# Prime Pair Field — Fields-Medal / Cross-Mathematics Delta 09

Date: 2026-08-11

Status: research delta. Exact identities are **V1**. Asymptotics derived from the prime number theorem are **PROVED / KNOWN**. Statements using Hardy–Littlewood pointwise asymptotics are explicitly conditional. Random-model calculations are calibration, not evidence of a proof.

## 0. Executive result: binary Goldbach is a one-log angular parity imbalance

From Delta 08, write the Hahn spectral energies of the one-body von Mangoldt vector on `[0,N]` as

\[
e_j(N)=|\widehat\Lambda_N(j)|^2\ge0.
\]

Then

\[
\sum_j e_j(N)=\sum_{n\le N}\Lambda(n)^2
\sim N\log N,
\]

while

\[
\sum_j(-1)^je_j(N)=r(N).
\]

Under the Hardy–Littlewood prediction

\[
r(N)\sim\mathfrak S(N)N,
\]

the normalized even/odd angular-energy imbalance is

\[
\boxed{
\frac{E_{\rm even}(N)-E_{\rm odd}(N)}
{E_{\rm even}(N)+E_{\rm odd}(N)}
\sim
\frac{\mathfrak S(N)}{\log N}.
}
\]

Thus the binary problem asks for deterministic control of a relative `1/log N` imbalance between two positive energies of order `N log N`.

For the unweighted prime indicator, the total energy is `pi(N)~N/log N` and the conjectural pair count is `~mathfrak S(N)N/log^2 N`, so the same ratio `~mathfrak S(N)/log N` appears.

This is an exact spectral meaning of the calibration statement that binary loses by one logarithm.

---

## 1. V1: even and odd energy formulas

Let

\[
E_+(N)=\sum_{j\ \mathrm{even}}e_j(N),
\qquad
E_-(N)=\sum_{j\ \mathrm{odd}}e_j(N).
\]

Parseval and the reflection identity give

\[
E_+(N)+E_-(N)=\sum_{m=0}^N\Lambda(m)^2,
\]

\[
E_+(N)-E_-(N)=r(N).
\]

Therefore

\[
\boxed{
E_\pm(N)
=
\frac12\left(
\sum_{m\le N}\Lambda(m)^2
\pm r(N)
\right).
}
\]

This is not an analogy: Goldbach is literally the polarization defect between the reflection-even and reflection-odd Hahn sectors.

Equivalently, if

\[
a_\pm=\frac12(a_N\pm R_Na_N),
\]

then

\[
E_\pm=\|a_\pm\|_2^2.
\]

---

## 2. PROVED: the total von Mangoldt angular energy is `N log N`

Exactly,

\[
\sum_{n\le x}\Lambda(n)^2
=
\sum_{p^k\le x}(\log p)^2.
\]

The prime-power terms with `k>=2` contribute

\[
O(\sqrt x\log^2x).
\]

For primes, partial summation with

\[
\vartheta(x)=\sum_{p\le x}\log p\sim x
\]

gives

\[
\sum_{p\le x}(\log p)^2
=
\vartheta(x)\log x-
\int_2^x\frac{\vartheta(t)}t\,dt
=
x\log x-x+o(x).
\]

Hence

\[
\boxed{
\sum_{n\le x}\Lambda(n)^2
=x\log x-x+o(x).
}
\]

Combining this with the formulas above yields, conditionally on Hardy–Littlewood,

\[
E_\pm(N)
=
\frac12N\log N
\pm\frac12\mathfrak S(N)N
+o(N\log N).
\]

The desired arithmetic signal is a first-order correction to two much larger positive quantities.

---

## 3. The same one-log ratio for the prime indicator

Let

\[
p_N(m)=1_{\mathbb P}(m),
\]

and let `g(N)` be the ordered unweighted Goldbach count. Then

\[
\|p_N\|_2^2=\pi(N)\sim\frac N{\log N},
\]

and

