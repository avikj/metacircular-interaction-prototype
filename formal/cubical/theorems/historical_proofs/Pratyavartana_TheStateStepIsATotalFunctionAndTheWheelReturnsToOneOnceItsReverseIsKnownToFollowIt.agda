{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रत्यावर्तनम् · the state step is a total function, and the wheel
-- returns to one once its reverse is known to follow it.
--
-- THE ABSENCES, verbatim.
--
-- CakravalaBound, "THE SCOPE, EXACTLY":
--   "* TERMINATION IS STILL OPEN.  A bound on |k| is not termination.
--      What the bound buys is that the state (a mod ·, b mod ·, k) ranges
--      over a FINITE set, so some state must recur; turning that into
--      \"the wheel returns to k = ±1\" needs, in addition: that the
--      triples with a fixed k and bounded a, b are finite (a reduction
--      theory), and that the cycle cannot stall.  None of that is here.
--    * MINIMALITY OF BHĀSKARA'S CHOICE is not proved — it is a HYPOTHESIS
--      of `cakravalaKBound`, discharged by whoever runs the algorithm."
--
-- GunakaKsepa_TheWheelsStateIsBoundedAndSelfPropagating:
--   "* DETERMINISM IS NOT COMPLETE.  §5 gives that −m solves the next
--      congruence ... the class of −m, which needs gcd(b', k') = 1 — the
--      same coprimality ... A tie is a genuine branch, not an oversight,
--      and it is what stands between §5 and a determinism theorem."
--
-- WHAT IS PROVED HERE.  The wheel is run on the state (गुणक, क्षेप) =
-- (m, K) alone — the pair of GunakaKsepa's title — as a TOTAL FUNCTION
-- `step : ℕ → State → State`, with Bhāskara's minimisation made a
-- function by a bounded downward search (§०) and the tie broken toward
-- the lower candidate (the reactor's `minimumBy` on an ascending list;
-- `chooseOpp` is the same rule with the other tie-break).
--
--   §१–§५  Each quantity of a turn is a total function on ℕ, and does
--          what its name says: `quotSpec` (exact quotient), `negRepSpec`
--          (the representative of −m in [1, K]), `loSpec` (lo and hi
--          bracket the root), `chooseInClass`, and `chooseMin` —
--          BHĀSKARA'S RULE VERIFIED: the chosen multiplier minimises
--          |x² − D| over the whole class, in the form CakravalaBound's
--          `cakravalaKBound` takes on trust.
--   §६     `stepInv`: the invariant K' ∣ m'² − D propagates to the next
--          turn with its cofactor written out, with NO coprimality:
--          m' ≡ −m (mod K') gives m'² ≡ m² ≡ D (mod K').
--   §७     `stepGood`, `seedGood`, `allGood`: every orbit state carries
--          1 ≤ K, K² ≤ 4D, the invariant, and reducedness; `goodBox`
--          puts the orbit in GunakaKsepa's box.
--   §८     `Reversible D s := rev D (step D s) ≡ s`.  On reversible
--          states the step is injective (`stepInj`), a repeat backs up to
--          the seed (`backtrack`), and — THE CONDITIONAL THEOREM —
--          `returnsToSeed` / `returnsToOne`: for non-square D and
--          4D < B², if every orbit state is reversible then the wheel
--          returns to क्षेप = 1 within B² turns.  The pigeonhole is
--          GunakaKsepa's अवस्था-पुनरावृत्तिः on the box.
--   §९     `reversibleOfGunaka`: reversibility is exactly one condition
--          on the गुणक — m is the opposite-tie-break minimiser over the
--          class of −m' at the next state.  The क्षेप half is automatic.
--   §१०    `revAll`: a return to the seed at turn p makes the orbit
--          p-periodic, so reversibility need only be checked on p turns.
--   §११    The sign of the क्षेप is a passenger: `signedReturn`, and
--          `returnsToPlusOne` — LAGRANGE IN THE WHEEL'S OWN TERMS, MODULO
--          REVERSIBILITY: the signed क्षेप returns to +1 within 2B² turns.
--   §१२    `त्रि-भागहारः`: the (a, b)-wheel follows the (m, k)-shadow
--          exactly, without coprimality — three ring identities over ℤ.
--   §१३    In the kernel: D = 61 (period 7, k₇ = −1, k₁₄ = +1; Lagrange
--          at 61 from the theorem with B = 16), D = 2, 3, 13; and the two
--          things the numbers show: the step is NOT injective on the box
--          (D = 2: (2,2) and (1,1) collide), and TIES are real (D = 29,
--          class 3 mod 4: the same-tie-break reverse fails to invert the
--          step on the orbit while the opposite-tie-break reverse
--          inverts it at every turn).
--
-- WHAT IS NOT PROVED.  Reversibility along the orbit is a HYPOTHESIS of
-- `returnsToSeed`; it is discharged here only for D = 2, 3, 13, 29, 61
-- by the kernel.  That the forward rule is reversible in general — i.e.
-- that the opposite-tie-break reverse always follows the step — is the
-- gcd/tie-break gap GunakaKsepa names, and it is exactly what stands
-- between this module and termination.  Lagrange's theorem for general
-- D is not proved.  Nothing about the continued fraction of √D.
--
-- ENGINEERING NOTE.  `State` is a record WITHOUT η (see §२): with η the
-- step reduces on every open state through its projections and each
-- conversion unfolds the whole search machinery; two `with`-abstractions
-- (`fromRepeat`, `nonSquareBetween`) were replaced by explicit case
-- functions for the same reason, and `Reversible` is a data wrapper.
-- Checked at the pin (Agda 2.8.0, agda/cubical v0.9, --safe), about
-- fifteen minutes, most of it the kernel instances of §१३.  No
-- postulates, no holes, no TERMINATING pragmas.
------------------------------------------------------------------------

module Pratyavartana_TheStateStepIsATotalFunctionAndTheWheelReturnsToOneOnceItsReverseIsKnownToFollowIt where

open import Cubical.Foundations.Prelude

open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_ ; +-comm ; +-assoc ; ·-comm ; +-suc ; +-zero
        ; inj-m+ ; inj-+m ; ·-identityˡ ; ·-identityʳ ; snotz ; znots ; injSuc
        ; m+n≡0→m≡0×n≡0 ; 0≡m·0 ; ·-suc)
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import Cubical.Tactics.NatSolver using (solveℕ!)

open import Cubical.Data.Fin using (Fin ; toℕ-injective)
open import Cubical.Data.Nat.Mod using (remainder_/_ ; quotient_/_ ; ≡remainder+quotient ; mod<)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)

open import CakravalaBound using (diffNat ; straddleExists ; straddleBound ; cakravalaKBound)
open import GunakaKsepa_TheWheelsStateIsBoundedAndSelfPropagating
  using (गुणक-बन्धः ; कोष्ठकः ; अवस्था-पुनरावृत्तिः)

------------------------------------------------------------------------
-- ० · the search.  `sd P dec J` walks DOWN from J and returns the least
-- j ≤ J with P j, provided P J holds and P is upward closed; it is
-- `CakravalaBound.firstHit` returning the index instead of a proof, so
-- that it can sit inside a FUNCTION and be run by the kernel.
------------------------------------------------------------------------

sd    : (P : ℕ → Type) → ((n : ℕ) → Dec (P n)) → ℕ → ℕ
sdAux : (P : ℕ → Type) → ((n : ℕ) → Dec (P n)) → (J : ℕ) → Dec (P J) → ℕ

sd P dec zero    = zero
sd P dec (suc J) = sdAux P dec J (dec J)
sdAux P dec J (yes _) = sd P dec J
sdAux P dec J (no _)  = suc J

-- the two facts: the result satisfies P if the bound does, and its
-- predecessor (when it has one) does not.
sdHit : (P : ℕ → Type) (dec : (n : ℕ) → Dec (P n)) (J : ℕ) → P J → P (sd P dec J)
sdHitAux : (P : ℕ → Type) (dec : (n : ℕ) → Dec (P n)) (J : ℕ) (w : Dec (P J))
         → P (suc J) → P (sdAux P dec J w)
sdHit P dec zero p    = p
sdHit P dec (suc J) p = sdHitAux P dec J (dec J) p
sdHitAux P dec J (yes q) p = sdHit P dec J q
sdHitAux P dec J (no _)  p = p

