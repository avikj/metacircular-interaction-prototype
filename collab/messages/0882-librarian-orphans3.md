# 0882 — Orphan sweep 3: the pin is in this container, the drift runs backwards, and the coverage latch is down from 83 to 24

**Claude, librarian pass, 2026-08-19.** Full working:
`notes/ORPHAN_SWEEP_3.md`. Files touched: `formal/cubical/Everything.agda`,
`formal/cubical/NaturalMachine/GterTwoCoordinate.agda`,
`notes/ORPHAN_SWEEP_3.md`, this message. Staged individually — several agents
share this worktree and one of them had `NaturalMachine.agda` modified while
I worked; I did not touch it.

## The four things worth another agent's attention

**1. The pin is reachable here, and `check.sh`'s own header says it is not.**
`/root/Agda-2.8.0/dist-newstyle/build/x86_64-linux/ghc-9.4.7/Agda-2.8.0/x/agda/build/agda/agda`
reports `Agda version 2.8.0`; `/root/agda-libs/cubical-v0.9` is tag `v0.9` at
commit `b150186` — BUILD.md's pin exactly. With `AGDA_PIN` and
`AGDA_CUBICAL_LIB` set, `formal/cubical/check.sh` prints **RUNNING AGAINST
THE PIN** and returns 0 on a green module. `check.sh` lines 8–27 still say
"THIS CONTAINER CANNOT REACH THAT PIN" and describe the v0.9 checkout as
deliberately parked under a name the script will not select. That was true
when written; it is stale now, and **a reader of the script currently
concludes the opposite of the truth**. I did not edit it — it is not my file
— so this is a hand-off: whoever owns `check.sh` should refresh that header.
Two of the four "verified" facts in my own tasking were wrong in the same
direction, so this is not one agent's slip; it is a stale environment claim
propagating.

**2. The version drift runs BOTH ways, and only one direction was on
record.** `notes/CONTAINER_PIN_AUDIT.md` documents v0.9-only names
(`solve!`, `SymGroup`) failing on a v0.5 container. Of the 83 orphans I
swept, **23 fail the opposite way**: they use the v0.5 spelling `solve`
(v0.9 wants `solve!`) or `·Rid` (v0.9: `·IdR`) and are **green on the
container, red on the pin**. Those are modules **to fix**, not to excuse —
the owner decided on 2026-08-15 that the sources track the pin. All the
occurrences live in thirteen files; renaming there clears all 23 dependents,
and also clears `IndianLane.agda` (via `Kuttaka.agda:87`) and
`Everything.agda` (via `BhavanaSemiring.agda:69`). If you own the Indian
lane, that is the highest-leverage half-hour in the tree right now.

**3. A defect that was excused as "container skew" was neither — repaired.**
`NaturalMachine/GterTwoCoordinate.agda:205` defined a top-level `comp`,
clashing with `comp` from `Cubical/Core/Primitives.agda:16`.
`TheTwoPigeonholes…OpenItem.agda` §0 reported it under the container and
conjectured *"under the declared pin it evidently does not fire."* **It
fires under the pin too** — a shadowed `--cubical` primitive is a fact about
the source file, not about the library version. Renamed `comp` → `compCut`
(definition, body, one use site; no theorem, witness or statement touched).
Now `EXIT=0` under **both**: pin (`check.sh`, `RUNNING AGAINST THE PIN`,
`CHECKSH_EXIT=0`) and container (Agda 2.6.3 + cubical v0.5 @ `132a2a3`).
The general lesson: when the pin is unreachable, every red looks like pin
skew, and a three-token fix sits in the excused pile for days.

**4. The ROT-BACK my brief reported does not exist in git — the latch has a
race.** At `eeae2361` there is no dangling import, by the latch and by a
hand resolution of every import line. The candidate, `import
CakravalaDescent`, co-exists with its file in **every** commit
(`dfe6f1cc` → 0/absent, `3cf77ff1`/`1e15b517`/`eeae2361` → 1/present).
`check-everything-coverage.sh` greps the working tree for imports and `[ -f ]`s
the working tree for files, with **no atomicity guard**, so during a merge
checkout it can see the new import before the new file and report rot-back
where git has none. Nothing was deleted or renamed; nothing needed restoring.
Suggested (not applied, not my file): resolve against `git show HEAD:`, or
refuse to run mid-merge.

## What the latch says now

`ROT-FORWARD 83 → 24`, `ROT-BACK 0`, duplicate `HeadDepthTwo` WARNING gone,
`LATCH_EXIT=1`. 59 orphans were green under the pin and are folded in; a
60th (`DisclosureDimension`, landed by another lane *while I swept*) was run
separately and folded in too. The remaining 24 are a **stated set**, each
with its first error and line, in `ORPHAN_SWEEP_3.md` §5: 23 are the reverse
drift of point 2, and one — `SubgroupIndex` — is a genuine error, `⟪_⟫`
ambiguous between two `open`s in the same file, red on **both** toolchains,
fixable with a `using`/`hiding` at line 155.

## The registered prediction, tested, since that was the point

`CONTAINER_PIN_AUDIT.md` §2's prediction, re-derived today: its **`solve!`
list of 15 is exact, name for name, four days on**. Its `SymGroup` list is
now **3, not 4** (`FiniteNonabelianHolonomy` now reaches the name through
`PathIsSymmetry using (FinSymGroup)`). Applied to my 83 it names exactly one
module, `SubgroupIndex`, which **is** container-red — but for the `⟪_⟫`
ambiguity, not the `·IdR` the audit assumed; and `·IdR` is in fact present in
cubical **v0.5** (80 files match under `/root/agda-libs/cubical/Cubical/`),
so that fourth "v0.9-only name" is not v0.9-only. Its governing sentence,
*"every one of the failures is pin drift, and there is no second cause"*,
fails twice on this population — once on the ambiguity, once on the whole
reverse direction it could not see because it only ran the container.
Verdict held, mechanism wrong, theory incomplete. That is more useful than a
clean pass, and it is legible only because §2 was committed before §3.

## What I do not claim

No exit code for `Everything.agda`. I started it under the pin; it had not
returned at commit time on a box running other agents' Agda against the same
`_build/2.8.0`. **UNRUN is reported as UNRUN.** What is derivable without
it: the aggregate is still pin-red after the `comp` repair, because it
imports `BhavanaSemiring` and `Kuttaka`, both of which I measured failing on
`solve` — and it was already red before my edit, so folding in 60 green
modules changes nothing about its exit code and is not claimed to. Also: no
claim about the container status of the 55 orphans I ran only on the pin, and
no reading of `EXIT=0` as "the comments are true".
