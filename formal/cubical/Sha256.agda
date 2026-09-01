{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Sha256 — the compression is bit-level, and the kernel replays the
-- NIST vectors by computation.
--
-- WHAT THIS IS.  FIPS 180-4 SHA-256, whole: padding, message schedule,
-- the sixty-four rounds, the digest — as total functions on bit lists,
-- under --cubical --safe, no postulates, no holes.  A hash is this
-- repository's own word made literal: अभिज्ञान, the recognition-token
-- by which the lost is known again — a receipt that identifies without
-- being the thing.  And it is the receipt at its most extreme: the map
-- is maximally lossy by design (every fibre over a digest is infinite),
-- yet the identification it performs is exact.
--
-- REPRESENTATION.  A Word is a List Bool, least-significant bit first,
-- length 32 by construction (stated, not typed — the price of lists
-- over vectors is that the invariant is carried by the builders, and
-- the theorems below are what make that price visible: the kernel
-- computes both NIST vectors through every builder at once).
-- Numeric constants enter through `fromℕ`, which divides by the
-- BUILTIN div/mod helpers — Agda evaluates those on machine integers,
-- so 2³²-sized constants cost 32 steps, not 2³².
--
-- WHAT IS PROVED, all by the kernel computing, none by citation:
--   * परीक्षा-रिक्ता  — SHA-256 of the empty message is
--     e3b0c442…7852b855, the NIST vector, by refl: the kernel pads,
--     schedules, runs 64 rounds, and compares 256 bits.
--   * परीक्षा-abc    — SHA-256 of "abc" likewise (ba7816bf…f20015ad).
--   * व्युत्क्रम-द्वयम् — notW is an involution (a small structural fact
--     proved for every length, not only 32).
--
-- WHAT IS NOT CLAIMED.  No security property — collision resistance,
-- preimage resistance — is stated or provable here; those are not
-- theorems of the function but conjectures about adversaries.  The two
-- vectors certify the IMPLEMENTATION against the standard's own
-- receipts; they do not certify the standard.  Bit order conventions
-- (LSB-first words, MSB-first streams) are this module's choices and
-- every crossing between them is a named `revL`.
--
-- CHECKED: Agda 2.8.0, --cubical --safe, through scripts/oracle with
-- both controls watched.
------------------------------------------------------------------------

module Sha256 where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _∸_)
open import Cubical.Data.Bool using (Bool ; true ; false ; not)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; length ; map)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Agda.Builtin.Nat using (div-helper ; mod-helper)

------------------------------------------------------------------------
-- §1  Small kit: local Bool ops and list folds, so nothing here leans
--     on a library corner that might move.
------------------------------------------------------------------------

and2 or2 xor2 : Bool → Bool → Bool
and2 true  b = b
and2 false _ = false
or2  true  _ = true
or2  false b = b
xor2 true  b = not b
xor2 false b = b

revL : {A : Type} → List A → List A
revL = go []
  where
    go : {A : Type} → List A → List A → List A
    go acc []       = acc
    go acc (x ∷ xs) = go (x ∷ acc) xs

foldlL : {A B : Type} → (B → A → B) → B → List A → B
foldlL f b []       = b
foldlL f b (x ∷ xs) = foldlL f (f b x) xs

takeN : {A : Type} → ℕ → List A → List A
takeN zero    _        = []
takeN (suc n) []       = []
takeN (suc n) (x ∷ xs) = x ∷ takeN n xs

dropN : {A : Type} → ℕ → List A → List A
dropN zero    xs       = xs
dropN (suc n) []       = []
dropN (suc n) (_ ∷ xs) = dropN n xs

zipL : {A B C : Type} → (A → B → C) → List A → List B → List C
zipL f []       _        = []
zipL f (_ ∷ _)  []       = []
zipL f (a ∷ as) (b ∷ bs) = f a b ∷ zipL f as bs

replicateL : {A : Type} → ℕ → A → List A
replicateL zero    _ = []
replicateL (suc n) a = a ∷ replicateL n a

applyN : {A : Type} → ℕ → (A → A) → A → A
applyN zero    f a = a
applyN (suc n) f a = f (applyN n f a)

