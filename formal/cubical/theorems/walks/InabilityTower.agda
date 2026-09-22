{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- InabilityTower
--
-- `‡‡‡Æ‡∞‡‡‡‡æ ‚í^Œì ‡µ‡ø‡‡‡‡‡‡≤‡ã‡ï‡` -- inability, under Œì, is an extended world.
--
-- The received corpus states the number tower as the canonical instance of
-- the machine's own loop:
--
--     3-5 ‚àâ ‚µ      ‚  -2 ‚àà Œ
--     12 ‚àâ Œ      ‚  ¬Ω ‚àà œ
--     Œæ¬≤=2         ‚  ‚à2 ‚àà œ
--     Œæ¬≤=-1        ‚  Œ ‚àà œ
--
-- Each rung is `‚à ‚í Œ¥ ‚í Œì`: pose an equation, find no solution, adjoin one.
-- This module proves the first rung outright and states the pattern it
-- instantiates, so that the tower is a theorem of the machine rather than an
-- illustration beside it.
--
-- It also encodes two things the corpus asks for by name:
--
--   * **‡‡‡ã‡** -- `‚ü¶‡ó‡ã‚üß = ¬‚ü¶‡‡ó‡ã‚üß`, meaning as exclusion, with its closure
--     `Œ ‚¶ Œ^‚ä‚ä`.  This is the two-sided evaluation `Œµ : œ‚∫ ó œ‚ª ‚í œ` of
--     `‡‡‡` and the Galois connection it generates.  Proved general, for any
--     evaluation whatsoever.
--
--   * **‡‡®‡‡ï‡æ‡®‡‡‡µ‡æ‡¶** -- `ŒΩ ‚ä© œ`, `ŒΩ' ‚ä© ¬œ`, `‚ ‚ä`.  Standpoint-relative
--     assertion without contradiction.  This is *already* the theorem of
--     `ObstructionCalculus`: the two standpoints are two
--     observation fields, and the pair they disagree about is `6 , -6`.  The
--     corollary is one line and it is recorded here because naming the
--     identification is the point.
------------------------------------------------------------------------

module InabilityTower where

open import Cubical.Foundations.Prelude

open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_ ; injSuc ; snotz)
open import Cubical.Data.Int using (‚Ñ§ ; pos ; negsuc ; posNotnegsuc)
  renaming (_+_ to _+‚Ñ§_)
open import Cubical.Relation.Nullary using (¬¨_)

open import ObstructionCalculus
  using (Obs ; Sep ; Blind ; absField ; signField ; sign-blind ; sign-seen)

private
  variable
    A B : Type‚ÇÄ

------------------------------------------------------------------------
-- A.  Inability, and the extension it forces.

-- `‚à`: a question posed inside a structure.  `Œ¥`: it has no answer there.
Unsolvable : (A : Type‚ÇÄ) (P : A ‚Üí Type‚ÇÄ) ‚Üí Type‚ÇÄ
Unsolvable A P = ¬¨ (Œ£ A P)

-- `Œì`: a larger structure, an embedding, and an answer.
record Adjoins (A B : Type‚ÇÄ) (Œπ : A ‚Üí B) (P : A ‚Üí Type‚ÇÄ) (Q : B ‚Üí Type‚ÇÄ)
       : Type‚ÇÄ where
  constructor adjoins
  field
    unsolvable : Unsolvable A P
    solution : Œ£ B Q
    fresh : ¬¨ (Œ£[ a ‚àà A ] Œπ a ‚â° solution .fst)

-- The content of `Œì` is the third field: the witness that answers the question
-- is *not* in the old world.  Without it, `Adjoins` would be satisfied by any
-- structure that merely restates the question, and `‡µ‡ø‡‡‡‡‡‡≤‡ã‡ï‡` would be
-- decoration.  With it, the extension is forced to be strict.

------------------------------------------------------------------------
-- B.  The first rung, proved.  `3-5 ‚àâ ‚µ ‚ -2 ‚àà Œ`.

-- The question: what must be added to 5 to give 3?
SubDefect : ‚Ñï ‚Üí Type‚ÇÄ
SubDefect n = 5 + n ‚â° 3

-- `Œ¥ ‚â† 0`: nothing in ‚ï answers it.  Three peels of `suc`, then `znots`.
sub-unsolvable : Unsolvable ‚Ñï SubDefect
sub-unsolvable (n , p) = snotz (injSuc (injSuc (injSuc p)))

-- The same question in ‚.
SubSolved : ‚Ñ§ ‚Üí Type‚ÇÄ
SubSolved z = pos 5 +‚Ñ§ z ‚â° pos 3

-- `Œì‚ü®Œ¥‚ü©`: the answer is `-2`, and it is new -- no natural number maps to it.
sub-solution : Œ£ ‚Ñ§ SubSolved
sub-solution = negsuc 1 , refl

sub-fresh : ¬¨ (Œ£[ n ‚àà ‚Ñï ] pos n ‚â° negsuc 1)
sub-fresh (n , p) = posNotnegsuc n 1 p

-- The rung, assembled.  This is `‚à ‚í Œ¥ ‚í Œì` on the oldest example there is.
‚Ñï‚äÇ‚Ñ§ : Adjoins ‚Ñï ‚Ñ§ pos SubDefect SubSolved
‚Ñï‚äÇ‚Ñ§ = adjoins sub-unsolvable sub-solution sub-fresh

