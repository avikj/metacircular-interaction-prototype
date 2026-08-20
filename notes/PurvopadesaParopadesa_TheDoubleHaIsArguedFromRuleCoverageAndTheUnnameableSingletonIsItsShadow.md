# Pūrvopadeśa / paropadeśa — Patañjali on the twice-taught ह, read in full

`cf-tessera-z-2`, 2026-08-20. Reading task. One Agda module landed with it.
Section found by `cf-tessera-u-0` (its note,
`notes/Siddhasadhana_TheSixDeclinedPriorArtSearchesRunWithWhatEachHostAnswered.md`,
is untracked and its property; read, not touched). Theorem read against
`cf-tessera-k-6`'s
`formal/cubical/NaturalMachine/Pratyahara_TheRepeatedHaBreaksIntersectionClosureAtExactlyOneSet.agda`
(commit `691156fe`), which names the *Mahābhāṣya* as the place the double ह is
argued and states it was not read there.

---

## On the name of this note

**पूर्वोपदेश** and **परोपदेश** are the section's own two words for its two
branches, and they are what it is about:

- `{12} astu tarhi pūrvopadeśaḥ` — *then let it be the earlier teaching*;
  `{14} yadi pūrvopadeśaḥ …`
- `{5}/{6} hakārasya paropadeśe …` — *if ha is taught in the later place*;
  and in the parallel section on र्, `Śs_5.2 {27} atha vā punaḥ astu
  paropadeśaḥ`.

I considered **उभयोपदेश** for the conclusion and rejected it. `ubhayopadeśa`
does occur in the *Mahābhāṣya* — exactly once, in the Paspaśāhnika
(`Pas_6 {6}`, KA I,5.11–22): *kim śabdopadeśaḥ kartavyaḥ āhosvit
apaśabdopadeśaḥ āhosvit ubhayopadeśaḥ iti* — "is it correct words that are to
be taught, or incorrect words, or both?" That is a different question, and
carrying the word over to this section would be asserting a usage the text
does not have (CLAUDE.md file-naming note 2). **The section has no single
compound for the conclusion.** Its conclusion is a sentence:
`{29} tasmāt pūrvaḥ ca upadeṣṭavyaḥ paraḥ ca`. So the note is named for the
attested pair, not for a coined summary.

The state of affairs itself the text calls `dviḥ upadiśyate` (`{2}`) — a hapax:
one occurrence in the whole 49 090-line file. The parallel for ण् is
`dviḥ anubadhyate` (`Śs_6 {1}`).

---

## Source, edition, provenance

| | |
|---|---|
| text | Patañjali, *Vyākaraṇa-Mahābhāṣya*, c. 150 BCE; the vārttikas embedded at `{5}/{6}` and `{13}` are Kātyāyana's, c. 250 BCE |
| section | Śivasūtra section, paragraph on the twice-taught ह; GRETIL marker `Śs_5.1`, thirty sentences |
| reference in file | `P. I.27.2-20  Ro_I,93-94` |
| edition behind `KA_`/`P.` | **Franz Kielhorn (Bombay 1880–1885), revised by K. V. Abhyankar (Poona 1972–1996)** — from `catalog.csv`, `source_bibl` |
| `Ro_` | Rohtak edition |
| e-text | `6_sastra/1_gram/sa_pataJjali-vyAkaraNamahAbhASya.txt`, 4 482 319 chars, 49 090 lines, CC BY-NC-SA 4.0 |
| clone | `tokushige-koyasan/gretil-corpus`, HEAD `b724739a` (2026-08-04), derived from `INDOLOGY/GRETIL-mirror` commit `0baf718d` — cloned to `/tmp`, never into the repo |

**Two cautions about the reference, established rather than assumed.**

1. This section's header prints `P. I.27.2-20`, not the file's usual `KA_I,…`.
   **154 of the file's 1910 section headers use the `P.` form**; the rest use
   `KA_`. It is the same pagination, not a second edition: the section before
   it ends at `KA_I,26.27` and the section after it begins at `KA_I,27.21`, so
   `P. I.27.2-20` is page 27, lines 2–20, continuous with both.
2. **The file carries page/line per SECTION, not per sentence.** All thirty
   sentences below share the one reference `I.27.2–20`. A per-sentence Kielhorn
   line cannot be given from this file, and I do not manufacture one.

---

## 1. `Śs_5.1` in full — thirty sentences

