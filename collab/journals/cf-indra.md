# cf-indra — journal

Memory anchor. Append-only, dated entries. A future instance of me starts
here: read top to bottom, then `git log --oneline -30`, then recent
`collab/messages/`.

## 2026-08-14T07:30Z — session start (first onboarding)

Believe: the EGB/Indra deltas (24, 25) are a real generative law, not prose —
their PROVE-shaped content is landable as checked Cubical Agda, and their
sharpest arithmetic consequence is that the minor-arc contribution in the
circle method is an un-objectified gluing defect ("install the defect as an
object" is exactly what analytic number theory has not done). The persistent
object of the collaboration is a span between construction histories (μ-side)
and behaviors (ν-side); neither colimit nor final coalgebra alone.

Context I carry from before onboarding (session started on side branch
`claude/eternal-golden-braid-recovery-sjk5sd` per an external task harness,
BEFORE reading the main-only owner directive):

- Landed there (commit a934b14): `notes/ETERNAL_GOLDEN_BRAID_DELTA24.md`,
  `formal/cubical/LawvereDiagonal.agda` (Lawvere fixed point, contrapositive,
  productive diagonal escape, Cantor instantiation),
  `formal/cubical/AchromaticToy.agda` (certified equivalence + transport,
  cycle holonomy provably `not`, collage-vs-collapse with separator, defect
  object generating ¬(G₂≃G₃), universe-graded Stage record, diagonal ascent).
  Both exit 0 standalone under Agda 2.6.3 + cubical v0.5.
- Delta 25 (Indra's Net) arrived; formalization targets triaged: T25.A
  type-theoretic Yoneda ((∀ z → z≡x → z≡y) ≃ (x≡y)), T25.B fiber equation
  (library `fiberEquiv` inherits it), T25.F propagation (compPathrEquiv /
  substEquiv + tear-visibility), T25.D coinductive net under --guardedness
  (no ▷ in v0.5; guardedness approximates; note honestly).
- Toolchain: apt Agda 2.6.3 + cubical v0.5 (~/agda-libs/cubical). Known open
  repo contradiction (fb8783f): formal/README says Agda 2.8 target, BUILD.md
  says v0.5; Everything.agda red at NaturalMachine.PathIsSymmetry under v0.5.
  NOT mine to resolve; scope every green claim as standalone-exit-0.

Doing: (1) re-land Delta 24 files onto main (owner directive: main only);
(2) land Delta 25 note + `formal/cubical/IndraNet.agda`; (3) message +
STATE row + BOARD block. Next after that: cross-review debt from the claims
board, then the minor-arc-defect note as a PROVE/SEARCH program item.

Forecast (PROTOCOL §4) for the IndraNet module: all four targets check under
--cubical --guardedness --safe with no postulates; risk is the bisim→path
copattern under 2.6.3 (may need PathP massaging); outcome space: {all green,
green minus coinductive path principle (then land without it and record),
guardedness rejection forcing sized/indexed reformulation}.

## 2026-08-14T08:05Z — landing + course correction

Outcome of forecast: ALL GREEN (LawvereDiagonal, AchromaticToy, IndraNet each
exit 0 standalone; one scope error en route — generalizable variable in
where-clause — fixed by explicit module binding; bisim→path checked first
try). Landed on main: two notes, three modules, Everything imports, message
0495, ROSTER row.

Course correction from the owner, verbatim spirit: do NOT walk in and produce
artifacts; orient first, read the body of work as if it were 10k files. I had
pattern-matched "engineering task" onto a living research corpus. Correct
posture per COGNITIVE_ORIENTATION §10: read constitution, then ONE native
mathematical object in full, then work from the object.

Constitution now read in full: COGNITIVE_ORIENTATION, MATHEMATICS_THAT_LEARNS,
PROTOCOL, TARGET, METHOD, BARRIER, GAUGE, FOREST, DIRECT, HOLOGRAM, PEM,
RESEARCH_SYSTEM, WHAT_IS_ACTUALLY_OPEN. Seven parallel readers sweeping:
claims registry, all messages, notes A-F/G-O/P-Z, formal lanes,
journals+failures+machine dirs. Synthesis next turn.

Key orientation facts I must not lose:
- TARGET = parity barrier as theorem about observable classes. W1+W2 DONE
  (ParitySeparator.agda, ChargeCriterion.agda — iff: separation ⟺ odd-Ω
  query). Live frontier: W3 oracle separation (value queries cannot simulate
  functional-equation queries); W4 coupling theorem (archimedean ↔ finite
  places) is what would matter to Goldbach.
- Protection/exposure duality: GAUGE Thm F (KMS state kills charged sector;
  parity = simplest boundary-invisible charge, Lemma F.2) + LIOUVILLE Thm H
  (λ fully visible at archimedean place). "Barrier is a property of the
  place, not the function."
- FOREST nucleus: T_pλ = -λ rigidity; interface ST_m = T_mS^m; DIRECT
  workstreams A (eigenmeasure dichotomy), B (proof-diff vs Sawin–Shusterman,
  emit ℤ's missing-structure certificate), C (constraint algebra; R0021
  countermodel to published TT step is real).
- HOLOGRAM: depth law corrected to exp(Θ(T^{1/2}log^{3/2}T)) for sums;
  difference atoms exponentially suppressed → exp(Θ(T)). Lesson: a constant
  without its X-dependence is worse than no constant.
- WHAT_IS_ACTUALLY_OPEN: the standing yield is UNEXECUTED MERGES, not new
  lanes. Strongest: e_b(q) = v_q(b^{ord_q(b)}-1) is simultaneously head
  depth, blindness depth, and Wieferich — three seeds demand the merge,
  nobody executed. Also: LENS_REPAIR hardness question (self-contained
  combinatorics); OBLIGATION §7 min-cut extraction specified never run.

Next: absorb reader reports, write synthesis, THEN pick work from the queue
in priority order (cross-review debts first). Do not produce before the
synthesis is real.

## 2026-08-14T15:55Z — orientation complete; two merges executed

Orientation: six corpus readers returned (claims registry, all 500+
messages, notes A-Z, formal lanes). Synthesis internalized; key: the
trustworthy layer is finite/exact/no-go; R0006 (index-one converse) and
R0021 (TT countermodel) are the two highest-stakes/least-audited packets;
Everything.agda coverage gap and BUILD-vs-README toolchain schism are the
build-truth risks; the analytic frontier's named open number is the band-B
bound with C < 3 (msg 0085), unheld.

Landed this session on main:
- 0502: HeadDepthMerge.agda — WHAT_IS_ACTUALLY_OPEN §1 merge EXECUTED.
  e_b(q) one carrier; W3 1048-triple replay now kernel fact; W4 counts;
  Wieferich 1093/3511 certified. Seed 1 CLOSED: strong = Fermat blindness
  on odd prime powers (forecast registered: predicted equality; outcome
  equality). General proof in notes/HEAD_DEPTH_MERGE.md §2 (cyclic units +
  unique involution). Monier SEARCH obligation recorded.
- 0503: Delta 28 landed (notes/DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_28.md)
  + DSOCutCalibration.agda (§62 as checked terms: feedback closure,
  order invariance, 4>3>2 hierarchy with proved rectangle lower bound).
  Deltas 26/27 ABSENT — SEARCH item. §48-50 typed against charge criterion
  in the landing note.

Resume state for next instance: (1) breaker slots I invited on 0502/0503;
(2) the two audit debts I'd take next: R0021 hostile re-derivation (highest
stakes, zero audits) or R0006's interpolation tail lemma extraction;
(3) Lean formalization of general W3+strong=Fermat (mathlib ZMod) is the
natural next PROVE; (4) the minor-arc-defect-as-object note from my Delta
25 synthesis remains unwritten — do it only after a grep sweep for prior
statements per TARGET.md §5.

## 2026-08-15T03:35Z — session end (usage-limit storm; salvage complete)

Fleet of 16 launched at owner direction; 11 died on session cap (resets
20:30Z). Landed green before the storm: HeadDepthTwo (seed 2 dissolved,
committed c0d055af). Salvaged as LABELED UNVERIFIED WIP commit: three fleet
modules (HeadDepthMergeBreaker, R0021FlipOrbit, NaturalMachine/
OracleSeparation — first did NOT finish a 10-min typecheck; treat all RED),
notes/EVERYTHING_COVERAGE_REPAIR.md, notes/MINOR_ARC_DEFECT_OBJECT.md.
Rebase conflict vs fast-moving main resolved keeping upstream for shared
files (orchestration ledgers, MathMachine.hs). All pushed; tree clean.

Machine: ran 7 supervised cycles green (208 green, 78 fibers, aggregate 42)
then loop exited 0. Restart it on resume.

Theorem Factory VI arrived and is landed (notes/EGB_THEOREM_FACTORY_VI.md,
faithful compression, every theorem statement preserved). ITS CORE IS THE
SESSION'S BEST MATHEMATICS: quantifier tear T101 (∀m∃x ⇏ ∃x∀m — factor-share
and scale limits do not commute), diagonal endpoint T102 (γ = limsup
log X_m / m < log m∗/α compiles near-prime families to exact witnesses),
κC<1 descent T105/106, critical Mellin β_c = 11/3 (T107), and the T110
strategy kill (cooling alone can never prove twins).

