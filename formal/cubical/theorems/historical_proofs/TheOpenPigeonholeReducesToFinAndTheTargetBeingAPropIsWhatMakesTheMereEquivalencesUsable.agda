{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheOpenPigeonholeReducesToFinAndTheTargetBeingAPropIsWhatMakesTheMereEquivalencesUsable
--
-- ON THE NAME.  No tradition term is used.  The object is
-- `TheOpenPigeonhole`, a statement about `OptimalObservation`'s own
-- definition.  That module's three INSTANCES are
-- Pigala's *Chandastra* uddia (c. 300 BCE), Virahka's
-- mtrmeru (c. 600–800) and a CRT residue decode.
--
-- ────────────────────────────────────────────────────────────────────
-- THE ITEM.  `Optimal X Y obs` unfolds to
-- *"`obs` is injective, AND some equivalence `X ≃ Y` exists"*;
-- the second conjunct is not about `obs`.  The statement, as a type:
--
--     TheOpenPigeonhole = (X Y : FinSet ℓ-zero) (obs : X .fst → Y .fst)
--                       → Optimal X Y obs → isEquiv obs
--
-- WHAT THIS MODULE DOES.  It proves that the statement is **exactly** the
-- corresponding fact about `Fin`:
--
--     FinPigeonhole = (n : ℕ) (f : SFin n → SFin n) → Injective f
--                   → isEquiv f
--
--     finPigeonholeGivesTheOpenPigeonhole : FinPigeonhole → TheOpenPigeonhole
--
-- so the remaining content is one combinatorial fact about finite
-- ordinals, with every FinSet-level and cardinality-level ingredient
-- discharged.
--
-- **AND THE STEP THAT MAKES THE REDUCTION LEGAL IS THE INTERESTING
-- ONE.**  `X` and `Y` carry only MERE equivalences to `SFin` — `∣≃card∣`
-- lands in `∥_∥₁`, and it must, or `card` would not be well defined.
-- An arbitrary construction cannot escape that truncation.  This one
-- can, for exactly one reason: **the goal `isEquiv obs` is a
-- proposition** (`isPropIsEquiv`), so `PT.rec2` applies and both
-- anonymous equivalences may be named at once.  Had the goal been the
-- equivalence itself — `X .fst ≃ Y .fst`, a structure — the same
-- argument would be blocked, and no amount of finiteness would unblock
-- it.  So the reduction is not bookkeeping: it is the observation that
-- **this particular question is truncation-stable and the neighbouring
-- one is not.**
--
-- WHAT IS PROVED
--
--   equivInjective     an equivalence's function is injective, from
--                      `retEq` — needed because the conjugation below
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
  using (_≃_ ; isEquiv ; isPropIsEquiv ; invEq ; retEq ; secEq
        ; invEquiv ; compEquiv)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.FinSet using (FinSet ; card)
open import Cubical.Data.FinSet.Cardinality using (∣≃card∣)
open import Cubical.Data.SumFin using () renaming (Fin to SFin)
open import Cubical.HITs.PropositionalTruncation as PT using ()

open import OptimalObservation using (Injective ; Optimal)
open import TheCardinalityHalfOfOptimalIsExactlyAMereEquivalenceAndItSaysNothingAboutTheSchemeItself
  using (TheOpenPigeonhole)

------------------------------------------------------------------------
-- 1.  An equivalence's function is injective
------------------------------------------------------------------------

equivInjective : {A B : Type} (e : A ≃ B) → Injective (e .fst)
equivInjective e {x} {y} p =
  sym (retEq e x) ∙ cong (invEq e) p ∙ retEq e y

------------------------------------------------------------------------
-- 2.  The residual combinatorial statement
------------------------------------------------------------------------

FinPigeonhole : Type
FinPigeonhole = (n : ℕ) (f : SFin n → SFin n) → Injective f → isEquiv f

------------------------------------------------------------------------
-- 3.  The reduction
------------------------------------------------------------------------

finPigeonholeGivesTheOpenPigeonhole : FinPigeonhole → TheOpenPigeonhole
finPigeonholeGivesTheOpenPigeonhole finP X Y obs (inj , tight) =
  PT.rec2 (isPropIsEquiv obs) go (∣≃card∣ X) (∣≃card∣ Y)
  where
    go : (X .fst ≃ SFin (card X)) → (Y .fst ≃ SFin (card Y)) → isEquiv obs
    go eX eY₀ = subst isEquiv obsPath (whole .snd)
      where
        eY : Y .fst ≃ SFin (card X)
        eY = subst (λ n → Y .fst ≃ SFin n) tight eY₀

        g : SFin (card X) → SFin (card X)
        g k = eY .fst (obs (invEq eX k))

        gInj : Injective g
        gInj {x} {y} p =
            sym (secEq eX x)
          ∙ cong (eX .fst) (inj (equivInjective eY p))
          ∙ secEq eX y

        whole : X .fst ≃ Y .fst
        whole = compEquiv eX (compEquiv (g , finP (card X) g gInj) (invEquiv eY))

        obsPath : whole .fst ≡ obs
        obsPath i x = (retEq eY (obs (invEq eX (eX .fst x)))
                      ∙ cong obs (retEq eX x)) i
