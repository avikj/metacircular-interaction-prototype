{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WindowShiftResidual — on a finite window, net displacement descends and
-- the boundary interaction history does not; for a fixed word the
-- residual lives only within one shift of the edges.
--
-- WHAT THIS IS.  On the whole line the shifts form a group: U₋ₐUₐ = UₐU₋ₐ
-- = id.  On a window [0, t) they are truncated, and the two words
-- "shift right then left" and "shift left then right" have the same net
-- displacement, zero, but act differently: one keeps what did not fall
-- off the right edge, the other what did not fall off the left edge.
--
--   §1  the closed forms:  (S⃰ S f)(x) = f x if x + a < t, else 0;
--                          (S S⃰ f)(x) = f x if a ≤ x < t, else 0.
--   §2  INTERIOR AGREEMENT: for a ≤ x and x + a < t the two agree.  The
--       residual is supported in [0, a) ∪ [t − a, t): for a fixed word it
--       retreats to the edges as the window grows.
--   §3  THE DESCENT OBSTRUCTION: the reading "net displacement" identifies
--       the two words (both 0) while the operator reading separates them
--       at x = 0 on the delta function, for any 1 ≤ a with a < t — so the
--       window action does not factor through displacement
--       (DescentObstructionUnified.factorObstruction).
--
-- READING.  The finite prime-translation operator of the compact-window
-- Weil formula introduces shifts a = log n up to the window size, so fresh
-- words always live at boundary scale; this is the exact-layer reason
-- bulk convergence of finite operators is not spectral convergence.
-- That reading is not proved here; §§1–3 are.
--
-- SYĀT — THE CLAIM, EXACTLY.  Functions ℕ → ℤ read on a window, two
-- truncated shifts, pointwise identities by case analysis on ℕ's order.
------------------------------------------------------------------------

module WindowShiftResidual_NetDisplacementDescendsAndTheBoundaryInteractionHistoryDoesNotAndForAFixedWordItRetreatsToTheEdges where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _∸_ ; snotz)
open import Cubical.Data.Nat.Order
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import DescentObstructionUnified using (FactorsThrough ; factorObstruction)

Signal : Type
Signal = ℕ → ℤ

-- decide x < n
lt? : (x n : ℕ) → Dec (x < n)
lt? x n = <Dec x n

