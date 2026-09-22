{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheDelimitorNeedsOnlyStability
--
-- ────────────────────────────────────────────────────────────────────
-- THE SITE
--
-- `AnyonyaAbhava` §5 assumes `Dec (Collision q t)` to
-- close the gap between the two Vaieika categories of ����.
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
--   §2  decidability on a class of sites: for a two-point state space with discrete Y and
--       discrete T, `Dec (Collision q t)` HOLDS, by an exhaustion over
--       the four pairs of which two are diagonal and die on `refl`.
--       So the answer to "does it hold at any site" is yes, and the
--       cost is the same finite search that `RefutingLaghavaIsASearch`
--       found at the presentation-measures site.
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
-- 2.  Decidability by exhaustion on a two-point state space
--
-- `Bool` is a hypothesis here: where a site has a two-point state space,
-- and Y and T are discrete, the delimitor is decidable and §5 of
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
