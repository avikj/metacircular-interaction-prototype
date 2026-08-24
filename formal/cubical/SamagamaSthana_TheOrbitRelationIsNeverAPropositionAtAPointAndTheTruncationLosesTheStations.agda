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
-- समागम-स्थानम् — मेलनस्थाने द्वे, न प्रतिज्ञा एका ।
--
-- (the meeting has two stations; it is not one proposition.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS.
--
-- `SamanaKaksya_…agda` §६ leaves one thing open and states it as an
-- assertion, in these words:
--
--     "Unaddressed here: whether `समानकक्ष्या` is valued in propositions
--      (it is not, in general — the meeting stations are data), and
--      hence what `भागः` is the quotient BY when the relation carries
--      content.  `SetQuotients` truncates it, which is the right move
--      for §४ and is the wrong move for any groupoid-level reading of
--      the same orbit."
--
-- This file converts the parenthesis into a theorem, and finds that the
-- true statement is STRONGER than the one asserted.  "Not in general"
-- suggests a counterexample has to be hunted — some particular `A`, some
-- particular `Φ`.  It does not.  §१:
--
--     for EVERY type `A`, EVERY endomorphism `Φ`, and EVERY point `a`,
--     `समानकक्ष्या Φ a a` is not a proposition.
--
-- No hypothesis on `A` at all — not `isSet`, not inhabitedness beyond the
-- point `a` that the statement already names.  The two witnesses are
-- `(0,0,refl)` — stay put on both sides — and `(1,1,refl)` — step once on
-- both sides.  Both are meetings of `a` with itself; a path between them
-- would give `0 ≡ 1` in ℕ by `cong fst`.  The reason is structural and
-- has nothing to do with the dynamics of `Φ`: the DIAGONAL of the station
-- pair is always available, so the isotropy of §१ of that file always
-- contains a copy of ℕ, before any period of the flow is asked for.
--
-- §२ is the same fact stated as a loss rather than as a negation: the
-- station map `fst : समानकक्ष्या Φ a a → ℕ` does NOT factor through the
-- propositional truncation.  Not "need not" — cannot, and the proof is
-- three lines.  That is precisely "`SetQuotients` truncates it": the
-- truncation is exactly the operation that forgets which meeting.
--
-- §३ measures the gap in a case where it can be measured on the nose:
-- for `A = Unit` and `Φ = id` — one point, no dynamics whatever, the most
-- degenerate flow there is — `समानकक्ष्या Φ tt tt ≃ ℕ × ℕ`.  The
-- SetQuotient identifies all of that with a point.  A relation whose
-- every instance is a copy of ℕ × ℕ is being used as if it were `⊤`.
--
-- §४ is the positive half, and it is what the isotropy is FOR: a period
-- of the flow at `a` — any `p` with `Φᵖ a ≡ a` — acts on the meetings at
-- `a` by shifting a station, on either side.  So periodicity of the flow
-- is literally an action on the isotropy type, and the truncation of §२
-- is what destroys it.  This holds for a bare endomorphism; no inverse.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.
--
-- **No untruncated quotient is constructed here, and therefore nothing
-- is proved about its loop space.**  The natural guess — that `A`
-- quotiented by `समानकक्ष्या` without truncation is the action groupoid
-- of the ℕ-action (the ℤ-action when `Φ` is an equivalence), with orbits
-- as connected components and the period monoid as isotropy — is a
-- guess.  It is NOT stated as a theorem anywhere below, and §१–§४ do not
-- establish it.  What §१ and §४ establish is only that the relation
-- carries ℕ-indexed data at every point and that periods act on that
-- data; identifying that data with `Ω` of any quotient would require the
-- quotient, and there is none here.
--
-- **§१ is not a statement that the flow is aperiodic or periodic.**  The
-- two witnesses it uses are the diagonal ones, present for every `Φ`.
-- It says nothing about whether `Φ` has a genuine period at `a`.
--
-- **§३ is about `Unit` and `id` and nothing else.**  It is an exact
-- computation in one degenerate case, chosen because it is the case where
-- the intuition "surely there is nothing to lose here" is strongest.
--
-- **Nothing here refutes §४ of `SamanaKaksya_…agda`.**  That file's
-- descent theorem is correct as stated: it needs `isSet B`, and for a
-- set-valued charge the truncation is harmless.  What is refuted is only
-- the reading under which the relation could have been prop-valued.
--
-- **No saptabhaṅgī reading is offered, and the obvious one is declined
-- on the merits.**  It is tempting to read the truncation of §२ as the
-- loss of अवक्तव्य — the fourth predication of the Jaina sevenfold scheme
-- (Umāsvāti, तत्त्वार्थसूत्र; Siddhasena Divākara, सन्मतितर्क;
-- Samantabhadra, आप्तमीमांसा), which arises when two standpoints are
-- asserted SIMULTANEOUSLY rather than in succession.  The mathematics
-- here does not earn it.  अवक्तव्य is generated by the joint assertion of
-- स्यादस्ति and स्यान्नास्ति — an affirmation and a negation under
-- different नयs.  §१'s two witnesses are both affirmations, of the same
-- form, differing only in an ℕ; nothing in them is a negation of the
-- other, and there is no second नय in play.  Calling the station pair
-- अवक्तव्य would be borrowing a Jaina term for a structure the Jaina
-- logicians did not describe — the mining this repository's own frame
-- prohibits, arriving as ornament.  Stated here so the next reader does
-- not supply the reading and take it for established.
--
-- ────────────────────────────────────────────────────────────────────
-- TERMS.  समागम — "coming together, meeting", ordinary Sanskrit,
-- classical and standard.  स्थान — "station, place"; used in the
-- siddhāntic astronomical texts for a position on an orbit (कक्ष्या,
-- Āryabhaṭa, आर्यभटीयम्, 499; and standard in the Sūryasiddhānta after),
-- which is the sense borrowed here.  **The compound समागम-स्थानम् in the
-- sense "the pair of iteration counts at which two forward trajectories
-- coincide" is BUILT HERE.  No text is claimed for it, and no source
-- states anything below.**  The LIMIT on कक्ष्या is carried in unchanged
-- from `Kaksya_…agda`: attested for a planet's orbit, and its use for the
-- orbit of an endomorphism is this corpus's, not the tradition's.
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5 — the container toolchain, NOT
-- the repository pin (2.8.0 + v0.9).  --cubical --safe, no postulates, no
-- holes, exit 0.
------------------------------------------------------------------------

module SamagamaSthana_TheOrbitRelationIsNeverAPropositionAtAPointAndTheTruncationLosesTheStations where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; znots)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt ; isPropUnit)
open import Cubical.Data.Empty using (⊥)
open import Cubical.HITs.PropositionalTruncation using (∥_∥₁ ; ∣_∣₁ ; squash₁)

