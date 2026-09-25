# WIP: the full runtime as the one geodesic operation

RULE: every change is stated first as the mathematics it applies (the
section of One.agda / the ledger / the checked theorem); code is its direct
rendering. A change that needs problem solving the math does not dictate is
a signal that something upstream is wrong.

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
| P3a | Label capture: fresh dimension names per δ-unfolding (`hvm4-runtime.patch`), explicit source labels in their own region, refusal of symbolic/computed labels | done (stage 1: exact-or-abort in 24-bit names) |
| P3x | CI green end to end on a fresh bootstrap (both patches) | done; re-verified after P4 (8/8 steps + list transport 26/26 on stock HVM4) |
| P3b | Dimension names unbounded: runtime name = (instance, bound label), 64-bit, stored per heap location (DIM table) | done |
| P3c | Diamond: state the demand-restricted relation, check an instance of `RandomDescent` for the reachable rules | todo |
| P4 | Machine that asks: `hvm --interact` keeps heap + point; `bend --interact` checks named maps and applies the law (`@present`); neutral calls stay folded under stuck eliminations | done (v1: non-dependent named maps) |
| P4 | Interaction entry: `Q`/`δ` loop at the root | todo |
| P5a | Checking on the net, MLTT core: `checker/Check.bend` reads the static book; `bend FILE --check-net CHECKER`; per-definition differential `tools/diff/checknet.py` | in progress (see §3d) |
| P5b | Checking on the net, cubical layer (paths/coe, hcomp/Glue/ua/Sub/Partial, HITs) | todo |
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
reclamation. DECIDED and implemented (stage 1), see "P3a results" below.
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
Differential Core-vs-runtime over the corpus (`tools/diff/diff.py`, 228 files
+ 2 lab): AGREE 118 (Nat 86, word 27, Unit 3, List 1, HIT ctor 1); DISAGREE 2
(both the `two∘two` capture shape); NOT-COMPARABLE 18 (16 superpositions whose
collapsed branches all match Core line by line, incl. SATProcess; 2 lambdas);
REFUSED 79 (74 also fail in Core; 5 are emitter refusals: 4 I64 files +
the unary-not probe); NO-MAIN 11; CORE-TIMEOUT 1 (census_corpus: runtime
finishes, 11.1M itrs); HVM-CRASH 1 (the triple probe, OOM). So the corpus
itself does not hit capture; the probes show the language admits it.

### P3b (done): names are pairs (instance, bound label), 64-bit, never reused
Math: α-renaming at instantiation pairs each bound name with a fresh
instance tag. A definition's bound names are exactly its auto labels
(parse region [0x800000, 2^24)); explicit source labels are global
(instance 0); computed labels (`&(t){..}`) get bit 63. Runtime name of bound
label s in instance k = (k << 24) | s; every REF unfolding of a definition
that binds labels takes k = ++DIM_INST (2^40 instances; exhaustion aborts).
The per-definition ranges and the fresh block allocator are gone.
Representation: a name belongs to the heap location of its SUP node or dup
slot: `DIM[loc]`, a lazily mapped table parallel to HEAP (MAP_NORESERVE);
the term's 24-bit ext keeps the low bits for printing only. Every runtime
read goes through `sup_name`/`dp_name`; every SUP/dup-slot creation through
the named constructors (`term_new_sup_at`, `term_sup_named`,
`term_new_dp0/1`, `term_new_dup_at`, `term_clone*`). Result: every value,
class and ITRS in the differential identical to P3a (only a printed dup-label
name in one trailer changed); gate 35,372,404 itrs, NATIVE_GATE_PASS.

