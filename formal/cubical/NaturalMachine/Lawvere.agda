{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Lawvere
--
-- Lawvere's fixed-point theorem (F. W. Lawvere, "Diagonal arguments and
-- cartesian closed categories", 1969), stated in type theory and proved
-- in three lines.  NOTHING HERE IS NEW.  The theorem is fifty-seven
-- years old, and every diagonal argument in the standard list is one of
-- its instances:
--
--   * Cantor      : B = Bool, f = not              (no fixed point)
--   * Russell     : B = Prop, f = ¬                (no fixed point)
--   * Tarski      : B = truth values, f = ¬        (undefinability)
--   * Gödel       : B = provability, f = ¬         (incompleteness)
--   * Turing      : B = halting behaviour, f = flip (undecidability)
--
-- [ADDED 2026-08-15, Claude (header-claim audit); the five lines above
--  are left exactly as written — dated records stand, corrections are
--  appended.  TWO of those five lines are now known to be wrong as
--  stated, by terms in a sibling module committed the same night,
--  formal/cubical/GodelSeparation.agda:
--
--  (a) The `Gödel` line is FALSE as an instance claim.  What is an
--      instance of Lawvere is the DIAGONAL LEMMA — the existence of G
--      with T ⊢ G ↔ ¬Prov(⌜G⌝).  Gödel's first incompleteness theorem
--      is that lemma PLUS arithmetized provability conditions, and it
--      splits:
--        · T ⊬ G      = GodelSeparation.goedelHalfOne — derivable, but
--          only with two hypotheses Lawvere does not supply
--          (consistency and the HBL condition D1).
--        · T ⊬ ¬G     = GodelSeparation.noHalfTwo — NOT derivable from
--          those data at all.  Every would-be derivation is refuted by
--          a four-sentence countermodel (`Wit`) satisfying consistency,
--          D1 and the Gödel fixed point in which ¬G IS provable.  The
--          countermodel is ω-inconsistent in the arithmetic sense
--          (`GodelSeparation.witOmegaBad`), which is the failure mode
--          Gödel 1931 excluded by assuming ω-consistency and Rosser
--          1936 removed by CHANGING THE FIXED POINT — a choice of ν,
--          not a consequence of the theorem about ν.
--      So: read the `Gödel` line as naming the diagonal lemma, not the
--      incompleteness theorem.
--
--  (b) The `Cantor` and `Tarski` lines are not two instances but ONE:
--      GodelSeparation.tarskiUndefinability = cantor, the same term
--      under a different gloss of the enumeration.  That identity is
--      the content, and the list overcounts by one.
--
--  (c) Not corrected because not adjudicated: the `Russell` and
--      `Turing` lines carry no term anywhere in this repository as of
--      this date, in this module or in GodelSeparation.agda.  They are
--      standard and almost certainly right; they are here recorded as
--      UNWITNESSED, not as wrong.
--
--  Nothing in the TERMS of this module asserts any of the above; this
--  module typechecks and proves what it says it proves.  The defect was
--  in the header alone, which is what gets cited.
--  See notes/HEADER_CLAIM_AUDIT.md and
--  notes/LEDGERS_RECONCILED.md §4.1.]
--
-- The single content of the theorem is: a point-surjective
-- φ : A → (A → B) forces EVERY endomap of B to have a fixed point.
-- Contrapositively, one fixed-point-free f on B kills point-surjectivity
-- of every φ.  All of the above are that contrapositive.
--
-- PRIOR ART, IN THIS REPOSITORY.  The general theorem is already
-- formalized at formal/cubical/LawvereDiagonal.agda (module
-- LawvereDiagonal), in the pointwise form
--     WkPtSurj e = (f : A → Y) → Σ[ a ∈ A ] ((x : A) → e a x ≡ f x).
-- This module is NOT a second proof of it.  It states the theorem in the
-- path form  Σ[ a ∈ A ] φ a ≡ g  used by NaturalMachine.EndObstruction,
-- proves the two forms interderivable (`ptSurj→wk`, `wk→ptSurj`, via
-- funExt, which is definitional-strength in cubical), and then derives
-- NaturalMachine.EndObstruction's δ-end / no-complete-quotation as the
-- B = Bool, f = not instance — so that the machine's end-obstruction is
-- visibly a corollary and not an independent argument.
--
-- Everything below is exact: no postulates, no holes, no truncation, no
-- classical logic.  The Σ (untruncated) form of surjectivity is used, so
-- the refutations refute even a CHOSEN index, which is the strongest
-- form and needs no hlevel machinery.
------------------------------------------------------------------------

module NaturalMachine.Lawvere where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv ; equiv-proof)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; true≢false)
open import Cubical.Data.Empty using (⊥ ; isProp⊥)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

