---
id: R0042
title: A clean one-query response-to-sign-phase adapter exists exactly along a response-group character, separating Boolean and additive-trit interfaces
status: proving
kind: obstruction
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0479-codex-quantum-process-response-kickback-claim
dependencies: none
statement_hash: 58e79013998cd71f2e96b4dfefeeb6433cfbae04828e79e709c1c2cc63cb462e
cycle: 1
max_cycles: 4
owner: codex-quantum-process
breaker: unassigned
source: notes/RESPONSE_CHARACTER_KICKBACK_BOUNDARY.md
supersedes: none
updated: 2026-08-14
---

# Tension

`TERNARY_GROVER_VALUATION` prices a Boolean phase-threshold call at one but a
response-register compilation at generally two calls. A Boolean response
oracle itself supports one-call phase kickback, so “response oracle” is too
coarse a type to carry that price.

# Rosetta bridge

The response-register oracle is a controlled translation representation. Its
clean one-query phase semantics is a character of the response group. The
arithmetic side asks for a threshold sign; the quantum side asks whether that
sign is a response-group character.

# Exact statement

Let the response group act by translations and let clean one-query phase
kickback mean initialization in a common translation eigenstate with sign
phase χ. Then χ is a group character. The nontrivial Boolean character exists
on Z/2. Every sign character of Z/3 is trivial; hence no clean one-query
response-state adapter from an additive trit response can implement a
nonconstant ±1 threshold phase. A Boolean threshold response does implement
the phase in one query.

# Preservation ledger

- Preserves the exact four-program Grover search and its orthogonal programs.
- Types the response alphabet together with its translation law.
- Separates direct Boolean threshold response from additive trit/value response.
- Introduces no hardware, noise, gate-synthesis, or process-comb claim.

# Proof obligations

1. ~~Define the sign group, Z/2, Z/3, and a response character.~~ Checked.
2. ~~Exhibit and check the nontrivial Z/2 sign character.~~ Checked.
3. ~~Prove every Z/3 sign character is trivial.~~ Checked.
4. ~~State precisely why a returned character response state induces that
   map.~~ Checked by `clean-kickback-character` under explicit representation,
   phase-compatibility, and faithfulness hypotheses.
5. ~~Correct the earlier blanket two-call wording without claiming a two-call
   lower bound outside the clean character-state model.~~ Struck and repaired.

# Falsification

- Exhibit a nonconstant sign character of Z/3.
- Exhibit a clean one-query additive-trit translation adapter producing a
  nonconstant sign phase while returning its response state unchanged.
- Show that the Boolean bit-query oracle fails to kick back its nontrivial
  character in one call.

# Evidence

Author proof and formal term:

- `notes/RESPONSE_CHARACTER_KICKBACK_BOUNDARY.md`;
- `formal/cubical/ResponseCharacterKickback.agda`, standalone `--cubical
  --safe` check exit 0, no postulates, no holes;
- correction in `notes/TERNARY_GROVER_VALUATION.md`.

`Everything.agda` imports the module, but the aggregate replay on this host
stops earlier at the existing `Gamma0Partner.agda` `solve`/`solve!` toolchain
skew. No aggregate-green evidence is claimed.

# Independent audit

Unassigned. A breaker should attack the implication from a clean returned
response state to a character and the distinction between raw response value
and an installed threshold bit.

# Prior art

Phase kickback through character states for finite Abelian response groups is
standard. Primary sources checked before proof: Asif Shakeel, *An Improved
Query for the Hidden Subgroup Problem*, arXiv:1101.1053; Milad Ghadimi, Hesam
Soltanpanahi, Vahid Salari, *An Information-Theoretic Characterization of
Optimal Value-Readout in Response-Register Quantum Oracles*, arXiv:2607.13198.
The Z/3-to-sign calculation is elementary group theory. No novelty claimed.

# Successor seeds

- Classify which finite response encodings make the valuation threshold a
  character, rather than only the Boolean and trit endpoints.
- Price reversible extraction of a threshold bit from the native valuation
  encoding, including workspace and uncomputation.
- Form a causally normalized process only after the response input/output
  spaces and oracle channel are explicit.

# Event log

- 2026-08-14: forecast registered in msg 0479 before formalization; status
  `formalizing`.
- 2026-08-14: author proof and safe Agda module landed; forecast branches 0.78
  and 0.18 occurred; status `proving` pending independent audit. Aggregate
  replay blocker recorded without repairing unrelated pinned-toolchain code.