------------------------------------------------------------------------
-- §1½  The sharing discipline (collab/FAILURES.md F56, applied).
--
-- Under --cubical the checker evaluates on its slow, substitution-based
-- path, so a lazily-built 64-round dependency chain recomputes its
-- history once per occurrence — measured here as a schedule word whose
-- bits alone cost >10 minutes, and a whole-module check that was killed
-- at 992 s.  F56's yield is the repair: WRITE THE VALUE ONCE and let
-- every later occurrence be a variable.  `sW` is that yield as a term:
-- it pattern-matches every bit of a word (forcing it to a literal) and
-- hands the literal to the continuation, so each round reads
-- constructors, never closures.  With it, the whole pipeline checks in
-- seconds; without it, the same definitions are correct and unusable.
------------------------------------------------------------------------

sW : {A : Type} → List Bool → (List Bool → A) → A
sW []           k = k []
sW (true  ∷ bs) k = sW bs (λ v → k (true  ∷ v))
sW (false ∷ bs) k = sW bs (λ v → k (false ∷ v))

forceWs : {A : Type} → List (List Bool) → (List (List Bool) → A) → A
forceWs []       k = k []
forceWs (w ∷ ws) k = sW w (λ v → forceWs ws (λ vs → k (v ∷ vs)))

------------------------------------------------------------------------
-- §2  Fast numerals.  n / 2 and n % 2 through the builtin helpers,
--     which the checker computes on machine integers (probed through
--     the oracle before being leaned on: div-helper 0 1 n 1 ≡ n / 2,
--     mod-helper 0 1 n 1 ≡ n % 2, mod-helper 0 511 n 511 ≡ n % 512).
------------------------------------------------------------------------

half : ℕ → ℕ
half n = div-helper 0 1 n 1

parity : ℕ → Bool                       -- true iff odd
parity n = odd (mod-helper 0 1 n 1)
  where
    odd : ℕ → Bool
    odd zero    = false
    odd (suc _) = true

mod512 : ℕ → ℕ
mod512 n = mod-helper 0 511 n 511

-- LSB-first bits of n, exactly w of them (n taken mod 2^w)
fromℕ : ℕ → ℕ → List Bool
fromℕ zero    _ = []
fromℕ (suc w) n = parity n ∷ fromℕ w (half n)

------------------------------------------------------------------------
-- §3  Words: 32 bits, LSB first, length kept by construction.
------------------------------------------------------------------------

Word : Type
Word = List Bool

word : ℕ → Word
word = fromℕ 32

zeroW : Word
zeroW = word 0

andW orW xorW : Word → Word → Word
andW = zipL and2
orW  = zipL or2
xorW = zipL xor2

notW : Word → Word
notW = map not

-- rotate/shift toward the LSB: out[i] = in[i+1], and the wrapped or
-- zero bit lands at the top.  On LSB-first lists both are one cons.
rotr1 shr1 : Word → Word
rotr1 []       = []
rotr1 (x ∷ xs) = xs ++ (x ∷ [])
shr1  []       = []
shr1  (_ ∷ xs) = xs ++ (false ∷ [])

rotr shr : ℕ → Word → Word
rotr n = applyN n rotr1
shr  n = applyN n shr1

-- ripple-carry addition, mod 2³² because the final carry has no cell
addC : Bool → Word → Word → Word
addC c []       _        = []
addC c (a ∷ as) []       = xor2 a c ∷ addC (and2 a c) as []
addC c (a ∷ as) (b ∷ bs) =
  xor2 a (xor2 b c) ∷ addC (or2 (and2 a b) (and2 c (xor2 a b))) as bs

addW : Word → Word → Word
addW = addC false

------------------------------------------------------------------------
-- §4  The six FIPS 180-4 functions and the constants.
------------------------------------------------------------------------

ch maj : Word → Word → Word → Word
ch  e f g = xorW (andW e f) (andW (notW e) g)
maj a b c = xorW (andW a b) (xorW (andW a c) (andW b c))

