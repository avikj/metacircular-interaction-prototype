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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PMNoSection
--
-- The Peres–Mermin section failure, in the constructive lane: nine
-- F₂ unknowns on a 3×3 square, six contexts (rows even, first two
-- columns even, third column ODD — the sign vector cf-archivist
-- derived from the exact Weyl cocycle).  Every context admits local
-- sections (`local·`, exhibited), but NO global assignment satisfies
-- all six: `noGlobal`.
--
-- The exhaustion over all 512 assignments is performed BY THE
-- TYPECHECKER: the certificate `exhaust` is `refl`, whose checking
-- normalizes the 512-fold conjunction to `true`.  A proof that runs —
-- the button's stance one level down.
--
-- Bridge (cf-archivist's PM_SECTION_VS_COCYCLE, msg 0368/0369): this
-- is descent of SECTIONS where DescentLaw is descent of OBSERVABLES —
-- all local factorizations exist, the assembly is obstructed, and the
-- obstruction class is the parity functional.  H¹ to DescentLaw's H⁰.
------------------------------------------------------------------------

module PMNoSection where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool
  using (Bool ; true ; false ; not ; _and_ ; _⊕_)
open import Cubical.Data.Vec using (Vec ; [] ; _∷_)

-- exhaustive verification with a soundness certificate ---------------

allVec : (n : ℕ) → (Vec Bool n → Bool) → Bool
allVec zero f = f []
allVec (suc n) f =
  allVec n (λ v → f (true ∷ v)) and allVec n (λ v → f (false ∷ v))

private
  andL : (x y : Bool) → x and y ≡ true → x ≡ true
  andL true y p = refl
  andL false y p = p

  andR : (x y : Bool) → x and y ≡ true → y ≡ true
  andR true y p = p
  andR false true p = refl
  andR false false p = p

sound : (n : ℕ) (f : Vec Bool n → Bool)
      → allVec n f ≡ true → (v : Vec Bool n) → f v ≡ true
sound zero f p [] = p
sound (suc n) f p (true ∷ v) =
  sound n (λ w → f (true ∷ w))
    (andL (allVec n (λ w → f (true ∷ w)))
          (allVec n (λ w → f (false ∷ w))) p) v
sound (suc n) f p (false ∷ v) =
  sound n (λ w → f (false ∷ w))
    (andR (allVec n (λ w → f (true ∷ w)))
          (allVec n (λ w → f (false ∷ w))) p) v

-- the Peres–Mermin square ---------------------------------------------

even3 odd3 : Bool → Bool → Bool → Bool
even3 x y z = not (x ⊕ (y ⊕ z))
odd3 x y z = x ⊕ (y ⊕ z)

-- observables laid out row-major: a b c / d e f / g h i
sat : Vec Bool 9 → Bool
sat (a ∷ b ∷ c ∷ d ∷ e ∷ f ∷ g ∷ h ∷ i ∷ []) =
  even3 a b c and (even3 d e f and (even3 g h i and
  (even3 a d g and (even3 b e h and odd3 c f i))))

-- the typechecker runs all 512 assignments here -----------------------

private
  exhaust : allVec 9 (λ v → not (sat v)) ≡ true
  exhaust = refl

  notTrue : (b : Bool) → not b ≡ true → b ≡ false
  notTrue false p = refl
  notTrue true p = sym p

-- no global section ----------------------------------------------------

noGlobal : (v : Vec Bool 9) → sat v ≡ false
noGlobal v = notTrue (sat v) (sound 9 (λ w → not (sat w)) exhaust v)

-- every context admits local sections (one exhibited per context) -----

localRow1 : even3 false false false ≡ true
localRow1 = refl
localRow2 : even3 true true false ≡ true
localRow2 = refl
localRow3 : even3 true false true ≡ true
localRow3 = refl
localCol1 : even3 false false false ≡ true
localCol1 = refl
localCol2 : even3 true true false ≡ true
localCol2 = refl
localCol3 : odd3 true false false ≡ true
localCol3 = refl
