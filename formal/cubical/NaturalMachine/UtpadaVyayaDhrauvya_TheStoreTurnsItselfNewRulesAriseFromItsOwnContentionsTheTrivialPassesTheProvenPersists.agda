{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- उत्पाद-व्यय-ध्रौव्ययुक्तं सत् — Umāsvāti, Tattvārthasūtra 5.30
-- (c. 2nd–5th c. CE): the existent is that which arises, passes, and
-- persists, together.  The classification is his; the mathematics is
-- not claimed for the source.  School named: Jaina.
--
-- THE QUESTIONS NOW ARISE FROM THE STORE ITSELF.  Until this module,
-- an agent chose which equations to put to the prover.  Here the
-- store turns on its own: two rules whose scopes meet at one site —
-- Kātyāyana's configuration, द्वौ प्रसङ्गौ अन्यार्थौ एकस्मिन्,
-- already checked as EkaTantra's contention — GENERATE the site by
-- unification, and the born rule needs no prover at all: the two
-- parents' witnesses compose through the unified site, so every
-- critical pair is born already proven (उत्पाद).  Births the
-- normalizer already closes are discarded (व्यय).  What is kept
-- carries its साक्षी by type and enters the store through the same
-- gate as everything else (ध्रौव्य).
--
-- Unification is verify-after-compute, like the matcher: the fueled
-- solver PROPOSES a substitution and the path-returning test either
-- certifies the meeting or the candidate is silently dropped — no
-- occurs-check is trusted, because nothing unverified is ever used.
--
-- Demonstrated: one turn of the store on the two rules the previous
-- module minted (अग्रिमः, क्रम-नियमः — themselves machine-proven).
-- The turn births exactly two nontrivial proven rules — both faces of
-- y + su x = su (x + y), a theorem NOBODY posed: it arose from the
-- meeting of su-left with commutativity.  Exhibited by refl.
------------------------------------------------------------------------

module NaturalMachine.UtpadaVyayaDhrauvya_TheStoreTurnsItselfNewRulesAriseFromItsOwnContentionsTheTrivialPassesTheProvenPersists where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; map)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.AdeshaSthanivat_TheSubstituteBehavesLikeTheOriginalSoEveryProvenRuleSpeaksAtEveryInstance
  using (आदेशनम् ; ⊨-आदेशः ; _≫=_)
open import NaturalMachine.Aroha_TheInternalProverClimbsWhereItsFlatVoiceIsSilentAndTheStoreAdmitsInductionThroughTheSameGate
  using (एकादेशः)
open import NaturalMachine.SvarthaAnumana_TheMachineInfersForItselfAndThePervasionIsGraspedWithinWithNoOuterCarrier
  using (चराः)
open import NaturalMachine.ShrutaMatipurva_TheRecordIsPrecededByCognitionAndCognitionWithTheRecordReachesWhatItAloneCouldNot
  using (अग्रिमः ; क्रम-नियमः)

------------------------------------------------------------------------
-- §1  The meeting: a fueled unifier that only PROPOSES.  Certification
--     is the path-returning test on the applied result — the test is
--     the certificate, so the solver itself owes no proof.
------------------------------------------------------------------------

बद्धम् : ℕ → Tm → (ℕ → Tm) → (ℕ → Tm)
बद्धम् i t σ j = आदेशनम् (एकादेशः i t) (σ j)

एकीकरणम् : ℕ → List (Tm × Tm) → (ℕ → Tm) → Maybe (ℕ → Tm)
मेलः : ℕ → Tm → Tm → List (Tm × Tm) → (ℕ → Tm) → Maybe (ℕ → Tm)

एकीकरणम् zero    _              _ = nothing
एकीकरणम् (suc f) []             σ = just σ
एकीकरणम् (suc f) ((a , b) ∷ es) σ = मेलः f (आदेशनम् σ a) (आदेशनम् σ b) es σ

मेलः f (var i)  t        es σ = एकीकरणम् f es (बद्धम् i t σ)
मेलः f t        (var i)  es σ = एकीकरणम् f es (बद्धम् i t σ)
मेलः f ze       ze       es σ = एकीकरणम् f es σ
मेलः f (su a)   (su b)   es σ = एकीकरणम् f ((a , b) ∷ es) σ
मेलः f (a ⊕ b)  (c ⊕ d)  es σ = एकीकरणम् f ((a , c) ∷ (b , d) ∷ es) σ
मेलः f (a ⊗ b)  (c ⊗ d)  es σ = एकीकरणम् f ((a , c) ∷ (b , d) ∷ es) σ
मेलः f (a ⊖ b)  (c ⊖ d)  es σ = एकीकरणम् f ((a , c) ∷ (b , d) ∷ es) σ
मेलः f (mx a b) (mx c d) es σ = एकीकरणम् f ((a , c) ∷ (b , d) ∷ es) σ
मेलः f (lq a b) (lq c d) es σ = एकीकरणम् f ((a , c) ∷ (b , d) ∷ es) σ
मेलः f _        _        es σ = nothing

