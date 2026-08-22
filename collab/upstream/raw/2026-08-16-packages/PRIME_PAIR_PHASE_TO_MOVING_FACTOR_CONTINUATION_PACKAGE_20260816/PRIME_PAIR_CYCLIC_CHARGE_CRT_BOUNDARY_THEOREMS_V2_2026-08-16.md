# Prime-Pair Cyclic Charge Projectors Inside the CRT Boundary — V2

## Exact phase-sector reconstruction, diagonal total-charge curvature, and incidence–phase duality

**Date:** 2026-08-16 UTC  
**Status:** exact finite-dimensional identities and exact compression/no-go results.  
**Source status:** roots-of-unity filtering, finite Fourier inversion, and Parseval are inherited elementary harmonic analysis. The project-specific contribution is their placement inside the canonical fixed-charge divisor kernels and the exact CRT boundary decomposition.  
**Non-claim:** no prime-pair asymptotic, no new Kloosterman estimate, and no claim that a phase representation alone creates cancellation.

**Depends on:** `PRIME_PAIR_CANONICAL_CHARGE_CORRECTION_2026-08-11.md`; `PRIME_PAIR_DIVISOR_LATTICE_TWO_CHARGE_DELTA_2026-08-11.md`; `PRIME_PAIR_SMOOTHED_BOUNDARY_HERMITIAN_DELTA_2026-08-11.md`; `GTER_OPERATOR_MOMENT_TOMOGRAPHY_DELTA_38_2026-08-14.md`; `PRIME_ATOM_TOMOGRAPHY_CONDITIONING_THEOREMS_2026-08-16.md`.

**Claim nodes touched:** `ARITH.CANON_CHARGE`, `ARITH.CRT_BOUNDARY`, `ARITH.TOMOGRAPHY`, `ARITH.TWO_CHARGE`, `ARITH.KUZNETSOV_NO_FREE_GAIN`, `OPEN.ARITH_STABLE_EXTRACTION`, `OPEN.ARITH_RIGIDITY`.  
**New exact nodes proposed:** `ARITH.CYCLIC_CRT_PROJECTOR`, `ARITH.DIAGONAL_CHARGE_CURVATURE`, `ARITH.PHASE_ENERGY_NO_GO`, `ARITH.INCIDENCE_PHASE_DOUBLE_RESOLUTION`.  
**Open obligation:** estimate the phase-deformed CRT/Kloosterman family uniformly enough to control its first angular Fourier coefficient, without losing the coefficient structure under triangle or Cauchy–Schwarz.

---

# 0. Result in one page

For

\[
a_z(d):=(z^\Omega*\mu)(d),
\]

the divisor kernel is the finite polynomial

\[
\boxed{
a_z(d)
=
z^{\Omega(d)-\omega(d)}(z-1)^{\omega(d)}
=
\sum_{r=0}^{\Omega(d)}\kappa_r(d)z^r.
}
\tag{0.1}
\]

Let \(M>\Omega(d)\) and \(\zeta=e^{2\pi i/M}\). Finite Fourier inversion gives

\[
\boxed{
\kappa_1(d)
=
\frac1M\sum_{\nu=0}^{M-1}\zeta^{-\nu}a_{\zeta^\nu}(d).
}
\tag{0.2}
\]

Thus the nonmultiplicative canonical prime divisor kernel is the first cyclic Fourier coefficient of multiplicative charge-phase kernels.

For the smoothed grand-canonical shifted correlation

\[
\mathcal C_X^W(z,w;h)
=
\sum_n z^{\Omega(n)}w^{\Omega(n+h)}W(n/X)
\]

and its exact local-equilibrium/positive-boundary split

\[
\mathcal C_X^W(z,w;h)
=
\mathcal M_X^W(z,w;h)
+
\Delta_X^W(z,w;h),
\]

coefficient extraction commutes with the linear CRT/Poisson decomposition. Therefore

\[
\boxed{
\Delta_{1,1}^W(X;h)
=
\frac1{M^2}
\sum_{\nu,\eta=0}^{M-1}
\zeta^{-\nu-\eta}
\Delta_X^W(\zeta^\nu,\zeta^\eta;h).
}
\tag{0.3}
\]

This closes the finite inverse-conditioning problem: the bivariate charge torus recovers the canonical prime boundary with absolute inverse amplification \(1\).

There is a tempting one-dimensional reduction. On a positive interior where both endpoints are at least \(2\),

\[
\mathbf1_{\mathbb P}(n)\mathbf1_{\mathbb P}(n+h)
=
\mathbf1_{\{\Omega(n)+\Omega(n+h)=2\}},
\]

