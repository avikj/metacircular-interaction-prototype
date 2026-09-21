{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡Æ‡‡≤‡µ‡æ‡ï‡‡Ø‡Æ‡ ¬ PROVENANCE OF THE NAME.
--
-- ‡ï‡‡∞‡Æ ¬ ‡®‡æ‡‡‡‡ø ‚î two terms, one from each half of the ‡‡‡‡‡‡ô‡‡ó‡ apparatus.
--
--   ‡‡‡Ø‡æ‡®‡‡®‡æ‡‡‡‡ø, the second ‡‡ô‡‡ó: in some respect, it is not.  **Samantabhadra,
--   *ptamms* 14-24 (~6th c. CE); Akalaka, *Laghyastraya* (~8th c.);
--   rooted in Umsvti, *Tattvrthastra* 5.31-32 (~2nd-5th c.).**
--
--   ‡ï‡‡∞‡Æ‡æ‡∞‡‡‡ versus ‡‡‡æ‡∞‡‡‡ ‚î presentation in SUCCESSION versus SIMULTANEOUSLY.
--   **Akalaka, *Laghyastraya* (~8th c.); Vidynandin,
--   *Tattvrthalokavrttika* (~9th c.).**  This is the load-bearing one:
--   ‡‡‡‡‡ø and ‡®‡æ‡‡‡‡ø asserted in succession give the third ‡‡ô‡‡ó and are
--   expressible; asserted together they give ‡‡µ‡ï‡‡‡µ‡‡Ø, the fourth, which is
--   neither unknown nor undefined nor empty but a positive fourth position.
--   The distinction is what makes seven positions and not four.
--
-- **No claim is made that Samantabhadra, Akalaka or Vidynandin proved
-- anything below.**  The sevenfold division and the ‡ï‡‡∞‡Æ/‡‡ distinction are
-- theirs, stated as doctrine; the theorems here are about what the fourth
-- corner can and cannot be over particular index types in cubical type
-- theory, and they are this repository's.  The Jaina texts do not contain a
-- claim about enumerable decidable instance sets and nothing here should be
-- read as saying they do.
--
------------------------------------------------------------------------
-- AnEnumerableRemedySetKillsTheFourthCorner
--
-- `TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift` showed
-- that at a single instance the fourth corner IS a counterexample to
-- the double-negation shift, and left EXISTENCE open with the remark
-- that a model would be needed.  It also recorded that the earlier
-- `Enumerated` hypothesis on the INSTANCE set was INERT there ‚î
-- `Enumerated Unit` is immediate, so enumerability of instances cannot
-- be what separates the corner from its absence.
--
-- Enumerability of the REMEDY set is a different matter, and it is not
-- inert: it kills the corner outright.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   All / allFromPointwise / allAtMember
--                     the recursive family and its two directions
--   finiteDNSList     the double-negation shift holds over a LIST:
--                     `All (¬¬ P) xs ‚í ¬ ¬ All P xs`, by induction, with
--                     no decidability and no choice
--   finiteDNS         hence over an ENUMERATED type:
--                     `((r) ‚í ¬ ¬ Q r) ‚í ¬ ¬ ((r) ‚í Q r)`
--   theFourthCornerNeedsANonEnumerableRemedySet
--                     so at a single instance the fourth corner refutes
--                     `Enumerated R`
--
-- **The two enumerability hypotheses are not symmetric, and that is the
-- finding.**  Enumerating the INSTANCES buys nothing ‚î one instance
-- already suffices for the corner, and one instance is enumerable.
-- Enumerating the REMEDIES buys everything: DNS becomes a theorem, and
-- the corner cannot exist.  An earlier module reached for `Enumerated`
-- on the wrong side of the pair and this says which side it belonged
-- on.  Where the corner can live is now: a NON-ENUMERABLE remedy set
-- with a badness that is not stable.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- NO NOVELTY.  That DNS holds over a finite index is elementary and
-- classical in the constructive literature ‚î DNS is only interesting
-- for infinite domains, which is exactly why Spector's bar recursion
-- concerns `‚ï`.  It is proved here because this corpus reached for
-- enumerability twice without noticing the two sides differ.
--
-- School named: ‡‡æ‡Æ‡Ø‡ø‡ï and ‡®‡ø‡‡‡Ø are `AnuktaAvaktavya`'s, another
-- identity's, used unchanged; DNS is from proof theory and no claim is
-- made that the two traditions are talking about one thing.
------------------------------------------------------------------------

module KramaAstiNasti_AnEnumerableRemedySetKillsTheFourthCorner where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_√ó_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Empty as ‚ä• using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

open import AnuktaAvaktavya using (‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï ; ‡§®‡§ø‡§§‡•ç‡§Ø)
open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any ; Enumerated)
open import KramaAstiNasti_TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift
  using (one ; DNSFailure ; fourthCornerGivesDNSFailure)

