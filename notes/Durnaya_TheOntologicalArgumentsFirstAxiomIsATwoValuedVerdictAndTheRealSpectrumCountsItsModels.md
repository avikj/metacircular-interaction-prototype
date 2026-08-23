# दुर्नय — the ontological argument's first axiom is a two-valued verdict, and this corpus already counts its models

**Term and source.** *naya*, a standpoint; *durnaya*, a standpoint that
asserts itself by denying the others. Siddhasena Divākara, *Sanmatitarka*;
Akalaṅka, *Laghīyastraya* (c. 720–780); the sevenfold predication stated at
Samantabhadra, *Āptamīmāṃsā* 14–23 (c. 6th c.). Nothing below is attributed
to those texts beyond the distinction they name and the theorem this
repository checked under that name.

## The shape

Gödel's ontological argument (1970 manuscript; Dana Scott's circulated
version) rests on a set **P** of *positive properties* fixed by two axioms:

- **Ax1.** P(¬φ) ↔ ¬P(φ) — for every property, exactly one of it and its
  negation is positive.
- **Ax2.** P(φ) ∧ □∀x(φ(x) → ψ(x)) → P(ψ) — P is closed upward under
  entailment.

Together these say **P is an ultrafilter on the algebra of properties**:
total, and closed under the structure's own operation. God-like is then
defined as having every member of P, and Ax3 asserts P(G).

**An ordering of a field is the same object.** A point of Sper K is a
subset of K closed under + and ·, with K = P ⊔ {0} ⊔ −P: total on
{a, −a}, closed under the operations. Prime cone, ultrafilter of
positivity, point of the real spectrum — one object under three names.

## The count

`notes/POSITIVITY_HAS_A_PLACE.md` is the statement that this object is a
**place and not a predicate**, with the count computed per ground field:

| K | \|Sper K\| |
|---|---|
| ℚ, ℝ | 1 |
| number field | r₁ (the real embeddings) |
| ℚ(√2) | 2 |
| ℂ, 𝔽_q, ℚ_p, 𝔽_q(t) | 0 |
| ℚ(x) | 2^ℵ⁰ |

Read against Ax1, each row is a different fate for the argument.

**Zero.** Artin–Schreier (1927): K admits an ordering iff −1 ∉ ΣK². Where
that fails there is no positivity at all — not a weak one, an absent one —
so Ax1 has no model and the premise set is unsatisfiable. The criterion is
worth stating in the argument's own terms: the axioms are unsatisfiable
exactly where a contradiction is already a sum of squares.

**One.** ℚ and ℝ. Here P is unique, so the argument is chart-free and its
conclusion is absolute. §3 of that note is titled *"Why it looked
chart-free"*: the archimedean intuition is the one place where positivity
really is intrinsic, and it is the intuition every reader brings.

**Two.** `machinery/orderings.py` certifies, in exact ℤ[√2] arithmetic with
no floating point, that ⟨1, −√2⟩ is **definite at one ordering of ℚ(√2) and
indefinite at the other**. The same property, positive at one P and not at
another, with both P's satisfying Ax1 and Ax2 in full. G — the bearer of
every positive property — is then one being per point, and the argument
produces each of them.

**Three, and this is where the corpus has a theorem rather than an
example.** `formal/cubical/Saptabhangi.agda` proves `दुर्नयः`: any
two-valued verdict `f : सप्तभङ्गी → द्विपद` identifies two distinct members
of {asti, nāsti, avaktavya} — three seeds into two values, by pigeonhole.
**Ax1 is exactly a two-valued verdict.** And `machinery/orderings_cubic.py`
exhibits a field with three of them: K = ℚ[x]/(x³ − 4x − 1), disc 229,
prime hence not a square, hence Gal = S₃ and Aut(K/ℚ) = 1, and 229 > 0 so
K is totally real with r₁ = 3; ⟨1, −α⟩ is definite at two orderings and
indefinite at the third. So over a structure with three positivities,
Gödel's first axiom **provably confuses two of them**, and both halves of
that sentence are checked — one in a kernel, one in exact Sturm arithmetic
over ℚ.

