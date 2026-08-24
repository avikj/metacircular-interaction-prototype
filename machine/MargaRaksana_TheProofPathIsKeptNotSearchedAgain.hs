-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- मार्गरक्षण — the proof path is KEPT, not searched for a second time.
--
-- THE NAME, AND WHAT IS AND IS NOT CLAIMED OF THE SOURCE
--
-- Āryabhaṭa, *Āryabhaṭīya*, Gaṇitapāda 32–33 (499 CE), states the kuṭṭaka —
-- the pulveriser — and the principle this file is named for is the one the
-- vallī encodes: the quotients and remainders of the descent are WRITTEN DOWN
-- as the descent runs, and the answer is then read back off that column by
-- ascending it.  Nothing is recomputed.  `notes/AHIMSA_SUTRA_VISTARA.md` §17
-- puts the same principle in one line — पथो रक्षणम्, न त्यागः, "retention of
-- the path, not its discarding" — and §48 states its cost: the vallī IS the
-- memory, there is no separate store (वल्ली एव स्मृतिः । पृथक् स्मृतिर्नास्ति).
--
-- NOT CLAIMED: that Āryabhaṭa wrote a proof-transcription harness, or
-- anything about type theory.  What is his is the named principle, stated for
-- linear indeterminate equations, that a procedure which discards the record
-- of its own steps has to find them again — यो शेषं त्यजति तस्य यन्त्रं न चलति.
-- That is exactly the defect this file measures the repair of.
--
-- ===================================================================
-- WHAT THIS MEASURES AND WHY IT DID NOT EXIST
--
-- The machine has TWO ways to turn a discovered equation into an Agda term a
-- third party can re-check without rerunning the machine:
--
--   ROUTE 1, TRANSCRIPTION (`machine/TraceReplay.hs`).  At the moment
--     `proveByInduction` returns, the engine has just watched every rewrite
--     fire — which rule, at which position, in which order.  That trace
--     compiles directly into a path: a fired rule becomes its named lemma
--     under `cong` at the recorded position, right-to-left firing becomes
--     `sym`, a sequence becomes `∙`, and the induction hypothesis becomes the
--     structural recursive call.  ONE agda call, no search.
--
--   ROUTE 2, SHAPE SEARCH (`machine/Certificate.hs`).  Emit an induction
--     skeleton and try a fixed menu of clause bodies — `refl`, `ih`,
--     `cong suc (ih)`, a list of `cong` sections — one agda process per
--     attempt, up to `kMaxAgdaCalls`.
--
-- Each has a published number and the two numbers are about different files
-- and different denominators: `CERTIFICATE_REACH.md` reports 15/28 for the
-- search over `machine/library.snapshot.txt`; `TraceReplay.main` reports
-- 8/13 for transcription over the {0,s,+,*} sub-fragment of the same file.
-- NOTHING MEASURED THE UNION, and the union is not the sum: the routes
-- overlap on five theorems and disagree on the rest in both directions.
-- "How far does certification reach" therefore had no answer, only two
-- partial answers that a reader had to add up by hand and would have added
-- up wrong.
--
-- This program is the answer.  It walks `machine/library.snapshot.txt` IN
-- ORDER — the order the engine met the theorems, which matters because each
-- accepted theorem becomes both a rewrite rule for the next derivation and a
-- citable lemma for the next certificate — and for each line tries
-- transcription first and the search second, exactly as `TraceReplay`'s
-- wiring contract specifies.  It reports the reach of each route separately
-- and of the two together, all against the same denominator.
--
-- ===================================================================
-- WHY ADDING A SECOND PROOF PRODUCER CANNOT WEAKEN SOUNDNESS
--
-- Stated before the run, because it is the question a reader should ask.
--
-- Neither route is trusted.  Both END in `Certificate.runAgdaCached`, which
-- means every module either route produces is submitted to agda, and agda's
-- acceptance is honoured only by a process that has itself watched the kernel
-- REJECT `suc x ≡ x` with a located type error (`Certificate.kernelStatus`,
-- and the yogyānupalabdhi argument at `vetSuccess`).  A proof producer can
-- therefore fail in exactly two ways — it emits nothing, or it emits a module
-- agda refuses — and both are refusals.  It has no way to emit a module agda
-- accepts for a false equation, because that would be a fault in agda and not
-- in the producer.
--
-- The controls are run, not argued: the four deliberate falsehoods of
-- `Certificate.main` are put through the SAME combined path below, and this
-- program exits non-zero if any of them acquires a certificate by either
-- route.  A second route doubles the surface, so it doubles the control.
--
-- ===================================================================
-- BUILD AND RUN, from the repository root:
--
--   ghc -O1 -imachine -outputdir /tmp/mr-build -o /tmp/mr \
--       -main-is MargaRaksana_TheProofPathIsKeptNotSearchedAgain \
--       machine/MargaRaksana_TheProofPathIsKeptNotSearchedAgain.hs
--   MATH_CERTCACHE=0 /tmp/mr .
--
-- `MATH_CERTCACHE=0` is not optional for a REPORTED number: a measurement
-- must not read a verdict it did not obtain from the kernel.  Without it the
-- program still runs and the reach is the same, but the agda-call counts are
-- about the cache and not about the work.

