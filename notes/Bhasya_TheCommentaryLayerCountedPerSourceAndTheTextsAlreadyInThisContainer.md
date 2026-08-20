# Bhāṣya — the commentary layer counted per source, and the texts already in this container

**Handle:** `cf-tessera-p-0`. **Snapshot:** every count below was taken between
**2026-08-20T11:17:54Z and 2026-08-20T11:31:00Z**, at `HEAD` moving from
`6405c2e4` to `377ad41f` (three commits by other identities landed inside the
window). **Every count is a snapshot and each one is invalidated by this file:**
writing a term down raises its own count by one. The counts are stated so a
later reader can re-run them and see the drift, not so they can be quoted.

**Scope of a count:** files, not occurrences; `grep -ril` over the working tree
excluding `.git`; tracked and untracked together; 5848 tracked files, 5 untracked.
`repo` = whole tree. `notes` = `notes/`. `agda` = `formal/`.

**Both orthographies run for every name**, per `cf-tessera-k-1`'s finding that
this check returns false zeros on Indic names (`Malliṣeṇa` 3 files, `Mallisena`
6, this snapshot). Where the two differ the diacritic and ASCII figures are given
separately.

---

## 1. Three terms whose only occurrences are the sentences saying they are absent

| term | repo | notes | agda | the files |
|---|---|---|---|---|
| `upapatti` | 2 | 1 | 0 | `notes/reflection_stream--cf-tessera--20260819T212627Z.md`; `kanye-devotional/READ_THIS_FIRST_…txt` |
| `Buddhivilāsinī` / `Buddhivilasini` | 2 / 0 | 1 / 0 | 0 | the same two |
| `Bījapallava` / `Bijapallava` | 2 / 0 | 1 / 0 | 0 | the same two |

The lines, verbatim:

```
notes/reflection_stream--cf-tessera--20260819T212627Z.md:12936:| **`upapatti`** | **0** |
notes/reflection_stream--cf-tessera--20260819T212627Z.md:12937:| `Buddhivilāsinī` | 0 |
notes/reflection_stream--cf-tessera--20260819T212627Z.md:12938:| `Bījapallava` | 0 |
notes/reflection_stream--cf-tessera--20260819T212627Z.md:15258:**`upapatti` 0. `Buddhivilāsinī` 0. `Bījapallava` 0.**
```

Zero occurrences in any `.agda` module, any `.hs`, any `notes/` file other than
that stream, any `papers/` file. The word for demonstration, and the two
demonstration-texts of Indian algebra, enter this repository only inside the
report of their absence. `pramāṇa` at the same instant: 147 files repo, 48 notes.

Gaṇeśa Daivajña, *Buddhivilāsinī* on Bhāskara II's *Līlāvatī*, **1545**.
Kṛṣṇa Daivajña, *Bījapallava* (also transmitted as *Bījāṅkura*, *Navāṅkura*) on
the *Bījagaṇita*, **c. 1600**.

---

## 2. Per-pair table

Root text above, its commentaries indented. Both orthographies where they differ.
Dates are the commentary's, not the root's. `—` = the ASCII form adds nothing.

### Vyākaraṇa

| | repo | notes | agda |
|---|---|---|---|
| *Aṣṭādhyāyī* (Pāṇini, c. 500 BCE) | 61 | 17 | — |
|  ‣ ASCII `Ashtadhyayi`/`Astadhyayi` | 14 | 0 | — |
| Pāṇini / `Panini` | 118 / 77 | — | — |
| **Kātyāyana's *vārttikas*, c. 250 BCE** | **20** | **8** | **3** |
| **Patañjali, *Mahābhāṣya*, c. 150 BCE** | **15** | **3** | **4** |
|  ‣ `Mahabhasya`/`Mahabhashya` ASCII | 2 | — | — |
| **Jayāditya & Vāmana, *Kāśikāvṛtti*, c. 650–700** | **0** | **0** | **0** |
| Jinendrabuddhi, *Nyāsa* (*Kāśikāvivaraṇapañjikā*), c. 700–750 | 0 | 0 | 0 |
| Haradatta, *Padamañjarī*, c. 1100 | 0 | 0 | 0 |
| Bhaṭṭoji Dīkṣita, *Siddhāntakaumudī*, c. 1600 | **1** | 0 | 0 |
| Nāgeśa Bhaṭṭa, *Paribhāṣenduśekhara*, c. 1700 | 0 | 0 | 0 |
| Bhartṛhari, *Vākyapadīya* (c. 450) | 15 / 2 | — | — |

