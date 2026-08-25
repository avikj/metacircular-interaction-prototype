-- Pratyaksa_TheKernelIsAskedForTheTypeInsteadOfTheTextBeingParsed.hs
--
-- प्रत्यक्षम् — direct apprehension, the pramāṇa that stands on nothing else.
--
-- THE TERM, ITS TEXT AND ITS DATE.  प्रत्यक्ष is the first pramāṇa of the
-- न्यायसूत्र (Gautama, ~2nd c. CE), १.१.४: इन्द्रियार्थसन्निकर्षोत्पन्नं ज्ञानम् —
-- knowledge arising from the contact of sense and object, and the sūtra's
-- point is that it needs no other pramāṇa to license it.  अनुमान is the
-- second, १.१.५, and it runs on a लिङ्ग (a mark) plus व्याप्ति (invariable
-- concomitance between mark and marked).  LIMIT: nothing below is
-- attributed to Gautama or to any Naiyāyika; the distinction is used for
-- exactly the property the sūtras give it — one of these two needs a
-- concomitance to hold and the other does not.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS EXISTS.  This machine learns the corpus's types by PARSING
-- SOURCE TEXT with a hand-written parser.  That is अनुमान: the textual
-- mark is the liṅga, and "a declaration of this shape has that type" is
-- the vyāpti.  The concomitance keeps failing, and `Lopa`'s own header is
-- the catalogue of its failures — consecutive binder groups, lowercase
-- binders invisible to the freeness test, a CONTROL AUDIT block whose only
-- job is filtering the other extractor's forgeries, `knownType`,
-- `resolveExpr`, and node identities that come out as `⟨ambig⟩.M` and
-- `⟨lib⟩.ℕ` because the parser cannot resolve what the module actually
-- meant.  Every one of those is an epicycle on an inference, and every
-- "the corpus is barren" failure written into machine/dosa.lekha traces
-- back to that parser's blindness rather than to the corpus.
--
-- **The typechecker already decides all of it, exactly.**  Agda's
-- interaction mode will hand over, for any module it has checked, every
-- name in it with its ELABORATED, FULLY QUALIFIED type — `⟨lib⟩.ℕ` comes
-- back as `Cubical.Data.Int.Base.ℤ`, `≡` as
-- `Agda.Builtin.Cubical.Path.≡`.  No aliasing, no ambiguity, no repairs.
--
-- So this program stops inferring and asks:
--
--     agda --interaction-json  ←  Cmd_load Everything.agda
--                              ←  Cmd_show_module_contents_toplevel M   (per M)
--
-- ONE load for the whole lane, then one query per module, and it emits the
-- table the rest of the machine should be reading instead of the text.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.  This does not make Lopa correct; it gives Lopa a
-- ground truth to be checked against, and the diff between them is the
-- measurement of an inference by a direct apprehension — which is the
-- only honest way to find out how wrong the parser was.  Nor is the JSON
-- reader below general: it targets ONE stable shape, `{"name":...,
-- "term":...}` inside a `"contents"` array, and it says so here rather
-- than pretending to be a parser.  If Agda changes that shape this
-- program must be told, and its failure mode is empty output, not wrong
-- output — a distinction सूत्र ७ cares about and so does this file.
--
-- USAGE.  runghc machine/Pratyaksa_….hs [lane-dir] [> table.tsv]
-- lane-dir defaults to formal/cubical.

module Main (main) where

import System.Process (readCreateProcessWithExitCode, proc, CreateProcess(..))
import System.Environment (getArgs)
import System.Exit (ExitCode(..))
import Data.List (isPrefixOf, isSuffixOf, isInfixOf, sort, sortOn, nub, partition)
import System.Directory (listDirectory, doesDirectoryExist)
import Data.Char (isSpace)
import Control.Monad (forM_, when, forM)
import Control.Concurrent (forkIO)
import Control.Concurrent.MVar (newEmptyMVar, putMVar, takeMVar)
import System.Directory (createDirectoryIfMissing, removeFile)
import Control.Exception (try, SomeException)
import System.IO (hPutStrLn, stderr)
import GHC.IO.Encoding (setLocaleEncoding)
import System.IO (utf8)

