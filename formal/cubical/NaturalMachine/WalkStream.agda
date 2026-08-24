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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- The walk's INSTALL-STREAM theorem, statement (3) of
-- notes/WALK_FORCING_LAW.md: "after installing q, lcm(S) = lcm(1..q)".
--
-- Setting.  The walk's state is a list S of installed sensors.  At a
-- collision the machine reads L = lcm(S) and installs the least q ≥ 2
-- with q ∤ L (NaturalMachine.WalkForcing.LeastNonDivisor).  The claim is
-- that the new state q ∷ S has lcm exactly lcm(1..q) -- the walk is at
-- the capacity of its own frontier, the fact that turns storage into
-- ψ(q).
--
-- Stated by universal property, as in NaturalMachine.WalkCapacity: no
-- lcm CONSTRUCTION appears anywhere.  We quantify over ANY L that is an
-- lcm of S and ANY M that is an lcm of q ∷ S, and conclude that M is an
-- lcm of range1 q = [q, q-1, …, 1].  The corollary installStream-≡ then
-- gives the note's equation literally: M ≡ C for any lcm C of the
-- frontier range.  Cubical v0.5 has no LCM module; the absence is again
-- an improvement, since the theorem needs no arithmetic at all -- only
-- membership, transitivity of ∣, and the two universal properties.
--
-- HYPOTHESES, and what is NOT weakened.  Two side conditions are carried
-- explicitly rather than derived:
--
--   * 2 ≤ q.  This is the walk's own search bound ("installs the least
--     q ≥ 2"), not an artifact: LeastNonDivisor L q alone does NOT imply
--     0 < q, because ¬ (0 ∣ L) holds for every L ≠ 0 while the minimality
--     clause is vacuous at q = 0.  The hypothesis is needed for q ∈
--     range1 q, and it is exactly what the walk supplies.
--   * every sensor already installed is in [1, q).  Along the walk the
--     installs are strictly increasing, so this holds at every state; it
--     is the same "frontier" hypothesis that WalkCapacity.capacity takes.
--     Without it the statement is FALSE, not merely unproved (put a
--     large prime in S and lcm(q ∷ S) exceeds lcm(1..q)).
--
-- So nothing is weakened relative to the note's statement (3): both
-- directions of the lcm characterisation are proved, and the closing
-- corollary is the note's equality.  What is not done here is the
-- induction ALONG the walk (that the installs are the prime powers in
-- order, statement (2)); this file proves the single install step, which
-- is that induction's step.
--
-- CHECKED: Agda 2.6.3, cubical v0.5, --cubical --safe, 2026-08-13.
-- No postulates, no holes.

module NaturalMachine.WalkStream where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.List
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.Unit

open import NaturalMachine.WalkCapacity
open import NaturalMachine.WalkForcing using (LeastNonDivisor)

-- 0 < q from the walk's search bound
2≤→0< : (q : ℕ) → 2 ≤ q → 0 < q
2≤→0< q 2≤q = ≤-trans ≤-sucℕ 2≤q

-- Everything in [1,k] divides N ⇒ N is a common multiple of the frontier
-- range.  (The one induction in the file, and it is on the range only.)
range1-common :
  (k N : ℕ) → ((r : ℕ) → 0 < r → r ≤ k → r ∣ N) →
  CommonMultiple (range1 k) N
range1-common zero    N h = tt
range1-common (suc k) N h =
  h (suc k) (suc-≤-suc zero-≤) ≤-refl
  , range1-common k N (λ r 0<r r≤k → h r 0<r (≤-suc r≤k))

-- THE INSTALL-STREAM THEOREM.  If L is an lcm of the installed sensors
-- S, all of them lying in [1,q), and q ≥ 2 is a least non-divisor of L,
-- then every lcm M of the new state q ∷ S is an lcm of the frontier
-- range [1..q].
installStream :
  (S : List ℕ) (L q M : ℕ) →
  2 ≤ q →
  IsLCM S L →
  LeastNonDivisor L q →
  All (λ x → (0 < x) × (x < q)) S →
  IsLCM (q ∷ S) M →
  IsLCM (range1 q) M
installStream S L q M 2≤q (_ , L-least) (_ , below) inRange (M-common , M-least) =
  range1-common q M covers , least
  where
  q∣M : q ∣ M
  q∣M = M-common .fst

  L∣M : L ∣ M
  L∣M = L-least M (M-common .snd)

  -- forward: every address in [1,q] divides M.  q does as a member of
  -- the new state; 1 does trivially; every r with 2 ≤ r < q divides L by
  -- minimality of q, and L divides M.
  covers : (r : ℕ) → 0 < r → r ≤ q → r ∣ M
  covers r 0<r r≤q with ≤-split r≤q
  ... | inr r≡q = subst (_∣ M) (sym r≡q) q∣M
  ... | inl r<q with ≤-split 0<r
  ...   | inr 1≡r = subst (_∣ M) 1≡r (∣-oneˡ M)
  ...   | inl 1<r = ∣-trans (below r 1<r r<q) L∣M

  -- backward: any common multiple of [1..q] is a common multiple of the
  -- new state, since q and every installed sensor lie in [1,q].
  least : (m : ℕ) → CommonMultiple (range1 q) m → M ∣ m
  least m m-common = M-least m (q∣m , mapS S inRange)
    where
    q∣m : q ∣ m
    q∣m = All→∈ (_∣ m) (range1 q) m-common
            (∈-range1 q q (2≤→0< q 2≤q) ≤-refl)

    mapS : (ys : List ℕ) → All (λ x → (0 < x) × (x < q)) ys → All (_∣ m) ys
    mapS []       _        = tt
    mapS (y ∷ ys) (p , ps) =
      All→∈ (_∣ m) (range1 q) m-common
        (∈-range1 y q (p .fst) (<-weaken (p .snd)))
      , mapS ys ps

-- The note's statement (3) verbatim: after installing q, the state's lcm
-- IS the lcm of 1..q.  (Two lcms of the same list agree, by antisymmetry
-- of divisibility -- so this is an equation between numbers, not merely
-- between predicates.)
installStream-≡ :
  (S : List ℕ) (L q M C : ℕ) →
  2 ≤ q →
  IsLCM S L →
  LeastNonDivisor L q →
  All (λ x → (0 < x) × (x < q)) S →
  IsLCM (q ∷ S) M →
  IsLCM (range1 q) C →
  M ≡ C
installStream-≡ S L q M C 2≤q lcmS lnd inRange lcmM (C-common , C-least) =
  antisym∣ (M-isLCM .snd C C-common) (C-least M (M-isLCM .fst))
  where
  M-isLCM : IsLCM (range1 q) M
  M-isLCM = installStream S L q M 2≤q lcmS lnd inRange lcmM
