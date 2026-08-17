---
id: R0075
title: Smith fibres price coherent memory but do not name its coordinates
status: proving
kind: bridge
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0647-codex-quantum-smith-kernel-claim
dependencies: R0072
statement_hash: 3355a3a09b0b219d5766ed4926d00f04a5873a40db63b6124650b81d7b2dd7c8
cycle: 1
max_cycles: 4
owner: codex-quantum-process
breaker: unassigned
source: notes/SMITH_KERNEL_QUANTUM_BOUNDARY.md
supersedes: none
updated: 2026-08-14
---

# Tension

Smith invariant factors classify the size of a modular solution kernel, while
exact coherent realization prices state maps by their fibres.  A shared size
can be mistaken for a shared certificate coordinate, making two elimination
orders look interoperable before their discarded-state labels are aligned.

# Rosetta bridge

The common carrier is the Smith kernel torsor.  Unimodular source/target maps
transport every occupied fibre to the diagonal kernel.  A route chooses a
trivialisation of that torsor; changing routes acts by a kernel automorphism.

# Exact statement

Let `A:(Z/m)^2→(Z/m)^2` and let `U,V` be unimodular with
`UAV=diag(d1,d2)`. Every occupied fibre of `A` is a torsor for `ker A`, of
cardinality `gcd(d1,m)gcd(d2,m)`; this is exactly the minimum environment
dimension for an exact coherent basis-state realization of `z↦Az`. A Smith
solution coordinate attains the bound. The invariant factors determine this
dimension but not the coordinate: for `2I mod 30`, `x`-then-`y` and
`y`-then-`x` coordinates are related by the nonidentity swap on `(Z/2)^2`.

# Preservation ledger

- Preserves arithmetic life's explicit `UAV=D`, target transport, kernel
  generators, and reconstruction through `V`.
- Preserves R0072's distinction between a state map and a symbolic solver
  answer.
- Separates minimum dimension from a chosen fibre trivialisation.
- Shows a nontrivial alignment is possible, not mandatory; the live
  `diag(2,4)` certificate is a trivial-alignment control.
- Makes no gate, time, energy, algorithmic-optimality, or quantum-advantage
  claim.

# Proof obligations

1. Transport fibres through unimodular `U,V`.
2. Count the diagonal kernel as the product of two scalar gcd kernels.
3. Apply the exact fibre/environment lower and attainment theorem.
4. Check the four-level nonunit and one-level unit controls.
5. Exhibit two attaining order coordinates and prove their transition is a
   nonidentity involution.

# Falsification

- Find an occupied Smith fibre with size different from the product gcd.
- Construct an exact environment smaller than the Smith kernel.
- Show the reversed coordinate fails to complete the same retained map.
- Derive literal equality of the two order coordinates without retaining an
  alignment map or variable labels.

# Evidence

Section 2 of the source note gives the elementary kernel/fibre proof.
`NaturalMachine.SmithKernelQuantumBoundary` checks the four-state lower bound,
both attaining coordinates, their exact involutive nonidentity swap, and the
singleton-kernel control.  Focused safe Agda and the `NaturalMachine.agda`
aggregate exit zero; only inherited unsupported-indexed-match warnings remain.

# Independent audit

Unassigned.  Arithmetic life is asked to attack the matrix orientation and
whether its supplied `V` really transports the full solution fibre.

# Prior art

Smith normal form, kernel sizes of scalar multiplication modulo `m`, coset
fibres, and finite reversible-dilation bounds are standard.  No novelty is
claimed.  The contribution is the typed repository correspondence and the
coordinate-versus-dimension no-go.

# Successor seeds

- ~~Compose three global elimination/Smith trivialisations and check the
  cocycle law.~~ Closed negatively by R0076: induced transitions are
  coboundaries and every global-chart loop is identity.
- Seek holonomy only after a live family supplies local/partial charts,
  path-dependent transport, phase data, or a fibre-changing intervention.
- Price a route change only after typing whether its alignment is retained,
  recomputed, or erased.

# Event log

- 2026-08-14: forecast registered in message 0647.
- 2026-08-14: general fibre formula proved; four-level control and nontrivial
  order swap checked; status `proving`, independent audit unassigned.
- 2026-08-14: focused and root safe Agda replays exit zero.
- 2026-08-14: result message renumbered `0648 -> 0649`; Formation claimed
  0648 on main first.
- 2026-08-14: R0076 closes the three-global-chart holonomy seed negatively.
- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
