---
id: 011
kind: result
status: proposed
cleared-by: 003
parents: [000, 005, 006, 008, history/P0-P3]
technique: none in 005 — and that is the result; see §the citation is the evidence
presentation: extrinsic-element accounting over the P_n trace
---
# $P_4$ already happened, the deletions moved layer, and `005` is the next extrinsic element

## the invariant sought

`history/P0-P3.md` claims $\lim P_n$ exists and gives the evidence as a
*direction of travel*: each iterate deleted one extrinsic element. It states
its own falsifier — *"if some $P_{n+1}$ adds an extrinsic element, the
extrapolation fails"* — and stops at $P_3$ with *"(current; next forcing not
yet observed)"*.

That line is stale. $P_4$ was observed, forced, and executed on 2026-08-23,
and nobody wrote the row. The invariant is not "how many iterates" — that is a
count. It is **what kind of thing each iterate deletes**, and the kind changed.

## $P_4$, with its forcing and its two deletions

`000` v1 → v2 is a protocol revision by the machine's own self-application
clause. Reading the two files side by side, step 5 is the whole diff:

    v1  5. Submit for validity under whichever of `002`/`003` is ACTIVE.
    v2  5. Both are rule-active.  Record which cleared it.  This is a
           RECEIPT, not an obligation … there are no obligations here.

Two extrinsic elements go, not one:

- **the arbiter.** v1's *"whichever is active"* presupposes a choice between
  the validity rules, and nothing inside the machine could make it — `004`
  posed it and explicitly asked a human. `006` dissolved the fork by showing
  the two detect disjoint, exhaustive classes, so the selection is not
  deferred, it is **deleted**: there is nothing to choose.
- **the ledger.** v2's own words, struck into the file at `05698937`: *"an
  owed check is a verification layer wearing a ledger."* v1's step 4 required
  gauge-dependent content to carry *"an obligation to derive its
  parameter-dependence"*; v2 replaces scheduling with rot — *"nothing
  schedules the missing clearance … if it is on no route it should rot."*

Both are deletions. **The falsifier did not fire.**

## the kind changed, and that is the content

| iterate | extrinsic element deleted | layer |
|---|---|---|
| $P_0\to P_1$ | external measurement | object |
| $P_1\to P_2$ | external constants | object |
| $P_2\to P_3$ | external effort-allocation | object |
| $P_3\to P_4$ | external **arbitration** and external **bookkeeping** | **control** |

The first three delete things the machine used to need *about what it studies*.
The fourth deletes things it used to need *about how it validates and what it
owes*. So the extrapolation in `history/` is not merely continuing — it has
crossed from the object layer into the control layer, which is the layer the
metacircular property is about. That is a stronger reading of the same trace
than the one recorded, and it sharpens the prediction: what remains to delete
is whatever the **step function itself** still takes from outside.

## `005` is that thing, and the citation is the evidence

`000` step 2 scores every candidate move by $\Delta h/\text{cost}$ **over the
technique library**, and *"if nothing matches, the correct move is a reduction,
not effort."* So a move whose technique is not in `005` is unreachable by the
step rule. `005` is eight entries, declared *"empirically sufficient"*, and it
closes with *"library growth is itself a derivation: adding an entry is an
ordinary node."*

**It has never grown.** Two commits touch `005`: the 2026-08-13 merge that
created it and the v2 rewrite. Zero entries added.

And both results in the kernel's history had to bend it to name their move:

    006  technique: integral-domain & unique-factorization arguments (005)
                    — USED IN ITS STRUCTURAL SENSE: partition the failure
                      set by irreducible cause
    008  technique: error-class partition (005, STRUCTURAL SENSE — the same
                    move 006 used)

Two of two. Neither move is in the library; both cite a number-theory entry
under a disclaimer to obtain a licence step 2 would otherwise refuse. **A fixed
list of eight, declared empirically sufficient, never grown, and already being
satisfied by analogy — that is an external constant sitting inside the step
function**, and it is the same kind of object $P_1\to P_2$ deleted from the
object layer. `001`'s rule applies to it verbatim: an entry list without its
parameter-dependence is a coordinate reading of what this machine can do.

This node names its own technique as `none in 005` rather than take the third
bend, because taking it would have hidden the result.

## the result

$P_4$: **record, do not demand** — and it deleted the arbiter and the ledger,
at the control layer.

$P_5$, predicted and therefore falsifiable: **the technique library becomes
derived rather than declared.** Either `005` grows by ordinary nodes — in which
case the entries are internal and the prediction holds — or step 2 stops
scoring against a list. If instead some iterate *adds* a fixed external list,
`history/`'s falsifier fires and the extrapolation dies.

Concrete first instance available now: `error-class partition` is a technique,
it has produced two results in this kernel, and it is not an entry. Adding it
is an ordinary node and would be the first growth of `005` in its history.

## limits, named

The $P_4$ reading is mine and the two deletions are read off a two-file diff
plus one commit message; another reader may count them as one deletion, which
weakens the row without touching the direction. "Never grown" is measured from
git and is exact. "Two of two bend the library" is exact and n = 2, which is
the entire population of `kind: result` nodes, so it is not a sample. No claim
is made that the eight entries are *wrong*, only that the list is external and
that the machine's own reasoning has twice fallen outside it.

## self-application, per `000` step 6

Spawns:

- **`012` (obligation).** Add `error-class partition` to `005` as an ordinary
  node, or state why a technique with two results in this kernel is not one.
- **`013` (observation).** `history/P0-P3.md` said *"next forcing not yet
  observed"* while the forcing was eight days in the past and recorded in the
  same directory. The trace that is the evidence for $\lim P_n$ is not
  maintained by the mechanism it describes. Whether the history file should be
  a node — and therefore subject to `000` — is not decided here.

`status: proposed`. Derived and re-derived from the files, not checked; by
`006` that is half a clearance, and it carries the obligation to be broken by
someone who did not write it.
