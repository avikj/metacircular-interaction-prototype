{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AnswerGrading
--
-- Two claims from `papers/hieroglyphics_iii.tex`, proved rather than
-- restated.
--
--   A.  `D_X ‚ ‡‡ï‡Æ‡‡µ ‡ï‡æ‡∞‡‡Æ‡` -- a defect does not determine its cause, and so
--       `Class(D)` is genuinely extra data.  The same defect admits repairs
--       that are not interchangeable; the classification is a decision, not a
--       computation performed on the defect.
--
--   B.  `‡‡‡‡‡ø‡‡‡µ < ‡‡ï‡‡‡µ < ‡‡‡∞‡æ‡ï‡‡‡ø‡ï‡‡æ < ‡‡æ‡∞‡‡µ‡‡‡∞‡ø‡ï‡‡æ`, with
--       `‡‡‡∞‡‡‡‡†‡â‡‡‡‡∞‡Æ‡ = ‡‡æ‡∞‡‡µ‡‡‡∞‡ø‡ï‡ó‡‡‡ß‡∞‡‡Æ‡Ø‡‡ï‡‡ ‡â‡‡‡‡∞‡Æ‡`.  The sign repair of
--       not merely *a* map resolving the defect -- `crush` is that too -- it
--       is the universal sign-blind map, and every sign-blind observation
--       factors through it, uniquely on representatives.
--
-- This answers something the earlier modules left open.  `RepairGrading` and
-- `ObstructionCalculus` established `Œì^ ‚í Œì‚à` with no converse, so `Œì^`
-- retains strictly more; neither said what makes `Œì^` the *right* repair
-- rather than merely a larger one.  The universal property is what makes it
-- right, and it is why the document puts `‡‡æ‡∞‡‡µ‡‡‡∞‡ø‡ï‡‡æ` above `‡‡‡‡‡ø‡‡‡µ` in a
-- chain rather than beside it in a list.
------------------------------------------------------------------------

module AnswerGrading where

open import Cubical.Foundations.Prelude

open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; snotz)
open import Cubical.Data.Int using (‚Ñ§ ; pos ; negsuc ; abs ; -_ ; abs- ; injPos)
open import Cubical.Relation.Nullary using (¬¨_)

open import SmithSignNormal using (abs‚Ñ§)

private
  variable
    A : Type‚ÇÄ

------------------------------------------------------------------------
-- A.  The defect does not determine the cause.

-- A repair of the pair `x , y` is any observation that stops distinguishing
-- them.
Resolves : {X : Type‚ÇÄ} (x y : X) ‚Üí (X ‚Üí A) ‚Üí Type‚ÇÄ
Resolves x y f = f x ‚â° f y

-- `abs‚` resolves the sign defect by choosing the nonnegative representative.
abs‚Ñ§-resolves : Resolves (pos 6) (negsuc 5) abs‚Ñ§
abs‚Ñ§-resolves = refl

-- The constant map resolves it too, by choosing nothing at all: `Œì‚à` in its
-- crudest form, and a perfectly valid repair of this defect.
crush : ‚Ñ§ ‚Üí ‚Ñ§
crush _ = pos 0

crush-resolves : Resolves (pos 6) (negsuc 5) crush
crush-resolves = refl

-- The two repairs disagree, so the defect did not select one of them.
repairs-differ : ¬¨ (abs‚Ñ§ (pos 6) ‚â° crush (pos 6))
repairs-differ p = snotz (injPos p)

-- `Class` is therefore extra data, exactly as the document says.
Class-is-extra :
  Œ£[ f ‚àà (‚Ñ§ ‚Üí ‚Ñ§) ] Œ£[ g ‚àà (‚Ñ§ ‚Üí ‚Ñ§) ]
    ( Resolves (pos 6) (negsuc 5) f
    √ó Resolves (pos 6) (negsuc 5) g
    √ó (¬¨ (f (pos 6) ‚â° g (pos 6))) )
Class-is-extra = abs‚Ñ§ , crush , abs‚Ñ§-resolves , crush-resolves , repairs-differ

------------------------------------------------------------------------
-- B.  The ladder, and where the sign repair sits on it.