Transliteration **exactly as GRETIL gives it**, including its word-splitting
(`pūrvaḥ ca` for *pūrvaś ca*, `kaḥ ca` for *kaś ca*) and its `Ś` for the
anunāsika. Everything after the em-dash is **my gloss**, not the text.

> `{1}` **sarve varṇāḥ sakṛt upadiṣṭāḥ .**
> — *my gloss:* all sounds are taught once.
>
> `{2}` **ayam hakāraḥ dviḥ upadiśyate pūrvaḥ ca paraḥ ca .**
> — this ha is taught twice, the earlier and the later.
>
> `{3}` **yadi punaḥ pūrvaḥ eva upadiśyeta paraḥ eva vā .**
> — but what if only the earlier were taught, or only the later?
>
> `{4}` **kaḥ ca atra viśeṣaḥ .**
> — and what is the difference here?
>
> `{5}` **hakārasya paropadeśe aḍgrahaṇeṣu hagrahaṇam .**  ← *vārttika*
> — if ha is taught in the later place, [then] in the aṭ-mentions, a mention
> of ha.
>
> `{6}` **hakārasya paropadeśe aḍgrahaṇeṣu hagrahaṇam kartavyam .**
> — …a mention of ha must be made.
>
> `{7}` **ātaḥ aṭi nityam , śaḥ chaḥ aṭi , dīrghāt aṭi samānapade .**
> — [the aṭ-mentions:] A 8.3.3 आतोऽटि नित्यम्, A 8.4.63 शश्छोऽटि,
> A 8.3.9 दीर्घादटि समानपादे.
>
> `{8}` **hakāre ca iti vaktavyam iha api yathā syāt : mahāŚ hi saḥ .**
> — "and before ha" would have to be stated, so that it applies here too:
> *mahāṁ hi saḥ*. (`Ś` = the anunāsika; the file uses it the same way at
> `P_1,1.17-18.2 {5}–{9}` — `uŚ`, `ūŚ`, glossed there *dīrghaḥ anunāsikaḥ* —
> and at `P_1,3.2.1 {2}` *abhre āŚ apaḥ : uddeśe yaḥ anunāsikaḥ*.)
>
> `{9}` **uttve ca . uttve ca hakāragrahaṇam kartavyam .**
> — and in [the rule for] the substitution of u; there too a mention of ha
> must be made.
>
> `{10}` **ataḥ roḥ aplutāt aplute , haśi ca .**
> — [namely] A 6.1.113 अतो रोरप्लुतादप्लुते, A 6.1.114 **हशि च**.
>
> `{11}` **hakāre ca iti vaktavyam iha api yathā syāt : puruṣaḥ hasati ,
> brāhmaṇaḥ hasati iti .**
> — "and before ha" would have to be stated, so that it applies here too:
> *puruṣo hasati*, *brāhmaṇo hasati*.
>
> `{12}` **astu tarhi pūrvopadeśaḥ .**
> — then let it be the earlier teaching.
>
> `{13}` **pūrvopadeśe kittvakseḍvidhayaḥ jhalgrahaṇāni ca .**  ← *vārttika*
> — under the earlier teaching, the rules for kit-ness, for ksa and for iṭ,
> and the jhal-mentions.
>
> `{14}` **yadi pūrvopadeśaḥ kittvam vidheyam .**
> — if the earlier teaching, kit-ness has to be provided [separately].
>
> `{15}` **snihitvā snehitvā sisnihiṣati sisnehiṣati .**
> — [examples; from √ṣṇih, which ends in ह.]
>
> `{16}` **ralaḥ vyupadhāt halādeḥ iti kittvam na prāpnoti .**
> — by A 1.2.26 **रलो व्युपधाद्धलादेः संश्च** kit-ness would not obtain.
>
> `{17}` **ksavidhiḥ .**
> — the ksa-rule.
>
> `{18}` **ksaḥ ca vidheyaḥ .**
> — and ksa has to be provided.
>
> `{19}` **adhukṣat alikṣat .**
> — [examples; from √duh and √lih, both ending in ह.]
>
> `{20}` **śalaḥ igupadhāt aniṭaḥ ksaḥ iti ksaḥ na prāpnoti .**
> — by A 3.1.45 **शल इगुपधादनिटः क्सः** ksa would not obtain.
>
> `{21}` **iḍvidhiḥ .**
> — the iṭ-rule.
>
> `{22}` **iṭ ca vidheyaḥ .**
> — and iṭ has to be provided.
>
> `{23}` **rudihi svapihi .**
> — [examples; imperatives of √rud and √svap, the affix *hi* beginning with ह.]
>
> `{24}` **valādilakṣaṇaḥ iṭ na prāpnoti. jhalgrahaṇāni ca .**
> — the iṭ conditioned by a *val*-initial [affix] would not obtain
> (A 7.2.35 आर्धधातुकस्येड् वलादेः, with A 7.2.76 रुदादिभ्यः सार्वधातुके).
> — and the jhal-mentions.
>
> `{25}` **kim .**
> — what [of them]?
>
> `{26}` **ahakārāṇi syuḥ .**
> — they would be without ha.
>
> `{27}` **tatra kaḥ doṣaḥ .**
> — what is the fault in that?
>
> `{28}` **jhalaḥ jhali iti iha na syāt : adāgdhām adāgdham .**
> — A 8.2.26 **झलो झलि** would not apply here: *adāgdhām*, *adāgdham*.
>
> `{29}` **tasmāt pūrvaḥ ca upadeṣṭavyaḥ paraḥ ca .**
> — therefore both the earlier and the later must be taught.
>
> `{30}` **yadi ca kim cit anyatra api upadeśe prayojanam asti tatra api
> upadeśaḥ kartavyaḥ .**
> — and if there is any purpose in teaching [a sound] elsewhere as well,
> teaching must be done there too.

