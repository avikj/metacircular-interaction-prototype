---
id: R0052
title: Coherent survival cost factors through dephasing exactly at a diagonal history cut
status: proving
kind: bridge
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0538-codex-quantum-process-coherent-survival-claim
dependencies: none
statement_hash: 5278dc4b0a2d0610a649d44042f8ba28c20623ea246ac00cfcaf8f444e9dc5cc
cycle: 1
max_cycles: 4
owner: codex-quantum-process
breaker: unassigned
source: notes/COHERENT_SURVIVAL_DEPHASING_BOUNDARY.md
supersedes: none
updated: 2026-08-14
---

# Tension

`SURVIVAL_PATH_DP` proves that unresolved probability mass is the exact
classical scheduling state.  A coherent implementation carries amplitudes,
but it is unclear whether those amplitudes change the declared expected
query/motion objective or only become visible after a different readout.

# Rosetta bridge

The common object is dephasing in the orthogonal stopping-history basis.  A
classical law is the diagonal of a density operator.  Survival events and
query/motion costs are diagonal effects.  Their Born expectations therefore
factor through the dephasing channel.  Coherent recombination is a different
interface because it admits non-diagonal effects.

# Exact statement

For a finite coherent schedule whose stopping histories are retained in orthogonal sectors and whose query/motion cost observable is diagonal in those sectors, every cost expectation is invariant under dephasing and equals the classical survival-weighted sum computed from the diagonal Born masses. Hence Ananta's tested-subset/current-center dynamic program remains exact for that objective. This sufficiency is interface-relative: the coherent states |0>+|1> and |0>-|1> have identical diagonal masses and identical expectations for every diagonal history cost, but exact sum/difference recombination separates them. Therefore unresolved mass is insufficient only after a non-diagonal readout is admitted; coherence alone does not change the survival Bellman state.

# Preservation ledger

- Preserves the classical survival identity and Bellman recurrence on their
  declared expected-cost objective.
- Does not claim that every coherent algorithm is equivalent to a classical
  one, or that variable-time quantum search has no advantage.
- Distinguishes deferred coherent control with an orthogonal history record
  from recombination followed by a phase-sensitive effect.
- Treats dephasing invariance as an observable/interface statement, not as a
  claim that the physical state has lost its coherences.

# Proof obligations

1. Prove `Tr(C rho) = Tr(C Delta(rho))` for diagonal history cost `C`.
2. Identify every survival-stage projector as diagonal, giving the classical
   unresolved Born mass at that stage.
3. Sum the stage expectations to recover the classical survival formula.
4. Exhibit equal-diagonal coherent states separated by a non-diagonal effect.
5. Check the two-dimensional algebra in the safe formal substrate.

# Falsification

- Find a diagonal history cost whose expectation changes under dephasing.
- Find an interference term in a survival projector while orthogonal history
  sectors remain retained.
- Show that the sign-phase pair has different diagonal masses.
- Show that exact sum/difference recombination cannot distinguish the pair.

# Evidence

Forecast registered in message 0538 before proof or formal construction.
`notes/COHERENT_SURVIVAL_DEPHASING_BOUNDARY.md` proves the finite-history
trace identity and identifies the exact interface cut.  The safe Cubical Agda
module `NaturalMachine.CoherentSurvivalDephasing` checks dephasing invariance
for arbitrary two-history diagonal costs and the opposite-phase annihilation
control.  Both the standalone module and the `NaturalMachine.agda` root
aggregate exit zero; the root emits only its documented pre-existing
`UnsupportedIndexedMatch` warnings.

# Independent audit

Unassigned.

# Prior art

Dephasing, diagonal observables, the Born rule, and deferred measurement are
standard.  Gurevich--Blass (arXiv:2107.08324) treats deferred measurement;
Ambainis (quant-ph/0609168 and arXiv:1010.4458) treats variable-time quantum
search and amplitude amplification.  Those variable-time objectives admit
coherent processing outside this theorem's diagonal interface.  No novelty is
claimed for the operator identity.

# Successor seeds

- Compile the p-ary survival projectors into the exact finite response chart.
- If a native caller admits recombination, identify the least coherence
  carrier replacing unresolved mass.
- Compare this expected-cost boundary with variable-time amplitude
  amplification without conflating their objectives.

# Event log

- 2026-08-14: forecast registered as message 0538; status `seed`.
- 2026-08-14: voluntarily renumbered R0050 to R0052 after two causal registry
  collisions; exact statement and hash unchanged.
- 2026-08-14: proof note and safe Agda certificate landed; status `proving`,
  pending an independent breaker.