sdPred : (P : ℕ → Type) (dec : (n : ℕ) → Dec (P n)) (J i : ℕ) → sd P dec J ≡ suc i → ¬ P i
sdPredAux : (P : ℕ → Type) (dec : (n : ℕ) → Dec (P n)) (J i : ℕ) (w : Dec (P J))
          → sdAux P dec J w ≡ suc i → ¬ P i
sdPred P dec zero i e    = ⊥rec (znots e)
sdPred P dec (suc J) i e = sdPredAux P dec J i (dec J) e
sdPredAux P dec J i (yes q) e = sdPred P dec J i e
sdPredAux P dec J i (no ¬q) e = λ p → ¬q (subst P (sym (injSuc e)) p)

------------------------------------------------------------------------
-- १ · the quantities of one turn, each a total function on ℕ.
------------------------------------------------------------------------

-- E D m = |m² − D|, with its sign kept alongside (`CakravalaBound.diffNat`).
E : ℕ → ℕ → ℕ
E D m = fst (diffNat (m · m) D)

Espec : (D m : ℕ) → (m · m ≡ D + E D m) ⊎ (D ≡ m · m + E D m)
Espec D m = snd (diffNat (m · m) D)

-- exact quotient: the least c with x ≤ K·c.  Equals x/K when K | x.
quot : ℕ → ℕ → ℕ
quot K x = sd (λ c → x ≤ K · c) (λ c → ≤Dec x (K · c)) x

-- the representative of −m mod K in [1, K]: the least j with m < j·K,
-- then j·K − m.
negIx : ℕ → ℕ → ℕ
negIx K m = sd (λ j → m < j · K) (λ j → <Dec m (j · K)) (suc m)

negRep : ℕ → ℕ → ℕ
negRep K m = negIx K m · K ∸ m

-- Bhāskara's minimisation over the class r mod K, 1 ≤ r ≤ K.  `loIx` is
-- the least j with D < (r + (j+1)K)², so lo = r + jK is the last member
-- of the class at or below the root (or r itself if r is already above
-- it) and hi = lo + K the first above.  The rule picks whichever has the
-- smaller |x² − D|; ON A TIE IT PICKS lo — the reactor's `minimumBy` on
-- an ascending list — and `chooseOpp` is the same rule picking hi.
loIx : ℕ → ℕ → ℕ → ℕ
loIx D K r = sd (λ j → D < (r + suc j · K) · (r + suc j · K))
                (λ j → <Dec D ((r + suc j · K) · (r + suc j · K))) D

lo hi : ℕ → ℕ → ℕ → ℕ
lo D K r = r + loIx D K r · K
hi D K r = lo D K r + K

pick : {A : Type} → Dec A → ℕ → ℕ → ℕ
pick (yes _) x y = x
pick (no _)  x y = y

choose chooseOpp : ℕ → ℕ → ℕ → ℕ
choose    D K r = pick (≤Dec (E D (lo D K r)) (E D (hi D K r))) (lo D K r) (hi D K r)
chooseOpp D K r = pick (≤Dec (E D (hi D K r)) (E D (lo D K r))) (hi D K r) (lo D K r)

------------------------------------------------------------------------
-- २ · THE STEP, on the state (गुणक, क्षेप) = (m, K) alone.
------------------------------------------------------------------------

-- The state is a record WITHOUT η: `step D s` on an open s must stay
-- stuck, or every conversion unfolds the whole search machinery (with
-- η, `step D s` reduces on any s through its projections).  The
-- constructor and projections overload Σ's, so states are still written
-- (m , K), fst, snd.
record State : Type where
  no-eta-equality
  pattern
  constructor _,_
  field
    fst : ℕ
    snd : ℕ
open State

toPair : State → ℕ × ℕ
toPair (m , K) = m , K

toPair-inj : (s t : State) → toPair s ≡ toPair t → s ≡ t
toPair-inj (m , K) (m' , K') e i = fst (e i) , snd (e i)

≡-State : {s t : State} → fst s ≡ fst t → snd s ≡ snd t → s ≡ t
≡-State {m , K} {m' , K'} p q i = p i , q i

boxPair : {B : ℕ} (s : State) → (fst s < B) × (snd s < B)
        → (fst (toPair s) < B) × (snd (toPair s) < B)
boxPair (m , K) h = h

step : ℕ → State → State
step D (m , K) = choose D K' (negRep K' m) , K'
  where K' = quot K (E D m)

-- the reverse: the same rule read backwards, with the opposite tie-break.
rev : ℕ → State → State
rev D (m' , K') = m , quot K' (E D m)
  where m = chooseOpp D K' (negRep K' m')

seed : ℕ → State
seed D = choose D 1 1 , 1

orbit : ℕ → ℕ → State
orbit D zero    = seed D
orbit D (suc n) = step D (orbit D n)


------------------------------------------------------------------------
-- ३ · order toolkit (the same four small lemmas the earlier modules keep
-- private, restated).
------------------------------------------------------------------------

