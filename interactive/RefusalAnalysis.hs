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
-- Read three of them from interactive/machine.log:
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

module RefusalAnalysis
  ( Term(..)
  , Obstruction(..)
  , parseAgdaTerm
  , residualOf
  , classify
  , obstructionGoals
  , Verdict(..)
  , triage
  , Pravesha(..)
  , pravesha
  , worthQueueing
  , goalOfRejectLine
  , claimOfAcceptLine
  , tacticOfAcceptLine
  , curriculum
    -- the saptabhaṅgī layer (see THE SEVENFOLD POSITIONS below)
  , Naya(..)
  , Bhanga(..)
  , Sthana(..)
  , Evidence(..)
  , evidenceOfReject
  , sthana
  , showClaim
  , acceptedClaims
  , census
  , crossTab
  , VerdictKind(..)
  , verdictKind
  , censusReport
  , lookupAffirm
  , knownSymbols
    -- the evaluator, exported 2026-08-20 so Nirnaya_NoVerdictWithoutItsWitness
    -- can VERIFY a witness instead of redefining the semantics it verifies
    -- against.  Two copies of `evalT` would let a refutation be true under
    -- one and false under the other, which is the same defect one layer out.
  , evalT
  , envs
  , symbolsIn
  , selfTest
  ) where

