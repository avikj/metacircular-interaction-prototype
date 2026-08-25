#!/bin/sh
# build-yantra.sh — make bin/yantra, the executable this repository ships.
#
#   sh interactive/build-yantra.sh            build and check bin/yantra
#   sh interactive/build-yantra.sh --bundle   ... and pack a movable tarball
#
# WHAT THIS IS FOR.  run-yantra.sh compiles into $TMPDIR and turns the result
# once; it is how a lane checks its own working tree, and its output does not
# survive the container.  This script produces the OTHER thing: one file, in
# bin/, committed, that runs on a machine which has agda and does not have
# this repository.  The two are the same image and neither replaces the other.
#
# WHY STATIC.  A dynamically linked GHC binary wants libgmp.so.10 and
# libffi.so.8 at the versions the building machine had.  Copying that onto a
# host with a different libc is the failure mode the whole exercise is meant
# to remove, and it fails at exec with a linker message that says nothing
# about the yantra.  Static linking costs about 4 MB and removes the class.
# It needs the .a files (libgmp-dev, libffi-dev, zlib1g-dev); if they are
# absent this falls back to a dynamic build and SAYS SO rather than shipping
# a binary whose portability is quietly different from the one claimed.
#
# WHAT THE BINARY STILL NEEDS AT RUN TIME, and this script cannot supply:
#
#   * agda 2.8.0 on PATH, with the cubical library registered as `cubical`
#     (formal/cubical/ensure-toolchain.sh --install builds exactly that pair,
#     and the pinning note there is load-bearing: v0.9 needs 2.8.0);
#   * a directory with formal/cubical under it, which the binary finds by
#     walking up from itself.  --bundle puts one in the tarball.
#
# Everything else -- the defect log, the transcript, the session date, the
# path to the doṣa-lekha organ -- the binary fills in for itself; Server.hs
# `resolveEnvironment` is where, and it overwrites nothing already exported.
set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
BIN="$ROOT/bin"
WORK="${TMPDIR:-/tmp}/yantra-build-$(id -u)"
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
"build-yantra: no ghc on PATH.  Any GHC with the boot libraries will do -- the
build has no dependency outside base, containers, time, directory, filepath
and process -- so \`apt-get install ghc\` is enough, as is ghcup."

mkdir -p "$WORK" "$BIN"

# ------------------------------------------------------------------ compile
#
# -O1, not run-yantra.sh's -O0.  That script optimises for the edit-run loop
# and rebuilds on every turn; this one runs when something is shipped, and the
# 30 s it costs is paid once.

LINK_KIND=static
say "==> compiling (ghc $(ghc --numeric-version), -O1, static)"
if ! ghc -O1 -i"$ROOT/interactive" \
        -outputdir "$WORK/obj" -o "$WORK/yantra" \
        -optl-static -optl-pthread \
        "$ROOT/interactive/Main.hs" >"$WORK/build.log" 2>&1; then
  say "!! the static link failed.  first errors:"
  grep -E "error|cannot find" -A4 "$WORK/build.log" | head -20 >&2
  say ""
  say "==> retrying dynamically"
  rm -rf "$WORK/obj"
  ghc -O1 -i"$ROOT/interactive" \
      -outputdir "$WORK/obj" -o "$WORK/yantra" \
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

strip "$WORK/yantra" 2>/dev/null || true

# The doṣa-lekha organ is the same image under another name; Main.hs selects
# on argv[0].  A relative link, so the pair survives being moved together.
ln -sf yantra "$WORK/dosalekha"

# --------------------------------------------------------------- the checks
#
# A binary that was produced is not a binary that works, and the difference is
# one turn.  Both organs are exercised before either is installed into bin/,
# against a MATH_ROOT that is NOT this repository -- so what is checked is the
# copied-elsewhere case, which is the one bin/ exists for.

say "==> checking the build before installing it"
PROBE="$WORK/probe"
rm -rf "$PROBE"; mkdir -p "$PROBE/bin" "$PROBE/formal/cubical"
cp "$WORK/yantra" "$PROBE/bin/yantra"
ln -sf yantra "$PROBE/bin/dosalekha"
cp "$ROOT/formal/cubical/natural-machine.agda-lib" "$PROBE/formal/cubical/"

# The session below is three turns, and each one checks something the other
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
( cd "$WORK" && printf '%s\n' \
    '{"kriya":"yantra.kriyah"}' \
    '{"kriya":"dosa.lekha","angani":{"kriya":"build-yantra self-check","hetu":"this record exists to exercise the organ pair at build time and is about no mathematics","nasta":["nothing: the record is a probe and destroys no distinction"]}}' \
    '{"kriya":"dosa.pramanya"}' \
  | YANTRA_STATE="$PROBE/state" "$PROBE/bin/yantra" --wire \
    >"$PROBE/out.jsonl" 2>"$PROBE/out.err" ) || die \
  "build-yantra: the binary exited non-zero on a three-turn session.
$(cat "$PROBE/out.err")"

[ "$(wc -l <"$PROBE/out.jsonl")" -eq 3 ] || die \
  "build-yantra: asked for three turns, got $(wc -l <"$PROBE/out.jsonl") answers."

sed -n 1p "$PROBE/out.jsonl" | grep -q '"uttara":"samkramana"' || die \
  "build-yantra: the machine answered yantra.kriyah, and the answer was not a
saṃkramaṇa.  what it said:
$(sed -n 1p "$PROBE/out.jsonl" | head -c 600)"

# The defect turn must come back a doṣa-lekha.  It is the one answer in this
# script that is SUPPOSED to be the refusal: `dosa.lekha` writes a defect, so
# a saṃkramaṇa here would mean the machine transported something instead of
# recording it.
sed -n 2p "$PROBE/out.jsonl" | grep -q '"uttara":"dosalekha"' || die \
  "build-yantra: writing a defect did not come back as a doṣa-lekha.
$(sed -n 2p "$PROBE/out.jsonl" | head -c 600)"

sed -n 3p "$PROBE/out.jsonl" | grep -q '"uttara":"samkramana"' || die \
  "build-yantra: the doṣa-lekha chain did not verify from inside the session.
$(sed -n 3p "$PROBE/out.jsonl" | head -c 600)"

# The record actually reached disk, and the standalone organ -- the same image
# entered under the other name, this time from the outside -- agrees.
LEKHA="$PROBE/state/session.lekha"
[ -s "$LEKHA" ] || die \
  "build-yantra: the session reported filing a defect and $LEKHA is empty, so
the forked organ did not write.  The two organs are one image selecting on
argv[0] (Main.hs); a symlink that did not survive the build would look
exactly like this."

DOSA_LEKHA="$LEKHA" "$PROBE/bin/dosalekha" verify >"$PROBE/verify.out" 2>&1 \
  || die "build-yantra: the doṣa-lekha organ did not verify the chain it just
wrote.
$(cat "$PROBE/verify.out")"

say "    three turns; forked the other organ; chain verified inside and out"

# ------------------------------------------------------------------ install

install -m 755 "$WORK/yantra" "$BIN/yantra"
ln -sf yantra "$BIN/dosalekha"

SHA=$(sha256sum "$BIN/yantra" | cut -d' ' -f1)
COMMIT=$(cd "$ROOT" && git rev-parse HEAD 2>/dev/null || echo unknown)
DIRTY=$(cd "$ROOT" && git status --porcelain -- interactive/ 2>/dev/null | head -1)

cat > "$BIN/PROVENANCE.txt" <<PROV
bin/yantra — what it was built from.

  built by     interactive/build-yantra.sh
  from source  interactive/*.hs, entry interactive/Main.hs
  at commit    $COMMIT
  linkage      $LINK_KIND
  compiler     ghc $(ghc --numeric-version)
  sha256       $SHA

The commit above is the one the working tree was AT when the compiler ran, so
it is the parent of whichever commit carries this file — a binary cannot
record the commit that will contain it.  ${DIRTY:+The interactive/ tree had
uncommitted changes at build time, so the source above is not exact.}

To rebuild:  sh interactive/build-yantra.sh
To repack :  sh interactive/build-yantra.sh --bundle

bin/dosalekha is a symlink to bin/yantra, not a second program.  The image
carries both organs and selects on the name it was invoked under; Main.hs
says why, and what that does and does not change about the interface between
them.
PROV

# ---------------------------------------------------------------- the usage
#
# The operation table is GENERATED, by asking the binary that was just built.
# The alternative is a written list, and a written list of nineteen verbs is a
# second copy of the dispatch table that goes stale the first time one of them
# is renamed -- with nothing to notice, because prose does not fail to compile.
# `yantra.kriyah` emits the table the server actually dispatches on, so what is
# below cannot disagree with what runs.  If python3 is not here, the section
# says how to get the list from the tool instead of guessing at it.

say "==> writing bin/USAGE.txt"
cat > "$BIN/USAGE.txt" <<'USAGE'
यन्त्रम् / yantra — THIS IS A TOOL.  RUN IT.  DO NOT BUILD IT.

You have been handed a program.  bin/yantra is a complete, statically linked
executable: there is nothing here to compile, nothing to install, no manifest
to resolve and no source you need to read.  If you have started looking for a
Makefile, a package file, or the language it was written in, you have left the
task you were given.  Turning this machine IS the task.

The repository it was compiled from does not have to be present.  Copy bin/
and formal/ onto any Linux host that has agda and it runs there.

--------------------------------------------------------------- how to turn it

  bin/yantra --wire

reads ONE JSON OBJECT PER LINE on stdin and writes ONE JSON OBJECT PER LINE on
stdout.  It stays up until stdin closes; a session is a pipe, not a series of
commands.  Anything it says about itself, its state, or its failures comes back
on that wire.  stderr carries the banner and the witness check only.

  bin/yantra

with no arguments runs a scripted session against itself and prints it.  Use it
once to see the machine work; it takes no input.

------------------------------------------------------------- what it needs

  agda 2.8.0 on PATH, with the cubical library registered under the name
  `cubical`.  ONLY the `sadhana` operation uses it -- that is the one that
  emits an Agda module and has the kernel check it.  Every other operation
  runs with no agda at all, so a host without it is not a host where this
  tool is useless.

  a directory with formal/cubical under it, which the binary finds by walking
  up from its own location.  It is beside bin/ in the bundle.

  Nothing else.  It writes to $XDG_STATE_HOME/yantra (or ~/.local/state/yantra),
  which it creates; set YANTRA_STATE to move that.

--------------------------------------------------------------- one exchange

  $ printf '%s\n' '{"kriya":"kuttaka","angani":{"a":137,"b":60,"c":1}}' \
      | bin/yantra --wire

  {"uttara":"samkramana","kriya":"kuttaka",
   "nirnaya":{"sthana":"syad-asti", ...},
   "pramanya":{"marga":"ganita","saksin":"137·53 − 1 ≡ 0 (mod 60), computed in ℤ"},
   "vahita":{"valli":[2,3,1,1,8],"bezout":{"x":-7,"y":16,"gcd":1},"x":53, ...},
   "vyaya":["the other solutions are given as a class, not enumerated", ...]}

  (one line in reality; broken here to be read)

------------------------------------------------------------ reading an answer

EVERY answer has `uttara`, and it is one of exactly two words.  There is no
third, and no operation returns a bare result.

  "samkramana"  transport happened.  `vahita` is what was carried across,
                `tulyata` is the identification it was carried along, and
                `vyaya` names what did NOT survive the trip.  Read `vyaya`:
                a transport that cost nothing is a transport that moved
                nothing, and the field is never empty for show.

  "dosalekha"   transport was not possible, and this is the written record of
                why.  `hetu` is the reason, `nasta` lists what a collapse
                here would have destroyed, one item at a time, and `sesa` is
                the remainder handed forward.  THIS IS AN ANSWER, NOT AN
                ERROR.  It is not a failure to retry, work around, or report
                as a crash; the machine declining to transport and saying
                what that costs is the machine working.

`nirnaya` carries the position the answer is taken from and `pramanya` the
route by which it counts as evidence, with that route's witness.  An answer
whose `pramanya.marga` is `ayogya` arrived by a route the machine does not
accept and is not to be used.

USAGE

if command -v python3 >/dev/null 2>&1; then
  printf '%s\n' '{"kriya":"yantra.kriyah"}' \
    | YANTRA_STATE="$PROBE/state" "$PROBE/bin/yantra" --wire 2>/dev/null \
    | python3 -c '
import json, sys, textwrap
ans = json.loads(sys.stdin.readline())
ks  = ans["vahita"]["kriyah"]
out = ["-" * 30 + " the operations (%d, generated from the running table)" % len(ks), ""]
for k in ks:
    out.append("  " + k["nama"])
    for ln in textwrap.wrap(k["artha"], 70):
        out.append("      " + ln)
    for a in k.get("angani", []):
        for i, ln in enumerate(textwrap.wrap(a["nama"] + " — " + a["artha"], 62)):
            out.append("        " + ("  " if i else "") + ln)
    out.append("")
out += ["This list was emitted by the binary in bin/, by the same table it",
        "dispatches on.  Ask it yourself at any time:", "",
        "  echo \x27{\"kriya\":\"yantra.kriyah\"}\x27 | bin/yantra --wire", ""]
sys.stdout.write("\n".join(out))
' >> "$BIN/USAGE.txt" || say "!! could not generate the operation table"
else
  cat >> "$BIN/USAGE.txt" <<'NOPY'
------------------------------ the operations

  This section is generated by asking the binary, and python3 was not present
  on the machine that built it, so it is not here.  Ask the tool directly --
  the answer is the dispatch table itself and cannot be out of date:

    printf '%s\n' '{"kriya":"yantra.kriyah"}' | bin/yantra --wire

NOPY
fi

say "==> bin/yantra  ($(du -h "$BIN/yantra" | cut -f1), $LINK_KIND, sha256 ${SHA%"${SHA#????????}"}…)"

# ------------------------------------------------------------------- bundle
#
# The movable copy.  formal/cubical goes in WHOLE and not as the one
# .agda-lib the kernel gate strictly needs: a candidate that imports a module
# of this repository's own is a thing the gate can be handed, and a bundle
# that works until someone does that is worse than one that is 15 MB.

if [ "$BUNDLE" -eq 1 ]; then
  NAME="yantra-$(echo "$COMMIT" | cut -c1-12)"
  DIR="$WORK/$NAME"
  say "==> packing $NAME"
  rm -rf "$DIR"; mkdir -p "$DIR/bin" "$DIR/formal"
  cp "$BIN/yantra" "$DIR/bin/yantra"
  ln -sf yantra "$DIR/bin/dosalekha"
  cp "$BIN/USAGE.txt" "$BIN/PROVENANCE.txt" "$DIR/bin/" 2>/dev/null || true
  cp -R "$ROOT/formal/cubical" "$DIR/formal/cubical"
  find "$DIR/formal" -name '*.agdai' -delete 2>/dev/null || true
  find "$DIR/formal" -name '_build' -type d -prune -exec rm -rf {} + 2>/dev/null || true
  ( cd "$WORK" && tar czf "$NAME.tar.gz" "$NAME" )
  say "    $WORK/$NAME.tar.gz  ($(du -h "$WORK/$NAME.tar.gz" | cut -f1))"
  say ""
  say "    copy it anywhere with agda 2.8.0 + cubical, then:"
  say "      tar xzf $NAME.tar.gz && $NAME/bin/yantra --wire"
fi
