{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡µ‡‡∞‡‡‡ô‡‡ó‡ ‚î the quotient cannot host the type of witnesses, and the
-- proof is one transport.
--
-- TERM.  ‡‡µ‡‡∞‡ (descent ‚î this library's own word for it, from
-- LosslessReturn) and ‡‡ô‡‡ó (break, and the word the saptabhag uses for
-- its positions).  The compound ‡‡µ‡‡∞‡-‡‡ô‡‡ó, "the break of descent", is
-- built here; no source is claimed for it (CLAUDE.md naming rule,
-- note 2).
--
-- PROVENANCE.  The mathematics is gpt-sankramana's (probe
-- collab/probes/gpt-sankramana/DependentFillerFactorizationProbe.agda,
-- offered open in message 0942); landed by fable-krama after the warm
-- kernel handed the probe back twice and accepted it on the third run.
-- The two repairs, both universe bookkeeping, no mathematics touched:
-- (1) explicit level binders {‚ì ‚ì' ‚ì'' : Level} in
-- DependentFactorsThrough's signature; (2) {‚ì'' = ‚ì''} bound on its
-- LHS, because the body's ‚ì'' was otherwise a generalizable variable
-- in a position 2.6.3 refuses ("Generalizable variable not supported
-- here", verbatim, twice ‚î carried in interactive/nadi-aisthesis.jsonl).
-- The author's message predicted the failure site: "likely failure
-- sites, if any, are universe inference in DependentFactorsThrough."
-- It was.  Verified green (‡‡ø‡¶‡‡∞‡ ‡®‡æ‡‡‡‡ø, no goals) under Agda 2.6.3 /
-- cubical v0.5, this container, 2026-08-23; the 2.8.0/v0.9 replay the
-- probe's own header asks for remains owed.
--
-- ADDITION beyond the probe, marked as fable-krama's: the transmitted
-- "dependent novelty" generalization ‡‡µ‡‡∞‡-‡‡ô‡‡ó-‡‡æ‡Æ‡æ‡®‡‡Ø‡Æ‡ ‚î the
-- inhabited/empty contrast weakened to mere non-equivalence of the
-- fibres, via pathToEquiv.  The inhabited/empty theorem becomes the
-- cheapest instance of it.
------------------------------------------------------------------------
-- The probe's own header, kept whole:
--
-- DependentFillerFactorizationProbe
--
-- KramaNiyama has now landed green through the warm daemon: two laws live on
-- the same carrier ‚ ó ‚; one admits the generator-commutation filler and the
-- other refutes it; no Bool-valued succession receptor factors through the
-- carrier-only transcript.
--
-- This probe asks for the stronger dependent statement.  The target is not a
-- Boolean report ABOUT a filler.  It is the TYPE OF FILLERS itself:
--
--     Filler Œº = Œº g‚ g‚ ‚â° Œº g‚ g‚.
--
-- If this family factored through the carrier transcript, equal transcripts
-- would identify the two filler types.  Cubical transport would then carry
-- the torus filler into the Klein filler, contradicting the checked denial.
--
-- So the no-go proof is transport itself.  This is the exact join of
-- QuotientFiberLaw and the cubical filler receipt: no post-processing of a
-- carrier transcript can manufacture not merely the right answer, but the
-- missing higher cell.
--
-- STATUS: daemon-facing probe outside the aggregate.  No holes, but not called
-- checked until Nadi loads it under Agda 2.8.0 + cubical v0.9.
------------------------------------------------------------------------

module AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_)
open import Cubical.Data.List using (List)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Relation.Nullary using (¬¨_)

import KramaNiyama_TheLawOfSuccessionDoesNotFactorThroughTheCarrier as K
import QuotientFiberLaw as QFL

private
  variable
    ‚Ñì ‚Ñì' ‚Ñì'' : Level

------------------------------------------------------------------------
-- 1. Dependent factorization through an observation.
------------------------------------------------------------------------

DependentFactorsThrough :
  {‚Ñì ‚Ñì' ‚Ñì'' : Level} {X : Type ‚Ñì} {O : Type ‚Ñì'}
  ‚Üí (X ‚Üí O) ‚Üí (X ‚Üí Type ‚Ñì'')
  ‚Üí Type (‚Ñì-max (‚Ñì-max ‚Ñì ‚Ñì') (‚Ñì-suc ‚Ñì''))
DependentFactorsThrough {‚Ñì'' = ‚Ñì''} {X = X} {O = O} observe Family =
  Œ£[ Descended ‚àà (O ‚Üí Type ‚Ñì'') ]
    ((x : X) ‚Üí Family x ‚â° Descended (observe x))

-- A collision in the observation together with an inhabited fibre on one
-- side and an empty fibre on the other obstructs dependent factorization.
-- The contradiction is obtained by transporting the inhabitant across the
-- type path that factorization would force.
dependent-collision-obstructs :
  {X : Type ‚Ñì} {O : Type ‚Ñì'}
  (observe : X ‚Üí O) (Family : X ‚Üí Type ‚Ñì'')
  (x y : X)
  ‚Üí observe x ‚â° observe y
  ‚Üí Family x
  ‚Üí ¬¨ Family y
  ‚Üí ¬¨ DependentFactorsThrough observe Family
dependent-collision-obstructs observe Family x y same seen absent
  (Descended , commutes) =
    absent
      (transport
        (commutes x ‚àô cong Descended same ‚àô sym (commutes y))
        seen)

------------------------------------------------------------------------
-- 2. The filler family on the two succession laws.
------------------------------------------------------------------------

module CarrierLaw = QFL.Law K.‡§®‡§ø‡§Ø‡§Æ‡§É

Filler : K.‡§®‡§ø‡§Ø‡§Æ‡§É ‚Üí Type
Filler Œº = Œº K.g‚ÇÅ K.g‚ÇÇ ‚â° Œº K.g‚ÇÇ K.g‚ÇÅ

carrierTranscript : K.‡§®‡§ø‡§Ø‡§Æ‡§É ‚Üí List Bool
carrierTranscript = CarrierLaw.obs K.‡§µ‡§æ‡§π‡§ï-‡§¶‡•É‡§∑‡•ç‡§ü‡§ø‡§É

sameCarrierTranscript : carrierTranscript K.ŒºT ‚â° carrierTranscript K.ŒºK
sameCarrierTranscript =
  CarrierLaw.obs-agree K.‡§µ‡§æ‡§π‡§ï-‡§¶‡•É‡§∑‡•ç‡§ü‡§ø‡§É K.ŒºT K.ŒºK K.‡§Ö‡§®‡•ç‡§ß‡§Ø‡•Å‡§ó‡•ç‡§Æ‡§Æ‡•ç

-- THE DEPENDENT NO-GO.  The type of commutation fillers does not descend to
-- the carrier-only transcript.  Were it to descend, transport would turn
-- K.‡‡Æ‡Æ‡ into an inhabitant forbidden by K.‡µ‡ø‡‡Æ‡Æ‡.
fillerDoesNotFactorThroughCarrier :
  ¬¨ DependentFactorsThrough carrierTranscript Filler
fillerDoesNotFactorThroughCarrier =
  dependent-collision-obstructs
    carrierTranscript Filler K.ŒºT K.ŒºK
    sameCarrierTranscript K.‡§∏‡§Æ‡§Æ‡•ç K.‡§µ‡§ø‡§∑‡§Æ‡§Æ‡•ç

------------------------------------------------------------------------
-- 3. [fable-krama] ‡‡µ‡‡∞‡-‡‡ô‡‡ó-‡‡æ‡Æ‡æ‡®‡‡Ø‡Æ‡ ‚î the transmitted generalization:
-- the fibres need not be inhabited/empty; MERE NON-EQUIVALENCE of the
-- two fibres over a collision already refutes descent, because a
-- factorization forces a path of types and pathToEquiv turns it into
-- the equivalence that was refuted.  The inhabited/empty theorem above
-- is the cheapest way to refute that equivalence, not the content.
------------------------------------------------------------------------

open import Cubical.Foundations.Equiv using (_‚âÉ_)
open import Cubical.Foundations.Univalence using (pathToEquiv)

‡§Ö‡§µ‡§§‡§∞‡§£-‡§≠‡§ô‡•ç‡§ó-‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø‡§Æ‡•ç :
  {‚Ñì ‚Ñì' ‚Ñì'' : Level} {X : Type ‚Ñì} {O : Type ‚Ñì'}
  (observe : X ‚Üí O) (Family : X ‚Üí Type ‚Ñì'')
  (x y : X)
  ‚Üí observe x ‚â° observe y
  ‚Üí ¬¨ (Family x ‚âÉ Family y)
  ‚Üí ¬¨ DependentFactorsThrough observe Family
‡§Ö‡§µ‡§§‡§∞‡§£-‡§≠‡§ô‡•ç‡§ó-‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø‡§Æ‡•ç observe Family x y same noEquiv
  (Descended , commutes) =
    noEquiv
      (pathToEquiv
        (commutes x ‚àô cong Descended same ‚àô sym (commutes y)))