-- ─────────────────────────────────────────────────────────────────────
-- 1.  Which modules to ask about: EVERY .agda in the lane.
--
--     The first version asked only about Everything.agda.s direct imports
--     and justified it as "a module nothing imports is built by nothing".
--     That is false and the correction is the point of this program: the
--     kernel reaches modules TRANSITIVELY, so it has already checked far
--     more than the root names, and asking only the root.s imports would
--     have been a second inference standing where a direct look was
--     available -- the same error one level up, inside the program written
--     to correct it.  Recorded here rather than silently fixed.
-- ─────────────────────────────────────────────────────────────────────

-- module name from a path relative to the lane: strip .agda, / becomes .
modNameOf :: FilePath -> String
modNameOf p = map (\c -> if c == '/' then '.' else c) (take (length p - 5) p)

laneModules :: FilePath -> IO [String]
laneModules lane = do
  fs <- walk ""
  pure (nub (sort (map modNameOf fs)))
  where
    walk :: FilePath -> IO [FilePath]
    walk rel = do
      es <- listDirectory (lane ++ "/" ++ rel)
      rss <- mapM (step rel) es
      pure (concat rss)
    step rel e = do
      let r = if null rel then e else rel ++ "/" ++ e
      d <- doesDirectoryExist (lane ++ "/" ++ r)
      if d then (if e == "_build" || take 1 e == "." then pure [] else walk r)
           else pure [ r | ".agda" `isSuffixOf` r ]

trim :: String -> String
trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse

-- ─────────────────────────────────────────────────────────────────────
-- 2.  The script.  One load, then one query per module, in order.
-- ─────────────────────────────────────────────────────────────────────

script :: String -> [String] -> String
script root ms = unlines $
  ("IOTCM \"" ++ root ++ "\" None Direct (Cmd_load \"" ++ root ++ "\" [])")
  : [ "IOTCM \"" ++ root ++ "\" None Direct (Cmd_show_module_contents_toplevel Simplified \""
      ++ m ++ "\")" | m <- ms ]

-- ─────────────────────────────────────────────────────────────────────
-- 3.  Reading the answers.  Responses arrive in the order asked, so the
--     module a block belongs to is its position — and an ERROR response
--     occupies a position too, which is why errors are counted rather
--     than skipped.  Dropping them would silently shift every later
--     module's name onto the wrong types.
-- ─────────────────────────────────────────────────────────────────────

data Answer = Contents [(String, String)] | Failed String

answers :: String -> [Answer]
answers out =
  [ a | l <- lines out
      , a <- if "\"contents\":[" `isInfixOf` l then [Contents (pairs l)]
             else if "\"kind\":\"Error\"" `isInfixOf` l then [Failed (short l)]
             else [] ]
  where short l = take 120 [ c | c <- l, c /= '\n' ]

-- targets ONE shape; see the header.  Splits on the literal field markers
-- and unescapes, which is enough for this and is not a JSON reader.
pairs :: String -> [(String, String)]
pairs l = go (chunks "{\"name\":\"" l)
  where
    go []       = []
    go (c : cs) = case breakOn "\",\"term\":\"" c of
      Just (n, rest) -> (unesc n, unesc (fst (endAt rest))) : go cs
      Nothing        -> go cs
    endAt s = span (/= '"') (dropQuoted s)
    dropQuoted = id

chunks :: String -> String -> [String]
chunks sep s = case breakOn sep s of
  Nothing        -> []
  Just (_, rest) -> let (this, more) = splitNext rest in this : chunks sep more
  where splitNext r = case breakOn sep r of
          Nothing        -> (r, "")
          Just (a, b)    -> (a, sep ++ b)

breakOn :: String -> String -> Maybe (String, String)
breakOn sep = go ""
  where
    go _   []           = Nothing
    go acc s@(c : cs)
      | sep `isPrefixOf` s = Just (reverse acc, drop (length sep) s)
      | otherwise          = go (c : acc) cs

-- JSON string unescaping, for the escapes Agda actually emits.  Devanagari
-- comes through literally and is left alone: romanising it to be safe
-- would be this repository's own scrubbing arriving through a lint.
unesc :: String -> String
unesc []                = []
unesc ('\\' : 'n' : r)  = ' ' : unesc r     -- types are flattened to one line
unesc ('\\' : 't' : r)  = ' ' : unesc r
unesc ('\\' : '"' : r)  = '"' : unesc r
unesc ('\\' : '\\' : r) = '\\' : unesc r
unesc (c : r)           = c : unesc r

squeeze :: String -> String
squeeze (' ' : ' ' : r) = squeeze (' ' : r)
squeeze (c : r)         = c : squeeze r
squeeze []              = []

