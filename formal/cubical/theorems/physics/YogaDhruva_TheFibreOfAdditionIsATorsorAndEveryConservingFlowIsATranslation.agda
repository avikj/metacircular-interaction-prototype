{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- योगध्रुव — the first Noether charge of arithmetic.
--
-- `Dhruva_….agda` proves the frame: an observable `f` and a flow `Φ`
-- with संरक्षणम् (f ∘ Φ ≡ f pointwise) give a flow INSIDE every fibre
-- (ध्रुव-तन्तौ), and the conserved quantity is the fibre index.  That
-- file is deliberately abstract.  This file is its canonical instance,
-- the smallest one arithmetic offers:
--
--     f  =  योग : ℤ × ℤ → ℤ,   योग (a , b) = a + b
--     Φₖ =  शियर k : (a , b) ↦ (a + k , b − k)
--
-- THE CONSERVED QUANTITY IS THE FIBRE INDEX — the sum n.  The shears
-- are the invisible motion: they move every pair, and योग cannot see
-- them.  What is proved:
--
--   §१  संरक्षण : every shear satisfies Dhruva's संरक्षणम् for योग
--       ((a + k) + (b − k) ≡ a + b, by ring arithmetic via solve!).
--   §२  प्रवाह : the induced action on fiber योग n, obtained through
--       Dhruva's ध्रुव-तन्तौ — imported, not restated.
--   §३  action laws: प्रवाह 0 is the identity and shears compose
--       (प्रवाह k ∘ प्रवाह k' ≡ प्रवाह (k' + k)) — so ℤ genuinely acts.
--   §४  मुक्तता (freeness): प्रवाह k x ≡ x forces k ≡ 0, by projecting
--       to the first coordinate and cancelling.
--   §५  संक्रामिता (transitivity): any two points of fiber योग n are
--       joined by a shear — k = a' − a works, because both pairs sum
--       to the same n.
--   §६  एकशियरता (uniqueness): the joining shear is unique.
--
-- §३–§६ together say: **fiber योग n is a ℤ-torsor.**  The fibre has no
-- preferred origin — knowing the sum n tells you the orbit exactly and
-- the point not at all.  That is the charge/gauge split at its
-- smallest: n is the charge, the shear is the gauge motion.
--
-- ────────────────────────────────────────────────────────────────────
-- SYĀT — THE CLAIM, EXACTLY.  This is NOT Noether's first theorem: there is
-- no Lagrangian, no variational principle, no continuous one-parameter
-- group, no conserved current — Φ is a bare endomorphism of a set and
-- every statement is discrete and structural (the fence in Dhruva's
-- header applies verbatim).  "First Noether charge of arithmetic" is a
-- reading of §१–§६, made in this comment and in no theorem.  Nor is
-- any general dichotomy claimed: the torsor facts are proved for THIS
-- observable on THIS ring, and "every conserving flow is a translation"
-- in the title is exactly §५+§६ (each fibre point is carried to each
-- other by one and only one shear), not a classification of all
-- conserving endomorphisms of ℤ × ℤ.
--
-- TERM.  योग — addition, the standard arithmetical term (आर्यभटीयम्
-- and the siddhāntas throughout); ध्रुव as in Dhruva's header.  The
-- compound is this corpus's; no Sanskrit source states any theorem
-- below.
--
-- CHECKED: Agda 2.8.0 + agda/cubical (installed version), --cubical
-- --safe, no postulates, no holes.
------------------------------------------------------------------------

module YogaDhruva_TheFibreOfAdditionIsATorsorAndEveryConservingFlowIsATranslation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry

open CommRingStr (ℤCommRing .snd)

private
  R : Type
  R = fst ℤCommRing

-- the observable and the flow ----------------------------------------

योग : R × R → R
योग (a , b) = a + b

शियर : R → R × R → R × R
शियर k (a , b) = (a + k) , (b - k)

