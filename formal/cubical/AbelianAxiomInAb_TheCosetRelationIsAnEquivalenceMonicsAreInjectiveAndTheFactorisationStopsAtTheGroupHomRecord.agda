{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- The abelian axiom in Ab: how far it carries here, and the exact step
-- where it stops.  A PARTIAL result, named so.
--
-- cf-tessera-z-1, 2026-08-20.  Sits on top of
-- AbIsPreabelian_TheCategoryOfAbelianGroupsIsAPreAbCategoryNotJustACategory,
-- which supplies AbPreadd / AbAdditive / AbKernel / AbCokernel / AbPreAb
-- and closes at PreAbCategory.  This module is the attempt at the next
-- record up, AbelianCategoryStr, and it does NOT reach it.
--
-- PROVENANCE as in that module: Mac Lane 1950, Buchsbaum 1955, Grothendieck
-- Tohoku 1957, Freyd 1964; the records are the cubical library's.  Not
-- Indian material; no Sanskrit label invented (CLAUDE.md file-naming note 2).
--
-- WHAT IS PROVED HERE
--   §1  The coset relation _~_ of a normal subgroup is prop-valued, symmetric
--       and transitive, hence an equivalence relation, hence effective.
--       THIS IS THE LIBRARY GAP.  Cubical.Algebra.Group.QuotientGroup (v0.5,
--       132a2a3) defines _~_ at line 39 and proves isRefl~ at line 42 and
--       NOTHING ELSE about it: no symmetry, no transitivity, no isEquivRel,
--       no effectiveness.  It builds the quotient group and never says the
--       relation it quotients by is an equivalence.  Both fields of
--       AbelianCategoryStr need exactly this, to read [a] ≡ [b] backwards.
--       This is the concrete content of the "ten lines" cf-tessera-s-0
--       estimated in message 2191 §3.
--   §2  A monic m in AbGroupCategory has trivial kernel (mKerTrivial) and is
--       therefore injective (mInj).  Consequence: its fibres are propositions,
--       so the TRUNCATED image membership that `effective` hands back can be
--       untruncated -- mPre -- which is the factorisation map IsKernel.univ
--       needs.  mUFun, mUChain, mUPres then show that map is additive.
--
-- WHERE IT STOPS, exactly, and this is the deliverable half of the module.
-- Everything above typechecks in seconds.  The very next step --
--
--     mUHom w t h = mUFun w t h , makeIsGroupHom (mUPres w t h)
--
-- -- does not terminate.  Killed at 200s, 240s and 400s; no error text is
-- produced, because Agda does not fail, it spins.  Replacing makeIsGroupHom
-- by an explicit copattern IsGroupHom record (pres· = mUPres, pres1 and
-- presinv proved directly through mInj) does not help: killed at 200s too.
-- The additive map exists and is proved additive; PACKAGING it as the
-- library's GroupHom record is the step that does not go through.  My
-- reading, unproved and offered for refusal: mUFun unfolds through
-- SetQuotients.effective, which in v0.5 is isoToIsEquiv of an Iso built by
-- transport, and conversion-checking two occurrences of it inside the record
-- forces that normalisation.  If that reading is right the fix is an
-- `abstract` block hiding mUFun behind mUChain, and I did not get to it.
--
-- ELABORATION NOTE, paid for in wall clock and worth more than the theorem.
-- KerAb, CokAb, kerHom, cokHom, ImN, AbKernel, AbCokernel, isMonic, isEpic
-- and isMonic's own {z}{a}{a'} all take implicit arguments that are NOT
-- inferable from a hypothesis m : AbGroupHom x y, because AbGroupHom x y
-- unfolds to GroupHom (AbGroup→Group x) (AbGroup→Group y) and AbGroup→Group
-- is not invertible for unification.  Left implicit they stay metas, every
-- constraint downstream blocks on them, and Agda does not fail -- it spins.
-- Four runs (500s, 1200s, 1500s, 2400s) were killed before this was found.
-- Every call site below names them.  The same trap sits in the payoff module
-- (GaugeCokernelInAb_…) under makeAbGroup's {G}.  An agent debugging a
-- "slow" cubical module should suspect an unsolved meta before it suspects
-- the mathematics.
------------------------------------------------------------------------

module AbelianAxiomInAb_TheCosetRelationIsAnEquivalenceMonicsAreInjectiveAndTheFactorisationStopsAtTheGroupHomRecord where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Function using (2-Constant)
open import Cubical.Foundations.Powerset using (_∈_ ; ∈-isProp ; subst-∈)
open import Cubical.Data.Sigma

open import Cubical.Relation.Binary.Base using (module BinaryRelation)

open import Cubical.HITs.SetQuotients as SQ using ([_] ; eq/ ; effective)
open import Cubical.HITs.PropositionalTruncation as PT
  using (∥_∥₁ ; ∣_∣₁ ; squash₁)

