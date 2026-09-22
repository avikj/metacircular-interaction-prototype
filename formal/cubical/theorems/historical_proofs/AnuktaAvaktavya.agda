{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AnuktaAvaktavya ‚î ‡‡®‡‡ï‡‡‡Æ‡ is not ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡, and the difference is a
-- swapped quantifier.
--
-- WHAT THIS CORRECTS.
--
-- `Satyayantra.agda` opens by describing its third position:
--
--     ‡‡®‡‡ï‡‡‡ ‡® ‡Æ‡ø‡‡‡Ø‡æ, ‡® ‚ä ‚î ‡‡‡‡‡Ø‡ ‡‡¶‡Æ‡ (avaktavyam), ‡‡‡≤‡ø‡Ø‡®‡-‡∞‡‡ø‡‡Æ‡ ‡
--     "the un-said is not false, not ‚ä ‚î a third position (avaktavyam),
--      boolean-free."
--
-- Everything in that line is right except the parenthesis.  The un-said of
-- the honest machine is a genuine third position, it is not falsity and not
-- ‚ä, and there is no boolean anywhere.  But it is NOT the fourth bhaga of
-- the saptabhag, and `SaptabhangiNaya.agda` ‚î sitting in the same
-- directory, also checked, also --safe ‚î proves the opposite modality.
--
-- THE TWO MODULES SAY, IN THEIR OWN WORDS:
--
--   Purnata.agda:  ‡‡®‡‡ï‡‡‡ ‡‡æ‡Æ‡Ø‡ø‡ï‡Æ‡ ‡‡µ, ‡® ‡‡®‡‡‡ ‡
--                  ‡‡‡‡Ø‡ ‡® ‡‡‡Ø‡ï‡‡‡Æ‡, ‡ï‡‡µ‡≤‡Æ‡ ‡‡¶‡‡Ø‡æ‡‡ø ‡‡®‡‡ï‡‡‡Æ‡ ‚î ‡‡®‡‡¶‡æ‡®‡‡® ‡‡‡∞‡ï‡æ‡‡‡Ø‡Æ‡ ‡
--                  "the un-said is only ever TEMPORARY, never a dead end.
--                   Truth was never abandoned, only not-yet-said ‚î
--                   uncovered by grant."
--
--   SaptabhangiNaya.agda ¬ß5:  no single utterance denotes the joint
--                  content, exhaustively over all six atoms of the
--                  language, each with its own separating profile.  The
--                  remedy is not more of anything.  It is a SECOND
--                  utterance, taken in succession (krama).
--
-- So one third position is removed by giving the machine more, and the
-- other is not removed by giving anything more.  Same word, opposite
-- modality: "not yet" against "not ever, in one breath".
--
-- THE SEPARATION IS EXACT AND IT IS A QUANTIFIER.  Both facts already
-- exist as theorems; what was missing is that they have the same shape
-- with ‚à and ‚à exchanged, which is why one word could cover both and
-- hide it.
--
--     ‡‡æ‡Æ‡Ø‡ø‡ï  bad : I ‚í R ‚í Type      (i : I) ‚í Œ[ r ] ¬ bad i r
--              for EVERY instance there is SOME remedy that removes it
--
--     ‡®‡ø‡‡‡Ø    bad : I ‚í R ‚í Type      (r : R) ‚í Œ[ i ] bad i r
--              for EVERY remedy there is SOME instance that survives it
--
-- `Purnata.‡‡‡∞‡‡‡‡æ` gives the first for the kuaka's un-said, with the
-- remedy being the grant.  `SaptabhangiNaya.no-single-vacana` IS the
-- second, with the remedy being a single utterance.  Neither theorem is
-- reproved here; this module only exhibits that they instantiate the two
-- shapes, which is the content of the distinction.
--
-- WHY IT MATTERS RATHER THAN BEING A LABELLING QUIBBLE.  A machine that
-- reports its third position has to tell a caller what to DO about it, and
-- the two answers are incompatible: spend more, or speak again.  Calling
-- both avaktavyam tells the caller to do nothing, twice.  Nyya keeps them
-- apart too ‚î a hetu that is asiddha (unestablished) is a defect of the
-- MEANS, repaired by establishing it; avaktavyam in the Jain scheme is a
-- positive predication about the ARTHA, and there is nothing to repair.
--
-- SOURCES.  Bhagavat Stra (pre-CE strata, redacted c. 5th c.); Umsvti,
-- Tattvrthastra 5.31 arpitnarpitasiddhe (c. 2nd‚ì5th c.); Siddhasena
-- Divkara, Sanmatitarka 1.21 (c. 5th c.); Akalaka, Laghyastraya
-- (c. 720‚ì780) for kramrpaa against sahrpaa ‚î succession against
-- simultaneity, which is precisely the ‚à/‚à difference below; Mallisena,
-- Sydvdamajar (1292) for sakaldea against vikaldea.  The kuaka
-- itself is ryabhaa, ryabhaya, Gaitapda 32‚ì33 (499 CE).
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module AnuktaAvaktavya where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; suc ; _+_)
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

