{-# OPTIONS --cubical --safe --guardedness #-}

------------------------------------------------------------------------
-- Punarāgamana · Krama  (क्रम, order/succession)
--
-- WHAT A TOTAL ORDER COSTS.  A machine that records only the final state
-- discards the fact that two events were independent.  A machine that
-- imposes one global sequence INVENTS an order that may not be there.
-- Neither is honest.  What is honest is to keep the difference between
--
--   genuine dependence          — the order is data, and survives
--   arbitrary serialisation     — the order is an artefact, and is not
--
-- and to have a proof that says which one is in front of you.
--
-- THE PROOF IS THE COMMUTATION.  For two steps f and g, a term of
--
--   Commutes = (a : A) → f (g a) ≡ g (f a)
--
-- is exactly the certificate that the serialisation between them is
-- removable.  The theorem below turns that certificate into the normal
-- form it licenses: for ANY interleaving word w over the two steps,
--
--   apply w a  ≡  iterate f (countL w) (iterate g (countR w) a)
--
-- so the result depends on the two COUNTS and not on the order — the
-- word's residue is the pair of counts, and its sequence is discarded
-- with a proof rather than by assumption.  (This is the Mazurkiewicz
-- quotient: words modulo the swap of independent events.)
--
-- ITS FAILURE IS NOT SILENCE.  The converse half is a computed refutation,
-- not a remark: `suc` and `double` do not commute; two words with EQUAL
-- counts compute 2 and 1; and so the order is genuinely part of the
-- result.  There is no filler to find, and the honest thing is to keep the
-- sequence.  The hypothesis of the theorem is exactly the thing that
-- fails, which is why the theorem is not vacuous.
--
-- THE SAME SEAM ELSEWHERE IN THE CORPUS.
-- formal/cubical/theorems/grammar/AvaktavyaTheYugapatContentIsOrderFree…
-- makes the krama/yugapat distinction for the fourth bhaṅga: the joint
-- content is order-free, every successive expression of it must pick an
-- order.  That is the same seam in the logical lane; this module is the
-- executional one, and neither imports the other.
--
-- WHAT IS NOT CLAIMED.  `Commutes` here is the 1-dimensional statement —
-- a path between the two composites.  The higher coherence of several such
-- squares (that a cube of them fills) is a further obligation and is not
-- proved by proving the faces.
------------------------------------------------------------------------

module Fibre.Krama_CommutationIsTheProofThatTheOrderWasNeverThereAndItsFailureIsRetained where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Properties
open import Cubical.Data.List.Base
open import Cubical.Relation.Nullary using (¬_)

open import Fibre.Orbit using (iterate)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- Words: which of the two steps fired, in which order.  The counts do not
-- depend on the steps, so they live out here.
------------------------------------------------------------------------

data Side : Type₀ where
  L R : Side

countL : List Side → ℕ
countL []      = 0
countL (L ∷ w) = suc (countL w)
countL (R ∷ w) = countL w

countR : List Side → ℕ
countR []      = 0
countR (L ∷ w) = countR w
countR (R ∷ w) = suc (countR w)

------------------------------------------------------------------------
-- Execution of a word, the normal form, and the certificate.
------------------------------------------------------------------------

module _ {A : Type ℓ} (f g : A → A) where

  apply : List Side → A → A
  apply []      a = a
  apply (L ∷ w) a = apply w (f a)
  apply (R ∷ w) a = apply w (g a)

  -- all the f's, then all the g's: the order-free representative
  normal : ℕ → ℕ → A → A
  normal m n a = iterate f m (iterate g n a)

  Commutes : Type ℓ
  Commutes = (a : A) → f (g a) ≡ g (f a)

  -- one f pushed through a block of g's
  push : Commutes → (n : ℕ) (a : A) → iterate g n (f a) ≡ f (iterate g n a)
  push c zero    a = refl
  push c (suc n) a = cong (iterate g n) (sym (c a)) ∙ push c n (g a)

  -- THE THEOREM.  The order is not in the answer.
  serialisation : Commutes → (w : List Side) (a : A)
                → apply w a ≡ normal (countL w) (countR w) a
  serialisation c []      a = refl
  serialisation c (L ∷ w) a =
    serialisation c w (f a) ∙ cong (iterate f (countL w)) (push c (countR w) a)
  serialisation c (R ∷ w) a = serialisation c w (g a)

  -- …so any two schedules of the same independent events agree, and the
  -- synchronisation that would have forced one of them is unnecessary.
  interleavings-agree : Commutes → (w v : List Side)
                      → countL w ≡ countL v → countR w ≡ countR v
                      → (a : A) → apply w a ≡ apply v a
  interleavings-agree c w v pl pr a =
      serialisation c w a
    ∙ (λ i → normal (pl i) (pr i) a)
    ∙ sym (serialisation c v a)

------------------------------------------------------------------------
-- A pair that does commute — and the certificate is refl.
------------------------------------------------------------------------

shift : ℕ → ℕ
shift n = n + 2

suc-shift-commute : Commutes suc shift
suc-shift-commute a = refl

shift-independent : (w v : List Side)
                  → countL w ≡ countL v → countR w ≡ countR v
                  → (a : ℕ) → apply suc shift w a ≡ apply suc shift v a
shift-independent = interleavings-agree suc shift suc-shift-commute

------------------------------------------------------------------------
-- A pair that does not — and then the order is data.
------------------------------------------------------------------------

double : ℕ → ℕ
double n = n + n

suc-double-not-commuting : ¬ Commutes suc double
suc-double-not-commuting c = znots (injSuc (c 0))

-- equal counts…
same-counts-L : countL (L ∷ R ∷ []) ≡ countL (R ∷ L ∷ [])
same-counts-L = refl

same-counts-R : countR (L ∷ R ∷ []) ≡ countR (R ∷ L ∷ [])
same-counts-R = refl

-- …different results.  2 and 1.  The sequence survives in the answer, so
-- discarding it would not be compression; it would be an error.
order-survives : ¬ (apply suc double (L ∷ R ∷ []) 0 ≡ apply suc double (R ∷ L ∷ []) 0)
order-survives p = snotz (injSuc p)
