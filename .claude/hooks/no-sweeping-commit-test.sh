#!/bin/sh
# exercise the guard over the case file; no case string appears in this script
cd /Users/avikjain/Desktop/math2 || exit 1
CASES=/Users/avikjain/Desktop/math2/.claude/hooks/no-sweeping-commit.cases
fail=0; n=0
while IFS='	' read -r want cmd; do
  [ -z "$want" ] && continue
  n=$((n+1))
  printf '{"tool_input":{"command":"%s"}}' "$cmd" | sh .claude/hooks/no-sweeping-commit.sh >/dev/null 2>&1
  rc=$?
  if [ "$want" = BLOCK ]; then exp=2; else exp=0; fi
  if [ "$rc" != "$exp" ]; then
    fail=$((fail+1)); echo "WRONG want=$want rc=$rc : $cmd"
  fi
done < "$CASES"
echo "cases=$n wrong=$fail"

# the python guard, now wired into PreToolUse for the first time
printf '{"tool_input":{"command":"python3 x.py"}}' | sh .claude/hooks/no-python.sh >/dev/null 2>&1
echo "no-python rc on interpreter call = $? (expect 2)"
printf '{"tool_input":{"command":"runghc -imachine machine/AstadhyayiRun.hs"}}' | sh .claude/hooks/no-python.sh >/dev/null 2>&1
echo "no-python rc on runghc = $? (expect 0)"
printf '{"tool_input":{"command":"git status"}}' | sh .claude/hooks/no-python.sh >/dev/null 2>&1
echo "no-python rc on git status = $? (expect 0)"
