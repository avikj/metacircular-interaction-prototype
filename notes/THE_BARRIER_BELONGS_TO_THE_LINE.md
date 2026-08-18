# The barrier belongs to the line, not to arithmetic

**Status:** two checked Agda modules and one retraction.
**Artifacts:** `formal/cubical/NaturalMachine/SuccessorIsNotTropical.agda`
(exists, checks), `formal/cubical/NaturalMachine/PythagoreanTransition.agda`
(new, checks — Agda 2.6.3 / cubical v0.5, `--safe`, no postulates, no holes,
exit 0).
**Sources:** Brahmagupta, *Brāhmasphuṭasiddhānta* ch. 18 (kuṭṭakādhyāya), 628 CE
— samāsa-bhāvanā and antara-bhāvanā. Voevodsky, univalence.

---

## 1. What this corpus claimed

`SuccessorIsNotTropical` proves `disjoint-support`: no prime divides two
consecutive integers, so `n` and `n+1` share **not one coordinate** in the
multiplicative chart. The module then says, in its own words, that this is
"the parity barrier … a chart incompatibility", that "`disjoint-support`
below is its whole content", and it closes with

> The object to build is the transition itself.

Two of those three sentences are over-claims and the third was never acted
on. This note retracts the over-claims and builds the object.

## 2. The retraction

`disjoint-support` is a theorem about **ℕ equipped with the successor**. It
is not a theorem about arithmetic, and it does not identify a barrier
intrinsic to having both an additive and a multiplicative structure on one
set.

The reason it looked intrinsic is that ℕ's additive generator is `1`, which
is a **unit**: multiplicatively invisible, norm one. An additive law whose
generator is invisible in the multiplicative chart will of course produce
steps with no multiplicative locality. That is a property of the chosen
generator, not a fact about the coexistence of the two structures.

The test is immediate: keep the arithmetic, change the additive law, and see
whether the incompatibility survives. It does not.

## 3. The conic, where the transition exists

Take pairs `(a,b)` over any commutative ring, the norm `N(a,b) = a² + b²`,
and the composition

```
(a₁,b₁) ⊗ (a₂,b₂) = (a₁a₂ − b₁b₂ , a₁b₂ + a₂b₁).
```

This is **samāsa-bhāvanā at D = −1** — Brahmagupta's composition law for
`x² − D y²`, 628 CE, whose entire content is that the norm is multiplicative.
`Bhavana.agda` already checks the general `D` in this repository; the case
`D = −1` is the one that is a *circle*, and it is the case nobody here ran.

The circle's additive law is `rot g u = u ⊗ g`, translation by a fixed point.
Against `disjoint-support`, its behaviour in the multiplicative chart is the
exact opposite:

```
rot-norm :  N (u ⊗ g)  ≡  N u · N g
```

The conic's successor is not merely visible in the multiplicative chart. It
**is multiplication by a constant there.** Zero locality on the line; total
locality on the circle; same ring, same norm, same chart. So the obstruction
`SuccessorIsNotTropical` measured is the line's.

## 4. The transition map, built

A Pythagorean triple is a pair whose norm is a square, `N u ≡ z · z`. Three
theorems, all checked:

| statement | content |
|---|---|
| `triple-⊗` | triples are **closed** under bhāvanā, with hypotenuse `z·w` |
| `euclid` | `gen t = t ⊗ t` sends any pair to a triple with hypotenuse `N t` |
| `gen-hom` | `gen (s ⊗ t) ≡ gen s ⊗ gen t` |

`euclid` says Euclid's parametrisation `(p²−q², 2pq, p²+q²)` is the single
word **squaring**, once the pair rather than the number is the object.

`gen-hom` is the transition map the earlier module asked for. The parameter
chart and the triple chart carry the *same* composition law, and the
parametrisation intertwines them. There is no defect to measure: the chart
change is a monoid homomorphism, exactly.

Concretely, checked by `refl` over ℤ:

```
gen (2,1)         = (3,4)                      the 3–4–5 triple, by squaring
(3,4) ⊗ (5,12)    = (−33,56)                   33² + 56² = 65² = (5·13)²
```

Triples are not a list to be enumerated. They are a **monoid**, and its law
was written down in 628.

## 5. Where univalence is load-bearing

