{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- JoinSavesTheMeet
--
-- A correction to `OverlapIsTheCost`, which got the SIGN wrong, and the
-- exact identity that fixes it.
--
-- ────────────────────────────────────────────────────────────────────
-- THE ERROR
--
-- `OverlapIsTheCost` concludes: "Every overlap is a place where the join
-- discards what the sum would have kept, and the discarded amount is the
-- whole difference between k! and lcm(1..k)."  Both halves of that
-- sentence are right and the reading of it is backwards.  Discarding
-- makes the state SMALLER.  lcm(1..k) = e^ψ(k) ≈ e^k while
-- k! = e^{k log k}: the join's state is exponentially smaller than the
-- sum's, and overlap is exactly where that saving happens.
--
--     Overlap is not the walk's cost.  Overlap is the walk's SAVING.
--
-- The title of that module is wrong and this one says so rather than
-- quietly editing it.
--
-- ────────────────────────────────────────────────────────────────────
-- THE EXACT IDENTITY
--
-- How much does the join save?  Exactly the meet, and the proof is one
-- line of tropical arithmetic:
--
--     max x y  +  min x y  ≡  x + y
--
-- lifted to derivations and pushed through `val`:
--
--     lcm-gcd :  val (u ⊔ v) · val (u ⊓ v)  ≡  val u · val v
--
-- which is the classical lcm(a,b)·gcd(a,b) = a·b.  In the tropical chart
-- it is not a theorem about divisibility at all; it is max + min = x + y,
-- and every trace of number theory has evaporated.
--
-- So the join's compression ratio against the sum is the GCD, pointwise
-- and exactly.  Overlap is measured by the meet.  On the coprime locus
-- the meet is trivial (`disjoint→meet-trivial`) and the join saves
-- nothing — which is `OverlapIsTheCost.val-⊔-disjoint` recovered here as a
-- corollary of an identity rather than proved separately.
--
-- ────────────────────────────────────────────────────────────────────
-- AND WHAT THE WALK'S ACTUAL COST IS, STATED HONESTLY AS OPEN
--
-- If the join is a saving, the walk's e^ψ(k) is what SURVIVES maximal
-- compression by it, not what the compression costs.  Distinguishing k
-- inputs needs log k bits; the walk carries ψ(k) ≈ k of them.  That gap
-- is not overlap and this thread has not located it.  Naming the previous
-- module's answer as wrong leaves the question open, and open is where it
-- honestly sits.
--
-- SYĀT — THE CLAIM, EXACTLY.  ψ(k) ≈ k and log k! ≈ k log k are quoted from
-- outside this file and are not proved here; they are used only to fix
-- the SIGN of a comparison, which the identity below settles on its own
-- without them: `⊔≤⊕` shows the join's state always divides the sum's.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module JoinSavesTheMeet where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-zero ; +-suc)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.List using (List ; [] ; _∷_)

open import SumProductTorus
  using (Exp ; zeroE ; _⊕_ ; _⊔_ ; _⊔ℕ_ ; val ; val-⊕ ; val-zero ; primes4)
open import OverlapIsTheCost using (Disjoint)

------------------------------------------------------------------------
-- 1.  The meet
------------------------------------------------------------------------

_⊓ℕ_ : ℕ → ℕ → ℕ
zero  ⊓ℕ n     = zero
suc m ⊓ℕ zero  = zero
suc m ⊓ℕ suc n = suc (m ⊓ℕ n)

infixl 5 _⊓_

_⊓_ : {bs : List ℕ} → Exp bs → Exp bs → Exp bs
_⊓_ {[]}     _        _        = tt
_⊓_ {b ∷ bs} (x , xs) (y , ys) = (x ⊓ℕ y) , (xs ⊓ ys)

------------------------------------------------------------------------
-- 2.  max + min = x + y, and everything follows
------------------------------------------------------------------------

max+min : (x y : ℕ) → (x ⊔ℕ y) + (x ⊓ℕ y) ≡ x + y
max+min zero    y       = +-zero y
max+min (suc x) zero    = refl
max+min (suc x) (suc y) =
    +-suc (suc (x ⊔ℕ y)) (x ⊓ℕ y)
  ∙ cong suc (cong suc (max+min x y))
  ∙ sym (cong suc (+-suc x y))

