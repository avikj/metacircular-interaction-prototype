{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡ ‚î ‡ï‡¶‡æ ‡‡®‡‡‡‡ ‡‡ï‡æ ‡‡µ ‡ï‡ï‡‡‡‡Ø‡æ ‡
--
-- (when is the fibre exhausted by one orbit ‚î the converse of descent.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS IS, and it is a CORRECTION before it is an addition.
--
-- `SamanaKaksya_‚¶agda` ¬ß‡ ("‡‡‡‡") says, of its descended charge
-- `‡‡µ‡‡‡∞‡‡‡ : A / ‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ Œ¶ ‚í B`:
--
--     "The converse of ¬ß‡ ‚î that `‡‡µ‡‡‡∞‡‡‡` is injective, i.e. equal
--      charge implies one orbit ‚î is `Kaksya` ¬ß‡'s `‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡` and is a
--      genuine hypothesis about the flow, not a missing definition."
--
-- and its WHAT-IS-NOT-CLAIMED fence says the same: "that it is
-- INJECTIVE ‚¶ is exactly the transitivity hypothesis `‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡` of
-- `Kaksya` ¬ß‡".
--
-- **That sentence is FALSE, in the direction it is used.**  `Kaksya`
-- ¬ß‡'s `‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡ b` is ONE-SIDED reachability ‚î `Œ[ n ] Œ¶‚ø x ‚â° y` for
-- every ordered pair in the fibre ‚î and `‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ` is the TWO-SIDED
-- meeting relation.  One-sided is SUFFICIENT for injectivity (¬ß‡©, via
-- ¬ß‡ß) and is NOT necessary: ¬ß‡ exhibits `f = Œª _ ‚í tt : Bool ‚í Unit`
-- with `Œ¶ = Œª _ ‚í true`, where `‡‡µ‡‡‡∞‡‡‡` is injective (indeed an
-- equivalence, the fibre being one orbit in the meeting sense) while
-- `‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡ tt` is refuted outright ‚î nothing reaches `false`.
--
-- The hypothesis that IS equivalent to injectivity is named here:
--
--     ‡â‡‡Ø-‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡ b  :=  (x y : fiber f b) ‚í ‚à ‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ Œ¶ x.fst y.fst ‚à‚
--
-- two-sided, and propositionally truncated.  Both amendments are
-- forced, and by the same fact: `[ a ] ‚â° [ b ]` in a set quotient
-- recovers the relation only up to `‚à_‚à‚` (`isEquivRel‚íTruncIso`), and
-- `‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ` is NOT prop-valued ‚î the meeting stations are data,
-- which is exactly the openness `SamanaKaksya` ¬ß‡ flagged in its last
-- paragraph.  So the truncation is not a technicality bolted on; it is
-- the same observation, arriving as the reason the naive converse
-- cannot hold.
--
-- With the hypothesis corrected, both directions go through (¬ß‡©, ¬ß‡),
-- and then the theorem worth having (¬ß‡):
--
--     **`‡‡µ‡‡‡∞‡‡‡` is an equivalence  ‚ü∫  `f` is surjective and the flow
--       is fibrewise transitive.**
--
-- Stated as an equivalence of PROPOSITIONS, not a pair of implications.
-- That is the precise sense in which "the observable IS the quotient":
-- the level sets of `f` are exactly the gauge orbits, with nothing left
-- over (injectivity) and nothing missing (surjectivity).
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- **Nothing here says the two-sided hypothesis is CHEAP.**  It is a real
-- hypothesis about the flow; ¬ß‡ only shows it is strictly weaker than
-- the one-sided one, not that it is free.
--
-- **¬ß‡ refutes a hypothesis, not a theorem.**  `Kaksya` ¬ß‡ proves that
-- `‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡ b` implies no invariant separates the fibre; that theorem
-- is untouched and true.  What is refuted is `SamanaKaksya` ¬ß‡'s claim
-- that `‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡` is *the* content of injectivity.
--
-- **No claim about the untruncated relation.**  Whether `[ a ] ‚â° [ b ]`
-- yields `‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ` itself (rather than its truncation) is not
-- addressed and is false in general for relations carrying data.
--
-- TERMS.  ‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡ ‚î "passing over, transition"; in jyotia the sun's
-- sakrnti, its passage from one ri into the next (standard in the
-- siddhntic tradition following the ryabhaya, 499); in Jaina karma
-- theory, sakrama, the transition of one karma-prakti into another
-- (akhagama with Vrasena's Dhaval, ~816).  LIMIT: neither sense
-- is a claim about endomorphisms of a type; the use of the word for
-- "the flow carries one point of a fibre to another" is `Kaksya_‚¶agda`'s
-- and is carried in unchanged from there.  ‡â‡‡Ø ‚î "both, two-sided",
-- ordinary ; the compound ‡â‡‡Ø-‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡ is BUILT HERE and no
-- text is claimed for it.  ‡ï‡ï‡‡‡‡Ø‡æ ‚î orbit, as in `Kaksya_‚¶agda`, with
-- its limit unchanged (attested for a planet's orbit; its use for the
-- orbit of an endomorphism is this corpus's).  NO SOURCE STATES ANYTHING
-- BELOW.
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5 ‚î the container, NOT the
-- repository pin (2.8.0 + v0.9).  --cubical --safe, no postulates, no
-- holes, exit 0.
------------------------------------------------------------------------

module Sankramana_TheFibreIsOneOrbitExactlyWhenTheChargeIsInjectiveAndOneSidedReachabilityIsStrictlyStronger where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso)
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Equiv
  using (isEquiv ; isPropIsEquiv ; invEq ; secEq ; retEq ; _‚âÉ_ ; fiber
        ; propBiimpl‚ÜíEquiv)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Relation.Binary.Base using (module BinaryRelation)
open import Cubical.HITs.SetQuotients using (_/_ ; [_] ; eq/ ; squash/ ; elimProp)
open import Cubical.HITs.PropositionalTruncation as PT using (‚à•_‚à•‚ÇÅ ; ‚à£_‚à£‚ÇÅ)
open import Cubical.Functions.Surjection
  using (isSurjection ; isPropIsSurjection ; isEmbedding√óisSurjection‚ÜíisEquiv)
open import Cubical.Functions.Embedding using (injEmbedding)

open BinaryRelation

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry
  using (‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç)
open import Kaksya_TheChargeIsConstantAlongTheWholeOrbitAndNotOnlyAcrossOneStep
  using (‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ ; ‡§ß‡•ç‡§∞‡•Å‡§µ‡§Ç-‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ‡§Ø‡§æ‡§Æ‡•ç ; ‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç)
open import SamanaKaksya_TheOrbitRelationIsAlreadyAnEquivalenceWithoutAnInverseAndTheChargeDescendsToTheQuotient
  using (‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ ; ‡§∏‡§Æ‡§æ‡§®-‡§∏‡•ç‡§µ ; ‡§∏‡§Æ‡§æ‡§®-‡§µ‡•ç‡§Ø‡§§‡•ç‡§Ø‡§Ø‡§É ; ‡§∏‡§Æ‡§æ‡§®-‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§É
        ; ‡§≠‡§æ‡§ó‡§É ; ‡§Ö‡§µ‡§§‡•Ä‡§∞‡•ç‡§£‡§É)

private variable ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡Æ‡‡æ-‡‡‡∞‡Æ‡æ‡‡Æ‡ ‚î the orbit relation packaged as `isEquivRel`, and
--     the truncated characterisation of paths in the quotient.
--
-- `SamanaKaksya` ¬ß‡® proves the three laws separately.  The library's
-- effectivity result wants them in one record, and `isEquivRel‚íTruncIso`
-- then gives, for a relation that need NOT be prop-valued:
--
--     [ a ] ‚â° [ b ]   ‚â   ‚à ‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ Œ¶ a b ‚à‚
--
-- This is where the truncation in ¬ß‡®'s hypothesis comes from.  It is
-- not a choice.
------------------------------------------------------------------------

module _ {A : Type ‚Ñì} (Œ¶ : A ‚Üí A) where

  ‡§∏‡§Æ‡§æ‡§®-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç : isEquivRel (‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶)
  ‡§∏‡§Æ‡§æ‡§®-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç = equivRel (‡§∏‡§Æ‡§æ‡§®-‡§∏‡•ç‡§µ Œ¶) (‡§∏‡§Æ‡§æ‡§®-‡§µ‡•ç‡§Ø‡§§‡•ç‡§Ø‡§Ø‡§É Œ¶) (‡§∏‡§Æ‡§æ‡§®-‡§∏‡§Ç‡§ï‡•ç‡§∞‡§Æ‡§É Œ¶)

  -- [ a ] ‚â° [ b ]  ‚ü  ‚à a ‚âà b ‚à‚ .  The library's `isEquivRel‚íTruncIso`
  -- is stated for `_/_` with the relation implicit; we name only the
  -- direction we use.
  ‡§™‡§•‡§æ‡§§‡•ç-‡§∏‡§Æ‡§§‡§æ : (a b : A) ‚Üí [ a ] ‚â° [ b ] ‚Üí ‚à• ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶ a b ‚à•‚ÇÅ
  ‡§™‡§•‡§æ‡§§‡•ç-‡§∏‡§Æ‡§§‡§æ a b =
    Iso.fun (Cubical.HITs.SetQuotients.isEquivRel‚ÜíTruncIso ‡§∏‡§Æ‡§æ‡§®-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç a b)

------------------------------------------------------------------------
-- ‡® ¬ ‡â‡‡Ø-‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡ ‚î THE CORRECTED HYPOTHESIS: the flow is transitive
--     on the fibre in the TWO-SIDED, truncated sense.
--
-- Compare `Kaksya` ¬ß‡:
--
--     ‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡ b = (x y : fiber f b) ‚í Œ[ n ‚àà ‚ï ] Œ¶‚ø (fst x) ‚â° fst y
--
-- ‚î ordered, untruncated, and carrying the number of steps as data.
-- Below is the same sentence with "reaches" replaced by "meets" and the
-- witness forgotten.  ¬ß‡ shows the two are NOT equivalent.
------------------------------------------------------------------------

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) (Œ¶ : A ‚Üí A) where

  ‡§â‡§≠‡§Ø-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç : B ‚Üí Type ‚Ñì
  ‡§â‡§≠‡§Ø-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç b = (x y : fiber f b) ‚Üí ‚à• ‡§∏‡§Æ‡§æ‡§®‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ Œ¶ (fst x) (fst y) ‚à•‚ÇÅ

  -- it is a proposition, which is why ¬ß‡ can be an equivalence rather
  -- than a pair of implications
  ‡§â‡§≠‡§Ø-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç : (b : B) ‚Üí isProp (‡§â‡§≠‡§Ø-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç b)
  ‡§â‡§≠‡§Ø-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç b = isPropŒ†2 Œª _ _ ‚Üí PT.isPropPropTrunc

  -- ONE-SIDED IMPLIES TWO-SIDED.  Stay put on the right, forget the
  -- step count.  (The converse is refuted in ¬ß‡.)
  ‡§è‡§ï‡§™‡§æ‡§∞‡•ç‡§∂‡•ç‡§µ‡§æ‡§§‡•ç-‡§â‡§≠‡§Ø‡§Æ‡•ç : (b : B) ‚Üí ‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç f Œ¶ b ‚Üí ‡§â‡§≠‡§Ø-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç b
  ‡§è‡§ï‡§™‡§æ‡§∞‡•ç‡§∂‡•ç‡§µ‡§æ‡§§‡•ç-‡§â‡§≠‡§Ø‡§Æ‡•ç b tr x y = ‚à£ fst (tr x y) , zero , snd (tr x y) ‚à£‚ÇÅ

------------------------------------------------------------------------
-- ‡© ¬ ‡‡®‡‡‡‡ ‡‡ï‡æ ‡ï‡ï‡‡‡‡Ø‡æ ‡‡‡ø ‡‡µ‡‡‡∞‡‡‡‡‡Ø ‡‡ï‡‡‡µ‡Æ‡ ‚î TRANSITIVITY IMPLIES
--     THE DESCENDED CHARGE IS INJECTIVE.
--
-- Equal charge ‚í one orbit ‚í one class.  The proof is `elimProp` twice,
-- legitimate because a path in a set quotient is a proposition, and
-- then `eq/` under the truncation, legitimate for the same reason.
--
-- Note `‡‡µ‡‡‡∞‡‡‡ [ a ] ‚â° f a` holds on the nose (`SamanaKaksya` ¬ß‡), so
-- the hypothesis `p` below IS `f a ‚â° f b` with no coercion.
------------------------------------------------------------------------

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) (Œ¶ : A ‚Üí A)
         (setB : isSet B) (cons : ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶) where

  private
    fÃÑ : ‡§≠‡§æ‡§ó‡§É f Œ¶ setB cons ‚Üí B
    fÃÑ = ‡§Ö‡§µ‡§§‡•Ä‡§∞‡•ç‡§£‡§É f Œ¶ setB cons

  ‡§è‡§ï‡§§‡•ç‡§µ‡§Æ‡•ç : Type ‚Ñì
  ‡§è‡§ï‡§§‡•ç‡§µ‡§Æ‡•ç = (q q' : ‡§≠‡§æ‡§ó‡§É f Œ¶ setB cons) ‚Üí fÃÑ q ‚â° fÃÑ q' ‚Üí q ‚â° q'

  ‡§è‡§ï‡§§‡•ç‡§µ‡§Æ‡•ç-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç : isProp ‡§è‡§ï‡§§‡•ç‡§µ‡§Æ‡•ç
  ‡§è‡§ï‡§§‡•ç‡§µ‡§Æ‡•ç-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç = isPropŒ†3 Œª q q' _ ‚Üí squash/ q q'

  -- ‚ü : the fibre is one orbit, so the charge separates classes
  ‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§æ‡§§‡•ç-‡§è‡§ï‡§§‡•ç‡§µ‡§Æ‡•ç : ((b : B) ‚Üí ‡§â‡§≠‡§Ø-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç f Œ¶ b) ‚Üí ‡§è‡§ï‡§§‡•ç‡§µ‡§Æ‡•ç
  ‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§æ‡§§‡•ç-‡§è‡§ï‡§§‡•ç‡§µ‡§Æ‡•ç tr =
    elimProp (Œª q ‚Üí isPropŒ†2 Œª q' _ ‚Üí squash/ q q')
      (Œª a ‚Üí elimProp (Œª q' ‚Üí isPropŒ† Œª _ ‚Üí squash/ [ a ] q')
        (Œª b p ‚Üí PT.rec (squash/ [ a ] [ b ]) (eq/ a b)
                   (tr (f a) (a , refl) (b , sym p))))

------------------------------------------------------------------------
-- ‡ ¬ ‡µ‡‡Ø‡‡‡Ø‡Ø‡ ‚î AND THE CONVERSE.  Injectivity implies the corrected
--     transitivity, and this is the direction that forces the two
--     amendments: `[ a ] ‚â° [ b ]` gives back only `‚à a ‚âà b ‚à‚`, and `‚âà`
--     is the meeting relation, not reachability.
------------------------------------------------------------------------

  ‡§è‡§ï‡§§‡•ç‡§µ‡§æ‡§§‡•ç-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç : ‡§è‡§ï‡§§‡•ç‡§µ‡§Æ‡•ç ‚Üí (b : B) ‚Üí ‡§â‡§≠‡§Ø-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç f Œ¶ b
  ‡§è‡§ï‡§§‡•ç‡§µ‡§æ‡§§‡•ç-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç inj b (x , px) (y , py) =
    ‡§™‡§•‡§æ‡§§‡•ç-‡§∏‡§Æ‡§§‡§æ Œ¶ x y (inj [ x ] [ y ] (px ‚àô sym py))

------------------------------------------------------------------------
-- ‡ ¬ ‡‡µ‡‡‡∞‡‡‡ ‡‡Æ‡‡æ ‚î THE THEOREM.  The observable IS the quotient
--     exactly when it is onto and its level sets are single orbits.
--
--     isEquiv ‡‡µ‡‡‡∞‡‡‡  ‚â  isSurjection f ó (fibrewise transitivity)
--
-- Both sides are propositions, so this is an equivalence of types and
-- not merely a pair of implications ‚î `propBiimpl‚íEquiv`.
--
-- Read at the physics: the gauge-invariant observable is a faithful
-- coordinate on the space of physical states precisely when (a) every
-- value is attained and (b) the gauge flow already identifies
-- everything the observable cannot separate.  (b) failing is a residual
-- charge; (a) failing is a value with no state.  No Lagrangian occurs.
------------------------------------------------------------------------

  private
    ‡§≤‡§ô‡•ç‡§ò‡§®‡§Æ‡•ç : isEquiv fÃÑ ‚Üí isSurjection f
    ‡§≤‡§ô‡•ç‡§ò‡§®‡§Æ‡•ç e b =
      elimProp {P = Œª q ‚Üí fÃÑ q ‚â° b ‚Üí ‚à• fiber f b ‚à•‚ÇÅ}
        (Œª _ ‚Üí isPropŒ† Œª _ ‚Üí PT.isPropPropTrunc)
        (Œª a p ‚Üí ‚à£ a , p ‚à£‚ÇÅ)
        (invEq (fÃÑ , e) b)
        (secEq (fÃÑ , e) b)

    ‡§∏‡§∞‡•ç‡§µ‡§§‡•ç‡§∞ : isSurjection f ‚Üí isSurjection fÃÑ
    ‡§∏‡§∞‡•ç‡§µ‡§§‡•ç‡§∞ s b = PT.map (Œª { (a , p) ‚Üí [ a ] , p }) (s b)

  ‡§Ö‡§µ‡§§‡•Ä‡§∞‡•ç‡§£‡§É-‡§∏‡§Æ‡§§‡§æ :
    isEquiv fÃÑ ‚âÉ (isSurjection f √ó ((b : B) ‚Üí ‡§â‡§≠‡§Ø-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç f Œ¶ b))
  ‡§Ö‡§µ‡§§‡•Ä‡§∞‡•ç‡§£‡§É-‡§∏‡§Æ‡§§‡§æ =
    propBiimpl‚ÜíEquiv
      (isPropIsEquiv fÃÑ)
      (isProp√ó isPropIsSurjection (isPropŒ† (‡§â‡§≠‡§Ø-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£‡§Æ‡•ç f Œ¶)))
      (Œª e ‚Üí ‡§≤‡§ô‡•ç‡§ò‡§®‡§Æ‡•ç e
           , ‡§è‡§ï‡§§‡•ç‡§µ‡§æ‡§§‡•ç-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç
               (Œª q q' p ‚Üí sym (retEq (fÃÑ , e) q) ‚àô cong (invEq (fÃÑ , e)) p
                           ‚àô retEq (fÃÑ , e) q'))
      (Œª { (s , tr) ‚Üí
             isEmbedding√óisSurjection‚ÜíisEquiv
               ( injEmbedding setB (Œª {q} {q'} p ‚Üí ‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§æ‡§§‡•ç-‡§è‡§ï‡§§‡•ç‡§µ‡§Æ‡•ç tr q q' p)
               , ‡§∏‡§∞‡•ç‡§µ‡§§‡•ç‡§∞ s ) })

------------------------------------------------------------------------
-- ‡ ¬ ‡‡ï‡‡æ‡∞‡‡‡‡µ‡ ‡ó‡‡∞‡‡‡∞‡Æ‡ ‚î ONE-SIDED REACHABILITY IS STRICTLY STRONGER,
--     AND THIS IS THE CORRECTION.
--
-- Two points, one collapsing flow, and the whole gap in four lines.
--
--     A = Bool,  B = Unit,  f = Œª _ ‚í tt,  Œ¶ = Œª _ ‚í true.
--
-- Conservation is `refl`.  The single fibre is all of `Bool`.
--
--   ¬ TWO-SIDED holds: both trajectories are at `true` after one step,
--     so any two points meet at stations `(1 , 1)`.  Hence by ¬ß‡ the
--     descended charge `Bool / ‡‡Æ‡æ‡®‡ï‡ï‡‡‡‡Ø‡æ Œ¶ ‚í Unit` is an equivalence:
--     the fibre IS one orbit in the only sense the quotient can see.
--
--   ¬ ONE-SIDED FAILS: `Œ¶‚ø true ‚â° true` for every `n`, so `false` is
--     reachable from nothing.  `‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡ tt` is refuted outright.
--
-- Therefore `SamanaKaksya` ¬ß‡'s "is exactly `Kaksya` ¬ß‡'s `‡‡ô‡‡ï‡‡∞‡Æ‡‡Æ‡`"
-- is false as an identification, and ¬ß‡®‚ì¬ß‡ above give the hypothesis
-- that is exact.  The flow here is not invertible, and that is not
-- incidental: it is what lets a point be departed from and never
-- returned to.
------------------------------------------------------------------------

private

  Œ¶‚ÇÄ : Bool ‚Üí Bool
  Œ¶‚ÇÄ _ = true

  f‚ÇÄ : Bool ‚Üí Unit
  f‚ÇÄ _ = tt

  cons‚ÇÄ : ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f‚ÇÄ Œ¶‚ÇÄ
  cons‚ÇÄ _ = refl

  -- every station of every trajectory is `true` from step one on
  ‡§∏‡•ç‡§•‡§ø‡§∞‡§Æ‡•ç : (n : ‚Ñï) (a : Bool) ‚Üí ‡§ï‡§ï‡•ç‡§∑‡•ç‡§Ø‡§æ f‚ÇÄ Œ¶‚ÇÄ (suc n) a ‚â° true
  ‡§∏‡•ç‡§•‡§ø‡§∞‡§Æ‡•ç n a = refl

  -- TWO-SIDED: any two points of the single fibre meet at (1 , 1)
  ‡§â‡§≠‡§Ø‡§Æ‡•ç-‡§Ö‡§∏‡•ç‡§§‡§ø : (b : Unit) ‚Üí ‡§â‡§≠‡§Ø-‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç f‚ÇÄ Œ¶‚ÇÄ b
  ‡§â‡§≠‡§Ø‡§Æ‡•ç-‡§Ö‡§∏‡•ç‡§§‡§ø b x y = ‚à£ suc zero , suc zero , refl ‚à£‚ÇÅ

  -- and hence the descended charge is an equivalence
  ‡§Ö‡§µ‡§§‡•Ä‡§∞‡•ç‡§£‡§É-‡§∏‡§Æ‡§§‡§æ‚ÇÄ : isEquiv (‡§Ö‡§µ‡§§‡•Ä‡§∞‡•ç‡§£‡§É f‚ÇÄ Œ¶‚ÇÄ isSetUnit cons‚ÇÄ)
  ‡§Ö‡§µ‡§§‡•Ä‡§∞‡•ç‡§£‡§É-‡§∏‡§Æ‡§§‡§æ‚ÇÄ =
    invEq (‡§Ö‡§µ‡§§‡•Ä‡§∞‡•ç‡§£‡§É-‡§∏‡§Æ‡§§‡§æ f‚ÇÄ Œ¶‚ÇÄ isSetUnit cons‚ÇÄ)
      ( (Œª b ‚Üí ‚à£ true , refl ‚à£‚ÇÅ) , ‡§â‡§≠‡§Ø‡§Æ‡•ç-‡§Ö‡§∏‡•ç‡§§‡§ø )

  -- ONE-SIDED: refuted.  `false` is reachable from `true` at no station.
  ‡§è‡§ï‡§™‡§æ‡§∞‡•ç‡§∂‡•ç‡§µ‡§Ç-‡§®‡§æ‡§∏‡•ç‡§§‡§ø : ‡§∏‡§ô‡•ç‡§ï‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç f‚ÇÄ Œ¶‚ÇÄ tt ‚Üí ‚ä•
  ‡§è‡§ï‡§™‡§æ‡§∞‡•ç‡§∂‡•ç‡§µ‡§Ç-‡§®‡§æ‡§∏‡•ç‡§§‡§ø tr with tr (true , refl) (false , refl)
  ... | zero  , p = true‚â¢false p
  ... | suc n , p = true‚â¢false (sym (‡§∏‡•ç‡§•‡§ø‡§∞‡§Æ‡•ç n true) ‚àô p)

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡ ‚î what stays open.
--
-- **The truncation is not shown to be necessary.**  ¬ß‡ produces
-- `‚à a ‚âà b ‚à‚` because that is all `isEquivRel‚íTruncIso` gives.  Whether
-- some flow makes the untruncated statement fail ‚î two points whose
-- classes agree but with no CHOSEN pair of meeting stations ‚î is not
-- settled here.  `SamanaKaksya` ¬ß‡'s last paragraph is the same
-- question and it is still open.
--
-- **Sufficient conditions are not surveyed.**  ¬ß‡ reduces "the fibre is
-- one orbit" to a checkable hypothesis but does not exhibit a family of
-- flows satisfying it beyond ¬ß‡'s collapse and the one-sided case.  The
-- torsor of `YogaDhruva_‚¶agda` is the natural next instance: a free
-- transitive action gives one-sided reachability by construction, hence
-- ¬ß‡®'s implication, hence ¬ß‡©.  Whether it gives it with `Œ¶` a single
-- endomorphism ‚î rather than a whole group ‚î is the actual question,
-- and iterating ONE translation on a torsor is a cyclic-subgroup
-- condition, not a torsor condition.  Not addressed.
--
-- **Nothing here is about the h-level of `A`.**  `A` is never assumed to
-- be a set; `isSet B` is used only where `SamanaKaksya` ¬ß‡ used it, plus
-- once in `injEmbedding`.
------------------------------------------------------------------------
