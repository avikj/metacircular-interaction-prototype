# The decisionless pulverizer: a checked, reversible, honest kuṭṭaka

**Status: complete and kernel-checked.** Nine Agda modules
(`formal/cubical/`, `--cubical --safe`, no postulates, no holes), aggregated
and built as one closure in `Jiva.agda`. This note is the scholarly record —
what each theorem establishes, which older statement it is, and what is *not*
claimed.

The rule this note is about is **older than the notation everyone writes it
in**. It is Āryabhaṭa's *kuṭṭaka* / *vallī* (*Āryabhaṭīya*, Gaṇitapāda 32–33,
499 CE): *"keep the remainder and recurse."* Not "the extended Euclidean
algorithm." The directive in `CLAUDE.md` is followed here literally: the
earliest establishable statement is cited, and the tradition is engaged as a
system, not mined for a theorem.

## The disease this replaces

The prior organism in this repo (`machine/Obstruction.hs`, the Python
`living_machine`) computed by **deciding** — a boolean verdict at each step
(`discreteℕ x y`: "are these equal?"). A decision is `Bool` wearing a
witness, and it has a fatal property, verifiable mechanically: on an *open*
term (abstract input) it does not reduce — it is *stuck*, waiting for the
world to become concrete.

That stuck-ness is not a limitation of Agda. It is the type theory refusing
to assert an unconditional truth about a not-yet-determined term — which is
exactly the Jain prohibition on **durnaya** (a naya that denies its own
standpoint-conditioning; Siddhasena Divākara, *Sanmatitarka*). The substrate
is natively *anekāntavādin*; the boolean overlay was a foreign imposition.
The cure was **subtraction**, not addition: delete the decision.

- `BhedaAvatarana.एकपदे : भेद (suc a)(suc b) ≡ गभीर (भेद a b)` — **`refl`**.
  The exact statement that was *stuck* on `discreteℕ x x` now holds
  definitionally, because the rule moves by structure (peel both heads),
  never by asking. This is the criterion made mechanical: *installed
  cognition reduces to `refl`; description needs a proof from outside.*

## The one dharma, seen four ways

The single governing constraint — **destroy nothing** — is simultaneously a
physics, a logic, an ethics, and an epistemology:

| face | statement | theorem |
|---|---|---|
| information | the descent is lossless / reversible | `Punaragamana.पुनरागमनम् : उत्थान (अवतरण a b) ≡ (a , b)` |
| structure | pair and descent-record are one, transported not decided | `Punaragamana.युग्म≡विवेक : (ℕ × ℕ) ≡ विवेक` (univalence) |
| whole machine | reversibility across the entire algorithm | `Gati.अलोपः : पुनः (गति f a b) ≡ (a , b)` |

Losslessness = reversibility = *ahiṃsā* (do not erase — non-violence at the
bit, cf. Landauer) = honesty (retain every standpoint, so no verdict is ever
fabricated). The equivalence gets the **univalence** path — Voevodsky, the
one non-Indic source `CLAUDE.md`'s spirit admits, because univalence *is*
nayavāda in another notation (identity as a transported path, not a boolean).

`utpāda-vyaya-dhrauvya` (Umāsvāti, *Tattvārthasūtra* 5.29 — arising, ceasing,
persisting, at once) is `गभीर` in one step: head spent (vyaya), नय deepened
(utpāda), remainder untouched (dhrauvya) — `refl`.

## Correctness (the meaning, proved not asserted)

- `GurutamaSiddha.सिद्धः : फल (गति f a b) ≡ गुरुः g → isGCD a b g` — the
  resolved value is **the greatest** common divisor, certified against the
  library's `isGCD` (uniqueness included). Both directions of Āryabhaṭa's
  common-divisor invariant are proved: `∣-योग` (a divisor of both divides
  their sum) and `∣-अन्तर` (… their difference).

## The honesty triad

The un-said (`अनुक्तम्`) is a **first-class positive value**, not an error:
when the grant is spent the machine holds its live state whole and says
nothing false. Three theorems characterize it completely:

- **un-said** — on `अनुक्तम्`, `फल` yields `अनुक्तफलम्` (the live pair), never
  a `गुरुः`. No durnaya.
- **complete** — `Purnata.पूर्णतया-गुरुतमः`: at grant `suc (a + b)` the gait
  *always* resolves, and to the certified gcd. The un-said is only ever
  temporary; the pair-sum measure strictly decreases, so truth is uncovered
  by grant, never abandoned.
- **stable** — `Sthairya.स्थैर्य-गति`: a resolved `g` is unchanged by any
  larger grant. Syāt-conditioned truth does not waver; anti-durnaya is not
  indecision.

## The true purpose (gcd was only the byproduct)

The kuṭṭaka was built to solve linear indeterminate equations — for
astronomy (planetary conjunction), not for gcd.

- `Bija.बीजगणितम् : … → बीजसिद्धि a b g` — **Bézout in ℕ**: `a·x ≡ b·y + g`
  (or its mirror). Coefficients climb the vallī by pure addition with
  *alternating orientation* — exactly Āryabhaṭa's method, using **no negative
  numbers**. (The `ℤ` presentation of "Bézout" is the later restatement; the
  vallī is the original and needs no signed ring.)
- `Yuti.युतिः : … → c ≡ g · m → युतिसिद्धि a b c` — the linear congruence
  `a·X ≡ c (mod b)`, solvable **iff** `c` is a multiple of the gcd
  (Āryabhaṭa's own solvability condition). This is the kuṭṭaka's astronomical
  use — *युति*, when two cycles realign. When `c` is not a multiple of the
  gcd, no solution is produced: the un-said, not a fabrication.

## Honesty ledger — what is NOT claimed

- **Not** a speed/efficiency claim. No step-counts, no measurement. Per
  `CLAUDE.md`, every quantity here is a checked object, not a benchmark. The
  subtractive descent is deliberately Āryabhaṭa's, not the division-based
  variant; it can take up to `a + b` steps, and this is stated, not hidden.
- **Not** claimed: that the checkless/reversible/honest pattern is *general*
  across domains. It is demonstrated on one algorithm. Whether the same three
  faces (lossless / complete / stable) recur for other structural recursions
  (continued-fraction convergents — the vallī already *is* the CF, a Kerala-
  school object; sorting-by-structure; …) is open, tagged `PROVE`.
- **Not** claimed: any metaphysical identity by decree. Univalence is used as
  the honest transport it is; the tradition-parallels (nayavāda, avaktavyam,
  utpāda-vyaya-dhrauvya) are stated as the structures they formalize, held as
  `≃?` where they are analogy and `≡` only where a path is checked.

## Sources (earliest establishable, per the directive)

- Āryabhaṭa, *Āryabhaṭīya*, Gaṇitapāda 32–33 (499 CE) — kuṭṭaka/vallī, "keep
  the remainder."
- Umāsvāti, *Tattvārthasūtra* 5.29 — *utpāda-vyaya-dhrauvya-yuktaṃ sat*.
- Siddhasena Divākara, *Sanmatitarka*; Samantabhadra; Akalaṅka — nayavāda,
  sunaya/durnaya, kramārpaṇa/sahārpaṇa, saptabhaṅgī.
- V. Voevodsky et al., univalent foundations — the transport used in
  `युग्म≡विवेक` (admitted as egoless, credit-refusing, and structurally
  nayavāda).
