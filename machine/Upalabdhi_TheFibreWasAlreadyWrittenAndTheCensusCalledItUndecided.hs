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

-- Upalabdhi_TheFibreWasAlreadyWrittenAndTheCensusCalledItUndecided.hs
--
-- उपलब्धि · upalabdhi, "apprehension" — and its complement अनुपलब्धि,
-- non-apprehension, which the Bhāṭṭa Mīmāṃsakas admit as a pramāṇa only
-- under a fitness condition, योग्यानुपलब्धि: the absence of a pot proves the
-- pot's absence only where a pot, had it been there, WOULD HAVE BEEN SEEN.
--
-- THE TERM, ITS TEXT AND ITS DATE.  Kumārila Bhaṭṭa, *Ślokavārttika*,
-- अभावपरिच्छेद (the Abhāva chapter), c. 650 CE, arguing against the
-- Naiyāyikas that abhāva is a distinct means of knowledge and that its
-- validity turns on योग्यता — fitness of the perceptual situation.  The
-- repository already carries the complement at
-- `formal/pairfield/YogyaAnupalabdhi_TheAxiomCheckStatesWhereItCouldHaveSeen.lean`.
--
-- WHAT IS AND IS NOT CLAIMED.  Kumārila wrote no census, no grep and no
-- fibre.  Nothing here is attributed to the *Ślokavārttika* as mathematics.
-- What is borrowed is exactly one epistemic move, in its own sense: a
-- reported absence is worth nothing unless the instrument states where it
-- was looking.  `machine/Lopa_…hs` grades 1045 edges UNDECIDED; that is a
-- reported absence, and the detector that produced it was looking at one
-- line, at column zero, with one spacing.  The mathematics below is the
-- fibre of a map, which is cubical type theory (Voevodsky), this
-- repository's one admitted non-Indian substrate.
--
-- ─────────────────────────────────────────────────────────────────────────
-- WHAT THIS PROGRAM DOES, and what it refuses to do.
--
-- It sweeps `.agda` and `.lean` sources for declarations whose BODY is a
-- fibre already written out: a Σ over some source type whose second
-- component is an equation against a parameter.  For each it emits
--
--     source-type <TAB> index-type <TAB> module.name <TAB> shape
--
-- so that a join against `Lopa --queue` (`src <TAB> tgt <TAB> site`) can
-- ask, of every edge the census called undecided, whether its fibre is
-- already sitting in the corpus under another name.
--
-- **A MATCH IS A LEAD, NOT A HIT.**  Two declarations can carry the same
-- source and index type and be fibres of DIFFERENT maps —
-- `PingalaPrastara.Metre` (matrā-sum) and a laghu-count over the same
-- `Pattern → ℕ` are the standing counterexample, found and paid for on
-- 2026-08-21.  This program therefore prints `LEAD`, never `HIT`, and the
-- map itself is carried in the shape column so a reader can reject the
-- lead without opening the file.  Reporting a lead as a verdict is the
-- दुर्नय this apparatus exists against.
--
-- NO ALPHABET IS EVER NAMED.  A token is what is not whitespace; a name is
-- what is not a delimiter.  A previous pair of gates in this repository
-- matched module names with an explicit Latin character class and reported
-- seventeen Devanagari-named modules as orphans — the gate cried absence at
-- exactly the files whose names were not English.  Every scan below is
-- structural: bracket depth, delimiter position, whitespace.
--
-- Usage:  runghc machine/Upalabdhi_…hs [ROOT ...] [--tsv|--summary]
--         runghc machine/Upalabdhi_…hs --join QUEUE.tsv [ROOT ...]

module Main (main) where

import Control.Monad (forM, when, unless)
import Data.Char (isSpace)
import Data.List (isPrefixOf, isInfixOf, isSuffixOf, nub, sort, sortBy, intercalate)
import Data.Maybe (mapMaybe, fromMaybe, catMaybes)
import Data.Ord (comparing)
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import System.Directory (doesDirectoryExist, listDirectory, doesFileExist)
import System.Environment (getArgs)
import System.FilePath ((</>), takeExtension, takeBaseName)
import System.IO

-- ─────────────────────────────────────────────────────────── file walking

walk :: FilePath -> IO [FilePath]
walk p = do
  isDir <- doesDirectoryExist p
  if isDir
    then do
      kids <- listDirectory p
      concat <$> mapM (walk . (p </>)) (filter (not . hidden) kids)
    else do
      isF <- doesFileExist p
      return [ p | isF, takeExtension p `elem` [".agda", ".lean"] ]
  where hidden ('.':_) = True
        hidden n       = n `elem` [".git", "build", ".lake", "_build", "MAlonzo"]

