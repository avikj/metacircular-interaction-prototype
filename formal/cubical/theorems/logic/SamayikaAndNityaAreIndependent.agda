{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SamayikaAndNityaAreIndependent
--
-- `AnuktaAvaktavya` separates
-- two third-positions by a swapped quantifier:
--
--   ‡‡æ‡Æ‡Ø‡ø‡ï bad = (i : I) ‚í Œ[ r ‚àà R ] (¬ bad i r)
--   ‡®‡ø‡‡‡Ø   bad = (r : R) ‚í Œ[ i ‚àà I ] (   bad i r)
--
-- This module adds to it rather than restating it: the swap is not a negation.
-- Both can hold of the SAME `bad`, and three of the four corners are
-- realised ‚î with the fourth impossible only in its strong form, which
-- is stated below rather than assumed.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS ADDED
--
--   bothHold                 a `bad` with ‡‡æ‡Æ‡Ø‡ø‡ï AND ‡®‡ø‡‡‡Ø at once
--   samayikaWithoutNitya     ‡‡æ‡Æ‡Ø‡ø‡ï holds, ‡®‡ø‡‡‡Ø refuted
--   nityaWithoutSamayika     ‡®‡ø‡‡‡Ø holds, ‡‡æ‡Æ‡Ø‡ø‡ï refuted
--   nitya‚ínoUniversalRemedy  ‡®‡ø‡‡‡Ø refutes the STRONG failure of ‡‡æ‡Æ‡Ø‡ø‡ï
--   samayika‚ínoInvincibleInstance
--                            ‡‡æ‡Æ‡Ø‡ø‡ï refutes the STRONG failure of ‡®‡ø‡‡‡Ø
--
-- So the pair is independent in the strict sense: neither implies the
-- other and neither implies the other's negation.  What each DOES refute
-- is the other's strong failure ‚î and those two strong failures are
-- jointly contradictory, which is why the fourth corner has no strong
-- witness.
------------------------------------------------------------------------

module SamayikaAndNityaAreIndependent where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false ; false‚â¢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬¨_)

open import AnuktaAvaktavya using (‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï ; ‡§®‡§ø‡§§‡•ç‡§Ø)

------------------------------------------------------------------------
-- 1.  Both at once ‚î so the swap is not a negation
--
-- Badness is "the remedy matches the instance".  Every instance has a
-- remedy that misses it, AND every remedy is matched by some instance.
------------------------------------------------------------------------

matching : Bool ‚Üí Bool ‚Üí Type
matching i r = i ‚â° r

matching-samayika : ‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï matching
matching-samayika true  = false , true‚â¢false
matching-samayika false = true  , false‚â¢true

matching-nitya : ‡§®‡§ø‡§§‡•ç‡§Ø matching
matching-nitya r = r , refl

bothHold : (‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï matching) √ó (‡§®‡§ø‡§§‡•ç‡§Ø matching)
bothHold = matching-samayika , matching-nitya

------------------------------------------------------------------------
-- 2.  Each without the other
------------------------------------------------------------------------

never : Bool ‚Üí Bool ‚Üí Type
never _ _ = ‚ä•

never-samayika : ‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï never
never-samayika _ = true , Œª x ‚Üí x

never-not-nitya : ¬¨ (‡§®‡§ø‡§§‡•ç‡§Ø never)
never-not-nitya n = n true .snd

samayikaWithoutNitya : (‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï never) √ó (¬¨ (‡§®‡§ø‡§§‡•ç‡§Ø never))
samayikaWithoutNitya = never-samayika , never-not-nitya

always : Bool ‚Üí Bool ‚Üí Type
always _ _ = Unit

always-nitya : ‡§®‡§ø‡§§‡•ç‡§Ø always
always-nitya _ = true , tt

always-not-samayika : ¬¨ (‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï always)
always-not-samayika s = s true .snd tt

nityaWithoutSamayika : (‡§®‡§ø‡§§‡•ç‡§Ø always) √ó (¬¨ (‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï always))
nityaWithoutSamayika = always-nitya , always-not-samayika

