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
-- NaturalMachine.TwoProfilesSuffice
--
-- CORRECTION TO `OneLemmaFiveSites` §3 AND ITS HEADER.
--
-- That module drew a distinction between two routes to `¬ FactorsThrough`:
--
--   COLLISION   exhibit two points the coarse map identifies and the
--               fine map separates; one pair kills every decoder.
--   EXHAUSTION  when the decoders are a small finite set, refute each in
--               turn.
--
-- and filed `Saptabhangi.no-single-vacana` under EXHAUSTION with the
-- reason: *"no single pair of profiles separates the joint content from
-- every utterance, because different utterances fail on different
-- profiles."*
--
-- The distinction is real.  That reason is false, and this module gives
-- the pair.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS ACTUALLY TRUE
--
--   ONE profile never suffices — §2.  For every φ there is an utterance
--   agreeing with the joint content on it, so no single profile refutes
--   the whole language.  That much of the prose was right, and it is now
--   a theorem rather than an observation.
--
--   TWO profiles do — §3.  φ₁ = (⊤,⊤,⊥) and φ₂ = (⊥,⊥,⊤).  The joint
--   content is false on both, and each of the six utterances says `true`
--   on one of them.  Their agreement sets are
--
--       at φ₁   { asti kernel-ind , nāsti rewriter , nāsti kernel-refl }
--       at φ₂   { asti rewriter , asti kernel-refl , nāsti kernel-ind }
--
--   which are complementary — disjoint, and together all six.  So the
--   pair separates, and `avaktavya-does-not-factor` follows from two
--   witnesses rather than from a six-fold case analysis.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THE CORRECTED DISTINCTION IS
--
-- Not collision-versus-exhaustion.  The real invariant is the NUMBER OF
-- WITNESSES an absence needs:
--
--     लाघव, अनुवृत्ति, carry/borrow, the fuel obstructions   1
--     अवक्तव्य                                              2
--
-- and 6 was never the answer — it was the size of the decoder space,
-- which is an upper bound anyone can read off, not a measure of the
-- absence.  In Navya-Nyāya terms the witnesses are the *avacchedaka*,
-- the delimitor that makes an abhāva over an infinite pratiyogin-space
-- exact; counting them measures the absence, counting the pratiyogins
-- measures only the language.
--
-- This bears on the standing deflationary thread.  It does not move
-- anything up the abhāva tower — the absence here was exact before and
-- is exact now — but it says the earlier reading was measuring the
-- wrong thing, and that a "must be exhaustive" verdict is a claim about
-- witness count that has to be proved, not read off a finite type.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TwoProfilesSuffice where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; true ; false ; not ; _and_ ; true≢false ; false≢true)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Relation.Nullary using (¬_)

open import SaptabhangiNaya
  using ( Naya ; rewriter ; kernel-refl ; kernel-ind
        ; Profile ; mk ; Vacana ; asti-from ; nasti-from
        ; denotes ; joint )

------------------------------------------------------------------------
-- 1.  Saying it, and separating it
------------------------------------------------------------------------

Says : Vacana → Profile → Type₀
Says v φ = denotes v φ ≡ joint φ

Separates : Profile → Profile → Type₀
Separates φ ψ = (v : Vacana) → (¬ Says v φ) ⊎ (¬ Says v ψ)

------------------------------------------------------------------------
-- 2.  ONE PROFILE IS NEVER ENOUGH
--
-- joint φ = φ rewriter ∧ ¬ (φ kernel-refl).  If `φ kernel-refl` is
-- false the joint content is just `φ rewriter`, said by asti-from
-- rewriter; if it is true the joint content is false, and when
-- `φ rewriter` is also true that is said by nāsti-from rewriter.  Every
-- profile falls into one of these.
------------------------------------------------------------------------

every-profile-is-said : (φ : Profile) → Σ[ v ∈ Vacana ] Says v φ
every-profile-is-said φ = choose (φ rewriter) (φ kernel-refl) refl refl
  where
  choose : (a b : Bool) → φ rewriter ≡ a → φ kernel-refl ≡ b
         → Σ[ v ∈ Vacana ] Says v φ
  choose true  true  pa pb =
    nasti-from rewriter , (cong not pa ∙ sym (cong₂ _and_ pa (cong not pb)))
  choose true  false pa pb =
    asti-from rewriter , (pa ∙ sym (cong₂ _and_ pa (cong not pb)))
  choose false true  pa pb =
    asti-from rewriter , (pa ∙ sym (cong₂ _and_ pa (cong not pb)))
  choose false false pa pb =
    asti-from rewriter , (pa ∙ sym (cong₂ _and_ pa (cong not pb)))

no-single-separator :
  ¬ (Σ[ φ ∈ Profile ] ((v : Vacana) → ¬ Says v φ))
