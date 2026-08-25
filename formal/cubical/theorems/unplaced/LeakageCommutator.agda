{-# OPTIONS --cubical --safe --no-import-sorts --lossy-unification #-}

------------------------------------------------------------------------
-- LeakageCommutator
--
-- The commutator is the antisymmetrization of the leakage.
--
-- Companion prose: notes/LEAKAGE_IS_HALF_COMMUTATOR_RANK.md, which states
-- the linear-algebra form
--
--     rank ((I - P) A P)  =  (1/2) · rank [P , A]
--
-- for an orthogonal projection P and a self-adjoint A.  Rank is a
-- model-dependent notion; the ALGEBRA underneath it is not, and the
-- algebra is what is checked here.  In any ring with involution, writing
--
--     L  =  (1 - p) · a · p                      (the leakage)
--
-- for self-adjoint p and a,
--
--     p · a - a · p  =  L† - L .
--
-- Three things formalization exposed that the prose had wrong or hidden:
--
--  1. IDEMPOTENCE OF p IS NEVER USED.  The note assumes p is a projection
--     throughout.  The identity needs only p† ≡ p.  Idempotence is what
--     makes L *mean* "what escapes an installed projector", and it is
--     needed for the rank corollary -- it is not needed for the identity.
--
--  2. † 1r ≡ 1r IS NOT AN AXIOM.  It was a hypothesis in the first draft.
--     It follows from antimultiplicativity and involutivity alone
--     (`†-pres-1` below), because an involution is its own inverse and
--     therefore surjective.
--
--  3. The rank statement = this identity + the model fact rank X = rank X†.
--     The identity is the transportable half; the halving is exactly where
--     the concrete model enters, and it does not live at this level of
--     generality.
------------------------------------------------------------------------

module LeakageCommutator where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.Ring

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- An involution: additive, antimultiplicative, self-inverse.
------------------------------------------------------------------------

record IsInvolution (R : Ring ℓ) (†_ : ⟨ R ⟩ → ⟨ R ⟩) : Type ℓ where
  open RingStr (snd R)
  field
    †-invol : (x : ⟨ R ⟩) → † († x) ≡ x
    †-+     : (x y : ⟨ R ⟩) → † (x + y) ≡ († x) + († y)
    †-·     : (x y : ⟨ R ⟩) → † (x · y) ≡ († y) · († x)

module _ (R : Ring ℓ) (†_ : ⟨ R ⟩ → ⟨ R ⟩) (inv : IsInvolution R †_) where
  open RingStr (snd R)
  open RingTheory R
  open IsInvolution inv

  private
    A : Type ℓ
    A = ⟨ R ⟩

    infixl 6 _⊖_
    _⊖_ : A → A → A
    x ⊖ y = x + (- y)

  ----------------------------------------------------------------------
  -- Elementary consequences of the involution axioms.
  ----------------------------------------------------------------------

  -- The unit is self-adjoint.  NOT assumed: an involution is surjective
  -- because it is its own inverse, so †1 acts as an identity on all of R.
  †-pres-1 : † 1r ≡ 1r
  †-pres-1 =
      † 1r
    ≡⟨ sym (·IdR († 1r)) ⟩
      († 1r) · 1r
    ≡⟨ cong ((† 1r) ·_) (sym (†-invol 1r)) ⟩
      († 1r) · († († 1r))
    ≡⟨ sym (†-· († 1r) 1r) ⟩
      † ((† 1r) · 1r)
    ≡⟨ cong †_ (·IdR († 1r)) ⟩
      † († 1r)
    ≡⟨ †-invol 1r ⟩
      1r ∎

  †-pres-0 : † 0r ≡ 0r
  †-pres-0 =
      † 0r
    ≡⟨ sym (+IdR _) ⟩
      († 0r) + 0r
    ≡⟨ cong ((† 0r) +_) (sym (+InvR († 0r))) ⟩
      († 0r) + ((† 0r) + (- († 0r)))
    ≡⟨ +Assoc _ _ _ ⟩
      ((† 0r) + († 0r)) + (- († 0r))
    ≡⟨ cong (_+ (- († 0r))) (sym (†-+ 0r 0r) ∙ cong †_ (+IdR 0r)) ⟩
      († 0r) + (- († 0r))
    ≡⟨ +InvR _ ⟩
      0r ∎

  †-pres-neg : (x : A) → † (- x) ≡ - († x)
  †-pres-neg x =
    implicitInverse († x) († (- x))
      (sym (†-+ x (- x)) ∙ cong †_ (+InvR x) ∙ †-pres-0)

  -- Self-adjointness passes to differences of self-adjoint elements.
  †-pres-⊖ : (x y : A) → († x ≡ x) → († y ≡ y) → † (x ⊖ y) ≡ x ⊖ y
  †-pres-⊖ x y hx hy =
    †-+ x (- y) ∙ cong₂ _+_ hx (†-pres-neg y ∙ cong -_ hy)

  ----------------------------------------------------------------------
  -- The leakage of an action `a` past an installed `p`.
  ----------------------------------------------------------------------

  leak : A → A → A
  leak p a = ((1r ⊖ p) · a) · p

  -- L = a·p - (p·a)·p .  No involution, no idempotence.
  leak-expand : (p a : A) → leak p a ≡ (a · p) ⊖ ((p · a) · p)
  leak-expand p a =
      ((1r ⊖ p) · a) · p
    ≡⟨ cong (_· p) (·DistL+ 1r (- p) a) ⟩
      ((1r · a) + ((- p) · a)) · p
    ≡⟨ cong (λ z → (z + ((- p) · a)) · p) (·IdL a) ⟩
      (a + ((- p) · a)) · p
    ≡⟨ cong (λ z → (a + z) · p) (-DistL· p a) ⟩
      (a ⊖ (p · a)) · p
    ≡⟨ ·DistL+ a (- (p · a)) p ⟩
      (a · p) + ((- (p · a)) · p)
    ≡⟨ cong ((a · p) +_) (-DistL· (p · a) p) ⟩
      (a · p) ⊖ ((p · a) · p) ∎

  -- L† = p·a - (p·a)·p , for self-adjoint p and a.
  leak-adjoint : (p a : A) → († p ≡ p) → († a ≡ a)
               → † (leak p a) ≡ (p · a) ⊖ ((p · a) · p)
  leak-adjoint p a hp ha =
      † (((1r ⊖ p) · a) · p)
    ≡⟨ †-· ((1r ⊖ p) · a) p ⟩
      († p) · († ((1r ⊖ p) · a))
    ≡⟨ cong (_· († ((1r ⊖ p) · a))) hp ⟩
      p · († ((1r ⊖ p) · a))
    ≡⟨ cong (p ·_) (†-· (1r ⊖ p) a) ⟩
      p · ((† a) · († (1r ⊖ p)))
    ≡⟨ cong (λ z → p · (z · († (1r ⊖ p)))) ha ⟩
      p · (a · († (1r ⊖ p)))
    ≡⟨ cong (λ z → p · (a · z)) (†-pres-⊖ 1r p †-pres-1 hp) ⟩
      p · (a · (1r ⊖ p))
    ≡⟨ cong (p ·_) (·DistR+ a 1r (- p)) ⟩
      p · ((a · 1r) + (a · (- p)))
    ≡⟨ cong (λ z → p · (z + (a · (- p)))) (·IdR a) ⟩
      p · (a + (a · (- p)))
    ≡⟨ cong (λ z → p · (a + z)) (-DistR· a p) ⟩
      p · (a ⊖ (a · p))
    ≡⟨ ·DistR+ p a (- (a · p)) ⟩
      (p · a) + (p · (- (a · p)))
    ≡⟨ cong ((p · a) +_) (-DistR· p (a · p)) ⟩
      (p · a) ⊖ (p · (a · p))
    ≡⟨ cong (λ z → (p · a) + (- z)) (·Assoc p a p) ⟩
      (p · a) ⊖ ((p · a) · p) ∎

  ----------------------------------------------------------------------
  -- Additive bookkeeping: (x - z) - (y - z) ≡ x - y.
  ----------------------------------------------------------------------

  private
    swapMid : (u v w t : A) → (u + v) + (w + t) ≡ (u + w) + (v + t)
    swapMid u v w t =
        (u + v) + (w + t)
      ≡⟨ sym (+Assoc _ _ _) ⟩
        u + (v + (w + t))
      ≡⟨ cong (u +_) (+Assoc v w t) ⟩
        u + ((v + w) + t)
      ≡⟨ cong (λ s → u + (s + t)) (+Comm v w) ⟩
        u + ((w + v) + t)
      ≡⟨ cong (u +_) (sym (+Assoc w v t)) ⟩
        u + (w + (v + t))
      ≡⟨ +Assoc _ _ _ ⟩
        (u + w) + (v + t) ∎

    neg-⊖ : (y z : A) → - (y ⊖ z) ≡ (- y) + z
    neg-⊖ y z = sym (-Dist y (- z)) ∙ cong ((- y) +_) (-Idempotent z)

    cancelMid : (x y z : A) → (x ⊖ z) ⊖ (y ⊖ z) ≡ x ⊖ y
    cancelMid x y z =
        (x ⊖ z) ⊖ (y ⊖ z)
      ≡⟨ cong ((x + (- z)) +_) (neg-⊖ y z) ⟩
        (x + (- z)) + ((- y) + z)
      ≡⟨ swapMid x (- z) (- y) z ⟩
        (x + (- y)) + ((- z) + z)
      ≡⟨ cong ((x + (- y)) +_) (+InvL z) ⟩
        (x + (- y)) + 0r
      ≡⟨ +IdR _ ⟩
        x ⊖ y ∎

  ----------------------------------------------------------------------
  -- THE THEOREM.
  --
  --     p · a - a · p  ≡  L† - L
  --
  -- Hypotheses: p and a self-adjoint.  That is all.
  ----------------------------------------------------------------------

  commutator-is-antisymmetrized-leakage :
      (p a : A) → († p ≡ p) → († a ≡ a)
    → (p · a) ⊖ (a · p) ≡ († (leak p a)) ⊖ (leak p a)
  commutator-is-antisymmetrized-leakage p a hp ha =
    sym ( cong₂ _⊖_ (leak-adjoint p a hp ha) (leak-expand p a)
        ∙ cancelMid (p · a) (a · p) ((p · a) · p) )

  ----------------------------------------------------------------------
  -- Corollary: zero leakage is exactly commutation.  This is
  -- `LEAKAGE_RANK_IS_INCIDENCE_RANK` Lemma 1.1 with "A is an orthogonal
  -- projection" weakened to "A is self-adjoint", and with idempotence of
  -- P dropped as well.
  ----------------------------------------------------------------------

  leak-zero→commutes :
      (p a : A) → († p ≡ p) → († a ≡ a)
    → leak p a ≡ 0r → p · a ≡ a · p
  leak-zero→commutes p a hp ha h0 =
    equalByDifference (p · a) (a · p)
      ( commutator-is-antisymmetrized-leakage p a hp ha
      ∙ cong₂ _⊖_ (cong †_ h0 ∙ †-pres-0) h0
      ∙ +InvR 0r )
