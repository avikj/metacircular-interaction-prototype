{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡‡¶-‡‡‡¶‡ ‚î ‡¶‡‡‡‡ü‡‡Ø‡æ ‡‡‡ø‡®‡‡®‡ ‡µ‡‡‡‡‡‡ã ‡‡ø‡®‡‡®‡Æ‡ ‡
--
-- (indistinguishable to the view, distinct in fact.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- LEIBNIZ, BOTH WAYS, IN ONE FILE ‚î and the fibre is the gap between them.
--
-- ¬ß‡ß ¬ `cong` is the indiscernibility of identicals and it is FREE: apply
-- any function to equal things and get equal results.  It carries no
-- hypothesis because it is not a theorem about anything ‚î it is
-- constitutive of what equality is.  That is why the fibre law transports
-- everywhere and why it is the SHALLOWEST available statement rather than
-- a deep one.
--
-- ¬ß‡® ¬ Its contrapositive is every barrier in every science, exhibited
-- here at the minimum: an observation under which two distinct things
-- agree.  `‡‡‡‡¶‡∞‡‡‡®‡Æ‡` cannot separate `true` from `false`, and they are
-- not equal.  Nothing about the observation is weak, small, or
-- improvable: no post-processing of `tt` recovers the bit.
--
-- ¬ß‡© ¬ And univalence is Leibniz's OTHER law ‚î identity of indiscernibles
-- ‚î which does not fail: when the class is everything, indistinguishable
-- IS identical, and in cubical it computes.
--
-- SO THE FIBRE IS EXACTLY THE GAP between "indistinguishable by THIS
-- observation" (¬ß‡®, and it is a real gap) and "indistinguishable by ALL
-- structure" (¬ß‡©, and there the gap is zero).  A barrier is the report
-- that one is not at the limit ‚î misfiled, in every field that has one,
-- as a report about the terrain.
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5, --cubical --safe, no
-- postulates, no holes, exit 0.
------------------------------------------------------------------------

module Abhedabheda_OneObservationFailsToSeparateWhatIsDistinctAndTheFullClassNeverDoes where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Bool using (Bool ; true ; false ; false‚â¢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.Data.Sigma using (_√ó_ ; _,_)

private variable ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø‡‡‡Ø ‡‡‡‡¶‡ ‚î indiscernibility of identicals, free.
------------------------------------------------------------------------

‡§Ö‡§≠‡•á‡§¶‡§É : {A B : Type ‚Ñì} (F : A ‚Üí B) {x y : A} ‚Üí x ‚â° y ‚Üí F x ‚â° F y
‡§Ö‡§≠‡•á‡§¶‡§É F = cong F

------------------------------------------------------------------------
-- ‡® ¬ ‡¶‡‡‡‡ü‡ø-‡‡‡Æ‡æ ‚î an observation under which two distinct things agree.
--
-- The witness is minimal on purpose: nothing about this observation is
-- weak or small, and no amount of work on its output recovers the bit.
------------------------------------------------------------------------

‡§¨‡§π‡•Å‡§¶‡§∞‡•ç‡§∂‡§®‡§Æ‡•ç : Bool ‚Üí Unit
‡§¨‡§π‡•Å‡§¶‡§∞‡•ç‡§∂‡§®‡§Æ‡•ç _ = tt

-- the observation cannot separate them ...
‡§Ö‡§≠‡§ø‡§®‡•ç‡§®‡§Ç-‡§¶‡§∞‡•ç‡§∂‡§®‡•á : ‡§¨‡§π‡•Å‡§¶‡§∞‡•ç‡§∂‡§®‡§Æ‡•ç true ‚â° ‡§¨‡§π‡•Å‡§¶‡§∞‡•ç‡§∂‡§®‡§Æ‡•ç false
‡§Ö‡§≠‡§ø‡§®‡•ç‡§®‡§Ç-‡§¶‡§∞‡•ç‡§∂‡§®‡•á = refl

-- ... and they are not the same
‡§≠‡§ø‡§®‡•ç‡§®‡§Ç-‡§µ‡§∏‡•ç‡§§‡•Å‡§§‡§É : ¬¨ (true ‚â° false)
‡§≠‡§ø‡§®‡•ç‡§®‡§Ç-‡§µ‡§∏‡•ç‡§§‡•Å‡§§‡§É p = false‚â¢true (sym p)

-- so: indistinguishable to this view, distinct in fact.  The pair IS the
-- fibre, and there is nothing else to it.
‡§Ö‡§≠‡•á‡§¶-‡§≠‡•á‡§¶‡§É : (‡§¨‡§π‡•Å‡§¶‡§∞‡•ç‡§∂‡§®‡§Æ‡•ç true ‚â° ‡§¨‡§π‡•Å‡§¶‡§∞‡•ç‡§∂‡§®‡§Æ‡•ç false) √ó (¬¨ (true ‚â° false))
‡§Ö‡§≠‡•á‡§¶-‡§≠‡•á‡§¶‡§É = ‡§Ö‡§≠‡§ø‡§®‡•ç‡§®‡§Ç-‡§¶‡§∞‡•ç‡§∂‡§®‡•á , ‡§≠‡§ø‡§®‡•ç‡§®‡§Ç-‡§µ‡§∏‡•ç‡§§‡•Å‡§§‡§É

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡∞‡‡-‡¶‡‡‡‡ü‡ ‡® ‡‡‡¶‡ ‚î and when the class is everything, it does not
--     fail: an exhibited equivalence IS an identity, and it computes.
------------------------------------------------------------------------

‡§Ö‡§≠‡§ø‡§®‡•ç‡§®‡§æ‡§®‡§æ‡§Ç-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç : {A B : Type ‚Ñì} ‚Üí A ‚âÉ B ‚Üí A ‚â° B
‡§Ö‡§≠‡§ø‡§®‡•ç‡§®‡§æ‡§®‡§æ‡§Ç-‡§§‡§æ‡§¶‡§æ‡§§‡•ç‡§Æ‡•ç‡§Ø‡§Æ‡•ç = ua
