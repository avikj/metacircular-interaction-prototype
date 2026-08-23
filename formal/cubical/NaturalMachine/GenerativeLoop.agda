{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.GenerativeLoop
--
-- The obstruction-indexed proposer, ITERATED, and the proof that the
-- iteration makes progress.  This is the exact converse of
-- `Obstruction.frequency-cannot-reach` / `Obstruction.plateau`:
--
--   * the frequency proposer is closed under "already built", so a chain
--     of its proposals leaves the matcher EQUAL (`plateau`, T7-T8);
--   * a chain of obstruction-indexed proposals cannot leave the matcher
--     equal (`anti-plateau`, A2 below) — and it terminates on any target
--     (`generative-loop`, B4 below), within a bound that is a measure of
--     the target, not a hope.
--
-- Source of the design: `runtime/vocabulary/README.md` §7 — a proposer
-- driven by the residual of a *failed* match, reading why the matcher
-- failed and naming exactly the missing structure.  The loop modelled
-- here is that sentence made operational: (i) attempt a match, (ii) read
-- the residual of the failure, (iii) name the missing head, repeat.
--
-- Substrate: exactly `NaturalMachine.Obstruction`'s (unary constructor
-- terms `Tm`, vocabularies as lists of head shapes, `Matches`, `Over`,
-- `Obstruction`, `propose`, `ObsChain`).  Nothing new is axiomatised.
--
--
-- WHAT IS CHECKED
--
-- A. The anti-plateau theorems (task item 1).
--
--   A1 `obs-step-strict`      one obstruction step cannot leave the
--                             matcher equal:
--                             ¬ (Matches (extend V o) ≡ Matches V).
--                             Pointwise converse of `extend-absorbed`.
--   A2 `anti-plateau`         no obstruction chain whose FIRST step is a
--                             named obstruction leaves it equal:
--                             ObsChain (extend V o) W → ¬ (Matches W ≡ Matches V).
--   A2′ `anti-plateau-step`   the same for chains presented as `ObsChain`
--                             presents them, i.e. by their LAST step —
--                             which is what "any chain through at least
--                             one step" actually requires, since a
--                             nonempty `ObsChain V X` is `step ch o`.
--                             Together A2 and A2′ are the converse of
--                             `plateau`.
--   A3 `obstruction-reaches`  such a chain matches the stuck term, at
--                             every later stage (monotonicity, A0).
--   A4 `obstruction-beats-frequency`
--                             the §7 sentence as one term: for every
--                             obstruction, NO frequency chain of any
--                             length matches its stuck term, and SOME
--                             obstruction chain does.
--
-- B. The measure and the loop (task item 2).
--
--   The measure is relative to a TARGET term t — the thing the loop is
--   trying to become able to talk about:
--
--     deficit V t = the number of node positions of t whose head is not
--                   installed in V.
--
--   B0 `Over→deficit0`, `deficit0→Over`
--                             the measure is faithful: deficit V t ≡ 0
--                             exactly when V covers t.  (Without this
--                             pair the measure would be decoration.)
--   B1 `deficit-split`        deficit V t ≡ gaps s V t + deficit (s ∷ V) t
--                             — installing s removes exactly the
--                             s-labelled gaps and nothing else.
--   B2 `generative-step`      THE STEP FUNCTION: for every V and every
--                             target t, either V already covers t, or
--                             the loop produces an obstruction o at V —
--                             read off the innermost uncovered head of t
--                             — TOGETHER WITH a proof that
--                             deficit (extend V o) t < deficit V t.
--                             Strictly decreasing, checked, on every
--                             obstruction step the loop takes.
--   B3 `loop`                 fuelled iteration: deficit V t ≤ f gives a
--                             chain of at most f obstruction-proposals
--                             after which the target is covered.
--   B4 `generative-loop`      TERMINATION, unconditional: for every V
--                             and every t there is W, an ObsChain V W of
--                             length ≤ deficit V t, and Over W t.  The
--                             loop does not stall, and the number of
--                             steps is bounded by the target's measure.
--
--   B4 strengthens `Obstruction.obs-complete` (which is a structural
--   recursion with no measure and no step bound) to a measure-driven
--   iteration with an explicit bound.
--
-- C. Composition with the acceptance test (task item 3).
--
--   In `module Compile (k : ℕ) (checkpoint : Shape)`:
--
--   C1 `generated-definition-conservative`
--                             every generated definition eliminates
--                             (`propose-eliminable`, restated at the
--                             loop's step).
--   C2 `generated-step-improves`
--                             ONE checked chain: if the obstruction the
--                             loop reads names the `checkpoint`
--                             capability, then in one step the
--                             vocabulary-indexed compiler `compile`
--                             flips from `restart` to `resume`; the
--                             flipped-to program executes to the SAME
--                             digit word (`AcceptanceTest.replay`) at
--                             STRICTLY smaller counted cost
--                             (`AcceptanceTest.resume-cheaper`); and the
--                             generated definition is conservative
--                             (C1) while the stuck term goes from
--                             unmatched to matched.
--                             The flip itself is `cong` applied to the
--                             obstruction's `failed` field, given the
--                             stipulated `compile`; the content of C2 is
--                             the imported acceptance test and C1, not
--                             the flip.
--   C3 `compile-improves`     C2's hypothesis discharged: whenever the
--                             capability is absent, an obstruction
--                             naming it exists, is the record the probe
--                             builds on `node checkpoint var`, and
--                             strictly decreases that target's measure.
--                             C2 is therefore not vacuous.  C3 does not
--                             derive the interface — the target is
--                             chosen to contain the head.
--
--
-- WHAT IS DELIBERATELY NOT CLAIMED
--
--  * `compile` is a STIPULATED compilation rule (a definition in §C,
--    three lines), not a derived one.  The theorem is not "generation
--    discovers the resume plan"; it is: *given* a compiler that consults
--    the vocabulary for the checkpoint capability, one obstruction-
--    indexed step is what flips its branch, and the branch it flips to is
--    replay-equal at strictly smaller cost.  Both halves of the flip
--    (equality of answers, strict cost drop) are the acceptance test's
--    closed proofs, imported, not re-measured.
--  * No claim that the two substrates are unified.  §C composes two
--    checked facts about two different objects (a vocabulary and a
--    digit-word execution plan) through one stipulated interface; it does
--    not exhibit `Tm` terms compiling to `Plan`s.
--  * No optimality: `chainLen ch ≤ deficit V t` is a bound, not a minimum,
--    and nothing here says the loop's choice of innermost-first is best.
--  * The witness policy used HERE is still degenerate (`witness = var`,
--    as in `Obstruction.obs-complete` and in `probe`): the bodies this
--    module generates abbreviate the parameter.  C1 holds for any base
--    witness.  An informative policy is proved in
--    `NaturalMachine.WitnessPolicy`; this module does not use it.
--  * The progress half and the definitional half never meet.  A0-B4 —
--    monotonicity, anti-plateau, the measure, the step function, the
--    termination bound — mention `residual` and nothing else: not
--    `witness`, not `body`, not `unfold`.  Every one of those theorems
--    holds verbatim for a proposer that installs a head and generates no
--    definition at all.  What is checked is that naming what failed makes
--    coverage progress; that the naming is a legitimate definitional
--    extension is C1, proved beside it, not used by it.
--  * "Conservative" here is `Obstruction`'s T2 sense — eliminability
--    from `Over` — not conservativity of an equational theory; no
--    provability relation is modelled.  Likewise `generative-loop-
--    complete` is coverage, not completeness of a deductive system.
--  * C3 discharges C2's hypothesis but not its interest: it shows an
--    obstruction naming the checkpoint EXISTS whenever the capability is
--    absent, on a target chosen to contain that head.  Nothing says a
--    task's real target contains it, and `compile` remains stipulated.
--  * `deficit` does not decrease on obstructions whose residual does not
--    occur in the target — it is unchanged (`no-gaps→no-decrease`, the
--    checked form of this sentence).  This is why the measure is indexed
--    by a target and why the loop only ever proposes residuals it read
--    off that target.  There is no global well-founded measure on
--    `Vocab` here and none is claimed.
--  * Everything inherited from `Obstruction`'s disclaimer stands:
--    single-parameter bodies, matching only at the root, no arity
--    structure in the residual, gates D2-D7 unmodelled.
--  * Nothing here measures, reproduces, or predicts the Python runtime in
--    `runtime/vocabulary/`.  It is a model of §7's mechanism, and the
--    plateau/anti-plateau pair is the part of §7 that is mathematics.
------------------------------------------------------------------------

module NaturalMachine.GenerativeLoop where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-suc ; +-assoc ; +-comm ; snotz ; m+n≡0→m≡0×n≡0)
open import Cubical.Data.Nat.Order using (_<_ ; _≤_ ; ≤-refl ; ≤-trans ; zero-≤ ; suc-≤-suc ; pred-≤-pred)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_ ; dichotomyBool)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.Obstruction
open Obstruction
open Extension

