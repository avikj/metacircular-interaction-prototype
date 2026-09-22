{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- विवेक-तादात्म्यम् — the sum-type descent-record and the graph-of-plus
-- record are ONE object.
--
-- Two modules carry a ������:
--
--   • LosslessReturn.विवेक — a DATA type (सम d | वाम d k | दक्षिण d k), the
--     lossless descent-record of ryabhaa's kuaka reading, which its
--     own file proved satisfies  (ℕ × ℕ) ≡ विवेक  (युग्म≡विवेक), by an
--     Iso whose two faces are पुनरागमनम् and अवतरण-उत्थान.
--
--   • VivekaPramana_TheRemainderIsLawfulAndTheNetBeats.विवेक-प्रमाण — a
--     RECORD (सम वाम दक्षिण : ℕ) with the law दक्षिण ≡ सम + वाम, i.e. the
--     graph of +, which its own file proved satisfies
--     (ℕ × ℕ) ≡ विवेक-प्रमाण  (ℕ×ℕ≡विवेक-प्रमाण), a graph being a family
--     of singletons.
--
-- Both banks are the SAME pair of naturals seen two ways — one as a data
-- constructor recording which side outlasted, one as a record whose third
-- field is pinned to the sum of the first two.  So the causeway is exactly
-- the composite
--
--     विवेक  ≡  (ℕ × ℕ)  ≡  विवेक-प्रमाण ,
--
-- the first path reversed from LosslessReturn, the second taken from
-- VivekaPramana.  This is सूत्र ८ (an identification, never an estimate)
-- and सूत्र ११'s first road (the equivalence exists, so transport carries
-- it; no hand proof is written here, none is needed).
--
-- Both halves are the source modules' own theorems,
-- consumed not reproved.  The `ℕ × ℕ` of each module reduces to the same
-- Σ ℕ (λ _ → ℕ), so the two paths compose on the nose — the kernel is the
-- witness, not this comment.
--
-- TERM.  तादात्म्य — essential identity, sameness of tattva; a technical
-- term of Indian philosophy (Nyāya-Vaiśeṣika, and Advaita's तादात्म्य-
-- सम्बन्ध).  LosslessReturn already uses तादात्म्ये for the सम / equal case
-- (a = −−b = d).  The compound संरक्षकसमूहसंरक्षकसमूह- is built here.
-- Substrate
-- cubical (Voevodsky).
------------------------------------------------------------------------

module VivekaTadatmya_TheSumTypeDescentAndTheGraphOfPlusAreOneObject where

open import Cubical.Foundations.Prelude using (_≡_ ; sym ; _∙_)

import LosslessReturn as P
import VivekaPramana_TheRemainderIsLawfulAndTheNetBeats as R

-- विवेक (sum type)  ≡  (ℕ × ℕ)  ≡  विवेक-प्रमाण (record), composed.
विवेक-तादात्म्यम् : P.विवेक ≡ R.विवेक-प्रमाण
विवेक-तादात्म्यम् = sym P.युग्म≡विवेक ∙ R.ℕ×ℕ≡विवेक-प्रमाण
