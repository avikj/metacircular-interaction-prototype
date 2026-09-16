# Charged coherence, lossless transport, and superconductivity

## Working research notes — September 16, 2026

This is the persistent mathematical notebook for Avik Jain's superconductivity investigation. The central target is a physical room-temperature superconducting realization. Work proceeds by exact deductions on the joint object, transporting established knowledge and retaining the residual of every proposed reduction. The related mathematical branches remain available together; discussion of the general method must not replace the physical calculation.

These notes import and organize the substantive derivations from the conversation notebooks rather than offering a result inventory. The preceding integrated conversation source, `RESEARCH_NOTES.md`, has SHA-256 `95465e40069c0ce6cc1b732ff19d2f4e0be5cf3876145c92ee5688a14cd50623`. This repository edition is a reorganization, not a byte-identical copy. The generalization formerly called Section 21 is now `FINITE_GAP_PAIR_REDUCTION.md`; the constructive-method continuation is `CONSTRUCTIVE_TRANSPORT_AND_RESEARCH_CONTINUATION.md`. New results on exhaustive ground spaces and exact density response are developed in `GROUND_SPACE_AND_DENSITY_RESPONSE.md`. Those files and the definitions below are sufficient to resume without the conversation.

The initial repository mathematics was read at `e0e4623c03a5a1a0afa17ca271bf6bbb3cacbf63`. The repository head before import was `8b02225e1ca128e72f3509b51ff3bed0a2950ba9`. Mathematical scope is determined by the terms and derivations, not by stronger phrases in an abstract or comment. No existing formal module is replaced by this notebook.

The current results include a complete finite-gap two-electron solution, exact paired states for two related but different many-body Hamiltonians, and explicit transport, thermal, and source-coupling residuals. They do not contain a chemical composition or an evaluated finite-temperature bulk Meissner response. This identifies the current equations to continue, not a reason to stop the mathematical investigation.

# 1. The shared object and the model distinctions

A periodic cubic lattice has L_x,L_y,L_z >= 3 cells and N=L_x L_y L_z. There are eight physical orbitals per cell and two conserved spin labels. A physical label i=(R,alpha) ranges over 8N sites. The physical Fock space has 16N fermion modes. The one-up/one-down space at fixed allowed total momentum has dimension 64N.

The lower one-electron energy is zero, the upper energy is Delta_b>0, and onsite attraction is U>0. A bound pair has E=-x, x>0. Crystal momentum has inverse-length units. The pair Hessian has energy-times-length-squared units and becomes inverse mass after division by hbar². Imaginary-time formulas use hbar=1; physical time and mass formulas display hbar. The pair charge magnitude is q_star=2e. Signs of charged phase and current must change together under a signed-charge convention.

There are three Hamiltonians, never one unnamed model:

\[
H_{on}=\sum_{ij,\sigma}h^\sigma_{ij}c_{i\sigma}^\dagger c_{j\sigma}
-U\sum_i n_{i\uparrow}n_{i\downarrow}.
\tag{1.1}
\]

This is the original finite-gap onsite model. Its pair spectrum is solved below; its finite-density Gibbs response remains a distinct problem.

\[
H_{projected}=-U\sum_i\bar n_{i\uparrow}\bar n_{i\downarrow}.
\tag{1.2}
\]

This acts on the lower-band Fock space. Its projected fields do not have canonical anticommutation relations on the 8N physical labels.

\[
H_{parent}=\Delta_b\widehat N_{upper}
-U\sum_i\bar n_{i\uparrow}\bar n_{i\downarrow}.
\tag{1.3}
\]

This acts on the full physical Fock space, with the projected fields implemented as operators inside it. It is a finite-gap model with a different interaction tensor. Its exact mismatch is

\[
V_{res}=H_{on}-H_{parent}
=-U\sum_i(n_{i\uparrow}n_{i\downarrow}-\bar n_{i\uparrow}\bar n_{i\downarrow}).
\tag{1.4}
\]

The same band geometry does not make (1.1)-(1.3) equal. Each reduction must carry (1.4) when its conclusion is moved between them.

P denotes a one-electron spectral projector. Pi denotes a many-body subspace projector. Q_hat denotes a fourfold unitary when discussing symmetry. K denotes pair momentum; K_med is a mediator kernel. The physical scalar source is varphi; the pair wavefunction is phi. These similarly written symbols have different types.

Momentum derivatives below refer to the displayed continuous Bloch formulas, or a specified boundary-twist extension. They are not derivatives of an uninterpreted finite list of allowed momenta.

# 2. Fibre conduction, the phase algebra, and the actual physical reading

For any map f:A->B, the canonical dependent completion is

\[
A\simeq\sum_{b:B}\operatorname{fib}_f(b),\qquad
\operatorname{fib}_f(b)=\sum_{a:A}(f(a)=b),
\quad a\mapsto(f(a),(a,refl)).
\tag{2.1}
\]

The inverse takes the retained a; its other inverse path uses the retained equality. `Fibre.Trace` proves the stronger over-the-base statement: if A is conservatively presented as sum_b T(b), with visible map run given by the first projection, then T(b) is equivalent to fib_run(b). An arbitrary total-space equivalence need not present a preselected f. The Boolean counterexample in that module distinguishes these cases.

Every later question A->Z can be transported to the family product_b(fib_f(b)->Z). Its value is obtained from the retained source, not guessed from a coarse result. Discarding the fibre additionally requires descent of the actual question. Equal visible values with different target values obstruct descent immediately. Higher targets require the corresponding coherent descent, not just a set-level slogan.

The universal family pi:sum_(X:U) X -> U classifies dependent families. The relevant source is `Fibre.Visvarupa`; `Fibre.CorpusSamvada` has points sum_(A:Type) A and questions (B,f:A->B). `CorpusSelfPresentation` returns the target, the actual residual, and a productive continuation at the target. `Fibre.Nucleus` transports entire coinductive orbits. These are operative interfaces, not a finite endpoint list used as a substitute for the process.

For physical use the package also contains Hilbert structure, energy, source coupling, probability weight, and boundary conditions. A correspondence between bare labels is not automatically a correspondence of those structures. The rest of this notebook makes the required maps explicit.

On the interdependent Boolean pair,

\[
q(a,b)=(\neg b,a),\quad q^2(a,b)=(\neg a,\neg b),\quad q^4=1.
\tag{2.2}
\]

`CaturamsaBhramana` proves that q does not descend to either separate projection, while q² does. Signed encoding gives

\[
J=\begin{pmatrix}0&-1\\1&0\end{pmatrix},\quad J^2=-I,
\]
\[
(aI+bJ)(cI+dJ)=(ac-bd)I+(ad+bc)J.
\tag{2.3}
\]

The planar real algebra is complex multiplication, and its norm-one elements are rotations. `PythagoreanTransition` proves this pair product and multiplicative norm over an arbitrary commutative ring, constructs the norm-one equivalences, and internalizes them as executable universe paths. The four compositional powers, their linear algebra, and its modules are related constructions, not competing counts of one set.

For the rope crossing R(x,y)=(q(y),x), R²=(q x,q y), R⁸=1, and both Yang–Baxter composites on three cells evaluate to (q²z,qy,x). Word factorization retains the bare permutation and deposited twists. Each cell reads its own twist count modulo four, which determines the twist kernel. The centralizer proof uses prefix readers and mixing to force one common q-equivariant cell map, hence a uniform power of q. These are connected consequences of one action.

The displayed Agda reader definition has zero lookahead. The conversation also derived the finite-head-readable extension: if T(s)_0=H(s_0,...,s_m) and T commutes with every crossing, a crossing at the last reading boundary gives H(prefix,q b)=H(prefix,a). Surjectivity removes that input. Repeat to obtain T(s)_0=g(s_0). Commutation at consecutive outputs propagates the same g, and the remaining equation gives gq=qg. This additional ordinary derivation has not been claimed as a newly compiled module.

A configuration-map centralizer does not automatically equal a physical linear-operator commutant; Section 12 retains the representation issue explicitly.

