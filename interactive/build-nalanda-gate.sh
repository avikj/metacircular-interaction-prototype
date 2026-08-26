#!/bin/sh
# build-nalanda-gate.sh — build the executable this repository publishes.
#
#   sh interactive/build-nalanda-gate.sh
#
# Output is dist/nalanda-gate (gitignored).  NOTHING here is committed: the
# binary reaches users through a GitHub release, published by
# .github/workflows/release.yml, and the ./nalanda-gate launcher at the repo
# root fetches and verifies it.  A binary in the tree is a second copy of the
# source that nothing keeps in step.
#
# WHY STATIC.  A dynamically linked GHC binary wants libgmp.so.10 and
# libffi.so.8 at the versions the building machine had.  Static linking costs
# about 4 MB and removes the class.  It needs the .a files (libgmp-dev,
# libffi-dev, zlib1g-dev); if they are absent this falls back to a dynamic
# build and SAYS SO rather than publishing a binary whose portability is
# quietly different from the one claimed.
#
# WHAT THE BINARY NEEDS AT RUN TIME.  A directory with formal/cubical under
# it, found by walking up from its own location.  Agda is NOT required: only
# the `sadhana` operation reaches a kernel, and without agda that one turn
# comes back an environment fault while the other eighteen run normally.
# The four-turn self-check below includes a `sadhana` turn for exactly that
# reason and passes either way.
#
set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
DIST="${NALANDA_DIST:-$ROOT/dist}"
WORK="${TMPDIR:-/tmp}/nalanda-gate-build-$(id -u)"
BUNDLE=0

for arg in "$@"; do
  case "$arg" in
    --bundle) BUNDLE=1 ;;
    *) echo "usage: $0 [--bundle]" >&2; exit 2 ;;
  esac
done

say() { printf '%s\n' "$*"; }
die() { printf '%s\n' "$*" >&2; exit 1; }

