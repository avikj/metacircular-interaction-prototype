---
id: R0049
title: Uniform and adaptive observable horizons can differ
status: seed
kind: counterexample
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0531-codex-formation-adaptive-gap-claim
dependencies: R0048
statement_hash: 1af2fb3e7c6aabd5c4196c31f94f6a9bf11163d55ca20850d8d087f7831da6ea
cycle: 1
max_cycles: 4
owner: codex-formation
breaker: unassigned
source: notes/OBSERVABLE_HORIZON.md
supersedes: none
updated: 2026-08-14
---

# Tension

R0048 computes the least depth of the parallel carrier containing every word
through that depth.  An adaptive experiment instead chooses one next action
from the responses already seen.  Treating those depths as one cost would
erase the policy constraint.

# Rosetta bridge

Use a finite response-dependent decision tree as the third object.  Its trace
includes the current observation and then one observation per chosen action.
Injectivity of that trace is exact state identification.

# Exact statement

There exists a four-state Boolean-action Boolean-observation system whose least uniform observable horizon is one but whose least adaptive identification-tree depth is two. Hence uniform response-window depth and adaptive experiment depth are distinct cost coordinates.

# Preservation ledger

- Uses the R0048 uniform horizon unchanged.
- Counts only actions; the current observation is available at depth zero.
- Requires one policy tree to identify every state, with branching only on
  observations actually returned.
- Proves both impossibility at depth one and a concrete depth-two tree.

# Proof obligations

1. Define finite Boolean response-dependent experiment trees and their traces.
2. Exhibit the four-state system and check its R0048 horizon is one.
3. Prove every tree of depth at most one has a collision.
4. Check a depth-two tree with injective traces.

# Falsification

- Find a depth-one adaptive tree identifying the four states.
- Find a collision in the declared depth-two tree.
- Show the uniform global horizon is zero or at least two.
- Show the trace branches on information not yet observed.

# Evidence

Forecast registered in message 0531 before the checked construction.

# Independent audit

Unassigned.

# Prior art

Adaptive distinguishing sequences, preset distinguishing sequences, and
Moore-machine testing are classical.  No novelty is claimed.

# Successor seeds

- Bound adaptive depth in terms of the number of future-equivalence classes.
- Characterize when adaptive depth equals the uniform horizon.
- Replace exact state identification by identification of the future quotient.

# Event log

- 2026-08-14: forecast registered; checked counterexample in progress.
