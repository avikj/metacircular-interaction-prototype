# The axiom gate: Lean's `--safe`, and what it found

**Author.** claude (Milner lineage), 2026-08-15.
**Substrate.** elan + Lean `4.33.0` + mathlib `v4.33.0`, warm cache, in-container.
Every number below is a build verdict or a `Lean.collectAxioms` scan, not a grep.

---

## 0. Verdict

| question | answer |
|---|---|
| does `lake build` pass? | **Yes.** `Build completed successfully (8839 jobs)`, exit 0, twice. |
| is the gate installed? | **Yes.** `formal/pairfield/AxiomGate.lean`, `lake exe axiom_gate`. |
| what does it find? | **2 theorems in 1 module** (`DiagonalSmithRoute`), both allowlisted with reasons. |
| what did it find before I fixed anything? | **13 theorems in 5 modules.** |
| cost | ~4 min on a warm build (it imports all 133 modules in one environment). |
| is it wired? | `formal/check.sh` and `.github/workflows/formal-gates.yml`. **CI is inert — §5.** |

---

## 1. The build is green, so the gate is not theatre

`notes/NATIVE_DECIDE_AUDIT.md` §5 proposed this gate and refused to install it,
on the grounds that *a gate over a red build is theatre*. The reasoning is
exact and worth keeping: a module that fails to typecheck contains no theorems,
so it contributes nothing to an axiom scan, and its silence is indistinguishable
from cleanliness. A red build makes the gate **lie in the safe direction**,
which is the worst kind.

That prerequisite is now met. `lake build` in `formal/pairfield/` completed with
exit 0 at 8839 jobs, twice, in this container. The `LEAN_LANE_AUDIT` §7c
instability — several agents sharing one `.lake`, three consecutive runs failing
on three different modules with `failed to open file '….olean'` — did not recur;
those were races and they have drained. The two prerequisites recommended there
(`globs`, the four repaired modules) are in `lakefile.toml` and in the tree; I
read them rather than trusting the claim.

## 2. What the gate is

`formal/pairfield/AxiomGate.lean`, ~120 lines, `lake exe axiom_gate`.

1. Walks `Pairfield/` on disk and imports **every** `.lean` file it finds (133
   modules). It does not read an import list, because an import list is the
   thing that rotted twice already (`LEAN_LANE_AUDIT` §1: 21 orphans;
   `PIN_SWEEP_NATURALMACHINE`: 34 in Agda).
2. For every non-internal `Pairfield.*` declaration that is a `theorem`, `def`
   or `axiom`, calls `Lean.collectAxioms` — the function behind `#print axioms`.
3. Passes iff the axiom set is a subset of `{propext, Classical.choice,
   Quot.sound}`, **or** the declaration is named in `axiom-allowlist.txt`.

Three design points, in Milner's sense that the type system should make the bad
state unrepresentable rather than discouraged:

- **It is not taught the names of the escape hatches.** It allows three axioms
  and rejects everything else. `native_decide`, `sorryAx`, a hand-written
  `axiom`, and whatever Lean grows next all fail it without an edit. A grep-based
  gate must be told what to fear; this one must be told what to trust, and the
  trusted set is three names long and will not grow.
- **It sees taint through imports.** `AdaptiveResidualCycleDeletion` and
  `AdaptiveResidualPositionCycleAdapter` were tainted at audit time while
  containing zero occurrences of `native_decide` (`NATIVE_DECIDE_AUDIT` §1).
  Grep counts sites; only the kernel counts dependencies.
- **The allowlist reports its own rot.** Entries whose declaration is now clean
  print `ALLOWLIST-STALE`; entries naming a declaration that no longer exists
  print `ALLOWLIST-ABSENT`. Neither fails the gate — a rename should not turn a
  soundness gate red — but both are printed every run. All three behaviours
  (fail, stale, absent) were exercised against a scratch allowlist, not assumed.

## 3. The residue: 13 → 2, and why it moved

The gate was first run against an **empty** allowlist, deliberately, so that the
residue would be seen before it was named. It reported **13 theorems in 5
modules**, not the 8 in 4 the audit predicted. The discrepancy is not an error in
either count; it is the gate doing its job:

- `EuclidDoublingForkMinimal` was **broken at HEAD** when the audit ran, so its
  4 `native_decide` sites were recorded as "untested" and its theorems did not
  exist to be counted. A sibling repaired the module (`LEAN_LANE_AUDIT` §7b);
  repair made 5 tainted theorems appear. *Fixing a module can raise the axiom
  count, and only a gate that runs after the build will notice.*
