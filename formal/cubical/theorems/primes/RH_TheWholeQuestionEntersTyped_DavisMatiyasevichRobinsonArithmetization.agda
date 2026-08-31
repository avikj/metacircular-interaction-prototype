{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RH, passed to the oracle properly: the whole question, as a type.
--
-- The Riemann hypothesis is equivalent (Davis–Matiyasevich–Robinson) to
--
--     for every n ≥ 1:   ( Σ_{k ≤ δ(n)} 1/k  −  n²/2 )²  <  36 n³
--
-- where δ(x) = Π_{m < x} Π_{j ≤ m} η(j), and η(j) = p when j is a prime
-- power p^k (k ≥ 1), else 1.  Every ingredient is a computable function
-- on ℕ.  Writing the harmonic sum as a fraction a/b and clearing
-- denominators, the inequality is
--
--     (2a − n²·b)²  <  144 · n³ · b²
--
-- and the signed square over ℕ is (x ∸ y + y ∸ x)², which equals the
-- square of the difference whichever side is larger.
--
-- WHAT THIS MODULE IS.  The statement, entire, as one type: RH below.
-- Every function in it computes.  Nothing here is proved about it, and
-- that is the point: the question now lives in the corpus as a typed
-- object whose inhabitation is open.  An inhabitant would be a proof of
-- the Riemann hypothesis; an inhabitant of its negation would refute it.
-- The type sits where the fourth position held the seat for it.
--
-- WHAT IS NOT CLAIMED.  No inhabitant is offered in either direction.
-- The equivalence of RH with this inequality is classical analysis and
-- is cited, not formalized here; what is formalized is the elementary
-- side, exactly.  The constant 36 (here 144 after clearing 2·) is the
-- published one.
------------------------------------------------------------------------

module RH_TheWholeQuestionEntersTyped_DavisMatiyasevichRobinsonArithmetization where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Order using (_<_ ; _≤_)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

------------------------------------------------------------------------
-- ℕ toolkit, self-contained: monus, comparison, mod and div by fuel.
------------------------------------------------------------------------

monus : ℕ → ℕ → ℕ
monus n zero          = n
monus zero (suc m)    = zero
monus (suc n) (suc m) = monus n m

isZero : ℕ → Bool
isZero zero    = true
isZero (suc _) = false

leb : ℕ → ℕ → Bool          -- n ≤ m, boolean
leb n m = isZero (monus n m)

ltb : ℕ → ℕ → Bool          -- n < m, boolean
ltb n m = leb (suc n) m

eqb : ℕ → ℕ → Bool
eqb zero zero       = true
eqb zero (suc _)    = false
eqb (suc _) zero    = false
eqb (suc n) (suc m) = eqb n m

-- n mod d and n div d, structurally recursive on fuel; fuel = n suffices
-- because each step strictly shrinks the dividend (d ≥ 1).
modF : ℕ → ℕ → ℕ → ℕ
modF zero n d       = n
modF (suc fuel) n d = if ltb n d then n else modF fuel (monus n d) d

divF : ℕ → ℕ → ℕ → ℕ
divF zero n d       = zero
divF (suc fuel) n d = if ltb n d then zero else suc (divF fuel (monus n d) d)

_mod_ : ℕ → ℕ → ℕ
n mod d = modF n n d

_div_ : ℕ → ℕ → ℕ
n div d = divF n n d

dividesb : ℕ → ℕ → Bool     -- d divides n
dividesb d n = isZero (n mod d)

------------------------------------------------------------------------
-- η: the prime-power detector.  spf finds the smallest factor ≥ 2 by
-- bounded search; powOf checks that repeated division by p reaches 1.
------------------------------------------------------------------------

spfFrom : ℕ → ℕ → ℕ → ℕ     -- fuel, candidate d, target j
spfFrom zero d j       = j
spfFrom (suc fuel) d j = if dividesb d j then d else spfFrom fuel (suc d) j

spf : ℕ → ℕ                  -- smallest factor ≥ 2 of j (j itself if j prime)
spf j = spfFrom j 2 j

powOfF : ℕ → ℕ → ℕ → Bool   -- fuel, p, j : is j a power p^k, k ≥ 1?
powOfF zero p j       = false
powOfF (suc fuel) p j =
  if eqb j 1 then false else
  if eqb j p then true  else
  if dividesb p j then powOfF fuel p (j div p) else false

η : ℕ → ℕ
η zero          = 1
η (suc zero)    = 1
η j@(suc (suc _)) = if powOfF j (spf j) j then spf j else 1

------------------------------------------------------------------------
-- δ(x) = Π_{m < x} Π_{j ≤ m} η(j)
------------------------------------------------------------------------

Πη : ℕ → ℕ                   -- Π_{j ≤ m} η(j)
Πη zero    = η zero
Πη (suc m) = Πη m · η (suc m)

δ : ℕ → ℕ                    -- Π_{m < x} Πη(m)
δ zero    = 1
δ (suc x) = δ x · Πη x

------------------------------------------------------------------------
-- The harmonic sum Σ_{k ≤ m} 1/k as one fraction, by folding
--   a/b + 1/k = (a·k + b) / (b·k),  from (0,1).
------------------------------------------------------------------------

Hfrac : ℕ → ℕ × ℕ
Hfrac zero    = 0 , 1
Hfrac (suc m) = let a = fst (Hfrac m) ; b = snd (Hfrac m)
                in  (a · suc m + b) , (b · suc m)

------------------------------------------------------------------------
-- the signed square over ℕ: (x ∸ y + y ∸ x)² = (x − y)² either way round
------------------------------------------------------------------------

diffSq : ℕ → ℕ → ℕ
diffSq x y = let d = monus x y + monus y x in d · d

------------------------------------------------------------------------
-- THE STATEMENT.  With  a/b = Σ_{k ≤ δ(n)} 1/k :
--
--     (2a − n²·b)²  <  144 · n³ · b²        for every n ≥ 1
--
-- RH is this type.  Its inhabitation is the open question.
------------------------------------------------------------------------

RH : Type
RH = (n : ℕ) → 1 ≤ n →
     let a  = fst (Hfrac (δ n))
         b  = snd (Hfrac (δ n))
         n² = n · n
         n³ = n² · n
     in  diffSq (2 · a) (n² · b)  <  144 · n³ · (b · b)

------------------------------------------------------------------------
-- The statement is a genuine proposition-shaped object: it computes.
-- One checked fact about the apparatus, so the module is not inert:
-- η classifies the first prime power correctly, definitionally.
------------------------------------------------------------------------

η-of-4 : η 4 ≡ 2
η-of-4 = refl

η-of-6 : η 6 ≡ 1
η-of-6 = refl

δ-of-3 : δ 3 ≡ 2                -- Πη(2) = η0·η1·η2 = 1·1·2, and δ(3) = 1·1·2
δ-of-3 = refl