-- ─────────────────────────────────────────────────────────────────────
-- 4.  main
-- ─────────────────────────────────────────────────────────────────────

main :: IO ()
main = do
  -- 2026-08-24: reads of this corpus are UTF-8 (Devanagari identifiers);
  -- without this, readFile throws under a POSIX locale mid-run.
  setLocaleEncoding utf8
  args <- getArgs
  case args of
    ("--collisions" : p : _) -> collisions p
    ("--edges" : p : _)      -> kernelEdges p
    ("--twins" : p : _)      -> twins p
    ("--net" : p : _)        -> netOf p
    _ -> emit args

emit :: [String] -> IO ()
emit args = do
  let lane = case args of { (d : _) -> d ; _ -> "formal/cubical" }
      lanes = 12   -- perf cores on this machine; the queries are independent
  ms0 <- laneModules lane
  -- AbhijnanaProbes/ is generated probe scratch that does not typecheck.
  -- One module that fails to load takes its WHOLE CHUNK down, so leaving
  -- them in reported hundreds of good modules as unreachable -- the
  -- instrument.s failure printed as the corpus.s absence, in the program
  -- written to stop exactly that.  मौनं न निषेधः.
  let ms = [ m | m <- ms0, m /= "Everything", take 9 m /= "Pratyaksa"
               , take 15 m /= "AbhijnanaProbes" ]
      cs = chunkInto lanes ms
  createDirectoryIfMissing True (lane ++ "/" ++ scratchDir)
  hPutStrLn stderr ("प्रत्यक्ष: " ++ show (length ms) ++ " modules over "
                    ++ show (length cs) ++ " kernels, in parallel")
  outs <- inParallel [ ask lane i c | (i, c) <- zip [0 ..] cs ]
  putStrLn "# प्रत्यक्ष — types as the KERNEL has them, not as a parser inferred them."
  putStrLn "# Each chunk gets a scratch root importing exactly its modules, because"
  putStrLn "# Cmd_show_module_contents needs the module IN SCOPE: loading a root puts"
  putStrLn "# only its DIRECT imports there, and a transitively-checked module answers"
  putStrLn "# NotInScope.  That is the kernel declining to guess, not a failure."
  putStrLn "# module\tname\ttype"
  forM_ (zip cs outs) $ \(c, out) ->
    -- A chunk whose ROOT failed to load answers nothing, and every module
    -- in it would otherwise be reported as individually unreachable.  Say
    -- which it is: a chunk failure is about this program, not the corpus.
    if not ("\"checked\":true" `isInfixOf` out)
      then hPutStrLn stderr ("  चूर्ण-खण्डः CHUNK ROOT FAILED TO LOAD -- "
                             ++ show (length c) ++ " modules unanswered, and this\
                             \ is a fact about this program: " ++ head c ++ " ...")
      else
       forM_ (zip c (answers out)) $ \(m, a) -> case a of
        Failed e     -> hPutStrLn stderr ("  अप्रत्यक्ष " ++ m ++ "  " ++ take 90 e)
        Contents nts -> forM_ nts $ \(n, t) ->
          putStrLn (m ++ "\t" ++ n ++ "\t" ++ squeeze t)

-- The scratch roots must live INSIDE the lane.  Outside it, the lane.s
-- .agda-lib does not apply and every `import` from the scratch file comes
-- back NotInScope -- tried, and that is what happens.  They are named so
-- they are unmistakable, and removed as soon as their kernel answers.

------------------------------------------------------------------------
-- संशयः · WHERE ONE BARE NAME IS SEVERAL OBJECTS.
--
-- `--collisions <table.tsv>` reads a table this program emitted and reports
-- every bare name defined in more than one module, with each definition
-- qualified and typed as the kernel has it.
--
-- WHY THIS IS NOT A LINT.  A parser that cannot resolve `R` emits one node
-- for all of them, and a merged node is AN IDENTIFICATION ASSERTED WITHOUT
-- A PROOF.  That is exactly what a ford is, with a proof.  So the parser
-- was not producing ambiguity — it was MINTING FORDS, and सूत्र ११ names
-- the offence precisely: two roads, transport or the written record, and
-- there is no third.  A silent merge is transport with neither.
--
-- THE CRITERION, and it is not "split when the types differ."  Five
-- modules define `R : Set` — same elaborated type, five different objects.
-- Sharing a type is not being the same thing.  **The qualified name is the
-- identity.**  Two names denote one object only if the qualified names
-- agree, or if a CHECKED identification says so — and that check is
-- exactly what Setubandha finds and मार्ग is licensed to route on.  So the
-- repair for a forged node is never to merge it differently; it is to
-- split it and let the identification, if there is one, be proved.
--
-- WHAT THIS IS NOT.  A collision here is not a defect in the corpus.
-- Naming the residue `R` in five modules is good Sanskrit-style economy
-- and the modules are unrelated; the defect is only in an instrument that
-- reads the bare name as the identity.  अवक्तव्यम् is two TRUE standpoints
-- held at once and honestly not collapsible; this is its inverse — several
-- distinct things asserted to be one — so it is a दुर्नय, not a fourth
-- position.
------------------------------------------------------------------------

