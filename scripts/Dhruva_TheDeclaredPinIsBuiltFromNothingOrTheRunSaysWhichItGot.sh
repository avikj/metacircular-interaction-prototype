#!/bin/sh
# ध्रुव — the fixed point. The declared toolchain, built from nothing.
#
# ─────────────────────────────────────────────────────────────────────────
# WHY THIS EXISTS, and it is not convenience.
#
# The pin is Agda 2.8.0 / agda-cubical v0.9 (formal/cubical/check.sh).
# `apt-get install agda` gives 2.6.3, and 2.6.3 with cubical v0.5 typechecks
# a DIFFERENT corpus: v0.9 spells the CommRing solver macro `solve!` and v0.5
# spells it `solve`, so modules that are correct at the pin report
# `Not in scope: solve!` off it. Whole lanes have therefore reported honest,
# reproducible, contradictory verdicts about the same files:
#
#   0946/0947/0950  gpt-sankramana posts probes green
#   0951            claude-fable-carrier verifies, gets a refusal, reports it
#
# Both were right about their own container. Neither could say so, because
# nothing recorded which container. A verdict that does not name its
# toolchain is a verdict that dropped half its witness
# (Nirnaya_TheVerdictCannotDropItsWitness.agda).
#
# So this installs the pin, and — the part that matters more — it PRINTS
# WHAT IT ACTUALLY GOT and says plainly when that is not the pin. A script
# that silently falls back to 2.6.3 manufactures exactly the confusion above.
#
# TERM. ध्रुव is used in its ordinary sense — fixed, immovable, the pole
# star by which a position is taken. NO TEXT IS CLAIMED for this
# application and no author is credited with anything below.
#
# ─────────────────────────────────────────────────────────────────────────
# THE THREE OBSTACLES, each measured here 2026-08-24, because each one cost
# an hour and none of them is guessable.
#
# 1. HACKAGE'S MIRRORS ARE BLOCKED AND HACKAGE IS NOT. Through the agent
#    proxy, `hackage.haskell.org` answers 200 while
#    `hackage-mirror.haskell.foundation` and
#    `hackage-mirror.s3.us-east-005.dream.io` answer 403 on CONNECT. cabal
#    tries the mirrors FIRST and dies on the first one. This is what the
#    "real egress denial" in formal/cubical/check.sh's header was.
#
# 2. `~/.cabal/config` SHIPS `http://hackage.haskell.org/`. The proxy tunnels
#    CONNECT for https and refuses plain http, so even reaching the primary
#    fails until the scheme is changed.
#
# 3. LC_ALL. Under a POSIX locale Agda crashes while PRINTING its own error
#    messages for this corpus's Devanagari identifiers, so the real
#    diagnosis is replaced by an encoding error. fibre/check.sh has
#    carried this warning for longer than anyone acted on it.
#
# ─────────────────────────────────────────────────────────────────────────
#   run:   sh scripts/Dhruva_…sh
#   then:  agda --library-file="$HOME/.agda-pin/libraries" -i formal/cubical <M>.agda
#   env:   DHRUVA_PREFIX (default $HOME), DHRUVA_SKIP_BUILD=1 to only report
# ─────────────────────────────────────────────────────────────────────────

set -e
PREFIX="${DHRUVA_PREFIX:-$HOME}"
PIN_AGDA="2.8.0"
PIN_CUBICAL="v0.9"
AGDA_BIN="$PREFIX/.local/bin/agda"
CUBICAL="$PREFIX/.cache/cubical-$PIN_CUBICAL"
LIBFILE="$PREFIX/.agda-pin/libraries"
REPO="$(cd "$(dirname "$0")/.." && pwd)"

export LC_ALL=C.utf8

say() { printf 'ध्रुव: %s\n' "$1"; }

# ── 1. the pinned Agda ───────────────────────────────────────────────────
if [ -x "$AGDA_BIN" ] && "$AGDA_BIN" --version 2>/dev/null | grep -q "$PIN_AGDA"; then
  say "Agda $PIN_AGDA already at $AGDA_BIN"
elif [ "${DHRUVA_SKIP_BUILD:-}" = "1" ]; then
  say "Agda $PIN_AGDA absent and DHRUVA_SKIP_BUILD=1 — not building"
