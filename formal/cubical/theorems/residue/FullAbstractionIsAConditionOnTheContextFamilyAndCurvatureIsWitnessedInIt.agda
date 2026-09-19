{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FullAbstractionIsAConditionOnTheContextFamilyAndCurvatureIsWitnessedInIt
--
-- ON THE NAME.  Contextual equivalence and full abstraction are
-- Milner's and Plotkin's (1977); there is no Indian source term for
-- them and none is invented, per CLAUDE.md's naming guard.  Checked
-- `.claude/hooks/priority-ledger.txt` and
-- `.claude/hooks/european-frame.txt` before naming; no row applies and
-- the frame check does not fire on a module with no Indian material.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
--   "**Theorem 28.14 (flat compression):** fully abstract compression
--    for all arising contexts preserves semantics for every order.
--    Curvature arises only from too-small context families,
--    approximation, dropped witnesses, or incoherent interface
--    updates."
--
-- and the curvature module already in this corpus recorded the gap:
-- "**Theorem 28.14 is not formalised** ‚î full abstraction is a
-- condition on the context *family*, and no context family appears."
--
-- A context family appears here, and with it the theorem.
--
-- WHAT IS PROVED
--
--   CtxEq p q        contextual equivalence RELATIVE TO A FAMILY: the
--                    family is a type `K` of indices with `ctxOf :
--                    K ‚í Ctx`, so "too small" and "all arising" are
--                    both expressible, which is the whole point
--   FullyAbstract C  the compression identifies whatever the family
--                    cannot separate
--   flatCompressionPreservesEveryOrder
--                    **Theorem 28.14**: if two elimination orders are
--                    contextually equivalent at every input, a fully
--                    abstract compression sends them to the SAME value
--                    ‚î "for every order" being an arbitrary pair of
--                    composites, not two fixed steps
--   curvatureIsWitnessedInTheFamily
--                    the contrapositive, and the sharper reading of
--                    ¬ß36‚ì38's causal list: if the images differ, the
--                    family already separates the two orders
--   curvatureExhibitsAContext
--                    and when the family is ENUMERATED and the
--                    observation type is DISCRETE, the separating
--                    context can be produced ‚î a Œ, not a double
--                    negation
--
-- **WHY THE FAMILY BEING A PARAMETER IS THE CONTENT.**  ¬ß36‚ì38 blames
-- curvature on "too-small context families" without a family in the
-- statement; once `K` is a parameter, "fully abstract for all arising
-- contexts" and "fully abstract for a small family" are the SAME
-- theorem at different `K`, and the difference in conclusion is
-- visible: a smaller `K` makes `CtxEq` easier, hence `FullyAbstract`
-- harder, hence the hypothesis of 28.14 stronger.  The note's causal
-- claim is, in this reading, the observation that shrinking `K` breaks
-- the hypothesis ‚î not that it creates curvature by some other route.
--
-- **AND THE WITNESS COSTS EXACTLY WHAT IT COST ON THE FOURTH-CORNER
-- LINE.**  `curvatureIsWitnessedInTheFamily` gives `¬ CtxEq`, a double
-- negation; turning it into a context needs the same two hypotheses
-- that line found ‚î enumerability of the index and decidability of the
-- observation ‚î through the same lemma, `decŒOverEnumerated`.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 ‚î NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module FullAbstractionIsAConditionOnTheContextFamilyAndCurvatureIsWitnessedInIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Empty as ‚ä• using (‚ä•)
open import Cubical.Relation.Nullary
  using (¬¨_ ; Dec ; yes ; no ; Discrete ; Dec‚ÜíStable)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Enumerated ; decŒ£OverEnumerated)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (decNeg)

