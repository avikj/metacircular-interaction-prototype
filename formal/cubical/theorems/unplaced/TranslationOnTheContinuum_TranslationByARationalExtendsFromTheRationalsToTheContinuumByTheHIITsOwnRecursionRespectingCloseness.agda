{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TranslationOnTheContinuum — the first map on SantataDhara's ℝ beyond
-- its constructors: translation by a rational,
--
--     translate s : ℝ → ℝ,   translate s (rat q) = rat (q + s),
--
-- extended to limits and to the path constructor by the HIIT's own
-- recursion, together with the proof that it respects closeness:
--
--     u ∼⟨ε⟩ v  →  translate s u ∼⟨ε⟩ translate s v.
--
-- WHAT THIS IS.  The second storey of the analysis tower: the first
-- non-trivial function ℝ → ℝ, defined and shown continuous in the only
-- sense the continuum module has (closeness-preserving, with the same
-- ε — translation is 1-Lipschitz, so no ε has to be rescaled, and no
-- arithmetic on ℚ⁺ is needed).  Its only arithmetic input is
-- TranslationInvariance; everything else is the recursion the HIIT
-- provides: rat, lim, eq for ℝ and the four closeness constructors
-- plus squash for ∼.
--
-- WHAT IS NOT HERE.  The laws — translate 0 u ≡ u, and
-- translate t (translate s u) ≡ translate (s + t) u — hold on rationals
-- up to the equality of reals (the two rationals are ε-close for every
-- ε), but to carry them to limits one needs closeness to be monotone
-- in ε and to satisfy the triangle inequality, which is the calculus of
-- §11.3.2 of the HoTT book over this ℚ⁺ and is NOT yet in the corpus.
-- On rationals the laws are proved below as closeness for every ε.
--
-- SYĀT.  A function on the continuum and its closeness-preservation,
-- by recursion; the laws at the rational layer only.
------------------------------------------------------------------------

module TranslationOnTheContinuum_TranslationByARationalExtendsFromTheRationalsToTheContinuumByTheHIITsOwnRecursionRespectingCloseness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; abs ; -_) renaming (_+_ to _+i_ ; _·_ to _·i_)
open import Cubical.Data.Int.Properties using (pos·pos)
open import Cubical.Data.Int.Order using (zero-≤pos ; suc-≤-suc) renaming (_<_ to _<ℤ_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver
open import Cubical.Tactics.NatSolver

import SantataDhara_TheContinuumBuiltFromTheAxiomsWithItsLimitsAsConstructors as S
open S using (ℝ ; rat ; lim ; eq ; _∼⟨_⟩_ ; ∼rat-rat ; ∼rat-lim ; ∼lim-rat ; ∼lim-lim ; ∼squash)
open S.ℚ using (num ; den)
open S.ℚ⁺ using (num⁺ ; den⁺)
open import ContinuumBridge_TheContinuumModulesOwnIntegersAreReflectedIntoTheLibrarysWithAdditionMultiplicationAndOrderSoClosenessIsAnOrderStatement
open import TranslationInvariance_ClosenessOfRationalsIsInvariantUnderTranslationByARationalSoTranslationWillExtendToTheContinuum

------------------------------------------------------------------------
-- §1  THE MAP, and that it respects closeness
------------------------------------------------------------------------

translate : S.ℚ → ℝ → ℝ
translate∼ : (s : S.ℚ) {u v : ℝ} {ε : S.ℚ⁺} → u ∼⟨ ε ⟩ v → translate s u ∼⟨ ε ⟩ translate s v

translate s (rat q) = rat (q +ℚ s)
translate s (lim (x , c)) = lim ((λ δ → translate s (x δ)) , λ δ ε → translate∼ s (c δ ε))
translate s (eq u v h i) = eq (translate s u) (translate s v) (λ ε → translate∼ s (h ε)) i

translate∼ s (∼rat-rat {q} {r} {ε} c) = ∼rat-rat (Close-translate ε q r s c)
translate∼ s (∼rat-lim h) = ∼rat-lim (translate∼ s h)
translate∼ s (∼lim-rat h) = ∼lim-rat (translate∼ s h)
translate∼ s (∼lim-lim h) = ∼lim-lim (translate∼ s h)
translate∼ s (∼squash p q i) = ∼squash (translate∼ s p) (translate∼ s q) i

-- the translation also reflects closeness (it is an isometry, not just Lipschitz):
-- stated at the rational layer, where it is TranslationInvariance's converse
translate-reflects-rat : (s : S.ℚ) {q r : S.ℚ} {ε : S.ℚ⁺}
                       → S.Close ε (q +ℚ s) (r +ℚ s) → S.Close ε q r
translate-reflects-rat s {q} {r} {ε} = Close-untranslate ε q r s

------------------------------------------------------------------------
-- §2  the laws at the rational layer: for every ε the two rationals are close
------------------------------------------------------------------------

-- the two ring identities behind the laws, over any commutative ring
-- (the solver reads literals reliably only through an abstract ring)
module Laws {ℓ : Level} (R' : CommRing ℓ) where
  open CommRingStr (R' .snd) renaming (_+_ to _+r_ ; _·_ to _·r_ ; -_ to neg)
  identity-zero : (Q d : fst R') → (Q ·r 1r +r 0r ·r d) ·r d +r neg (Q ·r (d ·r 1r)) ≡ 0r
  identity-zero Q d = solve! R'
  identity-assoc : (Q Sn T dq ds dt : fst R')
                 → ((Q ·r ds +r Sn ·r dq) ·r dt +r T ·r (dq ·r ds)) ·r (dq ·r (ds ·r dt))
                   +r neg ((Q ·r (ds ·r dt) +r (Sn ·r dt +r T ·r ds) ·r dq) ·r ((dq ·r ds) ·r dt))
                 ≡ 0r
  identity-assoc Q Sn T dq ds dt = solve! R'

-- a rational with numerator 0 is ε-close to itself and to any equal value:
-- closeℤ with |D| = 0 is  0 < positive
private
  zero-close : (ε : S.ℚ⁺) (p q : S.ℚ) → D p q ≡ pos 0 → S.Close ε p q
  zero-close ε p q d = closeℤ→Close ε p q
    (subst (λ z → pos (abs z) ·i pos (suc (den⁺ ε)) <ℤ pos (suc (num⁺ ε)) ·i pos (suc (den p + den q + den p · den q)))
           (sym d) positive)
    where
      positive : pos (abs (pos 0)) ·i pos (suc (den⁺ ε)) <ℤ pos (suc (num⁺ ε)) ·i pos (suc (den p + den q + den p · den q))
      positive = subst (pos 0 <ℤ_) (pos·pos (suc (num⁺ ε)) (suc (den p + den q + den p · den q))) (suc-≤-suc zero-≤pos)

zeroℚ : S.ℚ
zeroℚ = S.pos 0 S./1+ 0

-- q + 0 is ε-close to q, for every ε
translate-zero-rat : (ε : S.ℚ⁺) (q : S.ℚ) → S.Close ε (q +ℚ zeroℚ) q
translate-zero-rat ε q = zero-close ε (q +ℚ zeroℚ) q
  (cong₂ (λ x y → x +i (- y)) (cong₂ _·i_ (sum-num q zeroℚ) (refl {x = pos (suc (den q))})) (cong₂ _·i_ (refl {x = toℤ (num q)}) (sum-den q zeroℚ))
   ∙ Laws.identity-zero ℤCommRing (toℤ (num q)) (pos (suc (den q))))

-- (q + s) + t is ε-close to q + (s + t), for every ε
translate-assoc-rat : (ε : S.ℚ⁺) (q s t : S.ℚ) → S.Close ε ((q +ℚ s) +ℚ t) (q +ℚ (s +ℚ t))
translate-assoc-rat ε q s t = zero-close ε ((q +ℚ s) +ℚ t) (q +ℚ (s +ℚ t))
  (cong₂ (λ x y → x +i (- y))
     (cong₂ _·i_ (sum-num (q +ℚ s) t ∙ cong₂ _+i_ (cong (_·i pos (suc (den t))) (sum-num q s)) (cong (toℤ (num t) ·i_) (sum-den q s)))
                 (sum-den q (s +ℚ t) ∙ cong (pos (suc (den q)) ·i_) (sum-den s t)))
     (cong₂ _·i_ (sum-num q (s +ℚ t) ∙ cong₂ _+i_ (cong (toℤ (num q) ·i_) (sum-den s t)) (cong (_·i pos (suc (den q))) (sum-num s t)))
                 (sum-den (q +ℚ s) t ∙ cong (_·i pos (suc (den t))) (sum-den q s)))
   ∙ Laws.identity-assoc ℤCommRing (toℤ (num q)) (toℤ (num s)) (toℤ (num t)) (pos (suc (den q))) (pos (suc (den s))) (pos (suc (den t))))
