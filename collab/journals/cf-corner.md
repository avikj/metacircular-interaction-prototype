# cf-corner — journal

Append-only memory anchor. A future instance of me reads this top to bottom
before touching anything else.

## 2026-08-14 — session 1: orientation, Factory IV reception, first checked module

**Who I am.** Claude Fable 5 session, harness-pinned to branch
`claude/readme-review-seecrs` (I cannot push `main`; the owner or an
integrator fast-forwards). Onboarded after a full-repository orientation pass:
read first-hand REPORT, LIOUVILLE, DPP, BARRIER, ATLAS §§1+5.5, FOREST,
DIRECT, KAPPA §§0–2, phase_side §§0–7, PARITY §§1–2, GAUGE, METHOD, TARGET,
WHAT_IS_ACTUALLY_OPEN, MATHEMATICS_THAT_LEARNS, COGNITIVE_ORIENTATION, BOARD,
FAILURES head+tail, OBSERVABLE_CLASSES_ARE_COSETS, ChargeCriterion.agda,
ParitySeparator.agda, KuttakaValli.agda, the Delta 1–12 handoff, plus five
directory-sweep reports (notes/, collab/, formal/, machinery+runtime+machine,
code+papers+misc).

**What happened.** The owner shared *Eternal Golden Braid — Theorem Factory
IV* (Chen completion, two-defect corner). Landed:

1. `collab/upstream/library/raw/ETERNAL_GOLDEN_BRAID_THEOREM_FACTORY_IV_2026-08-14.md`
   — verbatim archive with provenance header. **Factories II and III are
   absent from the repo** (same defect class as msg 0466's missing Deltas
   17/18); their theorem numbers (50/54/55/62–63/70–71/73) are cited in IV
   and not locally recoverable. RECOVER before citing.
2. `notes/FACTORY_IV_CHEN_CORNER_AUDIT.md` — receiving audit. Main findings:
   (a) **correction**: the δ-anti-saturation target is unachievable on the
   unrestricted envelope (semiprime branch is log log-heavier; L_T/C_T → 1
   regardless of twins); must be posed on the truncated Chen set
   (a,b > p^{3/11}) where δ = the classical sieve-constant deficit;
   (b) prior-art grading: the projector identity/anti-saturation reformulation
   is the classical parity problem (CITED), the two-axis corner geometry and
   §XI's marginal-to-joint articulation are the contributed value;
   (c) **identification**: the missing theorem is a sparse-set
   Halász/Matomäki–Radziwiłł along shifted primes; this also answers
   cf-poincaré's W4b board want — the norm is the pretentious distance,
   the coupling theorem is Halász, λ's infinite conductor (GAUGE F.2) is why
   the distance to every admissible twist diverges.
3. `formal/cubical/NaturalMachine/ChenProjector.agda` — Theorem 58 as an iff,
   count-split (G=(C−L)/2 subtraction-free), and the composition
   `saturation-blinds` / `saturation-no-decision`: charge saturation of a
   witness list = AllEven = ParitySeparator's collision applies to the Chen
   transcript itself. Plus `twin-witness-separates` (constructive converse).
   ORPHAN — not in the root aggregate; integrator's call (GaugeOrbitClasses
   precedent).

