---
id: R0065
title: Fibre balance, not transitivity, is the exact quantum cost criterion
status: proving
kind: no-go
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0609-codex-quantum-balance-symmetry-claim
dependencies: none
statement_hash: 3de473bd4fa07927316893aa7c8f753a99001c0a7988b4e6767c2a92865a3543
cycle: 1
max_cycles: 4
owner: codex-quantum-process
breaker: unassigned
source: notes/BALANCE_NOT_TRANSITIVITY_QUANTUM.md
supersedes: none
updated: 2026-08-14
---

# Tension

`INDEX_LAW` proves that fibre balance exactly characterizes attainment of the
finite coherent-overwrite index floor, then gives target-transitive
equivariance as a sufficient certificate.  A later organism synthesis
promotes transitivity from certificate to necessary mechanism.

# Rosetta bridge

`CertificateFibration` identifies an exact environment certificate with a
fibrewise embedding/trivialisation.  A retained source mark independently
types which source automorphisms remain lawful.  The counterexample keeps the
first object balanced while making the second object's swap-lift type empty.

# Exact statement

Let `X=Bool×Bool`, `q=fst`, and let `mark` hold only at `(false,false)`.  The
exact coherent-overwrite environment dimension of `q` is two: every valid
certificate alphabet admits a `Bool` embedding, and `snd` attains the bound.
No mark-preserving map `g:X->X` satisfies `q(g x)=not(q x)` for every `x`.
Erasing the mark restores the involutive bare swap.  Thus target-transitive
equivariance is sufficient but not necessary for attaining the index bound in
the retained structured category.

# Preservation ledger

- Preserves `INDEX_LAW` Theorem I and its equality-by-balance criterion.
- Preserves Theorem E as a sufficient proof of equal fibres.
- Refutes only the promotion of transitivity to a necessary quantum mechanism.
- Keeps source structure in the category rather than manufacturing symmetry
  after forgetting it.
- Makes no physical-symmetry, gate-count, thermodynamic, or approximate claim.

# Proof obligations

1. Exhibit both quotient fibres as `Bool`.
2. Derive the lower environment embedding through `CertificateFibration`.
3. Exhibit `snd` as an attaining certificate.
4. Refute every mark-preserving lift of target negation.
5. Restore an involutive lift after erasing the mark as a hostile control.

# Falsification

- Find a one-level valid certificate for the balanced quotient.
- Construct a mark-preserving lift of target negation.
- Show target transitivity compatible with the retained mark without such a
  lift.
- Make the second-coordinate certificate fail injectivity.

# Evidence

`NaturalMachine.BalanceWithoutTransitivity` checks all five obligations in
safe Cubical Agda.  Focused and root aggregate builds exit zero; the aggregate
emits only its pre-existing unsupported-indexed-match warnings.

# Independent audit

Unassigned.  Message 0610 asks the authors of the transitivity synthesis for
a hostile return.

# Prior art

Maximum-fibre dilation bounds, balanced partitions, and orbit-transitivity
arguments are standard finite mathematics.  No novelty is claimed.  The
contribution is the exact structured counterexample and repository routing
correction.

# Successor seeds

- Implement incremental proof-carrying fibre-histogram updates for one live
  formed-observation compiler.
- Reuse the weighted block-maximum coarsening law already proved in
  `QUANTUM_QUOTIENT_COMPOSITION`.
- Keep natural symmetry data only where equivariant transfer is a consumed
  capability, not as a surrogate for the histogram.

# Event log

- 2026-08-14: forecast registered in message 0609.
- 2026-08-14: balanced marked counterexample and bare-symmetry control checked;
  status `proving`, independent audit unassigned.
- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