`{30}` is the general principle and it is not a rider: **teaching is repeated
wherever there is a प्रयोजन for it, without a stated bound.** The same
formulation opens `Śs_2 {3}` about ऌ: *yadi kim cit anyeṣām api varṇānām
upadeśe prayojanam asti ḷkāropadeśasya api tat bhavitum arhati*.

---

## 2. What breaks in each branch, in his terms

Each सूत्र below was looked up in
`/root/agda-libs/vidyut/vidyut-prakriya/data/sutrapatha.tsv` (3984 sūtras,
SLP1) — **no path under `/root/agda-libs/vidyut/` had appeared anywhere in this
repository before today.** Every one of Patañjali's citations is present and
matches. The set computations are `awk` over the fourteen sūtras in SLP1, taken
from `vidyut-prakriya/src/sounds.rs`'s `SUTRAS` table; they agree sound-for-sound
with `cf-tessera-k-6`'s Agda encoding.

### परोपदेश — ह taught only in हल् (the fourteenth)

| what breaks | grahaṇa | sūtras | computed |
|---|---|---|---|
| `{5}–{8}` the **अट्**-mentions | अट् | A 8.3.3, A 8.4.63, A 8.3.9 | अट् = {अ इ उ ऋ ऌ ए ओ ऐ औ **ह** य व र}, 13 → 12, ह gone |
| `{9}–{11}` the **उ**-substitution | हश् | A 6.1.113 + A 6.1.114 हशि च | **हश् ceases to be a name**: no ह is followed by श् |

**Patañjali's three अट्-sūtras are all three that exist.** Searching
`sutrapatha.tsv` for अट् in every written form — including the sandhi-elided
`'wi` of *ato'ṭi* — gives exactly A 8.3.3, A 8.3.9, A 8.4.63 (A 3.2.124 `lawaH`
is the लकार लट्, a homonym). **A 6.1.114 हशि च is the only sūtra in the
Aṣṭādhyāyī that uses हश्.**

### पूर्वोपदेश — ह taught only in हयवरट् (the fifth)

The vārttika `{13}` names four things. Behind them are four pratyāhāras, and
each is a class that **begins after the position of the earlier ह and closes at
ल्**, so each of them can only reach ह through the *later* one:

| `{13}` | grahaṇa | sūtra | computed |
|---|---|---|---|
| कित्त्व | **रल्** | A 1.2.26, `{16}` | 31 → 30, ह gone |
| क्स | **शल्** | A 3.1.45, `{20}` | {श ष स **ह**} → {श ष स} |
| इट् | **वल्** | A 7.2.35 (+ A 7.2.76), `{24}` | 32 → 31, ह gone |
| झल्ग्रहणानि | **झल्** | A 8.2.26 and six others, `{26}`–`{28}` | 24 → 23, ह gone |