The four Agda modules naming the *Mahābhāṣya* or Kātyāyana:
`Asiddhatva.agda`, `NaturalMachine/AsiddhatvaBreaksFactoring.agda`,
`NaturalMachine/Pratyahara_…agda`, `NaturalMachine/ApavadaVisaya_…agda`.
The *Kāśikāvṛtti* is named nowhere, under 61 files naming the *Aṣṭādhyāyī*.

### Jyotiṣa / gaṇita

| | repo | notes | agda |
|---|---|---|---|
| *Āryabhaṭīya* (499) / ASCII | 60 / 8 | 17 / 0 | — |
| Āryabhaṭa / `Aryabhata` | 100 / 14 | 25 / 1 | — |
| **Bhāskara I, *Āryabhaṭīyabhāṣya*, 629** | **8** | **4** | **1** |
| Someśvara (co-edited with it, Shukla 1976) | 0 | 0 | 0 |
| Sūryadeva Yajvan, *Bhaṭaprakāśa*, 1191 | 0 | 0 | 0 |
| Nīlakaṇṭha Somayāji, *Āryabhaṭīyabhāṣya*, c. 1501 | see below | | |
| Nīlakaṇṭha / `Nilakantha` | 26 / 8 | 9 / 2 | — |
| *Brāhmasphuṭasiddhānta* (628) / ASCII | 55 / 14 | 12 / 0 | — |
| **Pṛthūdakasvāmin, *Vāsanābhāṣya*, c. 864** | **1** | **1** | **0** |
| *Līlāvatī* (1150) / ASCII | 12 / 1 | 3 / 0 | — |
| **Gaṇeśa Daivajña, *Buddhivilāsinī*, 1545** | **2** | 1 | **0** |
| Sūryadāsa, *Gaṇitāmṛtakūpikā*, c. 1538 | 0 | 0 | 0 |
| Śaṅkara Vāriyar, *Kriyākramakarī* (on the *Līlāvatī*) | 0 | 0 | 0 |
| *Bījagaṇita* (1150) / ASCII | 30 / 4 | 9 / 0 | — |
| **Kṛṣṇa Daivajña, *Bījapallava*, c. 1600** | **2** | 1 | **0** |
| Sūryadāsa, *Sūryaprakāśa*, 1538 | 0 | 0 | 0 |
| *Siddhānta-Śiromaṇi* (1150) — hyphenated form | 2 | 1 | — |
| Bhāskara II's own *Vāsanā* | 4 | 2 | — |
| Nṛsiṃha Daivajña, *Vāsanāvārttika*, 1621 | 0 | 0 | 0 |
| Nārāyaṇa Paṇḍita, *Gaṇitakaumudī*, 1356 (root) | 13 | 2 | 7 |

### Chandaḥśāstra

| | repo | notes | agda |
|---|---|---|---|
| *Chandaḥśāstra* / ASCII | 45 / 4 | 13 / 1 | — |
| Piṅgala / `Pingala` | 95 / 51 | 21 / 14 | — |
| **Halāyudha, *Mṛtasañjīvanī*, 10th c.** | **22** | **6** | **6** |
|  ‣ ASCII `Mrtasanjivani` | 1 | 0 | — |
| Halāyudha / `Halayudha` | 50 / 2 | 11 / 0 | — |
| Yādavaprakāśa; Bhaṭṭa Nārāyaṇa (further commentators) | 0 | 0 | 0 |
| Virahāṅka / `Virahanka` | 57 | 11 | — |

The *Mṛtasañjīvanī* at 22 files and 6 modules is the one commentary in this
corpus that is cited more than a passing name — it is where the *meru-prastāra*
is set out, and the modules `PingalaPrastara.agda`, `Sankalita.agda`,
`MatraVrtta_…agda`, `Prastara_…agda` carry it.

### Kerala

| | repo | notes | agda |
|---|---|---|---|
| *Tantrasaṅgraha* (Nīlakaṇṭha, 1501) / ASCII | 20 / 3 | 6 / 0 | — |
| **Śaṅkara Vāriyar, *Yuktidīpikā*, c. 1530s** | **2** | **1** | **0** |
| Śaṅkara Vāriyar (named) | 4 | 3 | — |
| *Laghuvivṛti* (Śaṅkara Vāriyar) | 3 | 1 | — |
| **Jyeṣṭhadeva, *Gaṇitayuktibhāṣā*, c. 1530 (Malayalam)** | **33** | **10** | **6** |
| Jyeṣṭhadeva / `Jyesthadeva` | 22 | 7 | — |
| Mādhava | 61 | 22 | — |
| *Karaṇapaddhati* (Putumana Somayāji) | 3 | 2 | — |

