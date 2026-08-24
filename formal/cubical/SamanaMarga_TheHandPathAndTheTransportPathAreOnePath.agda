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
-- समानमार्गः — the hand road and the transport road are ONE path.
--
-- WHAT THIS REPAIRS.  `Punaragamanam_TheHandProofWasUnnecessary…agda` §5
-- asserts, in prose, that its transport-built path (ℕ×ℕ) ≡ विवेक-प्रमाण
-- "is the same path the hand proof produced", giving as the reason:
-- "the two constructions have the same endpoints and there was only ever
-- one equivalence to have."  The lemma it then names `समान-मार्गः` proves
-- only  उत्थान (अवतरण x) ≡ x  — a round trip of the underlying map — and
-- NOT the equality of the two universe-paths its own prose claims.  The
-- stated reason is moreover false as written: in HoTT two paths with the
-- same endpoints need not be equal (that is exactly the content of "a type
-- is not a set"), and a type in general carries many self-equivalences, so
-- "the same endpoints, one equivalence" does not, by itself, give one path.
--
-- The claim is nonetheless TRUE.  This module discharges it as a checked
-- term rather than a slogan, so the identification §5 wanted is present in
-- the machine and not only in its margin.
--
-- HOW.  `ua` is (one leg of) an equivalence, hence injective; so it is
-- enough to compare what sits under each road.  The hand road is
-- `isoToPath iso = ua (isoToEquiv iso)`, one `ua`.  The transport road is
-- `ua (Carrier≃ योग) ∙ sym (ua विवेक≃वाहकः)`, which `uaInvEquiv` and
-- `uaCompEquiv` fold back into a single `ua` of one composite equivalence.
-- Those two equivalences have JUDGMENTALLY equal underlying functions —
-- the composite sends (s,l) to a record whose प्रमाण field is `sym refl`,
-- the hand map to the same record with प्रमाण = `refl`, and `sym refl` is
-- `refl` definitionally — so `equivEq (funExt λ _ → refl)` closes it and
-- `cong ua` lifts it to the paths.  There was, indeed, only one
-- equivalence; the point is that "only one equivalence" is a THEOREM here
-- (equivEq on judgmentally-equal maps), not a reason one may state and skip.
--
-- WHAT IS NOT TOUCHED.  Neither `Punaragamanam_…` nor `VivekaPramana_…` is
-- edited (नयभेदे सङ्क्षेपो न विद्यते — §7 of the ahiṃsā-sūtra: no collapsing
-- of a standpoint by deletion).  This is a new road laid beside theirs,
-- carrying the derivation their road only gestured at.
--
-- WHAT IS AND IS NOT CLAIMED OF SOURCES.  समानमार्ग / पुनरागमन / विवेक-प्रमाण
-- are this repository's own coinages for these objects, not terms offered as
-- attested in a source text.  The substrate — `ua`, `uaCompEquiv`,
-- `uaInvEquiv`, `equivEq` — is Voevodsky's univalence as realised in cubical
-- type theory.  Nothing below is new mathematics; it is the proof the
-- neighbouring module said was unnecessary, supplied because a named claim
-- with no term behind it is exactly the durnaya this corpus refuses.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9, --cubical --safe, no postulates,
-- no holes, no native_decide.  Verified 2026-08-23.
------------------------------------------------------------------------

module SamanaMarga_TheHandPathAndTheTransportPathAreOnePath where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; _∙ₑ_ ; invEquiv ; equivEq)
open import Cubical.Foundations.Isomorphism using (isoToPath ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua ; uaCompEquiv ; uaInvEquiv)
open import Cubical.Data.Nat using (ℕ ; _+_)
open import Cubical.Data.Sigma using (_×_)

import VivekaPramana_TheRemainderIsLawfulAndTheNetBeats as V
import Punaragamanam_TheHandProofWasUnnecessaryAndTransportGivesIt as P

------------------------------------------------------------------------
-- १ · The two equivalences underneath the two roads are the same map.
--
-- The composite  Carrier≃ योग  then  invEquiv विवेक≃वाहकः  equals, as an
-- equivalence, the hand-built  isoToEquiv isoℕ×ℕ-विवेक-प्रमाण.  Their
-- forward functions are judgmentally equal (the only difference is
-- `sym refl` versus `refl` in the प्रमाण component), so funext is refl.
------------------------------------------------------------------------

संक्रमण-तुल्यम् :
  (P.Carrier≃ P.योग ∙ₑ invEquiv P.विवेक≃वाहकः)
    ≡ isoToEquiv V.isoℕ×ℕ-विवेक-प्रमाण
संक्रमण-तुल्यम् = equivEq (funExt λ _ → refl)

------------------------------------------------------------------------
-- २ · Therefore the two roads are one path.
--
-- Reduce the transport road to a single `ua`, swap in the equal
-- equivalence, and land on the hand road — every step a univalence lemma
-- or `cong ua` of §1.
------------------------------------------------------------------------

समानमार्गः : V.ℕ×ℕ≡विवेक-प्रमाण ≡ P.ℕ×ℕ≡विवेक-प्रमाण
समानमार्गः =
    V.ℕ×ℕ≡विवेक-प्रमाण
  ≡⟨ refl ⟩                                       -- isoToPath = ua ∘ isoToEquiv
    ua (isoToEquiv V.isoℕ×ℕ-विवेक-प्रमाण)
  ≡⟨ cong ua (sym संक्रमण-तुल्यम्) ⟩
    ua (P.Carrier≃ P.योग ∙ₑ invEquiv P.विवेक≃वाहकः)
  ≡⟨ uaCompEquiv (P.Carrier≃ P.योग) (invEquiv P.विवेक≃वाहकः) ⟩
    ua (P.Carrier≃ P.योग) ∙ ua (invEquiv P.विवेक≃वाहकः)
  ≡⟨ cong (ua (P.Carrier≃ P.योग) ∙_) (uaInvEquiv P.विवेक≃वाहकः) ⟩
    ua (P.Carrier≃ P.योग) ∙ sym (ua P.विवेक≃वाहकः)
  ∎
