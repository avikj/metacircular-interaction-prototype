# Prime Pair Field — Fields-Medal / Cross-Mathematics Delta 05

Date: 2026-08-11  
Status: research delta. Exact claims are marked **V1** when proved here. Standard operator/algebra facts are marked **KNOWN PRIOR ART**. Proposed arithmetic uses remain targets. This file supplements, but does not overwrite, the canonical state or Deltas 01–04.

## 0. Executive changes

Three corrections sharpen the Reconstruction and Obstruction master problems.

1. **Set-theoretic injectivity is nearly vacuous.** A single real heat moment can encode an entire finite binary sequence, but only with exponentially bad conditioning. The relevant notion is stable, scale-local reconstruction with a controlled inverse norm.

2. **The finite obstruction to one-circle phase reconstruction is a rational all-pass/Hankel defect.** Its canonical invariants are Hankel rank and singular values (McMillan degree and AAK spectrum), not ordinary K-theory. Two heat circles force this defect to vanish.

3. **The polynomial parity resultant is literally the determinant of the same finite Hardy-system defect.** For real `g`, the ratio `g(-s)/g(s)` is all-pass on the imaginary axis; its parity Bezoutian block-diagonalizes in the even/odd basis. This gives an operator-theoretic proof of the square resultant formula and a new route into the factor frontier via integral lossless realizations.

---

## 1. V1: one scalar can be informationally complete but exponentially unstable

Let

\[
a=(a_0,\ldots,a_N),
\qquad a_n\in\{0,1\},
\]

and let `0<q<1/2`. Define the single heat moment

\[
M_q(a)=\sum_{n=0}^N a_n q^n.
\]

### Theorem

The map `a -> M_q(a)` is injective. More quantitatively, if `a\ne b`, then

\[
|M_q(a)-M_q(b)|
\ge
q^N\frac{1-2q}{1-q}.
\]

### Proof

Let `k` be the least index at which `a_k\ne b_k`. The leading difference has magnitude `q^k`, while the entire tail can cancel by at most

\[
\sum_{n>k}q^n=\frac{q^{k+1}}{1-q}.
\]

Therefore

\[
|M_q(a)-M_q(b)|
\ge
q^k\left(1-\frac q{1-q}\right)
=
q^k\frac{1-2q}{1-q}
\ge
q^N\frac{1-2q}{1-q}.
\]

QED.

### Bounded-digit generalization

If `a_n in {0,1,...,M}` and

\[
q<\frac1{M+1},
\]

then the same leading-digit argument gives injectivity and

\[
|M_q(a)-M_q(b)|
\ge
q^N\frac{1-(M+1)q}{1-q}.
\]

### Arithmetic interpretation

For a binary sequence,

\[
C_0(t)=\sum_n a_n^2e^{-2tn}=M_{e^{-2t}}(a).
\]

Thus a **single scalar** `C_0(t)` already determines every finite binary support if `e^{-2t}<1/2`.

This is mathematically exact and analytically almost useless: the minimum separation is exponentially small in `N`. Any inverse procedure robust to absolute noise `epsilon` needs

\[
\epsilon\ll q^N.
\]

The inverse condition number is at least of order `q^{-N}`.

### Required correction to the master problem

Do not use “informationally complete” as the success criterion by itself. A valid arithmetic reconstruction theorem should specify at least:

- the topology/norm on states and observations;
- the aperture dependence of the inverse modulus of continuity;
- locality across prime/heat scales;
- precision required to recover the residual charge bit;
- whether the inverse condition number is polynomial, stretched exponential, or exponential.

Without such requirements, a real number can hide an arbitrary finite combinatorial object and the reconstruction statement becomes a coding tautology.

---

## 2. V1: fixed interior heat probes necessarily lose high-index information exponentially

Let

\[
A(z)=\sum_{n=0}^N a_nz^n.
\]

Changing only the top coefficient by `delta` changes the value on `|z|=r<1` by

\[
\delta A(re^{i\theta})=\delta r^Ne^{iN\theta}.
\]

Consequently the modulus-squared observation changes by at most

\[
\bigl||A+\delta r^Ne^{iN\theta}|^2-|A|^2\bigr|
\le
2|A|\,|\delta|r^N+|\delta|^2r^{2N}.
\]

Any locally Lipschitz inverse from modulus data on circles bounded by `r<1` must therefore have norm at least of exponential order `r^{-N}` along suitable directions.

Writing `r=e^{-t}`, polynomially bounded inversion `N^C` requires at least

\[
e^{-tN}\gtrsim N^{-C},
\]

hence

\[
\boxed{t\lesssim C\frac{\log N}{N}.}
\]

