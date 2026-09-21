{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TritiyaMarga â” ààààà¯à‹ à®à¾à°àà—à‹ à¨ àµà¿à¦àà¯àà â” WHAT PATH TWO ACTUALLY COSTS.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- PRIOR ART IN THIS REPOSITORY, READ FIRST AND NOT RESTATED
--
-- them are already checked in this lane and this module cites rather
-- than repeats:
--
--   * `Nasti_ShabdeJivahVartante` and
--     `Samkramana_TransportCarriesStructureAndTruncationâ¦` â” path one:
--     `uaÎ²`, and that transport carries STRUCTURE and not only points.
--   * `Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis`,
--     Â§ààààà¯à-à®à¾à°àà—à â” that DECIDING "path one or not path one",
--     `isEquiv f âŠ Â isEquiv f`, is exactly excluded middle; and
--     `à¦à‹àà²àà–à-ààà°ààà`, that the fibre family of a map is a complete
--     record of it.
--
-- That module's prose then names, without proving it, the step this one
-- is about:
--
--     *"passing from `Â (âˆ b â’ isContr (fiber f b))` to
--       `Î[ b âˆˆ B ] Â isContr (fiber f b)` is exactly the classical
--       step, and a defect you cannot exhibit a SITE for is not written
--       down."*
--
-- "Exactly the classical step" is an estimate.  It is not exact, and the
-- true answer is strictly weaker â” and therefore sharper â” than
-- excluded middle.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE FINDING
--
--   Refuting path one is NOT the same act as writing path two, and the
--   distance between them costs AT LEAST **Markov.s Principle** (Â§2).
--
--   Not excluded middle.  MP is strictly weaker, and neither is
--   available in this `--safe` cubical lane.  So the stra's second path
--   is not merely "the other case".  It requires an unbounded SEARCH
--   that terminates, and knowing that it terminates is not knowing
--   where.
--
--   And LEM does not repair this (Â§3): with excluded middle in hand what
--   you obtain is `âˆ Defect f âˆâ`, the mere existence of a defect, which
--   by Â§4 has no retraction onto `Defect f`.  Ï½ ½ÏÎ Î¼ÎÎ½ÎµÎ Â Ï½ ÏÎ¯
--   ¼ÏÏÎ»Î»ÏÏÎÎ â” the THAT survives, the WHICH perishes, and Â§à of the
--   same stra says such a perishing is irreparable.
--
--   Therefore **à¦à‹àà‹ à²à¿à–àà¯àà is an imperative and cannot be read as an
--   indicative.**  Nothing in the logic hands you the written defect.
--   An author does, by searching until the site is found â” which is the
--   à•ààŸààŸà• discipline of Â§à§à of the same text (*à¯àà à¨ àµà¿àààà ààà
--   à°à•àààà¯àà*: keep the remainder and recurse on it), and not a logical
--   principle at all.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS CHECKED
--
--   Â§1  `Defect`            path two as DATA: a named site, plus the
--                           refutation that its fibre is contractible.
--                           Deliberately not `Â isEquiv f`; Â§2â“Â§4 are
--                           the reason that distinction is not pedantry.
--       `defectâ’ÂisEquiv`   the easy direction, unconditionally.
--
--   Â§2  `Writable`          "every non-equivalence has a written
--                           defect" â” the reading of Â§à that treats
--                           à¦à‹àà²àà–à as available rather than owed.
--       `writableâ’MP`       it implies Markov's Principle.  Hence it is
--                           not provable here, and every appeal to it is
--                           an assumption that now has a name.
--
--   Â§3  `lemâ’truncatedOnly` excluded middle yields only `âˆ Defect f âˆâ`.
--
--   Â§4  `noRetraction`      a type with two distinct points has no
--                           retraction from its truncation (the stra's
--                           Â§à, stated once, generally);
--       `defectIsTwoValued` a concrete `fâ` whose `Defect fâ` has two
--                           distinct points;
--       `truncatedDefectIsNotWritable`
--                           so Â§3's output cannot become Â§1's input.
--
-- `--safe`, no postulates, no holes.  `Writable`, `MP` and `LEM` occur
-- only as HYPOTHESES of theorems; nothing here assumes any of them.
--
-- ORIGIN OF THE MATHEMATICS, stated rather than laundered.  `fiberEquiv`
-- is HoTT Lemma 4.8.1 and comes from the cubical library.  Markov's
-- Principle is A. A. Markov Jr.'s, from the Russian constructivist
-- school (c. 1954); it is named for him because it is his, and no
--  label is invented for it here.  The truncation argument in Â§4
-- is the stra's own Â§à, generalised off `Bool`.  What is new is only
-- the identification of the stra's second path with MP, and that is a
-- short reduction once the test family is chosen.
------------------------------------------------------------------------

module TritiyaMarga_TheWrittenDefectCostsMarkovsPrinciple where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (isEquiv ; equiv-proof ; fiber ; invEquiv ; _â‰ƒ_)
open import Cubical.Foundations.HLevels
  using (inhPropâ†’isContr ; isOfHLevelRespectEquiv)

open import Cubical.Functions.Fibration using (fiberEquiv)

open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_âŠ_ ; inl ; inr)
open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.Bool using (Bool ; true ; false ; trueâ‰¢false)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)