\[
\langle p_N,R_Np_N\rangle=g(N).
\]

The Hardy–Littlewood prediction is

\[
g(N)\sim\mathfrak S(N)\frac N{\log^2N}.
\]

Therefore

\[
\boxed{
\frac{g(N)}{\pi(N)}
\sim\frac{\mathfrak S(N)}{\log N}.
}
\]

The `1/log N` barrier is independent of whether the signal is normalized as `1_P` or `Lambda`; the weighting changes both total energy and pair signal by the corresponding density factor.

---

## 4. PROVED: every fixed angular multipole sees only the PNT background

Let `Q_{j,N}` be the symmetric Hahn polynomial of fixed degree `j`, normalized independently of `N`, and let

\[
M_j(N)=\sum_{n\le N}\Lambda(n)Q_{j,N}(n).
\]

The Hahn-to-Jacobi limit gives, for fixed `j`,

\[
Q_{j,N}(\lfloor Nt\rfloor)
\longrightarrow
P_j(1-2t)
\]

uniformly on `[0,1]`. The PNT in weak form says

\[
\frac1N\sum_{n\le N}\Lambda(n)f(n/N)
\longrightarrow
\int_0^1f(t)\,dt
\]

for every continuous `f`.

Since

\[
\int_0^1P_j(1-2t)\,dt=0
\qquad(j\ge1),
\]

we obtain

\[
\boxed{
M_j(N)=o(N)
\qquad\text{for every fixed }j\ge1.
}
\]

The Hahn norm satisfies

\[
\sum_{n=0}^NQ_{j,N}(n)^2
\sim\frac N{2j+1},
\]

so the normalized spectral coefficient obeys

\[
\boxed{
\widehat\Lambda_N(j)=o(\sqrt N)
\qquad(j\ge1\text{ fixed}).
}
\]

The constant mode has

\[
|\widehat\Lambda_N(0)|^2
=
\frac{\psi(N)^2}{N+1}
\sim N.
\]

But the full energy is `~N log N`. Therefore:

\[
\boxed{
\text{Any fixed finite collection of Hahn channels captures a vanishing fraction of the von Mangoldt energy.}
}
\]

This is a no-go for solving the sharp problem with finitely many fixed angular multipoles. The required angular aperture must grow with `N`.

---

## 5. Explicit first moment cancellation

The first Hahn mode can be taken as

\[
Q_{1,N}(m)=1-\frac{2m}{N}.
\]

Its arithmetic moment is

\[
M_1(N)
=
\psi(N)-\frac2N\sum_{m\le N}m\Lambda(m).
\]

Partial summation gives

\[
\sum_{m\le N}m\Lambda(m)
=N\psi(N)-\int_1^N\psi(t)\,dt
\sim\frac{N^2}{2}.
\]

Hence the two main terms cancel and

\[
M_1(N)=o(N).
\]

This is the simplest exact demonstration that the nonconstant angular channels discard the equilibrium/PNT bulk and expose only the error structure.

The same mechanism holds for every fixed `j>=1` by orthogonality.

---

## 6. Consequence for the `j=2` Hodge channel

The `j=2` primitive mode is canonically defined and geometrically important, but its one-body coefficient is still only an error-mode observable:

\[
\sum_{n\le N}\Lambda(n)
\left[1-\frac{6n(N-n)}{N(N-1)}\right]
=o(N).
\]

Thus the `j=2` channel cannot by itself retain the full prime energy. Its value is instead:

- it is the first reflection-even primitive channel;
- it annihilates the PNT bulk exactly/asymptotically;
- its zero-side multiplier is explicit and separates zero sums and differences quadratically;
- it is the extremizer of the symmetric primitive spectral gap `6`.

This downgrades any hope that a fixed `j=2` positivity statement alone proves Goldbach, while preserving it as the correct first diagnostic of the primitive sector.

---

## 7. Cramér calibration: coherent mode plus angular white noise