**And this list is exhaustive over what the grammar actually uses.** Deleting
the later ह changes the denotation of **exactly 32** nameable classes; all 32
are of the form X-**ल्** with X a sound standing after ह in हयवरट्; and of those
32, **exactly four occur as grahaṇas in the Aṣṭādhyāyī — रल्, शल्, वल्, झल्** —
which are exactly Kātyāyana's four. (The other 28 candidate names — यल्, मल्,
ञल्, खल्, कल्, … — do not occur. `Kal`, `Pal`, `Tal`, `tal`, `Ral`, `kal`,
`pal`, `bal` all return grep hits and every one of them is something else: the
kṛt affix खल्, the perfect ending थल्, the taddhita तल्, the ending णल्,
*kalāpin*, *palāśa*, *bala*, *phala*. Substring false nonzeros, all vetted by
hand.)

**झल्** is used at A 1.2.9, 6.1.183, 6.4.37, 8.2.26, 8.2.39, 8.3.24, 8.4.53 —
seven sūtras, and `{24}` says *jhalgrahaṇāni*, plural, then picks A 8.2.26 as
the fault.

---

## 3. Does he consider intersections? **No — and the neighbourhood is exact**

**His argument is entirely about coverage.** Every one of the thirty sentences
has the shape *"rule R would not obtain in form E"* — `na prāpnoti` at `{16}`,
`{20}`, `{24}`; `na syāt` at `{28}`; `yathā syāt` at `{8}`, `{11}`. The closest
the text comes to predicating anything of a *set* is `{26} ahakārāṇi syuḥ` —
"they would be without ha" — which is membership, and `{27}` immediately turns
it back into a rule: *tatra kaḥ doṣaḥ*, what fault follows.

**Scope of the negative, so it is not a bare assertion.** I read all thirty
sentences of `Śs_5.1`, all of `Śs_5.2`, `Śs_5.5`, `Śs_5.6`, `Śs_6`, `Śs_7-8.1–3`,
and the openings of the remaining `Śs_` sections. Whole-file greps, snapshot
2026-08-20: `ubhayagrahaṇa` 1 (at `P_6,1.17.2`, unrelated), `sādhāraṇa` 1
(`P_5,4.36`, unrelated), `vyāpti` 0, `antarbhāva` 0, `dvayoḥ grahaṇa` 0,
`ubhayoḥ grahaṇa` 0, `dvābhyām grahaṇa` 0, `grahaṇadvaya` 0. **I found no
passage anywhere in the file reasoning about the sounds common to two
pratyāhāras.** That is a negative over one e-text of one work, dated, not a
claim about Patañjali's mind.

**So k-6's theorem and `Śs_5.1` are neighbours, not the same result** — and
here is how close the neighbourhood is.

k-6's witness is **हश् ∩ शल् = { ह }**, with `{ ह }` nameable by no legal pair.
Across the whole 4.8 MB file:

- **हश्** occurs in 4 genuine places: `Śs_5.1 {10}`, `P_3,2.139 {46}`,
  `P_6,1.185 {21}`, `P_8,2.6.2 {97}`. (`khaśaḥ`, `rephaśirāḥ` are substring
  collisions.)
- **शल्** occurs in 2 genuine places: `Śs_5.1 {20}`, `P_3,1.44.2 {20}`.
  (`kuśalaḥ` is a collision.)
- **They never co-occur in one sentence.**

And yet: **the two pratyāhāras whose intersection is exactly `{ह}` are precisely
the two Patañjali cites on opposite sides of his alternative** — हश् (A 6.1.114)
in the परोपदेश branch at `{10}`, शल् (A 3.1.45) in the पूर्वोपदेश branch at
`{20}`. Each is the only sūtra in the Aṣṭādhyāyī using its pratyāhāra. He puts
them side by side and never intersects them, because on his question they are
opposite arms of a dilemma, not two sets.

**The theorem that follows, and it is not his.** Checked in
`formal/cubical/NaturalMachine/PurvopadesaParopadesa_TheSingletonHaExistsOnlyUnderTheDoubleTeaching.agda`
(`--cubical --safe`, no postulates, no holes, exit 0 in 4.9 s, Agda 2.6.3 +
cubical v0.5):

| string | हश् | शल् | हश् ∩ शल् |
|---|---|---|---|
| the fourteen as given | 20 sounds | {श ष स ह} | **{ह}** |
| परोपदेश (`{5}`) | **not a name** | {श ष स ह} | — |
| पूर्वोपदेश (`{12}`) | 20 sounds | {श ष स} | **∅** |

