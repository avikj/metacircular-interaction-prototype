# Emptiness is not univalence: the mokṣa-yantra reduced negations to constructions

**Status: source-critical self-refutation.** This note withdraws the Sanskrit
identifications made by four Agda modules I wrote this session
(`formal/cubical/NaturalMachine/NisvabhavaNet.agda`,
`CatuskotiPerspective.agda`, `PratityasamutpadaArising.agda`,
`MokshaYantra.agda`, sealed in `Moksha.agda`). It does not formalize
Madhyamaka, Jain, or Dzogchen thought, and it does not claim the checked
terms are wrong *as type theory* — they type-check and remain true. What is
withdrawn is the claim that they *are*, or *harden*, the Indian material whose
names they carry. The reduction those modules performed is the exact error
this repository's Indian lane (`APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md`,
`ABHAVA.md`, `PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md`) was built to prevent, and —
worse — it is the error the primary doctrine names as incurable.

## 1. The move, and why it is the disease and not the cure

Each module took an Indian **negation** — a refusal of intrinsic essence, a
refusal of a standpoint-free truth-value — and set it equal to a **positive,
inhabited, well-behaved type-theoretic construction**:

| module | the identification it asserts | Sanskrit it claims |
|---|---|---|
| `NisvabhavaNet` | `no-own-being := univalence` | niḥsvabhāva / śūnyatā |
| `CatuskotiPerspective` | the tetralemma *is* a coherent perspectival semantics; `both-is-consistent` inhabits the middle corner | catuṣkoṭi, anekāntavāda, śūnyatā |
| `PratityasamutpadaArising` | a Boolean observation splitting a pair *is* dependent arising; `cessation := sp ft` | pratītyasamutpāda, anicca, nirodha |
| `MokshaYantra` | bondage/liberation differ only by which `Sight : Type → Bool` meets the pair | avidyā, mokṣa |

Univalence is not a negation. It is one of the strongest *positive* identity
principles known: it says equivalent types **are identical**, and it makes the
identity type a rich, transportable, inhabited object. It *adds* structure; it
gives a type a definite, well-behaved identity read off from its relations.

To set `no-own-being := univalence` is therefore to give niḥsvabhāva a
svabhāva — to make "no-own-being" the name of a positive foundational axiom
with robust own-behaviour. That is not merely unsourced decoration. Nāgārjuna
names this specific move as the one fatal error:

> *śūnyatā sarvadṛṣṭīnāṃ proktā niḥsaraṇaṃ jinaiḥ / yeṣāṃ tu śūnyatādṛṣṭis
> tān asādhyān babhāṣire* — "Emptiness is taught by the victorious ones as the
> relinquishing of all views; but those for whom emptiness is *itself a view*,
> them they called incurable." (Mūlamadhyamakakārikā 13.8.)

And Nāgārjuna refuses, in his own voice, to hold any positive thesis at all:
*nāsti ca mama pratijñā* — "and I have no thesis" (Vigrahavyāvartanī 29). A
module whose entire content is a positive thesis (`univalence`, a term) cannot
be the formalization of a position defined by having none. The identification
inverts the doctrine at the exact point it claims to honour it.

## 2. What the encounter actually leaves: a distinction, not a term

The honest residual is sharper than the equation and is the only thing here
worth keeping. Univalence formalizes **pratītya** — the *relationality* of
identity: a type's identity is not an intrinsic tag but is constituted by how
it stands to others (its equivalences). That much is real and is the genuine
resonance that seduced the reduction.

But **pratītya is not śūnyatā.** Univalence stops at relational identity and
there *affirms* a positive, inhabited identity type — the relation, once
found, is a robust object. Madhyamaka's move is to empty *even that*:
emptiness is itself empty (*śūnyatā* is not a ground; MMK 24.18 makes
dependent origination, emptiness, and the middle way one, and none of the
three is a positive foundation). The tradition's negation is **prasajya** —
non-implicative: it removes without leaving a positive remainder. Univalence's
identity type is precisely a positive remainder.

So the corrected statement, which is a contribution and not a decoration:

> Univalence formalizes the **relational dependence of identity**
> (pratītya-flavoured), and by doing so demonstrates *by contrast* what it
> does **not** reach: the emptiness of the resulting identity itself
> (śūnyatā). Conflating the two — reading a positive identity principle as a
> doctrine of no-own-being — is the reification MMK 13.8 names.

