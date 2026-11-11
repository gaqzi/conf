#!/usr/bin/env bash

input=$(cat)
# The dispatch skill paces long agent runs from this file; the status
# line is the only place Claude Code exposes the usage windows.
printf '%s' "$input" | jq -c '.rate_limits // {}' > "$HOME/.claude/usage.json" 2>/dev/null

used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
cwd=$(echo "$input" | jq -r '.cwd // empty')
model=$(echo "$input" | jq -r '.model.id // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
# Not `// empty` -- jq's // treats a literal false as empty, hiding thinking:off
thinking=$(echo "$input" | jq -r '.thinking.enabled | if . == null then "" else tostring end')

# Drop the vendor prefix; keep the rest verbatim (incl. suffixes like [1m])
model="${model#claude-}"

# think: the effort level actually in use, or off when thinking is disabled
think=""
if [ "$thinking" = "false" ]; then
  think="off"
elif [ -n "$effort" ]; then
  think="$effort"
elif [ "$thinking" = "true" ]; then
  think="on"
fi

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

if [ -n "$model" ]; then
  parts+=("model:$model")
fi

if [ -n "$think" ]; then
  parts+=("think:$think")
fi

# Account usage, not this session. Every part above describes this
# session; this block describes the whole account, so it is bracketed
# to read as one thing that belongs together and apart from the rest.
# Weekly only shows once it matters.
usage=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
usage_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
if [ -n "$usage" ] && [ -n "$usage_reset" ]; then
  block="usage:${usage%.*}% reset:$(date -r "$usage_reset" +%H%M)"
  if [ -n "$week" ] && [ "${week%.*}" -ge 80 ]; then
    block="$block week:${week%.*}%"
  fi
  parts+=("[$block]")
fi

printf '%s' "$(IFS='  '; echo "${parts[*]}")"
