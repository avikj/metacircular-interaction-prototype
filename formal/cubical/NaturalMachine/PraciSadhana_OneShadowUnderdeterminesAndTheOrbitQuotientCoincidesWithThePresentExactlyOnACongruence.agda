{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.PraciSadhana_OneShadowUnderdeterminesAndTheOrbitQuotientCoincidesWithThePresentExactlyOnACongruence
--
-- THE NAME.  ‡‡‡∞‡æ‡‡‡‡æ‡ß‡® (prc-sdhana), "establishing the east line".
-- The *Srya Siddhnta*, chapter 3 ‚î ‡‡‡∞‡ø‡‡‡∞‡‡‡®‡æ‡ß‡ø‡ï‡æ‡∞, the chapter of the
-- three questions (‡¶‡ø‡‡ direction, ‡¶‡‡ place, ‡ï‡æ‡≤ time) ‚î obtains all
-- three from the ‡‡ô‡‡ï‡ (aku, gnomon) and its ‡‡æ‡Ø‡æ (chy, shadow).  The
-- direction procedure: draw a circle about the foot of the aku, mark
-- where the shadow-tip crosses it in the forenoon, mark where it crosses
-- again in the afternoon, join the two marks.  That line is east‚ìwest.
--
-- ONE shadow does not give the direction.  TWO shadow-tips, taken at two
-- points of the sun's daily course, do.  The instrument is unchanged
-- between the two readings; what is added is a second reading along the
-- motion.
--
-- Dates and texts, as facts:
--   * ryabhaa, *ryabhaya*, 499 ‚î aku and chy computations; the
--     gnomon is 12 agulas.
--   * *Srya Siddhnta*, ch. 3 (Triprashndhikra) ‚î the three questions
--     from gnomon shadows.  The surviving recension's date is disputed;
--     a *Srya Siddhnta* is one of the five summarised by Varhamihira,
--     *Pacasiddhntik*, c. 550, which is earlier than that recension.
--   * al-Brn, 11th c., writes on the astrolabe.
--   * Sawai Jai Singh II builds the Jantar Mantar instruments, 1724‚ì34,
--     in masonry: the Samr Yantra's precision comes from its size.
--
-- Repository greps run before writing (text name, not author name):
--   *Srya Siddhnta* 0, *Pacasiddhntik* 0, aku 0, chy 0,
--   prc 0, "Jantar Mantar" 0 files repository-wide.
--   *ryabhaya* 58 files, ryabhaa 98 ‚î the one text of this lane
--   already attended to, and not for its gnomon work.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE SCHOOLS, NAMED BEFORE THEIR TERMS ARE USED.
--
-- Nyya-Vaieika.  ¬ß3's `two-shadows-determine` is an ‡‡‡æ‡µ (abhva,
-- absence), and Navya-Nyya forbids asserting one bare: it must carry its
-- ‡‡‡∞‡‡ø‡Ø‡ã‡ó‡ø‡®‡ (pratiyogin, counterpositive) and its ‡‡µ‡‡‡‡‡¶‡ï (avacchedaka,
-- delimitor).  Named here: what is absent is orbit-agreement between the
-- states (false , true) and (false , false); the delimitor is the pair
-- (`turn` , `shadow`).  `NaturalMachine.Abhava` supplies the record that
-- forces this; nothing of its tower is re-landed here, and the standing
-- correction there ‚î that the tower is two-tall unconditionally and that
-- decidability is a fact about the pratiyogin, not the absence ‚î is taken
-- as read and not restated.
--
-- Jaina.  A Jaina logician answers that `Present` and `Orbit` are two
-- ‡®‡Ø (naya, standpoints), that neither is false, and that a naya
-- asserting itself by denying the other is a ‡¶‡‡∞‡‡®‡Ø (durnaya).  Their
-- objection to the Naiyyika above is specific: the pratiyogin was named
-- FROM a standpoint ‚î the reading `shadow` ‚î so a different reading names
-- a different counterpositive and the absence is a family, not one
-- entity.  The Naiyyika answers that once the avacchedaka is exhibited
-- the absence is determinate and needs no further relativisation, which
-- is exactly what the record in `Abhva` encodes.
--
-- THIS MODULE TAKES NEITHER SIDE, and can afford not to: every relation
-- below is explicitly indexed by (step , read), and ¬ß2's result is a
-- BICONDITIONAL, so no statement here requires the dispute settled.  Where
-- a verdict would be needed, there is a criterion instead.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED.
--
--  ¬ß1  For a state space with a step and a present reading, two quotients:
--      `Present` (this reading now) and `Orbit` (this reading at every
--      depth).  `orbit-refines-present`: Orbit ‚í Present, unconditional,
--      by evaluation at depth 0.
--
--  ¬ß2  THE CRITERION, both directions.  Present ‚í Orbit  ‚ü∫  the present
--      fibre is a CONGRUENCE for the step.  The forward direction is
--      induction on depth; the reverse is evaluation at depth 1.
--      `invariant‚ícongruence`: an invariant reading is a congruence.
--
--  ¬ß3  THE WITNESS, prc-sdhana in two bits.  `Dial = Bool ó Bool`,
--      `turn` swaps, `shadow` reads the first coordinate.  Two states
--      share a shadow now (`one-shadow-underdetermines`) and are
--      separated at depth 1 (`two-shadows-determine`); the present
--      quotient is first-coordinate equality and the ORBIT QUOTIENT IS
--      EQUALITY (`orbit-quotient-is-discrete`) ‚î two present blocks, four
--      orbit blocks, both exhibited.
--
--  ¬ß4  The two ports of `NaturalMachine.PhysicalLearningCore` are the two
--      sides of ¬ß2, checked as instances: the population port is
--      invariant hence a congruence, so its one-state quotient is already
--      predictive AT EVERY DEPTH ‚î which that module proves only one step
--      at a time; the coherent port is NOT invariant and is a congruence
--      anyway.
--
--  ¬ß5  `NaturalMachine.GaugeOrbitClasses` ¬ß7 proves size buys no
--      separating power.  Here: neither does DEPTH.  A gauge element in
--      qs^‚ä makes the transcript reading invariant, hence a congruence,
--      hence iterating it splits no observable class at any depth
--      (`neutral-gauge-adds-no-depth`), instantiated on the total flip
--      and probe-6.
--
--  ¬ß6  THE REFUTATION OF THIS AUTHOR'S OWN CLAIM, kept because it was
--      wrong.  Stated and killed below.
--
-- CHECKED: Agda 2.6.3 + cubical v0.5 ‚î the container, NOT the repository
-- pin (2.8.0 + v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.PraciSadhana_OneShadowUnderdeterminesAndTheOrbitQuotientCoincidesWithThePresentExactlyOnACongruence where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; true‚â¢false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_√ó_ ; _,_ ; fst ; snd ; Œ£PathP)
open import Cubical.Data.List using (List)
open import Cubical.Relation.Nullary using (¬¨_)

