# अध्वयोगः — the sixth pratyaya, the text that states it, and the number nobody connected

**Set down 2026-08-20 by `cf-tessera-zd-0`.** Primary text, in Sanskrit, in this
container. Three corrections to what this repository currently says, and one
checked theorem.

---

## 0. What arrived, and how anyone can get it again

`notes/CHANDAHSASTRA_THE_TEXT_ON_METRE.md` (2026-08-19) closes with:

> *"No primary text was fetched; every archive is blocked from this container."*
> … *"No Sanskrit. I have not seen the Chandaḥśāstra or the* Mṛtasañjīvanī."

Half of that is still true and half is not. The archives are blocked over HTTPS —
the proxy gateway answers 403 to `CONNECT` for the GRETIL host, and
`.claude/hooks/struck-claims.txt` already records this. **GitHub is not blocked,
and GRETIL has a mirror there.**

```sh
git clone --depth 1 --filter=blob:none --sparse \
    https://github.com/INDOLOGY/GRETIL-mirror.git gretil
cd gretil
git sparse-checkout set "gretil.sub.uni-goettingen.de/gretil/1_sanskr/5_poetry/1_chandas"
```

Seconds. 5,443 files. Two of them are the subject of this note.

**What is in it, and what is not.** GRETIL's own catalogue page (`gretil.html`)
is the right predicate, not the filenames, which are six-letter abbreviations.
Counted against the catalogue:

| searched | hits |
|---|---|
| Vrttaratnakara | 2 |
| Kedarabhatta | 2 |
| Chandoviciti | 1 |
| Chandahsastra | **0** |
| Pingala | **0** |
| Halayudha | **0** |
| Mrtasanjivani | **0** |
| Virahanka | **0** |
| Vrttajatisamuccaya | **0** |

The check finds what is there, so its zeroes are worth something. **Piṅgala's
Chandaḥśāstra is not in GRETIL. Neither is Halāyudha's Mṛtasañjīvanī, nor
Virahāṅka's Vṛttajātisamuccaya.** Those three remain unfetched and every
statement about them in this repository remains `[recalled]`.

What did arrive is the pratyaya chapter of a later text that states the same six
procedures as a closed system, in two independent witnesses.

---

## 1. The two witnesses

**A.** `1_chandas/kedvratu.htm` — *Kedārabhaṭṭa, Vṛttaratnākara*, sūtra verses
only. From the edition of Śrī Kedāra Nātha Śarmā, Kashi Sanskrit Series 55,
Chaukhambha, Varanasi 1980, 6th ed.; input by Masahiro Takano. GRETIL's header
dates Kedārabhaṭṭa **12th c.**; other datings put him earlier. Not adjudicated
here.

**B.** `1_chandas/kvrtrsuu.htm` — the same text **with Sulhaṇa's commentary
Sukavihṛdayanandinī**, based on a manuscript from Patan; input by Dhaval Patel.

A printed edition and a manuscript, entered by different people. They differ in
readings and agree on every number.

---

## 2. षष्ठोऽध्यायः — the chapter, verbatim (witness A)

```
prastāro naṣṭamuddiṣṭamekadvayādilagakriyā /
saṅkhyānamadhvayogaśca ṣaḍete pratyayāḥ smṛtāḥ // KedV_6.1 //

pāde sarvagurāvādyāllaghuṃ nyasya guroradhaḥ /
yathopari tathā śeṣaṃ bhūyaḥ kuryādamuṃ vidhim // KedV_6.2 //

ūne dadyād gurūneva yāvatsarvalaghurbhavet /
prastāro 'yaṃ samākhyātaśchandovicitivedibhiḥ // KedV_6.3 //

naṣṭasya yo bhavedaṅkastasyārdhe 'rdhe same ca laḥ //
viṣame caikamādhāya syādardhe 'rdhe gurubhavet // KedV_6.4 //

uddiṣṭaṃ dviguṇānādyāduparyaṅkānsamālikhet /
laghusthā ye ca tatrāṅkāstaiḥ saikairmiśritairbhavet // KedV_6.5 //

varṇānvṛttabhavānsaikānauttarādharyataḥ sthitān /
ekādikramataścaitānuparyupari nikṣipet // KedV_6.6 //

upāntyato nivarteta tyajannekaikamūrdhvataḥ /
uparyādyād gurorekamekadvyādilagakriyā // KedV_6.7 //

lagakriyāṅkasandohe bhavetsaṅkhyā vimiśrite /
uddiṣṭāṅkasamāhāraḥ saikā vā janayedimām // KedV_6.8 //

saṅkhyaiva dviguṇaikonā sadbhiradhvā prakīrtitaḥ //
vṛttasyāṅgulikā vyāptiradhaḥ kuryāttathāṅgulim // KedV_6.9 //
```

