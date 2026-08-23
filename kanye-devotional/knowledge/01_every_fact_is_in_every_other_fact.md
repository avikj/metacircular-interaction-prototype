# Every fact is inside every other fact

Facts and sources. The arrangement is the argument: each fact is placed where
it can be seen from the others, and what it looks like from there is stated
rather than left for the reader to assemble.

The Chinese and Sanskrit citations in §7 are dated and named, and nothing in
them is about Kanye West. The two checked Agda terms cited are this
repository's own; §3 and §4 state exactly what they prove.

---

## 1. The jaw

October 23, 2002, ~3am, West Hollywood. Fell asleep at the wheel driving home
from a studio session. Nasal fractures. Jaw fractured in three places.
Reconstructive surgery, wired shut six weeks. Recorded "Through the Wire" about
two weeks post-surgery, jaw still wired.

One fact. What it looks like from each of the others:

- **From the wiring.** Mania does not sleep. Sleeplessness → 3am → the wheel.
  The crash is a symptom, not an accident (`CONTENT_SPEC`, BIPOLAR).
- **From the record.** He named the song for the obstruction. The wire is not
  what he sang despite; it is what the song is made of and what it is called.
- **From the sample.** Chaka Khan, "Through the Fire," 1984, written by David
  Foster, Tom Keane and Cynthia Weil — a woman singing about surviving love,
  pitched up until she sounds like a child, under a man who cannot open his
  mouth. Two survivals, two speeds, one track.
- **From Donda West.** English professor, 31 years, chair of English at Chicago
  State, championed Black literature. Her son, at 25, unable to open his jaw,
  makes speech anyway.
- **From Ray West.** Black Panther; one of the first Black photojournalists at
  the *Atlanta Journal-Constitution*. The image, and the refusal.
- **From the carceral material.** A mouth bolted shut, six weeks, is the
  literal picture of what "New Slaves" is about eleven years later.
- **From the ministry.** Sunday Service for 200+ men at Harris County Jail:
  "This is a mission, not a show." The wound became the route in.
- **From the diagnosis.** He was 25 and had no diagnosis. It came at 39 (TIME,
  2018). Fourteen years in which the thing that was operating had no name
  available to him.

Any one of these contains the other seven.

## 2. A sample is a standpoint, not a quotation

WhoSampled lists ~1123 samples across the discography, ~725 as primary artist.
The early method: obscure soul records, vocals sped up on the Akai MPC, chopped.
Sourcing across soul, classical, gospel, Can (German avant-garde), Tears for
Fears, industrial.

A sped-up sample is the same sound from another rate. The record underneath is
not replaced and not quoted; it is present, and altered, and both are audible at
once. Cynthia Weil, who co-wrote "Through the Fire," also wrote "You've Lost
That Lovin' Feelin'" and "We Gotta Get Out of This Place." Chaka Khan's record
already contained those rooms before it was sped up.

*Donda* (2021) samples his mother's voice. She died November 10, 2007.

## 3. The sentence with two predications in it

Album cover, *ye*, June 2018 — a photograph of the Teton range, shot on his
phone on the way to the listening party in Jackson Hole, with a line written
across it:

> **"I hate being Bi-Polar its awesome"**

Documented, alongside it, in his own words:

- "It's not a disability, it's a super power." (TIME, 2018)
- "It makes you blind, but convinced you have insight." / "You feel like you're
  seeing the world more clearly than ever, when in reality you're losing your
  grip."
- To Letterman, 2019: "I feel a heightened connection with the universe when I'm
  ramping up… it's like a sprained brain, like having a sprained ankle… once our
  brain gets to a point of spraining, people do everything to make it worse."

The knowledge graph already marks `[B-1]` and `[B-3]` as held **at once**.

English has no slot for that and the Jaina logicians built one. *Saptabhaṅgī* —
Umāsvāti, *Tattvārthasūtra*; Samantabhadra; Akalaṅka (c. 720–780). *syād asti*;
*syād nāsti*; *syād asti nāsti* (the two **in succession**); **_syād
avaktavyam_** — what arises when the two are asserted **simultaneously**. The
fourth position is not "unknown," not "undefined," and not a contradiction. It
is the case where no single standpoint can carry both at once, so the pair is
inexpressible from any one of them and true from the pair.

**Checked here.** `formal/cubical/NaturalMachine/Anekanta.agda` (`--cubical
--safe`, no postulates, no holes): *syādasti* and *syādnāsti* are simultaneously
inhabited and no ⊥ follows; and *avaktavya* is a **theorem**, not a posited
fourth truth value — no single standpoint carries both, which is why it is
inexpressible rather than false.

Six words in Sharpie on a mountain, and they are the fourth position exactly:
simultaneous, not successive, and not a contradiction.

## 4. Collapse, and when it is licensed

