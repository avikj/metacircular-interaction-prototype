# Hostile audit of the defect-calculus nucleus

**Verdict.** Theorems 4.1 and 5.1 survive a from-scratch derivation, including
the edge case `p=2, k=1`. Equation (5.4) required a clarified conormal
base-change domain. Determinant of cohomology supplies no canonical positive
scalarization: its natural torsion trivialization makes the same-prime
derived incidence have norm one, equivalently logarithmic length zero.

## 1. Derived tensor and degree conventions

For primes `p,q`, resolve the first factor by the homological complex

\[
 P_\bullet=[\mathbb Z\xrightarrow{p}\mathbb Z]
\]

in degrees `1,0`. Tensoring with `F_q` gives

\[
 [\mathbb F_q\xrightarrow{p}\mathbb F_q].
\]

If `p!=q`, multiplication by `p` is invertible in `F_q`, so the complex is
contractible. If `p=q`, its differential is zero, giving `H_1=H_0=F_p` and
no other homology. This proves Theorem 4.1 with the declared homological
convention. A cohomological convention places the same groups in degrees
`-1,0`; changing convention does not change their opposite determinant
parities or the cancellation.

The cases where an index is not a prime power are genuinely zero because the
corresponding module `D_n` is the zero module, not merely a module of
cardinality one. Derived tensor with it vanishes.

## 2. The ramified conormal map

Let `t=zeta_(p^(k+1))`. Then

\[
 1-t^p=(1-t)(1+t+\cdots+t^{p-1}).
\]

At the unique prime above `p`, the second factor has valuation `p-1`, hence
`pi_k=u_k pi_(k+1)^p` for a unit `u_k`. Therefore the image of `pi_k` lies in
`I_(k+1)^2` for every prime `p`, proving that the conormal differential is
zero.

The exact typed map is

\[
 (I_k/I_k^2)\otimes_{O_k/I_k}\mathbb F_p
 \longrightarrow I_{k+1}/I_{k+1}^2.
\]

Both sides are vector spaces over the common residue field induced by the
tower map. Writing tensor over `O_k` is isomorphic after declaring the module
structure, but obscures that this is conormal base change along the closed
point.

For the delicate edge case `p=2,k=1`, `O_1=Z`, `pi_1=2`, `O_2=Z[i]`, and

\[
 2=-i(1-i)^2.
\]

Thus the residue map is `Z/2 -> Z[i]/(1-i)=F_2`, an isomorphism, while the
conormal generator maps to zero modulo `(1-i)^2`. Theorem 5.1 survives
unchanged.

## 3. Determinant of cohomology

Let `C=F_p tensor_Z^L F_p`. It is a perfect torsion complex over `Z`.
Its determinant line is

\[
 \det C=\bigotimes_i(\det H_i(C))^{(-1)^i}
\]

in determinant-functor notation. After tensoring with `Q`, `C` is acyclic,
so rational acyclicity gives the canonical torsion trivialization of this
line. The integral covolume under that trivialization is

\[
 \prod_i|H_i(C)|^{(-1)^i}=|F_p|/|F_p|=1.
\]

Equivalently, its logarithmic torsion length is zero. This conclusion is not a
choice of bases in the two `F_p` terms: it is forced by additivity of the
determinant functor on exact triangles and the rational acyclic trivialization.

There is also no hidden orientation supplied by exchanging the two factors.
The derived self-intersection has a degree-one Tor class paired with the
degree-zero tensor class; determinant parity places them on opposite sides.
A rule retaining only one side is a truncation or polarization, not the
canonical determinant of the original derived object.

## 4. Why the cyclotomic norm does not repair it

The norm correspondence `N_(k+1/k)(pi_(k+1))=pi_k` records ramification across
tower levels. It acts on the cyclotomic local rings and their ideals. It does
not furnish a canonical map selecting `H_0` over `H_1` in
`D_(p^a) tensor_Z^L D_(p^b)`. Both homology groups carry the same residue
field, and the determinant functor sees their equal lengths with opposite
parity.

One can obtain `log p` by truncating to `H_0`, shifting one chosen factor, or
equipping the complex with additional metric/orientation data. None is
intrinsic to the symmetric derived incidence object, and each must state why
factor symmetry, exact-triangle additivity, or self-duality is being broken.
Thus determinant of cohomology is a sharp no-go for the proposed canonical
scalarization, not the missing polarization.

## 5. Rigor boundary

Re-derived here: all homology calculations, the conormal zero map, the
`p=2,k=1` case, and determinant cancellation. Standard input: determinant
functors for perfect complexes and their rational acyclic torsion
trivialization. No claim is made that every possible enriched or metrized
intersection pairing must vanish; only the unadorned canonical determinant
of this derived `Z`-tensor product is closed.
