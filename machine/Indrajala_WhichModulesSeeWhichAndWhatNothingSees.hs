-- Indrajala_WhichModulesSeeWhichAndWhatNothingSees.hs
--
-- SOURCE AND FORM.  Indrajāla, Indra's net, is the image the Avataṃsaka
-- Sūtra uses for mutual containment: a net of jewels, each reflecting every
-- other, reflections within reflections, no ground.  Fazang (法藏, 643-712)
-- built the demonstration physically for Wu Zetian around 700 -- ten mirrors,
-- eight compass points plus above and below, all facing inward around a lamp
-- and a Buddha figure -- because she could not follow the mutual containment
-- from the text.  `machine/IndraNet.hs` in this repository is named for that
-- demonstration and implements the finite/productive bridge.
--
-- WHAT IS AND IS NOT CLAIMED.  Fazang did not analyse import graphs.  What is
-- taken is his method and nothing else: when a claim of mutual reflection
-- cannot be followed from the text, BUILD THE ROOM AND LOOK.  This program is
-- the room.  It reports which modules of this corpus actually see which, and
-- -- the half Fazang's mirrors make immediate and prose does not -- which
-- jewels are in the room reflecting nothing and reflected by nothing.
--
-- WHY A PROGRAM AND NOT A NOTE.  The same reason `machine/Anukramani.hs` is a
-- program: `formal/cubical/BUILD.md` already records, in its own words, that a
-- hand-maintained list of orphans "rots in both directions" -- it said four
-- when the true count was three, two having been folded in and one new orphan
-- having appeared in the interim.  Every number below is recomputed from the
-- filesystem on each run.
--
--   run:  runghc machine/Indrajala_WhichModulesSeeWhichAndWhatNothingSees.hs
--   from the repository root.  Prints a report; writes nothing.
--
-- WHAT IS MEASURED, AND THE LIMIT OF EACH MEASUREMENT, STATED AT THE SITE:
--
--  1. DARŚANA -- the import graph of every .agda under formal/cubical/,
--     excluding _build.  Edges come from `import`/`open import` lines only.
--     LIMIT: this is the SYNTACTIC graph.  BUILD.md is right that the .agdai
--     interface files are the ground truth about what the kernel checked, and
--     that grepping import lines gave the wrong orphan count there.  The two
--     disagree only where a module fails to check, so this graph is an upper
--     bound on reach: a module unreachable HERE is unreachable in the kernel
--     too, which is the direction the orphan claim needs.
--
--  2. ANĀTHA -- "without a protector": modules nothing imports (in-degree 0)
--     and which are not themselves aggregate roots.
--
--  3. SIDDHA / ASIDDHA -- "accomplished" / "not accomplished".  Which modules
--     have an .agdai interface file under _build.  BUILD.md is explicit that
--     the interface files, not the import lines, are the ground truth about
--     what the kernel actually checked.
--     LIMIT: this reports the state of the LAST build in this working tree,
--     not a fresh one.  It is a lower bound on what is checkable and an exact
--     statement of what is presently checked.
--
--  4. SAMĀNĀRTHA -- "having the same meaning": top-level type signatures that
--     are character-identical after normalisation but live in different
--     modules under different names.  This is the mechanical shadow of the
--     thing worth finding -- the same result under two names -- and it is only
--     the shadow: it catches literal restatement and cannot see a result
--     restated in different notation.  A hit here is a lead, not a verdict.
--     For each group the report says whether ANY member module reaches any
--     other through imports.  A group where nothing sees anything else is the
--     case this repository has hit three times: the same theorem proved twice,
--     found only at audit.
--
-- WHAT WAS FOUND ON THE FIRST RUN, 2026-08-20, so a later run has something
-- to disagree with.  Every one of these is reproduced by running this file.
--
--   * 794 .agda modules; 610 in the syntactic closure of the three roots
--     (Everything, NaturalMachine, IndianLane); 184 outside it; 55 of those
--     imported by nothing at all.  The unreached set is NOT loose leaves --
--     most of the 184 are imported, by each other.  They are subnets with
--     their own roots, mirroring each other and nothing else.
--
--   * Each of those 55 dark roots was then run through Agda by hand.
--     **45 exit 0 and 10 exit 42.**  All ten failures are
--     `NaturalMachine/Control/*`, the designed-annihilation suite, each of
--     which states something FALSE and carries "*** THIS FILE MUST FAIL TO
--     TYPE-CHECK ***" in its header.  They are orphaned CORRECTLY.
--     So: the dark set is not broken work.  It is 45 green modules that
--     nothing builds.  Anyone "fixing" the orphans by folding them into an
--     aggregate wholesale would import the ten and break the build.
--
--   * `Everything.agda` exits 0, and after building it only two reachable
--     modules lacked an interface (`IndianLane`, `CakravalaWitness`); both
--     check exit 0 individually.  A missing .agdai on a REACHABLE module
--     means the aggregate build aborted upstream, not that the module fails.
--
--   * 17 statements stand twice or more with nothing linking the modules,
--     and 5 of those pair a Devanagari-named declaration with a Latin-named
--     one -- the book and the apparatus proving the same theorem in
--     ignorance of each other.  The sharpest is the medial law:
--         Vargana . चतुर्-विनिमयः      (a·b)·(c·d) ≡ (a·c)·(b·d)
--         EGBPairComposition . interchange              -- the same type
--     one reached via the Jaina laws of indices (Anuyogadvāra), the other
--     annotated "Brahmagupta, straight" for the bhāvanā product.  Additively
--     the same identity stands FOUR times: MeruKarna . मध्य-विनिमयः,
--     Vargacitighana . मध्य-विनिमयः (identical Sanskrit name, two modules),
--     CachePathOrder . shuffle+, DSOFactorRankFinite . rearrange.
--
--  5. GRANTHANĀMAN -- "the name of the work".  CLAUDE.md's cheap check: for
--     each source, how many notes name the AUTHOR against how many name the
--     TEXT.  An author's name propagates through citation; a work's name
--     appears only when someone has attended to the work.  The gap is the
--     measurement.

