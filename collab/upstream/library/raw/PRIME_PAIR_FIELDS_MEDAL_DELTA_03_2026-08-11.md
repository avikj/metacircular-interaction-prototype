# Prime Pair Field — Fields-Medal / Cross-Mathematics Delta 03

Date: 2026-08-11
Status: research delta. Statements labelled V1 include a written derivation here. External identifications with standard theories are marked as prior-art bridges or conjectural targets and do not alter the canonical verification grades.

## 0. Executive change in picture

Five developments survive pressure testing and materially sharpen the program.

1. **The finite-adic Liouville field is an explicit prime-indexed heat flow on a Boolean cube.** For every prime, the local parity law is a convolution kernel on `(Z/2)^k`; Walsh characters diagonalize it, and the eigenvalue of a character is exactly the corresponding local Igusa parity factor. In the distinct-residue regime the operator is a lazy hypercube walk with degree-`j` eigenvalue `1-2j/(p+1)`.
2. **The infinite-prime neutral projection is a genuine renormalization limit.** Prime depth `Y` corresponds to heat time `log log Y`; Walsh degree `j` has scaling dimension `2j`. The degree-one mode decays with the explicit Mertens constant `e^{-2 gamma} zeta(2)/(log Y)^2`; all non-neutral modes vanish, and finite annihilation primes kill selected higher-degree modes exactly.
3. **Any positive-integer Liouville correlation surviving a locally unbiased place must be stored as cross-prime / cross-scale mutual information.** This gives a precise information-theoretic target compatible with Tao's entropy-decrement architecture. It is directly a Chowla/mixing statement; conditioning on roughness freezes small-prime parity and must be treated separately for Goldbach.
4. **Every noncollision Buchstab peel is an oriented child branch of a p-Hecke/Bruhat–Tits correspondence followed by primitive saturation of exactly one cusp vector.** The missing `(p+1)`st Hecke branch is the parent direction. This makes the positive-cone versus spherical-GL(2) distinction exact.
5. **Factorization charge belongs naturally to a Hall-algebra / finite-length-module framework, not ordinary cohomological parity.** Composition length retains repeated prime factors and gives Liouville. Exterior/derived Euler-characteristic constructions naturally suppress repetitions and tend toward Möbius instead. Buchstab peeling is a selected simple-subobject correspondence on the cyclic locus, ordered by prime slope.

These developments reinforce the three master problems:

- reconstruction = recover the large-prime tail after conditioning on all finite local data;
- obstruction = quantify the retained cross-scale dependence, now by information/graded invariants rather than ordinary K-theory;
- positivity = understand why the one-sided boundary/child operator can inherit any sign theorem from the spherical or geometric completion.

---

## 1. V1: complete finite-place Walsh spectral theorem

Fix shifts

\[
H=(h_1,\ldots,h_k)
\]

and a prime `p`. For Haar-random `n in Z_p`, define the local parity vector

\[
X_{p,H}(n)
=
\big((-1)^{v_p(n+h_1)},\ldots,(-1)^{v_p(n+h_k)}\big)
\in G_k:=\{\pm1\}^k.
\]

Let `nu_{p,H}` be its probability law on `G_k`. Define the convolution/Markov operator

\[
(T_{p,H}f)(x)
=
\mathbb E_{n\in\mathbb Z_p} f\big(x\cdot X_{p,H}(n)\big),
\]

where multiplication is coordinatewise.

For `J subseteq [k]`, write the Walsh character

\[
\chi_J(x)=\prod_{i\in J}x_i.
\]

Then

\[
T_{p,H}\chi_J
=
\widehat\nu_{p,H}(J)\chi_J,
\]

with

\[
\widehat\nu_{p,H}(J)
=
\mathbb E_{n\in\mathbb Z_p}
\prod_{i\in J}(-1)^{v_p(n+h_i)}
=
I_{p,H_J}(-1,\ldots,-1).
\]

