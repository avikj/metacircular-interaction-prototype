{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वैधर्म्य — विरुद्धधर्मः एव पर्याप्तः, न द्वैविध्यम् ।
--
-- (dissimilarity alone suffices; two-valuedness is not needed.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS.  `QuotientFiberLaw` is this corpus's
-- general obstruction theorem — an observation class sees exactly a
-- quotient, what it cannot see is the fibre, no post-processing
-- manufactures the fibre.  It has essentially NO hypotheses on the state
-- space: `X : Type ℓ`, arbitrary, no `isSet`, no `Discrete`, no
-- finiteness, and `Separates` quantifies over EVERY decoder, computable
-- or not, deliberately.
--
-- AND IT IS TWO-VALUED IN THREE PLACES, WHICH NOBODY HAD SAID.
--
--   Query   = X → Bool                        (a query IS a bit)
--   Charged o x y = o x ≡ not (o y)           (separation IS negation)
--   obs     : List Query → X → List Bool      (the transcript is bits)
--
-- and `no-decision` runs on `not-fix : (b : Bool) → ¬ (b ≡ not b)`,
-- proved by case-splitting `true` and `false`.
--
-- So the corpus's general theorem about what a collapsed verdict cannot
-- see is itself stated in a collapsed verdict — the register
-- `Saptabhangi.दुर्नयः` proves must identify two of any three seeds.  It
-- is not wrong.  It is a naya, and it cannot see its own limit from
-- inside.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS PROVES, AND IT IS ONE LINE OF ACTUAL CONTENT.
--
-- Replace `Bool` by an arbitrary answer type `V`, and `≡ not` by any
-- relation `_#_` that is merely IRREFLEXIVE.  The negative half of the
-- law survives verbatim.  §२'s proof mentions no constructor, no
-- decidability, no h-level, and no two-valuedness: blind queries give
-- EQUAL transcripts, `cong decide` carries that equality to the
-- decoder's output, and irreflexivity kills the separation.
--
-- **THE OBSTRUCTION WAS NEVER CLASSICAL.**  It holds for a spectral
-- observable with an apartness relation, for a real-valued measurement
-- with `≢`, for a complex amplitude — for any answer type whatever, so
-- long as a thing is not apart from itself.  The `Bool` in the original
-- was carrying no weight and was hiding the theorem's reach.
--
-- §३ recovers the original as the instance `V := Bool`,
-- `a # b := a ≡ not b`, so nothing is lost and the old theorem is a
-- corollary of this one.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED, and the asymmetry is the interesting part.
--
-- The POSITIVE half — charge suffices, a separator can be BUILT — does
-- NOT generalise for free.  Over `Bool` it projects the transcript with
-- `hd`, which needs a value at the empty list.  So §४ states it with `V`
-- POINTED, and that hypothesis is real: to exhibit a separator you must
-- be able to produce an answer, and over an arbitrary type you cannot.
--
-- **That asymmetry is the content, not a defect.**  Blindness is free and
-- universal; separation costs a point.  Which is the same shape as
-- everything else here: बहु is cheap to be stuck in and expensive to get
-- out of, and `Tantujala` proves `isContr` merges the two ends.
--
-- Nothing below computes a rank, a PSD dimension, or an entropy.  The
-- tables, ordinary rank 4 both, PSD dimensions 2 and 4) is NOT derived
-- here and is not a consequence of this module.  What this removes is
-- only the excuse that the obstruction was about bits.
--
-- ────────────────────────────────────────────────────────────────────
-- TERM.  वैधर्म्य — dissimilarity — is the technical term of the Nyāya
-- and Buddhist logical traditions for the DISSIMILAR class, against
-- साधर्म्य for the similar: the वैधर्म्य-दृष्टान्त is the negative
-- example, and Dignāga's third condition of the त्रैरूप्य is exactly
-- absence of the reason throughout the dissimilar class.  Sources:
-- Gautama, न्यायसूत्रम् (the दृष्टान्त members); Dignāga, ~5th–6th c.;
-- धर्मकीर्ति, न्यायबिन्दुः २.५, where the placement of the particle एव
-- fixes the scope of exactly this condition.
--
-- LIMIT: the term is used here for an irreflexive separation relation on
-- an answer type.  No text states an apartness relation, no logician
-- proved anything below, and the connection asserted is that both name
-- the same job — the condition under which two things count as told
-- apart.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Vaidharmya_TheObstructionWasNeverClassicalAndTheAnswerTypeNeedOnlyBeApart where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; true≢false)
open import Cubical.Relation.Nullary using (¬_)

