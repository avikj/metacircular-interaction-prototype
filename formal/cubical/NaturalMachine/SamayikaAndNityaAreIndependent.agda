{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.SamayikaAndNityaAreIndependent
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
-- WHAT IS NOT CLAIMED.  That the fourth corner is impossible in the
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

module NaturalMachine.SamayikaAndNityaAreIndependent where

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