Here `H_J` is the subtuple indexed by `J`, and `I` is the Igusa integral from Delta 02.

### Proof

The Walsh characters are the complete character group of the finite abelian group `G_k`. Convolution by any probability measure diagonalizes in this basis. Directly,

\[
(T_{p,H}\chi_J)(x)
=
\mathbb E_n\chi_J(xX_{p,H}(n))
=
\chi_J(x)\mathbb E_n\chi_J(X_{p,H}(n)).
\]

The final expectation is exactly the parity specialization of the subtuple Igusa integral. QED.

### Consequence

The full local spectrum, including every collision pattern and every Walsh degree, is

\[
\boxed{
\operatorname{Spec}(T_{p,H})
=
\{I_{p,H_J}(-1,\ldots,-1):J\subseteq[k]\}.
}
\]

Thus the collision-tree recursion is simultaneously an exact recursive spectral algorithm for the local parity channel.

---

## 2. V1: distinct residues give the lazy hypercube walk

Assume the shifts are distinct modulo `p`. Then at most one form `n+h_i` is divisible by `p`.

For one p-adic variable,

\[
\Pr(v_p(m)=r)=(1-1/p)p^{-r},\qquad r\ge0.
\]

Therefore

\[
\Pr(v_p(m)\text{ even})=\frac{p}{p+1},
\qquad
\Pr(v_p(m)\text{ odd})=\frac1{p+1}.
\]

Inside the residue ball `n=-h_i+p m`, one has

\[
v_p(n+h_i)=1+v_p(m).
\]

Hence the parity vector has the exact distribution

\[
\Pr(X_{p,H}=\mathbf 1)=\frac{p+1-k}{p+1},
\]

\[
\Pr(X_{p,H}=e_i)=\frac1{p+1}
\quad (1\le i\le k),
\]

where `e_i` denotes the vector with coordinate `i` equal to `-1` and all others `+1`; no state with two or more negative coordinates occurs.

Thus

\[
\boxed{
T_p
=
\frac{p+1-k}{p+1}I
+
\frac1{p+1}\sum_{i=1}^k\tau_i
=
I-\frac1{p+1}\sum_{i=1}^k(I-\tau_i),
}
\]

where `tau_i` flips coordinate `i`.

Let

\[
L_k=\sum_{i=1}^k(I-\tau_i)
\]

be the unnormalized hypercube Laplacian. On Walsh degree `j=|J|`,

\[
L_k\chi_J=2j\chi_J,
\]

so

\[
\boxed{
T_p\chi_J
=
\left(1-\frac{2j}{p+1}\right)\chi_J.
}
\]

### Exact annihilation

The entire degree-`j` Walsh sector is killed in one step when

\[
p=2j-1
\]

is prime and the `J`-subtuple is distinct modulo `p`.

This is stronger than a scalar coincidence: the local Euler place is a spectral notch filter for a complete irreducible degree sector of Boolean harmonic analysis.

---

## 3. V1: finite-prime product, heat time, and scaling dimensions

For a finite prime set `S`, use CRT/Haar independence and define truncated Liouville parities

\[
\lambda_S(n+h_i)
=
(-1)^{\sum_{p\in S}v_p(n+h_i)}.
\]

The total parity vector is the coordinatewise product of the independent local vectors. Hence its law is

\[
\nu_{S,H}=*_{p\in S}\nu_{p,H},
\]

and

\[
\boxed{
\widehat\nu_{S,H}(J)
=
\prod_{p\in S}I_{p,H_J}(-1,\ldots,-1).
}
\]

For fixed `H,J`, all sufficiently large primes are distinct-residue primes. If no finite local factor vanishes, then

\[
\log |\widehat\nu_{\le Y,H}(J)|
=
-2|J|\sum_{p\le Y}\frac1{p+1}+O_{H,J}(1)
=
-2|J|\log\log Y+O_{H,J}(1).
\]

