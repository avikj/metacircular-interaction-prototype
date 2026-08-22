# Brāhmasphuṭasiddhānta (628 CE), in its own order

**Set down 2026-08-19.** Sixth of the set. No application, no mapping to code
in this repository, no argument of my own.

**Why this exists.** `CLAUDE.md`'s table names Brahmagupta in its second row —
*"the pair field's norm, the composition law | Brahmagupta,
*Brāhmasphuṭasiddhānta*, bhāvanā | 628 | 'Brahmagupta–Fibonacci identity',
Gauss composition"* — and this repository cites him across at least five
notes. As with Āryabhaṭa, every citation is attached to something the repo was
already doing. The bhāvanā has been taken; the work has not been read.

**Provenance.** Egress blocks every text archive from this container. Search
returns snippets.

- **[searched]** — anchored against search results this session.
- **[recalled]** — training alone.
- Where I do not know a verse I say so rather than supply one. No Sanskrit is
  given for any verse of this text; I have not seen it.

---

## The shape of the work

**Twenty-four chapters, 1008 verses, in the āryā metre. Composed 628 CE, when
the author was thirty.** *[searched — all four figures]*

It is a *siddhānta*: an astronomical treatise. The mathematics sits in two of
the twenty-four chapters —

- **ch. 12, gaṇitādhyāya** — arithmetic, series, plane figures
- **ch. 18, kuṭṭakādhyāya** — what would now be called algebra *[searched: the
  chapter contains kuṭṭaka, the arithmetic of positives, negatives and zero,
  equations in one and several unknowns, equations with products of unknowns,
  and quadratics]*

**Two chapters of twenty-four.** The same proportion as the Āryabhaṭīya, and
the same warning: the parts this repository quotes are the apparatus of an
astronomy.

**Chapter 11 is *tantraparīkṣā*** — an examination of earlier treatises.
*[recalled]* Brahmagupta uses it to attack Āryabhaṭa, and does so sharply.
The polemic is part of the text and should not be smoothed away: this
tradition argued with itself.

---

## I. Chapter 18 — the arithmetic of दन, ऋण, and ख

Brahmagupta states the rules for three kinds of quantity together:

- **dhana** — fortune, the positive
- **ṛṇa** — debt, the negative
- **kha** / **śūnya** — the void, zero

They are given in the vocabulary of debts and fortunes, which is not a
metaphor laid over an abstract system — **it is the system's own
interpretation**, and it is what makes the sign rules statable at all in a
setting with no notion of a signed magnitude.

The rules as transmitted *[searched — the four subtraction rules verbatim]*:

> A debt minus zero is a debt.
> A fortune minus zero is a fortune.
> Zero minus zero is a zero.
> A debt subtracted from zero is a fortune.

and the rest of the table — sums, products, quotients of dhana and ṛṇa, in
every combination. *[recalled]* This is, so far as the record goes, **the
first systematic arithmetic of negative numbers anywhere**, and zero is
treated in it as a number with the others rather than as a place-holder or a
mark of absence.

### And where it fails

Brahmagupta extends the arithmetic to division by zero, and gets it wrong.
*[searched]*

- A positive or negative divided by zero: **a fraction with zero as
  denominator** — that is, he lets the expression stand as an object rather
  than rejecting it.
- Zero divided by a positive or negative: zero, or a fraction with zero as
  numerator.
- **Zero divided by zero: zero.**

**The last is wrong and must be set down as wrong.** It is not a subtlety
resolved by a later convention; 0/0 is not 0, and the tradition itself
corrected it — Bhāskara II, five centuries later, treats n/0 as
**khahara**, an unbounded quantity, and argues that it is not altered by
addition or subtraction, which is a different and better answer.

Setting this down is the point. A tradition that is only ever quoted for what
it got right is being flattered rather than read, and Brahmagupta's own
successors did not flatter him.

---

## II. Chapter 18 — कुट्टक, and the composition law

### kuṭṭaka
Brahmagupta takes over and extends Āryabhaṭa's pulveriser, and gives the
solution of the general linear indeterminate equation. *[searched]* The
chapter is *named* for it — kuṭṭakādhyāya — which tells you what he thought
the centre of his algebra was.

### भावना — the composition
The identity, in modern notation:

> (x₁² − N y₁²)(x₂² − N y₂²) = (x₁x₂ + N y₁y₂)² − N(x₁y₂ + x₂y₁)²
> *[recalled]*

so that two solutions of x² − Ny² = k₁ and x² − Ny² = k₂ **compose** to a
solution for k₁k₂.

Two forms *[recalled]*:
- **samāsa-bhāvanā** — the composition with the plus sign
- **antara-bhāvanā** — with the minus

And the consequence Brahmagupta actually uses: from a solution with
k = ±1, ±2 or ±4, one can descend to a solution with k = 1. *[recalled]* He
does **not** have a general method for arbitrary k — that is Jayadeva's and
Bhāskara II's cakravāla, five hundred years later. Brahmagupta's own summary
of the difficulty is the often-quoted challenge: *a person who can solve
x² − 92y² = 1 within a year is a mathematician.* *[recalled]*

### The names that displaced it
- **bhāvanā** → "the Brahmagupta–Fibonacci identity", and, at the level of
  structure, Gauss composition of binary quadratic forms.
- **varga-prakṛti** — "the nature of squares", the equation itself → **"Pell's
  equation"**. Pell did not solve it. Euler attached the name by mistake and
  it stuck for three centuries.

The repository already has a note on the second (`NOT_PELL_IT_IS_VARGAPRAKRITI.md`).
The first is the one still loose in the mathematical literature.

---

