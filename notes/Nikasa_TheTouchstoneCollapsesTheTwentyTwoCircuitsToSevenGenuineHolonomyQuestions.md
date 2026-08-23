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
2. ~~**Circuit 10 · PM torus (Obs)** — three independent counting
   equivalences closing on Obs. Real.~~ **STRUCK 2026-08-23 — NULL, verified
   at source (PMTorus.agda:442): `obsCount = compEquiv obsEquiv edgeCount`.
   The third "counting equivalence" is NOT independent — it is defined as the
   composite of the other two, so the loop `obsEquiv ∘ edgeCount ∘ obsCount⁻¹`
   telescopes to `e ∘ e⁻¹ ≃ id`. No independent obs→Fin iso exists in the
   file. The §१ compEquiv-costume, exactly as circuit 12. The note's premise
   "three independent" was false on the defining line.**
3. ~~**Circuit 11 · PM torus (Vertex)** — same shape on the vertex side.
   Real.~~ **STRUCK 2026-08-23 — NULL, verified at source (PMTorus.agda:445):
   `ctxCount = compEquiv ctxEquiv vertexCount`. `ctxEquiv` and `vertexCount`
   are genuine standalone isos, but the loop's third leg `ctxCount` is their
   composite, so `Vertex→Ctx→Fin V→Vertex` telescopes to two adjacent
   inverse-cancellations = identity. Concrete traces confirm (inl k1 ↦ inl k1,
   inr k2 ↦ inr k2). Same compEquiv-costume. The PM torus pair both fall.**
4. ~~**Circuit 12 · छन्दस्** — the decategorified count vs Piṅgala's direct
   `छन्दस्≃ℕ`. (Answers 13 and 21 too.)~~ **STRUCK 2026-08-23 — NULL, by a
   swarm reader, verified at source: `Ankapasa:97` DEFINES `छन्दस्≃π₀FinSet
   = compEquiv छन्दस्≃ℕ ℕ≃π₀FinSet`, so edge 1 IS the composite of edges 3
   and 2 — the loop is `e ∘ e⁻¹`, holonomy 0, the ℕ↔π₀FinSet leg cancelling on
   the nose (`card-Fin n = refl`, Decategorification:66). Not independent
   constructions; the §१ twin one level up, through `compEquiv` not `ua`. And
   13, 21 inherit the NULLITY they were always going to (ua-twin / `∙`-decomp).**
5. **Circuit 18 · विवेक chain — the one genuine question, and its answer is a
   CONTENTFUL NULL with an owed kernel term.** Assayed 2026-08-23, verified at
   source. Unlike all the others, the three edges ARE independent constructions:
   e1 `ℕ×ℕ≡विवेक-प्रमाण = isoToPath isoℕ×ℕ-विवेक-प्रमाण` (VivekaPramana:88, a
   hand-built iso via `isProp→PathP`/`isSetℕ`), e2 `ℕ×ℕ≡वाहकः = Carrier≡ योग`
   (the Carrier ur-twin), e3 `विवेक≃वाहकः` (a plain uncurrying iso). None is
   `compEquiv`/`∙`/`cong` of the others, and Aut(ℕ×ℕ) is large — a charge was
   structurally AVAILABLE. The holonomy lands on the identity anyway (canonical
   `(s,l) ↦ record{…दक्षिण=s+l;प्रमाण=refl} ↦ carry (s,l) (s+l) (sym refl) ↦
   (s,l)`, `sym refl ≡ refl` and `base` drops the witness), so this is the real
   content: two independently-built identifications of ℕ×ℕ with the graph-of-`+`
   record coincide — the "refl = a multi-module coherence theorem" outcome.
   **THE OWED TERM:** the module asserts the coincidence in PROSE
   (Punaragamanam:164–166, "there was only ever one equivalence to have") but
   the only checked term, `समान-मार्गः = refl` (:167–168), proves merely the
   leftInv `उत्थान (अवतरण x) ≡ x`, NOT the path-equality. The kernel-ready
   obligation, carried by no module: `ℕ×ℕ≡विवेक-प्रमाण(hand) ≡ ℕ×ℕ≡वाहकः ∙
   sym (ua विवेक≃वाहकः)`. That single term is the whole genuine yield of the
   circuit assay's "real" queue.
