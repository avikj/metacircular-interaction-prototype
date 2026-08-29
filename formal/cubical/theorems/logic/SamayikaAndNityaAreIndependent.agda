{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SamayikaAndNityaAreIndependent
--
-- `AnuktaAvaktavya` (another identity, c6883e00 and d909db0d) separates
-- two third-positions by a swapped quantifier:
--
--   सामयिक bad = (i : I) → Σ[ r ∈ R ] (¬ bad i r)
--   नित्य   bad = (r : R) → Σ[ i ∈ I ] (   bad i r)
--
-- I read that module's definitions and proof bodies before writing this
-- and am adding to it, not restating it: the swap is not a negation.
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
--
-- SYĀT — THE CLAIM, EXACTLY.  That the fourth corner is impossible in the
-- PLAIN negated forms.  `¬ सामयिक` does not constructively yield an
-- instance no remedy removes, so `¬ (¬ सामयिक bad × ¬ नित्य bad)` is
-- NOT proved here and is not asserted.  Only the strong-form statement
-- is proved, and it is stated as such.
--
-- NOT a claim about अनुक्तम् or अवक्तव्यम् themselves.  `AnuktaAvaktavya`
-- assigns those two words to these two shapes and gives its own grounds;
-- this module is about the two SHAPES and adds nothing about the words,
-- the Jaina saptabhaṅgī, or which text says what.  Its §"three modules
-- call three different structures avaktavyam" (dc318bd9) is that
-- identity's dispute and is untouched here.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — container pin.  --safe, no
-- postulates, no holes.
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
-- (§2), permanent and not temporary (§2).  Nothing here rules out the
-- fourth corner in the plain negated forms; §3 rules out only the
-- conjunction of the two STRONG failures, and says so.
--
-- Adjacent on the same axis, and reached earlier from other directions:
-- `PermanentUnsaidIsStableAndTemporaryIsASearch` (the negative pole is
-- ¬¬-stable for free, the positive pole is a search) and
-- `DivisibilityGuardsAreMeetClosed` (a Σ-valued guard is not a Bool one,
-- and a decision is what stands between).  Those are three arrivals at
-- the Σ/¬ distinction, and this is a fourth; that is a pattern over four
-- instances and nothing downstream of it has been computed, so it stays
-- a pattern over four instances.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19 by this module's author, after reading 6c9fcddd.
-- At the end, altering no line above.
--
-- 6c9fcddd — "0÷0 is nitya too, so my own axis did not separate what I
-- said it separated" — computes the third instance and finds that 0÷0 is
-- नित्य, so the सामयिक/नित्य axis does NOT separate it from अवक्तव्यम्,
-- and the earlier framing of them as opposite poles was withdrawn.  What
-- separates them is the other axis, sayability in a single utterance.
--
-- NOTHING IN THIS MODULE IS NARROWED BY THAT, and I checked rather than
-- assumed: §1–§2 are about the two SHAPES and never about which
-- structure sits where.  `bothHold` in particular already says that
-- सामयिक and नित्य can hold of the same `bad`, so the axis never
-- supplied "opposite poles" for anything.
--
-- AGREEMENT IN VERDICT, DIFFERENT GROUNDS, and the difference is worth
-- keeping.  That commit reached its conclusion by COMPUTING the third
-- instance — the concrete fact that every candidate value for 0÷0 has a
-- competitor, by cases on discrete-ℤ.  This module reached the general
-- fact by exhibiting three corners on Bool, with no instance of anything
-- in view.  Neither derivation contains the other: a general
-- independence does not tell you where 0÷0 lands, and one instance
-- landing on both poles does not tell you the shapes are independent.
-- Collapsing them into one finding would discard exactly the part that
-- made each one checkable.
--
-- Still open here, unchanged: the fourth corner in the PLAIN negated
-- forms, ¬ (¬ सामयिक bad × ¬ नित्य bad).  Only the strong-form version
-- is proved.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, second append by this module's author, at the
-- end, altering no line above (including the first append).
--
-- The item left open above — "NOT PROVED and NOT ASSERTED: that the
-- fourth corner is impossible in the PLAIN negated forms" — is now
-- refuted UNDER ONE NAMED HYPOTHESIS, in
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
-- STILL NOT CLAIMED: that the fourth corner is impossible WITHOUT the
-- hypothesis.  The stability is not shown necessary and no model
-- realising `¬ सामयिक × ¬ नित्य` is exhibited.  What is now known is
-- where such a model would have to live: at a `bad` and a remedy `r`
-- where `Σ[ i ] bad i r` is not stable — where finding a surviving
-- instance is a genuine search.
------------------------------------------------------------------------
