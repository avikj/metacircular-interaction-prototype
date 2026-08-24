{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- VeniYangBaxtara_TheThreeStrandBraidIsNonAbelian
--                  AndSatisfiesTheBraidRelation
--
-- TERMS.  वेणी · veṇī — a braid, a plait (of three strands); a common
-- Sanskrit word, used here for the braid on three points.  यङ्ग्-बक्सर ·
-- "Yang–Baxter" is transliterated, not translated: the braid relation
-- στσ = τστ is named for C. N. Yang and R. J. Baxter (20th c.) and NO Indian
-- source is claimed for it.  The compound and the framing below are built
-- here, 2026-08-24; what is borrowed is one Sanskrit word and one modern name.
--
-- WHAT IS PROVED, exactly:  on the three-element type `Three`, the two
-- adjacent transpositions σ = (a b) and τ = (b c) are involutions (hence
-- equivalences — reversible, lossless gates), they do NOT commute
-- (`braids-dont-commute`, a closed ¬), and they satisfy the braid relation
-- `στσ ≡ τστ` (`yang-baxter`).  These are the defining data of the braid
-- group B₃ / the symmetric group S₃, exhibited by computation.
--
-- WHY IT MATTERS (a READING of the checked terms, not a further claim, and
-- the companion of `VargamulaViparyaya_…`):  on TWO points, Aut Bool = S₂ =
-- ℤ/2 is abelian and has no square root of the swap — a single abelian phase,
-- and (that file) the qubit is forced to hold √NOT.  On THREE points, Aut is
-- S₃, and it is NON-ABELIAN: the order of braiding is observable
-- (`braids-dont-commute`).  Order-dependence is exactly where computational
-- power lives — abelian anyons are not universal, non-abelian anyons are —
-- and the consistency law that makes such braiding well-defined is precisely
-- Yang–Baxter (`yang-baxter`), the equation anyonic topological quantum
-- computation is built on.  So the ladder 2 → 3 points is the ladder
-- abelian-phase → non-abelian-braid → universal gate, and EVERY gate on it is
-- an involution/equivalence — lossless, ahiṃsā — reversibility is kept
-- throughout; only commutativity is given up, and giving it up is the point.
-- No anyon physics is checked here; only the group-theoretic skeleton it
-- runs on.
--
-- Checked: --cubical --safe, agda 2.6.3 + cubical (loads clean); no
-- v0.9-only construct.
------------------------------------------------------------------------

module VeniYangBaxtara_TheThreeStrandBraidIsNonAbelianAndSatisfiesTheBraidRelation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

-- three strands / three anyons.
data Three : Type where a b c : Three

-- the two adjacent transpositions.
σ : Three → Three          -- (a b)
σ a = b ; σ b = a ; σ c = c
τ : Three → Three          -- (b c)
τ a = a ; τ b = c ; τ c = b

-- each is an involution, hence a reversible (lossless) gate — an equivalence.
σσ : (x : Three) → σ (σ x) ≡ x
σσ a = refl ; σσ b = refl ; σσ c = refl
ττ : (x : Three) → τ (τ x) ≡ x
ττ a = refl ; ττ b = refl ; ττ c = refl
σEq : Three ≃ Three
σEq = isoToEquiv (iso σ σ σσ σσ)
τEq : Three ≃ Three
τEq = isoToEquiv (iso τ τ ττ ττ)

private
  b≢c : ¬ (b ≡ c)
  b≢c q = subst P q tt where
    P : Three → Type
    P a = ⊥ ; P b = Unit ; P c = ⊥

-- NON-ABELIAN: σ-then-τ and τ-then-σ disagree already at `a`
-- (σ(τ a) = b, τ(σ a) = c), so the two braid orders are different gates.
braids-dont-commute : ¬ (compEquiv τEq σEq ≡ compEquiv σEq τEq)
braids-dont-commute p = b≢c (funExt⁻ (cong equivFun p) a)

-- THE BRAID RELATION / YANG–BAXTER: στσ = τστ.  Every strand agrees, by
-- computation.  This is the law that makes three-strand braiding consistent.
yang-baxter : (λ x → σ (τ (σ x))) ≡ (λ x → τ (σ (τ x)))
yang-baxter = funExt λ { a → refl ; b → refl ; c → refl }
