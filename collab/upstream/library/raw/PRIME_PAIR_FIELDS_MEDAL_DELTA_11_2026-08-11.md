# Prime Pair Field — Fields-Medal / Cross-Mathematics Delta 11

Date: 2026-08-11

Status: research delta. The `su(1,1)`/Hahn/Casimir formulas and translation-primitive identification are **V1**. Classical invariant-theory and reflection-arrangement statements are **KNOWN**. The claimed explanatory relevance to binary versus ternary difficulty is a research hypothesis, not a proof.

## 0. Executive collapse: the archimedean primitive space and finite collision space are the same type-A object

For `k` additive legs, let

\[
V_k
=
\mathbb A^k/\mathbb G_a
\cong
\{(z_1,\ldots,z_k):z_1+\cdots+z_k=0\}.
\]

This is the standard `(k-1)`-dimensional representation of `S_k`.

It appears independently in the program as:

1. the shift-configuration space `(h_1,...,h_k)` modulo common translation;
2. the ambient space of the braid collision arrangement `z_i=z_j` controlling the p-adic Igusa factors;
3. the degree-wise primitive space in the `SU(1,1)` tensor decomposition;
4. the angular polynomial space on the fixed-sum simplex;
5. the multiplicity space distinguishing binary from higher additive problems.

The finite and archimedean geometries are therefore not parallel analogies. They are fibers/realizations of the same type-`A_{k-1}` relative coordinate object.

---

## 1. V1: one leg is the positive discrete series `D^+_{1/2}`

On the polynomial ring `C[z]`, define

\[
K_- = \partial_z,
\qquad
K_0=z\partial_z+\frac12,
\qquad
K_+=z^2\partial_z+z.
\]

On `e_n=z^n`,

\[
K_-e_n=ne_{n-1},
\qquad
K_0e_n=\left(n+\frac12\right)e_n,
\qquad
K_+e_n=(n+1)e_{n+1}.
\]

They satisfy

\[
[K_0,K_\pm]=\pm K_\pm,
\qquad
[K_-,K_+]=2K_0.
\]

This is the positive discrete series with lowest weight `1/2`.

The occupation number `n` is the additive coordinate on one leg. The coefficients `n` and `n+1` are exactly those appearing in the finite Hahn exchange generator.

---

## 2. V1: total lowering is common translation

On `k` legs, take the tensor/product representation on

\[
\mathbb C[z_1,\ldots,z_k].
\]

The diagonal generators are

\[
K_\bullet^{\rm tot}=\sum_{i=1}^kK_\bullet^{(i)}.
\]

In particular,

\[
\boxed{
K_-^{\rm tot}=\sum_{i=1}^k\partial_{z_i}.
}
\]

Its flow is simultaneous translation

\[
(z_1,\ldots,z_k)
\mapsto
(z_1+t,\ldots,z_k+t).
\]

Therefore the degree-`j` lowest-weight/primitive space is

\[
\begin{aligned}
\mathcal P_j^{(k)}
&=
\ker\!\left(
K_-^{\rm tot}:\mathbb C[z_1,\ldots,z_k]_j
\to
\mathbb C[z_1,\ldots,z_k]_{j-1}
\right)\\
&=
\mathbb C[z_1,\ldots,z_k]_j^{\mathbb G_a}.
\end{aligned}
\]

Equivalently,

\[
\boxed{
\mathcal P_j^{(k)}
\cong
\operatorname{Sym}^j(V_{\rm std}^*),
}
\]

where `V_std` is the standard `(k-1)`-dimensional representation of `S_k`.

Hence

\[
\boxed{
\dim\mathcal P_j^{(k)}
=
\binom{j+k-2}{k-2}.
}
\]

This is the exact source of the multileg Clebsch–Gordan multiplicities.

---

## 3. V1: Lefschetz-style decomposition of every fixed-sum simplex

The homogeneous degree-`N` occupation space has basis

\[
e_{n_1}\otimes\cdots\otimes e_{n_k},
\qquad
n_1+\cdots+n_k=N.
\]

Every irreducible summand begins at a primitive vector of degree `j` and is raised to degree `N` by the total `K_+`. Therefore

\[
\boxed{
\mathcal H_N^{(k)}
=
\bigoplus_{j=0}^N
(K_+^{\rm tot})^{N-j}\mathcal P_j^{(k)}.
}
\]

