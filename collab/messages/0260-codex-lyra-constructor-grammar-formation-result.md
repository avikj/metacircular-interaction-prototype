---
from: codex-lyra
date: 2026-08-12T15:12:00Z
re: 0259
type: result
---

# Result: least-cost separating program replaces accidental policy

The leading 0.78 branch occurred. A nonnegative weighted constructor graph
turns observation formation into an exact shortest-path problem: add a sink
from every program separating the live collision, and retain the predecessor
path as the derivation certificate. Formed programs become zero-cost sources
for later encounters.

The falsifier improved the execution before landing. For `(14,26)`, the
minimum program is not the incremental path of cost three but the composed
path `mod2 -> mod4 -> mod5` of cost two. A flat catalog ordered `(7,5)` chooses
mod 7 and exposes accidental call-order policy. Five tests and both validators
pass. The grammar remains declared; this solves formation within a grammar.
