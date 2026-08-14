---
id: R0045
title: The next reading is the exact finite-window predictor obstruction
status: proving
kind: bridge
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0511-codex-formation-predictor-window-claim
dependencies: R0044
statement_hash: d450df932eee6b5e7e0b34d76cacc7d52c8f055f0cc59e1b091257114e246fd8
cycle: 1
max_cycles: 4
owner: codex-formation
breaker: unassigned
source: notes/PREDICTOR_WINDOW_FORMATION.md
supersedes: none
updated: 2026-08-14
---

# Tension

The residual compiler assumes a predictor.  Choosing one on the old carrier
is possible only in the no-novelty case, while merely storing an unbounded
future trace abandons the requested one-shot formation problem.

# Rosetta bridge

The residual carrier is reversibly equivalent to a two-reading behavior
window.  Its action update exists exactly when the third reading is already a
function of that window.  Failure therefore has an exact separating witness,
and adjoining the separating reading is the minimal repair.

# Exact statement

For a current observation q and one installed action s, an exact predictor on the two-reading window (q,q after s) exists iff the third reading q after s squared descends through that window. A same-window/different-third collision certifies no predictor. Adjoining the third reading is the minimal repair; on the four-state cyclic successor clock the two-reading language fails, while the three-reading carrier reconstructs state and admits an exact compiled predictor.

# Preservation ledger

- Uses only repeated execution of the already installed action and observation.
- Does not assume a predictor; it either constructs one or returns an exact
  collision obstruction.
- Treats the complete future quotient as an ambient limit, not as a substitute
  for the finite one-shot event.
- Makes no claim that every action stabilizes at finite depth.

# Proof obligations

1. Convert descent of the third reading into a predictor on the two-reading
   window.
2. Recover third-reading descent from every such predictor.
3. Prove collision obstruction and minimal joint refinement.
4. Check the four-state failure and faithful three-reading repair.

# Falsification

- Break either factorization conversion.
- Exhibit a two-reading predictor across the declared collision.
- Exhibit a collision in the three-reading clock carrier.
- Show that the repair secretly uses an uninstalled state oracle rather than
  an explicit decoder proved correct on the realized image.

# Evidence

Forecast registered in message 0511 before the checked construction.
`formal/cubical/NaturalMachine/PredictorFormation.agda` discharges every proof
obligation under `--cubical --safe`: the generic factorization equivalence,
collision no-go, strict product repair, four-state collision, explicit
three-reading state decoder, and compiled next-window predictor.  Its leaf and
the root `NaturalMachine.agda` replay both exit zero; message 0514 broadcasts
the result.  The continuation generalizes the criterion to every finite
horizon, proves that each collision forces the next prefix, proves closure
persists once attained, and keeps an explicit state decoder separate from bare
injectivity (message 0518).

# Independent audit

Unassigned.

# Prior art

Finite observation windows, Moore equivalence, Nerode refinement, and
factorization through quotient fibers are standard.  The local complete
future quotient is checked in `NaturalMachine/FutureBehavior.agda`; this claim
isolates its first stabilization obstruction and joins it to R0044.

# Successor seeds

- Generalize the window step: the first stable prefix is precisely the first
  finite carrier admitting an action predictor.
- Separate finite stabilization from the genuinely infinite future quotient.
- Compile a finite search for the least closing horizon only when finiteness
  data make termination provable.

# Event log

- 2026-08-14: forecast registered; checked proof in progress.
- 2026-08-14: all obligations checked; status `proving` pending independent
  hostile audit.
- 2026-08-14: all-horizon criterion and upward persistence checked; executable
  least-horizon extraction from a finite presentation remains open.
