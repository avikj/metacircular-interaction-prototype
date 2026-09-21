{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- àààà¾à¨à¿àµà¦ààà¾àµà â” Adhyy 1.1.56, and à²à‹àà â” 1.1.60, 1.1.62.
--
-- THE STRAS, in the vulgate text and numbering.
--
--   1.1.56  àààà¾à¨à¿àµà¦à¾à¦ààà‹à½à¨à²ààµà¿à§à   sthnivad deo 'nalvidhau
--           An dea (substitute) is like the sthnin (the original it
--           stands in place of) â” EXCEPT in an al-vidhi, an operation
--           conditioned on the sounds (aL is the pratyhra of the whole
--           inventory).  So the substitute inherits the original's
--           designations and not its form.
--
--   1.1.60  àà¦à°ààà¨à à²à‹àà            adarana lopa
--           Lopa is NON-APPEARANCE.
--
--   1.1.62  ààà°ààà¯à¯à²à‹àà ààà°ààà¯à¯à²à•àààà®à  pratyayalope pratyayalakaam
--           When an affix is elided, the operations conditioned by that
--           affix still apply.
--
--   1.3.9   àààà¯ à²à‹àà               tasya lopa
--           The it-marker is elided (having, by 1.3.2â“1.3.8, done its
--           marking).
--
--   1.1.5   à•àà™à¿àà¿ à                 kiti ca
--           No gua or vddhi when the affix is marked with k or  â” a
--           marking 1.3.9 erased before this rule is consulted.
--
-- Pini, ~500 BCE; Ktyyana's vrttikas ~250 BCE; Patajali's
-- Mahbhya ~150 BCE.
--
-- WHAT IS PROVED, and it is four statements, not a gloss.
--
--   anal-blind        A rule that reads only the designations gives the
--                     same answer on an dea and on its sthnin.  For
--                     EVERY such rule, into EVERY type, with no case
--                     analysis: the proof is that the rule factors
--                     through the designation and the dea preserves
--                     it.  That is representation independence, and it
--                     is the half of 1.1.56 that holds.
--
--   ec?-not-anal      The half that does not.  6.1.78 eco 'yavyva
--                     asks whether the sound is in eC, and there is
--                     provably NO function of the designations that
--                     agrees with it â” so 6.1.78 is not blind, cannot be
--                     made blind, and is exactly what `anal-vidhau`
--                     excepts.  The barrier is not leaky by oversight.
--
--   one-reading-fails No single reading serves both.  If one function
--                     from varas to forms satisfies the al-vidhi's
--                     requirement and the anal-vidhi's, the two forms
--                     are equal, and here they are not.  So the grammar
--                     needs the rule-indexed reading it has; a
--                     transparency setting is not enough, and neither is
--                     an opacity setting.
--
--   lopa-load-bearing The elided vara is absent from the surface and
--                     present to the conditions.  Two derivations with
--                     the same appearance differ in what 1.1.5 reads,
--                     so deletion and non-appearance are not the same
--                     operation.
--
-- THE WITNESSES ARE NOT INVENTED.  They are what `machine/Astadhyayi.hs`
-- computes.  `n ~ lyu` derives `nayana`, and its `barrierAudit` prints
--
--     6.1.78 is conditioned on the sounds, so it read the dea e and
--     not the sthnin 
--
-- because 7.3.84 had put `e` in place of ``.  And `ci ~ kta` derives
-- `cita` because 1.1.5 reads the `k` that 1.3.9 erased; make lopa a
-- deletion (`deriveWithoutLopa`) and it gives `ceta`.
--
-- Striking `anal-vidhau` (`deriveSthanivatEverywhere`) gives:
--
--   n ~ lyu   nayana â’ neyu.  7.3.84 reads the  it has itself just
--               replaced, re-offers the SAME gua, the offer is a no-op,
--               and the engine reads that as a fixpoint and halts three
--               rules early.  A gua rule that counts its own output as
--               the sthnin cannot tell that it has fired -- so without
--               the clause the derivation ends in the wrong PLACE, not
--               merely with the wrong sound.
--   tat + ca    tacca â’ tajca.  8.4.40 keeps reading the t that 8.2.39
--               replaced.
--   rmas       rma â’ rmar.  8.3.15 reads the s it was given in place
--               of, so its `r` condition is never met.
--   vc         vk â’ vk, in FIVE steps rather than three: 8.2.39 cycles
--               k â’ j â’ g and 8.4.56 cycles g â’ c â’ k, and the cycle lands
--               back on the attested form.  Same word, different
--               derivation -- a test on the form alone would have called
--               this agreement.
--   tat + jalam tajjalam â’ tajjalam, unchanged.
--
-- ONE MODELLING CHOICE, STATED.  1.1.56 is an atidea -- it EXTENDS the
-- sthnin's properties to the dea.  Here that is rendered as a READING:
-- `drsta anal` hands a rule the sthnin's form, `drsta al` the dea's.
-- That is one way to make "counts as the sthnin" operational and not the
-- only one; what it buys is that the exception clause becomes a switch
-- whose cost can be measured, and what it costs is that an extension of a
-- property is rendered as a substitution on the input.
--
-- PRIOR ART, searched before writing.  That sthnivadbhva has the shape
-- of an abstraction barrier is stated in this repository's own
-- reading came from and which flags it as unimplemented; the reading of
-- 1.1.56 as opacity-with-an-exception is standard in the commentarial
-- literature (the Kik's treatment of anal-vidhi; Kiparsky on the
-- architecture of the grammar).  What is here is the mechanisation and
-- the impossibility half â” that no designation-function agrees with an
-- al-vidhi, and that no single reading serves both â” which I did not
-- find stated, and which is cheap enough that if it is stated somewhere
-- I did not reach, this is a re-derivation and the citation is owed.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module Sthanivadbhava_TheSubstituteInheritsDesignationsNotForm where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; trueâ‰¢false ; _or_)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma using (Î£ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

------------------------------------------------------------------------
-- 1.  àµà°ààà â” form, designation, and what it stands in place of.
--
--     The three forms are the ones the derivation n + lyu passes
--     through at the aga's final position: , its gua substitute e,
--     and the a that 6.1.78 would produce from e.
------------------------------------------------------------------------

data Rupa : Type where
  Ä« e a : Rupa

-- Designations.  `kit` is the marking 1.3.8 confers and 1.3.9's erasure
-- does not remove; `pratyaya` and `anga` are the two the encoded
-- derivation needs.
data Samjna : Type where
  anga pratyaya kit : Samjna

record Varna : Type where
  constructor mk
  field
    rupa    : Rupa      -- the REPRESENTATION
    sthanin : Rupa      -- what it stands in place of (itself, if nothing)
    samjna  : Samjna    -- the INTERFACE

open Varna

-- An dea: a new form, the old form kept as the sthnin, the
-- designation inherited.  This IS 1.1.56, written as a constructor.
adesa : Rupa â†’ Varna â†’ Varna
adesa f v = mk f (rupa v) (samjna v)

-- the inheritance half, definitionally
adesa-inherits : (f : Rupa) (v : Varna) â†’ samjna (adesa f v) â‰¡ samjna v
adesa-inherits f v = refl

-- and it does not inherit the form
adesa-replaces : (f : Rupa) (v : Varna) â†’ rupa (adesa f v) â‰¡ f
adesa-replaces f v = refl

------------------------------------------------------------------------
-- 2.  àà¨à²ààµà¿à§à¿à â” a rule conditioned on designations and nothing else.
--
--     "Reads only the designations" is not an annotation on a rule; it
--     is the statement that the rule FACTORS THROUGH the designation.
------------------------------------------------------------------------

AnalVidhi : (A : Type) â†’ (Varna â†’ A) â†’ Type
AnalVidhi A r = Î£ (Samjna â†’ A) (Î» g â†’ (v : Varna) â†’ r v â‰¡ g (samjna v))

-- THEOREM (1.1.56, the half that holds).  An anal-vidhi cannot tell an
-- dea from its sthnin.  Every such rule, every target type, no case
-- analysis: the substitute counts as the original because the rule can
-- only see what the substitute inherited.
anal-blind : {A : Type} (r : Varna â†’ A) â†’ AnalVidhi A r
           â†’ (f : Rupa) (v : Varna) â†’ r (adesa f v) â‰¡ r v
anal-blind r (g , h) f v = h (adesa f v) âˆ™ sym (h v)

------------------------------------------------------------------------
-- 3.  àà²ààµà¿à§à¿à â” and the exception clause, which is not a hedge.
--
--     6.1.78 eco 'yavyva operates on eC.  Asking whether a sound is
--     in eC is asking about the sound.
------------------------------------------------------------------------

ec? : Rupa â†’ Bool
ec? Ä« = false
ec? e = true
ec? a = false

-- the rule as it stands in the engine: it reads the form
eco-yavayavah : Varna â†’ Bool
eco-yavayavah v = ec? (rupa v)

-- Two varas with the SAME designation and different verdicts.  The
-- second is the first's gua substitute â” which is precisely the pair
-- the derivation of nayana produces.
Ä«-anga  : Varna
Ä«-anga  = mk Ä« Ä« anga

e-anga  : Varna
e-anga  = adesa e Ä«-anga            -- 7.3.84's guá¹‡a: e standing for Ä«

-- THEOREM (1.1.56, the half that fails, and provably must).  There is NO
-- function of the designations that agrees with 6.1.78 â” so 6.1.78 is
-- not an anal-vidhi, cannot be recast as one, and `anal-vidhau` is
-- naming a real class and not softening a claim.
ec?-not-anal : Â¬ (AnalVidhi Bool eco-yavayavah)
ec?-not-anal (g , h) = trueâ‰¢false (h e-anga âˆ™ sym (h Ä«-anga))

-- and, concretely, the two readings of the SAME vara disagree
drsta-al : Varna â†’ Rupa
drsta-al v = rupa v

drsta-anal : Varna â†’ Rupa
drsta-anal v = sthanin v

reading-al : ec? (drsta-al e-anga) â‰¡ true
reading-al = refl

reading-anal : ec? (drsta-anal e-anga) â‰¡ false
reading-anal = refl

-- so 6.1.78 fires under the exception and does not fire without it: the
-- clause decides whether the rule applies at all
exception-decides : Â¬ (ec? (drsta-al e-anga) â‰¡ ec? (drsta-anal e-anga))
exception-decides p = trueâ‰¢false (sym reading-al âˆ™ p âˆ™ reading-anal)

------------------------------------------------------------------------
-- 4.  THE SHARP ONE.  No single reading serves both kinds of rule.
--
--     The modern folklore offers transparency or opacity.  Either one is
--     a single function from a substitute to what a rule sees.  Whichever
--     is chosen, one of the two requirements below fails, because the two
--     requirements pin the same value to two different forms.
------------------------------------------------------------------------

isE : Rupa â†’ Bool
isE Ä« = false
isE e = true
isE a = false

Ä«â‰¢e : Â¬ (Ä« â‰¡ e)
Ä«â‰¢e p = trueâ‰¢false (sym (cong isE p))

one-reading-fails
  : (see : Varna â†’ Rupa)
  â†’ see e-anga â‰¡ rupa e-anga        -- what an al-vidhi requires of it
  â†’ see e-anga â‰¡ sthanin e-anga     -- what an anal-vidhi requires of it
  â†’ âŠ¥
one-reading-fails see hal hanal = Ä«â‰¢e (sym hanal âˆ™ hal)

-- The positive form of the same fact: the grammar's reading is indexed
-- by the rule, and both indices are inhabited and used.
data Vidhi : Type where
  al anal : Vidhi

drsta : Vidhi â†’ Varna â†’ Rupa
drsta al   v = rupa v
drsta anal v = sthanin v

both-used : Î£ (Î£ Vidhi (Î» k â†’ ec? (drsta k e-anga) â‰¡ true))
                (Î» _ â†’ Î£ Vidhi (Î» k â†’ ec? (drsta k e-anga) â‰¡ false))
both-used = (al , refl) , (anal , refl)

------------------------------------------------------------------------
-- 5.  à²à‹àà â” 1.1.60 adarana lopa: NON-APPEARANCE.
--
--     An item is either present or elided.  The elided one contributes
--     nothing to what appears and everything it did to what conditions.
------------------------------------------------------------------------

data Item : Type where
  ph    : Varna â†’ Item
  lupta : Varna â†’ Item          -- 1.3.9's output, 1.1.60's adarÅ›ana

-- what appears
darsana : List Item â†’ List Rupa
darsana []              = []
darsana (ph v    âˆ· xs) = rupa v âˆ· darsana xs
darsana (lupta v âˆ· xs) = darsana xs

-- 1.1.60, definitionally: an elided vara does not appear
adarsanam : (v : Varna) (xs : List Item) â†’ darsana (lupta v âˆ· xs) â‰¡ darsana xs
adarsanam v xs = refl

-- 1.1.5 à•à™à¿àà¿ à, as the predicate it is: is anything here marked kit?
-- It reads the elided item too, which is 1.1.62.
kit? : Samjna â†’ Bool
kit? anga     = false
kit? pratyaya = false
kit? kit      = true

knit : List Item â†’ Bool
knit []              = false
knit (ph v    âˆ· xs) = kit? (samjna v) or knit xs
knit (lupta v âˆ· xs) = kit? (samjna v) or knit xs

------------------------------------------------------------------------
-- 6.  ci + kta, in the two implementations of "delete".
--
--     à•àà is enunciated k-t-a.  1.3.8 makes the k an it, 1.3.9 elides it.
--     The engine that keeps it as an adarana and the engine that removes
--     it have the same surface and different conditions.
------------------------------------------------------------------------

k-marker : Varna
k-marker = mk Ä« Ä« kit          -- the form is irrelevant; the marking is not

t-varna : Varna
t-varna = mk a a pratyaya

i-varna : Varna
i-varna = mk Ä« Ä« anga

-- 1.3.9's output: the marker present as adarana
elided : List Item
elided = ph i-varna âˆ· lupta k-marker âˆ· ph t-varna âˆ· []

-- a naive engine's output: the marker removed
deleted : List Item
deleted = ph i-varna âˆ· ph t-varna âˆ· []

-- the surfaces are identical
same-surface : darsana elided â‰¡ darsana deleted
same-surface = refl

-- and 1.1.5 reads them differently
knit-elided : knit elided â‰¡ true
knit-elided = refl

knit-deleted : knit deleted â‰¡ false
knit-deleted = refl

-- THEOREM.  Lopa is not deletion.  Two derivations that appear the same
-- give opposite answers to the rule that decides whether gua applies,
-- so `adarana` is carrying information that `remove` destroys â” and the
-- form that comes out is cita in the first case and ceta in the second.
lopa-load-bearing : Â¬ (knit elided â‰¡ knit deleted)
lopa-load-bearing p = trueâ‰¢false (sym knit-elided âˆ™ p âˆ™ knit-deleted)

-- and the information is not recoverable from the surface: any function
-- of the appearance alone answers the same on both.
darsana-cannot-see
  : (r : List Rupa â†’ Bool) â†’ r (darsana elided) â‰¡ r (darsana deleted)
darsana-cannot-see r = cong r same-surface

------------------------------------------------------------------------
-- 7.  THE TWO STATEMENTS TOGETHER.
--
-- 1.1.56 says a substitute carries the interface and not the
-- representation, and names the clients that get the representation
-- anyway.  1.1.60 says a deletion removes the appearance and not the
-- conditioning.  Both are statements about WHAT A LATER RULE MAY
-- OBSERVE, and neither is a statement about what the form is.  Â§2 is the
-- first as a factorisation theorem; Â§5â“6 is the second as a separation.
--
-- The engine in machine/Astadhyayi.hs runs on exactly this, and the
-- correspondence is stated with the engine's own names (checked against
-- it 2026-08-20, when the engine side was written):
--
--   `Varna` here          â’ there the item and a PARALLEL channel `Prov`,
--                           not one record.  The sthnin is a String and
--                           can hold two sounds joined, because 6.1.84
--                           eka prvaparayo heads a block whose
--                           substitute replaces two.
--   `adesa`               â’ `applyRwP`, which writes the dea into the
--                           word and the sthnin into the channel.
--   `Vidhi` / `al` `anal` â’ `Vidhi` / `AlVidhi` `AnalVidhi`, plus a third
--                           `NoVidhi` for a site holding no dea, where
--                           the two readings coincide and 1.1.56 has
--                           nothing to say.
--   `drsta`               â’ `drsta`, and `seenBy` is it lifted over a
--                           whole word for one stra.
--   which rules are which â’ `alVidhiTable`, one entry per stra with its
--                           reason, checked total.
--   `lupta`               â’ `Lupta`.
--   `knit`                â’ `knitPratyaya`, read by 7.3.84's guard.
------------------------------------------------------------------------