import PairField.LawvereDiagonal as WK
import NaturalMachine.EndObstruction as EO
open EO using (Observable ; Quote)

private
  variable
    A B : Type₀

------------------------------------------------------------------------
-- 1.  Lawvere's fixed-point theorem
------------------------------------------------------------------------

-- φ is point-surjective: every B-valued observation on A is literally a
-- row of φ.  (Untruncated: the index is given, not merely asserted.)
PtSurj : (A → (A → B)) → Type₀
PtSurj {A = A} {B = B} φ = (g : A → B) → Σ[ a ∈ A ] φ a ≡ g

FixedPoint : (B → B) → Type₀
FixedPoint {B = B} f = Σ[ b ∈ B ] f b ≡ b

-- The twisted diagonal: read the row at its own index, then apply f.
twist : (A → (A → B)) → (B → B) → (A → B)
twist φ f a = f (φ a a)

-- Lawvere 1969.  If φ enumerates the observations, the index claimed
-- for the twisted diagonal reads at itself to a fixed point of f.
lawvere : {A B : Type₀} (φ : A → (A → B))
  → ((g : A → B) → Σ[ a ∈ A ] φ a ≡ g)
  → (f : B → B) → Σ[ b ∈ B ] f b ≡ b
lawvere φ surj f = φ a₀ a₀ , sym (funExt⁻ (surj (twist φ f) .snd) a₀)
  where
  a₀ : _
  a₀ = surj (twist φ f) .fst

-- Contrapositive: one fixed-point-free endomap of B refutes every φ.
noFix→noPtSurj : (φ : A → (A → B)) (f : B → B)
  → ((b : B) → ¬ (f b ≡ b))
  → ¬ PtSurj φ
noFix→noPtSurj φ f nofix surj = nofix (lawvere φ surj f .fst) (lawvere φ surj f .snd)

-- Productive form: the diagonal does not merely fail to be enumerated,
-- it is exhibited, and each claimed index is refuted individually.
escapes : (φ : A → (A → B)) (f : B → B)
  → ((b : B) → ¬ (f b ≡ b))
  → (a : A) → ¬ (φ a ≡ twist φ f)
escapes φ f nofix a p = nofix (φ a a) (sym (funExt⁻ p a))

defect : (φ : A → (A → B)) (f : B → B)
  → ((b : B) → ¬ (f b ≡ b))
  → Σ[ d ∈ (A → B) ] ((a : A) → ¬ (φ a ≡ d))
defect φ f nofix = twist φ f , escapes φ f nofix

------------------------------------------------------------------------
-- 1'.  Agreement with the pointwise formulation already in the repo
--      (formal/cubical/LawvereDiagonal.agda).  Same theorem.
------------------------------------------------------------------------

ptSurj→wk : (φ : A → (A → B)) → PtSurj φ → WK.WkPtSurj φ
ptSurj→wk φ surj g = surj g .fst , funExt⁻ (surj g .snd)

wk→ptSurj : (φ : A → (A → B)) → WK.WkPtSurj φ → PtSurj φ
wk→ptSurj φ surj g = surj g .fst , funExt (surj g .snd)

