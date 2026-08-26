{-# OPTIONS --cubical --safe --guardedness --no-import-sorts #-}

------------------------------------------------------------------------
-- अनुवृत्ति — where definitional computation stops and propositional
-- computation takes over, for transport along an identification.
--
-- ON THE NAME.  अनुवृत्ति (anuvṛtti) is the Aṣṭādhyāyī's carrying-over: a
-- word stated once in a sūtra continues into the following sūtras, unstated,
-- until it is cancelled — Pāṇini, *Aṣṭādhyāyī* (~500 BCE), throughout;
-- analysed as a device by Patañjali, *Mahābhāṣya* (~150 BCE).  It is used
-- here for the carrying-over of a term along a path at no cost.  WHAT IS NOT
-- CLAIMED: Pāṇini stated no theorem about transport, and the mathematics
-- below originates in cubical type theory (Cohen–Coquand–Huber–Mörtberg, and
-- Voevodsky's univalence), not in the grammatical tradition.  The compound
-- names the phenomenon; it does not assert a source for the theorem.
--
-- WHAT THIS MODULE MEASURES.  `loss/README.md` finding 3 records:
--
--     "transport along `ua` does not reduce on a neutral variable.  It sticks
--      on prim^unglue; it computes only on canonical form.  So uaβ is
--      load-bearing."
--
-- That is a correct observation of a stuck term and a WRONG attribution of
-- the cause, and the difference is the whole content here.  Under Agda 2.8.0
-- with agda/cubical v0.9, `transport (ua e) x ≡ equivFun e x` holds BY refl
-- for an arbitrary equivalence `e : ℕ ≃ ℕ` and an arbitrary `x : ℕ` — both
-- neutral variables, nothing canonical anywhere (§1).  The Glue is
-- transparent.  What is left over in the failing case is not the unglue: it
-- is the residual `transp` in the CODOMAIN, and it is stuck for a reason that
-- has nothing to do with univalence (§2, §3).
--
-- The four things established, each with its witness below:
--
--   §1  Transport along ua reduces definitionally on neutral input, and the
--       cost does NOT accumulate under composition: a two-fold and a
--       three-fold composite of ua's still close by refl.
--   §2  It stops at a NEUTRAL TYPE.  `transp (λ i → A) i0 x` has no reduction
--       rule when A is a type variable, and that single stuck step is the
--       entire cost.  It stays ONE uaβ under composition in the equivalence
--       lane; it becomes one `transportComposite` plus n uaβ's in the path
--       lane; and `uaCompEquiv` identifies the two paths — so the cost is a
--       property of the PRESENTATION of the identification, not of the
--       identification.
--   §3  It also stops at the TOP of a Σ, and there the stuckness is empty:
--       every projection of the stuck term reduces, so `ΣPathP (refl , refl)`
--       closes it and no transport lemma is used.  The transported packet is
--       stuck as a term and free at every observation.  Π does not stop at
--       all, so this is not "η" in general.
--   §4  Consequently the uaβ in `Loss.Carrier` is removable: the same
--       law written monomorphically computes by refl, and a NON-THEOREM
--       records that the module-parameterized form does not.
--   §5  The downstream price, at LosslessReturn's own instance: over an
--       infinite orbit, every READING is refl at every head and costs
--       nothing at any depth; only the demand for the whole packet costs one
--       β, once per head.
--
-- NON-THEOREMS ARE RECORDED AS NON-THEOREMS, in comments with the residual
-- Agda actually reports, the way `Loss.Compute` does.  A statement
-- that fails to hold definitionally is a measurement, not a failure.
--
-- TOOLCHAIN.  Every claim here, positive and negative, is a measurement at
-- Agda 2.8.0 / agda/cubical v0.9.  Reduction behaviour is version-sensitive;
-- the negative claims especially are claims about a checker, not about type
-- theory, and must be re-measured if the compiler moves.
------------------------------------------------------------------------

module Anuvrtti_TheGlueIsTransparentAndTheWholeCostIsTheNeutralTypeNotTheIdentification where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.Transport
open import Cubical.Data.Sigma
open import Cubical.Data.Nat
open import Cubical.Data.Bool

------------------------------------------------------------------------
-- §1  The Glue is transparent.
--
-- Everything in this section is `refl`.  `e` is a variable, `x` is a
-- variable; there is no canonical form on either side.  The claim that
-- transport along ua "computes only on canonical form" is false here.
------------------------------------------------------------------------

अनुवृत्ति-एक : (e : ℕ ≃ ℕ) (x : ℕ) → transport (ua e) x ≡ equivFun e x
अनुवृत्ति-एक e x = refl

-- and with the two endpoints distinct types, so it is not an artefact of
-- ua of an automorphism
अनुवृत्ति-भिन्न : (e : ℕ ≃ Bool) (x : ℕ) → transport (ua e) x ≡ equivFun e x
अनुवृत्ति-भिन्न e x = refl

-- The cost does not accumulate: two identifications, still refl.
अनुवृत्ति-द्वि : (e f : ℕ ≃ ℕ) (x : ℕ)
              → transport (ua e ∙ ua f) x ≡ equivFun f (equivFun e x)
अनुवृत्ति-द्वि e f x = refl

-- Three, still refl.
अनुवृत्ति-त्रि : (e f g : ℕ ≃ ℕ) (x : ℕ)
               → transport (ua e ∙ ua f ∙ ua g) x ≡ equivFun g (equivFun f (equivFun e x))
अनुवृत्ति-त्रि e f g x = refl

-- NON-THEOREM, and it is what makes §1 a statement about Glue rather than
-- about _∙_.  Transport along a composite of ARBITRARY paths does not reduce:
--
--   (A B C : Type) (p : A ≡ B) (q : B ≡ C) (x : A)
--     → transport (p ∙ q) x ≡ transport q (transport p x)
--   ✗  transp (λ i → doubleComp-faces (λ _ → A) q i0 (~ i) _) i0 x != x
--
-- So `_∙_` is opaque to transport in general, and the composites above close
-- by refl anyway.  The propositional statement, uniform in p and q, is:

समासः : {A B C : Type} (p : A ≡ B) (q : B ≡ C) (x : A)
      → transport (p ∙ q) x ≡ transport q (transport p x)
समासः p q x = transportComposite p q x

------------------------------------------------------------------------
-- §2  Where it stops: a neutral type.
--
-- `transp (λ i → A) i0 x` has no reduction rule when A is a type VARIABLE.
-- That one step is the entire cost, and the Glue has already vanished before
-- it is reached.
------------------------------------------------------------------------

-- At a closed data type the constant transport is the identity, definitionally.
स्थिर-ℕ : (x : ℕ) → transport (λ _ → ℕ) x ≡ x
स्थिर-ℕ x = refl

-- NON-THEOREM, at a neutral type, with no ua anywhere in sight:
--
--   {A : Type} (x : A) → transport (λ _ → A) x ≡ x
--   ✗  transp (λ i → A) i0 x != x of type A
--
-- The propositional statement is `transportRefl`.

-- NON-THEOREM, the same obstruction reached THROUGH ua.  Note the residual:
-- the unglue is applied and gone, and what is left is exactly the constant
-- transport at the neutral type above.
--
--   {A : Type} (e : A ≃ A) (x : A) → transport (ua e) x ≡ equivFun e x
--   ✗  transp (λ i → A) i0 (prim^unglue x) != fst e x of type A
--
-- Compare §1: the same statement at A := ℕ is refl.  Instantiating the type
-- removes the cost; the identification was never the cost.

module _ {A : Type} where

  -- One identification: one β.
  मूल्य-एक : (e : A ≃ A) (x : A) → transport (ua e) x ≡ equivFun e x
  मूल्य-एक e x = uaβ e x

  -- Composed in the EQUIVALENCE lane: still one β, whatever the length.
  मूल्य-समास : (e f : A ≃ A) (x : A)
             → transport (ua (compEquiv e f)) x ≡ equivFun f (equivFun e x)
  मूल्य-समास e f x = uaβ (compEquiv e f) x

  -- Composed in the PATH lane: one composite lemma, then one β per factor.
  मूल्य-पथ : (e f : A ≃ A) (x : A)
           → transport (ua e ∙ ua f) x ≡ equivFun f (equivFun e x)
  मूल्य-पथ e f x =
    समासः (ua e) (ua f) x ∙ cong (transport (ua f)) (uaβ e x) ∙ uaβ f _

  -- …and the two are the SAME PATH.  So the difference between one β and
  -- three steps is a difference of presentation, not of identification.
  मूल्य-अभेद : (e f : A ≃ A) → ua (compEquiv e f) ≡ ua e ∙ ua f
  मूल्य-अभेद e f = uaCompEquiv e f

------------------------------------------------------------------------
-- §3  Where it also stops: the top of a Σ — and there the stuckness is empty.
--
-- transp at a Π type produces a λ immediately, so it is never stuck.  transp
-- at a Σ type would have to η-expand a neutral argument, and does not; the
-- term is stuck.  But every ELIMINATION of the stuck term reduces, so the
-- residue is exactly one η-step and no transport lemma is consumed.
------------------------------------------------------------------------

-- NON-THEOREM, with no ua and no non-constant family:
--
--   (x : ℕ × ℕ) → transport (λ _ → ℕ × ℕ) x ≡ x
--   ✗  transp (λ i → ℕ × ℕ) i0 x != x of type Σ ℕ (λ _ → ℕ)
--
-- Contrast स्थिर-ℕ above, which is refl.  Now the eliminations:

क्षेत्र-प्रथम : (x : ℕ × ℕ) → fst (transport (λ _ → ℕ × ℕ) x) ≡ fst x
क्षेत्र-प्रथम x = refl

क्षेत्र-द्वितीय : (x : ℕ × ℕ) → snd (transport (λ _ → ℕ × ℕ) x) ≡ snd x
क्षेत्र-द्वितीय x = refl

-- …so the non-theorem above costs exactly one η-step to repair, and the
-- components are refl.  Nothing is computed here that was not already
-- computed.
क्षेत्र-सन्धि : (x : ℕ × ℕ) → transport (λ _ → ℕ × ℕ) x ≡ x
क्षेत्र-सन्धि x = ΣPathP (refl , refl)

-- The same, uniformly over an ARBITRARY path of types — and here even the
-- top closes by refl, because the right-hand side is a PAIR, and a
-- constructor on one side makes the checker η-expand the stuck term.
क्षेत्र-वितरण : (A : ℕ ≡ ℕ) (x : ℕ × ℕ)
              → transport (λ i → A i × A i) x
              ≡ (transport A (fst x) , transport A (snd x))
क्षेत्र-वितरण A x = refl

-- which locates the Σ stuckness exactly: it appears ONLY when both sides are
-- neutral.  Writing the right-hand side as `(fst x , snd x)` is not an
-- escape — the checker η-contracts that back to `x` and the comparison is
-- neutral-against-neutral again:
--
--   (x : ℕ × ℕ) → transport (λ _ → ℕ × ℕ) x ≡ (fst x , snd x)
--   ✗  transp (λ i → ℕ × ℕ) i0 x != x of type Σ ℕ (λ _ → ℕ)
--
-- So the residue of §3 is not a computation left unperformed.  It is the
-- checker declining to η-expand two neutral terms against each other, and
-- `ΣPathP (refl , refl)` is the instruction to do it.

-- Π does not stop at all — so §3 is not a statement about η in general.
प्रत्यय-स्थिर : (h : ℕ → ℕ) → transport (λ _ → ℕ → ℕ) h ≡ h
प्रत्यय-स्थिर h = refl

प्रत्यय-प्रयोग : (h : ℕ → ℕ) (a : ℕ) → transport (λ _ → ℕ → ℕ) h a ≡ h a
प्रत्यय-प्रयोग h a = refl

------------------------------------------------------------------------
-- §4  The consequence for Loss.Carrier: the uaβ is removable.
--
-- Written monomorphically — the record not a family, the map a top-level
-- definition — the law's transport reduces to `descend` BY refl, on a
-- neutral variable.  `carry-transport-descend` is then not load-bearing; it
-- is `refl`.
------------------------------------------------------------------------

योग-द्वि : ℕ → ℕ
योग-द्वि n = n + n

record वाहकः : Type where
  constructor वह
  field
    मूलम्   : ℕ
    वाहितम् : ℕ
    प्रमाणम् : योग-द्वि मूलम् ≡ वाहितम्
open वाहकः public

अवतरणम् : ℕ → वाहकः
अवतरणम् a = वह a (योग-द्वि a) refl

वाहक-Iso : Iso ℕ वाहकः
वाहक-Iso = iso अवतरणम् मूलम् उत्थान-अवतरण (λ _ → refl)
  where
    उत्थान-अवतरण : (c : वाहकः) → अवतरणम् (मूलम् c) ≡ c
    उत्थान-अवतरण (वह a b w) i = वह a (q i .fst) (q i .snd)
      where q = isContrSingl (योग-द्वि a) .snd (b , w)

वाहक≡ : ℕ ≡ वाहकः
वाहक≡ = ua (isoToEquiv वाहक-Iso)

-- THE POINT.  Neutral variable, univalent transport, closes by refl.
-- LosslessReturn's `carry-transport-descend` at this shape is refl.
अनुवृत्ति-वाहकः : (x : ℕ) → transport वाहक≡ x ≡ अवतरणम् x
अनुवृत्ति-वाहकः x = refl

-- NON-THEOREM, and it is the measurement that locates the cost.  The SAME
-- construction written as a module-parameterized family
--
--   module _ {A B : Type} (f : A → B) where record C … ; P : A ≡ C
--
-- and then INSTANTIATED at A := ℕ, B := ℕ, f := योग-द्वि does NOT reduce:
--
--   (x : ℕ) → transport (P योग-द्वि) x ≡ des योग-द्वि x
--   ✗  hcomp (λ i .o → transp (λ i₁ → ℕ) i
--              (primPOr i0 (i₁ ∨ ~ i₁) (λ .o₁ → prim^unglue x .witness i₁) …))
--        (x + x)  !=  x + x  of type ℕ
--
-- The residue is the WITNESS field: transp over the path family
-- `λ i → f (base i) ≡ carried i` becomes an hcomp whose cap is the neutral
-- path `prim^unglue x .witness`.  Two constructions that differ only by
-- whether the record is a module-parameterized family reduce differently
-- after the parameters are supplied.  I have no derivation of why the
-- parameterization blocks the unfolding, and say so rather than guess: it is
-- a measured fact about Agda 2.8.0, recorded here so it can be re-measured.

------------------------------------------------------------------------
-- §5  What a machine actually pays, at LosslessReturn's own instance.
--
-- Faithful mini-copy of the parameterized law and of the orbit, instantiated
-- at A := ℕ × ℕ, B := ℕ, f := (s , l) ↦ s + l — exactly Loss.Viveka.
-- There the packet-level identity is stuck (§3's Σ-η, reached through the
-- Glue), and the price is one β per head of a corecursive proof.
--
-- Every READING is refl at every head, and refl at every depth.
------------------------------------------------------------------------

module _ {A B : Type} (f : A → B) where

  record Carrier : Type where
    constructor carry
    field
      base    : A
      carried : B
      witness : f base ≡ carried
  open Carrier public

  descend : A → Carrier
  descend a = carry a (f a) refl

  Carrier-Iso : Iso A Carrier
  Carrier-Iso = iso descend base descend-ascend (λ _ → refl)
    where
      descend-ascend : (c : Carrier) → descend (base c) ≡ c
      descend-ascend (carry a b w) i = carry a (q i .fst) (q i .snd)
        where q = isContrSingl (f a) .snd (b , w)

  Carrier≡ : A ≡ Carrier
  Carrier≡ = ua (isoToEquiv Carrier-Iso)

  carry-transport : A → Carrier
  carry-transport a = transport Carrier≡ a

  carry-transport-descend : (a : A) → carry-transport a ≡ descend a
  carry-transport-descend a = uaβ (isoToEquiv Carrier-Iso) a

record Orbit (X : Type) : Type where
  coinductive
  field
    here : X
    next : Orbit X
open Orbit public

unfold : {X : Type} (Φ : X → X) → X → Orbit X
here (unfold Φ x) = x
next (unfold Φ x) = unfold Φ (Φ x)

mapO : {X Y : Type} (h : X → Y) → Orbit X → Orbit Y
here (mapO h o) = h (here o)
next (mapO h o) = mapO h (next o)

record _≈_ {X : Type} (o p : Orbit X) : Type where
  coinductive
  field
    ≈here : here o ≡ here p
    ≈next : next o ≈ next p
open _≈_ public

-- Loss.Viveka, verbatim in shape.
योग : ℕ × ℕ → ℕ
योग x = fst x + snd x

विवेकः : Type
विवेकः = Carrier योग

परिवहनम् : ℕ × ℕ → विवेकः
परिवहनम् = carry-transport योग

अवतरणम्′ : ℕ × ℕ → विवेकः
अवतरणम्′ = descend योग

Φ : ℕ × ℕ → ℕ × ℕ
Φ x = suc (fst x) , suc (snd x)

-- NON-THEOREM, the one Loss.Compute records:
--
--   (x : ℕ × ℕ) → परिवहनम् x ≡ अवतरणम्′ x
--   ✗  transp (λ i → ℕ × ℕ) i0 (prim^unglue x .base) != x
--                                            of type Σ ℕ (λ _ → ℕ)
--
-- and the residual names the cause precisely: the unglue is applied and
-- gone, and what is stuck is §3's constant transport at a Σ, at the `base`
-- field.  Not univalence.  Every reading of the transported packet is refl:

पठनम्-प्रथम : (x : ℕ × ℕ) → fst (base (परिवहनम् x)) ≡ fst x
पठनम्-प्रथम x = refl

पठनम्-द्वितीय : (x : ℕ × ℕ) → snd (base (परिवहनम् x)) ≡ snd x
पठनम्-द्वितीय x = refl

पठनम्-वाहितम् : (x : ℕ × ℕ) → carried (परिवहनम् x) ≡ fst x + snd x
पठनम्-वाहितम् x = refl

-- …so the packet-level identity costs exactly one η-step, as in §3, and no
-- uaβ.  This is a strictly cheaper proof than `carry-transport-descend`.
मूलम्-सन्धिः : (x : ℕ × ℕ) → base (परिवहनम् x) ≡ x
मूलम्-सन्धिः x = ΣPathP (refl , refl)

-- AT INFINITE DEPTH.  The orbit of READINGS closes by refl at every head:
-- corecursive, unbounded, and no β is consumed at any depth.  This is the
-- exact contrast with Loss.Nucleus's `transport-orbit≈`, whose head
-- is `carry-transport-descend` — one β per head, forever.
अनुवृत्ति-जालम् : (x : ℕ × ℕ)
                → mapO carried (mapO परिवहनम् (unfold Φ x))
                ≈ mapO carried (mapO अवतरणम्′ (unfold Φ x))
≈here (अनुवृत्ति-जालम् x) = refl
≈next (अनुवृत्ति-जालम् x) = अनुवृत्ति-जालम् (Φ x)

-- Both base coordinates, likewise, at every depth, by refl.
अनुवृत्ति-जालम्-मूलम् : (x : ℕ × ℕ)
                      → mapO (λ v → fst (base v)) (mapO परिवहनम् (unfold Φ x))
                      ≈ mapO (λ v → fst (base v)) (mapO अवतरणम्′ (unfold Φ x))
≈here (अनुवृत्ति-जालम्-मूलम् x) = refl
≈next (अनुवृत्ति-जालम्-मूलम् x) = अनुवृत्ति-जालम्-मूलम् (Φ x)

-- The packet-level orbit, for the contrast, closing at each head by the
-- η-step of §3 rather than by uaβ — still one head, but a strictly cheaper
-- one, and it uses no univalence lemma at all.
अनुवृत्ति-जालम्-पूर्णम् : (x : ℕ × ℕ)
                        → mapO (λ v → base v) (mapO परिवहनम् (unfold Φ x))
                        ≈ mapO (λ v → base v) (mapO अवतरणम्′ (unfold Φ x))
≈here (अनुवृत्ति-जालम्-पूर्णम् x) = मूलम्-सन्धिः x
≈next (अनुवृत्ति-जालम्-पूर्णम् x) = अनुवृत्ति-जालम्-पूर्णम् (Φ x)

------------------------------------------------------------------------
-- THE ANSWER, stated plainly.
--
-- Transport along an identification does no work.  At a type in canonical
-- form the whole thing — including composites of arbitrarily many ua's —
-- reduces by refl on neutral input, and no β is consumed (§1).  The cost
-- appears at exactly two places, neither of them the identification:
--
--   * a NEUTRAL TYPE, where `transp (λ i → A) i0` has no rule at all.  Cost:
--     one uaβ, and it does not grow with the number of equivalences composed
--     provided they are composed as equivalences (§2).
--   * the TOP OF A RECORD, where the cost is one η-step and every projection
--     is already refl (§3).
--
-- Both vanish on instantiation, and the second is free even before it
-- vanishes.  A machine that reads its transported data pays nothing at any
-- depth (§5); a machine that demands the transported packet back as a whole
-- pays one η-step per demand, and one uaβ per demand only if it is working
-- under an abstract type it has not yet instantiated.  The cost is charged
-- per identification DEMANDED, never per step travelled.
------------------------------------------------------------------------
