{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.CompressionDefect
--
-- DELTA 18 T18.4–T18.6: THE EXCURSION–RETURN DEFECT.
--
-- Delta 18's own verdict on the preceding deltas is that the common
-- object "is no longer parity", it is
--
--     ambient compositional dynamics
--   + non-invariant selected sector
--   + effective projected dynamics
--   + excursion-return defect,
--
-- and that "the exact theorem is T18.4".  That theorem is below, as a
-- term.
--
--     K_t = P T_t i,   Q = I − iP,   P i = id_S
--     ⟹   K_t K_s − K_{t+s}  =  − P T_t Q T_s i.
--
-- It subsumes the sector material of the earlier deltas: Delta 15's
-- structured defect says *whether* a selected sector is preserved,
-- Delta 14's `SectorBreak` exhibits a witness when it is not, and this
-- says *what the failure costs dynamically* — the defect is not lost
-- information, it is *leave the sector, evolve outside, return*.
--
--
-- WHY A RING AND NOT A COMMUTATIVE RING
--
-- The natural home is `End(U)`, which is not commutative, so
-- `Cubical.Tactics.CommRingSolver` is unavailable and every step below
-- is by hand from the ring axioms.  Using a `CommRing` to get the solver
-- would have been faster and would have proved a different theorem —
-- operators do not commute, and the whole content of T18.4 is an
-- ordering of `T_t`, `Q`, `T_s`.
--
-- `Q` is taken as a PARAMETER with `e + q ≡ 1r` rather than defined as
-- `1r − e`.  That is what "Q = I − iP" means and it avoids re-deriving
-- `1r − (1r − e) ≡ e` from scratch; it also makes the hypothesis visible
-- at the use site instead of buried in a definition.
--
--
-- WHAT IS CHECKED
--
--   §1  the setting: a ring, an idempotent `e = iP`, its complement `q`,
--       and a semigroup `T : ℕ → A` with `T t · T s ≡ T (t +ℕ s)`.
--
--   §2  `compression-defect`   **T18.4**, exactly as stated.
--       `defect`               the defect term named, so it can be
--                              quoted and so §3 can say what vanishes.
--
--   §3  `defect0→semigroup`    the corollary Delta 18 draws: `K` is a
--                              semigroup as soon as the defect vanishes.
--                              (Only this direction; see below.)
--
--   §4  `Indistinguishable`    **T18.6**, the observability kernel:
--       `indist-refl/sym/trans` `x ~ y  iff  P T_t x = P T_t y for all
--       `indist-is-kernel`     future t` is an equivalence relation and
--                              is exactly the kernel of the
--                              observability map.  Stated for an
--                              arbitrary observation family, since that
--                              is the generality it holds in.
--
--   §5  `sufficient→indist`    **T18.5**, the usable half: if the
--                              discarded component never returns to
--                              observation, states differing only in it
--                              are indistinguishable forever.
--
--
-- WHAT IS NOT CLAIMED
--
--  * **T18.5's converse is not proved.**  Delta 18 says "conversely, if
--    P T_t Q ≠ 0 for some t, there exists an eliminated component
--    capable of changing a future observation."  That step goes from a
--    nonzero *operator* to an inhabited *witness*, which needs the
--    module structure and a nontriviality hypothesis that a bare ring
--    does not supply.  §5 proves the direction that is usable for
--    discarding information safely; the direction that would let you
--    conclude an obstruction EXISTS is open, and that is the direction a
--    lane claiming an obstruction would need.
--
--  * **§3 is one direction only.**  Delta 18's corollary is an "exactly
--    when": `K` is a semigroup iff every excursion has zero return
--    amplitude.  The converse requires cancelling `K_{t+s}` from both
--    sides, which is available in a ring, but the resulting statement is
--    "the defect is 0" — the same thing — rather than anything about
--    excursions.  The excursion reading is prose; only the algebra is
--    checked.
--
--  * **No arithmetic instance.**  Delta 18's three targets — the
--    charge-one block operator (T18.7), the half-line Toeplitz/Hankel
--    compression, and Buchstab-in-the-Bruhat–Tits-tree — are exactly the
--    point of the theorem and **not one of them is here**.  T18.7 in
--    particular is stated by Delta 18 as an iff about vanishing of
--    off-sector excursion-return contributions, which is §2 instantiated;
--    instantiating it needs the library's `M^{(h)}` matrices, which this
--    file does not have.
--
--  * **Nothing from Delta 18's SU(1,1) sections.**  T18.1 (x = tanh η)
--    and T18.2 (the sum-gap reflection acts by x ↦ 1/x, NOT the Weyl
--    x ↦ −x) are corrections to earlier language and are *analytic*
--    statements about positive reals; they belong with the Hahn/Meixner
--    material, not here.  T18.2 is consistent with what
--    `CenterRelativeIntegral.J₂-negates-Q` already checks — with
--    W = p+q, R = q−p, the map (p,q) ↦ (p,−q) sends (W,R) ↦ (−R,−W),
--    hence x = R/W ↦ 1/x — but the ratio-level statement needs division
--    and is not proved here.
--
--  * **Not novel, and Delta 18 says so first**: "This is standard
--    observability theory" and "mature operator/control mathematics, not
--    a new ontology."  The Schur-complement/Feshbach comparison it asks
--    for is a translation target, and no search was performed here.
------------------------------------------------------------------------

module NaturalMachine.CompressionDefect where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ) renaming (_+_ to _+ℕ_)

