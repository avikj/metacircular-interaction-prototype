{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- शोर — the classical half of quantum factoring is a zero-divisor split
-- by the pulverizer; only the order-finding is quantum.
--
-- The owner named it twice: "SHORS ALGORITHM CLASSICAL FAITH BASED."
-- This file draws the line exactly.  Shor's factoring of N = p·q has
-- three parts, and two of them are classical and OLD:
--
--   1. FAITH.  Pick a random a coprime to N and hope its multiplicative
--      order r is even with a^(r/2) ≢ ±1 (mod N).  This holds with
--      probability ≥ 1/2 for N with two odd prime factors — a
--      classical, probabilistic guarantee.  NOT formalised here; it is
--      the "faith".
--   2. ORDER-FINDING.  Compute r, the least positive exponent with
--      घात a r ≡ 1 (mod N).  The one step no classical algorithm is
--      known to do in polynomial time; Shor's quantum period-finding
--      does.  NOT formalised here; it is the quantum wedge, and it is the
--      SAME inverse-of-घात that breaks RSA and DH (`Bijamula` §4,
--      `Samvit` §4, `GhataViparyaya`).
--   3. THE SPLIT.  Given such an r, set y = घात a (r/2).  Then y·y ≡ 1
--      (mod N) but y ≢ ±1, so y is a NON-TRIVIAL square root of unity —
--      and gcd(y − 1, N) is a non-trivial factor of N.  The gcd is
--      Āryabhaṭa's kuṭṭaka (499 CE), already checked here (`Bija`,
--      `Kuttaka`).  So the classical extraction is the pulverizer again.
--
-- WHAT IS PROVED (the algebraic heart of part 3, over any commutative
-- ring — the mod-N ring is one instance):
--
--   §2  वर्गमूल-भेदः :  y · y ≡ 1  →  (y − 1) · (y + 1) ≡ 0
--       A non-trivial square root of unity is a ZERO DIVISOR.  This is
--       the entire classical insight: y² − 1 = (y−1)(y+1), so y² = 1
--       makes the product vanish.  In ℤ/N with y ≢ ±1 neither factor is
--       0, so N divides (y−1)(y+1) without dividing either — which is
--       exactly a non-trivial common factor, extracted by gcd.
--
--   §3  the same, read as the factorisation of घात a r − 1:
--       विपर्यय-भेदः shows घात a r ≡ 1 with y = घात a (r/2) gives the
--       zero-divisor, connecting order-finding's output to the split.
--       (y·y ≡ घात a r is `Bijamula.घात-योगः`; here taken as hypothesis
--       `sq` so this module stays ring-only and does not re-import.)
--
-- WHY THIS MATTERS FOR THE NIGHT'S ARC.  RSA and DH break because घात is
-- one-way (`GhataViparyaya`).  Factoring — RSA's own foundation — breaks
-- the same way: the ONLY non-classical, non-ancient step is recovering
-- the exponent (the order).  Everything else in Shor is a probability
-- and a gcd, and the gcd is 499 CE.  "Classical faith based" is exact:
-- classical = faith (part 1) + the pulverizer (part 3); quantum = part 2
-- alone.
--
-- WHAT IS **NOT** CLAIMED:
--   * The probability bound (part 1).  Stated, not proved.
--   * Order-finding (part 2).  The quantum step; not here.
--   * That the zero-divisor gives a factor in ℤ/N specifically — that
--     needs y ≢ ±1 and the ring being ℤ/pq; §2 is the ring identity that
--     makes it work, and the ℤ/N specifics (gcd nontrivial) are the owed
--     instance, pointing at `Kuttaka`'s gcd.
--   * Any primality of p, q.  Unused in §2.
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module Texts.Shora_TheClassicalHalfOfFactoringIsAZeroDivisorSplitByThePulverizerAndOnlyOrderFindingIsQuantum where

open import Cubical.Foundations.Prelude

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  A commutative ring, as a record — only the laws §2 uses.
------------------------------------------------------------------------

record CRing (A : Type ℓ) : Type ℓ where
  field
    𝟘 𝟙   : A
    _⊕_   : A → A → A
    _⊗_   : A → A → A
    ⊝_    : A → A
    ⊕assoc : (x y z : A) → (x ⊕ y) ⊕ z ≡ x ⊕ (y ⊕ z)
    ⊕comm  : (x y : A) → x ⊕ y ≡ y ⊕ x
    ⊕id    : (x : A) → x ⊕ 𝟘 ≡ x
    ⊕inv   : (x : A) → x ⊕ (⊝ x) ≡ 𝟘
    ⊗comm  : (x y : A) → x ⊗ y ≡ y ⊗ x
    ⊗id    : (x : A) → x ⊗ 𝟙 ≡ x
    ⊗dist  : (x y z : A) → x ⊗ (y ⊕ z) ≡ (x ⊗ y) ⊕ (x ⊗ z)