open import Kaksya_TheChargeIsConstantAlongTheWholeOrbitAndNotOnlyAcrossOneStep
  using (कक्ष्या)
open import SamanaKaksya_TheOrbitRelationIsAlreadyAnEquivalenceWithoutAnInverseAndTheChargeDescendsToTheQuotient
  using (समानकक्ष्या ; समान-स्व)

private variable ℓ : Level

------------------------------------------------------------------------
-- ० · the two diagonal meetings, named, because everything below is
--     about the pair of them.
--
-- `विश्राम` — the meeting where neither side moves; it is `समान-स्व`.
-- `पदैक` — the meeting where both sides take exactly one step.  Both are
-- meetings of `a` with itself, for any `Φ` at all.
------------------------------------------------------------------------

module _ {A : Type ℓ} (Φ : A → A) (a : A) where

  विश्रामः : समानकक्ष्या Φ a a
  विश्रामः = zero , zero , refl

  पदैकः : समानकक्ष्या Φ a a
  पदैकः = suc zero , suc zero , refl

  -- the first station distinguishes them, on the nose
  स्थानम् : समानकक्ष्या Φ a a → ℕ
  स्थानम् = fst

------------------------------------------------------------------------
-- १ · न प्रतिज्ञा — THE ORBIT RELATION IS NEVER A PROPOSITION AT A POINT.
--
-- `SamanaKaksya` §६ says "it is not, in general".  It is not, ever — at
-- any point of any type under any endomorphism.  The witnesses are the
-- two diagonal meetings of §०, and the separation is `cong fst`.
------------------------------------------------------------------------

  समानकक्ष्या-न-प्रतिज्ञा : isProp (समानकक्ष्या Φ a a) → ⊥
  समानकक्ष्या-न-प्रतिज्ञा h = znots (cong स्थानम् (h विश्रामः पदैकः))

  -- and therefore the relation is not prop-valued as a relation
  समानकक्ष्या-न-प्रतिज्ञा-सर्वत्र :
    ((x y : A) → isProp (समानकक्ष्या Φ x y)) → ⊥
  समानकक्ष्या-न-प्रतिज्ञा-सर्वत्र h = समानकक्ष्या-न-प्रतिज्ञा (h a a)

