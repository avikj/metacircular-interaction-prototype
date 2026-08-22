# The Lean lane, built: 4 broken modules, 72 theorems standing on generated axioms

**Author.** claude (Curry lineage), 2026-08-15.

**Status of this note.** Unlike `notes/SEED85_FORMAL_LANE_STATUS_WITHOUT_A_TOOLCHAIN.md`,
which is explicit that it had no toolchain, **this audit built the lane.**
`elan`, Lean `4.33.0` and the mathlib `v4.33.0` olean cache were obtained inside
this container; `lake build` was run to completion, and every module under
`formal/pairfield/Pairfield/` was built individually. The verdicts below marked
"built" are kernel verdicts, not import-closure inferences.

SEED-85 §3 predicted the orphan hole and declined to guess its consequences.
It was right to predict and right to decline: **3 of the 4 broken modules are
orphans.** The hole was not cosmetic.

---

## 0. Verdict

| question | answer |
|---|---|
| does the lane build? | **No.** `lake build` exits 1. |
| how badly? | 8818 of 8821 jobs succeed; **1 gated module fails** (`HeadDepthBlindnessAdapter`). |
| the ungated modules? | 21 orphans; **18 build, 3 fail**, plus 1 more failing downstream of an orphan. |
| `sorry` / `admit` / `axiom`? | **none.** All grep hits are English prose in docstrings. |
| `native_decide`? | **143 occurrences in 39 files**; 72 distinct named `theorem`s are proved by it. |
| is the Agda lane's `--safe` discipline enforced here? | **No. Nothing enforces anything.** §4. |

---

## 1. What is there (counts verified, not quoted)

- `formal/pairfield/`: **132** `.lean` files — 1 root `Pairfield.lean`, **131**
  under `Pairfield/`. (The task brief said ~108; SEED-85 recorded 82 then 93.
  The tree grows fast; take the count, not the memory.)
- `lean-toolchain`: `leanprover/lean4:v4.33.0`.
- `lakefile.toml`: requires `mathlib` scope `leanprover-community` rev
  `v4.33.0`; `lake-manifest.json` pins mathlib commit
  `db584cd6d46c92f209a44c0f1c829460d327499d`, plus plausible, LeanSearchClient,
  importGraph and the usual transitive deps.
- `formal/pairfield/README.md` is **the stock `lake new … math` template**
  ("Under your repository name, click Settings…"). The lane has no README of
  its own. It documents nothing and claims nothing; the claims live in
  `notes/`.

### The gate hole, confirmed by build

`lakefile.toml` declares `lean_lib Pairfield` with **no `globs`**, so `lake
build` builds `Pairfield.lean` and its import closure only. `Pairfield.lean`
carries 110 imports, no duplicates, no dangling names. **21 modules under
`Pairfield/` are built by nothing:**

```
ArbitrarySmithClosure  ArgminDecomposition  Automata  BehavioralBFS
BuildCoverageChannel  CapabilityGraph  CharacterSectorClosure
EuclidDoublingForkMinimal  FiniteChuCalibration  FiniteChuResidualTransport
FiniteCoYonedaWeave  FiniteHistoryTotalization  GoldbachChebyshevAdapter
HolonomyDescent  InvariantCorrectiveClosure  LinearCongruenceChannel
ReachableChart  SieveRestriction  UpwardEscape  UpwardEscapeNecessity
VandermondeFrequencyResponse
```

(SEED-85 listed 16, then 13 on re-verification; the live number is 21 —
`ReachableChart` and `BehavioralBFS`, struck from that list as "since
imported", are orphans again. The list is not converging, which is itself the
argument for the one-line fix `globs = ["Pairfield.+"]` rather than periodic
recounts.)

---

## 2. Build results, per module

Reproduction (worked here, first attempt, through the proxy):

```
curl -sSfL https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain none
export PATH="$HOME/.elan/bin:$PATH"
elan toolchain install leanprover/lean4:v4.33.0
cd formal/pairfield && lake exe cache get && lake build
```

`lake exe cache get` fetched all 8690 mathlib oleans; no from-source mathlib
build was needed. Disk used ~10 GB.

### 2a. Gated tree: 1 failure

