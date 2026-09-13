{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अदृश्य-मान — the invisible gauge.
--
-- THE KERNEL OF THE DISCRETE SECOND DIFFERENCE IS EXACTLY THE AFFINE
-- SEQUENCES.  Not "contains" — exactly, in both directions.  So a
-- potential recovered from its second difference is determined only up
-- to two constants, and a receiver that is additive and blind to those
-- two constants descends to the quotient.
--
-- The shape is the corpus's recurring one:
--
--     potential  ⟶  quotient by an invisible gauge  ⟶  observable ,
--
-- and this module supplies its arithmetic instance in full.  If `A` is
-- any sequence with prescribed second difference, so is `A + α + βn`,
-- and NOTHING ELSE IS.  §3 is the "contains" half and §4 the "nothing
-- else" half; the second is the one that makes the fibre a torsor rather
-- than merely a coset of something bigger.
--
--   §1  Δ (aff a b) ≡ b, constantly — the first difference of an affine
--       sequence is its slope, everywhere.
--
--   §2  hence Δ² (aff a b) ≡ 0: every affine sequence is in the kernel.
--
--   §3  Δ is additive, and additive on differences.  Three shape lemmas,
--       all closed by the commutative-ring solver; no coordinates are
--       computed anywhere else in the file.
--
--   §4  THE CONVERSE.  If Δ² f ≡ 0 everywhere then
--
--         f n  ≡  f 0  +  n · (Δ f 0)     for every n,
--
--       where `n · x` is iterated addition, so no division by n and no
--       characteristic assumption.  The two constants are read off the
--       sequence itself: its value and its first difference at zero.
--
--   §5  THEREFORE THE FIBRE IS A TRANSLATE.  Two sequences with the same
--       second difference differ by an affine sequence, exactly:
--
--         Δ² f ≡ Δ² g  ⟹  f n ≡ g n + aff (f 0 - g 0) (Δ f 0 - Δ g 0) n .
--
--   §6  AND A BLIND RECEIVER DESCENDS.  Any `Φ` that is additive and
--       annihilates every affine sequence takes the same value on any
--       two sequences with the same second difference.  So such a `Φ` is
--       a function of the second difference alone — it never sees which
--       representative of the fibre it was handed.
--
-- WHAT IS CARRIED IN §6 AND WHY.  That a particular receiver annihilates
-- the affine directions is a HYPOTHESIS here, not a theorem.  For the
-- receiver this is written for, the annihilation is two vanishing sums
-- against a compactly supported packet, which is an analytic fact about
-- that packet and has no carrier in this corpus.  What is proved is that
-- annihilation is exactly what descent requires, and that the fibre it
-- must be blind to is exactly two-dimensional — neither more nor less.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–6 over any commutative ring, for every
-- sequence and every pair of constants.  NOT claimed: that any
-- particular receiver is additive or blind; that a sequence with a
-- prescribed second difference EXISTS — §§4–5 are about the fibre's
-- shape, never its inhabitation; anything about sums, convergence, or
-- boundary terms — there is no summation in this file, so no summation
-- by parts either; and nothing about primes, zeta, or any specific
-- second difference: `Δ² f` is whatever it is.
------------------------------------------------------------------------

module AdrsyaMana_TheKernelOfTheDiscreteSecondDifferenceIsExactlyTheAffineSequencesSoAnAdditiveReceiverBlindToThemDescendsToTheFibre where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
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

    ----------------------------------------------------------------
    -- THE ONLY COORDINATE COMPUTATIONS IN THIS FILE.
    ----------------------------------------------------------------

    sub-cancel : (x y : A) → (x + (- y)) + y ≡ x
    sub-cancel x y = solve! R

    shuffle : (p q s : A) → p + (q + s) ≡ q + (p + s)
    shuffle p q s = solve! R

    affShape : (a b s : A) → (a + (b + s)) + (- (a + s)) ≡ b
    affShape a b s = solve! R

    addShape : (p q r s : A)
      → (p + q) + (- (r + s)) ≡ (p + (- r)) + (q + (- s))
    addShape p q r s = solve! R

    subShape : (p q r s : A)
      → (p + (- q)) + (- (r + (- s))) ≡ (p + (- r)) + (- (q + (- s)))
    subShape p q r s = solve! R

    fromDiff : (x y : A) → x + (- y) ≡ 0r → x ≡ y
    fromDiff x y h = sym (sub-cancel x y) ∙ cong (_+ y) h ∙ +IdL y

    moveR : (x y z : A) → x + (- y) ≡ z → x ≡ y + z
    moveR x y z h = sym (sub-cancel x y) ∙ cong (_+ y) h ∙ +Comm z y

  --------------------------------------------------------------------
  -- ० · The difference operator, iterated addition, and the affine
  --     sequences it is blind to.
  --------------------------------------------------------------------

  Δ : (ℕ → A) → ℕ → A
  Δ f n = f (suc n) + (- f n)

  scale : ℕ → A → A
  scale zero    x = 0r
  scale (suc n) x = x + scale n x

  aff : A → A → ℕ → A
  aff a b n = a + scale n b

  --------------------------------------------------------------------
  -- १ · The first difference of an affine sequence is its slope.
  --------------------------------------------------------------------

  Δ-aff : (a b : A) (n : ℕ) → Δ (aff a b) n ≡ b
  Δ-aff a b n = affShape a b (scale n b)

  --------------------------------------------------------------------
  -- २ · So every affine sequence is in the kernel of Δ².
  --------------------------------------------------------------------

  Δ²-aff : (a b : A) (n : ℕ) → Δ (Δ (aff a b)) n ≡ 0r
  Δ²-aff a b n =
      cong₂ (λ x y → x + (- y)) (Δ-aff a b (suc n)) (Δ-aff a b n)
    ∙ +InvR b

  --------------------------------------------------------------------
  -- ३ · Δ is additive, and additive on differences.
  --------------------------------------------------------------------

  Δ-add : (f g : ℕ → A) (n : ℕ)
    → Δ (λ m → f m + g m) n ≡ Δ f n + Δ g n
  Δ-add f g n = addShape (f (suc n)) (g (suc n)) (f n) (g n)

  Δ-sub : (f g : ℕ → A) (n : ℕ)
    → Δ (λ m → f m + (- g m)) n ≡ Δ f n + (- Δ g n)
  Δ-sub f g n = subShape (f (suc n)) (g (suc n)) (f n) (g n)

  --------------------------------------------------------------------
  -- ४ · THE CONVERSE: the kernel contains nothing else.
  --------------------------------------------------------------------

  module _ (f : ℕ → A) (flat : (n : ℕ) → Δ (Δ f) n ≡ 0r) where

    Δ-constant : (n : ℕ) → Δ f n ≡ Δ f 0
    Δ-constant zero    = refl
    Δ-constant (suc n) =
      fromDiff (Δ f (suc n)) (Δ f n) (flat n) ∙ Δ-constant n

    kernel-is-affine : (n : ℕ) → f n ≡ aff (f 0) (Δ f 0) n
    kernel-is-affine zero    = sym (+IdR (f 0))
    kernel-is-affine (suc n) =
        f (suc n)
      ≡⟨ sym (sub-cancel (f (suc n)) (f n)) ⟩
        Δ f n + f n
      ≡⟨ cong₂ _+_ (Δ-constant n) (kernel-is-affine n) ⟩
        Δ f 0 + (f 0 + scale n (Δ f 0))
      ≡⟨ shuffle (Δ f 0) (f 0) (scale n (Δ f 0)) ⟩
        f 0 + (Δ f 0 + scale n (Δ f 0)) ∎

  --------------------------------------------------------------------
  -- ५ · SO THE FIBRE OF Δ² IS A TRANSLATE BY AN AFFINE SEQUENCE.
  --------------------------------------------------------------------

  module _ (f g : ℕ → A) (same : (n : ℕ) → Δ (Δ f) n ≡ Δ (Δ g) n) where

    private
      h : ℕ → A
      h m = f m + (- g m)

      h-flat : (n : ℕ) → Δ (Δ h) n ≡ 0r
      h-flat n =
          cong (λ φ → Δ φ n) (funExt (λ m → Δ-sub f g m))
        ∙ Δ-sub (Δ f) (Δ g) n
        ∙ cong (λ z → z + (- Δ (Δ g) n)) (same n)
        ∙ +InvR (Δ (Δ g) n)

    fibre-is-affine : (n : ℕ) → f n ≡ g n + aff (h 0) (Δ h 0) n
    fibre-is-affine n =
      moveR (f n) (g n) (aff (h 0) (Δ h 0) n)
            (kernel-is-affine h h-flat n)

  --------------------------------------------------------------------
  -- ६ · AND A BLIND ADDITIVE RECEIVER DESCENDS TO THE FIBRE.
  --------------------------------------------------------------------

  module _ (Φ : (ℕ → A) → A)
           (Φ-add : (f g : ℕ → A) → Φ (λ n → f n + g n) ≡ Φ f + Φ g)
           (Φ-blind : (a b : A) → Φ (aff a b) ≡ 0r)
           where

    receiver-descends : (f g : ℕ → A)
      → ((n : ℕ) → Δ (Δ f) n ≡ Δ (Δ g) n)
      → Φ f ≡ Φ g
    receiver-descends f g same =
        cong Φ (funExt (fibre-is-affine f g same))
      ∙ Φ-add g (aff (f 0 + (- g 0)) (Δ (λ m → f m + (- g m)) 0))
      ∙ cong (Φ g +_) (Φ-blind (f 0 + (- g 0))
                               (Δ (λ m → f m + (- g m)) 0))
      ∙ +IdR (Φ g)
