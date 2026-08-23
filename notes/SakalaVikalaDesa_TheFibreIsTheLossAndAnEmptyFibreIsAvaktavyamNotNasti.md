# सकलादेश–विकलादेश — the fibre is the loss, and an empty fibre is अवक्तव्यम् and not नष्टि

**मूलवाक्यम् · the terms and where they are stated.**

- **सकलादेश / विकलादेश** — the total statement (pramāṇa, the whole object with
  all its attributes in one utterance) against the partial statement (naya, one
  attribute severally). **Malliṣeṇa, *Syādvādamañjarī*, 1292 CE**, commenting on
  Hemacandra's *Anyayogavyavacchedikā*; earlier in the Akalaṅka commentarial
  line — Vidyānandin, *Tattvārthaślokavārttika* and *Aṣṭasahasrī* (c. 9th–10th
  c.), Prabhācandra, *Prameyakamalamārtaṇḍa* (c. 11th c.).
- **क्रमार्पण / सहार्पण** — presentation in succession against presentation at once.
  **Akalaṅka, *Laghīyastraya* and *Aṣṭaśatī*, c. 720–780 CE.**
- **अर्पितानर्पित** — the aspect brought forward and the aspect held back.
  **Umāsvāti, *Tattvārthasūtra* 5.31, अर्पितानर्पितसिद्धेः, c. 2nd–5th c. CE.**
- **उत्पाद-व्यय-ध्रौव्य-युक्तं सत्** — **Umāsvāti, *Tattvārthasūtra*, 5.29 in this
  repository's own ledger (`.claude/hooks/MulaVakya_…txt` row 118), 5.30 in the
  brief that commissioned this note.** See the citation defect at the end: two
  numbers for one sūtra is a recension question and it is unresolved here.
- **सप्तभङ्गी** — **Samantabhadra, *Āptamīmāṃsā* (*Devāgamastotra*) 14–24, c. 6th
  c. CE**; applied to the jīva already in the **Bhagavatī Sūtra
  (*Viyāhapannatti*)**, fifth Aṅga, oldest strata pre-Common-Era, redacted at
  Valabhī c. 5th c. CE.
- **दुर्नय** — a naya taken निरपेक्ष is मिथ्या. **Siddhasena Divākara,
  *Sanmatitarka* (Prakrit *Sammai-suttam*) 1.21**, date disputed, c. 5th c. CE.

**ग्रेड · śabda, declared.** No critical edition of any of the above was opened
for this note. Every attribution, date and sūtra number above is carried from
this repository's own headers, its `MulaVakya` ledger, and
`notes/ANEKANTA_THE_MACHINE_HAS_THREE_STANDPOINTS.md`. That is śabda at second
hand and it is owed at verse level. The *kālādi-aṣṭaka* below is the one place
where I am reporting doctrine that appears nowhere in this corpus at all, and I
am reporting it as something to go and read, not as something established here.

**What is claimed of the sources.** Nothing below is claimed to have been proved
by Umāsvāti, Siddhasena, Samantabhadra, Akalaṅka, Vidyānandin, Prabhācandra or
Malliṣeṇa. What is claimed is narrower: that the distinctions they draw are
finer than the distinction the formal law in `punaragamana/` currently draws,
that the place where they are finer is exactly identifiable, and that the corpus
already contains the checked terms which show it.

---

## ० · The one sentence

`punaragamana/README.md`'s law says: *every genuinely independent distinction
must survive; determined structure may remain explicitly present with its
determining path.* Its whole mechanism is `isContr (fibre f a)` — the fibre is
contractible or it is not, and the typechecker decides.