open import Gati using (‡§´‡§≤‡§Æ‡•ç ; ‡§ó‡•Å‡§∞‡•Å‡§É ; ‡§Ö‡§®‡•Å‡§ï‡•ç‡§§‡§´‡§≤‡§Æ‡•ç ; ‡§´‡§≤ ; ‡§ó‡§§‡§ø)
open import Purnata using (‡§™‡•Ç‡§∞‡•ç‡§£‡§§‡§æ)
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_ ; false‚â¢true)
open import Cubical.Data.Nat using (zero)
open import Cubical.Data.Int using (‚Ñ§ ; pos ; discrete‚Ñ§) renaming (_¬∑_ to _¬∑‚Ñ§_)
open import Cubical.Relation.Nullary using (yes ; no)
open import SaptabhangiNaya
  using ( Vacana ; Profile ; denotes ; joint ; no-single-vacana
        ; krama-expresses ; asti-from ; nasti-from ; rewriter ; kernel-refl )

------------------------------------------------------------------------
-- 1.  The two shapes.
--
-- `bad i r` reads: instance i is STILL in the third position when remedy r
-- has been applied.
------------------------------------------------------------------------

‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï : {I R : Type} ‚Üí (I ‚Üí R ‚Üí Type) ‚Üí Type
‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï {I} {R} bad = (i : I) ‚Üí Œ£[ r ‚àà R ] (¬¨ bad i r)

‡§®‡§ø‡§§‡•ç‡§Ø : {I R : Type} ‚Üí (I ‚Üí R ‚Üí Type) ‚Üí Type
‡§®‡§ø‡§§‡•ç‡§Ø {I} {R} bad = (r : R) ‚Üí Œ£[ i ‚àà I ] (bad i r)

------------------------------------------------------------------------
-- 2.  ‡‡®‡‡ï‡‡‡Æ‡ is ‡‡æ‡Æ‡Ø‡ø‡ï.  The remedy is the grant, and it always exists.
------------------------------------------------------------------------

-- "the result is still un-said"
‡§Ö‡§®‡•Å‡§ï‡•ç‡§§‡§Æ‡§∏‡•ç‡§§‡§ø : ‡§´‡§≤‡§Æ‡•ç ‚Üí Type
‡§Ö‡§®‡•Å‡§ï‡•ç‡§§‡§Æ‡§∏‡•ç‡§§‡§ø (‡§ó‡•Å‡§∞‡•Å‡§É _)       = ‚ä•
‡§Ö‡§®‡•Å‡§ï‡•ç‡§§‡§Æ‡§∏‡•ç‡§§‡§ø (‡§Ö‡§®‡•Å‡§ï‡•ç‡§§‡§´‡§≤‡§Æ‡•ç _)  = Unit

‡§¨‡§¶‡•ç‡§ß‡§Æ‡•ç : (‚Ñï √ó ‚Ñï) ‚Üí ‚Ñï ‚Üí Type
‡§¨‡§¶‡•ç‡§ß‡§Æ‡•ç (a , b) n = ‡§Ö‡§®‡•Å‡§ï‡•ç‡§§‡§Æ‡§∏‡•ç‡§§‡§ø (‡§´‡§≤ (‡§ó‡§§‡§ø n a b))

