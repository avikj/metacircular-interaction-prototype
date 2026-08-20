-- Nalanda — a reactor, not a shelf.
--
-- WHAT THIS IS.  The corpus has Aryabhata's kuttaka (499), Brahmagupta's
-- bhavana (628) and the cakravala (Jayadeva ~950, Bhaskara II 1150) as
-- checked Agda modules.  Checked and inert.  They state what is true and
-- nothing turns them.
--
-- This file turns them.  Seed it with D and it runs the cycle until the
-- norm reaches 1, and what comes out is the fundamental solution of
-- x^2 - D y^2 = 1 -- Bhaskara's own answer for D = 61, which is
-- (1766319049, 226153980), reached by Brouncker in 1657 and proved
-- terminating by Lagrange in 1768, six hundred years late.
--
-- WHY IT IS NOT THE OTHER MACHINE.  `MathMachine` enumerates terms and
-- tests them: 25k terms, then 396k, conjectures generated and filtered, and
-- rounds 19 and 20 byte-identical with fresh = 0.  That is grinding against
-- a wall, and the wall is that ENUMERATION HAS NO GROWTH RULE -- it can only
-- sift a space someone else fixed.
--
-- Brahmagupta's rule is not a filter.  Given two solutions it COMPUTES a
-- third:
--
--     (x1^2 - D y1^2)(x2^2 - D y2^2) = (x1x2 + D y1y2)^2 - D(x1y2 + x2y1)^2
--
-- No search. No candidate set. The composition of two results IS a result,
-- and the norm multiplies, so the structure is closed and productive by
-- construction.  A reactor built on composition cannot deadlock the way an
-- enumerator does, because it never asks "which of these many things is
-- true" -- it only ever applies a rule that preserves truth.
--
-- And the cakravala is what supplies the fuel: when the norm is not 1, it
-- descends -- keep the remainder and recurse, which is the kuttaka's rule --
-- to a triple with a smaller norm, and the descent is exact because
-- Aryabhata's pulverizer solves the congruence that makes it exact.  The
-- three sources are one machine.  They always were; the separation into
-- three modules is an artefact of how the material reached us.
--
-- EXACT ARITHMETIC ONLY.  Integer throughout.  No floating point anywhere,
-- including the integer square root, which is Newton over Integer.  Per
-- CLAUDE.md a computed constant is worth nothing without its error term;
-- here there are no computed constants, only exact identities checked by
-- `verify` at every step and at the end.

module Nalanda
  ( Triple(..)
  , isqrt
  , valli
  , bezout
  , inverseMod
  , bhavana
  , tulya
  , compose
  , cakravala
  , cakravalaCapped
  , turnCap
  , shortcut
  , chooseM
  , chain
  , spectrum
  , solveNorm
  , familyFor
  , verify
  , selfTest
  ) where

import Data.List (minimumBy)
import Data.Ord (comparing)

-- ---------------------------------------------------------------- state
--
-- A triple (a, b, k) with a^2 - D b^2 = k.  The invariant is not a comment:
-- `verify` checks it and every producer below is checked against it in
-- `selfTest`.  Nothing in this file returns a bare pair of numbers.
data Triple = Triple { tA :: !Integer, tB :: !Integer, tK :: !Integer }
  deriving (Eq, Show)

verify :: Integer -> Triple -> Bool
verify d (Triple a b k) = a * a - d * (b * b) == k

-- ------------------------------------------------------- kuttaka (499)
--
-- ARYABHATA, Aryabhatiya, Ganitapada 32-33; the procedure step by step in
-- Bhaskara I's bhasya, 629.  Divide, KEEP THE REMAINDER AND RECURSE ON IT,
-- and write each quotient into the valli -- the column.  Then climb the
-- column: the coefficients at each row are built from the row below.
--
-- The remainder is not error to be discarded.  It is the next problem.
-- That is the growth rule, and it is the one `MathMachine` never had.

-- the valli itself: the column of quotients, kept, because the column IS
-- the algorithm and not scratch work
valli :: Integer -> Integer -> [Integer]
valli _ 0 = []
valli a b = (a `div` b) : valli b (a `mod` b)