Thus stable recovery to aperture `N` forces the heat circles toward the sharp boundary at near-`1/N` scale. This is a precise analytic reason that deep heat smoothing trivializes the arithmetic while sharp cutoff remains hard.

The two-temperature theorem of Delta 04 proves uniqueness at any two distinct radii, but if both radii stay bounded away from `1`, the inverse is exponentially ill-conditioned. The correct next theorem is quantitative two-circle stability in the near-boundary scaling regime.

---

## 3. V1 / KNOWN PRIOR ART: one-circle ambiguity is a rational all-pass transfer function

Let `A,B` be nonzero polynomials satisfying

\[
|A(e^{i\theta})|=|B(e^{i\theta})|
\qquad\text{for all }\theta.
\]

After cancelling common factors, define

\[
R(z)=\frac{B(z)}{A(z)}.
\]

Then

\[
|R(e^{i\theta})|=1.
\]

Hence `R` is a rational all-pass function on the circle: a quotient of finite Blaschke products times a monomial/unimodular constant.

Let

\[
H_R=P_-M_RP_+
\]

be its Hardy Hankel block.

### Kronecker/Hankel defect

By the classical Kronecker theorem, `H_R` has finite rank, equal to the McMillan degree of the antianalytic rational part—equivalently, the number of uncancelled poles of `R` in the disk, counted with multiplicity. Similarly, `H_{\overline R}` counts the complementary zero defect.

Define the phase-defect pair

\[
\delta(A,B)
=
\bigl(\operatorname{rank}H_R,
      \operatorname{rank}H_{\overline R}\bigr).
\]

Then:

- `delta=(0,0)` iff `A=cB` up to the trivial monomial/phase convention;
- the winding number remembers only the **difference** of the two ranks;
- the pair of ranks remembers the total finite zero-flip content;
- the nonzero Hankel singular values refine rank to a stable metric of the ambiguity.

This is a more faithful finite obstruction than an ordinary K-class. Ordinary Toeplitz K-theory sees stable winding/index; the Hankel defect sees the actual off-diagonal phase completion.

### Two circles kill the defect

If the same rational `R` is unimodular on two distinct concentric circles, Delta 04's divisor argument forces `R` to be a unimodular constant. Therefore every nonzero Hankel singular value disappears. Two heat slices do not merely choose among ambiguities; they force the all-pass defect system to have McMillan degree zero.

---

## 4. Exact example: the minimal homometric pair is a finite all-pass factor flip

For the established minimal homometric pair

\[
A_0=\{0,1,2,6,8,11\},
\qquad
B_0=\{0,1,6,7,9,11\},
\]

let

\[
P_A(x)=\sum_{n\in A_0}x^n,
\qquad
P_B(x)=\sum_{n\in B_0}x^n.
\]

Exact factorization gives

\[
P_A(x)
=(x^2+1)(x^4+x+1)(x^5-x^3+1),
\]

\[
P_B(x)
=(x^2+1)(x^4+x+1)(x^5-x^2+1).
\]

The differing factors are reciprocal:

\[
x^5\left[(x^{-5}-x^{-2}+1)\right]
=x^5-x^3+1.
\]

Thus

\[
\frac{P_B(x)}{P_A(x)}
=
\frac{x^5-x^2+1}{x^5-x^3+1}
\]

is a rational all-pass quotient on the unit circle. Homometry is literally a finite reciprocal-factor flip. The associated Hardy Hankel defect has finite degree at most five and is annihilated by any second distinct heat circle.

This example should become the canonical finite test for the AAK stability program.

---

## 5. V1: polynomial sign parity is an all-pass system on the imaginary axis

Let `g in R[x]` be a real polynomial and define

\[
\Theta_g(s)=\frac{g(-s)}{g(s)}.
\]

For `s=iy`,

\[
g(-iy)=\overline{g(iy)},
\]

so wherever defined,

\[
\boxed{|\Theta_g(iy)|=1.}
\]

Thus the involution `s -> -s` produces a rational all-pass transfer function for the right/left half-plane Hardy polarization.

Its poles in the chosen Hardy half-plane are the roots of `g` there, except for cancellations by opposite root pairs. Its finite Hankel rank is the uncancelled half-plane McMillan degree.

### Cancellation criterion

The following are equivalent:

1. `g` and `g(-x)` have a common root;
2. `g` has a root pair `{alpha,-alpha}` (including `alpha=0`);
3. `Theta_g` has pole-zero cancellation;
4. `Res(g(x),g(-x))=0`;
5. the parity Bezoutian below is singular.

Therefore the resultant used in the factor-rigidity branch is exactly the nondegeneracy determinant of the finite parity all-pass realization.

---

## 6. V1: the parity Bezoutian block-diagonalizes into the even and odd sectors

Write