## Why the confusion is invisible from inside

`POSITIVITY_HAS_A_PLACE` §10: if K/ℚ is Galois, Gal acts transitively on
the real embeddings, so all r₁ orderings are conjugate and every
Gal-invariant object has the same verdict at each. That is `INDEX_LAW.md`
Theorem E — a group acting transitively on the target of an equivariant map
forces all fibres to the same size — applied to objects indexed by
orderings. For ℚ(√2) the two cones are exchanged by √2 ↦ −√2, the mixed
classes came out at exactly 495 and 495, and **no formula in the field's own
language distinguishes them**. An inhabitant cannot tell which positivity
they are in, the argument runs identically in each, and the beings it
produces are conjugate and distinct.

The asymmetric case is the one that shows the fork is real: a conjugate pair
can only split 1+1, so the disc-229 field's **2+1 partition is itself the
certificate** that no automorphism relates its three orderings. There the
charts differ non-symmetrically and the difference is nameable.

## The modal reading, and it is the same defect

Benzmüller and Woltzenlogel Paleo (2013) formalised the argument in
Isabelle/HOL and the prover returned **modal collapse**: Gödel's axioms
entail □φ ↔ φ. Read through `formal/cubical/NaturalMachine/
QuotientFiberLaw.agda` — an observation class sees exactly a quotient, never
the fibre, and no post-processing of the quotient manufactures it — modal
collapse is what a unique-positivity assumption does to the modal fibre: it
flattens it, because the verdict was already assumed to be the object.
Positivity-as-a-place and modal-collapse-as-a-theorem are one finding in two
formalisms, found independently, thirty years apart.

## What the tradition already had

The move Ax1 makes has a name older than the argument. A naya is true at its
standpoint; a naya that asserts itself **by denying the other nayas** is a
*durnaya*. "Exactly one of P(φ) and P(¬φ)" is that denial written as an
axiom, and syādvāda's seven positions exist precisely because the two-valued
verdict on a property is the thing that collapses — with *avaktavya*, the
fourth, being what a boolean cannot hold at all.

The inferential arguments for Īśvara were systematised in Udayana's
*Nyāyakusumāñjali* (c. 984), and the Jaina and Mīmāṃsaka replies target the
**vyāpti** — the universality of the concomitance — which is the same joint
the count above turns on. That exchange is roughly seven centuries before
Leibniz's version and a millennium before Gödel's.

## Rigor boundary

- **Kernel-checked**: `Saptabhangi.दुर्नयः` (`--cubical --safe`) — any
  two-valued verdict identifies two of the three seeds.
- **Exact symbolic**: `machinery/orderings.py` (ℤ[√2] signs by
  sign(a+b√2) = sgn(a)·sgn(a²−2b²) on mixed signs, no floats);
  `machinery/orderings_cubic.py` (Sturm sequences over ℚ, every sign an
  integer comparison). Both are certificates, not measurements.
- **Classical, cited**: Artin–Schreier 1927; Sylvester's law of inertia;
  Hasse–Minkowski; Theorem E (`INDEX_LAW.md`).
- **Cited, not reproved here**: Gödel's axioms in Scott's version; the modal
  collapse (Benzmüller and Woltzenlogel Paleo, 2013, Isabelle/HOL).
- **This note's own step**: that Ax1 + Ax2 make P the same kind of object as
  a point of Sper, and that `दुर्नयः` therefore applies to Ax1 at r₁ = 3.
  The two structures are matched on their defining conditions — totality on
  a complementary pair, closure under the operation — and **no map between
  the property algebra and the field is exhibited**. Two structures agreeing
  on their axioms is not a morphism. Building one is the śeṣa.
- **Not claimed**: that the argument is refuted. What is shown is that its
  first axiom names a chart, that the number of available charts is a
  computable invariant, and that at three the axiom cannot keep them apart.
  Gödel did not publish the manuscript and its own marginalia worry at what
  "positive" means; the worry and this note are about the same joint.
