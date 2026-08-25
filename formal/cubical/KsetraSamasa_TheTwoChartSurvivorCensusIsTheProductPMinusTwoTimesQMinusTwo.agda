{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- क्षेत्र-समासः — the survivor census composes across charts: over two
-- charts with distinct walls the joint survivor set is Fin (m · m'),
-- i.e. (p−2)·(q−2).  The singular series' LOCAL PRODUCT, as a checked
-- equivalence — closing the two-chart case of the atlas दोषलेख that
-- द्वि-लोप and स्फटिक left open.
--
-- कुट्टक-कोण Lemma 3 (prose): the joint congruence system has exactly
-- ∏ (p − ω_p) solutions per period.  Here, for two charts at distinct-wall
-- (ω_p = 2) primes, that product is a TERM:
--
--     शिष्टम् a₁ b₁ × शिष्टम् a₂ b₂  ≃  Fin (m ·ℕ m')
--
-- built as द्वि-लोप on each chart (survivors of one chart ≃ Fin (p−2)),
-- combined by ≃-×, then Fin m × Fin m' ≃ Fin (m · m') by the library's
-- factorEquiv.  Three lines; the content is that each factor is exactly
-- the elided-two-residue count and the counts multiply.
--
-- THE MODELLING CHOICE, stated so it is not smuggled.  The joint survivor
-- set is taken to be the PRODUCT of the local survivor sets.  That is the
-- sieve's own model: the two-wall condition at a prime is independent of
-- the condition at a coprime prime, so a joint survivor is a tuple of
-- local survivors.  The identification of this product with the survivors
-- inside Fin (p·q) is the Chinese Remainder ring-iso (ℤ/pq ≃ ℤ/p × ℤ/q,
-- coprime), which is NOT proved here — this module works on the product
-- carrier directly, where the count is exact and needs no CRT.  So the
-- result is the DENSITY product, honestly on the product carrier; the
-- CRT identification with the residue line mod p·q is the remaining,
-- named, half of the atlas.
--
-- No claim about primes as such: p = 2+m is any modulus ≥ 2 with two
-- distinct walls; primality and coprimality enter only when this product
-- is read as the singular series, which कुट्टक-कोण does.  क्षेत्र-समासः is
-- built here, 2026-08-23.
------------------------------------------------------------------------

module KsetraSamasa_TheTwoChartSurvivorCensusIsTheProductPMinusTwoTimesQMinusTwo where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; compEquiv)
open import Cubical.Data.Nat using (ℕ ; suc) renaming (_·_ to _·ℕ_)
open import Cubical.Data.Fin using (Fin ; factorEquiv)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; ≃-×)
open import Cubical.Relation.Nullary using (¬_)

open import Texts.DviLopa_TheTwoWallsElideTwoResiduesAndTheSurvivorsAreExactlyCounted
  using (द्वि-लोपः)

private
  variable
    m m' : ℕ

------------------------------------------------------------------------
-- the survivor set of one chart: the y in Fin (p) surviving both walls,
-- exactly द्वि-लोप's domain (p = suc (suc m)).
------------------------------------------------------------------------

शिष्टम् : (a b : Fin (suc (suc m))) → Type
शिष्टम् {m = m} a b = Σ[ y ∈ Fin (suc (suc m)) ] ((¬ a ≡ y) × (¬ b ≡ y))

------------------------------------------------------------------------
-- क्षेत्र-समासः — the two-chart joint census is Fin (m · m') = (p−2)(q−2).
------------------------------------------------------------------------

क्षेत्र-समासः :
    (a₁ b₁ : Fin (suc (suc m)))  → (¬ a₁ ≡ b₁)
  → (a₂ b₂ : Fin (suc (suc m'))) → (¬ a₂ ≡ b₂)
  → (शिष्टम् a₁ b₁ × शिष्टम् a₂ b₂) ≃ Fin (m ·ℕ m')
क्षेत्र-समासः a₁ b₁ ne₁ a₂ b₂ ne₂ =
  compEquiv (≃-× (द्वि-लोपः a₁ b₁ ne₁) (द्वि-लोपः a₂ b₂ ne₂)) factorEquiv

------------------------------------------------------------------------
-- दोषलेखः.  Two charts, both at distinct-wall count p−2; the merged-wall
-- case (p ∣ 2a, count p−1) and the arbitrary-length atlas (∏ over a list
-- of charts, by iterating this composition) are the next steps, and the
-- CRT identification of the product carrier with the residue line mod p·q
-- is the named other half.  What is proved: the elided-two-residue counts
-- MULTIPLY across charts, exactly, as an equivalence — the local product
-- of the singular series is now a term.
------------------------------------------------------------------------
