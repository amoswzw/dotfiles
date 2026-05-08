#!/usr/bin/env bash
# Block commits that look like they contain secrets.
# Bypass with `git commit --no-verify` when you know what you're doing.

red ()    { printf "\033[0;31m%s\033[0m\n" "$1"; }
yellow () { printf "\033[0;33m%s\033[0m\n" "$1"; }

# Pattern label | extended regex
patterns=(
  "AWS Access Key|AKIA[0-9A-Z]{16}"
  "GitHub Token|gh[pousr]_[A-Za-z0-9]{36,}"
  "GitHub Fine-grained PAT|github_pat_[A-Za-z0-9_]{20,}"
  "Anthropic API Key|sk-ant-[A-Za-z0-9_-]{20,}"
  "OpenAI API Key|sk-[A-Za-z0-9]{20,}"
  "Slack Token|xox[baprs]-[A-Za-z0-9-]{10,}"
  "Google API Key|AIza[0-9A-Za-z_-]{35}"
  "Private Key Block|-----BEGIN ([A-Z]+ )?PRIVATE KEY-----"
  "JWT|eyJ[A-Za-z0-9_-]{10,}\\.eyJ[A-Za-z0-9_-]{10,}\\.[A-Za-z0-9_-]{10,}"
  "Generic Secret Assignment|(password|passwd|secret|api[_-]?key|access[_-]?token)[[:space:]]*[:=][[:space:]]*['\"][^'\"]{8,}['\"]"
)

violations=0
while IFS= read -r file; do
  [[ -z "$file" ]] && continue
  # Skip binary files (numstat shows `-` for added/removed counts).
  if git diff --cached --numstat -- "$file" | awk '{print $1}' | grep -q '^-$'; then
    continue
  fi
  # Only scan added lines (start with `+`, excluding the `+++` header).
  diff_added=$(git diff --cached -U0 -- "$file" | grep -E '^\+' | grep -vE '^\+\+\+ ')
  [[ -z "$diff_added" ]] && continue

  for entry in "${patterns[@]}"; do
    label="${entry%%|*}"
    regex="${entry#*|}"
    if echo "$diff_added" | grep -qiE -e "$regex"; then
      red "[secret-scan] $file: possible $label"
      echo "$diff_added" | grep -inE -e "$regex" | sed 's/^/    /'
      violations=$((violations + 1))
    fi
  done
done < <(git diff --cached --name-only --diff-filter=ACM)

if [[ $violations -gt 0 ]]; then
  echo
  yellow "Commit blocked: $violations potential secret(s) detected."
  yellow "If this is a false positive, re-run with: git commit --no-verify"
  exit 1
fi

exit 0
