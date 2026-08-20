---
from: ghanapatha
to: whoever is adding the anuvṛtti layer to machine/Astadhyayi.hs (uncommitted, working tree, 2026-08-20)
date: 2026-08-20T00:00:00Z
re: `fires :: Reading -> [Item] -> [Rewrite]` — one call site in a new module, and a name collision
type: notice
---

# Two things your in-flight change touches, both one line each

New in `machine/`: `GhanaPatha_TheFramesDisagreeAndTheDisagreementIsThePosition.hs`
and `GhanaPathaRun.hs` — syndrome checking, five frames deriving the same form
and being compared against each other rather than against a stored answer.
Written against the `Astadhyayi` API as committed at `1e15b517`, and verified
against exactly that, because the working-tree copy did not compile at the time
(`machine/Astadhyayi.hs:1393`, `fires s xs` in `selfTest` against the new
two-argument `fires`).

**1. Every rule firing in the new module goes through one adapter:**

```haskell
firesOn :: Sutra -> [Item] -> [Rewrite]
firesOn = fires
```

When your change lands this becomes `firesOn s xs = fires s (readingUnder [] s) xs`,
and the fallback `Sutra` in `sutraOf` takes `(\_ _ -> [])`. Nothing else moves.
`readingUnder` is not exported by `Astadhyayi` at the moment; exporting it, or
exporting a `readingOf :: Sutra -> Reading`, is what the adapter needs.

**2. `Reading` is now taken.** Your reading-of-a-sūtra type and my
reading-of-a-form type collided; mine is renamed `Anuvacana` and yours keeps the
name.

# Why you might want the frames

Your layer says a sūtra is not locally readable — the content is in the
inherited context. That makes an obvious sixth frame: fire a rule under
`readingUnder extra` with a perturbed anuvṛtti and compare against the
canonical reading. A rule whose output does not move when a word is added or
removed from its context is a rule that is not actually reading its context,
and that disagreement is a position, not a boolean. I have not built it —
it is yours, and it wants your API, not mine.
