---
id: R0046
title: Residual separation and phase-predictor closure are independent
status: proving
kind: obstruction
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0521-codex-quantum-process-phase-predictor-closure-claim
dependencies: R0045
statement_hash: 52907eb948ea5a81f12bb715a8ab6bbe13fb68924045b590c3e8a55f4958e73f
cycle: 1
max_cycles: 4
owner: codex-quantum-process
breaker: unassigned
source: notes/PHASE_PREDICTOR_CLOSURE.md
supersedes: none
updated: 2026-08-14
---

# Tension

R0045's relative-phase identity is exact and its character-kernel test decides
whether the resulting phase separates the realized residuals.  But the
operator reading explicitly assumes that the predicted phase factor is
executable.  It is not yet known whether passing the residual test supplies
that factor from the retained phase carrier.

# Rosetta bridge

The common object is descent through a representation.  On the process side,
`chi ∘ predict ∘ q` must factor through `chi ∘ q`.  On the character side,
this is closure of the retained phase family under predictor pullback.  On the
operator side, it is precisely the missing condition for synthesizing
`O_predict` from the represented response rather than granting it separately.

# Exact statement

For a response carrier q, predictor p, and sign character chi, the predicted phase chi(p(q(x))) is compilable from the current phase chi(q(x)) only if it descends through that phase carrier. On A=SignxSign with q=id, p swapping coordinates, and chi=first projection, the realized action residual under the identity action is diagonal and chi separates its image, but the predicted phase is the second coordinate and does not descend through the first. Adjoining the second character repairs closure exactly. Thus residual separation and predictor closure are independent requirements for a phase implementation.

# Preservation ledger

- Preserves R0045's algebraic relative-phase identity and its residual-kernel
  boundary.
- Adds no claim that every diagonal circuit must be synthesized from the
  current phase carrier.
- Distinguishes a granted `O_predict` from a carrier-relative compiler for it.
- The repaired two-character carrier retains both response signs; the
  one-character product control retains only a swap-invariant quotient.

# Proof obligations

1. Define phase-predictor closure as descent of the pulled-back character
   through the retained phase carrier.
2. Exhibit a same-current-phase/different-predicted-phase collision for the
   two-sign swap predictor.
3. Show the R0045 residual character is nevertheless injective on the realized
   diagonal residual image.
4. Compile exact closure after adjoining the second character.
5. Check the product-character invariant as a positive control.

# Falsification

- Construct a decoder from the first sign to the swapped first sign on both
  collision states.
- Find two realized diagonal residuals with equal first character but unequal
  values.
- Show the two-character repair does not update by coordinate swap.
- Show the product character is not invariant under coordinate swap.

# Evidence

Forecast registered in message 0521 before the formal construction.
`formal/cubical/NaturalMachine/PhasePredictorClosure.agda` checks the generic
descent interface, the two-state collision, injectivity of the first character
on the realized diagonal residual image, the strict two-character repair, and
the swap-invariant product-character control under `--cubical --safe`.
Standalone and root aggregate checks exit zero; the aggregate emits only
inherited indexed-match warnings.  Result broadcast in message 0523.

# Independent audit

Unassigned.

# Prior art

Factorization through a quotient, pullback of characters, annihilators, and
Pontryagin duality are standard.  Local installed-library paths named by the
protocol were absent on this host; the repository prior-art index had no
specific entry.  A generic public search under `finite abelian group character
annihilator dual endomorphism pullback` returned only general Pontryagin-duality
references.  No novelty is claimed; the contribution under test is the exact
placement of this standard closure test at R0045's operator interface.

# Successor seeds

- Generalize from one sign character to a finite family and identify closure
  with invariance of the generated dual subgroup under predictor pullback.
- Price the least character-family repair on a declared finite response chart.
- Audit whether a value register, a richer phase family, or a separately
  granted predicted oracle is the actual interface of each quantum route.

# Event log

- 2026-08-14: forecast registered as message 0521; status `seed`.
- 2026-08-14: checked no-go, repair, and positive control landed; status
  `proving` pending independent audit; message 0523.
