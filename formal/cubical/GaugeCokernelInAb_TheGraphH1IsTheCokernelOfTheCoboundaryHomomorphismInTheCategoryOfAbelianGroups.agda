{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- The graph H1 is the cokernel of the coboundary IN Ab, and that is what
-- discharges the hand-written gauge descent lemma
--
-- cf-tessera-z-1, 2026-08-20.
--
-- PROVENANCE.  Category theory, not Indian material; per CLAUDE.md's
-- file-naming note 2 no Sanskrit label is invented.  Cokernels and abelian
-- categories: Mac Lane 1950, Buchsbaum 1955, Grothendieck Tohoku 1957,
-- Freyd 1964.  The graph cochain complex is Kirchhoff 1845/1847 and
-- Poincare 1895; the substrate is the cubical library v0.5.
--
-- WHAT THIS ADDS, AND WHAT IT DOES NOT, because two agents reached this
-- object within the hour and the difference has to be stated exactly:
--
--   cf-tessera-z-0, commit 2c68cd04 (13:20 UTC, message 2196), landed
--   CokernelUniversalProperty_TheHandRolledGraphH1IsACokernelAndItsGauge
--   RelationIsNotPropValued.agda.  It proves the universal property of
--   FiniteGraphCohomology's H1 directly, by hand, and its own header says
--   what it does NOT do: "No group structure is put on the hand-rolled H1
--   here, so this is the universal property in the category of SETS under
--   C1, instantiated at abelian-group targets -- NOT a proof that H1 is the
--   cokernel in Ab."  That sentence is the gap this module closes.
--
--   z-0 also owns the refutation that GaugeStep is not prop-valued, with a
--   guard I did not have (with Vertex EMPTY the relation IS prop-valued, so
--   the negative is not vacuous).  I reached the same non-identity
--   independently and later; it is z-0's, cited, not restated here.
--
--   What is here instead: delta-0 is a HOMOMORPHISM of abelian groups
--   (delta-Hom below); its cokernel is taken in AbGroupCategory using the
--   PreAbCategory instance in AbIsPreabelian_TheCategoryOfAbelianGroupsIsA
--   PreAbCategoryNotJustACategory; H1 is proved isomorphic to that
--   cokernel's carrier; and descendedEvaluation is proved equal to the map
--   IsCokernel.univ produces.  So the universal property is not re-proved
--   by hand for this one quotient -- it is INSTANTIATED from the categorical
--   record, which is what message 2191's blocker 3 asked for.
--
-- Nothing in NaturalMachine/FiniteGraphCohomology.agda is modified.
------------------------------------------------------------------------

module GaugeCokernelInAb_TheGraphH1IsTheCokernelOfTheCoboundaryHomomorphismInTheCategoryOfAbelianGroups where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Foundations.HLevels using (isSetΠ)
open import Cubical.Foundations.Isomorphism using (Iso ; iso)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool
  using (Bool ; false ; true ; _⊕_ ; ⊕-assoc ; ⊕-comm ; ⊕-identityʳ
        ; ⊕-invol ; isSetBool)

open import Cubical.HITs.SetQuotients as SQ using ([_] ; eq/ ; squash/)
open import Cubical.HITs.PropositionalTruncation as PT using (∣_∣₁)

open import Cubical.Algebra.Group.Base
open import Cubical.Algebra.Group.Morphisms
open import Cubical.Algebra.Group.MorphismProperties
open import Cubical.Algebra.Group.Subgroup
open import Cubical.Algebra.Group.QuotientGroup
open import Cubical.Algebra.AbGroup.Base

open import Cubical.Categories.Abelian.Base

open import AbIsPreabelian_TheCategoryOfAbelianGroupsIsAPreAbCategoryNotJustACategory
open import NaturalMachine.FiniteGraphCohomology

------------------------------------------------------------------------
-- 1.  Z/2 and the pointwise cochain groups.
------------------------------------------------------------------------

⊕-invR : (b : Bool) → b ⊕ b ≡ false
⊕-invR false = refl
⊕-invR true  = refl

-- Middle-four interchange, from associativity and commutativity of ⊕ only.
⊕-inter : (a b c d : Bool) → (a ⊕ b) ⊕ (c ⊕ d) ≡ (a ⊕ c) ⊕ (b ⊕ d)
⊕-inter a b c d =
    sym (⊕-assoc a b (c ⊕ d))
  ∙ cong (a ⊕_) ( ⊕-assoc b c d
                ∙ cong (_⊕ d) (⊕-comm b c)
                ∙ sym (⊕-assoc c b d) )
  ∙ ⊕-assoc a c (b ⊕ d)

BoolAb : AbGroup ℓ-zero
BoolAb = makeAbGroup false _⊕_ (λ b → b) isSetBool
           ⊕-assoc ⊕-identityʳ ⊕-invR ⊕-comm

-- NOTE, and this cost 25 minutes of wall clock to find: the {G} of
-- makeAbGroup is a module parameter and is NOT determined by the expected
-- type AbGroup ℓ-zero (which is a Σ), so writing `makeAbGroup (λ _ → false)
-- …` leaves the carrier an unsolved meta, blocks every constraint about δ⁰
-- downstream, and the module does not fail fast -- it spins.  Naming the
-- carrier explicitly is the whole fix.
FunAb : (A : Type₀) → AbGroup ℓ-zero
FunAb A = makeAbGroup {G = A → Bool} (λ _ → false) (λ f g a → f a ⊕ g a) (λ f → f)
            (isSetΠ (λ _ → isSetBool))
            (λ f g h → funExt λ a → ⊕-assoc (f a) (g a) (h a))
            (λ f → funExt λ a → ⊕-identityʳ (f a))
            (λ f → funExt λ a → ⊕-invR (f a))
            (λ f g → funExt λ a → ⊕-comm (f a) (g a))

------------------------------------------------------------------------
-- 2.  The graph, its coboundary homomorphism, and its cokernel in Ab.
------------------------------------------------------------------------

module Payoff (Vertex Edge : Type₀) (source target : Edge → Vertex) where
  open Graph Vertex Edge source target

  C⁰Ab C¹Ab : AbGroup ℓ-zero
  C⁰Ab = FunAb Vertex
  C¹Ab = FunAb Edge

  δHom : AbGroupHom C⁰Ab C¹Ab
  δHom = δ⁰ , makeIsGroupHom λ g h → funExt λ e →
    ⊕-inter (g (source e)) (h (source e)) (g (target e)) (h (target e))

  -- SECOND performance trap, same shape as the first and worse: CokAb, ImN,
  -- cokHom and AbCokernel all take {x y : AbGroup ℓ} implicitly, and those
  -- are NOT inferable from the type of δHom, because AbGroupHom x y unfolds
  -- to GroupHom (AbGroup→Group x) (AbGroup→Group y) and AbGroup→Group is not
  -- invertible for unification.  Left implicit they stay metas and the
  -- module spins rather than failing.  Every call site below names them.
  CokOfδ : Cokernel (AbPreadd {ℓ-zero}) {x = C⁰Ab} {y = C¹Ab} δHom
  CokOfδ = AbCokernel {x = C⁰Ab} {y = C¹Ab} δHom

  Cok : AbGroup ℓ-zero
  Cok = Cokernel.c CokOfδ

  cok : AbGroupHom C¹Ab Cok
  cok = Cokernel.coker CokOfδ

  -- The two quotients agree.  Note which direction needs the truncation:
  -- GaugeStep carries the gauge as data, so toCok can hand it over; the
  -- image relation is truncated, so fromCok must PT.rec, legal only because
  -- the target [x] ≡ [y] is a proposition.  (That asymmetry is the
  -- constructive content of cf-tessera-z-0's non-prop-valuedness result.)
  toCok : H¹ → ⟨ Cok ⟩
  toCok = SQ.rec squash/ [_] resp
    where
    resp : (a b : C¹) → GaugeStep a b → Path ⟨ Cok ⟩ [ a ] [ b ]
    resp a b (g , p) = eq/ a b ∣ g , funExt (λ e →
        sym (⊕-invol (a e) (δ⁰ g e)) ∙ cong (a e ⊕_) (p e)) ∣₁

  fromCok : ⟨ Cok ⟩ → H¹
  fromCok = SQ.rec squash/ classOf resp
    where
    resp : (a b : C¹)
         → _~_ (AbGroup→Group C¹Ab)
               (fst (ImN {x = C⁰Ab} {y = C¹Ab} δHom))
               (snd (ImN {x = C⁰Ab} {y = C¹Ab} δHom)) a b
         → classOf a ≡ classOf b
    resp a b = PT.rec (squash/ _ _) λ gp → eq/ a b (fst gp , λ e →
        cong (a e ⊕_) (funExt⁻ (snd gp) e) ∙ ⊕-invol (a e) (b e))

  H¹Iso : Iso H¹ ⟨ Cok ⟩
  H¹Iso = iso toCok fromCok
    (SQ.elimProp (λ _ → squash/ _ _) λ _ → refl)
    (SQ.elimProp (λ _ → squash/ _ _) λ _ → refl)

------------------------------------------------------------------------
-- 3.  The descent lemma, instantiated from IsCokernel.univ.
------------------------------------------------------------------------

  -- A CycleEvaluation is exactly a homomorphism C¹ → Z/2 killing δ⁰.
  evalHom : CycleEvaluation → AbGroupHom C¹Ab BoolAb
  evalHom cy = evaluate cy , makeIsGroupHom (additive cy)

  -- The ONLY field of CycleEvaluation used past making evalHom a
  -- homomorphism.  gaugeInvariant and respectsGauge, the two lemmas the
  -- source module proves by hand, are never mentioned.
  cokUniv : (cy : CycleEvaluation)
    → ∃![ u ∈ AbGroupHom Cok BoolAb ] (compGroupHom cok u ≡ evalHom cy)
  cokUniv cy =
    IsCokernel.univ (Cokernel.isCoker CokOfδ) BoolAb (evalHom cy)
      (GroupHom≡ (funExt λ g → closed cy g))

  descentByCokernel : CycleEvaluation → H¹ → Bool
  descentByCokernel cy h = fst (fst (fst (cokUniv cy))) (toCok h)

  descentIsTheCokernel : (cy : CycleEvaluation) (h : H¹)
    → descendedEvaluation cy h ≡ descentByCokernel cy h
  descentIsTheCokernel cy =
    SQ.elimProp (λ _ → isSetBool _ _)
      λ a → sym (funExt⁻ (cong fst (snd (fst (cokUniv cy)))) a)

  descentIsUnique : (cy : CycleEvaluation) (u v : AbGroupHom Cok BoolAb)
    → compGroupHom cok u ≡ evalHom cy
    → compGroupHom cok v ≡ evalHom cy
    → u ≡ v
  descentIsUnique cy u v pu pv =
    cong fst (sym (snd (cokUniv cy) (u , pu)) ∙ snd (cokUniv cy) (v , pv))

------------------------------------------------------------------------
-- 4.  A refutation of my own, recorded so the over-claim does not travel.
--
--  Before writing section 3 I claimed that routing descendedEvaluation
--  through the cokernel would buy it ADDITIVITY for free, on the grounds
--  that H1 is a bare Type₀ in the source module with no additive structure
--  and no statement that descendedEvaluation respects any.  False.
--  `evalHom` cannot be formed without `additive cy`, which is already a
--  field of CycleEvaluation; the cokernel CONSUMES that hypothesis, it does
--  not produce it.  What the cokernel actually buys is exactly two things:
--  the well-definedness obligation collapsing from respectsGauge (a
--  condition quantified over pairs of cochains and gauge steps) to the
--  single equation δ⁰ ⋆ eval ≡ 0h, and uniqueness.
--
--  HOW THIS COULD BE TRUE AND IRRELEVANT.  Section 3 is the only place in
--  formal/cubical/ where the PreAbCategory instance is spent, and it is
--  spent on one quotient over F2 -- where -x ≡ x, so the GaugeStep/coset
--  translation costs one ⊕-invol in each direction.  Over a general abelian
--  group the same argument carries an inverse and is not this short.
--  Nothing here computes H1 for any graph, and nothing here reaches β₁.
--  If no downstream consumer ever needs a second map out of H1, the
--  uniqueness half is decoration -- the same limit cf-tessera-z-0 states.
------------------------------------------------------------------------