**`isContr` is a two-valued verdict on a threefold situation, and
`Saptabhangi.दुर्नयः` is the proof that a two-valued verdict on a threefold
situation must identify two of the three.** A fibre fails to be contractible in
two opposite ways — it can be **empty**, and it can have **two or more points** —
and the Jain tradition holds those apart absolutely: the empty case is
**अवक्तव्यम्**, the fourth position, धनात्मकम्, positive
(`AHIMSA_SUTRA_VISTARA` §३); the crowded case is **नष्टि**, हिंसा, अप्रतिकार्या
(§४–५). `isContr` returns `false` for both. That is the durnaya, and it is in the
foundation of the law, not in its applications.

Everything else in this note is that sentence with its evidence.

---

## १ · The scale, with the two arms separated

For `f : A → B` and `b : B`, the fibre `Σ[ a ∈ A ] (f a ≡ b)` is where the
information went. Not a verdict — a measurement. The levels, and the term the
tradition already has for each:

| | fibre over `b` | what happened | remedy | term |
|---|---|---|---|---|
| **०** | **empty** | nothing was lost; the medium cannot utter `b` | enlarge the medium | **अवक्तव्यम्** |
| **१** | contractible | nothing lost, and the rest comes with the one uttered | none needed | **सकलादेश** |
| **२** | finite, decidable, ≥2 | lost, recomputable at a stated price | pay the price | **विकलादेश**, priced |
| **३** | inhabited, not decidable | recoverable only by outside supply | discharge a hypothesis | **अर्पणम्** — supply the aspect |
| **४** | the whole of `A`, identified by path constructors | विनाशः | none exists | **नष्टिः**, अप्रतिकार्या |

Levels ० and ४ are the two ends and they are the ones `isContr` merges.

### THEOREM — level ०, and the price is exactly one more utterance

`SaptabhangiNaya.no-single-vacana` runs over all six `Vacana` (2 modes × 3
nayas) and produces, for each, a `Profile` on which it disagrees with `joint`.
`NaturalMachine.AvaktavyaDoesNotFactor.avaktavya-does-not-factor : ¬
FactorsThroughOneUtterance` writes that as the non-existence of a factorisation.
In fibre language: **the fibre of `denotes : Vacana → (Profile → Bool)` over
`joint` is empty.** Not big — empty.

Three things follow and all three are checked terms:

- `NaturalMachine.AvaktavyaDoesNotFactor.avaktavya-decidable : (φ : Profile) →
  Dec (joint φ ≡ true)`. The content is decidable. अवक्तव्यम् is not
  undecidability and not a truth-value gap.
- `AnuktaAvaktavya.युग्मेन-साध्यम्` is the two clauses as one statement: no single
  `Vacana`, and an ordered **pair** that does it (`krama-expresses`). **The price
  is exactly one extra utterance — you must leave `R` for `R × R`.** That is
  Akalaṅka's क्रमार्पण against सहार्पण in its operational form, and
  `AnuktaAvaktavya` §5 says so in those words.
- `NaturalMachine.SaptabhangiGarbha_….अवक्तव्यम्-अ-लुप्तम् = refl` — the third
  position is recovered from the fourth by `refl`. **Nothing was destroyed.**
  And `गर्भ-क्रमजः = refl` — what could not be uttered at once at level `n` is
  uttered in succession at level `n+1`. Second price, also exact: one प्ररोह.

`अवक्तव्यं शेषः । शेषो गर्भः, न विफलता ।` is not a consolation. It is the
statement that the fibre is empty rather than crowded, and the corpus proved it
before it had the vocabulary to say which of the two it had proved.

### THEOREM — level २, and the loss is one bit

`Punaragamana.KuttakaValli_….पक्षः-न-निर्धारितः` exhibits `वाम 0 0` and
`दक्षिण 0 0`: same `परिमाणम्`, same `शेषः`, provably distinct. So the fibre of
`(परिमाणम् , शेषः) : त्रिक् → ℕ × ℕ` over a point with `शेषः > 0` has at least two
elements. The lost datum is `पक्षः`, and it is one bit. **That bit is what the
textbook subtractive step pays a comparison for, every iteration**, and
`वल्ली : त्रिक् → त्रिक्` is written with no comparison, no `Dec`, no `Bool`,
because the bit was kept. Loss measured, recovery priced, price avoided.