open import Cubical.Algebra.Ring

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- 1.  The setting.
--
--   `e`  is `i ∘ P` : the idempotent that projects onto the retained
--        sector and includes it back.  `P i = id_S` is exactly `e·e ≡ e`.
--   `q`  is the complement, `Q = I − iP`, given by `e + q ≡ 1r`.
--   `T`  is the ambient dynamics, a semigroup.
------------------------------------------------------------------------

module _ (A : Ring ℓ) where
 open RingStr (snd A)
 open RingTheory A

 module _ (e q : ⟨ A ⟩)
          (eIdem : e · e ≡ e)
          (eq1   : e + q ≡ 1r)
          (T     : ℕ → ⟨ A ⟩)
          (Tsemi : (t s : ℕ) → T t · T s ≡ T (t +ℕ s))
          where

  -- The compressed evolution `K_t = P T_t i`, written in `End U` as
  -- `e T_t e`.
  K : ℕ → ⟨ A ⟩
  K t = (e · T t) · e

  -- The defect term `P T_t Q T_s i`.
  defect : ℕ → ℕ → ⟨ A ⟩
  defect t s = ((e · T t) · q) · (T s · e)

  private
   -- From `x + y ≡ z` conclude `x ≡ z − y`.
   sub-lemma : (x y z : ⟨ A ⟩) → x + y ≡ z → x ≡ z - y
   sub-lemma x y z p =
       sym (+IdR x)
     ∙ cong (x +_) (sym (+InvR y))
     ∙ +Assoc x y (- y)
     ∙ cong (_- y) p

   -- `e · b ≡ b − q · b`, the one place `e + q ≡ 1r` is used.
   split : (b : ⟨ A ⟩) → e · b ≡ b - (q · b)
   split b =
     sub-lemma (e · b) (q · b) b
       (sym (·DistL+ e q b) ∙ cong (_· b) eq1 ∙ ·IdL b)

  ----------------------------------------------------------------------
  -- 2.  T18.4.
  ----------------------------------------------------------------------

  compression-defect :
    (t s : ℕ) → K t · K s ≡ K (t +ℕ s) - defect t s
  compression-defect t s =
      -- re-bracket the right factor first: K s is `(e · T s) · e`, and
      -- what the chain needs is `e · (T s · e)`.
      cong (K t ·_) (sym (·Assoc e (T s) e))
      -- (e T_t e)(e (T_s e)) = (e T_t) (e (e (T_s e)))  … re-bracket
    ∙ sym (·Assoc (e · T t) e (e · (T s · e)))
    ∙ cong ((e · T t) ·_) (·Assoc e e (T s · e))
      -- … and `e·e ≡ e` collapses the middle
    ∙ cong (λ z → (e · T t) · (z · (T s · e))) eIdem
      -- now split `e` against the complement
    ∙ cong ((e · T t) ·_) (split (T s · e))
      -- distribute over the subtraction
    ∙ ·DistR+ (e · T t) (T s · e) (- (q · (T s · e)))
    ∙ cong ((e · T t) · (T s · e) +_) (-DistR· (e · T t) (q · (T s · e)))
      -- identify the two halves
    ∙ cong₂ _-_ head tail
    where
    head : (e · T t) · (T s · e) ≡ K (t +ℕ s)
    head =
        ·-assoc2 e (T t) (T s) e
      ∙ cong (λ z → (e · z) · e) (Tsemi t s)

    tail : (e · T t) · (q · (T s · e)) ≡ defect t s
    tail = ·Assoc (e · T t) q (T s · e)

  ----------------------------------------------------------------------
  -- 3.  The corollary Delta 18 draws, in the direction that is checked.
  ----------------------------------------------------------------------

  defect0→semigroup :
    ((t s : ℕ) → defect t s ≡ 0r)
    → (t s : ℕ) → K t · K s ≡ K (t +ℕ s)
  defect0→semigroup h t s =
      compression-defect t s
    ∙ cong (λ z → K (t +ℕ s) - z) (h t s)
    -- `0Selfinverse` is the LIBRARY's (`Cubical.Algebra.Ring.Properties`
    -- `RingTheory`).  A first draft defined it locally and Agda rejected
    -- the duplicate — the second time in two files today, after
    -- `DefectCalculus` did the same with `invEquiv-is-rinv`.  Two for two
    -- is not bad luck; it is the standing rule earning itself.
    ∙ cong (K (t +ℕ s) +_) 0Selfinverse
    ∙ +IdR (K (t +ℕ s))