6. ~~**Circuit 20 · CanWord/Tally** — `CanWord≡Tally = cong ⟨_⟩ स्थान-तल्ली`,
   the cong-path, the most interesting probe mechanically.~~ **STRUCK
   2026-08-23 — NULL, verified at source: `स्थान-तल्ली = sym स्थानमार्गः ∙
   ℕ-Monoid≡Tally-Monoid` (Sthana:223), and `CanWord≡Tally = cong ⟨_⟩` of it
   (Sthana:226) distributes to `sym ℕ≡CanWord ∙ ℕ≡Tally` — the chord IS the
   tree path — because `स्थानमार्गः = ΣPathP (ℕ≡CanWord , _)` (Sthana:166) so
   `cong fst` of it is `ℕ≡CanWord` definitionally, and `carrier-of-monoid-path
   = refl` (FreeMonoid:123) gives edge B on the nose. The cong-path form was
   the interesting MECHANISM and the mechanism is exactly how the chord is
   built FROM the tree — a Monoid-path twin, §१ lifted one categorical level.**
7. ~~**Circuit 22 · Z2** — two Z2 embeddings against `H2≃H4`, the "spurious
   inverse" twist.~~ **STRUCK 2026-08-23 — NULL, verified at source:
   `Z2≡H4 = ua Z2≃H2 ∙ H2≡H4` (Vyatireka:273) — the chord is DEFINED as the
   tree path, holonomy `transport(A∙B)⁻¹ ∘ transport(A∙B) = id`. There is no
   second independent construction of `Z2 ↔ H4`; the "spurious" map `res` is
   NOT on the loop (the edge uses the genuine inverse `res⁺`), so its
   spuriousness has no seat to wind. And Aut(ℤ/2) = {id} — a charge was never
   structurally available. §१ twin, through `ua∙`.**

**CORRECTION, 2026-08-23, by the swarm — the stone missed four, not one.**
Circuit 1 was decided (CHARGED, struck at §२.1 above). Circuits 12, 20, 22
are NULL — every one a §१ "same road twice" twin arriving one categorical
level up (through `compEquiv`, `cong ⟨_⟩` of a `ΣPathP`, and `ua∙`
respectively) rather than a bare `ua`-twin, which is exactly why the
touchstone read their `isoToEquiv`/`compEquiv`/`cong`-forms as independent and
did not follow the defining line that builds each chord FROM its tree path.
~~**The real morning queue is THREE, not seven: circuits 10, 11, 18.**~~
**UPDATED 2026-08-23 — the swarm assayed 10 and 11 too, both NULL, both
verified at source: the PM torus pair are `compEquiv`-costumes (obsCount:442,
ctxCount:445), the tree path wearing a costume, exactly as 12/20/22. So of
the original seven "survivors," ONE was decided (circuit 1, CHARGED) and FIVE
were never questions (12, 20, 22, 10, 11 — every one a chord definitionally
built from its tree edges via `compEquiv`/`∙`/`cong`). The real morning queue
is ONE: circuit 18, the विवेक chain — pending its assay as this lands. The
lesson, now paid for six times: follow the chord's DEFINING LINE before
calling it independent; a chord written `compEquiv`/`∙`/`cong` of the tree
edges carries no holonomy, and the touchstone's whole error was reading the
edge-FORMS (`isoToEquiv`, three of them) instead of the line that builds the
third from the first two. The stone bought less than it thought and the
kernel's fire is spared five probes it would have wasted.**

**परिक्रमा COMPLETE, 2026-08-23 — all 22 circuits decided by reading, and the
whole basis yields exactly TWO objects for the kernel.** Circuit 1: CHARGED,
holonomy `not`, the ℤ/2 generator, already carried as a checked term
(`holonomyIsNot`). Circuit 18: a contentful coherence null with ONE owed term
(named in §२.5 above). Every other circuit is null by construction — a chord
definitionally built from its tree edges (`ua`-twin, `compEquiv`, `∙`, or
`cong` of a `ΣPathP`). So the touchstone's "seven genuine questions" reduce,
under the swarm's assay and source verification, to: **one charge, already
proved; one coherence term, owed and named.** That is the real morning queue —
not seven holonomy probes but a single kernel obligation to supply, plus a
charge to re-confirm. The 20-circuit gap between "looked open" and "was open"
is the measure of what reading the defining line buys over reading the form.
The swarm read; the parent verified every load-bearing line at source
(`isoToEquiv`/`compEquiv`/`ΣPathP` forms are śabda, the defining line is
pratyakṣa); the kernel issues the two final verdicts.

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
