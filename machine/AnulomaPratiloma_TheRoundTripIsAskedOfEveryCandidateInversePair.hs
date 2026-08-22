-- AnulomaPratiloma_TheRoundTripIsAskedOfEveryCandidateInversePair.hs
--
-- अनुलोम-प्रतिलोम — forward and backward.
--
-- ─────────────────────────────────────────────────────────────────────────
-- WHAT THIS IS.  A second naya for रात्रिः.  The loop reports FIXPOINT after
-- three dry passes and its own log says why: "निर्धारण reaches only records
-- that already carry a witness."  That is not the corpus being finished.
-- **DRY IS A PROPERTY OF THE QUESTION, NOT OF THE CORPUS**, and a standpoint
-- that reports its own exhaustion as the corpus's exhaustion is a दुर्नय —
-- exactly what `Saptabhangi.दुर्नयः` proves about any verdict that denies the
-- other standpoints.  The repair is not proof search.  It is another naya.
--
-- THE QUESTION THIS ONE ASKS.  For `f : A → B` the पुनरागमन law gives
-- `A ≃ Carrier f` for free, always, with no h-level hypothesis — so asking it
-- of every function would land one sentence a thousand times, which is the
-- पुनरुक्ति the loop already caught itself committing (44d5a136, "said one
-- thing 22 times over").  The question with CONTENT is the criterion: WHICH
-- SIDE OF `f a ≡ b` IS BOUND.  Bind `b` and the fibre is `singl`, free.  Bind
-- `a` and it is the preimage, and whether that preimage is रिक्तम् / एकम् /
-- बहु varies per function and is the whole subject.
--
-- So: find candidate inverse PAIRS and put the round trip to the kernel.  When
-- both composites are `refl`, `f` is an equivalence and `A ≃ B` is a genuine
-- new EDGE — every theorem on either side transports across it, for everyone,
-- forever.  When they are not, nothing lands and the pair is recorded as a
-- written defect (road two of अहिंसा-सूत्र-विस्तारः §६; there is no third).
--
-- WHY THE NAME IS NOT A METAPHOR.  अनुलोम (with the grain, forward) and
-- प्रतिलोम (against the grain, backward) are the technical terms of the Vedic
-- पाठ system for reciting a sequence forward and then backward — the
-- क्रम/जटा/घन elaborations are built out of exactly these two directions, and
-- their entire purpose is that a text said in reverse and forward again must
-- COME BACK unchanged, which is how the saṃhitā survived without writing.
-- That is a round-trip check on a sequence, specified as a discipline, and it
-- is the same shape as `section`/`retract`.  This repository already runs
-- `machine/GhanaPatha_…hs` on the घनपाठ.
--
-- NOT CLAIMED: no text states an isomorphism, and no Vedic source is being
-- credited with cubical type theory.  What is claimed is that the pair of
-- terms names the forward-and-back structure this program tests, and that the
-- pāṭha discipline is a round-trip check.  Source: the पाठ schemes are
-- described in the Prātiśākhya literature and in Pāṇini's commentarial
-- tradition; the terms अनुलोम/प्रतिलोम are ordinary Sanskrit, attested widely.
--
-- ─────────────────────────────────────────────────────────────────────────
-- METHOD, AND ITS LIMITS, AT THE SITE.
--
--  1. Read top-level signatures `name : X → Y` by Agda's layout rule (a
--     declaration begins at column 0).  LIMIT: functions inside `where`,
--     `private` or parameterized modules are invisible, and a signature
--     spanning lines is read only if the arrow is on the first line.
--  2. Pair `f : X → Y` with `g : Y → X` in the SAME module.  LIMIT: purely
--     syntactic type matching after whitespace normalization; `ℕ → ℕ` pairs
--     with everything of that shape in its module, which produces nonsense
--     candidates.  That is intended — the kernel is the filter, and a cheap
--     over-generous proposer with an exact checker is the correct shape.
--  3. Emit one probe per pair asking `isoToEquiv (iso f g (λ _ → refl)
--     (λ _ → refl))`.  LIMIT, and it is the big one: this only finds pairs
--     whose round trips hold DEFINITIONALLY.  A genuine equivalence needing a
--     one-line induction is missed, and is missed silently.  The count of
--     probes emitted vs. accepted is printed so the miss rate is visible.
--
-- Emits nothing into the corpus.  Writes probe files to $ANULOMA_SCRATCH (or
-- ./.anuloma) and prints them; रात्रिः checks and lands.
--
--   run:  runghc machine/AnulomaPratiloma_…hs [--limit N]