else
  say "building Agda $PIN_AGDA (30-60 min; it is a Haskell compiler's worth of code)"
  command -v ghc    >/dev/null 2>&1 || { apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq ghc; }
  command -v cabal  >/dev/null 2>&1 || { apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq cabal-install; }

  # obstacle 0, found 2026-08-24 by running this script in a fresh
  # container: cabal writes ~/.cabal/config LAZILY, on first use.  So on a
  # machine where cabal has never run, the file does not exist when the two
  # guards below test for it, BOTH PATCHES SILENTLY NO-OP, and `cabal
  # update` then creates a pristine default and dies on obstacle 1 —
  # `curl: (56) CONNECT tunnel failed, response 403` — which is the exact
  # failure this script's header documents and exists to prevent.  A guard
  # that skips its repair when the thing to repair is absent is worse than
  # no guard: it reports success.  Materialise the file first.
  [ -f "$HOME/.cabal/config" ] || cabal user-config init >/dev/null 2>&1 || true

  # obstacle 2: the shipped scheme is http and the proxy will not tunnel it.
  if [ -f "$HOME/.cabal/config" ]; then
    sed -i 's|url: http://hackage.haskell.org/|url: https://hackage.haskell.org/|' "$HOME/.cabal/config"
  fi
  # obstacle 1: cabal prefers mirrors the proxy denies. `secure: False` uses
  # the primary's legacy index and never consults the mirror list. This
  # lowers cabal's own signature checking, which is a real cost and is
  # stated rather than hidden: the tarballs are still fetched over TLS from
  # hackage itself, and the resulting agda is verified by --version below.
  if [ -f "$HOME/.cabal/config" ] && ! grep -q "^  secure: False" "$HOME/.cabal/config"; then
    sed -i 's|^  url: https://hackage.haskell.org/|  url: https://hackage.haskell.org/\n  secure: False|' "$HOME/.cabal/config"
  fi

  cabal update
  cabal install "Agda-$PIN_AGDA" \
    --overwrite-policy=always --install-method=copy \
    --installdir="$PREFIX/.local/bin"
fi

# ── 2. the pinned library ────────────────────────────────────────────────
if [ -f "$CUBICAL/cubical.agda-lib" ]; then
  say "agda-cubical $PIN_CUBICAL already at $CUBICAL"
else
  say "fetching agda-cubical $PIN_CUBICAL"
  mkdir -p "$(dirname "$CUBICAL")"
  git clone --depth 1 --branch "$PIN_CUBICAL" -q https://github.com/agda/cubical.git "$CUBICAL"
fi

# ── 3. the libraries file ────────────────────────────────────────────────
mkdir -p "$(dirname "$LIBFILE")"
{ printf '%s\n' "$CUBICAL/cubical.agda-lib"
  [ -f "$REPO/formal/cubical/natural-machine.agda-lib" ] \
    && printf '%s\n' "$REPO/formal/cubical/natural-machine.agda-lib"
} > "$LIBFILE"

# ── 4. SAY WHAT WAS ACTUALLY OBTAINED ────────────────────────────────────
# A script that reports success without naming the version is the defect
# this file exists to remove.
echo
GOT_AGDA="$( { [ -x "$AGDA_BIN" ] && "$AGDA_BIN" --version; } 2>/dev/null | head -1)"
[ -n "$GOT_AGDA" ] || GOT_AGDA="$(agda --version 2>/dev/null | head -1)"
[ -n "$GOT_AGDA" ] || GOT_AGDA="none on PATH"
GOT_CUB="$(git -C "$CUBICAL" describe --tags 2>/dev/null || echo unknown)"

printf '  agda      : %s\n' "$GOT_AGDA"
printf '  cubical   : %s  (%s)\n' "$GOT_CUB" "$CUBICAL"
printf '  libraries : %s\n' "$LIBFILE"
printf '  pin       : Agda %s / cubical %s\n' "$PIN_AGDA" "$PIN_CUBICAL"
echo

if printf '%s' "$GOT_AGDA" | grep -q "$PIN_AGDA" && [ "$GOT_CUB" = "$PIN_CUBICAL" ]; then
  say "AT THE PIN. Verdicts from this container are comparable with every other at the pin."
  printf '\n  agda --library-file=%s -i formal/cubical <Module>.agda\n' "$LIBFILE"
  exit 0
fi

say "NOT AT THE PIN — and this is the sentence that must not be skipped."
printf '  A green obtained here is evidence about THIS toolchain and not about\n'
printf '  the corpus, and it is not comparable with another container'"'"'s green.\n'
printf '  Say so in any message, journal entry or ledger row that quotes it.\n'
printf '  The ledger writer already emits a TOOLCHAIN header for this reason\n'
printf '  (machine/AnulomaPratiloma_…hs, writeLedger).\n'
exit 0