Therefore

\[
\boxed{
\widehat\nu_{\le Y,H}(J)
\asymp_{H,J}
(\log Y)^{-2|J|}
}
\]

up to sign and a nonzero finite Euler constant, unless an annihilation factor makes it identically zero from some depth onward.

### Renormalization interpretation

At good primes,

\[
T_p=I-\frac{L_k}{p+1}.
\]

Thus

\[
T_{\le Y}
=\prod_{p\le Y}\left(I-\frac{L_k}{p+1}\right)
\approx
\exp\left(-L_k\sum_{p\le Y}\frac1{p+1}\right).
\]

The effective heat time is

\[
t(Y)=\sum_{p\le Y}\frac1{p+1}=\log\log Y+O(1),
\]

and Walsh degree `j` has exact asymptotic scaling dimension `2j`.

This is a literal renormalization flow:

- degree zero is the fixed/neutral sector;
- degree one is the least irrelevant charged mode;
- degree `j` decays as `exp(-2j t)`;
- collision primes are finite defect operators;
- annihilation primes impose exact spectral zeros.

---

## 4. V1: explicit degree-one constant and quantitative mixing to gauge neutrality

For every shift and every prime, the degree-one eigenvalue is the singleton factor

\[
\frac{p-1}{p+1}.
\]

Hence

\[
a(Y):=\prod_{p\le Y}\frac{p-1}{p+1}
=
\frac{\prod_{p\le Y}(1-1/p)^2}
{\prod_{p\le Y}(1-1/p^2)}.
\]

Mertens' product theorem gives

\[
\boxed{
 a(Y)
\sim
\frac{e^{-2\gamma}\zeta(2)}{(\log Y)^2}.
}
\]

Let `u_k` be uniform measure on `G_k`. Fourier Parseval gives

\[
\chi^2(\nu_{\le Y,H}\|u_k)
=
\sum_{\varnothing\ne J\subseteq[k]}
|\widehat\nu_{\le Y,H}(J)|^2.
\]

Since all `k` degree-one coefficients equal `a(Y)` and every degree at least two is `O((log Y)^{-4})`, one obtains for fixed `H,k`

\[
\boxed{
\chi^2(\nu_{\le Y,H}\|u_k)
=
k a(Y)^2+O_{H,k}((\log Y)^{-8}).
}
\]

Consequently

\[
\|\nu_{\le Y,H}-u_k\|_{TV}
=
\Theta_{H,k}((\log Y)^{-2}),
\]

and the Shannon entropy deficit satisfies

\[
\boxed{
 k\log2-H(\nu_{\le Y,H})
\sim
\frac{k}{2}
\frac{e^{-4\gamma}\zeta(2)^2}{(\log Y)^4}.
}
\]

Thus the full gauge-neutral projection is not merely symmetry language: it is the infinite-time limit of an explicit prime-indexed Markov flow, with a computable approach rate.

### Exact finite-depth cancellation examples

- For two shifts with `3` not dividing their difference, the degree-two coefficient is exactly zero for every `Y>=3`.
- For a `j`-subtuple distinct modulo the prime `2j-1`, its degree-`j` truncated Liouville correlation is exactly zero once that prime is included.

---

## 5. V1: entropy is a monotone along local-prime convolution

For any probability measures `mu,nu` on a finite group,

\[
\mu*\nu=\sum_g\nu(g)\,\tau_g\mu
\]

is a convex combination of translates of `mu`. Shannon entropy is concave and translation-invariant, so

\[
\boxed{H(\mu*\nu)\ge H(\mu).}
\]

Equivalently,

\[
D(\mu*\nu\|u_k)\le D(\mu\|u_k).
\]

Strictness holds unless `mu` is already invariant under the subgroup generated by the support of `nu`.

Therefore

\[
H(\nu_{\le Y,H})
\]

