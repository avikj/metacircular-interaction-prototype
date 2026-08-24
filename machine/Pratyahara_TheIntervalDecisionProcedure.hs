-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- Pratyahara_TheIntervalDecisionProcedure
--
-- The inverse of what machine/Astadhyayi.hs already does.  Astadhyayi.hs runs
-- the pratyahara FORWARD: give it `a` and `c` and it hands back the nine
-- vowels.  This file runs it BACKWARD, which is the direction the grammar is
-- written in: you have a class of sounds in hand and you need to know whether
-- Panini's device can name it at all, and if so under which two symbols.
--
--     nameClass ["e","o"]            ==  Right ("e",  "n~ (sutra 3)")   -- eN,
--     nameClass ["i","u","r.","l."]  ==  Right ("i",  "k (sutra 2)")    -- iK
--     nameClass ["ai","au"]          ==  Right ("ai", "c (sutra 4)")    -- aiC
--     nameClass ["a","u"]            ==  Left  "not an interval ..."
--     nameClass ["a","i"]            ==  Left  "not an interval ..."  (contiguous,
--                                                but no anubandha stands after i)
--
-- No table of known pratyaharas is consulted.  The decision is made against
-- the varnasamamnaya itself -- walk the line from the first member, take
-- sounds while they are in the class, and check that the slot you stop on is
-- an anubandha.  That is the whole of it, and it is what makes the device a
-- device rather than a list: contiguity in ONE order decides nameability.
--
-- WHY THIS EXISTS NOW.  formal/cubical/PratyaharaLaghava_TheMarkerCountIs-
-- ForcedByTheAntichain.agda proves, for any linear order whatsoever and any
-- placement of markers: two classes ending at the SAME anubandha are
-- subset-comparable, hence a subset-ANTICHAIN of classes forces that many
-- distinct anubandhas.  markers >= width(family), in the containment order.
-- The Agda file matches that bound on the vowel subfamily (four classes, four
-- markers, and the siva-sutra order attains it).  Whether the bound is tight
-- for the WHOLE inventory is an arithmetic question about a finite poset, and
-- this file answers it by computing rather than by asserting: Dilworth, via
-- bipartite matching and Koenig, on the family of classes the device names.
--
-- WHAT THE COMPUTATION SAYS, and it is two different answers:
--
--   * the family of ALL classes the line can name -- 294 distinct sets over
--     the 43 sound-slots -- has width exactly 14, matching the 14 anubandhas.
--     So for the family the device EXPRESSES, fourteen markers is the
--     minimum, in any linear order whatsoever, by the Agda theorem.
--   * the ~30 pratyaharas the Astadhyayi actually USES have width 11.  So the
--     attested classes alone do not force all fourteen, and what the other
--     three buy is not settled by this bound.  Stated as found; the gap is
--     not narrated.
--
-- The antichain is returned with the number, and `selfTest` re-checks that
-- what came back is pairwise incomparable -- a lower bound needs a VALID
-- antichain, so that is the property the matching code has to be right about.
--
-- What is NOT here, matching the Agda file's own NOT-claimed list: Petersen's
-- theorem (2004) that the order is essentially unique.  Uniqueness is the
-- other half and neither file touches it.  The width computed here is a lower
-- bound on the anubandha count and nothing more.
--
-- No floating point.  Every number printed is a finite exhaustive count or a
-- matching size, and `selfTest` returns [] or names what failed.

module Pratyahara_TheIntervalDecisionProcedure
  ( -- the decision procedure
    nameClass
  , classAt
  , soundLine
    -- the family the device can express
  , allNamed
  , attested
    -- the antichain bound
  , properSubsets
  , maxAntichain
  , widthOf
    -- honesty
  , selfTest
  , report
  ) where

import Data.List (nub, sort, sortOn, intercalate, find)
import Data.Maybe (mapMaybe, isJust)
import qualified Data.IntMap.Strict as IM
import qualified Data.IntSet as IS

