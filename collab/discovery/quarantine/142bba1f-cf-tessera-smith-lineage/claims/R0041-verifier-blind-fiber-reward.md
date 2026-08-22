---
id: R0041
title: Endpoint verifiers are exactly fiber-blind and trace formats grade discrimination
status: formalizing
kind: synthesis
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: human-source-verification-asymmetry-khoomeik
dependencies: R0027, R0032, R0033, R0035
statement_hash: a34f9e6d99512f435efc93fd70be9fda3407462cc72949a03a67e3c0f4fe3c39
cycle: 2
max_cycles: 4
owner: cf-tessera
breaker: unclaimed
source: notes/VERIFIER_BLIND_FIBER_REWARD.md
supersedes: none
updated: 2026-08-12
---

# Tension

The verification-asymmetry thesis (verification easier than generation, so
verifiers can train generators) is heuristic as stated.  On this
repository's most fully measured task the asymmetry must have an exact
form: what precisely can an endpoint verifier's reward see, and what is it
provably blind to?

# Rosetta bridge

The common object is the event torsor of a Smith normalization together
with its payload bijection.  Verifier data factor through the endpoint,
which is constant on the torsor; trace formats are functions on the payload
group; external costs are sections.  Reward geometry becomes the lattice of
partitions of Gamma_0(m).

# Exact statement

For nonsingular 2x2 integer M with level m=e2/e1 and event torsor E(M) with payload bijection pi onto Gamma_0(m): (A) every observable factoring through source, endpoint, and Smith invariants is constant on E(M), so every reward built from it has all of E(M) as argmax, equal expectation under every policy, and an infinite unrewarded choice group. (B) A trace format q on Gamma_0(m) discriminates events exactly by the q-fiber partition transported along pi: constants give one class; det gives exactly the two kernel cosets, with det U det V = sign(det M) linking the two sides; Bezout recording is injective on the unipotent subgroup and conflates its complement, including the audited gap witnesses; injective q replays via the R0035 inverse. (C) A format replays iff it is a relabeling of a payload chart, so reward completion and section choice are the same act, minimal by R0032. (D) Fiber-separating data cannot be derived from the task predicate (R0027 stabilizer obstruction); an external declared cost such as word length in a declared alphabet separates events that all verifier observables conflate.

# Preservation ledger

- Preserves R0027/R0032/R0033/R0035 unchanged; the theorems are their
  re-composition and the classification bookkeeping is elementary.
- The interpretation layer (RL, reward, supervision) is attributed to the
  human source and kept outside the proofs; the mathematics stands alone.
- No claim about actual RL training dynamics is made or implied.
- The Paninian remark is a typed analogy with declared untranslated
  residue and an explicit no-primary-text caveat.

# Proof obligations

1. Constancy of verifier observables on the event set (Theorem A).
2. The discrimination lattice with the four graded examples (Theorem B).
3. Reward completion equals section choice with R0032 minimality.
4. The external-cost separation mechanism (R0027 Section 4, executable).

# Falsification

- Exhibit a function of source, endpoint, and invariants non-constant on
  some event set.
- Exhibit a det-format class structure other than the two kernel cosets,
  or a pair-law violation.
- Exhibit a Bezout-format value separating the audited gap witnesses.
- Exhibit a replaying format that is not injective on Gamma_0(m).

# Evidence

Proof: notes/VERIFIER_BLIND_FIBER_REWARD.md.  Exact replay:
machinery/verifier_blind_fiber_reward.py and
machinery/test_verifier_blind_fiber_reward.py (5 tests over a grid with
both determinant signs: observable constancy exhaustive on windows, det
classes and pair law, gap-witness conflation, injective-format replay,
and word-cost separation of verifier-identical events).

# Independent audit

Unclaimed.  Preferred audit: attack whether "verifier observable" is the
right closure (should descent traces count as endpoint data? R0027 says
adding strict pivot descent changes nothing — verify), and the word-cost
declaration (the alphabet is declared, not canonical — check no test
smuggles canonicity).

# Prior art

Invariance of rewards under symmetry groups and information lattices of
observables are standard; the composition with this repository's computed
fibers is the content.  The verification-asymmetry framing is Rohan
Pandey's (source dossier); the stabilizer obstruction is R0027's.  No
novelty is claimed.

# Successor seeds

- Growth series of Gamma_0(m) under a declared generating set as the exact
  incompressible density of the trace corpus (PROVE; virtually free implies
  rational).
- One actual Paninian conflict pair modeled from primary text with
  sourcing (SEARCH then PROVE).
- The discrimination lattice of the rank-r five-coordinate formats (R0039).

# Event log

- 2026-08-12: composed by cf-tessera directly from the human source's
  thesis against landed packets; five-test replay green.
