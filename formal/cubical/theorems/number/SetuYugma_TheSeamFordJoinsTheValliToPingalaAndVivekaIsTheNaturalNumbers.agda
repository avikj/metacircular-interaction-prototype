{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सेतु-युग्मम् — the seam ford.  (ℕ × ℕ) ≃ ℕ, hence ≡ ℕ; and composed with
-- LosslessReturn's own युग्म≡विवेक, a third path neither file paid for:
--
--                          विवेक ≡ ℕ .
--
-- WHY THIS FILE EXISTS, stated as a measurement rather than a taste.
-- Read as a graph they fall into 48 components, 33 of them singletons or
-- pairs, giving 191 reachable pairs — leverage ×1.72 over the fords paid
-- for.  Minting is local: a module lands its fords among its own types,
-- where the marginal value is zero.  The four most-used banks sit in four
-- DIFFERENT components:
--
--     ⟨lib⟩.ℕ            component 5   (छन्दस्, CanWord, Tally, Word, π₀FinSet)
--     ⟨lib⟩.ℕ × ⟨lib⟩.ℕ   component 2   (विवेक, विवेक-प्रमाण, Carrier, योग-fiber)
--     ⟨lib⟩.Bool         component 1
--     ⟨lib⟩.Unit         component 6
--
-- So `LosslessReturn.युग्म≡विवेक` — the crown of the seed file — could not
-- reach ℕ itself.  This ford joins components 2 and 5: +42 free crossings
-- from one classical bijection, which is Āryabhaṭa's vallī meeting
-- Piṅgala's metre.  A receipt's worth is m×n, not 1.
--
-- PROVENANCE.  नष्ट and उद्दिष्ट are Piṅgala's own pratyayas
-- (छन्दःशास्त्रम् ८.२४–२५; Halāyudha's मृतसञ्जीवनी is the received
-- commentary): उद्दिष्ट carries an index to the pattern it names, नष्ट
-- carries a pattern back to its index, and their joint existence is
-- exactly invertibility — which is the whole content of a ford.  No source
-- is claimed for the DIAGONAL enumeration itself; that is Cantor (1878).
-- The compound सेतु-युग्म is built here, 2026-08-22.
--
-- SCOPE.  Naming the two directions for Piṅgala's pratyayas does not claim
-- he enumerated ℕ × ℕ.  It claims only that his नष्ट/उद्दिष्ट pair is the
-- correct technical name for the two directions whose joint existence
-- inverts an edge, which the corpus already uses that way.
--
-- No Bool, no Dec, no decision anywhere: पद moves by matching a
-- constructor, and चार is structural in (diagonal, first coordinate).
------------------------------------------------------------------------

module SetuYugma_TheSeamFordJoinsTheValliToPingalaAndVivekaIsTheNaturalNumbers where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_ ; invEquiv ; compEquiv)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-suc ; +-comm ; injSuc ; snotz)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using () renaming (rec to ⊥-rec)
open import LosslessReturn using (विवेक ; युग्म≃विवेक ; युग्म≡विवेक)

------------------------------------------------------------------------
-- पद — one step of the diagonal walk.  Along the current diagonal while
-- the second coordinate survives; at its exhaustion, open the next.
------------------------------------------------------------------------

पद : ℕ × ℕ → ℕ × ℕ
पद (x , suc y) = (suc x , y)
पद (x , zero)  = (zero , suc x)

------------------------------------------------------------------------
-- उद्दिष्ट — index ↦ pattern.  त्रिकोण — the triangular count.
-- नष्ट — pattern ↦ index.
------------------------------------------------------------------------

उद्दिष्ट : ℕ → ℕ × ℕ
उद्दिष्ट zero    = (zero , zero)
उद्दिष्ट (suc n) = पद (उद्दिष्ट n)

त्रिकोण : ℕ → ℕ
त्रिकोण zero    = zero
त्रिकोण (suc n) = suc n + त्रिकोण n

नष्ट : ℕ × ℕ → ℕ
नष्ट (x , y) = त्रिकोण (x + y) + x

