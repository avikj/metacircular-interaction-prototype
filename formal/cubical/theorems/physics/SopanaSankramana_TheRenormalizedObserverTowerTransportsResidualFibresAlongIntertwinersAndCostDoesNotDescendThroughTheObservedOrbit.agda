{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सोपान-संक्रमण — transport up the ladder.
--
-- The common object the two boundary problems converge on: a tower of
-- states X_n with observers O_n, a renormalised transport R_n from one
-- stage to the next, and intertwiners g_n making the observation of a
-- transported state the transport of its observation.  The residual at
-- stage n is what O_n cannot see — the fibre of O_n over O_n x — and the
-- theorem that carries both lanes is that R restricts to residual fibres.
-- The spectral question (RH) and the recurrence question (NS) are then
-- questions about that residual transport, stated here as types.
--
--   §1  THE TOWER.  X, Y, O, R, g and the intertwining law.
--   §2  RESIDUAL TRANSPORT.  The fibre of O_n over O_n x is carried by R
--       into the fibre of O_{n+1} over O_{n+1}(R x): one path from the
--       intertwining law.  This is renormalised transport on the residual
--       fibre, generically.
--   §3  ORBITS.  A compatible family s_n with R_n s_n ≡ s_{n+1}, and its
--       observed orbit, which is a g-orbit.  Two orbits with the same
--       observed orbit at every stage and different cost at stage zero
--       show cost does not descend through the entire coarse history —
--       SankramanaShreni's localization, applied to orbits.
--   §4  DASHBOARDS.  A stagewise post-processing intertwining the g's
--       transports one tower's observers into another's, by
--       SopanaSamyoga's pravāha-vahana at every stage: towers form a
--       category over the same states.
--   §5  THE TWO TARGETS, AS TYPES.  A mode is an orbit the transport
--       rescales by a fixed factor; NeutralSpectrum asks that every
--       factor be neutral.  A bad orbit is one nonzero at every stage
--       and invisible at every stage; NoBadRecurrentOrbit asks there be
--       none.  RH and NS are inhabitants of these types on their
--       realisations.
--
-- A tower of finite-dimensional linear kernels is automatically
-- Mittag-Leffler, so the content is never a lim¹ class of the inverse
-- system: it is the transport R itself.  सोपान (sopāna, ladder) and
-- संक्रमण (saṅkramaṇa, transport) are ordinary Sanskrit.
------------------------------------------------------------------------

module SopanaSankramana_TheRenormalizedObserverTowerTransportsResidualFibresAlongIntertwinersAndCostDoesNotDescendThroughTheObservedOrbit where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isSetΠ)
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import SankramanaShreni_TheLocalizationSequenceAsOneObjectMeaningDescendsAndCostDoesNot
  using (module Localization)
open import SopanaSamyoga_AliasesComposeAlongIntertwinersSoTheLadderIsACategoryAndDashboardsAreItsMorphisms
  using (vahana-saṃyoga)

private
  variable
    ℓx ℓy ℓz : Level

------------------------------------------------------------------------
-- १ · The tower.
------------------------------------------------------------------------

record Tower (ℓx ℓy : Level) : Type (ℓ-suc (ℓ-max ℓx ℓy)) where
  field
    X : ℕ → Type ℓx                       -- states at stage n
    Y : ℕ → Type ℓy                       -- readings at stage n
    O : (n : ℕ) → X n → Y n               -- the observer
    R : (n : ℕ) → X n → X (suc n)         -- renormalised transport
    g : (n : ℕ) → Y n → Y (suc n)         -- transport of readings
    intertwine : (n : ℕ) (x : X n) → O (suc n) (R n x) ≡ g n (O n x)

  --------------------------------------------------------------------
  -- २ · The residual fibre, and its transport.
  --------------------------------------------------------------------

  -- what stage-n observation cannot separate from x
  Residual : (n : ℕ) → X n → Type (ℓ-max ℓx ℓy)
  Residual n x = fiber (O n) (O n x)

  -- R carries the residual fibre at x to the residual fibre at R x
  residual-saṅkramaṇa : (n : ℕ) (x : X n)
                      → Residual n x → Residual (suc n) (R n x)
  residual-saṅkramaṇa n x (x′ , p) =
    R n x′ , intertwine n x′ ∙ cong (g n) p ∙ sym (intertwine n x)

  --------------------------------------------------------------------
  -- ३ · Orbits, their observed orbits, and non-descent of cost.
  --------------------------------------------------------------------

  Orbit : Type ℓx
  Orbit = Σ[ s ∈ ((n : ℕ) → X n) ] ((n : ℕ) → R n (s n) ≡ s (suc n))

  -- the observed orbit
  dṛṣṭa : Orbit → (n : ℕ) → Y n
  dṛṣṭa (s , _) n = O n (s n)

  -- and it is a g-orbit: observing then transporting is transporting
  -- then observing
  dṛṣṭa-orbit : (o : Orbit) (n : ℕ) → g n (dṛṣṭa o n) ≡ dṛṣṭa o (suc n)
  dṛṣṭa-orbit (s , comp) n = sym (intertwine n (s n)) ∙ cong (O (suc n)) (comp n)

