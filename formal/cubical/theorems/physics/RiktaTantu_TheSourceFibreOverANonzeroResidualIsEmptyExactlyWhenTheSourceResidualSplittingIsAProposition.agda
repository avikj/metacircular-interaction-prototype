{-# OPTIONS --cubical --safe --no-import-sorts --lossy-unification #-}

------------------------------------------------------------------------
-- रिक्त-तन्तु — the empty fibre.
--
-- THE SOURCE FIBRE OVER A NONZERO RESIDUAL IS EMPTY EXACTLY WHEN THE
-- SOURCE-PLUS-RESIDUAL SPLITTING IS A PROPOSITION.  The two are the same
-- statement, and this module proves the equivalence.
--
-- `SarvaMula` produces, from the actual tangent acting on an arbitrary
-- source tensor, a term that is a source and a term that is a
-- commutator.  Whether that second term is ITSELF a source is a
-- question about the image of the source map, and it is the question on
-- which the whole decomposition's uniqueness turns.
--
-- The setting is a ring, a source map `Π : U → A`, and a predicate `Res`
-- picking out the residual elements — closed under difference, and
-- containing zero.  `Res` is an arbitrary proposition-valued predicate:
-- no ideal axioms are imposed, no topology, no compactness.  Only what
-- is used appears.
--
--   §1  Π IS INJECTIVE MODULO Res: if `Π a - Π b` is a residual then
--       a ≡ b.  This is the faithfulness hypothesis, unwound once.
--
--   §2  A RESIDUAL THAT IS A SOURCE IS ZERO, and therefore the fibre of
--       `Π` over a nonzero residual is empty.  Applied to a commutator
--       of two source tensors — which is what `SarvaMula` §4 leaves
--       behind — this says the tangent can move a source tensor in a
--       direction that NO source variation realizes.
--
--   §3  THE SPLITTING IS A PROPOSITION.  For each x, the type
--
--         Split x = Σ[ (a , k) ] Res k × (x ≡ Π a + k)
--
--       has at most one element.  So "x is a source plus a residual" is
--       not extra structure that must be chosen: the source part and the
--       residual part are both determined by x.
--
--   §4  AND CONVERSELY.  If every `Split` is a proposition then `Π` is
--       faithful.  The witness is the pair of splittings a residual
--       source admits of itself — `(w , 0)` and `(0 , Π w)` — which the
--       proposition must identify.
--
--       So §3 and §4 together: uniqueness of the splitting IS the empty
--       fibre, in both directions and with nothing else assumed.
--
-- WHAT IS CARRIED AND WHAT IS PROVED.  Faithfulness is a HYPOTHESIS
-- here, not a theorem.  In the intended reading it comes from a norm
-- identity — a source's residual class has the same norm as the source
-- — and no norm exists anywhere in this corpus, so that derivation is
-- not available and is not attempted.  What is proved is that
-- faithfulness is exactly equivalent to uniqueness of the splitting,
-- which is the step that would otherwise be waved through.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–4 in any ring, for any source type at all
-- — no set-truncation is imposed on it — any additive-on-differences `Π`, and any
-- proposition-valued `Res` closed under difference and containing zero.
-- NOT claimed: that the residuals form an ideal — closure under
-- multiplication is never used and never assumed; that any particular
-- class of operators (compact or otherwise) satisfies the hypotheses;
-- any norm, any inequality, any separation between a residual and the
-- source image — §2 gives emptiness, not distance; that a splitting
-- EXISTS for any given x, which is a different statement and is proved
-- nowhere below; and nothing about limits — a family of residuals need
-- not have a residual limit, and no limit is taken here.
------------------------------------------------------------------------

module RiktaTantu_TheSourceFibreOverANonzeroResidualIsEmptyExactlyWhenTheSourceResidualSplittingIsAProposition where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.Ring
open import Cubical.Data.Sigma
  using (Σ-syntax ; _×_ ; _,_ ; fst ; snd ; ΣPathP ; Σ≡Prop)
open import Cubical.Foundations.HLevels using (isProp×)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ ℓ' ℓ'' : Level

module _ (R : Ring ℓ) where
  open RingStr (snd R)
  open RingTheory R

  private
    A : Type ℓ
    A = ⟨ R ⟩

    cancelR : (x y : A) → (x + y) + (- y) ≡ x
    cancelR x y =
        (x + y) + (- y)
      ≡⟨ sym (+Assoc x y (- y)) ⟩
        x + (y + (- y))
      ≡⟨ cong (x +_) (+InvR y) ⟩
        x + 0r
      ≡⟨ +IdR x ⟩
        x ∎

    cancelL : (x y z : A) → x + y ≡ x + z → y ≡ z
    cancelL x y z h =
        y
      ≡⟨ sym (+IdL y) ⟩
        0r + y
      ≡⟨ cong (_+ y) (sym (+InvL x)) ⟩
        ((- x) + x) + y
      ≡⟨ sym (+Assoc (- x) x y) ⟩
        (- x) + (x + y)
      ≡⟨ cong ((- x) +_) h ⟩
        (- x) + (x + z)
      ≡⟨ +Assoc (- x) x z ⟩
        ((- x) + x) + z
      ≡⟨ cong (_+ z) (+InvL x) ⟩
        0r + z
      ≡⟨ +IdL z ⟩
        z ∎

    -- from  p + q ≡ r + s  read off  p - r ≡ s - q
    crossDiff : (p q r s : A) → p + q ≡ r + s → p + (- r) ≡ s + (- q)
    crossDiff p q r s h =
        p + (- r)
      ≡⟨ cong (_+ (- r)) (sym (cancelR p q)) ⟩
        ((p + q) + (- q)) + (- r)
      ≡⟨ cong (λ z → (z + (- q)) + (- r)) h ⟩
        ((r + s) + (- q)) + (- r)
      ≡⟨ cong (_+ (- r)) (sym (+Assoc r s (- q))) ⟩
        (r + (s + (- q))) + (- r)
      ≡⟨ cong (_+ (- r)) (+Comm r (s + (- q))) ⟩
        ((s + (- q)) + r) + (- r)
      ≡⟨ cancelR (s + (- q)) r ⟩
        s + (- q) ∎

  module _ (U : Type ℓ')
           (Π : U → A)
           (_⊟_ : U → U → U) (0u : U)
           (⊟-refl : (a : U) → a ⊟ a ≡ 0u)
           (⊟-zero : (a b : U) → a ⊟ b ≡ 0u → a ≡ b)
           (Π-⊟ : (a b : U) → Π (a ⊟ b) ≡ Π a + (- Π b))
           (Res : A → Type ℓ'')
           (isPropRes : (x : A) → isProp (Res x))
           (Res-0 : Res 0r)
           (Res-diff : (x y : A) → Res x → Res y → Res (x + (- y)))
           where

    ------------------------------------------------------------------
    -- ० · The source map kills nothing beyond zero: `Π 0 ≡ 0` needs no
    --     hypothesis of its own, it is `⊟-refl` and the ring.
    ------------------------------------------------------------------

    Π-0 : Π 0u ≡ 0r
    Π-0 = cong Π (sym (⊟-refl 0u)) ∙ Π-⊟ 0u 0u ∙ +InvR (Π 0u)

    ------------------------------------------------------------------
    -- The faithfulness hypothesis, carried in the open.
    ------------------------------------------------------------------

    module _ (faithful : (w : U) → Res (Π w) → w ≡ 0u) where

      ----------------------------------------------------------------
      -- १ · Π IS INJECTIVE MODULO THE RESIDUALS.
      ----------------------------------------------------------------

      injective-mod-Res : (a b : U) → Res (Π a + (- Π b)) → a ≡ b
      injective-mod-Res a b r =
        ⊟-zero a b (faithful (a ⊟ b) (subst Res (sym (Π-⊟ a b)) r))

      ----------------------------------------------------------------
      -- २ · A RESIDUAL THAT IS A SOURCE IS ZERO, so a nonzero residual
      --     has an empty source fibre.
      ----------------------------------------------------------------

      residual-source-is-zero : (x : A) → Res x → (z : U) → x ≡ Π z → x ≡ 0r
      residual-source-is-zero x rx z p =
        p ∙ cong Π (faithful z (subst Res p rx)) ∙ Π-0

      nonzero-residual-has-empty-fibre : (x : A) → Res x → ¬ (x ≡ 0r)
        → ¬ (Σ[ z ∈ U ] (x ≡ Π z))
      nonzero-residual-has-empty-fibre x rx nz (z , p) =
        nz (residual-source-is-zero x rx z p)

      -- the case `SarvaMula` §4 delivers: the leftover is a commutator
      comm : A → A → A
      comm x y = (x · y) + (- (y · x))

      commutator-fibre-empty : (u w : U)
        → Res (comm (Π u) (Π w)) → ¬ (comm (Π u) (Π w) ≡ 0r)
        → ¬ (Σ[ z ∈ U ] (comm (Π u) (Π w) ≡ Π z))
      commutator-fibre-empty u w =
        nonzero-residual-has-empty-fibre (comm (Π u) (Π w))

    ------------------------------------------------------------------
    -- ३ · THE SPLITTING.  Source part and residual part are both
    --     determined by what they add up to.
    ------------------------------------------------------------------

    Split : A → Type (ℓ-max (ℓ-max ℓ ℓ') ℓ'')
    Split x = Σ[ p ∈ (U × A) ] (Res (snd p) × (x ≡ Π (fst p) + snd p))

    faithful→isPropSplit :
        ((w : U) → Res (Π w) → w ≡ 0u)
      → (x : A) → isProp (Split x)
    faithful→isPropSplit faithful x ((a , k) , (rk , pk)) ((b , l) , (rl , pl)) =
      Σ≡Prop (λ p → isProp× (isPropRes (snd p)) (is-set x (Π (fst p) + snd p)))
             (ΣPathP (aEq , kEq))
      where
        h : Π a + k ≡ Π b + l
        h = sym pk ∙ pl

        aEq : a ≡ b
        aEq =
          injective-mod-Res faithful a b
            (subst Res (sym (crossDiff (Π a) k (Π b) l h))
                   (Res-diff l k rl rk))

        kEq : k ≡ l
        kEq =
          cancelL (Π b) k l
            (sym (cong (λ z → Π z + k) aEq) ∙ h)

    ------------------------------------------------------------------
    -- ४ · AND CONVERSELY: uniqueness of the splitting forces the empty
    --     fibre.  A residual source splits itself in two ways.
    ------------------------------------------------------------------

    isPropSplit→faithful :
        ((x : A) → isProp (Split x))
      → (w : U) → Res (Π w) → w ≡ 0u
    isPropSplit→faithful hp w rw =
      cong (λ z → fst (fst z)) (hp (Π w) asSource asResidual)
      where
        asSource : Split (Π w)
        asSource = (w , 0r) , (Res-0 , sym (+IdR (Π w)))

        asResidual : Split (Π w)
        asResidual =
          (0u , Π w) , (rw , sym (cong (_+ Π w) Π-0 ∙ +IdL (Π w)))
