{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- KuttakaIsta — the इष्ट section of the pulverizer: the solution family
-- has a LEAST NON-NEGATIVE representative, and it is unique.
--
-- SOURCE.  ĀRYABHAṬA, Āryabhaṭīya, Gaṇitapāda 32–33 (499 CE); BHĀSKARA I,
-- Āryabhaṭīyabhāṣya (629 CE).  Once the vallī has been run back up and a
-- pair (x₀ , y₀) with a·x₀ + b·y₀ = g is in hand, the rule's last step is to
-- reduce it: the multiplier is taken modulo the divisor — "divide by the
-- divisor, the remainder is the multiplier" — so that the answer reported
-- is the least one.  That reduction is what this file supplies.
--
-- THE ABSENCE THIS FILE CLOSES.  `Kuttaka.agda` says, in its header:
--
--     "NOT done (named honestly, per §5.2): the iṣṭa section — the reduction
--      of the solution family to the LEAST non-negative representative —
--      which needs a mod/section convention and is not supplied here."
--
-- and `KuttakaSamapti_TheValliIsFiniteForEveryPair.agda` repeats it:
--
--     "The इष्ट section — reduction of the solution family to its least
--      non-negative representative — is open in `Kuttaka.agda` and stays
--      open."
--
-- Neither module is modified.  The family is taken in EXACTLY the form
-- `Kuttaka.solutionFamily` presents it,
--
--     a · (x₀ + t · b) + b · (y₀ + (- (t · a))) ≡ g ,
--
-- with modulus b (Kuttaka's own header calls this the coarser b, a family;
-- the b/g, a/g refinement is not what `solutionFamily` states, and is not
-- what is reduced here — see THE SCOPE below).  The modulus is written
-- `pos (suc m)`, which is the convention "b > 0" chosen once and for all;
-- a `0 < m` phrasing is supplied alongside.
--
-- WHAT IS PROVED.  No postulates, no holes, --safe, no TERMINATING pragmas.
--
--   divℤ / divℤ'  EUCLIDEAN DIVISION ON ℤ BY A POSITIVE MODULUS.  For every
--                 z : ℤ and modulus suc m (equivalently m with 0 < m) there
--                 are q : ℤ and r : ℕ with r < suc m and
--                 z ≡ q · pos (suc m) + pos r.  Built from the library's ℕ
--                 division (`Cubical.Data.Nat.Mod`: `≡remainder+quotient`,
--                 `mod<`); a negative z is reflected: −(suc n) is divided
--                 as suc n = q'·M + r' and then folded to (−q'−1)·M + (M−r')
--                 when r' ≠ 0, and to (−q')·M + 0 when r' = 0.  (The
--                 library's `Cubical.Data.Int.Divisibility.quotRem` gives a
--                 remainder of the dividend's SIGN, so it is not the least
--                 non-negative one and is not used.)
--   divUnique     the quotient and remainder are UNIQUE: two divisions of
--                 the same integer by suc m with remainders below suc m
--                 agree in both coordinates.
--   iṣṭa          THE LEAST NON-NEGATIVE REPRESENTATIVE.  From any solution
--                 a·x₀ + pos (suc m)·y₀ ≡ g, a member of Kuttaka's family
--                 (parameter t, here t = −q where x₀ = q·M + r) whose x is
--                 pos r with r < suc m, still solving the equation — by
--                 `Kuttaka.solutionFamily`.
--   iṣṭaUnique    UNIQUENESS WITHIN THE FAMILY: two members of the family
--                 whose x lies in [0 , suc m) have the same t and the same
--                 x (and hence the same y): by `divUnique`.
--   complete₁     COMPLETENESS AT g = 1, via `Kuttaka.solutionsDiffer`:
--                 when a·x₀ + M·y₀ ≡ 1, EVERY solution of a·x + M·y ≡ 1 is
--                 a member of the family through (x₀ , y₀).  The difference
--                 of two solutions is a homogeneous solution (that is what
--                 `solutionsDiffer` gives), and the Bézout relation at 1 is
--                 exactly what turns "M divides a·c" into "M divides c".
--   iṣṭaUnique₁   hence at g = 1 the iṣṭa is unique among ALL solutions,
--                 not only within the family: any solution with
--                 0 ≤ x < M is the iṣṭa, x and y both.
--   example…      the classical answer for `Kuttaka.example`, 7x + 5y = 1:
--                 `bezout` gives (x₀ , y₀) = (−2 , 3); dividing −2 by 5 gives
--                 −2 = (−1)·5 + 3, so t = 1 and the iṣṭa is (x , y) = (3 , −4)
--                 — all by refl, and its uniqueness among all solutions with
--                 0 ≤ x < 5 by `iṣṭaUnique₁`.
--
-- THE SCOPE, EXACTLY.
--   * Reduction is modulo b, the modulus `solutionFamily` actually uses.
--     For g ≠ 1 the full solution set is parametrised by b/g, not by b, so
--     for g ≠ 1 `iṣṭaUnique` is uniqueness WITHIN the coarse family only;
--     completeness (every solution is a family member) is proved here only
--     at g = 1 (`complete₁`).  For general g the missing step is the one
--     `Kuttaka.agda` itself names after `solutionsDiffer`: the fine family
--     with modulus b/g and the coprimality of a/g and b/g.  It is NOT
--     proved here.
--   * Nothing about the length of the vallī, or the cakravāla, is touched.
------------------------------------------------------------------------

