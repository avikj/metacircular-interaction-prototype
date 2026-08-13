# Independent audit: prediction is not installation authority (R0030)

**Auditor:** cf-cinder (Claude Fable 5 lineage), 2026-08-12.
**Target:** `collab/discovery/claims/R0030-prediction-authority-boundary.md`,
source `notes/COUPLED_ARITHMETIC_ENCOUNTER_ENGINE.md` ("Predictive arithmetic
is not port authority") and `notes/SITUATED_CONSTRUCTOR_PREDICTIVE_CLASS.md`.
**Method:** independent re-implementation in `machinery/cf_cinder_audit_r0030.py`
+ `machinery/test_cf_cinder_audit_r0030.py`; builder's engine used only as the
second party in agreement checks. All arithmetic here is exact/finite.

## Verdict: CONFIRMED

Every point in the packet's `Falsification` section fails to hold. The exact
statement is true as registered. Transition `seed -> formalizing`. No strike;
nothing false was asserted by the builder.

## What the claim says, stripped

An explicit forecast adapter `P` reads the first certified Euclidean-descent
kind of a Smith matrix and returns a *predicted* environmental response
(row-residual -> 0, otherwise -> 2). Calling `P` is inert with respect to
installed capability: it appends one record to a forecast ledger and touches
nothing else. A live port response is a separate, provenance-bearing causal
input; it alone certifies and installs a constructor. For `A=((2,1),(0,7))` the
forecast is `0`, yet a live `r=2` still installs the order-two constructor with
future trace `(0,1)`. On the two-constructor carrier `C x X`, double reuse
already gives the discrete partition, so no larger carrier and no third
predictive class exists.

## Step-by-step, each with its pramana

**Step 1 -- Smith certificate replayed independently. (pramana: exact
computation, own arithmetic.)** I recomputed `L*A*R` with a local integer
matmul/determinant -- NOT the module's `verify()` -- for `A=((2,1),(0,7))`:
`L*A*R == D = ((1,0),(0,14))`, `det L, det R in {+-1}`, `D` diagonal, `d1 | d2`.
The first descent step is `row-residual`. Controls: `((2,0),(1,7))` gives
`column-residual`, `((2,0),(0,3))` gives `divisibility-residual`. So the three
first-step kinds are genuinely distinguished by the certificate, and `P` reads
a real certified feature, not a guess.

**Step 2 -- forecast changes no installation state. (pramana: exact snapshot
equality over all installation-bearing fields.)** I enumerated every field of
`EncounterEngine` except `response_forecasts` (proposals, sensors, actions,
returns, smith_fibers, two_adic_fibers, rich_memory_states, active_task,
task_view, active_constructor, active_grammar, constructor_selection_policy,
constructor_history), deep-copied them before the forecast call, and compared
after. The diff is empty; the forecast ledger grew from 0 to 1. Five repeated
forecasts still leave every installation field byte-for-byte equal and grow the
ledger to 5. `P(A)=0` matches my independent policy re-implementation. So the
first falsifier ("make forecast invocation install any executable grammar or
policy") does not fire.

**Step 3 -- opposed live port certifies uniquely. (pramana: brute force over
S_3 + engine agreement.)** Over the six permutations, exactly one carries
`0->1` with `g(2)=2`: `g=(1,0,2)`, the transposition `(0 1)`, order two, with
`g`-orbit of `0` equal to `(0,1)`. The engine's `couple_constructor_port(2,.)`
returns a certificate that `verifies()`, selects the same `(1,0,2)`, installs a
grammar of order 2, and yields `constructor_future(0)=(0,1)`. So the second
falsifier ("make the exact opposed live port fail certification") does not fire.

**Step 4 -- forecast does not override the response. (pramana: installed-object
identity.)** In one engine I forecast `0`, then supply live `r=2`. The installed
grammar has order two and future `(0,1)` -- the response's grammar, not the
forecast's order-three `(0,1,2)`. The disagreeing forecast `0` remains in the
ledger, unresolved, exactly as the packet demands ("disagreement is retained
rather than silently resolved by prediction"). So the third falsifier does not
fire.

**Step 5 -- reuse lives on `C x X`, not the raw transporter. (pramana: exact
closure check.)** `C={tau=(0 1), rho=(0 1 2)}` carries `0->1`, but
`tau^2 = id` (sends `0->0`) and `rho^2 = (0 2 1)` (sends `0->2`); neither square
carries `0->1`, so `C` is not closed under iteration and cannot be the reuse
carrier. On the repaired carrier `Q = C x X`, `a(g,x)=(g,g(x))`, initial
`(g,0)`, the observation words `(o, a, a^2)` are `tau: (0,1,0)` and
`rho: (0,1,2)`. So the fourth falsifier ("act repeatedly on the nonclosed
transporter") does not fire; the engine's `constructor_future` implements the
`C x X` semantics and returns `(0,1)` vs `(0,1,2)` for the two responses.

**Step 6 -- no third predictive class. (pramana: finite enumeration.)**
Endpoints (`o`, `a`) agree on both constructors -> the indiscrete partition;
`a^2` separates them -> the discrete partition. A two-element carrier admits
exactly two equivalence relations (verified by direct enumeration: the only
freedom is whether the two elements are related, and both choices are
transitive at `n=2`), and there are exactly two constructors in the transporter
to begin with. So the fifth falsifier ("exhibit a third predictive class") does
not fire; the scoped stop theorem of `SITUATED_CONSTRUCTOR_PREDICTIVE_CLASS.md`
holds.

## What did not break

- The forecast/installation separation is airtight under snapshot equality,
  including under repetition.
- The row-residual classification of `((2,1),(0,7))` is a certified fact, not a
  fitted label; the three descent kinds are genuinely distinct controls.
- The two-constructor carrier is complete: no intermediate quotient exists
  without first enlarging `C` and declaring a closed continuation action, which
  no live encounter has requested.

## Rigor boundary

Proved/replayed here: the Smith certificate replay, the forecast policy, the
empty installation diff, the unique order-two selection with trace `(0,1)`, the
transporter non-closure, the `C x X` signatures, and the two-quotient
enumeration -- all exact finite computations over concrete objects. Imported
without re-proof: the general `smith_reduce` descent algorithm and the
`select_with_port` construction (used as the second party, cross-checked at the
witnessed instances, not re-derived in general). Not in scope, as the packet
itself states: autonomous proposal generation, grammar development, and
organism-level self-production. This audit is a boundary/no-go confirmation of
a `novelty: known` obstruction; separating prediction from intervention is
standard causal-systems discipline and no novelty is claimed.

## Replay

```bash
cd machinery
python3 cf_cinder_audit_r0030.py
python3 -m unittest test_cf_cinder_audit_r0030.py   # 8 audit tests
python3 -m unittest test_coupled_encounter_engine.py # 12 builder tests
```

All three repository validators (`code/discovery_loop.py validate`,
`machinery/validate.py`, `code/natural.py validate`) pass (2 pre-existing
`natural` warnings unrelated to R0030).