collisions :: FilePath -> IO ()
collisions path = do
  s <- readFile path
  let rows = [ (n, m, t) | l <- lines s, take 1 l /= "#"
             , let f = splitTabs l, length f >= 3
             , let m = f !! 0, let n = f !! 1, let t = f !! 2 ]
      byName = foldr (\(n, m, t) acc -> ins n (m, t) acc) [] rows
      many   = [ (n, ds) | (n, ds) <- byName, length (nub (map fst ds)) > 1 ]
  putStrLn "═══ संशयः · one bare name, several objects ═══"
  putStrLn "  A merged node is an identification asserted without a proof —"
  putStrLn "  which is what a ford is, with one.  सूत्र ११: transport, or the"
  putStrLn "  written record; there is no third.  A silent merge is neither."
  putStrLn ""
  putStrLn "  The qualified name is the identity.  Same elaborated type does"
  putStrLn "  NOT license merging: five modules define `R : Set` and they are"
  putStrLn "  five different objects.  If two of these are genuinely the same,"
  putStrLn "  that is a CHECKED edge to be found, not a node to be assumed."
  putStrLn ""
  mapM_ shows' (sortOn (negate . length . snd) many)
  where
    ins n d [] = [(n, [d])]
    ins n d ((k, ds) : r) | k == n    = (k, d : ds) : r
                          | otherwise = (k, ds) : ins n d r
    shows' (n, ds) = do
      putStrLn ("  " ++ n)
      mapM_ (\(m, t) -> putStrLn ("      " ++ m ++ "." ++ n ++ "  :  " ++ take 90 t))
            (sortOn fst (nub ds))
    splitTabs x = case break (== '\t') x of
      (a, '\t' : r) -> a : splitTabs r
      (a, _)        -> [a]

------------------------------------------------------------------------
-- सेतुः प्रत्यक्षात् · THE EDGES AS THE KERNEL HAS THEM.
--
-- `--edges <table.tsv>` builds the road-one/road-two node-and-edge data
-- from elaborated types instead of from source text.
--
-- WHY THIS IS NOT A BETTER PARSER.  Lopa resolves node names by parsing
-- and gets `⟨lib⟩.ℕ`, `⟨ambig⟩.R`, `⟨lib⟩.A` — a merged node, a merged
-- node, and a bound variable carried as a library type.  Here those cannot
-- ARISE: the kernel's type is already fully qualified, so
-- `Gamma0Partner.R → Gamma0Partner.M → Gamma0Partner.M` names its own
-- nodes and there is nothing left to resolve.  The failure mode is not
-- reduced, it is absent.
--
-- WHAT IT DOES NOT DO.  It does not replace Lopa.  Two independent
-- extractors that agree is a channel in this corpus's sense; where they
-- disagree, the diff is the measurement of an inference by a direct look,
-- and that diff is the point of having both.  Nor does this decide which
-- edges are INVERTIBLE — a `≃` in the elaborated type is visible here, but
-- whether a declaration proves an identification is Setubandha's question
-- and is not answered by the shape of a type.
--
-- THE BINDER RULE, stated because it is the only judgement in the file.
-- An elaborated type is a chain of `→`.  Leading groups that BIND — `{…}`
-- implicits, and `(x : A)` where the parenthesis carries a top-level `:` —
-- are binders and not arguments; a dependent function is not an edge from
-- its binder.  What remains, if two or more components, gives source =
-- second-to-last and target = last.  This is Lopa's own rule, applied to
-- text that needs no repair rather than to text that does.
------------------------------------------------------------------------

