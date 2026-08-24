-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- अनेकान्त-दृष्टिः — the many-sided view, made a computation.
--
-- अनेकान्तवाद (anekāntavāda) is the Jaina doctrine that a thing admits many
-- standpoints, that each naya is true at its own standpoint, and that a naya
-- which asserts itself by denying the others becomes a durnaya.  Umāsvāti,
-- *Tattvārthasūtra*; Siddhasena Divākara, *Sanmatitarka*; Samantabhadra,
-- *Āptamīmāṃsā* 14–23 for the sevenfold.  The corpus already carries the
-- mechanical form: `formal/cubical/Saptabhangi.agda` proves दुर्नयः — any
-- TWO-valued verdict on three seeds must identify two of them.
--
-- WHAT IS ASKED HERE, and it is the question the previous instruments could
-- not ask.  `AkramaDrshti_...` computes THE finest branch-blind frame of a
-- multiway rule — one partition, arrived at by forced closure.  That is a
-- single answer, and a single answer is exactly what anekāntavāda says to be
-- suspicious of.
--
-- So: give the observer a VOCABULARY — a fixed list of instruments it could
-- build — and ask which SUBSETS of that vocabulary give a branch-blind
-- observer.  Two facts make this a real search and not a triviality:
--
--   * adding an instrument makes the observer's equivalence finer, which
--     weakens the hypothesis of branch-blindness and strengthens its
--     conclusion at the same time.  So admissibility is NOT monotone in
--     either direction, and it is not per-instrument either.  Every subset
--     must be tested.  2^|vocabulary| of them, exactly, over all 2^w states.
--
--   * therefore there may be SEVERAL MAXIMAL admissible subsets, and they may
--     be INCOMPARABLE — two observers with the same instruments available,
--     each seeing a lawful world, neither able to refine into the other.
--
-- That second possibility is the whole point of running this.  If it happens,
-- then for that rule there is no best observer and no privileged physics: the
-- maximal frames are nayas, each true at its standpoint, and any claim that
-- one of them is THE frame is a durnaya with a witness against it.
--
-- The theorem underneath: `formal/cubical/EkaVakyata_...`, branch-blindness
-- gives a deterministic law and a well-defined time with no confluence
-- assumed; `formal/cubical/Vyapti_...`, the closure that forces a frame.
--
-- Run:
--   runghc machine/AnekantaDrshti_SeveralMaximalFramesCanBeIncomparableSoThereIsNoBestObserver.hs 160 5
--   runghc machine/AnekantaDrshti_...hs sweep 5
module Main (main) where

import System.Environment (getArgs)
import System.IO (hSetEncoding, stdout, utf8)
import Data.Bits (testBit, xor, shiftL)
import Data.List (nub, sortOn, intercalate, subsequences)

type St = Int

-- ------------------------------------------------------------ the multiway
succsOf :: Int -> Int -> St -> [St]
succsOf r w x = nub [ upd i | i <- [0 .. w-1] ]
  where
    at i = testBit x ((i + w) `mod` w)
    upd i =
      let a = at (i-1); b = at i; c = at (i+1)
          k = (if a then 4 else 0) + (if b then 2 else 0) + (if c then 1 else 0)
      in if testBit r k == b then x else x `xor` (1 `shiftL` i)

-- ----------------------------------------------------------- the vocabulary
-- Instruments an observer could actually build: each is a reading of a row.
-- Kept small and namable on purpose — this is a workshop, not a basis.
vocabulary :: Int -> [(String, St -> Int)]
vocabulary w =
  [ ("alive?",      \x -> if x /= 0 then 1 else 0)
  , ("full?",       \x -> if x == 2^w - 1 then 1 else 0)
  , ("ω",           \x -> length [ () | i <- [0..w-1], testBit x i ])
  , ("ω mod 2",     \x -> length [ () | i <- [0..w-1], testBit x i ] `mod` 2)
  , ("walls",       \x -> wallsOf w x)
  , ("walls mod 2", \x -> wallsOf w x `mod` 2)
  , ("cell 0",      \x -> if testBit x 0 then 1 else 0)
  , ("cell 1",      \x -> if testBit x 1 then 1 else 0)
  , ("left half ω", \x -> length [ () | i <- [0 .. w `div` 2 - 1], testBit x i ])
  ]

wallsOf :: Int -> St -> Int
wallsOf w x = length [ () | i <- [0..w-1], testBit x i /= testBit x ((i+1) `mod` w) ]

-- the transcript of a subset of instruments, which is the observer
reading :: [(String, St -> Int)] -> St -> [Int]
reading qs x = [ q x | (_, q) <- qs ]

