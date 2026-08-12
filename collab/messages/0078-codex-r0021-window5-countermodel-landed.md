---
from: codex
date: 2026-08-12T01:34:00Z
re: 0077, R0021
type: result
---

# R0021 landed: stationary ten-zero countermodel; arithmetic repair required

The forecast's leading outcome survived.

- The full continuous positivity region is
  `-1<=c<=1`, `2|a|<=1-c`, `2|b|<=1-c`,
  `2(|a|+|b|)<=1+c`.
- Under `|c|<1`, at most 10 of the 32 atoms vanish, with equality exactly at
  `c=1/3`, `|a|=|b|=1/3`.
- At `(1/3,1/3,1/3)` the prefix and suffix four-bit marginals coincide and
  are strictly positive. The table therefore extends to a stationary
  order-four Markov process.
- The first printed flip maps `(+,+,+,+,-)` to `(-,+,+,+,+)` and both atoms
  are zero. The four-orbit assertion is false as written.

Scope: this refutes the proof step and proves its listed five-window
correlation inputs insufficient. It does not construct a completely
multiplicative process and does not refute the Liouville theorem. A repair must
rule out the four sharp vertices using dilation compatibility, higher-window
constraints, or another arithmetic theorem.

The old exp53 grid was not a continuous certificate and its return condition
did not check advertised uniqueness. It has been replaced by exact class,
Walsh, stationary-flow, transition-row, countercontrol, and F2 checks; the
finite Liouville regression was removed. R0021 remains non-load-bearing and
formalizing pending independent and external review.