-- Either formulation yields the other's conclusion; the fixed points
-- produced by the two proofs are the same element of B, on the nose.
lawvere-agrees : (φ : A → (A → B)) (surj : PtSurj φ) (f : B → B)
  → lawvere φ surj f .fst ≡ WK.lawvere φ (ptSurj→wk φ surj) f .fst
lawvere-agrees φ surj f = refl

------------------------------------------------------------------------
-- 2.  Cantor, as the B = Bool instance
------------------------------------------------------------------------

-- `not` is the fixed-point-free endomap that drives every Bool diagonal.
not-no-fix : (b : Bool) → ¬ (not b ≡ b)
not-no-fix true  p = true≢false (sym p)
not-no-fix false p = true≢false p

cantor : {A : Type₀} (φ : A → (A → Bool))
  → ¬ ((g : A → Bool) → Σ[ a ∈ A ] φ a ≡ g)
cantor φ = noFix→noPtSurj φ not not-no-fix

-- The escaping observation, exhibited with its escape witness.
cantor-defect : (φ : A → (A → Bool))
  → Σ[ d ∈ (A → Bool) ] ((a : A) → ¬ (φ a ≡ d))
cantor-defect φ = defect φ not not-no-fix

------------------------------------------------------------------------
-- 3.  EndObstruction re-derived
--
-- Quote 𝒬 = 𝒬 → Observable 𝒬 = 𝒬 → (𝒬 → Bool) and EO.diag ⌜_⌝ =
-- twist ⌜_⌝ not, both definitionally.  So EndObstruction's statements
-- are literally the B = Bool, f = not instance of §1: the terms below
-- typecheck by unfolding alone, which is the proof that the statements
-- agree rather than merely resemble each other.
------------------------------------------------------------------------

Complete : {𝒬 : Type₀} → Quote 𝒬 → Type₀
Complete {𝒬 = 𝒬} ⌜_⌝ = (d : Observable 𝒬) → Σ[ x ∈ 𝒬 ] ⌜ x ⌝ ≡ d

-- EO.δ-end, from `escapes`.
δ-end : {𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) (x : 𝒬) → ¬ (⌜ x ⌝ ≡ EO.diag ⌜_⌝)
δ-end ⌜_⌝ = escapes ⌜_⌝ not not-no-fix

-- EO.no-complete-quotation, from `cantor`: the derivation is now one
-- word, because the statement IS Cantor's.
no-complete-quotation : {𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) → ¬ Complete ⌜_⌝
no-complete-quotation = cantor

-- The two modules' statements are the same type …
δ-end-same-statement :
    ({𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) (x : 𝒬) → ¬ (⌜ x ⌝ ≡ EO.diag ⌜_⌝))
  × ({𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) (x : 𝒬) → ¬ (⌜ x ⌝ ≡ EO.diag ⌜_⌝))
δ-end-same-statement = δ-end , EO.δ-end

quotation-same-statement :
    ({𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) → ¬ Complete ⌜_⌝)
  × ({𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) → ¬ Complete ⌜_⌝)
quotation-same-statement = no-complete-quotation , EO.no-complete-quotation

-- … and the two derivations agree as terms (both land in ⊥, which is a
-- proposition, so there was never a second proof to have).
derivations-agree : {𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) (c : Complete ⌜_⌝)
  → no-complete-quotation ⌜_⌝ c ≡ EO.no-complete-quotation ⌜_⌝ c
derivations-agree ⌜_⌝ c = isProp⊥ _ _

------------------------------------------------------------------------
-- 4.  The consequence for the machine: the cadence always reopens
--
-- A self-describing machine is a carrier 𝒬 of states-that-can-be-quoted
-- together with a quotation ⌜_⌝ : Quote 𝒬 assigning to each state the
-- Bool-observation it makes of states.  §1 says: that assignment is
-- never point-surjective, no matter what 𝒬 or ⌜_⌝ is.  There is always
-- an observation the machine does not name, and it is CONSTRUCTED, not
-- shown to exist — so the next stage has its generator handed to it.
------------------------------------------------------------------------

