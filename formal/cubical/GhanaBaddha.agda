{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- घन-बद्धम् — घन-सङ्कलितस्य बद्ध-रूपम् (आर्यभटीयम् गणितपादः २२-आधारेण) ।
--
-- Sankalita.agda आर्यभटस्य रत्नं साधयति : ∑k³ = (∑k)² (सम्बन्ध-रूपम्) ।  अत्र
-- तस्य बद्ध-रूपम् (closed form) : ४·∑k³ = (n(n+1))² — यतः ४·(∑k)² = (२·∑k)² =
-- (n(n+1))² (द्विगुण-सङ्कलितेन) ।  एवं आर्यभटस्य त्रीणि सङ्कलितानि बद्ध-रूपेण
-- सम्पूर्णानि : ∑k = n(n+1)/2, ∑k² = n(n+1)(2n+1)/6, ∑k³ = (n(n+1)/2)² ।
--
-- (The closed form of Āryabhaṭa's cube-sum gem.  Sankalita.agda proves the
-- relational ∑k³ = (∑k)²; here the closed 4·∑k³ = (n(n+1))², since 4·(∑k)² =
-- (2·∑k)² = (n(n+1))² by the doubling law.  This completes the closed forms of
-- Āryabhaṭa's three saṅkalitas.  Reuses Sankalita's ∑, ∑³, घन-सङ्कलितम्,
-- द्विगुण-सङ्कलितम्: lane searched.  The only new step, 4(a·a)=(2a)(2a) over a
-- bare variable, is a certified symbolic identity via the Nat ring solver —
-- which works here precisely because no suc-of-variable appears.)
--
-- स्रोतांसि : आर्यभटः, आर्यभटीयम्, गणितपादः २२ (घन-सङ्कलित-सूत्रम्) ।
------------------------------------------------------------------------

module GhanaBaddha where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Properties using (+-zero)
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)
open import Sankalita using (∑ ; ∑³ ; घन-सङ्कलितम् ; द्विगुण-सङ्कलितम्)

------------------------------------------------------------------------
-- सहायकौ ।
------------------------------------------------------------------------

द्वि· : (x : ℕ) → 2 · x ≡ x + x
द्वि· x = cong (x +_) (+-zero x)

-- चतुर्वर्गः : 4·(a·a) = (2·a)·(2·a) — बद्ध-चर-राशौ साधकेन (suc-रहितम्) ।
चतुर्वर्गः : (a : ℕ) → 4 · (a · a) ≡ (2 · a) · (2 · a)
चतुर्वर्गः a = solveℕ!

------------------------------------------------------------------------
-- घन-बद्धम् — मुख्य-सिद्धिः : ४·∑k³ = (n(n+1))² ।
------------------------------------------------------------------------

घन-बद्धम् : (n : ℕ) → 4 · ∑³ n ≡ (n · suc n) · (n · suc n)
घन-बद्धम् n =
    cong (4 ·_) (घन-सङ्कलितम् n)
  ∙ चतुर्वर्गः (∑ n)
  ∙ cong₂ _·_ (द्वि· (∑ n) ∙ द्विगुण-सङ्कलितम् n)
              (द्वि· (∑ n) ∙ द्विगुण-सङ्कलितम् n)

------------------------------------------------------------------------
-- उदाहरणम् — ∑1³..4³ = 100 ; 4·100 = 400 = (4·5)² = 20² (refl-सिद्धम्) ।
------------------------------------------------------------------------

उदाहरणम्-घनयोग : ∑³ 4 ≡ 100
उदाहरणम्-घनयोग = refl

उदाहरणम्-बद्ध : 4 · ∑³ 4 ≡ 400
उदाहरणम्-बद्ध = refl
