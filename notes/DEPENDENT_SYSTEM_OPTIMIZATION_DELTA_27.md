# Dependent System Optimization — Delta 27

**Bellman representation, semantic dependency rank, and the Isbell
optimization nucleus**

Date: 2026-08-14  
Status: exact finite/quantale theorems, mature-theory inheritance, and a new
synthesis/program  
Depends on: `notes/DEPENDENT_SYSTEM_OPTIMIZATION.md` (Delta 26)  
Novelty: no novelty claim for inherited semiring, quantale, Isbell, tropical
rank, formal-concept, communication-complexity, or automata results.

The 2026 trellis calibration in §34 is user-supplied ancestry. It remains an
un-pinned prior-art claim until the exact paper and theorem are attached and
read. That provenance boundary does not affect the finite theorems below.

## 0. Executive leap

Delta 26 identified an open costed subsystem with its continuation action

\[
K:A\times B\to\overline{\mathbb R},\qquad
\mathcal B_K(V)(a)=\inf_b\bigl(K(a,b)+V(b)\bigr).
\]

Delta 27 separates two new questions:

\[
\boxed{\text{What is the smallest exact intermediate dependency object
through which }K\text{ factors?}}
\]

\[
\boxed{\text{What canonical complete semantic dependency object does }K
\text{ generate?}}
\]

For finite scalar-cost matrices, the first answer is min-plus factor rank. For
a quantale-valued profunctor, the second is its Isbell hull/nucleus:

\[
\boxed{\begin{aligned}
\operatorname{rank}_{\min+}(K)
  &=\text{smallest number of exact latent dependency modes},\\
\operatorname{Isb}(K)
  &=\text{complete space of saturated dependency modes}.
\end{aligned}}
\]

The architecture compiler must find a smallest or best finite generating
family *inside* the optimization nucleus. Canonical completion and minimal
implementation are different objects.

## 1. Tropical cost semiring

Let

\[
\mathbb T=(\overline{\mathbb R},\min,+,+\infty,0).
\]

Tropical addition chooses the cheaper alternative; tropical multiplication
composes costs; infinity means infeasible. A finite subsystem is a matrix
\(K\in\mathbb T^{A\times B}\), with

\[
(L\star K)(a,c)=\min_b\bigl(K(a,b)+L(b,c)\bigr).
\]

This is shortest-path/dynamic-programming composition. Extended-value
subtraction is not used without a separate convention; §§20–24 restrict the
explicit conjugacy formulas to finite real-valued matrices.

## 2. Free complete min-plus semimodules

The value space \(\mathbb T^B\) has pointwise minimum and scalar translation.
For