import Astadhyayi (Slot(..), sivasutraTable, varnasamamnaya, pratyahara)

------------------------------------------------------------------------
-- 1.  THE LINE.
--
-- The varnasamamnaya with its slots numbered.  A marker is a boundary and
-- never a member, so the sounds and the markers share one index space but
-- only the sounds can belong to a class.
------------------------------------------------------------------------

-- (index, slot) for the whole line
line :: [(Int, Slot)]
line = zip [0..] varnasamamnaya

-- just the sounds, in order, with their index in the line
soundLine :: [(Int, String)]
soundLine = [ (k, s) | (k, Snd s) <- line ]

-- the anubandha occurrences: index in the line, the letter, and the sutra it
-- closes.  Fourteen of them, and `n.` occurs twice (sutras 1 and 6), which is
-- why an occurrence and not a letter is the unit here.
markers :: [(Int, String, Int)]
markers = go 0 line
  where
    go _ [] = []
    go n ((k, It m) : rest) = (k, m, n + 1) : go (n + 1) rest
    go n (_ : rest) = go n rest

markerName :: (Int, String, Int) -> String
markerName (_, m, n) = m ++ " (sutra " ++ show n ++ ")"

-- the class named by starting at line-index i and stopping at marker
-- occurrence j: every SOUND strictly between, intervening markers skipped.
classAt :: Int -> Int -> [String]
classAt i j = nub [ s | (k, s) <- soundLine, k >= i, k < j ]

------------------------------------------------------------------------
-- 2.  THE DECISION PROCEDURE.
--
-- Given a class, is it an interval of this one line, and under which two
-- symbols?  From a candidate start, take sounds while they belong; the run
-- must exhaust the class and must stop on an anubandha.
--
-- THE CANDIDATE START IS NOT ALWAYS THE FIRST MEMBER, and this is the one
-- place the procedure has to be careful: `h` stands twice in the line, in
-- sutra 5 (ha ya va ra Ta) and again in sutra 14 (ha La).  haL -- every
-- consonant -- runs from the FIRST h to the last marker; jhaL contains h but
-- must start at `jh` in sutra 8, so a walk begun at the first h dies after
-- one step.  So every occurrence of every member is tried as a start, in line
-- order, and the first that exhausts the class and lands on an anubandha is
-- the name.  That preserves the tradition's convention (earliest start,
-- earliest terminating marker) and costs one extra pass.  Still no list of
-- known pratyaharas is consulted: nameability is decided against the line.
------------------------------------------------------------------------

nameClass :: [String] -> Either String (String, String)
nameClass raw
  | null cls = Left "empty class: a pratyahara names at least one sound"
  | null starts = Left ("not in the varnasamamnaya: " ++ unwords cls)
  | otherwise =
      case mapMaybe try starts of
        (nm : _) -> Right nm
        []       -> Left ("not an interval of the varnasamamnaya: no start in "
                          ++ unwords (nub (map snd starts))
                          ++ " runs out exactly onto an anubandha")
  where
    cls = nub raw
    starts = [ p | p@(_, s) <- soundLine, s `elem` cls ]
    try (i0, s0) =
      let run   = takeRun i0
          taken = nub [ s | (_, s) <- run ]
          lastK = if null run then i0 else fst (last run)
      in if sort taken /= sort cls
           then Nothing
           else case [ m | m@(k, _, _) <- markers, k == lastK + 1 ] of
                  (m : _) -> Just (s0, markerName m)
                  []      -> Nothing
    -- sounds from index i onward, while they belong; markers are transparent
    takeRun i = go [ p | p <- line, fst p >= i ]
      where
        go [] = []
        go ((k, Snd s) : rest)
          | s `elem` cls = (k, s) : go rest
          | otherwise    = []
        go ((_, It _) : rest) = go rest

