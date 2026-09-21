# Exact finite-gap pair reduction for projector families

## Research notes in progress — September 16, 2026

This chapter preserves the class-wide continuation of the original tensor-product calculation. Its starting point is not a fit to a successful example: the earlier proof used two flat energy levels, time reversal, and contact interaction. The three-dimensional eight-orbital geometry only supplied one explicit diagonalization of the resulting overlap matrix. Removing unused restrictions exposes the general transformation and its exact obstruction.

The physical model remains distinct from the engineered parent in `GROUND_SPACE_AND_DENSITY_RESPONSE.md`. Here the attraction is genuinely onsite in the full finite-gap physical Hilbert space. No isolated-band, weak-coupling, or mean-field approximation is made.

# 1. The model and the retained contact coordinate

At finite periodic volume let there be N cells, m orbitals per cell, and one particle of each spin. K is an allowed total momentum, so k -> k-K permutes the mesh. The fixed-K Hilbert space has dimension Nm². A Hermitian projector P(k) has constant rank r, 0<r<m. Set

\[
h_\uparrow(k)=\Delta[I_m-P(k)],\qquad
h_\downarrow(k)=h_\uparrow^*(-k),\quad\Delta>0,
\tag{F.1}
\]
\[
V=-U\sum_{R,\alpha}n_{R\alpha\uparrow}n_{R\alpha\downarrow},\quad U>0.
\tag{F.2}
\]

There are two flat one-particle energies, zero and Delta, with internal degeneracy permitted. A Laurent-polynomial projector gives finite-range hopping; an arbitrary projector need not. The normalized Brillouin integral version uses the same formulas where applicable.

The m contact states are

\[
|\alpha;K\rangle=N^{-1/2}\sum_k|k,\alpha,\uparrow;K-k,\alpha,\downarrow\rangle.
\]

Their isometry C_K satisfies C_K†C_K=I_m, and V=-UC_KC_K† exactly in this sector.

Define

\[
D_{\alpha\beta}=\delta_{\alpha\beta}d_\alpha,\qquad
 d_\alpha=N^{-1}\sum_kP_{\alpha\alpha}(k),
\tag{F.3}
\]
\[
G_{\alpha\beta}(K)=N^{-1}\sum_k
P_{\alpha\beta}(k)P_{\alpha\beta}^*(k-K).
\tag{F.4}
\]

D is diagonal, 0<=D<=I, tr D=r. G=C_K†P_LL C_K is positive Hermitian. The complex conjugation in (F.4) follows from time reversal and cannot be omitted for a general complex band frame.

# 2. Free-sector residues close before a particular lattice is chosen

Let L_1 and L_2 be the lower projectors of the two particles. They commute. The three free spectral projectors are L_1L_2, L_1(1-L_2)+(1-L_1)L_2, and (1-L_1)(1-L_2), at energies 0,Delta,2Delta.

The contact compression of L_1 is D: the other particle's identity enforces alpha=beta. The compression of L_2 is the same D because the momentum translation preserves the sum. Therefore

\[
C_K^\dagger P_{LL}C_K=G,
\quad C_K^\dagger(P_{LU}+P_{UL})C_K=2D-2G,
\quad C_K^\dagger P_{UU}C_K=I-2D+G.
\tag{F.5}
\]

Each residue is positive semidefinite and their sum is I. For x>0 the entire compressed resolvent is

\[
\mathscr K_x(K)=G/x+(2D-2G)/(x+\Delta)+(I-2D+G)/(x+2\Delta).
\tag{F.6}
\]

The bound-state equation and reconstruction are

\[
[U^{-1}I-\mathscr K_x(K)]v=0,
\qquad\psi=(H_0+x)^{-1}C_Kv.
\tag{F.7}
\]

Given a negative-energy eigenstate, v=UC_K†psi is nonzero, since H_0 is nonnegative. Conversely every nonzero solution v reconstructs a nonzero eigenstate. The norm of the reconstructed vector is

\[
\|\psi\|^2=v^\dagger\left[G/x^2+(2D-2G)/(x+\Delta)^2
+(I-2D+G)/(x+2\Delta)^2\right]v.
\tag{F.8}
\]

This is the inverse correspondence on the bound-state solution space. It does not identify the ambient Hilbert spaces or declare the Euclidean contact norm to be the physical state norm.

# 3. Necessary and sufficient fixed-channel criterion

Put a(x)=2Delta²/[x(x+Delta)(x+2Delta)]. An exact rearrangement gives

\[
\mathscr K_x=\frac I{x+2\Delta}+a(x)\left(G+\frac x\Delta D\right).
\tag{F.9}
\]

By bilinearity and antisymmetry of the commutator,

\[
\boxed{[\mathscr K_x,\mathscr K_y]
=a(x)a(y)\frac{y-x}{\Delta}[G,D].}
\tag{F.10}
\]

Finite-dimensional Hermitian matrices have a common orthonormal eigenbasis iff they commute. Since a(x)>0 and two positive distinct energies can be chosen,

