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
5. **Submit for validity, and record WHICH RULE CLEARED IT.** Both `002` and
   `003` are rule-active: they detect disjoint and exhaustive error classes
   (`nodes/006`). Every node therefore carries

       cleared-by: [002 | 003 | 002,003 | none]

   with these standing consequences, which are not advisory:

   - `cleared-by: 002` alone — the derivation checks. It carries an **open
     obligation to be re-derived in another presentation**, because a checker
     accepts a frozen gauge (`nodes/001`'s $\varepsilon$ was well-typed).
   - `cleared-by: 003` alone — it survived independent re-derivation. It
     carries an **open obligation to be checked**, because conservation is
     evaluated inside a frame and cannot see a broken step.
   - `cleared-by: 002,003` — both classes cleared. This is the only
     unqualified clearance the machine has.
   - `cleared-by: none` — `status: proposed`. Citable as a proposal, never as
     a parent of a derivation.

   Absent the field, a node is `none`. Silence is not a clearance.
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
