-- Pratilipi — the three śeṣas the shape menu cannot spell, transcribed.
--
-- प्रतिलिपि, *pratilipi* — a copy, a transcript (Monier-Williams s.v.
-- प्रतिलिपि, f., "a transcript, copy").  The word is used here for what the
-- operation IS: writing down again a thing already produced, rather than
-- producing it a second time.  Nothing about the mathematics below is claimed
-- for any text, and no source is claimed to have applied the word to proof
-- terms.  शेष, *śeṣa* — the remainder that is KEPT and recursed on
-- (Āryabhaṭīya, Gaṇitapāda 32–33, 499 CE, the kuṭṭaka), which is how
-- `notes/SesaPariksa_...md` hands these three forward.
--
-- WHAT THIS ASKS
--
-- `notes/SesaPariksa_TheSixLemmasBehindTheInductionWallAreNotAMathematicalGap.md`
-- settles that none of the six lemmas the kernel demanded needs a proof
-- principle stronger than structural induction on one ℕ.  Three of the six the
-- shipped emitter now reaches (§3 of that note, the empty-note fallback).  The
-- other three it cannot SPELL: read against `Certificate.stepShapes` the
-- shortfall is exact — no `_∙_`, no `sym`, congruence sections for `+` and `·`
-- only and only with a bare variable in the hole, and nothing previously
-- certified in scope.
--
-- `machine/CERTIFICATE_REACH.md` §10.4 names the route past that menu, and §3a
-- forbids the other one:
--
--   * §3a: a menu extended to compositions of proof shapes is a search over an
--     unbounded space — "a proof search, badly, in another process".  Nothing
--     here extends the menu.
--   * §10.4: transcription.  The engine, at the moment it discharged the
--     theorem, ran a derivation: which defining equation fired, at which
--     subterm, in which order.  A composition of paths is not SEARCHED for, it
--     is READ OFF that derivation.  `machine/TraceReplay.hs` is the compiler
--     for it and already emits `_∙_`, `sym`, and `cong` at an arbitrary
--     position — the three things the menu lacks.
--
-- So the question this file answers is a measurement and not a proposal: does
-- the transcription route, unextended, reach the three śeṣas the shape search
-- cannot?
--
-- WHAT HAD TO BE ADDED, AND WHAT DID NOT
--
-- Two of the three need no induction on the goal at all — both sides normalise
-- to a common term under the engine's own defining equations, and the whole
-- proof is the two traces composed.  `TraceReplay.replayModule` could only
-- emit an INDUCTION, so transcribing those meant inducting on a variable the
-- derivation never split on and letting both clauses repeat the same path.
-- That typechecks and it is a written record of a case split that did not
-- happen.  `TraceReplay.transcribeDirect` (added with this file, additive; no
-- existing definition changed) emits the path itself.
--
-- The third needs one structural induction on one ℕ and needed NOTHING new:
-- `replayModule` with `vocabEnv`'s `le` equations reaches it as shipped.  That
-- is reported as a finding, not repaired into an achievement.
--
-- KERNEL DISCIPLINE.  No acceptance is honoured by a process that has not
-- watched its own kernel reject a falsehood.  Every submission here goes
-- through `Certificate.runAgdaCached`, which runs `vetSuccess`, and the two
-- shared controls (`canaryTrue` must check, `canaryFalse` must not) are run
-- uncached once per process by `kernelStatus` before anything else.  On top of
-- that, and because the shared canary does NOT import the lemma block these
-- modules carry, this harness runs six of its own falsehoods:
--
--   * four false equations down the same transcription route;
--   * one FORGED module — a reached śeṣa's emitted module with its statement
--     replaced by a false one and its proof term left untouched;
--   * one false claim proved from the emitted lemma block, spliced onto the
--     block BYTE-IDENTICALLY (the header and preamble of a module this run
--     actually emitted), so a block quietly made inconsistent is caught here
--     rather than nowhere.
--
-- MATH_CERTCACHE=0 for any reported number: a measurement must not read a
-- verdict it did not obtain from the kernel.
--
-- Build and run:
--   ghc -O1 -imachine -outputdir /tmp/pl-build -o /tmp/pratilipi \
--       -main-is Pratilipi_TheThreeSesasAreTranscribedNotSearched \
--       machine/Pratilipi_TheThreeSesasAreTranscribedNotSearched.hs
--   MATH_CERTCACHE=0 /tmp/pratilipi .

module Pratilipi_TheThreeSesasAreTranscribedNotSearched (main) where

import qualified Certificate as C
import qualified TraceReplay as T

