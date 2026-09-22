{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DeflationaryTest
--
-- ────────────────────────────────────────────────────────────────────
-- THE ABSENCE TOWER
--
-- Decidability plays no part in the absence tower:
--
--     ¬-always-stable :  (A : Type ℓ) → ¬ ¬ (¬ A) → ¬ A
--
-- holds for EVERY A, decidable or not — it is `Abhava`'s own `¬¬¬→¬`,
-- which never used a hypothesis.  So the absence tower is two-tall for
-- every absence there has ever been.  Nothing in any corpus lives at
-- level three, and the level therefore carries no information about the
-- obstruction whatsoever.
--
-- ────────────────────────────────────────────────────────────────────
-- WHERE DECIDABILITY ACTUALLY ENTERS
--
--     dec→stable :  Dec A → (¬ ¬ A → A)
--
-- — a statement about the PRATIYOGIN A, not about the absence ¬A.  The
-- Navya-Nyya distinction lands here:
-- the absence is always level-two; it is the
-- counterpositive whose own recoverability decidability governs.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THE STABLE FRAGMENT SWALLOWS THIS WHOLE CORPUS
--
-- Stability is closed under ¬, under →, under ×, and under Π
-- (`Π-stable`).  Every obstruction in this thread has one of the shapes
--
--     ¬ A          (p ∤ suc n ;  ¬ Idempotent i ;  ¬ Reformulation)
--     (x : X) → ¬ A  (ℤ-has-no-i ;  sign-is-not-accumulable)
--
-- so all of them are stable by SHAPE, before anyone asks whether anything
-- is decidable.  §7 below instantiates the closure lemmas at those exact
-- shapes.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT A BARRIER CLAIM WOULD HAVE TO SAY INSTEAD
--
-- If "barrier" is to mean more than "here is a proof of ¬A", it must be a
-- claim about A:
--
--   (a) A is undecidable, or
--   (b) ¬¬A holds while A fails.
--
-- ────────────────────────────────────────────────────────────────────
-- WHERE DECIDABILITY ENTERS: THE DISJUNCTIONS
--
-- Stability is NOT closed under ⊎ — a stable-closure proof for sums is
-- exactly excluded middle.  So every place this corpus asserts an
-- either/or is a place where the deflation does not reach.  `Anekanta`'s
-- `collapse-dichotomy`, `Apavada`'s `kinds-exclude`, `NoNormOnAJoin`'s
-- `two-valued` and `three-collide` are all ⊎-shaped, and each obtains its
-- disjunction from a DECIDABLE source (`splitℕ-≤`, `discreteℤ`, an
-- explicit case split).  That is where decidability was doing work all
-- along — in the disjunctions, not in the absences.
------------------------------------------------------------------------

module DeflationaryTest where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1.  Stability
------------------------------------------------------------------------

Stable : Type ℓ → Type ℓ
Stable A = ¬ (¬ A) → A

------------------------------------------------------------------------
-- 2.  EVERY absence is stable.  No hypothesis, no decidability.
------------------------------------------------------------------------

¬-always-stable : (A : Type ℓ) → Stable (¬ A)
¬-always-stable A ¬¬¬a a = ¬¬¬a (λ ¬a → ¬a a)

-- the tower, stated as the corpus states it, now visibly unconditional
absence-tower-is-two-tall :
  (A : Type ℓ) → (¬ (¬ (¬ A)) → ¬ A) × (¬ A → ¬ (¬ (¬ A)))
absence-tower-is-two-tall A =
  ¬-always-stable A , (λ ¬a k → k ¬a)

------------------------------------------------------------------------
-- 3.  Decidability governs the COUNTERPOSITIVE, not the absence
------------------------------------------------------------------------

dec→stable : {A : Type ℓ} → Dec A → Stable A
dec→stable (yes a) _   = a
dec→stable (no ¬a) ¬¬a = Empty.rec (¬¬a ¬a)

------------------------------------------------------------------------
-- 4.  The stable fragment is closed under everything but ⊎
------------------------------------------------------------------------

Π-stable : {X : Type ℓ} {P : X → Type ℓ'}
         → ((x : X) → Stable (P x)) → Stable ((x : X) → P x)
Π-stable st h x = st x (λ k → h (λ f → k (f x)))

→-stable : {A : Type ℓ} {B : Type ℓ'} → Stable B → Stable (A → B)
→-stable stB = Π-stable (λ _ → stB)

×-stable : {A : Type ℓ} {B : Type ℓ'}
         → Stable A → Stable B → Stable (A × B)
×-stable stA stB h =
    stA (λ ka → h (λ p → ka (fst p)))
  , stB (λ kb → h (λ p → kb (snd p)))

------------------------------------------------------------------------
-- 5.  The corpus's obstruction shapes, all stable by shape
------------------------------------------------------------------------

-- shape 1: a bare absence.  `disjoint-support`'s conclusion,
-- `bhavana-is-not-a-join`, `ℤ-has-no-i` pointwise, `i-is-not-one`.
shape-absence : (A : Type ℓ) → Stable (¬ A)
shape-absence = ¬-always-stable

-- shape 2: a family of absences.  `ℤ-has-no-i`,
-- `sign-is-not-accumulable`, `disjoint-support` with its arguments.
shape-family : {X : Type ℓ} (P : X → Type ℓ')
             → Stable ((x : X) → ¬ (P x))
shape-family P = Π-stable (λ x → ¬-always-stable (P x))

-- shape 3: hypotheses in front of an absence, any number of them.
shape-conditional : {X : Type ℓ} {H : X → Type ℓ'} (P : X → Type ℓ')
                  → Stable ((x : X) → H x → ¬ (P x))
shape-conditional P = Π-stable (λ x → →-stable (¬-always-stable (P x)))

------------------------------------------------------------------------
-- 6.  What a barrier claim would have to be, as a type
--
-- Not "here is ¬A" — that is always stable and always exact.  A barrier
-- in the strong sense is a gap between ¬¬A and A, and the type below is
-- what would have to be inhabited to exhibit one.
------------------------------------------------------------------------

GenuineGap : Type ℓ → Type ℓ
GenuineGap A = (¬ (¬ A)) × (¬ A)

-- and it cannot be inhabited: a "gap" in that sense is a contradiction.
-- So even the strong reading has no room at the level of a single
-- proposition — the only honest barrier claim is UNDECIDABILITY.
no-gap : {A : Type ℓ} → ¬ (GenuineGap A)
no-gap (¬¬a , ¬a) = ¬¬a ¬a

-- which leaves exactly one form of barrier claim standing:
BarrierClaim : Type ℓ → Type ℓ
BarrierClaim A = ¬ (Dec A)

------------------------------------------------------------------------
-- 7.  The deflation, stated.
--
--   * every absence is level-two, unconditionally;
--   * so the stabilisation level measures nothing;
--   * decidability governs the counterpositive, not the absence;
--   * every obstruction in this thread is stable BY SHAPE (§5);
--   * a gap between ¬¬A and A is contradictory (`no-gap`), so the only
--     surviving form of a barrier claim is ¬¬` (Dec A)`.
--
-- The barrier vocabulary is therefore unwarranted by these objects.
--
-- Where decidability WAS doing work all along: the ⊎-shaped results.
-- Stability does not pass through sums, and `Anekanta.collapse-dichotomy`,
-- `Apavada.kinds-exclude`, `NoNormOnAJoin.two-valued` and `three-collide`
-- are all disjunctions obtained from decidable sources.  That is the
-- honest home of the avacchedaka in this corpus.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 8.  The ⊎-sites close too, and for a reason about the SUBSTRATE.
--
-- §7 leaves the sum-shaped results as the one place a genuine barrier
-- could sit, since stability does not pass through :⊎
--
--     **in a `--safe`, postulate-free development, every inhabited ⊎ is a
--     decision, because it was constructed.**
--
-- There is no way to write a term of `A ⊎ B` without producing `inl a` or
-- `inr b`.  A "non-constructive dichotomy" is not expressible in this
-- lane at all — not hard to find, not absent by luck: unwritable.
--
-- The anchor for that: a dichotomy of the
-- form `A ⊎ ¬ A` is literally decidability, up to the obvious iso.
------------------------------------------------------------------------

sum→dec : {A : Type ℓ} → A ⊎ (¬ A) → Dec A
sum→dec (inl a)  = yes a
sum→dec (inr ¬a) = no ¬a

dec→sum : {A : Type ℓ} → Dec A → A ⊎ (¬ A)
dec→sum (yes a)  = inl a
dec→sum (no ¬a)  = inr ¬a

sum→dec→sum : {A : Type ℓ} (d : A ⊎ (¬ A)) → dec→sum (sum→dec d) ≡ d
sum→dec→sum (inl _) = refl
sum→dec→sum (inr _) = refl

dec→sum→dec : {A : Type ℓ} (d : Dec A) → sum→dec (dec→sum d) ≡ d
dec→sum→dec (yes _) = refl
dec→sum→dec (no  _) = refl

------------------------------------------------------------------------
-- 9.  The deflation, closed.
--
--   * every absence is stable, unconditionally (§2) — nothing sits at
--     level three, and the level measures nothing;
--   * every obstruction in this lane is ¬-headed or a Π of such, hence
--     stable by shape (§5);
--   * a gap between ¬¬A and A is contradictory (§6), so the only
--     surviving barrier claim is ¬ (Dec A);
--   * and every dichotomy that could have carried one is a decision,
--     because in a postulate-free development it had to be built (§8).
--
-- So no statement in this repository is, or can be, a barrier in any
-- sense stronger than "here is a proof of ¬A".
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 10.  The last candidate barrier form is itself contradictory.
-- `¬ (Dec A)` is CONTRADICTORY, for every A, constructively:
--
--     no-barrier-claim :  (A : Type ℓ) → ¬ (¬ (Dec A))
--
--     assume k : ¬ (Dec A).  Then (λ a → k (yes a)) : ¬ A,
--     so (no (λ a → k (yes a))) : Dec A, and k applied to it gives ⊥.
--
-- Three lines.  So there is no barrier claim of that form to make, ever.
-- Undecidability of a specific proposition
-- is not something a constructive development can assert; what genuinely
-- undecidable results assert is something else entirely (independence
-- from a theory, or non-existence of an algorithm uniform in a
-- parameter), and neither is `¬ (Dec A)` for a fixed A.
--
-- THE DEFLATION IS THEREFORE TOTAL:
--
--   * every absence is stable (§2);
--   * every obstruction here is ¬-headed or a Π of such (§5);
--   * a gap between ¬¬A and A is contradictory (§6);
--   * every dichotomy is a decision, since it had to be built (§8);
--   * and the last candidate barrier form is itself contradictory (§10).
--
-- There is no sense available in this lane in which any statement here is
-- a barrier, other than "here is a proof of ¬A" — and that reading is
-- exact.  The word has nothing left to mean.
------------------------------------------------------------------------

no-barrier-claim : (A : Type ℓ) → ¬ (BarrierClaim A)
no-barrier-claim A k = k (no (λ a → k (yes a)))
