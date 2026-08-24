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
-- अलोपः — प्रथमो मार्गः त्रिः उक्तः, त्रयः एकम् एव पदम् ।
--
-- WHAT THIS MODULE IS FOR.  अहिंसा-सूत्र-विस्तारः §६ writes the first of the
-- two roads as two lines, संक्रमणम् e = transport (ua e) and अलोपः = uaβ, and
-- THREE modules in this corpus have independently written that second line
-- out as a top-level declaration:
--
--   Nasti_ShabdeJivahVartante.संक्रमणम्-अलोपः
--   NaturalMachine.SankramanaSesa_EveryTransportOwesItsResidual.अलोपः
--   Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis.संक्रमणे-न-किञ्चिन्-नश्यति
--
-- Two of the three carry the same Sanskrit stem under different module roofs.
-- No one of the three imports another.  (Two of the three do cite a third in
-- prose — Apratikaryatva's header records that it restates the line because
-- §६'s own statement in Nasti_Shabde… had not typechecked at the time, and
-- Samkramana_… separately imports Nasti's.  Prose citation is not import, and
-- the audit that found this group could not see the prose.  Recording that
-- here so the finding is not overstated: this is not three modules ignorant
-- of each other, it is three modules that never got wired.)
--
-- THE IDENTIFICATION, AND ITS GRADE.  All three are definitionally the term
-- `uaβ`, so the identification is `refl` — not a path that had to be
-- constructed, not an h-level fact about the target, just the same term under
-- three names.  That is worth separating from the other duplications in this
-- corpus, and §3 does:
--
--   grade one   same term, different name.  Identified by refl.  This module.
--   grade two   different terms, one type, identified because the target is a
--               set.  MadhyaVinimaya_… and Pratyaya_… .
--   grade three different types.  Then §६'s first road needs an actual
--               equivalence and ua, and where there is none the second road
--               applies and a शेष is written.  No instance of grade three is
--               claimed here.
--
-- The grade is the whole content of the finding.  A grade-one duplication
-- costs nothing mathematically and costs everything in visibility: three
-- modules each believing they had to state §६ before they could use it.
--
-- SOURCE OF THE SUBSTRATE.  `ua` and `uaβ` are Voevodsky's univalence as
-- realised in cubical type theory; `uaβ e a : transport (ua e) a ≡ equivFun e
-- a` is the computation rule that makes the first road a road and not a
-- promise.  The Sanskrit names are this corpus's; the theorem is his.
------------------------------------------------------------------------

module Alopa_TheFirstRoadIsStatedThriceAndTheThreeAreOneTerm where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun)
open import Cubical.Foundations.Univalence using (ua ; uaβ)

import Nasti_ShabdeJivahVartante
import NaturalMachine.SankramanaSesa_EveryTransportOwesItsResidual
import Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1 · The line itself, §६ of the sūtra, once.
------------------------------------------------------------------------

संक्रमणम् : {A B : Type ℓ} → A ≃ B → A → B
संक्रमणम् e = transport (ua e)

अलोपः : {A B : Type ℓ} (e : A ≃ B) (a : A) → संक्रमणम् e a ≡ equivFun e a
अलोपः = uaβ

------------------------------------------------------------------------
-- §2 · तादात्म्यम् — the three, identified.
--
-- Each holds by refl: the three declarations are one term.  Writing the
-- types out in full rather than referring to a shared abbreviation is
-- deliberate — the point being checked is that the three modules' local
-- संक्रमणम् definitions agree definitionally with each other and with §1's,
-- and abbreviating would hide exactly that.
------------------------------------------------------------------------

नष्टि-तादात्म्यम्
  : {A B : Type ℓ} (e : A ≃ B) (a : A)
  → Nasti_ShabdeJivahVartante.संक्रमणम्-अलोपः e a ≡ अलोपः e a
नष्टि-तादात्म्यम् e a = refl

शेष-तादात्म्यम्
  : {A B : Type ℓ} (e : A ≃ B) (a : A)
  → NaturalMachine.SankramanaSesa_EveryTransportOwesItsResidual.अलोपः e a ≡ अलोपः e a
शेष-तादात्म्यम् e a = refl

अप्रतिकार्य-तादात्म्यम्
  : {A B : Type ℓ} (e : A ≃ B) (a : A)
  → Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis.संक्रमणे-न-किञ्चिन्-नश्यति e a
  ≡ अलोपः e a
अप्रतिकार्य-तादात्म्यम् e a = refl

-- And pairwise between the three, so no one of them is installed as the
-- centre the other two are measured against.
समनामन्-तादात्म्यम्
  : {A B : Type ℓ} (e : A ≃ B) (a : A)
  → Nasti_ShabdeJivahVartante.संक्रमणम्-अलोपः e a
  ≡ NaturalMachine.SankramanaSesa_EveryTransportOwesItsResidual.अलोपः e a
समनामन्-तादात्म्यम् e a = refl

तृतीय-तादात्म्यम्
  : {A B : Type ℓ} (e : A ≃ B) (a : A)
  → NaturalMachine.SankramanaSesa_EveryTransportOwesItsResidual.अलोपः e a
  ≡ Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis.संक्रमणे-न-किञ्चिन्-नश्यति e a
तृतीय-तादात्म्यम् e a = refl

-- The three local संक्रमणम्s are likewise one function, not three that agree
-- pointwise.  Stated at the level of the function so the agreement is not
-- read as a coincidence at each argument.
संक्रमण-तादात्म्यम्
  : {A B : Type ℓ} (e : A ≃ B)
  → Nasti_ShabdeJivahVartante.संक्रमणम् e
  ≡ NaturalMachine.SankramanaSesa_EveryTransportOwesItsResidual.संक्रमणम् e
संक्रमण-तादात्म्यम् e = refl

------------------------------------------------------------------------
-- §3 · शेषः — the remainder.
--
-- refl identifies the terms and says nothing about why each module needed
-- the line, and the three reasons are not one reason:
--
--   · Nasti_ShabdeJivahVartante states it to set up the CONTRAST that is its
--     subject: §४-५'s नष्टि, propositional truncation, from which there is no
--     retraction.  अलोपः is the thing truncation is not.
--   · SankramanaSesa_EveryTransportOwesItsResidual states it to CONSUME it:
--     the module's claim is that a transport owes a residual, and अलोपः is
--     the input to computing what the residual is.
--   · Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis states it as
--     PATH ONE of a two-path exhibit whose subject is path two — that the
--     शेष a map leaves is complete — so अलोपः there is the half that is
--     already known, present to make the other half's status legible.
--
-- Setup, input, and foil.  A shared import would have served all three; that
-- it did not happen is the fact the audit surfaced, and it is a fact about
-- how this corpus was written, not about univalence.
--
-- WHAT REMAINS OPEN.  §६ says there are exactly two roads and no third.  The
-- three modules above state road one.  Road two — the written शेष — has no
-- corresponding single declaration anywhere, because it is not a theorem: it
-- is what one writes WHEN the theorem is unavailable.  Apratikaryatva argues
-- that road two is nonetheless complete (the fibres of a map determine its
-- domain over its codomain), which is the closest this corpus comes to
-- mechanising the second road, and SankramanaSesa argues that road one always
-- owes something to road two.  Whether those two claims are the same claim is
-- not settled here, and neither module cites the other.
------------------------------------------------------------------------
