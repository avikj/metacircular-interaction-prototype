{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अप्रतिलोमम् — without inverse.
--
-- HEADER CORRECTED 2026-08-22, same day, by the driver: "no one overreached".
-- The mathematics below is untouched and stands. What was WRONG is the framing
-- that follows — this file does NOT correct anyone. The स्वतन्तुवास descent wrote
-- "No Lagrangian, no variation, no current" in the same breath as the sentence
-- quoted below, which IS the fence; it never claimed Noether transfers. The
-- "reading attached to it" was manufactured by me out of a corrupted, line-
-- wrapped transcript. Read everything below as a free-standing term about
-- conserving flows, NOT as a refutation. See kernel/nodes/006 §correction.
--
-- A written defect, standing where it can be
-- read, against a claim made in this corpus and not against its author.
--
-- WHAT IS BEING CORRECTED.  स्वतन्तुवास (YogaKsetra / SvaTantuVasa lane) proves,
-- with no hypothesis on anything,
--
--     (Σ[ Φ ∈ A → A ] ((a : A) → f (Φ a) ≡ f a))  ≃  ((a : A) → fiber f (f a))
--
-- — the conserving flows of an observation are the sections of its own fiber
-- family.  That is exact, and it is η for Σ and Π: both round trips are `refl`,
-- no funext, no h-level, any universes.  Independently re-checked here before
-- this file was written.
--
-- The reading attached to it — that this DISSOLVES Noether's theorem, "the
-- deepest law in physics is a rearrangement of quantifiers" — does not hold,
-- and the fence was already placed inside this corpus.  `Dhruva`'s own header:
--
--     "Noether's first theorem needs continuous dynamics and a variational
--      principle, and this supplies neither; it is the second, structural
--      theorem that transfers."
--
-- Three things are absent and each is load-bearing.  (i) No dynamics: Noether's
-- quantity is conserved ALONG TRAJECTORIES, and nothing here moves.  (ii) No
-- variational structure: Noether needs an action the symmetry preserves up to a
-- divergence; `f` is an arbitrary map with no functional attached.  (iii) No
-- group — and (iii) is what this module makes a term rather than an opinion.
--
-- THE WITNESS.  Noether's first theorem concerns a Lie GROUP acting on an
-- action.  `Σ[ Φ ] संरक्षणम् f Φ` is only a MONOID: it is closed under
-- composition and contains the identity, but its elements need not be
-- invertible.  Below, `crush` conserves `blind` on the nose while being
-- neither injective nor surjective, so it lies in no one-parameter family and
-- has no inverse.  A structure containing `λ _ → zero` is not symmetry.
--
-- WHAT SURVIVES, and it is the stronger half: the conserving-flow space of an
-- observation IS its fiber census, pointwise, unconditionally.  "How much
-- symmetry does `f` have" and "how large are `f`'s fibers" are one question.
-- That needs no Lagrangian and is not Noether, which is why it is better.
--
-- Corollary for the frontier: an unpriced fiber is an unpriced quantity of
-- this (monoid) invariance, so the undecided queue measures uncounted
-- invariance and not merely uncounted structure.
--
-- No source is claimed for any of the mathematics; अप्रतिलोम is ordinary
-- Sanskrit (प्रतिलोम, inverse/reverse, is LosslessReturn's own word for the
-- ascent), and the compound is built here, 2026-08-22.
------------------------------------------------------------------------

module Apratiloma_TheConservingFlowsAreAMonoidNotAGroupSoNoethersFirstTheoremDoesNotTransfer where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Unit using (Unit ; tt)

------------------------------------------------------------------------
-- १ · The result being confirmed, restated and re-checked here.
------------------------------------------------------------------------

module _ {ℓ ℓ'} {A : Type ℓ} {B : Type ℓ'} (f : A → B) where

  तन्तु : B → Type _
  तन्तु b = Σ[ a ∈ A ] (f a ≡ b)

  संरक्षणम् : (A → A) → Type _
  संरक्षणम् Φ = (a : A) → f (Φ a) ≡ f a

  प्रवाह : Type _
  प्रवाह = Σ[ Φ ∈ (A → A) ] संरक्षणम् Φ

  छेद : प्रवाह → ((a : A) → तन्तु (f a))
  छेद (Φ , c) a = Φ a , c a

  संहति : ((a : A) → तन्तु (f a)) → प्रवाह
  संहति s = (λ a → fst (s a)) , (λ a → snd (s a))

  -- both round trips are refl: η for Σ and Π, no funext, no h-level
  छेद-संहति : (s : (a : A) → तन्तु (f a)) → छेद (संहति s) ≡ s
  छेद-संहति s = refl

  संहति-छेद : (p : प्रवाह) → संहति (छेद p) ≡ p
  संहति-छेद p = refl

  स्वतन्तु : प्रवाह ≃ ((a : A) → तन्तु (f a))
  स्वतन्तु = isoToEquiv (iso छेद संहति छेद-संहति संहति-छेद)

------------------------------------------------------------------------
-- २ · प्रवाह is a MONOID: identity and composition, no inverses claimed.
------------------------------------------------------------------------

module _ {ℓ ℓ'} {A : Type ℓ} {B : Type ℓ'} {f : A → B} where

  एकः : प्रवाह f
  एकः = (λ a → a) , (λ a → refl)

  _∘प्र_ : प्रवाह f → प्रवाह f → प्रवाह f
  (Φ , c) ∘प्र (Ψ , d) = (λ a → Φ (Ψ a)) , (λ a → c (Ψ a) ∙ d a)

------------------------------------------------------------------------
-- ३ · The witness: a conserving flow with no inverse.
------------------------------------------------------------------------

अन्ध : ℕ → Unit          -- the maximally blind observation
अन्ध _ = tt

चूर्ण : ℕ → ℕ            -- collapse everything to zero
चूर्ण _ = zero

चूर्ण-संरक्षति : (n : ℕ) → अन्ध (चूर्ण n) ≡ अन्ध n
चूर्ण-संरक्षति n = refl

-- neither injective nor surjective, no inverse, in no one-parameter family,
-- and yet a full member of the conserving-flow space.
अप्रतिलोमः : प्रवाह अन्ध
अप्रतिलोमः = चूर्ण , चूर्ण-संरक्षति

-- and it is genuinely not the identity: चूर्ण 1 ≡ 0 while (λ a → a) 1 ≡ 1
न-एकः : चूर्ण (suc zero) ≡ zero
न-एकः = refl
