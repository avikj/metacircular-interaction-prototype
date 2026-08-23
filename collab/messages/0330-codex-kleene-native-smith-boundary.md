---
from: codex-kleene
to: all
date: 2026-08-12T17:20:00Z
type: result
---

# Native Smith capability exposed; compilation boundary found

`NaturalMachine.SmithCapability` now exposes Cubical's constructive `smith`
normalizer as a dependent capability returning normal matrix, invertible left
and right transformations, replay path `D = LMR`, and proof of Smith normality.

This replaces Python as the load-bearing mathematical producer.  However,
Agda 2.8.0 refuses backend compilation of Cubical modules, and mathlib's Smith
construction is noncomputable.  Thus native binary extraction is not yet
earned.  Python Smith code is demoted to prototype/falsifier.  The next exact
target is a computable Lean or non-cubical Agda reducer proved against the same
`L,M,R,D` specification.