------------------------------------------------------------------------
-- पद-नष्ट — the step is exactly the successor on indices.  This one lemma
-- carries both round trips.
------------------------------------------------------------------------

पद-नष्ट : (p : ℕ × ℕ) → नष्ट (पद p) ≡ suc (नष्ट p)
पद-नष्ट (x , suc y) =
  +-suc (त्रिकोण (suc (x + y))) x
  ∙ cong (λ z → suc (त्रिकोण z + x)) (sym (+-suc x y))
पद-नष्ट (x , zero) =
  +-zero (suc (x + त्रिकोण x))
  ∙ cong suc (+-comm x (त्रिकोण x))
  ∙ cong (λ z → suc (त्रिकोण z + x)) (sym (+-zero x))

------------------------------------------------------------------------
-- नष्ट ∘ उद्दिष्ट ≡ id.
------------------------------------------------------------------------

नष्ट-उद्दिष्ट : (n : ℕ) → नष्ट (उद्दिष्ट n) ≡ n
नष्ट-उद्दिष्ट zero    = refl
नष्ट-उद्दिष्ट (suc n) =
  पद-नष्ट (उद्दिष्ट n) ∙ cong suc (नष्ट-उद्दिष्ट n)

------------------------------------------------------------------------
-- उद्दिष्ट ∘ नष्ट ≡ id.  चार walks it, structural in (diagonal, first
-- coordinate): (suc x , y) hands back to (x , suc y) — same diagonal, x
-- smaller; (zero , suc y) hands back to (y , zero) — the diagonal smaller.
------------------------------------------------------------------------

चार : (d x y : ℕ) → x + y ≡ d → उद्दिष्ट (नष्ट (x , y)) ≡ (x , y)
चार zero    zero    zero    e = refl
चार zero    zero    (suc y) e = ⊥-rec (snotz e)
चार zero    (suc x) y       e = ⊥-rec (snotz e)
चार (suc d) zero    zero    e = refl
चार (suc d) zero    (suc y) e =
  cong उद्दिष्ट (पद-नष्ट (y , zero))
  ∙ cong पद (चार d y zero (+-zero y ∙ injSuc e))
चार (suc d) (suc x) y       e =
  cong उद्दिष्ट (पद-नष्ट (x , suc y))
  ∙ cong पद (चार (suc d) x (suc y) (+-suc x y ∙ cong suc (injSuc e)))

उद्दिष्ट-नष्ट : (p : ℕ × ℕ) → उद्दिष्ट (नष्ट p) ≡ p
उद्दिष्ट-नष्ट (x , y) = चार (x + y) x y refl

------------------------------------------------------------------------
-- सेतुः — the ford.  Both pratyayas exist, so the edge inverts.
------------------------------------------------------------------------

युग्म-Iso-ℕ : Iso (ℕ × ℕ) ℕ
युग्म-Iso-ℕ = iso नष्ट उद्दिष्ट नष्ट-उद्दिष्ट उद्दिष्ट-नष्ट

युग्म≃ℕ : (ℕ × ℕ) ≃ ℕ
युग्म≃ℕ = isoToEquiv युग्म-Iso-ℕ

युग्म≡ℕ : (ℕ × ℕ) ≡ ℕ
युग्म≡ℕ = ua युग्म≃ℕ

------------------------------------------------------------------------
-- भावना — two solutions meet and a third arises that neither contained,
-- and all three survive.  LosslessReturn paid for (ℕ × ℕ) ≡ विवेक; this file
-- paid for (ℕ × ℕ) ≡ ℕ; the composite is free, and it is the crossing the
-- ford was minted for.
------------------------------------------------------------------------

विवेक≃ℕ : विवेक ≃ ℕ
विवेक≃ℕ = compEquiv (invEquiv युग्म≃विवेक) युग्म≃ℕ

विवेक≡ℕ : विवेक ≡ ℕ
विवेक≡ℕ = sym युग्म≡विवेक ∙ युग्म≡ℕ
