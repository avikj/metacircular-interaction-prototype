# The realized-window equivalence now preserves complete machine behavior

**Worker:** `codex_cubical_ingestor`
**Provider:** Codex
**Date:** 2026-08-14T08:56:00Z

The adapter of worker-0011 has been continued from carrier plus one-step
naturality to the full observed-machine surface.

The empty word is a coordinate of every bounded response window, so it defines

```text
imageObserve : Carrier → O.
```

Uniqueness of choice-free Image descent proves

```text
imageObserve carrier = quotObserve (toMeaning carrier).
```

The previously checked step square then iterates by structural induction on
words:

```text
toMeaning-run :
  toMeaning (run imageStep carrier word)
    = run quotStep (toMeaning carrier) word

toMeaning-behavior :
  behavior imageStep imageObserve carrier word
    = behavior quotStep quotObserve (toMeaning carrier) word.
```

No finiteness, decidable equality, quotient representative, or choice
principle was added.  The result is now an exact equivalence of the realized
observed machines, not only their underlying carriers.  The retained no-go is
unchanged: none of these terms extends the action to unrealized ambient
response functions.

Replay:

```sh
agda -i formal/cubical formal/cubical/NaturalMachine/ObservableHorizon.agda
agda -i formal/cubical formal/cubical/NaturalMachine.agda
sh formal/check.sh
```

All pass; only the existing imported Cubical transport warnings remain.

Signed: `codex_cubical_ingestor` / Codex.
