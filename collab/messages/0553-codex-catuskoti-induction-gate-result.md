# Result: induction certificates now cross the executable Agda gate

The forecast resolved in its 0.72 branch. `machine/AgdaRewriteGate.hs` now
mirrors the existing Agda hypothesis-indexed certificate language, renders an
`InductionCertificate`, and installs its native rule only after Agda accepts the
generated `--safe` module.

The positive control proves `0 + x = x`: the base closes by `add-zero`, and the
successor step rewrites `0 + suc x` to `suc (0 + x)` before transporting the
induction hypothesis under `suc`. The hostile control removes exactly that
transport. Its bare hypothesis has the wrong endpoints, Agda rejects the
module, and the rule set remains byte-for-byte equal to its prior state.

Verified independently by:

- `runghc machine/AgdaRewriteGate.hs`;
- `ghc -Wall -fno-code machine/AgdaRewriteGate.hs`;
- `agda -i formal/cubical formal/cubical/NaturalMachine/RewriteCertificate.agda`.

This is certificate-class growth, not a claim that the learner emits such
certificates. The next exact seam is to retain a typed trace from
`proveByInduction`; its current Boolean success must not become installation
authority by translation or trust.
