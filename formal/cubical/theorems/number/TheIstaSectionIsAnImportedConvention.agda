{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module TheIstaSectionIsAnImportedConvention where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; _·_ ; _+_ ; -_)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
open import Kuttaka using (solutionFamily)

------------------------------------------------------------------------
-- TheIstaSectionIsAnImportedConvention
--
-- The one item `INDIC_FORMAL_TRADITIONS_MAP.md` §5.2 leaves open after its
-- 2026-08-18 DISCHARGED block, quoted from the note:
--
--     "Still NOT done, named there: only the iṣṭa least-non-negative
--      section (needs a mod/section convention)."
--
-- and from `formal/cubical/Kuttaka.agda`'s own header, line 47: the iṣṭa
-- section "needs a mod/section convention and is not supplied here."
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED, AND WHAT IS STILL NOT
--
-- §5.2(ii) asked for "the iṣṭa reduction as an explicitly IMPORTED
-- section".  §1 below takes that literally: a section is a PARAMETER —
-- any function on the solution index that lands in the family — and §2
-- proves that importing one costs nothing, since the reduced solution
-- still solves the equation.
--
-- That is the *convention* half, and it is the half
-- "the section is a declared convention".  Declared, not derived — so the
-- honest formalisation makes it a parameter and proves the equation is
-- indifferent to it.
--
-- STILL NOT DONE, and narrowed rather than closed: the LEAST-NON-NEGATIVE
-- property.  Nothing below says the section lands in `[0, b)`; that needs
-- an order and a division algorithm on `ℤ`, neither of which `Kuttaka`
-- carries.  So §5.2's remaining item is now two items, one discharged and
-- one open, and the open one is minimality, not the section.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED
--
-- That this is what Āryabhaṭa meant by iṣṭa.  The verse-level sourcing is
-- owed and unpaid: `KUTTAKA_SOLUTION_FAMILY.md` states plainly that "no
-- primary text was fetchable from this container; the verse-level sourcing
-- is owed, not claimed", and §5.1 of the map records that it could not
-- improve on that disclosure through its channel either.  This module
-- inherits that debt unchanged and adds nothing to it.
--
-- That the section is unique or canonical.  §1's type admits many
-- sections, and that multiplicity is the point: the equation does not pick
-- one.
--
-- PRIOR ART, grep run and quoted: `grep -rn "IstaSection\|ista\|iṣṭa"
-- formal/cubical/` returns only the two lines of `Kuttaka.agda`'s header
-- that name it as not done.  No section exists in the formal tree.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  A section, as an imported convention
--
-- `sec` moves a solution's x-component somewhere in the family: for each
-- `x` there is a shift `t` with `sec x ≡ x + t · b`.  Nothing else is
-- required, and in particular no minimality.
------------------------------------------------------------------------

private
  shiftByZero : (x b : ℤ) → x ≡ x + pos 0 · b
  shiftByZero x b = solve! ℤCommRing

IstaSection : ℤ → Type
IstaSection b =
  Σ[ sec ∈ (ℤ → ℤ) ] ((x : ℤ) → Σ[ t ∈ ℤ ] (sec x ≡ x + t · b))

-- the trivial section: take the solution you were given.  Present so the
-- type is visibly inhabited and §2 is not vacuous.
identitySection : (b : ℤ) → IstaSection b
identitySection b = (λ x → x) , (λ x → pos 0 , shiftByZero x b)

------------------------------------------------------------------------
-- 2.  Importing a section costs nothing: the reduced solution still solves
------------------------------------------------------------------------

sectionPreservesSolving :
  (a b g x₀ y₀ : ℤ) → a · x₀ + b · y₀ ≡ g
  → (S : IstaSection b)
  → Σ[ y ∈ ℤ ] (a · (fst S x₀) + b · y ≡ g)
sectionPreservesSolving a b g x₀ y₀ sol (sec , wit) =
  (y₀ + (- (t · a)))
  , cong (λ z → a · z + b · (y₀ + (- (t · a)))) p
    ∙ solutionFamily a b g x₀ y₀ sol t
  where
  t : ℤ
  t = fst (wit x₀)
  p : sec x₀ ≡ x₀ + t · b
  p = snd (wit x₀)