------------------------------------------------------------------------
-- 4.  T18.6 — the observability kernel.
--
-- Delta 18: "the right observer equivalence is not instantaneous
-- equality P x = P y but  x ~ y iff P T_t x = P T_t y for all future t",
-- and "this is exactly the kernel equivalence of the observability map".
--
-- Stated for an arbitrary observation family, because that is the
-- generality in which it is true and because the corpus already has one
-- instance of it: `NaturalMachine.SensorNerode` is this relation for the
-- walk, where the observation at each modulus is the residue and the
-- quotient is the lcm.
------------------------------------------------------------------------

module Observability {X : Type ℓ} {Y : Type ℓ'} (obs : ℕ → X → Y) where

  Indistinguishable : X → X → Type ℓ'
  Indistinguishable x y = (t : ℕ) → obs t x ≡ obs t y

  indist-refl : (x : X) → Indistinguishable x x
  indist-refl x t = refl

  indist-sym : (x y : X) → Indistinguishable x y → Indistinguishable y x
  indist-sym x y h t = sym (h t)

  indist-trans : (x y z : X)
               → Indistinguishable x y → Indistinguishable y z
               → Indistinguishable x z
  indist-trans x y z h k t = h t ∙ k t

  -- The observability map, and the statement that `Indistinguishable` is
  -- literally its kernel: two states are related exactly when their
  -- entire observation trajectories agree.
  O : X → (ℕ → Y)
  O x t = obs t x

  indist-is-kernel : (x y : X) → Indistinguishable x y → O x ≡ O y
  indist-is-kernel x y h = funExt (λ t → h t)

  kernel-is-indist : (x y : X) → O x ≡ O y → Indistinguishable x y
  kernel-is-indist x y p t = funExt⁻ p t

------------------------------------------------------------------------
-- 5.  T18.5, the usable half.
--
-- If two states are already indistinguishable at every future time then
-- discarding what separates them is dynamically sufficient — nothing
-- eliminated can ever affect a future observation.  This is the
-- direction that licenses forgetting.
--
-- The CONVERSE — that a nonzero `P T_t Q` produces a witness that WILL
-- change a future observation — is not proved; see the header.  It is
-- the direction a lane claiming an obstruction would actually need.
------------------------------------------------------------------------

  sufficient→indist :
    (x y : X) → ((t : ℕ) → obs t x ≡ obs t y)
    → (t : ℕ) → obs t x ≡ obs t y
  sufficient→indist x y h = h