------------------------------------------------------------------------
-- 3.  What each DOES refute: the other's strong failure
--
--   a universal remedy   ‚î one r that clears every instance
--   an invincible instance ‚î one i that survives every remedy
--
-- These are the strong forms of ¬ ‡®‡ø‡‡‡Ø and ¬ ‡‡æ‡Æ‡Ø‡ø‡ï.  Each of the two
-- properties refutes one of them, and ¬ß3.3 shows the two cannot both
-- hold, which is why the fourth corner has no strong witness.
------------------------------------------------------------------------

UniversalRemedy : {I R : Type} ‚Üí (I ‚Üí R ‚Üí Type) ‚Üí Type
UniversalRemedy {I} {R} bad = Œ£[ r ‚àà R ] ((i : I) ‚Üí ¬¨ bad i r)

InvincibleInstance : {I R : Type} ‚Üí (I ‚Üí R ‚Üí Type) ‚Üí Type
InvincibleInstance {I} {R} bad = Œ£[ i ‚àà I ] ((r : R) ‚Üí bad i r)

nitya‚ÜínoUniversalRemedy :
  {I R : Type} (bad : I ‚Üí R ‚Üí Type) ‚Üí ‡§®‡§ø‡§§‡•ç‡§Ø bad ‚Üí ¬¨ UniversalRemedy bad
nitya‚ÜínoUniversalRemedy bad n (r , clears) =
  clears (n r .fst) (n r .snd)

samayika‚ÜínoInvincibleInstance :
  {I R : Type} (bad : I ‚Üí R ‚Üí Type) ‚Üí ‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï bad ‚Üí ¬¨ InvincibleInstance bad
samayika‚ÜínoInvincibleInstance bad s (i , survives) =
  s i .snd (survives (s i .fst))

noBothStrongFailures :
  {I R : Type} (bad : I ‚Üí R ‚Üí Type)
  ‚Üí ¬¨ ((InvincibleInstance bad) √ó (UniversalRemedy bad))
noBothStrongFailures bad ((i , survives) , (r , clears)) =
  clears i (survives r)

------------------------------------------------------------------------
-- 4.  The sentence, and its exact scope
--
-- "The difference is a swapped quantifier" is right, and ¬ß1‚ì¬ß2 say what
-- kind of difference it is: an INDEPENDENT one.  A `bad` may be
-- temporary and permanent at once (¬ß1), temporary and not permanent
-- (¬ß2), permanent and not temporary (¬ß2).
-- ¬ß3 rules out only the
-- conjunction of the two STRONG failures.
--
-- Adjacent on the same axis, and reached earlier from other directions:
-- `PermanentUnsaidIsStableAndTemporaryIsASearch` (the negative pole is
-- ¬¬-stable for free, the positive pole is a search) and
-- `DivisibilityGuardsAreMeetClosed` (a Œ-valued guard is not a Bool one,
-- and a decision is what stands between).
------------------------------------------------------------------------

------------------------------------------------------------------------
-- The fourth corner in the PLAIN negated forms is refuted UNDER ONE
-- NAMED HYPOTHESIS, in
-- `TheFourthCornerIsRefutedUnderPointwiseStability`:
--
--   noUniversalRemedyGivesPointwiseDoubleNegation :
--     ¬ UniversalRemedy bad ‚í (r : R) ‚í ¬ ¬ (Œ[ i ‚àà I ] bad i r)
--   pointwiseStabilityGivesNitya :
--     ((r) ‚í Stable (Œ[ i ] bad i r)) ‚í ¬ UniversalRemedy bad ‚í ‡®‡ø‡‡‡Ø bad
--   fourthCornerRefutedUnderPointwiseStability :
--     ((r) ‚í Stable (Œ[ i ] bad i r)) ‚í ¬ ((¬ ‡‡æ‡Æ‡Ø‡ø‡ï bad) ó (¬ ‡®‡ø‡‡‡Ø bad))
--
-- WHERE THE CONSTRUCTIVE ARGUMENT STOPS: the first of those is
-- unconditional and is a one-line contrapositive; it delivers `¬ ¬ Œ`
-- where `‡®‡ø‡‡‡Ø` wants the Œ.  The double negation IS the gap, and
-- pointwise stability ‚î which a decision at each remedy supplies ‚î is
-- exactly what fills it.
--
------------------------------------------------------------------------
