# The index-one Weil criterion

This note isolates a finite-index version of Weil's criterion.  It is a short
consequence of the Mellin-interpolation lemma used by Yoshida and by
Connes--Consani, but the two-pair argument does not appear to have been stated
explicitly in the sources checked so far.

## 1. Form and convention

Let

\[
 \Phi_g(s)=\int_{\mathbb R}g(u)e^{(s-1/2)u}\,du,
 \qquad g\in C_c^\infty(\mathbb R),
\]

and let \(Z\) be the multiset of nontrivial zeros of \(\zeta\).  Write
\(J(s)=1-\overline{s}\).  The polarized Weil form is

\[
 W(g,h)=\sum_{\rho\in Z}
   \Phi_h(\rho)\overline{\Phi_g(J\rho)}.                 \tag{1.1}
\]

The zero multiset is invariant under \(J\), so this is Hermitian.  Its
quadratic form is the \(W(g)\) of `WEIL.md`.  Put

\[
 P=\{g:\Phi_g(0)=\Phi_g(1)=0\},\qquad
 I=\operatorname{pole}-W.
\]

Thus \(I|_P=-W|_P\).  For a Hermitian form \(H\), write \(n_+(H)\) for the
largest dimension of a subspace on which \(H\) is positive definite.

## 2. The interpolation input

We use the following direct finite-point consequence of the interpolation
lemma in Connes--Consani, Appendix C, Proposition C.1 (following Yoshida).

**Lemma 2.1 (finite zero interpolation with a summable tail).**  Let
\(E\subset Z\) be finite and let \((v_z)_{z\in E}\) be prescribed complex
values.  For every sufficiently small \(\epsilon>0\), there is
\(g\in P\) such that

\[
 \Phi_g(z)=v_z\quad(z\in E),                            \tag{2.1}
\]

and, outside \(E\), the values are bounded by a constant times

\[
 \epsilon\sum_{z\in E}(1+|\rho-z|)^{-2}.               \tag{2.2}
\]

Consequently, if \(E\) is \(J\)-stable, the contribution to (1.1) from
\(Z\setminus E\) tends to zero with \(\epsilon\), uniformly for prescribed
values in a fixed finite-dimensional space.

*Derivation.*  The cited proof gives, for one target zero \(z\), a compactly
supported smooth function vanishing at \(0,1\), equal to one at \(z\), and
bounded by \(\epsilon/|\rho-z|^2\) at every other zero.  Apply this once for
each \(z\in E\).  Their evaluation matrix on \(E\) tends to the identity, so
it is invertible for small \(\epsilon\); invert it to impose (2.1).  The
inverse remains bounded and gives (2.2).  The Riemann--von Mangoldt bound
\(N(T)=O(T\log T)\) makes the resulting products summable in (1.1).  Since
\(J(E)=E\), no selected point is paired with an unselected point.  \(\square\)

This is the only analytic input.  In particular, no zero simplicity or RH is
assumed.

## 3. Index-one criterion

**Theorem 3.1.**  The following are equivalent.

1. The Riemann Hypothesis holds.
2. For every finite-dimensional complex subspace \(V\subset C_c^\infty
   (\mathbb R)\),
   \[
      n_+(I|_V)\leq1.                                  \tag{3.1}
   \]

*Proof.*  Assume RH.  Then \(W\geq0\), hence
\(I=\operatorname{pole}-W\leq\operatorname{pole}\).  The pole form is the
pullback of

\[
 (x,y)\longmapsto2\operatorname{Re}(x\overline y),
\]

whose positive index is one.  Therefore every finite restriction of \(I\)
has positive index at most one.

Conversely, suppose RH is false.  Choose an off-line zero
\(\rho=\beta+i\gamma\), \(\beta\ne1/2\).  There are no real nontrivial zeta
zeros, so the functional equation and conjugation give four distinct zeros

\[
 a=\rho,\quad b=J\rho=1-\overline\rho,
 \quad c=\overline\rho,\quad d=J\overline\rho=1-\rho.  \tag{3.2}
\]

They have the same multiplicity \(m\).  Take the \(J\)-stable set
\(E=\{a,b,c,d\}\).  Lemma 2.1 produces \(g_1,g_2\in P\) whose values on
\(E\) are respectively

\[
 (1,-1,0,0),\qquad(0,0,1,-1),                          \tag{3.3}
\]

with arbitrarily small summable tails.  Restricting (1.1) to the four
selected zeros gives

\[
 \begin{pmatrix}
 W(g_1,g_1)&W(g_1,g_2)\\
 W(g_2,g_1)&W(g_2,g_2)
 \end{pmatrix}
 =-2m\,\mathrm{Id}_2+o(1).                             \tag{3.4}
\]

For sufficiently small interpolation error this matrix is negative
definite.  Hence \(W\) is negative definite on
\(V=\operatorname{span}\{g_1,g_2\}\subset P\).  Since \(I|_P=-W|_P\),
the restriction \(I|_V\) is positive definite and
\(n_+(I|_V)=2\), contradicting (3.1).  Thus every nontrivial zero is on the
critical line. \(\square\)

The proof explains why the number one is forced.  A single off-line quartet
is not one indefinite defect: over complex test functions it contains two
independent \(J\)-pairs, one at each sign of the ordinate.

## 4. What is and is not new

The hard analytic ingredient is not new.  Yoshida's construction and
Connes--Consani Appendix C already isolate a chosen zero while enforcing any
finite family of Mellin vanishings.  Weil positivity, the pole form, and the
Hodge/intersection vocabulary are also established prior art.

Targeted searches located positivity and nondegeneracy criteria, including
Suzuki's 2023 screw-function theorems, but not the exact finite-index statement
of Theorem 3.1.  It should therefore be described as an apparently unrecorded
linear-algebra corollary of the existing interpolation theorem, pending an
expert literature check—not as a new route around the analytic difficulty of
RH.

The conceptual gain is compression: full positivity on the primitive block
and an index bound on the unrestricted form are equivalent RH detectors.  An
off-line quartet is witnessed by a two-dimensional subspace.

## 5. Audit obligations

Before promotion:

1. reconstruct Lemma 2.1 directly from Yoshida's original Proposition 1,
   including the topology in which the tail tends to zero;
2. independently check the polarization convention and the factor \(2m\);
3. confirm that complex, rather than real-only, test spaces are allowed in the
   cited Weil criterion;
4. search Pontryagin-space, negative-squares, Yoshida/Bombieri, and
   generalized Nevanlinna literature for this precise index formulation.