```
✖ [8814/8821] Building Pairfield.HeadDepthBlindnessAdapter
error: Pairfield/HeadDepthBlindnessAdapter.lean:111:16:
       Unknown constant `Nat.geom_sum_mul_of_one_le`
error: Pairfield/HeadDepthBlindnessAdapter.lean:110:50: unsolved goals
```

A mathlib lemma name that does not exist at the pinned revision. Everything
else in the closure — 109 modules, including all three `LEAN_STATUS.md` V3
targets `SumRigidity`, `Lorentz`, `ReversalRigidity` — builds.

**This is a green claim resting on an unrun build.** No note names
`HeadDepthBlindnessAdapter`, so nothing downstream is falsified by it; but the
lane has been broken at HEAD and nobody noticed, because nothing runs.

### 2b. Orphans: 18 build, 3 fail (+1 downstream)

| module | verdict |
|---|---|
| `CapabilityGraph` | **FAIL** — `:50 No goals to be solved`; `:54 rfl failed`, `C.pair x r` not defeq to `C.observe x = r` |
| `EuclidDoublingForkMinimal` | **FAIL** — `:63,:98,:149` failed to synthesize `Fintype (CausalSlot 1 × …)` and two `Decidable` instances |
| `HolonomyDescent` | **FAIL** — `:105,:116` `rewrite` cannot find `AddSubgroup.closure ?k ≤ ?K` in the goal |
| `ArbitrarySmithClosure` | **FAIL, downstream only** — imports `CapabilityGraph` |
| the other 17 + `ArgminDecomposition` | build clean |

### 2c. Prose these falsify

- `notes/HOLONOMY_DESCENT.md:31` — "The Lean module `Pairfield.HolonomyDescent`
  **checks** both equivalences and both uniqueness statements." It does not
  check. It does not compile. The mathematics in that note may well be right —
  the universal property of a quotient is a page of algebra — but the word
  "checks" is doing work it has not earned, and §"Relation to TWO_IDENTITIES"
  re-uses it ("the **checked** path-action instance").
- `notes/LEAN_TO_CUBICAL_PORT_MAP.md:42` describes `CapabilityGraph.lean`'s
  edge index and its "deliberately uninhabited open joint" as a fact about a
  Lean type. That type is in a file the kernel rejects.
- `notes/FINITE_HISTORY_TOTALIZATION.md` says "**Lean-checked** in
  `…/FiniteHistoryTotalization.lean`". That module *does* build — but it was
  built by nothing until today, so the claim was true by luck, not by gate.
  Same for the other 17 clean orphans: they are not vindicated, they are
  unfalsified.

The pattern is exactly the one the Agda lane hit twice tonight: **a module
named for a result is not a module containing a checked result.** Here it is
sharper, because for three modules there is no result at all — the file does
not typecheck.

---

## 3. `sorry`, `admit`, `axiom`, `native_decide`

- **`sorry`: 0.** The single grep hit is `RankOneWitness.lean:11`, a docstring
  boasting "with no `sorry`, no `native_decide`, and no appeal to an external
  oracle". (That boast is accurate for that file and the file builds.)
- **`admit`: 0.** Both hits are the English "admit"/"admits" in prose.
- **`axiom` declarations: 0.**
- **`native_decide`: 143 occurrences across 39 of 131 modules.** By nearest
  preceding declaration keyword: 97 under `theorem`, 51 under `example`, 20
  under `def`. **72 distinct named theorems** are proved by `native_decide`.
  - **Correction by addition, claude (Gentzen lineage), 2026-08-15.** §6 of
    this note is right that 72 is a syntactic attribution, and it is an
    undercount. An environment scan over `Lean.collectAxioms` (not grep) gives
    **113 theorems and 26 defs, in 28 modules**, carrying a generated
    `native_decide` axiom — two of those modules contain no `native_decide` at
    all and are tainted through imports, which no syntactic count can see.
    126 of the 142 tactic sites have since been converted to kernel `decide`
    or to proof; the residue is 8 theorems in 4 modules.
    See `notes/NATIVE_DECIDE_AUDIT.md`.

`native_decide` is not a stylistic choice. It emits a fresh axiom per use and
bypasses the kernel in favour of the compiler. Certified here, not asserted:

```
$ cat > Ax.lean <<'EOF'
import Pairfield.EuclidCoefficientTrace
#print axioms Pairfield.kuttaka610WitnessedCoefficients_values
EOF
$ lake env lean Ax.lean
'Pairfield.kuttaka610WitnessedCoefficients_values' depends on axioms:
 [Pairfield.kuttaka610WitnessedCoefficients_values._native.native_decide.ax_1_1,
  Pairfield.CoefficientWitness.negFive._native.native_decide.ax_1,
  Pairfield.CoefficientWitness.negOne._native.native_decide.ax_1,
  Pairfield.CoefficientWitness.one._native.native_decide.ax_1,
  Pairfield.CoefficientWitness.two._native.native_decide.ax_1,
  Pairfield.CoefficientWitness.zero._native.native_decide.ax_1]
```

Compare, from the same build:

```
'Pairfield.convSq_inj_nat' depends on axioms: [propext, Classical.choice, Quot.sound]
```

So the lane contains **both** kinds of theorem, and the written record does not
distinguish them. `notes/LEAN_STATUS.md` (2026-08-11) says under **Axiom
audit**: "`#print axioms` for all five theorems returns exactly
`[propext, Classical.choice, Quot.sound]` … nothing else, no `sorryAx`", and
under Build: "Zero sorries, **zero custom axioms**." Both sentences were true
of the five theorems then in the lane. Neither is true of the lane today, and
the note's scope line does not say so — it reads as a lane-wide green. It is a
green claim that outgrew its evidence, which is the `exp27` failure mode in a
different medium.

**What `native_decide` is worth.** CLAUDE.md permits "exact / certified
symbolic computation … a finite exhaustive verification". A `native_decide` of
a concrete finite fact *is* a finite exhaustive verification — but one carried
out by the compiler and inserted as an axiom, i.e. trusting the compiler,
the run, and the extraction, in exactly the way CLAUDE.md's §"substrate"
argument says a Python script is untrustworthy. `decide` (kernel-checked, 151
occurrences) has no such cost. The lane should distinguish the two, and the
72 theorems should be labelled.

---

## 4. The asymmetry, which is the real finding

| | Agda lane | Lean lane |
|---|---|---|
| unsafe-escape ban | `--safe`, no postulates, no holes — stated in CLAUDE.md | **nothing** |
| checked-by-flag | `--cubical --safe` in each module header | `weak.linter.mathlibStandardSet = false` in `lakefile.toml` — a *linter* switch, not a soundness one |
| whole-tree gate | `Everything.agda` (itself holed — SEED-85 §2) | `Pairfield.lean`, 21 orphans |
| CI | none for Agda | **none for Lean** |
| local gate | `formal/check.sh` runs 5 Agda files then `lake build` | same script; it has been failing at `lake build` and nobody ran it |

The repository's two CI workflows are `epistemic.yml` and `no-python.yml`.
Neither invokes `lake` or `agda`. `.githooks/pre-commit` and `pre-push` do not
either. So: **the only Python in this repository that is enforced by machinery
is its prohibition, and the mathematics that replaced it is enforced by
nothing.** `epistemic.yml` additionally runs `python3` three times, which is a
separate small embarrassment.

CLAUDE.md says of the Agda lane "`--cubical --safe`, no postulates, no holes"
and of the Lean lane only "(`formal/pairfield/`) for the analytic lane". That
omission is not neutral; it is the reason 72 theorems carry generated axioms
without anyone having decided that they may.

---

## 5. Recommended, cheapest first

1. `globs = ["Pairfield.+"]` in `lakefile.toml`. One line; closes the 21-module
   hole permanently and makes the count stop mattering.
2. Fix or quarantine the 4 broken modules. `HeadDepthBlindnessAdapter` is a
   one-name repair (find the current mathlib spelling of
   `Nat.geom_sum_mul_of_one_le`). The other three are real proof breakage.
3. Strike the false "checks" in `notes/HOLONOMY_DESCENT.md` and scope-limit
   `notes/LEAN_STATUS.md`'s axiom audit to its five theorems.
4. Add to CLAUDE.md, alongside the Agda sentence: the Lean lane forbids
   `sorry`, `admit` and `axiom` (currently true — keep it true), and any
   `native_decide` must be declared at its use site as a compiler-trusting
   step, with `decide` preferred wherever it terminates.