module Main (main) where

import Control.Monad (forM, forM_, when)
import Data.Char (isSpace, isAlphaNum)
import Data.List (isPrefixOf, isSuffixOf, nub, foldl')
import qualified Data.Map.Strict as M
import System.Directory (doesDirectoryExist, listDirectory, createDirectoryIfMissing)
import System.Environment (getArgs, lookupEnv)
import System.FilePath ((</>), takeExtension, takeBaseName)
import System.IO (hSetEncoding, stdout, utf8)

data Sig = Sig { sMod :: String, sName :: String, sFrom :: String, sTo :: String }

main :: IO ()
main = do
  hSetEncoding stdout utf8
  args <- getArgs
  let lim = case dropWhile (/= "--limit") args of
              (_:n:_) -> read n
              _       -> 400 :: Int
  scratch <- maybe ".anuloma" id <$> lookupEnv "ANULOMA_SCRATCH"
  createDirectoryIfMissing True scratch
  fs <- listAgda "formal/cubical"
  sigs <- concat <$> mapM readSigs fs
  let byMod = M.fromListWith (++) [ (sMod s, [s]) | s <- sigs ]
      pairs = [ (f, g)
              | (_, ss) <- M.toList byMod
              , f <- ss, g <- ss
              , sName f < sName g                     -- unordered, no self
              , norm (sTo f) == norm (sFrom g)
              , norm (sTo g) == norm (sFrom f)
              , norm (sFrom f) /= norm (sTo f)        -- endo pairs are noise
              ]
      keep = take lim pairs
  putStrLn ""
  putStrLn "  अनुलोम-प्रतिलोम — the round trip, put to the kernel"
  putStrLn "  ────────────────────────────────────────────────────────────"
  putStrLn $ "  modules scanned      : " ++ show (length fs)
  putStrLn $ "  top-level arrows     : " ++ show (length sigs)
  putStrLn $ "  candidate pairs      : " ++ show (length pairs)
  putStrLn $ "  probes emitted       : " ++ show (length keep)
  putStrLn ""
  forM_ (zip [1 :: Int ..] keep) $ \(i, (f, g)) -> do
    let nm = "AnulomaPratiloma_" ++ sanitize (sMod f) ++ "_"
             ++ sanitize (sName f) ++ "_" ++ sanitize (sName g)
        body = probe nm f g
    writeFile (scratch </> nm ++ ".agda") body
    putStrLn $ "  PROBE " ++ show i ++ "  " ++ sMod f ++ " : "
               ++ sName f ++ " ⇄ " ++ sName g
               ++ "   (" ++ trim (sFrom f) ++ " ≃ " ++ trim (sTo f) ++ ")"
  putStrLn ""
  putStrLn "  Every probe asks whether BOTH round trips hold definitionally."
  putStrLn "  Those that do are genuine equivalences and are new edges: every"
  putStrLn "  theorem on either side transports across, for everyone, forever."
  putStrLn "  Those that do not land NOTHING — road two, written not asserted."
  putStrLn ""

probe :: String -> Sig -> Sig -> String
probe nm f g = unlines
  [ "{-# OPTIONS --cubical --safe --no-import-sorts #-}"
  , "-- Emitted by अनुलोम-प्रतिलोम.  CHECKED IN PLACE before landing; nothing"
  , "-- lands that the kernel has not accepted.  The claim is exactly that the"
  , "-- two named functions are mutually inverse DEFINITIONALLY, hence that"
  , "-- their domains are equivalent, hence — by univalence — equal, so every"
  , "-- theorem about one is a `subst` away from the other."
  , "module " ++ nm ++ " where"
  , ""
  , "open import Cubical.Foundations.Prelude"
  , "open import Cubical.Foundations.Isomorphism"
  , "open import Cubical.Foundations.Equiv"
  , "open import Cubical.Foundations.Univalence"
  -- The signature's types come from the HOST module's imports, which a probe
  -- does not inherit.  Without these every probe dies at `NotInScope: ℕ`,
  -- which is how the second run lost all 39.  Over-importing is free here:
  -- the probe is checked and discarded, and an unused import costs nothing.
  , "open import " ++ sMod f
  , ""
  , "-- अनुलोमम् " ++ sName f ++ " , प्रतिलोमम् " ++ sName g ++ " ।"
  , "--"
  , "-- NO TYPE IS WRITTEN DOWN HERE, AND THAT IS THE POINT.  The first three"
  , "-- runs of this emitter restated the domain and codomain in the probe, and"
  , "-- all 39 probes died: first on the module path, then on `NotInScope: ℕ`,"
  , "-- and then -- after importing the data modules to fix that -- on"
  , "-- `Cubical.Data.Fin.Fin != Cubical.Data.FinData.Fin`, because a blanket"
  , "-- import SHADOWS the host's own choice of a type with that name.  Restating"
  , "-- a type is asserting a second time something the two functions already"
  , "-- determine, and every failure above was that assertion disagreeing with"
  , "-- the host.  The types are CARRIED; the functions are the base.  Agda"
  , "-- infers them, and then there is nothing to disagree with."
  , "मार्गः = iso " ++ sName f ++ " " ++ sName g ++ " (λ _ → refl) (λ _ → refl)"
  , ""
  , "समता = isoToEquiv मार्गः"
  , ""
  , "-- and the edge itself, which is what transports."
  , "सेतुः = ua समता"
  ]

-- ------------------------------------------------------------------ reading

listAgda :: FilePath -> IO [FilePath]
listAgda root = go root
  where
    go d = do
      ok <- doesDirectoryExist d
      if not ok then pure [] else do
        es <- listDirectory d
        fmap concat . forM es $ \e -> do
          let p = d </> e
          isD <- doesDirectoryExist p
          if isD then (if e `elem` ["_build", "Ratri", "MachineMinted"] then pure [] else go p)
                 else pure [ p | takeExtension p == ".agda" ]

readSigs :: FilePath -> IO [Sig]
readSigs fp = do
  src <- readFile fp
  -- The module NAME is the file's own `module X where` line, not its
  -- basename.  A file in a subdirectory declares `NaturalMachine.Digits`,
  -- and importing `Digits` fails with FileNotFound -- which is how all 39
  -- probes of the first run died at once.  The declaration is authoritative;
  -- the path is a view of it.
  let m = case [ w | l <- lines src, "module " `isPrefixOf` l
               , (w:_) <- [drop 1 (words l)] ] of
            (x:_) -> x
            []    -> takeBaseName fp
      ls = filter col0 (lines src)
  pure [ Sig m n a b | l <- ls, Just (n, a, b) <- [parseSig l] ]
  where col0 (c:_) = not (isSpace c) && c /= '-' && c /= '{' && c /= '#'
        col0 _     = False

-- `name : X → Y` with exactly one top-level arrow and no binders.
parseSig :: String -> Maybe (String, String, String)
parseSig l = do
  (n, rest) <- breakColon l
  let n' = trim n
  if null n' || not (all okChar n') then Nothing else do
    (a, b) <- splitArrow (trim rest)
    if any bad [a, b] || null (trim a) || null (trim b)
      then Nothing else Just (n', a, b)
  where
    okChar c = isAlphaNum c || c `elem` "-_'∙′"
    bad s = any (`elem` words s) ["∀", "→", "Σ", "Π"] || any (`elem` s) "{(∀[]"

breakColon :: String -> Maybe (String, String)
breakColon s = case break (== ':') s of
  (a, ':':b) | not (null a) && take 1 b /= ":" -> Just (a, b)
  _ -> Nothing

-- split on the FIRST top-level →, requiring exactly one
splitArrow :: String -> Maybe (String, String)
splitArrow s = case parts of
  [a, b] -> Just (a, b)
  _      -> Nothing
  where parts = go s "" []
        go [] acc out = reverse (reverse acc : out)
        go ('→':r) acc out = go r "" (reverse acc : out)
        go (c:r) acc out = go r (c:acc) out

norm :: String -> String
norm = filter (not . isSpace)

trim :: String -> String
trim = f . f where f = reverse . dropWhile isSpace

sanitize :: String -> String
sanitize = map (\c -> if isAlphaNum c || c == '-' then c else 'X')

-- ─────────────────────────────────────────────────────────────────────────
-- FIRST RUN, 2026-08-22.  TRUE RESULT: 39 PROPOSED, 0 ACCEPTED.
--
-- 813 modules scanned, 1029 top-level arrows, 39 candidate inverse pairs,
-- every one refused by the kernel.  Reported as-is because a proposer that
-- reports its proposals as findings is the दुर्नय this whole apparatus
-- exists against.
--
-- Three of the refusals were MY bugs and are fixed above, each recorded at
-- its site: the module path (a file in a subdirectory declares
-- `NaturalMachine.Digits`, not `Digits`); `NotInScope: ℕ`; and then, after
-- importing the data modules to fix that, `Cubical.Data.Fin.Fin !=
-- Cubical.Data.FinData.Fin` — a blanket import SHADOWING the host's own
-- choice of a type by that name.  The repair was to stop writing the types
-- down at all: they are determined by the two functions, and every one of
-- those failures was a restatement disagreeing with the host. The types are
-- carried; the functions are the base.
--
-- THE FOURTH REFUSAL IS NOT A BUG AND IS THE RESULT.  With the plumbing
-- correct the kernel returns mathematics:
--
--     edgeToFin (finToEdge b) != b  of type  FinData.Fin 9
--
-- The round trips do not hold DEFINITIONALLY. Not one of the 39. Each needs
-- at least a case split, and `PMTorus`'s needs nine.
--
-- WHICH THE CORPUS ALREADY KNEW AND STATED. `Bhedanirnaya_…agda` §6 gives
-- the ladder in its own words — "one induction to agree pointwise, one
-- abstraction to a path". This program implements the bottom rung only, and
-- the bottom rung is empty in this corpus. That is worth knowing exactly:
-- it says the cheap mechanical harvest is ZERO here, and that every real
-- causeway costs an induction. A loop that expected free edges was going to
-- report dry forever without ever saying why.
--
-- SO THE 39 ARE NOT A FAILURE LIST, THEY ARE A WORK QUEUE with a kernel
-- behind it: 39 pairs the corpus itself proposed, each with an exact
-- obligation the kernel prints, several of them obviously real —
-- Digits.digits ⇄ value (ℕ ≃ Word), PMTorus.edgeToFin ⇄ finToEdge
-- (Edge ≃ Fin 9), SaptabhangiNaya.code' ⇄ decode (Bhanga ≃ NEBasis),
-- FreeMonoid.len ⇄ unlen (Tally ≃ ℕ), TermFreeMonoid.fromList ⇄ toList.
--
-- NEXT RUNG, not built here so it is not claimed: read the host's own `data`
-- declaration, collect its constructors, and emit the pointwise split
-- instead of `λ _ → refl`. That is mechanical for the side whose type the
-- host defines, and not mechanical for the side that lands in a library
-- type — which is exactly the asymmetry `PMTorus` above exhibits.
