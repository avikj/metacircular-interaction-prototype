{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.DivisorHistoryDSO where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Properties using (_! ; _choose_)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import NaturalMachine.DSOContinuationFullAbstract using (Cost ; fin ; ∞)
import NaturalMachine.DSOMinPlusFinite as M

-- A divisor history with m labelled events is observed only through an
-- ordered block composition.  Permutations internal to each block form the
-- residual derivation fiber Π b!, while the visible flag/coset count is the
-- corresponding iterated binomial coefficient.
data Blocks : Type₀ where
  [] : Blocks
  _∷_ : ℕ → Blocks → Blocks

infixr 5 _∷_

mass : Blocks → ℕ
mass [] = zero
mass (b ∷ bs) = b + mass bs

residual : Blocks → ℕ
residual [] = 1
residual (b ∷ bs) = (b !) · residual bs

visible : Blocks → ℕ
visible [] = 1
visible (b ∷ bs) = ((b + mass bs) choose b) · visible bs

endpoint snapshot full : Blocks
endpoint = 3 ∷ []
snapshot = 2 ∷ 1 ∷ []
full = 1 ∷ 1 ∷ 1 ∷ []

endpoint-counts : (visible endpoint ≡ 1) × (residual endpoint ≡ 6)
endpoint-counts = refl , refl

snapshot-counts : (visible snapshot ≡ 3) × (residual snapshot ≡ 2)
snapshot-counts = refl , refl

full-counts : (visible full ≡ 6) × (residual full ≡ 1)
full-counts = refl , refl

-- Splitting a block transfers a binomial factor from the hidden history
-- fiber to the visible flag count.  These two steps are the m=3 checked
-- instance: 3 ↦ 2+1 has factor 3, then 2 ↦ 1+1 has factor 2.
endpoint→snapshot-visible : visible snapshot ≡ 3 · visible endpoint
endpoint→snapshot-visible = refl

endpoint→snapshot-residual : residual endpoint ≡ 3 · residual snapshot
endpoint→snapshot-residual = refl

snapshot→full-visible : visible full ≡ 2 · visible snapshot
snapshot→full-visible = refl

snapshot→full-residual : residual snapshot ≡ 2 · residual full
snapshot→full-residual = refl

-- Refinement never destroys an already visible option.  This is the finite
-- observation preorder endpoint ≤ snapshot ≤ full.
data Architecture : Type₀ where
  end snap hist : Architecture

data Refines : Architecture → Architecture → Type₀ where
  reflR : {a : Architecture} → Refines a a
  end-snap : Refines end snap
  snap-hist : Refines snap hist
  end-hist : Refines end hist

data Option : Architecture → Type₀ where
  endpoint-option : {a : Architecture} → Option a
  snapshot-option : Option snap
  snapshot-at-history : Option hist
  history-option : Option hist

option-monotone : {a b : Architecture} → Refines a b → Option a → Option b
option-monotone reflR o = o
option-monotone end-snap endpoint-option = endpoint-option
option-monotone snap-hist endpoint-option = endpoint-option
option-monotone snap-hist snapshot-option = snapshot-at-history
option-monotone end-hist endpoint-option = endpoint-option

-- The DSO choice is continuation-sensitive.  Rows are acquisition costs for
-- endpoint/snapshot/full-history observations; terminal costs encode what a
-- future task will ask.  No architecture is unconditionally optimal.
choice : M.Matrix 1 3
choice M.iz M.iz = fin 0
choice M.iz (M.is M.iz) = fin 1
choice M.iz (M.is (M.is M.iz)) = fin 3

endpointFuture snapshotFuture historyFuture : M.Continuation 3
endpointFuture M.iz = fin 0
endpointFuture (M.is M.iz) = fin 4
endpointFuture (M.is (M.is M.iz)) = fin 10

snapshotFuture M.iz = fin 8
snapshotFuture (M.is M.iz) = fin 1
snapshotFuture (M.is (M.is M.iz)) = fin 5

historyFuture M.iz = fin 20
historyFuture (M.is M.iz) = fin 8
historyFuture (M.is (M.is M.iz)) = fin 0

endpoint-chosen : M.Argmin choice endpointFuture M.iz
endpoint-chosen = M.active M.iz refl

snapshot-chosen : M.Argmin choice snapshotFuture M.iz
snapshot-chosen = M.active (M.is M.iz) refl

history-chosen : M.Argmin choice historyFuture M.iz
history-chosen = M.active (M.is (M.is M.iz)) refl

endpoint-value : M.bellman choice endpointFuture M.iz ≡ fin 0
endpoint-value = refl

snapshot-value : M.bellman choice snapshotFuture M.iz ≡ fin 2
snapshot-value = refl

history-value : M.bellman choice historyFuture M.iz ≡ fin 3
history-value = refl
