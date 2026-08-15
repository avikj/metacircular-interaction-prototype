{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.WalkFastInstance
--
-- THE EXCHANGE, MADE.  `WalkFast` proves the exchange rate
-- (`next-characterised`) and then says, in its own header, that no
-- instance of it type-checks: `next 8 ≡ 9` exhausts a 3.5 GB heap even
-- though every ingredient is cheap, "and I do not yet know what forces
-- it; the obvious suspect is the `with`-abstraction on `q ≟ next m`".
--
-- The suspect was right, and the fix is not a bigger heap.  `with q ≟
-- next m` demands the SCRUTINEE in weak head normal form, so the kernel
-- must run the walk step on cap m — the one object the exchange rate
-- exists to avoid.  Antisymmetry does not: from
--
--     ¬ (q < next m)   and   ¬ (next m < q)
--
-- the equality follows by a lemma whose own case split is on VARIABLES,
-- proved once, applied to `next m` as an opaque term.  Nothing in the
-- client is ever reduced.
--
-- So the walk's frontier was never m ≈ 8.  It was a `with`.
--
--   next-8  : next 8  ≡ 9     (the interval is empty)
--   next-9  : next 9  ≡ 11    (10 refuted by the decision procedure)
--   next-10 : next 10 ≡ 11    (the interval is empty)
--
-- Each instance costs one `decIsPrimePower` at the size of the answer,
-- never at the size of cap m = e^{ψ(m)}.
------------------------------------------------------------------------

module NaturalMachine.WFIScratch2 where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import NaturalMachine.CoprimeSplitting using (IsPrimePower)
open import NaturalMachine.WalkBridge using (next)
open import NaturalMachine.WalkFast
  using ( next-isPP ; next-> ; next-least
        ; decIsPrimePower ; acceptDec ; refuteDec ; IsYes ; IsNo ; noneIn )

------------------------------------------------------------------------
-- 1.  The case split, moved off the client's term.
------------------------------------------------------------------------

-- The only `with` in this file, and its scrutinee is a pair of
-- variables: it is reduced when THIS lemma is checked, never when it is
-- applied.
¬<→≤ : (m n : ℕ) → ¬ (n < m) → m ≤ n
¬<→≤ m n h with m ≟ n
... | lt p = <-weaken p
... | eq p = subst (m ≤_) p ≤-refl
... | gt p = Empty.rec (h p)

------------------------------------------------------------------------
-- 2.  The exchange rate, without the `with`.
------------------------------------------------------------------------

next-pinned :
  (m q : ℕ) → 1 ≤ m →
  IsPrimePower q → m < q →
  ((r : ℕ) → m < r → r < q → ¬ IsPrimePower r) →
  next m ≡ q
next-pinned m q 1≤m ippq m<q none =
  ≤-antisym (¬<→≤ (next m) q ¬q<n) (¬<→≤ q (next m) ¬n<q)
  where
    ¬q<n : ¬ (q < next m)
    ¬q<n q<n = next-least m 1≤m q m<q q<n ippq

    ¬n<q : ¬ (next m < q)
    ¬n<q n<q = none (next m) (next-> m 1≤m) n<q (next-isPP m)

------------------------------------------------------------------------
-- 3.  The instances.  Only the answer is ever evaluated.
------------------------------------------------------------------------

pp-9 : IsPrimePower 9
pp-9 = acceptDec (decIsPrimePower 9) tt
  where open import Cubical.Data.Unit using (tt)

