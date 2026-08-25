{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वर्गप्रकृति-तन्तुः — क्षेपस्य तन्तुः अनन्तः, भावना च तस्य साक्षी ।
--
-- (the vargaprakṛti fibre: the fibre of the kṣepa over one is infinite,
--  and Brahmagupta's composition is the witness.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS, AND WHY IT IS THE CRITERION AND NOT AN EXAMPLE.
--
-- `loss/src/Loss/Bhavana_…` builds वर्गप्रकृति as
-- `Carrier (क्षेपः D)`: base = the two roots, carried = the क्षेप, because
-- the roots DETERMINE it.  Its fibre `Σ[ k ] (क्षेपः D x ≡ k)` is
-- `singl`, contractible, and (ℤ × ℤ) ≃ वर्गप्रकृति D.  The carried datum
-- rides free.
--
-- Bind the OTHER side of the same equation and everything changes:
--
--     Σ[ x ] (क्षेपः D x ≡ 1)
--
-- is `fiber (क्षेपः D) 1`, and it is not contractible and not free.  It is
-- THE SET OF SOLUTIONS of the vargaprakṛti — what the कुट्टक, the भावना
-- and the चक्रवाल were all built to produce.  सूत्र ५: कः पक्षो बद्ध इति
-- सर्वम् — which side is bound, that is everything.  One map, two
-- bindings: the carrier is free, the subject is the fibre.
--
-- SO THIS FILE IS THE TWO HALVES JOINED, and neither half says it alone:
--
--   · `Bhavana_….भावना-क्षेपः` proves the carried datum MULTIPLIES:
--     क्षेप(compose) = क्षेप · क्षेप.  Hence composing a k=1 row with the
--     fundamental k=1 row stays at k=1 — the orbit never leaves the
--     fibre.  §१ below is that invariance, over ℕ and independently.
--   · `ALosslessReturn_….वृद्धिः` proves the orbit STRICTLY ASCENDS and so
--     never returns.  §३ below is that, chained.
--
--   Invariance alone gives an orbit inside the fibre and says nothing
--   about how much of it is visited.  Growth alone says the orbit is
--   infinite and says nothing about where it lives.  Together: §४, the
--   fibre contains a strictly increasing sequence, so it is infinite.
--
-- WHY THE INFINITUDE IS NOT A COUNT.  सूत्र ८ — अभिज्ञानं तादात्म्यम्, न
-- परिमाणम्.  §४ does not report a number; it exhibits an injection out of
-- ℕ, so the identification is a map you can evaluate, and the n-th
-- solution is `पङ्क्ति n`.  That is the receipt.
--
-- ────────────────────────────────────────────────────────────────────
-- SOURCES.  BRAHMAGUPTA, ब्राह्मस्फुटसिद्धान्तः १८ (कुट्टकाध्यायः), 628 CE —
-- भावना, the composition law for वर्गप्रकृति, with प्रकृति for the multiplier,
-- ज्येष्ठ and कनिष्ठ for the two roots, क्षेप for the interpolator.  The
-- root (3,2) for D=2 and the value 577/408 are BAUDHĀYANA's, शुल्बसूत्रम्
-- १.६१–६२ (~800 BCE), stated *saviśeṣa*, "with its excess".  JAYADEVA
-- (c. 950, surviving inside Udayadivākara's सुन्दरी) and BHĀSKARA II,
-- बीजगणित 1150 — the चक्रवाल.
--
-- NOT CLAIMED: that any of them stated anything below, and NOT that the
-- चक्रवाल is formalised here.  It is not: the cyclic step needs a chosen
-- m with k ∣ (a + b·m) and an exact division carrying its divisibility
-- witness, and none of that is done.  What is here is the भावना the
-- चक्रवाल is built out of, composed against the FIXED fundamental row,
-- which is the special case that needs no choice.  The citations are
-- second-hand and are owed at verse level.
--
-- ────────────────────────────────────────────────────────────────────
-- A LIMIT ON THE METHOD, added 2026-08-23 after reading a module that was
-- sitting untracked in the tree when this was written.
--
-- §१-§५ reach the fibre by composing against a FUNDAMENTAL ROW, and that
-- needs a small k=1 row to seed with.  For D = 2 the Śulba value supplies
-- one.  FOR D = 61 THERE IS NONE, and D = 61 is Bhāskara.s own worked
-- example -- so this method does not reach the case the tradition is
-- famous for, and saying only "the fibre is infinite" would leave a reader
-- believing it does.
--
-- What reaches it is the चक्रवाल, and
-- `Bhagahara_TheExactDivisionCarriesItsWitnessAndSixTurnsReachOneAtSixtyOne
-- .agda` runs one in the kernel: six turns from (8,1,+3) to
-- (29718, 3805, −1) with every divisibility witness discharged by `refl`,
-- then Brahmagupta.s composition of a k = −1 row with itself giving
-- 1766319049² − 61 · 226153980² = 1.
--
-- And it supplies the distinction this module does not make.  Here the
-- क्षेप fibre is `singl`, CONTRACTIBLE -- every pair has a क्षेप, so the
-- datum rides free.  There the भागहार fibre is a PROPOSITION AND NOT IN
-- GENERAL INHABITED, because division by k is partial and the inhabitant
-- IS the divisibility.  Contractible versus merely propositional is the
-- whole difference between the भावना being free and the चक्रवाल not being
-- free, and Bhāskara.s choice of m is what supplies the inhabitant.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module SourcedProofs.Vargaprakrtitantu_ThePellFibreIsInfiniteAndBrahmaguptasCompositionIsTheWitness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Order using (_<_ ; _≤_ ; <-trans ; ¬m<m)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

open import SourcedProofs.NoReturn_TheBhavanaOrbitStrictlyGrowsSoItNeverReturnsAndThatIsTheGenerativity
  using (नव-अंशः ; नव-हरः ; वृद्धिः)

------------------------------------------------------------------------
-- ० · the equation, in the subtraction-free form ℕ can state.
--     a² − 2b² = 1  is written  a² ≡ 2b² + 1.
------------------------------------------------------------------------

वर्गप्रकृतिः : ℕ × ℕ → Type₀
वर्गप्रकृतिः x = fst x · fst x ≡ 2 · (snd x · snd x) + 1

-- the fibre of the kṣepa over 1: the SOLUTION SET, which is what a bound
-- base gives where a bound carried gave `singl`.
तन्तुः : Type₀
तन्तुः = Σ[ x ∈ ℕ × ℕ ] वर्गप्रकृतिः x

------------------------------------------------------------------------
-- १ · अविकारः — THE STEP DOES NOT LEAVE THE FIBRE.
--
--     (a,b) ↦ (3a+4b , 2a+3b)
--
-- is भावना against the fundamental row (3,2) at D=2, whose own क्षेप is 1.
-- Brahmagupta's identity says the composed क्षेप is the PRODUCT, so it is
-- k·1 = k and the fibre is preserved.  Proved here directly in ℕ rather
-- than imported, because the ℤ statement lives in a different library
-- with its own agda-lib; two independent statements that agree is the
-- channel this corpus accepts, and asserting the import would be the
-- third road सूत्र ११ denies.
------------------------------------------------------------------------

पदम् : ℕ × ℕ → ℕ × ℕ
पदम् x = नव-अंशः (fst x) (snd x) , नव-हरः (fst x) (snd x)

अविकारः : (a b : ℕ) → वर्गप्रकृतिः (a , b) → वर्गप्रकृतिः (पदम् (a , b))
अविकारः a b h = वाम ∙ cong (λ z → 9 · z + (24 · (a · b) + 16 · (b · b))) h
              ∙ मध्यम ∙ sym (cong (λ z → 8 · z + (24 · (a · b) + 18 · (b · b)) + 1) h)
              ∙ sym दक्षिण
  where
  वाम : नव-अंशः a b · नव-अंशः a b
      ≡ 9 · (a · a) + (24 · (a · b) + 16 · (b · b))
  वाम = solveℕ!

  मध्यम : 9 · (2 · (b · b) + 1) + (24 · (a · b) + 16 · (b · b))
        ≡ 8 · (2 · (b · b) + 1) + (24 · (a · b) + 18 · (b · b)) + 1
  मध्यम = solveℕ!

  दक्षिण : 2 · (नव-हरः a b · नव-हरः a b) + 1
         ≡ 8 · (a · a) + (24 · (a · b) + 18 · (b · b)) + 1
  दक्षिण = solveℕ!

------------------------------------------------------------------------
-- २ · मूलम् — the fundamental row.  3² = 2·2² + 1, i.e. 9 = 8 + 1.
--     Baudhāyana's first convergent, and the seed of the whole orbit.
------------------------------------------------------------------------

मूलम् : तन्तुः
मूलम् = (3 , 2) , refl

------------------------------------------------------------------------
-- ३ · पङ्क्ति — THE SEQUENCE, and it lands IN the fibre by §१.
------------------------------------------------------------------------

पङ्क्ति : ℕ → तन्तुः
पङ्क्ति zero    = मूलम्
पङ्क्ति (suc n) with पङ्क्ति n
... | (a , b) , h = पदम् (a , b) , अविकारः a b h

-- the second root of the n-th solution
कनिष्ठ : ℕ → ℕ
कनिष्ठ n = snd (fst (पङ्क्ति n))

-- the first root is always a successor, so §४'s growth applies at every
-- step.  Proved alongside the sequence rather than after it, because it
-- is what keeps the growth hypothesis alive.
-- the successor form the growth lemma needs, named so solveℕ! has a target
अंश-सुक् : (z b : ℕ) → नव-अंशः (suc z) b ≡ suc (z · 3 + 4 · b + 2)
अंश-सुक् z b = solveℕ!

ज्येष्ठ-अशून्यम् : (n : ℕ) → Σ[ z ∈ ℕ ] (fst (fst (पङ्क्ति n)) ≡ suc z)
ज्येष्ठ-अशून्यम् zero    = 2 , refl
ज्येष्ठ-अशून्यम् (suc n) with पङ्क्ति n | ज्येष्ठ-अशून्यम् n
... | (a , b) , _ | z , p =
      (z · 3 + 4 · b + 2) , (cong (λ w → नव-अंशः w b) p ∙ अंश-सुक् z b)

------------------------------------------------------------------------
-- ४ · वृद्धिः पङ्क्तौ — the second root strictly grows at every step.
--     `ALosslessReturn_….वृद्धिः` needs a nonzero first root; §३'s
--     ज्येष्ठ-अशून्यम् is what keeps supplying it.
------------------------------------------------------------------------

वृद्धि-पदे : (n : ℕ) → कनिष्ठ n < कनिष्ठ (suc n)
वृद्धि-पदे n with पङ्क्ति n | ज्येष्ठ-अशून्यम् n
... | (a , b) , _ | z , p =
      subst (λ w → b < नव-हरः w b) (sym p) (वृद्धिः z b)

-- and therefore across any gap, by chaining.
वृद्धि-दूरे : (n k : ℕ) → कनिष्ठ n < कनिष्ठ (suc (k + n))
वृद्धि-दूरे n zero     = वृद्धि-पदे n
वृद्धि-दूरे n (suc k)  = <-trans (वृद्धि-दूरे n k) (वृद्धि-पदे (suc (k + n)))

------------------------------------------------------------------------
-- ५ · अनन्तः — THE FIBRE IS INFINITE.
--
--     No entry of the sequence is ever equal to a LATER entry, because
--     their second roots differ and a strict inequality forbids the
--     equality.  No trichotomy is needed: "later" is enough, and it is
--     the direction that says the sequence does not close up.
--
--     This is the join.  §१ (invariance, Brahmagupta) puts the orbit
--     inside the fibre and says nothing about how much of it is reached.
--     §४ (growth) says the orbit never repeats and says nothing about
--     where it lives.  Only together do they give a fibre containing a
--     sequence with no repetitions — an infinite solution set, with the
--     n-th solution EXHIBITED rather than counted (सूत्र ८).
------------------------------------------------------------------------

अनन्तः : (n k : ℕ) → ¬ (पङ्क्ति n ≡ पङ्क्ति (suc (k + n)))
अनन्तः n k e = ¬m<m (subst (कनिष्ठ n <_) (sym (cong (λ t → snd (fst t)) e))
                           (वृद्धि-दूरे n k))

------------------------------------------------------------------------
-- ६ · बौधायनस्य मानम् — and it lands on the Śulba value.
--
--     (3,2) → (17,12) → (99,70) → (577,408), and 577/408 is exactly the
--     *saviśeṣa* value BAUDHĀYANA gives for √2, शुल्बसूत्रम् १.६१–६२, about
--     twelve centuries before the composition that generates it here.
--     Each of these holds by `refl`, so Agda executes the arithmetic.
--
--     A DISTINCTION FOUND BY THE INDEX BEING WRONG, and it matters.
--     `Dvikarani.agda` records the chain (3,2) → (17,12) → (577,408) by
--     DOUBLING — composing each row with ITSELF.  This module composes
--     each row against the FIXED fundamental row, and gets (99,70) in
--     between.  Both are भावना and both reach Baudhāyana.s value; they
--     are not the same sequence.  Self-composition is the subsequence of
--     SQUARES and skips solutions; composition against the fundamental
--     row visits them in order.  For §५ that difference is the whole
--     point -- infinitude wants the sequence that does not skip -- and
--     the two are worth not conflating, which a note saying "the bhāvanā
--     orbit" would do.
------------------------------------------------------------------------

पङ्क्ति-० : fst (पङ्क्ति 0) ≡ (3 , 2)
पङ्क्ति-० = refl

पङ्क्ति-१ : fst (पङ्क्ति 1) ≡ (17 , 12)
पङ्क्ति-१ = refl

पङ्क्ति-२ : fst (पङ्क्ति 2) ≡ (99 , 70)
पङ्क्ति-२ = refl

पङ्क्ति-३ : fst (पङ्क्ति 3) ≡ (577 , 408)
पङ्क्ति-३ = refl

-- and the equation still holds there, computed rather than assumed
मानम्-५७७ : 577 · 577 ≡ 2 · (408 · 408) + 1
मानम्-५७७ = refl
