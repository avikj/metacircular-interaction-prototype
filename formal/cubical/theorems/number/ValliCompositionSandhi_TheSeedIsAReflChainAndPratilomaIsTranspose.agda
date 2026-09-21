{-# OPTIONS --cubical --safe #-}

-- ValliBhavanaSandhi_TheSeedIsAReflChainAndPratilomaIsTranspose
--
-- àµà²àà²à: ryabhaa, ryabhaya, Gaitapda 32â“33 (499).  àà¾àµà¨à¾: Brahmagupta,
-- Brhmasphuasiddhnta 18.64â“65 (628).  àà¨àà§à¿à: junction; the compound
-- àµà²àà²à-àà¾àµà¨à¾-àà¨àà§à¿à is built in this corpus (2026-08-23, and no source is
-- claimed for it. What is claimed of the sources is exactly what the machine
-- lane already claims: the vall is the quotient column, the àà¾àµà¨à¾ is the
-- composition rule (xx'+Dyy', xy'+x'y).
--
-- WHAT THIS MODULE CHECKS, checked forms of the note's derivation:
--
--   1. ààà°àà¿à²à‹à®-à®àà•ààà®à â” the generator column M(a) = [[a,1],[1,0]] is its
--      own transpose (refl), so reversal of a garland is transposition.
--   2. ààà°àà¿à²à‹à®à â” transpose is an anti-automorphism of the matrix monoid:
--      (AÂB)µ = BµÂAµ, proved componentwise from ÂComm alone.
--   3. àà¨àà§à¿-àààà®à (D = 2, the seed instance of the note's Theorem):
--      M(1)ÂM(2)ÂM(1)ÂM(0) â‰¡ Î(3 + 2âˆ2), where Î x y = [[x, Dy],[y, x]]
--      is the regular representation on the basis (1, âˆD).  One refl:
--      both sides compute to [[3,4],[2,3]].  det bookkeeping: 9 âˆ’ 2Â4 = 1.

module ValliBhavanaSandhi_TheSeedIsAReflChainAndPratilomaIsTranspose where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int
open import Cubical.Data.Int.Properties using (Â·Comm)

-- â”â” the matrix monoid, four slots, no list and no vector â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”

record Mat : Type where
  constructor mat
  field
    m00 m01 m10 m11 : â„¤

open Mat

_â‹†_ : Mat â†’ Mat â†’ Mat
A â‹† B = mat (m00 A Â· m00 B + m01 A Â· m10 B) (m00 A Â· m01 B + m01 A Â· m11 B)
            (m10 A Â· m00 B + m11 A Â· m10 B) (m10 A Â· m01 B + m11 A Â· m11 B)

infixl 20 _â‹†_

-- the vall generator: one digit, one column move
à¤—à¤£à¤•à¤ƒ : â„¤ â†’ Mat
à¤—à¤£à¤•à¤ƒ a = mat a (pos 1) (pos 1) (pos 0)

-- transpose
à¤ªà¥à¤°à¤¤à¤¿à¤²à¥‹à¤®à¤®à¥ : Mat â†’ Mat
à¤ªà¥à¤°à¤¤à¤¿à¤²à¥‹à¤®à¤®à¥ A = mat (m00 A) (m10 A) (m01 A) (m11 A)

-- the regular representation of x + yâˆD on the basis (1, âˆD)
Î¹ : (D x y : â„¤) â†’ Mat
Î¹ D x y = mat x (D Â· y) y x

-- â”â” à§ Â the generator is its own reverse â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”

à¤ªà¥à¤°à¤¤à¤¿à¤²à¥‹à¤®-à¤®à¥à¤•à¥à¤¤à¤®à¥ : (a : â„¤) â†’ à¤ªà¥à¤°à¤¤à¤¿à¤²à¥‹à¤®à¤®à¥ (à¤—à¤£à¤•à¤ƒ a) â‰¡ à¤—à¤£à¤•à¤ƒ a
à¤ªà¥à¤°à¤¤à¤¿à¤²à¥‹à¤®-à¤®à¥à¤•à¥à¤¤à¤®à¥ a = refl

-- â”â” à¨ Â transpose is an anti-automorphism: (Aâ‹B)µ â‰¡ Bµâ‹Aµ â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- Componentwise; each slot is two applications of ÂComm under _+_.

à¤ªà¥à¤°à¤¤à¤¿à¤²à¥‹à¤®à¤ƒ : (A B : Mat) â†’ à¤ªà¥à¤°à¤¤à¤¿à¤²à¥‹à¤®à¤®à¥ (A â‹† B) â‰¡ à¤ªà¥à¤°à¤¤à¤¿à¤²à¥‹à¤®à¤®à¥ B â‹† à¤ªà¥à¤°à¤¤à¤¿à¤²à¥‹à¤®à¤®à¥ A
à¤ªà¥à¤°à¤¤à¤¿à¤²à¥‹à¤®à¤ƒ A B i =
  mat (congâ‚‚ _+_ (Â·Comm (m00 A) (m00 B)) (Â·Comm (m01 A) (m10 B)) i)
      (congâ‚‚ _+_ (Â·Comm (m10 A) (m00 B)) (Â·Comm (m11 A) (m10 B)) i)
      (congâ‚‚ _+_ (Â·Comm (m00 A) (m01 B)) (Â·Comm (m01 A) (m11 B)) i)
      (congâ‚‚ _+_ (Â·Comm (m10 A) (m01 B)) (Â·Comm (m11 A) (m11 B)) i)

-- â”â” à© Â the seed sandhi, D = 2 â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- Digits of âˆ2 across the closed period: 1, 2, 1; dressed with M(0).
-- The garland lands on Î 2 3 2 â” the regular representation of 3 + 2âˆ2,
-- Brahmagupta's fundamental for D = 2, norm 9 âˆ’ 2Â4 = 1.

à¤¸à¤¨à¥à¤§à¤¿-à¤¬à¥€à¤œà¤®à¥ :
    à¤—à¤£à¤•à¤ƒ (pos 1) â‹† à¤—à¤£à¤•à¤ƒ (pos 2) â‹† à¤—à¤£à¤•à¤ƒ (pos 1) â‹† à¤—à¤£à¤•à¤ƒ (pos 0)
  â‰¡ Î¹ (pos 2) (pos 3) (pos 2)
à¤¸à¤¨à¥à¤§à¤¿-à¤¬à¥€à¤œà¤®à¥ = refl
