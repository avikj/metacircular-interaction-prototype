{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡µ‡‡‡‡‡ø ‚î ‡‡®‡‡‡ã‡ ‡‡µ‡‡‡‡‡ø‡ ‡‡µ ‡‡ô‡‡ñ‡‡Ø‡æ ‡
--
-- (the fiber's recurrence is exactly the count.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE CLASS THIS PRICES, AND WHY IT NEEDED A DIFFERENT MACHINE.
--
-- `interactive/Lopa_‚¶hs` grades 1062 one-way edges; **237 have source ‚ï or a
-- list-like type** and no case table will ever reach them, because their
-- domains are infinite.  A finite source is swept by enumeration.  An
-- infinite one has to be priced by an IDENTIFICATION, and the only
-- identification available for a map defined by structural recursion is
-- a RECURRENCE ON ITS FIBER, read off the map's own clauses.
--
-- Two such were proved by hand in this corpus before anyone noticed they
-- were one thing:
--
--   `Lopa_‚¶.fiber ‡Ø‡ã‡ó n ‚â SumFin (suc n)`      ‚î addition's antidiagonal
--   `PingalaPrastara.matrameruIso`
--        : Metre (2+n) ‚â Metre (1+n) ‚ä Metre n  ‚î the ‡Æ‡æ‡‡‡∞‡æ‡Æ‡‡∞‡
--
-- Both are the same move: the map's clauses say what the first
-- constructor costs, so the fiber over `n` decomposes by which
-- constructor came first, over fibers at smaller indices.  **That is the
-- emitter for the whole infinite-domain class**, and this module is its
-- clean case.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED.
--
-- ¬ß‡ß  the general recurrence, for ANY element type: the fiber of `length`
--     over a successor is the element type times the fiber below it.
--     `fiber length (suc n) ‚â X ó fiber length n`.  Nothing about `X` is
--     assumed ‚î not finiteness, not decidable equality, not an h-level.
-- ¬ß‡®  the base: `fiber length 0 ‚â Unit`.  Only `[]` is empty.
-- ¬ß‡©  Pigala's instance, for `varna` as the host actually writes it ‚î
--     and it is not `length` by definition, it is a separate recursion
--     with the same clauses, so the recurrence is re-proved rather than
--     transported, and ¬ß‡© says so.
-- ¬ß‡  **the payoff, and it is the point**: `sankhya (suc n) ‚â° sankhya n +
--     sankhya n` is the DOUBLING Pigala states, and ¬ß‡ß is WHY ‚î the
--     fiber over `suc n` is a two-element type times the fiber over `n`,
--     because a syllable is ‡≤‡ò‡ or ‡ó‡‡∞‡ and nothing else.  The count's
--     recurrence is the fiber's recurrence.  ‡‡®‡‡¶‡‡‡æ‡‡‡‡‡∞‡Æ‡ ‡Æ.‡®‡‚ì‡®‡Æ
--     gives the procedure; this gives the reason the procedure is right.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- TERM.  ‡‡µ‡‡‡‡‡ø ‚î turning-back, repetition, recurrence.  Ordinary
-- , and the tradition's own word for the construction rule of
-- the ‡Æ‡‡∞‡‡‡‡∞‡‡‡‡æ‡∞ as ‡‡≤‡æ‡Ø‡‡ß states it in the ‡Æ‡‡‡‡û‡‡‡‡µ‡®‡ (10th c.) on
-- ‡‡ø‡ô‡‡ó‡≤'s ‡‡®‡‡¶‡‡‡æ‡‡‡‡‡∞‡Æ‡ ‡Æ.‡©‡‚ì‡©‡: ‡‡ó‡‡∞‡ø‡Æ-‡‡ô‡‡ï‡‡‡ø‡ ‡‡‡∞‡‡µ-‡‡ô‡‡ï‡‡‡‡
-- ‡‡æ‡∞‡‡‡‡µ-‡Ø‡ã‡ó‡à‡ ‚î the next row from the adjacent sums of the previous.
-- Usually cited under Pascal's name (1654), a restatement six centuries
-- later, named here after the source and as one.
--
-- LIMIT: Pigala and Halyudha state procedures and prove nothing below;
-- no source states a fiber, a type, or an equivalence.  What is claimed
-- is that the objects the pratyayas enumerate ARE the fibers of the
-- counting maps ‚î a fact about the definitions in `PingalaPrastara.agda`.
------------------------------------------------------------------------

module Avrtti_TheFiberOfACountingMapSatisfiesARecurrenceAndThatRecurrenceIsSankhya where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Data.Sigma
open import Cubical.Data.Nat
open import Cubical.Data.List using (List ; [] ; _‚à∑_ ; length)
open import Cubical.Data.Unit
open import Cubical.Data.Empty renaming (rec to ‚ä•-rec)

open import PingalaPrastara using (Syllable ; laghu ; guru ; Pattern ; varna ; Vak ; sankhya)

private variable ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ The recurrence.  No hypothesis on the element type at all.
------------------------------------------------------------------------

module _ {X : Type ‚Ñì} where

  ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : (n : ‚Ñï) ‚Üí fiber (length {A = X}) (suc n) ‚âÉ (X √ó fiber (length {A = X}) n)
  ‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É n = isoToEquiv (iso ‡§≠‡§ô‡•ç‡§ó‡§É ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É)
    where
    ‡§≠‡§ô‡•ç‡§ó‡§É : fiber (length {A = X}) (suc n) ‚Üí X √ó fiber (length {A = X}) n
    ‡§≠‡§ô‡•ç‡§ó‡§É ([]     , p) = ‚ä•-rec (znots p)
    ‡§≠‡§ô‡•ç‡§ó‡§É (x ‚à∑ xs , p) = x , (xs , injSuc p)

    ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É : X √ó fiber (length {A = X}) n ‚Üí fiber (length {A = X}) (suc n)
    ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É (x , (xs , q)) = (x ‚à∑ xs) , cong suc q

    ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : (y : X √ó fiber (length {A = X}) n) ‚Üí ‡§≠‡§ô‡•ç‡§ó‡§É (‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É y) ‚â° y
    ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É (x , (xs , q)) =
      Œ£PathP (refl , Œ£‚â°Prop (Œª _ ‚Üí isSet‚Ñï _ _) refl)

    ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : (y : fiber (length {A = X}) (suc n)) ‚Üí ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É (‡§≠‡§ô‡•ç‡§ó‡§É y) ‚â° y
    ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É ([]     , p) = ‚ä•-rec (znots p)
    ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É (x ‚à∑ xs , p) = Œ£‚â°Prop (Œª _ ‚Üí isSet‚Ñï _ _) refl

------------------------------------------------------------------------
-- ‡® ¬ The base.  Only the empty list is empty.
------------------------------------------------------------------------

  ‡§Æ‡•Ç‡§≤‡§Æ‡•ç : fiber (length {A = X}) 0 ‚âÉ Unit
  ‡§Æ‡•Ç‡§≤‡§Æ‡•ç = isoToEquiv (iso _ (Œª _ ‚Üí [] , refl) (Œª _ ‚Üí refl) ‡§∞)
    where
    ‡§∞ : (y : fiber (length {A = X}) 0) ‚Üí ([] , refl) ‚â° y
    ‡§∞ ([]     , p) = Œ£‚â°Prop (Œª _ ‚Üí isSet‚Ñï _ _) refl
    ‡§∞ (x ‚à∑ xs , p) = ‚ä•-rec (snotz p)

------------------------------------------------------------------------
-- ‡© ¬ Pi‡óala's instance, RE-PROVED and not transported.
--
-- `varna` is a separate recursion with the same clauses as `length`, so
-- they are not definitionally one function.  The recurrence is therefore
-- established again here for `varna` itself ‚î three lines, and honest ‚î
-- rather than moved across an identification nobody has written.
------------------------------------------------------------------------

‡§µ‡§æ‡§ï‡•ç-‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : (n : ‚Ñï) ‚Üí Vak (suc n) ‚âÉ (Syllable √ó Vak n)
‡§µ‡§æ‡§ï‡•ç-‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É n = isoToEquiv (iso ‡§≠ ‡§∏ ‡§®‡§ø ‡§™‡•ç‡§∞)
  where
  ‡§≠ : Vak (suc n) ‚Üí Syllable √ó Vak n
  ‡§≠ ([]     , p) = ‚ä•-rec (znots p)
  ‡§≠ (s ‚à∑ ps , p) = s , (ps , injSuc p)

  ‡§∏ : Syllable √ó Vak n ‚Üí Vak (suc n)
  ‡§∏ (s , (ps , q)) = (s ‚à∑ ps) , cong suc q

  ‡§®‡§ø : (y : Syllable √ó Vak n) ‚Üí ‡§≠ (‡§∏ y) ‚â° y
  ‡§®‡§ø (s , (ps , q)) = Œ£PathP (refl , Œ£‚â°Prop (Œª _ ‚Üí isSet‚Ñï _ _) refl)

  ‡§™‡•ç‡§∞ : (y : Vak (suc n)) ‚Üí ‡§∏ (‡§≠ y) ‚â° y
  ‡§™‡•ç‡§∞ ([]     , p) = ‚ä•-rec (znots p)
  ‡§™‡•ç‡§∞ (s ‚à∑ ps , p) = Œ£‚â°Prop (Œª _ ‚Üí isSet‚Ñï _ _) refl

------------------------------------------------------------------------
-- ‡ ¬ Why ‡‡ô‡‡ñ‡‡Ø‡æ doubles.
--
-- `sankhya (suc n) = sankhya n + sankhya n` is what Pigala states.  ¬ß‡©
-- is the reason: the fiber over `suc n` is `Syllable ó (fiber over n)`,
-- and a syllable is ‡≤‡ò‡ or ‡ó‡‡∞‡ and nothing else.  **The count's
-- recurrence IS the fiber's recurrence** ‚î the procedure and its ground,
-- separated by twenty-three centuries and now in one file.
--
-- Stated as the definitional fact it is, so nothing is overclaimed: the
-- doubling holds by `sankhya`'s own clauses, and ¬ß‡© is what makes it the
-- right definition rather than a stipulation.
------------------------------------------------------------------------

‡§∏‡§ô‡•ç‡§ñ‡•ç‡§Ø‡§æ-‡§¶‡•ç‡§µ‡•à‡§ó‡•Å‡§£‡•ç‡§Ø‡§Æ‡•ç : (n : ‚Ñï) ‚Üí sankhya (suc n) ‚â° sankhya n + sankhya n
‡§∏‡§ô‡•ç‡§ñ‡•ç‡§Ø‡§æ-‡§¶‡•ç‡§µ‡•à‡§ó‡•Å‡§£‡•ç‡§Ø‡§Æ‡•ç n = refl

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡ ‚î the next rung, named rather than gestured at.
--
-- `length` charges exactly one per constructor, so ¬ß‡ß has no truncated
-- subtraction and no guard.  A WEIGHTED counting map does: `matraOf`
-- charges 1 for ‡≤‡ò‡ and 2 for ‡ó‡‡∞‡, so its fiber over `n` decomposes as
-- the fiber over `n ‚à 1` plus the fiber over `n ‚à 2`, and each summand
-- needs a proof that the weight fits.  That is exactly
-- `PingalaPrastara.matrameruIso`, proved by hand; the general
-- weighted emitter is `Bharavrtti_TheWeightedCountingMapsFiberDecomposesByHeadWeightAndTheNilCaseIsASeparateSummand.agda`.
--
-- The general shape: for `f : List X ‚í ‚ï` with
-- `f [] = 0` and `f (x ‚à xs) = w x + f xs`,
-- the nil case is a SEPARATE SUMMAND and the decomposition is a coproduct:
--
--     fiber f n ‚â (0 ‚â° n) ‚ä (Œ[ x ‚àà X ] Œ[ xs ‚àà List X ] (w x + f xs ‚â° n))
--
-- `f (x ‚à xs)` REDUCES to `w x + f xs`, so
-- the path is carried across unchanged and both round trips close by
-- `refl`.  The cons summand is equivalently
--     Œ[ x ‚àà X ] Œ[ m ‚àà ‚ï ] (w x + m ‚â° n) ó fiber f m
-- since `Œ[ m ] (f xs ‚â° m) ó ‚¶`
-- carries a contractible `singl (f xs)`.
-- The rung is above ¬ß‡ß because the codomain splits, not because
-- fitting proofs must be built.
