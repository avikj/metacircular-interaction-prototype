# निकष — the touchstone: 22 circuits assayed by reading, and seven survive as genuine questions

**THE TERM.** निकष, ordinary Sanskrit: the touchstone — the dark stone on which
gold is assayed by its streak (the kāvya commonplace निकषोपल). Plain sense; the
compound title is built here, 2026-08-23; no text is claimed.

**GRADE.** Every verdict below is a LEAD BY INSPECTION — the defining line of
each edge was read and is quoted with its site — and **only the kernel issues
verdicts**. But an assay is exactly what a touchstone gives: enough to decide
where the fire's time goes. Method: परिक्रमा (machine/Parikrama_….hs) emitted
the complete fundamental cycle basis of road one — 22 circuits, dimension
checked = E−V+C. Each circuit's holonomy is null iff its chord equals the
tree path as an equivalence. For most chords, the defining line answers.

## १ · The ua-twin law empties most of the queue

`Punaragamana/Carrier.agda:109` is `Carrier≡ = ua Carrier≃` — **the first
file's own double export**. Every module that re-exports both an `X≃Y` and an
`X≡Y := ua X≃Y` puts TWO admitted edges between one pair of banks, and the
resulting "second road" is the same road twice: the circuit composes to
`pathToEquiv (ua e) ∘ e⁻¹ ≃ e ∘ e⁻¹ ≃ id` — null by `pathToEquivIdEquiv`/
`uaβ`, library lemmas, no content. Assayed null on this pattern, with the
defining line quoted:

| circuit | chord | line |
|---|---|---|
| 2 | `H2≡H4 = ua H2≃H4` | Anyathasiddhi:134 |
| 3 | `Col≡Row3 = ua Col≃Row3` | Bhadraganita:111 |
| 4 | `Mat3≡Nine = ua Mat3≃Nine` | Bhadraganita:99 |
| 5 | `Pair≡CR = ua Pair≃CR` | CenterRelative:303 |
| 6 | `पर्याय-दर्शनम् = अभिज्ञानम्` (definitionally THE SAME equivalence) | Durnaya:167 |
| 7 | `Vyatireka.ℕ≡CanWord = ua Digits.ℕ≃CanWord` | Vyatireka:226 |
| 8 | chord AND tree edge both `= ua ℕ≃CanWord` (two files, one definition) | Vyatireka:226, Digits:320 |
| 13 | `छन्दस्≡ℕ = ua छन्दस्≃ℕ` → collapses onto circuit 12 | Pingala:164 |
| 14 | `त्रिक्≡कुट्टक = Carrier≡ उत्थान` (the Carrier twin) | KuttakaValli:214 |
| 15 | `आधार≡स्थानिवत् = Carrier≡ निर्धारितम्` | Sthanivadbhava:341 |
| 16 | `युग्म≡विवेक = Carrier≡ योग` | Viveka:74 |
| 17 | same pattern, root-level Punaragamana twin | — |
| 19 | `त्रिक्≡विवेक = ua त्रिक्≃विवेक` | Punaragamanam…Conjugation:76 |

And circuit **21 decomposes by its own chord**: `छन्दस्≡CanWord = छन्दस्≡ℕ ∙
ℕ≡CanWord` (Sthana:105) — the length-4 loop is definitionally the composite
of circuit 12's question with a ua-twin. Not independent.

**A नाम finding en passant:** `Vyatireka.ℕ≡CanWord` and `Digits.ℕ≡CanWord`
are two declarations with one definition in two files — a literal duplicate
the content-address census should confirm.

## २ · The seven that survive the stone — the kernel's real queue

1. ~~**Circuit 1 · AchromaticToy** — `L₁₂` and `L₂₁` are TWO INDEPENDENT
   `isoToEquiv` constructions (different to/from functions, :80 and :108).
   Whether `L₂₁ ≡ invEquiv L₁₂` is a genuine question; a difference is a
   charge minted from apparent redundancy.~~
   **STRUCK 2026-08-23 — this was never open, and listing it here is the exact
   defect §१ congratulates the stone for catching elsewhere: an instrument
   reporting undecided what the corpus has already decided. `AchromaticToy.agda`
   itself carries the verdict as checked terms — `holonomyIsNot` (equivFun of
   the round trip ≡ `not`, by `funExt λ{true→refl;false→refl}`, :123–124),
   `holonomyNontrivial` (:126–127), and `holonomyPathNontrivial` (:134–138)
   lifting it to the `ua`-path. Circuit 1 is CHARGED, charge = `not`, the ℤ/2
   generator; `G₁ = Bool`, `G₂ = Unit ⊎ Unit` (:63–65). `to₂₁` (`inl↦false`,
   `inr↦true`, :104–105) is pointwise `not` of `from₁₂` (`inl↦true`,`inr↦false`,
   :75–77), so `L₂₁ ≢ invEquiv L₁₂` — the twist is real and the module proved
   it before this note was written. Surfaced by a reader who opened the file to
   the bottom; the touchstone missed it because it read the two edges' `isoToEquiv`
   forms and not the module's own holonomy section fifty lines down. SIX survive
   the stone, not seven, and the miss is the lesson: read to the bottom before
   filing a question — the answer may be in the same file, which is this
   repository's oldest failure and it arrived in the note built to catch it.**
2. **Circuit 10 · PM torus (Obs)** — `obsEquiv ∘ edgeCount ∘ obsCount⁻¹`:
   three independent counting equivalences closing on Obs. Real.
3. **Circuit 11 · PM torus (Vertex)** — same shape on the vertex side. Real.
4. **Circuit 12 · छन्दस्** — Ankapasa's route through π₀FinSet against
   Piṅgala's direct `छन्दस्≃ℕ`: do the decategorified count and the direct
   enumeration agree AS EQUIVALENCES? The oldest object in the corpus asking
   whether its two modern readings are one reading. (Answers 13 and 21 too.)
5. **Circuit 18 · विवेक chain** — VivekaPramana → ℕ×ℕ → Carrier योग →
   विवेक-प्रमाण: three modules' identifications closing. Real.
6. **Circuit 20 · CanWord/Tally** — `CanWord≡Tally = cong ⟨_⟩ स्थान-तल्ली`
   (Sthana:226, a cong-path!) against the FreeMonoid∘Digits composite: does
   Piṅgala's next-row law agree with the digit/tally route? Real, and the
   cong-path form makes it the most interesting probe mechanically.
7. **Circuit 22 · Z2** — Vyatireka's two Z2 embeddings against `H2≃H4`:
   whether the "spurious inverse" module's group carries a twist. Real.

**What the stone bought:** the kernel's assay time drops from 22 probes to 7,
the 7 are each a route-agreement question between INDEPENDENT constructions
(exactly the kind whose answer is content either way — refl is a multi-module
coherence theorem; a moved point is a named charge), and the ua-twin pattern
is now known to be the dominant source of second roads, generated by the
Carrier law's own double export — worth one line in परिक्रमा's classifier
someday, so the stone runs inside the wheel.

*Assayed by the Fable seat, in the temple, night of 2026-08-22/23. Kernel
seats: the seven above are the morning queue; every probe recipe is already
printed by `runghc -imachine machine/Parikrama_….hs .`*
