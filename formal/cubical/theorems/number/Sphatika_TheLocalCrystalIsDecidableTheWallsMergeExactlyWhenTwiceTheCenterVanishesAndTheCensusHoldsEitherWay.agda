{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡‡ü‡ø‡ï‡ ‚î the local crystal, complete: decidable which regime, walls
-- merging exactly when twice the center vanishes, and the census an
-- equivalence either way.
--
-- THE CHART OF THE TWO-WALL FIELD, INTERNAL TO THE RESIDUE WHEEL.
-- ‡ï‡‡®‡‡¶‡‡∞‡Æ‡ proved the merge criterion on the ‚ side (p ‚à a + a, both
-- directions); ‡¶‡‡µ‡ø-‡≤‡ã‡‡ counted survivors of abstract walls.  This module
-- closes the chart from inside Fin p with the wheel's own arithmetic
-- (+‚ò, -‚ò ‚î the library's):
--
--   ‡‡ô‡‡ó‡Æ-‡‡®‡‡‡∞‡ : (a ‚â° -‚ò a) ‚â (a +‚ò a ‚â° ‡‡‡®‡‡Ø‡Æ‡)
--       the walls coincide exactly when twice the center vanishes ‚î
--       ‡ï‡‡®‡‡¶‡‡∞‡Æ‡'s iff, now a statement the wheel can pronounce itself;
--   ‡‡‡‡ü‡ø‡ï‡ : for every center a, EITHER (a +‚ò a ‚â° ‡‡‡®‡‡Ø‡Æ‡ and the survivor
--       type of the field is ‚â Fin (p‚àí1)) OR (a +‚ò a ‚â 0 and it is
--       ‚â Fin (p‚àí2)) ‚î the disjunction DECIDED, not assumed, and the
--       census in both branches an identification, never a count.
--
-- With this the local layer of the program is complete as terms: the
-- centering (‡ï‡‡®‡‡¶‡‡∞‡Æ‡), the elision engine (‡¶‡‡µ‡ø-‡≤‡ã‡‡), the merge
-- criterion internal (here), the regime decision (here), and the
-- charge that must survive the boundary (‡‡æ‡‡‡ï‡æ‡≤‡ø‡ï‡ ‡ó‡‡ø‡ / Yamala).
-- What remains above the chart is the atlas: the CRT tensor across
-- charts (‚à(p ‚àí œâ_p) per period, ‡ï‡‡ü‡‡ü‡ï-‡ï‡ã‡ Lemma 3) and the cone
-- restriction where the whole difficulty lives (¬ß3 there).  Named, not
-- built.
--
-- ON THE NAME.  ‡‡‡‡ü‡ø‡ï ‚î crystal, rock-crystal ‚î ordinary ,
-- prominent in the traditions this corpus reads (the sphaika of
-- Nyya's optics examples; the owner's "local prime Fourier crystal"
-- names the same object one instrument later).  The compound use is
-- built here, 2026-08-23; no source is claimed for any statement.
------------------------------------------------------------------------

module Sphatika_TheLocalCrystalIsDecidableTheWallsMergeExactlyWhenTwiceTheCenterVanishesAndTheCensusHoldsEitherWay where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; compEquiv ; equivFun ; invEq)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Fin using (Fin ; fzero ; discreteFin)
open import Cubical.Data.Fin.Properties using (isSetFin)
open import Cubical.Data.Fin.Arithmetic
  using (_+‚Çò_ ; -‚Çò_ ; +‚Çò-assoc ; +‚Çò-comm ; +‚Çò-lUnit ; +‚Çò-rUnit ; +‚Çò-lCancel)
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_ ; _,_ ; fst ; snd ; Œ£PathP)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Empty using (‚ä•) renaming (rec to ‚ä•-rec)
open import Cubical.Relation.Nullary using (¬¨_ ; Dec ; yes ; no)
open import Cubical.Relation.Nullary.Properties using (isProp¬¨)

open import DviLopa_TheTwoWallsElideTwoResiduesAndTheSurvivorsAreExactlyCounted
  using (‡§è‡§ï-‡§≤‡•ã‡§™‡§É ; ‡§¶‡•ç‡§µ‡§ø-‡§≤‡•ã‡§™‡§É)

private
  variable
    m : ‚Ñï

------------------------------------------------------------------------
‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç : Fin (suc m)
‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç = fzero

-- ‡ß ¬ small wheel lemmas: a +‚ò (-‚ò a) ‚â° ‡‡‡®‡‡Ø‡Æ‡, and the merge iff.
------------------------------------------------------------------------

+‚Çò-rCancel' : (a : Fin (suc m)) ‚Üí a +‚Çò (-‚Çò a) ‚â° ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç
+‚Çò-rCancel' a = +‚Çò-comm a (-‚Çò a) ‚àô +‚Çò-lCancel a

