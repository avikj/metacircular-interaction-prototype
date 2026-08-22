# नयभेदे सङ्क्षेपो न विद्यते — the Lean lane's closure, re-derived, and the refusal to wire it to the machine

**Author.** claude, 2026-08-20, Nālandā fleet, Lean lane.
**Substrate.** elan + Lean `4.33.0` + mathlib `v4.33.0` (`db584cd`), warm cache,
on the owner's machine. Every number below is a build verdict, a
`Lean.collectAxioms` scan, a closure computed by running it, or a wall-clock
reading with its conditions stated. None is fitted.

The title is §7 of `notes/AHIMSA_SUTRA_VISTARA.md`, which I was told to read in
full and did: *where the standpoints differ, collapse does not exist* — not
forbidden, not impolite, **does not exist**, because if the nayas are distinct
there is no single object equal to both threads. That sentence is the finding
of §4 below, arrived at independently and then recognised.

---

## 0. Verdict

| question | answer, re-derived today |
|---|---|
| modules under `formal/pairfield/Pairfield/` | **133** |
| built by nothing? | **0.** `globs = ["Pairfield", "Pairfield.+"]` is in `lakefile.toml`; `lake build` = **8840 jobs, exit 0**. The Agda lane's 199-of-776 shape does **not** hold here. |
| reachable from `Pairfield.lean`? | **114 of 133** before today. 19 modules answered nothing to `import Pairfield`. **Now 133 of 133.** |
| `sorry` / `admit` / `axiom` | **0**, confirmed. |
| axiom state of the whole lane | `lake exe axiom_gate`: **every** `Pairfield` declaration rests on `{propext, Classical.choice, Quot.sound}`, one allowlisted exception (`ChartQuotientWitness.quotientCard_eq_three`). Imported all 134 modules in one environment. |
| fitted constants (the `exp27` failure mode) | **none found.** §5. |
| should the analytic lane be reachable from the running machine? | **No.** §4, with the argument, not the preference. |
| an empty module carrying Mādhava's name | **found, and filled.** §3. |

---

## 1. The orphan question, answered by running it, and the answer is not the Agda answer

The charge assumed the Lean lane would look like the Agda lane's audit
(~199 of 776 outside the closure). It does not, and the reason is that a
sibling already took the structural fix rather than the recount:
`LEAN_LANE_AUDIT.md` §7a put `globs = ["Pairfield", "Pairfield.+"]` in
`lakefile.toml`. With a directory-wide glob **a module cannot avoid the kernel
by not being imported**, so the orphan count is zero by construction and stays
zero. Verified three ways, not asserted:

- `lake build` → `Build completed successfully (8840 jobs).`, exit 0;
- every one of the 133 `.lean` files has a corresponding `.olean` under
  `.lake/build/lib/lean/` (checked file by file, 0 missing);
- `lake exe axiom_gate`, which walks the **disk** rather than an import list,
  reports `importing 134 modules under Pairfield/` (133 + the root) and passes.

**So there was nothing unchecked.** What there was instead is the subject of §2,
and it is a different fault that the orphan question does not detect.

### 1a. One stale artefact, recorded because silence about it is the habit under repair

`.lake/build/lib/lean/Pairfield/SuppliedContinuation.olean` exists with **no
source file**. Local build residue, not committed, and the axiom gate is immune
(it walks source). But `import Pairfield.SuppliedContinuation` succeeds in this
container against a module nobody can read. `lake clean` removes it; noting it
because a build directory that answers for a deleted module is precisely the
"green claim resting on an unrun build" shape one level down.

---

## 2. The 19, and the reason that was given for them

Nineteen modules were outside `Pairfield.lean`'s import closure:

```
ArbitrarySmithClosure  Automata  BuildCoverageChannel  CapabilityGraph
CharacterSectorClosure  EuclidDoublingForkMinimal  FiniteChuResidualTransport
FiniteCoYonedaWeave  FiniteHistoryTotalization  GoldbachChebyshevAdapter
HolonomyDescent  InvariantCorrectiveClosure  LinearCongruenceChannel
Madhava  ParityRigidity  SieveRestriction  UpwardEscape
UpwardEscapeNecessity  VandermondeFrequencyResponse
```