is a canonical Perelman-style monotone for the finite-adic Liouville equilibrium flow. At good primes the support contains every coordinate flip, so the unique terminal state is uniform parity.

### Important limitation

This monotone concerns the **unconditioned profinite/KMS parity field**. Classical sieve roughness conditions on avoiding the forbidden residue balls. Under that conditioning every small-prime valuation is zero and the local parity vector is frozen at `+1`. Hence:

- unconditioned equilibrium randomizes charge into gauge neutrality;
- the rough conditioned ensemble transports all remaining charge into the unresolved large-prime tail.

These are dual but not identical mechanisms. The local annihilation at `p=3` does not by itself prove or disprove a prime-pair statement after conditioning on `3`-roughness.

---

## 6. V1: cross-scale mutual information is necessary for surviving parity correlation

Let `A,B` be `{+1,-1}`-valued random variables under any probability measure. Write

\[
a=\mathbb E A,
\qquad
c=\mathbb E[AB].
\]

Pinsker's inequality applied to the joint law and the product of its marginals gives

\[
\boxed{
|c-a\mathbb E B|
\le
\sqrt{2I(A;B)}
}
\]

when mutual information is measured in nats. Hence

\[
\boxed{
|c|
\le
|a|+\sqrt{2I(A;B)}.
}
\]

If `A` is exactly unbiased, then

\[
|c|\le\sqrt{2I(A;B)}.
\]

Moreover, using `sign(c)B` as an estimator of uniform `A` and applying the binary Fano bound,

\[
\boxed{
I(A;B)
\ge
\log2-h\left(\frac{1-|c|}{2}\right),
}
\]

where `h` is binary entropy in nats.

### Arithmetic specialization

Split a Liouville Walsh character into small-prime and tail factors:

\[
\prod_{i\in J}\lambda(L_i(n))
=
A_{\le Y}(n)B_{>Y}(n).
\]

The finite-adic theory computes the marginal bias

\[
\mathbb E A_{\le Y}
=
\prod_{p\le Y}I_{p,H_J}(-1,\ldots,-1),
\]

sometimes exactly zero. Under the positive-integer/archimedean measure, any persistent full correlation therefore requires either:

1. failure of the small-prime marginal to match its local model; or
2. nonvanishing mutual information between the small-prime parity and the large-prime tail.

At the critical horizon `Y=sqrt(X)`, each individual tail charge is only a zero-or-simple bit. The reconstruction problem can therefore be stated sharply:

> Quantify the mutual information between the locally visible finite-length-module state and the zero-or-simple residual quotient under the positive-cone arithmetic measure.

This is a concrete landing point for entropy-decrement methods. Tao's entropy-decrement argument is prior art for locating scales at which multiplicative data become approximately independent of residue-class data; the new point here is the explicit local parity channel and the exact information inequality it must feed.

### Caveat for Goldbach

After conditioning on all forms being `Y`-rough, small-prime parity is deterministic. One must then measure information between the **rough affine branch state** and the residual simple tail, not reuse the unconditioned Chowla decomposition verbatim.

---

## 7. V1: exact modular-symbol / rooted Hecke-branch realization

Use the canonical determinant-`h` CRT state

\[
Bs-At=h,
\]

and form the cusp-vector matrix

\[
G=
\begin{pmatrix}
 t&s\\
 B&A
\end{pmatrix},
\qquad
\det G=tA-sB=-h.
\]

Its primitive columns represent the rational endpoints

\[
x=t/B,
\qquad
y=s/A,
\]

so the oriented pair is the modular symbol `{x,y}` before quotienting by modular relations.

For a prime `p` and residue `r mod p`, let

\[
\gamma_{p,r}
=
\begin{pmatrix}
1&r\\
0&p
\end{pmatrix}.
\]

It acts on the boundary by

\[
u\mapsto\frac{u+r}{p},
\]

and

