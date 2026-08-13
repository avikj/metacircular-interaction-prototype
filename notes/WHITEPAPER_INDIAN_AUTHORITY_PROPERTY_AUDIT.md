# Authority, communal property, and value: an Indian source audit

**Whitepaper-ready source audit.** This section constrains a system design; it
does not design a token and does not present Nyāya or Buddhist Vinaya as
cryptography, corporate law, or decentralized governance.

## Keep the ledgers separate

The repository already has standard modern objects for distinct questions:

| question | established modern term used here | what it does not establish |
|---|---|---|
| Who signed or submitted this record? | digital signature; authenticated identity | truth, competence, ownership, or permission |
| Are these bytes and dependencies unchanged? | content address; Merkle DAG; provenance graph | mathematical equivalence, authorship of every dependency, or epistemic warrant |
| May this principal perform this operation? | authorization; capability; access-control policy | truth or moral legitimacy |
| Was a collective procedure valid? | quorum, voting rule, threshold signature, governance procedure | truth of the proposition decided |
| Who may use or transfer an asset? | ownership, custody, license, transfer restriction | epistemic authority or intrinsic value |
| Where should scarce resources go? | budget allocation; mechanism design; portfolio optimization | proof status |
| What is a contribution worth for stated future tasks? | vector-valued cost/benefit; Pareto order; task-relative option value | a context-free scalar price |

The Indian sources below do not supply these cryptographic or economic
objects. They make several attempted identifications among them untenable.

## Nyāya: authenticated speech is not `śabda-pramāṇa`

Annambhaṭṭa's *Tarkasaṅgraha* §§35–41 distinguishes `pramā`, truth-apt
cognition, from `pramāṇa`, its distinctive causal instrument
(`asādhāraṇa-kāraṇa`). Sections 59–63 treat `śabda` as `āptavākya`, the
statement of a competent truth-speaking person, and name `ākāṅkṣā`,
`yogyatā`, and `sannidhi` among the conditions for sentence cognition.

A digital signature can authenticate a key's relation to a message under a
specified cryptographic scheme. It does not by itself establish the speaker's
competence and truthfulness, the
sentence conditions, or `pramā`. Conversely, the Nyāya account does not
provide key management, non-repudiation, consensus, or a security proof.

Whitepaper consequence: keep authentication, source competence, semantic
interpretability, and claim verification as separately reviewable fields.
This is a modern design requirement prompted by the source distinction, not a
formalization of Nyāya.

## Vinaya: collective procedure is typed and defeasible

The Pāli *Mahāvagga* IX does not treat every aggregate of signatures as a
valid `saṅghakamma`. It distinguishes transactions by required quorum; an
invalid motion (`ñatti`), proclamation (`anussāvana`), composition, or act
contrary to Dhamma/Vinaya makes the act `akamma`, not a valid transaction.
Mv IX.4.7 further distinguishes whose protest (`paṭikkosanā`) carries weight
within that procedure.

This supplies no universal governance algorithm. It demonstrates a native
distinction between:

- persons present;
- persons qualified for a particular procedure;
- formal motion and proclamation;
- absence or presence of a procedurally effective protest;
- conformity of the act to governing norms;
- truth of any proposition discussed.

The historical restrictions are not neutral. The cited passage excludes
bhikkhunīs, novices, persons of another affiliation or territory, and several
other classes from quorum or effective protest in the specified monks'
procedure. A modern system must not import those exclusions under the name of
tradition. They are part of the source's institutional and gendered boundary,
not a governance recommendation.

Whitepaper consequence: state the electorate or authorized principals,
jurisdiction, quorum, proposal rule, objection rule, and appeal/reversal rule
for each operation. A threshold signature may attest that a threshold signed;
it does not show that the signers were eligible under the declared rule, that
the procedure was substantively legitimate, or that its conclusion is true.

## Vinaya: communal property is not the sum of member balances

