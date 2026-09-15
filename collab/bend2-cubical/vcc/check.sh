#!/usr/bin/env bash
# Check every vcc/*.bend (imports resolve in port/), run each main on HVM4.
# Perturb_mustfail must contain rejections. Usage: ./check.sh [bend-binary] [hvm-binary]
set -u
export LC_ALL=C.utf8 LANG=C.utf8
BEND="${1:-$(cat /tmp/BENDBIN_F 2>/dev/null || cat /tmp/BENDBIN 2>/dev/null || echo bend)}"
HVM="${2:-/tmp/HVM4/src/hvm}"
here="$(cd "$(dirname "$0")" && pwd)"; cd "$here/../port" || exit 1
bad=0
for f in "$here"/*.bend; do
  nm=$(basename "$f" .bend)
  out=$(timeout 600 "$BEND" "$f" 2>&1); ok=$(printf '%s' "$out" | grep -c "✓"); ko=$(printf '%s' "$out" | grep -c "✗")
  if [ "$nm" = "Perturb_mustfail" ]; then
    [ "$ko" -ge 1 ] && echo "MUSTFAIL $nm rejected=$ko ok=$ok" || { echo "MUSTFAIL-PASSED $nm"; bad=$((bad+1)); }
    continue
  fi
  { [ "$ko" -eq 0 ] && [ "$ok" -ge 1 ]; } && echo "OK $nm ok=$ok" || { echo "FAIL $nm ok=$ok ko=$ko"; bad=$((bad+1)); continue; }
  if [ -x "$HVM" ]; then
    tmp=$(mktemp -d); "$BEND" "$f" --to-hvm4-full > "$tmp/m.hvm4" 2>"$tmp/err" || { echo "  emit failed"; bad=$((bad+1)); continue; }
    res=$(timeout 600 "$HVM" "$tmp/m.hvm4" -s 2>&1); echo "  hvm4: $(printf '%s' "$res" | head -1 | cut -c1-120)"; echo "  $(printf '%s' "$res" | grep Itrs)"
    rm -rf "$tmp"
  fi
done
echo "bad=$bad"; [ "$bad" -eq 0 ]
