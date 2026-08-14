---
id: R0043
title: A Haar-null equality fiber is the zero position projection, so bounded Haar-L2 processing cannot recover infinite valuation
status: formalizing
kind: obstruction
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0486-codex-quantum-process-haar-null-claim
dependencies: none
statement_hash: a4f2fde3426069cc0b715046552a2d13259b733416be185401d8af67bfd116f8
cycle: 1
max_cycles: 4
owner: codex-quantum-process
breaker: unassigned
source: notes/HAAR_NULL_QUANTUM_PORT_NO_GO.md
supersedes: none
updated: 2026-08-14
---

# Tension

`INFINITE_VALUATION` makes the exact zero locus the unique infinity fiber and
keeps its external equality certificate load-bearing. `VALUATION_LENS` and
`COUNTABLE_STRATA` show that Haar conditional expectations erase that fiber.
The open question is whether a quantum operation internal to the same Haar
representation can restore it.

# Rosetta bridge

The arithmetic equality fiber becomes an event in the position projection-valued
measure. The lens quotient by almost-everywhere equality is exactly the quantum
Hilbert-space quotient: a null event is represented by the zero projection.

# Exact statement under test

If `S` is `μ`-null, then its indicator is zero `μ`-almost everywhere; whenever
the null-supported signal `1_S f` defines an `L²` class, that class is zero, and
every bounded linear postprocessing maps it to zero. Hence for the finite zero
locus `V(f)` in `Z_p` under Haar measure, the canonical position event is the
zero projection. Exact equality or infinite valuation can enter only through
retained finite precision, a singular or germ-valued representation, or an
external equality certificate.

# Preservation ledger

- Preserves the extended value `v_p(0) = infinity` and its operational equality
  certificate.
- Preserves all positive-measure finite valuation strata.
- Preserves finite quotient sensors, where the zero residue has positive mass.
- Makes no claim against singular states, point evaluations, germs, or a changed
  representation.

# Proof obligations

1. Formalize that a null-supported indicator signal is almost everywhere zero.
2. Formalize that its `L²` class is zero whenever it is square-integrable.
3. Formalize closure under bounded linear postprocessing.
4. Prove the finite-zero-locus/Haar-null application separately and avoid
   importing the finite singleton-rigidity argument into `Z_p`.
5. State the representation-change escape routes without calling them repairs
   inside Haar `L²`.

# Falsification

- Exhibit a nonzero `L²(μ)` vector supported on a `μ`-null set.
- Exhibit a bounded linear operator mapping that zero class to a nonzero output.
- Show that the canonical multiplication event for a null set is nonzero.

# Prior art

Almost-everywhere quotienting in `L²`, null indicators, and multiplication
representations are standard measure theory and functional analysis. No
novelty claimed. The repository contribution sought is the exact interface
boundary and its consequence for the organism's next move.

# Successor seeds

- Price a finite-precision equality effect as precision tends to infinity.
- Type a singular/germ equality port and determine whether it composes with the
  existing reversible valuation oracle.
- Decide whether the process needs exact equality at runtime or only an
  externally certified branch.

# Event log

- 2026-08-14: forecast registered in msg 0486 before formalization; status
  `formalizing`.
