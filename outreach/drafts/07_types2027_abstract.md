# Draft 7 — TYPES 2027 abstract (Udine, 7–11 June 2027; abstracts due ~19 Feb 2027 — verify when the CFP posts)

Format: 2 pages excluding references (prior editions; check the CFP).
Title and authors on the abstract. Post-proceedings are LIPIcs, optional.
This is objects A + C from the plan: the smallest exact things.

---

## A reversible rewriting kernel whose evaluator is route-blind, and univalence executed on a monoid structure, in Cubical Agda

**[Author]**, [affiliation or "independent, Berkeley"]

We report a small machine-checked development (Agda 2.8.0, agda/cubical
v0.9, `--cubical --safe` throughout, no postulates) with two results we
believe are of interest to this community for their *shape* rather than
their difficulty.

**1. A kernel of 296 lines.** `RewriteCertificate` defines terms over
`{var, zero, suc, add}` with six named coordinates, an evaluator
`eval : Tm → Env → ℕ`, and a type `Step a b` of rewrite steps that includes
a `reverse` constructor. Consequently `Derivation a b` (lists of steps) is
a groupoid presented as data rather than a reduction relation: what a
derivation *is* is kept, and the direction of rewriting is not privileged.
`derivation-sound : Derivation a b → (ρ : Env) → eval a ρ ≡ eval b ρ`
is the soundness theorem, and `InductionCertificate` extends it to
schematic identities with an induction hypothesis (`induction-sound`).
`GenerativeKernel` closes the loop with `install : Derivation lhs rhs →
NativeOperation`: a derived identity becomes an operation the kernel can
apply, and every operation that exists is sound by construction.

The observation we want to isolate is one line long. Because ℕ is a set,
```
forgetful-is-blind-to-route : (d e : Derivation a b) (ρ : Env)
  → derivation-sound d ρ ≡ derivation-sound e ρ
forgetful-is-blind-to-route d e ρ = isSetℕ _ _ (derivation-sound d ρ) (derivation-sound e ρ)
```
The evaluation semantics forgets the route entirely; the carried
derivation does not (`len` distinguishes a 2-step and a 4-step derivation
of the same identity, and `len (addTower n) ≡ suc n` exactly). The file
states in its header what this does not show: nothing about
step-count separations in an external measure. We include it because the
*placement* of the distinction — in the codomain's h-level — is, we think,
the correct one, and it is what makes the proof one line.

**2. Univalence computing on a structure.** As a worked example of the
structure identity principle in agda/cubical, we take base-*b* positional
words with ripple-carry addition (`Word`, `addw`, canonical words
`CanWord`), prove `CanWord-Monoid : Monoid`, obtain
`ℕ-Monoid≡CanWord-Monoid` by SIP from the evaluation equivalence, and
check that the structure path restricts to the carrier equivalence,
definitionally:
```
carrier-of-monoid-path : cong ⟨_⟩ ℕ-Monoid≡CanWord-Monoid ≡ ℕ≡CanWord
carrier-of-monoid-path = refl
```
Transport along the path *computes* by `uaβ`; the accompanying test
modules run it. We found this a clean teaching example and would like to
know whether a version belongs in the library.

**Context and what is not claimed.** These two modules are the base of a
larger development (a fibre-law-based notion of lossless machine step
with `isContr (Lossless uStep)`, coinductive interaction, and a port of the
cubical layer to an interaction-net runtime) which we mention only so the
reader knows why these particular statements were proved; nothing in this
abstract depends on it. All modules are `--safe`; the repository's
`check` script names its toolchain and refuses to report a verdict off
the pin. A CI job runs it on every push. [Tool disclosure, 3 lines, from
`drafts/05`.]

**References.** [HoTT book §4.8; Vezzosi–Mörtberg–Abel 2019 (Cubical
Agda); Cohen–Coquand–Huber–Mörtberg 2015 (CCHM); the SIP in agda/cubical
(Angiuli et al. 2021, "Internalizing representation independence with
univalence"); Bennett 1973 (reversible computation) for the `reverse`
constructor's lineage.]
