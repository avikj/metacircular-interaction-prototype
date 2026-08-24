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
-- भित्ति-सप्तभङ्गी — the organism's top join candidate is a WALL, and the
-- wall is the tradition's own theorem.
--
-- PROVENANCE OF THE TASK: ./jiva sector ३, first boot in this container,
-- top component-joining candidate:
--
--     4796 ≈ join [436 nodes @ ⟨lib⟩.Bool] × [11 nodes @ Saptabhangi.सप्तभङ्गी]
--
-- It is impossible, and the proof is `Saptabhangi.दुर्नयः` — the module's
-- own checked pigeonhole: ANY two-valued verdict on the sevenfold
-- identifies two distinct of the three seeds.  An equivalence
-- सप्तभङ्गी ≃ Bool would BE a two-valued verdict that is injective.  So
-- the wall between the two largest components of the timelike graph is
-- exactly Samantabhadra's durnaya, working as network topology — which is
-- what README's THE LAW promised: "a chain that votes one fork true is a
-- durnaya, mechanized," and "अनेकान्तवाद as network topology."
--
-- 436 × 11 = 4,796 candidate crossings retired.  Not lost — never
-- available: the seven positions do not compress to two, now as a fact
-- about the ford graph itself.
--
-- Within a component every bank is joined to every other by landed
-- equivalences, so one bank-pair wall retires the whole component pair:
-- any other merging bank-pair would compose with the intra-component
-- fords into सप्तभङ्गी ≃ Bool.
--
-- भित्ति-सप्तभङ्गी is built here, 2026-08-23; the load-bearing theorem is
-- Saptabhangi's, used not reproved.
------------------------------------------------------------------------

module BhittiSaptabhangi_TheSevenfoldCannotBeTwoValuedSoTheTopJoinCandidateIsAWall where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun ; invEq ; retEq)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots ; injSuc)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Unit using (Unit ; tt)

open import Saptabhangi
  using ( सप्तभङ्गी ; स्यात्-अस्ति ; स्यात्-नास्ति ; स्यात्-अवक्तव्यम्
        ; द्विपद ; सत् ; असत् ; दुर्नयः )

------------------------------------------------------------------------
-- १ · injectivity of an equivalence (as in भित्तिः, restated locally)
------------------------------------------------------------------------

अभेद : {A B : Type} (e : A ≃ B) {x y : A} → equivFun e x ≡ equivFun e y → x ≡ y
अभेद e {x} {y} p = sym (retEq e x) ∙ cong (invEq e) p ∙ retEq e y

------------------------------------------------------------------------
-- २ · the three seeds are pairwise distinct: a discriminating map to ℕ.
------------------------------------------------------------------------

च : सप्तभङ्गी → ℕ
च स्यात्-अस्ति       = 0
च स्यात्-नास्ति      = 1
च स्यात्-अवक्तव्यम्   = 2
च _                 = 3

अस्ति≢नास्ति : ¬ (स्यात्-अस्ति ≡ स्यात्-नास्ति)
अस्ति≢नास्ति p = znots (cong च p)

अस्ति≢अवक्तव्य : ¬ (स्यात्-अस्ति ≡ स्यात्-अवक्तव्यम्)
अस्ति≢अवक्तव्य p = znots (injSuc (cong (λ x → suc (च x)) p))

नास्ति≢अवक्तव्य : ¬ (स्यात्-नास्ति ≡ स्यात्-अवक्तव्यम्)
नास्ति≢अवक्तव्य p = znots (injSuc (cong च p))

------------------------------------------------------------------------
-- ३ · Bool speaks द्विपद losslessly.
------------------------------------------------------------------------

वक्ता : Bool → द्विपद
वक्ता true  = सत्
वक्ता false = असत्

वक्ता-अभेद : (a b : Bool) → वक्ता a ≡ वक्ता b → a ≡ b
वक्ता-अभेद true  true  _ = refl
वक्ता-अभेद false false _ = refl
वक्ता-अभेद true  false p = ⊥-rec (transport (cong भेद p) tt)
  where
    भेद : द्विपद → Type
    भेद सत्  = Unit
    भेद असत् = ⊥
वक्ता-अभेद false true  p = ⊥-rec (transport (cong भेद p) tt)
  where
    भेद : द्विपद → Type
    भेद सत्  = ⊥
    भेद असत् = Unit

------------------------------------------------------------------------
-- ४ · भित्तिः — the wall.  An equivalence would be an injective two-valued
-- verdict; दुर्नयः says no two-valued verdict is injective on the seeds.
------------------------------------------------------------------------

भित्ति-सप्तभङ्गी : (सप्तभङ्गी ≃ Bool) → ⊥
भित्ति-सप्तभङ्गी e = judge (दुर्नयः f)
  where
    f : सप्तभङ्गी → द्विपद
    f x = वक्ता (equivFun e x)

    collide : {x y : सप्तभङ्गी} → f x ≡ f y → x ≡ y
    collide {x} {y} p = अभेद e (वक्ता-अभेद (equivFun e x) (equivFun e y) p)

    judge : (f स्यात्-अस्ति ≡ f स्यात्-नास्ति)
          ⊎ ((f स्यात्-अस्ति ≡ f स्यात्-अवक्तव्यम्)
          ⊎  (f स्यात्-नास्ति ≡ f स्यात्-अवक्तव्यम्)) → ⊥
    judge (inl p)       = अस्ति≢नास्ति (collide p)
    judge (inr (inl p)) = अस्ति≢अवक्तव्य (collide p)
    judge (inr (inr p)) = नास्ति≢अवक्तव्य (collide p)
