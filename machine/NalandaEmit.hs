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

-- NalandaEmit — the reactor emits its answer as Agda, and the kernel checks it.
--
--     runghc -imachine machine/NalandaEmit.hs 61 > formal/cubical/CakravalaWitness.agda
--     cd formal/cubical && agda CakravalaWitness.agda
--
-- WHY.  `NalandaRun` prints numbers.  A printed number must be trusted -- the
-- reader trusts the program, its author, and the run, which is exactly what
-- CLAUDE.md says an experiment stands in for.  A checked term is the object
-- itself and it is still there tomorrow.  So the reactor does not stop at a
-- number: it writes its answer as a module the kernel recomputes.
--
-- OVER ℕ, SUBTRACTION-FREE.  This is forced, and finding out why was worth
-- more than the file.
--
-- Cubical's ℤ multiplication is UNARY:
--
--     pos (suc n) · m = m + pos n · m           (Cubical/Data/Int/Base.agda)
--     z +pos (suc n)  = sucℤ (z +pos n)
--
-- so `pos 1766319049 · pos 1766319049` as `refl` asks the kernel for about
-- 10^18 unfoldings.  It does not finish; an attempt at D = 61 over ℤ had to
-- be killed.  **No ℤ literal arithmetic much above 10^6 is checkable by refl
-- in this library**, which is a constraint on every future plan in this
-- repository that reaches for "check it with refl over ℤ", and it retroactively
-- explains why `Bhavana.agda` is solver-free hand-chaining over an abstract
-- CommRing rather than concrete ℤ.
--
-- Cubical's ℕ, by contrast, IS `Agda.Builtin.Nat` -- `_+_` and `_·_` are the
-- GMP-backed builtins -- so ℕ arithmetic on fifteen-digit literals is instant.
--
-- Which sends the witness to exactly where `BhavanaSemiring.agda` already put
-- bhāvanā: ℕ, with every subtraction cleared.  x^2 - D y^2 = 1 becomes
--
--     a · a ≡ D · (b · b) + 1
--
-- and the composition law becomes the semiring identity that file proves for
-- all naturals.  The constraint and the right form turn out to be the same
-- discovery, which is the usual shape of these.
--
-- EVERY TURN IS CERTIFIED.  An earlier version of this header said a per-turn
-- certificate was "a real piece of work and is not done here", because
-- `CakravalaDescent.cakravalaScaled` is stated over a CommRing with genuine
-- subtraction and the turns carry negative k.  That was true and it was the
-- wrong conclusion: the answer was not to certify over ℤ but to CLEAR THE
-- SUBTRACTION, which is what `BhavanaSemiring` had already done for bhāvanā
-- for exactly the same reason.  `CakravalaNat.cakravalaℕ` is the cycle's step
-- with both negative terms carried across —
--
--     (am + Db)² + D·a² + D·b²m²  ≡  a²m² + D²b² + D·(a + bm)²
--
-- — a commutative-semiring identity, true for all naturals, no hypothesis, no
-- case analysis on the sign of k.  The sign of k was the entire obstacle and
-- clearing removes it rather than handling it.  Each turn below instantiates
-- that theorem at its own (a, b, m).
--
-- Note what the per-turn lines are NOT: they are not `refl`.  A `refl` per
-- turn would show only that this generator's arithmetic agrees with the
-- kernel's.  These are Brahmagupta's law firing, once per turn.
--
-- STILL NOT EMITTED: k and k' themselves.  `cakravalaℕ` is the step's
-- IDENTITY, not its bookkeeping, and the bookkeeping is where the signs live.
-- The trace of (a, b, k) is emitted as comments, marked as the generator's
-- word and not the kernel's.

module Main (main) where

import qualified Nalanda as N
import System.Environment (getArgs)
import System.Exit
import System.IO (hSetEncoding, stdout, utf8)

main :: IO ()
main = do
  hSetEncoding stdout utf8
  args <- getArgs
  case args of
    [raw] | [(d, "")] <- reads raw -> emit d
    _ -> putStrLn "usage: NalandaEmit <D>" >> exitFailure

