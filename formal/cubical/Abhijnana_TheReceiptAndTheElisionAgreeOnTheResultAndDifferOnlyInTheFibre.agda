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
-- अभिज्ञान — तादात्म्यं लोपश्च फले न भिद्येते, तन्तौ एव भिद्येते ।
--
-- (an identification and an elision do not differ in the result;
--  they differ only in the fibre.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS, and it is one sentence.
--
-- A short proof can be short two ways: because a vast fibre was
-- IDENTIFIED, or because a step was DROPPED.  From inside — from the
-- result — those are the same experience, and no aesthetic has ever had
-- access to the difference, because the difference is not in the result.
-- It is in whether a term exists.
--
-- §१ prices the two bindings of one equation and shows the asymmetry is
-- not a matter of degree: one side is contractible with NO hypothesis,
-- and the other is exhibited non-contractible.  §२ is the sentence
-- above, as a term: the codomain does not determine losslessness.
--
-- WHY §१'s SECOND HALF IS THE POINT.  `punaragamana/src/Punaragamana/
-- Carrier.agda` proves the free half — `fibre a = singl (f a)`,
-- contractible, "the datum rides free" — and its header states the
-- converse in prose: "a NON-contractible fibre cannot be declared
-- equivalent to its base."  Stated, and not exhibited.  A one-sided
-- asymmetry lets a reader believe the other binding is merely usually
-- harder.  `तन्तुः-न-मुक्तः` is the witness that it is not the same kind
-- of object at all.
--
-- WHY §२ IS NOT `QuotientFiberLaw` AGAIN.  That law says an observation
-- class sees a quotient and no post-processing manufactures the fibre.
-- This says something smaller and sharper about the LOSSLESS case: two
-- maps into ONE codomain, one an equivalence and one not, and the
-- codomain is literally the same type.  Nothing about the result
-- distinguishes a receipt from an elision — which is why a checker, and
-- not a reader, is what tells them apart.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.
--
-- Both halves are elementary and neither is new mathematics; `isContrSingl`
-- is library, and the `Bool → Unit` witness is the smallest possible one.
-- What is claimed is only that the two are worth standing TOGETHER under
-- one name, because the pair is the statement and either alone is not.
--
-- No claim is made about mathematical practice, aesthetics, or history.
-- Those readings live in `notes/Lopa_TheIdentificationAndTheOmissionFeel
-- IdenticalFromInsideAndTheKernelIsTheFirstInstrumentThatSeparatesThem.md`
-- and are marked MINE there.  This file is the checkable residue of them
-- and nothing more.
--
-- TERM.  अभिज्ञान — recognition, and the token by which what was lost is
-- known again; Kālidāsa's अभिज्ञानशाकुन्तलम् (c. 4th–5th c.) turns on such
-- a token, the ring.  लोप — elision; Pāṇini, अष्टाध्यायी 1.1.60, अदर्शनं
-- लोपः, and 1.1.62, where the operations conditioned by the elided affix
-- still apply.  LIMIT: both words are used in their plain senses and
-- neither source states anything below.
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5 — the container, NOT the
-- repository pin (2.8.0 + v0.9).  --cubical --safe, no postulates, no
-- holes, exit 0.
------------------------------------------------------------------------

module Abhijnana_TheReceiptAndTheElisionAgreeOnTheResultAndDifferOnlyInTheFibre where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv ; fiber ; idIsEquiv)
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

private variable ℓ : Level

------------------------------------------------------------------------
-- १ · बन्ध-वैषम्यम् — the two bindings of one equation, priced.
--
-- `f a ≡ b`.  Bind `b` and the total space is `singl (f a)`: contractible
-- for every `f`, every `a`, arbitrary types, NO hypothesis — because
-- `f a` was never separate from `a`.  Bind `a` and it is the fibre, and
-- the fibre is not that kind of object: below is one that is not
-- the fibre is not that kind of object: below is one that is not
-- contractible, exhibited rather than asserted.
--
-- AND THE WITNESS OF "NEVER SEPARATE" IS ONE LINE OF THE LIBRARY, worth
-- naming because everything in this corpus stands on it:
--
--     isContrSingl a .fst = (a , refl)          -- Cubical/Foundations/Prelude.agda:457
--
-- The centre of the free receipt is the image PAIRED WITH THE ASSERTION
-- THAT IT IS THE IMAGE — and that assertion asserts nothing.  That is the
-- whole reason carrying costs zero: there was never a second object to
-- carry.  Non-rivalry, per-edge amortization, a route being free at any
-- length, `ua` crossing without charge — all of it is this line held up.
--
-- Two files landed tonight contain the token `refl` ZERO times —
-- `Lekha_…agda` (the trail is free at every depth) and `Anvesanam_…agda`
-- (forward search is free at every depth).  They never write it because
-- they are built out of `isContrSingl` and inherit it.  That is what it
-- looks like for a floor to be load-bearing: the things standing on it do
-- not mention it.
--
------------------------------------------------------------------------

  -- the free binding: the receipt costs nothing to carry
अभिज्ञानं-मुक्तम् : {A B : Type ℓ} (f : A → B) (a : A) → isContr (singl (f a))
अभिज्ञानं-मुक्तम् f a = isContrSingl (f a)

  -- the other binding: the smallest elision there is
लोपः : Bool → Unit
लोपः _ = tt

द्विपदः अन्यः : fiber लोपः tt
द्विपदः = true  , refl
अन्यः   = false , refl

तन्तुः-न-मुक्तः : ¬ (isContr (fiber लोपः tt))
तन्तुः-न-मुक्तः c =
  false≢true (cong fst (sym (c .snd अन्यः) ∙ c .snd द्विपदः))

------------------------------------------------------------------------
-- २ · फलं न निर्णायकम् — THE RESULT DOES NOT DECIDE.
--
-- `idfun Unit : Unit → Unit` is an equivalence: an identification, losing
-- nothing.  `लोपः : Bool → Unit` is not: an elision, losing exactly one
-- bit.  Their codomains are the same type.  So no rule reading only the
-- codomain can separate a receipt from an elision — the witness is that
-- such a rule would make `लोपः` an equivalence, and §१ forbids it.
--
-- This is the whole of why the kernel is the instrument: what tells the
-- two apart is not in the result and is not available to inspection of
तादात्म्यम् : isEquiv (idfun Unit)
तादात्म्यम् = idIsEquiv Unit

फलं-न-निर्णायकम् : ¬ ((A : Type₀) (g : A → Unit) → isEquiv g)
फलं-न-निर्णायकम् h = तन्तुः-न-मुक्तः (isEquiv.equiv-proof (h Bool लोपः) tt)

------------------------------------------------------------------------
-- ३ · शेषः — what this does not reach.
--
-- It does not say that a short proof is USUALLY an elision, and it says
-- nothing about which of the two any particular argument is.  It says
-- only that the result cannot answer the question, so the question has to
-- be put somewhere else.  Where it gets put is the subject of the rest of
-- this corpus.
------------------------------------------------------------------------