5. A CI job that runs `formal/check.sh`. Everything above is discovered by one
   `lake build`; the reason it went undiscovered is that nothing ran it.

---

## 6. Scope limits

- I did not read all 131 modules. §2c's claim-versus-content check covers the
  4 broken modules and the notes that name them, plus the three
  `LEAN_STATUS.md` targets. The other ~100 modules build, which says they are
  well-typed, **not** that their theorem statements match the prose that cites
  them. That sweep is the obvious next task and I did not do it.
- The 97/51/20 split of `native_decide` by declaration kind is a syntactic
  attribution (nearest preceding declaration keyword), not a Lean-level one.
  The 72-distinct-theorem figure inherits that. The `#print axioms` evidence in
  §3 is exact for the two theorems shown.
- Timings and disk are this container's; the mathlib cache fetch dominates
  (~8690 files) and is the only step likely to fail elsewhere.

---

## 7. Repair log — 2026-08-15 (claude, de Bruijn lineage)

Addition, not overwrite: §§0–6 above record the state at audit time and are
left standing. This section records what was changed in response, on the same
toolchain (Lean 4.33.0, mathlib `db584cd`, cache warm in the same container).

### 7a. `globs` (recommendation 1)

`lakefile.toml`'s `lean_lib Pairfield` now carries

```
globs = ["Pairfield", "Pairfield.+"]
```

The 21-module orphan hole is closed structurally: a module under
`Pairfield/` can no longer avoid the kernel by not being imported. The count in
§1 stops mattering, which was the point of preferring the one-line fix to
periodic recounts.

### 7b. The four broken modules — all four now check

| module | diagnosis | repair |
|---|---|---|
| `HeadDepthBlindnessAdapter` | `Nat.geom_sum_mul_of_one_le` never existed; the lemma is in the **root** namespace, `Mathlib/Algebra/Ring/GeomSum.lean:161`, for a `CommSemiring` with `OrderedSub` (which `ℕ` is) | `_root_.geom_sum_mul_of_one_le`. One token. Statement unchanged. |
| `HolonomyDescent` | `differenceSubgroup` is a `def`, so `rw [AddSubgroup.closure_le]` found no `closure` in the goal (`:105`, `:116`) | `rw [differenceSubgroup, AddSubgroup.closure_le]`. Statement unchanged. |
| `EuclidDoublingForkMinimal` | **not a proof failure — an import gap.** `Fintype (Fin 1 × Bool)` does not synthesize in this file's environment: `Mathlib.Data.Fintype.Prod`, `.Option`, `.Pi` were never imported. Separately, `formsBoth` is a `def`-wrapped `Prop`, which instance search will not unfold, so `Decidable formation.formsBoth` failed | added the three imports; added two explicit `Decidable` instances discharged by `unfold formsBoth; infer_instance`. Statements unchanged. |
| `CapabilityGraph` | **the statement was false.** `FiniteChu.pair` is an arbitrary `state → response → Prop` field; nothing ties it to `observe`. `chuToExecutableCapability (C : FiniteChu) : ExecutableChuCapability C` discharged `read_pair : ∀ x r, C.pair x r ↔ read x = r` by `rfl`, and the kernel was right to refuse: take `pair := fun _ _ => True` on any `C` with two responses. | added `Calibrated C := ∀ x r, C.pair x r ↔ C.observe x = r` as an explicit hypothesis, and `bit_calibrated : Calibrated FiniteChu.bit` (by `rfl`, since `bit.pair` *is* equality and `bit.observe` *is* `id`), so `bitChuCapability` and everything downstream is unaffected. `ArbitrarySmithClosure`, which failed only downstream, follows. |

The `CapabilityGraph` case is the one worth keeping. It is not the same species
as the other three: those were a wrong name, a missing `unfold`, and three
missing imports — clerical breakage that a running build would have caught the
day it was written. This one was a false theorem that compiled in nobody's
head. It is the `exp27` failure mode with the sign flipped: not a fitted number
standing in for a derivation, but a *`rfl`* standing in for a hypothesis. The
repair adds the hypothesis; it does not weaken the conclusion, and the only
consumer (`bit`) satisfies it.

Consequently `notes/LEAN_TO_CUBICAL_PORT_MAP.md:42` — which describes
`CapabilityGraph.lean`'s edge index and "deliberately uninhabited open joint"
as facts about a Lean type — now describes a file the kernel accepts. Its
substantive claim (the Cubical `smith` inhabits the joint Lean leaves open) was
never in question and is untouched.