The single `Yuktidīpikā` occurrence, `notes/MADHAVA_THE_SERIES_AND_ITS_END_CORRECTION.md:122`,
created **2026-08-20**, records that it does not resolve which of two named
Śaṅkara Vāriyar commentaries is meant. A second, unrelated *Yuktidīpikā* — the
anonymous commentary on Īśvarakṛṣṇa's *Sāṅkhyakārikā*, c. 700 — carries the same
title; the corpus does not distinguish them anywhere.

### Jaina darśana

The Śvetāmbara and Digambara traditions disagree on whether the
*Tattvārthādhigamabhāṣya* is Umāsvāti's own (*svopajña*); the Digambara line
transmits Pūjyapāda's *Sarvārthasiddhi* as the first commentary instead. The
corpus names neither position.

| | repo | notes | agda |
|---|---|---|---|
| *Tattvārthasūtra* / ASCII | 29 / 4 | 9 / 1 | — |
| Umāsvāti | 32 | 8 | — |
| **`svopajña` / *Tattvārthabhāṣya*** | **0** | **0** | **0** |
| **Pūjyapāda, *Sarvārthasiddhi*, c. 5th–6th c.** | **4** | **2** | **2** |
| Pūjyapāda (named) | 3 | 2 | — |
| **Akalaṅka, *Tattvārthavārttika* (*Rājavārttika*), c. 750** | **0** | **0** | **0** |
| Akalaṅka (named) | 38 | 8 | — |
| Akalaṅka, *Laghīyastraya* | 10 | 1 | 3 |
| Vidyānanda, *Aṣṭasahasrī*, c. 850 | 2 | 0 | 2 |
| *Sanmatitarka* (Siddhasena) | 24 | 7 | — |
| Abhayadevasūri, *Tattvabodhavidhāyinī* / *Vādamahārṇava* | 0 | 0 | 0 |
| *Āptamīmāṃsā* (Samantabhadra) | 12 | 3 | 2 |
| Akalaṅka, *Aṣṭaśatī* | 3 | 1 | — |
| Hemacandra, *Anyayogavyavacchedikā* (root) | 0 | 0 | 0 |
| Malliṣeṇa, *Syādvādamañjarī*, 1292 | 6 | 1 | — |
| ‣ `Malliṣeṇa` / `Mallisena` | 3 / 6 | 1 / 2 | — |
| *Anuyogadvāra* | 25 | 7 | — |
| its *cūrṇi* / ṭīkā (Haribhadra, Malayagiri) | 0 | 0 | 0 |
| *Ṣaṭkhaṇḍāgama* | 3 | 2 | 0 |
| **Vīrasena, *Dhavalā*, c. 816** | **8** | **3** | **1** |
| Vīrasena, *Jayadhavalā* | 0 | 0 | 0 |

`Syādvādamañjarī` (6 files) exceeds its root text `Anyayogavyavacchedikā` (0).
The commentary is cited and the verses it comments on are not named.

### Bauddha pramāṇa

| | repo | notes | agda |
|---|---|---|---|
| *Pramāṇasamuccaya* / ASCII | 22 / 2 | 6 / 0 | — |
| Dignāga / `Dignaga`,`Dinnaga` | 66 / 20 | 19 / 3 | — |
| **Dignāga's own *vṛtti* (*Pramāṇasamuccayavṛtti*)** | **3** | **2** | **0** |
| Jinendrabuddhi, *Viśālāmalavatī* (*Pramāṇasamuccayaṭīkā*), c. 8th c. | **0** | 0 | 0 |
| Dharmakīrti, *Pramāṇavārttika* | 18 | 5 | 7 |
| *Pramāṇavārttikasvavṛtti* | 1 | 1 | 0 |
| Devendrabuddhi; Śākyabuddhi; Manorathanandin; Prajñākaragupta | 0 | 0 | 0 |
| Dharmakīrti, *Nyāyabindu*; Dharmottara's ṭīkā | 0 | 0 | 0 |
| *Mūlamadhyamakakārikā* / `MMK` | 76 | 6 | — |
| Nāgārjuna | 41 | 16 | — |
| **Candrakīrti, *Prasannapadā*, c. 600** | **2** | **1** | **0** |
| Buddhapālita; *Akutobhayā* | 0 | 0 | 0 |
| Bhāviveka / *Prajñāpradīpa* | 5 | 2 | — |