command -v ghc >/dev/null 2>&1 || die \
"build-nalanda-gate: no ghc on PATH.  Any GHC with the boot libraries will do -- the
build has no dependency outside base, containers, time, directory, filepath
and process -- so \`apt-get install ghc\` is enough, as is ghcup."

mkdir -p "$WORK" "$DIST"

# ------------------------------------------------------------------ compile
#
# -O1, not run-yantra.sh's -O0.  That script optimises for the edit-run loop
# and rebuilds on every turn; this one runs when something is shipped, and the
# 30 s it costs is paid once.

LINK_KIND=static
say "==> compiling (ghc $(ghc --numeric-version), -O1, static)"
if ! ghc -O1 -i"$ROOT/interactive" \
        -outputdir "$WORK/obj" -o "$WORK/nalanda-gate" \
        -optl-static -optl-pthread \
        "$ROOT/interactive/Main.hs" >"$WORK/build.log" 2>&1; then
  say "!! the static link failed.  first errors:"
  grep -E "error|cannot find" -A4 "$WORK/build.log" | head -20 >&2
  say ""
  say "==> retrying dynamically"
  rm -rf "$WORK/obj"
  ghc -O1 -i"$ROOT/interactive" \
      -outputdir "$WORK/obj" -o "$WORK/nalanda-gate" \
      "$ROOT/interactive/Main.hs" >"$WORK/build.log" 2>&1 || {
    say "the yantra did not build.  first errors:"
    grep -E "error:" -A6 "$WORK/build.log" | head -30 >&2
    exit 1; }
  LINK_KIND=dynamic
  say "!! BUILT DYNAMIC.  This binary is NOT movable to a host with a"
  say "!! different libc/libgmp; it runs here and on machines like this one."
  say "!! Install libgmp-dev libffi-dev zlib1g-dev and rerun for the static"
  say "!! build, which is the one bin/ is supposed to hold."
fi

strip "$WORK/nalanda-gate" 2>/dev/null || true

# The doṣa-lekha organ is the same image under another name; Main.hs selects
# on argv[0].  A relative link, so the pair survives being moved together.
ln -sf nalanda-gate "$WORK/dosalekha"

# --------------------------------------------------------------- the checks
#
# A binary that was produced is not a binary that works, and the difference is
# one turn.  Both organs are exercised before either is installed into bin/,
# against a MATH_ROOT that is NOT this repository -- so what is checked is the
# copied-elsewhere case, which is the one bin/ exists for.

say "==> checking the build before installing it"
PROBE="$WORK/probe"
rm -rf "$PROBE"; mkdir -p "$PROBE/bin" "$PROBE/formal/cubical"
cp "$WORK/nalanda-gate" "$PROBE/bin/nalanda-gate"
ln -sf nalanda-gate "$PROBE/bin/dosalekha"
cp "$ROOT/formal/cubical/natural-machine.agda-lib" "$PROBE/formal/cubical/"

# What the probe tree holds BEFORE the machine is turned in it.  Compared
# again once the session is over; the check is at the end of this section.
#
# THE WHOLE TREE, not formal/ alone.  The cache this is watching for used
# to land at $MATH_ROOT/machine/.certcache -- a sibling of formal/, not a
# child of it -- so a snapshot narrowed to formal/ would have watched the
# one place the litter never appeared.  The state directory is deliberately
# OUTSIDE $PROBE for the same reason: it is where the run is SUPPOSED to
# write, and having it inside would make the comparison meaningless.
find "$PROBE" | sort > "$WORK/root-before"

# The session below is four turns, and each one checks something the others
# two cannot.  It is run with cwd set to NEITHER the binary's directory nor
# the repository -- if anything still resolves a path against the caller's
# working directory, this is where it shows -- and against a MATH_ROOT that
# is the probe tree, so what is exercised is the copied-elsewhere case, which
# is the only case bin/ exists for.
#
#   yantra.kriyah   the machine comes up, dispatches, and answers.
#   dosa.lekha      it FORKS THE OTHER ORGAN.  This is the turn that proves
#                   the argv[0] selection in Main.hs actually works: the
#                   record reaches disk only if the child image, entered
#                   under the name `dosalekha`, ran DefectRecord.main and
#                   not the server.  A build where that dispatch is wrong
#                   comes up, answers, and passes every other check here.
#   dosa.pramanya   the chain is recomputed from genesis over what the run
#                   just wrote, from inside the session.
mkdir -p "$WORK/state"
( cd "$WORK" && printf '%s\n' \
    '{"kriya":"yantra.kriyah"}' \
    '{"kriya":"dosa.lekha","angani":{"kriya":"build-yantra self-check","hetu":"this record exists to exercise the organ pair at build time and is about no mathematics","nasta":["nothing: the record is a probe and destroys no distinction"]}}' \
    '{"kriya":"dosa.pramanya"}' \
    '{"kriya":"sadhana","angani":{"vama":"(+ 0 x)","daksina":"x"}}' \
  | DOSA_LEKHA="$WORK/state/session.lekha" YANTRA_LEKHA="$WORK/state/transcript.jsonl" \
    DOSA_BIN="$PROBE/bin/dosalekha" \
    "$PROBE/bin/nalanda-gate" --wire \
    >"$WORK/out.jsonl" 2>"$WORK/out.err" ) || die \
  "build-nalanda-gate: the binary exited non-zero on a four-turn session.
$(cat "$WORK/out.err")"

[ "$(wc -l <"$WORK/out.jsonl")" -eq 4 ] || die \
  "build-nalanda-gate: asked for four turns, got $(wc -l <"$WORK/out.jsonl") answers."

sed -n 1p "$WORK/out.jsonl" | grep -q '"uttara":"samkramana"' || die \
  "build-nalanda-gate: the machine answered yantra.kriyah, and the answer was not a
saṃkramaṇa.  what it said:
$(sed -n 1p "$WORK/out.jsonl" | head -c 600)"

# The defect turn must come back a doṣa-lekha.  It is the one answer in this
# script that is SUPPOSED to be the refusal: `dosa.lekha` writes a defect, so
# a saṃkramaṇa here would mean the machine transported something instead of
# recording it.
sed -n 2p "$WORK/out.jsonl" | grep -q '"uttara":"dosalekha"' || die \
  "build-nalanda-gate: writing a defect did not come back as a doṣa-lekha.
$(sed -n 2p "$WORK/out.jsonl" | head -c 600)"

sed -n 3p "$WORK/out.jsonl" | grep -q '"uttara":"samkramana"' || die \
  "build-nalanda-gate: the doṣa-lekha chain did not verify from inside the session.
$(sed -n 3p "$WORK/out.jsonl" | head -c 600)"

# The record actually reached disk, and the standalone organ -- the same image
# entered under the other name, this time from the outside -- agrees.
LEKHA="$WORK/state/session.lekha"
[ -s "$LEKHA" ] || die \
  "build-nalanda-gate: the session reported filing a defect and $LEKHA is empty, so
the forked organ did not write.  The two organs are one image selecting on
argv[0] (Main.hs); a symlink that did not survive the build would look
exactly like this."

DOSA_LEKHA="$LEKHA" "$PROBE/bin/dosalekha" verify >"$WORK/verify.out" 2>&1 \
  || die "build-nalanda-gate: the doṣa-lekha organ did not verify the chain it just
wrote.
$(cat "$WORK/verify.out")"

# NOTHING THE RUN WROTE IS IN THE TREE IT WAS POINTED AT.
#
# MATH_ROOT is a checkout, and a run of the kernel is not an edit to it.
# Two things used to land there anyway: run-yantra.sh's per-run session log,
# written into interactive/ and deleted only by the START of the next run;
# and the gate's certificate cache, which joined `machine/.certcache` to
# MATH_ROOT and so created the cache AND a `machine/` to hold it.  Neither
# was ever visible, because .gitignore named both -- and an ignore rule does
# not delete a file, it deletes the report of the file.
#
# The `sadhana` turn above is in this session FOR THIS CHECK.  It is the one
# operation that reaches the kernel, so it is the only one that can write a
# cache entry.  Without agda it comes back an environment fault and the
# check still passes; on a machine that has agda it is the real thing.
find "$PROBE" | sort > "$WORK/root-after"
if ! diff -q "$WORK/root-before" "$WORK/root-after" >/dev/null; then
  say "!! the run left files in the tree it was pointed at:"
  diff "$WORK/root-before" "$WORK/root-after" | grep '^>' >&2
  die "build-nalanda-gate: turning the machine wrote into MATH_ROOT.  A run is not
an edit to the repository it is pointed at, and whatever wrote there needs a
path outside it -- ProofGate certCacheDir, run-yantra.sh LEKHA."
fi

say "    four turns; forked the other organ; chain verified inside and out"
say "    MATH_ROOT untouched by the run"

# ------------------------------------------------------------------ publish
#
# dist/, not bin/.  Gitignored, rebuilt by CI on every tag, uploaded to the
# release.  SHA256SUMS is what ./nalanda-gate verifies a download against.

install -m 755 "$WORK/nalanda-gate" "$DIST/nalanda-gate"
ln -sf nalanda-gate "$DIST/dosalekha"

SHA=$(sha256sum "$DIST/nalanda-gate" | cut -d' ' -f1)
COMMIT=$(cd "$ROOT" && git rev-parse HEAD 2>/dev/null || echo unknown)
DIRTY=$(cd "$ROOT" && git status --porcelain -- interactive/ 2>/dev/null | head -1)

printf '%s  nalanda-gate\n' "$SHA" > "$DIST/SHA256SUMS"

cat > "$DIST/PROVENANCE.txt" <<PROV
nalanda-gate — what it was built from.

  built by     interactive/build-nalanda-gate.sh
  from source  interactive/*.hs, entry interactive/Main.hs
  at commit    $COMMIT
  linkage      $LINK_KIND
  compiler     ghc $(ghc --numeric-version)
  sha256       $SHA

${DIRTY:+The interactive/ tree had uncommitted changes at build time, so the
source above is not exact.}

dosalekha is a symlink to nalanda-gate, not a second program.  The image
carries both organs and selects on the name it was invoked under; Main.hs
says why, and what that does and does not change about the interface between
them.
PROV

cat > "$DIST/USAGE.txt" <<'USAGE'
nalanda-gate — THIS IS A TOOL.  RUN IT.  DO NOT BUILD IT.

The gate is the entry: anyone may approach it, and what passes through it is
what can show itself to be true.  This program is that boundary made
executable — every answer it gives carries the witness that earns it, and
what it cannot transport it refuses in writing rather than guessing.

You have been handed a program.  There is nothing here to compile, nothing
to install, no manifest to resolve and no source you need to read.  If you
have started looking for a Makefile, a package file, or the language it was
written in, you have left the task you were given.  Turning this machine IS
the task.

--------------------------------------------------------------- how to run it

  ./nalanda-gate --wire

reads ONE JSON OBJECT PER LINE on stdin and writes ONE JSON OBJECT PER LINE
on stdout.  It stays up until stdin closes; a session is a pipe, not a series
of commands.  Anything it says about itself, its state, or its failures comes
back on that wire.  stderr carries the banner and the witness check only.

  ./nalanda-gate

with no arguments runs a scripted session against itself and prints it.  Use
it once to see the machine work; it takes no input.

------------------------------------------------------------- what it needs

  NOTHING TO INSTALL.  Clone the repository and run ./nalanda-gate.  The
  launcher fetches the published binary, verifies it against SHA256SUMS, and
  runs it.

  Agda is OPTIONAL.  Only the `sadhana` operation reaches a kernel; without
  agda that one turn returns an environment fault and the other eighteen
  operations are unaffected.  Install agda 2.8.0 with the cubical library
  registered as `cubical` if you want `sadhana` to certify.

  It writes its transcript and its defect log under
  $XDG_STATE_HOME/nalanda-gate (or ~/.local/state/nalanda-gate), which the
  launcher points it at; $YANTRA_LEKHA and $DOSA_LEKHA override them.  It
  writes nothing into the repository - the build checks this.

--------------------------------------------------------------- one exchange

  $ printf '%s\n' '{"kriya":"kuttaka","angani":{"a":137,"b":60,"c":1}}' \
      | ./nalanda-gate --wire

  {"uttara":"samkramana","kriya":"kuttaka",
   "nirnaya":{"sthana":"syad-asti", ...},
   "pramanya":{"marga":"ganita","saksin":"137·53 - 1 = 0 (mod 60), computed in Z"},
   "vahita":{"valli":[2,3,1,1,8],"bezout":{"x":-7,"y":16,"gcd":1},"x":53, ...},
   "vyaya":["the other solutions are given as a class, not enumerated", ...]}

  (one line in reality; broken here to be read)

  Ask it what else it can do:  {"kriya":"yantra.kriyah"}
USAGE

say ""
say "==> published to $DIST"
say "    nalanda-gate   $LINK_KIND, sha256 $SHA"
say "    SHA256SUMS PROVENANCE.txt USAGE.txt"
say "    nothing in dist/ is committed; the release carries it"