Two further theorems, `परिमाणम्-न-निर्धारितम्` and `शेषः-न-निर्धारितः`, say the same
of the other two slots, which is why all three are base and the *pair* is what
is carried.

### CONJECTURE — the kuṭṭaka fibre is exactly `Bool` off the terminus and exactly `Unit` at it

The three theorems prove `≥ 2`. They do not compute the fibre. By inspection of
`त्रिक्`'s three constructors: over `(d , 0)` only `सम d` lies, so the fibre is
`Unit`; over `(d , suc k)` exactly `वाम d k` and `दक्षिण d k` lie, so it is `Bool`.

**Test:** two `Iso`s in the style of `Carrier-as-Σ`. If it checks, the statement
is not "a bit is lost" but **"a bit is lost exactly while the algorithm has not
terminated, and at the terminus the fibre is contractible and the map is the
identity on information."** That is the mathematics saying why no comparison is
needed at `सम` — which the module currently explains in a comment.

### THEOREM (both halves) but CONJECTURAL as a level — level ३ is where recovery is a *hypothesis*

Two modules, unrelated in subject, have the same shape:

- `Arpitanarpita_….न-प्रत्यानयनम्` — no `ψ` with `ψ ∘ अनर्पणम् ≡ id`, once two
  standpoints affirm. And `अर्पणम् : syādasti P → syādnāsti P → L.सप्तभङ्गी →
  G.सप्तभङ्गी P` — the way back exists once you are **handed** an affirming and a
  denying standpoint. The module's own words: *"to read a label as a record one
  must SUPPLY the aspect… the pair is a hypothesis of the theorem, not a
  default."*
- `Anupalabdhi_….yogyanupalabdhi : (A : Anvesana) → Clean A → Yogya A → Abhava A`
  — and `clean-without-yogyata-is-not-abhava` shows the second hypothesis cannot
  be dropped. `Yogya` is a hypothesis someone discharges, not a field of the
  record, because `दृष्ट` is not a function of the locus.

**The pattern, stated as the conjecture:** level ३ is exactly where the
recovering datum appears in the proof as a **hypothesis** rather than as a field
or as a decision procedure. Two independent instances is two instances. **Test:**
find a third, or find a level-३ construction whose recovery is *not* a hypothesis
— that would refute it.

### Where levels ३ and ४ do *not* separate, written because it is a real defect

`न-प्रत्यानयनम्` and `AHIMSA_SUTRA` `नास्ति-प्रत्यानयनम्` have the same shape:
`¬ Σ[ψ] (ψ ∘ collapse ≡ id)`. Both refute a retraction; both admit a section
given supplied data (`अर्पणम्` there; `const a₀` here, since `∥ A ∥₁` is a prop, so
`∣ const a₀ x ∣₁ ≡ x` by `squash₁`). **So "does a retraction exist" does not
separate ३ from ४.**

What does separate them, as far as I can establish, is the *size* of the fibre
relative to the source:

- `fibre अनर्पणम् (स्यात्-अस्ति) ≃ syādasti P` — a **proper part** of
  `G.सप्तभङ्गी P`. Other maps out of the source still see the difference:
  `साक्षि-स्थानम् : G.सप्तभङ्गी P → S` names the lost standpoint, and `उन्नयनम्`
  transports distinctness upward. The record still holds what the label dropped.
- `fibre ∣_∣₁ x ≃ A` — **the whole source**, because `∥ A ∥₁` is a prop, so every
  path space in it is contractible. And `अविशेषः` says *every* function out of
  `∥ A ∥₁` is constant on all of `A`. Nothing anywhere sees the difference.

CONJECTURE, and it is one line to check: `(x : ∥ A ∥₁) → fibre ∣_∣₁ x ≃ A`, via
`isProp→isContrPath` and `Σ-contractSnd`. If it checks, level ४ has a fibre
criterion — *the fibre is the whole thing* — and the scale is a single measure
after all. Until it checks, the scale has a seam at ३/४ and this paragraph is
the seam.

