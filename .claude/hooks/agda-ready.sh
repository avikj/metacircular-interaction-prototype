#!/bin/sh
# Claude SessionStart gate for the substrate.
#
# Why this exists (2026-08-15): a session audited a transmission, produced
# four hand proofs, and wrote in its honesty ledger "no Agda was added: agda
# is not installed in this session, so any module I wrote would ship
# unchecked". That is the toolchain's absence deciding what mathematics gets
# written. `formal/cubical/BUILD.md` had the install recipe the whole time and
# nothing ran it.
#
# CLAUDE.md: a checked term is the object itself. If the kernel is missing,
# every claim in the session silently drops one grade, and the drop is
# invisible unless something says so at the top of the session. This says so,
# and starts the install rather than only complaining.

cd "$(dirname "$0")/../.." 2>/dev/null || exit 0
[ -f formal/cubical/ensure-toolchain.sh ] || exit 0

if sh formal/cubical/ensure-toolchain.sh >/dev/null 2>&1; then
  printf 'Agda substrate ready: %s\n' \
    "$(PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH" agda --version 2>/dev/null | head -1)"
  printf 'Check the lane with: cd formal/cubical && agda Everything.agda\n'
  exit 0
fi

sh formal/cubical/ensure-toolchain.sh --install --background >/dev/null 2>&1

cat <<'EOF'
AGDA SUBSTRATE NOT READY.

The pinned toolchain (Agda 2.8.0 + cubical v0.9, see formal/cubical/BUILD.md)
is missing or incomplete in this container. An install has been started in the
background; watch it with:

    tail -f ~/.agda-install.log
    sh formal/cubical/ensure-toolchain.sh          # re-check; exit 0 when ready

Until it reports ready, DO NOT write a note whose ledger says the mathematics
went unchecked because the kernel was unavailable. That is not an acceptable
outcome in this repository — wait for the install, or run
`sh formal/cubical/ensure-toolchain.sh --install` in the foreground and block
on it. Hand proofs are fine as prose; what is banned is letting a missing
binary decide that a checkable statement stays unchecked.
EOF
exit 0
