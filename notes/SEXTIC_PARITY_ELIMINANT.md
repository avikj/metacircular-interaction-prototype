# The checked sextic parity eliminant

The exact algebraic spine of `SEXTIC_OBSTRUCTION.md` now has a small safe
Agda certificate. It is not a replacement for that note's finite
computer-assisted exclusion.

## Exact surface

Over an arbitrary commutative ring, put

```text
g(x) = x^6 + a x^5 + b x^4 + c x^3 + d x^2 + e x + 1
E(y) = y^3 + b y^2 + d y + 1
O(y) = a y^2 + c y + e.
```

`SexticParityEliminant` checks the two parity presentations

```text
E(x^2) + x O(x^2) = g(x)
E(x^2) - x O(x^2) = g(-x)
```

and hence the reflection norm

```text
g(x) g(-x) = E(x^2)^2 - x^2 O(x^2)^2.
```

The leaf then defines the actual coefficient-ordered Sylvester matrix

```text
[ 1  b  d  1  0 ]
[ 0  1  b  d  1 ]
[ a  c  e  0  0 ]
[ 0  a  c  e  0 ]
[ 0  0  a  c  e ]
```

by explicit Laplace determinants. Its determinant is proved equal to the
sample's thirteen-term polynomial

```text
D = a^3 - 2a^2be - a^2cd + a^2d^2e + ab^2e^2 + abc^2
    - abcde + 3ace - 2ade^2 - bce^2 - c^3 + c^2de + e^3.
```

This pins the coefficient order and every sign without trusting a printed
expansion.

## Root presentation without root extraction

For supplied ring elements `y₁,y₂`, the checked identity

```text
O(a,-a(y₁+y₂),a y₁y₂;y) = a(y-y₁)(y-y₂)
```

makes the hypothesis explicit. Under exactly those substituted coefficients,
Agda proves

```text
a^3 E(y₁) E(y₂)
  = D(a,b,-a(y₁+y₂),d,a y₁y₂).
```

No inverse for `a`, choice of roots, algebraic closure, or field hypothesis is
used. The identity remains valid when the displayed quadratic degenerates.
The control `a=b=d=e=0, c=1` makes the determinant and `D` both equal `-1`,
so a silent sign or row-order transcription cannot pass merely because all
generic terms vanished.

## Prior art and exact boundary

`ParityNormEliminant.agda` already proves the degree-independent reflection
norm and the quartic/quintic determinant identities. It does not contain the
sextic coefficient split, the explicit 5-by-5 determinant, the thirteen-term
formula, or this root presentation. The new leaf is that bounded adapter, not
a new theory of resultants.

The sampled `SEXTIC_OBSTRUCTION.md` goes much farther. Its claims about a
golden-ratio root annulus, real-root count, coefficient box, irreducibility
census, Routh or Sturm calculations, resultant-tail inequalities, cyclotomic
closure, and absence of irreducible sextic factors are **not** certified by
this leaf. The retired Python certificate was inspected only as provenance;
it was not executed or translated wholesale. No numeric count or margin is
promoted to kernel evidence here.

Likewise, the algebra says nothing about NaturalMachine observations,
compression, physical processes, or Huayan/Indra's Net. It is a local exact
identity over a commutative ring.

## Draw 21 provenance

The encounter froze origin commit
`95190168302e54cfef9059f9292efd7a723c84fd`, tree
`81639342ae37a95745d5ccef09bd43d1b44d801d`. The full immutable random frame,
raw value, selected blob, verification, and hostile review will be recorded
in the result message after the leaf is cold-checked.

No aggregate or sampled-source edit belongs to this workset.