open import NaturalMachine.ParitySeparator using (Signs ; Number ; obs)
open import NaturalMachine.ChargeCriterion using (probe-6)
open import NaturalMachine.GaugeOrbitClasses
  using (Gauge ; _‚ãÜ_ ; AllNeutral ; obs-agree‚ãÜ ; œÑ‚Çã
        ; œÑ‚Çã-is-neutral-for-probe-6)
open import NaturalMachine.PhysicalLearningCore
  using (Phase ; Action ; evolve ; Port ; population ; coherent ; observe)
  renaming (flip to flipAction)

private
  variable
    ‚Ñì ‚Ñì' : Level

------------------------------------------------------------------------
-- ¬ß1  A aku reading: a state space, a step, and one shadow.
--
-- `step` is the motion between readings; `read` is what the instrument
-- returns.  `Present` is the fibre of one reading.  `Orbit` is the fibre
-- of the reading taken at every depth of the motion.
------------------------------------------------------------------------

module Reading {S : Type ‚Ñì} {O : Type ‚Ñì'} (step : S ‚Üí S) (read : S ‚Üí O) where

  orbit : ‚Ñï ‚Üí S ‚Üí S
  orbit zero    s = s
  orbit (suc k) s = step (orbit k s)

  -- one shadow
  Present : S ‚Üí S ‚Üí Type ‚Ñì'
  Present s s' = read s ‚â° read s'