They are not obscure. **Fourteen of the nineteen are cited by module path in
`notes/`** (`grep -lE 'Pairfield[./]<M>\b|<M>\.lean' notes/*.md`):
`CapabilityGraph` in 5 notes, `ArbitrarySmithClosure`, `HolonomyDescent`,
`InvariantCorrectiveClosure`, `ParityRigidity` and
`VandermondeFrequencyResponse` in 4 each.

### 2a. The reason was checkable and it was false

`Pairfield.lean` carried a reason for two of the exclusions:

> `Pairfield.ArbitrarySmithClosure` inhabits `CapabilityGraph`'s named open
> edge. It is kept out of the default target for the same reason
> `Pairfield.CapabilityGraph` always was: **that module imports all of
> Mathlib.**

One grep falsifies it. Eight modules under `Pairfield/` carry a bare
`import Mathlib`:

```
BoundedPrimePair  DirectSmith2x2  Lorentz  ParityRigidity
RankOneWitness  SumRigidity  VandermondeFrequencyResponse  ReversalRigidity
```

**Six of those eight were already in the root's import list.** `SumRigidity`
was **line 2 of the file**. The root's import closure has therefore been all of
Mathlib since long before the exclusion comment was written, so the stated
ground did not distinguish an excluded module from an included one.

This is not a wrong reason; a wrong reason can be contradicted. It is a reason
that does not discriminate, which is the shape `AHIMSA_SUTRA_VISTARA.md` §2
names:

> यो नयं न वदति स नयं गोपयति । गुप्तो नयो दुर्नयो भवति ।
> दुर्नयो न मिथ्या — मिथ्या प्रतिषेध्यम् ।

*A concealed standpoint becomes a durnaya; a durnaya is not false, and that is
what makes it worse.* It read as diligence. It survived because nobody ran the
grep that kills it, which took under a second.

(Not claimed: that the Jaina logicians wrote about import graphs. Theirs is the
principle that the route to a claim is part of the claim, and that concealing
the route is a distinct fault from being wrong. Siddhasena Divākara,
*Sanmatitarka*, Prakrit, c. 5th–6th c.; Akalaṅka, 8th c.)

### 2b. What was done, and what it cost — derived, not measured

All nineteen are now imported by `Pairfield.lean` (110 → 129 import lines,
133 of 133 reachable). The header, which described the file as "the V3 ledger
root: machine-checked targets from `notes/VV.md`" while being an accretion, now
says what the file is.

The cost of adding them is **zero, and this is derivable rather than
measurable**: the set of build targets is fixed by `globs`, which already
covered all 133, so the target set before and after is *identical*. Confirmed
anyway — `lake build` after the change: **8840 jobs, exit 0**, the same number.
What changed is only what `import Pairfield` reaches.

### 2c. The guard, falsified before it was believed

`scripts/check-lean-root-closure.sh` — no toolchain, computes the closure and
fails on any module that is neither reachable nor named in
`formal/pairfield/root-exclusions.txt` **with a reason**. Exclusions are
allowed; the reason goes in a file a reader can check against the tree, because
the last exclusion reason in this lane lived in a comment beside one import and
was false of six modules three lines above it.

Falsified on four constructed cases before being believed, on the model of
`scripts/GuptaNaya_…sh`:

| case | expected | observed |
|---|---|---|
| drop one import, no exclusions file | FAIL naming it | FAIL, `Pairfield.SieveRestriction`, exit 1 |
| same, module declared in exclusions | pass | exit 0 |
| exclusion for a module that is reachable again | report, not fail | reported as prunable, exit 0 |
| new module appears on disk, unimported | FAIL naming it | FAIL, `Pairfield.ZZTest`, exit 1 |

It complements `check-lean-globs.sh` and does not replace it: **globs answers
"is it built", this answers "is it reachable"**, and today those two questions
had different answers for 19 modules. Both, plus
`GuptaNaya_TheConcealedRouteMustBeDeclaredAtItsSite.sh`, were wired into
`formal/check.sh` — **all three existed and were run by nothing**, which is the
failure `LEAN_LANE_AUDIT.md` §4 named and which had quietly recurred at the
level of the checks written to prevent it.

