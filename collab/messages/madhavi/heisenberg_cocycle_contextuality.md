**From:** Madhavi  
**Object:** two-qubit Pauli observables as a finite Heisenberg central extension.

Let

```text
V = F_2^2 direct-sum F_2^2.
```

Write `u=(a,b)` with `a,b in F_2^2`, and define the alternating symplectic
form

```text
omega((a,b),(a',b')) = a dot b' + b dot a' in F_2.      (1)
```

For bit vectors, put

```text
X^a = X^(a_1) tensor X^(a_2),
Z^b = Z^(b_1) tensor Z^(b_2),
W(a,b) = X^a Z^b.
```

Then direct multiplication gives

```text
W(a,b) W(a',b')
  = (-1)^(b dot a') W(a+a',b+b').                       (2)
```

Thus `c(u,v)=(-1)^(b dot a')` is a normalized `±1`-valued 2-cocycle:

```text
c(u,v)c(u+v,w)=c(v,w)c(u,v+w).                          (3)
```

Equation (3) is associativity written downstairs. The commutator is its
antisymmetrization:

```text
W(u)W(v)=(-1)^omega(u,v) W(v)W(u).                      (4)
```

The Pauli group is therefore a central extension

```text
1 -> {±1,±i} -> P_2 -> V -> 0.                          (5)
```

The quotient `V` remembers which observables commute through `omega`; it does
not remember all multiplication signs. Those live in the extension cocycle
and in the choice of section.

## Hermitian section

To obtain self-adjoint involutions, choose

```text
P(a,b)=i^(a dot_Z b) W(a,b),                             (6)
```

where `a dot_Z b` is the ordinary integer count of coordinates with
`a_j=b_j=1`. Every `P(u)` is Hermitian and `P(u)^2=I`. Its multiplication law is

```text
P(u)P(v)=alpha(u,v)P(u+v),                              (7)
```

with

```text
alpha(u,v)=i^(q(u)+q(v)-q(u+v)) (-1)^(b dot a'),        (8)
q(a,b)=a dot_Z b,
```

where addition inside `q(u+v)` is bitwise XOR. `alpha` is a `mu_4`-valued
2-cocycle cohomologous to (2). If `omega(u,v)=0`, then `alpha(u,v)` is `±1`.
Thus even inside a commuting isotropic subspace, the lifted product has a
central sign not present in the additive shadow.

## Peres--Mermin as six isotropic relations

Use the nine vectors corresponding through (6) to

```text
X I     I X     X X
I Y     Y I     Y Y
X Y     Y X     Z Z.
```

Every row and column is a triple `(u,v,w)` of pairwise symplectically
orthogonal vectors with

```text
u+v+w=0.                                                (9)
```

Hence its lifted product is central:

```text
P(u)P(v)P(w)=sigma_C I,   sigma_C in {±1}.              (10)
```

Evaluating the cocycle gives

```text
rows:    +1,+1,+1,
columns: +1,+1,-1.                                      (11)
```

The negative final column is not caused by noncommutation: that column is
isotropic, and its three operators commute. It is a central-extension sign.

## The obstruction theorem

Let the nine observables be vertices and the six commuting triples be
contexts. Suppose a classical flattening assigns `v_j in {±1}` to every
observable and preserves every local product. Then

```text
product_{j in C} v_j = sigma_C                           (12)
```

for each context `C`. Multiplying all six equations, every observable occurs
twice, so the left side is `+1`. By (11), the right side is `-1`. Contradiction.

Equivalently over `F_2`, write `v_j=(-1)^(t_j)` and
`sigma_C=(-1)^(s_C)`. If `M` is the context--observable incidence matrix, a
global valuation would solve

```text
M t = s.                                                (13)
```

Every column of `M` has even weight, so the sum of coordinates of every vector
in `im(M)` is zero. The sign vector `s` has odd total parity. Therefore

```text
[s] != 0 in coker(M).                                   (14)
```

Changing the Hermitian section by signs

```text
P(u_j) |-> (-1)^(r_j)P(u_j)
```

changes `s` by `Mr`. Hence the cokernel class (14), not the individual context
sign convention, is invariant. This is the smallest precise sense in which
the cocycle survives all local rephasings.

## What the symplectic quotient loses

If one keeps only `(V,omega)`, all six contexts are merely isotropic triples
summing to zero. The odd parity in (11) is invisible. It enters through the
Heisenberg extension/section multiplication. Thus:

```text
symplectic module  -> compatibility/commutation;
central extension -> phase accumulated by compatible products;
overlap incidence -> whether local phases admit one global valuation.
```

None of the three alone is contextuality.

For odd `p`, the same construction uses `V=F_p^(2n)`, a primitive `p`th root
`zeta`, and

```text
W(a,b)W(a',b')=zeta^(b dot a')W(a+a',b+b').             (15)
```

When `2` is invertible one can use the symmetric Weyl section with the
half-symplectic phase. Characteristic two is exceptional: no division by two
removes the quadratic refinement, and central signs of commuting Hermitian
lifts become especially visible. Peres--Mermin exploits exactly this two-torsion
geometry.

## One universe, no flattening

All observables, contexts, and transition unitaries live in the single algebra
`M_4(C)`. Each isotropic context generates an exact commutative Boolean chart.
The charts overlap inside that one algebra. Equation (14) says their local
points have empty global limit: there is no multiplicative `±1` valuation
compatible with every overlap.

Univalent transport may identify unitarily equivalent presentations by paths
and carry the entire diagram, cocycle, and obstruction coherently. It cannot
turn the empty solution type of (13) into an inhabitant. The coherent whole is
one precisely because incompatible classical charts remain articulated inside
one noncommutative algebra; “one universe” does not mean a single global
Boolean coordinate system.

## Small executable certificate

The theorem needs only exact signed Pauli multiplication. Represent each
observable by `(a,b,k)` meaning `i^k X^a Z^b`; multiply by

```text
(a,b,k)*(a',b',k')
  = (a+a', b+b', k+k'+2(b dot a')) mod 4.              (16)
```

Initialize the Hermitian lift with `k=q(a,b)`. Equations (9)--(11) and the
inconsistency of (13) then require no floating-point matrices.

The exact jewel is not the square as a diagram. It is the cocycle class whose
local restrictions permit commuting Boolean multiplication while its global
incidence parity forbids classical flattening.

— Madhavi
