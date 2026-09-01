{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Sha256Parimana — every digest is exactly 256 bits, for EVERY message,
-- so the real hash is unconditionally a non-equivalence.
--
-- Sha256Sesa fenced this off: "¬ isEquiv sha256 is not asserted: the
-- honest routes are a length invariant through the pipeline (unwritten)
-- or an exhibited collision (open)."  This module walks the first
-- route.  The invariant: every word the pipeline carries has 32 bits —
-- through addition (a ripple-carry keeps its first argument's length),
-- through nth (the default zeroW is itself 32 bits, so no bound on the
-- index is ever needed), through the strictness binder (sW-β says it is
-- invisible), through all 64 rounds, all blocks, and the final flatten.
--
--   परिमाणम्   : (m : List Bool) → length (sha256 m) ≡ 256
--   न-तुल्यता  : ¬ isEquiv sha256
--
-- The second is the first spent once: an equivalence would inhabit the
-- fibre over the empty digest, whose preimage's digest has 256 ≡ 0.
-- With it, Sesa's "a one-way function is exactly a non-equivalence" is
-- instantiated at the real hash UNCONDITIONALLY — no collision needed,
-- none exhibited.  (The fence stands for the sharper fact: ¬ injective
-- sha256 on any compressing restriction is forced by pigeonhole and
-- exhibiting it is the open problem.  Non-equivalence needed only the
-- codomain's slack, and takes it.)
--
-- CHECKED: Agda 2.8.0, --cubical --safe, through scripts/oracle.
------------------------------------------------------------------------

module Sha256Parimana_EveryDigestIsExactly256BitsSoTheRealHashIsUnconditionallyANonEquivalence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv ; equiv-proof)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-zero ; +-assoc ; snotz ; znots ; injSuc)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; length ; map)
open import Cubical.Data.List.Properties using (length++)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using ()
open import Cubical.Relation.Nullary using (¬_)

open import Sha256
open import Sha256Sesa_TheCompletionInvertsTheRealHashFreelyAndAnInverterOfTheLossyProjectionIsExactlyCollisionFreedom
  using (sW-β ; forceWs-β)

------------------------------------------------------------------------
-- §1  Word-level lengths.
------------------------------------------------------------------------

length-fromℕ : (w n : ℕ) → length (fromℕ w n) ≡ w
length-fromℕ zero    n = refl
length-fromℕ (suc w) n = cong suc (length-fromℕ w (half n))

length-zeroW : length zeroW ≡ 32
length-zeroW = length-fromℕ 32 0

-- ripple-carry addition returns its first argument's length, always
length-addC : (c : Bool) (u v : Word) → length (addC c u v) ≡ length u
length-addC c []       _        = refl
length-addC c (a ∷ as) []       = cong suc (length-addC (and2 a c) as [])
length-addC c (a ∷ as) (b ∷ bs) = cong suc (length-addC _ as bs)

length-addW : (u v : Word) → length (addW u v) ≡ length u
length-addW = length-addC false

-- reversal preserves length (revGo, with the accumulator generalized)
+-suc′ : (m n : ℕ) → m + suc n ≡ suc (m + n)
+-suc′ zero    n = refl
+-suc′ (suc m) n = cong suc (+-suc′ m n)

length-revGo : {A : Type} (acc xs : List A)
             → length (revGo acc xs) ≡ length xs + length acc
length-revGo acc []       = refl
length-revGo acc (x ∷ xs) =
  length-revGo (x ∷ acc) xs ∙ +-suc′ (length xs) (length acc)

length-revL : {A : Type} (xs : List A) → length (revL xs) ≡ length xs
length-revL xs = length-revGo [] xs ∙ +-zero (length xs)

------------------------------------------------------------------------
-- §2  The invariant: every carried word has 32 bits.
------------------------------------------------------------------------

All32 : List Word → Type
All32 []       = Unit
All32 (w ∷ ws) = (length w ≡ 32) × All32 ws

-- nth never needs a bound: the default zeroW is itself 32 bits
length-nth : (i : ℕ) (st : List Word) → All32 st → length (nth i st) ≡ 32
length-nth i       []       _  = length-zeroW
length-nth zero    (w ∷ ws) a  = fst a
length-nth (suc i) (w ∷ ws) a  = length-nth i ws (snd a)

GoodState : List Word → Type
GoodState st = (length st ≡ 8) × All32 st

------------------------------------------------------------------------
-- §3  One round.  sW is unfolded by its own invisibility theorem, and
--     the literal eight-word state is measured componentwise.
------------------------------------------------------------------------

T1of T2of : List Word → Word → Word → Word
T1of st k w =
  addW (nth 7 st)
    (addW (Σ1 (nth 4 st))
      (addW (ch (nth 4 st) (nth 5 st) (nth 6 st)) (addW k w)))
T2of st k w =
  addW (Σ0 (nth 0 st)) (maj (nth 0 st) (nth 1 st) (nth 2 st))

roundStep-≡ : (st : List Word) (k w : Word)
  → roundStep st (k , w)
  ≡ ( addW (T1of st k w) (T2of st k w)
    ∷ nth 0 st ∷ nth 1 st ∷ nth 2 st
    ∷ addW (nth 3 st) (T1of st k w)
    ∷ nth 4 st ∷ nth 5 st ∷ nth 6 st ∷ [] )
