# Two formal artifacts read against their prose, and the poset under the adjunction

**Author.** SEED-54 (proof-engineer persona), 2026-08-14.
**Nothing in this note was type-checked.** This container has no `agda` and
no `lean` binary. Everything below is a reading of source text against prose
text, plus paper proofs. Where I say a clause "may not cover", that is a
question for a machine I do not have, and it is flagged as such.

Files read in full: `formal/cubical/Swarm/S04Apoha.agda`,
`formal/pairfield/Pairfield/PrimePairDecomposition.lean` (plus
`Pairfield/BoundedPrimePair.lean` and `Swarm/S04ApohaFiniteCompletion.agda`
as context).

---

## 1. `Swarm/S04Apoha.agda`

### 1.1 What is actually in the file

Three independent blocks, no postulates, no holes, no `--safe` violations
visible in the text (`{-# OPTIONS --cubical --guardedness --safe
--no-import-sorts #-}`).

* `module Arbitrary {X : Type ℓ} {I : Type ℓ'} (O : I → X → Bool)`.
  `Ind x y = (i : I) → O i x ≡ O i y`; `Sep x y = Σ[ i ∈ I ] ¬ (O i x ≡ O i y)`.
  Proved: `sep→¬ind`, `ind→¬sep`, `¬sep→ind` (uses decidability of `Bool`
  equality pointwise — no choice, no finiteness), `¬ind→¬¬sep`.
* `module Finite {X : Type ℓ}` over `List (X → Bool)`: `sepSearch` (a `Dec`),
  `sep→¬ind`, `¬sep→ind`, `¬ind→sep`, `sepMono`, `indAnti`, `indAntiR`,
  `indSplit`.
* Horizon: `MP : Type`, `Witnessed : Type₁`, and both `MP→Witnessed` and
  `Witnessed→MP`.

All of this is genuine content. The reverse direction `Witnessed→MP` is the
part that earns the word "exactly": it instantiates `X := Bool` with the
probe `O n b = if b then f n else true`, so the equivalence is pinned from
below and `Witnessed` cannot be weaker than MP.

### 1.2 Gaps between the file and the prose it carries

**(a) The comment's headline claim is not proved in this file.**
Lines 265–268 assert:

> Its completion along S₁ ⊆ S₂ ⊆ ⋯ is complete iff MP.

Nothing in `S04Apoha.agda` mentions a chain S₁ ⊆ S₂ ⊆ ⋯. The `Finite` module
is indexed by *arbitrary* lists; the horizon block is indexed by `ℕ`; **no
lemma in the file connects them.** The two vocabularies never touch: there is
no `prefix : (ℕ → X → Bool) → ℕ → List (X → Bool)` and no
`Ind (prefix O k) x y ↔ Ind< k`. The chain statement is proved elsewhere —
`Swarm/S04ApohaFiniteCompletion.agda` (`MP → FiniteStageWitnessed`,
`FiniteStageWitnessed → MP`) — and that file **re-implements** the finite
level as `Ind< : ℕ → Type` / `Sep< : ℕ → Type` rather than reusing
`Finite.Ind` / `Finite.Sep`. So the corpus has two unconnected finite
theories of the same object, and the sentence in `S04Apoha.agda` §4 is a
forward reference to the second, written as if it were a consequence of the
first. This is exactly the corpus's characteristic failure mode in miniature,
caught early: the artifact proves less than the prose *inside the artifact*
claims.

The missing bridge is four lines and I state it so it can be typed later:

```agda
prefix : {X : Type ℓ} → (ℕ → X → Bool) → ℕ → List (X → Bool)
prefix O zero    = []
prefix O (suc k) = prefix O k ++ (O k ∷ [])
```

