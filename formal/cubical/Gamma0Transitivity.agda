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
-- Gamma0Transitivity
--
-- Transitivity of the payload action over all of ℤ: between any two
-- normalization events of the same matrix m, the explicit transporter
--
--     H = εᵤ · U′ · adj U            (H · U ≡ U′ : `moves`)
--
-- carries the first event to the second, and with
--
--     K = εᵥ · adj V · V′
--
-- STABILIZES the endpoint (`stabilizes`):
--
--     H · (U·m·V) · K ≡ U·m·V   whenever  U′·m·V′ ≡ U·m·V.
--
-- Feeding `stabilizes` to Gamma0Converse extracts the congruence
-- membership of H; with Gamma0Freeness this completes the torsor:
-- free and transitive, every clause a program.
------------------------------------------------------------------------

module Gamma0Transitivity where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open import Gamma0Partner using (R ; M ; mul ; dia)
open import M2Unimodular using (adj ; det ; adjL ; adjR)
open import Gamma0Freeness using (mulAssoc)

open CommRingStr (ℤCommRing .snd)

scal : R → M → M
scal s (a , b , c , e) = (s · a , s · b , s · c , s · e)

-- entrywise lemmas (one solver shape per lemma, reused) --------------

private
  eL : (s a b a' c' : R)
     → (s · a) · a' + (s · b) · c' ≡ s · (a · a' + b · c')
  eL _ _ _ _ _ = solve! ℤCommRing
  eR : (s a b a' c' : R)
     → a · (s · a') + b · (s · c') ≡ s · (a · a' + b · c')
  eR _ _ _ _ _ = solve! ℤCommRing
  eS : (s t a : R) → s · (t · a) ≡ (s · t) · a
  eS _ _ _ = solve! ℤCommRing
  -- ℤ reduction facts (probed): 0r·a, 1r·a, a+0r reduce; the mirrored
  -- forms are stuck — entry lemmas are written against normal forms
  eE : (d c : R) → 0r + d · c ≡ d · c
  eE _ _ = solve! ℤCommRing

scalL : (s : R) (x y : M) → mul (scal s x) y ≡ scal s (mul x y)
scalL s (a , b , c , e) (a' , b' , c' , e') i =
  ( eL s a b a' c' i , eL s a b b' e' i
  , eL s c e a' c' i , eL s c e b' e' i )

scalR : (s : R) (x y : M) → mul x (scal s y) ≡ scal s (mul x y)
scalR s (a , b , c , e) (a' , b' , c' , e') i =
  ( eR s a b a' c' i , eR s a b b' e' i
  , eR s c e a' c' i , eR s c e b' e' i )

scalScal : (s t : R) (x : M) → scal s (scal t x) ≡ scal (s · t) x
scalScal s t (a , b , c , e) i =
  ( eS s t a i , eS s t b i , eS s t c i , eS s t e i )

scalOne : (x : M) → scal 1r x ≡ x
scalOne (a , b , c , e) i =
  ( ·IdL a i , ·IdL b i , ·IdL c i , ·IdL e i )

diaL : (d : R) (x : M) → mul (dia d d) x ≡ scal d x
diaL d (a , b , c , e) i =
  ( d · a , d · b , eE d c i , eE d e i )

diaR : (d : R) (x : M) → mul x (dia d d) ≡ scal d x
diaR d (a , b , c , e) i =
  ( iRa d a b i , iRb d a b i , iRa d c e i , iRb d c e i )
  where
  iRa : (d a b : R) → a · d + b · 0r ≡ d · a
  iRa _ _ _ = solve! ℤCommRing
  iRb : (d a b : R) → a · 0r + b · d ≡ d · b
  iRb _ _ _ = solve! ℤCommRing

congScal : {s t : R} (x : M) → s ≡ t → scal s x ≡ scal t x
congScal x p i = scal (p i) x

-- the theorems --------------------------------------------------------

module _ (U U' V V' m : M) (εu εv : R)
         (hdU : det U ≡ εu) (hεu : εu · εu ≡ 1r)
         (hdV : det V ≡ εv) (hεv : εv · εv ≡ 1r)
         where

  H K : M
  H = scal εu (mul U' (adj U))
  K = scal εv (mul (adj V) V')

  private
    unitU : εu · det U ≡ 1r
    unitU = cong (εu ·_) hdU ∙ hεu
    unitV : εv · det V ≡ 1r
    unitV = cong (εv ·_) hdV ∙ hεv

  -- the transporter moves the first event to the second
  moves : mul H U ≡ U'
  moves =
    scalL εu (mul U' (adj U)) U
    ∙ cong (scal εu)
        ( mulAssoc U' (adj U) U
        ∙ cong (mul U') (adjL U)
        ∙ diaR (det U) U' )
    ∙ scalScal εu (det U) U'
    ∙ congScal U' unitU
    ∙ scalOne U'

  -- W = the shared endpoint of both events
  private
    W : M
    W = mul (mul U m) V

  -- H · W collapses to the second factorization
  private
    collapseH : mul H W ≡ mul (mul U' m) V
    collapseH =
      scalL εu (mul U' (adj U)) W
      ∙ cong (scal εu)
          ( mulAssoc U' (adj U) W
          ∙ cong (mul U')
              ( sym (mulAssoc (adj U) (mul U m) V)
              ∙ cong (λ w → mul w V)
                  ( sym (mulAssoc (adj U) U m)
                  ∙ cong (λ w → mul w m) (adjL U)
                  ∙ diaL (det U) m )
              ∙ scalL (det U) m V )
          ∙ scalR (det U) U' (mul m V) )
      ∙ scalScal εu (det U) (mul U' (mul m V))
      ∙ congScal (mul U' (mul m V)) unitU
      ∙ scalOne (mul U' (mul m V))
      ∙ sym (mulAssoc U' m V)

  -- and K absorbs on the right, closing the loop
  stabilizes : mul (mul U' m) V' ≡ W
             → mul (mul H W) K ≡ W
  stabilizes hEq =
    cong (λ w → mul w K) collapseH
    ∙ scalR εv (mul (mul U' m) V) (mul (adj V) V')
    ∙ cong (scal εv)
        ( mulAssoc (mul U' m) V (mul (adj V) V')
        ∙ cong (mul (mul U' m))
            ( sym (mulAssoc V (adj V) V')
            ∙ cong (λ w → mul w V') (adjR V)
            ∙ diaL (det V) V' )
        ∙ scalR (det V) (mul U' m) V' )
    ∙ scalScal εv (det V) (mul (mul U' m) V')
    ∙ congScal (mul (mul U' m) V') unitV
    ∙ scalOne (mul (mul U' m) V')
    ∙ hEq