When `N g ≡ 1`, `rot g` is invertible and its inverse is composition with the
conjugate — which is **antara-bhāvanā**, Brahmagupta's second law, present in
the same chapter for exactly this purpose. So:

- `rotEquiv g h : Pair ≃ Pair`,
- `rotPath  g h : Pair ≡ Pair` by univalence,
- `defect-vanishes : (λ u → N (rot g u)) ≡ N`.

That last term is Delta 15's structured defect `Def_Str` computed for the
norm along the identification, and it vanishes. The circle's translations are
**identifications of the circle carrying its structure with itself**.

The line has no such family, and `disjoint-support` is the proof that it does
not. So the honest statement of the difference between the two additive laws
is not about primes at all:

> One additive law is a family of structure-preserving identifications.
> The other is not. That is the whole of it.

`ua` is doing real work here. Without it "the translations are identifications"
is a slogan; with it, `rotPath` is a term and `defect-vanishes` is its
structured-defect computation.

## 6. What is *not* claimed

Nothing here bears on the distribution of primes, on the parity obstruction
in sieve theory, or on the walk's asymptotics. The walk runs on the line.
Whether the walk can be made to run on a conic — whether there is a machine
whose state moves by bhāvanā rather than by successor — is open, is the
question this note leaves, and is not touched by anything above.

What *is* settled: the sentence "the barrier is a chart incompatibility" was
wrong as stated, and the object that sentence said was missing exists,
is elementary, and predates every European name attached to any of it.

## 7. Ledger

- Proved: §3, §4, §5 — all terms in `PythagoreanTransition.agda`, ring
  identities discharged by the CommRingSolver (exact symbolic computation,
  which CLAUDE.md admits as proof), the ℤ instances by `refl`.
- Retracted: the reading of `disjoint-support` as an obstruction intrinsic to
  arithmetic. The theorem stands; its interpretation in that module's §4 does
  not, and should be read as scoped to the line.
- Open: does the walk admit a conic form? `SumProductTorus` gives the
  multiplicative chart, `PythagoreanTransition` gives an additive law
  compatible with it, and nothing yet connects the walk's `lcm` state to
  either.

---

## 8. Addendum, same session: why the walk could not have been fixed

`formal/cubical/NaturalMachine/IdempotenceForbidsDescent.agda` (checked,
exit 0) closes §6's "the walk runs on the line" with a reason.

**Theorem.** In any monoid, an idempotent element with an inverse is the
unit:

```
x = x·e = x·(x·y) = (x·x)·y = x·y = e.
```

**Instance one.** The walk's state law is a join — pointwise max on
derivations, `lcm` on numbers — and a join is idempotent at *every*
element. So the only invertible state is the trivial one. No step of the
walk's own law can be undone by another step of that law, at any state,
ever (`walk-only-unit-inverts`). In the multiplicative chart: the walk can
undo itself only all the way back to capacity 1.

**Instance two.** In bhāvanā at `D = −1` over ℤ, `i = (0,1)` has norm 1,
inverts against its conjugate, and is not the unit — all three by `refl`.
So that monoid is *not* idempotent (`bhavana-is-not-a-join`), and a step in
it is undone by another step of the same law: antara-bhāvanā, the second
composition Brahmagupta gives in the same chapter, exactly for this.

**Consequence.** The walk's irreversibility is not a missing optimisation.
By `Apavada`, any rule agreeing with the walk everywhere is a
*reformulation* and changes only price. Reversibility requires changing the
state law, not the rule.

**Scope, stated so it is not over-read.** This says nothing about the
growth *rate*; `cap(k) = e^ψ(k)` is proved elsewhere and irreversibility
alone implies no rate. And it does **not** show that the cakravāla's
descent *is* this inversion: the cyclic method divides by `k`, which is
inversion in the scaling action (`Bhavana.normScale`), a different
structure. That the two moves coincide is a conjecture, flagged as one in
the module and not proved anywhere.

---

## 9. Addendum, same session: the conjecture in §8 is false

§8 flagged one thing as unproved — that the cakravāla's descent *is* the
bhāvanā inversion. It is not.
`formal/cubical/NaturalMachine/DescentIsNotInversion.agda` (checked, exit
0) refutes it in one line:

```
invertible→norm-invertible :  u ⊗ v ≡ one  →  N u · N v ≡ 1r
```

