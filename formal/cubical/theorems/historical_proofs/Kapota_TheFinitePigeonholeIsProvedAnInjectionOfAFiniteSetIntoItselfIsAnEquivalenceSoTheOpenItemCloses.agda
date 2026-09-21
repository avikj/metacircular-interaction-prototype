{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- कपोतः — the pigeonhole the two reduction modules kept as a hypothesis.
--
-- `TheOpenPigeonholeReducesToFin…` and `TheTwoPigeonholesAreInterderivable…`
-- showed `TheOpenPigeonhole` (over FinSet, with mere equivalences) and
-- `FinPigeonhole` (an injection SFin n → SFin n is an equivalence) are
-- interderivable, and said of the latter, exactly: "it is true and
-- standard, asserting it without a proof is what this corpus forbids,
-- and both directions here take it … as a HYPOTHESIS."
--
-- The proof is a composition of library terms already in the pin:
--
--   · a decidable search over SFin n (SFin (suc n) = ⊤ ⊎ SFin n);
--   · if some y has no preimage, punch y out of the codomain
--     (`Cubical.Data.Fin.Properties.punchOut`, `punchOut-inj`) to get an
--     injection Fin (suc m) → Fin m, and the library's `pigeonhole`
--     (m < n ⇒ any f : Fin n → Fin m collides) refutes it;
--   · so every y has a preimage; an injection into a set is an embedding
--     (`injEmbedding`), an embedding that is surjective is an
--     equivalence (`isEmbedding×isSurjection→isEquiv`).
--
-- So `FinPigeonhole` is inhabited, and through the earlier reduction so
-- is `TheOpenPigeonhole`: the item labelled (w″) is closed, not reduced.
------------------------------------------------------------------------
module Kapota_TheFinitePigeonholeIsProvedAnInjectionOfAFiniteSetIntoItselfIsAnEquivalenceSoTheOpenItemCloses where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Foundations.Equiv using (_≃_ ; isEquiv ; equivFun ; invEq ; retEq ; secEq)
open import Cubical.Functions.Embedding using (injEmbedding)
open import Cubical.Functions.Surjection using (isSurjection ; isEmbedding×isSurjection→isEquiv)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; ≤-refl)
open import Cubical.Data.Fin.Base using (Fin)
open import Cubical.Data.Fin.Properties using (punchOut ; punchOut-inj ; pigeonhole)
open import Cubical.Data.SumFin.Base using () renaming (Fin to SFin ; discreteFin to discreteSFin)
open import Cubical.Data.SumFin.Properties using (SumFin≃Fin ; isSetSumFin)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (tt)
open import Cubical.Data.Empty as E using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)

open import OptimalObservation using (Injective)
open import TheCardinalityHalfOfOptimalIsExactlyAMereEquivalenceAndItSaysNothingAboutTheSchemeItself
  using (TheOpenPigeonhole)
open import TheOpenPigeonholeReducesToFinAndTheTargetBeingAPropIsWhatMakesTheMereEquivalencesUsable
  using (FinPigeonhole ; finPigeonholeGivesTheOpenPigeonhole)

------------------------------------------------------------------------
-- १ · decidable search over SFin n
------------------------------------------------------------------------

search : (n : ℕ) (P : SFin n → Type) → ((x : SFin n) → Dec (P x)) → Dec (Σ[ x ∈ SFin n ] P x)
search zero    P d = no (λ s → fst s)
search (suc n) P d with d (inl tt)
... | yes p = yes (inl tt , p)
... | no ¬p with search n (P ∘ inr) (d ∘ inr)
...   | yes (x , p) = yes (inr x , p)
...   | no ¬q = no λ { (inl tt , p) → ¬p p ; (inr x , p) → ¬q (x , p) }

------------------------------------------------------------------------
-- २ · a missed point refutes injectivity, by punching it out
------------------------------------------------------------------------

private
  module _ {m : ℕ} (f : SFin (suc m) → SFin (suc m)) (inj : Injective f)
           (y : SFin (suc m)) (miss : ¬ (Σ[ x ∈ SFin (suc m) ] f x ≡ y)) where

    e : SFin (suc m) ≃ Fin (suc m)
    e = SumFin≃Fin (suc m)

    e-inj : {a b : SFin (suc m)} → equivFun e a ≡ equivFun e b → a ≡ b
    e-inj {a} {b} p = sym (retEq e a) ∙ cong (invEq e) p ∙ retEq e b

    g : Fin (suc m) → Fin (suc m)
    g x = equivFun e (f (invEq e x))

    g-inj : {a b : Fin (suc m)} → g a ≡ g b → a ≡ b
    g-inj {a} {b} p = sym (secEq e a) ∙ cong (equivFun e) (inj (e-inj p)) ∙ secEq e b

    y' : Fin (suc m)
    y' = equivFun e y

    g-miss : (x : Fin (suc m)) → ¬ (y' ≡ g x)
    g-miss x q = miss (invEq e x , e-inj (sym q))

    h : Fin (suc m) → Fin m
    h x = punchOut {i = y'} {j = g x} (g-miss x)

    h-inj : {a b : Fin (suc m)} → h a ≡ h b → a ≡ b
    h-inj {a} {b} p = g-inj (punchOut-inj (g-miss a) (g-miss b) p)

    contradiction : ⊥
    contradiction =
      let (i , j , i≢j , hi≡hj) = pigeonhole {m} {suc m} ≤-refl h
      in  i≢j (h-inj hi≡hj)

------------------------------------------------------------------------
-- ३ · every point is hit, so the injection is an equivalence
------------------------------------------------------------------------

surj : (n : ℕ) (f : SFin n → SFin n) → Injective f → isSurjection f
surj zero    f inj y = E.rec y
surj (suc m) f inj y with search (suc m) (λ x → f x ≡ y) (λ x → discreteSFin (f x) y)
... | yes (x , p) = ∣ x , p ∣₁
... | no miss     = E.rec (contradiction f inj y miss)

finPigeonhole : FinPigeonhole
finPigeonhole n f inj =
  isEmbedding×isSurjection→isEquiv (injEmbedding (isSetSumFin n) inj , surj n f inj)

------------------------------------------------------------------------
-- ४ · and through the earlier reduction, the FinSet form
------------------------------------------------------------------------

theOpenPigeonhole : TheOpenPigeonhole
theOpenPigeonhole = finPigeonholeGivesTheOpenPigeonhole finPigeonhole