-- An observation that cannot see the sign.
SignBlind : (‚Ñ§ ‚Üí A) ‚Üí Type‚ÇÄ
SignBlind f = (x : ‚Ñ§) ‚Üí f (- x) ‚â° f x

-- Both candidate repairs are sign-blind, so this property does not separate
-- them either.  Existence is cheap.
abs‚Ñ§-signBlind : SignBlind abs‚Ñ§
abs‚Ñ§-signBlind x = cong pos (abs- x)

crush-signBlind : SignBlind crush
crush-signBlind _ = refl

-- Every integer is its own nonnegative representative, up to sign.  Three
-- cases, and the only computation in the file.
abs‚Ñ§-rep : (x : ‚Ñ§) ‚Üí (x ‚â° abs‚Ñ§ x) ‚äé (x ‚â° - abs‚Ñ§ x)
abs‚Ñ§-rep (pos n) = inl refl
abs‚Ñ§-rep (negsuc n) = inr refl

-- **The universal property.**  Every sign-blind observation is already its own
-- factorization through `abs‚`: nothing that cannot see the sign can see the
-- difference between an integer and its representative.
abs‚Ñ§-factors : (f : ‚Ñ§ ‚Üí A) ‚Üí SignBlind f ‚Üí (x : ‚Ñ§) ‚Üí f x ‚â° f (abs‚Ñ§ x)
abs‚Ñ§-factors f sb x with abs‚Ñ§-rep x
... | inl p = cong f p
... | inr p = cong f p ‚àô sb (abs‚Ñ§ x)

abs‚Ñ§-universal : (f : ‚Ñ§ ‚Üí A) ‚Üí SignBlind f
               ‚Üí Œ£[ g ‚àà (‚Ñ§ ‚Üí A) ] ((x : ‚Ñ§) ‚Üí f x ‚â° g (abs‚Ñ§ x))
abs‚Ñ§-universal f sb = f , abs‚Ñ§-factors f sb

-- And the factorization is forced on representatives, which is the `‡‡ï‡‡‡µ`
-- rung: two factorizations of the same observation agree wherever `abs‚`
-- lands.
abs‚Ñ§-factor-unique :
    (f g h : ‚Ñ§ ‚Üí A)
  ‚Üí ((x : ‚Ñ§) ‚Üí f x ‚â° g (abs‚Ñ§ x))
  ‚Üí ((x : ‚Ñ§) ‚Üí f x ‚â° h (abs‚Ñ§ x))
  ‚Üí (n : ‚Ñï) ‚Üí g (pos n) ‚â° h (pos n)
abs‚Ñ§-factor-unique f g h pg ph n = sym (pg (pos n)) ‚àô ph (pos n)

-- **The crude repair has no such property.**  `crush` resolves the defect and
-- is sign-blind, but sign-blind observations do not factor through it: it
-- discarded information they still need.  This is the gap between `‡‡‡‡‡ø‡‡‡µ`
-- and `‡‡æ‡∞‡‡µ‡‡‡∞‡ø‡ï‡‡æ`, exhibited rather than asserted.
crush-not-universal :
  ¬¨ (Œ£[ g ‚àà (‚Ñ§ ‚Üí ‚Ñ§) ] ((x : ‚Ñ§) ‚Üí abs‚Ñ§ x ‚â° g (crush x)))
crush-not-universal (g , p) =
  snotz (injPos (p (pos 1) ‚àô sym (p (pos 0))))

-- So on this defect the ladder is strict: both repairs exist, only one is
-- universal, and the classification `Œì^` rather than `Œì‚à` is what reaches it.
sign-repair-is-best :
    (Œ£[ g ‚àà (‚Ñ§ ‚Üí ‚Ñ§) ] ((x : ‚Ñ§) ‚Üí abs‚Ñ§ x ‚â° g (abs‚Ñ§ x)))
  √ó (¬¨ (Œ£[ g ‚àà (‚Ñ§ ‚Üí ‚Ñ§) ] ((x : ‚Ñ§) ‚Üí abs‚Ñ§ x ‚â° g (crush x))))
sign-repair-is-best =
  abs‚Ñ§-universal abs‚Ñ§ abs‚Ñ§-signBlind , crush-not-universal
