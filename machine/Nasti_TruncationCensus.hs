-- Nasti_TruncationCensus.hs -- नष्टि-गणना, the census of collapse sites in
-- the machine's own source.
--
--     runghc machine/Nasti_TruncationCensus.hs
--     runghc machine/Nasti_TruncationCensus.hs machine        -- same
--     runghc machine/Nasti_TruncationCensus.hs formal/lean    -- any dir
--
-- ---------------------------------------------------------------------
-- WHY THIS EXISTS, AND WHY IT IS NOT `ObstructionCensus.hs`
--
-- `ANEKANTA.md` §1 reports the sharpest measurement this repository has
-- of its own hiṃsā: at `machine/MathMachine.hs:1743` a kernel refusal
-- was collapsed to `pure False`, and a census over the run log found
-- **1457 refusals** carrying at least four unrelated situations under
-- one bit -- 288 actually false, 455 accepted elsewhere in the same log,
-- 154 not expressible as a predication at all, 80 with no subject to
-- predicate of.  `machine/ObstructionCensus.hs` recomputes those.
--
-- IT CANNOT BE RE-RUN BY A READER.  Its own header says so: the input is
-- `machine/machine.log`, excluded by `.gitignore:16`.  A clone does not
-- have it, no two runs produce the same one, and the four published
-- numbers are therefore quotable but not checkable.  That is a count
-- without its input, which this repository already names as the same
-- defect as a constant without its scaling.
--
-- This census takes a different input: **the source, which is tracked**.
-- It does not measure how often a collapse fired at runtime.  It
-- measures how many places in the code CAN collapse -- how many sites
-- exist where structure is turned into a bit, a set into a count, or a
-- `Maybe` swallows which.  Every number below is re-derivable from a
-- fresh clone with one command, today and in a year, and it moves when
-- the code moves.  A count that can be re-derived tomorrow is worth more
-- than a paragraph about the problem.
--
-- ---------------------------------------------------------------------
-- WHAT IS COUNTED, EXACTLY.  No verdict is implied by a hit.
--
-- This is a LEXICAL scan, not a semantic analysis, and saying so is not
-- modesty -- it is the difference between what the number means and what
-- a reader will take it for.  Comments and string literals are stripped
-- first (approximately: see `stripCode`), so prose about `pure False`
-- does not count.  What survives is code lines, tokenised so that `->`,
-- `::` and `_` are single tokens and word matches are exact.
--
-- Seven categories, and the token patterns are given in full so that
-- anyone can disagree with a category rather than with a total:
--
--   द्विकः      dvika, "the pair" -- a verdict collapsed to a bit.
--              adjacent tokens: (pure|return|->|=) followed by
--              (True|False).  THIS IS THE MathMachine:1743 SHAPE.
--
--   निर्णयः     nirṇaya, "the settled verdict" -- a Bool-valued
--              signature.  A line containing `::` or `->` whose last
--              token is `Bool`.  Every one of these is a naya that has
--              been given the type of a verdict: the standpoint it
--              spoke from is not in the type, so it cannot be recovered
--              by a caller.  Not a defect per site; a defect per site
--              that matters.
--
--   कः-नष्टिः   kaḥ-naṣṭi, "the WHICH perishes" -- a Maybe or Either
--              consumed in a way that discards which:
--              fromMaybe, fromJust, isJust, isNothing, catMaybes,
--              mapMaybe, maybe, either, isLeft, isRight, and the
--              adjacent pair (Nothing, ->).
--
--   गणना       gaṇanā, "counting" -- a set of witnesses become a
--              number: length, genericLength, nub, nubBy, and any
--              qualified `.size`.  `nub` is here because it collapses
--              distinct-under-Eq, which is a chosen naya, and the
--              elements it drops are not recorded.
--
--   छेदः       cheda, "the cut" -- literal truncation:
--              take, takeWhile, drop, dropWhile, truncate, `.take`.
--              `take 160` at MathMachine:1743 is the archetype: the
--              161st character of the kernel's answer is destroyed.
--
--   सर्वत्र     sarvatra, "everywhere" -- the catch-all branch: the
--              adjacent pair (_, ->).  A whole family of constructors
--              answered in one arm, with no record of which arrived.
--
--   विनाशः     vināśa, "annihilation" -- a partial function, where the
--              failure case is not collapsed but destroyed:
--              error, undefined, head, last, init, fromJust, (!!).
--
-- AND THE COUNTER-SIDE, because a census that lists only injuries is
-- itself a durnaya:
--
--   प्रतिपक्षः  pratipakṣa -- the machine's own structured verdicts,
--              counted as occurrences of the types it already built to
--              refuse the collapse: Verdict, Naya, Obstruction, Bhanga,
--              Sthana, Saptabhangi, Pramana, Evidence, Provenance,
--              Justification, Avacchedaka, Pravesha, Sthiti, Yogya,
--              Residual, and `Either`.  This number is the repair, and
--              it is reported alongside rather than subtracted.
--
-- ---------------------------------------------------------------------
-- WHAT THIS CENSUS REFUSES TO DO
--
-- It does not print one number.  There is no "total hiṃsā", and adding
-- the seven categories would be the exact act the census is measuring:
-- seven distinguishable situations flattened into one scalar that no
-- caller can un-flatten.  The categories are reported as a vector and
-- stay a vector.  `sitesTotal` below is printed as "sites, summed" and
-- is labelled a convenience for the ratchet, not a finding.
--
-- It does not deduplicate across categories.  `fromJust` is both
-- कः-नष्टिः and विनाशः, and a line may be counted in several.  Choosing
-- one would be choosing a naya and hiding it.
--
-- It does not rank files.  It prints the ten with the most sites so a
-- reader can go and look, in file order within the tie -- a list is not
-- a score, and a file with many sites may be the one doing the most
-- work.
--
-- ---------------------------------------------------------------------
-- SOURCES for the vocabulary.  Umāsvāti, *Tattvārthasūtra* 7.13
-- (c. 2nd-5th c. CE): हिंसा is प्रमत्तयोगात् प्राणव्यपरोपणम् -- severance
-- performed INATTENTIVELY.  That is why a census of sites is the right
-- instrument and a census of intentions is not: nobody wrote
-- `pure False` in order to destroy 1457 distinctions.  Siddhasena
-- Divākara, *Sanmatitarka* (c. 5th c. CE), and Samantabhadra,
-- *Āptamīmāṃsā*, on नय / दुर्नय -- a standpoint that has forgotten it is
-- one.  NEITHER TEXT SAYS ANYTHING ABOUT HASKELL; what is taken is the
-- distinction between a partial view held as partial and a partial view
-- held as the whole, which is exactly the difference between `Verdict`
-- and `Bool`.
--
-- The mathematics of why the collapse is irreversible is checked, not
-- asserted: `formal/cubical/Apratikaryatva_TheRetractionTypeIsTheHLevel-
-- Hypothesis.agda`, where the type of ways back from an n-truncation is
-- proved EQUIVALENT to the h-level hypothesis, hence empty whenever the
-- structure was really there.  Nothing in this file is a proof; it is
-- the place where that theorem's hypothesis is looked for in the code.