so the **full endpoint count** obeys

\[
\boxed{
C_{1,1}^W(X;h)
=
\frac1M\sum_{\nu=0}^{M-1}
\zeta^{-2\nu}\mathcal C_X^W(\zeta^\nu,\zeta^\nu;h).
}
\tag{0.4}
\]

But the diagonal projector does not preserve the main/boundary decomposition:

\[
\boxed{
[u^2]\Delta_X^W(u,u;h)
=
\Delta_{0,2}^W+\Delta_{1,1}^W+\Delta_{2,0}^W.
}
\tag{0.5}
\]

Since the endpoint sectors \(C_{0,2}^W\) and \(C_{2,0}^W\) vanish on the positive interior,

\[
\Delta_{0,2}^W=-\mathcal M_{0,2}^W,
\qquad
\Delta_{2,0}^W=-\mathcal M_{2,0}^W,
\]

and hence

\[
\boxed{
\Delta_{1,1}^W
=
[u^2]\Delta_X^W(u,u;h)
+
\mathcal M_{0,2}^W
+
\mathcal M_{2,0}^W.
}
\tag{0.6}
\]

The one-dimensional total-charge quotient is endpoint-sufficient but decomposition-inexact. Its exact curvature is the vacuum/charge-two pair.

For \(\rho=\Omega(d)-\omega(d)\) and \(j=\omega(d)\),

\[
|a_{e^{i\theta}}(d)|
=
(2|\sin(\theta/2)|)^j,
\]

and Parseval gives

\[
\boxed{
\frac1{2\pi}\int_0^{2\pi}
|a_{e^{i\theta}}(d)|^2\,d\theta
=
\sum_r|\kappa_r(d)|^2
=
\binom{2j}{j}.
}
\tag{0.7}
\]

The inverse DFT is perfectly conditioned, but the phase-family energy can be exponentially larger than the first coefficient. Thus phase reconstruction removes interpolation instability, not canonical cancellation.

---

# 1. Divisor charge polynomial

For a prime power \(p^a\),

\[
a_z(p^a)=z^a-z^{a-1}=z^{a-1}(z-1).
\]

Multiplicativity yields

\[
\boxed{
a_z(d)
=
z^{\rho(d)}(z-1)^{j(d)},
\qquad
\rho(d)=\Omega(d)-\omega(d),
\quad
j(d)=\omega(d).
}
\tag{1.1}
\]

Expanding gives

\[
\boxed{
\kappa_r(d)
=
\begin{cases}
(-1)^{j-k}\binom jk,
&k=r-\rho\in\{0,\ldots,j\},\\
0,&\text{otherwise}.
\end{cases}
}
\tag{1.2}
\]

In particular,

\[
\boxed{
\kappa_1(d)
=
\begin{cases}
(-1)^{j-1}j,&\rho=0,\\
(-1)^j,&\rho=1,\\
0,&\rho\ge2.
\end{cases}
}
\tag{1.3}
\]

This is the exact Boolean-skeleton plus first-repeat-shell law.

---

# 2. Cyclic coefficient extraction and aliasing

For a polynomial \(A(z)=\sum_{r=0}^R A_rz^r\), let \(\zeta=e^{2\pi i/M}\). Then

\[
\boxed{
\frac1M\sum_{\nu=0}^{M-1}\zeta^{-s\nu}A(\zeta^\nu)
=
\sum_{\substack{0\le r\le R\\r\equiv s\pmod M}}A_r.
}
\tag{2.1}
\]

This is the exact aliasing theorem. If no other supported charge is congruent to \(s\pmod M\), the projector is exact. Taking \(M>R\) is a simple sufficient condition.

Applied to \(a_z(d)\),

\[
\boxed{
\Pi_{1,M}^{\mathrm{cyc}}a(d)
:=
\frac1M\sum_{\nu}\zeta^{-\nu}a_{\zeta^\nu}(d)
=
\sum_{r\equiv1\,(M)}\kappa_r(d).
}
\tag{2.2}
\]

The parity phase \(M=2\) is therefore not primality in general; it aliases every odd fixed-charge kernel.

For \(d>1\), \(a_1(d)=0\), so

\[
\sum_{r\ \mathrm{odd}}\kappa_r(d)
=
-\frac12a_{-1}(d)
=
-\frac12(-1)^{\rho(d)}(-2)^{\omega(d)}.
\tag{2.3}
\]

Parity is exact only after an independent hypothesis truncates the supported endpoint charges to \(\{1,2\}\).

