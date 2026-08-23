# PRIME-PAIR RESEARCH DELTA — charge projectors, LCM-convolution, and triple boundary spectrum

## CRITICAL CORRECTION TO THE PREVIOUS CHARGE-BOUNDARY DELTA

The family
\[
a_z=\mu * (n\mapsto z^{\Omega(n)})
\]
satisfies \(a_0=\mu\), but \(z=0\) here selects the **charge-zero state \(n=1\)**, not primes. Therefore the earlier phrase “\(a_0=\mu\) is the prime boundary” was incorrect.

Primes are the charge-one coefficient / tangent at \(z=0\).

For \(n\ge2\), define the desingularized charge field
\[
u_z(n)=z^{\Omega(n)-1},\qquad u_z(1)=0,
\]
and its Möbius/divisor kernel
\[
c_z=\mu*u_z.
\]
Then exactly
\[
u_z(n)=\sum_{d\mid n}c_z(d).
\]
Its Dirichlet series is
\[
\boxed{
C_z(s)=\sum_{d\ge1}\frac{c_z(d)}{d^s}
=
\frac{F(z,s)-1}{z\,\zeta(s)},
\qquad
F(z,s)=\prod_p(1-zp^{-s})^{-1}.
}
\]
The removable value at \(z=0\) is
\[
\boxed{
C_0(s)=\frac{P(s)}{\zeta(s)},
\qquad
P(s)=\sum_p p^{-s}.
}
\]
Coefficientwise,
\[
c_0=\mu*1_{\mathbb P},
\qquad
c_0(n)=\sum_{p\mid n}\mu(n/p).
\]
Thus the exact prime projector is the **first tangent above the Möbius vacuum**, not Möbius itself.

---

## VERIFIED EXACT — LCM/JOIN-CONVOLUTION SPECTRAL THEOREM

For arithmetic functions \(f,g\), define the LCM (join) convolution
\[
(f\vee g)(n)
=
\sum_{\operatorname{lcm}(d,e)=n}f(d)g(e).
\]
Define the divisor-zeta transform
\[
(\mathcal Z f)(n)=\sum_{d\mid n}f(d).
\]
Then
\[
\boxed{
\mathcal Z(f\vee g)
=
(\mathcal Zf)(\mathcal Zg)
}
\]
pointwise. Möbius inversion is the inverse transform.

For each factorization charge \(r\ge0\), let
\[
\pi_r(n)=1_{\{\Omega(n)=r\}},
\qquad
q_r=\mu*\pi_r.
\]
Since the \(\pi_r\) are disjoint pointwise projections,
\[
\pi_r\pi_s=\delta_{rs}\pi_r.
\]
Applying \(\mathcal Z^{-1}\) gives
\[
\boxed{
q_r\vee q_s=\delta_{rs}q_r.
}
\]
Also
\[
\boxed{
\sum_{r\ge0}q_r=\delta_1
}
\]
as a locally finite formal identity.

Therefore the factorization-charge strata are an exact family of mutually orthogonal idempotents in the divisor-lattice join algebra.

The prime sector is
\[
\boxed{
q_1=\mu*1_{\mathbb P};
\qquad
q_1\vee q_1=q_1.
}
\]

The ordinary fugacity kernel has the spectral resolution
\[
a_z=\sum_{r\ge0}z^r q_r
\]
and obeys
\[
\boxed{
a_z\vee a_w=a_{zw}.
}
\]
The desingularized family
\[
c_z=\sum_{r\ge1}z^{r-1}q_r
\]
also obeys
\[
\boxed{
c_z\vee c_w=c_{zw},
}
\]
with
\[
c_0=q_1.
\]

Interpretation: the prime projector is a genuine spectral idempotent of the divisibility semilattice. The hard arithmetic begins when additive translation mixes these LCM-spectral charge sectors.

General semilattice incidence-algebra transforms are established prior art; this specific factorization-charge resolution and its use for prime-pair translation is a project-derived synthesis / novelty candidate.

---

## OPERATOR FORM

On \(\ell^2(\mathbb N)\), let
\[
E_d|n\rangle=1_{d\mid n}|n\rangle.
\]
Then
\[
E_dE_e=E_{\operatorname{lcm}(d,e)}.
\]
Hence
\[
\boxed{
\Pi_r:=1_{\{\Omega(N)=r\}}
=
\sum_{d\ge1}q_r(d)E_d
}
\]
pointwise on the integer basis, and the LCM-idempotence above is exactly
\[
\Pi_r\Pi_s=\delta_{rs}\Pi_r.
\]