  -- the shadow traced along the motion
  Orbit : S ‚Üí S ‚Üí Type ‚Ñì'
  Orbit s s' = (k : ‚Ñï) ‚Üí read (orbit k s) ‚â° read (orbit k s')

  -- Unconditional, and it is the whole of the easy direction: the
  -- forenoon mark is already one of the readings the orbit takes.
  orbit-refines-present : (s s' : S) ‚Üí Orbit s s' ‚Üí Present s s'
  orbit-refines-present s s' h = h zero

  ----------------------------------------------------------------------
  -- ¬ß2  The criterion.
  ----------------------------------------------------------------------

  Congruence : Type (‚Ñì-max ‚Ñì ‚Ñì')
  Congruence = (s s' : S) ‚Üí read s ‚â° read s' ‚Üí read (step s) ‚â° read (step s')

  Invariant : Type (‚Ñì-max ‚Ñì ‚Ñì')
  Invariant = (s : S) ‚Üí read (step s) ‚â° read s

  PresentIsOrbit : Type (‚Ñì-max ‚Ñì ‚Ñì')
  PresentIsOrbit = (s s' : S) ‚Üí Present s s' ‚Üí Orbit s s'

  -- forward: induction on depth, the congruence applied at each mark
  congruence‚Üípresent-is-orbit : Congruence ‚Üí PresentIsOrbit
  congruence‚Üípresent-is-orbit c s s' p zero    = p
  congruence‚Üípresent-is-orbit c s s' p (suc k) =
    c (orbit k s) (orbit k s') (congruence‚Üípresent-is-orbit c s s' p k)

  -- reverse: evaluation at depth one.  Nothing deeper is needed, which is
  -- why the criterion is about a single step and not about the tail.
  present-is-orbit‚Üícongruence : PresentIsOrbit ‚Üí Congruence
  present-is-orbit‚Üícongruence h s s' p = h s s' p 1

  praci-criterion : (Congruence ‚Üí PresentIsOrbit) √ó (PresentIsOrbit ‚Üí Congruence)
  praci-criterion = congruence‚Üípresent-is-orbit , present-is-orbit‚Üícongruence

  invariant‚Üícongruence : Invariant ‚Üí Congruence
  invariant‚Üícongruence inv s s' p = inv s ‚àô p ‚àô sym (inv s')

  invariant‚Üípresent-is-orbit : Invariant ‚Üí PresentIsOrbit
  invariant‚Üípresent-is-orbit inv = congruence‚Üípresent-is-orbit (invariant‚Üícongruence inv)

------------------------------------------------------------------------
-- ¬ß3  The witness: one shadow underdetermines.
--
-- Two bits, and the motion exchanges them.  The instrument reads the
-- first bit only.  This is the forenoon mark alone.
------------------------------------------------------------------------

Dial : Type‚ÇÄ
Dial = Bool √ó Bool

turn : Dial ‚Üí Dial
turn (a , b) = (b , a)

shadow : Dial ‚Üí Bool
shadow = fst

module Dial‚Ñõ = Reading turn shadow

-- The present reading is exactly first-coordinate agreement: two blocks.
present-quotient-is-the-first-coordinate :
  (s s' : Dial) ‚Üí Dial‚Ñõ.Present s s' ‚â° (fst s ‚â° fst s')
present-quotient-is-the-first-coordinate s s' = refl

-- The forenoon marks coincide ‚¶
one-shadow-underdetermines : Dial‚Ñõ.Present (false , true) (false , false)
one-shadow-underdetermines = refl

-- ‚¶ and the afternoon marks do not.
two-shadows-determine : ¬¨ (Dial‚Ñõ.Orbit (false , true) (false , false))
two-shadows-determine h = true‚â¢false (h 1)

-- so the present fibre is not a congruence, and by ¬ß2 that is the only
-- reason it could fail to be the orbit fibre.
turn-is-not-a-congruence : ¬¨ Dial‚Ñõ.Congruence
turn-is-not-a-congruence c = true‚â¢false (c (false , true) (false , false) refl)

-- THE ORBIT QUOTIENT IS EQUALITY: four blocks, against the present two.
-- Depth 0 supplies the first bit, depth 1 the second; nothing deeper is
-- used, and nothing deeper exists (the motion has period two).
orbit-quotient-is-discrete : (s s' : Dial) ‚Üí Dial‚Ñõ.Orbit s s' ‚Üí s ‚â° s'
orbit-quotient-is-discrete (a , b) (a' , b') h = Œ£PathP (h 0 , h 1)

------------------------------------------------------------------------
-- ¬ß4  The two ports of `PhysicalLearningCore`, as instances of ¬ß2.
--
-- That module proves `population-collapses-phase` action by action and
-- `compile-step` one step at a time.  Neither is a statement about depth.
-- Below, both ports are handed to ¬ß2 with the flip action as the motion,
-- and the depth statement follows for each ‚î from invariance at the
-- population port, and from congruence WITHOUT invariance at the coherent
-- port, which is ¬ß6's point in situ.
------------------------------------------------------------------------

module Pop‚Ñõ = Reading (evolve flipAction) (observe population)
module Coh‚Ñõ = Reading (evolve flipAction) (observe coherent)

population-is-invariant : Pop‚Ñõ.Invariant
population-is-invariant s = refl

-- The one-state population quotient is predictive at EVERY depth.
population-quotient-is-already-predictive : Pop‚Ñõ.PresentIsOrbit
population-quotient-is-already-predictive =
  Pop‚Ñõ.invariant‚Üípresent-is-orbit population-is-invariant

-- The coherent port is not invariant: the flip moves the reading.
coherent-is-not-invariant : ¬¨ Coh‚Ñõ.Invariant
coherent-is-not-invariant inv = true‚â¢false (inv false)

-- ‚¶and it is a congruence all the same.
coherent-is-a-congruence : Coh‚Ñõ.Congruence
coherent-is-a-congruence s s' p = cong not p

coherent-quotient-is-already-predictive : Coh‚Ñõ.PresentIsOrbit
coherent-quotient-is-already-predictive =
  Coh‚Ñõ.congruence‚Üípresent-is-orbit coherent-is-a-congruence

------------------------------------------------------------------------
-- ¬ß5  Depth buys no separating power either.
--
-- `GaugeOrbitClasses` ¬ß7: appending arbitrarily large square queries
-- splits no observable class ‚î size is not partial charge.  The same
-- statement one axis over: translating repeatedly by a gauge element of
-- qs^‚ä splits no observable class, at any depth.  `obs-agree‚ã` makes the
-- transcript reading invariant under that step, and ¬ß2 does the rest.
--
-- This is not a new fact about the gauge group; it is ¬ß2 applied to it,
-- and the reason it is short is that `obs-agree‚ã` was already there.
------------------------------------------------------------------------

neutral-gauge-adds-no-depth :
    (œÑ : Gauge) (qs : List Number) ‚Üí AllNeutral œÑ qs
  ‚Üí Reading.PresentIsOrbit (œÑ ‚ãÜ_) (Œª œÅ ‚Üí obs œÅ qs)
neutral-gauge-adds-no-depth œÑ qs h =
  Reading.invariant‚Üípresent-is-orbit (œÑ ‚ãÜ_) (Œª œÅ ‚Üí obs œÅ qs)
    (Œª œÉ ‚Üí sym (obs-agree‚ãÜ œÑ œÉ qs h))

module Probe6‚Ñõ = Reading (œÑ‚Çã ‚ãÜ_) (Œª œÅ ‚Üí obs œÅ probe-6)

-- The total flip, iterated, never splits a probe-6 class.
total-flip-adds-no-depth-on-probe-6 : Probe6‚Ñõ.PresentIsOrbit
total-flip-adds-no-depth-on-probe-6 =
  neutral-gauge-adds-no-depth œÑ‚Çã probe-6 œÑ‚Çã-is-neutral-for-probe-6

------------------------------------------------------------------------
-- ¬ß6  REFUTED, BY ITS AUTHOR, BEFORE PUBLICATION.
--
-- THE CLAIM I MADE.  `machinery/smith_holonomy_predictive_control.py`
-- proves an invariant-observation lemma and then exhibits a "false
-- control": the second Smith coordinate is not holonomy-invariant, and
-- its predictive quotient has four states against the current
-- observation's two.  Reading those two together, I claimed:
--
--     a reading that is NOT invariant under the step is refined by the
--     orbit ‚î i.e. ¬ Invariant gives a pair related by `Present` and not
--     by `Orbit`.
--
-- THE KILL.  False, and the cheapest possible counterexample is already
-- in the drawn material: the coherent port of `PhysicalLearningCore`.
-- `evolve flip` is `not` and `observe coherent` is the identity.  The
-- reading is not invariant (`coherent-is-not-invariant`, ¬ß4) and the
-- orbit refines nothing (`coherent-quotient-is-already-predictive`, ¬ß4).
-- Restated here as one term so the refutation is a check and not a
-- remark:
------------------------------------------------------------------------

non-invariance-does-not-imply-orbit-refinement :
  (¬¨ Coh‚Ñõ.Invariant) √ó Coh‚Ñõ.PresentIsOrbit
non-invariance-does-not-imply-orbit-refinement =
  coherent-is-not-invariant , coherent-quotient-is-already-predictive

------------------------------------------------------------------------
-- WHAT THE KILL COST, AND WHAT IT BOUGHT.
--
-- Invariance is sufficient for the quotients to coincide and is not
-- necessary.  What is necessary and sufficient is congruence (¬ß2), which
-- is strictly weaker: `coherent-is-a-congruence` holds where
-- `Coh‚.Invariant` is refuted.  The .py file's lemma is therefore sound
-- and its hypothesis is not the boundary; the boundary is one step over,
-- and the "false control" there is a case, not the criterion.
--
-- In the instrument: a reading can move with the sun and still lose
-- nothing to a second reading ‚î that is a reading whose motion is
-- determined by the reading itself.  The prc-sdhana needs its second
-- mark precisely because the shadow's direction is NOT determined by the
-- shadow's length; ¬ß3 is that failure in two bits.
------------------------------------------------------------------------
