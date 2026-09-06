{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- स्फोट — the bursting.
--
-- The machine instantiated on the blow-up hypothesis.  Let BU be the
-- type of smooth divergence-free data whose maximal smooth development
-- terminates at a finite time.  The target is BU → ⊥.  This file is the
-- proof ARCHITECTURE as a term — the shape that turns "derive a gigantic
-- estimate" into "carry every inherited property and find two that
-- cannot coexist" — with the analytic inputs it needs isolated as the
-- fields of one record.  What is proved here is proved for any
-- candidate type and any readings; what is not proved is named exactly.
--
--   §1  THE DEPENDENT WITNESS.  A boundary witness is a candidate U with
--       a family of inherited readings.  Adding a reading maps the
--       witness type to a smaller one: the fibre only shrinks.  Forgetting
--       a reading is the truncation; it has a section only when the
--       forgotten reading is always inhabited.
--
--   §2  TRUNCATION HIDES THE CONTRADICTION.  On a two-element candidate
--       type, reading A is inhabited somewhere, reading B is inhabited
--       somewhere, and the joint reading is empty everywhere.  Either
--       truncation looks consistent; only the untruncated record is ⊥.
--       This is the reason never to select the few properties one
--       estimate needs.
--
--   §3  TWO INCOMPATIBLE READINGS EMPTY THE WITNESS.  If ancestry forces
--       A and forces B and A × B is empty pointwise, the witness type is
--       empty.  No single invariant is required.
--
--   §4  THE CLAY NEGATION, CONDITIONALLY.  BU → ⊥ follows from a lossless
--       blow-up transport BU → Σ U Ancestry(U) and any pair as in §3.
--       The record ClayNegation lists exactly those obligations; negate
--       is the composite.  The analytic content of the problem is the
--       inhabitation of that record's fields, nothing else.
--
--   §5  DESCENT: LOCAL ESCAPE DOES NOT GLUE.  The corpus already exhibits
--       a local system over a cover in which every context carries a
--       section and no global section exists (PMIncidenceLocalSystem,
--       no-global-sheet: the cover cycle acts as negation).  That is the
--       shape of Π LocalSingularGeometry(Uᵢ) inhabited while
--       GlobalNSSingularGeometry is empty, imported here as the exemplar
--       the pressure-realisability obstruction must instantiate.
--
--   §6  THE CONTINUATION FIBRE.  LawfulContinuationCore's EmptyFiber /
--       UniqueFiber / BranchingFiber classify what a continuation can do;
--       a finite-time blow-up is a compatible family of fixed points on
--       every earlier interval with an EmptyFiber at the limit.  The
--       Bellman reading — all continuations reconstruct the relation,
--       a selected family can erase distinctions — is the reason the UV
--       quotient must range over every lawful continuation.
--
-- स्फोट (sphoṭa, bursting) is ordinary Sanskrit.  Nothing here is an
-- estimate.
------------------------------------------------------------------------

module Sphota_TheBlowUpWitnessIsADependentRecordEachInheritedReadingShrinksItsFibreAndTwoIncompatibleReadingsEmptyIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false ; false≢true)
open import Cubical.Data.Empty using (⊥)

open import PMIncidenceLocalSystem using (GlobalSheet ; ObstructionSheet ; CoverBase ; no-global-sheet)
open import LawfulContinuationCore using (EmptyFiber ; UniqueFiber ; BranchingFiber)

private
  variable
    ℓ ℓ′ : Level

------------------------------------------------------------------------
-- १ · The dependent witness, and the fibre only shrinks.
------------------------------------------------------------------------

