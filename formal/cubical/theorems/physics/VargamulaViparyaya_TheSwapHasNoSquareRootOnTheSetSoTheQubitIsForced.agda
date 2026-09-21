{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- VargamulaViparyaya_TheSwapHasNoSquareRootOnTheSet
--                     SoTheQubitIsForced
--
-- TERMS.  ‡µ‡∞‡‡ó‡Æ‡‡≤ ¬ varga-mla ‚î "square root", the standard term of 
-- mathematics (ryabhaa, *ryabhaya*, Gaitapda, 499 CE, gives the
-- digit-by-digit ‡µ‡∞‡‡ó‡Æ‡‡≤ algorithm; Brahmagupta continues it).  ‡µ‡ø‡‡∞‡‡Ø‡Ø ¬
-- viparyaya ‚î reversal, inversion, exchange; a common word, here the swap /
-- logical NOT.  The compound ‡µ‡∞‡‡ó‡Æ‡‡≤‡µ‡ø‡‡∞‡‡Ø‡Ø ("square-root-of-inversion") and
-- ALL the mathematics below are built here, 2026-08-24, claimed of no source.
-- No source proved this theorem; what is borrowed is two words.
--
-- WHAT IS PROVED, exactly and only:  the two-element SET `Bool` has no
-- self-equivalence whose square is the swap.  `‚àNOT-does-not-exist` is a
-- closed `¬`.  Every self-equivalence `g` of Bool satisfies
-- `g (g true) ‚â° true` (`ff-true`, no case escapes), so `g ‚àò g` fixes `true`
-- while `not` moves it ‚î they cannot be equal.
--
-- WHY IT MATTERS (this is a READING of the checked term, not a further
-- claim):  the automorphism group of a finite SET is a permutation group,
-- discrete, and here `Aut Bool = S‚ = ‚/2` ‚î every element has order dividing
-- 2, so the swap (the only nontrivial element) has no square root.  ‚àNOT ‚î the
-- quantum gate whose square is NOT ‚î is exactly this missing square root.  It
-- cannot exist on the set; to hold it one must ENRICH the object, replacing
-- the 2-point set with the 2-dimensional ‚-space (a qubit), whose
-- automorphism group is the CONTINUOUS `U(2)`, in which every element has all
-- its roots ‚î ‚àNOT among them.  So the qubit is not posited; it is FORCED by
-- the set's inability to halve the swap.  The same univalence that here gives
-- only permutations (`ua notEquiv` is the NOT gate, an involution) gives,
-- over a linear enrichment, the unitaries ‚î and a unitary is precisely a
-- norm-preserving (lossless) automorphism: ahis over ‚, exactly as a
-- permutation is ahis over a set.  NONE of that ‚ / U(2) content is checked
-- here; only the impossibility that forces it.
------------------------------------------------------------------------

module VargamulaViparyaya_TheSwapHasNoSquareRootOnTheSetSoTheQubitIsForced where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Function using (_‚àò_)
open import Cubical.Data.Bool
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as ‚ä• using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

module _ (e : Bool ‚âÉ Bool) where
  private f = equivFun e

  -- an equivalence is injective: drag the equation back along the section.
  inj : (x y : Bool) ‚Üí f x ‚â° f y ‚Üí x ‚â° y
  inj x y p = sym (retEq e x) ‚àô cong (invEq e) p ‚àô retEq e y

  -- THE FIXED-POINT LEMMA.  Every self-equivalence of Bool returns `true`
  -- to `true` after two applications ‚î there is no exception, because there
  -- are only two places `f true` can go and both force it.
  ff-true : f (f true) ‚â° true
  ff-true with dichotomyBool (f true)
  ... | inl p = cong f p ‚àô p                    -- f true ‚â° true
  ... | inr p = cong f p ‚àô ‚äé‚Üí (dichotomyBool (f false))   -- f true ‚â° false
     where ‚äé‚Üí : (f false ‚â° true) ‚äé (f false ‚â° false) ‚Üí f false ‚â° true
           ‚äé‚Üí (inl r) = r
           ‚äé‚Üí (inr r) = ‚ä•.rec (false‚â¢true (inj false true (r ‚àô sym p)))

-- THE THEOREM.  No self-equivalence of the SET Bool squares to the swap.
-- Apply the supposed square-root twice to `true`: the fixed-point lemma says
-- the result is `true`, while `not true` is `false`.  true ‚â° false is absurd.
‚àöNOT-does-not-exist : ¬¨ (Œ£[ g ‚àà (Bool ‚âÉ Bool) ] (compEquiv g g ‚â° notEquiv))
‚àöNOT-does-not-exist (g , p) =
  false‚â¢true (sym (funExt‚Åª (cong equivFun p) true) ‚àô ff-true g)
