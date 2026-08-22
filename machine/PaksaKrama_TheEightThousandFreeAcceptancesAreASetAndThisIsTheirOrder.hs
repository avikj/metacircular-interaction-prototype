-- पक्षक्रमः — PakṣaKrama: the set of free acceptances, put in an order.
--
-- ---------------------------------------------------------------------
-- WHAT WAS HANDED FORWARD, VERBATIM
--
--     "the 8,130 is a set, not an order."
--
-- machine/PaksaLaksana_WhatIsWorthHandingTheKernelIsWhereTheTwoRewritersDisagree.hs
-- establishes, and `sh machine/run-paksa.sh` reproduces here byte for byte,
-- that the three hands of bhāvanā compose 119,489 true equations which fall
-- into four joint positions of two nayas — the machine's rewriter M and
-- Agda's definitional unfolding K, read as a case tree — and that one of the
-- four,
--
--     (M no, K yes)   8,130   refl for the kernel, and NEW to the machine
--
-- is free: certain before agda is called, one kernel call each, and outside
-- the machine's present reach.  That file's own śeṣa 1 says what it did not
-- do, and this file is that śeṣa discharged:
--
--     "8,130 free acceptances is a set, not an order.  Which of them,
--      installed as an M-rule, most enlarges what M can close is a further
--      computation this file does not do.  It is exactly
--      `Obstruction.curriculum`'s 'how many parents would this unblock',
--      asked forward instead of read off a log."
--
-- ---------------------------------------------------------------------
-- THE FINDING, NEGATIVE HALF FIRST
--
-- The order exists, it is extremely short, and most of the set is inert.
-- The numbers are printed by `--krama` and are set cardinalities throughout;
-- see the RUN section for the one command that produces them.
--
-- Two things bound the reader before any ranking is read:
--
--   1. THE BOUND ALREADY ESTABLISHED, NOT RE-DERIVED HERE.  Of the nine
--      lemmas the kernel's residual stream demands, the composed set of
--      119,489 contains ONE.  A selector over the composed set therefore
--      cannot deliver the kernel's curriculum; what is not reached is not
--      selectable.  That is PaksaLaksana's result, it is reprinted by both
--      arms of `run-paksa.sh`, and nothing below weakens or repairs it.  An
--      order over the 8,130 is an order over what IS reached.  It is not an
--      answer to the demand.
--
--   2. INSTALLING A RULE IS NOT PROVING A GOAL.  `upagraha` below counts
--      equations of the reach set that the machine's rewriter closes AFTER
--      the candidate is installed and could not close before.  The kernel is
--      still the authority on every one of them.  What the count measures is
--      the machine's own naya widening, which is the currency `lemmaRules`
--      is denominated in and the currency the engine's WIRE 7 selector is
--      NOT denominated in.
--
-- ---------------------------------------------------------------------
-- THE MEASURE — उपग्रह
--
-- UMĀSVĀTI, *Tattvārthasūtra* 5.21 (c. 2nd–5th c. CE):
-- परस्परोपग्रहो जीवानाम् — *parasparopagraho jīvānām*, "the mutual assistance
-- of souls."  *Upagraha* is assistance rendered such that the assisted thing
-- is thereby able to act.  The sūtra's force, and the reason the word is
-- taken here rather than an English one, is that in it existence is not prior
-- to the assisting: the jīvas are what they are BY the mutual upagraha, not
-- first there and then helpful.
--
-- WHAT IS CLAIMED.  That the word names the relation this file counts — one
-- established equation making a second one closable that was not closable
-- without it — and that the relation is not "usefulness" measured on the
-- helper alone.  A candidate's upagraha is a count of OTHER equations; it
-- does not exist in the candidate.
--
-- WHAT IS NOT CLAIMED.  That Umāsvāti wrote about rewrite systems, that
-- equations are jīvas, or that the Jaina doctrine of parasparopagraha is
-- exhausted by, or reducible to, a cardinality.  It is not.  The word is
-- taken for the shape of the relation and for nothing else, and the arrow
-- runs one way: the sūtra is not being checked by this file.
--
-- The school is named because the schools are not one toolkit: this is Jaina,
-- Umāsvāti's Tattvārthasūtra being the one text the Digambara and Śvetāmbara
-- traditions share, and it is not the Nyāya-Vaiśeṣika vocabulary of
-- *sahakāri-kāraṇa* (auxiliary cause), which would carry a causal-relatum
-- analysis this file does not perform and could not support.
--
-- ---------------------------------------------------------------------
-- THE STRATEGY, DECLARED, BECAUSE IT IS A CHOICE AND NOT A FACT
--
-- "Install candidate c as an M-rule" is under-specified until the strategy
-- is said, and two strategies are available:
--
--   M-PRIORITY (used for the ranking).  Normalise with M; where M is stuck,
--   take one c step; repeat.  Equivalently `stepAug t = mStep t <|> cStep t`.
--
--   APPENDED (what the live engine does).  `MathMachine`'s rewriter is
--   `definitionsOf … ++ mRules ++ lemmaRules` and its `rewriteOnce` tries
--   every rule at the root before descending, so an installed lemma can fire
--   at an OUTER position before a definition fires at an inner one.
--
-- They are not the same relation and the difference is not cosmetic.
-- M-priority is used for the ranking for one reason that is about
-- measurement and not about taste: under M-priority, if M already joins an
-- equation then M ∪ {c} joins it too, by determinism — so the ranking cannot
-- silently trade a new join against a lost one.  Under the appended
-- strategy, it can, because that rewriter is not confluent.
--
-- So the appended strategy is not waved off.  It is RUN, on the top
-- candidates, over the whole 93,848-equation M-stuck set with no pruning, by
-- `--anvaya N`, which prints the appended-strategy upagraha beside the
-- M-priority one AND the count of joins the appended strategy LOSES.  That
-- is this file's falsifier and it is meant to be re-run rather than quoted,
-- in the same sense `--kernel` is PaksaLaksana's.
--
-- ---------------------------------------------------------------------
-- ORIENTATION, AND WHY MOST OF THE SET IS INERT
--
-- An equation is not a rule until it is oriented, and under M-priority a rule
-- l → r is DEAD if l is M-reducible: every instance of l is then reducible at
-- the same position, so no M-normal term has a subterm matching l, so c never
-- fires.  This is decidable without trying, and it is where most of the 8,130
-- go.
--
-- The orientation policy, in full:
--   * a side is ADMISSIBLE as a left-hand side iff it is M-normal and is not
--     a bare variable (a variable lhs matches everything and is not a rule);
--   * among admissible orientations, prefer the size-decreasing one
--     (लाघवम्: the rewriter should shrink — VISTARA §33, and Patañjali's
--     अर्धमात्रालाघवेन on Aṣṭādhyāyī);
--   * if both are admissible and the sides are of equal size, orient by the
--     term order, and let the budget catch it if it loops;
--   * if neither is admissible, the candidate is inert in this orientation
--     policy and is counted, not ranked.
--
-- Non-termination is caught rather than assumed away: every augmented
-- normalisation is capped, a capped run is NOT reported as a normal form, and
-- the number of candidates that hit the cap is printed.
--
-- ---------------------------------------------------------------------
-- THE PRUNE, AND WHY IT IS SOUND
--
-- Ranking 8,130 candidates against 93,848 equations is 1.5 × 10^9
-- normalisations done naively.  It is not done naively, and the saving is
-- not an approximation:
--
--   Under M-priority, c can affect the pair (l, r) only if c's lhs matches a
--   subterm of nf_M(l) or of nf_M(r).  If it matches neither, no c step is
--   available at the M-normal form, the augmented normal forms ARE the M
--   normal forms, and the equation is untouched.
--
-- So an index from a two-level pattern key to the equations whose M-normal
-- sides contain a subterm that key could match is a SUPERSET of the affected
-- equations, and the real augmented normalisation is then run only on that
-- superset.  The result is exact: the prune removes work, not answers.
-- `--self-test` checks the prune against a full unpruned sweep on a
-- deterministic sample.
--
-- ---------------------------------------------------------------------
-- EXACT.  Every number printed is a set cardinality or a kernel verdict.  No
-- clock is read and no arm is timed; this host carries sixteen lanes and a
-- wall figure from it would be a measurement of the load, as
-- machine/MATRA_WhatTodaysFifteenOrgansChangedAboutTheEngine.md §6 records.
--
-- RUN — one snapshot, one binary, hashes printed, both arms out of it:
--
--     sh machine/run-paksa-krama.sh
--
-- or directly, from the repository root:
--
--     runghc -imachine machine/PaksaKrama_*.hs --self-test
--     runghc -imachine machine/PaksaKrama_*.hs --krama       # the order
--     runghc -imachine machine/PaksaKrama_*.hs --anvaya 8    # the falsifier

