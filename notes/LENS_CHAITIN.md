# The incompleteness lens: an audited finite endpoint obstruction

Chaitin's theorem concerns what a sound effectively axiomatized theory can
certify about Kolmogorov complexity.  The Selberg-pair argument below is not
an instance of that theorem.  It is a finite two-model semantic obstruction
that suggests a useful analogy.

~~For the parity barrier, without qualification, the information ceiling is
exactly zero and the arithmetic case is cleaner than Chaitin's.~~  The exact
replacement is scoped: after declaring a state class, an axiom map, and two
states in one axiom fiber, any conclusion valid on that whole fiber is bounded
by the worse of those two states.  R0007 preserves the original hash-bound
claim for provenance; R0012 is the corrected non-load-bearing successor.

## 1. The two finite endpoint systems

Fix $X\geq2$, put $\Omega_X=\{1,\ldots,X\}$, and let $\lambda$ be the
Liouville function.  Define nonnegative finite measures

$$
 \nu_\pm(f)=\sum_{n\leq X}(1\pm\lambda(n))f(n).
$$

Writing $L(X)=\sum_{n\leq X}\lambda(n)$ gives the exact identities

$$
 \nu_\pm(1)=X\pm L(X),\qquad
 \nu_+(f)-\nu_-(f)=2\sum_{n\leq X}\lambda(n)f(n).                 \tag{1.1}
$$

These are unnormalized integrals.  If $E_\nu$ denotes expectation under the
normalized probability measure $\nu/\nu(1)$, then (1.1) is not an identity
for $E_{\nu_+}f-E_{\nu_-}f$ because the two masses generally differ.

~~Both masses are $X+O(\sqrt X e^{c\sqrt{\log X}})$.~~  No such unconditional
bound is used or asserted.  The exact formula $X\pm L(X)$ is sufficient.

Since $\lambda(p)=-1$ for every prime,

$$
 \nu_+(\mathsf{Prime})=0,
 \qquad \nu_-(\mathsf{Prime})=2\pi(X).                           \tag{1.2}
$$

The twin construction uses a different state space and action.  For $X\geq5$
let

$$
 \Omega_X^{(2)}=\{1,\ldots,X-2\},\qquad
 c_2(n)=\lambda(n)\lambda(n+2),\qquad
 \eta_\pm=(1\pm c_2(n))\,dn.
$$

If $\pi_2(X)=\#\{n\leq X-2:n,n+2\text{ are prime}\}$, then $c_2(n)=1$ on
that target and hence

$$
 \eta_+(\mathsf{Twin})=2\pi_2(X),
 \qquad \eta_-(\mathsf{Twin})=0.                                \tag{1.3}
$$

Let $\sigma_2$ exchange $\eta_+$ and $\eta_-$.  This formal pair-charge
involution is not induced by the global replacement $\lambda\mapsto-\lambda$:
that replacement fixes $c_2$.

The Selberg pair and its use in explaining sieve parity are classical.  The
identities (1.1)--(1.3) are direct finite sums.

## 2. The exact one-bit statement

Let $S_\lambda=\{\nu_+,\nu_-\}$ and define $\sigma$ on this two-element set by
exchanging its endpoints.  A state observable $F:S_\lambda\to Z$ is
$\sigma$-invariant when $F\circ\sigma=F$; it then takes equal values on the
two endpoints by definition.  Equivalently, take the constant deterministic
channel

$$
 q:S_\lambda\longrightarrow\{*\}.
$$

Its image has cardinality one, so its deterministic Shannon capacity and
zero-error capacity are both zero bits per use.  Its unique state fiber has
cardinality two.  Therefore exact endpoint reconstruction needs and admits a
side alphabet of size two, or one fixed-length bit.  The prime-total target
also takes two distinct values by (1.2), so its minimum side alphabet is two.
The same statements hold for $S_2=\{\eta_+,\eta_-\}$ and the twin target.

These are different quantities:

$$
 \underbrace{\log_2|\operatorname{im}q|}_{0\text{ observer bits/use}}
 \neq
 \underbrace{\left\lceil\log_2\max_y|q^{-1}(y)|\right\rceil}_{1\text{ side bit}}.
$$

~~The state class is the whole pointwise cube $|w-1|\leq1$, whose common
shadow has exactly one missing bit.~~  The one-bit theorem is only about the
literal endpoint set.  Even the affine segment
$\{(1+t\lambda)dn:-1\leq t\leq1\}$ has continuum full-state ambiguity under
linear tests annihilating $\lambda$; the pointwise cube is larger.

~~All $n$-functionals, including AP counts and smooth sums, are sufficient
statistics shared exactly by the endpoints.~~  A linear test $A_f(\nu)=\nu(f)$
has equal endpoint values if and only if
$\sum_{n\leq X}\lambda(n)f(n)=0$.  Ordinary AP indicators generally have a
nonzero discrepancy.  `exp41_selberg_swap.py` reports those discrepancies as
falsifiers of exact equality.

The corrected information audit is:

```text
STATE CLASS:          exactly {nu_+,nu_-}; separately {eta_+,eta_-}
CHANNEL:              constant/common endpoint shadow on the stated pair
FIBER:                one two-point fiber, because the domain has two points
TARGET:               endpoint identity or the prime/twin total
SIDE INFORMATION:     minimum alphabet 2; one fixed-length bit
CHANNEL CAPACITY:     deterministic Shannon/zero-error capacity 0 bits/use
AP DATA:              not in the exact shadow unless its correlation vanishes
STABILITY:            no claim; requires a separately quantified noisy model
QUANTUM UPGRADE:      not applicable; this is a classical finite channel
```

## 3. Scoped conservation lemma C1

**Lemma C1 (finite two-model semantics).**  Let $K$ be a declared class of
nonnegative finite measures containing $\nu_+$ and $\nu_-$.  Let
$\mathcal A$ be any family of affine axiom functionals such that the exact
equalities

$$
 A(\nu_+)=A(\nu_-)\qquad(A\in\mathcal A)                         \tag{3.1}
$$

have been proved.  Suppose a conclusion $T(\nu)\geq\beta$ is valid for every
$\nu\in K$ having those axiom values.  Then

$$
 \beta\leq\min(T(\nu_+),T(\nu_-))
 =\frac{T(\nu_+)+T(\nu_-)}2
  -\left|\frac{T(\nu_+)-T(\nu_-)}2\right|.                       \tag{3.2}
$$

**Proof.**  Both endpoints lie in the declared feasible class by (3.1), so
the universal conclusion applies to each.  Take the smaller value. $\square$

For the prime target, (1.2) makes the right side zero.  For twins, apply the
same lemma separately to $S_2$, $\sigma_2$, and (1.3).  This proves no
positive lower bound only for a semantic derivation whose hypotheses are
exactly the declared axiom values over the declared state class.  It does not
say that an unspecified formal theory cannot prove that primes or twins exist.

~~AP counts, sieve-dimension data, and smooth sums are charge-even axioms by
name.~~  Each proposed axiom must satisfy (3.1) explicitly.  Approximate
agreement is not equality.

## 4. Noisy axioms are a separate theorem

Suppose instead that an axiom is an interval
$|A(\nu)-b_A|\leq R_A$.  C1 applies whenever both endpoints satisfy every
interval.  For linear $A$ write

$$
 A(\nu_\pm)=A(\nu_0)\pm\delta_A.
$$

The explicit sufficient condition

$$
 |A(\nu_0)-b_A|+|\delta_A|\leq R_A                               \tag{4.1}
$$

keeps both endpoints feasible.  Beyond (4.1), aggregation norms, dual
coefficients, asymptotic error budgets, and proof-mass lower bounds require
their own definitions and proofs.

~~LENS_CIRCUIT proves every standard AP/lcm-bounded family lies strictly below
the threshold, while Type II sums are precisely axioms proved to exceed their
own error budgets.~~  That statement was not established by C1 or exp41 and is
withdrawn here.  The Type II/reflection row is an analogy.  R0008 is the
current formalizing, non-load-bearing packet for a noisy dual-mass theorem and
must be audited against the corrected endpoint and interval scopes.

Likewise, ~~sieve proofs of twins must be polynomially heavy~~ is not a theorem
of this note.  Any such result is relative to a formalized derivation system,
its axiom normalization, and proved charge/error estimates.

## 5. What remains of the Chaitin lens

The exact theorem here is model indistinguishability, not algorithmic
incompleteness.  The following is a research dictionary, with no claim that
the columns are equivalent:

| Chaitin / proof search | scoped endpoint model |
|---|---|
| theory and axioms | declared $K$ and axiom map $A$ |
| indistinguishable models | two endpoints in one exact axiom fiber |
| stronger theory | an added observable that separates those endpoints |
| proof compression | a representation that shortens a kernel-checked proof |
| incompleteness ceiling | analogy only; C1's zero is target- and fiber-relative |

This lens is still useful: every claimed obstruction should name the state
class, observer, target, fiber, and proof semantics.  It is not a license to
infer independence, Kolmogorov complexity, or proof-time lower bounds from a
parity label.

## 6. Status, novelty, and prior art

- Classical: the Selberg pair and the parity phenomenon (Selberg; Bombieri;
  Friedlander--Iwaniec, *Opera de Cribro*, Chapter 16).
- Elementary/known: the finite constant-channel calculation and C1's
  unfavorable-model evaluation.
- Analogy only: Chaitin, reflection axioms, and the four-theater synthesis.
- Withdrawn from this note: the whole-cube one-bit claim, exact AP equality,
  the square-root mass bound, unconditional C2 instances, and polynomial
  proof-mass conclusions.
- Registry: R0007 retains its original exact-statement hash but is explicitly
  non-authoritative; R0012 is the corrected formalizing successor.  Neither is
  load-bearing.

No novelty is claimed for the corrected theorem.  A Lean formalization may be
useful as a reusable kernel, but formalization would not make the result new.

## References

- G. Chaitin, *Information-theoretic limitations of formal systems*, JACM 21
  (1974), for the analogy only.
- A. Selberg, *On elementary methods in prime number theory* (1949).
- J. Friedlander and H. Iwaniec, *Opera de Cribro*, Chapter 16.
- In-corpus: `INFORMATION_LENS.md`, `FiniteInformation.lean`, R0007, R0008,
  R0012, and `exp41_selberg_swap.py`.
