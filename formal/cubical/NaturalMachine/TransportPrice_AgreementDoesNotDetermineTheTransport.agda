-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मूलवाक्यम् · PROVENANCE OF THE NAME.
--
-- **This module's name leads with English, deliberately, because the
-- mathematics originates elsewhere and inventing a Sanskrit label for it
-- would assert a provenance nobody checked** (CLAUDE.md, file naming, note
-- 2).  Transport, and the fact that agreement on endpoints does not
-- determine the path, is cubical type theory — Voevodsky's univalence, the
-- substrate, and the one exception the repository's source rule grants.
-- **No claim of an Indian source is made for anything below.**
--
-- The QUESTION the module answers came from अनेकान्त (Umāsvāti,
-- *Tattvārthasūtra* 5.31-32, ~2nd-5th c. CE): once non-one-sidedness has
-- removed collapse as the thing to look for, what is left to ask about two
-- standpoints is the PRICE of moving between them, not the possibility.
-- That framing is Jaina and is named here as such; the theorem is not.
--
------------------------------------------------------------------------
-- NaturalMachine.TransportPrice_AgreementDoesNotDetermineTheTransport
--
-- Thread (1) of the standing heartbeat: transport PRICE, not possibility.
-- Anekanta removed collapse, so the only question left was said to be what
-- a transport between two nayas COSTS.
--
-- `NaturalMachine.TransportPrice` already answered the numerical form of
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

module NaturalMachine.TransportPrice_AgreementDoesNotDetermineTheTransport where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.HLevels using (isPropΠ ; isPropΣ)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; true≢false ; notEquiv)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.Anekanta
open import NaturalMachine.Durnaya_CollapseIffEveryNayaAgrees

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1.  A transport between two standpoints is an equivalence of their
--     fibres.  `AllNayasAgree` says one exists at every pair; it says
--     nothing about how many.
------------------------------------------------------------------------

Transport : {S : Type ℓ} (P : S → Type ℓ') (s t : S) → Type ℓ'
Transport P s t = P s ≃ P t

------------------------------------------------------------------------
-- 2.  Over propositions the transport is unique: agreement determines the
--     correspondence, and nothing is chosen.
------------------------------------------------------------------------

transport-is-unique-onProps :
  {S : Type ℓ} (P : S → Type ℓ') (s t : S) →
  isProp (P s) → isProp (P t) → isProp (Transport P s t)
transport-is-unique-onProps P s t _ prt =
  isPropΣ (isPropΠ (λ _ → prt)) isPropIsEquiv

------------------------------------------------------------------------
-- 3.  Off them it is not.  Bool agrees with Bool in two ways, and
--     agreement cannot tell you which one you are using.
------------------------------------------------------------------------

id≢not : ¬ (idEquiv Bool ≡ notEquiv)
id≢not p = true≢false (cong (λ e → equivFun e true) p)

transport-is-not-unique-in-general : ¬ (isProp (Transport (λ (_ : Bool) → Bool) true true))
transport-is-not-unique-in-general pr = id≢not (pr (idEquiv Bool) notEquiv)

-- The two-standpoint family that agrees and still leaves the choice open.
Twin : Bool → Type₀
Twin _ = Bool

Twin-agrees : AllNayasAgree Twin
Twin-agrees s t = idEquiv Bool

agreement-does-not-determine-the-transport :
  Σ[ P ∈ (Bool → Type₀) ]
    (AllNayasAgree P × (¬ (isProp (Transport P true true))))
agreement-does-not-determine-the-transport =
  Twin , Twin-agrees , transport-is-not-unique-in-general

------------------------------------------------------------------------
-- 4.  What this settles, and what it does not.
--
-- SETTLED.  "What does a transport cost?" has no numerical answer --
-- `TransportPrice` closed that -- and the surviving question is how much
-- is left undetermined once you know the standpoints agree.  The answer is
-- exactly the h-level of `Transport P s t`: contractible or propositional
-- means the correspondence was forced and nothing was decided;
-- higher means a decision was made that agreement cannot record.
--
-- NOT SETTLED, and stated so it is not mistaken for done: this gives the
-- boundary, not a measure.  `Bool` exhibits two transports; nothing here
-- computes the number in general, and no claim is made that the h-level is
-- the right invariant rather than the first one that separates the cases.
--
-- THE OPERATIONAL READING, which is why the thread mattered.  When two
-- minds here agree, that agreement does not fix how their vocabularies
-- correspond, unless what they hold are propositions.  A shared verdict is
-- not a shared translation.  The undetermined part is where the work is,
-- and it is invisible to any check that only asks whether they agree.
------------------------------------------------------------------------