-- right shift by a on the window (what falls off the left edge is lost;
-- the window's right edge is enforced by the reader below)
S : ℕ → Signal → Signal
S a f x with lt? x a
... | yes _ = pos 0
... | no  _ = f (x ∸ a)

-- left shift by a within a window of size t
S⃰ : ℕ → ℕ → Signal → Signal
S⃰ t a f x with lt? (x + a) t
... | yes _ = f (x + a)
... | no  _ = pos 0

-- the window reader: zero outside [0, t)
win : ℕ → Signal → Signal
win t f x with lt? x t
... | yes _ = f x
... | no  _ = pos 0

------------------------------------------------------------------------
-- §1  Closed forms.
------------------------------------------------------------------------

private
  ¬x+a<a : (x a : ℕ) → ¬ (x + a < a)
  ¬x+a<a x a h = ¬m<m (≤<-trans (≤SumRight {n = a} {k = x}) h)

  x+a∸a : (x a : ℕ) → (x + a) ∸ a ≡ x
  x+a∸a x a = +∸ x a
    where
    open import Cubical.Data.Nat.Properties using (+∸)

  x∸a+a : (x a : ℕ) → ¬ (x < a) → (x ∸ a) + a ≡ x
  x∸a+a x a h = ≤-∸-+-cancel (≮→≥ h)
    where
    ≮→≥ : ¬ (x < a) → a ≤ x
    ≮→≥ nh with x ≟ a
    ... | lt l = Empty.rec (nh l)
    ... | eq e = subst (a ≤_) (sym e) ≤-refl
    ... | gt g = <-weaken g

-- S⃰ S f (x) = f x when x + a < t, else 0
S⃰S : (t a : ℕ) (f : Signal) (x : ℕ)
    → S⃰ t a (S a f) x ≡ (win t (λ y → f (y ∸ a)) (x + a))
S⃰S t a f x with lt? (x + a) t
... | no _ = refl
... | yes _ with lt? (x + a) a
...   | yes h = Empty.rec (¬x+a<a x a h)
...   | no _  = refl

-- S S⃰ f (x) = f x when a ≤ x < t, else 0
SS⃰ : (t a : ℕ) (f : Signal) (x : ℕ)
    → (S a (S⃰ t a f) x ≡ win t f x) ⊎ ((x < a) × (S a (S⃰ t a f) x ≡ pos 0))
SS⃰ t a f x with lt? x a
... | yes h = inr (h , refl)
... | no h with lt? ((x ∸ a) + a) t | lt? x t
...   | yes _ | yes _ = inl (cong f (x∸a+a x a h))
...   | yes l | no  m = Empty.rec (m (subst (_< t) (x∸a+a x a h) l))
...   | no  m | yes l = Empty.rec (m (subst (_< t) (sym (x∸a+a x a h)) l))
...   | no  _ | no  _ = inl refl

------------------------------------------------------------------------
-- §2  Interior agreement: away from both edges the two words coincide.
------------------------------------------------------------------------

interior : (t a : ℕ) (f : Signal) (x : ℕ)
         → ¬ (x < a) → x + a < t
         → S⃰ t a (S a f) x ≡ S a (S⃰ t a f) x
interior t a f x a≤x x+a<t with lt? (x + a) t | lt? x a
... | no  m | _     = Empty.rec (m x+a<t)
... | yes _ | yes h = Empty.rec (a≤x h)
... | yes _ | no  h with lt? (x + a) a | lt? ((x ∸ a) + a) t
...   | yes k | _     = Empty.rec (¬x+a<a x a k)
...   | no  _ | yes _ = cong f (x+a∸a x a ∙ sym (x∸a+a x a h))
...   | no  _ | no  m = Empty.rec (m (subst (_< t) (sym (x∸a+a x a h)) (≤<-trans (≤SumLeft {n = x} {k = a}) x+a<t)))

------------------------------------------------------------------------
-- §3  Net displacement descends; the window action does not.
------------------------------------------------------------------------

-- a word is a list of signed displacements; the two words of interest
data Word : Type where
  right-then-left left-then-right : Word

-- the coarse reading: net displacement (both words return to the start)
displacement : Word → ℤ
displacement right-then-left = pos 0
displacement left-then-right = pos 0

-- the fine reading: the operator on the window, read at x = 0 on δ₀
δ₀ : Signal
δ₀ zero    = pos 1
δ₀ (suc _) = pos 0

act : ℕ → ℕ → Word → Signal → Signal
act t a right-then-left = λ f → S⃰ t a (S a f)
act t a left-then-right = λ f → S a (S⃰ t a f)

read0 : ℕ → ℕ → Word → ℤ
read0 t a w = act t a w δ₀ zero

-- for 1 ≤ a < t: right-then-left keeps δ₀(0) = 1, left-then-right kills it
read0-rtl : (t a : ℕ) → suc a < t → read0 t (suc a) right-then-left ≡ pos 1
read0-rtl t a a<t with lt? (zero + suc a) t
... | no  m = Empty.rec (m a<t)
... | yes _ with lt? (zero + suc a) (suc a)
...   | yes k = Empty.rec (¬m<m k)
...   | no  _ = cong δ₀ (x+a∸a zero (suc a))

read0-ltr : (t a : ℕ) → read0 t (suc a) left-then-right ≡ pos 0
read0-ltr t a with lt? zero (suc a)
... | yes _ = refl
... | no  m = Empty.rec (m (suc-≤-suc zero-≤))

private
  pos1≢pos0 : ¬ (pos 1 ≡ pos 0)
  pos1≢pos0 p = snotz (injPos p)
    where open import Cubical.Data.Int using (injPos)

-- THE OBSTRUCTION: for every window t > a ≥ 1, the operator reading does
-- not factor through net displacement.
window-action-not-through-displacement :
  (t a : ℕ) → suc a < t → ¬ (FactorsThrough displacement (read0 t (suc a)))
window-action-not-through-displacement t a a<t =
  factorObstruction displacement (read0 t (suc a))
    right-then-left left-then-right refl
    (λ e → pos1≢pos0 (sym (read0-rtl t a a<t) ∙ e ∙ read0-ltr t a))