\[
\gamma_{p,r}G
=
\begin{pmatrix}
 t+rB&s+rA\\
 pB&pA
\end{pmatrix}.
\]

If `r` is the residue that makes the first affine leg divisible by `p`, then the first column is divisible by `p`; primitive saturation divides that column by `p`. The determinant changes

\[
-h\xrightarrow{\gamma_{p,r}}-ph\xrightarrow{\text{saturate one column}}-h.
\]

The same holds for the second leg. If both columns were divisible by `p`, then

\[
p\mid A(t+rB)-B(s+rA)=At-Bs=-h.
\]

Thus for `p` not dividing `h`, exactly one column can saturate: the branch itself remembers which leg was peeled. Collision primes are precisely the places where simultaneous saturation is possible.

### Relation to Hecke and Bruhat–Tits geometry

The matrices `gamma_{p,r}`, `r mod p`, are the `p` affine child representatives in the standard determinant-`p` Hecke correspondence. The missing representative `diag(p,1)` is the parent direction. Equivalently, after choosing a cusp/end, the `(p+1)`-regular Bruhat–Tits tree is oriented into:

- one parent edge;
- `p` child edges `u -> (u+r)/p`.

Therefore:

\[
\boxed{
\text{Cuntz/ax+b inverse branches}
=
\text{rooted Hecke children},
}
\]

and a Buchstab peel is a **state-selected child Hecke modification followed by primitive saturation**.

This precisely explains why the ordinary spherical Hecke operator is too coarse:

- spherical Hecke includes parent and children and is self-adjoint after normalization;
- Buchstab retains the root orientation, least-prime stopping order, chosen forbidden branch, and leg saturation;
- forgetting this data recovers the tractable GL(2)-type ambient symmetry but erases the positive-cone boundary problem.

### Branch-count interpretation

For `p` not dividing `h`, two of the `p` child residues saturate one of the two legs; the other `p-2` are nonsaturating survivor branches. At `p|h`, the two forbidden branches collide. This is the same `p-2` versus `p-1` branch count that produces the Hardy–Littlewood local correction.

### Limitation

The Buchstab operation is not yet a linear Hecke operator on the usual modular-symbol quotient: the selected branch depends on the arithmetic state and stopping rule. The exact claim is **Hecke branch/modification**, not that classical Hecke theory already solves the transfer operator.

---

## 8. V1 / standard geometry: the correct collision moduli is tangent-framed M_0,k+1

The shift configuration is naturally

\[
\operatorname{Conf}_k(\mathbb A^1)
=
\{(h_1,\ldots,h_k):h_i\ne h_j\}.
\]

Simultaneous translation of all shifts is absorbed by translating `n`, so the intrinsic parameter space is

\[
\operatorname{Conf}_k(\mathbb A^1)/\mathbb G_a.
\]

A projective line with marked point `infinity` and a nonzero tangent vector at `infinity` determines an affine coordinate up to translation: scaling changes the tangent vector, while translation does not. Hence

\[
\boxed{
\operatorname{Conf}_k(\mathbb A^1)/\mathbb G_a
\cong
\text{the nonzero-tangent torsor over }M_{0,k+1}.
}
\]

This framed version is essential. Ordinary `M_{0,k+1}` also quotients by dilation and would forget the absolute p-adic collision depth that the Igusa factor retains.

### Universal divisor

Over the framed configuration space, take

\[
\mathcal X_k
=
\mathbb A^1_n\times
\operatorname{Conf}_k(\mathbb A^1)/\mathbb G_a
\]

with universal divisor

\[
D=\bigcup_{i=1}^k\{n+h_i=0\}.
\]

The local charge field is the motivic/p-adic integral of the monomial character attached to this relative divisor. The bad locus is exactly the braid-arrangement diagonal `h_i=h_j` where divisor sections collide.

### Stable/tropical cluster tree

