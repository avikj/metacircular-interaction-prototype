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

-- PairVocab — the prime-pair field as an executable vocabulary for the
-- natural machine.
--
-- WHAT THIS IS.  MathMachine generates terms over {0,s,+,*,max,-,gcd,le} and
-- ArithVocab extends that with {gcd,mod,lcm,v_p}.  Neither can state the
-- corpus's own central object: a PAIR in centre/radius coordinates.  A pair
-- is two legs
--
--     p = w - r          q = w + r
--
-- and the three identities that hold over ANY commutative ring are
--
--     (1)  p + q          = 2w
--     (2)  p * q          = w^2 - r^2          (the split norm)
--     (3)  (p+q)^2 - 4pq  = 4r^2               (the discriminant)
--
-- All three are already PROVED, over an arbitrary commutative ring, in
-- `formal/cubical/NaturalMachine/PairCoordinates.agda` (`e1=2w`,
-- `e2=splitNorm`, `disc=4r^2`, and `splitNorm` itself), by the commutative-
-- ring solver, --safe, no postulates, no holes.  Nothing here reproves them
-- and nothing here could: a finite check over Integer is a statement about a
-- finite range, never about a ring.  What this module does is make the object
-- EXECUTABLE for the engine — exact evaluators, machine `Sym`s, installable
-- rewrite rules — and then exhibit, on concrete numbers, the fact that gives
-- the object its standing in this corpus.
--
-- THE HINGE.  Identity (2) is the difference of two squares, and it is read
-- in two directions:
--
--   * FIX THE SUM 2w and ask which r make both legs prime.  That is
--     Goldbach's question for the even number 2w.
--   * FIX THE PRODUCT n and climb w from ceil(sqrt n) until w^2 - n is a
--     perfect square.  That is Fermat's factorisation method.
--
-- One conic, two readings, distinguished only by which coordinate is held
-- fixed.  `formal/cubical/EGBPairConic.agda` states exactly this framing for
-- the N-with-order chart (and records the hypothesis r <= w that truncated
-- subtraction forces).  Section 6 below exhibits the two readings meeting on
-- the SAME lattice point on concrete numbers, and section 7 verifies that
-- meeting exhaustively over a stated range.
--
-- WHAT IS NOT CLAIMED.  Nothing here proves Goldbach, or anything at all
-- about primes in general.  No statement below is asymptotic.  In particular:
--
--   * the identity checks are finite exhaustive verifications over the ranges
--     printed by `main`, and prove exactly those finitely-bounded statements;
--     the unbounded (ring) theorems are the Agda module's, by its proofs;
--   * `goldbachWitnesses w` returning a non-empty list for every w in a range
--     is a statement about that range and no more.  It is not evidence for
--     the conjecture, it is not offered as evidence, and the self-test does
--     not report it as a trend;
--   * the cost section (section 8) compares two algorithms under ONE counting
--     model, at named n.  Its iteration counts are not measured constants:
--     both are derived in closed form (`fermatItersFormula`,
--     `trialItersFormula`) and the counters are used only to CONFIRM the
--     derivation exhaustively over a stated range.  There is no fitted slope
--     anywhere and no claim about growth.
--
-- PROTOCOL (CLAUDE.md).  Exact integer arithmetic everywhere; no Double, no
-- Float, no `fromIntegral` into a float, no logarithm, no wall-clock reading.
-- Square roots are integer Newton iteration (`isqrt`), audited against its own
-- specification over a stated range.  Every claimed range is printed.  Every
-- verification ships with a FALSIFIER — a deliberately wrong variant that the
-- SAME checker rejects — so that an empty failure list cannot be read as a
-- vacuous check.
--
-- PRIOR ART (PROTOCOL §0), searched before writing, under standard names:
-- "Fermat's factorization method", "difference of two squares", "Goldbach
-- conjecture", grepped across `notes/`, `formal/cubical/`, `formal/pairfield/`
-- and `machine/`.  Both algorithms are classical and are cited as classical:
-- Fermat's method is 17th century; the centre/radius (mean/half-difference)
-- coordinates are the standard completing-the-square change of variables.  In
-- this repository the framing already exists in Agda (`EGBPairConic`,
-- `NaturalMachine.PairCoordinates`) and in Lean (`formal/pairfield/`,
-- Goldbach* modules); no Haskell implementation of either reading existed
-- before this file (`grep -rl fermatFactor` was empty).  A successor need not
-- repeat that search; what would be worth searching is whether the
-- closest-divisor closed form for Fermat's iteration count (section 8) has a
-- standard citation — it is folklore-obvious and is claimed here only as
-- derived, not as new.
--
-- LAYOUT.  §1 term algebra and Sym (mirrored from ArithVocab, so these terms
-- ARE MathMachine's terms) · §2 exact evaluators · §3 the vocabulary and its
-- installable rewrites · §4 the three identities as finite exhaustive
-- verifications, with falsifiers · §5 the parity obstruction · §6/§7 the two
-- readings · §8 cost · §9 the self-test.

module PairVocab where

import qualified Data.Map.Strict as M
import qualified Prastara_TheSearchSpaceIsGeneratedNotStored as P
import Data.List (intercalate)
import Text.Printf (printf)
import System.Exit (exitFailure, exitSuccess)

-- ============================================================ §1 term algebra
-- Copied from ArithVocab (which copied it from MathMachine) so that the
-- symbols below are the same kind of object as the entries of MathMachine's
-- `vocabulary` and could be appended to it without translation.

data Term = V !Int | F !String [Term] deriving (Eq, Ord)

instance Show Term where
  show = showTerm

showTerm :: Term -> String
showTerm (V i) | i >= 0 && i < 6 = [ "xyzuvw" !! i ]
               | otherwise       = "n" ++ show i
showTerm (F f []) = f
showTerm (F f [a,b])
  | f `elem` ["+","*","sub"] =
      "(" ++ showTerm a ++ opName f ++ showTerm b ++ ")"
  where opName "sub" = "-"
        opName g     = g
showTerm (F f as) = f ++ "(" ++ intercalate "," (map showTerm as) ++ ")"

size :: Term -> Int
size (V _) = 1
size (F _ ts) = 1 + sum (map size ts)

vars :: Term -> [Int]
vars (V i) = [i]
vars (F _ ts) = concatMap vars ts

subsetOf :: [Int] -> [Int] -> Bool
subsetOf a b = all (`elem` b) a

ordNub :: Ord a => [a] -> [a]
ordNub = go M.empty
  where
    go _ [] = []
    go seen (x:xs) | M.member x seen = go seen xs
                   | otherwise = x : go (M.insert x () seen) xs

x_, y_, z_, u_ :: Term
x_ = V 0
y_ = V 1
z_ = V 2
u_ = V 3

-- MACHINE NATIVE SYNTAX.  `showTerm` renders + and * INFIX, and
-- MathMachine's `parseTerm` reads PREFIX only, so a term printed by
-- `showTerm` is not a term the engine can be handed.  Everything §11 emits
-- as a `candidate` line goes through this instead, which is the exact
-- inverse of `MathMachine.termP`.  This is why machine/thoughts.bhavana.math
-- is GENERATED by the self-test and not transcribed: the term this module
-- verifies and the term the engine proves are one object.
nativeTerm :: Term -> String
nativeTerm (V i) | i >= 0 && i < 6 = [ "xyzuvw" !! i ]
                 | otherwise       = "n" ++ show i
nativeTerm (F f []) = f
nativeTerm (F f as) = f ++ "(" ++ intercalate "," (map nativeTerm as) ++ ")"

zero_ :: Term
zero_ = F "0" []

su :: Term -> Term
su t = F "s" [t]

bin :: String -> Term -> Term -> Term
bin f a b = F f [a,b]

-- numerals, for the discriminant D of §3d: it is a NUMERAL in the term
-- language, not a variable, and `num 2` is s(s(0)) and nothing else.
num :: Int -> Term
num k | k <= 0 = zero_
      | otherwise = su (num (k-1))

two_, four_ :: Term
two_ = num 2
four_ = num 4

-- A `Sym` is MathMachine's record verbatim: name, arity, an exact evaluator,
-- and the defining equations the proof kernel may use.
data Sym = Sym { symName :: String
               , symArity :: Int
               , symSem :: [Integer] -> Integer
               , symDefs :: [(Term,Term)] }

type Rule = (Term, Term)

-- ======================================================= §2 exact evaluators
-- All over Integer.  All total.  No floating point anywhere in this module.
--
-- NOTE ON SUBTRACTION.  MathMachine's `-` is TRUNCATED (max 0 (a-b)), because
-- its carrier is N.  This module's carrier is Z — as PairCoordinates.agda's
-- is an arbitrary commutative ring — so it introduces its own symbol `sub`
-- for ring subtraction rather than overloading MathMachine's `-` with a
-- different meaning.  The difference is not cosmetic: under truncation
-- identity (2) is FALSE off the cone r <= w, and §4 exhibits that failure as
-- one of its falsifiers.  This is exactly the hypothesis EGBPairConic.agda
-- carries.

legLo, legHi, splitNorm :: Integer -> Integer -> Integer
legLo w r = w - r
legHi w r = w + r
splitNorm w r = w*w - r*r

-- The inverse change of coordinates.  It needs a halving, and over Z halving
-- is partial: `centre`/`radius` use floor division, so the round trip
-- (p,q) -> (w,r) -> (p,q) holds exactly when p and q have the SAME PARITY.
-- That obstruction is the content of PairCoordinates.agda's `sumIsDouble`
-- (the map (w,r) |-> (w-r,w+r) is not invertible over a general ring) and is
-- exhibited with a witness in §5.  It is deliberately NOT hidden by a
-- convention that would make it look total.
centre, radius :: Integer -> Integer -> Integer
centre p q = (p + q) `div` 2
radius p q = (q - p) `div` 2

-- the truncated-subtraction leg, kept ONLY as the falsifier of §4.
legLoTrunc :: Integer -> Integer -> Integer
legLoTrunc w r = max 0 (w - r)

evLegLo, evLegHi, evCentre, evRadius, evSplitNorm, evSub :: [Integer] -> Integer
evLegLo [w,r] = legLo w r
evLegLo _ = error "leglo: arity"
evLegHi [w,r] = legHi w r
evLegHi _ = error "leghi: arity"
evCentre [p,q] = centre p q
evCentre _ = error "centre: arity"
evRadius [p,q] = radius p q
evRadius _ = error "radius: arity"
evSplitNorm [w,r] = splitNorm w r
evSplitNorm _ = error "splitnorm: arity"
evSub [a,b] = a - b
evSub _ = error "sub: arity"

-- ================================================== §3 the vocabulary itself
-- Order is precedence (later outranks earlier), as in MathMachine and
-- ArithVocab.  The arithmetic core {0,s,+,*} is MathMachine's, with the same
-- evaluators; `sub` is the ring subtraction discussed above; the five pair
-- symbols are new.

subSym, legLoSym, legHiSym, centreSym, radiusSym, splitNormSym :: Sym

subSym = Sym "sub" 2 evSub
  [ (bin "sub" x_ zero_, x_)                    -- a - 0 = a
  , (bin "sub" x_ x_,    zero_) ]               -- a - a = 0

legLoSym = Sym "leglo" 2 evLegLo
  [ (F "leglo" [x_, zero_], x_)                 -- radius 0: the leg is the centre
  , (F "leglo" [x_, y_], bin "sub" x_ y_) ]     -- the definition

legHiSym = Sym "leghi" 2 evLegHi
  [ (F "leghi" [x_, zero_], x_)
  , (F "leghi" [x_, y_], bin "+" x_ y_) ]

-- centre/radius carry NO unconditional defining equation in terms of the legs
-- (that direction is the halving, §5).  What they carry is the round trip in
-- the direction that IS total over Z, installed as a rewrite in §3b.
centreSym = Sym "centre" 2 evCentre
  [ (F "centre" [x_, x_], x_) ]                 -- centre(p,p) = p, exact

radiusSym = Sym "radius" 2 evRadius
  [ (F "radius" [x_, x_], zero_) ]              -- radius(p,p) = 0, exact

splitNormSym = Sym "splitnorm" 2 evSplitNorm
  [ (F "splitnorm" [x_, zero_], bin "*" x_ x_)  -- r = 0: the norm is w^2
  , (F "splitnorm" [x_, y_],
       bin "sub" (bin "*" x_ x_) (bin "*" y_ y_)) ]

vocabulary :: [Sym]
vocabulary =
  [ Sym "0" 0 (const 0) []
  , Sym "s" 1 (\vs -> head vs + 1) []
  , Sym "+" 2 (\vs -> vs!!0 + vs!!1)
      [ (bin "+" x_ zero_, x_) ]
  , Sym "*" 2 (\vs -> vs!!0 * vs!!1)
      [ (bin "*" x_ zero_, zero_) ]
  , subSym
  , legLoSym
  , legHiSym
  , centreSym
  , radiusSym
  , splitNormSym
  ]

pairSymbols :: [Sym]
pairSymbols = [ legLoSym, legHiSym, centreSym, radiusSym, splitNormSym ]

arities :: [Sym] -> [(String,Int)]
arities = map (\s -> (symName s, symArity s))

semantics :: [Sym] -> M.Map String ([Integer] -> Integer)
semantics ss = M.fromList [ (symName s, symSem s) | s <- ss ]

eval :: M.Map String ([Integer] -> Integer) -> [Integer] -> Term -> Integer
eval _ env (V i) = env !! i
eval sem env (F f ts) =
  case M.lookup f sem of
    Just g  -> g (map (eval sem env) ts)
    Nothing -> error ("PairVocab.eval: unknown symbol " ++ show f)

-- ------------------------------------------------------- §3a rewriting
-- The reduction machinery, mirrored from ArithVocab: ordered rewriting under
-- an LPO with a size/precedence fallback, so an unorientable equation still
-- fires only where it shrinks the term.

match :: Term -> Term -> Maybe (M.Map Int Term)
match pat t = go pat t M.empty
  where
    go (V i) u m = case M.lookup i m of
                     Nothing -> Just (M.insert i u m)
                     Just u' -> if u == u' then Just m else Nothing
    go (F f ps) (F g us) m
      | f == g && length ps == length us = foldM' ps us m
    go _ _ _ = Nothing
    foldM' [] [] m = Just m
    foldM' (p:ps) (u:us) m = go p u m >>= foldM' ps us
    foldM' _ _ _ = Nothing

applySub :: M.Map Int Term -> Term -> Term
applySub m (V i) = M.findWithDefault (V i) i m
applySub m (F f ts) = F f (map (applySub m) ts)

precedence :: String -> Int
precedence f =
  case [ i | (i,s) <- zip [0..] vocabulary, symName s == f ] of
    (i:_) -> i
    []    -> -1

cmpTerm :: Term -> Term -> Ordering
cmpTerm (V a) (V b) = compare a b
cmpTerm (V _) (F _ _) = LT
cmpTerm (F _ _) (V _) = GT
cmpTerm s@(F f as) t@(F g bs) =
  compare (size s) (size t)
    <> compare (precedence f) (precedence g)
    <> compare (length as) (length bs)
    <> mconcat (zipWith cmpTerm as bs)

lpo :: Term -> Term -> Bool
lpo s t
  | s == t = False
  | otherwise =
      case (s,t) of
        (V _, _) -> False
        (F _ _, V v) -> v `elem` vars s
        (F f ss, F g ts)
          | any (\si -> si == t || lpo si t) ss -> True
          | precedence f > precedence g && all (lpo s) ts -> True
          | f == g && all (lpo s) ts && lexGt ss ts -> True
          | otherwise -> False
  where
    lexGt (a:as) (b:bs) | a == b = lexGt as bs
                        | otherwise = lpo a b
    lexGt _ _ = False

decreases :: Term -> Term -> Bool
decreases u v
  | lpo u v = True
  | lpo v u = False
  | otherwise = cmpTerm v u == LT

step :: [Rule] -> Term -> Maybe Term
step rs t =
  case t of
    F f ts -> case rewriteArgs ts of
                Just ts' -> Just (F f ts')
                Nothing  -> topStep t
    _ -> topStep t
  where
    topStep u =
      case [ r' | (l,r) <- rs, Just sub <- [match l u]
                , let r' = applySub sub r, decreases u r' ] of
        (a:_) -> Just a
        []    -> Nothing
    rewriteArgs [] = Nothing
    rewriteArgs (a:as) =
      case step rs a of
        Just a' -> Just (a':as)
        Nothing -> fmap (a:) (rewriteArgs as)

