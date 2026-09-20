{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡∞‡ø‡µ‡∞‡‡‡Ø‡ã‡ó‡ ‚î the double sum interchanges, and pushforward composes
-- on rectangles.
--
-- TERM.  ‡‡∞‡ø‡µ‡∞‡‡ (interchange, turning about) and ‡Ø‡ã‡ó (sum, as in the
-- measure lane's ‡Ø‡ã‡ó‡‡≤/‡‡æ‡ñ‡ø‡‡Ø‡ã‡ó‡ vocabulary).  The compound ‡‡∞‡ø‡µ‡∞‡‡-‡Ø‡ã‡ó
-- is built here; no source is claimed for it.
--
-- SEED.  The owner's transmission of 2026-08-23 ("causal horizon"):
-- "the next finite theorem is Fubini as transport."  The full statement
-- ‚î g_!(f_!w) ‚â° (g‚àòf)_!w across the fibre-composition equivalence ‡‡‡
-- (fc/Sesa_TheCompositesRemainder‚¶:92) ‚î needs fibre ENUMERATIONS,
-- which the corpus does not yet carry for arbitrary maps.  What is
-- landable exactly, today, is the RECTANGULAR case, which is also the
-- interchange law the span/path-integral reading consumes first:
--
--     Œ_y Œ_z w(y,z)  ‚â°  Œ_z Œ_y w(y,z)
--
-- over nonempty SumFin index types, spending exactly associativity and
-- commutativity ‚î the same two laws ‡ï‡‡∞‡Æ‡®‡à‡∞‡‡‡ï‡‡‡‡Ø‡Æ‡ spends, and no
-- more.  On a rectangle X = Fin(1+a) ó Fin(1+b) with the two
-- projections as observations, the nested totals ARE f_! then g_!, so
-- this theorem is pushforward functoriality for the product square ‚î
-- the case where both fibres are constant.  The general fib version
-- remains owed and is named in the ledger.
--
-- WHAT IS PROVED.
--
--   ‡µ‡ø‡‡æ‡‡®‡Æ‡     the pointwise sum splits across a total:
--                total (Œª z ‚í f z +µ g z) ‚â° total f +µ total g.
--                This is the "abides" law; it is where assoc and comm
--                are spent, through the four-point exchange ‡µ‡ø‡®‡ø‡Æ‡Ø‡.
--   ‡‡∞‡ø‡µ‡∞‡‡‡      THE INTERCHANGE: the two nesting orders of the double
--                total agree, for every rectangular weight family.
--
------------------------------------------------------------------------

module ParivartaYoga_TheDoubleSumInterchangesAndPushforwardComposesOnRectangles where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.SumFin using (Fin ; fzero ; fsuc)

open import SamaVibhaga_TransitiveSymmetryNormalizationAndUniqueDivisionForceTheUniformMeasure
  using (total)

private
  variable
    ‚Ñì : Level

module _ {W : Type ‚Ñì} (_+·µÇ_ : W ‚Üí W ‚Üí W)
         (assoc : (x y z : W) ‚Üí x +·µÇ (y +·µÇ z) ‚â° (x +·µÇ y) +·µÇ z)
         (comm  : (x y : W) ‚Üí x +·µÇ y ‚â° y +·µÇ x) where

  -- the four-point exchange: (x+y)+(z+w) ‚â° (x+z)+(y+w).
  ‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É : (x y z w : W)
          ‚Üí (x +·µÇ y) +·µÇ (z +·µÇ w) ‚â° (x +·µÇ z) +·µÇ (y +·µÇ w)
  ‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É x y z w =
      sym (assoc x y (z +·µÇ w))
    ‚àô cong (x +·µÇ_) (assoc y z w
                    ‚àô cong (_+·µÇ w) (comm y z)
                    ‚àô sym (assoc z y w))
    ‚àô assoc x z (y +·µÇ w)

  -- the pointwise sum splits across a total.
  ‡§µ‡§ø‡§≠‡§æ‡§ú‡§®‡§Æ‡•ç : (b : ‚Ñï) (f g : Fin (suc b) ‚Üí W)
           ‚Üí total _+·µÇ_ b (Œª z ‚Üí f z +·µÇ g z)
             ‚â° (total _+·µÇ_ b f) +·µÇ (total _+·µÇ_ b g)
  ‡§µ‡§ø‡§≠‡§æ‡§ú‡§®‡§Æ‡•ç zero    f g = refl
  ‡§µ‡§ø‡§≠‡§æ‡§ú‡§®‡§Æ‡•ç (suc b) f g =
      cong ((f fzero +·µÇ g fzero) +·µÇ_)
           (‡§µ‡§ø‡§≠‡§æ‡§ú‡§®‡§Æ‡•ç b (Œª z ‚Üí f (fsuc z)) (Œª z ‚Üí g (fsuc z)))
    ‚àô ‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É (f fzero) (g fzero)
              (total _+·µÇ_ b (Œª z ‚Üí f (fsuc z)))
              (total _+·µÇ_ b (Œª z ‚Üí g (fsuc z)))

  -- THE INTERCHANGE.
  ‡§™‡§∞‡§ø‡§µ‡§∞‡•ç‡§§‡§É : (a b : ‚Ñï) (w : Fin (suc a) ‚Üí Fin (suc b) ‚Üí W)
           ‚Üí total _+·µÇ_ a (Œª y ‚Üí total _+·µÇ_ b (w y))
             ‚â° total _+·µÇ_ b (Œª z ‚Üí total _+·µÇ_ a (Œª y ‚Üí w y z))
  ‡§™‡§∞‡§ø‡§µ‡§∞‡•ç‡§§‡§É zero    b w = refl
  ‡§™‡§∞‡§ø‡§µ‡§∞‡•ç‡§§‡§É (suc a) b w =
      cong (total _+·µÇ_ b (w fzero) +·µÇ_)
           (‡§™‡§∞‡§ø‡§µ‡§∞‡•ç‡§§‡§É a b (Œª y ‚Üí w (fsuc y)))
    ‚àô sym (‡§µ‡§ø‡§≠‡§æ‡§ú‡§®‡§Æ‡•ç b (w fzero)
                      (Œª z ‚Üí total _+·µÇ_ a (Œª y ‚Üí w (fsuc y) z)))
