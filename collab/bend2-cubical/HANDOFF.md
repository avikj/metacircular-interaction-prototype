# HANDOFF — state of the cubical Bend2 work (read this first if you are a fresh agent)

Everything below is on `main`. The patched compiler lives OUTSIDE the repo in a
container (`/tmp/Bend2`); to rebuild from the repo:

    git clone https://github.com/DKormann/Bend2 /tmp/Bend2 && cd /tmp/Bend2 && git checkout f026483
    git apply collab/bend2-cubical/cubical-paths.patch      # the whole cubical layer + emitters
    # HVM3 as a local package: clone HigherOrderCO/HVM3 to /tmp/HVM3, patch Runtime.c to
    #   #include "runtime/reduce/ref.c" and "ref_sup.c"; cabal.project: packages: . /tmp/HVM3
    export PATH="$HOME/.ghcup/bin:$PATH" LC_ALL=C.utf8 LANG=C.utf8   # LC_ALL is MANDATORY
    cabal build exe:bend                                     # GHC 9.12.2, cabal 3.18
    # HVM4: clone HigherOrderCO/HVM4 to /tmp/HVM4; gcc -O2 -o src/hvm src/hvm.c ; `hvm f.hvm4 -s -C10`

TOOLCHAIN WITHOUT A HASKELL MIRROR (this container's proxy denies downloads.haskell.org):
    GHC 9.12.2 and cabal-install 3.16 come from the Nix binary cache without nix —
    hydra gives the store path, cache.nixos.org the NAR closure (a 60-line Python
    unpacker is enough); bash/ld work as-is from /nix/store. Build with
    `packages: . ../HVM3 ../hs-highlight`, `package zlib: flags: +bundled-c-zlib`
    (the nix cc does not see /usr/lib), and apply `hvm3-gcc15.patch` to HVM3
    (GCC 15 rejects the K&R prototype of `hvm_define`). Verified: the suite is
    bad=0 on that build, byte-identical behaviour to the previous binary.

MODULES: a line `import Name` (no `as`) loads `Name.bend` (next to the importing
file, else in the cwd) and brings its definitions in unqualified — added for the
port of the Agda corpus (`port/`, see `port/PORT.md`): one Agda module = one Bend
file, a shared `Prelude.bend`.

Run: `bend f.bend` (checks + runs; `bend check` is NOT a subcommand; count ✓/✗ lines).
Targets: `--to-hvm4` (normalised), `--to-hvm4-raw` (no normalisation, strict),
`--to-hvm4-full` (FULL cubical runtime: nothing erased), `--to-hvm` (HVM3), `--total`.

## What the user wants (their words, condensed)
The README's Interactive Symbolic Computer: the trace IS the path
(data = program = execution = proof = transport); traces compose, invert, have
higher coherences; knowledge is partial. So EVERYTHING cubical must be a RUNTIME
object, no erasure, no compile-time normalisation. No overclaiming; verify by
execution; push/pull main every few minutes; never idle; no questions.

## Where things stand (all verified by execution; see STATUS.md for the table)
- Checker: full CCHM layer, general hcompN, hfill, coherent univalence round
  trip, the fibre law A ≃ Σ B (fiber f) as a coherent Equiv (`fibrelaw.bend`).
- `--to-hvm4-full` (Target/HVM4Full.hs, in the patch): intervals, paths
  (#PLm / #UaU / #CompU data), TYPES (#Bool, #Pi, #Sig, #Path …), coe (@coe,
  runtime dispatch on the type former at a symbolic interval) and hcomp
  (@hcomp; faces evaluated at runtime; STUCK DATA #HCm when a face is symbolic)
  are all runtime. Verified: chain.bend 12 transports (itrs 134–1121),
  fibre law present/retrieve/contraction, t_* — all correct on the net;
  a composite applied at a symbolic interval stays `#HCm{…}` and is decided
  when the interval is (partial knowledge). See RUNTIME_FULL.md (being written).
- Native DUP-SUP routing confirmed on HVM4: a match commutes over a
  superposition and same-label dups annihilate (probe: `@f(&L{#A,#B},&L{1,2})`
  → branches get 1 and 2). `supline.bend` is the Bend2 test for it (next).

## Done since: supline.bend (6✓; full runtime &0{0,1}, native routing) and
isprop_run.bend (5✓; 4-face composite decided at every corner) recorded in
RUNTIME_FULL.md; STATUS.md updated.

## Reconciled with parallel agents (latest)
Folded into the patch from other agents: epNormCtx recursing into coe
(fromPathP), interval idempotence (iSyntEq), and Glue (their parser was missing
on main — now in the patch; see GLUE.md). `forced.bend` 44✓, `fpp_fromPathP`
2✓, `glue.bend` 2✓ on the patch binary. The whole-file .hs copies in this
directory were deleted: cubical-paths.patch is the ONLY source of truth. If
you see loose .hs files here again, diff them against the patch-applied tree
and fold real deltas into the patch.

## Kan rules DONE in the checker (uaglue.bend, hcompset.bend; GLUE.md)
Transport through Glue and hcomp-in-Set-as-Glue are implemented and green.
Full runtime (--to-hvm4-full) now has the same Kan rules (@coeGlue, hcomp at
#Set -> #Glue, @transpEquiv); verified uaglue/hcompset on HVM4. Resolved: the
isprop_run residual-DUP issue (static dup labels; prelude linearized —
never `λ&` a value just because it is used in several match arms).

## The forcing theorem RUNS (forcing_run.bend, 82✓; FORCING.md RUN section)
Both instances (recording trace / contractible trace) observed on HVM4 full
runtime with values matching the normaliser.

## The coinductive calculus + braid fabric carried (interaction.bend, braid.bend; INTERACTION.md)
Two checker fixes went in with it (rewrite descends into application heads;
same-head conversion before unfolding recursive type families). Also merged
the SetQuotient HIT from a parallel agent (QUOTIENT.md) into the patch.

## Genuine coinduction (coinduction.bend 13✓, streams.bend 10✓, coinduction_mustfail.bend; COINDUCTION.md)
Bend2 is coinductive by default (Fix-typed recursion, lazy HVM). `Answers`/
`IExec` are now the coinductive records themselves; `replay`/`forgetStates`
and both `run-is-answers` round trips are corecursive `[productive]` paths.
Three fixes in the patch: epNormCtx unfolds one level (`goNoUnfold`), printing
uses a capped normaliser (`normalCap`), record matches give no descent in
Totality (`branch2 Nothing`), Σ fields / Π codomains are guarded positions so
self-referential `type` families are `[productive]`. `bend f.bend --total`
(flag AFTER the file) passes on coinduction/interaction/braid.

## General silence-is-determinism (silence.bend 25✓, silence_mustfail.bend)
Parametric `(X, Q, δ)`, corecursive PathP contraction over a path of states,
`isContr(IExec x)` for contractible `Q`; closed machine as instance; runs on
HVM4 full (252 itrs → 4). Must-fail set for the suite loop now also includes
`silence_mustfail`.

## Cost measurements (SYNTHESIS.md §3-4; bench_*.bend)
Transport under sharing is paid ONCE: marginal cost of one more use is 14 itrs
shared vs 150 separate (k = 1..16).
Superposed transport has TWO regimes, both measured on HVM 4.0:
  * SHARED line, N values -> superposition WINS and improves with N
    (182/278, 259/556, 413/1112 at N=2/4/8; marginal 38 vs 139 per value).
    This is the DUP-SUP fibre routing paying off; it is the batch-migration case.
  * DIFFERENT lines -> superposition LOSES by a constant ~1.4x (215/158, 469/316).
    Not an emitter artifact: a one-line `neg` on a superposition costs 1.8x
    (9/5, 37/22, 149/90), i.e. the penalty is independent of dispatch depth.
Rule: superposition pays exactly when the branches share work.
Reproduce: `bend bench_X.bend --to-hvm4-full > x.hvm4 && hvm x.hvm4 -s`.

## The suite is a script now: ./suite.sh
85 files, bad=0. The must-fail registry lives IN the script — if you add a file
with a deliberate rejection, register it there. `erasure.bend` (another agent's)
is one of them: its `tbadResp` fake descent witness MUST be rejected.

## CUBICAL COMPLETENESS: read REMAINING.md (sections A, B, C, E are CLOSED)
Done since the audit: every type-directed hcomp rule (Pi/Sigma/PathP/Nat/List/
discrete/Set/Glue) in checker AND runtime; comp + hfill as core ops with comp
surface syntax; transp with a cofibration; Partial types with systems and pout;
Sub types with inS/outS; quotients emitted to the runtime with @qrec; the
circle S1 as a second HIT (s1base/s1loop/srec — NOT named base/loop, those are
ordinary identifiers in the corpus); every traversal exhaustive; JS backend
fails loudly on cubical terms. Left: a general HIT schema, and the Glue
composition law (needs face-restricted contexts).
New files: kan.bend comp.bend transp.bend sub.bend partial.bend circle.bend
glue_kan.bend + five _mustfail siblings. Suite 85 files bad=0 via ./suite.sh.

## SUPERSEDED — the original audit text follows
Audited against CCHM by reading every traversal and running probes. Headline:
`coe` is nearly complete; **`hcomp` has no type-directed rules except the
universe** (Pi/Sigma/Nat/Path all confirmed stuck by probe) — that is the bulk
of the work, and it must be written TWICE (whnfHCm and Target/HVM4Full.hs).
Also missing: transp-with-a-cofibration, comp, Partial and Sub types, any HIT
beyond the hardcoded SetQuotient. Fixed in this pass: quotient constructors
were missing from `normal`, `normalCap`, `occursMarker` (hard crashes) and
`mapSub` (silent wrong substitution). Still crashing: `Collapse.collapse`,
`Target/HVM.freeVars`, and `--to-hvm4-full` on any quotient.

## Next steps (if continuing)
1. Exercise dependent Π/Σ lines and a path BETWEEN universe paths (a higher
   coherence of traces) on --to-hvm4-full; add to RUNTIME_FULL.md.
2. hcomp in Set beyond the composite shape (would need Glue-style rules).
3. Keep every claim tied to a run; keep pushing main.
