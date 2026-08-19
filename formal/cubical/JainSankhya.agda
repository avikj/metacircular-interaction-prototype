{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- JainSankhya — the Jain stratification of magnitude, as itself.
--
-- SOURCE.  The Jain theory of number and the infinite: magnitude
-- (rāśi / saṅkhyā) is of three irreducible kinds —
--   saṃkhyāta  (numerable),
--   asaṃkhyāta (innumerable),
--   ananta     (infinite) —
-- and each kind is graded jaghanya (minimum) / madhyama (intermediate) /
-- utkṛṣṭa (maximum).  The locus classicus is the Anuyogadvāra-sūtra; the
-- doctrine is systematized in Umāsvāti's Tattvārthasūtra and, with the
-- salākā ("counting-pit") operations that generate the jumps between
-- orders, in Yativṛṣabha's Tiloyapaṇṇattī and Vīrasena's Dhavalā.  The
-- decisive claim, and the one this file makes a checked term, is that
-- ANANTA IS NOT ONE: the infinite is itself stratified into strictly
-- ordered orders — the Jains distinguished sizes of the infinite as a
-- matter of doctrine, and worked with them.
--
-- WHAT IS FORMALIZED, AND WHAT IS NOT.  This file takes the Jain object
-- AS ITSELF — the qualitative ordered stratification — and proves the
-- structural facts that are textually solid.  It does NOT identify any
-- grade with any outside cardinal or ordinal (that would be the reverse
-- colonisation this repository's Indic lane forbids), and it does NOT
-- encode the exact salākā operations or the cosmological magnitudes
-- (jaghanya saṃkhyāta = 2; the pit-filling process for the big jumps),
-- which need the primary text verse by verse and are OWED, not claimed.
-- The rank into 0..8 below is an internal device for ORDER only; it is not
-- a claim that these magnitudes ARE the numbers 0..8.
--
-- Contents (no postulates, no holes, --safe):
--
--   Kind, Grade, Magnitude   three kinds, three grades, magnitude=(kind,grade)
--   _≺_ , ≺-trans, ≺-irrefl  the stratification order (lexicographic via
--                            rank), a strict order
--   num≺innum, innum≺inf,    the stratification: EVERY magnitude of a lower
--   num≺inf                  kind is strictly below EVERY magnitude of a
--                            higher kind, whatever the grades — numerable,
--                            then innumerable, then infinite, uniformly
--   infinite-is-not-one      three strictly-ordered infinities:
--                            (ananta,jaghanya) ≺ (ananta,madhyama) ≺
--                            (ananta,utkṛṣṭa).  The Jain crown, as a term.
--   least                    jaghanya saṃkhyāta is ≤ every magnitude
--                            (the floor of number)
------------------------------------------------------------------------

module JainSankhya where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Order
  using ( _<_ ; _≤_ ; <-trans ; <-asym ; ≤-refl
        ; ≤<-trans ; <≤-trans ; zero-≤ ; ≤-k+ ; ≤SumLeft
        ; _≟_ ; Trichotomy ; lt ; eq ; gt )
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- The three kinds and the three grades.
------------------------------------------------------------------------

data Kind : Type where
  saṃkhyāta asaṃkhyāta ananta : Kind        -- numerable < innumerable < infinite

data Grade : Type where
  jaghanya madhyama utkṛṣṭa : Grade          -- minimum < intermediate < maximum

Magnitude : Type
Magnitude = Kind × Grade

------------------------------------------------------------------------
-- Rank into 0..8 — an internal ORDER device only (see header): kind in
-- the high place, grade in the low, so kind dominates and grade breaks
-- ties.  rank = 3·kindRank + gradeRank.
------------------------------------------------------------------------

kindRank : Kind → ℕ
kindRank saṃkhyāta  = 0
kindRank asaṃkhyāta = 1
kindRank ananta     = 2

gradeRank : Grade → ℕ
gradeRank jaghanya = 0
gradeRank madhyama = 1
gradeRank utkṛṣṭa  = 2

rank : Magnitude → ℕ
rank (k , g) = 3 · kindRank k + gradeRank g

-- the stratification order
_≺_ : Magnitude → Magnitude → Type
m ≺ n = rank m < rank n

≺-trans : {a b c : Magnitude} → a ≺ b → b ≺ c → a ≺ c
≺-trans = <-trans

≺-irrefl : (a : Magnitude) → ¬ (a ≺ a)
≺-irrefl a p = <-asym p ≤-refl

------------------------------------------------------------------------
-- Every grade rank is at most 2.
------------------------------------------------------------------------

gradeRank≤2 : (g : Grade) → gradeRank g ≤ 2
gradeRank≤2 jaghanya = 2 , refl
gradeRank≤2 madhyama = 1 , refl
gradeRank≤2 utkṛṣṭa  = 0 , refl

------------------------------------------------------------------------
-- The kind dominates the grade: if a low base + any grade is separated
-- from a high base by more than a grade can span (base a + 2 < base b),
-- then a+grade₁ < b+grade₂ for ALL grades.  This is why the kind wins.
------------------------------------------------------------------------

private
  bump : (g1 g2 : Grade) (a b : ℕ)
       → (a + 2) < b
       → (a + gradeRank g1) < (b + gradeRank g2)
  bump g1 g2 a b h =
    <≤-trans (≤<-trans (≤-k+ (gradeRank≤2 g1)) h) ≤SumLeft

------------------------------------------------------------------------
-- The stratification theorem, in its three kind-steps.  Uniform over the
-- grades: the kind decides.
------------------------------------------------------------------------

num≺innum : (g1 g2 : Grade) → (saṃkhyāta , g1) ≺ (asaṃkhyāta , g2)
num≺innum g1 g2 = bump g1 g2 (3 · 0) (3 · 1) (0 , refl)   -- 2 < 3

innum≺inf : (g1 g2 : Grade) → (asaṃkhyāta , g1) ≺ (ananta , g2)
innum≺inf g1 g2 = bump g1 g2 (3 · 1) (3 · 2) (0 , refl)   -- 5 < 6

num≺inf : (g1 g2 : Grade) → (saṃkhyāta , g1) ≺ (ananta , g2)
num≺inf g1 g2 = bump g1 g2 (3 · 0) (3 · 2) (3 , refl)     -- 2 < 6

------------------------------------------------------------------------
-- The crown: the infinite is not one.  Three infinities, strictly ordered.
------------------------------------------------------------------------

infinite-is-not-one :
    ((ananta , jaghanya) ≺ (ananta , madhyama))
  × ((ananta , madhyama) ≺ (ananta , utkṛṣṭa))
  × ((ananta , jaghanya) ≺ (ananta , utkṛṣṭa))
infinite-is-not-one =
    (0 , refl)                       -- 6 < 7
  , (0 , refl)                       -- 7 < 8
  , ≺-trans {ananta , jaghanya} {ananta , madhyama} {ananta , utkṛṣṭa}
            (0 , refl) (0 , refl)    -- 6 < 8

------------------------------------------------------------------------
-- jaghanya saṃkhyāta is the floor: ≤ every magnitude (rank 0).
------------------------------------------------------------------------

least : (a : Magnitude) → rank (saṃkhyāta , jaghanya) ≤ rank a
least a = zero-≤

------------------------------------------------------------------------
-- The stratification is a DECIDABLE total order: any two magnitudes are
-- comparable — below, at the same rank, or above.  (The Jains ranked
-- magnitudes; comparison is total, not partial.)
------------------------------------------------------------------------

≺-tri : (m n : Magnitude) → (m ≺ n) ⊎ ((rank m ≡ rank n) ⊎ (n ≺ m))
≺-tri m n with rank m ≟ rank n
... | lt p = inl p
... | eq p = inr (inl p)
... | gt p = inr (inr p)
