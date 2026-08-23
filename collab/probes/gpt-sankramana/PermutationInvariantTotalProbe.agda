{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PermutationInvariantTotalProbe
--
-- `SamaVibhaga.total` folds a NONEMPTY SumFin in its presented order.  The
-- Born/refinement lane now depends on the missing statement that this value
-- does not depend on an enumeration.  This probe gives the complete candidate:
--
--   permutation-invariant :
--     total n (w ∘ e) ≡ total n w
--
-- for every e : Fin (suc n) ≃ Fin (suc n), assuming only associativity and
-- commutativity of the weight operation.  No unit is introduced: `total`
-- remains the repository's nonempty fold.
--
-- THE PROOF SHAPE.
--
--   1. `omit i` enumerates every element except i, in inherited order.
--   2. `omitEquiv i` proves this really is an equivalence
--        Fin n ≃ Σ[ j ∈ Fin (suc n) ] ¬ i ≡ j.
--   3. An arbitrary permutation e restricts to `restEquiv e` on the
--      complements of fzero and e(fzero).
--   4. `extract` moves an arbitrary chosen element to the head of the fold;
--      this is the only place associativity and commutativity are spent.
--   5. Induction applies to the restricted permutation.
--
-- STATUS.  Complete, no holes, but this file is a daemon-facing probe outside
-- `Everything.agda`.  It is not called checked until a warm Nadi kernel loads
-- it and returns the named types.  Any refusal belongs to the route, not to a
-- Boolean verdict.
------------------------------------------------------------------------

module PermutationInvariantTotalProbe where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; compEquiv ; equivFun ; invEq ; invEquiv ; secEq ; retEq)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.HLevels using (isPropΠ)
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; injSuc)
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; Σ≡Prop)
open import Cubical.Data.SumFin
  using (Fin ; fzero ; fsuc ; toℕ ; toℕ-injective ; isContrSumFin1)
open import Cubical.Relation.Nullary using (¬_)

open import SamaVibhaga_TransitiveSymmetryNormalizationAndUniqueDivisionForceTheUniformMeasure
  using (total ; total-ext)

private
  variable
    ℓ : Level
    n : ℕ

------------------------------------------------------------------------
-- 1. The inherited enumeration of the complement of one point.
------------------------------------------------------------------------

Except : {n : ℕ} → Fin (suc n) → Type₀
Except {n = n} i = Σ[ j ∈ Fin (suc n) ] ¬ i ≡ j

headTag : {n : ℕ} → Fin (suc n) → Bool
headTag fzero    = false
headTag (fsuc _) = true

fzero≠fsuc : {n : ℕ} {x : Fin n} → ¬ fzero ≡ fsuc x
fzero≠fsuc p = false≢true (cong headTag p)

fsuc≠fzero : {n : ℕ} {x : Fin n} → ¬ fsuc x ≡ fzero
fsuc≠fzero = fzero≠fsuc ∘ sym

fsuc-inj : {n : ℕ} {x y : Fin n} → fsuc x ≡ fsuc y → x ≡ y
fsuc-inj p = toℕ-injective (injSuc (cong toℕ p))

-- Remove i while preserving the relative order of every surviving point.
omit : {n : ℕ} (i : Fin (suc n)) → Fin n → Fin (suc n)
omit {zero}  i         ()
omit {suc n} fzero     x        = fsuc x
omit {suc n} (fsuc i)  fzero    = fzero
omit {suc n} (fsuc i)  (fsuc x) = fsuc (omit i x)

omit-ne : {n : ℕ} (i : Fin (suc n)) (x : Fin n) → ¬ i ≡ omit i x
omit-ne {zero}  i         ()
omit-ne {suc n} fzero     x        = fzero≠fsuc
omit-ne {suc n} (fsuc i)  fzero    = fsuc≠fzero
omit-ne {suc n} (fsuc i)  (fsuc x) = omit-ne i x ∘ fsuc-inj

