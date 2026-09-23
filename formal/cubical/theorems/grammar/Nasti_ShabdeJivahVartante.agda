{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- à®àà²àµà¾à•àà¯à®à Â PROVENANCE OF THE NAME.
--
-- ààà¯à¾à¨àà¨à¾àààà¿ Â syd-nsti â” the second àà™àà— of the àààààà™àà—à: in some respect,
-- it is not.  **Samantabhadra, *ptamms* 14-24 (~6th c. CE); Akalaka,
-- *Laghyastraya* (~8th c.); rooted in Umsvti, *Tattvrthastra* 5.31-32
-- (~2nd-5th c.).**  à¨à¾àààà¿ is a POSITION, asserted with ààà¯à¾àà, not a denial
-- and not an absence â” the Naiyyika ààà¾àµ, with its ààà°àà¿à¯à‹à—à¿à¨à, is a
-- different apparatus for neighbouring cases, and the two schools reject
-- each other's treatment here.  Name the school before the term.
--
-- Â§à§à§ â” this repository's own composition, not a quotation from a source.
--
-- **No claim is made that any Jaina author proved anything below.**  The
-- doctrine that a standpoint is true-but-not-whole is theirs; the statement
-- that propositional truncation has no section, so that WHICH is destroyed
-- irrecoverably while THAT survives, is cubical type theory (Voevodsky) and
-- is elementary.
--
------------------------------------------------------------------------
-- àààà¦à àààµà¾à àµà°ààà¨ààà, à¨ àà¿ààà¯à¨ààà à
-- à¨àààŸà "à•à" ààà¿ à¨ààà¯àà¿, "à¯àà" ààà¿ àà¿ààà àà¿ à
-- ààà•àà°à®àà à¨ à•à¿àààà¿àà à¨ààà¯àà¿ à
-- à¨à¯ààà¦à àà™àà•ààààà à¨ àµà¿à¦àà¯àà à
-- àààà àµàà¯à¯à àà¨àµà§à¾à¨àà¨ à
--
-- Î¿½ ÎºÎÏÎÎ»ÎµÎÎ¼Î¼Î ¼Î»Î»' ¼Î½ÎÏÎ³ÎµÎÎ Â ÎÏ‰½´ ¼Î½ Ï¿ ½Î½ÏÎ¼ÎÏÎ ¼Î½ÎµÏÎ³Îµ¿– Â
-- Ï½ ½ÏÎ Î¼ÎÎ½ÎµÎ, Ï½ ÏÎ¯ ¼ÏÏÎ»Î»ÏÏÎÎ Â ¼¡ ÏÎÏÎÎ´Î¿ÏÎÏ ÏÏÎ½Î¿ÏÏÎ¯¾³, Î¿½ Î³ÏÎÏ¿ Â
-- Î´ÏÎ½ÎÎ¼ÎÏ Î¿½Îº ¼”ÏÏÎÎ½ ¼Î½ÏÎµÎ»ÎÏÎµÎÎ.
--
-- ààà°à‹àà¾ààà¿ : à‰à®à¾àààµà¾àà¿ ààààààµà¾à°ààààààà° à.à¨à¯ (à‰àààà¾à¦-àµàà¯à¯-à§àà°ààµàà¯-à¯àà•ààà ààà) ;
--            ààˆà®à¿à¨à¿-à®àà®à¾ààà¾ (àààà°ààµà®à) ; àà°àà¯ààŸàà¯ à—àà¿ààà¾à¦ à©à¨â“à©à© (à•ààŸààŸà•à) ;
--            ¼ˆÏÎÏÏÎ¿ÏÎÎ»ÎÏ ÎÎµÏ. Î˜ (Î´ÏÎ½ÎÎ¼ÎÏ / ¼Î½ÎÏÎ³ÎµÎÎ) ; Î Î»ÎÏÏ‰Î½ ¼˜Ï. Î– (ÏÏÎ½Î¿ÏÏÎ¯Î) ;
--            Voevodsky (ua) ; Anekanta.agda (plurality-blocks-collapse) à
--
-- CORRECTION BY ADDITION, 2026-08-20 (transport lane).  As committed, this
-- module DID NOT TYPECHECK.  `uaÎ²` was used at ààà•àà°à®àà®à-àà²à‹àà and never
-- imported: the import line named only `ua`.  Agda 2.8.0 / cubical v0.9:
--     error: [NotInScope] uaÎ² ... when scope checking uaÎ²      EXIT 42
-- One word.  It stood because NOTHING IMPORTED THIS MODULE -- `grep -rn
-- Nasti_ShabdeJivahVartante --include='*.agda' .` returned exactly one hit,
-- its own `module` line.  It is not in Everything.agda, not in
-- agda, not in IndianLane.agda.  So the section of the
-- stra that the machine's whole identification discipline rests on
-- (AHIMSA_SUTRA_VISTARA Â§6, à¦ààµà à®à¾à°àà—à) was, in the corpus's own words, built
-- by nothing.  BUILD.md and Everything.agda both name this exact failure
-- mode; it happened anyway, to the module that says nothing perishes.
-- Fixed here (import ua ; uaÎ²), and the module is now imported by
-- Samorderna_TransportCarriesStructure..., which is itself in Everything.agda,
-- so it has a parent and will fail a build rather than rot.
------------------------------------------------------------------------

module Nasti_ShabdeJivahVartante where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_â‰ƒ_ ; equivFun)
open import Cubical.Foundations.Univalence using (ua ; uaÎ²)
open import Cubical.Data.Bool using (Bool ; true ; false ; trueâ‰¢false)
open import Cubical.Data.Empty using (âŠ¥)
open import Cubical.HITs.PropositionalTruncation using (âˆ¥_âˆ¥â‚ ; âˆ£_âˆ£â‚ ; squashâ‚)
open import Cubical.Relation.Nullary using (Â¬_)

