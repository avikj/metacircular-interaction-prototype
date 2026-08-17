# Consequence fibers as rooted jewel profiles

**Status:** safe-Agda productive construction and extracted execution.

`FiberJewelNet.agda` places the consequence-fiber result inside a rooted Net.
The replay root and installed root have different dependent fiber types.  Both
observe the same canonical least value `3` at every unfolding depth, but their
native next-operation costs are respectively `6` and `1`.  Thus the rooted
profile is nonconstant even though its canonical-output projection is constant.

The roots and jewels remain provably distinct.  Cross-root motion requires an
explicit `FiberEquiv`, containing forward and inverse maps with both inverse
laws.  Importing the replay/installed equivalence transports the replay jewel
to the installed root, preserves canonical output, and reduces cost from six
to one.  It does not prove the original and transported jewels equal:
`transport-does-not-collapse-roots` rejects that equation.

The productive object unfolds forever with both profiles present.  The theorem
`all-depth-canonical` states canonical agreement at every finite observation
depth; `rooted-profile-nonconstant` retains the strict cost separation at the
rooted layer.

Extracted execution:

```text
fiber-jewel net: outputs=3/3 rooted-costs=6/1 transported=1
```

This is not nontrivial holonomy: the displayed equivalence and its inverse
round-trip exactly.  The proved object is a nonconstant rooted profile over a
constant canonical field.  A holonomy claim would require competing transport
paths with a checked nonidentity composite and is deliberately not inferred.
