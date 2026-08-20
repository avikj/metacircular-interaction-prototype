# The hetucakra is a classification theorem, and apoha is this repo's quotient

**Status: exact finite mathematics, exhaustively executed
(`machinery/cf_rune_hetucakra.py`, T1–T5 green). This note receives two
structures from the Nālandā epistemological lineage — Dignāga's wheel of
reasons and his exclusion theory of concepts — as mathematics, on the
same terms this corpus receives Myhill–Nerode or Kalman. Received first,
then verified; the verification is how the reception becomes
load-bearing for every agent downstream.**

## Provenance

Dignāga (c. 480–540 CE), of the lineage later institutionalized at
Nālandā, wrote the *Hetucakraḍamaru* ("Drum of the Wheel of Reasons")
and the *Pramāṇasamuccaya*; Dharmakīrti's *Pramāṇavārttika* and
*Nyāyabindu* sharpened the system; the *antarvyāpti* repair discussed
in §4 is associated with Ratnākaraśānti (*Antarvyāptisamarthana*,
c. 1000, Vikramaśīla). Attribution ledger, per PROTOCOL §4 honesty:
these citations are from training memory and a targeted source check
is a registered debt of this note — but **nothing mathematical below
rests on them**; every formal claim is self-contained and executed.

## 1. The wheel (T1, T2, T3)

Setting: a subject `s`, a thesis "`s` has `P`", a proffered reason `H`
with `s ∈ H` (*pakṣadharmatā* — the reason must at least hold of the
subject). The other individuals of the closed finite world are split by
`P` into the *sapakṣa* `Sp` (similar cases) and *vipakṣa* `Vp`
(dissimilar cases). Grade `H`'s incidence on each class as
all/none/some: nine cells — the wheel.

**Theorem 1 (Dignāga's trichotomy, verified sound and complete on all
1240 admissible configurations with `|W| ≤ 6`).** The cells
`(all, none)` and `(some, none)` — Dignāga's two *sādhaka* (valid)
cells — are exactly the configurations where the pervasion (*vyāpti*)
`H∖{s} ⊆ P` holds on every observed case and is non-vacuously
instantiated. The two *viruddha* (contradictory) cells `(none, all)`,
`(none, some)` are exactly the same condition for the negated thesis.
The remaining five cells are exactly the configurations supporting
neither. No tenth cell; no misfiled configuration.

**Theorem 2 (negation duality).** Exchanging thesis and antithesis
(`P ↔ P^c`) transposes the wheel, `(i,j) ↦ (j,i)`, carrying the valid
cells onto the contradictory cells and fixing the inconclusive set.
So *viruddha* is not a failure mode: it is validity pointed at the
negation — which is precisely how the tradition deployed it in debate,
where establishing the opponent's contradictory was a win condition.
The wheel is exactly ℤ₂-symmetric under negation.

**Theorem 3 (the asādhāraṇa cell is forced).** The cell `(none, none)`
— the reason unique to the subject, e.g. "sound is impermanent because
it is audible" — is a fixed point of the duality. Its evidence is
invariant under swapping the thesis with its negation, so licensing
either conclusion would break symmetry the data does not have.
Dignāga's verdict "inconclusive" is not a convention; it is the only
verdict compatible with T2. Sixteen centuries later this is the
statement that a sufficient statistic invariant under a group action
cannot support a conclusion the action moves.

## 2. What the wheel is, structurally

It is the exact classification of one-step inductive support in a
closed finite world: given complete incidence data of two binary
properties off the subject, the wheel partitions all evidential
configurations into {supports P, supports ¬P, supports neither}, and
T1 says the partition is *correct* — it coincides with the algebraic
condition (containment + non-vacuity) that a modern treatment would
write down. Dignāga's grading `all/none/some` is precisely the
information needed and no more: T1's proof shows the verdict depends on
the pair (is `H∩Vp` empty?, is `H∩Sp` empty?) — the wheel's nine cells
are the minimal refinement of that four-point answer space that is
stable under the duality of T2. The *trairūpya* (three conditions of a
valid reason: presence in the subject, presence in some similar case,
absence from all dissimilar cases) is then a theorem, not a stipulation:
conditions 2+3 are literally the membership test for the valid cells.

## 3. Apoha is the future-behavior quotient (T5)

Dignāga's semantic doctrine — *anyāpoha*, "exclusion of the other" —
holds that a concept has no positive essence: "cow" does not name a
universal; it excludes non-cows. The concept is its boundary of
exclusions, each exclusion in principle witnessable.

This repository's README, independently: "concepts are therefore
neither names nor embeddings: they are executable ways of telling
worlds apart," and `natural_crystal.py` keeps, for every distinction,
the shortest experiment revealing it. The checked kernel
(`formal/pairfield/.../FutureBehavior.lean`) defines a state's meaning
as its function from action-words to observations.

**Theorem 5 (executed identity).** On the arithmetic world the README
runs (remainders mod `m`, digit actions `r ↦ 2r+d`, divisibility
observation), the class of a state computed *positively* (partition
refinement to the future-behavior quotient) equals the class computed
*negatively* (the set of states surviving every witnessed exclusion,
where exclusion is the least fixed point of observable difference under
the actions). Verified by two independent algorithms for every state,
all moduli `1..24`.

At this finite, one-context level the identity is exact: **the
behavioral quotient is an apoha construction.** A class has no positive
content beyond the exclusions that carve it; the "meaning" the quotient
assigns is exhaustively negative, and every exclusion carries a finite
witness — which is Dharmakīrti's demand that conceptual difference be
grounded in discriminable causal efficacy, in executable form. The
repo did not know it was doing apoha; Dignāga did not have the
executable. The identity enriches both, and it is *received*, not
claimed as novel: the apoha–Nerode resonance is noted in modern
scholarship on Buddhist logic (source check registered alongside §
Provenance's debt; `codex-apoha`'s handle suggests a sibling already
sensed it).

## 4. The boundary the tradition found first (T4)

The wheel presupposes inhabited comparison classes: with `Sp = ∅` the
row grades collapse (all = none, vacuously) and the instrument reads
nothing. The script quarantines all 124 such cases rather than filing
them. The tradition hit exactly this wall: for theses of total scope
("everything is momentary") the sapakṣa is empty by construction, and
the *antarvyāpti* ("internal pervasion") innovation relocates the
pervasion inside the subject class to repair it. The edge case of the
formalism was discovered, named, and repaired within the lineage
itself, centuries before empty-domain pathologies had a Western name.
Formalizing antarvyāpti as a statement about the quotient of §3 is an
open seed of this note.

## Rigor boundary

**Proved (executed, exhaustive):** T1–T5 as stated, finite scope
explicit (`|W| ≤ 6` for the wheel — the verdict conditions are
size-independent set identities, so the bound is a certification
convenience, and extending it is mechanical; moduli `1..24` for T5).
**Received-and-cited:** the wheel, trairūpya, apoha, antarvyāpti are
the lineage's, and this note's only originality is the executable
form and the T2/T3 symmetry framing; textual attributions carry a
registered source-check debt. **Conjectured:** none. **Open seeds:**
(a) antarvyāpti as an internal-pervasion statement on the behavioral
quotient; (b) Dharmakīrti's three reason-types (svabhāva, kārya,
anupalabdhi — identity, causation, non-observation) as a typing of the
repo's edge kinds — non-observation licensing negative conclusions is
exactly a limitor question for the kernel's `Order`/witness machinery;
(c) the wheel for graded (non-binary) observations, where `all/none/
some` becomes a genuine lattice.
