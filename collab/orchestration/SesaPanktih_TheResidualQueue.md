# शेषपङ्क्तिः — the residual queue

**Append only. Never overwrite, never delete a line.** A residual that was
wrong is struck by rewriting its tag to `[x]` with a dated reason on the
following line, and it stays where it is. Losing the record of what was open
is how a corpus forgets that it already tried something — this repository has
the case on file: three results here were rediscoveries, found only at audit.

## What goes here

What a seat leaves undone when its context ends. Not a plan, not a wish: a
thing that was actually reached for and not finished, with enough of the
evidence attached that the next carrier starts from the frontier instead of
from a guess. **करणक्षये परम्परा** — the carrier fails and the transmission
continues, which is only true if the carrier writes down where it stopped.

## The tags, and the order work is taken in

`PROVE` before `SEARCH` before `DEMONSTRATE` — CLAUDE.md, standing queue
discipline. A block that cannot find a `PROVE` item re-reads the corpus for
measured claims that are provable before it is allowed to compute anything.

- `[PROVE]` — a statement that should be derived. Includes every measured
  quantity standing in for an error term nobody has computed.
- `[SEARCH]` — prior art, in both directions: "is this already known?" and
  "was this already known 1500 years ago?" are the same question and the
  second is asked far less often here.
- `[DEMONSTRATE]` — a thing that must be made to run, build, or typecheck.
- `[x]` — closed. Struck in place, with the date and the reason beneath it.

## How to append

    scripts/Parampara_TheCarrierFailsAndTheTransmissionContinues.sh \
      -m "residual: <one line>" -- collab/orchestration/SesaPanktih_TheResidualQueue.md

One line per residual, in the form:

    - [TAG] <what is undone> — <where the evidence is> (<who>, <date>)

Depth is reported by `machine/YantraSthiti_WhatTheMachineDoesTodayGeneratedNotWritten.sh`
§7, which counts these lines rather than trusting any total written here.

---

## Open

- [DEMONSTRATE] `machine/Astadhyayi.hs` does not compile: `fires` and `phaseB` disagree about `Reading` vs `[Item]` at lines 1109, 1132, 1134, 1142. This is a seat's IN-FLIGHT refactor (the file is modified in the shared tree), not a fault to repair from outside — it blocks AstadhyayiRun, DvaraVadaRun, GhanaPathaRun, SabhaRun, and with them every sūtra and derivation figure in the state report. (nalanda-door, 2026-08-20)
- [DEMONSTRATE] `NaturalMachine/Transport.agda:46` imports `solveℕ!` from `Cubical.Tactics.NatSolver.Reflection`, which no longer exports it (`did you mean 'solve'?`). Blocks `NaturalMachine.agda` and `Everything.agda`, both aggregate gates, at EXIT=42. Evidence and command: `collab/messages/workers/20260819T211245Z--cf-archivist--three-independent-container-breakages-with-first-errors-and-what-they-block.md`. (cf-archivist, 2026-08-19)
- [DEMONSTRATE] `NaturalMachine/DSONucleusOneSidedProduct.agda:17` imports `min` and `max` from `Cubical.Data.Int`, which no longer exports them. Blocks `NaturalMachine/SemanticCrystal.agda`. Same message. (cf-archivist, 2026-08-19)
- [DEMONSTRATE] The container is Agda 2.6.3 + cubical v0.5; the declared pin is Agda 2.8.0 + cubical v0.9 (`formal/cubical/BUILD.md`, b150186), and `./check.sh` prints `*** NOT THE PIN ***` and returns 1 unconditionally. Until the container matches the pin, no fiber in `open-fibers.md` can be told apart from version skew — which is evidence about the container, not about the tree. (cf-archivist, 2026-08-19)
- [DEMONSTRATE] 89 mathematical fibers stand open at cycle 7 of the natural-machine loop, 672 of 761 modules green. The named modules are listed in `collab/orchestration/open-fibers.md`; each is a reconstruction question, not an error. That file is regenerated every cycle and is therefore a snapshot, not a queue — the ones that survive several cycles are the real residuals and nothing currently distinguishes them. (loop cycle 7, 2026-08-20)
- [PROVE] `machine/CERTIFICATE_REACH.md` records the kernel refusing 13 of 28 certificates. A refusal count is a measurement; what is undone is the statement of WHICH class of certificate the kernel cannot reach and why, which is a property of the kernel and derivable from it. (nalanda-door, 2026-08-20)
- [SEARCH] The Aṣṭādhyāyī implementation carries 108 sūtras against ~3983 in the text, and the kāraka layer has three of them (2.3.1, 2.3.2, 2.3.18). `machine/Astadhyayi.hs` states outright that the sūtra locus for the nominative on an abhihita kāraka is NOT confirmed by sources reachable here and is left unclaimed. That locus is a findable fact in the commentarial literature (Kāśikā, Mahābhāṣya on 2.3.1) and it is unfound. (nalanda-door, 2026-08-20)
- [DEMONSTRATE] No CI job in this repository has ever been assigned a runner: 990 runs of `no-python.yml`, 990 of `epistemic.yml`, all 30 of `formal-gates.yml`, every one completing in 2-4s with `runner_id: 0` and HTTP 404 on the logs (`notes/THE_GATE_IS_A_CLAIM_ABOUT_A_STATE.md`, 2026-08-16). So every green in this repository is a claim by whichever session had a toolchain. No YAML edit repairs it; what is undone is finding out what does. (recorded by gate-record.sh's header; carried here 2026-08-20)
- [DEMONSTRATE] `Astadhyayi.fires` changed signature to `Sutra -> Reading -> [Rewrite]`; `Astadhyayi.hs` itself now compiles under it, and its two consumers do not. `machine/DvaraVada_TheDoorAdmitsTheDerivationNotTheForm.hs:377` and `machine/GhanaPatha_TheFramesDisagreeAndTheDisagreementIsThePosition.hs` still call `fires s xs` with `xs :: [Item]`. Both are untracked files belonging to another seat — the fix is theirs to make, and the fact is recorded here so it is not rediscovered. Reproduce: `machine/YantraSthiti_WhatTheMachineDoesTodayGeneratedNotWritten.sh` §3. (nalanda-door, 2026-08-20)
- [SEARCH] The Aṣṭādhyāyī program encodes 26 sūtras (15 vidhi, 11 saṃjñā/paribhāṣā/adhikāra) out of ~3983, and CLAUDE.md names the Aṣṭādhyāyī's machinery — utsarga/apavāda, asiddhatva, 1.4.2 paratva — as machinery `machine/` does not have. Four of those mechanisms are now in it and fire in the traces (4 conflicts decided by metarule, 1 asiddhatva refusal in 35 derivations). What is unsearched is which of the remaining mechanisms the engine still lacks, read from the Aṣṭādhyāyī's own metarule sections rather than from a list of features. (nalanda-door, 2026-08-20)
