-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- Turn the general wheel.
--
--     runghc -imachine machine/VargaPrakrtiRun_TurnTheGeneralWheel.hs --self-test
--     runghc -imachine machine/VargaPrakrtiRun_TurnTheGeneralWheel.hs 61
--     runghc -imachine machine/VargaPrakrtiRun_TurnTheGeneralWheel.hs --pell 61
--     runghc -imachine machine/VargaPrakrtiRun_TurnTheGeneralWheel.hs --order 3 1
--     runghc -imachine machine/VargaPrakrtiRun_TurnTheGeneralWheel.hs --ghana 2
--
-- `<Δ>` runs the MAXIMAL order of discriminant Δ; `--pell D` runs ℤ[√D],
-- which is `Nalanda`'s case, so the two can be compared side by side.
-- `--order T C` runs ℤ[ω] with ω² = Tω + C for arbitrary T and C.
-- `--ghana d` runs ℤ[∛d], where leg 3 is absent and the run returns the
-- written defect rather than a number.
--
-- Every run prints the whole trace.  The answer arrives with its derivation
-- attached and nothing has to be trusted.  A refusal prints the defect,
-- with the failing instance, and exits non-zero.

module Main (main) where

import VargaPrakrti_CompositionLawAsParameter
import System.Environment (getArgs)
import System.Exit
import Text.Printf (printf)

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["--self-test"] -> do
      ok <- selfTest
      putStrLn (if ok then "VARGAPRAKRTI REACTOR CHECKED" else "VARGAPRAKRTI FAILED")
      if ok then exitSuccess else exitFailure
    ["--pell", a] | [(d, "")] <- reads a -> quad ("ℤ[√" ++ show d ++ "]") d (pellLaw d)
    ["--order", a, b] | [(t, "")] <- reads a, [(c, "")] <- reads b ->
      quad ("ℤ[ω], ω² = " ++ show t ++ "ω + " ++ show c) (t * t + 4 * c)
           (vargaPrakrti t c)
    ["--ghana", a] | [(d, "")] <- reads a -> ghana d
    [a] | [(dd, "")] <- reads a ->
      quad ("maximal order of discriminant " ++ show dd) dd (maximalOrderLaw dd)
    _ -> do
      putStrLn "usage: VargaPrakrtiRun <Δ> | --pell D | --order T C | --ghana d \
               \| --self-test"
      exitFailure

quad :: String -> Integer -> Either Defect (Law Quad) -> IO ()
quad title dd elaw = case elaw of
  Left def -> refuse def
  Right law -> case reactor law of
    Left def -> refuse def
    Right tr -> do
      printf "%s\n  %s\n\n" title (lawSource law)
      printf "  turn   %-26s %-24s N\n" "x" "y"
      mapM_ (\(i, q@(Quad x y)) ->
               printf "  %-6d %-26s %-24s %d\n" (i :: Int) (show x) (show y)
                 (lawNorm law q))
            (zip [0 ..] tr)
      let e@(Quad ex ey) = last tr
      -- recover T and C from the norm form itself rather than passing them
      -- in, so the printed presentation cannot disagree with the law that
      -- was actually run: N(0,1) = −C and N(1,1) = 1 + T − C.
      let cc = negate (lawNorm law (Quad 0 1))
          tt = lawNorm law (Quad 1 1) - 1 + cc
      printf "\n  fundamental unit  ε = (%d, %d)   N(ε) = %d\n"
             ex ey (lawNorm law e)
      if tt == 1
        then printf "                        = (%d + %d√%d)/2   (basis 1, ω)\n"
                    (2 * ex + ey) ey dd
        else if tt == 0
          then printf "                        = %d + %d√%d   (basis 1, √C)\n"
                      ex ey cc
          else printf "                        = %d + %d·ω,  ω² = %dω + %d\n"
                      ex ey tt cc
      case normOneSolution law of
        Left def -> refuse def
        Right p@(Quad px py) ->
          printf "  norm-one solution     (%d, %d)   N = %d\n"
                 px py (lawNorm law p)

ghana :: Integer -> IO ()
ghana d = do
  let law = ghanaLaw d
      e   = Ghana (-1) 1 0
  printf "%s\n  %s\n\n" (lawName law) (lawSource law)
  case composeChecked law e e of
    Left def -> refuse def
    Right e2 -> do
      printf "  legs 1 and 2 RUN and are checked at every composition:\n"
      printf "    ε  = %s   N = %d\n" (show e) (lawNorm law e)
      printf "    ε² = %s   N = %d\n" (show e2) (lawNorm law e2)
      printf "\n  leg 3:\n"
      case reactor law of
        Right _ -> putStrLn "  the descent returned an answer it has no right to"
                     >> exitFailure
        Left def -> refuse def

refuse :: Defect -> IO ()
refuse def = mapM_ (putStrLn . ("  " ++)) (lines (renderDefect def)) >> exitFailure
