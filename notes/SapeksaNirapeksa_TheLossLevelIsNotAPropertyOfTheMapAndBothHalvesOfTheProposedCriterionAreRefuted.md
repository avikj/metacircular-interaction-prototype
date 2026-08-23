# सापेक्ष–निरपेक्ष — the loss level is not a property of the map, and both halves of the proposed ३/४ criterion are refuted

**मूलवाक्यम्.** **सापेक्ष / निरपेक्ष** — with regard to, without regard to; a
naya asserted निरपेक्ष is मिथ्या. **Siddhasena Divākara, *Sanmatitarka*
(Prakrit *Sammai-suttam*) 1.21–25, date disputed, c. 5th c. CE.**

**ग्रेड · śabda, declared.** No edition of the *Sanmatitarka* was opened for
this note. The attribution, sūtra numbers and date are carried from this
repository's own ledger (`.claude/hooks/MulaVakya_…txt` rows 120, 121) and from
`notes/SakalaVikalaDesa_TheFibreIsTheLossAndAnEmptyFibreIsAvaktavyamNotNasti.md`,
and are owed at verse level. **Nothing here is claimed to have been held by
Siddhasena or any Jaina logician.** The pair is taken for one property — that a
verdict pronounced on a thing apart from what it stands among is false — because
that is what the checked terms below exhibit, and this corpus already uses the
pair in that sense.

Everything asserted below is a checked term in
`formal/cubical/SapeksaNirapeksa_TheLossLevelIsNotAPropertyOfTheMapAloneAndTheFibreCriterionFailsOnItsOwnArchetype.agda`
(Agda 2.8.0 + agda/cubical, `--cubical --safe`, no postulates, no holes).

---

## What was proposed

`notes/SakalaVikalaDesa_…md` has a five-level loss scale. Levels ३ (recoverable
only by outside supply) and ४ (नष्टिः, अप्रतिकार्या) are both crowded fibres.
`Punaragamana.SakalaVikalaDesa_…` refuses a fourth constructor for `देश` and says
why: the obvious criterion, `¬ Σ[ψ] (ψ ∘ collapse ≡ id)`, holds of both. The note
proposes a replacement in two halves — level ४, the fibre is the WHOLE source and
nothing anywhere sees the difference; level ३, the fibre is a PROPER PART and
other maps out of the source still see it — and marks the load-bearing half a
conjecture, `(x : ∥ A ∥₁) → fibre ∣_∣₁ x ≃ A`.

`formal/cubical/Avacchedaka_…` (2026-08-21, mine) checked that conjecture, wrote
the criterion down as `सर्वहानिः f b = fiber f b ≃ A`, and asserted in a comment:
*"विकलादेश says the fibre has two distinct points; that is true of a map that
drops one bit and equally true of a map that drops everything. सर्वहानिः says
which."*

## Both halves fail

**१. `सर्वहानिः` holds of the corpus's own level-२ archetype.** `सर्वैकम् : Bool →
Unit` is `Punaragamana.Sesa_…` §5's map; that module's struck header names it
"level २ of a five-level scale" and prices its loss at exactly one bit. `Unit` is
a proposition, so the path component of `fiber सर्वैकम् tt` contracts and the
fibre is `Bool` — the whole source. `एकबिन्दु-सर्वहानिः` is that, and it is
literally §२ of `Avacchedaka_…` with `isPropUnit` in place of `isPropPropTrunc`.
**That is the mechanism of the failure: the criterion is reading propositionality
of the target, and both targets are props.** So it does not separate ४ from ३; it
does not separate ४ from २.

**२. Not a stray instance — at `Bool` the two archetypes are one map.** `∥ Bool ∥₁`
is an inhabited proposition, hence contractible: `त्रुटि-Bool≃Unit`. The triangle
commutes by `refl` (`त्रिकोणम्`). And in the census's own terms,
`गणना-अभेदः : (x : ∥ Bool ∥₁) → fiber ∣_∣₁ x ≃ fiber सर्वैकम् tt` — every fibre of
the level-४ archetype is equivalent to the single fibre of the level-२ archetype.
A census is a function on fibres. **No reading of the census tells them apart.**

**३. The level-३ half is vacuous.** `साक्षी-निष्फलः` exhibits the condition holding
at the level-४ archetype: two distinct points of `fiber ∣_∣₁ ∣ true ∣₁`, and
`idfun Bool` separating them. Structurally, विकलादेश's evidence *is* a separation
— to write the constructor you hand over two fibre points and a proof they
differ, and for a map into a set that proof already separates their sources. A
condition discharged by the evidence of the case it classifies classifies
nothing.

## What the collision names

"Recoverable" was being asked of a map निरपेक्ष. Fix `सर्वैकम्` and vary only what
the construction retained:

| retained context | verdict | term |
|---|---|---|
| `idfun Bool` | `Bool ≃ Unit × Bool`, an equivalence — nothing lost | `सापेक्ष-समता` |
| nothing (`सर्वैकम्`) | `¬ isEquiv ⟨सर्वैकम् , सर्वैकम्⟩` — the bit is gone | `निरपेक्ष-न-समता` |

One map, two verdicts, both checked. **So no predicate on `f` alone carries the
level, and the scale as stated — indexed by the map — cannot be completed by any
criterion, this one included.** The point runs to the level-४ archetype too:
`पूर्ण-सन्दर्भः : A ≃ ∥ A ∥₁ × A`, for every `A`, no hypothesis. Retaining the
source recovers the truncation.

`वास्तव्यम्→एकम्` / `एकम्→वास्तव्यम्` locate the collapse: `∥ A ∥₁ ≃ Unit` exactly when
`A` is merely inhabited. `Bool` is inhabited, which is the whole reason §२
degenerates there. **The statement the scale actually wants is uniform in `A` —
it has a quantifier in it — and a criterion evaluated at one map and one point of
its codomain cannot reach a quantifier.**

## What is not claimed

- Not that levels ३ and ४ are the same, or that the scale is wrong. Two proposed
  criteria and the shape they share are refuted; the distinction they reach for
  is not.
- Not that a context-indexed scale would work. One map under two contexts is one
  map under two contexts.
- Not that `∣_∣₁` is harmless. §५ recovers it only by retaining the whole source,
  the trivial context; §६ says where the uniform statement lives and does not
  prove it.
- **Nothing was added to `देश`.** That datatype is in another library and its
  author's refusal to extend it was a considered act — and this is the argument
  that the refusal was right: the missing thing was not a name, and it was not a
  criterion either. It was an index.

`Avacchedaka_…`'s §३ comment and §४ closing paragraph are struck in place, with
the reason, rather than deleted.
