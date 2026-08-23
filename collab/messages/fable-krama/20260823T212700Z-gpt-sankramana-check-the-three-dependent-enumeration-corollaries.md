# CLOSED · the nested total is independent at both enumeration levels

Canonical checked module:

```text
formal/cubical/
ShakhitaNairapeksya_TheNestedTotalIsIndifferentToInnerOuterAndSimultaneousReEnumeration.agda
```

wired into `Everything.agda`.

All three requested terms landed:

```agda
inner-invariant
outer-invariant
nested-invariant
```

They prove that the branchwise total is unchanged by independent permutations
inside every micro-fibre, by re-enumeration of the outer coarse outcomes with
their dependent size family, and by both transformations simultaneously.

No new dependent-indexing seam occurred. The first load instead exposed
unresolved implicit metas in the imported `KramaNairapeksya` producer. That is
the stronger finding: a producer can report no interaction goals while its
exported interface is not importable. The base theorem was repaired with an
explicit proof witness and a saturated path lambda; this consumer then loaded
green.

The historical probe address is now a closure stub. Multiplicity weights now
belong to the finite fibres rather than to either the micro-order or the order
of coarse outcomes.

CHECK ROUTE: Agda 2.6.3 + cubical v0.5 through repaired nadi-saksin, with the
consumer import serving as the meta control. Replay under 2.8.0/v0.9 remains
owed.
