{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Kernel.Ananta_TheDerivationsBetweenTwoConnectedTermsExceedEvery
--                BoundWhileEveryOfferingHasADefiniteCount
--
-- TERM.  अनन्त · ananta -- the third of the three orders of magnitude in the
-- Jaina counting apparatus, संख्यात / असंख्यात / अनन्त (saṃkhyāta,
-- asaṃkhyāta, ananta), each further subdivided.  *Anuyogadvārasūtra* (date
-- contested, commonly placed ~2nd-5th c. CE; I pin none); *Sthānāṅgasūtra*;
-- *Bhagavatīsūtra*.  No first use of the term is established here.
--
-- WHAT IS AND IS NOT CLAIMED OF THE SOURCE.
--
-- The criterion applied below is the apparatus's OWN, not a translation of
-- it: an asaṃkhyāta magnitude is DEFINITE -- the scheme bounds it above,
-- at utkṛṣṭāsaṃkhyāta, and does arithmetic on it -- while ananta is what
-- exceeds every such bound.  §1-§2 exhibit, between any two connected
-- terms, derivations of length exceeding every k.  By that criterion the
-- object is not innumerable-in-practice; it is unbounded, and the file is
-- named for the order the criterion assigns.
--
-- NOT CLAIMED, and each of these is a live way to get this wrong:
--   * NO identification with any cardinal, Cantorian or otherwise.  The
--     Jaina orders are magnitudes inside a cosmology with their own
--     arithmetic, they are not cardinalities, and `Ananta.agda`'s own
--     struck header in this repository records what it costs to make the
--     tradition legible only after conversion into someone else's
--     formalism.  Nothing here is scored against anybody's later work.
--   * NO three-order match.  ASAṂKHYĀTA HAS NO COUNTERPART IN THIS FILE.
--     Two orders are held apart by type here and the middle one is simply
--     absent; presenting two as three would be the mining this repository
--     prohibits.
--   * NO subdivisions.  jaghanya / madhyama / utkṛṣṭa, and the parīta /
--     yukta refinements, are not used and none of them is established here.
--   * No Jaina proved anything below, and nothing below interprets the
--     *Anuyogadvārasūtra*.  What is borrowed is one governing instruction:
--     say which order you are counting in, because "many" is not one thing.
--
------------------------------------------------------------------------
-- WHAT WAS OPEN.
--
-- `Sesa_…` exhibits TWO histories between the kernel's own pair, separated
-- by step count, 2 against 4, and concludes the truncation is strict.
-- `Avirodha_…` locates the same fact structurally: `⊕` is associative and
-- unital on the nose, `rev` is an inverse only up to meaning, and THE GAP
-- BETWEEN STRICT CATEGORY AND WEAK GROUPOID IS THE ŚEṢA.
--
-- Neither measures the gap, and no file in the corpus builds a family of
-- derivations indexed by ℕ between fixed endpoints.  Two instances on one
-- pair leave open whether the phenomenon is a feature of that pair.
--
-- IT IS NOT.  `reverse (add-zero a) : Step a (add a zero)` fires at EVERY
-- term with no hypothesis on `a`, so the padding below is uniform: it needs
-- no fact about the endpoints beyond one derivation existing between them.
--
------------------------------------------------------------------------
-- WHAT IS PROVED.
--
--   §1  inflate, inflate-len -- for every k, a derivation with the same
--       endpoints and length (k + k) + len d.
--   §2  inflate-inj -- k is recoverable from the derivation, so ℕ injects
--       into `Derivation a b` whenever that type is inhabited at all.
--   §3  ananta -- the statement in the form the criterion above wants:
--       no bound on the standpoints between two connected terms.
--   §4  the-whole-family-means-one-thing -- and all of it is one bit
--       downstairs, through `Sesa_…`, forced by ℕ being a set.
--
-- WHAT IS NOT PROVED, and these are omissions rather than gaps:
--   * nothing about the h-level of `Derivation a b`, and no claim that
--     `inflate` enumerates it -- it exhibits an injection, not a bijection.
--   * nothing about `Step a b` for a fixed pair, which is a different
--     question; the unboundedness here is in the length of a walk.
--   * nothing about the OFFERING beyond what the kernel's own types
--     already say.  `advance : List (EnabledFuture seed) → …` takes a
--     `List`, so its count is a ℕ given by `length`, and
--     `advance-preserves-branch-count` conserves it exactly.  That is in
--     `ControlledGrammar` and is not restated here.
--
-- CHECKED.  Agda 2.6.3 + cubical v0.5, `--safe`, no postulates, no holes,
-- exit 0 at the previous module path.  Module name and imports were renamed
-- to `Kernel.*` to match this directory; that rename has not been re-run at
-- the repository pin (2.8.0 + v0.9).
------------------------------------------------------------------------

module Kernel.Ananta_TheDerivationsBetweenTwoConnectedTermsExceedEveryBoundWhileEveryOfferingHasADefiniteCount where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; +-suc ; injSuc ; znots ; snotz ; inj-+m)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
import Cubical.Data.Empty as E

