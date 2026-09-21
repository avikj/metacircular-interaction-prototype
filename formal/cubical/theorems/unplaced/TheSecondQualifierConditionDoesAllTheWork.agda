{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheSecondUpadhiConditionDoesAllTheWork
--
-- The Naiyyikas state TWO conditions on an updhi.  Proved here: the
-- first alone is satisfied by a candidate that always exists, so it
-- carries no information; the second is what has content; and the bare
-- existential "some updhi exists" is equivalent to "the pervasion
-- fails" and therefore says nothing beyond it.  Only a NAMED updhi is
-- informative â” which is why the Navya-Nyya treatment is a taxonomy of
-- candidates and not an existence claim.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE SCHOOL, AND ITS TERMS, NAMED BEFORE USE
--
-- Nyya (Gautama, *Nyyastra*; the updhi machinery developed by the
-- Navya-Naiyyikas, Gagea, *Tattvacintmai*, 14th c.).  A *vypti* is
-- a pervasion â” wherever the hetu, there the sdhya.  An *updhi* is the
-- adventitious condition that defeats one.  The standard pair of
-- conditions on a genuine updhi U, for the inference "hetu H, therefore
-- sdhya S":
--
--   sdhya-vypakatva   U pervades the sdhya      (x : D) â’ S x â’ U x
--   sdhana-avypakatva U does not pervade the hetu Â ((x) â’ H x â’ U x)
--
-- The textbook instance: "the mountain has smoke because it has fire" â”
-- the updhi is wet fuel, which pervades smoke and does not pervade fire
-- (red-hot iron).
--
-- WHAT A RIVAL SCHOOL WOULD SAY.  The Jaina objection to the Naiyyika
-- apparatus is that a pervasion asserted flatly, without its standpoint,
-- is already a durnaya; on that reading `Vyapti` is the durnaya and U is
-- the missing *syt*.  The Naiyyika reply is that this dissolves the
-- inference rather than repairing it: if every vypti is conditioned,
-- no anumna is a prama, and the updhi apparatus exists precisely to
-- keep the unconditioned ones.  Nothing below adjudicates that; the
-- theorems are about the two conditions as the Naiyyikas state them.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT PROVOKED THIS
--
-- `interactive/Upadhi.hs`.  It reports that the engine's
-- sampler draws 40 assignments reduced `mod 9` and declares two terms
-- equal when their 40 values agree, and it records â” in its own words â”
-- "the risk is real and the failure is unobserved, and those are
-- different statements."
--
-- Â§4 is that sentence as a theorem, with the shelf's own numbers used
-- for nothing but the choice of probe size.  NO measurement from that
-- shelf is reproduced, relied on, or needed here: the probe below is
-- nine points because `mod 9` is nine points, and the counterexample is
-- exhibited, not sampled.
------------------------------------------------------------------------

module TheSecondUpadhiConditionDoesAllTheWork where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; znots)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

------------------------------------------------------------------------
-- 1.  Vypti and the two conditions
------------------------------------------------------------------------

module _ (D : Type) (H S : D â†’ Type) where

  -- the pervasion itself
  Vyapti : Type
  Vyapti = (x : D) â†’ H x â†’ S x

  -- sdhya-vypakatva: U pervades the sdhya
  SadhyaVyapaka : (D â†’ Type) â†’ Type
  SadhyaVyapaka U = (x : D) â†’ S x â†’ U x

  -- sdhana-avypakatva: U does not pervade the hetu
  SadhanaAvyapaka : (D â†’ Type) â†’ Type
  SadhanaAvyapaka U = Â¬ ((x : D) â†’ H x â†’ U x)

  Upadhi : (D â†’ Type) â†’ Type
  Upadhi U = SadhyaVyapaka U Ã— SadhanaAvyapaka U

  --------------------------------------------------------------------
  -- 2.  The first condition alone is vacuous
  --------------------------------------------------------------------

  -- the sdhya pervades itself, so a candidate meeting condition one
  -- exists for EVERY inference, with no hypothesis whatever
  firstConditionAlwaysHasACandidate : Î£[ U âˆˆ (D â†’ Type) ] SadhyaVyapaka U
  firstConditionAlwaysHasACandidate = S , Î» _ s â†’ s

  -- and for that candidate, condition two IS the failure of the
  -- pervasion â” the same type, not merely an equivalent one
  secondConditionOnTheTrivialCandidate : SadhanaAvyapaka S â‰¡ (Â¬ Vyapti)
  secondConditionOnTheTrivialCandidate = refl

  --------------------------------------------------------------------
  -- 3.  So the existential says nothing, and the naming says everything
  --------------------------------------------------------------------

  -- a genuine updhi refutes the pervasion
  upadhiRefutesVyapti : (U : D â†’ Type) â†’ Upadhi U â†’ Â¬ Vyapti
  upadhiRefutesVyapti U (sv , sa) vy = sa (Î» x h â†’ sv x (vy x h))

  -- â¦and conversely, any failed pervasion has one, by the trivial
  -- candidate.  Hence `Î U. Upadhi U` and `Â Vyapti` are interderivable:
  -- the existential carries exactly the information that the inference
  -- is bad, and none about WHY.
  failedVyaptiHasAnUpadhi : Â¬ Vyapti â†’ Î£[ U âˆˆ (D â†’ Type) ] Upadhi U
  failedVyaptiHasAnUpadhi nv = S , (Î» _ s â†’ s) , nv

  someUpadhiExistsâ†’vyaptiFails : Î£[ U âˆˆ (D â†’ Type) ] Upadhi U â†’ Â¬ Vyapti
  someUpadhiExistsâ†’vyaptiFails (U , u) = upadhiRefutesVyapti U u

