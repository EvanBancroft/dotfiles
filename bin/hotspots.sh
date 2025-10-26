#!/bin/zsh

# git_hotspots.sh - Find frequently modified files in git repository
# Usage: ./git_hotspots.sh

echo "By Commits:"
git log --since="12 months ago" --pretty=format: --name-only | 
  grep -v "__test" | 
  grep -v "^$" | 
  sort | 
  uniq -c | 
  sort -rg | 
  sed 's/^[ ]*//' | 
  awk '{print "     " $0}' | 
  head -15

echo -e "\nBy Inserts and Deletions:"
git log --since="12 months ago" --pretty=format: --stat-width=1000 --stat | 
  grep -v "^$" | 
  grep -v "__test" | 
  grep -v "package-lock.json" | 
  grep -v "{" | 
  grep " | " | 
  awk '{print $1, $3}' | 
  awk '{sum[$1] += $2} END {for (file in sum) print "     " sum[file], file}' | 
  sort -rn | 
  head -15
