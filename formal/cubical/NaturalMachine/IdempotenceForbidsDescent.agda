{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.IdempotenceForbidsDescent
--
-- Why the walk's capacity is e^ψ(k) and could never have been anything
-- else.  Two lines of monoid theory, and they close a question this
-- corpus has been treating as a tuning problem.
--
-- ────────────────────────────────────────────────────────────────────
-- THE OBSERVATION
--
-- The cakravāla (Jayadeva ~950, Bhāskara II 1150) does not merely
-- compose.  Each cycle composes the current triple with a trivial one by
-- bhāvanā and then **divides by k** — the descent that keeps the numbers
-- bounded and is the entire reason the cyclic method terminates in a
-- handful of steps where brute search does not terminate at all.
--
-- The walk composes too: its step joins the current state with a new
-- prime power, which under `SumProductTorus.val` is pointwise max on
-- derivations.  But the walk never divides.  Its state is monotone in
-- the divisor lattice from the first step to the last.
--
-- That has been described here as a feature of this particular machine.
-- It is not.  It is forced, and the proof is `idem-invertible-is-unit`:
--
--     in any monoid, an IDEMPOTENT element with an inverse is the unit.
--
--         x = x·e = x·(x·y) = (x·x)·y = x·y = e.
--
-- A join is idempotent at every element.  So in a join monoid **every**
-- invertible element is the unit.  Stated exactly, and this is the whole
-- claim: **no step of a join law can be undone by another step of that
-- law**, at any state, ever.  Not "the walk lacks a descent step" — the
-- walk cannot have one built from its own state law, and by `Apavada` a
-- rule that agrees with it everywhere is a reformulation that changes
-- only price.  Getting descent means changing the law.
--
-- ────────────────────────────────────────────────────────────────────
-- THE CONTRAST, IN THE SAME BREATH
--
-- `PythagoreanTransition` gives the other kind of state law: bhāvanā at
-- D = −1, which is a group on the norm-one part.  Over ℤ the element
-- i = (0,1) is invertible and is NOT the unit — checked by `refl` below
-- — so that monoid is not idempotent, and a composition step CAN be
-- undone by another composition step (with the conjugate: antara-bhāvanā).
--
-- So the two machines differ by exactly one algebraic property, and it
-- is the property that decides whether state can ever come back down:
--
--     join monoid   idempotent  ⇒ only the unit inverts ⇒ irreversible
--     bhāvanā       i ≠ one      ⇒ non-unit inverses     ⇒ reversible
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS DOES AND DOES NOT SETTLE.
--
-- It settles that the walk’s irreversibility is structural, not a missing
-- optimisation, and that no reformulation of the walk in its own chart
-- (`Apavada`: agreement, hence only price changes) can fix it.  Fixing it
-- requires a different state law, not a better rule.
--
-- It does NOT give the growth rate.  cap(k) = e^ψ(k) is proved elsewhere
-- in this lane; nothing here bears on ψ, and irreversibility alone does
-- not imply any particular rate.  Nor is the cakravāla’s descent shown to
-- BE this inversion: the cyclic method divides by k, which is inversion in
-- the scaling action (`Bhavana.normScale`), a different structure from the
-- one inverted here.  That the two are the same move is a conjecture this
-- module does not prove.  What is proved is the reversibility dichotomy.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.IdempotenceForbidsDescent where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Sigma
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Int.Properties using (injPos)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.SumProductTorus
  using (Exp ; zeroE ; _⊔_ ; _⊔ℕ_ ; val ; primes4)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- 1.  The theorem, over any monoid.  Unbundled on purpose: the two
--     instances below live in different libraries and neither is
--     packaged as a `Monoid` in this lane.
------------------------------------------------------------------------

module Mon {M : Type ℓ} (_⋆_ : M → M → M) (e : M)
           (idr    : (x : M) → x ⋆ e ≡ x)
           (assoc  : (x y z : M) → (x ⋆ y) ⋆ z ≡ x ⋆ (y ⋆ z))
           where

  Invertible : M → Type ℓ
  Invertible x = Σ[ y ∈ M ] (x ⋆ y ≡ e)

  Idempotent : M → Type ℓ
  Idempotent x = x ⋆ x ≡ x

  -- x = x·e = x·(x·y) = (x·x)·y = x·y = e
  idem-invertible-is-unit :
    (x : M) → Idempotent x → Invertible x → x ≡ e
  idem-invertible-is-unit x idem (y , inv) =
      sym (idr x)
    ∙ cong (x ⋆_) (sym inv)
    ∙ sym (assoc x x y)
    ∙ cong (_⋆ y) idem
    ∙ inv

  -- contrapositive, which is the form the machines are read in:
  -- a non-unit that inverts witnesses that the law is not a join.
  invertible-non-unit-breaks-idempotence :
    (x : M) → Invertible x → ¬ (x ≡ e) → ¬ (Idempotent x)
  invertible-non-unit-breaks-idempotence x invx x≢e idem =
    x≢e (idem-invertible-is-unit x idem invx)

------------------------------------------------------------------------
-- 2.  The walk's state law is a join, so every element is idempotent
------------------------------------------------------------------------

⊔ℕ-idem : (x : ℕ) → x ⊔ℕ x ≡ x
⊔ℕ-idem zero    = refl
⊔ℕ-idem (suc x) = cong suc (⊔ℕ-idem x)

⊔ℕ-idr : (x : ℕ) → x ⊔ℕ 0 ≡ x
⊔ℕ-idr zero    = refl
⊔ℕ-idr (suc x) = refl

⊔ℕ-assoc : (x y z : ℕ) → (x ⊔ℕ y) ⊔ℕ z ≡ x ⊔ℕ (y ⊔ℕ z)
⊔ℕ-assoc zero    y       z       = refl
⊔ℕ-assoc (suc x) zero    z       = refl
⊔ℕ-assoc (suc x) (suc y) zero    = refl
⊔ℕ-assoc (suc x) (suc y) (suc z) = cong suc (⊔ℕ-assoc x y z)

⊔-idem : (bs : List ℕ) (u : Exp bs) → (u ⊔ u) ≡ u
⊔-idem []       _        = refl
⊔-idem (b ∷ bs) (x , xs) i = ⊔ℕ-idem x i , ⊔-idem bs xs i

⊔-idr : (bs : List ℕ) (u : Exp bs) → (u ⊔ zeroE bs) ≡ u
⊔-idr []       _        = refl
⊔-idr (b ∷ bs) (x , xs) i = ⊔ℕ-idr x i , ⊔-idr bs xs i

⊔-assoc : (bs : List ℕ) (u v w : Exp bs) → ((u ⊔ v) ⊔ w) ≡ (u ⊔ (v ⊔ w))
⊔-assoc []       _ _ _ = refl
⊔-assoc (b ∷ bs) (x , xs) (y , ys) (z , zs) i =
  ⊔ℕ-assoc x y z i , ⊔-assoc bs xs ys zs i

module WalkStates (bs : List ℕ) =
  Mon {M = Exp bs} _⊔_ (zeroE bs) (⊔-idr bs) (⊔-assoc bs)

-- THE WALK IS IRREVERSIBLE.  Every state is idempotent, so the only state
-- with an inverse is the trivial one — the derivation of 1.  The only
-- state a step of the walk’s own law can return to is capacity 1.
walk-only-unit-inverts :
  (bs : List ℕ) (u : Exp bs) → WalkStates.Invertible bs u → u ≡ zeroE bs
walk-only-unit-inverts bs u inv =
  WalkStates.idem-invertible-is-unit bs u (⊔-idem bs u) inv

-- named in the multiplicative chart, that trivial state is the number 1:
-- the walk can undo itself only all the way back to the empty state.
walk-return-target-is-one : val primes4 (zeroE primes4) ≡ 1
walk-return-target-is-one = refl

------------------------------------------------------------------------
-- 3.  Bhāvanā is not a join: i = (0,1) inverts and is not the unit
------------------------------------------------------------------------

open import NaturalMachine.PythagoreanTransition using (module Circle)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)

