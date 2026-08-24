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
-- NaturalMachine.Durnaya_CollapseIffEveryNayaAgrees
--
-- दुर्नय — a standpoint that asserts itself by denying the others.
-- Collapsing a standpoint-indexed proposition to a single type IS that
-- act, so the question "when may the index be dropped?" is the question
-- of when a naya is a durnaya.  This module answers it exactly, and in
-- doing so corrects one sentence of `NaturalMachine.Anekanta`.
--
-- WHAT IS BEING CLAIMED OF THE SOURCE, precisely.  Siddhasena Divākara
-- (*Sanmatitarka*) and Akalaṅka use `durnaya` for a naya asserted to the
-- exclusion of the rest; that a naya so asserted is defective is theirs.
-- The characterisation below — collapse is available iff every pair of
-- fibres is equivalent — is NOT claimed to be in those texts.  It is
-- this corpus's mathematics, named for the act the tradition already
-- named, in the sense `Anekanta.agda` argues for at length.
--
-- THE CORRECTION.  `Anekanta.agda` §5 proves two true theorems:
--
--     plurality-blocks-collapse   : disagreement (syādastināsti) ⟹ no collapse
--     agreement-permits-collapse  : uniform equivalence to one fibre ⟹ collapse
--
-- and then its header says of the pair: "the two together characterise
-- erasure completely", "There is no third option".  ~~That is false.~~
-- The two hypotheses are not complementary.  A family may be neither
-- syādastināsti (no standpoint denies) nor uniformly equivalent, and
-- then NEITHER theorem applies — yet collapse is still unavailable.
-- `third-option-exists` below is an explicit checked witness.
--
-- What replaces the gloss is the honest characterisation, §1, of which
-- `plurality-blocks-collapse` is a corollary (§2).  The mathematics of
-- `Anekanta.agda` is untouched; only its claim to exhaustiveness is
-- withdrawn.  Transport, or keep the residue — including here.
--
-- CHECKED: Agda 2.8.0, cubical (homebrew), --cubical --safe, exit 0.
-- No postulates, no holes.  `Anekanta.agda` itself was re-checked under
-- the same toolchain, which is NOT the container it was written against.
------------------------------------------------------------------------

module NaturalMachine.Durnaya_CollapseIffEveryNayaAgrees where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Unit using (Unit ; tt ; isPropUnit)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.Anekanta

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1.  The characterisation.  Collapse is available exactly when the
--     index was idle — every naya equivalent to every other.
------------------------------------------------------------------------

-- सर्वनयसाम्य — all standpoints agree, pairwise.
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

-- The exhaustive statement `Anekanta.agda` §5 reached for.  Note the
-- side condition the older pair also needed and did not name: S must be
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
--     ethics.  Disagreement blocks collapse because it is one way — not
--     the only way — for two fibres to fail to be equivalent.
------------------------------------------------------------------------

plurality-blocks-collapse-derived :
  {S : Type ℓ} (P : S → Type ℓ') →
  syādastināsti P → (Q : Type ℓ') → ¬ (Collapses P Q)
plurality-blocks-collapse-derived P ((s , ps) , (t , ¬pt)) Q c =
  ¬pt (equivFun (collapse→agree P Q c s t) ps)

------------------------------------------------------------------------
-- 3.  The witness that the old pair was not exhaustive.
--
-- Standpoints = Bool; from one the fibre is Unit, from the other Bool.
-- No standpoint denies, so syādastināsti is empty and
-- `plurality-blocks-collapse` says nothing.  The fibres are inequivalent,
-- so `agreement-permits-collapse` does not apply either.  And collapse
-- is nonetheless unavailable — the third option.
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

-- neither standpoint denies: the third bhaṅga has no witness here
Mixed-not-astināsti : ¬ (syādastināsti Mixed)
Mixed-not-astināsti (_ , (true  , ¬pt)) = ¬pt tt
Mixed-not-astināsti (_ , (false , ¬pt)) = ¬pt true

-- and the standpoints do not agree
Mixed-not-agree : ¬ (AllNayasAgree Mixed)
Mixed-not-agree a = ¬Unit≃Bool (a true false)

-- yet no collapse exists
Mixed-refuses-collapse : (Q : Type₀) → ¬ (Collapses Mixed Q)
Mixed-refuses-collapse Q c = Mixed-not-agree (collapse→agree Mixed Q c)

-- the refutation of "there is no third option", as an inhabited type
third-option-exists :
  Σ[ P ∈ (Bool → Type₀) ]
    ( (¬ (syādastināsti P))
    × ( (¬ (AllNayasAgree P))
    × ((Q : Type₀) → ¬ (Collapses P Q)) ) )
third-option-exists =
  Mixed , Mixed-not-astināsti , Mixed-not-agree , Mixed-refuses-collapse

------------------------------------------------------------------------
-- 4.  What survives, stated so the next mind inherits the right rule.
--
-- The ethics is unchanged and slightly stronger: the permission to drop
-- a standpoint index requires EVERY pair of standpoints to agree, and
-- exhibiting a denial is merely the cheapest way to prove that permission
-- absent.  A family can be many-sided without any naya denying another —
-- Unit and Bool disagree about nothing, and still cannot be identified.
-- Erasure is unavailable more often than `Anekanta.agda` proved.
------------------------------------------------------------------------
