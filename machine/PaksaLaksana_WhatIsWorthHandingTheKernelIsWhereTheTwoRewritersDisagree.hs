-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

-- पक्षलक्षणम् — PakṣaLakṣaṇa: the mark of a thesis worth advancing, applied
-- to the equations this engine composes and hands to the Agda kernel.
--
-- ---------------------------------------------------------------------
-- THE FINDING, FIRST, AND THE NEGATIVE HALF FIRST WITHIN IT
--
-- Of the 119,489 true equations the three hands of bhāvanā compose
-- (machine/TulyaBhavana_TheIdentificationHandThatIstaPoolExcludes.hs),
-- exactly ONE is a lemma the kernel's own residual stream asked for.  So
-- selection over the composed set cannot, by itself, deliver the kernel's
-- curriculum: what is not reached is not selectable.  Anyone reading the
-- charge "novelty was never the constraint, relevance is" as "so filter the
-- 119,489 down to the demand" gets 1 out of 9, and that is measured below,
-- not argued.
--
-- What the composed set DOES contain, and nothing in this repository has
-- ever looked for, is this:
--
--     8,130 equations that the Agda kernel accepts by `refl`, in ONE agda
--     call, and that the machine's own rewriter cannot close at all.
--
-- They are free.  They are certain before Agda is called.  They are new to
-- the machine — installing one strictly strengthens its rewriter.  And the
-- engine's present composition wire (`MathMachine.hs --samasa`, WIRE 7)
-- cannot tell them apart from the 85,718 equations sitting next to them
-- that cost up to eight agda calls and are then usually refused.
--
-- ---------------------------------------------------------------------
-- HOW THEY ARE TOLD APART, WITHOUT CALLING AGDA
--
-- Two rewriters, not one.  The engine has always had one — its own — and
-- has been asking it a question only the kernel can answer.
--
--   M — the machine's naya.  `MathMachine`'s `symDefs`, as unconditional
--       rewrite rules in any position.  `+` and `*` recurse on the SECOND
--       argument; `max` has both zero-clauses firing on an open term.
--
--   K — the kernel's naya.  Agda's definitional unfolding for the same
--       functions, as a CASE TREE: `_+_` and `_*_` recurse on the FIRST
--       argument, and a clause fires only when the column it splits is
--       already a constructor.  Transcribed from `machine/Certificate.hs`
--       notes A and B, which state the divergence exactly and were written
--       for a different purpose.
--
-- Each is sound and neither is complete, which is the ordinary condition of
-- a naya.  An equation therefore has a JOINT position — joinable under M or
-- not, joinable under K or not — and the four positions have four different
-- prices at the kernel.  Measured against the kernel itself, 32 samples, 8
-- from each position (§ KERNEL, below):
--
--   position        count   what the kernel did, 8/8 in every row
--   (M yes, K yes)  10,713  Certified "refl", 1 agda call   — and the
--                           machine already rewrites it: siddha-sādhana,
--                           advancing what the respondent already grants.
--   (M no,  K yes)   8,130  Certified "refl", 1 agda call   — and the
--                           machine CANNOT.  This is the pakṣa.
--   (M yes, K no)   14,928  induction (2–4 calls) or refused after 8.
--                           The impedance-mismatch class `Obstruction.hs`
--                           already diagnosed; a real prize, dearly bought.
--   (M no,  K no)   85,718  induction, or refused after 8 calls.  The bulk.
--
-- 32 of 32 agreed with the prediction.  Every K-joinable sample certified by
-- `refl` in exactly one call; no K-stuck sample certified by `refl` at all.
--
-- ---------------------------------------------------------------------
-- THE INVERSION, WHICH IS THE POINT
--
-- `MathMachine.hs` WIRE 7 already selects, and its rule is (MathMachine.hs,
-- `composedNovel`): normalise both sides with the machine's rules and drop
-- the pair if they agree — "it says nothing the rewriter does not already
-- do."  That is exactly `M yes`, dropped.  So the present engine:
--
--   * drops all 25,641 M-joinable equations, of which 14,928 are the
--     bridging class the kernel's residual stream is asking for;
--   * keeps all 93,848 M-stuck ones, in which the 8,130 free acceptances
--     sit at a dilution of 1 in 11.5, unmarked;
--   * has no cheap-first ordering, because the currency it sorts in is its
--     own rewriter and the bill is paid in the kernel's.
--
-- "18 theorems either way, 209× the CPU, zero additional theorems" is what
-- that costs, and this is the mechanism, not a story about it.
--
-- ONE CONSEQUENCE, CHECKED BY THE KERNEL RATHER THAN ASSERTED.  The
-- flagship residual this engine has circled for 239 rounds:
--
--     x = x + (0 · x)        Certified "induction on x, step = cong suc", 4 calls
--     x = (0 · x) + x        Certified "refl",                            1 call
--
-- Both are in reach of the three hands.  `+(x,y) = +(y,x)` is line 15 of
-- machine/library.terms, already proved.  The mirror is a pakṣa; the
-- flagship is not; the sort says so before agda starts.
--
-- ---------------------------------------------------------------------
-- THE SOURCE, AND WHAT IS AND IS NOT CLAIMED OF IT
--
-- DHARMAKĪRTI, *Nyāyabindu* III.2 (c. 600–660 CE), the definition of a
-- thesis:  स्वरूपेणैव स्वयमिष्टोऽनिराकृतः पक्षः — *svarūpeṇaiva svayam iṣṭo
-- 'nirākṛtaḥ pakṣa iti* — "a pakṣa is what is intended by [the proponent]
-- himself, in its own form, and unrefuted."  Three conditions on what is
-- worth ADVANCING, as distinct from what is true.  Beside it stands the
-- named fault of advancing what the other party already grants,
-- *siddhasādhana*, current in the Nyāya and Buddhist debate literature.
--
-- WHAT IS CLAIMED.  That the tradition states selection — worth-advancing —
-- as a question separate from truth, and names both the conditions and the
-- fault; and that this engine has the fault, measurably, in the shape
-- *siddhasādhana* names.  The mapping of the three conditions onto this
-- machine is written out here so it can be disputed:
--
--   anirākṛta   unrefuted        — the fingerprint firewall.  The engine
--                                  HAS this one, and it is the only one of
--                                  the three it has.
--   svayam iṣṭa intended         — the proponent must want it.  ABSENT: the
--                                  engine proposes what it can form, not
--                                  what anything asked for.
--   svarūpeṇa   in its own form  — not as something else's consequence.
--
-- WHAT IS NOT CLAIMED.  That Dharmakīrti wrote about rewriting, term
-- algebras, or kernels; that a pakṣa is an equation; that the four positions
-- below are his (they are not — they are two nayas' joint predication, and
-- the sevenfold apparatus this repository already runs in
-- `machine/Obstruction.hs` and `formal/cubical/Saptabhangi.agda` is a
-- different and larger object, with which this makes no claim of identity).
-- What is his is the SHAPE: that "true" and "worth stating to this
-- respondent" are two questions, that the second has stateable conditions,
-- and that stating the already-granted is a named fault and not merely a
-- waste.
--
-- ---------------------------------------------------------------------
-- WHAT THIS DOES NOT SETTLE — the śeṣa, carried forward, not discharged
--
-- 1. RANKING WITHIN THE PAKṢA.  8,130 free acceptances is a set, not an
--    order.  Which of them, installed as an M-rule, most enlarges what M
--    can close is a further computation this file does not do.  It is
--    exactly `Obstruction.curriculum`'s "how many parents would this
--    unblock", asked forward instead of read off a log, and it is the next
--    step.
-- 2. M IS THE DEFINITIONS ONLY.  The live engine's rewriter is
--    `definitionsOf … ++ mRules ++ lemmaRules`, which grows as it proves.
--    So the counts here are for the engine at its library, and the (M no)
--    column can only shrink as the machine learns.  That is a property of
--    the sort, not an error in it: an equation leaving the pakṣa because
--    the machine now knows it is precisely siddhasādhana arriving.
-- 3. K IS A TRANSCRIPTION, NOT AGDA.  It agreed with the kernel on 32 of 32
--    samples and on 9 of 9 stalled residuals, and that is evidence, not a
--    proof of faithfulness.  `--kernel N` is the falsifier and is meant to
--    be re-run, not quoted.
-- 4. `gcd` REDUCES ON NO OPEN TERM in either naya, so every equation
--    mentioning it lands in (M no, K no) for a reason that is about
--    `Cubical.Data.Nat.GCD.euclid` and not about the mathematics.  It is
--    not excluded here; a reader counting the fourth position should know
--    this is in it.
-- 5. `BhavanaTheorem.definingEquations` transcribes ten of MathMachine's
--    `symDefs` and OMITS `le`'s three.  M below adds them, from
--    `Certificate.hs`'s transcription of the same `symDefs`, so that `le`
--    is not stuck under M for a bookkeeping reason.  The omission in
--    `BhavanaTheorem` is another identity's file and is left alone; it is
--    recorded here because it silently moves equations between positions.
--
-- EXACT.  Every number printed is a set cardinality or an agda verdict.  No
-- clock is read; the host carries sixteen lanes and a wall figure from it
-- would be load, as machine/MATRA_*.md §6 establishes.
--
-- ---------------------------------------------------------------------
-- ---------------------------------------------------------------------
-- WHY THIS IS NOT WIRED INTO THE ENGINE, AND EXACTLY WHAT THE WIRE WOULD BE
--
-- machine/MATRA_*.md §5 measures that twelve of the day's fifteen organs are
-- reached by nothing the engine runs, and says so as the finding rather than
-- inventing a benchmark to hide it.  This organ is a thirteenth, and the
-- reason is stated so it can be overruled rather than inherited.
--
-- The change is small and it is one expression.  In `MathMachine.hs`, WIRE 7
-- builds `composedRaw` and then keeps `composedNovel = [ … | l /= r ]` on the
-- MACHINE-normalised sides.  What the measurement above says is: that test
-- is in the wrong currency.  The wire would (a) carry `kstep`/`nfK` from this
-- file, (b) stop discarding the M-joinable composites, and (c) order the
-- proposal K-joinable first, so the round spends its agda calls on the
-- certain one-call acceptances before anything else.  Default off, as WIRE 4,
-- 5, 6 and 7 all are, so the unflagged engine stays byte-identical.
--
-- It is not done here for two reasons, both of which are about honesty of
-- measurement rather than about caution:
--
--   1. `MathMachine.hs` is the object sixteen concurrent lanes are measuring
--      today, and `machine/MATRA_*.md` §3.3 records three different sha256s
--      for it inside one session.  A commit into it from here would silently
--      invalidate arms already in flight.
--   2. A wire whose loop A/B cannot be run is worse than a wire deliberately
--      deferred.  The A/B for this one is Agda-bound and multi-round; this
--      host is at load 73.  Landing it and reporting the four counts above as
--      if they were an engine result would be exactly the invented benchmark
--      §5 names.
--
-- So: the criterion is measured, and it is measured against the kernel
-- itself, which is the part that could not be got any other way.  The wire is
-- an offer, in collab/messages/, not a commit into another lane's object.
--
-- RUN — same binary, one flag, both arms from one snapshot:
--
--     sh machine/run-paksa.sh
--
-- or directly, from the repository root:
--
--     runghc -imachine machine/PaksaLaksana_*.hs --asamskrta   # control
--     runghc -imachine machine/PaksaLaksana_*.hs --paksa       # selected
--     runghc -imachine machine/PaksaLaksana_*.hs --kernel 8    # the falsifier
--     runghc -imachine machine/PaksaLaksana_*.hs --self-test