module Main (main) where

import Control.Monad (forM, forM_, unless)
import Data.Char (isAlpha, isSpace, toLower)
import Data.List
  (intercalate, isInfixOf, isPrefixOf, isSuffixOf, nub, sort, sortBy, sortOn)
import Data.Maybe (mapMaybe)
import Data.Ord (Down (..), comparing)
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import System.Directory (doesDirectoryExist, listDirectory)
import System.FilePath ((</>), takeExtension, takeFileName)
import System.IO (hSetEncoding, stdout, utf8)
import GHC.IO.Encoding (setLocaleEncoding)
import System.IO (utf8)

-- ---------------------------------------------------------------- filesystem

-- | Every file under a root, skipping directories whose basename is in the
--   skip set.  `_build` holds Agda's generated copies and would double every
--   count.
walk :: [String] -> FilePath -> IO [FilePath]
walk skips root = do
  isDir <- doesDirectoryExist root
  if not isDir
    then return [root]
    else do
      names <- listDirectory root
      fmap concat . forM (sort names) $ \n ->
        if n `elem` skips || "." `isPrefixOf` n
          then return []
          else walk skips (root </> n)

readFileSafe :: FilePath -> IO String
readFileSafe p = do
  s <- readFile p
  length s `seq` return s

-- ------------------------------------------------------------------ agda

data Mod = Mod
  { mPath    :: FilePath   -- ^ path as found on disk
  , mName    :: String     -- ^ declared top-level module name
  , mImports :: [String]   -- ^ module names this file imports
  , mSigs    :: [(String, String)]  -- ^ (name, normalised type)
  }

-- | Strip an Agda line comment.  Deliberately crude: it does not understand
--   `{- -}` blocks or string literals.  Both cases affect only signature
--   normalisation (measurement 3), never the import graph, and a false split
--   there loses a lead rather than inventing one.
stripComment :: String -> String
stripComment = go
  where
    go ('-':'-':_) = []
    go (c:cs)      = c : go cs
    go []          = []

collapse :: String -> String
collapse = unwords . words

-- | The first `module ... where` at column 0.  Agda permits later inner
--   `module` blocks also at column 0 inside a parameterised section, so a
--   plain grep takes the wrong one; the first is the file's own name.
declaredModule :: [String] -> Maybe String
declaredModule ls =
  case [ w | l <- ls, "module " `isPrefixOf` l
           , w <- take 1 (drop 1 (words (stripComment l))) ] of
    (n:_) -> Just n
    []    -> Nothing