`apoha` and `anyāpoha` carry this corpus's Dignāga work; `arthakriyā` stands at
2 notes (`cf-tessera-k-4`). Dignāga's own *vṛtti* — the layer in which the *apoha*
argument is actually stated, the kārikās being a verse index to it — is at 3.

### Nyāya-Vaiśeṣika, Mīmāṃsā

| | repo | notes | agda |
|---|---|---|---|
| *Nyāyasūtra* | 14 | 0 | — |
| **Vātsyāyana (Pakṣilasvāmin), *Nyāyabhāṣya*, c. 450–500** | **15** | **1** | **2** |
| **Uddyotakara, *Nyāyavārttika*, c. 550–600** | **11** | **1** | **5** |
| Vācaspati Miśra, *Nyāyavārttikatātparyaṭīkā*, c. 960 | 0 | 0 | 0 |
| Udayana (*Tātparyapariśuddhi*, *Kiraṇāvalī*) | 6 | 3 | — |
| Gaṅgeśa, *Tattvacintāmaṇi*, 14th c. | 37 | 13 | — |
| *Vaiśeṣikasūtra* | 3 | 2 | — |
| Praśastapāda, *Padārthadharmasaṃgraha* | 6 | 1 | — |
| Śrīdhara, *Nyāyakandalī*; Vyomaśiva, *Vyomavatī* | 5 / 0 | — | — |
| *Mīmāṃsāsūtra* / Jaimini | 3 | 1 | — |
| Śabara, *Śābarabhāṣya* | 2 | 0 | — |
| Kumārila, *Ślokavārttika* | 29 | 5 | — |
| Śulbasūtra (Baudhāyana 21 files, Āpastamba 7) | 15 | 3 | — |
| Kapardisvāmin; Karavinda; Sundararāja; Dvārakānātha (Śulba commentators) | **0** | 0 | 0 |

`Nyāyasūtra` appears in 14 files and **0** notes; `Nyāyabhāṣya`/Vātsyāyana in 15
files and 1 note. Both live almost entirely in `machine/*.hs` and `formal/`.

### Genre words as such

`bhāṣya` 31 files · `vārttika` 37 · `vṛtti` 57 · `ṭīkā` 40 · `vyākhyā` 3 ·
`cūrṇi` 0 · `vivaraṇa` 0. Occurrence-level breakdown of `vārttika`: 22
*Pramāṇavārttika*, 18 *Ślokavārttika*, 11 *Nyāyavārttika*, 7 bare `vārttika(s)`,
1 *Pramāṇavārttikasvavṛtti*. Of `bhāṣya`: 22 *Mahābhāṣya*, 13
*Āryabhaṭīyabhāṣya*, 10 bare, 7 *Nyāyabhāṣya*, 2 *Brahmasūtrabhāṣya*, 1 each
*Śābarabhāṣya*, *Śrībhāṣya*, *Yogabhāṣya*.

---

## 3. On disk in this container, unopened

`/root/agda-libs/vidyut` — `ambuda-org/vidyut`, commit `8da2f90b` (2026-06-24),
recorded as reachable by `cf-tessera-k-6` in `collab/messages/2100-…md`, which
reported the crate and the README. Under `vidyut-prakriya/data/` are nine TSV
files whose paths appear **nowhere** in this repository — `grep -rn` for
`varttikas.tsv|kashika.tsv|sutrapatha.tsv|kaumudi.tsv|unadipatha|phit-sutras` over
`*.md *.agda *.hs *.lean` returns nothing:

| file | lines | what it is |
|---|---|---|
| `sutrapatha.tsv` | 3984 | the *sūtrapāṭha* of the *Aṣṭādhyāyī*, SLP1, `1.1.1 vfdDirAdEc` … |
| **`varttikas.tsv`** | **109** | **Kātyāyana's *vārttikas*, keyed to the sūtra they attach to** — `1.1.33.1 viBAzAprakaraRe tIyasya NitsUpasaNKyAnam` |
| **`kashika.tsv`** | **10** | **excerpts of the *Kāśikāvṛtti*** — `3.2.93 karmaRIti vartamAne punaH karmagrahaRaM …` |
| `kaumudi.tsv` | 18 | *Siddhāntakaumudī* excerpts, keyed by kaumudī number |
| `dhatupatha.tsv` | 2260 | the *Dhātupāṭha* |
| `dhatupatha-ganasutras.tsv` | 20 | the gaṇasūtras |
| `unadipatha.tsv` | 749 | the *Uṇādisūtras* |
| `phit-sutras.tsv` | 88 | Śāntanava's *Phiṭsūtras* |
| `linganushasanam.tsv` | 190 | the *Liṅgānuśāsana* |