normalize :: [Rule] -> Term -> Term
normalize rs = go (200 :: Int)
  where
    go 0 t = t
    go k t = case step rs t of
               Nothing -> t
               Just t' -> go (k-1) t'

orient :: Rule -> Maybe Rule
orient (l,r)
  | l == r = Nothing
  | lpo l r, vars r `subsetOf` vars l = Just (l,r)
  | lpo r l, vars l `subsetOf` vars r = Just (r,l)
  | otherwise = Nothing

-- ------------------------------------------- §3b the installable pair rules
-- Each is one of the three identities, or the total half of the coordinate
-- round trip, in the machine's Rule format: droppable into any [Rule] and fed
-- to `normalize`.  Every one is a theorem of PairCoordinates.agda over an
-- arbitrary commutative ring, hence in particular over Z; §4 re-checks each
-- as an exhaustive finite verification anyway, because a transcription error
-- is not a theorem.

ruleSum, ruleProduct, ruleDisc, ruleCentreRT, ruleRadiusRT :: Rule

-- (1)  leglo(w,r) + leghi(w,r)  ->  2*w
ruleSum = ( bin "+" (F "leglo" [x_,y_]) (F "leghi" [x_,y_])
          , bin "*" (su (su zero_)) x_ )

-- (2)  leglo(w,r) * leghi(w,r)  ->  splitnorm(w,r)
ruleProduct = ( bin "*" (F "leglo" [x_,y_]) (F "leghi" [x_,y_])
              , F "splitnorm" [x_,y_] )

-- (3)  (p+q)^2 - 4pq -> 4r^2, written with the legs substituted so that the
--      left-hand side is a term of the vocabulary.
ruleDisc =
  ( bin "sub"
      (bin "*" (bin "+" (F "leglo" [x_,y_]) (F "leghi" [x_,y_]))
               (bin "+" (F "leglo" [x_,y_]) (F "leghi" [x_,y_])))
      (bin "*" (bin "*" (su (su (su (su zero_))))
                        (F "leglo" [x_,y_]))
               (F "leghi" [x_,y_]))
  , bin "*" (su (su (su (su zero_)))) (bin "*" y_ y_) )

-- the total half of the round trip: centre/radius of a pair BUILT from (w,r)
-- recover (w,r) exactly, over Z, with no parity hypothesis.
ruleCentreRT = ( F "centre" [F "leglo" [x_,y_], F "leghi" [x_,y_]], x_ )
ruleRadiusRT = ( F "radius" [F "leglo" [x_,y_], F "leghi" [x_,y_]], y_ )

pairRules :: [(String,Rule)]
pairRules =
  [ ("sum",       ruleSum)
  , ("product",   ruleProduct)
  , ("disc",      ruleDisc)
  , ("centre-RT", ruleCentreRT)
  , ("radius-RT", ruleRadiusRT)
  ]

-- The rewrite that is NOT installed, and why.  The other half of the round
-- trip — rebuilding the legs from (centre p q, radius p q) — is true exactly
-- when p and q share a parity, and false otherwise (§5 exhibits the witness).
-- A first-order rewrite engine cannot carry that side condition, so putting
-- this in any symbol's `symDefs` would let the kernel derive falsehoods.  It
-- is recorded as a LEMMA, in the same idiom ArithVocab uses for the Euclidean
-- step and for lifting-the-exponent.
lemmaLegRT :: Rule
lemmaLegRT = ( F "leglo" [F "centre" [x_,y_], F "radius" [x_,y_]], x_ )

-- ================================================ §3c THE ℕ CHART
--
-- WHY THIS SECTION EXISTS.  Everything above lives over ℤ, because
-- PairCoordinates.agda's theorems are over an arbitrary commutative ring.
-- MathMachine does not.  Its carrier is ℕ, its `-` is TRUNCATED
-- (`max 0 (a-b)`), and its proof kernel emits Agda over `Cubical.Data.Nat`
-- with `∸`.  So a symbol handed to that engine with a ℤ evaluator would
-- compute one function in Haskell and denote a different one in the emitted
-- certificate — the engine would refute true statements and, worse, could
-- certify a statement it had tested against the wrong function.  This
-- section therefore builds the pair coordinates AS THE ENGINE'S OWN CHART:
-- `∸` everywhere ℤ used `-`, so the Haskell evaluator and the Agda
-- definition are the same function by construction.
--
--     natLegLo w r      = w ∸ r
--     natLegHi w r      = w + r
--     natSplitNorm w r  = (w·w) ∸ (r·r)
--
-- WHAT SURVIVES THE PASSAGE, and this is the content, not a technicality.
-- Of the three ring identities exactly ONE is still unconditionally true
-- over ℕ, and it is the split norm:
--
--     (2)  (w ∸ r) · (w + r)  =  (w·w) ∸ (r·r)        TRUE for all w,r : ℕ
--     (1)  (w ∸ r) + (w + r)  =  2w                   FALSE off the cone r ≤ w
--     (3)  disc                                        FALSE off the cone
--
-- Identity (2) survives because truncation kills both sides together: on
-- r ≤ w it is the ring identity, and on r > w the left factor is 0 while
-- r·r > w·w makes the right side 0 as well.  Identities (1) and (3) have no
-- such coincidence — at w=1, r=3 identity (1) reads 0 + 4 = 2.  §10 checks
-- all three exhaustively over a stated ℕ box, in both directions (the two
-- that fail are their own falsifier controls), so the claim "exactly one
-- survives" is a finite exhaustive verification and not a remark.
--
-- Each symbol carries EXACTLY ONE defining equation, in the UNFOLD
-- direction `f(x,y) = body`, because that is the shape MathMachine's
-- `certDefinitions` turns into an Agda local definition; a symbol with two
-- equations, or with the fold orientation, is emitted as nothing and every
-- statement mentioning it comes back KERNEL-SKIP.  `centre` and `radius`
-- are deliberately ABSENT from this chart: they need a halving, `div` is
-- not in MathMachine's term language and not in the certified Agda
-- fragment, so a `centre` here could only be a black box the engine tests
-- and never reasons about.

natLegLo, natLegHi, natSplitNorm :: Integer -> Integer -> Integer
natLegLo w r = max 0 (w - r)
natLegHi w r = w + r
natSplitNorm w r = max 0 (w*w - r*r)

evNatLegLo, evNatLegHi, evNatSplitNorm :: [Integer] -> Integer
evNatLegLo [w,r] = natLegLo w r
evNatLegLo _ = error "leglo(N): arity"
evNatLegHi [w,r] = natLegHi w r
evNatLegHi _ = error "leghi(N): arity"
evNatSplitNorm [w,r] = natSplitNorm w r
evNatSplitNorm _ = error "splitnorm(N): arity"

natLegLoSym, natLegHiSym, natSplitNormSym :: Sym
natLegLoSym = Sym "leglo" 2 evNatLegLo
  [ (F "leglo" [x_,y_], bin "-" x_ y_) ]