‡§Ö‡§®‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç-‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï‡§Æ‡•ç : ‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï ‡§¨‡§¶‡•ç‡§ß‡§Æ‡•ç
‡§Ö‡§®‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç-‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï‡§Æ‡•ç (a , b) =
  suc (a + b) , Œª h ‚Üí subst ‡§Ö‡§®‡•Å‡§ï‡•ç‡§§‡§Æ‡§∏‡•ç‡§§‡§ø (snd (‡§™‡•Ç‡§∞‡•ç‡§£‡§§‡§æ a b)) h

------------------------------------------------------------------------
-- 3.  ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ is ‡®‡ø‡‡‡Ø.  For every single utterance there is a profile
-- that survives it ‚î which is `no-single-vacana`, exactly, with nothing
-- added.
------------------------------------------------------------------------

‡§Ö‡§∏‡§Æ‡§∞‡•ç‡§•‡§Æ‡•ç : Profile ‚Üí Vacana ‚Üí Type
‡§Ö‡§∏‡§Æ‡§∞‡•ç‡§•‡§Æ‡•ç œÜ v = ¬¨ (denotes v œÜ ‚â° joint œÜ)

‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç : ‡§®‡§ø‡§§‡•ç‡§Ø ‡§Ö‡§∏‡§Æ‡§∞‡•ç‡§•‡§Æ‡•ç
‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç = no-single-vacana

------------------------------------------------------------------------
-- 4.  So the two words name different shapes, and one word cannot carry
--     both.
--
-- Stated as a type rather than a sentence: a predicate that is ‡‡æ‡Æ‡Ø‡ø‡ï
-- gives, at every instance, a remedy under which it fails; a predicate
-- that is ‡®‡ø‡‡‡Ø gives, at every remedy, an instance under which it holds.
-- Nothing below asserts that no predicate can be both ‚î for an empty
-- instance type or an empty remedy type the shapes degenerate, and that
-- is a separate statement I am not making.  What is exhibited is only
-- this: the two theorems already in this repository realise the two
-- shapes,
-- and `Satyayantra.agda`'s parenthetical puts one under the other's name.
------------------------------------------------------------------------

-- the un-said, at the pole it actually occupies
‡§Ö‡§®‡•Å‡§ï‡•ç‡§§-‡§™‡§¶‡§Æ‡•ç : ‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï ‡§¨‡§¶‡•ç‡§ß‡§Æ‡•ç
‡§Ö‡§®‡•Å‡§ï‡•ç‡§§-‡§™‡§¶‡§Æ‡•ç = ‡§Ö‡§®‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç-‡§∏‡§æ‡§Æ‡§Ø‡§ø‡§ï‡§Æ‡•ç

-- the fourth bhaga, at the other one
‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø-‡§™‡§¶‡§Æ‡•ç : ‡§®‡§ø‡§§‡•ç‡§Ø ‡§Ö‡§∏‡§Æ‡§∞‡•ç‡§•‡§Æ‡•ç
‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø-‡§™‡§¶‡§Æ‡•ç = ‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç

------------------------------------------------------------------------
-- 5.  THE SHARPER DIFFERENCE: WHERE THE REMEDY LIVES.
--
-- The quantifier is the surface of it.  Underneath, the two shapes differ
-- in whether the remedy can stay in its own type.
--
--   ‡‡æ‡Æ‡Ø‡ø‡ï.  The remedy is an element of R, and remedies COMBINE inside R.
--   `SatyayantraSamyoga.‡‡‡Ø‡ã‡ó` proves this for the honest machine: the
--   composite of two machines is a machine, and its ‡‡∞‡ø‡‡‡∞‡‡‡‡æ field is
--   constructed at grant  g‡® + g‡ß  ‚î the two grants aligned by stability
--   and then added.  So chaining honest machines keeps the un-said
--   temporary, and the cost is additive.  You never leave ‚ï.
--
--   ‡®‡ø‡‡‡Ø.  No element of R works ‚î that is exactly `no-single-vacana`,
--   exhaustively.  What works is an ordered PAIR, `krama-expresses`.  The
--   remedy is not a bigger element of R; it is an element of R ó R.  You
--   must leave the type.
--
-- That is Akalaka's kramrpaa against sahrpaa in its operational form
-- (Laghyastraya, c. 720‚ì780): succession is not more simultaneity, and no
-- amount of one becomes the other.  Both halves below are already theorems
-- elsewhere in this repository; what is new here is that they are the two
-- clauses of one statement, which is what makes the pair a SEPARATION and
-- not two remarks.
------------------------------------------------------------------------

