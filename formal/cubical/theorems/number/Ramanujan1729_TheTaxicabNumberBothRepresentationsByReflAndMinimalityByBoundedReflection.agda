{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रामानुजन् १७२९ — THE TAXICAB NUMBER: BOTH REPRESENTATIONS BY REFL,
-- AND MINIMALITY BY BOUNDED REFLECTION.
--
-- Hardy: "a rather dull number."  Ramanujan: "no — the smallest number
-- expressible as the sum of two cubes in two different ways."  This
-- file checks Ramanujan, completely:
--
--   1³ + 12³ ≡ 1729 ≡ 9³ + 10³,  both by refl (`first-way`,
--   `second-way`), and the two ways are distinct (`the-ways-differ`).
--
-- MINIMALITY is the real content, and it is proved, not sampled.  The
-- engine is boolean-free bounded reflection: a scanner visits every
-- quadruple 1 ≤ a,b,c,d ≤ 12, and answers each with a Maybe-witness —
-- the comparison returns Maybe (m ≡ n), the floor check returns
-- Maybe (1729 ≤ s) — and the whole scan evaluates to just tt by ONE
-- refl (`scan-ok`: 20736 quadruples, normalized by the kernel).
-- Soundness lemmas convert the computation into the theorem
-- (`collision-bound`): colliding representations with parts ≤ 12
-- agree, agree swapped, or sit at 1729 or beyond.  A cube-growth
-- argument (`parts-are-small`: 13³ = 2197 already overshoots) shows
-- parts of any representation below 1729 are ≤ 12, and the halves
-- assemble into
--
--   `ramanujan-was-right` : any number below 1729 has, up to order,
--   at most one representation as a sum of two positive cubes.
--
-- Deterministic work: the kernel did the 20736 cases; the lemmas did
-- the rest; nothing is asserted that did not compute or derive.
------------------------------------------------------------------------

module Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; znots ; injSuc ; ·-comm ; +-comm)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; zero-≤ ; suc-≤-suc ; pred-≤-pred ; ¬-<-zero ; ¬m<m ;
         ≤-trans ; ≤<-trans ; <≤-trans ; <-split ; splitℕ-≤ ; ≤-·k ; ≤SumLeft)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Maybe
  using (Maybe ; nothing ; just ; rec ; map-Maybe ; ¬nothing≡just)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (eq?)

------------------------------------------------------------------------
-- §1  Cubes, and the two ways.
------------------------------------------------------------------------

cube : ℕ → ℕ
cube n = n · (n · n)

S² : ℕ → ℕ → ℕ
S² a b = cube a + cube b

first-way : S² 1 12 ≡ 1729
first-way = refl

second-way : S² 9 10 ≡ 1729
second-way = refl

the-ways-differ : ¬ Path (ℕ × ℕ) (1 , 12) (9 , 10)
the-ways-differ p = znots (injSuc (cong fst p))

------------------------------------------------------------------------
-- §2  Witness-typed comparison toolkit.
------------------------------------------------------------------------

le? : (m n : ℕ) → Maybe (m ≤ n)
le? zero    n       = just zero-≤
le? (suc m) zero    = nothing
le? (suc m) (suc n) = map-Maybe suc-≤-suc (le? m n)

eq?-complete : (m n : ℕ) → eq? m n ≡ nothing → ¬ m ≡ n
eq?-complete zero    zero    h = Empty.rec (¬nothing≡just (sym h))
eq?-complete zero    (suc n) h = λ p → znots p
eq?-complete (suc m) zero    h = λ p → znots (sym p)
eq?-complete (suc m) (suc n) h =
  λ p → eq?-complete m n (strip (eq? m n) refl) (injSuc p)
  where
  strip : (x : Maybe (m ≡ n)) → eq? m n ≡ x → eq? m n ≡ nothing
  strip nothing  e = e
  strip (just q) e =
    Empty.rec (¬nothing≡just
      (sym (sym (cong (map-Maybe (cong suc)) e) ∙ h)))