module Main (main) where

import Control.Monad (forM, when)
import Data.Char (isAlphaNum, isSpace)
import Data.List (isSuffixOf, sortBy)
import Data.Bits (xor)
import Data.Ord (comparing)
import Data.Word (Word64)
import Numeric (showHex)
import System.Directory (doesDirectoryExist, listDirectory)
import System.Environment (getArgs)
import System.Exit (exitFailure, exitSuccess)
import System.FilePath ((</>))
import System.IO (hSetEncoding, utf8, stdout, stderr, openFile, IOMode(ReadMode)
                 , hGetContents)

-- ---------------------------------------------------------------------
-- 1.  Stripping.  Comments and string literals are not code.
--
-- APPROXIMATE, and the approximations are named: a `--` inside a string
-- ends the line early (over-strips), nested `{- -}` is handled to one
-- level of nesting, and a `--` that is part of an operator like `-->`
-- is treated as a comment.  Every one of these errs toward stripping
-- MORE, so the counts below are lower bounds on what a perfect scanner
-- would find.  A census that could be accused of inflation is worth
-- less than one that is provably conservative.
-- ---------------------------------------------------------------------

stripCode :: String -> String
stripCode = goBlock (0 :: Int)
  where
    goBlock d ('{' : '-' : cs) = goBlock (d + 1) cs
    goBlock d ('-' : '}' : cs) = goBlock (max 0 (d - 1)) cs
    goBlock d ('\n' : cs) = '\n' : goBlock d cs
    goBlock d (c : cs)
      | d > 0 = goBlock d cs
      | c == '"' = goStr d cs
      | otherwise = case c : cs of
          ('-' : '-' : _) -> goLine d (c : cs)
          _ -> c : goBlock d cs
    goBlock _ [] = []

    -- inside a line comment: drop to newline
    goLine d s = case dropWhile (/= '\n') s of
      ('\n' : rest) -> '\n' : goBlock d rest
      _ -> []

    -- inside a string literal: drop to the closing quote
    goStr d ('\\' : _ : cs) = goStr d cs
    goStr d ('"' : cs) = ' ' : goBlock d cs
    goStr d ('\n' : cs) = '\n' : goBlock d cs
    goStr d (_ : cs) = goStr d cs
    goStr _ [] = []

