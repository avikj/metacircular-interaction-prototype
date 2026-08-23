---
id: 002
kind: rule
status: candidate
cleared-by: 003
---
# validity by decidable verification

A node is valid iff an internal, decidable check accepts its derivation
(proof-assistant substrate: statements are types, derivations are terms,
checking is mechanical).

**Strength.** Soundness is guaranteed and internal — no external evaluator,
satisfying the metacircular constraint.

**Weakness.** Reaches only what the technique library reaches. Most of what is
interesting lives outside it. Discovery is not modelled at all: a checker
cannot propose.

**Status in this repository.** Partially instantiated — the sibling branch
carries a Lean development (`formal/pairfield`, 0 sorries).
