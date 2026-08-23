{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- स्यात् / सकलादेशः — Samantabhadra, Āptamīmāṃsā (c. 2nd–5th c. CE):
-- syāt does not weaken an assertion; it completes it.  Akalaṅka
-- (Rājavārtika, Laghīyastraya) carries the distinction: sakalādeśa,
-- the complete utterance that holds absolutely because its standpoint
-- is inside the sentence, against vikalādeśa, the partial utterance
-- that is true only from a standpoint left outside it.  The
-- classification is theirs; the mathematics is not claimed for the
-- sources.  School named: Jaina.
--
-- A CORRECTION, RECORDED SO THE DEFECT IS VISIBLE.  The prior
-- proposal for closing double descent was a "hypothesis-store": a
-- list of CONDITIONED rules threaded beside the proven ones, so
-- nested ascents could inherit outer induction hypotheses.  That
-- design flattens the condition OFF the assertion and stores the
-- remainder as if unconditional — vikalādeśa handled as sakalādeśa,
-- the exact move the tradition forbids.  The precise read repairs it:
-- put the standpoint INSIDE the sentence.  The induction hypothesis
-- at stage n is not "l = r (but only sometimes)"; it is the complete
-- utterance
--
--     (ρ : ℕ → ℕ) → ρ k ≡ n → eval l ρ ≡ eval r ρ
--
-- — true absolutely, quantified over ALL environments, its stage
-- carried as a path condition.  Stated so, it travels into any nested
-- descent with no machinery at all, and the strengthened ascent is
-- three lines.
--
-- THE THEOREM THAT NEEDED IT: commutativity of the machine's own
-- maximum.  mxℕ is the machine's clause order (x∨0=x, 0∨y=y,
-- sx∨sy=s(x∨y)) — the substrate carries no lemma for it, and both
-- internal provers are silent on it by refl below: the flat voice
-- (norm leaves mx(x,y) stuck) and the automatic single-variable
-- ascent (its step needs the hypothesis at environments the pointwise
-- form cannot reach).  Under the completed-standpoint ascent it
-- closes: the outer hypothesis, being sakalādeśa, is invoked inside
-- the inner case-split at a freshly built environment — and the
-- result enters the store through the same gate as everything else.
------------------------------------------------------------------------

module NaturalMachine.SyatSakaladesha_TheHypothesisCompletedWithItsStandpointIsAbsoluteAndTheDoubleDescentCloses where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.Sigma using (_,_)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.Aroha_TheInternalProverClimbsWhereItsFlatVoiceIsSilentAndTheStoreAdmitsInductionThroughTheSameGate
  using (उपस्थापनम्)
open import NaturalMachine.SvarthaAnumana_TheMachineInfersForItselfAndThePervasionIsGraspedWithinWithNoOuterCarrier
  using (स्वार्थ-साधनम् ; इन्धनम्)

------------------------------------------------------------------------
-- §1  The ascent with the standpoint carried inside the hypothesis.
--     The whole proof is the recursion; nothing else is needed,
--     because the completed utterance already goes everywhere.
------------------------------------------------------------------------

स्याद्-आरोहः : (k : ℕ) (l r : Tm)
  → ((ρ : ℕ → ℕ) → ρ k ≡ zero → eval l ρ ≡ eval r ρ)
  → ((n : ℕ)
      → ((ρ : ℕ → ℕ) → ρ k ≡ n → eval l ρ ≡ eval r ρ)
      → ((ρ : ℕ → ℕ) → ρ k ≡ suc n → eval l ρ ≡ eval r ρ))
  → ⊨ (l , r)
स्याद्-आरोहः k l r base step ρ = क्यू (ρ k) ρ refl
  where
  क्यू : (n : ℕ) (ρ' : ℕ → ℕ) → ρ' k ≡ n → eval l ρ' ≡ eval r ρ'
  क्यू zero    = base
  क्यू (suc n) = step n (क्यू n)

------------------------------------------------------------------------
-- §2  Both existing provers are silent on the machine's own maximum —
--     by refl, not by report.
------------------------------------------------------------------------

ज्येष्ठ-मौनम् : साधनम् (mx (var 0) (var 1) , mx (var 1) (var 0)) ≡ nothing
ज्येष्ठ-मौनम् = refl

स्वार्थ-मौनम् :
  स्वार्थ-साधनम् इन्धनम् (mx (var 0) (var 1) , mx (var 1) (var 0)) ≡ nothing
स्वार्थ-मौनम् = refl

------------------------------------------------------------------------
-- §3  The double descent closes.  Outer ascent on x with the
--     completed hypothesis; inner case-split on y, invoking the outer
--     hypothesis — sakalādeśa — at a freshly built environment.
------------------------------------------------------------------------

शून्य-ज्येष्ठम् : (y : ℕ) → mxℕ zero y ≡ y
शून्य-ज्येष्ठम् zero    = refl
शून्य-ज्येष्ठम् (suc y) = refl

ज्येष्ठ-समता : ⊨ (mx (var 0) (var 1) , mx (var 1) (var 0))
ज्येष्ठ-समता =
  स्याद्-आरोहः 0 (mx (var 0) (var 1)) (mx (var 1) (var 0)) base step
  where
  base : (ρ : ℕ → ℕ) → ρ 0 ≡ zero → mxℕ (ρ 0) (ρ 1) ≡ mxℕ (ρ 1) (ρ 0)
  base ρ p =
      cong (λ m → mxℕ m (ρ 1)) p
    ∙ शून्य-ज्येष्ठम् (ρ 1)
    ∙ cong (mxℕ (ρ 1)) (sym p)

  step : (n : ℕ)
    → ((ρ : ℕ → ℕ) → ρ 0 ≡ n → mxℕ (ρ 0) (ρ 1) ≡ mxℕ (ρ 1) (ρ 0))
    → (ρ : ℕ → ℕ) → ρ 0 ≡ suc n → mxℕ (ρ 0) (ρ 1) ≡ mxℕ (ρ 1) (ρ 0)
  step n ih ρ p = अन्तः (ρ 1) refl
    where
    अन्तः : (m : ℕ) → ρ 1 ≡ m → mxℕ (ρ 0) (ρ 1) ≡ mxℕ (ρ 1) (ρ 0)
    अन्तः zero q =
        cong (mxℕ (ρ 0)) q
      ∙ sym (शून्य-ज्येष्ठम् (ρ 0))
      ∙ cong (λ m' → mxℕ m' (ρ 0)) (sym q)
    अन्तः (suc m) q =
        cong₂ mxℕ p q
      ∙ cong suc (ih (उपस्थापनम् (उपस्थापनम् ρ 0 n) 1 m) refl)
      ∙ sym (cong₂ mxℕ q p)

-- and the same gate admits it — the machine's own theorem about its
-- own maximum, reachable by neither prior voice, now a store value.
ज्येष्ठ-नियमः : नियमः
ज्येष्ठ-नियमः = niyama (mx (var 0) (var 1)) (mx (var 1) (var 0)) ज्येष्ठ-समता