-- ---------------------------------------------------------------------
-- 2.  Tokenising.  Identifier-ish runs and symbol runs, each maximal, so
--     `->` and `::` are single tokens and `Bool` never matches `Boolean`.
-- ---------------------------------------------------------------------

isIdentChar :: Char -> Bool
isIdentChar c = isAlphaNum c || c == '_' || c == '\'' || c == '.'

tokens :: String -> [String]
tokens [] = []
tokens (c : cs)
  | isSpace c = tokens cs
  | isIdentChar c = let (w, r) = span isIdentChar (c : cs) in w : tokens r
  | c `elem` "()[],;`{}" = [c] : tokens cs
  | otherwise = let (s, r) = span isSymChar (c : cs) in s : tokens r
  where isSymChar x = not (isSpace x) && not (isIdentChar x)
                      && x `notElem` "()[],;`{}"

-- ---------------------------------------------------------------------
-- 3.  The categories.
-- ---------------------------------------------------------------------

data Cat = Dvika | Nirnaya | KahNasti | Ganana | Cheda | Sarvatra | Vinasha
  deriving (Eq, Ord, Enum, Bounded, Show)

-- The Devanagari name, the transliteration, and the one-line gloss.
-- Kept together so no report can print a name without its meaning.
catName :: Cat -> (String, String, String)
catName Dvika    = ("द्विकः",    "dvika",     "a verdict collapsed to a bit")
catName Nirnaya  = ("निर्णयः",   "nirnaya",   "a Bool-valued signature")
catName KahNasti = ("कः-नष्टिः", "kah-nasti", "a Maybe/Either swallows WHICH")
catName Ganana   = ("गणना",     "gaNanaa",   "witnesses become a number")
catName Cheda    = ("छेदः",      "cheda",     "literal truncation: take/drop")
catName Sarvatra = ("सर्वत्र",    "sarvatra",  "the catch-all _ -> branch")
catName Vinasha  = ("विनाशः",    "vinaasha",  "a partial function: error/head")

adjacent :: [String] -> [(String, String)]
adjacent ts = zip ts (drop 1 ts)

hits :: Cat -> [String] -> Int
hits Dvika ts =
  length [ () | (a, b) <- adjacent ts
              , a `elem` ["pure", "return", "->", "="]
              , b `elem` ["True", "False"] ]
hits Nirnaya ts
  | null ts = 0
  | (elem "::" ts || elem "->" ts) && last ts == "Bool" = 1
  | otherwise = 0
hits KahNasti ts =
  length (filter (`elem` maybeWords) ts)
  + length [ () | ("Nothing", "->") <- adjacent ts ]
  where maybeWords = [ "fromMaybe", "fromJust", "isJust", "isNothing"
                     , "catMaybes", "mapMaybe", "maybe", "either"
                     , "isLeft", "isRight" ]
hits Ganana ts =
  length (filter isCount ts)
  where isCount t = t `elem` ["length", "genericLength", "nub", "nubBy"]
                    || ".size" `isSuffixOf` t