Consider an independent Bernoulli signal `X_m` with mean `delta`. For any orthonormal Hahn vector `phi_j`:

\[
c_j=\sum_mX_m\phi_j(m).
\]

For `j>=1`, `sum_m phi_j(m)=0`, so

\[
\mathbb E[c_j]=0,
\qquad
\mathbb E[|c_j|^2]=\delta(1-\delta).
\]

For the constant mode,

\[
\mathbb E[|c_0|^2]
=\delta^2(N+1)+\delta(1-\delta).
\]

Thus a random sparse set has:

- one coherent constant mode of size `delta^2 N`;
- approximately flat nonconstant angular noise of size `delta` per mode;
- total noise energy `delta N`;
- expected antipodal count of size `delta^2N` after even/odd noise cancellation.

At prime density `delta~1/log N`, this reproduces:

\[
\text{total energy}\sim\frac N{\log N},
\qquad
\text{Goldbach signal}\sim\frac N{\log^2N},
\qquad
\text{relative imbalance}\sim\frac1{\log N}.
\]

The random model makes the required parity balance automatic in expectation. Arithmetic must prove a deterministic analogue after inserting the singular-series bias.

---

## 8. A sharper formulation of the binary parity barrier

Define the high-mode parity discrepancy

\[
D_N(J)
=
\sum_{j>J}(-1)^je_j(N).
\]

The low modes `j<=J` are polynomial moments of `Lambda` and become increasingly accessible through PNT-type input. The full Goldbach coefficient is

\[
r(N)
=
\sum_{j\le J}(-1)^je_j(N)+D_N(J).
\]

A useful theorem must control `D_N(J)` for an aperture `J=J(N)` large enough to resolve prime-scale structure.

The fixed-channel no-go proves `J` cannot remain bounded. A sampling heuristic gives

\[
J\gtrsim\frac N{\log N},
\]

because the average prime spacing in the normalized angular coordinate is `log N/N`. This is an angular analogue of the zero-height aperture law in Theorem B.

The exact quantitative aperture remains open.

---

## 9. Prolate reformulation becomes finite and standard

Let

\[
\Pi_{\le J}
\]

be the Hahn spectral projector onto degrees `0,...,J`, and let

\[
M_I
\]

be restriction to an interval or selected region of the arithmetic diagonal. The concentration operator

\[
M_I\Pi_{\le J}M_I
\]

is a discrete Hahn/Jacobi Slepian problem.

Hahn polynomials are bispectral, and the algebraic-Heun framework constructs tridiagonal commuting operators for finite time-and-band limiting problems of this type. Therefore this part of target #7 is established machinery, not an unspecified wish.

The genuinely arithmetic departures are:

1. the prime support is sparse and irregular rather than a single interval;
2. the desired observable is the antipodal sign `(-1)^j`, not merely concentration;
3. the useful bandwidth must grow toward the microscopic prime scale;
4. local congruence structure and internal factorization charge must be coupled to the angular bandlimit.

The next prolate computation should use the exact Hahn Heun operator and ask how the Ramanujan/local projector sits in its spectral basis.

---

## 10. Ramanujan-block target in Hahn language

Write

\[
\Lambda=\Lambda_Q^\sharp+\Lambda_Q^\flat.
\]

On each diagonal, decompose both signals into Hahn modes. The Goldbach form becomes

\[
\langle\Lambda,R_N\Lambda\rangle
=
\langle\Lambda^\sharp,R_N\Lambda^\sharp\rangle
+2\langle\Lambda^\sharp,R_N\Lambda^\flat\rangle
+\langle\Lambda^\flat,R_N\Lambda^\flat\rangle.
\]

This is exactly the previously measured `BC / mixed / zero` block decomposition, now refined by angular degree.

The new test is:

- Does `Lambda_Q^sharp` concentrate in a controlled collection of low or congruence-adapted Hahn/Heun modes?
- Is the residual `Lambda_Q^flat` approximately parity-balanced in high angular degree?
- Does the mixed coefficient `2` arise as the first off-diagonal polarization in the coupled basis, as expected algebraically?