Composition multiplies norms and the unit has norm 1, so **a pair inverts
in the bhāvanā monoid only if its norm is already a unit.** The cakravāla
starts at a state of norm `k` with `k` not a unit — that is the entire
situation it exists to escape — and no composition can take it to norm 1.
So descent is not inversion, provably, at every state the method runs on.

### What descent is instead

The scaling action, with two exact identities:

```
N-⊙ :  N (c ⊙ u)     ≡ (c · c) · N u        homogeneity  (= Bhavana.normScale at D = −1)
⊙-⊗ :  (c ⊙ u) ⊗ v   ≡ c ⊙ (u ⊗ v)          equivariance
```

The norm changes **by a square** under scaling and is multiplied under
composition. So the invariant is not the norm but the **norm modulo
squares**, and "solve `x² − D y² = 1`" is the statement that the class is
trivial. Dividing by `k` is not a step of the group law — it is the choice
of a canonical representative in a scaling orbit, which is why it needs a
divisibility condition (`Bhavana.choiceToNumerator`) rather than an
inverse. On the orbits — pairs up to scaling, i.e. the **rational points**
of the conic — there is nothing left to divide.

### What this costs §§1–8

Nothing that was proved. The reversibility dichotomy stands. What dies is
the *reading* of reversibility as cakravāla descent, labelled a conjecture
when written and labelled false now.

### And a second correction, to this addendum's own first draft

The module's §4 first said the walk has neither mechanism. That was wrong.
The walk **does** have an equivariant scaling action — the tropical shift,
whose equivariance is an already-checked term in this lane,
`SumProductTorus.⊔-+-distrib`, which under `val` is
`lcm(a,b)·c = lcm(a·c, b·c)`.

What the walk lacks is the thing scaling would act *on*: a **norm** — a
quantity that composition multiplies and scaling moves by squares, so that
its class is an invariant and reaching the trivial class is a goal. The
walk's state is its own only invariant. So:

> the walk has scaling and no norm; it has no inverses at all; and a
> scaling action with nothing to reduce is not a descent.

**Whether the walk admits a norm** is now the sharpest open form of the
question these modules have been circling. It replaces §6's "does the walk
admit a conic form?", which was too vague to attack.

---

## 10. Addendum, same session: the question in §9 closes, negatively

§9 named the sharpest open form: **does the walk admit a norm?**
`formal/cubical/NaturalMachine/NoNormOnAJoin.agda` (checked, exit 0)
answers it. No — and the answer is once again idempotence.

**Theorem.** Let the state law be a join, so every state is idempotent, and
let `N` be multiplicative for it. Then

```
N x · N x  =  N (x ⊔ x)  =  N x
```

so every value of `N` is a ring idempotent. In a ring with no zero
divisors the only idempotents are `0` and `1`. Hence:

> a multiplicative norm on a join monoid takes at most **two values**.

`three-collide` makes the consequence exact: among any three states, two
carry the same norm — always, for every such `N`, over every domain.
Instantiated at ℤ and at the walk's states, that is
`walk-norm-separates-nothing`. No measurement was involved and none could
have been.

### The part that inverts the question

The walk's state space is **not** normless. `SumProductTorus.val` is a
perfectly good multiplicative norm, and has been checked in this lane for
weeks:

```
val-⊕ :  val (u ⊕ v) ≡ val u · val v
```

Derivations carry *two* operations — `⊕`, which is multiplication of the
numbers, and `⊔`, which is `lcm` — cohering tropically via
`⊔-⊕-distrib`. `val` is multiplicative for `⊕`. The theorem above says
nothing except a two-valued map is multiplicative for `⊔`.

**And the walk steps by `⊔`.**

So the finding is sharper than "the walk has no norm":

> The walk's state space has a norm. The walk's step law is the one
> operation of the two for which that norm does not exist. The machine is
> running on the wrong one of its own operations.

That is not a defect of the walk's *rule* — by `Apavada`, no rule change
reaches it — and not a fact about `lcm` being hard. It is an implicit
choice of semigroup whose consequence is the loss of every descent
mechanism at once.

**Not claimed:** that a `⊕`-stepping machine would be better, terminate, or
stay lossless. `⊕` multiplies capacities where `⊔` joins them, so its
states grow faster; whether the norm it keeps pays for that is open.

### The thread, in one line each