-- the derivation-level identity: join ⊕ meet = the two of them summed
⊔-⊓-⊕ : (bs : List ℕ) (u v : Exp bs) → ((u ⊔ v) ⊕ (u ⊓ v)) ≡ (u ⊕ v)
⊔-⊓-⊕ []       _        _        = refl
⊔-⊓-⊕ (b ∷ bs) (x , xs) (y , ys) i =
  max+min x y i , ⊔-⊓-⊕ bs xs ys i

------------------------------------------------------------------------
-- 3.  lcm · gcd = product, as a consequence, with no divisibility used
------------------------------------------------------------------------

lcm-gcd : (bs : List ℕ) (u v : Exp bs)
        → val bs (u ⊔ v) · val bs (u ⊓ v) ≡ val bs u · val bs v
lcm-gcd bs u v =
    sym (val-⊕ bs (u ⊔ v) (u ⊓ v))
  ∙ cong (val bs) (⊔-⊓-⊕ bs u v)
  ∙ val-⊕ bs u v

-- and therefore the join's state always divides the sum's: the saving is
-- the meet, with an explicit witness rather than a truncated divisibility.
⊔≤⊕ : (bs : List ℕ) (u v : Exp bs)
    → Σ[ w ∈ Exp bs ] ((u ⊔ v) ⊕ w) ≡ (u ⊕ v)
⊔≤⊕ bs u v = (u ⊓ v) , ⊔-⊓-⊕ bs u v

------------------------------------------------------------------------
-- 4.  Coprime = the meet is trivial = the join saves nothing
------------------------------------------------------------------------

meetℕ-triv : (x y : ℕ) → (x ≡ 0) ⊎ (y ≡ 0) → x ⊓ℕ y ≡ 0
meetℕ-triv x y (inl p) = cong (_⊓ℕ y) p
meetℕ-triv zero    y (inr q) = refl
meetℕ-triv (suc x) y (inr q) = cong (suc x ⊓ℕ_) q

disjoint→meet-trivial :
  (bs : List ℕ) (u v : Exp bs) → Disjoint bs u v → (u ⊓ v) ≡ zeroE bs
disjoint→meet-trivial []       _        _        _        = refl
disjoint→meet-trivial (b ∷ bs) (x , xs) (y , ys) (d , ds) i =
  meetℕ-triv x y d i , disjoint→meet-trivial bs xs ys ds i

-- `OverlapIsTheCost.val-⊔-disjoint`, recovered as a corollary of the
-- identity instead of proved on its own.
val-⊔-coprime : (bs : List ℕ) (u v : Exp bs) → Disjoint bs u v
              → val bs (u ⊔ v) · 1 ≡ val bs u · val bs v
val-⊔-coprime bs u v d =
    cong (val bs (u ⊔ v) ·_)
         (sym (cong (val bs) (disjoint→meet-trivial bs u v d) ∙ val-zero bs))
  ∙ lcm-gcd bs u v

------------------------------------------------------------------------
-- 5.  It runs: the smallest overlap, and the saving it produces.
--
--   4 = (2,0,0,0)   8 = (3,0,0,0)   join 8, meet 4, product 32.
--   8 · 4 = 32 = 4 · 8.   The join saved a factor of 4, which is the gcd.
------------------------------------------------------------------------

four : Exp primes4
four = 2 , 0 , 0 , 0 , tt

eight : Exp primes4
eight = 3 , 0 , 0 , 0 , tt

join-is-eight : val primes4 (_⊔_ {primes4} four eight) ≡ 8
join-is-eight = refl

meet-is-four : val primes4 (_⊓_ {primes4} four eight) ≡ 4
meet-is-four = refl

saving-is-exact : val primes4 (_⊔_ {primes4} four eight)
                · val primes4 (_⊓_ {primes4} four eight)
                ≡ val primes4 four · val primes4 eight
saving-is-exact = lcm-gcd primes4 four eight

------------------------------------------------------------------------
-- 6.  The corrected sentence.
--
-- The join is a compression of the sum whose ratio is exactly the meet.
-- Overlap is where it compresses; coprimality is where it does not.  The
-- walk's residual e^ψ(k) is therefore what survives maximal compression,
-- and locating THAT is a question this thread has not answered and should
-- stop claiming to have.
------------------------------------------------------------------------
