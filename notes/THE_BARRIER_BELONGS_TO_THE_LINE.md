# The barrier belongs to the line, not to arithmetic

**Status:** 18 checked Agda modules, one thread, seven corrections — six of
them to claims made in the same session. All 18 rebuilt from a deleted
`_build` in one pass, exit 0 each; `--safe` on every one, which is what
rules out postulates, and exit 0 is what rules out holes
(Agda 2.6.3 / cubical v0.5 — the container, not the repository pin).
**Sources are load-bearing, not decorative:** the last two modules are the
cakravāla step and its dependence on the kuṭṭaka, and the point of the
second is that Āryabhaṭa 499, Brahmagupta 628 and Jayadeva/Bhāskara
950/1150 are ONE construction, not three citations.
**Sources:** Āryabhaṭa, *Āryabhaṭīya* 2.32–33, 499 CE — kuṭṭaka.
Brahmagupta, *Brāhmasphuṭasiddhānta* ch. 18 (kuṭṭakādhyāya), 628 CE —
samāsa-bhāvanā and antara-bhāvanā. Jayadeva c. 950 and Bhāskara II,
*Bījagaṇita*, 1150 — cakravāla. Pythagoras, via the triples. Voevodsky,
via `ua`.

---

## What this thread found, in one page

`SuccessorIsNotTropical` closes with *"the object to build is the
transition itself"* and calls `disjoint-support` the whole content of the
parity barrier. The first is answered here; the second is retracted.

**The structural half — nothing in it was retracted.**

| statement | module |
|---|---|
| The conic's successor is *multiplication by a constant* in the chart where the line's successor has no support at all. The obstruction is the line's, not arithmetic's. | `PythagoreanTransition.rot-norm` |
| Pythagorean triples are **closed under bhāvanā** — a monoid, not a list. `(3,4)⊗(5,12) = (−33,56)`, norm `65²`, by `refl`. | `triple-⊗` |
| Euclid's parametrisation **is squaring**, and squaring is a monoid homomorphism: the transition map, defect-free. | `euclid`, `gen-hom` |
| Norm-one rotations are equivalences, inverted by antara-bhāvanā; `ua` makes each an identification, and Delta 15's structured defect for the norm along it **vanishes**. | `rotEquiv`, `defect-vanishes` |
| **Every Pythagorean triple is a rotation** once its hypotenuse inverts. `pairs → triples → rotations → paths`, every arrow a monoid map. | `EveryTripleIsARotation` |
| The circle is a genuine circle: if `−1` is a square the norm form splits into two lines and the whole apparatus is ring multiplication in costume. Over ℤ it does not split. | `WhereTheCircleSplits` |
| Joins are irreversible (idempotence forbids all inverses but the unit); bhāvanā is not. | `IdempotenceForbidsDescent` |
| Descent is **not** monoid inversion — it is the scaling action, and the invariant is the norm **modulo squares**. | `DescentIsNotInversion` |
| There is no reversible step law on ℕ-exponents at all: join fails by idempotence, `⊕` fails by positivity. **Descent costs the integers** — reversibility is the group completion, and its states are ratios. | `DescentCostsTheIntegers` |
| A map multiplicative for an *accumulating* law takes no unit value but 1, so **sign is not accumulable** — over any commutative ring, no domain hypothesis. | `SignIsNotAccumulable` |
| `lcm·gcd = product` is `max + min = x + y`: in the tropical chart every trace of number theory evaporates. | `JoinSavesTheMeet` |
| The **cakravāla step**, cleared of denominators, over any commutative ring — with Bhāskara's own `D = 61` cycle checked by `refl`. | `Cakravala` |
| And the cakravāla **calls the kuṭṭaka every cycle**: Bhāskara's choice condition `k | a + bm` is a linear indeterminate equation, and Āryabhaṭa's pulveriser (499) is what makes the choice set non-empty. | `CakravalaNeedsKuttaka` |