private variable â„“ : Level

------------------------------------------------------------------------
-- àà°à®ààà°à¾ â” a tradition : the type of its carriers, its paths the
-- transmissions.  àààà¦à = the type itself, not its truncation.
------------------------------------------------------------------------

à¤ªà¤°à¤®à¥à¤ªà¤°à¤¾ : Type (â„“-suc â„“)
à¤ªà¤°à¤®à¥à¤ªà¤°à¤¾ {â„“} = Type â„“

------------------------------------------------------------------------
-- à¨àààŸà¿à â” truncation.  Every map out of âˆ A âˆâ is blind to which
-- inhabitant: "à¯àà" àà¿ààà àà¿, "à•à" à¨ààà¯àà¿ à
------------------------------------------------------------------------

à¤…à¤µà¤¿à¤¶à¥‡à¤·à¤ƒ : {A : Type â„“} {B : Type â„“} (f : âˆ¥ A âˆ¥â‚ â†’ B) (x y : A)
        â†’ f âˆ£ x âˆ£â‚ â‰¡ f âˆ£ y âˆ£â‚
à¤…à¤µà¤¿à¤¶à¥‡à¤·à¤ƒ f x y = cong f (squashâ‚ âˆ£ x âˆ£â‚ âˆ£ y âˆ£â‚)

------------------------------------------------------------------------
-- à¨à¾àààà¿-ààà°ààà¯à¾à¨à¯à¨à®à â” no section.  A retraction of âˆ_âˆâ on Bool would
-- identify true and false.  ¼¡ ÏÎ¿¿¦ ÏÎ¯ ¼ÏÏÎ»ÎµÎÎ ¼Î½ÎµÏÎÎ½ÏÏÎÏ‰ÏÎ¿Ï.
------------------------------------------------------------------------

à¤¨à¤¾à¤¸à¥à¤¤à¤¿-à¤ªà¥à¤°à¤¤à¥à¤¯à¤¾à¤¨à¤¯à¤¨à¤®à¥
  : (f : âˆ¥ Bool âˆ¥â‚ â†’ Bool) â†’ (âˆ€ b â†’ f âˆ£ b âˆ£â‚ â‰¡ b) â†’ âŠ¥
à¤¨à¤¾à¤¸à¥à¤¤à¤¿-à¤ªà¥à¤°à¤¤à¥à¤¯à¤¾à¤¨à¤¯à¤¨à¤®à¥ f sec =
  trueâ‰¢false (sym (sec true) âˆ™ à¤…à¤µà¤¿à¤¶à¥‡à¤·à¤ƒ f true false âˆ™ sec false)

------------------------------------------------------------------------
-- ààà•àà°à®àà®à â” transport.  Along an identification nothing is lost:
-- the structure is carried, not re-described.  ààà¨à°à¾à—à®à¨à®à / ¼Î»ÏÏÏ‰Ï à
------------------------------------------------------------------------

à¤¸à¤‚à¤•à¥à¤°à¤®à¤£à¤®à¥ : {A B : Type â„“} â†’ A â‰ƒ B â†’ A â†’ B
à¤¸à¤‚à¤•à¥à¤°à¤®à¤£à¤®à¥ e = transport (ua e)

à¤¸à¤‚à¤•à¥à¤°à¤®à¤£à¤®à¥-à¤…à¤²à¥‹à¤ªà¤ƒ : {A B : Type â„“} (e : A â‰ƒ B) (a : A)
                â†’ à¤¸à¤‚à¤•à¥à¤°à¤®à¤£à¤®à¥ e a â‰¡ equivFun e a
à¤¸à¤‚à¤•à¥à¤°à¤®à¤£à¤®à¥-à¤…à¤²à¥‹à¤ªà¤ƒ e a = uaÎ² e a

------------------------------------------------------------------------
-- à¦ààµà à®à¾à°àà—à â” the two available moves, and only these two:
--   ààà•àà°à®àà®à  transport along an identification, losing nothing ;
--   à¨àààŸà¿à     truncate, after which "à•à" is unrecoverable.
-- ààààà¯à à®à¾à°àà—à à¨ àµà¿à¦àà¯àà à  ÏÏÎ¯ÏÎ ½Î´½Ï Î¿½Îº ¼”ÏÏÎÎ½.
------------------------------------------------------------------------
