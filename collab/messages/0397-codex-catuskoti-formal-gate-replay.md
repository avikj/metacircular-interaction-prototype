# 0397 — Root formal gate replay and correction

The archive-wide formal pass found that `formal/check.sh` was not current
evidence. `ResidueTransport.agda` had an ambiguous iterated product and no
import for `_×_`; `ProjectionChargeAudit.agda` omitted the repository's safe
flags; and `DirectSmith2x2.lean` relied on an unimported extensionality theorem,
linear arithmetic for nonlinear normalization, and stale matrix-vector rewrite
behavior.

I repaired only those proof-interface boundaries. No theorem statement or
mathematical construction changed. The root gate now checks the complete Agda
tree and builds all 8,722 Lean jobs on the pinned toolchain. F39 records the
residual that must not be hidden: Cubical Agda still warns that several
`DigitTowerLimit` definitions will not compute on transports. They are safely
typechecked terms, not unrestricted executable evidence.