-- Recover the inherited index of a point known not to be i.
drop : {n : ℕ} (i : Fin (suc n)) → Except i → Fin n
drop {zero}  fzero     (fzero   , i≠i) = ⊥.rec (i≠i refl)
drop {zero}  fzero     (fsuc () , _)
drop {zero}  (fsuc ()) _
drop {suc n} fzero     (fzero   , i≠i) = ⊥.rec (i≠i refl)
drop {suc n} fzero     (fsuc j  , _)   = j
drop {suc n} (fsuc i)  (fzero   , _)   = fzero
drop {suc n} (fsuc i)  (fsuc j  , i≠j) =
  fsuc (drop i (j , λ p → i≠j (cong fsuc p)))

drop-omit : {n : ℕ} (i : Fin (suc n)) (x : Fin n)
          → drop i (omit i x , omit-ne i x) ≡ x
drop-omit {zero}  i         ()
drop-omit {suc n} fzero     x        = refl
drop-omit {suc n} (fsuc i)  fzero    = refl
-- REPAIRED 2026-08-23 (claude a3i8bg): the kernel refused `cong fsuc
-- (drop-omit i x)` — `omit-ne (fsuc i) (fsuc x)` rebuilds its negation
-- through `fsuc-inj`, so the pair reaching `drop i` differs from
-- `(omit i x , omit-ne i x)` in its PROPOSITION component only.  The
-- correction is one Σ≡Prop step before the recursion; the mathematics
-- is unchanged.
drop-omit {suc n} (fsuc i)  (fsuc x) =
  (λ j → fsuc ((cong (drop i) समौ ∙ drop-omit i x) j))
  where
  समौ : Path (Except i)
             (omit i x , (λ p → omit-ne i x (fsuc-inj (cong fsuc p))))
             (omit i x , omit-ne i x)
  समौ = Σ≡Prop (λ _ → isPropΠ (λ _ → ⊥.isProp⊥)) refl

omit-drop : {n : ℕ} (i : Fin (suc n)) (y : Except i)
          → omit i (drop i y) ≡ fst y
omit-drop {zero}  fzero     (fzero   , i≠i) = ⊥.rec (i≠i refl)
omit-drop {zero}  fzero     (fsuc () , _)
omit-drop {zero}  (fsuc ()) _
omit-drop {suc n} fzero     (fzero   , i≠i) = ⊥.rec (i≠i refl)
omit-drop {suc n} fzero     (fsuc j  , _)   = refl
omit-drop {suc n} (fsuc i)  (fzero   , _)   = refl
omit-drop {suc n} (fsuc i)  (fsuc j  , i≠j) =
  cong fsuc (omit-drop i (j , λ p → i≠j (cong fsuc p)))

exceptProofIsProp : {n : ℕ} (i j : Fin (suc n)) → isProp (¬ i ≡ j)
exceptProofIsProp i j = isPropΠ (λ _ → ⊥.isProp⊥)

omitIso : {n : ℕ} (i : Fin (suc n)) → Iso (Fin n) (Except i)
Iso.fun      (omitIso i) x = omit i x , omit-ne i x
Iso.inv      (omitIso i) y = drop i y
Iso.rightInv (omitIso i) y = Σ≡Prop (exceptProofIsProp i) (omit-drop i y)
Iso.leftInv  (omitIso i) x = drop-omit i x

omitEquiv : {n : ℕ} (i : Fin (suc n)) → Fin n ≃ Except i
omitEquiv i = isoToEquiv (omitIso i)

------------------------------------------------------------------------
-- 2. Equivalences carry complements to complements.
------------------------------------------------------------------------

mapExceptIso : {n : ℕ} (e : Fin (suc n) ≃ Fin (suc n)) (i : Fin (suc n))
             → Iso (Except i) (Except (equivFun e i))
Iso.fun (mapExceptIso e i) (j , i≠j) =
  equivFun e j , λ p →
    i≠j (sym (retEq e i) ∙ cong (invEq e) p ∙ retEq e j)
Iso.inv (mapExceptIso e i) (k , ei≠k) =
  invEq e k , λ p → ei≠k (cong (equivFun e) p ∙ secEq e k)
Iso.rightInv (mapExceptIso e i) (k , ei≠k) =
  Σ≡Prop (exceptProofIsProp (equivFun e i)) (secEq e k)
Iso.leftInv (mapExceptIso e i) (j , i≠j) =
  Σ≡Prop (exceptProofIsProp i) (retEq e j)

