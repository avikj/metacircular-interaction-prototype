-- TraceLibrary — the machine's own proofs, read back and made citable.
--
-- WHAT THIS IS FOR.
--
-- `MathMachine.tryReplay` renders a complete Agda module for every goal the
-- trace replayer closes, the kernel checks it, and until 2026-08-18 the
-- machine threw the source away and logged the words "trace replay".  That
-- path is 820 of 2362 `KERNEL-ACCEPT` lines — the plurality — and it is
-- exactly the path `KernelContext.proofOfNaya` refuses with
-- `NoTacticRecorded "trace replay"`, because `library.terms` records THAT a
-- trace was replayed and not the trace.
--
-- The sources are now kept (`machine/replay.traces`).  This module reads them
-- back and turns them into something a later goal can CITE.
--
-- WHY THAT MATTERS, in one line: every one of those records contains
--
--     addZero : (a : ℕ) → (a + zero) ≡ a
--
-- proved by induction — the lemma the residual stream demanded 27 times and
-- the seam dropped as a machine axiom.  `formal/cubical/SeamClosed.agda`
-- discharges the flagship residual with it, but by HAND-TRANSCRIPTION, which
-- is a demonstration and not a mechanism.  This module is the mechanism.
--
-- WHAT A RECORD LOOKS LIKE.  `MathMachine.recordTrace` writes
--
--     -- TRACE <lhs>\t<rhs>
--     {-# OPTIONS ... #-}
--     module Candidate where
--     <imports>
--     <helper lemmas: addZero, addSuc, addAssoc, mulZero, mulSuc, lem0..lemN>
--     candidate : <the claim>
--     <the proof>
--     -- END TRACE
--
-- A record splits into a CORE that every record shares (imports, addZero,
-- addSuc, addAssoc, mulZero, mulSuc), a per-record block of `lem0 .. lemN` --
-- the previously-known lemmas the replayer chose to cite for THIS goal -- and
-- the proof, always named `candidate`.
--
-- The first version of this module assumed the whole preamble was shared.
-- `selfTest` answered "records disagree on the helper preamble: 16 of 17",
-- which is the module catching its own author before the corpus did.
--
-- WHAT IS NOT DONE HERE, said plainly.  This is not wired into
-- `MathMachine.hs`.  It reads the corpus and renders a module; making the
-- round loop consult it before submitting a goal is the next change and is a
-- change to the engine, not to this file.

module TraceLibrary
  ( Record(..)
  , parseTraces
  , sharedPreamble
  , tailOf
  , renderCitable
  , renderCorpus
  , declBlocks
  , selfTest
  ) where

import Data.List (isPrefixOf, isInfixOf, nub, intercalate)
import Data.Char (isSpace, isAlphaNum)
import System.IO (openFile, hSetEncoding, hGetContents, utf8, IOMode(ReadMode))

-- claim as the machine writes it (prefix notation, tab-separated), plus the
-- full module text the kernel accepted
data Record = Record
  { recLhs  :: String
  , recRhs  :: String
  , recBody :: [String]     -- the module text, without the TRACE delimiters
  } deriving (Eq, Show)

-- ------------------------------------------------------------------ parsing

parseTraces :: String -> [Record]
parseTraces = go . lines
  where
    go [] = []
    go (l : ls)
      | "-- TRACE " `isPrefixOf` l =
          let hdr = drop (length "-- TRACE ") l
              (lhs, rest) = break (== '\t') hdr
              rhs = drop 1 rest
              (body, after) = break (== "-- END TRACE") ls
          in Record lhs rhs body : go (drop 1 after)
      | otherwise = go ls

-- ------------------------------------------------------- splitting a record
--
-- The preamble is everything up to the `candidate` declaration; the body is
-- `candidate` and what follows.  Both are taken by position rather than by
-- pattern-matching on lemma names, because the replayer's helper set is not
-- fixed and hardcoding it here would silently drop any helper it gains.

splitAtCandidate :: [String] -> ([String], [String])
splitAtCandidate = break (\l -> "candidate " `isPrefixOf` l
                             || "candidate:" `isPrefixOf` l)

-- THE PREAMBLE IS NOT CONSTANT, and the first version of this module assumed
-- it was.  `selfTest` reported "records disagree on the helper preamble: 16 of
-- 17" and that was the module catching its own author: the replayer emits a
-- FIXED core (imports, addZero, addSuc, addAssoc, mulZero, mulSuc) followed by
-- `lem0 … lemN`, the previously-known lemmas it chose to cite for THIS goal,
-- which naturally differ per record.
--
-- So the core is the longest common prefix across all records, and everything
-- after it is per-record and must be renamed before several records can share
-- one module.
sharedPreamble :: [Record] -> Either String [String]
sharedPreamble [] = Left "no trace records"
sharedPreamble recs = Right (foldr1 lcp (map (fst . splitAtCandidate . recBody) recs))
  where
    lcp (a : as) (b : bs) | a == b = a : lcp as bs
    lcp _ _ = []

-- Everything of a record that is NOT in the common core: its own cited lemmas
-- plus its proof.  Every identifier the record introduces (`candidate`, and
-- any `lemN`) is prefixed, so two records citing different `lem0`s do not
-- collide.  Renaming is token-level rather than textual, so `lem0` inside a
-- longer name is untouched.
bodyOf :: String -> Record -> [String]
bodyOf prefix r = map (concatMap ren . tokens) (drop core (recBody r))
  where
    core = length (takeWhile id
             (zipWith (==) (fst (splitAtCandidate (recBody r)))
                           (either (const []) id (sharedPreamble [r]))))
           -- for a single record the "common core" is its whole preamble, so
           -- the caller passes the corpus-wide core in `renderCitable` instead
    ren w | w == "candidate" = prefix
          | isLem w          = prefix ++ w
          | otherwise        = w
    isLem ('l':'e':'m':ds) = not (null ds) && all (`elem` "0123456789") ds
    isLem _ = False

tokens :: String -> [String]
tokens [] = []
tokens s@(c : _)
  | isAlphaNum c || c == '_' =
      let (w, rest) = span (\x -> isAlphaNum x || x == '_') s in w : tokens rest
  | otherwise =
      let (w, rest) = break (\x -> isAlphaNum x || x == '_') s in w : tokens rest

-- the part of a record after the corpus-wide common core, renamed
tailOf :: Int -> String -> Record -> [String]
tailOf coreLen prefix r =
    map (concatMap ren . tokens) (drop coreLen (recBody r))
  where
    ren w | w == "candidate" = prefix
          | isLem w          = prefix ++ w
          | otherwise        = w
    isLem ('l':'e':'m':ds) = not (null ds) && all (`elem` "0123456789") ds
    isLem _ = False

-- ------------------------------------------------- declaration-level split
--
-- The prefix approach above is exact only when the selected records share a
-- helper block, and the corpus does not.  Splitting into NAMED DECLARATIONS
-- instead makes the sharing question decidable per lemma rather than per
-- position: a declaration that every record spells identically is emitted
-- once, and one that records spell differently is renamed per record.
--
-- A declaration is a top-level `name : type` line plus every following line
-- until the next top-level declaration.  Import and pragma lines are handled
-- separately by `importLines`.

isDeclHead :: String -> Maybe String
isDeclHead l = case words l of
  (n : ":" : _) | not (" " `isPrefixOf` l)
                , all (\c -> isAlphaNum c || c == '_') n
                , not (null n) -> Just n
  _ -> Nothing

declBlocks :: [String] -> [(String, [String])]
declBlocks = go . dropWhile (\l -> isNothingHead l)
  where
    isNothingHead l = case isDeclHead l of
      Just _ -> False
      Nothing -> True
    go [] = []
    go (l : ls) = case isDeclHead l of
      Nothing -> go ls
      Just n -> let (rest, more) = break (\x -> isDeclHead x /= Nothing) ls
                in (n, l : rest) : go more

importLines :: [Record] -> [String]
importLines recs = nub [ l | r <- recs, l <- recBody r, "open import " `isPrefixOf` l ]

-- ---------------------------------------------------------------- rendering
--
-- One module: the shared helper block once, then each selected record as a
-- named lemma, then whatever the caller wants to state with them in scope.
-- THE WHOLE CORPUS IN ONE MODULE, by deduplicating declarations.
--
-- Every declaration name is classified: SHARED if all records that define it
-- spell it identically (emitted once, under its own name, so `addZero` is
-- literally `addZero` and a later goal cites it by that name), or CONTESTED if
-- they differ (emitted once per record under a prefixed name).  `candidate` is
-- always per-record.  Nothing is dropped and nothing is guessed.
renderCorpus :: String -> [Record] -> [(String, String)] -> String
renderCorpus modName recs goals = unlines $
     -- `--guardedness` added 2026-08-20: Agda's [InfectiveImport] rule makes it
     -- propagate, so a module opening Cubical.Foundations.Prelude without it fails
     -- at SCOPE-CHECKING under a cubical library compiled with it (Agda 2.8.0).
     -- Kept equal to Certificate.kOptionsPragma by
     -- scripts/Anuvrtti_TheOptionsLineIsSaidOnceAndContinues.sh.
     [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
     , ""
     , "-- GENERATED by machine/TraceLibrary.hs from machine/replay.traces."
     , "-- Do not hand-edit; regenerate."
     , "--"
     , "-- " ++ show (length recs) ++ " trace records, "
       ++ show (length shared) ++ " shared declarations, "
       ++ show (length contestedNames) ++ " contested."
     , "-- Every line below is the machine's own trace-replay output, which the"
     , "-- kernel had already accepted and the machine had already discarded."
     , ""
     , "module " ++ modName ++ " where"
     , "" ]
  ++ importLines recs
  ++ concat [ "" : b | (_, b) <- shared ]
  ++ concat [ "" : ("-- from the trace for  " ++ recLhs r ++ " = " ++ recRhs r)
                  : renameBlocks pfx r
            | (pfx, r) <- zip prefixes recs ]
  ++ concat [ ["", "-- " ++ why, decl] | (why, decl) <- goals ]
  where
    prefixes = [ "t" ++ show i ++ "_" | i <- [(0 :: Int) ..] ]
    allBlocks = [ (n, b) | r <- recs, (n, b) <- declBlocks (recBody r) ]
    byName n = nub [ b | (m, b) <- allBlocks, m == n ]
    names = nub (map fst allBlocks)
    -- IDENTICAL IS NOT ENOUGH, and Agda said so: `lem0 not in scope`.
    --
    -- A block can be spelled identically by every record that defines it and
    -- still REFER to a name that records spell differently.  Emitting it once,
    -- unrenamed, then leaves it citing a `lem0` that exists only under
    -- per-record names.  Shareability is therefore a fixpoint, not a per-block
    -- test: a declaration is shared when it is identical AND every corpus
    -- declaration it mentions is itself shared.
    identical = [ n | n <- names, n /= "candidate", length (byName n) == 1 ]
    mentions n = nub [ w | (m, b) <- allBlocks, m == n
                         , l <- b, w <- tokens l, w `elem` names ]
    sharedNames = fixpoint identical
      where
        fixpoint cur =
          let next = [ n | n <- cur
                         , all (\w -> w == n || w `elem` cur) (mentions n) ]
          in if next == cur then cur else fixpoint next
    contestedNames = [ n | n <- names, n /= "candidate"
                         , n `notElem` sharedNames ]
    shared = [ (n, head (byName n)) | n <- sharedNames ]
    -- a record contributes only what is not already shared, renamed
    renameBlocks pfx r =
      concat [ map (concatMap (ren pfx) . tokens) b
             | (n, b) <- declBlocks (recBody r)
             , n == "candidate" || n `elem` contestedNames ]
    ren pfx w | w == "candidate" = pfx
              | w `elem` contestedNames = pfx ++ w
              | otherwise = w

renderCitable :: String -> [Record] -> [(String, String)] -> Either String String
renderCitable modName recs goals = do
  pre <- sharedPreamble recs
  let hdr = [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
            , ""
            , "-- GENERATED by machine/TraceLibrary.hs from machine/replay.traces."
            , "-- Do not hand-edit; regenerate.  Every lemma below is the machine's"
            , "-- own trace-replay output, which the kernel had already accepted and"
            , "-- the machine had already discarded."
            , ""
            , "module " ++ modName ++ " where" ]
      -- drop the record's own OPTIONS/module lines; keep its imports
      preKeep = [ l | l <- pre
                    , not ("{-# OPTIONS" `isPrefixOf` l)
                    , not ("module " `isPrefixOf` l) ]
      lemmas = concat [ ("" : ("-- from the trace for  " ++ recLhs r ++ " = " ++ recRhs r)
                              : tailOf (length pre) nm r)
                      | (nm, r) <- zip lemNames recs ]
      lemNames = [ "trace" ++ show i ++ "_" | i <- [(0 :: Int) ..] ]
      stated = concat [ ["", "-- " ++ why, decl] | (why, decl) <- goals ]
      out = hdr ++ [""] ++ preKeep ++ lemmas ++ stated
  -- REFUSE RATHER THAN EMIT SOMETHING THAT WILL NOT CHECK.
  --
  -- The core is the longest common PREFIX, which is exact when the selected
  -- records share their helper block and degrades when they do not: over all
  -- 17 records of the present corpus the common prefix is 4 lines, so a wide
  -- selection would re-emit `addZero` once per record and Agda would refuse
  -- the module for duplicate definitions.
  --
  -- Emitting it anyway and letting the kernel find out would make a rendering
  -- limit look like a mathematical failure -- which is exactly the collapse
  -- `KernelContext` keeps separate with its three-way verdict.  So the clash
  -- is detected here and named.
  case duplicateDecls out of
    [] -> Right (unlines out)
    ds -> Left ("records do not share a helper core; these would be defined \
                \more than once: " ++ intercalate ", " ds
                ++ ".  Select records with a common prefix, or teach this \
                   \module to dedup by declaration rather than by prefix.")

-- top-level declaration names occurring more than once
duplicateDecls :: [String] -> [String]
duplicateDecls ls = nub [ n | n <- names, length (filter (== n) names) > 1 ]
  where
    names = [ n | l <- ls
                , not (" " `isPrefixOf` l)
                , (n : ":" : _) <- [words l]
                , all (\c -> isAlphaNum c || c == '_') n ]

-- ----------------------------------------------------------------- selftest

selfTest :: IO Bool
selfTest = do
    h <- openFile "machine/replay.traces" ReadMode
    hSetEncoding h utf8
    txt <- hGetContents h
    let recs = parseTraces txt
    putStrLn ("  records parsed: " ++ show (length recs))
    let withAddZero = length [ () | r <- recs
                                  , any ("addZero :" `isPrefixOf`) (recBody r) ]
    putStrLn ("  records containing addZero: " ++ show withAddZero
              ++ " of " ++ show (length recs))
    case sharedPreamble recs of
      Left err -> putStrLn ("  FAIL shared preamble: " ++ err) >> pure False
      Right pre -> do
        putStrLn ("  shared helper preamble: " ++ show (length pre) ++ " lines")
        let names = [ w | l <- pre, (w : ":" : _) <- [words l] ]
        putStrLn ("  helper lemmas: " ++ intercalate ", " (nub names))
        -- every record must actually carry a proof of its own claim
        let bodied = length [ () | r <- recs, not (null (snd (splitAtCandidate (recBody r)))) ]
        putStrLn ("  records with a candidate body: " ++ show bodied
                  ++ " of " ++ show (length recs))
        let ok = not (null recs) && withAddZero == length recs
                 && bodied == length recs
        putStrLn ("  all records usable: " ++ show ok)
        pure ok

-- ---------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above.  Pointer only; nothing here corrects this module.
--
-- `sharedPreamble = foldr1 lcp` is not a conservative guess, and the
-- alternative it replaced does not exist as an object.  Checked in
-- `formal/cubical/NaturalMachine/TheSharedPreambleIsACommonPrefixNotACommonSet.agda`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin):
--
--   lcpPrefixLeft / lcpPrefixRight / lcpGreatest
--       the longest common prefix IS the GREATEST common prefix -- a
--       meet, not a heuristic.
--
--   commonPrefixIsEmpty / neitherOrderingServesBoth
--       two records carrying exactly the same declarations in opposite
--       orders share NO prefix, and neither ordering of the shared pair
--       is a prefix of both.  So "take the declarations both records
--       share" is not a preamble at all: a preamble is a SEQUENCE whose
--       later lemmas may cite earlier ones, and a set must be ordered
--       before it can be one.
--
-- Which is why the selfTest's "records disagree on the helper preamble:
-- 16 of 17" was a symptom of a notion that does not exist, not merely of
-- an optimistic assumption -- and why lcp is forced rather than chosen.
--
-- The declaration names in that module (addZero, addSuc) are this file's
-- own.  NOT restated there: the 16-of-17 figure, which is a count over
-- machine/replay.traces and belongs to this module.  NOT claimed there:
-- anything about how MUCH lcp finds in practice -- only about order.
-- ---------------------------------------------------------------------
