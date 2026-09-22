# HANDOFF â€” the cubical Bend2 work

Everything below is on `main`. The patched compiler lives OUTSIDE the repo in a
container (`/tmp/Bend2`); to rebuild from the repo:

    git clone https://github.com/DKormann/Bend2 /tmp/Bend2 && cd /tmp/Bend2 && git checkout f026483
    git apply collab/bend2-interactive-cubical/cubical-paths.patch      # the whole cubical layer + emitters
    # HVM3 as a local package: clone HigherOrderCO/HVM3 to /tmp/HVM3, patch Runtime.c to
    #   #include "runtime/reduce/ref.c" and "ref_sup.c"; cabal.project: packages: . /tmp/HVM3
    export PATH="$HOME/.ghcup/bin:$PATH" LC_ALL=C.utf8 LANG=C.utf8   # LC_ALL is MANDATORY
    cabal build exe:bend                                     # GHC 9.12.2, cabal 3.18
    # HVM4: clone HigherOrderCO/HVM4 to /tmp/HVM4; gcc -O2 -o src/hvm src/hvm.c ; `hvm f.hvm4 -s -C10`

TOOLCHAIN WITHOUT A HASKELL MIRROR (this container's proxy denies downloads.haskell.org):
    GHC 9.12.2 and cabal-install 3.16 come from the Nix binary cache without nix â”
    hydra gives the store path, cache.nixos.org the NAR closure (a 60-line Python
    unpacker is enough); bash/ld work as-is from /nix/store. Build with
    `packages: . ../HVM3 ../hs-highlight`, `package zlib: flags: +bundled-c-zlib`
    (the nix cc does not see /usr/lib), and apply `hvm3-gcc15.patch` to HVM3
    (GCC 15 rejects the K&R prototype of `hvm_define`). Verified: the suite is
    bad=0 on that build, byte-identical behaviour to the previous binary.

MODULES: a line `import Name` (no `as`) loads `Name.bend` (next to the importing
file, else in the cwd) and brings its definitions in unqualified â” added for the
port of the Agda corpus (`port/`, see `port/PORT.md`): one Agda module = one Bend
file, a shared `Prelude.bend`.

Run: `bend f.bend` (checks + runs; `bend check` is NOT a subcommand; count â“/â— lines).
Targets: `--to-hvm4` (normalised), `--to-hvm4-raw` (no normalisation, strict),
`--to-hvm4-full` (FULL cubical runtime: nothing erased), `--to-hvm` (HVM3), `--total`.

### Building on a machine WITHOUT GHC 9.12 (verified 2026-09-14, Ubuntu 24.04)
`apt-get install ghc cabal-install` gives GHC 9.4.7 / cabal 3.8, which is enough:
the patch's `bend.cabal` (and HVM3's `HVM.cabal`, edit it the same way) use
`default-language: GHC2021` plus the GHC2024 extensions and `base >= 4.17`,
so nothing needs `^>= 4.21`. Two traps: (1) cabal 3.8's built-in Hackage
root keys are stale â” put the current key ids from
`https://hackage.haskell.org/root.json` under `root-keys:` (threshold 3) in
`~/.cabal/config` and set the repository `url:` to https; (2) `cabal.project`
must list `/tmp/HVM3` and a clone of `HigherOrderCO/hs-highlight` as local
packages, with NO blanket `allow-newer` (it drags in libraries needing a newer
base). `Data.List.unsnoc` is shimmed in `Target/HVM.hs`. HVM4 (May 2026 head,
`gcc -O2 -o src/hvm src/hvm.c -lm -lpthread`) runs every emitted program.

## What the user wants (their words, condensed)
The README's Interactive Symbolic Computer: the trace IS the path
(data = program = execution = proof = transport); traces compose, invert, have
higher coherences; knowledge is partial. So EVERYTHING cubical must be a RUNTIME
object, no erasure, no compile-time normalisation. No overclaiming; verify by
execution; push/pull main every few minutes; never idle; no questions.

## What is built (all verified by execution; see STATUS.md for the table)
- Checker: full CCHM layer, general hcompN, hfill, coherent univalence round
  trip, the fibre law A â‰ Î B (fiber f) as a coherent Equiv (`fibrelaw.bend`).
