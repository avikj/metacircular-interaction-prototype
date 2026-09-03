{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DerivationReachabilityIsValueEquality — for closed kernel terms,
-- Derivation a b is inhabited iff the two terms have equal value; the
-- numeral of that value is a basepoint from which every closed term of
-- the value is reachable.  On open terms the derivation graph is
-- genuinely disconnected: no derivation joins two distinct atoms.
--
-- WHY THIS MODULE EXISTS.  The kernel's step rules (add-zero, add-suc,
-- the two congruences, suc-step, reverse) are arithmetic identities, so
-- every Derivation preserves eval (RewriteCertificate.derivation-sound).
-- Hence the step graph on Tm decomposes into value components, and a
-- single global basepoint connected to everything cannot exist.  What
-- CAN exist — and is constructed here — is the per-component spanning
-- datum:
--
--   connect : (t : Tm) (c : Closed t) → Derivation (numeral (val t c)) t
--
-- This is exactly the `connect : ∀ v → Walk u₀ v` hypothesis that
-- HolonomyCriterionForExactness.TestBasis takes as a module parameter
-- and never constructs, and exactly the datum
-- MulaCakraPariksa_OneCycleTestDecidesPathIndependence... declines
-- ("NOT claimed: a spanning tree or a full H₁ basis for the whole step
-- graph").  With it, each value component of the closed-term derivation
-- graph is connected with the numeral as base, so a fundamental-cycle
-- test basis for step evaluators is available per component.
--
-- THEOREMS.
--   1. normalize   — every closed term derives to the numeral of its
--                    value (structural induction; congruence maps sucD,
--                    addLeftD, addRightD; addNumeral folds a numeral
--                    sum by add-suc/add-zero).
--   2. connect     — the reverse leg, via EveryDerivationIsInvertible's
--                    revD: the numeral reaches every closed term of its
--                    value.
--   3. reach       — COMPLETENESS: closed terms of equal value are
--                    joined by a derivation (normalize, transport along
--                    the value equality, return by connect).
--   4. valueOfReach — SOUNDNESS, specialised: a derivation between
--                    closed terms forces equal values (val agrees with
--                    eval at any environment; derivation-sound).
--                    With 3: Derivation a b ⟷ val a ≡ val b on closed
--                    terms — reachability IS value equality.
--   5. atomsDisconnected — sharpness of the closedness hypothesis: no
--                    derivation joins var to yvar (evaluate at an
--                    environment separating them).
--
-- Imports the kernel's own Derivation (RewriteCertificate) and its
-- concatenation/inversion (EveryDerivationIsInvertible); nothing is
-- restated.
------------------------------------------------------------------------

module DerivationReachabilityIsValueEquality where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-suc ; znots)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

open import RewriteCertificate
  using (Tm ; var ; yvar ; zvar ; uvar ; vvar ; wvar ; zero ; suc ; add
       ; Step ; add-zero ; add-suc ; suc-step ; add-left ; add-right ; reverse
       ; Derivation ; done ; then-step
       ; Env ; eval ; derivation-sound)
open import EveryDerivationIsInvertible using (_++_ ; revD)

private
  variable
    a b : Tm

------------------------------------------------------------------------
-- 1.  Closed terms, their value, and numerals.
------------------------------------------------------------------------

Closed : Tm → Type₀
Closed var       = ⊥
Closed yvar      = ⊥
Closed zvar      = ⊥
Closed uvar      = ⊥
Closed vvar      = ⊥
Closed wvar      = ⊥
Closed zero      = Unit
Closed (suc t)   = Closed t
Closed (add l r) = Closed l × Closed r

val : (t : Tm) → Closed t → ℕ
val var       c = Empty.rec c
val yvar      c = Empty.rec c
val zvar      c = Empty.rec c
val uvar      c = Empty.rec c
val vvar      c = Empty.rec c
val wvar      c = Empty.rec c
val zero      c = 0
val (suc t)   c = suc (val t c)
val (add l r) c = val l (fst c) + val r (snd c)

numeral : ℕ → Tm
numeral zero    = zero
numeral (suc n) = suc (numeral n)

-- val agrees with the kernel's eval at every environment: a closed
-- term's value does not read the environment.
val≡eval : (t : Tm) (c : Closed t) (ρ : Env) → val t c ≡ eval t ρ
val≡eval var       c ρ = Empty.rec c
val≡eval yvar      c ρ = Empty.rec c
val≡eval zvar      c ρ = Empty.rec c
val≡eval uvar      c ρ = Empty.rec c
val≡eval vvar      c ρ = Empty.rec c
val≡eval wvar      c ρ = Empty.rec c
val≡eval zero      c ρ = refl
val≡eval (suc t)   c ρ = cong suc (val≡eval t c ρ)
val≡eval (add l r) c ρ =
  cong₂ _+_ (val≡eval l (fst c) ρ) (val≡eval r (snd c) ρ)

