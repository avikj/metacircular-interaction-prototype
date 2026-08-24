-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- EXISTENCE OF LEAST COMMON MULTIPLES -- discharging the walk lane's
-- standing hypothesis.
--
-- NaturalMachine.WalkCapacity states the walk's laws through the
-- predicate
--
--   IsLCM xs L = CommonMultiple xs L × ((m : ℕ) → CommonMultiple xs m → L ∣ m)
--
-- and every theorem in WalkForcing / WalkCapacity / WalkStream /
-- WalkInduction takes `IsLCM S L` as a HYPOTHESIS, because cubical v0.5
-- ships no LCM module.  That made the capacity law construction-free but
-- left the whole lane CONDITIONAL on lcms existing.
--
-- WHAT IS PROVED HERE, UNCONDITIONALLY (no postulates, no holes):
--
--   lcm      : ℕ → ℕ → ℕ
--   lcm₂     : (a b : ℕ) → Σ[ L ∈ ℕ ] IsLCM₂ a b L
--   lcmList  : List ℕ → ℕ
--   lcmList-exists : (xs : List ℕ) → Σ[ L ∈ ℕ ] IsLCM xs L
--
-- for ARBITRARY lists of naturals -- no positivity hypothesis, zeros
-- included (lcm with 0 is 0, which is correct for the divisibility
-- lattice: 0 is its top element).  The hypothesis `IsLCM S L` is
-- therefore now always satisfiable, and every theorem in the walk lane
-- is unconditional.
--
-- METHOD.  The classical construction lcm a b = a·b / gcd a b, with the
-- quotient extracted by `∣-untrunc` (Cubical.Data.Nat.Divisibility --
-- divisibility is a propositional truncation, but its witness is unique
-- and the library already provides the untruncation).  Leastness is
-- proved WITHOUT Bezout, by the multiplicativity of gcd:
--
--   a ∣ m and b ∣ m  ⟹  a·b ∣ a·m and a·b ∣ b·m
--                    ⟹  a·b ∣ gcd (a·m) (b·m) = gcd a b · m = g·m
--                    ⟹  L·g ∣ m·g            (since a·b = L·g)
--                    ⟹  L ∣ m                (cancel g > 0).
--
-- `gcd-factorʳ` supplies the middle equality; `∣-cancelʳ` the last step.
-- When g = 0 the common-divisor property forces a ≡ 0 ≡ b and L = 0 is
-- immediate, so no positivity side condition survives.
--
-- The list lcm is the fold lcmList [] = 1, lcmList (x ∷ xs) =
-- lcm x (lcmList xs); its universal property is the binary one plus
-- transitivity of ∣, by induction on the list.  Predicates are the
-- recursive type families from WalkCapacity (indexed inductive families
-- over lists need injectivity of _∷_, unavailable in cubical Agda).
--
-- CHECKED: Agda 2.6.3, cubical v0.5, --cubical --safe, 2026-08-13.
-- No postulates, no holes.  Nothing is assumed.

module NaturalMachine.LCMExists where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.Nat.GCD
open import Cubical.Data.List
open import Cubical.Data.Sigma
open import Cubical.Data.Unit

open import NaturalMachine.WalkCapacity using (All; CommonMultiple; IsLCM)

-- the binary universal property
IsLCM₂ : ℕ → ℕ → ℕ → Type
IsLCM₂ a b L = (a ∣ L) × (b ∣ L) × ((m : ℕ) → a ∣ m → b ∣ m → L ∣ m)

-- ---------------------------------------------------------------------
-- the binary case
-- ---------------------------------------------------------------------

-- Parameterised by *any* gcd of a and b, so that the two cases (gcd
-- zero, gcd positive) can be taken apart before `gcd` is evaluated.
lcm₂-from-gcd : (a b g : ℕ) → isGCD a b g → Σ[ L ∈ ℕ ] IsLCM₂ a b L

-- g ≡ 0.  Then 0 ∣ a and 0 ∣ b, so a ≡ 0 ≡ b, and 0 is the lcm.
lcm₂-from-gcd a b zero ((g∣a , g∣b) , _) =
  0 , (∣-zeroʳ a , ∣-zeroʳ b , least)
  where
  0≡a : 0 ≡ a
  0≡a = ∣-zeroˡ g∣a

  least : (m : ℕ) → a ∣ m → b ∣ m → 0 ∣ m
  least m a∣m _ = subst (_∣ m) (sym 0≡a) a∣m

