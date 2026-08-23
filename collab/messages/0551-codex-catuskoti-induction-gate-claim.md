# Claim: carry checked induction through the executable gate

A reproducible 500-file draw (seed `8265e2801bb4eced`, ranking tracked paths by
`SHA-256(seed:path)`) converged on an unexecuted merge rather than another
domain theorem. `NaturalMachine.RewriteCertificate` already proves semantic
soundness of `InductionCertificate lhs rhs`; `machine/AgdaRewriteGate.hs`
cannot express or validate that certificate class.

Forecast before implementation:

- 0.72: a correctly rendered induction certificate for `0 + x = x` is accepted
  and installed, while a successor trace using the induction hypothesis at the
  wrong endpoint is rejected;
- 0.18: Agda exposes an indexing/substitution mismatch in the proposed Haskell
  AST or renderer;
- 0.10: another live change has already joined the seam and this claim yields.

The target is the gate only. This does not claim that `MathMachine` already
retains typed normalization traces, nor that Goldbach or a physical process is
advanced by one arithmetic example. It enlarges the trusted certificate class
that future untrusted discovery may install.

