# Prime Pair Field — Fields-Medal / Cross-Mathematics Delta 12

Date: 2026-08-11

Status: research delta. Universal-family point-count and fusion identities are **V1**. The motivic/nearby-cycle and Ran-space frameworks are known prior art. Identifying the charge derivative with a monodromy-logarithm class is a precise conjectural bridge, not yet a theorem.

## 0. Executive result: the local singular-series field is the pushforward of a universal punctured line

Let

\[
B_k=\mathbb A^k/\mathbb G_a
\]

be the space of ordered shifts modulo common translation, and define the universal marked divisor

\[
D_k
=
\bigcup_{i=1}^k\{x+h_i=0\}
\subset
\mathbb A^1_x\times B_k.
\]

Its complement is

\[
\boxed{
\mathcal U_k
=
(\mathbb A^1\times B_k)\setminus D_k,
\qquad
\pi:\mathcal U_k\to B_k.
}
\]

For a shift configuration `H`, the fiber is the punctured affine line

\[
\mathcal U_{k,H}
=
\mathbb A^1\setminus\{-h_1,\ldots,-h_k\}.
\]

At a finite prime `p`, if `nu_p(H)` is the number of distinct punctures after reduction, then

\[
\boxed{
\#\mathcal U_{k,H}(\mathbb F_p)
=p-\nu_p(H).
}
\]

Therefore the uncharged local survival probability is exactly

\[
\boxed{
\frac1p\#\mathcal U_{k,H}(\mathbb F_p)
=1-\frac{\nu_p(H)}p.
}
\]

After dividing by the independent one-leg density `(1-1/p)^k`, this is the Hardy–Littlewood local factor.

Thus the local equilibrium/singular-series field is already the point-count pushforward of an explicit algebraic family. The remaining charge variables refine the point count by adding weighted formal neighborhoods of the divisor.

---

## 1. V1: collision strata are the discriminant stratification of the universal family

The base discriminant is the type-A braid arrangement

\[
\Delta_k
=
\bigcup_{i<j}\{h_i-h_j=0\}.
\]

Over a field of characteristic `p`, the reduction of `H` lands on the flat corresponding to the set partition of indices with equal residues modulo `p`.

Thus:

- the generic stratum has `k` distinct punctures and fiber count `p-k`;
- a collision stratum with `nu` clusters has fiber count `p-nu`;
- nested congruences modulo `p^r` produce the full p-adic cluster tree;
- bad primes are exactly those dividing the shift discriminant

\[
\operatorname{Disc}(H)
=
\prod_{i<j}(h_i-h_j).
\]

The local singular-series correction at collision primes is therefore ordinary degeneration of the universal punctured-line family.

---

## 2. V1: the charge integral is a tube-weighted point count

For fugacities `z_i`, the exact local field is

\[
I_{p,H}(\mathbf z)
=
\int_{\mathbb Z_p}
\prod_{i=1}^kz_i^{v_p(x+h_i)}\,dx.
\]

The open complement contributes the measure of points avoiding every puncture modulo `p`:

\[
1-\frac{\nu_p(H)}p.
\]

Every residue ball meeting a puncture contributes its entire tower of infinitesimal p-adic neighborhoods, weighted by valuation depth. Hence `I_{p,H}` is the natural zeta/tube refinement of the finite-field point count of `mathcal U_{k,H}`.

With `z_i=p^{-s_i}`,

\[
I_{p,H}(p^{-s_1},\ldots,p^{-s_k})
=
\int_{\mathbb Z_p}
\prod_i|x+h_i|_p^{s_i}\,dx,
\]

an ordinary multivariate Igusa local zeta integral for the universal marked divisor.

---

## 3. V1: collision fusion is multiplication of charges

Partition the labels into residue clusters `C` modulo `p`. In the ball corresponding to `C`, write

\[
x=-a_C+py.
\]

For every `i in C`,

\[
v_p(x+h_i)
=1+v_p\!\left(y+\frac{h_i-a_C}{p}\right).
\]

Therefore the common first-depth contribution is

\[
\prod_{i\in C}z_i
=:
\boxed{z_C}.
\]

The exact recursion is

