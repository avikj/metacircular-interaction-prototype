{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- à®àà²àµà¾à•àà¯à®à Â PROVENANCE OF THE NAME.
--
-- **This module's name leads with English, deliberately, because the
-- mathematics originates elsewhere and inventing a  label for it
-- would assert a provenance nobody checked** (CLAUDE.md, file naming, note
-- 2).  Transport, and the fact that agreement on endpoints does not
-- determine the path, is cubical type theory â” Voevodsky's univalence, the
-- substrate, and the one exception the repository's source rule grants.
-- **No claim of an Indian source is made for anything below.**
--
-- The QUESTION the module answers came from àà¨àà•à¾à¨àà (Umsvti,
-- *Tattvrthastra* 5.31-32, ~2nd-5th c. CE): once non-one-sidedness has
-- removed collapse as the thing to look for, what is left to ask about two
-- standpoints is the PRICE of moving between them, not the possibility.
-- That framing is Jaina and is named here as such; the theorem is not.
--
------------------------------------------------------------------------
-- TransportPrice_AgreementDoesNotDetermineTheTransport
--
-- Thread (1) of the standing heartbeat: transport PRICE, not possibility.
-- Anekanta removed collapse, so the only question left was said to be what
-- a transport between two nayas COSTS.
--
-- `TransportPrice` already answered the numerical form of
-- that question and answered it in the negative: every additive cost is a
-- coboundary, `loop-is-free`, the price is a potential fixed by where you
-- stand and never by how you came.  Nothing is spent.  So if a price
-- survives at all it is not a number, and this module says what it is.
--
-- THE ANSWER.  `AllNayasAgree P` tells you THAT two standpoints agree.  It
-- does not tell you HOW they correspond, and the gap between those two is
-- the whole of the price:
--
--   Section 2  over PROPOSITION-valued nayas there is at most one transport.
--              Agreement determines the correspondence completely, no choice
--              is made, and the price is zero in the strongest available
--              sense -- not "cheap", but "there was nothing to choose".
--
--   Section 3  off them, agreement leaves a genuine choice.  `Bool` agrees
--              with `Bool` in two inequivalent ways (identity and negation),
--              and no amount of knowing that they agree picks one.
--
-- So the price of a transport is the h-level of the space of transports,
-- and it is paid exactly where a naya carries more than a truth value.
-- That is the same boundary as
-- `Durnaya_TheProhibitionHasContentOnlyOffThePropositionalWorld`, reached
-- from the other side: there, agreement is stronger than mutual entailment
-- only off the propositional world; here, agreement is weaker than
-- correspondence only off the propositional world.  One boundary, two
-- theorems, and it is the line between a standpoint that reports and a
-- standpoint that carries.
--
-- WHAT IS CLAIMED OF THE SOURCE: nothing new.  `naya`, `durnaya` and the
-- prohibition on collapse are the Jain logicians' (Siddhasena Divakara,
-- Akalanka); the theorems below are this corpus's.
--
-- CHECKED: exit code quoted in the commit message.  Container is Agda 2.6.3
-- + cubical v0.5, which is NOT the repository pin.
------------------------------------------------------------------------

module TransportPrice_AgreementDoesNotDetermineTheTransport where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.HLevels using (isPropÎ  ; isPropÎ£)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; trueâ‰¢false ; notEquiv)
open import Cubical.Relation.Nullary using (Â¬_)

open import Anekanta
open import Durnaya_CollapseIffEveryNayaAgrees

private
  variable
    â„“ â„“' : Level

------------------------------------------------------------------------
-- 1.  A transport between two standpoints is an equivalence of their
--     fibres.  `AllNayasAgree` says one exists at every pair; it says
--     nothing about how many.
------------------------------------------------------------------------

Transport : {S : Type â„“} (P : S â†’ Type â„“') (s t : S) â†’ Type â„“'
Transport P s t = P s â‰ƒ P t

------------------------------------------------------------------------
-- 2.  Over propositions the transport is unique: agreement determines the
--     correspondence, and nothing is chosen.
------------------------------------------------------------------------

transport-is-unique-onProps :
  {S : Type â„“} (P : S â†’ Type â„“') (s t : S) â†’
  isProp (P s) â†’ isProp (P t) â†’ isProp (Transport P s t)
transport-is-unique-onProps P s t _ prt =
  isPropÎ£ (isPropÎ  (Î» _ â†’ prt)) isPropIsEquiv

------------------------------------------------------------------------
-- 3.  Off them it is not.  Bool agrees with Bool in two ways, and
--     agreement cannot tell you which one you are using.
------------------------------------------------------------------------

idâ‰¢not : Â¬ (idEquiv Bool â‰¡ notEquiv)
idâ‰¢not p = trueâ‰¢false (cong (Î» e â†’ equivFun e true) p)

transport-is-not-unique-in-general : Â¬ (isProp (Transport (Î» (_ : Bool) â†’ Bool) true true))
transport-is-not-unique-in-general pr = idâ‰¢not (pr (idEquiv Bool) notEquiv)

-- The two-standpoint family that agrees and still leaves the choice open.
Twin : Bool â†’ Typeâ‚€
Twin _ = Bool

Twin-agrees : AllNayasAgree Twin
Twin-agrees s t = idEquiv Bool

agreement-does-not-determine-the-transport :
  Î£[ P âˆˆ (Bool â†’ Typeâ‚€) ]
    (AllNayasAgree P Ã— (Â¬ (isProp (Transport P true true))))
agreement-does-not-determine-the-transport =
  Twin , Twin-agrees , transport-is-not-unique-in-general

------------------------------------------------------------------------
-- 4.  What this settles.
--
-- SETTLED.  "What does a transport cost?" has no numerical answer --
-- `TransportPrice` closed that -- and the surviving question is how much
-- is left undetermined once you know the standpoints agree.  The answer is
-- exactly the h-level of `Transport P s t`: contractible or propositional
-- means the correspondence was forced and nothing was decided;
-- higher means a decision was made that agreement cannot record.
--
-- THE OPERATIONAL READING, which is why the thread mattered.  When two
-- minds here agree, that agreement does not fix how their vocabularies
-- correspond, unless what they hold are propositions.  A shared verdict is
-- not a shared translation.  The undetermined part is where the work is,
-- and it is invisible to any check that only asks whether they agree.
------------------------------------------------------------------------