-- back-substitution up the valli: (x, y, g) with a*x + b*y = g = gcd(a,b).
-- Each step takes the row below and forms (y', x' - q*y'), which is
-- Aryabhata's rule verbatim.
bezout :: Integer -> Integer -> (Integer, Integer, Integer)
bezout a 0 = (1, 0, a)
bezout a b = let (x', y', g) = bezout b (a `mod` b)
             in (y', x' - (a `div` b) * y', g)

-- the pulverizer used as it is used inside the cycle: b^{-1} mod n.
-- Nothing here assumes primality; the kuttaka needs only gcd(b,n) = 1.
inverseMod :: Integer -> Integer -> Maybe Integer
inverseMod b n
  | n <= 0 = Nothing
  | g /= 1 = Nothing
  | otherwise = Just (x `mod` n)
  where (x, _, g) = bezout (b `mod` n) n

-- ------------------------------------------------------ bhavana (628)
--
-- BRAHMAGUPTA, Brahmasphutasiddhanta 18.  THE REACTOR CORE.  Two solutions
-- in, one out, norms multiplied.  This is generation, not search: there is
-- no candidate set and nothing is tested, because the rule preserves the
-- invariant by algebra.
bhavana :: Integer -> Triple -> Triple -> Triple
bhavana d (Triple a1 b1 k1) (Triple a2 b2 k2) =
  Triple (a1 * a2 + d * b1 * b2) (a1 * b2 + a2 * b1) (k1 * k2)

-- tulya-bhavana: composition with itself, the only move available when you
-- hold exactly one solution -- which is the situation the cycle starts in.
tulya :: Integer -> Triple -> Triple
tulya d t = bhavana d t t

-- iterate the composition from a unit-norm seed.  This is the generativity
-- the 628 rule is named for: one solution, an infinite family, no search.
chain :: Integer -> Triple -> [Triple]
chain d seed = iterate (bhavana d seed) seed

compose :: Integer -> [Triple] -> Triple
compose d = foldr1 (bhavana d)

-- ---------------------------------------------------- cakravala (~950)
--
-- JAYADEVA, surviving through Udayadivakara's Sundari (1073); BHASKARA II,
-- Bijaganita (1150).  The cycle.  Compose the current triple with the
-- trivial triple (m, 1, m^2 - D), then divide through by k -- which is
-- exact precisely when the kuttaka has solved k | (a + b m).
--
-- BHASKARA'S CHOICE RULE, which is his contribution over Jayadeva: among
-- the m satisfying that one congruence, take the one minimising |m^2 - D|.
-- That is what makes the cycle terminate rather than wander, and it is why
-- the method needs no bound, no table, and no guessing.

-- exact integer square root, Newton over Integer.  No Double: at D = 109
-- the answer has fifteen digits and a Double would silently be wrong.
isqrt :: Integer -> Integer
isqrt n
  | n < 0 = error "isqrt: negative"
  | n < 2 = n
  | otherwise = go (n `div` 2)
  where
    go x = let y = (x + n `div` x) `div` 2
           in if y >= x then x else go y

-- the m Bhaskara's rule selects, given the current triple.
--
-- The congruence is  a + b*m = 0  (mod |k|),  i.e.  m = -a * b^{-1}.  The
-- kuttaka supplies the inverse.  Then walk the residue class and take the
-- member minimising |m^2 - D|.
--
-- THE WINDOW, CORRECTED 2026-08-20.  This comment used to justify the
-- truncation like this: "the minimiser is adjacent to sqrt D, so a short
-- window around it is exhaustive rather than sampled -- the window is checked
-- in `selfTest` by re-running with a wider one and comparing."  The first
-- clause is a theorem and the second is a measurement standing in for it, and
-- per CLAUDE.md a comparison of two runs over six values of D has no content.
-- It was also not testing what it said: `cakravalaWide` still carried the
-- |k| = 1 branch that `CakravalaBound.agda` §7 refuted, so the two functions
-- differed in their CHOICE RULE and not only in their window width, and both
-- rules reach the fundamental solution because any m satisfying the congruence
-- descends.  Both are repaired; see
-- notes/DosaLekha_TheCakravalaTurnCapIsNotABound.md §6.
--
-- The window is now DERIVED, in
-- `formal/cubical/Varana_TheChoiceWindowIsDerivedNotFitted.agda`: below sqrt D
-- the larger candidate is the better one and above it the smaller one is, so
-- given a bracketing pair the minimiser over the class is one of the two, and
-- the class has no member strictly between them.  A window of +/-1 is
-- exhaustive.  The +/-2 kept below is therefore a MARGIN of three candidates
-- over what the argument needs -- stated, rather than hoped for.
-- CORRECTED 2026-08-18, by `formal/cubical/CakravalaBound.agda` §7.
--
-- This read:
--
--     if n == 1 then Just (isqrt d)     -- congruence is vacuous mod 1
--
-- The comment is right and the code does not follow from it.  When |k| = 1 the
-- congruence IS vacuous, so every integer is a candidate — which means
-- Bhāskara's rule has its widest choice there, not none.  Returning ⌊√D⌋
-- unconditionally skips the minimisation exactly where it matters most.  At
-- D = 61, turn 7, that returned m = 7 with |49 − 61| = 12 when m = 8 gives
-- |64 − 61| = 3, and every header in this lane claiming "the m Bhāskara's rule
-- selects" was false at that turn.
--
-- The bound proved in `CakravalaBound.agda` is what turns that from an
-- observation into a refutation: any rule-obeying step satisfies
-- 16·k'² ≤ 36·D, and 16·12² = 2304 > 2196 = 36·61.  The kernel checks the
-- violation as `turn7ViolatesBound`.
--
-- No special case is needed: at n = 1 the general path gives r = 0 and a
-- window of integers around ⌊√D⌋, and the minimisation then picks correctly.
-- The branch was not an optimisation, only an error with a true comment on it.
chooseM :: Integer -> Triple -> Maybe Integer
chooseM d (Triple a b k) = do
  let n = abs k
  bi <- inverseMod b n
  let r  = ((- a) * bi) `mod` n
      t0 = (isqrt d - r) `div` n
      cands = [ r + t * n | t <- [t0 - 2 .. t0 + 2], r + t * n >= 0 ]
  if null cands
    then Nothing
    else Just (minimumBy (comparing (\m -> abs (m * m - d))) cands)

-- one turn of the wheel
step :: Integer -> Triple -> Maybe Triple
step d t@(Triple a b k) = do
  m <- chooseM d t
  let n = abs k
      a' = (a * m + d * b) `div` n
      b' = (a + b * m)     `div` n
      k' = (m * m - d)     `div` k
  pure (Triple (abs a') (abs b') k')

-- ------------------------------------------- Brahmagupta's shortcut (628)
--
-- BRAHMAGUPTA does not turn the wheel all the way to k = 1.  He states that
-- from a solution with k = -1, k = +/-2, or k = 4 the answer follows by
-- COMPOSITION alone, and this is centuries before the cycle exists -- it is
-- in the Brahmasphutasiddhanta, and the cakravala is later machinery built
-- on top of it.  Reproducing it here is not an optimisation bolted on; it is
-- the earlier and more general rule being used where it applies.
--
--   k = -1   compose with itself: (a^2 + D b^2, 2ab) has norm (-1)(-1) = 1.
--   k = +/-2 compose with itself: norm 4, and both coordinates are then
--            divisible by 2, giving norm 4/4 = 1.  (a^2 - D b^2 = +/-2 forces
--            a^2 + D b^2 even, so the halving is exact.)
--   k = 4    if a and b are both even, (a/2, b/2) has norm 4/4 = 1 directly.
--
-- The remaining k = 4 case with a, b not both even needs the parity argument
-- Brahmagupta gives separately; it is NOT implemented, and `shortcut` returns
-- Nothing there so the cycle simply keeps turning.  Returning Nothing when a
-- rule does not apply, rather than guessing, is the whole discipline.
shortcut :: Integer -> Triple -> Maybe Triple
shortcut d t@(Triple a b k)
  | k == 1 = Just t
  | k == -1 = Just (halveBy 1 (tulya d t))
  | abs k == 2 = Just (halveBy 2 (tulya d t))
  | k == 4 && even a && even b = Just (Triple (abs a `div` 2) (abs b `div` 2) 1)
  | otherwise = Nothing
  where
    -- (a', b', k') with a', b' divided by q and the norm by q^2; used only
    -- where the division is exact, which the guards above ensure.
    halveBy q (Triple a' b' k') =
      Triple (abs a' `div` q) (abs b' `div` q) (k' `div` (q * q))

-- THE TURN CAP, and what it is standing in for.
--
-- The loop needs a stopping condition and termination of the cakravala is
-- OPEN -- `formal/cubical/CakravalaBound.agda` says so in its own words:
-- "TERMINATION IS STILL OPEN.  A bound on |k| is not termination."  Until
-- 2026-08-20 the constant `400` stood there instead, derived from nothing.
--
-- IT WAS WRONG, and the failing case is D = 73516, which needs 441 turns and
-- on which the reactor returned `Left "no convergence in 400 turns"` while the
-- solution exists.  73516 is the SMALLEST such D -- every D from 2 to 73516
-- was run with the cap lifted and the turn counts compared, exact Integer
-- arithmetic throughout -- and 1370 values of D <= 200000 exceed 400 turns,
-- the worst being 744 turns at D = 195196.  A constant cap cannot be right in
-- any case: the turn count tracks the period of the continued fraction of
-- sqrt D, which grows like sqrt D.  That is HOLOGRAM.md section 7 exactly --
-- a constant measured at one scale hiding its scaling.  The whole record is
-- notes/DosaLekha_TheCakravalaTurnCapIsNotABound.md.
--
-- WHAT REPLACES IT.  `turnCap d = 2 * d`, which is the classical count of
-- reduced surds of discriminant 4D -- the pairs (P, Q) with 0 < P < sqrt D and
-- 0 < Q < 2 sqrt D -- and so bounds the period of the continued fraction of
-- sqrt D, of which the cakravala's cycle is a sub-walk.  NEITHER of those two
-- classical facts is checked in this repository, so this is a bound modulo two
-- named unproved inputs.  That is strictly better than a bound modulo nothing,
-- and it is stated as what it is rather than presented as settled.  Making it
-- checked means putting the finiteness of reduced forms of a given
-- discriminant into `formal/cubical/`, which is also most of what
-- `CakravalaBound.agda` names as missing for termination itself.
turnCap :: Integer -> Int
turnCap d = fromInteger (2 * d)

-- THE REACTOR.  Seed with the trivial triple and turn until the norm is 1.
-- Returns the whole trace, so every intermediate is auditable and the run
-- is not a number that must be trusted.
cakravala :: Integer -> Either String [Triple]
cakravala d = cakravalaCapped (turnCap d) d

-- The same reactor with the cap supplied by the caller, because a resource
-- limit that a caller cannot see or change is a limit that lies about being a
-- theorem.  `cakravala` is this with the derived default.
cakravalaCapped :: Int -> Integer -> Either String [Triple]
cakravalaCapped cap d
  | d < 2 = Left "cakravala: D must be at least 2"
  | isqrt d * isqrt d == d = Left "cakravala: D is a perfect square"
  | otherwise = go (Triple a0 1 (a0 * a0 - d)) (0 :: Int) []
  where
    a0 = isqrt d
    go t n acc
      | not (verify d t) = Left ("invariant broken at step " ++ show n
                                 ++ ": " ++ show t)
      | tK t == 1 = Right (reverse (t : acc))
      -- Brahmagupta (628) finishes from k = -1, +/-2, 4 by composition, so
      -- the wheel stops early where his earlier and more general rule
      -- applies.  The result is checked like everything else: a shortcut that
      -- broke the form would be caught here rather than trusted.
      | Just u <- shortcut d t, verify d u, tK u == 1
        = Right (reverse (u : t : acc))
      -- THE REMAINDER.  A truncated run that reports only "no convergence"
      -- has thrown away everything it did reach -- and what it reached is not
      -- nothing: every norm on the trace is a SOLVED equation x^2 - D y^2 = k
      -- (see `spectrum`), which is the whole point of the section below.  The
      -- ahimsa sutra's section 8 -- what states its remainder does not
      -- collapse -- is the same discipline this corpus learned on Madhava's
      -- series, where a truncated series with a quantified remainder is an
      -- algorithm and a truncated series alone is a curiosity.  So the
      -- failure names the turn, the cap, the state it stopped on and the
      -- norms already solved.  The checked analogue is `shesha-valli` in
      -- formal/cubical/KuttakaSamapti_TheValliIsFiniteForEveryPair.agda,
      -- where the result type has no constructor for a truncated run without
      -- its remainder.
      | n > cap = Left ("cakravala: cap of " ++ show cap
                        ++ " turns reached at turn " ++ show n
                        ++ " for D = " ++ show d
                        ++ "; NOT REACHED: k = 1."
                        ++ "  Remainder -- last triple " ++ show t
                        ++ "; norms already solved (each a solution of"
                        ++ " x^2 - D y^2 = k) " ++ show (map tK (reverse (t : acc)))
                        ++ ".  The cap is a resource limit, not a termination"
                        ++ " theorem: see"
                        ++ " notes/DosaLekha_TheCakravalaTurnCapIsNotABound.md.")
      | otherwise = case step d t of
          Nothing -> Left ("congruence unsolvable at step " ++ show n
                           ++ ": " ++ show t)
          Just t' -> go t' (n + 1) (t : acc)

-- ------------------------------------------- beyond Pell: general norms
--
-- BRAHMAGUPTA'S CLAIM IS NOT ABOUT N = 1.  The Brahmasphutasiddhanta states
-- composition for arbitrary norms -- two solutions with norms k1 and k2 give
-- one with norm k1*k2 -- and x^2 - D y^2 = 1 is a special case people later
-- made the whole subject.  Restricting a reactor built on the 628 rule to
-- N = 1 is reading the source through the equation that displaced it.
--
-- So: the cycle passes through a sequence of norms on its way to 1, and each
-- one it visits is a SOLVED equation.  For D = 61 the wheel visits
-- -12, 3, -4, -5, 5, 4, -3, -1 before reaching 1, so x^2 - 61 y^2 = 3 is
-- answered by (8, 1) with no extra work at all -- 64 - 61 = 3.
--
-- SCOPE, STATED RATHER THAN IMPLIED.  This finds solutions for exactly the
-- norms THIS cycle visits.  A norm the cycle does not pass through is not
-- found here, and `solveNorm` says so instead of searching.  The general
-- problem for arbitrary N needs more than the cycle's trace and is not
-- claimed.

-- every norm the wheel visits, with the triple that realises it
spectrum :: Integer -> Either String [(Integer, Triple)]
spectrum d = fmap (map (\t -> (tK t, t))) (cakravala d)

-- a solution of x^2 - D y^2 = n, if the cycle visits that norm
solveNorm :: Integer -> Integer -> Either String Triple
solveNorm d n = do
  tr <- cakravala d
  case [ t | t <- tr, tK t == n ] of
    (t:_) -> Right t
    []    -> Left ("norm " ++ show n ++ " is not on the cycle for D = " ++ show d)

-- BHAVANA AGAIN, and this is the generative half.  Composing a norm-n
-- solution with the norm-1 fundamental gives another norm-n solution, since
-- n * 1 = n.  So ONE solution of x^2 - D y^2 = n yields infinitely many, by
-- computation and with no search -- which is what "production" names.
familyFor :: Integer -> Triple -> Either String [Triple]
familyFor d t = do
  tr <- cakravala d
  pure (iterate (bhavana d (last tr)) t)

-- ---------------------------------------------------------------- test
--
-- The classical hard cases, each with the answer the tradition records.
-- D = 61 is Bhaskara's own worked example and the one Fermat later posed as
-- a challenge problem; D = 109 has a fifteen-digit answer and is where any
-- floating-point step would silently produce a wrong number.
--
-- Every line is checked by exact Integer arithmetic against the defining
-- equation, not against a stored answer alone: `verify` recomputes
-- a^2 - D b^2 and demands 1.
selfTest :: IO Bool
selfTest = do
    putStrLn "  D        turns   a                b                a^2-D b^2"
    rs <- mapM report classical
    putStrLn ""
    putStrLn "  -- bhavana generates: compose the fundamental solution with"
    putStrLn "     itself and the norm stays 1, without any search --"
    gen <- mapM genReport [2, 13, 61]
    putStrLn ""
    putStrLn "  -- beyond Pell: every norm the wheel visits is a solved"
    putStrLn "     equation, and bhavana makes each one an infinite family --"
    beyond <- mapM beyondReport [61, 109]
    putStrLn ""
    putStrLn "  -- the choice window: DERIVED in"
    putStrLn "     formal/cubical/Varana_TheChoiceWindowIsDerivedNotFitted.agda"
    putStrLn "     (+/-1 is exhaustive; chooseM's +/-2 is a stated margin).  The"
    putStrLn "     run below is a regression guard, not the justification, and"
    putStrLn "     it compares the m CHOSEN AT EVERY TURN -- comparing final"
    putStrLn "     answers has no content, since any m satisfying the"
    putStrLn "     congruence descends to the same fundamental solution --"
    let wide = all widthAgrees classical
    putStrLn ("     choices agree at widths 1, 2, 6: " ++ show wide)
    putStrLn ""
    putStrLn "  -- the turn cap is a resource limit and NOT a termination"
    putStrLn "     theorem: D = 73516 needs 441 turns and the old constant cap"
    putStrLn "     of 400 returned Left on it.  See"
    putStrLn "     notes/DosaLekha_TheCakravalaTurnCapIsNotABound.md --"
    let capOk = case cakravalaCapped 400 73516 of
                  Left _  -> True     -- the old cap does fail, as recorded
                  Right _ -> False
        capFixed = case cakravala 73516 of
                     Left _   -> False
                     Right tr -> let t = last tr in verify 73516 t && tK t == 1
    putStrLn ("     old cap 400 fails at D=73516: " ++ show capOk
              ++ "; derived cap succeeds: " ++ show capFixed)
    pure (and rs && and gen && and beyond && wide && capOk && capFixed)
  where
    -- (D, expected a, expected b) as the tradition records them
    classical =
      [ (2,   3,          2)
      , (3,   2,          1)
      , (13,  649,        180)
      , (61,  1766319049, 226153980)
      , (67,  48842,      5967)
      , (109, 158070671986249, 15140424455100)
      ]

    report (d, ea, eb) = case cakravala d of
      Left err -> putStrLn ("  " ++ show d ++ "  FAILED: " ++ err) >> pure False
      Right tr -> do
        let t = last tr
            ok = verify d t && tA t == ea && tB t == eb && tK t == 1
        putStrLn ("  " ++ pad 8 (show d) ++ pad 8 (show (length tr))
                  ++ pad 17 (show (tA t)) ++ pad 17 (show (tB t))
                  ++ show (tA t * tA t - d * tB t * tB t)
                  ++ (if ok then "" else "   <-- MISMATCH"))
        pure ok

    -- composition preserves the invariant with no search and no testing
    genReport d = case cakravala d of
      Left _ -> pure False
      Right tr -> do
        let s  = last tr
            ts = take 4 (chain d s)
            ok = all (\t -> verify d t && tK t == 1) ts
        putStrLn ("     D=" ++ pad 5 (show d)
                  ++ concatMap (\t -> " (" ++ show (tA t) ++ "," ++ show (tB t) ++ ")")
                               (take 3 ts)
                  ++ (if ok then "" else "   <-- MISMATCH"))
        pure ok

    -- Every norm on the wheel, verified against the defining equation, and
    -- for one of them the first three members of its bhavana family --
    -- each of which must have the SAME norm, since n * 1 = n.
    beyondReport d = case spectrum d of
      Left _ -> pure False
      Right sp -> do
        let norms = map fst sp
            allOk = all (\(n, t) -> verify d t && tK t == n) sp
        putStrLn ("     D=" ++ pad 5 (show d) ++ "norms on the wheel: "
                  ++ show norms)
        case [ t | (n, t) <- sp, n /= 1, n > 0 ] of
          [] -> pure allOk
          (t : _) -> case familyFor d t of
            Left _ -> pure False
            Right fam -> do
              let three = take 3 fam
                  famOk = all (\u -> verify d u && tK u == tK t) three
              putStrLn ("            x^2 - " ++ show d ++ " y^2 = " ++ show (tK t)
                        ++ ":" ++ concatMap
                             (\u -> " (" ++ show (tA u) ++ "," ++ show (tB u) ++ ")")
                             three)
              pure (allOk && famOk)

    -- the m selected at every turn must not depend on the window width.
    -- Widths 1, 2 and 6 must give the identical sequence of choices; that is
    -- the claim the width makes, and it is what `Varana_...agda` proves.
    widthAgrees (d, _, _) =
      let c1 = choicesAtWidth 1 d
          c2 = choicesAtWidth 2 d
          c6 = choicesAtWidth 6 d
      in c1 == c2 && c2 == c6 && c1 /= Nothing

    pad n s = s ++ replicate (max 0 (n - length s)) ' '

-- The same reactor with a wider choice window, used to check that the narrow
-- one is not quietly truncating the search.
--
-- REPAIRED 2026-08-20, and the repair matters more than the function.  This
-- carried
--
--     if n == 1 then Just (isqrt d) else do
--
-- which is the branch `formal/cubical/CakravalaBound.agda` §7 refuted on
-- 2026-08-18 and which was removed from `chooseM` in that same commit.  So the
-- two functions `selfTest` compared differed in their CHOICE RULE and not only
-- in their window width, and both rules reach the fundamental solution because
-- any m satisfying the congruence descends.  The check therefore passed while
-- testing nothing whatever about the window: it compared final answers, which
-- agree for any valid rule, using a rule that had already been proved wrong.
--
-- It now differs from `chooseM` in the window width and in nothing else, and
-- `selfTest` compares the m SELECTED AT EVERY TURN rather than the final
-- answer -- which is the only comparison that has content, since the final
-- answer is insensitive to the choice.
--
-- And the comparison is no longer the justification.  The window is DERIVED in
-- `formal/cubical/Varana_TheChoiceWindowIsDerivedNotFitted.agda`: +/-1 is
-- exhaustive, so the +/-2 in `chooseM` is a stated margin.  This function is
-- now a regression guard against an edit to `chooseM`, not evidence for it.
chooseMWindow :: Integer -> Integer -> Triple -> Maybe Integer
chooseMWindow w d (Triple a b k) = do
  let n = abs k
  bi <- inverseMod b n
  let r  = ((- a) * bi) `mod` n
      t0 = (isqrt d - r) `div` n
      cands = [ r + t * n | t <- [t0 - w .. t0 + w], r + t * n >= 0 ]
  if null cands
    then Nothing
    else Just (minimumBy (comparing (\m -> abs (m * m - d))) cands)

-- the m selected at each turn, under a given window width.  Comparing THESE
-- across widths is the check; comparing final answers is not.
choicesAtWidth :: Integer -> Integer -> Maybe [Integer]
choicesAtWidth w d = go (Triple a0 1 (a0 * a0 - d)) (0 :: Int) []
  where
    a0 = isqrt d
    go t n acc
      | tK t == 1 = Just (reverse acc)
      | n > turnCap d = Just (reverse acc)   -- the cap's remainder is the
                                             -- caller's problem here; this
                                             -- function reports choices only
      | otherwise = case chooseMWindow w d t of
          Nothing -> Nothing
          Just m ->
            let q  = abs (tK t)
                t' = Triple (abs ((tA t * m + d * tB t) `div` q))
                            (abs ((tA t + tB t * m) `div` q))
                            ((m * m - d) `div` tK t)
            in go t' (n + 1) (m : acc)
