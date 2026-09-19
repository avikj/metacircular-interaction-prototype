{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- JoinSavesTheMeet
--
-- A correction to `OverlapIsTheCost`, which got the SIGN wrong, and the
-- exact identity that fixes it.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE ERROR
--
-- `OverlapIsTheCost` concludes: "Every overlap is a place where the join
-- discards what the sum would have kept, and the discarded amount is the
-- whole difference between k! and lcm(1..k)."  Both halves of that
-- sentence are right and the reading of it is backwards.  Discarding
-- makes the state SMALLER.  lcm(1..k) = e^Ïˆ(k) â‰ˆ e^k while
-- k! = e^{k log k}: the join's state is exponentially smaller than the
-- sum's, and overlap is exactly where that saving happens.
--
--     Overlap is not the walk's cost.  Overlap is the walk's SAVING.
--
-- The title of that module is wrong and this one says so rather than
-- quietly editing it.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE EXACT IDENTITY
--
-- How much does the join save?  Exactly the meet, and the proof is one
-- line of tropical arithmetic:
--
--     max x y  +  min x y  â‰¡  x + y
--
-- lifted to derivations and pushed through `val`:
--
--     lcm-gcd :  val (u âŠ” v) Â val (u âŠ“ v)  â‰¡  val u Â val v
--
-- which is the classical lcm(a,b)Âgcd(a,b) = aÂb.  In the tropical chart
-- it is not a theorem about divisibility at all; it is max + min = x + y,
-- and every trace of number theory has evaporated.
--
-- So the join's compression ratio against the sum is the GCD, pointwise
-- and exactly.  Overlap is measured by the meet.  On the coprime locus
-- the meet is trivial (`disjointâ’meet-trivial`) and the join saves
-- nothing â” which is `OverlapIsTheCost.val-âŠ”-disjoint` recovered here as a
-- corollary of an identity rather than proved separately.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- AND WHAT THE WALK'S ACTUAL COST IS, STATED HONESTLY AS OPEN
--
-- If the join is a saving, the walk's e^Ïˆ(k) is what SURVIVES maximal
-- compression by it, not what the compression costs.  Distinguishing k
-- inputs needs log k bits; the walk carries Ïˆ(k) â‰ˆ k of them.  That gap
-- is not overlap and this thread has not located it.  Naming the previous
-- module's answer as wrong leaves the question open, and open is where it
-- honestly sits.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module JoinSavesTheMeet where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _Â·_ ; +-zero ; +-suc)
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)

open import SumProductTorus
  using (Exp ; zeroE ; _âŠ•_ ; _âŠ”_ ; _âŠ”â„•_ ; val ; val-âŠ• ; val-zero ; primes4)
open import OverlapIsTheCost using (Disjoint)

------------------------------------------------------------------------
-- 1.  The meet
------------------------------------------------------------------------

_âŠ“â„•_ : â„• â†’ â„• â†’ â„•
zero  âŠ“â„• n     = zero
suc m âŠ“â„• zero  = zero
suc m âŠ“â„• suc n = suc (m âŠ“â„• n)

infixl 5 _âŠ“_

_âŠ“_ : {bs : List â„•} â†’ Exp bs â†’ Exp bs â†’ Exp bs
_âŠ“_ {[]}     _        _        = tt
_âŠ“_ {b âˆ· bs} (x , xs) (y , ys) = (x âŠ“â„• y) , (xs âŠ“ ys)

------------------------------------------------------------------------
-- 2.  max + min = x + y, and everything follows
------------------------------------------------------------------------

max+min : (x y : â„•) â†’ (x âŠ”â„• y) + (x âŠ“â„• y) â‰¡ x + y
max+min zero    y       = +-zero y
max+min (suc x) zero    = refl
max+min (suc x) (suc y) =
    +-suc (suc (x âŠ”â„• y)) (x âŠ“â„• y)
  âˆ™ cong suc (cong suc (max+min x y))
  âˆ™ sym (cong suc (+-suc x y))

-- the derivation-level identity: join âŠ• meet = the two of them summed
âŠ”-âŠ“-âŠ• : (bs : List â„•) (u v : Exp bs) â†’ ((u âŠ” v) âŠ• (u âŠ“ v)) â‰¡ (u âŠ• v)
âŠ”-âŠ“-âŠ• []       _        _        = refl
âŠ”-âŠ“-âŠ• (b âˆ· bs) (x , xs) (y , ys) i =
  max+min x y i , âŠ”-âŠ“-âŠ• bs xs ys i