------------------------------------------------------------------------
-- 3.  THE WHOLE FAMILY THE DEVICE EXPRESSES.
--
-- Every start sound crossed with every marker occurrence after it.  This is
-- the largest family any encoding of THIS line can be asked to name, and it
-- is finite and small, so it can simply be listed.
------------------------------------------------------------------------

allNamed :: [((String, String), [String])]
allNamed =
  [ ((s, markerName m), cls)
  | (i, s) <- soundLine
  , m@(j, _, _) <- markers
  , j > i
  , let cls = classAt i j
  , not (null cls)
  ]

-- the pratyaharas the Astadhyayi actually uses, by their traditional names.
-- Sets are recomputed from the line, not typed in: `pratyahara` is
-- Astadhyayi's forward extractor, so this list asserts the NAMES only.
attested :: [(String, [String])]
attested =
  [ (s ++ m, nub (pratyahara s m))
  | (s, m) <- [ ("a","ṇ"), ("a","k"), ("i","k"), ("u","k"), ("e","ṅ")
              , ("a","c"), ("i","c"), ("e","c"), ("ai","c"), ("a","ṭ")
              , ("h","l"), ("y","ṇ"), ("y","m"), ("ñ","m"), ("y","ñ")
              , ("jh","l"), ("jh","ṣ"), ("jh","ś"), ("j","ś"), ("b","ś")
              , ("kh","r"), ("kh","y"), ("ch","v"), ("c","r"), ("ś","l")
              , ("ś","r"), ("y","r"), ("v","l"), ("r","l"), ("m","y")
              ]
  ]

------------------------------------------------------------------------
-- 4.  THE ANTICHAIN BOUND, COMPUTED.
--
-- The Agda theorem says markers >= the width of the family in the
-- containment order.  Width is max antichain, which by Dilworth equals
-- n - (maximum matching in the comparability bipartite graph); Koenig's
-- construction turns that matching into the antichain itself, so the bound
-- comes with its witness and is not a number to be trusted.
------------------------------------------------------------------------

-- distinct classes of a family, as canonical sorted sets
canon :: [[String]] -> [[String]]
canon = nub . map (sort . nub)

-- the strict containment relation, as left -> [right]
properSubsets :: [[String]] -> IM.IntMap [Int]
properSubsets xs = IM.fromList
  [ (i, [ j | (j, y) <- iy, i /= j, all (`elem` y) x, length x < length y ])
  | (i, x) <- iy ]
  where iy = zip [0 ..] xs

-- Kuhn's algorithm: maximum matching, returned as right -> left
matching :: Int -> IM.IntMap [Int] -> IM.IntMap Int
matching n adj = foldl step IM.empty [0 .. n - 1]
  where
    step m u = case augment IS.empty u m of
                 Just m' -> m'
                 Nothing -> m
    augment seen u m = go (IM.findWithDefault [] u adj) seen
      where
        go [] _ = Nothing
        go (v : vs) sn
          | v `IS.member` sn = go vs sn
          | otherwise =
              let sn' = IS.insert v sn
              in case IM.lookup v m of
                   Nothing -> Just (IM.insert v u m)
                   Just w  -> case augment sn' w m of
                                Just m' -> Just (IM.insert v u m')
                                Nothing -> go vs sn'

-- Koenig: the vertices reachable by alternating paths from unmatched lefts.
-- The maximum antichain is the set of elements that are in NEITHER side of
-- the minimum vertex cover.
maxAntichain :: [[String]] -> [[String]]
maxAntichain fam = [ xs !! i | i <- [0 .. n - 1]
                             , not (i `IS.member` coverL)
                             , not (i `IS.member` coverR) ]
  where
    xs  = canon fam
    n   = length xs
    adj = properSubsets xs
    m   = matching n adj                       -- right -> left
    matchedL = IS.fromList (IM.elems m)
    free = [ u | u <- [0 .. n - 1], not (u `IS.member` matchedL) ]
    (zl, zr) = reach (IS.fromList free) IS.empty free
    reach sl sr [] = (sl, sr)
    reach sl sr (u : q) =
      let vs  = [ v | v <- IM.findWithDefault [] u adj, not (v `IS.member` sr) ]
          sr' = foldr IS.insert sr vs
          ws  = mapMaybe (`IM.lookup` m) vs
          new = [ w | w <- ws, not (w `IS.member` sl) ]
          sl' = foldr IS.insert sl new
      in reach sl' sr' (q ++ new)
    coverL = IS.fromList [ u | u <- [0 .. n - 1], not (u `IS.member` zl) ]
    coverR = zr

