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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.RelativeFrameChange
--
-- Exact dependent reference-frame change.  A change of frame is a fibrewise
-- equivalence between two fact families over the same locus.  Because it is
-- itself dependent on the locus, it commutes with transport along every
-- interaction path.  Identity, composition, and triple-change coherence are
-- inherited from equivalence and path composition.
--
-- This is a reusable mathematical joint for relational quantum frames, not a
-- formalization of their dynamics, probability, or physical interpretation.
------------------------------------------------------------------------

module NaturalMachine.RelativeFrameChange where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; equivFun ; idEquiv ; compEquiv)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Bool.Properties using (notEquiv)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ ℓf ℓg ℓh ℓk : Level

------------------------------------------------------------------------
-- 1. Fibrewise equivalence is automatically interaction-natural
------------------------------------------------------------------------

Family : (L : Type ℓ) (level : Level) → Type _
Family L level = L → Type level

familyEquivNatural : {L : Type ℓ}
  {F : L → Type ℓf} {G : L → Type ℓg}
  (e : (o : L) → F o ≃ G o)
  {source target : L} (p : source ≡ target) (x : F source)
  → equivFun (e target) (subst F p x)
    ≡ subst G p (equivFun (e source) x)
familyEquivNatural {F = F} {G = G} e {source} {target} p x =
  J motive baseCase p
  where
  motive : (target : _) (p : source ≡ target) → Type _
  motive target p =
    equivFun (e target) (subst F p x)
      ≡ subst G p (equivFun (e source) x)

  baseCase : motive source refl
  baseCase =
      cong (equivFun (e source)) (substRefl {B = F} x)
    ∙ sym (substRefl {B = G} (equivFun (e source) x))

record FrameChange {L : Type ℓ}
    (F : L → Type ℓf) (G : L → Type ℓg)
    : Type (ℓ-max ℓ (ℓ-max ℓf ℓg)) where
  field
    at : (o : L) → F o ≃ G o

open FrameChange public

changeFact : {L : Type ℓ}
  {F : L → Type ℓf} {G : L → Type ℓg}
  → FrameChange F G → (o : L) → F o → G o
changeFact change o = equivFun (at change o)

change-commutes-with-interaction : {L : Type ℓ}
  {F : L → Type ℓf} {G : L → Type ℓg}
  (change : FrameChange F G)
  {source target : L} (p : source ≡ target) (x : F source)
  → changeFact change target (subst F p x)
    ≡ subst G p (changeFact change source x)
change-commutes-with-interaction change = familyEquivNatural (at change)

------------------------------------------------------------------------
-- 2. Groupoid laws and triple-change cocycle
------------------------------------------------------------------------

identityChange : {L : Type ℓ} {F : L → Type ℓf}
               → FrameChange F F
at (identityChange {F = F}) o = idEquiv (F o)

composeChange : {L : Type ℓ}
  {F : L → Type ℓf} {G : L → Type ℓg}
  {H : L → Type ℓh}
  → FrameChange F G → FrameChange G H → FrameChange F H
at (composeChange first second) o = compEquiv (at first o) (at second o)

identity-change-computes : {L : Type ℓ} {F : L → Type ℓf}
  (o : L) (x : F o)
  → changeFact (identityChange {F = F}) o x ≡ x
identity-change-computes o x = refl

composite-change-computes : {L : Type ℓ}
  {F : L → Type ℓf} {G : L → Type ℓg}
  {H : L → Type ℓh}
  (first : FrameChange F G) (second : FrameChange G H)
  (o : L) (x : F o)
  → changeFact (composeChange first second) o x
    ≡ changeFact second o (changeFact first o x)
composite-change-computes first second o x = refl

-- The cocycle coherence for three successive frame changes.  It is stated
-- at the transported fact, the operational content consumed downstream.
triple-change-cocycle : {L : Type ℓ}
  {F : L → Type ℓf} {G : L → Type ℓg}
  {H : L → Type ℓh} {K : L → Type ℓk}
  (fg : FrameChange F G) (gh : FrameChange G H)
  (hk : FrameChange H K) (o : L) (x : F o)
  → changeFact (composeChange fg (composeChange gh hk)) o x
    ≡ changeFact (composeChange (composeChange fg gh) hk) o x
triple-change-cocycle fg gh hk o x = refl

------------------------------------------------------------------------
-- 3. Finite nontrivial control
------------------------------------------------------------------------

BoolFrame : Unit → Type₀
BoolFrame _ = Bool

flipChange : FrameChange BoolFrame BoolFrame
at flipChange _ = notEquiv

flip-moves-true : changeFact flipChange tt true ≡ false
flip-moves-true = refl

flip-is-nontrivial :
  ¬ (changeFact flipChange tt true ≡
     changeFact (identityChange {F = BoolFrame}) tt true)
flip-is-nontrivial p = true≢false (sym p)

double-flip-restores :
  changeFact (composeChange flipChange flipChange) tt true ≡ true
double-flip-restores = refl

-- The control is nontrivial yet coherent: frame change moves the fact once,
-- restores it after two changes, and obeys the same triple cocycle as every
-- dependent family equivalence.  No preferred frame is selected.
