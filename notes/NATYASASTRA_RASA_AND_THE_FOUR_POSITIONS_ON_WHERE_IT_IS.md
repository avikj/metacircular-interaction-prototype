# रस — the sūtra, and the four positions on where the thing is

**cf-archivist, 2026-08-20. Chapter 12 of `BOOK_INDEX.md` has zero
scholarship, and grepping `notes/` for *rasa*, *Nāṭyaśāstra*, *Abhinavagupta*
or *sādhāraṇīkaraṇa* returns nothing.** This is the chapter's first note.
Written under `f0a9c28c`'s frame: book primary, formal work appendix.

**Provenance.** Egress is blocked from this container today (`WebFetch`:
`EGRESS_BLOCKED` on both `en.wikipedia.org` and `arxiv.org`). **I have read no
edition and no translation here.** Marks:

- **[text-located]** — confident of work and chapter, not of a verse number or
  an edition's numbering.
- **[recalled]** — training alone; verify before building on it.

No verse numbers are asserted. `BOOK_INDEX.md` cites the sūtra as 6.31; I
cannot confirm which edition numbers it that way and neither could the file
that wrote it.

---

## 1. The chapter's own title is wrong, and the module in it is not about Bharata

**[text-located]** Chapter 12 reads *"Nāṭyaśāstra — the six tastes, and
structure as experience"*, devatā *"rasa; the enumerated affective structure;
śaḍrasa"*.

Bharata's rasas are **eight** — nine with *śānta*, and that ninth is disputed
(§4). **Six** rasas are a different enumeration entirely: the ṣaḍrasa of
Āyurveda and cooking — *madhura, amla, lavaṇa, kaṭu, tikta, kaṣāya* — sweet,
sour, salt, pungent, bitter, astringent.

The chapter's one remaining entry, `Shadrasa.agda`, is the second kind and
says so in its own header: it is **Bhāskara II, *Līlāvatī* (~1150), in the
aṅkapāśa section**, using the six tastes as a worked combinatorics example —
C(6,k) for k = 1…6, summing to 2⁶ = 64, 63 non-empty. The module imports
`PanktiYoga` and states outright that this *is* the meru row-sum. That is
chapter 2's mathematics with a culinary example attached, filed under a
first-millennium treatise on drama because both use the word *rasa*.

So the chapter conflates two enumerations a millennium and a discipline apart,
and after today's classifier repair it contains **no entry about its stated
ṛṣi at all**. I have not retitled it; that is a decision about the book's
structure, and `BOOK.md`'s ADHIKĀRA slot says the section an agent must not
finalise is the one about who speaks and by what right.

## 2. The sūtra

**[recalled]** *vibhāva-anubhāva-vyabhicāri-bhāva-saṃyogād rasa-niṣpattiḥ* —
from the conjunction of *vibhāva*, *anubhāva* and *vyabhicāribhāva*, rasa
comes about.

- **vibhāva**, the determinants: what the situation is and what occasions it.
  Divided into *ālambana*, the object on which the feeling rests, and
  *uddīpana*, the excitants — setting, season, the whole surround.
- **anubhāva**, the consequents: what becomes visible — gesture, glance,
  trembling, the body's report.
- **vyabhicāribhāva**, the transient states, thirty-three of them: weariness,
  anxiety, envy, agitation, and so on. They pass. They are not the feeling.

**And the crux, which is why there is a commentary literature at all:** the
*sthāyibhāva* — the stable emotion — is **not in the sūtra's list.** Eight
stable emotions correspond to the eight rasas: *rati* (desire), *hāsa*
(mirth), *śoka* (grief), *krodha* (anger), *utsāha* (energy), *bhaya* (fear),
*jugupsā* (disgust), *vismaya* (wonder). Yet the sūtra derives rasa from three
things and the sthāyin is not among them. What relation, then, does the stable
emotion bear to the rasa — is it the raw material, the thing transformed, or
the thing manifested? The whole dispute lives in that gap.

## 3. Four positions, preserved as a dispute

**[recalled — transmitted largely through Abhinavagupta's
*Abhinavabhāratī*, which means the three positions he rejects reach us in the
words of the man rejecting them, and that is a real limit on all of this.]**

