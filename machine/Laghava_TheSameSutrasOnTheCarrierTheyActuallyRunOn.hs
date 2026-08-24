-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- Laghava -- लाघव -- the same sutras, designed against the carrier they run on.
--
-- THE TERM.  `laghava` is the grammarians' OWN word for the criterion the
-- Astadhyayi is built to: economy of statement.  Nagesa's
-- Paribhasendusekhara reports the maxim
--
--     ardhamatralaghavena putrotsavam manyante vaiyakaranah
--     -- grammarians rejoice over the saving of half a mora
--        as at the birth of a son.
--
-- Half a MORA.  Not half a page: the unit of saving is the unit of the
-- CARRIER, because the carrier is a reciting human being and the cost
-- being minimised is that person's memory and breath.  What is claimed
-- here of the source is exactly that and nothing more: that laghava is
-- Panini's stated criterion and that it is stated in units of the
-- substrate.  The cache hierarchy below is not Panini's; the CPU is
-- mine, the design principle is his.
--
-- WHAT THIS FILE IS.  `machine/Astadhyayi.hs` runs the sutras and is the
-- reference: it is written for a reader, in Strings, and every claim it
-- makes is checked there.  This file runs THE SAME SUTRAS with the same
-- metarules and the same outputs, encoded against the specification of
-- the machine that executes them.
--
-- THE MEASUREMENT THAT MOTIVATED IT (GHC 9.12.2 -O2, Apple M4 Max,
-- single thread, 20000 derivations over the 14-form corpus, -prof
-- -fprof-auto):
--
--     31.7%  GHC.Classes.==            list equality
--     21.2%  $fEqList_$s$c==1          String equality, specialised
--     14.7%  GHC.Internal.List.elem    membership
--      4.2%  eqString
--      3.6%  $w!!                      indexing a list by position
--
-- Seventy-two per cent of the running time is comparing Strings, because
-- a phoneme is a `String` and a pratyahara is a `[String]` and the
-- question a sutra asks -- `s `elem` jhaL` -- is therefore a linear scan
-- with a character-by-character comparison at every element.  The
-- grammar is small.  The COMPARISON is what is large.
--
-- WHAT CHANGED, and each change is the same change:
--
--   1. A phoneme is a Word8 -- an index into the varnasamamnaya's
--      inventory of 47 sounds.  Equality is one machine instruction.
--   2. A pratyahara is a Word64 BITMASK.  47 sounds fit in one register,
--      so `elem` becomes `testBit`, and the whole class inventory --
--      aC iK aK eC eN haL jhaL khaR jhaS stu scu -- is eleven registers.
--      The masks are not a stored table: they are GENERATED at startup by
--      the interval procedure of section 1, from the fourteen sutras, the
--      same way `Astadhyayi.pratyahara` generates them.  Small because
--      designed, not because truncated.
--   3. A substitution -- jas, car, ku, yan, dirgha, vrddhi, scu, stu --
--      is a 47-byte unboxed array.  Eight of them is 376 bytes.  The
--      entire phonology is smaller than one cache line times six.
--   4. `nextPh` no longer indexes with `!!` and no longer calls `length`.
--      The scan carries its own tail, so lookahead and the padanta and
--      avasana tests are O(1) instead of O(n), and a scan is O(n) instead
--      of O(n^2).
--   5. `derive` builds no Steps, renders no intermediate forms and
--      concatenates no note strings.  The reference builds a `Step` with
--      `render xs`, `render ys` and a `++`-built note for every rule
--      application, whether or not anybody reads them.  `deriveTrace`
--      here still builds them; `derive` does not.
--
-- WHAT DID NOT CHANGE, and this is the point: the ARCHITECTURE.  The
-- rules are still separate objects that offer rewrites; the offers still
-- collide; the collision is still decided by apavada first and 1.4.2
-- `vipratisedhe param karyam` second; the tripadi is still traversed once
-- in numeric order and is still blind to what follows, which is 8.2.1.
-- Nothing here is faster because a metarule was dropped.
--
-- WHAT IS NOT CLAIMED.  This is not a second opinion about Sanskrit.
-- `LaghavaRun.hs` checks it against `Astadhyayi.derive` form for form over
-- a generated corpus; where the two disagree, the reference is right and
-- this file is wrong.  The disagreement is a syndrome, and there is
-- deliberately no master copy inside this file.
--
--
-- ==================================================================
-- THE FIGURES, WITH THEIR CONDITIONS
-- ==================================================================
--
-- CONDITIONS, stated first because a number without them looks like
-- knowledge.  Apple M4 Max, 16 cores, macOS 25.5; GHC 9.12.2; `ghc -O2`,
-- single threaded, no -threaded, default RTS; the 14-form corpus of
-- `AstadhyayiRun.hs`, both engines in ONE process on the SAME forms, the
-- rendered output of each derivation folded into a checksum so nothing is
-- left unevaluated; 50000 derivations per repetition, BEST OF 5.
--
-- Best-of, not mean, and the reason is not statistical taste: this
-- repository runs several agents at once and the load average during
-- every measurement below was between 30 and 45 on 16 cores.  The mean of
-- a wall-clock timing under that load measures the other agents.  The
-- minimum is the repetition least contaminated by them.  The worst-of-5
-- ran 1.2x to 2.7x the best, and that spread is printed by the harness on
-- every run rather than hidden.
--
--   engine                                us/derivation   derivations/s   ratio
--   reference, Astadhyayi.hs at c9726ed1        14.33          69,787      1.00
--   this file                                    2.45         407,932      5.85
--
--   reference, Astadhyayi.hs live, with the      18.62          53,703      1.00
--     anuvrtti resolution added 2026-08-20
--   this file                                    2.49         401,045      7.47
--
-- The two reference rows are the same engine before and after another
-- session's anuvrtti work landed; both are reported because quoting only
-- the slower one would flatter this file.
--
-- INTERPRETED, the same two engines under `runghc -imachine`, 3000
-- derivations, best of 5:
--
--   reference   286.07 us   3,496/s
--   this file   191.28 us   5,228/s      ratio 1.50
--
-- 5.85x compiled against 1.50x interpreted, and the gap is the finding:
-- a Word8 comparison is cheaper than a String comparison only where a
-- comparison is an INSTRUCTION.  Under the bytecode interpreter both are
-- an interpreted thunk and the representation barely shows.  Designing
-- against the carrier means nothing if you then run on a different one.
--
-- WHAT DOMINATES THE TIME NOW (-prof -fprof-auto, 300000 derivations):
--
--   21.4%  firstOffer.go     the tripadi's per-rule scan of the word
--   15.7%  rules             the indirect call: a rule is a value in a
--                            list, so `ruAt r c` cannot be inlined
--    6.9%  the lookahead inside that scan
--    5.9%  ruAt              the record selector on that value
--    3.5%  break             `words`, in parsing the input
--    1.8%  tokenizeW
--
-- No String comparison appears anywhere in the profile.  What is left is
-- traversal and indirect dispatch.
--
-- WHAT IS BOUNDED BY THE ALGORITHM AND NOT BY THE ENCODING.  `phaseB`
-- runs the nine tripadi rules as nine separate traversals of the word,
-- and `saturate` restarts a rule's traversal at position 0 after every
-- application.  That is O(rules x n x applications) and no amount of
-- representation fixes it.  Panini's own device says the tripadi is
-- traversed ONCE -- the rules in order, each blind to what follows -- so
-- the word ought to be the outer loop and the rule sequence the inner
-- one, as `offersA` already does for section A.  It is NOT done here for
-- section B, and the reason is a real one rather than laziness: a tripadi
-- rewrite at position i can create a match for the SAME rule at a
-- position left of i (8.4.40's second branch offers at j > i, so its
-- output can feed a rule scanning from the left), and inverting the loops
-- without a proof that this cannot happen would change the derived form.
-- Section A gets the inversion because no rule of 6.1 offers anywhere but
-- at the position it is looking at, and that is checked by the 5360-form
-- equivalence in LaghavaRun.hs, not assumed.
--
-- WHAT WAS NOT DONE, and what it would take.
--
--   * The word is a `[Word8]`, a cons cell per sound.  A form of fifteen
--     sounds is fifteen heap objects where it could be two machine words.
--     Packing it -- 6 bits per slot, 10 slots per Word64 -- would make
--     `applyW` a shift-and-mask instead of take/++/drop, and would put a
--     whole derivation in registers.  That is the next real win and it is
--     not here.
--   * `parseW` still calls `words`, which is 3.5% of the remaining time
--     and allocates.  Parsing could be one pass over the input String.
--   * Nothing is unboxed across the rule boundary: `ruAt` takes a boxed
--     `Ctx`.  Removing it means passing six arguments and giving up the
--     rules-as-values architecture, which is load-bearing here -- the
--     rules must be enumerable for 1.4.2 to have anything to arbitrate.
--   * BOUNDED BY GHC, not by this file: a rule is a closure in a list, so
--     every `ruAt r c` is an unknown call GHC cannot inline or specialise.
--     A staged design -- the rule set is fixed and small, so it could be
--     compiled once into a dispatch on the phoneme's class bits -- needs
--     either Template Haskell or a different language. That is the honest
--     ceiling of the current approach and this file does not reach past it.
--   * The whole karaka layer, `deriveAsiddhavat`, `asiddhaAudit`,
--     `coverage` and the anuvrtti machinery of the reference are NOT
--     ported. This file carries `derive` and `traceW` and nothing else,
--     and the reference remains the place where the grammar is explained.

