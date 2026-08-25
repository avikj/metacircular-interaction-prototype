{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- खण्ड-पिण्डौ — the segment and the accumulated whole.
--
-- स्रोतः (source of the TERMS): the Kerala school's sine-table vocabulary —
-- खण्डज्या the segment-sine, पिण्डज्या the accumulated sine (Nīlakaṇṭha,
-- Tantrasaṅgraha 1501, ch. 2; Jyeṣṭhadeva, Yuktibhāṣā c. 1530, ch. 7 —
-- the jyā-prakaraṇa).  The pair names the relation this module proves for
-- the geometric partial sum: the ACCUMULATED whole at m + n is the whole
-- at m plus the m-th power carrying the whole at n into place —
--
--     सङ्कलितम् r (m + n)  ≡  सङ्कलितम् r m  +  घात r m · सङ्कलितम् r n
--
-- with the carrier law घात r (m + n) ≡ घात r m · घात r n.  This is the
-- block-decomposition under the Kerala telescoping: every accumulated
-- object is its segments, each scaled into place by the power at its
-- station.  (The same shape as KuttakaValli's replayHom — concatenation
-- carried to composition — arriving in the series lane.)
--
-- सत्यनिष्ठा (scope, per the naming rule): the TERMS khaṇḍa/piṇḍa are the
-- tradition's, cited above, where they name Rsine segments and wholes.
-- The block law for the geometric sum is elementary and is STATED BY THIS
-- REPOSITORY for the Kerala chapter; it is not attributed to either text.
-- घात and सङ्कलितम् are IMPORTED from Madhava.agda — the chapter composes;
-- it does not redefine (pratītyasamutpāda; no eighth Term).
--
-- Written in conversation with the warm kernel through नाडी: each ring
-- step below was proposed with `give` and verified live before landing.
------------------------------------------------------------------------

module Texts.KhandaPinda_TheAccumulatedSumIsItsSegmentsScaledIntoPlace where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-suc ; +-zero)
open import Cubical.Data.Int using (ℤ ; pos)
  renaming (_+_ to _+ℤ_ ; _·_ to _·ℤ_)
open import Cubical.Data.Int.Properties using (·Comm ; pos0+ ; +Comm)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

open import Madhava using (घात ; सङ्कलितम् ; वाम-एक)

------------------------------------------------------------------------
-- the carrier law: the power at a joint station is the product of the
-- powers — घातयोगः ।
------------------------------------------------------------------------

private
  -- (a·b)·c ≡ (a·c)·b — the station shuffle, variables only.
  विनिमय : (a b c : ℤ) → (a ·ℤ b) ·ℤ c ≡ (a ·ℤ c) ·ℤ b
  विनिमय a b c = solve! ℤCommRing

घात-योगः : (r : ℤ) (m n : ℕ) → घात r (m + n) ≡ घात r m ·ℤ घात r n
घात-योगः r zero    n = sym (वाम-एक (घात r n))
घात-योगः r (suc m) n =
  cong (_·ℤ r) (घात-योगः r m n) ∙ विनिमय (घात r m) (घात r n) r

------------------------------------------------------------------------
-- खण्ड-पिण्ड-न्यायः: the accumulated whole is its segments scaled into
-- place.  Induction on the second block.
------------------------------------------------------------------------

private
  -- P · 0 vanishes — the empty block carries nothing.
  शून्य-खण्डः : (P : ℤ) → P ·ℤ pos 0 ≡ pos 0
  शून्य-खण्डः P = solve! ℤCommRing

  -- (S + P·T) + P·G ≡ S + P·(T + G) — regrouping, variables only.
  पुनर्गठनम् : (S P T G : ℤ)
    → (S +ℤ (P ·ℤ T)) +ℤ (P ·ℤ G) ≡ S +ℤ (P ·ℤ (T +ℤ G))
  पुनर्गठनम् S P T G = solve! ℤCommRing

खण्ड-पिण्ड-न्यायः : (r : ℤ) (m n : ℕ)
  → सङ्कलितम् r (m + n) ≡ सङ्कलितम् r m +ℤ (घात r m ·ℤ सङ्कलितम् r n)
खण्ड-पिण्ड-न्यायः r m zero =
    cong (सङ्कलितम् r) (+-zero m)
  ∙ sym ( cong (सङ्कलितम् r m +ℤ_) (शून्य-खण्डः (घात r m))
        ∙ +Comm (सङ्कलितम् r m) (pos 0)
        ∙ sym (pos0+ (सङ्कलितम् r m)) )
खण्ड-पिण्ड-न्यायः r m (suc n) =
    cong (सङ्कलितम् r) (+-suc m n)
  ∙ cong₂ _+ℤ_ (खण्ड-पिण्ड-न्यायः r m n) (घात-योगः r m n)
  ∙ पुनर्गठनम् (सङ्कलितम् r m) (घात r m) (सङ्कलितम् r n) (घात r n)
