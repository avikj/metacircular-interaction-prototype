---
id: R0047
title: Finite observable closure is stabilization to future equivalence
status: proving
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0522-codex-formation-finite-observable-horizon-claim
dependencies: R0045
statement_hash: 2f0507b2684eaae73127ac3d8fac7256419a26d5dcb59cec3f06c0acf081b7bc
cycle: 1
max_cycles: 4
owner: codex-formation
breaker: unassigned
source: notes/OBSERVABLE_HORIZON.md
supersedes: none
updated: 2026-08-14
---

# Tension

R0045 proves the local one-action prefix law, but does not yet identify what
finite closure means for a generated action monoid or give a uniform finite
bound.  Exhaustive word layers are executable but hide the semantic event.

# Rosetta bridge

The kernel of the response map on all words of length at most `n` is a finite
observable equivalence.  It admits every one-step action exactly when that
bounded kernel has already stabilized to complete future equivalence.  A
shortest distinguishing word is therefore both the obstruction to closure at
every smaller depth and the forced next experimental coordinate.

# Exact statement

For any observed action system, agreement on all words of length at most n is action-stable iff it already implies complete future equivalence. For every finite Boolean DFA with k states this stabilization holds at n=k squared. In the three-state witness system the least stable horizon is exactly one.

# Preservation ledger

- Uses only the supplied transition and observation, with words as admitted
  future continuations.
- Separates semantic stabilization from the cost of an implementation that
  discovers the relevant pair states.
- Claims the safe pair-cardinality bound, not the sharper number of reachable
  or distinguishable pairs.
- Treats a shorter returned witness as an obstruction at all smaller horizons.

# Proof obligations

1. Prove action-stability of bounded equality iff bounded equality implies
   complete future equivalence.
2. Turn every longer separating word into a closure obstruction.
3. Deduce the `card(X)^2` bound from the checked pair-monitor shortening
   theorem.
4. Check a finite system whose least stable horizon is exactly one.

# Falsification

- Exhibit an action-stable bounded kernel that is not a future congruence.
- Break the induction that propagates bounded equality through a word.
- Exhibit a finite Boolean DFA requiring a separator of length at least
  `card(X)^2`.
- Find a depth-zero closure or a depth-one failure in the declared control.

# Evidence

Forecast registered in message 0522 before the checked construction.
`formal/pairfield/Pairfield/ObservableHorizon.lean` discharges all four proof
obligations.  Both the leaf build and the 8,745-job `Pairfield` root build exit
zero.  The proof and exact scope are recorded in `notes/OBSERVABLE_HORIZON.md`
and broadcast in message 0524.

The checked continuation `Pairfield.VisitedPairHorizon` consumes the completed
visited-state traversal on the synchronous pair monitor.  It retains the
actual reachable-pair count, proves the terminal frontier empty, and decides
future equivalence by searching valid replay nodes.  The concurrent
`VisitedPair` return proves global shortestness and preserves the full
derivation fibre; `ObservableVisitedPairAdapter` proves executable no-witness
is equivalent to semantic closure.  Message 0526 broadcasts the joined event.

# Independent audit

Unassigned.

# Prior art

Moore/Nerode equivalence refinement, partition stabilization, and the
`|X|^2` product-automaton bound are standard.  The contribution under test is
their exact placement as an observable-formation event following R0044/R0045;
no novelty is claimed.

# Successor seeds

- Replace the semantic `|X|^2` bound by an executable visited-pair bound with
  a checked empty-frontier certificate.
- Retain one shortest collision witness for every failed earlier horizon.
- Quotient the pair monitor by symmetry and prove when the smaller triangular
  bound is sound.

# Event log

- 2026-08-14: forecast registered; checked proof in progress.
- 2026-08-14: all obligations checked; status `proving` pending independent
  hostile audit.
- 2026-08-14: executable visited-pair compiler checked; global aggregation of
  all pair horizons remains the successor.
