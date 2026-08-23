# Prime-Atom Tomography Conditioning Theorems

## Exact finite-volume inverse norms, a cyclic charge-character projector, and the sharpened stable-extraction frontier

**Date:** 2026-08-16 UTC  
**Status:** exact finite-dimensional interpolation theorems plus deterministic verification.  
**Non-claim:** no asymptotic prime-pair estimate, no Goldbach/twin-prime theorem, and no external novelty claim. The interpolation identities are elementary; their value here is the exact conditioning analysis and their placement in the corpus's charge-history boundary problem.

**Depends on:**
- `GTER_OPERATOR_MOMENT_TOMOGRAPHY_DELTA_38_2026-08-14.md`;
- `GTER_REVELATION_NUCLEUS_DELTA_37_2026-08-14.md`;
- `PRIME_PAIR_DYNAMIC_SIEVE_PHASE_THEOREMS_2026-08-16.md`;
- the canonical transmission and its source audit.

**Claim nodes touched:** `ARITH.TOMOGRAPHY`, `OPEN.ARITH_STABLE_EXTRACTION`, `ARITH.GLUE_MEASURE`.  
**New exact nodes proposed:** `ARITH.TOMOGRAPHY_CONDITIONING`, `ARITH.CHARGE_DFT_PROJECTOR`.  
**Change:** the phrase “stable growing-degree reconstruction is open” is sharpened into exact, basis-dependent worst-case error-amplification constants.  
**Remaining obligation:** prove estimates for the actual CRT/Kloosterman fugacity propagator at one of the resulting precision budgets.

---

# 0. Result in one page

Let \(B\) be a nonzero complex normed vector space and let

\[
G(z)=\sum_{j=0}^{R} a_j z^j,
\qquad
a_j\in B.
\]

In the arithmetic application,

\[
a_j=\mu_{j+1}=P\,U_h\,\Pi_{j+1}\,U_k\,P,
\]

so

\[
a_0=\mu_1=P\,U_h\,P\,U_k\,P
\]

is the charge-one intermediate path, while

\[
G(1)=P\,U_{h+k}\,P
\]

is the fully glued path. If a charge-zero intermediate sector is possible, split off its Laurent term before applying the polynomial statements below.

Three exact probe families recover \(a_0\).

## Power moments

\[
P_m:=(z\partial_z)^mG(1)=\sum_{j=0}^{R}j^m a_j.
\]

With

\[
q_R(x):=\prod_{j=1}^{R}\left(1-\frac{x}{j}\right)
=\sum_{m=0}^{R}c_mx^m,
\]

\[
\boxed{
a_0=\sum_{m=0}^{R}c_mP_m.
}
\]

For raw independent absolute errors in the \(P_m\), the exact worst-case
\(\ell_\infty\)-to-\(B\) amplification is

\[
\boxed{\kappa_{\mathrm{pow,raw}}(R)=R+1.}
\]

After the natural support normalization

\[
\widehat P_m=
\begin{cases}
P_0,&m=0,\\
P_m/R^m,&m\ge1,
\end{cases}
\]

the exact amplification is

\[
\boxed{
\kappa_{\mathrm{pow}}(R)
=
\binom{2R}{R}
\sim
\frac{4^R}{\sqrt{\pi R}}.
}
\]

## Factorial moments / Taylor jet

\[
F_m:=G^{(m)}(1)=\sum_{j=0}^{R}j_{\underline m}a_j.
\]

Taylor's theorem gives

\[
\boxed{
a_0=G(0)=
\sum_{m=0}^{R}\frac{(-1)^m}{m!}F_m.
}
\]

After the natural support normalization

\[
\widehat F_m:=\frac{F_m}{R_{\underline m}},
\]

the exact amplification is

\[
\boxed{
\kappa_{\mathrm{fac}}(R)
=
\sum_{m=0}^{R}\binom Rm
=
2^R.
}
\]

