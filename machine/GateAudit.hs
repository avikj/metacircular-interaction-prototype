-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- GateAudit.hs — a hostile audit of the Agda kernel gate in Certificate.hs.
--
-- WHY THIS EXISTS
--
-- `machine/MathMachine.hs` installs a discovered equation as a permanent
-- rewrite rule iff `Certificate.certifyWith` returns `Certified`
-- (`kernelAcceptWith`, MathMachine.hs ~1286).  Every later round then
-- reasons with that rule.  So the gate is the only thing between a false
-- conjecture and the corpus, and its shipped evidence of soundness is the
-- four hand-picked falsehoods in `Certificate.main`.  Four controls are not
-- a proof.  This module is the adversary.
--
-- It imports `Certificate` and edits nothing: `Certificate.hs`,
-- `MathMachine.hs` and `ArithVocab.hs` are untouched, so what is attacked is
-- the shipped code, not a copy of it.
--
-- WHAT IS AUDITED, IN FOUR SECTIONS
--
--   A. A SYSTEMATIC FALSEHOOD POPULATION.  Enumerate every term of size ≤ 3
--      over the engine's vocabulary (0 s + * - max le gcd) in two variables,
--      form every unordered pair, and keep the pairs that are FALSE.
--      Falsity is decided by exact Integer evaluation on a finite grid: one
--      disagreeing assignment is a proof of falsity and costs nothing, so
--      this population contains no conjectures — every member is a theorem
--      of arithmetic's negation, with a witness printed on demand.  Each is
--      submitted to `certifyWith` with a plausible proof note.  ANY
--      `Certified` here is an unsoundness.
--
--   B. ADVERSARIAL SHAPES.  Not a random population but the seams:
--        * equations true on every assignment the ENGINE ever tests
--          (`MathMachine.assignments` reduces mod 9, so its test set is
--          exactly {0..8}) and false immediately beyond.  These attack the
--          engine's refutation stage, not the gate; the distinction is
--          marked `[engine]` in the table, and the gate is expected to be
--          the backstop that catches them.
--        * invented concepts supplied through the `Definition` argument,
--          including definitions that do not match the name used in the
--          equation, definitions shadowing vocabulary symbols, and
--          definitions whose NAME is an injection vector.
--        * proof notes that are malformed, absent, or name an induction
--          variable that does not occur.
--
--   C. THE ENVIRONMENT ATTACK.  `LOOP_MEASUREMENT.md` §4 records the
--      2026-08-15 finding that a broken `agda -i` invocation turned every
--      candidate into a KERNEL-REJECT indistinguishable from a false
--      statement.  This section asks the dual question: can an environment
--      failure produce a CERTIFIED?  agda missing from PATH, agda exiting
--      nonzero for a non-type-error reason, agda hanging, the emitted module
--      failing to PARSE rather than to typecheck, the include root missing,
--      and the certificate cache.  These are driven from OUTSIDE by
--      re-executing this same binary in a doctored environment (`--probe`),
--      never by editing Certificate.hs, so the shipped code is what runs.
--
--   D. AN INTEGRITY AUDIT OF THE SHIPPED CACHE (opt-in, `--sections d`).
--      `machine/.certcache` is an unauthenticated on-disk store of verdicts.
--      Re-run agda on the SOURCE of every entry that claims `accepted` and
--      check that agda agrees.
--
-- HOW TO BUILD AND RUN.  From the repository root:
--
--     ghc -O1 -imachine -outputdir /tmp/ga-build -o /tmp/ga \
--         -main-is GateAudit machine/GateAudit.hs
--     MATH_CERTCACHE=0 /tmp/ga .                 # sections a b c
--     MATH_CERTCACHE=0 /tmp/ga . --sections d    # the cache integrity audit
--
-- `MATH_CERTCACHE=0` is deliberate for A and B: an audit must not read a
-- verdict it did not obtain from the kernel, and must not write its own
-- adversarial modules into the repository's cache.  Section C sets the
-- variable itself, per probe, because the cache is one of the things under
-- attack.
--
-- Section A parallelises by `--slice K/M` (take every M-th member starting
-- at K).  The slices are disjoint and their union is the whole population,
-- so N processes cover it in 1/N the wall clock; agda is single-threaded.
--
-- `main` exits nonzero if any falsehood was certified.
--
-- ===================================================================
-- FINDINGS, 2026-08-16.  Audited machine/Certificate.hs at sha256
-- 15a3ef5c746882a17eff2abab55aaf71514b9d142f0d63deed9dee58463a857e and
-- machine/MathMachine.hs at 6fe7655ea48c336dd755862a5410dcedab30b1d70c
-- 3145af245e14431c0cda1d, Agda 2.6.3 with cubical v0.5.  Both files were
-- being edited by other agents while this ran; the hashes are what the
-- audited binary was built from and re-checking them is part of replaying
-- this.
--
-- WHAT SURVIVED.  On the systematic population (section A) the gate did not
-- admit a single falsehood.  Every rejection carried a genuine agda type
-- error naming the offending subterm.  The three equations that are true on
-- {0..8} — every assignment MathMachine's refutation stage ever forms — and
-- false immediately beyond were all rejected by the gate.  The 28 `accepted`
-- entries in the shipped machine/.certcache all re-check under agda.
--
-- WHAT DID NOT.  Four defects, in decreasing severity.
--
-- (1) NAME INJECTION THROUGH `Definition`, and it is a true unsoundness.
--     `preambleWith`'s `emit` drops a definition whose body does not
--     translate, justified in a comment as "the candidate fails to
--     scope-check rather than silently meaning something else".  That is
--     false when the dropped NAME is itself Agda source: `prefixAgda`
--     splices the name verbatim into the candidate's type, so a name ending
--     in a line comment deletes the caller's right-hand side.  With
--     `injName = "suc x) ≡ (suc x) -- "` the gate returns `Certified "refl" 1`
--     for the submitted equations `injName(x) = x`, `injName(x) = 0` AND
--     `injName(x) = s(s(x))`.  Three different right-hand sides for one
--     left-hand side all certify, which is a proof of unsoundness that needs
--     no appeal to arithmetic: what agda checked was `suc x ≡ suc x`, three
--     times.  `kernelAcceptWith` would install all three as rewrite rules.
--     REACHABILITY: not from the engine as it stands — `inventConcept` names
--     concepts `"c" ++ show n`, and neither `parseShowTerm` (names are
--     alphanumeric plus `_ #`) nor `parseSerialCert` (tokens cannot contain
--     spaces or parens) can produce such a name.  This is a latent hole in
--     the gate's contract, not an active exploit.  The fix is one predicate:
--     validate `defName` as an Agda identifier, and make an untranslatable
--     body a rejection rather than a silent drop.
--
-- (2) THE GATE READS THE EXIT STATUS AND NOTHING ELSE, so any environment
--     that loses agda's exit status certifies everything.  The realistic
--     form is a wrapper of the shape `agda "$@" 2>&1 | cat`, whose status is
--     the last stage's: real agda runs, really reports `suc x != x`, really
--     exits 1, and `certifyWith` returns `Certified "refl" 1` for
--     `s(x) = x`.  This is the converse of the 2026-08-15 finding in
--     LOOP_MEASUREMENT §4 and the answer is NO, the gate does not fail
--     closed.  It fails closed against agda being absent, exiting 139,
--     exiting 1 with noise, and against modules that fail to PARSE; it fails
--     OPEN against a corrupted exit status.
--
-- (3) THE FAULT IN (2) IS THEN MADE PERMANENT BY THE CACHE.  `runAgdaCached`
--     stores every `ExitSuccess` unconditionally.  Under the pipeline shim
--     the bogus accept is written to `machine/.certcache`, and after the
--     environment is repaired — real agda, same cache — the same false
--     equation comes back `Certified "cached, refl" 0`.  The toolchain
--     string in the key defends against the crude shim (which cannot answer
--     `agda --version`) and not at all against the realistic one (which
--     delegates it).  Separately, the store is unauthenticated: `--probe
--     poison` writes one file by hand, using only exported API to compute
--     the key, and turns `s(x) = x` into a `Certified` with zero agda
--     invocations.  `cacheableFailure` is careful in exactly the wrong
--     direction — it refuses to cache a rejection it cannot attribute to a
--     type error, while caching every success it cannot attribute to
--     anything.
--
-- (4) THE ENGINE HANDS THE GATE THE WRONG HALF OF ITS OWN CONCEPT RULE.
--     `MathMachine.certDefinitions` reads `Just (_, body) <- [conceptRule s]`
--     and `inventConcept` builds that rule as `(pattern, F nm args)`, so
--     `body` is `c0(a0)` and the emitted Agda is `c0 a0 = (c0 a0)`.  Agda
--     answers "Termination checking failed" and every candidate mentioning
--     an invented concept is rejected for a reason unrelated to its truth.
--     Not an unsoundness — but concept invention is described in
--     MathMachine's own header as the machine's growth axis, and at the gate
--     that axis is currently closed.  `Certificate.main`'s `selfTestDefs`
--     uses the FIRST component and so cannot see this; the two cases
--     "engine seam: body = snd/fst conceptRule" in section B are the
--     difference, side by side.
--
-- TWO LIVENESS OBSERVATIONS, not soundness.  The gate has NO TIMEOUT: an
-- agda that never returns blocks `certifyWith` forever, and `kMaxAgdaCalls`
-- bounds the number of processes, not the wall clock.  And `runAgda` lets
-- IO exceptions escape — a missing agda, or a `root` that does not exist,
-- raises out of `certifyWith`, and `kernelAcceptWith` does not catch it, so
-- the engine aborts instead of rejecting.
--
-- ONE HARDENING, no exploit claimed.  The emitted OPTIONS line is
-- `--cubical --guardedness --safe --no-import-sorts`.  `--safe` turns
-- `--guardedness` OFF unless it is set explicitly, and this line sets it
-- explicitly; no emitted module contains coinduction, and every one of them
-- typechecks with the flag removed (checked).  The documented inconsistency
-- is `--guardedness` together with `--sized-types`, which this line does not
-- request, so nothing here is a demonstrated hole — but the flag buys the
-- gate nothing and re-enables something `--safe` had switched off.
-- ===================================================================

