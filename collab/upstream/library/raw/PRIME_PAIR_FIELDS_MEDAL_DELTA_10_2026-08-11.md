# Prime Pair Field — Fields-Medal / Cross-Mathematics Delta 10

Date: 2026-08-11

Status: research delta. Fourier/reflection identities are **V1**. The Rayleigh/Legendre transform is known prior art. The Hahn microlocal interpretation is a derived asymptotic synthesis. Numerical block observations are calibration only.

## 0. Executive result: Ramanujan atoms become rational Bessel beams in Hahn angular momentum

Write the normalized diagonal coordinate as

\[
x=1-\frac{2m}{N}\in[-1,1].
\]

A rational additive character is

\[
e\!\left(\frac{am}{q}\right)
=
\exp\!\left(\frac{2\pi iam}{q}\right)
=
\exp\!\left(\frac{\pi iaN}{q}\right)
\exp\!\left(-i\frac{\pi aN}{q}x\right).
\]

Thus its archimedean angular wavenumber is

\[
\boxed{k=\frac{\pi aN}{q}.}
\]

The Rayleigh expansion

\[
e^{-ikx}
=
\sum_{j=0}^\infty
(2j+1)(-i)^j\,\mathrm j_j(k)P_j(x)
\]

shows that the Legendre/Hahn angular spectrum is a spherical-Bessel packet concentrated near the turning point

\[
\boxed{j\approx k=\pi N\frac aq}
\]

until the finite lattice/Nyquist ceiling is reached.

Ramanujan sums are finite superpositions of these packets over primitive `a mod q`. Therefore the Ramanujan major-arc projector is not a low-Hahn-band object. It is a union of rationally indexed Bessel beams in the joint finite/archimedean phase space.

This corrects a tempting but false version of the prolate program.

---

## 1. KNOWN: Rayleigh plane-wave / Legendre expansion

For real or complex `k`,

\[
\boxed{
e^{ikx}
=
\sum_{j=0}^\infty
(2j+1)i^j\mathrm j_j(k)P_j(x),
\qquad -1\le x\le1,
}
\]

where `j_j` is the spherical Bessel function.

Equivalently,

\[
\int_{-1}^1e^{ikx}P_j(x)\,dx
=2i^j\mathrm j_j(k).
\]

For large `k`, the packet transitions near `j~k`; below the turning point it is oscillatory and above it decays rapidly.

The finite Hahn transform converges to this Legendre transform in the scaling limit `m/N -> (1-x)/2`. Hence a fixed rational frequency `a/q` has its main finite Hahn mass near

\[
j\sim\pi N\left\|\frac aq\right\|,
\]

with folding/aliasing at the finite-degree ceiling. Here `||.||` denotes distance to the nearest integer for a real-valued cosine packet.

---

## 2. Numerical calibration of the turning-point law

An independent finite Hahn diagonalization at `N=500` gives the following peak degrees for the fundamental character `cos(2 pi m/q)`:

\[
\begin{array}{c|c|c}
q & \pi N/q & \text{measured peak }j\\
\hline
5 & 314.2 & 290\\
10 & 157.1 & 150\\
20 & 78.5 & 74\\
50 & 31.4 & 28\\
100 & 15.7 & 14
\end{array}
\]

The discrepancy is the expected finite-size/turning-point shift. This confirms the phase-space dictionary but is not needed for its asymptotic derivation.

For Ramanujan sums `c_q`, the strongest packet is likewise observed near `j~pi N/q` for the fundamental primitive frequencies, with additional beams from the other reduced residues.

---

## 3. Consequence: low denominator is generally high angular momentum

The arithmetic circle-method notion “major arc” means small rational denominator `q`. Along a length-`N` Goldbach diagonal, such an atom oscillates approximately `N/q` times. Therefore it requires angular degree of order

\[
\frac Nq,
\]

more precisely `pi N/q` in the Legendre turning-point normalization.

Hence:

\[
\boxed{
q\text{ small}
\not\Rightarrow
j\text{ small}.
}
\]

In fact small `q` often produces the highest Hahn degrees.

This explains a numerical feature of the Ramanujan decomposition:

- `Lambda_Q^sharp` has a much larger low-Hahn component than the residual, because it contains the equilibrium mode and larger denominators;
- nevertheless a substantial fraction of its energy remains at high Hahn degree, carried by low-denominator periodic atoms;
- `Lambda_Q^flat` is almost entirely high-angular-frequency.

The correct structured region is a phase-space union of curves

\[
\boxed{
\mathcal C_N
=
\left\{\left(\frac aq,j\right):
 j\approx\pi N\left\|\frac aq\right\|\right\},
}
\]

not a rectangle `q<=Q, j<=J`.

---

## 4. V1: exact reflection form on rational Fourier atoms

For `alpha,beta in R/Z`, define

\[
u_\alpha(m)=e(\alpha m),
\qquad 0\le m\le N.
\]