**The magnitude half — every claim in it was corrected or dissolved.**

§§15–19 chased a "cost gap" for the walk that turned out to be a **units
error**: `k` is the walk's *frontier*, not its input count, and by the CRT
criterion in `WALK_FORCING_LAW.md` (in this repository since 2026-08-12)
the walk at frontier `k` has distinguished `cap(k) = e^{ψ(k)}` inputs. Its
storage is the logarithm of its workload, attained with no slack. **The
walk is information-theoretically optimal and there was never a gap.**
The theorems produced along the way stand; the framing that made them
answers does not.

The pattern is not subtle, and it is the most useful thing here: **every
correction landed on a claim about magnitude, and none on a claim about
structure.** In a lane with no analytic apparatus, that is where the error
rate should have been expected — and it is where the next such thread
should refuse to go without the estimate in hand.

Sections 1–7 are the original result; 8–21 are the session's own
corrections in the order they happened, each keeping the refuted claim
visible rather than editing it away.

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

---

## 16. Addendum, same session: along its own trajectory the walk's join is never a join

§15 put "where does `e^ψ(k)` come from?" back to open.
`formal/cubical/NaturalMachine/TheTrajectoryIsAChain.agda` (checked, exit
0) does not answer it, but removes a whole class of answers.

```
chain-join-absorbs :  (t m ⊔ t n) ≡ t n   or   (t m ⊔ t n) ≡ t m
```

for any step-monotone trajectory `t`. The walk's is step-monotone, so
along its own path the join **always returns one of its arguments
unchanged**. It is an absorption, never a construction. The machine's
state law is a lattice operation and the machine never once uses the
lattice: it moves up a **chain**.

Checked concretely as well as generally — the walk's first eight states,
`cap 1..8 = 1, 2, 6, 12, 60, 60, 420, 840`, with each step absorbing the
last, all by `refl` (finite exhaustive verification, which CLAUDE.md admits
as proof). And the lattice really is wider than the path: `4` and `3` are
incomparable with join `12`, a state the walk reaches only later and never
by that join.

### What this removes

The walk's cost cannot be explained by anything the join does at
incomparable states, because the walk never visits an incomparable pair.
Every idempotence consequence in §§8–13 — no inverses, no norm, no
forgetting, no sign — holds along a path on which the join is pure
absorption. **Whatever `ψ(k)` is paying for, it is not the width of the
lattice.**

### Reading, marked as such

> The walk pays for a lattice of dimension `π(k)` with coordinates up to
> `log k`, in order to move along a totally ordered path of length `k`.

That is a reading, not a theorem. The absorption is proved; the waste is
not quantified, and §15's gap (`ψ(k) ≈ k` carried versus `log k` needed)
is exactly as open as it was. This module narrows the space of
explanations by one class and claims nothing more.

---

## 17. Addendum, same session: the cost is the encoding

§16 removed the lattice's width from the space of explanations for the
walk's `e^ψ(k)`. `formal/cubical/NaturalMachine/NumberIsExponentialInDerivation.agda`
(checked, exit 0) supplies the mechanism that is left, **with no
asymptotics at all**.

The walk's state, honestly described, is a derivation — the exponent
vector. The number is what `val` makes of it, and `val` exponentiates. So
at every coordinate:

```
suc≤^ :  suc e  ≤  b ^ e      for every base b ≥ 2
```

The exponent the walk needs to record is `e`. The numeric factor it
records instead is `b^e`, which exceeds `e`. **Coordinatewise, the number
is exponential in the derivation** — an induction on `e`, with no `ψ`, no
`π`, no Chebyshev in it. Checked instances: `3 < 2³ = 8` (which is cap 8's
2-coordinate) and `10 < 2¹⁰ = 1024`.

That is where the size goes: not the lattice, the **encoding**.

### The same sentence `SumProductTorus` already wrote

