-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- SesaPariksa — parīkṣā of the śeṣa: which of the six outstanding demands
-- the induction emitter reaches, which it cannot spell, and which (if any)
-- needs a proof principle stronger than structural induction on ℕ.
--
-- शेष, *śeṣa* — the remainder that is KEPT and recursed on, not discarded.
-- Āryabhaṭa, Āryabhaṭīya, Gaṇitapāda 32–33 (499 CE), the kuṭṭaka: the
-- division is run for its remainder and the remainder is the material of the
-- next step.  परीक्षा, *parīkṣā* — examination of a thesis by putting it to a
-- means of knowledge; Nyāyasūtra 1.1.1 lists parīkṣā's objects and Vātsyāyana's
-- Nyāyabhāṣya (c. 400 CE) glosses the word.  Nothing about the mathematics
-- below is claimed for either text; the names are for what the operation IS.
--
-- WHAT THIS ASKS, AND WHY IT IS NOT THE QUESTION ALREADY ANSWERED
--
-- notes/SamasaBhavana_TheEnginesGenerationStepMadeCompositionAndWhatItCost.md
-- §9 measures three composition hands against the nine lemmas the Agda kernel
-- stalled on: 119,489 true equations produced, 3 already known, 1 reached by
-- the identification hand (tulya), 5 out of reach of ANY composition law
-- because they are not equational consequences of the 47 base facts at all.
-- That note ends by saying the five "need induction", and stops.
--
-- Between "needs induction" and "the emitter cannot produce it" there are
-- THREE distinct objects, and reporting them as one is the collapse:
--
--   (a) the emitter can already reach it, and was never ASKED.  Until this
--       file was run `certifyWith` attempted induction only when the caller's
--       proof note named a variable (`inductionVariable proofNote`), and a
--       residual harvested from the kernel carries no such note, so the
--       candidate got one `refl` module and a rejection.  Not a limitation of
--       the shape menu at all.
--   (b) the shape menu cannot SPELL the proof, though the proof lives inside
--       the emitted fragment — one structural induction on one ℕ, closed with
--       ordinary congruence and path composition.  A limitation of the proof
--       TERM LANGUAGE, priced in what has to be added.
--   (c) the statement genuinely needs a stronger principle — course-of-values
--       induction, a generalised hypothesis, two-variable/nested induction, a
--       side condition.  A mathematical gap, and a different object from (b).
--
-- So this parīkṣā runs each śeṣa down two roads and prints which of the three
-- it is:
--
--   ROAD 1 (saṃkramaṇa, the transport that loses nothing): submit it through
--     `Certificate.certifyWith` with the EMPTY proof note, which is what a
--     harvested residual actually carries.  A Certified here is case (a).
--
--     When this file was first run the answer was 0 of 6, and the reason was
--     not the shape menu: `certifyWith` read the induction variable off the
--     caller's note and refused after one `refl` module when there was none.
--     Asking each variable in turn — the shape menu untouched — reaches
--     THREE, including `x = x + (0 · x)`, the residual this engine circled
--     for 239 rounds.  That fallback is now in `certifyWith`, so this road
--     tests the shipped emitter and not a repair made inside the harness.
--     The price of it is measured in the last section, on the snapshot with
--     every note stripped, because a bound never measured against the
--     traffic is a bound and not a price.
--
--   ROAD 2 (śeṣa-lekha, the written record of what could not be carried):
--     for each remaining demand, submit a WITNESS module — the same preamble,
--     the same local `max`/`le` transcriptions, plus defining-equation lemmas
--     PROVED IN THE MODULE by induction from the library's definitions, never
--     imported from Cubical.Data.Nat.Properties.  That restriction is
--     machine/CERTIFICATE_REACH.md §2's rule and it is the whole content of
--     the test: citing `+-comm` would certify by the library already knowing
--     the answer.  A witness that checks says the statement is INSIDE the
--     fragment and the shortfall is the menu — case (b), and the diff prices
--     itself, because the witness IS the shape that was missing.  A witness
--     that does not check leaves the demand open, and (c) stays live for it.
--
-- KERNEL DISCIPLINE.  No acceptance is honoured by a process that has not
-- watched its own kernel reject a falsehood.  Both roads end in
-- `Certificate.runAgdaCached`, which runs `vetSuccess` — `canaryTrue` must
-- check and `canaryFalse` (`suc x ≡ x` by refl) must not, uncached, once per
-- process — so no entry point is added here that turns an exit status into a
-- verdict on its own.  On top of that this harness carries its own controls:
-- four deliberate falsehoods down road 1 and one down road 2, the latter a
-- false claim proved with the SAME lemma block the witnesses use, so a lemma
-- block that had been quietly made inconsistent would be caught by its own
-- section rather than by the shared canary.
--
-- MATH_CERTCACHE=0 for any reported number: a measurement must not read a
-- verdict it did not obtain from the kernel.