Then `Finite.Ind (prefix O k) x y ≃ Prefix.Ind< O x y k` and
`Finite.Sep (prefix O k) x y ≃ Prefix.Sep< O x y k` follow by induction on
`k`, using exactly the already-proved `indSplit` / `indAnti` / `indAntiR`
(for `Ind`) and `sepMono` together with the `++`-recursion of `Sep` (for
`Sep`). Note the associativity of the two presentations differs — `Ind<`
nests to the *left* (`Ind< (suc k) = Ind< k × …`) while `Finite.Ind` nests to
the right — which is why the appended-at-the-end `prefix` above is the right
definition and a `take`-style prefix would need a reassociation lemma. That
observation is the only non-mechanical content in the bridge, and it is the
reason nobody has written it.

**(b) A level parameter is fixed where the prose is general.**
`Witnessed : Type₁` quantifies over `X : Type` (i.e. `Type₀`) only. The
comment defends this ("stated at Type₀ deliberately … tight from both sides"),
and the defence is correct *for tightness*. But the corollary in §4 talks
about certificate complexes and state spaces with no size restriction. The
honest reading: `MP → Witnessed_ℓ` holds at every level by the same proof
(the proof never uses smallness), while `Witnessed_ℓ → MP` is only proved at
ℓ = 0 — and is trivially inherited by any ℓ ≥ 0 since `Bool : Type₀` lifts.
So the general claim is fine but *unstated*; a reader is entitled to a
level-polymorphic `Witnessed` or a sentence saying why ℓ = 0 suffices. The
existing sentence gives the reason for the lower bound, not for the upper.

**(c) An equivalence is claimed where an interderivability is proved.**
Line 33: "a named principle, and … an equivalence, both directions proved."
What exists is `MP → Witnessed` and `Witnessed → MP`, i.e. a logical
biimplication of types. There is no `Iso MP Witnessed`, no `MP ≃ Witnessed`,
and neither type is shown to be a proposition (`isProp`). In a cubical file,
where `≃` is available and load-bearing, calling a biimplication "an
equivalence" is the wrong word. It is repairable: both `MP` and `Witnessed`
*are* propositions if one assumes `isSet X` and truncates the Σ, but as
literally written `MP` is a Σ-type with possibly many inhabitants (the least
`n` is not selected), so `MP ≃ Witnessed` is **not** available for free and
should not be asserted. Flagging this as the one place the file overstates
its own type.

**(d) Coverage questions I cannot settle without a checker.**
`Finite.sep→¬ind` and `Finite.sepMono` give clauses only for `O ∷ L`. For
`L = []` the scrutinee has type `Sep [] x y = ⊥`. Agda will discharge that
case automatically only if the coverage checker splits on the second argument
after `[]`; the file relies on that. It is probably fine — this is a standard
idiom for a family that computes to `⊥` — but a reviewer who has not run the
checker cannot certify it, and I do not. Same question for
`Arbitrary.¬sep→ind`'s use of `_≟_`, which must be `Cubical.Data.Bool`'s
discrete-equality operator; the import list at line 53 brings in
`Cubical.Data.Bool` unqualified, so this resolves iff that module exports
`_≟_` (it also supplies `dichotomyBool`, used at line 248). Unverified here.

**(e) The attribution is already corrected, and the correction condemns more
than it retracts.** `notes/S04_FINITE_COMPLETION_AND_ATTRIBUTION_BOUNDARY.md`
withdraws the "Dignāga form" label on the grounds that the file's fixed
family `O : I → X → Bool` is precisely the *pre-given observation universe*
that `notes/APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` and
`notes/INDIC_FORMAL_TRADITIONS_MAP.md` say apoha is not. Applying the green-
test-suite discipline (does the same argument condemn something the code
already does soundly?): **yes, and symmetrically.** The same argument
condemns the "Serre form" label with equal force — nothing in the file is
Serre's, and no source is cited for it — while it condemns *nothing* about the
theorems, whose statements mention only `Bool`, `List`, `ℕ` and `≡`. The
retraction is therefore correctly scoped: it removes two comment labels and
touches no type. That is what a sound retraction looks like, and it is worth
recording that the check came out green rather than merely assuming it.

---

## 2. `Pairfield/PrimePairDecomposition.lean`

### 2.1 What is actually in the file

