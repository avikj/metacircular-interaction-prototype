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
