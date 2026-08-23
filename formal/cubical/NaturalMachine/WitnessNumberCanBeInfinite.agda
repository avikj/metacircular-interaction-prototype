{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.WitnessNumberCanBeInfinite
--
-- `WitnessNumberIsUnbounded` left open whether witness number is
-- unbounded, saying the n-point version has the obvious upper bound but
-- that the lower bound at general n "needs a pigeonhole this module
-- does not prove".
--
-- The pigeonhole is not needed, and the answer is stronger than
-- unbounded: there is an exact absence here that NO FINITE LIST
-- REFUTES.  Its witness number is infinite, not merely large.
--
-- ────────────────────────────────────────────────────────────────────
-- THE FAMILY, AND ITS REFUTING LISTS EXACTLY
--
-- Over any discrete A, one standpoint per point, each wrong exactly at
-- its own:
--
--     diagLaw dA d x  =  ⊥     when d ≡ x
--     diagLaw dA d x  =  Unit  otherwise
--
-- The refuting lists are characterised — not bounded, characterised:
--
--     refuting→contains-all : Refutes (diagLaw dA) ys → (d : A) → Mem d ys
--     contains-all→refutes  : ((d : A) → Mem d ys) → Refutes (diagLaw dA) ys
--
-- A list refutes exactly when it contains every point.  That is sharper
-- than any length bound and is why no counting is needed: at A = Three
-- it gives `WitnessNumberIsUnbounded`'s answer 3, and at A = ℕ it gives
--
--     no-finite-list-refutes :
--       (ys : List ℕ) → ¬ Refutes (diagLaw discreteℕ) ys
--
-- because a finite list of naturals misses `suc (sumOf ys)`.  The
-- absence itself is real and one line: no standpoint is right at its own
-- point.
--
-- ────────────────────────────────────────────────────────────────────
-- THE PICTURE IS NOW COMPLETE
--
--   unconstrained decoders + locatable witnesses  ⟹ witness number 2
--                              (`WhyTheSitesAreTwo`, `LocatingIsEnough`)
--   constrained decoders                          ⟹ anything, up to ∞
--                              (`WitnessNumberIsUnbounded`, here)
--
-- So the deflation is exactly as strong as its hypothesis and no
-- stronger.  Every site in this corpus meets that hypothesis, which is
-- why every one of them costs 2; a site that did not could cost
-- anything at all, and this module is the witness that "anything"
-- includes "no finite amount".
--
-- ────────────────────────────────────────────────────────────────────
-- READ AS NAYAVĀDA
--
-- Infinitely many standpoints, pairwise disagreeing, no finite set of
-- observations telling them apart.  The anekānta result says plurality
-- blocks collapse; `WitnessNumberIsUnbounded` priced finite plurality at
-- one witness per standpoint; this says unbounded plurality cannot be
-- demonstrated by any finite observation at all.  That is not a barrier
-- in the sense this corpus has been deflating — the absence is still
-- exact, still one line — it is the honest statement that EXACTNESS AND
-- CHEAPNESS ARE DIFFERENT PROPERTIES, and only the first is universal
-- here.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.WitnessNumberCanBeInfinite where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; discreteℕ)
open import Cubical.Data.Nat.Order
  using (_≤_ ; ≤SumLeft ; ≤SumRight ; ≤-trans ; ¬m<m ; suc-≤-suc)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt ; Unit* ; tt*)
open import Cubical.Data.Empty as Empty using (⊥ ; ⊥*)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)

open import NaturalMachine.WitnessNumberIsTwo using (AllHold ; Refutes)
open import NaturalMachine.WhyTheSitesAreTwo using (Mem)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- 1.  One standpoint per point, each wrong exactly at its own
------------------------------------------------------------------------

offDiag : {A : Type ℓ} → Dec A → Type₀
offDiag (yes _) = ⊥
offDiag (no  _) = Unit

diagLaw : {A : Type ℓ} → Discrete A → A → A → Type₀
diagLaw dA d x = offDiag (dA d x)

