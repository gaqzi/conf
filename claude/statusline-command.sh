#!/usr/bin/env bash

input=$(cat)

used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
cwd=$(echo "$input" | jq -r '.cwd // empty')

branch=""
if [ -n "$cwd" ]; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
fi

# Compute display path: strip ~/code/ or ~/workspace/ prefix, keep project and below
display_path=""
if [ -n "$cwd" ]; then
  home="${HOME}"
  for base in "$home/code" "$home/workspace"; do
    if [[ "$cwd" == "$base/"* ]]; then
      display_path="${cwd#$base/}"
      break
    fi
  done
  if [ -z "$display_path" ]; then
    # Abbreviate home directory with ~
    if [[ "$cwd" == "$home"* ]]; then
      display_path="~${cwd#$home}"
    else
      display_path="$cwd"
    fi
  fi
fi

parts=()

if [ -n "$display_path" ]; then
  parts+=("dir:$display_path")
fi

if [ -n "$branch" ]; then
  parts+=("branch:$branch")
fi

if [ -n "$used" ]; then
  parts+=("ctx:${used}%")
fi

printf '%s' "$(IFS='  '; echo "${parts[*]}")"
