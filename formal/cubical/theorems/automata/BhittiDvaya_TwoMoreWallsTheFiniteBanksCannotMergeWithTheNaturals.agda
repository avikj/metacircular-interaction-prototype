{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡ø‡‡‡‡ø-‡¶‡‡µ‡Ø‡Æ‡ ‚î two more walls.
--
-- After ‡‡‡‡-‡‡‡∞‡Æ‡æ‡‡Æ‡ the big component holds 20 banks.  The next-largest
-- candidate merges into it are Unit's component (6 banks) and Fin 840's
-- (5 banks).  Both are impossible for the reason ‡‡ø‡‡‡‡ø‡ retired ‚ï ‚â Bool:
-- a finite type is not the naturals.
--
--   ‡‡ø‡‡‡‡ø-‡‡ï  : ¬ (‚ï ‚â Unit)       ‚î 6ó20 = 120 candidate crossings retired
--   ‡‡ø‡‡‡‡ø-‡‡ø‡® : ‚à n ‚í ¬ (‚ï ‚â Fin n) ‚î 5ó20 = 100 retired at n = 840, and
--                                      every future Fin-bank merge with it
--
-- Unit: injectivity of the equivalence sends isPropUnit's collision back
-- to 0 ‚â° 1 in ‚ï.  Fin: restrict the equivalence to the inclusion
-- Fin (suc n) ‚ ‚ï and land in Fin n; the library's `pigeonhole` (suc n
-- into n) hands two distinct points with equal image, and injectivity of
-- the composite refutes them.  Nothing invented; the pigeonhole is
-- cubical v0.5's own (`Cubical.Data.Fin.Properties`).
------------------------------------------------------------------------

module BhittiDvaya_TwoMoreWallsTheFiniteBanksCannotMergeWithTheNaturals where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; equivFun ; invEq ; retEq)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; znots)
open import Cubical.Data.Nat.Order using (_<_ ; ‚â§-refl ; isProp‚â§)
open import Cubical.Data.Unit using (Unit ; isPropUnit)
open import Cubical.Data.Fin using (Fin ; fzero ; to‚Ñï)
open import Cubical.Data.Fin.Properties using (pigeonhole)
open import Cubical.Data.Empty using (‚ä•) renaming (rec to ‚ä•-rec)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd ; Œ£‚â°Prop ; _√ó_)
open import Cubical.Relation.Nullary using (¬¨_)

------------------------------------------------------------------------
-- injectivity of an equivalence (as in ‡‡ø‡‡‡‡ø‡, restated locally)
------------------------------------------------------------------------

‡§Ö‡§≠‡•á‡§¶ : {A B : Type} (e : A ‚âÉ B) {x y : A} ‚Üí equivFun e x ‚â° equivFun e y ‚Üí x ‚â° y
‡§Ö‡§≠‡•á‡§¶ e {x} {y} p = sym (retEq e x) ‚àô cong (invEq e) p ‚àô retEq e y

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡ø‡‡‡‡ø-‡‡ï ‚î ‚ï is not Unit.
------------------------------------------------------------------------

‡§≠‡§ø‡§§‡•ç‡§§‡§ø-‡§è‡§ï : (‚Ñï ‚âÉ Unit) ‚Üí ‚ä•
‡§≠‡§ø‡§§‡•ç‡§§‡§ø-‡§è‡§ï e =
  znots (‡§Ö‡§≠‡•á‡§¶ e {zero} {suc zero}
          (isPropUnit (equivFun e zero) (equivFun e (suc zero))))

------------------------------------------------------------------------
-- ‡® ¬ ‡‡ø‡‡‡‡ø-‡‡ø‡® ‚î ‚ï is not Fin n, for any n.
--
-- The composite  Fin (suc n) --to‚ï--> ‚ï --e--> Fin n  is injective
-- (to‚ï is injective by Œ‚â°Prop on the order proof; e by ‡‡‡‡¶), and the
-- library pigeonhole for suc n > n produces i ‚â j with equal images.
------------------------------------------------------------------------

‡§≠‡§ø‡§§‡•ç‡§§‡§ø-‡§´‡§ø‡§® : (n : ‚Ñï) ‚Üí (‚Ñï ‚âÉ Fin n) ‚Üí ‚ä•
‡§≠‡§ø‡§§‡•ç‡§§‡§ø-‡§´‡§ø‡§® n e = i‚â¢j (to‚Ñï-inj (‡§Ö‡§≠‡•á‡§¶ e p))
  where
    g : Fin (suc n) ‚Üí Fin n
    g k = equivFun e (to‚Ñï k)

    ph : Œ£ (Fin (suc n)) (Œª i ‚Üí Œ£ (Fin (suc n)) (Œª j ‚Üí (¬¨ (i ‚â° j)) √ó (g i ‚â° g j)))
    ph = pigeonhole ‚â§-refl g

    i   = fst ph
    j   = fst (snd ph)
    i‚â¢j = fst (snd (snd ph))
    p   = snd (snd (snd ph))

    to‚Ñï-inj : {a b : Fin (suc n)} ‚Üí to‚Ñï a ‚â° to‚Ñï b ‚Üí a ‚â° b
    to‚Ñï-inj q = Œ£‚â°Prop (Œª _ ‚Üí isProp‚â§) q
