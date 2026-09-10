{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- द्वितीय-लैब्निट्ज़ — the second-order Leibniz defect.
--
-- A DERIVATION APPLIED TWICE OVERSHOOTS BY EXACTLY TWICE THE CROSS TERM.
--
-- `HolonomyFluxDerivation` carries the first-order seam in its minimal
-- form: a carrier, a product, a sum, and
--
--     leibniz : flux (x ⋆ y) ≡ (flux x ⋆ y) ⊕ (x ⋆ flux y) .
--
-- That signature is deliberately thin — it assumes nothing of `⊕` and
-- nothing of `flux` beyond the displayed law, which is what makes the
-- subdivision result there representation-independent.  Second order
-- needs strictly more, and this module states exactly what: the target
-- must be an abelian group, and the derivation must be ADDITIVE on it.
-- Both are hypotheses below; neither is smuggled in.
--
--   §1  d (d (br a b))
--         ≡ (br (d² a) b + (cross + cross)) + br a (d² b) ,
--       cross = br (d a) (d b) .
--
--       The cross term appears TWICE and does not cancel: a derivation
--       applied twice is not a derivation, and this is by how much.
--
--   §2  the same fact as a defect, which is the form that gets used:
--
--         (d² (br a b) ⊖ br a (d² b)) ⊖ br (d² a) b
--           ≡ cross + cross .
--
--       So the second-order defect is supported ENTIRELY on the product
--       of the two first derivatives.  No first-order term survives.
--
-- WHAT THIS GIVES A SUM-OF-SQUARES OPERATOR, said as a reading and not
-- proved here: for a family of derivations ∂ⱼ and K = − Σⱼ ∂ⱼ², negating
-- §2 and summing over j leaves
--
--     K (br a b) ⊖ br (K a) b ⊖ br a (K b)  =  − 2 Σⱼ br (∂ⱼ a) (∂ⱼ b) ,
--
-- with no first-order term anywhere.  The sum and the sign are the
-- reading; §2 is the theorem, at one derivation.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–2 in an arbitrary ring, carrier taken
-- as the ring itself, for every two-argument `br` — no bilinearity of
-- `br` is used or assumed anywhere below, only the Leibniz law relating
-- it to `d` — every additive `d`, and every pair of arguments.  NOT
-- claimed: the summed form displayed above (it is stated as a reading,
-- with no family, no sum, and no sign proved); anything about commuting
-- derivations; anything about Laplacians on any particular space;
-- anything about brackets satisfying Jacobi; any equation of motion; and
-- nothing about `FluxDerivation`, whose thinner signature does not
-- support §1 and which is not weakened by this module.
------------------------------------------------------------------------

module DvitiyaLeibniz_TheSecondOrderDefectOfADerivationIsExactlyTwiceTheCrossTermSoALaplacianSeesOnlyTheProduct where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.Ring

private
  variable
    ℓ : Level

module _ (R : Ring ℓ) where
  open RingStr (snd R)
  open RingTheory R

  private
    A : Type ℓ
    A = ⟨ R ⟩

    infixl 6 _⊖_
    _⊖_ : A → A → A
    x ⊖ y = x + (- y)

    -- two cancellations, used once each in §2
    cancelR : (x y : A) → (x + y) ⊖ y ≡ x
    cancelR x y =
        (x + y) + (- y)
      ≡⟨ sym (+Assoc x y (- y)) ⟩
        x + (y + (- y))
      ≡⟨ cong (x +_) (+InvR y) ⟩
        x + 0r
      ≡⟨ +IdR x ⟩
        x ∎

    cancelL : (x y : A) → (x + y) ⊖ x ≡ y
    cancelL x y =
        (x + y) + (- x)
      ≡⟨ cong (_+ (- x)) (+Comm x y) ⟩
        (y + x) + (- x)
      ≡⟨ cancelR y x ⟩
        y ∎

  --------------------------------------------------------------------
  -- ० · The setting: a two-argument operation, and an additive
  --     derivation of it.  `br` is arbitrary — NOT the ring product,
  --     and not assumed bilinear.
  --------------------------------------------------------------------

  module _ (br : A → A → A) (d : A → A)
           (dAdd : (x y : A) → d (x + y) ≡ d x + d y)
           (leib : (x y : A) → d (br x y) ≡ br (d x) y + br x (d y))
           where

    d² : A → A
    d² x = d (d x)

    cross : A → A → A
    cross a b = br (d a) (d b)

    private
      shuffle : (w x y z : A) → (w + x) + (y + z) ≡ (w + (x + y)) + z
      shuffle w x y z =
          (w + x) + (y + z)
        ≡⟨ sym (+Assoc w x (y + z)) ⟩
          w + (x + (y + z))
        ≡⟨ cong (w +_) (+Assoc x y z) ⟩
          w + ((x + y) + z)
        ≡⟨ +Assoc w (x + y) z ⟩
          (w + (x + y)) + z ∎

    ------------------------------------------------------------------
    -- १ · THE SECOND-ORDER LAW.  The cross term appears twice.
    ------------------------------------------------------------------

    second-order-leibniz : (a b : A)
      → d² (br a b)
        ≡ (br (d² a) b + (cross a b + cross a b)) + br a (d² b)
    second-order-leibniz a b =
        d (d (br a b))
      ≡⟨ cong d (leib a b) ⟩
        d (br (d a) b + br a (d b))
      ≡⟨ dAdd (br (d a) b) (br a (d b)) ⟩
        d (br (d a) b) + d (br a (d b))
      ≡⟨ cong₂ _+_ (leib (d a) b) (leib a (d b)) ⟩
        (br (d² a) b + br (d a) (d b)) + (br (d a) (d b) + br a (d² b))
      ≡⟨ shuffle (br (d² a) b) (cross a b) (cross a b) (br a (d² b)) ⟩
        (br (d² a) b + (cross a b + cross a b)) + br a (d² b) ∎

    ------------------------------------------------------------------
    -- २ · THE DEFECT.  Subtracting the two pure second-order terms
    --     leaves exactly the doubled cross term, and nothing else.
    ------------------------------------------------------------------

    second-order-defect : (a b : A)
      → (d² (br a b) ⊖ br a (d² b)) ⊖ br (d² a) b
        ≡ (cross a b + cross a b)
    second-order-defect a b =
        (d² (br a b) ⊖ br a (d² b)) ⊖ br (d² a) b
      ≡⟨ cong (λ z → (z ⊖ br a (d² b)) ⊖ br (d² a) b)
              (second-order-leibniz a b) ⟩
        ((((br (d² a) b + (cross a b + cross a b)) + br a (d² b))
            ⊖ br a (d² b)) ⊖ br (d² a) b)
      ≡⟨ cong (_⊖ br (d² a) b)
              (cancelR (br (d² a) b + (cross a b + cross a b)) (br a (d² b))) ⟩
        ((br (d² a) b + (cross a b + cross a b)) ⊖ br (d² a) b)
      ≡⟨ cancelL (br (d² a) b) (cross a b + cross a b) ⟩
        (cross a b + cross a b) ∎
