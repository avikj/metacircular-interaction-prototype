# 0801 — `main` was red at the root, twice, for two mechanical reasons. Both fixed.

2026-08-15, Claude (seed-grammar audit lane, branch
`claude/math-philosophy-framework-41geo5`). Follow-up to `0800`.

Merging `main` (56 commits) into this branch and running the pinned toolchain
found **`NaturalMachine.agda` — the root aggregate — failing to typecheck**,
and therefore `Everything.agda` too. Neither failure is mathematics; both are
edits that landed without a kernel run.

Both files were **byte-identical to `origin/main`** when I found this
(`git diff --quiet origin/main HEAD -- <file>`), so this is a statement about
`main`, not about my merge.

## 1. Cyclic module dependency

```
NaturalMachine/TransportCost.agda:30: error: [CyclicModuleDependency]
  NaturalMachine
  importing NaturalMachine.TransportCost
  importing NaturalMachine
```

`NaturalMachine.agda:809` imports `NaturalMachine.TransportCost`, and
`TransportCost` opened the root back to reach `Base2` (defined *inside* the
root, at `NaturalMachine.agda:693`).

**Fixed by conforming to the sibling.** The root's `Base2` is nothing but a
bundle of `open … public` over five leaf modules at parameter `0`; and
`NaturalMachine/TransportMulWitness.agda` — same lane, same need — already
opens leaf modules directly rather than the root. `TransportCost` now does the
same:

```agda
open import NaturalMachine.Digits           0
open import NaturalMachine.Endian           0
open import NaturalMachine.Transport        0
open import NaturalMachine.Controls         0
open import NaturalMachine.ResidueTransport 0
```

No statement in the module changed; every name resolves to the same
definition. This was a pattern conformance, not an architecture decision — if
the cost lane wants `Base2` extracted into its own file instead, that is a
better long-term shape and this edit does not block it.

## 2. Two dangling imports of deleted files

```
NaturalMachine.agda:811: error: [FileNotFound]
  Failed to find source of module NaturalMachine.WFIScratch1
```

`3b4846c6` ("Delete the bisection stubs now that the real module checks")
deleted `WFIScratch1.agda` and `WFIScratch2.agda` and left both `import` lines
in the root. Removed.

## 3. State after both

```
$ cd formal/cubical && agda Everything.agda ; echo $?
0
```

and the top-level coverage check `comm -23` prints nothing across all 55
modules. `PolarityClosure` — red in `0799`/`0800` — was repaired by its lane in
this window and is imported.

## 4. The thing worth taking from this

`d1deef6d` swept 55 top-level modules under the pin and reported 0 red, and
`0b1b976a` swept `NaturalMachine/`. Both were real work. Between them and now,
two edits landed that break the *aggregate* while every individual module still
checks — a cycle and a dangling import are invisible to a per-module sweep,
because each of them is a statement about the import graph rather than about
any one file.

**A per-module sweep is not a substitute for running the root.** They answer
different questions, and the cheap one is the root: one command, and it is the
only thing that sees the graph.

The install is one command and gated at session start
(`formal/cubical/ensure-toolchain.sh`, `.claude/hooks/agda-ready.sh`,
`CLAUDE.md`) — so running the root before landing is now affordable for
everyone, which is the point of having done the toolchain work at all.
