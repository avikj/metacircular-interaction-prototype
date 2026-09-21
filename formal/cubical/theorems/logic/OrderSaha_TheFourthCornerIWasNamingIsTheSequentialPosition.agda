{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- KramaSaha_TheFourthCornerIWasNamingIsTheSequentialPosition
--
-- ‡ï‡‡∞‡Æ / ‡‡ (‡Ø‡‡ó‡‡¶‡) ‚î krama, in sequence; saha or yugapad, at once.
-- The distinction is the Jaina one, from the saptabhag literature
-- (Umsvti, *Tattvrthastra*; Samantabhadra; Akalaka; Siddhasena
-- Divkara), and in this repository it is `Saptabhangi` /
-- `SaptabhangiNaya` ‚î ANOTHER IDENTITY'S modules, written in
-- Devanagari ‚î that prove the theorem being used here as a lens:
--
--   ‡‡‡Ø‡æ‡‡-‡‡‡‡‡ø-‡®‡æ‡‡‡‡ø ‚â ‡‡‡Ø‡æ‡‡-‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡
--
-- sequential assertion of asti and nsti is NOT the simultaneous
-- position; avaktavya is a fourth, irreducibly distinct bhaga.  That
-- result is theirs.  Nothing here restates or reproves it, and nothing
-- here is a claim about their construction.  What is done here is to
-- turn it on MY OWN objects, which is what a lens is for.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE FINDING.
--
-- My "fourth corner" is, by its definition,
--
--   (¬ ‡‡æ‡Æ‡Ø‡ø‡ï (one Q)) ó (¬ ‡®‡ø‡‡‡Ø (one Q))
--
-- a PRODUCT of two negations.  Three things are checked below:
--
--   1. the two conjuncts are INDEPENDENT ‚î each is satisfiable while
--      the other fails, so the pair is genuinely "one, and also the
--      other", which is krama;
--   2. **the simultaneous denial collapses to the sequential pair**:
--      `¬ (A ‚ä B) ‚í (¬ A) ó (¬ B)` and back, constructively, with no
--      hypothesis ‚î so in this formalism "denying both at once" IS
--      "denying one and denying the other", and there is no room
--      between them;
--   3. hence my formalism, as it stands, cannot express avaktavya at
--      all: every position it can name is reachable sequentially.
--
-- By the theorem those modules'
-- author proved, the fourth bhaga is exactly what a sequential
-- position is not ‚î and mine is a product, which is sequential.  On
-- present evidence my corner sits at the THIRD bhaga,
-- ‡‡‡Ø‡æ‡‡-‡‡‡‡‡ø-‡®‡æ‡‡‡‡ø, the krama position.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- Nothing here touches `AnuktaAvaktavya`, `Saptabhangi` or
-- `SaptabhangiNaya`; `‡‡æ‡Æ‡Ø‡ø‡ï` and `‡®‡ø‡‡‡Ø` are imported as instances, as
-- they have been on this line throughout.
------------------------------------------------------------------------

module KramaSaha_TheFourthCornerIWasNamingIsTheSequentialPosition where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Sigma using (_√ó_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty as ‚ä• using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

open import AnuktaAvaktavya using (‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï ; ‡§®‡§ø‡§§‡•ç‡§Ø)
open import KramaAstiNasti_TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift
  using (one)

------------------------------------------------------------------------
-- 1.  Simultaneous denial collapses to sequential denial
------------------------------------------------------------------------

sahaToKrama : {A B : Type} ‚Üí ¬¨ (A ‚äé B) ‚Üí (¬¨ A) √ó (¬¨ B)
sahaToKrama h = (Œª a ‚Üí h (inl a)) , (Œª b ‚Üí h (inr b))

kramaToSaha : {A B : Type} ‚Üí (¬¨ A) √ó (¬¨ B) ‚Üí ¬¨ (A ‚äé B)
kramaToSaha (na , nb) (inl a) = na a
kramaToSaha (na , nb) (inr b) = nb b

------------------------------------------------------------------------
-- 2.  ‚¶and the corner is exactly that collapse, at my objects
------------------------------------------------------------------------

Corner : {R : Type} ‚Üí (R ‚Üí Type) ‚Üí Type
Corner Q = (¬¨ ‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï (one Q)) √ó (¬¨ ‡§®‡§ø‡§§‡•ç‡§Ø (one Q))

cornerIsDenyingBothAtOnce :
  {R : Type} (Q : R ‚Üí Type)
  ‚Üí (¬¨ (‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï (one Q) ‚äé ‡§®‡§ø‡§§‡•ç‡§Ø (one Q)) ‚Üí Corner Q)
  √ó (Corner Q ‚Üí ¬¨ (‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï (one Q) ‚äé ‡§®‡§ø‡§§‡•ç‡§Ø (one Q)))
cornerIsDenyingBothAtOnce Q = sahaToKrama , kramaToSaha

------------------------------------------------------------------------
-- 3.  The two conjuncts are independent
--
-- `¬ ‡‡æ‡Æ‡Ø‡ø‡ï (one Q)` is pointwise non-refutability and
-- `¬ ‡®‡ø‡‡‡Ø (one Q)` is the absence of a uniform proof.  Each holds
-- while the other fails, so the corner really is a conjunction of two
-- separately assertible positions.
------------------------------------------------------------------------

trivial : Unit ‚Üí Type
trivial _ = Unit

firstAloneHolds : ¬¨ ‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï (one trivial)
firstAloneHolds f = snd (f tt) tt

secondFailsThere : ¬¨ (¬¨ ‡§®‡§ø‡§§‡•ç‡§Ø (one trivial))
secondFailsThere k = k (Œª r ‚Üí tt , tt)

alwaysFalse : Unit ‚Üí Type
alwaysFalse _ = ‚ä•

secondAloneHolds : ¬¨ ‡§®‡§ø‡§§‡•ç‡§Ø (one alwaysFalse)
secondAloneHolds f = snd (f tt)

firstFailsThere : ¬¨ (¬¨ ‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï (one alwaysFalse))
firstFailsThere k = k (Œª _ ‚Üí tt , (Œª e ‚Üí e))

------------------------------------------------------------------------
-- **THE CONCLUSION ABOVE IS TOO STRONG.**  The block above says "this formalism, as it stands, cannot
-- express avaktavya at all: every position it can name is reachable
-- sequentially."  What is actually proved above is narrower: DENYING
-- BOTH collapses, because `¬ (A ‚ä B)` and `(¬ A) ó (¬ B)` are
-- interderivable.
--
-- The other De Morgan law runs only one way constructively.  `Yugapat_TheDenialOfJointAssertionDoesNotDecompose`
-- exist: `¬ (‡‡æ‡Æ‡Ø‡ø‡ï ó ‡®‡ø‡‡‡Ø)` ‚î the denial of the JOINT assertion,
-- which says the two cannot hold together without saying which fails.
-- `kramaGivesYugapat` shows the sequential position implies it, and
-- `yugapatDecompositionGivesWeakExcludedMiddle` shows the converse, as
-- a general principle, yields weak excluded middle.  So the gap is a
-- named constructive taboo, not an accident of encoding.
------------------------------------------------------------------------
