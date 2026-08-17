# Quantum Gravity Refoliation Program II
## Jacobi forces anomaly cohomology; the central-extension problem becomes a classification theorem

**Date:** 2026-08-13  
**Status:** active mathematical-physics note. The abstract Lie-algebroid results are proved below. The 3+1 gravity classification targets remain open.

---

# 1. Starting point

The previous note isolated the quantum refoliation curvature

\[
\widehat{\mathcal F}(a,b)
=
\frac{1}{i\hbar}
[\widehat G_a,\widehat G_b]
-
\widehat G_{[a,b]_A},
\]

where \(A\) is the hypersurface-deformation Lie algebroid.

Exact covariance requires \(\widehat{\mathcal F}=0\).

Ray-level covariance permits

\[
\widehat{\mathcal F}(a,b)=\alpha(a,b)I.
\]

The question is now:

> How arbitrary can \(\alpha\) be?

Answer: not arbitrary at all. Jacobi forces \(\alpha\) to be a Lie-algebroid 2-cocycle. Rephasing the generators changes it only by a coboundary. Therefore projective quantum-gravity anomalies are classified, at the infinitesimal level, by a second Lie-algebroid cohomology class.

This is the exact continuum analogue of the finite \(H^2(K;U(1))\) obstruction.

---

# 2. Lie algebroid setup

Let \(A\to B\) be a Lie algebroid over a base \(B\), with:

- section bracket \([a,b]_A\);
- anchor
\[
\rho:A\to TB;
\]
- Leibniz law
\[
[a,fb]
=
f[a,b]
+
(\rho(a)f)b.
\]

For gravity, \(B\) is a configuration/phase-space-like space of nondegenerate spatial geometries/embeddings, and \(A\) consists of lapse-shift deformation directions.

Let \(\mathcal H\to B\) be a Hilbert bundle.

A quantum deformation connection assigns to a section \(a\in\Gamma(A)\) a first-order operator

\[
\nabla_a
\]

on Hilbert-bundle sections satisfying

\[
\nabla_{fa}=f\nabla_a.
\]

Its curvature is

\[
F(a,b)
=
[\nabla_a,\nabla_b]
-
\nabla_{[a,b]_A}.
\]

Projective flatness means

\[
F(a,b)=i\alpha(a,b)I
\]

for a real antisymmetric bilinear 2-form

\[
\alpha\in\Gamma(\wedge^2A^*).
\]

---

# 3. Projective Bianchi theorem

## Theorem 3.1

If

\[
F(a,b)=i\alpha(a,b)I,
\]

then

\[
d_A\alpha=0,
\]

where \(d_A\) is the Lie-algebroid exterior derivative.

Explicitly,

\[
\begin{aligned}
0={}&
\rho(a)\alpha(b,c)
+\rho(b)\alpha(c,a)
+\rho(c)\alpha(a,b)
\\
&-\alpha([a,b],c)
-\alpha([b,c],a)
-\alpha([c,a],b).
\end{aligned}
\]

### Proof

The operator Jacobi identity gives

\[
[\nabla_a,[\nabla_b,\nabla_c]]
+\text{cyclic}=0.
\]

Write

\[
[\nabla_b,\nabla_c]
=
\nabla_{[b,c]}+i\alpha(b,c)I.
\]

Then

\[
[\nabla_a,\nabla_{[b,c]}]
=
\nabla_{[a,[b,c]]}
+i\alpha(a,[b,c])I
\]

and

\[
[\nabla_a,i\alpha(b,c)I]
=
i\,\rho(a)\alpha(b,c)I,
\]

because \(\nabla_a\) differentiates scalar functions on the base through the anchor.

Summing cyclically, the noncentral generator terms cancel by the Lie-algebroid Jacobi identity. The scalar remainder is precisely \(i(d_A\alpha)(a,b,c)I\). QED.

So a proposed anomaly that fails this equation is not merely undesirable; it is algebraically impossible for associative quantum operators.

---

# 4. Gauge/rephasing theorem

Change the quantum connection by a scalar 1-form

\[
\nabla'_a
=
\nabla_a+i\lambda(a)I,
\qquad
\lambda\in\Gamma(A^*).
\]