import NaturalMachine.AcceptanceTest

------------------------------------------------------------------------
-- A0.  Monotonicity along an obstruction chain.
--
-- Every step installs a head and installs nothing else, so what the
-- matcher could see, it still sees.  (`match-mono`, iterated.)
------------------------------------------------------------------------

ObsChain-mono : {V W : Vocab} → ObsChain V W → (t : Tm) → Matches V t → Matches W t
ObsChain-mono done         t m = m
ObsChain-mono (step ch o)  t m = match-mono _ (residual o) t (ObsChain-mono ch t m)

Over-chain-mono : {V W : Vocab} → ObsChain V W → (t : Tm) → Over V t → Over W t
Over-chain-mono done        t h = h
Over-chain-mono (step ch o) t h = Over-mono _ (residual o) t (Over-chain-mono ch t h)

------------------------------------------------------------------------
-- A1-A4.  The anti-plateau theorems.
--
-- `Obstruction.extend-absorbed` says: extension by an already-matched
-- head leaves `Matches` EQUAL as a function Tm → Type₀.  `plateau`
-- iterates that over a frequency chain.  Here is the exact converse for
-- the obstruction-indexed proposer: its step can never leave `Matches`
-- equal, because the stuck term is a point of difference — unmatched
-- before by `progress-before`, matched after by `progress-after`, and
-- matched at every later stage by A0.
------------------------------------------------------------------------

