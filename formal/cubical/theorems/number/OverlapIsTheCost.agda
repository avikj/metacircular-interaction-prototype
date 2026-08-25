{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- OverlapIsTheCost
--
-- `SignIsNotAccumulable` left a conditional with two open antecedents and
-- said promoting it would be the fitted-constant error one level up.  The
-- second antecedent is false, and this module kills it — then keeps what
-- the death exposes, which is better than the rhyme was.
--
-- ────────────────────────────────────────────────────────────────────
-- THE REFUTATION
--
-- Sieve weights are multiplicative across COPRIME arguments.  In the
-- derivation chart coprime means DISJOINT SUPPORT, and on disjoint
-- supports the two operations of this whole thread coincide:
--
--     disjoint-agree :  Disjoint u v  →  u ⊔ v ≡ u ⊕ v
--
-- The join and the sum are the same operation there.  And nothing is
-- disjoint from itself except the trivial state:
--
--     self-disjoint-is-trivial :  Disjoint u u  →  u ≡ 0
--
-- So on the coprime locus idempotence has no purchase at all — you cannot
-- form `u ⋆ u` and stay inside it — and `SignIsNotAccumulable`'s
-- hypothesis is unsatisfiable except at the unit.  The theorem is true
-- and simply does not reach μ or λ.  The rhyme is dead.  It was recorded
-- as a rhyme, and this is what recording it that way is for.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THE DEATH EXPOSES
--
-- `NoNormOnAJoin` proved a multiplicative norm for a join is two-valued.
-- But `val` IS multiplicative for the join on disjoint arguments:
--
--     val-⊔-disjoint :  Disjoint u v  →  val (u ⊔ v) ≡ val u · val v
--
-- — an unrestricted, faithful, wildly-many-valued multiplicative weight
-- for the join, defined exactly on the coprime pairs.  So the earlier
-- theorem's strength comes entirely from quantifying over ALL pairs.  The
-- obstruction is not the join.  **The obstruction is overlap.**
--
-- And that relocates the walk's cost precisely.  A sieve only ever
-- combines coprime data, so it lives on the locus where join = sum and a
-- faithful weight exists.  The walk combines 1,2,3,4,…, and 2, 4, 8 all
-- touch the prime 2: its data overlap constantly.  Every overlap is a
-- place where the join discards what the sum would have kept, and the
-- discarded amount is the whole difference between k! and lcm(1..k).
--
--     the walk's cost is its overlap, and overlap is exactly the locus
--     where the two operations disagree.
--
-- WHAT IS NOT CLAIMED.  No rate.  The sentence above is a location, not a
-- bound: nothing here computes how much the join discards, and the
-- comparison of k! with lcm(1..k) is named as the quantity to compute,
-- not computed.  Nor is anything claimed about real sieves beyond the
-- observation that their weights are coprime-multiplicative, which is a
-- statement about sieve identities and not about this Agda.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module OverlapIsTheCost where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-zero)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.List using (List ; [] ; _∷_)

open import SumProductTorus
  using (Exp ; zeroE ; _⊕_ ; _⊔_ ; _⊔ℕ_ ; val ; val-⊕ ; primes4)
open import SourcedProofs.IdempotenceForbidsDescent using (⊔ℕ-idr)

------------------------------------------------------------------------
-- 1.  Disjoint support = coprime
------------------------------------------------------------------------

Disjoint : (bs : List ℕ) → Exp bs → Exp bs → Type
Disjoint []       _        _        = Unit
Disjoint (b ∷ bs) (x , xs) (y , ys) = ((x ≡ 0) ⊎ (y ≡ 0)) × Disjoint bs xs ys

------------------------------------------------------------------------
-- 2.  On the coprime locus the join IS the sum
------------------------------------------------------------------------

agreeℕ : (x y : ℕ) → (x ≡ 0) ⊎ (y ≡ 0) → x ⊔ℕ y ≡ x + y
agreeℕ x y (inl p) = cong (_⊔ℕ y) p ∙ sym (cong (_+ y) p)
agreeℕ x y (inr q) =
  cong (x ⊔ℕ_) q ∙ ⊔ℕ-idr x ∙ sym (+-zero x) ∙ sym (cong (x +_) q)