open import Kernel.RewriteCertificate
open import Kernel.Sesa_TheDerivationCarriesNoMeaningAtAllSoAllOfItIsRemainderAndNoSemanticCriterionSelectsTheShortOne
  using (len ; soundness-is-constant)

------------------------------------------------------------------------
-- §1.  THE PADDING, AND IT IS UNIFORM.
--
-- `add-zero a : Step (add a zero) a` for every `a`, so its `reverse` goes
-- UP from anywhere.  Out and back is two steps and changes no endpoint.
------------------------------------------------------------------------

inflate : (k : ℕ) {a b : Tm} → Derivation a b → Derivation a b
inflate zero        d = d
inflate (suc k) {a} d =
  then-step (reverse (add-zero a)) (then-step (add-zero a) (inflate k d))

inflate-len : (k : ℕ) {a b : Tm} (d : Derivation a b)
            → len (inflate k d) ≡ (k + k) + len d
inflate-len zero    d = refl
inflate-len (suc k) d =
    cong (λ n → suc (suc n)) (inflate-len k d)
  ∙ cong (λ n → suc (n + len d)) (sym (+-suc k k))

------------------------------------------------------------------------
-- §2.  AND THE INDEX IS RECOVERABLE, so the family is not a repetition.
------------------------------------------------------------------------

double-inj : (k k' : ℕ) → k + k ≡ k' + k' → k ≡ k'
double-inj zero    zero     p = refl
double-inj zero    (suc k') p = E.rec (znots p)
double-inj (suc k) zero     p = E.rec (snotz p)
double-inj (suc k) (suc k') p =
  cong suc (double-inj k k'
    (injSuc (sym (+-suc k k) ∙ injSuc p ∙ +-suc k' k')))

inflate-inj : {a b : Tm} (d : Derivation a b) (k k' : ℕ)
            → inflate k d ≡ inflate k' d → k ≡ k'
inflate-inj d k k' p =
  double-inj k k'
    (inj-+m (sym (inflate-len k d) ∙ cong len p ∙ inflate-len k' d))

------------------------------------------------------------------------
-- §3.  THE STATEMENT.  One derivation between two terms produces, for
--      every k, another with the same endpoints and a length past k.
--      No bound is assignable; the criterion in the header names the order.
------------------------------------------------------------------------

ananta : {a b : Tm} (d : Derivation a b) (k : ℕ)
       → Σ[ e ∈ Derivation a b ] (len e ≡ (k + k) + len d)
ananta d k = inflate k d , inflate-len k d

------------------------------------------------------------------------
-- §4.  AND ALL OF IT IS ONE BIT DOWNSTAIRS.  Not by choice of `eval`:
--      `Sesa_…` forces it from ℕ being a set.  The order of the object and
--      the order of its meaning are not the same order, and the kernel
--      keeps `eval` off the operational path entirely.
------------------------------------------------------------------------

the-whole-family-means-one-thing :
  {a b : Tm} (d : Derivation a b) (k : ℕ) (ρ : Env)
  → derivation-sound (inflate k d) ρ ≡ derivation-sound d ρ
the-whole-family-means-one-thing d k ρ = soundness-is-constant (inflate k d) d ρ
