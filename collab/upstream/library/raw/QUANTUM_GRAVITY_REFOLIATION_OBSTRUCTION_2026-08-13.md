# Quantum Gravity from Refoliation Consistency
## Projective flatness, anomaly curvature, and a finite theorem that isolates the QM/GR compatibility condition

**Date:** 2026-08-13  
**Status:** active mathematical-physics research note. The finite theorems below are proved here. Their application to continuum 3+1 quantum gravity is a research program, not a claimed solution.

---

# 0. Target

General relativity says that a physical spacetime process must not depend on how we foliate spacetime into intermediate spatial slices. Canonically, this is encoded by the hypersurface-deformation algebra.

Quantum mechanics says that physical evolution is encoded by linear maps/amplitudes on Hilbert spaces, with operational predictions invariant under irrelevant representational choices.

The direct compatibility question is:

> **What exact mathematical condition must a quantum theory of geometry satisfy so that different refoliations are the same physical process?**

The answer is not merely “the constraints should close.” The sharper object is the curvature/holonomy of a Hilbert-space connection over the space of hypersurfaces.

The finite result is:

\[
\boxed{
\text{quantum refoliation invariance}
\iff
\text{projective flatness of the hypersurface transport}
}
\]

and the obstruction is a \(U(1)\)-valued 2-cocycle plus, before projectivization, an operator-valued curvature.

In the infinitesimal continuum limit this curvature becomes exactly the anomaly in the quantum hypersurface-deformation algebra.

This gives a clean hierarchy:

\[
\boxed{
\begin{array}{c}
\text{classical GR}\\
\text{zero curvature of hypersurface deformation transport}
\end{array}}
\]

\[
\boxed{
\begin{array}{c}
\text{operational quantum refoliation invariance}\\
\text{central/projective curvature only}
\end{array}}
\]

\[
\boxed{
\begin{array}{c}
\text{fully coherent general-boundary quantum gravity}\\
\text{zero curvature, unless the phase cocycle is physically quotiented}
\end{array}}
\]

The useful research problem is therefore to classify and kill this obstruction in 3+1 dimensions.

---

# 1. Finite hypersurface complex

Let \(K\) be a connected directed 2-complex.

- Vertices \(v\in K_0\) represent admissible spatial hypersurfaces.
- Directed edges \(e:v\to w\) represent elementary local hypersurface deformations.
- Directed paths represent finite refoliations.
- A 2-cell \(c\) has two boundary paths \(p_c,q_c:v\to w\) representing two decompositions of the same geometric deformation.

To each vertex \(v\) assign a complex Hilbert space \(\mathcal H_v\).

To each directed edge \(e:v\to w\) assign a unitary

\[
U_e:\mathcal H_v\to\mathcal H_w.
\]

For a path

\[
p=e_n\cdots e_1
\]

define

\[
U_p=U_{e_n}\cdots U_{e_1}.
\]

The central question is whether \(U_p\) depends on the chosen path between the same endpoints.

---

# 2. Exact and projective path independence

## Definition 2.1 — exact refoliation invariance

Transport is exactly path independent if for every two equivalent paths \(p,q:v\to w\),

\[
U_p=U_q.
\]

## Definition 2.2 — projective refoliation invariance

Transport is projectively path independent if for every two equivalent paths \(p,q:v\to w\), there exists a phase

\[
\omega(p,q)\in U(1)
\]

such that

\[
U_p=\omega(p,q)U_q.
\]

The distinction is forced by quantum mechanics: state rays, transition probabilities, and expectation values are invariant under an overall phase, while coherent sums of different histories can be sensitive to relative phases.

---

# 3. Plaquette holonomy

For every 2-cell \(c\) with boundary paths \(p_c,q_c:v\to w\), define the holonomy operator on \(\mathcal H_v\)

\[
\Omega_c
=
U_{q_c}^{-1}U_{p_c}.
\]

This compares the two elementary refoliations.

---

# 4. Finite Refoliation Theorem

## Theorem 4.1 — exact flatness

Assume \(K\) is simply connected as a 2-complex. Then exact path independence holds iff

\[
\Omega_c=I
\]

for every 2-cell \(c\).

### Proof

Necessity is immediate.

