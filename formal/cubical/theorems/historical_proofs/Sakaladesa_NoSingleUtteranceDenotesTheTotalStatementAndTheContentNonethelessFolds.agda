{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡ï‡≤‡æ‡¶‡‡‡ ‚î ‡‡ï‡‡® ‡µ‡‡®‡‡® ‡® ‡â‡‡‡Ø‡‡, ‡‡∞‡‡‡‡‡‡ ‡‡ô‡‡ï‡≤‡ø‡‡ ‡
--
-- (the total statement: no single utterance denotes it ‚î and yet its
--  content folds.)
--
-- TEXT AND DATE.  ‡‡ï‡≤‡æ‡¶‡‡ / ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ ‚î the total statement against the
-- partial one ‚î is the pair Malliea uses in the ‡‡‡Ø‡æ‡¶‡‡µ‡æ‡¶‡Æ‡û‡‡‡∞‡, 1292 CE,
-- glossing Hemacandra; it is older in the Akalaka commentarial line
-- (Vidynandi, ‡‡‡‡ü‡‡‡‡‡∞‡, c. 9th c.).  ‡‡ï‡≤‡æ‡¶‡‡ is the utterance made
-- from ‡‡‡∞‡Æ‡æ‡, grasping the whole at once; ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ is made from a ‡®‡Ø, one
-- aspect at a time.  The mode distinction it rests on ‚î ‡ï‡‡∞‡Æ‡æ‡∞‡‡‡ against
-- ‡‡‡æ‡∞‡‡‡, in succession against simultaneously ‚î is AKALAKA's,
-- ‡≤‡ò‡‡Ø‡‡‡‡‡∞‡Ø‡Æ‡ / ‡‡‡‡ü‡‡‡, c. 720‚ì780 CE.  ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ as the fourth position
-- is canonical: ‡‡ó‡µ‡‡-‡‡‡‡‡∞ (‡µ‡‡Ø‡æ‡ñ‡‡Ø‡æ‡‡‡∞‡‡‡û‡‡‡‡ø), oldest strata pre-Common-Era,
-- redacted at Valabh c. 5th c. CE; fixed at seven with ‡‡‡Ø‡æ‡‡ prefixed
-- throughout by Samantabhadra, ‡‡‡‡‡Æ‡‡Æ‡æ‡‡‡æ, c. 6th c. CE.
--
-- WHY THIS MODULE EXISTS, AND WHAT IT CORRECTS.
--
-- `SaptabhangiNaya` fixes THREE standpoints and SIX utterances, and proves
-- `no-single-vacana` by listing all six.  `AvaktavyaDoesNotFactor`
-- turns that list into the shape it really has:
--
--     ¬ Œ[ v ] (‚à œ ‚í denotes v œ ‚â° joint œ)
--
-- ‚î a factorisation obstruction.  Both are at n = 3 standpoints and a joint
-- content of TWO conjuncts, and both proceed by exhausting the utterances.
--
-- ¬ß3 below proves it for an ARBITRARY standpoint type and an ARBITRARY
-- finite demand, with no case analysis over utterances, no decidable
-- equality on standpoints, and no finiteness: two constant profiles do the
-- whole job.  So the obstruction is not an artefact of three standpoints.
--
-- AND IT WITHDRAWS A CLAIM MADE IN CONVERSATION, WHICH IS THE MORE USEFUL
-- HALF.  It was put to the owner that ‡‡‡æ‡∞‡‡‡ is "irreducibly n-ary" ‚î that
-- the total statement over n standpoints cannot be built from binary steps ‚î
-- on the ground that `Arpitanarpita_‚¶.‡‡-‡‡‡ô‡‡ó‡‡ø‡-‡ä‡∞‡‡ß‡‡µ‡Æ‡` proves ‡‡‡æ‡∞‡‡‡‡Æ‡
-- non-associative.  That inference conflates two different objects:
--
--   ¬ the CONTENT demanded by the total statement, which is a conjunction
--     over the demand.  ¬ß2: it FOLDS.  `and` is associative, so the n-ary
--     content is exactly the iterated binary one, and `‡ï‡‡∞‡Æ-‡‡ô‡‡ï‡≤‡®‡Æ‡` holds
--     by `refl`.  The claim was wrong here.
--   ¬ the OPERATION combining seven-fold POSITIONS, `‡‡-‡Ø‡ã‡ó` / `‡‡‡æ‡∞‡‡‡‡Æ‡`,
--     which `SaptabhangiSamyoga_‚¶.‡‡-‡‡‡ô‡‡ó‡‡ø‡` and `Arpitanarpita_‚¶.‡‡-
--     ‡‡‡ô‡‡ó‡‡ø‡-‡ä‡∞‡‡ß‡‡µ‡Æ‡` prove non-associative on labels and on records
--     alike.  There the n-ary operation genuinely is not determined by the
--     binary one.  The claim was right here, about a different thing.
--
-- Content folds; the composition of positions does not.  Reading the second
-- as licensing the first is exactly the collapse this corpus exists to
-- refuse ‚î ‡‡‡‡®‡ ‡‡ï‡®‡æ‡Æ‡‡®‡æ ‡ó‡‡‡‡‡æ‡‡ø ‚î so it is written out rather than
-- quietly dropped (‡‡‡ø‡‡‡æ-‡‡‡‡‡∞-‡µ‡ø‡‡‡‡æ‡∞‡ ¬ß‡: ‡≤‡ø‡ñ‡ø‡‡ã ‡¶‡ã‡‡ã ‡‡‡µ‡‡ø).
--
-- WHAT IS PROVED.  --cubical --safe, no postulates, no holes.
--
--   ‡ï‡‡∞‡Æ-‡‡ô‡‡ï‡≤‡®‡Æ‡      succession expresses the demand, by construction.
--   ‡‡∞‡‡µ-‡‡‡‡Ø‡-‡Æ‡ø‡‡‡Ø‡æ   a demand with any negative entry is false at the
--                     all-affirming profile.
--   ‡‡∞‡‡µ-‡Æ‡ø‡‡‡Ø‡æ-‡Æ‡ø‡‡‡Ø‡æ  a demand with any positive entry is false at the
--                     all-denying profile.
--   ‡‡ï-‡µ‡‡®‡‡®-‡®        NO SINGLE UTTERANCE denotes a mixed demand ‚î any
--                     standpoint type, any length.  Two profiles, no
--                     exhaustion, no decidability.
--   ‡‡ï‡≤‡æ‡¶‡‡‡ã-‡®-‡‡ô‡‡ó‡‡‡‡‡  the same as a factorisation obstruction.
--   ‡∞‡ø‡ï‡‡‡-‡‡®‡‡‡‡‡æ‡≤‡Æ‡    and as the statement that the fibre of `denotes`
--                     over the demanded content is EMPTY.
--
-- THE LAST ONE IS THE POINT, and it is what places ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ on the scale
-- this corpus has been assembling.  A map's fibre being CONTRACTIBLE is
-- `Loss.Carrier`: nothing lost, the datum rides free.  A fibre with
-- MORE than one point is ‡®‡‡‡ü‡ø: the "which" is destroyed (¬ß‡), priced when
-- the fibre is finite and decidable, ‡‡‡‡∞‡‡ø‡ï‡æ‡∞‡‡Ø when truncated.  A fibre
-- that is EMPTY is neither: nothing was lost, because nothing was ever
-- there to lose ‚î the content simply is not in the image of single
-- utterance.  That is ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡, and it is why the tradition insists it is
-- not "unknown" and not "neither true nor false".  It is a statement about
-- what one vacana can denote.
--
------------------------------------------------------------------------

module Sakaladesa_NoSingleUtteranceDenotesTheTotalStatementAndTheContentNonethelessFolds where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; _and_ ; _or_ ; true‚â¢false ; false‚â¢true)
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Sigma using (Œ£ ; Œ£-syntax ; _√ó_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty as Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

private
  variable
    ‚Ñì : Level

module _ {S : Type ‚Ñì} where

  ----------------------------------------------------------------------
  -- ‡ß ¬ ‡µ‡‡®‡Æ‡ ‚î the vocabulary, with no finiteness anywhere.
  --
  -- A ‡‡‡∞‡ã‡‡æ‡‡≤ records, for each standpoint, whether the property is
  -- present there.  A ‡µ‡‡® ‚î a single utterance ‚î names ONE standpoint and
  -- ONE polarity, and denotes what that standpoint says.  This is
  -- `SaptabhangiNaya`'s `asti-from` / `nasti-from`, with the three fixed
  -- standpoints replaced by an arbitrary type.
  ----------------------------------------------------------------------

  Profile : Type ‚Ñì
  Profile = S ‚Üí Bool

  Vacana : Type ‚Ñì
  Vacana = S √ó Bool

  denotes : Vacana ‚Üí Profile ‚Üí Bool
  denotes (s , true)  œÜ = œÜ s
  denotes (s , false) œÜ = not (œÜ s)

  -- ‡‡∞‡‡µ‡æ‡‡‡‡ø / ‡‡∞‡‡µ‡®‡æ‡‡‡‡ø ‚î the two profiles that do all the work in ¬ß3.
  ‡§∏‡§∞‡•ç‡§µ‡§æ‡§∏‡•ç‡§§‡§ø ‡§∏‡§∞‡•ç‡§µ‡§®‡§æ‡§∏‡•ç‡§§‡§ø : Profile
  ‡§∏‡§∞‡•ç‡§µ‡§æ‡§∏‡•ç‡§§‡§ø  _ = true
  ‡§∏‡§∞‡•ç‡§µ‡§®‡§æ‡§∏‡•ç‡§§‡§ø _ = false

  ----------------------------------------------------------------------
  -- ‡® ¬ ‡‡¶‡‡‡ ‚î the demand, and its content.
  --
  -- What a ‡‡ï‡≤‡æ‡¶‡‡ asks for: a finite list of standpoint-with-polarity,
  -- all of them at once.  Its content is their conjunction.
  --
  -- ‡ï‡‡∞‡Æ-‡‡ô‡‡ï‡≤‡®‡Æ‡ ‚î SUCCESSION EXPRESSES IT, BY CONSTRUCTION, and the whole
  -- interest of ¬ß3 is that this is the easy direction.  `SaptabhangiNaya.
  -- krama-expresses` is this at one fixed two-element demand.
  --
  -- NOTE WHAT THIS SETTLES.  The content is a fold of the binary
  -- conjunction, so at the level of CONTENT the n-ary total statement is
  -- the iterated binary one.  The header records the claim this refutes.
  ----------------------------------------------------------------------

  Adesa : Type ‚Ñì
  Adesa = List Vacana

  joint : Adesa ‚Üí Profile ‚Üí Bool
  joint []      _ = true
  joint (v ‚à∑ d) œÜ = denotes v œÜ and joint d œÜ

  ‡§ï‡•ç‡§∞‡§Æ-‡§∏‡§ô‡•ç‡§ï‡§≤‡§®‡§Æ‡•ç : (v : Vacana) (d : Adesa) (œÜ : Profile)
                ‚Üí joint (v ‚à∑ d) œÜ ‚â° (denotes v œÜ and joint d œÜ)
  ‡§ï‡•ç‡§∞‡§Æ-‡§∏‡§ô‡•ç‡§ï‡§≤‡§®‡§Æ‡•ç _ _ _ = refl

  ----------------------------------------------------------------------
  -- ‡© ¬ ‡‡ï-‡µ‡‡®‡‡® ‡® ‚î NO SINGLE UTTERANCE.
  --
  -- The demand is MIXED when it asks for at least one presence and at
  -- least one absence.  That is the whole hypothesis: no finiteness of S,
  -- no decidable equality on S, no exhaustion of utterances.
  ----------------------------------------------------------------------

  ‡§Ö‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç ‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç : Adesa ‚Üí Bool
  ‡§Ö‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç []            = false
  ‡§Ö‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç ((_ , p) ‚à∑ d) = p or ‡§Ö‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç d
  ‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç []            = false
  ‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç ((_ , p) ‚à∑ d) = not p or ‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç d

  -- At the all-affirming profile every negative entry reads false, so one
  -- negative entry is enough to falsify the whole demand.
  ‡§∏‡§∞‡•ç‡§µ-‡§∏‡§§‡•ç‡§Ø‡•á-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ : (d : Adesa) ‚Üí ‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç d ‚â° true
                    ‚Üí joint d ‡§∏‡§∞‡•ç‡§µ‡§æ‡§∏‡•ç‡§§‡§ø ‚â° false
  ‡§∏‡§∞‡•ç‡§µ-‡§∏‡§§‡•ç‡§Ø‡•á-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ []                h = Empty.rec (false‚â¢true h)
  ‡§∏‡§∞‡•ç‡§µ-‡§∏‡§§‡•ç‡§Ø‡•á-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ ((_ , false) ‚à∑ _) _ = refl
  ‡§∏‡§∞‡•ç‡§µ-‡§∏‡§§‡•ç‡§Ø‡•á-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ ((_ , true)  ‚à∑ d) h = ‡§∏‡§∞‡•ç‡§µ-‡§∏‡§§‡•ç‡§Ø‡•á-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ d h

  -- ‚¶and dually.
  ‡§∏‡§∞‡•ç‡§µ-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ : (d : Adesa) ‚Üí ‡§Ö‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç d ‚â° true
                     ‚Üí joint d ‡§∏‡§∞‡•ç‡§µ‡§®‡§æ‡§∏‡•ç‡§§‡§ø ‚â° false
  ‡§∏‡§∞‡•ç‡§µ-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ []               h = Empty.rec (false‚â¢true h)
  ‡§∏‡§∞‡•ç‡§µ-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ ((_ , true) ‚à∑ _) _ = refl
  ‡§∏‡§∞‡•ç‡§µ-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ ((_ , false) ‚à∑ d) h = ‡§∏‡§∞‡•ç‡§µ-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ d h

  -- THE THEOREM.  Whatever the single utterance is, one of the two
  -- constant profiles separates it from the demanded content ‚î because a
  -- single utterance always reads TRUE at the constant profile matching
  -- its own polarity, while a mixed demand reads FALSE at both.
  ‡§è‡§ï-‡§µ‡§ö‡§®‡•á‡§®-‡§® : (d : Adesa)
              ‚Üí ‡§Ö‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç d ‚â° true ‚Üí ‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç d ‚â° true
              ‚Üí (v : Vacana) ‚Üí Œ£[ œÜ ‚àà Profile ] (¬¨ (denotes v œÜ ‚â° joint d œÜ))
  ‡§è‡§ï-‡§µ‡§ö‡§®‡•á‡§®-‡§® d ha hn (s , true) =
    ‡§∏‡§∞‡•ç‡§µ‡§æ‡§∏‡•ç‡§§‡§ø , Œª e ‚Üí true‚â¢false (e ‚àô ‡§∏‡§∞‡•ç‡§µ-‡§∏‡§§‡•ç‡§Ø‡•á-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ d hn)
  ‡§è‡§ï-‡§µ‡§ö‡§®‡•á‡§®-‡§® d ha hn (s , false) =
    ‡§∏‡§∞‡•ç‡§µ‡§®‡§æ‡§∏‡•ç‡§§‡§ø , Œª e ‚Üí true‚â¢false (e ‚àô ‡§∏‡§∞‡•ç‡§µ-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ-‡§Æ‡§ø‡§•‡•ç‡§Ø‡§æ d ha)

  ----------------------------------------------------------------------
  -- ‡ ¬ ‡‡ï‡≤‡æ‡¶‡‡‡ã ‡® ‡‡ô‡‡ó‡‡‡‡‡ ‚î the same, as a factorisation obstruction.
  --
  -- The shape `AvaktavyaDoesNotFactor` names, here at
  -- arbitrary S and arbitrary demand length.
  ----------------------------------------------------------------------

  EkenaVacanena : Adesa ‚Üí Type ‚Ñì
  EkenaVacanena d = Œ£[ v ‚àà Vacana ] ((œÜ : Profile) ‚Üí denotes v œÜ ‚â° joint d œÜ)

  ‡§∏‡§ï‡§≤‡§æ‡§¶‡•á‡§∂‡•ã-‡§®-‡§∏‡§ô‡•ç‡§ó‡§ö‡•ç‡§õ‡§§‡•á : (d : Adesa)
                       ‚Üí ‡§Ö‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç d ‚â° true ‚Üí ‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç d ‚â° true
                       ‚Üí ¬¨ EkenaVacanena d
  ‡§∏‡§ï‡§≤‡§æ‡§¶‡•á‡§∂‡•ã-‡§®-‡§∏‡§ô‡•ç‡§ó‡§ö‡•ç‡§õ‡§§‡•á d ha hn (v , agrees) =
    ‡§è‡§ï-‡§µ‡§ö‡§®‡•á‡§®-‡§® d ha hn v .snd (agrees (‡§è‡§ï-‡§µ‡§ö‡§®‡•á‡§®-‡§® d ha hn v .fst))

  ----------------------------------------------------------------------
  -- ‡ ¬ ‡∞‡ø‡ï‡‡‡ ‡‡®‡‡‡‡‡æ‡≤‡Æ‡ ‚î AND AS A STATEMENT ABOUT A FIBRE.
  --
  -- `denotes` sends an utterance to the content it denotes.  ¬ß4 says the
  -- demanded content is NOT IN ITS IMAGE, i.e. the fibre over it is empty.
  --
  -- Placed against the rest of the scale:
  --
  --   fibre contractible   nothing lost.  `Loss.Carrier`; the datum
  --                        is determined and rides free.
  --   fibre with >1 point  ‡®‡‡‡ü‡ø: the "which" is destroyed (¬ß‡).  Priced
  --                        when finite and decidable ‚î the ‡ï‡‡ü‡‡ü‡ï's side is
  --                        exactly one bit, and a comparison per step is
  --                        what recovers it.  ‡‡‡‡∞‡‡ø‡ï‡æ‡∞‡‡Ø when truncated.
  --   fibre EMPTY          ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡.  Nothing was lost; nothing was ever
  --                        there.  The content is not sayable by one
  --                        utterance at all.
  --
  -- The three are different failures and the middle one is the only one
  -- that is a LOSS.  Calling the third a loss ‚î "information destroyed by
  -- the fourth position" ‚î is a reading this module removes.
  ----------------------------------------------------------------------

  Tantu : Adesa ‚Üí Type ‚Ñì
  Tantu d = Œ£[ v ‚àà Vacana ] ((œÜ : Profile) ‚Üí denotes v œÜ ‚â° joint d œÜ)

  ‡§∞‡§ø‡§ï‡•ç‡§§‡§Ç-‡§§‡§®‡•ç‡§§‡•Å‡§ú‡§æ‡§≤‡§Æ‡•ç : (d : Adesa)
                    ‚Üí ‡§Ö‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç d ‚â° true ‚Üí ‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç d ‚â° true
                    ‚Üí ¬¨ Tantu d
  ‡§∞‡§ø‡§ï‡•ç‡§§‡§Ç-‡§§‡§®‡•ç‡§§‡•Å‡§ú‡§æ‡§≤‡§Æ‡•ç = ‡§∏‡§ï‡§≤‡§æ‡§¶‡•á‡§∂‡•ã-‡§®-‡§∏‡§ô‡•ç‡§ó‡§ö‡•ç‡§õ‡§§‡•á

------------------------------------------------------------------------
-- ‡ ¬ ‡¶‡‡µ‡ø-‡®‡Ø‡Æ‡ ‚î the smallest instance, so nothing above is vacuous.
--
-- Two standpoints, a demand asking presence at one and absence at the
-- other: precisely `SaptabhangiNaya.joint`, and precisely the
-- configuration the third bhaga (‡‡‡Ø‡æ‡¶‡‡‡‡ø ‡ ‡®‡æ‡‡‡‡ø ‡) is about.  It is
-- expressible in succession and by ¬ß4 it is not expressible by one vacana.
------------------------------------------------------------------------

data ‡§¶‡•ç‡§µ‡§ø : Type‚ÇÄ where
  ‡§™‡•ç‡§∞‡§•‡§Æ‡§É ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø‡§É : ‡§¶‡•ç‡§µ‡§ø

‡§Ü‡§¶‡•á‡§∂‡§É-‡§¶‡•ç‡§µ‡§ø : Adesa {S = ‡§¶‡•ç‡§µ‡§ø}
‡§Ü‡§¶‡•á‡§∂‡§É-‡§¶‡•ç‡§µ‡§ø = (‡§™‡•ç‡§∞‡§•‡§Æ‡§É , true) ‚à∑ (‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø‡§É , false) ‚à∑ []

‡§Æ‡§ø‡§∂‡•ç‡§∞‡§É-‡§Ö‡§∏‡•ç‡§§‡§ø : ‡§Ö‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç ‡§Ü‡§¶‡•á‡§∂‡§É-‡§¶‡•ç‡§µ‡§ø ‚â° true
‡§Æ‡§ø‡§∂‡•ç‡§∞‡§É-‡§Ö‡§∏‡•ç‡§§‡§ø = refl

‡§Æ‡§ø‡§∂‡•ç‡§∞‡§É-‡§®‡§æ‡§∏‡•ç‡§§‡§ø : ‡§®‡§æ‡§∏‡•ç‡§§‡§ø-‡§ï‡§∂‡•ç‡§ö‡§ø‡§§‡•ç ‡§Ü‡§¶‡•á‡§∂‡§É-‡§¶‡•ç‡§µ‡§ø ‚â° true
‡§Æ‡§ø‡§∂‡•ç‡§∞‡§É-‡§®‡§æ‡§∏‡•ç‡§§‡§ø = refl

-- realised: there is a profile at which the demand is met, so the content
-- is not empty of instances ‚î it is a genuine two-valued predicate and not
-- a truth-value gap.  (`SaptabhangiNaya.joint-realised`, restated here so
-- ¬ß6 does not depend on that module.)
‡§Ü‡§¶‡•á‡§∂‡§É-‡§∏‡§ø‡§¶‡•ç‡§ß‡§É : Œ£[ œÜ ‚àà Profile {S = ‡§¶‡•ç‡§µ‡§ø} ] (joint ‡§Ü‡§¶‡•á‡§∂‡§É-‡§¶‡•ç‡§µ‡§ø œÜ ‚â° true)
‡§Ü‡§¶‡•á‡§∂‡§É-‡§∏‡§ø‡§¶‡•ç‡§ß‡§É = œÜ , refl
  where
  œÜ : Profile {S = ‡§¶‡•ç‡§µ‡§ø}
  œÜ ‡§™‡•ç‡§∞‡§•‡§Æ‡§É  = true
  œÜ ‡§¶‡•ç‡§µ‡§ø‡§§‡•Ä‡§Ø‡§É = false

-- and yet no single utterance denotes it.
‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç-‡§¶‡•ç‡§µ‡§ø : ¬¨ EkenaVacanena ‡§Ü‡§¶‡•á‡§∂‡§É-‡§¶‡•ç‡§µ‡§ø
‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç-‡§¶‡•ç‡§µ‡§ø = ‡§∏‡§ï‡§≤‡§æ‡§¶‡•á‡§∂‡•ã-‡§®-‡§∏‡§ô‡•ç‡§ó‡§ö‡•ç‡§õ‡§§‡•á ‡§Ü‡§¶‡•á‡§∂‡§É-‡§¶‡•ç‡§µ‡§ø ‡§Æ‡§ø‡§∂‡•ç‡§∞‡§É-‡§Ö‡§∏‡•ç‡§§‡§ø ‡§Æ‡§ø‡§∂‡•ç‡§∞‡§É-‡§®‡§æ‡§∏‡•ç‡§§‡§ø

------------------------------------------------------------------------
-- ‡ ¬ What this does NOT license.
--
-- It does not say the total statement is impossible ‚î ‡ï‡‡∞‡Æ-‡‡ô‡‡ï‡≤‡®‡Æ‡ says
-- succession expresses it exactly, and ¬ß6 exhibits a profile meeting the
-- demand.  It says one vacana does not denote it.  That distinction is the
-- entire content of ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ in the sources and it is easy to lose in
-- translation: the position is about EXPRESSION, not about truth, not
-- about knowledge, and not about a third truth value.
--
-- Nor does it bear on which of the seven positions a given object
-- occupies, on the exhaustiveness of the seven, or on whether the record
-- lane and the label lane of `Arpitanarpita_‚¶` can be reconciled.  Those
-- are three separate open questions and none of them is touched here.
------------------------------------------------------------------------
