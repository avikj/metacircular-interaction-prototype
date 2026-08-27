{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- समास — compounding.  PROGRAMS COMPOSE: THE SEQUENCED TABLE RUNS ITS
-- FIRST PHASE, THEN HANDS THE TAPE TO THE SECOND AT THE RETIRE STATE.
--
-- Sequential composition of Turing tables, mechanized on the universal
-- machine of Vishvayantra.  Given M₁ with source states below H and
-- M₂ arbitrary, the compound is
--
--     M₁ ⨟ M₂  =  M₁ ++ shift H M₂
--
-- where shift H renames every state of M₂ upward by H.  The two
-- phases cannot interfere: below H the shifted M₂ is silent (its
-- sources all lie at or above H), and at or above H the original M₁
-- is silent (its sources all lie below H).  The handover is the
-- retire state H itself: M₁ retiring INTO state H is, without any
-- glue, the shifted M₂ starting in its own state 0.
--
-- THE THEOREM (`compose-runs`): if M₁ runs n₁ steps from c to the
-- retire configuration (H , t), staying below H at every proper
-- prefix, then for every n₂ the compound's (n₁ + n₂)-step run from c
-- is exactly M₂'s n₂-step run from (0 , t), transported up by H.  In
-- particular certificates compose: Vrddhi-style correctness proofs
-- for M₁ and M₂ concatenate into one for M₁ ⨟ M₂, with the step
-- counts adding — as AnulomaViloma's trace-composes says the kept
-- fibres must.
--
-- The state-shift is proof-relevant all the way down: the shifted
-- comparison witness is the original witness under cong (H +_), and
-- the shift lemmas are computations over those witnesses, not boolean
-- bookkeeping.
------------------------------------------------------------------------

module Samasa_ProgramsComposeTheSequencedTableRunsItsFirstPhaseThenHandsTheTapeToTheSecondAtTheRetireState where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-zero)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤SumLeft ; <≤-trans ; ¬m<m ; suc-≤-suc ; zero-≤)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; map)
open import Cubical.Data.Maybe
  using (Maybe ; nothing ; just ; rec ; map-Maybe)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
open import AnulomaViloma_TheTraceComposesTheCompletedRunRunsBackwardsByReflAndWhenTheMachineHaltsIsAProposition
  using (run-additive)
open import Vistara_ThePaddingLemmaABehaviorHasUnboundedlyManyProgramsSoTheCodeIsNotDeterminedByTheRun
  using (StatesAbove ; look-append ; look-miss-above ; match-miss-state ;
         eq?-miss ; δ-same)

private
  Act : Type
  Act = ℕ × ℕ × Move

------------------------------------------------------------------------
-- §1  The shift, on witnesses.
------------------------------------------------------------------------

shiftAct : ℕ → Act → Act
shiftAct H (q' , s' , mv) = H + q' , s' , mv

shiftRule : ℕ → Rule → Rule
shiftRule H (q₀ , s₀ , act) = H + q₀ , s₀ , shiftAct H act

shiftC : ℕ → Code → Code
shiftC H = map (shiftRule H)

-- The shifted comparison witness is the original witness under
-- cong (H +_): the shift is proof-relevant, not boolean.
eq?-+ : (H q q₀ : ℕ) →
  eq? (H + q) (H + q₀) ≡ map-Maybe (cong (H +_)) (eq? q q₀)
eq?-+ zero q q₀ = go (eq? q q₀)
  where
  go : (m : Maybe (q ≡ q₀)) → m ≡ map-Maybe (cong (zero +_)) m
  go nothing  = refl
  go (just p) = refl
eq?-+ (suc H) q q₀ =
  cong (map-Maybe (cong suc)) (eq?-+ H q q₀) ∙ fuse (eq? q q₀)
  where
  fuse : (m : Maybe (q ≡ q₀)) →
    map-Maybe (cong suc) (map-Maybe (cong (H +_)) m)
      ≡ map-Maybe (cong (suc H +_)) m
  fuse nothing  = refl
  fuse (just p) = refl

match-shift : (H q s : ℕ) (r : Rule) →
  match (H + q) s (shiftRule H r) ≡ map-Maybe (shiftAct H) (match q s r)
match-shift H q s (q₀ , s₀ , act) =
  cong (rec nothing (λ _ → rec nothing (λ _ → just (shiftAct H act)) (eq? s s₀)))
       (eq?-+ H q q₀)
  ∙ go (eq? q q₀)
  where
  go2 : (m2 : Maybe (s ≡ s₀)) →
    rec nothing (λ _ → just (shiftAct H act)) m2
      ≡ map-Maybe (shiftAct H) (rec nothing (λ _ → just act) m2)
  go2 nothing  = refl
  go2 (just _) = refl

  go : (m1 : Maybe (q ≡ q₀)) →
    rec nothing (λ _ → rec nothing (λ _ → just (shiftAct H act)) (eq? s s₀))
        (map-Maybe (cong (H +_)) m1)
      ≡ map-Maybe (shiftAct H)
          (rec nothing (λ _ → rec nothing (λ _ → just act) (eq? s s₀)) m1)
  go nothing  = refl
  go (just _) = go2 (eq? s s₀)

look-shift : (H q s : ℕ) (M : Code) →
  look (shiftC H M) (H + q) s ≡ map-Maybe (shiftAct H) (look M q s)