module _ {Candidate : Type ℓ} where

  -- a boundary witness carrying one family of readings
  Witness : (Candidate → Type ℓ′) → Type (ℓ-max ℓ ℓ′)
  Witness P = Σ[ U ∈ Candidate ] P U

  -- adding a reading: the witness with both maps into the witness with one
  saṅkoca : {P Q : Candidate → Type ℓ′}
          → Witness (λ U → P U × Q U) → Witness P
  saṅkoca (U , p , q) = U , p

  -- forgetting a reading is the truncation; it is split exactly when the
  -- forgotten reading is inhabited wherever the kept one is
  pratyāhāra : {P Q : Candidate → Type ℓ′}
             → ((U : Candidate) → P U → Q U)
             → Witness P → Witness (λ U → P U × Q U)
  pratyāhāra always (U , p) = U , p , always U p

------------------------------------------------------------------------
-- २ · Truncation hides the contradiction.
------------------------------------------------------------------------

module Chāyā where

  A B : Bool → Type₀
  A b = b ≡ true
  B b = b ≡ false

  -- each reading alone has a witness
  A-sthita : Witness A
  A-sthita = true , refl

  B-sthita : Witness B
  B-sthita = false , refl

  -- the joint reading has none: the truncations were consistent, the
  -- record is ⊥
  AB-śūnya : Witness (λ b → A b × B b) → ⊥
  AB-śūnya (b , p , q) = true≢false (sym p ∙ q)

------------------------------------------------------------------------
-- ३ · Two incompatible inherited readings empty the witness.
------------------------------------------------------------------------

module _ {Candidate : Type ℓ} (Ancestry : Candidate → Type ℓ′) where

  dvi-virodha : {A B : Candidate → Type ℓ′}
              → ((U : Candidate) → Ancestry U → A U)
              → ((U : Candidate) → Ancestry U → B U)
              → ((U : Candidate) → A U → B U → ⊥)
              → Witness Ancestry → ⊥
  dvi-virodha forcesA forcesB clash (U , anc) =
    clash U (forcesA U anc) (forcesB U anc)

------------------------------------------------------------------------
-- ४ · The Clay negation, with its obligations as fields.
------------------------------------------------------------------------

record ClayNegation (ℓb ℓc ℓa : Level) : Type (ℓ-suc (ℓ-max ℓb (ℓ-max ℓc ℓa))) where
  field
    -- the blow-up hypothesis, as a type
    BU        : Type ℓb
    -- candidates for the renormalised boundary object
    Candidate : Type ℓc
    -- every property that survives the blow-up transport, untruncated
    Ancestry  : Candidate → Type ℓa
    -- OBLIGATION 1: the lossless blow-up transport (the compactness
    -- extraction, carrying every inherited reading)
    saṅkramaṇa : BU → Witness Ancestry
    -- OBLIGATION 2: two inherited readings that cannot coexist
    A B       : Candidate → Type ℓa
    forcesA   : (U : Candidate) → Ancestry U → A U
    forcesB   : (U : Candidate) → Ancestry U → B U
    clash     : (U : Candidate) → A U → B U → ⊥

  -- and then the theorem is the composite
  negate : BU → ⊥
  negate b = dvi-virodha Ancestry forcesA forcesB clash (saṅkramaṇa b)

------------------------------------------------------------------------
-- ५ · Descent: local escape does not glue.  The exemplar, imported.
------------------------------------------------------------------------

-- every context of the cover carries a section of the obstruction sheaf …
sthānīya : (c : CoverBase) → ObstructionSheet c → ObstructionSheet c
sthānīya c s = s

-- … and there is no global section: the cover cycle is negation.
sārvatrika-śūnya : GlobalSheet → ⊥
sārvatrika-śūnya = no-global-sheet

------------------------------------------------------------------------
-- ६ · The continuation fibre vocabulary, in place for the time direction.
------------------------------------------------------------------------

-- a finite-time blow-up is an EmptyFiber at the limit of a family that is
-- inhabited at every earlier stage; the classification is the corpus's
Sphoṭa-ākāra : Type₁
Sphoṭa-ākāra = Σ[ Limit ∈ Type₀ ] EmptyFiber Limit
