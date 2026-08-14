# Smith fibres are exact coherent memory; Smith coordinates carry alignment

**Status:** exact standard correspondence and finite no-go, author-proved;
independent audit unassigned.  The arithmetic input is
`ARITHMETIC_LIFE_WITNESSED_SMITH_TRANSPORT.md`; the process input is
`CERTIFICATE_FIBRATION.md` and R0072.  No novelty is claimed.

## 1. The map being priced

Let `R=Z/mZ`, and let `A:R^2 -> R^2` be induced by an integer matrix.  Suppose
an exact Smith certificate supplies unimodular integer matrices `U,V` with

```text
U A V = D = diag(d1,d2).
```

The process in this note is the basis-state map

```text
z |-> A z.
```

It is not the algorithm from matrix descriptions to a Smith certificate, and
it is not the constant map from all solutions of `Az=b` to one symbolic coset
description.  Those maps have different sources and fibres.  R0072 showed
that this typing distinction can change a memory price from 10 to 60.

## 2. Exact kernel formula

**Theorem 2.1.** Every occupied fibre of `A` is a torsor for `ker A`, and

```text
|ker A| = gcd(d1,m) gcd(d2,m).
```

**Proof.** If `Az=b` has one solution `z0`, translation by `z0` is a bijection
from `ker A` to the fibre over `b`.  Since `U` and `V` are invertible modulo
`m`, they preserve kernels and fibres, and `z=Vw` changes `Az=b` into
`Dw=Ub`.

For one diagonal coordinate, put `g=gcd(d,m)`, `d=g d'`, and `m=g m'` with
`gcd(d',m')=1`.  Then

```text
d x = 0 mod m  iff  m' divides x mod m.
```

The solutions are exactly `x=alpha m'`, with `alpha mod g`, so the scalar
kernel has `g` elements.  The two diagonal coordinates are independent and
their sizes multiply.  ∎

**Corollary 2.2 (coherent boundary).** Any exact coherent basis-state
realization of `z |-> Az` needs environment Hilbert dimension at least

```text
gcd(d1,m) gcd(d2,m),
```

and a Smith solution coordinate attains it.

**Reason.** Inputs in one fibre have the same declared output and must acquire
mutually orthogonal environment records.  Conversely, solve `Dw=Ub`, choose
the supplied diagonal representative, record the two kernel residues
`(alpha1,alpha2)`, and reconstruct with `z=Vw`.  The recorded output and this
coordinate recover the input.  This is exactly `CertificateFibration`'s
fibre-embedding lower bound and trivialisation upper bound.

This is a memory/dimension statement.  It says nothing about the gate count,
time, energy, or difficulty of finding the Smith certificate.

## 3. Controls from the live arithmetic return

### 3.1 Unit determinant

If `gcd(det A,m)=1`, then each Smith factor is coprime to `m`; the formula is
`1*1=1`.  The map is already a permutation of the basis, so no nontrivial
environment is required.  This recovers arithmetic life's unit-determinant
branch as the zero-garbage process branch.

### 3.2 The supplied non-diagonal certificate

For

```text
A = [[2,4],[6,8]],  m=30,
U = [[1,0],[3,-1]],  V = [[1,-2],[0,1]],
U A V = diag(2,4),
```

the exact dimension is

```text
gcd(2,30) gcd(4,30) = 2*2 = 4.
```

The diagonal generators are `(15,0)` and `(0,15)`.  In this particular
certificate `V(15,0)=(15,0)` and `V(0,15)=(0,15)` modulo 30, so the alignment
residual happens to be trivial.  This is an important negative control: the
theorem below says an alignment map must be carried, not that it must always
be nonidentity.

## 4. Dimension is not a coordinate

The invariant factors determine the kernel *type and size*.  They do not by
themselves select a labelled trivialisation of every fibre.

**Proposition 4.1 (two elimination orders).** Consider the compatible system

```text
2x=b1,  2y=b2  mod 30.
```

After choosing one solution `(x0,y0)`, every solution is uniquely

```text
(x0,y0) + (15 epsilon_x, 15 epsilon_y),
epsilon_x,epsilon_y in Z/2.
```

Solving `x` then `y` records `(epsilon_x,epsilon_y)`.  Solving `y` then `x`
records `(epsilon_y,epsilon_x)`.  Both are exact four-state environments for
the same retained map, and their transition is

```text
S(epsilon_x,epsilon_y) = (epsilon_y,epsilon_x).
```

The map `S` is involutive and nonidentity; for example
`S(0,1)=(1,0)`.  Thus equality of endpoint solution sets and equality of
minimum dimensions do not imply literal equality of certificate coordinates.
∎

The same fact can be read as Smith-certificate gauge.  For `A=2I`, both
`(U,V)=(I,I)` and `(U,V)=(S,S)` satisfy `UAV=2I`, with `S` the coordinate
swap.  They certify the same diagonal and choose different labelled kernel
coordinates.  Variable labels or an explicit transition map remove the
ambiguity; the invariant factors alone do not.

## 5. Checked finite content

`NaturalMachine.SmithKernelQuantumBoundary` represents the four-element
kernel by `Bool x Bool` and checks, in safe Cubical Agda:

1. every exact environment for the solved-state projection contains an
   embedding of `Bool x Bool`;
2. the `(epsilon_x,epsilon_y)` coordinate attains the bound;
3. the reversed `(epsilon_y,epsilon_x)` coordinate also attains it;
4. the two coordinates are related by an involutive swap and are not equal;
5. the singleton-kernel/unit-determinant control needs and attains `Unit`.

The module deliberately does not pretend to be a formal integer Smith-normal-
form development.  The general gcd calculation is the elementary proof in
Section 2; the formal artifact pins the exact process seam and its smallest
nontrivial alignment residual.

## 6. What changes next

The correct comparison object for two modular elimination routes is now

```text
(common Smith kernel, route trivialisation, transition automorphism).
```

Therefore:

- do not multiply sequential scalar memory prices without identifying their
  joint kernel;
- do not infer reversible compatibility from equal solution sets or equal
  fibre counts;
- retain `V` (or the induced kernel-coordinate map) when reconstruction is
  promised;
- compare two routes by the explicit automorphism between their kernel
  coordinates; nontrivial composites around route loops are the honest
  holonomy question.

The immediate successor is not another cardinality calculation.  It is to
compose three lawful Smith/elimination charts and decide whether their
pairwise transition automorphisms satisfy the cocycle law definitionally,
only propositionally, or leave a nontrivial loop automorphism.