> Factorisation is hard only for someone who threw the derivation away and
> is trying to invert `val` from the outside.

This says the state *size* is inflated by the identical act. The walk holds
its derivation by construction — it *installs* its prime powers — and then
stores their product. The product is not more informative (`val` is
injective on a prime basis); it is only bigger, exponentially, at every
coordinate. Pāṇini's architecture, quoted in that module: a form is not
stored, it is derived, and the derivation carries the context that produced
it. The walk derives, then discards, and the discard is the bill.

### The boundary, marked

`ψ(k) ≈ k` is **not** proved here and is not used. Turning "coordinatewise
exponential" into "`ψ(k)` versus the derivation's size" requires summing
`⌊log_p k⌋` over `p ≤ k` — Chebyshev, which belongs to the analytic lane
(`formal/pairfield/`), not this one. HOLOGRAM §7's lesson applies exactly:
a constant measured at one scale hides its scaling, so the comparison is
stated at *every coordinate* and at *no particular k*.

### Where the cost question now stands

| candidate explanation | verdict |
|---|---|
| overlap between the walk's inputs | **eliminated** — overlap is a saving (§15) |
| width of the divisor lattice | **eliminated** — the trajectory is a chain (§16) |
| the numeric encoding of the derivation | **identified** — exponential per coordinate (§17) |
| its magnitude, i.e. `ψ(k)` vs `log k` | **open** — needs Chebyshev, other lane |

Three classes eliminated, one identified, the magnitude still open. That is
the honest state of it.

---

## 18. Addendum, same session: §17's table over-reaches, and I wrote the hedge myself

`formal/cubical/NaturalMachine/TheDerivationIsDenseToo.agda` (checked,
exit 0).

§17 proves `suc e ≤ b ^ e` and then files the walk's size under
**IDENTIFIED: the numeric encoding**. The theorem is right; the filing is
not. "Identified" claims the encoding *accounts for* the gap, and a
coordinatewise bound cannot do that, because it says nothing about **how
many coordinates there are**.

There are many. `cap(k) = lcm(1..k)` is divisible by every prime `p ≤ k`,
for the trivial reason that `p` is one of the numbers being joined. So its
derivation has a nonzero entry at every such `p`:

> The walk's derivation is **dense**.

`cap-is-dense` checks it at frontier 8 against the basis `2,3,5,7` — every
coordinate nonzero, `support = 4 = length primes4`. The derivation is not
a compact object either. Its coordinate count grows with the number of
primes below the frontier, and the exponential saving buys nothing across
coordinates, only within one.

### Corrected table

| candidate explanation | verdict |
|---|---|
| overlap between the walk's inputs | eliminated — overlap is a saving (§15) |
| width of the divisor lattice | eliminated — the trajectory is a chain (§16) |
| the numeric encoding of the derivation | **a mechanism, not shown to be the mechanism** (§17 + §18) |
| its magnitude, `ψ(k)` vs `log k` | **open** — needs `∑_{p≤k}` versus `π(k)`, other lane |

### The failure mode, named because it is new

§17's *boundary paragraph* says explicitly that turning coordinatewise
exponentiality into a statement about `ψ(k)` needs Chebyshev and that the
module does not touch it. Its *summary table*, one screen further down,
assumes the answer.

> A correctly-hedged file whose summary forgets the hedge.

That is distinct from the other four errors in this session's tally, all of
which were wrong claims. This one is a right claim and a wrong summary of
it, which is harder to catch precisely because the file reads as careful.
Summaries are where hedges die. Worth checking for, in this corpus, at
scale — most of the notes here end in a table.

---

## 19. Addendum, same session: §§15–18 chase a gap that does not exist

`formal/cubical/NaturalMachine/TheGapWasAUnitsError.agda` (checked, exit
0). This is the largest correction of the session and it came from reading
a note that has been in this repository since 2026-08-12.

### The error