For sufficiency, any two paths with the same endpoints differ by a finite sequence of elementary 2-cell replacements and cancellations \(ee^{-1}\). Replacing \(p_c\) by \(q_c\) changes path transport by multiplication by \(\Omega_c=I\). Cancellations also contribute identity. Hence transports agree. QED.

---

## Theorem 4.2 — projective flatness

Assume \(K\) is simply connected. Transition rays are path independent iff every elementary holonomy is central:

\[
\Omega_c=\omega_c I,
\qquad
\omega_c\in U(1).
\]

### Proof

If every plaquette holonomy is scalar, every elementary path replacement changes \(U_p\) only by a scalar phase. Therefore all equivalent paths define the same projective linear map.

Conversely, if every pair of equivalent paths gives the same projective map, in particular the two boundary paths of each 2-cell obey

\[
U_{p_c}=\omega_cU_{q_c},
\]

hence

\[
\Omega_c=\omega_cI.
\]

QED.

---

# 5. Observable equivalence theorem

Let \(\psi\in\mathcal H_v\), \(\phi\in\mathcal H_w\).

## Theorem 5.1

If

\[
U_p=e^{i\theta}U_q,
\]

then

\[
|\langle\phi,U_p\psi\rangle|^2
=
|\langle\phi,U_q\psi\rangle|^2.
\]

Also, for every observable \(A\) on \(\mathcal H_w\),

\[
\frac{\langle U_p\psi,A\,U_p\psi\rangle}
{\langle U_p\psi,U_p\psi\rangle}
=
\frac{\langle U_q\psi,A\,U_q\psi\rangle}
{\langle U_q\psi,U_q\psi\rangle}.
\]

### Proof

The phase cancels in absolute squares and bilinear expectation values. QED.

Thus projective flatness is precisely sufficient for ordinary ray-level quantum predictions to be foliation independent.

---

# 6. The phase obstruction is a 2-cocycle

Suppose every 2-cell holonomy is scalar:

\[
\Omega_c=\omega_c I.
\]

Write

\[
\omega_c=e^{i\theta_c}.
\]

Consider a closed 2-cycle \(Z=\sum_c n_c c\). The total holonomy is

\[
\Omega_Z
=
\prod_c \omega_c^{n_c}.
\]

For consistency under decomposition of a null 2-boundary, this product must be 1.

Hence \(\omega\) defines a multiplicative \(U(1)\)-valued 2-cocycle.

Changing edge phases

\[
U_e\mapsto \lambda_eU_e,
\qquad
\lambda_e\in U(1)
\]

changes plaquette phases by a coboundary.

Therefore the gauge-invariant obstruction is

\[
\boxed{
[\omega]\in H^2(K;U(1)).
}
\]

---

## Theorem 6.1 — phase-removal criterion

A projectively flat transport can be rephased edge-by-edge into an exactly flat transport iff

\[
[\omega]=0\in H^2(K;U(1)).
\]

### Proof

If \([\omega]=0\), then \(\omega=\delta\lambda\) for some edge 1-cochain \(\lambda\). Rephase \(U_e\) by \(\lambda_e^{-1}\); every plaquette phase becomes 1.

Conversely, if an edge rephasing makes every plaquette holonomy identity, the original plaquette cocycle differs from 1 by the coboundary generated by that rephasing, so its class vanishes. QED.

This is already a genuine local-to-global quantum-gravity obstruction: local ray-level consistency need not imply globally coherent amplitude-level consistency.

---

# 7. Why this matters physically

There are two logically distinct interpretations of refoliations.

### Gauge interpretation

Different foliations are merely different descriptions of the same physical process. Then an overall phase attached to the complete map may be unobservable, and projective flatness is enough.

### Coherent-history interpretation

Different decompositions can occur as branches inside a larger amplitude sum. Then their relative phase can affect interference. In that setting a nontrivial \([\omega]\) is potentially observable, and exact flatness or a principled quotient of the phase is required.

This distinction is usually blurred by saying only “the constraint algebra must be anomaly free.”

The actual question is:

\[
\boxed{
\text{Which holonomies are gauge phases, and which become relative phases in a larger composition?}
}
\]

That is a concrete problem for general-boundary/spinfoam/path-integral formulations.

---

# 8. Infinitesimal deformation generators

Now take a continuum limit.

Let a deformation be specified by lapse \(N\) and shift \(v^a\). Write

\[
\xi=(N,v).
\]

Let the infinitesimal quantum transport be generated by