module KuttakaIsta_TheSolutionFamilyHasALeastNonNegativeRepresentativeAndItIsUnique where

open import Cubical.Foundations.Prelude

open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; snotz ; +-suc ; +-comm ; +-assoc ; ·-comm)
  renaming (_+_ to _+ℕ_ ; _·_ to _·ℕ_)
open import Cubical.Data.Nat.Order
  using (_<_ ; _≤_ ; zero-≤ ; suc-≤-suc ; <-asym ; ≤-trans ; ≤SumLeft ; ¬-<-zero)
open import Cubical.Data.Nat.Mod
  using (mod< ; ≡remainder+quotient ; remainder_/_ ; quotient_/_)

open import Cubical.Data.Int
  using (ℤ ; pos ; negsuc ; _+_ ; _·_ ; -_ ; sucℤ ; predℤ)
open import Cubical.Data.Int.Properties
  using ( pos+ ; pos·pos ; injPos ; inj-z+ ; sucℤ+pos ; predℤ-pos
        ; ·DistL+ ; ·IdR ; ·AnnihilL ; ·lCancel ; -Involutive )
import Cubical.Data.Int.Order as ℤO

open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.Relation.Nullary using (¬_)

open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

open import Kuttaka
  using (solutionFamily ; solutionsDiffer ; exampleSolves)

------------------------------------------------------------------------
-- १ · Euclidean division on ℤ by a positive modulus.
--
-- The convention: the modulus is pos (suc m) — positive by its shape — and
-- the remainder is a NATURAL below suc m.  That is the "mod/section
-- convention" Kuttaka's header asked for: the section of ℤ → ℤ/(suc m)
-- picking the least non-negative representative.
------------------------------------------------------------------------

-- a division of z by suc m with least non-negative remainder.
DivRep : ℤ → ℕ → Type
DivRep z m = Σ[ q ∈ ℤ ] Σ[ r ∈ ℕ ] (r < suc m) × (z ≡ q · pos (suc m) + pos r)