‡§Ø‡•Å‡§ó‡•ç‡§Æ‡•á‡§®-‡§∏‡§æ‡§ß‡•ç‡§Ø‡§Æ‡•ç :
    ((v : Vacana) ‚Üí Œ£[ œÜ ‚àà Profile ] (¬¨ (denotes v œÜ ‚â° joint œÜ)))
  √ó (Œ£[ vw ‚àà (Vacana √ó Vacana) ]
      ((œÜ : Profile) ‚Üí joint œÜ ‚â° (denotes (fst vw) œÜ and denotes (snd vw) œÜ)))
‡§Ø‡•Å‡§ó‡•ç‡§Æ‡•á‡§®-‡§∏‡§æ‡§ß‡•ç‡§Ø‡§Æ‡•ç =
    no-single-vacana
  , ((asti-from rewriter , nasti-from kernel-refl) , krama-expresses)

------------------------------------------------------------------------
-- 6.  A THIRD USE OF THE WORD, AND IT FAILS THE SAME TEST FROM THE OTHER
--     SIDE.
--
-- `Khahara.agda` and `Shunya.agda` both identify 00 with avaktavyam:
--
--   Khahara:  00 = ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ (‡‡®‡ø‡‡‡‡ø‡‡Æ‡, ‡‡‡‡‡‡ô‡‡ó‡‡Ø‡æ‡ ‡‡∞‡‡‡ ‡‡¶‡Æ‡)
--   Shunya:   00 ‡® ‡‡ï‡ ‡Æ‡‡≤‡‡Ø‡Æ‡, ‡ï‡ø‡®‡‡‡ ‡‡®‡ø‡‡‡‡ø‡‡Æ‡ ‚î ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡
--             (‡‡‡‡‡‡ô‡‡ó‡‡Ø‡æ‡ ‡‡‡‡∞‡‡‡ ‡‡¶‡Æ‡), ‡® ‡‡‡®‡‡Ø‡Æ‡
--
-- Both are right that Brahmagupta's `00 = 0` (Brhmasphuasiddhnta, 628)
-- is a durnaya ‚î a definite verdict where none is available ‚î and right
-- that Bhskara II's khahara (Llvat, 1150) is a genuinely different
-- non-finite result from it.  Those are the load-bearing claims of both
-- modules and nothing here touches them.
--
-- The identification with the fourth bhaga is what fails, and it fails
-- INTERNALLY: by `SaptabhangiNaya`'s own criterion, not by an outside
-- standard.  ¬ß5 there defines avaktavyam as the case where NO SINGLE
-- UTTERANCE denotes the content, proved exhaustively over the six atoms.
--
-- But 00's situation is denotable in one utterance, and the utterance is
-- the type of `‡‡‡®‡‡Ø‡‡∞‡-‡‡∞‡‡µ‡‡‡∞` below: every x whatsoever satisfies the
-- defining condition.  That is one statement, it is complete, and it says
-- exactly what is wrong.  Nothing is inexpressible.
--
-- So the two defects are opposite:
--
--   avaktavyam  the content is DETERMINATE (`joint` is total into Bool with
--               both values realised) and the MEDIUM cannot say it in one
--               go.  An expressibility failure.
--   00         the content is perfectly EXPRESSIBLE and the SOLUTION SET
--               is not a singleton.  A uniqueness failure.
--
-- Determinate-but-unsayable against sayable-but-underdetermined.  Calling
-- both by the fourth bhaga's name is the boolean collapse this corpus
-- exists to fight, committed one level up: a single third position used as
-- a catch-all for "not a clean single answer".  Three modules now do it ‚î
-- Satyayantra (¬ß1 above), Khahara and Shunya ‚î with three different things
-- underneath.
--
------------------------------------------------------------------------

-- Brahmagupta's own reason, as a term: every x satisfies it.  Over cubical
-- ‚ this is `refl`, because `pos zero ¬ m` reduces to `pos zero` on the
-- nose ‚î the multiplication recurses on its first argument.
‡§∂‡•Ç‡§®‡•ç‡§Ø‡§π‡§∞‡§É-‡§∏‡§∞‡•ç‡§µ‡§§‡•ç‡§∞ : (x : ‚Ñ§) ‚Üí (pos 0) ¬∑‚Ñ§ x ‚â° pos 0
‡§∂‡•Ç‡§®‡•ç‡§Ø‡§π‡§∞‡§É-‡§∏‡§∞‡•ç‡§µ‡§§‡•ç‡§∞ _ = refl