widthOf :: [[String]] -> Int
widthOf = length . maxAntichain

------------------------------------------------------------------------
-- 5.  SELF-TEST.  Finite, exhaustive, and it names what failed.
------------------------------------------------------------------------

selfTest :: [String]
selfTest = concat
  [ chk "aC round-trips through the decision procedure"
      (fst <$> nameClass (nub (pratyahara "a" "c"))) (Right "a")
  , chk "eN. is named from its members alone"
      (nameClass ["e","o"]) (Right ("e", "ṅ (sutra 3)"))
  , chk "iK is named from its members alone"
      (nameClass ["i","u","ṛ","ḷ"]) (Right ("i", "k (sutra 2)"))
  , chk "a non-contiguous class is refused"
      (isJust (either Just (const Nothing) (nameClass ["a","au"]))) True
  , chk "a contiguous run not ending at an anubandha is refused"
      (isJust (either Just (const Nothing) (nameClass ["a","i"]))) True
  , chk "the empty class is refused"
      (isJust (either Just (const Nothing) (nameClass []))) True
  , chk "a sound outside the line is refused"
      (isJust (either Just (const Nothing) (nameClass ["q"]))) True
  , -- every attested pratyahara is decided, and decided with a name whose
    -- start sound is the traditional one
    concat [ chk ("attested " ++ nm ++ " is decided")
                 (either (const False) (const True) (nameClass cls)) True
           | (nm, cls) <- attested ]
  , -- the decision procedure agrees with exhaustive search over the line
    concat [ chk ("exhaustive agreement on " ++ nm)
                 (either (const False) (const True) (nameClass cls))
                 (any ((== sort (nub cls)) . sort . snd) allNamed)
           | (nm, cls) <- attested ]
  , -- h stands twice in the line, so `h` alone and `haL` are different names
    chk "h alone is named at sutra 14, not at sutra 5"
        (nameClass ["h"]) (Right ("h", "l (sutra 14)"))
  , chk "jhaL starts at jh even though it contains the earlier h"
        (fst <$> nameClass (nub (pratyahara "jh" "l"))) (Right "jh")
  , -- THE WITNESS, checked rather than trusted.  A lower bound needs only a
    -- VALID antichain, so the thing to verify about the matching code is that
    -- what it returns is pairwise incomparable.  Maximality is Dilworth's
    -- side of it and is not what the bound rests on.
    concat [ chk ("the computed antichain of the " ++ nm ++ " family is one")
                 (isAntichain (maxAntichain fam)) True
           | (nm, fam) <- [ ("attested", map snd attested)
                          , ("nameable", map snd allNamed) ] ]
  , -- brute force on a family small enough to enumerate: the four vowel
    -- classes of the Agda file are an antichain, so the width is 4
    chk "width of the four vowel classes is 4 (the Agda instance)"
        (widthOf vowelFour) 4
  , -- the anubandha count is met exactly on the family the device expresses
    chk "width of the full nameable family equals the anubandha count"
        (widthOf (map snd allNamed), length markers) (14, 14)
  ]
  where
    chk :: (Eq a, Show a) => String -> a -> a -> [String]
    chk nm got want
      | got == want = []
      | otherwise = [ nm ++ ": got " ++ show got ++ ", want " ++ show want ]