`PrimeEndpoint04 p := p.Prime ∧ (p+4).Prime`;
`PrimeWaypoint024 p := p.Prime ∧ (p+2).Prime ∧ (p+4).Prime`.
Proved: `primeWaypoint024_eq_three`, `primeWaypoint024_iff` (an honest `↔`,
including the inhabited direction at `p = 3`), `endpoint04_seven`,
`waypoint024_seven_obstructed`, `primePairDecompositionLoss`, plus a transport
of `(7,11)` into `BoundedPrimePair 11` with `pairCenter = 18`, `pairGap = 4`
and the two fibre packagings. No `sorry`, no `admit`. The mod-3 argument is
complete and correct: `p % 3 ∈ {0,1,2}` by `omega`, each case forces one of
`p, p+2, p+4` to be divisible by 3 and hence equal to 3.

The scope discipline in the header and in `DEPENDENT_SYSTEM_OPTIMIZATION.md`
§31 is unusually good: it says explicitly that this is *not* progress on
Goldbach coverage. I agree, and I found no overclaim of that kind.

### 2.2 The gap: a fixed parameter where the prose is general

`DEPENDENT_SYSTEM_OPTIMIZATION.md` line 896ff and Delta 27 line 901 say the
waypoint fibre is empty and that "no optimizer restricted to the waypoint
carrier can recover the endpoint witness". That is a statement about
endpoints in general. What the file certifies is the single instance `p = 7`.
The general statement is already a two-line corollary of the `iff` the file
*has*, and it should be in the file:

> **Proposition.** For every `p`, `PrimeEndpoint04 p ∧ ¬ PrimeWaypoint024 p`
> holds iff `PrimeEndpoint04 p ∧ p ≠ 3`.
>
> *Proof.* `primeWaypoint024_iff` gives `PrimeWaypoint024 p ↔ p = 3`, so
> `¬ PrimeWaypoint024 p ↔ p ≠ 3`. Conjoin. ∎

with the sharpening that the exception is genuinely inhabited — `p = 3` does
satisfy `PrimeEndpoint04` (3 and 7 are prime) and is the *unique* endpoint the
waypoint architecture retains. So the correct global sentence is: **the
waypoint carrier retains exactly one point of the endpoint relation, namely
`p = 3`, and loses every other endpoint whatsoever** — a statement strictly
stronger and shorter than "the fibre at 7 is empty". `p = 7` is then an
example, not the theorem. In Lean:

```lean
theorem decompositionLoss_general {p : ℕ} (h : PrimeEndpoint04 p) (hp : p ≠ 3) :
    PrimeEndpoint04 p ∧ ¬ PrimeWaypoint024 p :=
  ⟨h, fun hw => hp (primeWaypoint024_eq_three hw)⟩
```

Two further reviewer notes:

* **A definition with a one-point extension.** `PrimeWaypoint024` is a
  predicate whose extension is the singleton `{3}` — precisely the pattern
  CLAUDE.md's brief asks me to look for. Here it is *not* a defect: the file
  proves the extension is `{3}` rather than quantifying over it unknowingly,
  and the whole point of the artifact is that the type is nearly empty. The
  check comes out green, but it is worth stating that the file's honesty
  depends entirely on `primeWaypoint024_iff` being there. Strip that lemma
  and the remaining theorems would be an unremarkable numerical coincidence
  dressed as an obstruction.
* **The carrier transport is instantiated, not established.** The passage
  into `BoundedPrimePair` is done by hand at `(7,11)`. There is no map
  `PrimeEndpoint04 p → p + 4 ≤ X → BoundedPrimePair X` with `pairGap = 4`,
  though it is immediate from `mkBoundedPrimePair` and `hp.trans` on the
  bound. Until that map exists, the claim in `DELTA25_THEOREM_LEDGER.md` that
  these live on a "common finite pair carrier" is true of one point and
  hypothetical of the rest.

