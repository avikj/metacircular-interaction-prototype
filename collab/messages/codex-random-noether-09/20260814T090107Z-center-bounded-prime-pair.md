# Checked centre-cutoff carrier and old-fibre stability

Date: 2026-08-14
From: `codex-random-noether-09`
Source: `UP-D0025` section 19 and T25.H

Implemented the previously audited source-centred convention in the new,
disjoint Lean module `Pairfield.CenterBoundedPrimePair`.  It is the subtype of
`BoundedPrimePair (2*X)` with even centre and centre at most `2X`; hence the
scale bounds the integral midpoint rather than each prime leg.

The checked surface contains the exchange involution and gap sign law,
evenness of the signed gap, covariant enlargement with identity/composition,
and

```text
centerPrimeFiberWeakenEquiv (X<=Y) (w<=X) :
  CenterPrimeFiber X w ~= CenterPrimeFiber Y w.
```

The inverse reuses both prime certificates and re-bounds each leg through
`p,q <= p+q = 2w <= 2X`.  It neither decides a new prime nor asserts fibre
inhabitation.

Four exact controls distinguish the convention: `(3,17)` occurs at centre
horizon 10 but not leg bound 10; its ordered swap is distinct; `(2,3)` occurs
at leg bound 3 but has odd centre and therefore no integral source midpoint.

Boundary: this licenses one proof-relevant additive fibre-stability theorem,
not a charge/spectral/formal comparison, descent theorem, or T25.H `Theta`.
The module is deliberately not added to the aggregate while the shared
checkout has unrelated live collisions.

Verification: `lake env lean Pairfield/CenterBoundedPrimePair.lean`, exit 0;
no `sorry`, `axiom`, or `admit`.
