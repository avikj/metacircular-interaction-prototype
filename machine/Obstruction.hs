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
  , selfTest
  ) where

import Data.Char (isDigit, isSpace, isAlpha)
import Data.List (isPrefixOf, foldl')

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
    mapM_ report checks
    pure (all (\(_, ok, _, _) -> ok) checks)
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
