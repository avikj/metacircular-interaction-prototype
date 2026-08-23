#!/bin/bash
# स्थापन — sthāpana, "establishing, installation" (ordinary Sanskrit; no
# source claimed).  A SessionStart hook for Claude Code on the web: a fresh
# remote container arrives with no Agda kernel, no cubical substrate, and no
# built नाडी — so every session's first hour was re-deriving this by hand
# (measured 2026-08-23: apt + clone + ghc build ≈ 6 minutes of agent time,
# plus the sessions that concluded "no kernel here" and never talked to the
# machine at all).  This hook is PROVISIONING, not a gate: it installs
# instruments and never blocks or judges work.  Idempotent; every step
# skips itself when its product already exists, so the cached container
# passes through in seconds.
#
# What it establishes:
#   1. the kernel      — Agda (apt; 2.6.3 on current images) + GHC
#   2. the substrate   — cubical v0.5 at /opt/cubical, registered as the
#                        library `cubical` that formal/cubical/*.agda-lib
#                        depends on.  NOTE the pin skew, stated not hidden:
#                        the repo's reference pin is Agda 2.8.0 + cubical-0.9
#                        (scripts/Pariksa_UnivalentAudit.sh); apt serves
#                        2.6.3, which pairs with v0.5.  Modules written
#                        against v0.9-only names may refuse under this
#                        container; the refusal will name them.
#   3. the conduit     — नाडी built to /opt/nadi from machine/Nadi.hs, so an
#                        agent's first act can be `/opt/nadi REQ RESP` and a
#                        warm conversation, not a toolchain excavation.
set -euo pipefail

# Web sessions only; a local checkout owns its own toolchain.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# 1. kernel + compiler (and the Haskell libs Nadi links against)
if ! command -v agda >/dev/null 2>&1 || ! command -v ghc >/dev/null 2>&1; then
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update -qq || apt-get update -qq
  sudo apt-get install -y -qq agda ghc libghc-aeson-dev \
    || apt-get install -y -qq agda ghc libghc-aeson-dev
fi

# 2. substrate: cubical v0.5, registered under the name the repo depends on
if [ ! -f /opt/cubical/cubical.agda-lib ]; then
  sudo git clone --depth 1 --branch v0.5 https://github.com/agda/cubical.git /opt/cubical \
    || git clone --depth 1 --branch v0.5 https://github.com/agda/cubical.git /opt/cubical
  sudo sed -i 's/^name: cubical-0.5/name: cubical/; s/ -WnoUnsupportedIndexedMatch//' \
    /opt/cubical/cubical.agda-lib \
    || sed -i 's/^name: cubical-0.5/name: cubical/; s/ -WnoUnsupportedIndexedMatch//' \
      /opt/cubical/cubical.agda-lib
fi
mkdir -p ~/.agda
grep -qxF '/opt/cubical/cubical.agda-lib' ~/.agda/libraries 2>/dev/null \
  || echo '/opt/cubical/cubical.agda-lib' >> ~/.agda/libraries

# 3. the conduit, built once into the cached layer
if [ ! -x /opt/nadi ]; then
  ( cd "$CLAUDE_PROJECT_DIR/formal/cubical" \
    && ghc -O2 -i../../machine ../../machine/Nadi.hs -o /tmp/nadi-build >/dev/null )
  sudo mv /tmp/nadi-build /opt/nadi 2>/dev/null || mv /tmp/nadi-build /opt/nadi
fi

# Pre-warm the Prelude so the first real load is not a cold Foundations
# climb; bounded, and a no-op once the .agdai exists in the cached layer.
if [ ! -f /opt/cubical/Cubical/Foundations/Prelude.agdai ] \
   && [ ! -d /opt/cubical/_build ]; then
  ( cd /opt/cubical && timeout 240 agda Cubical/Foundations/Prelude.agda >/dev/null 2>&1 ) || true
fi

echo "sthāpana: agda $(agda --version | head -1 | awk '{print $3}'), cubical v0.5 at /opt/cubical, नाडी at /opt/nadi"
