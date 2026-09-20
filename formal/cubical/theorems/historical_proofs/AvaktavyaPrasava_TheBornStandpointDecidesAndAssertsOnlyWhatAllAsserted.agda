{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AvaktavyaPrasava_TheBornStandpointDecidesAndAsserts-
-- OnlyWhatAllAsserted
--
-- The two laws of the birth in
-- `machine/AvaktavyaPrasava_TheFourthPositionBearsTheRuleThatDecidesIt.hs`,
-- as theorems rather than as sites checked one at a time.
--
-- WHAT THE HASKELL DOES.  The scheduler
-- (`machine/Vipratisedha_ConflictIsDecidedByMetaruleNotByListPosition.hs`)
-- reaches the fourth position, ‡‡µ‡ï‡‡‡µ‡‡Ø, when several rules contend for one
-- item and no metarule ranks them.  Its `Avaktavya` now carries the residue
-- -- the contending offers, entire -- and from that residue a new standpoint
-- is born: the ‡‡®‡µ‡ï‡æ‡ rule whose whole scope IS the contested item,
-- declared an apavda to every contender.
--
-- The two things that have to be true of that birth, and they pull in
-- opposite directions:
--
--   1. IT DECIDES.  Adjoining the child makes the apavda selection unique,
--      and the unique winner is the child.  ¬ß1 below, and note that it
--      needs NO hypothesis whatever on the contenders' own apavda
--      relation: whatever mess is underneath, the child settles it.
--
--   2. IT TAKES NOTHING.  The child asserts exactly what every contender
--      already asserted, and where the contenders differ NOTHING IS BORN.
--      ¬ß2 below.  This is the half that keeps the birth from being a
--      tie-breaker: a tie-breaker chooses one contender, and this chooses
--      none -- it can only speak where they already spoke with one voice.
--
-- WITHOUT (2), (1) IS DURNAYA.  Siddhasena Divkara, *Sanmatitarka* 1.21
-- (c. 5th c. CE): a naya that asserts itself by denying the others is a
-- durnaya, and a durnaya is worse than a falsehood, since a falsehood can
-- be contradicted and a concealed standpoint cannot.  `bheda-na-janayati`
-- is the formal statement that the machine cannot commit that: given two
-- contenders whose results differ, the birth is provably `nothing`.
--
-- WHAT THIS DOES NOT TOUCH.  `Saptabhangi.no-single-vacana` and
-- `AnuktaAvaktavya` prove the fourth position is not reachable by krama
-- from the three: it must be SUPPLIED.  Nothing here derives it.  The birth
-- CONSUMES a fourth position -- in the Haskell, `prasava` takes a `Sesa`,
-- and a `Sesa` exists only where `nirnaya` already returned `Avaktavya`.
--
-- SOURCES, EARLIEST FIRST.
--   Ktyyana, vrttika 1 on Pini's *Adhyy* 1.4.2, preserved in
--     Patajali's *Mahbhya*, c. 150 BCE: ‡¶‡‡µ‡ ‡‡‡∞‡‡ô‡‡ó‡æ‡µ‡®‡‡Ø‡æ‡∞‡‡‡æ‡µ‡‡ï‡‡‡Æ‡ø‡®‡
--     ‡ ‡µ‡ø‡‡‡∞‡‡ø‡‡‡ß‡ -- two rules, each having its scope ELSEWHERE, meeting
--     on ONE item: that is vipratiedha.  That is the configuration ¬ß1 is
--     about, named by the Pinya grammarians and not by anyone since.
--   Umsvti, *Tattvrthastra* 5.31, c. 2nd-5th c. CE:
--     ‡‡∞‡‡‡ø‡‡æ‡®‡∞‡‡‡ø‡‡‡ø‡¶‡‡ß‡‡ -- the asserted and the unasserted aspect.  The
--     contenders speak about this item unasserted, in passing; the child
--     speaks about it asserted, and about nothing else.
--   Siddhasena Divkara, *Sanmatitarka* 1.21, c. 5th c. CE -- durnaya.
--   Akalaka, *Laghyastraya*, c. 720-780 CE -- kramrpaa / sahrpaa,
--     the distinction that makes the fourth position a position at all.
--   Ngea Bhaa, *Paribhenduekhara*, c. 1730, paribh 38 -- the
--     strength order prva < para < nitya < antaraga < apavda, which is
--     why the child winning BY APAVDA is the strongest verdict available
--     and not a courtesy.
--
-- WHAT THE CHECKER SAYS BACK, recorded here rather than left in a terminal.
-- `agda --cubical --safe --no-import-sorts` on this file: EXIT 0, no
-- postulates, no holes, and FOUR `-WUnsupportedIndexedMatch` warnings, on
-- `na-vipakse`, `garbha-jayati`, and the two `with`-generated functions of
-- ¬ß2.  Each is the same fact: the clause matches on a proof of `_‚àà_`, whose
-- index forces injectivity of `_‚à_`, which Cubical Agda does not yet
-- support.  The consequence is precise and worth stating rather than
-- glossing: these functions do not COMPUTE when applied to a transport.
-- They are still theorems, and nothing below depends on reducing them under
-- transport -- but a later module that wants to transport one of these
-- along a path of lists will find it stuck, and should know that now.
------------------------------------------------------------------------

module AvaktavyaPrasava_TheBornStandpointDecidesAndAssertsOnlyWhatAllAsserted where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool; true; false; true‚â¢false; false‚â¢true)
open import Cubical.Data.Empty as ‚ä• using (‚ä•)
open import Cubical.Data.List using (List; []; _‚à∑_)
open import Cubical.Data.Maybe using (Maybe; just; nothing; just-inj; ¬¨nothing‚â°just)
open import Cubical.Data.Sigma using (_√ó_; _,_)
open import Cubical.Data.Sum using (_‚äé_; inl; inr)
open import Cubical.Relation.Nullary using (¬¨_; Discrete; yes; no)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- 0.  MEMBERSHIP
--
-- "y is one of the standpoints in play".  Written out rather than imported
-- so that the two theorems below depend on nothing but this file and the
-- library's Bool, Maybe and Discrete.
------------------------------------------------------------------------