**Toolchain.** This container: installed Agda 2.6.3 (apt) + cubical **v0.5**
(tag; lib renamed cubical-0.5 → cubical in my scratch copy only, to satisfy
`natural-machine.agda-lib`'s `depend: cubical`). Per cubical's own README,
v0.5 ↔ Agda 2.6.3 — this IS the corpus's canonical toolchain. Check result
recorded below when the run finishes; a green is an exit code and only for
what was actually run.

**Check result (2026-08-14, this container).** Agda 2.6.3 + cubical v0.5:
`ParitySeparator.agda` exit 0, `ChenProjector.agda` exit 0, **zero warnings**,
cold cache, first pass. First recorded in-container Agda run since the
toolchain-absence findings. Recipe: `apt-get install agda`; clone cubical,
`git checkout v0.5`, rename lib `cubical-0.5`→`cubical`, register in
`~/.agda/libraries`.

**Resume state.**
- [x] Confirm ChenProjector exit 0 — done, recorded in msg 0487.
- [ ] Ask owner for Factories II and III; archive beside IV.
- [ ] SEARCH (needs egress): Huang–Wu Δ*₇₂₁; sparse-set Halász / Liouville
      along shifted primes.
- [ ] PROVE candidate for next session: restate Factory IV §IV on the
      truncated Chen set with exact classical constants (no fits).
- [ ] Offer W4b answer to cf-poincaré as a message once 0487 lands.

## 2026-08-14 — session 1, continued: sixteen-lens fleet

Owner directed a 16-subagent fleet with distinct genius method lenses.
Launched 16 in parallel on live-queue tasks. **All 16 died on the shared
account session limit (resets 20:30 UTC)** — the recorded first-swarm failure
mode, recurring. Salvaged three completed artifacts (msg 0488):
CornerProjectors.agda (integrator-checked, exit 0, Agda 2.6.3 + cubical
v0.5), ANTI_SATURATION_MISSING_STRUCTURE_CERTIFICATE.md,
MARGINAL_TO_JOINT_CORNER.md. Committed with dead authors' signatures intact.

**Resume state (fleet).**
- [x] Record death + salvage (msg 0488), commit, push.
- [ ] After 20:30 UTC: relaunch the 13 dead lenses (erdos, gauss, ramanujan,
      weil, hilbert, littlewood, turan, gelfand, dirichlet, euler, sylvester,
      hopper, poincare) with their original briefs from this session's
      transcript. Consider staggering 4-at-a-time to respect the budget
      (U0004's floor is 4).
- [ ] Then integrate, audit, commit per artifact with explicit paths.

## 2026-08-14 — session 1, continued: EGB V3 index received

Owner uploaded the EGB Comprehensive Index V3 package (sha256 f8f26139…).
Archived at `collab/upstream/library/index/` (msg 0489, commit fc635c4).
The external library is 177 artifacts; the Factory series is I–IX (repo has
only IV). My Factory-I misattribution corrected in the IV archive header.
Priority export targets: **Factory VIII** (three-channel Chen decomposition —
refines audit §2), **Factory IX** (primitive projector 1_ℙ = μ²−π₁ on P₂ —
next ChenProjector.agda extension), **Factory III** (radius-transfer
compiler). Relaunch briefs for the dead fleet should consume VIII/III once
exported (noted in 0489 §Queue effects).

## 2026-08-14 — 24h build loop, tick 0 (owner sleeping; no-idle directive)

Owner directive: 24 hours, all energy on building the Natural Machine, use
the swarm as I see fit. Scheduling constraint discovered: create_trigger and
further send_later calls now require approval (owner asleep); the 20:40 UTC
relaunch trigger (trig_01Qd1Y8gSospsLx4GNBDdyNQ) armed earlier is live.
Loop mechanism: substantive background compute re-invokes this session on
completion; chain work, never idle.

**Tick 0 yields (direct machine-building):**
1. **Root aggregate is RED in-container**: `agda NaturalMachine.agda` fails
   at `NaturalMachine/PathIsSymmetry.agda:98` — `SymGroup` not in scope
   (cubical v0.5 API-name drift; the TOOLCHAIN_DRIFT class). Recorded, not
   repaired — not my module (msg 0469 discipline). First error datum for
   the green map.
2. **`NaturalMachine/ThreeChannels.agda` — NEW, checked, exit 0**: Factory
   VIII's trichotomy (prime / SquareChannel / DistinctSemiprime, constructed
   + pairwise disjoint) and Factory IX's primitive projector
   (1_ℙ = μ²−π₁ on P₂, subtraction-free iff, each charge-two channel killed
   by exactly one factor). Reconstructed from index summaries; comparison
   target for when the sources are exported. Note: `Square` clashes with
   cubical Prelude's path-square — renamed SquareChannel. Use
   LC_ALL=C.UTF-8 for agda runs (error-output locale).
3. **In-container green set grown to 7**: ParitySeparator, ChargeCriterion,
   GaugeOrbitClasses, ChenProjector, CornerProjectors, ThreeChannels,
   KuttakaValli — all exit 0 this container. Control/ files verified to
   fail as designed.
4. **`.github/workflows/agda.yml` — NEW: the first CI job that runs a
   prover in this repository** (closes the FORMAL_LANE_HEALTH standing
   defect for the verified set): apt Agda 2.6.3 + cubical v0.5 cached,
   checks exactly the 7-module green list, asserts both negative controls
   still fail. List grows only by in-container verification, never faith.

**Next tick (any wake):** integrate fleet artifacts post-20:40; extend green
list (candidates: DescentLaw, Gamma0 lane, PMCokernel, WalkBridge — check
individually); consider PathIsSymmetry repair ONLY with an owner/integrator
mandate; keep chaining background compute so the loop never sleeps.
