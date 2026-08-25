{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.AdaptiveProbeCollapse
--
-- THE ADAPTIVE OBSERVER, IN THE BARE-POOL REGISTER, IN BOTH DIRECTIONS.
--
-- `notes/SIXTEEN_MINDS_ONE_THEOREM.md` §2 open door 1 claims that "every
-- observer class this corpus has formalized is provably STATIC" and that the
-- genuinely adaptive observer is "the one apparatus class not yet proven to
-- annihilate the charged sector".  That claim is FALSE as stated, and
-- `notes/ADAPTIVE_OBSERVERS_ARE_ALREADY_FENCED.md` documents the refutation:
-- `NaturalMachine.AdaptiveResidualAdapter` (this same directory) already
-- proves the collapse in the Moore-machine register
-- (`futureEq-adaptiveIso`), and ~22 `formal/pairfield/Pairfield/Adaptive*`
-- modules already carry the cost side, including two checked strict gaps
-- (`AdaptiveObservableHorizon.uniform_one_adaptive_two`,
--  `LinearAdaptiveGap.exact_linear_gap`).
--
-- What was genuinely absent, and is supplied here, is the same pair of
-- statements in the register the law of §1 is actually stated in: a BARE
-- PROBE POOL with no dynamics, no alphabet, no `step`, no Moore output, and
-- an arbitrary outcome type.  That is the register of
-- `notes/GTER_REVELATION_AND_THE_TWO_COORDINATE_DEFECT.md` §1, whose
-- Corollary 1.2 names adaptivity as invisible to the revelation cost and
-- whose scope fence §7.5 says "the adaptive quantity is named, not built".
-- This module builds it.
--
-- §1  (general, no finiteness anywhere)
--     `collapse`      -- every adaptive strategy's transcript is constant on
--                        the static full-pool indistinguishability class.
--     `indist→adaptive` / `adaptive→indist`
--                     -- the two kernels are EQUAL, not merely nested: the
--                        adaptive observer's kernel is the static full-pool
--                        kernel.  The hard direction is `collapse`; the easy
--                        one is witnessed by the depth-one strategies.
--     `collapse-seeded`
--                     -- randomised adaptivity collapses too, seedwise, for
--                        an arbitrary seed type.
--     `noAdaptiveDescent`
--                     -- THE CHARGED-SECTOR STATEMENT.  If a functional `f`
--                        separates an indistinguishable pair, then NO
--                        adaptive strategy at ANY depth, composed with ANY
--                        decoder, computes `f`.  "No post-processing of the
--                        quotient manufactures the fiber", now for adaptive
--                        observers.
--
-- §2  (finite, refl-checkable) THE FENCE IS ON THE OTHER COORDINATE.
--     Four states, three probes, budget two.
--     `adaptive-budget-2-identifies`  -- one depth-2 adaptive strategy
--                                        recovers the state exactly.
--     `static-budget-2-fails`         -- EVERY static 2-probe observer, all
--                                        nine of them, collides a pair.
--     `static-budget-3-identifies`    -- and the whole pool does separate,
--                                        so §2 never contradicts §1: what
--                                        adaptivity bought is BUDGET, never
--                                        visibility.
--
-- CONCLUSION, which is the fence this module draws.  Adaptivity is free with
-- respect to what is SEEN (§1: exact kernel equality, no hypotheses) and is
-- NOT free with respect to what is PAID (§2: a strict budget separation at
-- the smallest shape that carries it).  The corpus's law extends verbatim to
-- adaptive observers; the coordinate on which adaptivity is a real gain is
-- the one the law never spoke about.
--
-- CHECKED ON THE PIN.  `formal/cubical/check.sh` with
-- NM_MODULES="NaturalMachine/AdaptiveProbeCollapse.agda" prints
-- "RUNNING AGAINST THE PIN", names agda 2.8.0 at /root/Agda-2.8.0/... and
-- cubical at /root/agda-libs/cubical-v0.9, reports EXIT=0 for this module,
-- and its own CHECKSH_EXIT is 0.  This is a PIN green, not a container
-- green: as of 2026-08-19 this container reaches the declared pin, which
-- `notes/MY_GREENS_THIS_SESSION_ARE_CONTAINER_GREENS.md` (same day, earlier)
-- reports as unreachable -- that note's finding is superseded by the
-- toolchain, not by any argument, and its method stands.
-- No postulates, no holes, no `--guardedness`, no `native_decide` analogue.
------------------------------------------------------------------------

module NaturalMachine.AdaptiveProbeCollapse where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool
  using (Bool ; true ; false ; not ; _and_ ; if_then_else_ ; true≢false)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- §1  The general theorem.  No finiteness, no decidability, no dynamics.
------------------------------------------------------------------------

module Pool
    {ℓX ℓO ℓY : Level}
    (X : Type ℓX) (O : Type ℓO) (Y : Type ℓY)
    (out : O → X → Y)
  where

  -- The closed observation class is the pool `O`.  What it sees is exactly
  -- this quotient: GTER §7.1's `E(𝒪) = ⋂_{o} kerpair(o)`.
  Indist : X → X → Type (ℓ-max ℓO ℓY)
  Indist x x' = (o : O) → out o x ≡ out o x'

  -- An adaptive strategy of depth n.  The point of the `Y →` is that the
  -- NEXT probe is chosen from the LAST OUTCOME: `ask o k` fires `o`, reads
  -- `y`, and continues with the strategy `k y`.  A static observer is the
  -- special case where every `k` is constant.
  data Strategy : ℕ → Type (ℓ-max ℓO ℓY) where
    stop : Strategy zero
    ask  : {n : ℕ} → O → (Y → Strategy n) → Strategy (suc n)

  -- The transcript: the outcomes actually returned, in order.
  run : {n : ℕ} → Strategy n → X → List Y
  run stop      x = []
  run (ask o k) x = out o x ∷ run (k (out o x)) x

  ----------------------------------------------------------------
  -- Theorem A (the collapse).  The adaptive transcript is a function of
  -- the static full-pool quotient.  The whole content is the interpolation
  -- `k (e o i)`: the strategy's own branching is transported along the
  -- outcome path, which is possible precisely because the strategy reads
  -- nothing but outcomes.
  ----------------------------------------------------------------
  collapse : {n : ℕ} (s : Strategy n) {x x' : X}
    → Indist x x' → run s x ≡ run s x'
  collapse stop      e   = refl
  collapse (ask o k) e i = e o i ∷ collapse (k (e o i)) e i

  indist→adaptive : {x x' : X} → Indist x x'
    → {n : ℕ} (s : Strategy n) → run s x ≡ run s x'
  indist→adaptive e s = collapse s e

  -- The converse, so that the two kernels are EQUAL rather than nested.
  probeStrategy : O → Strategy (suc zero)
  probeStrategy o = ask o (λ _ → stop)

  firstOutcome : Y → List Y → Y
  firstOutcome d []      = d
  firstOutcome _ (y ∷ _) = y

  adaptive→indist : {x x' : X}
    → ({n : ℕ} (s : Strategy n) → run s x ≡ run s x') → Indist x x'
  adaptive→indist {x = x} h o =
    cong (firstOutcome (out o x)) (h (probeStrategy o))

  ----------------------------------------------------------------
  -- Randomised / externally seeded adaptivity buys nothing either: the
  -- collapse holds for each seed, and the seed type is arbitrary.  So a
  -- coin, an oracle, or a whole prior history of side advice cannot help,
  -- as long as the PROBES come from the pool.
  ----------------------------------------------------------------
  collapse-seeded : {ℓS : Level} {S : Type ℓS} {n : ℕ}
    → (σ : S → Strategy n) {x x' : X} → Indist x x'
    → (s : S) → run (σ s) x ≡ run (σ s) x'
  collapse-seeded σ e s = collapse (σ s) e

  ----------------------------------------------------------------
  -- Theorem A′ (the charged sector).  This is the statement the law of
  -- `SIXTEEN_MINDS_ONE_THEOREM` §1 makes, with "closed observation class"
  -- read as "adaptive strategies over the pool".
  ----------------------------------------------------------------
  noAdaptiveDescent :
      {ℓA : Level} {A : Type ℓA} (f : X → A) (x x' : X)
    → Indist x x' → ¬ (f x ≡ f x')
    → {n : ℕ} (s : Strategy n) (decode : List Y → A)
    → ¬ ((z : X) → decode (run s z) ≡ f z)
  noAdaptiveDescent f x x' e charged s decode sound =
    charged
      ( sym (sound x)
      ∙ cong decode (collapse s e)
      ∙ sound x' )

------------------------------------------------------------------------
-- §2  The fence: a strict budget separation at the smallest shape.
--
-- States are the four Boolean pairs.  Probes: `bit` reads the first
-- coordinate; `pinT` fires only at (true , true); `pinF` only at
-- (false , true).
------------------------------------------------------------------------

St : Type₀
St = Bool × Bool

data Probe : Type₀ where
  bit  : Probe
  pinT : Probe
  pinF : Probe

out3 : Probe → St → Bool
out3 bit  z = fst z
out3 pinT z = fst z and snd z
out3 pinF z = (not (fst z)) and snd z

module G = Pool St Probe Bool out3

------------------------------------------------------------------------
-- 2.1  One depth-two adaptive strategy identifies all four states.
------------------------------------------------------------------------

-- Read the first bit, then choose WHICH pin to fire based on what came
-- back.  This is exactly "next probe chosen from last outcome"; the choice
-- is not available to any static observer of the same budget.
adaptiveTree : G.Strategy 2
adaptiveTree =
  G.ask bit
    (λ b → if b then G.ask pinT (λ _ → G.stop)
                else G.ask pinF (λ _ → G.stop))

decodeTree : List Bool → St
decodeTree (b ∷ c ∷ _) = b , c
decodeTree _           = false , false

adaptive-budget-2-identifies : (z : St) → decodeTree (G.run adaptiveTree z) ≡ z
adaptive-budget-2-identifies (false , false) = refl
adaptive-budget-2-identifies (false , true)  = refl
adaptive-budget-2-identifies (true  , false) = refl
adaptive-budget-2-identifies (true  , true)  = refl

------------------------------------------------------------------------
-- 2.2  No static two-probe observer identifies all four states.
------------------------------------------------------------------------

staticPair : Probe → Probe → St → Bool × Bool
staticPair p q z = out3 p z , out3 q z

-- The colliding pair, exhibited as an explicit function of the probe pair.
-- Nine cases, no search, no quantifier over strategies left implicit.
clashL clashR : Probe → Probe → St

clashL bit  bit  = true  , true
clashL bit  pinT = false , true
clashL bit  pinF = true  , true
clashL pinT bit  = false , true
clashL pinT pinT = true  , false
clashL pinT pinF = true  , false
clashL pinF bit  = true  , true
clashL pinF pinT = true  , false
clashL pinF pinF = true  , true

clashR bit  bit  = true  , false
clashR bit  pinT = false , false
clashR bit  pinF = true  , false
clashR pinT bit  = false , false
clashR pinT pinT = false , false
clashR pinT pinF = false , false
clashR pinF bit  = true  , false
clashR pinF pinT = false , false
clashR pinF pinF = true  , false

private
  tt≢tf : ¬ (Path St (true , true) (true , false))
  tt≢tf p = true≢false (cong snd p)

  ft≢ff : ¬ (Path St (false , true) (false , false))
  ft≢ff p = true≢false (cong snd p)

  tf≢ff : ¬ (Path St (true , false) (false , false))
  tf≢ff p = true≢false (cong fst p)

clash-distinct : (p q : Probe) → ¬ (clashL p q ≡ clashR p q)
clash-distinct bit  bit  = tt≢tf
clash-distinct bit  pinT = ft≢ff
clash-distinct bit  pinF = tt≢tf
clash-distinct pinT bit  = ft≢ff
clash-distinct pinT pinT = tf≢ff
clash-distinct pinT pinF = tf≢ff
clash-distinct pinF bit  = tt≢tf
clash-distinct pinF pinT = tf≢ff
clash-distinct pinF pinF = tt≢tf

clash-collides : (p q : Probe)
  → staticPair p q (clashL p q) ≡ staticPair p q (clashR p q)
clash-collides bit  bit  = refl
clash-collides bit  pinT = refl
clash-collides bit  pinF = refl
clash-collides pinT bit  = refl
clash-collides pinT pinT = refl
clash-collides pinT pinF = refl
clash-collides pinF bit  = refl
clash-collides pinF pinT = refl
clash-collides pinF pinF = refl

-- Every static observer of budget two, including the ones that spend both
-- queries on the same probe, fails.
static-budget-2-fails : (p q : Probe)
  → Σ[ u ∈ St ] Σ[ v ∈ St ]
      ((¬ (u ≡ v)) × (staticPair p q u ≡ staticPair p q v))
static-budget-2-fails p q =
  clashL p q , clashR p q , clash-distinct p q , clash-collides p q

------------------------------------------------------------------------
-- 2.3  The pool itself does separate.  So §2 is a statement about BUDGET
--      and never about visibility, and §1 is not contradicted: the
--      adaptive strategy reached the pool's own quotient sooner, never
--      past it.
------------------------------------------------------------------------

staticTriple : St → Bool × Bool × Bool
staticTriple z = out3 bit z , out3 pinT z , out3 pinF z

decodeTriple : Bool × Bool × Bool → St
decodeTriple (b , t , f) = b , (if b then t else f)

static-budget-3-identifies : (z : St) → decodeTriple (staticTriple z) ≡ z
static-budget-3-identifies (false , false) = refl
static-budget-3-identifies (false , true)  = refl
static-budget-3-identifies (true  , false) = refl
static-budget-3-identifies (true  , true)  = refl

-- Consequently the pool's indistinguishability relation on this carrier is
-- trivial, and by §1 there is no charged functional here to annihilate --
-- which is the correct reading of §2: it is a COST theorem, and the fence
-- it draws is on the cost coordinate only.
pool-separates : (x x' : St) → G.Indist x x' → x ≡ x'
pool-separates x x' e =
  sym (static-budget-3-identifies x)
  ∙ cong decodeTriple (λ i → e bit i , e pinT i , e pinF i)
  ∙ static-budget-3-identifies x'

------------------------------------------------------------------------
-- §3  The two halves, side by side, as one term.
------------------------------------------------------------------------

-- Adaptivity is free in visibility and strictly not free in budget.
-- (The first conjunct is stated at `Type₀` only because a `Level`-quantified
-- component has no fixed sort and so cannot sit inside a `_×_`; the general
-- statement is `Pool.noAdaptiveDescent` above, and that is the theorem.)
adaptivity-is-budget-not-visibility :
    ( {A : Type₀} (f : St → A) (x x' : St)
      → G.Indist x x' → ¬ (f x ≡ f x')
      → {n : ℕ} (s : G.Strategy n) (decode : List Bool → A)
      → ¬ ((z : St) → decode (G.run s z) ≡ f z) )
  × ( ((z : St) → decodeTree (G.run adaptiveTree z) ≡ z)
      × ((p q : Probe) → Σ[ u ∈ St ] Σ[ v ∈ St ]
            ((¬ (u ≡ v)) × (staticPair p q u ≡ staticPair p q v))) )
adaptivity-is-budget-not-visibility =
  G.noAdaptiveDescent ,
  adaptive-budget-2-identifies ,
  static-budget-2-fails