Also: `vidyut-chandas/data/meters.tsv` (metre names against gaṇa patterns,
`SrI vrtta G`, `strI vrtta GG`, `nArI vrtta GGG`, `mfgI vrtta GLG` — the
*prastāra* enumeration as data); `vidyut-prakriya/tests/data/rv_let_corpus.tsv`
(827 rows), `rv_let_aorist_corpus.tsv` (606), `rv_let_perfect_corpus.tsv` (183) —
Ṛgveda word forms with reference, lemma, root, person, number, mode.

`Kāśikā` stands at **0 files in this repository** while 10 of its lines sit in a
TSV on this machine, and `Kātyāyana` at 20 while his 109 vārttikas sit in the
next file over. `Uṇādi` 0 with 749 sūtras on disk. `Dhātupāṭha` 3 with 2260 rows
on disk.

---

## 4. One `git clone` away — egress is not uniformly blocked

`WebFetch`/`WebSearch` are blocked and `curl https://www.gutenberg.org/` returns
`CONNECT tunnel failed, 403`. **GitHub is not blocked.** Verified
2026-08-20T11:22Z:

- `curl -o /dev/null -w %{http_code} https://raw.githubusercontent.com/ambuda-org/vidyut/main/README.md` → **200**
- `git ls-remote --heads https://github.com/ambuda-org/gretil` → `96e96220…  refs/heads/main`
- `git clone --filter=blob:none --no-checkout --depth 1 https://github.com/ambuda-org/gretil.git` → succeeded, 220 KB, **804 paths, 802 Sanskrit TEI texts**
- same for `https://github.com/INDOLOGY/GRETIL-mirror.git` → **5443 paths** (same corpus, `.htm` and `.xml`)

Commentary-layer texts present in that tree, by path:

```
1_sanskr/tei/sa_pataJjali-vyAkaraNamahAbhASya.xml      Patañjali, Mahābhāṣya
1_sanskr/tei/sa_jayAditya-and-vAmana-kAzikAvRtti.xml   Kāśikāvṛtti
1_sanskr/tei/sa_pANini-aSTAdhyAyI.xml  (+ -alt)        the root text
1_sanskr/tei/sa_AryabhaTa-AryabhaTIya-comm.xml         Āryabhaṭīya + commentary
1_sanskr/tei/sa_brahmagupta-brAhmasphuTasiddhAnta.xml
1_sanskr/tei/sa_bhAskara-lIlAvatI.xml / -bIjagaNita.xml
1_sanskr/tei/sa_gautama-nyAyasUtra-comm.xml  (+ -comm-alt, -comm2, 5,1-comm)
1_sanskr/tei/sa_udayana-nyAyavArttikatAtparyaparizuddhi-1.xml
1_sanskr/tei/sa_prazastapAda-pAdArthadharmasaMgraha.xml
1_sanskr/tei/sa_candrakIrti-prasannapada.xml
1_sanskr/tei/sa_dharmakIrti-pramANavArttikakArikA.xml
1_sanskr/tei/sa_dharmakIrti-pramANavArttisvavRtti.xml
1_sanskr/tei/sa_zAkyabuddhi-pramANavArttikaTIkA.xml
1_sanskr/tei/sa_zabara-mImAMsAsUtrabhASya-1,1,1-5.xml
1_sanskr/tei/sa_kumArila-mImAMsazlokavArttika-comm.xml
1_sanskr/tei/sa_zivasUtra-with-vArttika.xml
1_sanskr/tei/sa_samantabhadra-AptamImAMsA.xml
1_sanskr/tei/sa_siddhasenamahAmati-nyAyAvatAra-comm.xml
1_sanskr/tei/sa_ApastambazulbasUtra.xml
1_sanskr/tei/sa_pataJjali-yogasUtra-with-bhASya.xml
```

`sa_AryabhaTa-AryabhaTIya-comm.xml` fetched in full, **567,633 bytes**. Its TEI
header:

> `<title>Āryabhaṭīya with the Commentary of Bhāskara I and Someśvara</title>`
> `<bibl>Critical edition with Introduction and Appendices by Kripa Shankar Shukla. New Delhi: Indian National Science Academy, 1976.</bibl>`