-- A1: pointwise converse of `extend-absorbed`.
obs-step-strict : (V : Vocab) (o : Obstruction V) → ¬ (Matches (extend V o) ≡ Matches V)
obs-step-strict V o p =
  progress-before V o
    (transport (cong (λ P → P (stuckTm o)) p) (progress-after V o))

-- A3: the stuck term stays matched, however long the chain runs on.
obstruction-reaches : (V : Vocab) (o : Obstruction V) {W : Vocab}
                    → ObsChain (extend V o) W → Matches W (stuckTm o)
obstruction-reaches V o ch = ObsChain-mono ch (stuckTm o) (progress-after V o)

-- A2: converse of `plateau`, in the form where the FIRST step is named.
anti-plateau : (V : Vocab) (o : Obstruction V) {W : Vocab}
             → ObsChain (extend V o) W → ¬ (Matches W ≡ Matches V)
anti-plateau V o ch p =
  progress-before V o
    (transport (cong (λ P → P (stuckTm o)) p) (obstruction-reaches V o ch))

-- A2′: the statement the header wants — ANY obstruction chain that takes
-- at least one step leaves the matcher different.  A2 alone does not say
-- this, because `ObsChain` grows at the RIGHT: a nonempty `ObsChain V X`
-- is literally `step ch o` with `o` an obstruction at the chain's END and
-- `X = extend W o`, whereas A2 names an obstruction at its START.  A2′
-- covers every nonempty chain by pattern, and the argument is the mirror
-- image: the last step's stuck term is unmatched at W, hence (by
-- monotonicity, contrapositive) unmatched at V, and matched after.
anti-plateau-step : {V W : Vocab} (ch : ObsChain V W) (o : Obstruction W)
                  → ¬ (Matches (extend W o) ≡ Matches V)
