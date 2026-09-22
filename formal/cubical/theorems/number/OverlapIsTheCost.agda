{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- OverlapIsTheCost
--
-- `SignIsNotAccumulable` states a conditional with two antecedents.  The
-- second antecedent is false, and this module kills it â” then keeps what
-- the death exposes
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE REFUTATION
--
-- Sieve weights are multiplicative across COPRIME arguments.  In the
-- derivation chart coprime means DISJOINT SUPPORT, and on disjoint
-- supports the two operations of this whole thread coincide:
--
--     disjoint-agree :  Disjoint u v  â’  u âŠ” v â‰¡ u âŠ• v
--
-- The join and the sum are the same operation there.  And nothing is
-- disjoint from itself except the trivial state:
--
--     self-disjoint-is-trivial :  Disjoint u u  â’  u â‰¡ 0
--
-- So on the coprime locus idempotence has no purchase at all â” you cannot
-- form `u â‹ u` and stay inside it â” and `SignIsNotAccumulable`'s
-- hypothesis is unsatisfiable except at the unit.  The theorem is true
-- and simply does not reach Î¼ or Î».  The rhyme is dead.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THE DEATH EXPOSES
--
-- `NoNormOnAJoin` proved a multiplicative norm for a join is two-valued.
-- But `val` IS multiplicative for the join on disjoint arguments:
--
--     val-âŠ”-disjoint :  Disjoint u v  â’  val (u âŠ” v) â‰¡ val u Â val v
--
-- â” an unrestricted, faithful, wildly-many-valued multiplicative weight
-- for the join, defined exactly on the coprime pairs.  So the earlier
-- theorem's strength comes entirely from quantifying over ALL pairs.  The
-- obstruction is not the join.  **The obstruction is overlap.**
--
-- And that locates the walk's overlap precisely.  A sieve only ever
-- combines coprime data, so it lives on the locus where join = sum and a
-- faithful weight exists.  The walk combines 1,2,3,4,â¦, and 2, 4, 8 all
-- touch the prime 2: its data overlap constantly.  Every overlap is a
-- place where the join discards what the sum would have kept, and the
-- discarded amount is the whole difference between k! and lcm(1..k).
--
--     the walk's saving is its overlap, and overlap is exactly the locus
--     where the two operations disagree.
------------------------------------------------------------------------

module OverlapIsTheCost where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _Â·_ ; +-zero)
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)

open import SumProductTorus
  using (Exp ; zeroE ; _âŠ•_ ; _âŠ”_ ; _âŠ”â„•_ ; val ; val-âŠ• ; primes4)
open import IdempotenceForbidsDescent using (âŠ”â„•-idr)

------------------------------------------------------------------------
-- 1.  Disjoint support = coprime
------------------------------------------------------------------------

Disjoint : (bs : List â„•) â†’ Exp bs â†’ Exp bs â†’ Type
Disjoint []       _        _        = Unit
Disjoint (b âˆ· bs) (x , xs) (y , ys) = ((x â‰¡ 0) âŠŽ (y â‰¡ 0)) Ã— Disjoint bs xs ys

------------------------------------------------------------------------
-- 2.  On the coprime locus the join IS the sum
------------------------------------------------------------------------

agreeâ„• : (x y : â„•) â†’ (x â‰¡ 0) âŠŽ (y â‰¡ 0) â†’ x âŠ”â„• y â‰¡ x + y
agreeâ„• x y (inl p) = cong (_âŠ”â„• y) p âˆ™ sym (cong (_+ y) p)
agreeâ„• x y (inr q) =
  cong (x âŠ”â„•_) q âˆ™ âŠ”â„•-idr x âˆ™ sym (+-zero x) âˆ™ sym (cong (x +_) q)

disjoint-agree : (bs : List â„•) (u v : Exp bs)
               â†’ Disjoint bs u v â†’ (u âŠ” v) â‰¡ (u âŠ• v)
disjoint-agree []       _        _        _        = refl
disjoint-agree (b âˆ· bs) (x , xs) (y , ys) (d , ds) i =
  agreeâ„• x y d i , disjoint-agree bs xs ys ds i

------------------------------------------------------------------------
-- 3.  Nothing overlaps itself, so idempotence never occurs there
------------------------------------------------------------------------

selfâ„• : (x : â„•) â†’ (x â‰¡ 0) âŠŽ (x â‰¡ 0) â†’ x â‰¡ 0
selfâ„• x (inl p) = p
selfâ„• x (inr p) = p

self-disjoint-is-trivial :
  (bs : List â„•) (u : Exp bs) â†’ Disjoint bs u u â†’ u â‰¡ zeroE bs
self-disjoint-is-trivial []       _        _        = refl
self-disjoint-is-trivial (b âˆ· bs) (x , xs) (d , ds) i =
  selfâ„• x d i , self-disjoint-is-trivial bs xs ds i

------------------------------------------------------------------------
-- 4.  THE POINT.  A faithful multiplicative weight for the join exists â”
--     on the coprime locus.  So `NoNormOnAJoin`'s two-valuedness is a
--     statement about OVERLAP, not about the join.
------------------------------------------------------------------------

val-âŠ”-disjoint : (bs : List â„•) (u v : Exp bs) â†’ Disjoint bs u v
               â†’ val bs (u âŠ” v) â‰¡ val bs u Â· val bs v
val-âŠ”-disjoint bs u v d = cong (val bs) (disjoint-agree bs u v d) âˆ™ val-âŠ• bs u v

-- and it is faithful, not two-valued: a coprime pair of walk states whose
-- join has a value neither 0 nor 1.
--   (1,0,0,0) is 2, (0,1,0,0) is 3, disjoint, join is 6.
two : Exp primes4
two = 1 , 0 , 0 , 0 , tt

three : Exp primes4
three = 0 , 1 , 0 , 0 , tt

two-three-disjoint : Disjoint primes4 two three
two-three-disjoint = inr refl , inl refl , inl refl , inl refl , tt

join-is-six : val primes4 (_âŠ”_ {primes4} two three) â‰¡ 6
join-is-six = refl

weight-is-faithful : val primes4 (_âŠ”_ {primes4} two three) â‰¡ val primes4 two Â· val primes4 three
weight-is-faithful = val-âŠ”-disjoint primes4 two three two-three-disjoint

------------------------------------------------------------------------
-- 5.  Where this leaves the thread.
--
-- Idempotence forbids inverses, norms, and forgetting â” but only because
-- those were demanded at EVERY pair.  Restricted to coprime pairs the
-- join is the sum, carries `val` faithfully, and has none of the three
-- pathologies, because no state is coprime to itself.
--
-- A sieve stays on that locus.  The walk does not: it joins 1,2,3,4,â¦,
-- and 2, 4, 8 share the prime 2.  Its saving is what the join discards at
-- the overlaps, and lcm(1..k) versus k! is the quantity that measures it.
--
-- That quantity is not computed here.  Naming it is what this module does.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  The size of the saving.
--
-- Discarding makes the state SMALLER.  lcm(1..k) = e^Ïˆ(k) â‰ˆ
-- e^k while k! = e^{k log k}: the join's state is exponentially smaller
-- than the sum's, and overlap is exactly where that saving happens.
--
--     Overlap is not the walk's cost.  Overlap is the walk's SAVING.
--
-- `JoinSavesTheMeet` proves how much, exactly:
--
--     lcm-gcd :  val (u âŠ” v) Â val (u âŠ“ v) â‰¡ val u Â val v
--
-- â” the join's compression ratio against the sum is the meet, i.e. the
-- gcd, and in the tropical chart the whole identity is max + min = x + y.
------------------------------------------------------------------------
