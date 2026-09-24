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
| P3 | Diamond + label audit of the reachable HVM4 rules (§3a); label capture found: fresh dimension names per instantiation | in progress |
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

## 3a. P3 audit (in progress)

### Reachable rule set
HVM4 `hvm.c` (6defdfc) counted rules: APP-{LAM,ERA,SUP,INC,MAT-SUP,MAT-CTR-MAT,
MAT-CTR-MIS,MAT-NUM-MAT,MAT-NUM-MIS}, DUP-{LAM,SUP,NOD,NAM}, OP2-*, AND-*, OR-*,
EQL-*, DSU-*, DDU-*, USE-*, MAT-INC, WNF-UNS. Uncounted: REF/ALO (δ-unfolding,
lazy node-by-node copy of the book term), APP-NAM/APP-DRY (stuck).
Scanning all 222 emitted programs: none contain `.&.` `.|.` `===` `↑` `&(…)`
`!${` `*`; `SupM` and `Fix` are never emitted by the corpus. Reachable:
LAM (incl. erased binder), APP, VAR, DUP (auto-dup `λ&`, `!&`), SUP, ERA,
CTR, MAT, SWI, NUM, OP2, REF/ALO. Bend `&&`/`||` lower to strict OP2
(bitwise), NOT to the short-circuit AND/OR nodes.

### Diamond / cost
- `AND-ZER`, `OR-ONE`, and APP-LAM with an erased binder all drop an
  unevaluated subgraph. Under a context-closed relation that breaks the
  equal-length conclusion (REDUCTION_FOUNDATIONS). Under the demand-restricted
  relation (a redex fires only when demanded; the evaluator's actual
  relation) a dropped subgraph was never demanded, so this does not arise.
  TODO: state the demand-restricted step relation precisely and check an
  instance of `InteractionGeodesic.RandomDescent` for the reachable rules.
- δ (REF/ALO) is uncounted: definitional unfolding is refl, consistent with
  "transport is free".

### LABEL CAPTURE — a correctness bug, not a cost question (found)
Reading (exact): `&L{a,b}` is a 1-cell in dimension L; `!&L{x,y}=v` takes its
two faces. DUP-SUP same label = face map on its own dimension (annihilate);
different labels = faces in different dimensions commute. DUP-LAM pushes the
face map under a binder. **A label is a dimension name.** Correctness needs
every dimension name bound by one correlation (capture-free).
HVM4 assigns auto-dup labels once per SOURCE binder (parse counter), and every
δ-unfolding of a definition reuses them. Two dynamic instances of one
definition therefore share dimension names: capture.
Evidence (`probes/label_capture/`): `two(Nat->Nat, λg. two(Nat,g), suc, 0)`:
Core = 4, runtime = `λa.#Suc{a}` (wrong). Same program with two identical
defs `twoA`/`twoB` (distinct static labels): runtime = 4, 27 itrs. Triple
nesting: Core 16, runtime OOM-killed.
Also: `Fix` emission uses the literal static label `F` for every knot.
Fix direction (math-forced): α-rename bound dimensions at instantiation —
fresh labels per δ-unfolding (and per Fix knot). Engineering constraint:
HVM4 labels are 24-bit (term ext); DSU/DDU dynamic labels also land in 24
bits; there is no fresh-label primitive. A monotone per-unfolding counter
wraps after 2^24 unfoldings, so exactness needs wider labels or label
reclamation. DECISION PENDING with the user (see chat).
Where freshness must happen (from the code, not assumed):
- `term_clone` always makes a lazy shared DUP of its value, so copies of an
  unevaluated REF (or of any fresh-number term) share ONE evaluation. A fresh
  label drawn at the reference site is therefore shared by all lazy copies of
  that reference: not enough.
- The single shared δ-unfolding is what gets copied (DUP-NOD / DUP-LAM over
  the unfolded body). Capture = a DUP-L copying a term containing a dup of
  the same L. Drawing the dimension names at the unfolding (ALO) makes the
  unfolded instance's names differ from every name live when it was created;
  a DUP of another instance then commutes with it, as IC requires.
- Implementation shape in hvm.c: parse already allocates one contiguous
  static-label range per definition (PARSE_FRESH_LAB increments while that
  def parses) -> record [lo, count) per book entry; at `case REF` unfolding
  take base = FRESH_LAB; FRESH_LAB += count; every ALO copy of a
  SUP/DUP/DP0/DP1/BJ0/BJ1 remaps a static label s in [lo, lo+count) to
  base + (s - lo). ALO must carry base: it currently packs (ls,tm) in one
  word and len in ext, with the len==0 fast path allocating nothing.
- Label width: ext is 24 bits and parse labels occupy [0x800000, 2^24). The
  dynamic range [0, 0x800000) holds 8.4M names; programs with millions of
  unfoldings (the mining gate runs 35M interactions) exhaust it. Exactness
  needs either wider labels (label moved from the term word into the node:
  SUP 3 words, DUP node 2 words; touches every rule reading term_ext for a
  label, plus collapse/printing) or level-indexed names (Lamping brackets:
  bookkeeping interactions, Asperti–Mairson overhead, counted). Never wrap
  silently: exhaustion must abort ("refuse, never miscompile").
Differential Core-vs-runtime check over the corpus: running.

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