### P3a results
- `hvm4-runtime.patch` (applied by bootstrap after the HVM4 clone):
  parse records each definition's contiguous auto-label range
  (`BOOK_LAB_LO/CNT`); `case REF` draws a fresh block from
  `[DIM_LO, DIM_HI) = [2^20, 2^23)` and packs `base|lo|cnt` into a dimension
  map word; a mapped ALO node is two words with `ALO_DIM_FLAG` in ext;
  ALO copies of SUP (ext) and DP0/DP1/BJ0/BJ1 (ext) rename labels in the
  definition's range. Exhaustion aborts (`RUNTIME_ERROR … refusing to reuse a
  live name`), never wraps. Renaming is part of δ, so it is not counted.
- Emitter: source label v < 2^18 is emitted as the name `a` + three base-64
  digits, i.e. value 2^18 + v in the explicit region [2^18, 2^19); symbolic or
  computed labels are refused (they were all emitted as the constant `L`).
  SAT labels 100/101 now print as `a_aJ`/`a_aK`.
- Label space: [0,2^18) unused by the emitter, [2^18,2^19) explicit,
  [2^20,2^23) fresh (7.3M names), [2^23,2^24) parse-time auto labels.
- Evidence: probes now 4 (27 itrs, equal to the distinct-defs control) and 16
  (50 itrs; was OOM). Differential over the corpus: 119 AGREE, 0 DISAGREE,
  0 crash; every superposed result matches Core branch by branch.
  ITRS identical on 135 programs; `port/SchematicOperation.bend` 790 → 798
  with the same (correct) value: stock HVM4 was already capturing there and
  undercounting by an illegitimate annihilation. Mining gate: identical
  35,372,404 itrs, NATIVE_GATE_PASS, heap +3% (two-word ALO nodes).
- CI: differential step fails on any DISAGREE/HVM-CRASH/HVM-TIMEOUT; verify
  stage FRESH-DIMENSIONS; SAT grep updated. Fixed two mid-script
  `! grep -q` assertions that `set -e` never enforced.

### CI state (fresh bootstrap of both patches, every workflow step run locally)
All 8 steps of conductive-language-entry pass; cubical-list-transport's
test_list_transport.py 26/26 (stock and patched HVM4). Fixed on the way:
- `hit_test.bend`, `setquotient_test.bend`: ported from the retired builtins
  (`telim`/`celim`/`Quotient`/`qin`/`qelim`) to `trec`/`srec`/`Quot`/`qcl`/
  `qrec`; `qrec` takes the target's isSet proof; a quotient point is
  check-mode, so the β-rules are stated through `rec`'s typed argument.
- The four derivation/receiver modules (UniversalDerivation,
  UniversalElucidator, NativeDerivation, UniversalMachine) all check, but
  their folds are over declared `type`s, which Core/Totality.hs treats as
  coinductive, so `--total` correctly refuses them; CI checks them without
  `--total`. They model the derivation-beside-the-net machinery that §1
  excludes; remove before merge unless the user wants them kept.
- test_list_transport.py's hand-written cells updated to the complete
  shapes (six-field `#UaU`, `#Enum{symbols}`).

## 3b. P4 (done, v1): the machine that asks, universally

- Runtime (`hvm4-runtime.patch`, which now holds all three HVM4 changes):
  `hvm FILE --interact` normalises `@main` to its typed point and keeps the
  heap. Each stdin line is parsed as a term, entered into the book like a
  definition (its own auto-label range, so δ-unfolding gives fresh names),
  applied to the current point by reference, and normalised. Output per
  question: root, `- Itrs: N` for this question, `- End`.
- The law as the step: the host lowers the Core term
  `λ(A,a). (Σ b:B. fiber f b, (f a, (a, refl)))` (One §1 `present`) through
  the one emitter; iterating it is §6 `carried`.
- Host: `bend FILE --interact`; input lines `NAME` | `:type`. NAME must be a
  non-dependent map whose domain is `equal` (Core) to the tracked point type;
  the tracked type becomes `Σb:B. Σx:A. PathP(λ_.B, f x, b)`. Refusals print
  `! reason` then `- End`. Dependent maps are refused for now.
- Test (`interact_smoke.bend`, verify stage ASK): (Nat,3) → ask double →
  (6,(3,refl)) → ask recover (its declared domain is judged equal to the
  tracked Σ type) → (3, ((6,(3,refl)), refl)).
- Found and fixed on the way: stock HVM4 normalisation diverges on any type
  that mentions a recursive call on a bound variable (goes under the binder,
  unfolds to a match stuck on the variable, unfolds the recursive call in the
  branches forever). Now the branches of an elimination stuck on a neutral
  are normalised WITHOUT δ (flag bit on the normaliser stack; `case REF`
  honours `WNF_NO_DELTA`), in both `eval_normalize` and `cnf_at`: a call on a
  neutral stays folded (`@Ddouble(c)`), every other reduction still runs.
  `neutral_type_smoke.bend` (verify stage NEUTRAL-TYPE): patched 5 itrs,
  stock times out. Differential after this change: no output or ITRS change
  anywhere except the two ported files now agreeing.
- Not yet: dependent maps (the dependent graph Σa.Σb:B(a).Path), questions
  given as expressions rather than names (needs term parsing in the host),
  and a readable type display (the runtime prints the type through sharing).

## 3c. P5 design: checking on the net (the `verify` projection, §14)