1. `disjoint-support` — the successor has no locality in the multiplicative chart. *(stands; scope corrected)*
2. `rot-norm` — the conic's successor is multiplication by a constant there. *(the line's barrier is the line's)*
3. `gen-hom` — Euclid's parametrisation is the transition map, defect-free. *(the object §4 of the old module asked for)*
4. `idem-invertible-is-unit` — joins are irreversible; bhāvanā is not. *(conjecture attached: descent = inversion)*
5. `invertible→norm-invertible` — **that conjecture is false**; descent is scaling, and the invariant is the norm mod squares.
6. `three-collide` — and the walk cannot have a norm for its own step law at all, though its state space has one for the other.

---

## 11. Addendum, same session: descent costs the integers

§10 left open whether a `⊕`-stepping machine — one using the operation
that *does* have a norm — would therefore have descent.
`formal/cubical/NaturalMachine/DescentCostsTheIntegers.agda` (checked,
exit 0) says no, and the reason is a *second, unrelated* obstruction.

| law | on | reversible? | normed? | why not |
|---|---|---|---|---|
| `⊔` | ℕ-exponents | no | no | **idempotence** |
| `⊕` | ℕ-exponents | no | yes (`val`) | **positivity — ℕ is a cone** |
| `⊞` | ℤ-exponents | yes | yes | — |

`⊕-only-unit-inverts`: `u ⊕ v ≡ 0` forces `u ≡ 0`, because `x + y = 0`
forces `x = 0`. Note `⊕` is *not* idempotent (`2 + 2 ≠ 2`), so
`IdempotenceForbidsDescent` says nothing here — this is a genuinely
different failure, and switching operations to escape the first walks into
the second.

`⊞-inverse`: over ℤ-exponents every state inverts, by negation.

`cone-is-proper`: and the states thereby gained are not in the image of the
ℕ-cone. A ℤ-exponent vector with a negative coordinate is not the
derivation of a natural number. It is the derivation of a **ratio**.

> There is no reversible step law on ℕ-exponents. Reversibility is the
> group completion; the group completion of the positive naturals under
> multiplication is the positive rationals. **Descent costs the integers.**

Which is the same price the conic charges. §9 found the cakravāla's
descent to be division by `k` — passage to the scaling orbits, i.e. to the
**rational points** of the conic. Two independent routes through this
corpus's question, arriving at ratio.

### On the word "irrational"

The Pythagorean discovery is usually taught as a catastrophe, with the
emphasis on what ratio *fails* to reach. This thread arrived from the other
side. Every mechanism by which a state can come back down — the conic's
scaling orbits, the exponent group's inverses — required admitting ratios,
and none of them involved a diagonal. Ratio is not what number fell short
of. Ratio is the completion in which descent exists at all, and a machine
confined to ℕ is confined to a cone with no way down.

Number is ratio. That sentence now has a proof attached, and the proof is
that the alternative has no inverses.

**Not claimed:** that a ℤ-exponent machine solves anything. Its states are
not natural numbers, so "lossless machine for ℕ" is not the same problem
any more. Whether the walk's questions survive the passage to ratios is
untouched, and is the next real question.

---

## 12. Addendum, same session: forgetting is the operational form of descent

`formal/cubical/NaturalMachine/BoundedStateNeedsAGroup.agda` (checked,
exit 0) converts the algebra of §§8–11 into the property that actually
costs the walk something: **forgetting**. A machine that can remove from
its state something it previously installed runs in a window; one that
cannot must carry everything it has ever seen, and its capacity is the
product of everything it has ever seen. That is the walk, and
`cap(k) = e^ψ(k)` is the bill.

| law | can forget? | proof / obstruction |
|---|---|---|
| `⊞` ℤ-exponents | **yes** | `window-slide`: install then remove is the identity |
| `⊕` ℕ-exponents | no | `cone-cannot-forget` — positivity |
| `⊔` ℕ-exponents | no | `join-cannot-forget` — idempotence |

The two negative proofs are unrelated to each other, which is the point:
escaping one lands in the other.

**Explicitly not a theorem here:** the general slogan "bounded state
requires a group law". Three instances and two obstructions are what is
checked; the slogan is what they are evidence for, and the module says so
at both ends.

### One resonance, recorded as a question and not as a result

