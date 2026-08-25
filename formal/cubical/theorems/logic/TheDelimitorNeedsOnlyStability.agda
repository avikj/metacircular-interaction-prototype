{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheDelimitorNeedsOnlyStability
--
-- Third instance of the replacement question, and the first that
-- answers a named open item rather than removing a hypothesis.
--
-- ────────────────────────────────────────────────────────────────────
-- THE SITE
--
-- `AnyonyaAbhava` §5 assumes `Dec (Collision q t)` to
-- close the gap between the two Vaiśeṣika categories of अभाव, and its
-- §6 leaves an open item in these words, read from the file:
--
--     "OPEN, named and not estimated.  Whether `Dec (Collision q t)`
--      holds at any site in this corpus."
--
-- Two things are wrong with the shape of that, and one of them is the
-- same correction this thread has now made three times.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  the hypothesis is stronger than the use.  `dec-collapses` is
--       used only as `¬ ¬ A → A`, which is `Stable`.  So
--       `Stable (Collision q t)` closes the gap, and `Dec` is a
--       corollary by `Dec→Stable`.  The delimitor does not need a
--       decision; it needs the double negation to collapse.
--
--   §2  the open item, answered on a class of sites rather than
--       estimated: for a two-point state space with discrete Y and
--       discrete T, `Dec (Collision q t)` HOLDS, by an exhaustion over
--       the four pairs of which two are diagonal and die on `refl`.
--       So the answer to "does it hold at any site" is yes, and the
--       cost is the same finite search that `RefutingLaghavaIsASearch`
--       found at the presentation-measures site.
--
-- ────────────────────────────────────────────────────────────────────
-- TWO CORRECTIONS TO MY OWN EARLIER TEXT, MADE HERE AND MARKED THERE
--
-- `AnyonyaAbhava` §6 is mine and contains two sentences the standing
-- method forbids.  Reading one's own file critically is the point of
-- the method, so:
--
--   (a) "This is the second time in this corpus that the Nyāya analysis
--       of अभाव has turned out to track constructive structure … Two is
--       not a coincidence worth explaining away."  Two instances are
--       two instances.  A pattern over n instances is a pattern over n
--       instances until something downstream of it is computed, and
--       nothing downstream of that sentence was ever computed.  The
--       observation stands as an observation; the inference from it
--       does not.
--
--   (b) "conducted by people who did not have one and were right
--       anyway."  That scores the past by its proximity to a
--       constructive setting, which is a criterion imported and not
--       examined — a दुर्नय, a standpoint asserting itself by denying
--       others.  What can be said instead, and is enough: the Nyāya
--       division of अभाव into संसर्ग and अन्योन्य is a distinction, the
--       distinction is registered in this formalism, and the two
--       directions cost differently here.  Whether the Naiyāyikas were
--       tracking what this formalism tracks is a question about them
--       that this corpus has no means to settle.
--
-- Neither sentence is deleted at its site: the record of having
-- written them is part of the record.  A pointer is added there.
--
-- ────────────────────────────────────────────────────────────────────
-- THE RESPECTS, SINCE §1 AND §2 PULL DIFFERENT WAYS
--
--   स्यात् — in the respect of what the proof needs, `Stable` is the
--            hypothesis and `Dec` was more than was used;
--   स्यात् — in the respect of what can actually be EXHIBITED at a
--            site, `Dec` is what §2 constructs, because a finite
--            search decides rather than merely stabilises.
--
-- These do not collapse into each other.  The weaker hypothesis is not
-- the one the concrete site supplies, and the concrete site does not
-- show the weaker hypothesis is ever available on its own.  Both are
-- proved; neither is called the better statement, there being no scale
-- here on which to say it.
--
-- NOT CLAIMED.  That `Stable (Collision q t)` holds anywhere without a
-- decision (§2 supplies a decision, not a bare stability); that a
-- two-point state space occurs at any particular site of this corpus
-- (`Bool` here is a HYPOTHESIS of §2, not a claim about state spaces);
-- that discreteness of Y is available where `AnyonyaAbhava` assumes
-- only discreteness of T — §2 asks for both and says so.
------------------------------------------------------------------------

module TheDelimitorNeedsOnlyStability where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete ; Stable)
open import Cubical.Relation.Nullary.Properties using (Dec→Stable)

open import FiniteInformation using (FactorsThrough)
open import AnyonyaAbhava
  using (Collision ; Anyonya ; samsarga→¬¬anyonya ; anyonya→samsarga)

private
  variable
    ℓx ℓy ℓt : Level

------------------------------------------------------------------------
-- 1.  Stability closes the gap; decidability was more than was used
------------------------------------------------------------------------