import Control.Monad (forM)
import Data.IORef (modifyIORef', newIORef, readIORef)
import GHC.IO.Encoding (setLocaleEncoding)
import System.Environment (getArgs)
import System.Exit (ExitCode(..), exitFailure, exitSuccess)
import System.IO
import Text.Printf (printf)

-- ------------------------------------------------------------- the terms

zero_ :: T.Term
zero_ = T.F "0" []

su :: T.Term -> T.Term
su t = T.F "s" [t]

bin :: String -> T.Term -> T.Term -> T.Term
bin f a b = T.F f [a, b]

x_, y_ :: T.Term
x_ = T.V 0
y_ = T.V 1

type Goal = (T.Term, T.Term)

-- The six, in the order `notes/SesaPariksa_...md` §1 lists them.  All six are
-- run, not only the three, because "transcription reaches the three the menu
-- cannot" is a claim about a route and a route that reached ONLY those three
-- would be a different object from one that reaches all six.
sesa :: [(String, Goal)]
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

-- The three of those six that `Certificate.certifyWith` cannot spell, measured
-- in `notes/SesaPariksa_...md` §3.  Named rather than recomputed, so this file
-- reports agreement or disagreement with that measurement instead of silently
-- redefining what "the three" are.
menuCannotSpell :: [String]
menuCannotSpell =
  [ "x * (y + 0) = (x * y) + (x * 0)"
  , "max(x,y) + 0 = max(x + 0, y + 0)"
  , "0 = le(s(x + y), y)"
  ]

-- The same four controls `SesaPariksa` sends down road 1, sent down this route
-- instead.  Same fragment, same symbols, deliberately false.
falsehoods :: [(String, Goal)]
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

-- ------------------------------------------------------------- the route

-- The engine's own defining equations for exactly the symbols this goal
-- mentions, both as the rules the derivation is run against and as the lemmas
-- the proof may cite.  ONE source for both, which is why `vocabEnv` is used
-- rather than a second list written here: `peanoRules` omits `max` and `le`,
-- and a derivation over those symbols run against a rule set that cannot fire
-- them simply does not close, so replay would decline a proof that was in fact
-- available.  (That is the two-copies fault recorded in `TraceReplay`'s own
-- export note, and it cost that file its whole reach once already.)
--
-- Not `Cubical.Data.Nat.Properties`.  `machine/CERTIFICATE_REACH.md` §2: a
-- module that may cite `+-comm` certifies by the library already knowing the
-- answer, and the log would not say so.  `vocabEnv` emits `addZero`, `addSuc`,
-- `addAssoc`, `mulZero`, `mulSuc` PROVED in the module by induction from the
-- library's definitions, and the `max`/`le` equations by `refl` against the
-- local case trees the module itself defines.
envFor :: Goal -> (T.LemmaEnv, [T.Rule])
envFor (l, r) = (lenv, map fst (T.leLemmas lenv))
  where
    lenv = T.vocabEnv (symsOf l ++ symsOf r)
    symsOf (T.V _) = []
    symsOf (T.F f ts) = f : concatMap symsOf ts

-- How the module was arrived at.  Reported per śeṣa, because "transcription
-- reached it" and "transcription reached it WITHOUT inducting" are different
-- facts and the second is the one that says the derivation had no case split.
data Route = Direct | Inducted Int

instance Show Route where
  show Direct = "direct (no induction)"
  show (Inducted v) = "induction on " ++ [ "xyzuvw" !! v ]

-- Transcribe: the path first, one structural induction second.
--
-- THIS IS NOT §3a's SEARCH.  §3a refuses a menu extended to COMPOSITIONS of
-- proof shapes — an unbounded space of proof TERMS.  There is no menu here at
-- all: the proof term is whatever the derivation says it is, and the only
-- thing tried more than once is which of the goal's ≤ 6 variables the
-- induction splits on, which is what `MathMachine.proveByInduction` itself
-- tries and what `certifyWith` now tries when the note names none.  Bounded by
-- the goal, stated, and at most one agda call is spent — on the FIRST module
-- that renders, since a rendered transcription either typechecks or the
-- transcription is wrong.
transcribe :: Goal -> Maybe (Route, String)
transcribe goal@(l, r) =
  case T.transcribeDirect lenv rules "Candidate" goal of
    Just src -> Just (Direct, src)
    Nothing -> firstJust
      [ (,) (Inducted v) <$> T.replayModule lenv "Candidate"
                                (T.deriveByInduction rules goal v)
      | v <- varsOf l `unionI` varsOf r ]
  where
    (lenv, rules) = envFor goal
    varsOf (T.V i) = [i]
    varsOf (T.F _ ts) = concatMap varsOf ts
    unionI a b = foldl (\acc i -> if i `elem` acc then acc else acc ++ [i]) []
                       (a ++ b)
    firstJust xs = case [ x | Just x <- xs ] of
      (x : _) -> Just x
      []      -> Nothing

-- ------------------------------------------------------------- the controls

-- Replace a module's statement and proof, keeping its header and lemma block
-- BYTE-IDENTICALLY.  `transcribeDirect` and `replayModule` both emit
-- `unlines (header ++ preamble ++ [signature, clause])` for a direct
-- transcription, so dropping the last two lines is exactly the block, and the
-- control is then testing the block this run actually shipped rather than a
-- transcription of it made here.  A hand-copied block is a second copy, and a
-- second copy is the thing that is quietly allowed to drift.
splice :: String -> [String] -> String
splice src body = unlines (block ++ body)
  where block = dropLast 2 (lines src)
        dropLast n xs = take (length xs - n) xs

-- ------------------------------------------------------------------ main

main :: IO ()
main = do
  setLocaleEncoding utf8
  hSetEncoding stdout utf8
  hSetBuffering stdout LineBuffering
  args <- getArgs
  let root = case args of (p : _) -> p; [] -> "."
  putStrLn "Pratilipi — the śeṣas, transcribed rather than searched for."
  putStrLn ""

  st <- C.kernelStatus root
  putStrLn ("kernel controls: " ++ show st)
  case st of
    C.KernelChecking -> pure ()
    _ -> do
      putStrLn "The kernel did not pass its own controls.  Nothing below would"
      putStrLn "be a verdict about mathematics, so nothing is run."
      exitFailure
  putStrLn ""

  calls <- newIORef (0 :: Int)
  let spend n = modifyIORef' calls (+ n)

  putStrLn "== the six śeṣas, down the transcription route =="
  results <- forM sesa $ \(nm, goal) ->
    case transcribe goal of
      Nothing -> do
        printf "  no path   %-34s (the derivation does not close here)\n" nm
        pure (nm, Nothing)
      Just (route, src) -> do
        (code, out, n) <- C.runAgdaCached root src
        spend n
        case code of
          ExitSuccess -> do
            printf "  CHECKED   %-34s %-22s (%d call%s)\n"
                   nm (show route) n (if n == 1 then "" else "s")
            pure (nm, Just (route, src))
          ExitFailure _ -> do
            -- Keep it.  `runAgdaCached` writes into a private temp directory
            -- and removes it, so a refusal otherwise leaves the reader a line
            -- and column in a file that no longer exists.
            let path = "/tmp/pratilipi-refused-" ++ safe nm ++ ".agda"
            writeUtf8 path src
            printf "  NO        %-34s %s\n" nm (short (firstLine out))
            printf "            (module kept at %s)\n" path
            pure (nm, Nothing)
  putStrLn ""

  let reached = [ nm | (nm, Just _) <- results ]
      emitted = [ (nm, src) | (nm, Just (_, src)) <- results ]

  -- DECLINING IS NOT REFUSING, and the first draft of this section counted
  -- them as the same thing.  Transcription emits a module only when the two
  -- traces MEET, so a false equation cannot produce one and every control here
  -- came back "declined" without an agda process ever starting.  That is a
  -- true and much weaker statement than "the kernel refused it": it says this
  -- harness did not ask.  So each falsehood is asked anyway — its statement,
  -- on the emitted block's own bytes, under the most permissive proof term the
  -- fragment has.  Both facts are then printed, and counted separately.
  putStrLn "== controls A: four false equations (declined by the route, then asked) =="
  badA <- forM falsehoods $ \(nm, goal) -> do
    let declined = case transcribe goal of Nothing -> True; Just _ -> False
    forged <- case (declined, emitted) of
      (False, _) -> pure Nothing            -- it did NOT decline; see below
      (True, []) -> pure Nothing
      (True, (_, src) : _) -> do
        stmt <- pure (falseStatement goal)
        case stmt of
          Nothing -> pure Nothing
          Just sig -> do
            let m = splice src [ sig, "candidate = refl" ]
            (code, out, n) <- C.runAgdaCached root m
            spend n
            pure (Just (code == ExitSuccess, out))
    case (declined, forged) of
      (False, _) -> do
        printf "  NOT DECLINED %-31s   <-- CONTROL FAILED\n" nm
        pure True
      (True, Just (accepted, out)) -> do
        printf "  %-9s %-34s %s\n"
               (if accepted then "ACCEPTED" else "refused")
               nm
               (if accepted then "<-- CONTROL FAILED" else short (firstLine out))
        pure accepted
      (True, Nothing) -> do
        printf "  declined  %-34s (route declined; NOT submitted)\n" nm
        pure True
  putStrLn ""

  putStrLn "== controls B: the emitted block itself (must be refused) =="
  badB <- case emitted of
    [] -> do
      putStrLn "  no module was emitted, so the block cannot be tested."
      putStrLn "  <-- CONTROL FAILED (a run that proves nothing must not pass)"
      pure [True]
    ((srcName, src) : _) -> do
      -- B1.  The proof term of a module that CHECKED, under a statement that
      -- is false.  If this is accepted, the emitted proof term is not being
      -- checked against the emitted statement at all.
      let b1 = splice src
                 [ "candidate : (x y : ℕ) → (x · (y + zero)) ≡ suc ((x · y))"
                 , "candidate x y = cong (λ h → (x · h)) (addZero (y))" ]
      (c1, o1, n1) <- C.runAgdaCached root b1
      spend n1
      let ok1 = c1 /= ExitSuccess
      printf "  %-9s forged statement, real proof term (from: %s)\n"
             (if ok1 then "refused" else "ACCEPTED") (short srcName)
      if ok1 then printf "            %s\n" (short (firstLine o1))
             else putStrLn "            <-- CONTROL FAILED"
      -- B2.  A falsehood proved FROM the block, on the block's own bytes.  The
      -- shared canary does not import the block, so a block quietly made
      -- inconsistent would not be caught by it.
      let b2 = splice src
                 [ "candidate : (a : ℕ) → (a + zero) ≡ suc a"
                 , "candidate a = addZero a" ]
      (c2, o2, n2) <- C.runAgdaCached root b2
      spend n2
      let ok2 = c2 /= ExitSuccess
      printf "  %-9s (a + 0) ≡ s(a) from the same lemma block\n"
             (if ok2 then "refused" else "ACCEPTED")
      if ok2 then printf "            %s\n" (short (firstLine o2))
             else putStrLn "            <-- CONTROL FAILED"
      pure [not ok1, not ok2]
  putStrLn ""

  n <- readIORef calls
  let spelled = [ nm | nm <- reached, nm `elem` menuCannotSpell ]
      directs = length [ () | (_, Just (Direct, _)) <- results ]
  printf "śeṣas examined                       : %d\n" (length sesa)
  printf "transcribed and kernel-checked        : %d\n" (length reached)
  printf "  of them, with no induction at all   : %d\n" directs
  printf "the three the shape menu cannot spell : %d/%d\n"
         (length spelled) (length menuCannotSpell)
  printf "agda invocations this run             : %d\n" n
  printf "controls A refused                    : %d/%d\n"
         (length [ () | False <- badA ]) (length badA)
  printf "controls B refused                    : %d/%d\n"
         (length [ () | False <- badB ]) (length badB)
  if or badA || or badB
    then putStrLn "PRATILIPI NOT CHECKED — a control failed." >> exitFailure
    else putStrLn "PRATILIPI CHECKED" >> exitSuccess

-- A file name out of a theorem's name, without inventing an index nobody can
-- map back to the theorem.
safe :: String -> String
safe = map (\c -> if c `elem` (" ()*+=,[]" :: String) then '_' else c)

-- The module text is UTF-8 (ℕ, ≡, ∙, λ) and the ambient locale is not to be
-- trusted for it — the same fault `Certificate.writeUtf8` exists for.
writeUtf8 :: FilePath -> String -> IO ()
writeUtf8 p s = do
  h <- openFile p WriteMode
  hSetEncoding h utf8
  hPutStr h s
  hClose h

short :: String -> String
short s = let t = takeWhile (/= '\n') s
          in if length t > 62 then take 62 t ++ "..." else t

-- The FIRST INFORMATIVE line.  Agda's first line of output is
-- `Checking Candidate (/private/var/folders/...)`, which is a progress report
-- and not a diagnosis; printing it as the reason a module was refused is a
-- report that says nothing, and it hid this file's one real failure for a
-- whole run.  Same filter `TraceReplay.measureSnapshot` uses, for the same
-- reason.
firstLine :: String -> String
firstLine s = case [ unwords (words l) | l <- lines s, informative l ] of
  (l : _) -> l
  []      -> "(no output)"
  where
    informative ln = not (null (words ln))
                     && take 9 (dropWhile (== ' ') ln) /= "Checking "