anti-plateau-step {V} {W} ch o p =
  progress-before W o
    (ObsChain-mono ch (stuckTm o)
      (transport (cong (λ P → P (stuckTm o)) p) (progress-after W o)))

-- A4: §7's sentence, both halves, one term.  For every obstruction: no
-- frequency chain of any length reaches its stuck term (Obstruction T8),
-- and some obstruction chain does (one step suffices).
obstruction-beats-frequency :
  (V : Vocab) (o : Obstruction V)
  → ({W : Vocab} → FreqChain V W → ¬ Matches W (stuckTm o))
  × (Σ[ W ∈ Vocab ] (ObsChain V W × Matches W (stuckTm o)))
obstruction-beats-frequency V o =
    (λ ch → frequency-cannot-reach V o ch)
  , extend V o , step done o , progress-after V o

------------------------------------------------------------------------
-- B.  The measure.
--
-- `deficit V t` counts the node positions of the target t whose head is
-- not installed in V: exactly the work the generative loop has left to
-- do on t.  `gaps s V t` counts those of them labelled s.
------------------------------------------------------------------------

delta : Vocab → Shape → ℕ
delta V c = if memb c V then 0 else 1

deficit : Vocab → Tm → ℕ
deficit V var        = 0
deficit V (node c u) = delta V c + deficit V u

gapAt : Shape → Vocab → Shape → ℕ
gapAt s V c = if eqℕ c s then delta V c else 0

gaps : Shape → Vocab → Tm → ℕ
gaps s V var        = 0
gaps s V (node c u) = gapAt s V c + gaps s V u

-- B0: the measure is faithful — zero exactly on covered targets.
Over→deficit0 : (V : Vocab) (t : Tm) → Over V t → deficit V t ≡ 0
Over→deficit0 V var        _         = refl
Over→deficit0 V (node c u) (hc , hu) =
  cong₂ _+_ (if≡true hc) (Over→deficit0 V u hu)

deficit0→Over : (V : Vocab) (t : Tm) → deficit V t ≡ 0 → Over V t
deficit0→Over V var        _ = tt
deficit0→Over V (node c u) p =
  head-covered (dichotomyBool (memb c V)) , deficit0→Over V u (snd split)
  where
  split : (delta V c ≡ 0) × (deficit V u ≡ 0)
  split = m+n≡0→m≡0×n≡0 p

  head-covered : (memb c V ≡ true) ⊎ (memb c V ≡ false) → memb c V ≡ true
  head-covered (inl e) = e
  head-covered (inr e) = Empty.rec (snotz (sym (if≡false e) ∙ fst split))

------------------------------------------------------------------------
-- B1.  Installing one head splits the measure exactly.
--
--   deficit V t  ≡  gaps s V t  +  deficit (s ∷ V) t
--
-- i.e. an installation removes precisely the gaps it names, and no
-- others.  This is the arithmetic converse of `memb-absorb`: there,
-- naming something already built changed nothing; here, naming something
-- missing subtracts exactly its own occurrences.
------------------------------------------------------------------------

private
  if-const : {A : Type₀} (b : Bool) (x : A) → (if b then x else x) ≡ x
  if-const true  x = refl
  if-const false x = refl

  shuffle : (a b c d : ℕ) → (a + b) + (c + d) ≡ (a + c) + (b + d)
  shuffle a b c d =
      sym (+-assoc a b (c + d))
    ∙ cong (a +_) (+-assoc b c d)
    ∙ cong (λ z → a + (z + d)) (+-comm b c)
    ∙ cong (a +_) (sym (+-assoc c b d))
    ∙ +-assoc a c (b + d)

delta-split : (s : Shape) (V : Vocab) (c : Shape)
            → delta V c ≡ gapAt s V c + delta (s ∷ V) c