natLegHiSym = Sym "leghi" 2 evNatLegHi
  [ (F "leghi" [x_,y_], bin "+" x_ y_) ]
natSplitNormSym = Sym "splitnorm" 2 evNatSplitNorm
  [ (F "splitnorm" [x_,y_], bin "-" (bin "*" x_ x_) (bin "*" y_ y_)) ]

-- ======================================= §3d THE PELL CHART (BHAVANA)
--
-- BRAHMAGUPTA, Brahmasphutasiddhanta, 628 CE, chapter 18 (kuttaka), the
-- rule called BHAVANA ("production", "composition"):
--
--     (x1^2 - D y1^2) (x2^2 - D y2^2)
--        = (x1 x2 + D y1 y2)^2 - D (x1 y2 + x2 y1)^2.
--
-- In Brahmagupta's own words the rule composes two "bhavita" rows
-- (x1, y1, k1) and (x2, y2, k2) of the equation N x^2 + k = y^2 into a
-- third with k = k1 k2; the samasa-bhavana (sum composition) is the +
-- sign above, the antara-bhavana (difference composition) the -.  It is
-- the multiplicativity of the norm form N(x,y) = x^2 - D y^2, i.e. the
-- group law on the Pell conic, and it is the composition law underlying
-- this repository's pair field.  It predates Brouncker, Wallis, Euler and
-- Lagrange by roughly a thousand years and is not a special case of any of
-- them.  Cited here as Brahmagupta's, not as a footnote to a European
-- restatement.
--
-- WHAT THIS SECTION ADDS, and it is FOUR symbols, not one:
--
--     nrm2(x,y)         = x*x -. 2*(y*y)          the D = 2 norm over ℕ
--     bcx1(x,y,z,u)     = x*z + (y*u)             the D = 1 composed first
--     bcx2(x,y,z,u)     = x*z + 2*(y*u)           the D = 2 composed first
--     bcy(x,y,z,u)      = x*u + (z*y)             the composed second
--
-- reading (x,y) = (x1,y1) and (z,u) = (x2,y2).  `bcy` carries no D: the
-- second component of the composition is D-free, which is one of the two
-- facts that make bhavana a group law rather than a coincidence.
--
-- HOW D IS HANDLED, and why it is a NUMERAL and not a variable.  A
-- variable D would make the norm a THREE-argument symbol and bhavana a
-- FIVE-variable statement, and `agdaVar` spells only six variables
-- (x y z u v w) while the engine's induction prover splits exactly one of
-- them.  Fixing D as a numeral costs the generality and buys a statement
-- the engine can at least be handed.  D = 2 is the classic Pell case
-- (x^2 - 2 y^2 = 1, the side-and-diagonal numbers); D = 1 is the
-- degenerate case where the form factors, and there the norm IS
-- `splitnorm` of §3c, so every D = 1 statement below cross-checks against
-- the one identity WIRE 5 already carried.  The two charts are wired
-- together and share `bcy`.
--
-- THE TRUNCATION PROBLEM, stated exactly because it is the whole content
-- of this section.  Over ℕ, `-` is monus, so `nrm2(x,y)` is not the
-- integer norm: it is `max 0 (x^2 - 2 y^2)`.  Write N1, N2 for the two
-- TRUE (ℤ) norms.  Then
--
--     N1 >= 0, N2 >= 0   both sides are the true product        HOLDS
--     exactly one < 0    left is 0.k = 0, right is max 0 (N1 N2)
--                        with N1 N2 < 0, hence 0                HOLDS
--     both < 0           left is 0.0 = 0, right is N1 N2 > 0    FAILS
--
-- So BHAVANA IS FALSE OVER ℕ AS LITERALLY STATED, and it fails on an
-- explicit region: both norms negative.  The smallest witness at D = 2 is
-- x1 = y1 = x2 = y2 = ... see `bhavanaNatWitness`; §11 finds it by search
-- rather than by assertion.  This is not a defect of the wiring, it is the
-- reason the wiring cannot end at one candidate: the ℕ chart admits
-- bhavana only in the forms below.
--
--   (a) ON THE CONE.  Restricted to pairs with x^2 >= D y^2 the identity
--       holds unconditionally (§11 verifies both the cone and the box).
--       This is exactly the hypothesis EGBPairConic.agda already carries
--       for the split norm, one rung up.
--
--   (b) THE SUBTRACTION-FREE FORM, which is the honest ℕ statement and
--       needs no hypothesis at all.  With a = x1^2, b = D y1^2, c = x2^2,
--       d = D y2^2 and t = x1 x2 y1 y2,
--
--           cx^2 = a c + b d + 2 D t,     D cy^2 = a d + b c + 2 D t,
--
--       so the identity (a-b)(c-d) = cx^2 - D cy^2 is, after moving every
--       negative term across, a statement with NO SUBTRACTION IN IT:
--
--           cx^2 + D x1^2 y2^2 + D x2^2 y1^2
--              = x1^2 x2^2 + D^2 y1^2 y2^2 + D cy^2.
--
--       That is true over ℕ for all four arguments, with no cone, and it
--       is bhavana: over ℤ it is equivalent to the displayed identity by
--       adding the same two terms to both sides.  It is what a ring with
--       no subtraction can say.  §11 verifies it exhaustively at D = 1
--       and D = 2 and machine/thoughts.bhavana.math hands it to the
--       engine as `bhavanaAdd1` / `bhavanaAdd2`.
--
--   (c) THE SCALING CASE y2 = 0, where the second norm is a square and so
--       is never negative.  Composition with (z, 0) reads
--       cx = x z, cy = z y, and bhavana collapses to
--
--           nrm(x,y) * z^2 = nrm(x z, z y),
--
--       which survives monus because monus is right-distributive over
--       multiplication.  Three variables instead of four.
--
-- WORKING OVER ℤ INSTEAD, and what it would cost.  §2 of this file
-- already has the ℤ chart, and over ℤ bhavana is unconditionally true.
-- It cannot be handed to this engine: `Certificate.render` emits
-- `Cubical.Data.Nat` and spells `-` as `∸`, so a ℤ-valued `nrm` would be
-- TESTED as one function in Haskell and CERTIFIED as another in Agda --
-- the precise failure WIRE 5 was built to prevent.  Moving the engine to
-- ℤ is a change to the certificate emitter and the kernel fragment, not
-- to a vocabulary, and nothing here pretends otherwise.

natNrm2 :: Integer -> Integer -> Integer
natNrm2 x y = max 0 (x*x - 2*(y*y))

natBcx1, natBcx2, natBcy :: Integer -> Integer -> Integer -> Integer -> Integer
natBcx1 x1 y1 x2 y2 = x1*x2 + y1*y2
natBcx2 x1 y1 x2 y2 = x1*x2 + 2*(y1*y2)
natBcy  x1 y1 x2 y2 = x1*y2 + x2*y1

evNatNrm2, evNatBcx1, evNatBcx2, evNatBcy :: [Integer] -> Integer
evNatNrm2 [x,y] = natNrm2 x y
evNatNrm2 _ = error "nrm2: arity"
evNatBcx1 [a,b,c,d] = natBcx1 a b c d
evNatBcx1 _ = error "bcx1: arity"
evNatBcx2 [a,b,c,d] = natBcx2 a b c d
evNatBcx2 _ = error "bcx2: arity"
evNatBcy [a,b,c,d] = natBcy a b c d
evNatBcy _ = error "bcy: arity"

-- EXACTLY ONE defining equation each, in the UNFOLD direction, over
-- {0,s,+,*,-} only.  That is what `MathMachine.definingClause` and
-- `certDefinitions` require to emit an Agda local definition; a symbol
-- with two equations, or with the fold orientation, is emitted as nothing
-- and every statement naming it comes back KERNEL-SKIP.  §11 audits all
-- four against their evaluators over [0..8]^arity before the wire.
natNrm2Sym, natBcx1Sym, natBcx2Sym, natBcySym :: Sym
natNrm2Sym = Sym "nrm2" 2 evNatNrm2
  [ (F "nrm2" [x_,y_]
    , bin "-" (bin "*" x_ x_) (bin "*" two_ (bin "*" y_ y_))) ]
natBcx1Sym = Sym "bcx1" 4 evNatBcx1
  [ (F "bcx1" [x_,y_,z_,u_]
    , bin "+" (bin "*" x_ z_) (bin "*" y_ u_)) ]
natBcx2Sym = Sym "bcx2" 4 evNatBcx2
  [ (F "bcx2" [x_,y_,z_,u_]
    , bin "+" (bin "*" x_ z_) (bin "*" two_ (bin "*" y_ u_))) ]
natBcySym = Sym "bcy" 4 evNatBcy
  [ (F "bcy" [x_,y_,z_,u_]
    , bin "+" (bin "*" x_ u_) (bin "*" z_ y_)) ]

bhavanaSymbols :: [Sym]
bhavanaSymbols = [ natNrm2Sym, natBcx1Sym, natBcx2Sym, natBcySym ]

-- The pair symbols the engine may carry, in the order they are appended to
-- MathMachine's `vocabulary` (order is precedence there).  The three of
-- WIRE 5 come FIRST and keep indices 8,9,10; the four Pell symbols are
-- appended, so no recorded normal form changes meaning.
natPairSymbols :: [Sym]
natPairSymbols = [ natLegLoSym, natLegHiSym, natSplitNormSym ] ++ bhavanaSymbols

-- The ambient ℕ vocabulary these are defined against.  Its {0,s,+,*,-}
-- evaluators are MathMachine's, verbatim, so `natFirewallFailures` below is
-- checking the chart against the engine's own arithmetic and not against a
-- second copy of it.
natVocabulary :: [Sym]
natVocabulary =
  [ Sym "0" 0 (const 0) []
  , Sym "s" 1 (\vs -> head vs + 1) []
  , Sym "+" 2 (\vs -> vs!!0 + vs!!1) []
  , Sym "*" 2 (\vs -> vs!!0 * vs!!1) []
  , Sym "-" 2 (\vs -> max 0 (vs!!0 - vs!!1)) []
  ] ++ natPairSymbols

-- ==================================== §4 the identities, finitely verified
-- CLAUDE.md: "Exact / certified symbolic computation is proof and is always
-- allowed: ... A FINITE EXHAUSTIVE VERIFICATION ...".  What each check below
-- PROVES is precisely its own finitely-bounded statement over the range named
-- in the range constants, printed verbatim by `main`.  The unbounded theorems
-- are PairCoordinates.agda's, over an arbitrary commutative ring, by the ring
-- solver.  A bound that is not stated is not a result.

-- Range A: the cone.  w in [0..coneW], r in [0..w].  Legs are non-negative
-- here, which is the regime the two readings of §6 live in.
coneW :: Integer
coneW = 60

-- Range B: a full symmetric box in Z, w and r in [-boxB..boxB], including
-- r > w and negative coordinates.  Identities (1)-(3) are ring identities, so
-- they must survive this too; the truncated-subtraction falsifier must not.
boxB :: Integer
boxB = 30

conePoints :: [(Integer,Integer)]
conePoints = [ (w,r) | w <- [0..coneW], r <- [0..w] ]

boxPoints :: [(Integer,Integer)]
boxPoints = [ (w,r) | w <- [-boxB..boxB], r <- [-boxB..boxB] ]

-- A check is a named pair of exact Integer-valued sides.  `failuresOf` is the
-- one checker used for BOTH the identities and the falsifiers: that is what
-- makes the falsifiers informative, since a falsifier rejected by a different
-- checker would say nothing about this one.
type PairCheck = (Integer,Integer) -> (Integer,Integer)

failuresOf :: [(Integer,Integer)] -> PairCheck -> [((Integer,Integer),Integer,Integer)]
failuresOf pts chk =
  [ ((w,r), lhs, rhs) | (w,r) <- pts, let (lhs,rhs) = chk (w,r), lhs /= rhs ]

