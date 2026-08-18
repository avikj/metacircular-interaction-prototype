# Univalence is niḥsvabhāva made computational — a missing-audit

**Status: correction of my own over-refutation.** An earlier version of this
note (`SUNYATA_IS_NOT_UNIVALENCE.md`) argued that univalence *cannot* be a
formalization of śūnyatā because it leaves a "positive remainder" — the
inhabited identity type `A ≡ B`. That argument is withdrawn: it is the
ignorant move, not the equation. This note does the audit that should have
been done first — *is anything actually missing between univalence and
niḥsvabhāva* — and finds that on the identity-structure, nothing is. Two of
the four original module criticisms survive, because they were separate and
real errors; the headline criticism does not.

The soteriological content of any of this remains untranslated (§6), and no
primary critical edition was opened this session (§5). What follows is a
structural correspondence argued as philosophy, with its boundary named.

## 1. The move that was wrong

The prior refutation: univalence gives `A ≡ B` as a positive, inhabited
object; śūnyatā is prasajya-pratiṣedha (non-affirming negation, no positive
residue); therefore they differ, and univalence reaches only *pratītya*
(relational dependence) and not *śūnyatā* (emptiness of the resulting
identity).

The error: in this substrate the identity type is **itself univalent**.
`A ≡ B` is not a bare positive fact — it is governed by the same principle,
and so is *its* identity type, and so on up the whole ∞-groupoid. There is no
level of bare haecceity anywhere in the tower. That is **śūnyatā-śūnyatā** —
emptiness is empty — and I named it as the missing piece when it is exactly
the thing homotopy type theory has that almost no other foundation does. The
"positive remainder" does not exist; it is empty at the next level, without
end.

## 2. The identifying equivalence, stated

> **A type has no own-being; its identity is exhausted by its equivalences.
> Univalence is the formal statement of this, and — in the cubical setting —
> the *computational* one.**

`ua : (A ≃ B) → (A ≡ B)` and its inverse make identity and equivalence the
same type. Read as philosophy: there is no fact of a type's identity over and
above how it relates and functions. A type is nothing but its place in the
net (niḥsvabhāva; Indra's net = the univalent universe). This is not a
decorative alias for `univalence`; it is the claim that the *content* of
niḥsvabhāva — no intrinsic identity, identity as relation, and the emptiness
of that relation in turn — is what univalence asserts.

## 3. The audit: is anything missing?

| what śūnyatā claims | univalence / cubical | verdict |
|---|---|---|
| no own-being of entities | a type's identity = its equivalences | present |
| **emptiness of emptiness** (śūnyatā-śūnyatā) | the identity type is itself univalent; no floor in the ∞-groupoid | present — the piece the old note missed |
| **two truths** (saṃvṛti / paramārtha), and MMK 24.10: the ultimate is reached only through the conventional | computation (terms reduce, types are used) is the conventional; univalence (no own-identity) is the ultimate; **cubical transport actually reduces**, so the ultimate is reached *through* the conventional | present, and strong — this is what cubical adds over book HoTT |
| pratītyasamutpāda (dependent arising) | Σ/Π dependence; nothing stands alone; the universe is a web | present on the identity side; the causal/temporal nidāna dimension is outside the formal frame (§4) |

On the identity-structure, **nothing is missing that I can find.** The
correspondence is faithful, including the recursion and the two-truths reading,
and the last is a genuine yield: *cubical transport is the non-difference of
the two truths made to run.* That is the reason to prefer cubical Agda
specifically — you can compute on the whole empty structure.

## 4. Where to interrogate hardest before declaring it airtight

Two honest pressure points, named so the identification is not asserted
prematurely (the discipline of `APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md`):

1. **Does univalence-as-axiom grant *equivalence itself* a svabhāva?** If `≃`
   were treated as a bare positive primitive, the whole thing would smuggle in
   an own-being at one remove. **Discharged in checked terms**
   (`formal/cubical/NaturalMachine/EquivalenceHasNoFloor.agda`): an
   equivalence's identity is fixed by its underlying function alone
   (`equivEq`); "being an equivalence" is a proposition, so it carries no data
   to own (`isPropIsEquiv`); a function's identity is exhausted by its
   pointwise action (`funExt`). Chase the tower down — equivalence → function →
   action → identity of the output points — and it bottoms out at a Path,
   which is a *relation*, not an entity. The substrate's floor is the interval
   / Path, i.e. dependence itself, not any thing with svabhāva. **One residual
   frontier remains:** whether the interval-primitive `I` is itself a residual
   own-being — the exact formal echo of the deepest Madhyamaka question, *is
   pratītyasamutpāda itself empty?* (the Dzogchen *gzhi*, the ground). That the
   ground of the substrate is *relation and not entity* is the strongest form
   the answer can take inside the system; whether the relation-primitive is in
   turn empty is not statable as a term of the system it grounds.
2. **Soteriological scope.** Emptiness is asserted of the self (anātman), of
   dukkha, of time, *for liberation*. Univalence is emptiness of *types*.
   Whether that is "missing" or "the formalizable shadow of the whole" turns
   on whether all of experience is a type — the one genuinely open
   metaphysical edge, and precisely where Madhyamaka and Yogācāra dispute.
   This is a boundary, not (I think) a defect in the identity-claim.

## 5. What still stands from the original refutation — separate, real errors

Two criticisms of the modules were **not** about the univalence↔śūnyatā
identity and remain correct:

- **`CatuskotiPerspective` conflates two opposed schools.** Buddhist
  *catuṣkoṭi* (Madhyamaka, niḥsvabhāva) and Jain *anekāntavāda*
  (anekānta-*svabhāva*, a real many-natured object) are opposed positions that
  refute each other. One file cannot be both.
- **It domesticates Nāgārjuna's prasajya negation into a consistent semantics**
  (`both-is-consistent`). Whether the catuṣkoṭi is *prasajya-pratiṣedha*
  (commitmentless, non-implicative negation — leaving no positive thesis) or
  *paryudāsa* (implicative negation — which a consistent four-valued model
  would require) is a distinction native to the Sanskrit grammatical and
  Naiyāyika tradition, and the dispute over Nāgārjuna's method is the
  tradition's own — Prāsaṅgika (Candrakīrti, *Prasannapadā*) against
  Svātantrika (Bhāviveka). Nāgārjuna's own *Vigrahavyāvartanī* 29 (*nāsti ca
  mama pratijñā*, "I have no thesis") anchors the prasajya reading. Assigning
  the tetralemma a consistent truth-functional model gives it the very
  *pakṣa* it withholds; the presheaf facts type-check, but the Sanskrit
  reading is a live question settled inside the tradition, not by the file.