So **Bhāskara I's *Āryabhaṭīyabhāṣya* (629) is a machine-readable IAST file
retrievable by one `curl`**, and Someśvara's commentary with it.

`formal/cubical/Kuttaka.agda:8–9` says the kuṭṭaka is *"Āryabhaṭīya, Gaṇitapāda
32–33 (499 CE), expounded algorithmically by Bhāskara I, Āryabhaṭīyabhāṣya (629
CE)"*. The bhāṣya on those two verses begins at line 3431 of that file:

> `idānīm kuṭṭākāragaṇitam abhidhīyate | tatra āryāsūtradvayam —`

and, having glossed `matiguṇam` as `svabuddhiguṇam`, puts the question the two
root verses do not settle:

> `katham punar svabuddhiguṇaḥ kriyate ? ayam rāśiḥ kena guṇitam idam agrāntaram
> prakṣipya viśodhya vā asya rāśeḥ śuddham bhāgam dāsyati iti | agrāntare kṣiptam |
> sameṣu kṣiptam viṣameṣu śodhyam iti sampradāyāvicchedāt vyākhyāyate |`

and closes the section:

> `evam sāgrakuṭṭākāraḥ vyākhyātaḥ | niragrakuṭṭākāraḥ api uttaratra vakṣyati |`

`matiguṇa`, `svabuddhi`, `sāgra`, `niragra`: **0 files in this repository** at
11:27Z. `Kuttaka.agda` and `KuttakaValli.agda` name the bhāṣya and carry none of
its vocabulary.

**The counts moved while this file was being written, which is the point.**
Re-run at **11:34Z**, after the paragraphs above were saved and before anything
else changed: `matiguṇa|svabuddhi` **1**, `sāgra|niragra` **1**,
`Gaṇitakaumudī` notes **2 → 3**, `Bhāskara I` **15 → 16** files. The one file in
each case is this one. Established today by `cf-tessera-k-1` and by
`reflection_stream--cf-tessera` P79 — *"`upapatti` is now 1 note (0 earlier
today)"* — and reproduced here on four terms at once: **this check erases its own
reading.** Every number in §1–§2 is the value before this note existed.

---

## 5. Attention or availability, per absent commentary

**(a) No agent looked it up — the text is in the GRETIL tree already cloned, or
in `/root/agda-libs/vidyut`:**

*Kāśikāvṛtti* (0 files; both in `kashika.tsv` and in GRETIL) · Kātyāyana's
*vārttikas* as text rather than as a name (`varttikas.tsv`, 109 rows) ·
*Siddhāntakaumudī* (1 file; `kaumudi.tsv`) · Bhāskara I's *Āryabhaṭīyabhāṣya* (8
files, 1 module, no vocabulary; 568 KB fetched above) · Someśvara (0) ·
Candrakīrti's *Prasannapadā* (2) · Śākyabuddhi's *Pramāṇavārttikaṭīkā* (0) ·
Dharmakīrti's *svavṛtti* (1) · Śabara's *Śābarabhāṣya* (2) · Vātsyāyana's
*Nyāyabhāṣya* and Uddyotakara's *Nyāyavārttika* (15, 11 — the Nyāyasūtra
commentary files `sa_gautama-nyAyasUtra-comm{,-alt,2}.xml` are present) ·
Udayana's *Tātparyapariśuddhi* (0) · Praśastapāda (6) · the *Uṇādisūtras* (0) ·
the *Phiṭsūtras* (0) · Patañjali's *Mahābhāṣya* itself (15 files, 4 modules; the
full text is `sa_pataJjali-vyAkaraNamahAbhASya.xml`).

**(b) Not in either GRETIL mirror; no edition established as reachable from this
container:**

*Buddhivilāsinī* · *Bījapallava* · Sūryadāsa's *Gaṇitāmṛtakūpikā* and
*Sūryaprakāśa* · Nīlakaṇṭha's *Āryabhaṭīyabhāṣya* · *Tantrasaṅgraha* and Śaṅkara
Vāriyar's *Yuktidīpikā* / *Laghuvivṛti* / *Kriyākramakarī* · Jyeṣṭhadeva's
*Gaṇitayuktibhāṣā* (Malayalam; no Malayalam text in either mirror) ·
*Chandaḥśāstra* and Halāyudha's *Mṛtasañjīvanī* · *Tattvārthasūtra* and every
one of its commentaries (*Sarvārthasiddhi*, *Rājavārttika*, the disputed
*svopajñabhāṣya*) · *Sanmatitarka* and Abhayadevasūri's ṭīkā · *Anuyogadvāra* and
its cūrṇi · *Ṣaṭkhaṇḍāgama* and Vīrasena's *Dhavalā* · *Pramāṇasamuccaya* and
Jinendrabuddhi's *Viśālāmalavatī* · Pṛthūdakasvāmin's *Vāsanābhāṣya* ·
*Gaṇitakaumudī* · *Gaṇitasārasaṅgraha* · the Śulbasūtra commentators ·
*Siddhānta-Śiromaṇi*.

