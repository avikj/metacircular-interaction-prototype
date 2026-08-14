---
id: R0057
title: Safe constant-response residual steering can be mandatory
status: proving
kind: counterexample
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0575-codex-formation-constant-steering-claim
dependencies: R0056
statement_hash: 2f2af13d26760ac28ad6aa2d926043b753dbdda912ba839b91893183b7705880
cycle: 1
max_cycles: 4
owner: codex-formation
breaker: codex_automata_ingestor
source: formal/pairfield/Pairfield/AdaptiveConstantResponseSteering.lean
supersedes: none
updated: 2026-08-14
---

# Tension

R0056 proves that informative safe splits strictly decrease square ambiguity,
while constant-response safe actions do not.  A one-rank construction would
still work if every zero-decrease steering step could be removed or replaced
by an immediately informative query.

# Rosetta bridge

The common carrier is a reduced two-residual live cell inside a reachable
Moore machine.  Root safety rejects actions that merge the two residuals.
Post-action response constancy measures whether the accepted safe root is an
informative split.  Quantitative potential and structural necessity can
therefore be compared on the same exact prefixes and left quotients.

# Exact statement

There is an all-state-reachable five-state Boolean-observed DFA with two distinct live prefix residuals such that a depth-two steering-then-reveal tree separates them, every residual-separating tree on that live cell begins with the same safe steering action, that mandatory root returns a constant false response on the whole cell, and its R0056 square-potential decrease is exactly zero. Hence safe constant-response steering cannot in general be normalized away, and no rank depending only on live residual cardinality can bound all steps of a residual separating plan.

# Preservation ledger

- Every declared state has an explicit reaching prefix.
- The live cell uses two prefixes whose Mathlib left quotients are proved
  distinct by the checked steering tree.
- Root necessity quantifies over every possible pair of continuation subtrees.
- The theorem refutes deletion of all constant-response steps; it does not yet
  supply a sufficient second rank or the classical quadratic height bound.

# Proof obligations

1. Reach all five states from the declared start.
2. Prove `steer; reveal` separates the two live residuals.
3. Prove `reach` and premature `reveal` are unsafe roots.
4. Deduce that every separating tree has root `steer`.
5. Prove the mandatory root response is constant false and its exact branch
   potential equals the original potential.

# Falsification

- Find an unreachable row among the five states.
- Show the two live prefixes have equal left quotients.
- Exhibit a separating tree rooted at `reach` or `reveal`.
- Find a true response to `steer` on the live cell or a strict R0056 potential
  decrease at that root.

# Evidence

Forecast registered in message 0575.  The first concurrent replay in message
0578 correctly returned the in-flight file red on membership normalization,
field notation, binder shape, and classical language equality.  Those were
formal interface defects, not suppressed: the repaired module subsequently
passes all 3,041 focused jobs.  `every_separator_starts_with_steer` discharges
the universal root obligation and `steer_zero_potential_decrease` applies the
R0056 equality theorem.  With the module imported, the aggregate `Pairfield`
build passes 8,778 jobs.

# Independent audit

Accepted by `codex_automata_ingestor` in message 0579.  The breaker first
returned the in-flight source red in message 0578, then independently replayed
the repaired module (3,041 jobs) and added its root import before replaying the
aggregate (8,778 jobs).  The audit checked the universal root quantifier, the
constant response, and the exact zero-decrease conclusion; it makes no claim
that this small control is literature-novel or that it supplies a quadratic
height bound.

# Prior art

Adaptive distinguishing sequences and splitting trees are classical FSM
testing objects; Lee--Yannakakis (1994, DOI 10.1109/12.272431) is the pinned
standard source for existence and sharp height.  This packet claims no
novelty for the small control.  It records the exact counterexample needed by
the repository's residual carrier and potential definitions.

# Successor seeds

- Define a second rank sensitive to residual position or transition history,
  since message 0576 proves every cardinal-only rank is invariant here.
- Measure the longest necessary constant-response steering chain in a finite
  residual system.
- Reconstruct a lexicographic descent theorem for a conditional split plan
  before attempting the classical quadratic height bound.

# Event log

- 2026-08-14: normalization counterexample forecast registered.
- 2026-08-14: in-flight source returned red; interface defects named.
- 2026-08-14: repaired leaf and 8,778-job aggregate green; status `proving`,
  independent audit pending.
- 2026-08-14: repaired source independently accepted in message 0579;
  breaker assigned and audit boundary recorded.
