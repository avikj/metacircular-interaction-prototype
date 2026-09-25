{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- Target-relative final-round elimination on the repository's real SHA.
-- This imports SHA's actual roundStep and the already existing equation
-- exposing it. It does not implement a surrogate round or a reduced hash.
-- For a 64-round schedule, the suffix clause is reached AFTER 61 rounds.
-- The highest Bitcoin digest word is then known; later rounds are demanded
-- only by the remaining output coordinates/continuation.
-- This is established mining prior art.

module BitcoinMiningCut where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Sha256 using
  (Word ; roundStep ; foldlL ; nth ; addW ; takeN ; dropN ; revL)
open import EveryDigestIsExactly256BitsSoTheRealHashIsUnconditionallyANonEquivalence
  using (roundStep-≡ ; T1of)

State : Type₀
State = List Word

Round : Type₀
Round = Word × Word

rounds : State → List Round → State
rounds = foldlL roundStep

rounds-append : (s : State) (prefix suffix : List Round)
  → rounds s (prefix ++ suffix) ≡ rounds (rounds s prefix) suffix
rounds-append s [] suffix = refl
rounds-append s (p ∷ ps) suffix =
  rounds-append (roundStep s p) ps suffix

-- Six copied-register laws. None evaluates T1 or T2 to establish the law.
shift-h : (s : State) (p : Round)
  → nth 7 (roundStep s p) ≡ nth 6 s
shift-h s (k , w) = cong (nth 7) (roundStep-≡ s k w)

shift-g : (s : State) (p : Round)
  → nth 6 (roundStep s p) ≡ nth 5 s
shift-g s (k , w) = cong (nth 6) (roundStep-≡ s k w)

shift-f : (s : State) (p : Round)
  → nth 5 (roundStep s p) ≡ nth 4 s
shift-f s (k , w) = cong (nth 5) (roundStep-≡ s k w)

shift-d : (s : State) (p : Round)
  → nth 3 (roundStep s p) ≡ nth 2 s
shift-d s (k , w) = cong (nth 3) (roundStep-≡ s k w)

shift-c : (s : State) (p : Round)
  → nth 2 (roundStep s p) ≡ nth 1 s
shift-c s (k , w) = cong (nth 2) (roundStep-≡ s k w)

shift-b : (s : State) (p : Round)
  → nth 1 (roundStep s p) ≡ nth 0 s
shift-b s (k , w) = cong (nth 1) (roundStep-≡ s k w)

after2 : State → Round → Round → State
after2 s p q = roundStep (roundStep s p) q

after3 : State → Round → Round → Round → State
after3 s p q r = roundStep (after2 s p q) r

h-after3 : (s : State) (p q r : Round)
  → nth 7 (after3 s p q r) ≡ nth 4 s
h-after3 s p q r =
  shift-h (after2 s p q) r
  ∙ shift-g (roundStep s p) q
  ∙ shift-f s p

g-after3 : (s : State) (p q r : Round)
  → nth 6 (after3 s p q r) ≡ nth 4 (roundStep s p)
g-after3 s p q r =
  shift-g (after2 s p q) r ∙ shift-f (roundStep s p) q

f-after3 : (s : State) (p q r : Round)
  → nth 5 (after3 s p q r) ≡ nth 4 (after2 s p q)
f-after3 s p q r = shift-f (after2 s p q) r

d-after3 : (s : State) (p q r : Round)
  → nth 3 (after3 s p q r) ≡ nth 0 s
d-after3 s p q r =
  shift-d (after2 s p q) r
  ∙ shift-c (roundStep s p) q
  ∙ shift-b s p

c-after3 : (s : State) (p q r : Round)
  → nth 2 (after3 s p q r) ≡ nth 0 (roundStep s p)
c-after3 s p q r =
  shift-c (after2 s p q) r ∙ shift-b (roundStep s p) q

b-after3 : (s : State) (p q r : Round)
  → nth 1 (after3 s p q r) ≡ nth 0 (after2 s p q)
b-after3 s p q r = shift-b (after2 s p q) r

-- Eight feed-forward words, highest BITCOIN word first. Each Word is
-- still in SHA numeric representation; byte order is handled below.
-- On the real SHA pipeline both states have eight 32-bit words.
descendingFeed : State → State → List Word
descendingFeed initial s =
    addW (nth 7 initial) (nth 7 s)
  ∷ addW (nth 6 initial) (nth 6 s)
  ∷ addW (nth 5 initial) (nth 5 s)
  ∷ addW (nth 4 initial) (nth 4 s)
  ∷ addW (nth 3 initial) (nth 3 s)
  ∷ addW (nth 2 initial) (nth 2 s)
  ∷ addW (nth 1 initial) (nth 1 s)
  ∷ addW (nth 0 initial) (nth 0 s) ∷ []

-- Shares s1/s2/s3. In particular the first element has NO reference to
-- the three future rounds or their message-schedule words.
demandedFeed : State → State → Round → Round → Round → List Word
demandedFeed initial s p q r =
  let s1 = roundStep s p
      s2 = roundStep s1 q
      s3 = roundStep s2 r
  in  addW (nth 7 initial) (nth 4 s)
    ∷ addW (nth 6 initial) (nth 4 s1)
    ∷ addW (nth 5 initial) (nth 4 s2)
    ∷ addW (nth 4 initial) (nth 4 s3)
    ∷ addW (nth 3 initial) (nth 0 s)
    ∷ addW (nth 2 initial) (nth 0 s1)
    ∷ addW (nth 1 initial) (nth 0 s2)
    ∷ addW (nth 0 initial) (nth 0 s3) ∷ []

-- Full vector equality, not just agreement of a sampled bit.
feed-descent : (initial s : State) (p q r : Round)
  → descendingFeed initial (after3 s p q r)
    ≡ demandedFeed initial s p q r
feed-descent initial s p q r i =
    addW (nth 7 initial) (h-after3 s p q r i)
  ∷ addW (nth 6 initial) (g-after3 s p q r i)
  ∷ addW (nth 5 initial) (f-after3 s p q r i)
  ∷ addW (nth 4 initial) (nth 4 (after3 s p q r))
  ∷ addW (nth 3 initial) (d-after3 s p q r i)
  ∷ addW (nth 2 initial) (c-after3 s p q r i)
  ∷ addW (nth 1 initial) (b-after3 s p q r i)
  ∷ addW (nth 0 initial) (nth 0 (after3 s p q r)) ∷ []

-- Pull the high-word predicate one more step back: the relevant output is
-- d + T1; the a-branch's T2 is not needed for this coordinate.
high-word-at60 : (initial s : State) (k w : Word) (p q r : Round)
  → addW (nth 7 initial)
      (nth 7 (after3 (roundStep s (k , w)) p q r))
    ≡ addW (nth 7 initial) (addW (nth 3 s) (T1of s k w))
high-word-at60 initial s k w p q r =
  cong (addW (nth 7 initial))
    (h-after3 (roundStep s (k , w)) p q r
     ∙ cong (nth 4) (roundStep-≡ s k w))

-- Exact Bitcoin comparison order inside a SHA word:
-- lowest byte first, but most-significant bit first WITHIN each byte.
wordComparisonBits : Word → List Bool
wordComparisonBits w =
    revL (takeN 8 w)
  ++ revL (takeN 8 (dropN 8 w))
  ++ revL (takeN 8 (dropN 16 w))
  ++ revL (takeN 8 (dropN 24 w))

data Ordering : Type₀ where
  below equal above : Ordering

compareBE : List Bool → List Bool → Ordering
compareBE [] [] = equal
compareBE [] (_ ∷ _) = below
compareBE (_ ∷ _) [] = above
compareBE (false ∷ xs) (true ∷ ys) = below
compareBE (true ∷ xs) (false ∷ ys) = above
compareBE (false ∷ xs) (false ∷ ys) = compareBE xs ys
compareBE (true ∷ xs) (true ∷ ys) = compareBE xs ys

-- Target words are supplied in the SAME storage representation as digest
-- words: eight SHA-endian words in reversed word order. For a numeric
-- big-endian target (t7,...,t0), supply (bswap32(t7),...,bswap32(t0)).
leWords : List Word → List Word → Bool
leWords [] _ = true
leWords (_ ∷ _) [] = false
leWords (x ∷ xs) (y ∷ ys) with compareBE (wordComparisonBits x) (wordComparisonBits y)
... | below = true
... | above = false
... | equal = leWords xs ys

-- Suffix-sensitive evaluation: postpone the final three rounds until their
-- coordinates are actually requested by the target comparison.
untilLast3 : State → State → List Round → List Word → Bool
untilLast3 initial s [] target = leWords (descendingFeed initial s) target
untilLast3 initial s (p ∷ []) target =
  leWords (descendingFeed initial (roundStep s p)) target
untilLast3 initial s (p ∷ q ∷ []) target =
  leWords (descendingFeed initial (after2 s p q)) target
untilLast3 initial s (p ∷ q ∷ r ∷ []) target =
  leWords (demandedFeed initial s p q r) target
untilLast3 initial s (p ∷ q ∷ r ∷ u ∷ rest) target =
  untilLast3 initial (roundStep s p) (q ∷ r ∷ u ∷ rest) target

untilLast3-exact : (initial s : State) (ps : List Round) (target : List Word)
  → untilLast3 initial s ps target
    ≡ leWords (descendingFeed initial (rounds s ps)) target
untilLast3-exact initial s [] target = refl
untilLast3-exact initial s (p ∷ []) target = refl
untilLast3-exact initial s (p ∷ q ∷ []) target = refl
untilLast3-exact initial s (p ∷ q ∷ r ∷ []) target =
  cong (λ ws → leWords ws target) (sym (feed-descent initial s p q r))
untilLast3-exact initial s (p ∷ q ∷ r ∷ u ∷ rest) target =
  untilLast3-exact initial (roundStep s p) (q ∷ r ∷ u ∷ rest) target

------------------------------------------------------------------------
-- Expose the last FOUR rounds as the existing unforced equation.
-- The source SHA uses sW to force both arithmetic branches for the Agda
-- evaluator. roundStep-≡ licenses replacing that forcing at this demand
-- boundary. The high digest half depends only on the four successive
-- e-register updates: no newly computed a-register / Sigma0 / Maj needed.
------------------------------------------------------------------------

open import EveryDigestIsExactly256BitsSoTheRealHashIsUnconditionallyANonEquivalence
  using (T2of)

roundLazy : State → Round → State
roundLazy s (k , w) =
  let t1 = T1of s k w
      t2 = T2of s k w
  in  addW t1 t2
    ∷ nth 0 s ∷ nth 1 s ∷ nth 2 s
    ∷ addW (nth 3 s) t1
    ∷ nth 4 s ∷ nth 5 s ∷ nth 6 s ∷ []

roundLazy-agrees : (s : State) (p : Round)
  → roundLazy s p ≡ roundStep s p
roundLazy-agrees s (k , w) = sym (roundStep-≡ s k w)

lazyRounds : State → List Round → State
lazyRounds = foldlL roundLazy

lazyRounds-agree : (s : State) (ps : List Round)
  → lazyRounds s ps ≡ rounds s ps
lazyRounds-agree s [] = refl
lazyRounds-agree s (p ∷ ps) =
  lazyRounds-agree (roundLazy s p) ps
  ∙ cong (λ st → rounds st ps) (roundLazy-agrees s p)

-- The first comparison at a four-round cut reduces directly to d + T1
-- of its FIRST round. There is no reference to p1, p2, p3 or T2of.
lazy-high-from-four : (initial s : State) (k w : Word) (p1 p2 p3 : Round)
  → nth 0 (descendingFeed initial
      (lazyRounds s ((k , w) ∷ p1 ∷ p2 ∷ p3 ∷ [])))
    ≡ addW (nth 7 initial) (addW (nth 3 s) (T1of s k w))
lazy-high-from-four initial s k w (k1 , w1) (k2 , w2) (k3 , w3) = refl

-- Each suffix of at most four rounds is exposed lazily. Earlier rounds
-- keep the repository's existing force/share discipline unchanged.
untilLast4 : State → State → List Round → List Word → Bool
untilLast4 initial s [] target = leWords (descendingFeed initial s) target
untilLast4 initial s (p ∷ []) target =
  leWords (descendingFeed initial (lazyRounds s (p ∷ []))) target
untilLast4 initial s (p ∷ q ∷ []) target =
  leWords (descendingFeed initial (lazyRounds s (p ∷ q ∷ []))) target
untilLast4 initial s (p ∷ q ∷ r ∷ []) target =
  leWords (descendingFeed initial (lazyRounds s (p ∷ q ∷ r ∷ []))) target
untilLast4 initial s (p ∷ q ∷ r ∷ u ∷ []) target =
  leWords (descendingFeed initial (lazyRounds s (p ∷ q ∷ r ∷ u ∷ []))) target
untilLast4 initial s (p ∷ q ∷ r ∷ u ∷ v ∷ rest) target =
  untilLast4 initial (roundStep s p) (q ∷ r ∷ u ∷ v ∷ rest) target

untilLast4-exact : (initial s : State) (ps : List Round) (target : List Word)
  → untilLast4 initial s ps target
    ≡ leWords (descendingFeed initial (rounds s ps)) target
untilLast4-exact initial s [] target = refl
untilLast4-exact initial s (p ∷ []) target =
  cong (λ st → leWords (descendingFeed initial st) target)
       (lazyRounds-agree s (p ∷ []))
untilLast4-exact initial s (p ∷ q ∷ []) target =
  cong (λ st → leWords (descendingFeed initial st) target)
       (lazyRounds-agree s (p ∷ q ∷ []))
untilLast4-exact initial s (p ∷ q ∷ r ∷ []) target =
  cong (λ st → leWords (descendingFeed initial st) target)
       (lazyRounds-agree s (p ∷ q ∷ r ∷ []))
untilLast4-exact initial s (p ∷ q ∷ r ∷ u ∷ []) target =
  cong (λ st → leWords (descendingFeed initial st) target)
       (lazyRounds-agree s (p ∷ q ∷ r ∷ u ∷ []))
untilLast4-exact initial s (p ∷ q ∷ r ∷ u ∷ v ∷ rest) target =
  untilLast4-exact initial (roundStep s p) (q ∷ r ∷ u ∷ v ∷ rest) target