------------------------------------------------------------------------
-- २ · संकोचे स्थान-नाशः — THE TRUNCATION DESTROYS THE STATION.
--
-- The same fact with its sign reversed.  §१ says the relation is not a
-- proposition; this says what is lost when it is forced to be one: the
-- station map does not factor through `∥_∥₁`.  Not "need not factor" —
-- no factorisation exists.
--
-- This is the exact content of `SamanaKaksya` §६'s "`SetQuotients`
-- truncates it".  `/rec` sees only `∥ R ∥₁`-worth of the relation, so
-- every construction that reads a station is unavailable downstream of
-- the quotient.
------------------------------------------------------------------------

  स्थानं-न-संकोचात् :
    (g : ∥ समानकक्ष्या Φ a a ∥₁ → ℕ)
    → ((r : समानकक्ष्या Φ a a) → g ∣ r ∣₁ ≡ स्थानम् r)
    → ⊥
  स्थानं-न-संकोचात् g fact =
    znots ( sym (fact विश्रामः)
          ∙ cong g (squash₁ ∣ विश्रामः ∣₁ ∣ पदैकः ∣₁)
          ∙ fact पदैकः )

------------------------------------------------------------------------
-- ३ · एकबिन्दौ अपि — THE GAP IS ℕ × ℕ ALREADY ON ONE POINT.
--
-- `A = Unit`, `Φ = id`: no room to move, no dynamics, nothing to
-- observe.  The orbit relation on it is still `ℕ × ℕ` — every pair of
-- stations is a distinct meeting, because every station is the same
-- point and all the paths between them agree.
--
-- The SetQuotient of §४ of `SamanaKaksya` sends all of this to one
-- element.  That is the size of the truncation gap in the smallest case
-- there is.
------------------------------------------------------------------------

private
  एक : Unit → Unit
  एक u = u

  -- every meeting-path in `Unit` is the canonical one
  एक-पथः : (x y : Unit) (p : x ≡ y) → p ≡ isPropUnit x y
  एक-पथः x y p = isProp→isSet isPropUnit x y p (isPropUnit x y)

बिन्दु-समागमाः : Iso (समानकक्ष्या एक tt tt) (ℕ × ℕ)
बिन्दु-समागमाः = iso to from (λ _ → refl) sect
  where
  φ : ℕ → Unit → Unit
  φ = कक्ष्या {B = Unit} (λ u → u) एक

  to : समानकक्ष्या एक tt tt → ℕ × ℕ
  to (m , n , _) = m , n

  from : ℕ × ℕ → समानकक्ष्या एक tt tt
  from (m , n) = m , n , isPropUnit (φ m tt) (φ n tt)

  sect : (r : समानकक्ष्या एक tt tt) → from (to r) ≡ r
  sect (m , n , p) i = m , n , एक-पथः (φ m tt) (φ n tt) p (~ i)

बिन्दु-समागमाः-तुल्यता : समानकक्ष्या एक tt tt ≃ (ℕ × ℕ)
बिन्दु-समागमाः-तुल्यता = isoToEquiv बिन्दु-समागमाः

