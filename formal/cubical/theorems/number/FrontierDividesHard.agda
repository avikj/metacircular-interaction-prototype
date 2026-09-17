{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FrontierDividesHard
--
-- `FrontierDivides` Â§2, the half its own header called hard and said no
-- amount of certificate-composition would produce:
--
--     frontier-divides-hard :
--       0 < m â’ m â‰ k â’ m âˆ prodOf (frontierList k)
--
-- Together with `FrontierDivides.frontier-divides` (the other half) this
-- is the universal property of `prodOf (frontierList k)` as the lcm of
-- 1 â¦ k, which CLAUDE.md requires be stated that way because cubical
-- v0.5 has no LCM module.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE ASSEMBLY
--
-- Strong induction on m, peeled one prime at a time:
--
--   m > 1  âŸ  p prime with p âˆ m                    CoprimeSplitting
--   m = p^a Â m'  with  p âˆ m'                       PFreePart
--   a â‰ logOf p k                                    ExponentBound
--   (p , logOf p k) âˆˆ frontierList k                 FrontierMember
--   p^a âˆ p^(logOf p k) âˆ prodOf (frontierList k)    Â§1, Â§2 below
--   m' âˆ prodOf (frontierList k)                     induction, m' < m
--   isGCD (p^a) m' 1                                 PrimeCofactorCoprime
--   âŸ (p^a Â m') âˆ prodOf                            FinCardinality.gauss
--
-- Every line but the two in Â§1â“Â§2 is a module this thread built for the
-- purpose, and those two are list and power bookkeeping.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT `FrontierDivides` GOT RIGHT AND WHAT IT GOT WRONG
--
-- Right: that this half needs existence of prime factorisation, strong
-- induction on m, and a smallest-divisor argument.  All three are used.
--
-- Wrong: "no amount of certificate-composition produces it".  The
-- certificates do most of it.  What was actually missing was smaller
-- and duller than that sentence suggests â” a specification for `logOf`
-- (which turned out not to exist at all), a membership lemma, and a
-- coprimality lemma that is three lines.  The asymmetry between the two
-- halves is real but it is a factor of six modules, not a difference in
-- kind.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module FrontierDividesHard where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility
  using (_âˆ£_ ; âˆ£-refl ; âˆ£-trans ; âˆ£-left ; âˆ£-right ; âˆ£-oneË¡ ; mâˆ£nâ†’mâ‰¤n)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

open import FinCardinality using (gauss)
open import WalkJumps using (IsPrime)
open import FrontierCount using (Entry ; prodOf)
open import FrontierList using (frontierList ; logOf)
open import FrontierMember using (Mem ; frontier-member)
open import ExponentBound using (exponent-bounded ; ^-pos ; x<pÂ·x)
open import PFreePart using (pFreePart)
open import PrimeCofactorCoprime using (prime-power-âˆ¤-coprime)
open import CoprimeSplitting using (primeDivisor)

------------------------------------------------------------------------
-- 1.  An entry divides the product of the list it is in
------------------------------------------------------------------------

entry-âˆ£-prod : (p i : â„•) (es : List Entry)
             â†’ Mem (p , i) es â†’ (p ^ i) âˆ£ prodOf es
entry-âˆ£-prod p i []             m = Empty.rec m
entry-âˆ£-prod p i ((q , j) âˆ· es) m = go m
  where
  go : (((p , i) â‰¡ (q , j)) âŠŽ Mem (p , i) es)
     â†’ (p ^ i) âˆ£ ((q ^ j) Â· prodOf es)
  go (inl e) =
    subst (Î» z â†’ (fst z ^ snd z) âˆ£ ((q ^ j) Â· prodOf es)) (sym e)
          (âˆ£-left (prodOf es))
  go (inr r) = âˆ£-trans (entry-âˆ£-prod p i es r) (âˆ£-right (q ^ j))

------------------------------------------------------------------------
-- 2.  Powers divide upward
------------------------------------------------------------------------

^-âˆ£ : (p a b : â„•) â†’ a â‰¤ b â†’ (p ^ a) âˆ£ (p ^ b)
^-âˆ£ p a b (d , q) = subst (Î» z â†’ (p ^ a) âˆ£ (p ^ z)) q (climb d)
  where
  climb : (e : â„•) â†’ (p ^ a) âˆ£ (p ^ (e + a))
  climb zero    = âˆ£-refl refl
  climb (suc e) = âˆ£-trans (climb e) (âˆ£-right p)

------------------------------------------------------------------------
-- 3.  Small arithmetic the peel needs
------------------------------------------------------------------------

private
  0<p-of : {p : â„•} â†’ 1 < p â†’ 0 < p
  0<p-of 1<p = â‰¤-trans â‰¤-sucâ„• 1<p

  -- 1 < p and 0 < p^e give 1 < p^(suc e), since p^(suc e) = p Â p^e â‰ p
  1<pow : (p e : â„•) â†’ 1 < p â†’ 1 < (p ^ (suc e))
  1<pow p e 1<p = <â‰¤-trans 1<p step
    where
    step : p â‰¤ (p ^ (suc e))
    step = subst2 _â‰¤_ (Â·-identityË¡ p) (Â·-comm (p ^ e) p)
                  (â‰¤-Â·k {k = p} (^-pos p e (0<p-of 1<p)))

  mâ‰¢0 : (n : â„•) â†’ 0 < n â†’ Â¬ (n â‰¡ 0)
  mâ‰¢0 n 0<n q = Â¬-<-zero (subst (0 <_) q 0<n)

  -- 0 < a Â b forces 0 < b
  posSnd : (a b : â„•) â†’ 0 < (a Â· b) â†’ 0 < b
  posSnd a zero    0<ab = Empty.rec (Â¬-<-zero (subst (0 <_) (sym (0â‰¡mÂ·0 a)) 0<ab))
  posSnd a (suc b) _    = suc-â‰¤-suc zero-â‰¤

------------------------------------------------------------------------
-- 4.  THE HARD HALF, by fuelled strong induction on m
------------------------------------------------------------------------

hard-fuel : (fuel k m : â„•) â†’ 0 < m â†’ m â‰¤ k â†’ m â‰¤ fuel
          â†’ m âˆ£ prodOf (frontierList k)
hard-fuel zero k m 0<m mâ‰¤k mâ‰¤f =
  Empty.rec (Â¬-<-zero (<â‰¤-trans 0<m mâ‰¤f))
hard-fuel (suc f) k m 0<m mâ‰¤k mâ‰¤f = small (splitâ„•-â‰¤ m 1)
  where
  P : â„•
  P = prodOf (frontierList k)

  small : ((m â‰¤ 1) âŠŽ (1 < m)) â†’ m âˆ£ P
  small (inl mâ‰¤1) = subst (_âˆ£ P) (sym mâ‰¡1) (âˆ£-oneË¡ P)
    where
    mâ‰¡1 : m â‰¡ 1
    mâ‰¡1 = â‰¤-antisym mâ‰¤1 0<m
  small (inr 1<m) = peel (primeDivisor m 1<m)
    where
    peel : Î£[ p âˆˆ â„• ] (IsPrime p Ã— (p âˆ£ m)) â†’ m âˆ£ P
    peel (p , pp , pâˆ£m) = split (pFreePart p m (pp .fst) 0<m)
      where
      pâ‰¤k : p â‰¤ k
      pâ‰¤k = â‰¤-trans (mâˆ£nâ†’mâ‰¤n (mâ‰¢0 m 0<m) pâˆ£m) mâ‰¤k

      -- the frontier entry for p, and everything below it
      entryâˆ£ : (p ^ (logOf p k)) âˆ£ P
      entryâˆ£ = entry-âˆ£-prod p (logOf p k) (frontierList k)
                 (frontier-member p k pp pâ‰¤k)

      split : Î£[ a âˆˆ â„• ] Î£[ m' âˆˆ â„• ] ((m â‰¡ (p ^ a) Â· m') Ã— (Â¬ (p âˆ£ m')))
            â†’ m âˆ£ P
      split (a , m' , mâ‰¡ , pâˆ¤m') = subst (_âˆ£ P) (sym mâ‰¡) productâˆ£
        where
        0<m' : 0 < m'
        0<m' = posSnd (p ^ a) m' (subst (0 <_) mâ‰¡ 0<m)

        paâˆ£m : (p ^ a) âˆ£ m
        paâˆ£m = subst ((p ^ a) âˆ£_) (sym mâ‰¡) (âˆ£-left m')

        aâ‰¤log : a â‰¤ logOf p k
        aâ‰¤log = exponent-bounded p k m a (pp .fst) 0<m mâ‰¤k paâˆ£m

        paâˆ£P : (p ^ a) âˆ£ P
        paâˆ£P = âˆ£-trans (^-âˆ£ p a (logOf p k) aâ‰¤log) entryâˆ£

        -- a â‰¡ 0 would make m' â‰¡ m, and then p âˆ m' contradicts p âˆ m
        m'<m : m' < m
        m'<m = shrink a refl
          where
          shrink : (e : â„•) â†’ e â‰¡ a â†’ m' < m
          shrink zero eâ‰¡a =
            Empty.rec (pâˆ¤m' (subst (p âˆ£_) m'â‰¡m pâˆ£m))
            where
            m'â‰¡m : m â‰¡ m'
            m'â‰¡m = mâ‰¡ âˆ™ cong (Î» z â†’ (p ^ z) Â· m') (sym eâ‰¡a) âˆ™ Â·-identityË¡ m'
          shrink (suc e) eâ‰¡a =
            subst (m' <_) (sym mâ‰¡)
              (subst (Î» z â†’ m' < ((p ^ z) Â· m')) eâ‰¡a
                (x<pÂ·x (p ^ (suc e)) m' (1<pow p e (pp .fst)) 0<m'))

        m'âˆ£P : m' âˆ£ P
        m'âˆ£P = hard-fuel f k m' 0<m'
                 (â‰¤-trans (<-weaken m'<m) mâ‰¤k)
                 (pred-â‰¤-pred (<â‰¤-trans m'<m mâ‰¤f))

        productâˆ£ : ((p ^ a) Â· m') âˆ£ P
        productâˆ£ = gauss (p ^ a) m' P
                     (prime-power-âˆ¤-coprime p m' a pp pâˆ¤m')
                     paâˆ£P m'âˆ£P

------------------------------------------------------------------------
-- 5.  THE STATEMENT
------------------------------------------------------------------------

frontier-divides-hard :
  (k m : â„•) â†’ 0 < m â†’ m â‰¤ k â†’ m âˆ£ prodOf (frontierList k)
frontier-divides-hard k m 0<m mâ‰¤k = hard-fuel m k m 0<m mâ‰¤k â‰¤-refl

------------------------------------------------------------------------
-- 6.  It runs.  prodOf (frontierList 8) = 840, and every m â‰ 8 divides
--     it â” including 8, 7, 6 and 5, which is the content.
------------------------------------------------------------------------

eight-divides : 8 âˆ£ prodOf (frontierList 8)
eight-divides = frontier-divides-hard 8 8 (suc-â‰¤-suc zero-â‰¤) â‰¤-refl

seven-divides : 7 âˆ£ prodOf (frontierList 8)
seven-divides = frontier-divides-hard 8 7 (suc-â‰¤-suc zero-â‰¤) (1 , refl)

six-divides : 6 âˆ£ prodOf (frontierList 8)
six-divides = frontier-divides-hard 8 6 (suc-â‰¤-suc zero-â‰¤) (2 , refl)

five-divides : 5 âˆ£ prodOf (frontierList 8)
five-divides = frontier-divides-hard 8 5 (suc-â‰¤-suc zero-â‰¤) (3 , refl)

------------------------------------------------------------------------
-- 7.  The universal property, both halves.
--
--   (a)  every m â‰ k divides prodOf (frontierList k)        here
--   (b)  prodOf (frontierList k) divides every common multiple
--                                                  FrontierDivides Â§2
--
-- So `prodOf (frontierList k)` IS lcm(1 â¦ k), stated by its universal
-- property because this lane has no LCM module â” which is what
-- CLAUDE.md asks for, and it is now a theorem rather than a `refl` at
-- k = 8.
------------------------------------------------------------------------
