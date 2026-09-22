{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ProvenanceIsCarriedAndNeverConsumedSoFreeWasDoingDoubleDuty
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- TWO SENSES OF `free` IN THE FOUR COMPONENTS OF
-- `ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem`.
--
--   DERIVABLE-FREE.  Boundary preservation composes by `‚àô`, migration by
--   function composition.  Each is a real obligation discharged by a
--   real operation; there is something to prove and the proof is one
--   symbol.
--
--   VACUOUSLY FREE.  Provenance is `List Prov` with NO condition
--   anywhere.  It composes by `++` because nothing constrains it ‚î
--   including `++` itself.  ¬ß2 below proves the sharp form: **any
--   certificate's provenance may be REPLACED BY THE EMPTY LIST and the
--   result is still a certificate.**  So no theorem downstream can ever
--   recover a step from it.
--
-- Those are opposite situations wearing one word.
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   len / lenAppend    length is additive over `++`, by induction ‚î
--                      v0.5's `Cubical.Data.List.Properties` has
--                      `length-map` but no `length-++`, so it is proved
--                      here rather than assumed
--   provenanceLengthIsAdditive
--                      composing certificates adds provenance lengths.
--                      This is the ONLY thing provenance satisfies.
--   provenanceMayBeDiscarded
--                      and it satisfies nothing else: `(s , i , m , _)`
--                      ‚¶ `(s , i , m , [])` is a certificate for the
--                      same pair.  **This is the proof that `free` meant
--                      `vacuous` here**, and it is the whole finding
--   provenanceIsNotDeterminedByTheOtherThree
--                      immediately: two certificates for the same pair
--                      agreeing on the first three components and
--                      differing on the fourth
------------------------------------------------------------------------

module ProvenanceIsCarriedAndNeverConsumedSoFreeWasDoingDoubleDuty where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_)
open import Cubical.Data.List using (List ; [] ; _‚à∑_ ; _++_)
open import Cubical.Data.Sigma using (_√ó_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬¨_)

open import ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem
  using (Certified ; composeCertified)

------------------------------------------------------------------------
-- 1.  Length, and its additivity ‚î v0.5 ships neither
------------------------------------------------------------------------

len : {‚Ñì : Level} {A : Type ‚Ñì} ‚Üí List A ‚Üí ‚Ñï
len []       = zero
len (_ ‚à∑ xs) = suc (len xs)

lenAppend :
  {‚Ñì : Level} {A : Type ‚Ñì} (xs ys : List A)
  ‚Üí len (xs ++ ys) ‚â° len xs + len ys
lenAppend []       ys = refl
lenAppend (x ‚à∑ xs) ys = cong suc (lenAppend xs ys)

------------------------------------------------------------------------
-- 2.  What provenance satisfies, and what it does not
------------------------------------------------------------------------

module _ {Sys B Prov : Type}
         (sem  : Sys ‚Üí B)
         (cost : Sys ‚Üí List ‚Ñï)
         (M    : Sys ‚Üí Type)
  where

  -- `Prov` is implicit in `Certified` and appears only in its fourth
  -- component, so no application determines it.  Fixing it once here is
  -- what makes every statement below have a type at all ‚î and it is a
  -- small instance of the same point: the provenance type is so
  -- unconstrained that the elaborator cannot find it either.
  Cert : Sys ‚Üí Sys ‚Üí Type
  Cert = Certified {Prov = Prov} sem cost M

  prov : {d e : Sys} ‚Üí Cert d e ‚Üí List Prov
  prov c = snd (snd (snd c))

  ----------------------------------------------------------------------
  -- 2a.  The one law it has: composition adds lengths
  ----------------------------------------------------------------------

  provenanceLengthIsAdditive :
    (d e f : Sys) (c‚ÇÅ : Cert d e) (c‚ÇÇ : Cert e f)
    ‚Üí len (prov (composeCertified sem cost M d e f c‚ÇÅ c‚ÇÇ))
      ‚â° len (prov c‚ÇÅ) + len (prov c‚ÇÇ)
  provenanceLengthIsAdditive d e f c‚ÇÅ c‚ÇÇ = lenAppend (prov c‚ÇÅ) (prov c‚ÇÇ)

  ----------------------------------------------------------------------
  -- 2b.  And the one it does not have: it may simply be thrown away
  ----------------------------------------------------------------------

  provenanceMayBeDiscarded : (d e : Sys) ‚Üí Cert d e ‚Üí Cert d e
  provenanceMayBeDiscarded d e (s , i , m , _) = (s , i , m , [])

  provenanceIsNotDeterminedByTheOtherThree :
    (d e : Sys) (c : Cert d e) (p : List Prov)
    ‚Üí Œ£[ c‚Ä≤ ‚àà Cert d e ]
        ( (fst c‚Ä≤ ‚â° fst c)
        √ó (fst (snd c‚Ä≤) ‚â° fst (snd c))
        √ó (fst (snd (snd c‚Ä≤)) ‚â° fst (snd (snd c)))
        √ó (prov c‚Ä≤ ‚â° p) )
  provenanceIsNotDeterminedByTheOtherThree d e (s , i , m , _) p =
    (s , i , m , p) , refl , refl , refl , refl
