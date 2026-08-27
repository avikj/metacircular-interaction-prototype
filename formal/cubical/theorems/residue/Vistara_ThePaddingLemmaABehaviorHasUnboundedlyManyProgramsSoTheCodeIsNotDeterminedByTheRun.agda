{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- विस्तार — expansion.  THE PADDING LEMMA: A BEHAVIOR HAS UNBOUNDEDLY
-- MANY PROGRAMS, SO THE CODE IS NOT DETERMINED BY THE RUN.
--
-- Rules whose source states lie above everything a machine can reach
-- are dead weight: appending them changes the code and changes nothing
-- the tape ever sees.  This file proves it, and with it the classical
-- padding lemma for the universal machine of Vishvayantra:
--
--   `padding-invisible`  — for M bounded below B, pad entirely at or
--     above B, and a start state below B, every configuration of every
--     run of M ++ pad equals the corresponding configuration of M.
--
--   `padding-lemma`      — hence an INJECTION prog : ℕ → Code, all of
--     whose values run identically: the visible behavior map from
--     codes to runs has a fibre with unboundedly many points.
--
-- Read against Ekatva: the lossless completion of a map is unique —
-- but the CODE of a behavior is maximally non-unique.  The fibre that
-- is contractible is the trace of one fixed step; the fibre that is
-- infinite is the preimage of a behavior in the space of tables.  The
-- machinery is exact both ways, and both are checked.
--
-- Everything here is boolean-free: the lookup analysis proceeds by
-- generalizing over the witness (`Maybe (m ≡ n)`) the comparison
-- returns, never over a bit.
------------------------------------------------------------------------

module Vistara_ThePaddingLemmaABehaviorHasUnboundedlyManyProgramsSoTheCodeIsNotDeterminedByTheRun where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; injSuc ; inj-m+)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤-refl ; <≤-trans ; ¬m<m)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; length)
open import Cubical.Data.List.Properties using (length++)
open import Cubical.Data.Maybe
  using (Maybe ; nothing ; just ; rec ; map-Maybe ; just-inj ; ¬nothing≡just)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource

private
  Act : Type
  Act = ℕ × ℕ × Move

------------------------------------------------------------------------
-- §1  The comparison misses exactly when the numbers differ.
------------------------------------------------------------------------

eq?-miss : (m n : ℕ) → ¬ m ≡ n → eq? m n ≡ nothing
eq?-miss zero    zero    h = Empty.rec (h refl)
eq?-miss zero    (suc n) h = refl
eq?-miss (suc m) zero    h = refl
eq?-miss (suc m) (suc n) h =
  cong (map-Maybe (cong suc)) (eq?-miss m n (λ p → h (cong suc p)))

match-miss-state : (q s : ℕ) (r : Rule) → ¬ q ≡ fst r → match q s r ≡ nothing
match-miss-state q s (q₀ , s₀ , act) h =
  cong (rec nothing (λ _ → rec nothing (λ _ → just act) (eq? s s₀)))
       (eq?-miss q q₀ h)

-- A successful match hands back the rule's own action, nothing else.
match-just : (q s : ℕ) (r : Rule) (a : Act) →
  match q s r ≡ just a → snd (snd r) ≡ a
match-just q s (q₀ , s₀ , act) a = go (eq? q q₀)
  where
  go2 : (m2 : Maybe (s ≡ s₀)) →
        rec nothing (λ _ → just act) m2 ≡ just a → act ≡ a
  go2 nothing  h = Empty.rec (¬nothing≡just h)
  go2 (just _) h = just-inj act a h

  go : (m1 : Maybe (q ≡ q₀)) →
       rec nothing (λ _ → rec nothing (λ _ → just act) (eq? s s₀)) m1
         ≡ just a →
       act ≡ a
  go nothing  h = Empty.rec (¬nothing≡just h)
  go (just _) h = go2 (eq? s s₀) h

------------------------------------------------------------------------
-- §2  Bounded and dead tables.
------------------------------------------------------------------------

-- Every source and target state of the table lies strictly below B.
StatesBelow : ℕ → Code → Type
StatesBelow B []       = Unit
StatesBelow B (r ∷ rs) =
  (fst r < B) × (fst (snd (snd r)) < B) × StatesBelow B rs

-- Every source state of the table lies at or above B.
StatesAbove : ℕ → Code → Type
StatesAbove B []       = Unit
StatesAbove B (r ∷ rs) = (B ≤ fst r) × StatesAbove B rs

-- A table living above B is silent below B.
look-miss-above : (B q s : ℕ) (pad : Code) →
  StatesAbove B pad → q < B → look pad q s ≡ nothing
look-miss-above B q s []       _          _  = refl
look-miss-above B q s (r ∷ rs) (hr , hrs) qB =
  cong (λ m → rec (look rs q s) just m)
       (match-miss-state q s r
         (λ p → ¬m<m (subst (_< fst r) p (<≤-trans qB hr))))
  ∙ look-miss-above B q s rs hrs qB

-- Lookup over an appended table: the front is consulted first.
look-append : (xs ys : Code) (q s : ℕ) →
  look (xs ++ ys) q s ≡ rec (look ys q s) just (look xs q s)
look-append []       ys q s = refl
look-append (r ∷ xs) ys q s = go (match q s r)
  where
  go : (m : Maybe Act) →
       rec (look (xs ++ ys) q s) just m
         ≡ rec (look ys q s) just (rec (look xs q s) just m)
  go (just a) = refl
  go nothing  = look-append xs ys q s