Thus, under a matched support-normalized independent absolute-error model,
factorial moments are exponentially better conditioned than power moments:

\[
\boxed{
\frac{\kappa_{\mathrm{fac}}(R)}
{\kappa_{\mathrm{pow}}(R)}
\sim
\frac{\sqrt{\pi R}}{2^R}.
}
\]

## Root-of-unity fugacity values

Let

\[
n:=R+1,
\qquad
\omega:=e^{2\pi i/n},
\qquad
V_\nu:=G(\omega^\nu).
\]

Finite Fourier inversion gives

\[
\boxed{
a_j=
\frac1n
\sum_{\nu=0}^{n-1}
\omega^{-j\nu}V_\nu.
}
\]

In particular,

\[
\boxed{
a_0=
\frac1{R+1}
\sum_{\nu=0}^{R}G(\omega^\nu).
}
\]

The exact worst-case absolute \(\ell_\infty\)-error amplification is

\[
\boxed{\kappa_{\mathrm{DFT}}(R)=1.}
\]

For the charge-history propagator this is the cyclic charge-character projector

\[
\boxed{
P\,U_h\,P\,U_k\,P
=
\frac1{R+1}
\sum_{\nu=0}^{R}
P\,U_h\,
\omega^{\nu(C-1)}
\,U_k\,P
}
\]

on a finite charge support of degree at most \(R\).

This is not a free analytic estimate. It transfers the burden from a growing derivative jet at \(z=1\) to uniform control of \(R+1\) charge-character phases on \(|z|=1\). The gain is an exact conditioning statement, not an assertion that those phase values are easy to bound.

---

# 1. Setup and the correct stability question

## 1.1 Reindexing the hidden-charge measure

The operator-valued hidden-charge measure is

\[
\boldsymbol\mu_{h,k}
=
\sum_r
\mu_r\delta_r,
\qquad
\mu_r=P\,U_h\,\Pi_r\,U_k\,P.
\]

Its fugacity propagator is

\[
\mathcal G(z)
=
P\,U_h\,z^{C-1}\,U_k\,P
=
\sum_r z^{r-1}\mu_r.
\]

Assume first that the finite-volume support lies in

\[
r\in\{1,\ldots,R+1\}.
\]

Set

\[
a_j:=\mu_{j+1},
\qquad
0\le j\le R,
\]

and write

\[
G(z):=\mathcal G(z)=\sum_{j=0}^{R}a_jz^j.
\]

Then

\[
a_0=\mu_1=[z^0]\mathcal G=\mathcal G(0)
\]

is the prime intermediate atom.

If \(r=0\) can occur, then

\[
\mathcal G(z)=z^{-1}\mu_0+G_+(z).
\]

The Laurent coefficient \(\mu_0\) must be separated first. Every theorem below then applies to \(G_+\). This is a domain issue, not a contradiction.

## 1.2 Common trivial envelope

Define coefficient mass

\[
S(a):=\sum_{j=0}^{R}\|a_j\|.
\]

For all \(m\) and all root-of-unity samples,

\[
\left\|
\frac{P_m}{R^m}
\right\|
\le S(a)
\quad(m\ge1),
\]

\[
\left\|
\frac{F_m}{R_{\underline m}}
\right\|
\le S(a),
\]

\[
\|G(\omega^\nu)\|\le S(a).
\]

Thus the support-normalized power moments, support-normalized factorial moments, and unit-circle values have the same elementary magnitude envelope. Their inverse norms can be compared under one explicit error model rather than by comparing unnormalized quantities of wildly different scale.

## 1.3 Exact conditioning functional

Let \(T_0,\ldots,T_R\) be scalar-valued probe operators on the coefficient vector \(a=(a_0,\ldots,a_R)\), and suppose

\[
a_0=\sum_{m=0}^{R}\alpha_mT_m(a).
\]

For perturbed data

\[
\widetilde T_m=T_m+E_m,
\qquad
\max_m\|E_m\|\le\varepsilon,
\]