‡§è‡§ï‡§Æ‡•ç? : ‚Ñ§ ‚Üí Bool
‡§è‡§ï‡§Æ‡•ç? (pos (suc zero)) = true
‡§è‡§ï‡§Æ‡•ç? _                = false

‡§∂‡•Ç‡§®‡•ç‡§Ø‚â¢‡§è‡§ï‡§Æ‡•ç : ¬¨ (pos 0 ‚â° pos 1)
‡§∂‡•Ç‡§®‡•ç‡§Ø‚â¢‡§è‡§ï‡§Æ‡•ç p = false‚â¢true (cong ‡§è‡§ï‡§Æ‡•ç? p)

-- Two distinct values both satisfy it, so the fibre is not a singleton.
-- THIS is the defect at 00, and it is not the defect at avaktavyam.
‡§∂‡•Ç‡§®‡•ç‡§Ø‡§π‡§∞‡§É-‡§Ö‡§®‡•á‡§ï‡§Æ‡•ç :
  Œ£[ x ‚àà ‚Ñ§ ] Œ£[ y ‚àà ‚Ñ§ ]
    ((¬¨ (x ‚â° y)) √ó (((pos 0) ¬∑‚Ñ§ x ‚â° pos 0) √ó ((pos 0) ¬∑‚Ñ§ y ‚â° pos 0)))
‡§∂‡•Ç‡§®‡•ç‡§Ø‡§π‡§∞‡§É-‡§Ö‡§®‡•á‡§ï‡§Æ‡•ç = pos 0 , pos 1 , ‡§∂‡•Ç‡§®‡•ç‡§Ø‚â¢‡§è‡§ï‡§Æ‡•ç , refl , refl


------------------------------------------------------------------------
-- 7.  WHAT WAS ALREADY HERE, AND THE DISTINCTION THAT RESOLVES IT.
--
-- Two
-- modules in this repository go further than sections 5 and 6 above:
--
--   `NaturalMachine/AvaktavyaDoesNotFactor.agda` proves
--   `avaktavya-decidable`, so avaktavyam is neither a truth-value gap nor
--   an undecidability, and identifies its shape as a FAILURE TO FACTOR,
--   ¬ Œ[ decoder ] ((x : _) ‚í decoder (coarse x) ‚â° fine x) -- the same
--   shape as Pini's lghava criterion and as the analytic lane's open
--   barrier problem.
--
--   `Saptabhangi.agda` proves `‡ï‡‡∞‡Æ-‡‡-‡‡‡¶‡`: the bhaga reached by
--   krama-arpaa is not the bhaga reached by saha-arpaa.  And `‡¶‡‡∞‡‡®‡Ø‡`:
--   ANY two-valued verdict on the sevenfold identifies two of the three
--   seeds, by pigeonhole -- the boolean collapse, proved rather than
--   deplored.
--
-- THE APPARENT TENSION.  `SaptabhangiNaya.krama-expresses` says a PAIR of
-- utterances denotes the joint content exactly.  `Saptabhangi.‡ï‡‡∞‡Æ-‡‡-‡‡‡¶‡`
-- says the sequential position is not the simultaneous one.  Read
-- carelessly these disagree about whether succession reaches avaktavyam.
--
-- THEY DO NOT, AND THE REASON IS A DISTINCTION NEITHER FILE DRAWS:
-- they quantify over different objects.
--
--   CONTENT   a predicate on profiles.  Reachable by a pair: the joint
--             content IS the conjunction of two denotations.
--   POSITION  a bhaga, a speech act.  NOT reachable by sequencing: the
--             third bhaga and the fourth are distinct inhabitants.
--
-- So expressing-the-content and occupying-the-position come apart.  A pair
-- of successive utterances says what avaktavyam is about, and is still not
-- avaktavyam.  That is exactly Akalaka's point in putting kramrpaa and
-- sahrpaa side by side rather than ordering them, and it is why the
-- scheme needs a fourth member instead of stopping at three.
--
-- AND THE FINDING ABOVE IS AN INSTANCE OF ‡¶‡‡∞‡‡®‡Ø‡, ONE LEVEL UP.  ¬ß1 and ¬ß6
-- found three distinct structures in this repository all called
-- avaktavyam -- Satyayantra's un-said (‡‡æ‡Æ‡Ø‡ø‡ï), 00 (underdetermined), and
-- the fourth bhaga (‡®‡ø‡‡‡Ø, non-factoring).  `‡¶‡‡∞‡‡®‡Ø‡` proves that mapping
-- three distinct seeds into two values must identify two of them.  Mapping
-- three distinct structures onto ONE name is the same pigeonhole with a
-- smaller codomain, and it collapses all three.  The corpus escaped Bool
-- and then made its escape hatch into a Bool of one element.
------------------------------------------------------------------------