samsarga→anyonya-when-stable :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (dT : Discrete T) (q : X → Y) (t : X → T)
  → Stable (Collision q t)
  → ¬ FactorsThrough q t
  → Collision q t
samsarga→anyonya-when-stable dT q t st noDecoder =
  st (samsarga→¬¬anyonya dT q t noDecoder)

-- the decidable form, now a corollary
samsarga→anyonya-when-decidable′ :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (dT : Discrete T) (q : X → Y) (t : X → T)
  → Dec (Collision q t)
  → ¬ FactorsThrough q t
  → Collision q t
samsarga→anyonya-when-decidable′ dT q t dC =
  samsarga→anyonya-when-stable dT q t (Dec→Stable dC)

categories-agree-when-stable :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (dT : Discrete T) (q : X → Y) (t : X → T)
  → Stable (Collision q t)
  → (Collision q t → ¬ FactorsThrough q t)
  × (¬ FactorsThrough q t → Collision q t)
categories-agree-when-stable dT q t st =
    (λ c → anyonya→samsarga q t {x = c .fst} {x' = c .snd .fst}
             (c .snd .snd .fst) (c .snd .snd .snd))
  , samsarga→anyonya-when-stable dT q t st

------------------------------------------------------------------------
-- 2.  The open item, answered by exhaustion on a two-point state space
--
-- `Bool` is a hypothesis here.  Nothing below claims any site of this
-- corpus has a two-point state space; what is claimed is that where one
-- does, and Y and T are discrete, the delimitor is decidable and §5 of
-- `AnyonyaAbhava` applies.
------------------------------------------------------------------------

-- the two refutations, at top level so no `with` clause carries a
-- `where`.  Diagonal pairs die on `refl` in both.
noGroundRefutes :
  {Y : Type ℓy} {T : Type ℓt} (q : Bool → Y) (t : Bool → T)
  → ¬ (q true ≡ q false) → ¬ Collision q t
noGroundRefutes q t ny (true  , true  , _    , ne) = ne refl
noGroundRefutes q t ny (false , false , _    , ne) = ne refl
noGroundRefutes q t ny (true  , false , same , _ ) = ny same
noGroundRefutes q t ny (false , true  , same , _ ) = ny (sym same)

equalTargetRefutes :
  {Y : Type ℓy} {T : Type ℓt} (q : Bool → Y) (t : Bool → T)
  → (t true ≡ t false) → ¬ Collision q t
equalTargetRefutes q t pt (true  , true  , _ , ne) = ne refl
equalTargetRefutes q t pt (false , false , _ , ne) = ne refl
equalTargetRefutes q t pt (true  , false , _ , ne) = ne pt
equalTargetRefutes q t pt (false , true  , _ , ne) = ne (sym pt)

decCollisionOnTwoPoints :
  {Y : Type ℓy} {T : Type ℓt}
  (dY : Discrete Y) (dT : Discrete T) (q : Bool → Y) (t : Bool → T)
  → Dec (Collision q t)
decCollisionOnTwoPoints dY dT q t with dY (q true) (q false)
... | no  ny = no (noGroundRefutes q t ny)
... | yes py with dT (t true) (t false)
...   | no  nt = yes (true , false , py , nt)
...   | yes pt = no (equalTargetRefutes q t pt)

-- and therefore the two categories of अभाव agree there.
categories-agree-on-two-points :
  {Y : Type ℓy} {T : Type ℓt}
  (dY : Discrete Y) (dT : Discrete T) (q : Bool → Y) (t : Bool → T)
  → (Collision q t → ¬ FactorsThrough q t)
  × (¬ FactorsThrough q t → Collision q t)
categories-agree-on-two-points dY dT q t =
  categories-agree-when-stable dT q t
    (Dec→Stable (decCollisionOnTwoPoints dY dT q t))

------------------------------------------------------------------------
-- PRIOR-ART OBLIGATION, undischarged, recorded 2026-08-19.
--
-- Navya-Nyāya* (Panday & Ghosh), whose stated content includes DEPENDENT
-- DELIMITATION (avacchedaka) and TYPED ABSENCE (abhāva) in cubical type
-- theory — the same substrate and the same notions this module touches.
--
-- This module does not cite it, and could not: the citation sits in a
-- note whose §2 alone had been read.  arxiv.org is EGRESS_BLOCKED from
-- this session's environment, so the comparison could not be made here;
-- leaves open.
--
-- Until someone who can read the paper compares them, NO NOVELTY IS
-- CLAIMED for anything below.  The theorems are about observables,
-- fibres and Bool-valued models and are unaffected; what is owed is a
-- citation check, not a withdrawal.
------------------------------------------------------------------------