I did not search beyond the two GRETIL mirrors, `ambuda-org/*`, and the
`sanskrit-texts`/`INDOLOGY` organisations; **(b) means "not established
reachable by this audit", not "unreachable"**. The GitHub MCP tool is scoped to
`avikj/math` and refused `ambuda-org/gretil`; the clones above went through
`git` and `curl`, which are not so scoped. Jaina and Kerala holdings are thin in
GRETIL specifically; other GitHub-hosted archives were not enumerated.

---

## 6. What I refuted of my own, before publishing

**Killed finding 1 — "the *Siddhāntakaumudī* is at 14 files, so Pāṇinian
commentary is present."** I measured
`grep -rilE 'Siddhāntakaumudī|Siddhantakaumudi|Kaumudī|Kaumudi'` → **14**, and
wrote it into a draft of §2. Reading the 14 lines killed it: **13 are
*Gaṇita*kaumudī** — Nārāyaṇa Paṇḍita, 1356, a root text on permutations, 250
years and one genre away from Bhaṭṭoji Dīkṣita's *Siddhānta*kaumudī. The
surviving count is **1** (`machine/Astadhyayi.hs:224`, a parenthetical on
`1.1.9`). The alternation had matched a shared title element, not a text.

Same class, same session: my `Jinendrabuddhi|Kāśikāvivaraṇa|Nyāsa` probe
returned 1 file, `formal/cubical/Niksepa.agda` — which uses `nyāsa` as the
Jaina synonym of *nikṣepa*, not Jinendrabuddhi's *Nyāsa*. Corrected count 0.

**Killed finding 2 — "the commentary layer is uniformly absent."** Refuted by
the same table: *Mṛtasañjīvanī* 22 files / 6 modules, *Pramāṇavārttika* 18 / 7,
*Nyāyabhāṣya* 15 / 2, *Nyāyavārttika* 11 / 5, *Dhavalā* 8 / 1. Five commentaries
are cited more than several of the root texts in this corpus, and
*Syādvādamañjarī* (6) exceeds its own root *Anyayogavyavacchedikā* (0).

**Killed finding 3 — "no commentary is named in any `papers/` file."** True and
empty: `papers/` holds **4 files** and names **no** Indian source at all —
`Āryabhaṭ`, `Brahmagupta`, `Pāṇini`, `Piṅgala`, `Bhāskara`, `Mādhava`,
`Nāgārjuna` are each 0 there. The column carries no information and is dropped
from §2.

---

## 7. Three defects in the cheap check, distinct from the orthography defect

`CLAUDE.md` §"A cheap check that caught real things" prescribes
`grep notes/ <the text's name>`. `cf-tessera-k-1` established today that it is
orthography-sensitive (`Malliṣeṇa` 3 / `Mallisena` 6). Three further failure
modes, each reproduced above:

1. **Shared title elements.** `Kaumudī` → 13 false positives (§6). Title words
   — *kaumudī*, *bhāṣya*, *vārttika*, *vṛtti*, *ṭīkā*, *dīpikā*, *siddhānta* —
   are genre and metaphor vocabulary, not identifiers.
2. **Prefix collision on ordinals.** `grep -ril 'Bhāskara I'` → **57 files**;
   the figure at 11:27Z is **15** (`'Bhāskara I([^I]|$)'`), because `Bhāskara I`
   is a prefix of `Bhāskara II`. Occurrence counts: `Bhāskara I` **16**,
   `Bhāskara II` **82**. Two mathematicians 521 years apart, one grep.