This is an exact `sl_2` / Hard-Lefschetz-shaped decomposition:

- `K_+` raises radial/total occupation;
- `K_-` lowers;
- `P_j` is primitive;
- the fixed-sum simplex is assembled from raised primitive channels.

Dimension checking gives

\[
\sum_{j=0}^N\binom{j+k-2}{k-2}
=
\binom{N+k-1}{k-1},
\]

which is the number of integer points in the `k`-leg simplex.

---

## 4. V1: the multileg Hahn generator is the relative Casimir

On a function of occupations `n=(n_1,...,n_k)` with total `N`, define

\[
\boxed{
(L_{N,k}f)(\mathbf n)
=
\sum_{i\ne r}
 n_i(n_r+1)
\left[
 f(\mathbf n-e_i+e_r)-f(\mathbf n)
\right].
}
\]

The rate from `n` to `n-e_i+e_r` equals the reverse rate, so counting measure on the integer simplex is reversible.

Let the `su(1,1)` Casimir be

\[
C=K_0(K_0-1)-K_+K_-.
\]

On the fixed-total-`N` space,

\[
K_+^{\rm tot}K_-^{\rm tot}
=
L_{N,k}+N(N+k-1)I.
\]

Also

\[
K_0^{\rm tot}=N+\frac k2.
\]

Therefore

\[
\boxed{
-L_{N,k}
=
C_{\rm tot}
-
\frac k2\left(\frac k2-1\right)I.
}
\]

On the irreducible channel with lowest weight

\[
K=\frac k2+j,
\]

the eigenvalue is

\[
\boxed{
-L_{N,k}=j(j+k-1),
\qquad j=0,1,\ldots,N,
}
\]

with multiplicity

\[
\binom{j+k-2}{k-2}.
\]

For `k=2` this reduces exactly to the Hahn operator and eigenvalues `j(j+1)` from Delta 08.

Thus the finite diagonal Hodge operator and the archimedean `SU(1,1)` Casimir are literally the same operator in two realizations.

---

## 5. V1: the primitive Dirichlet form

By reversibility,

\[
\boxed{
-\langle f,L_{N,k}f\rangle
=
\frac12
\sum_{\mathbf n}
\sum_{i\ne r}
 n_i(n_r+1)
\left|
 f(\mathbf n-e_i+e_r)-f(\mathbf n)
\right|^2
\ge0.
}
\]

Constants are the `j=0` radial sector. On the orthogonal complement,

\[
-\langle f,L_{N,k}f\rangle
\ge k\|f\|_2^2,
\]

because the first primitive eigenvalue is

\[
1(1+k-1)=k.
\]

Additional permutation symmetry removes some low channels and raises the relevant spectral gap, exactly as reflection symmetry raised the binary gap from `2` to `6`.

---

## 6. KNOWN / V1 APPLICATION: permutation action on multiplicity spaces

The symmetric group `S_k` permutes the legs and acts on

\[
\mathcal P_j^{(k)}\cong\operatorname{Sym}^j(V_{\rm std}^*).
\]

For any permutation `sigma`,

\[
\boxed{
\sum_{j\ge0}
\operatorname{tr}\!\left(
\sigma\mid\mathcal P_j^{(k)}
\right)t^j
=
\frac1{\det(I-t\sigma\mid V_{\rm std})}.
}
\]

For a transposition, the eigenvalues on `V_std` are

\[
-1\text{ once},
\qquad
+1\text{ with multiplicity }k-2.
\]

Hence

\[
\boxed{
\sum_{j\ge0}
\operatorname{tr}(\tau\mid\mathcal P_j^{(k)})t^j
=
\frac1{(1-t)^{k-2}(1+t)}.
}
\]

### Binary

For `k=2`,

\[
\operatorname{tr}(\tau\mid\mathcal P_j^{(2)})=(-1)^j.
\]

Each channel is one-dimensional, and the leg swap is a pure sign. This is exactly the alternating Hahn-energy identity for binary Goldbach.

### Ternary

For `k=3`,

\[
\frac1{(1-t)(1+t)}
=
\frac1{1-t^2},
\]

so