For \(|z|<1\),
\[
G(z)=\sum_{r\ge1}z^{r-1}\Pi_r
\]
is a bounded analytic operator family satisfying
\[
G(0)=\Pi_1
\]
(the prime projector) and
\[
G(z)|n\rangle=
\begin{cases}
z^{\Omega(n)-1}|n\rangle,&n\ge2,\\
0,&n=1.
\end{cases}
\]
For \(0\le z\le1\),
\[
\|G(z)-\Pi_1\|=z.
\]

The fixed-gap charge-transition kernel is
\[
K_{X,h}(z,w)
=
\operatorname{Tr}\!\left(P_XG(z)U_h^*G(w)U_h\right)
=
\sum_{n\le X}z^{\Omega(n)-1}w^{\Omega(n+h)-1}.
\]
At \((z,w)=(0,0)\), this is exactly the prime-pair count.

---

## VERIFIED EXACT — CORRECT CHARGE-DEFORMED CRT BOUNDARY DECOMPOSITION

Using \(u_z=1*c_z\),
\[
K_{X,h}(z,w)
=
\sum_{d,e}c_z(d)c_w(e)N_X(d,e;h),
\]
where \(N_X(d,e;h)\) counts \(n\le X\) satisfying
\[
d\mid n,\qquad e\mid n+h.
\]

Let \(g=(d,e)\), \(L=[d,e]\). If \(g\nmid h\), \(N_X=0\). If \(g\mid h\), let \(a(d,e;h)\bmod L\) be the unique CRT solution. Then
\[
N_X(d,e;h)
=
\frac1L
\sum_{r\bmod L}
D_X(r/L)e(-ra/L),
\qquad
D_X(\theta)=\sum_{n\le X}e(n\theta).
\]

Thus:
\[
\boxed{
K_{X,h}
=
\mathcal M_{X,h}
+
\mathcal B_{X,h},
}
\]
where the zero additive mode is
\[
\mathcal M_{X,h}(z,w)
=
X\sum_{\substack{d,e\\(d,e)\mid h}}
\frac{c_z(d)c_w(e)}{[d,e]},
\]
with the finite-volume divisor truncations understood, and the positive-cone boundary is
\[
\mathcal B_{X,h}(z,w)
=
\sum_{\substack{d,e\\(d,e)\mid h}}
\frac{c_z(d)c_w(e)}{[d,e]}
\sum_{\substack{r\bmod[d,e]\\r\ne0}}
D_X(r/[d,e])e(-ra/[d,e]).
\]

At \(z=w=0\), the weights are \(q_1(d)q_1(e)\), not \(\mu(d)\mu(e)\).

The Möbius-weighted formula remains exactly correct for the **finite rough-sieve projection**; the exact prime projector requires the charge-one idempotent \(q_1\).

---

## VERIFIED EXACT — MULTIPLICATIVE CHARACTER DIAGONALIZATION OF THE CRT INVERSE PHASE

In the coprime sector \((d,e)=1\),
\[
\frac{a(d,e;h)}{de}
\equiv
-\frac{h\,d^{-1}}e
\pmod1.
\]
Hence the boundary phase is
\[
e(rh\,d^{-1}/e)
\]
(up to the chosen Fourier sign).

For a Dirichlet character \(\chi\bmod e\), define the generalized Gauss sum
\[
\tau_e(\chi;c)
=
\sum_{x\in(\mathbb Z/e\mathbb Z)^\times}
\chi(x)e(cx/e).
\]
Finite multiplicative Fourier inversion gives, for \(d\in(\mathbb Z/e\mathbb Z)^\times\),
\[
\boxed{
e(c\,d^{-1}/e)
=
\frac1{\varphi(e)}
\sum_{\chi\bmod e}
\tau_e(\chi;c)\chi(d).
}
\]
For primitive \(\chi\) and \((c,e)=1\),
\[
\tau_e(\chi;c)=\overline{\chi(c)}\,\tau(\chi).
\]

Thus the same positive-cone boundary kernel admits:
1. additive Fourier modes \(r/[d,e]\);
2. multiplicative character modes \(\chi\bmod e\);
3. charge modes \(z,w\).

---

## VERIFIED EXACT — TWISTED CHARGE SPECTRUM

