{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PFreePart
--
-- The p-adic split, as a term:
--
--     pFreePart : 1 < p â’ 0 < m
--               â’ Î[ a ] Î[ m' ] ((m â‰¡ (p ^ a) Â m') — Â (p âˆ m'))
--
-- Every positive m factors as `p^a Â m'` with `p` not dividing `m'`.
-- Classical, and the piece `FrontierDivides` Â§2 needs â” that section
-- names the hard half of the universal property and says it requires
-- multiplicities, not just existence of a factorisation.  This is the
-- multiplicity, extracted one prime at a time.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- PRIOR ART
--
-- `CoprimeSplitting.decâˆ : (d n : â•) â’ 0 < d â’ Dec (d âˆ n)` is the
-- decision this needs, and that module's header explains why it exists:
-- cubical v0.5 has no decidable divisibility, so it is a bounded search
-- with fuel accounted for honestly.  The descent below is the same idiom
-- as `Factorisation.factorise-fuel`, one file over.
------------------------------------------------------------------------

module PFreePart where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility using (_âˆ£_ ; âˆ£-untrunc)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)

open import CoprimeSplitting using (decâˆ£)

------------------------------------------------------------------------
-- 1.  Dividing by p strictly shrinks a positive number, when p > 1
------------------------------------------------------------------------

private
  c<2c : (c : â„•) â†’ 0 < c â†’ c < 2 Â· c
  c<2c c 0<c = subst2 _â‰¤_ (+-comm c 1) (sym two-c) (â‰¤-k+ 0<c)
    where
    two-c : 2 Â· c â‰¡ c + c
    two-c = cong (c +_) (+-zero c)

  shrink : (c p m : â„•) â†’ 0 < c â†’ 1 < p â†’ c Â· p â‰¡ m â†’ c < m
  shrink c p m 0<c 1<p pc =
    subst (c <_) (Â·-comm p c âˆ™ pc) (<â‰¤-trans (c<2c c 0<c) (â‰¤-Â·k 1<p))

  cofactor-pos : (c p m : â„•) â†’ 0 < m â†’ c Â· p â‰¡ m â†’ 0 < c
  cofactor-pos zero    p m 0<m pc = Empty.rec (Â¬-<-zero (subst (0 <_) (sym pc) 0<m))
  cofactor-pos (suc c) p m _   _  = suc-â‰¤-suc zero-â‰¤

------------------------------------------------------------------------
-- 2.  THE SPLIT, by fuel â” this lane's idiom for a bounded descent
------------------------------------------------------------------------

Split : â„• â†’ â„• â†’ Type
Split p m = Î£[ a âˆˆ â„• ] Î£[ m' âˆˆ â„• ] ((m â‰¡ (p ^ a) Â· m') Ã— (Â¬ (p âˆ£ m')))

pFree-fuel : (fuel p m : â„•) â†’ 1 < p â†’ 0 < m â†’ m â‰¤ fuel â†’ Split p m
pFree-fuel zero    p m 1<p 0<m mâ‰¤f = Empty.rec (Â¬-<-zero (<â‰¤-trans 0<m mâ‰¤f))
pFree-fuel (suc f) p m 1<p 0<m mâ‰¤f = go (decâˆ£ p m (<-trans (suc-â‰¤-suc zero-â‰¤) 1<p))
  where
  go : Dec (p âˆ£ m) â†’ Split p m
  go (no Â¬pâˆ£m) = 0 , m , sym (Â·-identityË¡ m) , Â¬pâˆ£m
  go (yes pâˆ£m) = peel (âˆ£-untrunc pâˆ£m)
    where
    peel : Î£[ c âˆˆ â„• ] (c Â· p â‰¡ m) â†’ Split p m
    peel (c , pc) =
      suc (rec .fst) , rec .snd .fst ,
      ( sym pc
      âˆ™ cong (_Â· p) (rec .snd .snd .fst)
      âˆ™ regroup p (rec .fst) (rec .snd .fst) ) ,
      rec .snd .snd .snd
      where
      0<c : 0 < c
      0<c = cofactor-pos c p m 0<m pc

      c<m : c < m
      c<m = shrink c p m 0<c 1<p pc

      rec : Split p c
      rec = pFree-fuel f p c 1<p 0<c (pred-â‰¤-pred (<â‰¤-trans c<m mâ‰¤f))

      regroup : (p a m' : â„•) â†’ ((p ^ a) Â· m') Â· p â‰¡ (p ^ (suc a)) Â· m'
      regroup p a m' =
          sym (Â·-assoc (p ^ a) m' p)
        âˆ™ cong ((p ^ a) Â·_) (Â·-comm m' p)
        âˆ™ Â·-assoc (p ^ a) p m'
        âˆ™ cong (_Â· m') (Â·-comm (p ^ a) p)

pFreePart : (p m : â„•) â†’ 1 < p â†’ 0 < m â†’ Split p m
pFreePart p m 1<p 0<m = pFree-fuel m p m 1<p 0<m â‰¤-refl

------------------------------------------------------------------------
-- 3.  It runs.  12 = 2Â² Â 3, and 3 is not divisible by 2.
------------------------------------------------------------------------

split-12 : Split 2 12
split-12 = pFreePart 2 12 (suc-â‰¤-suc (suc-â‰¤-suc zero-â‰¤)) (suc-â‰¤-suc zero-â‰¤)

split-12-exponent : split-12 .fst â‰¡ 2
split-12-exponent = refl

split-12-cofactor : split-12 .snd .fst â‰¡ 3
split-12-cofactor = refl

-- ---------------------------------------------------------------------
-- The pieces `FrontierDividesHard` needs on top of this module:
--   (1) that `a â‰ âŠlog_p kâ‹` when `p^a âˆ m â‰ k`
--   (2) that `p` with its exponent is in `frontierList k`
--   (3) that `gcd(p^a, m') = 1` follows from `p âˆ m'`
--
-- `NaturalMachine/ExponentBound.agda` proves (1), as `exponent-bounded`, and
-- `FrontierMember` proves (2).
--
-- `NaturalMachine/PrimeCofactorCoprime.agda` proves (3): a common
-- divisor of a prime `p` and `m` is 1 or `p` by the lane's own `IsPrime`,
-- and `p âˆ m` kills the second branch, so it needs no Euclid.
-- ---------------------------------------------------------------------