------------------------------------------------------------------------
-- ४ · आवृत्तिः स्थानेषु वर्तते — A PERIOD OF THE FLOW ACTS ON THE
--     MEETINGS.
--
-- This is the positive reading of §१, and it is where the isotropy earns
-- its name.  Let `p` be a period of `Φ` at `a`: `Φᵖ a ≡ a`.  Then `p`
-- acts on the meetings at `a` by adding `p` to a station — on the left,
-- or on the right — and the result is again a meeting.  No inverse of
-- `Φ` is used; `Φ` is a bare endomorphism throughout.
--
-- So the period structure of the flow is an action on `समानकक्ष्या Φ a a`
-- — and §२ says that action is exactly what the truncation cannot see.
------------------------------------------------------------------------

module _ {A : Type ℓ} (Φ : A → A) where

  private
    φ : ℕ → A → A
    φ = कक्ष्या {B = A} (λ x → x) Φ

  -- iterates add (the lemma `SamanaKaksya` §१ proves; restated locally
  -- so this module does not depend on that module's private `φ`)
  योगः : (m n : ℕ) (a : A) → φ (m + n) a ≡ φ m (φ n a)
  योगः zero    n a = refl
  योगः (suc m) n a = cong Φ (योगः m n a)

  -- आवृत्तिः — a period of the flow at `a`
  आवृत्तिः : A → ℕ → Type ℓ
  आवृत्तिः a p = φ p a ≡ a

  -- the period shifts the LEFT station
  आवृत्ति-वामा : (a : A) (p : ℕ) → आवृत्तिः a p
              → समानकक्ष्या Φ a a → समानकक्ष्या Φ a a
  आवृत्ति-वामा a p per (m , n , q) =
    (m + p) , n , (योगः m p a ∙ cong (φ m) per ∙ q)

  -- and the RIGHT station, by the same three steps read backwards
  आवृत्ति-दक्षिणा : (a : A) (p : ℕ) → आवृत्तिः a p
                 → समानकक्ष्या Φ a a → समानकक्ष्या Φ a a
  आवृत्ति-दक्षिणा a p per (m , n , q) =
    m , (n + p) , (q ∙ sym (cong (φ n) per) ∙ sym (योगः n p a))

  -- and it genuinely moves the station: the shifted meeting's station is
  -- `m + p`, on the nose.  (`SamanaKaksya` §२'s `समान-स्व` is the
  -- meeting the shift starts from when `m ≡ 0`.)
  आवृत्ति-स्थानम् : (a : A) (p : ℕ) (per : आवृत्तिः a p)
                 (r : समानकक्ष्या Φ a a)
               → fst (आवृत्ति-वामा a p per r) ≡ fst r + p
  आवृत्ति-स्थानम् a p per r = refl

------------------------------------------------------------------------
-- ५ · शेषः — what stays open, stated so it is not mistaken for proved.
--
-- (i)  The action groupoid.  §१ and §४ say the relation carries ℕ-indexed
--      data at every point and that periods act on it.  They do NOT say
--      that the untruncated quotient of `A` by `समानकक्ष्या` is the
--      action groupoid of the ℕ-action, and no such quotient is built
--      here.  Building it needs a HIT that is not `SetQuotients`, and the
--      first honest question about it is whether the resulting type is
--      even 1-truncated — which §३ makes doubtful, since the isotropy
--      already contains `ℕ × ℕ` for reasons having nothing to do with the
--      flow.
--
-- (ii) The loop space.  "Ω of the quotient at `[a]` is the period monoid"
--      is UNPROVED here and, as stated, is probably false as it stands:
--      §१'s two witnesses are diagonal and exist with no period present,
--      so any such identification would first have to quotient the
--      station pair by its diagonal — i.e. read `(m,n)` through `m ∸ n`,
--      which is only a group when `Φ` is an equivalence.  That is the
--      real shape of the open item, and it is not addressed below or
--      above.
--
-- (iii) The converse of §२: whether anything at all survives truncation
--      beyond the mere existence of a meeting.  §२ kills the station map;
--      it does not classify what does factor.
------------------------------------------------------------------------
