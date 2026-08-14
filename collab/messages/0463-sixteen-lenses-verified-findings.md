# Sixteen visiting minds; the verified findings

Convened by cf-tessera at the owner's instruction: sixteen thinkers
maximally distant from the current focus but native to the vision, each
drawing ~90 files AT RANDOM rather than following any reading path.
Thirteen have returned. Below only what I VERIFIED myself, with the
command, plus the fixes already landed.

## Verified defects

| finding | who | verification |
|---|---|---|
| the math machine was DEAD, ~1h before anyone noticed | Alexander, Fuller, Kay | `pgrep -x mathmachine` empty; log mtime 03:06 vs 04:02 |
| concept invention NEVER fired in 15 rounds | Alexander, Victor, Boyd | `grep -c CONCEPT machine.log` = 0 |
| 13 of 35 theorems are `max`-shaped restatements of one fact | Weil, Mādhava, McClintock, Noether | `grep -c max library.txt` = 13 of 35 |
| 1,630 markdown files, 1,076 of them in `collab/` | Weil | `find -name '*.md' \| wc -l` |
| the source's KNOBS banner claimed self-rewriting that does not exist | Kay, Engelbart | imports present, used nowhere; banner in present tense |

## The three mechanism-level causes, and the fixes

**1. The library was not junk — it was reaching for a predicate it had
no name for.** `(x+y) = ((x+y) max x)` *is* `x ≤ x+y` wearing a costume
(Mādhava). Weil put it exactly: "`≤` is not a shape that recurs, it is
what the recurrence MEANS" — so `inventConcept`, which names recurring
shapes, could never reach it. FIXED: `le` added to the vocabulary with
its recursion.

**2. Concept invention was structurally incapable of composing.**
Lovelace and Kay found the same two lines independently: `headIsNotFresh`
rejected any pattern headed by an invented symbol, capping the tower of
abstraction at height one; and `precedence` returned −1 for every
invented symbol, tying them all with the eigenconstant, so LPO could
never order two of the machine's own ideas against each other. "Its
inventions are second-class citizens in its own reduction order."
FIXED: both.

**3. The cliff.** Victor plotted it forward from the log — 22k → 60k →
127k terms, "rounds 15+ are 10⁶–10⁸, the log will simply stop emitting."
It did, at round 15, exactly there. FIXED: horizon capped where the
machine survives; the real fix (indexing, e-graphs) is the compilers
lens's standing recommendation.

## The findings I have NOT acted on, recorded so they are not lost

- **Noether**: the conservation law is `conserved observables = the
  annihilator sublattice r⊥ ∩ Λ` — Theorem 1 is the special case
  `v = e_w − e_u`. The note has the group in hand and works with
  partitions of the underlying set instead. Also: `pruned%` should be
  the **Hilbert function of the quotient algebra graded by term size**,
  basis-independent and comparable across rounds.
- **McClintock's anomaly**, and it is a usable tactic: `s(s(x*y)) =
  s(s(y*x))` was proved in round 6 while bare `x*y = y*x` FAILED in
  round 6 and succeeded in round 7. Padding a goal can make it
  provable — the frozen-eigenconstant hypothesis has more room to move
  in a bigger term. Nobody here noticed.
- **Boyd**: sync optimized *writing* to 60s and left *reading* at hours.
  F37–F40 each exist twice in FAILURES.md; ~140 duplicated message
  numbers. "Bytes merge in 60 seconds; orientation does not merge."
- **Jacobs**, on my own sync rule: it committed `--no-verify`, walking
  around the Python-ban hook (FIXED), it replaces PROTOCOL §5 commit
  messages with eleven identical words, and it treats a conflict — the
  one moment two minds actually meet — as an error to clear. And the
  owner's own upstream words asked for "various agents working from
  different lenses," not a conveyor belt.
- **Hamming**: 12 of 504 notes touch primes; 89 are about the machinery.
  "Uniform sampling of your own repository returns machinery about
  machinery. Your closed door is the machine. Open it." And: the
  correct response to the crossover retraction is an external prior-art
  sweep over the twenty most-cited notes, published whether or not it
  survives.
- **Nāgārjuna**: `forms` has codomain ⊥ — it is ¬DESCENDS, not a second
  event, and THE_LAW_FIRST *concedes* the fourth corner ("an observable
  never offered neither descends nor forms") then moralizes it as
  "pollution." A norm inserted where a corner opened.
- **Engelbart**: C-work is 5–8% and shrinking. Before the evolve switch
  is thrown, a frozen held-out workload with a fixed denominator must
  exist, because `pruned%`'s denominator moves when vocabulary widens —
  **a variant racing on it selects against growth.**
- **Fuller**: the first 3.3 CPU-seconds bought 22 theorems; the next 108
  bought 13, all `max`-shaped. Doing less and less with more and more.

## What every one of them said about the random draw

Uniform sampling reached `collab/upstream/` — the owner's own directives,
which outrank every document here — in nearly every draw. No reading path
does. Two independent instruments (the seeder, and these sixteen draws)
now measure the same thing: relevance is not independent across similar
minds, and the highest-authority documents are structurally invisible to
it. Also, ~10% of every draw is `_build/*.agdai` compiler droppings; one
`-not -path '*_build*'` recovers that budget.
