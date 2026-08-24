-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TransporterMembership
--
-- The torsor, closed: when two events normalize the same matrix to the
-- Smith endpoint D = dia d₁ (q·d₁) (d₁ ≠ 0), the explicit transporter
-- H = εᵤ·U′·adj U — which MOVES one event to the other
-- (Gamma0Transitivity.moves) — has lower-left entry divisible by q,
-- with the witness computed:  Σ k. H₂₁ ≡ k·q.
--
-- Nothing new is proved here by hand: the module is pure composition —
-- `stabilizes` transported to the endpoint, `det` bookkeeping
-- (multiplicativity, adjugate, scaling), and Gamma0Converse.membership
-- consuming the result.  The tower measured on finite windows in
-- August stands as one typed statement: the event set of a Smith
-- normalization is a Γ₀(q)-torsor, and every clause is a program.
------------------------------------------------------------------------

module TransporterMembership where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (⊥)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open import Gamma0Partner using (R ; M ; mul ; dia)
open import M2Unimodular using (adj ; det ; detMul)
open import Gamma0Converse using (membership)
open import Gamma0Transitivity using (scal ; stabilizes)

open CommRingStr (ℤCommRing .snd)

-- det bookkeeping -----------------------------------------------------

private
  dS : (s a b c e : R)
     → (s · a) · (s · e) - (s · b) · (s · c)
       ≡ (s · s) · (a · e - b · c)
  dS _ _ _ _ _ = solve! ℤCommRing
  dA : (a b c e : R) → e · a - (- b) · (- c) ≡ a · e - b · c
  dA _ _ _ _ = solve! ℤCommRing
  regE : (x y : R) → (x · y) · (x · y) ≡ (x · x) · (y · y)
  regE _ _ = solve! ℤCommRing

detScal : (s : R) (x : M) → det (scal s x) ≡ (s · s) · det x
detScal s (a , b , c , e) = dS s a b c e

detAdj : (x : M) → det (adj x) ≡ det x
detAdj (a , b , c , e) = dA a b c e

-- the corollary -------------------------------------------------------

module _ (U U' V V' m : M) (εu εu' εv : R) (d1 q : R)
         (hdU : det U ≡ εu) (hεu : εu · εu ≡ 1r)
         (hdU' : det U' ≡ εu') (hεu' : εu' · εu' ≡ 1r)
         (hdV : det V ≡ εv) (hεv : εv · εv ≡ 1r)
         (d1n : (d1 ≡ 0r) → ⊥)
         (hW : mul (mul U m) V ≡ dia d1 (q · d1))
         (hEq : mul (mul U' m) V' ≡ mul (mul U m) V)
         where

  Ht Kt : M
  Ht = scal εu (mul U' (adj U))
  Kt = scal εv (mul (adj V) V')

  detHt : det Ht ≡ εu' · εu
  detHt = detScal εu (mul U' (adj U))
        ∙ cong (_· det (mul U' (adj U))) hεu
        ∙ detMul U' (adj U)
        ∙ cong (det U' ·_) (detAdj U)
        ∙ cong₂ _·_ hdU' hdU

  epsSq : (εu' · εu) · (εu' · εu) ≡ 1r
  epsSq = regE εu' εu ∙ cong₂ _·_ hεu' hεu

  stabD : mul (mul Ht (dia d1 (q · d1))) Kt ≡ dia d1 (q · d1)
  stabD = subst (λ w → mul (mul Ht w) Kt ≡ w) hW
                (stabilizes U U' V V' m εu εv hdU hεu hdV hεv hEq)

  -- q divides the transporter's lower-left entry, witness computed
  transporterMembership : Σ[ k ∈ R ] fst (snd (snd Ht)) ≡ k · q
  transporterMembership =
    membership (fst Ht) (fst (snd Ht)) (fst (snd (snd Ht)))
               (snd (snd (snd Ht)))
               d1 q (εu' · εu)
               (fst Kt) (fst (snd Kt)) (fst (snd (snd Kt)))
               (snd (snd (snd Kt)))
               d1n detHt epsSq stabD