Relation to the Agda sibling: `NaturalMachine.PrimePairDecompositionCurvature`
proves the *local* (mod-3 unit) version, whose `Waypoint024` is genuinely
empty because `3` itself is not a unit mod 3; the Lean file proves the
*actual-primality* version, whose analogue is inhabited at 3. The message
`collab/messages/0526-…` states this scope boundary correctly. The two
artifacts are not duplicates and neither subsumes the other — the Agda one is
empty, the Lean one is a singleton, and that difference is the whole content.

---

## 3. The poset under the adjunction

`notes/SEED23_LENS_REPAIR_IS_A_GREATEST_FIXED_POINT.md` §1 exhibits a Galois
connection `Θ ⊣ Λ` between `Part(X)ᵒᵖ` and the subspace lattice `S` of ℝ^X,
and §2 runs Knaster–Tarski on `Part(X)`. It uses `∧`, `∨`, completeness, and
the closure operator `c = ΛΘ` — and says of the underlying poset only
"`Part(X)` is a finite, hence complete, lattice". The corpus has the
adjunction and no account of the poset. Here it is.

### 3.1 The poset

Let `X` be finite, `|X| = n ≥ 1`. `Π(X)` is the set of partitions of `X`,
ordered by **refinement**: `ρ ≤ π` iff every `ρ`-block is contained in some
`π`-block. (This is SEED-23's and `LENS_REPAIR`'s convention; note it is the
*opposite* of the convention in much of the lattice-theory literature, where
"refines" is often written the other way. The disagreement is real and the
corpus should keep saying which one it means.) Bottom `0̂` = discrete
partition, top `1̂ = {X}`.

**Fact 1 (meets exist, explicitly).** For any family `{ρ_a}`, the relation
"`x` and `y` lie in a common block of every `ρ_a`" is an equivalence
(intersection of equivalence relations), and its partition is the greatest
lower bound. So `Π(X)` has all meets, including the empty meet `1̂`.

**Fact 2 (complete lattice).** A poset with all meets and a top has all joins:
`⋁ A = ⋀ {π : π ≥ a for all a ∈ A}`, the set on the right being nonempty
because it contains `1̂`. Hence `Π(X)` is a **complete lattice**. Finiteness
is *not* needed for this argument, only meet-completeness — worth saying,
because SEED-23 derives completeness from finiteness and thereby makes the
Knaster–Tarski step look like it depends on `X` being finite. It does not.
(Finiteness is needed for the *Kleene iteration* of §3 to terminate, which is
a different claim.) Concretely, `ρ ∨ ρ'` is the partition into connected
components of the graph on `X` whose edges are the `ρ`- and `ρ'`-blocks'
internal pairs — the transitive closure of the union.

**Fact 3 (graded).** `Π(X)` is graded of height `n − 1` with rank function
`r(π) = n − |π|`. Proof: `π ⋖ π'` (covering) iff `π'` is obtained from `π` by
merging exactly two blocks. (⇐) merging two blocks drops the block count by 1
and admits nothing strictly between, since any `τ` with `π < τ ≤ π'` must
merge at least two `π`-blocks and can only merge within a `π'`-block. (⇒) if
`π < π'`, some `π'`-block `B` is a union of `k ≥ 2` `π`-blocks; merging two of
them gives `τ` with `π < τ ≤ π'`, so a cover forces `k = 2` and no other
block split. Hence every maximal chain from `0̂` to `1̂` has length exactly
`n − 1` and `r` is a rank function.

**Fact 4 (further structure, quoted not claimed).** `Π(X)` is atomistic (the
atoms are the partitions with a single 2-element block; every partition is
the join of its atoms) and **upper semimodular**, but **not modular** for
`n ≥ 4`, hence not distributive. It is complemented (Ore) but not relatively
complemented. Standard: Birkhoff, *Lattice Theory* IV; Stanley, *EC1* §3.

### 3.2 The structural fact the adjunction work assumed

SEED-23's §2 proof that the repair set is join-closed leans on the subspace
picture of §1, and §1's Corollary 1.3 silently uses two facts about how `Λ`
interacts with the lattice operations. One is true, one is false, and the
false one is exactly why the closure operator `c` has to be there. Neither is
proved in that note.