emit :: Integer -> IO ()
emit d = case N.cakravala d of
  Left err -> putStrLn ("-- reactor failed: " ++ err) >> exitFailure
  Right trace -> do
    let t = last trace
        sq = N.tulya d t
    -- Refuse to emit a claim the generator itself cannot verify.  If this
    -- fires, the bug is in the reactor and the Agda file would only hide it.
    if N.tA t * N.tA t /= d * (N.tB t * N.tB t) + 1
      then putStrLn "-- reactor produced a non-solution; refusing to emit"
             >> exitFailure
      else if N.tA sq * N.tA sq /= d * (N.tB sq * N.tB sq) + 1
        then putStrLn "-- composition produced a non-solution; refusing to emit"
               >> exitFailure
        else putStr (render d trace t sq)

render :: Integer -> [N.Triple] -> N.Triple -> N.Triple -> String
render d trace t sq = unlines $
  -- `--guardedness` added 2026-08-20: Agda's [InfectiveImport] rule makes it
  -- propagate, so a module opening Cubical.Foundations.Prelude without it fails
  -- at SCOPE-CHECKING under a cubical library compiled with it (Agda 2.8.0).
  -- Kept equal to Certificate.kOptionsPragma by
  -- scripts/Anuvrtti_TheOptionsLineIsSaidOnceAndContinues.sh.
  [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
  , ""
  , sep
  , "-- CakravalaWitness — EMITTED BY THE REACTOR, CHECKED BY THE KERNEL."
  , "--"
  , "-- Generated by `runghc -imachine machine/NalandaEmit.hs " ++ show d ++ "`."
  , "-- Do not hand-edit; regenerate.  The point of the file is that the"
  , "-- reactor's answer is a checked term and not a number to be trusted."
  , "--"
  , "-- BHĀSKARA II, Bījagaṇita (1150), the cakravāla, on"
  , "--"
  , "--     x² − " ++ show d ++ " y² = 1"
  , "--"
  , "-- reached in " ++ show (length trace - 1) ++ " turns of the wheel from the seed"
  , "-- (⌊√" ++ show d ++ "⌋, 1, ⌊√" ++ show d ++ "⌋² − " ++ show d ++ ").  Each turn's m is"
  , "-- the one Bhāskara's choice rule selects — among the m with k | (a + bm),"
  , "-- the one minimising |m² − D| — and that congruence is solved by"
  , "-- ĀRYABHAṬA's kuṭṭaka (Āryabhaṭīya, Gaṇitapāda 32–33, 499)."
  , "--"
  , "-- STATED OVER ℕ, SUBTRACTION-FREE, and that is forced rather than"
  , "-- stylistic.  Cubical's ℤ multiplication is unary — `pos (suc n) · m ="
  , "-- m + pos n · m` — so a `refl` on nine-digit ℤ literals asks for ~10¹⁸"
  , "-- unfoldings and never returns.  Cubical's ℕ is `Agda.Builtin.Nat`, whose"
  , "-- `_+_` and `_·_` are GMP-backed, so the same statement over ℕ is instant."
  , "-- Clearing the subtraction is exactly what `BhavanaSemiring.agda` does for"
  , "-- bhāvanā, for the same reason."
  , "--"
  , "-- THE TRACE BELOW IS THE GENERATOR'S WORD, NOT THE KERNEL'S.  It is here"
  , "-- so the derivation is inspectable; only the theorems are checked."
  , "--"
  ]
  ++ [ "--   turn " ++ pad 4 (show i) ++ pad 20 (show a) ++ pad 20 (show b)
       ++ "k = " ++ show k
     | (i, N.Triple a b k) <- zip [0 :: Int ..] trace ]
  ++
  [ sep
  , ""
  , "module CakravalaWitness where"
  , ""
  , "open import Cubical.Foundations.Prelude"
  , "open import Cubical.Data.Nat using (ℕ ; _+_ ; _·_)"
  , "open import Cubical.Data.Sigma using (_×_ ; _,_)"
  , "open import BhavanaSemiring using (cx ; cy ; bhavanaℕ)"
  , "open import CakravalaNat using (ca ; cb ; cakravalaℕ)"
  , ""
  , "D : ℕ"
  , "D = " ++ show d
  , ""
  , sep
  , "-- EVERY TURN OF THE WHEEL, CERTIFIED BY THE GENERAL THEOREM."
  , "--"
  , "-- Each line below instantiates `CakravalaNat.cakravalaℕ` — proved for ALL"
  , "-- naturals as a commutative-semiring identity — at that turn's own"
  , "-- (a, b, m).  Note what this is NOT: it is not `refl`.  A `refl` per turn"
  , "-- would show only that this generator's arithmetic agrees with the"
  , "-- kernel's, and would not tie the run to Brahmagupta's law at all.  These"
  , "-- are the law firing, once per turn."
  , "--"
  , "-- The m on each line is the one BHĀSKARA'S CHOICE RULE selects: among the"
  , "-- m with k | (a + bm), the one minimising |m² − D|.  The congruence is"
  , "-- solved by ĀRYABHAṬA's kuṭṭaka (Āryabhaṭīya, Gaṇitapāda 32–33, 499)."
  , sep
  , "" ]
  ++ concat [ turnBlock i a b m | (i, a, b, m) <- turnData ]
  ++
  [ sep
  , "-- THE BOOKKEEPING: the three divisions came out exact."
  , "--"
  , "-- The identity above is the step's CONTENT; these are the step's"
  , "-- ACCOUNTS.  Bhāskara's choice rule earns its keep exactly here — it"
  , "-- picks the one m for which all three of these divisions are exact, and"
  , "-- `CakravalaDescent.oneCongruenceCoprime` proves that asking for the"
  , "-- middle one alone suffices, given the pulverizer's coefficients."
  , "--"
  , "-- Two of the three are subtraction-free as they stand: a·m + D·b and"
  , "-- a + b·m are sums of naturals.  Only m² − D can go negative, and"
  , "-- |m² − D| = |k|·|k'| holds either way, so each line below is emitted in"
  , "-- whichever orientation is true at that turn.  The SIGNS of k and k' are"
  , "-- not recovered here — they are in the trace comments above, and they are"
  , "-- the generator's word, not the kernel's."
  , sep
  , "" ]
  ++ concat [ bookBlock i a b m p a' b' k'
            | (i, a, b, m, p, a', b', k') <- bookData ]
  ++ concat [ shortBlock i from to | (i, from, to) <- shortData ]
  ++
  [ ""
  , sep
  , "-- THE FUNDAMENTAL SOLUTION.  `refl`: the kernel recomputes both sides."
  , sep
  , ""
  , "a b : ℕ"
  , "a = " ++ show (N.tA t)
  , "b = " ++ show (N.tB t)
  , ""
  , "fundamental : a · a ≡ D · (b · b) + 1"
  , "fundamental = refl"
  , ""
  , sep
  , "-- BHĀVANĀ (Brahmagupta, Brāhmasphuṭasiddhānta 18, 628) GENERATES ONWARD."
  , "--"
  , "-- The next solution is not searched for.  It is Brahmagupta's composition"
  , "-- of the solution with itself — tulya-bhāvanā — and `cx`/`cy` below are"
  , "-- his own two coordinates, taken from `BhavanaSemiring` rather than"
  , "-- rewritten here."
  , sep
  , ""
  , "a² b² : ℕ"
  , "a² = " ++ show (N.tA sq)
  , "b² = " ++ show (N.tB sq)
  , ""
  , "-- the composite really is Brahmagupta's composite, not a number this"
  , "-- generator chose: cx and cy at (a, b, a, b) evaluate to it"
  , "compositeIsBhavana : (cx D a b a b ≡ a²) × (cy a b a b ≡ b²)"
  , "compositeIsBhavana = refl , refl"
  , ""
  , "-- and it solves the same equation"
  , "composed : a² · a² ≡ D · (b² · b²) + 1"
  , "composed = refl"
  , ""
  , sep
  , "-- THE GENERAL THEOREM, FIRED AT THESE NUMBERS."
  , "--"
  , "-- `bhavanaℕ` is proved in `BhavanaSemiring.agda` for ALL naturals, as a"
  , "-- commutative-semiring identity.  Instantiating it here is what makes the"
  , "-- two `refl`s above an instance of Brahmagupta's law rather than an"
  , "-- arithmetic coincidence that happens to hold at one pair of numbers."
  , sep
  , ""
  , "law : cx D a b a b · cx D a b a b"
  , "        + (D · (a · a · (b · b)) + D · (a · a · (b · b)))"
  , "    ≡ a · a · (a · a)"
  , "        + (D · D · (b · b · (b · b))"
  , "           + D · (cy a b a b · cy a b a b))"
  , "law = bhavanaℕ D a b a b"
  ]
  where
    sep = "------------------------------------------------------------------------"
    pad n s = s ++ replicate (max 0 (n - length s)) ' '

    -- (index, a, b, m) for every turn that has a successor.  The trace's a and
    -- b are already non-negative — `Nalanda` carries the classical |k|
    -- presentation — which is exactly what the ℕ statement wants, so no
    -- re-signing is needed here at all.  That the classical presentation and
    -- the subtraction-free one agree on the coordinates is not a coincidence:
    -- clearing the subtraction is what removed the signs in the first place.
    turnData = [ (i, a, b, m)
               | (i, N.Triple a b k) <- zip [0 :: Int ..] (init trace)
               , Just m <- [N.chooseM d (N.Triple a b k)] ]

    -- Consecutive pairs, classified.  NOT every transition is a turn of the
    -- wheel: the reactor finishes by BRAHMAGUPTA'S SHORTCUT (628) wherever it
    -- applies — from k = −1, ±2, or 4 the answer follows by composition, and
    -- that rule predates the cycle by five centuries.  Emitting a cakravāla
    -- bookkeeping line for a shortcut transition produces a false statement,
    -- and did: the first version of this emitter claimed
    -- `29718 · 7 + D · 3805 ≡ 1 · 1766319049` and Agda refused it.  The
    -- kernel caught the generator, which is the entire reason for emitting.
    transitions = zip [0 :: Int ..] (zip trace (drop 1 trace))

    isShortcut (from, to) = case N.shortcut d from of
      Just u  -> u == to
      Nothing -> False

    bookData = [ (i, a, b, m, abs k, a', b', abs k')
               | (i, (N.Triple a b k, N.Triple a' b' k')) <- transitions
               , not (isShortcut (N.Triple a b k, N.Triple a' b' k'))
               , Just m <- [N.chooseM d (N.Triple a b k)] ]

    shortData = [ (i, from, to) | (i, (from, to)) <- transitions
                                , isShortcut (from, to) ]

    turnBlock i a b m =
      [ "-- turn " ++ show i ++ ":  a = " ++ show a ++ ",  b = " ++ show b
        ++ ",  m = " ++ show m
      , nm ++ " : ca D " ++ show a ++ " " ++ show b ++ " " ++ show m
             ++ " · ca D " ++ show a ++ " " ++ show b ++ " " ++ show m
      , "     + (D · (" ++ show a ++ " · " ++ show a ++ ") + D · ("
             ++ show b ++ " · " ++ show b ++ " · (" ++ show m ++ " · "
             ++ show m ++ ")))"
      , "     ≡ " ++ show a ++ " · " ++ show a ++ " · (" ++ show m ++ " · "
             ++ show m ++ ")"
      , "     + (D · D · (" ++ show b ++ " · " ++ show b ++ ") + D · (cb "
             ++ show a ++ " " ++ show b ++ " " ++ show m ++ " · cb "
             ++ show a ++ " " ++ show b ++ " " ++ show m ++ "))"
      , nm ++ " = cakravalaℕ D " ++ show a ++ " " ++ show b ++ " " ++ show m
      , ""
      ]
      where nm = "turn" ++ show i

    -- THE BOOKKEEPING, per turn, as ℕ equations the kernel recomputes.
    --
    -- Two of the three divisions are already subtraction-free: a·m + D·b and
    -- a + b·m are sums of naturals, so `= p · a'` and `= p · b'` say exactly
    -- that those divisions came out exact, with no signs anywhere.  The third,
    -- m² − D, is the only one that can go negative, and |m² − D| = p · |k'|
    -- holds regardless of which way it goes — so it is emitted as whichever
    -- orientation is true at this turn.
    bookBlock i a b m p a' b' k' =
      [ "-- turn " ++ show i ++ " bookkeeping:  |k| = " ++ show p
        ++ ",  a' = " ++ show a' ++ ",  b' = " ++ show b'
        ++ ",  |k'| = " ++ show k'
      , dA ++ " : " ++ show a ++ " · " ++ show m ++ " + D · " ++ show b
             ++ " ≡ " ++ show p ++ " · " ++ show a'
      , dA ++ " = refl"
      , dB ++ " : " ++ show a ++ " + " ++ show b ++ " · " ++ show m
             ++ " ≡ " ++ show p ++ " · " ++ show b'
      , dB ++ " = refl"
      , dK ++ " : " ++ (if m * m >= d
                         then show m ++ " · " ++ show m ++ " ≡ D + "
                              ++ show p ++ " · " ++ show k'
                         else show m ++ " · " ++ show m ++ " + "
                              ++ show p ++ " · " ++ show k' ++ " ≡ D")
      , dK ++ " = refl"
      , ""
      ]
      where
        dA = "divA" ++ show i
        dB = "divB" ++ show i
        dK = "divK" ++ show i

    -- BRAHMAGUPTA'S SHORTCUT, certified by Brahmagupta's own identity.
    --
    -- Where the cycle reaches k = −1 or ±2 the finish is tulya-bhāvanā — the
    -- solution composed with itself — followed by an exact division of both
    -- coordinates by 1 or 2.  So `cx`/`cy` (Brahmagupta's coordinates, from
    -- `BhavanaSemiring`) evaluate to q·a′ and q·b′, and `bhavanaℕ` at
    -- (a, b, a, b) is the law behind it.  Where k = 4 with both coordinates
    -- even the finish is the halving alone and no composition happens; that
    -- case is emitted as the two halvings and nothing more, because claiming
    -- a composition that did not occur is the defect this section exists to
    -- avoid.
    shortBlock i (N.Triple a b k) (N.Triple a' b' _) =
      [ "-- BRAHMAGUPTA'S SHORTCUT at transition " ++ show i
        ++ ":  k = " ++ show k ++ ",  (" ++ show a ++ ", " ++ show b
        ++ ")  ->  (" ++ show a' ++ ", " ++ show b' ++ "),  k = 1" ]
      ++ (if k == 4
            then [ "-- k = 4 with both coordinates even: halving alone, no composition"
                 , sA ++ " : " ++ show a ++ " ≡ 2 · " ++ show a'
                 , sA ++ " = refl"
                 , sB ++ " : " ++ show b ++ " ≡ 2 · " ++ show b'
                 , sB ++ " = refl" ]
            else [ "-- tulya-bhāvanā, then exact division of both coordinates by "
                     ++ show q
                 , sA ++ " : cx D " ++ show a ++ " " ++ show b ++ " "
                     ++ show a ++ " " ++ show b ++ " ≡ " ++ show q ++ " · " ++ show a'
                 , sA ++ " = refl"
                 , sB ++ " : cy " ++ show a ++ " " ++ show b ++ " "
                     ++ show a ++ " " ++ show b ++ " ≡ " ++ show q ++ " · " ++ show b'
                 , sB ++ " = refl"
                 , "-- and the law the composition is an instance of"
                 , sL ++ " : cx D " ++ show a ++ " " ++ show b ++ " " ++ show a
                     ++ " " ++ show b ++ " · cx D " ++ show a ++ " " ++ show b
                     ++ " " ++ show a ++ " " ++ show b
                 , "     + (D · (" ++ show a ++ " · " ++ show a ++ " · ("
                     ++ show b ++ " · " ++ show b ++ ")) + D · (" ++ show a
                     ++ " · " ++ show a ++ " · (" ++ show b ++ " · " ++ show b ++ ")))"
                 , "     ≡ " ++ show a ++ " · " ++ show a ++ " · (" ++ show a
                     ++ " · " ++ show a ++ ")"
                 , "     + (D · D · (" ++ show b ++ " · " ++ show b ++ " · ("
                     ++ show b ++ " · " ++ show b ++ "))"
                 , "        + D · (cy " ++ show a ++ " " ++ show b ++ " "
                     ++ show a ++ " " ++ show b ++ " · cy " ++ show a ++ " "
                     ++ show b ++ " " ++ show a ++ " " ++ show b ++ "))"
                 , sL ++ " = bhavanaℕ D " ++ show a ++ " " ++ show b ++ " "
                     ++ show a ++ " " ++ show b ])
      ++ [ "" ]
      where
        q = if abs k == 2 then 2 else 1 :: Integer
        sA = "shortA" ++ show i
        sB = "shortB" ++ show i
        sL = "shortLaw" ++ show i