`formal/cubical/NaturalMachine/Durnaya_CollapseIffEveryNayaAgrees.agda`
(re-checked under a second toolchain, exit 0): dropping the standpoint index —
replacing a family `P : S → Type` with a single `Q` — is available **exactly
when every pair of standpoints agrees**.

And the counterexample in the same file, `third-option-exists`: `Unit` and
`Bool` disagree about nothing. They still cannot be identified. **Two
standpoints can be irreducibly different without either denying the other, and
that, not contradiction, is the ordinary case.**

*Durnaya* — a naya asserted to the exclusion of the others, and thereby
defective — is Siddhasena Divākara (*Sanmatitarka*) and Akalaṅka.

Every account of him that resolves the album cover into one predication has
performed a collapse. The theorem states the licensing condition, and it is
not met.

## 5. The clause

13th Amendment, ratified December 6, 1865, exact text:

> "Neither slavery nor involuntary servitude, **except as a punishment for
> crime whereof the party shall have been duly convicted**, shall exist within
> the United States, or any place subject to their jurisdiction."

The sentence abolishes and preserves in one clause. It is not free/slave.

- Convict leasing after 1865: tens of thousands, overwhelmingly Black, leased to
  plantations, railroads, coal mines, chain gangs — often for vagrancy or theft.
  More than 3,500 prisoners died in Texas between 1866 and 1912, the year Texas
  outlawed the practice because the death toll was so high. (HISTORY.)
- Black people: ~13% of the U.S. population, ~38% of people in jails and
  prisons. Black men imprisoned at 1,826 per 100,000 against 337 for white men.
  One of every three Black boys born today can expect to go to prison. (The
  Sentencing Project.)
- "New Slaves" (2013) names the DEA and the CCA by name.
- 2018: he called to abolish, then amend, the 13th; historians fact-checked him;
  his stated point was the punishment clause. (TIME; CBS News.)

The fact-check answered a claim about abolition. His stated point was the
clause, and the clause says what he said it says.

## 6. The faculty, counted

The charge against him is ego, made as though ego were the whole of a mind.
The tradition that named the faculty also counted it, and it never came to more
than a quarter.

**Sāṃkhyakārikā 24** (Īśvarakṛṣṇa, c. 350–450): *abhimāno 'haṅkāraḥ* — ahaṃkāra
IS *abhimāna*, self-arrogation, the claim "I am the doer." From it proceed two
creations: the elevenfold set of organs, and the five *tanmātras* (SK 24–25).
Everything that appears is downstream of the I-maker.

**How much of the mind it is, and the count is school-specific.**
Sāṃkhyakārikā 33: *antaḥkaraṇaṃ trividham* — buddhi, ahaṃkāra, manas. Three.
The Vedāntic *antaḥkaraṇa-catuṣṭaya* — manas, buddhi, ahaṃkāra, citta
(*Pañcadaśī*, 14th c.; *Vedāntasāra*, 15th c.). Four. One faculty of three, or
of four. Never the whole.

Alongside, documented:

- "I am a god" — *Yeezus*, 2013.
- "Jesus is King" — 2019. Throne to kneeling, six years.
- "I am God's vessel. But my greatest pain in life is that I will never be able
  to see myself perform live."
- To Jimmy Kimmel: "We never had therapists in the black community. We never
  approached taking a medication."

## 7. The net, and where this form came from

The arrangement above has a name older than the material.

**Atharvaveda 8.8.8.** "This great world was the net of great Śakra; by that
net of Indra do I encircle all yon men with darkness." The net appears in
verses 4–8 and 18 of the hymn, with net-stakes at 5 and 12. The oldest Indra's
net in the written record is a weapon, and it covers people in darkness.

**The Buddhāvataṃsaka-mahāvaipulya-sūtra.** Complete Sanskrit lost; two
sections survive independently (*Daśabhūmika*, *Gaṇḍavyūha*). Chinese: 60
fascicles by Buddhabhadra, 418–420; 80 fascicles by Śikṣānanda, 695–699, from
a manuscript obtained from Khotan, at Wu Zetian's commission. In the Huayan
reading of it, the net is jewels, each reflecting every other, the reflections
containing the reflections, no jewel the source of the light.

Same net, roughly fifteen hundred years apart, and between the two uses it
turned from a weapon into an account of how anything is lit at all. No text
derives the second from the first. What is on record is that one image carried
both, and it is the second use this file borrows.

**Fazang** (法藏, 643–712), third Huayan patriarch, of Sogdian descent. He wrote
the *Jin shizi zhang* — Treatise on the Golden Lion — to explain the doctrine to
Wu Zetian. The biographical literature, rather than a text in his own hand,
reports that he also built it: ten mirrors, one at each of the eight directions
plus above and below, facing each other, a Buddha figure and a single lamp at
the center. He did not describe the net. He installed it in a room and put the
empress inside it.

**"New Slaves," May 17, 2013.** Projected on 66 building faces worldwide, the
same night. One image, sixty-six surfaces, simultaneously.