hits Cheda ts =
  length (filter isCut ts)
  where isCut t = t `elem` ["take", "takeWhile", "drop", "dropWhile", "truncate"]
                  || ".take" `isSuffixOf` t || ".drop" `isSuffixOf` t
hits Sarvatra ts = length [ () | ("_", "->") <- adjacent ts ]
hits Vinasha ts =
  length (filter (`elem` ws) ts)
  where ws = ["error", "undefined", "head", "last", "init", "fromJust", "!!"]

-- the repair, counted the same way and reported beside the injuries.
pratipaksha :: [String] -> Int
pratipaksha ts = length (filter (`elem` ws) ts)
  where ws = [ "Verdict", "Naya", "Obstruction", "Bhanga", "Sthana"
             , "Saptabhangi", "Pramana", "Evidence", "Provenance"
             , "Justification", "Avacchedaka", "Pravesha", "Sthiti"
             , "Yogya", "Residual", "Either" ]

-- ---------------------------------------------------------------------
-- 4.  The scan.
-- ---------------------------------------------------------------------

data FileReport = FileReport
  { frPath  :: FilePath
  , frLines :: Int              -- non-blank code lines after stripping
  , frCat   :: [(Cat, Int)]
  , frRepair :: Int
  , frSites :: [(Cat, Int, String)]   -- category, line number, the line
  }

scanFile :: FilePath -> String -> FileReport
scanFile path src = FileReport
  { frPath = path
  , frLines = length [ () | l <- codeLines, not (all isSpace l) ]
  , frCat = [ (c, sum [ hits c (tokens l) | l <- codeLines ]) | c <- [minBound ..] ]
  , frRepair = sum [ pratipaksha (tokens l) | l <- codeLines ]
  , frSites = [ (c, n, trim l)
              | (n, l) <- zip [1 ..] codeLines
              , c <- [minBound ..]
              , hits c (tokens l) > 0 ]
  }
  where
    codeLines = lines (stripCode src)
    trim = dropWhile isSpace