-- ───────────────────────────────────────────────────── comment stripping
--
-- Line comments and block comments only.  Deliberately crude in one
-- direction: a `--` that begins a token starts a comment, a `--` inside a
-- token (`x--y`) does not.  Erring toward keeping text is safe here; this
-- program only ever proposes leads.

stripComments :: String -> String -> String
stripComments ext = unlines . map stripLine . unBlock . lines
  where
    lineTok = if ext == ".lean" then "--" else "--"
    stripLine l = go l True
      where
        go [] _ = []
        go s atBoundary
          | atBoundary && lineTok `isPrefixOf` s = []
          | otherwise = case s of
              (c:cs) -> c : go cs (isSpace c || c `elem` "([{,;")
              []     -> []
    unBlock ls = snd (foldl step (0 :: Int, []) ls)
      where
        step (d, acc) l = let (d', l') = scan d l in (d', acc ++ [l'])
        scan d ('{':'-':cs) = scan (d+1) cs
        scan d ('-':'}':cs) = scan (max 0 (d-1)) cs
        scan d (c:cs) = let (d', r) = scan d cs in (d', if d == 0 then c:r else ' ':r)
        scan d [] = (d, [])

-- ─────────────────────────────────────────────────── declaration chunking
--
-- A top-level declaration begins on a line whose first character is not
-- whitespace and which is not a pragma or an opening brace.  Continuation
-- lines are indented.  This is the layout rule both languages actually use.

data Chunk = Chunk { chLine :: Int, chText :: String } deriving Show

-- Block keywords whose BODY is an indented sequence of further top-level
-- declarations.  Without this the whole body of a `private` block, or of a
-- `module … where` whose contents are indented, arrives as ONE chunk, and a
-- `Σ[ … ≡ … ]` anywhere inside it is reported under the block's own name
-- with the rest of the file glued to it as its "index type".  That was the
-- first thing this program got wrong, and it got it wrong loudly enough to
-- be visible in the first twelve rows of output.
blockKeywords :: [String]
blockKeywords =
  [ "module", "private", "mutual", "abstract", "instance", "macro"
  , "namespace", "section", "variable", "postulate", "opaque" ]

