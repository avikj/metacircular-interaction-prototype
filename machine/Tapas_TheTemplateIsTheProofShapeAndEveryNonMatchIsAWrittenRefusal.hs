-- Tapas_TheTemplateIsTheProofShapeAndEveryNonMatchIsAWrittenRefusal.hs
--
-- तपस् · tapas, "heat, disciplined exertion" — the slow work that mints.
--
-- WHAT THIS PROGRAM IS.  The third instrument in the fibre lane, and the
-- first one that EMITS.  `machine/Lopa_…hs` built the one-way graph and
-- reported 1031 of its edges UNDECIDED, because no syntactic rule can name
-- a fibre.  `machine/Upalabdhi_…hs` joined the already-written fibre
-- statements of the corpus against that queue and produced shortlists —
-- and its own header prices them honestly: pair-level false positives
-- ≈ 90%, a LEAD is not a HIT.  This program closes the loop for the small
-- class of edges where the fibre IS nameable syntactically: it reads the
-- edge's DEFINING CLAUSES from the host module and matches them against a
-- template library of proof shapes.  A match yields an emitted Agda probe
-- stating the fibre identification, which the calling script puts to the
-- kernel; the kernel's exit code — not this program — is the verdict.
--
-- THE TEMPLATE LIBRARY, first pass, stated so it can be attacked:
--
--   T-CONST-BOOL   one clause `f <var|_> = false|true`, target ⟨lib⟩.Bool.
--                  Emitted: fiber f v ≃ domain (over the constant's value),
--                  fiber f o ≃ ⊥ in the form ¬ fiber f o (off the value),
--                  and no section exists.  The probe follows the structure
--                  of `formal/cubical/Lopa_TheSumsFibre…agda`: the
--                  identification, both directions, and the no-return.
--   T-FST / T-SND  `f = fst`, `f x = fst x`, `f (a , b) = a` (resp. snd).
--                  RECOGNIZED but NOT emitted this pass; a recognition
--                  without an emitter is recorded as a refusal, not hidden.
--   T-ID           `f x = x` on a named type.  Recognized, not emitted
--                  (and Lopa counts zero endomorphisms, so it is vacuous).
--   T-INL / T-INR  `f x = inl x` / `inr x`.  Recognized, not emitted.
--
-- Everything else is REFUSED WITH A WRITTEN REASON.  The refusal ledger is
-- the product as much as the mint: each refused candidate also records
-- whether Upalabdhi's join had shortlisted it, so this pass doubles as the
-- calibration run that detector's honesty note asks for — its ~90%
-- false-positive estimate finally measured against proof shapes rather
-- than against a hand-checked spread of ten.
--
-- WHAT IS DELIBERATELY NOT CLAIMED.  A refusal here is a statement about
-- THIS template library, never about the edge: T-CONST-BOOL matching
-- nothing would say the corpus writes its small maps as case tables (it
-- does — `bit`, `b2n`, `carryVal`, `twoPrimes` are all two-clause tables,
-- found by hand before this was written), not that their fibres are hard.
-- The two-clause Bool table is the named template gap of this first pass.
--
-- NO ALPHABET IS NAMED ANYWHERE BELOW (the Upalabdhi rule, inherited): a
-- token is what is not whitespace, a name is what is not a delimiter.
-- Two closure gates in this repository once matched a Latin character
-- class and called seventeen Devanagari-named modules orphans.
--
-- Usage:
--   runghc machine/Tapas_…hs LOPA_OUT JOIN_OUT ROOT SCRATCH
--
--     LOPA_OUT  the captured stdout of machine/Lopa_…hs
--     JOIN_OUT  the captured stdout of machine/Upalabdhi_…hs --join
--               (pass a nonexistent path to run without shortlists)
--     ROOT      repository root
--     SCRATCH   directory into which probes are emitted
--
-- Output: a TSV ledger on stdout, one row per tractable candidate:
--   MINTED  <site> <src> ⟶ <tgt> <template> <probe-file> shortlist=<...>
--   REFUSED <site> <src> ⟶ <tgt> <reason>              shortlist=<...>
-- plus a PRASAVA-style tail summary.  Probes go to SCRATCH; landing,
-- kernel-checking and wiring belong to scripts/Tapas_…sh, not here.

module Main (main) where

import Data.Char (isSpace)
import Data.List (isPrefixOf, isInfixOf, isSuffixOf, intercalate, nub)
import Data.Maybe (mapMaybe, fromMaybe)
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import System.Directory (doesFileExist, createDirectoryIfMissing)
import System.Environment (getArgs)
import System.FilePath ((</>))
import System.IO

import Aisthesis_TheOneSensoryEventFormAndTheEfferenceGateNoActWithoutAPrediction
  ( Aisthesis(..), Sarira, sariraP, appendEvent )
import Pramanya_TheFiveRoutesAndTheirWitnesses (Pramanya(Pratyaksa))
import Sabda_TheWireHasNoBoolean (J(..), parseLine, look)
import Data.Time.Clock (getCurrentTime)
import Data.Time.Format (formatTime, defaultTimeLocale)

-- ── small text utilities ─────────────────────────────────────────────────

trim :: String -> String
trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse

splitOn :: Char -> String -> [String]
splitOn c s = case break (== c) s of
  (a, _:r) -> a : splitOn c r
  (a, [])  -> [a]

-- the last '.'-component of a qualified name, and everything before it
unqualify :: String -> (String, String)
unqualify q = case splitOn '.' q of
  [x] -> ("", x)
  xs  -> (intercalate "." (init xs), last xs)

readUtf8 :: FilePath -> IO String
readUtf8 p = do
  h <- openFile p ReadMode
  hSetEncoding h utf8
  hGetContents h

-- line comments only; block comments in signature/clause position are rare
-- and a false negative here is a refusal, never a wrong mint — the kernel
-- stands between every emission and the tree.
stripLineComment :: String -> String
stripLineComment [] = []
stripLineComment ('-':'-':_) = []
stripLineComment (c:r) = c : stripLineComment r

-- ── the edge list, from Lopa's own output ────────────────────────────────

data Edge = Edge { eSrc :: String, eTgt :: String, eSite :: String }
  deriving (Eq, Show)

-- `  [kind] SRC  ⟶  TGT   « SITE`
parseEdgeLine :: String -> Maybe Edge
parseEdgeLine l
  | "  [" `isPrefixOf` l
  , '«' `elem` l
  , '⟶' `elem` l
  = let (lhs, rhs)   = break (== '«') l
        site         = trim (drop 1 rhs)
        afterKind    = drop 1 (dropWhile (/= ']') lhs)
        (src, tgt)   = break (== '⟶') afterKind
    in Just (Edge (trim src) (trim (drop 1 tgt)) site)
  | otherwise = Nothing

section :: String -> String -> [String]
section header out =
  takeWhile (not . ("── " `isPrefixOf`) . trim)
    (drop 1 (dropWhile (not . (header `isInfixOf`)) (lines out)))

-- ── the shortlist, from Upalabdhi's join output ──────────────────────────

shortlistOf :: String -> M.Map String String
shortlistOf out = M.fromListWith better
  [ (site, grade)
  | l <- lines out
  , let fs = splitOn '\t' l
  , (grade:_:_:site:_) <- [fs]
  , grade `elem` ["NAMED-MAP", "TYPE-ONLY"] ]
  where better a b = if a == "NAMED-MAP" || b == "NAMED-MAP" then "NAMED-MAP" else a

-- ── tractability: the conservative gate ──────────────────────────────────

libAtoms :: [String]
libAtoms = ["⟨lib⟩.Bool", "⟨lib⟩.ℕ", "⟨lib⟩.ℤ", "⟨lib⟩.Unit"]

isLibFin :: String -> Bool
isLibFin s = "⟨lib⟩.Fin " `isPrefixOf` s && all (`elem` "0123456789") (drop 10 s)

isSmallNamed :: String -> Bool
isSmallNamed s =
  s `elem` libAtoms || isLibFin s || "⟨lib⟩.SumFin " `isPrefixOf` s
  || (notElem ' ' s && not ("⟨" `isPrefixOf` s) && '.' `elem` s)
     -- a single qualified corpus name, no applications, no ambiguity marks

tractable :: Edge -> Bool
tractable e = (eTgt e `elem` libAtoms || isLibFin (eTgt e)) && isSmallNamed (eSrc e)

-- ── the host module's defining clauses ───────────────────────────────────

hostFileOf :: FilePath -> String -> IO (Maybe FilePath)
hostFileOf root m = go candidates
  where
    rel = map (\c -> if c == '.' then '/' else c) m ++ ".agda"
    candidates = [ root </> "formal/cubical" </> rel
                 , root </> "punaragamana/src" </> rel
                 , root </> "formal/executable" </> rel ]
    go [] = return Nothing
    go (p:ps) = do ok <- doesFileExist p
                   if ok then return (Just p) else go ps

-- top-level clauses of one name: column-0 lines whose first token is the
-- name and which carry an `=` outside any signature (a `:` before the `=`
-- marks the signature and is skipped).
clausesOf :: String -> String -> [([String], String)]
clausesOf nm src =
  [ (pats, trim rhs)
  | l0 <- lines src
  , let l = stripLineComment l0
  , not (null l), not (isSpace (head' l))
  , let ws = words l
  , take 1 ws == [nm]
  , let body = drop 1 ws
  , let (lhs, rest) = break (== "=") body
  , not (null rest)
  , ":" `notElem` lhs
  , let pats = lhs
  , let rhs = unwords (drop 1 rest) ]
  where head' s = case s of (c:_) -> c; [] -> ' '

-- ── template recognition ─────────────────────────────────────────────────

recognize :: Edge -> [([String], String)] -> Either String (String, String)
-- Left reason | Right (template, constantValue)
recognize e cls
  | null cls = Left "no column-0 defining clause found in host (record field, where-block, or pattern lambda)"
  | eTgt e == "⟨lib⟩.Bool"
  , [([p], v)] <- cls
  , v `elem` ["false", "true"]
  , p /= "false", p /= "true"
  , not ('(' `elem` p)
  = Right ("T-CONST-BOOL", v)
  | [(_, rhs)] <- cls, rhs == "fst" || "fst " `isPrefixOf` rhs
  = Left "matches T-FST but the fst emitter is not implemented this pass"
  | [(_, rhs)] <- cls, rhs == "snd" || "snd " `isPrefixOf` rhs
  = Left "matches T-SND but the snd emitter is not implemented this pass"
  | [([p], rhs)] <- cls, rhs == p
  = Left "matches T-ID but the identity emitter is not implemented this pass"
  | [(_, rhs)] <- cls, "inl " `isPrefixOf` rhs || "inr " `isPrefixOf` rhs
  = Left "matches T-INL/T-INR but the sum emitter is not implemented this pass"
  | length cls >= 2, all (constantish . snd) cls
  = Left "case table (several clauses of literal values): the NAMED TEMPLATE GAP of this pass — its fibre splits along the finite domain and no template states that yet"
  | otherwise
  = Left "matches no template in the library (arithmetic, recursion, or constructed value)"
  where constantish r = r `elem` ["false","true","0","1","zero"] || "suc " `isPrefixOf` r

-- ── the emitter: T-CONST-BOOL ────────────────────────────────────────────

emitConstBool :: Edge -> String -> String -> Maybe (String, String)
emitConstBool e host v
  | (srcMod, srcBase) <- unqualify (eSrc e)
  , srcMod == host                    -- domain importable from the host
  , (_, mapBase) <- unqualify (eSite e)
  = let o    = if v == "false" then "true" else "false"
        neq  = if v == "false" then "false≢true" else "true≢false"
        nm   = "ConstantFibre_" ++ map dash host ++ "_" ++ mapBase
        dash c = if c == '.' then '-' else c
        txt = unlines
          [ "{-# OPTIONS --cubical --safe --no-import-sorts #-}"
          , ""
          , "------------------------------------------------------------------------"
          , "-- तपस् — a MINTED fibre receipt.  Emitted by"
          , "-- machine/Tapas_TheTemplateIsTheProofShapeAndEveryNonMatchIsAWrittenRefusal.hs"
          , "-- from template T-CONST-BOOL, then CHECKED BY THE KERNEL before landing;"
          , "-- the only later edit is the module line, qualified to its path."
          , "--"
          , "-- THE EDGE (Lopa's queue, verdict UNDECIDED before this module):"
          , "--   " ++ eSrc e ++ "  ⟶  " ++ eTgt e
          , "--   « " ++ eSite e
          , "--"
          , "-- WHAT IS PROVED, following the structure of"
          , "-- Lopa_TheSumsFibreIsExactlyNPlusOneAndNoLeftInverseExists:"
          , "--   §1  over the constant's value " ++ v ++ ", the fibre IS the domain:"
          , "--       fiber " ++ mapBase ++ " " ++ v ++ " ≃ " ++ srcBase ++ ".  A constant map loses"
          , "--       EVERYTHING, and the fibre says so exactly: the elided datum is"
          , "--       the whole input."
          , "--   §2  off the value the fibre is EMPTY: ¬ fiber " ++ mapBase ++ " " ++ o ++ "."
          , "--       रिक्तम् — the third verdict, which a two-valued isContr check"
          , "--       conflates with §1's opposite."
          , "--   §3  hence no section, and so certainly no left inverse in the other"
          , "--       role: nothing the map does can be undone, because half the"
          , "--       codomain is never reached."
          , "--"
          , "-- WHAT IS NOT CLAIMED.  Nothing about any other edge; nothing about the"
          , "-- host's own theorems.  " ++ srcBase ++ " is imported, not re-proved."
          , "------------------------------------------------------------------------"
          , ""
          , "module " ++ nm ++ " where"
          , ""
          , "open import Cubical.Foundations.Prelude"
          , "open import Cubical.Foundations.Equiv using (_≃_ ; fiber)"
          , "open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)"
          , "open import Cubical.Data.Bool using (Bool ; false ; true ; isSetBool ; " ++ neq ++ ")"
          , "open import Cubical.Data.Empty using (⊥)"
          , "open import Cubical.Data.Sigma using (_,_ ; fst ; snd)"
          , "open import Cubical.Relation.Nullary using (¬_)"
          , ""
          , "open import " ++ host ++ " using (" ++ srcBase ++ " ; " ++ mapBase ++ ")"
          , ""
          , "-- §1 · over the value: the fibre is the whole domain."
          , "over-value : fiber " ++ mapBase ++ " " ++ v ++ " ≃ " ++ srcBase
          , "over-value = isoToEquiv i where"
          , "  i : Iso (fiber " ++ mapBase ++ " " ++ v ++ ") " ++ srcBase
          , "  Iso.fun i = fst"
          , "  Iso.inv i x = x , refl"
          , "  Iso.rightInv i x = refl"
          , "  Iso.leftInv i (x , p) j = x , isSetBool " ++ v ++ " " ++ v ++ " refl p j"
          , ""
          , "-- §2 · off the value: the fibre is empty (रिक्तम्, the third verdict)."
          , "off-value : ¬ fiber " ++ mapBase ++ " " ++ o
          , "off-value (x , p) = " ++ neq ++ " p"
          , ""
          , "-- §3 · no section: the map reaches half the codomain and no map back"
          , "-- can pretend otherwise."
          , "no-section : (g : Bool → " ++ srcBase ++ ") → ((b : Bool) → " ++ mapBase ++ " (g b) ≡ b) → ⊥"
          , "no-section g s = " ++ neq ++ " (s " ++ o ++ ")"
          ]
    in Just (nm, txt)
  | otherwise = Nothing

-- ── main ─────────────────────────────────────────────────────────────────

main :: IO ()
main = do
  hSetEncoding stdout utf8
  args <- getArgs
  case args of
    [lopaOut, joinOut, root, scratch] -> run lopaOut joinOut root scratch
    _ -> hPutStrLn stderr "usage: Tapas LOPA_OUT JOIN_OUT ROOT SCRATCH" >> return ()

run :: FilePath -> FilePath -> FilePath -> FilePath -> IO ()
run lopaOut joinOut root scratch = do
  createDirectoryIfMissing True scratch
  lopa <- readUtf8 lopaOut
  haveJoin <- doesFileExist joinOut
  shortlist <- if haveJoin then shortlistOf <$> readUtf8 joinOut else return M.empty
  let decided = S.fromList
        [ trim (drop 1 (dropWhile (/= '«') l))
        | l <- section "EVERY DECIDED VERDICT" lopa, '«' `elem` l ]
      edges   = mapMaybe parseEdgeLine (section "EVERY GENUINE ONE-WAY EDGE" lopa)
      undec   = [ e | e <- edges, not (eSite e `S.member` decided)
                    , not ("Ratri." `isPrefixOf` eSite e) ]
      cands   = nub [ e | e <- undec, tractable e ]
  rows <- mapM (judge root scratch shortlist) cands
  mapM_ (putStrLn . fst) rows
  let minted  = length [ () | (_, True)  <- rows ]
      refused = length [ () | (_, False) <- rows ]
      slAll   = length [ () | e <- cands, M.member (eSite e) shortlist ]
      slRef   = length [ () | ((r, ok), e) <- zip rows cands
                            , not ok, M.member (eSite e) shortlist, let _ = r ]
  putStrLn ""
  putStrLn "── तपस् · pass summary ──"
  putStrLn ("  edges in Lopa's genuine one-way list : " ++ show (length edges))
  putStrLn ("  of which UNDECIDED                   : " ++ show (length undec))
  putStrLn ("  tractable candidates (gate above)    : " ++ show (length cands))
  putStrLn ("  probes emitted (template matched)    : " ++ show minted)
  putStrLn ("  refused with a written reason        : " ++ show refused)
  putStrLn ("  candidates carrying an Upalabdhi shortlist lead : " ++ show slAll)
  putStrLn ("  of those, refused by every template  : " ++ show slRef
            ++ "   ← the calibration its ~90% estimate asked for, at candidate level")
  putStrLn "  (emission is not landing: the kernel's exit code, taken by the"
  putStrLn "   calling script standing where the probe will live, is the verdict)"
  -- ── the pass is an act, and an act carries its efference copy ─────────
  -- Baseline: the journal's last recorded beat (jiva writes one per run).
  -- Prediction: emission into SCRATCH moves nothing — the body changes
  -- only when the calling script lands a probe, which is a later act.
  -- If no beat was ever recorded, the gate refuses this event and the
  -- refusal is what enters the journal: acting on an unread body is pain,
  -- written, never silence.
  let journal = root </> "machine" </> "aisthesis.jsonl"
  purva <- lastBeat journal
  now <- formatTime defaultTimeLocale "%Y-%m-%dT%H:%M:%SZ" <$> getCurrentTime
  _ <- appendEvent journal Aisthesis
    { aIndriya = "tapas"
    , aNaya    = "paryayarthika — one fibre at a time, in the one-way sector"
    , aVisaya  = show (length cands) ++ " tractable candidates of "
                 ++ show (length undec) ++ " undecided one-way edges"
    , aKriya   = Just ("emit " ++ show minted ++ " probes into scratch; refuse "
                       ++ show refused ++ " with written reasons")
    , aUpalabdhi = JObj [ ("minted", JInt (fromIntegral minted))
                        , ("refused", JInt (fromIntegral refused)) ]
    , aYogyata = "template vocabulary of this pass only; a refusal is a nonmatch, never a mathematical verdict"
    , aVyapti  = "Lopa's genuine one-way list, minus decided, minus Ratri"
    , aMarga   = Pratyaksa "the TSV rows above; every refusal carries its reason inline"
    , aSesa    = [ show refused ++ " sites refused by every template — the instrument's fixed point, not the mathematics'" ]
    , aPurva   = purva
    , aBhavi   = purva      -- emission to scratch: the body does not move
    , aPascat  = Nothing    -- pending: the landing script is the act's completion
    , aVailaksanya = []
    , aAgama   = "machine/Tapas_…hs, this pass; baseline from the journal's last beat"
    , aKala    = now
    }
  return ()

-- the last heartbeat any organ journalled: read backwards, first event
-- whose upalabdhi carries one.  No beat, no baseline — Nothing, and the
-- gate says what that costs.
lastBeat :: FilePath -> IO (Maybe Sarira)
lastBeat p = do
  ex <- doesFileExist p
  if not ex then return Nothing else do
    h <- openFile p ReadMode
    hSetEncoding h utf8
    ls <- lines <$> hGetContents h
    let beats = [ s | l <- reverse ls
                    , Right j <- [parseLine l]
                    , Right u <- [look "upalabdhi" j]
                    , Right hb <- [look "heartbeat" u]
                    , Right s <- [sariraP hb] ]
    length ls `seq` hClose h
    return (case beats of { (s:_) -> Just s; [] -> Nothing })

judge :: FilePath -> FilePath -> M.Map String String -> Edge -> IO (String, Bool)
judge root scratch shortlist e = do
  let (host, base) = unqualify (eSite e)
      sl = fromMaybe "NO" (M.lookup (eSite e) shortlist)
      row tag rest = intercalate "\t"
        [tag, eSite e, eSrc e ++ " ⟶ " ++ eTgt e, rest, "shortlist=" ++ sl]
  mf <- hostFileOf root host
  case mf of
    Nothing -> return (row "REFUSED" "host module file not found under any lane root", False)
    Just f -> do
      src <- readUtf8 f
      case recognize e (clausesOf base src) of
        Left why -> return (row "REFUSED" why, False)
        Right (tpl, v) ->
          case emitConstBool e host v of
            Nothing -> return
              (row "REFUSED" (tpl ++ " matched but the domain is not a type of the host module itself (emitter limit, first pass)"), False)
            Just (nm, txt) -> do
              let out = scratch </> (nm ++ ".agda")
              h <- openFile out WriteMode
              hSetEncoding h utf8
              hPutStr h txt
              hClose h
              return (row "MINTED" (tpl ++ " → " ++ nm ++ ".agda"), True)