- `--to-hvm4-full` (Target/HVM4Full.hs, in the patch): intervals, paths
  (#PLm / #UaU / #CompU data), TYPES (#Bool, #Pi, #Sig, #Path â¦), coe (@coe,
  runtime dispatch on the type former at a symbolic interval) and hcomp
  (@hcomp; faces evaluated at runtime; STUCK DATA #HCm when a face is symbolic)
  are all runtime. Verified: chain.bend 12 transports (itrs 134â“1121),
  fibre law present/retrieve/contraction, t_* â” all correct on the net;
  a composite applied at a symbolic interval stays `#HCm{â¦}` and is decided
  when the interval is (partial knowledge). See RUNTIME_FULL.md.
- Native DUP-SUP routing confirmed on HVM4: a match commutes over a
  superposition and same-label dups annihilate (probe: `@f(&L{#A,#B},&L{1,2})`
  â’ branches get 1 and 2). `supline.bend` is the Bend2 test for it.

## supline.bend (6â“; full runtime &0{0,1}, native routing) and
isprop_run.bend (5â“; 4-face composite decided at every corner) are recorded in
RUNTIME_FULL.md and STATUS.md.

## Reconciled with parallel agents
Folded into the patch from other agents: epNormCtx recursing into coe
(fromPathP), interval idempotence (iSyntEq), and Glue (their parser was missing
on main â” now in the patch; see GLUE.md). `forced.bend` 44â“, `fpp_fromPathP`
2â“, `glue.bend` 2â“ on the patch binary. The whole-file .hs copies in this
directory were deleted: cubical-paths.patch is the ONLY source of truth. If
you see loose .hs files here again, diff them against the patch-applied tree
and fold real deltas into the patch.

## Kan rules in the checker (uaglue.bend, hcompset.bend; GLUE.md)
Transport through Glue and hcomp-in-Set-as-Glue are implemented and green.
Full runtime (--to-hvm4-full) has the same Kan rules (@coeGlue, hcomp at
#Set -> #Glue, @transpEquiv); verified uaglue/hcompset on HVM4. Resolved: the
isprop_run residual-DUP issue (static dup labels; prelude linearized â”
never `Î»&` a value just because it is used in several match arms).

## The forcing theorem RUNS (forcing_run.bend, 82â“; FORCING.md RUN section)
Both instances (recording trace / contractible trace) observed on HVM4 full
runtime with values matching the normaliser.

## The coinductive calculus + braid fabric carried (interaction.bend, braid.bend; INTERACTION.md)
Two checker fixes went in with it (rewrite descends into application heads;
same-head conversion before unfolding recursive type families). Also merged
the SetQuotient HIT from a parallel agent (QUOTIENT.md) into the patch.

## Genuine coinduction (coinduction.bend 13â“, streams.bend 10â“, coinduction_mustfail.bend; COINDUCTION.md)
Bend2 is coinductive by default (Fix-typed recursion, lazy HVM). `Answers`/
`IExec` are now the coinductive records themselves; `replay`/`forgetStates`
and both `run-is-answers` round trips are corecursive `[productive]` paths.
Three fixes in the patch: epNormCtx unfolds one level (`goNoUnfold`), printing
uses a capped normaliser (`normalCap`), record matches give no descent in
Totality (`branch2 Nothing`), Î fields / Î  codomains are guarded positions so
self-referential `type` families are `[productive]`. `bend f.bend --total`
(flag AFTER the file) passes on coinduction/interaction/braid.

## General silence-is-determinism (silence.bend 25â“, silence_mustfail.bend)
Parametric `(X, Q, Î´)`, corecursive PathP contraction over a path of states,
`isContr(IExec x)` for contractible `Q`; closed machine as instance; runs on
HVM4 full (252 itrs â’ 4). Must-fail set for the suite loop now also includes
`silence_mustfail`.

## Cost measurements (SYNTHESIS.md Â§3-4; bench_*.bend)
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
85 files, bad=0. The must-fail registry lives IN the script â” if you add a file
with a deliberate rejection, register it there. `erasure.bend` (another agent's)
is one of them: its `tbadResp` fake descent witness MUST be rejected.

## CUBICAL COMPLETENESS (see REMAINING.md)
Every type-directed hcomp rule (Pi/Sigma/PathP/Nat/List/
discrete/Set/Glue) in checker AND runtime; comp + hfill as core ops with comp
surface syntax; transp with a cofibration; Partial types with systems and pout;
Sub types with inS/outS; quotients emitted to the runtime with @qrec; the
circle S1 as a second HIT (s1base/s1loop/srec â” NOT named base/loop, those are
ordinary identifiers in the corpus); every traversal exhaustive; JS backend
fails loudly on cubical terms.
Files: kan.bend comp.bend transp.bend sub.bend partial.bend circle.bend
glue_kan.bend + five _mustfail siblings. Suite 85 files bad=0 via ./suite.sh.

## THE GENERAL HIT SCHEMA (HIT.md)
At Cubical Agda `data` generality: `hit Name<params>(indices): case
@tag(fields) -> Name(â¦) | path @tag(fields): T | path @tag(fields): lhs ~> rhs`
generates `Name`, `Name/tag`; `Name/elim(params, P, indices, x, branches)` is
SYNTAX resolved into the primitive `HEl` (Core/Adjust.elimSugar) â” not a def,
its type cannot be a Î -telescope. Four generic `Term` forms
(`HTy`/`HPt`/`HPa`/`HEl`), signatures in the `Book` (second map, `HitSig`);
`hitInst`/`hitSpine`/`hitEndAt`/`whnfHEl` in WHNF (cells of any dimension,
hcomp cells via `compAt` over `hfillAt`); `checkTele`/`hitMotiveType`/
`hitPathTypeOver`/`hitBranchType` in Check; `hitDefs` in Parse/Book;
`hitRuntime` in HVM4Full (generated `@hitAt`, `@hitCoe`, `@hit_Name_elim`,
spine walks unrolled to the program's max dimension). Three general fixes rode
along: `whnfHCm` dispatches on the type's normal form; face-cell restriction
is a syntactic substitution (`substVar`) â” the semantic `rewrite` diverged on
recursive defs stuck on a variable; `Equal.sameHead` sees through `@` spines
(else a recursive path lemma applied at an interval is
unfolded forever when an argument is convertible but not syntactically equal). `p @ i @ j` is left associative. Files:
hit_circle hit_susp hit_pushout hit_trunc hit_quot hit_interval hit_tree
hit_torus hit_settrunc hit_indexed hit_hcomp + hit_mustfail (registered).
Suite 100 files bad=0; every `main` agrees between normaliser and HVM4.
Recursion in branches is by named defs (Agda's pattern matching): the
expected face `Name/elim(â¦, x, bs)` IS `rec(x)` after unfolding. Known
HVM4 property, not ours: printing a recursive function as a VALUE never
terminates (`@main = @add` included). PUSC.md is the author's architecture
statement â” the level at which the whole is to be read.

## Merge note (2026-09-14): two general HIT schemas met on main
Two sessions built the general HIT schema in parallel. The one on main
(`type â¦ path â¦`, `@c{args}`, `hrec`/`helim`, HITS.md) is the one kept â” the
module system, the Prelude and the fourteen `port/` files are written on it.
The other (`hit Name<params>(indices): case @tag(fields) -> Name(â¦) | path
@tag(fields): T`, `Name/elim` as syntax, native indices) lives in git history
at commit a236711 with its own tests and HIT.md; it is superseded, not
merged. Carried over from it onto main's implementation, each verified on
main's tests too: the three checker fixes (HITS.md, last section), transport
commuting with hcomp (checker and runtime), a line named by a definition
reaching the HIT transport branch, the eliminator on an hcomp cell whose type
is named by a definition, the RUNTIME transport arm for HIT lines (`@hitCoe`,
`@X_T`, `@HTp_T_k` â” main's runtime had none), and five files re-expressed
on main's syntax: hit_interval, hit_tree, hit_indexed (indices as
index-equation fields), hit_hcomp, hit_mustfail (registered). PUSC.md is the
author's architecture statement. Suite 108 files bad=0; every `main` agrees
between normaliser and HVM4; the pre-existing runtime programs keep their
recorded interaction counts. Built here with the apt GHC 9.4.7 recipe above.