\[
\widehat G[\xi]
=
\widehat H[N]+\widehat D[v].
\]

For a small parameter \(\epsilon\),

\[
U_\xi(\epsilon)
=
\exp\left(
-\frac{i}{\hbar}\epsilon\widehat G[\xi]
\right).
\]

Consider the infinitesimal commutator loop

\[
U_\eta(-\epsilon)
U_\xi(-\epsilon)
U_\eta(\epsilon)
U_\xi(\epsilon).
\]

Baker-Campbell-Hausdorff gives

\[
\Omega(\xi,\eta)
=
I
-\frac{\epsilon^2}{\hbar^2}
[\widehat G[\xi],\widehat G[\eta]]
+O(\epsilon^3)
\]

before accounting for the fact that the geometric commutator of two hypersurface deformations is itself another deformation.

If the classical hypersurface-deformation bracket is

\[
[\xi,\eta]_{\rm HDA},
\]

the geometrically expected closing transport contributes

\[
I
-\frac{i}{\hbar}\epsilon^2
\widehat G[[\xi,\eta]_{\rm HDA}]
+O(\epsilon^3).
\]

Hence the operator curvature is

\[
\boxed{
\widehat{\mathcal F}(\xi,\eta)
=
\frac{1}{i\hbar}
[\widehat G[\xi],\widehat G[\eta]]
-
\widehat G[[\xi,\eta]_{\rm HDA}].
}
\]

This is the quantum refoliation curvature.

---

# 9. Infinitesimal Refoliation Theorem

## Theorem 9.1

To second order in infinitesimal deformations:

- exact refoliation invariance requires

\[
\widehat{\mathcal F}(\xi,\eta)=0;
\]

- ray-level refoliation invariance requires

\[
\widehat{\mathcal F}(\xi,\eta)
=
\alpha(\xi,\eta)I
\]

for a real bilinear antisymmetric scalar \(\alpha\).

### Proof

The residual commutator-loop operator is identity to order \(\epsilon^2\) exactly when curvature vanishes. It is a scalar phase to this order exactly when the curvature is scalar. QED.

Thus the usual quantum “anomaly” is literally curvature of hypersurface transport.

---

# 10. GR hypersurface-deformation structure

For classical ADM GR, with spatial metric \(q_{ab}\),

\[
\{D[v],D[w]\}
=
D[[v,w]],
\]

\[
\{D[v],H[N]\}
=
H[\mathcal L_vN],
\]

\[
\{H[N],H[M]\}
=
D[
q^{ab}(N\partial_bM-M\partial_bN)
].
\]

The last bracket contains the inverse spatial metric and therefore has structure functions rather than fixed structure constants.

This is why the structure is naturally an **algebroid**, not a Lie algebra.

Quantum gravity must therefore represent not merely a fixed algebra but a geometry-dependent deformation algebroid.

That is the central technical obstruction.

---

# 11. Quantum curvature components

Define

\[
\mathcal A_{DD}(v,w)
=
\frac{1}{i\hbar}
[\widehat D[v],\widehat D[w]]
-
\widehat D[[v,w]],
\]

\[
\mathcal A_{DH}(v,N)
=
\frac{1}{i\hbar}
[\widehat D[v],\widehat H[N]]
-
\widehat H[\mathcal L_vN],
\]

and

\[
\mathcal A_{HH}(N,M)
=
\frac{1}{i\hbar}
[\widehat H[N],\widehat H[M]]
-
\widehat D[
\widehat q^{ab}(N\partial_bM-M\partial_bN)
].
\]

The hardest term is the last one because the inverse metric is operator-valued and ordering/domain questions become inseparable from closure.

The compatibility problem QM + GR is therefore:

\[
\boxed{
\mathcal A_{DD}=
\mathcal A_{DH}=
\mathcal A_{HH}=0
}
\]

or, at minimum for projective ray covariance,

\[
\boxed{
\mathcal A_{\bullet\bullet}
\in \mathbb R\,I.
}
\]

---

# 12. Classical uniqueness enters

Hojman-Kuchař-Teitelboim showed, under specific locality/canonical assumptions, that requiring canonical generators to realize the hypersurface-deformation algebra essentially recovers ADM general relativity.

So the classical chain is:

\[
\text{path independence}
\Rightarrow
\text{HDA}
\Rightarrow
\text{GR dynamics}
\]

