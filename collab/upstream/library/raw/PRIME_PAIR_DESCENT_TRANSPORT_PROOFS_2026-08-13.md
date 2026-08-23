# Prime-Pair Core: Descent–Transport Proofs
## Exact transport of the refoliation/descent machinery into the canonical arithmetic program
Date: 2026-08-13

### 1. Grand-canonical divisor kernel
Let \(f_z(n)=z^{\Omega(n)}\) and \(a_z=f_z*\mu\).

**Theorem 1.** \(a_z\) is multiplicative and
\[
a_z(p^k)=z^k-z^{k-1}=(z-1)z^{k-1}\quad(k\ge1).
\]

**Proof.** Multiplicativity follows from convolution of multiplicative functions. On \(p^k\), only the \(\mu(1)\) and \(\mu(p)\) terms survive. QED.

### 2. Grand-canonical divisor expansion
\[
\boxed{z^{\Omega(n)}=\sum_{d\mid n}a_z(d).}
\]

**Proof.** \(1*a_z=1*f_z*\mu=f_z\). QED.

### 3. Canonical kernels are coefficients
For \(q_r=1_{\Omega=r}\), \(\kappa_r=q_r*\mu\),
\[
\boxed{\kappa_r(d)=[z^r]a_z(d).}
\]

**Proof.** Coefficient extraction commutes with finite Dirichlet convolution:
\([z^r](f_z*\mu)=([z^r]f_z)*\mu=q_r*\mu\). QED.

### 4. Prime-power canonical kernel
\[
\boxed{\kappa_r(p^k)=1_{k=r}-1_{k=r+1}.}
\]

**Proof.** Extract \(z^r\) from \(z^k-z^{k-1}\). QED.

Thus nonmultiplicativity of fixed total charge is not local at one prime; it is created by the global total-charge constraint.

### 5. Fixed charge of an Euler product
Let \(A(z)=\prod_pA_p(z)\), \(A_p(z)=\sum_{m\ge0}a_{p,m}z^m\), \(a_{p,0}=1\).

**Theorem 5.**
\[
[z^r]A(z)=
\sum_{\sum_pm_p=r}\prod_pa_{p,m_p}.
\]

**Proof.** Formal product expansion and total-degree collection. QED.

Hence canonical charge imposes the global simplex constraint \(\sum_pm_p=r\) on independent Euler occupations.

### 6. Charge one and two
\[
[z]A=\sum_pa_{p,1},
\]
\[
[z^2]A=\sum_pa_{p,2}+\sum_{p<q}a_{p,1}a_{q,1}.
\]

**Proof.** The only partitions of total degrees 1 and 2. QED.

The cross-prime term at charge two is created exactly by canonical projection.

### 7. Canonical projection cannot factor placewise
For \(r\ge1\), fixed-charge extraction cannot generally be written as a product of independent local linear functionals.

**Proof for r=1.** Take only two nontrivial factors \(A_p=1+xz,A_q=1+yz\). The coefficient is \(x+y\). If it were \(F(x)G(y)\) for all x,y, setting y=0 and x=0 forces a multiplicative separation incompatible with \(x+y\). Higher r contains mixed partitions by Theorem 5. QED.

This is an exact non-descent theorem: canonical projection destroys Euler-place tensor independence.

### 8. Canonical Dirichlet symbols recovered
For
\[
F_\chi(z,s)=\prod_p(1-z\chi(p)p^{-s})^{-1},
\]
Theorem 5 gives
\[
Z_{1,\chi}=P_\chi(s),
\]
and
\[
Z_{2,\chi}
=\frac12(P_\chi(s)^2+P_{\chi^2}(2s)).
\]

**Proof.** Charge one chooses one occupied prime place. Charge two chooses either two distinct places or occupation two at one place. QED.

### 9. Divisor symbol
The twisted Dirichlet series of \(a_z\) is
\[
A_\chi(z,s)
=
\frac{F_\chi(z,s)}{L(s,\chi)}.
\]

**Proof.** Dirichlet convolution becomes multiplication of Dirichlet series; \(\mu\chi\) has series \(1/L(s,\chi)\). QED.

Taking coefficients:
\[
\boxed{K_{r,\chi}(s)=Z_{r,\chi}(s)/L(s,\chi).}
\]

For primes:
\[
K_{1,\chi}=P_\chi/L.
\]