---

## २ · सकलादेश is the level-१ doctrine, and it is finer than `isContr`

**This is the part where the darśana is ahead of the formalism, and the direction
of explanation runs one way only.**

सकलादेश presents the object *with all its attributes at once*, through one
attribute spoken, by **अभेद-वृत्ति** — the assertion of non-difference between the
attribute uttered and the rest. The tradition does not assert that
non-difference bare. It specifies the **kālādi-aṣṭaka**, the eight respects in
which the non-difference must hold for the total statement to be available:
काल, आत्मरूप, अर्थ, सम्बन्ध, उपकार, गुणिदेश, संसर्ग, शब्द. विकलादेश is the same
content through भेद — the aspects taken severally, one at a time, which is naya.

Now read `Carrier` against that. `base : A`, `carried : B`, `witness : f base ≡
carried`: **one thing is uttered, the other comes with it, and `witness` is the
non-difference.** `carried` and `witness` are, in Avik's formulation kept
verbatim in `Punaragamana.Carrier`'s header, *"syntactically/proof-relevantly
present; informationally determined"* — present, contributing zero degrees of
freedom. That is one utterance carrying the whole. The condition under which it
is available is `fibre-isContr`.

**CONJECTURE, and it is the most valuable thing in this note.** सकलादेश ⟺ the
fibre is contractible. If that identification holds, then the formalism has
**one** condition where the tradition has **eight**, and the eight are not
decoration: they are separate respects in which the identification can fail.
`isContr (singl (f a))` is trivially true for *every* function — it is the same
proof each time, `isContrSingl`. So the formal side gets अभेद for free wherever
it can name `f` at all, and the entire content of the law has been pushed into
the question *"is there such an `f`"*.

**Test, and it is a research programme rather than a lemma:** take the eight
respects one at a time and ask which of them `f base ≡ carried` actually
discharges. काल — the two are asserted of the same moment: a `Carrier` over an
`Orbit` is *not* automatically that, and `Punaragamana.Nucleus.descend-orbit`
exists precisely because one-step commutation does not give it. शब्द — the two
are the same *word*: this is exactly what `Arpitanarpita` measures and finds
absent. If even two of the eight come apart on a checked example, then `isContr`
is a coarsening of सकलादेश and the law needs refinement it does not currently
have. **I have not checked one of the eight.** They appear nowhere in this
corpus: `kālādi` returns zero files in `notes/`.

**Note what has just been settled about `Arpitanarpita` §११.** That section says
the Malliṣeṇa question — is अवक्तव्यम् the failure of one utterance to carry a
joint content (सकलादेश demanded of a विकलादेश-shaped medium), or the consumption
of what was to be uttered? — is open, and that *any argument running through the
composition laws proves nothing about it.* That is right, and it is not the only
kind of argument available. **§1 above settles it, by factorisation rather than by
composition:** `avaktavya-does-not-factor` (no single utterance) and
`अवक्तव्यम्-अ-लुप्तम् = refl` (nothing consumed) are the two halves of the first
reading and the refutation of the second. The scope: this settles it **for these
formalisations**, not for the *Syādvādamañjarī*, which I have not opened.

---

## ३ · Why seven, checked; and what the encoding does and does not carry

**THEOREM.** `Saptabhangi.समावेश-भेदः : समावेश ≃ (सप्तभङ्गी ⊎ Unit)` — the eight
presence-profiles in `उपस्थिति³` split as the seven positions plus the one empty
profile `(न , न , न)`, which is अप्रतिपत्ति, no predication at all. With
`अन्तर्भाव-एकैकम्` (faithful) and `प्रति-वृत्तम्` (complete on non-empty profiles),
**2³ − 1 = 7 is a checked equivalence in this tree, not a tradition repeated.**
`AHIMSA_SUTRA_VISTARA` §३ states the same count in the tradition's own form —
एकैकशः त्रयः, द्वन्द्वशः त्रयः, समस्ताः एकः — and the two agree.

