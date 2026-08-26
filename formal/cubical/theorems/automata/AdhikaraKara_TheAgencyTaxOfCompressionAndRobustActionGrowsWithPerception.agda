{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अधिकारकरः — the agency tax of compression, and robust action grows
-- with perception.
--
-- TERM.  अधिकार as in अधिकारभङ्गः (capacity, the standing to act); कर —
-- tax, tribute, the levy a state exacts.  The compound अधिकार-कर, "the
-- tax on agency", is built here; no source is claimed for it.
--
-- SEED.  The owner's transmission of 2026-08-23 ("causal horizon
-- formation"), the section after the affordance theorem: the no-go
-- (अधिकारभङ्गः, landed) says no controller on the quotient can be
-- COMPLETE — but the richer distinction is between two action spaces
-- over an observed state:
--
--   Possible o  =  actions valid in SOME hidden state of o's fiber;
--   Robust o    =  actions valid in EVERY hidden state of o's fiber.
--
-- A controller that sees only o can safely choose from Robust o.  The
-- difference — possible but not robust — is THE AGENCY TAX OF
-- COMPRESSION.  And refining the sensorium shrinks fibers, so robust
-- affordances can only grow: better perception does not merely improve
-- prediction, it enlarges the set of actions takeable without
-- violating an unseen state.  That is the operational meaning of
-- organogenesis.
--
-- WHAT IS PROVED.
--
--   दृढ→सम्भव     robust actions are possible, over any inhabited fiber.
--   करसाक्षी      the tax is real: a two-state instance where the one
--                 action is possible and provably not robust.
--   इन्द्रिय-वृद्धिः  monotonicity: adjoining a receptor (S' = ⟨S , q⟩)
--                 only shrinks fibers, so every S-robust action remains
--                 S'-robust at the refined observation.  The proof is
--                 one projection — the refined fiber maps into the
--                 coarse fiber and robustness pulls back.
--
-- WHAT IS NOT CLAIMED.  No claim that the tax is ever forced positive
-- for a GIVEN task (a task may need only robust actions); करसाक्षी is
-- an existence witness, not a lower bound.  The n-step future families
-- (Future_n, the causal cone) and the coarsest-lawful-quotient
-- optimization are the transmission's next strata and are not touched.
------------------------------------------------------------------------

module AdhikaraKara_TheAgencyTaxOfCompressionAndRobustActionGrowsWithPerception where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.HITs.PropositionalTruncation using (∥_∥₁ ; ∣_∣₁)

private
  variable
    ℓ ℓ' ℓ'' ℓ''' : Level

------------------------------------------------------------------------
-- १ · the two action spaces over an observed state.
------------------------------------------------------------------------

module _ {X : Type ℓ} {O : Type ℓ'} {U : Type ℓ''}
         (S : X → O) (V : X → U → Type ℓ''') where

  तन्तुः : O → Type (ℓ-max ℓ ℓ')
  तन्तुः o = Σ[ x ∈ X ] S x ≡ o

  -- valid in SOME hidden state of the fiber (merely — the choice of
  -- hidden state is not data the controller may use).
  सम्भवः : O → Type (ℓ-max (ℓ-max ℓ ℓ') (ℓ-max ℓ'' ℓ'''))
  सम्भवः o = Σ[ a ∈ U ] ∥ Σ[ p ∈ तन्तुः o ] V (fst p) a ∥₁

  -- valid in EVERY hidden state of the fiber.
  दृढः : O → Type (ℓ-max (ℓ-max ℓ ℓ') (ℓ-max ℓ'' ℓ'''))
  दृढः o = Σ[ a ∈ U ] ((p : तन्तुः o) → V (fst p) a)

  -- robust ⟹ possible, over any inhabited fiber.
  दृढ→सम्भव : (o : O) → तन्तुः o → दृढः o → सम्भवः o
  दृढ→सम्भव o p₀ (a , all) = a , ∣ p₀ , all p₀ ∣₁

  -- a witness that an action is taxed: possible, and provably not
  -- robust.
  करः : (o : O) (a : U) → Type (ℓ-max (ℓ-max ℓ ℓ') ℓ''')
  करः o a = ∥ Σ[ p ∈ तन्तुः o ] V (fst p) a ∥₁
          × (¬ ((p : तन्तुः o) → V (fst p) a))

------------------------------------------------------------------------
-- २ · the tax is real: the smallest instance.  Two hidden states, one
-- observation, one action label — valid above, invalid below.
------------------------------------------------------------------------

private
  V₀ : Bool → Unit → Type
  V₀ true  _ = Unit
  V₀ false _ = ⊥

करसाक्षी : करः {X = Bool} {O = Unit} {U = Unit} (λ _ → tt) V₀ tt tt
करसाक्षी = ∣ (true , refl) , tt ∣₁
         , λ all → all (false , refl)

------------------------------------------------------------------------
-- ३ · robust action grows with perception.  Adjoin any receptor q; the
-- refined fiber projects onto the coarse fiber, so robustness pulls
-- back along the projection: every S-robust action is ⟨S,q⟩-robust.
------------------------------------------------------------------------

module _ {X : Type ℓ} {O : Type ℓ'} {U : Type ℓ''} {Q : Type ℓ'''}
         {ℓv : Level}
         (S : X → O) (q : X → Q) (V : X → U → Type ℓv) where

  संयुक्तम् : X → O × Q
  संयुक्तम् x = S x , q x

  -- the refined fiber maps into the coarse fiber.
  सङ्कोचः : (o : O) (q₀ : Q)
          → तन्तुः संयुक्तम् V (o , q₀) → तन्तुः S V o
  सङ्कोचः o q₀ (x , p) = x , cong fst p

  इन्द्रिय-वृद्धिः : (o : O) (q₀ : Q)
                → दृढः S V o → दृढः संयुक्तम् V (o , q₀)
  इन्द्रिय-वृद्धिः o q₀ (a , all) = a , λ p' → all (सङ्कोचः o q₀ p')