-- g ≡ suc k.  L = (a / g) · b.
lcm₂-from-gcd a b (suc k) gGCD =
  L , (a∣L , b∣L , least)
  where
  g : ℕ
  g = suc k

  g∣a : g ∣ a
  g∣a = gGCD .fst .fst

  g∣b : g ∣ b
  g∣b = gGCD .fst .snd

  q : ℕ
  q = ∣-untrunc g∣a .fst

  qg≡a : q · g ≡ a
  qg≡a = ∣-untrunc g∣a .snd

  r : ℕ
  r = ∣-untrunc g∣b .fst

  rg≡b : r · g ≡ b
  rg≡b = ∣-untrunc g∣b .snd

  L : ℕ
  L = q · b

  b∣L : b ∣ L
  b∣L = ∣-right q

  -- L = a · r as well, which is what makes a divide it
  ar≡L : a · r ≡ L
  ar≡L =
    a · r        ≡⟨ cong (_· r) (sym qg≡a) ⟩
    (q · g) · r  ≡⟨ sym (·-assoc q g r) ⟩
    q · (g · r)  ≡⟨ cong (q ·_) (·-comm g r) ⟩
    q · (r · g)  ≡⟨ cong (q ·_) rg≡b ⟩
    q · b        ∎

  a∣L : a ∣ L
  a∣L = subst (a ∣_) ar≡L (∣-left r)

  ab≡Lg : a · b ≡ L · g
  ab≡Lg =
    a · b        ≡⟨ cong (_· b) (sym qg≡a) ⟩
    (q · g) · b  ≡⟨ sym (·-assoc q g b) ⟩
    q · (g · b)  ≡⟨ cong (q ·_) (·-comm g b) ⟩
    q · (b · g)  ≡⟨ ·-assoc q b g ⟩
    (q · b) · g  ∎

  least : (m : ℕ) → a ∣ m → b ∣ m → L ∣ m
  least m a∣m b∣m = ∣-cancelʳ k Lg∣mg
    where
    ab∣am : (a · b) ∣ (a · m)
    ab∣am = subst2 _∣_ (·-comm b a) (·-comm m a) (∣-multʳ a b∣m)

    ab∣bm : (a · b) ∣ (b · m)
    ab∣bm = subst ((a · b) ∣_) (·-comm m b) (∣-multʳ b a∣m)

    ab∣gcd : (a · b) ∣ gcd (a · m) (b · m)
    ab∣gcd = gcdIsGCD (a · m) (b · m) .snd (a · b) (ab∣am , ab∣bm)

    gcd≡gm : gcd (a · m) (b · m) ≡ g · m
    gcd≡gm = gcd-factorʳ a b m ∙ cong (_· m) (isGCD→gcd≡ gGCD)

    ab∣gm : (a · b) ∣ (g · m)
    ab∣gm = subst ((a · b) ∣_) gcd≡gm ab∣gcd

    Lg∣mg : (L · suc k) ∣ (m · suc k)
    Lg∣mg = subst2 _∣_ ab≡Lg (·-comm g m) ab∣gm

lcm₂ : (a b : ℕ) → Σ[ L ∈ ℕ ] IsLCM₂ a b L
lcm₂ a b = lcm₂-from-gcd a b (gcd a b) (gcdIsGCD a b)

lcm : ℕ → ℕ → ℕ
lcm a b = lcm₂ a b .fst

lcm-isLCM₂ : (a b : ℕ) → IsLCM₂ a b (lcm a b)
lcm-isLCM₂ a b = lcm₂ a b .snd

-- ---------------------------------------------------------------------
-- the list case
-- ---------------------------------------------------------------------

All-∣-trans : (xs : List ℕ) {K L : ℕ} → K ∣ L →
              All (_∣ K) xs → All (_∣ L) xs
All-∣-trans []       _    _            = tt
All-∣-trans (x ∷ xs) K∣L (x∣K , rest) =
  ∣-trans x∣K K∣L , All-∣-trans xs K∣L rest

-- THE EXISTENCE THEOREM.  Every finite list of naturals has an lcm, in
-- the exact sense WalkCapacity's `IsLCM` demands.
lcmList-exists : (xs : List ℕ) → Σ[ L ∈ ℕ ] IsLCM xs L
lcmList-exists []       = 1 , (tt , λ m _ → ∣-oneˡ m)
lcmList-exists (x ∷ xs) =
  let K      = lcmList-exists xs .fst
      Kcm    = lcmList-exists xs .snd .fst
      Kleast = lcmList-exists xs .snd .snd
      L      = lcm x K
      x∣L    = lcm-isLCM₂ x K .fst
      K∣L    = lcm-isLCM₂ x K .snd .fst
      Lleast = lcm-isLCM₂ x K .snd .snd
  in L , ( (x∣L , All-∣-trans xs K∣L Kcm)
         , λ m cm → Lleast m (cm .fst) (Kleast m (cm .snd)) )

lcmList : List ℕ → ℕ
lcmList xs = lcmList-exists xs .fst

lcmList-isLCM : (xs : List ℕ) → IsLCM xs (lcmList xs)
lcmList-isLCM xs = lcmList-exists xs .snd