open import Cubical.Algebra.Group.Base
open import Cubical.Algebra.Group.Morphisms
open import Cubical.Algebra.Group.MorphismProperties
open import Cubical.Algebra.Group.Properties
open import Cubical.Algebra.Group.Subgroup
open import Cubical.Algebra.Group.QuotientGroup
open import Cubical.Algebra.AbGroup.Base

open import Cubical.Categories.Category.Base
open import Cubical.Categories.Morphism using (isMonic ; isEpic)
open import Cubical.Categories.Instances.AbGroups
open import Cubical.Categories.Additive.Base
open import Cubical.Categories.Abelian.Base

open import AbIsPreabelian_TheCategoryOfAbelianGroupsIsAPreAbCategoryNotJustACategory

------------------------------------------------------------------------
-- 1.  The coset relation of a normal subgroup is an equivalence relation,
--     and it is prop-valued, so SetQuotients.effective applies.
------------------------------------------------------------------------

module _ {ℓ : Level} (G : Group ℓ) (N : NormalSubgroup G) where
  private
    module G = GroupStr (snd G)
    open GroupTheory G
    open isSubgroup (snd (fst N))

    R : ⟨ G ⟩ → ⟨ G ⟩ → Type ℓ
    R = _~_ G (fst N) (snd N)

  ~isPropValued : BinaryRelation.isPropValued R
  ~isPropValued a b = ∈-isProp (fst (fst N)) _

  ~isSym : BinaryRelation.isSym R
  ~isSym a b p =
    subst-∈ (fst (fst N))
      (invDistr a (G.inv b) ∙ cong (G._· G.inv a) (invInv b))
      (inv-closed p)

  ~isTrans : BinaryRelation.isTrans R
  ~isTrans a b c p q = subst-∈ (fst (fst N)) path (op-closed p q)
    where
    path : (a G.· G.inv b) G.· (b G.· G.inv c) ≡ a G.· G.inv c
    path = sym (G.·Assoc a (G.inv b) (b G.· G.inv c))
         ∙ cong (a G.·_) ( G.·Assoc (G.inv b) b (G.inv c)
                         ∙ cong (G._· G.inv c) (G.·InvL b)
                         ∙ G.·IdL (G.inv c) )

  ~isEquivRel : BinaryRelation.isEquivRel R
  ~isEquivRel =
    BinaryRelation.equivRel (isRefl~ G (fst N) (snd N)) ~isSym ~isTrans

  ~effective : (a b : ⟨ G ⟩) → Path (⟨ G ⟩ SQ./ R) [ a ] [ b ] → R a b
  ~effective = effective ~isPropValued ~isEquivRel

------------------------------------------------------------------------
-- 2.  Monics in Ab are injective, and are the kernel of their cokernel.
------------------------------------------------------------------------