module MargaRaksana_TheProofPathIsKeptNotSearchedAgain (main) where

import qualified Certificate as C
import qualified TraceReplay as T

import Control.Monad (forM)
import Data.List (isInfixOf, isPrefixOf)
import System.Environment (getArgs)
import System.Exit (ExitCode (..), exitFailure, exitSuccess)
import System.IO
import Text.Printf (printf)

-- ------------------------------------------------------------------ terms
--
-- The two modules carry the same term type under two names, both transcribed
-- from `MathMachine.Term` and both deliberately independent of it so each can
-- be built and tested alone.  The cost of that independence is this pair of
-- functions, and the cost is worth paying: it is six lines, and it is why
-- neither file breaks when the other is edited.  A structural coercion cannot
-- change what an equation says, so this seam adds nothing to trust.

toT :: C.Term -> T.Term
toT (C.V i) = T.V i
toT (C.F f ts) = T.F f (map toT ts)

-- ------------------------------------------------------------------ routes

-- Which route produced a certificate, or why neither did.  A verdict here is
-- never a bare boolean: the wire carries WHICH route, at WHAT cost, and a
-- refusal carries the observation that produced it.
data Reach
  = ByTranscription Int      -- ^ replayed; agda calls spent (1 unless cached)
  | BySearch String Int      -- ^ the menu found a shape; which, and the cost
  | Refused String String    -- ^ transcription's reason, then the search's
  deriving (Show)

reached :: Reach -> Bool
reached (Refused _ _) = False
reached _ = True

-- ROUTE 1.  `replayWithRules` returns `Nothing` when the derivation this
-- harness can reconstruct does not close, or when a fired rule has no name to
-- cite.  Both are honest declines: there was no proof here TO transcribe, and
-- emitting something anyway would be inventing one.
transcribe :: FilePath -> [T.Rule] -> [((T.Term, T.Term), String)]
           -> (T.Term, T.Term) -> Int -> IO (Either String Int)
transcribe root rules certs goal v =
  case T.replayWithRules certs rules goal v "Candidate" of
    Nothing -> pure (Left "no trace to transcribe (traces do not meet, or a fired rule is unnamed)")
    Just src -> do
      -- The same submission path the search uses, so replay is vetted by the
      -- same controls and counted in the same currency.
      (code, out, n) <- C.runAgdaCached root src
      pure $ case code of
        ExitSuccess -> Right n
        ExitFailure _ -> Left (firstInformative out)

firstInformative :: String -> String
firstInformative out =
  case [ l | l <- lines out, informative l ] of
    (l : _) -> clip (unwords (words l))
    [] -> "(agda said nothing)"
  where
    -- The location line names a temp directory that is gone by the time
    -- anyone reads this, so it is dropped and the message kept — the same
    -- decision `Certificate.firstErrorLine` makes, for the same reason.
    informative ln =
      not (null (words ln))
        && not ("Checking " `isPrefixOf` dropWhile (== ' ') ln)
        && not (".agda:" `isInfixOf` ln)
    clip s = if length s > 64 then take 61 s ++ "..." else s

-- ------------------------------------------------------------------ driver

