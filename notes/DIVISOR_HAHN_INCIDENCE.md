# The divisor--Hahn incidence transform

**Status:** exact finite mathematics; first landing of the fourth-corner
workstream.  This note extracts the common finite object behind canonical
factorization charge, Hahn angular resolution, and the positive-interval CRT
boundary.  It does **not** prove a Ramanujan--Hahn stationary-phase asymptotic
or a prime-pair estimate.

The main correction is structural.  The three coordinates are not three
diagonalizations of one self-adjoint operator.  Hahn modes diagonalize a
birth--death operator; fixed charge diagonalizes the LCM/join algebra; additive
characters resolve the CRT interval discrepancy.  The incidence transform
intertwines these different structures.

## 1. Finite diagonal and conventions

Fix an integer (N\ge 4), and put

\[
I_N=\{2,3,\ldots,N-2\}.
\]

Let (V_N) be the real vector space of functions on

\[
\{0,1,\ldots,N\}
\]

with counting inner product.  Extend every arithmetic signal below by zero
outside (I_N).  Let (R_N) be reflection,

\[
(R_Nf)(m)=f(N-m).
\]

The Hahn birth--death operator is

\[
(L_Nf)(m)
=(m+1)(N-m)(f(m+1)-f(m))
+m(N-m+1)(f(m-1)-f(m)),
\]

with the missing endpoint terms omitted.  It is symmetric for counting
measure: the coefficient on the edge (m\leftrightarrow m+1) is
((m+1)(N-m)) in both directions.  Choose a real orthonormal Hahn basis
(Q_{j,N}), (0\le j\le N), satisfying

\[
L_NQ_{j,N}=-j(j+1)Q_{j,N},\qquad
Q_{j,N}(N-m)=(-1)^jQ_{j,N}(m).
\]

For (f\in V_N\), write

\[
\widehat f_N(j)=\sum_{m=0}^Nf(m)Q_{j,N}(m).
\]

For complex signals it is important to distinguish the bilinear form

\[
B_N(f,g)=\sum_{m=0}^N f(m)g(N-m)
\]

from the Hermitian form (\langle f,R_Ng\rangle).  The former is the native
Goldbach form.

## 2. The incidence matrix and its rational-frequency resolution

For (d\ge1\), (r\in\mathbb Z/d\mathbb Z\), define the
residue-resolved divisor--Hahn incidence coefficient

\[
\boxed{
\mathcal H_N(j;d,r)
=\sum_{\substack{m\in I_N\\m\equiv r\pmod d}}Q_{j,N}(m).
}
\tag{2.1}
\]

Define also the finite plane-wave/Hahn coefficient

\[
\boxed{
\mathcal F_N(j;\alpha)
=\sum_{m\in I_N}Q_{j,N}(m)e(\alpha m),
\qquad e(x)=e^{2\pi ix}.
}
\tag{2.2}
\]

**Theorem 2.1 (exact rational Fourier resolution).**  For every (d,j,r),

\[
\boxed{
\mathcal H_N(j;d,r)
=\frac1d\sum_{a\bmod d}e(-ar/d)\,
\mathcal F_N(j;a/d).
}
\tag{2.3}
\]

Conversely,

\[
\boxed{
\mathcal F_N(j;a/d)
=\sum_{r\bmod d}e(ar/d)\mathcal H_N(j;d,r).
}
\tag{2.4}
\]

**Proof.**  Insert the exact character identity

\[
1_{m\equiv r\,(d)}
=\frac1d\sum_{a\bmod d}e(a(m-r)/d)
\]

into (2.1).  This gives (2.3); finite Fourier inversion gives (2.4).
\(\square\)

This is the exact finite content beneath the phrase
``Ramanujan--Hahn transform.''  Any assertion that the mass of
\(\mathcal F_N(j;a/d)\) concentrates near

\[
j\sim \pi N\|a/d\|
\]

is an additional uniform asymptotic theorem, not part of Theorem 2.1.

## 3. Canonical factorization charge enters through incidence

For (n\ge2\) and a formal or complex parameter (z), put

\[
u_z(n)=z^{\Omega(n)-1},
\]

and set (u_z(0)=u_z(1)=0).  Let

\[
c_z=\mu*u_z.
\]

Then, for every (n\ge1),

\[
u_z(n)=\sum_{d\mid n}c_z(d).
\tag{3.1}
\]

Equivalently, in terms of the fixed-charge kernels

\[
q_r=\mu*1_{\Omega=r},
\]

one has the locally finite formal expansion

\[
c_z=\sum_{r\ge1}z^{r-1}q_r.
\tag{3.2}
\]

In particular,

\[
c_0=q_1,\qquad u_0=1_{\mathbb P}.
\tag{3.3}
\]