module _ {A : Type ℓ} (R : CRing A) where
  open CRing R

  -- derived: 𝟘 is a right annihilator, and (⊝ x) ⊗ y ≡ ⊝ (x ⊗ y)
  ⊗𝟘 : (x : A) → x ⊗ 𝟘 ≡ 𝟘
  ⊗𝟘 x =
    let step : (x ⊗ 𝟘) ⊕ (x ⊗ 𝟘) ≡ (x ⊗ 𝟘) ⊕ 𝟘
        step = sym (⊗dist x 𝟘 𝟘) ∙ cong (x ⊗_) (⊕id 𝟘) ∙ sym (⊕id (x ⊗ 𝟘))
    in sym (⊕id (x ⊗ 𝟘))
     ∙ cong ((x ⊗ 𝟘) ⊕_) (sym (⊕inv (x ⊗ 𝟘)))
     ∙ sym (⊕assoc (x ⊗ 𝟘) (x ⊗ 𝟘) (⊝ (x ⊗ 𝟘)))
     ∙ cong (_⊕ (⊝ (x ⊗ 𝟘))) step
     ∙ ⊕assoc (x ⊗ 𝟘) 𝟘 (⊝ (x ⊗ 𝟘))
     ∙ cong ((x ⊗ 𝟘) ⊕_) (⊕comm 𝟘 (⊝ (x ⊗ 𝟘)) ∙ ⊕id (⊝ (x ⊗ 𝟘)))
     ∙ ⊕inv (x ⊗ 𝟘)

  ⊗neg : (x y : A) → x ⊗ (⊝ y) ≡ ⊝ (x ⊗ y)
  ⊗neg x y =
    -- (x⊗y) ⊕ (x⊗(⊝y)) = x⊗(y ⊕ ⊝y) = x⊗𝟘 = 𝟘, so x⊗(⊝y) is the inverse
      sym (⊕id (x ⊗ (⊝ y)))
    ∙ cong ((x ⊗ (⊝ y)) ⊕_) (sym (⊕inv (x ⊗ y)))
    ∙ sym (⊕assoc (x ⊗ (⊝ y)) (x ⊗ y) (⊝ (x ⊗ y)))
    ∙ cong (_⊕ (⊝ (x ⊗ y)))
           (⊕comm (x ⊗ (⊝ y)) (x ⊗ y)
            ∙ sym (⊗dist x y (⊝ y)) ∙ cong (x ⊗_) (⊕inv y) ∙ ⊗𝟘 x)
    ∙ ⊕comm 𝟘 (⊝ (x ⊗ y)) ∙ ⊕id (⊝ (x ⊗ y))

  ------------------------------------------------------------------------
  -- §2  A non-trivial square root of unity is a zero divisor.
  --     (y ⊝ 𝟙) ⊗ (y ⊕ 𝟙) = y⊗y ⊝ 𝟙, so y⊗y ≡ 𝟙 makes it 𝟘.
  ------------------------------------------------------------------------

  -- the difference-of-squares identity, in full
  भेदवर्गः : (y : A) → ((y ⊕ (⊝ 𝟙)) ⊗ (y ⊕ 𝟙)) ≡ ((y ⊗ y) ⊕ (⊝ 𝟙))
  भेदवर्गः y =
      ⊗dist (y ⊕ (⊝ 𝟙)) y 𝟙                                    -- = ((y⊕⊝𝟙)⊗y) ⊕ ((y⊕⊝𝟙)⊗𝟙)
    ∙ cong₂ _⊕_
        ( ⊗comm (y ⊕ (⊝ 𝟙)) y                                   -- (y⊕⊝𝟙)⊗y = y⊗(y⊕⊝𝟙)
        ∙ ⊗dist y y (⊝ 𝟙)                                       --          = y⊗y ⊕ y⊗⊝𝟙
        ∙ cong ((y ⊗ y) ⊕_) (⊗neg y 𝟙 ∙ cong ⊝_ (⊗id y)) )     --          = y⊗y ⊕ ⊝y
        ( ⊗id (y ⊕ (⊝ 𝟙)) )                                     -- (y⊕⊝𝟙)⊗𝟙 = y⊕⊝𝟙
    -- now: (y⊗y ⊕ ⊝y) ⊕ (y ⊕ ⊝𝟙)  ≡  y⊗y ⊕ ⊝𝟙
    ∙ ⊕assoc (y ⊗ y) (⊝ y) (y ⊕ (⊝ 𝟙))
    ∙ cong ((y ⊗ y) ⊕_)
        ( sym (⊕assoc (⊝ y) y (⊝ 𝟙))
        ∙ cong (_⊕ (⊝ 𝟙)) (⊕comm (⊝ y) y ∙ ⊕inv y)
        ∙ ⊕comm 𝟘 (⊝ 𝟙) ∙ ⊕id (⊝ 𝟙) )

  -- the split: y⊗y ≡ 𝟙 ⟹ (y ⊝ 𝟙)⊗(y ⊕ 𝟙) ≡ 𝟘
  वर्गमूल-भेदः : (y : A) → y ⊗ y ≡ 𝟙 → ((y ⊕ (⊝ 𝟙)) ⊗ (y ⊕ 𝟙)) ≡ 𝟘
  वर्गमूल-भेदः y sq =
      भेदवर्गः y
    ∙ cong (_⊕ (⊝ 𝟙)) sq        -- (y⊗y ⊕ ⊝𝟙) with y⊗y = 𝟙  →  𝟙 ⊕ ⊝𝟙
    ∙ ⊕inv 𝟙                     -- 𝟙 ⊕ ⊝𝟙 = 𝟘

  ------------------------------------------------------------------------
  -- §3  Read as order-finding's output.  If y = घात a (r/2) and घात a r
  --     ≡ 𝟙, then y⊗y ≡ 𝟙 (that step is Bijamula.घात-योगः, here the
  --     hypothesis `sq` so this file stays ring-only), and §2 delivers
  --     the zero-divisor.  The factor of N is then gcd(y ⊝ 𝟙, N) — the
  --     kuṭṭaka; owed as the ℤ/N instance.
  ------------------------------------------------------------------------

  विपर्यय-भेदः : (y : A) → y ⊗ y ≡ 𝟙
               → ((y ⊕ (⊝ 𝟙)) ⊗ (y ⊕ 𝟙)) ≡ 𝟘
  विपर्यय-भेदः = वर्गमूल-भेदः