------------------------------------------------------------------------
-- 4.  A named updhi: agreement at an untested point
--
-- The inference under test is the sampler's:
--   hetu    H â” the two functions agree on the probe
--   sdhya  S â” the two functions are equal
-- and the updhi is `U` â” they agree at 9, the first point `mod 9`
-- cannot reach.
------------------------------------------------------------------------

All : {A : Type} (Q : A â†’ Type) â†’ List A â†’ Type
All Q []       = Unit
All Q (x âˆ· xs) = Q x Ã— All Q xs

probe : List â„•
probe = 0 âˆ· 1 âˆ· 2 âˆ· 3 âˆ· 4 âˆ· 5 âˆ· 6 âˆ· 7 âˆ· 8 âˆ· []

fâ‚€ : â„• â†’ â„•
fâ‚€ _ = 0

gâ‚€ : â„• â†’ â„•
gâ‚€ 0 = 0
gâ‚€ 1 = 0
gâ‚€ 2 = 0
gâ‚€ 3 = 0
gâ‚€ 4 = 0
gâ‚€ 5 = 0
gâ‚€ 6 = 0
gâ‚€ 7 = 0
gâ‚€ 8 = 0
gâ‚€ _ = 1

Pair : Type
Pair = (â„• â†’ â„•) Ã— (â„• â†’ â„•)

Hprobe : Pair â†’ Type
Hprobe (f , g) = All (Î» x â†’ f x â‰¡ g x) probe

Severy : Pair â†’ Type
Severy (f , g) = (x : â„•) â†’ f x â‰¡ g x

Uat9 : Pair â†’ Type
Uat9 (f , g) = f 9 â‰¡ g 9

-- the witness the sampler cannot see: agreement on all nine probe points
agreeOnProbe : Hprobe (fâ‚€ , gâ‚€)
agreeOnProbe =
  refl , refl , refl , refl , refl , refl , refl , refl , refl , tt

-- sdhya-vypakatva: equality everywhere gives agreement at 9
u-pervades-sadhya : SadhyaVyapaka Pair Hprobe Severy Uat9
u-pervades-sadhya (f , g) s = s 9

-- sdhana-avypakatva: probe-agreement does NOT give agreement at 9
u-does-not-pervade-hetu : SadhanaAvyapaka Pair Hprobe Severy Uat9
u-does-not-pervade-hetu h = znots (h (fâ‚€ , gâ‚€) agreeOnProbe)

theUpadhi : Upadhi Pair Hprobe Severy Uat9
theUpadhi = u-pervades-sadhya , u-does-not-pervade-hetu

-- and therefore the sampler's pervasion is not one
probeAgreementDoesNotPervadeEquality : Â¬ Vyapti Pair Hprobe Severy
probeAgreementDoesNotPervadeEquality =
  upadhiRefutesVyapti Pair Hprobe Severy Uat9 theUpadhi

------------------------------------------------------------------------
-- 5.  What Â§2â“Â§3 change about how the shelf's sentence should be read
--
-- `interactive/Upadhi.hs` distinguishes "the risk is real" from "the failure
-- is unobserved".  Â§3 says why that distinction is forced rather than
-- cautious: `Î U. Upadhi U` is interderivable with `Â Vyapti`, so
-- asserting that SOME defeating condition exists is not weaker evidence
-- for the same thing â” it is the same statement.  What is not the same
-- statement is exhibiting one, and Â§4 exhibits one for a probe while the
-- shelf's own search for one among ACTUAL engine terms returned nothing.
--
-- The two live on one axis: `Â Vyapti` is a
-- negation and is ÂÂ-stable for free; `Î U. Upadhi U` is a search, and
-- its stability is not free â” it is bought with a decision or with a
-- construction.  Here the construction is `theUpadhi`, given outright.
-- Cross-reference, same axis, different object:
-- `PermanentUnsaidIsStableAndTemporaryIsASearch`.
------------------------------------------------------------------------
