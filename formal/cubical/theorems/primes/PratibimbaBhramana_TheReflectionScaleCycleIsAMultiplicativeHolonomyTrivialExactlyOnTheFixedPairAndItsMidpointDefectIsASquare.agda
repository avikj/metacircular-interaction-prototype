{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रतिबिम्ब-भ्रमण — the reflection circuit.
--
-- THE FOUR-STEP CYCLE  scale⁻¹ → reflect → scale → reflect  IS NOT THE
-- IDENTITY.  It is an explicit multiplicative holonomy, it is trivial
-- exactly on the reflection-fixed pair, and its midpoint defect is a
-- perfect square.
--
-- `VyarthaCakra` put up the ADDITIVE fence: the descent defect of an
-- involution satisfies its cocycle identity for every feature, so the
-- identity separates nothing and only pointwise vanishing carries
-- content.  This is the same fence on the MULTIPLICATIVE side, and here
-- the defect is a closed transport rather than a difference.
--
-- On one reflected pair the state is a pair of ring elements, the
-- reflection is the swap, and the scale acts diagonally by a unit pair
-- (u , v).  Then:
--
--   §1  THE CYCLE IS A DIAGONAL MULTIPLICATION.  Composing the four
--       steps on any state gives
--
--         swap ∘ act (u,v) ∘ swap ∘ act (u⁻¹,v⁻¹)  ≡  act ( v·u⁻¹ , u·v⁻¹ )
--
--       — the holonomy is the element `hol = (v·u⁻¹ , u·v⁻¹)`, and it is
--       computed, not posited.  In the intended reading `u` and `v` are
--       the two members of a reflected pair, so `hol` is the pair's
--       displacement doubled; that reading is not needed below.
--
--   §2  IT IS TRIVIAL EXACTLY ON THE FIXED PAIR:  hol ≡ (1,1) ⟺ u ≡ v.
--       Both directions, in any commutative ring.
--
--   §3  ITS REFLECTION IS ITS INVERSE:  swap(hol) · hol ≡ (1,1), for
--       every unit pair whatsoever.  So — exactly as in the additive
--       case — that relation is AUTOMATIC and separates nothing; §2 is
--       the statement with content.
--
--   §4  AND IT IS MULTIPLICATIVE in the scale: hol(w·w') ≡ hol w · hol w'.
--       So the holonomies of the one-parameter scale family form a
--       homomorphic image of it, and one nontrivial value forces all of
--       them nontrivial.
--
--   §5  THE MIDPOINT DEFECT IS A SQUARE.  For x with inverse y,
--
--         (x² + y²) - 2  ≡  (x - y)² ,
--
--       which is the two-sided scale probe minus twice the centre.  It
--       is a square with no hypothesis beyond `x·y ≡ 1`, so it can never
--       be negative in any ordered instance — the probe is midpoint
--       convex, exactly.
--
--   §6  AND ITS VANISHING FORCES THE HOLONOMY TO BE AN INVOLUTION:
--       x² ≡ 1.  In a reduced ring this is everything the defect knows.
--
-- WHERE THE ANALYSIS ENTERS, NAMED PRECISELY.  §6 gives `x² ≡ 1`, not
-- `x ≡ 1`.  Over an ordered field where `x` is a positive exponential
-- the two coincide, because the only positive square root of one is one.
-- That single step — POSITIVITY OF THE SCALE FACTOR — is the whole of
-- what an ordered structure is needed for here, and it is the only thing
-- in this circuit that this corpus cannot supply.  Everything else, the
-- cycle, its triviality criterion, its cocycle relation, its
-- multiplicativity and its convexity, is ring algebra and is proved.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–6 in any commutative ring, for every
-- unit pair.  NOT claimed: that `x ≡ 1r` follows from `x · x ≡ 1r` —
-- see above, and it is false in general (take x ≡ -1r); anything about
-- exponentials, zeros, or a spectral measure; that the holonomy is
-- bounded, or that a supremum of displacements exists — no order
-- relation occurs in this file; and nothing about summing over a family,
-- which is `VyarthaCakra` §6 and needs positive weights.
------------------------------------------------------------------------

module PratibimbaBhramana_TheReflectionScaleCycleIsAMultiplicativeHolonomyTrivialExactlyOnTheFixedPairAndItsMidpointDefectIsASquare where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd ; ΣPathP)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

private
  variable
    ℓ : Level

module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)

  private
    A : Type ℓ
    A = ⟨ R ⟩

  ------------------------------------------------------------------
  -- ० · One reflected pair: states, the reflection, the scale action.
  ------------------------------------------------------------------

  Pair : Type ℓ
  Pair = A × A

  swap : Pair → Pair
  swap p = (snd p , fst p)

  act : Pair → Pair → Pair
  act w p = (fst w · fst p , snd w · snd p)

  1P : Pair
  1P = (1r , 1r)

  _⊙_ : Pair → Pair → Pair
  p ⊙ q = (fst p · fst q , snd p · snd q)

  -- the holonomy of a scale element, as computed in §1
  hol : A → A → A → A → Pair
  hol u ū v v̄ = ((v · ū) , (u · v̄))

  ------------------------------------------------------------------
  -- A scale element is a unit pair, carried with its inverse.
  ------------------------------------------------------------------

  module _ (u ū v v̄ : A) (uu : u · ū ≡ 1r) (vv : v · v̄ ≡ 1r) where

    private
      H : Pair
      H = hol u ū v v̄

    ----------------------------------------------------------------
    -- १ · THE CYCLE IS EXACTLY MULTIPLICATION BY `hol`.
    ----------------------------------------------------------------

    cycle : Pair → Pair
    cycle p = swap (act (u , v) (swap (act (ū , v̄) p)))

    cycle-is-holonomy : (p : Pair) → cycle p ≡ act H p
    cycle-is-holonomy p =
      ΣPathP ( ·Assoc v ū (fst p) , ·Assoc u v̄ (snd p) )

    ----------------------------------------------------------------
    -- २ · TRIVIAL EXACTLY ON THE FIXED PAIR.
    ----------------------------------------------------------------

    private
      ūu : ū · u ≡ 1r
      ūu = ·Comm ū u ∙ uu

    fixed→trivial : u ≡ v → H ≡ 1P
    fixed→trivial e =
      ΣPathP ( cong (_· ū) (sym e) ∙ uu
             , cong (_· v̄) e ∙ vv )

    trivial→fixed : H ≡ 1P → u ≡ v
    trivial→fixed e =
      sym ( sym (·IdR v)
          ∙ cong (v ·_) (sym ūu)
          ∙ ·Assoc v ū u
          ∙ cong (_· u) (cong fst e)
          ∙ ·IdL u )

    ----------------------------------------------------------------
    -- ३ · ITS REFLECTION IS ITS INVERSE — automatically, for every
    --     unit pair.  This relation is the vacuous one.
    ----------------------------------------------------------------

    reflection-inverts : (swap H) ⊙ H ≡ 1P
    reflection-inverts =
      ΣPathP ( regroup u v̄ v ū ∙ cong₂ _·_ uu vv ∙ ·IdL 1r
             , regroup v ū u v̄ ∙ cong₂ _·_ vv uu ∙ ·IdL 1r )
      where
        regroup : (a b c d : A) → (a · b) · (c · d) ≡ (a · d) · (c · b)
        regroup a b c d = solve! R

    ----------------------------------------------------------------
    -- ५ · THE MIDPOINT DEFECT IS A SQUARE.
    ----------------------------------------------------------------

    probe : A → A → A
    probe x y = ((x · x) + (y · y)) + (- (1r + 1r))

    midpoint-defect-is-a-square : (x y : A) → x · y ≡ 1r
      → probe x y ≡ (x + (- y)) · (x + (- y))
    midpoint-defect-is-a-square x y h =
        cong (λ z → ((x · x) + (y · y)) + (- (z + z))) (sym h)
      ∙ expand x y
      where
        expand : (p q : A)
          → ((p · p) + (q · q)) + (- ((p · q) + (p · q)))
            ≡ (p + (- q)) · (p + (- q))
        expand p q = solve! R

    ----------------------------------------------------------------
    -- ६ · AND ITS VANISHING MAKES THE HOLONOMY AN INVOLUTION.
    ----------------------------------------------------------------

    hol-units : fst H · snd H ≡ 1r
    hol-units =
        cross v ū u v̄ ∙ cong₂ _·_ uu vv ∙ ·IdL 1r
      where
        cross : (a b c d : A) → (a · b) · (c · d) ≡ (c · b) · (a · d)
        cross a b c d = solve! R

    defect-zero→involutive :
        ((a : A) → a · a ≡ 0r → a ≡ 0r)
      → probe (fst H) (snd H) ≡ 0r
      → fst H · fst H ≡ 1r
    defect-zero→involutive reduced h =
        cong (fst H ·_) same
      ∙ hol-units
      where
        same : fst H ≡ snd H
        same =
            sym (cancel (fst H) (snd H))
          ∙ cong (_+ snd H)
                 (reduced (fst H + (- snd H))
                          (sym (midpoint-defect-is-a-square
                                 (fst H) (snd H) hol-units) ∙ h))
          ∙ +IdL (snd H)
          where
            cancel : (p q : A) → (p + (- q)) + q ≡ p
            cancel p q = solve! R

  ------------------------------------------------------------------
  -- ४ · THE HOLONOMY IS MULTIPLICATIVE IN THE SCALE.
  ------------------------------------------------------------------

  holonomy-multiplicative :
      (u ū v v̄ u' ū' v' v̄' : A)
    → hol (u · u') (ū · ū') (v · v') (v̄ · v̄')
      ≡ (hol u ū v v̄) ⊙ (hol u' ū' v' v̄')
  holonomy-multiplicative u ū v v̄ u' ū' v' v̄' =
    ΣPathP ( shuffle v v' ū ū' , shuffle u u' v̄ v̄' )
    where
      shuffle : (a b c d : A) → (a · b) · (c · d) ≡ (a · c) · (b · d)
      shuffle a b c d = solve! R
