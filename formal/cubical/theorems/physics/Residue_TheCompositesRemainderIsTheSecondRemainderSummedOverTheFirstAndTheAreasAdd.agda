{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡ ‚î the remainder that is KEPT and becomes the material of the next
-- step.  ryabhaa, *ryabhaya*, Gaitapda 32‚ì33 (499), where the
-- kuaka's governing move is exactly that: divide, keep the remainder,
-- recurse on it.
--
-- LIMIT ON THE TERM.  ryabhaa states a descent on integers.  He states
-- nothing whatever about maps of types, fibres, or composition of maps,
-- and none of the theorems below are attributed to him.  ‡‡‡ is borrowed
-- for its exact sense ‚î the part not consumed by the step, carried into
-- the next one ‚î because that is what a fibre of a map is.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS SETTLES.
--
-- `Avaccheda_‚¶.agda` proves the cut decomposition A ‚â Œ[ b ‚àà B ] fibre f b
-- maps composed:
--
--     rank(AB) = rank(B) ‚àí dim(im B ‚à© ker A)                       (11)
--
-- and reads its defect term as an "alignment obstruction" ‚î as though
-- composition failed to be additive, against the fibration's additivity.
--
-- IT IS THE SAME THEOREM.  (11) is rank‚ìnullity applied to A restricted
-- to im B, i.e. it is the fibre decomposition of that restricted map:
-- the defect dim(im B ‚à© ker A) is the DIMENSION OF ITS FIBRE, and the
-- "non-additivity" of composition is the additivity of the fibration read
-- on a different map.  ¬ß‡ß below is the type-theoretic form of that fact,
-- with no linear algebra in it at all:
--
--   ¬ß‡ß  ‡‡‡ : fibre (g ‚àò f) z ‚â Œ[ p ‚àà fibre g z ] fibre f (fst p)
--
--       The remainder of the composite is the remainder of f summed over
--       the remainder of g.  Nothing is lost and nothing is created by
--       composing; the fibres reassemble.
--
--   ¬ß‡®  ‡‡‡‡‡Æ‡‡æ : if f has a uniform remainder ‚î fibre f y ‚â Œ¶ for every
--       y ‚î then fibre (g ‚àò f) z ‚â fibre g z ó Œ¶.  At cardinality this is
--       |fibre(g‚àòf)| = |fibre g| ¬ |Œ¶|, i.e. LOGS ADD.  This is the whole
--       of "area = log of the fibre" under composition, and it is an
--       equivalence, not an inequality.
--
--   ¬ß‡©  ‡‡‡®‡‡Ø‡‡‡ : g ‚àò f has contractible fibres as soon as both do ‚î
--       the composite of two cuts that retain nothing retains nothing.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- CHECKED: Agda 2.8.0 + agda/cubical (the installed version), --cubical
-- --safe, no postulates, no holes.  Exit code reported in the session log.
------------------------------------------------------------------------

module Sesa_TheCompositesRemainderIsTheSecondRemainderSummedOverTheFirstAndTheAreasAdd where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.GroupoidLaws
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.HLevels
open import Cubical.Data.Sigma

private
  variable
    ‚Ñì ‚Ñì' ‚Ñì'' : Level

module _ {X : Type ‚Ñì} {Y : Type ‚Ñì'} {Z : Type ‚Ñì''}
         (g : Y ‚Üí Z) (f : X ‚Üí Y) where

  -- ¬ß‡ß  the composite's remainder, reassembled.
  ‡§∂‡•á‡§∑-Iso : (z : Z) ‚Üí Iso (fiber (Œª x ‚Üí g (f x)) z)
                          (Œ£[ p ‚àà fiber g z ] fiber f (fst p))
  Iso.fun (‡§∂‡•á‡§∑-Iso z) (x , q) = ((f x , q) , (x , refl))
  Iso.inv (‡§∂‡•á‡§∑-Iso z) ((y , p) , (x , r)) = (x , cong g r ‚àô p)
  Iso.rightInv (‡§∂‡•á‡§∑-Iso z) ((y , p) , (x , r)) =
    J (Œª y' r' ‚Üí (p' : g y' ‚â° z) ‚Üí
         Iso.fun (‡§∂‡•á‡§∑-Iso z) (Iso.inv (‡§∂‡•á‡§∑-Iso z) ((y' , p') , (x , r')))
           ‚â° ((y' , p') , (x , r')))
      (Œª p' i ‚Üí ((f x , lUnit p' (~ i)) , (x , refl)))
      r p
  Iso.leftInv (‡§∂‡•á‡§∑-Iso z) (x , q) = cong (x ,_) (sym (lUnit q))

  ‡§∂‡•á‡§∑ : (z : Z) ‚Üí fiber (Œª x ‚Üí g (f x)) z ‚âÉ (Œ£[ p ‚àà fiber g z ] fiber f (fst p))
  ‡§∂‡•á‡§∑ z = isoToEquiv (‡§∂‡•á‡§∑-Iso z)

  -- ¬ß‡®  a uniform remainder: the two remainders multiply, so their logs add.
  ‡§∂‡•á‡§∑‡§∏‡§Æ‡§§‡§æ : {Œ¶ : Type ‚Ñì} ‚Üí ((y : Y) ‚Üí fiber f y ‚âÉ Œ¶) ‚Üí
            (z : Z) ‚Üí fiber (Œª x ‚Üí g (f x)) z ‚âÉ (fiber g z √ó Œ¶)
  ‡§∂‡•á‡§∑‡§∏‡§Æ‡§§‡§æ {Œ¶ = Œ¶} u z =
    compEquiv (‡§∂‡•á‡§∑ z) (Œ£-cong-equiv-snd (Œª p ‚Üí u (fst p)))

  -- ¬ß‡©  no remainder composed with no remainder is no remainder.
  ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§∂‡•á‡§∑ : ((y : Y) ‚Üí isContr (fiber f y)) ‚Üí
             ((z : Z) ‚Üí isContr (fiber g z)) ‚Üí
             (z : Z) ‚Üí isContr (fiber (Œª x ‚Üí g (f x)) z)
  ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§∂‡•á‡§∑ cf cg z =
    isOfHLevelRespectEquiv 0 (invEquiv (‡§∂‡•á‡§∑ z))
      (isOfHLevelŒ£ 0 (cg z) (Œª p ‚Üí cf (fst p)))
