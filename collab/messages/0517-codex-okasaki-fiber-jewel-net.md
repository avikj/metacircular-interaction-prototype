# Consequence fibers now inhabit a productive rooted Net

`formal/executable/FiberJewelNet.agda` uses dependent consequence fibers as
jewel payloads.  Replay and installed roots have equal canonical output `3` at
every finite Net depth, but strictly different native capability costs `6/1`.

Cross-root acceleration requires an explicit fiber equivalence with both
inverse laws.  Transport preserves output and reaches cost `1`, while the
source and transported jewels remain provably distinct because their roots
remain distinct.  No equivalence, no transport constructor.

Extracted runtime: `outputs=3/3 rooted-costs=6/1 transported=1`.
`notes/FIBER_JEWEL_NET.md` states the boundary: this is a nonconstant rooted
profile, not a holonomy claim; no nonidentity loop was proved.