import qualified BhavanaTheorem as B
import qualified Obstruction as OB
import qualified Certificate as C
import Data.List (isInfixOf, nub, sortOn)
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import System.Environment (getArgs)
import System.IO

type T = B.Term
type Eqn = (T, T)

-- ------------------------------------------------------------ plumbing

varsOf :: T -> [Int]
varsOf (B.V i) = [i]
varsOf (B.F _ ts) = concatMap varsOf ts

tsize :: T -> Int
tsize (B.V _) = 1
tsize (B.F _ ts) = 1 + sum (map tsize ts)

canon :: Eqn -> Eqn
canon (l, r) =
  let m = M.fromList (zip (nub (varsOf l ++ varsOf r)) [0 ..])
      f (B.V i) = B.V (M.findWithDefault i i m)
      f (B.F g ts) = B.F g (map f ts)
      (a, b) = (f l, f r)
  in if a <= b then (a, b) else (b, a)

fromOb :: OB.Term -> T
fromOb (OB.V i) = B.V i
fromOb (OB.F f ts) = B.F f (map fromOb ts)

toCert :: T -> C.Term
toCert (B.V i) = C.V i
toCert (B.F f ts) = C.F f (map toCert ts)

-- तुल्यभावना, the third hand, verbatim from
-- machine/TulyaBhavana_TheIdentificationHandThatIstaPoolExcludes.hs so that
-- the reach set below IS that file's reach set and the two are comparable.
tulya :: [Eqn] -> [Eqn]
tulya eqs =
  S.toList (S.fromList
    [ (B.applySubst s l, B.applySubst s r)
    | (l, r) <- eqs
    , let vs = nub (varsOf l ++ varsOf r)
    , i <- vs, j <- vs, i /= j
    , let s = M.singleton i (B.V j)
    , B.applySubst s l /= B.applySubst s r ])

