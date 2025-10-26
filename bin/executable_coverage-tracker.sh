#!/bin/bash

# coverage-tracker.sh - Local coverage tracking for development
# Best practices applied

set -euo pipefail # Exit on error, undefined vars, pipe failures
IFS=$'\n\t'       # Secure Internal Field Separator

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(pwd)"
readonly PROJECT_NAME="$(basename "$PROJECT_ROOT")"
readonly TEMP_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/coverage-tracker"
readonly BASELINE_FILE="$TEMP_DIR/${PROJECT_NAME}-baseline.json"
readonly CURRENT_FILE="$TEMP_DIR/${PROJECT_NAME}-current.json"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}ℹ${NC} $*"; }
log_success() { echo -e "${GREEN}✓${NC} $*"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $*"; }
log_error() { echo -e "${RED}✗${NC} $*" >&2; }

# Validation functions
check_dependencies() {
  local missing_deps=()

  command -v node >/dev/null 2>&1 || missing_deps+=("node")
  command -v npm >/dev/null 2>&1 || missing_deps+=("npm")

  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    log_error "Missing dependencies: ${missing_deps[*]}"
    return 1
  fi
}

validate_project() {
  if [[ ! -f "package.json" ]]; then
    log_error "Not in a Node.js project directory (no package.json found)"
    return 1
  fi

  if ! grep -q '"test:coverage"' package.json; then
    log_error "No 'test:coverage' script found in package.json"
    return 1
  fi
}

# Core functions
setup_temp_dir() {
  mkdir -p "$TEMP_DIR"
}

run_coverage() {
  local output_file="$1"

  log_info "Running coverage analysis..."

  # Run coverage but don't fail on Jest exit code
  set +e # Temporarily disable exit on error
  npm run test:coverage >/dev/null 2>&1
  local npm_exit_code=$?
  set -e # Re-enable exit on error

  if [[ $npm_exit_code -ne 0 ]]; then
    log_warning "Jest returned exit code $npm_exit_code (possibly due to failing tests, but checking for coverage data...)"
  fi

  if [[ ! -f "./coverage/lcov.info" ]]; then
    log_error "Coverage data not found - Jest may have failed completely"
    return 1
  fi

  # Convert lcov to JSON summary (using the code from my previous response)
  node -e "
    const fs = require('fs');
    const lcovData = fs.readFileSync('./coverage/lcov.info', 'utf8');
    
    // Parse LCOV data
    const lines = lcovData.split('\n');
    let totalLines = 0, coveredLines = 0;
    let totalFunctions = 0, coveredFunctions = 0;
    let totalBranches = 0, coveredBranches = 0;
    let totalStatements = 0, coveredStatements = 0;
    
    for (const line of lines) {
      if (line.startsWith('LF:')) totalLines += parseInt(line.split(':')[1]);
      if (line.startsWith('LH:')) coveredLines += parseInt(line.split(':')[1]);
      if (line.startsWith('FNF:')) totalFunctions += parseInt(line.split(':')[1]);
      if (line.startsWith('FNH:')) coveredFunctions += parseInt(line.split(':')[1]);
      if (line.startsWith('BRF:')) totalBranches += parseInt(line.split(':')[1]);
      if (line.startsWith('BRH:')) coveredBranches += parseInt(line.split(':')[1]);
    }
    
    totalStatements = totalLines;
    coveredStatements = coveredLines;
    
    const summary = {
      total: {
        lines: {
          total: totalLines,
          covered: coveredLines,
          pct: totalLines ? (coveredLines / totalLines * 100) : 0
        },
        statements: {
          total: totalStatements,
          covered: coveredStatements,
          pct: totalStatements ? (coveredStatements / totalStatements * 100) : 0
        },
        functions: {
          total: totalFunctions,
          covered: coveredFunctions,
          pct: totalFunctions ? (coveredFunctions / totalFunctions * 100) : 0
        },
        branches: {
          total: totalBranches,
          covered: coveredBranches,
          pct: totalBranches ? (coveredBranches / totalBranches * 100) : 0
        }
      }
    };
    
    fs.writeFileSync('$output_file', JSON.stringify(summary, null, 2));
  "

  log_success "Coverage data extracted from LCOV"
}

calculate_diff() {
  local baseline_file="$1"
  local current_file="$2"

  # Use a separate Node.js script for complex calculations
  node -e "
    const fs = require('fs');
    
    try {
        const baseline = JSON.parse(fs.readFileSync('$baseline_file', 'utf8'));
        const current = JSON.parse(fs.readFileSync('$current_file', 'utf8'));
        
        const diff = {
            lines: current.total.lines.pct - baseline.total.lines.pct,
            statements: current.total.statements.pct - baseline.total.statements.pct,
            functions: current.total.functions.pct - baseline.total.functions.pct,
            branches: current.total.branches.pct - baseline.total.branches.pct
        };
        
        const average = (diff.lines + diff.statements + diff.functions + diff.branches) / 4;
        
        console.log('BASELINE_LINES=' + baseline.total.lines.pct.toFixed(2));
        console.log('CURRENT_LINES=' + current.total.lines.pct.toFixed(2));
        console.log('BASELINE_STATEMENTS=' + baseline.total.statements.pct.toFixed(2));
        console.log('CURRENT_STATEMENTS=' + current.total.statements.pct.toFixed(2));
        console.log('BASELINE_FUNCTIONS=' + baseline.total.functions.pct.toFixed(2));
        console.log('CURRENT_FUNCTIONS=' + current.total.functions.pct.toFixed(2));
        console.log('BASELINE_BRANCHES=' + baseline.total.branches.pct.toFixed(2));
        console.log('CURRENT_BRANCHES=' + current.total.branches.pct.toFixed(2));
        console.log('DIFF_LINES=' + diff.lines.toFixed(3));
        console.log('DIFF_STATEMENTS=' + diff.statements.toFixed(3));
        console.log('DIFF_FUNCTIONS=' + diff.functions.toFixed(3));
        console.log('DIFF_BRANCHES=' + diff.branches.toFixed(3));
        console.log('AVERAGE_DIFF=' + average.toFixed(3));
        console.log('TARGET_MET=' + (average >= 0.2 ? 'true' : 'false'));
        console.log('NEEDED=' + Math.max(0, 0.2 - average).toFixed(3));
        
    } catch (error) {
        console.error('Error calculating diff:', error.message);
        process.exit(1);
    }
    "
}

display_results() {
  local baseline_file="$1"
  local current_file="$2"

  # Get calculations and source them as variables
  local calc_output
  calc_output=$(calculate_diff "$baseline_file" "$current_file")

  # Source the output to get variables
  eval "$calc_output"

  echo
  log_info "Coverage Comparison:"
  printf "  Lines:      %s%% → %s%% (+%s%%)\n" "$BASELINE_LINES" "$CURRENT_LINES" "$DIFF_LINES"
  printf "  Statements: %s%% → %s%% (+%s%%)\n" "$BASELINE_STATEMENTS" "$CURRENT_STATEMENTS" "$DIFF_STATEMENTS"
  printf "  Functions:  %s%% → %s%% (+%s%%)\n" "$BASELINE_FUNCTIONS" "$CURRENT_FUNCTIONS" "$DIFF_FUNCTIONS"
  printf "  Branches:   %s%% → %s%% (+%s%%)\n" "$BASELINE_BRANCHES" "$CURRENT_BRANCHES" "$DIFF_BRANCHES"
  echo
  printf "🎯 Average: +%s%% (target: +0.200%%)\n" "$AVERAGE_DIFF"

  if [[ "$TARGET_MET" == "true" ]]; then
    log_success "Target achieved! 🎉"
    return 0
  else
    log_warning "Need +${NEEDED}% more coverage"
    return 1
  fi
}

# Command handlers
cmd_baseline() {
  log_info "Setting coverage baseline for $PROJECT_NAME"

  if ! run_coverage "$BASELINE_FILE"; then
    return 1
  fi

  log_success "Baseline set!"
}

cmd_check() {
  if [[ ! -f "$BASELINE_FILE" ]]; then
    log_warning "No baseline found. Setting current coverage as baseline..."
    cmd_baseline
    return $?
  fi

  if ! run_coverage "$CURRENT_FILE"; then
    return 1
  fi

  display_results "$BASELINE_FILE" "$CURRENT_FILE"
}

cmd_reset() {
  rm -f "$BASELINE_FILE" "$CURRENT_FILE"
  log_success "Baseline reset!"
}

cmd_help() {
  cat <<EOF
Coverage Tracker - Local development tool

Usage: $0 COMMAND

Commands:
  baseline, b    Set current coverage as baseline
  check, c       Check coverage against baseline  
  reset, r       Reset stored baseline
  help, h        Show this help

Examples:
  $0 baseline    # Set baseline at start of PR
  $0 check       # Check progress after adding tests
  $0 reset       # Start over
EOF
}

# Main execution
main() {
  # Setup
  check_dependencies || exit 1
  validate_project || exit 1
  setup_temp_dir

  # Handle commands
  case "${1:-help}" in
  "baseline" | "b") cmd_baseline ;;
  "check" | "c") cmd_check ;;
  "reset" | "r") cmd_reset ;;
  "help" | "h" | *) cmd_help ;;
  esac
}

# Only run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