## Theorem 4.1

The projective curvature changes by

\[
\alpha'
=
\alpha+d_A\lambda.
\]

### Proof

Expand

\[
[\nabla_a+i\lambda(a),\nabla_b+i\lambda(b)]
-
\nabla'_{[a,b]}.
\]

The old curvature contributes \(i\alpha(a,b)\). Scalar commutators contribute

\[
i\rho(a)\lambda(b)
-i\rho(b)\lambda(a),
\]

while subtracting \(\nabla'_{[a,b]}\) contributes

\[
-i\lambda([a,b]).
\]

Together these are \(i(d_A\lambda)(a,b)\). QED.

Hence the invariant infinitesimal projective obstruction is

\[
\boxed{
[\alpha]\in H^2(A;\mathbb R)
}
\]

or its integrated \(U(1)\) version when exponentiation is possible.

---

# 5. The anomaly is a geometric object, not a central-charge number

For an ordinary Lie algebra, a central extension is often described by constants.

For a Lie algebroid, \(\alpha(a,b)\) may vary over the base geometry \(q\). Jacobi then contains the anchor derivatives

\[
\rho(a)\alpha(b,c).
\]

Therefore a gravity anomaly can behave like Berry curvature over geometry space.

This is exactly what the field-dependent structure functions force us to consider.

The classification problem is not merely:

\[
\text{find central charges}.
\]

It is:

\[
\boxed{
\text{compute }H^2(A_{\rm HDA};\mathbb R)
\text{ in the physically admissible local class}.
}
\]

The qualifier “physically admissible local class” is crucial: unrestricted cohomology can contain wildly nonlocal objects irrelevant to local quantum gravity.

---

# 6. Decompose the HDA cocycle

Write a deformation section as a pair

\[
a=(v,N)
\]

with shift vector field \(v\) and lapse scalar \(N\).

The classical bracket is schematically

\[
[(v,N),(w,M)]
=
\left(
[v,w]+\beta_q(N,M),
\mathcal L_vM-\mathcal L_wN
\right),
\]

where

\[
\beta_q(N,M)^a
=
q^{ab}
(N\partial_bM-M\partial_bN).
\]

Decompose a general antisymmetric anomaly 2-form as

\[
\alpha((v,N),(w,M))
=
A(v,w)
+
B(v,M)
-
B(w,N)
+
C(N,M).
\]

Here:

- \(A\): shift-shift anomaly;
- \(B\): mixed shift-lapse anomaly;
- \(C\): normal-normal anomaly.

The cocycle equation links them. They cannot be chosen independently.

---

# 7. DDD cocycle equation

Insert three shifts \(v,w,u\).

Then

\[
\begin{aligned}
0={}&
\rho_vA(w,u)
+\rho_wA(u,v)
+\rho_uA(v,w)
\\
&-A([v,w],u)
-A([w,u],v)
-A([u,v],w).
\end{aligned}
\]

Thus \(A\) is itself a 2-cocycle for the spatial-diffeomorphism action.

A nonzero \(A\) means spatial diffeomorphisms are represented only projectively.

For ordinary gravity this would already be severe because spatial diffeomorphisms are supposed to be gauge redundancy.

---

# 8. DDH cocycle equation

Insert \(D_v,D_w,H_N\). Direct expansion gives

\[
\boxed{
\begin{aligned}
0={}&
\rho_v B(w,N)
-\rho_w B(v,N)
+\rho_N A(v,w)
\\
&-B([v,w],N)
+B(v,\mathcal L_wN)
-B(w,\mathcal L_vN).
\end{aligned}}
\]

Therefore even if a mixed anomaly seems possible in isolation, it must transform coherently with any shift-shift anomaly and the Hamiltonian anchor action.

If \(A=0\), then \(B\) is an equivariant 1-cocycle-like object under spatial diffeomorphisms.

---

# 9. DHH cocycle equation

Insert \(D_v,H_N,H_M\). One obtains

\[
\boxed{
\begin{aligned}
0={}&
\rho_v C(N,M)
-\rho_N B(v,M)
+\rho_M B(v,N)
\\
&-C(\mathcal L_vN,M)
-C(N,\mathcal L_vM)
-A(\beta_q(N,M),v).
\end{aligned}}
\]

This is important.

If

\[
A=B=0,
\]

then

\[
\rho_v C(N,M)
=
C(\mathcal L_vN,M)
+
C(N,\mathcal L_vM).
\]

So \(C\) must be spatial-diffeomorphism covariant.

A normal-normal central anomaly cannot simply be an arbitrary bilinear functional of lapses.

---

# 10. HHH cocycle equation

Insert three normal deformations \(H_N,H_M,H_L\).

Because

\[
[H_N,H_M]=D_{\beta_q(N,M)},
\]

the cocycle equation becomes

\[
\boxed{
\begin{aligned}
0={}&
\rho_N C(M,L)
+\rho_M C(L,N)
+\rho_L C(N,M)
\\
&-B(\beta_q(N,M),L)
-B(\beta_q(M,L),N)
-B(\beta_q(L,N),M).
\end{aligned}}
\]

If \(B=0\), then

\[
\rho_N C(M,L)
+\rho_M C(L,N)
+\rho_L C(N,M)
=0.
\]

Thus geometry dependence of \(C\) is constrained along the Hamiltonian-deformation directions themselves.

This is the place where a Berry-curvature-like anomaly would have to survive.

---

# 11. Immediate consequence: anomaly sectors are coupled

The equations show that “put a central term in \([H,H]\)” is generally incomplete.

Because \([H,H]\) lands in the shift sector with a metric-dependent coefficient, \(C\) must coexist consistently with:

- spatial diffeomorphism covariance;
- possible mixed cocycle \(B\);
- possible diffeomorphism cocycle \(A\);
- the anchor action on geometry.

The HDA does not permit independent Virasoro-style decoration of one commutator without checking the entire algebroid.

---

# 12. A restricted no-anomaly theorem

We can prove a useful but deliberately restricted statement.

Assume:

1. \(\Sigma\) is compact without boundary;
2. \(A=B=0\);
3. \(C(N,M)\) is a local bilinear functional;
4. \(C\) is ultralocal in the metric \(q\);
5. \(C\) contains no derivatives of \(q\);
6. \(C\) contains at most two derivatives total acting on \(N,M\);
7. no background tensor other than \(q_{ab}\), its inverse, and its volume density is available;
8. spatial parity-odd background structure is absent.

## Theorem 12.1

Under these hypotheses,

\[
C(N,M)=0.
\]

### Proof

A diffeomorphism-covariant scalar bilinear functional on a closed manifold must be an integral of a scalar density constructed from \(q\), \(N,M\), and their covariant derivatives.

At derivative order zero the only bilinear scalar is proportional to

\[
NM,
\]

which is symmetric, so its antisymmetrization vanishes.

At one derivative, one obtains a covector such as

\[
N\nabla_aM-M\nabla_aN.
\]

There is no natural vector constructed algebraically from \(q_{ab}\) alone with which to contract it into a scalar. Hence no scalar density exists.

At two derivatives, the only metric-natural scalar bilinear terms reduce, modulo coefficients, to combinations of

\[
N\Delta M,\quad
M\Delta N,\quad
\nabla_aN\nabla^aM,\quad
NM.
\]

The gradient product and \(NM\) are symmetric. The antisymmetric Laplacian term integrates to zero on a closed manifold because the Laplacian is formally self-adjoint:

\[
\int_\Sigma\sqrt q\,
(N\Delta M-M\Delta N)
=0.
\]

Therefore no nonzero antisymmetric \(C\) exists. QED.

This does **not** prove absence of all gravity anomalies. It proves that a projective \(HH\) anomaly cannot occur at the first natural low-derivative/background-free level.

A surviving anomaly must use at least one of:

- higher derivatives;
- derivatives/curvature of \(q\);
- parity-odd structure;
- nonlocality;
- boundary data;
- nonzero \(A\) or \(B\);
- additional matter/background fields;
- global topology.

That is already a strong filter.

---

# 13. Operator form of the \(C\)-classification problem

Any bilinear anomaly can be written formally as

\[
C(N,M)
=
\langle N,KM\rangle_q
-
\langle M,KN\rangle_q
\]

for some local differential operator \(K\), with

\[
\langle f,g\rangle_q
=
\int_\Sigma \sqrt q\,fg.
\]

Equivalently only the skew-adjoint part matters:

\[
C(N,M)
=
\langle N,(K-K^\dagger)M\rangle_q.
\]

Therefore:

\[
\boxed{
\text{classifying local }HH\text{ central anomalies}
\Longrightarrow
\text{classifying natural skew-adjoint scalar differential operators}.
}
\]

In one spatial dimension nontrivial odd-derivative cocycles are closely related to Virasoro/Gelfand-Fuchs structure.

In three spatial dimensions the corresponding background-free natural-operator classification may be drastically more rigid.

This is now a sharply formulated mathematics problem.

---

# 14. Boundary loophole

The closed-\(\Sigma\) assumption matters.

For a manifold with boundary,

\[
\int_\Sigma
(N\Delta M-M\Delta N)\sqrt q
=
\int_{\partial\Sigma}
(N\nabla_nM-M\nabla_nN)\,dS.
\]

So a term that vanishes in the bulk can survive as a boundary cocycle.

This immediately connects projective refoliation anomalies to gravitational edge modes, asymptotic symmetry charges, and boundary degrees of freedom.

Hence there may be a clean division:

\[
\boxed{
\text{bulk HDA anomaly trivial}
\quad\text{but}\quad
\text{boundary central extension nontrivial}.
}
\]

That pattern is physically familiar in gauge/gravitational systems and should be treated as a primary hypothesis.

---

# 15. Bulk-vs-boundary conjecture

## Conjecture II-A

For compact 3-manifolds without boundary, every local, diffeomorphism-covariant, unitary central extension of the nondegenerate hypersurface-deformation algebroid satisfying an appropriate finite-order locality condition is cohomologically trivial.

Symbolically,

\[
H^2_{\rm local,phys}(A_{\rm HDA};\mathbb R)=0.
\]

For manifolds with boundary or asymptotic ends, nontrivial classes reduce to boundary/asymptotic charge extensions.

If true, **3+1 bulk quantum gravity cannot possess a genuine projective refoliation anomaly**.

Any continuum bulk anomaly must be noncentral and hence a real inconsistency, not a harmless quantum phase.

This would be a major structural theorem.

---

# 16. Why 1+1 parametrized field theory is the control case

Parametrized field theory on a cylinder is special because its quantum constraint algebra is simultaneously the hypersurface-deformation algebra and a Virasoro/CFT algebra. Finite-resolution constraint algebras need not close; continuum anomaly freedom is recovered through renormalization.

That model gives a perfect calibration:

1. identify the familiar central extension;
2. express it as the algebroid curvature \(\alpha\);
3. verify the cocycle equation above;
4. track it under Hamiltonian renormalization;
5. compare dimension one with dimension three.

The question is whether the Virasoro central extension is a dimension-specific possibility that has no 3+1 bulk analogue.

---

# 17. RG equation for the anomaly

Let a regulator scale \(a\) define a quantum connection \(\nabla^{(a)}\) and curvature

\[
F_a=i\alpha_a I+\mathcal N_a
\]

where \(\mathcal N_a\) is the noncentral part.

A healthy continuum limit should satisfy

\[
\|\mathcal N_a\|\to0.
\]

The central piece may:

1. vanish:
\[
[\alpha_a]\to0;
\]

2. converge to a trivial class removable by rephasing;

3. converge to a nontrivial stable class;

4. fail to converge.

The first two give exact continuum refoliation invariance.

The third gives a genuinely projective quantum spacetime.

The fourth fails to define a continuum symmetry.

This is the anomaly RG phase diagram.

---

# 18. Cohomology under refinement

Suppose discretizations/refinements induce algebroid approximations

\[
A_a
\]

and coarse/fine comparison maps.

A regulator anomaly is physically meaningful only if the cohomology classes form a compatible system

\[
[\alpha_a]
\mapsto
[\alpha_{a'}].
\]

A phase visible at one regulator but killed by a finer coboundary is not continuum physics.

This repeats the stable-reconstruction discipline from the arithmetic program:

\[
\boxed{
\text{do not promote a finite obstruction unless it survives refinement functorially}.
}
\]

---

# 19. Mixed frame-refoliation cocycle

Now enlarge the algebroid to include quantum reference-frame transformations.

Let \(R\) denote frame-change directions and \(A\) hypersurface directions.

The total connection has components

\[
\nabla_A,\qquad \nabla_R.
\]

Its curvature splits:

\[
F_{AA},\qquad
F_{RR},\qquad
F_{AR}.
\]

Interpretation:

- \(F_{AA}\): refoliation anomaly;
- \(F_{RR}\): quantum-frame transformation anomaly;
- \(F_{AR}\): failure of evolution to commute with frame change.

Projective consistency requires every component central.

The Bianchi identity couples these components.

Therefore one cannot independently demand “QRF covariance” and “constraint closure”: the full enlarged connection must satisfy one joint curvature/cohomology problem.

This is a potentially powerful synthesis with relational path-integral gravity.

---

# 20. A square-to-cube consistency theorem

At the finite level, suppose three independent kinds of transformations \(X,Y,Z\) generate faces of a cube. Every face is projectively flat with phase \(\omega_{XY}\), etc.

For the total transport around the boundary of the cube to be associative/consistent, the product of oriented face phases must equal one.

This is the discrete Bianchi identity:

\[
\boxed{
\delta\omega=1.
}
\]

Thus pairwise commuting squares are not sufficient if their phases fail the 3-cell cocycle condition.

This is exactly why the anomaly is cohomological rather than a list of independent plaquette phases.

---

# 21. Quantum spacetime as a gerbe-like possibility

If the projective phase class is nontrivial, there may be no globally defined flat Hilbert bundle, only projective Hilbert data with a \(U(1)\) 2-cocycle.

Mathematically this resembles the passage from bundles to projective bundles/gerbes.

I am not claiming quantum spacetime *is* a gerbe.

The precise statement is narrower:

> a nontrivial projective refoliation class naturally has the same obstruction degree as the class obstructing a global lift from projective to ordinary unitary transport.

That suggests bundle-gerbe machinery may be the correct language if Conjecture II-A fails.

---

# 22. The strongest near-term theorem target

Prove Conjecture II-A under a progressively enlarged locality class.

Start with:

### Class 0
Ultralocal in \(q\), at most two lapse derivatives.

Solved above: \(C=0\) when \(A=B=0\).

### Class 1
Allow curvature \(R[q]\) and finitely many covariant derivatives, but no parity-odd tensors.

Classify all natural skew-adjoint scalar operators.

### Class 2
Allow the orientation tensor \(\epsilon^{abc}\).

Determine whether parity-odd local cocycles exist.

### Class 3
Allow coupled \(A,B,C\), not merely \(C\).

Solve the full algebroid cocycle system.

### Class 4
Add boundaries/asymptotics.

Classify which classes are pure boundary charges.

This is a tractable ladder.

---

# 23. A possible decisive lemma

A promising route is a natural-operator theorem:

## Candidate Lemma

On a closed Riemannian 3-manifold, every diffeomorphism-natural scalar differential operator constructed polynomially from \(q,q^{-1}\), curvature, and covariant derivatives, acting on weight-zero scalars and invariant under orientation reversal, is formally self-adjoint modulo operators whose antisymmetric part is a total divergence.

If true, then every background-free parity-even bilinear local central \(HH\) anomaly vanishes after integration.

This would kill the entire \(C\) sector under broad assumptions.

I do not yet have a proof; this is the next math target.

---

# 24. Why the metric-dependent structure function may kill the remaining sectors

Even if \(A\) or \(B\) exists, the DHH and HHH equations contain

\[
\beta_q(N,M)^a
=
q^{ab}(N\partial_bM-M\partial_bN).
\]

By varying \(N,M\), the vector fields \(\beta_q(N,M)\) may span a large portion of the tangent-vector-field algebra locally.

If so, the term

\[
A(\beta_q(N,M),v)
\]

forces \(A\) into the \(C\) covariance equation, while

\[
B(\beta_q(N,M),L)
\]

forces \(B\) into HHH.

This suggests a rigidity mechanism:

\[
\boxed{
\text{normal deformations generate tangential directions strongly enough
that an anomaly in one sector contaminates all sectors.}
}
\]

If spatial diffeomorphism projective anomalies are absent, the coupling may force the whole HDA anomaly to vanish.

This is the structural route I would try to prove.

---

# 25. Local spanning lemma

At any point \(x\) of a nondegenerate spatial manifold and for any tangent vector \(X^a\in T_x\Sigma\), there exist smooth lapse functions \(N,M\) such that

\[
\beta_q(N,M)^a(x)=X^a.
\]

## Proof

Choose \(N\) with \(N(x)=1\), \(dN_x=0\). Choose \(M\) with

\[
dM_x=q_{ab}X^a\,dx^b.
\]

Then at \(x\),

\[
\beta_q(N,M)^a
=
q^{ab}\partial_bM
=
X^a.
\]

QED.

This elementary fact is important: **normal-normal brackets locally generate arbitrary tangential directions.**

Therefore the \(HH\) sector algebraically probes the full tangent symmetry.

---

# 26. Consequence of local spanning

Suppose a local bilinear \(A(v,w)\) vanishes whenever its first argument lies in the image of every \(\beta_q(N,M)\).

By the spanning lemma and locality, this forces

\[
A=0.
\]

Likewise, strong constraints on

\[
B(\beta_q(N,M),L)
\]

for all lapses constrain \(B(v,L)\) for arbitrary local \(v\).

Thus HHH consistency has enough normal-deformation freedom to control the mixed anomaly sector.

The remaining work is to turn this local spanning into a global cohomology vanishing argument.

---

# 27. New rigidity strategy

The anomaly-triviality proof can be attacked in this order:

1. classify/kill \(A\), the spatial-diffeomorphism central extension, under locality/background-free assumptions;
2. use DDH to constrain \(B\);
3. use the local spanning of \(\beta_q(N,M)\) plus HHH to kill \(B\);
4. DHH then reduces \(C\) to a diffeomorphism-natural skew pairing;
5. natural-operator self-adjointness kills \(C\);
6. conclude
\[
[\alpha]=0.
\]

This is much more structured than attacking the Hamiltonian-constraint commutator directly.

---

# 28. If the theorem succeeds

Then quantum gravity gets a binary structural requirement:

\[
\boxed{
\text{any physically local bulk quantization of 3+1 GR must be exactly anomaly-free;}
}
\]

there is no harmless bulk projective central extension to hide behind.

Regulated nonclosure is permitted only as a transient RG artifact whose noncentral curvature vanishes in the continuum.

Boundary central charges remain possible.

This would conceptually separate 3+1 gravity from 1+1 CFT/string-like constraint algebras.

---

# 29. If the theorem fails

A counterexample would be equally valuable.

An explicit nontrivial local cocycle

\[
[\alpha]\ne0
\]

would define new quantum geometric data.

Then we ask:

- does it integrate to a projective representation?
- is it refinement stable?
- does it become a relative phase in a general-boundary amplitude?
- does it modify black-hole/asymptotic charges?
- does it imply a quantum violation of exact refoliation equivalence while preserving rays?

That would be a real prediction-bearing structure.

---

# 30. Current mathematical state

We now have:

### Proved abstractly
\[
F=i\alpha I
\Rightarrow
d_A\alpha=0.
\]

### Proved gauge classification
\[
\alpha\sim\alpha+d_A\lambda.
\]

### Therefore
\[
[\alpha]\in H^2(A;\mathbb R)
\]
is the infinitesimal projective anomaly.

### Proved low-order restricted no-go
For closed \(\Sigma\), \(A=B=0\), background-free parity-even metric-ultralocal \(C\) with at most two lapse derivatives:
\[
C=0.
\]

### Proved local spanning
\[
\{\beta_q(N,M)(x)\}_{N,M}
=
T_x\Sigma.
\]

### Open decisive target
Prove
\[
H^2_{\rm local,phys}(A_{\rm HDA};\mathbb R)=0
\]
for closed 3-manifolds, with all nontrivial extensions forced to boundaries/asymptotics.

That is now the knife-edge problem.
