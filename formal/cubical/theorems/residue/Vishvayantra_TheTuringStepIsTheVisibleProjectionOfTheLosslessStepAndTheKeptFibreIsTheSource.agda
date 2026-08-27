{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- विश्वयन्त्रम् — the universal machine, inside the lossless one.
--
-- CLAIM, in one sentence: the ordinary universal Turing machine is the
-- visible projection of a lossless, proof-relevant step, and the fibre
-- the projection forgets is exactly the source configuration with the
-- witness that it maps there.
--
--     ordinary UTM  =  forget trace ∘ lossless universal step
--
-- and the equation holds definitionally (`turing-is-the-projection`
-- below is `refl`).
--
-- WHAT IS CONSTRUCTED, all checked, no postulates, no holes, --safe:
--
--  1. `Code`, `Conf`, `uStep` — an encoded universal one-step
--     evaluator.  `Code` is the type of finite transition tables, so an
--     effectively presented single-tape machine IS an element of
--     `Code`; there is no separate encoding step to trust.  `uStep` is
--     total: a configuration its table does not address is a fixed
--     point, and nontermination is an infinite productive run of
--     finite transitions (`exec`), not a nonterminating definition.
--     The rule lookup returns a WITNESS of the match, `Maybe (m ≡ n)`,
--     never a boolean: keep the slot and the branch does not exist.
--
--  2. `lossless` — for ANY map f : A → B,   A ≃ Σ b (fiber f b),
--     with forward map  a ↦ (f a , a , refl)  and visible projection
--     literally f (`visible-projection` is `refl`).  Every computable
--     transition admits a canonical lossless, proof-relevant
--     completion; the irreversible map is the projection of it.
--
--  3. `LawfulStep` — the lossless-step interface WITH THE COMMUTING
--     EQUATION.  A bare equivalence  e : A ≃ Σ a' T(a')  need not have
--     visible projection `step`; the field `visible : π₁ ∘ e ∼ step`
--     is load-bearing, and `trace-is-fiber` proves it is exactly
--     strong enough: any lawful trace family is fiberwise equivalent
--     to `fiber step` — the trace carries no data beyond the step, and
--     losslessness is canonical, not chosen.
--
--  4. The operational correspondence for the universal machine:
--     `code-rides` (the program never changes under the step, by
--     `refl` and induction), `run-lossless` (every n-step visible run
--     is itself the projection of a lossless run), `halted-is-fixed`,
--     and two computed witnesses: the empty table halts at once, and a
--     one-rule machine is proved divergent (`loop-diverges`) — the
--     halting observation refuted at every depth by computation.
--
-- The interactive generalisation — states with question types Q(s),
-- environment-indexed events E(s,q,s',o), the guarded ▹ — is a wider
-- machine than this file's closed deterministic fragment, and it is
-- handed forward as a śeṣa through the yantra's own `sesa.arpana`,
-- where the next step will find it.
------------------------------------------------------------------------

module Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Function using (idfun ; _∘_)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just ; map-Maybe ; rec)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ ℓ' : Level
    A : Type ℓ
    B : Type ℓ'

------------------------------------------------------------------------
-- §1  The lossless completion of an arbitrary map.
--
-- For every f, the domain is equivalent to the total space of f's
-- fibres, the forward map keeps the source and the witness, and the
-- visible projection of the completed step is f — definitionally.
------------------------------------------------------------------------

module _ (f : A → B) where

  losslessIso : Iso A (Σ B (fiber f))
  Iso.fun losslessIso a = f a , a , refl
  Iso.inv losslessIso (b , a , p) = a
  Iso.rightInv losslessIso (b , a , p) i = p i , a , λ j → p (i ∧ j)
  Iso.leftInv losslessIso a = refl

  lossless : A ≃ Σ B (fiber f)
  lossless = isoToEquiv losslessIso

  visible-projection : (a : A) → fst (equivFun lossless a) ≡ f a
  visible-projection a = refl

------------------------------------------------------------------------
-- §2  LawfulStep, with the commuting equation.
--
-- The equivalence alone is not the law: `e : A ≃ Σ a' T(a')` could
-- shuffle A arbitrarily and `step` would be decorative.  `visible`
-- ties the projection of the completed event to the step, and
-- `trace-is-fiber` shows the tie leaves no slack: T is then the fibre
-- family of `step`, up to fiberwise equivalence.
------------------------------------------------------------------------