------------------------------------------------------------------------
-- 3.  lcm Â gcd = product, as a consequence, with no divisibility used
------------------------------------------------------------------------

lcm-gcd : (bs : List â„•) (u v : Exp bs)
        â†’ val bs (u âŠ” v) Â· val bs (u âŠ“ v) â‰¡ val bs u Â· val bs v
lcm-gcd bs u v =
    sym (val-âŠ• bs (u âŠ” v) (u âŠ“ v))
  âˆ™ cong (val bs) (âŠ”-âŠ“-âŠ• bs u v)
  âˆ™ val-âŠ• bs u v

-- and therefore the join's state always divides the sum's: the saving is
-- the meet, with an explicit witness rather than a truncated divisibility.
âŠ”â‰¤âŠ• : (bs : List â„•) (u v : Exp bs)
    â†’ Î£[ w âˆˆ Exp bs ] ((u âŠ” v) âŠ• w) â‰¡ (u âŠ• v)
âŠ”â‰¤âŠ• bs u v = (u âŠ“ v) , âŠ”-âŠ“-âŠ• bs u v

------------------------------------------------------------------------
-- 4.  Coprime = the meet is trivial = the join saves nothing
------------------------------------------------------------------------

meetâ„•-triv : (x y : â„•) â†’ (x â‰¡ 0) âŠŽ (y â‰¡ 0) â†’ x âŠ“â„• y â‰¡ 0
meetâ„•-triv x y (inl p) = cong (_âŠ“â„• y) p
meetâ„•-triv zero    y (inr q) = refl
meetâ„•-triv (suc x) y (inr q) = cong (suc x âŠ“â„•_) q

disjointâ†’meet-trivial :
  (bs : List â„•) (u v : Exp bs) â†’ Disjoint bs u v â†’ (u âŠ“ v) â‰¡ zeroE bs
disjointâ†’meet-trivial []       _        _        _        = refl
disjointâ†’meet-trivial (b âˆ· bs) (x , xs) (y , ys) (d , ds) i =
  meetâ„•-triv x y d i , disjointâ†’meet-trivial bs xs ys ds i

-- `OverlapIsTheCost.val-âŠ”-disjoint`, recovered as a corollary of the
-- identity instead of proved on its own.
val-âŠ”-coprime : (bs : List â„•) (u v : Exp bs) â†’ Disjoint bs u v
              â†’ val bs (u âŠ” v) Â· 1 â‰¡ val bs u Â· val bs v
val-âŠ”-coprime bs u v d =
    cong (val bs (u âŠ” v) Â·_)
         (sym (cong (val bs) (disjointâ†’meet-trivial bs u v d) âˆ™ val-zero bs))
  âˆ™ lcm-gcd bs u v

------------------------------------------------------------------------
-- 5.  It runs: the smallest overlap, and the saving it produces.
--
--   4 = (2,0,0,0)   8 = (3,0,0,0)   join 8, meet 4, product 32.
--   8 Â 4 = 32 = 4 Â 8.   The join saved a factor of 4, which is the gcd.
------------------------------------------------------------------------

four : Exp primes4
four = 2 , 0 , 0 , 0 , tt

eight : Exp primes4
eight = 3 , 0 , 0 , 0 , tt

join-is-eight : val primes4 (_âŠ”_ {primes4} four eight) â‰¡ 8
join-is-eight = refl

meet-is-four : val primes4 (_âŠ“_ {primes4} four eight) â‰¡ 4
meet-is-four = refl

saving-is-exact : val primes4 (_âŠ”_ {primes4} four eight)
                Â· val primes4 (_âŠ“_ {primes4} four eight)
                â‰¡ val primes4 four Â· val primes4 eight
saving-is-exact = lcm-gcd primes4 four eight

------------------------------------------------------------------------
-- 6.  The corrected sentence.
--
-- The join is a compression of the sum whose ratio is exactly the meet.
-- Overlap is where it compresses; coprimality is where it does not.  The
-- walk's residual e^Ïˆ(k) is therefore what survives maximal compression,
-- and locating THAT is a question this thread has not answered and should
-- stop claiming to have.
------------------------------------------------------------------------