import Data.Char (isDigit, isSpace, isAlpha)
import Data.List (isPrefixOf, isInfixOf, foldl', nub, sort, sortOn)

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
--
-- STANDPOINT.  Every constructor below is a report of ONE naya, the
-- `KernelRefl` standpoint — Agda's definitional equality with `refl` as the
-- whole tactic.  That was true when this type was written and it was
-- nowhere said, which is precisely the durnaya described under THE SEVENFOLD
-- POSITIONS: a partial view that has dropped its index and reads as the
-- verdict.  The index is now carried explicitly by `Evidence`, and this type
-- is one of its three fields.
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
-- interactive/machine.log.
--
-- FIGURES RE-MEASURED 2026-08-18 by `interactive/ObstructionCensus.hs`.  The log
-- has grown since they were first written and two of them were stale; both
-- are corrected here rather than left standing, and the originals are kept
-- so the drift is visible:
--
--     rejections           1457     (was recorded as 1092)
--     residuals recovered  1303     (was recorded as  946)
--     distinct residuals    112     unchanged -- and this is the number the
--                                   finiteness argument actually rests on,
--                                   so the argument is unaffected
--     residual term size   min 2, max 20   (both sides summed; not re-measured)
--
-- That the first two grew by a third while the third did not move is itself
-- the finiteness claim being confirmed on new data.
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
-- The census over interactive/machine.log found 112 distinct residuals ("107"
-- stood here until 2026-08-18 and disagreed with the header's 112 on the
-- same log; 112 is the re-measured figure), and they are NOT one kind of
-- thing.  Three classes are tangled together, and
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
-- NOT a proof of truth -- it is the absence of a refutation OVER THE
-- ASSIGNMENTS TRIED.  The verdict is `Aviruddha` ("unrefuted"), never `True`,
-- and it carries the domain it searched, because "unrefuted" without an
-- extent is not a weaker claim than "true", it is an unfalsifiable one.  The
-- kernel remains the only thing that can accept a theorem here.

-- STANDPOINT.  This is the report of the `Rewriter` naya — the machine's own
-- evaluation over Integer.  It is not commensurable with `Obstruction`
-- above, and the fact that the two were previously compared as if they were
-- is what `Evidence` fixes.
-- क्वापि न शून्यबोधः — nowhere a bare truth-value.  Renamed and re-typed
-- 2026-08-18 after reading `formal/cubical/Anekanta.agda`, which does this
-- properly: नकारः खण्डनं ददाति, स्वीकारः साक्षिणम् ।  Previously three of the
-- four constructors were bare labels, which is the durnaya this whole file
-- exists to remove — a verdict carrying no evidence of why it is the verdict.
-- Sanskrit names because the English shadow of each ("plausible", "silent")
-- drifts back toward a truth value within one refactor; these have no such
-- shadow to drift into.
data Verdict
  = Aviruddha [[Integer]]   -- अविरुद्ध — unrefuted, CARRYING THE DOMAIN
                   -- SEARCHED.  Not "true": the absence of a refutation over
                   -- a stated extent, which is the yogya condition and is
                   -- meaningless without the extent.
  | Khandita [Integer]  -- खण्डित — refuted, with the assignment that kills it.
                   -- A refutation is exact: one disagreement is a proof.
  | Nirdharmin (Int, Int)  -- निर्धर्मिन् — no subject to predicate of, carrying
                   -- WHICH two distinct variables made it subjectless.
  | Tusnim String  -- तूष्णीम् — this naya declines to speak, carrying the
                   -- symbol outside its semantics that silenced it.  SPLIT OUT
                   -- 2026-08-18.  Previously this returned `Plausible` with
                   -- the comment "no opinion offered" — i.e. silence and
                   -- affirmation were the same constructor, which is the same
                   -- boolean collapse this module was written to undo, one
                   -- level down.  `queueable` preserves the old BEHAVIOUR
                   -- exactly (both are queued) while separating the two
                   -- INFORMATIONALLY, so every number this file documents
                   -- still holds.
  -- Ord is derived only so census output has a canonical order; the
  -- ordering has no semantic content and nothing reads it as a ranking.
  deriving (Eq, Ord)

-- THE WITNESS IS IN THE VALUE; THE DISPLAY SUMMARISES IT.  A derived Show
-- prints all 84 assignments of an aviruddha's domain on one line, which makes
-- every log line unreadable and — worse — makes the next author delete the
-- field to get the output back.  So the domain prints as its EXTENT, which is
-- the part a reader is actually judging ("unrefuted over what?"), with its
-- first point named so the extent is not an unfalsifiable number.  The
-- pointed witnesses print whole: they are one assignment, one symbol, one
-- pair, and each is short and is the entire content of its verdict.
instance Show Verdict where
  show (Aviruddha [])     = "Aviruddha over NOTHING"
  show (Aviruddha d)      = "Aviruddha over " ++ show (length d)
                            ++ " assignments from " ++ show (head d)
  show (Khandita e)       = "Khandita at " ++ show e
  show (Nirdharmin (a,b)) = "Nirdharmin " ++ show (a, b)
  show (Tusnim s)         = "Tusnim on " ++ show s

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

-- every function symbol occurring in a term, outermost first.  `known` and
-- `triage`'s silence branch both read the SAME list, so a symbol can never be
-- evaluable-but-alien or alien-but-evaluable.
symbolsIn :: Term -> [String]
symbolsIn (V _) = []
symbolsIn (F f ts) = f : concatMap symbolsIn ts

known :: Term -> Bool
known t = all (`elem` knownSymbols) (symbolsIn t)

-- Deterministic assignments; no system entropy, so a verdict is
-- reproducible.  84 of them.
--
-- THE CONSTANT IS VALIDATED, not guessed.  `CLAUDE.md` forbids leaving a
-- number unjustified, so: the 78 residuals that survive this filter were
-- re-tested against an EXHAUSTIVE sweep of 0..12 in three variables —
-- 13³ = 2197 assignments, 28× more work — and **all 78 survived that too.
-- Zero false positives.**  So the cheap filter is as strong as the
-- exhaustive one on this data, and paying 2197 evaluations per residual in
-- the engine's hot loop would buy nothing.  If the vocabulary is extended
-- (PairVocab, CyclotomicVocab) this should be re-validated, because the
-- result is a fact about these eight symbols and not a theorem.
envs :: Integer -> [[Integer]]
envs n = [ [ (a * 7 + b * 3 + c) `mod` 11
           , (a * 5 + b * 2 + 1) `mod` 9
           , (a + b * 4 + c * 2) `mod` 7 ]
         | a <- [0 .. n], b <- [0 .. 3], c <- [0 .. 2] ]

-- नकारः खण्डनं ददाति, स्वीकारः साक्षिणम् — क्वापि न शून्यबोधः ।
-- Negation yields a refutation, acceptance yields a witness, nowhere a bare
-- truth-value.  Every branch below hands back the evidence that put it there.
triage :: (Term, Term) -> Verdict
triage (l, r)
  | Just vs <- degenerate = Nirdharmin vs
  | Just s  <- alien l    = Tusnim s
  | Just s  <- alien r    = Tusnim s
  | otherwise = case [ e | e <- searched, evalT e l /= evalT e r ] of
      (e:_) -> Khandita e
      -- अविरुद्ध carries the domain actually searched.  That is the yogya
      -- condition: "unrefuted" is meaningless without saying over what.
      []    -> Aviruddha searched
  where
    searched = envs 6
    -- a bare variable on one side and a DIFFERENT bare variable on the other
    -- has no dharmin to predicate of: it is a failed unification, not a
    -- conjecture.  Carry WHICH two, so the verdict states its own reason.
    degenerate = case (l, r) of
      (V a, V b) | a /= b -> Just (a, b)
      _ -> Nothing
    -- and silence names the symbol that silenced it
    alien t = case [ f | f <- symbolsIn t, f `notElem` knownSymbols ] of
      (f:_) -> Just f
      []    -> Nothing

knownSymbols :: [String]
knownSymbols = ["0","s","+","*","max","-","gcd","le"]

-- अहिंसा.  एकान्तः हिंसा — one-sidedness is violence, and this was the last
-- place in the module where a decision was made one-sidedly.
--
-- `queueable :: Verdict -> Bool` stood here.  Every constructor of `Verdict`
-- had just been given a mandatory witness so that no verdict could be stated
-- without its evidence — and then this function took the witnessed verdict and
-- answered `True`.  A bare label again, one layer further out, in the function
-- that actually decides what the machine does next.  It was written the same
-- morning as the fix, by the hand doing the fixing, and its commit message
-- offered it as proof of rigour.
--
-- The Jain point is not that booleans are inelegant.  It is that asserting a
-- naya without its standpoint does violence to the object: the thing queued
-- and the thing dropped both arrive downstream stripped of why, and nothing
-- downstream can ask.  So entry is a statement WITH ITS GROUND on both sides.
-- नकारः खण्डनं ददाति, स्वीकारः साक्षिणम् applies to admission exactly as it
-- applies to judgement.
data Pravesha
  = Pravishati Verdict  -- प्रविशति — it enters, carried in by THIS verdict
  | Nivartate  Verdict  -- निवर्तते — it turns back, turned by THIS verdict
  deriving (Eq)

instance Show Pravesha where
  show (Pravishati v) = "enters on " ++ show v
  show (Nivartate  v) = "turns back on " ++ show v

-- The extension is unchanged: aviruddha and tusnim entered before the split
-- (both were `Plausible`) and enter now, khandita and nirdharmin turned back
-- and turn back now.  What is gone is the ability to receive the decision
-- without receiving its ground.
pravesha :: Verdict -> Pravesha
pravesha v@(Aviruddha _)  = Pravishati v
pravesha v@(Tusnim _)     = Pravishati v
pravesha v@(Khandita _)   = Nivartate v
pravesha v@(Nirdharmin _) = Nivartate v

-- DELIBERATELY ABSENT: `entered :: Pravesha -> Bool`.  A one-line helper of
-- that shape restores the durnaya for every caller at once and reads as a
-- convenience while doing it.  Callers match, and in matching they hold the
-- reason.  There are three of them; it costs each of them one line.

-- What should actually enter the conjecture queue.
worthQueueing :: [Obstruction] -> [(Term, Term)]
worthQueueing obs =
  nub [ p | p <- obstructionGoals obs
          , Pravishati _ <- [pravesha (triage p)] ]

-- ---------------------------------------------------------------- curriculum
--
-- A KERNEL-REJECT line carries BOTH the goal (in the machine's notation) and
-- the residual (in Agda's).  So the log is a bipartite graph goal → residual,
-- and the honest ranking of "what should I prove first" is not the raw
-- occurrence count — which over-weights a goal retried across many rounds —
-- but: HOW MANY DISTINCT PARENT GOALS WOULD THIS ONE LEMMA UNBLOCK.
--
-- Measured over interactive/machine.log (re-measured 2026-08-18, all three
-- unchanged; the first is disambiguated because the raw count of distinct
-- goals on rejection lines is 238 and a reader could take "130" for that):
--
--     distinct stalled goals        130   -- goals with a QUEUEABLE residual
--     distinct lemmas demanded       78
--     top 8 lemmas unblock           54 of the 130
--
-- WHAT THE TOP OF THAT LIST MEANS, which is the real finding.  It reads:
--
--     unblocks 14   0 = y·0
--     unblocks 11   x·le(x,0) = 0
--     unblocks  8   x·0 = 0
--     unblocks  5   x = x+0
--
-- The machine ALREADY HAS `x·0 = 0`.  It is a defining equation of `*` in
-- its own vocabulary (`symDefs`).  It is demanding something it knows.
--
-- The reason is that Agda's `_·_` on ℕ recurses on the other argument, so
-- `x · 0` is not definitionally `0` there — it needs induction — while the
-- machine's rewriter discharges it immediately.  So the residual stream is
-- not really a list of things the machine does not know.  It is a
-- measurement of the IMPEDANCE MISMATCH between the machine's rewriting and
-- Agda's definitional equality, and this curriculum is exactly the set of
-- bridging lemmas that would close it.
--
-- That reframes the payoff.  Proving these 78 does not teach the machine new
-- mathematics; it teaches the machine's OUTPUT to survive contact with the
-- kernel — which is the thing that has been capping accepted theorems all
-- along.

-- Recover the goal from a KERNEL-REJECT line.  Cutting at the first '(' is
-- wrong: goals contain parens, and `x = (xmaxx)` would collapse to `x = `,
-- reading 130 distinct goals as 11.  The goal ends at the "  (N agda calls)"
-- framing.
goalOfRejectLine :: String -> String
goalOfRejectLine l =
    let afterRound = drop 1 (dropWhile (/= ' ') (dropWhile (== ' ') l))
        afterEq    = drop 1 (dropWhile (/= '=') afterRound)
        body       = drop 1 (dropWhile (/= ' ') afterEq)
    in unwords (words (upTo "  (" body))
  where
    upTo sep = go ""
      where
        go acc [] = reverse acc
        go acc t@(c:cs)
          | take (length sep) t == sep = reverse acc
          | otherwise = go (c:acc) cs

-- Lemmas worth proving, best first, paired with the number of distinct
-- parent goals each would unblock.  Input is the KERNEL-REJECT lines.
curriculum :: [String] -> [((Term, Term), Int)]
curriculum ls =
    sortOn (negate . snd)
      [ (p, length (nub gs)) | (p, gs) <- collect ]
  where
    edges = [ (p, goalOfRejectLine l)
            | l <- ls, Just p <- [residualOf l]
            , Pravishati _ <- [pravesha (triage p)] ]
    collect = [ (p, [ g | (p', g) <- edges, p' == p ])
              | p <- nub (map fst edges) ]

-- ------------------------------------------------- THE SEVENFOLD POSITIONS
--
-- SOURCES.  Umāsvāti, Tattvārthasūtra (c. 2nd–5th c. CE) 1.6
-- `pramāṇanayair adhigamaḥ` and 5.31 `arpitānarpitasiddheḥ`; Siddhasena
-- Divākara, Sanmatitarka (Prakrit Sammai-suttaṃ, c. 5th c. CE) 1.21 on the
-- durnaya; Samantabhadra, Āptamīmāṃsā (c. 6th c. CE) for the saptabhaṅgī;
-- Akalaṅka, Laghīyastraya (c. 720–780 CE) for the argument that the number
-- is exactly seven.  `formal/cubical/Saptabhangi.agda` checks the parts of
-- this that are theorems (Agda 2.6.3, --safe, no postulates, no holes,
-- EXIT=0).  What follows is the measurement.
--
-- THE OBSERVATION THAT FORCED THIS.  Two lines of interactive/machine.log,
-- verbatim, both round 0.  QUOTED, NOT POINTED AT: that file is gitignored
-- and is rewritten by every engine run, so no commit fixes its bytes and
-- no line number names anything in it.  The quotations below ARE the
-- object; the file is named as history.  (This paragraph used to read
-- "146 ... / 174 ...".  Both numbers rotted -- position 146 today is a
-- KERNEL-SKIP of a different claim -- and the citation went on resolving
-- after the object had gone, which is exactly the failure the sevenfold
-- below is about.  Registered as `uddhrta` in interactive/mula.pramana and
-- checked by interactive/MulaPramana_ACitationNamesAFixedObjectOrItIsNotOne.hs.)
--
--   as quoted 2026-08-18:
--     KERNEL-REJECT  x = (xmaxx)  ... refl has type x ≡ max x x
--     KERNEL-ACCEPT  x = (xmaxx)  (induction on x, step = cong suc)
--
--   as the log stands 2026-08-20 -- the same claim, still both ways, and
--   the refusal now given a different ground, which is itself the finding:
--     KERNEL-ACCEPT round=0 x = (xmaxx)  (induction on x, step = cong suc, 4 agda calls)
--     KERNEL-REJECT round=0 x = (xmaxx)  (4 agda calls) [naya=induction on x] kernel gate environment fault
--
-- Same claim, same round, denied and affirmed.  The verdict was never a
-- property of the claim; it is a property of the (claim, standpoint) pair,
-- and the standpoint was not being recorded.  This module's opening
-- paragraph already found one level of that collapse (Bool → three
-- constructors).  It stopped one level too early: `Obstruction` is not
-- "what the kernel said", it is what ONE naya said, and the log contains at
-- least three nayas, distinguishable by the tactic it prints:
--
--     663  trace replay              480  induction on x, step = refl
--     420  induction on x, step = ih  255  induction on x, step = cong suc
--      43  refl
--
-- WHAT IS AND IS NOT CLAIMED ABOUT THE DOCTRINE.  In the classical scheme
-- the seven bhaṅgas are seven legitimate WAYS OF SPEAKING about one object,
-- all seven true of every object; they are not a partition of objects into
-- seven bins.  A census therefore asks a question the doctrine does not
-- itself answer, and the operationalisation below is mine, not Akalaṅka's:
--
--   asti       — some naya in the log AFFIRMS the claim (an ACCEPT line).
--   nāsti      — some naya in the log DENIES it (a REJECT line; kernel-refl
--                refused), or the rewriter refutes it by evaluation.
--   avaktavya  — the refusal is not expressible as a standpointed
--                predication at all: Agda's message yields no term in the
--                language, so no `Vacana` is even formable.  This is the
--                §5 notion of Saptabhangi.agda in its degenerate case, and
--                it is what `Unparsed` was reaching for.
--
-- Note the asymmetry, deliberately kept: absence of an ACCEPT line is NOT
-- recorded as nāsti.  The log records refusals and successes; it does not
-- record a naya declining to try.  Reading silence as denial is the durnaya.

data Naya
  = Rewriter    -- the machine's own evaluation over Integer (`triage`)
  | KernelRefl  -- Agda's definitional equality, `refl` the whole tactic
  | KernelInd   -- Agda plus induction on a variable, or trace replay
  deriving (Eq, Ord, Show)

data Bhanga
  = B1Asti                  -- syād asti
  | B2Nasti                 -- syād nāsti
  | B3AstiNasti             -- syād asti nāsti ca        (krama, in succession)
  | B4Avaktavya             -- syād avaktavyam           (yugapat, at once)
  | B5AstiAvaktavya         -- syād asti ca avaktavyaṃ ca
  | B6NastiAvaktavya        -- syād nāsti ca avaktavyaṃ ca
  | B7AstiNastiAvaktavya    -- syād asti nāsti ca avaktavyaṃ ca
  deriving (Eq, Ord, Show)

-- Saptabhaṅgī presupposes a dharma predicated of a dharmin — a property of
-- a subject.  `x = y` with two distinct free variables has no dharmin: it is
-- a failed unification, not a claim.  It is NOT a bhaṅga and is not forced
-- into one.  This constructor is the honest residue.
data Sthana = Position Bhanga | ADharmin
  deriving (Eq, Ord, Show)

-- The standpoint, carried explicitly.  One field per naya; no field is a
-- verdict "of the kernel" or "of the machine" unindexed.
data Evidence = Evidence
  { evRewriter   :: Maybe Verdict      -- Nothing when there is no term to judge
  , evKernelRefl :: Obstruction        -- what refl refused, and how
  , evSakshin    :: Maybe String       -- साक्षिन्: the ACCEPT line that affirms
                                      -- it, if any naya did.  Not a Bool: the
                                      -- witness itself, so affirmation cannot
                                      -- be asserted without producing it.
  } deriving (Eq, Show)

evidenceOfReject :: [String] -> String -> Evidence
evidenceOfReject accepted line = Evidence
  { evRewriter   = fmap triage (residualOf line)
  , evKernelRefl = obs
  , evSakshin    = lookupAffirm (goalOfRejectLine line) accepted
  }
  where
    -- The goal is printed in the machine's notation and the residual in
    -- Agda's, which the module header calls incomparable.  It is comparable
    -- in ONE direction: `Term`'s Show instance IS the machine's notation, so
    -- rendering the parsed residual back and comparing strings decides
    -- TacticTooWeak vs Residual from a single line, with no second source.
    obs = case residualOf line of
      Nothing  -> Unparsed (take 200 line)
      Just res@(a, b)
        | showClaim res == goal || showClaim (b, a) == goal -> TacticTooWeak res
        | otherwise                                        -> Residual res
    goal = goalOfRejectLine line

sthana :: Evidence -> Sthana
sthana ev
  | Just (Nirdharmin _) <- evRewriter ev = ADharmin
  | otherwise = Position (assemble asti nasti avaktavya)
  where
    avaktavya = case evKernelRefl ev of
      Unparsed _ -> True
      _          -> False
    -- the REJECT line itself is kernel-refl denying; the rewriter may deny too
    nasti = True
    asti  = case evSakshin ev of { Just _ -> True ; Nothing -> False }
    assemble True  False False = B1Asti
    assemble False True  False = B2Nasti
    assemble True  True  False = B3AstiNasti
    assemble False False True  = B4Avaktavya
    assemble True  False True  = B5AstiAvaktavya
    assemble False True  True  = B6NastiAvaktavya
    assemble True  True  True  = B7AstiNastiAvaktavya
    -- no evidence at all: the line would not be in the log.  Kept total
    -- rather than partial, and never reached from `evidenceOfReject` because
    -- `nasti` is True there by construction.
    assemble False False False = B2Nasti

-- Render a term pair in the machine's own notation, which is what the log
-- prints on ACCEPT lines.  (`Term`'s Show instance already agrees with it;
-- `showClaim (V 0, F "+" [F "0" [], V 0])` is "x = (0+x)", the exact string
-- at machine.log's first ACCEPT.)
showClaim :: (Term, Term) -> String
showClaim (l, r) = show l ++ " = " ++ show r

-- The claim on a KERNEL-ACCEPT line.  The framing is character-identical to
-- a KERNEL-REJECT line's up to the "  (" that opens the tactic, so the same
-- extractor is correct; this alias exists so the call site says which.
claimOfAcceptLine :: String -> String
claimOfAcceptLine = goalOfRejectLine

-- The tactic named on a KERNEL-ACCEPT line: the text between "  (" and the
-- ", N agda calls)" tail.  This is what distinguishes KernelRefl from
-- KernelInd, and it is the only place the log says which naya spoke.
tacticOfAcceptLine :: String -> String
tacticOfAcceptLine l = case dropTo "  (" l of
  Nothing -> ""
  Just t  -> case reverse (dropWhile (/= ',') (reverse t)) of
    []  -> t          -- no ", N agda calls)" tail; take it whole
    s   -> init s     -- drop the tail, then its separating comma
  where
    dropTo sep s
      | sep `isPrefixOf` s = Just (drop (length sep) s)
      | null s             = Nothing
      | otherwise          = dropTo sep (tail s)

acceptedClaims :: [String] -> [String]
acceptedClaims ls = nub [ claimOfAcceptLine l | l <- ls, "KERNEL-ACCEPT" `isInfixOf` l ]

-- The census.  Two populations, deliberately, because they answer different
-- questions and only reporting one of them would mislead:
--
--   * over REJECTION LINES        — every position is reachable
--   * over DISTINCT RESIDUALS     — `avaktavya` is 0 BY CONSTRUCTION, since
--                                   being one of the distinct residuals
--                                   already means the message parsed.
census :: [String] -> ([(Sthana, Int)], [(Sthana, Int)])
census ls = (tally overLines, tally overResiduals)
  where
    accepted = acceptedClaims ls
    rejects  = [ l | l <- ls, "KERNEL-REJECT" `isInfixOf` l ]
    overLines = [ sthana (evidenceOfReject accepted l) | l <- rejects ]
    -- one entry per DISTINCT residual pair; a residual's own asti is asked
    -- of the residual as a claim, not of the parent goal
    overResiduals =
      [ sthana Evidence { evRewriter   = Just (triage p)
                        , evKernelRefl = Residual p
                        , evSakshin    = lookupAffirm (showClaim p) accepted }
      | p <- nub [ p | l <- rejects, Just p <- [residualOf l] ] ]
    tally xs = [ (k, length [ () | y <- xs, y == k ]) | k <- nub (sort xs) ]

-- The cross-tabulation is the point.  A one-dimensional census would let a
-- reader conclude that the sevenfold replaces `triage`.  It does not: the
-- table below shows each carrying information the other discards, which is
-- the anekāntavāda conclusion applied to the classifier itself rather than
-- to the classified.
-- EVIDENCE IS NOT CLASSIFICATION, AND A TALLY MUST NOT FAKE ONE.  Every
-- `Verdict` constructor now carries a witness, and a cross-tab grouped by the
-- witness would give each refuting assignment and each alien symbol its own
-- row — a table with one line per line.  So the tally groups by KIND.  The
-- first version of this did it by rebuilding the constructors with empty
-- payloads, which printed `Aviruddha over NOTHING` and `Khandita at []` —
-- a display asserting something false about the evidence in order to hide
-- that the evidence had been discarded, which is the exact defect this
-- module exists to remove, reappearing in the report layer.  A separate type
-- cannot lie: it has no place to put a witness, so it does not claim one.
data VerdictKind = KAviruddha | KKhandita | KNirdharmin | KTusnim
  deriving (Eq, Ord)

instance Show VerdictKind where
  show KAviruddha  = "aviruddha"
  show KKhandita   = "khandita"
  show KNirdharmin = "nirdharmin"
  show KTusnim     = "tusnim"

verdictKind :: Verdict -> VerdictKind
verdictKind (Aviruddha _)  = KAviruddha
verdictKind (Khandita _)   = KKhandita
verdictKind (Nirdharmin _) = KNirdharmin
verdictKind (Tusnim _)     = KTusnim

crossTab :: [String] -> [((Sthana, Maybe VerdictKind), Int)]
crossTab ls =
    [ (k, length [ () | y <- pairs, y == k ]) | k <- nub (sort pairs) ]
  where
    accepted = acceptedClaims ls
    pairs = [ (sthana ev, fmap verdictKind (evRewriter ev))
            | l <- ls, "KERNEL-REJECT" `isInfixOf` l
            , let ev = evidenceOfReject accepted l ]

censusReport :: [String] -> String
censusReport ls = unlines $
     [ "saptabhangi census over " ++ show (length ls) ++ " log lines"
     , ""
     , "  rejection lines:      " ++ show (sum (map snd byLine))
     , "  distinct residuals:   " ++ show (sum (map snd byRes))
     , "  distinct claims accepted by some naya: " ++ show (length (acceptedClaims ls))
     , ""
     , "-- over rejection lines --" ]
  ++ map row byLine
  ++ [ "", "-- over distinct residuals --" ]
  ++ map row byRes
  ++ [ ""
     , "-- sthana x rewriter-naya verdict, over rejection lines --"
     , "   (Nothing = no term to judge: the message did not parse)" ]
  ++ [ "  " ++ pad 32 (show s) ++ pad 18 (show v) ++ show n
     | ((s, v), n) <- crossTab ls ]
  where
    (byLine, byRes) = census ls
    row (k, n) = "  " ++ pad 32 (show k) ++ show n
    pad n s = s ++ replicate (max 0 (n - length s)) ' '

-- ---------------------------------------------------------------- selftest
--
-- Every string below is copied verbatim out of interactive/machine.log.  A test
-- written against invented input would prove only that the parser parses its
-- author's imagination.

selfTest :: IO Bool
selfTest = do
    let checks = map run cases
        run (name, goal, msg, expected) =
          let got = classify goal msg
          in (name, got == expected, got, expected)
        triChecks = map runT tri
        -- THE TEST CHECKS THE EVIDENCE, NOT A COPY OF IT.  Comparing the
        -- payload against a hardcoded assignment would test only that the
        -- generator in `envs` still enumerates in the same order.  What the
        -- verdict claims is what gets checked: a khandita must hand back an
        -- assignment that ACTUALLY separates the two sides, and an aviruddha
        -- must hand back a non-empty domain on which they actually agree.
        -- The expected payloads below are therefore written empty.
        runT (name, p, expected) =
          let got = triage p
          in (name, agrees p got expected, got, expected)
        agrees (l, r) (Khandita e) (Khandita _) = evalT e l /= evalT e r
        agrees (l, r) (Aviruddha d) (Aviruddha _) =
          not (null d) && all (\e -> evalT e l == evalT e r) d
        agrees _ a b = a == b
        sapChecks = map runS sap
        runS (name, got, expected) = (name, got == expected, got, expected)
    mapM_ report checks
    putStrLn "  -- triage --"
    mapM_ report triChecks
    putStrLn "  -- saptabhangi --"
    mapM_ report sapChecks
    pure (all (\(_, ok, _, _) -> ok) checks
          && all (\(_, ok, _, _) -> ok) triChecks
          && all (\(_, ok, _, _) -> ok) sapChecks)
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
      [ ( "real missing lemma  x = x + 0",   (x, F "+" [x, z0]),            Aviruddha [] )
      , ( "real missing lemma  x*0 = 0",     (F "*" [x, z0], z0),           Aviruddha [] )
      , ( "real missing lemma  0 = x - x",   (z0, F "-" [x, x]),            Aviruddha [] )
        -- both of these are FALSE and appear 30 and 100 times in the log.
        -- Queued undifferentiated they regenerate themselves forever.
      , ( "false parent  x*x = s(x)",        (F "*" [x, x], suc x),         Khandita [] )
      , ( "false parent  x*max(x,1) = s(x)", (F "*" [x, F "max" [x, suc z0]], suc x)
                                                                          , Khandita [] )
      , ( "degenerate  x = y",               (x, V 1),                      Nirdharmin (0,1) )
      ]

    -- SAPTABHANGI.  Every line below is copied verbatim out of
    -- interactive/machine.log at the line number named, and the accept-set is
    -- the two real ACCEPT lines the cases turn on rather than an invented
    -- one.  The point of testing against the real log twice over is that
    -- the sevenfold's ONE new axis — asti, "some naya affirmed this" — is
    -- a cross-stream fact, and a test that fabricated the accept stream
    -- would be testing nothing.
    acc =
      [ claimOfAcceptLine
          "  KERNEL-ACCEPT round=0 x = (xmaxx)  (induction on x, step = cong suc, 1 agda calls)"
      , claimOfAcceptLine
          "  KERNEL-ACCEPT round=0 (x+y) = (y+x)  (induction on x, step = ih, 1 agda calls)"
      ]

    st = sthana . evidenceOfReject acc

    sap =
      [ -- THE CASE THE WHOLE THING IS FOR.  The log denies this claim under
        -- refl and affirms it under induction, in the same round.  The
        -- REJECT string below is the citation: quoted, because machine.log
        -- is gitignored and regenerated and no position in it holds still.
        -- syad asti-nasti, taken KRAMA.  Neither line is wrong.
        ( "krama: x = max x x, denied under refl and affirmed under induction"
        , st "  KERNEL-REJECT round=0 x = (xmaxx)  (0 agda calls) cached: x != max x x of type \8469 when checking that the expression refl has type x \8801 max x x"
        , Position B3AstiNasti )

        -- Same shape, but no naya in the log affirms it.  Quoted, not pointed at.
      , ( "nasti only: no accept line anywhere for this claim"
        , st "  KERNEL-REJECT round=5 x = -((x+y),y)  (2 agda calls) base clause: x != x + zero of type \8469 when checking that the expression refl has type x \8801 x + zero \8760 zero"
        , Position B2Nasti )

        -- The refusal quoted below mentions a section `cong (x ·_)`,
        -- which is outside the language of standpointed predication: no
        -- Vacana is formable, so nothing single-standpointed denotes it.
        -- This is `Unparsed` read as what it always was.
      , ( "avaktavya: refusal not expressible as a standpointed predication"
        , st "  KERNEL-REJECT round=0 le(x,0) = -(s(0),(x*x))  (8 agda calls) x \183 le x zero != zero of type \8469 when checking that the expression cong (x \183_) (candidate x) has"
        , Position B6NastiAvaktavya )

        -- `x != y`: two distinct free variables.  There is
        -- no dharmin, so there is no bhanga -- and note the claim IS in the
        -- accept stream, so a careless reading would have made this B3.
      , ( "adharmin: x != y has no subject, so no bhanga (not forced into one)"
        , st "  KERNEL-REJECT round=0 (x+y) = (y+x)  (0 agda calls) cached: x != y of type \8469 when checking that the expression refl has type x + y \8801 y + x"
        , ADharmin )
      ]

-- साक्षिन् — the affirming witness, or nothing.  Not a Bool: if a naya
-- affirmed the claim, the ACCEPT line that did so is produced.
lookupAffirm :: String -> [String] -> Maybe String
lookupAffirm claim accepted =
  case [ a | a <- accepted, a == claim ] of
    (a:_) -> Just a
    []    -> Nothing