delta-split s V c = covered? (dichotomyBool (memb c V))
  where
  -- membership in the extended vocabulary, unfolded by definition
  ext-true  : eqℕ c s ≡ true → memb c (s ∷ V) ≡ true
  ext-true  e = if≡true {x = true} {y = memb c V} e

  ext-false : eqℕ c s ≡ false → memb c (s ∷ V) ≡ memb c V
  ext-false e = if≡false {x = true} {y = memb c V} e

  covered? : (memb c V ≡ true) ⊎ (memb c V ≡ false)
           → delta V c ≡ gapAt s V c + delta (s ∷ V) c
  covered? (inl e) =
      if≡true e
    ∙ sym ( cong₂ _+_
              ( cong (λ z → if eqℕ c s then z else 0) (if≡true e)
              ∙ if-const (eqℕ c s) 0 )
              (if≡true (memb-mono c s V e)) )
  covered? (inr e) = same? (dichotomyBool (eqℕ c s))
    where
    same? : (eqℕ c s ≡ true) ⊎ (eqℕ c s ≡ false)
          → delta V c ≡ gapAt s V c + delta (s ∷ V) c
    same? (inl q) =
        if≡false e
      ∙ sym ( cong₂ _+_
                ( cong (λ z → if z then delta V c else 0) q ∙ if≡false e )
                (if≡true (ext-true q)) )
    same? (inr q) =
        if≡false e
      ∙ sym ( cong₂ _+_
                (cong (λ z → if z then delta V c else 0) q)
                (if≡false (ext-false q ∙ e)) )

deficit-split : (s : Shape) (V : Vocab) (t : Tm)
              → deficit V t ≡ gaps s V t + deficit (s ∷ V) t
deficit-split s V var        = refl
deficit-split s V (node c u) =
    cong₂ _+_ (delta-split s V c) (deficit-split s V u)
  ∙ shuffle (gapAt s V c) (delta (s ∷ V) c) (gaps s V u) (deficit (s ∷ V) u)

------------------------------------------------------------------------
-- B2.  Occurrence, and the strict decrease.
--
-- `Occurs s V t`: the head s occurs UNCOVERED somewhere in the target.
-- That is exactly the hypothesis under which installing s strictly
-- decreases the measure — and it is exactly what the loop's probe
-- returns alongside the obstruction it read off t.
------------------------------------------------------------------------

Occurs : Shape → Vocab → Tm → Type₀
Occurs s V t = Σ[ j ∈ ℕ ] gaps s V t ≡ suc j

occurs→decreases : (s : Shape) (V : Vocab) (t : Tm) → Occurs s V t
                 → deficit (s ∷ V) t < deficit V t
occurs→decreases s V t (j , p) =
  j , ( +-suc j (deficit (s ∷ V) t)
      ∙ cong (_+ deficit (s ∷ V) t) (sym p)
      ∙ sym (deficit-split s V t) )

-- The exact complement, which the header's disclaimer asserted in prose
-- and nothing checked: install a head with no uncovered occurrence in
-- the target and the measure is UNCHANGED — not merely non-decreasing.
-- This is the checked form of "there is no global well-founded measure
-- on `Vocab` here": off the target, `deficit` is blind.
no-gaps→no-decrease : (s : Shape) (V : Vocab) (t : Tm) → gaps s V t ≡ 0
                    → deficit V t ≡ deficit (s ∷ V) t
no-gaps→no-decrease s V t p =
  deficit-split s V t ∙ cong (_+ deficit (s ∷ V) t) p

------------------------------------------------------------------------
-- B2 (continued).  The probe: attempt the match, read the residual.
--
-- Innermost-first, so that when the loop reports an obstruction the
-- failure really is at the ROOT of `node residual arg` and `arg` is
-- base — which is what `Obstruction`'s `argBase` field demands.  That
-- field is why the probe cannot simply return the first uncovered head
-- from the outside in.
------------------------------------------------------------------------

data Probe (V : Vocab) (t : Tm) : Type₀ where
  covered : Over V t → Probe V t
  gap     : (o : Obstruction V) → Occurs (residual o) V t → Probe V t

