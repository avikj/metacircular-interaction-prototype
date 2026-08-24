-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.ProductiveTear where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Bool using (Bool ; false ; true)
open import Cubical.Relation.Nullary using (Dec)

open import NaturalMachine.FiniteIndraWeave
open import NaturalMachine.ProductiveIndraNet

data PrefixOK {Root Jewel : Type₀} (anchor : Root)
              (net : Net Root Jewel) (roots targets : List Root)
              : ℕ → Type₁ where
  ok-zero : PrefixOK anchor net roots targets zero
  ok-suc : {n : ℕ}
    → WeaveOK anchor (Net.view net) targets roots
    → PrefixOK anchor (Net.next net) roots targets n
    → PrefixOK anchor net roots targets (suc n)

-- `later-tear` retains the checked coherence of the preceding layer. Thus a
-- returned tear is earliest in the inspected prefix, not merely some failure.
data EarliestTear {Root Jewel : Type₀} (anchor : Root)
                  (net : Net Root Jewel) (roots targets : List Root)
                  : ℕ → Type₁ where
  now-tear : {n : ℕ}
    → Tear anchor (Net.view net)
    → EarliestTear anchor net roots targets (suc n)
  later-tear : {n : ℕ}
    → WeaveOK anchor (Net.view net) targets roots
    → EarliestTear anchor (Net.next net) roots targets n
    → EarliestTear anchor net roots targets (suc n)

data PrefixAudit {Root Jewel : Type₀} (anchor : Root)
                 (net : Net Root Jewel) (roots targets : List Root)
                 (n : ℕ) : Type₁ where
  prefix-ok : PrefixOK anchor net roots targets n
            → PrefixAudit anchor net roots targets n
  prefix-torn : EarliestTear anchor net roots targets n
              → PrefixAudit anchor net roots targets n

scanPrefix : {Root Jewel : Type₀}
  → ((x y : Jewel) → Dec (x ≡ y))
  → (anchor : Root) (net : Net Root Jewel)
  → (roots targets : List Root) (n : ℕ)
  → PrefixAudit anchor net roots targets n
scanPrefix dec anchor net roots targets zero = prefix-ok ok-zero
scanPrefix dec anchor net roots targets (suc n)
  with scan dec anchor (Net.view net) roots targets
... | torn witness = prefix-torn (now-tear witness)
... | coherent here with scanPrefix dec anchor (Net.next net) roots targets n
...   | prefix-ok rest = prefix-ok (ok-suc here rest)
...   | prefix-torn witness = prefix-torn (later-tear here witness)

-- Bisimilar productive nets have equal finite propagated observations.
propagated-observations-agree : {Root Jewel : Type₀}
  (action : LocalAction Root Jewel) {left right : Net Root Jewel}
  → Bisim left right → (n : ℕ)
  → observe n (propagate action left) ≡ observe n (propagate action right)
propagated-observations-agree action related =
  observe-bisim (propagate-bisim action related)

roots₂ : List Bool
roots₂ = false ∷ true ∷ []

base-row : (root : Bool) → RowOK false root baseView roots₂
base-row root = row∷ refl (row∷ refl row[])

base-ok : WeaveOK false baseView roots₂ roots₂
base-ok = weave∷ (base-row false) (weave∷ (base-row true) weave[])

-- pulse is coherent at time zero and torn at time one; the returned object
-- contains both the earlier coherence grid and the later concrete tear.
pulse-two-audit : PrefixAudit false pulse roots₂ roots₂ 2
pulse-two-audit = scanPrefix boolEq false pulse roots₂ roots₂ 2

pulse-earliest-tear : EarliestTear false pulse roots₂ roots₂ 2
pulse-earliest-tear = later-tear base-ok (now-tear demo-tear)

pulse-finds-earliest-tear : pulse-two-audit ≡ prefix-torn pulse-earliest-tear
pulse-finds-earliest-tear = refl
