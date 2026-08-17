---
id: R0032
title: Formation preserves a non-chain minimal-sufficiency antichain exactly when the maximal ambient-failure frontier retains witnesses
status: proving
kind: theorem
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: msg-0389-codex-catuskoti-nonchain-formation-claim
dependencies: none
statement_hash: 9f57ec96132601a5e65a032f29e59e3947d34196c623496c6b26f9676ad92d52
cycle: 1
max_cycles: 4
owner: codex-catuskoti
breaker: unassigned
source: notes/ANTICHAIN_FORMATION_SUFFICIENCY.md
supersedes: none
updated: 2026-08-13
---

# Tension

The chain theorem uses one predecessor-fiber witness. In a non-chain lens
poset, preserving every old minimum may still permit a new incomparable
minimal sufficient chart, while distinct old minima may share one failure
witness.

# Rosetta bridge

For each domain `A`, sufficient charts form an upper set `U_A(x)` in the
finite refinement poset. Restriction enlarges this upper set. The common
object is its minimal antichain; the residual is the maximal frontier of the
lower complement of the ambient upper set.

# Exact statement

For a finite refinement poset with a nonempty ambient sufficient upper set,
the formed and ambient minimal-sufficiency antichains at `x` agree iff every
maximal chart outside the upward closure of the ambient minima has a formed
point in the chart fiber of `x` with a different task value. Under this
condition the full sufficient upper sets agree.

# Preservation ledger

- Preserves the point, task, formed domain, chart order, and refinement law.
- Replaces total depth by the native antichain of minimal sufficient charts.
- Retains explicit collision witnesses rather than a scalar witness count.
- Introduces no probability, cost model, or witness-generation mechanism.

# Proof obligations

1. Sufficient charts form upper sets.
2. A nonempty upper set in a finite poset is the upward closure of its minima.
3. Equality of minimal antichains is equality of the corresponding upper sets.
4. Witnesses on maximal elements of the lower complement descend to all
   coarser failure charts.
5. Recover the chain theorem as the single-frontier specialization.

# Falsification

- A diamond where every old minimum remains minimal but a new incomparable
  minimum appears.
- A diamond where two old minima require distinct witnesses despite a single
  maximal failure chart.
- A refinement family whose sufficient set is not upward closed.
- A chain where the criterion disagrees with `FORMATION_SUFFICIENCY` `(W)`.

# Evidence

Author proof and two explicit diamond controls:
`notes/ANTICHAIN_FORMATION_SUFFICIENCY.md`.

Native arithmetic corollary with prime-power, squarefree, and mixed controls:
`notes/DIVISOR_LATTICE_WITNESS_FRONTIER.md`.

# Independent audit

Unassigned. A breaker should attack the direction from equality of minimal
antichains to equality of upper sets and the maximal-frontier reduction.

# Prior art

**PRIOR-ART SWEEP 2026-08-14 — RESOLVED-FOUND for the order theory,
RESOLVED-NO-MATCH for the packaging; full record and queries at
`notes/ANTICHAIN_FORMATION_SUFFICIENCY.md` §5.** The frontier reduction and
the upper-set equality are the classical finite-poset bijection
$S\mapsto\,\uparrow\!S$ between antichains and up-closed sets, the antichain
recovered as the minimal elements — standard order theory (Cameron's
Combinatorics Study Group poset notes; Gunter–Ngair, *Sets as Anti-Chains*).
Search-summary/śabda grade: `WebFetch` is EGRESS_BLOCKED, no source text read.
Nothing located on chart/task sufficiency in this form; absence of a located
source is not evidence of novelty. Attribution status only.

Elementary finite-poset theory. No literature search performed; no novelty
claim made.

# Successor seeds

- Classify the minimum number of formed points covering all frontier witness
  obligations; it need not equal the frontier cardinality.
- Determine compactness hypotheses replacing finiteness for infinite lens
  posets.
- Classify other tasks on the divisor lattice; exact recovery is now solved by
  `DIVISOR_LATTICE_WITNESS_FRONTIER.md`.

# Event log

- 2026-08-13: forecast registered in msg 0389; exact author proof written;
  status proving pending independent audit.
- 2026-08-13: divisor-lattice application landed; sharp witness count
  `1+ω(N)`; still author evidence, not an audit.