module GateAudit (main) where

import Certificate hiding (main)
import qualified Prastara_TheSearchSpaceIsGeneratedNotStored as P

import Control.Exception (SomeException, evaluate, try)
import Control.Monad (forM, forM_, unless, when)
import Data.IORef (IORef, modifyIORef', newIORef, readIORef)
import Data.List (intercalate, isPrefixOf, nub, sort)
import Data.Maybe (fromMaybe, listToMaybe, mapMaybe)
import System.Directory
  ( createDirectoryIfMissing, doesDirectoryExist, doesFileExist
  , getPermissions, listDirectory, setOwnerExecutable, setPermissions )
import GHC.IO.Encoding (setLocaleEncoding)
import System.Environment (getArgs, getExecutablePath, getEnvironment)
import System.Exit (ExitCode(..), exitFailure, exitSuccess)
import System.FilePath ((</>))
import System.IO
import System.Process
  (CreateProcess(..), proc, readCreateProcessWithExitCode)
import Text.Printf (printf)

-- ===================================================================== terms

zero_ :: Term
zero_ = F "0" []

su :: Term -> Term
su = \t -> F "s" [t]

nat :: Int -> Term
nat n = iterate su zero_ !! n

bin :: String -> Term -> Term -> Term
bin f a b = F f [a, b]

x_, y_ :: Term
x_ = V 0
y_ = V 1

-- The engine's vocabulary, arities as in Certificate.render.
binarySymbols :: [String]
binarySymbols = ["+", "*", "-", "max", "le", "gcd"]

-- ===================================================== exact semantics on ℕ
--
-- These are the functions the emitted Agda module denotes, transcribed from
-- Certificate's own translation table (header, "FAITHFULNESS"):
--   +, *  builtin ℕ addition/multiplication
--   -     _∸_, truncated subtraction
--   max   localMax: max a zero = a; max zero b = b; max (suc a)(suc b) = suc (max a b)
--   le    localLe: le zero b = 1; le (suc a) zero = 0; le (suc a)(suc b) = le a b
--   gcd   Cubical.Data.Nat.GCD.gcd, i.e. Haskell gcd on ℕ with gcd 0 0 = 0
-- and they agree with MathMachine's `symSem`.  Evaluation is exact Integer
-- arithmetic; nothing here is a measurement.

lookupDefn :: [Definition] -> String -> Maybe Definition
lookupDefn ds f = listToMaybe [ d | d <- ds, defName d == f ]

evalT :: [Definition] -> [(Int, Integer)] -> Term -> Maybe Integer
evalT defs = go (8 :: Int)
  where
    go _ env (V i) = lookup i env
    go fuel env (F f as) = do
      vs <- mapM (go fuel env) as
      case prim f vs of
        Just v -> Just v
        Nothing -> unfold fuel f vs
    prim "0" [] = Just 0
    prim "s" [a] = Just (a + 1)
    prim "+" [a, b] = Just (a + b)
    prim "*" [a, b] = Just (a * b)
    prim "-" [a, b] = Just (max 0 (a - b))
    prim "max" [a, b] = Just (max a b)
    prim "le" [a, b] = Just (if a <= b then 1 else 0)
    prim "gcd" [a, b] = Just (gcd a b)
    prim _ _ = Nothing
    unfold fuel f vs
      | fuel <= 0 = Nothing
      | Just d <- lookupDefn defs f, defArity d == length vs =
          go (fuel - 1) (zip [0 ..] vs) (defBody d)
      | otherwise = Nothing

-- The refutation grid.  Small on purpose: a counterexample is a proof and
-- larger grids buy nothing for the members that already have one.  What a
-- grid CANNOT do is establish truth — that asymmetry is section B's subject.
kGrid :: Integer
kGrid = 6

-- सारणी वा क्रिया (Piṅgala, Chandaḥśāstra 8.24–28).  This was
--     gridFor vs = map (zip vs) (mapM (const [0 .. kGrid]) vs)
-- — the grid laid out.  It is now naṣṭa in radix (kGrid+1): same rows,
-- same order, made from an index and dropped.  Checked exhaustively for
-- 1..4 variables in machine/PrastaraRun.hs.
gridFor :: [Int] -> [[(Int, Integer)]]
gridFor vs = P.rows (P.gridPrastara vs kGrid)

-- A single disagreeing assignment, if there is one on the grid.
falsityWitness :: [Definition] -> Equation -> Maybe ([(Int, Integer)], Integer, Integer)
falsityWitness defs (l, r) =
  listToMaybe
    [ (e, a, b)
    | e <- gridFor (sort (nub (varsOf l ++ varsOf r)))
    , Just a <- [evalT defs e l]
    , Just b <- [evalT defs e r]
    , a /= b
    ]

showWitness :: ([(Int, Integer)], Integer, Integer) -> String
showWitness (e, a, b) =
  "[" ++ intercalate ", " [ nm i ++ "=" ++ show v | (i, v) <- e ] ++ "] "
    ++ show a ++ " /= " ++ show b
  where nm i = fromMaybe ("n" ++ show i) (agdaVar i)

-- The machine's own Show, so the table names equations the way the engine's
-- log and machine/library.txt do.
pretty :: Term -> String
pretty (V i) = fromMaybe ("n" ++ show i) (agdaVar i)
pretty (F f []) = f
pretty (F f [a, b])
  | f `elem` ["+", "*", "^", "gcd", "max"] =
      "(" ++ pretty a ++ f ++ pretty b ++ ")"
pretty (F f as) = f ++ "(" ++ intercalate "," (map pretty as) ++ ")"

prettyEq :: Equation -> String
prettyEq (l, r) = pretty l ++ " = " ++ pretty r

-- ============================================================== enumeration

-- Terms of each size 1..n over {x, y, 0} with s and the six binary symbols.
termsBySize :: Int -> [[Term]]
termsBySize n = table
  where
    table = [ gen k | k <- [1 .. n] ]
    at k = table !! (k - 1)
    gen 1 = [x_, y_, zero_]
    gen k =
      [ su t | t <- at (k - 1) ]
        ++ [ bin f a b
           | f <- binarySymbols
           , i <- [1 .. k - 2]
           , a <- at i
           , b <- at (k - 1 - i)
           ]
    gen _ = []

kTermSize :: Int
kTermSize = 3

allSmallTerms :: [Term]
allSmallTerms = concat (termsBySize kTermSize)

-- Every unordered pair of distinct terms.  Ordered pairs would only double
-- the population with mirror images: `certifyWith` is not symmetric in
-- general (refl is, the induction skeleton's step shapes are not), but a
-- Certified on (l,r) and on (r,l) are the same unsoundness, and the mirror
-- is covered in section B where it is cheap.
allPairs :: [Equation]
allPairs =
  [ (a, b)
  | (i, a) <- zip [(0 :: Int) ..] allSmallTerms
  , (j, b) <- zip [(0 :: Int) ..] allSmallTerms
  , i < j
  ]

-- The falsehood population: every pair with a counterexample on the grid.
falsePopulation :: [(Equation, ([(Int, Integer)], Integer, Integer))]
falsePopulation =
  [ (eq, w) | eq <- allPairs, Just w <- [falsityWitness [] eq] ]

-- Pairs with no counterexample on the grid — NOT claimed true, just not
-- refuted here.  Reported as a count so the population's complement is
-- visible rather than silently discarded.
unrefutedPairs :: [Equation]
unrefutedPairs = [ eq | eq <- allPairs, falsityWitness [] eq == Nothing ]

-- A plausible proof note, of the shape MathMachine writes.
noteFor :: Equation -> String
noteFor (l, r) = case sort (nub (varsOf l ++ varsOf r)) of
  (v : _) -> "[induction on " ++ fromMaybe "x" (agdaVar v) ++ "]"
  [] -> "[induction on x]"

-- ================================================================= running

data Outcome
  = OCert String Int
  | ORej String Int
  | OUntr String
  | OExc String
  deriving (Eq, Show)

outcomeTag :: Outcome -> String
outcomeTag (OCert _ _) = "CERTIFIED"
outcomeTag (ORej _ _) = "rejected"
outcomeTag (OUntr _) = "untranslatable"
outcomeTag (OExc _) = "EXCEPTION"

outcomeDetail :: Outcome -> String
outcomeDetail (OCert s n) = s ++ " (" ++ show n ++ " calls)"
outcomeDetail (ORej s n) = s ++ " (" ++ show n ++ " calls)"
outcomeDetail (OUntr s) = s
outcomeDetail (OExc s) = s

isCert :: Outcome -> Bool
isCert (OCert _ _) = True
isCert _ = False

-- One submission to the shipped gate, with exceptions caught and reported
-- rather than allowed to abort the audit.  An exception is itself a finding
-- (see the missing-agda probe), so it must be visible, not fatal.
submit :: [Definition] -> FilePath -> (Equation, String) -> IO Outcome
submit defs root c = do
  r <- try (do
         v <- certifyWith defs root c
         _ <- evaluate (length (show v))
         pure v) :: IO (Either SomeException Verdict)
  pure $ case r of
    Left e -> OExc (oneLine (show e))
    Right (Certified s n) -> OCert s n
    Right (Rejected s n) -> ORej s n
    Right (Untranslatable s) -> OUntr s

oneLine :: String -> String
oneLine = unwords . words

clip :: Int -> String -> String
clip n s = let t = oneLine s in if length t > n then take (n - 3) t ++ "..." else t

-- ================================================================ section A

runSectionA :: FilePath -> (Int, Int) -> IORef [String] -> IO (Int, Int, Int, Int)
runSectionA root (sliceK, sliceM) admittedRef = do
  let pop = falsePopulation
      mine = [ p | (i, p) <- zip [(0 :: Int) ..] pop, i `mod` sliceM == sliceK ]
  printf "== A. systematic falsehoods ==\n"
  printf "terms of size <= %d over {x,y,0} with s and %s: %d\n"
    kTermSize (show binarySymbols) (length allSmallTerms)
  printf "unordered pairs: %d ; refuted on the grid [0..%d]: %d ; unrefuted: %d\n"
    (length allPairs) kGrid (length pop) (length unrefutedPairs)
  printf "this process runs slice %d of %d: %d equations\n\n" sliceK sliceM (length mine)
  outs <- forM (zip [(1 :: Int) ..] mine) $ \(i, (eq, w)) -> do
    o <- submit [] root (eq, noteFor eq)
    when (isCert o) $ do
      let src = fromMaybe "(emitter returned Nothing)" (agdaCertificateWith [] eq)
      modifyIORef' admittedRef
        (("A/" ++ show i ++ "  " ++ prettyEq eq ++ "\n  witness: " ++ showWitness w
          ++ "\n  verdict: " ++ outcomeDetail o ++ "\n  module:\n"
          ++ unlines (map ("    " ++) (lines src))) :)
    printf "  %-10s %-34s %s\n" (outcomeTag o) (clip 34 (prettyEq eq)) (clip 60 (outcomeDetail o))
    pure o
  let nc = length (filter isCert outs)
      nr = length [ () | ORej _ _ <- outs ]
      nu = length [ () | OUntr _ <- outs ]
      ne = length [ () | OExc _ <- outs ]
  printf "\nA: %d submitted, %d CERTIFIED, %d rejected, %d untranslatable, %d exceptions\n\n"
    (length mine) nc nr nu ne
  pure (nc, nr, nu, ne)

-- ================================================================ section B

data Case = Case
  { cLabel :: String
  , cKind :: String        -- "gate" | "engine" | "control"
  , cDefs :: [Definition]
  , cEq :: Equation
  , cNote :: String
  , cWhy :: String         -- what a Certified here would mean
  }

-- The name-injection vector.  `preambleWith`'s `emit` DROPS a definition
-- whose body does not translate, with the comment "so the candidate fails to
-- scope-check rather than silently meaning something else".  That reasoning
-- assumes the dropped NAME is meaningless to Agda.  A name may instead be a
-- fragment of Agda source: it is spliced verbatim into the candidate's type
-- by `prefixAgda`, and the emitted line is
--
--     candidate : (x : ℕ) → (<name> x) ≡ <rhs>
--
-- so a name ending in a line comment deletes the caller's right-hand side.
injName :: String
injName = "suc x) \8801 (suc x) -- "

injDef :: Definition
injDef = Definition injName 1 (F "\9633untranslatable" [])

sectionBCases :: [Case]
sectionBCases =
  -- controls: the harness must be able to produce a Certified at all, or a
  -- clean sheet in A means nothing.
  [ Case "control: x = (0+x)" "control" []
      (x_, bin "+" zero_ x_) "[induction on x]"
      "control — this MUST certify or the audit proves nothing"
  , Case "control: gcd(x,0) = x" "control" []
      (bin "gcd" x_ zero_, x_) "[induction on x]"
      "control — exercises the gcd import path"

  -- true on every assignment the ENGINE tests, false beyond.
  -- MathMachine.assignments reduces every value mod 9, so its entire test
  -- set is {0..8}, for every run, at every kAssign.
  , Case "[engine] -(x,8) = 0" "engine" []
      (bin "-" x_ (nat 8), zero_) "[induction on x]"
      "true on {0..8} = every assignment the engine ever forms; false at x=9"
  , Case "[engine] le(x,9) = s(0)" "engine" []
      (bin "le" x_ (nat 9), su zero_) "[induction on x]"
      "true for x <= 9, false at x = 10"
  , Case "[engine] (xmax9) = 9" "engine" []
      (bin "max" x_ (nat 9), nat 9) "[induction on x]"
      "true for x <= 9, false at x = 10"

  -- invented concepts through the Definition argument.
  , Case "concept, honest: c0(x) = (x+x)" "control"
      [Definition "c0" 1 (bin "+" (V 0) (V 0))]
      (F "c0" [x_], bin "+" x_ x_) "[induction on x]"
      "control — the engine's own first concept, correctly supplied"
  -- THE DEFINITION THE ENGINE ACTUALLY PASSES.  MathMachine.certDefinitions
  -- (~1276) reads `Just (_, body) <- [conceptRule s]`, and `conceptRule` is
  -- `symDefs s`'s single rule, which `inventConcept` (~1655) builds as
  -- `(p, F nm (map V [0 .. ar-1]))` — pattern on the LEFT, the folded name on
  -- the RIGHT.  Taking the second component makes the Definition body
  -- `c0(a0)`, so the emitted Agda is `c0 a0 = (c0 a0)`.  The self-test in
  -- Certificate.main uses the FIRST component and therefore cannot see this.
  , Case "engine seam: body = snd conceptRule" "gate"
      [Definition "c0" 1 (F "c0" [V 0])]
      (F "c0" [x_], bin "+" x_ x_) "[induction on x]"
      "this is the Definition MathMachine hands the gate for its own concept"
  , Case "engine seam: body = fst conceptRule" "control"
      [Definition "c0" 1 (bin "+" (V 0) (V 0))]
      (F "c0" [x_], bin "+" x_ x_) "[induction on x]"
      "control — the same case with the component Certificate's header specifies"
  , Case "concept undefined: c1(x) = x" "gate"
      [Definition "c0" 1 (bin "+" (V 0) (V 0))]
      (F "c1" [x_], x_) "[induction on x]"
      "a name with no supplied definition must be untranslatable"
  -- RECLASSIFIED 2026-08-16 by cf-tantu, with the argument stated in
  -- machine/GATE_AUDIT_DISPOSITION.md §4 and msg 0868, and this file's author
  -- no longer in session.  It was "gate", i.e. certifying it counted as an
  -- unsoundness -- which made `main` exit nonzero forever and the audit
  -- useless as a standing check.
  --
  -- The gate certifies relative to the definitions it is HANDED, and that is
  -- all it can do: given `c0 = id` and `c0(x) = x` it is right to certify,
  -- because that equation is true of that definition.  It has no second
  -- source of truth for `c0`.  The obligation is the CALLER's, so the check
  -- belongs there, and `MathMachine.certDefinitions` now carries it: a
  -- concept contributes a Definition only if its rule folds to that symbol
  -- applied to its own parameters, its body's variables are exactly
  -- V 0..V(arity-1), and body and fold agree on [0..8]^arity by exact
  -- Integer evaluation.  A concept failing any of those makes every
  -- candidate mentioning it Untranslatable.
  --
  -- What is NOT claimed: this case no longer tests anything about the gate.
  -- The property it used to gesture at is now tested on the engine side and
  -- nothing here checks that `certDefinitions` still carries it.  A section E
  -- that drives the engine's own emitter is the missing piece.
  , Case "concept mismatched: c0(x) = x" "control"
      [Definition "c0" 1 (V 0)]
      (F "c0" [x_], x_) "[induction on x]"
      "control — the gate certifies against the definition it is handed; the caller's obligation is checked in certDefinitions"
  , Case "concept arity mismatch: c0(x,y) = x" "gate"
      [Definition "c0" 1 (V 0)]
      (F "c0" [x_, y_], x_) "[induction on x]"
      "arity disagreement must not translate"
  , Case "concept body out of range" "gate"
      [Definition "c0" 1 (V 3)]
      (F "c0" [x_], x_) "[induction on x]"
      "body mentions a0's nonexistent sibling a3; must not certify"
  , Case "concept shadows max" "gate"
      [Definition "max" 2 (V 0)]
      (bin "max" x_ y_, x_) "[induction on x]"
      "supplied max = fst; the vocabulary's max is emitted too"
  , Case "concept shadows le" "gate"
      [Definition "le" 2 (V 0)]
      (bin "le" x_ y_, x_) "[induction on x]"
      "supplied le = fst; false under the vocabulary's le"
  , Case "concept shadows gcd" "gate"
      [Definition "gcd" 2 (V 0)]
      (bin "gcd" x_ y_, x_) "[induction on x]"
      "gcd is IMPORTED, not locally emitted: a supplied gcd may not clash"
  , Case "concept shadows candidate" "gate"
      [Definition "candidate" 1 (V 0)]
      (F "candidate" [x_], x_) "[induction on x]"
      "a definition named like the theorem itself"

  -- name injection.  Three different right-hand sides for the SAME left-hand
  -- side: if more than one certifies, the gate has certified an equation
  -- system with no solution, which is a proof of unsoundness needing no
  -- appeal to arithmetic.
  , Case "INJECTION rhs = x" "gate" [injDef]
      (F injName [x_], x_) "[induction on x]"
      "the emitted type is not the submitted equation"
  , Case "INJECTION rhs = 0" "gate" [injDef]
      (F injName [x_], zero_) "[induction on x]"
      "same lhs as the previous case with a different rhs"
  , Case "INJECTION rhs = s(s(x))" "gate" [injDef]
      (F injName [x_], su (su x_)) "[induction on x]"
      "same lhs again with a third rhs"
  , Case "INJECTION unterminated block comment" "gate"
      [Definition "c0\n{-" 1 (F "\9633untranslatable" [])]
      (F "c0\n{-" [x_], x_) "[induction on x]"
      "a name that opens a block comment agda cannot close"

  -- proof notes.
  , Case "note names an absent variable" "gate" []
      (su x_, x_) "[induction on y]"
      "false equation whose note points at a variable that does not occur"
  , Case "true eq, note names absent variable" "control" []
      (x_, bin "+" zero_ x_) "[induction on y]"
      "control — this is TRUE and refl-provable, so the bad note is irrelevant"
  , Case "note absent, false equation" "gate" []
      (su x_, x_) ""
      "no note: the induction path must not run at all"
  , Case "note malformed, false equation" "gate" []
      (su x_, x_) "by inspection, obviously"
      "unparseable note"
  , Case "note names n7, false equation" "gate" []
      (su x_, x_) "[induction on n7]"
      "variable index outside the six universe names"
  , Case "note names the other variable, false equation" "gate" []
      (bin "+" x_ y_, bin "*" x_ y_) "[induction on y]"
      "induction on a variable that occurs but is the wrong one"

  -- variables outside the emitter's range.
  , Case "variable index 7" "gate" []
      (V 7, bin "+" zero_ (V 7)) "[induction on x]"
      "agdaVar has six names; a seventh index must not translate"
  ]

runSectionB :: FilePath -> IORef [String] -> IO [(Case, Outcome)]
runSectionB root admittedRef = do
  printf "== B. adversarial shapes ==\n"
  rs <- forM (zip [(1 :: Int) ..] sectionBCases) $ \(i, c) -> do
    o <- submit (cDefs c) root (cEq c, cNote c)
    printf "  %-10s %-40s %s\n" (outcomeTag o) (clip 40 (cLabel c)) (clip 52 (outcomeDetail o))
    when (isCert o && cKind c /= "control") $ do
      let src = fromMaybe "(emitter returned Nothing)"
                  (agdaCertificateWith (cDefs c) (cEq c))
      modifyIORef' admittedRef
        (("B/" ++ show i ++ "  " ++ cLabel c ++ "\n  submitted: " ++ prettyEq (cEq c)
          ++ "\n  why it matters: " ++ cWhy c
          ++ "\n  verdict: " ++ outcomeDetail o ++ "\n  module agda actually checked:\n"
          ++ unlines (map ("    " ++) (lines src))) :)
    pure (c, o)
  putStrLn ""
  pure rs

-- ================================================================ section C
--
-- Environment probes.  Each runs THIS binary again, as a child, in a
-- doctored environment, and reads back a one-line classification.  Nothing
-- in Certificate.hs is edited or simulated; the child calls the shipped
-- `certifyWith` and the environment is what differs.

data Probe = Probe
  { prName :: String
  , prDesc :: String
  , prShim :: Maybe String   -- AUDIT_SHIM behaviour, if a fake agda is used
  , prPathless :: Bool       -- strip agda from PATH entirely
  , prCache :: String        -- MATH_CERTCACHE value for the child
  , prRootKind :: String     -- "repo" | "bare" | "poison"
  , prTimeout :: Int         -- seconds the parent will wait
  , prExpect :: String
  }

probes :: [Probe]
probes =
  [ Probe "agda-absent" "agda absent from PATH (coreutils still present)"
      Nothing True "0" "repo" 90
      "fail closed: no Certified"
  , Probe "exit1-noise" "agda exits 1 for a non-type-error reason (disk quota)"
      (Just "exit1-noise") False "1" "temp" 90
      "fail closed: Rejected, and NOT written to the cache"
  , Probe "exit0-silent" "a process named agda that exits 0 without checking"
      (Just "exit0-silent") False "1" "temp" 90
      "the gate reads the exit status and nothing else"
  , Probe "exit0-pipeline" "realistic wrapper: `agda \"$@\" 2>&1 | cat` — pipeline status is cat's"
      (Just "exit0-pipeline") False "1" "temp" 400
      "real agda runs, really reports the type error, and really exits 1 — into a pipe"
  , Probe "hang" "agda never terminates"
      (Just "hang") False "0" "repo" 25
      "the gate has no timeout"
  , Probe "signal" "agda dies on a signal (exit 139)"
      (Just "signal") False "0" "repo" 90
      "fail closed: Rejected"
  , Probe "no-include-root" "the include root formal/cubical is absent (the 2026-08-15 fault)"
      Nothing False "0" "bare" 120
      "fail closed: Rejected"
  , Probe "parse-not-typecheck" "the emitted module fails to PARSE, not to typecheck"
      Nothing False "0" "parse" 120
      "fail closed: Rejected"
  , Probe "cache-poison" "a hand-written file in machine/.certcache claims accepted"
      Nothing False "1" "poison" 120
      "a verdict produced with zero agda invocations"
  ]

-- The shim.  One script, dispatching on AUDIT_SHIM, so the probe table and
-- the script cannot drift apart.
shimSource :: FilePath -> String
shimSource realAgda = unlines
  [ "#!/bin/sh"
  , "case \"$AUDIT_SHIM\" in"
  , "  exit1-noise)"
  , "    echo 'agda: could not create directory: Disk quota exceeded' >&2"
  , "    exit 1 ;;"
  , "  exit0-silent)"
  , "    exit 0 ;;"
  , "  exit0-pipeline)"
  , "    " ++ realAgda ++ " \"$@\" 2>&1 | cat"
  , "    exit $? ;;"
  , "  hang)"
  , "    case \"$1\" in --version) echo 'Agda version 2.6.3' ; exit 0 ;; esac"
  , "    sleep 600 ;;"
  , "  signal)"
  , "    exit 139 ;;"
  , "  *)"
  , "    exec " ++ realAgda ++ " \"$@\" ;;"
  , "esac"
  ]

-- The child side of a probe: submit one equation known to certify in a
-- healthy environment, and one that must never certify.
probeMain :: String -> FilePath -> IO ()
probeMain kind root = do
  hSetEncoding stdout utf8
  hSetBuffering stdout LineBuffering
  case kind of
    "poison" -> do
      -- Forge a cache entry for the refl module of a FALSE equation and then
      -- ask the shipped gate for a verdict.  Only exported API is used:
      -- agdaCertificateWith gives the exact source, toolchainIdentity and
      -- cacheKey give the exact filename, and the on-disk format is the one
      -- `encodeEntry` writes.
      let eq = (su x_, x_)
      case agdaCertificateWith [] eq of
        Nothing -> putStrLn "PROBE-FALSE untranslatable emitter-returned-Nothing"
        Just src -> do
          tc <- toolchainIdentity
          let key = cacheKey tc src
              dir = root </> kCertCacheDir
              body = lines src
              entry = unlines $
                [ "CERTCACHE 1"
                , "VERDICT accepted"
                , "EXIT 0"
                , "TOOLCHAIN " ++ tc
                , "AGDA-OUTPUT 0 nonl"
                , "SOURCE " ++ show (length body) ++ " nl"
                ] ++ body
          createDirectoryIfMissing True dir
          withFile (dir </> key) WriteMode $ \h ->
            hSetEncoding h utf8 >> hPutStr h entry
          o <- submit [] root (eq, "[induction on x]")
          printf "PROBE-FALSE %s %s\n" (outcomeTag o) (clip 70 (outcomeDetail o))
          printf "PROBE-NOTE forged-key %s\n" key
    "parse" -> do
      -- A module that fails at the LEXER, not the typechecker: the name opens
      -- a block comment agda can never close.  The question is only whether a
      -- syntax failure can be mistaken for success.
      let d = Definition "c0\n{-" 1 (F "\9633untranslatable" [])
          eq = (F "c0\n{-" [x_], x_)
      o <- submit [d] root (eq, "[induction on x]")
      printf "PROBE-FALSE %s %s\n" (outcomeTag o) (clip 70 (outcomeDetail o))
    _ -> do
      tOut <- submit [] root ((x_, bin "+" zero_ x_), "[induction on x]")
      printf "PROBE-TRUE %s %s\n" (outcomeTag tOut) (clip 70 (outcomeDetail tOut))
      fOut <- submit [] root ((su x_, x_), "[induction on x]")
      printf "PROBE-FALSE %s %s\n" (outcomeTag fOut) (clip 70 (outcomeDetail fOut))
      -- What agda ITSELF said about the false module, taken from the same
      -- shipped entry point the gate uses.  This separates "the gate believed
      -- agda" from "agda was never consulted".
      raw <- try (case agdaCertificateWith [] (su x_, x_) of
                    Nothing -> pure (ExitFailure (-1), "no module")
                    -- UNWATCHED on purpose, and by name since 2026-08-20:
                    -- `Certificate.runAgda` now applies the falsifier watch,
                    -- and this probe's whole job is to print what the child
                    -- returned BEFORE anyone judged it.  Vetting here would
                    -- make PROBE-RAW report the verdict it exists to be
                    -- compared against.
                    Just s -> runAgdaUnwatched root s) :: IO (Either SomeException (ExitCode, String))
      case raw of
        Left e -> printf "PROBE-RAW exception %s\n" (clip 70 (show e))
        Right (c, out) ->
          printf "PROBE-RAW exit=%s agda-said=%s\n" (show c) (clip 70 out)

-- A repository-shaped directory that is NOT the repository: `formal` is a
-- symlink so agda can resolve the include root, and `machine/.certcache` is
-- private, so no probe can write an adversarial verdict into the real tree.
makeRoot :: FilePath -> FilePath -> Bool -> IO FilePath
makeRoot repoRoot path withFormal = do
  createDirectoryIfMissing True (path </> "machine")
  when withFormal $ do
    ex <- doesDirectoryExist (path </> "formal")
    unless ex $ do
      _ <- readCreateProcessWithExitCode
             (proc "ln" ["-sfn", repoRoot </> "formal", path </> "formal"]) ""
      pure ()
  pure path

cacheFileCount :: FilePath -> IO Int
cacheFileCount root = do
  ex <- doesDirectoryExist (root </> kCertCacheDir)
  if not ex then pure 0 else length <$> listDirectory (root </> kCertCacheDir)

runSectionC :: FilePath -> FilePath -> IORef [String] -> IO [(Probe, String, [String])]
runSectionC repoRoot scratch admittedRef = do
  printf "== C. the environment attack ==\n"
  exe <- getExecutablePath
  base <- getEnvironment
  -- the real agda, resolved once, so the shim can delegate to it
  realAgda <- do
    (c, o, _) <- readCreateProcessWithExitCode (proc "sh" ["-c", "command -v agda"]) ""
    pure $ case c of
      ExitSuccess -> oneLine o
      _ -> "agda"
  let shimDir = scratch </> "shimbin"
      noAgdaDir = scratch </> "noagdabin"
  createDirectoryIfMissing True shimDir
  withFile (shimDir </> "agda") WriteMode $ \h -> hPutStr h (shimSource realAgda)
  p <- getPermissions (shimDir </> "agda")
  setPermissions (shimDir </> "agda") (setOwnerExecutable True p)
  -- "agda absent" must mean AGDA absent, not the whole environment absent: a
  -- PATH with no coreutils makes `mktemp` the thing that fails and tests
  -- nothing about the gate.  This directory holds everything the gate needs
  -- except agda.
  createDirectoryIfMissing True noAgdaDir
  forM_ ["mktemp", "sh", "cat", "env", "ln", "sleep", "rm"] $ \t -> do
    (c, o, _) <- readCreateProcessWithExitCode (proc "sh" ["-c", "command -v " ++ t]) ""
    when (c == ExitSuccess && not (null (oneLine o))) $ do
      _ <- readCreateProcessWithExitCode
             (proc "ln" ["-sfn", oneLine o, noAgdaDir </> t]) ""
      pure ()
  rs <- forM (zip [(0 :: Int) ..] probes) $ \(idx, pr) -> do
    root <- case prRootKind pr of
      "bare" -> makeRoot repoRoot (scratch </> "bare-root") False
      "poison" -> makeRoot repoRoot (scratch </> "poison-root") True
      "temp" -> makeRoot repoRoot (scratch </> ("temp-root-" ++ show idx)) True
      _ -> pure repoRoot
    before <- cacheFileCount root
    let path0 = fromMaybe "/usr/bin:/bin" (lookup "PATH" base)
        path' | prPathless pr = noAgdaDir
              | Just _ <- prShim pr = shimDir ++ ":" ++ path0
              | otherwise = path0
        mkEnv c = [ ("PATH", path')
                  , ("MATH_CERTCACHE", c)
                  , ("AUDIT_SHIM", fromMaybe "" (prShim pr))
                  , ("LC_ALL", "C.UTF-8")
                  , ("LANG", "C.UTF-8")
                  ]
                  ++ [ kv | kv@(k, _) <- base
                     , k `notElem` ["PATH", "MATH_CERTCACHE", "AUDIT_SHIM", "LC_ALL", "LANG"] ]
        kindArg = case prRootKind pr of
          "poison" -> "poison"
          "parse" -> "parse"
          _ -> "basic"
        cp = (proc "timeout"
                [ "-k", "3", show (prTimeout pr), exe, "--probe", kindArg, root ])
               { env = Just (mkEnv (prCache pr)) }
    (code, out, err) <- readCreateProcessWithExitCode cp ""
    after <- cacheFileCount root
    -- For the probes that ran with the cache live in a private root: does the
    -- fault OUTLIVE itself?  Re-ask the same question with the real agda back
    -- on PATH and the same cache directory.
    repaired <- if prRootKind pr /= "temp" then pure Nothing else do
      let cp2 = (proc "timeout" ["-k", "3", "300", exe, "--probe", "basic", root])
                  { env = Just (filter ((/= "AUDIT_SHIM") . fst)
                                  [ kv | kv <- mkEnv "1", fst kv /= "PATH" ]
                                ++ [("PATH", path0)]) }
      (_, o2, e2) <- readCreateProcessWithExitCode cp2 ""
      pure (Just [ l | l <- lines (o2 ++ "\n" ++ e2), "PROBE-FALSE" `isPrefixOf` l ])
    let ls = [ l | l <- lines (out ++ "\n" ++ err), "PROBE-" `isPrefixOf` l ]
        timedOut = code == ExitFailure 124 || code == ExitFailure 137
        summary
          | timedOut = "TIMED OUT after " ++ show (prTimeout pr) ++ "s (the gate has no timeout)"
          | null ls = "no verdict line; child exited " ++ show code
          | otherwise = intercalate " | " (map oneLine ls)
    printf "  %-19s %s\n" (prName pr) (prDesc pr)
    printf "      expected : %s\n" (prExpect pr)
    printf "      observed : %s\n" (clip 200 summary)
    when (prRootKind pr `elem` ["temp", "poison"]) $
      printf "      cache    : %d file(s) before, %d after\n" before after
    forM_ repaired $ \r ->
      printf "      after the environment is repaired (real agda, same cache): %s\n"
        (clip 120 (intercalate " | " (map oneLine r)))
    let certLines = [ l | l <- ls ++ concat repaired, "PROBE-FALSE CERTIFIED" `isPrefixOf` l ]
    unless (null certLines) $
      modifyIORef' admittedRef
        (("C/" ++ prName pr ++ "  a FALSE equation (s(x) = x) was CERTIFIED under: "
          ++ prDesc pr ++ "\n  " ++ intercalate "\n  " (map oneLine certLines)) :)
    pure (pr, summary, ls)
  putStrLn ""
  pure rs

-- ================================================================ section D
--
-- Integrity of the shipped cache.  Every entry claiming `accepted` is
-- re-checked by running agda on the SOURCE the entry itself stores.  An
-- entry whose source agda rejects is a poisoned or stale accept, and the
-- gate would serve it as `Certified` with zero agda invocations.

runSectionD :: FilePath -> IO (Int, Int, Int)
runSectionD root = do
  printf "== D. integrity of the shipped certificate cache ==\n"
  let dir = root </> kCertCacheDir
  present <- doesDirectoryExist dir
  if not present
    then printf "  %s does not exist; nothing to audit\n\n" dir >> pure (0, 0, 0)
    else do
      names <- sort <$> listDirectory dir
      entries <- forM names $ \nm -> do
        isf <- doesFileExist (dir </> nm)
        if not isf then pure Nothing else do
          txt <- withFile (dir </> nm) ReadMode $ \h -> do
            hSetEncoding h utf8
            s <- hGetContents h
            length s `seq` pure s
          pure (Just (nm, txt))
      let parsed = [ (nm, txt) | Just (nm, txt) <- entries ]
          accepted = [ (nm, src) | (nm, txt) <- parsed
                     , "VERDICT accepted" `elem` lines txt
                     , Just src <- [entrySource txt] ]
      printf "  entries: %d, of which claim accepted: %d\n" (length parsed) (length accepted)
      bad <- forM accepted $ \(nm, src) -> do
        (code, out) <- runAgda root src
        case code of
          ExitSuccess -> pure Nothing
          ExitFailure _ -> do
            printf "  MISMATCH %s: stored accept, agda says %s\n" nm (clip 70 out)
            pure (Just nm)
      let nbad = length [ () | Just _ <- bad ]
      printf "  re-checked %d accepted entries, %d disagree with agda\n\n"
        (length accepted) nbad
      pure (length parsed, length accepted, nbad)

-- Pull the SOURCE block back out of a stored entry (the format `block`
-- writes: "SOURCE <n> <nl|nonl>" then n lines).
entrySource :: String -> Maybe String
entrySource txt = go (lines txt)
  where
    go [] = Nothing
    go (l : more)
      | "SOURCE " `isPrefixOf` l = case words (drop 7 l) of
          [nS, flag] | [(n, "")] <- reads nS ->
            let body = take n more
            in if length body /= n then Nothing
               else Just (if flag == "nl" then unlines body else intercalate "\n" body)
          _ -> Nothing
      | otherwise = go more

-- ==================================================================== main

data Opts = Opts
  { oRoot :: FilePath
  , oSections :: String
  , oSlice :: (Int, Int)
  , oScratch :: FilePath
  }

defaultOpts :: Opts
defaultOpts = Opts "." "abc" (0, 1) "/tmp/gate-audit-scratch"

parseOpts :: [String] -> Opts -> Opts
parseOpts [] o = o
parseOpts ("--sections" : s : more) o = parseOpts more o { oSections = s }
parseOpts ("--scratch" : s : more) o = parseOpts more o { oScratch = s }
parseOpts ("--slice" : s : more) o =
  case break (== '/') s of
    (a, '/' : b) | [(k, "")] <- reads a, [(m, "")] <- reads b, m > 0 ->
      parseOpts more o { oSlice = (k, m) }
    _ -> parseOpts more o
parseOpts (a : more) o
  | "--" `isPrefixOf` a = parseOpts more o
  | otherwise = parseOpts more o { oRoot = a }

main :: IO ()
main = do
  -- agda's diagnostics contain ℕ and ≡, and the pipes of every child this
  -- module spawns are decoded with the process locale encoding; under LANG=C
  -- that throws before any verdict is read.  Same fault as Certificate's
  -- fault (2), on the audit's side of the fence.
  setLocaleEncoding utf8
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8
  hSetBuffering stdout LineBuffering
  argv <- getArgs
  case argv of
    ("--probe" : kind : root : _) -> probeMain kind root
    _ -> auditMain (parseOpts argv defaultOpts)

auditMain :: Opts -> IO ()
auditMain o = do
  let root = oRoot o
  printf "GateAudit — hostile audit of Certificate.hs's Agda kernel gate\n"
  printf "repository root %s ; sections %s ; slice %d/%d\n"
    (show root) (show (oSections o)) (fst (oSlice o)) (snd (oSlice o))
  printf "budget per candidate: %d agda calls (kMaxAgdaCalls)\n" kMaxAgdaCalls
  cacheOn <- cacheEnabled
  printf "certificate cache for sections A and B: %s\n\n"
    (if cacheOn then "ON — rerun with MATH_CERTCACHE=0 for a cold audit" else "OFF")
  admitted <- newIORef []
  aRes <- if 'a' `elem` oSections o
            then Just <$> runSectionA root (oSlice o) admitted
            else pure Nothing
  bRes <- if 'b' `elem` oSections o
            then Just <$> runSectionB root admitted
            else pure Nothing
  cRes <- if 'c' `elem` oSections o
            then do createDirectoryIfMissing True (oScratch o)
                    Just <$> runSectionC root (oScratch o) admitted
            else pure Nothing
  dRes <- if 'd' `elem` oSections o then Just <$> runSectionD root else pure Nothing
  putStrLn "== summary =="
  forM_ aRes $ \(nc, nr, nu, ne) ->
    printf "  A systematic falsehoods : %d certified, %d rejected, %d untranslatable, %d exceptions\n"
      nc nr nu ne
  forM_ bRes $ \rs -> do
    let ctl = [ (c, v) | (c, v) <- rs, cKind c == "control" ]
        eng = [ (c, v) | (c, v) <- rs, cKind c == "engine" ]
        gat = [ (c, v) | (c, v) <- rs, cKind c == "gate" ]
    printf "  B controls              : %d/%d certified (must be %d)\n"
      (length (filter (isCert . snd) ctl)) (length ctl) (length ctl)
    printf "  B engine-stage probes   : %d/%d certified (the GATE must reject all)\n"
      (length (filter (isCert . snd) eng)) (length eng)
    printf "  B gate probes           : %d/%d certified\n"
      (length (filter (isCert . snd) gat)) (length gat)
  forM_ cRes $ \rs ->
    forM_ rs $ \(pr, summary, _) ->
      printf "  C %-16s: %s\n" (prName pr) (clip 96 summary)
  forM_ dRes $ \(n, a, bad) ->
    printf "  D cache                 : %d entries, %d accepted, %d disagree with agda\n" n a bad
  bad <- reverse <$> readIORef admitted
  putStrLn ""
  if null bad
    then do
      putStrLn "NO FALSEHOOD WAS CERTIFIED in any section run here."
      exitSuccess
    else do
      printf "UNSOUND: %d admitted falsehood(s)\n\n" (length bad)
      mapM_ (\s -> putStrLn s >> putStrLn "") bad
      exitFailure