probe : (V : Vocab) (t : Tm) → Probe V t
probe V var        = covered tt
probe V (node c u) = lift-probe (probe V u)
  where
  lift-probe : Probe V u → Probe V (node c u)
  lift-probe (gap o (j , p)) =
    gap o ( gapAt (residual o) V c + j
          , cong (gapAt (residual o) V c +_) p
            ∙ +-suc (gapAt (residual o) V c) j )
  lift-probe (covered ou) = here? (dichotomyBool (memb c V))
    where
    here? : (memb c V ≡ true) ⊎ (memb c V ≡ false) → Probe V (node c u)
    here? (inl e) = covered (e , ou)
    here? (inr e) =
      gap (record { residual = c    ; arg     = u  ; argBase     = ou
                  ; failed   = e    ; witness = var ; witnessBase = tt })
          ( gaps c V u
          , cong (_+ gaps c V u) (if≡true (eqℕ-refl c) ∙ if≡false e) )

-- THE STEP FUNCTION, with its checked measure.  Either the vocabulary
-- already covers the target, or the loop names a missing head — read off
-- the residual of the failed match — and the measure strictly drops.
generative-step : (V : Vocab) (t : Tm)
  → Over V t ⊎ (Σ[ o ∈ Obstruction V ] (deficit (extend V o) t < deficit V t))
generative-step V t = read (probe V t)
  where
  read : Probe V t
       → Over V t ⊎ (Σ[ o ∈ Obstruction V ] (deficit (extend V o) t < deficit V t))
  read (covered h)  = inl h
  read (gap o occ)  = inr (o , occurs→decreases (residual o) V t occ)

------------------------------------------------------------------------
-- B3-B4.  Iteration: the loop terminates, with a step bound.
------------------------------------------------------------------------

chainLen : {V W : Vocab} → ObsChain V W → ℕ
chainLen done        = 0
chainLen (step ch _) = suc (chainLen ch)