- All four of those sites are now **converted to kernel `decide`** by me. Three
  needed nothing; `noFormationFormsBoth` (a `∀` over the complete finite
  schedule type) needed `set_option maxRecDepth 100000 in` and costs 79 s. This
  is the intended trade — a slow kernel proof instead of a fast axiom — and it
  retires 5 of the 13. The audit's §4d is thereby closed: those sites were
  never a reducibility obstruction, only an unbuilt module.
- The other 6 were retired concurrently by claude (Church lineage), commit
  `82b8dc07`, replacing `Finset.sort` in `NativeReversePairTraversal.pairList`
  with a kernel-reducible enumeration — the follow-up `NATIVE_DECIDE_AUDIT` §4a
  named as its highest-value item.

**Remaining: 2 theorems, `DiagonalSmithRoute`.** `kuttaka610Transcript_replays_compact_certificate`
and `kuttaka610Transcript_actionCost_minimal`. Kernel reduction stalls on
projections out of `ComputableSmith2x2.reduceDiagonal`; the blocking
sub-definition was not isolated by the audit and is not isolated here, and
neither of us will name a cause we did not observe. They are allowlisted, with
that reason written out, and `DiagonalSmithRoute.lean` now carries the
`-- TRUSTS-COMPILER:` header the audit proposed. It is the only module in the
lane that carries one, and the gate is what keeps that true.

So the lane's honest state is: **8837 of 8839 jobs' worth of mathematics rests
on nothing but `propext`, `Classical.choice` and `Quot.sound`; two theorems rest
on the Lean compiler; and this is now a machine-checked sentence rather than an
audited one.**

> **Superseded, same day (claude, Skolem lineage;
> `collab/messages/0846-skolem-diagonalsmith.md`).** The blocking sub-definition
> was isolated: `Nat.xgcdAux`, reached through `Nat.gcdA`/`gcdB` in
> `ComputableSmith2x2.fromNatGcdOne`, is compiled to `Nat.strongRec` — well-founded,
> hence irreducible **to the elaborator**, which is what `decide` uses. The kernel
> unfolds it fine. All five sites are now `decide +kernel`; both theorems return
> exactly `{propext, Classical.choice, Quot.sound}`; `lake build` green at 8839
> jobs; `lake exe axiom_gate` reports **OK, allowlisted: 0**. The allowlist is
> empty, the `TRUSTS-COMPILER` header is gone, and **no module in the lane carries
> one**. The lane's honest state is now: all 8839 jobs' worth of mathematics rests
> on nothing but `propext`, `Classical.choice` and `Quot.sound`. Details and the
> general lesson (elaborator-irreducible ≠ kernel-irreducible) in
> `NATIVE_DECIDE_AUDIT.md` §4b.

## 4. The allowlist is the load-bearing part

An allowlist without reasons rots into a rubber stamp within one shift. The file
therefore requires, per entry: the axiom depended on, the **observed** reason
kernel checking fails, and what would remove it. The `DiagonalSmithRoute` entry
has all three; if a future entry does not, the correct action is to delete it,
let the gate go red, and make someone look.

This is the same rule CLAUDE.md applies to numbers: a constant without its
$X$-dependence is worse than no constant, because it looks like knowledge. An
allowlist entry without its reason is worse than a red gate, because it looks
like a decision.

## 5. CI is wired and inert, and this is stated deliberately

The gate is a step in `.github/workflows/formal-gates.yml`'s `lean-build` job
(itself `workflow_dispatch`-only, because `lake exe cache get` pulls ~10 GB), and
a line in `formal/check.sh` after `lake build`.

**GitHub Actions on this account never starts.** Every run shows `runner_id 0`,
no steps, logs 404 (`notes/CI_FORMAL_GATES.md` §2). Nothing I wired has executed
in a runner and I am not claiming it has. It is correct-but-inert, and it begins
working the moment the owner re-enables Actions. The verdicts in §§0–3 are from
`lake exe axiom_gate` run **in this container**, which is where the evidence is.

`formal/check.sh` is the path that actually runs today, and it is the one to run.

## 6. Does the Agda lane need the analogue?

**Mostly no, and the residue is precisely locatable.**

`--safe` is strictly stronger than this gate in the direction that matters. It is
checked by the compiler that produces the artifact, so it cannot be skipped,
forgotten, or run against a stale build; it rejects postulates, holes, `trustMe`,
`{-# TERMINATING #-}` and unsafe pragmas at typecheck time rather than after. The
Lean gate is a second pass over a finished environment and is therefore only as
current as the last build. Nobody should read this note as "Agda now needs a
script too".

What `--safe` does **not** give, and what the Lean gate does:

1. **`--safe` is per-module.** A file that omits the pragma is checked without
   it, silently. Agda has no lane-wide assertion; the convention is a header
   comment repeated 272 times. A three-line grep that every module under
   `formal/cubical/` begins `{-# OPTIONS --cubical --safe #-}` would close that,
   and unlike the Lean gate it needs no toolchain, so it can run in the CI that
   never starts as cheaply as the import-closure checks already there. **This is
   the one thing I would add, and I did not add it** — I did not audit the Agda
   headers and will not gate on a property I have not measured.
2. **`--safe` says nothing about reachability.** A safe module that no aggregate
   imports is safe and irrelevant; `PIN_SWEEP_NATURALMACHINE` found 34 such
   orphans. That gap is already closed by `scripts/check-agda-closure.sh`, which
   is the Agda analogue of `globs`, not of this gate.

So the honest mapping is: `globs` ↔ `check-agda-closure.sh` (both closed);
axiom gate ↔ `--safe` (Lean's is now installed, Agda's is stronger and was
always there); and the one asymmetry left is that Agda's is asserted per file
rather than checked lane-wide. That is a grep, it is cheap, and it is the open
item this note leaves behind.

## 7. Scope limits

- The gate scans the `Pairfield.*` namespace. A `native_decide` axiom reachable
  only through a mathlib-namespaced declaration would be missed. None exists
  (mathlib is a pinned revision built from cache), but the gate does not prove it.
- It gates on *axioms*, i.e. on what a theorem stands on. It says nothing about
  whether a theorem's **statement** matches the prose that cites it. That sweep
  is `LEAN_LANE_AUDIT` §6's open item and is still open; it is the larger risk
  and no gate of this kind can touch it.
- `examples` emit no reachable axiom, so the `ChartQuotient:238` timeout site
  (`NATIVE_DECIDE_AUDIT` §4c) is invisible to the gate. Correct, and worth
  knowing: the gate measures dependency, not hygiene.
- The 4-minute figure is this container's, dominated by importing 133 modules
  into one environment. It is not a bound.
- I did not read the 133 modules. I read `lakefile.toml`, `check.sh`, the CI
  workflow, both audits, and the modules I edited.

## 7a. The `example` blindness, closed — added 2026-08-15, claude (Post lineage)

**Addition, not revision.** §7's third bullet is exactly right and is the
defect this section closes. Written by its author as a scope note, it was
independently rediscovered as a live hole by `DECIDE_STATEMENT_SWEEP` §5, which
found that the lane's **single surviving `native_decide` was itself inside an
anonymous `example`** — i.e. the gate would certify the tree while structurally
unable to look at its only remaining oracle use. A decision procedure that
cannot see part of its domain is not a decision procedure.

**What I verified before acting** (every verdict from a run in this container):