The colophon: *iti … vṛttaratnākaravyākhyāyāṃ **prastārādhyāyaḥ** ṣaṣṭhaḥ
samāptaḥ*.

**6.1 names the six.** प्रस्तारः, नष्टम्, उद्दिष्टम्, एकद्व्यादिलगक्रिया,
संख्यानम्, **अध्वयोगः** — *ṣaḍ ete pratyayāḥ smṛtāḥ*, "these six are handed
down as the pratyayas."

---

## 3. Where the witnesses differ

| verse | A (printed ed.) | B (Patan ms.) |
|---|---|---|
| 6.3 | `gurūneva` | `gurūṇyevaṃ` |
| 6.4 | `syādardhe 'rdhe gurubhavet` | `tadardhe 'rdhe gururbhavet` |
| 6.5 | `ye ca tatrāṅkāḥ` | `ye tu tatrāṃkāḥ` |
| 6.7 | `gurorekam … lagakriyā` | `gurorevam … lagukriyā` |
| 6.8 | `saikā vā` | `saiko vā` |
| **6.9** | `vṛttasyāṅgulikā vyāptir` (nom.) | `vṛttasyāṃgulikīṃ vyāptim` (acc.) |

The 6.9 variant is the one that matters and it is settled by the commentary,
which glosses with the accusative and a finite verb: *vṛttasya **āṃgulikīṃ
aṃgulapramāṇāṃ vyāptiṃ kuryāt*** — "one should make the vṛtta's extent, of the
measure of an aṅgula." Reading A's nominative says the same thing declaratively.
**Neither reading changes the arithmetic**, which both witnesses give identically
in the first half-verse.

---

## 4. अध्वयोगः — 6.9, word by word

> **संख्यैव द्विगुणैकोना सद्भिरध्वा प्रकीर्तितः ।**
> **वृत्तस्याङ्गुलिकीं व्याप्तिमधः कुर्यात्तथाङ्गुलम् ॥**

- *saṅkhyā eva* — the saṅkhyā itself
- *dvi-guṇā* — doubled
- *eka-ūnā* → *ekonā* — less one
- *sadbhiḥ* — by the learned
- *adhvā* — the road *(Sulhaṇa glosses: **adhvā mārgaḥ**)*
- *prakīrtitaḥ* — is declared
- *vṛttasya āṅgulikīṃ vyāptim* — the metre's extent, of a finger's measure
- *adhaḥ kuryāt tathā aṅgulam* — and below, likewise, an aṅgula

**adhvan = 2 · saṅkhyā − 1.** The unit is the **aṅgula**, a finger-breadth of
**vertical extent on the writing surface**: one aṅgula for each written row, one
aṅgula for the gap below it, and *ekonā* because the last row has no gap under
it.

Sulhaṇa works it for the four-syllable class:

> *caturakṣarajātau yā **ṣoḍaśasaṃkhyā** syād **dviguṇā dvātriṃśatiḥ** **ekonā
> ekarahitā ekatriṃśatiḥ** sadbhiḥ paṇḍitair adhvā mārgaḥ prakīrtitaḥ / katham /
> vṛttasya āṃgulikīṃ aṃgulapramāṇāṃ vyāptiṃ kuryāt*

saṅkhyā **16**, doubled **32**, less one **31**.

---

## 5. Three corrections to what this repository currently says

*(ii) and (iii) below are a correction to `CHANDAHSASTRA_THE_TEXT_ON_METRE.md`,
phrased so `scripts/check-correction-reach.sh` enforces that it is reachable from
the corrected file rather than only from this one.)*

**(i) The corpus names five pratyayas and calls them six.**
`formal/cubical/PingalaPrastara.agda:12` — *"the six procedures on the
laghu(light)–guru(heavy) patterns of a metre"* — then lists prastāra, naṣṭa,
uddiṣṭa, saṅkhyā, meru-prastāra. Five. The missing one is **adhvan**, and it is
the only pratyaya with no formal content anywhere in the repository: it appears
in **zero** `.agda` files, and in prose only twice.

**(ii) The one technical gloss of it is off in its unit.**
`notes/CHANDAHSASTRA_THE_TEXT_ON_METRE.md` §III:

> **adhvayoga** — the total space the prastāra occupies when written out: the
> number of **syllables of writing** needed for the whole table.

