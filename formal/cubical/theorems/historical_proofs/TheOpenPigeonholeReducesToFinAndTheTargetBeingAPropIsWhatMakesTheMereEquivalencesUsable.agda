{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheOpenPigeonholeReducesToFinAndTheTargetBeingAPropIsWhatMakesTheMereEquivalencesUsable
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- The object is `TheOpenPigeonhole`, a statement I wrote down at
-- ac4ee91d about `OptimalObservation`'s own definition; there is no
-- source to cite and a fabricated  label would assert a
-- provenance nobody checked.  That module's three INSTANCES are
-- Pigala's *Chandastra* uddia (c. 300 BCE), Virahka's
-- mtrmeru (c. 600â“800) and a CRT residue decode, named here in that
-- order and before any later name; **nothing below is a claim about
-- their mathematics.**  Checked before naming:
-- `.claude/hooks/priority-ledger.txt` (CURRENT header) and
-- first.  `--guardedness` carried; infective.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE ITEM.  At ac4ee91d I proved that `Optimal X Y obs` unfolds to
-- *"`obs` is injective, AND some equivalence `X â‰ Y` exists"*, observed
-- that the second conjunct is not about `obs`, and left as a type
--
--     TheOpenPigeonhole = (X Y : FinSet â“-zero) (obs : X .fst â’ Y .fst)
--                       â’ Optimal X Y obs â’ isEquiv obs
--
-- WHAT THIS MODULE DOES, AND WHAT IT DOES NOT.  It does **not** prove
-- that statement.  It proves that the statement is **exactly** the
-- corresponding fact about `Fin`:
--
--     FinPigeonhole = (n : â•) (f : SFin n â’ SFin n) â’ Injective f
--                   â’ isEquiv f
--
--     finPigeonholeGivesTheOpenPigeonhole : FinPigeonhole â’ TheOpenPigeonhole
--
-- so the remaining content is one combinatorial fact about finite
-- ordinals, with every FinSet-level and cardinality-level ingredient
-- discharged.  Recording a reduction is not recording a proof, and the
-- header says which this is.
--
-- **AND THE STEP THAT MAKES THE REDUCTION LEGAL IS THE INTERESTING
-- ONE.**  `X` and `Y` carry only MERE equivalences to `SFin` â” `âˆâ‰cardâˆ`
-- lands in `âˆ_âˆâ`, and it must, or `card` would not be well defined.
-- An arbitrary construction cannot escape that truncation.  This one
-- can, for exactly one reason: **the goal `isEquiv obs` is a
-- proposition** (`isPropIsEquiv`), so `PT.rec2` applies and both
-- anonymous equivalences may be named at once.  Had the goal been the
-- equivalence itself â” `X .fst â‰ Y .fst`, a structure â” the same
-- argument would be blocked, and no amount of finiteness would unblock
-- it.  So the reduction is not bookkeeping: it is the observation that
-- **this particular question is truncation-stable and the neighbouring
-- one is not.**
--
-- WHAT IS PROVED
--
--   equivInjective     an equivalence's function is injective, from
--                      `retEq` â” needed because the conjugation below
--                      moves injectivity across two equivalences
--   FinPigeonhole      the residual combinatorial statement, over
--                      `Cubical.Data.SumFin`'s `Fin`, which is the one
--                      `isFinSet` is defined with (checked: FinSet.Base
--                      line 35 uses `SumFin`, not `Data.Fin`)
--   finPigeonholeGivesTheOpenPigeonhole
--                      the reduction: transport `Y`'s equivalence along
--                      `tight`, conjugate `obs` to an endo-map of
--                      `SFin (card X)`, apply the hypothesis, and
--                      transport the resulting `isEquiv` back along a
--                      `funExt` built from `retEq` twice
------------------------------------------------------------------------

module TheOpenPigeonholeReducesToFinAndTheTargetBeingAPropIsWhatMakesTheMereEquivalencesUsable where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_â‰ƒ_ ; isEquiv ; isPropIsEquiv ; invEq ; retEq ; secEq
        ; invEquiv ; compEquiv)
open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.FinSet using (FinSet ; card)
open import Cubical.Data.FinSet.Cardinality using (âˆ£â‰ƒcardâˆ£)
open import Cubical.Data.SumFin using () renaming (Fin to SFin)
open import Cubical.HITs.PropositionalTruncation as PT using ()

open import OptimalObservation using (Injective ; Optimal)
open import TheCardinalityHalfOfOptimalIsExactlyAMereEquivalenceAndItSaysNothingAboutTheSchemeItself
  using (TheOpenPigeonhole)

------------------------------------------------------------------------
-- 1.  An equivalence's function is injective
------------------------------------------------------------------------

equivInjective : {A B : Type} (e : A â‰ƒ B) â†’ Injective (e .fst)
equivInjective e {x} {y} p =
  sym (retEq e x) âˆ™ cong (invEq e) p âˆ™ retEq e y

------------------------------------------------------------------------
-- 2.  The residual combinatorial statement
------------------------------------------------------------------------

FinPigeonhole : Type
FinPigeonhole = (n : â„•) (f : SFin n â†’ SFin n) â†’ Injective f â†’ isEquiv f

------------------------------------------------------------------------
-- 3.  The reduction
------------------------------------------------------------------------

finPigeonholeGivesTheOpenPigeonhole : FinPigeonhole â†’ TheOpenPigeonhole
finPigeonholeGivesTheOpenPigeonhole finP X Y obs (inj , tight) =
  PT.rec2 (isPropIsEquiv obs) go (âˆ£â‰ƒcardâˆ£ X) (âˆ£â‰ƒcardâˆ£ Y)
  where
    go : (X .fst â‰ƒ SFin (card X)) â†’ (Y .fst â‰ƒ SFin (card Y)) â†’ isEquiv obs
    go eX eYâ‚€ = subst isEquiv obsPath (whole .snd)
      where
        eY : Y .fst â‰ƒ SFin (card X)
        eY = subst (Î» n â†’ Y .fst â‰ƒ SFin n) tight eYâ‚€

        g : SFin (card X) â†’ SFin (card X)
        g k = eY .fst (obs (invEq eX k))

        gInj : Injective g
        gInj {x} {y} p =
            sym (secEq eX x)
          âˆ™ cong (eX .fst) (inj (equivInjective eY p))
          âˆ™ secEq eX y

        whole : X .fst â‰ƒ Y .fst
        whole = compEquiv eX (compEquiv (g , finP (card X) g gInj) (invEquiv eY))

        obsPath : whole .fst â‰¡ obs
        obsPath i x = (retEq eY (obs (invEq eX (eX .fst x)))
                      âˆ™ cong obs (retEq eX x)) i
