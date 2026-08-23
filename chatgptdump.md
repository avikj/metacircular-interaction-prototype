---
title: "Prime-Pair Field / Additive–Multiplicative Arithmetic Program — Self-Contained Agent Handoff"
date: 2026-08-11
scope: "Distillation of the materialized math research library through Fields-Medal Delta 12"
intended_readers: "Long-running Claude Code, Codex, theorem-proving, literature-search, and computational-research agents"
canonical_repo_hint: "avikj/math"
---

# Prime-Pair Field / Additive–Multiplicative Arithmetic Program

## Self-contained canonical handoff for autonomous research agents

This document is the compacted working state of the Prime-Pair Field program as of **August 11, 2026**. It merges the useful content of the 27 materialized Markdown files in the math library: the canonical research state, the arithmetic ledger, the charge/CRT/operator deltas, the cross-mathematics lens, and Fields-Medal Deltas 02–12.

It is written to let a new agent enter the project without depending on prior chat context. It is not a popular exposition. It is an operational mathematical state: definitions, exact identities, proved corrections, known prior art, conjectural bridges, numerical evidence, killed branches, and concrete next problems.

**Nothing here proves Goldbach, twin primes, the Hardy–Littlewood prime-tuple conjecture, or the Riemann hypothesis.** The program has produced a substantial exact architecture around the obstruction. The unresolved problem is increasingly localized, but it remains unresolved.

## Fast navigation for a new agent

Read Sections **0–3** first for precedence, notation, and authoritative corrections. Then choose the path matching the task:

- **Core pair field and reconstruction:** Sections 4–5.
- **Finite-adic equilibrium and factorization charge:** Sections 6–8.
- **Affine/CRT/Kloosterman boundary:** Section 9.
- **Archimedean Meixner–`SU(1,1)` and finite Hahn geometry:** Sections 10–12.
- **Multileg and factorization-space geometry:** Sections 13–14.
- **Independent prime-polynomial/all-pass branch:** Section 15.
- **Master problems, killed branches, evidence, and priorities:** Sections 16–19.
- **Executable workstreams and long-running-agent protocol:** Sections 20–22.
- **Prior art, truth-status map, and source manifest:** Sections 23–25.
- **One-paragraph research thesis:** Section 26.

For machine ingestion, the file is intentionally plain Markdown with LaTeX display equations and no dependence on chat-only context.

---

# 0. Agent contract: how to use this document

## 0.1 Authority and precedence

Use the following precedence order.

1. An explicit proved correction later in this document overrides an earlier formulation.
2. Exact formulas and theorems copied here override surrounding metaphor or interpretation.
3. `KNOWN PRIOR ART` means the mathematical fact is not a project novelty, even when its placement in this architecture may be new.
4. `NOVELTY CANDIDATE` means no sufficient prior-art match was found in the library’s searches; it is not permission to claim novelty publicly.
5. `TARGET` or `CONJECTURAL` means there is no theorem yet.
6. `NO-GO` or `KILLED BRANCH` means do not restart the branch in its stated form unless a premise is changed explicitly.

The library index defines a verification ladder:

- `V1`: complete written proof in a delta;
- `V2`: independent replication;
- `V2.5`: exact-arithmetic certification;
- `V3`: Lean 4 + mathlib, passing with zero `sorry`s.

Some source deltas use `V1` more loosely for “proved in this file,” and an external user-supplied handoff was referenced by the index but is not itself materialized in the library. Therefore **do not infer a verification grade from a bare V-label alone**. In new work, spell out the evidence: written proof, independent derivation, exact computation, or machine check.

## 0.2 Provenance gap that must remain visible

The library index references a separate “User external state v1, 2026-08-11,” authoritative for an older V1/V2/V2.5/V3 summary and seven named open targets. That exact document is absent from the materialized library. Its surviving downstream branches are represented here, especially:

- the marginal-reconstruction / homometry branch;
- the prime-polynomial factor branch called **Conjecture A-double-prime**;
- the degree-eight frontier;
- the unresolved “epsilon variance closure” label.

The exact original definition of the prime polynomial in that external handoff, the verbatim seven target names, and the full epsilon-variance statement could not be recovered. Do not invent them. Treat the corresponding branch in Section 15 as partially specified until the original source or repository version is found.

## 0.3 Required research behavior

Every durable new result should be stored in this form:

- **VERIFIED EXACT** — statement, hypotheses, proof;
- **KNOWN PRIOR ART** — exact source and theorem, not vague resemblance;
- **NOVELTY CANDIDATE** — search terms, databases searched, closest matches;
- **NUMERICAL** — code, range, precision, normalization, reproducibility seed;
- **KILLED BRANCH** — exact contradiction, counterexample, or structural no-go;
- **LIVE FRONTIER** — smallest next theorem or falsifiable computation.

Do not optimize for a clever analogy. Promote a bridge only when it gives one of: an exact identity, a useful operator, a transferable theorem, a computable invariant, a proof reduction, or a sharp no-go.

Set-theoretic reconstruction is not enough. Every reconstruction claim must include conditioning, aperture, scale locality, and required precision.

---

# 1. Executive state of the program

The project began from the observation that Goldbach and prime gaps are two projections of one pair field. It has now resolved into three exact coordinates and one hard joint boundary.

## 1.1 Three coordinates

### Internal multiplicative coordinate: factorization charge

For an integer `n`, let

\[
C(n)=\Omega(n),
\]

where `Omega` counts prime factors with multiplicity. Primes are exactly the charge-one sector among integers `n>=2`.

This coordinate is governed by:

- the charge-deformed Buchstab flow;
- canonical fixed-charge projectors;
- finite-place Igusa integrals;
- Boolean/Walsh parity sectors;
- a scale-truncated residual charge bit near the square-root sieve horizon.

### External additive/angular coordinate

On a fixed sum diagonal `m+(N-m)=N`, the coordinate `m` carries a finite Hahn/Jacobi geometry. The angular degree is `j`; reflection `m -> N-m` acts by `(-1)^j`. Goldbach is the sharp antipodal trace of the prime signal on this diagonal.

This coordinate is governed by:

- Hahn/Jacobi birth–death operators;
- `SU(1,1)` tensor decomposition;
- beta and continuous-Hahn kernels;
- Meixner–Pollaczek spectral measures;
- heat/Poisson regularization and prolate concentration;
- a growing angular aperture.

### Affine/determinant coordinate

Buchstab peeling of the two affine forms `n` and `n+h` produces integer matrices of fixed determinant `h`. The determinant is the exact gap invariant. At finite primes it records collision depth; globally the finite-interval boundary produces modular inverses and Kloosterman-type phases.

This coordinate is governed by:

- fixed-determinant matrix states;
- Farey/Hecke geometry at the state-space level;
- CRT residues;
- Dirichlet-character and Kloosterman spectral decompositions;
- a positive-cone boundary operator concentrated near square-root divisor scales.

## 1.2 The hard corner

The local, positive, smoothed interiors are comparatively controlled. Prime pairs require the simultaneous limit

1. **internal charge becomes exactly one on each leg**;
2. **external angular evaluation becomes the sharp antipode**;
3. **the positive-integer interval boundary is retained rather than quotiented away**;
4. **the aperture grows with the arithmetic scale**.

This is the core synthesis:

> The prime-pair obstruction is not one missing parity bit in isolation. It is a joint boundary-lifting problem coupling canonical factorization charge, the positive cone, and high angular/rational-frequency structure.

## 1.3 Strongest exact spectral target

For the exact prime projector, the canonical divisor/character symbol is

\[
\boxed{\frac{P_\chi(s)}{L(s,\chi)}},
\qquad
P_\chi(s)=\sum_p\frac{\chi(p)}{p^s},
\]

not merely `1/L(s,chi)`. The latter belongs to the Möbius rough-sieve/vacuum endpoint. This correction is authoritative.

The same finite-volume boundary admits three simultaneous coordinates:

- additive Fourier frequency;
- multiplicative Dirichlet character;
- factorization charge.

In the coprime divisor sector its phase contains

\[
e\!\left(\frac{r h d^{-1}}e\right),
\]

so Kloosterman/Kuznetsov machinery is structurally forced by the positive-cone CRT boundary, not imported by analogy.

## 1.4 Strongest archimedean target

On each fixed Goldbach diagonal, rational major-arc atoms become high-degree Hahn/Bessel packets. Small denominator does **not** mean low Hahn degree. The singular series is an exact coherent antipodal trace of these rational Bessel beams.

The corrected concentration target is therefore not a scalar low-degree cutoff. It is a **matrix-valued or microlocal Hahn–Heun projector adapted to rational Bessel beams**, with a growing aperture and an inverse theorem classifying any residual parity discrepancy.

---

# 2. Core notation

Use these conventions unless a proof explicitly states otherwise.

- `1_P(n)` or `1_{\mathbb P}(n)`: exact prime indicator.
- `Lambda(n)`: von Mangoldt function. It includes prime powers; never silently identify it with the prime indicator.
- `mu(n)`: Möbius function.
- `lambda(n)=(-1)^{Omega(n)}`: Liouville function.
- `omega(n)`: number of distinct prime factors. Do not confuse it with the Buchstab function, which is written `\omega(u)` when the argument is continuous.
- `Omega(n)`: number of prime factors with multiplicity.
- `P^-(n)`: least prime factor, with the usual convention for `n=1` specified locally.
- `e(x)=e^{2\pi i x}`.
- `phi(q)`: Euler totient.
- `c_q(h)`: Ramanujan sum.
- `mathfrak S(H)`: Hardy–Littlewood singular series for a shift tuple `H`.
- `H={h_1,...,h_k}`: a finite shift tuple.
- `nu_p(H)`: number of distinct residues occupied by the shifts modulo `p`.
- `[d,e]`: least common multiple; `(d,e)`: greatest common divisor.
- `P_X`: projection/cutoff to integers up to `X`, with exact endpoint convention stated in each computation.
- `U_h`: additive translation by `h`.
- `Pi_r`: exact projector onto `Omega=r`.
- `q_r=mu*1_{Omega=r}`: canonical divisor kernel for charge `r`.
- `kappa_r`: same fixed-charge Möbius kernel notation in some source files; in this handoff use `q_r` for operator/join algebra and `kappa_r` when reproducing the smoothed CRT formulas.
- `a_z=mu*(n\mapsto z^{Omega(n)})`: grand-canonical divisor kernel.
- `c_z=mu*u_z`, where `u_z(n)=z^{Omega(n)-1}` for `n>=2` and `u_z(1)=0`: desingularized canonical charge family.
- `P(s)=sum_p p^{-s}`: prime zeta function where convergent or analytically continued with care.
- `P_chi(s)=sum_p chi(p)p^{-s}`: twisted prime zeta function.

---

# 3. Canonical corrections and no-go results

These statements supersede earlier formulations throughout the project.

## 3.1 Full heat-resolved gap data is reconstructive

The claim “the full gap field loses phase” is false when the radial/heat coordinate is retained. Phase loss appears only after radial compression, such as retaining a single circle or only the unweighted correlation.

For a nonnegative sequence, the zero-lag heat trace

\[
C_0(t)=\sum_n a_n^2e^{-2nt}
\]

already determines the coefficients by Laplace-series uniqueness. For finite complex sequences, two complete heat circles determine the sequence up to global phase; one circle plus its radial derivative also suffices.

## 3.2 Full divisibility data determines `Omega`

The claim that the diagonal divisibility algebra is intrinsically blind to factorization charge is false. On integer basis states,

\[
\Omega(n)=\sum_p\sum_{r\ge1}1_{p^r\mid n}.
\]

The real obstruction is finite-scale truncation and cross-scale coherence. At the critical horizon `y=sqrt(X)`, an integer `n<=X` satisfies

\[
\Omega(n)=\Omega_{\le\sqrt X}(n)+\varepsilon_X(n),
\qquad \varepsilon_X(n)\in\{0,1\}.
\]

The unresolved tail is simple-or-zero: one remaining charge bit.

## 3.3 The Möbius endpoint is not the exact prime projector

For the grand-canonical family, `z=0` selects charge zero (`n=1`) and yields the Möbius divisor kernel. Exact primes are the **charge-one coefficient** or the tangent of the desingularized family at `z=0`.

Use `q_1=mu*1_P`, or the twisted symbol `P_chi/L`, for exact prime pairs. Use `mu` and `1/L` only for the rough-sieve/Möbius endpoint.

## 3.4 Goldbach parity and Liouville parity are distinct

- Liouville parity is internal: `(-1)^{Omega(n)}`.
- Hahn parity is external: reflection degree `(-1)^j` on a fixed additive diagonal.

They interact at the prime-pair corner but are not the same grading.

## 3.5 Ordinary complex K-theory cannot detect the Liouville endpoint twist

The Liouville gauge lies in the full prime-indexed gauge torus and is homotopic to the identity. Homotopy invariance makes the induced ordinary complex K-theory map trivial. Do not attempt to encode sieve parity in the endpoint K-class of this gauge twist.

Surviving candidates include graded/equivariant/Real refinements, cyclic cocycles, secondary invariants, eta functions, transfer determinants, spectral flow, Hankel singular spectra, and scattering data.

## 3.6 Prime creation is odd but not a differential

For prime multiplication/creation `C_p|n>=|pn>`, Liouville grading `F` gives

\[
FC_p=-C_pF.
\]

But `C_p^2` is nonzero. Any finite pure-creation sum `Q=sum a_pC_p` satisfies `Q^2=0` only when every coefficient is zero. Exteriorizing the generators forces squarefreeness and naturally produces Möbius, not Liouville occupation parity. Do not force the Buchstab flow into a naive cochain differential.

## 3.7 One PNT-centered tensor square does not center both sums and gaps

Subtracting Lebesgue/PNT background from `Lambda` naturally centers additive Goldbach sums. Under difference pushforward, the integer gap atoms remain the raw `Lambda(n)Lambda(n+h)` weights while the reference terms are absolutely continuous. The Hardy–Littlewood gap baseline is not removed. This failure is structural.

## 3.8 Fixed angular channels cannot solve the sharp problem

Every fixed Hahn multipole sees only PNT-scale background, and any fixed finite band captures a vanishing fraction of the von Mangoldt energy. The angular aperture must grow with `N`.

## 3.9 Generic log-concavity of raw Hahn energies is false

~~Numerical tests falsify~~ the proposed generic Huh/log-concavity statement for raw squared Hahn coefficients ~~is not currently disproved to this repository's standard~~. Hodge machinery must enter before squaring/projecting, through the collision arrangement, or through another structured object. Do not revive raw-energy log-concavity without a new hypothesis.

> **Correction (seed121 audit, 2026-08-14).** The *conclusion* here is very
> likely right, but the *warrant* is inadmissible under `CLAUDE.md`. A
> falsification is the one kind of claim that needs no measurement at all: a
> single explicit triple of Hahn indices with exact rational (or exact
> algebraic) coefficients violating `a_j^2 >= a_{j-1}a_{j+1}` settles it
> forever, and such a witness is a mathematical object rather than a run.
> "Numerical tests falsify" is a floating-point statement about a strict
> inequality — precisely the case where round-off can manufacture the sign.
> **Action:** downgrade §3.9 and §17.12 from *false* to *unresolved pending an
> exact witness* until one triple `(N, j-1, j, j+1)` is exhibited with its
> coefficients in closed form. No claim of this note depends on the outcome,
> so the downgrade costs nothing. (I did not attempt the witness; I make no
> claim that log-concavity holds.)

## 3.10 One-body Xi/Meixner–Pollaczek expansions are prior art

The project’s live spectral object is the **two-body beta/Hahn tensor transform**, not a claim that expanding Xi in Meixner–Pollaczek polynomials is new.

---

# 4. Pair field, sum/gap projections, and reconstruction

## 4.1 Exact pair-field identities

For a sequence `a_n`, define

\[
K(w,d)=a_{w-d}a_{w+d}.
\]

On two copies of the number operator, set

\[
S=N_1+N_2,\qquad D=N_2-N_1,\qquad Q=N_1N_2.
\]

Then

\[
\boxed{S^2-D^2=4Q.}
\]

This is an exact coordinate identity, not evidence of a hidden Lorentz dynamics.

For

\[
P(t)=\sum_na_ne^{-nt},
\]

define

\[
Z(t,\theta)
=\sum_{m,n}a_ma_ne^{-t(m+n)}e^{i\theta(n-m)}
=P(t+i\theta)P(t-i\theta).
\]

The `S` projection is additive-sum/Goldbach information. The `D` projection is difference/gap information.

For compressed representation functions

\[
R(s)=\sum_{m+n=s}a_ma_n,
\qquad
C(h)=\sum_na_na_{n+h},
\]

with generating Fourier series `A(theta)`,

\[
\widehat R(\theta)=A(\theta)^2,
\qquad
\widehat C(\theta)=|A(\theta)|^2.
\]

Thus the compressed gap channel knows the modulus of the Goldbach transform but not its analytic phase.

## 4.2 Two heat scales restore finite phase

Let

\[
A(z)=\sum_{n=0}^da_nz^n.
\]

The complete heat-weighted autocorrelation at `t`, with `r=e^{-t}`, is exactly the boundary modulus `|A(re^{i\theta})|^2`. If two finite polynomials have equal moduli on two distinct concentric circles, their quotient is unimodular on both circles and must be a unimodular constant. Hence two complete heat slices determine a finite complex sequence up to global phase.

Equivalently, one complete slice plus the normal derivative suffices. If

\[
C_a(h;t)=\sum_na_{n+h}\overline{a_n}e^{-t(2n+h)},
\]

then

\[
-\partial_tC_a(h;t)
=\sum_n(2n+h)a_{n+h}\overline{a_n}e^{-t(2n+h)}.
\]

The derivative supplies the missing radial Cauchy datum.

## 4.3 Injectivity without stability is nearly vacuous

For binary digits `a_0,...,a_N` and `0<q<1/2`, the single scalar

\[
M_q(a)=\sum_{n=0}^Na_nq^n
\]

is injective, with separation

\[
|M_q(a)-M_q(b)|\ge q^N\frac{1-2q}{1-q}.
\]

This encodes the whole finite binary object in one real number but has inverse condition number at least `q^{-N}`. It is mathematically exact and analytically useless at arithmetic scales.

For a coefficient at index `N`, data on `|z|=r<1` suppresses the perturbation by `r^N`. Polynomially conditioned inversion requires

\[
r^N\gtrsim N^{-C},
\qquad r=e^{-t},
\]

so

\[
\boxed{t\lesssim C\frac{\log N}{N}.}
\]

Stable recovery forces the heat circles toward the sharp boundary at near-`1/N` scale.

## 4.4 Toeplitz/Hankel decomposition and the positive cone

For a bilateral matrix `K`, define diagonal and anti-diagonal Radon transforms

