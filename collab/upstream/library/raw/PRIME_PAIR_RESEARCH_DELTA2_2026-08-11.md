# PRIME-PAIR RESEARCH DELTA 2 — fixed determinant as complete two-leg local invariant

## VERIFIED EXACT — determinant controls full p-adic collision depth
Let
\[
L_1(m)=Bm+t,\qquad L_2(m)=Am+s,
\]
with
\[
h=Bs-At=\det\begin{pmatrix}B&t\\A&s\end{pmatrix}.
\]
For every prime p with p not dividing AB, the p-adic roots
\[
\alpha=-t/B,\qquad \beta=-s/A
\]
satisfy
\[
\alpha-\beta=\frac{h}{AB}.
\]
Hence
\[
\boxed{v_p(\alpha-\beta)=v_p(h).}
\]
In particular the two forms have a common root mod p iff p|h, and they remain collided through exactly v_p(h) p-adic levels.

Therefore, at every good prime p not dividing the current slopes AB, the ENTIRE local collision tree of a two-leg affine Buchstab state is determined by the determinant valuation v_p(det M). Since det M is exactly preserved by Buchstab peeling, all untouched Euler places retain their complete charge-deformed local interaction, not merely the first-layer forbidden-residue count.

This strengthens the previous renormalization-locality law: determinant is both the global fixed-gap invariant and the complete good-prime local collision invariant.

## CONSEQUENCE — charge-deformed local factors are determinant class functions at good primes
The exact two-leg p-adic fugacity factor for p^k||h can be written as a function only of k=v_p(det M), z1,z2. Thus along the affine Buchstab RG, for q unequal to the peeled prime and q not dividing the updated slopes, the full local charge factor is invariant automatically because det M is invariant.

This gives a much stronger reason the fixed-determinant matrix space is natural: it packages precisely the local data that the singular series / charge-deformed Euler product needs.

## VERIFIED EXACT — primitive fixed-determinant states are a Smith-normal-form homogeneous space
For a primitive integer matrix M (gcd of its four entries 1) with det M=h, Smith normal form gives
\[
U M V=\operatorname{diag}(1,h)
\]
for U,V in GL_2(Z) (orientation refinements give SL_2 variants up to signs). Thus primitive determinant-h states form the integral double orbit of diag(1,h). This makes the previously suggested Hecke connection precise at the level of state space: determinant-h matrices are the standard matrices underlying degree-h Hecke correspondences/double cosets. What remains nontrivial is whether the *directed prime-peeling dynamics and its weights* coincide with, or define a useful transfer operator on, a standard Hecke correspondence.

## h=1 specialization — exact Farey adjacency
For det M=1 with M=[[B,t],[A,s]],
\[
\frac{s}{A}-\frac{t}{B}=\frac1{AB}.
\]
Thus t/B and s/A are Farey neighbors whenever represented in the usual positive/reduced normalization. The twin/gap-one affine Buchstab state space is literally built from adjacent rational endpoints; the recursion moves among determinant-one matrices.

## LIVE FRONTIER
Define the charge-weighted affine transfer operator on primitive determinant-h states. A peeling event on leg i at prime p acts by the exact ax+b matrix transformation and contributes fugacity z_i. Because untouched good-prime local factors are determinant class functions, factor them out first. Study the residual operator on the determinant-h homogeneous space. Questions:
1. Does it descend to a standard Hecke/Farey transfer operator after quotienting translation gauge?
2. Are its nontrivial eigenmodes exactly the connected boundary interaction Gamma_h that obstructs factorization?
3. Does rational/Dirichlet-character decomposition of this operator recover L-function spectral corrections naturally?
4. Can the scalar charge convolution semigroup exp_*(z f) be realized as the radial/abelianized part of this matrix-valued transfer semigroup?