\[
g(x)=E(x^2)+xO(x^2).
\]

Let the Bezoutian kernel be

\[
\mathcal B_g(x,y)
=
\frac{g(x)g(-y)-g(y)g(-x)}{x-y}.
\]

Put `X=x^2`, `Y=y^2`. Direct expansion gives

\[
g(x)g(-y)-g(y)g(-x)
=
2\bigl[xO(X)E(Y)-yO(Y)E(X)\bigr].
\]

Multiplying numerator and denominator by `x+y` yields

\[
\boxed{
\mathcal B_g(x,y)
=
2\frac{XO(X)E(Y)-YO(Y)E(X)}{X-Y}
+
2xy\frac{O(X)E(Y)-O(Y)E(X)}{X-Y}.
}
\]

There are no even–odd cross terms. In the monomial basis ordered by parity, the Bezout matrix is block diagonal:

\[
\boxed{
B(g,g(-x))
\simeq
2B(XO,E)\oplus 2B(O,E),
}
\]

with the evident degree padding and sign convention.

This is the exact finite-dimensional operator manifestation of the `Z/2` decomposition.

### Determinant square

The determinant of a Bezout matrix is, up to the standard sign/leading-coefficient convention, the resultant. Taking determinants of the two parity blocks gives

\[
\operatorname{Res}(g(x),g(-x))
=
\pm 2^{\deg g}\,g(0)\,\operatorname{Res}(E,O)^2.
\]

For the monic constant-term-one factors relevant to `F_X`, this reduces to

\[
\boxed{
\operatorname{Res}(g,g(-x))
=
\pm2^{\deg g}\operatorname{Res}(E,O)^2.
}
\]

This supplies a structural proof of the convention-sensitive identity already present in the canonical state: the square is forced because the full parity Bezoutian splits into two companion even/odd blocks with the same resultant content.

---

## 7. V1 consequence for the factor frontier: the even/odd pair is integral-unimodular

The canonical factor theorem gives, for a nondegenerate monic factor `g` of the prime polynomial,

\[
\operatorname{Res}(g,g(-x))\mid 2^{\deg g}.
\]

Combining this with the square formula gives

\[
\operatorname{Res}(E,O)^2\mid1.
\]

Hence

\[
\boxed{\operatorname{Res}(E,O)=\pm1.}
\]

Equivalently, there exist integer polynomials `U,V` satisfying the Bezout identity

\[
U(x)E(x)+V(x)O(x)=1.
\]

Thus every surviving non-cyclotomic factor candidate determines:

- an integral unimodular row `(E,O)`;
- an invertible integer parity Bezoutian;
- a finite rational all-pass system with minimal dyadic determinant;
- an integer Hankel/realization matrix after the standard Bezoutian–Hankel inversion.

This is substantially more structured than an arbitrary irreducible polynomial factor.

### New attack on Conjecture A-double-prime

Replace degree-by-degree coefficient elimination by classification of **integral lossless parity systems** compatible with the sparse prime polynomial:

1. enumerate possible unimodular even/odd pairs `(E,O)` via their polynomial Euclidean/continued-fraction realization;
2. use the integer Smith normal form of the two Bezout blocks;
3. constrain their Hankel recurrence / McMillan realization;
4. impose that `E(x^2)+xO(x^2)` divides `F_X`;
5. exploit the long prime-gap zero strings against the finite recurrence.

The hope is that a low-degree factor corresponds to a finite-state all-pass recurrence, while the growing prime-gap chains force an arbitrarily long forbidden zero pattern. This may provide a system-theoretic version of the lacunary-factor argument with sharper finite-degree certificates.

No all-degree theorem is claimed yet.

---

## 8. KNOWN PRIOR ART / PROJECT USE: Bezoutian inverse, Hankel realization, and continued fractions

Classical Bezoutian/Hankel realization theory provides:

- `det B(f,g)=Res(f,g)`;
- nonsingular Bezoutians have Hankel-structured inverses under standard normalizations;
- finite-rank Hankel matrices are equivalent to rational transfer functions (Kronecker);
- the rank is the McMillan degree;
- the Euclidean algorithm / continued fraction of a rational function gives a minimal realization;
- Bezoutian signatures encode half-plane root counts in Routh–Hurwitz-type theory.

For the program, the relevant rational function is not arbitrary:

\[
\Theta_g(s)=g(-s)/g(s),
\]

and the relevant integral pair is `(E,O)` with resultant `plus or minus 1`.

This is exactly the setting where network-synthesis/lossless-system methods may be stronger than generic polynomial factorization. The literature should be searched under:

- rational all-pass / lossless bounded-real realization;
- even–odd polynomial parts and Hurwitz/Routh continued fractions;
- Bezoutian storage functions;
- integral or dyadic lossless lattices;
- unimodular polynomial rows and `SL_2(Z[x])`.

