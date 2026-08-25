{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTrajectoryIsAChain
--
-- `JoinSavesTheMeet` withdrew the answer to "where does the walk's e^ψ(k)
-- come from?" and put the question back to open.  This module does not
-- answer it either, but it removes a whole class of answers by proving
-- something about the walk that had not been said:
--
--     along its own trajectory, the walk's join is never a join.
--
-- It is always an absorption — one of the two arguments, returned.  The
-- machine's state law is a lattice operation, and the machine never once
-- uses the lattice.  It moves up a CHAIN.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THAT MATTERS FOR THE COST QUESTION
--
-- Six modules have now derived consequences from the join's idempotence:
-- no inverses, no norm, no forgetting, no sign.  All of them are true of
-- the join.  This one says the walk's trajectory never leaves a chain,
-- and on a chain the join has no content at all — `chain-join-absorbs`
-- says every join along the trajectory returns an argument unchanged.
--
-- So the walk pays for a lattice of dimension π(k) with coordinates up to
-- log k, in order to move along a totally ordered path of length k.
--
-- That sentence is a READING and is not proved here.  What is proved is
-- the absorption, generally (from step-monotonicity alone) and concretely
-- (the first eight states of the actual walk, by `refl`).  Quantifying
-- the waste — the ψ(k) versus log k gap — remains exactly as open as
-- `JoinSavesTheMeet` left it, and this module does not narrow it.
--
-- WHAT IS NOT CLAIMED.  That a chain-representing machine would be
-- smaller; that the walk could be re-encoded by its index without losing
-- what it is for (it is a machine over inputs, not over its own step
-- count); or any rate.  Only that the join does no work on the path the
-- walk actually takes.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module TheTrajectoryIsAChain where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Order using (_≤_ ; splitℕ-≤ ; <-weaken)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (tt)
open import Cubical.Data.List using (List ; [] ; _∷_)

open import SumProductTorus
  using (Exp ; zeroE ; _⊔_ ; val ; primes4 ; ⊔-comm)
open import IdempotenceForbidsDescent using (⊔-idem ; ⊔-assoc)

------------------------------------------------------------------------
-- 1.  The lattice order, and its transitivity
------------------------------------------------------------------------

Below : {bs : List ℕ} → Exp bs → Exp bs → Type
Below u v = (u ⊔ v) ≡ v

below-trans : (bs : List ℕ) (u v w : Exp bs)
            → Below u v → Below v w → Below u w
below-trans bs u v w p q =
    cong (u ⊔_) (sym q)
  ∙ sym (⊔-assoc bs u v w)
  ∙ cong (_⊔ w) p
  ∙ q

------------------------------------------------------------------------
-- 2.  A step-monotone trajectory is a chain
------------------------------------------------------------------------

module _ (bs : List ℕ) (t : ℕ → Exp bs)
         (step : (k : ℕ) → Below (t k) (t (suc k)))
         where

  below-add : (d m : ℕ) → Below (t m) (t (d + m))
  below-add zero    m = ⊔-idem bs (t m)
  below-add (suc d) m =
    below-trans bs (t m) (t (d + m)) (t (suc (d + m)))
      (below-add d m) (step (d + m))

  below-≤ : (m n : ℕ) → m ≤ n → Below (t m) (t n)
  below-≤ m n (d , p) = subst (λ z → Below (t m) (t z)) p (below-add d m)

  -- THE STATEMENT.  Any two states on the trajectory are comparable, so
  -- their join is one of them.  The join never constructs anything.
  chain-join-absorbs :
    (m n : ℕ) → ((t m ⊔ t n) ≡ t n) ⊎ ((t m ⊔ t n) ≡ t m)
  chain-join-absorbs m n with splitℕ-≤ m n
  ... | inl m≤n = inl (below-≤ m n m≤n)
  ... | inr n<m = inr (⊔-comm bs (t m) (t n) ∙ below-≤ n m (<-weaken n<m))

------------------------------------------------------------------------
-- 3.  The actual walk, concretely: its first eight states, and the fact
--     that each absorbs the last.  Finite exhaustive verification.
--
--     cap 1..8  =  1, 2, 6, 12, 60, 60, 420, 840
------------------------------------------------------------------------

capE : ℕ → Exp primes4
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
    (val primes4 (capE 1) ≡ 1)
  × (val primes4 (capE 2) ≡ 2)
  × (val primes4 (capE 3) ≡ 6)
  × (val primes4 (capE 4) ≡ 12)
  × (val primes4 (capE 5) ≡ 60)
  × (val primes4 (capE 6) ≡ 60)
  × (val primes4 (capE 7) ≡ 420)
  × (val primes4 (capE 8) ≡ 840)
cap-values = refl , refl , refl , refl , refl , refl , refl , refl

-- and every step absorbs: the join is doing nothing
cap-absorbs :
    (_⊔_ {primes4} (capE 1) (capE 2) ≡ capE 2)
  × (_⊔_ {primes4} (capE 2) (capE 3) ≡ capE 3)
  × (_⊔_ {primes4} (capE 3) (capE 4) ≡ capE 4)
  × (_⊔_ {primes4} (capE 4) (capE 5) ≡ capE 5)
  × (_⊔_ {primes4} (capE 5) (capE 6) ≡ capE 6)
  × (_⊔_ {primes4} (capE 6) (capE 7) ≡ capE 7)
  × (_⊔_ {primes4} (capE 7) (capE 8) ≡ capE 8)
cap-absorbs = refl , refl , refl , refl , refl , refl , refl

-- non-trivial joins DO exist in this lattice — the walk simply never
-- reaches them.  4 and 3 are incomparable and their join is neither.
fourE : Exp primes4
fourE = 2 , 0 , 0 , 0 , tt

threeE : Exp primes4
threeE = 0 , 1 , 0 , 0 , tt

lattice-is-not-a-chain-here :
    (val primes4 (_⊔_ {primes4} fourE threeE) ≡ 12)
  × (val primes4 fourE ≡ 4)
  × (val primes4 threeE ≡ 3)
lattice-is-not-a-chain-here = refl , refl , refl

------------------------------------------------------------------------
-- 4.  What is now removed from the space of answers.
--
-- The walk's cost cannot be explained by anything the join does at
-- incomparable states, because the walk never visits an incomparable
-- pair.  Every idempotence consequence in this thread — no inverses, no
-- norm, no forgetting, no sign — holds along a path on which the join is
-- pure absorption.  Whatever ψ(k) is paying for, it is not the width of
-- the lattice.
--
-- The question stands where `JoinSavesTheMeet` left it, one class of
-- answers narrower.
------------------------------------------------------------------------