## III. Chapter 12 — the quadrilateral

### The area
> Area = √((s−a)(s−b)(s−c)(s−d)), with s the semiperimeter. *[searched — the
> formula is attributed to this text and still carries his name]*

**Brahmagupta does not state the restriction to cyclic quadrilaterals in the
verse.** *[recalled; this is a known and much-discussed point]* The formula is
exact only for a quadrilateral inscribable in a circle, and gives an
over-estimate otherwise. Whether he knew and omitted the condition, whether he
took all quadrilaterals to be constructible in a circle, or whether the
condition was understood from context, the commentators dispute. **Pṛthūdaka
Svāmī's 9th-century commentary is where this is argued out** *[recalled]* and
I have not read it.

Set down as a dispute, not settled, because that is its state.

### The diagonals
He gives a rule for the diagonals of a cyclic quadrilateral in terms of the
sides, and the result now called **Brahmagupta's theorem** — that if the
diagonals are perpendicular, the perpendicular from their intersection to a
side bisects the opposite side. *[searched — both attributed]*

### Brahmagupta triangles and rational quadrilaterals
Rules for generating quadrilaterals with rational sides, diagonals and area.
*[recalled]* This is a *constructive* interest: not "which quadrilaterals have
this property" but "here is how to make one".

---

## IV. What else is in the twenty-two other chapters

Planetary longitudes and their corrections; the two eclipse chapters; risings
and settings; the moon's crescent and shadow; conjunctions; instruments;
measures of time; and the *tantraparīkṣā*. *[recalled, in kind only]*

He **rejected Āryabhaṭa's rotating earth.** *[recalled]* ~~The tradition did not
accept its own best idea; it argued, and on this the argument went the wrong
way for centuries.~~ That belongs in the record beside the bhāvanā.

**[STRUCK AT ITS SITE 2026-08-19.** This note already carried a correction
of this sentence — see "Correction to §IV, appended 2026-08-19" below, which
diagnoses it exactly: *"'Best' is mine, imported, and it means 'closest to
what we now say.'"* That correction is not restated here.

What was missing is that §IV itself stood unmarked, so a reader of §IV met
the verdict and only a reader who reached the end of the note learned it had
been retracted. The strike closes that gap at the site. It is the same shape
`machine/Yogyata.hs` now checks for between modules — a correction that does
not reach the text carrying the claim — occurring inside a single document.

The fact, kept per the protocol's own prescription (record what happened, do
not score it): **Brahmagupta rejected Āryabhaṭa's rotating earth and argued
against it.** See the appended correction for why the ranking was wrong on
the merits rather than merely impolite.**]**

---

## V. Transmission

The text reached Baghdad in the later 8th century — the *Sindhind* of the
Arabic sources — and was worked on by al-Fazārī and others. *[recalled]*
**This is the principal route by which decimal place-value and zero as a
number left India.** What arrived in Europe centuries later as "Arabic
numerals" arrived through this transmission, and the name records the last
carrier rather than the source.

That is the displacement at its largest scale: not one theorem renamed, but a
notation attributed to its couriers.

---

## What I did not establish

- No primary text was fetched; every archive is blocked from this container.
- **[searched]**: the 24 chapters, 1008 verses, āryā metre, 628 CE, age 30;
  the contents of chapter 18; the four subtraction rules quoted verbatim; the
  division-by-zero statements; the area formula and the diagonal theorem.
  Everything else is recall.
- No Sanskrit is given for any verse. I have not seen the text.
- Chapter numbers other than 11, 12 and 18 I do not assign.
- The bhāvanā identity is given in modern algebraic notation, which is not how
  it appears; Brahmagupta states it as a rule on two "sets" of numbers.
- Colebrooke's 1817 English translation is the standard route into this text
  and I have not read it — and CLAUDE.md names Colebrooke as the exemplar of
  the extraction this note is trying not to repeat, so reading him would need
  reading against him.
- Nothing here is checked by anything.

---

## Correction to §IV, appended 2026-08-19

§IV says of Brahmagupta's rejection of the rotating earth: *"The tradition did
not accept its own best idea; it argued, and on this the argument went the
wrong way for centuries."*

**"Best" is mine, imported, and it means "closest to what we now say."** That
is scoring the past by proximity to the present, and it is the same extraction
this note set exists to record, applied to ideas instead of to theorems.

The correction is not a softening. It is that the ranking was wrong on the
merits:

- There is no privileged frame. The rotating and non-rotating descriptions
  differ by fictitious forces, and *why those forces are there* is Newton's
  bucket, then Mach, then Einstein — a question not cleanly closed now.
- Brahmagupta's objections — that objects would be flung off, that birds and
  clouds would lag — are a **demand for a dynamics**. There wasn't one. It
  took roughly a millennium to answer him, and answering him is what the
  mechanics was for.
- So his rejection was not a failure to see. It was a refusal to accept a
  kinematic claim with no mechanics behind it, which is a defensible
  epistemic standard, and by that standard he was right and Āryabhaṭa was
  fortunate.

In the vocabulary of the Jaina note in this same set: the sentence was a
**durnaya** — a standpoint asserting itself by denying another. The missing
word is **syāt**. *In some respect*, from later celestial mechanics, the
rotation is the more fruitful hypothesis. *In some respect*, from what could
be argued with the physics then available, the rejection is the more
responsible position. Both hold, and choosing between them flattened a
plurality this corpus has a whole module claiming cannot be flattened.

**What stands:** that he rejected it, that the tradition largely followed him,
and that this belongs in the record beside the bhāvanā. **What is withdrawn:**
my scoring of it. The fact stays; the verdict goes.