under HKT hypotheses.

The quantum chain suggested here is:

\[
\text{projective path independence}
\Rightarrow
\text{projective representation of HDA}
\Rightarrow
\text{classification of admissible quantum geometry}.
\]

This suggests a precise “quantum geometrodynamics regained” problem:

> Classify local, positive, unitary/projective representations of the hypersurface-deformation algebroid on a Hilbert bundle over nondegenerate quantum geometries, modulo local frame changes.

If the classification is rigid, quantum gravity may be much more constrained than “quantize Einstein's equations somehow.”

---

# 13. Connection over the space of hypersurfaces

Let \(\mathfrak S\) denote a formal space/groupoid of spatial hypersurfaces or embeddings.

Associate a Hilbert space \(\mathcal H_\Sigma\) to each \(\Sigma\).

A deformation direction \(\xi\) defines a covariant derivative

\[
\nabla_\xi
=
\delta_\xi
+
\frac{i}{\hbar}\widehat G[\xi].
\]

Then

\[
[\nabla_\xi,\nabla_\eta]
-
\nabla_{[\xi,\eta]_{\rm HDA}}
=
\frac{i}{\hbar}\widehat{\mathcal F}(\xi,\eta)
\]

up to sign convention.

Hence:

\[
\boxed{
\text{quantum gravity anomaly}
=
\text{curvature of the Hilbert bundle connection over hypersurface space}.
}
\]

This is not metaphor. It is the differential-geometric meaning of the failure of path-independent quantum evolution.

---

# 14. The “problem of time” becomes holonomy

In a generally covariant system there is no preferred external time parameter.

Instead of asking for one Hamiltonian \(H\) generating evolution in \(t\), assign transport to every admissible hypersurface deformation.

Then “time evolution” is parallel transport in \(\mathfrak S\).

Different clock choices/refoliations are different paths.

The problem of time is therefore partly the question:

\[
\boxed{
\text{Does parallel transport between the same physical boundaries depend on the chosen clock/foliation path?}
}
\]

If the connection is flat, no.

If projectively flat, only a phase survives.

If operator curvature survives, different clocks define genuinely different quantum predictions: refoliation invariance is broken.

This formulation interfaces naturally with relational quantum reference frames.

---

# 15. Quantum reference-frame covariance

A relational frame \(F\) selects physical coordinates from matter/geometry fields.

Let

\[
\mathcal H^{(F)}
\]

denote the corresponding frame-relative representation.

A frame transformation

