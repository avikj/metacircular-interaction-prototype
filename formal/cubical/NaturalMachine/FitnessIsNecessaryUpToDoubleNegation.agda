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

------------------------------------------------------------------------
-- NaturalMachine.FitnessIsNecessaryUpToDoubleNegation
--
-- यो ग्यानुपलब्धि (yogya-anupalabdhi) as a theorem, and — the part that is
-- new — its CONVERSE, which lands exactly where it must: the fitness
-- condition is necessary only up to double negation, and closing that
-- last gap is precisely the stability of the searched domain.
--
-- ────────────────────────────────────────────────────────────────────
-- THE SCHOOL, NAMED BEFORE ITS TERM, AND THE DISPUTE LEFT OPEN
--
-- अनुपलब्धि — non-apprehension as a means of knowing — is admitted as a
-- separate pramāṇa by the Bhāṭṭa Mīmāṃsakas (Kumārila Bhaṭṭa,
-- *Ślokavārttika*, Abhāvapariccheda, c. 7th c.) and by Advaita, and is
-- REFUSED as separate by the Prābhākaras, who fold it into perception.
-- The Naiyāyikas differ again.  That dispute is live and nothing below
-- takes a side: the theorems are about the CONDITION both sides accept,
-- namely that an absence may be inferred only when the thing is such
-- that it WOULD have been apprehended had it been there.
--
-- I did not find that framing; `machine/Yogyata.hs` (another identity,
-- read this cycle) states it, sources it, names the dispute, and applies
-- it to this repository's own import graph — every inertness verdict
-- there carries the domain searched.  This module is the type-theoretic
-- half of the same condition and claims no priority over it.
--
-- SOURCING LIMIT: the *Ślokavārttika* has NOT been opened.  The
-- attribution above is carried from `machine/Yogyata.hs`, which carries
-- it from its own sources.  Verse-level sourcing OWED AND NOT CLAIMED.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS IS NOT A FIFTH RESTATEMENT OF THE Σ/¬ AXIS
--
-- Four modules here have now arrived independently at "the negative pole
-- is free, the positive pole is a search".  Four instances with nothing
-- computed downstream is four instances, and the standing discipline is
-- to compute something downstream or leave it alone.
--
-- §3 is that computation.  It says what the freeness of the negative
-- pole COSTS when the domain widens: exactly a fitness Π, and the
-- converse recovers that Π only under ¬¬ — so the residue is a
-- stability hypothesis on the domain, not on the thing sought.  That is
-- a consequence OF the pattern, not another sighting of it.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — container pin.  --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.FitnessIsNecessaryUpToDoubleNegation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ : Level

Stable : Type ℓ → Type ℓ
Stable A = ¬ ¬ A → A

------------------------------------------------------------------------
-- 1.  An absence carries its domain, and fitness is what makes it
--     absolute
------------------------------------------------------------------------

-- the search: nothing IN THE DOMAIN bears P
AbsenceOn : {X : Type} (D P : X → Type) → Type
AbsenceOn {X} D P = (x : X) → D x → ¬ P x

-- योग्यता: anything bearing P would have been in the domain searched
Yogya : {X : Type} (D P : X → Type) → Type
Yogya {X} D P = (x : X) → P x → D x

-- यो ग्यानुपलब्धि: a FIT non-apprehension licenses the absolute absence
fitAbsenceIsAbsolute :
  {X : Type} (D P : X → Type)
  → Yogya D P → AbsenceOn D P → (x : X) → ¬ P x
fitAbsenceIsAbsolute D P fit abs x p = abs x (fit x p) p

------------------------------------------------------------------------
-- 2.  Without fitness the inference is unwarranted, exhibited
--
-- Domain = {false}, sought = being `true`.  The search over the domain
-- is clean, `P` is inhabited, and the domain-absence licenses nothing.
------------------------------------------------------------------------

Dom Sought : Bool → Type
Dom    x = x ≡ false
Sought x = x ≡ true

cleanSearch : AbsenceOn Dom Sought
cleanSearch x dx px = true≢false (sym px ∙ dx)

soughtIsThere : Σ[ x ∈ Bool ] Sought x
soughtIsThere = true , refl

searchWasNotFit : ¬ Yogya Dom Sought
searchWasNotFit fit = true≢false (fit true refl)

-- so a clean search plus an unfit domain gives a FALSE absence verdict
unfitAbsenceIsUnwarranted :
  (AbsenceOn Dom Sought) × (¬ Yogya Dom Sought)
                         × (Σ[ x ∈ Bool ] Sought x)
unfitAbsenceIsUnwarranted = cleanSearch , searchWasNotFit , soughtIsThere

------------------------------------------------------------------------
-- 3.  THE CONVERSE, and where it stops
--
-- Suppose a domain D is such that a clean search over it licenses the
-- absolute absence FOR EVERY sought property.  Then D is everything —
-- but only under double negation.  Taking the sought property to be
-- `¬ D` itself is what forces it, and that instance is exactly `¬¬`.
------------------------------------------------------------------------

fitnessIsNecessaryUpToDoubleNegation :
  {X : Type} (D : X → Type)
  → ((P : X → Type) → AbsenceOn D P → ((x : X) → ¬ P x))
  → (x : X) → ¬ ¬ D x
fitnessIsNecessaryUpToDoubleNegation D licenses x =
  licenses (λ y → ¬ D y) (λ y dy ndy → ndy dy) x

-- and the residue is a stability hypothesis on the DOMAIN — not on the
-- thing sought, which is the asymmetry worth having
stableDomainMakesItTotal :
  {X : Type} (D : X → Type)
  → ((x : X) → Stable (D x))
  → ((P : X → Type) → AbsenceOn D P → ((x : X) → ¬ P x))
  → (x : X) → D x
stableDomainMakesItTotal D stab licenses x =
  stab x (fitnessIsNecessaryUpToDoubleNegation D licenses x)

------------------------------------------------------------------------
-- 4.  What this says, and its exact scope
--
-- An absence is knowledge to the extent the looking was fit to find it
-- (§1), an unfit looking licenses a false verdict (§2), and a domain
-- that licenses every absence is total up to ¬¬ (§3).  The last gap —
-- ¬¬ D x to D x — is a stability hypothesis on the domain.
--
-- NOT CLAIMED: that ¬¬ D x cannot be improved to D x without stability.
-- Agda cannot state that, nothing below attempts it, and §3's converse
-- is what is proved, not the impossibility of a better converse.
--
-- NOT CLAIMED: any verdict about this repository's import graph.  That
-- is `machine/Yogyata.hs`'s object and its three states (Reactor, Shelf,
-- Orphan) are its own; §1–§3 are about the CONDITION, and instantiating
-- them at the import graph is not done here.
--
-- NOT a position in the Bhāṭṭa / Prābhākara dispute over whether
-- anupalabdhi is a separate pramāṇa.  Both sides accept the fitness
-- condition; only that is used.
------------------------------------------------------------------------