Define the truncated charge signal (v_{N,z}\in V_N) by

\[
v_{N,z}(m)=1_{I_N}(m)u_z(m).
\]

**Theorem 3.1 (charge-to-angle transform).**  Its Hahn coefficients satisfy

\[
\boxed{
\widehat v_{N,z}(j)
=\sum_{d\le N-2}c_z(d)\mathcal H_N(j;d,0).
}
\tag{3.4}
\]

Consequently,

\[
\boxed{
[z^{r-1}]\widehat v_{N,z}(j)
=\sum_{d\le N-2}q_r(d)\mathcal H_N(j;d,0).
}
\tag{3.5}
\]

At (r=1), this is the exact canonical-prime-to-Hahn transform.

**Proof.**  Using (3.1), all sums being finite,

\[
\begin{aligned}
\widehat v_{N,z}(j)
&=\sum_{m\in I_N}Q_{j,N}(m)\sum_{d\mid m}c_z(d)\\
&=\sum_{d\le N-2}c_z(d)
  \sum_{\substack{m\in I_N\\d\mid m}}Q_{j,N}(m),
\end{aligned}
\]

which is (3.4).  Extracting the coefficient with (3.2) gives (3.5).
\(\square\)

The matrix (\mathcal H_N(j;d,0)\) is not generally unitary: the divisor
indicators (1_{d\mid m}\) form a redundant, nonorthogonal synthesis family,
whereas the Hahn polynomials form an orthonormal basis.  Thus (3.4) is an
exact intertwining/synthesis identity, not a simultaneous diagonalization.

## 4. The sharp corner in the Hahn and divisor bases

Define the charged Goldbach polynomial

\[
\boxed{
\mathscr G_N(z,w)
=B_N(v_{N,z},v_{N,w})
=\sum_{m\in I_N}u_z(m)u_w(N-m).
}
\tag{4.1}
\]

At the canonical prime point,

\[
\boxed{
\mathscr G_N(0,0)
=\sum_{m=2}^{N-2}1_{\mathbb P}(m)1_{\mathbb P}(N-m).
}
\tag{4.2}
\]

This counts ordered Goldbach representations in the stated endpoint
convention.

**Theorem 4.1 (two exact resolutions of the sharp corner).**  One has the
Hahn resolution

\[
\boxed{
\mathscr G_N(z,w)
=\sum_{j=0}^N(-1)^j
\widehat v_{N,z}(j)\widehat v_{N,w}(j),
}
\tag{4.3}
\]

and the divisor/CRT resolution

\[
\boxed{
\mathscr G_N(z,w)
=\sum_{d,e}c_z(d)c_w(e)\,C_N(d,e),
}
\tag{4.4}
\]

where the finite sum may be restricted to (d,e\le N-2), and

\[
C_N(d,e)
=\#\{m\in I_N:d\mid m,\ e\mid N-m\}.
\tag{4.5}
\]

The compatibility condition is

\[
C_N(d,e)=0\quad\text{unless}\quad(d,e)\mid N.
\tag{4.6}
\]

When ((d,e)\mid N\), the congruences select one residue
(a_N(d,e)\pmod{[d,e]}\).

**Proof.**  Expand both signals in the real orthonormal Hahn basis.  Since
(R_NQ_{j,N}=(-1)^jQ_{j,N}), the bilinear form gives (4.3), with no complex
conjugation.  Expanding both (u)'s by (3.1) and interchanging finite sums
gives (4.4).  The CRT gives (4.6) and uniqueness modulo the least common
multiple. \(\square\)

**Hermitian warning.**  For arbitrary complex (z,w), equation (4.3) is
bilinear.  The Hermitian identity is instead

\[
\langle v_{N,z},R_Nv_{N,w}\rangle
=\sum_j(-1)^j\widehat v_{N,z}(j)
\overline{\widehat v_{N,w}(j)}.
\]

Writing absolute squares in (4.3) is valid only in the real diagonal case.

## 5. Equilibrium and positive-boundary frequencies

Let (M=[d,e]\), and suppose ((d,e)\mid N\).  For a finite interval
(I\subset\mathbb Z\), put

\[
D_I(\alpha)=\sum_{m\in I}e(\alpha m).
\]

Finite Fourier inversion on (\mathbb Z/M\mathbb Z\) gives

\[
\boxed{
C_N(d,e)
=\frac{|I_N|}{M}
+\frac1M\sum_{\substack{k\bmod M\\k\ne0}}
D_{I_N}(k/M)e(-ka_N(d,e)/M).
}
\tag{5.1}
\]

Therefore

\[
\boxed{
\mathscr G_N(z,w)
=\mathscr G_N^{\mathrm{eq}}(z,w)
+\mathscr G_N^{\partial}(z,w),
}
\tag{5.2}
\]