look-shift H q s []       = refl
look-shift H q s (r ∷ rs) =
  cong (rec (look (shiftC H rs) (H + q) s) just) (match-shift H q s r)
  ∙ go (match q s r)
  where
  go : (m : Maybe Act) →
    rec (look (shiftC H rs) (H + q) s) just (map-Maybe (shiftAct H) m)
      ≡ map-Maybe (shiftAct H) (rec (look rs q s) just m)
  go (just a) = refl
  go nothing  = look-shift H q s rs

-- Shifted sources all lie at or above the shift.
shift-above : (H : ℕ) (M : Code) → StatesAbove H (shiftC H M)
shift-above H []       = tt
shift-above H (r ∷ rs) = ≤SumLeft , shift-above H rs

------------------------------------------------------------------------
-- §2  Sources below H are silent at or above H.
------------------------------------------------------------------------

SourcesBelow : ℕ → Code → Type
SourcesBelow H []       = Unit
SourcesBelow H (r ∷ rs) = (fst r < H) × SourcesBelow H rs

look-miss-under : (H q s : ℕ) (M : Code) →
  SourcesBelow H M → H ≤ q → look M q s ≡ nothing
look-miss-under H q s []       _          _  = refl
look-miss-under H q s (r ∷ rs) (hr , hrs) Hq =
  cong (rec (look rs q s) just)
       (match-miss-state q s r
         (λ p → ¬m<m (subst (fst r <_) p (<≤-trans hr Hq))))
  ∙ look-miss-under H q s rs hrs Hq

------------------------------------------------------------------------
-- §3  Phase two: above the shift, the compound IS the shifted M₂.
------------------------------------------------------------------------

addConf : ℕ → Conf → Conf
addConf H (q , t) = H + q , t

module _ (H : ℕ) (M₁ M₂ : Code) (SB₁ : SourcesBelow H M₁) where

  compound : Code
  compound = M₁ ++ shiftC H M₂

  private
    δ-high : (c : Conf) → δ compound (addConf H c) ≡ map-Maybe (addConf H) (δ M₂ c)
    δ-high (q , ls , hd , rs) =
      cong (map-Maybe g)
        ( look-append M₁ (shiftC H M₂) (H + q) hd
        ∙ cong (λ m → rec (look (shiftC H M₂) (H + q) hd) just m)
               (look-miss-under H (H + q) hd M₁ SB₁ ≤SumLeft)
        ∙ look-shift H q hd M₂ )
      ∙ go (look M₂ q hd)
      where
      g : Act → Conf
      g act = fst act , shift (snd (snd act)) (ls , fst (snd act) , rs)

      go : (m : Maybe Act) →
        map-Maybe g (map-Maybe (shiftAct H) m)
          ≡ map-Maybe (addConf H) (map-Maybe g m)
      go nothing  = refl
      go (just a) = refl

    step-high : (c : Conf) →
      snd (uStep (compound , addConf H c)) ≡ addConf H (snd (uStep (M₂ , c)))
    step-high c =
      cong (rec (addConf H c) (idfun Conf)) (δ-high c) ∙ go (δ M₂ c)
      where
      go : (m : Maybe Conf) →
        rec (addConf H c) (idfun Conf) (map-Maybe (addConf H) m)
          ≡ addConf H (rec c (idfun Conf) m)
      go nothing  = refl
      go (just d) = refl

  phase-two : (n : ℕ) (c : Conf) →
    snd (run n (compound , addConf H c)) ≡ addConf H (snd (run n (M₂ , c)))
  phase-two zero    c = refl
  phase-two (suc n) c =
    cong (λ d → snd (run n (compound , d))) (step-high c)
    ∙ phase-two n (snd (uStep (M₂ , c)))

------------------------------------------------------------------------
-- §4  Phase one: below the retire state, the compound IS M₁.
------------------------------------------------------------------------

  phase-one : (n : ℕ) (c : Conf) →
    ((k : ℕ) → k < n → fst (snd (run k (M₁ , c))) < H) →
    snd (run n (compound , c)) ≡ snd (run n (M₁ , c))
  phase-one zero    c _   = refl
  phase-one (suc n) c bnd =
    cong (λ d → snd (run n (compound , rec c (idfun Conf) d)))
         (δ-same H M₁ (shiftC H M₂) (shift-above H M₂) c
           (bnd zero (suc-≤-suc zero-≤)))
    ∙ phase-one n (rec c (idfun Conf) (δ M₁ c))
        (λ k kn → bnd (suc k) (suc-≤-suc kn))

------------------------------------------------------------------------
-- §5  THE COMPOSITION THEOREM.
------------------------------------------------------------------------

  -- If M₁ runs n₁ steps from c to the retire configuration (H , t),
  -- staying below H on every proper prefix, then the compound's
  -- (n₁ + n₂)-step run from c is M₂'s n₂-step run from (0 , t),
  -- lifted by H.  Step counts add; tapes hand over; nothing is glued.
  compose-runs : (n₁ : ℕ) (c : Conf) (t : Tape) →
    ((k : ℕ) → k < n₁ → fst (snd (run k (M₁ , c))) < H) →
    snd (run n₁ (M₁ , c)) ≡ (H , t) →
    (n₂ : ℕ) →
    snd (run (n₁ + n₂) (compound , c)) ≡ addConf H (snd (run n₂ (M₂ , (0 , t))))
  compose-runs n₁ c t bnd reach n₂ =
    cong snd (run-additive n₁ n₂ (compound , c))
    ∙ cong (λ x → snd (run n₂ x))
        (ΣPathP ( code-rides n₁ compound c
                , phase-one n₁ c bnd ∙ reach
                  ∙ λ i → +-zero H (~ i) , t ))
    ∙ phase-two n₂ (0 , t)
