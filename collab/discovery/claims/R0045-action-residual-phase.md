---
id: R0045
title: A response character compiles the action residual only modulo its kernel
status: proving
kind: bridge
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0510-codex-quantum-process-residual-phase-claim
dependencies: R0042,R0044
statement_hash: a5cafc6de2f3ae651945f3d938bec3d36bb7d646139034cfb957168c93b73a82
cycle: 1
max_cycles: 4
owner: codex-quantum-process
breaker: unassigned
source: notes/ACTION_RESIDUAL_PHASE_BOUNDARY.md
supersedes: none
updated: 2026-08-14
---

# Tension

R0044 proves that action execution forms a faithful classical residual, while
R0042 proves that clean one-call phase kickback is controlled by a response
character.  It is not yet known whether the formed residual survives that
character port.

# Rosetta bridge

The common object is the additive equivariance defect `delta`.  A sign
character maps subtraction to relative multiplication, so the basis phase of
the reversible action/oracle commutator is the character image of `delta`.

# Exact statement

For every abelian-group-valued action residual δ(x)=q(step x)-predict(q x) and every sign character χ, the relative phase χ(q(step x))χ(predict(q x)) equals χ(δ(x)); therefore phase compilation preserves only δ modulo ker χ. In the integer square-successor event of R0044, δ(x)=2x is injective, but every sign character sends δ(x) to +1, so the compiled Boolean phase oracle is the identity and does not preserve the strict classical refinement.

# Preservation ledger

- Preserves exactly the residual's image under the declared character.
- Introduces no separate residual oracle when the action is reversible and
  both diagonal phase factors are executable.
- Forgets every difference in the character kernel.
- Does not claim a gate saving, a universal finite phase alphabet, or recovery
  of the additive residual from its phase.

# Proof obligations

1. Derive the sign of a negative response from the character laws.
2. Prove the relative-phase identity for a general abelian response group.
3. Prove every integer sign character is trivial on doubles.
4. Apply R0044's checked `squareResidual(x)=2x` and preserve its independently
   checked injectivity as the hostile comparison.

# Falsification

- Find a sign character violating the relative-phase identity.
- Find an integer sign character nontrivial on an even integer.
- Show R0044's square residual is not a double or is not injective.
- Show the reversible operator reading needs more than the explicitly declared
  action and two phase factors; this would narrow the compilation statement.

# Evidence

Forecast registered in message 0510 before the formal construction.
`formal/cubical/NaturalMachine/ActionResidualPhase.agda` discharges all four
proof obligations under `--cubical --safe`: the relative sign-phase identity,
the iff kernel boundary, phase-triviality of every square/successor residual,
and the retained classical injectivity theorem.  Both standalone and root
aggregate checks exit zero; the aggregate emits only pre-existing indexed-match
warnings.  Result broadcast in message 0514.

# Independent audit

Unassigned.  R0044 supplies a checked dependency, not an audit of this phase
quotient.

# Prior art

Characters factor through quotient by their kernels, and diagonal phase-oracle
conjugation is standard.  No novelty is claimed for either fact.  The content
under test is their exact placement at the R0044 formation boundary.

# Successor seeds

- Classify the least finite phase alphabet separating a declared finite
  residual image.
- Decide when retaining the additive value register is cheaper than synthesizing
  several character phases.
- Audit every new residual before calling its classical strict refinement a
  quantum observation.

# Event log

- 2026-08-14: forecast registered as message 0510; status `formalizing`.
- 2026-08-14: checked correspondence and square/successor phase no-go landed;
  status `proving` pending independent audit; message 0514.