\[
\boxed{\text{one basis diagonalizes every }\mathscr K_x(K),\ x>0
\iff [D,G(K)]=0.}
\tag{F.11}
\]

This basis can depend on K. The theorem concerns energy-independent contact channels at fixed momentum, not momentum-independent eigenvectors.

Uniform weights D=pI suffice, but are not necessary. Explicitly [D,G]_alpha_beta=(d_alpha-d_beta)G_alpha_beta, so G can mix only equal-weight orbital eigenspaces when the criterion holds. A diagonal G commutes with a nonuniform D as well.

When the commutator does not vanish, the exact residual is the matrix pencil G+(x/Delta)D, including its energy-dependent eigenvectors. Clearing scalar denominators gives

\[
\det\left[x(x+\Delta)(x+2\Delta)I
-U\{x^2I+\Delta x(I+2D)+2\Delta^2G\}\right]=0.
\tag{F.12}
\]

This is an m-dimensional cubic matrix polynomial. Its determinant has degree at most 3m, independent of volume. It is not automatically a product of scalar cubics. Reconstruction, norm, and physical-source derivatives in (F.7)-(F.8) remain attached in either case.

# 4. Scalar channels and complete characteristic polynomial

When [D,G]=0, choose a common eigenvector Dv=dv and Gv=lambda v. The three nonnegative residue weights give max(0,2d-1)<=lambda<=d. Its exact scalar equation is

\[
1/U=\lambda/x+(2d-2\lambda)/(x+\Delta)
+(1-2d+\lambda)/(x+2\Delta),
\]
\[
\boxed{x^3+(3\Delta-U)x^2+
[2\Delta^2-(1+2d)U\Delta]x-2U\lambda\Delta^2=0.}
\tag{F.13}
\]

For lambda>0 the rational function strictly decreases from infinity to zero on x>0, giving one bound state for every U>0. Lambda=0 requires d<=1/2; its exact threshold is U>2Delta/(1+2d). Equality is the threshold, not a negative-energy state.

The free multiplicities are Nr², 2Nr(m-r), N(m-r)². Define

\[
q_{d,\lambda}(E)=E^3+(U-3\Delta)E^2+
[2\Delta^2-(1+2d)U\Delta]E+2U\lambda\Delta^2.
\]

The determinant lemma gives

\[
\det(E-H_K)=E^{Nr^2-m}(E-\Delta)^{2Nr(m-r)-m}
(E-2\Delta)^{N(m-r)^2-m}\prod_{a=1}^m q_{d_a,\lambda_a}(E).
\tag{F.14}
\]

For N>=m these exponents are nonnegative and the equality is polynomial. At smaller sizes read it first as a rational factorization and cancel pole factors before interpreting multiplicities. The block identity remains exact. Vanishing residues can restore a free factor in q. Reconstruction at the free poles uses non-inverted block equations; the x>0 formula (F.7) is not asserted where its inverse fails.

Computing G for a geometry is still a real input calculation. This theorem makes the spectral dependence finite and explicit; it does not claim every arbitrary overlap matrix has a preferred elementary diagonalization.

# 5. Uniform orbital weights give an origin theorem across the class

Suppose d_alpha=p for all orbitals. Here p=r/m is a lower-projector weight, not the many-body filling. At K=0,

\[
G_{\alpha\beta}(0)=N^{-1}\sum_k|P_{\alpha\beta}(k)|^2.
\]

Its row sums are p because P²=P. Therefore the uniform vector is an eigenvector with eigenvalue p. The residue 2pI-2G>=0 shows every other eigenvalue is at most p. Simplicity is not assumed and is not needed for this origin binding equation.

In that channel the mixed-band residue vanishes:

\[
1/U=p/x_0+(1-p)/(x_0+2\Delta),
\]
\[
\boxed{x_0^2+(2\Delta-U)x_0-2pU\Delta=0,}
\]
\[
\boxed{x_0=\frac{U-2\Delta+\sqrt{(2\Delta-U)^2+8pU\Delta}}2.}
\tag{F.15}
\]

The exact upper/upper fraction is

\[
p_{UU}=\frac{(1-p)x_0^2}{p(x_0+2\Delta)^2+(1-p)x_0^2}.
\tag{F.16}
\]

The old eight-orbital calculation is p=1/8. Neither cubic-lattice geometry nor rank one is required for (F.15).

# 6. A universal spectral mobility multiplier

Let lambda(K) be a twice differentiable contact eigenvalue branch with lambda(0)=p. Since lambda(K)<=p, its first derivative vanishes at an interior origin. An isolated maximum eigenvalue is one sufficient way to obtain a smooth branch; degeneracies require the actual degenerate matrix problem.

Define

\[
A(x)=1/x-2/(x+\Delta)+1/(x+2\Delta),
\quad B_p(x)=p/x^2+(1-p)/(x+2\Delta)^2,
\quad W_p=A(x_0)/B_p(x_0).
\]

Implicit differentiation of the scalar secular equation gives

\[
\boxed{\partial_i\partial_jE_{pair}(0)
=-W_p\partial_i\partial_j\lambda(0).}
\tag{F.17}
\]