private variable ℓ : Level

------------------------------------------------------------------------
-- १ · The law, over an arbitrary answer type.
--
-- `V` is what a query returns.  `_#_` is what it means to be told apart.
-- The ONLY thing asked of `_#_` is that nothing is apart from itself.
------------------------------------------------------------------------

module Law (X : Type ℓ) (V : Type ℓ)
           (_#_ : V → V → Type ℓ)
           (#-irrefl : (v : V) → ¬ (v # v)) where

  Query : Type ℓ
  Query = X → V

  obs : List Query → X → List V
  obs []       x = []
  obs (o ∷ os) x = o x ∷ obs os x

  Blind Charged : Query → X → X → Type ℓ
  Blind   o x y = o x ≡ o y
  Charged o x y = o x # o y

  AllBlind : List Query → X → X → Type ℓ
  AllBlind []       x y = Unit*
  AllBlind (o ∷ os) x y = Blind o x y × AllBlind os x y

  -- Quantifies over EVERY analysis of the transcript, computable or not.
  Separates : List Query → X → X → Type ℓ
  Separates os x y =
    Σ[ decide ∈ (List V → V) ] (decide (obs os x) # decide (obs os y))

------------------------------------------------------------------------
-- २ · The negative half, and it never mentions a constructor.
--
-- Blind queries give EQUAL transcripts — not close, equal — so `cong`
-- carries the equality through any decoder whatever, and then the
-- separation is a thing apart from itself.
------------------------------------------------------------------------

  obs-agree : (os : List Query) (x y : X)
            → AllBlind os x y → obs os x ≡ obs os y
  obs-agree []       x y _        = refl
  obs-agree (o ∷ os) x y (b , bs) = cong₂ _∷_ b (obs-agree os x y bs)

  no-decision : (os : List Query) (x y : X)
              → AllBlind os x y → ¬ Separates os x y
  no-decision os x y bs (decide , sep) =
    #-irrefl (decide (obs os y))
      (subst (λ z → z # decide (obs os y))
             (cong decide (obs-agree os x y bs))
             sep)

------------------------------------------------------------------------
-- ३ · The original is the instance `V := Bool`, `a # b := a ≡ not b`.
--
-- So `QuotientFiberLaw`'s negative half is a corollary of §२ and nothing
-- has been given up.  The `Bool` was carrying no weight.
------------------------------------------------------------------------

द्विमूल-वैधर्म्यम् : Bool → Bool → Type
द्विमूल-वैधर्म्यम् a b = a ≡ not b

द्विमूल-अस्वविरोधः : (b : Bool) → ¬ (द्विमूल-वैधर्म्यम् b b)
द्विमूल-अस्वविरोधः true  e = true≢false e
द्विमूल-अस्वविरोधः false e = true≢false (sym e)

module पूर्वः (X : Type₀) =
  Law X Bool द्विमूल-वैधर्म्यम् द्विमूल-अस्वविरोधः

------------------------------------------------------------------------
-- ४ · Any type at all, with `≢` as the separation.
--
-- Irreflexivity is then immediate, so EVERY answer type carries the
-- obstruction with no structure supplied whatever.  This is the
-- statement that the law is not about bits.
------------------------------------------------------------------------

अभेदः : {V : Type ℓ} → V → V → Type ℓ
अभेदः a b = ¬ (a ≡ b)

अभेद-अस्वविरोधः : {V : Type ℓ} (v : V) → ¬ (अभेदः v v)
अभेद-अस्वविरोधः v ne = ne refl

module सर्वत्र {ℓ₀ : Level} (X : Type ℓ₀) (V : Type ℓ₀) =
  Law X V अभेदः अभेद-अस्वविरोधः

------------------------------------------------------------------------
-- ५ · शेषः — blindness is free, separation costs a point.
--
-- The positive half of `QuotientFiberLaw` (charge suffices — a separator
-- can be exhibited) projects the transcript with a head function, which
-- needs a value at `[]`.  Over `Bool` that is silent.  Over an arbitrary
-- `V` it is a hypothesis: **to exhibit a separator you must be able to
-- produce an answer.**
--
-- The asymmetry is the finding.  Being unable to tell two things apart
-- is universal and costs nothing to prove.  Telling them apart requires
-- an inhabitant of the answer type — you must be able to SAY something.
-- Nothing here supplies that, and no default is invented, because an
-- arbitrary default on an unobservable value is precisely the move both
-- lanes' `FactorsThrough` refuses by typing its decoder on the image.
------------------------------------------------------------------------