For a p-adic point `H`, the hierarchy of disks containing subsets of the marked shifts is the rooted metric cluster tree determined by `v_p(h_i-h_j)`. Standard nonarchimedean geometry identifies this with the stable/tropical tree in the skeleton of the marked rational-curve configuration; the tangent framing retains the root scale.

The collision recursion from Delta 02 is dynamic programming on this tree. Wonderful/Fulton–MacPherson compactification turns nested collisions into normal-crossing boundary strata indexed by the same nested cluster data.

This produces a concrete relative-geometric program:

1. construct an integral framed Fulton–MacPherson model;
2. resolve the universal divisor `D` relatively;
3. compute its motivic Igusa function once on the boundary-stratum/nested-set complex;
4. specialize to each prime and each shift tuple;
5. study nearby/vanishing cycles at the `Phi_2` parity-zero strata.

This is the precise common landing point of the Mumford/Deligne–Knudsen, Hironaka, Voevodsky/Denef–Loeser, Huh, and Ngô lenses.

---

## 9. V1 exact categorical substrate: Hall algebra and ordered simple-factor peeling

Let `FinAb` be the finite-length category from Delta 02. For `p|n`, the cyclic module `M_n=Z/nZ` has the canonical exact sequence

\[
\boxed{
0\longrightarrow S_p
\longrightarrow M_n
\longrightarrow M_{n/p}
\longrightarrow0,
}
\]

where `S_p=Z/pZ` is the unique subgroup of order `p`.

Thus prime peeling is literally removal of a simple composition factor. Composition length is additive in exact sequences:

\[
\ell(M_n)=\Omega(n),
\]

and the Liouville grading is

\[
(-1)^{\ell(M_n)}=\lambda(n).
\]

The Hall algebra of finite-length modules multiplies by counting extensions and is graded by `K_0` and total length. Locally at a prime it is the classical Hall algebra of finite abelian p-groups, related to symmetric/Hall–Littlewood functions; globally it factorizes over the p-primary categories.

### Buchstab as a selected Hall correspondence

The full Hall product includes every extension and leaves the cyclic locus. Buchstab instead uses the distinguished cyclic extension above and orders it by the **least prime label**. Assigning a monotone slope/phase to each simple `S_p` turns primary decomposition into a trivial Harder–Narasimhan ordering; on the cyclic locus, repeated quotienting by the first simple factor is exactly least-prime peeling.

This suggests the correct categorical lift:

> an ordered/stability-filtered Hall correspondence restricted to cyclic objects, with additive-size cutoff and affine-form collision labels.

The static Hall algebra captures multiplicative composition; the hard arithmetic lies in the ordered cyclic boundary and additive cutoff.

### Why ordinary derived/cohomological parity tends to see Mobius, not Liouville

Ordinary cohomology of a free abelian/group-completion direction is exterior: a generator appears at most once in a wedge degree. Incidence Euler characteristic of the divisor lattice likewise gives the number-theoretic Mobius function, which vanishes on repeated prime factors.

Liouville instead assigns a sign to **every repeated composition factor**. It is bosonic occupation parity, not squarefree exterior degree.

Therefore:

- derived/exterior/Euler-characteristic constructions naturally align with `mu`;
- Hall/symmetric/Fock grading retains repeated factors and aligns with `lambda`;
- a Venkatesh-style derived Hecke enhancement will not encode Liouville merely by declaring cohomological degree to be factorization parity;
- any successful graded index must act on the bosonic occupation/Hall object or an equivalent supergraded Fock space.

This is an independent conceptual explanation of the ordinary-K-theory no-go in Delta 02.

---

## 10. Maynard lens: why many-leg bounded gaps can bypass higher parity sectors

In a Buchstab cell where roughness plus Liouville chirality identifies primality, write schematically

\[
P_i=R_i\frac{1-X_i}{2},
\qquad X_i=\lambda(L_i(n)).
\]

The event that all `k` forms are prime expands as

