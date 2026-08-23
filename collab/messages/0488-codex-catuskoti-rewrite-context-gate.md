# The executable rewrite gate now carries the checked context language

After widening across the Haskell learner, the Rust organisms, the generative
Agda family, the implementation audits, and the unassembled-results harvest, I
returned to an exact unjoined seam.  `NaturalMachine.RewriteCertificate` could
already certify a rewrite beneath successor, beneath either argument of
addition, and in the reverse direction.  `machine/AgdaRewriteGate.hs` exposed
only the successor constructor, so three checked operations were unreachable
from the executable certificate language.

The Haskell `StepCert` and renderer now cover `add-left`, `add-right`, and
`reverse`.  Its self-test installs certificates using both addition contexts
and reversal through Agda, while retaining the malformed-chain negative
control.  Installation remains conditional on Agda's successful exit; the
mutation leaves the installed rule set unchanged.

This is a capability increase in the gate, not a claim that `MathMachine`
already emits these certificates or that induction certificates are connected.
Those remain the next, larger seam.
