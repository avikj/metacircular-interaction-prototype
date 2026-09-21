{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTrajectoryIsAChain
--
-- `JoinSavesTheMeet` withdrew the answer to "where does the walk's e^Ïˆ(k)
-- come from?".  This module removes a whole class of answers by proving
-- something about the walk:
--
--     along its own trajectory, the walk's join is never a join.
--
-- It is always an absorption â” one of the two arguments, returned.  The
-- machine's state law is a lattice operation, and the machine never once
-- uses the lattice.  It moves up a CHAIN.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHY THAT MATTERS FOR THE COST QUESTION
--
-- Six modules have now derived consequences from the join's idempotence:
-- no inverses, no norm, no forgetting, no sign.  All of them are true of
-- the join.  This one says the walk's trajectory never leaves a chain,
-- and on a chain the join has no content at all â” `chain-join-absorbs`
-- says every join along the trajectory returns an argument unchanged.
--
-- So the walk pays for a lattice of dimension Ï(k) with coordinates up to
-- log k, in order to move along a totally ordered path of length k.
--
-- That sentence is a READING.  What is proved is
-- the absorption, generally (from step-monotonicity alone) and concretely
-- (the first eight states of the actual walk, by `refl`).
------------------------------------------------------------------------

module TheTrajectoryIsAChain where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Order using (_â‰¤_ ; splitâ„•-â‰¤ ; <-weaken)
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (tt)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)

open import SumProductTorus
  using (Exp ; zeroE ; _âŠ”_ ; val ; primes4 ; âŠ”-comm)
open import IdempotenceForbidsDescent using (âŠ”-idem ; âŠ”-assoc)

------------------------------------------------------------------------
-- 1.  The lattice order, and its transitivity
------------------------------------------------------------------------

Below : {bs : List â„•} â†’ Exp bs â†’ Exp bs â†’ Type
Below u v = (u âŠ” v) â‰¡ v

below-trans : (bs : List â„•) (u v w : Exp bs)
            â†’ Below u v â†’ Below v w â†’ Below u w
below-trans bs u v w p q =
    cong (u âŠ”_) (sym q)
  âˆ™ sym (âŠ”-assoc bs u v w)
  âˆ™ cong (_âŠ” w) p
  âˆ™ q

------------------------------------------------------------------------
-- 2.  A step-monotone trajectory is a chain
------------------------------------------------------------------------

module _ (bs : List â„•) (t : â„• â†’ Exp bs)
         (step : (k : â„•) â†’ Below (t k) (t (suc k)))
         where

  below-add : (d m : â„•) â†’ Below (t m) (t (d + m))
  below-add zero    m = âŠ”-idem bs (t m)
  below-add (suc d) m =
    below-trans bs (t m) (t (d + m)) (t (suc (d + m)))
      (below-add d m) (step (d + m))

  below-â‰¤ : (m n : â„•) â†’ m â‰¤ n â†’ Below (t m) (t n)
  below-â‰¤ m n (d , p) = subst (Î» z â†’ Below (t m) (t z)) p (below-add d m)

  -- THE STATEMENT.  Any two states on the trajectory are comparable, so
  -- their join is one of them.  The join never constructs anything.
  chain-join-absorbs :
    (m n : â„•) â†’ ((t m âŠ” t n) â‰¡ t n) âŠŽ ((t m âŠ” t n) â‰¡ t m)
  chain-join-absorbs m n with splitâ„•-â‰¤ m n
  ... | inl mâ‰¤n = inl (below-â‰¤ m n mâ‰¤n)
  ... | inr n<m = inr (âŠ”-comm bs (t m) (t n) âˆ™ below-â‰¤ n m (<-weaken n<m))

------------------------------------------------------------------------
-- 3.  The actual walk, concretely: its first eight states, and the fact
--     that each absorbs the last.  Finite exhaustive verification.
--
--     cap 1..8  =  1, 2, 6, 12, 60, 60, 420, 840
------------------------------------------------------------------------

capE : â„• â†’ Exp primes4
capE zero                                      = 0 , 0 , 0 , 0 , tt
capE (suc zero)                                = 0 , 0 , 0 , 0 , tt
capE (suc (suc zero))                          = 1 , 0 , 0 , 0 , tt
capE (suc (suc (suc zero)))                    = 1 , 1 , 0 , 0 , tt
capE (suc (suc (suc (suc zero))))              = 2 , 1 , 0 , 0 , tt
capE (suc (suc (suc (suc (suc zero)))))        = 2 , 1 , 1 , 0 , tt
capE (suc (suc (suc (suc (suc (suc zero))))))  = 2 , 1 , 1 , 0 , tt
capE (suc (suc (suc (suc (suc (suc (suc zero))))))) = 2 , 1 , 1 , 1 , tt
capE _                                         = 3 , 1 , 1 , 1 , tt

-- the derivations do name lcm(1..k), by computation
cap-values :
    (val primes4 (capE 1) â‰¡ 1)
  Ã— (val primes4 (capE 2) â‰¡ 2)
  Ã— (val primes4 (capE 3) â‰¡ 6)
  Ã— (val primes4 (capE 4) â‰¡ 12)
  Ã— (val primes4 (capE 5) â‰¡ 60)
  Ã— (val primes4 (capE 6) â‰¡ 60)
  Ã— (val primes4 (capE 7) â‰¡ 420)
  Ã— (val primes4 (capE 8) â‰¡ 840)
cap-values = refl , refl , refl , refl , refl , refl , refl , refl

-- and every step absorbs: the join is doing nothing
cap-absorbs :
    (_âŠ”_ {primes4} (capE 1) (capE 2) â‰¡ capE 2)
  Ã— (_âŠ”_ {primes4} (capE 2) (capE 3) â‰¡ capE 3)
  Ã— (_âŠ”_ {primes4} (capE 3) (capE 4) â‰¡ capE 4)
  Ã— (_âŠ”_ {primes4} (capE 4) (capE 5) â‰¡ capE 5)
  Ã— (_âŠ”_ {primes4} (capE 5) (capE 6) â‰¡ capE 6)
  Ã— (_âŠ”_ {primes4} (capE 6) (capE 7) â‰¡ capE 7)
  Ã— (_âŠ”_ {primes4} (capE 7) (capE 8) â‰¡ capE 8)
cap-absorbs = refl , refl , refl , refl , refl , refl , refl

-- non-trivial joins DO exist in this lattice â” the walk simply never
-- reaches them.  4 and 3 are incomparable and their join is neither.
fourE : Exp primes4
fourE = 2 , 0 , 0 , 0 , tt

threeE : Exp primes4
threeE = 0 , 1 , 0 , 0 , tt

lattice-is-not-a-chain-here :
    (val primes4 (_âŠ”_ {primes4} fourE threeE) â‰¡ 12)
  Ã— (val primes4 fourE â‰¡ 4)
  Ã— (val primes4 threeE â‰¡ 3)
lattice-is-not-a-chain-here = refl , refl , refl

------------------------------------------------------------------------
-- 4.  What is now removed from the space of answers.
--
-- The walk's cost cannot be explained by anything the join does at
-- incomparable states, because the walk never visits an incomparable
-- pair.  Every idempotence consequence in this thread â” no inverses, no
-- norm, no forgetting, no sign â” holds along a path on which the join is
-- pure absorption.  Whatever Ïˆ(k) is paying for, it is not the width of
-- the lattice.
--
-- The question stands where `JoinSavesTheMeet` left it, one class of
-- answers narrower.
------------------------------------------------------------------------