disjoint-agree : (bs : List ℕ) (u v : Exp bs)
               → Disjoint bs u v → (u ⊔ v) ≡ (u ⊕ v)
disjoint-agree []       _        _        _        = refl
disjoint-agree (b ∷ bs) (x , xs) (y , ys) (d , ds) i =
  agreeℕ x y d i , disjoint-agree bs xs ys ds i

------------------------------------------------------------------------
-- 3.  Nothing overlaps itself, so idempotence never occurs there
------------------------------------------------------------------------

selfℕ : (x : ℕ) → (x ≡ 0) ⊎ (x ≡ 0) → x ≡ 0
selfℕ x (inl p) = p
selfℕ x (inr p) = p

self-disjoint-is-trivial :
  (bs : List ℕ) (u : Exp bs) → Disjoint bs u u → u ≡ zeroE bs
self-disjoint-is-trivial []       _        _        = refl
self-disjoint-is-trivial (b ∷ bs) (x , xs) (d , ds) i =
  selfℕ x d i , self-disjoint-is-trivial bs xs ds i

------------------------------------------------------------------------
-- 4.  THE POINT.  A faithful multiplicative weight for the join exists —
--     on the coprime locus.  So `NoNormOnAJoin`'s two-valuedness is a
--     statement about OVERLAP, not about the join.
------------------------------------------------------------------------

val-⊔-disjoint : (bs : List ℕ) (u v : Exp bs) → Disjoint bs u v
               → val bs (u ⊔ v) ≡ val bs u · val bs v
val-⊔-disjoint bs u v d = cong (val bs) (disjoint-agree bs u v d) ∙ val-⊕ bs u v

-- and it is faithful, not two-valued: a coprime pair of walk states whose
-- join has a value neither 0 nor 1.
--   (1,0,0,0) is 2, (0,1,0,0) is 3, disjoint, join is 6.
two : Exp primes4
two = 1 , 0 , 0 , 0 , tt

three : Exp primes4
three = 0 , 1 , 0 , 0 , tt

two-three-disjoint : Disjoint primes4 two three
two-three-disjoint = inr refl , inl refl , inl refl , inl refl , tt

join-is-six : val primes4 (_⊔_ {primes4} two three) ≡ 6
join-is-six = refl

weight-is-faithful : val primes4 (_⊔_ {primes4} two three) ≡ val primes4 two · val primes4 three
weight-is-faithful = val-⊔-disjoint primes4 two three two-three-disjoint

------------------------------------------------------------------------
-- 5.  Where this leaves the thread.
--
-- Idempotence forbids inverses, norms, and forgetting — but only because
-- those were demanded at EVERY pair.  Restricted to coprime pairs the
-- join is the sum, carries `val` faithfully, and has none of the three
-- pathologies, because no state is coprime to itself.
--
-- A sieve stays on that locus.  The walk does not: it joins 1,2,3,4,…,
-- and 2, 4, 8 share the prime 2.  Its cost is what the join discards at
-- the overlaps, and lcm(1..k) versus k! is the quantity that measures it.
--
-- That quantity is not computed here.  Naming it is what this module does.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  CORRECTION, same session — this module's TITLE is wrong.
--
-- §5 above says "the walk's cost is what the join discards at the
-- overlaps".  Discarding makes the state SMALLER.  lcm(1..k) = e^ψ(k) ≈
-- e^k while k! = e^{k log k}: the join's state is exponentially smaller
-- than the sum's, and overlap is exactly where that saving happens.
--
--     Overlap is not the walk's cost.  Overlap is the walk's SAVING.
--
-- `JoinSavesTheMeet` proves how much, exactly:
--
--     lcm-gcd :  val (u ⊔ v) · val (u ⊓ v) ≡ val u · val v
--
-- — the join's compression ratio against the sum is the meet, i.e. the
-- gcd, and in the tropical chart the whole identity is max + min = x + y.
--
-- Everything PROVED in §§1–4 stands: `disjoint-agree`,
-- `self-disjoint-is-trivial`, and `val-⊔-disjoint` are unaffected, and the
-- refutation of the parity rhyme is unaffected.  What is withdrawn is the
-- sign of §5's reading, and with it the module's name.
------------------------------------------------------------------------