For a Dirichlet character \(\chi\), define
\[
F_\chi(z,s)
=
\prod_p(1-z\chi(p)p^{-s})^{-1}.
\]
Twisting the divisor kernel by \(\chi\) gives
\[
\boxed{
C_{z,\chi}(s)
:=
\sum_{n\ge1}\frac{c_z(n)\chi(n)}{n^s}
=
\frac{F_\chi(z,s)-1}{z\,L(s,\chi)}.
}
\]
At the prime point,
\[
\boxed{
C_{0,\chi}(s)
=
\frac{P_\chi(s)}{L(s,\chi)},
\qquad
P_\chi(s)=\sum_p\frac{\chi(p)}{p^s}.
}
\]

Moreover,
\[
\boxed{
P_\chi(s)
=
\sum_{m\ge1}\frac{\mu(m)}m
\log L(ms,\chi^m)
}
\]
in the absolute-convergence half-plane.

Therefore the exact prime-pair boundary operator has a simultaneous spectral description in which:
- the modular-inverse geometry is diagonalized by Dirichlet characters / Gauss sums;
- the prime charge sector has twisted spectrum \(P_\chi/L(s,\chi)\);
- all abelian \(L\)-functions and their power twists enter canonically.

This unifies the previously separate Dirichlet-\(L\), Kloosterman, charge-fugacity, and positive-cone branches inside one exact finite-volume operator.

---

## BOUNDARY-LAYER RIGIDITY THEOREM (CONDITIONAL META-THEOREM)

Let \(H=\{h_1,\ldots,h_k\}\) be admissible and
\[
Z_{H,X}(\mathbf z)
=
\sum_{n\le X}\prod_i z_i^{\Omega(n+h_i)-1}.
\]
Put \(L=\log\log X\) and define the boundary-layer family
\[
\mathcal F_X(\boldsymbol\lambda)
=
\frac{(\log X)^k}{\mathfrak S(H)X}
Z_{H,X}\!\left(\frac{\lambda_1}{L},\ldots,\frac{\lambda_k}{L}\right).
\]

Suppose on every compact polydisc:
1. \(\mathcal F_X\) is locally uniformly bounded;
2. on some product of nonempty real intervals, \(\mathcal F_X(\boldsymbol\lambda)\to e^{\sum_i\lambda_i}\).

Then Montel/Vitali plus the several-variable identity theorem gives
\[
\boxed{
\mathcal F_X(\boldsymbol\lambda)\to e^{\sum_i\lambda_i}
}
\]
locally uniformly throughout the connected domain, including \(\boldsymbol\lambda=0\). Consequently:
\[
\boxed{
\#\{n\le X:n+h_i\in\mathbb P\ \forall i\}
\sim
\mathfrak S(H)\frac{X}{(\log X)^k}.
}
\]

More generally, Cauchy coefficient extraction yields the entire fixed-charge tower:
\[
\boxed{
\#\{n\le X:\Omega(n+h_i)=r_i\ \forall i\}
\sim
\mathfrak S(H)\frac{X}{(\log X)^k}
\prod_i
\frac{(\log\log X)^{r_i-1}}{(r_i-1)!}.
}
\]

For complex \(\lambda_i\),
\[
|Z_{H,X}(\lambda_i/L)|
\le
Z_{H,X}(|\lambda_i|/L),
\]
so expected-order upper bounds for the positive-real boundary layer are sufficient to provide the normal-family bound.

This does not prove Hardy–Littlewood; it identifies a concrete rigidity mechanism: a real-variable boundary-layer asymptotic plus positive upper bounds forces the prime endpoint and all fixed almost-prime strata simultaneously.

---

## STRONGEST LIVE FRONTIER

1. Analyze the exact boundary operator in the simultaneous additive-Fourier / multiplicative-character / charge basis.
2. Seek uniform estimates for
\[
C_{z,\chi}(s)=\frac{F_\chi(z,s)-1}{zL(s,\chi)}
\]
when \(z\asymp1/\log\log X\), combined with spectral large-sieve / Kuznetsov control of the modular-inverse phase.
3. Establish expected-order positive-real upper bounds and any interior boundary-layer asymptotic sufficient for the rigidity theorem.
4. Correct all state files that identify \(a_0=\mu\) directly with the prime endpoint: \(a_0\) is charge zero; primes are the \(q_1\) projector / tangent \(c_0\).