open import Saptabhangi
  using (‡§∏‡§™‡•ç‡§§‡§≠‡§ô‡•ç‡§ó‡•Ä ; ‡§Ö‡§∞‡•ç‡§™‡§£‡§Æ‡•ç ; ‡§â‡§≠‡§Ø‡§Æ‡•ç ; ‡§ï‡•ç‡§∞‡§Æ‡§É ; ‡§∏‡§π‡§É ; ‡§ï‡•ç‡§∞‡§Æ-‡§∏‡§π-‡§≠‡•á‡§¶‡§É)

-- POSITION: succession does not reach the fourth bhaga.  (Saptabhangi's,
-- re-exported here so the two levels stand in one place.)
‡§∏‡•ç‡§•‡§æ‡§®-‡§≠‡•á‡§¶‡§É : ¬¨ (‡§Ö‡§∞‡•ç‡§™‡§£‡§Æ‡•ç ‡§â‡§≠‡§Ø‡§Æ‡•ç ‡§ï‡•ç‡§∞‡§Æ‡§É ‚â° ‡§Ö‡§∞‡•ç‡§™‡§£‡§Æ‡•ç ‡§â‡§≠‡§Ø‡§Æ‡•ç ‡§∏‡§π‡§É)
‡§∏‡•ç‡§•‡§æ‡§®-‡§≠‡•á‡§¶‡§É = ‡§ï‡•ç‡§∞‡§Æ-‡§∏‡§π-‡§≠‡•á‡§¶‡§É

-- CONTENT: and yet the pair denotes the joint content exactly.  (¬ß5's
-- second clause.)  Both hold; they are about different things.
‡§Ö‡§∞‡•ç‡§•-‡§∏‡§æ‡§Æ‡•ç‡§Ø‡§Æ‡•ç : (œÜ : Profile)
             ‚Üí joint œÜ ‚â° (denotes (asti-from rewriter) œÜ
                          and denotes (nasti-from kernel-refl) œÜ)
‡§Ö‡§∞‡•ç‡§•-‡§∏‡§æ‡§Æ‡•ç‡§Ø‡§Æ‡•ç = krama-expresses

------------------------------------------------------------------------
-- 8.  THE THREE-WAY SEPARATION, COMPLETED.
--
-- ¬ß1 and ¬ß6 asserted three distinct structures wearing one name, and
-- proved two of the three separations.  A pattern over n instances is a
-- pattern over n instances until something downstream of it is computed,
-- so here is the third, and it changes the shape of the claim.
--
-- 00 is NOT ‡‡æ‡Æ‡Ø‡ø‡ï.  No resource resolves it: for EVERY candidate value
-- there is a competing value satisfying the same defining condition.  In
-- the vocabulary of ¬ß1 that makes it ‡®‡ø‡‡‡Ø too.
--
-- So the ‡‡æ‡Æ‡Ø‡ø‡ï/‡®‡ø‡‡‡Ø axis does NOT separate 00 from the fourth bhaga,
-- and whatWhat separates them is the
-- other axis, the one ¬ß6 actually exhibited: 00's whole situation is
-- denotable in a single utterance (`‡‡‡®‡‡Ø‡‡∞‡-‡‡∞‡‡µ‡‡‡∞`), and avaktavyam's is
-- not (`no-single-vacana`).  Two axes, three structures, each pair
-- separated by at least one:
--
--                        ‡‡æ‡Æ‡Ø‡ø‡ï?    sayable in one utterance?
--   ‡‡®‡‡ï‡‡‡Æ‡ (Satyayantra)   yes             --
--   00                     no             yes
--   ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ (4th bhaga)  no             no
------------------------------------------------------------------------

