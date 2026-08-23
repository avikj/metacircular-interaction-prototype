# Goldbach machine — injectivity and charge extraction stop exactly before positivity

**Question.** Can `Pairfield.SumRigidity`, exact charge/Fourier extraction, and the checked bounded prime-pair carrier force every even center fiber to be inhabited?

**Answer.** No. Together they give an exact reconstruction-and-support square, but the final input `0 < coefficient` is absent. A one-atom control shows that every position-forgetting charge summary can agree while a chosen even-center coefficient changes from zero to nonzero. The full signed Fourier coefficient distinguishes the controls, as it must; it still supplies no positivity theorem for the actual prime indicator.

No Goldbach theorem or new core operation is claimed.

## 1. Sources consumed and their exact types

### Checked sum rigidity

`formal/pairfield/Pairfield/SumRigidity.lean` proves for finitely supported nonnegative weights `a,b : ℕ →₀ ℕ`:

\[
\left(\forall N,\ r_a(N)=r_b(N)\right)\Longrightarrow a=b,
\]

where

\[
r_a(N)=\sum_{m+n=N}a(m)a(n).
\]

The polynomial proof is injectivity of squaring on the nonnegative cone: `A²=B²` in an integral domain gives `A=B` or `A=-B`, and coefficient nonnegativity eliminates the second branch. This is a uniqueness theorem conditioned on equality of the **entire** convolution square. It has no conclusion `r_a(N)>0` for a specified `N`.

### Exact charged fixed-fiber square

`notes/CHARGED_FIXED_FIBER_AUDIT.md` defines, for `n≥2`,

\[
u_z(n)=z^{\Omega(n)-1}
\]

and

\[
G_N(z,w)=\sum_{m=2}^{N-2}
 z^{\Omega(m)-1}w^{\Omega(N-m)-1}.
\]

Finite partition by `(Ω(m),Ω(N-m))` gives

\[
G_N(z,w)=\sum_{r,s\ge1}R_{r,s}(N)z^{r-1}w^{s-1},
\]

so

\[
G_N(0,0)=R_{1,1}(N),
\]

the ordered prime-pair count. Finite Fourier orthogonality is exact Laurent coefficient extraction:

\[
P_N(A,B)=[x^N](A(x)B(x)).
\]

Consequently sharp bidegree extraction and additive projection form a commuting square. The note's operator-domain correction is retained: the two vertical extraction maps act on different spaces, so this is a commuting square, not one endomorphism commutator. The arbitrary-coloring control proves that this commutation uses only grading and finite linearity, not prime-specific distribution.

The exact audit was read as mathematics and provenance. Its Python replay was not run.

### Charge descent and history controls

`ProjectionChargeAudit.agda` and `ProjectionChargeAudit2.agda` check that a charge descends through a quotient exactly when it respects the quotient relation; a separating charge cannot descend. `NaturalMachine.ChargeTwoHistories.agda` checks that endpoint augmentation can annihilate an ordered-history difference retained by a relative channel. These results justify retaining charge or history when a declared task reads it. Neither constructs a positive additive center coefficient.

### Bounded actual-prime boundary

`Pairfield.BoundedPrimePair` supplies certified bounded primes, pairs, `pairCenter`, and `PrimeCenterFiber`. The subsequently appearing `Pairfield.GoldbachBoundary` makes the last support equivalence explicit:

\[
\boxed{
0<\operatorname{goldbachCount}(N)
\iff
\operatorname{GoldbachAt}(N)
\iff
\exists p,q\text{ prime},\ p+q=N.}
\]

It also states strong Goldbach as uniform positivity over all even `N≥4`; it proves no positivity estimate. This file was inspected read-only and not replayed in this encounter.

## 2. The exact carrier and map chain

For a declared center `N`, let the finite prime indicator be

\[
\pi_N(n)=
\begin{cases}
1&n\le N\text{ and }n\text{ is prime},\\
0&\text{otherwise}.
\end{cases}
\]

Write

\[
A_N(x)=\sum_{n\le N}\pi_N(n)x^n.
\]

The exact center coefficient is

\[
c_N=[x^N]A_N(x)^2
=\sum_{m+n=N}\pi_N(m)\pi_N(n).
\]

Every summand is nonnegative, and `c_N` is exactly the ordered cardinality of `PrimeCenterFiber N N`. Thus there is an exact proof-relevant chain

```text
charged two-leg finite field
       | sharp charge E₀₀
       v
prime-indicator two-leg field --P_N=[x^N]--> c_N : ℕ
                                                |
                                                | proof of 0 < c_N
                                                v
                                  PrimeCenterFiber N N inhabited
```

The upper square commutes. The lower vertical implication is the checked finite-cardinality support equivalence. The missing datum is exactly the label on that lower arrow:

\[
\boxed{0<[x^N]A_N(x)^2.}
\]

For all centers at once, the missing premise is

\[
\boxed{
\forall N\ge4,\quad 2\mid N\Longrightarrow
0<E_{0,0}P_N(\text{charged two-leg field}).}
\]

This is not weaker than strong Goldbach; by the carrier/support equivalence it is the same proposition in coefficient language. A non-tautological sufficient input must therefore be an estimate implying this inequality. The companion `analytic-uniformity.md` names one such conditional route: a uniform one-sided signed minor-arc bound, together with the standard major-arc asymptotic. Neither estimate follows from injectivity or exact extraction.