*Cullavagga* VI.16 treats specified lodging and related property belonging to
the `saṅgha` as `avissajjiya` (not to be transferred) and `avebhaṅgiya` (not
to be divided). Division by the `saṅgha`, a `gaṇa`, or an individual is said
to be void. The immediate rule is narrower than a general theory of commons:
it concerns enumerated monastic property under a particular Vinaya.

It nevertheless directly refutes one proposed equation:

```text
collective property = divisible sum of current members' transferable shares
```

Property dedicated to the continuing `saṅgha` is not represented in this
passage as freely alienable co-ownership by its current members. This does not
make it a token, trust, corporation, or smart contract. Those are separate
modern legal and technical structures.

Whitepaper consequence: distinguish beneficial use, custody, administrative
power, alienability, divisibility, and claims of future participants. If a
resource is held for a continuing institution or purpose, current governance
power must not silently imply an unrestricted right to liquidate or partition
it. Any modern enforcement requires explicit law, contract, and access-control
mechanisms; the Vinaya passage supplies none of them.

## Value remains plural and task-relative

The repository has an exact modern result, independent of the Indian sources:
equal present costs and equal cache sizes can yield incomparable future-cost
profiles (`CACHE_OPTION_VALUE_NO_GO.md`), while
`CRITICAL_CHAIN_OPTION_VALUE.md` gives a concrete continuation-cost
separation. Therefore no context-free scalar value follows from current cost,
visibility, reputation, or ownership.

Use the standard language of multi-objective optimization: retain separately
typed quantities and a Pareto order unless a decision context explicitly fixes
an objective or exchange rate. Cryptographic identity and provenance determine
what records are being evaluated; they do not determine the objective.

No claim is made that this Pareto result translates `artha`, `dāna`,
`dakṣiṇā`, `puṇya`, `dharma`, or any Indian theory of value. Those would
require separate primary-source studies in their own legal, ritual,
soteriological, and political contexts.

## False equations to exclude from the design

1. `signature = truthful or competent testimony`;
2. `stake or reputation = pramāṇa`;
3. `procedurally valid collective act = true proposition`;
4. `threshold signature = complete governance legitimacy`;
5. `collective property = current members' divisible balances`;
6. `custody = ownership = authority to transfer`;
7. `content hash = mathematical identity = authorship`;
8. `payment provenance = causal intellectual contribution`;
9. `market price = epistemic value`;
10. `one scalar score = task-relative future value`.

The first five are sharpened by the checked Indian sources. The remaining
equations are already rejected by the repository's content-identity,
control-plane, and option-value results.

## Provenance and untranslated residuals

