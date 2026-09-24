# WIP: the full runtime as the one geodesic operation

Branch `claude/metacircular-pr-45-review-yt93oh`. Working notes, kept current
on every push. **Delete this file before the branch merges.**

## 0. The mathematics this implements (read these, not summaries)

Everything below is forced by checked results. Primary sources:

- `formal/cubical/One.agda` — the whole kernel in one file.
  - §1 `law : A ≃ Σ b. fiber f b`, `present a = (f a, a, refl)`,
    `transport-is-present` (uaβ).
  - §2 `uniqueness : isContr (Lossless f)`; `machines-are-maps`.
  - §3 descent: a projection cannot carry what its fibre identifies.
  - §4 cost and inverse cannot coexist: an additive grade on a structure
    with inverses is zero, so **cost lives on the retained walk, never on
    the transport**.
  - §5 `Geodesic`: a potential Φ local on primitive edges
    (`Φ u ≤ w u v + Φ v`) and zero at the target bounds every walk; a walk
    meeting it is shortest against every competitor, with no enumeration.
  - §6 path ≃ bisimulation; transport commutes with unfolding.
  - §7 `Run ≃ Answers`; `silence-is-determinism` (a closed machine is the
    interaction with nothing to ask).
  - §8 locality: depth is time; §5's potential read metrically.
  - §14 `Step`: `decide = present`, `verify` inverts it; **finding and
    checking are the two projections of one equivalence**.
- `research/sat_fibre/InteractionGeodesic.agda` — under the exact one-step
  diamond, every complete reduction to the normal form has the same length:
  `normalization-is-geodesic`. Any schedule is a geodesic.
- `research/PNP_GEODESIC_REDUCTION_20260916.md` — the ledger: A (completion),
  B (coinductive answers), C (exact descent), D (cost on retained
  realizations: grading vs subadditive word length), G (rope geodesic: lower
  bound from prefix locality + attainment), H (the costed realization fibre
  `Fib_(Sem_b)(f)` is the uniform interface; minimum over representations).
- `research/sat_fibre/REDUCTION_FOUNDATIONS.md` — what HVM's ITRS counts, rule
  by rule; `AND-ZER` breaks the diamond under context closure; demand
  belongs in the state whose geodesic is measured.
- `formal/cubical/theorems/cost/Machine_…Groupoid…agda` — programs are
  equivalences; running is transport; the forgotten fibre is the cost.

## 1. End state

One object, one rule set, one operation.

1. **Object.** One interaction net holding the whole cell complex: terms,
   types (types are cells; `U` is a point; towers flatten), intervals,
   paths, HITs, SUP (a fibre's candidates held as one shared node).
2. **Rules.** Only active-pair interactions, the Kan rules (`coe`, `hcomp`,
   Glue/ua) among them. The rule set satisfies the exact one-step diamond,
   so the interaction count of any complete reduction is the geodesic length.
3. **Operation.** Complete inference = the fibre point by a geodesic walk.
   Execution, type checking (`verify`), inference (`decide`), proof search,
   synthesis (SupGen: SUP over the fibre) are this one operation.
   Cost = interactions on the walk (ITRS). Minimum across representations =
   a point of the costed realization fibre, found by the same operation.
4. **Root.** A checked program is its typed point `(A, a) : Σ(A:U). A`,
   emitted as `@main = #Pair{@Tmain, @Dmain}`.
5. **Interaction.** A running program is a machine that asks
   (`Interaction X = (Q, δ)`); each answer advances the point; a closed
   program is the case with nothing to ask.
6. **Host.** Haskell parses the surface and lowers it to the net. No
   Haskell evaluator in the loop (Core `whnf` is a second copy of the
   semantics and decides some things non-locally, e.g. coe regularity by
   full normalisation).

**Not in the design (delete on sight):** compile-time native steps /
derivations, receiver folds, conductive entries, hand-written `cf*`
bootstrap, any trace object beside the net. A closed run's history is
contractible (§7, `fibre-of-run`); cost is the net's own interaction count.

## 2. Phases

| # | Phase | State |
|---|---|---|
| P1 | Seam: check gate, no deleted cells, types emitted, typed-point root, remove companions/bootstrap | done (commit 1) |
| P2 | Fix breakages from P1 (mining gate reader, `sat_fibre.bend` `not`, all-or-nothing emission) | done (commit 3) |
| P3 | Diamond audit: classify every HVM4 primitive rule the emitter can reach; rewrite emission so only diamond rules are used (explicit erasure, demand in state) | next |
| P4 | Interaction entry: `Q`/`δ` loop at the root | todo |
| P5 | Checking on the net (`verify` projection): the checker as a net program | todo |
| P6 | Delete the Haskell evaluator from the compile path; bootstrap + CI green; delete this file | todo |

## 3. Current branch state

- Base: PR #45 head `d6ef4108` + `origin/main` merged (clean; patch byte-identical).
- The other agent's later commits on `conductive-language-entry`
  (`de570bb7..21632539`, recursive native derivations + `@nativeFold`) are
  NOT included: they extend what P1 deletes.
- Compiler changes live in `collab/bend2-interactive-cubical/cubical-paths.patch`
  (over DKormann/Bend2 `f026483`):
  - `Core/CLI.hs`: `--to-hvm4-full` runs `checkDefinitions` first (report to
    stderr); ill-typed ⇒ exit 1, empty stdout. `--native-steps` removed.
  - `Core/WHNF.hs`: NativeRule/NativeStep/nativeRun/whnfViaStep removed.
  - `Target/HVM4Full.hs`: `@D<name>` term cells, `@T<name>` type cells
    (injective escaping `_`→`_u`, `/`→`_s`, disjoint from prelude names);
    `Eql` keeps `{T,a,b}`, `Enum` its symbols, `Num` its kind, `ua` both
    coherences (6 fields; `@pAtSym/@pL/@pR/@coeU` updated); `POW` → `@pow`;
    `U64_TO_CHAR` → `@u64ToChar`; chars emitted as numbers; unary `not`/`neg`
    and unsolved metas are refused (they were miscompiled: `not` was identity).
- Tests: `verify_conductive_entry.sh` (TYPED-POINT, FIBRE-LAW-AND-CONTINUATION,
  CELLS, CHECK-GATE), `complex_cells_smoke.bend`, `gate_mustfail.bend`
  (registered in `suite.sh`), workflow updated, mining linker uses `@D` names.

### Verified
- verify script: all four stages pass.
- Regression over all 223 tracked `.bend` (`tools/regress/`): 130/132 changed
  results carry exactly the baseline value as the typed point's value (2
  differ only by α-renaming); 15 newly refused files are all registered
  ill-typed probes; `streams.bend` now compiles (baseline OOM-killed at
  ~14 GB).
