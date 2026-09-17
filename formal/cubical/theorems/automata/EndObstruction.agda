{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- Î´_end : àà¨ààà¿à®à—àà°à¨ààà¿à.
--
--   Fix âŸâââŸ âFixâ âŸdiagâŸ Fixâº
--
-- àà®à¾àààà¿ â‰ àà®à¾àààà¿àµà°ààà¨à®à : the end is never among the things the machine
-- can say about the end.  Lawvere/Cantor, no fuel, no measurement: for every
-- quotation ââˆ’â : ğ’ â’ (ğ’ â’ Bool) the diagonal observable is outside the
-- image, so Î´_end â‰ 0 unconditionally and Î“âŸ¨Î´_endâŸ© is always the next door.

module EndObstruction where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

private
  BoolCode : Bool â†’ Typeâ‚€
  BoolCode true = Unit
  BoolCode false = âŠ¥

  xâ‰¢not : (x : Bool) â†’ Â¬ (x â‰¡ not x)
  xâ‰¢not true p = subst BoolCode p tt
  xâ‰¢not false p = subst BoolCode (sym p) tt

--------------------------------------------------------------------------
-- ââˆ’â, diag
--------------------------------------------------------------------------

Observable : Typeâ‚€ â†’ Typeâ‚€
Observable ğ’¬ = ğ’¬ â†’ Bool

Quote : Typeâ‚€ â†’ Typeâ‚€
Quote ğ’¬ = ğ’¬ â†’ Observable ğ’¬

diag : {ğ’¬ : Typeâ‚€} â†’ Quote ğ’¬ â†’ Observable ğ’¬
diag âŒœ_âŒ x = not (âŒœ x âŒ x)

--------------------------------------------------------------------------
-- Î´_end â‰ 0
--------------------------------------------------------------------------

Î´-end : {ğ’¬ : Typeâ‚€} (âŒœ_âŒ : Quote ğ’¬) (x : ğ’¬) â†’ Â¬ (âŒœ x âŒ â‰¡ diag âŒœ_âŒ)
Î´-end âŒœ_âŒ x p = xâ‰¢not (âŒœ x âŒ x) (funExtâ» p x)

-- No self-description is complete: the cadence cannot quote its own closure.
no-complete-quotation :
    {ğ’¬ : Typeâ‚€} (âŒœ_âŒ : Quote ğ’¬)
  â†’ Â¬ ((d : Observable ğ’¬) â†’ Î£[ x âˆˆ ğ’¬ ] âŒœ x âŒ â‰¡ d)
no-complete-quotation âŒœ_âŒ complete =
  Î´-end âŒœ_âŒ (fst hit) (snd hit)
  where
    hit : Î£[ x âˆˆ _ ] âŒœ x âŒ â‰¡ diag âŒœ_âŒ
    hit = complete (diag âŒœ_âŒ)

-- à¯àà àà—à²à¾ à¦ààµà¾à° : the door is exhibited, not merely asserted to exist.
next-door : {ğ’¬ : Typeâ‚€} (âŒœ_âŒ : Quote ğ’¬) â†’ Î£[ d âˆˆ Observable ğ’¬ ] ((x : ğ’¬) â†’ Â¬ (âŒœ x âŒ â‰¡ d))
next-door âŒœ_âŒ = diag âŒœ_âŒ , Î´-end âŒœ_âŒ

-- CHECKED: Agda 2.6.3, cubical **v0.7** (/tmp/cubical), --cubical --safe,
-- 2026-08-15.  No postulates, no holes.  NOT verified against the pin in
-- formal/cubical/BUILD.md (Agda 2.8.0, cubical v0.9), nor against the v0.5
-- the rest of this lane's headers quote: three toolchain states are live in
-- this repository at once and this file has only seen one of them.
