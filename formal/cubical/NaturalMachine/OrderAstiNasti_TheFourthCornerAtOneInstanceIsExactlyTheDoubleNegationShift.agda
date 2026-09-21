{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift
--
-- `TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet` gave a
-- second SUFFICIENT condition for refuting the fourth corner.
--
-- A necessary one is here, for one family, and it identifies the corner
-- with a named principle instead of describing it.
--
-- Take the instance set to be a SINGLE instance (`Unit`) and let the
-- remedies be arbitrary.  Then, writing `bad _ r = Q r`:
--
--   Â àà¾à®à¯à¿à• bad  â‰  (r : R) â’ Â Â Q r
--   Â à¨à¿ààà¯   bad  â‰  Â ((r : R) â’ Q r)
--
-- so the fourth corner IS
--
--   ((r : R) â’ Â Â Q r)  —  Â ((r : R) â’ Q r)
--
-- which is exactly a counterexample to the DOUBLE-NEGATION SHIFT,
-- `(âˆx ÂÂA x) â’ ÂÂ (âˆx A x)` â” the principle isolated by Spector's
-- bar-recursion interpretation of analysis (`Provably recursive
-- functionals of analysis`, 1962) and by Kreisel before him.  DNS
-- refutes the configuration outright: from `ÂÂ Î ` and `Â Î `.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   notSamayikaIsPointwiseDoubleNegation   both directions
--   notNityaIsNotThePi                     both directions
--   fourthCornerIsDNSFailure               the two together
--   fourthCornerRefutesPointwiseStability
--       and therefore, at this family, the earlier module's hypothesis
--       is NECESSARY and not merely sufficient: the corner exists only
--       where `Stable (Q r)` fails at some r
--
-- The last one is the point.  Two modules gave sufficient conditions and
-- said no necessary one was known.  Here the condition is necessary, so
-- the search for the fourth corner is not "look for an exotic instance
-- family" â” a ONE-element instance family already suffices, and the
-- whole question is whether the BADNESS is stable.  The earlier
-- `Enumerated` route was answering a question the corner does not ask.
--
-- EXISTENCE.  DNS is not provable in this substrate and NOT
-- refutable in it either â” exhibiting a failure needs a model, and no model
-- is constructed here, nor can one be from inside `--safe` cubical without
-- postulates. What changes is the STATUS of the question: it is no longer "is
-- there an exotic configuration?" but "does this substrate validate DNS?",
-- which is a question with a literature and an answer that depends on the
-- metatheory.
--
-- The `Unit` instance set is a specialisation: the equivalence is
-- proved for it.
--
-- School named before the term: àà¾à®à¯à¿à• and à¨à¿ààà¯ are `AnuktaAvaktavya`'s,
-- another identity's, imported unchanged; the fourth corner is the
-- position in the saptabhag reading that module sets up.  The
-- double-negation shift is not a Jaina notion; the identification is
-- between a configuration this repository
-- wrote down and a principle from proof theory, and it is an
-- identification of the FORMULA, not of the two traditions' concerns.
------------------------------------------------------------------------

module NaturalMachine.KramaAstiNasti_TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

open import AnuktaAvaktavya using (à¤¸à¤¾à¤®à¤¯à¤¿à¤• ; à¤¨à¤¿à¤¤à¥à¤¯)

private
  variable
    R : Type

Stable : Type â†’ Type
Stable A = Â¬ Â¬ A â†’ A

------------------------------------------------------------------------
-- 1.  One instance, arbitrary remedies
------------------------------------------------------------------------

one : {R : Type} â†’ (R â†’ Type) â†’ (Unit â†’ R â†’ Type)
one Q _ r = Q r

------------------------------------------------------------------------
-- 2.  The two negations, computed
------------------------------------------------------------------------

notSamayikaGivesPointwise :
  (Q : R â†’ Type) â†’ Â¬ à¤¸à¤¾à¤®à¤¯à¤¿à¤• (one Q) â†’ (r : R) â†’ Â¬ Â¬ Q r
notSamayikaGivesPointwise Q h r nq = h (Î» _ â†’ r , nq)

pointwiseGivesNotSamayika :
  (Q : R â†’ Type) â†’ ((r : R) â†’ Â¬ Â¬ Q r) â†’ Â¬ à¤¸à¤¾à¤®à¤¯à¤¿à¤• (one Q)
pointwiseGivesNotSamayika Q k f = k (fst (f tt)) (snd (f tt))

notNityaGivesNotThePi :
  (Q : R â†’ Type) â†’ Â¬ à¤¨à¤¿à¤¤à¥à¤¯ (one Q) â†’ Â¬ ((r : R) â†’ Q r)
notNityaGivesNotThePi Q h g = h (Î» r â†’ tt , g r)

notThePiGivesNotNitya :
  (Q : R â†’ Type) â†’ Â¬ ((r : R) â†’ Q r) â†’ Â¬ à¤¨à¤¿à¤¤à¥à¤¯ (one Q)
notThePiGivesNotNitya Q k f = k (Î» r â†’ snd (f r))

------------------------------------------------------------------------
-- 3.  So the fourth corner IS a failure of the double-negation shift
------------------------------------------------------------------------

DNSFailure : {R : Type} â†’ (R â†’ Type) â†’ Type
DNSFailure {R} Q = ((r : R) â†’ Â¬ Â¬ Q r) Ã— (Â¬ ((r : R) â†’ Q r))

fourthCornerGivesDNSFailure :
  (Q : R â†’ Type)
  â†’ (Â¬ à¤¸à¤¾à¤®à¤¯à¤¿à¤• (one Q)) Ã— (Â¬ à¤¨à¤¿à¤¤à¥à¤¯ (one Q)) â†’ DNSFailure Q
fourthCornerGivesDNSFailure Q (ns , nn) =
  notSamayikaGivesPointwise Q ns , notNityaGivesNotThePi Q nn

dnsFailureGivesFourthCorner :
  (Q : R â†’ Type)
  â†’ DNSFailure Q â†’ (Â¬ à¤¸à¤¾à¤®à¤¯à¤¿à¤• (one Q)) Ã— (Â¬ à¤¨à¤¿à¤¤à¥à¤¯ (one Q))
dnsFailureGivesFourthCorner Q (pw , np) =
  pointwiseGivesNotSamayika Q pw , notThePiGivesNotNitya Q np

------------------------------------------------------------------------
-- 4.  Hence the earlier hypothesis is NECESSARY here, not just sufficient
--
-- Pointwise stability turns `(r) â’ Â Â Q r` into `(r) â’ Q r`, which the
-- second component forbids.  So at a one-instance family the corner
-- exists ONLY where the badness fails to be stable â” the instance set
-- has nothing to do with it.
------------------------------------------------------------------------

fourthCornerRefutesPointwiseStability :
  (Q : R â†’ Type)
  â†’ (Â¬ à¤¸à¤¾à¤®à¤¯à¤¿à¤• (one Q)) Ã— (Â¬ à¤¨à¤¿à¤¤à¥à¤¯ (one Q))
  â†’ Â¬ ((r : R) â†’ Stable (Q r))
fourthCornerRefutesPointwiseStability Q corner stab =
  snd d (Î» r â†’ stab r (fst d r))
  where
    d : DNSFailure Q
    d = fourthCornerGivesDNSFailure Q corner

------------------------------------------------------------------------
-- Enumerability of the REMEDY set is a different matter and is NOT
-- inert.  In `NaturalMachine.AnEnumerableRemedySetKillsTheFourthCorner`:
--
--   finiteDNSList   `All (ÂÂ P) xs â’ Â Â All P xs`, by induction â” no
--                   decidability, no choice
--   finiteDNS       hence `((r) â’ ÂÂ Q r) â’ Â Â ((r) â’ Q r)` for an
--                   ENUMERATED remedy set
--   theFourthCornerNeedsANonEnumerableRemedySet
--                   so the corner refutes `Enumerated R`
--
-- **THE TWO ENUMERABILITY HYPOTHESES ARE NOT SYMMETRIC.**  Enumerating
-- the INSTANCES buys nothing â” one instance suffices for the corner and
-- one instance is enumerable.  Enumerating the REMEDIES buys
-- everything: DNS becomes a theorem and the corner cannot exist.  An
-- earlier module reached for `Enumerated` on the wrong side of the pair;
-- that is now said, with the right side identified.
--
-- WHERE THE CORNER CAN LIVE: a
-- NON-ENUMERABLE remedy set with a badness that is not stable.
--
------------------------------------------------------------------------

------------------------------------------------------------------------
-- Renamed from
-- `Avaktavya_*` to `KramaAstiNasti_*`: the previous term was wrong.
-- `KramaSaha_TheFourthCornerIWasNamingIsTheSequentialPosition` proves
-- this line's "fourth corner" is a product of two independent
-- negations and that simultaneous refusal collapses into the
-- sequential pair, so the position is the THIRD bhaga â”
-- ààà¯à¾àà-ààààà¿-à¨à¾àààà¿, asserted à•àà°à®àà â” and not avaktavya.  The full
-- correction is recorded at
-- `KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet`.
------------------------------------------------------------------------
