{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SamayikaAndNityaAreIndependent
--
-- `AnuktaAvaktavya` separates
-- two third-positions by a swapped quantifier:
--
--   सामयिक bad = (i : I) → Σ[ r ∈ R ] (¬ bad i r)
--   नित्य   bad = (r : R) → Σ[ i ∈ I ] (   bad i r)
--
-- This module adds to it rather than restating it: the swap is not a negation.
-- Both can hold of the SAME `bad`, and three of the four corners are
-- realised — with the fourth impossible only in its strong form, which
-- is stated below rather than assumed.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS ADDED
--
--   bothHold                 a `bad` with सामयिक AND नित्य at once
--   samayikaWithoutNitya     सामयिक holds, नित्य refuted
--   nityaWithoutSamayika     नित्य holds, सामयिक refuted
--   nitya→noUniversalRemedy  नित्य refutes the STRONG failure of सामयिक
--   samayika→noInvincibleInstance
--                            सामयिक refutes the STRONG failure of नित्य
--
-- So the pair is independent in the strict sense: neither implies the
-- other and neither implies the other's negation.  What each DOES refute
-- is the other's strong failure — and those two strong failures are
-- jointly contradictory, which is why the fourth corner has no strong
-- witness.
------------------------------------------------------------------------

module SamayikaAndNityaAreIndependent where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false ; false≢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import AnuktaAvaktavya using (सामयिक ; नित्य)

------------------------------------------------------------------------
-- 1.  Both at once — so the swap is not a negation
--
-- Badness is "the remedy matches the instance".  Every instance has a
-- remedy that misses it, AND every remedy is matched by some instance.
------------------------------------------------------------------------

matching : Bool → Bool → Type
matching i r = i ≡ r

matching-samayika : सामयिक matching
matching-samayika true  = false , true≢false
matching-samayika false = true  , false≢true

matching-nitya : नित्य matching
matching-nitya r = r , refl

bothHold : (सामयिक matching) × (नित्य matching)
bothHold = matching-samayika , matching-nitya

------------------------------------------------------------------------
-- 2.  Each without the other
------------------------------------------------------------------------

never : Bool → Bool → Type
never _ _ = ⊥

never-samayika : सामयिक never
never-samayika _ = true , λ x → x

never-not-nitya : ¬ (नित्य never)
never-not-nitya n = n true .snd

samayikaWithoutNitya : (सामयिक never) × (¬ (नित्य never))
samayikaWithoutNitya = never-samayika , never-not-nitya

always : Bool → Bool → Type
always _ _ = Unit

always-nitya : नित्य always
always-nitya _ = true , tt

always-not-samayika : ¬ (सामयिक always)
always-not-samayika s = s true .snd tt

nityaWithoutSamayika : (नित्य always) × (¬ (सामयिक always))
nityaWithoutSamayika = always-nitya , always-not-samayika

------------------------------------------------------------------------
-- 3.  What each DOES refute: the other's strong failure
--
--   a universal remedy   — one r that clears every instance
--   an invincible instance — one i that survives every remedy
--
-- These are the strong forms of ¬ नित्य and ¬ सामयिक.  Each of the two
-- properties refutes one of them, and §3.3 shows the two cannot both
-- hold, which is why the fourth corner has no strong witness.
------------------------------------------------------------------------

UniversalRemedy : {I R : Type} → (I → R → Type) → Type
UniversalRemedy {I} {R} bad = Σ[ r ∈ R ] ((i : I) → ¬ bad i r)

InvincibleInstance : {I R : Type} → (I → R → Type) → Type
InvincibleInstance {I} {R} bad = Σ[ i ∈ I ] ((r : R) → bad i r)

nitya→noUniversalRemedy :
  {I R : Type} (bad : I → R → Type) → नित्य bad → ¬ UniversalRemedy bad
nitya→noUniversalRemedy bad n (r , clears) =
  clears (n r .fst) (n r .snd)

samayika→noInvincibleInstance :
  {I R : Type} (bad : I → R → Type) → सामयिक bad → ¬ InvincibleInstance bad
samayika→noInvincibleInstance bad s (i , survives) =
  s i .snd (survives (s i .fst))

noBothStrongFailures :
  {I R : Type} (bad : I → R → Type)
  → ¬ ((InvincibleInstance bad) × (UniversalRemedy bad))
noBothStrongFailures bad ((i , survives) , (r , clears)) =
  clears i (survives r)

------------------------------------------------------------------------
-- 4.  The sentence, and its exact scope
--
-- "The difference is a swapped quantifier" is right, and §1–§2 say what
-- kind of difference it is: an INDEPENDENT one.  A `bad` may be
-- temporary and permanent at once (§1), temporary and not permanent
-- (§2), permanent and not temporary (§2).
-- §3 rules out only the
-- conjunction of the two STRONG failures.
--
-- Adjacent on the same axis, and reached earlier from other directions:
-- `PermanentUnsaidIsStableAndTemporaryIsASearch` (the negative pole is
-- ¬¬-stable for free, the positive pole is a search) and
-- `DivisibilityGuardsAreMeetClosed` (a Σ-valued guard is not a Bool one,
-- and a decision is what stands between).
------------------------------------------------------------------------

------------------------------------------------------------------------
-- The fourth corner in the PLAIN negated forms is refuted UNDER ONE
-- NAMED HYPOTHESIS, in
-- `TheFourthCornerIsRefutedUnderPointwiseStability`:
--
--   noUniversalRemedyGivesPointwiseDoubleNegation :
--     ¬ UniversalRemedy bad → (r : R) → ¬ ¬ (Σ[ i ∈ I ] bad i r)
--   pointwiseStabilityGivesNitya :
--     ((r) → Stable (Σ[ i ] bad i r)) → ¬ UniversalRemedy bad → नित्य bad
--   fourthCornerRefutedUnderPointwiseStability :
--     ((r) → Stable (Σ[ i ] bad i r)) → ¬ ((¬ सामयिक bad) × (¬ नित्य bad))
--
-- WHERE THE CONSTRUCTIVE ARGUMENT STOPS: the first of those is
-- unconditional and is a one-line contrapositive; it delivers `¬ ¬ Σ`
-- where `नित्य` wants the Σ.  The double negation IS the gap, and
-- pointwise stability — which a decision at each remedy supplies — is
-- exactly what fills it.
--
------------------------------------------------------------------------