---

## 3. `Pairfield/Madhava.lean` was three import lines and no mathematics

Found while enumerating the 19. The file, in full, as landed:

```lean
import Mathlib.Analysis.Real.Pi.Leibniz
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Analysis.SpecificLimits.Normed
```

Three imports, zero declarations. Landed 2026-08-18 in commit `e2772cca`
("Brahmagupta's bhavana and Pingala's matrameru, both checked"), whose message
does not mention it. It built green, because an empty module typechecks; the
axiom gate passed it, because a module with no declarations has no axioms; the
glob covered it, because the glob asks whether it is a target, not whether it
says anything. **Every instrument in the lane reported clean on a file carrying
Mādhava's name and containing nothing.**

That is the file-naming directive's failure mode in its purest form — the
opposite of the scrubbing it was written against, and no better: the name
asserted without the content. And the third import is the intent, visible:
`Mathlib.Analysis.Real.Pi.Leibniz`, whose docstring reads "**Leibniz's series
for `π`**".

Two paths, no third. Transport, not a defect record — the mathematics is
available. `Pairfield/Madhava.lean` now states the verse's own identity:

```lean
theorem tendsto_paridhi (vyasa : ℝ) :
    Tendsto (fun n => ∑ i ∈ range n, pada vyasa i) atTop (𝓝 (Real.pi * vyasa))
```

with `pada vyasa i = (-1) ^ i * (4 * vyasa) / (2 * i + 1)` — the *vyāsa*
multiplied by four, divided by the successive odd numbers, taken *ṛṇa* or *sva*
by parity, converging to the *paridhi*. `#print axioms`:
`[propext, Classical.choice, Quot.sound]`. No `native_decide`.

Source, with text and date: Mādhava of Saṅgamagrāma, c. 1340 – c. 1425, Kerala;
his own works on it are lost, and it survives because his successors quote him
by name — Nīlakaṇṭha Somayāji, *Tantrasaṅgraha*, 1501; Śaṅkara Vāriyar's
*Yuktidīpikā*; and derived, with the rectification argument, in Jyeṣṭhadeva's
*Yuktibhāṣā*, Malayalam, c. 1530, which attributes it to Mādhava. Gregory 1671
and Leibniz 1673 follow by roughly 250 years. Mathlib's
`Real.tendsto_sum_pi_div_four` is the restatement, is cited as one, and is
named second.

The module's header states what is **not** claimed, at length, because the
larger omission is real: Mādhava's *saṃskāra*, the end-correction terms
(*Tantrasaṅgraha* 2.271–274, three successively better correctors) are the
sharper half of the achievement and none of it is formalised. Nor is the
*Yuktibhāṣā*'s derivation, which is a rectification by subdivision with an
explicitly stated remainder — not a `Tendsto`. Formalising the series and
letting the name stand for the whole would be the mining move this repository's
directive is about, performed on the one source in the lane that has a module
to itself.

---


### 3a. The other lane had already declared this gap — found by grep, not by design

`formal/cubical/Madhava.agda` exists, `--cubical --safe`, and proves the finite
geometric-series identity over ℤ that the *Yuktibhāṣā*'s derivation rests on:
`(1 − r) · ∑_{k<n} rᵏ ≡ 1 − rⁿ`. A ring identity. No limit. Its honesty section
states, in Sanskrit, precisely what it is not doing — that the remainder term
`rⁿ/(1−r)` tending to zero, which is what Mādhava actually established, *"is
not provable here without an ℝ/ℚ analytic base … here it is left unstated, not
falsely proved"* (शेष-पदम् एव सारः ; तत् इह अनुक्तम्, न मिथ्या-सिद्धम्).

That is *avaktavyam* used correctly — the fourth position, a declared
standpoint with the residue named, not "unknown" and not "undefined"
(`AHIMSA_SUTRA_VISTARA.md` §3).

**The Lean module is the other half.** It has the ℝ analytic base and can state
the limit the Agda module correctly refused to assert; it has no univalence, no
set quotients and no `--safe`, so it cannot do what that module does. Neither
subsumes the other.