**The one set at which ∩-closure fails is manufactured by exactly the
repetition that `{13}` and `{5}` argue is forced.** Take the repetition away in
either direction and the singleton is gone — and so are the classes the
Aṣṭādhyāyī needs. Coverage and ∩-closure are two different demands on the same
family; the tradition argues the first at length; satisfying the first is what
breaks the second, at exactly one set.

**What is claimed of Patañjali:** that he poses the two counterfactuals, and
rejects each by naming rules that stop reaching forms. **What is not claimed:**
that he proved, stated, or would recognise anything about intersection-closure.
He did not. He established that no single position for ह serves the whole rule
system, and he established it by exhibiting, on each branch, particular sūtras
and particular derivations that fail.

---

## 4. The neighbouring `Śs_` sections

Fifteen sections, all counts from this file, snapshot 2026-08-20:
`Śs_1.1` 74, `Śs_1.2` 109, `Śs_2` 115, `Śs_3-4.1` 80, `Śs_3-4.2` 138,
`Śs_5.1` 30, `Śs_5.2` 36, `Śs_5.3` 74, `Śs_5.4` 101, `Śs_5.5` 29, `Śs_5.6` 43,
`Śs_6` 81, `Śs_7-8.1` 17, `Śs_7-8.2` 6, `Śs_7-8.3` 7.

### `Śs_5.2` (KA I,27.21–28.15) — **the same argument shape, for र्**

`{1} idam vicāryate : ayam rephaḥ yakāravakārābhyām pūrvaḥ eva upadiśyeta
ha ra ya vaṭ iti paraḥ eva vā yathānyāsam iti` — should र् be taught *before*
य् and व् (**हरयवट्**) or after, as it stands? The identical two-branch move:
`{3}` *rephasya paropadeśe* → अनुनासिक, द्विर्वचन and परसवर्ण would wrongly
apply (A 8.4.45? यरोऽनुनासिके, A 8.4.46 अचो रहाभ्यां द्वे, A 8.4.58 अनुस्वारस्य
ययि परसवर्णः); `{9} astu tarhi pūrvopadeśaḥ` → कित्त्व over-applies (A 1.2.26
again) and the व्-lopa rule (A 6.1.66 लोपो व्योर्वलि) fails. **But here the
answer is different:** `{14} na eṣaḥ doṣaḥ`, and both branches get repaired by
re-reading, ending `{29}–{33}` with *rephoṣmaṇām savarṇāḥ na santi* and *nimittam
imau rahau dvirvacanasya* — र् and ह् are the *occasion* of doubling, not its
*subject*. **So the two-branch form is a standing method in these sections, and
it does not always end in "teach it twice."** For ह it does; for र् it ends in
a distinction.

### `Śs_6` (KA I,34.4–35.18, 81 sentences) — **the second ण्, and the convention `vidyut` calls `R2`**

**Yes: the Mahābhāṣya states it, and this is where.**

`{1} ayam ṇakāraḥ dviḥ anubadhyate pūrvaḥ ca paraḥ ca .`
`{2} tatra aṇgrahaṇeṣu iṇgrahaṇeṣu ca sandehaḥ bhavati pūrveṇa vā syuḥ pareṇa
vā iti .` — *in the अण्-mentions and the इण्-mentions there is doubt: are they
by the earlier or by the later?*

He then walks every अण्-mention in turn, each with the same four-move frame
(*asandigdham … kutaḥ etat … parābhāvāt … nanu ca ayam asti … evam tarhi
sāmarthyāt*):

| sūtra | `{ }` | verdict |
|---|---|---|
| A 6.3.111 ढ्रलोपे पूर्वस्य दीर्घोऽणः | `{4}–{14}` | **पूर्व** |
| A 7.4.13 केऽणः | `{15}–{26}` | **पूर्व** |
| A 8.4.57 अणोऽप्रगृह्यस्यानुनासिकः | `{27}–{36}` | **पूर्व** |
| A 1.1.51 उरण् रपरः | `{37}–{66}` | **पूर्व** (after a long ज्ञापक detour through A 7.1.100 ऋत इद्धातोः) |
| A 1.1.69 अणुदित्सवर्णस्य चाप्रत्ययः | `{67}–{70}` | **पर**, by the ज्ञापक that A 1.1.51 writes `उः ऋत्` with ऋ made तपर |
| the इण्-mentions | `{71}–{79}` | **पर**, by the ज्ञापक that where he wants the earlier he writes `य्वोः` instead, spending 3½ मात्रा where a pratyāhāra would cost 3 |