This derives the canonical boundary symbol as the charge coefficient of one grand-canonical divisor-transport symbol.

### 10. Shifted grand-canonical CRT expansion
Define
\[
Z_{X,h}(z,w)=\sum_{n\le X}z^{\Omega(n)}w^{\Omega(n+h)}.
\]

**Theorem 10.**
\[
\boxed{
Z_{X,h}(z,w)
=
\sum_{d,e}a_z(d)a_w(e)N_X(d,e;h),
}
\]
where \(N_X(d,e;h)\) counts \(n\le X\) with \(d|n,e|n+h\).

**Proof.** Insert Theorem 2 on both legs and interchange finite sums. QED.

### 11. Every fixed-charge pair is one coefficient
\[
\boxed{
C_{r,t}(X;h)
=
[z^rw^t]Z_{X,h}
=
\sum_{d,e}\kappa_r(d)\kappa_t(e)N_X(d,e;h).
}
\]

**Proof.** Theorem 3 coefficientwise in Theorem 10. QED.

So prime pairs are exactly the \((1,1)\) canonical coefficient of one charge-deformed CRT transport family.

### 12. CRT is the local gluing law
The congruences \(n=0\bmod d\), \(n=-h\bmod e\) glue iff
\[
(d,e)|h.
\]

**Proof.** Generalized CRT. QED.

When compatible they form one residue class modulo \([d,e]\).

### 13. Exact equilibrium/boundary split
For compatible d,e,
\[
N_X(d,e;h)=X/[d,e]+B_X(a,[d,e]).
\]

**Proof.** Define \(B_X\) as discrepancy of the actual finite interval count from uniform residue density. QED.

By linearity, every charge coefficient splits exactly into equilibrium and positive-boundary terms.

### 14. Two distinct nonlocalizations
The grand-canonical local field factorizes over primes, but exact prime pairs require:
1. global fixed-charge extraction \([zw]\);
2. finite positive-boundary discrepancy \(B_X\).

**Theorem 14.** Neither is determined by one-prime marginal expectations alone.

**Proof.** Fixed charge fails placewise factorization by Theorem 7. Boundary discrepancy depends on the coherent CRT residue modulo the assembled lcm, not merely the marginal density of each divisibility event. QED.


# II. Additive transport across factorization-charge fibers

### 15. Charge-block representation
Let \(\Pi_r=1_{\Omega=r}\) on \(\ell^2(\mathbb N)\) and
\[
M^{(h)}_{r,t}=\Pi_rU_h\Pi_t.
\]

**Theorem 15.**
\[
\boxed{
M^{(h+k)}_{r,t}
=
\sum_sM^{(h)}_{r,s}M^{(k)}_{s,t}.
}
\]

**Proof.** Insert \(I=\sum_s\Pi_s\) between \(U_h\) and \(U_k\), using \(U_hU_k=U_{h+k}\). QED.

Thus the full charge-resolved matrix is an exact representation of additive translation.

### 16. Prime-block curvature
Taking r=t=1,
\[
M^{(h+k)}_{1,1}
=
M^{(h)}_{1,1}M^{(k)}_{1,1}
+
\sum_{s\ne1}M^{(h)}_{1,s}M^{(k)}_{s,1}.
\]

Define
\[
\mathcal K_{h,k}
=
M^{(h)}_{1,1}M^{(k)}_{1,1}
-
M^{(h+k)}_{1,1}.
\]

**Theorem 16.**
\[
\boxed{
\mathcal K_{h,k}
=
-\sum_{s\ne1}M^{(h)}_{1,s}M^{(k)}_{s,1}.
}
\]

**Proof.** Rearrangement. QED.

Every failure of prime-only additive composition is exactly mediated by excursions through other factorization charges.

### 17. Prime curvature is extrinsic, not intrinsic
**Theorem 17.**
\(\mathcal K_{h,k}\) is induced solely by projection to charge one; it vanishes when all charge sectors are retained.

**Proof.**
The full charge-block identity is exactly Theorem 15. The defect arises only after deleting the \(s\ne1\) terms. QED.

Therefore this curvature is **not itself the sieve parity obstruction**. It is a projection/compression curvature of an exactly flat parent translation representation.

This correction matters: do not promote \(\mathcal K\) directly to a cohomological parity invariant.

### 18. Charge fugacity restores the deleted intermediate sectors
Let
\[
Z=z^C=\sum_sz^s\Pi_s.
\]

