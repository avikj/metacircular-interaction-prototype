---
id: R0077
title: Persistent addition-chain futures obstruct endpoint compression
status: proving
kind: no-go
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0667-codex-cubical-addition-chain-predictive-memory-claim
dependencies: none
statement_hash: 78b166d32e627d35ece1efa7350908cfe656a96d4b589b32ecc96dfcdf79b21d
cycle: 1
max_cycles: 3
owner: codex_cubical_ingestor
breaker: unassigned
source: formal/cubical/NaturalMachine/AdditionChainPredictiveMemory.agda
supersedes: none
updated: 2026-08-14
---

# Tension

`TerminalTraceCompression` proves that a deterministic history is safely
replaceable by its terminal record when the two observations mutually factor.
Persistent addition-chain caches provide an exact obstruction: distinct
histories can reach the same integer while enabling different future reuse.

# Rosetta bridge

The common object is `FiniteInformation.FactorsThrough`.  The endpoint is the
putative quotient observation, persistent availability is the downstream
target, and a same-endpoint pair with unequal responses is precisely a kernel
collision obstructing descent.  A retained cache bit is side information; an
explicit garbage-collection operation changes the downstream target.

# Exact statement

For histories A and B with a common endpoint, persistent future responses
`has3` and `has4` disagree. Therefore no decoder from the endpoint to either
separating response exists. The Bool cache bit together with the endpoint
factors every declared response, while after explicit garbage collection the
constant response factors through the endpoint alone.

# Preservation ledger

- Preserves the exact histories' common endpoint and their opposite responses
  to the declared probes 3 and 4.
- Preserves cache persistence as an explicit response semantics rather than
  metadata.
- Compiles the obstruction and repair into constructive decoders on univalent
  images.
- Separates persistent and garbage-collected semantics by different targets.
- Does not certify the arithmetic construction trace, chain minimality, cache
  cost, quantum process structure, or any physical memory claim.

# Proof obligations

1. Define the two histories, common endpoint, probes, cache bit, and persistent
   response table.
2. Check both separating responses by reduction.
3. Apply the generic collision obstruction to reject endpoint descent.
4. Construct the endpoint-plus-bit decoder for the whole response table.
5. Construct the endpoint decoder after explicit garbage collection.
6. Integrate the module and pass `sh formal/check.sh` under `--safe`.

# Falsification

- Produce an endpoint decoder for either separating persistent response.
- Show the endpoint-plus-bit decoder fails on one declared probe.
- Show the garbage-collected target remains nonconstant.
- Derive a quantum or physical conclusion from the finite classical interface
  without adding the missing structure.

# Evidence

`terminal-cannot-predict-has3` and `terminal-cannot-predict-has4` instantiate
the generic collision obstruction.  `terminal-cannot-recover-cacheBit` checks
the missing reverse factorization; `persistent-through-terminal-and-cacheBit`
constructs the repaired two-probe decoder; and
`garbage-collected-through-terminal` constructs the endpoint decoder only for
the explicitly changed constant target.  Standalone safe Agda and the full
`sh formal/check.sh` gate exit zero; the latter checks 8,817 Lean jobs.  Only
inherited warnings remain.

# Independent audit

Unassigned.  A breaker should attack whether the adapter proves persistence or
merely assumes it, and whether any conclusion exceeds the declared two-probe
future interface.

# Prior art

Predictive-state equivalence and sufficient statistics are standard.  The
source result is `notes/ADDITION_CHAIN_PROCESS_MEMORY.md`; no novelty is
claimed for the finite collision argument.

# Successor seeds

- Replace the two-probe table by a native finite formed-value cache only if the
  extra carrier changes a theorem rather than its presentation.
- Compare equal-endpoint chains by declared continuation cost after the
  predictive quotient is fixed.
- Add coherent or quantum structure only through an explicit instrument and
  normalization interface.

# Event log

- 2026-08-14: forecast and scope boundary registered in message 0667; status
  `formalizing`, independent audit unassigned.
- 2026-08-14: leading collision/definitional-decoder branch checked; one
  `funExt` packages function-valued replay.  Result message 0669; status
  `proving`, independent audit unassigned.
- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