module _ {Tm O : Type} (Ctx : Type) (plug : Ctx ‚Üí Tm ‚Üí Tm) (obs : Tm ‚Üí O)
         (K : Type) (ctxOf : K ‚Üí Ctx)
  where

  ------------------------------------------------------------------
  -- 1.  Contextual equivalence, relative to the family
  ------------------------------------------------------------------

  CtxEq : Tm ‚Üí Tm ‚Üí Type
  CtxEq p q = (k : K) ‚Üí obs (plug (ctxOf k) p) ‚â° obs (plug (ctxOf k) q)

  module _ {D : Type} (C : Tm ‚Üí D) where

    FullyAbstract : Type
    FullyAbstract = (p q : Tm) ‚Üí CtxEq p q ‚Üí C p ‚â° C q

    ----------------------------------------------------------------
    -- 2.  Theorem 28.14
    ----------------------------------------------------------------

    flatCompressionPreservesEveryOrder :
      FullyAbstract ‚Üí (r‚ÇÅ r‚ÇÇ : Tm ‚Üí Tm)
      ‚Üí ((p : Tm) ‚Üí CtxEq (r‚ÇÅ p) (r‚ÇÇ p))
      ‚Üí (p : Tm) ‚Üí C (r‚ÇÅ p) ‚â° C (r‚ÇÇ p)
    flatCompressionPreservesEveryOrder fa r‚ÇÅ r‚ÇÇ eqv p = fa (r‚ÇÅ p) (r‚ÇÇ p) (eqv p)

    ----------------------------------------------------------------
    -- 3.  Curvature is separation inside the family
    ----------------------------------------------------------------

    curvatureIsWitnessedInTheFamily :
      FullyAbstract ‚Üí (p q : Tm) ‚Üí ¬¨ (C p ‚â° C q) ‚Üí ¬¨ CtxEq p q
    curvatureIsWitnessedInTheFamily fa p q ¬¨eq ce = ¬¨eq (fa p q ce)

    curvatureExhibitsAContext :
      Enumerated K ‚Üí Discrete O ‚Üí FullyAbstract
      ‚Üí (p q : Tm) ‚Üí ¬¨ (C p ‚â° C q)
      ‚Üí Œ£[ k ‚àà K ] ¬¨ (obs (plug (ctxOf k) p) ‚â° obs (plug (ctxOf k) q))
    curvatureExhibitsAContext en dO fa p q ¬¨eq
      with decŒ£OverEnumerated en
             (Œª k ‚Üí ¬¨ (obs (plug (ctxOf k) p) ‚â° obs (plug (ctxOf k) q)))
             (Œª k ‚Üí decNeg (dO (obs (plug (ctxOf k) p))
                               (obs (plug (ctxOf k) q))))
    ... | yes w  = w
    ... | no ¬¨w  =
      ‚ä•.rec (curvatureIsWitnessedInTheFamily fa p q ¬¨eq
              (Œª k ‚Üí Dec‚ÜíStable
                       (dO (obs (plug (ctxOf k) p)) (obs (plug (ctxOf k) q)))
                       (Œª ¬¨e ‚Üí ¬¨w (k , ¬¨e))))

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  Recording site: commit ae3c3d00,
-- `AbhihitanvayaAnvitabhidhana_TheTypeOfTheSemanticsAlreadyTakesASideAndSoundnessIsFreeOnOneOfThem`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin).
--
-- **THE OMISSION.**  Everything above states ONE implication ‚î
-- `CtxEq p q ‚í C p ‚â° C q` ‚î and the ¬ß"SYT ‚î THE CLAIM, EXACTLY" above does
-- not list the CONVERSE among what is missing.  It should have.  The
-- section names a term language, contexts, compression, "arising",
-- approximation, dropped witnesses, incoherent updates and holonomy,
-- and omits the one gap that was a theorem away.
--
-- **AND THE CONVERSE IS NOT A SECOND HYPOTHESIS.**  It follows from two
-- premises about `C`, by `cong` three times:
--
--   Compositional   C (plug c t) ‚â° act c (C t)
--   Factors         obs t ‚â° obsD (C t)
--
-- so `C p ‚â° C q ‚í CtxEq p q` costs no decidability, no enumerability,
-- and does not use `FullyAbstract`.  Together with `FullyAbstract` it
-- gives that `CtxEq` IS the kernel of `C`, not merely contained in it.
--
-- **WHAT THAT MAKES VISIBLE ABOUT THIS MODULE, AND IT IS THE POINT.**
-- `curvatureExhibitsAContext` above pays `Enumerated K` + `Discrete O`
-- + `FullyAbstract` to produce a separating context from `¬ (C p ‚â° C q)`.
-- The OPPOSITE direction ‚î a separating context yielding
-- `¬ (C p ‚â° C q)` ‚î is free at the recording site.  The header above
-- says the witness "costs exactly what it cost on the fourth-corner
-- line" and is right about the cost; what it could not see, having only
-- one implication, is that **the cost is not the statement's, it is the
-- DIRECTION's.**  One way is a congruence.  The other is a search.
--
-- NOTHING ABOVE IS RETRACTED.  `flatCompressionPreservesEveryOrder`,
-- `curvatureIsWitnessedInTheFamily` and `curvatureExhibitsAContext` are
-- unaltered and true as stated; `FullyAbstract` remains the right
-- hypothesis for all three.  Only the inventory of what was missing was
-- incomplete.
--
-- Also unchanged: nothing in the corpus is shown to satisfy any of
-- this.  The recording site adds three more parameters (`act`, `obsD`,
-- and `D` unchanged) and constructs nothing either.
------------------------------------------------------------------------