\[
\prod_{i=1}^kP_i
=
2^{-k}\left(\prod_iR_i\right)
\sum_{J\subseteq[k]}(-1)^{|J|}\chi_J(X).
\]

Exact simultaneous primality requires every Walsh sector up to degree `k`. The top-degree sector is precisely the kind killed by the finite-place eigenvalue at `p=2k-1` when available.

By contrast, Maynard's bounded-gap strategy controls a weighted first moment

\[
\sum_iP_i,
\]

which only asks for one-leg prime information combined with a neutral joint sieve weight. The prime number theorem/distribution in progressions supplies the degree-one input; positivity and many redundant legs force several primes without evaluating their higher joint Chowla sectors.

This gives a structural explanation:

\[
\boxed{
\text{Maynard bypasses parity by replacing a high-degree conjunction}
\text{ with a low-degree moment plus redundancy.}
}
\]

A fixed binary Goldbach sum remains a sum of degree-two conjunctions; merely summing many candidate decompositions does not lower their Walsh degree. Any Maynard-style attack on Goldbach would need a new combinatorial design that converts the fixed-diagonal pair event into a consequence of one-leg information, not just more conventional sieve weight optimization.

This section is an explanatory synthesis, not a new theorem about Maynard weights.

---

## 11. Revised priorities after Delta 03

1. **Promote the local parity heat-flow theorem.** It is the cleanest exact bridge among KMS gauge invariance, Igusa factors, Boolean Fourier analysis, entropy, and renormalization.
2. **Use mutual information as the obstruction quantity.** Formulate the positive-cone distribution of the visible small-prime state and residual zero-or-simple tail, then measure/estimate `I(visible;tail)` under sharp and smoothed ensembles.
3. **Construct the rooted Hecke child transfer operator explicitly.** Separate parent versus children, survivor versus saturation branches, and collision defects; compare its spherical completion to the solved GL(2) divisor calibration.
4. **Build the tangent-framed configuration compactification and universal divisor.** This is now a finite geometric object with a clear motivic computation program.
5. **Develop the cyclic ordered Hall correspondence.** Test whether the exact z-Buchstab semigroup is an integration/continuum image of a length-graded Hall exponential.
6. **Use Maynard only through the degree-lowering principle.** Search for a redundancy construction that genuinely lowers the charged degree of the fixed-diagonal target; do not assume ordinary multidimensional sieve weights do this.
7. **Demote ordinary derived-Hecke parity.** Pursue derived Hecke only if the chain-level construction retains repeated occupation and positive-cone stopping; ordinary cohomological grading is likely Mobius-like.
8. **Keep the rough-conditioning distinction explicit.** Unconditioned parity heat flow concerns Chowla/mixing; Goldbach requires the killed/conditioned branch process and tail reconstruction.

## 12. Literature anchors

- Tao, *The logarithmically averaged Chowla and Elliott conjectures for two-point correlations*, arXiv:1509.05422 — entropy decrement.
- Venkatesh, *Derived Hecke algebra and cohomology of arithmetic groups*, arXiv:1608.07234 — graded Hecke action, but not automatically Liouville occupation parity.
- Hilgert–Mayer–Movasati / Muehlenbruch on transfer operators and Hecke operators for modular/period functions.
- Standard modular-symbol/Manin-symbol theory: determinant-p double cosets act on cusp-pair symbols.
- Classical Hall algebra of finite abelian p-groups; Dyckerhoff, *Higher categorical aspects of Hall algebras*, arXiv:1505.06940.
- Reineke/Bridgeland/Kontsevich–Soibelman on Hall-algebra Harder–Narasimhan factorization and wall crossing.
- Tropical/nonarchimedean descriptions of `M_0,n` and its skeleton; Fulton–MacPherson/wonderful compactification of configuration spaces.
- Delta 02 anchors for Denef–Loeser motivic Igusa zeta and hyperplane-arrangement Igusa functions.

