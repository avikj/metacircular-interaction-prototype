{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सङ्क्रमणम् — कदा तन्तुः एका एव कक्ष्या ।
--
-- (when is the fibre exhausted by one orbit — the converse of descent.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS, and it is a CORRECTION before it is an addition.
--
-- `SamanaKaksya_…agda` §६ ("शेषः") says, of its descended charge
-- `अवतीर्णः : A / समानकक्ष्या Φ → B`:
--
--     "The converse of §४ — that `अवतीर्णः` is injective, i.e. equal
--      charge implies one orbit — is `Kaksya` §७'s `सङ्क्रमणम्` and is a
--      genuine hypothesis about the flow, not a missing definition."
--
-- and its WHAT-IS-NOT-CLAIMED fence says the same: "that it is
-- INJECTIVE … is exactly the transitivity hypothesis `सङ्क्रमणम्` of
-- `Kaksya` §७".
--
-- **That sentence is FALSE, in the direction it is used.**  `Kaksya`
-- §७'s `सङ्क्रमणम् b` is ONE-SIDED reachability — `Σ[ n ] Φⁿ x ≡ y` for
-- every ordered pair in the fibre — and `समानकक्ष्या` is the TWO-SIDED
-- meeting relation.  One-sided is SUFFICIENT for injectivity (§३, via
-- §१) and is NOT necessary: §६ exhibits `f = λ _ → tt : Bool → Unit`
-- with `Φ = λ _ → true`, where `अवतीर्णः` is injective (indeed an
-- equivalence, the fibre being one orbit in the meeting sense) while
-- `सङ्क्रमणम् tt` is refuted outright — nothing reaches `false`.
--
-- The hypothesis that IS equivalent to injectivity is named here:
--
--     उभय-सङ्क्रमणम् b  :=  (x y : fiber f b) → ∥ समानकक्ष्या Φ x.fst y.fst ∥₁
--
-- two-sided, and propositionally truncated.  Both amendments are
-- forced, and by the same fact: `[ a ] ≡ [ b ]` in a set quotient
-- recovers the relation only up to `∥_∥₁` (`isEquivRel→TruncIso`), and
-- `समानकक्ष्या` is NOT prop-valued — the meeting stations are data,
-- which is exactly the openness `SamanaKaksya` §६ flagged in its last
-- paragraph.  So the truncation is not a technicality bolted on; it is
-- the same observation, arriving as the reason the naive converse
-- cannot hold.
--
-- With the hypothesis corrected, both directions go through (§३, §४),
-- and then the theorem worth having (§५):
--
--     **`अवतीर्णः` is an equivalence  ⟺  `f` is surjective and the flow
--       is fibrewise transitive.**
--
-- Stated as an equivalence of PROPOSITIONS, not a pair of implications.
-- That is the precise sense in which "the observable IS the quotient":
-- the level sets of `f` are exactly the gauge orbits, with nothing left
-- over (injectivity) and nothing missing (surjectivity).
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.
--
-- **Not Noether.**  Every fence in `Dhruva`'s header stands unchanged:
-- no Lagrangian, no variation, no action, no continuity.  `Φ` is a bare
-- endomorphism throughout — no inverse is used anywhere below, and §६'s
-- counterexample flow is not invertible.
--
-- **Nothing here says the two-sided hypothesis is CHEAP.**  It is a real
-- hypothesis about the flow; §६ only shows it is strictly weaker than
-- the one-sided one, not that it is free.
--
-- **§६ refutes a hypothesis, not a theorem.**  `Kaksya` §७ proves that
-- `सङ्क्रमणम् b` implies no invariant separates the fibre; that theorem
-- is untouched and true.  What is refuted is `SamanaKaksya` §६'s claim
-- that `सङ्क्रमणम्` is *the* content of injectivity.
--
-- **No claim about the untruncated relation.**  Whether `[ a ] ≡ [ b ]`
-- yields `समानकक्ष्या` itself (rather than its truncation) is not
-- addressed and is false in general for relations carrying data.
--
-- TERMS.  सङ्क्रमणम् — "passing over, transition"; in jyotiṣa the sun's
-- saṃkrānti, its passage from one rāśi into the next (standard in the
-- siddhāntic tradition following the Āryabhaṭīya, 499); in Jaina karma
-- theory, saṃkrama, the transition of one karma-prakṛti into another
-- (Ṣaṭkhaṇḍāgama with Vīrasena's Dhavalā, ~816).  LIMIT: neither sense
-- is a claim about endomorphisms of a type; the use of the word for
-- "the flow carries one point of a fibre to another" is `Kaksya_…agda`'s
-- and is carried in unchanged from there.  उभय — "both, two-sided",
-- ordinary Sanskrit; the compound उभय-सङ्क्रमणम् is BUILT HERE and no
-- text is claimed for it.  कक्ष्या — orbit, as in `Kaksya_…agda`, with
-- its limit unchanged (attested for a planet's orbit; its use for the
-- orbit of an endomorphism is this corpus's).  NO SOURCE STATES ANYTHING
-- BELOW.
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5 — the container, NOT the
-- repository pin (2.8.0 + v0.9).  --cubical --safe, no postulates, no
-- holes, exit 0.
------------------------------------------------------------------------

module Sankramana_TheFibreIsOneOrbitExactlyWhenTheChargeIsInjectiveAndOneSidedReachabilityIsStrictlyStronger where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso)
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Equiv
  using (isEquiv ; isPropIsEquiv ; invEq ; secEq ; retEq ; _≃_ ; fiber
        ; propBiimpl→Equiv)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Binary.Base using (module BinaryRelation)
open import Cubical.HITs.SetQuotients using (_/_ ; [_] ; eq/ ; squash/ ; elimProp)
open import Cubical.HITs.PropositionalTruncation as PT using (∥_∥₁ ; ∣_∣₁)
open import Cubical.Functions.Surjection
  using (isSurjection ; isPropIsSurjection ; isEmbedding×isSurjection→isEquiv)
open import Cubical.Functions.Embedding using (injEmbedding)

open BinaryRelation

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry
  using (संरक्षणम्)
open import Kaksya_TheChargeIsConstantAlongTheWholeOrbitAndNotOnlyAcrossOneStep
  using (कक्ष्या ; ध्रुवं-कक्ष्यायाम् ; सङ्क्रमणम्)
open import SamanaKaksya_TheOrbitRelationIsAlreadyAnEquivalenceWithoutAnInverseAndTheChargeDescendsToTheQuotient
  using (समानकक्ष्या ; समान-स्व ; समान-व्यत्ययः ; समान-संक्रमः
        ; भागः ; अवतीर्णः)

private variable ℓ : Level

------------------------------------------------------------------------
-- १ · समता-प्रमाणम् — the orbit relation packaged as `isEquivRel`, and
--     the truncated characterisation of paths in the quotient.
--
-- `SamanaKaksya` §२ proves the three laws separately.  The library's
-- effectivity result wants them in one record, and `isEquivRel→TruncIso`
-- then gives, for a relation that need NOT be prop-valued:
--
--     [ a ] ≡ [ b ]   ≅   ∥ समानकक्ष्या Φ a b ∥₁
--
-- This is where the truncation in §२'s hypothesis comes from.  It is
-- not a choice.
------------------------------------------------------------------------

module _ {A : Type ℓ} (Φ : A → A) where

  समान-प्रमाणम् : isEquivRel (समानकक्ष्या Φ)
  समान-प्रमाणम् = equivRel (समान-स्व Φ) (समान-व्यत्ययः Φ) (समान-संक्रमः Φ)

  -- [ a ] ≡ [ b ]  ⟶  ∥ a ≈ b ∥₁ .  The library's `isEquivRel→TruncIso`
  -- is stated for `_/_` with the relation implicit; we name only the
  -- direction we use.
  पथात्-समता : (a b : A) → [ a ] ≡ [ b ] → ∥ समानकक्ष्या Φ a b ∥₁
  पथात्-समता a b =
    Iso.fun (Cubical.HITs.SetQuotients.isEquivRel→TruncIso समान-प्रमाणम् a b)

------------------------------------------------------------------------
-- २ · उभय-सङ्क्रमणम् — THE CORRECTED HYPOTHESIS: the flow is transitive
--     on the fibre in the TWO-SIDED, truncated sense.
--
-- Compare `Kaksya` §७:
--
--     सङ्क्रमणम् b = (x y : fiber f b) → Σ[ n ∈ ℕ ] Φⁿ (fst x) ≡ fst y
--
-- — ordered, untruncated, and carrying the number of steps as data.
-- Below is the same sentence with "reaches" replaced by "meets" and the
-- witness forgotten.  §६ shows the two are NOT equivalent.
------------------------------------------------------------------------

module _ {A B : Type ℓ} (f : A → B) (Φ : A → A) where

  उभय-सङ्क्रमणम् : B → Type ℓ
  उभय-सङ्क्रमणम् b = (x y : fiber f b) → ∥ समानकक्ष्या Φ (fst x) (fst y) ∥₁

  -- it is a proposition, which is why §५ can be an equivalence rather
  -- than a pair of implications
  उभय-सङ्क्रमणम्-प्रमाणम् : (b : B) → isProp (उभय-सङ्क्रमणम् b)
  उभय-सङ्क्रमणम्-प्रमाणम् b = isPropΠ2 λ _ _ → PT.isPropPropTrunc

  -- ONE-SIDED IMPLIES TWO-SIDED.  Stay put on the right, forget the
  -- step count.  (The converse is refuted in §६.)
  एकपार्श्वात्-उभयम् : (b : B) → सङ्क्रमणम् f Φ b → उभय-सङ्क्रमणम् b
  एकपार्श्वात्-उभयम् b tr x y = ∣ fst (tr x y) , zero , snd (tr x y) ∣₁

------------------------------------------------------------------------
-- ३ · तन्तुः एका कक्ष्या इति अवतीर्णस्य एकत्वम् — TRANSITIVITY IMPLIES
--     THE DESCENDED CHARGE IS INJECTIVE.
--
-- Equal charge ⇒ one orbit ⇒ one class.  The proof is `elimProp` twice,
-- legitimate because a path in a set quotient is a proposition, and
-- then `eq/` under the truncation, legitimate for the same reason.
--
-- Note `अवतीर्णः [ a ] ≡ f a` holds on the nose (`SamanaKaksya` §४), so
-- the hypothesis `p` below IS `f a ≡ f b` with no coercion.
------------------------------------------------------------------------

module _ {A B : Type ℓ} (f : A → B) (Φ : A → A)
         (setB : isSet B) (cons : संरक्षणम् f Φ) where

  private
    f̄ : भागः f Φ setB cons → B
    f̄ = अवतीर्णः f Φ setB cons

  एकत्वम् : Type ℓ
  एकत्वम् = (q q' : भागः f Φ setB cons) → f̄ q ≡ f̄ q' → q ≡ q'

  एकत्वम्-प्रमाणम् : isProp एकत्वम्
  एकत्वम्-प्रमाणम् = isPropΠ3 λ q q' _ → squash/ q q'

  -- ⟸ : the fibre is one orbit, so the charge separates classes
  सङ्क्रमणात्-एकत्वम् : ((b : B) → उभय-सङ्क्रमणम् f Φ b) → एकत्वम्
  सङ्क्रमणात्-एकत्वम् tr =
    elimProp (λ q → isPropΠ2 λ q' _ → squash/ q q')
      (λ a → elimProp (λ q' → isPropΠ λ _ → squash/ [ a ] q')
        (λ b p → PT.rec (squash/ [ a ] [ b ]) (eq/ a b)
                   (tr (f a) (a , refl) (b , sym p))))

------------------------------------------------------------------------
-- ४ · व्यत्ययः — AND THE CONVERSE.  Injectivity implies the corrected
--     transitivity, and this is the direction that forces the two
--     amendments: `[ a ] ≡ [ b ]` gives back only `∥ a ≈ b ∥₁`, and `≈`
--     is the meeting relation, not reachability.
------------------------------------------------------------------------

  एकत्वात्-सङ्क्रमणम् : एकत्वम् → (b : B) → उभय-सङ्क्रमणम् f Φ b
  एकत्वात्-सङ्क्रमणम् inj b (x , px) (y , py) =
    पथात्-समता Φ x y (inj [ x ] [ y ] (px ∙ sym py))

------------------------------------------------------------------------
-- ५ · अवतीर्णः समता — THE THEOREM.  The observable IS the quotient
--     exactly when it is onto and its level sets are single orbits.
--
--     isEquiv अवतीर्णः  ≃  isSurjection f × (fibrewise transitivity)
--
-- Both sides are propositions, so this is an equivalence of types and
-- not merely a pair of implications — `propBiimpl→Equiv`.
--
-- Read at the physics: the gauge-invariant observable is a faithful
-- coordinate on the space of physical states precisely when (a) every
-- value is attained and (b) the gauge flow already identifies
-- everything the observable cannot separate.  (b) failing is a residual
-- charge; (a) failing is a value with no state.  No Lagrangian occurs.
------------------------------------------------------------------------

  private
    लङ्घनम् : isEquiv f̄ → isSurjection f
    लङ्घनम् e b =
      elimProp {P = λ q → f̄ q ≡ b → ∥ fiber f b ∥₁}
        (λ _ → isPropΠ λ _ → PT.isPropPropTrunc)
        (λ a p → ∣ a , p ∣₁)
        (invEq (f̄ , e) b)
        (secEq (f̄ , e) b)

    सर्वत्र : isSurjection f → isSurjection f̄
    सर्वत्र s b = PT.map (λ { (a , p) → [ a ] , p }) (s b)

  अवतीर्णः-समता :
    isEquiv f̄ ≃ (isSurjection f × ((b : B) → उभय-सङ्क्रमणम् f Φ b))
  अवतीर्णः-समता =
    propBiimpl→Equiv
      (isPropIsEquiv f̄)
      (isProp× isPropIsSurjection (isPropΠ (उभय-सङ्क्रमणम्-प्रमाणम् f Φ)))
      (λ e → लङ्घनम् e
           , एकत्वात्-सङ्क्रमणम्
               (λ q q' p → sym (retEq (f̄ , e) q) ∙ cong (invEq (f̄ , e)) p
                           ∙ retEq (f̄ , e) q'))
      (λ { (s , tr) →
             isEmbedding×isSurjection→isEquiv
               ( injEmbedding setB (λ {q} {q'} p → सङ्क्रमणात्-एकत्वम् tr q q' p)
               , सर्वत्र s ) })

------------------------------------------------------------------------
-- ६ · एकपार्श्वं गुरुतरम् — ONE-SIDED REACHABILITY IS STRICTLY STRONGER,
--     AND THIS IS THE CORRECTION.
--
-- Two points, one collapsing flow, and the whole gap in four lines.
--
--     A = Bool,  B = Unit,  f = λ _ → tt,  Φ = λ _ → true.
--
-- Conservation is `refl`.  The single fibre is all of `Bool`.
--
--   · TWO-SIDED holds: both trajectories are at `true` after one step,
--     so any two points meet at stations `(1 , 1)`.  Hence by §५ the
--     descended charge `Bool / समानकक्ष्या Φ → Unit` is an equivalence:
--     the fibre IS one orbit in the only sense the quotient can see.
--
--   · ONE-SIDED FAILS: `Φⁿ true ≡ true` for every `n`, so `false` is
--     reachable from nothing.  `सङ्क्रमणम् tt` is refuted outright.
--
-- Therefore `SamanaKaksya` §६'s "is exactly `Kaksya` §७'s `सङ्क्रमणम्`"
-- is false as an identification, and §२–§५ above give the hypothesis
-- that is exact.  The flow here is not invertible, and that is not
-- incidental: it is what lets a point be departed from and never
-- returned to.
------------------------------------------------------------------------

private

  Φ₀ : Bool → Bool
  Φ₀ _ = true

  f₀ : Bool → Unit
  f₀ _ = tt

  cons₀ : संरक्षणम् f₀ Φ₀
  cons₀ _ = refl

  -- every station of every trajectory is `true` from step one on
  स्थिरम् : (n : ℕ) (a : Bool) → कक्ष्या f₀ Φ₀ (suc n) a ≡ true
  स्थिरम् n a = refl

  -- TWO-SIDED: any two points of the single fibre meet at (1 , 1)
  उभयम्-अस्ति : (b : Unit) → उभय-सङ्क्रमणम् f₀ Φ₀ b
  उभयम्-अस्ति b x y = ∣ suc zero , suc zero , refl ∣₁

  -- and hence the descended charge is an equivalence
  अवतीर्णः-समता₀ : isEquiv (अवतीर्णः f₀ Φ₀ isSetUnit cons₀)
  अवतीर्णः-समता₀ =
    invEq (अवतीर्णः-समता f₀ Φ₀ isSetUnit cons₀)
      ( (λ b → ∣ true , refl ∣₁) , उभयम्-अस्ति )

  -- ONE-SIDED: refuted.  `false` is reachable from `true` at no station.
  एकपार्श्वं-नास्ति : सङ्क्रमणम् f₀ Φ₀ tt → ⊥
  एकपार्श्वं-नास्ति tr with tr (true , refl) (false , refl)
  ... | zero  , p = true≢false p
  ... | suc n , p = true≢false (sym (स्थिरम् n true) ∙ p)

------------------------------------------------------------------------
-- ७ · शेषः — what stays open.
--
-- **The truncation is not shown to be necessary.**  §४ produces
-- `∥ a ≈ b ∥₁` because that is all `isEquivRel→TruncIso` gives.  Whether
-- some flow makes the untruncated statement fail — two points whose
-- classes agree but with no CHOSEN pair of meeting stations — is not
-- settled here.  `SamanaKaksya` §६'s last paragraph is the same
-- question and it is still open.
--
-- **Sufficient conditions are not surveyed.**  §५ reduces "the fibre is
-- one orbit" to a checkable hypothesis but does not exhibit a family of
-- flows satisfying it beyond §६'s collapse and the one-sided case.  The
-- torsor of `YogaDhruva_…agda` is the natural next instance: a free
-- transitive action gives one-sided reachability by construction, hence
-- §२'s implication, hence §३.  Whether it gives it with `Φ` a single
-- endomorphism — rather than a whole group — is the actual question,
-- and iterating ONE translation on a torsor is a cyclic-subgroup
-- condition, not a torsor condition.  Not addressed.
--
-- **Nothing here is about the h-level of `A`.**  `A` is never assumed to
-- be a set; `isSet B` is used only where `SamanaKaksya` §४ used it, plus
-- once in `injEmbedding`.
------------------------------------------------------------------------
