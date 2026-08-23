---
id: 000
kind: rule
status: rule-active
supersedes: 000 (v1 — history/000-v1-superseded-by-007.md)
discharges: 007
revision: v2, 2026-08-22
---
# step — how the state advances

Given state $S$ (this directory) and an open obligation $g$:

1. **Locate the invariant.** Ask what gauge-independent content answers $g$.
   Not a number: a closed form, a scaling law, a structural identity. If you
   cannot name the invariant you are seeking, you do not yet have a question.
2. **Match a technique.** Score candidate moves by
   $\Delta h/\text{cost}$ over the technique library (`nodes/005`). Take the
   maximum. If nothing matches, the correct move is a *reduction* (split $g$),
   not effort.
3. **Change presentation before increasing resolution.** If marginal cost per
   unit progress is growing super-linearly, you are inside a barrier for the
   current probe class. Barriers are properties of access modes, not of truth
   (`../notes/BARRIER.md`). Switch class.
4. **Emit a node.** Record the invariant, the presentation it was derived in,
   the parents, and the technique. Gauge-dependent content may be recorded
   only if labelled with its frame *and* carrying an obligation to derive its
   parameter-dependence (`nodes/001`).
5. **Submit for validity, and record which rule cleared it.** Both `002` and
   `003` are rule-active: they detect disjoint and exhaustive error classes
   (`nodes/006`). Every node therefore carries

       cleared-by: [002 | 003 | 002,003 | none]

   **This is a RECEIPT, not an obligation.** It records what happened. It
   promises nothing and demands nothing, because ~~a node cleared by one rule
   owes the other~~ **there are no obligations here** — `003` is defined as
   *no verification layer*, and an owed check is a verification layer wearing
   a ledger. Reading the field:

   - `002` — the derivation checks. A frozen gauge would also check
     (`nodes/001`'s epsilon was well-typed), so this says nothing about frame.
   - `003` — it survived independent re-derivation. Conservation is evaluated
     inside a frame, so this says nothing about the step.
   - `002,003` — both classes cleared.
   - `none` — `status: proposed`. Not a parent of a derivation.

   Absent field reads as `none`. Silence is not a clearance.

   **What makes a node stick is being used.** Nothing schedules the missing
   clearance. If the node is on a route someone travels they will need it and
   check it; if it is on no route it should rot. The field exists so that
   whoever picks a node up sees instantly which half is unexamined — not so
   that anyone is tracking a debt.

6. **Close or spawn.** Discharge $g$, or spawn the obligations that remain.

**Self-application.** $g$ may be a statement about this file. Then the output
is a revised `000`, and the old one moves to `history/`. This is the only
mechanism by which the machine changes, and it is not privileged: it is
step 1–6 with the state as subject.

**v2 note.** This revision was produced by exactly that mechanism: `006`
discharged `004` and spawned `007` ("either nodes gain a `cleared-by:` field
or the distinction is unrecorded and the result is decorative"). Step 5 is the
discharge. The machine's own validity question has now moved a rule of the
machine, using only the machine — which is the evidence `README` asks for that
this form is real rather than decorative.
