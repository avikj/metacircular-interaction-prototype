{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Durnaya_CollapseIffEveryNayaAgrees
--
-- ������ � a standpoint that asserts itself by denying the others.
-- Collapsing a standpoint-indexed proposition to a single type IS that
-- act, so the question "when may the index be dropped?" is the question
-- of when a naya is a durnaya.  This module answers it exactly.
--
-- PROVENANCE OF THE NAME.  Siddhasena Divkara
-- (*Sanmatitarka*) and Akalaka use `durnaya` for a naya asserted to the
-- exclusion of the rest; that a naya so asserted is defective is theirs.
-- The characterisation below � collapse is available iff every pair of
-- fibres is equivalent � is
-- this corpus's mathematics, named for the act the tradition already
-- named, in the sense `Anekanta.agda` argues for at length.
------------------------------------------------------------------------

module Durnaya_CollapseIffEveryNayaAgrees where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Unit using (Unit ; tt ; isPropUnit)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Anekanta

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1.  The characterisation.  Collapse is available exactly when the
--     index was idle � every naya equivalent to every other.
------------------------------------------------------------------------

-- ����������� � all standpoints agree, pairwise.
AllNayasAgree : {S : Type ℓ} (P : S → Type ℓ') → Type _
AllNayasAgree {S = S} P = (s t : S) → P s ≃ P t

collapse→agree :
  {S : Type ℓ} (P : S → Type ℓ') (Q : Type ℓ') →
  Collapses P Q → AllNayasAgree P
collapse→agree P Q c s t = compEquiv (c s) (invEquiv (c t))

agree→collapse :
  {S : Type ℓ} (P : S → Type ℓ') (s₀ : S) →
  AllNayasAgree P → Σ[ Q ∈ Type ℓ' ] Collapses P Q
agree→collapse P s₀ a = P s₀ , λ s → a s s₀

-- The characterisation.  Note the
-- side condition: S must be
-- inhabited for the backward direction, since over an empty S every Q
-- collapses vacuously and there is no fibre to collapse to.
collapse-characterisation :
  {S : Type ℓ} (P : S → Type ℓ') (s₀ : S) →
  ((Σ[ Q ∈ Type ℓ' ] Collapses P Q) → AllNayasAgree P)
  × (AllNayasAgree P → Σ[ Q ∈ Type ℓ' ] Collapses P Q)
collapse-characterisation P s₀ =
  (λ (Q , c) → collapse→agree P Q c) , agree→collapse P s₀

------------------------------------------------------------------------
-- 2.  `plurality-blocks-collapse` is a corollary, not an axiom of the
--     ethics.  Disagreement blocks collapse because it is one way � not
--     the only way � for two fibres to fail to be equivalent.
------------------------------------------------------------------------

plurality-blocks-collapse-derived :
  {S : Type ℓ} (P : S → Type ℓ') →
  syādastināsti P → (Q : Type ℓ') → ¬ (Collapses P Q)
plurality-blocks-collapse-derived P ((s , ps) , (t , ¬pt)) Q c =
  ¬pt (equivFun (collapse→agree P Q c s t) ps)

------------------------------------------------------------------------
-- 3.  The third option.
--
-- Standpoints = Bool; from one the fibre is Unit, from the other Bool.
-- No standpoint denies, so sydastinsti is empty and
-- `plurality-blocks-collapse` says nothing.  The fibres are inequivalent,
-- so `agreement-permits-collapse` does not apply either.  And collapse
-- is nonetheless unavailable � the third option.
------------------------------------------------------------------------

¬Unit≃Bool : ¬ (Unit ≃ Bool)
¬Unit≃Bool e = false≢true (sym path)
  where
    path : true ≡ false
    path = sym (secEq e true)
         ∙ cong (equivFun e) (isPropUnit (invEq e true) (invEq e false))
         ∙ secEq e false

Mixed : Bool → Type₀
Mixed true  = Unit
Mixed false = Bool

-- neither standpoint denies: the third bhaga has no witness here
Mixed-not-astināsti : ¬ (syādastināsti Mixed)
Mixed-not-astināsti (_ , (true  , ¬pt)) = ¬pt tt
Mixed-not-astināsti (_ , (false , ¬pt)) = ¬pt true

-- and the standpoints do not agree
Mixed-not-agree : ¬ (AllNayasAgree Mixed)
Mixed-not-agree a = ¬Unit≃Bool (a true false)

-- yet no collapse exists
Mixed-denies-collapse : (Q : Type₀) → ¬ (Collapses Mixed Q)
Mixed-denies-collapse Q c = Mixed-not-agree (collapse→agree Mixed Q c)

-- the third option, as an inhabited type
third-option-exists :
  Σ[ P ∈ (Bool → Type₀) ]
    ( (¬ (syādastināsti P))
    × ( (¬ (AllNayasAgree P))
    × ((Q : Type₀) → ¬ (Collapses P Q)) ) )
third-option-exists =
  Mixed , Mixed-not-astināsti , Mixed-not-agree , Mixed-denies-collapse

------------------------------------------------------------------------
-- 4.  The rule.
--
-- The ethics is this: the permission to drop
-- a standpoint index requires EVERY pair of standpoints to agree, and
-- exhibiting a denial is merely the cheapest way to prove that permission
-- absent.  A family can be many-sided without any naya denying another �
-- Unit and Bool disagree about nothing, and still cannot be identified.
------------------------------------------------------------------------