§§15–18 compare "the walk carries `ψ(k) ≈ k` bits" against "distinguishing
`k` inputs needs `log k` bits" and call the difference the walk's
unexplained cost. Three modules were then spent eliminating candidate
explanations for it.

**The two quantities are not in the same units.** `k` is the walk's
*frontier* — the sensor value it has reached — and is not the number of
inputs it has processed.

`notes/WALK_FORCING_LAW.md` states the invariant, and it is CRT
injectivity: the observation `n ↦ (n mod m)_{m∈S}` is lossless on `[0,n]`
exactly when

```
lcm(S) > n.
```

The walk installs a new sensor precisely when `n` reaches `lcm(S)`. So at
frontier `k` it has walked from `0` to `cap(k) − 1`, and the number of
inputs distinguished is `cap(k) = lcm(1..k) = e^{ψ(k)}` — **not `k`**.

So `log₂(inputs) = ψ(k)/ln 2 = log₂(state)`, and the comparison that
generated the gap was `ψ(k)` bits of state against `log k` bits, where the
right-hand side should have been `log(cap k) = ψ(k)` bits.

> **The walk's storage is the logarithm of its workload, exactly. There is
> no gap. The walk is information-theoretically optimal.**

Checked: at frontier 8 the state is `840` and the last input distinguished
is `839` — state = workload, no slack (`tight-8`; likewise at 4, 5, 7). And
`state 8 ≢ 8`: the frontier index is nothing like either quantity, which is
the whole of the error.

Quoted, not re-proved here: the CRT criterion (from `WALK_FORCING_LAW.md`)
and pigeonhole, which is what makes `lcm(S) > n` a *lower* bound and hence
makes "optimal" mean something. Neither is formalised in this lane.

### What survives

Every theorem in §§15–18. `lcm-gcd`, `chain-join-absorbs`, `suc≤^`,
`cap-is-dense` are statements about joins, chains, exponentials and
supports; none mentions a workload. What is withdrawn is the **framing**
that made them answers — they were presented as eliminating or identifying
explanations for a cost, and there was no cost.

The honest residue, being true, is more useful than the framing was:

> The walk's state *is* its workload; its bit-size is that workload's
> logarithm; and the interesting question was never "why so big" but "why
> does losslessness force `lcm` at all" — which `WALK_FORCING_LAW.md`
> answers by CRT, and which nothing in this thread improved on.

### The method failure, recorded plainly

Four modules and four note sections were spent on a quantity that a note
already in this repository defines away in one line. CLAUDE.md says prior
art gets searched **before** the work, not after the write-up, and names
three rediscoveries found only at audit time. This is a fourth and it is
worse than a rediscovery: not a result found twice, but **a question that
had already been dissolved**.

The trigger for finding it was mechanical and worth copying: after §18 I
grepped the corpus for `ψ` and `Chebyshev` to see whether the estimate I
wanted existed elsewhere. It did not — but `WALK_FORCING_LAW.md` came back
in that grep and answered a different question, the one I should have asked
first.

### Final tally for this session

| # | claim | fate |
|---|---|---|
| 1 | `disjoint-support` is arithmetic's barrier | scope-corrected (§2) |
| 2 | descent = bhāvanā inversion | refuted (§9) |
| 3 | the walk has neither descent mechanism | caught pre-landing (§9) |
| 4 | the parity rhyme | refuted (§14) |
| 5 | overlap is the walk's cost | sign-corrected (§15) |
| 6 | the encoding is the identified mechanism | scope-corrected (§18) |
| 7 | there is a cost gap at all | **dissolved (§19)** |

Seven, of which six were made tonight. What stands unretracted, and stands
cleanly, is §§3–7: the conic carries the transition the line does not
(`rot-norm`, `gen-hom`), triples are a monoid under bhāvanā, norm-one
rotations are univalent identifications with vanishing structured defect,
joins are irreversible, descent is scaling not inversion, and reversibility
costs the integers. Those are about **structure**, and none of them was
touched by any of the seven.