and closes, `{81/81}`, at the end of KA I,34.4–35.18:

> **etat jñāpayati ācāryaḥ bhavati eṣā paribhāṣā vyākhyānataḥ
> viśeṣapratipattiḥ na hi sandehāt alakṣaṇam iti. aṇuditsavarṇam parihāya
> pūrveṇa aṇgrahaṇam pareṇa iṇgrahaṇam iti vyākhyāsyāmaḥ .**
>
> — *my gloss:* by this the ācārya makes it known that this paribhāṣā holds —
> **specific determination comes from explanation, for doubt does not abolish a
> rule** — and we shall explain: setting aside [A 1.1.69] अणुदित्सवर्णस्य, the
> **अण्-mentions are by the earlier, the इण्-mentions by the later.**

`vidyut-prakriya/src/sounds.rs:305–306` documents its convention as *"`R` refers
to the first `R` (a i u R); `R2` refers to the second `R` (la R)"* and uses
`iR2` at `src/tripadi/pada_8_3.rs:21–22` — for A 8.3.57 इण्कोः — and `aR` (first)
at `src/tripadi/pada_8_4.rs:19` for A 8.4.57. **Both choices are Patañjali's,
`{71}–{79}` and `{27}–{36}` respectively.** The crate calls it "an external
convention"; `Śs_6 {81}` is where it is stated, and the paribhāṣā it is stated
under — *vyākhyānato viśeṣapratipattiḥ, na hi sandehād alakṣaṇam* — is
Paribhāṣā 1 of Nāgeśa's *Paribhāṣenduśekhara*. Snapshot: `vyākhyānato` occurred
**0 times** in this repository before this note.

I did not check whether the crate's `aR` is used anywhere that A 1.1.69 governs;
`{67}–{70}` says that one alone is by the *later*, and the crate has no `aR2`.
**That is an open discrepancy, not a defect I have demonstrated.**

### `Śs_5.5` (KA I,32.12–33.4, 29 sentences) — **why the अनुबन्धs are not caught by अच्-mentions**

`{2} pratyāhāre anubandhānām katham ajgrahaṇeṣu na .` — the it-markers ण् क् ङ्
च् physically stand among the vowels; why does an अच्-grahaṇa not pick them up?
`{5}–{6}` gives the damage: *dadhi ṇakārīyati* would take यण् by A 6.1.77.
Three answers: `{7}–{10}` **आचारात्** — from the ācāryas' usage; `{11}–{13}`
**अप्राधान्यात्** — they are not taught there as principal; `{19}` **लोपश्च
बलवत्तरः** — and the elision (A 1.3.9) is stronger.

**This is the passage `cf-tessera-k-6`'s `isMarker : Sym → Bool` formalises, and
it is worth saying that Patañjali does not ground it structurally.** He grounds
it in आचार and in अप्राधान्य. The boolean is a decision the encoding makes;
the text makes it a matter of how the sounds were taught, not of what they are.

`{17}–{18}` is a design statement about the fourteen and I have found no other:

> **eṣā hi ācāryasya śailī lakṣyate yat tulyajātīyān tulyajātīyeṣu upadiśati .
> acaḥ akṣu halaḥ halṣu .**
>
> — *my gloss:* this is observed to be the ācārya's manner: he teaches
> like-kind among like-kind — vowels among the vowel-[sūtras], consonants among
> the consonant-[sūtras].

### `Śs_5.6` (KA I,33.5–34.2, 43 sentences) — **the placement of य् व् र् ल्**

`{1} atha kimartham antaḥsthānām aṇsu upadeśaḥ kriyate .` — why are the
अन्तःस्थs taught inside the अण् span at all? Directly on the ordering of the
fourteen.

### `Śs_7-8.1` (KA I,35.20–36.4, 17 sentences) — **which अनुबन्ध, ञ् or म्**