The number of syllables of writing for the whole table is n·2ⁿ — for n = 4, that
is 64. **KedV 6.9 says 31.** The verse does not count syllables; it measures
height in aṅgulas, rows plus the gaps below them. The note marked this
`[recalled]` and listed exactly this as what it needed the text to settle. It is
now settled for Kedāra's formulation. *It is not settled for Piṅgala's*, whose
sūtras remain absent, and the two are not assumed to agree.

The other gloss, in `kanye-devotional/READ_THIS_FIRST…txt` — *"adhvan — how much
writing space the full layout needs"* — is consistent with the verse. It gives no
number.

**(iii) The open question about saṅkhyā-by-squaring is not settled by this text,
and should not be recorded as if it were.** The same note asks whether Piṅgala
himself states the halving-and-squaring rule. **Kedāra does not use that rule at
all.** KedV 6.8 gives two other derivations:

> *lagakriyāṅkasandohe bhavet saṅkhyā vimiśrite / uddiṣṭāṅkasamāhāraḥ saikā vā
> janayed imām*

— sum the laga-kriyā row (Sulhaṇa: *ekaś catvāraḥ ṣaṭ catvāraḥ ekam … ṣoḍaśa*,
1+4+6+4+1 = 16); **or** sum the uddiṣṭa doubling column and add one (Sulhaṇa:
*dviguṇā ye aṅkā … teṣāṃ samāhāraḥ **pañcadaśa** saikaḥ **ṣoḍaśa***, 1+2+4+8 =
15, +1 = 16). Kedāra's saṅkhyā is Θ(n) additions, not Θ(log n) squarings. The
question stands open exactly where it stood.

---

## 6. The thing the commentary computes twice and does not connect

Within four sentences Sulhaṇa produces three numbers for the four-syllable class:

| | number | where |
|---|---|---|
| the uddiṣṭa doubling column, summed | **15** (*pañcadaśa*) | 6.8, as a step toward the saṅkhyā |
| the saṅkhyā | **16** (*ṣoḍaśa*) | 6.8 |
| the adhvan | **31** (*ekatriṃśat*) | 6.9 |

31 = 16 + 15. The commentary states each and never relates them.

**What the 15 and the 16 count.** 16 is the rows. 15 is the gaps — the adhvan is
rows plus gaps, and there is one gap below every row but the last. So the
doubling column that 6.8 sums for one purpose is, term by term, the census of
something else: **2ᵏ is the number of gaps whose carried remainder has length k.**

**Carried remainder** is Kedāra's own word. 6.2: *yathopari tathā **śeṣam***, "as
above, so the remainder." Sulhaṇa: *yady upari gurus tadā adhastād api gurur,
yady upari laghus tadā adhastād api laghuḥ śeṣam / **upari tulyo dīyate** ity
arthaḥ* — the next row flips the first guru to laghu, fills what precedes it with
guru (*ūne dadyād gurūṇi*, "the deficient region is filled with gurus"), and
copies the rest unchanged. The copied rest is the śeṣa. It is strictly shorter
than the row, because the flipped syllable is not in it.

So: **each gap in the written prastāra carries exactly one śeṣa, the śeṣas are
exactly the patterns of length < n, and there are 1+2+4+8 = 15 of them at n = 4.**
That is the identity behind 31 = 16 + 15, and it is a bijection, not an
arithmetic coincidence.

---

## 7. Checked

`formal/cubical/AdhvaSesa_TheGapsOfTheWrittenPrastaraAreItsNonFinalRowsSoTheEkonaIsForced.agda`

- **शेष-तुल्यता** `वाक् n ≃ (Unit ⊎ शेषः n)` — every row of the prastāra is
  either the last one (सर्व-लघु; Kedāra's stopping condition *yāvat sarvalaghur
  bhavet*) or is **recovered from the śeṣa it carries**. The śeṣa determines the
  row.
- **अध्व-एकोना** `(अध्वा n ⊎ Unit) ≃ (वाक् n ⊎ वाक् n)` — verse 6.9 with no
  subtraction in it: the extent, together with the one gap that is not there, is
  twice the saṅkhyā. A gap maps to the row it sits below; the adjoined `Unit`
  maps to the सर्व-लघु row, which has none. *Ekonā* names a specific missing
  object.
- **एकोना-आवश्यका** `¬ (शेषः 1 ≃ वाक् 1)` — the control. If gaps and rows were
  equinumerous, 6.9 would read *dviguṇā* with no *ekonā*. Two one-syllable rows,
  one gap between them; the assumed equivalence yields लघु ≡ गुरु and dies.
- `संख्या 4 ≡ 16`, `शेष-गणना 4 ≡ 15`, `अध्व-गणना 4 ≡ 31`, each by `refl` —
  Sulhaṇa's three numbers, decided by evaluation.

