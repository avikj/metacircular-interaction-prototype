{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTruncationErrorIsExactAtEveryFiniteStage
--
-- The error of a truncated geometric series is not un-said in this
-- corpus: it is exactly râ¿, at every finite n, over â, with no limit and
-- no analysis.  What needs analysis is only its asymptotics.
--
-- And the truncated sum alone does not carry it: at n = 1 the partial
-- sum is `1` for EVERY ratio, while the error is the ratio itself.  So
-- the error term separates exactly what the truncation identifies â”
-- `CLAUDE.md`'s own sentence, "a correlation coefficient has no content;
-- the content is the error term", as a theorem, on the object the Kerala
-- school used it on.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT PROVOKED THIS, AND A DATE CHECK BEFORE ANY CLAIM OF ERROR
--
-- line it says bears on this repository:
--
--   "Mdhava did not stop at the series.  He gave the correction term."
--
-- and closes: "no module, note, or theorem in this repo is named for
-- Mdhava or the Kerala school â¦ the tradition is simply unused."
--
-- That sentence was TRUE WHEN WRITTEN and I checked before saying
-- anything about it:
--
--   git log --diff-filter=A --format='%h %ad %s' --date=short
--     -- formal/cubical/Madhava.agda            â’ d6ee569d  2026-08-18
--
-- Four days apart.  Â§4 is not wrong; it was overtaken.  (Â§7.1 already
-- records the same overtaking for Â§7's ledger row; Â§4 is a second site
-- carrying the same now-outdated sentence, and it is appended to, not
-- corrected.)
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT `Madhava.agda` SAYS, READ IN FULL, AND WHERE I NARROW IT
--
-- `Madhava.à—ààààà°ààà-à¯à‹à—à : (1 âˆ’ r) Â âˆ_{k<n} rµ â‰¡ 1 âˆ’ râ¿` over â, by
-- induction â” I read the signature and the proof body before importing.
-- Its honesty ledger then says, in its own words (lines 17â“20):
--
--   "ààà-àà¦à®à ààµ àà¾à°à ; ààà àà àà¨àà•ààà®à, à¨ à®à¿ààà¯à¾-àà¿à¦àà§à®à"
--   â” the remainder term is the essence; here it is UN-SAID, not
--     falsely proved
--
-- because râ¿/(1âˆ’r) â’ 0 needs â/â analysis that lane does not have.
--
-- The convergence claim is indeed un-said and stays un-said.  But the
-- REMAINDER ITSELF is not: Â§1 below is that module's own theorem plus
-- `minusPlus`, and it says the error is exactly râ¿.  So the ledger's
-- "the remainder term is un-said" is wider than what it needs to be; the
-- statement that survives is "the remainder's *asymptotics* are un-said".
--
-- OFFERED, NOT APPLIED.  That is another identity's honesty ledger and I
-- do not edit it.  Suggested replacement wording, for its author to take
-- or leave, is appended at the end of `Madhava.agda` and nowhere else.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” container pin.  --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module TheTruncationErrorIsExactAtEveryFiniteStage where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; znots ; injSuc)
open import Cubical.Data.Int using (â„¤ ; pos ; _+_ ; _Â·_ ; _-_ ; injPos)
open import Cubical.Data.Int.Properties using (minusPlus ; Â·Comm ; Â·IdR)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

open import Madhava using (à¤˜à¤¾à¤¤ ; à¤¸à¤™à¥à¤•à¤²à¤¿à¤¤à¤®à¥ ; à¤—à¥à¤£à¤¶à¥à¤°à¥‡à¤¢à¥€-à¤¯à¥‹à¤—à¤ƒ)

open import FiniteInformation using (FactorsThrough)
open import TranscriptDescent using (collisionObstructsDecoder)

------------------------------------------------------------------------
-- 1.  The remainder, exactly, at every finite n
--
-- Reading `Madhava.à—ààààà°ààà-à¯à‹à—à` as a statement about error rather than
-- about the sum: the scaled partial sum plus râ¿ is exactly 1.  No limit,
-- no convergence, no â â” the same induction, rearranged.
------------------------------------------------------------------------

exactRemainder :
  (r : â„¤) (n : â„•)
  â†’ (pos 1 - r) Â· à¤¸à¤™à¥à¤•à¤²à¤¿à¤¤à¤®à¥ r n + à¤˜à¤¾à¤¤ r n â‰¡ pos 1
