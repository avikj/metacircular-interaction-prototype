# Defect calculus: an exact arithmetic nucleus

**Status.** Exact elementary/standard algebra assembled as a proposed machine
language.  The theorems below are proved.  The claim that this language extends
to a useful global arithmetic intersection theory is open and non-load-bearing.

## 1. Primitive datum

The primitive datum is a typed map together with observations of its failure
to be invertible at several depths.  For a map `f:A->B`, its defect profile may
contain

\[
 (\ker f,\operatorname{coker}f),\qquad
 L_{B/A},\qquad
 \operatorname{Tor}^A_*(B,-),\qquad
 \det(f),\qquad
 \text{local lengths},\qquad
 \text{metric or signature data}.                 \tag{1.1}
\]

These entries are not interchangeable.  The point of the profile is to retain
the lowest layer at which a proposed equivalence loses information.

## 2. Determinant defect and composition

Let `f:M->M` be an injective endomorphism of a free abelian group of finite
rank with nonzero determinant.  Then

\[
 \boxed{|\operatorname{coker}f|=|\det f|.}          \tag{2.1}
\]

If `g:M->M` is another such endomorphism, then

\[
 \boxed{\log|\operatorname{coker}(g f)|
 =\log|\operatorname{coker}f|+\log|\operatorname{coker}g|.} \tag{2.2}
\]

**Proof.** Smith normal form proves (2.1).  Equation (2.2) follows from
`det(gf)=det(g)det(f)`.  Equivalently, the snake lemma gives the exact sequence

\[
 0\to\operatorname{coker}f\longrightarrow
 \operatorname{coker}(gf)\longrightarrow
 \operatorname{coker}g\to0,                         \tag{2.3}
\]

where the first map sends `[x]` to `[g x]` and the second sends `[y]` modulo
`gf(M)` to `[y]` modulo `g(M)`. \(\square\)

Thus logarithmic defect length is additive under composition.  This is the
finite algebraic ancestor of an additive height; it is not yet an
archimedean height or an intersection pairing.

Localizing (2.1) gives

\[
 \log|\operatorname{coker}f|
 =\sum_p \operatorname{length}_{\mathbb Z_p}
   (\operatorname{coker}f\otimes\mathbb Z_p)\log p. \tag{2.4}
\]

The support and local lengths are therefore a strictly finer observation than
the single determinant magnitude.

## 3. Cyclotomic identity defects

For `n>1`, put

\[
 \mathcal D_n=\mathbb Z[x]/(\Phi_n(x),x-1).
\]

The canonical calculation from `CYCLOTOMIC_INTERSECTION_MANGOLDT.md` is

\[
 \mathcal D_n\cong
 \begin{cases}
 \mathbb F_p,&n=p^a,\\
 0,&n\text{ is not a prime power},
 \end{cases}
 \qquad
 \log|\mathcal D_n|=\Lambda(n).                     \tag{3.1}
\]

The modules, rather than their cardinalities, admit a new exact binary
operation.

## 4. Derived prime-incidence theorem

Define the derived incidence object

\[
 \mathcal I(m,n):=
 \mathcal D_m\otimes_{\mathbb Z}^{\mathbf L}\mathcal D_n
 \in D^b(\mathbb Z).                                \tag{4.1}
\]

### Theorem 4.1

For `m,n>1`:

1. if either index is not a prime power, then `I(m,n)=0`;
2. if `m=p^a` and `n=q^b` with `p!=q`, then `I(m,n)=0`;
3. if `m=p^a` and `n=p^b`, then

\[
 H_0\mathcal I(m,n)\cong\mathbb F_p,
 \qquad
 H_1\mathcal I(m,n)\cong\mathbb F_p,               \tag{4.2}
\]

and all other homology groups vanish.

**Proof.** Only the prime-power case survives (3.1).  Resolve
`F_p=Z/pZ` by

\[
 0\longrightarrow\mathbb Z\xrightarrow{p}\mathbb Z
 \longrightarrow\mathbb F_p\longrightarrow0.       \tag{4.3}
\]

After tensoring with `F_q`, the two-term complex has differential
multiplication by `p`.  It is invertible on `F_q` when `p!=q`, giving zero
homology.  When `p=q`, the differential is zero and both displayed terms are
`F_p`, giving (4.2). \(\square\)

Hence the derived intersection detects equality of the rational prime below
two cyclotomic identity collisions without being handed a factorization label
afterward.

### Corollary 4.2: scalar cancellation obstruction

For `m=p^a,n=p^b`, the alternating logarithmic size is

\[
 \sum_i(-1)^i\log|H_i\mathcal I(m,n)|
 =\log p-\log p=0.                                  \tag{4.4}
\]