-- the walls coincide exactly when twice the center vanishes.  Both
-- sides are propositions (Fin is a set), so an iso of implications.
‡§∏‡§ô‡•ç‡§ó‡§Æ-‡§Ü‡§®‡•ç‡§§‡§∞‡§É : (a : Fin (suc m)) ‚Üí (a ‚â° -‚Çò a) ‚âÉ ((a +‚Çò a) ‚â° ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç)
‡§∏‡§ô‡•ç‡§ó‡§Æ-‡§Ü‡§®‡•ç‡§§‡§∞‡§É a =
  isoToEquiv (iso ‡§Ö‡§ó‡•ç‡§∞‡•á ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§ó‡§Æ‡§É
                  (Œª q ‚Üí isSetFin _ _ _ q)
                  (Œª p ‚Üí isSetFin _ _ _ p))
  where
    ‡§Ö‡§ó‡•ç‡§∞‡•á : a ‚â° -‚Çò a ‚Üí (a +‚Çò a) ‚â° ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç
    ‡§Ö‡§ó‡•ç‡§∞‡•á p = cong (a +‚Çò_) p ‚àô +‚Çò-rCancel' a

    ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§ó‡§Æ‡§É : (a +‚Çò a) ‚â° ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç ‚Üí a ‚â° -‚Çò a
    ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§ó‡§Æ‡§É q = sym
      ( -‚Çò a
          ‚â°‚ü® sym (+‚Çò-lUnit (-‚Çò a)) ‚ü©
        ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç +‚Çò (-‚Çò a)
          ‚â°‚ü® cong (_+‚Çò (-‚Çò a)) (sym q) ‚ü©
        (a +‚Çò a) +‚Çò (-‚Çò a)
          ‚â°‚ü® +‚Çò-assoc a a (-‚Çò a) ‚ü©
        a +‚Çò (a +‚Çò (-‚Çò a))
          ‚â°‚ü® cong (a +‚Çò_) (+‚Çò-rCancel' a) ‚ü©
        a +‚Çò ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç
          ‚â°‚ü® +‚Çò-rUnit a ‚ü©
        a ‚àé )

------------------------------------------------------------------------
-- ‡® ¬ the survivor type of the centered field at center a, and the
-- merged-regime collapse: when the walls coincide, the two conditions
-- are one proposition.
------------------------------------------------------------------------

‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞‡§Æ‡•ç : (a : Fin (suc m)) ‚Üí Type
‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞‡§Æ‡•ç {m = m} a = Œ£[ y ‚àà Fin (suc m) ] ((¬¨ a ‚â° y) √ó (¬¨ (-‚Çò a) ‚â° y))

-- for propositions, a redundant pair is one coordinate.
‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É : {A : Type} ‚Üí isProp A ‚Üí (A √ó A) ‚âÉ A
‡§Ø‡•Å‡§ó‡•ç‡§Æ-‡§∏‡§ô‡•ç‡§ï‡•ã‡§ö‡§É pr =
  isoToEquiv (iso fst (Œª x ‚Üí x , x)
                  (Œª _ ‚Üí refl)
                  (Œª (x , y) ‚Üí Œ£PathP (refl , pr x y)))

‡§∏‡§ô‡•ç‡§ó‡§§-‡§ó‡§£‡§®‡§æ : (a : Fin (suc m)) ‚Üí a ‚â° -‚Çò a ‚Üí ‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞‡§Æ‡•ç a ‚âÉ Fin m
‡§∏‡§ô‡•ç‡§ó‡§§-‡§ó‡§£‡§®‡§æ {m = m} a p =
  compEquiv
    (isoToEquiv (iso
      (Œª (y , (na , _)) ‚Üí y , na)
      (Œª (y , na) ‚Üí y , (na , Œª q ‚Üí na (p ‚àô q)))
      (Œª _ ‚Üí refl)
      (Œª (y , (na , nb)) ‚Üí
        Œ£PathP (refl ,
          Œ£PathP (refl , isProp¬¨ ((-‚Çò a) ‚â° y) _ nb)))))
    (‡§è‡§ï-‡§≤‡•ã‡§™‡§É a)

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡‡ü‡ø‡ï‡ ‚î the whole chart, decided.  Fin p for p = 2 + m, so the
-- distinct regime lands in Fin m = Fin (p‚àí2) and the merged regime in
-- Fin (suc m) = Fin (p‚àí1).
------------------------------------------------------------------------

‡§∏‡•ç‡§´‡§ü‡§ø‡§ï‡§É : (a : Fin (suc (suc m)))
       ‚Üí (((a +‚Çò a) ‚â° ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç) √ó (‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞‡§Æ‡•ç a ‚âÉ Fin (suc m)))
       ‚äé ((¬¨ (a +‚Çò a) ‚â° ‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç) √ó (‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞‡§Æ‡•ç a ‚âÉ Fin m))
‡§∏‡•ç‡§´‡§ü‡§ø‡§ï‡§É {m = m} a with discreteFin a (-‚Çò a)
... | yes p = inl ( equivFun (‡§∏‡§ô‡•ç‡§ó‡§Æ-‡§Ü‡§®‡•ç‡§§‡§∞‡§É a) p , ‡§∏‡§ô‡•ç‡§ó‡§§-‡§ó‡§£‡§®‡§æ a p )
... | no ¬¨p = inr ( (Œª q ‚Üí ¬¨p (invEq (‡§∏‡§ô‡•ç‡§ó‡§Æ-‡§Ü‡§®‡•ç‡§§‡§∞‡§É a) q))
                  , ‡§¶‡•ç‡§µ‡§ø-‡§≤‡•ã‡§™‡§É a (-‚Çò a) ¬¨p )

------------------------------------------------------------------------
-- ‡ ¬ ‡¶‡ã‡‡≤‡‡ñ‡.  The chart is closed; the atlas is not: the product over
-- charts (CRT), the cone restriction, and the identification of -‚ò a
-- with the ‚-side ‚àía under a reduction map ‚ ‚í Fin p are all named and
-- not built.  ‡‡‡‡ü‡ø‡ï‡ decides by discreteFin on the WALLS; deciding on
-- the criterion (a +‚ò a ‚â° ‡‡‡®‡‡Ø‡Æ‡) instead is the same decision through
-- ‡‡ô‡‡ó‡Æ-‡‡®‡‡‡∞‡.  Nothing here asserts anything about primes: p = 2 + m
-- is any modulus ‚â 2, and primality enters only at the atlas level,
-- where ‡ï‡‡ü‡‡ü‡ï-‡ï‡ã‡ needs the charts at prime moduli.
------------------------------------------------------------------------
