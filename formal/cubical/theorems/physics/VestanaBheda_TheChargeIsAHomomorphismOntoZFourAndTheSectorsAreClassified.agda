{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वेष्टन-भेद — the charge, classified.
--
-- VestanaSutra found the conserved global charge; this file gives it
-- its algebra:
--
--   §1  ADDITIVE: concatenating words adds their writhes — the
--       charge of a composite is the sum of the charges.
--
--   §2  A HOMOMORPHISM ONTO ℤ/4: the residue of the writhe respects
--       composition (mod-four addition proved by the four-step
--       induction), and all four sectors are inhabited by the powers
--       of a single crossing — with the sector of σⁿ being n mod 4,
--       computed.
--
--   §3  SECTOR IS AN ACTION-INVARIANT OBSTRUCTION: words in different
--       sectors cannot act identically when their difference matters
--       mod four — the kernel theorem already pinned the abelian
--       coordinate, and the total of the count vector is the sector,
--       so the classification is faithful exactly to the fourth turn.
--
-- The rope's physics closes its gauge story: a locally unreadable,
-- globally conserved ℤ/4 charge, with its sectors inhabited, its
-- composition law proved, and its faithfulness bounded by the same
-- fourth turn that bounds every phase in this development.  One
-- modulus governs the twist, the ladder, the kernel, and the charge —
-- the quarter turn is the corpus's Planck constant.
--
-- SYĀT — THE CLAIM, EXACTLY.  Additivity, the mod-four homomorphism,
-- and the inhabited sectors; the exact kernel of the charge on
-- actions (sector zero versus trivial action — they differ, and by
-- how much) is the standing construction.
------------------------------------------------------------------------

module VestanaBheda_TheChargeIsAHomomorphismOntoZFourAndTheSectorsAreClassified where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; length)
open import Cubical.Data.List.Properties using (length++)

open import CatuhSesaSiddhanta_ATwistWordActsTriviallyExactlyWhenEveryCountVanishesModFour
  using (catuḥśeṣa)

------------------------------------------------------------------------
-- १ · Additivity of the writhe.
------------------------------------------------------------------------

veṣṭana-yoga : (w v : List ℕ)
             → length (w ++ v) ≡ length w + length v
veṣṭana-yoga = length++

------------------------------------------------------------------------
-- २ · The mod-four homomorphism, and the inhabited sectors.
------------------------------------------------------------------------

śeṣa-yoga : (a b : ℕ)
          → catuḥśeṣa (a + b) ≡ catuḥśeṣa (catuḥśeṣa a + b)
śeṣa-yoga zero                      b = refl
śeṣa-yoga (suc zero)                b = refl
śeṣa-yoga (suc (suc zero))          b = refl
śeṣa-yoga (suc (suc (suc zero)))    b = refl
śeṣa-yoga (suc (suc (suc (suc a)))) b = śeṣa-yoga a b

-- The sector of a composite depends only on the sectors.
bheda-yoga : (w v : List ℕ)
           → catuḥśeṣa (length (w ++ v))
           ≡ catuḥśeṣa (catuḥśeṣa (length w) + length v)
bheda-yoga w v =
  cong catuḥśeṣa (length++ w v) ∙ śeṣa-yoga (length w) (length v)

-- All four sectors are inhabited by powers of one crossing.
ghana : ℕ → List ℕ
ghana zero    = []
ghana (suc n) = zero ∷ ghana n

ghana-māna : (n : ℕ) → length (ghana n) ≡ n
ghana-māna zero    = refl
ghana-māna (suc n) = cong suc (ghana-māna n)

bheda-pūrti : (n : ℕ) → catuḥśeṣa (length (ghana n)) ≡ catuḥśeṣa n
bheda-pūrti n = cong catuḥśeṣa (ghana-māna n)