module _ {ℓ : Level} {x y : AbGroup ℓ}
         (m : AbGroupHom x y) (mono : isMonic (AbGroupCategory {ℓ}) {x = x} {y = y} m) where
  private
    module X = AbGroupStr (snd x)
    module Y = AbGroupStr (snd y)
    Yg = AbGroup→Group y

    Kof : Kernel (AbPreadd {ℓ}) {x = x} {y = y} m
    Kof = AbKernel {x = x} {y = y} m

    Cof : Cokernel (AbPreadd {ℓ}) {x = x} {y = y} m
    Cof = AbCokernel {x = x} {y = y} m

    ImOf : NormalSubgroup Yg
    ImOf = ImN {x = x} {y = y} m

  CokOf : AbGroup ℓ
  CokOf = Cokernel.c Cof

  cokOf : AbGroupHom y CokOf
  cokOf = Cokernel.coker Cof

  mKerTrivial : (a : ⟨ x ⟩) → fst m a ≡ Y.0g → a ≡ X.0g
  mKerTrivial a p = funExt⁻ (cong fst step) (a , p)
    where
    Kg = AbGroup→Group (Kernel.k Kof)

    zeroPath : compGroupHom (trivGroupHom Kg x) m ≡ trivGroupHom Kg y
    zeroPath = GroupHom≡ (funExt λ _ → IsGroupHom.pres1 (snd m))

    step : Kernel.ker Kof ≡ trivGroupHom Kg x
    step = mono {z = Kernel.k Kof}
                {a = Kernel.ker Kof} {a' = trivGroupHom Kg x}
                (IsKernel.ker⋆f (Kernel.isKer Kof) ∙ sym zeroPath)

  mInj : (a b : ⟨ x ⟩) → fst m a ≡ fst m b → a ≡ b
  mInj a b q =
      sym (X.+IdR a)
    ∙ cong (a X.+_) (sym (X.+InvL b))
    ∙ X.+Assoc a (X.- b) b
    ∙ cong (X._+ b) s
    ∙ X.+IdL b
    where
    r : fst m (a X.+ (X.- b)) ≡ Y.0g
    r = IsGroupHom.pres· (snd m) a (X.- b)
      ∙ cong (fst m a Y.+_) (IsGroupHom.presinv (snd m) b)
      ∙ cong (λ u → fst m a Y.+ (Y.- u)) (sym q)
      ∙ Y.+InvR (fst m a)

    s : a X.+ (X.- b) ≡ X.0g
    s = mKerTrivial (a X.+ (X.- b)) r

  -- DIAGNOSTIC
  mPre : (w : AbGroup ℓ) (t : AbGroupHom w y)
       → compGroupHom t cokOf
         ≡ AbGroupStr.0g (snd (HomGroup (AbGroup→Group w) CokOf))
       → (v : ⟨ w ⟩) → Σ[ a ∈ ⟨ x ⟩ ] (fst m a ≡ fst t v)
  mPre w t h v = PT.rec (fibProp (fst t v))
      (λ ap → fst ap , snd ap ∙ tidy (fst t v))
      (~effective Yg ImOf (fst t v) Y.0g (funExt⁻ (cong fst h) v))
    where
    fibProp : (cc : ⟨ y ⟩) → isProp (Σ[ a ∈ ⟨ x ⟩ ] (fst m a ≡ cc))
    fibProp cc (a , p) (b , q) =
      Σ≡Prop (λ _ → isSetAbGroup y _ _) (mInj a b (p ∙ sym q))

    tidy : (b : ⟨ y ⟩) → b Y.+ (Y.- Y.0g) ≡ b
    tidy b = cong (b Y.+_) (GroupTheory.inv1g Yg) ∙ Y.+IdR b

  mUFun : (w : AbGroup ℓ) (t : AbGroupHom w y)
        → (h : compGroupHom t cokOf
               ≡ AbGroupStr.0g (snd (HomGroup (AbGroup→Group w) CokOf)))
        → ⟨ w ⟩ → ⟨ x ⟩
  mUFun w t h v = fst (mPre w t h v)

  mUChain : (w : AbGroup ℓ) (t : AbGroupHom w y)
        → (h : compGroupHom t cokOf
               ≡ AbGroupStr.0g (snd (HomGroup (AbGroup→Group w) CokOf)))
        → (v v' : ⟨ w ⟩)
        → fst m (mUFun w t h (AbGroupStr._+_ (snd w) v v'))
          ≡ fst m (mUFun w t h v X.+ mUFun w t h v')
  mUChain w t h v v' =
      snd (mPre w t h (AbGroupStr._+_ (snd w) v v'))
    ∙ IsGroupHom.pres· (snd t) v v'
    ∙ cong₂ Y._+_ (sym (snd (mPre w t h v))) (sym (snd (mPre w t h v')))
    ∙ sym (IsGroupHom.pres· (snd m) (mUFun w t h v) (mUFun w t h v'))

  mUPres : (w : AbGroup ℓ) (t : AbGroupHom w y)
        → (h : compGroupHom t cokOf
               ≡ AbGroupStr.0g (snd (HomGroup (AbGroup→Group w) CokOf)))
        → (v v' : ⟨ w ⟩)
        → mUFun w t h (AbGroupStr._+_ (snd w) v v')
          ≡ mUFun w t h v X.+ mUFun w t h v'
  mUPres w t h v v' =
    mInj (mUFun w t h (AbGroupStr._+_ (snd w) v v'))
         (mUFun w t h v X.+ mUFun w t h v')
         (mUChain w t h v v')

------------------------------------------------------------------------
-- 3.  Rigor boundary.
--
--  NOT proved here: monNormal, epiNormal, AbelianCategoryStr,
--  AbelianCategory.  Nothing in this module should be read as saying
--  AbGroupCategory is abelian.  What it says is that the two classical
--  ingredients are in hand -- monics are injective (§2), and the coset
--  relation is effective (§1), which is what makes epics surjective by the
--  dual argument -- and that the obstruction to assembling them is an
--  elaboration failure at the GroupHom record, not a mathematical gap.
--
--  REFUTATION OF MY OWN, recorded because it was in a draft header for an
--  hour: I wrote that the ONLY thing the library was missing for the
--  abelian axiom was §1, "and both halves fall out of it".  §1 was indeed
--  missing and is indeed necessary.  It is not sufficient, and the thing
--  that stopped the proof was not a missing lemma at all.
--
--  HOW THIS COULD BE TRUE AND IRRELEVANT: §1 is a general fact about
--  quotient groups and is used here by nothing that closes.  If the
--  packaging problem has a one-line fix, §1 becomes a footnote to a
--  theorem someone else states in ten minutes.
------------------------------------------------------------------------
