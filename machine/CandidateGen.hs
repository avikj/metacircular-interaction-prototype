-- CandidateGen.hs — mint Agda candidate modules from the head-depth carrier.
--
-- WHAT THIS IS
--
-- MathMachine's admission discipline (message 0484: only agda exit 0
-- installs; 0487: private staging; AgdaRewriteGate: the certificate carries
-- its exact conclusion) applied to the corpus' merged head-depth organ,
-- formal/cubical/HeadDepthMerge.agda.  The generator:
--
--   1. GENERATES candidate facts over the carrier e_b(q) = v_q(b^ord_q(b)-1)
--      on ranges the corpus has never certified:
--        * fresh (q,a,b) threshold scans (W3 + strong-equivalence) at
--          q = 29, 31 — HeadDepthMerge's certified range stops at q = 23;
--        * W4 subgroup counts blindCount q a at fresh (q,a) pairs;
--        * a Wieferich scan over the fresh prime window (3511, 3700].
--   2. REFUTES candidates by exact Integer computation: every generated
--      module's facts are evaluated first by a Haskell mirror that
--      transcribes HeadDepthMerge's fueled definitions clause for clause.
--      A candidate the mirror refutes is never submitted (logged REFUTED).
--   3. GATES the survivors: each candidate is serialized as a --safe
--      cubical Agda module under formal/cubical/MachineMinted/ and checked
--      with the same invocation shape as machine/Certificate.hs
--      (agda -i formal/cubical --library=cubical).  Exit 0 is the ONLY
--      admission criterion; a rejected module is deleted, not kept.
--   4. CONTROLS itself: one deliberate falsehood (wieferich 1091 ≡ true —
--      HeadDepthMerge certifies the negation) is submitted through the
--      identical path and MUST be rejected.  If the kernel ever accepts it,
--      the run deletes it and exits nonzero: an unsound gate installs
--      nothing.
--   5. INDEXES what survived: MachineMinted/Everything.agda is regenerated
--      from the directory listing and gated too, so no minted module is an
--      orphan the build never replays (the exact hole formal/cubical's
--      Everything.agda exists to close, one level down).
--
-- WHAT THE MINTED FACTS ARE, HONESTLY
--
-- Instance certificates, not new laws.  W3 (Fermat blindness on q^a iff
-- a <= e_b(q)) and W4 (blind bases form the subgroup of order q-1) are
-- proved in the corpus; HEAD_DEPTH_MERGE's strong-liar equality is proved
-- in its header.  What the kernel had certified was the finite range
-- q <= 23.  Each minted module is a CHECKED TERM extending the certified
-- range — finite exhaustive verification, which CLAUDE.md classifies as
-- proof, and the only computation class this repository permits.  The
-- Wieferich window facts are the same threshold reading e_2(q) >= 2 on
-- primes no organ of this corpus has touched.
--
-- Build and run, from the repository root:
--
--     ghc -O -Wall -outputdir /tmp/candidate-gen-build \
--         -o /tmp/candidate-gen machine/CandidateGen.hs
--     /tmp/candidate-gen            # or: /tmp/candidate-gen <repo-root>
--
-- Every decision is appended to machine/minted.log, never rewritten.

module Main (main) where

import qualified Certificate as C
import Control.Monad (forM, forM_, unless, when)
import Data.List (intercalate, isSuffixOf, sort)
import GHC.IO.Encoding (setLocaleEncoding)
import System.Directory
  (createDirectoryIfMissing, listDirectory, removeFile)
import System.Environment (getArgs, getEnvironment)
import System.Exit (ExitCode (..), exitFailure)
import System.FilePath ((</>))
import System.IO
import System.Process (CreateProcess (..), proc, readCreateProcessWithExitCode)

-- =====================================================================
-- The Haskell mirror of HeadDepthMerge.agda.
--
-- Clause-for-clause transcription of the fueled definitions, on Integer.
-- The mirror exists to REFUTE candidates before an agda call is spent and
-- to predict the exact constants the modules assert.  It carries no
-- authority: admission is agda exit 0 and nothing else.
-- =====================================================================

-- _%%_ : n %% zero = n; n %% suc m = n mod (suc m)
infixl 7 %%
(%%) :: Integer -> Integer -> Integer
n %% 0 = n
n %% m = n `mod` m

