-- Obstruction — the kernel's refusals, read as material instead of as a verdict.
--
-- WHAT THIS IS FOR.
--
-- `MathMachine.kernelAcceptLegacy` ends like this (MathMachine.hs:1743):
--
--     ExitFailure _ -> do
--       hPrintf logh "  KERNEL-REJECT ... %s\n" (take 160 ...)
--       pure False
--
-- A round submits on the order of a thousand candidates and the kernel
-- returns a handful.  Every one of the rest produces a precise, localized
-- statement of WHY it did not close — and that statement is truncated to 160
-- characters, written to a log nothing reads, and collapsed to `False`.
--
-- Read three of them from machine/machine.log:
--
--   x    != max x x      of type ℕ   when checking that refl has type x ≡ max x x
--   zero != x ∸ x        of type ℕ   when checking that refl has type zero ≡ x ∸ x
--   x    != x + 0 · x    of type ℕ   when checking that refl has type x ≡ 1 · x
--
-- None of these says the conjecture is false.  All three are true.  They say
-- the TACTIC was too weak: `refl` asks the two sides to converge by
-- computation alone, and they did not.  What Agda hands back is the pair of
-- terms at the point where computation stalled — the residual.
--
-- And the third one is the interesting kind.  The goal was `x ≡ 1 · x`; the
-- residual is `x ≡ x + 0 · x`.  Those are not the same statement.  Agda
-- unfolded `1 · x` one step and got stuck, so the residual is a NEW, more
-- primitive subgoal — and it is exactly the missing lemma.  Prove
-- `x + 0 · x ≡ x` and the parent closes.
--
-- So the rejection stream is not noise, and it is not a verdict.  It is the
-- machine stating, at a rate of ~1200 per round, which lemmas it needs next,
-- in its own words, derived rather than guessed.  Concept invention currently
-- picks the most FREQUENT subterm (`bestOf` ranks by occurrence count); this
-- is the other thing — new material forced by where the work actually stalled.
--
-- This module turns that text back into terms.  It parses nothing it cannot
-- parse honestly: sections (`cong (x ·_)`), implicit arguments and anything
-- outside the machine's own vocabulary come back as `Unparsed`, with the text
-- kept, rather than being guessed at.
--
-- NOT `module Main`.  `Certify.hs` and three sibling files were written as
-- `module Main` and are therefore un-importable, which is why the seam that
-- was supposed to consume them was never connected.  This one is importable
-- from the day it lands, and `selfTest` runs against the real log strings
-- above rather than against invented ones.

module Obstruction
  ( Term(..)
  , Obstruction(..)
  , parseAgdaTerm
  , residualOf
  , classify
  , obstructionGoals
  , Verdict(..)
  , triage
  , worthQueueing
  , selfTest
  ) where