-- ------------------------------------------------------- M — the machine's naya
--
-- MathMachine's `symDefs` as unconditional rewrite rules at any position.
-- `+` and `*` recurse on the SECOND argument; `max` fires `max x 0 = x` and
-- `max 0 x = x` whichever column is the zero.  This is stronger than pattern
-- matching, which is Certificate.hs note B's observation read forward.
--
-- `le`'s three clauses are added here and are NOT in
-- `BhavanaTheorem.definingEquations`; see śeṣa 5 in the header.
machineRules :: [Eqn]
machineRules = B.definingEquations ++ leDefs
  where
    leDefs = [ (B.F "le" [z, x],       s z)
             , (B.F "le" [s x, z],     z)
             , (B.F "le" [s x, s y],   B.F "le" [x, y]) ]
    x = B.V 0 ; y = B.V 1 ; z = B.F "0" [] ; s t = B.F "s" [t]

rewriteOnce :: [Eqn] -> T -> Maybe T
rewriteOnce rs t =
  case [ B.applySubst sb r | (l, r) <- rs, Just sb <- [B.match l t] ] of
    (u:_) -> Just u
    []    -> case t of
      B.F f ts -> descend f [] ts
      _        -> Nothing
  where
    descend _ _ [] = Nothing
    descend f pre (c:cs) = case rewriteOnce rs c of
      Just c' -> Just (B.F f (reverse pre ++ c' : cs))
      Nothing -> descend f (c:pre) cs