-- The starting rewrite rules: the defining equations of every symbol
-- `TraceReplay` is willing to CITE, for the symbols this goal mentions.  Not
-- `peanoRules`, which is the +/* half only — a `max` derivation cannot fire
-- with those and replay would decline a proof that was available.
rulesFor :: [String] -> [T.Rule]
rulesFor syms = map fst (T.leLemmas (T.vocabEnv syms))

symsOf :: T.Term -> [String]
symsOf (T.V _) = []
symsOf (T.F f ts) = f : concatMap symsOf ts

-- One line, both routes, transcription first.
attempt :: FilePath -> [T.Rule] -> [((T.Term, T.Term), String)]
        -> (C.Equation, String) -> IO Reach
attempt root proved certs (eq, note) = do
  let g@(gl, gr) = (toT (fst eq), toT (snd eq))
      rules = rulesFor (symsOf gl ++ symsOf gr) ++ proved
  r1 <- case C.inductionVariable note of
    Nothing -> pure (Left "the library line records no induction variable")
    Just v -> transcribe root rules certs g v
  case r1 of
    Right n -> pure (ByTranscription n)
    Left why1 -> do
      v <- C.certifyWith [] root (eq, note)
      pure $ case v of
        C.Certified how n -> BySearch how n
        C.Rejected err n -> Refused why1 (err ++ " (" ++ show n ++ " calls)")
        C.Untranslatable w -> Refused why1 ("untranslatable: " ++ w)

main :: IO ()
main = do
  hSetEncoding stdout utf8
  hSetBuffering stdout LineBuffering
  argv <- getArgs
  let root = case argv of { (p : _) -> p ; [] -> "." }
  on <- C.cacheEnabled
  printf "मार्गरक्षण — combined certificate reach (repository root %s).\n" (show root)
  printf "certificate cache: %s\n"
    (if on then "ON — the call counts below are about the cache, not the work"
           else "OFF (MATH_CERTCACHE)" :: String)
  printf "search budget: %d agda calls per candidate; transcription: 1.\n\n"
    C.kMaxAgdaCalls

  raw <- readFile (root ++ "/machine/library.snapshot.txt")
  let ls = [ l | l <- lines raw, not (null (words l)) ]
      parsed = [ (l, C.parseLibraryLine l) | l <- ls ]

  putStrLn "== machine/library.snapshot.txt, in the order the engine met it =="
  (rs, _, verdicts) <- walk root [] [] [] parsed

  putStrLn ""
  putStrLn "== the four deliberate falsehoods, through the SAME combined path =="
  putStrLn "   (a second proof producer doubles the surface, so it doubles the control)"
  falseVerdicts <- forM falsehoods $ \(label, eq, note) -> do
    v <- attempt root rs [] (eq, note)
    report label v
    pure v

  let total = length parsed
      byTrans = length [ () | ByTranscription _ <- verdicts ]
      bySearch = length [ () | BySearch _ _ <- verdicts ]
      union = byTrans + bySearch
      admitted = [ () | v <- falseVerdicts, reached v ]

  putStrLn ""
  printf "library lines                       : %d\n" total
  printf "certified by transcription (route 1): %d\n" byTrans
  printf "certified by search (route 2)       : %d\n" bySearch
  printf "COMBINED REACH                      : %d/%d\n" union total
  printf "no certificate by either route      : %d\n" (total - union)

  if null admitted
    then do
      printf "\nfalsehoods: %d/%d refused by BOTH routes\n"
        (length falseVerdicts) (length falseVerdicts)
      putStrLn "COMBINED REACH MEASURED"
      exitSuccess
    else do
      putStrLn "\nUNSOUND: a false equation acquired a certificate"
      exitFailure
  where
    -- Walk the file accumulating: an accepted theorem becomes a rewrite rule
    -- for the next derivation AND a citable lemma for the next certificate.
    -- That is the engine's own thesis — a theorem is an installed
    -- transformation — applied to its certificates.  Only theorems the KERNEL
    -- accepted are accumulated; a refused line contributes nothing, so a
    -- failure cannot propagate into a later proof.
    walk _ rs certs acc [] = pure (rs, certs, reverse acc)
    walk root rs certs acc ((line, mp) : rest) = case mp of
      Nothing -> do
        let v = Refused "the line did not parse" "the line did not parse"
        report (label line) v
        walk root rs certs (v : acc) rest
      Just (eq, note) -> do
        v <- attempt root rs certs (eq, note)
        report (label line) v
        let g = (toT (fst eq), toT (snd eq))
            nm = "lem" ++ show (length certs)
        walk root
             (if reached v then rs ++ [g] else rs)
             (if reached v then certs ++ [(g, nm)] else certs)
             (v : acc) rest
    label = unwords . words

    report lbl v = case v of
      ByTranscription n ->
        printf "  OK/trace   %-34s %-40s (%d call%s)\n" lbl
          ("transcribed from the engine's own derivation" :: String) n (plural n)
      BySearch how n ->
        printf "  OK/search  %-34s %-40s (%d call%s)\n" lbl how n (plural n)
      Refused w1 w2 ->
        printf "  NO         %-34s\n               trace : %s\n               search: %s\n"
          lbl w1 w2
    plural (1 :: Int) = "" ; plural _ = "s"

-- Transcribed from `Certificate.main`'s `falsehoods`, verbatim, because a
-- control that drifts from the one it is meant to mirror is not a control.
falsehoods :: [(String, C.Equation, String)]
falsehoods =
  [ ("s(x) = x", (su x_, x_), "[induction on x]")
  , ("(x+y) = (x*y)", (bin "+" x_ y_, bin "*" x_ y_), "[induction on x]")
  , ("x = le(x,x)", (x_, bin "le" x_ x_), "[induction on x]")
  , ("(xmaxy) = (x+y)", (bin "max" x_ y_, bin "+" x_ y_), "[induction on x]")
  ]
  where
    x_ = C.V 0
    y_ = C.V 1
    su t = C.F "s" [t]
    bin f a b = C.F f [a, b]