`{1} kimartham imau mukhanāsikāvacanau varṇau ubhau api anubadhyete na ñakāra
eva anubadhyeta .` — why are both attached as anubandhas; why not ञ् alone? Then
the same shape again: substitute यञ् for यम् in A 8.4.64 हलो यमां यमि लोपः,
A 8.3.6 पुमः खय्यम्परे, A 8.3.32 ङमो ह्रस्वादचि ङमुण् नित्यम्, and show what
over-applies — answered `{5}`, `{10}`, `{14}` by *jha* and *bha* never in fact
standing in the required position, and finally `{15}` by यथासंख्य (A 1.3.10):
five आगमs against three आगमिन्s. **Same method, applied to the choice of
it-marker rather than to the placement of a sound.**

### the rest, briefly

`Śs_1.1`/`Śs_1.2` — the विवृत teaching of अ, and सवर्ण-grahaṇa (`{1}
anaṇtvāt`). `Śs_2` — why ऌ is taught at all, with `{3}` the same *prayojana*
principle as `{30}` above. `Śs_3-4.1` — should the सन्ध्यक्षरs be taught तपर.
`Śs_3-4.2` — whether a sound that is part of another sound is caught by the
whole (`{4} iha samudāyāḥ api upadiśyante avayavāḥ api`). `Śs_5.3` — the
अयोगवाहs, taught nowhere and heard nevertheless. `Śs_5.4` — are the sounds
meaningful. `Śs_7-8.2`/`.3` — what *akṣara* is, and why the whole
अक्षरसमाम्नाय is taught: `{5} brahmarāśiḥ`.

---

## 5. What the `vidyut` data gave

Nothing under `/root/agda-libs/vidyut/vidyut-prakriya/data/` had been opened by
anything in this repository. Used here:

- **`sutrapatha.tsv` (3984)** — every sūtra Patañjali cites in `Śs_5.1`, present
  and matching: A 1.2.26, 3.1.45, 6.1.113, 6.1.114, 7.2.35, 7.2.76, 8.2.26,
  8.3.3, 8.3.9, 8.4.63; and for `Śs_6`: A 1.1.51, 1.1.69, 6.3.111, 7.4.13,
  8.4.57, 8.3.57. It is what makes the exhaustiveness claims in §2 checkable at
  all.
- **`src/sounds.rs`** — the `SUTRAS` table and the `R`/`R2` documentation.

**`varttikas.tsv` (109) gave nothing, and this is worth recording.** It is keyed
by Aṣṭādhyāyī sūtra code and its first entry is `1.1.33.1`; **it contains no
Śivasūtra-section vārttikas at all**, so neither `{5}/{6}` nor `{13}` is in it.
It is a small curated selection out of Kātyāyana's several thousand, not a
vārttikapāṭha. `dhatupatha.tsv`, `unadipatha.tsv`, `linganushasanam.tsv`,
`phit-sutras.tsv`, `kaumudi.tsv`, `kashika.tsv` do not bear on the double ह and
were not used.

---

## 6. Two things of mine, refuted

**(a) An Agda claim, killed by the checker.** I wrote that on the परोपदेश
string the extractor would report the vanished name हश् as the empty class —
`between ha Ś sivasutra14-para ≡ []`. Agda rejects it:

```
ha ∷ upto Ś (L ∷ []) != [] of type List Sym
```

`upto` collects until it finds the marker **or runs out of list**, so it walks
off the end and returns what it passed. The true value is `ha ∷ []` — the
extractor hands back **the very singleton k-6 proves is unnameable**, as though
it were the value of a name. So the ∩-closure statement cannot be transported to
a counterfactual string by `between` alone; it needs a definedness predicate,
which is `named?` in §1 of the new module. On the fourteen as they stand the
truncation never fires for these two names, so **k-6's theorem is untouched** —
but the extractor the three `NaturalMachine` pratyāhāra modules share is total
*by truncation*, not by totality, and that is a defect all three carry.

**(b) A reading of mine, killed by the computation.** I took the two vārttikas
to be symmetric — each enumerating what breaks on its branch. They are not.

- Under **पूर्वोपदेश**, 32 names change denotation, and the four Kātyāyana
  names are exactly the four of those 32 that the Aṣṭādhyāyī uses. Exhaustive.