------------------------------------------------------------------------
-- §3  The scanner: top-level stages so soundness can name them.
------------------------------------------------------------------------

bndM : ℕ → ℕ → Maybe Unit
bndM a b = rec nothing (λ _ → just tt) (le? 1729 (S² a b))

swpM : ℕ → ℕ → ℕ → ℕ → Maybe Unit
swpM a b c d =
  rec (bndM a b) (λ _ → rec (bndM a b) (λ _ → just tt) (eq? b c)) (eq? a d)

dirM : ℕ → ℕ → ℕ → ℕ → Maybe Unit
dirM a b c d =
  rec (swpM a b c d) (λ _ → rec (swpM a b c d) (λ _ → just tt) (eq? b d))
      (eq? a c)

leafM : ℕ → ℕ → ℕ → ℕ → Maybe Unit
leafM a b c d = rec (just tt) (λ _ → dirM a b c d) (eq? (S² a b) (S² c d))

mand : Maybe Unit → Maybe Unit → Maybe Unit
mand (just _) y = y
mand nothing  _ = nothing

loop : (ℕ → Maybe Unit) → ℕ → Maybe Unit
loop f zero    = f zero
loop f (suc n) = mand (f (suc n)) (loop f n)

-- THE SCAN: all 20736 quadruples of 1..12, one normalization, with
-- each stage named so soundness can address it.
fD : ℕ → ℕ → ℕ → ℕ → Maybe Unit
fD a b c d = leafM (suc a) (suc b) (suc c) (suc d)

fC : ℕ → ℕ → ℕ → Maybe Unit
fC a b c = loop (fD a b c) 11

fB : ℕ → ℕ → Maybe Unit
fB a b = loop (fC a b) 11

fA : ℕ → Maybe Unit
fA a = loop (fB a) 11

scan : Maybe Unit
scan = loop fA 11

scan-ok : scan ≡ just tt
scan-ok = refl

------------------------------------------------------------------------
-- §4  Soundness: the computation is the theorem.
------------------------------------------------------------------------

Out : ℕ → ℕ → ℕ → ℕ → Type
Out a b c d =
  ((a ≡ c) × (b ≡ d)) ⊎ (((a ≡ d) × (b ≡ c)) ⊎ (1729 ≤ S² a b))

bndM-sound : (a b : ℕ) → bndM a b ≡ just tt → 1729 ≤ S² a b
bndM-sound a b h = go (le? 1729 (S² a b)) refl
  where
  go : (w : Maybe (1729 ≤ S² a b)) → le? 1729 (S² a b) ≡ w → 1729 ≤ S² a b
  go (just x) _  = x
  go nothing  pw =
    Empty.rec (¬nothing≡just
      (sym (cong (rec nothing (λ _ → just tt)) pw) ∙ h))

swpM-sound : (a b c d : ℕ) → swpM a b c d ≡ just tt →
             ((a ≡ d) × (b ≡ c)) ⊎ (1729 ≤ S² a b)
swpM-sound a b c d h = go (eq? a d) refl
  where
  inner : (p : a ≡ d) →
          rec (bndM a b) (λ _ → just tt) (eq? b c) ≡ just tt →
          ((a ≡ d) × (b ≡ c)) ⊎ (1729 ≤ S² a b)
  inner p h2 = go2 (eq? b c) refl
    where
    go2 : (w : Maybe (b ≡ c)) → eq? b c ≡ w →
          ((a ≡ d) × (b ≡ c)) ⊎ (1729 ≤ S² a b)
    go2 (just q) _  = inl (p , q)
    go2 nothing  pw =
      inr (bndM-sound a b
        (sym (cong (rec (bndM a b) (λ _ → just tt)) pw) ∙ h2))

  go : (w : Maybe (a ≡ d)) → eq? a d ≡ w →
       ((a ≡ d) × (b ≡ c)) ⊎ (1729 ≤ S² a b)
  go (just p) pw =
    inner p
      (sym (cong (rec (bndM a b)
                      (λ _ → rec (bndM a b) (λ _ → just tt) (eq? b c))) pw)
       ∙ h)
  go nothing  pw =
    inr (bndM-sound a b
      (sym (cong (rec (bndM a b)
                      (λ _ → rec (bndM a b) (λ _ → just tt) (eq? b c))) pw)
       ∙ h))

