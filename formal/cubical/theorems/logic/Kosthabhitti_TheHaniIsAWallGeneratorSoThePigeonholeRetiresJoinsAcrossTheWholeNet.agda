{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡ï‡ã‡‡‡†-‡‡ø‡‡‡‡ø‡ ‚î ‡‡æ‡®‡ø‡ ‡‡µ ‡‡ø‡‡‡‡ø-‡‡®‡ï‡ ‡
--
-- (the pigeonhole wall: ‡‡æ‡®‡ø‡ is the wall generator, so one counting
--  argument retires joins across the whole net.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE THREE PIECES THIS JOINS, AND WHY THE JOIN IS THE POINT.
--
-- `Kosthanyaya_‚¶agda` separated two things the corpus had been running
-- together: the PIGEONHOLE is unconditional ‚î three points, a two-valued
-- readout, two images agree ‚î and the LOSS is a separate hypothesis,
-- needing the three points pairwise distinct.  `‡‡æ‡®‡ø‡` there returns the
-- merged pair TOGETHER WITH its distinctness, which at the time looked
-- like bookkeeping.
--
-- `Bhitti_‚¶agda`, `BhittiDvaya_‚¶`, `BhittiSaptabhangi_‚¶` (another seat)
-- land WALLS ‚î proved non-identifications, `¬ (A ‚â B)` ‚î each retiring a
-- candidate join forever.
--
-- `BhittiSanorder_‚¶agda` (same seat) proves walls TRANSPORT:
--     ‡‡ø‡‡‡‡ø-‡‡‡ï‡‡∞‡Æ‡ : (A ‚â B) ‚í ¬ (B ‚â C) ‚í ¬ (A ‚â C)
-- so a wall crosses every ford by itself, and "the candidate list shrinks
-- quadratically in what is landed, not linearly in what is proved."
--
-- ¬ß‡® is the missing joint: **the distinctness half of ‡‡æ‡®‡ø‡ is exactly
-- what a wall needs, and supplying it makes the wall.**  A two-valued
-- codomain and three pairwise-distinct points in the source are enough,
-- with no arithmetic, no cardinality, and nothing about the particular
-- types.  So the wall family is a theorem rather than a collection, and
-- every future instance is an application.
--
-- WHY IT WORKS, in one sentence: an equivalence is injective, the
-- pigeonhole says a two-valued readout is not, and distinctness is what
-- turns "two images agree" into "not injective".  That is precisely the
-- hypothesis `Kosthanyaya` peeled off, and this is what it was for.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHY A WALL TRANSPORTS AND A DEFECT DOES NOT ‚î recorded because it is
-- the structural reason behind the neighbour's result and neither file
-- states it.
--
-- A DEFECT is a property of a MAP: `Œ[ b ] ¬ isContr (fiber f b)`.  It
-- needs a site, and `TritiyaMarga_‚¶` proves that getting the site from
-- the refutation costs at least Markov's Principle.
--
-- A WALL is a property of a PAIR OF TYPES: `¬ (A ‚â C)`.  Transport moves
-- statements about types.  So walls cross fords and defects do not, and
-- that is the term/type distinction rather than a happy accident.
--
-- It also settles an over-reading available from
-- `Samyoge_‚¶agda`'s title: "refutation does not compose" is true of
-- sequential composition of MAPS and false of transport across the
-- identification graph.  Two compositions, two answers.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- ‡ï‡ã‡‡‡†-‡®‡‡Ø‡æ‡Ø is used as the ordinary name for the pigeonhole and no text
-- is claimed for it; ‡‡ø‡‡‡‡ø (wall) is the neighbouring seat's term, used
-- in their sense.  ‡¶‡‡∞‡‡®‡Ø is the Jaina term ‚î a naya asserting itself by
-- denying the others (Siddhasena Divkara, ‡‡®‡‡Æ‡‡ø‡‡∞‡‡ï; Akalaka's line) ‚î
-- and what is taken from it is the SHAPE, a readout too narrow to hold
-- the distinctions being forced to deny one, not a theorem of any Jaina
-- logician.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Kosthabhitti_TheHaniIsAWallGeneratorSoThePigeonholeRetiresJoinsAcrossTheWholeNet where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; equivFun ; invEq ; retEq)
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; znots ; snotz ; injSuc)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Relation.Nullary using (¬¨_)

open import Kosthanyaya_TheDurnayaIsThePigeonholeAndTheLossIsTheSeparateHypothesis
  using (‡§¶‡•ç‡§µ‡§ø-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç ; ‡§π‡§æ‡§®‡§ø‡§É)

private
  variable
    ‚Ñì ‚Ñì' : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡Æ‡‡æ-‡‡ï‡à‡ï‡‡‡µ‡Æ‡ ‚î an equivalence is injective.  One line, and it is
--     the only thing about equivalences this file uses.
------------------------------------------------------------------------

‡§∏‡§Æ‡§§‡§æ-‡§è‡§ï‡•à‡§ï‡§§‡•ç‡§µ‡§Æ‡•ç : {X D : Type ‚Ñì} (e : X ‚âÉ D) (p q : X)
               ‚Üí equivFun e p ‚â° equivFun e q ‚Üí p ‚â° q
‡§∏‡§Æ‡§§‡§æ-‡§è‡§ï‡•à‡§ï‡§§‡•ç‡§µ‡§Æ‡•ç e p q h =
  sym (retEq e p) ‚àô cong (invEq e) h ‚àô retEq e q

------------------------------------------------------------------------
-- ‡® ¬ ‡ï‡ã‡‡‡†-‡‡ø‡‡‡‡ø‡ ‚î THE WALL GENERATOR.
--
--     Three pairwise-distinct points in the source, a two-valued
--     codomain, and there is no identification between them.  No
--     cardinality, no arithmetic, nothing about which types these are.
------------------------------------------------------------------------

‡§ï‡•ã‡§∑‡•ç‡§†-‡§≠‡§ø‡§§‡•ç‡§§‡§ø‡§É : {X : Type ‚Ñì} {D : Type ‚Ñì} {d‚ÇÄ d‚ÇÅ : D}
              ‚Üí ‡§¶‡•ç‡§µ‡§ø-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç D d‚ÇÄ d‚ÇÅ
              ‚Üí (x y z : X) ‚Üí ¬¨ (x ‚â° y) ‚Üí ¬¨ (x ‚â° z) ‚Üí ¬¨ (y ‚â° z)
              ‚Üí ¬¨ (X ‚âÉ D)
‡§ï‡•ã‡§∑‡•ç‡§†-‡§≠‡§ø‡§§‡•ç‡§§‡§ø‡§É two x y z x‚â¢y x‚â¢z y‚â¢z e =
  let (p , q , p‚â¢q , eq) = ‡§π‡§æ‡§®‡§ø‡§É two (equivFun e) x y z x‚â¢y x‚â¢z y‚â¢z
  in p‚â¢q (‡§∏‡§Æ‡§§‡§æ-‡§è‡§ï‡•à‡§ï‡§§‡•ç‡§µ‡§Æ‡•ç e p q eq)

------------------------------------------------------------------------
-- ‡© ¬ The instance the neighbouring lane landed by hand, obtained.
--
--     `Bhitti_TheNaturalsAndTheBooleansAreAProvedWall‚¶` proves ¬ (‚ï ‚â Bool).
--     Here it is three numerals and ¬ß‡®, with `Bool`'s two-valuedness the
--     only fact about `Bool` used.  Their module is NOT superseded ‚î it
--     is the named wall the economy cites, and it may well prove it by a
--     route that generalises differently.  What ¬ß‡© shows is that the
--     statement is an instance of a counting argument and needs nothing
--     about ‚ï beyond three distinct numerals.
------------------------------------------------------------------------

Bool-‡§¶‡•ç‡§µ‡§ø-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç : ‡§¶‡•ç‡§µ‡§ø-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç Bool true false
Bool-‡§¶‡•ç‡§µ‡§ø-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç true  = inl refl
  where open import Cubical.Data.Sum using (inl)
Bool-‡§¶‡•ç‡§µ‡§ø-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç false = inr refl
  where open import Cubical.Data.Sum using (inr)

‡•¶‚â¢‡•ß : ¬¨ (0 ‚â° 1)
‡•¶‚â¢‡•ß = znots

‡•¶‚â¢‡•® : ¬¨ (0 ‚â° 2)
‡•¶‚â¢‡•® = znots

‡•ß‚â¢‡•® : ¬¨ (1 ‚â° 2)
‡•ß‚â¢‡•® p = znots (injSuc p)

‚Ñï-‡§≠‡§ø‡§§‡•ç‡§§‡§ø‡§É-Bool : ¬¨ (‚Ñï ‚âÉ Bool)
‚Ñï-‡§≠‡§ø‡§§‡•ç‡§§‡§ø‡§É-Bool = ‡§ï‡•ã‡§∑‡•ç‡§†-‡§≠‡§ø‡§§‡•ç‡§§‡§ø‡§É Bool-‡§¶‡•ç‡§µ‡§ø-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç 0 1 2 ‡•¶‚â¢‡•ß ‡•¶‚â¢‡•® ‡•ß‚â¢‡•®