private
  variable
    A R : Type

------------------------------------------------------------------------
-- 1.  All, and its two directions
------------------------------------------------------------------------

All : (P : A ‚Üí Type) ‚Üí List A ‚Üí Type
All P []       = Unit
All P (x ‚à∑ xs) = P x √ó All P xs

allFromPointwise :
  (P : A ‚Üí Type) ‚Üí ((a : A) ‚Üí P a) ‚Üí (xs : List A) ‚Üí All P xs
allFromPointwise P f []       = tt
allFromPointwise P f (x ‚à∑ xs) = f x , allFromPointwise P f xs

allAtMember :
  (P : A ‚Üí Type) (xs : List A) (a : A)
  ‚Üí All P xs ‚Üí Any (Œª y ‚Üí y ‚â° a) xs ‚Üí P a
allAtMember P []       a _          e       = ‚ä•.rec e
allAtMember P (x ‚à∑ xs) a (p , _)    (inl q) = subst P q p
allAtMember P (x ‚à∑ xs) a (_ , rest) (inr m) = allAtMember P xs a rest m

------------------------------------------------------------------------
-- 2.  The double-negation shift holds over a list
--
-- No decidability, no choice: the negative translation of a finite
-- conjunction is a finite conjunction of negative translations, and
-- the induction is one line.
------------------------------------------------------------------------

finiteDNSList :
  (P : A ‚Üí Type) (xs : List A)
  ‚Üí All (Œª a ‚Üí ¬¨ ¬¨ P a) xs ‚Üí ¬¨ ¬¨ All P xs
finiteDNSList P []       _           k = k tt
finiteDNSList P (x ‚à∑ xs) (nnp , rest) k =
  nnp (Œª p ‚Üí finiteDNSList P xs rest (Œª ap ‚Üí k (p , ap)))

------------------------------------------------------------------------
-- 3.  Hence over an enumerated type
------------------------------------------------------------------------

finiteDNS :
  (Q : R ‚Üí Type) ‚Üí Enumerated R
  ‚Üí ((r : R) ‚Üí ¬¨ ¬¨ Q r) ‚Üí ¬¨ ¬¨ ((r : R) ‚Üí Q r)
finiteDNS {R = R} Q (xs , cov) pointwise k =
  finiteDNSList Q xs (allFromPointwise (Œª r ‚Üí ¬¨ ¬¨ Q r) pointwise xs)
    (Œª allQ ‚Üí k (Œª r ‚Üí allAtMember Q xs r allQ (cov r)))

------------------------------------------------------------------------
-- 4.  So the corner needs a non-enumerable remedy set
------------------------------------------------------------------------

theFourthCornerNeedsANonEnumerableRemedySet :
  (Q : R ‚Üí Type)
  ‚Üí (¬¨ ‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï (one Q)) √ó (¬¨ ‡§®‡§ø‡§§‡•ç‡§Ø (one Q))
  ‚Üí ¬¨ Enumerated R
theFourthCornerNeedsANonEnumerableRemedySet Q corner enum =
  finiteDNS Q enum (fst d) (snd d)
  where
    d : DNSFailure Q
    d = fourthCornerGivesDNSFailure Q corner

------------------------------------------------------------------------
-- ON THE NAME.
-- `KramaSaha_TheFourthCornerIWasNamingIsTheSequentialPosition` proves
-- this line's "fourth corner" is a product of two independent
-- negations and that simultaneous refusal collapses into the
-- sequential pair, so the position is the THIRD bhaga ‚î
-- ‡‡‡Ø‡æ‡‡-‡‡‡‡‡ø-‡®‡æ‡‡‡‡ø, asserted ‡ï‡‡∞‡Æ‡‡ ‚î and not avaktavya.  See also
-- `KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet`.
------------------------------------------------------------------------