data _‚àà_ {A : Type ‚Ñì} (x : A) : List A ‚Üí Type ‚Ñì where
  here  : {xs : List A} ‚Üí x ‚àà (x ‚à∑ xs)
  there : {y : A} {xs : List A} ‚Üí x ‚àà xs ‚Üí x ‚àà (y ‚à∑ xs)

------------------------------------------------------------------------
-- 1.  THE BIRTH DECIDES
--
-- `Praja` -- what is in play once the child exists.  `just a` is a
-- contender; `nothing` is the born standpoint, and it is a separate
-- constructor because it is a separate kind of thing: its scope is the one
-- contested item and every contender's scope is elsewhere (anyrtha).
--
-- `apa*` extends the domain's own apavda relation to it, and the two new
-- lines are the whole content of ‡‡®‡µ‡ï‡æ‡:
--
--     apa* nothing (just _) = true    the child excepts every contender
--     apa* (just _) nothing = false   no contender excepts the child
--
-- The second is not a convention.  A contender's scope properly contains
-- the item, so it is the general rule here and cannot be the exception to
-- the rule whose scope is that item alone.
------------------------------------------------------------------------

module _ {A : Type ‚Ñì} (apa : A ‚Üí A ‚Üí Bool) where

  Praja : Type ‚Ñì
  Praja = Maybe A

  apa* : Praja ‚Üí Praja ‚Üí Bool
  apa* nothing  (just _) = true
  apa* (just _) nothing  = false
  apa* (just x) (just y) = apa x y
  apa* nothing  nothing  = false

  -- The scheduler's apavda selection, verbatim: w wins iff every other
  -- standpoint in play is one w excepts.  (`nirnaya`'s `apavadas`.)
  Jayati : List Praja ‚Üí Praja ‚Üí Type ‚Ñì
  Jayati xs w = (y : Praja) ‚Üí y ‚àà xs ‚Üí (y ‚â° w) ‚äé (apa* w y ‚â° true)

  -- the contenders, as standpoints in play
  vipaksah : List A ‚Üí List Praja
  vipaksah []       = []
  vipaksah (x ‚à∑ xs) = just x ‚à∑ vipaksah xs

  garbhaSabha : List A ‚Üí List Praja
  garbhaSabha xs = nothing ‚à∑ vipaksah xs

  -- the child is not one of the contenders, and this is what makes the
  -- selection below come out unique
  na-vipakse : (xs : List A) ‚Üí ¬¨ (nothing ‚àà vipaksah xs)
  na-vipakse (_ ‚à∑ xs) (there p) = na-vipakse xs p

  -- 1a.  THE CHILD WINS.  No hypothesis on `apa`.
  garbha-jayati : (xs : List A) ‚Üí Jayati (garbhaSabha xs) nothing
  garbha-jayati _  nothing  here      = inl refl
  garbha-jayati xs nothing  (there p) = ‚ä•.rec (na-vipakse xs p)
  garbha-jayati _  (just _) (there _) = inr refl

  -- 1b.  AND NOBODY ELSE DOES.  A contender fails on the child alone: it
  -- is not the child, and it does not except the child.  So the winner of
  -- the extended selection is unique, and it is the one that was born.
  eka-eva-jayati : (xs : List A) (a : A) ‚Üí ¬¨ (Jayati (garbhaSabha xs) (just a))
  eka-eva-jayati _ _ f with f nothing here
  ... | inl p = ¬¨nothing‚â°just p
  ... | inr q = false‚â¢true q

------------------------------------------------------------------------
-- 2.  THE BIRTH TAKES NOTHING
--
-- What the child asserts is `eka`: the one result, if every contender gave
-- the same one, and NOTHING otherwise.  (In the Haskell the "same one" is
-- reached either outright or by joining over the whole reachable set, which
-- prefers no path; here it is the first case, which is the one carrying the
-- law.)
------------------------------------------------------------------------

module _ {R : Type ‚Ñì} (dec : Discrete R) where

  decB : R ‚Üí R ‚Üí Bool
  decB a b with dec a b
  ... | yes _ = true
  ... | no  _ = false

  decB-satyam : (a b : R) ‚Üí decB a b ‚â° true ‚Üí a ‚â° b
  decB-satyam a b p with dec a b
  ... | yes q = q
  ... | no  _ = ‚ä•.rec (false‚â¢true p)

  -- every element of the list is v
  samana : R ‚Üí List R ‚Üí Bool
  samana _ []       = true
  samana v (w ‚à∑ ws) with decB w v
  ... | true  = samana v ws
  ... | false = false

  samana-satyam : (v : R) (ws : List R) ‚Üí samana v ws ‚â° true
                ‚Üí (w : R) ‚Üí w ‚àà ws ‚Üí w ‚â° v
  samana-satyam v (u ‚à∑ us) p w q with dec u v
  samana-satyam v (u ‚à∑ us) p w here      | yes r = r
  samana-satyam v (u ‚à∑ us) p w (there s) | yes _ = samana-satyam v us p w s
  samana-satyam v (u ‚à∑ us) p w _         | no  _ = ‚ä•.rec (false‚â¢true p)

  ekaAux : R ‚Üí Bool ‚Üí Maybe R
  ekaAux u true  = just u
  ekaAux u false = nothing

  ekaAux-satyam : (u : R) (b : Bool) (v : R) ‚Üí ekaAux u b ‚â° just v
                ‚Üí (b ‚â° true) √ó (u ‚â° v)
  ekaAux-satyam u true  v p = refl , just-inj u v p
  ekaAux-satyam u false v p = ‚ä•.rec (¬¨nothing‚â°just p)

  -- THE BIRTH'S TARGET.  `nothing` = no rule is born.
  eka : List R ‚Üí Maybe R
  eka []       = nothing
  eka (u ‚à∑ us) = ekaAux u (samana u us)

  -- 2a.  WHAT IS BORN ASSERTS ONLY WHAT EVERY CONTENDER ASSERTED.  This is
  -- the transport law: the site's answer after the birth is the answer it
  -- already had, so no derivation anywhere changes.  (`--avaktavya-prasava`
  -- re-verifies the same statement exhaustively over every term of depth
  -- <= 3 in the engine's own rule set; this is the reason it comes out 0.)
  eka-vadati : (vs : List R) (v : R) ‚Üí eka vs ‚â° just v
             ‚Üí (w : R) ‚Üí w ‚àà vs ‚Üí w ‚â° v
  eka-vadati (u ‚à∑ us) v p w q with ekaAux-satyam u (samana u us) v p
  eka-vadati (u ‚à∑ us) v p w here      | (_ , uv) = uv
  eka-vadati (u ‚à∑ us) v p w (there s) | (su , uv) =
    samana-satyam u us su w s ‚àô uv

  -- 2b.  WHERE THE CONTENDERS DIFFER, NOTHING IS BORN.  The machine cannot
  -- rank one standpoint over another with no fact to do it by -- which is
  -- exactly the durnaya of Sanmatitarka 1.21, here made unavailable rather
  -- than discouraged.
  ekaAux-sunyam : (u : R) (b : Bool)
                ‚Üí ((v : R) ‚Üí ekaAux u b ‚â° just v ‚Üí ‚ä•) ‚Üí ekaAux u b ‚â° nothing
  ekaAux-sunyam u true  f = ‚ä•.rec (f u refl)
  ekaAux-sunyam _ false _ = refl

  bheda-na-janayati : (vs : List R) (w w' : R)
                    ‚Üí w ‚àà vs ‚Üí w' ‚àà vs ‚Üí ¬¨ (w ‚â° w')
                    ‚Üí eka vs ‚â° nothing
  bheda-na-janayati [] _ _ ()
  bheda-na-janayati (u ‚à∑ us) w w' p p' d =
    ekaAux-sunyam u (samana u us)
      (Œª v q ‚Üí d (eka-vadati (u ‚à∑ us) v q w p
                  ‚àô sym (eka-vadati (u ‚à∑ us) v q w' p')))

------------------------------------------------------------------------
-- 3.  WHAT THE TWO SECTIONS SAY TOGETHER
--
-- ¬ß1 says the fourth position always bears a standpoint that decides it.
-- ¬ß2 says that standpoint can say nothing the contenders had not already
-- said, and says nothing at all when they disagree.  Neither is worth
-- much alone: ¬ß1 alone is a tie-breaker in , and ¬ß2 alone is the
-- machine stopping.  Together they are the stra's claim, which is not
-- that the fourth position is a gap and not that it is a verdict --
--
--     ‡‡µ‡ï‡‡‡µ‡‡Ø‡ ‡‡‡‡ã ‡µ‡‡‡ø ‡ ‡‡‡‡ã ‡ó‡∞‡‡‡, ‡® ‡µ‡ø‡‡≤‡‡æ ‡
--     ‡ó‡∞‡‡‡æ‡¶‡ ‡‡ó‡‡∞‡ø‡Æ‡ã ‡®‡Ø‡ã ‡‡æ‡Ø‡‡ ‡
--
-- -- in the avaktavya the residue dwells; the residue is a womb, not a
-- failure; from the womb the next naya is born.
------------------------------------------------------------------------
