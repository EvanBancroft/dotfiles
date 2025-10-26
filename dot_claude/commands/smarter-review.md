# Smart Local Changes Review

CRITICAL: This command performs comprehensive code review with context-aware analysis.

**Review Scope**: $ARGUMENTS (default: all local changes)

## RULE 0 (MOST IMPORTANT): Parallel Information Gathering

You have the capability to call multiple tools in a single response. When multiple independent pieces of information are requested, batch your tool calls together for optimal performance. ALWAYS run the following bash commands in parallel:
- `git status` to see all file states
- `git diff` (or appropriate variant based on scope) to see changes  
- `git log --oneline -5` to understand recent commit context

<!-- Pattern Attribution:
- **Emphasis Hierarchy**: "RULE 0 (MOST IMPORTANT)" creates absolute priority (prompt-engineering.md:309)
- **Parallel Information Gathering**: Batching commands for efficiency (prompt-engineering.md:120)
- **Behavioral Impact**: Prevents serial command execution, reduces latency
-->

## AUTOMATED ANALYSIS WORKFLOW

### Step 1: Change Detection and Scope Analysis
<change_analysis>
Determine what type of changes we're reviewing based on $ARGUMENTS:
- **No arguments**: Review all uncommitted changes (`git diff HEAD`)
- **"staged"**: Review only staged changes (`git diff --cached`)  
- **"commit:\<hash\>"**: Review specific commit (`git show <hash>`)
- **File path**: Review specific file changes (`git diff HEAD -- <path>`)
- **"last"**: Review last commit (`git show HEAD`)
- **Branch name**: Review branch changes (`git diff main...<branch>`)
</change_analysis>

<!-- Pattern Attribution:
- **Structured Thinking Enforcement**: <change_analysis> tags force systematic analysis (prompt-engineering.md:407-413)  
- **Progressive Disclosure**: Start with detection, build complexity (prompt-engineering.md:384)
- **Behavioral Impact**: Ensures comprehensive scope understanding before review begins
-->

### Step 2: Context Gathering (REQUIRED)

ALWAYS execute these information gathering steps:

1. **Repository State**: Run `git status` to understand working directory state
2. **Change Diff**: Display relevant diffs based on detected scope  
3. **File Classification**: Identify file types and technologies involved
4. **Recent History**: Check recent commits for context and patterns

NEVER skip context gathering - incomplete context leads to poor review quality.

<!-- Pattern Attribution:
- **Absolute Rules**: "ALWAYS execute" and "NEVER skip" create clear boundaries (prompt-engineering.md:327-336)
- **Consequence Framing**: "incomplete context leads to poor review quality" (prompt-engineering.md:400)
- **Behavioral Impact**: Prevents rushing to conclusions without proper context
-->

### Step 3: File-Type Specific Review Criteria

Execute review based on file types identified. MATCH your review focus to the actual files changed:

**Frontend Files** (.js, .jsx, .ts, .tsx, .vue, .css, .scss):
- UI/UX impact and user experience
- Accessibility compliance (ARIA, semantic HTML)  
- Performance implications (bundle size, rendering)
- Cross-browser compatibility concerns

**Backend Files** (.py, .rb, .php, .go, .java, server configs):
- Business logic correctness and edge cases
- Security vulnerabilities (injection, authorization)
- Data handling and validation
- API contract compatibility

**Database Files** (.sql, migrations, schema):
- Migration safety (reversibility, data loss risk)
- Index efficiency and query performance  
- Data integrity constraints
- Production deployment considerations

**Configuration Files** (.env, .config, .yml, .json):
- Security exposure (secrets, keys, permissions)
- Environment consistency across deployments
- Service configuration correctness
- Breaking changes to dependent services

**Test Files** (.test.js, .spec.py, _test.go):
- Test coverage completeness
- Edge case handling
- Test quality and maintainability  
- Integration test scenarios

**Documentation Files** (.md, .rst, .txt):
- Technical accuracy and completeness
- Clarity and comprehensiveness
- Code example validity
- Outdated information identification

<!-- Pattern Attribution:
- **Category-Based Guidance**: Grouping by file types with specific criteria (prompt-engineering.md:353-356)
- **Context-Aware Instructions**: Adapt behavior based on actual files found (prompt-engineering.md:192-222)
- **Behavioral Impact**: Provides targeted, relevant review criteria instead of generic feedback
-->

### Step 4: Risk Assessment and Impact Analysis

<risk_analysis>
For each changed file, evaluate:

**CRITICAL RISKS** (Immediate attention required):
- Security vulnerabilities or exposed secrets
- Breaking API changes affecting clients
- Database operations with data loss potential
- Performance regressions in critical paths