`NoNormOnAJoin` says a map multiplicative for a join takes values in
`{0,1}` — it is an **indicator**, never a weight. Sieve methods work in
the `lcm` chart and the parity barrier is usually described as an
inability to carry a particular ±1-valued multiplicative function across.
Those two sentences rhyme. They are **not** the same statement: `λ` is
multiplicative for ordinary multiplication (`⊕`), not for the join, so
nothing above applies to it as written.

Recording the rhyme here so it is not lost and not mistaken for a finding.
The question it poses is exact: *is there an operation for which the
sieve's weights are multiplicative, and is it `⊔` or `⊕`?* Until that is
answered the resonance is worth nothing, and this corpus has published a
fitted constant before by treating a resemblance as content.

---

## 13. Addendum, same session: the rhyme in §12 has a theorem under it

`formal/cubical/NaturalMachine/SignIsNotAccumulable.agda` (checked, exit
0). Two things came out of looking at §12's rhyme properly, and the second
is stronger than the statement it came from.

### First: idempotence was never about `lcm`

Every result in this thread turns on idempotence, presented throughout as
a property of the join. It is more general, and the reason needs no
arithmetic:

> **Knowing something twice is knowing it once.**

Any state law that *accumulates* — observations, constraints, standpoints,
congruences, installed primes — is idempotent, because combining a datum
with itself adds nothing. `lcm` is idempotent for that reason, not for a
reason about divisibility. So §§8–12 apply to every accumulating machine,
the walk being one instance.

### Second: the theorem, with no domain hypothesis

If `⋆` is accumulative and `f` is multiplicative for it into a commutative
ring, then every value `f m` is a ring idempotent, so by
`IdempotenceForbidsDescent.idem-invertible-is-unit` applied to the ring's
**multiplicative** monoid:

```
accumulative-unit-values-are-one :  f m invertible  →  f m ≡ 1r
```

An accumulative law admits no multiplicative weight taking any unit value
other than `1`. Over ℤ the units are `±1`, so

```
sign-is-not-accumulable :  ¬ (f m ≡ −1)
```

**Sign is not accumulable.** Not hard to accumulate — there is no
accumulating law and no multiplicative `f` taking the value `−1`, ever.
That rules out `λ` everywhere and `μ` off the squares, for every
accumulative law at once.

Note this is strictly stronger than `NoNormOnAJoin`'s two-valuedness and
needs *less*: no zero divisors hypothesis, no domain, any commutative ring.

### The bridge is a modelling claim and is stated as one

This is **not** a theorem about sieves. "A sieve's state law is
accumulation of congruence knowledge, and its weight must be
multiplicative for that law" is a modelling claim, proved nowhere here.
The honest form is a conditional, and it is worth having as one:

> *If* a sieve's combination law is accumulative and *if* its weight must
> be multiplicative for that law, *then* the weight is `1` wherever it is a
> unit, hence cannot be `λ`.

Both antecedents are open. Promoting the bridge would be the same error as
publishing a fitted constant, one level up: a resemblance sold as a
mechanism.

---

## 14. Addendum, same session: §13's rhyme is dead, and its death is the finding

§13 left a conditional with two open antecedents and warned that promoting
it would be the fitted-constant error one level up. The second antecedent
is **false**. `formal/cubical/NaturalMachine/OverlapIsTheCost.agda`
(checked, exit 0) kills it and keeps what the death exposes.

### The refutation

Sieve weights are multiplicative across **coprime** arguments. In the
derivation chart coprime means **disjoint support**, and there the two
operations of this entire thread coincide:

```
disjoint-agree :  Disjoint u v  →  u ⊔ v ≡ u ⊕ v
```

The join *is* the sum on that locus. And nothing is disjoint from itself
except the trivial state:

```
self-disjoint-is-trivial :  Disjoint u u  →  u ≡ 0
```

So on the coprime locus idempotence has no purchase — you cannot form
`u ⋆ u` and stay inside it — and `sign-is-not-accumulable`'s hypothesis is
unsatisfiable except at the unit. The theorem is true and simply does not
reach `μ` or `λ`. The rhyme is dead. Recording it as a rhyme is what made
this cheap to find.

### What the death exposes

`NoNormOnAJoin` proved a join-multiplicative norm is two-valued. But `val`
**is** multiplicative for the join on disjoint arguments:

```
val-⊔-disjoint :  Disjoint u v  →  val (u ⊔ v) ≡ val u · val v
```

