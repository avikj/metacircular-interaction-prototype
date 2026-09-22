{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रतिबिम्ब — the reflected image.  THE BEHAVIOR IS A SET-QUOTIENT OF
-- THE CODE; ITS FIBRE IS INFINITE, AND THE LOSSLESS TRACE IS A POINT.
--
-- The machine is a quotient computer, and this file makes the
-- quotient literal.  Take codes modulo running the same:
--
--     Beh  =  Code / (M ~ N  iff  every run of M and N agrees,
--                      configuration for configuration, at every
--                      depth, from every start)
--
-- Running descends to the quotient (`visible`), because the target of
-- running is a set.  And the quotient genuinely collapses: a rule
-- APPENDED BEHIND a table it duplicates is shadowed by first-match
-- lookup — unconditionally, at every configuration, with no
-- boundedness hypothesis at all — so duplicating a table any number
-- of times never changes a run (`shadow-run`), while it changes the
-- code every time.  For any non-empty table this yields an injection
-- ℕ → Code whose image is one single point of Beh
-- (`one-point-many-codes`).
--
-- Against Ekatva the picture closes: the lossless completion of the
-- step is contractible — a point of structure, forced; the behavioral
-- quotient of the code is infinite-to-one — a fibre of programs,
-- free.  What is unique is the trace; what is multiple is the
-- expression; the machine computes in the quotient and the fibre
-- carries what the quotient forgot.
------------------------------------------------------------------------

module Pratibimba_TheBehaviorIsASetQuotientOfTheCodeItsFibreIsInfiniteAndTheLosslessTraceIsAPoint where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Foundations.HLevels using (isSetΠ)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Order
  using (_<_ ; _≟_ ; Trichotomy ; lt ; eq ; gt ; ¬m<m ; <-trans ; ≤-+k ;
         suc-≤-suc ; zero-≤ ; <-split ; ¬-<-zero)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; length)
open import Cubical.Data.List.Properties using (length++)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just ; rec ; map-Maybe)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
open import AnulomaViloma_TheTraceComposesTheCompletedRunRunsBackwardsByReflAndWhenTheMachineHaltsIsAProposition
  using (isSetConf)
open import Vistara_ThePaddingLemmaABehaviorHasUnboundedlyManyProgramsSoTheCodeIsNotDeterminedByTheRun
  using (look-append)

private
  Act : Type
  Act = ℕ × ℕ × Move

------------------------------------------------------------------------
-- §1  Shadowing: a duplicated table is invisible, unconditionally.
------------------------------------------------------------------------

dups : ℕ → Code → Code
dups zero    M = M
dups (suc j) M = M ++ dups j M

-- First-match lookup never reaches the copies: no bound, no
-- hypothesis, every state and symbol.
shadow-look : (j q s : ℕ) (M : Code) →
  look (dups j M) q s ≡ look M q s
shadow-look zero    q s M = refl
shadow-look (suc j) q s M =
  look-append M (dups j M) q s ∙ go (look M q s) refl
  where
  go : (m : Maybe Act) → look M q s ≡ m →
       rec (look (dups j M) q s) just m ≡ look M q s
  go (just a) lp = sym lp
  go nothing  lp = shadow-look j q s M

shadow-run : (j n : ℕ) (M : Code) (c : Conf) →
  snd (run n (dups j M , c)) ≡ snd (run n (M , c))
shadow-run j zero    M c = refl
shadow-run j (suc n) M c =
  cong (λ d → snd (run n (dups j M , rec c (idfun Conf) d))) (δ-dup c)
  ∙ shadow-run j n M (rec c (idfun Conf) (δ M c))
  where
  δ-dup : (c' : Conf) → δ (dups j M) c' ≡ δ M c'
  δ-dup (q , ls , hd , rs) =
    cong (map-Maybe (λ act →
            fst act , shift (snd (snd act)) (ls , fst (snd act) , rs)))
         (shadow-look j q hd M)

------------------------------------------------------------------------
-- §2  The copies are all different codes.
------------------------------------------------------------------------

module _ (r : Rule) (M' : Code) where

  private
    M : Code
    M = r ∷ M'

    lenGrows : (j : ℕ) → length (dups j M) < length (dups (suc j) M)
    lenGrows j =
      subst (length (dups j M) <_) (sym (length++ M (dups j M)))
            (≤-+k {m = 1} {n = length M} (suc-≤-suc zero-≤))

    lenMono : (j k : ℕ) → j < k → length (dups j M) < length (dups k M)
    lenMono j zero    jk = Empty.rec (¬-<-zero jk)
    lenMono j (suc k) jk = go (<-split jk)
      where
      go : (j < k) ⊎ (j ≡ k) → length (dups j M) < length (dups (suc k) M)
      go (inl jk') = <-trans (lenMono j k jk') (lenGrows k)
      go (inr p)   =
        subst (λ x → length (dups x M) < length (dups (suc k) M))
              (sym p) (lenGrows k)

  -- All the copies are different codes: the doubling family is
  -- injective.
  dups-inj : (j k : ℕ) → dups j M ≡ dups k M → j ≡ k
  dups-inj j k p = go (j ≟ k)
    where
    go : Trichotomy j k → j ≡ k
    go (lt jk) =
      Empty.rec (¬m<m (subst (_< length (dups k M))
                             (cong length p) (lenMono j k jk)))
    go (eq q)  = q
    go (gt kj) =
      Empty.rec (¬m<m (subst (_< length (dups j M))
                             (cong length (sym p)) (lenMono k j kj)))

------------------------------------------------------------------------
-- §3  The quotient: behavior as code modulo running the same.
------------------------------------------------------------------------

SameRun : Code → Code → Type
SameRun M N = (n : ℕ) (c : Conf) → snd (run n (M , c)) ≡ snd (run n (N , c))

Beh : Type
Beh = Code / SameRun

-- Running descends to the quotient: behavior is well-defined on
-- behavior, because the target of running is a set.
visible : Beh → ℕ → Conf → Conf
visible = SQ.rec (isSetΠ (λ _ → isSetΠ (λ _ → isSetConf)))
                 (λ M n c → snd (run n (M , c)))
                 (λ M N r → funExt (λ n → funExt (λ c → r n c)))

-- On a code, the descended behavior is the run, definitionally.
visible-computes : (M : Code) →
  visible [ M ] ≡ (λ n c → snd (run n (M , c)))
visible-computes M = refl

------------------------------------------------------------------------
-- §4  THE THEOREM: one point of the quotient, unboundedly many codes.
------------------------------------------------------------------------

one-point-many-codes : (r : Rule) (M' : Code) →
  Σ[ codes ∈ (ℕ → Code) ]
    ( ((j k : ℕ) → codes j ≡ codes k → j ≡ k)
    × ((j k : ℕ) → Path Beh [ codes j ] [ codes k ]) )
one-point-many-codes r M' =
  (λ j → dups j (r ∷ M')) ,
  dups-inj r M' ,
  λ j k → eq/ _ _ (λ n c →
    shadow-run j n (r ∷ M') c ∙ sym (shadow-run k n (r ∷ M') c))
