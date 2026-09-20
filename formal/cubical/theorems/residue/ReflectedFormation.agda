{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module ReflectedFormation where
open import Cubical.Foundations.Prelude using (Type)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Agda.Builtin.Reflection renaming (Type to Quoted)

record Decl : Type₀ where
  constructor formed
  field declName : Name; declType : Term; declDefinition : Definition

decl : Name → TC Decl
decl nm = bindTC (getType nm) λ ty → bindTC (getDefinition nm) λ df → returnTC (formed nm ty df)

rawView : Decl → Term
rawView = Decl.declType

headCode : Term → ℕ
headCode (var _ _) = 0
headCode (con _ _) = 1
headCode (def _ _) = 2
headCode (lam _ _) = 3
headCode (pat-lam _ _) = 4
headCode (pi _ _) = 5
headCode (agda-sort _) = 6
headCode (lit _) = 7
headCode (meta _ _) = 8
headCode unknown = 9

argChildren : List (Arg Term) → List Term
argChildren [] = []
argChildren (arg _ t ∷ as) = t ∷ argChildren as

children : Term → List Term
children (var _ as) = argChildren as
children (con _ as) = argChildren as
children (def _ as) = argChildren as
children (lam _ (abs _ t)) = t ∷ []
children (pat-lam _ as) = argChildren as
children (pi (arg _ a) (abs _ b)) = a ∷ b ∷ []
children (agda-sort (set t)) = t ∷ []
children (agda-sort (prop t)) = t ∷ []
children (agda-sort _) = []
children (lit _) = []
children (meta _ as) = argChildren as
children unknown = []

nth : List Term → ℕ → Term → Term
nth [] _ fallback = fallback
nth (t ∷ _) zero _ = t
nth (_ ∷ ts) (suc n) fallback = nth ts n fallback

child : Term → ℕ → Term
child t n = nth (children t) n t