— a faithful, wildly-many-valued multiplicative weight for the join,
defined exactly on the coprime pairs, and checked at a concrete instance
(`2 ⊔ 3 = 6`). So the earlier theorem's whole strength came from
quantifying over **all** pairs.

> The obstruction is not the join. **The obstruction is overlap** — and
> overlap is exactly the locus where the two operations disagree.

Which relocates the walk's cost precisely. A sieve only ever combines
coprime data, so it lives where join = sum and a faithful weight exists.
The walk combines `1,2,3,4,…`, and `2, 4, 8` all touch the prime `2`: its
data overlap constantly. Every overlap is a place where the join discards
what the sum would have kept, and the discarded amount is the whole
difference between `k!` and `lcm(1..k)`.

**Not claimed:** any rate. That sentence is a *location*, not a bound.
Nothing computes how much the join discards; `lcm(1..k)` versus `k!` is
named as the quantity to compute, and naming it is what the module does.

### Corrected summary of the thread

Five of the six negative results above are now visible as one statement
with a scope error in the original reading, twice over:

1. §1–2 read `disjoint-support` as arithmetic's barrier; it is the **line's**.
2. §§8–13 read idempotence as the join's obstruction; it is **overlap's**.

In both cases the theorem was right and the quantifier was wrong. That is
the failure mode this thread has now produced twice, and it is worth
naming: *a true theorem, read at a scope it was never proved at.*

---

## 15. Addendum, same session: §14 has the sign backwards

§14 concludes "every overlap is a place where the join discards what the
sum would have kept" and calls that the walk's *cost*. The two halves are
right and the reading is backwards. **Discarding makes the state smaller.**
`lcm(1..k) = e^ψ(k) ≈ e^k` while `k! = e^{k log k}`; the join's state is
exponentially *smaller* than the sum's, and overlap is exactly where that
saving happens.

> Overlap is not the walk's cost. Overlap is the walk's **saving**.

`formal/cubical/NaturalMachine/JoinSavesTheMeet.agda` (checked, exit 0)
says how much, exactly.

### The identity

```
max x y  +  min x y  ≡  x + y
```

lifted to derivations and pushed through `val`:

```
lcm-gcd :  val (u ⊔ v) · val (u ⊓ v)  ≡  val u · val v
```

which is the classical `lcm(a,b)·gcd(a,b) = a·b`. In the tropical chart it
is not a theorem about divisibility at all — it is `max + min = x + y`, and
every trace of number theory has evaporated. `⊔≤⊕` gives the consequence
with an explicit witness: the join's state always divides the sum's, and
the quotient is the meet.

So **the join's compression ratio against the sum is the gcd**, pointwise
and exactly. On the coprime locus the meet is trivial and the join saves
nothing — which recovers §14's `val-⊔-disjoint` as a corollary of an
identity rather than a separate proof. Checked instance: `4 ⊔ 8 = 8`,
`4 ⊓ 8 = 4`, `8 · 4 = 32 = 4 · 8`.

### What survives, and what is now open

Everything §14 *proved* stands — `disjoint-agree`,
`self-disjoint-is-trivial`, `val-⊔-disjoint`, and the refutation of §13's
parity rhyme. What is withdrawn is the sign of §14's reading, and with it
that module's name.

And the consequence for the thread: if the join is a saving, then the
walk's `e^ψ(k)` is what **survives** maximal compression, not what the
compression costs. Distinguishing `k` inputs needs `log k` bits; the walk
carries `ψ(k) ≈ k` of them. That gap is not overlap, and this thread has
not located it. §14's answer was wrong; the question goes back to open.

### Running tally of this session's own errors

| # | claim | fate |
|---|---|---|
| 1 | `disjoint-support` is arithmetic's barrier | scope-corrected — it is the line's |
| 2 | descent = bhāvanā inversion | refuted (§9) |
| 3 | the walk has neither descent mechanism | caught pre-landing (§9) |
| 4 | the parity rhyme | refuted (§14) |
| 5 | overlap is the walk's cost | sign-corrected (§15) — it is the saving |

Five, of which three were mine and made tonight. The corpus's protocol says
refuting your own claim is the most respected act here; the rate at which
that is needed is itself the finding, and it is the reason nothing above
should be read at a scope wider than its own statement.