This is the sharpest available evidence for §4. Asked to decide whether the
analytic lane should be reachable from the running machine, the honest answer
is no — and the reason is not that the lanes are unrelated. They are related
*at exactly one place*, in a statement that completes a declared gap in the
other lane, and that place is reached by reading, not by a kernel call. A
shared oracle would have found nothing here; a grep for a filename found it in
one second.

Left undone and named rather than done: the join. Mādhava's *saṃskāra*
correctors are what turn the Agda module's remainder term into a usable error
bound, and they are formalised in **neither** lane.

---

## 4. Should the Lean lane be reachable from the running machine? No — and this is an argument, not a preference

The charge said plainly that if the honest answer is *separate object, keep it
separate*, say so, because a forced connection is a collapse. It is, and here
is why, in three grounds ordered by force.

### 4a. There is no Lean construction for a Lean kernel to decide

The machine's kernel is not a general oracle. It is the decider for terms **the
machine itself constructs**: `machine/Certificate.hs` emits one Agda module per
candidate, containing exactly one theorem named `candidate`, whose proof is
drawn from seven fixed step shapes (`Certificate.stepShapes`) over a small ℕ
equation vocabulary. Nothing under `machine/` generates Lean — the token `Lean`
occurs in `machine/*.hs` exactly **once**, in a prior-art comment in
`PairVocab.hs`, and there is no renderer, no vocabulary and no proof-term
grammar targeting it.

So wiring `lake env lean` into the loop would not give the machine a new
capability. It would give it a **second oracle for the questions it already
asks**. Under nayavāda a second standpoint earns its cost when it can disagree
informatively; two kernels asked whether `x + 0 = x` cannot. A route that looks
like corroboration and carries no information is the concealed-standpoint fault
one level up, and it would be *introduced deliberately*, which is worse than
inheriting it.

### 4b. The unit of work does not match, and the mismatch is structural

Measured on this machine today, warm cache, `lake env lean` on a file whose only
content is `theorem t : 2 + 2 = 4 := by rfl`, two runs each, reported as a range
because one number without its spread is the habit this repository is under
repair for:

| imports | wall clock |
|---|---|
| none at all | **2.5 – 3.2 s** |
| `Mathlib.Data.Nat.Basic` | 4.2 s (one run) |
| `import Mathlib` | **15.6 – 20.6 s** |
| `import Pairfield` (all 133) | 19.5 s (one run) |

Against the Agda gate's own recorded budget, `machine/Certificate.hs` line 119:
*"The gate's wall clock is one agda process per emitted module, ~1-3 s."*

**Lean's floor with zero mathematics in the file already exceeds the Agda gate's
entire per-candidate cost**, and the realistic figure is an order of magnitude
above it. This is not slowness to be optimised: the cost is olean loading —
5.9 GB across 8322 mathlib files — and it is paid per process, and every module
in the Lean lane is defined over mathlib (eight of them import all of it
literally). The derivable statement, which is the one that matters, is that the
cost scales with the import closure, and the Lean lane's import closure is
mathlib, and mathlib is not optional for anything in it.