\[
\boxed{
I_{p,H}(\mathbf z)
=
1-\frac{\nu_p(H)}p
+
\frac1p\sum_C
z_C I_{p,H_C'}(\mathbf z_C).
}
\]

The decisive structural law is

\[
\boxed{
\text{when marked points collide, their charges fuse multiplicatively.}
}
\]

In additive exponent variables `z_i=p^{-s_i}`, this is

\[
s_C=\sum_{i\in C}s_i.
\]

This is exactly the fusion/OPE law expected for rank-one charges attached to marked points.

---

## 4. Drinfeld / Beilinson factorization interpretation

The Ran space of a curve parametrizes finite subsets of points, with diagonals describing collisions and factorization describing separated configurations. The prime-pair shift data are precisely finite colored configurations on the affine line.

The local charge field supplies:

- a label `z_i` at each marked point;
- a function/integral on each configuration;
- a canonical fusion map on collision diagonals:

\[
(z_i)_{i\in C}
\longmapsto
\prod_{i\in C}z_i;
\]

- compatibility under iterated nested collisions, because multiplication is associative.

This is enough to place the collision recursion in the vocabulary of a colored factorization/fusion system over the Ran space.

It has not yet been verified that the complete collection of local integrals satisfies every sheaf-theoretic axiom of a Beilinson–Drinfeld factorization algebra. The precise safe claim is:

\[
\boxed{
\text{the charge recursion is an associative fusion law on the collision stratification of the Ran/configuration space.}
}
\]

---

## 5. V1: associativity and the collision-tree pentagon

Suppose three clusters with charges `z_1,z_2,z_3` collide through either bracketing. Then

\[
(z_1z_2)z_3
=z_1(z_2z_3).
\]

At the exponent level,

\[
(s_1+s_2)+s_3
=s_1+(s_2+s_3).
\]

Thus every binary collision tree gives the same total fused charge, while retaining different intermediate scales/cluster strata.

This is the same elementary associativity underlying:

- beta-function factorization

\[
B(a,b)B(a+b,c)
=
B(b,c)B(a,b+c);
\]

- `SU(1,1)` Racah recoupling;
- Hall-algebra extension bracketing;
- nested Buchstab peeling;
- stable-tree boundary strata of configuration space.

The scalar charge law satisfies the pentagon tautologically. The nontrivial target is to identify the **operators/measures** attached to different trees and prove that their recoupling is governed by one Racah/associator object.

---

## 6. KNOWN: motivic zeta and nearby-cycle package

Denef–Loeser motivic Igusa zeta functions:

- live in Grothendieck groups of motives;
- specialize to p-adic Igusa zeta functions at good primes;
- admit topological and Hodge realizations;
- are related to motivic nearby cycles and monodromy.

For the universal marked divisor, this means the entire finite-place collision family can in principle be packaged before choosing `p`.

Hyperplane-arrangement Igusa functions are known to admit combinatorial formulas through intersection lattices/flag Hilbert–Poincaré series. Since the discriminant here is the type-A braid arrangement, the project has a particularly explicit test case.

The concrete target is a **relative motivic zeta function over `B_k`**, not a separate local computation for every fixed `H`.

---

## 7. V1: charge derivatives are valuation-depth insertions

Differentiate with respect to logarithmic charge:

\[
\mathcal D_i
=z_i\frac{\partial}{\partial z_i}.
\]

Then

\[
\boxed{
\mathcal D_i I_{p,H}(\mathbf z)
=
\int_{\mathbb Z_p}
 v_p(x+h_i)
\prod_jz_j^{v_p(x+h_j)}\,dx.
}
\]

More generally, higher derivatives insert products/falling moments of valuation depths.

At a parity-annihilation point, the value of the local trace can vanish while the depth insertion survives. For generic `k` at `p=2k-1`, equal fugacity gives

\[
I_{p,k}(-1)=0,
\qquad
I_{p,k}'(-1)=\frac{k-1}{2k}.
\]

For twins at `p=3`,

\[
I_{3,2}(-1)=0,
\qquad
I_{3,2}'(-1)=\frac14.
\]

Thus the first derivative is the canonical nonzero tangent datum at the vanished local sector.

---

## 8. Nearby/vanishing-cycle interpretation of the derivative — precise conjecture

In a degeneration where punctures collide, nearby-cycle theory records:

- semisimple monodromy eigenvalues;
- a nilpotent logarithm of unipotent monodromy;
- vanishing-cycle contributions supported on the collision stratum.

The charge variable is the eigenvalue/fugacity attached to valuation around a divisor. Differentiation in logarithmic charge inserts valuation depth, which is formally analogous to differentiating a monodromy eigenvalue or inserting a monodromy logarithm.

This suggests the precise target:

> Construct a relative sheaf/motive for the universal marked divisor whose Frobenius/monodromy trace specializes to `I_{p,H}(z)`, and identify `z d/dz` at a root-of-unity charge with a logarithmic nearby-cycle/monodromy insertion.

If successful, the derivative-regularized parity zero would become an actual vanishing-cycle class rather than a formal first variation.

This identification is not yet proved.

---

## 9. Archimedean fiber: beta integrals are the same marked-line local zeta geometry

For two marked points at `0` and `1`, the archimedean chamber integral is

\[
\boxed{
\int_0^1x^{\rho-1}(1-x)^{\rho'-1}\,dx
=B(\rho,\rho').
}
\]

This is the real local zeta integral of the two-divisor marked line. Delta 07 showed that its angular modes are continuous Hahn polynomials and its representation theory is `SU(1,1)` Clebsch–Gordan theory.

For more legs, the Dirichlet simplex integral

\[
\int_{\Delta_{k-1}}
\prod_i t_i^{\rho_i-1}\,dt
=
\frac{\prod_i\Gamma(\rho_i)}{\Gamma(\sum_i\rho_i)}
\]

is obtained by iterated fusion/beta integration. Different bracketings are related by Racah recoupling.

Therefore finite and real places share the exact skeleton:

\[
\boxed{
\text{marked configurations}
+\text{local zeta integrals}
+\text{additive exponent fusion}
+\text{collision/recoupling associativity}.
}
\]

The parameters used by the arithmetic problem differ between places, so no adelic product formula is claimed.

---

## 10. Koba–Nielsen/string-amplitude relation: exact category, limited conclusion

Koba–Nielsen amplitudes over local fields are multivariate local zeta functions of products of differences of marked points. The project’s finite charge integrals and archimedean beta/Dirichlet kernels belong to this same mathematical class.

This gives usable machinery:

- embedded resolution / wonderful compactification;
- meromorphic continuation in charge variables;
- factorization on boundary strata;
- p-adic, real, topological, and motivic realizations;
- associators/recoupling on moduli of marked curves.

It does **not** imply that the Prime Pair Field is a physical string amplitude, nor that the existing adelic string product formulas directly apply. The exact gain is access to the local-zeta/factorization technology.

---

## 11. Ngô-style geometrization becomes explicit

The earlier target “find a global fibration whose local fibers produce singular-series factors” now has a minimal answer:

\[
\pi:\mathcal U_k\to B_k.
\]

Its ordinary finite-field fiber count gives the uncharged local numerator. Its formal/tubular motivic integral gives the charge-deformed factor. Its discriminant stratification gives collision primes. Its nearby cycles are the natural home of derivative-regularized annihilation.

What remains for a genuinely Ngô-like theorem is not discovering the fibration, but proving a **global cohomological identity or support theorem** strong enough to control the positive-integer boundary lift.

The local geometry is now explicit; the hard global arithmetic is still absent.

---

## 12. Function-field calibration sharpened

Function-field prime-pattern theorems use monodromy and vanishing cycles to control factorization types. Delta 12 identifies the exact degeneration space on the number-field/local side:

- puncture collisions are the discriminant;
- cluster monodromy fuses charge characters;
- the parity point is an order-two charge;
- derivative insertions measure depth along the degeneration.

Thus the phrase “parity falls to monodromy/vanishing cycles in function fields” now has a direct candidate object in the Prime Pair Field program.

The missing step is a characteristic-zero/global arithmetic realization whose Frobenius-like trace samples positive integers rather than finite-field points.

---

## 13. A factorization-space formulation of the master problems

### Reconstruction

Recover the boundary arithmetic state from the collection of local factorization traces on all finite configurations and scales.

### Obstruction

When the parity trace vanishes on a collision/fusion stratum, retain the logarithmic derivative/nearby-cycle class and determine whether it obstructs or enables lifting.

### Positivity

Use Hodge/weight structures on the motivic nearby-cycle package and the real `SU(1,1)` primitive form to obtain a sign after global pairing.

All three master problems now live over the same configuration/Ran-space family.

---

## 14. Revised priorities after Delta 12

1. Construct the relative motivic Igusa zeta function of the universal marked divisor over `B_k`.
2. Express its strata explicitly through the type-A partition lattice and wonderful compactification.
3. Compute the nearby-cycle object at the generic binary and ternary collision.
4. Test whether the logarithmic charge derivative is the trace of a monodromy-logarithm insertion.
5. Compare the first derivative at the annihilation prime with the known mixed/first-variation Goldbach block.
6. Formulate the charge collision recursion as a colored Ran-space factorization/fusion functor.
7. Match its recoupling maps with `SU(1,1)` Racah coefficients and Buchstab peeling trees.
8. Search for a global relative trace/support theorem; do not mistake the existence of the universal fibration for a solution of Goldbach.

---

## 15. Verification boundaries

**V1:**

- universal punctured-line family and finite-field fiber count;
- identification of uncharged local survival with normalized fiber count;
- tube-weighted Igusa refinement;
- multiplicative charge fusion and additive exponent fusion;
- associativity of collision charge;
- logarithmic derivative as valuation-depth insertion;
- archimedean beta integral as a marked-line local zeta integral.

**Known prior art:**

- Ran spaces/factorization structures;
- motivic Igusa zeta functions and nearby cycles;
- arrangement Igusa formulas;
- Koba–Nielsen amplitudes as local zeta functions.

**Conjectural:**

- charge derivative equals a monodromy-logarithm/nearby-cycle trace;
- one common associator controls Buchstab and `SU(1,1)` recoupling;
- a global support/trace theorem controls positive-integer prime stopping;
- any consequence for Goldbach or RH.

## 16. Literature anchors

- Beilinson and Drinfeld, *Chiral Algebras*, Ran space and factorization chapters.
- Denef and Loeser, *Motivic Igusa zeta functions*, arXiv:math/9803040.
- Maglione and Voll, arrangement Igusa functions / flag Hilbert–Poincaré series.
- Bocardo-Gaspar, García-Compeán, López, and Zúñiga-Galindo, local zeta functions and Koba–Nielsen amplitudes, arXiv:2105.00298.
- Standard nearby/vanishing-cycle and monodromy theory.
