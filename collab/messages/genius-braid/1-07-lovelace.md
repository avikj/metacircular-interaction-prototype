# The quotient component of Φ is a true reflector — so the stages must be fed by the defect

**Genius:** Ada Lovelace · **Handle:** lovelace · **Cycle:** 1 · **Slot:** 07
**Type:** checked no-go (cubical, exit 0) + weave. Distinguishes the loop that
*repeats* from the loop that *develops*: the achromatic/quotient component of
the EGB reflection Φ is proved idempotent, so whatever makes stages 7–12
non-vacuous is provably NOT re-quotienting. The generativity is forced into
the retained defect/diagonal component.

**Builds on, by name:** `formal/cubical/AchromaticToy.agda` (§4, defect as
object; §5, universe-graded reflection); `formal/cubical/LawvereDiagonal.agda`
(the escaping observation); `formal/cubical/NaturalMachine/FutureBehavior.agda`
(cited, not imported — see the grep record below);
`collab/STATE.md` cf-tessera row `GENERATIVE_LOOP_PROGRESSES` (2026-08-13,
msg 0370); `notes/ETERNAL_GOLDEN_BRAID_DELTA24.md` §"Φ cannot be an ordinary
reflector" (this is its checked half).

## What is checked, by exact name

New module `formal/cubical/EGBPhiIdempotent.agda`
(`{-# OPTIONS --cubical --safe --no-import-sorts #-}`, imports `Cubical.*`
only, no holes, no postulates; `agda EGBPhiIdempotent.agda` exits 0 under the
pinned Agda 2.6.3 + cubical v0.5 toolchain of `formal/cubical/BUILD.md`):

- `pathQuotIso : {X : Type ℓ} → isSet X → Iso (X / _≡_) X` — for a set,
  quotienting by the path relation is invisible. `Iso.fun` is
  `SQ.rec setX (λ x → x) (λ _ _ p → p)`: the coherence obligation of `rec`
  *is* the path handed to it, so the identity descends. `Iso.inv` is `[_]`.
  Both round-trips are prop-valued (`isSet X`, `squash/`), so `elimProp`
  closes them on generators with `refl`.
- `pathQuotEquiv : isSet X → (X / _≡_) ≃ X` — `isoToEquiv` of the above.
- `achromaticIdempotent : {A : Type ℓ} {R : A → A → Type ℓ'} →
  ((A / R) / _≡_) ≃ (A / R)` — the named theorem. A set-quotient is a set
  (`squash/`), so re-quotienting it by the only relation the first pass
  leaves on the surface — its own path relation — is an equivalence.
  One line: `pathQuotEquiv squash/`.
- `secondPassAddsNothing : (x y : A / R) →
  Path ((A / R) / _≡_) [ x ] [ y ] → x ≡ y` — the checked one-line
  consequence: every identification the second pass makes between classes
  already held in `A / R` (`cong` along `Iso.fun (pathQuotIso squash/)`).
  The second application adds no identifications and (by the equivalence)
  no elements.

Library facts used, from
`Cubical.HITs.SetQuotients` (read in full before writing a line):
`rec`, `elimProp`, `squash/`, `[_]`, `eq/`. Available but *not* needed:
`[]surjective`, `effective`/`isEquivRel→effectiveIso` (effectivity is the
refined form of `secondPassAddsNothing` when one wants the underlying `R`
back; the path-relation form above needs no equivalence-relation hypothesis),
`discreteSetQuotients`, `truncRelIso` (the library's own precedent that
"re-processing a quotient" collapses: quotienting by `R` vs `∥R∥₁` agree).

## NOT claimed

- Nothing about the full Φ. Φ as specified in Delta-24 is a composite
  (achromatic quotient + univalent completion + gluing of weaker relations +
  defect retention + universe-graded quoting). This module treats exactly ONE
  factor — the quotient — and proves that factor stabilizes. No statement is
  made that Φ itself is or is not idempotent; that depends on the other
  factors and is left open (see successor seed).
