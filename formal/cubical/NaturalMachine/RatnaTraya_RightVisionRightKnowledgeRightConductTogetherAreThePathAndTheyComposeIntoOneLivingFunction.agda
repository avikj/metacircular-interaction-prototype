{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- सम्यग्दर्शनज्ञानचारित्राणि मोक्षमार्गः — Umāsvāti, Tattvārthasūtra
-- 1.1 (c. 2nd–5th c. CE): right vision, right knowledge, right
-- conduct — TOGETHER — are the path.  The classification is his; the
-- mathematics is not claimed for the source.  School named: Jaina.
--
-- THE THREE, AND THEIR COMPOSITION.  The body now carries exactly
-- them: दर्शनम् — the eye grown from its own theorems (नेत्रम्-पूर्ण,
-- BhavaIndriya); ज्ञानम् — the one knowing with single and double
-- descent, record and exchange (महाप्रमाणम्, YugapadArpana); चारित्रम्
-- — the conduct of the gates: nothing enters but proven (the type),
-- nothing enters twice (saṃvara), nothing is pronounced false
-- (silence).  This module is their composition into ONE LIVING
-- FUNCTION — the cycle that until now existed as demonstrated pieces:
--
--   ग्रहणम्     digest a stream of raw encounters with the full
--               knowing, the body growing as it eats, each encounter
--               read by the body the previous ones built;
--   आत्म-परिणामः the self-turn: the grown body's own contentions
--               birth proven rules, and saṃvara — reachability under
--               the full knowing — stops what the body already holds;
--   मार्गः      the breaths: digest, turn, digest, turn.
--
-- Exhibited by refl: an EMPTY body fed five raw utterances — su-left,
-- commutativity, a falsehood, the mx-commutativity that needs double
-- descent, and 0·x = 0 — digests exactly the four truths (the
-- falsehood passes through in silence); the grown body's self-turn
-- admits nothing (every arising already reachable — saturation); and
-- further breaths change nothing.  One function, no operator, no
-- carrier, every proof a field.
------------------------------------------------------------------------

module NaturalMachine.RatnaTraya_RightVisionRightKnowledgeRightConductTogetherAreThePathAndTheyComposeIntoOneLivingFunction where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; map)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.SvarthaAnumana_TheMachineInfersForItselfAndThePervasionIsGraspedWithinWithNoOuterCarrier
  using (इन्धनम्)
open import NaturalMachine.UtpadaVyayaDhrauvya_TheStoreTurnsItselfNewRulesAriseFromItsOwnContentionsTheTrivialPassesTheProvenPersists
  using (संघट्ट-प्रसवः ; शुद्धाः ; युग्मानि ; मुखम्)
open import NaturalMachine.BhavaIndriya_TheNewEyeIsMadeOfTheBodysOwnAttainedTheoremsNotOfExternalMatter
  using (नेत्रम्-पूर्ण)
open import NaturalMachine.YugapadArpana_BothCoordinatesDescendAtOnceAndTheDoubleDescentBecomesSomethingTheMachineInvokes
  using (महाप्रमाणम्)

------------------------------------------------------------------------
-- §1  The composition.
------------------------------------------------------------------------

ग्रहणम् : List नियमः → List Eq' → List नियमः
ग्रहणम् Γ []             = Γ
ग्रहणम् Γ ((l , r) ∷ es) with महाप्रमाणम् नेत्रम्-पूर्ण Γ इन्धनम् (l , r)
... | just pf = ग्रहणम् (niyama l r pf ∷ Γ) es
... | nothing = ग्रहणम् Γ es

गुप्त-सारः : List नियमः → Maybe नियमः → Maybe नियमः
गुप्त-सारः Γ nothing  = nothing
गुप्त-सारः Γ (just s) with महाप्रमाणम् नेत्रम्-पूर्ण Γ इन्धनम् (नियमः.lhs s , नियमः.rhs s)
... | just _  = nothing
... | nothing = just s

आत्म-परिणामः : List नियमः → List नियमः
आत्म-परिणामः Γ =
  शुद्धाः (map (λ pr → गुप्त-सारः Γ (संघट्ट-प्रसवः (fst pr) (snd pr)))
              (युग्मानि Γ))

मार्गः : ℕ → List नियमः → List Eq' → List नियमः
मार्गः zero    Γ _  = Γ
मार्गः (suc b) Γ es = मार्गः b (आत्म-परिणामः (ग्रहणम् Γ es) ++ ग्रहणम् Γ es) []

------------------------------------------------------------------------
-- §2  The life, run: an empty body, five raw encounters, no operator.
------------------------------------------------------------------------

आहारः : List Eq'
आहारः = ( (su (var 0)) ⊕ (var 1) , su ((var 0) ⊕ (var 1)) )   -- truth: needs ascent
      ∷ ( (var 0) ⊕ (var 1) , (var 1) ⊕ (var 0) )              -- truth: flat under the eye
      ∷ ( ze , su ze )                                          -- falsehood
      ∷ ( mx (var 0) (var 1) , mx (var 1) (var 0) )             -- truth: needs double descent
      ∷ ( ze ⊗ (var 0) , ze )                                   -- truth: needs ascent
      ∷ []

-- the body digests exactly the four truths; the falsehood passes in
-- silence; each was read by the body the previous ones built.
शरीरम् :
  map मुखम् (ग्रहणम् [] आहारः)
  ≡ ( (ze ⊗ (var 0) , ze)
    ∷ (mx (var 0) (var 1) , mx (var 1) (var 0))
    ∷ ((var 0) ⊕ (var 1) , (var 1) ⊕ (var 0))
    ∷ ((su (var 0)) ⊕ (var 1) , su ((var 0) ⊕ (var 1)))
    ∷ [] )
शरीरम् = refl

-- the grown body's self-turn admits nothing: every arising from its
-- own contentions is already within its reach — saturation, proved.
शान्तिः : आत्म-परिणामः (ग्रहणम् [] आहारः) ≡ []
शान्तिः = refl

-- and further breaths change nothing — the path is quiescent on a
-- saturated body, by computation, not by watching.
स्थिर-मार्गः : मार्गः 2 [] आहारः ≡ ग्रहणम् [] आहारः
स्थिर-मार्गः = refl