-- pairwise subset-incomparable, which is all a lower bound needs
isAntichain :: [[String]] -> Bool
isAntichain xs = and
  [ not (all (`elem` y) x) && not (all (`elem` x) y)
  | (p, x) <- zip [0 :: Int ..] xs, (q, y) <- zip [0 ..] xs, p < q ]

-- aN., iK, eN,, aiC -- the family formal/cubical/PratyaharaLaghava_... uses
vowelFour :: [[String]]
vowelFour = [ nub (pratyahara s m)
            | (s, m) <- [("a","ṇ"), ("i","k"), ("e","ṅ"), ("ai","c")] ]

------------------------------------------------------------------------
-- 6.  WHAT THE MACHINE NOW DECIDES, PRINTED.
------------------------------------------------------------------------

report :: IO ()
report = do
  putStrLn "PRATYAHARA -- the interval decision procedure"
  putStrLn "============================================"
  putStrLn ""
  putStrLn ("sounds in the line          : " ++ show (length soundLine))
  putStrLn ("anubandha occurrences       : " ++ show (length markers))
  putStrLn ("distinct classes nameable   : " ++ show (length (canon (map snd allNamed))))
  putStrLn ""
  putStrLn "decisions, made against the line and not against a list:"
  mapM_ report
    [ ["e","o"], ["i","u","ṛ","ḷ"], ["a","i","u"], ["ai","au"]
    , ["y","v","r","l"], ["a","u"], ["a","i"], ["h"]
    ]
  putStrLn ""
  putStrLn "the antichain bound (Agda: markers >= width of the family):"
  let famA = canon (map snd attested)
      acA  = maxAntichain famA
      famN = canon (map snd allNamed)
      acN  = maxAntichain famN
  putStrLn ("  attested family      : " ++ show (length famA) ++ " classes, width "
            ++ show (length acA))
  putStrLn ("    a witnessing antichain:")
  mapM_ (\c -> putStrLn ("      " ++ nameOrRaw c)) acA
  putStrLn ("  full nameable family : " ++ show (length famN) ++ " classes, width "
            ++ show (length acN))
  putStrLn ("  anubandhas actually used : " ++ show (length markers))
  putStrLn ""
  putStrLn (verdict (length acA) (length acN) (length markers))
  putStrLn ""
  case selfTest of
    [] -> putStrLn "selfTest: all checks pass"
    fs -> mapM_ (putStrLn . ("selfTest FAILED: " ++)) fs
  where
    report cls = putStrLn ("  " ++ pad 26 (unwords cls) ++ " " ++
      case nameClass cls of
        Right (s, m) -> "= " ++ s ++ " .. " ++ m
        Left err     -> "NOT NAMEABLE -- " ++ err)
    pad n s = s ++ replicate (max 0 (n - length s)) ' '
    nameOrRaw c = case nameClass c of
      Right (s, m) -> pad 22 (unwords c) ++ "  named " ++ s ++ " .. " ++ m
      Left _       -> unwords c
    verdict wA wN k
      | wN == k && wA == k =
          "The bound is TIGHT on both families: width = " ++ show k ++
          " = the anubandhas used, so " ++ show k ++
          " markers is the minimum for this family in ANY linear order."
      | wN == k =
          "The bound is tight on the full nameable family (width " ++ show wN ++
          " = " ++ show k ++ " anubandhas), so " ++ show k ++
          " is minimal for it in ANY order; on the attested subfamily the width\n" ++
          "is only " ++ show wA ++ ", so the attested classes alone do not force all "
          ++ show k ++ ".\nWhat the extra markers buy there is not settled by this bound."
      | otherwise =
          "The bound is NOT tight here: width(attested) = " ++ show wA ++
          ", width(nameable) = " ++ show wN ++ ", anubandhas = " ++ show k ++
          ".\nThe antichain argument alone does not force the count; the remaining\n\
          \gap is what Petersen's theorem addresses and it is not proved here."