- Under **परोपदेश**, **88** names change denotation. The vārttika `{5}` names
  one class of them (अट्) and Patañjali adds one more (हश्). At least two
  further *used* names change and are not named in the section: **हल्**
  collapses to `{ह}` alone — हल् appears in roughly 45 sūtras of
  `sutrapatha.tsv`, more than any other pratyāhāra — and **अश्** loses ह,
  bearing on A 8.3.17 भोभगोअघोअपूर्वस्य योऽशि.

  **(and a correction inside the correction)** I first published 97 here, from
  comparing the *extracted lists*. Nine of those 97 are order-only: अल् for
  instance runs `… ह य व र ल …` under the double teaching and `… य व र ल …
  श ष स ह` under परोपदेश — the same 42 sounds, ह moved to the end. Comparing as
  sets, 88. The पूर्वोपदेश count is 32 either way, every one of the 32 losing a
  member. **A list is not a set, and the extractor returns lists.**

I record that and I do not score it. The vārttika is headed *aḍgrahaṇeṣu* — it
says what it is about. Reading a selective enumeration as a failed exhaustive
one is a durnaya, and the missing word is **स्यात्**.

---

## 7. What I could not establish

- **Whether the section has its own compound for the conclusion.** It does not,
  in this e-text; `{29}` is a sentence. I did not invent one.
- **A per-sentence Kielhorn line.** The file gives page/line per section.
- **Whether `vidyut`'s single `aR` is correct for A 1.1.69.** `Śs_6 {67}–{70}`
  puts A 1.1.69 with the *later* ण्; the crate has no `aR2`. I did not read the
  crate's A 1.1.69 handling far enough to say it is wrong.
- **Kātyāyana's own text.** I read the two vārttikas only as the *Mahābhāṣya*
  embeds them. No separate vārttikapāṭha was reachable — `varttikas.tsv` has no
  Śivasūtra entries, and GRETIL's own host is 403 at the gateway.
- **Whether ∩-closure was ever a design criterion.** Nothing in the fifteen
  `Śs_` sections suggests the question was posed. That is absence of evidence
  over one work.

---

## 8. Grep defects caught while doing this — all dated 2026-08-20

Three of the six fired, live:

1. **Bracket classes over non-ASCII match bytes.** `grep -c "[अ-ह]"` on the
   e-text returned **44 854 lines** — the whole file. The range is a byte range
   and it swallows Latin text. `grep -cE "अ|आ|…|ह"` returns **0**: the file is
   romanized only. Alternation, never brackets.
2. **Orthography false zeros.** `grep -c "paropadeśa"` found 3 and missed
   `Śs_5.1 {5}/{6}`, which write `paropadeśe`. `grep "awi"` for अट् missed
   A 8.3.3, which sandhi writes `Ato'wi` — the initial अ is elided. Both forms
   had to be run.
3. **Substring false nonzeros.** `śal` → *kuśalaḥ*, *śalālu*; `haś` → *khaśaḥ*,
   *rephaśirāḥ*; `hal` → *halasīra*, *halisakthi* (plough); `Kal`/`Tal`/`tal`/
   `Ral` → the affixes खल्, थल्, तल्, णल्. Every nonzero in §2 was vetted by
   eye.
4. **Prefix collision:** `grep "paropadeśa"` matched `taparopadeśaḥ` at
   `Śs_3-4.1 {7}/{8}` — *tapara*-upadeśa, a different word.

Repo-side snapshot, `notes/` and whole repo, taken **before** this note was
written, 2026-08-20: `Mahābhāṣya` 5/16, `mahAbhASya` 3/6, `Patañjali` 8/23,
`Kātyāyana` 10/19, `vārttika` 10/35, `Kielhorn` 2/4, `Śivasūtra` 4/11,
`शिवसूत्र` 1/5, `pratyāhāra` 8/27, `प्रत्याहार` 1/8, `anubandha` 3/9,
`pūrvopadeśa` 2/3, `paropadeśa` **0/0**, `vyākhyānato` **0/0**,
`महाभाष्य` **0/0**, `पतञ्जलि` **0/0**, `कात्यायन` **0/0**. Counts are a
snapshot and this note makes several of them nonzero.

---

## Standing on

- `cf-tessera-k-6`, `formal/cubical/NaturalMachine/Pratyahara_TheRepeatedHaBreaksIntersectionClosureAtExactlyOneSet.agda`,
  commit `691156fe` — the theorem this reads against, and whose own §6 killed
  the last-occurrence repair by हल् and हश्. **`Śs_5.1`'s परोपदेश branch
  destroys the same two classes** — computed above — and Patañjali names one of
  them, हश्, at `{10}`.
- `cf-tessera-u-0`, `notes/Siddhasadhana_…` (untracked, not touched) — found the
  section, the file, and the marker.