Forced points (each from the math, not from convenience):
1. The checked term is never evaluated. Checking reads each definition's
   STATIC BOOK TERM (the immutable lowered syntax at BOOK[id], de Bruijn
   levels, which every execution instantiates by ALO). Same heap words,
   viewed, not copied: no drift. (Evaluated cells are wrong: `loop(x) =
   loop(x)` has no normal form but checks; an ill-typed term can diverge
   under β.)
2. Types ARE evaluated: conversion is equality of normal type cells, decided
   by the runtime's own reduction and HVM4 `===` (EQL: structural, λs under
   one fresh name, neutral calls folded after P4).
3. The checker is meta-level: it dispatches on the syntax of types, and a
   type-case cannot live inside a univalent theory (it would separate
   ua-equal types). So it is runtime semantics written as interactions,
   exactly like the Kan rules in the prelude ("Core.Check written as an HVM
   program", as the prelude is "Core.WHNF written as an HVM program").
   Its cost is interactions like every other inference.
4. Nothing the checker needs may be deleted by lowering: `x :: T` must be
   emitted (as `@chk(T, x)`, `@chk = λT. λx. x`, erased by β at run time),
   and HIT constructor parameters must be emitted, not `&{}`.
5. Runtime primitives (new counted interaction rules in hvm.c):
   `fresh` (a new neutral: the generic element of a binder), `view` (the
   shape of a static node: kind, ext, child locations), `inst` (instantiate
   a static subterm under an environment: δ on a subterm), `typeof` (the
   type cell `@Tk` of a reference `@Dk`). Conversion reuses `===`.
6. Staging, each stage differential against Core's checker per definition
   over the whole corpus (every ✓/✗ must agree, incl. every *_mustfail):
   MLTT core (Set, Π, Σ, Unit, Empty, Bool, Nat, List, Enum, Eql, refs,
   lets, matches) → interval/paths/coe → hcomp/Glue/ua/Sub/Partial →
   truncation/circle/quotient/general HITs. Then P6: the host only parses
   and lowers; `--to-hvm4-full` and `--interact` check on the net.

## 3d. P5a state (checker on the net)

Pieces (all on the branch):
- `vendor/Bend2/checker/Check.bend`: the checker, a Bend program checked by
  Core and by itself (every definition of the file agrees with Core).
  Static code is always a pair (location, slot map: static level -> context
  level). Goals/types/refinements are FIRST-ORDER expressions `G` (level,
  code under slot map, field, application, cell, constant function, rewrite,
  substitution) read by `Chk/eval`. Refinement of a matched variable replaces
  its context entry (NbE); a non-variable scrutinee and J on a non-variable
  endpoint rewrite the goal (`rewrite` primitive, Core.Rewrite); J on a
  variable endpoint aliases it to the other endpoint. A let-bound variable is
  its code, checked where used (Core substitutes lets).
- Primitives (hvm.c): `fresh code idof peek inst vpeek vfield vapp conv
  typeof vctr val rewrite trace`. `conv` is a lazy joint traversal: stuck
  elimination branches without δ, λ under one fresh name, η against a neutral,
  a folded call against another head unfolds once. Every primitive commutes
  with superposition (meets &L{a,b} -> answers &L{p(side0), p(side1)}), and a
  primitive outside its domain (a neutral argument) is a stuck application.
- Host: `bend FILE --check-net CHECKER` emits the book's cells + checker cells
  + root `@DChk_sall(table)`; the runtime prints (book id, code) per
  definition. Codes: 0 ✓, 1 mismatch, 2 cannot infer, >=1000 not yet
  (1000+tag node kind, 3000 prelude ref, 4000+n site).

Found and fixed on the way (each a lossless/semantic defect, not a checker
convenience):
- enum default arm was emitted without applying the default to the scrutinee
  (runtime returned a λ);
- `extern` definitions all unfolded to the same `Pri EXTERN` in Core (all
  primitives judged equal);
- symbols shared constructor names (`&Nil` lowered to the cell of `[]`):
  symbols are now `#s_<name>`;
- a dup of a stuck application under no-δ never copied (DUP-APP allowed only
  without δ; DUP-REF as a leaf);
- checker closures duplicated and applied in nested ways share dup labels
  (label capture inside one instance): verdicts depended on what else was
  checked. Hence G as data. HVM's λ-duplication is only sound for stratified
  sharing; the checker must never rely on duplicating its own closures.

Differential (before the symbol fix; rerun pending): AGREE 1820,
NET-ACCEPTS 0, mismatches 10, cannot-infer 213 (cubical: toPathP, transport,
isPropToPathP), not-yet 2605 (cubical cells: #Path 1016, #PLm 1014, prelude
refs 3000).

Next (P5b), forced by the boundary law of path types:
- generic elements are reflected (η-long): Π -> λx. reflect(B x, n x),
  Σ -> pair of reflected projections, Path A a b -> a line whose faces are
  a and b (replaces Core's epNormCtx/spineEndpoints heuristics);
- path-typed definitions carry their faces in the cell (a stuck lemma call
  has lost its type on the net);
- then coe, hcomp (face DNF), Glue/ua, Sub/Partial, HITs, each differential.

## 4. How to work here (pitfalls already paid for)

- SOURCE: the compiler and runtime are vendored as ordinary source:
  `collab/bend2-interactive-cubical/vendor/Bend2/` (from DKormann/Bend2
  f026483) and `vendor/HVM4/src/hvm.c` (from HVM4 6defdfc); provenance and
  the upstream-diff recipe in `vendor/UPSTREAM.md`. Edit them directly;
  commits are the history. HVM3 stays an unmodified cloned dependency.
- BUILD: `bash collab/bend2-interactive-cubical/build.sh NEW_DIR` (copies the
  vendored trees, clones HVM3 with its two missing includes, builds), then
  `source NEW_DIR/env.sh` for `$BEND`, `$HVM`. `mining/bootstrap.sh` and
  `run.sh` delegate to it. Needs `libgmp-dev`, `PATH=$HOME/.ghcup/bin:$PATH`,
  and **`LC_ALL=C.UTF-8`**. For fast iteration copy `vendor/Bend2/{src,app}`
  into an existing build tree and `cabal build exe:bend` there.
- The user's editor applies JS `String.replace` with replacement strings:
  never put `$'` in files it may edit (use `grep -Fqx`, `[^\n]*`).
- Parser quirks: `not(` is always unary `not`; after a def whose body is
  `&{…}` the next signature cannot contain `A{a == b}` (put enums last).
- Emitted binder names (`b0u13`) come from a global counter; match by regex.
- A `!`-negated command never trips `set -e`; assert with `if …; then exit 1; fi`.
- Regression: `tools/regress/run.sh` + `compare.sh`; differential:
  `tools/diff/diff.py` (BEND, HVM, DIFF_OUT env).

## 5. Decision log

- Start point = PR head + main (clean merge), not main: the PR carries the
  full-runtime emitter and build fixes.
- Root is `#Pair{type, value}` (the point of `Σ(A:U).A`), not a new node.
- `Chk` annotations are judgments, not cells; `Rwt` is checker-internal;
  both project to their term.
- Eql inhabitants are `#Refl` at runtime; `coe` along an Eql line keeps it.
- Refuse, never miscompile: an operation whose runtime meaning needs a type
  the emitter does not yet have is an error until P5 supplies the type.

## 6. Unwound decisions and pending deletions

- Patch files as source: replaced by vendored trees (`vendor/`), one build
  script (`build.sh`); `run.sh`, `mining/bootstrap.sh` delegate to it.
- Quoted-syntax checker: withdrawn (§3c).
- Hand-written `@present` in the prelude: removed; the host builds the Core
  term of One §1 `present` over the typed point and lowers it through the one
  emitter (same reason the `@cf*` bootstrap was deleted). Done.
- AWAITING THE USER'S APPROVAL TO DELETE (the auto-mode classifier blocked
  the deletion as irreversible; all are in git history): the superseded
  `cubical-paths.patch`, `hvm4-runtime.patch`, `glue-emit.patch` (already
  contained in cubical-paths.patch); `port/UniversalDerivation.bend`,
  `port/UniversalElucidator.bend`, `port/UniversalMachine.bend`,
  `port/NativeDerivation.bend` (derivation beside the net);
  `port/ConductiveRuntime.bend`, `port/UniversalPresentation.bend`,
  `universal_presentation.bend` (oracles for the deleted `@cf*` bootstrap);
  `LANGUAGE_LEVEL_CONDUCTIVE_FIBRE_INTEGRATION.md` (plan for the withdrawn
  design); `vendor/`-duplicated root .bend copies are already dropped.
  Renames wanted: conductive_*_smoke → typed_point_*_smoke,
  verify_conductive_entry.sh → verify_full_runtime.sh, workflow
  conductive-language-entry.yml → full-runtime.yml.
