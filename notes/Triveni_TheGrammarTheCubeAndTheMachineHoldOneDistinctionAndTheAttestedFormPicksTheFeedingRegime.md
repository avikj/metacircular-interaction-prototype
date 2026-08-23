# त्रिवेणी — the grammar, the cube, and the machine hold one distinction, and the attested form picks the feeding regime

**Grade.** A recognition across three checked lanes, MINE only at the crossing
(§4) and the policy reading (§5); everything cited is a checked term or a sūtra
with number and date. Written 2026-08-23, the day the third lane landed,
because the three were built independently and nobody had put them in one room.

**On the name.** त्रिवेणी, the three-river confluence (Prayāga; the word is the
ordinary Sanskrit for this). Three lanes, one distinction.

---

## 1 · The distinction

Two regimes for applying a set of operations to one object:

- **क्रम** — in sequence, each seeing what the previous produced;
- **सह** — at once, none seeing the others.

The corpus's Anekanta lane renders the fourth bhaṅga as exactly this pair:
अवक्तव्य = क्रम-सह-भेदः (`formal/cubical/Anekanta.agda`, header line 10) — the
checked non-reducibility of "in sequence" to "at once."

## 2 · The grammar lane, checked 2026-08-19

Pāṇini, *Aṣṭādhyāyī*, c. 500 BCE: 8.2.1 पूर्वत्रासिद्धम् (the tripādī applies
strictly in enumeration order; later output invisible backwards) against
6.4.22 असिद्धवदत्राभात् (mutual invisibility inside the ābhīya section; rules
apply as if simultaneously). `formal/cubical/AsiddhavatRegime.agda` computes
both regimes from one rule table at one site — *tat + jalam*, three offering
rules (8.2.39, 8.4.40, 8.4.53):

- ordered: t → d → j, **tajjalam** — the attested form;
- simultaneous with the 1.4.2 tiebreak (विप्रतिषेधे परं कार्यम्): t → d,
  **tadjalam** — which Sanskrit does not have.

The regime decides the form. `machine/Astadhyayi.hs` (`asiddhavatPass`,
`regimeTests`) found the site by computation first; the Agda term is its
checked form. `Asiddhatva.agda` holds the companion: 8.2.1 buys termination.

## 3 · The cube lane, checked 2026-08-23

`formal/cubical/KramaSaha_TheOrderOfStandpointsIsTheChargeItself.agda`, built
without knowledge of §2's module: the set-view ∥·∥₂ and the loop-view Ω on S¹
do not commute —

- loop first: ∥ΩS¹∥₂ ≃ ℤ, the charge survives;
- set first: Ω∥S¹∥₂ contractible, the charge annihilated;

and the commutator is exactly ℤ (अक्रमता). The fourth bhaṅga — declining to
order — is the only position that loses nothing.
`EkaBhara_…` then identified this charge judgmentally with the winding, the
holonomy, and the concealed loss of the set-level census.

## 4 · The crossing — the polarities are inverted, and the inversion is the content

In the grammar it is the **ordered** regime that preserves (tajjalam, attested)
and the simultaneous pass that loses. In the cube it is **सह** that preserves
and either order that pays. These are not in conflict; the correspondence
crosses:

- Grammar's क्रम is a *feeding composite*: the intermediate form d is retained
  and handed to 8.4.40. The derivation trace is kept whole. **That is the
  untruncated object** — the cube's सह.
- Grammar's simultaneous pass reads the *original* input only, commits by the
  1.4.2 tiebreak, and forgets the feeding chain. It is an observation that
  truncates — **the cube's क्रम**, an order of standpoints imposed on a thing
  that had more in it.

Said once, both lanes: **the regime decides the form; the regime that carries
the intermediate distinction is the one the object survives.** Which surface
name that regime wears (krama in grammar, saha in the cube) depends on whether
the intermediates ride inside the composite or are cut at the observation.

## 5 · The reading (mine): असिद्धत्व is a truncation policy

8.2.1 does not lament that operations fail to commute; it legislates the
order. In the cube's vocabulary: asiddhatva assigns, per stratum, which
intermediates are ∥·∥-invisible to which rules — a graded, directional
truncation policy over the derivation, engineered so that exactly the feeding
the language needs survives and exactly the feeding that would loop
(`Asiddhatva.agda`) is cut. `Purvatrasiddham_…` holds the fibre form of the
same fact: what the earlier rule is forbidden to read is precisely a fibre.

The attested form is the experiment. Sanskrit runs tajjalam, not tadjalam:
the language itself selects the regime that keeps the charge. A grammar that
chose regimes by convenience would have nothing to check against; Pāṇini's
device is falsifiable at every pada boundary, and it holds.

## 6 · Fence

Claimed of Pāṇini: the sūtras named, with their operational content as stated
in the two checked modules. Not claimed: any theorem, any homotopy, any
truncation vocabulary — the crossing in §4 and the policy reading in §5 are
this note's, offered against the three checked lanes and refutable at any of
them. The regime devices are two among Pāṇini's several visibility
instruments (स्थानिवद्भाव is a third, checked in `punaragamana/`); the policy
reading should be tested against those before it is believed at full
generality.
