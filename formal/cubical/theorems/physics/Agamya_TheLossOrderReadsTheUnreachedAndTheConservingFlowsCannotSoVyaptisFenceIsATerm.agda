{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अगम्य — अगम्यं पदं संरक्षकाः न पश्यन्ति, व्याप्तिः पश्यति ।
--
-- (the unreached point: the conserving flows cannot see it; the loss
--  order can.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS FILLS.  `Vyapti_TheLossOrderIsCoarsening…agda`'s fence says,
-- verbatim:
--
--     "**§३ and §५ are one direction only.**  That `संरक्षणम् f ⊆
--      संरक्षणम् g` implies `f व्याप्नोति g` is FALSE in general and no
--      weakened converse is offered."
--
-- The sentence stands in that file with no witness.  Per the corpus's own
-- discipline (an absence without a command is a rumor; a fence without a
-- counterexample is an estimate), this module makes it a term — and the
-- witness turns out to say more than the fence asked for.
--
-- THE THEOREM.  There are observables f, g on one domain whose entire
-- conserving apparatus is IDENTICAL — each conserving-flow space
-- `Σ[ Φ ] संरक्षणम्` is contractible, so no invariant of the symmetry
-- data whatsoever separates them — while the loss order still does:
-- `g व्याप्नोति f` holds and `f व्याप्नोति g` is refutable.  So व्याप्ति is
-- NOT a function of the conserving flows: the order carries strictly
-- more than the symmetries, and §३ of Vyapti (order ⟹ flows) cannot be
-- reversed even up to any weakening that factors through the flow space.
--
-- WHY, in the census's own vocabulary, which is the point of writing it:
-- a conserving flow is a section of the fiber family AT REACHED POINTS
-- (`SvaTantuVasa`: flows ≃ (a : A) → fiber f (f a) — every index is an
-- f a).  The mediator h of `f व्याप्नोति g` is typed on the WHOLE
-- codomain.  A point of B outside f's image — a रिक्तम् fiber, the
-- census's अवक्तव्यम् — is invisible to every flow and every conservation
-- witness, and it is exactly where h can die.  Here it does: B = Bool
-- with the whole codomain unreached, C = ⊥, and the mediator would be a
-- map Bool → ⊥.  The symmetry standpoint reads motion; the order reads
-- the map's whole codomain, silence included.  मौनं न निषेधः cuts both
-- ways: the flows' silence about the unreached sector is not evidence
-- there is nothing there to owe.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS **NOT** CLAIMED.  The witness is DEGENERATE ON PURPOSE — the
-- domain is ⊥, which is what makes both flow spaces contractible and
-- every conservation hypothesis vacuous, isolating the unreached-sector
-- obstruction with nothing else in the frame.  Whether an INHABITED
-- domain admits the same separation (identical conserving data, order
-- refutable) is not settled here and is the honest next stone: for
-- inhabited A the flow spaces are no longer trivially contractible, and
-- a separating pair would have to hide the difference somewhere subtler
-- than an empty domain.  Left open, named rather than gestured at.
-- Nothing here touches Vyapti's §३/§५, which are correct and are
-- consumed, not restated.
--
-- TERM.  अगम्य — "not to be gone to", unreachable; ordinary Sanskrit
-- (गम् with negative prefix, gerundive).  The compound and its use here
-- for a codomain point outside the image are THIS FILE's; no text is
-- claimed for the term or for any statement below, per CLAUDE.md's
-- naming rule note 2.  The mathematics is cubical type theory
-- (Voevodsky), this repository's one admitted non-Indian frame.
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5 — the container, NOT the
-- repository pin (2.8.0 + v0.9); the same standing `Vyapti` itself
-- declares.  --cubical --safe, no postulates, no holes.
------------------------------------------------------------------------

module Agamya_TheLossOrderReadsTheUnreachedAndTheConservingFlowsCannotSoVyaptisFenceIsATerm where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Foundations.HLevels using (isPropΣ ; inhProp→isContr)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Data.Bool using (Bool ; true)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import Dhruva_TheSymmetryLivesInTheFiberAndWithoutALossThereIsNoSymmetry
  using (संरक्षणम्)
open import Vyapti_TheLossOrderIsCoarseningAndTheSymmetryMonoidGrowsMonotonicallyAlongIt
  using (_व्याप्नोति_)

------------------------------------------------------------------------
-- १ · The pair.  One domain (⊥), two codomains: g reaches everything it
--     names (⊥ — nothing), f names two points and reaches neither.
------------------------------------------------------------------------

f : ⊥ → Bool
f x = ⊥-rec x

g : ⊥ → ⊥
g = idfun ⊥

------------------------------------------------------------------------
-- २ · The conserving apparatus is identical: both flow spaces are
--     contractible, so NO invariant of the symmetries separates f from g.
--     (Everything out of ⊥ is a proposition; the identity flow inhabits.)
------------------------------------------------------------------------

private
  -- any two functions out of ⊥ are equal
  शून्य-Π-prop : {ℓ : Level} {P : ⊥ → Type ℓ} → isProp ((x : ⊥) → P x)
  शून्य-Π-prop u v = funExt (λ x → ⊥-rec x)

प्रवाह-क्षेत्रम् : (h : ⊥ → Bool) → Type
प्रवाह-क्षेत्रम् h = Σ[ Φ ∈ (⊥ → ⊥) ] संरक्षणम् h Φ

f-प्रवाह-संकोचः : isContr (Σ[ Φ ∈ (⊥ → ⊥) ] संरक्षणम् f Φ)
f-प्रवाह-संकोचः =
  inhProp→isContr (idfun ⊥ , λ a → ⊥-rec a)
    (isPropΣ शून्य-Π-prop (λ Φ → शून्य-Π-prop))

g-प्रवाह-संकोचः : isContr (Σ[ Φ ∈ (⊥ → ⊥) ] संरक्षणम् g Φ)
g-प्रवाह-संकोचः =
  inhProp→isContr (idfun ⊥ , λ a → ⊥-rec a)
    (isPropΣ शून्य-Π-prop (λ Φ → शून्य-Π-prop))

-- and conservation-inclusion holds in BOTH directions, vacuously —
-- the hypothesis of the hoped-for converse is as strong as it can be.
संरक्षण-अन्तर्भावः : (Φ : ⊥ → ⊥) → संरक्षणम् f Φ → संरक्षणम् g Φ
संरक्षण-अन्तर्भावः Φ _ a = ⊥-rec a

संरक्षण-प्रत्यन्तर्भावः : (Φ : ⊥ → ⊥) → संरक्षणम् g Φ → संरक्षणम् f Φ
संरक्षण-प्रत्यन्तर्भावः Φ _ a = ⊥-rec a

------------------------------------------------------------------------
-- ३ · The order still separates them — asymmetrically.
--     g व्याप्नोति f holds; f व्याप्नोति g is refutable, and the refuting
--     move is exactly an unreached point of f's codomain meeting a
--     mediator with nowhere to send it.
------------------------------------------------------------------------

गम्यते : g व्याप्नोति f
गम्यते = (λ x → ⊥-rec x) , (λ a → ⊥-rec a)

अगम्यम् : ¬ (f व्याप्नोति g)
अगम्यम् (h , _) = h true

------------------------------------------------------------------------
-- ४ · THE FENCE, AS A TERM.  Vyapti's "no weakened converse" holds
--     against the strongest possible hypothesis: even full two-way
--     conservation-inclusion PLUS equivalence of the entire conserving-
--     flow data (both contractible) does not yield the order.
------------------------------------------------------------------------

व्याप्ति-न-संरक्षणस्य-कार्यम् :
    ((Φ : ⊥ → ⊥) → संरक्षणम् f Φ → संरक्षणम् g Φ)
  × ((Φ : ⊥ → ⊥) → संरक्षणम् g Φ → संरक्षणम् f Φ)
  × isContr (Σ[ Φ ∈ (⊥ → ⊥) ] संरक्षणम् f Φ)
  × isContr (Σ[ Φ ∈ (⊥ → ⊥) ] संरक्षणम् g Φ)
  × (¬ (f व्याप्नोति g))
व्याप्ति-न-संरक्षणस्य-कार्यम् =
    संरक्षण-अन्तर्भावः
  , संरक्षण-प्रत्यन्तर्भावः
  , f-प्रवाह-संकोचः
  , g-प्रवाह-संकोचः
  , अगम्यम्