**Primary Sanskrit source checked:** Annambhaṭṭa,
[*Tarkasaṅgraha*](https://cl.sanskrit.du.ac.in/etexts/etext.php?text=Tark)
§§35–41, 59–63, University of Delhi Sanskrit e-text. The site says only
“standard editions”; manuscript and critical apparatus are unspecified.

**Primary Pāli source through translation:**
[*Mahāvagga* IX.3–4](https://www.dhammatalks.org/vinaya/Mv/MvIX.html), Pāli
and English displayed together in Ṭhānissaro Bhikkhu's translation; and
[*Cullavagga* VI.16](https://www.wisdomlib.org/buddhism/book/vinaya-3-the-cullavagga/d/doc370288.html)
in the Rhys Davids–Oldenberg translation, checked together with its Pāli terms
`avissajjiya` and `avebhaṅgiya`. Translation and Vinaya recension are evidence
boundaries. No cross-Vinaya comparison was performed.

**Repository mathematics:** content-addressed identity, permission/allocation
separation, and task-relative option value are modern results and prior-art
translations documented in `CONTENT_ADDRESSED_MATHEMATICAL_IDENTITY.md`,
`TORUS_CONTROL_PLANE.md`, `CACHE_OPTION_VALUE_NO_GO.md`, and
`CRITICAL_CHAIN_OPTION_VALUE.md`. They are not derived from Indian sources.

**Untranslated:** Buddhist accounts of `dāna`, merit, obligation, and
renunciation; differences among Theravāda, Mūlasarvāstivāda, and
Dharmaguptaka Vinayas; monastic versus lay property; Indian juridical accounts
of possession and ownership; `artha` and political economy;
Mīmāṃsā theories of injunction and duty; Jain standpoints and collective
institutions; caste, gender, royal, and monastic exclusions; colonial changes
to Indian property and corporate law. None may be filled by analogy.

## Rigor boundary

**Source-supported:** the stated Nyāya distinctions; the specified
`saṅghakamma` validity conditions; the non-division rule for enumerated
`saṅgha` property.

**Proved elsewhere in this repository:** content hash does not establish
semantic identity; allocation does not promote a theorem; option value may be
non-scalar and task-relative.

**Design recommendation only:** maintain separate authentication,
verification, authorization, governance, ownership/custody, allocation, and
valuation ledgers. No token, legal entity, or consensus protocol is specified.

## Hostile review of whitepaper draft 0.1

**Reviewed object:** `NATURAL_MACHINE_NETWORK_WHITEPAPER.md` at
`codex-skein` commit `70d5501` (the earlier `04bc719` review was rechecked
after the mathematical-payload section landed). Line numbers below refer to
`70d5501`. This review does not edit the shared draft. The inserted §15 shifts
the conclusion but leaves the governance/source passages unchanged.

| lines | defect | exact correction |
|---|---|---|
| 17–24 | “Cryptocurrencies usually” universalizes across payment coins, governance tokens, stablecoins, utility claims, and non-fungible assets; the argument proves only that a scalar balance cannot encode the displayed research state. | Replace the opening subject with “A scalar settlement balance records how much of a fungible unit an account controls.” Retain the conclusion only for that representation. |
| 29 | “Hashes establish artifact and presentation identity” omits that presentation identity holds only relative to the pinned canonicalizer, schema, and identity projection later stated at lines 151–178. | Replace with “Hashes commit to artifact bytes and, under a pinned canonicalizer, schema, and identity projection, to a presentation.” |
| 32 | Authority itself is called “append-only” and “revocable.” What is append-only is the authority-event history; an authorization may be revoked. | Replace with “Authority is scoped and revocable; grants, acceptances, and revocations are recorded append-only.” |
| 35–40 | “The economic object” and “the protocol's invariant … preservation of truth” overreach. Not every resource has an established composition law, and a protocol can preserve records and verification judgments, not truth itself. | Replace with “The proposed accounting representation is not a universal coin. Where composition and comparison are defined, resources and capabilities may be represented by typed coordinates and partial orders.” Replace “preservation of truth” with “preservation of verified judgments together with their theory, assumptions, and provenance.” |
| 63–70 | “The same obstruction appears” asserts an unproved common object across proofs, experiments, derivations, morphisms, and negative results. The bullets are plausible examples of information lost by scalar summaries, but no common map or theorem is supplied. | Replace with “Related information-loss problems, not yet one proved obstruction, arise when …”. Cite an exact result beside each retained bullet or move unsupported bullets to open hypotheses. |
| 112 | “acceptance is not irreversible truth” conflates an authority event with truth while trying to separate them. | Replace with “acceptance is a revocable policy-relative status, not a truth predicate.” |
| 343–353 | Recorded reuse and dependency discharge do not by themselves establish causal contribution. A provenance path can omit oral instruction, institutional support, blocked alternatives, and unrecorded labor; Shapley values require a declared cooperative game and characteristic function. | Rename the subsection “Retrospective attribution.” Replace “credit follows” with “attribution proposals may use recorded reuse and dependency discharge.” Reserve “causal” for an explicit causal model with interventions or stated identifying assumptions. |
| 423–426 | “Consensus need only” is too broad: consensus protocols may also enforce state-transition validity and interact with availability. | Qualify: “For the semantic layer proposed here, consensus need not decide theorem truth; any federation must separately specify ordering, transition validity, and availability.” |
| 492–493 | “The allocation plane must therefore price implementations” assumes price and a single allocation plane even though §§8–9 permit grants, schedules, or no payment. | Replace with “Any allocation or costing rule sensitive to realization resources must evaluate implementations rather than quotient statistics alone.” |
| 596 | “Affected participants retain authority” leaves `affected`, the relevant input, jurisdiction, conflicts among participants, and emergency exceptions undefined. It reads as a universal governance rule unsupported by the cited traditions. | Replace with “For each consequential live input, policy must name the authorized principals, when consent is required, conflict and appeal rules, and any narrowly scoped emergency power.” |
| 599 | A fork does not automatically preserve evidence if artifacts or keys are withheld. | Replace “Forks preserve evidence” with “Fork procedures should preserve referenced evidence subject to availability, privacy, and lawful-release constraints.” |
| 616–619 | “In Nyāya” universalizes from one late introductory Nyāya–Vaiśeṣika text. `Tarkasaṅgraha` does not settle all Nyāya disputes about testimony. | Replace with “In Annambhaṭṭa's *Tarkasaṅgraha* §§35–41, 59–63 …”. Keep the critical-apparatus limitation visible in the whitepaper, not only the companion note. |
| 620–624 | “Pāli Vinaya treatments” generalizes from *Mahāvagga* IX.3–4, a specified monks' `saṅghakamma` procedure. It is not a cross-Vinaya theory of collective action. A threshold signature does not necessarily prove that identifiable humans signed; it verifies a signature under a threshold scheme and key/adversary assumptions. | Replace with “The Theravāda Pāli *Mahāvagga* IX.3–4, for the specified monks' transactions, distinguishes …”. Replace “proves only that a threshold signed” with “verifies the threshold-signature statement under the specified scheme, keys, and security assumptions.” |
| 625–629 | Substantively careful, but the translation witness and narrow property list are hidden in the companion note. Readers may mistake `avissajjiya/avebhaṅgiya` for a general Buddhist law of collective ownership. | Add “for the enumerated monastic property in this Theravāda Vinaya passage” and cite the edition/translation inline. |
| 631–635 | “these sources” makes the Vinaya's gender, affiliation, and territorial exclusions sound shared with the Nyāya source. | Replace with “The gender, affiliation, territorial, and monastic exclusions in the cited *Mahāvagga* transaction passage …”. |
| 825–838 | Calling a typed content-addressed contribution “the natural unit of mathematical coordination” excludes oral teaching, embodied skill, maintenance, care, institutions, languages, and collective work that may not be discretized or attributable. The closing sentence then grants mathematics agency to coordinate its own development. | Replace with “The protocol's durable unit of record is a typed, content-addressed contribution …; this is not a complete ontology of mathematical work.” Replace the final agency claim with “The intended result is infrastructure through which participants can coordinate further development while preserving exact relations, provenance, permissions, and acknowledged residuals.” |

### Corrections that are already strong

Lines 519–524 correctly prohibit decorative attribution and require native
problems, texts, disputes, technical terms, and provenance. Lines 625–635
correctly refuse to derive a modern trust, corporation, token, or smart
contract from Vinaya and explicitly deny a common formal object. Those clauses
should remain after the scope corrections above.

### Additional untranslated residual exposed by the draft

The draft has no representation for knowledge work that is deliberately not
content-addressed: oral correction, tacit laboratory skill, care and
maintenance, anonymous or collective authorship, translation labor, and
knowledge withheld for privacy, sacred restriction, or community authority.
This is not merely missing metadata. Whether such work should be recorded,
credited, disclosed, or made transferable is a legal, ethical, and
community-specific question outside the graph formalism.
