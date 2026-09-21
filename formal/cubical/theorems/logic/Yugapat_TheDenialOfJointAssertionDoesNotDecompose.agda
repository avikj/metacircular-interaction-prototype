{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Yugapat_TheDenialOfJointAssertionDoesNotDecompose
--
-- ‡Ø‡‡ó‡‡‡ ¬ yugapat ‚î "at once", the Jaina term for the simultaneous
-- mode of predication, paired with ‡ï‡‡∞‡Æ ¬ krama, "in sequence"
-- (saptabhag: Umsvti, *Tattvrthastra*; Samantabhadra; Akalaka;
-- Siddhasena Divkara).  The distinction is theirs and so is its
-- formalisation in this repository: `Saptabhangi` and
-- `SaptabhangiNaya`, ANOTHER IDENTITY'S modules, define the mode as a
-- DATATYPE `‡‡∞‡‡‡` ‚î a parameter of the predication ‚î and prove
-- ‡‡‡Ø‡æ‡‡-‡‡‡‡‡ø-‡®‡æ‡‡‡‡ø ‚â ‡‡‡Ø‡æ‡‡-‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡.  **Their `‡‡∞‡‡‡` is IMPORTED
-- below, not rebuilt**, and nothing here is a claim about their
-- theorem.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- A CORRECTION OF MY OWN CLAIM.
--
-- `KramaSaha_TheFourthCornerIWasNamingIsTheSequentialPosition`
-- concluded:
--
--   "this formalism, as it stands, cannot express avaktavya at all:
--    every position it can name is reachable sequentially."
--
-- **That was too strong, and the reason is a De Morgan asymmetry I did
-- not check.**  What that module proved is that DENYING BOTH collapses:
-- `¬ (A ‚ä B)` and `(¬ A) ó (¬ B)` are interderivable.  It does not
-- follow that every position collapses, because the OTHER De Morgan
-- law runs only one way constructively: `((¬ A) ‚ä (¬ B)) ‚í ¬ (A ó B)`
-- always, and the converse does not.
--
-- So there IS a position in my formalism that is not a sequential pair:
-- **the denial of the JOINT assertion**, `¬ (‡‡æ‡Æ‡Ø‡ø‡ï ó ‡®‡ø‡‡‡Ø)`, which
-- says the two cannot hold together without saying which fails.  That
-- is the shape yugapat has in the tradition ‚î a single act about the
-- pair, not two acts ‚î and it is exactly what a product of denials
-- cannot express.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   Assert m Q          the mode-parameterised predication over MY
--                       instance family, indexed by their `‡‡∞‡‡‡`:
--                       ‡ï‡‡∞‡Æ‡ gives the sequential pair of denials,
--                       ‡‡‡ the denial of the joint assertion
--   kramaGivesYugapat   the sequential position implies the
--                       simultaneous one ‚î one line, and unconditional
--   yugapatDecompositionGivesWeakExcludedMiddle
--                       the CONVERSE, as a general principle, implies
--                       weak excluded middle: from
--                       `(A B : Type) ‚í ¬ (A ó B) ‚í ((¬ A) ‚ä (¬ B))`,
--                       taking `B := ¬ A`, one gets `¬ A ‚ä ¬ ¬ A` for
--                       every `A`
--
-- **So the two modes are not interderivable here for a reason with a
-- name.**  The direction that fails is not an accident of my encoding;
-- decomposing a denial-of-conjunction is a known constructive taboo,
-- and this module reduces it to that taboo rather than asserting it.
-- The parallel with the rest of this line is exact: the fourth-corner
-- work reduced a position to failure of the double-negation shift,
-- another principle that is classically trivial and constructively not.
------------------------------------------------------------------------

module Yugapat_TheDenialOfJointAssertionDoesNotDecompose where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Sigma using (_√ó_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬¨_)

open import Saptabhangi using (‡§Ü‡§∞‡•ç‡§™‡§£ ; ‡§ï‡•ç‡§∞‡§Æ‡§É ; ‡§∏‡§π‡§É)
open import AnuktaAvaktavya using (‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï ; ‡§®‡§ø‡§§‡•ç‡§Ø)
open import KramaAstiNasti_TheFourthCornerAtOneInstanceIsExactlyTheDoubleNegationShift
  using (one)

private
  variable
    R : Type

------------------------------------------------------------------------
-- 1.  The mode is a parameter, as it is in their construction
------------------------------------------------------------------------

Assert : ‡§Ü‡§∞‡•ç‡§™‡§£ ‚Üí (R ‚Üí Type) ‚Üí Type
Assert ‡§ï‡•ç‡§∞‡§Æ‡§É Q = (¬¨ ‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï (one Q)) √ó (¬¨ ‡§®‡§ø‡§§‡•ç‡§Ø (one Q))
Assert ‡§∏‡§π‡§É  Q = ¬¨ (‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï (one Q) √ó ‡§®‡§ø‡§§‡•ç‡§Ø (one Q))

------------------------------------------------------------------------
-- 2.  Sequential implies simultaneous, for nothing
------------------------------------------------------------------------

kramaGivesYugapat : (Q : R ‚Üí Type) ‚Üí Assert ‡§ï‡•ç‡§∞‡§Æ‡§É Q ‚Üí Assert ‡§∏‡§π‡§É Q
kramaGivesYugapat Q (ns , nn) both = ns (fst both)

------------------------------------------------------------------------
-- 3.  ‚¶and the converse is a constructive taboo
------------------------------------------------------------------------

yugapatDecompositionGivesWeakExcludedMiddle :
  ((A B : Type) ‚Üí ¬¨ (A √ó B) ‚Üí ((¬¨ A) ‚äé (¬¨ B)))
  ‚Üí (A : Type) ‚Üí (¬¨ A) ‚äé (¬¨ (¬¨ A))
yugapatDecompositionGivesWeakExcludedMiddle dec A =
  dec A (¬¨ A) (Œª p ‚Üí snd p (fst p))

------------------------------------------------------------------------
-- Whether there is a
-- THIRD position between the sequential pair and the denial of the
-- joint assertion is answered in
-- `Bhanga_ThePositionsOverTwoAtomsAreAThreeStepChain`.  There is:
--
--   Krama = (¬ ‡‡æ‡Æ‡Ø‡ø‡ï) ó (¬ ‡®‡ø‡‡‡Ø)
--     ‚í Vikalpa = (¬ ‡‡æ‡Æ‡Ø‡ø‡ï) ‚ä (¬ ‡®‡ø‡‡‡Ø)
--       ‚í Yugapat = ¬ (‡‡æ‡Æ‡Ø‡ø‡ï ó ‡®‡ø‡‡‡Ø)
--
-- **and the two gaps are of different KINDS.**  Krama ‚ää Vikalpa is
-- settled outright by an example ‚î at the trivially-true family
-- `¬ ‡‡æ‡Æ‡Ø‡ø‡ï` holds while `¬ ‡®‡ø‡‡‡Ø` fails ‚î so it is a fact about my
-- instance family.  Vikalpa ‚ê Yugapat is not about the family at all:
-- it is the constructive taboo proved here, and no example can settle
-- it inside `--safe`.
--
-- That distinction is the useful part.  A count of positions says less
-- than the character of the gaps between them: one is refutable, one is
-- only reducible.
------------------------------------------------------------------------