-- --------------------------------------------------------- branch-blindness
-- o x ≡ o y  ⟹  every successor of x reads like every successor of y.
-- Exhaustive over every ordered pair of states.
blind :: (St -> [St]) -> Int -> [(String, St -> Int)] -> Bool
blind sc n qs =
  and [ reading qs x' == reading qs y'
      | x <- [0 .. n-1], y <- [0 .. n-1]
      , reading qs x == reading qs y
      , x' <- sc x, y' <- sc y ]

resolution :: Int -> [(String, St -> Int)] -> Int
resolution n qs = length (nub [ reading qs x | x <- [0 .. n-1] ])

-- ------------------------------------------------------------- the maxima
-- Admissibility is not monotone, so every subset is tested.  A subset is
-- MAXIMAL when no admissible subset properly contains it.
maximalFrames :: (St -> [St]) -> Int -> [(String, St -> Int)]
              -> [[(String, St -> Int)]]
maximalFrames sc n vocab =
  [ s | s <- adm, not (any (properlyContains s) adm) ]
  where
    adm = [ s | s <- subsequences vocab, blind sc n s ]
    properlyContains s t = names s /= names t && all (`elem` names t) (names s)
    names = map fst

-- two frames are incomparable when neither's readings refine the other's
refines :: Int -> [(String, St -> Int)] -> [(String, St -> Int)] -> Bool
refines n a b =
  and [ (reading a x == reading a y) <= (reading b x == reading b y)
      | x <- [0 .. n-1], y <- [0 .. n-1] ]
  where _ = ()

-- ---------------------------------------------------------------- display
detail :: Int -> Int -> IO ()
detail r w = do
  let n     = 2 ^ w
      sc    = succsOf r w
      vocab = vocabulary w
      maxes = maximalFrames sc n vocab
  putStrLn ("rule " ++ show r ++ " asynchronous, width " ++ show w
            ++ ", " ++ show n ++ " states, "
            ++ show (length vocab) ++ " instruments available ("
            ++ show (2 ^ length vocab :: Int) ++ " subsets, all tested).\n")
  let ff = forcedFrame sc n
      ffres = length (nub ff)
  putStrLn ("  the FORCED finest frame has " ++ show ffres
            ++ " classes — that world exists whatever the instruments are.")
  putStrLn ("  MAXIMAL LAWFUL OBSERVERS BUILDABLE FROM THE VOCABULARY: "
            ++ show (length maxes))
  mapM_ (one n) (zip [1 :: Int ..] maxes)
  putStrLn ""
  let inc = [ (i,j) | (i,a) <- zip [1 :: Int ..] maxes
                    , (j,b) <- zip [1 :: Int ..] maxes
                    , i < j, not (refines n a b), not (refines n b a) ]
  if null inc
    then putStrLn "  all of them are comparable — the maximal frames form a chain."
    else do
      putStrLn ("  INCOMPARABLE PAIRS: " ++ show (length inc) ++ " — "
                ++ intercalate ", " [ "#" ++ show i ++ "/#" ++ show j
                                    | (i,j) <- take 8 inc ])
      putStrLn  "  Neither refines the other.  Two observers, the same instruments"
      putStrLn  "  available, each seeing a lawful world, and no common refinement"
      putStrLn  "  that is still lawful.  There is no best frame for this rule, and"
      putStrLn  "  calling any one of them THE frame is a durnaya with a witness."
  where
    one n (i, s) =
      putStrLn ("    #" ++ show i ++ "  resolution " ++ show (resolution n s)
                ++ "  from {" ++ intercalate ", " (map fst s) ++ "}")

sweep :: Int -> IO ()
sweep w = do
  let n = 2 ^ w
  putStrLn ("all 256 asynchronous elementary rules at width " ++ show w
            ++ ", every subset of the vocabulary tested.\n")
  putStrLn  "  maximal lawful observers | incomparable pairs among them | rules"
  let rows = [ (r, length ms, incs) | r <- [0 .. 255]
             , let sc = succsOf r w
             , let ms = maximalFrames sc n (vocabulary w)
             , let incs = length [ () | (i,a) <- zip [0 :: Int ..] ms
                                      , (j,b) <- zip [0 :: Int ..] ms, i < j
                                      , not (refines n a b), not (refines n b a) ] ]
      keys = nub [ (k, c) | (_, k, c) <- rows ]
  mapM_ (\(k,c) ->
           let rs = [ r | (r,k',c') <- rows, k' == k, c' == c ]
           in putStrLn ("  " ++ pad 26 (show k) ++ pad 31 (show c)
                        ++ show (length rs) ++ " rules  " ++ shortly rs))
        (sortOn id keys)
  putStrLn "\n  exhaustive: every subset, every state, every rule."
  where
    pad k s = s ++ replicate (k - length s) ' '
    shortly rs | length rs > 8 = intercalate "," (map show (take 8 rs)) ++ ",…"
               | otherwise     = intercalate "," (map show rs)