-- the three identities
chkSum, chkProduct, chkDisc :: PairCheck
chkSum (w,r)     = ( legLo w r + legHi w r, 2*w )
chkProduct (w,r) = ( legLo w r * legHi w r, splitNorm w r )
chkDisc (w,r)    = ( let s = legLo w r + legHi w r
                         p = legLo w r * legHi w r
                     in s*s - 4*p
                   , 4*r*r )

-- FALSIFIERS.  Deliberately wrong variants, fed to the SAME `failuresOf`.
-- Each must produce a NON-EMPTY failure list; if any of them came back empty
-- the checker would be vacuous and §4's empty lists would mean nothing.  The
-- self-test's exit gate treats a silent falsifier as a failure of the module.
--
--   F1  product identity with a PLUS: p*q =? w^2 + r^2.  Agrees exactly on
--       r = 0, which is why it is a real control rather than a straw man: the
--       range must reach r > 0 for the checker to see it.
--   F2  discriminant with the wrong constant: (p+q)^2 - 4pq =? 2r^2.  Also
--       agrees at r = 0.
--   F3  the MATHEMATICAL falsifier: identity (2) with TRUNCATED subtraction,
--       legLoTrunc w r = max 0 (w-r).  This one is not wrong algebra, it is
--       the same algebra over the wrong carrier, and it fails exactly off the
--       cone r <= w.  So it must FAIL on range B and SURVIVE on range A —
--       which pins the hypothesis EGBPairConic.agda carries, from both sides.
chkProductFalse, chkDiscFalse, chkProductTrunc :: PairCheck
chkProductFalse (w,r) = ( legLo w r * legHi w r, w*w + r*r )
chkDiscFalse (w,r)    = ( let s = legLo w r + legHi w r
                              p = legLo w r * legHi w r
                          in s*s - 4*p
                        , 2*r*r )
chkProductTrunc (w,r) = ( legLoTrunc w r * legHi w r, splitNorm w r )

-- --------------------------------------- the defining-rewrite firewall
-- Every equation installed in a `symDefs` (the kernel-safe set) and every
-- rule in `pairRules` is audited by exhaustive evaluation over a symmetric
-- integer box.  An unsound entry here is a bug in this module, not a
-- discovery, and the exit gate treats it as such.

firewallBound :: Integer
firewallBound = 8

-- सारणी वा क्रिया (Piṅgala, Chandaḥśāstra 8.24–28).  This was
--     smallEnvironmentsZ n b = sequence (replicate n [-b .. b])
-- — the signed box laid out.  It is now naṣṭa in radix (2b+1) with the
-- digit shifted down by b: the same (2b+1)^n rows in the same order, made
-- from an index and dropped.  Checked in machine/PrastaraRun.hs.
smallEnvironmentsZ :: Int -> Integer -> [[Integer]]
smallEnvironmentsZ n b =
  P.rows (P.powerP n (P.isoP (subtract b) (+ b) (P.chedaP (2 * b))))

varCount :: Term -> Term -> Int
varCount l r = case vars l ++ vars r of
  [] -> 0
  us -> 1 + maximum us

exhaustiveCounterexample
  :: M.Map String ([Integer]->Integer) -> Integer -> Rule
  -> Maybe ([Integer],Integer,Integer)
exhaustiveCounterexample sem b (l,r) =
  case [ (env,lv,rv)
       | env <- smallEnvironmentsZ (varCount l r) b
       , let lv = eval sem env l
       , let rv = eval sem env r
       , lv /= rv ] of
    (w:_) -> Just w
    []    -> Nothing

