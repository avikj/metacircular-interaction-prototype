{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सम्यक्-सोपान — the ladder that sees everything.
--
-- SopanaSankramana's tower pushes readings UP with the transport.  An
-- observer ladder runs the other way: the finer reading determines the
-- coarser one, never the reverse.  So the ladder is the dual object —
-- coarsening maps c_n : Y_{n+1} → Y_n with c_n (O_{n+1} (R_n x)) ≡ O_n x
-- — and its residual fibres SHRINK as the rung rises: what stage n+1
-- cannot see, stage n cannot see either.  A ladder is jointly faithful
-- when the intersection of all its residual fibres is a point.
--
--   §1  THE LADDER, its descending residuals, joint faithfulness.
--   §2  THE THEOREM.  With identity transport, a jointly faithful ladder
--       has no bad recurrent orbit: an orbit invisible at every rung is
--       observed like zero at every rung, hence is zero, hence not
--       nonzero.  Two lines.  So a bad orbit — nonzero and invisible at
--       every rung — needs the transport to be nontrivial: it must MOVE
--       between rungs to stay invisible.  The difficulty is the
--       renormalisation, not the observers.
--   §3  THE COARSE-MODE LADDER IS JOINTLY FAITHFUL.  SamaChaya's coarse
--       movies at every resolution separate fields: two fields observed
--       identically at every resolution are equal, because mode m is
--       read at resolution m.  Coarsening commutes as required.  Hence
--       on the fixed-resolution ladder there is no bad orbit, and the
--       plane wave of SamaChaya — invisible below its mode — is caught
--       at its mode.
--
-- Read with NoBadRecurrentOrbit: for Navier–Stokes the ladder is
-- jointly faithful (the coarse movies at all K determine u), so the only
-- way a singular residual survives every rung is by riding the parabolic
-- rescaling to infinite frequency — a moving, scale-critical orbit, not a
-- fixed kernel.  सम्यक् (samyak, complete/right) and सोपान (sopāna,
-- ladder) are ordinary Sanskrit.
------------------------------------------------------------------------

module SamyakSopana_AJointlyFaithfulLadderWithIdentityTransportHasNoBadRecurrentOrbitSoABadOrbitNeedsTheRenormalisationToMove where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (≤Dec ; ≤-refl ; ≤-trans ; _≤_)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.Relation.Nullary using (¬_ ; yes ; no)

open import SamaChaya_TwoFieldsWithTheSameEntireCoarseMovieHaveDifferentSubgridEnergyAndDifferentCostSoNeitherDescendsThroughCoarseObservation
  using (Field ; chāyā)

private
  variable
    ℓx ℓy : Level

------------------------------------------------------------------------
-- १ · The ladder, descending residuals, joint faithfulness.
------------------------------------------------------------------------

record Ladder (ℓx ℓy : Level) : Type (ℓ-suc (ℓ-max ℓx ℓy)) where
  field
    X : ℕ → Type ℓx
    Y : ℕ → Type ℓy
    O : (n : ℕ) → X n → Y n
    R : (n : ℕ) → X n → X (suc n)          -- renormalised transport, up
    c : (n : ℕ) → Y (suc n) → Y n          -- coarsening, down
    coarsen : (n : ℕ) (x : X n) → c n (O (suc n) (R n x)) ≡ O n x

  Residual : (n : ℕ) → X n → Type (ℓ-max ℓx ℓy)
  Residual n x = fiber (O n) (O n x)

  -- what the finer rung cannot separate from R x, the coarser rung
  -- cannot separate from x: the residual descends the ladder
  residual-avataraṇa : (n : ℕ) (x : X n) (x′ : X n)
                     → O (suc n) (R n x′) ≡ O (suc n) (R n x)
                     → O n x′ ≡ O n x
  residual-avataraṇa n x x′ p =
    sym (coarsen n x′) ∙ cong (c n) p ∙ coarsen n x

  Orbit : Type ℓx
  Orbit = Σ[ s ∈ ((n : ℕ) → X n) ] ((n : ℕ) → R n (s n) ≡ s (suc n))

------------------------------------------------------------------------
-- २ · Identity transport: joint faithfulness kills every bad orbit.
------------------------------------------------------------------------

module _ {X : Type ℓx} {Y : ℕ → Type ℓy}
         (O : (n : ℕ) → X → Y n)
         (zero-state : X)
         -- jointly faithful: observed like zero at every rung ⇒ zero
         (faithful : (x : X) → ((n : ℕ) → O n x ≡ O n zero-state) → x ≡ zero-state)
  where

  -- invisible at rung n: observed like zero
  Invisible : ℕ → X → Type ℓy
  Invisible n x = O n x ≡ O n zero-state

  Nonzero : X → Type ℓx
  Nonzero x = ¬ (x ≡ zero-state)

  -- no state is nonzero and invisible at every rung
  na-duṣṭa : (x : X) → ((n : ℕ) → Nonzero x × Invisible n x) → ⊥
  na-duṣṭa x bad = fst (bad zero) (faithful x (λ n → snd (bad n)))

------------------------------------------------------------------------
-- ३ · The coarse-mode ladder is jointly faithful.
------------------------------------------------------------------------

śūnya : Field
śūnya _ _ = zero

-- mode m is read at resolution m
mātrā-dṛṣṭa : (u : Field) (t m : ℕ) → chāyā m u t m ≡ u t m
mātrā-dṛṣṭa u t m with ≤Dec m m
... | yes _  = refl
... | no  ¬r = ⊥-elim (¬r ≤-refl)

-- two fields observed identically at every resolution are equal
samyak : (u v : Field) → ((n : ℕ) → chāyā n u ≡ chāyā n v) → u ≡ v
samyak u v same = funExt λ t → funExt λ m →
  sym (mātrā-dṛṣṭa u t m) ∙ (λ i → same m i t m) ∙ mātrā-dṛṣṭa v t m

-- coarsening commutes: reading at n then restricting equals reading at n
chāyā-coarsen : (n : ℕ) (u : Field) (t m : ℕ)
              → chāyā n (chāyā (suc n) u) t m ≡ chāyā n u t m
chāyā-coarsen n u t m with ≤Dec m n
... | no  _   = refl
... | yes m≤n with ≤Dec m (suc n)
...   | yes _    = refl
...   | no  ¬le  = ⊥-elim (¬le (≤-trans m≤n (1 , refl)))

-- the fixed-resolution ladder on fields, identity transport
kṣetra-sopāna : Ladder ℓ-zero ℓ-zero
Ladder.X kṣetra-sopāna n = Field
Ladder.Y kṣetra-sopāna n = ℕ → ℕ → ℕ
Ladder.O kṣetra-sopāna n = chāyā n
Ladder.R kṣetra-sopāna n u = u
Ladder.c kṣetra-sopāna n r = chāyā n (λ t m → r t m)
Ladder.coarsen kṣetra-sopāna n u = funExt λ t → funExt λ m → chāyā-coarsen n u t m

-- hence no field is nonzero and invisible at every resolution: a bad
-- orbit of the Navier–Stokes ladder must move
kṣetra-na-duṣṭa : (u : Field) → ((n : ℕ) → (¬ (u ≡ śūnya)) × (chāyā n u ≡ chāyā n śūnya)) → ⊥
kṣetra-na-duṣṭa =
  na-duṣṭa chāyā śūnya (λ u same → samyak u śūnya same)