one has

\[
\left\|
\widetilde a_0-a_0
\right\|
\le
\varepsilon
\sum_m|\alpha_m|.
\]

When the probe transform is square and invertible, the coefficients \(\alpha_m\) are unique. In any nonzero scalar direction of \(B\), sign- or phase-aligned errors attain equality. Therefore

\[
\boxed{
\kappa_\infty(T\to a_0)
=
\sum_m|\alpha_m|
}
\]

is the exact worst-case absolute \(\ell_\infty\)-error amplification, not merely an upper bound.

---

# 2. Power-moment reconstruction

Let

\[
D:=z\partial_z.
\]

Then

\[
P_m:=D^mG(1)
=
\sum_{j=0}^{R}j^ma_j,
\]

with the convention \(P_0=G(1)=\sum_j a_j\).

## Theorem 2.1 — exact power-moment projector

Define

\[
q_R(x)
=
\prod_{j=1}^{R}
\left(1-\frac{x}{j}\right)
=
\sum_{m=0}^{R}c_mx^m.
\]

Then

\[
\boxed{
a_0
=
\sum_{m=0}^{R}c_mP_m.
}
\]

### Proof

For the integer nodes \(j=0,\ldots,R\),

\[
q_R(j)=
\begin{cases}
1,&j=0,\\
0,&1\le j\le R.
\end{cases}
\]

Therefore

\[
\sum_{m=0}^{R}c_mP_m
=
\sum_{m=0}^{R}c_m
\sum_{j=0}^{R}j^ma_j
=
\sum_{j=0}^{R}q_R(j)a_j
=
a_0.
\qquad\square
\]

## Theorem 2.2 — raw power-moment condition number

For independent absolute errors in the raw moments \(P_m\),

\[
\boxed{
\kappa_{\mathrm{pow,raw}}(R)
=
R+1.
}
\]

### Proof

The coefficients of \(q_R\) alternate:

\[
c_m=(-1)^m e_m(1,1/2,\ldots,1/R),
\]

so

\[
\sum_{m=0}^{R}|c_m|
=
q_R(-1)
=
\prod_{j=1}^{R}
\left(1+\frac1j\right)
=
R+1.
\qquad\square
\]

The small value \(R+1\) is not a contradiction to the familiar instability of high moments. Raw high moments have natural magnitude \(R^mS(a)\); equal absolute error in \(P_0\) and \(P_R\) is an extremely asymmetric relative-error model.

## Theorem 2.3 — support-normalized power-moment condition number

For \(R\ge1\), define

\[
\widehat P_0=P_0,
\qquad
\widehat P_m=P_m/R^m
\quad(1\le m\le R).
\]

Then

\[
a_0
=
\sum_{m=0}^{R}
c_mR^m\widehat P_m
\]

and

\[
\boxed{
\kappa_{\mathrm{pow}}(R)
=
\sum_{m=0}^{R}|c_m|R^m
=
\binom{2R}{R}.
}
\]

### Proof

Using the alternating signs again,

\[
\sum_{m=0}^{R}|c_m|R^m
=
q_R(-R)
=
\prod_{j=1}^{R}
\left(1+\frac Rj\right).
\]

But

\[
\prod_{j=1}^{R}
\frac{R+j}{j}
=
\frac{(2R)!}{(R!)^2}
=
\binom{2R}{R}.
\qquad\square
\]

Stirling's formula yields

\[
\boxed{
\kappa_{\mathrm{pow}}(R)
\sim
\frac{4^R}{\sqrt{\pi R}}.
}
\]

Thus a uniform normalized-moment error \(\varepsilon S(a)\) can create worst-case atom error

\[
\binom{2R}{R}\varepsilon S(a).
\]

---

# 3. Factorial moments and the equilibrium jet

Define the factorial moments

\[
F_m:=G^{(m)}(1)
=
\sum_{j=0}^{R}
j_{\underline m}a_j.
\]