### 7c. What is still red, and whose it is

`lake build` at the moment of writing exits **1**, and none of the failures are
in the modules above. Four sibling agents are editing `formal/pairfield/` in
this shared worktree concurrently; `ps` showed a second `lake build` running
against the same `.lake` directory throughout. Two consequences, both verified
rather than assumed:

- **Transient failures.** Three consecutive `lake build` runs failed on three
  *different* modules, every time with `failed to open file '….olean': No such
  file or directory` — the other build had the dependency mid-write. Each named
  module built clean under `lake env lean` immediately after. These are races,
  not breakage.
- **Real, and not mine.** `Pairfield/ChartQuotient.lean:236` (`unexpected token
  'set_option'`, plus a `whnf` heartbeat timeout at `:239`) and
  `Pairfield/ParityRigidity.lean:131` (`simp` failed) are a sibling's in-flight
  `native_decide` → `decide` conversion, visible as uncommitted/untracked edits
  in `git status`. `CapabilityGraph` reports one error only because it imports
  `ChartQuotient`.

So the honest statement is: **the four modules this section repairs are
kernel-checked, and the tree as a whole is red for reasons introduced after
this audit began.** Verified per-module with `lake env lean`, which is
race-free; the whole-tree exit code is not currently a stable measurement of
anything, and will not be until the concurrent edits land.

### 7d. Not done

Recommendations 3 (partially — `HOLONOMY_DESCENT.md` is corrected by addition,
`LEAN_STATUS.md`'s axiom audit is still unscoped), 4 (CLAUDE.md's Lean clause —
the Curry-lineage message says this was added; not re-verified here) and 5 (CI
running `formal/check.sh`) are untouched. The 72 `native_decide` theorems are
untouched by me; a sibling is converting some to `decide` as of this writing.

---

## 8. Re-derivation, 2026-08-20 (claude, Nālandā fleet) — addition, nothing above altered

Ran the lane rather than reading it, on the owner's machine (Lean 4.33.0,
mathlib `db584cd`, warm cache). Full detail:
`notes/NAYABHEDE_SANKSEPO_NA_VIDYATE_TheLeanLaneClosureAuditAndTheRefusalToWireIt.md`.

**§7a's fix holds and §7c's red has drained.** `lake build` → *Build completed
successfully (8840 jobs)*, exit 0. All 133 modules have oleans; `lake exe
axiom_gate` imports 134 modules and passes with 1 allowlisted entry. The orphan
count is **0** and stays 0 by construction, so §1's list has stopped mattering
exactly as §7a intended.

**What the orphan question does not detect, and what replaced it.** §1 and §7a
both ask "is it BUILT". Nobody asked "is it REACHABLE", and today those had
different answers: **114 of 133** modules were in `Pairfield.lean`'s import
closure. Nineteen were not, fourteen of them cited by module path in `notes/`.
The reason recorded in `Pairfield.lean` for two of the exclusions — "that module
imports all of Mathlib" — is false as a discriminator: eight modules carry a
bare `import Mathlib` and **six were already in the root**, `SumRigidity` at
line 2. Repaired (133/133) and guarded by
`scripts/check-lean-root-closure.sh`, falsified on four constructed cases.

**§5's recommendation 5 (CI) is now moot and worse than it was.** There is no
`.github/workflows/` at all — commit `d631078e`, "demolish the checks: all three
workflows deleted by direct owner order". `notes/AXIOM_GATE.md` §0 still cites
`.github/workflows/formal-gates.yml` as a wiring; that file does not exist.
`formal/check.sh` is the only runner, and until today it invoked neither
`check-lean-globs.sh`, `check-lean-root-closure.sh`, nor
`GuptaNaya_TheConcealedRouteMustBeDeclaredAtItsSite.sh`. All three are wired in
now. §4's sentence — *the mathematics is enforced by nothing* — had recurred at
the level of the checks written to answer it.

**One artefact.** `.lake/build/lib/lean/Pairfield/SuppliedContinuation.olean`
exists with no source. Build residue, uncommitted, invisible to the axiom gate
(it walks source), removed by `lake clean`.
