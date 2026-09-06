{-# OPTIONS --cubical --safe --no-import-sorts --lossy-unification #-}

------------------------------------------------------------------------
-- व्यतिक्रम — the crossing.
--
-- THE COMMUTATOR OF A SELF-ADJOINT WITH A SKEW-ADJOINT IS SELF-ADJOINT.
--
-- `LeakageCommutator` proves, in any ring with involution, that for two
-- SELF-ADJOINT elements the commutator is the antisymmetrized leakage:
--
--     p · a - a · p  ≡  L† - L ,      L = (1 - p) · a · p .
--
-- Its hypothesis `† a ≡ a` is load-bearing, and a helicity-split
-- evolution sits on the other side of it: there the sign operator is
-- self-adjoint and the interaction is SKEW-adjoint.  What must hold for
-- the cross-sector current to be a real quantity — the common
-- production term of two positive budgets, rather than an indefinite
-- bookkeeping artefact — is that their commutator is SELF-adjoint.
--
-- The received route is to multiply the skew element by i and reuse the
-- self-adjoint theorem.  That is unnecessary, and it costs a complex
-- structure the statement does not need.  Everything below is proved
-- directly in an arbitrary ring with involution: no scalars, no i, no
-- idempotence, and no hypothesis beyond the two adjointness equations.
--
-- THE PARITY TABLE, and it is the whole content:
--
--                        [p,a]†            {p,a}†
--     a self-adjoint     -[p,a]   (§2)      {p,a}
--     a skew-adjoint     +[p,a]   (§1)     -{p,a}   (§3)
--
--   §1  p† ≡ p , a† ≡ -a  ⟹  [p,a]† ≡  [p,a]
--   §2  p† ≡ p , a† ≡  a  ⟹  [p,a]† ≡ -[p,a]
--   §3  p† ≡ p , a† ≡ -a  ⟹  {p,a}† ≡ -{p,a}
--
-- §1 is the entry the cross-sector current inhabits; §2 is the parent
-- module's parity, stated here so the flip is exhibited rather than
-- asserted; §3 is the companion that shows the commutator is the ONLY
-- bracket of the two that pairs really in the skew case.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–3 for any ring with involution, for
-- all p and a satisfying the stated equations.  NOT claimed: anything
-- about operators on a function space, about projections (idempotence
-- is never used, as in the parent), or about any analytic pairing
-- ⟨ x , [p,a] x ⟩ — the algebra is the transportable half, and which
-- ring one instantiates it in is where a concrete model enters.
------------------------------------------------------------------------

module Vyatikrama_TheCommutatorOfASelfAdjointWithASkewAdjointIsSelfAdjointSoTheCrossSectorCurrentIsARealPairing where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.Ring

open import LeakageCommutator using (IsInvolution)

private
  variable
    ℓ : Level

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
  -- ० · The two elementary consequences this file needs.  Restated from
  --     the parent's proof so the module stands on the axioms alone.
  ----------------------------------------------------------------------

  †-pres-0' : † 0r ≡ 0r
  †-pres-0' =
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

  †-pres-neg' : (x : A) → † (- x) ≡ - († x)
  †-pres-neg' x =
    implicitInverse († x) († (- x))
      (sym (†-+ x (- x)) ∙ cong †_ (+InvR x) ∙ †-pres-0')

  ----------------------------------------------------------------------
  -- The two brackets.
  ----------------------------------------------------------------------

  bracket : A → A → A                     -- [p , a]
  bracket p a = (p · a) ⊖ (a · p)

  anti : A → A → A                        -- {p , a}
  anti p a = (p · a) + (a · p)

  ----------------------------------------------------------------------
  -- १ · CROSS PARITY: the commutator of a self-adjoint with a
  --     skew-adjoint is SELF-ADJOINT.
  --
  --       †(p·a - a·p) = (†a)(†p) - (†p)(†a)
  --                    = (-a)p - p(-a)
  --                    = -(a·p) + (p·a)
  --                    =  p·a - a·p .
  ----------------------------------------------------------------------

  comm-selfadjoint-skew :
      (p a : A) → († p ≡ p) → († a ≡ - a)
    → † (bracket p a) ≡ bracket p a
  comm-selfadjoint-skew p a hp ha =
      † ((p · a) + (- (a · p)))
    ≡⟨ †-+ (p · a) (- (a · p)) ⟩
      († (p · a)) + († (- (a · p)))
    ≡⟨ cong ((† (p · a)) +_) (†-pres-neg' (a · p)) ⟩
      († (p · a)) + (- († (a · p)))
    ≡⟨ cong₂ (λ u v → u + (- v)) (†-· p a) (†-· a p) ⟩
      ((† a) · († p)) + (- ((† p) · († a)))
    ≡⟨ cong₂ (λ u v → (u · († p)) + (- ((† p) · v))) ha ha ⟩
      ((- a) · († p)) + (- ((† p) · (- a)))
    ≡⟨ cong₂ (λ u v → ((- a) · u) + (- (v · (- a)))) hp hp ⟩
      ((- a) · p) + (- (p · (- a)))
    ≡⟨ cong₂ (λ u v → u + (- v)) (-DistL· a p) (-DistR· p a) ⟩
      (- (a · p)) + (- (- (p · a)))
    ≡⟨ cong ((- (a · p)) +_) (-Idempotent (p · a)) ⟩
      (- (a · p)) + (p · a)
    ≡⟨ +Comm (- (a · p)) (p · a) ⟩
      (p · a) + (- (a · p)) ∎

  ----------------------------------------------------------------------
  -- २ · THE PARENT'S PARITY: both self-adjoint, commutator SKEW.
  --     Same computation with `ha` used the other way, then the
  --     negation pulled out of the sum.
  ----------------------------------------------------------------------

  comm-skew-selfadjoint :
      (p a : A) → († p ≡ p) → († a ≡ a)
    → † (bracket p a) ≡ - (bracket p a)
  comm-skew-selfadjoint p a hp ha =
      † ((p · a) + (- (a · p)))
    ≡⟨ †-+ (p · a) (- (a · p)) ⟩
      († (p · a)) + († (- (a · p)))
    ≡⟨ cong ((† (p · a)) +_) (†-pres-neg' (a · p)) ⟩
      († (p · a)) + (- († (a · p)))
    ≡⟨ cong₂ (λ u v → u + (- v)) (†-· p a) (†-· a p) ⟩
      ((† a) · († p)) + (- ((† p) · († a)))
    ≡⟨ cong₂ (λ u v → (u · († p)) + (- ((† p) · v))) ha ha ⟩
      (a · († p)) + (- ((† p) · a))
    ≡⟨ cong₂ (λ u v → (a · u) + (- (v · a))) hp hp ⟩
      (a · p) + (- (p · a))
    ≡⟨ cong (_+ (- (p · a))) (sym (-Idempotent (a · p))) ⟩
      (- (- (a · p))) + (- (p · a))
    ≡⟨ +Comm (- (- (a · p))) (- (p · a)) ⟩
      (- (p · a)) + (- (- (a · p)))
    ≡⟨ -Dist (p · a) (- (a · p)) ⟩
      - ((p · a) + (- (a · p))) ∎

  ----------------------------------------------------------------------
  -- ३ · AND THE COMPANION: with `a` skew, the ANTIcommutator is
  --     SKEW-adjoint.  So in the skew case the commutator is the only
  --     one of the two brackets that pairs really.
  --
  --       †(p·a + a·p) = (†a)(†p) + (†p)(†a)
  --                    = (-a)p + p(-a)
  --                    = -(a·p) - (p·a)
  --                    = -(p·a + a·p) .
  ----------------------------------------------------------------------

  anti-skew-skew :
      (p a : A) → († p ≡ p) → († a ≡ - a)
    → † (anti p a) ≡ - (anti p a)
  anti-skew-skew p a hp ha =
      † ((p · a) + (a · p))
    ≡⟨ †-+ (p · a) (a · p) ⟩
      († (p · a)) + († (a · p))
    ≡⟨ cong₂ _+_ (†-· p a) (†-· a p) ⟩
      ((† a) · († p)) + ((† p) · († a))
    ≡⟨ cong₂ (λ u v → (u · († p)) + ((† p) · v)) ha ha ⟩
      ((- a) · († p)) + ((† p) · (- a))
    ≡⟨ cong₂ (λ u v → ((- a) · u) + (v · (- a))) hp hp ⟩
      ((- a) · p) + (p · (- a))
    ≡⟨ cong₂ _+_ (-DistL· a p) (-DistR· p a) ⟩
      (- (a · p)) + (- (p · a))
    ≡⟨ +Comm (- (a · p)) (- (p · a)) ⟩
      (- (p · a)) + (- (a · p))
    ≡⟨ -Dist (p · a) (a · p) ⟩
      - ((p · a) + (a · p)) ∎