-- ---------------------------------------------------------------------
-- 5.  THE RATCHET.
--
-- Measured 2026-08-20 against machine/*.hs at commit 547a37ab, with
-- Agda-lane work already landed.  These are not targets and not limits;
-- they are a mark on the wall, so that the next reader can see which
-- direction the number moved and does not have to take anyone's word
-- that it moved at all.
--
-- The check FAILS (exit 1) if any category is ABOVE its mark.  It says
-- so loudly and exits 0 when a category is below -- a ratchet that
-- silently accepts improvement is how a baseline stops being one.
--
-- If a category is above its mark for a good reason, MOVE THE MARK IN
-- THIS FILE, in the same commit, with the reason.  A baseline edited
-- separately from the change that needed it is a lie with a timestamp.
-- ---------------------------------------------------------------------

-- THE MARK IS TIED TO AN INPUT, AND THE CHECK REFUSES TO RULE WITHOUT IT.
--
-- Learned by running this census three times in ten minutes and getting
-- dvika = 306, 308, 315, 317: `machine/` is being written by several lanes
-- at once, and every one of those runs read a different tree.  A ratchet
-- that reported "REGRESSION: +9" across two different inputs would be
-- asserting a fact about the code from a comparison that has no subject --
-- which is the same defect as `pure False`, committed by the instrument
-- built to find it.
--
-- So: if the digest matches `markDigest`, the deltas below are a VERDICT
-- and growth exits 1.  If it does not, the deltas are INFORMATION, the
-- report says so in those words, and the exit is 0.  There is no third
-- outcome and no averaging of the two.  A comparison across a moved input
-- is not "a weak regression signal"; it is अवक्तव्यम् -- not unknown, not
-- undefined, not false, but the case where two standpoints (this tree and
-- the marked tree) are being asserted at once and no single predication
-- carries both.
--
-- THE MARK BELOW WAS TAKEN AGAINST A GIT REVISION, NOT A WORKING TREE, so
-- it is reproducible byte-for-byte by anyone, at any later date:
--
--     T=$(mktemp -d)
--     git archive 98ad555a machine | tar -x -C "$T"
--     (cd "$T" && runghc machine/Nasti_TruncationCensus.hs)
--
-- That run prints digest fnv1a:a438770021d42124 over 65 files and 20143
-- code lines, and the seven numbers in `baseline`.  A working tree in this
-- repository has more machine/*.hs than any commit does -- several lanes
-- keep uncommitted files there -- so a mark taken from `pwd` would have
-- been unreproducible on the day it was written.
--
-- To re-mark: check out the revision, run, paste the digest and the seven
-- numbers here, in the same commit, with the reason.
markDigest :: String
markDigest = "fnv1a:a438770021d42124"

markRev :: String
markRev = "rev 98ad555a; machine/ there, less this file: 65 files, 20143 code lines"

baseline :: [(Cat, Int)]
baseline =
  [ (Dvika,    280)
  , (Nirnaya,  154)
  , (KahNasti, 294)
  , (Ganana,   833)
  , (Cheda,    285)
  , (Sarvatra, 288)
  , (Vinasha,  221)
  ]

-- ---------------------------------------------------------------------
-- 6.  main
-- ---------------------------------------------------------------------

main :: IO ()
main = do
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8
  args <- getArgs
  let root = case args of (p : _) -> p; [] -> "machine"
  ok <- doesDirectoryExist root
  when (not ok) $ do
    putStrLn ("no such directory: " ++ root)
    exitFailure
  names <- listDirectory root
  -- THE INSTRUMENT IS NOT PART OF THE SPECIMEN, and this is not tidiness.
  -- This file lives in the directory it scans, so its own bytes are in the
  -- digest -- which means setting the mark CHANGES the thing the mark is
  -- against, and no mark can ever be stable.  Found by setting one and
  -- watching the reproduction disagree with the file that had just been
  -- written from it.  Excluding self makes the digest depend only on the
  -- code under audit, so editing the census (a new category, a better
  -- stripper, a moved mark) leaves the mark's subject untouched.
  --
  -- Recorded rather than fixed silently, because the failure has the same
  -- shape as everything this file counts: a measurement that includes the
  -- measurer, reported as though it were about the object.
  let self = "Nasti_TruncationCensus.hs"
      paths = [ root </> n | n <- names, ".hs" `isSuffixOf` n, n /= self ]
  loaded <- forM (sortBy (comparing id) paths) $ \p -> do
    h <- openFile p ReadMode
    hSetEncoding h utf8
    s <- hGetContents h
    length s `seq` return (p, s)

  let srcs = [ p ++ s | (p, s) <- loaded ]
      reports = [ scanFile p s | (p, s) <- loaded ]
      totalFor c = sum [ n | r <- reports, (c', n) <- frCat r, c' == c ]
      sitesTotal = sum (map totalFor [minBound ..])
      repairTotal = sum (map frRepair reports)
      codeTotal = sum (map frLines reports)

  putStrLn "======================================================================"
  putStrLn "नष्टि-गणना  ·  NAṢṬI CENSUS  ·  collapse sites in the machine's source"
  putStrLn "======================================================================"
  putStrLn ("  input      : " ++ root ++ "/*.hs   (TRACKED -- re-derivable from a clone)")
  putStrLn ("  files      : " ++ show (length reports))
  putStrLn ("  code lines : " ++ show codeTotal ++ "   (comments and strings stripped)")
  let digest = "fnv1a:" ++ showHex (fnv1a (concat srcs)) ""
  putStrLn ("  digest     : " ++ digest
            ++ "   (" ++ show (sum (map length srcs)) ++ " bytes read)")
  putStrLn   "               a mark in section 5 is a mark against THIS digest."
  putStrLn ""
  putStrLn "-- the vector.  It is not summed into a verdict; see the header. ------"
  putStrLn ""
  mapM_ (putStrLn . catLine totalFor) [minBound ..]
  putStrLn ""
  putStrLn ("  sites, summed (a convenience for the ratchet, not a finding): "
            ++ show sitesTotal)
  putStrLn ""
  putStrLn "-- प्रतिपक्षः · the repair, counted the same way and not subtracted ----"
  putStrLn ("  structured-verdict mentions (Verdict/Naya/Obstruction/... /Either): "
            ++ show repairTotal)
  putStrLn ""

  putStrLn "-- the ten files with the most sites.  A list, not a score. ----------"
  let byFile = sortBy (flip (comparing (\r -> sum (map snd (frCat r))))) reports
  mapM_ (\r -> putStrLn ("  " ++ pad 44 (frPath r)
                         ++ pad 7 (show (sum (map snd (frCat r))))
                         ++ "  repair " ++ show (frRepair r)))
        (take 10 byFile)
  putStrLn ""

  putStrLn "-- exemplar sites for द्विकः, the MathMachine:1743 shape --------------"
  let dvikaSites = [ (frPath r, n, l)
                   | r <- reports, (c, n, l) <- frSites r, c == Dvika ]
  mapM_ (\(p, n, l) -> putStrLn ("  " ++ p ++ ":" ++ show n ++ "   " ++ take 70 l))
        (take 12 dvikaSites)
  when (length dvikaSites > 12) $
    putStrLn ("  ... and " ++ show (length dvikaSites - 12) ++ " more.")
  putStrLn ""

  putStrLn "-- the ratchet (marks set 2026-08-20; see §5 of this file) ------------"
  let deltas = [ (c, totalFor c, b) | (c, b) <- baseline ]
      worse = [ d | d@(_, now, b) <- deltas, now > b ]
      better = [ d | d@(_, now, b) <- deltas, now < b ]
  mapM_ (\(c, now, b) ->
           let (dev, tr, _) = catName c
               arrow | now > b = "  ABOVE THE MARK  +" ++ show (now - b)
                     | now < b = "  below the mark  -" ++ show (b - now)
                     | otherwise = "  at the mark"
           in putStrLn ("  " ++ pad 14 dev ++ pad 12 tr
                        ++ pad 7 (show now) ++ "mark " ++ pad 7 (show b) ++ arrow))
        deltas
  putStrLn ""
  when (not (null better)) $
    putStrLn ("  " ++ show (length better)
              ++ " categor" ++ (if length better == 1 then "y" else "ies")
              ++ " below the mark.  MOVE THE MARK DOWN in this file.")
  if digest /= markDigest
    then do
      putStrLn "  THE INPUT IS NOT THE MARKED INPUT."
      putStrLn ("    marked : " ++ markDigest ++ "  (" ++ markRev ++ ")")
      putStrLn ("    read   : " ++ digest)
      putStrLn "  The deltas above are INFORMATION, not a verdict.  No"
      putStrLn "  regression claim is available from a comparison whose two"
      putStrLn "  sides are different trees; see the note on markDigest."
      putStrLn "  RESULT: no verdict (अवक्तव्यम्).  Exit 0."
      exitSuccess
    else if null worse
      then putStrLn "  RESULT: nothing above its mark." >> exitSuccess
      else do
        putStrLn ("  RESULT: " ++ show (length worse) ++ " above the mark.")
        putStrLn "  Either undo the collapse, or move the mark HERE, in the same"
        putStrLn "  commit, with the reason.  See the note on markDigest."
        exitFailure
  where
    catLine totalFor c =
      let (dev, tr, gloss) = catName c
      in "  " ++ pad 14 dev ++ pad 12 tr ++ pad 8 (show (totalFor c)) ++ gloss

-- A digest of exactly what was scanned.  `ObstructionCensus.hs` learned the
-- hard way that a count without its input is not quotable; here the input IS
-- tracked, but machine/ is edited by several lanes at once and two runs of
-- THIS census seconds apart already disagreed (dvika 306, then 308).  So the
-- report carries a fingerprint of the bytes it read, and a mark in §5 is a
-- mark against THAT fingerprint and no other.  FNV-1a, 64-bit: not a security
-- hash, an identity.
fnv1a :: String -> Word64
fnv1a = foldl step 14695981039346656037
  where step h c = (h `xor` fromIntegral (fromEnum c `mod` 256)) * 1099511628211

pad :: Int -> String -> String
pad n s = s ++ replicate (max 1 (n - length s)) ' '