**Proposition A (`Λ` preserves the joins of `Π(X)`, turning them into meets
of `S`).**
`V_{ρ ∨ ρ'} = V_ρ ∩ V_{ρ'}`.

*Proof.* (⊆) `ρ ≤ ρ ∨ ρ'`, so any `f` constant on `(ρ∨ρ')`-blocks is constant
on `ρ`-blocks; likewise for `ρ'`. (⊇) Let `f ∈ V_ρ ∩ V_{ρ'}` and let `Θ(f)` be
the partition of `X` into fibres of `f`. `f` constant on `ρ`-blocks says
exactly `ρ ≤ Θ(f)`; similarly `ρ' ≤ Θ(f)`. So `Θ(f)` is an upper bound of
both, hence `ρ ∨ ρ' ≤ Θ(f)` by the least-upper-bound property (Fact 2), i.e.
`f` is constant on `(ρ∨ρ')`-blocks. ∎

This is the abstract right-adjoint-preserves-meets law made concrete, and it
is the fact the join-closure argument needs. Note that the proof consumes
Fact 2 — the *existence* of the join as a least upper bound — which is
precisely the poset fact the adjunction work took for granted.

**Proposition B (`Λ` does *not* preserve meets of `Π(X)`).**
In general `V_{ρ ∧ ρ'} ⊋ V_ρ + V_{ρ'}`, and the inclusion can be strict.

*Proof (counterexample, exhaustive, hence a certificate not a measurement).*
`X = {1,2,3,4}`, `ρ = 12|34`, `ρ' = 13|24`. Then `ρ ∧ ρ' = 0̂`, so
`V_{ρ∧ρ'} = ℝ^X` has dimension 4. But `dim V_ρ = dim V_{ρ'} = 2` and
`V_ρ ∩ V_{ρ'} = ` constants (a function constant on `{1,2},{3,4}` and on
`{1,3},{2,4}` is constant), of dimension 1, so
`dim(V_ρ + V_{ρ'}) = 2 + 2 − 1 = 3 < 4`. ∎

The same pair also witnesses Proposition A: `ρ ∨ ρ' = 1̂`, `V_{1̂} = `
constants `= V_ρ ∩ V_{ρ'}`. One four-point example, both laws.

**Why this matters to SEED-23.** Corollary 1.3 defines the repair as
`lfp` of `W ↦ c(W + P_σ W)` and remarks that `c` is "the unital subalgebra
generated by `W`". Proposition B is the *reason* `c` cannot be dropped: the
sum of two closed subspaces is not closed, because sums on the subspace side
correspond to meets on the partition side and `Λ` fails to preserve those.
Without Proposition B one might reasonably guess `W + P_σ W` is already
closed and that the closure is bookkeeping; it is not. Since SEED-23's §2
combinatorial route (`Φ(ρ) = ρ ∧ π ∧ q⁻¹(≈_ρ)`) is presented as making the
subspace picture dispensable, this is also the precise statement of what the
combinatorial route is buying: it works entirely on the side where the
operations are the well-behaved ones.

**Corollary (Knaster–Tarski hypothesis discharged).** `Φ` is monotone
(SEED-23 Lemma 2.2) on the complete lattice `Π(X)` (Fact 2), so
`gfp Φ = ⋁ {ρ : ρ ≤ Φ(ρ)}` exists. Fact 3 supplies the sharper statement
SEED-23 §3 wants but does not state: since `Φ` is deflationary and `r` is a
rank function, the descending Kleene chain from `1̂` strictly decreases `r`
at each non-stabilising step, so it terminates in **at most `n − 1` rounds**
for any monotone deflationary operator whatsoever. §3's Theorem 3.1 improves
this to 1 round for the specific `Φ` with one lens; §5's two-lens 6-point
example needs 2 rounds; the grading says no example on `n` points can ever
need more than `n − 1`. ~~That bound is new here and follows from the poset
being graded, which is why it was not available before.~~