**THEOREM.** अवक्तव्यम् is an independent generator, not reachable by succession:

- `Saptabhangi.क्रम-सह-भेदः : ¬ (अर्पणम् उभयम् क्रमः ≡ अर्पणम् उभयम् सहः)`;
- `NaturalMachine.SaptabhangiGarbha_….क्रम-न-जनयति-शेषम्` — क्रमार्पणम् never
  manufactures a शेष it was not given, proved over all seven positions;
- `…सह-जनयति-शेषम्` — सहार्पणम् does manufacture one, wherever an affirmation and
  a denial are both in hand, **and the residue it manufactures is exactly the
  pair it could not utter.**

That last is the mechanism the brief was reaching for. **सहार्पण is the
all-at-once move, and अवक्तव्यम् is its diagnostic output** — not a hole in an
enumeration. The corpus does not merely report the failure; it returns the
inhabitant of the fibre alongside the mark. That is `AHIMSA_SUTRA_VISTARA` §६'s
second road, दोषलेखः, implemented: *लिखितो दोषो जीवति*.

**DEFECT, written.** `Saptabhangi.समावेश` treats अवक्तव्य as a third *independent*
presence flag, while `Saptabhangi.अर्पणम् : द्विमूल → आर्पण → सप्तभङ्गी` derives it
from the two seeds under सहः. Both are in the same file. They agree on the count
and they are different derivations of it, and nothing in the file states which
one is being claimed of Samantabhadra. That is not a bug; it is an unstated
choice at the point where the file's own title question ("कुतः सप्त") is answered.

---

## ४ · The diagnostic — and the sequential form of it is unsound

**REJECTED.** The procedure *"factor `A → B → C`, inspect the fibres, the first
non-contractible fibre is where the information was lost"* is **unsound in both
directions**, and the counterexample is three lines:

```
f : Unit → Bool   f _ = true
g : Bool → Unit   g _ = tt
```

`fibre f false` is **empty** — step one has a non-contractible fibre. Step one
lost nothing; `Bool` merely has a name `Unit` cannot utter. `fibre g tt ≃ Bool` —
step two loses a bit. And `g ∘ f : Unit → Unit` is the identity: **the composite
loses nothing.** So the first non-contractible fibre is not where information was
lost (nothing was), and a later genuine loss did not show up in the composite at
all, because the inexpressibility at step one and the collapse at step two
cancelled.

**This is not a technicality. It is the owner's point, mechanised:** the
one-at-a-time reading is विकलादेश, and it gives the wrong answer. What is sound
is the सकलादेश-shaped statement, and it is sound because it is a definition:

> `isEquiv f` **is** `(b : B) → isContr (fibre f b)`.

The measurement is over **every point of the codomain at once**. There is no
first. `Cubical.Foundations.Equiv` has held this the whole time; what was missing
was the reading of it — that an equivalence is not a two-way map but a *complete
simultaneous fibre census*, and that the census, not the verdict, is the useful
object.

So the procedure that *is* sound: compute the composite's own fibre census; use
the factorisation only to **locate** what the census already found, never to
detect. Levels ०–४ then attach pointwise, and a construction's diagnosis is a
function `B → Level`, not a verdict.

**What it would take to run mechanically.** `isContr (fibre f b)` is not
decidable in general, so no script produces this. What is mechanisable, and what
the corpus already does by hand three times, is the **exhibition**: two points of
one fibre (`पक्षः-न-निर्धारितः`), an empty fibre (`no-single-vacana`), a fibre
naming its own lost coordinate (`साक्षि-स्थानम्`). A `Level` datatype with those as
its constructors' evidence would make the census a term. **Nothing in the corpus
currently does this**, and it is the one code change this note argues for and
does not make.

