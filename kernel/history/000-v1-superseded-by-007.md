---
id: 000
kind: rule
status: rule-active
supersedes: CLAUDE.md (v2)
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
5. **Submit for validity** under whichever of `002`/`003` is active.
6. **Close or spawn.** Discharge $g$, or spawn the obligations that remain.

**Self-application.** $g$ may be a statement about this file. Then the output
is a revised `000`, and the old one moves to `history/`. This is the only
mechanism by which the machine changes, and it is not privileged: it is
step 1–6 with the state as subject.