\[
\boxed{
\operatorname{tr}(\tau\mid\mathcal P_j^{(3)})
=
\begin{cases}
1,&j\text{ even},\\
0,&j\text{ odd}.
\end{cases}
}
\]

But

\[
\dim\mathcal P_j^{(3)}=j+1.
\]

Thus a transposition is no longer a scalar parity; its normalized trace is `1/(j+1)` on even degrees and zero on odd degrees. Permutation parity is diluted across a growing multiplicity space.

This is an exact representation-theoretic distinction between binary and ternary diagonal geometry.

---

## 7. KNOWN: symmetric primitive invariants occur in degrees `2,...,k`

The invariant ring of the standard reflection representation of `S_k` is polynomial with generator degrees

\[
2,3,\ldots,k.
\]

Equivalently,

\[
\boxed{
\sum_{j\ge0}
\dim\left(\mathcal P_j^{(k)}\right)^{S_k}t^j
=
\prod_{d=2}^k\frac1{1-t^d}.
}
\]

### Binary

For `k=2`, only degree `2` generates the invariant ring. Symmetric primitive channels occur only in even degree.

### Ternary

For `k=3`, generators occur in degrees `2` and `3`:

\[
\frac1{(1-t^2)(1-t^3)}.
\]

There is a genuinely cubic symmetric primitive channel absent from the binary problem.

This is a concrete sense in which the ternary relative geometry has an additional invariant direction, not merely a larger ambient dimension.

It is an open question whether this cubic primitive is directly responsible for the analytic spare factor in Vinogradov's theorem.

---

## 8. The same type-A arrangement at every finite place

The relative shift space is

\[
V_k=\mathbb A^k/\mathbb G_a.
\]

The collision divisor is the type-`A_{k-1}` braid arrangement

\[
\mathcal A_{k-1}
=
\bigcup_{i<r}\{z_i-z_r=0\}.
\]

For integer shifts `H=(h_1,...,h_k)`:

- reduction modulo `p` lands in `V_k(F_p)`;
- collision flats record equal residue clusters;
- higher valuations `v_p(h_i-h_r)` give the nested cluster tree;
- the local charge factor is the Igusa integral attached to the translated linear forms;
- collision primes divide the discriminant

\[
\Delta(H)=\prod_{i<r}(h_i-h_r).
\]

At the real place:

- the positive simplex is a chamber/projectivization of the positive cone;
- angular polynomials are functions on the same relative space;
- the Casimir/Hahn operator supplies the primitive spectrum.

Therefore:

\[
\boxed{
\text{finite Igusa collision geometry}
\quad\text{and}\quad
\text{archimedean Hahn/Jacobi primitive geometry}
\text{ live on the same type-A relative configuration space.}
}
\]

---

## 9. Huh / flag-variety bridge becomes literal but limited

The braid arrangement has:

- intersection lattice given by set partitions;
- Orlik–Solomon algebra;
- matroid Chow ring satisfying Hard Lefschetz and Hodge–Riemann;
- coinvariant algebra isomorphic to the cohomology of the complete flag variety.

This makes the Huh/Deligne/Grothendieck lens concrete. The candidate Hodge package is not attached to raw Hahn-energy coefficients; it is attached to the type-A collision arrangement **before** taking local integrals or spectral squares.

The project can now ask precise questions:

1. Can the local Igusa charge factors be realized as evaluations of classes/valuations in the braid-arrangement Chow ring?
2. Do Hodge–Riemann inequalities constrain their collision-stratum coefficients?
3. Does the archimedean Casimir primitive form correspond to a realization of the same Lefschetz operator?
4. Can nearby/vanishing cycles at the discriminant transport these inequalities between collision strata?

Important limitation: for binary `k=2`, the `A_1` arrangement is essentially trivial. Combinatorial Hodge theory has little room to create a new binary sign theorem. This machinery becomes structurally richer starting at ternary `A_2`.

---

## 10. Binary-versus-ternary calibration sharpened

The following facts now line up:

### Binary (`k=2`)

- primitive multiplicity is exactly one at every degree;
- leg swap acts by the full sign `(-1)^j`;
- symmetric primitive channels are only even;
- collision arrangement is rank one;
- angular Goldbach form is an undiluted difference of even/odd energies;
- analytically there is no spare Holder factor.

### Ternary (`k=3`)

