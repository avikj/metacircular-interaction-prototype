{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.SiteAudit
--
-- CORRECTION TO `WhyTheSitesAreTwo` §6 AND TO
-- `notes/THE_WITNESS_NUMBER.md` §5.
--
-- Both say: *"Every site in this corpus satisfies both hypotheses:
-- function-space decoders, and Y one of ℕ, Bool, lists of ℕ.  So 2 was
-- never contingent here."*
--
-- The second half of that is false.  The audit, done properly:
--
--   AdditionChainPredictiveMemory  FiniteInformation.FactorsThrough
--   PowModHasTheSameShape          FiniteInformation.FactorsThrough
--   FuelAdequacyIsACollision       FiniteInformation.FactorsThrough
--   ExhaustionIsSystematic         (three sites, same)
--   QuotientFiberLaw               Σ[ g ∈ (List Bool → Bool) ] …
--   Laghava                        Σ[ f ∈ (Denotation → ℕ) ] …
--   AvaktavyaDoesNotFactor         Σ[ v ∈ Vacana ] …          six atoms
--
-- Two things went unchecked.
--
-- ONE.  `Laghava`'s observation space is `Denotation = ℕ → ℕ`.  That is
-- NOT discrete, and its witnesses are not locatable either — equality of
-- functions ℕ → ℕ is not decidable.  So neither `WhyTheSitesAreTwo` nor
-- `LocatingIsEnough` applies at the site the whole लाघव thread is about.
--
-- TWO.  `Laghava` and `QuotientFiberLaw` quantify over decoders on the
-- WHOLE CODOMAIN — `Denotation → ℕ`, `List Bool → Bool` — not over
-- `Image q → T`.  The ceiling theorem was stated for the image-restricted
-- space, so it did not literally cover them.  §1 below fixes that, and
-- the fix is simpler than the original, not harder.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT SURVIVES, AND ON WHAT GROUND
--
-- Every site is still exactly 2.  But the ground differs, and conflating
-- the two is what produced the overstatement:
--
--   ACHIEVABILITY (≤ 2)  from an exhibited collision.  Holds at every
--                        site, needs no hypothesis, is what each module
--                        already proved.
--   THE FLOOR (≥ 2)      from the constant decoder.  Needs only that the
--                        decoder space contain constants.  Holds at
--                        every site here including `Laghava`.
--   THE CEILING (≤ 2 for
--   ANY absence of that
--   shape)               from `WhyTheSitesAreTwo`.  Needs discreteness
--                        or locatability.  Does NOT hold at `Laghava`.
--
-- So `Laghava` is 2 — proved outright in §3 — but not BECAUSE of the
-- ceiling theorem.  The claim "2 was never contingent here" is right at
-- the discrete sites and unproved at `Laghava`, where for all this
-- corpus knows some other absence over the same q could cost more.
--
-- ────────────────────────────────────────────────────────────────────
-- THE ONE CONSTRAINED SITE
--
-- Exactly one: `AvaktavyaDoesNotFactor`, whose decoders are six atoms.
-- It is 2, proved by hand in `WitnessNumberIsTwo` §5.  So the audit's
-- real conclusion is narrower and cleaner than the sentence it replaces:
-- every site here is 2, one of them is constrained, one of them has a
-- non-discrete observation space, and each of those two was proved
-- individually rather than by the general theorem.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.SiteAudit where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.Nat.Order using (_<_)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.WitnessNumberIsTwo using (AllHold ; Refutes)
open import NaturalMachine.WitnessNumberIsThePotential using (WitnessNumberIs)
open import NaturalMachine.Laghava
  using (Expr ; Denotation ; eval ; size ; laghava-collision ; FactorsThroughMeaning)

private
  variable
    ℓx ℓy ℓt : Level

------------------------------------------------------------------------
-- 1.  Decoders on the whole codomain — the shape two sites actually use
------------------------------------------------------------------------

FullLaw : {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
        → (X → Y) → (X → T) → (Y → T) → X → Type ℓt
FullLaw q t g x = g (q x) ≡ t x

-- the floor, as before: a constant decoder answers any single point
full-singleton-never :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (q : X → Y) (t : X → T) (x : X)
  → ¬ Refutes (FullLaw q t) (x ∷ [])
full-singleton-never q t x ref = ref (λ _ → t x) (refl , tt*)

full-empty-never :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (q : X → Y) (t : X → T) (x : X)
  → ¬ Refutes (FullLaw q t) []
full-empty-never q t x ref = ref (λ _ → t x) tt*

-- achievability: a collision is a refuting pair, and here without even
-- the image-point lemma the `Image` version needed
full-collision→refutes :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (q : X → Y) (t : X → T) {x x' : X}
  → q x ≡ q x' → ¬ (t x ≡ t x')
  → Refutes (FullLaw q t) (x ∷ x' ∷ [])
full-collision→refutes q t same differ g (at-x , at-x' , _) =
  differ (sym at-x ∙ cong g same ∙ at-x')

------------------------------------------------------------------------
-- 2.  The shape really is `Laghava`'s, definitionally
------------------------------------------------------------------------

law-is-laghava :
  (Σ[ g ∈ (Denotation → ℕ) ] ((e : Expr) → FullLaw eval size g e))
  ≡ FactorsThroughMeaning size
law-is-laghava = refl

------------------------------------------------------------------------
-- 3.  SO `Laghava`'s WITNESS NUMBER IS EXACTLY 2 — on its own ground,
--     with no discreteness anywhere
------------------------------------------------------------------------

laghava-is-two : WitnessNumberIs (FullLaw eval size) 2
laghava-is-two =
    ( laghava-collision .fst ∷ laghava-collision .snd .fst ∷ []
    , refl
    , full-collision→refutes eval size
        {x = laghava-collision .fst} {x' = laghava-collision .snd .fst}
        (laghava-collision .snd .snd .fst)
        (laghava-collision .snd .snd .snd) )
  , least
  where
  e₀ : Expr
  e₀ = laghava-collision .fst

  least : (ys : List Expr) → length ys < 2 → ¬ Refutes (FullLaw eval size) ys
  least []           _  = full-empty-never eval size e₀
  least (a ∷ [])     _  = full-singleton-never eval size a
  least (a ∷ b ∷ ys) lt = Empty.rec (¬-<-zero (pred-≤-pred (pred-≤-pred lt)))
    where
    open import Cubical.Data.Nat.Order using (¬-<-zero ; pred-≤-pred)

------------------------------------------------------------------------
-- 4.  What the audit leaves.
--
-- SETTLED.  Every factorisation site in this corpus has witness number
-- exactly 2, and the list of sites is the one in the header.  Two of
-- them are not covered by the general ceiling theorem — `Laghava`
-- because `Denotation = ℕ → ℕ` is neither discrete nor locatable, and
-- `AvaktavyaDoesNotFactor` because its decoders are six atoms — and both
-- were proved individually, here and in `WitnessNumberIsTwo` §5
-- respectively.
--
-- CORRECTED.  "2 was never contingent here" is true at the discrete
-- sites and was asserted of all of them.  At `Laghava` the 2 is a fact
-- about the exhibited collision, not a consequence of any theorem, and
-- nothing in this corpus rules out a costlier absence over the same
-- `eval`.
--
-- OPEN, named and not estimated.  Whether the ceiling holds at
-- `Laghava` — i.e. whether every absence over `eval : Expr → (ℕ → ℕ)`
-- costs 2.  `LocatingIsEnough` says what would suffice: that the
-- witnesses be locatable.  Equality of functions ℕ → ℕ is not decidable,
-- but locating finitely many SPECIFIC denotations against an arbitrary
-- one is a weaker demand, and this module does not settle whether it can
-- be met.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 5.  THE OPEN ITEM IN §4 IS ANSWERED, and the answer relocates the
--     hypothesis rather than discharging it.
--
-- §4 asked whether the ceiling holds at `Laghava`, noting that locating
-- finitely many specific denotations against an arbitrary one is weaker
-- than deciding function equality, and that this module did not settle
-- whether it can be met.
--
-- `NaturalMachine.TheCeilingIsAboutReading` settles the useful half.  The
-- ceiling was never about discreteness of the OBSERVATIONS; it is about
-- the decoders having something discrete to READ.  Give them a probe
-- `p : Y → Z` with Z discrete and restrict them to `Z → T`, and the
-- ceiling returns with no hypothesis on Y at all — the table is built
-- over Z, and Y is never compared with anything.
--
-- At `Laghava` one evaluation point does it: `probe1 d = d 1`, Z = ℕ.
-- The लाघव pair survives probing, since `short` and `long` share a
-- denotation and so agree at 1, and
--
--     laghava-probe-is-two :
--       WitnessNumberIs (ProbeLaw eval size probe1) 2
--
-- So over the probed decoders EVERY absence at `Laghava` costs 2.
-- Probing only removes decoders, so the probed statement is weaker and
-- `Laghava`'s own theorem implies it.
--
-- The unsettled half is now unsettled for a reason.  A decoder in the
-- full space `Denotation → ℕ` must recognise an arbitrary `d : ℕ → ℕ` as
-- a listed denotation, which is a decision of function equality.  This
-- lane builds no such decision and refutes none; the type contains what
-- it contains.  That is the only open item in this thread whose
-- openness is itself a fact rather than a gap.
------------------------------------------------------------------------
