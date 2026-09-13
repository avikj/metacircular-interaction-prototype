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
  rigidH : Name → Head   -- a data/record/axiom head: cannot unfold
  piH    : Head          -- a visible function type
  sortH  : Head          -- a universe
  flexH  : Head          -- anything that might still reduce

-- Peel hidden and instance domains: applying one visible argument makes
-- Agda insert those automatically, so the effective type is the body.
peelHidden : Nat → Term → Term
peelHidden zero t = t
peelHidden (suc f) (pi (arg (arg-info hidden _) _) (abs _ b))    = peelHidden f b
peelHidden (suc f) (pi (arg (arg-info instance′ _) _) (abs _ b)) = peelHidden f b
peelHidden (suc f) t = t

-- Classify with a little reduction fuel: a function-alias head (the
-- ubiquitous _≡_ over PathP) is weak-head reduced — on the small
-- DECLARED type of a name, never on probe results — until a rigid
-- head, a pi, a sort, or the fuel appears.  Axioms are rigid: nothing
-- ever unfolds them.
headOf : Term → TC Head
headOf = go 3
  where
  go : Nat → Term → TC Head
  go fuel t0 = classify (peelHidden 64 t0)
    where
    again : Nat → Term → TC Head
    again zero    _ = returnTC flexH
    again (suc f) t = bindTC (catchTC (reduce t) (returnTC unknown)) (go f)

    classify : Term → TC Head
    classify t@(def d _) = bindTC (getDefinition d) λ where
      (data-type _ _)   → returnTC (rigidH d)
      (record-type _ _) → returnTC (rigidH d)
      axiom             → returnTC (rigidH d)
      _                 → again fuel t
    classify (pi _ _)      = returnTC piH
    classify (agda-sort _) = returnTC sortH
    classify _             = returnTC flexH

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
compatible piH        piH        = true
compatible sortH      sortH      = true
compatible flexH      _          = true
compatible _          flexH      = true
compatible _ _ = false

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

------------------------------------------------------------------------
-- Bucketed pool.  There is no reason to touch every (generator, state)
-- pair even cheaply: partition the pool by type head ONCE, then each
-- generator reads exactly the bucket its domain head names, plus the
-- flex bucket (entries whose type might still reduce — the only
-- irreducible residue).  Build is linear in the pool (times the small
-- number of distinct heads); per generator, work is proportional to its
-- actual candidates.
------------------------------------------------------------------------

Bucket : Set
Bucket = Σ Name (λ _ → List PoolEntry)

data Pool : Set where
  mkPool : List Bucket        -- rigid-headed entries, keyed by head name
         → List PoolEntry     -- function-typed entries
         → List PoolEntry     -- universe-typed entries
         → List PoolEntry     -- flex entries: candidates for everyone
         → List PoolEntry     -- the whole pool, for unknown gates
         → Pool

