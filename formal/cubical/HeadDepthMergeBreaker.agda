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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- HeadDepthMergeBreaker
--
-- HOSTILE REPLICATION of HeadDepthMerge (cf-indra, 2026-08-14).
--
-- The certificates in HeadDepthMerge are refl-terms, so they are only
-- as strong as its definitions being the spec.  This module attacks
-- that gap in three ways:
--
-- (A) INDEPENDENT REIMPLEMENTATION.  Every primitive is rebuilt with a
--     structurally different algorithm:
--       * powModB squares the RESULT (left-recursive h², then multiply
--         by the reduced base) instead of squaring the BASE
--         (HeadDepthMerge's right-to-left recursion), with fuel 64,
--         not 40;
--       * ordB is the minimal divisor d of q−1 with q ∣ b^d − 1
--         (divisor scan over an exact power), not an iterated
--         accumulator with fuel q;
--       * the depth threshold a ≤ e_b(q) is read as the DIVISIBILITY
--         q^a ∣ b^{ord_q(b)} − 1 (no valuation function at all; this
--         is the definition of v_q ≥ a), not as vCap with cap 40;
--       * v₂ is a downward divisibility search (largest t ≤ 24 with
--         2^t ∣ m), not repeated division;
--       * the Miller–Rabin window is an anyList over r ∈ [0, s−1]
--         with an independent powModB per slot, not a chained-squaring
--         mrChain;
--       * the 1048-triple enumeration runs a-outermost over a
--         DESCENDING base list with the coprimality guard as a boolean
--         implication, not b-outermost ascending with an if.
--     w3TheoremB and strongTheoremB below re-prove the two headline
--     certificates from these rebuilt parts, and collisionTheorem
--     certifies POINTWISE agreement of the two implementations on all
--     1048 triples — the corpus's replication standard.
--
-- (B) EDGE AUDIT, as checked terms.  Where HeadDepthMerge's
--     definitions diverge from the mathematical spec OUTSIDE the
--     guarded range, the divergence is exhibited, not prose-claimed:
--       * q ∣ b: ord saturates to 0, headDepth to the vCap fuel 40,
--         and the unguarded W3 equivalence is FALSE at (3,1,3) —
--         the b %% q == 0 guard in overTriples is load-bearing;
--       * powMod fuel exhaustion silently returns 1 %% m
--         (powMod 1 7 2 4 ≡ 1, true value 2 ≡ powModB 7 2 4);
--         in-range exponents are ≤ 23⁴−1 < 2^40, so fuel 40 is safe
--         there, with a 2-decade margin certified by the count term;
--       * the top Miller–Rabin window slot r = s−1 is genuinely
--         exercised inside the range: (q,a,b) = (17,1,3) first hits
--         −1 at r = 3 = s−1, so an off-by-one (window [0,s−2]) would
--         have flipped a certified triple — both implementations agree
--         it is a strong liar.
--
-- (C) BOUNDARY ATTACK on the note's §2 proposition (strong = Fermat).
--     Its cyclicity hypothesis fails exactly at composite moduli and
--     at 2^k, k ≥ 3, and the note claims nothing there.  Checked:
--       * n = 15 = 3·5: b = 4 is a Fermat liar and NOT a strong liar
--         — the exact counterexample showing strong = Fermat is a
--         theorem about prime powers, not a general fact; 4 is a
--         square root of 1 other than ±1 mod 15, i.e. precisely the
--         failed unique-involution step;
--       * mod 8: 3² ≡ 1 with 3 ∉ {1, −1} — (ℤ/2^k)^× non-cyclic,
--         the unique involution fails; BUT the statement itself
--         survives at q = 2 by a different mechanism (n − 1 odd ⟹
--         empty MR window ⟹ strong ≡ Fermat trivially, and Fermat
--         blindness for 2^a is b ≡ 1 mod 2^a ⟺ v₂(b−1) ≥ a), and
--         q2Theorem certifies the q = 2 analogue of BOTH certificates
--         on a finite range: the note's "not claimed at q = 2" is
--         conservative, not a hidden failure.
--
-- Also independently re-certified from the rebuilt parts: the note's
-- triple count 1048; W4's four subgroup counts, this time counting
-- ACTUAL Fermat liars over the full window [1, q^a] (HeadDepthMerge's
-- blindCount counts the headDepth-threshold predicate, whose
-- identification with Fermat blindness for bases ≥ 3q rests on the
-- prose W3, not the kernel — the gap is closed here by certifying the
-- Fermat count directly); and both Wieferich instances with their
-- neighbours via the divisor-scan ord.
--
-- --safe throughout; no postulates, no holes.
------------------------------------------------------------------------

module HeadDepthMergeBreaker where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ; zero; suc; _+_; _∸_)
open import Agda.Builtin.Nat using (_==_; _<_; div-helper; mod-helper; _*_)
open import Cubical.Data.Bool using (Bool; true; false; if_then_else_; _and_; _or_; not)
open import Cubical.Data.List using (List; []; _∷_)
open import Cubical.Data.Sigma using (_×_; _,_)