private
  -- the library's ℕ division, in the shape a ≡ q·b + r.
  ℕdiv : (m n : ℕ) → n ≡ (quotient n / suc m) ·ℕ suc m +ℕ (remainder n / suc m)
  ℕdiv m n =
      sym (≡remainder+quotient (suc m) n)
    ∙ +-comm (remainder n / suc m) (suc m ·ℕ (quotient n / suc m))
    ∙ cong (_+ℕ (remainder n / suc m)) (·-comm (suc m) (quotient n / suc m))

  -- an ℕ division IS a ℤ division, under pos.
  liftEq : (a b q r : ℕ) → a ≡ q ·ℕ b +ℕ r → pos a ≡ pos q · pos b + pos r
  liftEq a b q r eq = cong pos eq ∙ pos+ (q ·ℕ b) r ∙ cong (_+ pos r) (pos·pos q b)

  -- pure ring identities (the solver, on ∀-quantified statements only —
  -- it does not read the literal 1, so −1 is kept out of them).
  negDist : (Q R : ℤ) → - (Q · R) ≡ (- Q) · R
  negDist Q R = solve! ℤCommRing

  negId : (Q K R : ℤ)
        → - (Q · (K + R) + R) ≡ ((- Q) · (K + R) + (- (K + R))) + K
  negId Q K R = solve! ℤCommRing

  -- reflecting: with M ≡ K + R,  −(Q·M + R) ≡ (−Q)·M − M + K.
  negStep : (Q Mz K R : ℤ) → Mz ≡ K + R
          → - (Q · Mz + R) ≡ ((- Q) · Mz + (- Mz)) + K
  negStep Q Mz K R p =
      cong (λ z → - (Q · z + R)) p
    ∙ negId Q K R
    ∙ cong (λ z → ((- Q) · z + (- z)) + K) (sym p)

  -- the negative dividend, given the ℕ division of suc n by suc m.
  negCase : (n m q' r' : ℕ) → r' < suc m → suc n ≡ q' ·ℕ suc m +ℕ r'
          → DivRep (negsuc n) m
  -- exact: −(suc n) = (−q')·M + 0.
  negCase n m q' zero _ eq =
    (- pos q') , 0 , suc-≤-suc zero-≤
    , (cong -_ (liftEq (suc n) (suc m) q' 0 eq) ∙ negDist (pos q') (pos (suc m)))
  -- inexact: −(suc n) = (−q'−1)·M + (M − r'), and M − r' = suc k where
  -- k + suc r' ≡ m, i.e. k + suc (suc r'') ≡ suc m is the witness of r' < M.
  negCase n m q' (suc r'') (k , kEq) eq =
    negsuc q' , suc k , (r'' , bound) , path
    where
      bound : r'' +ℕ suc (suc k) ≡ suc m
      bound = +-comm r'' (suc (suc k))
            ∙ sym (+-suc k (suc r'') ∙ cong suc (+-suc k r''))
            ∙ kEq
      Meq : pos (suc m) ≡ pos (suc k) + pos (suc r'')
      Meq = cong pos (sym kEq ∙ +-suc k (suc r'')) ∙ pos+ (suc k) (suc r'')
      path : negsuc n ≡ negsuc q' · pos (suc m) + pos (suc k)
      path = cong -_ (liftEq (suc n) (suc m) q' (suc r'') eq)
           ∙ negStep (pos q') (pos (suc m)) (pos (suc k)) (pos (suc r'')) Meq
           ∙ cong (_+ pos (suc k))
                  ( sym (·DistL+ (- pos q') (negsuc 0) (pos (suc m)))
                  ∙ cong (_· pos (suc m)) (predℤ-pos q') )

-- EXISTENCE: every integer divides by suc m with a remainder in [0 , suc m).
divℤ : (z : ℤ) (m : ℕ) → DivRep z m
divℤ (pos n) m =
  pos (quotient n / suc m) , remainder n / suc m , mod< m n
  , liftEq n (suc m) (quotient n / suc m) (remainder n / suc m) (ℕdiv m n)
divℤ (negsuc n) m =
  negCase n m (quotient (suc n) / suc m) (remainder (suc n) / suc m)
          (mod< m (suc n)) (ℕdiv m (suc n))

-- the same, phrased with an arbitrary modulus m and the hypothesis 0 < m.
divℤ' : (z : ℤ) (m : ℕ) → 0 < m
      → Σ[ q ∈ ℤ ] Σ[ r ∈ ℕ ] (r < m) × (z ≡ q · pos m + pos r)
divℤ' z zero    lt = ⊥rec (¬-<-zero lt)
divℤ' z (suc m) _  = divℤ z m

private
  shiftId : (q S Mz R : ℤ) → (q + S) · Mz + R ≡ q · Mz + (S · Mz + R)
  shiftId q S Mz R = solve! ℤCommRing

  -- a strictly larger quotient forces the other remainder past the modulus.
  tooBig : (m : ℕ) (q : ℤ) (k r r' : ℕ) → r < suc m
         → q · pos (suc m) + pos r ≡ (q + pos (suc k)) · pos (suc m) + pos r'
         → ⊥
  tooBig m q k r r' r<M hyp = <-asym r<M M≤r
    where
      step : pos r ≡ pos (suc k ·ℕ suc m +ℕ r')
      step = inj-z+ (hyp ∙ shiftId q (pos (suc k)) (pos (suc m)) (pos r'))
           ∙ sym (pos+ (suc k ·ℕ suc m) r' ∙ cong (_+ pos r') (pos·pos (suc k) (suc m)))
      s₁ : suc m ≤ suc m +ℕ k ·ℕ suc m
      s₁ = ≤SumLeft
      s₂ : suc m +ℕ k ·ℕ suc m ≤ (suc m +ℕ k ·ℕ suc m) +ℕ r'
      s₂ = ≤SumLeft
      M≤r : suc m ≤ r
      M≤r = subst (suc m ≤_) (sym (injPos step)) (≤-trans s₁ s₂)

-- UNIQUENESS: quotient and remainder are determined.
divUnique : (m : ℕ) (q q' : ℤ) (r r' : ℕ) → r < suc m → r' < suc m
          → q · pos (suc m) + pos r ≡ q' · pos (suc m) + pos r'
          → (q ≡ q') × (r ≡ r')
divUnique m q q' r r' r<M r'<M hyp = go (q ℤO.≟ q')
  where
    go : ℤO.Trichotomy q q' → (q ≡ q') × (r ≡ r')
    go (ℤO.lt (k , p)) =
      ⊥rec (tooBig m q k r r' r<M
             (hyp ∙ cong (λ z → z · pos (suc m) + pos r') (sym p ∙ sym (sucℤ+pos k q))))
    go (ℤO.gt (k , p)) =
      ⊥rec (tooBig m q' k r' r r'<M
             (sym hyp ∙ cong (λ z → z · pos (suc m) + pos r) (sym p ∙ sym (sucℤ+pos k q'))))
    go (ℤO.eq p) =
      p , injPos (inj-z+ (cong (λ z → z · pos (suc m) + pos r) (sym p) ∙ hyp))

------------------------------------------------------------------------
-- २ · The iṣṭa: the least non-negative representative of the family.
--
-- The family is `Kuttaka.solutionFamily`'s, verbatim: member t through
-- (x₀ , y₀) is (x₀ + t · b , y₀ + (- (t · a))), with b = pos (suc m).
------------------------------------------------------------------------

-- a member of the family whose x is a natural below the modulus.
Iṣṭa : (a x₀ y₀ g : ℤ) (m : ℕ) → Type
Iṣṭa a x₀ y₀ g m =
  Σ[ t ∈ ℤ ] Σ[ r ∈ ℕ ]
      (r < suc m)
    × (x₀ + t · pos (suc m) ≡ pos r)
    × (a · pos r + pos (suc m) · (y₀ + (- (t · a))) ≡ g)

private
  cancelId : (q Mz R : ℤ) → (q · Mz + R) + (- q) · Mz ≡ R
  cancelId q Mz R = solve! ℤCommRing

-- EXISTENCE: divide x₀ by the modulus and take t = −q.
iṣṭa : (a x₀ y₀ g : ℤ) (m : ℕ) → a · x₀ + pos (suc m) · y₀ ≡ g
     → Iṣṭa a x₀ y₀ g m
iṣṭa a x₀ y₀ g m sol = (- q) , r , r<M , xEq , yEq
  where
    d   = divℤ x₀ m
    q   = fst d
    r   = fst (snd d)
    r<M = fst (snd (snd d))
    x₀≡ = snd (snd (snd d))
    xEq : x₀ + (- q) · pos (suc m) ≡ pos r
    xEq = cong (_+ (- q) · pos (suc m)) x₀≡ ∙ cancelId q (pos (suc m)) (pos r)
    yEq : a · pos r + pos (suc m) · (y₀ + (- ((- q) · a))) ≡ g
    yEq = cong (λ z → a · z + pos (suc m) · (y₀ + (- ((- q) · a)))) (sym xEq)
        ∙ solutionFamily a (pos (suc m)) g x₀ y₀ sol (- q)

private
  backId : (t x Mz : ℤ) → (- t) · Mz + (x + t · Mz) ≡ x
  backId t x Mz = solve! ℤCommRing

-- UNIQUENESS WITHIN THE FAMILY: two members with x in [0 , suc m) are the
-- same member — same t, same x — by uniqueness of division.
iṣṭaUnique : (x₀ : ℤ) (m : ℕ) (t t' : ℤ) (r r' : ℕ) → r < suc m → r' < suc m
           → x₀ + t · pos (suc m) ≡ pos r → x₀ + t' · pos (suc m) ≡ pos r'
           → (t ≡ t') × (r ≡ r')
iṣṭaUnique x₀ m t t' r r' r<M r'<M e e' =
  (sym (-Involutive t) ∙ cong -_ (fst u) ∙ -Involutive t') , snd u
  where
    toDiv : (s : ℤ) (n : ℕ) → x₀ + s · pos (suc m) ≡ pos n
          → (- s) · pos (suc m) + pos n ≡ x₀
    toDiv s n e₀ = cong (λ z → (- s) · pos (suc m) + z) (sym e₀) ∙ backId s x₀ (pos (suc m))
    u : ((- t) ≡ (- t')) × (r ≡ r')
    u = divUnique m (- t) (- t') r r' r<M r'<M (toDiv t r e ∙ sym (toDiv t' r' e'))

-- and so the two members coincide as pairs (x , y).
iṣṭaUniqueMember : (a x₀ y₀ : ℤ) (m : ℕ) (t t' : ℤ) (r r' : ℕ)
                 → r < suc m → r' < suc m
                 → x₀ + t · pos (suc m) ≡ pos r → x₀ + t' · pos (suc m) ≡ pos r'
                 → Path (ℤ × ℤ) (pos r , y₀ + (- (t · a))) (pos r' , y₀ + (- (t' · a)))
iṣṭaUniqueMember a x₀ y₀ m t t' r r' r<M r'<M e e' =
  λ i → (pos (snd u i) , y₀ + (- (fst u i · a)))
  where
    u = iṣṭaUnique x₀ m t t' r r' r<M r'<M e e'

------------------------------------------------------------------------
-- ३ · Completeness at g = 1, from `Kuttaka.solutionsDiffer`.
--
-- `solutionsDiffer` says two solutions differ by a homogeneous solution:
-- a·c + M·e ≡ 0 with c = x − x₀, e = y − y₀.  At g = 1 the Bézout relation
-- a·x₀ + M·y₀ ≡ 1 lets c be written as c·(a·x₀ + M·y₀) = M·(c·y₀ − e·x₀)
-- + (a·c + M·e)·x₀, so M divides c: t = c·y₀ − e·x₀ is the parameter.
------------------------------------------------------------------------

private
  compX : (a Mz x₀ y₀ x y : ℤ)
        → (x₀ + ((x + (- x₀)) · y₀ + (- ((y + (- y₀)) · x₀))) · Mz)
            + (a · (x + (- x₀)) + Mz · (y + (- y₀))) · x₀
          ≡ x₀ + (x + (- x₀)) · (a · x₀ + Mz · y₀)
  compX a Mz x₀ y₀ x y = solve! ℤCommRing

  compX' : (x x₀ : ℤ) → x₀ + (x + (- x₀)) ≡ x
  compX' x x₀ = solve! ℤCommRing

  compY : (a Mz x₀ t y : ℤ)
        → a · (x₀ + t · Mz) + Mz · y ≡ a · x₀ + Mz · (a · t + y)
  compY a Mz x₀ t y = solve! ℤCommRing

  compY' : (a t y : ℤ) → y ≡ (a · t + y) + (- (t · a))
  compY' a t y = solve! ℤCommRing

  M≠0 : (m : ℕ) → ¬ pos (suc m) ≡ pos 0
  M≠0 m p = snotz (injPos p)

-- every solution of a·x + M·y ≡ 1 is a member of the family through a
-- solution (x₀ , y₀) of the same equation.
complete₁ : (a x₀ y₀ x y : ℤ) (m : ℕ)
          → a · x₀ + pos (suc m) · y₀ ≡ pos 1
          → a · x  + pos (suc m) · y  ≡ pos 1
          → Σ[ t ∈ ℤ ] (x ≡ x₀ + t · pos (suc m)) × (y ≡ y₀ + (- (t · a)))
complete₁ a x₀ y₀ x y m P Q = t , xEq , yEq
  where
    Mz = pos (suc m)
    c  = x + (- x₀)
    e  = y + (- y₀)
    t  = c · y₀ + (- (e · x₀))
    D : a · c + Mz · e ≡ pos 0
    D = solutionsDiffer a Mz (pos 1) x y x₀ y₀ Q P
    xEq : x ≡ x₀ + t · Mz
    xEq = sym
      ( cong (λ z → (x₀ + t · Mz) + z) (sym (cong (_· x₀) D ∙ ·AnnihilL x₀))
      ∙ compX a Mz x₀ y₀ x y
      ∙ cong (λ z → x₀ + c · z) P
      ∙ cong (x₀ +_) (·IdR c)
      ∙ compX' x x₀ )
    aty≡y₀ : a · t + y ≡ y₀
    aty≡y₀ = ·lCancel Mz (a · t + y) y₀
      (inj-z+ {z = a · x₀}
        ( sym (compY a Mz x₀ t y)
        ∙ cong (λ z → a · z + Mz · y) (sym xEq)
        ∙ Q ∙ sym P ))
      (M≠0 m)
    yEq : y ≡ y₀ + (- (t · a))
    yEq = compY' a t y ∙ cong (_+ (- (t · a))) aty≡y₀

-- hence at g = 1 the iṣṭa is unique among ALL solutions: any two solutions
-- with x in [0 , suc m) agree in x and in y.
iṣṭaUnique₁ : (a x₀ y₀ : ℤ) (m : ℕ) → a · x₀ + pos (suc m) · y₀ ≡ pos 1
            → (r r' : ℕ) (y y' : ℤ) → r < suc m → r' < suc m
            → a · pos r  + pos (suc m) · y  ≡ pos 1
            → a · pos r' + pos (suc m) · y' ≡ pos 1
            → (r ≡ r') × (y ≡ y')
iṣṭaUnique₁ a x₀ y₀ m P r r' y y' r<M r'<M S S' =
  snd u , (snd (snd w) ∙ cong (λ z → y₀ + (- (z · a))) (fst u) ∙ sym (snd (snd w')))
  where
    w  = complete₁ a x₀ y₀ (pos r)  y  m P S
    w' = complete₁ a x₀ y₀ (pos r') y' m P S'
    u : (fst w ≡ fst w') × (r ≡ r')
    u = iṣṭaUnique x₀ m (fst w) (fst w') r r' r<M r'<M
                   (sym (fst (snd w))) (sym (fst (snd w')))

------------------------------------------------------------------------
-- ४ · Non-vacuity, on Kuttaka's own example: 7x + 5y = 1.
--
-- `Kuttaka.bezout` on the vallī 1, 2, 2 gives (x₀ , y₀) = (−2 , 3).  The
-- iṣṭa reduces x₀ modulo 5: −2 = (−1)·5 + 3, so t = 1 and the least
-- non-negative solution is (x , y) = (3 , −4): 21 − 20 = 1.  This is the
-- answer the classical procedure reports.  Everything below is by refl,
-- so it checks that `divℤ` and `iṣṭa` COMPUTE, and compute this.
------------------------------------------------------------------------

exampleIṣṭa : Iṣṭa (pos 7) (fst exampleSolves) (fst (snd exampleSolves)) (pos 1) 4
exampleIṣṭa = iṣṭa (pos 7) (fst exampleSolves) (fst (snd exampleSolves)) (pos 1) 4
                   (snd (snd exampleSolves))

-- bezout's pair, read off: x₀ = −2, y₀ = 3.
exampleX₀ : fst exampleSolves ≡ negsuc 1
exampleX₀ = refl

exampleY₀ : fst (snd exampleSolves) ≡ pos 3
exampleY₀ = refl

-- the division of x₀ = −2 by 5: quotient −1, remainder 3.
exampleDiv : (fst (divℤ (negsuc 1) 4) ≡ negsuc 0) × (fst (snd (divℤ (negsuc 1) 4)) ≡ 3)
exampleDiv = refl , refl

-- the iṣṭa: t = 1, x = 3, y = 3 − 1·7 = −4.
exampleT : fst exampleIṣṭa ≡ pos 1
exampleT = refl

exampleX : fst (snd exampleIṣṭa) ≡ 3
exampleX = refl

exampleY : fst (snd exampleSolves) + (- (fst exampleIṣṭa · pos 7)) ≡ negsuc 3
exampleY = refl

-- and it solves: 7·3 + 5·(−4) ≡ 1.
exampleSolvesLeast : pos 7 · pos 3 + pos 5 · negsuc 3 ≡ pos 1
exampleSolvesLeast = refl

-- uniqueness among all solutions: whoever solves 7x + 5y = 1 with 0 ≤ x < 5
-- has x = 3 and y = −4.
exampleUnique : (r : ℕ) (y : ℤ) → r < 5 → pos 7 · pos r + pos 5 · y ≡ pos 1
              → (r ≡ 3) × (y ≡ negsuc 3)
exampleUnique r y r<5 S =
  iṣṭaUnique₁ (pos 7) (fst exampleSolves) (fst (snd exampleSolves)) 4
              (snd (snd exampleSolves)) r 3 y (negsuc 3) r<5 (1 , refl)
              S refl