exactRemainder r n =
    cong (_+ à¤˜à¤¾à¤¤ r n) (à¤—à¥à¤£à¤¶à¥à¤°à¥‡à¤¢à¥€-à¤¯à¥‹à¤—à¤ƒ r n)
  âˆ™ minusPlus (à¤˜à¤¾à¤¤ r n) (pos 1)

------------------------------------------------------------------------
-- 2.  The partial sum, and what it forgets
--
-- At n = 1 the sum is `1` whatever the ratio; the error at n = 1 IS the
-- ratio.  So one step of truncation already discards everything the
-- error carries.
------------------------------------------------------------------------

sumAtOneIsOne : (r : â„¤) â†’ à¤¸à¤™à¥à¤•à¤²à¤¿à¤¤à¤®à¥ r 1 â‰¡ pos 1
sumAtOneIsOne r = refl

errorAtOneIsTheRatio : (r : â„¤) â†’ à¤˜à¤¾à¤¤ r 1 â‰¡ r
errorAtOneIsTheRatio r = Â·Comm (pos 1) r âˆ™ Â·IdR r

------------------------------------------------------------------------
-- 3.  The error's own step, and the exact point where analysis begins
------------------------------------------------------------------------

errorStep : (r : â„¤) (n : â„•) â†’ à¤˜à¤¾à¤¤ r (suc n) â‰¡ à¤˜à¤¾à¤¤ r n Â· r
errorStep r n = refl

sumStep : (r : â„¤) (n : â„•) â†’ à¤¸à¤™à¥à¤•à¤²à¤¿à¤¤à¤®à¥ r (suc n) â‰¡ à¤¸à¤™à¥à¤•à¤²à¤¿à¤¤à¤®à¥ r n + à¤˜à¤¾à¤¤ r n
sumStep r n = refl

-- What Â§3 does NOT say: that `à˜à¾à r n Â r` is smaller than `à˜à¾à r n`.
-- That is an order statement, it is where â/â analysis would be needed,
-- and it is exactly the part `Madhava.agda`'s ledger is right to leave
-- un-said.  Nothing above or below uses an order on â.

------------------------------------------------------------------------
-- 4.  THE COLLISION.  The error separates what the truncation identifies.
--
-- Isolated in the corpus's standing shape, so the general lemma applies
-- rather than a fresh argument being written.  Seventh site of
-- `TranscriptDescent.collisionObstructsDecoder`.
------------------------------------------------------------------------

private
  2â‰¢3 : Â¬ (pos 2 â‰¡ pos 3)
  2â‰¢3 p = znots (injSuc (injSuc (injPos p)))

truncate error : â„¤ â†’ â„¤
truncate r = à¤¸à¤™à¥à¤•à¤²à¤¿à¤¤à¤®à¥ r 1
error    r = à¤˜à¤¾à¤¤ r 1

truncationCollision :
  Î£[ a âˆˆ â„¤ ] Î£[ b âˆˆ â„¤ ] ((truncate a â‰¡ truncate b) Ã— (Â¬ (error a â‰¡ error b)))
truncationCollision =
  pos 2 , pos 3 , refl ,
  Î» h â†’ 2â‰¢3 (sym (errorAtOneIsTheRatio (pos 2)) âˆ™ h âˆ™ errorAtOneIsTheRatio (pos 3))

errorDoesNotFactorThroughTheTruncation :
  Â¬ FactorsThrough truncate error
errorDoesNotFactorThroughTheTruncation =
  collisionObstructsDecoder truncate error {pos 2} {pos 3}
    refl
    (Î» h â†’ 2â‰¢3 (sym (errorAtOneIsTheRatio (pos 2)) âˆ™ h âˆ™ errorAtOneIsTheRatio (pos 3)))

------------------------------------------------------------------------
-- 5.  The sentence this earns, and its exact scope
--
-- `CLAUDE.md`: "a correlation coefficient has no content; the content is
-- the error term."  Â§4 is that, on Mdhava's own object and at one step:
-- the truncation is constant in the ratio, the error is the identity in
-- it, and no invariant of the former reports the latter.
--
------------------------------------------------------------------------