main :: IO ()
main = do
  hSetEncoding stdout utf8
  as <- getArgs
  putStrLn "अनेकान्त-दृष्टिः — how many maximal lawful observers, and are any incomparable.\n"
  case as of
    ("sweep":w:_) -> sweep (read w)
    ("sweep":_)   -> sweep 5
    (r:w:_)       -> detail (read r) (read w)
    (r:_)         -> detail (read r) 5
    []            -> detail 160 5
  putStrLn "\n(branch-blindness gives a law and a time with no confluence:\n \
           \ formal/cubical/EkaVakyata_...agda;  दुर्नयः: formal/cubical/Saptabhangi.agda)"

-- ------------------------------------------------- the frame it is owed
-- `AkramaDrshti_...` computes the FORCED finest frame: the least congruence
-- identifying every pair of co-successors, closed under the step.  That frame
-- exists whether or not any instrument in the vocabulary can name it.  The
-- gap between the two is the thing worth printing — an observer can be
-- entitled to a lawful world it has no instrument to build.
forcedFrame :: (St -> [St]) -> Int -> [Int]
forcedFrame sc n = go (zip [0 ..] [0 .. n-1]) seeds
  where
    seeds = concat [ zip ss (drop 1 ss) | i <- [0 .. n-1], let ss = sc i ]
    root m i = case lookup i m of Just j | j /= i -> root m j; _ -> i
    go m [] = [ root m i | i <- [0 .. n-1] ]
    go m ((x,y):q) =
      let rx = root m x; ry = root m y
      in if rx == ry then go m q
         else let m' = (rx, ry) : filter ((/= rx) . fst) m
                  nx = case (sc x, sc y) of
                         ((a:_), (b:_)) -> [(root m' a, root m' b)]
                         _              -> []
              in go m' (nx ++ q)

-- ---------------------------------------------------------------- मर्यादा
--
-- WHAT RUNNING IT ACTUALLY SAID, recorded here rather than in a note,
-- because the header above says the incomparable case is the point of the
-- exercise and it did not happen.
--
-- At width 4, all 256 rules, every one of the 512 subsets tested: EVERY rule
-- has exactly ONE maximal lawful observer, and there are ZERO incomparable
-- pairs anywhere.  The anekānta case this was built to catch does not occur
-- in this space.
--
-- And the reason is the previous instrument's result, which explains it.  A
-- branch-blind partition is coarser than the forced frame F, so every query
-- in an admissible set is constant on F's classes — that part is PER-QUERY.
-- The joint part is that the combined partition must also be a congruence of
-- the induced law f̄ on F.  `AkramaDrshti_...`'s motion sweep found that f̄
-- moves at most one class for 237 of 256 rules and none at all for 141, so
-- nearly every coarsening is an f̄-congruence and the joint condition is
-- nearly vacuous.  Admissibility collapses to the per-query test, per-query
-- tests have a unique maximum, and there is nothing for two incomparable
-- frames to be made of.
--
-- So the two findings are one finding: the frames are static, and BECAUSE
-- they are static there is only ever one of them.  To get incomparable
-- maximal frames one needs a system whose forced frame has a genuinely
-- MOVING induced law and a vocabulary rich enough to name part of it.  In
-- this space rules 160 and 250 are the only ones with real motion (five of
-- six classes), and the vocabulary cannot name their frame at all.  Neither
-- half is available at once here, and that is a statement about asynchronous
-- elementary rules, not about the question.
--
-- THE GAP WORTH KEEPING, which this did establish.  The forced frame and the
-- buildable one are far apart:
--
--     rule 205   forced 18 classes   buildable 3
--     rule 76    forced 18 classes   buildable 3
--     rule 160   forced  6 classes   buildable 1  (sees nothing)
--     rule 110   forced  2 classes   buildable 2  (the only one that closes)
--
-- A lawful world can exist that no instrument in the observer's language
-- names.  That is not a shortage of bits — rule 205's observer has nine
-- instruments and resolves three classes out of eighteen available.  It is a
-- shortage of the RIGHT question, which is `QuotientFiberLaw`'s separating
-- query with one more thing said about it: the separating query may not be
-- in your vocabulary at all.