\[
\delta_b(b')=\begin{cases}0&b'=b,\\+\infty&b'\ne b,
\end{cases}
\]

every value decomposes as

\[
\boxed{V=\bigoplus_{b:B}V(b)\odot\delta_b.}
\]

## 3. Bellman representation theorem

A map \(F:\mathbb T^B\to\mathbb T^A\) is **complete min-plus linear** when it
preserves arbitrary pointwise infima and scalar translations:

\[
F\left(\bigoplus_iV_i\right)=\bigoplus_iF(V_i),\qquad
F(\lambda\odot V)=\lambda\odot F(V).
\]

**Theorem 27.2 — Bellman representation.** Every such map has a unique matrix
\(K_F:A\times B\to\overline{\mathbb R}\) with

\[
F=\mathcal B_{K_F},\qquad
\boxed{K_F(a,b)=F(\delta_b)(a).}
\]

Indeed,

\[
F(V)(a)=\min_b\bigl(V(b)+F(\delta_b)(a)\bigr).
\]

Evaluation on all Dirac values proves uniqueness.

## 4. Full abstraction of continuation semantics

\[
\boxed{
\mathbb T^{A\times B}\cong
\operatorname{Hom}_{\mathbb T\text{-Sup}}(\mathbb T^B,\mathbb T^A).
}
\]

The assignment reverses boundary direction and respects composition:

\[
\mathcal B_{L\star K}=\mathcal B_K\circ\mathcal B_L.
\]

All scalar boundary-cost information is retained by the action on *every*
future value. This is the exact semantic category for initial scalar DSO.

## 5. Exact architecture factorization

An interface \(B\) for \(K:A\rightsquigarrow C\) is a pair

\[
M:A\rightsquigarrow B,\qquad L:B\rightsquigarrow C
\]

with

\[
\boxed{K=L\star M},\qquad
K(a,c)=\min_b\bigl(M(a,b)+L(b,c)\bigr).
\]

Equivalently,

\[
\mathcal B_K=\mathcal B_M\circ\mathcal B_L.
\]

Each \(b\) is a latent dependency mode, not merely an embedding coordinate.

## 6. Semantic dependency rank

For finite \(A,C\), define

\[
\boxed{
\operatorname{rank}_{\min+}(K)=
\min\{|B|:K=L\star M\}.
}
\]

Equivalently it is the least \(r\) such that

\[
\boxed{K(a,c)=\min_{1\le i\le r}\bigl(x_i(a)+y_i(c)\bigr).}
\]

This is exactly the minimum cardinality of an exact latent interface and hence
a semantics-level lower bound on architecture width.

## 7. Rank is not runtime complexity

Large factor rank says that no small exact separable interface exists. It does
not rule out a specialized polynomial-time evaluator exploiting some other
structure. Semantic rank measures dependency/representation
incompressibility, not generic computational complexity.

## 8. Gauge invariance

For finite boundary potentials \(\alpha:A\to\mathbb R\) and
\(\beta:C\to\mathbb R\), let

\[
K'(a,c)=\alpha(a)+K(a,c)+\beta(c).
\]

Then

\[
\boxed{\operatorname{rank}_{\min+}(K')=
\operatorname{rank}_{\min+}(K).}
\]

Shift every upstream/downstream factor and apply inverse shifts for the two
inequalities. Rank is likewise invariant under row/column relabeling and exact
boundary bijections.

## 9. Rank-one criterion

Rank one means \(K(a,c)=x(a)+y(c)\). Therefore every additive \(2\times2\)
minor satisfies

\[
\boxed{K(a,c)+K(a',c')=K(a,c')+K(a',c).}
\]

One violation proves factor rank at least two. Higher lower bounds may use
tropically nonsingular minors, subject to the standard inequality

\[
\operatorname{tropicalRank}(K)\le
\operatorname{factorRank}_{\min+}(K).
\]

The inequivalent notions called “tropical rank” must not be conflated.

## 10. Boolean specialization

Embed a relation \(R\subseteq A\times C\) by

\[
K_R(a,c)=\begin{cases}0&R(a,c),\\+\infty&\neg R(a,c).
\end{cases}
\]

Then

\[
\boxed{\operatorname{rank}_{\min+}(K_R)=
\text{minimum number of all-true rectangles covering }R.}
\]

This is Boolean factor rank. A latent mode is a certificate consisting of an
upstream membership test and downstream membership test.

## 11. Communication lower bound

Under the standard nondeterministic Boolean communication convention, an
interface with \(r\) certificate classes costs \(\lceil\log_2r\rceil\) bits
to name, and each certificate class is a true rectangle. Hence

\[
\boxed{N^1(R)=\left\lceil
\log_2\operatorname{rank}_{\mathbb B}(R)\right\rceil}
\]

with local verification cost excluded by that convention.

## 12. Fooling-set lower bound

A Boolean fooling set is a family \((a_i,c_i)\in R\) such that no all-true
rectangle contains two chosen pairs. A fooling set of size \(m\) forces every
rectangle cover, hence every exact latent interface, to have size at least
\(m\).

## 13. Context-restricted semantic rank

For \(\mathcal V\subseteq\mathbb T^C\), let

\[
\operatorname{rank}_{\mathcal V}(K)
\]

be the least \(|B|\) for which

\[
\mathcal B_M\mathcal B_L(V)=\mathcal B_K(V)
\quad\forall V\in\mathcal V.
\]

If every Dirac continuation belongs to \(\mathcal V\), Dirac reconstruction
gives

\[
\boxed{\operatorname{rank}_{\mathcal V}(K)=
\operatorname{rank}_{\min+}(K).}
\]

A smaller context family may legitimately admit a smaller interface only when
the excluded futures are truly out of scope.

## 14. Context growth and option value

If \(\mathcal V_1\subseteq\mathcal V_2\), then

\[
\boxed{\operatorname{rank}_{\mathcal V_1}(K)\le
\operatorname{rank}_{\mathcal V_2}(K).}
\]

More possible futures cannot decrease the minimum exact dependency width.
This is option monotonicity at rank level.

## 15. Safe approximate dependency rank

A factorized approximation \(\widehat K=L\star M\) is safely
\(\varepsilon\)-accurate when

\[
\boxed{K(a,c)\le\widehat K(a,c)\le K(a,c)+\varepsilon.}
\]

Its least interface width is
\(\operatorname{rank}^{\mathrm{safe}}_\varepsilon(K)\). For every continuation,

\[
\boxed{\mathcal B_K(V)\le\mathcal B_{\widehat K}(V)
\le\mathcal B_K(V)+\varepsilon.}
\]

The first inequality is monotonicity; the second follows by evaluating an
arbitrarily near-optimal endpoint for \(K\). The one-sided condition forbids an
approximation from inventing infeasible or unrealistically cheap paths.

## 16. Proof-relevant implementation rank

Let \(\mathbf K:A\times C\to\mathcal U\) be an implementation-valued relation
with witness costs. Its scalar decategorification is

\[
K(a,c)=\inf_{w:\mathbf K(a,c)}\operatorname{cost}(w).
\]

A witness-preserving factorization through \(B\) is an equivalence

\[
\boxed{
\mathbf K(a,c)\simeq
\sum_{b:B}\mathbf M(a,b)\times\mathbf L(b,c),
}
\]

or the appropriate proof-relevant coend when symmetries are present, with
additive costs. Let \(\operatorname{wrank}(\mathbf K)\) be its least width.
Decategorification gives

\[
\boxed{\operatorname{rank}_{\min+}(K)\le
\operatorname{wrank}(\mathbf K).}
\]

## 17. Strict loss under decategorification

For \(A=C=\{0,1\}\), take finite CW witness types

\[
\mathbf K(0,0)=\mathbf K(1,1)=S^1,
\qquad
\mathbf K(0,1)=\mathbf K(1,0)=\mathbf 1,
\]

all at cost zero. The scalar matrix is constantly zero and has min-plus rank
one. A rank-one witness factorization would make the Euler-characteristic
matrix an outer product, but

\[
\begin{bmatrix}0&1\\1&0\end{bmatrix}
\]

has determinant \(-1\). Hence witness rank is strictly larger than scalar
rank. Equal optimal values need not preserve proof identity, provenance,
topology, alternatives, or future composability.

## 18. Quantale generalization

For a commutative quantale \(Q\), a \(Q\)-matrix
\(K:A\nrightarrow C\) is a quantale-valued profunctor with composition

\[
(L\circ M)(a,c)=\bigvee_bM(a,b)\otimes L(b,c).
\]

These matrices form a quantaloid: homs are complete lattices, composition
preserves arbitrary joins, and right extensions/liftings exist. Boolean
relations, min/max-plus quantities, fuzzy relations, Lawvere metrics, and
suitably defined Pareto resource semantics are specializations.

## 19. Residuation synthesizes the missing side

Given \(X:A\nrightarrow B\) and \(K:A\nrightarrow C\), the right extension
\(K\swarrow X:B\nrightarrow C\) is the greatest \(Y\) with
\(Y\circ X\le_QK\). Dually, \(Y\searrow K\) is the greatest compatible
upstream factor. Thus

\[
Y\le K\swarrow X
\iff Y\circ X\le K
\iff X\le Y\searrow K.
\]

Architecture repair therefore has exact adjoint synthesis operators; it is
not necessarily blind search.

## 20. Explicit min-plus conjugacy

For finite real-valued \(K\), a sound rank-one majorant satisfies
\(K(a,c)\le x(a)+y(c)\). Define

\[
\boxed{K^\uparrow x(c)=\sup_a\bigl(K(a,c)-x(a)\bigr)},
\]

\[
\boxed{K^\downarrow y(a)=\sup_c\bigl(K(a,c)-y(c)\bigr)}.
\]

These are the least compatible downstream/upstream potentials and form an
antitone Galois correspondence. The finite-real hypothesis avoids undefined
extended-real subtraction.

## 21. Optimization nucleus

Define

\[
\boxed{
\operatorname{Nuc}(K)=
\{(x,y):y=K^\uparrow x,\ x=K^\downarrow y\}.
}
\]

Abstractly,

\[
\operatorname{Isb}(K)=
\{(X,Y):Y=K\swarrow X,\ X=Y\searrow K\}.
\]

This is the Isbell hull/nucleus of the profunctor.

## 22. Nucleus modes are tight majorants

Every nucleus pair obeys \(K(a,c)\le x(a)+y(c)\), and neither profile can be
reduced independently while remaining sound against the other. The two
profiles are the upstream burden of entering a latent mode and the downstream
burden of completing from it; mutual conjugacy makes both saturated.

## 23. Saturation theorem

Suppose \(K\le x+y\), and set

\[
\bar y=K^\uparrow x,
\qquad
\bar x=K^\downarrow\bar y.
\]

Then

1. \((\bar x,\bar y)\in\operatorname{Nuc}(K)\);
2. \(K\le\bar x+\bar y\);
3. \(\bar x+\bar y\le x+y\).

Minimality gives \(\bar y\le y\); soundness of \(x+\bar y\) gives
\(\bar x\le x\); the Galois closure identities give the remaining fixed-point
equation.

## 24. Nucleus cover theorem

For finite real-valued \(K\),

\[
\boxed{
\operatorname{rank}_{\min+}(K)=
\min\left\{r:
K=\min_{1\le i\le r}(x_i+y_i),\ (x_i,y_i)\in\operatorname{Nuc}(K)
\right\}.
}
\]

Every nucleus cover is a factorization. Conversely, saturate every term of an
optimal factorization. Each new term stays above \(K\) and below the old term,
so their lower envelope remains exactly \(K\) without increasing the number
of modes.

## 25. The central duality

\[
\boxed{\begin{aligned}
\operatorname{Nuc}(K)
  &=\text{all saturated exact dependency concepts},\\
\operatorname{rank}_{\min+}(K)
  &=\text{smallest number whose lower envelope is }K.
\end{aligned}}
\]

Architecture synthesis therefore splits into semantic completion of the
nucleus and finite generation/cover inside it. This is the **nucleus
compiler**.

## 26. Mature specializations

- For a Boolean relation, the nucleus is the formal concept lattice.
- For a poset order, it is the Dedekind–MacNeille completion.
- For a Lawvere metric, Isbell completion gives the directed tight span or
  generalized injective hull.
- For vector/dual pairing, it recovers lower-semicontinuous convex functions
  and Legendre–Fenchel conjugacy.
- For tropical matrices, it is a complete semi-tropical semimodule generated
  by row/column data.

The common operation is completing a relation into the stable dual concepts it
already implies.

## 27. Boolean concepts

For \(R\subseteq A\times C\), a formal concept is a pair \((X,Y)\) satisfying

\[
Y=\{c:\forall a\in X,\ R(a,c)\},
\qquad
X=\{a:\forall c\in Y,\ R(a,c)\}.
\]

Then \(X\times Y\subseteq R\) is a maximal true rectangle. Every Boolean
rectangle can be saturated to a concept rectangle without increasing cover
size. Hence Boolean rank is the minimum number of formal concepts covering the
relation. The lattice is the complete interface; a minimum concept cover is a
smallest exact finite interface.

## 28. Canonical versus minimal

The nucleus is canonical but may be large or infinite. A minimum-rank
factorization is small but can be nonunique, hard to compute, unstable,
context-dependent, or destructive of witness structure. The compiler must
preserve both the nucleus as semantic reference and selected finite generators
as executable architectures.

## 29. Architecture synthesis by conjugate closure

A finite search loop may:

1. propose upstream potentials \(x_i\);
2. compute \(y_i=K^\uparrow x_i\);
3. tighten \(x_i\leftarrow K^\downarrow y_i\);
4. form \(\widehat K=\min_i(x_i+y_i)\);
5. measure the conservative gap \(\widehat K-K\ge0\);
6. add, split, or move modes until the contextual error target is met.

Each retained mode is saturated. No global convergence or optimality claim is
made for naïve alternating updates.

## 30. Active dependency cells

For a factorization, define

\[
\operatorname{Act}(a,c)=
\operatorname*{argmin}_i\bigl(x_i(a)+y_i(c)\bigr).
\]

Different modes govern different cells of \(A\times C\). Ties lie on tropical
walls and remain proof-relevant when downstream behavior depends on the
realizing mode.

## 31. Rank stratification under change

For \(K_\theta\), parameter space is stratified by factor/contextual rank,
nucleus combinatorics, active cells, and wall crossings. Perturbations can
preserve rank, move active regions, split modes, or cause discontinuous rank
jumps. These are dependency phase transitions.

## 32. Sequential systems and behavioral Hankel matrices

For \(f:\Sigma^*\to\overline{\mathbb R}\), define

\[
\boxed{H_f(u,v)=f(uv).}
\]

A finite-state min-plus realization with state carrier \(B\) factors this
past–future matrix through \(B\). Hence every finite submatrix satisfies

\[
\operatorname{rank}_{\min+}(H_f)\le|B|.
\]

These rank lower bounds are state-complexity lower bounds. A converse needs
compatibility with action-induced shifts and is not automatic for arbitrary
semirings.