The geometric tensor is specific to P; at fixed projector it is independent of U. The spectral factor depends only on p,U,Delta. With t=x_0/Delta,

\[
U/\Delta=u_p(t)=\frac{t(t+2)}{t+2p},
\quad W_p/\Delta=w_p(t)=\frac{2t(t+2)}{(t+1)(t^2+4pt+4p)}.
\tag{F.18}
\]

Direct differentiation gives

\[
u_p'(t)=\frac{t^2+4pt+4p}{(t+2p)^2}>0,
\]
\[
w_p'(t)=-\frac{2[t^4+4t^3+2t^2-8pt-8p]}
{(t+1)^2(t^2+4pt+4p)^2}.
\tag{F.19}
\]

For every 0<p<1 the numerator polynomial has one positive root: its coefficients have one sign change, its value at zero is negative, and its positive-infinity limit is positive. Thus w_p increases and then decreases once. Monotonic u_p transfers the unique maximum to U:

\[
\boxed{t_*^4+4t_*^3+2t_*^2-8pt_*-8p=0,\qquad t_*>0.}
\tag{F.20}
\]

For any fixed geometric direction with nonzero curvature, this optimizes that pair inverse-mass component. If the geometric tensor vanishes, mobility remains zero and optimizing a multiplying coefficient does not create it. This is not a many-body critical-temperature optimization.

The exact limiting identities are W_p/U->1 at small U/Delta and W_p U/Delta²->2 at large U/Delta throughout the class. These follow from the rational functions, not a numerical sweep. At p=1/8, (F.20) recovers the original quartic and its ratio U_star/Delta approximately 1.80649344026221.

# 7. The same input feeds the many-body parent and the original-model obstruction

Uniform diagonal of the full real-space projector gives

\[
H_{projected}+\frac{Up}{2}\widehat N=\frac U2\sum_iM_i^2.
\tag{F.21}
\]

The projected paired states and engineered finite-gap parent therefore extend with p replacing 1/8. The algebra needs the isometry and time-reversed paired frames; a compact frame additionally helps establish locality. The full common kernel, excitation embedding, and physical-density response are now derived for this general projector package in the new response chapter.

For the original onsite model the reconstructed origin pair remains phi=alpha I+gamma P with gamma>0. Its four-creation residual has two-onsite-pair coefficient 4U gamma² |P_ij|². Uniform idempotence gives

\[
\sum_{j\ne i}|P_{ij}|^2=p(1-p)>0.
\tag{F.22}
\]

Thus the additive-pair residual is nonzero for every projector in this class. Failure at every eigenenergy requires more than nonzero residual. A sufficient condition is that two off-diagonal squared magnitudes s=|P_ij|² take different values. The ratio of the residual coefficient to the corresponding pair-square coefficient is

\[
\frac{2U\gamma^2s}{U^{-2}-\gamma^2s}.
\tag{F.23}
\]

Phi=alpha I+gamma P is positive definite, so the denominator is a positive two-by-two principal minor. The ratio is strictly increasing in s. Different s therefore prevent residual proportionality and exclude the pair square as an eigenstate at any energy. The original projector has zero same-cell off-diagonal entries and nonzero intercell ones, satisfying this criterion. No stronger assertion for all equal-off-diagonal frames is silently inferred.

# 8. Exact resumption and provenance

The class input is (P,Delta,U,C_K,D,G), with the physical source and boundary conventions retained. The output is the exact matrix pencil, solution reconstruction, norm, and fixed-channel iff. In a uniform frame it also supplies the universal origin root and spectral mobility multiplier. The common input couples pair spectra, projected ground states, parent engineering, and the original-model residual.

The original derivation was developed from the conversation notebook's explicit eight-orbital calculation by inspecting which hypotheses its proof used. It was not extrapolated from finite examples. The earlier `verify_generalization.py` executed 22 symbolic controls of the residue algebra, cubic coefficients, reconstruction weights, commutator, mobility derivatives, p=1/8 recovery, limiting identities and ratio monotonicity. That is a historical test report; the general proofs are written above and no fresh proof-assistant build is asserted.

Prior exact multiband pair equations: M. Iskin, *Two-body problem in a multiband lattice and the role of quantum geometry*, arXiv:2102.03530. Prior constructive many-body families: Z. Han et al., *Quantum Geometric Nesting and Solvable Model Flat-Band Systems*, arXiv:2401.04163v3. All-flat-band comparison: S. S. Elden and M. Iskin, *Correlation lengths of flat-band superconductivity from quantum geometry*, arXiv:2601.12969. These are substantive comparison sources, not a claim that a search for a title establishes priority of the complete derivation.

The next physical calculation acts on the retained object: recompute D,G for a changed geometry; retain the noncommuting pencil when required; carry energy derivatives into the reconstruction metric; and transport all physical source vertices. Retardation, finite-density response of H_on, defects, and chemical energetics are still coupled tasks. The exact parent's newly solved density response adds further usable data without identifying H_on and H_parent.