dirM-sound : (a b c d : ℕ) → dirM a b c d ≡ just tt → Out a b c d
dirM-sound a b c d h = go (eq? a c) refl
  where
  step : swpM a b c d ≡ just tt → Out a b c d
  step h' = go' (swpM-sound a b c d h')
    where
    go' : ((a ≡ d) × (b ≡ c)) ⊎ (1729 ≤ S² a b) → Out a b c d
    go' (inl x) = inr (inl x)
    go' (inr w) = inr (inr w)

  inner : (p : a ≡ c) →
          rec (swpM a b c d) (λ _ → just tt) (eq? b d) ≡ just tt →
          Out a b c d
  inner p h2 = go2 (eq? b d) refl
    where
    go2 : (w : Maybe (b ≡ d)) → eq? b d ≡ w → Out a b c d
    go2 (just q) _  = inl (p , q)
    go2 nothing  pw =
      step (sym (cong (rec (swpM a b c d) (λ _ → just tt)) pw) ∙ h2)

  go : (w : Maybe (a ≡ c)) → eq? a c ≡ w → Out a b c d
  go (just p) pw =
    inner p
      (sym (cong (rec (swpM a b c d)
                      (λ _ → rec (swpM a b c d) (λ _ → just tt) (eq? b d))) pw)
       ∙ h)
  go nothing  pw =
    step (sym (cong (rec (swpM a b c d)
                    (λ _ → rec (swpM a b c d) (λ _ → just tt) (eq? b d))) pw)
          ∙ h)

leafM-sound : (a b c d : ℕ) → leafM a b c d ≡ just tt →
              S² a b ≡ S² c d → Out a b c d
leafM-sound a b c d h sums = go (eq? (S² a b) (S² c d)) refl
  where
  go : (w : Maybe (S² a b ≡ S² c d)) → eq? (S² a b) (S² c d) ≡ w →
       Out a b c d
  go (just _) pw =
    dirM-sound a b c d
      (sym (cong (rec (just tt) (λ _ → dirM a b c d)) pw) ∙ h)
  go nothing  pw = Empty.rec (eq?-complete _ _ pw sums)

mand-just : (x y : Maybe Unit) → mand x y ≡ just tt →
            (x ≡ just tt) × (y ≡ just tt)
mand-just (just tt) y h = refl , h
mand-just nothing   y h = Empty.rec (¬nothing≡just h)

loop-sound : (f : ℕ → Maybe Unit) (n : ℕ) → loop f n ≡ just tt →
             (k : ℕ) → k ≤ n → f k ≡ just tt
loop-sound f zero    h k kn = go (<-split (suc-≤-suc kn))
  where
  go : (k < zero) ⊎ (k ≡ zero) → f k ≡ just tt
  go (inl k0) = Empty.rec (¬-<-zero k0)
  go (inr k0) = subst (λ x → f x ≡ just tt) (sym k0) h
loop-sound f (suc n) h k kn = go (<-split (suc-≤-suc kn))
  where
  hs : (f (suc n) ≡ just tt) × (loop f n ≡ just tt)
  hs = mand-just (f (suc n)) (loop f n) h

  go : (k < suc n) ⊎ (k ≡ suc n) → f k ≡ just tt
  go (inl kn') = loop-sound f n (snd hs) k (pred-≤-pred kn')
  go (inr k≡)  = subst (λ x → f x ≡ just tt) (sym k≡) (fst hs)

-- Any collision among cubes of 1..12 is the taxicab's, up to order,
-- or sits at 1729 or beyond.
collision-bound : (a b c d : ℕ) →
  a ≤ 11 → b ≤ 11 → c ≤ 11 → d ≤ 11 →
  S² (suc a) (suc b) ≡ S² (suc c) (suc d) →
  Out (suc a) (suc b) (suc c) (suc d)
collision-bound a b c d ha hb hc hd sums =
  leafM-sound (suc a) (suc b) (suc c) (suc d)
    (loop-sound (fD a b c) 11
      (loop-sound (fC a b) 11
        (loop-sound (fB a) 11
          (loop-sound fA 11 scan-ok a ha) b hb) c hc) d hd)
    sums

------------------------------------------------------------------------
-- §5  Parts of a small sum are small: 13³ already overshoots.
------------------------------------------------------------------------

≤-k· : {m n : ℕ} (k : ℕ) → m ≤ n → k · m ≤ k · n
≤-k· {m} {n} k h =
  subst (_≤ k · n) (·-comm m k)
    (subst (m · k ≤_) (·-comm n k) (≤-·k h))

cube-mono : {m n : ℕ} → m ≤ n → cube m ≤ cube n
cube-mono {m} {n} h =
  ≤-trans (≤-·k {k = m · m} h)
          (≤-k· n (≤-trans (≤-·k {k = m} h) (≤-k· n h)))

1729≤2197 : 1729 ≤ 2197
1729≤2197 = 468 , refl

parts-are-small : (a b m : ℕ) → m < 1729 → S² a b ≡ m → a ≤ 12
parts-are-small a b m mlt sums = go (splitℕ-≤ a 12)
  where
  go : (a ≤ 12) ⊎ (12 < a) → a ≤ 12
  go (inl h)   = h
  go (inr h13) =
    Empty.rec (¬m<m (<≤-trans (≤<-trans t2 mlt) 1729≤2197))
    where
    t2 : 2197 ≤ m
    t2 = subst (2197 ≤_) sums (≤-trans (cube-mono h13) ≤SumLeft)

------------------------------------------------------------------------
-- §6  THE THEOREM.
------------------------------------------------------------------------

-- Any number below 1729 has, up to order, at most one representation
-- as a sum of two positive cubes.
ramanujan-was-right : (m : ℕ) → m < 1729 →
  (a b c d : ℕ) → 1 ≤ a → 1 ≤ b → 1 ≤ c → 1 ≤ d →
  S² a b ≡ m → S² c d ≡ m →
  ((a ≡ c) × (b ≡ d)) ⊎ ((a ≡ d) × (b ≡ c))
ramanujan-was-right m mlt zero b c d pa _ _ _ _ _ = Empty.rec (¬-<-zero pa)
ramanujan-was-right m mlt (suc a) zero c d _ pb _ _ _ _ =
  Empty.rec (¬-<-zero pb)
ramanujan-was-right m mlt (suc a) (suc b) zero d _ _ pc _ _ _ =
  Empty.rec (¬-<-zero pc)
ramanujan-was-right m mlt (suc a) (suc b) (suc c) zero _ _ _ pd _ _ =
  Empty.rec (¬-<-zero pd)
ramanujan-was-right m mlt (suc a) (suc b) (suc c) (suc d) _ _ _ _ s1 s2 =
  go (collision-bound a b c d
       (pred-≤-pred (parts-are-small (suc a) (suc b) m mlt s1))
       (pred-≤-pred (parts-are-small (suc b) (suc a) m mlt
         (+-comm (cube (suc b)) (cube (suc a)) ∙ s1)))
       (pred-≤-pred (parts-are-small (suc c) (suc d) m mlt s2))
       (pred-≤-pred (parts-are-small (suc d) (suc c) m mlt
         (+-comm (cube (suc d)) (cube (suc c)) ∙ s2)))
       (s1 ∙ sym s2))
  where
  go : Out (suc a) (suc b) (suc c) (suc d) →
       ((suc a ≡ suc c) × (suc b ≡ suc d))
         ⊎ ((suc a ≡ suc d) × (suc b ≡ suc c))
  go (inl x)       = inl x
  go (inr (inl x)) = inr x
  go (inr (inr w)) =
    Empty.rec (¬m<m (≤<-trans (subst (1729 ≤_) s1 w) mlt))