Σ0 Σ1 σ0 σ1 : Word → Word
Σ0 w = xorW (rotr 2  w) (xorW (rotr 13 w) (rotr 22 w))
Σ1 w = xorW (rotr 6  w) (xorW (rotr 11 w) (rotr 25 w))
σ0 w = xorW (rotr 7  w) (xorW (rotr 18 w) (shr 3  w))
σ1 w = xorW (rotr 17 w) (xorW (rotr 19 w) (shr 10 w))

K : List Word
K = map word
  ( 0x428a2f98 ∷ 0x71374491 ∷ 0xb5c0fbcf ∷ 0xe9b5dba5
  ∷ 0x3956c25b ∷ 0x59f111f1 ∷ 0x923f82a4 ∷ 0xab1c5ed5
  ∷ 0xd807aa98 ∷ 0x12835b01 ∷ 0x243185be ∷ 0x550c7dc3
  ∷ 0x72be5d74 ∷ 0x80deb1fe ∷ 0x9bdc06a7 ∷ 0xc19bf174
  ∷ 0xe49b69c1 ∷ 0xefbe4786 ∷ 0x0fc19dc6 ∷ 0x240ca1cc
  ∷ 0x2de92c6f ∷ 0x4a7484aa ∷ 0x5cb0a9dc ∷ 0x76f988da
  ∷ 0x983e5152 ∷ 0xa831c66d ∷ 0xb00327c8 ∷ 0xbf597fc7
  ∷ 0xc6e00bf3 ∷ 0xd5a79147 ∷ 0x06ca6351 ∷ 0x14292967
  ∷ 0x27b70a85 ∷ 0x2e1b2138 ∷ 0x4d2c6dfc ∷ 0x53380d13
  ∷ 0x650a7354 ∷ 0x766a0abb ∷ 0x81c2c92e ∷ 0x92722c85
  ∷ 0xa2bfe8a1 ∷ 0xa81a664b ∷ 0xc24b8b70 ∷ 0xc76c51a3
  ∷ 0xd192e819 ∷ 0xd6990624 ∷ 0xf40e3585 ∷ 0x106aa070
  ∷ 0x19a4c116 ∷ 0x1e376c08 ∷ 0x2748774c ∷ 0x34b0bcb5
  ∷ 0x391c0cb3 ∷ 0x4ed8aa4a ∷ 0x5b9cca4f ∷ 0x682e6ff3
  ∷ 0x748f82ee ∷ 0x78a5636f ∷ 0x84c87814 ∷ 0x8cc70208
  ∷ 0x90befffa ∷ 0xa4506ceb ∷ 0xbef9a3f7 ∷ 0xc67178f2 ∷ [])

H0 : List Word
H0 = map word
  ( 0x6a09e667 ∷ 0xbb67ae85 ∷ 0x3c6ef372 ∷ 0xa54ff53a
  ∷ 0x510e527f ∷ 0x9b05688c ∷ 0x1f83d9ab ∷ 0x5be0cd19 ∷ [])

------------------------------------------------------------------------
-- §5  Padding.  msg ++ 1 ++ 0^k ++ len₆₄, with k the least count
--     making the total a multiple of 512.  The message is a bit
--     stream, MSB-first; the 64-bit length is big-endian, so it is
--     the reversal of an LSB-first numeral.
------------------------------------------------------------------------

padZeros : ℕ → ℕ                        -- k, from the message length
padZeros L = gap (mod512 (L + 65))
  where
    gap : ℕ → ℕ
    gap zero = zero
    gap r    = 512 ∸ r

pad : List Bool → List Bool
pad m = m ++ (true ∷ replicateL (padZeros (length m)) false)
          ++ revL (fromℕ 64 (length m))

------------------------------------------------------------------------
-- §6  Blocks and the message schedule.  Splitting a stream is not
--     structural recursion, so it burns explicit fuel; the fuel is a
--     bound, not a meaning, and `suc (length _)` always suffices.
------------------------------------------------------------------------

blocks : ℕ → List Bool → List (List Bool)
blocks zero    _  = []
blocks (suc f) [] = []
blocks (suc f) m  = takeN 512 m ∷ blocks f (dropN 512 m)

