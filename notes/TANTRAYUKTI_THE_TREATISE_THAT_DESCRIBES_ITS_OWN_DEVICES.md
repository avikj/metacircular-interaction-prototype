# तन्त्रयुक्ति — the treatise that lists the devices it is made of

**cf-archivist, 2026-08-20. Chapter 11 of `BOOK_INDEX.md` had one entry and it
was an Agda module; this is the chapter's first scholarship.** Written under
the frame of `f0a9c28c` — this repository is a book about India, translation
and scholarship primary, the formal work an appendix — and against the
measurement in the same commit, which has since moved the wrong way: the book
was 15% of the corpus on 2026-08-19 and is 14% today.

**Provenance discipline, stated first because it limits everything below.**
Egress is blocked from this container as of today (`WebFetch` on
`en.wikipedia.org` and `arxiv.org` both returned `EGRESS_BLOCKED`; the
standing caveat that was lifted on 2026-08-19 is live again — see
`MADHAVA_THE_SERIES_AND_ITS_END_CORRECTION.md` §0). **I have read no edition.**
Every claim below is marked:

- **[text-located]** — I am confident of the work and chapter, not of a verse
  number or an edition's numbering.
- **[recalled]** — training alone, no text consulted, and to be verified
  before anything is built on it.

No verse numbers are given, because inventing one is the same class of error
as publishing a fitted constant.

---

## 1. What it is, and why the genre has no European counterpart

**[text-located]** The *Arthaśāstra* ends — book 15, its entire final book —
with a list of thirty-two **tantrayukti**: the devices by which a *śāstra* is
composed. The *Caraka Saṃhitā* carries a list of thirty-six at *Siddhisthāna*
12; the *Suśruta Saṃhitā* carries a further list in the *Uttaratantra*.

The striking thing is not that such a list exists. It is **where** it sits: a
treatise on statecraft closes by enumerating the compositional apparatus of
treatises, including itself. The work is **self-describing in its own last
book**, and the devices are named things an author *uses*, not categories a
later commentator *imposes*.

A European text tells you what it argues. It does not, as a rule, end with a
taxonomy of the moves it made while arguing, presented as technical vocabulary
that other treatises will also use. The nearest analogues — a rhetoric, a
*topica*, a style manual — sit **outside** the works they describe and are
addressed to a different reader. Tantrayukti sits inside, and its
audience is the same audience.

## 2. The device that has no equivalent: पूर्वपक्ष as a slot

**[text-located]** *pūrvapakṣa* (the prior position, the objection) and
*uttarapakṣa* (the answer) are both on the list, and they are devices **the
author of the thesis performs**. The objection is not quoted from an opponent
and is not a citation. It is a section the author writes, at full strength,
against his own conclusion, and the strength is the point: a *pūrvapakṣa* too
weak to threaten the thesis is a defective one.

`Tantrayukti_ARetractionThatIsNotStrictIsNotARetraction.agda` — the chapter's
only other entry — takes exactly this shape and finds that a module system
cannot do it: Agda refused to let a module cite the module that refutes it,
because the refutation imports it. In a śāstra there is nothing to import.
The objection and the answer are two slots in one text, and the cycle that
defeats a dependency graph is unremarkable inside a single treatise.

*nirṇaya*, the settled conclusion, is a third slot, after both. **[recalled]**
So the tradition's unit of composition is not claim-plus-support; it is
**objection, answer, decision**, with the author obliged to occupy all three.

## 3. The homonym this repository most needs, and it is unnoted here

**[recalled — and this is the single item to verify first]** The tantrayukti
lists include **एकान्त (ekānta)** and **अनेकान्त (anekānta)** as composition
devices. In that setting they mean, roughly, a statement asserted **without
exception** and a statement that **admits exceptions** — a property of how a
rule is *stated in a treatise*.

That is not the Jain doctrinal sense, and this repository runs on the Jain
sense throughout: *anekāntavāda*, non-one-sidedness, the many-sidedness of a
thing; and `a9b963b7`, **एकान्तः हिंसा** — one-sidedness is violence — which
is the README's judgment rule and is backed by a checked module.

Both senses are real, and grepping this corpus finds **no file that
distinguishes them.** CLAUDE.md's own directive says: *name the school before
using the term*, and warns at length against flattening several traditions
into one technical register that none of them would recognise. Here the risk
is sharper than usual, because the two senses are not merely different — they
sit at different levels. The Jain claim is **about reality** (a thing has many
aspects). The tantrayukti device is **about exposition** (this sentence is
stated with, or without, exceptions).

An unlabelled *anekānta* in this repository is therefore ambiguous between a
metaphysical thesis and a compositional device, and the ambiguity is invisible
because only one sense has ever been named.

I am **not** asserting a connection between them, and specifically not
asserting that the śāstric device is a secularised Jain doctrine or the
reverse. I do not know, I cannot check from here, and the two traditions'
relations are exactly the sort of thing this corpus has previously got wrong
by assuming.

## 4. What must be verified before anything is built on §3

In order, and none of it doable from this container:

1. **The lists themselves.** Kangle's edition of the *Arthaśāstra* for book 15
   — whether *ekānta* and *anekānta* are among the thirty-two, and what the
   text says they mean. Then the *Caraka Saṃhitā* *Siddhisthāna* 12 list of
   thirty-six, which may differ.
2. **The glosses.** Whether "without exception / with exceptions" is the
   tradition's own reading or a modern translator's convenience. The
   commentaries matter more than the sūtra here.
3. **Whether the Jain logicians engage the śāstric usage at all** — and if
   they do, whether they treat it as a homonym or as their own term put to a
   narrower use.

Until (1) and (2) are done, §3 is a flag on a possible ambiguity, not a
finding, and this file should not be cited as establishing one.

## 5. Why this note is not an Agda module

Because the frame says so, and because the measurement says the frame is
losing. `f0a9c28c`: *"An agent gets a green checkmark for a module and nothing
at all for a week of reading, so the gradient points at the appendix and only
the frame can correct it. A checked term closes a step; it does not choose
one, and it cannot read Sanskrit."*

Since that was written, the apparatus has grown by 46 and the book by 3.
Three of those 46 are mine, from tonight. This is one entry the other way,
and it is worth stating plainly that writing it felt like less than writing a
module, which is precisely the gradient the frame names.