- `mining/transport-checks.mjs`: 18/18.

### P2 results
- `mining.mjs verifyGate` reads the typed point `#Pair{#List{#Bool{}}, bits}`.
  Two pre-existing reader bugs fixed on the way (they had only ever met the
  synthetic unit-test strings): HVM4 prints `#Nil{}` not `#Nil`, and `-C`
  prints each result followed by its interaction count `#N`. Real run:
  prepare → typecheck (116 ✓) → emit → link → gate: all six SHA-256/Bitcoin
  checks = 1, 35,372,404 interactions, `NATIVE_GATE_PASS`. The unbounded
  native search phase was not run.
- `research/sat_fibre/sat_fibre.bend`: its `def not` renamed `bnot` (a call
  spelled `not(` always parses as unary `not`, so the def was uncallable).
  At the witness (T,T,T) F is True with or without the old identity bug, so
  the baseline `1` was right by coincidence; now `#Pair{#Bool{},1}` in 52.
- Emission is all-or-nothing: `compileFull` is forced before printing, so a
  refused cell leaves empty stdout (was: partial program + exit 1).
  `emit_refuses_unary_not.bend` + verify stage REFUSE-NOT-MISCOMPILE.

## 4. How to work here (pitfalls already paid for)

- Build tree: `bash collab/bend2-interactive-cubical/mining/bootstrap.sh DIR`
  (then `source DIR/env.sh` for `$BEND`, `$HVM`). Needs `libgmp-dev`,
  `PATH=$HOME/.ghcup/bin:$PATH`, and **`LC_ALL=C.UTF-8`** (else bend exits
  silently / HVM3 embedFile fails).
- Edit Bend2 in the build tree, rebuild `cabal build exe:bend`, then
  regenerate the patch: in the Bend2 checkout
  `git add -A -N && git diff HEAD -- . ':!cabal.project' > cubical-paths.patch`
  (cabal.project is rewritten by bootstrap, not the patch). Check it applies
  to a pristine `f026483` worktree before committing.
- The user's editor applies JS `String.replace` with replacement strings:
  never put `$'` in files it may edit (use `grep -Fqx`, `[^\n]*`).
- Parser quirks: `not(` is always unary `not`; after a def whose body is
  `&{…}` the next signature cannot contain `A{a == b}` (put enums last).
- Emitted binder names (`b0u13`) come from a global counter; match them by
  regex in tests.
- Regression: `HVM=$HVM tools/regress/run.sh $BEND OUT` then
  `compare.sh BASE OUT` and `typed_point_values.py cmp.txt BASE OUT`. The
  committed `baseline-d6ef4108.tsv` is the summary only; regenerate `.norm`
  files from a build of `d6ef4108`'s patch when values must be compared.

## 5. Decision log

- Start point = PR head + main (clean merge), not main: the PR carries the
  full-runtime emitter and build fixes.
- Root is `#Pair{type, value}` (the point of `Σ(A:U).A`), not a new node.
- `Chk` annotations are judgments, not cells; `Rwt` is checker-internal;
  both project to their term.
- Eql inhabitants are `#Refl` at runtime; `coe` along an Eql line keeps it.
- Refuse, never miscompile: an operation whose runtime meaning needs a type
  the emitter does not yet have is an error until P5 supplies the type.