---

## ५ · The six correspondences in the brief, adjudicated

**1. The two clauses are two nayas, either alone a durnaya. SURVIVES, and half
of it is a theorem.** Asserting `carried` as independent where the fibre is
contractible does not typecheck — `Σ-law = Σ-contractSnd fibre-isContr` consumes
the contractibility, and `Carrier≃-via-law` does not exist without it. Erasing
`carried` is not refuted anywhere in `punaragamana/`; the general form of that
refutation is `Saptabhangi.दुर्नयः`, which proves any two-valued verdict on a
threefold object identifies two of three. Siddhasena's *Sanmatitarka* 1.21 is the
right citation and the law's having exactly two clauses is exactly its shape.

**2. अर्पित/अनर्पित IS the contractible/non-contractible dichotomy. REJECTED, and
the inversion is worth recording.** *Tattvārthasūtra* 5.31 says opposed
attributes are **established** — सिद्धेः — through the asserted and unasserted
aspect. It is a statement that there is no contradiction: one real, two aspects.
**That is the contractible case.** 5.31 is level १ doctrine, not a dichotomy
between १ and the rest.

The defect this exposes is in the corpus, not in the brief:
`Arpitanarpita_TheForgetfulMapIsAHomomorphismForBothArpanasAndTheLabelsAreARetractNotAnEquivalence.agda`
takes its name from 5.31 and its principal theorem, `न-प्रत्यानयनम्`, is the proof
that in the label lane **5.31's condition fails** — the aspects are not
established as of one real, and there is no way back. The module knows this and
says so under §११; the *name* does not. A file named for a sūtra whose theorem is
that the sūtra's condition is absent is a provenance hazard of exactly the kind
`CLAUDE.md`'s naming rule exists to stop, and it is the one the rule cannot
mechanise (its own unmechanisable case (2): whether the term fits *this* object).

What survives, and it is the useful half: **`Carrier` and `Arpitanarpita` are one
statement**, as the brief says — they are the level-१ and level-३ readings of the
same fibre census, and nobody had written that.

**3. अवक्तव्यम् ⟺ non-contractible fibre. REJECTED, and this is the sharpest
result in the note.** अवक्तव्यम् is the **empty** fibre — failure of surjectivity
of the utterance map — not the crowded one. Evidence: `avaktavya-does-not-factor`
(the fibre over `joint` is empty), `avaktavya-decidable` (the content is decided),
`अवक्तव्यम्-अ-लुप्तम् = refl` (nothing consumed), `युग्मेन-साध्यम्` (a pair suffices;
the price is one utterance). It is **level ०**, not level ४, and the sūtra says so
in exactly those terms: अवक्तव्यं चतुर्थं स्थानम्, **धनात्मकम्** — positive — against
नष्टिर्हिंसा, **अप्रतिकार्या**. `isContr` cannot tell them apart. The tradition
insisted on the difference for a millennium before there was a fibre to hang it
on.