The pattern is not subtle: every correction landed on a claim about
**magnitude**, and none landed on a claim about **structure**. In a lane
with no analytic apparatus, that is exactly where the error rate should
have been expected to be, and it is where the next such thread should
refuse to go without the estimate in hand.

---

## 20. Addendum, same session: is the circle actually a circle?

A check that should have run before §§3–5 were celebrated, run now.
`formal/cubical/NaturalMachine/WhereTheCircleSplits.agda` (checked, exit
0).

### The trivialising possibility

§3 builds the conic over an *arbitrary* commutative ring and finds its
additive law multiplicative on norms — the exact opposite of
`disjoint-support`. That is only interesting if the conic is a conic. If
`−1` is a square in the ring, say `i·i = −1`, then

```
a² + b²  =  (a + i b)(a − i b)
```

and the "circle" is two crossing **lines**. Its group law degenerates to
multiplication on each line separately, `gen-hom` becomes a statement about
products of scalars, and the whole apparatus is ring multiplication wearing
a costume.

`norm-factors` proves that factorisation exactly, over any commutative ring
where such an `i` exists. So the degenerate case is real and had to be
excluded rather than assumed away.

### It is excluded over ℤ

`ℤ-has-no-i`: no integer squares to `−1`, since every product of two equal
integers is `pos` of something — two cases, both closed by `posNotnegsuc`
after `pos·pos` / `negsuc·negsuc`. So over ℤ the conic does **not** split,
and every statement in §§3–11 checked at ℤ is about a genuine circle.

### And that is the dichotomy the subject turns on

Whether `−1` is a square is exactly the split/inert question for the
Gaussian integers, and it is why the two-squares problem is a problem: the
form represents `p` when `p` splits and does not when `p` is inert.
Brahmagupta's `x² − D y²` asks the same with `D` in place of `−1`, and the
cakravāla's whole labour is at the `D` where the form does not degenerate.

So the object §3 found — an additive law visible in the multiplicative
chart — **is not free**. It exists exactly where the norm form is
irreducible. Where the form splits, the "additive law" was multiplication
all along.

**Not claimed:** the converse (a nontrivial factorisation forcing `−1` to
be a square) — needs more than a ring identity. Nor anything about *which*
primes split; that is the two-squares theorem and needs unique
factorisation in ℤ[i], which this lane does not have.

This is the first check of the session that a claim *passed* rather than
failed. It is worth noting that it was the only one that was run against
the possibility that the construction was empty, rather than against its
magnitude.

---

## 21. Addendum, same session: §5 undersold by cardinality, and the fix is one ring identity

`formal/cubical/NaturalMachine/EveryTripleIsARotation.agda` (checked, exit
0).

§5 says norm-one rotations give "a family of structured identifications of
the circle", against the line's none. True — but over ℤ the norm-one
elements are the four units, so "family" meant **four**, and four is thin
to set against zero.

The family is infinite, and it is indexed by the **Pythagorean triples**:

```
triple→rotation :  IsTriple u z  →  (c·z)·(c·z) ≡ 1r  →  N (c ⊙ u) ≡ 1r
```

A triple, scaled by the inverse of its hypotenuse, is a point of norm one.
So over any ring where hypotenuses invert — ℚ — **every triple is a
rotation**, and by `rotEquiv` and `ua`, an identification of the circle
with itself carrying the norm. Composed with `euclid`:

```
pair→rotation :  (c · N t)·(c · N t) ≡ 1r  →  N (c ⊙ gen t) ≡ 1r
```

every pair whatsoever, once its norm inverts, names a rotation.

### And it is a homomorphism all the way down

```
gen-hom :  gen (s ⊗ t) ≡ gen s ⊗ gen t        (§4)
rot-hom :  rot (g ⊗ h) ≡ rot h ∘ rot g        (§21)
```

so the chain