-- _//_ : n // zero = 0; n // suc m = n div (suc m)
infixl 7 //
(//) :: Integer -> Integer -> Integer
_ // 0 = 0
n // m = n `div` m

-- monus, as Cubical.Data.Nat._∸_
monus :: Integer -> Integer -> Integer
monus a b = max 0 (a - b)

-- power b n = b ^ n (non-modular, exactly as the Agda)
powerN :: Integer -> Integer -> Integer
powerN b n = b ^ n

-- powMod fuel m b e — the fueled square-and-multiply, fuel 40 at all
-- use sites, exactly as in HeadDepthMerge
powModM :: Integer -> Integer -> Integer -> Integer -> Integer
powModM 0 m _ _ = 1 %% m
powModM f m b e
  | e == 0 = 1 %% m
  | otherwise =
      let h = powModM (f - 1) m ((b * b) %% m) (e // 2)
      in if e %% 2 == 1 then (b * h) %% m else h

-- ord q b: multiplicative order of b mod q, fuel q; 0 on fuel exhaustion
ordN :: Integer -> Integer -> Integer
ordN q b = go q (b %% q) 1
  where
    go 0 _ _ = 0
    go f acc k
      | acc == 1 = k
      | otherwise = go (f - 1) ((acc * b) %% q) (k + 1)

-- vCap fuel q n: q-adic valuation, v(0) saturating to the remaining fuel
vCap :: Integer -> Integer -> Integer -> Integer
vCap 0 _ _ = 0
vCap f q n
  | n == 0 = f
  | n %% q == 0 = 1 + vCap (f - 1) q (n // q)
  | otherwise = 0

-- THE quantity: e_b(q) = v_q(b^ord_q(b) - 1), fuel 40
headDepth :: Integer -> Integer -> Integer
headDepth q b = vCap 40 q (monus (powerN b (ordN q b)) 1)

fermatBlind :: Integer -> Integer -> Integer -> Bool
fermatBlind q a b = let n = powerN q a in powModM 40 n b (monus n 1) == 1

wieferich :: Integer -> Bool
wieferich q = 2 <= headDepth q 2

mrChain :: Integer -> Integer -> Integer -> Bool
mrChain _ 0 _ = False
mrChain n k x
  | x == monus n 1 = True
  | otherwise = mrChain n (k - 1) ((x * x) %% n)

strongBlind :: Integer -> Integer -> Integer -> Bool
strongBlind q a b =
  let n = powerN q a
      s = vCap 40 2 (monus n 1)
      d = monus n 1 // powerN 2 s
      x0 = powModM 40 n b d
  in x0 == 1 || mrChain n s x0

blindCount :: Integer -> Integer -> Integer
blindCount q a =
  toInteger (length [ b | b <- [1 .. powerN q a]
                        , b %% q /= 0, a <= headDepth q b ])

-- The window scan's primality test, mirroring the emitted Agda
-- noFactorFrom/isPrime exactly (fuel n, divisors from 2, cutoff d*d > n)
noFactorFrom :: Integer -> Integer -> Integer -> Bool
noFactorFrom 0 _ _ = True
noFactorFrom f d n
  | n < d * d = True
  | n %% d == 0 = False
  | otherwise = noFactorFrom (f - 1) (d + 1) n

isPrimeM :: Integer -> Bool
isPrimeM n = n >= 2 && noFactorFrom n 2 n

-- =====================================================================
-- Candidate families
-- =====================================================================

data Candidate = Candidate
  { cName :: String        -- module basename under MachineMinted
  , cClaim :: String       -- one-line human statement
  , cPredicted :: Bool     -- the mirror's verdict on ALL facts in the module
  , cControl :: Bool       -- deliberate falsehood: the gate MUST reject it
  , cSource :: String      -- complete Agda module text
  }

optionsLine :: String
optionsLine = "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
-- --guardedness matches natural-machine.agda-lib's flags: HeadDepthMerge's
-- interface is built under them, and an importer must agree.

provenance :: String -> [String]
provenance claim =
  [ "-- MachineMinted: generated by machine/CandidateGen.hs."
  , "-- Admitted only on agda exit 0 (the MathMachine kernel-gate rule,"
  , "-- message 0484).  Instance certificate over the head-depth carrier"
  , "-- e_b(q) = v_q(b^ord_q(b) - 1) of formal/cubical/HeadDepthMerge.agda;"
  , "-- an extension of the corpus' certified range, not a new law."
  , "-- CLAIM: " ++ claim
  ]

stdImports :: [String]
stdImports =
  [ "open import Cubical.Foundations.Prelude"
  , "open import Cubical.Data.Nat using (\8469; zero; suc; _\8760_)"
  , "open import Agda.Builtin.Nat using (_==_; _<_; _*_)"
  , "open import Cubical.Data.Bool using (Bool; true; false; if_then_else_; _and_; not)"
  ]

-- ---------------------------------------------------------------------
-- Family 1: fresh (q,a,b) threshold scans.  HeadDepthMerge certifies
-- q <= 23, b < 3q, a <= 4 (the 1048 triples).  These modules extend the
-- kernel-certified range of BOTH theorems (W3 and strong = Fermat) to a
-- fresh prime, and pin the deepest base in the window as named instance
-- facts: its exact head depth and the two threshold readings around it.
-- ---------------------------------------------------------------------

thresholdCandidate :: Integer -> Candidate
thresholdCandidate q = Candidate name claim predicted False source
  where
    name = "ThresholdQ" ++ show q
    bs = [ b | b <- [2 .. 3 * q - 1], b %% q /= 0 ]
    w3Holds = and [ fermatBlind q a b == (a <= headDepth q b)
                  | b <- bs, a <- [1 .. 4] ]
    strongHolds = and [ strongBlind q a b == fermatBlind q a b
                      | b <- bs, a <- [1 .. 4] ]
    -- the deepest base in the fresh window, and its exact depth
    (e0, b0) = maximum [ (headDepth q b, b) | b <- bs ]
    instHolds = headDepth q b0 == e0
                && fermatBlind q e0 b0
                && not (fermatBlind q (e0 + 1) b0)
    predicted = w3Holds && strongHolds && instHolds && e0 < 40
    claim = "W3 and strong-blindness certified at fresh prime q = "
            ++ show q ++ " (b in [2," ++ show (3 * q - 1) ++ "], q does not divide b, a in [1,4]); "
            ++ "deepest base b = " ++ show b0 ++ " has e_" ++ show b0
            ++ "(" ++ show q ++ ") = " ++ show e0
    source = unlines $
      provenance claim ++
      [ optionsLine
      , "module MachineMinted." ++ name ++ " where"
      , ""
      ] ++ stdImports ++
      [ "open import HeadDepthMerge using"
      , "  (headDepth; fermatBlind; strongBlind; allList; range; eqBool; _\8804?_; _%%_)"
      , ""
      , "-- Theorem W3 at q = " ++ show q ++ ": Fermat blindness on q^a \8660 a \8804 e_b(q),"
      , "-- exhaustively over the same triple shape as HeadDepthMerge.overTriples."
      , "w3Scan : \8469 \8594 Bool"
      , "w3Scan q ="
      , "  allList (\955 b \8594 if b %% q == 0 then true"
      , "                 else allList (\955 a \8594 eqBool (fermatBlind q a b) (a \8804? headDepth q b))"
      , "                              (range 1 4))"
      , "          (range 2 (3 * q \8760 2))"
      , ""
      , "-- Strong (Miller\8211Rabin) blindness = Fermat blindness on odd prime powers"
      , "-- (HEAD_DEPTH_MERGE seed 1), certified on the same fresh range."
      , "strongScan : \8469 \8594 Bool"
      , "strongScan q ="
      , "  allList (\955 b \8594 if b %% q == 0 then true"
      , "                 else allList (\955 a \8594 eqBool (strongBlind q a b) (fermatBlind q a b))"
      , "                              (range 1 4))"
      , "          (range 2 (3 * q \8760 2))"
      , ""
      , "w3-at-" ++ show q ++ " : w3Scan " ++ show q ++ " \8801 true"
      , "w3-at-" ++ show q ++ " = refl"
      , ""
      , "strong-at-" ++ show q ++ " : strongScan " ++ show q ++ " \8801 true"
      , "strong-at-" ++ show q ++ " = refl"
      , ""
      , "-- The deepest base of the window, pinned exactly, with the threshold"
      , "-- read in both directions: blind at depth e, refuted at depth e+1."
      , "deepest-base : headDepth " ++ show q ++ " " ++ show b0 ++ " \8801 " ++ show e0
      , "deepest-base = refl"
      , ""
      , "blind-at-" ++ show e0 ++ " : fermatBlind " ++ show q ++ " " ++ show e0 ++ " " ++ show b0 ++ " \8801 true"
      , "blind-at-" ++ show e0 ++ " = refl"
      , ""
      , "refuted-at-" ++ show (e0 + 1) ++ " : fermatBlind " ++ show q ++ " " ++ show (e0 + 1) ++ " " ++ show b0 ++ " \8801 false"
      , "refuted-at-" ++ show (e0 + 1) ++ " = refl"
      ]

-- ---------------------------------------------------------------------
-- Family 2: W4 subgroup counts at fresh (q,a).  Corollary W4 says the
-- a-blind bases in [1, q^a] form the subgroup of order q-1; the kernel
-- had certified only (5,2) (5,3) (7,3) (13,3).  Each fact here is a
-- fresh exhaustive count.  The generator refuses to mint if the mirror's
-- count disagrees with the proved value q-1: that would mean the mirror
-- or the carrier is broken, and a machine that notices must stop.
-- ---------------------------------------------------------------------

w4Pairs :: [(Integer, Integer)]
w4Pairs = [(3,2), (3,3), (7,2), (11,2), (13,2), (17,2)]

w4Candidate :: Candidate
w4Candidate = Candidate name claim predicted False source
  where
    name = "W4CountsFresh"
    counts = [ (q, a, blindCount q a) | (q, a) <- w4Pairs ]
    predicted = and [ c == q - 1 | (q, _, c) <- counts ]
    claim = "W4 subgroup counts at fresh (q,a): "
            ++ intercalate ", "
                 [ "blindCount " ++ show q ++ " " ++ show a ++ " = " ++ show c
                 | (q, a, c) <- counts ]
    factBlock (q, a, c) =
      [ "w4-" ++ show q ++ "-" ++ show a ++ " : blindCount " ++ show q
          ++ " " ++ show a ++ " \8801 " ++ show c
      , "w4-" ++ show q ++ "-" ++ show a ++ " = refl"
      , ""
      ]
    source = unlines $
      provenance claim ++
      [ optionsLine
      , "module MachineMinted." ++ name ++ " where"
      , ""
      , "open import Cubical.Foundations.Prelude"
      , "open import HeadDepthMerge using (blindCount)"
      , ""
      , "-- Corollary W4 instances: the a-blind bases in [1, q^a] form the"
      , "-- subgroup of order q \8722 1 of (\8484/q^a)^\215.  Each count below is a fresh"
      , "-- exhaustive kernel computation; each equals q \8722 1, as W4 proves."
      , ""
      ] ++ concatMap factBlock counts

-- ---------------------------------------------------------------------
-- Family 3: Wieferich scan on a fresh prime window.  HeadDepthMerge
-- certifies 1093 and 3511 above threshold and two neighbours below.
-- This module certifies the whole window (3511, hi]: a self-contained
-- fueled primality test, the fact that the window holds exactly k
-- primes, and that every one of them is below the Wieferich threshold
-- e_2(q) >= 2.
-- ---------------------------------------------------------------------

windowLo, windowHi :: Integer
windowLo = 3512
windowHi = 3700

wieferichWindowCandidate :: Candidate
wieferichWindowCandidate = Candidate name claim predicted False source
  where
    name = "WieferichWindow3512to3700"
    width = windowHi - windowLo + 1
    ns = [windowLo .. windowHi]
    primes = filter isPrimeM ns
    k = toInteger (length primes)
    predicted = not (any wieferich primes) && k > 0
    claim = "no Wieferich prime in [" ++ show windowLo ++ "," ++ show windowHi
            ++ "]: all " ++ show k ++ " primes of the window have e_2(q) < 2"
    source = unlines $
      provenance claim ++
      [ optionsLine
      , "module MachineMinted." ++ name ++ " where"
      , ""
      ] ++ stdImports ++
      [ "open import HeadDepthMerge using (wieferich; allList; countList; range; _%%_)"
      , ""
      , "-- Fueled trial division; fuel n bounds the divisor walk, the cutoff"
      , "-- is d * d > n, so the test is exact for every n the fuel covers."
      , "noFactorFrom : \8469 \8594 \8469 \8594 \8469 \8594 Bool"
      , "noFactorFrom zero    d n = true"
      , "noFactorFrom (suc f) d n ="
      , "  if n < d * d then true"
      , "  else (if n %% d == 0 then false else noFactorFrom f (suc d) n)"
      , ""
      , "isPrime : \8469 \8594 Bool"
      , "isPrime n = if n < 2 then false else noFactorFrom n 2 n"
      , ""
      , "-- every prime of the window is below the Wieferich threshold"
      , "windowClear : \8469 \8594 \8469 \8594 Bool"
      , "windowClear lo w ="
      , "  allList (\955 n \8594 if isPrime n then not (wieferich n) else true)"
      , "          (range lo w)"
      , ""
      , "window-clear : windowClear " ++ show windowLo ++ " " ++ show width ++ " \8801 true"
      , "window-clear = refl"
      , ""
      , "-- and the window is not vacuous: it holds exactly " ++ show k ++ " primes"
      , "window-prime-count : countList isPrime (range " ++ show windowLo
          ++ " " ++ show width ++ ") \8801 " ++ show k
      , "window-prime-count = refl"
      ]

-- ---------------------------------------------------------------------
-- The negative control.  HeadDepthMerge certifies wieferich 1091 ≡ false;
-- this module claims the opposite.  It is submitted through the identical
-- serialize-and-gate path and MUST come back rejected.  A gate that
-- accepts it is unsound and the whole run fails.
-- ---------------------------------------------------------------------

controlCandidate :: Candidate
controlCandidate = Candidate name claim predicted True source
  where
    name = "ControlFalseWieferich1091"
    predicted = wieferich 1091   -- the mirror already knows it is False
    claim = "DELIBERATE FALSEHOOD (negative control): wieferich 1091 \8801 true"
    source = unlines $
      [ "-- MachineMinted NEGATIVE CONTROL: this module is FALSE by design"
      , "-- (HeadDepthMerge.notWieferich-1091 certifies the negation).  It is"
      , "-- submitted to prove the gate rejects; it must never be installed."
      , optionsLine
      , "module MachineMinted." ++ name ++ " where"
      , ""
      , "open import Cubical.Foundations.Prelude"
      , "open import Cubical.Data.Bool using (true)"
      , "open import HeadDepthMerge using (wieferich)"
      , ""
      , "false-claim : wieferich 1091 \8801 true"
      , "false-claim = refl"
      ]

-- =====================================================================
-- The gate.  Serialize into formal/cubical/MachineMinted/, run agda with
-- the Certificate.hs invocation shape, keep the module ONLY on exit 0.
-- =====================================================================

mintedRelDir :: FilePath
mintedRelDir = "formal" </> "cubical" </> "MachineMinted"

writeUtf8 :: FilePath -> String -> IO ()
writeUtf8 path s = withFile path WriteMode $ \h -> do
  hSetEncoding h utf8
  hPutStr h s

-- THE WATCH, ADDED 2026-08-20.  This function was `Certificate.runAgda`
-- copied here — the locale discipline carried across and the FITNESS left
-- behind.  Both callers (`gateCandidate`, `regenerateEverything`) read
-- `code == ExitSuccess` and nothing else, so under a wrapper of the shape
-- `agda "$@" 2>&1 | cat` a minted candidate agda had rejected was
-- `Installed`, and an accepted CONTROL — the module whose whole job is to be
-- refused — was reported as the alarm firing rather than as the kernel being
-- gone.  `C.vetForeignRun` applies the same per-call output scan and
-- per-process falsifier `Certificate.runAgda` now carries.  It is applied
-- HERE rather than at the two call sites so that a third caller cannot
-- inherit the old behaviour by forgetting — which is how this copy was made
-- in the first place.
runAgda :: FilePath -> FilePath -> IO (ExitCode, String)
runAgda root file = do
  setLocaleEncoding utf8
  base <- getEnvironment
  let env' = ("LC_ALL", "C.UTF-8")
             : ("LANG", "C.UTF-8")
             : [ kv | kv@(k, _) <- base, k /= "LC_ALL", k /= "LANG" ]
      cp = (proc "agda" ["-i", "formal/cubical", "--library=cubical", file])
             { cwd = Just root, env = Just env' }
  (code, out, err) <- readCreateProcessWithExitCode cp ""
  C.vetForeignRun root code (out ++ err)

firstErrorLine :: String -> String
firstErrorLine out =
  case [ ln | ln <- lines out
            , not (null (words ln))
            , take 9 (dropWhile (== ' ') ln) /= "Checking " ] of
    [] -> "(agda said nothing)"
    ls -> unwords (words (unwords (take 2 ls)))

data Verdict = Installed | Rejected String | Refuted
  deriving (Eq, Show)

-- Gate one candidate.  The file is written in place and deleted unless
-- agda exits 0; a control that agda ACCEPTS is deleted too, and reported
-- as the alarm it is.
gateCandidate :: FilePath -> Candidate -> IO Verdict
gateCandidate root cand
  | not (cPredicted cand) && not (cControl cand) = pure Refuted
  | otherwise = do
      let rel = mintedRelDir </> (cName cand ++ ".agda")
          abs' = root </> rel
      writeUtf8 abs' (cSource cand)
      (code, out) <- runAgda root rel
      case code of
        ExitSuccess
          | cControl cand -> do
              removeFile abs'   -- never leave an accepted falsehood behind
              pure Installed    -- caller treats Installed control as alarm
          | otherwise -> pure Installed
        ExitFailure _ -> do
          removeFile abs'
          pure (Rejected (firstErrorLine out))

-- Regenerate and gate the MachineMinted index so nothing minted is an
-- orphan outside every build's import closure.
regenerateEverything :: FilePath -> IO Bool
regenerateEverything root = do
  files <- listDirectory (root </> mintedRelDir)
  let mods = sort [ take (length f - 5) f
                  | f <- files, ".agda" `isSuffixOf` f
                  , f /= "Everything.agda" ]
  if null mods
    then pure False
    else do
      let rel = mintedRelDir </> "Everything.agda"
          src = unlines $
            [ "-- MachineMinted index, regenerated by machine/CandidateGen.hs on"
            , "-- every run from the directory listing.  A module absent here is"
            , "-- a module no build replays; this file is the latch."
            , optionsLine
            , "module MachineMinted.Everything where"
            , ""
            ] ++ [ "import MachineMinted." ++ m | m <- mods ]
      writeUtf8 (root </> rel) src
      (code, _) <- runAgda root rel
      case code of
        ExitSuccess -> pure True
        ExitFailure _ -> removeFile (root </> rel) >> pure False

-- =====================================================================
-- main
-- =====================================================================

logLine :: FilePath -> String -> IO ()
logLine root s = do
  appendFile (root </> "machine" </> "minted.log") (s ++ "\n")
  putStrLn s

main :: IO ()
main = do
  setLocaleEncoding utf8
  hSetEncoding stdout utf8
  hSetBuffering stdout LineBuffering
  argv <- getArgs
  let root = case argv of { (p : _) -> p; [] -> "." }
  createDirectoryIfMissing True (root </> mintedRelDir)
  let real = [ thresholdCandidate 29
             , thresholdCandidate 31
             , w4Candidate
             , wieferichWindowCandidate
             ]
      control = controlCandidate
  logLine root "== CandidateGen: minting from the head-depth carrier =="
  verdicts <- forM real $ \cand -> do
    logLine root ("CANDIDATE " ++ cName cand ++ ": " ++ cClaim cand)
    logLine root ("  mirror-predicts=" ++ show (cPredicted cand))
    v <- gateCandidate root cand
    case v of
      Installed -> logLine root
        ("  KERNEL-ACCEPT installed " ++ (mintedRelDir </> (cName cand ++ ".agda")))
      Rejected why -> logLine root ("  KERNEL-REJECT " ++ why)
      Refuted -> logLine root "  REFUTED by the mirror; no agda call spent"
    pure (cand, v)

  logLine root ("CONTROL " ++ cName control ++ ": " ++ cClaim control)
  controlV <- gateCandidate root control
  controlSound <- case controlV of
    Rejected why -> do
      logLine root ("  CONTROL-REJECTED (as required): " ++ why)
      pure True
    Installed -> do
      logLine root "  ALARM: the gate ACCEPTED a false module; run is unsound"
      pure False
    Refuted -> do
      logLine root "  ALARM: control skipped the gate; the control proves nothing"
      pure False

  let installed = [ cName c | (c, Installed) <- verdicts ]
  indexed <- if null installed
               then pure False
               else regenerateEverything root
  when indexed $
    logLine root ("INDEX regenerated and checked: "
                  ++ (mintedRelDir </> "Everything.agda"))

  logLine root ("SUMMARY installed=" ++ show (length installed)
                ++ " of " ++ show (length real)
                ++ " candidates; control-rejected=" ++ show controlSound
                ++ "; index-green=" ++ show indexed)
  forM_ installed $ \n -> logLine root ("  INSTALLED MachineMinted." ++ n)
  unless (length installed >= 3 && controlSound && indexed) $ do
    logLine root "MINT RUN FAILED its own bar (>=3 installs, control rejected, index green)"
    exitFailure
  logLine root "CANDIDATE GENERATOR CHECKED"
