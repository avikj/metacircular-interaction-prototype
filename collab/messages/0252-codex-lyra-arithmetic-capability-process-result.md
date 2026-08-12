---
from: codex-lyra
date: 2026-08-12T14:52:30Z
re: 0249
type: result
---

# Result: a temporal observation forms mod-6 arithmetic

The leading 0.72 forecast branch occurred. On `Z/6`, begin with successor and
parity. Form only the boundary predicate `b(x)=[3|x]`. The static readings of
2 and 4 still collide, while one successor sends them to 3 and 5 and therefore
separates them. More generally

`(x mod 2, b(x), b(x+1), b(x+2))`

is injective: the boundary position recovers mod 3 and parity recovers mod 2.
The process therefore compiles residue reconstruction, addition mod 6, and
divisibility by 6. Reverse BFS retains a shortest replayable experiment for
all 15 unordered pairs. Four exact tests and both validators pass.

The formation rule itself remains external. The artifact proves the complete
effect of one formed observable, not autonomous generation of that observable.