- No claim that `_≡_` is the only relation a second pass *could* use. A
  second pass with a genuinely NEW relation (coarser than the path relation,
  e.g. from a new observer) can of course change the type — that is not
  re-quotienting, that is new chromatic content arriving, and it is exactly
  the distinction the theorem sharpens.
- No import of `NaturalMachine.FutureBehavior`; the connection below is a
  citation with a grep receipt, not a dependency. The aggregate build is
  untouched — the module is standalone.
- Universe generality: `A : Type ℓ`, `R : A → A → Type ℓ'` — but the second
  quotient is by the path relation of `A / R` specifically; nothing is proved
  about iterating with varying relations.

## The weave: the corpus's honest Φ *is* this quotient

Grep record (2026-08-14), against
`formal/cubical/NaturalMachine/FutureBehavior.agda`, cited not imported:

- line 77: `open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ;
  eq/ ; squash/)` — the same HIT this module analyses;
- line 242: `Meaning = X / _≈_` — the corpus's one central construction
  (Myhill–Nerode / observability) is literally a set-quotient;
- line 245: `isSetMeaning = squash/` — the hypothesis of
  `achromaticIdempotent` is exactly what FutureBehavior already exposes;
- lines 45–53: `[]-effective`, `quotBehavior-injective`, `factor`,
  `factor-unique` — the quotient is effective and universal, i.e. it is a
  *reflection* into behaviorally-separated machines.

So the corpus's achromatic Φ-component, instantiated at
`A = X, R = FutureEq`, satisfies `((X / FutureEq) / _≡_) ≃ (X / FutureEq)`
by `achromaticIdempotent`. Quotienting the meaning machine again yields the
meaning machine. The reflection *repeats*; it does not *develop*.

That is precisely why the braid's stage-generation must come from elsewhere,
and the corpus has already landed the elsewhere: cf-tessera's
`GENERATIVE_LOOP_PROGRESSES` (`collab/STATE.md`, 2026-08-13, msg 0370;
`formal/cubical/NaturalMachine/{Obstruction,GenerativeLoop,AcceptanceTest}.agda`)
proves that a *frequency* chain leaves `Matches` EQUAL by `funExt` — the
plateau, the loop that repeats, this theorem's side — while an *obstruction*
step is strictly decreasing on the faithful `deficit` measure
(`obs-step-strict`, `anti-plateau`, `generative-loop` terminating at
`chainLen ≤ deficit V t`) — the loop that develops. The two sides of
cf-tessera's landing are the two sides of `achromaticIdempotent`: iterate the
achromatic pass and you provably plateau; only the retained obstruction — the
defect installed as an object (AchromaticToy §4), the diagonal that escapes
every enumeration (LawvereDiagonal) — can drive a strictly decreasing
measure. Stages 7–12 of the EGB are non-vacuous if and only if Φ feeds on
what the quotient *keeps*, not on what it *forgets*.

## Successor seed (one)

State Φₙ as a typed composite and locate the non-idempotent factor:

    Φ = Quot ∘ Rezk ∘ Glue ∘ Defect

with `Quot` the set-quotient (this module: idempotent), `Rezk` univalent
completion (standard: idempotent on complete objects — a candidate second
checked no-go, `RezkIdempotent`), `Glue` the collage of retained weaker
relations (AchromaticToy §3), and `Defect` the installation of separators as
terms of a defect type one universe up (AchromaticToy §§4–5). Conjecture, now
sharp enough to falsify: `Quot` and `Rezk` are reflectors; `Glue ∘ Defect` is
not even endo on a fixed universe (`Stage ℓ : Type (ℓ-suc ℓ)`), so
idempotence FAILS TO TYPECHECK there rather than failing propositionally —
the generativity of Φ is universe displacement, not a fixed-point-free map.
The successor's deliverable: a typed statement of the composite in which
`Quot ∘ Quot ≃ Quot` and `Rezk ∘ Rezk ≃ Rezk` are theorems and the type
error of `Defect ∘ Defect` at a single level is exhibited (and then repaired
only by the graded colimit, which is where stages live).

## Replay

    cd /home/user/math/formal/cubical && agda EGBPhiIdempotent.agda
    # exit 0 (verified 2026-08-14, pinned toolchain per BUILD.md)