-- No machine's quotation enumerates its own observations.
quote-never-point-surjective : {𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) → ¬ PtSurj ⌜_⌝
quote-never-point-surjective = cantor

-- The door, exhibited (EO.next-door, now a corollary of Lawvere).
cadence-reopens : {𝒬 : Type₀} (⌜_⌝ : Quote 𝒬)
  → Σ[ d ∈ Observable 𝒬 ] ((x : 𝒬) → ¬ (⌜ x ⌝ ≡ d))
cadence-reopens ⌜_⌝ = cantor-defect ⌜_⌝

next-door-same-statement :
    ({𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) → Σ[ d ∈ Observable 𝒬 ] ((x : 𝒬) → ¬ (⌜ x ⌝ ≡ d)))
  × ({𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) → Σ[ d ∈ Observable 𝒬 ] ((x : 𝒬) → ¬ (⌜ x ⌝ ≡ d)))
next-door-same-statement = cadence-reopens , EO.next-door

-- The exhibited door is the same observable in both modules, on the nose.
door-agrees : {𝒬 : Type₀} (⌜_⌝ : Quote 𝒬)
  → cadence-reopens ⌜_⌝ .fst ≡ EO.next-door ⌜_⌝ .fst
door-agrees ⌜_⌝ = refl

-- Iterating: whatever door is adjoined, the extended quotation has a new
-- one.  Stated for the machine that has already adjoined d, i.e. for any
-- quotation whatsoever — which is exactly why the cadence never closes.
cadence-never-closes : {𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) (d : Observable 𝒬)
  → ((x : 𝒬) → ¬ (⌜ x ⌝ ≡ d))
  → Σ[ d′ ∈ Observable 𝒬 ] (((x : 𝒬) → ¬ (⌜ x ⌝ ≡ d′)) × (¬ (Σ[ x ∈ 𝒬 ] ⌜ x ⌝ ≡ d)))
cadence-never-closes ⌜_⌝ d esc =
  cadence-reopens ⌜_⌝ .fst , cadence-reopens ⌜_⌝ .snd , λ hit → esc (hit .fst) (hit .snd)

------------------------------------------------------------------------
-- 5.  Bool-free strengthenings (no hlevel machinery used)
--
-- Point-surjectivity is weaker than being a section and weaker than
-- being an equivalence, so the refutation of the weakest kills both.
------------------------------------------------------------------------

ptSurj-of-section : (φ : A → (A → B)) (s : (A → B) → A)
  → ((g : A → B) → φ (s g) ≡ g) → PtSurj φ
ptSurj-of-section φ s h g = s g , h g

ptSurj-of-isEquiv : (φ : A → (A → B)) → isEquiv φ → PtSurj φ
ptSurj-of-isEquiv φ e g = equiv-proof e g .fst

-- No type is equivalent to its own Bool-observations, and none even
-- carries a section of the quotation map.
no-quote-section : {A : Type₀} (φ : A → (A → Bool)) (s : (A → Bool) → A)
  → ¬ ((g : A → Bool) → φ (s g) ≡ g)
no-quote-section φ s h = cantor φ (ptSurj-of-section φ s h)

no-quote-equiv : {A : Type₀} (φ : A → (A → Bool)) → ¬ (isEquiv φ)
no-quote-equiv φ e = cantor φ (ptSurj-of-isEquiv φ e)

-- Same for the machine: a quotation is never an equivalence onto its
-- observations — 𝒬 ≃ Observable 𝒬 is unavailable, whatever 𝒬 is.
quote-never-equiv : {𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) → ¬ (isEquiv ⌜_⌝)
quote-never-equiv = no-quote-equiv

-- CHECKED: Agda 2.6.3, cubical **v0.7** (/tmp/cubical), --cubical --safe,
-- 2026-08-15.  No postulates, no holes.  NOT verified against the pin in
-- formal/cubical/BUILD.md (Agda 2.8.0, cubical v0.9), nor against the v0.5
-- the rest of this lane's headers quote: three toolchain states are live in
-- this repository at once and this file has only seen one of them.