---

# 3. Exact bivariate CRT phase projector

The grand-canonical divisor expansion is

\[
z^{\Omega(n)}
=
\sum_{d\mid n}a_z(d).
\]

Hence

\[
\mathcal C_X^W(z,w;h)
=
\sum_{d,e}a_z(d)a_w(e)
\sum_{\substack{n\equiv0\,(d)\\n\equiv-h\,(e)}}W(n/X).
\tag{3.1}
\]

For compatible \(d,e\), with \(L=[d,e]\) and CRT residue \(a(d,e;h)\), Poisson summation gives a zero-frequency local-equilibrium term and a nonzero-frequency boundary term. Both are linear in the coefficient tensor \(a_z(d)a_w(e)\). Therefore

\[
[z^rw^t]\mathcal M_X^W(z,w;h)=\mathcal M_{r,t}^W,
\]

\[
[z^rw^t]\Delta_X^W(z,w;h)=\Delta_{r,t}^W.
\tag{3.2}
\]

Finite Fourier inversion then proves (0.3).

The phase kernels retain the same inverse-residue geometry. For coprime \(d,e\),

\[
\frac{a(d,e;h)}{de}
\equiv
-\frac{h\bar d}{e}
\pmod1,
\]

so every phase sector still produces incomplete Kloosterman fractions. The charge Fourier transform does not complete the additive orbit or create a free norm gain.

---

# 4. Diagonal compression curvature

Let

\[
\mathcal C_{\mathrm{diag}}(u)
=
\mathcal C_X^W(u,u;h).
\]

Then

\[
[u^2]\mathcal C_{\mathrm{diag}}(u)
=
C_{0,2}^W+C_{1,1}^W+C_{2,0}^W.
\tag{4.1}
\]

On the positive interior the charge-zero endpoint sectors vanish, so (0.4) follows.

However, the divisor kernels \(\kappa_0=\mu\) and \(\kappa_2\) are nonzero. Thus \(\mathcal M_{0,2}\), \(\mathcal M_{2,0}\), \(\Delta_{0,2}\), and \(\Delta_{2,0}\) need not vanish separately. Because endpoint count equals main plus boundary,

\[
0=C_{0,2}^W=\mathcal M_{0,2}^W+\Delta_{0,2}^W,
\]

\[
0=C_{2,0}^W=\mathcal M_{2,0}^W+\Delta_{2,0}^W.
\]

This proves (0.6).

Equivalently, the diagonal total-charge divisor kernel is

\[
\boxed{
\Lambda_2
=
\kappa_0\otimes\kappa_2
+
\kappa_1\otimes\kappa_1
+
\kappa_2\otimes\kappa_0.
}
\tag{4.2}
\]

The desired prime kernel is only its middle summand. Total charge forgets which leg carries the charge; the forgotten leg-label reappears as main/boundary curvature.

---

# 5. Character/Mellin angular form

For a Dirichlet character \(\chi\),

\[
\mathcal A_\chi(z,s)
=
\sum_d\frac{a_z(d)\chi(d)}{d^s}
=
\frac{F_\chi(z,s)}{L(s,\chi)}.
\tag{5.1}
\]

Angular Fourier inversion gives

\[
\boxed{
K_{r,\chi}(s)
=
\frac1{2\pi}
\int_0^{2\pi}
e^{-ir\theta}
\mathcal A_\chi(e^{i\theta},s)\,d\theta.
}
\tag{5.2}
\]

For \(r=1\),

\[
\boxed{
\frac{P_\chi(s)}{L(s,\chi)}
=
\frac1{2\pi}
\int_0^{2\pi}
e^{-i\theta}
\frac{F_\chi(e^{i\theta},s)}{L(s,\chi)}\,d\theta.
}
\tag{5.3}
\]

Two phase anchors are

\[
\mathcal A_\chi(1,s)=1,
\]

\[
\boxed{
\mathcal A_\chi(-1,s)
=
\frac{L(2s,\chi^2)}{L(s,\chi)^2}.
}
\tag{5.4}
\]

The diagonal total-charge symbol at degree two is

\[
\boxed{
[z^2]\mathcal A_\chi(z,s)\mathcal A_\psi(z,t)
=
\frac{
Z_{2,\chi}(s)
+
P_\chi(s)P_\psi(t)
+
Z_{2,\psi}(t)
}{
L(s,\chi)L(t,\psi)
}.
}
\tag{5.5}
\]

The two \(Z_2\) terms are the character/Mellin image of diagonal compression curvature.

---