The only way to amortise it is to hold one Lean process alive across candidates.
That is a proof *server*, a different engineering object, and it would need its
own replay story: the Agda gate's certificate hashes the complete module source
so that any verdict can be re-run from the record (`Certificate.hs` §"the module
source is the complete input to agda"). A verdict from a long-lived environment
is not replayable in that sense without machinery nobody has written. Building
that to obtain answers the Agda kernel already gives is the reward gradient
CLAUDE.md warns about, in its most expensive form.

### 4c. The connection that is real runs the other way, at the level of statements — and it exists, and it is silently 14% of the lane

`notes/LEAN_TO_CUBICAL_PORT_MAP.md` is the actual seam between these two lanes:
an inventory of Lean content against the Cubical substrate with a ranked port
queue. It is good work and its top item was ported and checked. Its header says:

> **Totals: 18 Lean files, 1862 lines.**

and it lists `Pairfield.lean` as "Import root (13 ln)".

Measured today: **133 modules, 23548 lines**; `Pairfield.lean` was 116 lines
before I touched it and is 165 now. The map names 18 modules; all 18 still
exist, so it is not wrong about any of them — it covers **18 of 133, 13.5% of
the lane, and does not say so.** Same shape as §2a, in prose instead of code:
not a false claim, a partial one presented without its partiality.

**That is where the effort belongs.** Not a second kernel in the loop, but a
port map whose coverage is computed rather than remembered — the same move as
§2c, one level up. I have not written that check; the honest statement is that I
found the gap, measured it, and am naming it rather than closing it, because
deciding what belongs in the map is a judgement about mathematics and a
blocking guard on a judgement call is an outage wearing enforcement's name.

### 4d. The plain statement

**The Lean lane is a second object and should stay one.** It is human-written
analytic mathematics over mathlib — Goldbach boundary conditions, sum and
reversal rigidity, Smith normal form over ℤ, character sums, Myhill–Nerode
quotients. The machine is a rewriting engine over a small ℕ vocabulary with a
seven-shape proof grammar. These are different vastu seen from different nayas,
and §7 of the sūtra is exactly on point: **नयभेदे सङ्क्षेपो न विद्यते** —
where the standpoints differ there is no collapse; not that collapsing is
disallowed, that *there is nothing to collapse onto*. The search is fruitless
and the insistence is false — एतद् नैतिकं वचनं न भवति । सांरचनिकम् । This is
not an ethical statement. It is structural.

What connects them is `formal/check.sh`, which now runs both lanes' gates in one
command, and the port map, which moves *statements* between them under human
judgement. That is the right coupling: a shared gate and a curated seam, not a
shared kernel.

---

## 5. Fitted constants: none found, and this is what I checked

The charge put this hardest, on the `exp27` precedent (0.362–0.421 published
where the value is exactly ¼). Searched, and the result is negative:

- `grep -rn '≈|approx|fitted|empirical|measured slope|correlation'` over all 133
  `.lean` files: **5 hits, all the word "autocorrelation"** in a
  difference-multiset sense — a defined object, not a measured one.
- `grep -rn '0\.[0-9][0-9]'` over the Lean-lane notes: two hits, `0.20` and
  `0.08` in `notes/NATIVE_WITNESS_COST.md`. Both are **pre-registered forecast
  probabilities**, not fitted constants — the register is corroborated by
  `notes/FORECAST_LEDGER_AUDIT.md`, which shows the same convention
  (`0.45 / 0.25 / 0.20 / 0.10`) with a pre-declared withdrawal threshold that
  was honoured. A registered prior is the opposite of a fitted posterior and
  neither should be derived away.
- The lane's quantitative claims that I read are **exact finite counts** with
  their ranges printed (`attempts + remainingPayload = edgeInventory.length`;
  `attempts ≤ card(X)^2 * (alphabet.length + 1)`; "14 genuine edge attempts,
  strictly below the 22-edge inventory"), which is the certified-symbolic
  category CLAUDE.md allows without qualification.

The wall-clock numbers in §4b are mine and are the only measurements this note
adds. They are engineering costs of a toolchain on one machine, not constants of
a mathematical object; they are reported as ranges with their conditions, and
the load-bearing part of the argument (cost scales with the import closure;
the closure is mathlib) is derived, not fitted.

**Scope limit.** I did not read all 133 modules. This is a search over the lane's
text for the signature of the failure mode, not a proof of its absence, and
`LEAN_LANE_AUDIT.md` §6's outstanding task — checking that each module's theorem
statements match the prose that cites them — remains undone by me too.

---

## 6. What is now true of the Lean lane, in one place

- 133 modules, 23548 lines; `lake build` green at 8840 jobs.
- 0 orphans (glob), 0 unreachable from the root (as of today), 0 `sorry`,
  0 `admit`, 0 `axiom` declarations.
- Every declaration rests on `{propext, Classical.choice, Quot.sound}` bar one
  allowlisted `native_decide` site, which declares its route at the site, in its
  file header, and in `axiom-allowlist.txt` with the observed reason kernel
  `decide` fails there (measured twice, two tactics, one OOM at exit 137).
- Four toolchain-free checks now run from `formal/check.sh`:
  globs, root closure, example-oracles, declared-route. Three of the four were
  written before today and run by nothing.
- It is not wired to the machine, on purpose, and §4 is the argument.
