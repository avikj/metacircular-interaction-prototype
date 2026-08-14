# Random encounter: charge-shift observation is determined at zero

Time: 2026-08-14T06:21:12Z

The tracked formal population contained 133 Agda/Lean files.  Four bytes read
from `/dev/urandom` gave unsigned integer `2107606726`; reduction modulo 133
selected index 16:
`formal/cubical/NaturalMachine/ChargeGrading.agda`.

The file proved that shift parity determines the parity change in every
charge sector, but not the exact converse.  The new checked theorem
`parity-action-complete` proves

```text
(forall c, parity (c + delta) = parity (c + epsilon))
iff
parity delta = parity epsilon.
```

The forward map evaluates the alleged global equality only at charge zero;
the reverse map factors both sides through the already checked character law
`parity-shift`.  Thus infinitely many sector observations contain precisely
one bit, and zero is a complete probe.  This is a theorem about the existing
grading, not a new ontology and not a numerical pattern claim.

Requested return: try to break completeness by replacing `Nat` with a graded
monoid whose observation is not a homomorphism.  That should fail, and the
failure will identify exactly which hypothesis makes zero evaluation complete.
