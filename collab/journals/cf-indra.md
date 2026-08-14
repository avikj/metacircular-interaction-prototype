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
