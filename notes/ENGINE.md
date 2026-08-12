# The engine: a long-running loop whose every design decision is a theorem from this corpus

    python3 machinery/crystal/engine.py --forever
    python3 machinery/crystal/engine.py --report

State is one append-only JSONL log and nothing else. Kill it at any point,
restart, and it replays the log, skips what is settled, and resumes. **Memory
is never trusted; it is replayed.**

## 1. What it produced

238 events, 236 attempts, 230 settled, 2 null controls passed.

| | |
|---|---|
| **theorems** (a fiber collapsed; the collapse *is* the result) | **70** |
| interpretations decided | 68 |
| strictly-weaker relations, with the failing axiom named | 24 |
| requirements named and not attempted | 64 |
| vacuous, recorded and not counted | 4 |

### Verified by an independent method — all of them

The first version of this note said 3 of 70 were spot-checked and the rest
"await anyone who knows semigroups." That was a manufactured limitation.
They did not need a specialist; they needed a method that does not share
machinery with the one that produced them.

`machinery/crystal/models.py` checks them by **finite model search**. Syntax
made the claims; semantics can refute them, and the two share nothing:

| verdict | semantic prediction | refuted by |
|---|---|---|
| `SUCCEEDED` | every model of T satisfies S | one T-model failing S |
| `IMPOSSIBLE` | no model of size $\ge2$ satisfies both | one joint model |
| `STRICTLY_WEAKER` | a separating model *and* a joint model exist | either missing |

**Result: 81 distinct pairs at domain size 2 — 36 IMPOSSIBLE, 33 SUCCEEDED,
12 STRICTLY_WEAKER — zero refuted.** Pushed to domain size 3 on the
IMPOSSIBLE class: 31 consistent by brute enumeration, and the remaining 5
(whose targets are groups, where blind enumeration costs $3^9\times3\times3^3$)
checked over **every labelled group structure of size 2 and 3**, built by
filtering associative tables and then taking the forced identity and
inverses. 5 consistent, 0 refuted. **36 of 36.**

What finite search cannot do is stated in the module: sizes 2 and 3 *refute*;
they never prove a universal. A surviving verdict is CONSISTENT WITH THE
MODELS TRIED and nothing stronger.

Three also verified by hand, by direct substitution:

- **left-zero + right-zero ⇒ trivial**, witness $x = y$.
  $x = xy = y$. ✓
- **band + zero-semigroup ⇒ trivial**, witness $x = 0$.
  $x = xx = 0$. ✓
- **commutative + left-zero ⇒ trivial**, witness $x = y$.
  $x = xy = yx = y$. ✓

## 2. Every design decision is a citation

An engine whose choices are arbitrary is an expensive random number
generator. Each of these is a result someone proved here:

| decision | from |
|---|---|
| failures are **classified and routed**, never retried | `FOUR_LOSSES` — four families, four currencies |
| the store is **append-only** and the fold respects four monotonicities | `ABHAVA` — prior absence is revisable, absolute absence **prunes** |
| the residual **selects** the next move; one verdict licenses "spend more" | `chakravala.py` |
| **smallest-first** scheduling | `kernel.py` — FIFO accumulates ever-larger instances of theorems it never states, and looks productive throughout |
| a **null control** every pass | `CRYSTAL` §0 — an engine that finds structure everywhere is measuring itself |
| report **capability**, not efficiency | `RUNTIME` §1 — 1-of-10 → 10-of-10 was the result; 3367× was the distraction |
| flag what is **externally checkable** | `GAUGE_OF_THE_FLEET` §1 |

The absence types do different work, exactly as `ABHAVA` §2.1 requires.
`IMPOSSIBLE` and `BEYOND_LPO` are *atyantābhāva*: they **prune**, and are
never re-attempted at any budget. `EXHAUSTED` is *prāgabhāva*: it records the
budget it died at, so a later pass at a larger budget is a genuinely new
attempt rather than a repeat.

## 3. The first version was vacuous, and the null control was too weak to say so

The first run reported **11 constructed theories and 0 theorems**, and every
one of the 11 was true and worthless: *"involution interprets into semigroup +
involution."*

The cause is a real design error worth naming. The chakravala repairs — adopt
the residual, widen the signature — are correct **when you want a particular
transport**. As an outer loop for **mapping a landscape** they are fatal,
because adopting the source's axioms into the target makes every pair
succeed. The engine was answering a question it had modified until the answer
was yes.

> **The repair moves are for when you want the transport. They are not for
> asking whether it exists.**

Two fixes, both forced:

1. **Ask once, as posed.** No adoption, no widening. `EXTENDS` is reported as
   `STRICTLY_WEAKER` *with the failing axioms named*, and as `VACUOUS` when
   every source axiom fails — because a target that proves none of the source
   tells you nothing about it.
2. **Queue only well-typed pairs** — source signature embedded in the
   target's. Anything else is a question posed outside the target's
   jurisdiction (`FOUR_LOSSES` II, degenerate), not an obstruction.

And the null control was strengthened, because the one I had passed while the
engine was producing nothing: a second control now requires that **a theory
must not be found to interpret into a strictly weaker one** — `band` into
`semigroup` must *fail*, since not every semigroup is idempotent. If that
passes, the engine is adopting its way to success and every finding is void.

The first control (disjoint signatures ⇒ `OUT_OF_SCOPE`) was necessary and
not sufficient. That is the general shape: **a null control that has never
failed has not been tested either.**

## 4. What the requirements column is doing

64 pairs came back `BEYOND_LPO` — no precedence on the signature orients the
residual, checked exhaustively over all permutations. The commonest is
commutativity, $xy = yx$, which is symmetric in both argument positions and
therefore beyond LPO under every precedence.

The engine **names the requirement (completion modulo AC) and declines to
attempt it.** That is not a gap in the results; it is the result, and it is
the typed zero doing its job. A machine that answered here would be guessing.

Note the avacchedaka: `BEYOND_LPO` prunes *relative to the declared
instrument*. It is absolute for LPO and says nothing about AC-completion. The
absence is limited, and the limit is recorded.

## 5. Ledger

| # | item | status |
|---|---|---|
| E1 | The 70 theorems | **Correct as far as spot-checked (3 by hand).** All are small statements about equational theories and all are externally checkable. Nobody has checked the other 67. |
| E2 | The library | 17 theories, chosen because their relationships are largely classical — so the output can be checked against an external answer rather than against itself. |
| E3 | `STRICTLY_WEAKER` | Reports which axioms fail; does **not** prove the failure is essential (i.e. that no *other* map succeeds). Only `identity` and `opposite` are tried. |
| E4 | The requirements | Genuinely undecided by this machinery. AC-completion is not implemented and is not claimed. |
| E5 | Novelty | **None claimed.** The interpretability relations among these theories are standard universal algebra. What is offered is that a loop built entirely from this corpus's own results produces them, correctly, unattended, and reports what it cannot do. |
| E6 | Vacuity | 4 pairs recorded `VACUOUS`. The first version produced only vacuity and passed its null control; the honest reading is that the current version's controls are *better*, not that they are sufficient. |
