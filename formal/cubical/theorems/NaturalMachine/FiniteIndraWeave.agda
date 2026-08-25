{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.FiniteIndraWeave where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Dec ; yes ; no ; ¬_)
open import Cubical.Data.Bool using (Bool ; false ; true ; not ; false≢true)

TotalView : (Root Jewel : Type₀) → Type₀
TotalView Root Jewel = Root → Root → Jewel

LocalAction : (Root Jewel : Type₀) → Type₀
LocalAction Root Jewel = Root → Jewel → Jewel

reweave : {Root Jewel : Type₀}
  → LocalAction Root Jewel → TotalView Root Jewel → TotalView Root Jewel
reweave action view root target = action root (view root target)

AnchorCoherent : {Root Jewel : Type₀}
  → Root → TotalView Root Jewel → Type₀
AnchorCoherent anchor view =
  (root target : _) → view anchor target ≡ view root target

PairwiseCoherent : {Root Jewel : Type₀} → TotalView Root Jewel → Type₀
PairwiseCoherent view =
  (left right target : _) → view left target ≡ view right target

anchor→pairwise : {Root Jewel : Type₀} {anchor : Root}
  {view : TotalView Root Jewel}
  → AnchorCoherent anchor view → PairwiseCoherent view
anchor→pairwise coherent left right target =
  sym (coherent left target) ∙ coherent right target

pairwise→anchor : {Root Jewel : Type₀} {anchor : Root}
  {view : TotalView Root Jewel}
  → PairwiseCoherent view → AnchorCoherent anchor view
pairwise→anchor coherent root target = coherent _ root target

data RowOK {Root Jewel : Type₀} (anchor root : Root)
           (view : TotalView Root Jewel) : List Root → Type₀ where
  row[] : RowOK anchor root view []
  row∷ : {target : Root} {targets : List Root}
       → view anchor target ≡ view root target
       → RowOK anchor root view targets
       → RowOK anchor root view (target ∷ targets)

data RowAudit {Root Jewel : Type₀} (anchor root : Root)
              (view : TotalView Root Jewel) (targets : List Root) : Type₀ where
  row-ok : RowOK anchor root view targets → RowAudit anchor root view targets
  row-tear : (target : Root)
           → ¬ (view anchor target ≡ view root target)
           → RowAudit anchor root view targets

scanRow : {Root Jewel : Type₀}
  → ((x y : Jewel) → Dec (x ≡ y))
  → (anchor root : Root) (view : TotalView Root Jewel)
  → (targets : List Root) → RowAudit anchor root view targets
scanRow dec anchor root view [] = row-ok row[]
scanRow dec anchor root view (target ∷ targets)
  with dec (view anchor target) (view root target)
... | no unequal = row-tear target unequal
... | yes equal with scanRow dec anchor root view targets
...   | row-tear torn unequal = row-tear torn unequal
...   | row-ok rest = row-ok (row∷ equal rest)

data WeaveOK {Root Jewel : Type₀} (anchor : Root)
             (view : TotalView Root Jewel) (targets : List Root)
             : List Root → Type₀ where
  weave[] : WeaveOK anchor view targets []
  weave∷ : {root : Root} {roots : List Root}
         → RowOK anchor root view targets
         → WeaveOK anchor view targets roots
         → WeaveOK anchor view targets (root ∷ roots)

record Tear {Root Jewel : Type₀} (anchor : Root)
            (view : TotalView Root Jewel) : Type₀ where
  constructor tear
  field
    root target : Root
    failed : ¬ (view anchor target ≡ view root target)

data Audit {Root Jewel : Type₀} (anchor : Root)
           (view : TotalView Root Jewel)
           (roots targets : List Root) : Type₀ where
  coherent : WeaveOK anchor view targets roots
           → Audit anchor view roots targets
  torn : Tear anchor view → Audit anchor view roots targets

-- At most one comparison per root-target cell; unlike the cubic pairwise
-- scan, the anchor invariant needs only the rectangular grid.
scan : {Root Jewel : Type₀}
  → ((x y : Jewel) → Dec (x ≡ y))
  → (anchor : Root) (view : TotalView Root Jewel)
  → (roots targets : List Root) → Audit anchor view roots targets
scan dec anchor view [] targets = coherent weave[]
scan dec anchor view (root ∷ roots) targets
  with scanRow dec anchor root view targets
... | row-tear target unequal = torn (tear root target unequal)
... | row-ok row with scan dec anchor view roots targets
...   | torn witness = torn witness
...   | coherent rest = coherent (weave∷ row rest)

boolEq : (x y : Bool) → Dec (x ≡ y)
boolEq false false = yes refl
boolEq false true = no false≢true
boolEq true false = no (λ p → false≢true (sym p))
boolEq true true = yes refl

baseView : TotalView Bool Bool
baseView root target = false

rootAction : LocalAction Bool Bool
rootAction false jewel = jewel
rootAction true jewel = not jewel

woven : TotalView Bool Bool
woven = reweave rootAction baseView

demo : Audit false woven (false ∷ true ∷ []) (false ∷ true ∷ [])
demo = scan boolEq false woven (false ∷ true ∷ []) (false ∷ true ∷ [])

demo-tear : Tear false woven
demo-tear = tear true false false≢true

demo-finds-tear : demo ≡ torn demo-tear
demo-finds-tear = refl