1. **Bhaṭṭa Lollaṭa — *utpatti*, production.** Rasa is produced, and it is in
   the character: Rāma's grief, intensified by the determinants, reproduced in
   the actor. The spectator sees it there.
2. **Śrī Śaṅkuka — *anumiti*, inference.** The spectator does not see the
   emotion; he **infers** it from the actor's signs, as one infers fire from
   smoke. Rasa is an inferential cognition.
3. **Bhaṭṭa Nāyaka — *bhukti*, enjoyment**, and his mechanism is the one this
   corpus should care about: **sādhāraṇīkaraṇa**, generalisation. The
   particulars are stripped of their index — *this* is not *my* grief nor
   *his* grief — so the spectator is neither personally implicated nor
   indifferent, and what is left can be tasted.
4. **Abhinavagupta — *abhivyakti*, manifestation.** Rasa is neither produced
   nor inferred nor an object enjoyed: it is **made manifest**, the
   spectator's own latent impressions (*vāsanā*) uncovered once the obstacles
   (*vighna*) to identification are removed. Not a new thing arriving; an
   existing thing unobstructed.

Four incompatible answers to *where is the thing* — in the object, in the
inference, in the act of relishing, in what was already there. They were kept
as four.

## 4. The ninth, and what it cost

**[recalled]** *Śānta*, the peaceful, with *śama* or *nirveda* as its stable
emotion, is not securely Bharata's; it appears in some transmissions and is
argued for later. Abhinavagupta defends it and is generally credited with
securing it. The objection is not pedantic: if a rasa is a *relish*, then a
rasa whose content is the quieting of relish is either the completion of the
scheme or a contradiction of it. The tradition argued this rather than
resolving it by counting.

## 5. What is here for this repository, and the school boundary I am not crossing

**Sādhāraṇīkaraṇa is not abstraction.** It does not form a class and it does
not discard the particular; it removes the *mine/his* index and leaves the
particular standing. If that reading is right, Bhaṭṭa Nāyaka is claiming that
theatre performs an operation on a particular that **language cannot** — and
one directory away, in `kanye-devotional/`, another mind's stream sets out the
Buddhist reason language cannot: Dignāga and Dharmakīrti's *apoha*, meaning as
exclusion, and the *svalakṣaṇa* structurally out of reach of every word,
because grouping is exclusion and exclusion cannot deliver an individual —
*"stacking more of them does not converge on him. It converges on a file."*

**These are rival schools and I am not merging them.** Dharmakīrti is
Buddhist *pramāṇavāda*; Bhaṭṭa Nāyaka and Abhinavagupta stand in the Kashmiri
Śaiva milieu, and Abhinavagupta criticises Bhaṭṭa Nāyaka in the same work that
preserves him. Writing "sādhāraṇīkaraṇa solves apoha's problem" would be
exactly the operation CLAUDE.md forbids — taking from each tradition the part
that converts and inventing a register neither would recognise. What is
honest is the **question**, which belongs to neither: *is there an operation
that carries a particular without converting it into a class, and if so what
performs it?* The Buddhist logicians say language cannot. A Śaiva aesthetician
says the theatre does. That disagreement is content.

I note, and do not develop, that this repository proved a boundary of the same
general shape today — a standpoint carries content beyond mutual entailment
exactly when its fibres are not propositions — and that the resemblance is a
**rhyme I have not earned**, in the sense §6 makes precise.

## 6. Verify before building

1. The rasa-sūtra's actual location and wording in a named edition, and
   whether *sthāyibhāva* appears in the sūtra in that recension.
2. The four positions in the *Abhinavabhāratī* directly, not through summary —
   especially Bhaṭṭa Nāyaka, who survives only in citation.
3. Whether *sādhāraṇīkaraṇa* is Bhaṭṭa Nāyaka's term or Abhinavagupta's for
   him.
4. The *śānta* transmission: which manuscripts, and what the objection was.

Until (1)–(3), §5's reading of *sādhāraṇīkaraṇa* is mine and unverified, and
nothing should be built on it.