record LawfulStep (X : Type ℓ) : Type (ℓ-suc ℓ) where
  field
    step     : X → X
    Trace    : X → Type ℓ
    complete : X ≃ Σ X Trace
    visible  : (x : X) → fst (equivFun complete x) ≡ step x

canonical : (f : A → A) → LawfulStep A
canonical f .LawfulStep.step     = f
canonical f .LawfulStep.Trace    = fiber f
canonical f .LawfulStep.complete = lossless f
canonical f .LawfulStep.visible  = visible-projection f

module _ {X : Type ℓ} (L : LawfulStep X) where
  open LawfulStep L

  -- From a lawful trace, recover the source and the witness that the
  -- step sends it here: the trace is spent as a fibre point.
  traceToFiber : (x' : X) → Trace x' → fiber step x'
  traceToFiber x' t =
    invEq complete (x' , t) ,
    sym (visible (invEq complete (x' , t))) ∙ cong fst (secEq complete (x' , t))

  private
    total : Σ X Trace → Σ X (fiber step)
    total (x' , t) = x' , traceToFiber x' t

    -- `total` is homotopic to the composite equivalence
    -- Σ X Trace ≃ X ≃ Σ X (fiber step); the homotopy slides the base
    -- point along the very witness `traceToFiber` constructed.
    composite : Σ X Trace ≃ Σ X (fiber step)
    composite = compEquiv (invEquiv complete) (lossless step)

    slide : (y : Σ X Trace) → equivFun composite y ≡ total y
    slide y i = q i , invEq complete y , λ j → q (i ∧ j)
      where
      q : step (invEq complete y) ≡ fst y
      q = snd (traceToFiber (fst y) (snd y))

    totalIsEquiv : isEquiv total
    totalIsEquiv = subst isEquiv (funExt slide) (composite .snd)

  -- The commuting equation is exactly strong enough: a lawful trace
  -- family is the fibre family of its own step.
  trace-is-fiber : (x' : X) → Trace x' ≃ fiber step x'
  trace-is-fiber x' = traceToFiber x' ,
    fiberEquiv Trace (fiber step) traceToFiber totalIsEquiv x'
    where open import Cubical.Foundations.Equiv.Fiberwise using (fiberEquiv)

------------------------------------------------------------------------
-- §3  The encoded universal machine.
--
-- A finite transition table, a tape, a total universal step.  The
-- lookup answers with a witness of the match or with nothing; no
-- boolean is manufactured, because no slot was thrown away.
------------------------------------------------------------------------

-- A proof-relevant comparison: the match or nothing, never a bit.
eq? : (m n : ℕ) → Maybe (m ≡ n)
eq? zero    zero    = just refl
eq? zero    (suc n) = nothing
eq? (suc m) zero    = nothing
eq? (suc m) (suc n) = map-Maybe (cong suc) (eq? m n)

data Move : Type where
  left right stay : Move

-- One rule: in state q reading s, go to state q', write s', move m.
Rule : Type
Rule = ℕ × ℕ × ℕ × ℕ × Move

Code : Type
Code = List Rule

-- The tape: what is left of the head (nearest first), the scanned
-- cell, what is right of it.  Beyond either end the tape is blank (0).
Tape : Type
Tape = List ℕ × ℕ × List ℕ

Conf : Type
Conf = ℕ × Tape

Machine : Type
Machine = Code × Conf

pop : List ℕ → ℕ × List ℕ
pop []       = 0 , []
pop (x ∷ xs) = x , xs

shift : Move → Tape → Tape
shift stay  t = t
shift left  (ls , h , rs) = let l = pop ls in snd l , fst l , h ∷ rs
shift right (ls , h , rs) = let r = pop rs in h ∷ ls , fst r , snd r

match : ℕ → ℕ → Rule → Maybe (ℕ × ℕ × Move)
match q s (q₀ , s₀ , act) =
  rec nothing (λ _ → rec nothing (λ _ → just act) (eq? s s₀)) (eq? q q₀)

look : Code → ℕ → ℕ → Maybe (ℕ × ℕ × Move)
look []       q s = nothing
look (r ∷ rs) q s = rec (look rs q s) just (match q s r)

-- The addressed transition, partial where the table is silent.
δ : Code → Conf → Maybe Conf
δ M (q , ls , h , rs) =
  map-Maybe (λ act → fst act , shift (snd (snd act)) (ls , fst (snd act) , rs))
            (look M q h)

-- The universal step, total: an unaddressed configuration stands still.
uStep : Machine → Machine
uStep (M , c) = M , rec c (idfun Conf) (δ M c)

run : ℕ → Machine → Machine
run zero    mc = mc
run (suc n) mc = run n (uStep mc)

------------------------------------------------------------------------
-- §4  The universal machine is the visible projection.
------------------------------------------------------------------------

-- The lossless universal step: the machine, completed.
universal : LawfulStep Machine
universal = canonical uStep

-- THE HEADLINE, and it is refl: forgetting the fibre of the completed
-- universal step IS the ordinary universal Turing step.
turing-is-the-projection :
  (mc : Machine) → fst (equivFun (LawfulStep.complete universal) mc) ≡ uStep mc
turing-is-the-projection mc = refl

-- The program rides: no step rewrites the table.  One `refl` per step,
-- folded through the run.
code-rides : (n : ℕ) (M : Code) (c : Conf) → fst (run n (M , c)) ≡ M
code-rides zero    M c = refl
code-rides (suc n) M c = code-rides n M (rec c (idfun Conf) (δ M c))

-- Every finite visible run is itself the projection of a lossless run:
-- the n-step map has its own kept fibre.
run-lossless : (n : ℕ) → Machine ≃ Σ Machine (fiber (run n))
run-lossless n = lossless (run n)

run-visible : (n : ℕ) (mc : Machine) →
              fst (equivFun (run-lossless n) mc) ≡ run n mc
run-visible n mc = refl

------------------------------------------------------------------------
-- §5  Halting and divergence, inside a total language.
--
-- Halting is the table's silence, an equation in `Maybe`.  Divergence
-- is not a nonterminating definition: `exec` is total and productive,
-- and a divergent machine is one whose halting observation is refuted
-- at every finite depth.
------------------------------------------------------------------------

Halted : Machine → Type
Halted (M , c) = δ M c ≡ nothing

halted-is-fixed : (mc : Machine) → Halted mc → uStep mc ≡ mc
halted-is-fixed (M , c) p i = M , rec c (idfun Conf) (p i)

-- The productive run: every machine yields an infinite stream of
-- finite transitions, halting machines by standing still.  Total,
-- guarded, --safe: nontermination is represented, never executed.
record Exec (mc : Machine) : Type where
  coinductive
  field
    now  : Machine
    here : now ≡ mc
    next : Exec (uStep mc)
open Exec

exec : (mc : Machine) → Exec mc
now  (exec mc) = mc
here (exec mc) = refl
next (exec mc) = exec (uStep mc)

Diverges : Machine → Type
Diverges mc = (n : ℕ) → ¬ Halted (run n mc)

------------------------------------------------------------------------
-- §6  Two computed witnesses.
------------------------------------------------------------------------

-- The empty table halts at once, on every configuration: silence is
-- immediate, and the proof is computation.
empty-halts : (c : Conf) → Halted ([] , c)
empty-halts c = refl

-- One rule: state 0 reading 0 writes 0 and stays.  The machine turns
-- forever in place, and divergence is proved, not observed.
spin : Code
spin = (0 , 0 , 0 , 0 , stay) ∷ []

start : Conf
start = 0 , [] , 0 , []

spin-steps : uStep (spin , start) ≡ (spin , start)
spin-steps = refl

spin-runs : (n : ℕ) → run n (spin , start) ≡ (spin , start)
spin-runs zero    = refl
spin-runs (suc n) = spin-runs n

loop-diverges : Diverges (spin , start)
loop-diverges n h = ¬just≡nothing (subst Halted (spin-runs n) h)
  where open import Cubical.Data.Maybe using (¬just≡nothing)