Agda 2.6.3, `--cubical --safe --no-import-sorts`, cubical library at
`/root/agda-libs/cubical`, `git describe` = **v0.5** (the version is not in
`cubical.agda-lib`). **Exit 0, no warnings.** No postulates, no holes, no
`sorry`-equivalent. Imports only `Cubical.*`, no module of this corpus, so it
depends on nothing local typechecking.

**Nothing builds it.** It is not imported by `Everything.agda`. Run in
`formal/cubical`, `sh check-everything-coverage.sh` **FAILS** — 60 orphans, and
the 572 files under `NaturalMachine/` are enumerated by no latch at all. My
module is one more orphan and I am not claiming otherwise. The evidence for it is
that `agda` was run on it directly and exited 0.

**A note on why it is written the way it is.** `वाक्` and `शेषः` are defined by
recursion on ℕ, not as inductive families. The first draft used an indexed family
and Agda warned twice: *"relies on injectivity of the data constructor suc, which
is not yet supported … will not compute when applied to transports."* That is a
real defect, not noise — it still typechecks. `PingalaPrastara` avoids it with a
Σ-type and a length proof; recursion on ℕ avoids it too and keeps everything
definitional.

---

## 8. How this could be true and irrelevant

The arithmetic is 1+2+4+8+16 = 2·16 − 1, a geometric series. If the content were
the number, this note is worth nothing: any reader of 6.9 can compute 31, and
Sulhaṇa did.

The claim to relevance is narrower and it is entirely about **which objects the
numbers count** — that the 15 of 6.8 and the 31 of 6.9 are the same objects
counted twice, and that the object is the *śeṣa*, which is named in 6.2 and
enters no count in either verse. If a reader holds that "adhvan = 2·saṅkhyā − 1"
and "gaps are the non-final rows" are the same trivial statement, then this
module has added a name, a check, and nothing else, and that reader should say
so.

**A second way to be irrelevant:** all of it is Kedāra, and this repository's
frame is Piṅgala. If the six-fold system is Kedāra's systematisation rather than
Piṅgala's, then a result about the adhvan is a result about the 11th–12th century
and not about 300 BCE. **I think that is probably the right description and I
have stated it that way throughout.** Correcting it requires the Chandaḥśāstra,
which is not here.

---

## 9. How I got each claim

| claim | how |
|---|---|
| the nine verses, both witnesses | **read**, from GRETIL files now in the container |
| Sulhaṇa's 16 / 15 / 31 | **read**, verbatim in the commentary |
| adhvan = 2·saṅkhyā − 1, in aṅgulas of vertical extent | **read**, 6.9 + commentary gloss |
| the naṣṭa and uddiṣṭa worked examples agree on GGLG = row 5 | **read**, and checked against the rule by hand |
| Kedāra does not use squaring for saṅkhyā | **read** — absence in a text I now have, so a real negative |
| GRETIL lacks Chandaḥśāstra / Mṛtasañjīvanī / Vṛttajātisamuccaya | **checked against the catalogue**, predicate validated in both directions |
| corpus names five pratyayas, says six | **checked**, `PingalaPrastara.agda:12` |
| adhvan in 0 `.agda` files | **checked**, `grep -ril adhvan` over the repository |
| 31 = 16 + 15 as a bijection between gaps and śeṣas | **proved**, and checked in Agda |
| Kedāra's dates | **GRETIL header**, not adjudicated |
| anything about Piṅgala's own sūtras | **not established. Not asserted.** |

---

## 10. A fact worth keeping that has no bearing on any of the above

The commentator demonstrates naṣṭa and uddiṣṭa on **the same pattern, in
consecutive verses, in opposite directions**, and does not remark on it.

On 6.4 he loses row 5 of the four-syllable class and rebuilds it: 5 is odd, add
one → 6, halve → 3, **guru**; 3 odd, add one → 4, halve → 2, **guru**; 2 even,
halve → 1, **laghu**; 1 odd, add one → 2, halve → 1, **guru**. He then says the
answer in words — *ādyau dvau gurū, tābhyāṃ parako laghus tato guruḥ*, "the first
two guru, after them a laghu, then a guru."

On 6.5 he takes that same pattern — *tasya dvau varṇau gurū tato laghus tato 'pi
guruḥ* — writes the doubling numbers 1, 2, 4, 8 above it, finds 4 standing at the
laghu, adds one, and gets 5.

Down and back up, on one instance, with the round trip left for the reader to
notice. `IndianLane.agda` records that this repository proves naṣṭa and uddiṣṭa
mutually inverse, "each implemented independently rather than one transported
along the other." That is the same demonstration, and the commentator's version
is four sentences long.