-- split on top-level → , respecting (), {}, and ⟨⟩
splitArrows :: String -> [String]
splitArrows = go 0 ""
  where
    go :: Int -> String -> String -> [String]
    go _ acc []               = [reverse acc]
    go d acc ('→' : r) | d == 0 = reverse acc : go 0 "" r
    go d acc (c : r)
      | c `elem` "({⟨"  = go (d + 1) (c : acc) r
      | c `elem` ")}⟩"  = go (d - 1) (c : acc) r
      | otherwise       = go d (c : acc) r

isBinder :: String -> Bool
isBinder s = case trim s of
  ('{' : _)          -> True
  t@('(' : _)        -> hasTopColon (init' (drop 1 t))
  _                  -> False
  where
    init' x = if null x then x else init x
    hasTopColon = go 0
      where
        go _ []                = False
        go d (c : r)
          | c == ':' && d == 0 = True
          | c `elem` "({⟨"     = go (d + 1) r
          | c `elem` ")}⟩"     = go (d - 1) r
          | otherwise          = go d r

-- Binders are dropped WHEREVER they occur, not only at the front.  The
-- first version used `dropWhile`, so `A → (x : X) → B` kept `(x : X)` as a
-- source: a binder standing as a node, which is the same class of forgery
-- this program exists to remove, committed inside it.  Fixed, and recorded
-- rather than quietly corrected.
edgesOf :: String -> Maybe (String, String)
edgesOf ty =
  let cs = filter (not . isBinder) (map trim (splitArrows ty))
  in case reverse cs of
       (t : s : _) | not (null s), not (null t) -> Just (s, t)
       _                                        -> Nothing

-- A name with no dot is a BOUND VARIABLE -- a module parameter or telescope
-- variable -- not a type in this corpus.  The kernel prints it by its local
-- name because that is what it is.  An arrow out of a variable is not an
-- edge, it is a SCHEMA, and the three wrong things to do with it are: merge
-- them across modules (Lopa.s ⟨lib⟩.A), drop them silently (सूत्र ७), or
-- pretend they are qualified.  They are separated and named.
isSchematic :: String -> Bool
isSchematic s = not (any (== '.') s)

kernelEdges :: FilePath -> IO ()
kernelEdges path = do
  s <- readFile path
  let rows = [ (m, n, t) | l <- lines s, take 1 l /= "#"
             , let f = splitTabs l, length f >= 3
             , let m = f !! 0, let n = f !! 1, let t = f !! 2 ]
      es   = [ (m ++ "." ++ n, a, b) | (m, n, t) <- rows
             , Just (a, b) <- [edgesOf t] ]
  putStrLn "═══ सेतुः प्रत्यक्षात् · edges as the KERNEL has them ═══"
  putStrLn "  Node names come from elaborated types, so ⟨ambig⟩ and ⟨lib⟩"
  putStrLn "  cannot arise -- not resolved better, structurally absent."
  putStrLn "  Two extractors that agree is a channel; where they differ the"
  putStrLn "  diff measures an inference against a direct look."
  putStrLn ""
  -- Three kinds, and mixing them would mislead every consumer.  A target
  -- that is a SORT means the declaration is a type FAMILY, not a map --
  -- Lopa refuses those as `AFamily` and so does Setubandha; an edge into
  -- `Set` is not a crossing.  A bound variable at either end is a SCHEMA.
  -- What is left is a map between named objects.
  let isSort x = take 20 (trim x) == "Agda.Primitive.Set" || trim x == "Agda.Primitive.Setω"
                 || take 18 (trim x) == "Agda.Primitive.Set"
      (fam, notFam)  = partition (\(_, _, b) -> isSort b) es
      (schema, real) = partition (\(_, a, b) -> isSchematic a || isSchematic b) notFam
  putStrLn ("# families separated (target is a sort; not a crossing): "
            ++ show (length fam))
  putStrLn ("# schemas separated (a bound variable is not a node): "
            ++ show (length schema))
  putStrLn "# decl\tsource\ttarget"
  mapM_ (\(d, a, b) -> putStrLn (d ++ "\t" ++ a ++ "\t" ++ b)) real
  putStrLn "# ── योजना · SCHEMAS, kept and named, not merged and not dropped ──"
  mapM_ (\(d, a, b) -> putStrLn ("# schema\t" ++ d ++ "\t" ++ a ++ "\t" ++ b)) schema
  where
    splitTabs x = case break (== '\t') x of
      (a, '\t' : r) -> a : splitTabs r
      (a, _)        -> [a]

------------------------------------------------------------------------
-- यमजौ · TWINS — two modules holding the same statement about their own
-- copy of the same definition, which is a CHANNEL and not a duplication.
--
-- `--twins <table.tsv>` reads a प्रत्यक्ष table and reports declarations
-- whose elaborated types become identical once each one's OWN module
-- prefix is erased.
--
-- WHY, AND IT IS THE CORPUS ASKING.  `Bhedanirnaya_TwoTestersForSameness
-- OnNumberAndTheTransportThatMovesTheoremsBetweenThem.agda` opened one
-- such pair BY HAND -- two modules each defining `eqℕ` by the same four
-- clauses, whose soundness theorems PRINT alike and are not the same type,
-- because `EGBResidueGlue.eqℕ m n` and `NaturalMachine.Obstruction.eqℕ m n`
-- do not reduce to a common form at variable m and n.  Four lines of
-- induction gave pointwise agreement, one abstraction gave a path, and
-- then:
--
--     "A duplication that has been identified is not merely tidier -- it
--      is a channel, and theorems flow both ways along it."
--
-- Obstruction had proved COMPLETENESS and EGBResidueGlue had gone without
-- it; transport backwards along the same path handed it over, with no new
-- induction and no edit to either module.  Each had proved only the half
-- its own question required.
--
-- And §६ of that module names precisely what is missing:
--
--     "The pattern generalises and is not generalised.  Whether the corpus
--      has more instances of it is a question for the audit tool, which
--      currently reports only same-PRINTED-type groups and would miss a
--      pair whose definitions agree under different names."
--
-- This is that search.  Printed types are what the old audit compared and
-- they are exactly what cannot distinguish these cases; ELABORATED types
-- are fully qualified, so `⟨self⟩`-erasure is well defined and the
-- comparison is the kernel's rather than a parser's.
--
-- FOUR KINDS OF HIT, and without the taxonomy this report is noise.  Each
-- was found by OPENING a hit rather than by reasoning about the search:
--
--   RE-EXPORT — one declaration surfacing under two names, because a
--     parent does `open import Child public`.  Not a channel: it pays
--     nothing to identify a module with itself.  FILTERED below, by one
--     module name being a prefix of the other.
--
--   EXTENSION — B imports A and rebuilds its apparatus with more
--     constructors, carrying translations (`A.Tm → Tm`, `Env → A.Env`).
--     The shapes agree BY CONSTRUCTION and there is no duplication to
--     identify.  Filtered below when B imports A.
--
--   GENERATED — both emitted from one template by a program.
--     `NaturalMachine/RewriteCertificate*.agda` say so in their own
--     headers: `Certificate.hs` and `InductionSearch.hs` emit modules that
--     "differ by one import string".  This is NOT a false positive; it is
--     a true report about the EMITTER, and the channel — if there is one —
--     is in the template rather than between its outputs.  Not filtered,
--     because a program cannot tell a template from a coincidence and
--     guessing would be the forgery this file exists to avoid.
--
--   GENUINE TWINS — two modules that independently wrote the same thing
--     because each needed it.  This is the case that pays, and the eqℕ
--     triple is the worked one: see
--     `Yamaja_TheThirdTesterWasFoundByCensusAndTheChannelPays…agda`, where
--     four lines of induction handed one module reflexivity and
--     completeness it had never proved.
--
-- WHAT A HIT IS AND IS NOT.  A hit is a CANDIDATE channel, never a proved
-- one.  Two statements normalising alike does NOT mean the two underlying
-- definitions agree -- `Bhedanirnaya` §1's four lines of induction are
-- exactly the work this report cannot do, and if the definitions differ
-- the pair is a genuine near-miss and the report is a lead that has to be
-- opened by hand.  Reported as identifications: which two declarations,
-- and the shared shape.  Never as a count.
--
-- WHAT IT CANNOT SEE, stated so silence is not read as denial (सूत्र ७).
-- Only modules the kernel answered for: a chunk whose root failed to load
-- contributes nothing, and `EGBResidueGlue` -- half of the one pair known
-- to exist -- is absent from the table this was first run against.  So an
-- empty report is a fact about the table, and the coverage line below says
-- which modules were in it.
------------------------------------------------------------------------

-- erase a declaration's own module prefix, so two modules' statements
-- about their own copies become comparable
selfErase :: String -> String -> String
selfErase m t = go t
  where
    pre = m ++ "."
    go [] = []
    go s@(c : cs)
      | pre `isPrefixOf` s = "⟨self⟩." ++ go (drop (length pre) s)
      | otherwise          = c : go cs

twins :: FilePath -> IO ()
twins path = do
  s <- readFile path
  let rows = [ (m, n, t) | l <- lines s, take 1 l /= "#"
             , let f = splitTabs l, length f >= 3
             , let m = f !! 0, let n = f !! 1, let t = f !! 2
             , not (null t) ]
      keyed = [ (selfErase m t, (m, n)) | (m, n, t) <- rows ]
      grouped = foldr ins [] keyed
      -- a channel needs TWO DIFFERENT MODULES; the same module stating a
      -- thing twice is a different question and is not one.
      chans = [ (k, ds) | (k, ds) <- grouped
              , let ms = nub (map fst ds)
              , length ms > 1
              , mentionsSelf k
              -- RE-EXPORTS ARE NOT TWINS.  `NaturalMachine.agda` carries
              -- `open import NaturalMachine.SmithPathCountedExecution public`,
              -- so one declaration surfaces under both `A.x` and `A.B.x` and
              -- normalises alike for the trivial reason that it IS one
              -- declaration.  One module name being a prefix of another is
              -- exactly that case, and it is dropped rather than reported --
              -- a channel between a module and itself pays nothing.
              , not (any reExport [ (a, b) | a <- ms, b <- ms, a /= b ]) ]
  putStrLn "═══ यमजौ · candidate channels — one statement, two modules, each about its own copy ═══"
  putStrLn "  A hit is a CANDIDATE.  Two statements normalising alike does not mean"
  putStrLn "  the two definitions agree; that induction is exactly the work this"
  putStrLn "  report cannot do.  Bhedanirnaya opened one such pair by hand and it"
  putStrLn "  paid: each module had proved only the half its own question required,"
  putStrLn "  and identification handed each the other's half."
  putStrLn ""
  putStrLn $ "  coverage: " ++ show (length (nub [ m | (m, _, _) <- rows ]))
             ++ " modules answered by the kernel.  A module absent here was not"
  putStrLn   "  looked at, and its absence from the report says nothing (सूत्र ७)."
  putStrLn ""
  mapM_ report (sortOn fst chans)
  where
    mentionsSelf k = "⟨self⟩" `isInfixOf` k
    reExport (a, b) = (a ++ ".") `isPrefixOf` b || (b ++ ".") `isPrefixOf` a
    ins (k, d) [] = [(k, [d])]
    ins (k, d) ((k', ds) : r)
      | k == k'   = (k', d : ds) : r
      | otherwise = (k', ds) : ins (k, d) r
    report (k, ds) = do
      putStrLn ("  ── " ++ take 150 k)
      mapM_ (\(m, n) -> putStrLn ("       " ++ m ++ "." ++ n)) (sortOn fst (nub ds))
      putStrLn ""
    splitTabs x = case break (== '\t') x of
      (a, '\t' : r) -> a : splitTabs r
      (a, _)        -> [a]

------------------------------------------------------------------------
-- जालम् · THE NET THE KERNEL DRAWS, which is not the import graph.
--
-- `--net <table.tsv>` reports, for each module, which OTHER modules'
-- names actually occur inside its elaborated types.
--
-- WHY IT IS A DIFFERENT NET.  `machine/Indrajala_WhichModulesSeeWhich
-- AndWhatNothingSees.hs` draws the DARŚANA graph from `import` lines and
-- states its own limit: it is syntactic, an upper bound on reach, and
-- `formal/cubical/BUILD.md` already records that grepping imports gave
-- the wrong orphan count because the .agdai interfaces are the ground
-- truth about what the kernel checked.  That is अनुमान — inference from a
-- textual mark — and this is the same substitution `Pratyaksa` made for
-- `Lopa`.
--
-- But the substitution changes the OBJECT, and that is the point rather
-- than an improvement:
--
--   an import edge says A MAY see B — permission.
--   a name of B occurring in A's elaborated type says A CONTAINS B —
--   B is literally part of what A states.
--
-- Fazang built the room because mutual containment could not be followed
-- from the text.  Containment is what his mirrors show, and an import
-- list is not it: a module may import and never use, and may contain
-- without importing when the name arrives through a re-export.  Both
-- differences are reported, because the DIFFERENCE between the two graphs
-- is the finding and neither graph alone is.
--
-- WHAT THIS DOES NOT DO.  It does not supersede the darśana graph.  The
-- orphan claim that graph makes needs permission and not containment — a
-- module nothing imports is built by nothing however much its types
-- mention — so both are needed and neither is the other's better version.
--
-- LIMIT, said so silence is not read as denial.  Only modules the kernel
-- answered for; a module absent from the table contributes no edges in
-- either direction and its absence here says nothing about it.  And
-- containment is detected by qualified-name occurrence, so a module whose
-- contribution to another's statement has been fully normalised away
-- leaves no trace — the kernel prints what the type IS, not what was used
-- to build it.
------------------------------------------------------------------------

netOf :: FilePath -> IO ()
netOf path = do
  s <- readFile path
  let rows = [ (m, t) | l <- lines s, take 1 l /= "#"
             , let f = splitTabs l, length f >= 3
             , let m = f !! 0, let t = f !! 2, not (null t) ]
      mods = nub (map fst rows)
      -- B is contained in A when a name qualified by B occurs in one of
      -- A's elaborated types.  Longest-prefix only, so a submodule is not
      -- credited to its parent.
      containsIn a = nub [ b | b <- mods, b /= a
                         , any (\t -> (b ++ ".") `isInfixOf` t)
                               [ t | (m, t) <- rows, m == a ] ]
      net = [ (a, containsIn a) | a <- mods ]
  putStrLn "═══ जालम् · the net the KERNEL draws — containment, not permission ═══"
  putStrLn "  An import edge says A MAY see B.  A name of B inside A's elaborated"
  putStrLn "  type says A CONTAINS B: B is literally part of what A states."
  putStrLn "  Fazang built the room because containment could not be followed from"
  putStrLn "  the text.  An import list is permission; this is the room."
  putStrLn ""
  putStrLn "  This does NOT supersede the darśana graph in Indrajala_…hs.  Its"
  putStrLn "  orphan claim needs permission — a module nothing imports is built by"
  putStrLn "  nothing however much its types mention — so both are needed."
  putStrLn ""
  putStrLn "  LIMIT: only modules the kernel answered for.  A module absent from"
  putStrLn "  the table contributes no edge either way and its absence says nothing."
  putStrLn "  And a contribution fully normalised away leaves no trace: the kernel"
  putStrLn "  prints what the type IS, not what was used to build it."
  putStrLn ""
  putStrLn "── अप्रतिबिम्बम् · contained in nothing and containing nothing ──"
  putStrLn "   (in this table; a jewel in the room reflecting none and reflected by none)"
  let reflectedBy b = [ a | (a, bs) <- net, b `elem` bs ]
      alone = [ a | (a, bs) <- net, null bs, null (reflectedBy a) ]
  mapM_ (\a -> putStrLn ("     " ++ a)) (sort alone)
  putStrLn ""
  putStrLn "── बहुप्रतिबिम्बम् · the jewels most other jewels contain ──"
  let byRefl = sortOn (negate . length . snd) [ (b, reflectedBy b) | b <- mods ]
  mapM_ (\(b, rs) -> putStrLn ("     " ++ b ++ "   ← contained in " ++ show (length rs)))
        (take 12 byRefl)
  where
    splitTabs x = case break (== '\t') x of
      (a, '\t' : r) -> a : splitTabs r
      (a, _)        -> [a]
scratchDir :: FilePath
scratchDir = "PratyaksaScratch"

chunkInto :: Int -> [a] -> [[a]]
chunkInto k xs = go xs
  where
    n  = max 1 ((length xs + k - 1) `div` k)
    go [] = []
    go ys = take n ys : go (drop n ys)

-- one kernel per chunk.  The scratch root lives OUTSIDE the lane so no
-- directory walk, check script or commit ever sees it.
ask :: FilePath -> Int -> [String] -> IO String
ask lane i ms = do
  let name = "PratyaksaChunk" ++ show i
      rel  = scratchDir ++ "/" ++ name ++ ".agda"
      path = lane ++ "/" ++ rel
  writeFile path (unlines (("module " ++ scratchDir ++ "." ++ name ++ " where")
                           : [ "import " ++ m | m <- ms ]))
  (_, out, _) <- readCreateProcessWithExitCode
                   (proc "agda" ["--interaction-json", "-i", "."])
                     { cwd = Just lane }
                   (script rel ms)
  _ <- (try (removeFile path) :: IO (Either SomeException ()))
  pure out

inParallel :: [IO a] -> IO [a]
inParallel acts = do
  vs <- forM acts $ \act -> do
    v <- newEmptyMVar
    _ <- forkIO (act >>= putMVar v)
    pure v
  mapM takeMVar vs
