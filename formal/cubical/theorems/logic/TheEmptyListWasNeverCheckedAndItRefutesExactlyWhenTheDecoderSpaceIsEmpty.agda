{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheEmptyListWasNeverCheckedAndItRefutesExactlyWhenTheDecoderSpaceIsEmpty
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- The audited module belongs to the standing à²à¾à˜àµ (lghava) thread and
-- names its sites ààµà•àààµàà¯ (avaktavya), àà¨ààµààààà¿ (anuvtti),
-- ààà°ààà¯à¾àà¾à° (pratyhra), àààµà¾à¦ (apavda) â” Jaina and Pinian terms
-- respectively, and **the school is named before the term** as the
-- naming rule requires.  This module touches none of that material: its
-- subject is the LIST-LENGTH bookkeeping of a measure defined in that
-- module, for which no tradition term exists and inventing one would
-- assert a provenance nobody checked.  Checked before naming:
-- `.claude/hooks/priority-ledger.txt` (CURRENT header) and
-- first.  **No claim whatever is made about avaktavya, anuvtti,
-- pratyhra or apavda.**
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE AUDIT.  `WitnessNumberIsTwo` defines a measure â”
-- the least list of points on which no decoder survives â” and concludes
--
--   "so the witness number at any collision site is **exactly 2**:
--    2 suffices (above) and 1 does not (Â§3)"
--
-- with `collision-witness-number-2` pairing `Refutes â¦ (x âˆ x' âˆ [])`
-- against `(z : X) â’ Â Refutes â¦ (z âˆ [])`.
--
-- **A LEAST OVER LIST LENGTHS HAS THREE CASES BELOW 3, AND ONLY TWO
-- WERE CHECKED.**  Lengths 2 and 1 are settled; **length 0 is not
-- mentioned anywhere on the line.**  That is not pedantry, because the
-- definition does not make it vacuous:
--
--     AllHold law d []  =  Unit*
--     Refutes law []    =  (d : D) â’ Â Unit*
--
-- so `Refutes law []` is `Â D` up to the unit â” **the empty list
-- refutes exactly when the DECODER SPACE IS EMPTY.**  Â§1 proves both
-- directions; Â§3 exhibits an inhabited instance at `D = âŠ`, where the
-- witness number is 0 and not 2.
--
-- WHAT IS PROVED
--
--   nilRefutesGivesNoDecoder / noDecoderGivesNilRefutes
--        the two directions.  Neither needs anything of `law`, `X` or
--        the universes â” `law` is not even applied, which is the point:
--        at length 0 the measure stops seeing the law at all
--   aDecoderKeepsTheEmptyListSilent
--        the usable form: any `d : D` refutes the refutation
--   factorLawEmptyNeverRefutes
--        and at the audited module's own `factorLaw`, ONE point of `X`
--        supplies the decoder (`Î» _ â’ t x`), exactly as
--        `singleton-never-refutes` does â” so on that line the gap is
--        closable, and closing it is this
--   collisionWitnessNumberIsTwoAtAllThreeLengths
--        the audited conclusion with its third case attached
--   witnessNumberZeroIsAttained
--        at `D = âŠ` the empty list refutes for EVERY law, so "the
--        answer is 2 everywhere" is a statement about lines with
--        inhabited decoder spaces, and that hypothesis was silent
--
-- **WHAT THIS SAYS ABOUT THE MEASURE, AND IT IS THE FINDING.**  The
-- audited module's own Â§6 diagnoses its two predecessors: *"a quantity
-- was named before a measure was fixed."*  The measure IS fixed here,
-- and the residue is subtler â” **a minimum was reported without its
-- whole range being examined.**  Length 0 is where the measure degrades
-- from a fact about the obstruction to a fact about the decoder space,
-- which is precisely the distinction that module's own closing lines
-- draw ("both bounds are properties of the DECODER SPACE and neither is
-- a property of the mathematics obstructed").  The omitted case is the
-- extreme point of the distinction it had already found.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheEmptyListWasNeverCheckedAndItRefutesExactlyWhenTheDecoderSpaceIsEmpty where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Relation.Nullary using (Â¬_)

open import WitnessNumberIsTwo
  using (AllHold ; Refutes ; factorLaw ; singleton-never-refutes
        ; collisionâ†’refutes)

private
  variable
    â„“ â„“d â„“x â„“y â„“t : Level

------------------------------------------------------------------------
-- 1.  At length 0 the measure sees the decoder space and nothing else
------------------------------------------------------------------------

nilRefutesGivesNoDecoder :
  {D : Type â„“d} {X : Type â„“x} (law : D â†’ X â†’ Type â„“)
  â†’ Refutes law [] â†’ Â¬ D
nilRefutesGivesNoDecoder law ref d = ref d tt*

noDecoderGivesNilRefutes :
  {D : Type â„“d} {X : Type â„“x} (law : D â†’ X â†’ Type â„“)
  â†’ Â¬ D â†’ Refutes law []
noDecoderGivesNilRefutes law noD d = âŠ¥.rec (noD d)

aDecoderKeepsTheEmptyListSilent :
  {D : Type â„“d} {X : Type â„“x} (law : D â†’ X â†’ Type â„“)
  â†’ D â†’ Â¬ Refutes law []
aDecoderKeepsTheEmptyListSilent law d ref = ref d tt*

------------------------------------------------------------------------
-- 2.  On the audited line the gap closes, from one point of X
------------------------------------------------------------------------

factorLawEmptyNeverRefutes :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (q : X â†’ Y) (t : X â†’ T) (x : X)
  â†’ Â¬ Refutes (factorLaw q t) []
factorLawEmptyNeverRefutes q t x =
  aDecoderKeepsTheEmptyListSilent (factorLaw q t) (Î» _ â†’ t x)

collisionWitnessNumberIsTwoAtAllThreeLengths :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (q : X â†’ Y) (t : X â†’ T) {x x' : X}
  â†’ q x â‰¡ q x' â†’ Â¬ (t x â‰¡ t x')
  â†’ Refutes (factorLaw q t) (x âˆ· x' âˆ· [])
  Ã— ((z : X) â†’ Â¬ Refutes (factorLaw q t) (z âˆ· []))
  Ã— (Â¬ Refutes (factorLaw q t) [])
collisionWitnessNumberIsTwoAtAllThreeLengths q t {x = x} same differ =
    collisionâ†’refutes q t same differ
  , singleton-never-refutes q t
  , factorLawEmptyNeverRefutes q t x

------------------------------------------------------------------------
-- 3.  â¦and the omitted case is inhabited, so the hypothesis was real
------------------------------------------------------------------------

witnessNumberZeroIsAttained :
  {X : Type â„“x} (law : âŠ¥ â†’ X â†’ Type â„“) â†’ Refutes law []
witnessNumberZeroIsAttained law = noDecoderGivesNilRefutes law (Î» e â†’ e)