\[
T_{F\to F'}
\]

should intertwine physical boundary amplitudes.

The latest relational path-integral work formulates gravity using frame-dressed observables and emphasizes covariance under quantum reference-frame changes.

The present structure suggests a second curvature:

\[
\mathcal F_{\rm frame}(F,F')
\]

measuring failure of frame-change transport to commute with hypersurface transport.

The full consistency square is:

\[
\begin{array}{ccc}
(\Sigma,F) & \xrightarrow{\text{evolve}} & (\Sigma',F)\\
\downarrow \text{frame} && \downarrow \text{frame}\\
(\Sigma,F') & \xrightarrow{\text{evolve}} & (\Sigma',F')
\end{array}
\]

and consistency requires equality/projective equality of the two composites.

This gives a mixed curvature

\[
\boxed{
\mathcal F_{\rm mixed}
=
T_{F\to F'}\,U^{(F)}
-
U^{(F')}\,T_{F\to F'}.
}
\]

A complete relational quantum gravity must kill both refoliation curvature and frame-change curvature.

---

# 16. New finite theorem: mixed-square obstruction

Take a finite square with horizontal hypersurface transport \(U_F,U_{F'}\) and vertical frame transforms \(T_\Sigma,T_{\Sigma'}\).

Define

\[
\Omega_{\rm mixed}
=
(U_{F'})^{-1}
T_{\Sigma'}
U_F
T_\Sigma^{-1}.
\]

## Theorem 16.1

Frame covariance and refoliation covariance commute on rays iff

\[
\Omega_{\rm mixed}
=
e^{i\theta}I.
\]

They commute as amplitudes iff

\[
\Omega_{\rm mixed}=I.
\]

### Proof

Exactly the projective-square argument of Theorem 4.2. QED.

This gives an experimentally/computationally testable obstruction in finite quantum-reference-frame models.

---

# 17. Nondegeneracy is structural, not cosmetic

The HDA contains \(q^{ab}\).

Therefore the algebra itself presupposes an invertible spatial metric.

A quantum representation that lives primarily on states where the metric is degenerate cannot straightforwardly represent the same algebroid.

Hence a possible necessary condition for a faithful quantum GR phase is:

\[
\boxed{
\text{the physical domain must support an inverse-metric operator strongly enough to define } \mathcal A_{HH}.
}
\]

This sharpens “geometry should emerge”: before even discussing semiclassical Einstein equations, the quantum state space must support the algebraic operation that tells two normal deformations how to compose.

That is a powerful filter on candidate quantum-gravity kinematics.

---

# 18. Renormalization reformulated

At finite regulator scale \(a\), exact HDA closure may fail:

\[
\mathcal F_a\neq0.
\]

That need not be fatal if the continuum limit satisfies

\[
\lim_{a\to0}
\mathcal F_a=0
\]

in a physically specified operator topology on a nondegenerate domain.

Thus “anomaly freedom” should be treated as an RG fixed-point property, not necessarily a finite-lattice identity.

Define anomaly norm

\[
\epsilon(a)
=
\sup_{\xi,\eta\in\mathcal B}
\|
\mathcal F_a(\xi,\eta)
\|_{\rm phys}
\]

for a bounded test family \(\mathcal B\).

A candidate continuum quantum gravity must exhibit

\[
\epsilon(a)\to0
\]

or a central limit

\[
\mathcal F_a\to\alpha I
\]

if only projective covariance is demanded.

This produces an actual numerical/theoretical diagnostic.

---

# 19. A cohomological classification problem

At the finite level, projective anomalies live in

\[
H^2(K;U(1)).
\]

At the infinitesimal level, central anomalies are Lie-algebroid 2-cocycles.

Therefore the first tractable classification question is:

> Compute the second cohomology controlling projective representations of finite/discretized hypersurface-deformation groupoids and determine which classes survive refinement.

Let

\[
K_1\prec K_2\prec\cdots
\]

be refinements of hypersurface complexes.

Each induces a pullback/pushforward map on anomaly classes.

A continuum anomaly is physically meaningful only if it defines a coherent pro-class under refinement.

So we should distinguish:

1. regulator artifact: class dies after refinement;
2. projective quantum effect: stable nonzero \(U(1)\) class;
3. true inconsistency: operator-valued noncentral curvature survives.

This is much sharper than one bit “anomalous/nonanomalous.”

---

# 20. Candidate Continuum Rigidity Conjecture

Here is the first genuinely ambitious conjecture generated by the synthesis.

## Conjecture QGR-Rigidity

Consider a local quantum field theoretic assignment satisfying:

1. to every admissible nondegenerate spatial hypersurface \(\Sigma\), a Hilbert space \(\mathcal H_\Sigma\);
2. to every compactly supported hypersurface deformation \(\xi=(N,v)\), an essentially self-adjoint generator \(\widehat G[\xi]\);
3. locality of generator densities;
4. spatial diffeomorphism covariance;
5. positive physical inner product;
6. projective refoliation invariance;
7. a semiclassical sector whose commutator bracket tends to the classical Poisson bracket;
8. local quantum-reference-frame covariance;
9. a refinement/renormalization limit with stable domains.

Then, modulo unitary equivalence, local counterterms, and possibly a \(U(1)\) anomaly class, the semiclassical deformation generators are forced to the Einstein hypersurface-deformation structure with cosmological constant and admissible matter couplings.

This is a quantum analogue of HKT rigidity.

I do **not** claim it is proved. But it is precise enough to attack.

---

# 21. Stronger conjecture: anomaly triviality in 3+1 gravity

## Conjecture QGR-Flat

Under the hypotheses above plus coherent general-boundary composition, the stable projective anomaly class vanishes:

\[
[\omega]_{\rm continuum}=0.
\]

Equivalently, the Hilbert bundle over physical hypersurface/frame space admits a globally flat connection after allowed local rephasings.

If true, quantum gravity has no genuine refoliation Berry phase.

If false, the surviving class is new physical data beyond classical GR.

Either outcome is interesting.

---

# 22. Relation to Berry curvature

Ordinary Berry phase appears when a quantum state is parallel transported around parameter space and returns with a phase.

The present construction says: the space of **foliations/reference frames themselves** may carry an analogous connection.

But unlike an external Hamiltonian parameter space, these directions are gauge/geometric redundancies.

Therefore a nontrivial Berry-like curvature here asks a severe question:

> Can a gauge redundancy possess observable quantum holonomy?

If the answer is no, anomaly class must vanish.

If yes, classical refoliation equivalence is quantum mechanically projective rather than exact.

This is a concrete conceptual fork.

---

# 23. Relation to path integrals

Let a spacetime region \(M\) have boundary \(\partial M\).

General-boundary quantum theory assigns an amplitude

\[
Z_M:\mathcal H_{\partial M}\to\mathbb C
\]

or a corresponding boundary map.

If

\[
M=M_2\cup_\Sigma M_1,
\]

gluing demands schematically

\[
Z_M
=
\operatorname{Tr}_{\mathcal H_\Sigma}
(Z_{M_2}Z_{M_1})
\]

with measure/gauge subtleties.

Different decompositions of the same \(M\) must give compatible amplitudes.

Thus the finite 2-cell theorem is the categorical skeleton of path-integral gluing consistency.

The continuum anomaly curvature is the infinitesimal shadow of decomposition dependence.

So canonical constraint closure and covariant path-integral gluing are two views of the same obstruction.

That is the key bridge.

---

# 24. Canonical/covariant equivalence target

A successful theory should establish:

\[
\boxed{
\text{HDA flatness}
\iff
\text{general-boundary gluing invariance}
}
\]

under explicit regularity assumptions.

One direction is intuitive: anomaly-free constraint transport gives path-independent deformation.

The reverse direction is deeper: sufficiently local gluing invariance should imply an infinitesimal deformation algebra, whose classical limit is HDA.

This is an actual theorem target.

---

# 25. Why this may be more constraining than quantizing a metric

The usual program starts with classical fields \(q_{ab},\pi^{ab}\), chooses variables, quantizes, then fights anomalies.

The alternative starts with the operational demand:

\[
\text{same physical region + same boundary data}
\Rightarrow
\text{same quantum map regardless of internal slicing}.
\]

This directly constrains the allowed quantum generators.

In classical gravity that principle is already extremely rigid through HKT.

The possibility is that the quantum version is similarly rigid and that much of “quantum gravity model space” can be eliminated by curvature before detailed dynamics are solved.

---

# 26. A finite model we can completely solve

Take \(K\) to be a square lattice discretizing two deformation directions \(X,Y\).

Assign a fixed Hilbert space \(\mathcal H\) to every vertex.

Let

\[
U_X(n,m),\qquad U_Y(n,m)
\]

be edge unitaries.

Plaquette holonomy is

\[
\Omega_{n,m}
=
U_Y(n+1,m)^{-1}
U_X(n,m+1)^{-1}
U_Y(n,m)
U_X(n,m)
\]

up to orientation convention.

Projective refoliation invariance is exactly

\[
\Omega_{n,m}\in U(1)I.
\]

Exact invariance is

\[
\Omega_{n,m}=I.
\]

The phase field

\[
\omega_{n,m}
\]

is a discrete curvature 2-form.

On a contractible grid, every projective phase field satisfying 2-cocycle consistency is gauge-removable.

On a toroidal hypersurface-parameter complex, a global flux can survive.

This gives a toy model where local anomaly-free squares can coexist with global holonomy depending on topology.

---

# 27. New theorem: local flatness is not global flatness

## Theorem 27.1

Let \(K\) be connected but not simply connected. Suppose every contractible elementary plaquette has identity holonomy. Then transport may still possess nontrivial global holonomy around noncontractible loops.

### Proof

A flat connection is a representation of \(\pi_1(K)\) into the unitary group. Nontrivial representations exist whenever \(\pi_1(K)\) admits them. QED.

Hence local constraint closure alone does not guarantee global refoliation independence if the relevant hypersurface/frame space has nontrivial topology.

The global classification object is a representation

\[
\rho:\pi_1(\mathfrak S)\to PU(\mathcal H)
\]

or, before projectivization,

\[
\rho:\pi_1(\mathfrak S)\to U(\mathcal H).
\]

This global issue deserves explicit attention in quantum gravity.

---

# 28. Quantum gravity as a representation problem

The synthesis can now be written in one line.

Classical GR supplies a deformation groupoid/algebroid \(\mathcal G_{\rm HDA}\).

Quantum gravity seeks a functorial/projective unitary representation

\[
\boxed{
\mathcal U:
\mathcal G_{\rm HDA}
\longrightarrow
\mathbf{Hilb}
}
\]

such that:

- composition maps to operator composition;
- gauge-equivalent refoliations map to equal/projectively equal maps;
- nondegenerate geometry is represented;
- the classical limit recovers Einstein geometrodynamics;
- local observables are relational/frame-covariant;
- gluing agrees with covariant amplitudes.

This is a much cleaner mathematical statement of the target than “quantize spacetime.”

---

# 29. Where quantum mechanics enters nontrivially

Nothing above yet derives the Born rule or Hilbert space from GR.

The genuine quantum input is:

1. boundary state spaces are Hilbert spaces;
2. physical transformations are linear/unitary/projective;
3. amplitudes compose linearly;
4. superposition makes relative path phases potentially physical.

GR contributes the deformation algebra.

The compatibility problem is the existence/classification of representations satisfying both structures simultaneously.

That is the exact intersection.

---

# 30. Where GR enters nontrivially

This is not generic gauge theory.

The normal-normal bracket closes into a tangential deformation with coefficient \(q^{ab}\), so geometry appears **inside its own deformation law**.

Schematically,

\[
[H,H]\sim q^{-1}D.
\]

The object being transformed controls the algebra of transformations.

That self-reference is likely the deepest reason quantum gravity is hard.

A conventional Lie-group quantization quantizes a fixed symmetry algebra.

GR asks for a quantum representation of an algebroid whose structure functions are themselves quantum observables.

So the core problem may be stated as:

\[
\boxed{
\text{quantize a self-referential symmetry algebroid without curvature/anomaly}.
}
\]

---

# 31. Candidate route through groupoids

Instead of demanding operators satisfy the infinitesimal HDA directly, exponentiate finite deformations into a groupoid.

This has two advantages:

1. finite composition may be better defined than products of operator-valued distributions;
2. anomaly becomes literal holonomy.

Thiemann's exact \(U(1)^3\) model demonstrates that exponentiating the hypersurface-deformation algebroid and groupoid averaging can yield an exact anomaly-free quantization in a nontrivial generally covariant model.

The obvious research move is therefore:

> Identify which structural features of the \(U(1)^3\) exponentiation permit exact flatness and determine the obstruction to lifting them to SU(2)/Lorentzian GR.

That is a concrete frontier problem, not philosophy.

---

# 32. Candidate obstruction decomposition

For a regulated theory define

\[
\mathcal F_a
=
\mathcal F_a^{\rm domain}
+
\mathcal F_a^{\rm ordering}
+
\mathcal F_a^{\rm discretization}
+
\mathcal F_a^{\rm topology}
+
\mathcal F_a^{\rm true}.
\]

Interpretation:

- domain: inverse metric/generator not simultaneously defined;
- ordering: noncommuting operator choices generate spurious terms;
- discretization: finite regulator breaks diffeomorphism symmetry;
- topology: globally flat locally but nontrivial holonomy;
- true: regulator-stable noncentral obstruction.

The research program should separate these experimentally/mathematically rather than calling all failures “the anomaly problem.”

---

# 33. A falsifiable near-term theorem target

Take a finite simplicial/Regge-like region and its elementary hypersurface moves.

Construct the move 2-complex \(K\).

Assign quantum amplitudes/operators to elementary Pachner-like moves.

Compute all elementary 2-cell holonomies corresponding to relations among moves.

Then ask:

\[
\Omega_c\stackrel{?}{\in} U(1)I.
\]

If not, the model fails quantum refoliation invariance at that scale.

If yes, compute

\[
[\omega]\in H^2(K;U(1)).
\]

Then refine triangulation and track the induced anomaly class.

This is executable.

---

# 34. Relation to spin foams

Spin foams already assign amplitudes to combinatorial spacetime histories and use local gluing.

The present criterion says the crucial test is not merely convergence or semiclassical asymptotics but **move/refinement holonomy**:

Do two sequences of local spacetime moves with the same boundary induce the same boundary amplitude/map?

Topological theories satisfy strong move invariance.

4D gravity is not topological, so local bulk degrees of freedom complicate the comparison, but refoliations representing gauge-equivalent decompositions should still induce equivalent physical maps.

Thus we need to separate:
- physically different bulk histories;
- different decompositions of the same history.

Only the latter must be flat.

This distinction can be encoded in the move complex.

---

# 35. Relation to causal dynamical triangulations / discrete gravity

A fixed preferred foliation can avoid the refoliation problem by construction, but then full diffeomorphism/refoliation invariance must emerge in the continuum if GR is recovered.

Our anomaly norm \(\epsilon(a)\) becomes an observable diagnostic of that emergence.

So the framework applies even to theories that do not impose exact symmetry microscopically.

---

# 36. Relation to Wolfram causal invariance

Wolfram's causal invariance asks whether different update orders produce the same causal structure.

The exact mathematical overlap is now visible:

\[
\text{causal invariance}
\leftrightarrow
\text{discrete path independence under local update reorderings}
\]

while GR's HDA is the continuum geometry of hypersurface path independence.

The nontrivial quantum extension is to replace equality of classical outcomes by projective equality of Hilbert-space transport and then classify the resulting holonomy.

This is a concrete bridge, not an identification of the theories.

---

# 37. Relation to the Library's reconstruction/obstruction program

The Prime-Pair work developed a disciplined pattern:

1. define observable quotient;
2. characterize ambiguity fiber;
3. find the smallest supplement;
4. if reconstruction fails, identify a canonical obstruction;
5. demand stability under refinement.

The same architecture applies here.

Observable quotient:
boundary relational data.

Ambiguity fiber:
all internal foliations/histories compatible with the same boundary process.

Reconstruction target:
one well-defined physical quantum map.

Obstruction:
holonomy/curvature class.

Stability:
behavior under regulator refinement.

This is a mathematically exact reuse of the research method, not a physics analogy.

---

# 38. What would count as an actual breakthrough

Any of the following would be real:

### A. Rigidity theorem
Prove a quantum HKT theorem: projectively flat local representations with the correct semiclassical limit force Einstein dynamics plus a sharply classified finite set of quantum corrections.

### B. Anomaly triviality theorem
Show the relevant second algebroid/groupoid cohomology vanishes under physical locality/unitarity/nondegeneracy assumptions.

### C. Constructive representation
Build a nonperturbative, positive Hilbert-space representation of the full Lorentzian 3+1 HDA with exact flatness and a controlled semiclassical sector.

### D. Canonical-covariant equivalence
Prove exact equivalence between flat hypersurface transport and decomposition-independent gravitational path-integral gluing.

### E. New stable anomaly
Find a nontrivial refinement-stable \(U(1)\) class and derive an observable consequence.

Those are theorem-sized targets.

---

# 39. The immediate mathematical attack

The lowest-dimensional nontrivial path is:

1. finite deformation 2-complex;
2. classify projective holonomies;
3. pass to a parametrized field theory where the HDA is exactly known;
4. reproduce the continuum anomaly as curvature;
5. repeat in \(U(1)^3\) gravity;
6. isolate what changes when the structure functions become the full non-Abelian gravitational variables;
7. attempt a cohomological/no-go or constructive lifting theorem.

The key object to calculate is not a wavefunction of the universe.

It is

\[
\boxed{
\mathcal F(\xi,\eta)
=
\frac{1}{i\hbar}[G_\xi,G_\eta]-G_{[\xi,\eta]_{\rm HDA}}.
}
\]

Kill that in the right representation, globally and under refinement.

Then the quantum evolution does not care how spacetime is sliced.

That is the mathematical compatibility condition between quantum theory and general covariance.

---

# 40. Current result

The finite part is proved:

\[
\boxed{
\text{ray-level refoliation invariance}
\iff
\Omega_c\in U(1)I
}
\]

on a simply connected deformation 2-complex, and the obstruction to upgrading projective invariance to exact amplitude invariance is

\[
\boxed{
[\omega]\in H^2(K;U(1)).
}
\]

Its infinitesimal continuum shadow is

\[
\boxed{
\mathcal F(\xi,\eta)
=
\frac{1}{i\hbar}[G_\xi,G_\eta]
-
G_{[\xi,\eta]_{\rm HDA}},
}
\]

i.e. the quantum constraint anomaly interpreted as curvature.

The next serious task is not more prose: compute this obstruction in an exact generally covariant quantum model, then lift toward 3+1 Lorentzian GR.