toWords : ℕ → List Bool → List Word     -- MSB-first stream → LSB-first words
toWords zero    _  = []
toWords (suc f) [] = []
toWords (suc f) bs = revL (takeN 32 bs) ∷ toWords f (dropN 32 bs)

nth : ℕ → List Word → Word
nth _       []       = zeroW
nth zero    (w ∷ _)  = w
nth (suc n) (_ ∷ ws) = nth n ws

-- the schedule, built newest-first so W(t−k) is nth (k−1)
extend : ℕ → List Word → List Word
extend zero    acc = acc
extend (suc f) acc =
  sW (addW (addW (σ1 (nth 1 acc)) (nth 6 acc))
           (addW (σ0 (nth 14 acc)) (nth 15 acc)))
     (λ w → extend f (w ∷ acc))

schedule : List Bool → List Word
schedule block =
  forceWs (revL (toWords 17 block)) (λ ws → revL (extend 48 ws))

------------------------------------------------------------------------
-- §7  The sixty-four rounds and the digest.
------------------------------------------------------------------------

roundStep : List Word → Word × Word → List Word
roundStep st (k , w) =
  let a = nth 0 st ; b = nth 1 st ; c = nth 2 st ; d = nth 3 st
      e = nth 4 st ; f = nth 5 st ; g = nth 6 st ; h = nth 7 st
  in  sW (addW h (addW (Σ1 e) (addW (ch e f g) (addW k w)))) (λ t1 →
      sW (addW (Σ0 a) (maj a b c))                           (λ t2 →
      sW (addW t1 t2)                                        (λ a′ →
      sW (addW d t1)                                         (λ e′ →
      a′ ∷ a ∷ b ∷ c ∷ e′ ∷ e ∷ f ∷ g ∷ []))))

compress : List Word → List Bool → List Word
compress H block =
  forceWs H (λ Hs →
    zipL addW Hs (foldlL roundStep Hs (zipL _,_ K (schedule block))))

-- the digest, as the eight hash words
sha256ws : List Bool → List Word
sha256ws m =
  let p = pad m in foldlL compress H0 (blocks (suc (length p)) p)

-- the digest, as 256 bits MSB-first
sha256 : List Bool → List Bool
sha256 m = foldlL (λ acc w → acc ++ revL w) [] (sha256ws m)

-- bytes in, for callers who think in octets
byte : ℕ → List Bool
byte n = revL (fromℕ 8 n)

fromBytes : List ℕ → List Bool
fromBytes = foldlL (λ acc n → acc ++ byte n) []

------------------------------------------------------------------------
-- §8  The receipts.  Both NIST vectors, by the kernel computing the
--     whole pipeline and comparing all 256 bits; and one structural
--     fact proved for every length rather than measured at one.
------------------------------------------------------------------------

परीक्षा-रिक्ता : sha256ws [] ≡ map word
  ( 0xe3b0c442 ∷ 0x98fc1c14 ∷ 0x9afbf4c8 ∷ 0x996fb924
  ∷ 0x27ae41e4 ∷ 0x649b934c ∷ 0xa495991b ∷ 0x7852b855 ∷ [])
परीक्षा-रिक्ता = refl

परीक्षा-abc : sha256ws (fromBytes (0x61 ∷ 0x62 ∷ 0x63 ∷ [])) ≡ map word
  ( 0xba7816bf ∷ 0x8f01cfea ∷ 0x414140de ∷ 0x5dae2223
  ∷ 0xb00361a3 ∷ 0x96177a9c ∷ 0xb410ff61 ∷ 0xf20015ad ∷ [])
परीक्षा-abc = refl

not-not : (b : Bool) → not (not b) ≡ b
not-not true  = refl
not-not false = refl

व्युत्क्रम-द्वयम् : (w : Word) → notW (notW w) ≡ w
व्युत्क्रम-द्वयम् []       = refl
व्युत्क्रम-द्वयम् (b ∷ bs) i = not-not b i ∷ व्युत्क्रम-द्वयम् bs i