| claim | verdict |
|---|---|
| `lake exe axiom_gate` passes at HEAD | **Yes**, `OK … (allowlisted: 0)`, 3 m 25 s |
| `native_decide` *tactic* sites in the tree | **1**, `ChartQuotient.lean`:238. The other 4 string matches are prose that disclaims it (`DECIDE_STATEMENT_SWEEP` §4/D3 reproduced exactly) |
| that site is inside an anonymous `example` | **Yes**, `example :` at :237 |
| decide-carrying declarations under `Pairfield/` | **195**, not the sweep's headline 200 — its own components (93 `theorem` + 69 `example` + 31 `def` + 1 `instance` + 1 `inductive`) sum to 195, and rerunning its awk verbatim gives 195 lines. The 69 and the 93 are right; only the total was wrong |
| `.lean` files under `Pairfield/` | **132**, no subdirectories (the gate's "133 modules" includes the `Pairfield.lean` root) |

The 195 correction is worth stating in this note's own terms: a count is a
claim and needs its scope quoted with it, and this one had a scope quoted so
precisely that the arithmetic error was recoverable from the note itself.

**The fix, in both halves, because neither subsumes the other.**

1. **Structural (option b): the example is now a theorem.**
   `ChartQuotientWitness.quotientCard_eq_three`, stating
   `Fintype.card (Quotient (dfaFutureSetoid automaton)) = 3` — the four-row
   chart automaton has three behavioural future classes. It was worth naming:
   it is the file's whole point, and the docstring above it already asserted it
   in prose. Naming brings it **inside this gate permanently**, which is the
   only fix that does not depend on anyone remembering.

   The demonstration that the hole was real is the pair of runs on one
   unchanged oracle: with the site anonymous the gate reports `OK
   (allowlisted: 0)`; with it named and the allowlist still empty the gate
   reports

   ```
   axiom_gate: FAIL — 1 declaration(s) outside the trusted axiom set
     THM	Pairfield.ChartQuotientWitness.quotientCard_eq_three
         axioms: [….quotientCard_eq_three._native.native_decide.ax_1_1]
   ```

   Note the axiom's shape: Lean 4.33 emits a **per-declaration** native axiom,
   not the `Lean.ofReduceBool` the older notes name. §2's design point survives
   the observation and is strengthened by it — a gate taught the names of the
   escape hatches would have missed this one; a gate taught only what to trust
   catches it without an edit.

2. **The oracle is NOT forced away — it is recorded.** The removal was
   attempted and refused on measurement. `NATIVE_DECIDE_AUDIT` §4c had it as a
   >20 min non-terminating `decide`; I substituted `decide +kernel`, the tactic
   that retired the `DiagonalSmithRoute` entries (§3's superseding note), and
   the build was **killed with exit 137 — OOM — after 123 s**. So this is not
   the elaborator-irreducibility case `+kernel` fixes; it is a genuine cost
   case, and it is a *memory* blowup, not only a stall. That is a second,
   independent, differently-shaped observation of the same obstruction, and it
   is what the allowlist entry now records, with the removal path (a `Fintype`
   instance computed from the ChartStateBFS row table, or an explicit bijection
   to `Fin 3` — neither is written). `ChartQuotient.lean` carries the
   `-- TRUSTS-COMPILER:` header, and is now the only module in the lane that
   does.

   **The lane's honest state, corrected.** §3's superseding note says "all 8839
   jobs' worth of mathematics rests on nothing but `propext`,
   `Classical.choice` and `Quot.sound`". That was true of everything the gate
   could see and false of the tree: one compiled-code result was hiding in the
   blind spot the whole time. The gate now reports `OK … (allowlisted: 1)`, and
   that `1` is the difference between an exception and an oversight.

3. **Syntactic (option a): `scripts/check-lean-example-oracles.sh`**, wired into
   `formal/check.sh` (before the expensive steps, beside
   `check-agda-pragmas.sh`) and into `formal-gates.yml`'s cheap job. It fails
   if any column-0 `example` block contains `native_decide`, `ofReduceBool`,
   `ofReduceNat`, `sorryAx` or `sorry`, comments stripped. Toolchain-free, so
   it runs where the closure checks do.

   It complements this gate and replaces nothing: **the axiom gate sees
   dependencies and is blind to anonymous declarations; the script sees
   anonymous declarations and is blind to taint through imports** — precisely
   the failure (`AdaptiveResidualCycleDeletion`, §2) the axiom gate was built
   to catch. Neither alone covers the lane.

   **Observed failing and passing, not assumed** — the standard this corpus set
   for the staleness path in §2. Against the tree as found it exited 1 naming
   `ChartQuotient.lean:237`; against a scratch lane it flagged a fresh
   anonymous `example`, ignored the same token inside a `--` comment, and
   ignored named `theorem`s around it; after the rename it exits 0.

**What this does not close.** The script is a site check, not a dependency
check, and shares `DECIDE_STATEMENT_SWEEP` §1's warning about syntactic
attribution. It only knows the oracle tokens it is told, which is the weakness
§2 correctly identifies in grep-shaped gates — that is why it is the second
line and not the first. And 68 anonymous `example`s carrying a kernel `decide`
remain unnamed: none rests on an oracle (this script's exit 0 is the evidence),
so none is a soundness hole, but they are still uncitable, which is
`DECIDE_STATEMENT_SWEEP` §5's separate and still-open recommendation. I did not
name them; whether they are worth naming is a lane judgement, and I did not
want a soundness fix to arrive carrying 68 unrelated edits.

---

## Addendum, 2026-08-20 (claude, Nālandā fleet) — one wiring claim in §0 is stale

§0 records the gate as wired into "`formal/check.sh` and
`.github/workflows/formal-gates.yml`. **CI is inert — §5.**" It is worse than
inert: **there is no `.github/` in this repository.** Commit `d631078e`,
"demolish the checks: all three workflows deleted by direct owner order",
removed all of them. `formal/check.sh` is the only runner and it does invoke
`lake build` then `lake exe axiom_gate`, so the gate itself is reachable; the
CI half of that sentence names a file that does not exist.

The gate's own verdict, re-run today on the owner's machine (Lean 4.33.0,
mathlib `db584cd`): `importing 134 modules under Pairfield/` — `OK — every
Pairfield declaration rests on [propext, Classical.choice, Quot.sound]
(allowlisted: 1)`, exit 0. §0's "2 theorems in 1 module" has since become 1
allowlisted entry, which is the file's self-pruning working as designed.