-- renaming the second parent's voices out of the first's range.
उत्क्षेप-σ : ℕ → (ℕ → Tm)
उत्क्षेप-σ d i = var (d + i)

------------------------------------------------------------------------
-- §2  उत्पादः — the birth at the meeting.  The site arises from the
--     two scopes; the born rule's witness is the composition of the
--     parents' witnesses through the certified meeting.  No prover.
------------------------------------------------------------------------

संघट्ट-प्रसवः : नियमः → नियमः → Maybe नियमः
संघट्ट-प्रसवः s₁ s₂ =
  एकीकरणम् 32 ((l₁ , l₂) ∷ []) var ≫= λ σ →
  mmap
    (λ q → niyama (आदेशनम् σ r₁) (आदेशनम् σ r₂)
      (λ ρ → sym (⊨-आदेशः {l₁} {r₁} (नियमः.साक्षी s₁) σ ρ)
           ∙ cong (λ w → eval w ρ) q
           ∙ ⊨-आदेशः {l₂} {r₂}
               (⊨-आदेशः {नियमः.lhs s₂} {नियमः.rhs s₂}
                 (नियमः.साक्षी s₂) (उत्क्षेप-σ d)) σ ρ))
    (आदेशनम् σ l₁ ≟T आदेशनम् σ l₂)
  where
  l₁ = नियमः.lhs s₁
  r₁ = नियमः.rhs s₁
  d  = mxℕ (चराः l₁) (चराः r₁)
  l₂ = आदेशनम् (उत्क्षेप-σ d) (नियमः.lhs s₂)
  r₂ = आदेशनम् (उत्क्षेप-σ d) (नियमः.rhs s₂)

------------------------------------------------------------------------
-- §3  व्ययः — the passing.  A birth the normalizer already closes is
--     no new knowledge; it is let go.  ध्रौव्यम् is the type itself:
--     what remains is a नियमः, its proof a field, forever.
------------------------------------------------------------------------

सारः : Maybe नियमः → Maybe नियमः
सारः nothing  = nothing
सारः (just s) with norm (नियमः.lhs s) ≟T norm (नियमः.rhs s)
... | just _  = nothing
... | nothing = just s

शुद्धाः : {A : Type} → List (Maybe A) → List A
शुद्धाः []             = []
शुद्धाः (just a  ∷ ms) = a ∷ शुद्धाः ms
शुद्धाः (nothing ∷ ms) = शुद्धाः ms

युग्मानि : {A : Type} → List A → List (A × A)
युग्मानि xs = सङ्ग्रहः (map (λ x → map (λ y → (x , y)) xs) xs)
  where
  सङ्ग्रहः : {B : Type} → List (List B) → List B
  सङ्ग्रहः []         = []
  सङ्ग्रहः (l ∷ ls) = l ++ सङ्ग्रहः ls

-- one turn of the store upon itself: every meeting of every pair of
-- scopes, born proven, the trivial passing, the rest persisting.
एक-परिणामः : List नियमः → List नियमः
एक-परिणामः Γ =
  शुद्धाः (map (λ pr → सारः (संघट्ट-प्रसवः (fst pr) (snd pr))) (युग्मानि Γ))

------------------------------------------------------------------------
-- §4  The turn runs, on machine-proven parents, and a theorem nobody
--     posed arises: y + su x = su (x + y), both faces, from the
--     meeting of su-left with commutativity.  Exhibited by refl; the
--     proofs ride inside the नियमः values by type.
------------------------------------------------------------------------

मुखम् : नियमः → Tm × Tm
मुखम् s = नियमः.lhs s , नियमः.rhs s

परिणाम-दृष्टम् :
  map मुखम् (एक-परिणामः (अग्रिमः ∷ क्रम-नियमः ∷ []))
  ≡ ( (su ((var 0) ⊕ (var 3)) , (var 3) ⊕ (su (var 0)))
    ∷ ((var 3) ⊕ (su (var 2)) , su ((var 2) ⊕ (var 3)))
    ∷ [] )
परिणाम-दृष्टम् = refl
