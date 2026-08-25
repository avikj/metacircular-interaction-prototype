{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RadixResidueUnification
--
-- TWO MODULES, ONE OBJECT.
--
-- `notes/PRIOR_ART_TRANSPORTDIV.md` found that this directory contains
-- two independent formalisations of the base-`b` digit action:
--
--   * `RadixSymptoma`, module `Radix`, over an ARBITRARY
--     digit alphabet `D` with weight `dig : D → ℕ`:
--
--         step r d = b · r + dig d          (NO reduction)
--         val (d ∷ w) = b ^ length w · dig d + val w
--         run≡ : run step r w ≡ b ^ length w · r + val w
--
--     The state is a full numeral; it grows without bound as digits are
--     consumed.  The modulus `M` enters only through the OBSERVATION
--     `obs x = isZero (x mod M)`, i.e. the reduction is performed once,
--     at the end, by the observer.  `w`'s HEAD is its MOST significant
--     digit (`val` weights it by `b ^ length w`): Radix is BIG-ENDIAN.
--
--   * `TransportDiv`, on the `Digits` chart:
--
--         modw n []      = 0 mod n
--         modw n (d ∷ w) = (toℕ d + b · modw n w) mod n
--
--     One reduction PER DIGIT, so the state never leaves `{0,…,n−1}`.
--     `Digits.Word` is LITTLE-ENDIAN (`Digits.agda` §0: "the head is the
--     *least* significant digit"), matching `value (d ∷ w) = toℕ d +
--     b · value w`.
--
-- Same shadow, two objects, no theorem between them — the homometry
-- hazard.  This module is the theorem.
--
-- WHAT IS PROVED HERE.
--
--   §1  THE CONVENTIONS DIFFER, AND THE REVERSAL IS PART OF THE
--       STATEMENT.  `val-rev : Radix.val (rev w) ≡ Digits.value w`.
--       Everything downstream carries `rev`; without it the two
--       automata compute different functions (they agree only on
--       palindromic digit words), so `rev` is not bookkeeping.
--
--   §2  AGREEMENT.  `radix-mod≡modw`:
--
--           (run Radix.step 0 (rev w)) mod n  ≡  modw n w
--
--       — the unreduced run, reduced once at the end, IS the reduced
--       run.  Proved through `Radix.run≡` (unreduced, exact) composed
--       with `TransportDiv.value-modw` (reduced, congruent), so it is
--       the composite of the two modules' own correctness theorems and
--       borrows nothing new.  The general-start form
--       `radix-mod-from` is included because the reduced automaton has
--       no general-start form: `modw` is hard-wired to start at 0.
--
--   §3  ONE DECISION, NOT TWO.  `decDividesRadix` reads the unreduced
--       final state; `WalkResidueBridge.decDivides` reads the reduced
--       one.  `decisions-agree` proves them EQUAL as inhabitants of
--       `Dec ((suc n) ∣ value w)` via `isPropDec isProp∣`, the argument
--       `WalkResidueBridge.decDividesℕ-agrees` uses.  This is equality
--       of decisions, not agreement of extensions: either may be
--       substituted for the other under any predicate whatsoever.
--
--   §4  THE COST DIFFERENCE, WHICH IS THE WHOLE REMAINING CONTENT.
--       `reduced-bounded : modw (suc n) w < suc n` — for every word,
--       uniformly, the state is below the modulus.  Against it
--       `unreduced-grows : suc (length w) ≤ run Radix.step 1 (rev w)`,
--       through `unreduced-below : b ^ length w ≤ run Radix.step 1
--       (rev w)` and `pow-lb : suc m ≤ b ^ m` (which needs `2 ≤ b`, and
--       has it: `Digits.b = suc (suc k)`).  So the unreduced state is
--       bounded below by a function of `length w` alone and above by
--       nothing depending on `n`, while the reduced state is bounded by
--       `n` alone and by nothing depending on `w`.
--
-- ON `Residual`.  This is the `Residual` shape — one object, two
-- presentations, δ ≡ 0 (§2 is the bridge) and ϱ ≢ 0 (§4 is the gap) —
-- and it is NOT instantiated here, deliberately.  `CostGeometry.Presentation`
-- requires `op : Carrier → Carrier → Carrier`; the digit action is
-- `State → Digit → State`, a heterogeneous action with no binary
-- operation to offer, so `Residual.respond` could only be reached by
-- fabricating an `op` and two edge costs, and the resulting `↝` would
-- be a restatement of numbers put in by hand rather than a theorem.
-- §4's two bounds are the honest form of the same claim.  Read this
-- paragraph as an unproved framing remark, which is what it is.
--
-- NAME COLLISION (reported, not fixed).  `RadixSymptoma.scale-mod` and
-- `TransportDiv.scale-mod` are DIFFERENT theorems sharing a name in one
-- directory:
--
--     RadixSymptoma:  (b n j k r s : ℕ) → (b ^ k · r) mod n ≡ (b ^ k · s) mod n
--                   → (b ^ (j + k) · r) mod n ≡ (b ^ (j + k) · s) mod n
--     TransportDiv:   (n x : ℕ) → (b · x) mod n ≡ (b · (x mod n)) mod n
--
-- Neither is renamed here (both are load-bearing).  RECOMMENDATION:
-- rename the RadixSymptoma one, to `scale-mod-deep` — it is the
-- statement that a congruence survives every DEEPER scaling, which the
-- current name does not say, and `RadixSymptoma` is imported by exactly
-- one module (`agda`, the index) against `TransportDiv`'s
-- six.  This module dodges the clash by importing `RadixSymptoma`
-- qualified as `RS`, which is why it can mention both.
--
-- CHECKED: Agda 2.6.3, cubical v0.7 (/tmp/cubical), --cubical --safe,
-- exit 0, 4.4 s wall from a cold interface for this module and for
-- `RadixSymptoma`.  No postulates, no holes.
--
-- TOOLCHAIN, STATED IN FULL BECAUSE IT IS NOT CLEAN.  The check above
-- required a ONE-LINE compatibility fix to the cubical checkout, which
-- was applied, used, and then REVERTED, so the environment as left will
-- reproduce the failure and not the success:
--
--   /tmp/cubical/Cubical/Tactics/Reflection.agda:92
--     -    withReduceDefs (false , don't-Reduce) (
--     +    dontReduceDefs don't-Reduce (
--
-- cubical v0.7 is released for Agda 2.6.4.1 and `withReduceDefs` does
-- not exist in the installed Agda 2.6.3, where the same effect is
-- `dontReduceDefs`.  Consequence, which is not this module's fault and
-- is worth flagging on its own: EVERY module in this directory that
-- uses `solveℕ!` is currently unbuildable here, `RadixSymptoma`
-- INCLUDED — there is no `RadixSymptoma.agdai` in `_build/2.6.3/`, so
-- its own header's green claim has never been reproduced in this
-- environment.  Same caveat as `TransportDiv`: NOT verified against the
-- pin in `formal/cubical/BUILD.md` (Agda 2.8.0, cubical v0.9), where
-- `withReduceDefs` exists and no patch is needed.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ ; zero ; suc)

module RadixResidueUnification (k : ℕ) where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Mod using (_mod_ ; mod<)
open import Cubical.Data.Nat.Divisibility using (_∣_ ; isProp∣)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Fin using (Fin ; toℕ)
open import Cubical.Data.List using (List ; [] ; _∷_ ; [_] ; _++_ ; length ; rev)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Dec ; yes ; no ; ¬_ ; isPropDec)
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

open import Digits k
open import TransportDiv k
open import WalkResidueBridge k using (∣→modw-zero ; decDivides)

import FutureBehavior as FB
import RadixSymptoma as RS

------------------------------------------------------------------------
-- 0.  The two machines, side by side.
--
-- `R n` is `RadixSymptoma.Radix` instantiated on THIS lane's alphabet:
-- digits `Fin b` weighted by `toℕ`, base `b = suc (suc k)`, modulus `n`.
-- The instantiation is the point: RadixSymptoma's alphabet is arbitrary,
-- so `Digits.Digit` is one of its instances and no generality is lost.
------------------------------------------------------------------------

module R (n : ℕ) = RS.Radix {D = Digit} b n toℕ

-- The unreduced state after consuming `w` from state `r`.  `rev` is
-- forced by §1 and is discussed there.
uns : ℕ → ℕ → Word → ℕ
uns n r w = FB.run (R.step n) r (rev w)

------------------------------------------------------------------------
-- 1.  ENDIANNESS.  `Radix.val` is big-endian, `Digits.value` is
--     little-endian, and `rev` is the isomorphism between them.
------------------------------------------------------------------------

private
  snocBase : (x c : ℕ) → 1 · x + 0 ≡ c · 0 + x
  snocBase _ _ = solveℕ!

  snocStep : (p c e v x : ℕ) → (c · p) · e + (c · v + x) ≡ c · (p · e + v) + x
  snocStep _ _ _ _ _ = solveℕ!

  zeroStart : (x v : ℕ) → x · 0 + v ≡ v
  zeroStart _ _ = solveℕ!

  oneStart : (x v : ℕ) → v + x ≡ x · 1 + v
  oneStart _ _ = solveℕ!

  twoBound : (c x : ℕ) → c · x + (x + x) ≡ (2 + c) · x
  twoBound _ _ = solveℕ!

length-snoc : (u : Word) (d : Digit) → length (u ++ [ d ]) ≡ suc (length u)
length-snoc []      d = refl
length-snoc (e ∷ u) d = cong suc (length-snoc u d)

length-rev : (w : Word) → length (rev w) ≡ length w
length-rev []      = refl
length-rev (d ∷ w) = length-snoc (rev w) d ∙ cong suc (length-rev w)

-- Appending one digit at the LOW end of a big-endian numeral is one
-- Horner step.  This is `Radix.step` seen from the `val` side.
val-snoc : (n : ℕ) (u : Word) (d : Digit)
         → R.val n (u ++ [ d ]) ≡ b · R.val n u + toℕ d
val-snoc n []      d = snocBase (toℕ d) b
val-snoc n (e ∷ u) d =
    cong (λ z → b ^ z · toℕ e + R.val n (u ++ [ d ])) (length-snoc u d)
  ∙ cong (λ z → b ^ suc (length u) · toℕ e + z) (val-snoc n u d)
  ∙ snocStep (b ^ length u) b (toℕ e) (R.val n u) (toℕ d)

-- THE ENDIAN THEOREM.  The two positional evaluations are the same
-- function up to reversal — and only up to reversal.
val-rev : (n : ℕ) (w : Word) → R.val n (rev w) ≡ value w
val-rev n []      = refl
val-rev n (d ∷ w) =
    val-snoc n (rev w) d
  ∙ cong (λ z → b · z + toℕ d) (val-rev n w)
  ∙ +-comm (b · value w) (toℕ d)

------------------------------------------------------------------------
-- 2.  AGREEMENT.  The unreduced run, reduced once at the end, is the
--     reduced run.
------------------------------------------------------------------------

-- The unreduced machine on a little-endian word, in closed form.  This
-- is `Radix.run≡` transported across §1.
uns≡ : (n r : ℕ) (w : Word) → uns n r w ≡ b ^ length w · r + value w
uns≡ n r w =
    R.run≡ n (rev w) r
  ∙ cong₂ (λ x y → x · r + y) (cong (b ^_) (length-rev w)) (val-rev n w)

-- Started at 0, the unreduced state is the number itself: the machine
-- is not testing the value, it is BUILDING it.
uns-zero : (n : ℕ) (w : Word) → uns n 0 w ≡ value w
uns-zero n w = uns≡ n 0 w ∙ zeroStart (b ^ length w) (value w)

-- THE UNIFICATION THEOREM.
--
--   RadixSymptoma reduces once, at the observer.
--   TransportDiv reduces at every digit.
--   They land on the same residue, for every base, every modulus
--   (0 included), and every word.
radix-mod≡modw : (n : ℕ) (w : Word) → (uns n 0 w) mod n ≡ modw n w
radix-mod≡modw n w = cong (_mod n) (uns-zero n w) ∙ sym (value-modw n w)

-- The reduced automaton has no general-start form (`modw` begins at 0
-- by definition), so the general statement can only be made on the
-- unreduced side; this is it, and `radix-mod≡modw` is its `r = 0` case
-- after `value-modw`.
radix-mod-from : (n r : ℕ) (w : Word)
  → (uns n r w) mod n ≡ (b ^ length w · r + value w) mod n
radix-mod-from n r w = cong (_mod n) (uns≡ n r w)

-- The same statement in the observation the two modules actually read.
-- `R.obs n` is RadixSymptoma's only observation; `isZero (modw n w)` is
-- the reduced automaton's final test.
radix-obs≡ : (n : ℕ) (w : Word)
  → R.obs n (uns n 0 w) ≡ isZero (modw n w)
radix-obs≡ n w = cong isZero (radix-mod≡modw n w)

------------------------------------------------------------------------
-- 3.  ONE DECISION.
--
-- `Radix.Accepts r u` is "`u` carries `r` to a multiple of the modulus".
-- At `r = 0` on `rev w` it is the divisibility test RadixSymptoma's
-- automaton induces; `modw … ≡ 0` is TransportDiv's.  They are
-- interchangeable, then equal.
------------------------------------------------------------------------

accepts→modw-zero : (n : ℕ) (w : Word)
  → R.Accepts n 0 (rev w) → modw n w ≡ 0
accepts→modw-zero n w a = sym (radix-mod≡modw n w) ∙ a

modw-zero→accepts : (n : ℕ) (w : Word)
  → modw n w ≡ 0 → R.Accepts n 0 (rev w)
modw-zero→accepts n w h = radix-mod≡modw n w ∙ h

-- RadixSymptoma's acceptance, at a positive modulus, IS divisibility of
-- the number the little-endian word names.  (The positivity caveat is
-- TransportDiv's, verbatim: `x mod 0 = 0`, so the modulus-0 automaton
-- accepts everything and asserts nothing.)
radix-accepts→∣ : (n : ℕ) (w : Word)
  → R.Accepts (suc n) 0 (rev w) → (suc n) ∣ value w
radix-accepts→∣ n w a = modw-zero→∣ n w (accepts→modw-zero (suc n) w a)

∣→radix-accepts : (n : ℕ) (w : Word)
  → (suc n) ∣ value w → R.Accepts (suc n) 0 (rev w)
∣→radix-accepts n w d = modw-zero→accepts (suc n) w (∣→modw-zero n w d)

-- The divisibility test induced by the UNREDUCED automaton …
decDividesRadix : (n : ℕ) (w : Word) → Dec ((suc n) ∣ value w)
decDividesRadix n w with discreteℕ ((uns (suc n) 0 w) mod (suc n)) 0
... | yes p = yes (radix-accepts→∣ n w p)
... | no ¬p = no  (λ d → ¬p (∣→radix-accepts n w d))

-- … and the theorem that it is not a second test.  `_∣_` is a
-- proposition, so `Dec` of it is a proposition, so the two decisions are
-- equal — not merely both correct.  (The argument is
-- `WalkResidueBridge.decDividesℕ-agrees`, applied one level up.)
decisions-agree : (n : ℕ) (w : Word)
  → decDividesRadix n w ≡ decDivides n w
decisions-agree n w = isPropDec isProp∣ _ _

------------------------------------------------------------------------
-- 4.  THE COST DIFFERENCE THAT SURVIVES THE AGREEMENT.
--
-- §2 and §3 say the two lanes compute one function and take one
-- decision.  Everything that remains is where the state lives.
------------------------------------------------------------------------

-- REDUCED: below the modulus, for every word.  The bound does not
-- mention `w`.
reduced-bounded : (n : ℕ) (w : Word) → modw (suc n) w < suc n
reduced-bounded n []      = mod< n 0
reduced-bounded n (d ∷ w) = mod< n (toℕ d + b · modw (suc n) w)

-- UNREDUCED: at least `b ^ length w`, from the state 1.  The bound does
-- not mention `n`.
unreduced-below : (n : ℕ) (w : Word) → b ^ length w ≤ uns n 1 w
unreduced-below n w =
  subst (b ^ length w ≤_) (sym (uns≡ n 1 w))
        (value w , oneStart (b ^ length w) (value w))

-- `2 ≤ b` is definitional here (`Digits.b = suc (suc k)`), so the
-- exponential really is unbounded and this is a theorem, not a gesture.
pow-lb : (m : ℕ) → suc m ≤ b ^ m
pow-lb zero    = ≤-refl
pow-lb (suc m) = ≤-trans (≤-trans dbl (≤-trans up1 up2)) two
  where
    ih : suc m ≤ b ^ m
    ih = pow-lb m

    dbl : suc (suc m) ≤ suc m + suc m
    dbl = suc-≤-suc (m , refl)

    up1 : suc m + suc m ≤ b ^ m + suc m
    up1 = ≤-+k ih

    up2 : b ^ m + suc m ≤ b ^ m + b ^ m
    up2 = ≤-k+ ih

    two : b ^ m + b ^ m ≤ b ^ suc m
    two = k · (b ^ m) , twoBound k (b ^ m)

-- THE GAP, stated so the two sides are comparable: the reduced state is
-- bounded by the modulus and by nothing about the word; the unreduced
-- state exceeds the word's own length and is bounded by nothing about
-- the modulus.  Same function (§2), same decision (§3), different
-- machine.
unreduced-grows : (n : ℕ) (w : Word) → suc (length w) ≤ uns n 1 w
unreduced-grows n w = ≤-trans (pow-lb (length w)) (unreduced-below n w)