-- ring arithmetic, discharged by the solver --------------------------

private
  L1 : (a b k : R) → (a + k) + (b - k) ≡ a + b
  L1 _ _ _ = solve! ℤCommRing
  L2 : (a k : R) → k ≡ (a + k) - a
  L2 _ _ = solve! ℤCommRing
  L3 : (a : R) → a - a ≡ 0r
  L3 _ = solve! ℤCommRing
  L4 : (a a' : R) → a + (a' - a) ≡ a'
  L4 _ _ = solve! ℤCommRing
  L5 : (a b a' : R) → b - (a' - a) ≡ (a + b) - a'
  L5 _ _ _ = solve! ℤCommRing
  L6 : (a' b' : R) → (a' + b') - a' ≡ b'
  L6 _ _ = solve! ℤCommRing
  L7 : (a k k' : R) → (a + k') + k ≡ a + (k' + k)
  L7 _ _ _ = solve! ℤCommRing
  L8 : (b k k' : R) → (b - k') - k ≡ b - (k' + k)
  L8 _ _ _ = solve! ℤCommRing
  L9 : (a : R) → a + 0r ≡ a
  L9 _ = solve! ℤCommRing
  L10 : (b : R) → b - 0r ≡ b
  L10 _ = solve! ℤCommRing

-- §१ · every shear conserves the sum ---------------------------------

संरक्षण : (k : R) → संरक्षणम् योग (शियर k)
संरक्षण k (a , b) = L1 a b k

-- §२ · the induced action inside the fibre, through Dhruva -----------

प्रवाह : (k n : R) → fiber योग n → fiber योग n
प्रवाह k = ध्रुव-तन्तौ योग (शियर k) (संरक्षण k)

-- paths in the fibre are paths of pairs: the equation is a prop ------

private
  fib≡ : {n : R} {x y : fiber योग n} → fst x ≡ fst y → x ≡ y
  fib≡ {n = n} = Σ≡Prop (λ ab → is-set (योग ab) n)

-- §३ · the action laws: ℤ acts on the fibre --------------------------

तादात्म्य : (n : R) (x : fiber योग n) → प्रवाह 0r n x ≡ x
तादात्म्य n ((a , b) , _) = fib≡ (λ i → L9 a i , L10 b i)

संयोग : (k k' n : R) (x : fiber योग n)
      → प्रवाह k n (प्रवाह k' n x) ≡ प्रवाह (k' + k) n x
संयोग k k' n ((a , b) , _) = fib≡ (λ i → L7 a k k' i , L8 b k k' i)

-- §४ · freeness: a shear fixing any fibre point is the zero shear ----

मुक्तता : (k n : R) (x : fiber योग n) → प्रवाह k n x ≡ x → k ≡ 0r
मुक्तता k n ((a , b) , _) h =
  L2 a k ∙ cong (_- a) (cong (λ w → fst (fst w)) h) ∙ L3 a

-- §५ · transitivity: any two fibre points differ by a shear ----------

संक्रामिता : (n : R) (x y : fiber योग n) → Σ[ k ∈ R ] प्रवाह k n x ≡ y
संक्रामिता n ((a , b) , p) ((a' , b') , q) =
  (a' - a) , fib≡ (λ i → L4 a a' i , sndPath i)
  where
    sndPath : b - (a' - a) ≡ b'
    sndPath = L5 a b a' ∙ cong (_- a') (p ∙ sym q) ∙ L6 a' b'

-- §६ · and by only one: the joining shear is unique ------------------

एकशियरता : (k k' n : R) (x y : fiber योग n)
         → प्रवाह k n x ≡ y → प्रवाह k' n x ≡ y → k ≡ k'
एकशियरता k k' n ((a , b) , _) _ h h' =
  L2 a k
  ∙ cong (_- a) (cong (λ w → fst (fst w)) h ∙ sym (cong (λ w → fst (fst w)) h'))
  ∙ sym (L2 a k')
