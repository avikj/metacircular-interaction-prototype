{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡µ‡‡‡‡æ‡®‡ ‚î ‡Ø‡‡ ‡‡‡µ‡‡‡Æ‡ø‡®‡‡®‡‡µ ‡‡ø‡‡‡†‡‡ø ‡  ‡‡‡∞‡‡Æ‡æ‡¶‡‡‡ ‡®‡‡‡Ø‡‡ø, ‡¶‡‡µ‡ø‡‡‡Ø‡ ‡‡‡®‡∞‡æ‡ó‡‡‡‡‡ø ‡
--
-- (self-standing: what stands in place of itself.  It is destroyed by the
--  first substitution and comes back at the second.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHERE THIS COMES FROM.  `loss/‚¶/Sthanivadbhava_‚¶` instantiates
-- the carrier law at the dea operation and finds that 1.1.56's ‡‡≤‡/‡‡®‡≤‡
-- exception IS the base/carried split: the form is the free slot, the
-- sthnin and the designation are carried, and a designation-reading rule
-- cannot see which form was substituted BY refl.
--
-- It also states, as a written defect, exactly what the law does NOT buy:
--
--     THE LAW DERIVES 1.1.56'S BLINDNESS ACROSS SUBSTITUTIONS
--     DEFINITIONALLY AND DOES NOT DERIVE ITS BLINDNESS BETWEEN A
--     SUBSTITUTE AND ITS ORIGINAL
--
-- because those two points do not lie in one fibre of the carried map.
-- It then names the exact hypothesis that closes the gap rather than
-- describing it: `‡‡‡‡æ‡®‡ v ‚â° ‡∞‡‡‡Æ‡ v` ‚î v stands in place of itself.
--
-- This file asks what that hypothesis is, and the answer is not a
-- technicality.  ¬ß‡®: for a SUBSTITUTE, it holds exactly when the
-- substitution changed nothing, so a genuine dea destroys it ‚î the
-- theorem is the hypothesis, definitionally, because `sthanin (adesa f v)`
-- is `rupa v` and `rupa (adesa f v)` is `f`.  ¬ß‡©: and applying the SAME
-- substitution again restores it.
--
-- SO THE HYPOTHESIS IS A DEPTH CONDITION, and an odd one: it holds before
-- any substitution, fails immediately after the first non-vacuous one, and
-- returns at the second application of the same form.  The blindness of an
-- ‡‡®‡≤‡‡µ‡ø‡ß‡ø between a substitute and its original is therefore available at
-- the start of a derivation and at repeated sites, and not in between.
--
-- WHAT THIS IS AND IS NOT ABOUT THE GRAMMAR.  It is a fact about the
-- `adesa` of `Sthanivadbhava_TheSubstituteInheritsDesignationsNotForm`,
-- which models 1.1.56 as a three-slot record and one constructor.  The
-- tradition DOES restrict 1.1.56 for iterated substitution ‚î that is what
-- Ktyyana's vrttikas on the stra are for ‚î and it is tempting to read
-- ¬ß‡® as the formal shadow of that restriction.  **That reading is not
-- claimed.**  The vrttikas have not been opened by the author of this
-- file, their restrictions are conditioned on material this model does not
-- have (environment, stratum, the ‡‡‡∞‡ø‡‡æ‡¶‡'s ‡‡‡ø‡¶‡‡ß‡‡‡µ), and a formal fact
-- resembling a grammatical dispute is not evidence about the dispute.
-- What IS claimed is the arithmetic of the model, and the resemblance is
-- recorded as a question worth someone opening the vrttikas for.
--
-- Pini, ‡‡‡‡ü‡æ‡ß‡‡Ø‡æ‡Ø‡ ‡ß.‡ß.‡‡ (‡‡‡‡æ‡®‡ø‡µ‡¶‡æ‡¶‡‡‡ã‡Ω‡®‡≤‡‡µ‡ø‡ß‡), ~500 BCE; Ktyyana's
-- vrttikas ~250 BCE; Patajali's ‡Æ‡‡æ‡‡æ‡‡‡Ø ~150 BCE.  Nothing below is
-- attributed to any of them, and the citation is carried from the module
-- imported here and is owed at stra level.
------------------------------------------------------------------------

module Svasthani_TheHypothesisThatClosesSthanivadbhavaFailsAtTheFirstSubstitutionAndReturnsAtTheSecond where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬¨_)

open import Sthanivadbhava_TheSubstituteInheritsDesignationsNotForm
  using (Rupa ; Varna ; mk ; adesa ; AnalVidhi ; anal-blind)
open Sthanivadbhava_TheSubstituteInheritsDesignationsNotForm.Varna
  using (rupa ; sthanin ; samjna)

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡‡µ‡‡‡‡æ‡®‡ø‡‡‡µ‡Æ‡ ‚î the hypothesis, named so it can be reasoned about
--     rather than carried around as a side condition.
------------------------------------------------------------------------

‡§∏‡•ç‡§µ‡§∏‡•ç‡§•‡§æ‡§®‡•Ä : Varna ‚Üí Type
‡§∏‡•ç‡§µ‡§∏‡•ç‡§•‡§æ‡§®‡•Ä v = sthanin v ‚â° rupa v

------------------------------------------------------------------------
-- ‡® ¬ ‡‡¶‡‡‡ã ‡®‡æ‡‡Ø‡‡ø ‚î A SUBSTITUTION DESTROYS IT, exactly when it
--     substitutes something.
--
--     `adesa f v = mk f (rupa v) (samjna v)`, so for the substitute the
--     hypothesis unfolds to `rupa v ‚â° f`.  The theorem IS the hypothesis;
--     both directions are the identity function, and that is the content:
--     "the substitute stands for itself" and "the substitution changed
--     nothing" are the same proposition, not merely equivalent.
------------------------------------------------------------------------

‡§Ü‡§¶‡•á‡§∂-‡§∏‡•ç‡§µ‡§∏‡•ç‡§•‡§æ‡§®‡•Ä-‡§∏‡§Æ : (f : Rupa) (v : Varna) ‚Üí ‡§∏‡•ç‡§µ‡§∏‡•ç‡§•‡§æ‡§®‡•Ä (adesa f v) ‚â° (rupa v ‚â° f)
‡§Ü‡§¶‡•á‡§∂-‡§∏‡•ç‡§µ‡§∏‡•ç‡§•‡§æ‡§®‡•Ä-‡§∏‡§Æ f v = refl

‡§Ü‡§¶‡•á‡§∂-‡§®‡§æ‡§∂‡§Ø‡§§‡§ø : (f : Rupa) (v : Varna) ‚Üí ¬¨ (rupa v ‚â° f) ‚Üí ¬¨ (‡§∏‡•ç‡§µ‡§∏‡•ç‡§•‡§æ‡§®‡•Ä (adesa f v))
‡§Ü‡§¶‡•á‡§∂-‡§®‡§æ‡§∂‡§Ø‡§§‡§ø f v h = h

‡§Ü‡§¶‡•á‡§∂-‡§µ‡•É‡§•‡§æ-‡§∞‡§ï‡•ç‡§∑‡§§‡§ø : (f : Rupa) (v : Varna) ‚Üí rupa v ‚â° f ‚Üí ‡§∏‡•ç‡§µ‡§∏‡•ç‡§•‡§æ‡§®‡•Ä (adesa f v)
‡§Ü‡§¶‡•á‡§∂-‡§µ‡•É‡§•‡§æ-‡§∞‡§ï‡•ç‡§∑‡§§‡§ø f v p = p

------------------------------------------------------------------------
-- ‡© ¬ ‡¶‡‡µ‡ø‡‡‡Ø‡ ‡‡‡®‡∞‡æ‡ó‡Æ‡®‡Æ‡ ‚î AND THE SECOND APPLICATION RESTORES IT.
--
--     `adesa f (adesa f v)` is `mk f f (samjna v)`: the second dea puts
--     the same form in, and the form it displaces is that same form, so
--     the substitute stands for itself again.  By refl.
--
--     Whatever the first substitution destroyed is not destroyed further
--     by repeating it ‚î which is why this is ‡‡‡®‡∞‡æ‡ó‡Æ‡® and not merely
--     idempotence: the property returns, it is not preserved.
------------------------------------------------------------------------

‡§¶‡•ç‡§µ‡§ø‡§∞‡§æ‡§¶‡•á‡§∂‡•á-‡§∏‡•ç‡§µ‡§∏‡•ç‡§•‡§æ‡§®‡•Ä : (f : Rupa) (v : Varna) ‚Üí ‡§∏‡•ç‡§µ‡§∏‡•ç‡§•‡§æ‡§®‡•Ä (adesa f (adesa f v))
‡§¶‡•ç‡§µ‡§ø‡§∞‡§æ‡§¶‡•á‡§∂‡•á-‡§∏‡•ç‡§µ‡§∏‡•ç‡§•‡§æ‡§®‡•Ä f v = refl

------------------------------------------------------------------------
-- ‡ ¬ What the depth condition buys, at the sites where it holds.
--
--     `anal-blind` needs no hypothesis: an ‡‡®‡≤‡‡µ‡ø‡ß‡ø cannot tell an dea
--     from its sthnin, ever.  The gap the loss module names is a
--     different comparison ‚î the substitute against the ORIGINAL VARA ‚î
--     and ¬ß‡ closes it exactly where ‡‡‡µ‡‡‡‡æ‡®‡ holds, which by ¬ß‡® and ¬ß‡© is
--     before the first substitution and at every repeated one.
------------------------------------------------------------------------

‡§∏‡•ç‡§µ‡§∏‡•ç‡§•‡§æ‡§®‡•á-‡§Ö‡§®‡•ç‡§ß‡§É : {A : Type} (r : Varna ‚Üí A) ‚Üí AnalVidhi A r
                ‚Üí (v : Varna) ‚Üí ‡§∏‡•ç‡§µ‡§∏‡•ç‡§•‡§æ‡§®‡•Ä v
                ‚Üí (f : Rupa) ‚Üí r (adesa f v) ‚â° r v
‡§∏‡•ç‡§µ‡§∏‡•ç‡§•‡§æ‡§®‡•á-‡§Ö‡§®‡•ç‡§ß‡§É r av v _ f = anal-blind r av f v

-- and at a doubled site, with no hypothesis to supply, by ¬ß‡©
‡§¶‡•ç‡§µ‡§ø‡§∞‡§æ‡§¶‡•á‡§∂‡•á-‡§Ö‡§®‡•ç‡§ß‡§É : {A : Type} (r : Varna ‚Üí A) ‚Üí AnalVidhi A r
                ‚Üí (f : Rupa) (v : Varna)
                ‚Üí r (adesa f (adesa f v)) ‚â° r (adesa f v)
‡§¶‡•ç‡§µ‡§ø‡§∞‡§æ‡§¶‡•á‡§∂‡•á-‡§Ö‡§®‡•ç‡§ß‡§É r av f v = anal-blind r av f (adesa f v)