## 3. Why the available arrows cannot fill the gap

The three load-bearing statements have incompatible logical directions:

1. **Rigidity:** `(all marginals equal) → (inputs equal)`.
2. **Charge/Fourier extraction:** two ways of computing the same coefficient are equal.
3. **Bounded support:** `(coefficient positive) ↔ (fiber inhabited)`.

Equality and injectivity transport information already present. Positivity is an order property of one output coordinate. No term in (1) or (2) inhabits the left side of (3).

Equivalently, knowing `A_N` exactly determines `A_N²`; it does not imply that every even coefficient of `A_N²` is nonzero. Sum rigidity rules out a second nonnegative input with the same **whole** square, but zero coefficients are fully compatible with a unique square.

The charge theorem has the same boundary. It proves

\[
E_{0,0}P_N=P_NE_{0,0}
\]

as a typed commuting square. A commuting extraction may return zero. The arbitrary-coloring control is decisive: any claim deriving positivity from this square alone would also derive positivity for an arbitrarily chosen color-one set.

## 4. Smallest position-forgetting control

The following systems are controls, not rival models of the actual prime indicator.

With input support restricted to the bounded domain `0,…,6`, define nonnegative finitely supported weights on `ℕ`

\[
a=\delta_3,
\qquad
b=\delta_5.
\]

Both support points are actual primes, but each system retains only one of the primes; neither is `π₆`.

They have identical position-forgetting summaries:

- total mass is one;
- the entire `Ω`-charge histogram is one unit in charge layer `Ω=1`;
- the charged one-leg polynomial after forgetting the exponent position is `1`;
- the parity histogram is one odd atom and zero even atoms;
- for every `α`, their Fourier energies agree:
  \[
  |e(3\alpha)|^2=1=|e(5\alpha)|^2.
  \]

Yet at the even center `N=6`,

\[
r_a(6)=1
\]

because `3+3=6`, while

\[
r_b(6)=0
\]

because the only sum in `b*b` is `5+5=10`.

This is cardinality-minimal among nonempty controls: each system has one support atom. Choosing `3` and `5` makes ordinary parity and factor-count charge agree as well.

Formally, let `S` retain mass, the `Ω` histogram, the parity histogram, and Fourier energy but discard Fourier phase/position. Then

\[
S(a)=S(b),
\qquad
[r_a(6)>0]\ne[r_b(6)>0].
\]

Therefore no function of `S` can decide center-six support for all nonnegative prime-supported controls.

The full exact Fourier data correctly separates them:

\[
A_a(x)=x^3,
\qquad
A_b(x)=x^5,
\]

so

\[
A_a(x)^2=x^6,
\qquad
A_b(x)^2=x^{10}.
\]

Thus this pair does not contradict `sumMarginal_inj` or the charged fixed-fiber square. It identifies exactly what the coarser retained summaries erased: additive position/phase.

## 5. Actual-prime statement kept separate

For the actual finite prime indicator at `N=6`,

\[
\pi_6=\delta_2+\delta_3+\delta_5,
\]

and the center-six coefficient is positive because the certified pair `(3,3)` exists. This is an actual bounded-prime witness. The controls `δ₃` and `δ₅` do not alter that fact and do not propose alternative prime sets.

At a general even `N`, the corresponding actual claim remains exactly `0<c_N`. Injectivity proves that all the coefficients collectively determine the prime indicator; charge extraction locates `c_N`; neither supplies its sign.

## 6. Delta 27 / merge verdict

- **Carrier:** finite nonnegative weights for the control; `BoundedPrimePair N` and `PrimeCenterFiber N N` for the actual statement.
- **Maps:** charge extraction `E₀₀`, finite additive projection `P_N=[x^N]`, convolution-square map `a↦r_a`, cardinality, and the support equivalence from positive count to fiber inhabitation.
- **Exact theorem:** the composite identifies Goldbach at `N` with positivity of one exact coefficient. Rigidity and extraction do not prove that positivity.
- **No-go:** the one-atom pair `δ₃,δ₅` collides under the declared position-forgetting charge/energy summary but has different support at center six.
- **Natural Machine consequence:** preserve the signed position-sensitive coefficient or a proved lower-bound certificate. Charge labels and injective global reconstruction are not substitutes for a positivity witness.
- **Core decision:** no edit. `SumRigidity` and the bounded support bridge already own the checked generic maps; the new content is their exact logical composition and a tiny control, not a missing general theorem.

## Rigor boundary

- **Kernel-checked source, read not replayed here:** `Pairfield.SumRigidity`, `ProjectionChargeAudit`, `ProjectionChargeAudit2`, `NaturalMachine.ChargeTwoHistories`, `Pairfield.BoundedPrimePair`, and the concurrent `Pairfield.GoldbachBoundary` source.
- **Exact finite mathematics in the audited note:** charged bidegree resolution, Laurent coefficient extraction, and the commuting square. The associated Python audit was not executed.
- **Hand-checked here:** the map chain, logical-direction obstruction, and the `δ₃/δ₅` control.
- **Not claimed:** pointwise positivity for any unproved center, a new estimate, a new charge relation, or a counterexample involving the actual prime indicator.