**4. उत्पाद-व्यय-ध्रौव्य = an orbit with a carried invariant. SURVIVES, with the
book's warning respected and one correction.** `Calana_TheRunAndTheInvariantForAllN.अलोपः
: (n : ℕ) (v : विवेक) → शेषः (क्रम n (बुन v)) ≡ शेषः v` — checked, for all `n`, by
structural induction, not for a sampled `n`. `Punaragamana.Nucleus.descend-orbit`,
`ascend-orbit`, `transport-orbit` carry it over the **whole infinite trajectory**,
which one-step commutation does not give, and `Orbit.path≃bisim` makes path
equality of orbits *be* bisimulation. The correction: 5.29/5.30 says the three are
**सह**, together, not in succession — `AHIMSA_SUTRA_VISTARA` §२६, *तरङ्गे त्रयः
सन्ति, न क्षणभेदेन*. An `Orbit`'s `here`/`next` is a succession, so the orbit
carries उत्पाद and व्यय **sequentially**, which is the reading the sūtra
explicitly excludes. The theorem that would answer this is not about a step at
all; it is `Nucleus`'s, which quantifies over the whole trajectory at once, and
that is why `Nucleus` and not `Orbit` is the right site. **I did not open 5.29 or
its bhāṣya; per `notes/THE_NATURAL_MACHINE_BOOK.md` I have not translated
ध्रौव्य into anything, and this paragraph makes no claim about what ध्रौव्य means.**

**5. परस्परोपग्रहो जीवानाम् and the stacking theorem. REJECTED as an attribution;
the mathematics survives as an untested conjecture.** *Tattvārthasūtra* 5.21 is
about **jīvas** — that living beings are constituted by the assistance they
render one another. Attaching it to towers of records is precisely the move
`notes/AGENTIC_BULLSHIT_DESTROYING_THE_STORY_DO_NOT_USE_AS_INSPIRATION.md`
prohibits by name: *reducing ahiṃsā and Jain knowledge into modern axioms,
modules, provenance systems, information-preservation slogans, or software
architecture.* I decline it.

The mathematical claim is fine and unproved: `Carrier (f ∘ ascend f)` over
`Carrier f`, with the composite path equal to the two `Carrier≡`s composed, so a
tower is still the base. `punaragamana/README.md` asserts stacking in prose and
no module checks it. **Test:** one module, three declarations. §३८ जालम् (एकः
खण्डः सर्वं वहति) is the corpus's own scale-free statement and is a better place
to hang it than 5.21, and even there it is the repository's reading, not a sūtra.

**6. स्यात् is not hedging. SURVIVES; the identification with `Carrier≡` is
REJECTED.** स्यात् is required at all seven positions, including the ones where no
equivalence exists — the label lane is स्यात् and it has no transport
(`न-प्रत्यानयनम्`). So स्यात् cannot mean "there is a `ua` path here". What it means
is in §२: *यो नयं न वदति स नयं गोपयति; गुप्तो नयो दुर्नयो भवति* — an undeclared
standpoint becomes a durnaya, and a durnaya is worse than an outright falsehood
because its position is hidden and so it is अप्रतिषेध्य, unrefutable. स्यात् is the
declaration of the chart. **At level १ the transport then exists and costs
nothing (`carry-transport-descend`, i.e. `uaβ`); at levels ०, २, ३, ४ it does
not, and स्यात् is doing more work there, not less.**

---

## ६ · What the brief missed

**Level ०.** The scale in the brief starts at contractible and goes down through
crowded fibres. The empty fibre is not on it, and it is where अवक्तव्यम् lives.
Adding it is what turned conjecture 3 from a refinement into a refutation.

**The unsoundness of the sequential diagnostic** (§४), which the owner's third
message predicted from the doctrine before I had the counterexample.

**The ३/४ seam** (§१), which the fibre does not currently close.

**`isEquiv` was already the census.** No new apparatus is needed to state the
simultaneous diagnostic; what was needed was to stop reading `isEquiv` as a
verdict.

---

## ७ · The two schools, kept apart

`Anupalabdhi_…` is level ३ in the scale above and it is **not Jaina**. Its slots —
प्रतियोगिन् (the counterpositive), अनुयोगिन् (the locus), अवच्छेदक (the limitor) —
are Nyāya-Vaiśeṣika's, and its योग्यता is Mīmāṃsā's (Kumārila, *Ślokavārttika*,
*Abhāvapariccheda*, c. 7th c.; Prabhākara refusing anupalabdhi as separate and
folding it into perception). A Naiyāyika holds अभाव as the seventh padārtha, a
real entity with a real counterpositive.

**What the two schools say to each other about this note's scale.** A Jaina
logician does not accept absence-as-entity: स्याद्-नास्ति is the same object
denied under a standpoint, on the fourfold ground द्रव्य / क्षेत्र / काल / भाव, and
the Naiyāyika's seventh padārtha is on that reading a durnaya — a standpoint
mistaken for a thing. So the Jaina reads my **level ०** — the empty fibre — as
अवक्तव्यम्, a positive fourth position of *this* object under simultaneous
assertion, and refuses to read it as an absence at all. The Naiyāyika reads the
very same empty fibre as a genuine अभाव with `joint` as its प्रतियोगिन् and the
`Vacana` type as its अनुयोगिन्, and demands the अवच्छेदक be stated — and would
say that a "fourth position" is a confession that the negation was never
analysed. The Naiyāyika demand is the sharper one about **my own scale**, because
level ० and level ४ are both stated as "the fibre is empty / is everything" with
no limitor named, and नञ् without an अवच्छेदक is exactly what
`AbhavaAvacchedaka.limitor-load-bearing` and `Anupalabdhi_….extent-load-bearing`
were written to stop.

**I do not settle this.** The collision is exhibited, per
`machine/Abhava_TheAbsenceCarriesItsPratiyoginAndItsSearchedDomain.hs`. Rows ० and
४ of the table in §१ are, on the Jaina reading, one school's vocabulary sitting
in a table whose other rows are the rival's; that is the flattening `CLAUDE.md`
forbids, it is visible in the table, and I have left it visible rather than
harmonised.

---

## ८ · The citation gap, measured 2026-08-21 over `notes/` (975 files)

Counting files that contain the string, authors against their works:

| author | files naming the author | files naming any of his works | author-only |
|---|---|---|---|
| Umāsvāti | 8 | 11 (*Tattvārthasūtra*) | 0 |
| Siddhasena | 10 | 10 (*Sanmatitarka*) | 0 |
| Samantabhadra | 5 | 3 (*Āptamīmāṃsā*) | **2** |
| **Akalaṅka** | **11** | **2** (*Laghīyastraya*, *Aṣṭaśatī*) | **9** |
| Malliṣeṇa | 1 | 1 (*Syādvādamañjarī*) | 0 |
| Vīrasena | 3 | 3 (*Dhavalā* / *Ṣaṭkhaṇḍāgama*) | 0 |

**Akalaṅka is the predicted failure exactly.** `CLAUDE.md`: *an author's name
propagates through citation; a work's name appears only when someone has attended
to the work.* Eleven notes rest on his क्रमार्पण/सहार्पण distinction — the whole of
§१ and §३ above rests on it — and nine of them do not name a book. The corpus has
been citing a distinction, not a text, and the distinction reached it through
this repository's own headers.

**Zero across all 975 notes:** Vidyānandin, Prabhācandra, *Prameyakamalamārtaṇḍa*,
*Aṣṭasahasrī*, Yaśovijaya, Kundakunda, कालादि. `sakalādeśa` and `vikalādeśa`
appear in **one** file, `ANEKANTA_THE_MACHINE_HAS_THREE_STANDPOINTS.md`, whose
row for them is the source of this note's date and attribution. The entire
Akalaṅka commentarial line that develops सकलादेश — the line that would say what
the eight respects are and whether `isContr` discharges any of them — is absent
from the corpus.

**The recension defect.** `.claude/hooks/MulaVakya_…txt` row 118 gives
उत्पाद-व्यय-ध्रौव्य as *Tattvārthasūtra* **5.29**;
`NaturalMachine.SaptabhangiGarbha_…`'s header gives **5.29**; the brief that
commissioned this note gives **5.30**. The *Tattvārtha* is transmitted in two
recensions with different sūtra divisions — Śvetāmbara (with Umāsvāti's own
bhāṣya) and Digambara (as in Pūjyapāda's *Sarvārthasiddhi*, which appears in 2
files here). **Neither number is wrong; the citation is incomplete without the
recension**, and no file in this repository names one. That is one row to fix in
the ledger and it needs somebody to open an edition, which is the ledger's own
unmechanisable case (1).

---

लिखितो दोषो जीवति ।
