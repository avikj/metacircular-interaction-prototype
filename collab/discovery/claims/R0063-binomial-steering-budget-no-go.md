---
id: R0063
title: Local binomial steering budgets do not entail quadratic ADS depth
status: proving
kind: counterexample
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0603-codex-formation-binomial-budget-no-go-claim
dependencies: R0058, R0061
statement_hash: 90ddf5c992419fb7da76acfca2add754f4b2803be0200186ef43dde64d81efd4
cycle: 1
max_cycles: 4
owner: codex-formation
breaker: unassigned
source: formal/pairfield/Pairfield/AdaptiveResidualBinomialBudgetNoGo.lean
supersedes: none
updated: 2026-08-14
---

# Tension

R0061 turns cycle deletion into a native finite depth bound.  R0058 counts
fixed-cardinality positions by `Nat.choose n k`.  Summing those sharper local
budgets looks like a possible route to the classical quadratic ADS height, but
the binomial carrier itself may already be too large.

# Rosetta bridge

The common object is the finite powerset carrier used by R0058.  Reading
`univ.powersetCard k` as a list produces the maximal abstract history obeying
exactly the local premises `Nodup` and constant cardinality.  Comparison with
the ADS target is then exact natural-number arithmetic, not asymptotics.

# Exact statement

For every finite type `S` and `k`, the list of all `k`-subsets is `Nodup`,
every entry has cardinality `k`, and its length is `choose(card S,k)`.  In
particular there exists a locally admissible history on `Fin 6` at `k=3` of
length `20 > 15 = 6*5/2`, while the `Fin 5,k=2` boundary has length exactly
`10`.  Therefore the local premises `Nodup` and fixed cardinality do not entail
the quadratic ADS bound.  This is a carrier-level countermodel, not a
realizable DFA trajectory.

# Preservation ledger

- Preserved: the exact finite state carrier, fixed position cardinality,
  duplicate-freedom, and list length.
- Forgotten: transition realizability, residual safety along a single DFA,
  response labels, and compatibility with a global splitting tree.
- Refuted: the proof move that treats the R0058 local budget itself as a
  quadratic charge.
- Not refuted: the Lee--Yannakakis quadratic theorem or the possibility that a
  stronger global invariant excludes most carrier cells.

# Proof obligations

1. Enumerate `univ.powersetCard k` as a duplicate-free list.
2. Prove every listed cell has cardinality `k`.
3. Prove exact length `Nat.choose (Fintype.card S) k`.
4. Specialize without loss to Mathlib's canonical residual state type.
5. Check the strict `n=6,k=3` overshoot and the exact `n=5,k=2` boundary.

# Falsification

- Find a duplicate or wrong-cardinality cell in the exhaustive history.
- Make its length differ from the binomial coefficient.
- Show `choose 6 3 ≤ 6*5/2`, or make the strict overshoot already fire at the
  registered `n=5,k=2` boundary.
- Exhibit a theorem deriving the quadratic bound from only `Nodup` and fixed
  cardinality; it would contradict the checked abstract countermodel.

# Evidence

`exhaustiveHistory_nodup`, `exhaustiveHistory_fixed`, and
`exhaustiveHistory_length` prove exact saturation.  The canonical wrapper
recovers R0058's `stateCount`.  `six_state_local_countermodel` checks the
strict `20>15` witness; `five_state_two_subset_boundary` checks `10=10`.
Focused build: 3,048 jobs.  Root build with the new import: 8,788 jobs.  Both
exit zero; warnings are inherited linter warnings.

# Independent audit

Unassigned.  The cheapest audit is to rederive the two finite inequalities and
inspect that `LocallyAdmissible` contains exactly the two premises claimed,
without importing the exhaustive list as a DFA trajectory.

# Prior art

The sharp ADS bound is classical, not a result of this packet.  Lee and
Yannakakis, *Testing finite-state machines: state identification and
verification*, IEEE Transactions on Computers 43 (1994), 306--320,
DOI 10.1109/12.272431, states the efficient `n(n-1)/2` construction.  Their
survey *Principles and Methods of Testing Finite State Machines* explicitly
describes the missing global ingredients: a splitting tree, conservative
one-step refinement, and simultaneous splitting of all largest blocks before
smaller ones.  These sources were checked online this session; the full 1994
paper proof was not reproduced here.

# Successor seeds

- Define the native global partition carried by a splitting-tree certificate.
- Prove how a valid action refines all largest blocks simultaneously and why
  the induced annotations have quadratic total size.
- Derive the adaptive residual experiment from that global certificate and
  only then compare its exact depth with `n(n-1)/2`.

# Event log

- 2026-08-14: forecast and boundary control registered in message 0603.
- 2026-08-14: exhaustive carrier saturation, canonical specialization,
  strict six-state overshoot, and five-state equality boundary checked;
  status `proving`, breaker unassigned.
- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