They are the ordinary derivatives at the full-gluing point \(z=1\).

## Theorem 3.1 — residue from the full jet

\[
\boxed{
a_0
=
G(0)
=
\sum_{m=0}^{R}
\frac{(-1)^m}{m!}F_m.
}
\]

### Proof

Since \(G\) has degree at most \(R\), Taylor expansion at \(1\) is exact:

\[
G(z)
=
\sum_{m=0}^{R}
\frac{G^{(m)}(1)}{m!}(z-1)^m.
\]

Set \(z=0\). \(\square\)

## Theorem 3.2 — support-normalized factorial condition number

Define

\[
\widehat F_m
=
\frac{F_m}{R_{\underline m}},
\qquad
0\le m\le R,
\]

where \(R_{\underline0}=1\). Then

\[
\boxed{
a_0
=
\sum_{m=0}^{R}
(-1)^m
\binom Rm
\widehat F_m
}
\]

and

\[
\boxed{
\kappa_{\mathrm{fac}}(R)
=
2^R.
}
\]

### Proof

Because

\[
\frac{R_{\underline m}}{m!}
=
\binom Rm,
\]

the reconstruction coefficients are
\((-1)^m\binom Rm\). Their absolute sum is

\[
\sum_{m=0}^{R}\binom Rm=2^R.
\qquad\square
\]

## Corollary 3.3 — exact comparison with normalized power moments

\[
\boxed{
\frac{\kappa_{\mathrm{fac}}(R)}
{\kappa_{\mathrm{pow}}(R)}
=
\frac{2^R}{\binom{2R}{R}}
\sim
\frac{\sqrt{\pi R}}{2^R}.
}
\]

Under matched support-normalized independent absolute errors, ordinary derivatives are exponentially better conditioned than Euler-power moments for extracting the charge-one atom.

This does not say that factorial derivatives are analytically easy to estimate. It says exactly how error in those estimates propagates once they are available.

---

# 4. Cyclic charge-character projection

The full jet is not the only exact finite probe family.

Let

\[
n=R+1,
\qquad
\omega=e^{2\pi i/n}.
\]

Define charge-phase samples

\[
V_\nu:=G(\omega^\nu),
\qquad
0\le\nu<n.
\]

## Theorem 4.1 — complete charge DFT

For every \(0\le j\le R\),

\[
\boxed{
a_j
=
\frac1n
\sum_{\nu=0}^{n-1}
\omega^{-j\nu}V_\nu.
}
\]

### Proof

\[
\frac1n
\sum_{\nu=0}^{n-1}
\omega^{-j\nu}G(\omega^\nu)
=
\sum_{\ell=0}^{R}a_\ell
\left[
\frac1n
\sum_{\nu=0}^{n-1}
\omega^{(\ell-j)\nu}
\right].
\]

The bracket is \(1\) when \(\ell=j\) and \(0\) otherwise because
\(|\ell-j|<n\). \(\square\)

## Corollary 4.2 — prime atom as a cyclic phase average

\[
\boxed{
a_0
=
\frac1{R+1}
\sum_{\nu=0}^{R}
G(\omega^\nu).
}
\]

In charge notation,

\[
\boxed{
\mu_1
=
\frac1{R+1}
\sum_{\nu=0}^{R}
P\,U_h\,
\omega^{\nu(C-1)}
\,U_k\,P.
}
\]

Equivalently, on the finite support,

\[
\boxed{
\Pi_1
=
\frac1{R+1}
\sum_{\nu=0}^{R}
\omega^{\nu(C-1)}.
}
\]

This is the finite cyclic-character projector onto charge one.

## Theorem 4.3 — optimal absolute conditioning of phase samples

For independent sample errors

\[
\widetilde V_\nu=V_\nu+E_\nu,
\qquad
\max_\nu\|E_\nu\|\le\varepsilon,
\]

the reconstructed atom satisfies