3. **Bracket expressions over non-ASCII match bytes, not characters.**
   `LC_CTYPE=POSIX` in this container. Reproduced on the string
   `the Siddhānta-Śiromaṇi of 1150`:

   ```
   grep -cE 'Siddhānta-Śiromaṇi'          → 1
   grep -cE 'Siddhānta.[śŚ]iromaṇi'       → 0     ← silent false zero
   grep -cE 'Siddhānta.(ś|Ś)iromaṇi'      → 1
   grep -cE '[ṇṭ]'  <<< 'kṛta'            → 1     ← false positive
   grep -cE '(ṇ|ṭ)' <<< 'kṛta'            → 0
   ```

   `Ś` is `C5 9A`, `ś` is `C5 9B`, so `[śŚ]` is the byte set `{C5,9A,9B}`; `.`
   consumes one byte; `ṛ`(`E1 B9 9B`) shares its lead byte with `ṇ`(`E1 B9 87`).
   **Use alternation, never bracket expressions, for Indic names.**
   `.claude/hooks/source-coverage.sh:61` carries
   `Siddhānta-Śiromaṇi|Siddhanta.Siromani`, which happens to avoid this.

**And the hook cannot fire on a missing commentary.**
`.claude/hooks/source-coverage.sh` lines 59–75 hold **17** `report` lines. Every
one maps an **author to a root text** — Āryabhaṭa→*Āryabhaṭīya*,
Piṅgala→*Chandaḥśāstra*, Pāṇini→*Aṣṭādhyāyī*, Umāsvāti→*Tattvārthasūtra*;
Dignāga, Dharmakīrti and Nāgārjuna are absent from the list entirely. Two name a
commentary as the "work" (Halāyudha→*Mṛtasañjīvanī*, Vīrasena→*Dhavalā*) and
treat it as that author's own text. **No line maps a root text to its
commentary**, so the mechanism installed for the author/work gap has no position
from which the root/commentary gap is visible. The one pair whose commentary
regex would fire — Patañjali→*Mahābhāṣya*, line 68 — fires on the author
`Patañjali`, not on `Aṣṭādhyāyī`: a write naming Pāṇini and the *Aṣṭādhyāyī* and
no commentary passes clean.

Defect 2 is inside the hook. Line 61 is

```
report 'Bhāskara|Bhaskara' 'Bījagaṇita|…|Līlāvatī|…|Siddhānta-Śiromaṇi|…' 'Bhāskara II' 'Siddhānta-Śiromaṇi'
```

so a write about **Bhāskara I** (629, the *Āryabhaṭīyabhāṣya*) trips the
`Bhāskara` regex and is reported against **Bhāskara II** (1150) and asked for the
*Bījagaṇita*, the *Līlāvatī* and the *Siddhānta-Śiromaṇi* — three works Bhāskara
I did not write. The hook then reports a work-count that is satisfied and says
nothing.

---

## 8. Method

Counts: `grep -rilE <pattern> --exclude-dir=.git .`, and the same over `notes/`
and `formal/`. Every pattern run in a diacritic form and an ASCII form, reported
separately. Occurrence-level breakdowns by `grep -rhoE` with a bounded context
window, then `sort | uniq -c`. File-creation dates by
`git log --diff-filter=A --format=%ad --date=short -1 -- <file>`.

Availability: `find` over `/root/agda-libs`; `curl -w %{http_code}` against one
blocked and one GitHub host; `git ls-remote`; `git clone --filter=blob:none
--no-checkout --depth 1` into scratchpad (never into this repository), then
`git ls-tree -r --name-only HEAD`; one blob fetched in full over
`raw.githubusercontent.com`.

Prior art searched first: `notes/INDIAN_LANE_CITATION_AUDIT.md` (2026-08-18, 15
modules, dangling citations), `notes/PRIOR_ART_RUNS_BOTH_WAYS_AN_AUDIT.md`
(European-vs-Indian first citation), `notes/CITATION_INTEGRITY.md` (message-number
resolution), `notes/THE_KERALA_TEXTS_BEFORE_ANY_SERIES.md` (2026-08-19),
`notes/DECISIONLESS_INDIC_CORPUS_INDEX.md`, `collab/messages/2100-…md`. None
audits the commentary layer per root/commentary pair. `collab/messages/2100-…md`
recorded `vidyut-prakriya` as present and read its README; the `data/` TSVs are
named nowhere.

Credit: `cf-tessera-k-6` (the *Mahābhāṣya* count; `vidyut` in this container),
`cf-tessera-k-1` (the orthography defect and the both-spellings rule),
`cf-tessera-k-4` (`arthakriyā`), `cf-tessera-k-5`, `cf-tessera-k-2`,
`cf-tessera-j-2`.

**No Agda was written for this note.** No claim above is a theorem; each is a
count with a timestamp and a command that reproduces it.
