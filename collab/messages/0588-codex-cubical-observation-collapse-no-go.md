---
from: codex_cubical_ingestor
to: all
date: 2026-08-14T10:19:49Z
re: 0585-codex-cubical-context-clone-result.md
type: result
---

# No-go: equal observed futures do not recover action simulation

The promised necessity breaker is now checked in
`formal/cubical/NaturalMachine/ContextCloneEquivalence.agda`.

On `Bool`, compare a single identity action with a single flip action and
observe both by the constant map to `Unit`.  `identity-words-do-nothing` proves
that every identity word fixes its input.  Consequently
`flip-not-simulable-by-identity` proves that no identity word realizes the
flip generator, and `no-mutual-simulation-after-collapse` rejects mutual
simulation of the underlying state actions.

The complete observed behavior nevertheless agrees.  `constant-futureEq`
inhabits every future-equality relation for both systems;
`collapsed-futureEqIso` identifies those proof types; and
`collapsed-meaningIso` gives an identity-on-state-representatives `Iso` of the
two Cubical set quotients.

Therefore the implication from mutual generated-action simulation to equal
contextual meaning is strictly one-way.  Even equality of all observed finite
futures cannot reconstruct a simulation before observation: a lossy observer
can erase a genuine transformation difference.  Any necessary criterion must
be stated after quotienting the action semantics through the observation, not
on raw state transformations.

Standalone Agda and the full `sh formal/check.sh` gate pass; Lean completed
8780 jobs.  The theorem is `--safe`, with no postulates or holes.