\[
(\mathcal TK)(h)=\sum_nK_{n+h,n},
\qquad
(\mathcal HK)(N)=\sum_nK_{N-n,n}.
\]

Let `J` reflect one leg. Then

\[
\boxed{\mathcal HK=\mathcal T(KJ).}
\]

On the bilateral line, sums and differences are exactly equivalent after reflection. On the Hardy positive cone, reflection crosses the polarization `H_+` to `H_-`; the mixed block is Hankel. The Goldbach information missing from a gap/Toeplitz symbol is therefore an off-diagonal Hankel completion.

For `A=IO` in inner–outer factorization, the gap symbol `|A|^2` determines the outer factor up to phase but is blind to the inner factor; Goldbach retains `A^2` and hence `I^2`.

## 4.5 One-circle ambiguity and AAK obstruction

If polynomials `A,B` have equal modulus on the unit circle, then after cancelling common factors

\[
R(z)=\frac{B(z)}{A(z)}
\]

is a rational all-pass function. Its Hardy Hankel block

\[
H_R=P_-M_RP_+
\]

has finite rank equal to the McMillan degree of the antianalytic rational defect. The two ranks

\[
\delta(A,B)=\bigl(\operatorname{rank}H_R,
\operatorname{rank}H_{\overline R}\bigr)
\]

retain more information than the winding number, which sees only their difference.

AAK singular values refine rank into a quantitative stability spectrum. They are the natural obstruction data for near-homometry, noisy phase completion, and quasi-inner arithmetic systems.

Connes–Consani quasi-inner functions use exactly the Hardy block language: compactness of `(1-P)uP` is a Hankel condition, and the complementary block defines a Sonin space. A precise project target is to construct an arithmetic transfer function `u_H` for which the diagonal/Toeplitz block gives local or gap data, the off-diagonal Hankel block carries the Goldbach phase/positive-cone lift, and its canonical-system realization matches the verified one-zero screw kernel. No such `u_H` has been constructed.

## 4.6 Canonical homometric test pair

The minimal pair used throughout the program is

\[
A_0=\{0,1,2,6,8,11\},
\qquad
B_0=\{0,1,6,7,9,11\}.
\]

Its generating polynomials factor as

\[
P_A=(x^2+1)(x^4+x+1)(x^5-x^3+1),
\]

\[
P_B=(x^2+1)(x^4+x+1)(x^5-x^2+1).
\]

The differing factors are reciprocal, so `P_B/P_A` is all-pass. Exact Routh analysis gives

\[
\operatorname{rank}H_R=2,
\qquad
\operatorname{rank}H_{\overline R}=3,
\qquad
\operatorname{wind}R=1.
\]

The singular spectra have the exact shape

\[
\operatorname{sing}(H_R)=\{\sigma_1,\sigma_2\},
\qquad
\operatorname{sing}(H_{\overline R})=\{1,\sigma_1,\sigma_2\}.
\]

A finite-section computation found

\[
\sigma_1\approx0.977147971,
\qquad
\sigma_2\approx0.899663554.
\]

By the cosine–sine decomposition of the block multiplication unitary, every singular value strictly between zero and one occurs in a matched pair across the two Hankel defects; rank imbalance is carried only by excess singular values equal to one. Thus only the excess unit mode is topological/index data, while the paired fractional singular values carry the non-topological phase geometry.

---
# 5. Laplace–Mellin, centered Goldbach fields, and the zeta spectrum

## 5.1 Exact additive–multiplicative bridge

For the von Mangoldt sequence,

\[
P(t)=\sum_{n\ge1}\Lambda(n)e^{-nt}.
\]

Its Mellin transform is