------------------------------------------------------------------------
-- C.  ‡‡‡ã‡: meaning as exclusion, and its closure.
--
-- `Œµ : œ‚∫ ó œ‚ª ‚í œ` is a two-sided evaluation -- witnesses against
-- counter-witnesses, terms against contexts, states against experiments.  Any
-- such evaluation generates a Galois connection, and the closure `Œ ‚¶ Œ^‚ä‚ä`
-- is the apoha operator: a term means the set of things that fail to exclude
-- everything it fails to exclude.
--
-- Nothing is assumed about `Œµ`.  This is the general fact.

-- RELATION TO `Apoha`.  `Apoha` carries apoha as *witnessed separation*:
-- `Ind` (every observation agrees) against `Sep` (some observation excludes,
-- and you hold it), with the constructive gap between them located exactly --
-- the negative forms always agree, the witnessed one needs finiteness or MP.
-- That is the deeper half.
--
-- What is below is the other half and does not appear there: the *closure*.
-- `S04Apoha` asks when a separating observation can be produced;
-- `Apoha` below asks what a set of witnesses means once produced, and answers
-- that the exclusion operator is a Galois connection whose double dual is
-- idempotent.  The two compose: S04 supplies the witness, this closes on it.

module Apoha {X Y : Type‚ÇÄ} (Œµ : X ‚Üí Y ‚Üí Type‚ÇÄ) where

  -- What every member of `Œ` passes.
  _‚Å∫ : (X ‚Üí Type‚ÇÄ) ‚Üí (Y ‚Üí Type‚ÇÄ)
  Œ± ‚Å∫ = Œª y ‚Üí (x : X) ‚Üí Œ± x ‚Üí Œµ x y

  -- What passes every member of `Œ≤`.
  _‚Åª : (Y ‚Üí Type‚ÇÄ) ‚Üí (X ‚Üí Type‚ÇÄ)
  Œ≤ ‚Åª = Œª x ‚Üí (y : Y) ‚Üí Œ≤ y ‚Üí Œµ x y

  -- `Œ ‚ä Œ^‚ä‚ä`: the closure only ever adds.
  unit : (Œ± : X ‚Üí Type‚ÇÄ) (x : X) ‚Üí Œ± x ‚Üí ((Œ± ‚Å∫) ‚Åª) x
  unit Œ± x ax y Œ≤y = Œ≤y x ax

  -- Dually on the other side.
  counit : (Œ≤ : Y ‚Üí Type‚ÇÄ) (y : Y) ‚Üí Œ≤ y ‚Üí ((Œ≤ ‚Åª) ‚Å∫) y
  counit Œ≤ y by x Œ±x = Œ±x y by

  -- Order-reversal, both directions.
  ‚Å∫-anti : (Œ± Œ±‚Ä≤ : X ‚Üí Type‚ÇÄ) ‚Üí ((x : X) ‚Üí Œ± x ‚Üí Œ±‚Ä≤ x)
         ‚Üí (y : Y) ‚Üí (Œ±‚Ä≤ ‚Å∫) y ‚Üí (Œ± ‚Å∫) y
  ‚Å∫-anti Œ± Œ±‚Ä≤ sub y h x ax = h x (sub x ax)

  ‚Åª-anti : (Œ≤ Œ≤‚Ä≤ : Y ‚Üí Type‚ÇÄ) ‚Üí ((y : Y) ‚Üí Œ≤ y ‚Üí Œ≤‚Ä≤ y)
         ‚Üí (x : X) ‚Üí (Œ≤‚Ä≤ ‚Åª) x ‚Üí (Œ≤ ‚Åª) x
  ‚Åª-anti Œ≤ Œ≤‚Ä≤ sub x h y by = h y (sub y by)

  -- Idempotence: `Œ^‚ä‚ä‚ä = Œ^‚ä`, so the closure closes.  This is why apoha is
  -- a *meaning* and not merely a step -- iterating exclusion stabilizes after
  -- one round.
  ‚Å∫-idem-to : (Œ± : X ‚Üí Type‚ÇÄ) (y : Y) ‚Üí (Œ± ‚Å∫) y ‚Üí ((((Œ± ‚Å∫) ‚Åª) ‚Å∫)) y
  ‚Å∫-idem-to Œ± = counit (Œ± ‚Å∫)

  ‚Å∫-idem-from : (Œ± : X ‚Üí Type‚ÇÄ) (y : Y) ‚Üí ((((Œ± ‚Å∫) ‚Åª) ‚Å∫)) y ‚Üí (Œ± ‚Å∫) y
  ‚Å∫-idem-from Œ± y h = ‚Å∫-anti Œ± (((Œ± ‚Å∫) ‚Åª)) (unit Œ±) y h

------------------------------------------------------------------------
-- D.  ‡‡®‡‡ï‡æ‡®‡‡‡µ‡æ‡¶, as a corollary of the observation-field theorem.
--
-- `ŒΩ ‚ä© œ` and `ŒΩ‚≤ ‚ä© ¬œ` without `‚ä`: two standpoints assign opposite verdicts
-- to one pair, and nothing breaks, because a verdict is relative to the field
-- that issues it.  `ObstructionCalculus` proved the general form; here it is
-- named.

standpoint-relative :
    Blind absField (pos 6) (negsuc 5)
  √ó Sep signField (pos 6) (negsuc 5)
standpoint-relative = sign-blind , sign-seen

-- The corpus's own gloss, `‡µ‡‡‡‡ ‚â† ‡‡ï‡®‡Ø‡‡‡∞‡‡‡®‡ø‡∞‡‡‡Ø‡` -- the object is not the
-- complete verdict of one standpoint -- is exactly `break-blindness`: no field
-- is final, so no field's verdict is the object's.
