# SEED33 — Where the corpus's negations refuse a witness, and one place they no longer do

**Agent:** SEED-33, persona A. A. Markov Jr. / Kleene (constructivist).
**Date:** 2026-08-14. **Status:** exact; no computation was run; no Python was
written or executed.
**Draw:** `notes/KUTTAKA_SOLUTION_FAMILY.md`,
`collab/messages/workers/20260812T090836.491254Z--codex_formation--0006.md`;
frontier field *matching and unification modulo an equational theory (AC, ACU,
ACI)*; lens *"when a negation refuses to yield a witness, name the principle
that would supply it"*; Ibn Khaldūn (cyclical structural explanation).

---

## 0. The discipline, stated once

A classical proof of `¬∃x P(x)` is worth exactly as much as the object it
hands you. There are three grades, and the corpus contains all three:

- **Grade A — decidable negation.** `¬∃x P(x)` is proved by a *bounded*
  exhaustion or by an invariant that a candidate would have to violate. The
  negation carries a finite, checkable certificate. No principle beyond
  primitive recursion is used.
- **Grade B — stable negation.** `¬¬∃x P(x)` is proved (e.g. by a counting or
  measure argument), and `∃x P(x)` is then asserted. The gap is exactly
  **Markov's principle** when `P` is decidable and the search is over `ℕ`, and
  **excluded middle on an undecidable predicate** otherwise. MP makes the
  search *terminate* but supplies **no bound**: the resulting algorithm is
  correct and has no complexity.
- **Grade C — asserted Skolem function.** A `Π₂` claim `∀ε ∃X₀ ∀X>X₀ …` is
  proved with the remark "the implied constant is effective". "Effective" is a
  *promise* of a witness, not a witness. Constructively the statement is not
  the `Π₂` sentence but the pair (sentence, numeral-valued `X₀(ε)`), and only
  the second half is usable downstream.

The corpus is, by habit, better at this than most: its standard move is the
*obstruction certificate*, which is Grade A. The systematic leak is Grade C.

---

## 1. Census of non-constructive steps

| # | site | what is claimed | principle actually used | what a constructive version needs |
|---|---|---|---|---|
| N1 | `SEED12_SYMMETRIC_REPAIR_UNIQUENESS_FAILS.md` §"Minimality" (l.112): *"No smaller witness exists: for `\|X\| ≤ 2` every pair …"* | non-existence over an infinite class | **none** — the class is cut to `\|X\|≤2` first and then exhausted | nothing. **Grade A.** This is the model the rest should imitate: the quantifier was made bounded *before* the negation was taken. |
| N2 | same, l.183: *"blocks of size `6/4 = 3/2`. No such `σ` exists"* | non-existence of a partition | **none** — a non-integrality certificate | nothing. **Grade A.** The witness for the negation is the integer equation `4 ∤ 6`. |
| N3 | `KUTTAKA_CONGRUENCE_UPDATE.md` §1: *"the pair `(g, a−r)` is a complete obstruction certificate"* | inconsistency of a congruence system | **none** | nothing. **Grade A**, and explicitly named as such by its author. Note this is the *only* place in the kuṭṭaka lane where a negative verdict is issued, and it already ships its witness. |
| N4 | `ASYMPTOTIC_FACTOR_RIGIDITY.md` ll.45, 180, 191: *"for all sufficiently large `X`. The implied constant is effective."* | `δ_nr(F_X) ≫ log₂X log₄X / log₃X` | **Grade C.** The sentence is `∃c ∃X₀ ∀X>X₀`; `c` and `X₀` are asserted to exist and are never written. Compounding: the `X₀` is inherited from Ford–Maynard–Tao and from Lenstra's gap theorem, so the promise is delegated twice. | the numerals. Failing that, the *shape*: `X₀` as a function of `r` and of Lenstra's `c(n)`. Per `SEED20_FINITE_IDENTIFICATION.md` Cor. 0.1 this is the corpus's own rule: a `Π₂` claim with an unexhibited threshold has measured a `Σ₀` shadow, and the threshold *is* the error term. |
| N5 | `SEED14_WIEFERICH_AUXILIARY_OBSTRUCTION.md` l.181: *"No condition on `b` modulo `q²` can decide `e_b(q)≥3`"* | non-existence over the infinite space of mod-`q²` conditions | **Grade B as written** — the nested-subgroup argument shows a separating pair must exist without producing one. | a single pair `b₁ ≡ b₂ (mod q²)` with `e_{b₁}(q) ≥ 3 > e_{b₂}(q)`. **Supplied in §2.2 below.** |
| N6 | `KUTTAKA_SOLUTION_FAMILY.md` §2, "the blindness theorems": *"nothing computable from `a,b,c` and the endpoint selects `t`"* | non-existence of a computable section | this is Grade A **iff** the proof exhibits two inputs with equal observables and different `t`; the note asserts "beyond-family witnesses exhibited exactly", so it is. `THRESHOLD_GENERATION_DICHOTOMY.md` §8.2(3) independently replicates it with the Calendar Round fiber — again by an explicit pair (`d`, `d+18980`). | nothing. **Grade A.** Worth recording that the corpus's flagship *impossibility* results are its most constructive ones. |
| N7 | The finiteness of a Hilbert basis, used implicitly wherever "the complete set of unifiers is finite" is invoked (§3) | Dickson's lemma | classically: **well-ordering / minimal-bad-sequence**. Constructively Dickson's lemma is provable (Coquand–Persson, inductive almost-full relations) but the proof is a bar induction and yields **no bound on the basis**. | an explicit basis, or an explicit bound on its size, for the ideal actually in play. **Supplied in §3.3 for the two-variable case: the basis has exactly one element and it is written down.** |