Spatial-prefix completion and homotopy truncation are different readings. In particular, helix transport around the homotopical circle shifts an integer, while a constant family gives trivial transport around the same loop. Integer winding is not the compositional order of every local phase operation. The family and the actual projection determine what is retained.

# 3. Charged joint phase and the superconducting observable

Under c_sigma -> exp(i chi)c_sigma, a pair b=c_down c_up transforms as exp(2i chi)b. A single-electron quarter turn changes the sign of b; a single-electron half turn leaves it fixed. This is a charge-two representation, not by itself an energetic pairing theorem.

For one pair shared between two regions,

\[
|\psi_\phi\rangle=2^{-1/2}(|1,0\rangle+e^{i\phi}|0,1\rangle),
\]

both local occupation marginals are (|0><0|+|1><1|)/2, independent of phi, while

\[
\langle b_L^\dagger b_R\rangle=\tfrac12 e^{i\phi}.
\tag{3.1}
\]

The joint transfer observes information absent from both isolated occupation readings. A macroscopic superconducting state requires the appropriate many-body order and response, not just this two-region example.

In a specified phase-only regime, with nonzero amplitude and thermodynamic stiffness Upsilon,

\[
v_i=\partial_i\theta-\frac{q_\star}{\hbar}A_i,\qquad
F_\theta=\tfrac12\int d^d x\,\Upsilon_{ij}v_iv_j,
\]
\[
j_i=-\frac{\delta F_\theta}{\delta A_i}
=\frac{q_\star}{\hbar}\Upsilon_{ij}v_j.
\tag{3.2}
\]

For isotropic three-dimensional bulk, magnetostatics and the curl give

\[
\lambda_L^{-2}=\mu_0 q_\star^2\Upsilon/\hbar^2.
\tag{3.3}
\]

Around a loop avoiding zeros of the order parameter, integral grad(theta).dl=2pi n. Therefore

\[
\Phi+\mu_0\lambda_L^2\oint j\cdot dl=n h/q_\star.
\tag{3.4}
\]

The route carries winding even when its endpoint phase returns. Vortex cores and boundary crossings change the domain on which the nonvanishing phase description applies. A conserved total winding label permits opposite defects; it does not supply their thermal weights.

On a graph, let phi_ij=theta_j-theta_i-a_ij, with a_ij=q_star integral A.dl/hbar. The specified Josephson energy -sum E_ij cos(phi_ij) gives I_ij=q_star E_ij sin(phi_ij)/hbar and V_ij=hbar dot(phi_ij)/q_star in the consistent convention. With incidence B, the phase Hessian is

\[
B\,\operatorname{diag}(E_{ij}\cos\phi_{ij})\,B^{\mathsf T}.
\tag{3.5}
\]

`KirchhoffIncidence` supplies gradient, divergence, summation by parts, and the incidence Gram operator. Physical coupling energies and their thermal response are additional data. A Drude response and equilibrium transverse stiffness use different limits of the current correlation function; one cannot be substituted for the other.

# 4. A finite-range three-dimensional projector

Take

\[
u(k)=e^{kaJ/2}\binom10=\binom{\cos(ka/2)}{\sin(ka/2)},
\]
\[
p(k)=u(k)u(k)^{\mathsf T}
=\tfrac12\begin{pmatrix}1+\cos ka&\sin ka\\\sin ka&1-\cos ka\end{pmatrix}.
\tag{4.1}
\]

The vector is antiperiodic over a Brillouin period; the projector is periodic. A normalized periodic frame is

\[
w(k)=e^{ika/2}u(k)
=\binom{(1+e^{ika})/2}{(e^{ika}-1)/(2i)}.
\tag{4.2}
\]

Direct multiplication gives w†w=1 and ww†=p. Its Fourier support is at zero and one, so the Wannier vector occupies two neighboring cells. Pointwise Bloch normalization makes all lattice translates orthonormal.

In three dimensions,

\[
P(k)=p(k_x)\otimes p(k_y)\otimes p(k_z),
\quad w(k)=w(k_x)\otimes w(k_y)\otimes w(k_z).
\tag{4.3}
\]

The real-space frame W:C^N->C^(8N) has support in a 2x2x2 cube and

\[
W^\dagger W=I_N,\quad P=WW^\dagger,\quad P_{ii}=p_0=1/8.
\tag{4.4}
\]

Independent averages of each diagonal factor give one half and hence p_0. The lattice-size conventions ensure the first- and second-harmonic Fourier averages used below are exact.

Set

\[
h_\uparrow(k)=\Delta_b[I-P(k)],\qquad
h_\downarrow(k)=h_\uparrow^*(-k).
\tag{4.5}
\]

There is one lower flat band and seven upper bands for each spin. Matrix entries have Fourier support in displacements with components -1,0,1, proving finite range. In real space h_down=h_up*; use W and W* as the lower frames:

\[
\bar c_{i\uparrow}=\sum_aW_{ia}d_{a\uparrow},\qquad
\bar c_{i\downarrow}=\sum_aW_{ia}^*d_{a\downarrow}.
\tag{4.6}
\]

Their anticommutators are P_ij and P_ij*. The complete lower-band interaction tensor multiplying d_a↑†d_b↑d_c↓†d_d↓ is

\[
-U\sum_iW_{ia}^*W_{ib}W_{ic}W_{id}^*.
\tag{4.7}
\]

Dropping some of these terms to keep only a preferred bosonic hopping is another model change.

The rank-one quantum metric is

\[
g_{\mu\nu}=\operatorname{Re}\langle\partial_\mu w|(1-P)|\partial_\nu w\rangle.
\]

Since partial_k u=(a/2)Ju is orthogonal to u, the one-dimensional metric is a²/4. Product differentiation gives g_munu=a² delta_munu/4 for (4.3) in its fixed orbital convention. This does not itself determine an electromagnetic response. The periodic frame also does not imply a nonzero first Chern class: a trivial line bundle can have nonzero metric.

A later exact literature comparison identifies the one-dimensional block with a flat Creutz ladder after scale, energy shift, and momentum relabeling. For h_C(k)=-2t_C[sin(ka)sigma_z+cos(ka)sigma_x],