- primitive multiplicity is `j+1`;
- a transposition has tiny/zero normalized trace on high-degree multiplicities;
- symmetric primitive invariant generators have degrees `2` and `3`;
- collision arrangement is the nontrivial `A_2` braid arrangement;
- multiple coupling/recoupling channels exist;
- analytically the `(infinity,2,2)` pattern supplies a spare square-integrable leg.

These are exact structural correspondences. A theorem identifying the analytic spare factor with a trace or norm over the multiplicity space remains open.

---

## 11. Recoupling and associativity

For `k>=3`, there are multiple binary trees for coupling the `SU(1,1)` legs. Each gives a basis of the same primitive multiplicity space. Changes of basis are Racah / `6j` coefficients; for more legs they become higher `3nj` symbols and multivariate Racah polynomials.

On the scalar beta-function ground channel, the first associativity identity is

\[
B(a,b)B(a+b,c)
=
B(b,c)B(a,b+c)
=
\frac{\Gamma(a)\Gamma(b)\Gamma(c)}{\Gamma(a+b+c)}.
\]

The higher-channel recoupling theory is therefore the canonical language for reorganizing:

- three-zero and higher-zero contributions;
- ternary Goldbach variation terms;
- different Buchstab peeling orders;
- collision-tree bracketings.

A major target is to determine whether the Buchstab order dependence and `SU(1,1)` Racah recoupling form one pentagon/coherence structure.

---

## 12. A global type-A object suggested by all local realizations

The natural object is no longer vaguely “a geometry of primes.” It is the relative configuration stack/space

\[
\operatorname{Conf}_k(\mathbb A^1)/\mathbb G_a
\]

with its type-A discriminant, together with:

- finite-place Igusa/motivic integration;
- real positive-cone harmonic analysis;
- `S_k`/braid monodromy;
- `SU(1,1)` Lefschetz/Casimir action;
- scale-ordered positive-integer boundary sampling.

The first four pieces are established or now explicit. The fifth—positive-integer prime stopping—is the genuinely arithmetic lift not supplied by the configuration geometry alone.

This sharply locates the missing structure.

---

## 13. Revised priorities after Delta 11

1. Formalize the multileg Casimir/Hahn generator and primitive decomposition in Lean.
2. Compute the ternary degree-2 and degree-3 symmetric primitive kernels explicitly on the integer simplex.
3. Rewrite the ternary Goldbach major/minor-arc decomposition in the `S_3` multiplicity basis.
4. Test whether the `(3,3)` variation coefficients and `(infinity,2,2)` Holder pattern have a direct multiplicity-space trace interpretation.
5. Express the p-adic Igusa collision recursion as a valuation on the type-A intersection lattice/Chow ring.
6. Compare the arrangement Lefschetz operator with the archimedean relative Casimir.
7. Develop Racah/recoupling formulas for three-zero and three-leg Buchstab sectors.
8. Do not expect rank-one `A_1` combinatorial Hodge theory alone to solve binary Goldbach.

---

## 14. Verification boundaries

**V1:**

- polynomial realization of `D^+_{1/2}`;
- primitive space as translation-invariant homogeneous polynomials;
- multiplicity formula;
- fixed-degree Lefschetz decomposition;
- multileg Hahn generator and Casimir identity;
- eigenvalues `j(j+k-1)`;
- Dirichlet form;
- transposition trace generating function and binary/ternary specializations.

**Known:**

- invariant ring degrees `2,...,k` for the standard `S_k` reflection representation;
- braid arrangement / flag-variety / matroid Hodge package;
- `SU(1,1)` Racah recoupling theory.

**Open:**

- analytic spare factor equals multiplicity-space averaging;
- Hodge inequalities for the actual local charge factors;
- a common motivic/archimedean Lefschetz realization;
- recoupling control of Buchstab order;
- any binary or ternary Goldbach theorem from this structure.

## 15. Literature anchors

- Standard positive discrete-series representation theory of `su(1,1)`.
- Koelink–Van der Jeugt and multivariate `SU(1,1)` Clebsch–Gordan/Racah literature.
- Classical invariant theory of the symmetric group / type-A reflection representation.
- Orlik–Solomon and braid arrangement theory.
- Adiprasito–Huh–Katz, combinatorial Hodge theory for matroids.
- Denef–Loeser and arrangement Igusa-zeta literature.