# 6. Phase energy and relative conditioning

Because the phase factor \(e^{i\rho\theta}\) has unit modulus,

\[
|a_{e^{i\theta}}(d)|^2
=
|e^{i\theta}-1|^{2j}.
\]

The constant Fourier coefficient of

\[
(e^{i\theta}-1)^j(e^{-i\theta}-1)^j
\]

is \(\binom{2j}{j}\), giving (0.7).

For squarefree \(d\), \(|\kappa_1(d)|=j\), so the phase-RMS to charge-one ratio is

\[
\boxed{
\frac{\sqrt{\binom{2j}{j}}}{j}
\sim
\frac{2^j}{\pi^{1/4}j^{5/4}}.
}
\tag{6.1}
\]

On the first repeated-prime shell, \(|\kappa_1(d)|=1\), and the burden is

\[
\boxed{
\sqrt{\binom{2j}{j}}
\sim
\frac{2^j}{(\pi j)^{1/4}}.
}
\tag{6.2}
\]

Thus an estimate that controls phase sectors only by their raw \(L^2\) energy can miss the sparse first Fourier coefficient by an exponential factor in \(\omega(d)\). Since maximal distinct-prime count at scale \(D\) is \(O(\log D/\log\log D)\), this burden is \(D^{o(1)}\), not a fixed power, but it is still the exact conditioning tax carried by phase-energy-only arguments.

---

# 7. Parity no-go

Let

\[
d_1=pq,
\qquad
d_2=p^3q
\]

for distinct primes \(p,q\). Both have \(\omega=2\), while their repeated-prime excesses are \(0\) and \(2\). Therefore

\[
a_{-1}(d_1)=a_{-1}(d_2)=4,
\]

but

\[
\kappa_1(d_1)=-2,
\qquad
\kappa_1(d_2)=0.
\]

Hence

\[
\boxed{
a_{-1}\text{ does not determine }\kappa_1.
}
\tag{7.1}
\]

Parity is the maximal-magnitude point of the phase family, not a sufficient canonical interface. Its sufficiency in the first Buchstab window comes from the independent charge truncation, not from parity alone.

---

# 8. Incidence–phase double resolution

The canonical kernel also satisfies

\[
\boxed{
\kappa_1(n)
=
\sum_{p\mid n}\mu(n/p).
}
\tag{8.1}
\]

Combining (0.2) and (8.1),

\[
\boxed{
\frac1M\sum_{\nu=0}^{M-1}
\zeta^{-\nu}a_{\zeta^\nu}(n)
=
\sum_{p\mid n}\mu(n/p).
}
\tag{8.2}
\]

For the dyadic canonical vector

\[
v_D(n)=\frac{\kappa_1(n)}{\sqrt n}V(n/D),
\]

one obtains two exact forms:

\[
\boxed{
v_D(n)
=
\sum_{pb=n}
\frac{\mu(b)}{\sqrt{pb}}V(pb/D),
}
\tag{8.3}
\]

\[
\boxed{
v_D(n)
=
\frac1M\sum_{\nu=0}^{M-1}
\zeta^{-\nu}
\frac{a_{\zeta^\nu}(n)}{\sqrt n}V(n/D).
}
\tag{8.4}
\]

The incidence resolution exposes the prime–Möbius hyperbola and its quarter-scale short leg. The phase resolution exposes multiplicative sectors and condition-one inversion. Neither dominates the other; the analytic frontier is their interaction before destructive absolute values.

---

# 9. Final frontier

The finite algebra is now closed:

\[
\boxed{
\begin{array}{c}
\text{canonical boundary coefficient}\\
=\text{bivariate cyclic charge Fourier coefficient}\\
=\text{prime–Möbius incidence vector transported through the same CRT boundary}.
\end{array}
}
\]

The remaining problem is forward analytic control. A useful theorem must estimate

\[
\Delta_X^W(e^{i\theta},e^{i\phi};h)
\]

uniformly enough that its \((1,1)\) angular coefficient is small at the prime-pair target scale, or must act directly on the incidence form and return a stronger bound than arbitrary-coefficient Kloosterman theory.

The exact no-go constraints are:

\[
\boxed{
\begin{array}{l}
\text{one diagonal phase loses leg-resolved boundary information};\\
\text{parity aliases all odd charges};\\
\text{phase DFT conditioning }1\text{ does not control phase-family energy};\\
\text{Fourier/Gauss basis change creates no free analytic saving}.
\end{array}
}
\]

The next theorem should therefore use the moving prime/Möbius factor, cyclic phase averaging before absolute values, or both.