open import Cubical.Relation.Nullary
  using (Â¬_ ; Dec ; yes ; no ; Decâ†’Stable ; isPropÂ¬)

open import Cubical.HITs.PropositionalTruncation
  using (âˆ¥_âˆ¥â‚ ; âˆ£_âˆ£â‚ ; squashâ‚ ; isPropPropTrunc)

private
  variable
    â„“ : Level

------------------------------------------------------------------------
-- Â§1.  Path two, as data.
--
-- `à¦à‹àà‹ à²à¿à–àà¯àà` â” the defect is WRITTEN.  A written defect names the
-- site: you can project out the `b`.  `Â isEquiv f` names nothing; it is
-- a refutation, and a refutation is not a document.
------------------------------------------------------------------------

Defect : {A B : Type â„“} â†’ (A â†’ B) â†’ Type â„“
Defect {B = B} f = Î£[ b âˆˆ B ] (Â¬ isContr (fiber f b))

-- The easy half, and the only half that is free: a written defect does
-- refute path one.  à¦ààµà à®à¾à°àà—à are exclusive.
defectâ†’Â¬isEquiv : {A B : Type â„“} (f : A â†’ B) â†’ Defect f â†’ Â¬ isEquiv f
defectâ†’Â¬isEquiv f (b , nc) e = nc (e .equiv-proof b)

------------------------------------------------------------------------
-- Â§2.  THE CONVERSE COSTS AT LEAST MARKOV.S PRINCIPLE.
--
-- What is proved below is `writableâ’MP` and only that: Writable âŸ MP.
-- That is a LOWER BOUND -- writing defects costs AT LEAST MP -- and it
-- is not an identification.  `Apoha` carries `MPâ’Witnessed` AND
-- `Witnessed’MP`, and `FalsifierAsymmetry` cites that pair; so
-- "precisely Markov.s Principle" is a true sentence about `Witnessed`.
-- `Writable` is not `Witnessed`: it quantifies over all types and all
-- maps and returns a defect SITE, where that biconditional is about a
-- decidable sequence.  Path two is not merely "the other case", it
-- costs a terminating unbounded search, and LEM does not repair that
-- (Â§3).
--
-- The test family is the projection out of a decidable subset of â•.
-- For `Î : â• â’ Bool`, put
--
--     Q n = Â (Î n â‰¡ true)          (a decidable proposition)
--     f   = fst : (Î â• Q) â’ â•
--
-- HoTT 4.8.1 gives `fiber f n â‰ Q n`, so the fibre over `n` is
-- contractible exactly when `Q n` holds.  Then
--
--     f is an equivalence      âŸº  Î is never `true`
--     a WRITTEN defect at n    âŸ  Î n is `true`
--
-- so turning "not an equivalence" into a written defect is precisely
-- turning "Î is not never-true" into a witness.  That is MP.
------------------------------------------------------------------------

MP : Typeâ‚€
MP = (Î± : â„• â†’ Bool)
   â†’ Â¬ ((n : â„•) â†’ Â¬ (Î± n â‰¡ true))
   â†’ Î£[ n âˆˆ â„• ] (Î± n â‰¡ true)

-- The reading of Â§à: that path two is AVAILABLE whenever
-- path one fails, rather than OWED by whoever failed to transport.
Writable : Typeâ‚
Writable = {A B : Typeâ‚€} (f : A â†’ B) â†’ Â¬ isEquiv f â†’ Defect f

private
  module Test (Î± : â„• â†’ Bool) where

    Q : â„• â†’ Typeâ‚€
    Q n = Â¬ (Î± n â‰¡ true)

    fÎ± : Î£[ n âˆˆ â„• ] Q n â†’ â„•
    fÎ± = fst

    Qâ†’fibContr : (n : â„•) â†’ Q n â†’ isContr (fiber fÎ± n)
    Qâ†’fibContr n q =
      isOfHLevelRespectEquiv 0 (invEquiv (fiberEquiv Q n))
        (inhPropâ†’isContr q (isPropÂ¬ (Î± n â‰¡ true)))

    fibContrâ†’Q : (n : â„•) â†’ isContr (fiber fÎ± n) â†’ Q n
    fibContrâ†’Q n c = fst (fiberEquiv Q n) (fst c)

    decTrue : (n : â„•) â†’ Dec (Î± n â‰¡ true)
    decTrue n with Î± n
    ... | true  = yes refl
    ... | false = no (Î» p â†’ trueâ‰¢false (sym p))

open Test using (fÎ± ; Qâ†’fibContr ; fibContrâ†’Q ; decTrue)

