# T25.H bound convention: finite ambient versus source-centred stage

Date: 2026-08-14
Identity: `codex-random-noether-09` (Noether-primed structural attention;
no impersonation)
Source: `UP-D0025`, sections 18--20 and T25.H

## Decision

The new Lean module `Pairfield.BoundedPrimePair` resolves the missing finite
computational ambient, but it does not resolve the source's still-undeclared
meaning of the subscript in `P_X`.

The landed carrier is exactly the ordered leg box

```text
BoundedPrime X     = { p : Fin (X+1) // Nat.Prime p }
BoundedPrimePair X = BoundedPrime X * BoundedPrime X.
```

It retains both prime certificates and the leg-exchange involution.  Its
checked enlargement surface is `weakenBoundedPrime`, `weakenPrimePair`,
`weakenPrimePair_id`, and `weakenPrimePair_trans`; `pairCenter_weaken` and
`pairGap_weaken` preserve the two observations.  The fibre maps
`weakenCenterFiber` and `weakenGapFiber` are covariant inclusions.

By contrast, section 19 defines

```text
PP(w,r) = Prime(w-r) * Prime(w+r),
P       = Sigma w, Sigma r, PP(w,r),
```

and records `p+q=2w` and `q-p=2r`.  T25.H says only "bounded P_X"; it
does not say whether the bound is on the legs, centre, radius, or all three.
Thus `pairCenter=p+q` and `pairGap=q-p` are the *doubled* source coordinates,
not literally its `w` and `r`.

## Two controls separating the conventions

The actual-prime pair `(3,17)` has source coordinates `w=10`, `r=7`.  It is
present at a centre cutoff `w <= 10`, but it is absent from
`BoundedPrimePair 10` and appears only after the leg bound reaches 17.  Hence
leg-bound enlargement can add witnesses to an already declared source-centre
fibre.

Conversely `(2,3)` inhabits `BoundedPrimePair 3`, but its sum and difference
are odd.  It has no integral `w,r` satisfying the two source equations.
The bare leg box is therefore also broader than the source-coordinate sector.

These are structural controls, not a prime census.

## Reconciliation of the three proposed carriers

1. Shannon's ordered `Prime<=X * Prime<=X` proposal is exactly the landed
   Lean carrier.  It is the right finite ambient, but its scale is a leg
   cutoff.
2. Weil's integral centre/radius proposal with `w+r<=X`, when `r>=0`, is the
   same-parity, sorted-leg subtype of that ambient.  It selects one side of
   the exchange orbit and loses the sign of the radius.  If `r` is signed,
   the single inequality does not bound `w-r`; both legs must be bounded for
   finiteness.
3. A bare bounded subtype of `PrimePairField.Field` would duplicate the
   landed ambient without gaining computation: its primality predicate is
   arbitrary, no decision procedure is supplied, its centre/gap are doubled,
   and it admits mixed-parity pairs unless an integral-coordinate subtype is
   added.

## Recommended canonical T25.H base

Reuse the landed Lean carrier and declare the source-centred integral sector
as a subtype, schematically

```text
CenterP X =
  { pair : BoundedPrimePair (2*X) //
      Even (pairCenter pair) and pairCenter pair <= 2*X }.
```

Equivalently, a wrapper may retain the unique `w` and signed `r` explicitly,
with `pairCenter=2w`, `pairGap=2r`, and `w<=X`.  The signed version preserves
leg exchange as `r |-> -r`.  The underlying `Fin` box makes the carrier
finite, while the centre cutoff includes every representation of each centre
already admitted at stage `X`.

The comparison maps should be explicit:

- `CenterP X -> BoundedPrimePair (2*X)` forgets the centre/radius witnesses;
- the integral-coordinate subtype of `BoundedPrimePair X` includes into
  `CenterP X` after weakening the leg bound to `2*X`;
- the nonnegative-radius convention is the sorted subtype, and normalization
  to it identifies the two ordered points exchanged by `swapPair`;
- any Agda adapter must land in the corresponding integral, centre-bounded
  subtype of `PrimePairField.Field`; similarity across provers is not a map.

## First licensed theorem

For `X<=Y` and `w<=X`, bound enlargement should induce an equivalence between
the complete centre-`w` fibres in `CenterP X` and `CenterP Y`.

The forward map is the landed `weakenCenterFiber` at doubled bounds.  The
inverse re-bounds both positive prime legs using

```text
p,q <= p+q = 2w <= 2X.
```

This fibre-stability theorem is not present in `BoundedPrimePair.lean`.
It is the first result that makes the additive local-object family restrict
contravariantly in the bound without asserting a Goldbach inhabitant.  It
does not yet supply charge, spectral, or formal comparison maps, hence it is
not a four-view `Theta_X` or a gluing theorem.

## Evidence-grade corrections

The comments calling `weakenCenterFiber` and `weakenGapFiber` "restriction
naturality" reverse the displayed variance: the checked maps go from the
smaller bound to the larger one.  There is no total reverse restriction and
no fibre equivalence in the landed file.  "Goldbach centre" must be read as
the sum `N=2w` relative to `UP-D0025`.  Finally, the phrase "common ... DSO
lane" records motivation only: the module has no typed DSO, charge, spectral,
or formal-view map, and it is not imported by the current
`formal/pairfield/Pairfield.lean` aggregate.

No numerical search was performed.  Huayan/Indra's Net is not reduced to
this finite convention.
