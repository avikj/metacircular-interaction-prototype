{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ààà°à¯à‹ à¨à¿à°ààà¯à¾à â” trayo niray, "three verdicts."  ààà°à•ààà-ààààà°à®à à:
-- Âààà°à¯à‹ à¨à¿à°ààà¯à¾à, à¨ à¦ààµà àÂ» â” three verdicts, never two.  (Owner's root
-- text, README Â§ààà°à•ààà-ààààà°à¾àà¿, 2026-08-22; the grammar of the stra is
-- the author's own.  The epistemic frame is the Jaina saptabhag â”
-- asti / nsti / avaktavya â” Umsvti, *Tattvrthastra* 5.32; the third
-- position is what a standpoint yields when it cannot yet decide.)
--
-- WHAT IT PROVES, and why it is here.  runtime/propagate/invalidate.py's
-- survival rule (README Â§0-Â§1): a consequence dies under the retraction
-- of a fact x iff EVERY homotopy class of its justification passes
-- through x; a surviving class is one whose leaf-multiset avoids x.  The
-- decision is computed from a class enumeration that MAY BE INCOMPLETE,
-- and its result type is deliberately three-valued â” SURVIVES / DEAD /
-- UNDECIDED â” with recompute.apply refusing to act on UNDECIDED
-- (SCALE.md Â§5.1; STATUS.md failure mode #1 is exactly a boolean guess
-- here).  This module proves that the third verdict is IRREDUCIBLE:
--
--   Â§0  a class is characterised, for the retraction of x, by one bit â”
--       true = passes through x (dies with x), false = avoids x (an
--       independent proof).  `avoids` is the GROUND TRUTH and it is
--       two-valued: the consequence's actual survival is asti or nsti.
--   Â§1  the epistemic verdict `decide seen complete` from a PARTIAL
--       enumeration `seen`.
--   Â§2  soundness of `survives`: a found survivor is real and stays real
--       under any completion (`avoids` is monotone under ++).
--   Â§3  soundness of `dead`, and Â§4 completeness âŸ never UNDECIDED.
--   Â§5  THE DURNAYA â” the load-bearing theorem.  No two-valued verdict
--       computed from `seen` alone can be correct: two completions of the
--       same seen prefix have DIFFERENT ground truth, so any boolean
--       decision destroys a real asti/nsti distinction.  ààà°à¯à‹ à¨à¿à°ààà¯à¾à,
--       à¨ à¦ààµà, mechanised for L4 survival.
--
-- The fibre reading: the survivors are the fibre over the seen prefix
-- that the retraction cannot see into; forcing a two-valued answer is the
-- unreceipted compression (àà¿ààà¾ àà™àà•ààààà) that loses it.  UNDECIDED is
-- the honest receipt that the fibre was not enumerated.
--
-- Sources for the mathematics: runtime/propagate/README.md Â§0-Â§1,
-- invalidate.survival; runtime/SCALE.md Â§5.1; runtime/STATUS.md.
--
-- CHECKED under the pin (Agda 2.8.0 + cubical library).
------------------------------------------------------------------------

module TrayoNirnayah_SurvivalUnderRetractionHasThreeVerdictsBecauseAPartialClassEnumerationCannotDecide where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (Â¬_)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Data.Bool
open import Cubical.Data.List

------------------------------------------------------------------------
-- Â§0  classes, and the ground truth of survival (two-valued).
--   true  = this homotopy class passes through the retracted fact x
--   false = this class avoids x â” an independent proof, a survivor
------------------------------------------------------------------------

Classes : Type
Classes = List Bool

-- SURVIVES the retraction of x  âŸº  some class avoids x.
avoids : Classes â†’ Bool
avoids []       = false
avoids (c âˆ· cs) = not c or avoids cs

------------------------------------------------------------------------
-- Â§1  the three verdicts, and the decision from a PARTIAL enumeration.
------------------------------------------------------------------------

data Nirnaya : Type where
  survives undecided dead : Nirnaya

-- `seen` are the classes enumerated so far; `complete` says the
-- enumeration exhausted them.  A found survivor decides SURVIVES at once;
-- otherwise only completeness licenses DEAD, and without it the honest
-- verdict is UNDECIDED.
decide : Classes â†’ Bool â†’ Nirnaya
decide seen complete =
  if avoids seen then survives
  else (if complete then dead else undecided)

-- a discriminator, so the three verdicts are provably distinct.
private
  isSurv : Nirnaya â†’ Bool
  isSurv survives = true
  isSurv _        = false

  survivesâ‰¢dead : Â¬ (survives â‰¡ dead)
  survivesâ‰¢dead p = trueâ‰¢false (cong isSurv p)

  isUndec : Nirnaya â†’ Bool
  isUndec undecided = true
  isUndec _         = false

  survivesâ‰¢undec : Â¬ (survives â‰¡ undecided)
  survivesâ‰¢undec p = falseâ‰¢true (cong isUndec p)

  deadâ‰¢undec : Â¬ (dead â‰¡ undecided)
  deadâ‰¢undec p = falseâ‰¢true (cong isUndec p)

------------------------------------------------------------------------
-- Â§2  soundness of SURVIVES: a found survivor is real under any completion.
--     `avoids` is monotone: appending more classes never loses a survivor.
------------------------------------------------------------------------

avoids-++ : (xs ys : Classes) â†’ avoids xs â‰¡ true â†’ avoids (xs ++ ys) â‰¡ true
avoids-++ []           ys h = âŠ¥.rec (falseâ‰¢true h)
avoids-++ (true  âˆ· cs) ys h = avoids-++ cs ys h
avoids-++ (false âˆ· cs) ys h = refl

-- if the partial enumeration already decides SURVIVES, then the true
-- survival over any completion `seen ++ rest` is likewise `true`.
survives-sound : (seen rest : Classes) (complete : Bool)
               â†’ decide seen complete â‰¡ survives
               â†’ avoids (seen ++ rest) â‰¡ true
survives-sound seen rest complete h = avoids-++ seen rest seenAvoids
  where
  -- decide reduces to survives only through the `then` branch, i.e.
  -- avoids seen â‰¡ true; extract it by casing on avoids seen.
  seenAvoids : avoids seen â‰¡ true
  seenAvoids with avoids seen
  ... | true  = refl
  ... | false = âŠ¥.rec (helper complete h)
    where
    helper : (c : Bool) â†’ (if c then dead else undecided) â‰¡ survives â†’ âŠ¥
    helper true  q = survivesâ‰¢dead (sym q)
    helper false q = survivesâ‰¢undec (sym q)

------------------------------------------------------------------------
-- Â§3  soundness of DEAD: under a COMPLETE enumeration, `dead` is truthful.
------------------------------------------------------------------------

dead-sound : (cs : Classes) â†’ decide cs true â‰¡ dead â†’ avoids cs â‰¡ false
dead-sound cs h with avoids cs
... | false = refl
... | true  = âŠ¥.rec (survivesâ‰¢dead h)

------------------------------------------------------------------------
-- Â§4  completeness âŸ the verdict is never UNDECIDED.
------------------------------------------------------------------------

complete-decides : (cs : Classes) â†’ Â¬ (decide cs true â‰¡ undecided)
complete-decides cs h with avoids cs
... | true  = survivesâ‰¢undec h
... | false = deadâ‰¢undec h

------------------------------------------------------------------------
-- Â§5  THE DURNAYA â” ààà°à¯à‹ à¨à¿à°ààà¯à¾à, à¨ à¦ààµà.
--
-- The incomplete standpoint: one class seen, and it passes through x, so
-- no survivor is found yet and the enumeration is not exhausted.
------------------------------------------------------------------------

seenâ‚€ : Classes
seenâ‚€ = true âˆ· []

-- the honest verdict on it is UNDECIDED (checked).
_ : decide seenâ‚€ false â‰¡ undecided
_ = refl

-- two completions of the SAME seen prefix, disagreeing in ground truth.
cs-survivor cs-dead : Classes
cs-survivor = seenâ‚€ ++ (false âˆ· [])   -- a survivor hidden past the prefix
cs-dead     = seenâ‚€ ++ (true  âˆ· [])   -- nothing but passes-through classes

_ : avoids cs-survivor â‰¡ true    -- truly survives
_ = refl
_ : avoids cs-dead     â‰¡ false   -- truly dead
_ = refl

-- No verdict computed from `seen` ALONE (a function of the seen prefix)
-- can be correct on both completions: it would have to equal both `true`
-- and `false`.  Any two-valued decision on the incomplete standpoint
-- destroys the asti/nsti distinction the unenumerated classes carry â”
-- which is exactly why the third verdict is required, not optional.
durnaya : (v : Classes â†’ Bool)
        â†’ v seenâ‚€ â‰¡ avoids cs-survivor
        â†’ v seenâ‚€ â‰¡ avoids cs-dead
        â†’ âŠ¥
durnaya v p q = trueâ‰¢false (sym p âˆ™ q)