import HeadDepthMerge as HDM

------------------------------------------------------------------------
-- Arithmetic, rebuilt

_%_ : ℕ → ℕ → ℕ
n % zero  = n
n % suc m = mod-helper 0 m n m

_/_ : ℕ → ℕ → ℕ
n / zero  = 0
n / suc m = div-helper 0 m n m

eqB : Bool → Bool → Bool
eqB x y = if x then y else not y

implies : Bool → Bool → Bool
implies x y = if x then y else true

-- exact power, tail-recursive accumulator (HDM.power is right-nested)
powAcc : ℕ → ℕ → ℕ → ℕ
powAcc acc b zero    = acc
powAcc acc b (suc n) = powAcc (acc * b) b n

pow : ℕ → ℕ → ℕ
pow b n = powAcc 1 b n

-- modular exponentiation, squaring the RESULT of the recursive call
-- (b^e = (b^{e/2})² · b^{e mod 2}), base reduced; fuel 64.
--
-- The recursive result is consumed by `pmStep` as a function ARGUMENT,
-- not an inline `let h = …; (h * h) …`.  This is load-bearing for the
-- kernel, not cosmetic: the checker's normaliser does not share a
-- `let`-binding, so squaring a let-bound recursive call `h * h`
-- re-expands `pmB f …` TWICE per level → 2^{bits e} ≈ 2^18 leaf
-- evaluations per triple, and the 1048-triple certificates below never
-- return.  Passing the result as an argument shares it (exactly as
-- HeadDepthMerge's `powMod` shares its reduced base), giving the honest
-- O(log e) cost.  The arithmetic is unchanged — `pmStep`'s two branches
-- are the original `(h²·b)` and `h²` verbatim — so every certified value
-- is identical; only the reduction cost differs.
pmStep : ℕ → ℕ → ℕ → ℕ → ℕ           -- m b e h,  h the reduced h = b^{e/2}
pmStep m b e h =
  let h2 = (h * h) % m
  in if e % 2 == 1 then (h2 * (b % m)) % m else h2

pmB : ℕ → ℕ → ℕ → ℕ → ℕ
pmB zero    m b e = 1 % m
pmB (suc f) m b e =
  if e == 0 then 1 % m
  else pmStep m b e (pmB f m b (e / 2))

powModB : ℕ → ℕ → ℕ → ℕ
powModB m b e = pmB 64 m b e

------------------------------------------------------------------------
-- Lists, rebuilt

rangeB : ℕ → ℕ → List ℕ            -- x, x+1, …, x+n−1
rangeB x zero    = []
rangeB x (suc n) = x ∷ rangeB (suc x) n

downFrom : ℕ → ℕ → List ℕ          -- x, x−1, …  (n elements, descending)
downFrom x zero    = []
downFrom x (suc n) = x ∷ downFrom (x ∸ 1) n

allList : (ℕ → Bool) → List ℕ → Bool
allList f []       = true
allList f (x ∷ xs) = f x and allList f xs

anyList : (ℕ → Bool) → List ℕ → Bool
anyList f []       = false
anyList f (x ∷ xs) = f x or anyList f xs

countList : (ℕ → Bool) → List ℕ → ℕ
countList f []       = 0
countList f (x ∷ xs) = (if f x then 1 else 0) + countList f xs

sumList : (ℕ → ℕ) → List ℕ → ℕ
sumList f []       = 0
sumList f (x ∷ xs) = f x + sumList f xs

------------------------------------------------------------------------
-- ord, rebuilt: minimal divisor d of q−1 with q ∣ b^d − 1
-- (for q prime and q ∤ b this is ord_q(b); the exact power is GMP work)

findOrd : ℕ → ℕ → List ℕ → ℕ
findOrd q b []       = 0
findOrd q b (d ∷ ds) =
  if ((q ∸ 1) % d == 0) and ((pow b d ∸ 1) % q == 0)
  then d
  else findOrd q b ds

ordB : ℕ → ℕ → ℕ
ordB q b = findOrd q b (rangeB 1 (q ∸ 1))

------------------------------------------------------------------------
-- The three readings, rebuilt

-- a ≤ e_b(q) read as divisibility: q^a ∣ b^{ord_q(b)} − 1.
-- (Definition of v_q ≥ a; no valuation function, no cap.)
blindDepthB : ℕ → ℕ → ℕ → Bool
blindDepthB q a b = (pow b (ordB q b) ∸ 1) % pow q a == 0

-- Fermat liar for arbitrary modulus n
fermatN : ℕ → ℕ → Bool
fermatN n b = powModB n b (n ∸ 1) == 1

fermatBlindB : ℕ → ℕ → ℕ → Bool
fermatBlindB q a b = fermatN (pow q a) b

-- v₂ as a downward divisibility search: largest t ≤ 24 with 2^t ∣ m
v2Down : ℕ → ℕ → ℕ
v2Down zero    m = 0
v2Down (suc t) m = if m % pow 2 (suc t) == 0 then suc t else v2Down t m

v2B : ℕ → ℕ
v2B m = v2Down 24 m

-- strong (Miller–Rabin) liar for arbitrary odd n: b^d ≡ 1, or
-- b^{d·2^r} ≡ n−1 for some r ∈ [0, s−1] — each slot recomputed
-- independently, no chained squaring
strongN : ℕ → ℕ → Bool
strongN n b =
  let s = v2B (n ∸ 1)
      d = (n ∸ 1) / pow 2 s
  in (powModB n b d == 1)
     or anyList (λ r → powModB n b (d * pow 2 r) == n ∸ 1) (rangeB 0 s)

strongBlindB : ℕ → ℕ → ℕ → Bool
strongBlindB q a b = strongN (pow q a) b

wieferichB : ℕ → Bool
wieferichB q = (pow 2 (ordB q 2) ∸ 1) % (q * q) == 0

------------------------------------------------------------------------
-- The 1048 triples, enumerated differently: a outermost, bases
-- DESCENDING 3q−1 … 2, coprimality guard as an implication

primesB : List ℕ
primesB = 3 ∷ 5 ∷ 7 ∷ 11 ∷ 13 ∷ 17 ∷ 19 ∷ 23 ∷ []

basesB : ℕ → List ℕ
basesB q = downFrom (3 * q ∸ 1) (3 * q ∸ 2)

overTriplesB : (ℕ → ℕ → ℕ → Bool) → Bool
overTriplesB P =
  allList
    (λ q → allList
      (λ a → allList
        (λ b → implies (not (b % q == 0)) (P q a b))
        (basesB q))
      (rangeB 1 4))
    primesB

-- the note's arithmetic, certified: 4·Σ_q (3q−4) = 1048
tripleCount : ℕ
tripleCount =
  sumList (λ q → 4 * countList (λ b → not (b % q == 0)) (basesB q)) primesB

tripleCount-1048 : tripleCount ≡ 1048
tripleCount-1048 = refl

------------------------------------------------------------------------
-- (A) The two headline certificates, re-proved from rebuilt parts

w3B : Bool
w3B = overTriplesB (λ q a b → eqB (fermatBlindB q a b) (blindDepthB q a b))

w3TheoremB : w3B ≡ true
w3TheoremB = refl

strongB : Bool
strongB = overTriplesB (λ q a b → eqB (strongBlindB q a b) (fermatBlindB q a b))

strongTheoremB : strongB ≡ true
strongTheoremB = refl

-- pointwise collision of the two independent implementations on all
-- 1048 triples: Fermat reading, strong reading, and depth threshold
collisionB : Bool
collisionB = overTriplesB
  (λ q a b →
       eqB (fermatBlindB q a b) (HDM.fermatBlind q a b)
   and eqB (strongBlindB q a b) (HDM.strongBlind q a b)
   and eqB (blindDepthB q a b)  (a HDM.≤? HDM.headDepth q b))

collisionTheorem : collisionB ≡ true
collisionTheorem = refl

------------------------------------------------------------------------
-- (A cont.) W4 counts, strengthened: count ACTUAL Fermat liars over
-- the full window [1, q^a] (HeadDepthMerge counts the headDepth
-- threshold; for bases ≥ 3q the identification was prose-only)

fermatLiarCount : ℕ → ℕ → ℕ
fermatLiarCount q a =
  countList
    (λ b → not (b % q == 0) and fermatBlindB q a b)
    (rangeB 1 (pow q a))

w4B-5-2 : fermatLiarCount 5 2 ≡ 4
w4B-5-2 = refl

w4B-5-3 : fermatLiarCount 5 3 ≡ 4
w4B-5-3 = refl

w4B-7-3 : fermatLiarCount 7 3 ≡ 6
w4B-7-3 = refl

w4B-13-3 : fermatLiarCount 13 3 ≡ 12
w4B-13-3 = refl

-- and the threshold predicate agrees with HeadDepthMerge's count
w4B-13-3-threshold : countList
    (λ b → not (b % 13 == 0) and blindDepthB 13 3 b)
    (rangeB 1 (pow 13 3)) ≡ 12
w4B-13-3-threshold = refl

------------------------------------------------------------------------
-- (A cont.) Wieferich instances via the divisor-scan ord

wieferichB-1093 : wieferichB 1093 ≡ true
wieferichB-1093 = refl

wieferichB-3511 : wieferichB 3511 ≡ true
wieferichB-3511 = refl

notWieferichB-1091 : wieferichB 1091 ≡ false
notWieferichB-1091 = refl

notWieferichB-3517 : wieferichB 3517 ≡ false
notWieferichB-3517 = refl

------------------------------------------------------------------------
-- (B) Edge audit: definition-vs-spec divergences of HeadDepthMerge,
-- exhibited as checked terms

-- q ∣ b: HDM.ord fuel-exhausts to 0, so headDepth = vCap 40 q 0
-- saturates to the fuel 40 …
edge-ord-0 : HDM.ord 3 3 ≡ 0
edge-ord-0 = refl

edge-headDepth-saturates : HDM.headDepth 3 3 ≡ 40
edge-headDepth-saturates = refl

-- … and the UNGUARDED W3 equivalence is false there: 3 is not a
-- Fermat liar for 3, but 1 ≤ headDepth 3 3.  The b %% q == 0 guard
-- in HDM.overTriples is load-bearing, not cosmetic.
edge-w3-fails-at-q-dvd-b :
  HDM.eqBool (HDM.fermatBlind 3 1 3) (HDM._≤?_ 1 (HDM.headDepth 3 3)) ≡ false
edge-w3-fails-at-q-dvd-b = refl

-- powMod fuel exhaustion silently returns 1 %% m: with fuel 1,
-- 2^4 mod 7 comes out 1; the true value is 2 (breaker implementation).
-- In the certified range e ≤ 23^4 − 1 < 2^40 so fuel 40 never
-- exhausts, but the wart is real outside it.
edge-powMod-fuel-wart : HDM.powMod 1 7 2 4 ≡ 1
edge-powMod-fuel-wart = refl

edge-powMod-true-value : powModB 7 2 4 ≡ 2
edge-powMod-true-value = refl

-- the top Miller–Rabin window slot r = s−1 is exercised IN range:
-- n = 17, s = 4, d = 1, and 3 first hits −1 at r = 3 = s−1
-- (3 → 9 → 13 → 16 mod 17).  A window off-by-one ([0, s−2]) would
-- have flipped this certified triple; both implementations agree.
edge-window-top-slot : Path (Bool × Bool)
                          (HDM.strongBlind 17 1 3 , strongBlindB 17 1 3)
                          (true , true)
edge-window-top-slot = refl

------------------------------------------------------------------------
-- (C) Boundary attack on the note's §2 proposition

-- Composite modulus n = 15 = 3·5: the proposition FAILS, exactly as
-- its cyclicity hypothesis predicts.  b = 4 is a Fermat liar
-- (4^14 ≡ 1 mod 15) but NOT a strong liar (s = 1, d = 7,
-- 4^7 ≡ 4 ∉ {1, 14}).
cex-15-fermatLiar : fermatN 15 4 ≡ true
cex-15-fermatLiar = refl

cex-15-notStrongLiar : strongN 15 4 ≡ false
cex-15-notStrongLiar = refl

-- The failed ingredient, isolated: 4 is a square root of 1 mod 15
-- other than ±1 — the "unique involution" step of the proof is
-- exactly what composite moduli break.
cex-15-extra-involution :
  (((4 * 4) % 15 == 1) and ((not (4 == 1)) and (not (4 == 14)))) ≡ true
cex-15-extra-involution = refl

-- Same ingredient fails at n = 8 = 2³ ((ℤ/2^k)^× non-cyclic):
cex-8-extra-involution :
  (((3 * 3) % 8 == 1) and ((not (3 == 1)) and (not (3 == 7)))) ≡ true
cex-8-extra-involution = refl

-- … BUT at q = 2 the STATEMENT survives the death of its proof:
-- n − 1 is odd, so s = 0, the MR window is empty, and strong ≡ Fermat
-- trivially; and Fermat blindness for 2^a is b ≡ 1 (mod 2^a), i.e.
-- v₂(b−1) ≥ a — the one-coordinate W3 shape.  Certified for all odd
-- b ≤ 39, a ≤ 5 (moduli 2, 4, 8, 16, 32):
q2B : Bool
q2B =
  allList
    (λ b → implies (b % 2 == 1)
      (allList
        (λ a →     eqB (fermatN (pow 2 a) b) ((b ∸ 1) % pow 2 a == 0)
               and eqB (strongN (pow 2 a) b) (fermatN (pow 2 a) b))
        (rangeB 1 5)))
    (rangeB 1 39)

q2Theorem : q2B ≡ true
q2Theorem = refl