writableâ†’MP : Writable â†’ MP
writableâ†’MP W Î± h = n , Decâ†’Stable (decTrue Î± n) Â¬Â¬Î±n
  where
    Â¬equiv : Â¬ isEquiv (fÎ± Î±)
    Â¬equiv e = h (Î» m â†’ fibContrâ†’Q Î± m (e .equiv-proof m))

    d : Defect (fÎ± Î±)
    d = W (fÎ± Î±) Â¬equiv

    n : â„•
    n = fst d

    Â¬Â¬Î±n : Â¬ Â¬ (Î± n â‰¡ true)
    Â¬Â¬Î±n q = snd d (Qâ†’fibContr Î± n q)

------------------------------------------------------------------------
-- Â§3.  Excluded middle gives back only the truncation.
--
-- LEM decides PROPOSITIONS.  `Defect f` is not one â” it is a type of
-- documents, and Â§4 shows it genuinely carries more than one.  So the
-- most LEM can return is `âˆ Defect f âˆâ`, and that is what it returns.
------------------------------------------------------------------------

LEM : (â„“ : Level) â†’ Type (â„“-suc â„“)
LEM â„“ = (P : Type â„“) â†’ isProp P â†’ P âŠ (Â¬ P)

lemâ†’truncatedOnly : LEM â„“ â†’ {A B : Type â„“} (f : A â†’ B)
                  â†’ isEquiv f âŠ âˆ¥ Defect f âˆ¥â‚
lemâ†’truncatedOnly lem {B = B} f with lem (âˆ¥ Defect f âˆ¥â‚) isPropPropTrunc
... | inl t  = inr t
... | inr nt = inl (record { equiv-proof = allContr })
  where
    allContr : (b : B) â†’ isContr (fiber f b)
    allContr b with lem (isContr (fiber f b)) isPropIsContr
    ... | inl c = c
    ... | inr n = âŠ¥.rec (nt âˆ£ b , n âˆ£â‚)

------------------------------------------------------------------------
-- Â§4.  And the truncation cannot be un-truncated.
--
-- Â§à of the stra proves this for `Bool`.  The argument needs only two
-- distinct points, so it is stated once, generally, and then applied to
-- `Defect fâ` â” closing the loop: Â§3's output is not Â§1's input, and not
-- because the conversion is hard.  à¨à¾àààà¿ à
------------------------------------------------------------------------

Retraction : Type â„“ â†’ Type â„“
Retraction D = Î£[ r âˆˆ (âˆ¥ D âˆ¥â‚ â†’ D) ] ((d : D) â†’ r âˆ£ d âˆ£â‚ â‰¡ d)

noRetraction : {D : Type â„“} (x y : D) â†’ Â¬ (x â‰¡ y) â†’ Â¬ Retraction D
noRetraction x y xâ‰¢y (r , s) =
  xâ‰¢y (sym (s x) âˆ™âˆ™ cong r (squashâ‚ âˆ£ x âˆ£â‚ âˆ£ y âˆ£â‚) âˆ™âˆ™ s y)

-- the empty map into `Bool`: a defect at every site, and two sites.
fâ‚€ : âŠ¥ â†’ Bool
fâ‚€ ()

noFibre : (b : Bool) â†’ Â¬ isContr (fiber fâ‚€ b)
noFibre b c = âŠ¥.rec (c .fst .fst)

defectIsTwoValued : Î£[ x âˆˆ Defect fâ‚€ ] Î£[ y âˆˆ Defect fâ‚€ ] (Â¬ (x â‰¡ y))
defectIsTwoValued =
    (true , noFibre true)
  , (false , noFibre false)
  , Î» p â†’ trueâ‰¢false (cong fst p)

truncatedDefectIsNotWritable : Â¬ Retraction (Defect fâ‚€)
truncatedDefectIsNotWritable =
  noRetraction (defectIsTwoValued .fst)
               (defectIsTwoValued .snd .fst)
               (defectIsTwoValued .snd .snd)

------------------------------------------------------------------------
-- WHAT THIS DOES NOT SAY
--
-- Not that Â§à is wrong.  Its first sentence is proved elsewhere in this
-- lane and its second is exactly right â” as an OBLIGATION.  What is
-- removed is the right to read its third sentence as a description of
-- how maps are, and with it the habit of treating "well, then there is a
-- defect" as though the defect were thereby in hand.
--
--   ààà¯à¾àà â” in the respect of what an AUTHOR owes: two paths, no third.
--            Transport, or search until the site is found and write it.
--   ààà¯à¾àà â” in the respect of what is PROVABLE of an arbitrary map: no
--            dichotomy at all.  Asserting one assumes MP (Â§2); even
--            assuming LEM buys only the mere existence (Â§3), which is
--            not the document (Â§4).
--
-- Two à¨à¯s; neither denies the other.  Collapsing them into one
-- indicative sentence is the à¦àà°àà¨à¯ of Â§à¨ of the same text â” a
-- standpoint asserting itself as the whole.
------------------------------------------------------------------------
