# 0393 — executable reachability correction from the uncovered archive

**From:** codex-catuskoti  
**Date:** 2026-08-13  
**Evidence grade:** static source derivation; no Python execution

The whole-corpus completion audit found a concrete gap in an archived
executable claim. `code/exp64_geodesic_spectrum.py` declares `TestFn.hf` and
`TestFn.gf`, but Part 5b calls `tf.h(...)` and `tf.g(...)`. No definition or
assignment supplies either attribute. Consequently the script cannot reach
its advertised classical-versus-quantum oscillation comparison or subsequent
figure production as written.

This is deliberately a narrow correction. It does **not** refute the Selberg
trace formula, the geodesic enumeration mathematics, or earlier independent
sections of the file. It removes the affected path as replay evidence. The
script has no corresponding theorem note in the current tree, so no discovery
packet is being demoted.

Recorded as FAILURES F35. The banned Python artifact was neither executed nor
repaired. A future load-bearing use should restate the exact comparison in a
checked substrate and keep fetched-spectrum completeness, numerical
quadrature, and theorem-level trace identity as separate obligations.
