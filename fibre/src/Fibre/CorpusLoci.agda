{-# OPTIONS --cubical --safe --guardedness #-}

module Fibre.CorpusLoci where

open import Agda.Builtin.Reflection
open import Agda.Builtin.List
open import Agda.Builtin.Sigma
open import Agda.Builtin.Unit
open import Agda.Builtin.Bool
open import Agda.Builtin.Maybe

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

open import Agda.Builtin.Nat using (Nat ; zero ; suc)

-- Fuel-bounded size gate.  The heap wall is the cumulative size of the
-- one materialized value: a handful of realizations whose types carry
-- huge instantiations dominate it.  A realization is recorded only when
-- its terms fit the fuel; the traversal itself is fuel-bounded so a
-- huge term costs only the fuel, never its own size.
mutual
  fuelT : Nat → Term → Nat
  fuelT zero _ = zero
  fuelT (suc f) (var _ as)      = fuelAs f as
  fuelT (suc f) (con _ as)      = fuelAs f as
  fuelT (suc f) (def _ as)      = fuelAs f as
  fuelT (suc f) (lam _ (abs _ t)) = fuelT f t
  fuelT (suc f) (pat-lam _ as)  = fuelAs f as
  fuelT (suc f) (pi (arg _ a) (abs _ b)) = fuelT (fuelT f a) b
  fuelT (suc f) (agda-sort _)   = f
  fuelT (suc f) (lit _)         = f
  fuelT (suc f) (meta _ as)     = fuelAs f as
  fuelT (suc f) unknown         = f

  fuelAs : Nat → List (Arg Term) → Nat
  fuelAs zero _ = zero
  fuelAs f []   = f
  fuelAs f (arg _ t ∷ as) = fuelAs (fuelT f t) as

fits : Nat → Term → Bool
fits f t = positive (fuelT f t)
  where
  positive : Nat → Bool
  positive zero    = false
  positive (suc _) = true

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


------------------------------------------------------------------------
-- Head gate.  Almost every (generator, argument) pair is rejected by
-- the typechecker on the heads of the two types alone, and two DISTINCT
-- RIGID heads (data or record types, which nothing can unfold) can
-- never convert.  Comparing heads costs one name equality instead of an
-- elaboration, turning the effectively-quadratic probe bill into a
-- quadratic bill of cheap comparisons plus a near-linear bill of real
-- probes.  Only provably-doomed probes are skipped: any uncertainty
-- (function aliases, primitives, vars, sorts) falls through to a real
-- probe, so the recorded loci value is unchanged.
------------------------------------------------------------------------

data Head : Set where
  rigidH : Name → Head   -- a data/record head: cannot unfold
  piH    : Head          -- a visible function type
  flexH  : Head          -- anything that might still reduce

-- Peel hidden and instance domains: applying one visible argument makes
-- Agda insert those automatically, so the effective type is the body.
peelHidden : Nat → Term → Term
peelHidden zero t = t
peelHidden (suc f) (pi (arg (arg-info hidden _) _) (abs _ b))    = peelHidden f b
peelHidden (suc f) (pi (arg (arg-info instance′ _) _) (abs _ b)) = peelHidden f b
peelHidden (suc f) t = t

headOf : Term → TC Head
headOf t0 = classify (peelHidden 64 t0)
  where
  classify : Term → TC Head
  classify (def d _) = bindTC (getDefinition d) λ where
    (data-type _ _)   → returnTC (rigidH d)
    (record-type _ _) → returnTC (rigidH d)
    _                 → returnTC flexH
  classify (pi _ _) = returnTC piH
  classify _        = returnTC flexH

-- The first visible domain of a generator's type, if syntactically
-- apparent; nothing means "cannot tell", never "cannot apply".
visibleDomain : Term → Maybe Term
visibleDomain t = grab (peelHidden 64 t)
  where
  grab : Term → Maybe Term
  grab (pi (arg (arg-info visible _) a) _) = just a
  grab _ = nothing

compatible : Head → Head → Bool
compatible (rigidH a) (rigidH b) = primQNameEquality a b
compatible (rigidH _) piH        = false
compatible piH        (rigidH _) = false
compatible _ _ = true

-- A pool entry carries its argument term and type head, computed once.
PoolEntry : Set
PoolEntry = Σ Name (λ _ → Σ Term (λ _ → Head))

preparePool : List Name → TC (List PoolEntry)
preparePool [] = returnTC []
preparePool (n ∷ ns) =
  bindTC (termOf n) λ x →
  bindTC (catchTC (bindTC (getType n) headOf) (returnTC flexH)) λ hx →
  bindTC (preparePool ns) λ rest →
  returnTC ((n , x , hx) ∷ rest)

-- The generator's domain head; nothing = unknown, probe everything.
genGate : Name → TC (Maybe Head)
genGate f =
  catchTC
    (bindTC (getType f) λ tf → gate (visibleDomain tf))
    (returnTC nothing)
  where
  gate : Maybe Term → TC (Maybe Head)
  gate nothing    = returnTC nothing
  gate (just dom) = bindTC (headOf dom) just′
    where
    just′ : Head → TC (Maybe Head)
    just′ h = returnTC (just h)

admits : Maybe Head → Head → Bool
admits nothing   _  = true
admits (just hd) hx = compatible hd hx

tryRealization : Name → Name → Term → TC (List RawRealization)
tryRealization f n x =
  bindTC (applyNamed f x) λ app →
  -- No withReconstructed: parameter reconstruction on arbitrary corpus
  -- terms hits an uncatchable internal error in Agda 2.8.0's
  -- ReconstructParameters; the locus needs only the checked application
  -- and its normalized type, which inference supplies unreconstructed.
  -- The result type is recorded exactly as inference produced it:
  -- both full normalisation and weak-head reduction unfold heads
  -- (FactorsThrough into its Σ-expansion, certificate computations
  -- into their tables) and the sum of those expansions across the
  -- quadratic probe grid is what exhausts the heap.  The recorded
  -- application is fully checked either way.
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
         returnTC (keep n app ty , false))))
    (returnTC [])
  where
  keep : Name → Term → Term → List RawRealization
  keep n app nty with and (and (metaFreeT app) (metaFreeT nty))
                         (and (fits 200 app) (fits 200 nty))
  ... | true  = (n , app , nty) ∷ []
  ... | false = []