chunks :: String -> [Chunk]
chunks src = go (indentOf' (zip [1..] (lines src)))
  where
    indentOf' = filter (not . null . trim . snd)
    go ls = concatMap expand (group ls)
      where
        base = case ls of ((_,l):_) -> indent l; _ -> 0
        group [] = []
        group ((n,l):rest) =
          let (body, more) = span (\(_,l') -> indent l' > indent l) rest
          in ((n,l):body) : group more
        expand grp@((n,l):body)
          | headTok (trim l) `elem` blockKeywords && not (null body) = go body
          | otherwise = [ Chunk n (intercalate " " (map (trim . snd) grp)) ]
        expand [] = []
    indent = length . takeWhile isSpace
    headTok = takeWhile (not . isSpace)

trim :: String -> String
trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse

-- ─────────────────────────────────────────────────────────── bracketing

-- Take the text up to the delimiter that closes the group opened by the
-- caller, honouring nesting of ( ) [ ] { } and the ⟨ ⟩ / Σ[ ] pairs.
takeBalanced :: String -> String
takeBalanced = go (0 :: Int) ""
  where
    go _ acc [] = reverse acc
    go d acc (c:cs)
      | c `elem` "([{"        = go (d+1) (c:acc) cs
      | c == ']' && d == 0    = reverse acc
      | c `elem` ")]}"        = go (max 0 (d-1)) (c:acc) cs
      | otherwise             = go d (c:acc) cs

-- Split on a top-level (depth-zero) occurrence of a multi-character marker.
splitTop :: String -> String -> [String]
splitTop mark = go (0 :: Int) ""
  where
    n = length mark
    go _ acc [] = [reverse acc]
    go d acc s@(c:cs)
      | d == 0 && mark `isPrefixOf` s = reverse acc : go 0 "" (drop n s)
      | c `elem` "([{"  = go (d+1) (c:acc) cs
      | c `elem` ")]}"  = go (max 0 (d-1)) (c:acc) cs
      | otherwise       = go d (c:acc) cs

-- ────────────────────────────────────────────────────────── normalisation
--
-- Strip module qualification from every token: the join key is the type as
-- written, not as addressed.  Lopa prints `⟨lib⟩.List ⟨lib⟩.ℕ`; a source
-- file writes `List ℕ`.  A token's qualification is everything up to and
-- including its last '.', when what follows the '.' is non-empty.

unqualify :: String -> String
unqualify t = case break (== '.') (reverse t) of
  (revLast, _:_) | not (null revLast) -> reverse revLast
  _ -> t

normType :: String -> String
normType = unwords . map unqualify . words . map degroup . trim
  where degroup c = if c `elem` "()" then ' ' else c

-- ─────────────────────────────────────────────────────────────── the scan

data Lead = Lead
  { ldSrcTy :: String
  , ldIdxTy :: String
  , ldSite  :: String
  , ldShape :: String
  , ldMap   :: String   -- head of the LHS of the equation: the map itself
  , ldFile  :: FilePath
  , ldLine  :: Int
  } deriving (Eq, Show)

moduleOf :: FilePath -> String -> String
moduleOf fp src =
  case [ trim (takeWhile (/= ' ') (trim (drop 6 l)))
       | l <- lines src, "module " `isPrefixOf` l ] of
    (m:_) | not (null m) -> m
    _ -> takeBaseName fp

-- Last hypothesis of a signature: split the type on top-level arrows, drop
-- the result, take the final argument, and if it is a named telescope
-- binder `(n : ℕ)` take the type after the colon.
lastHypothesis :: String -> Maybe String
lastHypothesis ty =
  let ps = map trim (splitTop "→" ty)
      ps' = concatMap (splitTop "->") ps
      qs = map trim ps'
  in case reverse qs of
       (_res : arg : _) -> Just (afterColon arg)
       _ -> Nothing
  where
    afterColon a =
      let inner = trim (dropWhile (`elem` "({") (reverse (dropWhile (`elem` ")}") (reverse (trim a)))))
      in case splitTop ":" inner of
           [_, t] -> trim t
           _      -> trim a

-- The source type of a `Σ[ x ∈ A ]`, if the binder names one.
sigmaSource :: String -> Maybe String
sigmaSource t = case findSub "Σ[" t of
  Nothing -> Nothing
  Just rest ->
    let grp = takeBalanced rest
    in case splitTop "∈" grp of
         [_, a] -> Just (trim a)
         _      -> Nothing

-- THE MAP, and it is the column that turns a coincidence into a lead.
-- Two fibres over the same source and index types need not be fibres of the
-- same map: `PingalaPrastara.Metre` sums morae and `MatraVarnaGuru.लघु-सङ्ख्या`
-- counts laghus, both `Pattern → ℕ`, and on 2026-08-21 the first lead ever
-- checked in this lane was exactly that pair and it FAILED.  So the head of
-- the equation's left-hand side is carried out with the lead, and a join
-- that can compare it says so.
mapHead :: String -> String -> String
mapHead eqMark b =
  let afterBinder = case findSub "]" b of
                      Just r  -> r
                      Nothing -> b
  in case splitTop eqMark afterBinder of
       (lhs:_:_) -> case words (map degroup (trim lhs)) of
                      (w:_) -> unqualify w
                      _ -> "?"
       _ -> "?"
  where degroup c = if c `elem` "()" then ' ' else c

findSub :: String -> String -> Maybe String
findSub m s
  | m `isPrefixOf` s = Just (drop (length m) s)
  | null s = Nothing
  | otherwise = findSub m (tail s)

-- What stands on the right of the last top-level `≡` (or `=` in Lean).
rhsOfEq :: String -> String -> Maybe String
rhsOfEq eqMark t = case splitTop eqMark t of
  ps@(_:_:_) -> Just (trim (last ps))
  _ -> Nothing

shapeOf :: String -> String -> String
shapeOf ext body
  | "record " `isPrefixOf` body && hasEq = "record-eq"
  | "data " `isPrefixOf` body && hasEq   = "data-eq"
  | negatedEq                            = "sigma-neq"
  | "Σ[" `isInfixOf` body && hasEq       = "sigma-eq"
  | "Σ" `isInfixOf` body && hasEq        = "sigma-bare-eq"
  | fibreWord                            = "fiber-alias"
  | "//" `isInfixOf` body && hasEq       = "subtype-eq"
  | "Subtype" `isInfixOf` body && hasEq  = "subtype-eq"
  | hasEq                                = "eq-body"
  | otherwise                            = "?"
  where
    hasEq | ext == ".lean" = "=" `isInfixOf` body
          | otherwise      = "≡" `isInfixOf` body
    negatedEq = hasEq && ("¬" `isInfixOf` body || "≢" `isInfixOf` body)
    fibreWord = "fiber" `isInfixOf` body || "fibre" `isInfixOf` body

scanFile :: FilePath -> IO [Lead]
scanFile fp = do
  raw <- readFileUtf8 fp
  let ext  = takeExtension fp
      src  = stripComments ext raw
      modn = moduleOf fp raw
      cs   = chunks src
      -- signature table: `name : type`
      sigs = M.fromList
        [ (nm, ty)
        | Chunk _ t <- cs
        , let ws = words t
        , (nm:rest) <- [ws]
        , (":" : _) <- [rest]
        , let ty = trim (drop 1 (dropWhile (/= ':') t))
        , not (null nm), not (null ty) ]
      eqMark = if ext == ".lean" then "=" else "≡"
  return (mapMaybe (leadOf ext modn sigs eqMark fp) cs)

leadOf :: String -> String -> M.Map String String -> String -> FilePath -> Chunk -> Maybe Lead
leadOf ext modn sigs eqMark fp (Chunk ln t0) =
  let nm0 = takeWhile (not . isSpace) (trim t0)
      -- A `where` block hangs off a definition at deeper indentation and so
      -- arrives glued to its parent.  Its contents are that definition's
      -- LOCAL lemmas; a Σ inside one belongs to a name this program cannot
      -- address, and gluing it on makes the parent's "index type" the rest
      -- of the file.  Cut it, except on `record`/`data`, whose body is the
      -- declaration.
      t = case splitTop " where " t0 of
            (h:_:_) | nm0 `notElem` ["record","data"] -> h
            _ -> t0
      ws = words t
  in case ws of
    [] -> Nothing
    (nm:rest) ->
      let isSig = take 1 rest == [":"]
          -- body of a definition: everything after the first top-level '='
          defBody = case splitTop "=" t of
                      (_:bs@(_:_)) -> Just (trim (intercalate "=" bs))
                      _ -> Nothing
          isDecl = nm `elem` ["record", "data"]
          body = if isDecl then Just t else defBody
      in if isSig then Nothing else do
        b <- body
        let sh = shapeOf ext b
        if sh == "?" || sh == "eq-body" then Nothing else do
          -- a fibre must actually be a Σ / subtype / record / data / alias
          let srcTy = fromMaybe (fromMaybe "?" (subtypeSource b)) (sigmaSource b)
              name  = if isDecl then (case rest of (n:_) -> n; _ -> nm) else nm
              sigTy = M.lookup name sigs
              idxFromSig = sigTy >>= lastHypothesis
              idxFromRhs = rhsOfEq eqMark b
              -- A type expression that runs to more than a few tokens is not
              -- a type this program recovered; it is the parse running off
              -- the end of the declaration.  Say `?` rather than emit a key
              -- that can never match and inflate the denominator.
              sane x = let n = length (words x) in n >= 1 && n <= 4
              idxTy = fromMaybe "?" (firstJust (filter (maybe False sane)
                                       [idxFromSig, idxFromRhs]))
          if srcTy == "?" && sh `notElem` ["record-eq","data-eq","fiber-alias"]
            then Nothing
            else Just (Lead (normType srcTy) (normType idxTy)
                            (modn ++ "." ++ name) sh (mapHead eqMark b) fp ln)
  where
    firstJust xs = case catMaybes xs of (y:_) -> Just y; _ -> Nothing
    subtypeSource b = case findSub "{" b of
      Nothing -> Nothing
      Just r -> case splitTop "//" (takeBalanced' r) of
        [l, _] -> case splitTop ":" l of
                    [_, ty] -> Just (trim ty)
                    _ -> Nothing
        _ -> Nothing
    takeBalanced' = go (0 :: Int) ""
      where go _ acc [] = reverse acc
            go d acc (c:cs)
              | c `elem` "([{" = go (d+1) (c:acc) cs
              | c == '}' && d == 0 = reverse acc
              | c `elem` ")]}" = go (max 0 (d-1)) (c:acc) cs
              | otherwise = go d (c:acc) cs

readFileUtf8 :: FilePath -> IO String
readFileUtf8 fp = do
  h <- openFile fp ReadMode
  hSetEncoding h utf8
  s <- hGetContents h
  length s `seq` return s

-- ────────────────────────────────────────────────────────────────── main

main :: IO ()
main = do
  hSetEncoding stdout utf8
  args <- getArgs
  let flags = filter ("--" `isPrefixOf`) args
      pos   = filter (not . ("--" `isPrefixOf`)) args
      joinQ = case dropWhile (/= "--join") args of
                (_:q:_) -> Just q
                _ -> Nothing
      roots0 = [ p | p <- pos, Just p /= joinQ ]
      roots = if null roots0
                then ["formal/cubical", "punaragamana/src", "formal/pairfield"]
                else roots0
  files <- concat <$> mapM walk roots
  leads <- concat <$> mapM scanFile files
  case joinQ of
    Nothing -> do
      when ("--summary" `elem` flags) $ do
        let byShape = M.fromListWith (+) [ (ldShape l, 1 :: Int) | l <- leads ]
        putStrLn ("files scanned: " ++ show (length files))
        putStrLn ("leads: " ++ show (length leads))
        mapM_ (\(k,v) -> putStrLn ("  " ++ show v ++ "  " ++ k))
              (sortBy (flip (comparing snd)) (M.toList byShape))
      unless ("--summary" `elem` flags) $
        mapM_ (\l -> putStrLn (intercalate "\t"
                 [ldSrcTy l, ldIdxTy l, ldSite l, ldShape l, ldMap l,
                  ldFile l ++ ":" ++ show (ldLine l)])) leads
    Just q -> do
      qraw <- readFileUtf8 q
      let qrows = [ (normType a, normType b, c)
                  | l <- lines qraw
                  , let fs = splitOn '\t' l
                  , [a,b,c] <- [fs] ]
          -- INSTRUMENT CHECK, and it is not optional.  A join that returns
          -- zero has two explanations and only one of them is a fact about
          -- the corpus.  Print both sides' key sets before printing the
          -- intersection.
          idx = M.fromListWith (++) [ ((ldSrcTy l, ldIdxTy l), [l]) | l <- leads ]
      putStrLn ("── INSTRUMENT CHECK ──")
      putStrLn ("  queue rows parsed:        " ++ show (length qrows))
      putStrLn ("  leads found:              " ++ show (length leads))
      putStrLn ("  distinct lead keys:       " ++ show (M.size idx))
      putStrLn ("  distinct queue keys:      " ++ show (S.size (S.fromList [ (a,b) | (a,b,_) <- qrows ])))
      putStrLn ""
      let hits = [ (s,t,site,l)
                 | (s,t,site) <- qrows
                 , l <- fromMaybe [] (M.lookup (s,t) idx) ]
      -- TWO GRADES OF LEAD, and the weaker one is mostly noise.
      --   NAMED-MAP  the fibre's equation applies the very map the queue
      --              edge is about — the head of the LHS is the edge's own
      --              declaration name.  Still a lead: the same name can be
      --              re-bound locally, and an alias is not an identity.
      --   TYPE-ONLY  the source and index types agree and nothing else does.
      --              On common banks (ℕ → Bool, List ℕ → ℕ) this is a
      --              coincidence of arity, and the census is right to have
      --              withheld.  Printed, because a human reading twenty of
      --              them finds the one the types alone could not rank.
      let named (_,_,site,l) = ldMap l /= "?" && ldMap l == unqualify site
          (strong, weak) = (filter named hits, filter (not . named) hits)
          row grade (s,t,site,l) = intercalate "\t"
               [grade, s, t, site, ldSite l, ldShape l, ldMap l,
                ldFile l ++ ":" ++ show (ldLine l)]
      putStrLn ("── LEADS (a match is a LEAD, not a HIT) ──")
      mapM_ (putStrLn . row "NAMED-MAP") strong
      mapM_ (putStrLn . row "TYPE-ONLY") weak
      putStrLn ""
      putStrLn ("  edges with at least one lead: "
                ++ show (S.size (S.fromList [ site | (_,_,site,_) <- hits ]))
                ++ " of " ++ show (length qrows))
      putStrLn ("  of those, NAMED-MAP:          "
                ++ show (S.size (S.fromList [ site | h@(_,_,site,_) <- hits, named h ])))
      putStrLn ("  lead pairs: " ++ show (length hits)
                ++ "  (NAMED-MAP " ++ show (length strong)
                ++ ", TYPE-ONLY " ++ show (length weak) ++ ")")

splitOn :: Char -> String -> [String]
splitOn c s = case break (== c) s of
  (a, _:r) -> a : splitOn c r
  (a, [])  -> [a]