-- The Bool is `reached a normal form within the budget`.  A capped
-- normalisation is NOT reported as a normal form; `--self-test` counts the
-- caps and the count must be 0, because a silent cap would move equations
-- between positions with nothing said.
nfWith :: (T -> Maybe T) -> Int -> T -> (T, Bool)
nfWith _    0 t = (t, False)
nfWith step n t = case step t of
  Nothing -> (t, True)
  Just u  -> nfWith step (n - 1) u

kBudget :: Int
kBudget = 3000

nfM :: T -> (T, Bool)
nfM = nfWith (rewriteOnce machineRules) kBudget

-- ------------------------------------------------------- K — the kernel's naya
--
-- Agda's definitional unfolding, AS A CASE TREE.  A clause fires only when
-- the column it splits on is already a constructor; an open term in that
-- column is stuck.  That is the whole of the difference from M, and it is
-- what makes `x · 0` irreducible for the kernel and immediate for the
-- machine.
--
-- Clause lists transcribed from machine/Certificate.hs, which states them
-- for the emitter it feeds:
--   _+_  (Agda.Builtin.Nat)   zero + m = m ; suc n + m = suc (n + m)
--   _*_  (Agda.Builtin.Nat)   zero * m = zero ; suc n * m = m + n * m
--   _∸_  (Agda.Builtin.Nat)   n - zero = n ; zero - suc m = zero
--                             ; suc n - suc m = n - m
--   max  (LOCAL, emitted by Certificate.preamble in the machine's clause
--        order)               max a zero = a ; max zero b = b
--                             ; max (suc a) (suc b) = suc (max a b)
--   le   (LOCAL)              le zero b = suc zero ; le (suc a) zero = zero
--                             ; le (suc a) (suc b) = le a b
--   gcd  Cubical.Data.Nat.GCD.gcd — reduces on no open term, so no clause.
kstep :: T -> Maybe T
kstep (B.F "+" [a, b]) = case a of
  B.F "0" []  -> Just b
  B.F "s" [n] -> Just (B.F "s" [B.F "+" [n, b]])
  _           -> Nothing
