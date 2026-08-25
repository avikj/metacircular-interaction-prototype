{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- शेषरक्षा — keep the remainder.  The Kerala chapter's essence, stated
-- exactly where Madhava.agda fenced it: "शेष-पदम् एव सारः; तत् इह अनुक्तम्,
-- न मिथ्या-सिद्धम्" — the remainder term is the essence, there unstated.
-- Its ℤ-native form IS statable, and it is DIVISION WITH REMAINDER at
-- every finite stage, the remainder first-class:
--
--     pos 1  ≡  (pos 1 − r) · सङ्कलितम् r n  +  घात r n
--
-- one = divisor · quotient + remainder, for every n — the exact identity
-- the Yuktibhāṣā's iterated division (1/(1+x) = 1 − x·(1/(1+x)))
-- unrolls, with no limit taken and nothing false at any stage.  And the
-- remainder RECURSES: घात r (suc n) ≡ घात r n · r, definitionally — each
-- stage's remainder is the previous remainder carried once more.
--
-- SCOPE (the six-rule discipline).  The identity is a rearrangement of
-- Madhava.agda's गुणश्रेढी-योगः and is stated by this repository for the
-- Kerala chapter; it is not attributed to a source.  What IS the
-- tradition's: the iterated-division derivation of the series with its
-- exact remainder at every truncation (Jyeṣṭhadeva, Yuktibhāṣā c. 1530,
-- the caturthāhāra/saṃskāra passages; Nīlakaṇṭha, Tantrasaṅgraha 1501)
-- — cited as the reading that names the objects, with the scholarship
-- on the text itself still owed (BOOK.md ch. 10, the thin row).  The
-- RESONANCE with the kuṭṭaka's "keep the remainder, recurse on the
-- remainder" (Āryabhaṭīya, Gaṇitapāda 32–33 — the corpus's own motto
-- शेषं रक्ष) is a shared SHAPE, not a claimed historical identity, and
-- the two recursions differ exactly as ANEKANTA §3 warned: the kuṭṭaka's
-- remainders strictly decrease, the series remainder घात r n need not —
-- termination does not transfer, and is not claimed.
--
-- The convergence statement (remainder → 0 for |r| < 1) still needs
-- ℝ/ℚ and remains where Madhava.agda left it: unstated, not falsely
-- proven.  What this module adds is that the FINITE essence needs no
-- limit at all.
--
-- Composed through नाडी against the warm kernel.
------------------------------------------------------------------------

module SourcedProofs.SesaRaksa_TheSeriesIsDivisionWithRemainderAtEveryStageAndTheRemainderRecurses where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Int using (ℤ ; pos)
  renaming (_+_ to _+ℤ_ ; _·_ to _·ℤ_ ; _-_ to _-ℤ_)
open import Cubical.Data.Int.Properties using (minusPlus)

open import Madhava using (घात ; सङ्कलितम् ; गुणश्रेढी-योगः)

------------------------------------------------------------------------
-- विभाजनम् — one is divisor times quotient plus remainder, at EVERY
-- stage.  The remainder घात r n is first-class: kept, not discarded.
------------------------------------------------------------------------

विभाजनम् : (r : ℤ) (n : ℕ)
  → pos 1 ≡ ((pos 1 -ℤ r) ·ℤ सङ्कलितम् r n) +ℤ घात r n
विभाजनम् r n =
  sym (cong (_+ℤ घात r n) (गुणश्रेढी-योगः r n) ∙ minusPlus (घात r n) (pos 1))

------------------------------------------------------------------------
-- शेष-परम्परा — the remainder recurses: each stage's remainder is the
-- previous one carried once more.  Definitional, pinned by name so the
-- recursion is a stated fact and not an accident of the definition.
------------------------------------------------------------------------

शेष-परम्परा : (r : ℤ) (n : ℕ) → घात r (suc n) ≡ घात r n ·ℤ r
शेष-परम्परा r n = refl