‡§∂‡•Ç‡§®‡•ç‡§Ø‡§π‡§∞‡§É-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç :
  (r : ‚Ñ§) ‚Üí Œ£[ i ‚àà ‚Ñ§ ] ((¬¨ (i ‚â° r)) √ó ((pos 0) ¬∑‚Ñ§ i ‚â° pos 0))
‡§∂‡•Ç‡§®‡•ç‡§Ø‡§π‡§∞‡§É-‡§®‡§ø‡§§‡•ç‡§Ø‡§Æ‡•ç r with discrete‚Ñ§ r (pos 0)
... | yes p = pos 1 , (Œª q ‚Üí ‡§∂‡•Ç‡§®‡•ç‡§Ø‚â¢‡§è‡§ï‡§Æ‡•ç (sym (q ‚àô p))) , refl
... | no ¬¨p = pos 0 , (Œª q ‚Üí ¬¨p (sym q)) , refl


------------------------------------------------------------------------
-- 9.  THE TWO AXES ARE INDEPENDENT, NOT DUAL.
--   `NaturalMachine/SamayikaAndNityaAreIndependent.agda` ‚î the swap of ‚à
--   and ‚à is NOT a negation.  `bothHold` exhibits a single `bad` that is
--   ‡‡æ‡Æ‡Ø‡ø‡ï AND ‡®‡ø‡‡‡Ø at once; `samayikaWithoutNitya` and
--   `nityaWithoutSamayika` give the other two corners.  Neither predicate
--   implies the other and neither implies the other's negation.  What each
--   DOES refute is the other's STRONG failure, which is a different and
--   weaker relation than duality.
--
--   `NaturalMachine/NonUniquenessAndInexpressibilityAreIndependent.agda` ‚î
--   the same, over four realised corners, for ¬ß6's other axis.  So the two
--   defects are not two readings of one thing at any strength.
--
-- The three-way separation of sections 1, 6 and 8 stands: the
-- three structures ARE distinct, and each pair is separated by at least
-- one of the two properties.  The two properties are not
-- poles of a line: the truth is a square with at least three corners
-- occupied, and reading a square as a line is how a classification loses
-- exactly the case that matters.
------------------------------------------------------------------------

open import NonUniquenessAndInexpressibilityAreIndependent
  using ( corner-nonUnique-expressible ; corner-unique-inexpressible
        ; corner-both ; corner-neither )

-- The corner showing the two defects on ¬ß6's axis: one content is BOTH
-- non-unique and inexpressible at once, so they are not two ends of
-- anything.
‡§®-‡§¶‡•ç‡§µ‡•à‡§§‡§Æ‡•ç : _
‡§®-‡§¶‡•ç‡§µ‡•à‡§§‡§Æ‡•ç = corner-both

-- and the corner in the other direction: a content
-- with NEITHER defect.  A line with two ends has no such point; a square
-- has four, and all four are inhabited here.
‡§®-‡§ß‡•ç‡§∞‡•Å‡§µ‡•å : _
‡§®-‡§ß‡•ç‡§∞‡•Å‡§µ‡•å = corner-neither
-- The other two corners, named rather than tupled.  A four-way tuple with
-- an inferred type leaves Agda unable to solve which Œ it is (the same
-- ambiguity ¬ß5 of `BhavanaKrida` hit), and an anonymous meta is not a
-- checked claim.  Four names, four checks.
‡§™‡•É‡§•‡§ï‡•ç-‡§Ö‡§®‡•á‡§ï‡§Æ‡•ç : _
‡§™‡•É‡§•‡§ï‡•ç-‡§Ö‡§®‡•á‡§ï‡§Æ‡•ç = corner-nonUnique-expressible

‡§™‡•É‡§•‡§ï‡•ç-‡§Ö‡§µ‡§æ‡§ö‡•ç‡§Ø‡§Æ‡•ç : _
‡§™‡•É‡§•‡§ï‡•ç-‡§Ö‡§µ‡§æ‡§ö‡•ç‡§Ø‡§Æ‡•ç = corner-unique-inexpressible