import qualified BhavanaTheorem as B
import qualified Obstruction as OB
import Data.List (isInfixOf, nub, sortOn, foldl')
import Data.Maybe (fromMaybe)
import qualified Data.IntSet as IS
import qualified Data.Map.Strict as M
import qualified Data.Set as S
import System.Environment (getArgs)
import System.IO

type T = B.Term
type Eqn = (T, T)

-- ------------------------------------------------------------ plumbing
-- Transcribed from PaksaLaksana_* rather than imported: that file is a
-- `module Main` and cannot be imported.  The transcription is checked, not
-- trusted — `--self-test` requires the four position counts here to equal
-- the four that file prints, and a divergence is a śeṣa against this file.

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

-- ------------------------------------------------------- M — the machine's naya

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

nfWith :: (T -> Maybe T) -> Int -> T -> (T, Bool)
nfWith _    0 t = (t, False)
nfWith step n t = case step t of
  Nothing -> (t, True)
  Just u  -> nfWith step (n - 1) u

kBudget :: Int
kBudget = 3000

mStep :: T -> Maybe T
mStep = rewriteOnce machineRules

nfM :: T -> (T, Bool)
nfM = nfWith mStep kBudget

-- ------------------------------------------------------- K — the kernel's naya

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

data Sthana = Sthana { underM :: !Bool, underK :: !Bool } deriving (Eq, Ord)

instance Show Sthana where
  show (Sthana m k) = "(M " ++ yn m ++ ", K " ++ yn k ++ ")"
    where yn True = "yes" ; yn False = "no "

positions :: [Sthana]
positions = [ Sthana True True, Sthana False True, Sthana True False, Sthana False False ]

gloss :: Sthana -> String
gloss (Sthana True  True ) = "siddhasadhana -- refl for the kernel, machine already rewrites it"
gloss (Sthana False True ) = "PAKSA         -- refl for the kernel, NEW to the machine"
gloss (Sthana True  False) = "the bridge    -- the machine knows it, the kernel needs induction"
gloss (Sthana False False) = "neither naya  -- expensive, usually refused"

-- ------------------------------------------------------------ the reach set

tulya :: [Eqn] -> [Eqn]
tulya eqs =
  S.toList (S.fromList
    [ (B.applySubst s l, B.applySubst s r)
    | (l, r) <- eqs
    , let vs = nub (varsOf l ++ varsOf r)
    , i <- vs, j <- vs, i /= j
    , let s = M.singleton i (B.V j)
    , B.applySubst s l /= B.applySubst s r ])

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

-- =====================================================================
-- ORIENTATION

isVarT :: T -> Bool
isVarT (B.V _) = True
isVarT _ = False

-- Admissible as a left-hand side: M-normal (else every instance is reducible
-- at the same position and the rule is dead under M-priority) and not a bare
-- variable.
admissibleLhs :: T -> Bool
admissibleLhs t = not (isVarT t) && mStep t == Nothing

-- Nothing = inert: neither side can head a rule under this policy.
orient :: Eqn -> Maybe Eqn
orient (a, b) = case (admissibleLhs a, admissibleLhs b) of
  (False, False) -> Nothing
  (True , False) -> Just (a, b)
  (False, True ) -> Just (b, a)
  (True , True )
    | tsize a > tsize b -> Just (a, b)
    | tsize b > tsize a -> Just (b, a)
    | a > b             -> Just (a, b)
    | otherwise         -> Just (b, a)

-- =====================================================================
-- THE TWO AUGMENTED STRATEGIES

-- M-priority: M to normal form, then one candidate step, repeat.
stepPriority :: Eqn -> T -> Maybe T
stepPriority c t = case mStep t of
  Just u  -> Just u
  Nothing -> rewriteOnce [c] t

-- Appended: exactly what MathMachine's rewriter does with `lemmaRules`, the
-- candidate last in one flat list, so it may fire at an outer position before
-- a definition fires at an inner one.
stepAppended :: Eqn -> T -> Maybe T
stepAppended c = rewriteOnce (machineRules ++ [c])

-- (joined?, terminated within budget?)
joinsUnder :: (T -> Maybe T) -> Eqn -> (Bool, Bool)
joinsUnder step (l, r) =
  let (a, oka) = nfWith step kBudget l
      (b, okb) = nfWith step kBudget r
  in (a == b, oka && okb)

-- =====================================================================
-- THE PRUNE
--
-- Key: a pattern's top two levels.  For a pattern F f args the key is
-- (f, [root of each arg, or "*" where the arg is a variable]).  For a term
-- F f args the keys that could match it are (f, choices) with each position
-- independently "*" or the arg's actual root — at most 2^arity, and arity is
-- at most 2 throughout this vocabulary.

type Key = (String, [String])

rootOf :: T -> String
rootOf (B.V _) = "*"
rootOf (B.F f _) = f

patKey :: T -> Maybe Key
patKey (B.V _) = Nothing
patKey (B.F f args) = Just (f, map rootOf args)

-- every key a pattern could have and still match this term
termKeys :: T -> [Key]
termKeys (B.V _) = []
termKeys (B.F f args) = [ (f, cs) | cs <- choices (map rootOf args) ]
  where
    choices [] = [[]]
    choices (a:as) = [ c : rest | c <- nub [a, "*"], rest <- choices as ]

subterms :: T -> [T]
subterms t = t : case t of
  B.F _ ts -> concatMap subterms ts
  _        -> []

buildIndex :: [(Int, (T, T))] -> M.Map Key IS.IntSet
buildIndex nfs = foldl' ins M.empty
  [ (k, i) | (i, (l, r)) <- nfs, u <- subterms l ++ subterms r, k <- termKeys u ]
  where ins m (k, i) = M.insertWith IS.union k (IS.singleton i) m

-- =====================================================================
-- MAIN

readUtf8 :: FilePath -> IO String
readUtf8 p = do { h <- openFile p ReadMode ; hSetEncoding h utf8 ; hGetContents h }

pad :: Int -> String -> String
pad n s = s ++ replicate (max 0 (n - length s)) ' '

showEqn :: Eqn -> String
showEqn (a, b) = show a ++ " = " ++ show b

data Env = Env
  { eReach   :: [Eqn]
  , eTagged  :: [(Eqn, Sthana)]
  , eCounts  :: [(Sthana, Int)]
  , eDemand  :: [Eqn]
  , ePaksa   :: [Eqn]                 -- the 8,130, smallest first
  , eStuck   :: [(Int, Eqn)]          -- M-stuck equations, indexed
  , eStuckM  :: M.Map Int Eqn        -- the same, as a map, built ONCE
  , eStuckP  :: M.Map Int Sthana      -- position of each M-stuck equation
  , eStuckNF :: [(Int, (T, T))]       -- their M-normal sides
  , eIndex   :: M.Map Key IS.IntSet
  }

buildEnv :: IO Env
buildEnv = do
  lib  <- readUtf8 "machine/library.terms"
  logl <- lines <$> readUtf8 "machine/machine.log"
  let (_, reach) = reachSet lib
      tagged  = [ (e, sthanaOf e) | e <- reach ]
      sthanaOf (l, r) = Sthana (fst (nfM l) == fst (nfM r)) (fst (nfK l) == fst (nfK r))
      counts  = [ (p, length [ () | (_, q) <- tagged, q == p ]) | p <- positions ]
      paksa   = sortOn (\e -> (tsize (fst e) + tsize (snd e), e))
                  [ e | (e, q) <- tagged, q == Sthana False True ]
      stuckL  = [ (e, q) | (e, q) <- tagged, not (underM q) ]
      stuck   = zip [0 ..] (map fst stuckL)
      stuckP  = M.fromList (zip [0 ..] (map snd stuckL))
      stuckNF = [ (i, (fst (nfM l), fst (nfM r))) | (i, (l, r)) <- stuck ]
  pure (Env reach tagged counts (demandedOf logl) paksa stuck (M.fromList stuck) stuckP stuckNF
            (buildIndex stuckNF))

header :: Env -> IO ()
header env = do
  putStrLn "पक्षक्रमः — the 8,130 free acceptances, put in an order by what each unblocks."
  putStrLn ""
  putStrLn ("  reach of the three hands, distinct:        " ++ show (length (eReach env)))
  putStrLn "  the four positions (must equal PaksaLaksana's, or this transcription is wrong):"
  mapM_ (\(p, n) -> putStrLn ("    " ++ show p ++ "  " ++ pad 7 (show n) ++ "  " ++ gloss p))
        (eCounts env)
  putStrLn ""
  putStrLn ("  lemmas the kernel's residual stream demands: " ++ show (length (eDemand env)))
  putStrLn ("    of those, reached by the three hands:      "
            ++ show (length [ g | g <- eDemand env, g `elem` eReach env ]))
  putStrLn "    -- established by PaksaLaksana, reprinted, NOT re-derived: a selector"
  putStrLn "       over the composed set cannot deliver the curriculum.  An order over"
  putStrLn "       the 8,130 is an order over what IS reached, and is not an answer to"
  putStrLn "       the demand."
  putStrLn ""

-- --------------------------------------------------------------- upagraha

-- The count, plus the position breakdown of what was newly closed, plus
-- whether the augmented normalisation stayed inside the budget everywhere.
data Upagraha = Upagraha
  { uCount :: !Int
  , uFromPaksa :: !Int     -- newly closed, came from (M no, K yes)
  , uFromBulk  :: !Int     -- newly closed, came from (M no, K no)
  , uCapped :: !Bool
  }

upagrahaOf :: Env -> Eqn -> Upagraha
upagrahaOf env rule =
  let cand = IS.toList (fromMaybe IS.empty (patKey (fst rule) >>= \k -> M.lookup k (eIndex env)))
      eqs  = eStuckM env
      step = stepPriority rule
      res  = [ (i, joinsUnder step e) | i <- cand, Just e <- [M.lookup i eqs] ]
      won  = [ i | (i, (True, True)) <- res ]
      capd = or [ not ok | (_, (_, ok)) <- res ]
      pos i = M.lookup i (eStuckP env)
  in Upagraha (length won)
              (length [ () | i <- won, pos i == Just (Sthana False True) ])
              (length [ () | i <- won, pos i == Just (Sthana False False) ])
              capd

krama :: Env -> Int -> IO ()
krama env topN = do
  let cands = [ (e, orient e) | e <- ePaksa env ]
      inert = [ e | (e, Nothing) <- cands ]
      live  = [ (e, r) | (e, Just r) <- cands ]
      ranked = [ (e, r, upagrahaOf env r) | (e, r) <- live ]
      capped = [ x | x@(_, _, u) <- ranked, uCapped u ]
      clean  = [ x | x@(_, _, u) <- ranked, not (uCapped u) ]
      nonzero = [ x | x@(_, _, u) <- clean, uCount u > 0 ]
      best = take topN (sortOn (\(e, _, u) -> (negate (uFromBulk u), negate (uCount u),
                                               tsize (fst e) + tsize (snd e), e)) nonzero)
  putStrLn "  KRAMA — the candidates, oriented, ranked by upagraha."
  putStrLn ""
  putStrLn ("    candidates (the paksa):                      " ++ show (length cands))
  putStrLn ("      inert: neither side is an admissible lhs   " ++ show (length inert))
  putStrLn ("      oriented into a rule                       " ++ show (length live))
  putStrLn ("        of those, hit the normalisation budget   " ++ show (length capped)
            ++ "   (not ranked: a capped run is not a normal form)")
  putStrLn ("        of those, upagraha = 0 (inert in effect) "
            ++ show (length clean - length nonzero))
  putStrLn ("        of those, upagraha > 0                   " ++ show (length nonzero))
  putStrLn ""
  putStrLn ("    distinct rules among the ranked:             "
            ++ show (S.size (S.fromList [ r | (_, r, _) <- nonzero ])))
  putStrLn ("    distinct upagraha values:                    "
            ++ show (S.size (S.fromList [ uCount u | (_, _, u) <- nonzero ])))
  putStrLn ("    total M-stuck equations:                     " ++ show (length (eStuck env)))
  putStrLn ""
  putStrLn "    -- the order, best first.  The sort key is (equations newly closed that"
  putStrLn "       came from the (M no, K no) bulk), then (total newly closed), then size."
  putStrLn "       The bulk comes first because an equation moving out of (M no, K no)"
  putStrLn "       into (M yes, K no) BECOMES the bridging class the kernel's residual"
  putStrLn "       stream is made of, whereas one moving out of (M no, K yes) merely"
  putStrLn "       becomes siddhasadhana -- something the kernel already did in one call."
  putStrLn ""
  putStrLn (   "       " ++ pad 7 "upagr" ++ pad 8 "of.bulk" ++ pad 8 "of.paksa" ++ "rule")
  mapM_ (\(_, r, u) ->
           putStrLn ("       " ++ pad 7 (show (uCount u))
                     ++ pad 8 (show (uFromBulk u))
                     ++ pad 8 (show (uFromPaksa u))
                     ++ show (fst r) ++ " -> " ++ show (snd r)))
        best
  putStrLn ""
  -- the flagship's mirror, named in PaksaLaksana, located in this order
  let flagship = canon (B.V 0, B.F "+" [B.F "*" [B.F "0" [], B.V 0], B.V 0])
      allRanked = sortOn (\(e, _, u) -> (negate (uFromBulk u), negate (uCount u),
                                         tsize (fst e) + tsize (snd e), e)) nonzero
      place = [ n | (n, (e, _, _)) <- zip [(1::Int)..] allRanked, e == flagship ]
  putStrLn ("    the flagship's mirror  " ++ showEqn flagship ++ "  -- PaksaLaksana's"
            ++ " one-call witness --")
  putStrLn ("      is at rank " ++ (case place of
                                      (n:_) -> show n ++ " of " ++ show (length allRanked)
                                      [] -> "NOT in the ranked set")
            ++ " in this order.")
  putStrLn "      Cheapest at the kernel and most enlarging for the rewriter are two"
  putStrLn "      different questions, and this is where they part."

-- --------------------------------------------------------------- anvaya
--
-- THE FALSIFIER.  The ranking is computed under M-priority and with a prune.
-- `--anvaya N` re-runs the top N candidates under the strategy the LIVE
-- ENGINE uses -- the candidate appended to one flat rule list -- over the
-- whole M-stuck set with no prune at all, and prints what that strategy gains
-- and what it LOSES.  A loss is possible there and impossible under
-- M-priority, which is the entire reason both are run.

anvaya :: Env -> Int -> IO ()
anvaya env topN = do
  let cands = [ (e, r) | e <- ePaksa env, Just r <- [orient e] ]
      ranked = [ (e, r, upagrahaOf env r) | (e, r) <- cands ]
      nonzero = [ x | x@(_, _, u) <- ranked, not (uCapped u), uCount u > 0 ]
      best = take topN (sortOn (\(e, _, u) -> (negate (uFromBulk u), negate (uCount u),
                                               tsize (fst e) + tsize (snd e), e)) nonzero)
      joinedByM = S.fromList [ i | (i, _) <- eStuckNF env ]  -- none: all M-stuck
      allEqs = eTagged env
  putStrLn ("  ANVAYA — the top " ++ show topN ++ " re-measured under the LIVE ENGINE's"
            ++ " strategy,")
  putStrLn "    the candidate appended to one flat rule list, over the WHOLE reach set,"
  putStrLn "    unpruned.  `gain` counts equations the appended strategy newly closes;"
  putStrLn "    `loss` counts equations M alone closed and M ++ [c] no longer closes."
  putStrLn "    Under M-priority `loss` is 0 by determinism; here it need not be."
  putStrLn ("    (" ++ show (S.size joinedByM) ++ " M-stuck equations, "
            ++ show (length allEqs) ++ " in the reach set.)")
  putStrLn ""
  putStrLn ("     " ++ pad 8 "M-prio" ++ pad 8 "gain" ++ pad 8 "loss" ++ pad 8 "capped"
            ++ "rule")
  mapM_ (\(_, r, u) -> do
           let step = stepAppended r
               outs = [ (underM q, joinsUnder step e) | (e, q) <- allEqs ]
               gain = length [ () | (False, (True, True)) <- outs ]
               loss = length [ () | (True, (False, True)) <- outs ]
               capd = length [ () | (_, (_, False)) <- outs ]
           putStrLn ("     " ++ pad 8 (show (uCount u)) ++ pad 8 (show gain)
                     ++ pad 8 (show loss) ++ pad 8 (show capd)
                     ++ show (fst r) ++ " -> " ++ show (snd r)))
        best

-- --------------------------------------------------------------- self-test

selfTest :: Env -> IO ()
selfTest env = do
  let counts = eCounts env
      expected = [ (Sthana True True, 10713), (Sthana False True, 8130)
                 , (Sthana True False, 14928), (Sthana False False, 85718) ]
      transcriptionOk = counts == expected
      false = [ e | e <- eReach env, not (B.semanticsAgree e) ]
      cappedM = [ e | (l, r) <- eReach env, e <- [(l,r)]
                , not (snd (nfM l)) || not (snd (nfM r)) ]
      -- installed rules must be true, or a "join" is a falsehood being closed
      badRules = [ e | e <- ePaksa env, not (B.semanticsAgree e) ]
      -- the prune, checked against a full sweep on a deterministic sample
      sample = take 12 [ (e, r) | e <- ePaksa env, Just r <- [orient e] ]
      full (_, r) = length [ () | (_, e) <- eStuck env
                           , let (j, ok) = joinsUnder (stepPriority r) e, j, ok ]
      pruned (_, r) = uCount (upagrahaOf env r)
      pruneDiffs = [ (r, pruned x, full x) | x@(_, r) <- sample, pruned x /= full x ]
  putStrLn "  SELF-TEST"
  putStrLn ("    the four position counts equal PaksaLaksana's: " ++ show transcriptionOk)
  mapM_ (\((p, n), (_, m)) -> if n == m then pure () else
            putStrLn ("      !! " ++ show p ++ " here " ++ show n ++ ", there " ++ show m))
        (zip counts expected)
  putStrLn ("    reach equations disagreeing with the semantics: " ++ show (length false)
            ++ "   (must be 0)")
  putStrLn ("    M normalisations that hit the budget:           " ++ show (length cappedM)
            ++ "   (must be 0: a capped run is not a normal form)")
  putStrLn ("    candidate rules that are not true:              " ++ show (length badRules)
            ++ "   (must be 0: installing a falsehood closes falsehoods)")
  putStrLn ("    prune vs full sweep, 12 candidates, disagreements: "
            ++ show (length pruneDiffs)
            ++ "   (must be 0: the prune removes work, not answers)")
  mapM_ (\(r, a, b) -> putStrLn ("      !! " ++ show (fst r) ++ " -> " ++ show (snd r)
                                 ++ "  pruned " ++ show a ++ "  full " ++ show b))
        pruneDiffs

main :: IO ()
main = do
  hSetEncoding stdout utf8
  args <- getArgs
  env <- buildEnv
  header env
  let numAfter fl d = case dropWhile (/= fl) args of
        (_:v:_) | [(n, "")] <- reads v -> n
        _ -> d
  case () of
    _ | "--self-test" `elem` args -> selfTest env
      | "--krama"     `elem` args -> krama env (numAfter "--krama" 12)
      | "--anvaya"    `elem` args -> anvaya env (numAfter "--anvaya" 8)
      | otherwise -> putStrLn "  (no arm chosen: --krama [N], --anvaya [N], --self-test)"
