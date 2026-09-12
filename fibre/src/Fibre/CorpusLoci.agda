{-# OPTIONS --cubical --safe --guardedness #-}

module Fibre.CorpusLoci where

open import Agda.Builtin.Reflection
open import Agda.Builtin.List
open import Agda.Builtin.Sigma
open import Agda.Builtin.Unit
open import Agda.Builtin.Bool

open import Fibre.CorpusReflection using (expandAll)

infixr 5 _++_
_++_ : {A : Set} → List A → List A → List A
[] ++ ys = ys
(x ∷ xs) ++ ys = x ∷ (xs ++ ys)

-- One exact checked realization of a generator:
-- source declaration, accepted application term, normalized result type.
RawRealization : Set
RawRealization = Σ Name (λ _ → Σ Term (λ _ → Term))

-- A generator is stored once, with its exact Agda-accepted realization family.
RawLocus : Set
RawLocus = Σ Name (λ _ → List RawRealization)

RawLoci : Set
RawLoci = List RawLocus

vArg : Term → Arg Term
vArg t = arg (arg-info visible (modality relevant quantity-ω)) t

termOf : Name → TC Term
termOf n = bindTC (getDefinition n) λ where
  (data-cons _ _) → returnTC (con n [])
  _               → returnTC (def n [])

applyNamed : Name → Term → TC Term
applyNamed f x = bindTC (getDefinition f) λ where
  (data-cons _ _) → returnTC (con f (vArg x ∷ []))
  _               → returnTC (def f (vArg x ∷ []))

and : Bool → Bool → Bool
and true b = b
and false _ = false

-- A recorded realization must be meta-free: inferType on a partial
-- application can leave unsolved implicit metas, and a quoted meta node
-- poisons the final closed value with an unsolvable constraint.
mutual
  metaFreeT : Term → Bool
  metaFreeT (var _ as)      = metaFreeAs as
  metaFreeT (con _ as)      = metaFreeAs as
  metaFreeT (def _ as)      = metaFreeAs as
  metaFreeT (lam _ (abs _ t)) = metaFreeT t
  metaFreeT (pat-lam cs as) = and (metaFreeCs cs) (metaFreeAs as)
  metaFreeT (pi (arg _ a) (abs _ b)) = and (metaFreeT a) (metaFreeT b)
  metaFreeT (agda-sort (set t))  = metaFreeT t
  metaFreeT (agda-sort (prop t)) = metaFreeT t
  metaFreeT (agda-sort _)   = true
  metaFreeT (lit (meta _))  = false
  metaFreeT (lit _)         = true
  metaFreeT (meta _ _)      = false
  metaFreeT unknown         = true

  metaFreeAs : List (Arg Term) → Bool
  metaFreeAs [] = true
  metaFreeAs (arg _ t ∷ as) = and (metaFreeT t) (metaFreeAs as)

  metaFreeCs : List Clause → Bool
  metaFreeCs [] = true
  metaFreeCs (clause _ _ t ∷ cs)      = and (metaFreeT t) (metaFreeCs cs)
  metaFreeCs (absurd-clause _ _ ∷ cs) = metaFreeCs cs


tryRealization : Name → Name → TC (List RawRealization)
tryRealization f n =
  bindTC (termOf n) λ x →
  bindTC (applyNamed f x) λ app →
  -- No withReconstructed: parameter reconstruction on arbitrary corpus
  -- terms hits an uncatchable internal error in Agda 2.8.0's
  -- ReconstructParameters; the locus needs only the checked application
  -- and its normalized type, which inference supplies unreconstructed.
  -- The result type is weak-head reduced, not normalised: full
  -- normalisation of some application types unfolds certificate
  -- computations past this machine's heap, while reduce keeps a
  -- canonical head at bounded cost.
  -- runSpeculative with false rolls the TC state back, discarding every
  -- meta the probe created (a partial application of a parameterized
  -- family otherwise leaves unsolved metas that poison the whole
  -- declaration), while the computed value survives.  The meta-free
  -- filter still guards the recorded terms: a reference to a rolled-back
  -- meta would dangle.
  catchTC
    (runSpeculative
      (noConstraints
        (bindTC (inferType app) λ ty →
         bindTC (reduce ty) λ rty →
         returnTC (keep n app rty , false))))
    (returnTC [])
  where
  keep : Name → Term → Term → List RawRealization
  keep n app nty with and (metaFreeT app) (metaFreeT nty)
  ... | true  = (n , app , nty) ∷ []
  ... | false = []

realizations : Name → List Name → TC (List RawRealization)
realizations f [] = returnTC []
realizations f (n ∷ ns) =
  bindTC (tryRealization f n) λ here →
  bindTC (realizations f ns) λ rest →
  returnTC (here ++ rest)

oneLocus : List Name → Name → TC RawLoci
oneLocus all f =
  bindTC (realizations f all) λ where
    []       → returnTC []
    (r ∷ rs) → returnTC ((f , r ∷ rs) ∷ [])

buildLoci : List Name → List Name → TC RawLoci
buildLoci all [] = returnTC []
buildLoci all (f ∷ fs) =
  bindTC (oneLocus all f) λ here →
  bindTC (buildLoci all fs) λ rest →
  returnTC (here ++ rest)

materializeLociTerm : List Name → TC Term
materializeLociTerm ns =
  bindTC (expandAll ns) λ expanded →
  bindTC (buildLoci expanded expanded) quoteTC

macro
  materializeLoci : List Name → Term → TC ⊤
  materializeLoci ns hole = bindTC (materializeLociTerm ns) (unify hole)
