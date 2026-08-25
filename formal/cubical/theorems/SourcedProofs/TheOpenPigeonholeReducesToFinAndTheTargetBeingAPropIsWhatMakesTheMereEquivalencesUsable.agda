{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheOpenPigeonholeReducesToFinAndTheTargetBeingAPropIsWhatMakesTheMereEquivalencesUsable
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- The object is `TheOpenPigeonhole`, a statement I wrote down at
-- ac4ee91d about `OptimalObservation`'s own definition; there is no
-- source to cite and a fabricated Sanskrit label would assert a
-- provenance nobody checked.  That module's three INSTANCES are
-- Piṅgala's *Chandaḥśāstra* uddiṣṭa (c. 300 BCE), Virahāṅka's
-- mātrāmeru (c. 600–800) and a CRT residue decode, named here in that
-- order and before any later name; **nothing below is a claim about
-- their mathematics.**  Checked before naming:
-- `.claude/hooks/priority-ledger.txt` (CURRENT header) and
-- `.claude/hooks/european-frame.txt`; `formal/` and `notes/` grepped
-- first.  `--guardedness` carried; infective.
--
-- ────────────────────────────────────────────────────────────────────
-- THE ITEM.  At ac4ee91d I proved that `Optimal X Y obs` unfolds to
-- *"`obs` is injective, AND some equivalence `X ≃ Y` exists"*, observed
-- that the second conjunct is not about `obs`, and left as a type
--
--     TheOpenPigeonhole = (X Y : FinSet ℓ-zero) (obs : X .fst → Y .fst)
--                       → Optimal X Y obs → isEquiv obs
--
-- WHAT THIS MODULE DOES, AND WHAT IT DOES NOT.  It does **not** prove
-- that statement.  It proves that the statement is **exactly** the
-- corresponding fact about `Fin`:
--
--     FinPigeonhole = (n : ℕ) (f : SFin n → SFin n) → Injective f
--                   → isEquiv f
--
--     finPigeonholeGivesTheOpenPigeonhole : FinPigeonhole → TheOpenPigeonhole
--
-- so the remaining content is one combinatorial fact about finite
-- ordinals, with every FinSet-level and cardinality-level ingredient
-- discharged.  Recording a reduction is not recording a proof, and the
-- header says which this is.
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
--
-- WHAT IS NOT CLAIMED.  **Nothing is amended or retracted** —
-- `OptimalObservation` and ac4ee91d stand unchanged, and `Optimal`,
-- `Injective` and `TheOpenPigeonhole` are imported, not redefined.
-- `FinPigeonhole` is NOT proved here and NOT refuted; it is true and
-- standard, and asserting it without a proof is exactly what this
-- corpus forbids, so it appears only as a hypothesis.  The CONVERSE
-- reduction — that `TheOpenPigeonhole` gives `FinPigeonhole` — is not
-- proved either, though it should be immediate at `X = Y = SFin n`;
-- "exactly" in the summary above therefore means *reduces to*, in one
-- direction, and nothing more.  No decidability is used anywhere.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module SourcedProofs.TheOpenPigeonholeReducesToFinAndTheTargetBeingAPropIsWhatMakesTheMereEquivalencesUsable where

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

open import SourcedProofs.OptimalObservation using (Injective ; Optimal)
open import SourcedProofs.TheCardinalityHalfOfOptimalIsExactlyAMereEquivalenceAndItSaysNothingAboutTheSchemeItself
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