Therefore ordinary Euler-characteristic decategorification erases every
nonzero derived prime incidence.  Any proposed scalar pairing extracted from
`I(m,n)` must justify a polarization, truncation, metric determinant, or other
degree-sensitive realization independently.  Selecting `H_0` merely because
it gives the desired positive weight is definition by fiat.

This is an exact no-go for the most naive derived-intersection pairing.

## 5. Ramified tangent defect

Fix a prime `p` and set

\[
 \mathcal O_k=\mathbb Z[\zeta_{p^k}],\qquad
 \pi_k=1-\zeta_{p^k},\qquad I_k=(\pi_k).
\]

Under `O_k -> O_(k+1)`, total cyclotomic ramification gives

\[
 \pi_k=u_k\pi_{k+1}^{p}                              \tag{5.1}
\]

for a unit `u_k`.  Norm in the reverse direction gives

\[
 N_{k+1/k}(\pi_{k+1})=\pi_k                         \tag{5.2}
\]

up to the equivalent unit convention for the chosen uniformizer.

### Theorem 5.1

The induced residue map is the identity isomorphism

\[
 \mathcal O_k/I_k\cong\mathbb F_p
 \xrightarrow{\sim}
 \mathcal O_{k+1}/I_{k+1}\cong\mathbb F_p,          \tag{5.3}
\]

whereas the induced conormal map after reduction is zero.  More precisely,
write the common residue field as `k=F_p`, regarded as an `O_k`-module via
`O_k -> O_k/I_k`.  The map of closed points induced by
`O_k -> O_(k+1)` gives the conormal map

\[
 (I_k/I_k^2)\otimes_{\mathcal O_k/I_k}k
 \longrightarrow I_{k+1}/I_{k+1}^2,
 \qquad [\pi_k]\longmapsto0.                        \tag{5.4}
\]

**Proof.** Both residue maps send the relevant root of unity to one and reduce
integers modulo `p`, proving (5.3).  Equation (5.1) sends `[pi_k]` to
`[u_k pi_(k+1)^p]`, which belongs to `I_(k+1)^2` because `p>=2`; hence (5.4).
\(\square\)

The order-zero point persists while its first-order tangent is annihilated.
The lost order is retained by ramification multiplicity, norm, and logarithmic
scale.  This is a genuine cross-layer distinction, unlike two coefficientwise
linear projectors on a fixed finite fiber.

## 6. Reconstruction ledger

For a prime-power tower event, retain the typed quadruple

\[
 \boxed{(\mathbb F_p,\ d=0,\ e=p,\ \Delta h=\log p)}. \tag{6.1}
\]

Here `d=0` denotes the zero conormal differential, `e` the ramification index,
and `Delta h` the logarithmic displacement.  No theorem here says that an
arbitrary three entries reconstruct the fourth.  The quadruple is a loss
ledger: residue-only forgets the level; tangent-only forgets the weight;
discriminant-only produces the wrong growing exponents; height-only forgets
the finite place.

## 7. Proposed machine laws

The exact nucleus supports four operations:

1. **Defect:** attach kernel/cokernel and derived fibers to a typed map.
2. **Compose:** use exact sequences and determinant lines to add defect length.
3. **Localize:** resolve a global finite defect into prime-supported lengths.
4. **Lift minimally:** retain the least infinitesimal/derived layer at which
   the generating maps stop being invertible or cease to agree.

A fifth operation, **polarize**, is deliberately absent.  It would turn a
graded defect into a scalar bilinear form or signature.  Corollary 4.2 proves
that the naive alternating realization is zero on same-prime incidence.  A
non-arbitrary polarization is the first open construction problem.

## 8. Hard boundaries and next test

All algebra above is standard or immediate from standard cyclotomic
ramification and homological algebra.  The possibly useful contribution is the
typed assembly and the cancellation obstruction, not a novelty claim for any
ingredient.

Advance only if a candidate polarization:

- is functorial under exact sequences and cyclotomic norm maps;
- distinguishes the two homological degrees without selecting the desired
  sign by decree;
- produces `log p` rather than the growing cyclotomic discriminant exponent;
- admits an archimedean metric from the same construction;
- yields a nontrivial pairing before the explicit formula is invoked.

~~The cheapest next test is determinant-of-cohomology with its natural finite
torsion norm.~~  This test is now closed negatively by
`DEFECT_CALCULUS_NUCLEUS_AUDIT.md`.  For the perfect torsion complex
`I(p^a,p^b)`, rational acyclicity canonically trivializes its determinant line,
and the integral covolume is the alternating product of homology orders,
which is one.  The cyclotomic norm maps preserve the residue prime and
ramification multiplicity but do not canonically orient homological degree
inside this derived tensor product.  Producing `log p` therefore requires
extra degree-sensitive structure and an explicit account of which determinant
functoriality or self-duality it abandons.
