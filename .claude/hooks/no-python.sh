#!/bin/sh
# Claude PreToolUse gate. The Git and CI gates remain authoritative for files;
# this layer blocks direct Python execution before it starts.

payload=$(cat)
if printf '%s\n' "$payload" | grep -Eiq '(^|[;&|[:space:]"'"''])(python([0-9.]*)?|pip([0-9.]*)?|pytest)([;&|[:space:]"'"'']|$)'; then
  printf '%s\n' 'BLOCKED: Python is retired in this repository; use Agda or Lean.' >&2
  exit 2
fi

exit 0