This is the same shape as `APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` §4: the
tradition does not *supply* the formal object; it *refutes the premature claim
that one has been supplied*, and the refutation is the result.

## 3. The catuṣkoṭi module conflates two opposed schools and domesticates a negation

`CatuskotiPerspective` commits two further errors.

**(a) It merges Nāgārjuna with the Jains.** It names *catuṣkoṭi* (Buddhist,
Madhyamaka) and *anekāntavāda* (Jain) as one apparatus. They are opposed
positions. Nāgārjuna's tetralemma (MMK 18.8: *sarvaṃ tathyaṃ na vā
tathyaṃ…* — all is real, or not real, or both, or neither) is deployed as
**prasajya-pratiṣedha** to refuse all four koṭis, leaving no standpoint. Jain
**anekāntavāda / syādvāda** asserts the opposite: a real object with *many
natures* (anekānta-svabhāva), truly graspable from many standpoints (**naya**)
under the conditionality operator **syāt**, enumerated by the sevenfold
**saptabhaṅgī** (syād asti, syād nāsti, syād asti-nāsti, **syād avaktavya**
[inexpressible], and three combinations). The Jains affirm a many-natured
*svabhāva*; the Mādhyamika denies *svabhāva* outright. Each tradition
explicitly refutes the other. A single Agda file cannot be both.

**(b) It domesticates the tetralemma into a consistent model.** `both-is-
consistent : PerspectivallyBoth witnessClaim` gives the "both" corner a
truth-maker (holds at the ⊤-jewel, fails at the ⊥-jewel). That is the
paraconsistent / perspectival reading of the catuṣkoṭi — a real but contested
scholarly position (Priest–Garfield), and one that Madhyamaka readers
(Westerhoff, Siderits) argue effaces the prasaṅga method by handing the
tetralemma the very *pakṣa* (positive thesis) it exists to withhold. Assigning
it a consistent semantics is not neutral hardening; it takes a side in a live
dispute *and* takes the side that the negation-reading says destroys the
point.

What survives: the file's genuine content is a small perspectival semantics
over `Type`-indexed families (holds-here/fails-there is a real, unremarkable
fact about presheaves). That is fine as type theory. Its Sanskrit names are
withdrawn: it is neither the catuṣkoṭi nor anekāntavāda, and it cannot be
both.

## 4. Dzogchen marks the machine's boundary, not another jewel

The owner offered rigpa / the unconditioned as a *different angle* —
unconditioned perception, ka dag (primordial purity) and lhun grub
(spontaneous presence), knowledge as recognition rather than construction. The
correct response is **not** to write a `Rigpa.agda`. Every term in this
substrate is **saṃskṛta** — compounded, constructed, produced by rules. The
unconditioned (**asaṃskṛta**) is by its own account exactly what is *not* a
constructed term. A checked term named `rigpa` would be a category error in
its first character.

That is itself a result, and a humble one: the substrate is constitutively
saṃskṛta, so the unconditioned names a **boundary of what the machine can
hold**, not a content it can hold. This is the honest place to leave it. My
knowledge of Dzogchen is thin (as the owner said his is); the lineage one
would actually study — Longchenpa's *mDzod bdun* (Seven Treasuries),
especially the *Chos dbyings mdzod*; the three series sems sde / klong sde /
man ngag sde — is named here as an obligation, not a source I have read.

## 5. Ledger