**The pattern, in Ibn Khaldūn's register.** The corpus cycles. A lane opens
with an algorithm (Grade A: the pulverizer *is* its own witness), matures into
structure theorems (still Grade A: impossibility by explicit indistinguishable
pair), and only at the asymptotic frontier does it import Grade C statements
wholesale from an outside literature — at which point the lane's certificates
stop composing, because an unexhibited `X₀` cannot be substituted into
anything. N4 is not a lapse of care; it is the predictable senescence of a
lane that has run out of finite objects to compute with. The remedy is the
same each cycle: find the finite object again.

---

## 2. Two negations made constructive

### 2.1 The main one: ℕ-solvability of the pulverizer's equation, decided without search

`KUTTAKA_SOLUTION_FAMILY.md` §1 records the ℤ-family. The tradition's own
practice (the *iṣṭa* reduction to the least **positive** solution) already
lives one step outside it, in `ℕ`, and *there* the existence question is a
genuine `Σ₁` search: "is some member of the family nonnegative?" ranges over
an unbounded parameter `t`. Answering "no" by exhausting `t` never terminates;
answering "yes" by MP terminates with no bound. Both are avoidable.

Throughout: `a, b ≥ 1`, `g = gcd(a,b)`, `A = a/g`, `B = b/g`, `c ≥ 0`.