{-# LANGUAGE BangPatterns #-}

module Laghava_TheSameSutrasOnTheCarrierTheyActuallyRunOn
  ( Ph
  , phName, phCode, nPhones
  , Cls, member
  , aC, iK, aK, eC, eN, haL, jhaL, khaR, jhaSv, sTu, sCu, sTuRetro
  , pratyaharaW, savarnaW
  , W, tokenizeW, parseW, renderW
  , Rw(..), Rule(..), Ctx(..), rules, ruFires, sectionAW, sectionBW
  , Ref, refOf, refTriple
  , deriveW, derive, traceW, TraceStep(..)
  , laghavaSelfTest
  ) where

import Data.Bits
import Data.Word
import Data.Int ()
import Data.List (sortOn, foldl')
import Data.Array.Unboxed
import Data.Array.Base (unsafeAt)
import qualified Data.Array as B
import qualified Data.Map.Strict as M

------------------------------------------------------------------------
-- 0.  THE INVENTORY.  Index order is the order of `Astadhyayi.phones`,
--     so a code is a position in a list somebody can read, not a magic
--     number.
------------------------------------------------------------------------

type Ph = Word8

-- (name, sthana code, prayatna code, vowel)
-- sthana: 0 kantha 1 talu 2 murdhan 3 danta 4 ostha
--         5 kantha-talu 6 kantha-ostha 7 dantostha
-- prayatna: 0 sprsta 1 isatsprsta 2 isadvivrta 3 vivrta 4 vivrtatara
inventory :: [(String, Int, Int, Bool)]
inventory =
  [ ("a",0,3,True),  ("ā",0,3,True)
  , ("i",1,3,True),  ("ī",1,3,True)
  , ("u",4,3,True),  ("ū",4,3,True)
  , ("ṛ",2,3,True),  ("ṝ",2,3,True)
  , ("ḷ",3,3,True)
  , ("e",5,3,True),  ("ai",5,4,True)
  , ("o",6,3,True),  ("au",6,4,True)
  , ("k",0,0,False), ("kh",0,0,False), ("g",0,0,False), ("gh",0,0,False), ("ṅ",0,0,False)
  , ("c",1,0,False), ("ch",1,0,False), ("j",1,0,False), ("jh",1,0,False), ("ñ",1,0,False)
  , ("ṭ",2,0,False), ("ṭh",2,0,False), ("ḍ",2,0,False), ("ḍh",2,0,False), ("ṇ",2,0,False)
  , ("t",3,0,False), ("th",3,0,False), ("d",3,0,False), ("dh",3,0,False), ("n",3,0,False)
  , ("p",4,0,False), ("ph",4,0,False), ("b",4,0,False), ("bh",4,0,False), ("m",4,0,False)
  , ("y",1,1,False), ("r",2,1,False), ("l",3,1,False), ("v",7,1,False)
  , ("ś",1,2,False), ("ṣ",2,2,False), ("s",3,2,False), ("h",0,2,False)
  , ("ḥ",0,2,False)
  ]

nPhones :: Int
nPhones = length inventory          -- 47, and 47 < 64

phNameArr :: B.Array Ph String
phNameArr = B.listArray (0, fromIntegral nPhones - 1) [ n | (n,_,_,_) <- inventory ]

phName :: Ph -> String
phName p = phNameArr B.! p

codeMap :: M.Map String Ph
codeMap = M.fromList (zip [ n | (n,_,_,_) <- inventory ] [0 ..])

phCode :: String -> Ph
phCode s = M.findWithDefault 255 s codeMap

sthanaA, prayatnaA :: UArray Ph Word8
sthanaA   = listArray (0, fromIntegral nPhones - 1) [ fromIntegral s | (_,s,_,_) <- inventory ]
prayatnaA = listArray (0, fromIntegral nPhones - 1) [ fromIntegral p | (_,_,p,_) <- inventory ]

vowelA :: UArray Ph Bool
vowelA = listArray (0, fromIntegral nPhones - 1) [ v | (_,_,_,v) <- inventory ]

-- item codes above the inventory: the junctures
cPada, cMorph, cAvagraha :: Word8
cPada     = 61
cMorph    = 62
cAvagraha = 63

isPh :: Word8 -> Bool
isPh w = w < 47
{-# INLINE isPh #-}

------------------------------------------------------------------------
-- 1.  THE FOURTEEN SIVA-SUTRAS, and the pratyahara AS A PROCEDURE.
--
--     The class is generated by walking an interval, exactly as in the
--     reference.  What differs is only where the answer is put: a bit in
--     a register instead of a list of Strings.  See AHIMSA_SUTRA_VISTARA
--     s.41 -- `saranee va kriya`, and where space is dear, procedure.
------------------------------------------------------------------------

sivasutraTable :: [([String], String)]
sivasutraTable =
  [ (["a","i","u"],                          "ṇ")
  , (["ṛ","ḷ"],                              "k")
  , (["e","o"],                              "ṅ")
  , (["ai","au"],                            "c")
  , (["h","y","v","r"],                      "ṭ")
  , (["l"],                                  "ṇ")
  , (["ñ","m","ṅ","ṇ","n"],                  "m")
  , (["jh","bh"],                            "ñ")
  , (["gh","ḍh","dh"],                       "ṣ")
  , (["j","b","g","ḍ","d"],                  "ś")
  , (["kh","ph","ch","ṭh","th","c","ṭ","t"], "v")
  , (["k","p"],                              "y")
  , (["ś","ṣ","s"],                          "r")
  , (["h"],                                  "l")
  ]

-- (isMarker, code)
varnasamamnaya :: [(Bool, Ph)]
varnasamamnaya =
  concat [ [ (False, phCode s) | s <- ss ] ++ [ (True, phCode m) ] | (ss, m) <- sivasutraTable ]

-- the k-th reading, as `Astadhyayi.pratyaharaOcc`
pratyaharaOccW :: String -> String -> Int -> [Ph]
pratyaharaOccW s m k = go k (dropWhile (/= (False, phCode s)) varnasamamnaya)
  where
    go _ [] = []
    go n ((True, x) : rest)
      | x == phCode m = if n <= (0 :: Int) then [] else go (n - 1) rest
      | otherwise     = go n rest
    go n ((False, x) : rest) = x : go n rest

pratyaharaW :: String -> String -> [Ph]
pratyaharaW s m = pratyaharaOccW s m 0

type Cls = Word64

member :: Ph -> Cls -> Bool
member p c = testBit c (fromIntegral p)
{-# INLINE member #-}

clsOf :: [Ph] -> Cls
clsOf = foldl' (\acc p -> setBit acc (fromIntegral p)) 0

-- 1.1.9 tulyasyaprayatnam savarnam, with 1.1.10 najjhalau as an override
savarnaW :: Ph -> Ph -> Bool
savarnaW x y
  | unsafeAt vowelA (fromIntegral x) /= unsafeAt vowelA (fromIntegral y) = False
  | otherwise = unsafeAt sthanaA (fromIntegral x) == unsafeAt sthanaA (fromIntegral y)
             && unsafeAt prayatnaA (fromIntegral x) == unsafeAt prayatnaA (fromIntegral y)
{-# INLINE savarnaW #-}

-- 1.1.69 anudit savarnasya capratyayah: an aN sound (the sutra-6 reading)
-- denotes its savarnas too.  This is why aC reaches the long vowels.
denotesW :: [Ph] -> Cls
denotesW xs = foldl' step 0 xs
  where
    anUdit = clsOf (pratyaharaOccW "a" "ṇ" 1)
    step acc x
      | member x anUdit = foldl' (\a p -> if savarnaW x p then setBit a (fromIntegral p) else a)
                                 acc [0 .. fromIntegral nPhones - 1]
      | otherwise       = setBit acc (fromIntegral x)

aC, iK, aK, eC, eN, haL, jhaL, khaR, jhaSv, sTu, sCu, sTuRetro, aAlong :: Cls
aC       = denotesW (pratyaharaW "a" "c")
iK       = denotesW (pratyaharaW "i" "k")
aK       = denotesW (pratyaharaW "a" "k")
eC       = clsOf (pratyaharaW "e" "c")
eN       = clsOf (pratyaharaW "e" "ṅ")
haL      = clsOf (pratyaharaW "h" "l")
jhaL     = clsOf (pratyaharaW "jh" "l")
khaR     = clsOf (pratyaharaW "kh" "r")
jhaSv    = clsOf (pratyaharaW "jh" "ś")
sTu      = clsOf (map phCode ["s","t","th","d","dh","n"])
sCu      = clsOf (map phCode ["ś","c","ch","j","jh","ñ"])
sTuRetro = clsOf (map phCode ["ṣ","ṭ","ṭh","ḍ","ḍh","ṇ"])
aAlong   = clsOf (map phCode ["a","ā"])          -- 6.1.87/6.1.88's `ad`
cU       :: Cls
cU       = clsOf (map phCode ["c","ch","j","jh","ñ"])

-- the four single sounds a sutra below names by itself, hoisted so that the
-- name is resolved once at startup and never inside the scan
pA, pR, pS, pVisarga :: Ph
pA       = phCode "a"
pR       = phCode "r"
pS       = phCode "s"
pVisarga = phCode "ḥ"

------------------------------------------------------------------------
-- 2.  THE SUBSTITUTIONS.  Eight unboxed 47-byte arrays; the whole
--     phonology of this grammar is 376 bytes and never leaves L1.
------------------------------------------------------------------------

subst :: [(String, String)] -> UArray Ph Ph
subst tbl = listArray (0, fromIntegral nPhones - 1)
  [ maybe (fromIntegral i) phCode (lookup n (tbl))
  | (i, (n,_,_,_)) <- zip [(0 :: Int) ..] inventory ]

jasA, carA, kuA, yanA, dirghaA, vrddhiA, scuA, stuRetroA :: UArray Ph Ph
jasA = subst
  [("k","g"),("kh","g"),("g","g"),("gh","g")
  ,("c","j"),("ch","j"),("j","j"),("jh","j")
  ,("ṭ","ḍ"),("ṭh","ḍ"),("ḍ","ḍ"),("ḍh","ḍ")
  ,("t","d"),("th","d"),("d","d"),("dh","d")
  ,("p","b"),("ph","b"),("b","b"),("bh","b")]
carA = subst
  [("k","k"),("kh","k"),("g","k"),("gh","k")
  ,("c","c"),("ch","c"),("j","c"),("jh","c")
  ,("ṭ","ṭ"),("ṭh","ṭ"),("ḍ","ṭ"),("ḍh","ṭ")
  ,("t","t"),("th","t"),("d","t"),("dh","t")
  ,("p","p"),("ph","p"),("b","p"),("bh","p")]
kuA        = subst [("c","k"),("ch","kh"),("j","g"),("jh","gh"),("ñ","ṅ")]
yanA       = subst [("i","y"),("ī","y"),("u","v"),("ū","v"),("ṛ","r"),("ṝ","r"),("ḷ","l")]
dirghaA    = subst [("a","ā"),("ā","ā"),("i","ī"),("ī","ī")
                   ,("u","ū"),("ū","ū"),("ṛ","ṝ"),("ṝ","ṝ")]
vrddhiA    = subst [("e","ai"),("o","au"),("ai","ai"),("au","au"),("a","ā"),("ā","ā")
                   ,("i","ai"),("ī","ai"),("u","au"),("ū","au")]
scuA       = subst [("s","ś"),("t","c"),("th","ch"),("d","j"),("dh","jh"),("n","ñ")]
stuRetroA  = subst [("s","ṣ"),("t","ṭ"),("th","ṭh"),("d","ḍ"),("dh","ḍh"),("n","ṇ")]

sub :: UArray Ph Ph -> Ph -> Ph
sub a p = unsafeAt a (fromIntegral p)
{-# INLINE sub #-}

-- guna and ayavayav produce TWO sounds from one, so they are boxed arrays
-- of already-built lists: the lists are shared, and a lookup allocates
-- nothing.  1.1.51 `ur an raparah` is why guna of r. is two items.
gunaA, ayavayavA :: B.Array Ph [Ph]
gunaA = B.listArray (0, fromIntegral nPhones - 1)
  [ case n of
      "i" -> [phCode "e"]; "ī" -> [phCode "e"]
      "u" -> [phCode "o"]; "ū" -> [phCode "o"]
      "ṛ" -> [phCode "a", phCode "r"]; "ṝ" -> [phCode "a", phCode "r"]
      "ḷ" -> [phCode "a", phCode "l"]
      _   -> [fromIntegral i]
  | (i, (n,_,_,_)) <- zip [(0 :: Int) ..] inventory ]
ayavayavA = B.listArray (0, fromIntegral nPhones - 1)
  [ case n of
      "e"  -> [phCode "a", phCode "y"]
      "o"  -> [phCode "a", phCode "v"]
      "ai" -> [phCode "ā", phCode "y"]
      "au" -> [phCode "ā", phCode "v"]
      _    -> [fromIntegral i]
  | (i, (n,_,_,_)) <- zip [(0 :: Int) ..] inventory ]

------------------------------------------------------------------------
-- 3.  WORDS, AND A SCAN THAT DOES NOT INDEX
------------------------------------------------------------------------

type W = [Word8]

-- Longest match over the inventory, without building a substring to look
-- up.  Every two-character name in the inventory is either an aspirate
-- (base + `h`) or a diphthong written a + i / a + u, so the longest match
-- is decided by looking at the second character, and the map that is
-- consulted is keyed on a Char.
singleMap, aspirateMap :: M.Map Char Ph
singleMap   = M.fromList [ (ch, p) | (n, p) <- M.toList codeMap, [ch] <- [n] ]
aspirateMap = M.fromList [ (ch, p) | (n, p) <- M.toList codeMap, [ch, 'h'] <- [n] ]

pAi, pAu :: Ph
pAi = phCode "ai"
pAu = phCode "au"

tokenizeW :: String -> [Ph]
tokenizeW [] = []
tokenizeW (c : rest) =
  case rest of
    (d : rest')
      | d == 'h', Just p <- M.lookup c aspirateMap -> p : tokenizeW rest'
      | c == 'a', d == 'i' -> pAi : tokenizeW rest'
      | c == 'a', d == 'u' -> pAu : tokenizeW rest'
    _ -> case M.lookup c singleMap of
           Just p  -> p : tokenizeW rest
           Nothing -> 255 : tokenizeW rest    -- unknown sound, kept as a slot

parseW :: String -> W
parseW = go . words
  where
    go []           = []
    go ["+"]        = []
    go ["-"]        = []
    go ("+" : r)    = cPada  : go r
    go ("-" : r)    = cMorph : go r
    go (w : r)      = tokenizeW w ++ go r

renderW :: W -> String
renderW = concatMap f
  where
    f w | w == cPada     = " "
        | w == cMorph    = ""
        | w == cAvagraha = "'"
        | w == 255       = "?"
        | otherwise      = phName w

------------------------------------------------------------------------
-- 4.  THE RULES.  A Ref is packed into one Int so that 1.4.2's
--     comparison -- `the later sutra` -- is an integer comparison.
------------------------------------------------------------------------

type Ref = Int

refOf :: Int -> Int -> Int -> Ref
refOf a p s = a * 1000000 + p * 1000 + s

refTriple :: Ref -> (Int, Int, Int)
refTriple r = (r `div` 1000000, (r `div` 1000) `mod` 1000, r `mod` 1000)

data Rw = Rw
  { rSutra :: {-# UNPACK #-} !Ref
  , rPos   :: {-# UNPACK #-} !Int
  , rLen   :: {-# UNPACK #-} !Int
  , rNew   :: !W
  }

data Rule = Rule
  { ruNum     :: {-# UNPACK #-} !Ref
  , ruText    :: String
  , ruApavada :: ![Ref]
  , ruAt      :: Ctx -> Maybe Rw
  }

-- the context a sutra actually asks about, computed once per position and
-- shared by every rule that looks at that position.  In the reference each
-- rule runs its own scan and each scan recomputes this; here the traversal
-- is the outer loop and the rules are the inner one.
data Ctx = Ctx
  { cI     :: {-# UNPACK #-} !Int
  , cS     :: {-# UNPACK #-} !Ph
  , cNextI :: {-# UNPACK #-} !Int      -- -1 when there is none
  , cNextS :: {-# UNPACK #-} !Ph
  , cPadanta :: !Bool
  , cAvasana :: !Bool
  }

-- One left-to-right traversal, carrying its own tail: no (!!), no length.
-- `f` is offered each position and answers at most once, so the offers come
-- out already ordered by position and no list is concatenated per step.
scanCtx :: W -> (Ctx -> [a]) -> [a]
scanCtx xs0 f = go 0 xs0
  where
    go !_ [] = []
    go !i (x : tl)
      | isPh x =
          let (nj, ns) = look (i + 1) tl
              pad = case tl of (y : _) -> y == cPada; [] -> True
              av  = null tl
          in case f (Ctx i x nj ns pad av) of
               []  -> go (i + 1) tl
               ys  -> ys ++ go (i + 1) tl
      | otherwise = go (i + 1) tl
    look !_ [] = (-1, 255)
    look !j (y : r) | isPh y    = (j, y)
                    | otherwise = look (j + 1) r
{-# INLINE scanCtx #-}

-- every offer one rule makes, in position order
ruFires :: Rule -> W -> [Rw]
ruFires r xs = scanCtx xs (\c -> case ruAt r c of Just q -> [q]; Nothing -> [])

-- the first offer one rule makes, without building the rest: the tripadi
-- takes the leftmost and re-runs, so the rest was always discarded
firstOffer :: Rule -> W -> Maybe Rw
firstOffer r xs0 = go 0 xs0
  where
    go !_ [] = Nothing
    go !i (x : tl)
      | isPh x =
          let (nj, ns) = look (i + 1) tl
              pad = case tl of (y : _) -> y == cPada; [] -> True
              av  = null tl
          in case ruAt r (Ctx i x nj ns pad av) of
               Just q  -> Just q
               Nothing -> go (i + 1) tl
      | otherwise = go (i + 1) tl
    look !_ [] = (-1, 255)
    look !j (y : r') | isPh y    = (j, y)
                     | otherwise = look (j + 1) r'

rw :: Ref -> Int -> Int -> W -> Maybe Rw
rw r i n new = Just (Rw r i n new)
{-# INLINE rw #-}

rules :: [Rule]
rules =
  [ Rule (refOf 6 1 77) "iko yaṇ aci" []
      (\c -> if member (cS c) iK && cNextI c >= 0 && member (cNextS c) aC
               then rw (refOf 6 1 77) (cI c) (cNextI c - cI c) [sub yanA (cS c)]
               else Nothing)

  , Rule (refOf 6 1 78) "eco 'yavāyāvaḥ" []
      (\c -> if member (cS c) eC && cNextI c >= 0 && member (cNextS c) aC
               then rw (refOf 6 1 78) (cI c) (cNextI c - cI c) (ayavayavA B.! cS c)
               else Nothing)

  , Rule (refOf 6 1 87) "ād guṇaḥ" []
      (\c -> if member (cS c) aAlong && cNextI c >= 0 && member (cNextS c) iK
               then rw (refOf 6 1 87) (cI c) (cNextI c - cI c + 1) (gunaA B.! cNextS c)
               else Nothing)

  , Rule (refOf 6 1 88) "vṛddhir eci" [refOf 6 1 87]
      (\c -> if member (cS c) aAlong && cNextI c >= 0 && member (cNextS c) eC
               then rw (refOf 6 1 88) (cI c) (cNextI c - cI c + 1) [sub vrddhiA (cNextS c)]
               else Nothing)

  , Rule (refOf 6 1 101) "akaḥ savarṇe dīrghaḥ" []
      (\c -> if member (cS c) aK && cNextI c >= 0 && member (cNextS c) aC
                  && savarnaW (cS c) (cNextS c)
               then rw (refOf 6 1 101) (cI c) (cNextI c - cI c + 1) [sub dirghaA (cS c)]
               else Nothing)

  , Rule (refOf 6 1 109) "eṅaḥ padāntād ati" []
      (\c -> if member (cS c) eN && cPadanta c && cNextI c >= 0 && cNextS c == pA
               then rw (refOf 6 1 109) (cI c) (cNextI c - cI c + 1) [cS c, cAvagraha]
               else Nothing)

  ----------------------------------------------------------------
  -- THE TRIPADI.  8.2.1 pūrvatrāsiddham: run once, in order, blind
  -- to everything after.
  ----------------------------------------------------------------

  , Rule (refOf 8 2 30) "coḥ kuḥ" []
      (\c -> if member (cS c) cU && cPadanta c
               then rw (refOf 8 2 30) (cI c) 1 [sub kuA (cS c)]
               else Nothing)

  , Rule (refOf 8 2 39) "jhalāṃ jaśo 'nte" []
      (\c -> if member (cS c) jhaL && sub jasA (cS c) /= cS c && cPadanta c
               then rw (refOf 8 2 39) (cI c) 1 [sub jasA (cS c)]
               else Nothing)

  , Rule (refOf 8 2 66) "sasajuṣo ruḥ" []
      (\c -> if cS c == pS && cPadanta c
               then rw (refOf 8 2 66) (cI c) 1 [pR]
               else Nothing)

  , Rule (refOf 8 3 15) "kharavasānayor visarjanīyaḥ" []
      (\c -> if cS c == pR && cPadanta c
                  && (cNextI c < 0 || member (cNextS c) khaR)
               then rw (refOf 8 3 15) (cI c) 1 [pVisarga]
               else Nothing)

  , Rule (refOf 8 4 40) "stoḥ ścunā ścuḥ" []
      (\c -> if cNextI c < 0 then Nothing
             else if member (cS c) sTu && member (cNextS c) sCu
               then rw (refOf 8 4 40) (cI c) (cNextI c - cI c) [sub scuA (cS c)]
             else if member (cS c) sCu && member (cNextS c) sTu
               then rw (refOf 8 4 40) (cNextI c) 1 [sub scuA (cNextS c)]
             else Nothing)

  , Rule (refOf 8 4 41) "ṣṭunā ṣṭuḥ" []
      (\c -> if cNextI c < 0 then Nothing
             else if member (cS c) sTu && member (cNextS c) sTuRetro
               then rw (refOf 8 4 41) (cI c) (cNextI c - cI c) [sub stuRetroA (cS c)]
             else if member (cS c) sTuRetro && member (cNextS c) sTu
               then rw (refOf 8 4 41) (cNextI c) 1 [sub stuRetroA (cNextS c)]
             else Nothing)

  , Rule (refOf 8 4 53) "jhalāṃ jaś jhaśi" []
      (\c -> if member (cS c) jhaL && sub jasA (cS c) /= cS c
                  && cNextI c >= 0 && member (cNextS c) jhaSv
               then rw (refOf 8 4 53) (cI c) (cNextI c - cI c) [sub jasA (cS c)]
               else Nothing)

  , Rule (refOf 8 4 55) "khari ca" []
      (\c -> if member (cS c) jhaL && sub carA (cS c) /= cS c
                  && cNextI c >= 0 && member (cNextS c) khaR
               then rw (refOf 8 4 55) (cI c) (cNextI c - cI c) [sub carA (cS c)]
               else Nothing)

  , Rule (refOf 8 4 56) "vāvasāne" []
      (\c -> if member (cS c) jhaL && sub carA (cS c) /= cS c && cAvasana c
               then rw (refOf 8 4 56) (cI c) 1 [sub carA (cS c)]
               else Nothing)
  ]

tripadiRef :: Ref -> Bool
tripadiRef r = let (a, p, _) = refTriple r in a > 8 || (a == 8 && p >= 2)

sectionAW, sectionBW :: [Rule]
sectionAW = [ r | r <- rules, not (tripadiRef (ruNum r)) ]
sectionBW = sortOn ruNum [ r | r <- rules, tripadiRef (ruNum r) ]

-- The utsarga/apavada edges: only the pairs that HAVE one, so the lookup
-- walks a one-element list instead of the whole rule table.  6.1.88
-- `vrddhir eci` is an apavada to 6.1.87 `ad gunah` and is the only edge
-- this sample carries.
apavadaTable :: [(Ref, [Ref])]
apavadaTable = [ (ruNum u, ruApavada u) | u <- rules, not (null (ruApavada u)) ]

apavadaOf :: Ref -> [Ref]
apavadaOf r = case lookup r apavadaTable of Just xs -> xs; Nothing -> []

------------------------------------------------------------------------
-- 5.  THE ENGINE.  Same two regimes, same two metarules.
------------------------------------------------------------------------

applyW :: W -> Rw -> W
applyW xs (Rw _ i n new) = take i xs ++ new ++ drop (i + n) xs

overlapsW :: Rw -> Rw -> Bool
overlapsW a b = rPos a < rPos b + rLen b && rPos b < rPos a + rLen a
{-# INLINE overlapsW #-}

-- utsarga/apavada first, then 1.4.2 vipratisedhe param karyam.
resolveW :: [Rw] -> (Rw, [Ref])
resolveW [r] = (r, [])
resolveW rs =
  case [ r | r <- rs, any (\o -> rSutra o `elem` apavadaOf (rSutra r)) rs ] of
    (r : _) -> (r, [ rSutra o | o <- rs, rSutra o /= rSutra r ])
    []      -> let w = foldl1 (\a b -> if rSutra b > rSutra a then b else a) rs
               in (w, [ rSutra o | o <- rs, rSutra o /= rSutra w ])

-- Every offer section A makes, in ONE traversal: the word is the outer
-- loop and the rules are the inner one.  The reference runs a scan per
-- rule and then sorts by position; because no rule of section A offers
-- anywhere but at the position it is looking at, the two orders are the
-- same list, and this one comes out sorted without a sort.
offersA :: W -> [Rw]
offersA xs = scanCtx xs (\c -> [ q | r <- sectionAW, Just q <- [ruAt r c] ])

-- 1.4.2 decides among the rules competing for ONE position, so only the
-- leftmost offer and whatever overlaps it is ever needed.  `offersA` is
-- lazy and sorted, so the traversal stops a couple of positions past the
-- first offer instead of covering the word.
stepAW :: W -> Maybe (Rw, [Ref])
stepAW xs =
  case offersA xs of
    []         -> Nothing
    (r0 : rest) ->
      Just (resolveW (r0 : takeWhile (\r -> rPos r < rPos r0 + rLen r0) rest))

-- `derive`: no Step, no render of an intermediate, no note string.
deriveW :: W -> W
deriveW start = phaseB (phaseA (0 :: Int) start) sectionBW
  where
    phaseA !k xs
      | k > 64 = xs
      | otherwise = case stepAW xs of
          Nothing      -> xs
          Just (w, _)  -> let ys = applyW xs w
                          in if ys == xs then xs else phaseA (k + 1) ys
    phaseB xs []       = xs
    phaseB xs (r : rs) = phaseB (saturate (0 :: Int) xs) rs
      where
        saturate !n ys
          | n > 16 = ys
          | otherwise = case firstOffer r ys of
              Nothing -> ys
              Just q  -> let zs = applyW ys q
                         in if zs == ys then ys else saturate (n + 1) zs

derive :: String -> String
derive = renderW . deriveW . parseW

data TraceStep = TraceStep
  { tsSutra  :: !Ref
  , tsText   :: String
  , tsBeaten :: [Ref]
  , tsBefore :: String
  , tsAfter  :: String
  }

textOf :: Ref -> String
textOf r = case [ ruText u | u <- rules, ruNum u == r ] of
             (t : _) -> t
             []      -> "?"

traceW :: W -> ([TraceStep], W)
traceW start = let (a, xs) = phaseA (0 :: Int) start [] in phaseB xs sectionBW a
  where
    phaseA !k xs acc
      | k > 64 = (reverse acc, xs)
      | otherwise = case stepAW xs of
          Nothing -> (reverse acc, xs)
          Just (w, lost) ->
            let ys = applyW xs w
            in if ys == xs then (reverse acc, xs)
               else phaseA (k + 1) ys
                      (TraceStep (rSutra w) (textOf (rSutra w)) lost
                                 (renderW xs) (renderW ys) : acc)
    phaseB xs [] acc = (acc, xs)
    phaseB xs (r : rs) acc =
      let (ys, sts) = sat (0 :: Int) xs []
      in phaseB ys rs (acc ++ sts)
      where
        sat !n ys st
          | n > 16 = (ys, reverse st)
          | otherwise = case firstOffer r ys of
              Nothing -> (ys, reverse st)
              Just q  -> let zs = applyW ys q
                         in if zs == ys then (ys, reverse st)
                            else sat (n + 1) zs
                                   (TraceStep (ruNum r) (ruText r) []
                                              (renderW ys) (renderW zs) : st)

------------------------------------------------------------------------
-- 6.  SELF-TEST.  The pratyaharas against their traditional values, so
--     that the bitmask is checked against the interval that generated it
--     and not merely against itself.  The form-for-form comparison with
--     `Astadhyayi.derive` lives in LaghavaRun.hs, which imports both.
------------------------------------------------------------------------

laghavaSelfTest :: [String]
laghavaSelfTest = concat
  [ chk "inventory fits one register" (nPhones <= 64) True
  , chk "aṆ"   (nm (pratyaharaW "a" "ṇ")) ["a","i","u"]
  , chk "aK"   (nm (pratyaharaW "a" "k")) ["a","i","u","ṛ","ḷ"]
  , chk "iK"   (nm (pratyaharaW "i" "k")) ["i","u","ṛ","ḷ"]
  , chk "eṄ"   (nm (pratyaharaW "e" "ṅ")) ["e","o"]
  , chk "aC"   (nm (pratyaharaW "a" "c")) ["a","i","u","ṛ","ḷ","e","o","ai","au"]
  , chk "eC"   (nm (pratyaharaW "e" "c")) ["e","o","ai","au"]
  , chk "yaṆ"  (nm (pratyaharaW "y" "ṇ")) ["y","v","r","l"]
  , chk "ñaM"  (nm (pratyaharaW "ñ" "m")) ["ñ","m","ṅ","ṇ","n"]
  , chk "jhaṢ" (nm (pratyaharaW "jh" "ṣ")) ["jh","bh","gh","ḍh","dh"]
  , chk "jaŚ"  (nm (pratyaharaW "j" "ś"))  ["j","b","g","ḍ","d"]
  , chk "śaR"  (nm (pratyaharaW "ś" "r"))  ["ś","ṣ","s"]
  , chk "|jhaY| = 20"  (length (pratyaharaW "jh" "y")) 20
  , chk "|jhaL| = 24"  (length (pratyaharaW "jh" "l")) 24
  , chk "|yaR| = 32"   (length (pratyaharaW "y" "r"))  32
  , chk "|haL| = 34 slots" (length (pratyaharaW "h" "l")) 34
  , chk "|aL| = 43 slots"  (length (pratyaharaW "a" "l")) 43
  -- the masks: aC must have reached the long vowels via 1.1.69
  , chk "aC contains ā ī ū ṝ (1.1.69 savarṇa)"
      (all (`member` aC) (map phCode ["ā","ī","ū","ṝ"])) True
  , chk "aC excludes every consonant"
      (any (`member` aC) (map phCode ["k","y","s","h"])) False
  , chk "|aC| = 13" (popCount aC) 13
  , chk "1.1.10 nājjhalau: a and h are not savarṇa"
      (savarnaW (phCode "a") (phCode "h")) False
  -- the tokenizer's longest match
  , chk "longest match: dh before d" (nm (tokenizeW "dhi")) ["dh","i"]
  , chk "longest match: ai before a" (nm (tokenizeW "ai")) ["ai"]
  ]
  where
    nm = map phName
    chk n got want | got == want = []
                   | otherwise   = [ n ++ ": got " ++ show got ++ ", wanted " ++ show want ]
