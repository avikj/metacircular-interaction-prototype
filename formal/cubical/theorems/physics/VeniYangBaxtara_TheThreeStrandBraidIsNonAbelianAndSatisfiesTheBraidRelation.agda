{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- VeniYangBaxtara_TheThreeStrandBraidIsNonAbelian
--                  AndSatisfiesTheBraidRelation
--
-- TERMS.  àµààà Â ve â” a braid, a plait (of three strands); a common
--  word, used here for the braid on three points.  à¯à™àà—à-àà•ààà° Â
-- "Yangâ“Baxter" is transliterated, not translated: the braid relation
-- ÏÏÏ = ÏÏÏ is named for C. N. Yang and R. J. Baxter (20th c.) and NO Indian
-- source is claimed for it.  The compound and the framing below are built
-- here, 2026-08-24; what is borrowed is one  word and one modern name.
--
-- WHAT IS PROVED, exactly:  on the three-element type `Three`, the two
-- adjacent transpositions Ï = (a b) and Ï = (b c) are involutions (hence
-- equivalences â” reversible, lossless gates), they do NOT commute
-- (`braids-dont-commute`, a closed Â), and they satisfy the braid relation
-- `ÏÏÏ â‰¡ ÏÏÏ` (`yang-baxter`).  These are the defining data of the braid
-- group Bâ / the symmetric group Sâ, exhibited by computation.
--
-- WHY IT MATTERS (a READING of the checked terms, not a further claim, and
-- the companion of `VargamulaViparyaya_â¦`):  on TWO points, Aut Bool = Sâ =
-- â/2 is abelian and has no square root of the swap â” a single abelian phase,
-- and (that file) the qubit is forced to hold âˆNOT.  On THREE points, Aut is
-- Sâ, and it is NON-ABELIAN: the order of braiding is observable
-- (`braids-dont-commute`).  Order-dependence is exactly where computational
-- power lives â” abelian anyons are not universal, non-abelian anyons are â”
-- and the consistency law that makes such braiding well-defined is precisely
-- Yangâ“Baxter (`yang-baxter`), the equation anyonic topological quantum
-- computation is built on.  So the ladder 2 â’ 3 points is the ladder
-- abelian-phase â’ non-abelian-braid â’ universal gate, and EVERY gate on it is
-- an involution/equivalence â” lossless, ahis â” reversibility is kept
-- throughout; only commutativity is given up, and giving it up is the point.
-- No anyon physics is checked here; only the group-theoretic skeleton it
-- runs on.
--
-- Checked: --cubical --safe, agda 2.6.3 + cubical (loads clean); no
-- v0.9-only construct.
------------------------------------------------------------------------

module VeniYangBaxtara_TheThreeStrandBraidIsNonAbelianAndSatisfiesTheBraidRelation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

-- three strands / three anyons.
data Three : Type where a b c : Three

-- the two adjacent transpositions.
Ïƒ : Three â†’ Three          -- (a b)
Ïƒ a = b ; Ïƒ b = a ; Ïƒ c = c
Ï„ : Three â†’ Three          -- (b c)
Ï„ a = a ; Ï„ b = c ; Ï„ c = b

-- each is an involution, hence a reversible (lossless) gate â” an equivalence.
ÏƒÏƒ : (x : Three) â†’ Ïƒ (Ïƒ x) â‰¡ x
ÏƒÏƒ a = refl ; ÏƒÏƒ b = refl ; ÏƒÏƒ c = refl
Ï„Ï„ : (x : Three) â†’ Ï„ (Ï„ x) â‰¡ x
Ï„Ï„ a = refl ; Ï„Ï„ b = refl ; Ï„Ï„ c = refl
ÏƒEq : Three â‰ƒ Three
ÏƒEq = isoToEquiv (iso Ïƒ Ïƒ ÏƒÏƒ ÏƒÏƒ)
Ï„Eq : Three â‰ƒ Three
Ï„Eq = isoToEquiv (iso Ï„ Ï„ Ï„Ï„ Ï„Ï„)

private
  bâ‰¢c : Â¬ (b â‰¡ c)
  bâ‰¢c q = subst P q tt where
    P : Three â†’ Type
    P a = âŠ¥ ; P b = Unit ; P c = âŠ¥

-- NON-ABELIAN: Ï-then-Ï and Ï-then-Ï disagree already at `a`
-- (Ï(Ï a) = b, Ï(Ï a) = c), so the two braid orders are different gates.
braids-dont-commute : Â¬ (compEquiv Ï„Eq ÏƒEq â‰¡ compEquiv ÏƒEq Ï„Eq)
braids-dont-commute p = bâ‰¢c (funExtâ» (cong equivFun p) a)

-- THE BRAID RELATION / YANGâ“BAXTER: ÏÏÏ = ÏÏÏ.  Every strand agrees, by
-- computation.  This is the law that makes three-strand braiding consistent.
yang-baxter : (Î» x â†’ Ïƒ (Ï„ (Ïƒ x))) â‰¡ (Î» x â†’ Ï„ (Ïƒ (Ï„ x)))
yang-baxter = funExt Î» { a â†’ refl ; b â†’ refl ; c â†’ refl }