realizations : Name → Maybe Head → List PoolEntry → TC (List RawRealization)
realizations f gate [] = returnTC []
realizations f gate ((n , x , hx) ∷ ns) =
  bindTC (probe (admits gate hx)) λ here →
  bindTC (realizations f gate ns) λ rest →
  returnTC (here ++ rest)
  where
  probe : Bool → TC (List RawRealization)
  probe true  = tryRealization f n x
  probe false = returnTC []

oneLocus : List PoolEntry → Name → TC RawLoci
oneLocus pool f =
  bindTC (genGate f) λ gate →
  bindTC (realizations f gate pool) λ where
    []       → returnTC []
    (r ∷ rs) → returnTC ((f , r ∷ rs) ∷ [])

buildLoci : List PoolEntry → List Name → TC RawLoci
buildLoci pool [] = returnTC []
buildLoci pool (f ∷ fs) =
  bindTC (oneLocus pool f) λ here →
  bindTC (buildLoci pool fs) λ rest →
  returnTC (here ++ rest)

materializeLociTerm : List Name → TC Term
materializeLociTerm ns =
  bindTC (expandAll ns) λ expanded →
  bindTC (preparePool expanded) λ pool →
  bindTC (buildLoci pool expanded) quoteTC

-- Generator-sliced form: probe only the given generators against the
-- full pool.  Quadratic probing accumulates un-collectable TC state, so
-- one process cannot hold the whole grid; slices materialize the same
-- loci value shard by shard, one bounded process each, and the shards
-- concatenate to exactly buildLoci pool pool.
materializeLociForTerm : List Name → List Name → TC Term
materializeLociForTerm gens ns =
  bindTC (expandAll ns) λ expanded →
  bindTC (preparePool expanded) λ pool →
  bindTC (expandAll gens) λ egens →
  bindTC (buildLoci pool egens) quoteTC

macro
  materializeLoci : List Name → Term → TC ⊤
  materializeLoci ns hole = bindTC (materializeLociTerm ns) (unify hole)

  materializeLociFor : List Name → List Name → Term → TC ⊤
  materializeLociFor gens ns hole =
    bindTC (materializeLociForTerm gens ns) (unify hole)
