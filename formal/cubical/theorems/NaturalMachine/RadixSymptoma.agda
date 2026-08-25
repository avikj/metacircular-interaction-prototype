{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.RadixSymptoma
--
-- THE SHORTEST COMPLETION IS THE COMPLETE INVARIANT.
--
-- `notes/GENERAL_RADIX_DIVISIBILITY.md` records the Myhill--Nerode
-- classification of the base-`b` divisibility automaton by a signature
-- with `K + 1` coordinates,
--
--     Σ(r) = (e₀ r , … , e_{K-1} r , r mod (m / gcd(m , b^K))),
--
-- where `K` is least with `b^K ≥ m` and `e_k r` is the unique accepting
-- suffix of length `k`, or `⊥`.  This module checks a strictly shorter
-- invariant, in two coordinates and with no reference to `K`, to the
-- interval `[0 , b^k)`, or even to the digit alphabet being complete:
--
--     σ(r) = (κ r , (b^{κ r} · r) mod m)
--
-- where `κ r` — the SYMPTOMA — is the least length at which some digit
-- word carries `r` to a multiple of `m`.  Read arithmetically,
-- `(b^{κ r} · r) mod m` names exactly the set of shortest completions of
-- `r`, so the theorem is:
--
--     two states of the divisibility automaton are behaviourally equal
--     iff they have the SAME SET OF SHORTEST COMPLETIONS.
--
-- WHAT IS GENERALISED, AND WHY IT MATTERS.  The note's proof turns on
-- "a word of length k represents a unique integer n with 0 ≤ n < b^k",
-- which is a statement about the FULL digit alphabet {0,…,b-1}.  The
-- proof below never counts words and never compares `b^k` with `m`, so
-- the alphabet here is an arbitrary type `D` with an arbitrary weight
-- map `dig : D → ℕ`.  The classification is the same for digits
-- {0,2,4,6,8} in base ten, for the two-letter alphabet {0,1} in base
-- ten, and for the complete alphabet.  That independence is the content
-- the (K+1)-coordinate signature hides, because every one of its
-- coordinates is defined by an interval test that presupposes
-- completeness.
--
-- Contents (all proved, no holes, no postulates, --safe):
--
--   §1  mod-+congˡ, mod-·congʳ   congruence of `_mod_` under + and ·
--       mod-+cancel              additive cancellation mod n, proved
--                                WITHOUT subtraction or ℤ, by summing
--                                the two hypotheses in the two orders
--       ^-+, scale-mod           b^(j+k) = b^j·b^k, and its use: a
--                                congruence at depth k survives every
--                                deeper depth
--
--   §2  Radix                    the machine: step r d = b·r + dig d,
--                                observation "is the state ≡ 0 mod m"
--       run≡                     run step r w ≡ b^|w| · r + val w
--       Reach, Escape, NoEscape  the symptoma, as a RELATION (κ need
--                                not be computable: `D` may be infinite)
--
--   §3  symptoma→≈               SUFFICIENCY: equal symptoma ⇒ equal
--                                behaviour
--       ≈→sameDepth, ≈→symptoma  NECESSITY, in its two coordinates
--       noEscape→≈, ≈→noEscape   the degenerate class: states with no
--                                completion at all are all equivalent
--
-- The behavioural equality is `NaturalMachine.FutureBehavior.FutureEq`
-- verbatim, so everything that module proves about the quotient (full
-- abstraction, terminality, effectivity) applies to these classes
-- without restatement.
------------------------------------------------------------------------

module NaturalMachine.RadixSymptoma where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Mod
open import Cubical.Data.Nat.Order
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

open import NaturalMachine.FutureBehavior using (run ; behavior ; FutureEq)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- 1.  Modular arithmetic on ℕ
--
-- Every lemma holds for EVERY modulus, `0` included, because cubical's
-- `_mod_` is defined with `x mod 0 = 0`.  Nothing below needs `ℕ₊₁`,
-- subtraction, or ℤ.
------------------------------------------------------------------------

mod-+congˡ : (n c x y : ℕ) → x mod n ≡ y mod n → (x + c) mod n ≡ (y + c) mod n
mod-+congˡ n c x y p =
  mod-lCancel n x c ∙∙ cong (λ z → (z + c) mod n) p ∙∙ sym (mod-lCancel n y c)

mod-·congʳ : (n c x y : ℕ) → x mod n ≡ y mod n → (c · x) mod n ≡ (c · y) mod n
mod-·congʳ n c x y p =
    mod·mod≡mod n c x
  ∙∙ cong (λ z → ((c mod n) · z) mod n) p
  ∙∙ sym (mod·mod≡mod n c y)

private
  swap+ : (x v y : ℕ) → (x + v) + y ≡ x + (y + v)
  swap+ _ _ _ = solveℕ!

-- Additive cancellation mod n, with no inverses available: add the two
-- hypotheses to each other in the two associations.  `(x+v)+y` collapses
-- on the left to `y`, and `x+(y+v)` collapses on the right to `x`.
mod-+cancel : (n v x y : ℕ)
  → (x + v) mod n ≡ 0 → (y + v) mod n ≡ 0 → x mod n ≡ y mod n
mod-+cancel n v x y hx hy =
  sym step2 ∙∙ cong (_mod n) (sym (swap+ x v y)) ∙∙ step1
  where
    step1 : ((x + v) + y) mod n ≡ y mod n
    step1 = mod-lCancel n (x + v) y ∙ cong (λ z → (z + y) mod n) hx

    step2 : (x + (y + v)) mod n ≡ x mod n
    step2 = mod-rCancel n x (y + v)
          ∙ cong (λ z → (x + z) mod n) hy
          ∙ cong (_mod n) (+-zero x)

^-+ : (b j k : ℕ) → b ^ (j + k) ≡ b ^ j · b ^ k
^-+ b zero k = sym (+-zero (b ^ k))
^-+ b (suc j) k = cong (b ·_) (^-+ b j k) ∙ ·-assoc b (b ^ j) (b ^ k)

-- A congruence between the b^k-scalings of two states survives every
-- deeper scaling.  This is the whole arithmetic content of sufficiency.
scale-mod : (b n j k r s : ℕ)
  → (b ^ k · r) mod n ≡ (b ^ k · s) mod n
  → (b ^ (j + k) · r) mod n ≡ (b ^ (j + k) · s) mod n
scale-mod b n j k r s p =
    cong (_mod n) (regroup r)
  ∙∙ mod-·congʳ n (b ^ j) (b ^ k · r) (b ^ k · s) p
  ∙∙ cong (_mod n) (sym (regroup s))
  where
    regroup : (t : ℕ) → b ^ (j + k) · t ≡ b ^ j · (b ^ k · t)
    regroup t = cong (_· t) (^-+ b j k) ∙ sym (·-assoc (b ^ j) (b ^ k) t)

isZero→≡0 : (k : ℕ) → isZero k ≡ true → k ≡ 0
isZero→≡0 zero _ = refl
isZero→≡0 (suc k) p = Empty.rec (false≢true p)

≢0→isZero≡false : (k : ℕ) → ¬ (k ≡ 0) → isZero k ≡ false
≢0→isZero≡false zero p = Empty.rec (p refl)
≢0→isZero≡false (suc k) _ = refl

------------------------------------------------------------------------
-- 2.  The divisibility machine over an ARBITRARY digit alphabet
------------------------------------------------------------------------

module Radix {D : Type ℓ} (b M : ℕ) (dig : D → ℕ) where

  -- one digit appended on the right
  step : ℕ → D → ℕ
  step r d = b · r + dig d

  -- the only observation: is the running value a multiple of M?
  obs : ℕ → Bool
  obs x = isZero (x mod M)

  -- behavioural equality, taken verbatim from FutureBehavior
  _≈_ : ℕ → ℕ → Type ℓ
  r ≈ s = FutureEq step obs r s

  -- the numeral value of a word, alphabet-relative
  val : List D → ℕ
  val [] = 0
  val (d ∷ w) = b ^ length w · dig d + val w

  private
    base0 : (r : ℕ) → r ≡ 1 · r + 0
    base0 _ = solveℕ!

    stepId : (p c r d v : ℕ)
           → p · (c · r + d) + v ≡ (c · p) · r + (p · d + v)
    stepId _ _ _ _ _ = solveℕ!

  -- The machine is affine in the state: the word contributes a constant.
  run≡ : (w : List D) (r : ℕ) → run step r w ≡ b ^ length w · r + val w
  run≡ [] r = base0 r
  run≡ (d ∷ w) r =
    run≡ w (b · r + dig d) ∙ stepId (b ^ length w) b r (dig d) (val w)

  -- `w` completes `r` to a multiple of M.
  Accepts : ℕ → List D → Type
  Accepts r w = (run step r w) mod M ≡ 0

  acc→obs : (r : ℕ) (w : List D) → Accepts r w → obs (run step r w) ≡ true
  acc→obs r w a = cong isZero a

  obs→acc : (r : ℕ) (w : List D) → obs (run step r w) ≡ true → Accepts r w
  obs→acc r w p = isZero→≡0 _ p

  ¬acc→obs : (r : ℕ) (w : List D) → ¬ Accepts r w → obs (run step r w) ≡ false
  ¬acc→obs r w na = ≢0→isZero≡false _ na

  -- `r` has SOME completion of length k …
  Reach : ℕ → ℕ → Type ℓ
  Reach r k = Σ[ w ∈ List D ] ((length w ≡ k) × Accepts r w)

  -- … and k is the least such length.  This is the symptoma, stated as
  -- a relation rather than a function: `D` may be infinite, so the least
  -- such k need not be computable, and the theorem does not need it.
  Escape : ℕ → ℕ → Type ℓ
  Escape r k = Reach r k × ((j : ℕ) → j < k → ¬ Reach r j)

  NoEscape : ℕ → Type ℓ
  NoEscape r = (j : ℕ) → ¬ Reach r j

------------------------------------------------------------------------
-- 3.  The symptoma theorem
------------------------------------------------------------------------

  private
    -- At or beyond the escape depth, the two runs agree mod M outright.
    ≈-deep : (r s k : ℕ) → (b ^ k · r) mod M ≡ (b ^ k · s) mod M
           → (w : List D) → k ≤ length w
           → obs (run step r w) ≡ obs (run step s w)
    ≈-deep r s k p w (j , q) =
      cong isZero
        ( cong (_mod M) (run≡ w r)
        ∙∙ mod-+congˡ M (val w) (b ^ length w · r) (b ^ length w · s) hi
        ∙∙ cong (_mod M) (sym (run≡ w s)) )
      where
        hi : (b ^ length w · r) mod M ≡ (b ^ length w · s) mod M
        hi = subst (λ n → (b ^ n · r) mod M ≡ (b ^ n · s) mod M) q
                   (scale-mod b M j k r s p)

  -- SUFFICIENCY.  Equal escape depth and equal shortest-completion set
  -- imply equal behaviour.  Below the depth both states reject
  -- everything; at or above it the scaled congruence carries.
  symptoma→≈ : (r s k : ℕ) → Escape r k → Escape s k
    → (b ^ k · r) mod M ≡ (b ^ k · s) mod M
    → r ≈ s
  symptoma→≈ r s k (_ , minr) (_ , mins) p w = go (length w ≟ k)
    where
      go : Trichotomy (length w) k → obs (run step r w) ≡ obs (run step s w)
      go (lt q) =
          ¬acc→obs r w (λ a → minr (length w) q (w , refl , a))
        ∙ sym (¬acc→obs s w (λ a → mins (length w) q (w , refl , a)))
      go (eq q) = ≈-deep r s k p w (subst (λ z → z ≤ length w) q ≤-refl)
      go (gt q) = ≈-deep r s k p w (<-weaken q)

  -- NECESSITY, first coordinate: the escape depth is a behavioural
  -- invariant, hence unique.
  ≈→sameDepth : (r s k l : ℕ) → r ≈ s → Escape r k → Escape s l → k ≡ l
  ≈→sameDepth r s k l h (rr , minr) (rs , minl) = go (k ≟ l)
    where
      toS : Reach r k → Reach s k
      toS (w , lw , a) = w , lw , obs→acc s w (sym (h w) ∙ acc→obs r w a)

      toR : Reach s l → Reach r l
      toR (w , lw , a) = w , lw , obs→acc r w (h w ∙ acc→obs s w a)

      go : Trichotomy k l → k ≡ l
      go (lt q) = Empty.rec (minl k q (toS rr))
      go (eq q) = q
      go (gt q) = Empty.rec (minr l q (toR rs))

  -- NECESSITY, second coordinate: the shortest completions agree.
  ≈→symptoma : (r s k : ℕ) → r ≈ s → Escape r k
    → (b ^ k · r) mod M ≡ (b ^ k · s) mod M
  ≈→symptoma r s k h ((w , lw , a) , _) =
    mod-+cancel M (val w) (b ^ k · r) (b ^ k · s) hr hs
    where
      shift : (t : ℕ) → (run step t w) mod M ≡ 0
            → (b ^ k · t + val w) mod M ≡ 0
      shift t x = subst (λ n → (b ^ n · t + val w) mod M ≡ 0) lw
                        (sym (cong (_mod M) (run≡ w t)) ∙ x)

      hr : (b ^ k · r + val w) mod M ≡ 0
      hr = shift r a

      hs : (b ^ k · s + val w) mod M ≡ 0
      hs = shift s (obs→acc s w (sym (h w) ∙ acc→obs r w a))

  -- The degenerate class: states with no completion at all reject every
  -- word, so they form ONE behavioural class, whatever their residues.
  noEscape→≈ : (r s : ℕ) → NoEscape r → NoEscape s → r ≈ s
  noEscape→≈ r s nr ns w =
      ¬acc→obs r w (λ a → nr (length w) (w , refl , a))
    ∙ sym (¬acc→obs s w (λ a → ns (length w) (w , refl , a)))

  ≈→noEscape : (r s : ℕ) → r ≈ s → NoEscape r → NoEscape s
  ≈→noEscape r s h nr j (w , lw , a) =
    nr j (w , lw , obs→acc r w (h w ∙ acc→obs s w a))