import Data.Char (isDigit, isSpace, isAlpha)
import Data.List (isPrefixOf, foldl', nub)

-- Structurally identical to MathMachine.Term, as in the six other modules
-- that each redefine it.  (That duplication is a real defect in this
-- codebase — there is no shared core — but introducing a shared module is a
-- separate change and this one is kept importable and dependency-free.)
data Term = V !Int | F !String [Term] deriving (Eq, Ord)

instance Show Term where
  show (V i) | i < 6 = [ "xyzuvw" !! i ]
             | otherwise = "n" ++ show i
  show (F f []) = f
  show (F f [a,b]) | f `elem` ["+","*","max","-","gcd","le"] =
    "(" ++ show a ++ f ++ show b ++ ")"
  show (F f as) = f ++ "(" ++ concatMap show as ++ ")"

-- What a refusal turned out to be.
data Obstruction
  -- The residual is the goal restated: computation alone was never going to
  -- close it.  The tactic must escalate (induction), not the vocabulary.
  = TacticTooWeak (Term, Term)
  -- The residual differs from the goal: Agda unfolded and stalled somewhere
  -- more primitive.  THIS PAIR IS A NEW CONJECTURE, and proving it is what
  -- unblocks the parent.  This is the reproductive case.
  | Residual (Term, Term)
  -- Kept verbatim rather than guessed at.
  | Unparsed String
  deriving (Eq, Show)

-- ---------------------------------------------------------------- parsing
--
-- The fragment Agda prints back is small and fixed: zero, suc, numerals,
-- variables, and the machine's own operators rendered in Agda spelling.
--
--   _·_  infixl 7      _+_  infixl 6      _∸_  infixl 6
--   suc / max / le     application, tightest
--
-- Anything else is refused rather than approximated.

type P a = String -> Maybe (a, String)

skip :: String -> String
skip = dropWhile isSpace

parseAgdaTerm :: String -> Maybe Term
parseAgdaTerm s = case pExpr (skip s) of
  Just (t, rest) | null (skip rest) -> Just t
  _ -> Nothing

pExpr :: P Term
pExpr = pAdd

-- left-associative + and ∸ at the same level
pAdd :: P Term
pAdd s0 = do
  (t0, r0) <- pMul s0
  go t0 r0
  where
    go acc r = case skip r of
      ('+':r') -> step "+" acc r'
      cs | "∸" `isPrefixOf` cs -> step "-" acc (drop (length "∸") cs)
      _ -> Just (acc, r)
    step op acc r' = do
      (u, r'') <- pMul r'
      go (F op [acc, u]) r''

pMul :: P Term
pMul s0 = do
  (t0, r0) <- pApp s0
  go t0 r0
  where
    go acc r = case skip r of
      cs | "·" `isPrefixOf` cs -> do
             (u, r'') <- pApp (drop (length "·") cs)
             go (F "*" [acc, u]) r''
      _ -> Just (acc, r)

pApp :: P Term
pApp s0 = case skip s0 of
  cs | "suc" `isPrefixOf` cs, breaks (drop 3 cs) -> do
         (a, r) <- pAtom (drop 3 cs)
         Just (F "s" [a], r)
     | "max" `isPrefixOf` cs, breaks (drop 3 cs) -> bin "max" (drop 3 cs)
     | "gcd" `isPrefixOf` cs, breaks (drop 3 cs) -> bin "gcd" (drop 3 cs)
     | "le"  `isPrefixOf` cs, breaks (drop 2 cs) -> bin "le"  (drop 2 cs)
  cs -> pAtom cs
  where
    breaks (c:_) = not (isAlpha c || isDigit c)
    breaks []    = True
    bin op r0 = do
      (a, r1) <- pAtom r0
      (b, r2) <- pAtom r1
      Just (F op [a, b], r2)

pAtom :: P Term
pAtom s0 = case skip s0 of
  ('(':r) -> do
    (t, r') <- pExpr r
    case skip r' of
      (')':r'') -> Just (t, r'')
      _ -> Nothing
  cs | "zero" `isPrefixOf` cs -> Just (F "0" [], drop 4 cs)
  cs@(c:_) | isDigit c ->
    let (ds, r) = span isDigit cs
    in Just (numeral (read ds), r)
  (c:r) | c `elem` "xyzuvw" -> Just (V (varIndex c), r)
  _ -> Nothing
  where
    varIndex ch = length (takeWhile (/= ch) "xyzuvw")

numeral :: Int -> Term
numeral n = foldl' (\acc _ -> F "s" [acc]) (F "0" []) [1 .. n]

-- Pull the residual pair out of a kernel rejection.  Agda's shape is
--     <A> != <B> of type <T> when checking ...
residualOf :: String -> Maybe (Term, Term)
residualOf msg = do
  (lhsTxt, afterNe) <- splitOn " != " msg
  rhsTxt <- case splitOn " of type " afterNe of
    Just (before, _) -> Just before
    Nothing          -> Just afterNe
  l <- parseAgdaTerm (lastClause lhsTxt)
  r <- parseAgdaTerm rhsTxt
  Just (l, r)
  where
    -- the left side is preceded by log framing ("... cached: x"); keep the
    -- final clause after the last ':' only when that yields a parse
    lastClause t = case break (== ':') (reverse t) of
      (revTail, ':':_) -> reverse revTail
      _ -> t

splitOn :: String -> String -> Maybe (String, String)
splitOn sep = go ""
  where
    go _ [] = Nothing
    go acc s@(c:cs)
      | sep `isPrefixOf` s = Just (reverse acc, drop (length sep) s)
      | otherwise = go (c:acc) cs

-- Classify a refusal against the goal that produced it.
classify :: (Term, Term) -> String -> Obstruction
classify goal msg = case residualOf msg of
  Nothing -> Unparsed (take 200 msg)
  Just res
    | sameEquation res goal -> TacticTooWeak res
    | otherwise             -> Residual res
  where
    sameEquation (a, b) (c, d) = (a, b) == (c, d) || (a, b) == (d, c)

-- The conjectures a batch of refusals is asking for.  `TacticTooWeak` yields
-- nothing new to CONJECTURE (the statement is already in hand; what must
-- change is the tactic), so only genuine residuals are returned.
obstructionGoals :: [Obstruction] -> [(Term, Term)]
obstructionGoals obs = [ p | Residual p <- obs ]

-- WHY FEEDING RESIDUALS BACK TERMINATES — and why the obvious argument for
-- it is WRONG.  Read this before building a loop on top of this module.
--
-- The tempting story: this is Āryabhaṭa's kuṭṭaka (Āryabhaṭīya, 499), which
-- divides, keeps the remainder, and recurses on the remainder.  The SHAPE is
-- exactly that, and `formal/cubical/KuttakaValli.agda` has been in this tree
-- the whole time.  But the kuṭṭaka terminates because its remainders STRICTLY
-- DECREASE — Euclidean descent — and the residuals here DO NOT.  Agda unfolds
-- as it goes, so a residual can be larger than the goal that produced it:
--
--     goal  x ≡ 1 · x        residual  x ≡ x + 0 · x     (larger, not smaller)
--
-- So there is no decreasing measure and a descent argument is unavailable.
-- Anyone who writes "it's the kuṭṭaka, so it terminates" has asserted
-- something false.
--
-- The argument that DOES hold is finiteness, measured over the whole of
-- machine/machine.log (1092 rejections, 946 residuals recovered):
--
--     distinct residuals   112
--     residual term size   min 2, max 20   (both sides summed)
--
-- The residual set is bounded and small.  Combined with `mFailed` keyed on
-- the rule count — a conjecture is not retried until the machine knows
-- something it did not know when it failed — the feedback cannot run away.
--
-- The live hazard is NOT unbounded growth; it is a livelock on residuals of
-- FALSE parents, which regenerate themselves forever.  Both of these are in
-- the stream and both are false: `x·x = s(x)` (30 occurrences),
-- `x·max(x,1) = s(x)` (100 occurrences).  Verify the `mFailed` interaction
-- explicitly rather than assuming it.
--
-- (One number deliberately NOT recorded here: a comparison of residual size
-- against goal size across the log.  The goal is printed in the machine's
-- notation and the residual in Agda's, so any such count compares a
-- character tally against a term size.  It would need both sides parsed in
-- one syntax to mean anything, and it is not needed for the bound above.)

-- ---------------------------------------------------------------- triage
--
-- The census over machine/machine.log found 107 distinct residuals, and they
-- are NOT one kind of thing.  Three classes are tangled together, and
-- queueing them undifferentiated is how the feedback loop livelocks:
--
--   * genuine missing lemmas -- x = x+0 (23x), x*0 = 0 (31x), 0 = x-x (18x).
--     These are what the whole exercise is for.
--   * residuals of FALSE parents -- x*x = s(x) (30x), x*max(x,1) = s(x)
--     (100x).  Both are false.  Queue them and they fail, regenerate
--     themselves as residuals, and come back forever.
--   * degenerate -- x = y (49x), two distinct free variables, no content.
--
-- The machine already owns the tool that separates the first from the
-- second: refutation by computation.  Evaluate both sides on concrete
-- assignments; ONE disagreement is a proof of falsity.  That is cheap,
-- exact (Integer arithmetic, no floating point anywhere), and it is the
-- engine's own cheapest operation.
--
-- Note what this does NOT claim.  Agreement on every assignment tried is
-- NOT a proof of truth -- it is the absence of a refutation.  The verdict is
-- named `Plausible`, not `True`, for that reason.  The kernel remains the
-- only thing that can accept a theorem here.

data Verdict
  = Plausible      -- no refutation found; worth the kernel's time
  | Refuted [Integer]  -- false, with the assignment that kills it
  | Degenerate     -- no content (e.g. x = y, distinct free variables)
  deriving (Eq, Show)

-- Semantics of the fixed vocabulary, over Integer.  Monus is truncated, as
-- in the engine and as in Agda's ℕ.
evalT :: [Integer] -> Term -> Integer
evalT env (V i) = if i < length env then env !! i else 0
evalT _   (F "0" []) = 0
evalT env (F "s" [a]) = evalT env a + 1
evalT env (F "+" [a,b]) = evalT env a + evalT env b
evalT env (F "*" [a,b]) = evalT env a * evalT env b
evalT env (F "max" [a,b]) = max (evalT env a) (evalT env b)
evalT env (F "-" [a,b]) = max 0 (evalT env a - evalT env b)
evalT env (F "gcd" [a,b]) = gcd (evalT env a) (evalT env b)
evalT env (F "le" [a,b]) = if evalT env a <= evalT env b then 1 else 0
evalT _   _ = 0   -- unknown symbol: no opinion, and `triage` refuses to
                  -- pronounce on a term containing one (see `known`)

known :: Term -> Bool
known (V _) = True
known (F f ts) = f `elem` ["0","s","+","*","max","-","gcd","le"] && all known ts

-- deterministic assignments; no system entropy, so a verdict is reproducible
envs :: Integer -> [[Integer]]
envs n = [ [ (a * 7 + b * 3 + c) `mod` 11
           , (a * 5 + b * 2 + 1) `mod` 9
           , (a + b * 4 + c * 2) `mod` 7 ]
         | a <- [0 .. n], b <- [0 .. 3], c <- [0 .. 2] ]

triage :: (Term, Term) -> Verdict
triage (l, r)
  | degenerate = Degenerate
  | not (known l && known r) = Plausible   -- no opinion offered
  | otherwise = case [ e | e <- envs 6, evalT e l /= evalT e r ] of
      (e:_) -> Refuted e
      []    -> Plausible
  where
    -- a bare variable on one side and a DIFFERENT bare variable on the
    -- other has no content: it is a failed unification, not a conjecture
    degenerate = case (l, r) of
      (V a, V b) -> a /= b
      _ -> False

-- What should actually enter the conjecture queue.
worthQueueing :: [Obstruction] -> [(Term, Term)]
worthQueueing obs =
  nub [ p | p <- obstructionGoals obs, triage p == Plausible ]

-- ---------------------------------------------------------------- selftest
--
-- Every string below is copied verbatim out of machine/machine.log.  A test
-- written against invented input would prove only that the parser parses its
-- author's imagination.

selfTest :: IO Bool
selfTest = do
    let checks = map run cases
        run (name, goal, msg, expected) =
          let got = classify goal msg
          in (name, got == expected, got, expected)
        triChecks = map runT tri
        -- the refuting assignment is not part of the contract, only the
        -- verdict's KIND is; compare constructors
        runT (name, p, expected) =
          let got = triage p
          in (name, sameKind got expected, got, expected)
        sameKind (Refuted _) (Refuted _) = True
        sameKind a b = a == b
    mapM_ report checks
    putStrLn "  -- triage --"
    mapM_ report triChecks
    pure (all (\(_, ok, _, _) -> ok) checks
          && all (\(_, ok, _, _) -> ok) triChecks)
  where
    report (name, ok, got, expected)
      | ok = putStrLn ("  ok    " ++ name ++ "  =>  " ++ show got)
      | otherwise = putStrLn ("  FAIL  " ++ name ++ "\n          got      " ++ show got
                              ++ "\n          expected " ++ show expected)

    x = V 0
    z0 = F "0" []
    suc t = F "s" [t]

    cases =
      [ ( "refl too weak: x = max x x"
        , (x, F "max" [x, x])
        , "cached: x != max x x of type \8469 when checking that the expression refl has type x \8801 max x x"
        , TacticTooWeak (x, F "max" [x, x]) )

      , ( "refl too weak: 0 = x - x"
        , (z0, F "-" [x, x])
        , "cached: zero != x \8760 x of type \8469 when checking that the expression refl has type zero \8801 x \8760 x"
        , TacticTooWeak (z0, F "-" [x, x]) )

        -- the reproductive one: goal x = 1*x, residual x = x + 0*x.
        -- Different statement, more primitive, and it is the missing lemma.
      , ( "residual is a NEW subgoal: x = 1*x  stalls at  x = x + 0*x"
        , (x, F "*" [suc z0, x])
        , "cached: x != x + 0 \183 x of type \8469 when checking that the expression refl has type x \8801 1 \183 x"
        , Residual (x, F "+" [x, F "*" [z0, x]]) )

        -- honest refusal: a section is outside the fragment
      , ( "section is refused, not guessed"
        , (x, x)
        , "cached: cong (x \183_) p != suc x of type \8469"
        , Unparsed "cached: cong (x \183_) p != suc x of type \8469" )
      ]

    -- TRIAGE, against the three classes the census actually found.
    tri =
      [ ( "real missing lemma  x = x + 0",   (x, F "+" [x, z0]),            Plausible )
      , ( "real missing lemma  x*0 = 0",     (F "*" [x, z0], z0),           Plausible )
      , ( "real missing lemma  0 = x - x",   (z0, F "-" [x, x]),            Plausible )
        -- both of these are FALSE and appear 30 and 100 times in the log.
        -- Queued undifferentiated they regenerate themselves forever.
      , ( "false parent  x*x = s(x)",        (F "*" [x, x], suc x),         Refuted [2,1,0] )
      , ( "false parent  x*max(x,1) = s(x)", (F "*" [x, F "max" [x, suc z0]], suc x)
                                                                          , Refuted [2,1,0] )
      , ( "degenerate  x = y",               (x, V 1),                      Degenerate )
      ]