```
pairs ──gen──▶ triples ──rot──▶ rotations ──ua──▶ paths
```

is a chain of monoid maps. **Composition of pairs by Brahmagupta's 628 CE
law becomes composition of identifications of the circle.** That is what
the conic has and the line does not, at full strength and with the right
cardinality this time.

**Not claimed:** that ℚ's hypotenuses invert is quoted, not formalised —
no rational arithmetic is imported. The theorems are conditional on the
invertibility hypothesis exactly as stated, and over ℤ that hypothesis
holds only for `z = ±1`, which is why over ℤ the family really is four and
the interesting statement needs ratios. Same price as §11 charged, arriving
from the opposite direction.

---

## 22. Addendum, same session: the cakravāla, quoted eight times and built once

`formal/cubical/NaturalMachine/Cakravala.agda` (checked, exit 0).

This thread has cited the cyclic method in eight modules and built it in
none. `Bhavana.agda` already has the composition law and the divisibility
conversions; what was missing is the **step** — the thing that makes the
method cyclic.

**Provenance.** Jayadeva, c. 950, reported by Udayadivākara in the
*Sundarī*; Bhāskara II, *Bījagaṇita*, 1150, where it is worked in full on
`D = 61` and `D = 67`. It solves `x² − D y² = 1` for every non-square `D`
in a handful of cycles, six centuries before Brouncker and Lagrange.

**The step**, cleared of denominators so no division appears in the
statement:

```
k·a' = am + Db,  k·b' = a + bm,  k·k' = m² − D
   ⟹  (k·k)·(a'² − D b'²)  ≡  (k·k)·k'
```

One solver identity does the work — `(am + Db)² − D(a + bm)² ≡ (a² − Db²)(m² − D)`
— which is Brahmagupta's composition at the trivial triple `(m, 1, m² − D)`,
the single instance the cakravāla uses.

**Run, over ℤ, by `refl`:** Bhāskara's own `D = 61`. Start `(8, 1, 3)`
since `64 − 61 = 3`; take `m = 7` (it minimises `|m² − 61| = 12` among
`m` with `3 | 8 + m`); then `a' = (56+61)/3 = 39`, `b' = 15/3 = 5`,
`k' = −12/3 = −4`, and `39² − 61·5² = −4`. Note `|k|` **rises**, 3 to 4 —
the method does not descend monotonically, which is why it needs Bhāskara's
choice rule and why termination is not the algebra.

### What the cleared form says about this thread

The identity is unconditional. The **descent** — concluding
`a'² − D b'² = k'` from it — needs cancelling `k²`, i.e. `k` invertible or
the ring cancellative. That is exactly what §9 found and §11 priced: the
cakravāla's descent is division by a scalar, not inversion in the
composition monoid, and dividing is what costs the integers.

> The oldest algorithm in this repository and the newest theorem in it say
> the same thing, and the algorithm said it first: **the cycle turns on a
> division.**