Use the bilinear Goldbach form

\[
B_N(f,g)=\sum_{m=0}^Nf(m)g(N-m).
\]

Then

\[
\begin{aligned}
B_N(u_\alpha,u_\beta)
&=
\sum_{m=0}^N
 e(\alpha m)e(\beta(N-m))\\
&=
e(\beta N)
\sum_{m=0}^Ne((\alpha-\beta)m).
\end{aligned}
\]

Thus

\[
\boxed{
B_N(u_\alpha,u_\beta)
=
e(\beta N)D_N(\alpha-\beta),
}
\]

where

\[
D_N(t)=\sum_{m=0}^Ne(tm)
=
\frac{1-e((N+1)t)}{1-e(t)}
\]

is the finite Dirichlet kernel.

The main term occurs at the resonance

\[
\alpha=\beta,
\]

where

\[
B_N(u_\alpha,u_\alpha)=(N+1)e(\alpha N).
\]

Distinct frequencies are controlled by

\[
|D_N(t)|\le
\min\left(N+1,\frac1{2\|t\|}\right).
\]

This is the exact finite mechanism by which rational phases `e(aN/q)` enter the Goldbach singular series.

---

## 5. V1: Ramanujan block and the truncated singular series as a parity trace

Recall

\[
c_q(m)=\sum_{a\in(\mathbb Z/q\mathbb Z)^\times}e(am/q)
\]

and

\[
\Lambda_Q^\sharp(m)
=
\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q(m).
\]

Expanding the reflection form gives

\[
B_N(\Lambda_Q^\sharp,\Lambda_Q^\sharp)
=
\sum_{q,r\le Q}
\frac{\mu(q)\mu(r)}{\varphi(q)\varphi(r)}
\sum_{a\in U_q}\sum_{b\in U_r}
 e(bN/r)
 D_N(a/q-b/r).
\]

Because `a/q` and `b/r` are reduced fractions, exact resonance occurs only when

\[
q=r,
\qquad
a=b.
\]

The resonant contribution is

\[
\boxed{
(N+1)
\sum_{q\le Q}
\frac{\mu(q)^2}{\varphi(q)^2}c_q(N).
}
\]

This is precisely the truncated Ramanujan/singular-series model, up to the standard endpoint and normalization conventions. All remaining terms are nonresonant finite-boundary contributions.

Now apply the Hahn transform. Since reflection acts by `(-1)^j`, the same exact scalar is

\[
B_N(\Lambda_Q^\sharp,\Lambda_Q^\sharp)
=
\sum_{j=0}^N(-1)^j
|\widehat{\Lambda_Q^\sharp}(j)|^2.
\]

Therefore:

\[
\boxed{
\text{The truncated singular series is the coherent angular-parity trace of rational Bessel packets.}
}
\]

This unifies the Ramanujan/Wiener–Khintchine and Hahn/antipodal descriptions exactly.

---

## 6. Spherical-Bessel parity identity

For a single continuum plane wave, the Legendre energies are proportional to

\[
(2j+1)\mathrm j_j(k)^2.
\]

The spherical-Bessel addition theorem gives

\[
\sum_{j=0}^\infty(2j+1)\mathrm j_j(k)^2=1,
\]

and at the antipodal point,

\[
\boxed{
\sum_{j=0}^\infty
(2j+1)(-1)^j\mathrm j_j(k)^2
=
\mathrm j_0(2k)
=
\frac{\sin(2k)}{2k}.
}
\]

This identity concerns the Hermitian reflection correlation of a single complex plane wave. The arithmetic Ramanujan block uses the bilinear form and includes cross-frequency phases, so it must not be substituted blindly into the singular series.

Its conceptual value is that angular parity of an individual beam is an explicit oscillatory function of its rational wavenumber. The full local factor is produced by coherent interference among the primitive rational beams.

---

## 7. Microlocal interpretation

The circle-method frequency `alpha=a/q` is a finite/rational covector. The Hahn degree `j` is the archimedean angular momentum conjugate to relative displacement along the diagonal.

The Rayleigh transform defines a canonical relation

\[
\boxed{
\alpha\longmapsto
j/N\approx\pi\|\alpha\|.
}
\]

In this sense, the Ramanujan-to-Hahn change of basis is a discrete arithmetic Fourier-integral transform:

- finite rational atoms become archimedean Bessel wave packets;
- reflection parity reads their antipodal phase;
- resonant packets produce singular-series terms;
- nonresonant packets are boundary/off-diagonal errors.

This is the first literal finite-to-archimedean phase-space bridge in the program.

---

## 8. Correction to the prolate target

A simple low-Hahn projector

\[
\Pi_{j\le J}
\]

cannot isolate the Ramanujan major arcs, because low denominators can live near `j~N`.

The correct concentration projector should select a **multiband microlocal region** around the rational Bessel beams:

\[
\Pi_{\mathcal C(Q)}
\approx
\sum_{q\le Q}\sum_{a\in U_q}
\Pi_{|j-\pi N\|a/q\||\le\Delta_j}.
\]

But angular degree alone loses the identity of the rational beam; a faithful operator must retain both:

- the finite character label `a/q` or Ramanujan denominator block;
- the archimedean Hahn/Heun degree.

Thus the relevant Slepian object is matrix-valued or adelically fibered. This aligns with modern matrix-valued and reflective prolate theory more closely than the scalar low-band problem.

---

## 9. Independent numerical block replication

A separate finite Hahn implementation at `N=500`, `Q=50` produced the reflection blocks

\[
\begin{array}{c|r}
\text{block} & \text{value}\\
\hline
\langle\Lambda^\sharp,R\Lambda^\sharp\rangle & 916.6656\\
2\langle\Lambda^\sharp,R\Lambda^\flat\rangle & -51.4719\\
\langle\Lambda^\flat,R\Lambda^\flat\rangle & 0.0693\\
\hline
\text{sum} & 865.2630
\end{array}
\]

matching the direct von Mangoldt reflection correlation to floating precision.

This reproduces the canonical qualitative finding:

- structured/BC block supplies the singular-series model;
- mixed block is the first correction;
- residual zero block is nearly parity-balanced.

The new information is spectral: the structured block is not confined to low Hahn degree; it follows rational Bessel beams across the full angular spectrum.

No verification upgrade is assigned from this single additional computation.

---

## 10. A refined inverse-theorem target

The earlier target “large high-Hahn parity discrepancy implies arithmetic structure” can now be sharpened:

> If a residual signal has a large antipodal/Hahn parity discrepancy, then its joint Ramanujan–Hahn phase-space mass must concentrate near a rational Bessel canonical relation.

This is a microlocal inverse theorem. It should classify structure by packets `(a/q,j)` rather than only by:

- low additive Fourier frequency;
- low denominator;
- low Hahn degree;
- bounded-depth divisibility tests.

The Ramanujan projector gives the model structured objects explicitly.

A successful theorem would say that after removing these packets, the remaining angular even/odd energies equidistribute.

---

## 11. Relation to the finite-place Igusa field

The finite-place local field depends on residue collisions of the affine forms. The Ramanujan character `a/q` records the dual residue-frequency data. Delta 10 adds the archimedean image of that character as a Hahn/Bessel beam.

The proposed adelic relative-trace object should therefore have three compatible descriptions:

1. **residue configuration:** Igusa collision integral;
2. **rational dual frequency:** Ramanujan atom `a/q`;
3. **archimedean angular wavefront:** Bessel packet near `j~pi N a/q`.

The singular series is obtained either by local survival densities or by coherent resonance of the rational packets. The equality is standard Fourier duality locally; the new task is to package all three levels in one transfer/trace formalism retaining the positive-cone boundary.

---

## 12. Revised priorities after Delta 10

1. Build the joint Ramanujan–Hahn transform explicitly and visualize packet concentration for each `(q,a)`.
2. Derive uniform asymptotics for finite Hahn coefficients of `e(am/q)` in the transition region `j~pi Na/q`.
3. Construct a matrix-valued algebraic-Heun/Slepian operator localized to rational Bessel beams rather than a scalar low-degree band.
4. Formulate the residual inverse theorem in this microlocal phase space.
5. Re-express the mixed block as interference between structured Bessel packets and diffuse zero-spectrum mass.
6. Compare the packet turning-point asymptotics with the zero-height aperture law and the Meixner/continuous-Hahn archimedean transform.
7. Search for an adelic Fourier-integral or relative-trace construction with finite Igusa and real Bessel/Hahn localizations.

---

## 13. Verification boundaries

**V1:**

- rational-character coordinate change and wavenumber;
- exact bilinear reflection/Dirichlet-kernel formula;
- exact resonant contribution to the Ramanujan sharp block;
- equality of the reflection form with the alternating Hahn trace.

**Known prior art:**

- Rayleigh plane-wave expansion;
- spherical-Bessel addition theorem;
- Hahn-to-Jacobi scaling;
- Ramanujan expansion of the singular-series model.

**Derived asymptotic synthesis:**

- packet concentration near `j~pi Na/q`;
- rational Bessel canonical relation;
- multiband/microlocal correction to the prolate target.

**Open:**

- uniform finite Hahn turning-point estimates;
- matrix-valued rational-beam Heun operator;
- microlocal inverse theorem for the residual;
- adelic relative-trace packaging;
- any new Goldbach consequence.

## 14. Literature anchors

- NIST DLMF, plane-wave expansion, equation 10.60.7.
- Mehrem, *The plane wave expansion, infinite integrals and identities involving spherical Bessel functions*, arXiv:0909.0494.
- Standard Ramanujan-sum expansion and Wiener–Khintchine calculation for Hardy–Littlewood factors.
- Grünbaum–Vinet–Zhedanov and later matrix-valued/reflective prolate work.
