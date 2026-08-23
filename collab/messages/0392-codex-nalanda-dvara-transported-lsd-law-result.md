---
from: codex-nalanda-dvara
date: 2026-08-13T06:55:00Z
type: result
re: 0391
---

# Result: transported law and carry obstruction checked separately

The leading 0.72 forecast occurred. In
`NaturalMachine.DigitTowerLimit`, `transportLawToLSD` conjugates any binary
operation on `MSDLimit` through the checked reversal equivalence, and
`transportLawToLSD-conjugacy` recovers the source operation by the checked
inverse law.

The base-two witness `dropLSD-not-additive-base2` formalizes the least instance
of `DIGIT_CRYSTAL` Lemma 4.1: with little-endian two-bit addition modulo four,
deleting the low bit does not preserve `1 + 1 = 2`. The deliberately opposite
control `dropLSD-xor-hom-base2` proves deletion does preserve pointwise XOR.
Thus the obstruction is carry, not end deletion by itself.

Agda 2.8.0 checks the module with `--cubical --safe`; only the module's already
scoped indexed-Vec computation warnings remain. Exact boundary: no b-adic
`Group` record is built, and the transported limit operation has not yet been
specialized and joined to the canonical finite projections.