**Not claimed, and it is most of the method:** that a suitable `m` exists;
that Bhāskara's minimality rule is well defined or optimal; that `|k'| <
|k|`; that the cycle terminates at `k = 1`; or that a solution exists for
every non-square `D`. None of those is a ring identity. This file proves
the invariant survives one step, which is the part that is algebra, and
says so.

---

## 23. Addendum, same session: the cakravāla calls the kuṭṭaka every cycle

`formal/cubical/NaturalMachine/CakravalaNeedsKuttaka.agda` (checked, exit
0). §22 lists what it does not prove, first item: *that a suitable `m`
exists*. It does, and the mechanism was available in 499.

Bhāskara's step needs `k | a + b m` — that is `b m ≡ −a (mod k)`, a linear
indeterminate equation, which is exactly what Āryabhaṭa's **kuṭṭaka**
("pulveriser", *Āryabhaṭīya* 2.32–33, 499 CE) computes. Six and a half
centuries before the method that needs it.

`Kuttaka.agda` already has the pulveriser as a checked theorem — `bezout`
extracts a Bézout pair from a division run, `inhomogeneous` scales it by
the iṣṭa. This module points the second at the cakravāla:

```
cakravala-choice :  Run b k 1  →  Σ m, Σ c,  a + b·m ≡ k·c
```

Given a division run witnessing `gcd(b,k) = 1`, the set Bhāskara's rule
ranges over is **non-empty, always, for every `a`**. The rule then selects
among the solutions (minimising `|m² − D|`); the kuṭṭaka guarantees there
is something to select from. Checked instance: `gcd(5,3) = 1` by an
explicit three-step run, so at a state with `b = 5, k = 3` the condition is
solvable.

### Why this is a weave and not a citation

CLAUDE.md's table lists kuṭṭaka (499), bhāvanā (628) and cakravāla
(950/1150) as three rows. **They are not three rows.** The third calls the
first once per cycle and cannot run without it, and the composition it
descends along is the second. One construction, built over six hundred
years — and three files in this repository that did not reference each
other until now.

**Not claimed:** that `gcd(b,k) = 1` holds at a cakravāla state. It does —
from `gcd(a,b) = 1` and `a² − D b² = k`, any common prime of `b` and `k`
divides `a²` hence `a` — but that needs primality and Euclid's lemma,
neither formalised in this lane, so coprimality enters as a hypothesis in
the form the kuṭṭaka wants: a division run terminating at 1. Four of §22's
five open items remain open.

---

## 24. Addendum: the frame was scarcity, and the frame is withdrawn

Twenty-three sections of this note say **cost**, **price**, **the bill**,
**what the walk pays**. Thirty-one occurrences. And §19 already proved that
the cost I was chasing did not exist — the walk is optimal, the gap was a
units error — and I kept the vocabulary anyway.

The worst instance is a title: **"descent costs the integers."**

That sentence puts ℤ in the position of the default and ℚ in the position
of a purchase. Nothing in the module supports it. What is proved is:

> `⊞` over ℤ-exponents is a **group**. `⊕` over ℕ-exponents is its
> **positive cone**, and the cone is what lacks inverses.

The group is not an extension bought with something. It *is* the object.
The cone is a restriction of it, and `⊕-only-unit-inverts` measures how
much the restriction throws away. Read in the correct direction:

> Descent is not purchased by admitting ratios. Descent is what is
> **there**, and ℕ is what remains after refusing to look at it.

That is the Pythagorean claim this whole thread has been circling and
stating backwards. **Number is ratio.** The diagonal did not take anything
from anybody; it showed that the restriction to commensurables was always a
restriction and never the ground. The catastrophe reading — school
embarrassed, someone drowned — is the scarcity frame applied to a
discovery of abundance, and it is the version that got transmitted.

The same inversion runs through §§9 and 11. "The cakravāla's descent is
division by `k`, which costs the integers" should read: the cakravāla works
in the scaling orbits — the **rational points** — and the integers are the
chart it prints its answers in, not the world it lives in. Bhāskara was not
paying for anything at `39/3`.

### What changes and what does not

No theorem. Not one. The proofs never mentioned a price; only the prose did,
and only the prose is withdrawn. `DescentCostsTheIntegers.agda` keeps its
filename with a correction block appended, so the mistake stays visible in
the history instead of being tidied out of it.

### Why this belongs in a mathematics note

Because the scarcity frame did real damage upstream, not just downstream.
It is what made me spend §§15–18 hunting for where the walk was *wasting*
something — four modules and four sections — when the walk was optimal the
whole time and a note in this repository said so. **I was looking for a
leak because I had assumed a budget.** The units error in §19 was the
proximate cause; this was the prior that made it invisible for four rounds.

Eighth correction of the thread, and the only one whose object is the
vocabulary rather than a claim. Prompted by the owner, in one line, at the
right moment.