importsOf :: [String] -> [String]
importsOf ls = nub (mapMaybe one ls)
  where
    one l0 =
      let l = stripComment l0
          ws = words l
      in case ws of
           ("import":m:_)        -> Just m
           ("open":"import":m:_) -> Just m
           _                     -> Nothing

-- | Top-level type signatures: a line beginning at column 0 with
--   `name : ...`, continued by following indented lines until the next
--   column-0 line.  The name is dropped; what is hashed is the type.
signaturesOf :: [String] -> [(String, String)]
signaturesOf = go
  where
    go [] = []
    go (l:ls) =
      case sigHead l of
        Nothing -> go ls
        Just (nm, rest) ->
          let (cont, ls') = span indented ls
              ty = collapse (unwords (rest : map stripComment cont))
          in (nm, ty) : go ls'
    indented (c:_ ) | not (isSpace c) = False
    indented l = not (null (words (stripComment l)))
    sigHead l0 =
      let l = stripComment l0
      in case break (== ':') l of
           (lhs, ':':rhs)
             | not (null lhs)
             , startsIdent lhs
             , [nm] <- words lhs
             , not (null (words rhs))
             , take 1 rhs /= "="        -- `:=` is not a signature
             -> Just (nm, rhs)
           _ -> Nothing
    startsIdent s = case s of
      (c:_) -> isAlpha c || c `elem` "_∀ΠΣ"
      _     -> False

parseAgda :: FilePath -> String -> Maybe Mod
parseAgda p src =
  let ls = lines src
  in case declaredModule ls of
       Nothing -> Nothing
       Just n  -> Just (Mod p n (importsOf ls) (signaturesOf ls))

-- ------------------------------------------------------------- graph work

reachFrom :: M.Map String [String] -> [String] -> S.Set String
reachFrom g = go S.empty
  where
    go seen []     = seen
    go seen (x:xs)
      | x `S.member` seen = go seen xs
      | otherwise         = go (S.insert x seen) (M.findWithDefault [] x g ++ xs)

-- ------------------------------------------------------------------ notes

-- | (author as it is usually cited, the works themselves).  Drawn from
--   CLAUDE.md's provenance table and from the ṛṣi fields of
--   `machine/Anukramani.hs`, so the two indexes name the same sources.
--   Transliteration variants are listed because this corpus writes both
--   with and without diacritics.
sources :: [(String, [String], [String])]
sources =
  [ ("Piṅgala",      ["Pingala","Piṅgala"],                 ["Chandahsastra","Chandaḥśāstra","Chandahśāstra","Chandas-sastra"])
  , ("Āryabhaṭa",    ["Aryabhata","Āryabhaṭa"],             ["Aryabhatiya","Āryabhaṭīya","Ganitapada","Gaṇitapāda"])
  , ("Brahmagupta",  ["Brahmagupta"],                       ["Brahmasphuta","Brāhmasphuṭa"])
  , ("Bhāskara II",  ["Bhaskara","Bhāskara"],               ["Bijaganita","Bījagaṇita","Lilavati","Līlāvatī","Siddhantasiromani","Siddhāntaśiromaṇi"])
  , ("Mādhava",      ["Madhava","Mādhava"],                 ["Yuktibhasa","Yuktibhāṣā","Tantrasangraha","Tantrasaṅgraha","Karanapaddhati","Karaṇapaddhati"])
  , ("Nīlakaṇṭha",   ["Nilakantha","Nīlakaṇṭha"],           ["Tantrasangraha","Tantrasaṅgraha","Aryabhatiyabhasya","Āryabhaṭīyabhāṣya"])
  , ("Pāṇini",       ["Panini","Pāṇini"],                   ["Astadhyayi","Aṣṭādhyāyī","Ashtadhyayi"])
  , ("Patañjali",    ["Patanjali","Patañjali"],             ["Mahabhasya","Mahābhāṣya"])
  , ("Umāsvāti",     ["Umasvati","Umāsvāti"],               ["Tattvarthasutra","Tattvārthasūtra","Tattvartha"])
  , ("Siddhasena",   ["Siddhasena"],                        ["Sanmatitarka","Sanmati"])
  , ("Samantabhadra",["Samantabhadra"],                     ["Aptamimamsa","Āptamīmāṃsā"])
  , ("Akalaṅka",     ["Akalanka","Akalaṅka"],               ["Laghiyastraya","Laghīyastraya","Nyayaviniscaya","Nyāyaviniścaya"])
  , ("Gautama",      ["Nyayasutra","Nyāyasūtra","Gautama"], ["Nyayasutra","Nyāyasūtra"])
  , ("Vātsyāyana",   ["Vatsyayana","Vātsyāyana"],           ["Nyayabhasya","Nyāyabhāṣya"])
  , ("Kumārila",     ["Kumarila","Kumārila"],               ["Slokavarttika","Ślokavārttika","Abhavapariccheda"])
  , ("Dignāga",      ["Dignaga","Dinnaga","Dignāga"],       ["Pramanasamuccaya","Pramāṇasamuccaya"])
  , ("Dharmakīrti",  ["Dharmakirti","Dharmakīrti"],         ["Pramanavarttika","Pramāṇavārttika","Nyayabindu","Nyāyabindu"])
  , ("Nāgārjuna",    ["Nagarjuna","Nāgārjuna"],             ["Mulamadhyamaka","Mūlamadhyamaka","Vigrahavyavartani","Vigrahavyāvartanī"])
  , ("Baudhāyana",   ["Baudhayana","Baudhāyana"],           ["Sulbasutra","Śulbasūtra","Sulvasutra"])
  , ("Nārāyaṇa",     ["Narayana Pandita","Nārāyaṇa Paṇḍita"],["Ganitakaumudi","Gaṇitakaumudī"])
  , ("Virahāṅka",    ["Virahanka","Virahāṅka"],             ["Vrttajatisamuccaya","Vṛttajātisamuccaya"])
  , ("Halāyudha",    ["Halayudha","Halāyudha"],             ["Mrtasanjivani","Mṛtasañjīvanī"])
  , ("Bharata",      ["Natyasastra","Nāṭyaśāstra","Bharata"],["Natyasastra","Nāṭyaśāstra"])
  , ("Kauṭilya",     ["Kautilya","Kauṭilya"],               ["Arthasastra","Arthaśāstra"])
  , ("Jayadeva",     ["Jayadeva"],                          ["Sundari","Udayadivakara","Udayadivākara"])
  , ("Fazang",       ["Fazang","Fa-tsang"],                 ["Avatamsaka","Avataṃsaka","Huayan","Huáyán"])
  ]

-- | How many files in a set mention any of the given needles, case-folded.
countFiles :: [(FilePath, String)] -> [String] -> Int
countFiles corpus needles =
  length [ () | (_, s) <- corpus
              , let ls = map toLower s
              , any (\n -> map toLower n `isInfixOf` ls) needles ]

-- --------------------------------------------------------------------- main

main :: IO ()
main = do
  -- 2026-08-24: reads of this corpus are UTF-8 (Devanagari identifiers);
  -- without this, readFile throws under a POSIX locale mid-run.
  setLocaleEncoding utf8
  hSetEncoding stdout utf8

  -- 1 & 2 -------------------------------------------------------------------
  agdaPaths <- filter ((== ".agda") . takeExtension)
               <$> walk ["_build"] "formal/cubical"
  mods <- forM agdaPaths $ \p -> do
    s <- readFileSafe p
    return (p, parseAgda p s)
  let parsed   = [ m | (_, Just m) <- mods ]
      unparsed = [ p | (p, Nothing) <- mods ]
      byName   = M.fromListWith (++) [ (mName m, [m]) | m <- parsed ]
      known    = M.keysSet byName
      -- edges kept only when the target is a module of THIS corpus, so the
      -- cubical stdlib (Cubical.*, Agda.*) does not appear as a node.
      graph    = M.fromList
                   [ (mName m, [ i | i <- mImports m, i `S.member` known ])
                   | m <- parsed ]
      indeg    = M.fromListWith (+)
                   [ (t, 1 :: Int) | (_, ts) <- M.toList graph, t <- nub ts ]
      roots    = [ "Everything", "NaturalMachine", "IndianLane" ]
      liveRoots = [ r | r <- roots, r `S.member` known ]
      reached  = reachFrom graph liveRoots
      unreached = sort [ n | n <- S.toList known, not (n `S.member` reached) ]
      anatha   = sort [ n | n <- S.toList known
                          , M.findWithDefault 0 n indeg == 0
                          , n `notElem` liveRoots ]

  putStrLn "=============================================================="
  putStrLn "दर्शनम् · DARŚANA -- what sees what"
  putStrLn "=============================================================="
  putStrLn $ "  .agda files under formal/cubical (excl. _build) : " ++ show (length agdaPaths)
  putStrLn $ "  with a parseable top-level module declaration   : " ++ show (length parsed)
  unless (null unparsed) $
    putStrLn $ "  NO module declaration found (not a module?)     : "
               ++ show (length unparsed)
  putStrLn $ "  distinct module names                           : " ++ show (S.size known)
  putStrLn $ "  aggregate roots present                         : "
             ++ intercalate ", " liveRoots
  putStrLn $ "  reachable from the roots (syntactic closure)    : " ++ show (S.size reached)
  putStrLn $ "  NOT reachable from any root                     : " ++ show (length unreached)
  putStrLn $ "  imported by NOTHING (anātha, in-degree 0)       : " ++ show (length anatha)
  putStrLn ""

  let dupNames = [ (n, map mPath ms)
                 | (n, ms) <- M.toList byName, length ms > 1 ]
  unless (null dupNames) $ do
    putStrLn $ "  module names declared by more than one file     : "
               ++ show (length dupNames)
    forM_ (take 12 dupNames) $ \(n, ps) ->
      putStrLn $ "      " ++ n ++ "  <-  " ++ intercalate ", " ps
    putStrLn ""

  putStrLn "  -- unreached AND imported by nothing: checked by nothing,"
  putStrLn "     and nothing in the corpus would ever have said so."
  let darkAll = [ n | n <- unreached, n `elem` anatha ]
      -- NOT EVERY ORPHAN IS AN ACCIDENT.  `NaturalMachine/Control/*` is a
      -- designed-annihilation suite (collab/PROTOCOL.md §7): each file states
      -- something FALSE and its headline reads "*** THIS FILE MUST FAIL TO
      -- TYPE-CHECK ***".  Measured 2026-08-20: all ten exit 42, individually,
      -- as intended.  They are orphaned CORRECTLY -- importing them into any
      -- aggregate would break it -- so folding "the orphans" into a root
      -- wholesale is a bug, and any report that does not carve them out is
      -- inviting exactly that.
      isControl n = "NaturalMachine.Control." `isPrefixOf` n
      control = filter isControl darkAll
      dark    = filter (not . isControl) darkAll
  putStrLn $ "     count (all)                                  : " ++ show (length darkAll)
  putStrLn $ "     of which the designed-failure control suite  : " ++ show (length control)
  putStrLn $ "     dark and NOT by design                       : " ++ show (length dark)
  forM_ dark $ \n -> putStrLn ("       " ++ n)
  putStrLn ""

  -- The gap between the two counts is the interesting object.  185 modules
  -- unreachable from the roots but only 56 with in-degree 0 means the rest
  -- are imported -- by each other.  They are not loose leaves; they are
  -- SUBNETS, complete with their own roots, hanging off nothing.
  let darkClosure = reachFrom graph dark
      inDarkNets  = S.size (darkClosure `S.intersection` S.fromList unreached)
  putStrLn $ "  unreached modules pulled in by those " ++ show (length dark)
             ++ " dark roots : " ++ show inDarkNets
  putStrLn $ "  unreached and NOT pulled in even by them (cycles)      : "
             ++ show (length unreached - inDarkNets)
  putStrLn "  -- so the unreached set is not scattered leaves.  It is subnets"
  putStrLn "     with their own roots, mirroring each other and nothing else."
  putStrLn ""

  -- 4 -----------------------------------------------------------------------
  ifacePaths <- walk [] "formal/cubical/_build"
  let ifaces = S.fromList
        [ dropSuffix ".agdai" (takeFileName p)
        | p <- ifacePaths, ".agdai" `isSuffixOf` p ]
      -- interface files are named by the LAST component of the module name
      leaf n = reverse (takeWhile (/= '.') (reverse n))
      siddha  = [ n | n <- S.toList known, leaf n `S.member` ifaces ]
      asiddha = sort [ n | n <- S.toList known, not (leaf n `S.member` ifaces) ]
  putStrLn "=============================================================="
  putStrLn "सिद्ध / असिद्ध · SIDDHA / ASIDDHA -- what the kernel actually did"
  putStrLn "=============================================================="
  putStrLn $ "  .agdai interface files found                    : " ++ show (S.size ifaces)
  putStrLn $ "  modules WITH an interface (checked at some point): " ++ show (length siddha)
  putStrLn $ "  modules with NO interface (asiddha)             : " ++ show (length asiddha)
  putStrLn $ "  ... of those, syntactically reachable from a root: "
             ++ show (length [ n | n <- asiddha, n `S.member` reached ])
  putStrLn "      (reachable but with no interface = the last aggregate build"
  putStrLn "       never got there.  Agda stops at the first error, so this"
  putStrLn "       set is everything downstream of wherever it stopped -- NOT"
  putStrLn "       a set of failing modules.  Measured 2026-08-20: all 17 in"
  putStrLn "       this position checked exit 0 individually; the aggregate had"
  putStrLn "       simply aborted upstream of them.  The distinction matters:"
  putStrLn "       an empty list here means the whole closure is green.)"
  putStrLn ""
  forM_ [ n | n <- asiddha, n `S.member` reached ] $ \n ->
    putStrLn ("       " ++ n)
  putStrLn ""

  -- 5 -----------------------------------------------------------------------

  -- 3 -----------------------------------------------------------------------
  let sigTable = M.fromListWith (++)
        [ (ty, [(mName m, nm)])
        | m <- parsed, (nm, ty) <- mSigs m
        , length ty >= 24                       -- below this the type is noise
        , not (trivialType ty) ]
      sameArtha =
        [ (ty, us)
        | (ty, occs) <- M.toList sigTable
        , let us = nub occs
        , length (nub (map fst us)) > 1          -- across DIFFERENT modules
        ]
      -- the strong case: same type, DIFFERENT name, different module.
      renamed = [ (ty, us) | (ty, us) <- sameArtha, length (nub (map snd us)) > 1 ]

  putStrLn "=============================================================="
  putStrLn "समानार्थम् · SAMĀNĀRTHA -- one statement, two names"
  putStrLn "=============================================================="
  putStrLn $ "  top-level signatures parsed                     : "
             ++ show (sum (map (length . mSigs) parsed))
  putStrLn $ "  identical types occurring in >1 module          : " ++ show (length sameArtha)
  putStrLn $ "  ... of those, under DIFFERENT names             : " ++ show (length renamed)
  putStrLn "  (a lead, never a verdict -- this catches literal restatement"
  putStrLn "   only, and is blind to the same result in other notation)"
  -- Does anything in the group see anything else in it?
  -- Reachability is computed ONCE per module that appears in any group and
  -- then shared; recomputing it per pair walks the whole graph thousands of
  -- times and is the difference between two seconds and ten minutes.
  let groupMods = S.toList (S.fromList (concatMap (map fst . snd) renamed))
      reachMap  = M.fromList [ (m, reachFrom graph [m]) | m <- groupMods ]
      seesAnother us =
        let ms = nub (map fst us)
        in or [ b `S.member` M.findWithDefault S.empty a reachMap
              | a <- ms, b <- ms, a /= b ]
      blind = [ g | g@(_, us) <- renamed, not (seesAnother us) ]
  putStrLn $ "  ... of those, where NO member module reaches any other  : "
             ++ show (length blind)
  putStrLn "  (the same statement standing twice with nothing linking them)"

  -- The shape of the blindness, not just its count.  This corpus names its
  -- primary-source mathematics in Devanagari and its apparatus in English.
  -- A blind group containing BOTH is the book and the appendix proving the
  -- same theorem in ignorance of each other -- which is a fact about the
  -- corpus's structure and not about any one module.
  let devanagari c = c >= '\x0900' && c <= '\x097F'
      hasDev = any (any devanagari . snd)
      hasLat = any (all (not . devanagari) . snd)
      twins  = [ g | g@(_, us) <- blind, hasDev us, hasLat us ]
  putStrLn $ "  ... of those, with a Devanagari-named AND a Latin-named"
  putStrLn $ "      declaration in the same group                     : "
             ++ show (length twins)
  putStrLn "      (the book and the apparatus, same theorem, no link)"
  putStrLn ""
  forM_ (take 30 (sortOn (Down . length . snd) blind)) $ \(ty, us) -> do
    putStrLn $ "    : " ++ take 96 ty
    forM_ (sort us) $ \(m, n) -> putStrLn ("        " ++ m ++ " . " ++ n)
    putStrLn ""

  -- 4 -----------------------------------------------------------------------
  notePaths <- filter ((== ".md") . takeExtension) <$> walk ["_build"] "notes"
  notesCorpus <- forM notePaths $ \p -> do { s <- readFileSafe p; return (p, s) }

  putStrLn "=============================================================="
  putStrLn "ग्रन्थनाम · GRANTHANĀMAN -- the author's name against the work's"
  putStrLn "=============================================================="
  putStrLn $ "  notes/*.md scanned : " ++ show (length notesCorpus)
  putStrLn ""
  putStrLn "    source                 author-in-N   work-in-N   gap"
  let rows = [ (label, a, w, a - w)
             | (label, auth, works) <- sources
             , let a = countFiles notesCorpus auth
             , let w = countFiles notesCorpus works ]
  forM_ (sortBy (comparing (\(_,_,_,g) -> Down g)) rows) $ \(l, a, w, g) ->
    putStrLn $ "    " ++ pad 22 l ++ padL 9 (show a) ++ padL 12 (show w)
               ++ padL 6 (show g) ++ (if w == 0 && a > 0 then "   <- never named" else "")
  putStrLn ""
  let totA = sum [ a | (_, a, _, _) <- rows ]
      totW = sum [ w | (_, _, w, _) <- rows ]
      never = length [ () | (_, a, w, _) <- rows, w == 0, a > 0 ]
  putStrLn $ "    totals: author-mentions " ++ show totA
             ++ "   work-mentions " ++ show totW
             ++ "   sources whose text is never named: " ++ show never
  putStrLn ""

  -- 6 -----------------------------------------------------------------------
  -- CLAUDE.md, on the Lean lane: "a module that is not in Pairfield.lean's
  -- import closure is built by nothing, so 'the lane builds' says nothing
  -- about it".  Same measurement, other substrate.
  leanPaths <- filter ((== ".lean") . takeExtension)
               <$> walk [".lake", "_build"] "formal/pairfield"
  leanSrc <- forM leanPaths $ \p -> do { s <- readFileSafe p; return (p, s) }
  let leanName p = intercalate "."
                     (splitOn '/' (dropSuffix ".lean" (dropPrefix "formal/pairfield/" p)))
      leanRaw = M.fromList
        [ (leanName p, [ m | l <- lines s
                           , ("import":m:_) <- [words (takeWhile (/= '-') l)] ])
        | (p, s) <- leanSrc ]
      leanKnown = M.keysSet leanRaw
      -- Mathlib and the toolchain are not this lane's modules; without this
      -- filter the "reached" count exceeds the number of files, which is how
      -- the bug announced itself.
      leanG = M.map (filter (`S.member` leanKnown)) leanRaw
      leanReach = reachFrom leanG [ r | r <- ["Pairfield"], r `S.member` leanKnown ]
      leanOut = sort [ n | n <- S.toList leanKnown, not (n `S.member` leanReach) ]
  putStrLn "=============================================================="
  putStrLn "पेटिका · THE LEAN LANE -- the same question, other substrate"
  putStrLn "=============================================================="
  putStrLn $ "  .lean files (excl. .lake)                       : " ++ show (length leanPaths)
  putStrLn $ "  in Pairfield.lean's import closure              : " ++ show (S.size leanReach)
  putStrLn $ "  OUTSIDE it -- built by nothing                  : " ++ show (length leanOut)
  forM_ leanOut $ \n -> putStrLn ("       " ++ n)
  putStrLn ""

splitOn :: Char -> String -> [String]
splitOn c s = case break (== c) s of
  (a, [])     -> [a]
  (a, _:rest) -> a : splitOn c rest

dropPrefix :: String -> String -> String
dropPrefix p s | p `isPrefixOf` s = drop (length p) s
               | otherwise        = s

dropSuffix :: String -> String -> String
dropSuffix suf s
  | suf `isSuffixOf` s = take (length s - length suf) s
  | otherwise          = s

trivialType :: String -> Bool
trivialType ty =
  ty `elem` ["Type", "Type ℓ", "Set", "Bool", "ℕ", "ℕ → ℕ", "Type₀", "Type0"]

pad :: Int -> String -> String
pad n s = s ++ replicate (n - length s) ' '

padL :: Int -> String -> String
padL n s = replicate (n - length s) ' ' ++ s