-- ============ §10 THE ℕ CHART, FINITELY VERIFIED (the wire's own firewall)
--
-- Same checker (`failuresOf`) as §4, pointed at the truncated evaluators of
-- §3c over a ℕ box.  Three statements are made and all three are checked:
--
--   N2  the split norm identity SURVIVES truncation, everywhere on the box;
--   N1  the sum identity DOES NOT, and
--   N3  the discriminant identity DOES NOT.
--
-- N1 and N3 are not decorations: they are the reason `natPairSymbols`
-- carries exactly one installable identity rather than three, and they are
-- their own falsifier controls — a checker that reported 0 failures for
-- them would be vacuous, and the exit gate says so.
--
-- The box is 0 ≤ w,r ≤ natBoxB, i.e. it reaches r > w, which is the whole
-- point: on the cone r ≤ w all three identities hold and the box is what
-- separates them.

natBoxB :: Integer
natBoxB = 40

natBoxPoints :: [(Integer,Integer)]
natBoxPoints = [ (w,r) | w <- [0..natBoxB], r <- [0..natBoxB] ]

natConePoints :: [(Integer,Integer)]
natConePoints = [ (w,r) | w <- [0..natBoxB], r <- [0..w] ]

chkNatProduct, chkNatSum, chkNatDisc :: PairCheck
chkNatProduct (w,r) = ( natLegLo w r * natLegHi w r, natSplitNorm w r )
chkNatSum (w,r)     = ( natLegLo w r + natLegHi w r, 2*w )
chkNatDisc (w,r)    = ( let sm = natLegLo w r + natLegHi w r
                            pr = natLegLo w r * natLegHi w r
                        in max 0 (sm*sm - 4*pr)
                      , 4*r*r )

-- The defining equations of §3c, audited against the ℕ semantics they will
-- be handed to the engine with.  This is MathMachine's own definition
-- firewall (`definitionFailures`) run here, before the wire, so a bad
-- equation cannot reach the kernel at all.
natFirewallFailures :: [(String,Term,Term,[Integer],Integer,Integer)]
natFirewallFailures =
  [ (symName s, l, r, env, lv, rv)
  | s <- natPairSymbols
  , (l,r) <- symDefs s
  , Just (env,lv,rv) <- [natCounterexample (l,r)] ]

-- over ℕ only: the engine never evaluates at a negative environment
natCounterexample :: Rule -> Maybe ([Integer],Integer,Integer)
natCounterexample (l,r) =
  case [ (env,lv,rv)
       | env <- sequence (replicate (varCount l r) [0 .. firewallBound])
       , let lv = eval (semantics natVocabulary) env l
       , let rv = eval (semantics natVocabulary) env r
       , lv /= rv ] of
    (w:_) -> Just w
    []    -> Nothing

-- The identity as a machine RULE, in the orientation MathMachine will use.
-- This is the statement the engine is asked to prove; it is stated here so
-- that the term the wire submits and the term this module verifies are one
-- object and not two transcriptions.
natSplitNormLaw :: Rule
natSplitNormLaw = ( bin "*" (F "leglo" [x_,y_]) (F "leghi" [x_,y_])
                  , F "splitnorm" [x_,y_] )

-- ================ §11 BHAVANA OVER ℕ, FINITELY VERIFIED (the Pell wire)
--
-- Brahmagupta, Brahmasphutasiddhanta 628 CE.  §3d says which forms of the
-- composition rule can survive monus and why; this section CHECKS that,
-- exhaustively over a stated ℕ box, and emits the survivors in the exact
-- syntax MathMachine's `parseTerm` reads, so that machine/thoughts.bhavana.math
-- is generated from the terms verified here rather than retyped.
--
-- Every law below is a `Rule` over the ℕ chart of §3c+§3d.  Each is checked
-- on the FULL box (all four arguments free) and, where §3d predicts a cone
-- hypothesis, on the cone x^2 >= D y^2 as well.  The laws marked "must FAIL"
-- are not decorations: they are the falsifier controls, and a checker that
-- reported zero failures for them would be vacuous.  The exit gate says so.

bhavanaBox :: Integer
bhavanaBox = 12          -- 13^4 = 28561 points for a four-variable law

lawArity :: Rule -> Int
lawArity (l,r) = case vars l ++ vars r of
                   [] -> 0
                   vs -> 1 + maximum vs

lawPoints :: Int -> [[Integer]]
lawPoints n = sequence (replicate n [0 .. bhavanaBox])

-- failures of a law over the box, optionally restricted by a predicate on
-- the environment.  Lazy, so `take 1` on a must-FAIL law is cheap.
lawFailuresWhere :: ([Integer] -> Bool) -> Rule -> [([Integer],Integer,Integer)]
lawFailuresWhere p rl@(l,r) =
  [ (env,lv,rv)
  | env <- lawPoints (lawArity rl)
  , p env
  , let lv = eval sem env l
  , let rv = eval sem env r
  , lv /= rv ]
  where sem = semantics natVocabulary

lawFailures :: Rule -> [([Integer],Integer,Integer)]
lawFailures = lawFailuresWhere (const True)

-- the Pell cone at discriminant D: every (x,y) row of the environment has a
-- NON-NEGATIVE true norm, which is exactly the region §3d predicts bhavana
-- survives truncation on.
onConeD :: Integer -> [Integer] -> Bool
onConeD d env = and [ a*a >= d*(b*b) | (a,b) <- rows env ]
  where rows (a:b:rest) = (a,b) : rows rest
        rows _          = []

-- the true (ℤ) norms of an environment's rows, for exhibiting WHY a point
-- fails: bhavana over ℕ breaks exactly where BOTH are negative.
trueNorms :: Integer -> [Integer] -> [Integer]
trueNorms d env = [ a*a - d*(b*b) | (a,b) <- rows env ]
  where rows (a:b:rest) = (a,b) : rows rest
        rows _          = []

-- ---------------------------------------------------------------- the laws
sq :: Term -> Term
sq t = bin "*" t t

scaleT :: Integer -> Term -> Term
scaleT 1 t = t
scaleT k t = bin "*" (num (fromInteger k)) t

-- the norm symbol at D.  D = 1 IS §3c's `splitnorm`, so every D = 1 law
-- below cross-checks the Pell wire against the chart WIRE 5 already carried.
nrmT :: Integer -> Term -> Term -> Term
nrmT 1 a b = F "splitnorm" [a,b]
nrmT 2 a b = F "nrm2" [a,b]
nrmT d _ _ = error ("PairVocab: no norm symbol at D = " ++ show d)

cxT :: Integer -> Term -> Term -> Term -> Term -> Term
cxT 1 a b c e = F "bcx1" [a,b,c,e]
cxT 2 a b c e = F "bcx2" [a,b,c,e]
cxT d _ _ _ _ = error ("PairVocab: no composition symbol at D = " ++ show d)

cyT :: Term -> Term -> Term -> Term -> Term
cyT a b c e = F "bcy" [a,b,c,e]

-- (B) BHAVANA AS BRAHMAGUPTA STATES IT, transcribed into the ℕ chart.
-- FALSE over ℕ off the cone; the check below exhibits the witness.
bhavanaLaw :: Integer -> Rule
bhavanaLaw d = ( bin "*" (nrmT d x_ y_) (nrmT d z_ u_)
               , nrmT d (cxT d x_ y_ z_ u_) (cyT x_ y_ z_ u_) )

-- (b) THE SUBTRACTION-FREE FORM.  Equivalent to (B) over ℤ by adding
-- D x1^2 y2^2 + D x2^2 y1^2 to both sides; TRUE over ℕ with no hypothesis.
bhavanaAddLaw :: Integer -> Rule
bhavanaAddLaw d =
  ( bin "+" (sq (cxT d x_ y_ z_ u_))
      (bin "+" (scaleT d (sq (bin "*" x_ u_)))
               (scaleT d (sq (bin "*" z_ y_))))
  , bin "+" (sq (bin "*" x_ z_))
      (bin "+" (scaleT (d*d) (sq (bin "*" y_ u_)))
               (scaleT d (sq (cyT x_ y_ z_ u_)))) )

-- (c) THE SCALING CASE y2 = 0.  The second norm is a square, hence never
-- negative, so monus cannot separate the sides; survives because monus is
-- right-distributive over multiplication.
bhavanaScaleLaw :: Integer -> Rule
bhavanaScaleLaw d = ( bin "*" (nrmT d x_ y_) (sq z_)
                    , nrmT d (bin "*" x_ z_) (bin "*" z_ y_) )

-- the same statement said THROUGH the composition symbols, so that what
-- is proved is a specialisation of bhavana and not a lookalike.
bhavanaScaleCompLaw :: Integer -> Rule
bhavanaScaleCompLaw d =
  ( bin "*" (nrmT d x_ y_) (nrmT d z_ zero_)
  , nrmT d (cxT d x_ y_ z_ zero_) (cyT x_ y_ z_ zero_) )

-- (d) composition with the Pell unit (1,0) is the identity
bhavanaUnitLaw :: Integer -> Rule
bhavanaUnitLaw d = ( nrmT d (cxT d x_ y_ (su zero_) zero_)
                          (cyT x_ y_ (su zero_) zero_)
                   , nrmT d x_ y_ )

-- (e) the composition is commutative, componentwise
bhavanaCommX :: Integer -> Rule
bhavanaCommX d = ( cxT d x_ y_ z_ u_, cxT d z_ u_ x_ y_ )

bhavanaCommY :: Rule
bhavanaCommY = ( cyT x_ y_ z_ u_, cyT z_ u_ x_ y_ )

-- (f) the two charts differ by exactly one cross term: bcx2 = bcx1 + y u
bhavanaChartsDiffer :: Rule
bhavanaChartsDiffer = ( cxT 2 x_ y_ z_ u_
                      , bin "+" (cxT 1 x_ y_ z_ u_) (bin "*" y_ u_) )

-- (g) the degenerate rows: the composition on radius-0 pairs is
-- multiplication of centres, which is why the Pell conic contains ℕ.
bcxDegenerate :: Integer -> Rule
bcxDegenerate d = ( cxT d x_ zero_ z_ zero_, bin "*" x_ z_ )

bcxRightUnit :: Integer -> Rule
bcxRightUnit d = ( cxT d x_ y_ z_ zero_, bin "*" x_ z_ )

bcyRightUnit, bcyDegenerate, bcyDuplicate :: Rule
bcyRightUnit  = ( cyT x_ y_ z_ zero_, bin "*" z_ y_ )
bcyDegenerate = ( cyT x_ zero_ z_ zero_, zero_ )
bcyDuplicate  = ( cyT x_ y_ x_ y_, bin "*" two_ (bin "*" x_ y_) )

nrm2AtZeroRadius, nrm2AtZeroCentre :: Rule
nrm2AtZeroRadius = ( F "nrm2" [x_, zero_], sq x_ )
nrm2AtZeroCentre = ( F "nrm2" [zero_, y_], zero_ )   -- monus: 0 -. 2y^2 = 0

-- (h) NEGATIVE CONTROL.  The duplication (squaring) case of bhavana:
-- TRUE over ℤ, FALSE over ℕ, for exactly the reason (B) is.
bhavanaSquareLaw :: Integer -> Rule
bhavanaSquareLaw d = ( nrmT d (cxT d x_ y_ x_ y_) (cyT x_ y_ x_ y_)
                     , bin "*" (nrmT d x_ y_) (nrmT d x_ y_) )

-- (i) FALSIFIER CONTROLS FOR THE CHECKER ITSELF.  Deliberately wrong
-- variants of laws that hold, fed to the SAME checker.  If either came back
-- with zero failures the box would be too small to see anything and every
-- empty failure list above would mean nothing.
bhavanaAddWrong :: Rule                 -- D^2 replaced by D
bhavanaAddWrong =
  ( bin "+" (sq (cxT 2 x_ y_ z_ u_))
      (bin "+" (scaleT 2 (sq (bin "*" x_ u_)))
               (scaleT 2 (sq (bin "*" z_ y_))))
  , bin "+" (sq (bin "*" x_ z_))
      (bin "+" (scaleT 2 (sq (bin "*" y_ u_)))
               (scaleT 2 (sq (cyT x_ y_ z_ u_)))) )

bcyWrong :: Rule                        -- second component with a wrong leg
bcyWrong = ( cyT x_ y_ z_ u_, bin "+" (bin "*" x_ u_) (bin "*" z_ z_) )

-- ------------------------------------------- what gets handed to the engine
--
-- A `candidate` line in MathMachine's own syntax.  `showTerm` renders + and
-- * infix and `parseTerm` reads prefix only, so this goes through
-- `nativeTerm`, which is `termP`'s inverse.
thoughtLine :: Rule -> String
thoughtLine (l,r) = "candidate\t" ++ nativeTerm l ++ "\t" ++ nativeTerm r

-- ============================================ §5 the parity obstruction
-- PairCoordinates.agda `sumIsDouble`: the sum of the legs is always a double,
-- so the map (w,r) |-> (w-r, w+r) is not invertible over a general ring —
-- recovering w needs a halving.  Over Z the halving exists only on pairs of
-- equal parity.  The two statements below are the two sides of that, both
-- finitely verified, and the second is what makes `lemmaLegRT` a lemma with a
-- domain rather than a defining equation.

parityRange :: Integer
parityRange = 40

-- (a) on same-parity pairs the round trip is exact.
roundTripFailures :: [((Integer,Integer),(Integer,Integer))]
roundTripFailures =
  [ ((p,q),(legLo w r, legHi w r))
  | p <- [-parityRange..parityRange], q <- [-parityRange..parityRange]
  , even (p+q)
  , let w = centre p q, let r = radius p q
  , (legLo w r, legHi w r) /= (p,q) ]

-- (b) off it the round trip is exactly wrong, and here is the first witness.
--     A `Nothing` here would mean the parity hypothesis is doing no work and
--     the module's account of it is fiction; the exit gate fails on Nothing.
parityWitness :: Maybe ((Integer,Integer),(Integer,Integer))
parityWitness =
  case [ ((p,q),(legLo w r, legHi w r))
       | p <- [0..parityRange], q <- [0..parityRange]
       , odd (p+q)
       , let w = centre p q, let r = radius p q
       , (legLo w r, legHi w r) /= (p,q) ] of
    (a:_) -> Just a
    []    -> Nothing

-- ================================================ §6 the two readings
-- Primality and integer square roots, exact.  No floats: `isqrt` is Newton's
-- iteration on Integer, and `isqrtAuditFailures` verifies it against its own
-- specification (s^2 <= n < (s+1)^2) exhaustively over a stated range, so the
-- instrument is checked rather than trusted.

isPrime :: Integer -> Bool
isPrime m
  | m < 2 = False
  | m < 4 = True
  | even m = False
  | otherwise = null [ d | d <- takeWhile (\d -> d*d <= m) [3,5..], m `mod` d == 0 ]

-- floor(sqrt n) for n >= 0, by Newton from a power-of-two upper bound.
isqrt :: Integer -> Integer
isqrt n
  | n < 0 = 0                       -- convention; never used below
  | n < 2 = n
  | otherwise = go (bound 1)
  where
    bound k | k*k >= n = k
            | otherwise = bound (2*k)
    go a = let b = (a + n `div` a) `div` 2
           in if b >= a then a else go b

isSquare :: Integer -> Bool
isSquare n = n >= 0 && let s = isqrt n in s*s == n

ceilSqrt :: Integer -> Integer
ceilSqrt n = let s = isqrt n in if s*s == n then s else s + 1

isqrtAuditBound :: Integer
isqrtAuditBound = 5000

isqrtAuditFailures :: [Integer]
isqrtAuditFailures =
  [ n | n <- [0..isqrtAuditBound]
      , let s = isqrt n
      , not (s*s <= n && n < (s+1)*(s+1)) ]

-- ---------------------------------------------------- reading I: Goldbach
-- Hold the SUM fixed.  For centre w (so the even number is 2w), the witnesses
-- are the radii r with both legs prime.  This is a decision procedure for one
-- even number, nothing more: it says nothing about any other w, and the
-- module makes no conjecture-shaped claim from its output.
goldbachWitnesses :: Integer -> [Integer]
goldbachWitnesses w = [ r | r <- [0..w], isPrime (legLo w r), isPrime (legHi w r) ]

-- ---------------------------------------------------- reading II: Fermat
-- Hold the PRODUCT fixed.  Climb w from ceil(sqrt n) until w^2 - n is a
-- perfect square; then n = (w-r)(w+r) with r = sqrt(w^2 - n).
--
-- DOMAIN.  n odd and n >= 1.  For even n the method is not merely slow, it is
-- wrong-domain: n = (w-r)(w+r) forces the two legs to share a parity, so a
-- representation exists only if n is odd or 4 | n; at n = 2 (mod 4) there is
-- none and an uncapped loop would not terminate.  `fermatFactor` returns
-- Nothing off its domain rather than pretending.
--
-- TERMINATION, derived rather than hoped for: for odd n >= 1, w = (n+1)/2
-- gives w^2 - n = ((n-1)/2)^2, a perfect square, so the loop halts at or
-- before (n+1)/2.  That is the cap below, and it is reached exactly when n is
-- prime (the trivial factorisation n = 1 * n).
fermatCap :: Integer -> Integer
fermatCap n = (n + 1) `div` 2

fermatFactor :: Integer -> Maybe (Integer,Integer)
fermatFactor n = fmap snd (fermatFactorCounted n)

-- the same loop, returning the exact number of iterations (values of w tried,
-- including the successful one).  Counting is part of the algorithm here, not
-- an instrument bolted on: see §8.
fermatFactorCounted :: Integer -> Maybe (Integer,(Integer,Integer))
fermatFactorCounted n
  | n < 1 || even n = Nothing
  | otherwise = go (ceilSqrt n) 0
  where
    cap = fermatCap n
    go w k
      | w > cap = Nothing                        -- unreachable for odd n >= 1
      | isSquare (w*w - n) = let r = isqrt (w*w - n)
                             in Just (k+1, (legLo w r, legHi w r))
      | otherwise = go (w+1) (k+1)

-- trial division on the same domain, for the comparison of §8.  One iteration
-- = one odd candidate divisor tested.  Returns the pair it finds; for prime n
-- that is the trivial pair (1,n), exactly as Fermat's method returns it, so
-- the two are answering the same question.
trialFactorCounted :: Integer -> Maybe (Integer,(Integer,Integer))
trialFactorCounted n
  | n < 1 || even n = Nothing
  | otherwise = go 3 0
  where
    go d k
      | d*d > n = Just (k, (1,n))
      | n `mod` d == 0 = Just (k+1, (d, n `div` d))
      | otherwise = go (d+2) (k+1)

-- ================================ §7 one conic, exhibited from both sides
-- The point of the module.  For a composite odd n, `fermatFactor n` returns a
-- pair; that pair's centre/radius coordinates satisfy the SAME splitNorm
-- identity the Goldbach search uses, because it is the same identity.  When
-- the legs happen to be prime, the very same lattice point (w,r) is
-- simultaneously a Fermat factorisation of n and a Goldbach witness for 2w —
-- the two readings are two projections of one point, and the example below
-- exhibits the point, not an analogy.

data BothSides = BothSides
  { bsN       :: !Integer
  , bsPair    :: !(Integer,Integer)   -- the legs Fermat returns
  , bsCentre  :: !Integer
  , bsRadius  :: !Integer
  , bsNorm    :: !Integer             -- splitNorm centre radius
  , bsSum     :: !Integer             -- legLo + legHi, which must be 2*centre
  , bsPrimes  :: !(Bool,Bool)         -- are the legs prime?
  , bsGoldbach :: !Bool               -- is bsRadius a Goldbach witness for 2w?
  }

bothSides :: Integer -> Maybe BothSides
bothSides n = do
  (p,q) <- fermatFactor n
  let w = centre p q
      r = radius p q
  pure BothSides { bsN = n, bsPair = (p,q), bsCentre = w, bsRadius = r
                 , bsNorm = splitNorm w r, bsSum = p + q
                 , bsPrimes = (isPrime p, isPrime q)
                 , bsGoldbach = r `elem` goldbachWitnesses w }

-- The worked instances.  8051 = 83*97 is the classical textbook instance of
-- Fermat's method and it lands, with no adjustment, on a Goldbach witness for
-- 180.  45 = 5*9 is the deliberate contrast: a genuine point of the conic
-- whose legs are NOT both prime, so it is a Fermat factorisation and NOT a
-- Goldbach witness.  The two readings are different fibrations of one conic;
-- if every Fermat output were a Goldbach witness the distinction would be
-- empty, and 45 is the control that shows it is not.
workedInstances :: [Integer]
workedInstances = [8051, 5959, 8633, 10403, 45, 1147, 7919]

-- EXHAUSTIVE cross-check of the meeting, over a stated range: for every
-- centre w in [3..coneW] and every Goldbach witness r of that centre with
-- both legs ODD primes, Fermat's method applied to the product returns
-- exactly that pair.  (Legs must be odd: a leg equal to 2 makes the product
-- even, which is off Fermat's domain.  The witness with the smallest r is the
-- one Fermat finds first, and for a product of two primes it is the only
-- non-trivial pair, so the identity of the outputs is forced.)
crossCheckInstances :: [(Integer,Integer,Integer)]
crossCheckInstances =
  [ (w, r, splitNorm w r)
  | w <- [3..coneW], r <- goldbachWitnesses w
  , legLo w r >= 3 ]

crossCheckFailures :: [((Integer,Integer),Maybe (Integer,Integer))]
crossCheckFailures =
  [ ((w,r), fermatFactor n)
  | (w,r,n) <- crossCheckInstances
  , fermatFactor n /= Just (legLo w r, legHi w r) ]

-- ================================================== §8 cost, exactly counted
-- WHAT THIS SECTION IS AND IS NOT.  It is an honest comparison of two
-- algorithms under ONE counting model: one unit = one loop iteration, meaning
-- one candidate w for Fermat and one candidate odd divisor d for trial
-- division.  The per-iteration WORK differs between the two — a Fermat step
-- is one multiplication plus one integer-square-root test, a trial-division
-- step is one division with remainder — so the model compares SEARCH LENGTHS,
-- not machine time, and the table must be read that way.  No wall-clock
-- reading appears anywhere.
--
-- It is NOT an asymptotic claim, and it is not a measurement, because both
-- counts have exact closed forms and are DERIVED here (CLAUDE.md: derive the
-- quantity rather than fit it).  The counters exist only to confirm the
-- derivations exhaustively over a stated range.
--
-- DERIVATION (both one line).  Let n be odd, n >= 3.
--
--   Fermat.  The loop tests w = ceil(sqrt n), ceil(sqrt n)+1, ... and stops
--   at the first w with w^2 - n a square, i.e. at the first w admitting a
--   factorisation n = (w-r)(w+r).  Factorisations of n correspond to divisor
--   pairs (d, n/d) with d <= sqrt n, and the pair's centre (d + n/d)/2 is
--   DECREASING in d on 0 < d <= sqrt n.  Hence the first w reached is
--   w0 = (d* + n/d*)/2 with d* the LARGEST divisor of n not exceeding
--   sqrt n, and
--            F(n) = w0 - ceil(sqrt n) + 1.
--   For prime n, d* = 1 and F(n) = (n+1)/2 - ceil(sqrt n) + 1.
--
--   Trial division.  The loop tests d = 3,5,7,... and stops at the first
--   divisor, or when d^2 > n.  If n is composite with least prime factor
--   p (necessarily odd and <= sqrt n) it stops at d = p having tested the
--   (p-1)/2 odd numbers 3,5,...,p, so T(n) = (p-1)/2.  If n is prime it
--   tests every odd d in [3, floor(sqrt n)], so T(n) = floor((s-1)/2) with
--   s = floor(sqrt n).
--
-- WHERE EACH WINS is then not an observation but a decidable comparison of
-- the two closed forms: Fermat is short exactly when n has a divisor near
-- sqrt n (a balanced semiprime: F = 1 when d* + n/d* = 2*ceil(sqrt n)), trial
-- division is short exactly when n has a small prime factor.  Neither
-- statement is about growth; both are exact at each n.

largestDivisorAtMostSqrt :: Integer -> Integer
largestDivisorAtMostSqrt n =
  case [ d | d <- [isqrt n, isqrt n - 1 .. 1], n `mod` d == 0 ] of
    (d:_) -> d
    []    -> 1

leastOddPrimeFactor :: Integer -> Maybe Integer
leastOddPrimeFactor n =
  case [ d | d <- takeWhile (\d -> d*d <= n) [3,5..], n `mod` d == 0 ] of
    (d:_) -> Just d
    []    -> Nothing

fermatItersFormula :: Integer -> Integer
fermatItersFormula n =
  let d = largestDivisorAtMostSqrt n
  in (d + n `div` d) `div` 2 - ceilSqrt n + 1

trialItersFormula :: Integer -> Integer
trialItersFormula n =
  case leastOddPrimeFactor n of
    Just p  -> (p - 1) `div` 2
    Nothing -> let s = isqrt n in max 0 ((s - 1) `div` 2)

-- the range on which the two closed forms are verified against the counters.
formulaRange :: Integer
formulaRange = 1501

formulaFailures :: [(Integer,String,Integer,Integer)]
formulaFailures =
  concat
    [ [ (n, "fermat", fk, fermatItersFormula n) | fk /= fermatItersFormula n ]
      ++ [ (n, "trial", tk, trialItersFormula n) | tk /= trialItersFormula n ]
    | n <- [3,5..formulaRange]
    , Just (fk,_) <- [fermatFactorCounted n]
    , Just (tk,_) <- [trialFactorCounted n] ]

-- the tabulated instances, chosen to exhibit both winners and the crossover:
-- balanced semiprimes (Fermat short), a small-factor composite and a prime
-- (trial short), and a semiprime with unbalanced but not tiny factors.
costInstances :: [Integer]
costInstances = [ 8051, 10403, 8633, 5959, 1147, 45, 29919, 26051, 7919, 32399 ]

data CostRow = CostRow
  { crN :: !Integer
  , crFermatPair :: !(Integer,Integer), crFermatIters :: !Integer
  , crTrialPair :: !(Integer,Integer), crTrialIters :: !Integer
  , crProductsOK :: !Bool }

costRow :: Integer -> Maybe CostRow
costRow n = do
  (fk,fp) <- fermatFactorCounted n
  (tk,tp) <- trialFactorCounted n
  pure CostRow { crN = n
               , crFermatPair = fp, crFermatIters = fk
               , crTrialPair = tp, crTrialIters = tk
               , crProductsOK = fst fp * snd fp == n && fst tp * snd tp == n }

winner :: CostRow -> String
winner r
  | crFermatIters r < crTrialIters r = "Fermat"
  | crFermatIters r > crTrialIters r = "trial"
  | otherwise                        = "tie"

-- ==================================================== §9 the self-test
-- Prints the ranges, the falsifier outcomes, the worked two-readings example
-- and the cost table; exits nonzero if any check that this module claims to
-- have performed did not come out the way the module says it does.

showPt :: (Integer,Integer) -> String
showPt (w,r) = "(w=" ++ show w ++ ",r=" ++ show r ++ ")"

reportCheck :: String -> String -> [(Integer,Integer)]
            -> PairCheck -> Bool -> IO [String]
reportCheck nm rangeName pts chk mustHold = do
  let fs = failuresOf pts chk
      k  = length fs
  printf "  %-34s over %-26s %6d points, %6d failures  %s\n"
    nm rangeName (length pts) k
    (if mustHold
       then (if k == 0 then "OK" else "*** BROKEN ***")
       else (if k == 0 then "*** VACUOUS: falsifier not rejected ***" else "rejected, as required"))
  case fs of
    (((w,r),lv,rv):_) ->
      printf "        first witness %s : left=%d right=%d\n" (showPt (w,r)) lv rv
    [] -> pure ()
  pure $ if mustHold
           then [ nm ++ ": identity fails at " ++ showPt p ++ " over " ++ rangeName
                | (p,_,_) <- take 1 fs ]
           else [ nm ++ ": falsifier NOT rejected over " ++ rangeName
                  ++ " -- the checker is vacuous" | k == 0 ]

-- §11's reporter.  Same contract as `reportCheck`: `mustHold` says which
-- way the verdict is read, and a falsifier that is NOT rejected is a
-- failure of the module, not a success of the law.
reportLaw :: String -> Rule -> Bool -> IO [String]
reportLaw nm rl mustHold = reportLawOn nm (const True) rl mustHold

reportLawOn :: String -> ([Integer] -> Bool) -> Rule -> Bool -> IO [String]
reportLawOn nm p rl mustHold = do
  let n    = lawArity rl
      pts  = length (filter p (lawPoints n))
      fs   = lawFailuresWhere p rl
  if mustHold
    then do
      let k = length fs
      printf "  %-32s %d vars %7d points %6d failures  %s\n"
        nm n pts k (if k == 0 then "OK" else "*** BROKEN ***")
      mapM_ (reportWitness rl) (take 1 fs)
      pure [ nm ++ ": fails at env=" ++ show e | (e,_,_) <- take 1 fs ]
    else case take 1 fs of
      [] -> do
        printf "  %-32s %d vars %7d points      0 failures  *** VACUOUS ***\n" nm n pts
        pure [ nm ++ ": expected to FAIL over N and did not; the check is vacuous" ]
      (w:_) -> do
        printf "  %-32s %d vars %7d points    >=1 failures  rejected, as required\n" nm n pts
        reportWitness rl w
        pure []

-- A witness is printed WITH the true (ℤ) norms of its rows, because that is
-- the whole explanation: bhavana breaks over ℕ exactly where both are
-- negative and monus has flattened both factors to 0.
reportWitness :: Rule -> ([Integer],Integer,Integer) -> IO ()
reportWitness rl (e,lv,rv) = do
  printf "        first witness env=%s : left=%d right=%d\n" (show e) lv rv
  printf "          true norms over Z: D=1 %s   D=2 %s\n"
    (show (trueNorms 1 e)) (show (trueNorms 2 e))
  printf "          law: %s = %s\n" (nativeTerm (fst rl)) (nativeTerm (snd rl))

reportRule :: (String,Rule) -> IO ()
reportRule (grp,(l,r)) =
  printf "  [%-9s] %-46s -> %-24s %s\n" grp (show l) (show r)
    (case orient (l,r) of
       Just (a,b) | (a,b) == (l,r) -> "oriented L->R"
                  | otherwise      -> "oriented R->L (flipped)"
       Nothing                     -> "UNORIENTABLE (lemma only)")

main :: IO ()
main = do
  let sem = semantics vocabulary

  putStrLn "=== PairVocab: the prime-pair field as machine vocabulary ==="
  putStrLn "  p = w - r,  q = w + r.   Identities (proved over any commutative ring"
  putStrLn "  in formal/cubical/NaturalMachine/PairCoordinates.agda, NOT reproved here):"
  putStrLn "     (1) p + q = 2w      (2) p*q = w^2 - r^2      (3) (p+q)^2 - 4pq = 4r^2"
  putStrLn ""

  -- ---------------------------------------------------------------- §1-3
  putStrLn "-- (1) generators and exact evaluators (spot values, exact Integer) --"
  printf "  legLo 90 7 = %d   legHi 90 7 = %d   splitNorm 90 7 = %d\n"
    (legLo 90 7) (legHi 90 7) (splitNorm 90 7)
  printf "  centre 83 97 = %d  radius 83 97 = %d   (round trip exact: same parity)\n"
    (centre 83 97) (radius 83 97)
  printf "  centre 83 98 = %d  radius 83 98 = %d   (parities differ: see (5))\n\n"
    (centre 83 98) (radius 83 98)

  putStrLn "-- (2) the identities as installable machine rules (orientability) --"
  mapM_ reportRule pairRules
  reportRule ("lemma", lemmaLegRT)
  putStrLn "        ^ leglo(centre(p,q),radius(p,q)) = p is TRUE only when p,q share a"
  putStrLn "          parity, so it is a LEMMA and is deliberately in no symDefs."
  putStrLn ""
  putStrLn "  reduction demo, under the LPO orientation reported above (this is the"
  putStrLn "  engine getting cheaper: a pair term collapses instead of being searched)"
  let installed = [ o | (_,rl) <- pairRules, Just o <- [orient rl] ]
      demos = [ F "centre" [F "leglo" [x_,y_], F "leghi" [x_,y_]]
              , F "radius" [F "leglo" [x_,y_], F "leghi" [x_,y_]]
              , bin "+" (F "leglo" [x_,y_]) (F "leghi" [x_,y_])
              , fst ruleDisc
              , F "splitnorm" [x_,y_]
              , bin "*" (F "leglo" [x_,y_]) (F "leghi" [x_,y_]) ]
  mapM_ (\t -> printf "    %-56s ~~> %s\n" (show t) (show (normalize installed t))) demos
  putStrLn "    ^ the discriminant term reduces only PARTIALLY, and that is reported"
  putStrLn "      rather than hidden: `step` rewrites innermost-first, so rule (1)"
  putStrLn "      fires inside it and destroys rule (3)'s left-hand pattern.  That is"
  putStrLn "      a genuine critical-pair overlap between (1) and (3), not an error --"
  putStrLn "      the residual ((2x)*(2x)) - 4*leglo*leghi still EQUALS 4*y*y (rule"
  putStrLn "      (3) is verified exhaustively in (3) and (4) below); the rule set is"
  putStrLn "      sound but not confluent until the overlap is completed."
  putStrLn "    ^ the last two lines are the honest report, not a failure: with"
  putStrLn "      splitnorm ranked ABOVE * in this precedence, identity (2) orients as"
  putStrLn "      an EXPANSION (splitnorm -> leglo*leghi), so the product does not"
  putStrLn "      contract back.  A machine that wants to RECOGNISE a product as a"
  putStrLn "      split norm must rank splitnorm below *; the equation is the same one"
  putStrLn "      either way, and which direction terminates is a choice of order."
  putStrLn ""

  putStrLn "-- (3) defining-rewrite firewall (exhaustive over a symmetric box) --"
  printf "  box: every variable independently over [%d..%d], exact Integer\n"
    (negate firewallBound) firewallBound
  let defRules  = [ (symName s, e) | s <- vocabulary, e <- symDefs s ]
      allRules  = defRules ++ [ ("rule:" ++ nm, rl) | (nm,rl) <- pairRules ]
      ruleFails = [ (nm,l,r,env,lv,rv)
                  | (nm,(l,r)) <- allRules
                  , Just (env,lv,rv) <- [exhaustiveCounterexample sem firewallBound (l,r)] ]
  if null ruleFails
    then printf "  all %d defining equations and %d pair rules survive (sound).\n"
           (length defRules) (length pairRules)
    else mapM_ (\(nm,l,r,env,lv,rv) ->
           printf "  UNSOUND %s: %s = %s fails at %s (%d vs %d)\n"
             nm (show l) (show r) (show env) lv rv) ruleFails
  putStrLn ""

  -- ---------------------------------------------------------------- §4
  putStrLn "-- (4) FINITE EXHAUSTIVE VERIFICATION of the three identities --"
  putStrLn "  CLAUDE.md admits a finite exhaustive verification as PROOF.  What is"
  putStrLn "  proved is exactly the finitely-bounded statement over the range named;"
  putStrLn "  the ring theorems are PairCoordinates.agda's.  Nothing here is asymptotic."
  let coneName = printf "cone 0<=w<=%d, 0<=r<=w" coneW :: String
      boxName  = printf "box %d<=w,r<=%d" (negate boxB) boxB :: String
  printf "  RANGE A: %s\n" coneName
  printf "  RANGE B: %s\n" boxName
  f1 <- reportCheck "(1) p+q = 2w"              coneName conePoints chkSum     True
  f2 <- reportCheck "(1) p+q = 2w"              boxName  boxPoints  chkSum     True
  f3 <- reportCheck "(2) p*q = w^2-r^2"         coneName conePoints chkProduct True
  f4 <- reportCheck "(2) p*q = w^2-r^2"         boxName  boxPoints  chkProduct True
  f5 <- reportCheck "(3) (p+q)^2-4pq = 4r^2"    coneName conePoints chkDisc    True
  f6 <- reportCheck "(3) (p+q)^2-4pq = 4r^2"    boxName  boxPoints  chkDisc    True
  putStrLn "  FALSIFIER CONTROLS (same checker; each MUST be rejected):"
  g1 <- reportCheck "F1 p*q =? w^2+r^2 (wrong)" coneName conePoints chkProductFalse False
  g2 <- reportCheck "F2 disc =? 2r^2   (wrong)" coneName conePoints chkDiscFalse    False
  g3 <- reportCheck "F3 (2) with TRUNCATED sub" boxName  boxPoints  chkProductTrunc False
  g4 <- reportCheck "F3 same, restricted r<=w"  coneName conePoints chkProductTrunc True
  putStrLn "        ^ F3 is the mathematical falsifier: over N with truncated"
  putStrLn "          subtraction identity (2) is FALSE off the cone and TRUE on it."
  putStrLn "          That pins EGBPairConic.agda's hypothesis r <= w from both sides."
  putStrLn ""

  -- ---------------------------------------------------------------- §5
  putStrLn "-- (5) the parity obstruction (PairCoordinates.agda sumIsDouble) --"
  printf "  same-parity pairs p,q in [%d..%d]: round trip failures = %d\n"
    (negate parityRange) parityRange (length roundTripFailures)
  case parityWitness of
    Just ((p,q),(p',q')) ->
      printf "  opposite parity, first witness: (p,q)=(%d,%d) -> (w,r)=(%d,%d) -> (%d,%d)  NOT recovered\n"
        p q (centre p q) (radius p q) p' q'
    Nothing ->
      putStrLn "  *** no opposite-parity witness found: the parity account is untested ***"
  printf "  non-degenerate exhibit: (p,q)=(83,98) -> (w,r)=(%d,%d) -> (%d,%d); the odd\n"
    (centre 83 98) (radius 83 98) (legLo (centre 83 98) (radius 83 98))
    (legHi (centre 83 98) (radius 83 98))
  putStrLn "    sum 181 is not a double, so no (w,r) over Z has these legs at all."
  putStrLn ""

  -- ---------------------------------------------------------------- §6
  putStrLn "-- (6) instrument audit --"
  printf "  isqrt: s^2 <= n < (s+1)^2 checked for every n in [0..%d]; failures = %d\n"
    isqrtAuditBound (length isqrtAuditFailures)
  putStrLn ""

  putStrLn "-- (7) ONE CONIC, TWO READINGS, on concrete numbers --"
  putStrLn "  Goldbach reading (fix the sum 2w, ask for prime legs):"
  mapM_ (\w -> printf "    2w = %3d : witnesses r = %s\n"
                 (2*w) (show (goldbachWitnesses w)))
        [15, 45, 90 :: Integer]
  putStrLn "  Fermat reading (fix the product n, climb w until w^2-n is square):"
  let rows = [ (n, bothSides n) | n <- workedInstances ]
  mapM_ (\(n,mb) -> case mb of
            Nothing -> printf "    n = %6d : off domain (even or < 1)\n" n
            Just b  -> do
              let (p,q) = bsPair b
                  (pp,qq) = bsPrimes b
              printf "    n = %6d : legs (%d, %d)  w=%d r=%d   splitNorm w r = %d %s n\n"
                n p q (bsCentre b) (bsRadius b) (bsNorm b)
                (if bsNorm b == n then "=" else "/=")
              printf "               p+q = %d = 2w %s ; legs prime? (%s,%s) ; Goldbach witness for 2w? %s\n"
                (bsSum b) (if bsSum b == 2 * bsCentre b then "OK" else "BROKEN")
                (show pp) (show qq) (show (bsGoldbach b)))
        rows
  putStrLn "    ^ 8051 is the point where the two readings COINCIDE: Fermat's method"
  putStrLn "      returns (83,97), whose centre/radius (90,7) is simultaneously a"
  putStrLn "      Goldbach witness for 180.  45 is the control: a genuine Fermat"
  putStrLn "      factorisation whose legs are NOT both prime, so the two fibrations"
  putStrLn "      of the one conic are visibly different.  7919 is prime and Fermat"
  putStrLn "      returns the trivial pair (1,n) at the derived cap (n+1)/2."
  putStrLn ""

  -- ---------------------------------------------------------------- §7
  putStrLn "-- (8) the meeting, verified exhaustively over a stated range --"
  printf "  for every centre w in [3..%d] and every Goldbach witness r with both\n" coneW
  putStrLn "  legs odd primes, Fermat's method applied to n = splitNorm w r returns"
  putStrLn "  exactly the pair (w-r, w+r):"
  printf "    instances checked: %d      failures: %d\n"
    (length crossCheckInstances) (length crossCheckFailures)
  mapM_ (\((w,r),got) -> printf "    FAIL %s: fermatFactor gave %s\n" (showPt (w,r)) (show got))
        (take 5 crossCheckFailures)
  putStrLn ""

  -- ---------------------------------------------------------------- §8
  putStrLn "-- (9) COST: two algorithms, ONE counting model, exact counts --"
  putStrLn "  unit = one loop iteration: one candidate w (Fermat) or one candidate"
  putStrLn "  odd divisor d (trial division).  The per-iteration work is NOT equal"
  putStrLn "  (a multiply + isqrt test vs a division with remainder), so this compares"
  putStrLn "  SEARCH LENGTHS under the stated model, not machine time.  No wall clock."
  putStrLn "  Both counts are DERIVED in closed form (see source, section 8); the"
  putStrLn "  counters below only confirm the derivation.  Nothing here is asymptotic."
  printf "  closed forms verified against the counters for every odd n in [3..%d]:\n"
    formulaRange
  printf "    disagreements: %d\n" (length formulaFailures)
  mapM_ (\(n,which,got,want) ->
           printf "    FORMULA FAIL n=%d %s: counted %d, formula %d\n" n which got want)
        (take 5 formulaFailures)
  putStrLn ""
  putStrLn "         n   Fermat pair    F iters    trial pair    T iters   winner  n=pq?"
  let costRows = [ (n, costRow n) | n <- costInstances ]
  mapM_ (\(n,mr) -> case mr of
           Nothing -> printf "  %8d   off domain\n" n
           Just r  ->
             printf "  %8d   (%5d,%6d) %9d    (%5d,%6d) %8d   %-7s %s\n"
               (crN r) (fst (crFermatPair r)) (snd (crFermatPair r)) (crFermatIters r)
               (fst (crTrialPair r)) (snd (crTrialPair r)) (crTrialIters r)
               (winner r) (if crProductsOK r then "yes" else "NO"))
        costRows
  putStrLn ""
  putStrLn "  reading the table (each statement is exact at the named n, not a trend):"
  putStrLn "    * balanced semiprimes (8051=83*97, 10403=101*103, 8633=89*97) have a"
  putStrLn "      divisor at ceil(sqrt n), so F = 1 while T = (least factor - 1)/2."
  putStrLn "    * a small factor (29919 = 3*9973) gives T = 1 while Fermat must climb"
  putStrLn "      from ceil(sqrt n) to the centre 4988 of a lopsided pair."
  putStrLn "    * 45 = 3*15 = 5*9 is a tie at 1, and not a coincidence: its least prime"
  putStrLn "      factor is 3 (T = 1) and its closest divisor pair is (5,9), whose"
  putStrLn "      centre 7 is already ceil(sqrt 45) (F = 1).  Both formulas give 1."
  putStrLn "    * for a prime (7919) Fermat runs to its derived cap (n+1)/2 while"
  putStrLn "      trial division stops at floor(sqrt n): the worst case for one is"
  putStrLn "      near the best case for the other."
  putStrLn "    The crossover is decidable from the two closed forms alone: Fermat is"
  putStrLn "    shorter iff (d* + n/d*)/2 - ceil(sqrt n) + 1 < (least odd prime"
  putStrLn "    factor - 1)/2, with d* the largest divisor of n at most sqrt n."
  putStrLn ""

  -- --------------------------------------------------------------- §10
  putStrLn "-- (10) THE N CHART: which identities survive truncated subtraction --"
  putStrLn "  MathMachine's carrier is N and its `-` is truncated, so the wired"
  putStrLn "  symbols are leglo(w,r)=w-.r, leghi(w,r)=w+r, splitnorm(w,r)=w*w-.r*r"
  putStrLn "  (-. = monus).  Exactly one of the three ring identities survives."
  let natBoxName  = printf "N box 0<=w,r<=%d" natBoxB :: String
      natConeName = printf "N cone 0<=w<=%d, 0<=r<=w" natBoxB :: String
  n1 <- reportCheck "(N2) p*q = splitnorm  SURVIVES" natBoxName natBoxPoints chkNatProduct True
  n2 <- reportCheck "(N1) p+q = 2w   must FAIL"      natBoxName natBoxPoints chkNatSum     False
  n3 <- reportCheck "(N3) disc = 4r^2 must FAIL"     natBoxName natBoxPoints chkNatDisc    False
  n4 <- reportCheck "(N1) p+q = 2w   on the cone"    natConeName natConePoints chkNatSum   True
  n5 <- reportCheck "(N3) disc = 4r^2 on the cone"   natConeName natConePoints chkNatDisc  True
  putStrLn "        ^ the split norm is the ONLY one of the three that needs no"
  putStrLn "          cone hypothesis over N: truncation kills both of its sides"
  putStrLn "          together (r>w gives 0*(w+r)=0 and w^2-.r^2=0).  The other"
  putStrLn "          two are true exactly on the cone, which is why the wire"
  putStrLn "          installs one identity and not three."
  printf "  defining-equation firewall over N, every variable in [0..%d]: %d failures\n"
    firewallBound (length natFirewallFailures)
  printf "  the law the engine is handed: %s = %s\n"
    (show (fst natSplitNormLaw)) (show (snd natSplitNormLaw))
  putStrLn ""

  -- --------------------------------------------------------------- §11
  putStrLn "-- (11) BHAVANA (Brahmagupta, Brahmasphutasiddhanta, 628 CE) over N --"
  putStrLn "  (x1^2 - D y1^2)(x2^2 - D y2^2) = (x1 x2 + D y1 y2)^2 - D (x1 y2 + x2 y1)^2"
  putStrLn "  D is a NUMERAL here, not a variable (see section 3d): D = 1, where the"
  putStrLn "  form factors and the norm IS splitnorm, and D = 2, the classic Pell case."
  printf   "  Box: every argument in [0..%d]; a four-variable law is %d points.\n"
    bhavanaBox ((bhavanaBox+1)^(4::Int))
  putStrLn ""
  putStrLn "  (A) BHAVANA AS STATED, over N.  MUST FAIL: monus flattens both factors"
  putStrLn "      to 0 where both norms are negative, but not the right-hand side."
  b1 <- reportLaw "bhavana D=1, full box"   (bhavanaLaw 1) False
  b2 <- reportLaw "bhavana D=2, full box"   (bhavanaLaw 2) False
  b3 <- reportLaw "bhavana D=2 squaring"    (bhavanaSquareLaw 2) False
  putStrLn ""
  putStrLn "  (B) THE SAME LAW ON THE CONE x^2 >= D y^2 (both true norms >= 0)."
  b4 <- reportLawOn "bhavana D=1 on the cone" (onConeD 1) (bhavanaLaw 1) True
  b5 <- reportLawOn "bhavana D=2 on the cone" (onConeD 2) (bhavanaLaw 2) True
  putStrLn ""
  putStrLn "  (C) THE SUBTRACTION-FREE FORM.  Bhavana with every negative term moved"
  putStrLn "      across; equivalent over Z, and TRUE over N with NO hypothesis."
  b6 <- reportLaw "bhavana-additive D=1"    (bhavanaAddLaw 1) True
  b7 <- reportLaw "bhavana-additive D=2"    (bhavanaAddLaw 2) True
  putStrLn ""
  putStrLn "  (D) THE SPECIAL CASES that survive monus with all arguments free."
  b8  <- reportLaw "scaling y2=0, D=1"      (bhavanaScaleLaw 1) True
  b9  <- reportLaw "scaling y2=0, D=2"      (bhavanaScaleLaw 2) True
  b10 <- reportLaw "scaling via bcx/bcy D=1" (bhavanaScaleCompLaw 1) True
  b11 <- reportLaw "scaling via bcx/bcy D=2" (bhavanaScaleCompLaw 2) True
  b12 <- reportLaw "unit (1,0), D=1"        (bhavanaUnitLaw 1) True
  b13 <- reportLaw "unit (1,0), D=2"        (bhavanaUnitLaw 2) True
  b14 <- reportLaw "bcx1 commutes"          (bhavanaCommX 1) True
  b15 <- reportLaw "bcx2 commutes"          (bhavanaCommX 2) True
  b16 <- reportLaw "bcy commutes"           bhavanaCommY True
  b17 <- reportLaw "bcx2 = bcx1 + y*u"      bhavanaChartsDiffer True
  b18 <- reportLaw "bcx1 on radius-0 rows"  (bcxDegenerate 1) True
  b19 <- reportLaw "bcx2 on radius-0 rows"  (bcxDegenerate 2) True
  b20 <- reportLaw "bcx1 right unit"        (bcxRightUnit 1) True
  b21 <- reportLaw "bcx2 right unit"        (bcxRightUnit 2) True
  b22 <- reportLaw "bcy right unit"         bcyRightUnit True
  b23 <- reportLaw "bcy on radius-0 rows"   bcyDegenerate True
  b24 <- reportLaw "bcy duplicated row"     bcyDuplicate True
  b25 <- reportLaw "nrm2(x,0) = x*x"        nrm2AtZeroRadius True
  b26 <- reportLaw "nrm2(0,y) = 0 (monus)"  nrm2AtZeroCentre True
  putStrLn ""
  putStrLn "  (E) FALSIFIER CONTROLS for the checker itself; each MUST be rejected."
  b27 <- reportLaw "additive form, D^2 -> D" bhavanaAddWrong False
  b28 <- reportLaw "bcy with a wrong leg"    bcyWrong False
  putStrLn ""
  printf "  defining-equation firewall over N, every variable in [0..%d]: %d failures\n"
    firewallBound (length natFirewallFailures)
  putStrLn "  (that firewall now covers all seven pair symbols, bcx1/bcx2/bcy included.)"
  putStrLn ""
  putStrLn "  THE CANDIDATE LINES, in MathMachine's own syntax.  These are the terms"
  putStrLn "  verified above, printed by `nativeTerm`; machine/thoughts.bhavana.math"
  putStrLn "  is generated from this block, not transcribed from it."
  mapM_ (putStrLn . ("  " ++) . thoughtLine)
    ( [ bhavanaLaw 1, bhavanaLaw 2 ]                       -- the negative controls
   ++ [ bhavanaAddLaw 1, bhavanaAddLaw 2
      , bhavanaScaleLaw 1, bhavanaScaleLaw 2
      , bhavanaScaleCompLaw 1, bhavanaScaleCompLaw 2
      , bhavanaUnitLaw 1, bhavanaUnitLaw 2
      , bhavanaCommX 1, bhavanaCommX 2, bhavanaCommY
      , bhavanaChartsDiffer
      , bcxDegenerate 1, bcxDegenerate 2
      , bcxRightUnit 1, bcxRightUnit 2
      , bcyRightUnit, bcyDegenerate, bcyDuplicate
      , nrm2AtZeroRadius, nrm2AtZeroCentre
      , bhavanaSquareLaw 2 ] )
  putStrLn ""

  -- ------------------------------------------------------------ exit gate
  let bhavanaFailures = concat [b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13
                               ,b14,b15,b16,b17,b18,b19,b20,b21,b22,b23,b24
                               ,b25,b26,b27,b28]
      natFailures = bhavanaFailures ++ concat [n1,n2,n3,n4,n5]
        ++ [ "N chart defining equation unsound: " ++ nm
           | (nm,_,_,_,_,_) <- natFirewallFailures ]
      identityFailures = concat [f1,f2,f3,f4,f5,f6,g1,g2,g3,g4] ++ natFailures
      firewallFailures = [ "unsound rule: " ++ nm | (nm,_,_,_,_,_) <- ruleFails ]
      parityFailures =
        [ "round trip fails on a same-parity pair " ++ show p
        | (p,_) <- take 1 roundTripFailures ]
        ++ [ "no opposite-parity witness: the parity obstruction is untested"
           | parityWitness == Nothing ]
      instrumentFailures =
        [ "isqrt violates its specification at n = " ++ show n
        | n <- take 1 isqrtAuditFailures ]
      readingFailures =
        [ "splitNorm does not reproduce n at n = " ++ show (bsN b)
        | (_,Just b) <- rows, bsNorm b /= bsN b ]
        ++ [ "leg sum is not 2w at n = " ++ show (bsN b)
           | (_,Just b) <- rows, bsSum b /= 2 * bsCentre b ]
        ++ [ "worked instance vanished (odd n rejected): " ++ show n
           | (n,Nothing) <- rows, odd n ]
        ++ [ "8051 must land on a Goldbach witness of 180"
           | (8051,Just b) <- rows, not (bsGoldbach b) ]
        ++ [ "45 must NOT be a Goldbach witness (the control is dead)"
           | (45,Just b) <- rows, bsGoldbach b ]
      meetingFailures =
        [ "cross-check fails at " ++ showPt p | (p,_) <- take 3 crossCheckFailures ]
      costFailures =
        [ printf "iteration-count formula wrong at n=%d (%s)" n which
        | (n,which,_,_) <- take 3 formulaFailures ]
        ++ [ "cost row product mismatch at n = " ++ show (crN r)
           | (_,Just r) <- costRows, not (crProductsOK r) ]
        ++ [ "cost row missing for odd n = " ++ show n | (n,Nothing) <- costRows, odd n ]
      allFailures = firewallFailures ++ identityFailures ++ parityFailures
                    ++ instrumentFailures ++ readingFailures ++ meetingFailures
                    ++ costFailures

  putStrLn "-- EXIT GATE --"
  if null allFailures
    then do
      putStrLn "  no failures."
      putStrLn ""
      putStrLn "PAIRVOCAB SELF-TEST COMPLETE"
      exitSuccess
    else do
      printf "  %d FAILURES:\n" (length allFailures)
      mapM_ (putStrLn . ("    ! " ++)) allFailures
      putStrLn ""
      putStrLn "PAIRVOCAB SELF-TEST FAILED"
      exitFailure