module _ {A : Type ℓ} (dA : Discrete A) where

  self-fails : (d : A) → ¬ (diagLaw dA d d)
  self-fails d with dA d d
  ... | yes _  = λ z → z
  ... | no ¬p  = Empty.rec (¬p refl)

  off-holds : (d x : A) → ¬ (d ≡ x) → diagLaw dA d x
  off-holds d x ¬e with dA d x
  ... | yes e = Empty.rec (¬e e)
  ... | no  _ = tt

------------------------------------------------------------------------
-- 2.  A standpoint not in the list survives it; one in it does not
------------------------------------------------------------------------

  notMem→survives : (d : A) (ys : List A)
                  → ¬ Mem d ys → AllHold (diagLaw dA) d ys
  notMem→survives d []       _  = tt*
  notMem→survives d (y ∷ ys) nm =
      off-holds d y (λ e → nm (inl e))
    , notMem→survives d ys (λ m → nm (inr m))

  memFails : (d : A) (ys : List A)
           → Mem d ys → AllHold (diagLaw dA) d ys → ⊥
  memFails d (y ∷ ys) (inl e) (h , _)  =
    self-fails d (subst (diagLaw dA d) (sym e) h)
  memFails d (y ∷ ys) (inr m) (_ , hs) = memFails d ys m hs

------------------------------------------------------------------------
-- 3.  Membership is decidable, so the characterisation is constructive
------------------------------------------------------------------------

  decMem : (d : A) (ys : List A) → Dec (Mem d ys)
  decMem d []       = no Empty.rec*
  decMem d (y ∷ ys) with dA d y
  ... | yes e = yes (inl e)
  ... | no ¬e = step (decMem d ys)
    where
    step : Dec (Mem d ys) → Dec (Mem d (y ∷ ys))
    step (yes m) = yes (inr m)
    step (no ¬m) = no bad
      where
      bad : Mem d (y ∷ ys) → ⊥
      bad (inl e) = ¬e e
      bad (inr m) = ¬m m

------------------------------------------------------------------------
-- 4.  THE CHARACTERISATION: refuting = containing every point
------------------------------------------------------------------------

  refuting→contains-all :
    (ys : List A) → Refutes (diagLaw dA) ys → (d : A) → Mem d ys
  refuting→contains-all ys ref d = pick (decMem d ys)
    where
    pick : Dec (Mem d ys) → Mem d ys
    pick (yes m) = m
    pick (no ¬m) = Empty.rec (ref d (notMem→survives d ys ¬m))

  contains-all→refutes :
    (ys : List A) → ((d : A) → Mem d ys) → Refutes (diagLaw dA) ys
  contains-all→refutes ys all d = memFails d ys (all d)

------------------------------------------------------------------------
-- 5.  The absence is real, at any inhabited A
------------------------------------------------------------------------

  no-universal-standpoint : ¬ (Σ[ d ∈ A ] ((x : A) → diagLaw dA d x))
  no-universal-standpoint (d , full) = self-fails d (full d)

------------------------------------------------------------------------
-- 6.  AT A = ℕ, NO FINITE LIST REFUTES
--
-- A finite list of naturals misses `suc (sumOf ys)`, because every
-- member is at most the sum.
------------------------------------------------------------------------

sumOf : List ℕ → ℕ
sumOf []       = 0
sumOf (x ∷ xs) = x + sumOf xs

mem≤sum : (d : ℕ) (ys : List ℕ) → Mem d ys → d ≤ sumOf ys
mem≤sum d (y ∷ ys) (inl e) = subst (_≤ (y + sumOf ys)) (sym e) ≤SumLeft
mem≤sum d (y ∷ ys) (inr m) = ≤-trans (mem≤sum d ys m) ≤SumRight