The scalar coefficient `2` is already exact; the spectral localization questions are open and directly computable.

---

## 11. Relation to the binary-versus-ternary calibration

Binary Goldbach is the difference of two energies of order `N log N` with an expected imbalance of order `N`. Analytically, this is a one-log relative effect.

In ternary Goldbach, an additional factor allows the minor-arc estimate to be distributed through an `(infinity,2,2)` Holder pattern. In the multileg Hahn geometry, the ternary angular degree-`j` space has multiplicity `j+1` rather than one.

These are two exact but not yet proved-equivalent manifestations of “a spare direction”:

- analytic: an additional `L^2` factor;
- representation-theoretic: nontrivial angular channel multiplicity.

A serious next task is to write the ternary minor-arc norm estimate in the multivariate Hahn basis and determine whether the spare Holder factor is literally a trace over the multiplicity space.

---

## 12. Huh / stable-polynomial branch, sharply constrained

The angular spectral polynomial

\[
\mathcal G_N(q)=\sum_je_j(N)q^j
\]

has nonnegative coefficients and Goldbach is `mathcal G_N(-1)`.

It is tempting to seek log-concavity or real-rootedness of `(e_j)`, but arbitrary nonnegative signals do not possess such a property, and preliminary exact computations for prime indicators show many failures of coefficient monotonicity and log-concavity.

Therefore a direct generic Huh theorem on the Hahn-energy sequence is a dead branch.

Any viable Hodge/stability theorem must use additional arithmetic structure, for example:

- the Ramanujan projector;
- congruence-conditioned blocks;
- a multivariate polynomial retaining local prime variables;
- an arrangement/matroid object before taking squared Hahn coefficients.

This prevents another seductive but false positivity import.

---

## 13. Revised priorities after Delta 09

1. Quantify the angular aperture `J(N)` needed to control the parity tail, under RH and under stronger zero-correlation hypotheses.
2. Implement the finite Hahn/Heun concentration operator and numerically decompose `Lambda_Q^sharp`, `Lambda_Q^flat`, and their mixed block.
3. Seek an arithmetic inverse theorem: large high-mode parity discrepancy forces correlation with a classified congruence/character structure.
4. Translate the one-log angular imbalance into the existing AC0/divisibility circuit ladder.
5. Analyze the multivariate Hahn multiplicity spaces for ternary Goldbach and compare directly with the `(infinity,2,2)` Holder proof.
6. Do not pursue generic log-concavity of raw Hahn energy; it is numerically false.
7. Retain `j=2` as the first primitive diagnostic, not as a standalone positivity solution.

---

## 14. Verification boundaries

**V1 / proved:**

- even/odd energy formulas;
- `sum Lambda^2 = x log x-x+o(x)` from PNT;
- fixed-degree Hahn moment cancellation from PNT and Hahn-to-Jacobi convergence;
- first-moment cancellation;
- Bernoulli spectral calibration;
- exact block polarization in Hahn language.

**Conditional:**

- the `1/log N` asymptotic constant using pointwise Hardy–Littlewood;
- the corresponding detailed asymptotics for `E_+` and `E_-`.

**Heuristic / open:**

- aperture `J~N/log N`;
- high-mode parity balance;
- ternary multiplicity as the exact source of the spare Holder factor;
- useful arithmetic Hahn/Heun concentration bounds.

## 15. Literature anchors

- Prime number theorem and partial summation for `sum Lambda(n)^2`.
- Standard Hahn-to-Jacobi limit in the Askey scheme.
- Grünbaum, Vinet, and Zhedanov, *Algebraic Heun operator and band-time limiting*, arXiv:1711.07862.
- Bergeron, Vinet, and Zhedanov, *Signal processing, orthogonal polynomials, and Heun equations*, arXiv:1903.00144.
- Classical Cramér random model as calibration only.