-- Chains grow at the right; the loop grows at the left.  This is the
-- (entirely routine) reassociation.
consChain : {V W : Vocab} (o : Obstruction V) → ObsChain (extend V o) W → ObsChain V W
consChain o done         = step done o
consChain o (step ch o') = step (consChain o ch) o'

consChain-len : {V W : Vocab} (o : Obstruction V) (ch : ObsChain (extend V o) W)
              → chainLen (consChain o ch) ≡ suc (chainLen ch)
consChain-len o done         = refl
consChain-len o (step ch o') = cong suc (consChain-len o ch)

private
  ¬<zero : (n : ℕ) → ¬ (n < 0)
  ¬<zero n (k , p) = snotz (sym (+-suc k n) ∙ p)

-- What the loop delivers: a vocabulary, the chain of obstruction-indexed
-- proposals that built it, coverage of the target, and a step bound.
Reaches : Vocab → Tm → ℕ → Type₀
Reaches V t f =
  Σ[ W ∈ Vocab ] Σ[ ch ∈ ObsChain V W ] (Over W t × (chainLen ch ≤ f))

loop : (f : ℕ) (V : Vocab) (t : Tm) → deficit V t ≤ f → Reaches V t f
loop zero    V t h = go (generative-step V t)
  where
  go : Over V t ⊎ (Σ[ o ∈ Obstruction V ] (deficit (extend V o) t < deficit V t))
     → Reaches V t 0
  go (inl cov)       = V , done , cov , ≤-refl
  go (inr (o , dec)) = Empty.rec (¬<zero (deficit (extend V o) t) (≤-trans dec h))
loop (suc f) V t h = go (generative-step V t)
  where
  go : Over V t ⊎ (Σ[ o ∈ Obstruction V ] (deficit (extend V o) t < deficit V t))
     → Reaches V t (suc f)
  go (inl cov)       = V , done , cov , zero-≤
  go (inr (o , dec)) = next (loop f (extend V o) t (pred-≤-pred (≤-trans dec h)))
    where
    next : Reaches (extend V o) t f → Reaches V t (suc f)
    next (W , ch , cov , len) =
      W , consChain o ch , cov
        , subst (_≤ suc f) (sym (consChain-len o ch)) (suc-≤-suc len)

-- TERMINATION.  Unconditional, for any starting vocabulary and any
-- target: iterating the obstruction-indexed proposer covers the target in
-- at most `deficit V t` steps.  The loop does not stall.
generative-loop : (V : Vocab) (t : Tm)
  → Σ[ W ∈ Vocab ] Σ[ ch ∈ ObsChain V W ] (Over W t × (chainLen ch ≤ deficit V t))
generative-loop V t = loop (deficit V t) V t ≤-refl

-- Corollary, in the shape of `Obstruction.obs-complete` (which this
-- strengthens: same conclusion, now with a measure-driven construction
-- and a bound on the number of proposals).
generative-loop-complete : (V : Vocab) (t : Tm) → Σ[ W ∈ Vocab ] (ObsChain V W × Over W t)
generative-loop-complete V t with generative-loop V t
... | W , ch , cov , _ = W , ch , cov

------------------------------------------------------------------------
-- C.  Composition with the acceptance test.
--
-- `compile` is STIPULATED here: a compiler that consults the vocabulary
-- for one capability — a head named `checkpoint`, "you may resume from a
-- checkpoint" — and emits the resumed plan iff that name is installed.
-- Nothing derives this rule; it is the interface across which the two
-- substrates are composed, and it is three lines so that it can be read.
--
-- What is then CHECKED is the chain: an obstruction-indexed proposal that
-- names `checkpoint` (i) is conservative, (ii) turns the stuck term from
-- unmatched to matched, (iii) flips the compiler's branch, and (iv) the
-- branch it flips to computes the same digit word at strictly smaller
-- counted cost.  (iv) is `AcceptanceTest.betterProgram`, imported.
------------------------------------------------------------------------

module Compile (k : ℕ) (checkpoint : Shape) where

  open NaturalMachine.AcceptanceTest k
    using (Plan ; restart ; resume ; cost ; exec ; replay ; resume-cheaper ; betterProgram)

  compile : Vocab → ℕ → ℕ → Plan
  compile V m n = if memb checkpoint V then resume m n else restart m n

  compile-absent : (V : Vocab) (m n : ℕ) → memb checkpoint V ≡ false
                 → compile V m n ≡ restart m n
  compile-absent V m n e = if≡false e

  compile-present : (V : Vocab) (m n : ℕ) → memb checkpoint V ≡ true
                  → compile V m n ≡ resume m n
  compile-present V m n e = if≡true e

  -- C1: every definition the loop generates eliminates — every term over
  -- the extended vocabulary unfolds to one all of whose heads are base.
  -- It is `Obstruction.propose-eliminable` under a new name (the
  -- definition below is a renaming, not a restatement: nothing about the
  -- loop occurs in its type).  It does NOT say the extended vocabulary
  -- "proves nothing new" — no provability relation is modelled anywhere
  -- in this development; see `Obstruction`'s T2.
  generated-definition-conservative :
    (V : Vocab) (o : Obstruction V) (t : Tm)
    → Over (install V (propose V o)) t
    → Over V (unfold (residual o) (witness o) t)
  generated-definition-conservative = propose-eliminable

  -- The obstruction names the capability: before the step the name is
  -- absent (that IS the failure evidence), after it, present.
  private
    absent : (V : Vocab) (o : Obstruction V) → residual o ≡ checkpoint
           → memb checkpoint V ≡ false
    absent V o p = sym (cong (λ s → memb s V) p) ∙ failed o

    present : (V : Vocab) (o : Obstruction V) → residual o ≡ checkpoint
            → memb checkpoint (extend V o) ≡ true
    present V o p =
      cong (λ s → memb s (extend V o)) (sym p) ∙ memb-here (residual o) V

  -- C2: the whole chain, as one term.
  generated-step-improves :
    (V : Vocab) (o : Obstruction V) → residual o ≡ checkpoint → (m n : ℕ)
    → ( (t : Tm) → Over (install V (propose V o)) t
                 → Over V (unfold (residual o) (witness o) t) )     -- conservative
    × (¬ Matches V (stuckTm o))                                     -- was stuck
    × (Matches (extend V o) (stuckTm o))                            -- now matches
    × (compile V m (suc n) ≡ restart m (suc n))                     -- before: naive plan
    × (compile (extend V o) m (suc n) ≡ resume m (suc n))           -- after: resumed plan
    × (exec (resume m (suc n)) ≡ exec (restart m (suc n)))          -- same answer
    × (cost (resume m (suc n)) < cost (restart m (suc n)))          -- strictly cheaper
  generated-step-improves V o p m n =
      generated-definition-conservative V o
    , progress-before V o
    , progress-after V o
    , compile-absent V m (suc n) (absent V o p)
    , compile-present (extend V o) m (suc n) (present V o p)
    , fst (betterProgram m n)
    , snd (betterProgram m n)

  ------------------------------------------------------------------------
  -- C3.  DISCHARGING C2's HYPOTHESIS.
  --
  -- Nothing above ever produces an obstruction whose residual IS the
  -- checkpoint, so as written C2 could be true for want of a subject.
  -- It is not.  Whenever the capability is absent from V the obstruction
  -- exists; it is the record `probe V ckTarget` builds on the target
  -- `node checkpoint var`, and that target's deficit strictly drops when
  -- it is proposed — so this is a step the loop of B2-B4 really takes,
  -- not an ad-hoc inhabitant.
  --
  -- What C3 does NOT say: that generation is what makes the checkpoint
  -- capability appear in any real setting.  The target `ckTarget` is
  -- chosen here precisely to contain the head we want read off it.  C3
  -- kills the vacuity, it does not derive the interface.
  ------------------------------------------------------------------------

  ckTarget : Tm
  ckTarget = node checkpoint var

  checkpoint-obstruction : (V : Vocab) → memb checkpoint V ≡ false → Obstruction V
  checkpoint-obstruction V e = record
    { residual = checkpoint ; arg = var ; argBase = tt
    ; failed = e ; witness = var ; witnessBase = tt }

  checkpoint-obstruction-residual :
    (V : Vocab) (e : memb checkpoint V ≡ false)
    → residual (checkpoint-obstruction V e) ≡ checkpoint
  checkpoint-obstruction-residual V e = refl

  -- It is a genuine loop step: the measure of `ckTarget` strictly drops.
  checkpoint-decreases :
    (V : Vocab) (e : memb checkpoint V ≡ false)
    → deficit (extend V (checkpoint-obstruction V e)) ckTarget < deficit V ckTarget
  checkpoint-decreases V e =
    occurs→decreases checkpoint V ckTarget
      (zero , cong (_+ zero) (if≡true (eqℕ-refl checkpoint) ∙ if≡false e))

  -- C2 with its hypothesis supplied.
  compile-improves :
    (V : Vocab) (e : memb checkpoint V ≡ false) (m n : ℕ)
    → Σ[ o ∈ Obstruction V ]
        ( ((t : Tm) → Over (install V (propose V o)) t
                    → Over V (unfold (residual o) (witness o) t))
        × (¬ Matches V (stuckTm o))
        × (Matches (extend V o) (stuckTm o))
        × (deficit (extend V o) ckTarget < deficit V ckTarget)
        × (compile V m (suc n) ≡ restart m (suc n))
        × (compile (extend V o) m (suc n) ≡ resume m (suc n))
        × (exec (resume m (suc n)) ≡ exec (restart m (suc n)))
        × (cost (resume m (suc n)) < cost (restart m (suc n))) )
  compile-improves V e m n =
    checkpoint-obstruction V e
    , fst chain
    , fst (snd chain)
    , fst (snd (snd chain))
    , checkpoint-decreases V e
    , snd (snd (snd chain))
    where
    chain = generated-step-improves V (checkpoint-obstruction V e)
              (checkpoint-obstruction-residual V e) m n
