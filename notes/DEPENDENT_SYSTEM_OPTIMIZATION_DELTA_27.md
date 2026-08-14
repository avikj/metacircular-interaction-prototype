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