open Circle ℤCommRing using (Pair ; _⊗_ ; conj ; one ; N)

i : Pair
i = pos 0 , pos 1

i-norm-one : N i ≡ pos 1
i-norm-one = refl

i-inverts : i ⊗ conj i ≡ one
i-inverts = refl

i-is-not-one : ¬ (i ≡ one)
i-is-not-one p = znots (injPos (cong snd (sym p)))

module Rot = Mon {M = Pair} _⊗_ one
                 (Circle.⊗-idʳ ℤCommRing) (Circle.⊗-assoc ℤCommRing)

-- so this monoid is NOT idempotent, and a step in it can be undone by
-- another step of the same law — provably unlike the walk’s.
bhavana-is-not-a-join : ¬ (Rot.Idempotent i)
bhavana-is-not-a-join =
  Rot.invertible-non-unit-breaks-idempotence i (conj i , i-inverts) i-is-not-one

------------------------------------------------------------------------
-- 4.  The sentence this module exists to make exact.
--
-- The walk’s state never comes back down because its law is a join,
-- joins are idempotent, and idempotence forbids every inverse but the
-- trivial one.  No rule change touches this: by `Apavada`, a rule that
-- agrees with the walk everywhere is a REFORMULATION and changes only
-- price.  Reversibility requires changing the state law, and the oldest
-- state law in this repository that has it is Brahmagupta’s.
------------------------------------------------------------------------
