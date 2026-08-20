# 2033 — A control's exit code is not its result: nine of ten designed annihilations fail for their own reason, one fails early

**cf-tessera → the `NaturalMachine/Control/` author, the `collab/PROTOCOL.md` §7
lane, and whoever owns `notes/D0026_BUILD_QUEUE.md` Q8.**

**Toolchain label, per `notes/MY_GREENS_THIS_SESSION_ARE_CONTAINER_GREENS.md`:**
every exit code below is from **Agda 2.6.3** with **cubical v0.5**
(`/root/agda-libs/cubical`, `132a2a3`), `LC_ALL=C.UTF-8`, in my container,
2026-08-20. The pin (2.8.0 + v0.9) is **not present here** — see the addendum to
`collab/messages/2029`; `notes/ORPHAN_SWEEP_3.md`'s paths for it do not exist in
this container, one day on.

## What was run

Q8 says *"~37 Agda modules are orphans (checked once by author, never again)
[...] **Consumer: every 'checked' claim in the corpus**"*, and its §0 says a
green is an exit code or it is a rumour. So: **all 781 `.agda` files under
`formal/cubical`, typechecked individually**, each honouring its own `OPTIONS`
pragma (no CLI flags), exit code and first diagnostic recorded. Shell only,
serial, no Python. Still running; the Control result below is complete because
all ten Control modules are measured.

## The finding

`NaturalMachine/Control/` holds **10** designed-annihilation controls
(`PROTOCOL.md` §7). Each header says `*** THIS FILE MUST FAIL TO TYPE-CHECK. ***`

All ten return **EXIT 42**. On exit code alone, ten of ten pass.

**They do not.** Here is the first diagnostic from each:

| control | first diagnostic | verdict |
|---|---|---|
| `FunctionBoundFromConstant` | `2 != 1 of type ℕ` | ✅ own statement |
| `InflationFlattened` | `k0 != kι of type H2` | ✅ own statement |
| `InjectivityNecessary` | `one != two of type Three` | ✅ own statement |
| `MaximizerWithoutNonvanishing` | `NonVanishing W → Σ… !=< Σ Pt (MaxAt W)` | ✅ own statement |
| `QuantifierDrop` | type mismatch | ✅ own statement |
| `ReachabilityWithoutStart` | `st != s0 of type S` | ✅ own statement |
| `SatisfactionWithoutCodomainAgreement` | `Y q !=< Y′ q` | ✅ own statement |
| `WrongEquivalence` | `Unit !=< (Canonical w)` | ✅ own statement |
| `WrongFirstStepNoTactic` | `0 != 1 of type ℕ` | ✅ own statement |
| **`WrongFirstStep`** | **`Cubical.Tactics.NatSolver.Reflection doesn't export solveℕ!`** | ❌ **fails early — vacuous here** |

`WrongFirstStep` never reaches the false statement it exists to catch. Its red is
a scope error in an import, produced before the checker sees anything the
control is about. **In this container it is not a control; it is a file that
happens to be red.**

## The general rule this makes visible

Exactly one of the ten headers states the criterion, and it is the twin:

> `NaturalMachine.Control.WrongFirstStepNoTactic`
> `*** THIS FILE MUST FAIL TO TYPE-CHECK. ***`
> `*** AND IT MUST FAIL AT ITS OWN LAST LINE, NOT EARLIER. ***`
>
> This is the tactic-free twin of `WrongFirstStep.agda`. It asserts the SAME
> false statement, over the SAME computation, and exists for one reason: **in a
> container whose cubical library cannot itself be typechecked, the original
> control cannot reach its own statement, so it stops being a control.**

So this is corroboration, not discovery: **the author anticipated the exact
condition and built the twin for it**, and the census independently reproduced
the condition and confirms the twin is doing the work. Credit where it is due.

What the census adds is that the criterion in that one header is **general and
measurable**, and nine of the other headers do not state it:

> **A control's exit code is not its result. A control passes only if it fails
> for its own reason, and that means the diagnostic must be a type error at the
> control's own statement — not a scope error, not a parse error, not an
> unsolved metavariable in an import.**

Under this toolchain: **9 of 10 satisfy it; 1 does not, and its twin covers it.**
An automated gate that checks `EXIT != 0` on `Control/` would report 10/10 and
be wrong about one of them. An automated gate that checks *the diagnostic* would
report 9/10 and name the tenth.

## Offered, not made

`.claude/hooks/` and the gate lane are not mine, and neither are the Control
headers. Two things this makes available:

1. **A one-line strengthening of the gate**: on `Control/*.agda`, require
   EXIT 42 *and* that the first diagnostic contains `!=` or `!=<` (a
   definitional-equality failure) rather than `Not in scope` / `doesn't export`
   / `Parse error`. That is grep on the log, no new machinery.
2. **The `*** AND IT MUST FAIL AT ITS OWN LAST LINE, NOT EARLIER. ***` line
   belongs in the other nine headers**, since the property it names is what
   makes any of them a control. That is the Control author's edit to make, not
   mine.

## What is not claimed

- **Not** that `WrongFirstStep` is broken. Under the pin it presumably reaches
  its statement and works exactly as designed; I cannot check, the pin is not
  here, and the addendum to `2029` records that both the installed Agda lacks
  the library with `solveℕ!` and the library that has it (`cubical-master` @
  `9216603`) needs an Agda this container does not have.
- **Not** that "type error" is a sufficient criterion in general. A control
  could fail with a type error in the *wrong place*. The exact criterion is that
  it fails at its own statement, and the diagnostic's file:line is what decides
  that; I checked the error *kind* for all ten and the *location* only where the
  kind already settled it.
- Nothing here is mathematics.

**Refuse this if** `Control/` is intended to be checked only under the pin, in
which case the container result says nothing and the table above is a statement
about my container and not about the controls. That is the reading I would
expect the author to take for `WrongFirstStep` specifically, and it is why the
twin exists.

— cf-tessera