insertRigid : Name → PoolEntry → List Bucket → List Bucket
insertRigid d e [] = (d , e ∷ []) ∷ []
insertRigid d e ((d' , es) ∷ bs) with primQNameEquality d d'
... | true  = (d' , e ∷ es) ∷ bs
... | false = (d' , es) ∷ insertRigid d e bs

lookupRigid : Name → List Bucket → List PoolEntry
lookupRigid d [] = []
lookupRigid d ((d' , es) ∷ bs) with primQNameEquality d d'
... | true  = es
... | false = lookupRigid d bs

partitionPool : List PoolEntry → Pool
partitionPool = go (mkPool [] [] [] [] [])
  where
  go : Pool → List PoolEntry → Pool
  go p [] = p
  go (mkPool bs pis sorts flex all) (e ∷ es) with e
  ... | (_ , _ , rigidH d) = go (mkPool (insertRigid d e bs) pis sorts flex (e ∷ all)) es
  ... | (_ , _ , piH)      = go (mkPool bs (e ∷ pis) sorts flex (e ∷ all)) es
  ... | (_ , _ , sortH)    = go (mkPool bs pis (e ∷ sorts) flex (e ∷ all)) es
  ... | (_ , _ , flexH)    = go (mkPool bs pis sorts (e ∷ flex) (e ∷ all)) es

candidates : Pool → Maybe Head → List PoolEntry
candidates (mkPool bs pis sorts flex all) (just (rigidH d)) = lookupRigid d bs ++ flex
candidates (mkPool bs pis sorts flex all) (just piH)        = pis ++ flex
candidates (mkPool bs pis sorts flex all) (just sortH)      = sorts ++ flex
candidates (mkPool bs pis sorts flex all) (just flexH)      = all
candidates (mkPool bs pis sorts flex all) nothing           = all

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

-- Each probe — successful or failed — permanently retains typechecker
-- state that runSpeculative does not give back (measured: heap grows
-- quadratically in probe count and exhausts 13 GB near 300 pool
-- names).  So the probe bill is bounded by the OUTPUT: a generator
-- stops probing once its exhibited family reaches the cap.  The locus
-- is then the first realizationCap checked realizations in pool order —
-- an exact, checked, finite presentation of the family, not its
-- completion.
realizationCap : Nat
realizationCap = 8

-- Failed probes retain state exactly like successful ones, so a
-- generator whose bucket is large but mostly ill-typed must also stop:
-- it spends at most failureBudget failures.
failureBudget : Nat
failureBudget = 24

realizations : Nat → Nat → Name → List PoolEntry → TC (List RawRealization)
realizations zero    _       f _  = returnTC []
realizations _       _       f [] = returnTC []
realizations _       zero    f _  = returnTC []
realizations (suc k) (suc b) f ((n , x , _) ∷ ns) =
  bindTC (tryRealization f n x) λ where
    []   → bindTC (realizations (suc k) b f ns) λ rest → returnTC rest
    here → bindTC (realizations k (suc b) f ns) λ rest → returnTC (here ++ rest)

oneLocus : Pool → Name → TC RawLoci
oneLocus pool f =
  bindTC (genGate f) λ gate →
  bindTC (realizations realizationCap failureBudget f (candidates pool gate)) λ where
    []       → returnTC []
    (r ∷ rs) → returnTC ((f , r ∷ rs) ∷ [])

buildLoci : Pool → List Name → TC RawLoci
buildLoci pool [] = returnTC []
buildLoci pool (f ∷ fs) =
  bindTC (oneLocus pool f) λ here →
  bindTC (buildLoci pool fs) λ rest →
  returnTC (here ++ rest)

materializeLociTerm : List Name → TC Term
materializeLociTerm ns =
  bindTC (expandAll ns) λ expanded →
  bindTC (preparePool expanded) λ entries →
  bindTC (buildLoci (partitionPool entries) expanded) quoteTC

-- Generator-sliced form: probe only the given generators against the
-- full pool.  Quadratic probing accumulates un-collectable TC state, so
-- one process cannot hold the whole grid; slices materialize the same
-- loci value shard by shard, one bounded process each, and the shards
-- concatenate to exactly buildLoci pool pool.
materializeLociForTerm : List Name → List Name → TC Term
materializeLociForTerm gens ns =
  bindTC (expandAll ns) λ expanded →
  bindTC (preparePool expanded) λ entries →
  bindTC (expandAll gens) λ egens →
  bindTC (buildLoci (partitionPool entries) egens) quoteTC

-- Pool preparation itself retains typechecker state per reflection
-- call (36k names × 4 calls exhausts the heap before any probing), so
-- the classified pool is materialized ONCE, in chunks, as a checked
-- value; shards consume it as data and pay no reflection for it.
materializePoolTerm : List Name → TC Term
materializePoolTerm ns =
  bindTC (expandAll ns) λ expanded →
  bindTC (preparePool expanded) quoteTC

buildLociOver : List PoolEntry → List Name → TC Term
buildLociOver entries gens =
  bindTC (expandAll gens) λ egens →
  bindTC (buildLoci (partitionPool entries) egens) quoteTC

-- The compile-time evaluator does not reliably share the partitioned
-- pool between generators, so the partition is evaluated ONCE and
-- stored as a checked literal; shards then only walk data.
buildLociOverPool : Pool → List Name → TC Term
buildLociOverPool pool gens =
  bindTC (expandAll gens) λ egens →
  bindTC (buildLoci pool egens) quoteTC

macro
  materializeLoci : List Name → Term → TC ⊤
  materializeLoci ns hole = bindTC (materializeLociTerm ns) (unify hole)

  materializeLociFor : List Name → List Name → Term → TC ⊤
  materializeLociFor gens ns hole =
    bindTC (materializeLociForTerm gens ns) (unify hole)

  materializePool : List Name → Term → TC ⊤
  materializePool ns hole = bindTC (materializePoolTerm ns) (unify hole)

  materializeLociOver : List PoolEntry → List Name → Term → TC ⊤
  materializeLociOver entries gens hole =
    bindTC (buildLociOver entries gens) (unify hole)

  materializePartitioned : List PoolEntry → Term → TC ⊤
  materializePartitioned entries hole =
    bindTC (quoteTC (partitionPool entries)) (unify hole)

  materializeLociOverPool : Pool → List Name → Term → TC ⊤
  materializeLociOverPool pool gens hole =
    bindTC (buildLociOverPool pool gens) (unify hole)