**HIGH RISKS** (Review carefully):
- Logic changes in core business functions
- Configuration changes affecting multiple environments
- Dependencies that may introduce conflicts
- Test removals reducing coverage

**MEDIUM RISKS** (Monitor):
- UI changes affecting user workflows
- Code style deviations from project standards
- Documentation gaps for new features
- Minor performance optimizations

**LOW RISKS** (Informational):
- Cosmetic changes and formatting
- Comment updates and clarifications
- Development tooling adjustments
- Non-critical dependency updates
</risk_analysis>

<!-- Pattern Attribution:
- **Structured Thinking Enforcement**: <risk_analysis> tags mandate systematic evaluation (prompt-engineering.md:407-413)
- **Emphasis Hierarchy**: CRITICAL/HIGH/MEDIUM/LOW priority system (prompt-engineering.md:302-309)  
- **Behavioral Impact**: Forces prioritization of review findings by actual risk level
-->

## REVIEW OUTPUT FORMAT (REQUIRED)

Your review MUST follow this exact structure. DO NOT deviate from this format:

### Executive Summary
**[1-2 sentences]** High-level overview of changes and overall assessment.

### Change Analysis  
**[File-by-file breakdown]** Detailed analysis for each modified file with specific findings.

### Risk Assessment
**[Categorized by severity]** Issues found organized by CRITICAL/HIGH/MEDIUM/LOW risk levels.

### Action Items
**[Specific, actionable tasks]** Concrete steps required before committing/merging:
- [ ] Specific task 1
- [ ] Specific task 2  
- [ ] Specific task 3

### Quality Score: [X/10]
**[Justification]** Brief explanation of score based on code quality, risk level, and completeness.

<!-- Pattern Attribution:
- **Output Format Strictness**: "MUST follow this exact structure" with specific formatting (prompt-engineering.md:419-421)
- **Structured Templates**: Consistent section organization for predictable output (prompt-engineering.md:148)
- **Behavioral Impact**: Ensures consistent, parseable review format for users
-->

## CONTEXTUAL RECOMMENDATIONS ENGINE

AUTOMATICALLY identify and suggest:

1. **Related Files**: Files that might need updates based on changes made
2. **Breaking Changes**: Modifications that could break dependent code
3. **Testing Scenarios**: Additional test cases recommended for changes  
4. **Integration Points**: Services/APIs that need attention due to changes

Use your understanding of the codebase architecture and common patterns to provide intelligent suggestions beyond just the changed files.

<!-- Pattern Attribution:
- **Proactive Guidance**: "AUTOMATICALLY identify" encourages anticipatory analysis (prompt-engineering.md:313-325)
- **Context-Aware Instructions**: Leverage codebase understanding for suggestions (prompt-engineering.md:67)
- **Behavioral Impact**: Transforms reactive review into proactive risk identification
-->

## ERROR RECOVERY INSTRUCTIONS

If you encounter any of these issues during review:

**Git Command Failures**: Retry with different git options or ask for clarification of scope
**Large Diffs**: Focus on changed lines with context, don't attempt to review entire files  
**Unknown File Types**: Apply general code quality principles and note the limitation
**Missing Context**: Explicitly state what information is needed for complete review

NEVER provide partial reviews without noting limitations. Transparency about constraints is required.

<!-- Pattern Attribution:
- **Error Recovery Instructions**: Explicit handling of common failure modes (prompt-engineering.md:259-279)
- **Absolute Rules**: "NEVER provide partial reviews" sets clear boundary (prompt-engineering.md:327-336)
- **Behavioral Impact**: Prevents incomplete analysis and manages user expectations
-->

## REWARDS AND BEHAVIORAL GUIDELINES

**CRITICAL SUCCESS FACTORS**:
- Complete context gathering before analysis (+$1000)
- Risk-appropriate depth of review for file types (+$500)
- Actionable, specific recommendations (+$500)  
- Following exact output format (+$300)

**PENALTIES**:
- Skipping context gathering steps (-$1000)
- Generic recommendations without specificity (-$500)
- Missing risk categorization (-$300)
- Deviating from required output format (-$200)

Being thorough and systematic is more valuable than being fast.

<!-- Pattern Attribution:
- **Reward/Penalty System**: Monetary values create behavioral incentives (prompt-engineering.md:283-299)
- **Clear Priorities**: "more valuable than being fast" establishes value hierarchy (prompt-engineering.md:294-296)
- **Behavioral Impact**: Shapes decision-making toward quality over speed
-->

---

**IMPORTANT**: Start your analysis by running the parallel git commands to gather context, then proceed through each step systematically. Your review quality directly impacts code safety and team productivity.