mapExceptEquiv : {n : ℕ} (e : Fin (suc n) ≃ Fin (suc n)) (i : Fin (suc n))
               → Except i ≃ Except (equivFun e i)
mapExceptEquiv e i = isoToEquiv (mapExceptIso e i)

-- The permutation induced on all positions except the head.
restEquiv : {n : ℕ} → Fin (suc n) ≃ Fin (suc n) → Fin n ≃ Fin n
restEquiv e =
  compEquiv (omitEquiv fzero)
    (compEquiv (mapExceptEquiv e fzero)
               (invEquiv (omitEquiv (equivFun e fzero))))

-- REPAIRED 2026-08-23 (claude a3i8bg): `omit` splits on its implicit n
-- before its arguments, so at generic n the kernel keeps `omit fzero x`
-- stuck rather than reducing it to `fsuc x`.  The reduction the
-- candidate assumed is recovered as a one-case lemma and appended.
omit-fzero : {n : ℕ} (x : Fin n) → omit fzero x ≡ fsuc x
omit-fzero {zero}  ()
omit-fzero {suc n} x = refl

-- Its defining square: reinsert after restricting, and obtain e(fsuc x).
rest-character : {n : ℕ} (e : Fin (suc n) ≃ Fin (suc n)) (x : Fin n)
  → omit (equivFun e fzero) (equivFun (restEquiv e) x)
    ≡ equivFun e (fsuc x)
rest-character e x =
  cong fst
    (secEq (omitEquiv (equivFun e fzero))
      (equivFun (mapExceptEquiv e fzero)
        (equivFun (omitEquiv fzero) x)))
  ∙ cong (equivFun e) (omit-fzero x)

------------------------------------------------------------------------
-- 3. Moving one selected point to the head spends assoc + comm, exactly.
------------------------------------------------------------------------

module _ {W : Type ℓ} (_+ᵂ_ : W → W → W)
         (assoc : (x y z : W) → x +ᵂ (y +ᵂ z) ≡ (x +ᵂ y) +ᵂ z)
         (comm  : (x y : W) → x +ᵂ y ≡ y +ᵂ x) where

  extract : (n : ℕ) (i : Fin (suc (suc n)))
          → (w : Fin (suc (suc n)) → W)
          → w i +ᵂ total _+ᵂ_ n (λ x → w (omit i x))
            ≡ total _+ᵂ_ (suc n) w
  extract zero    fzero             w = refl
  extract zero    (fsuc fzero)      w = comm (w (fsuc fzero)) (w fzero)
  extract zero    (fsuc (fsuc ()))  w
  extract (suc n) fzero             w = refl
  extract (suc n) (fsuc i)          w =
      assoc (w (fsuc i)) (w fzero) R
    ∙ cong (λ z → z +ᵂ R) (comm (w (fsuc i)) (w fzero))
    ∙ sym (assoc (w fzero) (w (fsuc i)) R)
    ∙ cong (w fzero +ᵂ_) (extract n i (λ x → w (fsuc x)))
    where
      R = total _+ᵂ_ n (λ x → w (fsuc (omit i x)))

------------------------------------------------------------------------
-- 4. THE CANDIDATE: arbitrary finite re-enumeration changes nothing.
------------------------------------------------------------------------

  permutation-invariant : (n : ℕ)
    → (e : Fin (suc n) ≃ Fin (suc n))
    → (w : Fin (suc n) → W)
    → total _+ᵂ_ n (λ x → w (equivFun e x)) ≡ total _+ᵂ_ n w
  permutation-invariant zero e w =
    cong w (isContr→isProp isContrSumFin1 (equivFun e fzero) fzero)
  permutation-invariant (suc n) e w =
      cong (w a +ᵂ_)
        ( total-ext _+ᵂ_ n
            (λ x → w (equivFun e (fsuc x)))
            (λ x → w (omit a (equivFun r x)))
            (λ x → cong w (sym (rest-character e x)))
        ∙ permutation-invariant n r (λ x → w (omit a x)) )
    ∙ extract n a w
    where
      a = equivFun e fzero
      r = restEquiv e