module SesaPariksa_WhichOfTheSixOutstandingDemandsInductionReaches (main) where

import Certificate
  ( Equation
  , Term(..)
  , Verdict(..)
  , certifyWith
  , kernelStatus
  , KernelStatus(..)
  , preambleWith
  , runAgdaCached
  , varsOf
  , symbolsOf
  , parseLibraryLine
  , kMaxAgdaCallsUnannotated
  )
import Control.Monad (forM, forM_)
import Data.IORef (modifyIORef', newIORef, readIORef)
import Data.List (intercalate)
import GHC.IO.Encoding (setLocaleEncoding)
import System.Environment (getArgs)
import System.Exit (ExitCode(..), exitFailure, exitSuccess)
import System.IO
import Text.Printf (printf)

-- ------------------------------------------------------------- the terms

zero_ :: Term
zero_ = F "0" []

su :: Term -> Term
su t = F "s" [t]

bin :: String -> Term -> Term -> Term
bin f a b = F f [a, b]

x_, y_ :: Term
x_ = V 0
y_ = V 1

-- The nine the kernel demanded, as §6 of the SamasaBhavana note reads them
-- out of Obstruction.curriculum.  The three marked KNOWN are the ones the
-- base facts already hold; the six below are the śeṣa this file examines.
--
-- Written as MathMachine terms, not as Agda text, so the translation is the
-- emitter's and not this file's.
sesa :: [(String, Equation)]
sesa =
  [ ("x = x + (0 * x)"
    , (x_, bin "+" x_ (bin "*" zero_ x_)))
  , ("x * (y + 0) = (x * y) + (x * 0)"
    , (bin "*" x_ (bin "+" y_ zero_), bin "+" (bin "*" x_ y_) (bin "*" x_ zero_)))
  , ("max(x,y) + 0 = max(x + 0, y + 0)"
    , (bin "+" (bin "max" x_ y_) zero_
      , bin "max" (bin "+" x_ zero_) (bin "+" y_ zero_)))
  , ("max(0,x) + 0 = max(0 + 0, x + 0)"
    , (bin "+" (bin "max" zero_ x_) zero_
      , bin "max" (bin "+" zero_ zero_) (bin "+" x_ zero_)))
  , ("0 = le(s(x + y), y)"
    , (zero_, bin "le" (su (bin "+" x_ y_)) y_))
  , ("0 = le(s(s(s(x))), x)"
    , (zero_, bin "le" (su (su (su x_))) x_))
  ]

-- Road 1's controls.  Same fragment, same symbols, deliberately false.
falsehoods :: [(String, Equation)]
falsehoods =
  [ ("x = x + (s(0) * x)   [FALSE]"
    , (x_, bin "+" x_ (bin "*" (su zero_) x_)))
  , ("max(x,y) + 0 = max(x + 0, s(y))   [FALSE]"
    , (bin "+" (bin "max" x_ y_) zero_
      , bin "max" (bin "+" x_ zero_) (su y_)))
  , ("s(0) = le(s(x + y), y)   [FALSE]"
    , (su zero_, bin "le" (su (bin "+" x_ y_)) y_))
  , ("0 = le(x, s(s(s(x))))   [FALSE]"
    , (zero_, bin "le" x_ (su (su (su x_)))))
  ]

-- ------------------------------------------------------------ road 1

-- A demand harvested from the kernel carries NO "[induction on v]" note, and
-- that is submitted here verbatim — the empty note — rather than repaired by
-- this harness.  Repairing it here would measure a program nobody runs: the
-- engine's residual path (`MathMachine.kernelAcceptSearch`) passes exactly
-- what the residual carried.  Choosing the variable is `certifyWith`'s job,
-- and whether it does it is the thing under examination.
road1 :: FilePath -> Equation -> IO (Either String (String, Int))
road1 root eq = do
  v <- certifyWith [] root (eq, "")
  pure $ case v of
    Certified shape k  -> Right (shape, k)
    Rejected err _     -> Left err
    Untranslatable why -> Left why

-- ------------------------------------------------------------ road 2

-- The defining equations of the library's `+` and `·`, in the machine's
-- reading, PROVED HERE by induction from the library's definitions.  Not
-- imported.  CERTIFICATE_REACH.md §2: if the module may cite `+-comm` then
-- the engine's contribution collapses from proof to discovery and nothing in
-- the log says so.  These four are the machine's own `symDefs` transcribed
-- and discharged, which is a different act from citing a theorem.
lemmaBlock :: [String]
lemmaBlock =
  [ "addZero : (a : \8469) \8594 (a + zero) \8801 a"
  , "addZero zero = refl"
  , "addZero (suc a) = cong suc (addZero a)"
  , ""
  , "addSuc : (a b : \8469) \8594 (a + suc b) \8801 suc (a + b)"
  , "addSuc zero b = refl"
  , "addSuc (suc a) b = cong suc (addSuc a b)"
  , ""
  , "mulZero : (a : \8469) \8594 (a \183 zero) \8801 zero"
  , "mulZero zero = refl"
  , "mulZero (suc a) = mulZero a"
  ]

-- A witness: the statement in Agda, and a proof term written in the fragment.
data Witness = Witness
  { wName  :: String
  , wSyms  :: [String]   -- symbols, so the preamble emits local max / le
  , wSig   :: String
  , wProof :: [String]
  }

witnesses :: [Witness]
witnesses =
  [ Witness
      "x * (y + 0) = (x * y) + (x * 0)"
      ["+", "*"]
      "sesa : (x y : \8469) \8594 (x \183 (y + zero)) \8801 ((x \183 y) + (x \183 zero))"
      [ "sesa x y ="
      , "  cong (x \183_) (addZero y)"
      , "  \8729 sym (cong ((x \183 y) +_) (mulZero x) \8729 addZero (x \183 y))"
      ]
  , Witness
      "max(x,y) + 0 = max(x + 0, y + 0)"
      ["+", "max"]
      "sesa : (x y : \8469) \8594 ((max x y) + zero) \8801 (max (x + zero) (y + zero))"
      [ "sesa x y ="
      , "  addZero (max x y)"
      , "  \8729 sym (cong\8322 max (addZero x) (addZero y))"
      ]
  , Witness
      "max(0,x) + 0 = max(0 + 0, x + 0)"
      ["+", "max"]
      "sesa : (x : \8469) \8594 ((max zero x) + zero) \8801 (max (zero + zero) (x + zero))"
      [ "sesa x ="
      , "  addZero (max zero x)"
      , "  \8729 cong (max zero) (sym (addZero x))"
      ]
  , Witness
      "0 = le(s(x + y), y)"
      ["+", "le"]
      "sesa : (x y : \8469) \8594 zero \8801 (le (suc (x + y)) y)"
      [ "sesa x zero = refl"
      , "sesa x (suc y) ="
      , "  sesa x y \8729 sym (cong (\955 t \8594 le t y) (addSuc x y))"
      ]
  ]

-- Road 2's control: a FALSE claim built with the same lemma block, in the
-- same fragment.  It must be refused.  A lemma block quietly made
-- inconsistent would certify this, and the shared kernel canary would not
-- notice, because the canary does not import the block.
witnessFalsehood :: Witness
witnessFalsehood = Witness
  "(a + 0) = s(a)   [FALSE, proved with the same block]"
  ["+"]
  "sesa : (a : \8469) \8594 (a + zero) \8801 suc a"
  [ "sesa a = addZero a" ]

witnessModule :: Witness -> String
witnessModule w = unlines $
  preambleWith [] (wSyms w) ++ [""] ++ lemmaBlock ++ ["", wSig w] ++ wProof w

-- ------------------------------------------------------------------ main

main :: IO ()
main = do
  setLocaleEncoding utf8
  hSetEncoding stdout utf8
  hSetBuffering stdout LineBuffering
  args <- getArgs
  let root = case args of (r : _) -> r; [] -> "."
  putStrLn "SesaPariksa — the six outstanding demands, down two roads."
  putStrLn ""

  st <- kernelStatus root
  putStrLn ("kernel controls: " ++ show st)
  case st of
    KernelChecking -> pure ()
    _ -> do
      putStrLn "The kernel did not pass its own controls. Nothing below would"
      putStrLn "be a verdict about mathematics, so nothing is run."
      exitFailure
  putStrLn ""

  calls <- newIORef (0 :: Int)
  let spend n = modifyIORef' calls (+ n)

  putStrLn "== ROAD 1: the shipped emitter, empty proof note (as a residual arrives) =="
  r1 <- forM sesa $ \(nm, eq) -> do
    res <- road1 root eq
    case res of
      Right (shape, n) -> do
        spend n
        printf "  REACHED   %-34s %s (%d calls)\n" nm shape n
        pure (nm, True)
      Left err -> do
        printf "  open      %-34s %s\n" nm (short err)
        pure (nm, False)
  putStrLn ""

  putStrLn "== ROAD 1 controls (must all be refused) =="
  bad <- forM falsehoods $ \(nm, eq) -> do
    res <- road1 root eq
    case res of
      Right (shape, _) -> do
        printf "  ACCEPTED  %-34s %s   <-- CONTROL FAILED\n" nm shape
        pure True
      Left _ -> do
        printf "  refused   %-34s\n" nm
        pure False
  putStrLn ""

  let openOnes = [ nm | (nm, False) <- r1 ]
  putStrLn "== ROAD 2: a witness in the same fragment, lemmas proved not imported =="
  r2 <- forM witnesses $ \w -> do
    (code, out, n) <- runAgdaCached root (witnessModule w)
    spend n
    case code of
      ExitSuccess -> do
        printf "  WITNESS   %-34s checks (%d calls)\n" (wName w) n
        pure (wName w, True)
      ExitFailure _ -> do
        printf "  no wit.   %-34s %s\n" (wName w) (short (firstLine out))
        pure (wName w, False)
  putStrLn ""

  putStrLn "== ROAD 2 control (same lemma block, false claim; must be refused) =="
  (fcode, fout, fn) <- runAgdaCached root (witnessModule witnessFalsehood)
  spend fn
  let wControlOk = fcode /= ExitSuccess
  if wControlOk
    then printf "  refused   %-34s %s\n" (wName witnessFalsehood) (short (firstLine fout))
    else printf "  ACCEPTED  %-34s   <-- CONTROL FAILED\n" (wName witnessFalsehood)
  putStrLn ""

  -- THE PRICE OF THE FALLBACK, on the objects the engine actually hands the
  -- gate.  `machine/library.snapshot.txt` is read from disk and every note is
  -- STRIPPED, which is precisely the shape a residual arrives in.  Before the
  -- fallback this section is 0 certified at 1 call per line by construction:
  -- `certifyWith` refused a note-less candidate after the refl module.  What
  -- it costs and what it buys are both printed, because a bound that is never
  -- measured against the traffic is a bound and not a price.
  putStrLn "== THE PRICE: machine/library.snapshot.txt with every note stripped =="
  raw <- readFileUtf8 (root ++ "/machine/library.snapshot.txt")
  let parsed = [ (l, eq) | l <- lines raw, Just (eq, _) <- [parseLibraryLine l] ]
  stripped <- forM parsed $ \(l, eq) -> do
    v <- certifyWith [] root (eq, "")
    pure $ case v of
      Certified shape k  -> (k, Just (l, shape))
      Rejected _ k       -> (k, Nothing)
      Untranslatable _   -> (0, Nothing)
  let sCalls = sum (map fst stripped)
      sOK    = [ p | (_, Just p) <- stripped ]
  forM_ sOK $ \(l, shape) ->
    printf "  note-less OK  %-30s %s\n" (short (unwords (words l))) shape
  printf "  lines read %d, certified with no note %d, agda calls %d (bound %d/line)\n"
         (length parsed) (length sOK) sCalls kMaxAgdaCallsUnannotated
  spend sCalls
  putStrLn ""

  n <- readIORef calls
  let reached  = length [ () | (_, True) <- r1 ]
      witnessed = length [ () | (nm, True) <- r2, nm `elem` openOnes ]
      stillOpen = length sesa - reached - witnessed
  printf "outstanding demands examined      : %d\n" (length sesa)
  printf "reached by TODAY'S emitter        : %d   (case a: never asked)\n" reached
  printf "inside the fragment, menu too poor: %d   (case b: proof-term language)\n" witnessed
  printf "no witness here                   : %d   (case c stays live)\n" stillOpen
  printf "agda invocations this run         : %d\n" n
  printf "road 1 controls refused           : %d/%d\n"
         (length [ () | False <- bad ]) (length bad)
  printf "road 2 control refused            : %s\n" (show wControlOk)
  if or bad || not wControlOk
    then putStrLn "SESA PARIKSA NOT CHECKED — a control failed." >> exitFailure
    else putStrLn "SESA PARIKSA CHECKED" >> exitSuccess

short :: String -> String
short s = let t = takeWhile (/= '\n') s
          in if length t > 62 then take 62 t ++ "..." else t

firstLine :: String -> String
firstLine s = case [ l | l <- lines s, not (null (words l)) ] of
  (l : _) -> unwords (words l)
  []      -> "(no output)"

-- The snapshot is UTF-8 (it carries ℕ-free ASCII today, but the machine
-- writes ⁱ-subscripted variables when it runs out of letters), and the
-- ambient locale is not to be trusted for it — the same fault
-- `Certificate.writeUtf8` exists for, on the way in.
readFileUtf8 :: FilePath -> IO String
readFileUtf8 p = do
  h <- openFile p ReadMode
  hSetEncoding h utf8
  s <- hGetContents h
  length s `seq` pure s
