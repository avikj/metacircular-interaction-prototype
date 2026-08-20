{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AbGroupCategory is a PreAbCategory, not just a Category:
-- the first non-terminal instance of the library's additive/abelian records
--
-- cf-tessera-z-1, 2026-08-20.
--
-- PROVENANCE, stated because CLAUDE.md's file-naming rule requires it and
-- operative note 2 of that rule forbids inventing a Sanskrit label for
-- mathematics that does not come from the traditions this repository reads.
-- The objects here are additive and abelian categories: Mac Lane, "Duality
-- for groups" (1950) and "Categories for the Working Mathematician" (1971);
-- Buchsbaum's exact categories (1955); Grothendieck, "Sur quelques points
-- d'algebre homologique", Tohoku Math. J. 9 (1957), where the AB-axioms are
-- stated; Freyd, "Abelian Categories" (1964).  The Agda records instantiated
-- below are Cubical.Categories.Additive.Base and Cubical.Categories.Abelian
-- .Base of the cubical library, v0.5 (commit 132a2a3).  None of this is
-- Indian material and no Sanskrit term is claimed for it.
--
-- CREDIT.  cf-tessera-s-0 scoped this in message 2191 section 5, blocker 3:
-- the abelian-category machinery in the library has exactly one instance
-- (Terminal.agda, in each of Additive/Instances and Abelian/Instances) and
-- Cubical.Categories.Instances.AbGroups is 24 lines building a bare
-- Category.  cf-tessera-w-0 was sent at it and was killed by a session limit
-- at 12:40 UTC mid-work, reporting "full tower to cokernels typechecks".
-- Its untracked scratch file formal/cubical/scratch_ab_preadd.agda is on
-- disk; it is w-0's property, it was read and not edited, and it in fact
-- carries the whole tower THROUGH the PreAbCategory assembly and typechecks
-- (verified here on a copy, exit 0).  The route below -- HomGroup for the
-- hom abelian groups, trivialAbGroup for the zero object, dirProdAb for the
-- biproduct, Subgroup->Group of kerSubgroup for the kernel, the quotient by
-- imSubgroup for the cokernel -- is w-0's, and the proof terms in sections
-- 1-3 follow it closely.  What is added here is section 0, the field-by-
-- field requirement read off the library rather than assumed.
--
-- UPSTREAM, checked before writing rather than after: agda/cubical's live
-- default branch has PreaddCategoryStr in exactly three files (Additive/
-- Base.agda, Additive/Instances/Terminal.agda, Additive/Quotient.agda) and
-- AbGroupCategory in exactly one (Categories/Instances/AbGroups.agda), so
-- this instance is absent upstream as well, not merely absent from the v0.5
-- pin.
--
-- The other libraries on this machine, checked rather than assumed, and the
-- check corrected me once: /root/agda-libs/1lab/src/Cat/Abelian/Instances/
-- Ab.lagda.md exists and its prose says Ab is "an abelian category at
-- that", so I first recorded that 1lab already has this.  Reading the file
-- refutes it.  Sixty lines, one theorem: `Ab-is-additive : is-additive
-- (Ab l)`.  It opens `is-pre-abelian` and never constructs one; grepping
-- the whole of 1lab for `is-pre-abelian (Ab` or `is-abelian (Ab` returns
-- nothing.  So 1lab stops at ADDITIVE, exactly one step below where this
-- module stops, and the kernels/cokernels half is absent there too.
-- agda-unimath has neither: group-theory/category-of-abelian-groups
-- .lagda.md is a bare (large) category and there are no additive or abelian
-- category records anywhere in it.  Neither library is importable here.
--
-- WHAT IS AND IS NOT CLAIMED.  PreAbCategory closes.  AbelianCategory does
-- not close in this module; see AbIsAbelian_MonosAreKernelsAndEpisAre
-- CokernelsOnceTheCosetRelationIsAnEquivalence for that step and for the
-- one library lemma it needs.
------------------------------------------------------------------------

module AbIsPreabelian_TheCategoryOfAbelianGroupsIsAPreAbCategoryNotJustACategory where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Powerset using (subst-∈)
open import Cubical.Data.Sigma

open import Cubical.HITs.SetQuotients as SQ using ([_] ; eq/ ; squash/)
open import Cubical.HITs.PropositionalTruncation as PT using (∥_∥₁ ; ∣_∣₁)

open import Cubical.Algebra.Group.Base
open import Cubical.Algebra.Group.Morphisms
open import Cubical.Algebra.Group.MorphismProperties
open import Cubical.Algebra.Group.Properties
open import Cubical.Algebra.Group.Subgroup
open import Cubical.Algebra.Group.QuotientGroup
open import Cubical.Algebra.AbGroup.Base

open import Cubical.Categories.Category.Base
open import Cubical.Categories.Instances.AbGroups
open import Cubical.Categories.Additive.Base
open import Cubical.Categories.Abelian.Base


------------------------------------------------------------------------
-- 0.  What the three records actually require, field by field, in v0.5.
--     Read off Cubical/Categories/Additive/Base.agda and
--     Cubical/Categories/Abelian/Base.agda, not assumed.
--
--  PreaddCategoryStr (C : Category ℓ ℓ')  -- 3 fields
--    homAbStr : (x y : ob) → AbGroupStr Hom[ x , y ]
--    ⋆distl+  : f ⋆ (g + g') ≡ (f ⋆ g) + (f ⋆ g')
--    ⋆distr+  : (f + f') ⋆ g ≡ (f ⋆ g) + (f' ⋆ g)
--  PreaddCategory ℓ ℓ' = record { cat ; preadd }.
--  NOTE: no field asks that composition preserve 0h.  That is derivable
--  (Cubical.Categories.Additive.Properties) and is NOT a hypothesis.
--
--  AdditiveCategoryStr (C : PreaddCategory ℓ ℓ')  -- 2 fields
--    zero   : ZeroObject  = record { z ; zInit : isInitial ; zTerm : isTerminal }
--    biprod : ∀ x y → Biproduct x y
--  Biproduct x y = record { x⊕y ; i₁ ; i₂ ; π₁ ; π₂ ; isBipr }, and
--  IsBiproduct has FIVE equations: i₁⋆π₁ ≡ id, i₁⋆π₂ ≡ 0h, i₂⋆π₁ ≡ 0h,
--  i₂⋆π₂ ≡ id, and π₁ ⋆ i₁ + π₂ ⋆ i₂ ≡ id.  The last is the one that makes
--  it a biproduct rather than a product-and-coproduct-that-happen-to-agree;
--  it is the only field of the whole tower that uses the hom-group addition
--  in an essential way.
--
--  PreAbCategoryStr (C : AdditiveCategory ℓ ℓ')  -- 2 fields
--    hasKernels   : (f : Hom[ x , y ]) → Kernel preaddcat f
--    hasCokernels : (f : Hom[ x , y ]) → Cokernel preaddcat f
--  Kernel = record { k ; ker ; isKer }, IsKernel ker = record
--    { ker⋆f : ker ⋆ f ≡ 0h
--    ; univ  : ∀ w (t : Hom[ w , x ]) → t ⋆ f ≡ 0h
--               → ∃![ u ∈ Hom[ w , k ] ] (u ⋆ ker ≡ t) }
--  and Cokernel dually with f ⋆ coker ≡ 0h and coker ⋆ u ≡ t.
--  ∃! here is isContr of a Σ, so `univ` owes a centre AND a contraction.
--
--  AbelianCategoryStr (C : PreAbCategory ℓ ℓ')  -- 2 fields
--    monNormal : (m : Hom[ x , y ]) → isMonic cat m
--                  → Σ[ z ] Σ[ f ∈ Hom[ y , z ] ] IsKernel f m
--    epiNormal : (e : Hom[ x , y ]) → isEpic cat e
--                  → Σ[ w ] Σ[ f ∈ Hom[ w , x ] ] IsCokernel f e
--  This last record is NOT instantiated below.  Section 6 says exactly why.
------------------------------------------------------------------------

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- 1.  AbGroupCategory is preadditive.
------------------------------------------------------------------------

module _ {ℓ : Level} where
  open Category
  open PreaddCategoryStr
  open PreaddCategory

  AbPreaddStr : PreaddCategoryStr (AbGroupCategory {ℓ})
  homAbStr AbPreaddStr x y = snd (HomGroup (AbGroup→Group x) y)
  ⋆distl+ AbPreaddStr f g g' = GroupHom≡ refl
  ⋆distr+ AbPreaddStr f f' g =
    GroupHom≡ (funExt λ a → IsGroupHom.pres· (snd g) (fst f a) (fst f' a))

  AbPreadd : PreaddCategory (ℓ-suc ℓ) ℓ
  cat AbPreadd = AbGroupCategory
  preadd AbPreadd = AbPreaddStr

------------------------------------------------------------------------
-- 2.  Zero object and biproducts: AbGroupCategory is additive.
------------------------------------------------------------------------

  open ZeroObject
  open AdditiveCategoryStr
  open AdditiveCategory
  open Biproduct
  open IsBiproduct

  AbZero : ZeroObject AbPreadd
  z AbZero = trivialAbGroup
  zInit AbZero y =
      trivGroupHom (AbGroup→Group trivialAbGroup) y
    , λ f → GroupHom≡ (funExt λ _ → sym (IsGroupHom.pres1 (snd f)))
  zTerm AbZero y =
      trivGroupHom (AbGroup→Group y) trivialAbGroup
    , λ f → GroupHom≡ (funExt λ _ → refl)

  AbBiproduct : (x y : AbGroup ℓ) → Biproduct AbPreadd x y
  x⊕y (AbBiproduct x y) = dirProdAb x y
  i₁ (AbBiproduct x y) =
      (λ a → a , AbGroupStr.0g (snd y))
    , makeIsGroupHom λ a a' → ΣPathP (refl , sym (AbGroupStr.+IdR (snd y) _))
  i₂ (AbBiproduct x y) =
      (λ b → AbGroupStr.0g (snd x) , b)
    , makeIsGroupHom λ b b' → ΣPathP (sym (AbGroupStr.+IdR (snd x) _) , refl)
  π₁ (AbBiproduct x y) = fst , makeIsGroupHom λ _ _ → refl
  π₂ (AbBiproduct x y) = snd , makeIsGroupHom λ _ _ → refl
  i₁⋆π₁ (isBipr (AbBiproduct x y)) = GroupHom≡ refl
  i₁⋆π₂ (isBipr (AbBiproduct x y)) = GroupHom≡ refl
  i₂⋆π₁ (isBipr (AbBiproduct x y)) = GroupHom≡ refl
  i₂⋆π₂ (isBipr (AbBiproduct x y)) = GroupHom≡ refl
  ∑π⋆i (isBipr (AbBiproduct x y)) =
    GroupHom≡ (funExt λ ab →
      ΣPathP ( AbGroupStr.+IdR (snd x) (fst ab)
             , AbGroupStr.+IdL (snd y) (snd ab) ))

  AbAdditive : AdditiveCategory (ℓ-suc ℓ) ℓ
  preaddcat AbAdditive = AbPreadd
  zero (addit AbAdditive) = AbZero
  biprod (addit AbAdditive) = AbBiproduct

------------------------------------------------------------------------
-- 3.  Kernels and cokernels.
------------------------------------------------------------------------

  open Kernel
  open IsKernel
  open Cokernel
  open IsCokernel

  module _ {x y : AbGroup ℓ} (f : AbGroupHom x y) where
    private
      X = AbGroup→Group x
      Y = AbGroup→Group y
      module X = AbGroupStr (snd x)
      module Y = AbGroupStr (snd y)

      kerProp : (v : ⟨ x ⟩) → isProp (fst f v ≡ Y.0g)
      kerProp v = isPropIsInKer f v

    KerAb : AbGroup ℓ
    KerAb = Group→AbGroup (Subgroup→Group X (kerSubgroup f))
              (λ a b → Σ≡Prop kerProp (X.+Comm (fst a) (fst b)))

    kerHom : AbGroupHom KerAb x
    kerHom = fst , makeIsGroupHom λ _ _ → refl

    AbKernel : Kernel AbPreadd {x = x} {y = y} f
    k AbKernel = KerAb
    ker AbKernel = kerHom
    ker⋆f (isKer AbKernel) = GroupHom≡ (funExt λ ap → snd ap)
    univ (isKer AbKernel) w t h = (uHom , GroupHom≡ refl) , uniq
      where
      uHom : AbGroupHom w KerAb
      uHom = (λ v → fst t v , funExt⁻ (cong fst h) v)
           , makeIsGroupHom λ a b →
               Σ≡Prop kerProp (IsGroupHom.pres· (snd t) a b)

      uniq : (v : Σ[ u ∈ AbGroupHom w KerAb ] (compGroupHom u kerHom ≡ t))
           → (uHom , GroupHom≡ refl) ≡ v
      uniq (u' , p') =
        Σ≡Prop (λ u → isSetGroupHom (compGroupHom u kerHom) t)
          (GroupHom≡ (funExt λ v →
            Σ≡Prop kerProp (sym (funExt⁻ (cong fst p') v))))

    ImN : NormalSubgroup Y
    ImN = imSubgroup f , isNormalIm f Y.+Comm

    CokAb : AbGroup ℓ
    CokAb = Group→AbGroup (Y / ImN)
      (SQ.elimProp2 (λ _ _ → GroupStr.is-set (snd (Y / ImN)) _ _)
        λ a b → cong [_] (Y.+Comm a b))

    cokHom : AbGroupHom y CokAb
    cokHom = [_] , makeIsGroupHom λ _ _ → refl

    AbCokernel : Cokernel AbPreadd {x = x} {y = y} f
    c AbCokernel = CokAb
    coker AbCokernel = cokHom
    f⋆coker (isCoker AbCokernel) = GroupHom≡ (funExt λ a →
      eq/ (fst f a) Y.0g
        (subst-∈ (fst (imSubgroup f))
          (sym ( cong (fst f a Y.+_) (GroupTheory.inv1g Y)
               ∙ Y.+IdR (fst f a) ))
          ∣ a , refl ∣₁))
    univ (isCoker AbCokernel) w t h = (uHom , GroupHom≡ refl) , uniq
      where
      module W = AbGroupStr (snd w)

      wd : (a b : ⟨ y ⟩) → _~_ Y (fst ImN) (snd ImN) a b → fst t a ≡ fst t b
      wd a b = PT.rec (isSetAbGroup w _ _) λ gp →
        GroupTheory.·CancelR (AbGroup→Group w) (W.- fst t b)
          ( cong (fst t a W.+_) (sym (IsGroupHom.presinv (snd t) b))
          ∙ sym (IsGroupHom.pres· (snd t) a (Y.- b))
          ∙ cong (fst t) (sym (snd gp))
          ∙ funExt⁻ (cong fst h) (fst gp)
          ∙ sym (W.+InvR (fst t b)) )

      uHom : AbGroupHom CokAb w
      uHom = SQ.rec (isSetAbGroup w) (fst t) wd
           , makeIsGroupHom
               (SQ.elimProp2 (λ _ _ → isSetAbGroup w _ _)
                 λ a b → IsGroupHom.pres· (snd t) a b)

      uniq : (v : Σ[ u ∈ AbGroupHom CokAb w ] (compGroupHom cokHom u ≡ t))
           → (uHom , GroupHom≡ refl) ≡ v
      uniq (u' , p') =
        Σ≡Prop (λ u → isSetGroupHom (compGroupHom cokHom u) t)
          (GroupHom≡ (funExt (SQ.elimProp (λ _ → isSetAbGroup w _ _)
            λ a → sym (funExt⁻ (cong fst p') a))))

------------------------------------------------------------------------
-- 4.  Assembly.  AbGroupCategory is preabelian.
------------------------------------------------------------------------

  open PreAbCategoryStr
  open PreAbCategory

  AbPreAb : PreAbCategory (ℓ-suc ℓ) ℓ
  additive AbPreAb = AbAdditive
  hasKernels (preAbStr AbPreAb) f = AbKernel f
  hasCokernels (preAbStr AbPreAb) f = AbCokernel f