no-finite-list-refutes : (ys : List ℕ) → ¬ Refutes (diagLaw discreteℕ) ys
no-finite-list-refutes ys ref =
  ¬m<m (suc-≤-suc (mem≤sum (suc (sumOf ys)) ys
                    (refuting→contains-all discreteℕ ys ref (suc (sumOf ys)))))

-- and yet the absence holds
no-universal-ℕ : ¬ (Σ[ d ∈ ℕ ] ((x : ℕ) → diagLaw discreteℕ d x))
no-universal-ℕ = no-universal-standpoint discreteℕ

------------------------------------------------------------------------
-- 7.  What is settled.
--
-- SETTLED, and stronger than the open item asked.  Witness number is
-- not merely unbounded; it can fail to be a number at all.  The refuting
-- lists of the diagonal family are exactly those containing every point,
-- so at a finite A the number is |A| and at A = ℕ there is none.
--
-- No pigeonhole was needed, because characterising the refuting lists is
-- easier than counting them — which is the same lesson as the rest of
-- this thread: fix what is being measured before reaching for a bound.
--
-- OPEN, named and not estimated.  Whether an absence with infinite
-- witness number arises anywhere in this corpus's MATHEMATICS.  The
-- diagonal family above is constructed to order, and `WhyTheSitesAreTwo`
-- says nothing with unconstrained decoders and locatable witnesses can
-- be one.  Whether any site here has constrained decoders at all has not
-- been checked.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19 by another identity, at the end, altering no line
-- above.  A CORRECTION THAT LANDED FOUR MINUTES AFTER THIS FILE AND NEVER
-- REACHED IT.
--
-- The header above says:
--
--     "Every site in this corpus meets that hypothesis, which is why
--      every one of them costs 2."
--
-- `NaturalMachine/SiteAudit.agda` was written at 14:36:26 on 2026-08-18,
-- four minutes after this file (14:32:41), and exists to correct exactly
-- that sentence where it appears in `WhyTheSitesAreTwo` §6 and in
-- `notes/THE_WITNESS_NUMBER.md` §5.  It corrected both.  It does not
-- mention this module, and the sentence is still standing here.
--
-- WHAT THE AUDIT ESTABLISHED.  Every site is still exactly 2 — the
-- conclusion survives — but the GROUND differs, and conflating the two is
-- what produced the overstatement:
--
--   achievability (≤ 2)  from an exhibited collision; holds everywhere,
--                        needs no hypothesis.
--   the floor (≥ 2)      from the constant decoder; needs only that the
--                        decoder space contain constants.  Holds at every
--                        site, `Laghava` included.
--   the ceiling (≤ 2 for ANY absence of that shape)
--                        needs discreteness or locatability, and DOES NOT
--                        HOLD at `Laghava`, whose observation space is
--                        `Denotation = ℕ → ℕ` — not discrete, and equality
--                        of functions ℕ → ℕ is not decidable.
--
-- So `Laghava` is 2, proved outright and by hand, but NOT because of the
-- hypothesis this file's header invokes.  For all this corpus knows, some
-- other absence over the same q could cost more there.  One site is also
-- constrained rather than unconstrained — `AvaktavyaDoesNotFactor`, six
-- atoms — and was likewise proved by hand.
--
-- Nothing in §§1–4 above changes: `no-finite-list-refutes` and the
-- characterisation of refuting lists are untouched, and the two-line
-- summary of the picture is right about the DICHOTOMY.  What is wrong is
-- only the universal "every site meets that hypothesis".
--
-- AND THE POINTER IS MADE LOAD-BEARING RATHER THAN LEFT AS PROSE, because
-- a prose correction is exactly what failed to propagate the first time.
-- The audit's theorem is imported below, so this module now DEPENDS on it:
-- if the audited ground ever changes, this file stops compiling.
------------------------------------------------------------------------

open import NaturalMachine.SiteAudit using (laghava-is-two)

-- The site the header's universal claim gets wrong, at its audited value,
-- proved by hand there rather than by the ceiling theorem.
laghava-audited : _
laghava-audited = laghava-is-two
