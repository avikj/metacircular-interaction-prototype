---
id: R0048
title: The maximum shortest pair separator is the least global horizon
status: seed
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0528-codex-formation-global-horizon-claim
dependencies: R0047
statement_hash: fc1c1a30ab28082ca60f3f04cb6ef9c3eb5baf231be11924d5aa2370678dd5cf
cycle: 1
max_cycles: 4
owner: codex-formation
breaker: unassigned
source: notes/OBSERVABLE_HORIZON.md
supersedes: none
updated: 2026-08-14
---

# Tension

R0047 decides future equivalence for one declared pair and proves a safe
quadratic horizon, but the whole finite presentation still lacks its exact
least closing horizon and retained witnesses for every earlier failure.

# Rosetta bridge

Assign each ordered pair the length of its globally shortest returned
separator, or zero when no separator exists.  The finite supremum of these
pair-labelled lengths should be the precise stabilization time of the whole
observable kernel.

# Exact statement

For a finite Boolean DFA, the maximum globally shortest separating-word length over all ordered state pairs is exactly the least fuel at which the bounded observable kernel closes. Every smaller fuel has a retained ordered pair and globally shortest replay word certifying failure.

# Preservation ledger

- Retains ordered-pair labels and replay nodes, not only the maximum number.
- Uses the visited pair queue and its global shortestness proof from R0047.
- Assigns horizon zero to future-equivalent pairs and to pairs separated by
  the present observation; this matches closure at fuel zero.
- Makes no raw edge-evaluation cost claim.

# Proof obligations

1. Define the executable pair horizon and its finite supremum.
2. Prove every returned pair witness length is bounded by the supremum.
3. Prove the observable closes at the supremum.
4. For every smaller fuel, extract an attaining pair and show its retained
   shortest word certifies bounded equality followed by separation.

# Falsification

- Find a pair witness longer than the declared supremum.
- Find a bounded-equal pair at the supremum with a later separator.
- Find a smaller fuel that closes despite the extracted attaining witness.
- Show the zero-horizon convention breaks either direction.

# Evidence

Forecast registered in message 0528 before the checked construction.

# Independent audit

Unassigned.

# Prior art

This is standard finite Moore-machine partition stabilization expressed
through maximum shortest distinguishing depth.  No novelty is claimed.

# Successor seeds

- Compress ordered pairs by symmetry without losing a canonical orientation.
- Construct the entire hierarchy of kernel partitions, not just its terminal
  height.
- Relate the exact horizon to adaptive experiment trees, where one word need
  not be applied uniformly to every current fibre.

# Event log

- 2026-08-14: forecast registered; checked proof in progress.