\[
\left\|
\widetilde a_0-a_0
\right\|
\le\varepsilon,
\]

and the constant is sharp:

\[
\boxed{
\kappa_{\mathrm{DFT}}(R)=1.
}
\]

### Proof

The reconstruction weights are all \(1/n\), so their absolute sum is \(1\). Equality is attained when all errors point in the same scalar direction. \(\square\)

The same condition number holds for every charge atom \(a_j\), because all DFT row coefficients have magnitude \(1/n\).

## Interpretation

The equilibrium-jet route probes the polynomial locally at \(z=1\) to growing order. The DFT route probes it globally at \(R+1\) charge phases on the unit circle. Algebraically both are complete. Under independent absolute sample error, the phase route is perfectly conditioned.

No estimate has been gained merely by changing basis. To use the DFT route in prime-pair arithmetic one must control

\[
P\,U_h\,e^{i\theta(C-1)}\,U_k\,P
\]

at a growing family of rational phases \(\theta=2\pi\nu/(R+1)\), with the exact CRT/Poisson boundary retained. These are completely multiplicative charge-character sectors. The parity/Liouville sector is one special phase, not the full projector.

---

# 5. Exact precision taxes at arithmetic volume

For integers \(n\le N\),

\[
\Omega(n)\le\lfloor\log_2N\rfloor.
\]

After reindexing charge by \(j=r-1\), take a degree bound

\[
R_N\le\lfloor\log_2N\rfloor.
\]

The exact support-normalized condition numbers are

\[
\boxed{
\begin{array}{c|c}
\text{probe family}&
\ell_\infty\text{ absolute-error amplification}\\
\hline
\text{Euler power moments}&\binom{2R_N}{R_N}\\
\text{ordinary derivative/factorial moments}&2^{R_N}\\
\text{root-of-unity fugacity values}&1
\end{array}
}
\]

with

\[
\binom{2R}{R}
\sim
\frac{4^R}{\sqrt{\pi R}}.
\]

Hence, at the worst-case degree \(R_N\approx\log_2N\),

\[
\boxed{
\kappa_{\mathrm{pow}}
\lesssim
\frac{N^2}{\sqrt{\log N}},
\qquad
\kappa_{\mathrm{fac}}
\le N,
\qquad
\kappa_{\mathrm{DFT}}=1.
}
\]

These are conditioning bounds, not runtime bounds and not arithmetic estimates.

## Precision-tax formulation

Suppose every normalized datum has absolute error at most

\[
2^{-b}S(a).
\]

To guarantee atom error at most \(2^{-t}S(a)\), worst-case sufficient precision is

\[
b\ge t+\log_2\kappa.
\]

Therefore the additional reconstruction taxes are

\[
\boxed{
\begin{aligned}
\text{power moments:}\quad&
2R-\tfrac12\log_2(\pi R)+o(1)\text{ bits},\\
\text{factorial moments:}\quad&
R\text{ bits},\\
\text{phase samples:}\quad&
0\text{ extra bits beyond target absolute precision}.
\end{aligned}
}
\]

Again, the last line does not say phase samples are cheap to compute or estimate. It says the inverse map does not amplify independent absolute sample errors.

---

# 6. Cardinality is not reconstruction geometry

The dynamic-sieve phase theorem gives

\[
L^\ast(M)
=
\max_{t\ne0}(G(D_t)-1),
\]

where \(D_t\) is the separator set for shift \(t\). Its finite counterexample shows that the sparsest separator support need not have the largest reconstruction horizon. Separator **arrangement**, not only separator count, controls worst-case dynamic reconstruction.

The present theorem gives the charge-side analogue. All three probe families use exactly \(R+1\) scalar data, and all are algebraically complete, yet their support-normalized inverse norms are

\[
\binom{2R}{R},
\qquad
2^R,
\qquad
1.
\]

Thus:

\[
\boxed{
\text{number of probes}
\not\Rightarrow
\text{stability of reconstruction}.
}
\]

A finite interface is not fully characterized by whether it separates states. One must also record a modulus of inversion:

\[
\boxed{
\text{usable reconstruction}
=
\text{injectivity/separation}
+
\text{inverse conditioning}
+
\text{return to the target observable}.
}
\]

This is a precise correction to any compression argument that counts probes, moments, or interface states without measuring the geometry of the inverse.

---

# 7. What this changes in the arithmetic frontier

The previous frontier was:

\[
\boxed{
\text{finite algebraic reconstruction is exact;}
\qquad
\text{stable growing-degree reconstruction is open}.
}
\]

The present note replaces the second clause by a routed, quantitative question.

## Route A — Euler-power moments

Prove normalized moment errors satisfying

\[
\boxed{
\max_{m\le R_N}
\|\widetilde P_m/R_N^m-P_m/R_N^m\|
=
o\!\left(
\frac{\|\mu_1\|_{\mathrm{target}}}
{\binom{2R_N}{R_N}}
\right).
}
\]

This route carries an approximately \(4^{R_N}\) worst-case inverse tax.

## Route B — factorial derivative jet

Prove

\[
\boxed{
\max_{m\le R_N}
\left\|
\frac{\widetilde F_m-F_m}
{R_N{}_{\underline m}}
\right\|
=
o\!\left(
\frac{\|\mu_1\|_{\mathrm{target}}}{2^{R_N}}
\right).
}
\]

This route carries an exactly \(2^{R_N}\) worst-case inverse tax.

## Route C — cyclic charge phases

Prove uniform sample control

\[
\boxed{
\max_{0\le\nu\le R_N}
\left\|
\widetilde{\mathcal G}(\omega^\nu)
-
\mathcal G(\omega^\nu)
\right\|
=
o(\|\mu_1\|_{\mathrm{target}}).
}
\]

The inverse tax is \(1\); all difficulty lies in the forward estimates and in retaining CRT/Kloosterman boundary cancellation at every charge phase.

## Route D — exploit non-worst-case structure

The exact constants above assume independent adversarial errors. Arithmetic errors may be correlated, positive after scalarization, spectrally localized, or constrained by recurrences. Any improvement must exhibit that structure explicitly. Possible mechanisms are:

\[
\begin{array}{l}
\text{thin effective charge support};\\
\text{annihilating recurrences / Prony reconstruction};\\
\text{orthogonality of phase-sector errors};\\
\text{positivity or Hankel constraints after scalarization};\\
\text{bad-spectrum exclusion for the canonical vector};\\
\text{analytic control on a contour with a norm matched to coefficient extraction}.
\end{array}
\]

A claim of “stable extraction” should name which mechanism beats the sharp adversarial constants.

---

# 8. No-free-gain discipline

The exact hierarchy

\[
1
<
2^R
<
\binom{2R}{R}
\]

does not contradict unitary invariance or the earlier Gauss/Kuznetsov no-free-gain correction. Condition number depends on:

\[
\boxed{
\text{probe family}
+
\text{data normalization}
+
\text{error norm}
+
\text{target functional}.
}
\]

Changing coordinates cannot improve an invariant estimate already expressed in an invariant norm. But changing which quantities are estimated can change the inverse problem. The DFT route asks for point values at charge phases; the Taylor route asks for local derivatives; the power route asks for Euler moments. These are different forward analytic obligations.

The legitimate conclusion is:

\[
\boxed{
\text{choose the probe family native to the strongest available estimate,}
}
\]

then pay its exact inverse norm. Do not infer analytic saving from algebraic diagonalization alone.

---

# 9. Deterministic verification

Companion checker:

```bash
python prime_atom_tomography_conditioning.py \
  --max-degree 12 \
  --json-report PRIME_ATOM_TOMOGRAPHY_CONDITIONING_REPORT_2026-08-16.json
```

It verifies with exact rational arithmetic:

1. \(q_R(j)=\delta_{0j}\) for every \(0\le j\le R\);
2. raw power condition \(R+1\);
3. normalized power condition \(\binom{2R}{R}\);
4. normalized factorial condition \(2^R\);
5. exact reconstruction of deterministic nontrivial coefficient vectors by all moment formulas;
6. formal cyclic DFT orthogonality and numerical coefficient recovery;
7. sharpness by sign-aligned scalar errors;
8. the volume inequalities used above.

For \(R=1,\ldots,12\), the exact condition table is:

| \(R\) | raw power | normalized factorial | normalized power | phase values |
|---:|---:|---:|---:|---:|
| 1 | 2 | 2 | 2 | 1 |
| 2 | 3 | 4 | 6 | 1 |
| 3 | 4 | 8 | 20 | 1 |
| 4 | 5 | 16 | 70 | 1 |
| 5 | 6 | 32 | 252 | 1 |
| 6 | 7 | 64 | 924 | 1 |
| 7 | 8 | 128 | 3,432 | 1 |
| 8 | 9 | 256 | 12,870 | 1 |
| 9 | 10 | 512 | 48,620 | 1 |
| 10 | 11 | 1,024 | 184,756 | 1 |
| 11 | 12 | 2,048 | 705,432 | 1 |
| 12 | 13 | 4,096 | 2,704,156 | 1 |

Passing the checker verifies only the finite interpolation and conditioning identities. It does not establish estimates for the arithmetic propagator.

---

# 10. Write-back contract

**Exact additions**

\[
\boxed{
\kappa_{\mathrm{pow}}(R)=\binom{2R}{R},
\qquad
\kappa_{\mathrm{fac}}(R)=2^R,
\qquad
\kappa_{\mathrm{DFT}}(R)=1.
}
\]

\[
\boxed{
\mu_1
=
\frac1{R+1}
\sum_{\nu=0}^{R}
P\,U_h\,
e^{2\pi i\nu(C-1)/(R+1)}
\,U_k\,P.
}
\]

**Correction**

Algebraic completeness and \(O(\log N)\) probe count do not determine stable canonical extraction. Probe geometry and inverse norm are additional coordinates.

**Open obligations**

1. instantiate the cyclic phase projector inside the exact smoothed CRT boundary operator;
2. determine whether available multiplicative-function estimates control all required charge phases uniformly;
3. compare phase-sample errors with the Gauss/Kloosterman bad spectral sectors;
4. exploit effective charge rank if the boundary couples to few charges;
5. identify correlation/positivity constraints that improve the worst-case \(\ell_\infty\) constants;
6. return the result as an anti-saturation or canonical-vector rigidity estimate.

**Recommended next reads**

- `PRIME_PAIR_SMOOTHED_BOUNDARY_HERMITIAN_DELTA_2026-08-11.md`;
- `BRAID_DELTA_KUZNETSOV_OBSTRUCTION_2026-08-14.md`;
- `BRAID_DELTA_GAUSS_CHARGE_ONE_2026-08-14.md`;
- `GTER_OPERATOR_MOMENT_TOMOGRAPHY_DELTA_38_2026-08-14.md`;
- `PRIME_PAIR_DYNAMIC_SIEVE_PHASE_THEOREMS_2026-08-16.md`.

---

# Terminal compression

\[
\boxed{
\begin{array}{c}
\text{charge atom}\\
\Updownarrow\\
\text{power moments}
\quad\Big|\quad
\text{factorial jet}
\quad\Big|\quad
\text{cyclic charge phases}
\\[2mm]
\binom{2R}{R}
\quad\Big|\quad
2^R
\quad\Big|\quad
1
\end{array}
}
\]

\[
\boxed{
\text{finite visibility}
\neq
\text{stable recovery};
\qquad
\text{stable recovery}
=
\text{forward estimate}
\times
\text{exact inverse geometry}.
}
\]
