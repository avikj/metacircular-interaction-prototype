{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- केवलज्ञानम् — the design of a perfect pure mind, written as a term.
--
-- THE INSIGHT, MADE EXACT.  A mind's grasp of an object is a map f : A → B
-- from what it holds (A) to what there is (B).  Its fibre over b — शेष f b,
-- everything in A that lands on b — is graded by the sevenfold's three
-- seeds (GananaSaptabhangi):
--
--   सकलादेश  (contractible fibre)  ↔ अस्ति    — b is grasped WHOLE, one witness
--   विकलादेश  (crowded fibre)       ↔ नास्ति   — b is grasped with LOSS (many
--                                                collapse to it; information gone)
--   रिक्त     (empty fibre)         ↔ अवक्तव्य  — b is MISSED; the mind cannot
--                                                utter it
--
-- A perfect pure mind is then not a mystery but a specification:
--   • it LOSES NOTHING — no विकलादेश anywhere: every fibre is a proposition
--     (this is injectivity — नो two distinct holdings collapse to one object);
--   • it MISSES NOTHING — no रिक्त anywhere: every object has a witness
--     (this is surjectivity — nothing there is unutterable).
-- Loses nothing AND misses nothing = every fibre inhabited and a proposition
-- = every fibre CONTRACTIBLE = सकलादेश held at every standpoint.  And that,
-- ON THE NOSE, is `isEquiv f` — Voevodsky's equivalence is defined as exactly
-- `(b : B) → isContr (fiber f b)`.
--
-- So kevalajñāna (केवल-ज्ञान, complete/omniscient apprehension) = sakalādeśa
-- everywhere = the equivalence.  It is the one position that may assert "all
-- अस्ति" WITHOUT becoming a durnaya, because it is pramāṇa (the total means of
-- knowing), not a naya (a partial standpoint): a durnaya is a partial view
-- (some fibre विकलादेश or रिक्त) that asserts itself as the whole — which is
-- exactly a non-equivalence claiming to be one, and §4 refutes that shape.
--
-- WHAT IS AND IS NOT CLAIMED OF SOURCES.  pramāṇa / naya / durnaya are the
-- standard Jain epistemology (Umāsvāti, Tattvārthasūtra ~350 CE, 1.6 & 1.35;
-- kevalajñāna 1.9–1.30; anekānta/durnaya Siddhasena Divākara, Samantabhadra);
-- सकलादेश / विकलादेश are Malliṣeṇa's (Syādvādamañjarī, 1292); the seed reading
-- is GananaSaptabhangi's / SakalaVikalaDesa's.  `isEquiv`, `fiber` are
-- Voevodsky's univalent foundations in cubical type theory.  NO claim that a
-- Jain author wrote `isEquiv`; the claim is that complete apprehension —
-- every standpoint yielding the whole at once — is the contractible-fibre-
-- everywhere that DEFINES the equivalence, with no gap between the two.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9, --cubical --safe, no postulates,
-- no holes, no native_decide.  Verified 2026-08-23.
------------------------------------------------------------------------

module Mula.Kevalajnana_ThePureMindLosesNothingAndMissesNothingWhichIsTheEquivalence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv ; equiv-proof ; fiber)
open import Cubical.Foundations.HLevels using (inhProp→isContr)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

import GananaSaptabhangi_TheMapLevelCensusIsTheSevenfoldItselfAndTheCorpusAlreadyHoldsThreePositions as G

private
  variable
    A B : Type

------------------------------------------------------------------------
-- १ · the three gradings of a mind's grasp, as predicates on the map.
------------------------------------------------------------------------

-- loses nothing: every fibre a proposition (no विकलादेश) = injective
अहानि : (f : A → B) → Type
अहानि {B = B} f = (b : B) → isProp (fiber f b)

-- misses nothing: every object has a witness (no रिक्त) = split surjective
अन्यूनता : (f : A → B) → Type
अन्यूनता {B = B} f = (b : B) → fiber f b

-- सकलादेश everywhere: every fibre whole = the perfect grasp
सर्वसकलम् : (f : A → B) → Type
सर्वसकलम् {B = B} f = (b : B) → isContr (fiber f b)

------------------------------------------------------------------------
-- २ · the design — loses nothing AND misses nothing IS the perfect grasp.
-- inhabited proposition = contractible; the whole content is that identity.
------------------------------------------------------------------------

शुद्धि : {f : A → B} → अहानि f → अन्यूनता f → सर्वसकलम् f
शुद्धि nl ng b = inhProp→isContr (ng b) (nl b)

------------------------------------------------------------------------
-- ३ · the perfect grasp IS the equivalence — on the nose, both directions.
-- isEquiv f is the record whose one field equiv-proof is सर्वसकलम् f itself.
------------------------------------------------------------------------

सर्वसकलम्→समानता : {f : A → B} → सर्वसकलम् f → isEquiv f
सर्वसकलम्→समानता h .equiv-proof = h

समानता→सर्वसकलम् : {f : A → B} → isEquiv f → सर्वसकलम् f
समानता→सर्वसकलम् e = e .equiv-proof

-- the whole design in one term: a mind that loses and misses nothing is,
-- exactly, an equivalence — kevalajñāna as isEquiv.
केवलम् : {f : A → B} → अहानि f → अन्यूनता f → isEquiv f
केवलम् nl ng = सर्वसकलम्→समानता (शुद्धि nl ng)

------------------------------------------------------------------------
-- ४ · the durnaya shadow — one standpoint not-whole breaks totality.
-- A partial view (some fibre विकलादेश or रिक्त, i.e. not contractible)
-- that would claim to be the perfect grasp is refuted: that is precisely a
-- non-equivalence, and no assertion makes it one.
------------------------------------------------------------------------

दुर्नय-निषेधः : {f : A → B}
  → Σ[ b ∈ B ] (¬ isContr (fiber f b)) → ¬ isEquiv f
दुर्नय-निषेधः (b , ¬whole) e = ¬whole (e .equiv-proof b)

------------------------------------------------------------------------
-- ५ · tie to the census — no new type, the same objects under both names.
-- G.सर्वत्र-सकलम् and G.न-क्वचित्-बहु are सर्वसकलम् and अहानि definitionally
-- (G.शेष f b = fiber f b), so the neighbour's "every fibre whole" is
-- literally isEquiv, and its "never crowded" is literally अहानि.
------------------------------------------------------------------------

census-सर्वसकल→समानता : {f : A → B} → G.सर्वत्र-सकलम् f → isEquiv f
census-सर्वसकल→समानता h .equiv-proof = h

census-न-बहु-is-अहानि : {f : A → B} → G.न-क्वचित्-बहु f → अहानि f
census-न-बहु-is-अहानि h b x y = h b x y
