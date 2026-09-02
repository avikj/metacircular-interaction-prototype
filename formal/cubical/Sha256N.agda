{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- Sha256N — SHA-256 as a compact native-arithmetic object: ℕ → ℕ, words
-- as naturals mod 2³², every bit operation built from builtin div/mod/+/·
-- so the kernel evaluates it on GMP integers.  No List Bool, no unrolled
-- gate DAG: this is the passable form — a small recursive definition the
-- kernel holds and computes.  NIST vectors checked by refl at the bottom.

module Sha256N where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.List using (List ; [] ; _∷_ ; foldl ; map)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Agda.Builtin.Nat using (_+_ ; _*_ ; _-_ ; div-helper ; mod-helper)
open import Agda.Builtin.Strict using (primForce)

-- native fast div/mod (builtin helpers evaluate on machine integers)
_div_ : ℕ → ℕ → ℕ
a div zero = zero
a div (suc b) = div-helper 0 b a b
_mod_ : ℕ → ℕ → ℕ
a mod zero = a
a mod (suc b) = mod-helper 0 b a b
infixl 7 _div_ _mod_

pow2 : ℕ → ℕ
pow2 zero = 1
pow2 (suc n) = 2 * pow2 n

m32 : ℕ                       -- 2³²
m32 = pow2 32
mask32 : ℕ → ℕ
mask32 x = x mod m32

-- combine two words bitwise, 32 bits, with a per-bit op f : ℕ → ℕ → ℕ
combine : ℕ → (ℕ → ℕ → ℕ) → ℕ → ℕ → ℕ → ℕ
combine zero    f w a b = 0
combine (suc n) f w a b = f (a mod 2) (b mod 2) * w + combine n f (w * 2) (a div 2) (b div 2)

xorb andb orb : ℕ → ℕ → ℕ
xorb a b = (a + b) mod 2
andb a b = a * b
orb  a b = (a + b) - (a * b)

xorN andN orN : ℕ → ℕ → ℕ
xorN = combine 32 xorb 1
andN = combine 32 andb 1
orN  = combine 32 orb 1
notN : ℕ → ℕ
notN a = (m32 - 1) - a            -- 32-bit complement (a < 2³²)

addN : ℕ → ℕ → ℕ
addN a b = mask32 (a + b)

-- rotate right / shift right within 32 bits
rotrN : ℕ → ℕ → ℕ
rotrN n x = mask32 ((x div pow2 n) + (x mod pow2 n) * pow2 (32 - n))
shrN : ℕ → ℕ → ℕ
shrN n x = x div pow2 n

Σ0 Σ1 σ0 σ1 : ℕ → ℕ
Σ0 x = xorN (rotrN 2 x)  (xorN (rotrN 13 x) (rotrN 22 x))
Σ1 x = xorN (rotrN 6 x)  (xorN (rotrN 11 x) (rotrN 25 x))
σ0 x = xorN (rotrN 7 x)  (xorN (rotrN 18 x) (shrN 3 x))
σ1 x = xorN (rotrN 17 x) (xorN (rotrN 19 x) (shrN 10 x))

ch maj : ℕ → ℕ → ℕ → ℕ
ch  e f g = xorN (andN e f) (andN (notN e) g)
maj a b c = xorN (andN a b) (xorN (andN a c) (andN b c))

K : List ℕ
K = 0x428a2f98 ∷ 0x71374491 ∷ 0xb5c0fbcf ∷ 0xe9b5dba5 ∷ 0x3956c25b ∷ 0x59f111f1 ∷ 0x923f82a4 ∷ 0xab1c5ed5
  ∷ 0xd807aa98 ∷ 0x12835b01 ∷ 0x243185be ∷ 0x550c7dc3 ∷ 0x72be5d74 ∷ 0x80deb1fe ∷ 0x9bdc06a7 ∷ 0xc19bf174
  ∷ 0xe49b69c1 ∷ 0xefbe4786 ∷ 0x0fc19dc6 ∷ 0x240ca1cc ∷ 0x2de92c6f ∷ 0x4a7484aa ∷ 0x5cb0a9dc ∷ 0x76f988da
  ∷ 0x983e5152 ∷ 0xa831c66d ∷ 0xb00327c8 ∷ 0xbf597fc7 ∷ 0xc6e00bf3 ∷ 0xd5a79147 ∷ 0x06ca6351 ∷ 0x14292967
  ∷ 0x27b70a85 ∷ 0x2e1b2138 ∷ 0x4d2c6dfc ∷ 0x53380d13 ∷ 0x650a7354 ∷ 0x766a0abb ∷ 0x81c2c92e ∷ 0x92722c85
  ∷ 0xa2bfe8a1 ∷ 0xa81a664b ∷ 0xc24b8b70 ∷ 0xc76c51a3 ∷ 0xd192e819 ∷ 0xd6990624 ∷ 0xf40e3585 ∷ 0x106aa070
  ∷ 0x19a4c116 ∷ 0x1e376c08 ∷ 0x2748774c ∷ 0x34b0bcb5 ∷ 0x391c0cb3 ∷ 0x4ed8aa4a ∷ 0x5b9cca4f ∷ 0x682e6ff3
  ∷ 0x748f82ee ∷ 0x78a5636f ∷ 0x84c87814 ∷ 0x8cc70208 ∷ 0x90befffa ∷ 0xa4506ceb ∷ 0xbef9a3f7 ∷ 0xc67178f2 ∷ []

H0 : List ℕ
H0 = 0x6a09e667 ∷ 0xbb67ae85 ∷ 0x3c6ef372 ∷ 0xa54ff53a ∷ 0x510e527f ∷ 0x9b05688c ∷ 0x1f83d9ab ∷ 0x5be0cd19 ∷ []

nth : ℕ → List ℕ → ℕ
nth _       []       = 0
nth zero    (x ∷ _)  = x
nth (suc n) (_ ∷ xs) = nth n xs

-- message schedule: 16 words → 64, built newest-first then reversed by index access
extend : ℕ → List ℕ → List ℕ
extend zero    acc = acc
extend (suc f) acc =
  primForce (addN (addN (σ1 (nth 1 acc)) (nth 6 acc)) (addN (σ0 (nth 14 acc)) (nth 15 acc)))
            (λ w → extend f (w ∷ acc))

revAcc : List ℕ → List ℕ → List ℕ
revAcc acc [] = acc
revAcc acc (x ∷ xs) = revAcc (x ∷ acc) xs
revL : List ℕ → List ℕ
revL = revAcc []

schedule : List ℕ → List ℕ            -- 16 words in → 64 words out
schedule ws = revL (extend 48 (revL ws))

-- word subtraction mod 2³² (a,b < 2³²): a ⊟ b
subN : ℕ → ℕ → ℕ
subN a b = mask32 ((a + m32) - b)

takeN : ℕ → List ℕ → List ℕ
takeN zero    _        = []
takeN (suc n) []       = []
takeN (suc n) (x ∷ xs) = x ∷ takeN n xs

lastN : ℕ → List ℕ → List ℕ
lastN n xs = revL (takeN n (revL xs))

-- one backward schedule step: from a window [Wₜ .. Wₜ₊₁₅] recover Wₜ₋₁,
-- inverting W_s = σ1(W_{s-2}) + W_{s-7} + σ0(W_{s-15}) + W_{s-16} at s = t+15
schedBack1 : List ℕ → ℕ
schedBack1 (w0 ∷ _ ∷ _ ∷ _ ∷ _ ∷ _ ∷ _ ∷ _ ∷ w8 ∷ _ ∷ _ ∷ _ ∷ _ ∷ w13 ∷ _ ∷ w15 ∷ _) =
  subN (subN (subN w15 (σ1 w13)) w8) (σ0 w0)
schedBack1 _ = 0

slideDown : ℕ → List ℕ → List ℕ → List ℕ
slideDown zero    win rec = rec
slideDown (suc f) win rec =
  primForce (schedBack1 win) (λ wp → slideDown f (wp ∷ takeN 15 win) (wp ∷ rec))

-- recover the 16-word message from the full 64-word schedule, using only
-- the last 16 words and the backward recurrence
message16 : List ℕ → List ℕ
message16 sch = takeN 16 (slideDown 48 (lastN 16 sch) [])

-- one round on the 8-word state
round : List ℕ → ℕ → ℕ → List ℕ
round st k w =
  let a = nth 0 st ; b = nth 1 st ; c = nth 2 st ; d = nth 3 st
      e = nth 4 st ; f = nth 5 st ; g = nth 6 st ; h = nth 7 st
  in primForce (addN h (addN (Σ1 e) (addN (ch e f g) (addN k w)))) (λ t1 →
     primForce (addN (Σ0 a) (maj a b c))                           (λ t2 →
     primForce (addN t1 t2)                                        (λ na →
     primForce (addN d t1)                                         (λ ne →
     na ∷ a ∷ b ∷ c ∷ ne ∷ e ∷ f ∷ g ∷ []))))

zipAdd : List ℕ → List ℕ → List ℕ
zipAdd [] _ = []
zipAdd (_ ∷ _) [] = []
zipAdd (x ∷ xs) (y ∷ ys) = primForce (addN x y) (λ z → z ∷ zipAdd xs ys)

pairKW : List ℕ → List ℕ → List (ℕ × ℕ)
pairKW [] _ = []
pairKW (_ ∷ _) [] = []
pairKW (x ∷ xs) (y ∷ ys) = (x , y) ∷ pairKW xs ys

-- compress one block (16 message words) into the 8-word state
compress : List ℕ → List ℕ → List ℕ
compress H ws = zipAdd H (foldl (λ st kw → round st (fst kw) (snd kw)) H (pairKW K (schedule ws)))

-- SHA-256 of a single 16-word block, as the 8 digest words
sha256block : List ℕ → List ℕ
sha256block ws = compress H0 ws

-- padded "abc": 24-bit message + 0x80 byte + zeros + length 24
abcBlock : List ℕ
abcBlock = 0x61626380 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 24 ∷ []

-- ℕ → ℕ face: message packed as one natural (16 words, low word first),
-- digest packed as one natural (8 words, low word first).  This is the
-- shape the yantra's equation language speaks: sha256nat y ≡ X.
splitWords : ℕ → ℕ → List ℕ
splitWords zero    _ = []
splitWords (suc k) m = (m mod m32) ∷ splitWords k (m div m32)

packWords : List ℕ → ℕ
packWords [] = 0
packWords (x ∷ xs) = x + m32 * packWords xs

sha256nat : ℕ → ℕ
sha256nat n = packWords (sha256block (splitWords 16 n))

-- the abc digest as a named natural target, so the yantra proposition
-- `sha256nat y ≡ Xabc` needs no 256-bit literal on the wire
Xabc : ℕ
Xabc = packWords ( 0xba7816bf ∷ 0x8f01cfea ∷ 0x414140de ∷ 0x5dae2223
                 ∷ 0xb00361a3 ∷ 0x96177a9c ∷ 0xb410ff61 ∷ 0xf20015ad ∷ [] )

-- the NIST vector, by the kernel computing the whole object
test-abc : sha256block abcBlock ≡
  ( 0xba7816bf ∷ 0x8f01cfea ∷ 0x414140de ∷ 0x5dae2223
  ∷ 0xb00361a3 ∷ 0x96177a9c ∷ 0xb410ff61 ∷ 0xf20015ad ∷ [] )
test-abc = refl

-- the ℕ→ℕ face agrees: sha256nat of the packed abc block is the packed digest
test-abc-nat : sha256nat (packWords abcBlock) ≡
  packWords ( 0xba7816bf ∷ 0x8f01cfea ∷ 0x414140de ∷ 0x5dae2223
            ∷ 0xb00361a3 ∷ 0x96177a9c ∷ 0xb410ff61 ∷ 0xf20015ad ∷ [] )
test-abc-nat = refl

-- THE SCHEDULE IS INVERTIBLE: recover the message from the expansion,
-- unexpand ∘ expand ≡ id, checked on the abc block
test-schedule-inverse : message16 (schedule abcBlock) ≡ abcBlock
test-schedule-inverse = refl

------------------------------------------------------------------------
-- PREIMAGE, 1 round.  One-round compression (feed-forward included) as a
-- function of the single message word W₀; and its INVERSE, solving the
-- round equation for W₀ from the digest.  Given a 1-round digest, we
-- recover a message word that regenerates it — a genuine preimage,
-- constructed by the round algebra and checked by the kernel.
------------------------------------------------------------------------

zipSub : List ℕ → List ℕ → List ℕ
zipSub [] _ = []
zipSub (_ ∷ _) [] = []
zipSub (x ∷ xs) (y ∷ ys) = subN x y ∷ zipSub xs ys

compress1 : ℕ → List ℕ
compress1 w = zipAdd H0 (round H0 (nth 0 K) w)

-- invert one round for the message word: from digest D, T = D ⊟ H0 = S₁,
-- T1 = S₁.a ⊟ T2  (T2 computed from H0), then peel the additive chain
solveW1 : List ℕ → ℕ
solveW1 D =
  let a0 = nth 0 H0 ; b0 = nth 1 H0 ; c0 = nth 2 H0
      e0 = nth 4 H0 ; f0 = nth 5 H0 ; g0 = nth 6 H0 ; h0 = nth 7 H0
      t2 = addN (Σ0 a0) (maj a0 b0 c0)
      t1 = subN (nth 0 (zipSub D H0)) t2
  in subN (subN (subN (subN t1 h0) (Σ1 e0)) (ch e0 f0 g0)) (nth 0 K)

-- a given 1-round digest (target), and the recovered preimage word
Xtarget1 : List ℕ
Xtarget1 = compress1 0x61626380
recovered1 : ℕ
recovered1 = solveW1 Xtarget1

-- THE PREIMAGE HOLDS: the recovered word regenerates the target digest
test-preimage-1round : compress1 recovered1 ≡ Xtarget1
test-preimage-1round = refl
-- and the inversion recovered exactly the original message word
test-recovered-word : recovered1 ≡ 0x61626380
test-recovered-word = refl

------------------------------------------------------------------------
-- PREIMAGE, 4 rounds — closed form.  After t rounds the state is
-- [aₜ,aₜ₋₁,aₜ₋₂,aₜ₋₃, eₜ,eₜ₋₁,eₜ₋₂,eₜ₋₃].  So T = digest ⊟ H0 pins the
-- last four a's and e's, and H0 pins the first four; for r = 4 the WHOLE
-- a/e trajectory is known, and each message word solves in closed form:
--   T1ₜ = eₜ₊₁ ⊟ aₜ₋₃ ,  Wₜ = T1ₜ ⊟ eₜ₋₃ ⊟ Σ1(eₜ) ⊟ ch(eₜ,eₜ₋₁,eₜ₋₂) ⊟ Kₜ
------------------------------------------------------------------------

takePairs : ℕ → List (ℕ × ℕ) → List (ℕ × ℕ)
takePairs zero    _        = []
takePairs (suc n) []       = []
takePairs (suc n) (x ∷ xs) = x ∷ takePairs n xs

compressR : ℕ → List ℕ → List ℕ            -- r-round compression, r ≤ 16
compressR r ws =
  zipAdd H0 (foldl (λ st kw → round st (fst kw) (snd kw)) H0 (takePairs r (pairKW K ws)))

-- a/e sequences indexed 0..7 for indices −3..+4
wAt : List ℕ → List ℕ → ℕ → ℕ
wAt aS eS t =
  let t1 = subN (nth (t + 4) eS) (nth t aS)
  in subN (subN (subN (subN t1 (nth t eS)) (Σ1 (nth (t + 3) eS)))
                (ch (nth (t + 3) eS) (nth (t + 2) eS) (nth (t + 1) eS)))
          (nth t K)

invert4 : List ℕ → List ℕ                  -- recover a 16-word message from a 4-round digest
invert4 D =
  let T  = zipSub D H0
      aS = nth 3 H0 ∷ nth 2 H0 ∷ nth 1 H0 ∷ nth 0 H0 ∷ nth 3 T ∷ nth 2 T ∷ nth 1 T ∷ nth 0 T ∷ []
      eS = nth 7 H0 ∷ nth 6 H0 ∷ nth 5 H0 ∷ nth 4 H0 ∷ nth 7 T ∷ nth 6 T ∷ nth 5 T ∷ nth 4 T ∷ []
  in wAt aS eS 0 ∷ wAt aS eS 1 ∷ wAt aS eS 2 ∷ wAt aS eS 3
   ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ []

-- a given 4-round digest, from some message, and the recovered preimage
Xtarget4 : List ℕ
Xtarget4 = compressR 4 abcBlock
preimage4 : List ℕ
preimage4 = invert4 Xtarget4

-- THE 4-ROUND PREIMAGE HOLDS: the recovered message regenerates the digest
test-preimage-4round : compressR 4 preimage4 ≡ Xtarget4
test-preimage-4round = refl

------------------------------------------------------------------------
-- PREIMAGE, 8 rounds — still closed form, by cascading the middle a's.
-- e_{t+1} = a_{t+1} ⊟ T2ₜ ⊞ a_{t-3}, so a_{t-3} = e_{t+1} ⊟ (a_{t+1} ⊟ T2ₜ).
-- The four pinned e's (e₅..e₈) solve a₄,a₃,a₂,a₁ in turn, each from
-- already-known a's — no search.
------------------------------------------------------------------------

invert8 : List ℕ → List ℕ
invert8 D =
  let T   = zipSub D H0
      a0  = nth 0 H0 ; am1 = nth 1 H0 ; am2 = nth 2 H0 ; am3 = nth 3 H0
      e0  = nth 4 H0 ; em1 = nth 5 H0 ; em2 = nth 6 H0 ; em3 = nth 7 H0
      a5  = nth 3 T ; a6 = nth 2 T ; a7 = nth 1 T ; a8 = nth 0 T
      e5  = nth 7 T ; e6 = nth 6 T ; e7 = nth 5 T ; e8 = nth 4 T
      a4  = subN e8 (subN a8 (addN (Σ0 a7) (maj a7 a6 a5)))
      a3  = subN e7 (subN a7 (addN (Σ0 a6) (maj a6 a5 a4)))
      a2  = subN e6 (subN a6 (addN (Σ0 a5) (maj a5 a4 a3)))
      a1  = subN e5 (subN a5 (addN (Σ0 a4) (maj a4 a3 a2)))
      e1  = addN (subN a1 (addN (Σ0 a0) (maj a0 am1 am2))) am3
      e2  = addN (subN a2 (addN (Σ0 a1) (maj a1 a0 am1))) am2
      e3  = addN (subN a3 (addN (Σ0 a2) (maj a2 a1 a0))) am1
      e4  = addN (subN a4 (addN (Σ0 a3) (maj a3 a2 a1))) a0
      aS  = am3 ∷ am2 ∷ am1 ∷ a0 ∷ a1 ∷ a2 ∷ a3 ∷ a4 ∷ a5 ∷ a6 ∷ a7 ∷ a8 ∷ []
      eS  = em3 ∷ em2 ∷ em1 ∷ e0 ∷ e1 ∷ e2 ∷ e3 ∷ e4 ∷ e5 ∷ e6 ∷ e7 ∷ e8 ∷ []
  in wAt aS eS 0 ∷ wAt aS eS 1 ∷ wAt aS eS 2 ∷ wAt aS eS 3
   ∷ wAt aS eS 4 ∷ wAt aS eS 5 ∷ wAt aS eS 6 ∷ wAt aS eS 7
   ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ 0 ∷ []

Xtarget8 : List ℕ
Xtarget8 = compressR 8 abcBlock
preimage8 : List ℕ
preimage8 = invert8 Xtarget8

-- THE 8-ROUND PREIMAGE HOLDS
test-preimage-8round : compressR 8 preimage8 ≡ Xtarget8
test-preimage-8round = refl