open Tower

-- cost does not descend through the entire observed history: two
-- orbits observed identically at every stage, priced apart at stage 0
module _ (T : Tower ℓx ℓy) (isSetY : (n : ℕ) → isSet (Y T n)) (cost : X T zero → ℕ) where

  open Localization {X = Orbit T} {Y = (n : ℕ) → Y T n}
                    (isSetΠ isSetY) (dṛṣṭa T) (λ o → cost (fst o zero))
    public

  kṣetra-avataraṇa : (o o′ : Orbit T)
                   → ((n : ℕ) → dṛṣṭa T o n ≡ dṛṣṭa T o′ n)
                   → ¬ (cost (fst o zero) ≡ cost (fst o′ zero))
                   → ¬ (Σ[ c ∈ (Ĝ → ℕ) ] ((o″ : Orbit T) → c (L o″) ≡ cost (fst o″ zero)))
  kṣetra-avataraṇa o o′ same apart =
    costDoesNotDescend o o′ (λ i n → same n i) apart


------------------------------------------------------------------------
-- ४ · Dashboards transport towers.
------------------------------------------------------------------------

-- a stagewise post-processing intertwining the reading transports
-- yields an observer tower on the same states
record Dashboard {ℓz : Level} (T : Tower ℓx ℓy) (Z : ℕ → Type ℓz)
    : Type (ℓ-max (ℓ-max ℓx ℓy) ℓz) where
  field
    h  : (n : ℕ) → Y T n → Z n
    g′ : (n : ℕ) → Z n → Z (suc n)
    inter : (n : ℕ) (y : Y T n) → h (suc n) (g T n y) ≡ g′ n (h n y)

  -- the composite observer h ∘ O intertwines with g′
  vahita : Tower ℓx ℓz
  X vahita = X T
  Y vahita = Z
  O vahita n x = h n (O T n x)
  R vahita = R T
  g vahita = g′
  intertwine vahita n x = cong (h (suc n)) (intertwine T n x) ∙ inter n (O T n x)

open Dashboard

------------------------------------------------------------------------
-- ५ · The two targets, as types.
------------------------------------------------------------------------

module _ (T : Tower ℓx ℓy) where

  -- a mode: an orbit the transport rescales by a fixed factor, for a
  -- given notion of scaling on the states
  Mode : (scale : (n : ℕ) → X T n → X T n) → Type ℓx
  Mode scale = Σ[ s ∈ ((n : ℕ) → X T n) ] ((n : ℕ) → R T n (s n) ≡ scale (suc n) (s (suc n)))

  -- RH-shaped: every mode's factor is neutral, for a given neutrality
  NeutralSpectrum : (Scale : Type ℓx) (act : Scale → (n : ℕ) → X T n → X T n)
                  → (Neutral : Scale → Type ℓx) → Type ℓx
  NeutralSpectrum Scale act Neutral =
    (σ : Scale) → Mode (act σ) → Neutral σ

  -- NS-shaped: no orbit that is nonzero at every stage and invisible
  -- to every stage's observer
  NoBadRecurrentOrbit : (nonzero : (n : ℕ) → X T n → Type ℓx)
                      → (invisible : (n : ℕ) → X T n → Type ℓy) → Type (ℓ-max ℓx ℓy)
  NoBadRecurrentOrbit nonzero invisible =
    (o : Orbit T) → ((n : ℕ) → nonzero n (fst o n) × invisible n (fst o n)) → ⊥