where

\[
\mathscr G_N^{\mathrm{eq}}(z,w)
=|I_N|\sum_{(d,e)\mid N}
\frac{c_z(d)c_w(e)}{[d,e]},
\tag{5.3}
\]

and

\[
\mathscr G_N^{\partial}(z,w)
=\sum_{(d,e)\mid N}\frac{c_z(d)c_w(e)}{[d,e]}
\sum_{\substack{k\bmod[d,e]\\k\ne0}}
D_{I_N}(k/[d,e])e(-ka_N(d,e)/[d,e]).
\tag{5.4}
\]

Here ((d,e)\mid N) means the divisibility condition on the gcd, not that an
ordered pair divides (N).

**Proof.**  The indicator of the CRT residue is

\[
1_{m\equiv a\,(M)}
=\frac1M\sum_{k\bmod M}e(k(m-a)/M).
\]

Sum it over (I_N), then insert the result into (4.4). \(\square\)

The zero mode (5.3) is finite-adic equilibrium in this endpoint convention;
all positive-interval information not determined by the local density is in
(5.4).  For coprime (d,e), solving the CRT residue introduces the inverse
phase (e(-kNd^{-1}/e)\), up to the chosen residue/sign convention.  Thus the
Kloosterman/character boundary and the rational plane waves in Theorem 2.1
are two appearances of the same finite additive characters, but on different
sides of the incidence transform.

## 6. The actual fourth-corner object

Equations (2.3), (3.4), (4.3), and (5.4) form the exact commuting calculation

\[
\text{canonical charge coefficients}
\longrightarrow
\text{divisor residue classes}
\longrightarrow
\text{rational plane waves}
\longrightarrow
\text{Hahn angular modes}
\longrightarrow
\text{antipodal trace}.
\]

The fourth-corner object is therefore the residue-resolved incidence tensor

\[
\boxed{\mathcal H_N(j;d,r),}
\]

together with the nonzero-frequency boundary weights in (5.4).  It measures
how canonical factorization charge is distributed across rational/angular
modes after restriction to the positive Goldbach diagonal.

The theorem does **not** yet provide an estimate.  A useful next decomposition
would separate the (a=0) mode, primitive rational modes with denominator
bounded by (Q\), and the remaining frequencies.  The new content would be a
uniform estimate for the charge-one antipodal quadratic form of the residual,
not the formal existence of that split.

## 7. Successor statements and falsifiers

### Exact next lemma

Derive a closed hypergeometric formula for

\[
\mathcal F_N(j;a/d)
\]

in the present counting-measure Hahn normalization, and prove a uniform
finite-Hahn/Legendre comparison in a declared range of (j,d,N).  Only after
that comparison is controlled may one promote the Rayleigh localization

\[
j\approx \pi N\|a/d\|.
\]

### Arithmetic target

After a denominator cutoff (Q\), define the rational-beam span from the
vectors (j\mapsto\mathcal F_N(j;a/d)), (d\le Q\), and its orthogonal
projector (P_{N,Q}^{\mathrm{rat}}\).  The genuine inverse/estimate problem is
to control the charge-one residual antipodal form

\[
\left\langle
(1-P_{N,Q}^{\mathrm{rat}})v_{N,0},
R_N(1-P_{N,Q}^{\mathrm{rat}})v_{N,0}
\right\rangle
\]

relative to the singular-series contribution, with (Q\) and the angular
aperture growing with (N\).

### Cheapest exact controls

1. Verify (4.3) and (4.4) for arbitrary rational signals, not only primes.
2. A deliberately non-reflection-stable interval must break the unmodified
   Hahn formula, confirming the endpoint hypothesis.
3. Replacing the bilinear coefficient product in (4.3) by absolute squares
   must fail for a nonreal signal.
4. At (z=w=0), the divisor expansion with (q_1\) must reproduce the direct
   ordered prime-pair count exactly; replacing (q_1\) by (\mu\) is a planted
   false control and should not agree in general.

## 8. Rigor boundary

**Proved here:** all finite identities (2.3)--(5.4), conditional only on the
standard Hahn eigenbasis/reflection normalization stated in Section 1; the
charge convolution identities used in Section 3 are exact identities already
recorded in `chatgptdump.md` and should receive an independent local-source
audit before registry promotion.

**Not proved:** a hypergeometric closed form in this normalization; uniform
Hahn-to-Legendre asymptotics; Bessel packet localization; a microlocal inverse
theorem; any saving for the residual boundary; any Goldbach consequence.

**Interpretation boundary:** `DIVISOR_HAHN_INCIDENCE` supplies an exact map
between three existing coordinate systems.  Calling it the central object of
the full program is a strategic hypothesis, not a mathematical conclusion.