kstep (B.F "*" [a, b]) = case a of
  B.F "0" []  -> Just (B.F "0" [])
  B.F "s" [n] -> Just (B.F "+" [b, B.F "*" [n, b]])
  _           -> Nothing
kstep (B.F "-" [a, b]) = case b of
  B.F "0" []  -> Just a
  B.F "s" [m] -> case a of
    B.F "0" []  -> Just (B.F "0" [])
    B.F "s" [n] -> Just (B.F "-" [n, m])
    _           -> Nothing
  _           -> Nothing
kstep (B.F "max" [a, b]) = case b of
  B.F "0" []   -> Just a
  B.F "s" [b'] -> case a of
    B.F "0" []   -> Just b
    B.F "s" [a'] -> Just (B.F "s" [B.F "max" [a', b']])
    _            -> Nothing
  _            -> Nothing
kstep (B.F "le" [a, b]) = case a of
  B.F "0" []   -> Just (B.F "s" [B.F "0" []])
  B.F "s" [a'] -> case b of
    B.F "0" []   -> Just (B.F "0" [])
    B.F "s" [b'] -> Just (B.F "le" [a', b'])
    _            -> Nothing
  _            -> Nothing
kstep _ = Nothing

kOnce :: T -> Maybe T
kOnce t = case kstep t of
  Just u  -> Just u
  Nothing -> case t of
    B.F f ts -> descend f [] ts
    _        -> Nothing
  where
    descend _ _ [] = Nothing
    descend f pre (c:cs) = case kOnce c of
      Just c' -> Just (B.F f (reverse pre ++ c' : cs))
      Nothing -> descend f (c:pre) cs

nfK :: T -> (T, Bool)
nfK = nfWith kOnce kBudget

-- ------------------------------------------------------------ the position

-- The joint predication of the two nayas: is this equation already closed
-- under M, and is it already closed under K.  Neither answer alone is a
-- verdict on the equation; the pair is what has a price.
data Sthana = Sthana { underM :: !Bool, underK :: !Bool } deriving (Eq, Ord)

instance Show Sthana where
  show (Sthana m k) = "(M " ++ yn m ++ ", K " ++ yn k ++ ")"
    where yn True = "yes" ; yn False = "no "

sthanaOf :: Eqn -> Sthana
sthanaOf (l, r) = Sthana (fst (nfM l) == fst (nfM r)) (fst (nfK l) == fst (nfK r))

positions :: [Sthana]
positions = [ Sthana True True, Sthana False True, Sthana True False, Sthana False False ]

gloss :: Sthana -> String
gloss (Sthana True  True ) = "siddhasadhana -- refl for the kernel, and the machine already rewrites it"
gloss (Sthana False True ) = "PAKSA         -- refl for the kernel, and NEW to the machine"
gloss (Sthana True  False) = "the bridge    -- the machine knows it, the kernel needs induction"
gloss (Sthana False False) = "neither naya  -- expensive, usually refused"

-- ------------------------------------------------------------ the reach set

reachSet :: String -> ([Eqn], [Eqn])
reachSet lib =
  let base     = nub (B.parseLibraryPublic lib ++ B.definingEquations)
      pool     = B.istaPool base
      composed = B.bhavana base
      twoHands = composed ++ B.praksepa pool base ++ B.praksepa pool composed
      three    = twoHands ++ tulya (base ++ twoHands)
  in (base, S.toList (S.fromList (map canon three)))

demandedOf :: [String] -> [Eqn]
demandedOf ls =
  S.toList (S.fromList
    [ canon (fromOb a, fromOb b)
    | ((a, b), _) <- OB.curriculum [ l | l <- ls, "KERNEL-REJECT" `isInfixOf` l ] ])

-- ------------------------------------------------------------------ main

readUtf8 :: FilePath -> IO String
readUtf8 p = do { h <- openFile p ReadMode ; hSetEncoding h utf8 ; hGetContents h }

main :: IO ()
main = do
  hSetEncoding stdout utf8
  args <- getArgs
  lib  <- readUtf8 "machine/library.terms"
  logl <- lines <$> readUtf8 "machine/machine.log"
  let (base, reach) = reachSet lib
      demanded = demandedOf logl
      tagged   = [ (e, sthanaOf e) | e <- reach ]
      inPos p  = [ e | (e, q) <- tagged, q == p ]
      counts   = [ (p, length (inPos p)) | p <- positions ]
      -- the engine's present rule, MathMachine.hs WIRE 7 `composedNovel`:
      -- normalise with the machine's rules and drop the pair if they agree.
      wire7Keeps = [ e | (e, q) <- tagged, not (underM q) ]
      -- this file's rule.
      paksa      = sortOn (\e -> (tsize (fst e) + tsize (snd e), e))
                     (inPos (Sthana False True))
  putStrLn "पक्षलक्षणम् — the two rewriters, and what is worth handing the kernel."
  putStrLn ""
  putStrLn ("  base facts (library + defining equations): " ++ show (length base))
  putStrLn ("  reach of the three hands, distinct:        " ++ show (length reach))
  putStrLn ""
  putStrLn "  the four positions:"
  mapM_ (\(p, n) -> putStrLn ("    " ++ show p ++ "  " ++ pad 7 (show n)
                              ++ "  " ++ gloss p)) counts
  putStrLn ""
  -- The demand, and the negative half of the finding, printed in BOTH arms
  -- so that neither can be quoted without it.
  let inReach = [ g | g <- demanded, g `elem` reach ]
  putStrLn ("  lemmas the kernel's residual stream demands: " ++ show (length demanded))
  putStrLn ("    of those, reached by the three hands:      " ++ show (length inReach))
  putStrLn "    -- so selection over the composed set cannot deliver the curriculum;"
  putStrLn "       what is not reached is not selectable.  This is the negative result."
  putStrLn ""
  case () of
    _ | "--self-test" `elem` args -> selfTest reach demanded
      | "--kernel"    `elem` args -> kernelCheck (budgetOf args) inPos
      | "--asamskrta" `elem` args -> arm "ASAMSKRTA (control: the engine's present WIRE 7 rule)"
                                         wire7Keeps tagged
      | "--paksa"     `elem` args -> arm "PAKSA (selected: refl for the kernel, new to the machine)"
                                         paksa tagged
      | otherwise -> do
          putStrLn "  (no arm chosen: --asamskrta, --paksa, --kernel N, --self-test)"
  where
    pad n s = s ++ replicate (max 0 (n - length s)) ' '
    budgetOf as = case dropWhile (/= "--kernel") as of
      (_:v:_) | [(n, "")] <- reads v -> n
      _ -> 8

-- Both arms print the same shape, so the two are read side by side: what the
-- arm proposes, and what the proposal costs at the kernel per the position
-- table above.  The arms differ in exactly one expression -- which list is
-- passed in -- and nothing else.
arm :: String -> [Eqn] -> [(Eqn, Sthana)] -> IO ()
arm name proposal tagged = do
  putStrLn ("  ARM: " ++ name)
  putStrLn ("    equations proposed to the kernel: " ++ show (length proposal))
  let m = M.fromList tagged
      byPos = [ (p, length [ () | e <- proposal, M.lookup e m == Just p ]) | p <- positions ]
  mapM_ (\(p, n) -> putStrLn ("      " ++ show p ++ "  " ++ show n)) byPos
  let onecall = sum [ n | (p, n) <- byPos, underK p ]
  putStrLn ("    of the proposal, accepted by refl in ONE agda call: " ++ show onecall)
  putStrLn ("    of the proposal, costing 2-8 calls and often refused: "
            ++ show (length proposal - onecall))
  putStrLn ""
  putStrLn "    -- the first eight proposed, smallest first --"
  mapM_ (\(a, b) -> putStrLn ("       " ++ show a ++ " = " ++ show b))
        (take 8 (sortOn (\(a,b) -> (tsize a + tsize b, (a,b))) proposal))

-- THE FALSIFIER.  The claim is that K decides `refl` and it is checked
-- against the authority, not asserted.  Deterministic sampling: sorted by
-- size, then every k-th, so re-running names the same equations.
kernelCheck :: Int -> (Sthana -> [Eqn]) -> IO ()
kernelCheck n inPos = do
  putStrLn ("  KERNEL -- " ++ show n ++ " samples per position, put to agda.")
  putStrLn "  PREDICTION: `Certified \"refl\" 1` exactly where K joins, nowhere else."
  putStrLn ""
  results <- mapM (checkOne n inPos) positions
  let agree = sum (map fst results) ; total = sum (map snd results)
  putStrLn ""
  putStrLn ("  agreed with the prediction: " ++ show agree ++ " of " ++ show total)
  putStrLn "  (a disagreement is a written seṣa against K's transcription, not"
  putStrLn "   against the kernel; K is the thing that has to be repaired.)"

checkOne :: Int -> (Sthana -> [Eqn]) -> Sthana -> IO (Int, Int)
checkOne n inPos p = do
  putStrLn ("  == " ++ show p ++ "  " ++ gloss p)
  let pool = sortOn (\(a,b) -> (tsize a + tsize b, (a,b))) (inPos p)
      k = max 1 (length pool `div` max 1 n)
      sample = take n [ e | (i, e) <- zip [(0::Int)..] pool, i `mod` k == 0 ]
  vs <- mapM (\e@(l, r) -> do
                v <- C.certifyWith [] "." ((toCert l, toCert r), "")
                let isRefl = case v of C.Certified "refl" 1 -> True ; _ -> False
                    ok = isRefl == underK p
                putStrLn ("     " ++ (if ok then "  " else "!!") ++ " "
                          ++ show l ++ " = " ++ show r ++ "   -> " ++ show v)
                pure ok)
             sample
  pure (length (filter id vs), length vs)

-- The negative controls, all three of which must hold or nothing above is
-- worth reading.
selfTest :: [Eqn] -> [Eqn] -> IO ()
selfTest reach demanded = do
  let false   = [ e | e <- reach, not (B.semanticsAgree e) ]
      cappedM = [ e | e@(l,r) <- reach, not (snd (nfM l)) || not (snd (nfM r)) ]
      cappedK = [ e | e@(l,r) <- reach, not (snd (nfK l)) || not (snd (nfK r)) ]
      kJoinedDemand = [ g | g <- demanded, underK (sthanaOf g) ]
  putStrLn "  SELF-TEST"
  putStrLn ("    reach equations disagreeing with the semantics: " ++ show (length false)
            ++ "   (must be 0: composition and specialisation cannot make a truth false)")
  putStrLn ("    normalisations that hit the budget, M: " ++ show (length cappedM)
            ++ "   K: " ++ show (length cappedK)
            ++ "   (must be 0,0: a capped run is not a normal form)")
  putStrLn ("    demanded lemmas K claims are already refl: " ++ show (length kJoinedDemand)
            ++ " of " ++ show (length demanded)
            ++ "   (must be 0: the kernel STALLED on every one of them, so a K"
            ++ " that joins one is a K that is wrong about agda)")
  mapM_ (\(a,b) -> putStrLn ("      !! " ++ show a ++ " = " ++ show b)) kJoinedDemand