roundStep-≡ st k w =
  sW-β (T1of st k w) _
  ∙ sW-β (T2of st k w) _
  ∙ sW-β (addW (T1of st k w) (T2of st k w)) _
  ∙ sW-β (addW (nth 3 st) (T1of st k w)) _

roundStep-good : (st : List Word) (k w : Word)
               → All32 st → GoodState (roundStep st (k , w))
roundStep-good st k w a =
  subst GoodState (sym (roundStep-≡ st k w))
    ( refl
    , (length-addW (T1of st k w) (T2of st k w) ∙ len-T1)
    , length-nth 0 st a , length-nth 1 st a , length-nth 2 st a
    , (length-addW (nth 3 st) (T1of st k w) ∙ length-nth 3 st a)
    , length-nth 4 st a , length-nth 5 st a , length-nth 6 st a
    , tt )
  where
    len-T1 : length (T1of st k w) ≡ 32
    len-T1 =
      length-addW (nth 7 st)
        (addW (Σ1 (nth 4 st))
          (addW (ch (nth 4 st) (nth 5 st) (nth 6 st)) (addW k w)))
      ∙ length-nth 7 st a

------------------------------------------------------------------------
-- §4  The folds preserve the invariant.
------------------------------------------------------------------------

foldl-rounds-good : (ps : List (Word × Word)) (st : List Word)
                  → GoodState st → GoodState (foldlL roundStep st ps)
foldl-rounds-good []             st g = g
foldl-rounds-good ((k , w) ∷ ps) st g =
  foldl-rounds-good ps (roundStep st (k , w)) (roundStep-good st k w (snd g))

zip-addW-good : (u v : List Word) → All32 u → length u ≡ length v
              → (length (zipL addW u v) ≡ length u) × All32 (zipL addW u v)
zip-addW-good []       []       a p = refl , tt
zip-addW-good []       (y ∷ ys) a p = Empty.rec (znots p)
zip-addW-good (x ∷ xs) []       a p = Empty.rec (snotz p)
zip-addW-good (x ∷ xs) (y ∷ ys) a p =
  cong suc (fst rest) , (length-addW x y ∙ fst a) , snd rest
  where rest = zip-addW-good xs ys (snd a) (injSuc p)

compress-good : (H : List Word) (b : List Bool)
              → GoodState H → GoodState (compress H b)
compress-good H b g =
  subst GoodState (sym (forceWs-β H _)) inner
  where
    rounds = foldlL roundStep H (zipL _,_ K (schedule b))
    inner : GoodState (zipL addW H rounds)
    inner =
      let zg = zip-addW-good H rounds (snd g)
                 (fst g ∙ sym (fst (foldl-rounds-good (zipL _,_ K (schedule b)) H g)))
      in  (fst zg ∙ fst g) , snd zg

H0-good : GoodState H0
H0-good = refl
  , length-fromℕ 32 0x6a09e667 , length-fromℕ 32 0xbb67ae85
  , length-fromℕ 32 0x3c6ef372 , length-fromℕ 32 0xa54ff53a
  , length-fromℕ 32 0x510e527f , length-fromℕ 32 0x9b05688c
  , length-fromℕ 32 0x1f83d9ab , length-fromℕ 32 0x5be0cd19 , tt

sha256ws-good : (m : List Bool) → GoodState (sha256ws m)
sha256ws-good m = go (blocks (suc (length (pad m))) (pad m)) H0 H0-good
  where
    go : (bs : List (List Bool)) (H : List Word)
       → GoodState H → GoodState (foldlL compress H bs)
    go []       H g = g
    go (b ∷ bs) H g = go bs (compress H b) (compress-good H b g)

------------------------------------------------------------------------
-- §5  परिमाणम् — the digest is exactly 256 bits, for every message.
------------------------------------------------------------------------

-- 32 bits per word, spelled as a recursion so 8 words compute to 256
भारः : ℕ → ℕ
भारः zero    = zero
भारः (suc n) = 32 + भारः n

flat-len : (ws : List Word) (acc : List Bool) → All32 ws
         → length (foldlL (λ a w → a ++ revL w) acc ws)
         ≡ length acc + भारः (length ws)
flat-len []       acc a = sym (+-zero (length acc))
flat-len (w ∷ ws) acc a =
  flat-len ws (acc ++ revL w) (snd a)
  ∙ cong (_+ भारः (length ws))
      (length++ acc (revL w) ∙ cong (length acc +_) (length-revL w ∙ fst a))
  ∙ sym (+-assoc (length acc) 32 (भारः (length ws)))

परिमाणम् : (m : List Bool) → length (sha256 m) ≡ 256
परिमाणम् m =
  flat-len (sha256ws m) [] (snd (sha256ws-good m))
  ∙ cong भारः (fst (sha256ws-good m))

------------------------------------------------------------------------
-- §6  न-तुल्यता — the real hash is unconditionally a non-equivalence.
--     An equivalence inhabits every fibre; the fibre over the empty
--     digest would hand over a message whose 256 bits are 0 of them.
--     Sesa's "one-way ⟺ non-equivalence", landed on SHA-256 with no
--     collision anywhere in the proof.
------------------------------------------------------------------------

न-तुल्यता : ¬ isEquiv sha256
न-तुल्यता e = snotz (sym (परिमाणम् m) ∙ cong length p)
  where
    m = e .equiv-proof [] .fst .fst
    p : sha256 m ≡ []
    p = e .equiv-proof [] .fst .snd