Then inserting \(Z\) between additive translations generates the charge-resolved intermediate paths:
\[
\Pi_rU_hZU_k\Pi_t
=
\sum_sz^sM^{(h)}_{r,s}M^{(k)}_{s,t}.
\]

**Proof.** Spectral resolution of \(Z\). QED.

Thus fugacity is not only a counting parameter; it is the generating coordinate for the exact hidden charge paths deleted by canonical projection.

### 19. Prime-sector curvature is the missing-coefficient sum
At z=1,
\[
\Pi_1U_hZU_k\Pi_1
=
M^{(h+k)}_{1,1}.
\]

At z=0, only the vacuum intermediate sector survives; at coefficient \(z^1\), only prime intermediates survive.

**Proof.** Theorem 18 coefficient extraction. QED.

The additive composition law is therefore an analytic generating family in intermediate charge.

# III. Transporting the Reconstruction–Descent distinction

### 20. Full divisibility reconstructs charge but finite sieve need not descend
The canonical state already has
\[
\Omega(n)=\sum_p\sum_{a\ge1}1_{p^a|n}.
\]

**Theorem 20.**
The full divisibility diagonal reconstructs \(\Omega\) exactly.

**Proof.**
For each p, \(\sum_{a\ge1}1_{p^a|n}=v_p(n)\). Sum over p. QED.

This kills any claim of absolute charge invisibility.

### 21. Finite CRT phase descends additive translation
Let \(M=\prod_{p\le y}p^{a_p}\) be any finite modulus sufficient for the chosen truncated valuation observables, and \(q_M(n)=n\bmod M\).

**Theorem 21.**
\[
q_M(n+h)=q_M(n)+h\bmod M.
\]

**Proof.** Congruence arithmetic. QED.

So the full finite local phase is dynamically closed under addition.

### 22. Survival/roughness quotient generally does not descend
Let
\[
\rho_M(n)=1_{(n,M)=1}.
\]

For \(M\) divisible by 2 and 3, translation by 2 does not descend through \(\rho_M\).

**Proof.**
Take residues \(1,5\bmod6\), both coprime to 6. After +2 they become \(3,1\bmod6\), respectively non-coprime and coprime. QED.

Thus the standard sieve survival observable is a compression of a dynamically flat CRT phase into a dynamically nonclosed quotient.

### 23. Exact location of the finite-sieve dynamic defect
For a finite modulus M and shift h, define equivalence \(r\sim s\) iff \(\rho_M(r)=\rho_M(s)\).

**Theorem 23.**
Descent fails exactly when one equivalence class contains residues r,s with
\[
\rho_M(r+h)\ne\rho_M(s+h).
\]

**Proof.**
This is the deterministic descent criterion. QED.

The missing variable is not mystical: it is precisely the residual CRT phase inside a survival fiber relevant to future shifts.

### 24. Static parity and dynamic phase are distinct obstructions
At the exact primality horizon the canonical state isolates an unresolved tail charge bit after finite divisibility data. Separately, Theorem 22 shows even finite local survival loses CRT phase needed for additive dynamics.

**Theorem 24.**
These two losses are logically distinct: restoring the finite CRT residue does not by itself reconstruct large-prime tail charge, while restoring tail charge alone does not determine finite CRT phase.

**Proof.**
CRT residue modulo a finite M depends only on congruence class and cannot determine arbitrary factorization beyond primes dividing M. Conversely a scalar tail-charge value does not distinguish the many residue classes modulo M. QED.

So the core obstruction should no longer be compressed to a single “parity bit.” There is a **state reconstruction axis** and a **dynamic phase/descent axis**.

# IV. Buchstab transport as a genuine semigroup before boundary projection

### 25. Charge-deformed Buchstab measures form an additive charge semigroup
The canonical state has
\[
\mu_z=\delta_0+z\omega_z(u)\,du,
\qquad
\mathcal L\mu_z(s)=e^{zE_1(s)}.
\]

**Theorem 25.**
\[
\boxed{\mu_{z_1}*\mu_{z_2}=\mu_{z_1+z_2}.}
\]

**Proof.**
Laplace transforms multiply:
\[
e^{z_1E_1(s)}e^{z_2E_1(s)}
=
e^{(z_1+z_2)E_1(s)}.
\]
Uniqueness of Laplace transform in the locally finite class gives equality. QED.

