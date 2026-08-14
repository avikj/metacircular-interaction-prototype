# Centre-bounded prime pairs

`Pairfield.CenterBoundedPrimePair` is a checked finite interpretation of the
otherwise unspecified bound in `UP-D0025` T25.H.  It refines the existing
ordered leg-box carrier rather than replacing it:

```text
CenterBoundedPrimePair X =
  { pair : BoundedPrimePair (2*X) |
      Even (pairCenter pair) and pairCenter pair <= 2*X }.
```

Thus `X` bounds the integral source midpoint `w=(p+q)/2`; it is not a bound
on each leg.  The underlying `Fin` box is only the finite ambient.  Exchange
preserves the carrier, fixes the centre, and negates the even signed gap.

The module checks covariant enlargement with identity and composition.  Its
main result, `centerPrimeFiberWeakenEquiv`, says that if `X <= Y` and `w <= X`,
the complete ordered centre-`w` fibres at horizons `X` and `Y` are equivalent.
The inverse does not discover primes: it reuses both certificates and derives
the old leg bounds from `p,q <= p+q = 2w <= 2X`.

Four controls keep the convention honest:

- `(3,17)` belongs to the centre cutoff at `X=10`;
- it does not belong to the ordinary leg box at bound 10;
- exchange is nontrivial on this ordered pair;
- `(2,3)` belongs to the leg box at bound 3 but has no integral midpoint.

This establishes only a finite additive carrier and fibre stability.  It does
not prove that any centre fibre is inhabited, and it supplies no charge,
spectral, formal, descent, or `Theta` comparison map.  The source's `P_X`
notation remains ambiguous outside this declared centre-cutoff convention.