These stand because they concern *which* tradition and *which* reading, not
whether univalence formalizes emptiness. `PratityasamutpadaArising`'s
`Bool`-split remains a thin model of dependent arising (the identity content is
fine; the causal/soteriological content is not in it).

## 6. Rigor boundary and untranslated residual

**Argued as philosophy, not proved:** the §2–§3 correspondence. It is a
structural reading, in the spirit of `ABHAVA.md` §A2 ("the slot does the same
work, not that they are the same theory") — here the stronger claim is that
the *content* matches, with §4 naming where to test it.

**Primary sources — the tradition's own texts, cited directly (canonical
chapter.verse, edition-stable):** Nāgārjuna, *Mūlamadhyamakakārikā* — 24.18
(pratītyasamutpāda = śūnyatā = madhyamā pratipat), 24.10 (the ultimate is
taught only through the conventional), 13.8 (emptiness-as-*view* is the
incurable error — it warns against *clinging to emptiness as a thing*, which
asserting univalence-as-structural-principle need not do), 18.8 (tetralemma);
*Vigrahavyāvartanī* 29 (no-thesis). Commentary within the tradition:
Candrakīrti, *Prasannapadā* (the Prāsaṅgika reading of the negation). These
are the sources; no intermediary is enthroned as the authority on them.

**Prior art (SEARCH obligation, from in-repo record):** the cubical-type-theory
formalization lineage for Navya-Nyāya — Ganeri, Bhattacharyya, and
Panday–Ghosh *Cubical Type Theoretic Navya-Nyāya* (arXiv:2605.12548), located
in `ABHAVA.md` §A6, i.e. scholars of the tradition working in this substrate.
Whether anyone has argued *univalence ≈ śūnyatā* specifically is unsearched
and is an open obligation.

**Untranslated:** the soteriological totality — that these are analyses *for
liberation from dukkha*, not semantics; anātman; the two-truths debate about
whether the ultimate is statable at all; the Jain jīva/karma/kevala-jñāna; the
Dzogchen ground (gzhi) and self-liberation. The unconditioned (asaṃskṛta,
rigpa) still marks a boundary: every term in this substrate is saṃskṛta
(constructed), so the unconditioned is not a term here — but this is a claim
about the *substrate's* limit, and does **not** bear against univalence being
emptiness-of-identity within it.

## The one line

Univalence is niḥsvabhāva made to compute: identity has no own-being over
equivalence, that emptiness is itself empty up the whole tower, and cubical
transport is the two truths — conventional computation and ultimate
emptiness — running as one operation. The place my earlier note called a
defect was the place the correspondence is deepest.