### 26. Parity mode is the convolution inverse
\[
\boxed{\mu_{-1}*\mu_1=\delta_0.}
\]

**Proof.**
Theorem 25 with \(z_1=-1,z_2=1\). QED.

This is an actual group-like inverse in the charge parameter, not a metaphorical “negative mode.”

### 27. Charge-one generator
\[
\left.\partial_z\mu_z\right|_{z=0}
=
1_{u\ge1}\frac{du}{u}.
\]

**Proof.**
Differentiate
\[
\mathcal L\mu_z=e^{zE_1}
\]
at zero to obtain \(E_1(s)\), whose inverse Laplace transform is \(1_{u\ge1}du/u\). QED.

### 28. Canonical extraction again breaks semigroup factorization
The semigroup law is linear in the grand-canonical parameter z, but fixing a finite total charge means taking Taylor coefficients.

**Theorem 28.**
If
\[
\mu_z=\sum_{r\ge0}z^r\nu_r,
\]
then
\[
\boxed{
\nu_r
=
\sum_{a+b=r}\nu_a*\nu_b
}
\]
under a decomposition of charge parameter \(z=z_1+z_2\) after coefficient bookkeeping in independent variables.

More precisely,
\[
\mu_{z_1+z_2}
=
\sum_{a,b\ge0}z_1^az_2^b(\nu_a*\nu_b).
\]

**Proof.**
Expand \(\mu_{z_1}*\mu_{z_2}\) and use Theorem 25. QED.

Thus canonical charge r is assembled from every partition of r across scale-flow components—the same global simplex coupling as Theorem 5.

### 29. Static Euler charge and Buchstab charge have the same canonical-composition law
Both the Euler product and Buchstab convolution semigroup obey:
grand-canonical parameter addition/product factorizes; fixed-charge coefficients sum over all partitions of total charge.

**Proof.**
Euler case: Theorem 5. Buchstab case: Theorem 28. QED.

This is an exact structural identification inside the core program.

It suggests that the right “one-particle” object is the infinitesimal charge generator, while fixed primes are canonical boundary extraction after the full scale transport.


# V. Affine Buchstab flow and path coherence

### 30. Determinant is a transport invariant
Encode two affine forms by
\[
M=\begin{pmatrix}a&b\\c&d\end{pmatrix}.
\]
A peel of prime p from leg one in residue r acts
\[
M'
=
\begin{pmatrix}p^{-1}&0\\0&1\end{pmatrix}
M
\begin{pmatrix}p&r\\0&1\end{pmatrix}.
\]

**Theorem 30.**
\[
\det M'=\det M.
\]

**Proof.**
The left and right multipliers have determinants \(p^{-1}\) and p. QED.

So the gap/determinant is a first integral of the affine Buchstab transport.

### 31. Two-leg peeled state is a fixed-determinant lattice
After peeled divisors A|n, B|n+h with (A,B)=1, write the CRT parametrization so residual forms are
\[
n/A=Bm+t,\qquad
(n+h)/B=Am+s.
\]

**Theorem 31.**
\[
\boxed{Bs-At=h.}
\]

**Proof.**
Multiply:
\[
B(n+h)/B-A(n/A)=n+h-n=h.
\]
Substitute residual forms:
\[
B(Am+s)-A(Bm+t)=Bs-At.
\]
QED.

Thus the affine flow lives on integer matrices of fixed determinant h.

### 32. Order of peeling coprime primes is path-equivalent at the congruence level
Suppose distinct primes p,q are peeled from specified legs/residue constraints and the combined congruence system is compatible.

**Theorem 32.**
Peeling p then q and q then p yields the same final CRT residue class modulo pq (after canonical reparametrization).

**Proof.**
Both procedures impose the same pair of congruence conditions modulo p and q. CRT uniqueness gives the same residue modulo pq. QED.

This is genuine path coherence of the finite local congruence transport.

### 33. Local Euler data is flat under independent peel order
For any third prime \(\ell\ne p,q\), the forbidden-residue configuration after peeling p and q is related to the original by an invertible affine change modulo \(\ell\), independent of peel order up to composition.