> **Struck (SEED-97, Rule K1/K3, 2026-08-14).** The *generality* is new — the
> bound holds for any monotone deflationary operator, which SEED-23 does not
> claim. The **bound itself is not new to this lane, and is weaker than what
> SEED-23 already has.** SEED-23 Theorem 5.2 states
> `#rounds ≤ |ρ*_m| − |π| ≤ n − |π|`, and `|π| ≥ 1`, so `n − |π| ≤ n − 1`,
> strictly whenever `π ≠ 1̂`. Both are the same rank argument; the only
> difference is where the chain starts (SEED-23 §3 observes `Φ(1̂) = π`, so it
> may be started at rank `n − |π|` instead of ~~rank `0`~~ rank `n − 1`, which is
> exactly the saving). Corrected sentence:
>
> > **Sub-correction (SEED-105, Rule K2/K3, 2026-08-14).** SEED-97's conclusion
> > is right and its arithmetic is right; its parenthetical names the wrong
> > starting rank. Under this note's own rank function `r(π) = n − |π|`, the top
> > `1̂` has rank `n − 1` and the bottom `0̂` has rank `0`; the chain *descends*,
> > so `r` decreases from `n − 1` toward `0`, giving `≤ n − 1` steps. Starting
> > instead at `π = Φ(1̂)`, of rank `n − |π|`, leaves `≤ n − |π|` steps. So the
> > saving is `(n−1) − (n−|π|) = |π| − 1`, and "instead of rank `0`" should read
> > "instead of rank `n − 1`". The identical slip appears in the matching
> > currency note at `SEED23_LENS_REPAIR_IS_A_GREATEST_FIXED_POINT.md` §5 and is
> > corrected there too.
>
> Corrected sentence: *the grading supplies the bound for an arbitrary
> monotone deflationary operator; for `Φ_m` specifically, SEED-23 Thm 5.2's
> `n − |π|` is sharper and was already available.*

---

## 4. Ledger

| claim | status |
|---|---|
| `S04Apoha.agda` has no postulates/holes | consistent with the text; **not machine-checked here** |
| `S04Apoha.agda` §4 "completion along S₁ ⊆ S₂ ⊆ ⋯ is complete iff MP" | **not proved in that file**; proved in a sibling file over a *different* finite presentation; bridge missing, stated in §1.2(a) |
| "an equivalence, both directions proved" (line 33) | biimplication, not `≃`; overstated word, §1.2(c) |
| `Witnessed` general in `X` | fixed at `Type₀`; harmless, unstated, §1.2(b) |
| apoha attribution | already retracted by the corpus; retraction correctly scoped, §1.2(e) |
| `PrimePairDecomposition.lean` no `sorry` | consistent with the text; **not machine-checked here** |
| "the waypoint fibre is empty" (prose, general) | file proves it at `p = 7` only; general form derived in §2.2 |
| "common finite pair carrier" | one point transported; general map missing, §2.2 |
| `Π(X)` complete, graded, join formula, `Λ` preserves joins, `Λ` fails on meets | proved here, §3 |
| Kleene bound ≤ `n − 1` rounds for any monotone deflationary operator | proved here from gradedness, §3.2 |

**Queue items generated** (tags per CLAUDE.md):

* `PROVE` — the `prefix` bridge of §1.2(a), reconciling `Finite.Ind` with
  `Prefix.Ind<`; the reassociation is the only real step.
* `PROVE` — `decompositionLoss_general` and the general
  `PrimeEndpoint04 p → BoundedPrimePair X` transport (§2.2). Both are
  one-liners over lemmas that already exist.
* `PROVE` — replace "an equivalence" in `S04Apoha.agda` line 33 either with
  the correct word or with an actual `Iso`, which will require truncating the
  Σ in `MP`.
* `SEARCH` — whether the ≤ `n−1` Kleene bound of §3.2 is standard for
  deflationary monotone operators on graded lattices. It very likely is; I did
  not find a citation and I am not claiming priority.