**Lemma 2.1 (the pulverizer's output, used as a modular inverse).** The vallī
back-substitution returns `u, v ∈ ℤ` with `ua + vb = g`, in `O(log min(a,b))`
divisions. Reducing mod `b` gives `uA ≡ 1 (mod B)`, so `u mod B` is the
inverse of `A` in `ℤ/B`. ∎

**Theorem 2.2 (decision by one comparison).** Suppose `g ∣ c` (decidable by one
division; if `g ∤ c` the certificate is `(g, c)` and there is no solution even
in `ℤ`). Put

  `x* := (u · (c/g)) mod B ∈ [0, B)`.

Then `ax + by = c` has a solution with `x, y ∈ ℕ` **if and only if
`a·x* ≤ c`**, and in that case `(x*, (c − a x*)/b)` is one, and is the one with
least `x`.

*Proof.* For `x ≥ 0`, `y = (c − ax)/b` is an integer iff `ax ≡ c (mod b)` iff
`Ax ≡ c/g (mod B)` iff `x ≡ u(c/g) ≡ x* (mod B)`. So the admissible `x` are
exactly `x* + kB`, `k ≥ 0`. On these, `y ≥ 0` iff `ax ≤ c`, and `ax` is
strictly increasing in `k`. Hence a nonnegative solution exists iff the
smallest admissible `x`, namely `x*`, satisfies `a x* ≤ c`. ∎

**Corollary 2.3 (the negation has a witness).** If `a x* > c`, the statement
"no `(x,y) ∈ ℕ²` solves `ax+by=c`" is certified by the finite object

  `(u, v, x*, a x* − c)`,

checkable by three identities — `ua+vb = g`, `0 ≤ x* < B` with
`A x* ≡ c/g (mod B)`, and `a x* − c > 0` — none of which mentions a search.
The predicate is **decidable**, not merely stable: neither Markov's principle
nor excluded middle is used anywhere. An unbounded `Σ₁` search has become a
constant-time comparison downstream of `O(log min(a,b))` divisions.

**Corollary 2.4 (Frobenius, exactly, as a two-line consequence).** Let
`g = 1`, `a, b ≥ 2`. Then `c` is *not* representable in `ℕ` iff `c < a x*(c)`,
and the largest such `c` is exactly

  `F(a,b) = ab − a − b`.

*Proof.* (≤) If `c ≥ ab−a−b+1` were unrepresentable then `c < a x*` with
`x* ≤ b−1`, and `c ≡ a x* (mod b)` with `c < a x*` forces `c ≤ a x* − b ≤
ab − a − b`, a contradiction. (=) `ab−a−b` is unrepresentable: `ax+by =
ab−a−b` gives `a(x+1) + b(y+1) = ab`, so `a ∣ b(y+1)`, so `a ∣ y+1`, so
`b(y+1) ≥ ab` and `a(x+1) ≤ 0`, impossible for `x ≥ 0`. ∎

**Corollary 2.5 (Sylvester's count, from the same criterion).** For
`0 ≤ c ≤ F`, exactly one of `c`, `F−c` is representable; hence the
unrepresentable `c` number `(a−1)(b−1)/2`.

*Proof.* Not both: their sum `F` would be representable, contradicting 2.4.
Not neither: if `c` is unrepresentable then `c = a x* − mb` with `m ≥ 1` and
`0 ≤ x* ≤ b−1`, whence `F − c = a(b−1−x*) + b(m−1)` is a nonnegative
combination. `F = ab−a−b` is odd for coprime `a,b ≥ 2` (check both parity
cases), so `c ≠ F−c` and the `F+1 = ab−a−b+1` values pair off exactly:
`(ab−a−b+1)/2 = (a−1)(b−1)/2`. ∎

**What was gained.** Corollaries 2.4 and 2.5 are classical (Sylvester, 1882 —
**CITED**, standard, not claimed as new). The *point* is the route: they fall
out of Theorem 2.2's witness `x*` with no asymptotics and no threshold, and
they are exactly the "explicit bound that turns an unbounded search into a
decidable one" the mandate asks for. The vallī, per
`KUTTAKA_SOLUTION_FAMILY.md` fact 2, is the trace that produces `u`; `x*` is
the *iṣṭa* section, fact 3; and Theorem 2.2 says that the declared convention
of the tradition is not merely a convention — it is the decision procedure for
the `ℕ`-problem. The section is load-bearing in a stronger sense than the note
claims: it is the unique point of the fiber at which solvability is decidable
by inspection.

### 2.2 The second one: a witness for N5

`SEED14`'s claim is that no condition on `b` mod `q²` decides `e_b(q) ≥ 3`.
The argument (nested deciding subgroups) is Grade B. A witness pair:

**Proposition 2.6.** Let `q ≥ 3` be prime. Hensel-lift a primitive
`(q−1)`-th root of unity from `ℤ/q` to `b₁ ∈ (ℤ/q³)^×` with
`b₁^{q−1} ≡ 1 (mod q³)` — a terminating procedure, two Newton steps. Put
`b₂ = b₁ + q²`. Then `b₁ ≡ b₂ (mod q²)`, `e_{b₁}(q) ≥ 3`, and
`e_{b₂}(q) = 2`.

*Proof.* Binomially, mod `q³`,
`b₂^{q−1} ≡ b₁^{q−1} + (q−1) b₁^{q−2} q² ≡ 1 + (q−1)b₁^{q−2} q²`,
and `q ∤ (q−1)b₁^{q−2}`, so `b₂^{q−1} ≢ 1 (mod q³)` while
`b₂^{q−1} ≡ 1 (mod q²)`. ∎

So the negation now yields an explicit pair, computable for each `q` by a
bounded procedure. N5 moves from Grade B to Grade A. (This says nothing about
the *infinitude* of Wieferich or non-Wieferich primes, which remains open and
is not touched.)

---

## 3. The unification-modulo-a-theory question, answered plainly

The mandate asks whether the kuṭṭaka solution family *is* an AC/ACU-unification
problem. **It is not.** It is an **AG**-unification problem, and the difference
is exactly the difference between §1's ℤ-family and §2's ℕ-decision.

### 3.1 What the family is

Let `AG` be the equational theory of abelian groups (associativity,
commutativity, unit, **inverse**). Elementary `AG`-unification with constants
is the solution of linear systems over `ℤ`, decided by Hermite/Smith normal
form in polynomial time, and it is **unitary** (type 1): every solvable
problem has a *single* most general unifier.

For `aX − bY ≐ c` **with `g | c`** (K1, SEED-99: the hypothesis is not
optional and was omitted here as it was in the source note — see the currency
box below), the mgu is

  `σ = { X ↦ x₀ + B·T, Y ↦ y₀ + A·T }`, `T` a fresh variable.

This is a precise, not analogical, restatement of the note's three facts:

1. **"The answer is a family"** = *AG-unification is unitary and the mgu carries
   one fresh variable*. The family is the mgu; `t` is `T`.
2. **"The vallī is a trace"** = the unification algorithm's derivation, from
   which `σ` is read off by back-substitution. Its length is the Euclidean word
   length, which is the algorithm's step count.
3. **"A section is a declared convention"** = *a unifier is not a ground
   substitution*. No unification procedure returns a ground instance of an mgu
   with a free variable; choosing one is instantiation, which is input, not
   output. This is the blindness theorem, and in this vocabulary it is a
   triviality — which is the useful part: it says the impossibility is a
   property of the *theory* (`AG` is unitary with a nontrivial unit group of
   the coefficient ring), not of the endpoint observable.

> **Currency, K1 (SEED-99, 2026-08-14).**
> `notes/SEED49_completeness_of_three_families.md` §1 now *proves* what §3.1
> here imports as unification theory, and the two notes agree on the family.
> SEED-49 Theorem 1 (`ax − by = c` solvable in `ℤ` iff `g | c`) and Theorem 2
> (the solution set is exactly `(x₀ + t·b/g, y₀ + t·a/g)`, and `t ↦ …` is
> injective) are, in this note's vocabulary, exactly *"the `AG`-unification
> problem is solvable iff `g | c`, and when solvable it is unitary with a
> one-variable mgu"*. **The classification in §3 stands unchanged and now rests
> on a corpus proof rather than on a cited type-classification alone.**
> Two consequences applied at their sites:
> (i) SEED-49 flags that `KUTTAKA_SOLUTION_FAMILY.md` §1.1 omits `g | c`;
> §3.1 above inherited the omission from that source and is repaired in place.
> Theorem 2.2 of §2.1 never had the defect — it assumes `g | c` explicitly and
> ships `(g, c)` as the certificate otherwise — so the constructive half of
> this note is untouched.
> (ii) SEED-49's injectivity clause needs `a, b` not both `0`, and its `b ≠ 0`
> caveat is the same one §2.1 needs for `B = b/g` to be a modulus; both notes
> exclude it, consistently.

**Imported complexity.** `AG`-unification: decidable, unitary, polynomial. The
kuṭṭaka's `O(log min(a,b))` divisions is the two-variable instance and is
optimal in the sense that it is the Euclidean word length itself.

### 3.2 What AC/ACU is instead, and where the corpus already knows this

Drop inverses. Elementary `AC`-unification is, by Stickel (1981), exactly the
solution of homogeneous linear Diophantine systems over **ℕ**; a complete set
of unifiers corresponds to the **Hilbert basis** (the minimal nonzero
nonnegative solutions) of the solution monoid. Consequences, all **CITED** as
standard:

- `AC` and `ACU` unification are **finitary** (type ω) — finite complete sets
  of unifiers, but in general *not* unitary;
- the Hilbert basis can be exponential in the number of variables;
- `AC`-unifiability (with free symbols) is **NP-complete** (Kapur–Narendran,
  1992); ~~the elementary/with-constants cases are NP-complete as well;~~
  **the *with-constants* case is NP-complete (that is Kapur–Narendran's
  statement, and it is the inhomogeneous system, i.e. the shape §3.3 is about);
  the *elementary* case is not, and cannot be unless P = NP** — see the
  correction below;
- `ACI`/`ACUI` is unitary for elementary unification and polynomial with
  constants — which is precisely the fact
  `THRESHOLD_GENERATION_DICHOTOMY.md` §9(2) already imported for a *different*
  object (the scope semilattice). The corpus therefore has `ACUI` on file and
  `AC`/`ACU` not; this note supplies the missing row.

> **Correction, K1/K3 (SEED-99, 2026-08-14) — derived, not cited.** Elementary
> `AC`-unification has **no constants and no free function symbols**, so every
> term is a multiset of variables and each equation is *homogeneous*: a system
> `M·n = 0` to be solved with `n ∈ ℤ_{>0}^V`, where `n_v = |σ(v)|` is the size
> of the multiset assigned to the variable `v`. *Necessity:* counting
> occurrences of each term in the range of a unifier gives such an `n`.
> *Sufficiency:* given `n`, send each `v` to `n_v` copies of one fresh variable
> `z`; both sides of every equation become the same number of copies of `z`.
> So elementary `AC`-unifiability is exactly *"does a homogeneous rational
> system have a strictly positive solution?"* — LP feasibility, polynomial, and
> integrality is free because a positive rational solution scales to a positive
> integer one. (With `ACU` the unit makes `n_v = 0` legal and every elementary
> problem is solvable outright.) An NP-complete problem in P forces P = NP, so
> the struck clause is **refuted**, not merely unsupported.
>
> **This strengthens §3.3 rather than weakening it.** The NP-complete case is
> precisely the one *with constants* — the **inhomogeneous** system, which is
> exactly the `ℕ`-shape of the kuṭṭaka that Theorem 2.2 decides by one
> comparison at two variables. The note's headline ("do not import AC's
> NP-completeness into the kuṭṭaka") is aimed at the right target, and the
> two-variable collapse is now a collapse *of the NP-complete case*, which is
> the stronger reading. Nothing else in §3 moves: `AG` is unitary and
> polynomial in both the elementary and the with-constants case, which is all
> §3.1 uses.

### 3.3 The exact point of contact, and the exact divergence

**Proposition 3.1 (the homogeneous case coincides).** The `ℕ`-solutions of
`aX = bY` form a free monoid on the single generator `(B, A) = (b/g, a/g)`.

*Proof.* `aX = bY` ⟺ `AX = BY` with `gcd(A,B)=1` ⟺ `B ∣ X`, and then
`X = kB`, `Y = kA`. ∎

So in the *homogeneous two-variable* case the Hilbert basis has exactly one
element, `AC`/`ACU` is unitary there too, and it is the *same line* the
pulverizer's `t`-family runs along. This is the whole overlap — and note that
it also discharges N7 for this lane: the finiteness of the basis needs no
Dickson's lemma here, because the basis is exhibited.

**The divergence is the inhomogeneous case,** and it is exactly Theorem 2.2:
over `ℤ` (`AG`) the fiber is a torsor and solvability is `g ∣ c`; over `ℕ`
(`ACU`-matching) the fiber is a truncated ray, solvability is `a x* ≤ c`, and
the truncation is invisible to the `AG`-mgu. Frobenius and Sylvester (2.4,
2.5) are the *measure* of that invisibility. `KUTTAKA_SOLUTION_FAMILY.md` says
sections must be imported and never derived; §2 sharpens it: over `ℕ` the
section is not free-floating convention but the unique canonical
representative, and the residual freedom the blindness theorem detects is
precisely the freedom that `AG` has and `ACU` does not.

**Plain answer to the mandate's question.** The corpus's solution family is
*not* an AC/ACU-unification problem — calling it one would import an
NP-completeness that does not apply and would misdescribe a unitary problem as
finitary. It is `AG`-unification, unitary and polynomial. Its `ACU` shadow is
a different, harder problem in general, which at two variables collapses back
to a single comparison (Thm. 2.2) and at many variables is the NP-complete
Hilbert-basis computation.

---

## 4. Ledger

| statement | grade | where |
|---|---|---|
| Census N1–N3, N6: Grade A, no principle used | **AUDIT**, by inspection of the cited lines | §1 |
| N4 (`ASYMPTOTIC_FACTOR_RIGIDITY` thresholds): Grade C, `Π₂` with unexhibited Skolem function, twice delegated | **AUDIT** (not repaired; the constants live in FMT and Lenstra) | §1 |
| N5 repaired: explicit `b₁ ≡ b₂ (mod q²)` with different `e` | **PROVED** | Prop. 2.6 |
| N7 discharged for the kuṭṭaka lane: Hilbert basis exhibited, no Dickson | **PROVED** | Prop. 3.1 |
| Thm 2.2: `ℕ`-solvability iff `a x* ≤ c`; no search | **PROVED** | §2.1 |
| Cor. 2.3: negation carries a checkable certificate; predicate decidable | **PROVED** | §2.1 |
| Cor. 2.4/2.5: `F = ab−a−b`, count `(a−1)(b−1)/2` | **PROVED** here; classical (Sylvester 1882) — **no novelty claimed** | §2.1 |
| Kuṭṭaka family = mgu of an `AG`-unification problem; unitary; polynomial | **PROVED** (identification) + **CITED** (AG-unification type/complexity) | §3.1 |
| `AC` = ℕ-Diophantine, Hilbert basis, finitary, NP-complete ~~(Stickel 1981; Kapur–Narendran 1992)~~ **with constants** (Stickel 1981; Kapur–Narendran 1992); the **elementary** case is polynomial | **CITED** from standard knowledge; no source text was fetched (egress). The elementary/with-constants split is **PROVED** in the §3.2 correction box (SEED-99, 2026-08-14), not cited | §3.2 |
| Kuṭṭaka family solvable iff `g \| c`; solution set exactly (K); injective in `t` | **PROVED** in `notes/SEED49_completeness_of_three_families.md` §1, Thms 1–2 (added SEED-99, 2026-08-14) | §3.1 |
| the family is *not* an AC/ACU problem | **PROVED** (the theories differ by inverses; §3.3 exhibits the divergence) | §3.3 |

**Owed.** (i) The numerals in N4 — that is a `PROVE` item for whoever owns the
asymptotic lane, and until it is discharged nothing downstream may substitute
into `X₀`. (ii) Verse-level sourcing for the kuṭṭaka, still owed as
`KUTTAKA_SOLUTION_FAMILY.md` says. (iii) Sylvester's paper is cited from
standard knowledge; no primary text was read.

**My least-sure step, for a hostile reader.** Prop. 2.6 assumes `q ≥ 3` and
that a `(q−1)`-th root of unity lifts to `ℤ/q³` — Hensel applies because
`(q−1)x^{q−2}` is a unit mod `q`, but I have not checked the `q = 2` boundary
and do not claim it. Theorem 2.2 is a four-line argument with no such exposure.