\[
\Delta_b[I-p(k)]=\tfrac{\Delta_b}{2}I+h_C(k'),
\quad k'a=\pi/2-ka,\quad t_C=\Delta_b/4.
\tag{4.8}
\]

This is a Bloch-family identity. Boundaries, physical sources, and interactions must follow the coordinate change. The three-dimensional operator is Delta_b(I-p_x tensor p_y tensor p_z), not a sum of three independent ladders.

# 5. The complete finite-gap pair problem

At fixed allowed pair momentum K, define eight orthonormal contact states

\[
|\alpha;K\rangle=N^{-1/2}\sum_k
|k,\alpha,\uparrow;K-k,\alpha,\downarrow\rangle.
\tag{5.1}
\]

Let C be their isometry. On this spin sector, onsite attraction is exactly -UCC†. The free pair levels 0,Delta_b,2Delta_b have multiplicities N,14N,49N, with projectors P_LL, P_LU+P_UL, P_UU.

The contact Gram matrix is G(K)=C†P_LL C. For one coordinate,

\[
(G_1)_{\alpha\beta}(K)=\overline{p_{\alpha\beta}(k)p_{\alpha\beta}(k-K)}.
\]

Averages of sine and cosine vanish; averages cos(k)cos(k-K) and sin(k)sin(k-K) equal cos(K)/2. Thus

\[
G_1(q)=\tfrac18\begin{pmatrix}2+\cos qa&\cos qa\\\cos qa&2+\cos qa\end{pmatrix},
\qquad G(K)=\bigotimes_\mu G_1(K_\mu).
\tag{5.2}
\]

The fixed vectors v_+=(1,1)/sqrt2 and v_-=(1,-1)/sqrt2 have eigenvalues

\[
\lambda_+(q)=(1+\cos qa)/4,\qquad\lambda_-(q)=1/4.
\tag{5.3}
\]

The eight channel eigenvalues are the products. They satisfy 0<=lambda<=1/8. Near K=0 the unique largest channel is

\[
\lambda_0(K)=\tfrac18\prod_\mu\cos^2(K_\mu a/2),
\quad\partial_i\partial_j\lambda_0(0)=-a^2\delta_{ij}/16.
\tag{5.4}
\]

Each single-particle lower projector compressed between contact states is I/8, because the other particle's identity forces the orbital labels to agree. Hence all three residues are

\[
C^\dagger P_{LL}C=G,\quad
C^\dagger(P_{LU}+P_{UL})C=I/4-2G,\quad
C^\dagger P_{UU}C=3I/4+G.
\tag{5.5}
\]

They are positive semidefinite and sum to I. For x>0,

\[
C^\dagger(H_0+x)^{-1}C
=G/x+(I/4-2G)/(x+\Delta_b)+(3I/4+G)/(x+2\Delta_b).
\tag{5.6}
\]

Every residue is affine in the same G, so the finite gap does not break common diagonalization.

For a negative-energy eigenstate, (H_0-E)psi=UC C†psi. Set v=UC†psi. It cannot vanish, since H_0 is nonnegative. Conversely each nonzero solution of

\[
[U^{-1}I-C^\dagger(H_0-E)^{-1}C]v=0
\]

reconstructs a nonzero eigenstate by

\[
\psi=(H_0-E)^{-1}Cv.
\tag{5.7}
\]

This proves a necessary-and-sufficient solution correspondence with its inverse, not only a variational condition.

In a channel lambda,

\[
1/U=f(x,\lambda):=\lambda/x+(1/4-2\lambda)/(x+\Delta_b)
+(3/4+\lambda)/(x+2\Delta_b).
\tag{5.8}
\]

Clearing denominators gives

\[
x^3+(3\Delta_b-U)x^2+(2\Delta_b^2-5U\Delta_b/4)x
-2U\lambda\Delta_b^2=0.
\tag{5.9}
\]

For lambda>0 the rational function strictly decreases from infinity to zero on x>0, so exactly one bound state exists for every U>0. If lambda=0, its limit at x=0 is 5/(8Delta_b), so binding requires and is implied by U>8Delta_b/5. Equality is a threshold, not a negative energy.

The full spectrum, not just its negative roots, is encoded by

\[
q_\lambda(E)=E^3+(U-3\Delta_b)E^2
+(2\Delta_b^2-5U\Delta_b/4)E+2U\lambda\Delta_b^2,
\]
\[
\boxed{\det(E-H_K)=E^{N-8}(E-\Delta_b)^{14N-8}
(E-2\Delta_b)^{49N-8}\prod_s q_{\lambda_s(K)}(E).}
\tag{5.10}
\]

Proof: apply the determinant lemma to E-H_0+UCC† away from its free poles. Each of the eight contact channels has denominator E(E-Delta_b)(E-2Delta_b) and numerator q_lambda. Both sides are polynomials, extending the identity through the poles. Vanishing residues restore flat factors through the cubic. The degree is N-8+14N-8+49N-8+24=64N. Reconstruction at a free pole uses the non-inverted block equations; (5.7) was asserted for E<0, where its inverse exists.

# 6. Binding, interband normalization, and an exact mobility optimum

At K=0, lambda=1/8 and the mixed residue vanishes. Then

\[
1/U=1/(8x_0)+7/[8(x_0+2\Delta_b)],
\]
\[
x_0^2+(2\Delta_b-U)x_0-U\Delta_b/4=0,
\]
\[
\boxed{x_0=\frac{U-2\Delta_b+\sqrt{(2\Delta_b-U)^2+U\Delta_b}}2.}
\tag{6.1}
\]

The roots have opposite signs, making this the unique positive root. The normalized contact vector reconstructs an unnormalized wavefunction of norm

\[
\|\psi\|^2=1/(8x_0^2)+7/[8(x_0+2\Delta_b)^2].
\]

The upper/upper probability is

\[
p_{UU}=\frac{7x_0^2}{(x_0+2\Delta_b)^2+7x_0^2}.
\tag{6.2}
\]

Define

\[
A(x)=\partial_\lambda f=1/x-2/(x+\Delta_b)+1/(x+2\Delta_b)
=\frac{2\Delta_b^2}{x(x+\Delta_b)(x+2\Delta_b)},
\]
\[
B(x,\lambda)=-\partial_x f
=\lambda/x^2+(1/4-2\lambda)/(x+\Delta_b)^2
+(3/4+\lambda)/(x+2\Delta_b)^2.
\tag{6.3}
\]

Implicit differentiation yields dx/dlambda=A/B>0. The denominator is the reconstruction norm. Put W(U,Delta_b)=A(x_0)/B(x_0,1/8). Since the first derivative of lambda_0 vanishes,

\[
\partial_i\partial_jE_{pair}(0)=a^2W\delta_{ij}/16,
\qquad(m_{pair}^{-1})_{ij}=a^2W\delta_{ij}/(16\hbar^2).
\tag{6.4}
\]

Let t=x_0/Delta_b. Eliminating the quadratic gives

\[
U/\Delta_b=\frac{4t(t+2)}{4t+1},\qquad
W/\Delta_b=\frac{4t(t+2)}{(t+1)(2t^2+t+1)}.
\tag{6.5}
\]

The derivative of the first function is (16t²+8t+8)/(4t+1)²>0. The second derivative has sign opposite to

\[
t^4+4t^3+2t^2-t-1.
\tag{6.6}
\]

Its explicit value is -8 times this polynomial divided by (t+1)²(2t²+t+1)². Descartes' rule gives at most one positive root, while the signs at zero and infinity give one. Therefore the mobility has a unique global maximum over U>0 at fixed projector, gap, and lattice spacing. The positive root is approximately 0.582205155700574, giving U_star/Delta_b approximately 1.80649344026221 and W_star/Delta_b approximately 1.68162983956482. There p_UU approximately 0.262456033386548.

The exact limiting identities W/U->1 as U/Delta_b->0 and WU/Delta_b²->2 as U/Delta_b->infinity show the turnover. No parameter sweep selected the maximum. It is a two-electron mobility optimum, not an evaluated optimum of T_c. The general p-dependent version is proved in `FINITE_GAP_PAIR_REDUCTION.md`.

At all momenta the lowest pair selects

\[
\lambda_{max}(K)=\frac1{64}\prod_\mu\max\{1+\cos(K_\mu a),1\}.
\tag{6.7}
\]

This ranges between 1/64 and 1/8 and switches fixed channels when a cosine changes sign. The global bandwidth is x(1/8)-x(1/64). A derivative of one smooth channel at a crossing is not automatically a derivative of the lowest envelope. All channels remain in the spectral answer and thermal trace.

The constant contact eigenvector near the origin is v=(1,...,1)/sqrt8. Its contact-mode texture metric vanishes because its derivatives vanish. The reconstructed state (H_0-E)^(-1)Cv and its Bloch constituents can still vary with K. This distinguishes finite-gap/interband structure from the additional momentum texture of a contact pairing mode discussed in the 2026 pair-geometry literature.

# 7. Exact projected paired states and their density degeneracy

From the projected anticommutator {bar c_i,bar c_i†}=p_0,

\[
\bar n_{i\sigma}^2=p_0\bar n_{i\sigma}.
\]

The proof is bar c_i†(p_0-bar n_i)bar c_i=p_0 bar n_i; the remaining term vanishes by nilpotence. Isometry gives sum_i bar n_i_sigma=Nhat_sigma. With M_i=bar n_i_up-bar n_i_down,

\[
\boxed{H_{projected}+\frac{Up_0}{2}\widehat N
=\frac U2\sum_iM_i^2.}
\tag{7.1}
\]

Let eta†=sum_a d_a_up†d_a_down†. Complex-conjugate frames imply

\[
[\bar n_{i\uparrow},\eta^\dagger]
=[\bar n_{i\downarrow},\eta^\dagger]
=\bar c_{i\uparrow}^\dagger\bar c_{i\downarrow}^\dagger.
\]

Thus [M_i,eta†]=0. Since M_i kills the vacuum, the nonzero states

\[
|M\rangle=(\eta^\dagger)^M|0\rangle,\qquad0\le M\le N,
\]

saturate (7.1) and have fixed-number ground energies

\[
E_M=-Up_0M=-UM/8.
\tag{7.2}
\]

Equivalently [H_projected,eta†]=-Up_0 eta†. The original notebook exhibited these ground states without claiming uniqueness. The connected-frame uniqueness and entire common-kernel classification are now proved in `GROUND_SPACE_AND_DENSITY_RESPONSE.md`.

Different mode-pair creators b_a†=d_a_up†d_a_down† commute, and each squares to zero. Expanding eta^M gives M! times the equal-amplitude sum over all M-element subsets, so

\[
\langle M|M\rangle=(M!)^2\binom NM.
\]

In the normalized state,

\[
\langle b_a^\dagger b_a\rangle=M/N,
\quad
\langle b_a^\dagger b_b\rangle=\frac{M(N-M)}{N(N-1)}\quad(a\ne b).
\tag{7.3}
\]

The off-diagonal count is binom(N-2,M-1)/binom(N,M). The pair-transfer matrix therefore has collective eigenvalue M(N-M+1)/N and N-1 orthogonal eigenvalues M(M-1)/[N(N-1)]. Its trace is M. At fixed interior filling the collective eigenvalue is extensive. The physical-mode isometry retains this macroscopic pair correlation; these are ground-state formulas, not an uncomputed thermal ensemble.

The same energy has

\[
E_{M+1}-2E_M+E_{M-1}=0.
\tag{7.4}
\]

At mu=-Up_0/2 the tower has equal grand energy across fillings. Thus the exact projected solution simultaneously exposes the absent density restoring curvature. Interband, Coulomb, or other changes must be evaluated as operators and in the same constrained free energy; one cannot add a scalar curvature and assume the eigenstates and currents unchanged.

The tower supplies known terms to a grand trace, not the whole trace. Other states and their thermal weights remain. The complete overlap-controlled collective spectrum and physical-density matrix elements are advanced in the new response chapter.

# 8. The original finite-gap many-pair residual

Use canonical physical a_i=c_i_up, b_j=c_j_down, and B_phi†=sum_ij phi_ij a_i†b_j†. The vacuum pair equation is

\[
h_\uparrow\phi+\phi h_\downarrow^{\mathsf T}
-U\operatorname{diag}\phi=E\phi.
\tag{8.1}
\]

Here diag retains diagonal entries as a matrix. The CAR give

\[
[n_{l\uparrow}n_{l\downarrow},a_i^\dagger b_j^\dagger]
=a_i^\dagger b_j^\dagger
(\delta_{li}n_{l\downarrow}+\delta_{lj}n_{l\uparrow}+\delta_{li}\delta_{lj}).
\]

The final delta supplies -U diag(phi), yielding

\[
[H_{on},B_\phi^\dagger]=EB_\phi^\dagger+R_\phi,
\quad
R_\phi=-U\sum_{ij}\phi_{ij}a_i^\dagger b_j^\dagger
(n_{i\downarrow}+n_{j\uparrow}).
\tag{8.2}
\]

At i=j the displayed occupation residual vanishes by c†n=0; its onsite constant is already in (8.1). The residual vanishes on the vacuum, not generally on occupied states.

Set X_i†=a_i† sum_j phi_ij b_j† and Y_i†=(sum_j phi_ji a_j†)b_i†. Commuting the occupations through B_phi† and relabeling gives

\[
C_\phi=[R_\phi,B_\phi^\dagger]=-2U\sum_iX_i^\dagger Y_i^\dagger.
\tag{8.3}
\]

Even pure-creation operators commute, so [C_phi,B_phi†]=0. Moving R to the right in the commutator of a power, where it kills the vacuum, counts binom(M,2) crossings. Hence

\[
\boxed{H_{on}(B_\phi^\dagger)^M|0\rangle
=ME(B_\phi^\dagger)^M|0\rangle
+\binom M2(B_\phi^\dagger)^{M-2}C_\phi|0\rangle.}
\tag{8.4}
\]

For M=0,1 omit the second term. For a nonzero pair-power state, additive energy ME holds iff the residual vector vanishes. At M=2 this is C_phi|0>=0. A pure-creation operator is determined by its action on the vacuum, so this closes the entire nonzero additive tower. Nonzero residual alone would not exclude an eigenstate at a different energy; the stronger argument follows.

At zero momentum the full reconstructed kernel is, up to an irrelevant common scale,

\[
\phi=P/x_0+(I-P)/(x_0+2\Delta_b)=\alpha I+\gamma P,
\]
\[
\alpha=(x_0+2\Delta_b)^{-1},\qquad
\gamma=x_0^{-1}-(x_0+2\Delta_b)^{-1}>0.
\tag{8.5}
\]

The diagonal is p_0/x_0+(1-p_0)/(x_0+2Delta_b)=1/U. Since h_down^T=h_up=Delta_b(I-P), substitution verifies (8.1).

For p_i†=a_i†b_i† and i!=j, the coefficient of p_i†p_j†|0> in C_phi|0> is

\[
4U\phi_{ij}\phi_{ji}=4U\gamma^2|P_{ij}|^2.
\tag{8.6}
\]

Only terms centered at i or j create precisely those four modes; both fermionic reorderings cancel the minus in (8.3). Idempotence gives

\[
\sum_{j\ne i}|P_{ij}|^2=p_0-p_0^2=7/64.
\tag{8.7}
\]

Thus C_phi is not zero. Moreover the coefficient of the same configuration in (B_phi†)²|0> is

\[
2(\phi_{ii}\phi_{jj}-\phi_{ij}\phi_{ji}).
\tag{8.8}
\]

For two different orbitals in the same cell, P_ij=0 because the zero-displacement Fourier coefficient is I_8/8. Equation (8.8) is then 2/U², while (8.6) is zero. Proportionality C_phi|0>=c(B_phi†)²|0> would force c=0. But (8.7) supplies another pair with nonzero (8.6), a contradiction. Therefore the exact vacuum pair squared is not an eigenstate of the original finite-gap Hamiltonian at any energy.

This closes that ansatz, not superconductivity or every density-dependent pair state. Its orthogonal residual becomes the next exact operator. Normalize chi_M proportional to (B_phi†)^M|0>, define Pi_M=|chi_M><chi_M|, Q_M=I-Pi_M,

\[
a_M=\langle\chi_M|H|\chi_M\rangle,\quad
r_M=Q_MH|\chi_M\rangle,\quad D_M=Q_MHQ_M|_{Q_M\mathcal H}.
\]

Equation (8.4) computes r_M. Block inversion gives

\[
\boxed{\langle\chi_M|(z-H)^{-1}|\chi_M\rangle
=[z-a_M-r_M^\dagger(z-D_M)^{-1}r_M]^{-1}.}
\tag{8.9}
\]

The cyclic sector generated by r_M,D_Mr_M,... is an exact continuation target. Naming D_M is not evaluating it. Its dark states and determinant still contribute to other questions, especially thermal traces.

# 9. The finite-gap parent and common-annihilator construction

Upper occupation commutes with the lower interaction in (1.3). Equation (7.1) therefore gives in the full physical Fock space

\[
\boxed{H_{parent}+\frac{Up_0}{2}\widehat N_{total}
=(\Delta_b+Up_0/2)\widehat N_{upper}+\frac U2\sum_iM_i^2.}
\tag{9.1}
\]

The lower eta states kill every term on the right and hence are exact ground states at each fixed 2M for positive finite U,Delta_b. The projected quartic interaction is finite-range because P has finite Fourier support, but it contains correlated hopping and is not onsite Hubbard attraction. Its difference from the original is exactly (1.4).

For a proposed perturbation V, a subspace Pi is preserved with one common scalar shift iff

\[
(1-\Pi)V\Pi=0,\qquad\Pi V\Pi=c\Pi.
\tag{9.2}
\]

For a one-dimensional line, preservation already makes its vector an eigenstate with its diagonal shift. To remain a ground state the complementary spectrum must also stay above it; (9.2) alone does not determine that spectrum.

The new chapter proves that the connected projector in this model has no additional common-annihilator ground states at fixed pair number and then computes a full density-response subspace. These statements belong to H_parent, not H_on.

# 10. Exact elimination carries a metric, sources, and determinants

Let a finite Hermitian block matrix be

\[
H=\begin{pmatrix}A&B\\B^\dagger&C\end{pmatrix}.
\]

Off spec(C), define Sigma(z)=B(z-C)^(-1)B† and H_eff(z)=A+Sigma(z). The exact block factorization is

\[
z-H=
\begin{pmatrix}I&-B(z-C)^{-1}\\0&I\end{pmatrix}
\begin{pmatrix}z-H_{eff}(z)&0\\0&z-C\end{pmatrix}
\begin{pmatrix}I&0\\-(z-C)^{-1}B^\dagger&I\end{pmatrix}.
\tag{10.1}
\]

It proves the projected resolvent and determinant identities. The eigenstate reconstruction at a real E outside spec(C) is

\[
\psi=\mathcal T(E)u=\binom{u}{(E-C)^{-1}B^\dagger u},\quad
H_{eff}(E)u=Eu.
\]

Because the derivative of (E-C)^(-1) is -(E-C)^(-2),

\[
\mathcal T^\dagger\mathcal T=I-\partial_EH_{eff}
=I+B(E-C)^{-2}B^\dagger.
\tag{10.2}
\]

For a simple differentiable eigenbranch under a specified physical source varphi, differentiation cancels the eigenvector terms and gives

\[
\boxed{\frac{dE}{d\varphi}
=\frac{u^\dagger\partial_\varphi H_{eff}(E,\varphi)u}
{u^\dagger(I-\partial_EH_{eff})u}.}
\tag{10.3}
\]

The numerator is a partial derivative at fixed E. Degenerate branches require the actual matrix problem within the degenerate subspace. The complete source dependence and normalization cannot be dropped while claiming the same current.

Successive Schur eliminations agree with simultaneous elimination on their shared invertibility domain because they solve the same block equations. Reconstructions compose and determinants multiply. The repository's Delta 19 gives the corresponding excursion picture: intermediate complementary-sector visits followed by returns produce the self-energy. Its series coefficients BD^mC retain all return kernels. Exact dynamic closure on a retained sector is equivalent to their vanishing in the stated linear setting, not merely to instantaneous agreement of the visible states.

# 11. Electromagnetic source transport and the magnetic projector defect

For a source-dependent unitary frame V(varphi), let H_tilde=VHV† and A_varphi=(partial_varphi V)V†. Then

\[
\partial_\varphi\widetilde H
=V(\partial_\varphi H)V^\dagger+[A_\varphi,\widetilde H].
\tag{11.1}
\]

The covariant derivative subtracts the representation commutator. A pure frame change leaves the Gibbs trace invariant and cannot by itself generate free-energy curvature.

For vertex-to-edge gradient D, suppose the complete physical source family obeys H[A+Dchi]=U_chi H[A]U_chi†. Then F[A+Dchi]=F[A], and its static response matrix K obeys

\[
D^{\mathsf T}\nabla_AF=0,\qquad D^{\mathsf T}K=0,\qquad KD=0.
\tag{11.2}
\]

On a connected finite graph, all cycle holonomies being trivial is necessary and sufficient for a link field to be removable by vertex phases. Necessity telescopes the endpoint phases. Sufficiency constructs vertex phases along a spanning tree and checks the remaining edges' cycles. Nontrivial torus holonomy or a transverse field is not a pure vertex-gauge perturbation.

For the free two-flat-level model, a uniform Peierls twist shifts momentum but not the eigenvalues. Its free partition function

\[
\Xi_0=[(1+z)(1+ze^{-\beta\Delta_b})^7]^{2N}
\tag{11.3}
\]

is twist independent. Nonzero band metric alone has not created free stiffness.

A natural finite-range magnetic dressing is P[A]_ij=P_ij U_ij[A], with U_ji=U_ij* along specified paths. It is gauge covariant. Nevertheless

\[
\boxed{(P[A]^2-P[A])_{ij}
=\sum_lP_{il}P_{lj}[U_{il}U_{lj}-U_{ij}].}
\tag{11.4}
\]

This follows by multiplying and subtracting P²=P. The bracket compares two paths with the same endpoints, hence a Wilson-loop phase. It vanishes for pure vertex-gauge dressing, not in general for flux.

A three-label control starts from P_ij=1/3 and dresses it to

\[
P[A]=\tfrac13\begin{pmatrix}1&1&z^{-1}\\1&1&1\\z&1&1\end{pmatrix},\quad|z|=1.
\]

The (1,2) defect is (z^(-1)-1)/9, nonzero at z=i. Thus covariance does not imply idempotence. The parent proof uses projector anticommutators; it cannot simply reuse them after this dressing. An actual magnetic spectral projector restores idempotence but its locality, diagonal weights, and interaction tensor then have to be recomputed.

There is also a spin-source issue. Both electron spins have the same electrical charge. Physical time reversal gives

\[
h_\downarrow[A]=h_\uparrow[-A]^*,
\tag{11.5}
\]

not generally h_down[A]=h_up[A]*. Imposing the latter at nonzero field can accidentally assign opposite charge couplings. These are exact unresolved source extensions, not a no-go for every possible construction.

# 12. Actual noise operators and protected sectors

A configuration centralizer cannot be silently promoted to every linear operator in a physical representation. On X=(Z/4)² let Q|i,j>=|i+1,j+1> and R|i,j>=|j+1,i>. The uniform vector u is fixed, so P_u=|u><u|/<u,u> commutes with R. Let v=sum_i|i,i>-sum_i|i,i+1>. Both u and v have Q eigenvalue one, but P_u keeps u and kills v. No polynomial in Q can do that, since it acts by the same scalar on a given Q-character space. This is a precise representation obstruction, not a refutation of the rope's theorem in its stated class.

Write H_SB=sum_alpha S_alpha tensor B_alpha in an independent basis of nontrivial bath operators, moving bath-identity terms into H_S. A finite-dimensional subspace Pi has factorized evolution for arbitrary bath states with no relative interaction inside it iff

\[
(1-\Pi)S_\alpha\Pi=0,\qquad
\Pi S_\alpha\Pi=s_\alpha\Pi
\tag{12.1}
\]

for each independent bath component, and H_S preserves Pi. Sufficiency restricts the generator to H_Pi tensor I+I tensor H_B'. Necessity differentiates the factorization at the identity; independence forces each remaining coefficient to be scalar and every leakage block to vanish.

If the actual bath algebra lies in C[Q] with Q^4=I, each character projector Pi_r=(1/4)sum_k i^(-rk)Q^k satisfies the scalar condition. Mere commutation with Q only gives block diagonality and can still resolve internal states. Charge-two b obeys QbQ†=-b, so Pi_r b Pi_r=0 while b_i†b_j is neutral. Fixed-sector anomalous expectation is not a replacement for number-conserving pair coherence.

The parent's paired states are common zeros of M_i, so sum_i M_i tensor X_i acts trivially on their span. The new ground-space chapter identifies that span completely when the projector overlap is connected. Thermal occupation and actual physical phonon couplings are separate questions sharing the same operators.

For density noise L_alpha=sum_i g_alpha_i n_i and onsite pair transfer T_ij=b_i†b_j,

\[
[L_\alpha,T_{ij}]=2(g_{\alpha i}-g_{\alpha j})T_{ij}.
\tag{12.2}
\]

A nonzero transfer preserves all these bath eigenvalues iff the coupling columns g_i and g_j agree. Uniform total-density coupling and independent local density coupling have the same global charge symmetry but distinguish different spatial information.

If the same harmonic mediator induces -(1/2)sum L_alpha K_med^(-1)_alpha_beta L_beta, that operator is scalar on any joint eigenspace where every L_alpha is scalar. It cannot select internal configurations inside that fixed subspace. A retarded version requires invariance throughout the relevant history. This is a compatibility condition between exact invisibility and mediated selection, not a general prohibition on superconductivity or different pairing operators.

# 13. Finite-temperature input and exact response

At finite volume let Q_m(beta)=Tr_(Nhat=m)exp(-beta H), with common spin fugacity z. Then

\[
\Xi(z)=\sum_{m=0}^{16N}z^m Q_m,
\quad\log\Xi=zQ_1+z^2(Q_2-Q_1^2/2)+\sum_{m\ge3}b_mz^m.
\tag{13.1}
\]

This is the local Taylor expansion at z=0, not a convergence assertion at arbitrary finite density. Interaction leaves Q_1 and same-spin two-electron sectors unchanged. Q_1=2N(1+7exp(-betaDelta_b)). Using all roots epsilon_s,r(K) of (5.10), the exact interaction change in b_2 is

\[
\boxed{\Delta b_2=\sum_K\left[\sum_{s,r}e^{-\beta\epsilon_{s,r}(K)}
-8(1+e^{-\beta\Delta_b}+e^{-2\beta\Delta_b})\right].}
\tag{13.2}
\]

The restored flat factors and positive roots are retained. At U=0 every cubic factors as E(E-Delta_b)(E-2Delta_b), and the difference vanishes. Higher Q_m remain actual many-body data, not zero by virtue of having solved a pair.

For a finite differentiable H(varphi), rho=exp(-betaH)/Z, J=partial_varphi H, Duhamel differentiation is

\[
\partial_\varphi e^{-\beta H}
=-\beta\int_0^1e^{-\beta(1-s)H}Je^{-\beta sH}\,ds.
\]

Cyclicity gives F'=<J>, and a second derivative gives

\[
\boxed{F''=\langle H''\rangle
-\beta\int_0^1\operatorname{Tr}(\rho^{1-s}\delta J\rho^s\delta J)\,ds.}
\tag{13.3}
\]

The commuting case is <H''>-beta Var(J). In an eigenbasis, the subtracted term is sum_nm w_nm |delta J_nm|² with

\[
w_{nm}=(p_n-p_m)/(E_m-E_n)\quad(E_n\ne E_m),
\qquad w_{nm}=\beta p_n\quad(E_n=E_m).
\tag{13.4}
\]

The diagonal and degenerate contributions do not vanish. A spectrum without physical current matrix elements does not determine this response. The finite-volume expression must be carried into the actual equilibrium static transverse, thermodynamic, and boundary limits to obtain the superconducting observable. The dynamic Drude limit is different.

For a specified system and bath with source-independent reference Z_B,

\[
e^{-\beta H^*(\beta,\varphi)}
=\operatorname{Tr}_B e^{-\beta H_{tot}(\varphi)}/Z_B.
\tag{13.5}
\]

The finite-dimensional partial trace is strictly positive, so its logarithm exists. The mean-force Hamiltonian exactly gives rho_S=exp(-betaH*)/Z*, Z_tot=Z_B Z*, and F_tot=F_B+F*. Source derivatives of F* agree with those of F_tot when F_B is source independent. Its beta dependence also remains:

\[
-\partial_\beta\log Z_*
=\langle H^*+\beta\partial_\beta H^*\rangle.
\tag{13.6}
\]

The thermodynamic energy need not be <H*> alone. Mean force reconstructs the equilibrium marginal, not every joint correlation or future open-system process. Those require the retained total state or influence functional.

# 14. Mediators, fluctuations, and thermodynamic residuals

For a positive invertible harmonic kernel under specified thermal boundary conditions,

\[
S[n,X]=S_e[n]+\tfrac12\langle X,K_{med}X\rangle+\langle gn,X\rangle.
\]

Complete the square around X_mean=-K_med^(-1)gn. Integration gives

\[
S_{eff}[n]=S_e[n]-\tfrac12\langle gn,K_{med}^{-1}gn\rangle,
\tag{14.1}
\]

with the Gaussian determinant and conditional covariance K_med^(-1). A source-dependent determinant cannot be dropped as a constant.

For a mass-normalized oscillator K_med(i nu)=nu²+Omega², the induced interaction is -g²/(nu²+Omega²). Matching only its static value to -U, U=g²/Omega², leaves

\[
V(i\nu)+U=U\nu^2/(\nu^2+\Omega^2).
\tag{14.2}
\]

Thus the instantaneous U is a model specialization, not the general exact result of phonon elimination. The physical orbital form factors, Coulomb terms, and competing channels also have to remain.

For a non-Gaussian bath use its full source functional W[j]=log<exp(-<j,X>)>_B. Where a cumulant expansion is legitimate,

\[
W[j]=\sum_{m\ge1}\frac{(-1)^m}{m!}
\int j(1)\cdots j(m)\langle X(1)\cdots X(m)\rangle_c.
\tag{14.3}
\]

The functional remains the object when the series cannot be used. Vanishing connected cumulants above second order is the Gaussian condition. Quantum histories retain the appropriate imaginary-time ordering.

For a Hermitian B coupled as -fB, use chi^R(t)=(i/hbar)theta(t)<[B(t),B(0)]> and S_sym(omega)=(1/2)integral exp(iomega t)<{deltaB(t),deltaB(0)}>. At nonzero frequency,

\[
S_{sym}(\omega)=\hbar\coth(\beta\hbar\omega/2)\operatorname{Im}\chi^R(\omega).
\tag{14.4}
\]

The proof pairs upward/downward transitions with Gibbs ratio exp(-beta hbar omega). Exactly conserved or degenerate components can additionally carry

\[
2\pi\sum_{E_n=E_m}p_n|\delta B_{nm}|^2\delta(\omega).
\tag{14.5}
\]

Their commutator has no weight because the Gibbs probabilities agree. This elastic term must be retained separately or by a distributional limiting prescription. If [H,B]=0, the retarded commutator can vanish while Var(B)>0 and static curvature contains -beta Var(B). Equating a zero commutator with absent thermal fluctuations would erase this information.

Logical reversibility is also not the same as zero physical heat. If the initial bath marginal is Gibbs with energy H_B and the joint state evolves unitarily, relative entropy gives betaQ=Delta S_B+D(rho'_B||rho_B). Joint entropy conservation gives Delta S_B=S(rho_S)-S(rho'_S)+I(S':B')-I(S:B). Hence

\[
\boxed{\beta Q=S(\rho_S)-S(\rho'_S)+I(S':B')-I(S:B)
+D(\rho'_B\Vert\rho_B).}
\tag{14.6}
\]

The repository's injective displacement theorem is consistent with this: distinctions disappearing from one marginal must remain jointly. It does not set the bath energy change to zero. A groupoid identity is not a replacement for the Gibbs reference, energy observable, and correlation terms in (14.6). Superconductivity concerns charged response, not zero entropy in every part of a warm material.

# 15. Ionic relaxation and the shared response Hessian

For externally specified static internal coordinates xi,

\[
F(\varphi,\xi)=E_{ion}(\xi)-\beta^{-1}\log\operatorname{Tr}e^{-\beta H_e(\varphi,\xi)}.
\tag{15.1}
\]

Duhamel differentiation gives, for real coordinates y_a,y_b,

\[
F_{ab}=(E_{ion})_{ab}+\langle H_{ab}\rangle-\chi_{ab},
\quad\chi_{ab}=\beta\int_0^1\operatorname{Tr}(\rho^{1-s}\delta H_a\rho^s\delta H_b)ds.
\tag{15.2}
\]

For linear electron-ion coupling H_e=H_e(0)+sum xi_a V_a, the ionic block is K_ion-chi_VV. The same coupling enters attraction, fluctuations, and structural softening; they are not independently assignable constants.

On a stationary branch F_xi=0, if K=F_xixi is invertible after the constraints and gauge zero modes are removed,

\[
\xi'=-K^{-1}F_{\xi\varphi},\qquad
F_{relaxed,\varphi\varphi}
=F_{\varphi\varphi}-F_{\varphi\xi}K^{-1}F_{\xi\varphi}.
\tag{15.3}
\]

This follows by differentiating stationarity, not by neglecting xi. Its exact quadratic identity is

\[
(a,x)^T\begin{pmatrix}A&B\\B^T&K\end{pmatrix}(a,x)
=a^T(A-BK^{-1}B^T)a+(x+K^{-1}B^Ta)^TK(x+K^{-1}B^Ta).
\tag{15.4}
\]

For positive definite K, full positive semidefiniteness is equivalent to the Schur-complement condition. If an internal mode reaches zero, this inverse chart fails; that mode must remain or a constrained inverse with its compatibility conditions must be supplied. A local Hessian of one branch is not a comparison with every competing crystal or charge order.

# 16. Exact electron–nuclear factorization

For a normalized differentiable pure joint wavefunction, on a patch where the nuclear marginal is nonzero,

\[
\Psi(r,R)=\chi(R)\Phi_R(r),\quad
\langle\Phi_R|\Phi_R\rangle_r=1,\quad
|\chi(R)|^2=\int dr\,|\Psi(r,R)|^2.
\tag{16.1}
\]

The phase freedom is Phi_R -> exp(i theta(R))Phi_R and chi -> exp(-i theta(R))chi. This is exact factorization, not a Born–Oppenheimer assumption.

Define

\[
A_\nu=\langle\Phi_R|-i\hbar\partial_\nu\Phi_R\rangle,
\quad
 g_{\nu\nu}=\langle\partial_\nu\Phi_R|
(1-|\Phi_R\rangle\langle\Phi_R|)|\partial_\nu\Phi_R\rangle.
\]

Normalization makes <Phi|partialPhi> imaginary. Expanding partial(chiPhi), completing the square in the cross term, and imposing the actual kinetic boundary conditions gives

\[
\boxed{\langle T_{nuc}\rangle=\sum_\nu\int dR
\left[\frac{|(-i\hbar\partial_\nu+A_\nu)\chi|^2}{2M_\nu}
+\frac{\hbar^2|\chi|^2g_{\nu\nu}}{2M_\nu}\right].}
\tag{16.2}
\]

A transforms by A_nu -> A_nu+hbar partial_nu theta; the first square is covariant and the perpendicular metric term invariant. The projective metric has the same mathematical construction as the band metric but a different base, nuclear configuration space, and different physical weights. That exact structural correspondence does not identify their numerical values.

Nodes of chi require patches or measure-theoretic treatment. A thermal mixed state requires density-operator data or an explicitly retained purification; it cannot be silently replaced by one pure state. No conditional electronic state for a candidate compound has yet been computed in this investigation.

# 17. Defects, scale, and the common source functional

For a system genuinely in the two-dimensional BKT regime with F=(Upsilon/2)integral|gradtheta|², the renormalized stiffness obeys k_B T_BKT=(pi/2)Upsilon(T_BKT^-). This is not a three-dimensional transition formula. In a charged film the relevant electromagnetic lengths also matter. At 300 K its conditional right stiffness would be about 16.46 meV; this conversion is not a prediction from the constructed pair mass.

For H_lambda(varphi)=lambda H(varphi), lambda>0,

\[
\rho_T(H_\lambda)=\rho_{T/\lambda}(H),\qquad
F_{H_\lambda}(T,\varphi)=\lambda F_H(T/\lambda,\varphi).
\tag{17.1}
\]

Transition temperatures, where they exist with matched thermodynamic controls, scale by lambda. Chemical potential must be scaled too when it is a fixed energy parameter. Projectors and phase relations can remain unchanged. k_B approximately 8.617333262e-5 eV/K gives k_B(300 K) approximately 25.852 meV. The dimensionless mobility optimum does not select a band gap in electronvolts or calibrate a cell length and interaction time.

A common finite-volume source-dependent object is

\[
\mathcal Z[A,\eta,\xi]=\operatorname{Tr}\mathcal T_\tau
\exp\left[-\int_0^\beta d\tau\,
(H[A(\tau),\xi(\tau)]-\mu\widehat N
-\eta(\tau)B^\dagger-\bar\eta(\tau)B)\right].
\tag{17.2}
\]

The model, source domains, ordering, boundaries, and physical operator conventions are part of this definition. Exact preservation under an explicit source map preserves its derivatives. Preserving selected eigenvalues alone need not do so. Dynamic questions use a stated real-time continuation or process, not an unspecified analytic shortcut.

A microscopic realization map must connect composition, orbital geometry, pressure, charge density, electron–nuclear interactions, and physical source couplings to this object. Its fibre can contain several possible compounds or no current constructed example. Necessary-and-sufficient characterizations are not themselves a proof that a particular realization exists or is unique. The mathematical task remains to construct that realization with its energy and stability data.

# 18. Current continuations, kept attached to their equations

**Original finite-gap many body.** Continue from phi=alpha I+gamma P, C_phi, and the return triple (a_M,r_M,D_M), not from an ideal-boson replacement. The squared lowest pair is excluded at every energy; correlated states, density-dependent kernels, and invariant sectors generated by the residual remain. Any newly closed sector must retain the physical source derivatives and thermal contribution of the complement.

**General pair class.** Use D,G and [D,G] from `FINITE_GAP_PAIR_REDUCTION.md`. Fixed scalar channels exist exactly when the commutator vanishes. Otherwise retain the cubic matrix pencil, including energy-dependent eigenvectors. Geometry changes must recompute G and its curvature; a numerical optimum from p=1/8 is not an independent universal constant.

**Parent and exact ground space.** Use (9.1), the complete projected quartic tensor, and V_res. The previously unresolved common kernel is now closed for connected frames in the new chapter. The same chapter derives the collective and physical-density response, including upper particles. Neither deletes V_res when comparing to the original onsite model.

**Finite temperature.** The full pair trace supplies (13.2). Positive-temperature response still requires the other particle sectors, their eigenvectors under the physical source, and the stated bulk limits. Exact zero-temperature response data and known collective modes are inputs to that problem, not a replacement for its Gibbs sum.

**Electromagnetism.** Start with the actual H[A], including the interaction tensor. Preserve (11.2), the Schur metric, and same-charge spin convention (11.5). Resolve or replace the specific dressing defect (11.4) before reusing a zero-field projector proof. Density and transverse current are related by the specified dynamics and continuity equation, not by their names.

**Mediation, bath, and structure.** The same physical coupling operators enter the complete frequency kernel, its fluctuations, density distinguishability, and ionic Hessian. For non-Gaussian mediators retain (14.3). Protected annihilator couplings and ordinary density couplings are different operator families; the new density-response result provides an exact comparison in the parent.

**Defects and boundaries.** Retain amplitude zeros, vortex cores, and boundary crossings in the source-dependent action. Net topological charge does not determine their energies or thermal weights. The bulk dimension is three unless a new film model and its electromagnetic geometry are specified.

**Electron–nuclear realization.** The conditional state, Berry connection, nuclear marginal, and perpendicular derivative term in (16.2) are the concrete data to compute. Mixed thermal states require their own retained state representation. Source-dependent reductions must preserve these data when they determine stability or pairing.

**Proof re-entry.** The current notebook and exact scripts are research outputs. They have not been compiled as an autonomous native materials-discovery program. A formal port should encode the actual types, inverse domains, model distinctions, and source maps, not assume an unevaluated return block equals zero. The resulting typed transformations should re-enter the ongoing calculation at every justified instance.

# 19. Corrections and provenance that must survive a restart

The quarter-turn's connected algebraic role was initially understated as a mere example; the opposite error would be to identify its configuration centralizer with every physical linear operator. Both distinctions are retained. Finite phase period does not limit the content of a dependent fibre. Integer winding, spatial-prefix completion, and homotopy truncation remain different constructions.

The pair problem is solved at finite gap; the projected and engineered-parent eta states belong to different Hamiltonians. Nonzero C_phi first excluded additive energy, while the coefficient comparison in (8.8) supplied the stronger no-eigenstate result. The old compact fluctuation–dissipation statement omitted the zero-frequency elastic sector, now explicit in (14.5). The magnetic source extension had implicitly reused projector idempotence; equation (11.4) is its missing residual. Reversible logical history was at times overstated as zero heat; equation (14.6) carries the actual statistical content.

A pair mobility optimum is not a T_c optimum, and a protected prepared subspace is not a thermal equilibrium population. These distinctions keep the physical objects usable, rather than evaluating the value of a derivation only by its eventual materials endpoint.

Repository source landmarks at the initial anchor:

- `fibre/src/Fibre/Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase.agda`: Conservative, run, fibre-of-run, trace-is-forced, fiberize, canonical-run, canonical-recovers.
- `fibre/src/Fibre/Visvarupa_EveryFamilyIsAPullbackOfTheUniverseAndTheTowerFlattensToOne.agda`: Universal, pi, canonical pullback, classifier, flattening.
- `fibre/src/Fibre/CorpusSamvada.agda`, `Fibre/Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers.agda`, `Fibre/Nucleus.agda`, and `formal/cubical/theorems/residue/CorpusLosslessPresentation.agda`, `CorpusSelfPresentation.agda`: dependent productive process, actual residual, whole-orbit transport.
- `formal/cubical/theorems/physics/CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare.agda` and `formal/cubical/theorems/historical_proofs/PythagoreanTransition.agda`: signed phase, non-descent, rotation equivalences.
- Physics modules `VeniBandha`, `VeniPatha`, `NirupaSutra`, `CatuhSesaSiddhanta`, `KendraPurnaNirvahana`, `KendraNirvahana`, `CaturekaSutra`, `SthairyaSutra`, and `PurnataSutra` by their full descriptive repository filenames: braid action, normal form, mod-four reading, causal centralizer and coinductive completeness. The actual prefix theorem, not an unqualified Lipschitz phrase, fixes the metric convention: depth n+1 agreement implies output depth n agreement. In d=2^(-first difference) it permits a factor-two expansion.
- `formal/cubical/theorems/physics/Pula_ThePrincipalBundleIsAFamilyOfTorsorsSoItsHolonomyIsTheGroupAndTheFibrePointConjugatesIt.agda`, `RelationalHolonomyRefinement.agda`, and `Pradakshina_TheCircuitReturnsToTheBasePointWithTheFibreShiftedSoTheHolonomyIsInhabited.agda`: torsor transport, refinement, and winding.
- `formal/cubical/KirchhoffIncidence_GraphLaplacianIsDivGradAndSummationByPartsIsExact.agda`: grad, div, by-parts and laplacian-is-gram.
- `research/handoff_20260908/sources/S25_delta19.md`, Sections 19.1-19.7: sector paths, return kernels, projected resolvent and full-future observability.
- `formal/cubical/theorems/physics/ApasaranaNiyama_ReversibilityConservesDistinctionsSoErasureIsDisplacementIntoTheEnvironmentNeverDestruction.agda`: injective joint displacement. The stronger thermodynamic prose in `theorems/cost/Yantra_TheComputerIsTheGroupoidOfProofsOfTransportNotTheMonoidOfIrreversibleSteps.agda` is not substituted for (14.6).

The source toolchain was Agda 2.8.0 with agda/cubical v0.9; older modules mention other checks. This import does not report a new aggregate build or whole-repository verification.

# 20. Primary references and reproducibility

The main equations above are derived from their displayed definitions. References establish attribution and exact comparison targets; an existing ingredient does not decide the originality of every composition, and a derivation made here does not by itself establish worldwide priority.

1. M. Tovmasyan, S. Peotta, P. Törmä, S. D. Huber, *Effective theory and emergent SU(2) symmetry in the flat bands of attractive Hubbard models*, arXiv:1608.00976; Phys. Rev. B 94, 245149 (2016). Uniform-pairing ground states, pseudospin and density degeneracy.
2. K.-E. Huhtinen et al., *Revisiting flat band superconductivity: dependence on minimal quantum metric and band touchings*, arXiv:2203.11133; Phys. Rev. B 106, 014518 (2022). Complete response, internal relaxation and geometric hypotheses.
3. D. J. Scalapino, S. R. White, S. Zhang, *Insulator, metal, or superconductor: The criteria*, Phys. Rev. B 47, 7995 (1993), DOI 10.1103/PhysRevB.47.7995. Current-response limits.
4. G. Dusson, I. M. Sigal, B. Stamm, *The Feshbach–Schur map and perturbation theory*, arXiv:2105.02058. Spectral reduction; no perturbative estimate is imported here.
5. Z. Han, J. Herzog-Arbeitman, B. A. Bernevig, S. A. Kivelson, *Quantum Geometric Nesting and Solvable Model Flat-Band Systems*, arXiv:2401.04163v3; Phys. Rev. X 14, 041004 (2024). Constructive solvable parents and selected excitations.
6. D. A. Lidar, I. L. Chuang, K. B. Whaley, *Decoherence Free Subspaces for Quantum Computation*, arXiv:quant-ph/9807004; Phys. Rev. Lett. 81, 2594 (1998). Scalar action and common annihilators.
7. G. Timofeev, A. Trushechkin, *Hamiltonian of mean force in the weak-coupling and high-temperature approximations and refined quantum master equations*, arXiv:2204.00599. Used for the mean-force definition, not its approximation schemes.
8. H. B. Callen, T. A. Welton, *Irreversibility and Generalized Noise*, Phys. Rev. 83, 34 (1951). Fluctuation–dissipation background with conventions and zero-frequency terms explicit above.
9. D. Reeb, M. M. Wolf, *An improved Landauer Principle with finite-size corrections*, arXiv:1306.4352; New J. Phys. 16, 103011 (2014). Bath entropy and relative entropy; the initially correlated extension is derived above.
10. A. Abedi, N. T. Maitra, E. K. U. Gross, *Exact factorization of the time-dependent electron-nuclear wavefunction*, arXiv:1006.2638; Phys. Rev. Lett. 105, 123002 (2010), with extended derivation arXiv:1208.4388.
11. R. Requist, C. R. Proetto, E. K. U. Gross, *Exact factorization-based density functional theory of electron-phonon systems*, arXiv:1901.07523; Phys. Rev. B 99, 165136 (2019).
12. R. P. Feynman, R. B. Leighton, M. Sands, *The Feynman Lectures on Physics*, III.21, official Caltech edition. Standard phase-current and flux interpretation.
13. D. R. Nelson, J. M. Kosterlitz, *Universal Jump in the Superfluid Density of Two-Dimensional Superfluids*, Phys. Rev. Lett. 39, 1201 (1977). Conditional two-dimensional relation, not a 3D transition formula.
14. NIST CODATA Boltzmann constant in eV/K. Unit calibration only.
15. M. A. Keskiner, M. Iskin, *Superconductivity beyond band geometry: emergence of pair quantum geometry*, arXiv:2606.06017v2 (August 11, 2026). Pairing-mode texture comparison; zero contact texture does not erase reconstructed pair geometry.
16. M. Iskin, *Two-body problem in a multiband lattice and the role of quantum geometry*, arXiv:2102.03530; Phys. Rev. A 103, 053311 (2021); and *Effective-mass tensor of the two-body bound states and the quantum-metric tensor of the underlying Bloch states*, arXiv:2109.06000. General multiband pair equations and known strong-attraction mass turnover.
17. S. Moudgalya, N. Regnault, B. A. Bernevig, *Eta-pairing in Hubbard models: From Spectrum Generating Algebras to Quantum Many-Body Scars*, arXiv:2004.13727. Nested-commutator tower context.
18. S. S. Elden, M. Iskin, *Correlation lengths of flat-band superconductivity from quantum geometry*, arXiv:2601.12969; Phys. Rev. B 113, 214501 (2026). The Creutz-block comparison in (4.8).

The conversation packages contained exact SymPy controls: 51 assertions for the original projector/pair/Schur/CAR calculations, 88 for the many-pair and parent continuation, 16 for the stronger two-pair obstruction, magnetic defect and static conserved-source checks, and 22 for the general projector-family reduction. Those are historical execution records, not counts of formally verified general theorems or new executions in this import. The general proofs are retained in the text. The new repository script and fresh output specifically concern the ground-space/density-response continuation.

To resume, use the actual object belonging to the desired branch: (phi,C_phi,a_M,r_M,D_M) for the original correlated many-body problem; (W,A_i,S,mathcal L,mathcal I_M) for the solved parent's response; (P[A],P[A]²-P[A],H_parent[A]) for its transverse source extension; (Q_m,Z,J,H'',chi) for the thermal problem; and the full mediator or electron–nuclear Hamiltonian for realization. Keep newly obtained maps, their inverse domains, state norms, and source compatibility alongside their answers. The outcome of continuing these constructions remains a research question, with superconductivity central throughout.