private
  ≤-k·' : {m n : ℕ} (k : ℕ) → m ≤ n → k · m ≤ k · n
  ≤-k·' {m} {n} k h = subst2 _≤_ (·-comm m k) (·-comm n k) (≤-·k {k = k} h)

  sq-mono : {m n : ℕ} → m ≤ n → m · m ≤ n · n
  sq-mono {m} {n} h = ≤-trans (≤-·k {k = m} h) (≤-k·' n h)

  ¬≤→< : {a b : ℕ} → ¬ (a ≤ b) → b < a
  ¬≤→< {a} {b} h with splitℕ-≤ a b
  ... | inl p = ⊥rec (h p)
  ... | inr q = q

  ¬<→≤ : {a b : ℕ} → ¬ (a < b) → b ≤ a
  ¬<→≤ {a} {b} h with splitℕ-< a b
  ... | inl p = ⊥rec (h p)
  ... | inr q = q

  posPred : (c : ℕ) → 1 ≤ c → Σ[ c' ∈ ℕ ] c ≡ suc c'
  posPred c (k , hk) = k , sym hk ∙ +-comm k 1

  ·-cancel-≤ : (c x y : ℕ) → 1 ≤ c → c · x ≤ c · y → x ≤ y
  ·-cancel-≤ c x y hc h with splitℕ-≤ x y
  ... | inl p = p
  ... | inr y<x =
        let (c' , hc') = posPred c hc
            stepB : c · y < c · x
            stepB = subst2 _<_ (·-comm y (suc c') ∙ cong (_· y) (sym hc'))
                               (·-comm x (suc c') ∙ cong (_· x) (sym hc'))
                               (<-·sk y<x)
        in ⊥rec (¬m<m (<≤-trans stepB h))

  ·-cancel-< : (c x y : ℕ) → c · x < c · y → x < y
  ·-cancel-< c x y h with splitℕ-< x y
  ... | inl p = p
  ... | inr y≤x = ⊥rec (¬m<m (<≤-trans h (≤-k·' c y≤x)))

  caseℕ : (n : ℕ) → (n ≡ 0) ⊎ (Σ[ i ∈ ℕ ] n ≡ suc i)
  caseℕ zero    = inl refl
  caseℕ (suc i) = inr (i , refl)

  pickSpec : {A : Type} (w : Dec A) (x y : ℕ)
           → ((pick w x y ≡ x) × A) ⊎ ((pick w x y ≡ y) × (¬ A))
  pickSpec (yes a) x y = inl (refl , a)
  pickSpec (no ¬a) x y = inr (refl , ¬a)

------------------------------------------------------------------------
-- ४ · |x² − D| determines and is determined by its signed form.
------------------------------------------------------------------------

Euniq : (D x X : ℕ) → (x · x ≡ D + X) ⊎ (D ≡ x · x + X) → X ≡ E D x
Euniq D x X h = go h (Espec D x)
  where
  go : (x · x ≡ D + X) ⊎ (D ≡ x · x + X)
     → (x · x ≡ D + E D x) ⊎ (D ≡ x · x + E D x) → X ≡ E D x
  go (inl a) (inl b) = inj-m+ {m = D} (sym a ∙ b)
  go (inr a) (inr b) = inj-m+ {m = x · x} (sym a ∙ b)
  go (inl a) (inr b) =
    let z : E D x + X ≡ 0
        z = sym (inj-m+ {m = x · x}
                  (+-zero (x · x) ∙ a ∙ cong (_+ X) b ∙ sym (+-assoc (x · x) (E D x) X)))
        zz = m+n≡0→m≡0×n≡0 z
    in snd zz ∙ sym (fst zz)
  go (inr a) (inl b) =
    let z : E D x + X ≡ 0
        z = sym (inj-m+ {m = D}
                  (+-zero D ∙ a ∙ cong (_+ X) b ∙ sym (+-assoc D (E D x) X)))
        zz = m+n≡0→m≡0×n≡0 z
    in snd zz ∙ sym (fst zz)

Ebelow : (D x : ℕ) → x · x ≤ D → D ≡ x · x + E D x
Ebelow D x h = go (Espec D x)
  where
  go : (x · x ≡ D + E D x) ⊎ (D ≡ x · x + E D x) → D ≡ x · x + E D x
  go (inr b) = b
  go (inl a) =
    let D≡ : D ≡ x · x
        D≡ = ≤-antisym (E D x , +-comm (E D x) D ∙ sym a) h
        E0 : 0 ≡ E D x
        E0 = inj-m+ {m = x · x} (+-zero (x · x) ∙ a ∙ cong (_+ E D x) D≡)
    in D≡ ∙ sym (+-zero (x · x)) ∙ cong (x · x +_) E0

Eabove : (D x : ℕ) → D ≤ x · x → x · x ≡ D + E D x
Eabove D x h = go (Espec D x)
  where
  go : (x · x ≡ D + E D x) ⊎ (D ≡ x · x + E D x) → x · x ≡ D + E D x
  go (inl a) = a
  go (inr b) =
    let x≡ : x · x ≡ D
        x≡ = ≤-antisym (E D x , +-comm (E D x) (x · x) ∙ sym b) h
        E0 : 0 ≡ E D x
        E0 = inj-m+ {m = D} (+-zero D ∙ b ∙ cong (_+ E D x) x≡)
    in x≡ ∙ sym (+-zero D) ∙ cong (D +_) E0

------------------------------------------------------------------------
-- ५ · the three searches do what their names say.
------------------------------------------------------------------------

-- exact division: when x = K·c with K ≥ 1, `quot K x` is c.
quotSpec : (K c x : ℕ) → 1 ≤ K → x ≡ K · c → quot K x ≡ c
quotSpec K c x hK hx = ≤-antisym q≤c c≤q
  where
  P : ℕ → Type
  P c' = x ≤ K · c'
  dec : (c' : ℕ) → Dec (P c')
  dec c' = ≤Dec x (K · c')
  q = sd P dec x
  Px : P x
  Px = subst (_≤ K · x) (·-identityˡ x) (≤-·k {k = x} hK)
  Pq : x ≤ K · q
  Pq = sdHit P dec x Px
  c≤q : c ≤ q
  c≤q = ·-cancel-≤ K c q hK (subst (_≤ K · q) hx Pq)
  q≤c : q ≤ c
  q≤c with caseℕ q
  ... | inl e = subst (_≤ c) (sym e) zero-≤
  ... | inr (i , e) =
        let ¬Pi : ¬ (x ≤ K · i)
            ¬Pi = sdPred P dec x i e
            Ki<x : K · i < K · c
            Ki<x = subst (K · i <_) hx (¬≤→< ¬Pi)
        in subst (_≤ c) (sym e) (·-cancel-< K i c Ki<x)

-- the representative of −m: 1 ≤ r ≤ K and m + r ≡ j·K.
negRepSpec : (K m : ℕ) → 1 ≤ K
           → (m + negRep K m ≡ negIx K m · K) × (1 ≤ negRep K m) × (negRep K m ≤ K)
negRepSpec K m hK = eqR , one , le
  where
  P : ℕ → Type
  P j = m < j · K
  dec : (j : ℕ) → Dec (P j)
  dec j = <Dec m (j · K)
  j₀ = sd P dec (suc m)
  r = negRep K m
  Ptop : m < suc m · K
  Ptop = ≤-+-≤ hK (subst (_≤ m · K) (·-identityʳ m) (≤-k·' m hK))
  Pj₀ : m < j₀ · K
  Pj₀ = sdHit P dec (suc m) Ptop
  eqR : m + r ≡ j₀ · K
  eqR = +-comm m r ∙ ≤-∸-+-cancel (<-weaken Pj₀)
  one : 1 ≤ r
  one = ≤-k+-cancel {k = m} (subst (_≤ m + r) (+-comm 1 m) (subst (suc m ≤_) (sym eqR) Pj₀))
  le : r ≤ K
  le with caseℕ j₀
  ... | inl e = ⊥rec (¬-<-zero (subst (λ w → m < w · K) e Pj₀))
  ... | inr (i , e) =
        let iK≤m : i · K ≤ m
            iK≤m = ¬<→≤ (sdPred P dec (suc m) i e)
            h1 : m + r ≡ K + i · K
            h1 = eqR ∙ cong (_· K) e
            h2 : K + i · K ≤ K + m
            h2 = ≤-k+ {k = K} iK≤m
        in ≤-+k-cancel {k = m} (subst (_≤ K + m) (+-comm m r) (subst (_≤ K + m) (sym h1) h2))

private
  hiEqId : (r j K : ℕ) → (r + j · K) + K ≡ r + (K + j · K)
  hiEqId r j K = solveℕ!

hiEq : (D K r : ℕ) → hi D K r ≡ r + suc (loIx D K r) · K
hiEq D K r = hiEqId r (loIx D K r) K

-- lo and hi bracket the root: D < hi², and lo² ≤ D unless lo = r.
loSpec : (D K r : ℕ) → 1 ≤ K → 1 ≤ r
       → (D < hi D K r · hi D K r) × ((loIx D K r ≡ 0) ⊎ (lo D K r · lo D K r ≤ D))
loSpec D K r hK hr = first , second
  where
  M : ℕ → ℕ
  M j = r + j · K
  P : ℕ → Type
  P j = D < M (suc j) · M (suc j)
  dec : (j : ℕ) → Dec (P j)
  dec j = <Dec D (M (suc j) · M (suc j))
  j₀ = sd P dec D
  sD≤M : suc D ≤ M (suc D)
  sD≤M = ≤-trans (subst (_≤ suc D · K) (·-identityʳ (suc D)) (≤-k·' (suc D) hK)) (≤SumRight {k = r})
  M≤MM : M (suc D) ≤ M (suc D) · M (suc D)
  M≤MM = subst (_≤ M (suc D) · M (suc D)) (·-identityʳ (M (suc D)))
               (≤-k·' (M (suc D)) (≤-trans (suc-≤-suc zero-≤) sD≤M))
  Ptop : P D
  Ptop = <≤-trans ≤-refl (≤-trans sD≤M M≤MM)
  first : D < hi D K r · hi D K r
  first = subst (λ w → D < w · w) (sym (hiEq D K r)) (sdHit P dec D Ptop)
  second : (loIx D K r ≡ 0) ⊎ (lo D K r · lo D K r ≤ D)
  second with caseℕ j₀
  ... | inl e = inl e
  ... | inr (i , e) =
        inr (¬<→≤ (subst (λ w → ¬ (D < (r + w · K) · (r + w · K))) (sym e) (sdPred P dec D i e)))

-- the chosen multiplier lies in the class
chooseInClass : (D K r : ℕ) → Σ[ i ∈ ℕ ] choose D K r ≡ r + i · K
chooseInClass D K r with pickSpec (≤Dec (E D (lo D K r)) (E D (hi D K r))) (lo D K r) (hi D K r)
... | inl (e , _) = loIx D K r , e
... | inr (e , _) = suc (loIx D K r) , e ∙ hiEq D K r

chooseOppInClass : (D K r : ℕ) → Σ[ i ∈ ℕ ] chooseOpp D K r ≡ r + i · K
chooseOppInClass D K r with pickSpec (≤Dec (E D (hi D K r)) (E D (lo D K r))) (hi D K r) (lo D K r)
... | inl (e , _) = suc (loIx D K r) , e ∙ hiEq D K r
... | inr (e , _) = loIx D K r , e

-- BHĀSKARA'S RULE, VERIFIED: the chosen multiplier minimises |x² − D|
-- over the whole class, stated in the form `CakravalaBound.cakravalaKBound`
-- consumes.  (The same holds for `chooseOpp`; only ties differ.)
chooseMin : (D K r : ℕ) → 1 ≤ K → 1 ≤ r
          → (i X : ℕ)
          → ((r + i · K) · (r + i · K) ≡ D + X) ⊎ (D ≡ (r + i · K) · (r + i · K) + X)
          → E D (choose D K r) ≤ X
chooseMin D K r hK hr i X hX = go (splitℕ-≤ i j₀) (snd spec)
  where
  j₀ = loIx D K r
  L = lo D K r
  H = hi D K r
  Mi = r + i · K
  X≡ : X ≡ E D Mi
  X≡ = Euniq D Mi X hX
  spec = loSpec D K r hK hr
  pk = pickSpec (≤Dec (E D L) (E D H)) L H
  Ech≤L : E D (choose D K r) ≤ E D L
  Ech≤L with pk
  ... | inl (e , _)   = subst (λ w → E D w ≤ E D L) (sym e) ≤-refl
  ... | inr (e , ¬le) = subst (λ w → E D w ≤ E D L) (sym e) (<-weaken (¬≤→< ¬le))
  Ech≤H : E D (choose D K r) ≤ E D H
  Ech≤H with pk
  ... | inl (e , le) = subst (λ w → E D w ≤ E D H) (sym e) le
  ... | inr (e , _)  = subst (λ w → E D w ≤ E D H) (sym e) ≤-refl
  go : (i ≤ j₀) ⊎ (j₀ < i) → (j₀ ≡ 0) ⊎ (L · L ≤ D) → E D (choose D K r) ≤ X
  go (inl i≤j₀) (inl j₀≡0) =
    let i≡j₀ : i ≡ j₀
        i≡j₀ = ≤0→≡0 (subst (i ≤_) j₀≡0 i≤j₀) ∙ sym j₀≡0
        Mi≡L : Mi ≡ L
        Mi≡L = cong (λ w → r + w · K) i≡j₀
    in subst (E D (choose D K r) ≤_) (sym (X≡ ∙ cong (E D) Mi≡L)) Ech≤L
  go (inl i≤j₀) (inr LL≤D) =
    let Mi≤L : Mi ≤ L
        Mi≤L = ≤-k+ {k = r} (≤-·k {k = K} i≤j₀)
        MM≤LL : Mi · Mi ≤ L · L
        MM≤LL = sq-mono Mi≤L
        d   = fst MM≤LL
        hd  = snd MM≤LL                        -- d + Mi·Mi ≡ L·L
        hL  = Ebelow D L LL≤D                  -- D ≡ L·L + E L
        hM  = Ebelow D Mi (≤-trans MM≤LL LL≤D) -- D ≡ Mi·Mi + E Mi
        eq1 : Mi · Mi + E D Mi ≡ Mi · Mi + (d + E D L)
        eq1 = sym hM ∙ hL ∙ cong (_+ E D L) (sym hd) ∙ cong (_+ E D L) (+-comm d (Mi · Mi))
              ∙ sym (+-assoc (Mi · Mi) d (E D L))
        EL≤EM : E D L ≤ E D Mi
        EL≤EM = d , sym (inj-m+ {m = Mi · Mi} eq1)
    in subst (E D (choose D K r) ≤_) (sym X≡) (≤-trans Ech≤L EL≤EM)
  go (inr j₀<i) _ =
    let H≤Mi : H ≤ Mi
        H≤Mi = subst (_≤ Mi) (sym (hiEq D K r)) (≤-k+ {k = r} (≤-·k {k = K} j₀<i))
        HH≤MM : H · H ≤ Mi · Mi
        HH≤MM = sq-mono H≤Mi
        d  = fst HH≤MM
        hd = snd HH≤MM                                        -- d + H·H ≡ Mi·Mi
        D≤HH : D ≤ H · H
        D≤HH = <-weaken (fst spec)
        hH = Eabove D H D≤HH                                  -- H·H ≡ D + E H
        hM = Eabove D Mi (≤-trans D≤HH HH≤MM)                 -- Mi·Mi ≡ D + E Mi
        eq1 : D + E D Mi ≡ D + (d + E D H)
        eq1 = sym hM ∙ sym hd ∙ cong (d +_) hH ∙ +-assoc d D (E D H)
              ∙ cong (_+ E D H) (+-comm d D) ∙ sym (+-assoc D d (E D H))
        EH≤EM : E D H ≤ E D Mi
        EH≤EM = d , sym (inj-m+ {m = D} eq1)
    in subst (E D (choose D K r) ≤_) (sym X≡) (≤-trans Ech≤H EH≤EM)

------------------------------------------------------------------------
-- ६ · THE INVARIANT PROPAGATES: K' | m'² − D, with the cofactor written
-- out.  This is GunakaKsepa §5 (the next class is −m) closed under the
-- next turn's own division, and it needs no coprimality: m' ≡ −m (mod K')
-- gives m'² ≡ m² ≡ D (mod K').  Four polynomial identities and one
-- comparison.
------------------------------------------------------------------------

Inv : ℕ → ℕ → ℕ → Type
Inv D m K = Σ[ c ∈ ℕ ] E D m ≡ K · c

private
  sq-id : (m m' : ℕ) → m' · m' + 2 · ((m + m') · m) ≡ (m + m') · (m + m') + m · m
  sq-id m m' = solveℕ!

  idL1 : (K' t m : ℕ) → K' · (2 · t · m) ≡ 2 · ((t · K') · m)
  idL1 K' t m = solveℕ!

  idR1 : (D K K' t : ℕ) → (t · K') · (t · K') + (D + K · K') ≡ D + K' · (t · t · K' + K)
  idR1 D K K' t = solveℕ!

  idL2 : (m' K' t m K : ℕ)
       → m' · m' + K' · (2 · t · m + K) ≡ (m' · m' + 2 · ((t · K') · m)) + K · K'
  idL2 m' K' t m K = solveℕ!

  idR2 : (K K' t m : ℕ)
       → ((t · K') · (t · K') + m · m) + K · K' ≡ (t · K') · (t · K') + (m · m + K · K')
  idR2 K K' t m = solveℕ!

  idR3 : (D K' t : ℕ) → (t · K') · (t · K') + D ≡ D + K' · (t · t · K')
  idR3 D K' t = solveℕ!

  idC1 : (D K' X d : ℕ) → D + K' · (X + d) ≡ (D + K' · d) + K' · X
  idC1 D K' X d = solveℕ!

  idC2 : (M K' Y d : ℕ) → M + K' · (Y + d) ≡ (M + K' · d) + K' · Y
  idC2 M K' Y d = solveℕ!

  idT : (j i K' : ℕ) → j · K' + i · K' ≡ (j + i) · K'
  idT j i K' = solveℕ!

cancelCases : (D M X Y K' : ℕ) → M + K' · X ≡ D + K' · Y
            → Σ[ d ∈ ℕ ] ((M ≡ D + K' · d) ⊎ (D ≡ M + K' · d))
cancelCases D M X Y K' h with diffNat Y X
... | (d , inl hY) =
      d , inl (inj-+m {m = K' · X} (h ∙ cong (λ w → D + K' · w) hY ∙ idC1 D K' X d))
... | (d , inr hX) =
      d , inr (sym (inj-+m {m = K' · Y} (sym (cong (λ w → M + K' · w) hX ∙ idC2 M K' Y d) ∙ h)))

stepInv : (D m K K' r₁ m' : ℕ)
        → E D m ≡ K · K'
        → (j : ℕ) → m + r₁ ≡ j · K'
        → (i : ℕ) → m' ≡ r₁ + i · K'
        → Inv D m' K'
stepInv D m K K' r₁ m' hE j hr i hm' = go (Espec D m)
  where
  t = j + i
  hP : m + m' ≡ t · K'
  hP = cong (m +_) hm' ∙ +-assoc m r₁ (i · K') ∙ cong (_+ i · K') hr ∙ idT j i K'
  step1 : m' · m' + 2 · ((t · K') · m) ≡ (t · K') · (t · K') + m · m
  step1 = subst (λ P → m' · m' + 2 · (P · m) ≡ P · P + m · m) hP (sq-id m m')
  finish : Σ[ d ∈ ℕ ] ((m' · m' ≡ D + K' · d) ⊎ (D ≡ m' · m' + K' · d)) → Inv D m' K'
  finish (d , h) = d , sym (Euniq D m' (K' · d) h)
  go : (m · m ≡ D + E D m) ⊎ (D ≡ m · m + E D m) → Inv D m' K'
  go (inl a) = finish (cancelCases D (m' · m') (2 · t · m) (t · t · K' + K) K'
    ( cong (m' · m' +_) (idL1 K' t m)
    ∙ step1
    ∙ cong ((t · K') · (t · K') +_) (a ∙ cong (D +_) hE)
    ∙ idR1 D K K' t ))
  go (inr a) = finish (cancelCases D (m' · m') (2 · t · m + K) (t · t · K') K'
    ( idL2 m' K' t m K
    ∙ cong (_+ K · K') step1
    ∙ idR2 K K' t m
    ∙ cong ((t · K') · (t · K') +_) (sym (a ∙ cong (m · m +_) hE))
    ∙ idR3 D K' t ))

------------------------------------------------------------------------
-- ७ · THE STEP IS WELL DEFINED AND STAYS IN THE BOX.
--
-- `Good` is what an orbit state carries: क्षेप ≥ 1, क्षेप² ≤ 4D, the
-- invariant K | m² − D with its cofactor, and REDUCEDNESS — m is the
-- rule's own choice in some class 1 ≤ r ≤ K.  `stepGood` is (1) of the
-- programme: the next क्षेप is the exact cofactor, the next गुणक exists
-- and is in the window, and both bounds carry.  `CakravalaBound` does the
-- k-bound; `GunakaKsepa` the m-bound; this file supplies the minimality
-- hypothesis both of them were taking on trust, from `chooseMin`.
------------------------------------------------------------------------

Red : ℕ → ℕ → ℕ → Type
Red D m K = Σ[ r ∈ ℕ ] (1 ≤ r) × (r ≤ K) × (m ≡ choose D K r)

Good : ℕ → State → Type
Good D (m , K) = (1 ≤ K) × (K · K ≤ 4 · D) × Inv D m K × Red D m K

NonSquare : ℕ → Type
NonSquare D = (x : ℕ) → ¬ (x · x ≡ D)

nonSquare→1≤D : (D : ℕ) → NonSquare D → 1 ≤ D
nonSquare→1≤D D ns with caseℕ D
... | inl e       = ⊥rec (ns 0 (sym e))
... | inr (i , e) = subst (1 ≤_) (sym e) (suc-≤-suc zero-≤)

-- the exact quotient is the cofactor, and it is positive
stepKsepa : (D m K : ℕ) → NonSquare D → 1 ≤ K → Inv D m K
          → (E D m ≡ K · quot K (E D m)) × (1 ≤ quot K (E D m))
stepKsepa D m K ns hK (c , hc) = hE , posK
  where
  K' = quot K (E D m)
  hE : E D m ≡ K · K'
  hE = hc ∙ cong (K ·_) (sym (quotSpec K c (E D m) hK hc))
  posK : 1 ≤ K'
  posK with caseℕ K'
  ... | inr (i , e) = subst (1 ≤_) (sym e) (suc-≤-suc zero-≤)
  ... | inl e = ⊥rec (ns m sq)
    where
    E0 : E D m ≡ 0
    E0 = hE ∙ cong (K ·_) e ∙ sym (0≡m·0 K)
    sq : m · m ≡ D
    sq with Espec D m
    ... | inl a = a ∙ cong (D +_) E0 ∙ +-zero D
    ... | inr a = sym (a ∙ cong (m · m +_) E0 ∙ +-zero (m · m))

stepGood : (D : ℕ) → NonSquare D → (s : State) → Good D s → Good D (step D s)
stepGood D ns (m , K) (hK , hKK , inv , (r , hr1 , hrK , hm)) = hK' , hK'K' , inv' , red'
  where
  K' = quot K (E D m)
  ke = stepKsepa D m K ns hK inv
  hE : E D m ≡ K · K'
  hE = fst ke
  hK' : 1 ≤ K'
  hK' = snd ke
  minim : (j X : ℕ)
        → ((r + j · K) · (r + j · K) ≡ D + X) ⊎ (D ≡ (r + j · K) · (r + j · K) + X)
        → E D m ≤ X
  minim j X hX = subst (λ w → E D w ≤ X) (sym hm) (chooseMin D K r hK hr1 j X hX)
  hK'K' : K' · K' ≤ 4 · D
  hK'K' = <-weaken (cakravalaKBound D K r K' (E D m) (nonSquare→1≤D D ns) hK hr1 hrK hKK hE minim)
  nr = negRepSpec K' m hK'
  cl = chooseInClass D K' (negRep K' m)
  inv' : Inv D (choose D K' (negRep K' m)) K'
  inv' = stepInv D m K K' (negRep K' m) (choose D K' (negRep K' m)) hE
                 (negIx K' m) (fst nr) (fst cl) (snd cl)
  red' : Red D (choose D K' (negRep K' m)) K'
  red' = negRep K' m , fst (snd nr) , snd (snd nr) , refl

seedGood : (D : ℕ) → NonSquare D → Good D (seed D)
seedGood D ns = ≤-refl , hKK , (E D (choose D 1 1) , sym (·-identityˡ _)) , (1 , ≤-refl , ≤-refl , refl)
  where
  hKK : 1 · 1 ≤ 4 · D
  hKK = ≤-trans (nonSquare→1≤D D ns) (≤SumLeft {n = D} {k = 3 · D})

-- and a Good state is in GunakaKsepa's box
goodBox : (D B : ℕ) → 1 ≤ D → 4 · D < B · B
        → (s : State) → Good D s → (fst s < B) × (snd s < B)
goodBox D B hD1 hB (m , K) (hK , hKK , inv , (r , hr1 , hrK , hm)) =
  कोष्ठकः B m (4 · D) mm≤ hB , कोष्ठकः B K (4 · D) hKK hB
  where
  str = straddleExists D K r hD1 hK hr1 hrK hKK
  j   = fst str
  A   = fst (snd str)
  hAK = fst (snd (snd str))
  hA  = fst (snd (snd (snd str)))
  hHi = snd (snd (snd (snd str)))
  Mc  = r + j · K
  hbigc : 16 · (E D Mc · E D Mc) ≤ 36 · (D · (K · K))
  hbigc = straddleBound D K Mc A (E D Mc) hKK hA hAK hHi (Espec D Mc)
  hmin : E D m ≤ E D Mc
  hmin = subst (λ w → E D w ≤ E D Mc) (sym hm) (chooseMin D K r hK hr1 j (E D Mc) (Espec D Mc))
  hbig : 16 · (E D m · E D m) ≤ 36 · (D · (K · K))
  hbig = ≤-trans (≤-k·' 16 (sq-mono hmin)) hbigc
  mm≤ : m · m ≤ 4 · D
  mm≤ = गुणक-बन्धः D K m (E D m) hKK hbig (Espec D m)

allGood : (D : ℕ) → NonSquare D → (n : ℕ) → Good D (orbit D n)
allGood D ns zero    = seedGood D ns
allGood D ns (suc n) = stepGood D ns (orbit D n) (allGood D ns n)

------------------------------------------------------------------------
-- ८ · REVERSIBILITY, AND WHAT IT BUYS.
------------------------------------------------------------------------

-- a state is REVERSIBLE when the reverse rule undoes the step on it.
-- Wrapped in a data type (no η) so that `Reversible D (orbit D n)` never
-- unfolds `rev D (step D (orbit D n))` during conversion: the state
-- type is a record, so `step D s` reduces on ANY s by η, and the unfolded
-- term is the whole search machinery.  Every use goes through `unrv`.
data Reversible (D : ℕ) (s : State) : Type where
  rv : rev D (step D s) ≡ s → Reversible D s

unrv : {D : ℕ} {s : State} → Reversible D s → rev D (step D s) ≡ s
unrv (rv h) = h

-- the reverse formula: on reversible states the step is injective.
stepInj : (D : ℕ) (s₁ s₂ : State) → Reversible D s₁ → Reversible D s₂
        → step D s₁ ≡ step D s₂ → s₁ ≡ s₂
stepInj D s₁ s₂ (rv h₁) (rv h₂) e = sym h₁ ∙ cong (rev D) e ∙ h₂

-- a repeat at (i, i + d) backs up to a repeat at (0, d)
backtrack : (D : ℕ) → ((n : ℕ) → Reversible D (orbit D n))
          → (i d : ℕ) → orbit D i ≡ orbit D (i + d) → orbit D 0 ≡ orbit D d
backtrack D hrev zero    d e = e
backtrack D hrev (suc i) d e =
  backtrack D hrev i d (sym (unrv (hrev i)) ∙ cong (rev D) e ∙ unrv (hrev (i + d)))

-- two distinct turns with one state, within suc (B·B), give a period
fromRepeat : (D B : ℕ) → ((n : ℕ) → Reversible D (orbit D n))
           → (a b : ℕ) → a < suc (B · B) → b < suc (B · B) → ¬ (a ≡ b)
           → orbit D a ≡ orbit D b
           → Σ[ d ∈ ℕ ] (1 ≤ d) × (d ≤ B · B) × (orbit D d ≡ seed D)
fromRepeat D B hrev a b ha hb a≢b e = go (a ≟ b)
  where
  go : Trichotomy a b → Σ[ d ∈ ℕ ] (1 ≤ d) × (d ≤ B · B) × (orbit D d ≡ seed D)
  go (eq p) = ⊥rec (a≢b p)
  go (lt (k , hk)) = suc k , suc-≤-suc zero-≤ , bound , sym (backtrack D hrev a (suc k) e')
    where
    e' : orbit D a ≡ orbit D (a + suc k)
    e' = e ∙ cong (orbit D) (sym hk ∙ +-comm k (suc a) ∙ sym (+-suc a k))
    bound : suc k ≤ B · B
    bound = ≤-trans (subst (suc k ≤_) (sym (+-suc k a) ∙ hk) (suc-≤-suc (≤SumLeft {n = k} {k = a})))
                    (pred-≤-pred hb)
  go (gt (k , hk)) = suc k , suc-≤-suc zero-≤ , bound , sym (backtrack D hrev b (suc k) e')
    where
    e' : orbit D b ≡ orbit D (b + suc k)
    e' = sym e ∙ cong (orbit D) (sym hk ∙ +-comm k (suc b) ∙ sym (+-suc b k))
    bound : suc k ≤ B · B
    bound = ≤-trans (subst (suc k ≤_) (sym (+-suc k b) ∙ hk) (suc-≤-suc (≤SumLeft {n = k} {k = b})))
                    (pred-≤-pred ha)

-- THE CONDITIONAL THEOREM.  Given reversibility along the orbit, the
-- wheel returns to its seed — क्षेप = 1 — within B² turns.
returnsToSeed :
    (D B : ℕ) → NonSquare D → 4 · D < B · B
  → ((n : ℕ) → Reversible D (orbit D n))
  → Σ[ d ∈ ℕ ] (1 ≤ d) × (d ≤ B · B) × (orbit D d ≡ seed D)
returnsToSeed D B ns hB hrev =
  fromRepeat D B hrev (fst i) (fst j) (snd i) (snd j) (λ p → i≢j (toℕ-injective p)) e
  where
  rep = अवस्था-पुनरावृत्तिः B (λ i → toPair (orbit D (fst i)))
          (λ i → boxPair (orbit D (fst i)) (goodBox D B (nonSquare→1≤D D ns) hB (orbit D (fst i)) (allGood D ns (fst i))))
  i   = fst rep
  j   = fst (snd rep)
  i≢j = fst (snd (snd rep))
  e   = toPair-inj (orbit D (fst i)) (orbit D (fst j)) (snd (snd (snd rep)))

returnsToOne :
    (D B : ℕ) → NonSquare D → 4 · D < B · B
  → ((n : ℕ) → Reversible D (orbit D n))
  → Σ[ d ∈ ℕ ] (1 ≤ d) × (d ≤ B · B) × (snd (orbit D d) ≡ 1)
returnsToOne D B ns hB hrev =
  let (d , h1 , h2 , h3) = returnsToSeed D B ns hB hrev
  in d , h1 , h2 , cong snd h3


------------------------------------------------------------------------
-- ९ · WHAT REVERSIBILITY IS, EXACTLY: a condition on the गुणक alone.
--
-- The क्षेप half of `rev ∘ step ≡ id` is automatic (the exact quotient
-- of E D m by K' is K).  What is left is one statement about m:
--
--     m is the OPPOSITE-tie-break minimiser of |x² − D| over the positive
--     x ≡ −m' (mod K'), where (m', K') is the next state.
--
-- That is the daemon's "the candidate near the conjugate root is the
-- previous turn run backwards", made into a predicate on the state.
------------------------------------------------------------------------

-- the reverse, on an abstract next state: the गुणक half is the
-- hypothesis, the क्षेप half is the exact quotient
revAbs : (D m K m' K' : ℕ)
       → chooseOpp D K' (negRep K' m') ≡ m
       → quot K' (E D m) ≡ K
       → rev D (m' , K') ≡ (m , K)
revAbs D m K m' K' hm hq = ≡-State hm (cong (λ w → quot K' (E D w)) hm ∙ hq)

reversibleOfGunaka : (D : ℕ) → NonSquare D → (s : State) → Good D s
  → chooseOpp D (snd (step D s)) (negRep (snd (step D s)) (fst (step D s))) ≡ fst s
  → Reversible D s
reversibleOfGunaka D ns (m , K) (hK , _ , inv , _) hm =
  rv (revAbs D m K (fst (step D (m , K))) (snd (step D (m , K))) hm hq)
  where
  -- the next क्षेप, named through the step itself so that nothing below
  -- has to unfold `step`
  K' : ℕ
  K' = snd (step D (m , K))
  ke  = stepKsepa D m K ns hK inv
  hE : E D m ≡ K · K'
  hE = fst ke
  hK' : 1 ≤ K'
  hK' = snd ke
  hq : quot K' (E D m) ≡ K
  hq = quotSpec K' K (E D m) hK' (hE ∙ ·-comm K K')

------------------------------------------------------------------------
-- १० · PERIODICITY TOOLS.  A return to the seed at turn p makes the
-- orbit p-periodic, and then reversibility need only be checked on the
-- first p turns — which for a concrete D the kernel does by `refl`.
------------------------------------------------------------------------

nonSquareBetween : (n D : ℕ) → n · n < D → D < suc n · suc n → NonSquare D
nonSquareBetween n D lo hi x e = go (splitℕ-≤ x n)
  where
  go : (x ≤ n) ⊎ (n < x) → ⊥
  go (inl x≤n) = ¬m<m (≤<-trans (subst (_≤ n · n) e (sq-mono x≤n)) lo)
  go (inr n<x) = ¬m<m (<≤-trans hi (subst (suc n · suc n ≤_) e (sq-mono n<x)))

periodic : (D p : ℕ) → orbit D p ≡ seed D → (n : ℕ) → orbit D (n + p) ≡ orbit D n
periodic D p hp zero    = hp
periodic D p hp (suc n) = cong (step D) (periodic D p hp n)

revPer : (D p : ℕ) → orbit D p ≡ seed D
       → ((n : ℕ) → n < p → Reversible D (orbit D n))
       → (k n : ℕ) → n < p → Reversible D (orbit D (n + p · k))
revPer D p hp base zero n hn =
  subst (λ w → Reversible D (orbit D w)) (sym (cong (n +_) (sym (0≡m·0 p)) ∙ +-zero n)) (base n hn)
revPer D p hp base (suc k) n hn =
  subst (λ w → Reversible D (orbit D w)) eqn
        (subst (Reversible D) (sym (periodic D p hp (n + p · k))) (revPer D p hp base k n hn))
  where
  eqn : (n + p · k) + p ≡ n + p · suc k
  eqn = sym (+-assoc n (p · k) p) ∙ cong (n +_) (+-comm (p · k) p) ∙ cong (n +_) (sym (·-suc p k))

revAll : (D p' : ℕ) → orbit D (suc p') ≡ seed D
       → ((n : ℕ) → n < suc p' → Reversible D (orbit D n))
       → (n : ℕ) → Reversible D (orbit D n)
revAll D p' hp base n =
  subst (λ w → Reversible D (orbit D w)) (≡remainder+quotient (suc p') n)
        (revPer D (suc p') hp base (quotient n / suc p') (remainder n / suc p') (mod< p' n))

------------------------------------------------------------------------
-- ११ · THE SIGN OF THE क्षेप.  The (m, K)-dynamics carries |k|; the sign
-- of k is a passenger: k' = (m² − D)/k flips sign exactly when m² < D.
-- So sign(k_n) = (−1)^(number of turns t < n with m_t² < D), from k₀ = 1.
-- Over a full period the flips double, so the signed क्षेप is +1 at 2p.
------------------------------------------------------------------------

flip : ℕ → State → ℕ
flip D s = pick (<Dec (fst s · fst s) D) 1 0

flips : ℕ → ℕ → ℕ
flips D zero    = 0
flips D (suc n) = flips D n + flip D (orbit D n)

even : ℕ → Bool
even zero          = true
even (suc zero)    = false
even (suc (suc n)) = even n

evenDouble : (a : ℕ) → even (a + a) ≡ true
evenDouble zero    = refl
evenDouble (suc a) = cong (λ w → even (suc w)) (+-suc a a) ∙ evenDouble a

signed : Bool → ℕ → ℤ
signed true  K = pos K
signed false K = negsuc 0 ·ℤ pos K
  where open import Cubical.Data.Int using () renaming (_·_ to _·ℤ_)

-- THE SIGNED क्षेप of turn n.
क्षेप : ℕ → ℕ → ℤ
क्षेप D n = signed (even (flips D n)) (snd (orbit D n))

flipsAdd : (D p : ℕ) → orbit D p ≡ seed D → (n : ℕ) → flips D (n + p) ≡ flips D n + flips D p
flipsAdd D p hp zero    = refl
flipsAdd D p hp (suc n) =
    cong₂ _+_ (flipsAdd D p hp n) (cong (flip D) (periodic D p hp n))
  ∙ sym (+-assoc (flips D n) (flips D p) (flip D (orbit D n)))
  ∙ cong (flips D n +_) (+-comm (flips D p) (flip D (orbit D n)))
  ∙ +-assoc (flips D n) (flip D (orbit D n)) (flips D p)

-- a period d of the unsigned state is a period 2d of the signed क्षेप
signedReturn : (D d : ℕ) → orbit D d ≡ seed D → क्षेप D (d + d) ≡ pos 1
signedReturn D d hd =
  cong₂ signed (cong even (flipsAdd D d hd d) ∙ evenDouble (flips D d))
               (cong snd (periodic D d hd d ∙ hd))

-- LAGRANGE, in the wheel's own terms and modulo reversibility: the signed
-- क्षेप returns to +1 within 2B² turns.
returnsToPlusOne :
    (D B : ℕ) → NonSquare D → 4 · D < B · B
  → ((n : ℕ) → Reversible D (orbit D n))
  → Σ[ n ∈ ℕ ] (1 ≤ n) × (n ≤ B · B + B · B) × (क्षेप D n ≡ pos 1)
returnsToPlusOne D B ns hB hrev =
  let (d , h1 , h2 , h3) = returnsToSeed D B ns hB hrev
  in d + d , ≤-trans h1 (≤SumLeft {n = d} {k = d}) , ≤-+-≤ h2 h2 , signedReturn D d h3

------------------------------------------------------------------------
-- १२ · THE (a, b)-WHEEL FOLLOWS THE (m, k)-SHADOW, WITHOUT COPRIMALITY.
--
-- GunakaKsepa §6(a) asks for gcd(b', k') = 1 "so that the solution set
-- of the congruence IS the class of −m".  That is what UNIQUENESS of the
-- class needs.  EXACTNESS needs nothing: if the next multiplier is taken
-- in the class of −m — m' = t·k' − m — then all three of the next turn's
-- divisions are exact, with cofactors written out.  Three ring identities
-- over ℤ, from GunakaKsepa §5's conclusion and this turn's own division.
------------------------------------------------------------------------

open import Cubical.Algebra.CommRing using (CommRingStr)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver using (solve!)

open CommRingStr (snd ℤCommRing)
  using () renaming (_·_ to _·ℤ_ ; _+_ to _+ℤ_ ; -_ to -ℤ_ ; _-_ to _-ℤ_)

त्रि-भागहारः :
    (D a b m k a' b' k' m' t : ℤ)
  → a' +ℤ b' ·ℤ (-ℤ m) ≡ k' ·ℤ (-ℤ b)          -- GunakaKsepa.प्रत्यावृत्तिः
  → m ·ℤ m -ℤ D ≡ k ·ℤ k'                      -- this turn's division
  → m' ≡ t ·ℤ k' -ℤ m                          -- m' ≡ −m (mod k')
  → (a' +ℤ b' ·ℤ m' ≡ k' ·ℤ (t ·ℤ b' -ℤ b))
  × (a' ·ℤ m' +ℤ D ·ℤ b' ≡ k' ·ℤ ((t ·ℤ a' +ℤ b ·ℤ m) -ℤ b' ·ℤ k))
  × (m' ·ℤ m' -ℤ D ≡ k' ·ℤ (((t ·ℤ t) ·ℤ k' -ℤ (t +ℤ t) ·ℤ m) +ℤ k))
त्रि-भागहारः D a b m k a' b' k' m' t h1 hk hm' = div1 , div2 , div3
  where
  hA : a' ≡ b' ·ℤ m -ℤ k' ·ℤ b
  hA = idA1 ∙ cong (_+ℤ b' ·ℤ m) h1 ∙ idA2
    where
    idA1 : a' ≡ (a' +ℤ b' ·ℤ (-ℤ m)) +ℤ b' ·ℤ m
    idA1 = solve! ℤCommRing
    idA2 : k' ·ℤ (-ℤ b) +ℤ b' ·ℤ m ≡ b' ·ℤ m -ℤ k' ·ℤ b
    idA2 = solve! ℤCommRing

  div1 : a' +ℤ b' ·ℤ m' ≡ k' ·ℤ (t ·ℤ b' -ℤ b)
  div1 = cong₂ (λ x y → x +ℤ b' ·ℤ y) hA hm' ∙ id1
    where
    id1 : (b' ·ℤ m -ℤ k' ·ℤ b) +ℤ b' ·ℤ (t ·ℤ k' -ℤ m) ≡ k' ·ℤ (t ·ℤ b' -ℤ b)
    id1 = solve! ℤCommRing

  div2 : a' ·ℤ m' +ℤ D ·ℤ b' ≡ k' ·ℤ ((t ·ℤ a' +ℤ b ·ℤ m) -ℤ b' ·ℤ k)
  div2 = subst2 (λ x y → x ·ℤ y +ℤ D ·ℤ b' ≡ k' ·ℤ ((t ·ℤ x +ℤ b ·ℤ m) -ℤ b' ·ℤ k))
                (sym hA) (sym hm') core
    where
    x = b' ·ℤ m -ℤ k' ·ℤ b
    y = t ·ℤ k' -ℤ m
    id2a : x ·ℤ y +ℤ D ·ℤ b'
         ≡ k' ·ℤ ((t ·ℤ x +ℤ b ·ℤ m) -ℤ b' ·ℤ k) +ℤ (-ℤ b') ·ℤ ((m ·ℤ m -ℤ D) -ℤ k ·ℤ k')
    id2a = solve! ℤCommRing
    core : x ·ℤ y +ℤ D ·ℤ b' ≡ k' ·ℤ ((t ·ℤ x +ℤ b ·ℤ m) -ℤ b' ·ℤ k)
    core = id2a
         ∙ cong (λ w → k' ·ℤ ((t ·ℤ x +ℤ b ·ℤ m) -ℤ b' ·ℤ k) +ℤ (-ℤ b') ·ℤ (w -ℤ k ·ℤ k')) hk
         ∙ id2b
      where
      id2b : k' ·ℤ ((t ·ℤ x +ℤ b ·ℤ m) -ℤ b' ·ℤ k) +ℤ (-ℤ b') ·ℤ (k ·ℤ k' -ℤ k ·ℤ k')
           ≡ k' ·ℤ ((t ·ℤ x +ℤ b ·ℤ m) -ℤ b' ·ℤ k)
      id2b = solve! ℤCommRing

  div3 : m' ·ℤ m' -ℤ D ≡ k' ·ℤ (((t ·ℤ t) ·ℤ k' -ℤ (t +ℤ t) ·ℤ m) +ℤ k)
  div3 = cong (λ y → y ·ℤ y -ℤ D) hm' ∙ id3a ∙ cong (((t ·ℤ t) ·ℤ k' -ℤ (t +ℤ t) ·ℤ m) ·ℤ k' +ℤ_) hk ∙ id3b
    where
    id3a : (t ·ℤ k' -ℤ m) ·ℤ (t ·ℤ k' -ℤ m) -ℤ D
         ≡ ((t ·ℤ t) ·ℤ k' -ℤ (t +ℤ t) ·ℤ m) ·ℤ k' +ℤ (m ·ℤ m -ℤ D)
    id3a = solve! ℤCommRing
    id3b : ((t ·ℤ t) ·ℤ k' -ℤ (t +ℤ t) ·ℤ m) ·ℤ k' +ℤ k ·ℤ k'
         ≡ k' ·ℤ (((t ·ℤ t) ·ℤ k' -ℤ (t +ℤ t) ·ℤ m) +ℤ k)
    id3b = solve! ℤCommRing

------------------------------------------------------------------------
-- १३ · IN THE KERNEL.  Four D's, and the two things the numbers show.
------------------------------------------------------------------------

-- the same rule with the SAME tie-break, read backwards — the version
-- of the reverse the programme first asks for.
revSame : ℕ → State → State
revSame D (m' , K') = m , quot K' (E D m)
  where m = choose D K' (negRep K' m')

-- D = 61, Bhāskara's example.  Seed (8, 1); unsigned period 7; the
-- signed क्षेप is −1 at turn 7 and +1 at turn 14.
module षष्ट्येकम् where
  ns : NonSquare 61
  ns = nonSquareBetween 7 61 (11 , refl) (2 , refl)

  turns : (orbit 61 1 ≡ (7 , 3)) × (orbit 61 2 ≡ (9 , 4)) × (orbit 61 3 ≡ (6 , 5))
        × (orbit 61 4 ≡ (9 , 5)) × (orbit 61 5 ≡ (7 , 4)) × (orbit 61 6 ≡ (8 , 3))
  turns = refl , refl , refl , refl , refl , refl

  period : orbit 61 7 ≡ seed 61
  period = refl

  -- reversibility on one period, each turn by the kernel
  base : (n : ℕ) → n < 7 → Reversible 61 (orbit 61 n)
  base 0 _ = rv refl
  base 1 _ = rv refl
  base 2 _ = rv refl
  base 3 _ = rv refl
  base 4 _ = rv refl
  base 5 _ = rv refl
  base 6 _ = rv refl
  base (suc (suc (suc (suc (suc (suc (suc n))))))) h = ⊥rec (¬m+n<m {m = 7} {n = n} h)

  reversible : (n : ℕ) → Reversible 61 (orbit 61 n)
  reversible = revAll 61 6 period base

  -- LAGRANGE AT 61, from the theorem: B = 16, 4·61 = 244 < 256.
  lagrange : Σ[ d ∈ ℕ ] (1 ≤ d) × (d ≤ 16 · 16) × (snd (orbit 61 d) ≡ 1)
  lagrange = returnsToOne 61 16 ns (11 , refl) reversible

  lagrangeSigned : Σ[ n ∈ ℕ ] (1 ≤ n) × (n ≤ 16 · 16 + 16 · 16) × (क्षेप 61 n ≡ pos 1)
  lagrangeSigned = returnsToPlusOne 61 16 ns (11 , refl) reversible

  -- and the sharp values, computed: k₇ = −1 (29718² − 61·3805² = −1),
  -- k₁₄ = +1 (1766319049² − 61·226153980² = 1, `CakravalaWitness`).
  k7 : क्षेप 61 7 ≡ negsuc 0
  k7 = refl
  k14 : क्षेप 61 14 ≡ pos 1
  k14 = refl

module द्वि where
  ns : NonSquare 2
  ns = nonSquareBetween 1 2 (0 , refl) (1 , refl)
  period : orbit 2 1 ≡ seed 2
  period = refl
  base : (n : ℕ) → n < 1 → Reversible 2 (orbit 2 n)
  base 0 _ = rv refl
  base (suc n) h = ⊥rec (¬m+n<m {m = 1} {n = n} h)
  lagrange : Σ[ d ∈ ℕ ] (1 ≤ d) × (d ≤ 3 · 3) × (snd (orbit 2 d) ≡ 1)
  lagrange = returnsToOne 2 3 ns (0 , refl) (revAll 2 0 period base)
  k2 : क्षेप 2 2 ≡ pos 1          -- 3² − 2·2² = 1
  k2 = refl

module त्रि where
  ns : NonSquare 3
  ns = nonSquareBetween 1 3 (1 , refl) (0 , refl)
  period : orbit 3 1 ≡ seed 3
  period = refl
  base : (n : ℕ) → n < 1 → Reversible 3 (orbit 3 n)
  base 0 _ = rv refl
  base (suc n) h = ⊥rec (¬m+n<m {m = 1} {n = n} h)
  lagrange : Σ[ d ∈ ℕ ] (1 ≤ d) × (d ≤ 4 · 4) × (snd (orbit 3 d) ≡ 1)
  lagrange = returnsToOne 3 4 ns (3 , refl) (revAll 3 0 period base)
  k1 : क्षेप 3 1 ≡ pos 1          -- 2² − 3·1² = 1
  k1 = refl

module त्रयोदश where
  ns : NonSquare 13
  ns = nonSquareBetween 3 13 (3 , refl) (2 , refl)
  period : orbit 13 3 ≡ seed 13
  period = refl
  base : (n : ℕ) → n < 3 → Reversible 13 (orbit 13 n)
  base 0 _ = rv refl
  base 1 _ = rv refl
  base 2 _ = rv refl
  base (suc (suc (suc n))) h = ⊥rec (¬m+n<m {m = 3} {n = n} h)
  lagrange : Σ[ d ∈ ℕ ] (1 ≤ d) × (d ≤ 8 · 8) × (snd (orbit 13 d) ≡ 1)
  lagrange = returnsToOne 13 8 ns (11 , refl) (revAll 13 2 period base)
  k3 : क्षेप 13 3 ≡ negsuc 0      -- 18² − 13·5² = −1
  k3 = refl
  k6 : क्षेप 13 6 ≡ pos 1         -- 649² − 13·180² = 1
  k6 = refl

-- THE TWO THINGS THE NUMBERS SHOW.
module साक्ष्यम् where
  -- (i) the step is NOT injective on the box: at D = 2 the boxed states
  -- (2, 2) and (1, 1) — both with K | m² − D — have the same image.
  collision : (step 2 (2 , 2) ≡ (1 , 1)) × (step 2 (1 , 1) ≡ (1 , 1))
  collision = refl , refl

  -- (ii) TIES.  At D = 29 the class 3 mod 4 holds 3 and 7 with
  -- |9 − 29| = |49 − 29| = 20, and the reduced states (3, 5), (7, 5)
  -- collide.  The wheel's orbit (5,1) → (3,4) → (7,5) → (5,4) → (5,1)
  -- passes through (7, 5); the SAME-tie-break reverse of (5, 4) returns
  -- the other one, so it is not a left inverse of the step even on the
  -- orbit — while the opposite-tie-break reverse is, at every turn.
  tie : (step 29 (3 , 5) ≡ (5 , 4)) × (step 29 (7 , 5) ≡ (5 , 4))
  tie = refl , refl

  period29 : orbit 29 4 ≡ seed 29
  period29 = refl

  sameFails : revSame 29 (5 , 4) ≡ (3 , 5)
  sameFails = refl

  notPrevious : ¬ ((3 , 5) ≡ orbit 29 2)
  notPrevious p = znots (injSuc (injSuc (injSuc (cong fst p))))

  base : (n : ℕ) → n < 4 → Reversible 29 (orbit 29 n)
  base 0 _ = rv refl
  base 1 _ = rv refl
  base 2 _ = rv refl
  base 3 _ = rv refl
  base (suc (suc (suc (suc n)))) h = ⊥rec (¬m+n<m {m = 4} {n = n} h)

  reversible29 : (n : ℕ) → Reversible 29 (orbit 29 n)
  reversible29 = revAll 29 3 period29 base
