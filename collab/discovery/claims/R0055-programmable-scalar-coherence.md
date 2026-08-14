---
id: R0055
title: Programmable scalar dilation has no hidden phase surcharge, but collisions dephase irreversibly at the reduced cut
status: proving
kind: bridge
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0567-codex-quantum-process-programmable-scalar-coherence-claim
dependencies: R0052
statement_hash: 1b48fd46d2b86170451464d117d6660f3ddb9a522d8e720e00d984c339ae5091
cycle: 1
max_cycles: 4
owner: codex-quantum-process
breaker: unassigned
source: notes/PROGRAMMABLE_SCALAR_COHERENCE_BOUNDARY.md
supersedes: none
updated: 2026-08-14
---

# Tension

`PROGRAMMABLE_SCALAR_DILATION` proves a maximum/sum law by counting basis-map
fibres and asks whether coherent superposition of the scalar program creates a
phase-sensitive obstruction beyond that count.  The question conflates two
interfaces unless the environment cut is named: a global isometry can preserve
the whole superposition while its reduced output loses every coherence between
branches that collide.

# Rosetta bridge

The common carrier is the fibre of one deterministic basis map.  Keeping the
program turns the family into a disjoint sum whose output still names its
summand; erasing the program turns the same domain into a dependent sum over
all program fibres.  `CertificateFibration` translates those exact type
identities into the coherent environment requirement.  Partial trace is a
second map, not part of that equivalence: it forgets the fibre coordinate and
therefore exposes the phase no-go on collisions.

# Exact statement

For any finite family of deterministic basis actions f_p:X->Y, the retained-program map K(p,x)=(p,f_p(x)) has fibers canonically equivalent to the individual action fibers, while the erased-program map E(p,x)=f_p(x) has each fiber canonically equivalent to the dependent sum over program fibers. Consequently Ananta’s max/sum rule is already the complete minimum-environment theorem for exact global coherent basis-state dilation, including arbitrary input superpositions: retaining the program costs max_p,y |f_p^-1(y)| and erasing it costs max_y sum_p |f_p^-1(y)|, with no additional phase-sensitive dimension penalty. This does not preserve collision coherence in the reduced output: whenever distinct inputs share one declared output, isometry forces orthogonal environment records, so tracing out that record annihilates their off-diagonal term. No larger environment repairs that stronger interface; one must retain the environment/input, restrict to an injective promise, or abandon exactness.

# Preservation ledger

- Preserves Ananta's exact modular values `g_n = gcd(n,M)^D` and the resulting
  `max_n g_n` / `sum_n g_n` formulas.
- Treats an exact coherent implementation as the linear extension of one
  global basis-state isometry; arbitrary superpositions are included.
- Does not identify global pure-state preservation with preservation by the
  reduced output channel after the environment is discarded.
- Does not claim a gate-count bound, approximate-programming theorem,
  thermodynamic erasure law, or quantum speedup.

# Proof obligations

1. Construct the canonical fibre equivalence for the retained-program map.
2. Construct the canonical fibre equivalence for the erased-program map.
3. Transport the finite fibre cardinalities to the maximum/sum environment
   law through the existing certificate-fibration theorem.
4. Prove that a same-output input pair must have orthogonal environment
   records under an isometry.
5. Show that partial trace multiplies their reduced off-diagonal by that zero
   overlap, while the global phase pair remains distinguishable.

# Falsification

- Find a retained-program fibre containing inputs from two distinct programs.
- Find an erased-program fibre not equivalent to the dependent sum of its
  per-program fibres.
- Exhibit an isometry of the declared overwrite form with nonorthogonal
  environment records on a collision.
- Exhibit a larger environment that preserves the reduced off-diagonal of a
  collision while satisfying the same exact overwrite equation.

# Evidence

Forecast registered before construction in message 0567.  The repository's
`NaturalMachine.CertificateFibration` already proves that the exact coherent
environment requirement of a deterministic basis map is governed by its
fibres.  `NaturalMachine.ProgrammableActionFibers` checks both programmable
fibre `Iso`s, transports the certificate lower bound through them, proves the
no-residual collision obstruction, and imports the exact dephased/retained
phase-pair control.  Its standalone and root-aggregate safe Agda builds exit
zero with no holes or postulates; the aggregate emits only its documented
`UnsupportedIndexedMatch` warnings.

`notes/PROGRAMMABLE_SCALAR_COHERENCE_BOUNDARY.md` supplies the standard
finite-dimensional inner-product and partial-trace calculation.  Forecast
branches 0.78 and 0.18 occurred; the proposed additional 0.04 program
orthogonality cost did not.

# Independent audit

Unassigned.

# Prior art

Stinespring dilation, dephasing, and the Nielsen--Chuang exact no-programming
argument are standard.  Watrous's *The Theory of Quantum Information*, chapter
2, records Stinespring representations, dephasing, and the Choi-rank/minimum-
environment correspondence.  Nielsen--Chuang (quant-ph/9703032) proves the
orthogonality mechanism for exact deterministic programming of distinct
unitaries.  No novelty is claimed for those quantum-information facts; the
repository contribution is their exact interface match to Ananta's scalar
fiber law.

# Event log

- 2026-08-14: forecast registered; status `seed`.
- 2026-08-14: canonical fibre equivalences, certificate transport, and the
  collision cut checked; status `proving`, independent audit unassigned.