------------------------------------------------------------------------
-- 2.  Congruence maps on whole derivations.
------------------------------------------------------------------------

sucD : Derivation a b → Derivation (suc a) (suc b)
sucD (done x)        = done (suc x)
sucD (then-step s d) = then-step (suc-step s) (sucD d)

addLeftD : Derivation a b → (z : Tm) → Derivation (add a z) (add b z)
addLeftD (done x)        z = done (add x z)
addLeftD (then-step s d) z = then-step (add-left s z) (addLeftD d z)

addRightD : (z : Tm) → Derivation a b → Derivation (add z a) (add z b)
addRightD z (done x)        = done (add z x)
addRightD z (then-step s d) = then-step (add-right z s) (addRightD z d)

------------------------------------------------------------------------
-- 3.  A sum of numerals derives to the numeral of the sum.
------------------------------------------------------------------------

addNumeral : (m n : ℕ) → Derivation (add (numeral m) (numeral n)) (numeral (m + n))
addNumeral m zero =
  subst (λ k → Derivation (add (numeral m) zero) (numeral k))
        (sym (+-zero m))
        (then-step (add-zero (numeral m)) (done (numeral m)))
addNumeral m (suc n) =
  subst (λ k → Derivation (add (numeral m) (suc (numeral n))) (numeral k))
        (sym (+-suc m n))
        (then-step (add-suc (numeral m) (numeral n))
                   (sucD (addNumeral m n)))

------------------------------------------------------------------------
-- 4.  THEOREM (normalize).  Every closed term derives to the numeral
--     of its value.
------------------------------------------------------------------------

normalize : (t : Tm) (c : Closed t) → Derivation t (numeral (val t c))
normalize var       c = Empty.rec c
normalize yvar      c = Empty.rec c
normalize zvar      c = Empty.rec c
normalize uvar      c = Empty.rec c
normalize vvar      c = Empty.rec c
normalize wvar      c = Empty.rec c
normalize zero      c = done zero
normalize (suc t)   c = sucD (normalize t c)
normalize (add l r) c =
  (addLeftD (normalize l (fst c)) r
    ++ addRightD (numeral (val l (fst c))) (normalize r (snd c)))
    ++ addNumeral (val l (fst c)) (val r (snd c))

------------------------------------------------------------------------
-- 5.  THEOREM (connect).  The numeral is a basepoint from which every
--     closed term of its value is reachable — the spanning datum
--     TestBasis hypothesises, per value component.
------------------------------------------------------------------------

connect : (t : Tm) (c : Closed t) → Derivation (numeral (val t c)) t
connect t c = revD (normalize t c)

------------------------------------------------------------------------
-- 6.  THEOREM (reach / valueOfReach).  On closed terms, reachability
--     is value equality — both directions.
------------------------------------------------------------------------

reach : (a b : Tm) (ca : Closed a) (cb : Closed b)
      → val a ca ≡ val b cb → Derivation a b
reach a b ca cb p =
  subst (λ k → Derivation a (numeral k)) p (normalize a ca) ++ connect b cb

-- an arbitrary environment; any one works, since val ignores it.
ρ₀ : Env
ρ₀ = record { x = 0 ; y = 0 ; z = 0 ; u = 0 ; v = 0 ; w = 0 }

valueOfReach : (a b : Tm) (ca : Closed a) (cb : Closed b)
             → Derivation a b → val a ca ≡ val b cb
valueOfReach a b ca cb d =
  val≡eval a ca ρ₀ ∙ derivation-sound d ρ₀ ∙ sym (val≡eval b cb ρ₀)

------------------------------------------------------------------------
-- 7.  THEOREM (atomsDisconnected).  The closedness hypothesis is
--     sharp: the derivation graph on open terms is disconnected.  No
--     derivation joins var to yvar — evaluate at an environment that
--     separates them.
------------------------------------------------------------------------

ρ₁ : Env
ρ₁ = record { x = 0 ; y = 1 ; z = 0 ; u = 0 ; v = 0 ; w = 0 }

atomsDisconnected : Derivation var yvar → ⊥
atomsDisconnected d = znots (derivation-sound d ρ₁)