-- What a bounded table addresses, it addresses below B.
look-target-below : (B q s : ℕ) (M : Code) → StatesBelow B M →
  (act : Act) → look M q s ≡ just act → fst act < B
look-target-below B q s []       _                 act h =
  Empty.rec (¬nothing≡just h)
look-target-below B q s (r ∷ rs) (_ , tB , rsB) act h =
  go (match q s r) refl h
  where
  go : (m : Maybe Act) → match q s r ≡ m →
       rec (look rs q s) just m ≡ just act → fst act < B
  go (just a) mp hp =
    subst (λ x → fst x < B) (match-just q s r a mp ∙ just-inj a act hp) tB
  go nothing  _  hp = look-target-below B q s rs rsB act hp

------------------------------------------------------------------------
-- §3  A bounded machine stays bounded.
------------------------------------------------------------------------

step-bound : (B : ℕ) (M : Code) → StatesBelow B M →
  (c : Conf) → fst c < B → fst (snd (uStep (M , c))) < B
step-bound B M MB (q , ls , hd , rs) qB =
  go (look M q hd) refl
  where
  g : Act → Conf
  g act = fst act , shift (snd (snd act)) (ls , fst (snd act) , rs)

  go : (m : Maybe Act) → look M q hd ≡ m →
       fst (rec (q , ls , hd , rs) (idfun Conf) (map-Maybe g m)) < B
  go nothing  _  = qB
  go (just a) lp = look-target-below B q hd M MB a lp

run-bound : (B : ℕ) (M : Code) → StatesBelow B M →
  (n : ℕ) (c : Conf) → fst c < B → fst (snd (run n (M , c))) < B
run-bound B M MB zero    c qB = qB
run-bound B M MB (suc n) c qB =
  run-bound B M MB n (snd (uStep (M , c))) (step-bound B M MB c qB)

------------------------------------------------------------------------
-- §4  Padding is invisible.
------------------------------------------------------------------------

look-same : (B : ℕ) (M pad : Code) → StatesAbove B pad →
  (q s : ℕ) → q < B → look (M ++ pad) q s ≡ look M q s
look-same B M pad padA q s qB =
  look-append M pad q s ∙ go (look M q s) refl
  where
  go : (m : Maybe Act) → look M q s ≡ m →
       rec (look pad q s) just m ≡ look M q s
  go (just a) lp = sym lp
  go nothing  lp = look-miss-above B q s pad padA qB ∙ sym lp

δ-same : (B : ℕ) (M pad : Code) → StatesAbove B pad →
  (c : Conf) → fst c < B → δ (M ++ pad) c ≡ δ M c
δ-same B M pad padA (q , ls , hd , rs) qB =
  cong (map-Maybe (λ act →
          fst act , shift (snd (snd act)) (ls , fst (snd act) , rs)))
       (look-same B M pad padA q hd qB)

-- THE INVISIBILITY.  Rule for rule, step for step, depth for depth:
-- the padded machine's configurations are the machine's own.
padding-invisible : (B : ℕ) (M pad : Code) →
  StatesBelow B M → StatesAbove B pad →
  (n : ℕ) (c : Conf) → fst c < B →
  snd (run n ((M ++ pad) , c)) ≡ snd (run n (M , c))
padding-invisible B M pad MB padA zero    c qB = refl
padding-invisible B M pad MB padA (suc n) c qB =
  cong (λ d → snd (run n ((M ++ pad) , rec c (idfun Conf) d)))
       (δ-same B M pad padA c qB)
  ∙ padding-invisible B M pad MB padA n
      (rec c (idfun Conf) (δ M c))
      (step-bound B M MB c qB)

------------------------------------------------------------------------
-- §5  The padding lemma.
------------------------------------------------------------------------

module _ (B : ℕ) where

  padRule : Rule
  padRule = B , 0 , B , 0 , stay

  pads : ℕ → Code
  pads zero    = padRule ∷ []
  pads (suc j) = padRule ∷ pads j

  pads-above : (j : ℕ) → StatesAbove B (pads j)
  pads-above zero    = ≤-refl , tt
  pads-above (suc j) = ≤-refl , pads-above j

  pads-length : (j : ℕ) → length (pads j) ≡ suc j
  pads-length zero    = refl
  pads-length (suc j) = cong suc (pads-length j)

-- THE THEOREM.  For every bounded machine there is an injection of ℕ
-- into Code all of whose values run identically: unboundedly many
-- programs, one behavior.  The code is not a function of the run.
padding-lemma : (B : ℕ) (M : Code) → StatesBelow B M →
  Σ[ prog ∈ (ℕ → Code) ]
    ( ((j k : ℕ) → prog j ≡ prog k → j ≡ k)
    × ((j n : ℕ) (c : Conf) → fst c < B →
         snd (run n (prog j , c)) ≡ snd (run n (M , c))) )
padding-lemma B M MB = prog , inj , same
  where
  prog : ℕ → Code
  prog j = M ++ pads B j

  inj : (j k : ℕ) → prog j ≡ prog k → j ≡ k
  inj j k p = injSuc
    (sym (pads-length B j)
     ∙ inj-m+ {m = length M}
         (sym (length++ M (pads B j)) ∙ cong length p ∙ length++ M (pads B k))
     ∙ pads-length B k)

  same : (j n : ℕ) (c : Conf) → fst c < B →
         snd (run n (prog j , c)) ≡ snd (run n (M , c))
  same j n c qB = padding-invisible B M (pads B j) MB (pads-above B j) n c qB