no-single-separator (φ , sep) =
  sep (every-profile-is-said φ .fst) (every-profile-is-said φ .snd)

------------------------------------------------------------------------
-- 3.  TWO PROFILES ARE
------------------------------------------------------------------------

φ₁ : Profile
φ₁ = mk true true false

φ₂ : Profile
φ₂ = mk false false true

-- the joint content is false on both
joint-φ₁ : joint φ₁ ≡ false
joint-φ₁ = refl

joint-φ₂ : joint φ₂ ≡ false
joint-φ₂ = refl

-- and every utterance says `true` on one of them
pair-separates : Separates φ₁ φ₂
pair-separates (asti-from  rewriter)    = inl true≢false
pair-separates (asti-from  kernel-refl) = inl true≢false
pair-separates (asti-from  kernel-ind)  = inr true≢false
pair-separates (nasti-from rewriter)    = inr true≢false
pair-separates (nasti-from kernel-refl) = inr true≢false
pair-separates (nasti-from kernel-ind)  = inl true≢false

------------------------------------------------------------------------
-- 4.  AVAKTAVYA FROM TWO WITNESSES
------------------------------------------------------------------------

FactorsThroughOneUtterance : Type₀
FactorsThroughOneUtterance = Σ[ v ∈ Vacana ] ((φ : Profile) → Says v φ)

avaktavya-from-two : ¬ FactorsThroughOneUtterance
avaktavya-from-two (v , agrees) = split (pair-separates v)
  where
  split : ((¬ Says v φ₁) ⊎ (¬ Says v φ₂)) → _
  split (inl bad) = bad (agrees φ₁)
  split (inr bad) = bad (agrees φ₂)

------------------------------------------------------------------------
-- 5.  The agreement sets, recorded because they are the content
--
-- Each utterance agrees with the joint content on exactly one of the two
-- profiles, and the three-three split is what makes the pair work.
------------------------------------------------------------------------

says-ki-φ₁ : Says (asti-from kernel-ind) φ₁
says-ki-φ₁ = refl

says-nr-φ₁ : Says (nasti-from rewriter) φ₁
says-nr-φ₁ = refl

says-nk-φ₁ : Says (nasti-from kernel-refl) φ₁
says-nk-φ₁ = refl

says-ar-φ₂ : Says (asti-from rewriter) φ₂
says-ar-φ₂ = refl

says-ak-φ₂ : Says (asti-from kernel-refl) φ₂
says-ak-φ₂ = refl

says-nki-φ₂ : Says (nasti-from kernel-ind) φ₂
says-nki-φ₂ = refl

------------------------------------------------------------------------
-- 6.  What this leaves standing and what it removes.
--
-- STANDS.  `Saptabhangi.no-single-vacana` is correct and is not
-- touched; §5 above is literally its six cases regrouped by which
-- profile they use.  `AvaktavyaDoesNotFactor` is correct.  The
-- krama/yugapat contrast — succession expresses the joint content,
-- simultaneity does not — is untouched, and that is the Jain point.
--
-- REMOVED.  The claim that exhaustion is FORCED here.  It is not; two
-- witnesses do it, and the six-fold analysis was a convenience.  A
-- verdict of "this one must be exhaustive" is a lower bound on witness
-- count and needs a proof of its own — §2 is that proof for the bound 1,
-- and §3 shows the bound is exactly 2.
--
-- OPEN, named and not estimated: whether any site in this corpus needs
-- more than two.  Nothing here suggests one does, and nothing here rules
-- it out.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 7.  CORRECTION, appended 2026-08-18 — same day, next commit.
--
-- §"WHAT THE CORRECTED DISTINCTION IS" above says the invariant is the
-- number of witnesses, "1 for लाघव, अनुवृत्ति, carry/borrow and the fuel
-- obstructions; 2 for अवक्तव्य".  That counts in two units.  A collision
-- is one PAIR and a pair is two POINTS.
--
-- `NaturalMachine.WitnessNumberIsTwo` fixes one measure — the least list
-- of points on which no decoder survives — and under it:
--
--   * one point is NEVER enough for any `FactorsThrough` obstruction,
--     with no hypotheses, because the constant decoder `λ _ → t x`
--     answers any single point;
--   * a collision is exactly a refuting pair;
--   * the अवक्तव्य site is 2 as well, by `every-profile-is-said` below
--     for the floor and `pair-separates` for the ceiling.
--
-- So it is 2 versus 2, not 1 versus 2.  What differs between the sites
-- is the ROUTE to the pair — constructed from a collision, or found by
-- looking — which is a fact about obtaining the witness, not about the
-- absence.
--
-- The error is the same shape as the one this module was written to
-- correct: a quantity named before a measure was fixed.
------------------------------------------------------------------------