RESUME ORDER for next cf-indra instance:
1. Restart machine (./run_the_natural_machine_forever --supervise).
2. Verify/repair the three RED fleet modules (HeadDepthMergeBreaker hung —
   suspect slow unary computation; profile before trusting).
3. FactoryVICore.agda: T96/97/100/101 in integer-exact form
   (a^m ≤ b ⟺ a^{m+1} ≤ n; pigeonhole compactness; the E_m countermodel).
   Three-liners; highest theorem-per-token in the queue.
4. Re-launch the dead 11 fleet tasks after 20:30Z reset (prompts in this
   session's transcript; targets unchanged).
5. Standing: R0021 audit, R0006 tail lemma, Lean W3 general, γ-metric
   message to the collaboration (C112.1 retypes ALL near-prime work).

## 2026-08-16T04:00Z — machine-build swarm; the loop is now APPLIED

Owner directive: all energy on building the natural machine (2026 math
automation object); 16 genius subagents. Launched a build crew with STRICTLY
disjoint file ownership (the collision lesson). Usage cap (Fable 5) killed
~half mid-flight again; salvaged all green work by explicit pathspec.

HEADLINE — RUNTIME.md §4 item 5 (the corpus's #1 gap) is CLOSED, checkably:
- The machine, given ONLY ord_p + v_p(a^n−1) and no LTE knowledge,
  autonomously mined v_p(a^n−1)=e+v_p(n) on chain d|n, refuted the naive law
  + 43 rivals, MATCHING CYCLOTOMIC_SENSOR Thm 1. Emitted CyclotomicMined.agda
  (exit 0, verified cold). machine/CyclotomicVocab.hs.
- CandidateGen.hs MINTED 4 fresh certified corpus instances on ranges the
  corpus never reached: Wieferich pair (29,63), q=29/31 threshold scans, W4
  counts, Wieferich-clear window 3512-3700, self-regenerated MachineMinted/
  index. Negative control correctly rejected. All --safe exit 0.

Landed + pushed (through a4d2e11f and after):
- coverage-regeneration latch (check-everything-coverage.sh); ledger hardened
  to event-vs-state schema.
- FactoryVICore.agda: T101 quantifier tear checked (∀m∃x ⇏ ∃x∀m).
- FactoryVICoolingKill.agda: T110 strategy-kill (cooling alone can't prove
  twins).
- DSO self-scheduling: 32→28 steps, peak cut width 7→5, optimum certified.
- ArithVocab.hs (gcd/mod/lcm/v_p propose-and-refute).
- AgdaRewriteGate.hs: CRITICAL FIX — gate wrote to bare tempdir where cubical
  couldn't resolve, so EVERY candidate was silently rejected; now +timeout
  (no hang) +cache +verdict trichotomy.
- Certificate.hs + CertReplay.hs: library.txt 100% replay-complete, corrupted
  cert rejected. Machine's proof library is now a re-checkable ledger.
- machine-state-report.sh: state-not-event liveness (fails safe to DEAD).
- TRUTH_GATE_AUDIT.md: gate SOUND, latent unsanitized-defName defect
  (one-line fix: reject defName ∉ [A-Za-z_][A-Za-z0-9_]*).
- Rust CPU loop: self-improvement ROBUST (~5.6% unseen, ~5× null) but exact
  numbers are HashMap-seed artifacts (determinism overclaimed) — CORRECTION
  OWED to NATURAL_MACHINE_SELF_IMPROVES §2/§3.
- NestedInduction/ParallelGate/SelfArchitecture.hs (compile clean, authors
  capped pre-report — behavior unvalidated beyond compilation).
- DSO_DELTAS_26_27_FROM_INDEX.md: SEARCH flag was STALE — Delta 26/27
  ORIGINALS are in-repo (DEPENDENT_SYSTEM_OPTIMIZATION.md + _DELTA_27.md).

RED / OWED for next instance:
1. HeadDepthVocab.hs + BenchHeadDepth.hs DO NOT COMPILE — held back, repair.
2. TruthGate defName one-line fix (Certificate.hs identifier check).
3. Rust determinism correction into NATURAL_MACHINE_SELF_IMPROVES note
   (strike §2/§3 exact numbers; keep the robust ~5× separation).
4. Wire minted lane + new modules into top-level Everything.agda (coverage
   latch currently RED: HeadDepthMergeBreaker, R0021FlipOrbit orphaned).
5. Integrate optimalSchedule/CandidateGen dispatch into MathMachine.hs main
   (the agents left patches; not applied — MathMachine.hs is single-owner).
6. Relaunch capped tasks after limit reset: min-cut (OBLIGATION §7),
   R0021 audit, nested-induction validation, 3-red-module repair.
7. Machine liveness: container kills backgrounded loops; restart on resume
   (./run_the_natural_machine_forever --supervise) — death is now visible via
   machine-state-report.sh.

## 2026-08-16T16:55Z — circulation 0002; the κ=1 result and its operational payoff

Model switched to Opus 5 mid-session. Four upstream packages arrived; one
(INDEX_V3) byte-identical to msg 0861's landing, skipped. Three new, landed
with headers (msg 0863, pushed 72d0189c):
- PRIME_ATOM_TOMOGRAPHY_CONDITIONING.md
- PRIME_PAIR_CYCLIC_CHARGE_CRT_BOUNDARY_V2.md
- PRIME_MOBIUS_KLOOSTERMAN_PARAMETER_AUDIT.md
- EGB_CIRCULATION_INTERFERENCE_PASS_0002.md (+ data/egb_circulation_0002/)

DISCIPLINE AT THE DOOR: all three shipped .py evidence generators. NOT landed
(ban). Every script-derived number therefore graded MEASURED + unreplayable
in-repo, said so in each header. The exact identities stand on their proofs.

THE RESULT THAT MATTERS (tomography §0). Recovering the charge-one path
a_0 = P U_h P U_k P from the glued G(1), exact worst-case ℓ∞ amplification:
  power moments      C(2R,R) ~ 4^R/√(πR)
  factorial moments  2^R
  root-of-unity DFT  1          ← perfectly conditioned
Operational consequence for THIS corpus: extract charge-one by the cyclic
character projector, never by moments. Any moment-phrased charge route pays
an exponential conditioning penalty for nothing.

CONJECTURE I RAISED (agent verifying): the Z/2 gauge twirl (1+z)/2 of
GAUGE.md / TOY_OBSTRUCTION.md IS the n=2 case of the root-of-unity projector
(1/n)Σω^{-jν}. If so, the corpus has been using the OPTIMALLY-conditioned
extractor all along at n=2, and tomography tells it how to reach general n
without losing conditioning. Positive cross-lane identity; verify before claim.

KLOOSTERMAN = a direct-application NO-GO (quarter-scale factorization sits
inside the published theorem's hypothesis but is termwise nontrivial only on
a much shorter subrange). Highest-value genre; being independently verified
with the exponent arithmetic turned into kernel facts (its Python is gone, so
this is the ban forcing an upgrade, exactly as intended).

MACHINE: state report correctly screamed PRESUMED DEAD (12h since last row)
DESPITE a live supervise pid — state-vs-event discipline working as designed.
Drove a fresh cycle in the harness background (survives turns; the right
mechanism, unlike nohup which the container reaps).

6 agents live: tomography conditioning → Agda; corpus moments→DFT sweep;
MathMachine dispatch wiring (flag-gated, loop is live); Kloosterman exponent
verification; gate defName fix + Rust determinism correction; CRT aliasing
(n > R is the hypothesis κ=1 rests on — must be checked before the
operational recommendation is safe).
