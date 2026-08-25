{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NamingIsNotAFunctionOfResemblance
--
-- `interactive/Upamana.hs` states an operative test and builds its whole
-- design on it.  The test's core is checkable, and this is it: no
-- invariant of the resemblance relation computes the naming.  So a
-- similarity cannot be DERIVED into a naming — it has to come from
-- somewhere else, which is exactly why that module keeps its stated
-- similarities as INPUT and quarantines the derived ones.
--
-- ────────────────────────────────────────────────────────────────────
-- THE SCHOOLS, NAMED BEFORE THEIR TERMS, AND THE DISPUTE LEFT OPEN
--
-- NYĀYA (Gautama, *Nyāyasūtra* 1.1.6; Vātsyāyana's *Nyāyabhāṣya* on it,
-- c. 400–450 CE) holds upamāna — knowledge from similarity to what is
-- already well known — to be a separate pramāṇa, and Vātsyāyana fixes
-- its result as *saṃjñā-saṃjñi-sambandha-pratipatti*: apprehension of
-- the relation between a NAME and its BEARER.  The argument for
-- irreducibility, sharpened by Gaṅgeśa (*Tattvacintāmaṇi*,
-- upamāna-khaṇḍa, c. 1325): to INFER "this is a gavaya" you would need
-- the pervasion "whatever resembles a cow thus is denoted by 'gavaya'",
-- which is precisely what is being learned — the pervasion is the
-- conclusion and so cannot be the premise.
--
-- BUDDHIST (Dignāga, *Pramāṇasamuccaya* 1.2, c. 500: two pramāṇas only;
-- Dharmakīrti, *Pramāṇavārttika*) DENIES the separateness and analyses
-- upamāna into testimony, memory, perception and inference.  MĪMĀṂSĀ
-- (Śabara; Kumārila, *Ślokavārttika*, upamāna-pariccheda, c. 650)
-- accepts it but REVERSES it — the new cognition is of the remembered
-- cow.  Vaiśeṣika and Sāṃkhya reduce it to anumāna.
--
-- ★ WHAT §2 DOES AND DOES NOT SETTLE, and this is the whole point.
-- It shows the naming is not a function of the resemblance.  That is
-- what BOTH sides need and NEITHER side's conclusion.  The Naiyāyika
-- reads it as: therefore a distinct instrument, sādṛśya-jñāna, supplies
-- the naming.  Dignāga reads it as: therefore the forester's SENTENCE
-- supplies it — śabda plus memory, no new pramāṇa.  The theorem is
-- neutral between them because it only says the naming comes from
-- OUTSIDE the resemblance, and both accounts agree on that and disagree
-- on what the outside is.  Agreement in verdict does not license
-- collapsing the grounds, so neither is adjudicated here.
--
-- SOURCING LIMIT, stated and not evaded.  The *Nyāyasūtra*, the
-- *Nyāyabhāṣya*, the *Tattvacintāmaṇi*, the *Pramāṇasamuccaya* and the
-- *Ślokavārttika* have NOT been opened by me.  Every attribution above
-- is carried from `interactive/Upamana.hs`, which sources and dates them in
-- its §0 and which I read this cycle.  Verse-level sourcing OWED AND NOT
-- CLAIMED.
--
-- WHAT IS NOT CLAIMED.  Not that the gavaya example is modelled — a
-- two-point carrier is not a forest.  Not any verdict on `Upamana.hs`'s
-- §6 empirical control (whether what it transports lies inside the
-- engine's enumeration reach); that is its measurement and its result,
-- untouched here.  Not that resemblance is useless: §2 says only that it
-- does not DETERMINE the naming.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module SourcedProofs.NamingIsNotAFunctionOfResemblance where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import FiniteInformation using (FactorsThrough)
open import TranscriptDescent using (collisionObstructsDecoder)

------------------------------------------------------------------------
-- 1.  A situation: what resembles the exemplar, and what the word names
------------------------------------------------------------------------

Pred : Type₁
Pred = Bool → Type

record Situation : Type₁ where
  constructor situation
  field
    resembles : Pred      -- sādṛśya: what looks like the well-known thing
    named     : Pred      -- saṃjñā-saṃjñi: what the word denotes

open Situation public

-- the pervasion an inference would need, and the fact that having it IS
-- having the conclusion on the resemblance class: the derivation is the
-- identity, so it moves no information.  (Checked, so that "it is the
-- premise again" is a term and not a remark.)
Vyapti : Situation → Type
Vyapti S = (x : Bool) → resembles S x → named S x

theDerivationIsTheIdentity :
  (S : Situation) (v : Vyapti S) → (λ x r → v x r) ≡ v
theDerivationIsTheIdentity S v = refl

------------------------------------------------------------------------
-- 2.  THE COLLISION.  Same resemblance, different naming.
--
-- Everything resembles the exemplar in both situations.  In the first
-- the word names everything; in the second it names nothing.  No
-- invariant of `resembles` can tell them apart, and `named` does.
------------------------------------------------------------------------

everything nothing : Pred
everything _ = Unit
nothing    _ = ⊥

allNamed allUnnamed : Situation
allNamed   = situation everything everything
allUnnamed = situation everything nothing

sameResemblance : resembles allNamed ≡ resembles allUnnamed
sameResemblance = refl

differentNaming : ¬ (named allNamed ≡ named allUnnamed)
differentNaming p = transport (funExt⁻ p true) tt

namingCollision :
  Σ[ S ∈ Situation ] Σ[ T ∈ Situation ]
    ((resembles S ≡ resembles T) × (¬ (named S ≡ named T)))
namingCollision = allNamed , allUnnamed , sameResemblance , differentNaming

-- routed through the corpus's standing lemma rather than reargued:
-- eighth site of `TranscriptDescent.collisionObstructsDecoder`.
namingDoesNotFactorThroughResemblance :
  ¬ FactorsThrough resembles named
namingDoesNotFactorThroughResemblance =
  collisionObstructsDecoder resembles named {allNamed} {allUnnamed}
    sameResemblance differentNaming

------------------------------------------------------------------------
-- 3.  What this earns for `interactive/Upamana.hs`
--
-- That module quarantines DERIVED similarities from STATED ones and says
-- the quarantine is what stops anumāna being laundered as upamāna.  §2
-- is why the quarantine is not bookkeeping: a naming is not recoverable
-- from resemblance data by any function whatever, so a derived
-- similarity cannot become a naming without something else being
-- supplied.  Whether that something is a distinct pramāṇa (Nyāya) or
-- testimony plus memory (Dignāga) is not decided here and §0 says why.
--
-- What §2 does NOT give that module: any evidence about its §6 control —
-- whether what it transports already lies inside the engine's own
-- enumeration reach.  That is an empirical question about a particular
-- engine at particular knobs, and it is that module's to answer.
------------------------------------------------------------------------