**Proof.**
Each peel parametrizes \(n=r+pm\) or \(n=r'+qm\); multiplication by p,q is invertible mod \(\ell\). Composition is an invertible affine map. The set cardinality/collision partition of forbidden residues is invariant under affine bijection. QED.

Thus independent finite-place local density has zero peel-order curvature.

### 34. Any nontrivial peel-order obstruction must enter through boundary/stopping data
Under the hypotheses of Theorems 32–33, local congruence state and determinant are path coherent.

**Corollary 34.**
A difference between peel orders cannot be detected by the finite-place local-density quotient alone; it must use data discarded by that quotient, such as positive interval boundaries, least-prime stopping/order restrictions, or residual charge/tail information.

**Proof.**
All observables factoring through the coherent local congruence/determinant state agree. QED.

This is the exact transport version of the library's statement that hard arithmetic lives in the positive-cone lift after local equilibrium is divided out.

### 35. Least-prime ordering is not a gauge symmetry
Buchstab peeling chooses the least prime factor, so arbitrary permutations of peel order need not be admissible paths of the same recursion.

**Theorem 35.**
CRT commutation of independent divisibility constraints does not imply commutation of the **ordered least-prime stopping process**.

**Proof.**
The least-prime rule includes an inequality constraint excluding smaller primes at each step. Swapping a later prime before a smaller prime changes whether the path satisfies that rule, even though the final divisibility congruences commute. QED.

Therefore the true boundary transport is a path category with order/stopping structure, not merely an abelian set of local prime removals.

### 36. This identifies the correct curvature target
The local divisor constraints are flat by Theorem 32, while the canonical charge projection is extrinsically curved by Theorem 17 and the least-prime boundary process is order-sensitive by Theorem 35.

**Conclusion theorem 36.**
Any intrinsic arithmetic obstruction worth comparing to refoliation holonomy must be sought in the **ordered positive-boundary lift after retaining enough charge state**, not in raw CRT commutation and not in prime-projector compression curvature alone.

**Proof.**
Raw CRT path mismatch vanishes. Prime-projector mismatch is explained entirely by deleted charge sectors. The remaining nontrivial process structure is the ordered/stopped lift. QED.

# VI. A new exact factorization of the master problem

### 37. Three maps
The core arithmetic pipeline can be separated as:

\[
\text{fine integer/affine state}
\xrightarrow{Q_{\rm loc}}
\text{finite local/CRT state}
\xrightarrow{E}
\text{local equilibrium quotient},
\]
together with
\[
\Pi_r:\text{charge generating family}\to\text{fixed charge},
\]
and positive-boundary sampling \(P_X\).

**Theorem 37.**
The following failures are mathematically distinct:
1. \(Q_{\rm loc}\) truncation can lose tail charge;
2. \(E\) can lose CRT phase/dynamic information;
3. \(\Pi_r\) creates cross-place canonical coupling;
4. \(P_X\) creates coherent boundary discrepancy.

**Proof.**
(1) Finite divisibility does not determine factors beyond the cutoff.
(2) The survival quotient fails additive descent while full CRT phase descends.
(3) Theorem 7.
(4) The exact \(B_X(a,m)\) term depends on assembled residue phase. QED.

This replaces a single undifferentiated “parity barrier” by four exact operations.

### 38. Prime-pair theorem target after transport correction
After factoring exact local equilibrium and retaining full charge-generating transport, the genuinely hard object is the positive-boundary canonical coefficient:
\[
\boxed{
[zw]\,
Z^\partial_{X,h}(z,w).
}
\]

**Proof.**
Theorem 14 splits the exact pair count into equilibrium plus boundary, and Theorem 11 identifies prime pairs with [zw]. QED.

Character diagonalization gives the already-canonical symbol \(P_\chi/L\), so the boundary target is precisely the charge-one coefficient of the grand-canonical boundary transport.

### 39. Coefficient-before-boundary versus boundary-before-coefficient commute linearly
Let \(\mathcal B_X\) be the linear operation replacing each CRT congruence count by its discrepancy \(B_X\).

**Theorem 39.**
\[
[zw]\mathcal B_X Z(z,w)
=
\mathcal B_X[zw]Z(z,w).
\]

**Proof.**
Both coefficient extraction and \(\mathcal B_X\) are linear. QED.

Therefore the hard obstruction is **not** a failure of these two linear operations to commute.

This kills a tempting but false “curvature” story.

### 40. Where noncommutation really occurs
The nonlinear/product operation of forming local Euler equilibrium does not commute with canonical coefficient extraction as a placewise tensor operation (Theorem 7), while the least-prime stopped transport is not freely reorderable (Theorem 35).

**Theorem 40.**
These, not the linear equilibrium/boundary split, are the exact non-descent points currently proved.

QED by cited theorems.

# VII. Consequence for the Cubical/obstruction branch

### 41. Static two-element tail fiber is insufficient for cohomology
At scale \(\sqrt X\), the unresolved tail charge may be a bit.

**Theorem 41.**
The existence of a two-element reconstruction fiber does not by itself define a nontrivial cocycle/monodromy.

**Proof.**
A product bundle \(B\times\{0,1\}\to B\) has two-element fibers and trivial monodromy. QED.

### 42. Correct finite transport test
Let B be the finite observable state space and F_b its residual charge fiber. A scale/peel path induces transport between fibers whenever the fine arithmetic state supplies a lift.

**Theorem 42.**
A genuine binary obstruction requires a loop whose induced permutation on a two-element fiber is nontrivial.

**Proof.**
For a two-sheeted covering/fiber transport, monodromy lies in \(S_2\cong\mathbb Z/2\). Nontriviality is exactly sheet exchange. QED.

Thus the Cubical target must add path transport to the existing quotient/fiber model.

### 43. But prime-projector compression cannot supply this monodromy
**Theorem 43.**
The operator curvature \(\mathcal K_{h,k}\) of Theorem 16 does not define such a binary sheet exchange without additional structure.

**Proof.**
\(\mathcal K\) is an operator sum over all \(s\ne1\) charge sectors, not a permutation of a two-element residual fiber. QED.

This prevents conflating the new descent machinery with the old parity-obstruction conjecture.

# VIII. Core synthesis theorem

### 44. Arithmetic Descent Theorem — current exact form
The established prime-pair machinery decomposes into:

1. **flat grand-canonical local transport:** Euler/p-adic charge fields factor placewise;
2. **global canonical coupling:** fixed total charge is coefficient extraction across all Euler places;
3. **flat full additive transport:** \(U_hU_k=U_{h+k}\), equivalently the full charge-block matrix composes exactly;
4. **extrinsic canonical curvature:** restricting intermediate states to charge one deletes all \(s\ne1\) paths;
5. **flat CRT constraint gluing:** compatible prime divisibility constraints commute under CRT;
6. **ordered positive-boundary transport:** least-prime Buchstab stopping is not freely reorderable;
7. **boundary spectral sector:** exact fixed-charge boundary symbol is \(Z_{r,\chi}/L\), and for primes \(P_\chi/L\).

**Proof.**
Items 1–7 are Theorems 16,5–9,15–17,12/32,35, and9/38 respectively. QED.

### 45. Corrected master obstruction
**Theorem 45.**
None of the following alone can be the final prime-pair obstruction:
- local Euler nonfactorization (it factorizes grand-canonically);
- raw additive noncommutation (translations commute);
- raw CRT peel-order curvature (compatible constraints are path coherent);
- prime-projector compression curvature (it is extrinsic and exactly resolved by restoring charge sectors).

**Proof.**
Theorems 16,15,32,17. QED.

Therefore the unresolved obstruction is forced farther downstream:

\[
\boxed{
\text{canonical charge boundary}
+
\text{ordered Buchstab stopping}
+
\text{positive-cone CRT phase}
}
\]

after exact finite-adic equilibrium has been factored out.

This is not a proof of Hardy–Littlewood. It is a proof that several candidate obstruction locations are wrong and that the remaining core is more sharply localized.

### 46. Strongest next theorem target
Define the charge-deformed positive-boundary transfer before taking \([zw]\), normalize out:
- exact finite-adic local factors;
- one-body charge/Buchstab semigroups.

Then prove either:

(A) the normalized connected two-leg transport descends to the fixed-determinant affine state and is flat/trivial; or

(B) exhibit its exact residual operator and prove a nontrivial spectral/character decomposition whose charge-one coefficient is \(P_\chi/L\).

This line is a target, not a theorem.

### 47. End
The transported insight is now precise:

**Reconstruction** asks which charge/tail information a sieve snapshot loses.

**Descent** asks whether the retained local state evolves autonomously under additive/scale transport.

**Curvature** must be computed only after restoring extrinsic charge sectors and quotienting genuine gauge/path equivalences.

The core prime-pair problem survives exactly in the positive-boundary canonical lift, not in the already-explained projection defects.