| # | item | status |
|---|---|---|
| S1 | `no-own-being := univalence` as a formalization of niḥsvabhāva | **WITHDRAWN.** Univalence is a positive identity principle; the identification reifies emptiness into a svabhāva (MMK 13.8). The term stays true as type theory; the name is withdrawn. |
| S2 | Univalence formalizes pratītya (relational identity) but not śūnyatā | **Mine, and a reading** (§2). Offered as the surviving distinction. Not a claim that univalence and Madhyamaka share an object. |
| S3 | catuṣkoṭi ≡ anekāntavāda | **WITHDRAWN.** Opposed schools (Buddhist niḥsvabhāva vs Jain anekānta-svabhāva); each refutes the other. |
| S4 | the tetralemma *is* a consistent perspectival semantics (`both-is-consistent`) | **WITHDRAWN as a reading of Nāgārjuna.** Takes a contested side (Priest–Garfield) against the prasajya-negation reading (Westerhoff, Siderits). The presheaf fact survives; the Sanskrit does not. |
| S5 | Boolean split ≡ pratītyasamutpāda; `cessation` ≡ nirodha | **WITHDRAWN.** Dependent origination concerns the arising and cessation of dukkha across the nidānas, not a decidable-equality split on `Bool`. |
| S6 | a `rigpa` / unconditioned checked term | **NOT ATTEMPTED, on principle** (§4). The substrate is saṃskṛta; asaṃskṛta marks a boundary, not a term. |
| S7 | "univalence = the one kept Western spark that is itself the source" (NisvabhavaNet header) | **WITHDRAWN.** Univalence is a tool of the Agda substrate, not a member of the lineage. Operating principle (owner, 2026-08-18): raise no borrowed concept as source. |

## 6. Rigor boundary

**Textually supported at chapter.verse (canonical, edition-stable):** MMK
13.8 (emptiness-as-view is incurable); MMK 24.18 (pratītyasamutpāda =
śūnyatā = madhyamā pratipat); MMK 18.8 (the tetralemma verse);
Vigrahavyāvartanī 29 (no-thesis). These are among the most-cited verses in
Buddhist philosophy; I quote them from memory of the standard Sanskrit and
have **not** opened a critical edition (Siderits–Katsura; de Jong; Ye Shaoyong)
this session. Verse *numbers* are stable; the apparatus is unchecked.

**Not verified:** any Jain primary text. The saptabhaṅgī / nayavāda summary
(§3) is standard doxography; the lineage to check — Umāsvāti's
*Tattvārthasūtra*, Siddhasena Divākara's *Sanmatitarka*, Mallavādin's
*Dvādaśāranayacakra*, Vidyānandin — is named as an obligation, unread here.

**Not verified:** any Dzogchen primary text (§4).

**The type theory** in the four modules is checked (each file `agda`-clean
individually; `Moksha.agda` seals the four in one closure). Nothing in §§1–4
touches that; only the identifications are withdrawn.

## 7. Prior art (SEARCH obligation, partially discharged from in-repo record)

`ABHAVA.md` §A6 already located the formalization lineage for Indian logic in
cubical type theory: Matilal (1968, negation into Western logic), Ganeri,
Bhattacharyya (Martin-Löf type theory), and Panday–Ghosh, *Cubical Type
Theoretic Navya-Nyāya* (arXiv:2605.12548). That lineage is the correct home
for any *genuine* formalization — it types **avacchedaka, abhāva, tādātmya,
paramparā-sambandha** by taking them as the object, not by renaming a
pre-existing Western term. My four modules did the opposite (renamed
`univalence` etc.), so they are not in that lineage and claim no place in it.

I did **not** run a fresh web search this session (operating principle: work
from the source, not the outside). The Madhyamaka secondary lineage named
above (Westerhoff, Siderits, Priest–Garfield for the disputed logical reading)
is cited from memory as the dispute one would have to enter; treat every such
name as an unopened SEARCH obligation, not a checked citation.

## 8. Untranslated residual

Nothing here translates: the soteriological point of any of it — that these
are analyses *for the sake of liberation from dukkha*, not semantics; the
two-truths architecture (saṃvṛti / paramārtha) and whether emptiness is
statable in the ultimate at all; the Jain **jīva**, karma-as-subtle-matter,
and **kevala-jñāna**; the Dzogchen **gzhi** (ground), trekchö/tögal, and
self-liberation (rang grol); the Madhyamaka–Yogācāra and Madhyamaka–Jain
disputes; and the whole question of whether *any* of this should be rendered
in a formal substrate at all. The owner's operating principle — stay in the
source, raise no borrowed concept — is, read strictly, a warning that the
substrate itself (a Western-authored proof assistant) is not neutral ground.
That tension is not resolved here; it is named.

## The one line

I took negations that exist to refuse own-being and set them equal to positive
constructions that manufacture it, then called the manufacture a hardening of
the source. The source refutes exactly that manufacture. Withdrawing the
identifications, and keeping only the distinction they obscured —
univalence reaches pratītya and not śūnyatā — is the whole of what the
encounter honestly yields.