\[
\boxed{
\int_0^\infty P(t)t^{s-1}\,dt
=\Gamma(s)\left(-\frac{\zeta'(s)}{\zeta(s)}\right).
}
\]

This is the clean exact bridge between additive heat analysis and multiplicative Dirichlet analysis.

Tensoring the explicit formula generates sums over pairs of zeta zeros. That phenomenon and Goldbach Mellin–Barnes formulas with zero sums are known prior art; do not claim novelty for “zero pairs appear after squaring the explicit formula.” Relevant established lines include Egami–Matsumoto, Bhowmik–Schlage-Puchta, Languasco–Zaccagnini, and Brüdern–Kaczorowski–Perelli.

## 5.2 Centered two-body distribution

Let

\[
\mu_\Lambda=\sum_{n\ge1}\Lambda(n)\delta_n,
\qquad
\lambda_0=1_{[1,\infty)}dx,
\qquad
\xi=\mu_\Lambda-\lambda_0.
\]

Then `Xi=xi tensor xi` is a rigorous centered two-body distribution. The additive pushforward has a discrete Goldbach part and explicit continuous one-body/background terms. A more canonical spectral centering uses the completed-zeta logarithmic derivative

\[
F(s)=M(s)-A_\infty(s)=-\frac{\xi_R'(s)}{\xi_R(s)}.
\]

The tensor product splits into:

1. main/archimedean sector;
2. one-zero cross sector;
3. two-zero sector.

## 5.3 Matsumoto–Suzuki placement

Matsumoto–Suzuki’s `H_1` is the normalized residue field of the **one-zero cross sector** in the Goldbach projection. Their screw kernel is equivalent to RH and, under RH, becomes a positive Gram kernel indexed by zero ordinates.

This is a strong rigorous bridge but it does not automatically control the quadratic two-zero sector or prove Goldbach positivity. There is no free complete-positivity theorem transferring one-zero screw positivity to the pair sector.

## 5.4 One prime object, two commuting energies

Let `V_P` have one basis vector `|p>` for each prime. Define commuting one-particle operators

\[
A|p\rangle=p|p\rangle,
\qquad
H|p\rangle=(\log p)|p\rangle,
\qquad A=e^H.
\]

On bosonic Fock space, with particle-number fugacity `z`, define

\[
\boxed{
\mathcal Z(z;t,s)
=\prod_p\left(1-ze^{-tp}p^{-s}\right)^{-1}.
}
\]

Specializations:

- `t=0,z=1` gives `zeta(s)`;
- the ordered two-particle coefficient contains `P_s(t)^2`, where
  \[
  P_s(t)=\sum_pp^{-s}e^{-tp};
  \]
- its additive-energy coefficient at `N` counts ordered prime pairs with sum `N`.

Thus zeta and Goldbach are two observables of one prime one-particle object:

- zeta is the grand-canonical partition function for logarithmic/multiplicative energy;
- Goldbach is a two-particle microcanonical slice for additive energy.

The exact bosonic Euler product contains prime-power cycle corrections:

\[
\log\mathcal Z(z;t,s)
=\sum_{r\ge1}\frac{z^r}{r}\sum_pe^{-trp}p^{-rs}.
\]

The continuum Buchstab semigroup is Poisson/Maxwell–Boltzmann in factor-log space; the `r>=2` cycle terms are the discrete prime-power correction to that continuum Poissonization.

## 5.5 Hirzebruch/Todd packaging: exact identities, interpretive status limited

The canonical state records exact local identities placing zeta and Hardy–Littlewood factors into Hirzebruch/Todd-style characteristic factors. One useful family is

\[
Q_y(x)=x\frac{1+ye^{-x}}{1-e^{-x}}.
\]

With `x_p=s\log p`,

\[
\frac{Q_0(x_p)}{x_p}=\frac1{1-p^{-s}},
\qquad
\zeta(s)=\prod_p\frac{Q_0(x_p)}{x_p}.
\]

More generally,

\[
\boxed{
Z_y(s)=\prod_p\frac{1+yp^{-s}}{1-p^{-s}}
=\prod_p\frac{Q_y(x_p)}{x_p}
=\sum_{n\ge1}\frac{(1+y)^{\omega(n)}}{n^s}.
}
\]

Thus `y=0` gives `zeta(s)`, `y=1` gives `zeta(s)^2/zeta(2s)`, and `y=-1` collapses to one. The Liouville eta factor is the ratio

\[
\frac{Q_0(x)}{Q_1(x)}=\frac1{1+e^{-x}},
\qquad
\prod_p\frac{Q_0(x_p)}{Q_1(x_p)}
=\frac{\zeta(2s)}{\zeta(s)}.
\]

The Hardy–Littlewood local tuple factor has the exact inhomogeneous characteristic-factor form

\[
\boxed{
\frac{1-\nu_p(H)/p}{(1-1/p)^k}
=\frac{Q_{-\nu_p(H)}(\log p)}{\log p}
\left(\frac{Q_0(\log p)}{\log p}\right)^{k-1}.
}
\]

The formulas are exact. The interpretation as a useful global genus is conjectural, because the local parameter `-nu_p(H)` varies with `p`; ordinary index language does not remove the parity obstruction.

A related established BC/spectral-triple identity is the Liouville-twisted eta/Dirichlet series

\[
\sum_{n\ge1}\frac{\lambda(n)}{n^\beta}
=\frac{\zeta(2\beta)}{\zeta(\beta)}.
\]

This is real prior art. It packages occupation parity spectrally but does not provide an odd supercharge or a prime-pair index theorem.

---

# 6. Finite-adic local equilibrium, criticality, and the positive boundary

## 6.1 Critical Bost–Connes/Cuntz sieve field

Let

\[
\widehat{\mathbb Z}=\prod_p\mathbb Z_p
\]

with additive Haar probability. For a finite prime set `F`, define

\[
e_F(x)=\prod_{p\in F}1_{\mathbb Z_p^\times}(x_p).
\]

The normalized two-point correlation is

\[
C_F(h)=\frac{\mu(e_F\tau_he_F)}{\mu(e_F)^2}.
\]

For an admissible shift, as `F` exhausts the primes,

\[
C_F(h)\longrightarrow\mathfrak S(h).
\]

For a `k`-tuple of shifts,

\[
C_F(H)=\prod_{p\in F}
\frac{1-\nu_p(H)/p}{(1-1/p)^k}
\longrightarrow\mathfrak S(H).
\]

This is an exact operator/KMS packaging of the classical local-density product. It computes finite-adic equilibrium, not prime occurrence on the positive integers.

## 6.2 Criticality proposition E0

For the BC `KMS_beta` local measure, the normalized local factor satisfies

\[
\log L_{\beta,p}(H)
=(k-1)(p^{-\beta}-p^{-1})+O(p^{-2}+p^{-2\beta}).
\]

Hence the normalized infinite correlation is finite and nonzero exactly at

\[
\boxed{\beta=1.}
\]

More precisely:

\[
\beta<1:\ \infty,
\qquad
\beta=1:\ \mathfrak S(H),
\qquad
\beta>1:\ 0.
\]

> **Flag (seed121 audit, 2026-08-14).** The trichotomy *does* follow from the
> displayed expansion — `sum_p (p^{-beta} - p^{-1})` diverges to `+inf` for
> `beta<1`, vanishes termwise at `beta=1`, and diverges to `-inf` for
> `beta>1` — so the boxed conclusion is internally sound. But the expansion is
> load-bearing and its derivation is nowhere in this document, and it is
> **not** what the naive Haar-style local factor gives. If one takes
> `L_{beta,p}(H) = (1-nu_p(H)p^{-beta})/(1-p^{-beta})^k` normalized against
> its own `beta=1` value, then for admissible `H` and all but finitely many
> `p` one has `nu_p(H)=k`, the first-order terms cancel identically, and
>
> ```text
> log L = -k(k-1)/2 · (p^{-2beta} - p^{-2}) + O(p^{-3beta}),
> ```
>
> which is summable for every `beta > 1/2`. That version of the statement has
> **no** critical point at `beta=1`: the correlation would be finite and
> nonzero on the whole half-line `beta>1/2`. So the criticality of `beta=1` is
> a genuine consequence of the Bost–Connes KMS normalization being *unlike*
> the Haar factor, not of the profinite geometry. Proposition E0 should not be
> quoted until the BC local factor is written out here explicitly; as it
> stands a reader can reconstruct only the false version.

The Hardy–Littlewood singular series is therefore a genuine critical phenomenon in this normalization.

## 6.3 Finite-size critical window

Set

\[
\beta_z=1+\frac{\lambda}{\log z}.
\]

The library derives the crossover

\[
\frac{C_{\beta_z,z}(H)}{C_{1,z}(H)}
\longrightarrow
\exp\left((k-1)\int_0^1\frac{e^{-\lambda u}-1}{u}\,du\right).
\]

The tuple geometry enters only through the critical amplitude `mathfrak S(H)` and the number of legs `k`. This is a novelty candidate; prior art must be checked before any claim.

## 6.4 Addition and multiplication force the critical temperature

In the arithmetic `ax+b` algebra, the residue partition relation

\[
\sum_{j=0}^{n-1}u^je_nu^{-j}=1
\]

and multiplicative KMS dynamics give `omega(e_n)=n^{-beta}`, while additive translation invariance forces `n omega(e_n)=1`. Therefore `beta=1`.

This is the exact balance between additive residue entropy and multiplicative dilation energy.

## 6.5 Ramanujan spectrum

For squarefree primorial `M`, let

\[
g_M(x)=\frac{M}{\varphi(M)}1_{(x,M)=1}.
\]

Its primitive-denominator Fourier amplitude at `q|M` is

\[
\frac{\mu(q)}{\varphi(q)}.
\]

The prime-pair singular series has the classical Ramanujan expansion

\[
\boxed{
\mathfrak S(h)
=\sum_{q\ge1}\frac{\mu(q)^2}{\varphi(q)^2}c_q(h).
}
\]

The distinction matters:

- local sieve **amplitudes** carry coherent `mu(q)/phi(q)` signs;
- pair **intensities** square them to `mu(q)^2/phi(q)^2`.

Gadiyar–Padma and related Ramanujan/Wiener–Khintchine work are prior art for the spectral identity. The BC/KMS sieve-projection placement is the project’s synthesis candidate.

The coherent multiplicative transform of the signed amplitudes is

\[
\boxed{\sum_{q\ge1}\frac{\mu(q)}{q^s}=\frac1{\zeta(s)}}.
\]

This sharpens the amplitude/intensity split:

- coherent signed spectrum leads to `1/zeta` and is zero-sensitive;
- squared two-point intensity leads to the singular series and local pair density.

This is a structural formulation of the sieve parity loss, not a proof that recovering the coherent phase is sufficient.

## 6.6 Binary/ternary smoothing threshold

The one-leg local field is singular. Its two-fold convolution has Fourier coefficients at the `l^2` threshold but not generally `l^1`. For `k>=3`, the relevant Ramanujan coefficients become absolutely summable:

\[
\sum_q\frac{\mu(q)^2}{\varphi(q)^{k-1}}<\infty.
\]

This yields an exact finite-place smoothing distinction:

- one prime: singular measure;
- two primes: `L^2`-type boundary;
- three or more: continuous/bounded local convolution.

The library’s conjectural meta-principle is that the historical binary/ternary Goldbach gap may be the same smoothing threshold appearing at finite and archimedean places. This is not a theorem about Goldbach.

## 6.7 Goldbach and gaps are locally identical

At every finite prime, the substitution `y=-x` maps

\[
x\in\mathbb Z_p^\times,
\quad N-x\in\mathbb Z_p^\times
\]

to

\[
y\in\mathbb Z_p^\times,
\quad y+N\in\mathbb Z_p^\times.
\]

The equality persists for the full charge-deformed local integral, not only at the sieve endpoint. The difference between Goldbach and gaps is therefore archimedean/positive-cone, not finite-adic local density.

On signed integers, reflection converts sum to difference. For the symmetrized prime indicator,

\[
r_{\mathrm{sym}}(N)
=r_{\mathrm{Goldbach}}(N)+2c_{\mathrm{gap}}(N).
\]

Its positivity is weaker than Goldbach: every even `N` is a sum **or difference** of two primes.

## 6.8 Boundary quotient versus Toeplitz lift

The clean translation-invariant arithmetic algebra is a boundary quotient of a concrete semigroup/Toeplitz algebra on `ell^2(N)`. Quotienting by compact/boundary effects produces exact translation invariance and finite-adic equilibrium. The concrete lift remembers:

- the positive boundary;
- finite intervals;
- endpoint discrepancy;
- off-diagonal Hankel information.

Hence:

- the singular series belongs naturally to the quotient/equilibrium layer;
- prime conjectures are boundary-sensitive lifting problems.

## 6.9 Exact finite sieve projection

For a finite set of local forbidden residues, multiply the corresponding affine residue projections into `E_{H,z}`. Then

\[
\operatorname{Tr}(P_XE_{H,z})
\]

is exactly the count of integers in the interval whose shifted forms have no prime factor up to `z`, whereas the critical quotient trace is exactly

\[
X\prod_{p\le z}\left(1-\frac{\nu_p(H)}p\right).
\]

The ratio

\[
\mathcal B_H(X,z)
=\frac{\operatorname{Tr}(P_XE_{H,z})}{X\tau(E_{H,z})}
\]

measures actual positive-integer arithmetic divided by finite-adic equilibrium.

Actual primality is a moving-scale adelic observable. For `n>=2`,

\[
\boxed{
1_{\mathbb P}(n)
=\prod_{p^2\le n}(1-1_{p\mid n}).
}
\]

Finite coordinates provide divisibility, while the real coordinate provides the moving cutoff `p<=sqrt(n)`. This is why a static profinite equilibrium field can produce the singular series but not exact primes.

## 6.10 Buchstab boundary renormalization

For one integer, write `z=X^{1/u}`. Rough-number counting gives

\[
\Phi(X,z)\sim\frac{X\omega(u)}{\log z},
\]

whereas critical KMS/Mertens equilibrium predicts `e^{-gamma}X/log z`. Therefore

\[
\boxed{\mathcal B_{\{0\}}(u)=e^\gamma\omega(u).}
\]

As `u->infinity`, this tends to one. At the prime stopping horizon `u=2`, it equals `e^gamma/2`.

## 6.11 Many-body boundary factorization conjecture

After dividing the actual rough-tuple count by

1. its exact finite-adic local density;
2. each one-body Buchstab boundary factor,

define the connected interaction `kappa_H` or free energy `Gamma_H=log kappa_H`. The master conjecture is

\[
\boxed{\kappa_H(\mathbf u)\to1}
\qquad\text{or}\qquad
\boxed{\Gamma_H(\mathbf u)\to0.}
\]

Equivalently, the free solution would be

\[
B_H(\mathbf u)
\stackrel{?}=e^{k\gamma}\prod_i\omega(u_i).
\]

At `u_i=2`, this is equivalent to Hardy–Littlewood prime tuples after the singular series is removed. Moderate-scale experiments reported connected ratios within roughly `0.2%` of one for several gaps and asymmetric sieve depths. This is numerical evidence only.

---
# 7. Factorization charge, Buchstab flow, and canonical prime projection

## 7.1 Charge completes the two-leg arithmetic state

For two integers `m,n>=2`, both are prime exactly when

\[
\Omega(m)+\Omega(n)=2.
\]

Thus a Goldbach event and a fixed-gap prime-pair event can be written respectively as

\[
S=N,\quad C_{\mathrm{tot}}=2,
\]

and

\[
D=h,\quad C_{\mathrm{tot}}=2.
\]

The coordinate identity `S^2-D^2=4Q` continues to relate additive and multiplicative geometry, while the charge coordinate distinguishes primes from composites on the same hyperbola.

## 7.2 Exact charge-deformed Buchstab recursion

For complex `z`, define the desingularized rough-charge sum

\[
R_z(x,y)
=\sum_{\substack{2\le n\le x\\P^-(n)>y}}
z^{\Omega(n)-1}.
\]

Least-prime-factor peeling gives the exact identity

\[
\boxed{
R_z(x,y)
=\pi(x)-\pi(y)
+z\sum_{y<p\le\sqrt x}R_z(x/p,p).
}
\]

The corresponding continuum delay family is

\[
\omega_z(u)=0\quad(u<1),
\]

\[
\omega_z(u)=\frac1u\quad(1\le u\le2),
\]

\[
\boxed{(u\omega_z(u))'=z\omega_z(u-1).}
\]

Special values:

- `z=1`: ordinary Buchstab flow;
- `z=-1`: the sign-reversed Liouville/parity mode;
- derivatives at `z=0`: fixed-charge generators.

## 7.3 Laplace solution and convolution semigroup

Let

\[
W_z(s)=\int_1^\infty e^{-su}\omega_z(u)\,du,
\qquad
E_1(s)=\int_s^\infty\frac{e^{-t}}t\,dt.
\]

Boundary accounting gives

\[
\boxed{1+zW_z(s)=\exp(zE_1(s)).}
\]

Define the locally finite measure

\[
\mu_z^{\mathrm B}=\delta_0+z\omega_z(u)\,du.
\]

Then

\[
\mathcal L\mu_z^{\mathrm B}=e^{zE_1(s)},
\qquad
\boxed{\mu_{z_1}^{\mathrm B}*\mu_{z_2}^{\mathrm B}=\mu_{z_1+z_2}^{\mathrm B}.}
\]

Equivalently,

\[
\mu_z^{\mathrm B}=\exp_*(zf),
\qquad
f(u)=1_{u\ge1}\frac{du}{u}.
\]

The ordinary flow is `mu_1`; the Liouville mode is its convolution inverse `mu_{-1}`.

After exponential tilting and normalization, this becomes an infinitely divisible law with Lévy density proportional to `z e^{-s_0u}du/u`.

## 7.4 Exact Walsh reconstruction in the first nontrivial Buchstab window

If

\[
y>X^{1/3},
\]

then every `y`-rough integer `n<=X` has `Omega(n)` equal to one or two. On this sector,

\[
\boxed{1_{\mathbb P}(n)=\frac{1-\lambda(n)}2.}
\]

For `k` affine forms in the same window,

\[
\prod_{i=1}^k1_{\mathbb P}(L_i(n))
=2^{-k}\sum_{J\subseteq[k]}(-1)^{|J|}
\prod_{j\in J}\lambda(L_j(n)),
\]

with roughness indicators understood. Thus removing semiprime contamination is exactly equivalent to controlling all nontrivial Walsh parity sectors in this window.

## 7.5 Grand-canonical fugacity

The factorization partition function is

\[
\boxed{
F(z,s)
=\sum_{n\ge1}\frac{z^{\Omega(n)}}{n^s}
=\prod_p(1-zp^{-s})^{-1}.
}
\]

Its charge-one coefficient is the prime zeta function:

\[
[z]F(z,s)=P(s)=\sum_pp^{-s}.
\]

Specializations:

\[
F(1,s)=\zeta(s),
\qquad
F(-1,s)=\frac{\zeta(2s)}{\zeta(s)}.
\]

On occupation coordinates,

\[
H=\log N=\sum_pv_p\log p,
\qquad
C=\Omega(N)=\sum_pv_p,
\]

and `Tr(z^Ce^{-sH})=F(z,s)`.

## 7.6 Shifted charge field and the prime boundary layer

For a shift tuple `H={h_1,...,h_k}`, define

\[
Z_{H,X}(z_1,\ldots,z_k)
=\sum_{n\le X}\prod_i z_i^{\Omega(n+h_i)-1}.
\]

Assuming every form value is at least two,

\[
\boxed{Z_{H,X}(0,\ldots,0)
=\#\{n\le X:n+h_i\text{ prime for all }i\}.}
\]

More generally, the coefficient of `prod z_i^{r_i-1}` counts the fixed-charge stratum `Omega(n+h_i)=r_i`.

The saddle for fixed charge `r` lies at magnitude

\[
|z|\asymp\frac r{\log\log X}.
\]

Exact primes live in an `X`-dependent radial boundary layer approaching zero. This explains why estimates on unit-modulus multiplicative phases do not automatically reach prime precision: they control angular behavior near `|z|=1`, while primes require radial penetration toward zero.

## 7.7 Conjectural shifted/parallel-form Selberg–Delange family

For primitive affine forms, define the local factor

\[
A_H(\mathbf z)
=\prod_p(1-p^{-1})^{\sum_i z_i-k}
\int_{\mathbb Z_p}\prod_i z_i^{v_p(L_i(x))}\,dx.
\]

Generic `p^{-1}` terms cancel, suggesting holomorphy near both `z=0` and `z=1`. The master conjecture is

\[
\boxed{
Z_{H,X}(\mathbf z)
\sim
X(\log X)^{\sum_i(z_i-1)}
\frac{A_H(\mathbf z)}{\prod_i\Gamma(1+z_i)}.
}
\]

Endpoint checks:

- `z_i=1`: bulk count `X`;
- `z_i=0`: Hardy–Littlewood prime tuples;
- derivatives near one: joint Sathe–Selberg/Erdős–Kac cumulants;
- negative integers: zeros of `1/Gamma(1+z)` suppress ordinary main terms in parity-like sectors.

Standard Green–Tao/Matthiesen linear-correlation theorems typically require independent or nonparallel linear parts. The project needs the degenerate **shifted/parallel-form** geometry `n+h_i`, uniformly as `z` approaches zero.

## 7.8 Universal low-charge prediction

Let

\[
L=\log\log X,
\qquad
z_i=\frac{\lambda_i}{L}.
\]

The predicted boundary layer is

\[
\boxed{
Z_{H,X}(\lambda_1/L,\ldots,\lambda_k/L)
\sim
\mathfrak S(H)\frac{X}{(\log X)^k}
\exp\left(\sum_i\lambda_i\right).
}
\]

At `lambda_i=0`, this is the prime-tuple asymptotic. Coefficient extraction gives a Poisson-like fixed-charge tower.

## 7.9 Normal-family rigidity meta-theorem

Normalize

\[
\mathcal F_X(\boldsymbol\lambda)
=
\frac{(\log X)^k}{\mathfrak S(H)X}
Z_{H,X}\left(\frac{\lambda_1}{L},\ldots,
\frac{\lambda_k}{L}\right).
\]

Suppose:

1. `mathcal F_X` is locally uniformly bounded on every compact polydisc in a connected domain containing zero;
2. on a product of nonempty real intervals, `mathcal F_X -> exp(sum lambda_i)`.

Then Montel/Vitali and the several-variable identity theorem give local uniform convergence throughout the domain, including zero. Consequently the prime-tuple asymptotic and every fixed almost-prime stratum follow.

The hard estimate is not supplied by complex analysis. The meta-theorem identifies exactly what positive-real boundary-layer upper bounds and interior convergence would suffice.

## 7.10 Grand-canonical divisor kernel

Define multiplicatively

\[
a_z(1)=1,
\qquad
a_z(p^r)=(z-1)z^{r-1}.
\]

Then

\[
\boxed{z^{\Omega(n)}=\sum_{d\mid n}a_z(d),}
\]

and

\[
\sum_d\frac{a_z(d)}{d^s}
=\frac{F(z,s)}{\zeta(s)}
=\prod_p\frac{1-p^{-s}}{1-zp^{-s}}.
\]

At `z=1`, only `d=1` remains. At `z=0`, `a_0=mu`, but this is the charge-zero/Möbius endpoint, not exact primes.

## 7.11 Canonical fixed-charge kernels

Let

\[
\pi_r(n)=1_{\{\Omega(n)=r\}},
\qquad
q_r=\mu*\pi_r.
\]

Then

\[
\pi_r=1*q_r.
\]

For primes,

\[
\boxed{q_1(n)=\sum_{p\mid n}\mu(n/p).}
\]

This kernel is sparse and nonmultiplicative.

The twisted fixed-charge Dirichlet symbol is

\[
\boxed{
K_{r,\chi}(s)
=\sum_n\frac{q_r(n)\chi(n)}{n^s}
=\frac{Z_{r,\chi}(s)}{L(s,\chi)},
}
\]

where

\[
Z_{r,\chi}(s)=[z^r]F_\chi(z,s).
\]

For exact primes,

\[
\boxed{K_{1,\chi}(s)=\frac{P_\chi(s)}{L(s,\chi)}.}
\]

## 7.12 Symmetric-power hierarchy

For

\[
F_\chi(z,s)=\prod_p(1-z\chi(p)p^{-s})^{-1},
\]

one has

\[
\log F_\chi(z,s)
=\sum_{j\ge1}\frac{z^j}{j}P_{\chi^j}(js).
\]

Thus

\[
Z_{1,\chi}=P_\chi(s),
\]

\[
Z_{2,\chi}
=\frac12\left(P_\chi(s)^2+P_{\chi^2}(2s)\right),
\]

and the Newton recurrence

\[
\boxed{
rZ_{r,\chi}(s)
=\sum_{j=1}^rP_{\chi^j}(js)Z_{r-j,\chi}(s).
}
\]

The fixed-charge tower is an exact symmetric-power hierarchy over the one-prime spectrum.

## 7.13 Join/LCM convolution and exact charge idempotents

Define

\[
(f\vee g)(n)
=\sum_{\operatorname{lcm}(d,e)=n}f(d)g(e),
\]

and the divisor-zeta transform

\[
(\mathcal Zf)(n)=\sum_{d\mid n}f(d).
\]

Then

\[
\boxed{\mathcal Z(f\vee g)=(\mathcal Zf)(\mathcal Zg).}
\]

Since the pointwise projectors `pi_r` are orthogonal,

\[
\boxed{q_r\vee q_s=\delta_{rs}q_r,}
\qquad
\boxed{\sum_{r\ge0}q_r=\delta_1}
\]

as a locally finite formal identity.

The fugacity kernels decompose spectrally:

\[
a_z=\sum_{r\ge0}z^rq_r,
\qquad
\boxed{a_z\vee a_w=a_{zw}.}
\]

For the desingularized family

\[
c_z=\sum_{r\ge1}z^{r-1}q_r,
\qquad c_0=q_1,
\]

its Dirichlet series is

\[
\boxed{
C_z(s)=\sum_d\frac{c_z(d)}{d^s}
=\frac{F(z,s)-1}{z\zeta(s)},
}
\]

with removable value

\[
\boxed{C_0(s)=\frac{P(s)}{\zeta(s)}}.
\]

It likewise obeys

\[
\boxed{c_z\vee c_w=c_{zw}.}
\]

On `ell^2(N)`, divisibility projections satisfy

\[
E_dE_e=E_{[d,e]},
\]

and

\[
\boxed{
\Pi_r=\sum_{d\ge1}q_r(d)E_d,
\qquad
\Pi_r\Pi_s=\delta_{rs}\Pi_r.
}
\]

For `0<=z<=1`, the analytic charge family

\[
G(z)=\sum_{r\ge1}z^{r-1}\Pi_r
\]

satisfies

\[
G(0)=\Pi_1,
\qquad
\|G(z)-\Pi_1\|=z.
\]

Additive translation is where these exact LCM-spectral sectors mix.

## 7.14 Distinct-prime charge versus repeated-prime charge

The divisor-lattice characteristic polynomial is

\[
\Phi_n(t)
=\sum_{d\mid n}\mu(n/d)t^{\Omega(d)}
=t^{\Omega(n)-\omega(n)}(t-1)^{\omega(n)}.
\]

This splits factorization into

\[
R(n)=\Omega(n)-\omega(n)
\]

(repeated-prime charge) and

\[
W(n)=\omega(n)
\]

(distinct-prime charge).

A two-fugacity Dirichlet series is

\[
F(u,v;s)
=\prod_p\frac{1+(v-u)p^{-s}}{1-up^{-s}}.
\]

Only distinct-prime charge controls the critical singular exponent; repeated-prime charge contributes an analytic prime-power correction. This is useful for separating the genuinely critical squarefree structure from lower-order repeated-factor effects.

---
# 8. Local Igusa geometry, Walsh heat flow, and categorical factorization

## 8.1 Exact multivariate local charge integral

For shifts `H={h_1,...,h_k}` and normalized Haar measure on `Z_p`, define

\[
\boxed{
I_{p,H}(\mathbf z)
=\int_{\mathbb Z_p}\prod_{i=1}^kz_i^{v_p(n+h_i)}\,dn.
}
\]

With `z_i=p^{-s_i}`, this is the multivariate Igusa local zeta integral for the linear divisors `n+h_i`:

\[
I_{p,H}(p^{-s_1},\ldots,p^{-s_k})
=\int_{\mathbb Z_p}\prod_i|n+h_i|_p^{s_i}\,dn.
\]

The parity point `z_i=-1` is a specialization of the resulting rational function in the formal Igusa variables.

## 8.2 Collision-tree recursion

Partition the indices into clusters `C` according to equality of `h_i mod p`. Let `a_C` be the common residue in a cluster, set

\[
H_C'=\{(h_i-a_C)/p:i\in C\},
\qquad
z_C=\prod_{i\in C}z_i.
\]

Then

\[
\boxed{
I_{p,H}(\mathbf z)
=1-\frac{\nu_p(H)}p
+\frac1p\sum_Cz_CI_{p,H_C'}(\mathbf z_C).
}
\]

The full local factor depends only on the ultrametric collision dendrogram, equivalently the hierarchy of valuations `v_p(h_i-h_j)`.

For a singleton,

\[
I_{p,\{0\}}(z)=\frac{p-1}{p-z}.
\]

When all `k` shifts are distinct modulo `p` and `a_i=1-z_i`, the normalized local factor has the closed form

\[
A_{p,H}(\mathbf z)
=1-\sum_{r=2}^k\frac{(r-1)e_r(a_1,\ldots,a_k)}{(p-1)^r}.
\]

The `1/p` term cancels exactly, so generic interactions begin at `p^{-2}`. Exceptional geometry is confined to collision primes.

For the normalized finite-adic charge martingale, the library derives the moment exponent

\[
\boxed{
\tau_r(z)=r(1-\operatorname{Re}z)+|z|^r-1.
}
\]

This gives an exact multifractal/intermittency diagnostic for the charge-deformed local field. Its relevance to the positive-cone prime boundary remains conjectural.

## 8.3 Exact two-leg factor at every collision depth

For shifts `{0,h}` and `a=v_p(h)`, the parity specialization is

\[
\boxed{
I_{p,\{0,h\}}(-1,-1)
=1-\frac4{(p+1)p^{v_p(h)}}.
}
\]

It vanishes if and only if

\[
\boxed{p=3\quad\text{and}\quad3\nmid h.}
\]

This is the unique two-leg finite-place Liouville annihilation across all collision depths.

For `k` distinct shifts and equal fugacity, the local factor is

\[
I_{p,k}(z)=\frac{p-k+(k-1)z}{p-z}.
\]

At `z=-1`, it vanishes at the prime

\[
p=2k-1.
\]

Equivalently, a good prime `p=2j-1` annihilates the entire Walsh degree-`j` sector. This is an exact local cyclotomic/Lee–Yang-style zero geometry. Treat that phrase only as a description of the finite Euler-factor zero unless a rigorous global consequence is proved.

## 8.4 Walsh spectral theorem

For Haar-random `n in Z_p`, define the parity vector

\[
X_{p,H}(n)
=\bigl((-1)^{v_p(n+h_1)},\ldots,(-1)^{v_p(n+h_k)}\bigr)
\in\{\pm1\}^k.
\]

Let `T_{p,H}` be convolution by its law. For a Walsh character

\[
\chi_J(x)=\prod_{i\in J}x_i,
\]

one has

\[
\boxed{
T_{p,H}\chi_J
=I_{p,H_J}(-1,\ldots,-1)\chi_J.
}
\]

Thus the collision recursion is simultaneously a recursive algorithm for the full local Boolean spectrum.

## 8.5 Distinct-residue lazy hypercube walk

If the shifts are distinct modulo `p`, then

\[
\boxed{
T_p
=I-\frac1{p+1}L_k,
\qquad
L_k=\sum_{i=1}^k(I-\tau_i),
}
\]

where `tau_i` flips coordinate `i`. On Walsh degree `j`,

\[
\boxed{
T_p\chi_J
=\left(1-\frac{2j}{p+1}\right)\chi_J.
}
\]

The prime `p=2j-1`, when good for the subtuple, is an exact spectral notch filter.

## 8.6 Prime-indexed heat flow

For all primes up to `Y`, CRT/Haar independence gives

\[
\widehat\nu_{\le Y,H}(J)
=\prod_{p\le Y}I_{p,H_J}(-1,\ldots,-1).
\]

Unless a finite factor annihilates the mode,

\[
\boxed{
\widehat\nu_{\le Y,H}(J)
\asymp_{H,J}(\log Y)^{-2|J|}.
}
\]

At good primes,

\[
T_{\le Y}
\approx\exp\left(-L_k\sum_{p\le Y}\frac1{p+1}\right),
\]

so the effective heat time is

\[
t(Y)=\log\log Y+O(1),
\]

and degree `j` has scaling dimension `2j`.

For degree one,

\[
\prod_{p\le Y}\frac{p-1}{p+1}
\sim
\boxed{
\frac{e^{-2\gamma}\zeta(2)}{(\log Y)^2}.
}
\]

The full parity law approaches the uniform gauge-neutral law at total variation order `(log Y)^{-2}`; its entropy deficit is asymptotic to

\[
\frac{k}{2}
\frac{e^{-4\gamma}\zeta(2)^2}{(\log Y)^4}.
\]

## 8.7 Entropy and the conditioned/unconditioned distinction

Convolution on a finite group is a convex mixture of translates, so Shannon entropy is monotone:

\[
H(\mu*\nu)\ge H(\mu).
\]

The unconditioned finite-adic parity flow randomizes toward the uniform neutral sector. A roughness condition does the opposite locally: it conditions every small-prime valuation to zero and freezes those parities at `+1`, pushing all unresolved charge into the large-prime tail.

Do not transfer an annihilation theorem from the unconditioned local field directly to a conditioned prime problem.

## 8.8 Cross-scale mutual information target

For `{+-1}`-valued random variables `A,B`, Pinsker gives

\[
|\mathbb E[AB]-\mathbb EA\,\mathbb EB|
\le\sqrt{2I(A;B)}.
\]

If a local factor makes `A` unbiased, any surviving correlation must be stored as mutual information with the remaining scale/tail. This supplies a precise information-theoretic target compatible with entropy-decrement methods. For Goldbach, conditioning on roughness changes the measure, so the relevant dependence must be formulated in the conditioned ensemble.

## 8.9 Categorical home of factorization charge

Let `FinAb` be the category of finite abelian groups. Its simples are `S_p=Z/pZ`, and

\[
K_0(\mathrm{FinAb})
\cong\bigoplus_p\mathbb Z[S_p].
\]

For `M_n=Z/nZ`,

\[
[M_n]=\sum_pv_p(n)[S_p],
\qquad
\ell(M_n)=\Omega(n).
\]

The Liouville character is the homomorphism sending every simple class to `-1`:

\[
\chi_\lambda([M_n])=(-1)^{\ell(M_n)}=\lambda(n).
\]

Thus factorization parity is composition-length grading in `K_0`, not an ordinary endpoint `K_1` class.

At scale `sqrt(X)`, the residual module quotient is zero or simple. This is the exact finite categorical form of the unresolved charge bit.

## 8.10 Hall algebra and least-prime peeling

Finite-length `Z`-modules carry a Hall algebra. A Buchstab peel is a selected simple-subobject/quotient correspondence on the cyclic locus, ordered by the least prime. This is the appropriate categorical substrate for repeated prime factors.

Derived/exterior Euler-characteristic constructions tend to kill repetitions and produce Möbius/squarefree signs; composition length preserves repetitions and produces Liouville. This distinction should remain explicit in any cohomological proposal.

## 8.11 Configuration-space geometry

The shift tuple modulo simultaneous translation lives on a type-`A` relative configuration space. Collision divisors are the braid arrangement `h_i=h_j`. The full `p`-adic dendrogram records successive approaches to these diagonals.

The natural geometric objects include:

- tangent-framed `M_{0,k+1}`-type configurations;
- wonderful/normal-crossings compactifications of the braid arrangement;
- tropical/stable collision trees;
- motivic Igusa zeta functions and nearby cycles.

This geometrizes the local singular-series field. It does not yet control the positive-integer boundary or prove a global prime theorem.

---

# 9. Affine Buchstab states, fixed determinant, and CRT boundary spectrum

## 9.1 Exact affine peel

Encode two affine forms by

\[
M=\begin{pmatrix}a&b\\c&d\end{pmatrix},
\qquad
\binom{L_1(n)}{L_2(n)}=M\binom n1.
\]

Peeling a prime `p` from the first leg, writing `n=r+pm` and dividing that leg by `p`, gives

\[
\boxed{
M'
=\operatorname{diag}(p^{-1},1)
M
\begin{pmatrix}p&r\\0&1\end{pmatrix}.
}
\]

Therefore

\[
\boxed{\det M'=\det M.}
\]

For `L_1=n,L_2=n+h`, the determinant is `h` up to the sign convention.

After peeled divisors `A|n`, `B|n+h`, with `(A,B)=1`, CRT gives residual forms

\[
\frac nA=Bm+t,
\qquad
\frac{n+h}B=Am+s,
\]

satisfying

\[
\boxed{Bs-At=h.}
\]

The state matrix

\[
\begin{pmatrix}B&t\\A&s\end{pmatrix}
\]

has determinant `h`.

## 9.2 Farey/Hecke state space

For `h=1`,

\[
\frac sA-\frac tB=\frac1{AB},
\]

so the rational endpoints are Farey neighbors in the usual reduced positive normalization.

More generally, primitive determinant-`h` integer matrices satisfy Smith normal form

\[
UMV=\operatorname{diag}(1,h)
\]

for `U,V in GL_2(Z)`. Thus the state space is the standard integral double orbit underlying degree-`h` Hecke correspondences.

This makes the Hecke/Farey relation exact at the level of states. It does **not** prove that directed, weighted, least-prime Buchstab dynamics is a standard self-adjoint Hecke operator.

More precisely, the affine child matrices

\[
\gamma_{p,r}=\begin{pmatrix}1&r\\0&p\end{pmatrix}
\]

act on a cusp coordinate by `u -> (u+r)/p`. They are the `p` child representatives in the determinant-`p` Hecke correspondence; the missing representative `diag(p,1)` is the parent direction of the `(p+1)`-regular Bruhat–Tits tree. A Buchstab step selects a child branch and then primitively saturates one column. Spherical Hecke theory restores parent-plus-children symmetry and thereby forgets the root orientation, forbidden branch, least-prime order, and positive-cone stopping data.

## 9.3 Good-prime dynamics largely abelianizes

Modulo simultaneous translation of the intercepts, a coprime ordered pair `(A,B)` has one class of solutions to `Bs-At=h`. For a prime `p not dividing h`, a peeled prime can enter only one leg. The quotient dynamics therefore reduces to a two-color assignment process multiplying `A` or `B` by `p`.

Genuine coupled/noncoprime branching is supported at primes dividing `h`, exactly the collision primes appearing in the singular series.

Consequence: after local factors are removed, ordinary bi-invariant Hecke spectrum is unlikely by itself to contain the hard global remainder. The remaining interaction must involve scale ordering, positive-cone stopping, coherent additive sampling, or global `L`-spectral effects.

## 9.4 Exact finite-sieve CRT decomposition

Let

\[
P(y)=\prod_{p\le y}p,
\]

and

\[
R_h(X,y)=\sum_{1\le n\le X}
1_{(n,P(y))=1}1_{(n+h,P(y))=1}.
\]

Möbius expansion gives

\[
R_h(X,y)
=\sum_{d,e\mid P(y)}\mu(d)\mu(e)N_X(d,e;h),
\]

where `N_X(d,e;h)` counts solutions to

\[
d\mid n,
\qquad
e\mid n+h.
\]

Let `g=(d,e)`, `L=[d,e]`. There are no solutions unless `g|h`. In the compatible case there is one residue `a mod L`, and

\[
N_X(d,e;h)=\frac XL+B_X(a,L),
\]

where `B_X` is the bounded periodic endpoint/sawtooth correction. Hence

\[
\boxed{
R_h(X,y)
=X\sum_{\substack{d,e\mid P(y)\\(d,e)\mid h}}
\frac{\mu(d)\mu(e)}{[d,e]}
+\Delta_h(X,y).
}
\]

The first term is exactly the finite singular-series/equilibrium density. The entire finite-interval error is the explicit CRT boundary operator

\[
\Delta_h(X,y)
=\sum_{\substack{d,e\mid P(y)\\(d,e)\mid h}}
\mu(d)\mu(e)B_X(a(d,e;h),[d,e]).
\]

## 9.5 Modular inverses are forced by the boundary

In the coprime sector, write `a=dt`. CRT gives

\[
t\equiv-hd^{-1}\pmod e,
\]

so

\[
\frac a{de}\equiv-\frac{hd^{-1}}e\pmod1.
\]

Fourier expansion of the sawtooth therefore produces phases

\[
\boxed{e(-khd^{-1}/e).}
\]

This is the first exact place where inverse-residue/Kloosterman geometry is forced by the positive-cone remainder itself.

## 9.6 Exact canonical charge boundary operator

For the desingularized charge family,

\[
K_{X,h}(z,w)
=\operatorname{Tr}\bigl(P_XG(z)U_h^*G(w)U_h\bigr)
=\sum_{n\le X}z^{\Omega(n)-1}w^{\Omega(n+h)-1}.
\]

Using `u_z=1*c_z`,

\[
K_{X,h}(z,w)
=\sum_{d,e}c_z(d)c_w(e)N_X(d,e;h).
\]

It splits exactly as

\[
\boxed{K_{X,h}=\mathcal M_{X,h}+\mathcal B_{X,h},}
\]

with zero additive mode

\[
\mathcal M_{X,h}(z,w)
=X\sum_{(d,e)\mid h}\frac{c_z(d)c_w(e)}{[d,e]},
\]

and boundary

\[
\mathcal B_{X,h}(z,w)
=\sum_{(d,e)\mid h}
\frac{c_z(d)c_w(e)}{[d,e]}
\sum_{\substack{r\bmod[d,e]\\r\ne0}}
D_X(r/[d,e])e(-ra/[d,e]).
\]

At the exact prime point `z=w=0`, the weights are `q_1(d)q_1(e)`, not `mu(d)mu(e)`.

## 9.7 Multiplicative-character diagonalization

For a unit `d mod e`, finite Fourier inversion on `(Z/eZ)^x` gives

\[
\boxed{
e(c d^{-1}/e)
=\frac1{\varphi(e)}
\sum_{\chi\bmod e}\tau_e(\chi;c)\chi(d),
}
\]

with generalized Gauss sum

\[
\tau_e(\chi;c)
=\sum_{x\bmod e}^*\chi(x)e(cx/e).
\]

Thus the same boundary operator admits:

1. additive Fourier modes;
2. multiplicative character modes;
3. factorization charge modes.

## 9.8 Twisted charge spectrum

For the grand-canonical kernel,

\[
\mathcal A_\chi(z,s)
=\sum_n\frac{a_z(n)\chi(n)}{n^s}
=\frac{F_\chi(z,s)}{L(s,\chi)}.
\]

In a zero-free domain,

\[
F_\chi(z,s)=L(s,\chi)^zG_\chi(z,s),
\]

where the local correction is analytic because the first-order prime term cancels. Therefore

\[
\mathcal A_\chi(z,s)=L(s,\chi)^{z-1}G_\chi(z,s).
\]

An `L`-zero of multiplicity `m` has local charge exponent `m(z-1)`: equilibrium `z=1` cancels the singularity, while `z=0` produces an inverse-`L` pole.

For the exact canonical prime sector,

\[
\boxed{
C_{0,\chi}(s)=\frac{P_\chi(s)}{L(s,\chi)}.
}
\]

The twisted prime zeta admits

\[
\boxed{
P_\chi(s)
=\sum_{m\ge1}\frac{\mu(m)}m\log L(ms,\chi^m)
}
\]

in the absolute-convergence half-plane.

## 9.9 Smoothed Poisson boundary and square-root localization

For `W in C_c^infty((0,infty))`, fixed charges `r,t`, and canonical kernels `kappa_r,kappa_t`, the smoothed correlation

\[
C_{r,t}^W(X;h)
=\sum_n1_{\Omega(n)=r}1_{\Omega(n+h)=t}W(n/X)
\]

has the exact Poisson expansion

\[
\sum_{n\equiv a\ (L)}W(n/X)
=\frac XL\sum_{k\in\mathbb Z}
\widehat W(kX/L)e(ka/L).
\]

Hence the nonzero-frequency boundary is

\[
\Delta_{r,t}^W
=X\sum_{(d,e)\mid h}
\frac{\kappa_r(d)\kappa_t(e)}{[d,e]}
\sum_{k\ne0}\widehat W(kX/[d,e])e(ka/[d,e]).
\]

If `d,e<=D` with

\[
D\le X^{1/2-\varepsilon},
\]

rapid Fourier decay gives, for every `B>0`,

\[
\boxed{
\Delta_{r,t}^{W,\le D}(X;h)=O(X^{-B}).
}
\]

Thus every divisor block strictly below the square-root hyperbola is asymptotically pure equilibrium. The positive-cone spectrum is supported on

\[
[d,e]\gtrsim X,
\]

with the balanced Type-II block `d,e~sqrt(X)` as the first critical regime.

## 9.10 Hermitian Kloosterman normalization

For coprime `d,e`, additive reciprocity gives

\[
\frac{\bar d}{e}+\frac{\bar e}{d}
\equiv\frac1{de}\pmod1.
\]

Define

\[
\mathcal K_a(d,e)
=e\left(-a\frac{\bar d}{e}+\frac a{2de}\right).
\]

Then

\[
\boxed{\mathcal K_a(e,d)=\overline{\mathcal K_a(d,e)}.}
\]

After absorbing the half-phase into the smooth archimedean weight, a dyadic equal-charge boundary block is a Hermitian bilinear form. Its natural hard quantity is an operator norm.

Bettin–Chandee-type Kloosterman-fraction estimates give power savings in balanced fixed-frequency blocks, but do not yet control all long divisor/frequency ranges or evaluate the exact canonical main term.

## 9.11 Direct analytic workstream

The most concrete direct route is:

1. decompose the exact prime kernel
   \[
   q_1=1_{\mathbb P}*\mu
   \]
   or its smoothed counterpart using a Vaughan/Heath-Brown-style identity;
2. insert it into the exact CRT/Poisson formula;
3. separate balanced, unbalanced, and long-frequency blocks;
4. use dispersion, spectral large sieve, Kloosterman-fraction, or Kuznetsov estimates where nontrivial;
5. exploit the special divisor-lattice and `P_chi/L` structure rather than treating coefficients as arbitrary;
6. derive any expected-order positive-real charge bound needed by the normal-family theorem.

A power saving uniform for a mesoscopic charge

\[
z=(\log\log X)^{-\alpha},\qquad \alpha<1,
\]

would already be genuine progress even without reaching the prime scale `alpha=1`.

---
# 10. Archimedean beta geometry, Meixner flow, and `SU(1,1)` tensor structure

## 10.1 Log-center and rapidity coordinates

For positive coordinates `m,n`, define

\[
c=\frac{\log m+\log n}{2},
\qquad
d=\frac{\log n-\log m}{2}.
\]

Then

\[
m=e^{c-d},
\qquad
n=e^{c+d},
\]

\[
S=m+n=2e^c\cosh d,
\qquad
D=n-m=2e^c\sinh d,
\qquad
Q=mn=e^{2c}.
\]

The multiplicative Haar measure is flat:

\[
\frac{dm}{m}\frac{dn}{n}=2\,dc\,dd.
\]

For Mellin frequencies `gamma,gamma'`,

\[
m^{-i\gamma}n^{-i\gamma'}
=e^{-i(\gamma+\gamma')c}
e^{-i(\gamma'-\gamma)d}.
\]

Thus

\[
\boxed{
\gamma+\gamma'\ \text{is dual to log-center }c,
\qquad
\gamma'-\gamma\ \text{is dual to rapidity }d.
}
\]

The Goldbach shell `S=N` is the curved graph

\[
c=\log\frac{N}{2\cosh d}.
\]

This curvature couples center and rapidity and produces the beta interaction kernel. A product rectangle misses it.

## 10.2 Beta kernel as hyperbolic Fourier transform

For complex `rho,rho'` with positive real parts,

\[
B(\rho,\rho')
=\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho')}.
\]

The Goldbach shell gives

\[
B(\rho,\rho')
=2\int_{\mathbb R}
\frac{e^{(\rho'-\rho)d}}{(2\cosh d)^{\rho+\rho'}}\,dd.
\]

Thus the two-zero beta coefficient is the rapidity Fourier/Laplace transform of the additive simplex boundary.

The Languasco–Zaccagnini Cesàro coefficient

\[
C(\rho,\rho')
=\frac{\Gamma(\rho)\Gamma(\rho')}
{\Gamma(\rho+\rho'+2)}
\]

is the same beta interaction followed by the resolvent multiplier

\[
\frac1{(\rho+\rho')(\rho+\rho'+1)}.
\]

Its same-sign polynomial decay and opposite-sign exponential suppression follow from Stirling and the triangle defect. They are not merely numerical observations.

## 10.3 Symmetric Meixner density

For `Re(s)>0` and real `nu`, define

\[
\boxed{
m_s(\nu)
=\frac{2^{s-2}}{\pi\Gamma(s)}
\Gamma\left(\frac{s+i\nu}{2}\right)
\Gamma\left(\frac{s-i\nu}{2}\right).
}
\]

It is the inverse Fourier transform of `sech(d)^s`:

\[
\boxed{
m_s(\nu)
=\frac1{2\pi}\int_{\mathbb R}
e^{i\nu d}\operatorname{sech}(d)^s\,dd.
}
\]

For real `s>0`, it is a probability density and satisfies the exact convolution semigroup

\[
\boxed{m_{s_1}*m_{s_2}=m_{s_1+s_2}.}
\]

Its Lévy measure is

\[
\boxed{
\Pi_s(dx)
=\frac{s}{2|x|\sinh(\pi|x|/2)}\,dx.
}
\]

The pair coefficient is

\[
\boxed{
C(\rho,\rho')
=\frac{\pi2^{2-s}}{s(s+1)}m_s(\nu),
\qquad
s=\rho+\rho',
\quad
\nu=-i(\rho-\rho').
}
\]

Under RH,

\[
\rho=\frac12+i\gamma,
\qquad
\rho'=\frac12+i\gamma',
\]

so

\[
\boxed{
s=1+i(\gamma+\gamma'),
\qquad
\nu=\gamma-\gamma'.
}
\]

Zero difference is the Meixner spectral coordinate; zero sum is complex convolution time / representation weight.

## 10.4 Meixner–Pollaczek Jacobi operator

For real `s>0`, define monic polynomials by

\[
Q_0^{(s)}=1,
\qquad
Q_1^{(s)}(\nu)=\nu,
\]

\[
\boxed{
Q_{n+1}^{(s)}(\nu)
=\nu Q_n^{(s)}(\nu)
-n(n+s-1)Q_{n-1}^{(s)}(\nu).
}
\]

They are symmetric Meixner–Pollaczek polynomials for the measure `m_s(nu)dnu`. In the orthonormal basis, multiplication by `nu` is the Jacobi operator

\[
J_se_n
=\sqrt{(n+1)(n+s)}e_{n+1}
+\sqrt{n(n+s-1)}e_{n-1}.
\]

For real positive `s`, this is established `SU(1,1)` positive-discrete-series representation theory. The Goldbach zero-pair formula analytically continues the cyclic spectral density to the vertical line `Re(s)=1` and then applies the Cesàro resolvent.

## 10.5 Three semigroups

The program contains three exact flows:

1. finite-prime Boolean heat flow:
   \[
   T_p=I-L_k/(p+1);
   \]
2. factorization-scale Buchstab convolution:
   \[
   \mathcal L\mu_z^{\mathrm B}=e^{zE_1};
   \]
3. archimedean Meixner convolution:
   \[
   \widehat m_s(d)=\operatorname{sech}(d)^s.
   \]

They are structurally parallel exponentials of infinitesimal generators, but no coupled adelic generator has yet been constructed. Merely listing them together is not a theorem.

## 10.6 `SU(1,1)` radial/angular decomposition

A single positive leg realizes the lowest positive discrete series `D^+_{1/2}`. In the two-leg tensor product:

- total sum `S=x_1+x_2` is radial;
- relative coordinate
  \[
  x=\frac{x_2-x_1}{x_1+x_2}
  \]
  is angular.

The positive-positive tensor product decomposes into a discrete ladder indexed by angular degree `j`. Jacobi polynomials give the angular basis, and their Mellin transforms are continuous Hahn polynomials.

For Jacobi parameters `alpha,beta`, define

\[
I_j^{(\alpha,\beta)}(\rho,\rho')
=\int_0^1t^{\rho-1}(1-t)^{\rho'-1}
P_j^{(\alpha,\beta)}(1-2t)\,dt.
\]

This equals a beta factor times a terminating `{}_3F_2`; in the symmetric representation normalization it becomes

\[
I_j
=\frac{(-i)^jB(\rho,\rho')}{(s)_j}
\,p_j\left(\frac{\rho-\rho'}{2i};\frac s2,\ldots\right),
\]

where `p_j` is a continuous Hahn polynomial and `s=rho+rho'`.

The first relative channels are

\[
\boxed{
\frac{I_1}{B}=\frac{\rho'-\rho}{\rho+\rho'},
}
\]

and

\[
\boxed{
\frac{I_2}{B}
=\frac{3(\rho'-\rho)^2-s^2+2s}{2s(s+1)}.
}
\]

These nonradial channels defeat the earlier radial/separable no-go: the zero sum and zero difference remain in distinct slots but are coupled by a full angular ladder.

At fixed zero sum under RH, set

\[
\Sigma=\gamma+\gamma',
\qquad
r=\frac{\gamma-\gamma'}2,
\qquad
A=\frac12+\frac{i\Sigma}{2}.
\]

Then `rho=A+ir`, `rho'=A-ir`, and the phase-free numerator mass is

\[
|\Gamma(\rho)\Gamma(\rho')|^2
=\Gamma(A+ir)\Gamma(\overline A+ir)
 \Gamma(\overline A-ir)\Gamma(A-ir).
\]

This is exactly a continuous-Hahn orthogonality weight in the relative coordinate `r`, with parameter quadruple `(A,overline A,overline A,A)`. Since the Cesàro denominator is constant in `r` at fixed `Sigma`, the relative zero-difference mass has a complete continuous-Hahn mode decomposition: `j=0` is radial and `j>=1` are primitive/nonradial pair channels.

## 10.7 Goldbach versus gaps in representation theory

The library’s exact dictionary is

\[
\boxed{
\begin{array}{c|c}
\text{Goldbach / sums}
& D^+\otimes D^+,\ \text{discrete angular ladder},\ \text{Hahn polynomials}\\
\text{gaps / differences}
& D^+\otimes D^-,\ \text{principal-series scattering},\ \text{Hahn functions}
\end{array}
}
\]

This is the representation-theoretic form of positive-cone symmetry breaking. At finite places and on the signed line, reflection identifies the channels; the positive archimedean polarization separates a discrete bound-state ladder from scattering.

## 10.8 Jacobi primitive negativity

The Jacobi differential operator is negative semidefinite in its natural weight:

\[
\boxed{
\langle f,\mathcal J_{\alpha,\beta}f\rangle_w
=-\int_0^1t^{\alpha+1}(1-t)^{\beta+1}|f'(t)|^2\,dt\le0.
}
\]

This is an ambient geometric sign theorem. It does not supply the sign of the arithmetic Goldbach coefficient after sharp antipodal evaluation.

## 10.9 The correct prolate problem

The arithmetic position region is the additive simplex

\[
\Delta_X=\{(m,n):m>0,n>0,m+n\le X\},
\]

not a product rectangle. In `(c,d)` coordinates,

\[
c\le\log\frac{X}{2\cosh d}.
\]

A product cutoff factorizes and reproduces the already-killed separable construction. The correct two-body concentration operator has the form

\[
\boxed{
\mathcal C_{X,\Gamma}
=P_{\Delta_X}Q_\Gamma P_{\Delta_X},
}
\]

where `Q_Gamma` imposes a tensor-scaling/relative-Mellin spectral window or Sonin condition.

Desired outputs:

- a sparse commuting differential, difference, or canonical-system operator;
- a de Branges/Sonin space whose matrix coefficients reproduce beta/simplex weights;
- a trace or positive norm matching the two-zero Goldbach Weil functional;
- preservation of the beta interaction, proving the construction is not a factorized tautology.

## 10.10 Meixner–Pollaczek time-band limiting

For real `s>0`, let `F_s` be the Meixner–Pollaczek spectral transform, `P_N` the degree cutoff, and `B_Omega` the spectral interval. Define

\[
K_{N,\Omega}^{(s)}
=P_N\mathcal F_s^{-1}B_\Omega\mathcal F_sP_N.
\]

The first target is to construct a sparse self-adjoint `L_{N,Omega}^{(s)}` commuting with this concentration operator, or prove that the naive hard-band version admits no such operator and identify a soft/reflecting replacement.

This lands on an explicit open Meixner–Pollaczek time-band-limiting problem discussed by Grünbaum. The usual Slepian cancellation is not automatic because the dual Meixner–Pollaczek equation uses imaginary shifts / an infinite-order real operator.

## 10.11 String/screw kernel placement

The one-zero screw kernel has a centered Mellin multiplier equivalent to a massive dilation resolvent, with factor of the form

\[
(\gamma^2+1/4)^{-1}.
\]

This explains why the Matsumoto–Suzuki one-zero sector fits a Krein-string/canonical-system positivity theory. The unresolved variance wall is phase separation/localization after two-body compression, not positivity of this one-body resolvent.

---

# 11. Finite Hahn geometry on a Goldbach diagonal

## 11.1 Hahn operator

Fix `N` and functions on `{0,...,N}`. Define

\[
\boxed{
(L_Nf)(m)
=(m+1)(N-m)[f(m+1)-f(m)]
+m(N-m+1)[f(m-1)-f(m)].
}
\]

Its orthogonal eigenfunctions are Hahn polynomials `Q_j(m;N)` with

\[
L_NQ_j=-j(j+1)Q_j,
\qquad j=0,\ldots,N.
\]

Reflection satisfies

\[
\boxed{Q_j(N-m;N)=(-1)^jQ_j(m;N).}
\]

## 11.2 Goldbach as alternating angular energy

For a signal `a_N(m)` on the diagonal, let `a_hat_N(j)` be its normalized Hahn coefficients. Reflection gives

\[
\boxed{
\sum_{m=0}^Na_N(m)a_N(N-m)
=\sum_{j=0}^N(-1)^j|\widehat a_N(j)|^2.
}
\]

For the von Mangoldt or prime signal, this is the Goldbach correlation. It is an antipodal wave-propagator matrix coefficient for the finite angular Casimir.

Define `A_N=-L_N` and the degree operator

\[
\mathcal N_N=\frac{\sqrt{1+4A_N}-1}{2}.
\]

Then reflection is exactly

\[
\boxed{
R_N=(-1)^{\mathcal N_N}
=\cos\left[\frac\pi2(\sqrt{1+4A_N}-1)\right].
}
\]

## 11.3 Dirichlet form and primitive gap

Summation by parts gives

\[
\boxed{
-\langle f,L_Nf\rangle
=\sum_{m=0}^{N-1}(m+1)(N-m)|f(m+1)-f(m)|^2\ge0.
}
\]

On the mean-zero subspace, the first eigenvalue is `2`. On the reflection-even mean-zero subspace, only even `j` occur, so the first mode is `j=2` and

\[
\boxed{-\langle f,L_Nf\rangle\ge6\|f\|_2^2.}
\]

A normalized degree-two mode is

\[
\boxed{
Q_{2,N}(m)
=1-\frac{6m(N-m)}{N(N-1)}.
}
\]

This is the first primitive symmetric channel after removing the uniform bulk.

## 11.4 Heat-reflected positivity and the sharp boundary

For `tau>0`, define

\[
r_\tau(N)=\langle a_N,e^{\tau L_N}R_Na_N\rangle
=\sum_j(-1)^je^{-\tau j(j+1)}|\widehat a_N(j)|^2.
\]

The heat kernel is positivity preserving, and after reflection the kernel is strictly positive. For any nonzero nonnegative signal,

\[
\boxed{r_\tau(N)>0\qquad(\tau>0).}
\]

At `tau=0`, this becomes the sharp Goldbach trace and positivity is no longer automatic. A crude comparison is

\[
r(N)
\ge r_\tau(N)
-\tau\sum_{m=0}^{N-1}(m+1)(N-m)|\Lambda(m+1)-\Lambda(m)|^2.
\]

The needed arithmetic work is to approach `tau=0` with an error smaller than the positive smoothed signal.

## 11.5 Angular energy polynomial

Define

\[
\mathcal G_N(q)=\sum_{j=0}^Nq^j|\widehat a_N(j)|^2.
\]

For `0<=q<1`, this is a positive Poisson/heat interpolation. At the antipode,

\[
\boxed{\mathcal G_N(-1)=r(N).}
\]

Therefore

\[
\boxed{
\text{Goldbach failure at }N
\iff(1+q)\text{ divides }\mathcal G_N(q).
}
\]

This is exact but not yet an effective exclusion theorem.

## 11.6 Joint charged-angular partition function

Let `rho_y(n)` be a finite roughness indicator and

\[
v_{y,z}(m)=\rho_y(m)z^{\Omega(m)}.
\]

Define

\[
\boxed{
\mathcal Z_{N,y}(z_1,z_2;q)
=\langle v_{y,z_1},q^{\mathcal N_N}v_{y,z_2}\rangle.
}
\]

At `q=-1`, this is the exact rough two-leg charge generating function on the Goldbach diagonal. In a first-Buchstab-window cell, prime-pair extraction is the internal Walsh combination

\[
G_N
=\frac14\bigl[
\mathcal Z(1,1;-1)
-\mathcal Z(-1,1;-1)
-\mathcal Z(1,-1;-1)
+\mathcal Z(-1,-1;-1)
\bigr].
\]

This finite model makes the two boundary directions explicit:

- internal charge variables `z_i`;
- external angular variable `q`;
- prime pairs at the charged antipodal corner.

## 11.7 Pair-field Hodge decomposition

For

\[
f_N(m)=\Lambda(m)\Lambda(N-m),
\]

write

\[
f_N=\overline f_N+f_N^\circ,
\qquad
\overline f_N=\frac{r(N)}{N+1}.
\]

The primitive part is reflection-even and lies in modes `j=2,4,...`; hence

\[
-\langle f_N^\circ,L_Nf_N^\circ\rangle
\ge6\|f_N^\circ\|_2^2.
\]

The first primitive observable is

\[
R_2(N)
=\sum_{m=0}^N\Lambda(m)\Lambda(N-m)
\left[1-\frac{6m(N-m)}{N(N-1)}\right].
\]

Under RH zero coordinates `Sigma=gamma+gamma'`, `Delta=gamma-gamma'`, its continuous-Hahn beta multiplier is

\[
\boxed{
\frac{I_2}{B}
=\frac{1+\Sigma^2-3\Delta^2}
{2(1+i\Sigma)(2+i\Sigma)}.
}
\]

No sign theorem for the arithmetic `R_2(N)` is known.

## 11.8 One-log parity imbalance

The total von Mangoldt energy on a diagonal satisfies

\[
\sum_{n\le N}\Lambda(n)^2
=N\log N-N+o(N).
\]

Let `E_even,E_odd` be the Hahn energy in even and odd modes. Then

\[
E_{even}-E_{odd}=r(N),
\qquad
E_{even}+E_{odd}=\sum_{n\le N}\Lambda(n)^2.
\]

Assuming Hardy–Littlewood,

\[
\boxed{
\frac{E_{even}-E_{odd}}{E_{even}+E_{odd}}
\sim\frac{\mathfrak S(N)}{\log N}.
}
\]

The same `1/log N` relative imbalance appears for the unweighted prime indicator.

The sharp theorem therefore asks for a very small coherent difference between two much larger angular energies.

## 11.9 Fixed multipole no-go and growing aperture

For every fixed `j>=1`, PNT plus partial summation gives the fixed Hahn moment

\[
M_j(N)=o(N),
\]

and the normalized coefficient is `o(sqrt(N))`. The simplest exact cancellation uses

\[
Q_{1,N}(m)=1-\frac{2m}{N},
\qquad
M_1(N)=\psi(N)-\frac2N\sum_{m\le N}m\Lambda(m).
\]

Partial summation gives

\[
\sum_{m\le N}m\Lambda(m)
=N\psi(N)-\int_1^N\psi(t)\,dt
\sim\frac{N^2}{2},
\]

so the two PNT main terms cancel and `M_1(N)=o(N)`. The same orthogonality mechanism holds for every fixed nonconstant mode. The constant mode carries `~N`, while the full von Mangoldt energy is `~N log N`; hence any fixed finite set of modes captures a vanishing fraction of the energy.

The external aperture must grow with `N`. A random/Cramér calibration gives one coherent constant mode plus approximately white angular noise. The arithmetic signal is the structured `1/log N` parity imbalance inside a wide noisy band.

A fixed `j=2` theorem is a useful diagnostic but cannot by itself prove Goldbach.

A complementary extremal target is a Delsarte/Viazovska-style polynomial minorant: construct a low-complexity function of the Hahn Casimir whose spectral multipliers lie below `(-1)^j` on the required aperture while its position kernel has a sign or support property compatible with nonnegative arithmetic signals. Any such certificate must grow in degree/aperture with `N`; a fixed polynomial is ruled out by the fixed-band theorem.

## 11.10 Finite Hahn/Heun prolate target

The finite Hahn system is bispectral and admits algebraic-Heun constructions in standard time-band settings. The arithmetic version needs a concentration operator adapted to:

- a growing degree aperture;
- reflection parity;
- rational major-arc beam structure;
- charge sectors;
- the positive diagonal interval.

The target is a sparse commuting operator or a sharp no-go that identifies the correct matrix-valued/microlocal replacement.

---
# 12. Ramanujan–Hahn phase space and rational Bessel beams

## 12.1 Rational characters are high angular momentum

On the fixed diagonal, write

\[
x=\frac{2m-N}{N}.
\]

A rational additive character becomes

\[
e(am/q)=e(aN/2q)e^{i\pi aNx/q}.
\]

Its angular wavenumber is

\[
\boxed{k=\frac{\pi aN}{q}.}
\]

The Rayleigh expansion

\[
e^{ikx}
=\sum_{j\ge0}(2j+1)i^j\,\mathrm j_j(k)P_j(x)
\]

shows that its Legendre/Hahn spectrum is a spherical-Bessel packet concentrated near

\[
\boxed{j\approx\pi N\frac aq}
\]

until the finite lattice/Nyquist ceiling.

Therefore

\[
\boxed{q\text{ small}\not\Rightarrow j\text{ small}.}
\]

The major arcs are not a low-Hahn-degree band. They are a union of rationally indexed beams along the phase-space curves

\[
\boxed{
\mathcal C_N
=\left\{\left(\frac aq,j\right):
 j\approx\pi N\left\|\frac aq\right\|\right\}.
}
\]

## 12.2 Exact reflection form for plane waves

For plane waves `u_alpha(m)=e(alpha m)`, the reflection bilinear form is

\[
\boxed{
B_N(u_\alpha,u_\beta)
=e(\beta N)D_N(\alpha-\beta),
}
\]

where `D_N` is the finite Dirichlet kernel. Rational frequencies are coherent when their difference is within `1/N` of an integer.

## 12.3 Singular series as coherent antipodal trace

A truncated Ramanujan approximation to the prime field is a coherent sum of rational plane waves with amplitudes `mu(q)/phi(q)`. Its resonant antipodal contribution is

\[
\boxed{
(N+1)\sum_{q\le Q}
\frac{\mu(q)^2}{\varphi(q)^2}c_q(N).
}
\]

Hence

\[
\boxed{
\text{the truncated singular series is the coherent angular-parity trace of rational Bessel packets.}
}
\]

This is an exact unification of the Ramanujan/Wiener–Khintchine and Hahn/antipodal pictures.

The spherical-Bessel identity

\[
\sum_{j\ge0}(2j+1)(-1)^j\mathrm j_j(k)^2
=\mathrm j_0(2k)
=\frac{\sin(2k)}{2k}
\]

makes the antipodal cancellation of a single continuum beam explicit. It concerns a Hermitian reflection correlation of one complex plane wave. The arithmetic Ramanujan block uses a bilinear form with coherent cross-frequency phases, so this identity must not be substituted for the singular series term-by-term.

## 12.4 Canonical relation

The Rayleigh transform defines the phase-space relation

\[
\boxed{
\alpha\longmapsto j/N\approx\pi\|\alpha\|.
}
\]

The Ramanujan-to-Hahn change of basis is therefore a discrete arithmetic Fourier-integral transform. This is the right language for classifying structured versus unstructured angular energy.

## 12.5 Corrected concentration problem

A scalar projector onto degrees `j<=J` is misaligned with the major arcs. The correct structured subspace is generated by rational Bessel packets for relevant `a/q`, possibly with charge and collision labels. The concentration operator should be matrix-valued or microlocal, measuring simultaneous localization near `mathcal C_N` and in the positive diagonal interval.

A candidate architecture:

1. choose a denominator/height cutoff `Q` and construct normalized rational beam vectors;
2. form their Gram matrix in the Hahn basis;
3. decompose into resonant `sharp`, mixed, and residual `flat` blocks;
4. construct a sparse Hahn–Heun or block-Jacobi operator commuting approximately or exactly with the beam projector;
5. prove an inverse theorem: a large residual antipodal discrepancy forces concentration near a classified rational/character structure.

## 12.6 Numerical calibration already in the library

One exploratory computation at `N=500,Q=50` decomposed a model antipodal form into approximately

\[
\text{structured}=916.6656,
\qquad
\text{mixed}=-51.4719,
\qquad
\text{residual}=0.0693,
\]

with total `865.2630`. This is a calibration of the decomposition, not evidence for a theorem or a universal asymptotic.

## 12.7 High-value theorem schema

A useful inverse theorem would have the form:

> If the sharp even/odd Hahn energy discrepancy exceeds the random/noise scale after the singular-series beam contribution is removed, then the signal has nontrivial correlation with a bounded-complexity rational character, Dirichlet character, collision stratum, or canonical charge mode.

The theorem must quantify:

- the aperture `J(N)`;
- denominator range `Q(N)`;
- norm of the residual projector;
- stability under replacing Legendre by finite Hahn functions;
- interaction with the exact canonical prime kernel.

---

# 13. Type-`A` multileg structure and the binary/ternary divide

## 13.1 Relative configuration space

For `k` legs, quotient common translation from `A^k`. The resulting relative space is the standard reflection representation

\[
V_{\mathrm{std}}
=\{(z_1,\ldots,z_k):\sum_iz_i=0\}.
\]

The finite collision arrangement is type `A_{k-1}`. The same relative space controls the archimedean primitive angular modes.

## 13.2 Primitive space

In the polynomial realization of `D^+_{1/2}`, total lowering is common translation:

\[
K_-^{\mathrm{tot}}=\sum_{i=1}^k\partial_{z_i}.
\]

Primitive homogeneous polynomials of degree `j` are those killed by total lowering. Exactly,

\[
\boxed{
\mathcal P_j^{(k)}
\cong\operatorname{Sym}^j(V_{\mathrm{std}}^*).
}
\]

Therefore

\[
\boxed{
\dim\mathcal P_j^{(k)}
=\binom{j+k-2}{k-2}.
}
\]

Every fixed-total-degree simplex decomposes as

\[
\boxed{
\mathcal H_N^{(k)}
=\bigoplus_{j=0}^N
(K_+^{\mathrm{tot}})^{N-j}\mathcal P_j^{(k)}.
}
\]

This is a Lefschetz-style radial/primitive decomposition.

## 13.3 Multileg Hahn generator

On occupations `n_1+...+n_k=N`, summing over ordered pairs of distinct legs `(i,r)`, define

\[
\boxed{
(L_{N,k}f)(\mathbf n)
=\sum_{i\ne r}n_i(n_r+1)
[f(\mathbf n-e_i+e_r)-f(\mathbf n)].
}
\]

Up to convention, `-L_{N,k}` is the total `SU(1,1)` Casimir minus the scalar lowest-weight contribution. On primitive degree `j`,

\[
\boxed{-L_{N,k}=j(j+k-1),}
\]

with multiplicity

\[
\binom{j+k-2}{k-2}.
\]

The reversible Dirichlet form is an exact sum of squared edge differences on the composition simplex.

## 13.4 Permutation traces

For a permutation `sigma in S_k`,

\[
\boxed{
\sum_{j\ge0}
\operatorname{tr}(\sigma|\mathcal P_j^{(k)})t^j
=\frac1{\det(I-t\sigma|V_{\mathrm{std}})}.
}
\]

For a transposition,

\[
\boxed{
\sum_{j\ge0}\operatorname{tr}(\tau|\mathcal P_j^{(k)})t^j
=\frac1{(1-t)^{k-2}(1+t)}.
}
\]

Consequences:

- binary `k=2`: the trace is exactly `(-1)^j`; reflection parity is undiluted;
- ternary `k=3`: the transposition trace is `1` for even `j`, `0` for odd `j`, while the multiplicity is `j+1`; the parity trace is diluted inside a growing multiplicity space.

## 13.5 Symmetric primitive invariants

The Hilbert series of `S_k`-invariant primitive polynomials is

\[
\boxed{
\sum_{j\ge0}\dim(\mathcal P_j^{(k)})^{S_k}t^j
=\prod_{d=2}^k\frac1{1-t^d}.
}
\]

Thus symmetric primitive generators occur in degrees `2,...,k`.

- Binary has only the degree-two invariant.
- Ternary has degrees two and three; the degree-three invariant is the first genuinely new symmetric shape coordinate.

This gives a structural candidate for why three-variable arguments have an extra channel unavailable in binary problems.

## 13.6 Binary/ternary analytic calibration

The finite-place Ramanujan coefficients cross from `l^2` to `l^1` at three legs. Circle-method minor arcs likewise gain a spare Hölder/Cauchy factor in ternary settings. The type-`A` primitive space also acquires multiplicity and a degree-three invariant at `k=3`.

These facts align, but no theorem yet identifies them as one mechanism. A serious result must construct an explicit operator or inequality relating:

- ternary primitive multiplicity;
- the degree-three invariant;
- the extra analytic integrability/smoothing factor;
- a binary no-go or ternary gain.

### Maynard degree-lowering lens

In a rough cell, simultaneous primality of `k` forms expands into all Walsh degrees through

\[
\prod_iP_i
=2^{-k}\left(\prod_iR_i\right)
\sum_{J\subseteq[k]}(-1)^{|J|}\chi_J.
\]

A conjunction requires the full high-degree spectrum. Maynard’s bounded-gap method instead controls a weighted first moment `sum_i P_i`, using one-leg distribution plus many redundant candidate legs. Positivity and redundancy produce several primes without evaluating every higher joint parity sector. This explains structurally how a many-leg problem can bypass parity. A fixed binary Goldbach diagonal remains degree two; ordinary multidimensional sieve weights do not automatically lower that degree.

## 13.7 Recoupling and Racah structure

Different binary bracketings of a multileg tensor product are related by Racah/`6j` coefficients. On the finite side, different collision-tree resolutions are also related by associativity moves. This is the correct language for ensuring that local charge fusion and archimedean primitive decompositions are independent of arbitrary peeling/bracketing order.

---

# 14. Universal punctured line, factorization space, and local-to-global geometry

## 14.1 Universal family

Let

\[
B_k=\mathbb A^k/\mathbb G_a
\]

be the relative shift space. Over it, let `D_k` be the union of the `k` marked sections `x=-h_i`. Define the universal punctured line

\[
\boxed{
\mathcal U_k
=(\mathbb A^1\times B_k)\setminus D_k,
\qquad
\pi:\mathcal U_k\to B_k.
}
\]

At a finite prime, for a fiber `H`,

\[
\boxed{
\#\mathcal U_{k,H}(\mathbb F_p)=p-\nu_p(H).
}
\]

Hence the uncharged local survival probability is

\[
\frac1p\#\mathcal U_{k,H}(\mathbb F_p)
=1-\frac{\nu_p(H)}p.
\]

Dividing by `(1-1/p)^k` yields the Hardy–Littlewood local factor.

This makes the singular-series numerator a literal fiber point count.

## 14.2 Collision strata

The discriminant of the family is the braid arrangement where marked sections collide. Successive `p`-adic collision depth is tube depth around these strata. The Igusa charge integral is a tube-weighted point count on this universal family.

## 14.3 Charge fusion

When a cluster `C` of marked points collides, the fugacities fuse as

\[
\boxed{z_C=\prod_{i\in C}z_i.}
\]

In exponent variables `z_i=p^{-s_i}`, this is additive fusion `s_C=sum_{i in C}s_i`. The collision recursion is associative. For three clusters,

\[
(z_1z_2)z_3=z_1(z_2z_3),
\qquad
(s_1+s_2)+s_3=s_1+(s_2+s_3),
\]

and the corresponding beta factors obey

\[
\boxed{B(a,b)B(a+b,c)=B(b,c)B(a,b+c).}
\]

Thus every binary collision tree has the same total fused charge while retaining different intermediate scales and strata. The scalar charge law satisfies the pentagon tautologically. The nontrivial target is an operator/measure-level associator matching `SU(1,1)` Racah recoupling, Hall-algebra bracketing, nested Buchstab peeling, and stable-tree boundary moves.

This is an exact fusion law on the collision stratification of the Ran/configuration space. It has not been proved that every sheaf-theoretic axiom of a Beilinson–Drinfeld factorization algebra is satisfied. Use “factorization-space structure” as a precise target, not an established global theorem.

## 14.4 Charge derivatives as valuation insertions

The logarithmic derivative

\[
\mathcal D_i=z_i\partial_{z_i}
\]

acts by

\[
\boxed{
\mathcal D_iI_{p,H}(\mathbf z)
=\int_{\mathbb Z_p}v_p(x+h_i)
\prod_jz_j^{v_p(x+h_j)}\,dx.
}
\]

At a local annihilation point, the value may vanish while derivatives survive. The derivative records valuation depth and is the natural tangent observable to compare with vanishing cycles or monodromy logarithms.

The conjectural identification “charge derivative equals a nearby-cycle/monodromy trace” is not proved.

## 14.5 Archimedean fiber

For two marked points normalized to `0` and `1`, the real local zeta integral is

\[
\boxed{
\int_0^1x^{\rho-1}(1-x)^{\rho'-1}\,dx
=B(\rho,\rho').
}
\]

Its angular modes are continuous Hahn polynomials and its representation theory is `SU(1,1)` Clebsch–Gordan theory. Thus finite and real places share the exact skeleton:

\[
\boxed{
\text{marked configurations}
+\text{local zeta integrals}
+\text{additive exponent fusion}
+\text{collision/recoupling associativity}.
}
\]

## 14.6 Motivic and nearby-cycle target

Established Denef–Loeser motivic-zeta/nearby-cycle machinery packages local zeta integrals before choosing a prime, specializes to `p`-adic Igusa functions at good places, and admits topological and Hodge realizations related to monodromy. Hyperplane-arrangement Igusa functions also admit combinatorial formulas through intersection lattices and flag/Hilbert–Poincaré data; the type-`A` braid arrangement here is an explicit test case. The project target is a **relative** motivic object over `B_k` for the universal punctured line whose specializations recover:

- finite-place Igusa charge factors;
- collision derivatives;
- archimedean beta/Hahn characters;
- associativity/recoupling data.

The desired global theorem would be an adelic relative-trace or support statement that links these local objects to the positive-integer boundary. No such theorem is presently known.

## 14.7 Koba–Nielsen/string-amplitude relation

Beta and Selberg-type marked-point integrals belong to the same mathematical category as Koba–Nielsen/string amplitudes. This is a useful library of identities, recursions, and moduli-space geometry. It is not evidence that Goldbach is literally a string amplitude or that a physical string model has been derived.

## 14.8 Function-field calibration

The universal-family formulation suggests a function-field testbed where Frobenius, weights, and sheaf trace functions are available. A productive calibration should ask whether the local charge sheaf and its fusion can be constructed and whether a global trace estimate separates bulk from boundary. Success there would clarify which number-field obstruction is genuinely archimedean and which is categorical.

---
# 15. Independent polynomial-factor / all-pass branch

## 15.1 Provenance limitation

The absent external handoff defines a sparse “prime polynomial” denoted `F_X` and states a sequence of conjectures `A`, `A-prime`, and `A-double-prime`. The materialized files preserve the factor-theoretic consequences below but not the exact normalization of `F_X` or the verbatim conjecture. Agents must locate the original repository/source before making a publication-grade statement of Conjecture A-double-prime.

The durable target in the library index is:

> Continue the `A-double-prime` irreducibility/factor-exclusion frontier beyond degree eight.

## 15.2 Sign-parity all-pass system

For a real polynomial `g`, define

\[
\Theta_g(s)=\frac{g(-s)}{g(s)}.
\]

On the imaginary axis,

\[
g(-iy)=\overline{g(iy)},
\]

so

\[
\boxed{|\Theta_g(iy)|=1}
\]

wherever defined. Thus the involution `s -> -s` produces a rational half-plane all-pass transfer function.

The following are equivalent:

1. `g` and `g(-x)` share a root;
2. `g` has an opposite root pair `{alpha,-alpha}` or a root at zero;
3. `Theta_g` has a pole-zero cancellation;
4. `Res(g(x),g(-x))=0`;
5. the parity Bezoutian is singular.

## 15.3 Even/odd decomposition of the Bezoutian

Write

\[
g(x)=E(x^2)+xO(x^2).
\]

The Bezoutian kernel is

\[
\mathcal B_g(x,y)
=\frac{g(x)g(-y)-g(y)g(-x)}{x-y}.
\]

With `X=x²,Y=y²`, direct expansion gives

\[
\boxed{
\mathcal B_g(x,y)
=2\frac{XO(X)E(Y)-YO(Y)E(X)}{X-Y}
+2xy\frac{O(X)E(Y)-O(Y)E(X)}{X-Y}.
}
\]

There are no even–odd cross terms. In a parity-ordered monomial basis,

\[
\boxed{
B(g,g(-x))
\simeq2B(XO,E)\oplus2B(O,E).
}
\]

Consequently,

\[
\boxed{
\operatorname{Res}(g(x),g(-x))
=\pm2^{\deg g}g(0)\operatorname{Res}(E,O)^2.
}
\]

For the monic constant-term-one factors relevant to the source’s prime polynomial,

\[
\operatorname{Res}(g,g(-x))
=\pm2^{\deg g}\operatorname{Res}(E,O)^2.
\]

## 15.4 Integral unimodularity

The preserved canonical factor theorem states that any nondegenerate monic factor `g` under consideration satisfies

\[
\operatorname{Res}(g,g(-x))\mid2^{\deg g}.
\]

Combined with the square formula,

\[
\boxed{\operatorname{Res}(E,O)=\pm1.}
\]

Equivalently, there exist integer polynomials `U,V` with

\[
U(x)E(x)+V(x)O(x)=1.
\]

Every surviving non-cyclotomic factor candidate therefore determines:

- an integral unimodular polynomial row `(E,O)`;
- an invertible integer parity Bezoutian;
- a rational lossless/all-pass system with minimal dyadic determinant;
- a finite Hankel/McMillan realization;
- an integer continued-fraction/Euclidean-algorithm structure.

## 15.5 Proposed attack on A-double-prime

Replace degree-by-degree coefficient elimination by classification of integral lossless parity systems:

1. enumerate unimodular pairs `(E,O)` via polynomial Euclidean algorithms and continued fractions;
2. compute Smith normal forms of both parity Bezout blocks;
3. constrain the associated Hankel recurrence and McMillan realization;
4. impose divisibility of the source prime polynomial by
   \[
   E(x^2)+xO(x^2);
   \]
5. use arbitrarily long prime-gap zero strings against the finite linear recurrence;
6. seek a finite-state no-long-zero-string theorem compatible with integral all-pass realizations.

A low-degree factor behaves like a finite-state recurrence. Growing prime gaps should force increasingly long forbidden coefficient strings. The missing step is a uniform all-degree theorem, not another finite-degree elimination.

## 15.6 Computation/formalization requirements

A serious agent working this branch should first recover the exact `F_X` definition and existing degree-eight certification from the repo. Then:

- independently reproduce every resultant sign and degree convention;
- use exact integer/rational arithmetic only;
- enumerate factors and parity pairs for a larger range of `X` and degree;
- store certificates: factor, Bezout matrices, determinants, Smith forms, recurrence, and contradiction;
- formalize the parity Bezoutian decomposition in Lean;
- search literature under integral lossless systems, unimodular polynomial rows, `SL_2(Z[x])`, Routh continued fractions, Bezoutian storage functions, and lacunary-polynomial factors.

## 15.7 Epsilon-variance branch

The library index independently lists “the epsilon variance closure” as a live target, but the exact statement is absent from the materialized corpus. Do not merge it with the heat-stability, Hahn-energy, or residual-tail `epsilon_X in {0,1}` statements merely because the notation resembles them. Locate the original source before work begins; until then this is a provenance TODO, not a defined conjecture.

---

# 16. Three master problems

## 16.1 Stable Reconstruction

Given a scale-filtered arithmetic state `x` and an observable family `O_X(x)`, determine:

1. the exact ambiguity fiber;
2. the symmetry/group action producing that fiber;
3. the smallest extra observable restoring injectivity;
4. the inverse modulus of continuity as `X->infinity`;
5. whether recovery is local under scale refinement;
6. the aperture and precision needed to recover canonical charge and angular phase;
7. compatibility of the inverse condition number with known analytic errors.

Concrete instances:

- one-circle autocorrelation versus two circles or a radial derivative;
- finite sieve divisibility data versus the simple-or-zero tail;
- neutral gauge expectation versus charge projectors;
- low Hahn band versus rational-beam phase space;
- finite-place local factors versus the positive-integer CRT boundary.

## 16.2 Obstruction

When stable reconstruction fails, identify the obstruction in the smallest faithful category.

Current exact obstruction models:

- finite Hankel/McMillan rank for one-circle phase defects;
- AAK singular spectrum for quantitative phase ambiguity;
- residual simple-or-zero module tail at the square-root sieve scale;
- nonzero mutual information across prime scales;
- canonical charge idempotents in the LCM/join algebra;
- modular-inverse/Kloosterman phases in the CRT boundary;
- high angular momentum outside any fixed Hahn band.

Only after a functorial link is proved should one promote these to a graded/equivariant K-class, cyclic cocycle, nearby-cycle class, eta invariant, or determinant.

## 16.3 Positivity

Smoothed or neutral interiors often have automatic positivity:

- finite-place convolution kernels are probability operators;
- Jacobi/Hahn generators have nonnegative Dirichlet forms;
- heat-reflected Hahn kernels are strictly positive for `tau>0`;
- one-zero screw kernels are positive under RH;
- concentration operators are positive contractions.

The hard question is whether a sign survives at the simultaneous sharp boundary. A valid positivity theorem must retain:

- the beta/simplex interaction;
- the exact charge-one sector;
- the high rational-beam aperture;
- the positive-cone boundary;
- the distinction between prime indicator and von Mangoldt weights.

A factorized one-body norm, neutral Toeplitz symbol, or positive heat kernel that discards these features is insufficient.

## 16.4 Candidate common abstraction

A useful categorical object would contain:

- a scale filtration;
- an internal factorization-charge grading;
- a neutral conditional expectation;
- a charge/scale semigroup;
- an external angular/reflection action;
- a positive-cone or boundary lift;
- an obstruction object measuring lost completion data;
- a reconstruction theorem specifying minimal extra observations.

The finite-place Igusa field, the Buchstab semigroup, the canonical charge projectors, the Hahn diagonal, and the CRT boundary should become functorial components of this object. No complete category has yet been constructed.

---

# 17. Dead, downgraded, or sharply limited branches

Treat this section as a branch-kill list.

## 17.1 Full heat data as phaseless

**False.** Full heat/radial resolution is reconstructive. Only compressed data has homometric ambiguity.

## 17.2 Full divisibility algebra as blind to `Omega`

**False.** Full prime-power divisibility determines `Omega`; the obstruction is finite-scale coherence.

## 17.3 `z=0`, Möbius, and exact primes as the same endpoint

**False.** Möbius is the grand-canonical charge-zero/vacuum kernel. Exact primes are the canonical charge-one projector/tangent with symbol `P_chi/L`.

## 17.4 Lorentzian spacetime as the primary arithmetic machinery

**Downgraded.** `S²-D²=4Q` and center/rapidity coordinates are exact and useful, but affine, divisor-lattice, Hardy/Hankel, Igusa, and Hahn structures carry more machinery. Do not build physical Lorentz dynamics from the identity alone.

## 17.5 One universal PNT-centered tensor square

**False for simultaneous sum/gap centering.** It centers Goldbach naturally and leaves discrete gap atoms uncentered.

## 17.6 RH causality or screw positivity directly implying Goldbach

**Unsupported.** One-zero positivity does not automatically control the quadratic two-zero sector.

## 17.7 Two-zero Goldbach spectral sums as a novelty claim

**Prior art.** The project novelty candidates concern the exact operator placement, beta/Hahn decomposition, joint boundary, and prolate architecture.

## 17.8 Ordinary endpoint K-theory detecting Liouville parity

**Proved no-go.** The gauge path is homotopic to identity.

## 17.9 Prime creation as a nilpotent supersymmetric differential

**Proved no-go for pure creation.** Repetitions prevent nilpotence; exteriorization switches the arithmetic to Möbius/squarefree behavior.

## 17.10 Scalar low-Hahn-band major arcs

**False geometry.** Small denominator rational frequencies usually live at high Hahn degree `j~pi Na/q`.

## 17.11 Fixed `j=2` positivity as a Goldbach proof

**Insufficient.** Any fixed band captures vanishing energy as `N` grows.

## 17.12 Generic log-concavity of raw squared Hahn coefficients

~~**Numerically false.**~~ **Unresolved pending an exact witness** (seed121 audit, 2026-08-14; see the correction at §3.9 — a falsification of a strict inequality must be a single exhibited counterexample in closed form, not a floating-point scan). Do not invoke Hodge theory after an arbitrary non-geometric squaring/projection.

## 17.13 Standard Hecke theory alone

**Downgraded.** The fixed-determinant state space is exactly Hecke/Farey-like, but good-prime dynamics abelianizes after translation quotient and is directed/scale ordered. The hard spectrum reappears in the positive boundary.

## 17.14 Ordinary matroid/Tutte formulation of the full collision tree

**Downgraded.** The correct finite object is a hierarchical partition/dendrogram unless a genuine deletion–contraction invariant is found.

## 17.15 Graph/Ihara cycles

**Low priority.** Buchstab flow is scale ordered and nearly acyclic; forgetting ordering to create cycles likely discards the hard boundary information.

## 17.16 Host–Kra/nilsystem machinery for the fixed two-point problem

**Not currently forced.** The fixed two-leg charge correlation is `U²`/Fourier level. Revisit only if an additional averaging parameter arises.

## 17.17 Rovelli/RQM/LQG as added machinery

**No theorem yet.** The relational phrasing “given additive displacement, correlate charge-one events” is legitimate, but RQM/LQG/spinfoams have not supplied a useful operator or estimate.

## 17.18 Metamathematical/incompleteness conclusions

**No result.** The charge family compresses the representation of primality, but no proof-complexity or incompleteness bound has been established.

## 17.19 Positive heat-reflected Hahn trace

**True but not sharp.** Positivity for every `tau>0` does not imply positivity at `tau=0` without an arithmetic boundary estimate.

---

# 18. Numerical and finite evidence

All items here require reproduction before use.

1. **Many-body Buchstab connected ratio:** several moderate-scale gap/depth tests reportedly placed the normalized ratio within about `0.2%` of one. Exact scripts/ranges must be recovered from the repo.
2. **Minimal homometric AAK spectrum:** exact ranks `(2,3)` and winding `1`; numerical fractional singular values about `0.977147971` and `0.899663554`.
3. **Ramanujan–Hahn block at `N=500,Q=50`:** structured `916.6656`, mixed `-51.4719`, residual `0.0693`, total `865.2630` in the source normalization.
4. **Local parity factors:** exact finite-level averages modulo `p^M` agree with the derived Igusa formulas up to the expected truncated valuation-infinity mass.
5. **Raw Hahn log-concavity:** counterexamples were found; the generic conjecture is killed.
6. **Degree-eight factor frontier:** referenced by the index, but the exact certificates and polynomial normalization are absent from the materialized library and must be recovered.

Every new numerical claim should include exact code version, integer conventions, precision, input range, and output certificate.

---
# 19. Current priority stack

## 19.1 Library-index priorities, preserved verbatim in substance

1. Build the joint Ramanujan–Hahn phase-space transform and quantify the growing aperture needed for prime-scale parity balance.
2. Construct a matrix-valued/microlocal Hahn–Heun concentration operator for rational Bessel beams and decompose the Ramanujan sharp/flat blocks.
3. Develop an inverse theorem: large angular parity discrepancy forces classified congruence/character structure.
4. Formalize the type-`A` multileg Casimir/Hahn decomposition and compare ternary multiplicity spaces and degree-three invariants with the analytic spare Hölder factor.
5. Construct the Jacobi/Hahn or strip/Sonin prolate operator relevant to the tensor simplex.
6. Construct the relative motivic-zeta/nearby-cycle object of the universal punctured line and search for an adelic relative-trace theorem joining finite Igusa factors to the archimedean beta–Hahn character.
7. Study equivariant/graded transfer determinants or scattering invariants, not ordinary endpoint K-theory.
8. Continue A-double-prime factor irreducibility beyond degree eight and the epsilon-variance closure independently.

## 19.2 Operational additions forced by the canonical charge correction

Two direct analytic tasks deserve equal P0 attention:

9. Analyze the exact canonical prime boundary with weights `q_1` and twisted symbol `P_chi/L`, not the superseded Möbius-only model.
10. Prove any positive-real shifted/parallel charge estimate in a mesoscopic boundary layer and combine it with normal-family rigidity.

---

# 20. Detailed autonomous workstreams

Each workstream below is designed so an agent can begin without another planning conversation.

## Workstream A — Exact canonical CRT/Kloosterman boundary

### Goal

Obtain a nontrivial bound, structural factorization, or spectral decomposition for the exact smoothed prime-pair boundary

\[
\Delta_{1,1}^W(X;h)
=X\sum_{(d,e)\mid h}
\frac{q_1(d)q_1(e)}{[d,e]}
\sum_{k\ne0}\widehat W(kX/[d,e])e(ka/[d,e]).
\]

### Starting facts

- sub-square-root divisor blocks are negligible after smoothing;
- the first critical region is `d,e~sqrt(X)`;
- additive reciprocity makes fixed-frequency blocks Hermitian;
- inverse phases diagonalize into Dirichlet characters;
- the exact prime symbol is `P_chi/L`;
- existing arbitrary-coefficient Kloosterman-fraction estimates are useful but insufficient.

### First tasks

1. Recover or derive a finite Vaughan/Heath-Brown identity for `q_1=1_P*mu` suited to divisor variables.
2. Dyadically decompose `d,e,k` and label regimes by `de/X`, imbalance `d/e`, and Fourier length.
3. In each block, derive exact coefficient `l^1`, `l^2`, and twisted character norms.
4. Compare direct Bettin–Chandee, Linnik dispersion, Kuznetsov, and spectral-large-sieve bounds.
5. Identify where the `P_chi` numerator helps or hurts compared with arbitrary sequences.
6. Compute the zero-frequency canonical main term separately; do not assume it factorizes Eulerwise.

### Deliverable

A theorem with explicit ranges, for example a power saving for a balanced or mesoscopic block, plus a complete statement of the still-uncontrolled ranges. A useful no-go proving that a standard estimate cannot reach the needed range is also durable progress.

### Kill criteria

Do not report “Kloosterman methods apply” without an exponent calculation. Do not replace `q_1` by `mu` unless the theorem is explicitly about rough sieving.

## Workstream B — Shifted/parallel charge Selberg–Delange

### Goal

Prove an asymptotic or expected-order upper bound for

\[
Z_{H,X}(\mathbf z)
=\sum_{n\le X}\prod_i z_i^{\Omega(n+h_i)-1}
\]

uniform as positive `z_i` approach zero.

### Progressive ladder

1. Reprove the one-leg theorem in the project’s desingularized normalization.
2. Prove a two-leg upper bound for fixed `z>0` in the parallel shift geometry.
3. Establish uniformity for `z` in a compact subset of `(0,1]`.
4. Reach `z=(log log X)^{-alpha}` for any `alpha<1`.
5. Reach the critical `alpha=1` boundary layer.
6. Obtain interior asymptotics plus positive-real normal-family bounds sufficient for Vitali.

### Candidate tools

- Selberg–Delange and Sathe–Selberg methods;
- Nair–Tenenbaum-type bounds for multiplicative functions on polynomial values;
- Henriot/Shiu upper bounds;
- pretentious estimates adapted to parallel shifts;
- sieve majorants preserving the `z` dependence;
- divisor-kernel/CRT expansion followed by dispersion;
- canonical coefficient extraction after a grand-canonical theorem.

### Deliverable

State the uniform domain in `z`, the dependence on `h`, the exact local factor, and whether the result concerns grand-canonical `z^{Omega}` or canonical `z^{Omega-1}`. Even an expected-order upper bound can feed the rigidity theorem.

### Kill criteria

Do not cite a theorem for nonparallel linear forms as if it covered `n` and `n+h`. Do not use analytic continuation through zero without a locally uniform bound.

## Workstream C — Joint Ramanujan–Hahn transform

### Goal

Construct an exact finite change of basis from rational additive characters/Ramanujan atoms to Hahn angular modes on a fixed diagonal, with uniform asymptotics in `N,q,j`.

### First tasks

1. Derive exact finite Hahn coefficients of `m -> e(am/q)` using hypergeometric identities.
2. Prove a discrete stationary-phase/Rayleigh asymptotic locating the packet near `j~pi N||a/q||`.
3. Quantify packet width, tails, aliasing, and endpoint effects.
4. Sum primitive `a mod q` to obtain Ramanujan-beam vectors.
5. Compute their Gram matrix and reflection matrix exactly or asymptotically.
6. Prove the truncated singular-series trace from this basis without informal continuum replacement.

### Deliverable

A theorem-level “Ramanujan–Hahn transform” with explicit normalization and error, plus code validating it using exact arithmetic for moderate `N`.

### Kill criteria

Do not use Legendre continuum formulas without controlling the finite Hahn discrepancy. Do not identify denominator size with angular degree.

## Workstream D — Microlocal inverse theorem

### Goal

Classify signals with anomalously large sharp reflection/parity discrepancy after structured rational beams are removed.

### Candidate formulation

Let `P_struct` project onto the span of rational beam packets up to denominator `Q`, with charge/collision refinements. Let `R_N` be reflection. Bound

\[
|\langle (1-P_{struct})f,R_N(1-P_{struct})f\rangle|
\]

by a noise or Sobolev quantity, or prove that a large value implies correlation with a classified rational/character mode.

### First tasks

- formulate a finite uncertainty principle in the Hahn/Ramanujan phase space;
- compare with inverse theorems for large Fourier coefficients and large sieve saturation;
- identify the correct norm: energy, Dirichlet form, or prolate concentration norm;
- include a stability statement under small perturbations;
- test on primes, random Bernoulli controls, Cramér-weighted controls, and constructed rational signals.

### Deliverable

A rigorous inverse theorem or a finite-dimensional conjecture with exhaustive exact verification to a meaningful aperture.

## Workstream E — Hahn/Jacobi/Meixner prolate operator

### Goal

Construct a sparse operator commuting with the concentration problem relevant to the arithmetic simplex, or prove a precise no-go for the naive hard-band model.

### Three laboratories

1. **Finite Hahn:** fixed `N`, degree/position cutoff, reflection symmetry.
2. **Real Meixner–Pollaczek:** real `s>0`, degree cutoff and spectral interval.
3. **Two-body simplex:** curved position cutoff and diamond/simplex zero-frequency region.

### Procedure

1. Write the tridiagonal Jacobi operator and dual difference operator explicitly.
2. Form the most general low-band algebraic-Heun combination compatible with the cutoff.
3. Solve the commutator equations symbolically.
4. If no solution exists, prove the obstruction from boundary rank or imaginary-shift nonlocality.
5. Test soft windows, reflecting boundaries, and matrix-valued beam windows.
6. Only after a real self-adjoint solution exists, analytically continue toward `Re(s)=1`.

### Deliverable

An exact commuting operator, an exact no-go, or a quantitatively small commutator with a proved concentration consequence.

### Kill criteria

Do not start with complex zero parameters. Do not accept a product of one-body prolate operators that removes the beta interaction.

## Workstream F — Type-`A` multileg theorem

### Goal

Turn the exact multileg Casimir decomposition into an analytic explanation of a ternary advantage or a binary obstruction.

### First tasks

1. Formalize `P_j^(k)=Sym^j(V_std^*)` and the spectrum `j(j+k-1)`.
2. Decompose multiplicity spaces into `S_k` irreducibles.
3. Identify the degree-three ternary invariant explicitly on the composition simplex.
4. Derive its finite-place analogue on the `A_2` collision arrangement.
5. Compare its norm/energy estimate with the spare Hölder factor in ternary circle-method arguments.
6. Search for a trace inequality or interpolation theorem whose `k=2` case is critical and `k=3` case gains summability.

### Deliverable

A theorem linking representation multiplicity/invariant degree to an analytic norm gain, or a proof that the observed parallels are only analogy.

## Workstream G — Relative motivic/factorization object

### Goal

Construct the relative local-zeta object of the universal punctured line and its fusion/derivative operations.

### First tasks

1. Define the family and collision divisor over the relative configuration base.
2. Construct a motivic or sheaf-theoretic local zeta object whose finite-field trace is `p-nu_p(H)` and whose tube weights recover `I_{p,H}(z)`.
3. Prove associativity of charge fusion as a factorization axiom.
4. Interpret logarithmic charge derivatives as nearby/vanishing-cycle or monodromy insertions, or prove this interpretation false.
5. Build the archimedean realization yielding beta and continuous-Hahn characters.
6. Search for a relative trace formula or support theorem capable of seeing the positive boundary.

### Deliverable

A precise object and comparison theorem, not just a list of related names.

## Workstream H — Graded/equivariant transfer invariants

### Goal

Find a secondary invariant that detects charge/Hankel information erased by ordinary K-theory.

### Candidate objects

- signed Fredholm/Ruelle determinants of the one-sided transfer operator;
- eta functions or spectral asymmetry;
- graded/equivariant cyclic cocycles;
- scattering/characteristic functions of Hardy block operators;
- spectral flow around the full gauge loop;
- AAK singular measures and determinant formulas.

### First task

Construct the finite-dimensional invariant for the minimal homometric pair and for finite charge-transition matrices. Prove it reduces to the full singular-value data rather than only winding. Then identify a stable infinite-volume limit.

### Kill criteria

Do not return to ordinary endpoint K-groups. Do not name an invariant without computing it on the canonical finite examples.

## Workstream I — A-double-prime factor frontier

Follow Section 15. The first action is provenance recovery. Then reproduce the degree-eight result exactly before extending it.

## Workstream J — Finite observability in Cubical Agda/HoTT

### Goal

Formalize the scale-truncated reconstruction problem as a finite quotient/fiber computation.

### Suggested model

- finite arithmetic states up to `X`;
- observations generated by divisibility by prime powers below `y`;
- quotient states by equal visible observations;
- characterize fibers at `y=sqrt(X)`;
- add the residual simple-or-zero module/charge bit;
- prove reconstruction after augmentation;
- compare the finite lifting defect with any proposed operator/K-theory obstruction.

### Deliverable

Executable Cubical Agda definitions and proofs for small finite models, with a theorem stated independently of the implementation.

This is a synthetic laboratory, not a replacement for Lean certification of analytic identities.

## Workstream K — Lean 4 certification

Prioritize finite exact statements that are algebraic and convention-sensitive:

1. pair-field identity and reflection transforms;
2. two-circle polynomial rigidity in a finite algebraic form;
3. LCM-convolution spectral idempotents;
4. canonical kernel formulas;
5. affine peel determinant invariance;
6. CRT residue and additive reciprocity identities;
7. parity Bezoutian block decomposition and resultant square;
8. finite Hahn reflection/eigenvalue/Dirichlet-form statements;
9. type-`A` primitive dimensions and permutation traces.

A theorem reaches `V3` only when it passes with zero `sorry`s in the repository’s pinned Lean/mathlib environment.

---
# 21. Long-running agent operating protocol

## 21.1 Startup sequence

On entering a Claude Code or Codex session:

1. Read this handoff completely.
2. Inspect the repository `avikj/math` if connected; locate current branch, uncommitted work, tests, notebooks, formalizations, and the missing external handoff.
3. Search for newer deltas that supersede this August 11 state.
4. Reproduce at least one exact theorem adjacent to the chosen workstream before attempting novelty.
5. Select the highest-value unblocked theorem, not the broadest vision statement.
6. Work continuously through proof, exact computation, literature search, and falsification. Do not stop after producing a plan.

## 21.2 Smallest-theorem loop

Repeat this loop:

1. **State one precise lemma.** Include every quantifier, domain, normalization, and endpoint.
2. **Find the nearest prior art.** Search exact formulas and operator names, not just conceptual keywords.
3. **Attempt a symbolic derivation.** Track constants and signs.
4. **Attempt a counterexample.** Search edge cases and small exact instances before investing in a proof.
5. **Compute exactly where finite.** Prefer integers, rationals, algebraic numbers, interval arithmetic, or certified symbolic output.
6. **Prove or kill.** A sharp no-go is a result.
7. **Record the delta.** Include impact on every dependent branch.
8. **Move immediately to the next smallest lemma.**

## 21.3 Evidence discipline

### Written proof

A written proof must be locally checkable. “By standard arguments” is acceptable only when the precise standard theorem and hypotheses are named.

### Independent replication

Replication should use a genuinely different derivation, implementation, or agent. Merely rerunning the same symbolic script is not independent.

### Exact arithmetic

Store machine-readable certificates. Examples:

- factorization and resultant certificates;
- Smith normal form matrices;
- exact Hahn coefficients;
- rational CRT residues;
- finite modular averages;
- commutator matrices equal to zero;
- interval-certified inequalities.

### Numerical evidence

Numerics must state:

- object and normalization;
- range and sampling rule;
- precision and library versions;
- seed if randomized;
- control models;
- expected asymptotic scale;
- what would falsify the pattern.

### Formal proof

Pin the theorem-prover environment. A theorem with hidden axioms, admitted lemmas, or version-dependent failures is not `V3`.

## 21.4 Literature-search protocol

Before asserting novelty:

1. search the exact formula in multiple notations;
2. search the operator class and the arithmetic application separately;
3. search historical terminology;
4. inspect references of the closest paper;
5. distinguish “identity known” from “placement/application known”;
6. record negative search results and databases used;
7. never use an LLM’s uncited memory as novelty evidence.

When a current or niche source matters, verify it directly. For technical work, prefer original papers, monographs, and official documentation.

## 21.5 Branch management

Keep each branch in one of five states:

- `ACTIVE`: exact next lemma identified;
- `BLOCKED`: dependency named precisely;
- `CONDITIONAL`: theorem proved assuming a stated hypothesis;
- `KILLED`: exact counterexample/no-go stored;
- `DORMANT`: conceptually interesting but no theorem-producing mechanism.

Do not leave branches in “interesting analogy” limbo.

## 21.6 Suggested repository layout

Use or adapt this structure without destroying existing organization:

```text
research/
  PRIME_PAIR_FIELD_AGENT_HANDOFF_2026-08-11.md
  state/
  deltas/
  proofs/
  literature/
    bibliography.md
    prior_art_searches/
  experiments/
    exact/
    numerical/
    controls/
  operators/
    crt_boundary/
    hahn/
    prolate/
    transfer/
  geometry/
    igusa/
    type_a/
    factorization_space/
  formal/
    lean/
    cubical_agda/
  certificates/
  scripts/
```

Do not create duplicate “final” files. Update the canonical state only after a delta survives review.

## 21.7 Delta template

```markdown
# PRIME-PAIR RESEARCH DELTA — <short exact title>

Date:
Agent/session:
Repository commit:

## STATUS
VERIFIED EXACT / KNOWN PRIOR ART / NOVELTY CANDIDATE /
NUMERICAL / KILLED BRANCH / LIVE FRONTIER

## STATEMENT
All hypotheses and conventions.

## PROOF OR CERTIFICATE
Complete derivation or reproducible artifact path.

## INDEPENDENT CHECK
Different derivation, exact computation, or formal proof status.

## PRIOR ART
Closest sources and exact distinction.

## CONSEQUENCES
Which canonical statements change; which do not.

## FAILURE MODES
Edge cases, conditioning, aperture, unresolved ranges.

## NEXT SMALLEST LEMMA
One precise target.
```

## 21.8 Mathematical hygiene checklist

Before accepting a result, check:

- Is this `1_P` or `Lambda`? Are prime powers contaminating the statement?
- Is `z=0` a grand-canonical vacuum, a desingularized tangent, or an exact coefficient?
- Is the local measure conditioned on roughness or unconditioned Haar/KMS?
- Is the operator bilateral, Hardy-positive, or finite-interval?
- Is reflection unitary in the space being used?
- Is the divisor kernel `mu`, `a_z`, `c_z`, `q_r`, or `kappa_r`?
- Is the theorem for independent linear forms or the needed parallel shifts?
- Is a fixed angular mode being mistaken for a growing aperture?
- Is a finite-place identity being promoted to a positive-integer theorem?
- Is a numerical sign stable under normalization and precision?
- Is an apparent new structure already classical representation theory or orthogonal-polynomial theory?
- Does a reconstruction theorem include conditioning?

## 21.9 Failure is informative

The program has advanced substantially through corrections. An agent should aggressively seek:

- counterexamples to overbroad positivity;
- homotopies that kill proposed topological invariants;
- spectral rank calculations that expose lost information;
- asymptotic aperture lower bounds;
- local/global distinctions;
- exact points where known estimates cease to save a power.

A branch-killing theorem is preferable to months of decorative analogy.

---

# 22. Ready-to-paste bootstrap prompt for Claude Code or Codex

Copy the following prompt into a new long-running session together with this document:

```text
You are joining the Prime-Pair Field / additive–multiplicative arithmetic
research program. Treat the attached handoff as the canonical self-contained
state as of 2026-08-11, subject to any newer proved delta you find in the repo.

Your job is to perform autonomous theorem-producing research, not to summarize
the document or stop after a plan.

First inspect the repository, branch, tests, notes, exact computations, and
formalizations. Locate the missing user external-state handoff if it exists.
Do not overwrite uncommitted work. Then choose the highest-value unblocked
workstream and reproduce one adjacent exact statement independently before
extending it.

Evidence labels must be explicit:
VERIFIED EXACT, KNOWN PRIOR ART, NOVELTY CANDIDATE, NUMERICAL,
KILLED BRANCH, or LIVE FRONTIER. Never upgrade a result because it sounds
conceptually compelling. Track every constant, sign, normalization, charge
convention, and prime-indicator/von-Mangoldt distinction.

Critical corrections you must preserve:
- full heat-resolved autocorrelation is reconstructive; phase loss appears
  after radial compression;
- full divisibility data determines Omega; the sieve obstruction is
  finite-scale/large-prime coherence;
- exact primes are the canonical charge-one projector q_1 or the tangent c_0,
  with twisted symbol P_chi/L, not the grand-canonical Mobius endpoint 1/L;
- Liouville charge parity and Hahn reflection parity are distinct;
- ordinary complex K-theory cannot detect the Liouville gauge endpoint;
- fixed Hahn degree cannot solve the sharp problem; aperture must grow;
- small denominator rational modes usually have high Hahn degree;
- generic log-concavity of raw Hahn energies is false.

For each research cycle:
1. state the smallest precise lemma;
2. search exact prior art;
3. derive it symbolically;
4. try to falsify it with exact finite cases;
5. prove, certify, or kill it;
6. save a delta and reproducible artifacts;
7. continue immediately to the next lemma.

Priority targets are:
(1) exact canonical CRT/Kloosterman boundary with q_1 and P_chi/L;
(2) shifted/parallel charge Selberg–Delange toward z~1/loglog X;
(3) exact Ramanujan–Hahn transform and microlocal rational-beam projector;
(4) inverse theorem for residual angular parity discrepancy;
(5) Hahn/Jacobi/Meixner simplex-prolate operator or no-go;
(6) type-A multileg analytic theorem;
(7) universal punctured-line motivic/factorization object;
(8) graded transfer/Hankel invariants;
(9) A-double-prime factor frontier after recovering its exact definition;
(10) Lean/Cubical-Agda certification of finite exact statements.

Do not stop merely because a problem is open. Produce the strongest correct
partial theorem, no-go, exact computation, or reduction available in the
current session, and leave the repo in a strictly more informative state.
```

---

# 23. Prior-art anchors already identified in the library

This is a search map, not a complete bibliography. Verify editions, theorem numbers, and current literature before publication.

## Additive prime pairs and zero sums

- Egami–Matsumoto: analytic continuation/natural boundaries for Goldbach generating functions.
- Bhowmik–Schlage-Puchta: natural boundaries and Goldbach Dirichlet series.
- Brüdern–Kaczorowski–Perelli: Goldbach average and zeta zeros.
- Languasco–Zaccagnini: Cesàro/Riesz weighted Goldbach explicit formulas.
- Matsumoto–Suzuki: screw functions and RH-equivalent positivity in the one-zero sector.

## Ramanujan and sieve spectrum

- Gadiyar–Padma and related Ramanujan–Fourier/Wiener–Khintchine formulations.
- Classical Hardy–Littlewood singular series.
- Selberg sieve, linear sieve, beta sieve, and parity problem literature.
- Linnik dispersion, Deshouillers–Iwaniec, Kuznetsov, spectral large sieve.
- Bettin–Chandee trilinear Kloosterman-fraction bounds.

## Multiplicative functions and charge asymptotics

- Selberg–Delange, Sathe–Selberg, Erdős–Kac.
- Shiu/Nair–Tenenbaum/Henriot bounds for multiplicative functions on shifted or polynomial arguments.
- Green–Tao/Matthiesen-type linear forms results, with the important nonparallel-forms caveat.
- Tao entropy decrement and logarithmic Chowla-type methods.

## Operator algebras and arithmetic systems

- Bost–Connes system.
- Cuntz arithmetic `ax+b` algebra and boundary quotients.
- Laca–Raeburn/semigroup Toeplitz frameworks.
- Spera and related zeta/eta spectral triples.
- Connes–Consani quasi-inner, Sonin, prolate, and explicit-formula constructions.

## Phase retrieval and systems theory

- Homometric sets and one-dimensional phase retrieval.
- Kronecker finite-rank Hankel theorem.
- Nehari and Adamyan–Arov–Krein theory.
- Rational all-pass/lossless realization.
- Bezoutians, Hankel inverses, Routh–Hurwitz, continued fractions.
- Integral/unimodular polynomial systems and `SL_2(Z[x])`.

## Orthogonal polynomials and representation theory

- Meixner processes and Meixner–Pollaczek polynomials.
- Koelink–Van der Jeugt on `SU(1,1)` convolutions/Clebsch–Gordan coefficients.
- Grünbaum on time-band limiting and the Meixner–Pollaczek open problem.
- Hahn, continuous Hahn, Jacobi, Racah, algebraic-Heun, and bispectral theory.
- Slepian/Landau/Pollak and multidimensional prolate theory.

## Local zeta and geometry

- Igusa local zeta functions.
- Hironaka resolution and Denef–Loeser motivic zeta/nearby cycles.
- De Concini–Procesi wonderful models of arrangements.
- Huh/Adiprasito–Huh–Katz combinatorial Hodge theory.
- Ngô-style geometrization/support methods.
- Beilinson–Drinfeld factorization spaces and Ran space.
- Type-`A` braid arrangements and invariant theory.

## Formal and categorical directions

- Hall algebras of finite-length modules.
- `K_0` of finite abelian groups / Jordan–Hölder length.
- Cubical Agda and higher-inductive quotients for finite observability models.
- Lean 4/mathlib for exact algebraic certification.

---
# 24. Truth-status map

## 24.1 Exact/proved within the library

The following are the most consequential exact results, subject to independent replication/formalization status:

- pair-field and `S²-D²=4Q` identities;
- sum/gap Fourier relation `A²` versus `|A|²`;
- reconstruction from two heat circles or one circle plus radial derivative;
- exponential instability of interior heat reconstruction;
- Toeplitz/Hankel reflection decomposition;
- minimal homometric all-pass factorization and exact Hankel ranks;
- Laplace–Mellin transform to `-zeta'/zeta`;
- critical BC/KMS local factor and `beta=1` criticality;
- finite-adic Goldbach/gap equality;
- finite sieve projection and one-body Buchstab factor;
- charge-deformed Buchstab recursion and convolution semigroup;
- first-window Walsh reconstruction of primes;
- full divisibility reconstruction of `Omega` and simple-or-zero tail;
- canonical charge idempotents under LCM convolution;
- exact prime divisor kernel `q_1` and twisted symbol `P_chi/L`;
- local Igusa integral and collision-tree recursion;
- all-depth two-leg parity factor and unique `p=3` annihilation;
- Walsh hypercube spectrum and prime-indexed heat flow;
- affine peel determinant invariance and fixed-determinant state space;
- CRT equilibrium-plus-boundary decomposition;
- forced modular inverse phases and character diagonalization;
- smoothed square-root localization and Hermitian normalization;
- center/rapidity coordinates and beta kernel;
- Meixner density/convolution and Meixner–Pollaczek recurrence;
- finite Hahn operator, reflection parity, Dirichlet form, and alternating energy identity;
- fixed-band aperture no-go;
- rational-character-to-Bessel-beam relation and singular-series antipodal trace;
- type-`A` primitive-space/Casimir decomposition;
- universal punctured-line point count and associative charge fusion;
- ordinary K-theory no-go;
- pure-creation differential no-go;
- parity Bezoutian block decomposition and integral unimodularity conditional on the preserved canonical factor theorem.

## 24.2 Conditional meta-theorems

- boundary-layer normal-family rigidity implies Hardy–Littlewood once its analytic hypotheses are proved;
- the `1/log N` Hahn energy imbalance uses Hardy–Littlewood pointwise asymptotics;
- any positivity transfer from a constructed prolate/canonical system would depend on proving the exact trace comparison;
- factor-branch integral unimodularity uses the source’s canonical resultant divisibility theorem, whose original external statement should be recovered.

## 24.3 Main conjectures/targets

- many-body Buchstab boundary factorization `kappa_H -> 1`;
- shifted/parallel-form Selberg–Delange uniform to `z~1/loglog X`;
- expected-order positive-real charge bounds for normal-family rigidity;
- complete canonical CRT/Kloosterman boundary control;
- Ramanujan–Hahn microlocal inverse theorem;
- arithmetic simplex/Meixner prolate commuting operator;
- type-`A` theorem explaining ternary gain;
- adelic factorization-space/relative-trace theorem;
- graded transfer/scattering invariant retaining charge and Hankel data;
- all-degree A-double-prime factor exclusion;
- epsilon-variance closure after provenance recovery.

## 24.4 What a breakthrough would look like

A genuinely major advance need not immediately prove Goldbach. Any of the following would change the field-level picture:

1. a shifted parallel-form Selberg–Delange theorem in an `X`-dependent charge range;
2. a power-saving estimate for the exact `q_1` CRT/Kloosterman boundary beyond existing arbitrary-coefficient technology;
3. an exact Ramanujan–Hahn transform plus inverse theorem classifying all large parity discrepancy;
4. a new simplex/Meixner prolate commuting operator tied to the Goldbach Weil form;
5. an all-degree integral all-pass factor exclusion for the sparse prime polynomial;
6. a global relative-trace/support theorem joining finite Igusa and archimedean beta/Hahn data;
7. a rigorous theorem explaining why the three-leg type-`A` primitive structure yields an analytic smoothing advantage unavailable at two legs.

---

# 25. Materialized source manifest

The handoff was distilled from these 27 Markdown files.

## Canonical state and navigation

1. `PRIME_PAIR_RESEARCH_LIBRARY_INDEX.md` — precedence, corrections, architecture, priorities, verification ladder.
2. `PRIME_PAIR_RESEARCH_STATE.md` — canonical cross-thread state, base identities, BC/Cuntz field, Buchstab, Atiyah/Hirzebruch and Farey branches.
3. `PRIME_PAIR_RESEARCH_STATE_DELTA_2026-08-11.md` — charge-deformed state, boundary layer, affine determinant.
4. `Arithmetic Research Ledger.md` — loss-resistant exact/prior-art/dead-branch ledger and binary/ternary smoothing threshold.

## Charge, divisor, and CRT boundary deltas

5. `PRIME_PAIR_RESEARCH_DELTA_2026-08-11.md` — exact charge Buchstab and shifted Selberg–Delange target.
6. `PRIME_PAIR_RESEARCH_DELTA2_2026-08-11.md` — determinant as complete two-leg local invariant and Smith-normal-form state space.
7. `PRIME_PAIR_RESEARCH_DELTA3_2026-08-11.md` — translation quotient and localization of coupling at primes dividing `h`.
8. `PRIME_PAIR_RESEARCH_FANOUT_DELTA_2026-08-11.md` — p-adic dendrograms, divisor lattice, branch triage, global boundary refocus.
9. `PRIME_PAIR_BOUNDARY_OPERATOR_DELTA_2026-08-11.md` — exact CRT boundary and forced inverse phases.
10. `PRIME_PAIR_CHARGE_BOUNDARY_DELTA_2026-08-11.md` — grand-canonical charge divisor transform; later corrected at the exact-prime endpoint.
11. `PRIME_PAIR_CHARGE_CHARACTER_SPECTRAL_DELTA_2026-08-11.md` — character diagonalization and fractional inverse-`L` charge flow.
12. `PRIME_PAIR_CANONICAL_CHARGE_CORRECTION_2026-08-11.md` — fixed-charge kernels, symmetric-power numerators, exact canonical correction.
13. `PRIME_PAIR_CHARGE_PROJECTOR_DELTA_2026-08-11.md` — LCM idempotents, operator prime projector, triple boundary spectrum, rigidity meta-theorem.
14. `PRIME_PAIR_DIVISOR_LATTICE_TWO_CHARGE_DELTA_2026-08-11.md` — characteristic polynomial and distinct/repeated-prime charge split.
15. `PRIME_PAIR_SMOOTHED_BOUNDARY_HERMITIAN_DELTA_2026-08-11.md` — Poisson localization, square-root boundary, Hermitian Kloosterman blocks.

## Cross-mathematics / Fields-Medal layers

16. `PRIME_PAIR_FIELDS_MEDAL_LENS_DELTA_2026-08-11.md` — Reconstruction/Obstruction/Positivity organizing layer.
17. `PRIME_PAIR_FIELDS_MEDAL_DELTA_02_2026-08-11.md` — K-theory no-go, `K_0(FinAb)`, Igusa geometry, all-depth parity factor.
18. `PRIME_PAIR_FIELDS_MEDAL_DELTA_03_2026-08-11.md` — Walsh heat flow, entropy, mutual information, Hall/Hecke/configuration structure.
19. `PRIME_PAIR_FIELDS_MEDAL_DELTA_04_2026-08-11.md` — two-temperature reconstruction, Toeplitz/Hankel, prime Fock, beta/simplex, prolate target.
20. `PRIME_PAIR_FIELDS_MEDAL_DELTA_05_2026-08-11.md` — stability, AAK, all-pass systems, parity Bezoutian, A-double-prime route.
21. `PRIME_PAIR_FIELDS_MEDAL_DELTA_06_2026-08-11.md` — Meixner density, Meixner–Pollaczek, named prolate problem, exact homometric ranks.
22. `PRIME_PAIR_FIELDS_MEDAL_DELTA_07_2026-08-11.md` — `SU(1,1)` tensor decomposition, beta–Jacobi–continuous-Hahn transform.
23. `PRIME_PAIR_FIELDS_MEDAL_DELTA_08_2026-08-11.md` — finite Hahn Goldbach geometry, charged-angular partition function, primitive decomposition.
24. `PRIME_PAIR_FIELDS_MEDAL_DELTA_09_2026-08-11.md` — one-log imbalance, fixed-band no-go, Cramér calibration, log-concavity counterexamples.
25. `PRIME_PAIR_FIELDS_MEDAL_DELTA_10_2026-08-11.md` — rational Bessel beams and Ramanujan–Hahn microlocal geometry.
26. `PRIME_PAIR_FIELDS_MEDAL_DELTA_11_2026-08-11.md` — type-`A` multileg Casimir, primitive multiplicities, binary/ternary structure.
27. `PRIME_PAIR_FIELDS_MEDAL_DELTA_12_2026-08-11.md` — universal punctured line, factorization fusion, motivic/nearby-cycle target.

## Missing referenced source

- `User external state v1, 2026-08-11` — referenced by the index but not materialized. Recover from the repository or prior conversation export before formal work on its verbatim theorem labels, seven named targets, exact prime-polynomial definition, or epsilon-variance closure.

---

# 26. Final distilled research thesis

The strongest coherent statement of the program is:

> Prime-pair hardness appears after several exact, individually tractable structures are pushed to a simultaneous boundary. Finite-adic local equilibrium is encoded by Igusa/singular-series factors; factorization depth is diagonalized by canonical charge projectors and Buchstab flow; additive geometry on a fixed sum is diagonalized by Hahn/continuous-Hahn modes; and finite-interval lifting produces a CRT boundary with modular inverse spectrum. Exact primes require the charge-one tangent, while Goldbach requires sharp antipodal angular evaluation on the positive cone with an aperture growing to prime scale. The unresolved theorem is to control their coupled boundary after all local, one-body, and rationally structured components are removed.

The project should now be judged by whether it can convert that localization into one of three things:

1. a new analytic estimate;
2. a new reconstructive/inverse theorem;
3. a new operator or geometric trace theorem with a forced sign.

Everything else is supporting structure.

