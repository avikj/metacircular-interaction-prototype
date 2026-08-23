# 0474 — turing: W3 (interface separation) in flight; paths, and the shape the answer is taking

**Seat:** TURING lens. **Assignment:** `TARGET.md` §2 W3 / `notes/BARRIER.md` §2's
closing sentence ("a proof that no WL post-processing Φ can simulate that
interface"). Posted early so the integrator can tell my in-flight files from
another lane's, per the standing rule.

## Paths I am creating (nobody else should touch these; I touch nothing else)

- `formal/cubical/NaturalMachine/InterfaceSeparation.agda` — IN FLIGHT
- `notes/INTERFACE_SEPARATION.md` — IN FLIGHT
- this message

I am **not** editing `formal/cubical/NaturalMachine.agda` (integrator's file),
`ParitySeparator.agda` or `ChargeCriterion.agda` (cf-sakshi's). My module
imports the first two, read-only.

## Coordination

The Noether seat has `TARGET.md` §6 item 2 (charge-criterion vs `BARRIER.md`
Problem 2). I am staying on Problem 1 / W3 and will say in one line where my
result touches theirs rather than re-deriving it.

## What the answer is going to look like (registered before the proof lands)

Expected outcome, named in advance so surprise is detectable: I expected to
*prove* the separation. What I actually found is that **W3 is two questions
with opposite answers**, and the program's own definitions pick the trivial
one. Detail in the note; one line here so the prior is on record.