---

## 9. AAK singular values as a quantitative obstruction spectrum

Rank is only a discrete obstruction. AAK theory associates to a compact Hankel block a sequence of singular values

\[
s_1\ge s_2\ge\cdots\downarrow0,
\]

where `s_{n+1}` is the optimal error of approximation by a Hankel operator of rank at most `n`.

This gives a natural hierarchy for arithmetic reconstruction:

- exact finite homometry: finitely many nonzero singular values;
- near-homometry / noisy heat data: small trailing singular values;
- quasi-inner local-factor systems: compact infinite Hankel spectrum;
- exact inner symmetry: zero off-diagonal defect;
- unstable phase recovery: singular values near the observation noise floor.

### Candidate arithmetic invariant

For aperture `X`, define the **phase-defect spectrum** of a compatible gap observation as the singular spectrum of the minimal Hankel completion needed to realize the candidate Goldbach phase.

Questions:

1. Does the prime/von-Mangoldt sequence have a spectral gap separating its true Hankel completion from zero-flipped alternatives once a near-boundary heat derivative is supplied?
2. Is the aperture law in Theorem B equivalent to decay of these singular values?
3. Does Liouville charge occupy a distinguished Schmidt subspace?
4. Can the local `Phi_2` annihilation derivative be identified with the first nonzero Hankel singular direction?
5. Does the prolate transition band control the AAK spectrum of the simplex compression?

These are concrete finite computations before they are theorem claims.

---

## 10. Stable reconstruction should replace bare reconstruction in the three-master-problem architecture

The master problem should now be stated as follows.

### Stable Reconstruction

Given a scale-filtered arithmetic state `x` and observations `O_X(x)`, determine:

1. the exact ambiguity fiber;
2. a normed/topological model of the fiber;
3. the smallest extra observation restoring injectivity;
4. the inverse modulus of continuity as `X -> infinity`;
5. whether recovery is local under scale refinement;
6. whether the condition number is compatible with available analytic error terms.

### Dynamical/Hankel Obstruction

If stable reconstruction fails, identify:

- finite McMillan/Hankel rank in exact finite models;
- compact Hankel singular spectrum in limiting models;
- charge-sensitive eta/determinant/scattering data;
- only then, if genuinely functorial, a graded/equivariant K-theory class.

### Positivity

Seek a norm or canonical-system pairing in which the relevant Hankel/simplex completion has a forced sign. Bare positivity of the neutral Toeplitz symbol is insufficient because it has already forgotten the inner phase.

---

## 11. Revised priority list

1. **Promote stability into every reconstruction target.** Reject set-theoretic encodings with exponential inverse cost as explanatory solutions.
2. **Formalize the phase-defect rank theorem** and compute it for the minimal homometric pair and prime-prefix examples.
3. **Promote the parity Bezoutian block decomposition** into the canonical A-prime factor machinery; independently replicate signs and degree conventions.
4. **Search integral lossless/all-pass realization theory** for a classification of unimodular even/odd polynomial pairs.
5. **Use Smith normal forms and Hankel recurrences** to extend the degree-eight factor frontier.
6. **Compute AAK spectra** for truncated prime indicators, von Mangoldt weights, homometric controls, and random controls.
7. **Compare AAK transition scales with prolate/Sonin spectra** from the simplex concentration operator.
8. Continue graded/equivariant operator work, but do not return to ordinary K-theory of the Liouville endpoint twist.

---

## 12. Verification discipline and literature anchors

### Exact V1 results in this delta

- one-scalar binary heat encoding and exponential separation bound;
- necessary near-boundary scaling for polynomially stable coefficient recovery;
- rational all-pass form of one-circle ambiguity;
- exact reciprocal-factor description of the minimal homometric pair;
- imaginary-axis all-pass identity for `g(-s)/g(s)`;
- parity Bezoutian block decomposition;
- determinant-square formula including the constant-term factor;
- integral unimodularity `Res(E,O)=plus or minus 1` under the canonical divisibility theorem.

### Standard prior art used

- Kronecker finite-rank Hankel theorem;
- Nehari and Adamyan–Arov–Krein Hankel approximation;
- Bezoutian determinant/resultant identity;
- Bezoutian–Hankel realization and inversion;
- rational all-pass/lossless systems;
- Routh–Hurwitz even/odd polynomial machinery.

### Unproved program targets

- all-degree exclusion of integral lossless factor systems dividing `F_X`;
- useful AAK lower bounds for prime-prefix phase reconstruction;
- identification of the local parity derivative with a canonical Hankel singular vector;
- a stable simplex-prolate reconstruction theorem with arithmetic-strength constants.

