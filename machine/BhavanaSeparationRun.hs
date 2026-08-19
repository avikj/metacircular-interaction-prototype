-- The separation table.  Every number printed is an exact integer.
--
--   ./bhavana-separation           the default family, exhaustive bound 10^6
--   ./bhavana-separation <B>       a chosen exhaustive bound
--   ./bhavana-separation <B> <D..> a chosen bound and chosen D
import BhavanaSeparation
import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, utf8)

pad :: Int -> String -> String
pad n s = replicate (max 0 (n - length s)) ' ' ++ s

padR :: Int -> String -> String
padR n s = s ++ replicate (max 0 (n - length s)) ' '

short :: Integer -> String
short n | digits n <= 12 = show n
        | otherwise      = "10^" ++ show (digits n - 1)

showRow :: Row -> String
showRow r = concat
  [ pad 6 (show (rD r))
  , pad 8 (show (rTurns r))
  , pad 8 (show (digits (rY r)))
  , pad 16 (short (rFullCost r))
  , pad 16 (short (rCertCost r))
  , "   ", padR 10 (case rTier r of Certified -> "CERTIFIED"; Bounded -> "BOUNDED")
  ]

main :: IO ()
main = do
  setLocaleEncoding utf8
  hSetEncoding stdout utf8
  args <- getArgs
  let (bound, fam) = case args of
        (b : ds@(_ : _)) -> (read b, map read ds)
        [b]              -> (read b, defaultFamily)
        []               -> (1000000, defaultFamily)
  putStrLn ""
  putStrLn "== self-test ========================================================="
  case selfTest of
    [] -> putStrLn "  all checks pass"
    fs -> mapM_ (putStrLn . ("  FAIL  " ++)) fs
  putStrLn ""
  putStrLn "== generation against enumeration ===================================="
  putStrLn ""
  putStrLn "  Bhaskara's cycle (Jayadeva ~950, Bhaskara II, Bijaganita 1150)"
  putStrLn "  against any procedure that generates candidates and tests them."
  putStrLn ""
  putStrLn "    turns    what composing costs: cakravala turns to reach x^2-Dy^2=1."
  putStrLn "    dig(y1)  the number of decimal digits in the answer's y."
  putStrLn "    enum     tests the enumerator must perform.  It must reach y1,"
  putStrLn "             because no smaller y admits a solution -- so its cost is"
  putStrLn "             y1 itself, which is 10^dig(y1)."
  putStrLn "    certified  the part of that established WITHOUT theory, by the"
  putStrLn "             exhaustive check alone.  CERTIFIED rows needed no theory;"
  putStrLn "             BOUNDED rows fall back on minimality of the fundamental"
  putStrLn "             solution (standard; not re-proved here)."
  putStrLn ""
  putStrLn (concat
    [ pad 6 "D", pad 8 "turns", pad 8 "dig(y1)", pad 16 "enum tests"
    , pad 16 "certified >=", "   ", "tier" ])
  putStrLn (replicate 78 '-')
  rs <- mapM (\d -> case row bound d of
                      Left e  -> do putStrLn ("  " ++ e); return Nothing
                      Right r -> do putStrLn (showRow r); return (Just r))
             fam
  let ok = [ r | Just r <- rs ]
  putStrLn ""
  putStrLn ("  exhaustive bound used: " ++ show bound
            ++ "   rows: " ++ show (length ok)
            ++ "  (certified " ++ show (length [ () | r <- ok, rTier r == Certified ])
            ++ ", bounded " ++ show (length [ () | r <- ok, rTier r == Bounded ]) ++ ")")
  putStrLn ""
  putStrLn "== the shape of it ==================================================="
  putStrLn ""
  putStrLn "  Read the `turns` and `dig(y1)` columns together.  The enumerator's"
  putStrLn "  cost is 10^dig(y1).  The composer's is `turns`.  Both are exact, both"
  putStrLn "  are printed, and nothing between them is fitted or estimated."
  putStrLn ""
  mapM_ headline [ r | r <- ok, rD r `elem` [61, 421, 1621] ]
  putStrLn "  THE OBVIOUS OBJECTION, answered.  A turn is not a unit-cost step: at"
  putStrLn "  D = 1621 it multiplies 76-digit integers.  Charge each turn the full"
  putStrLn "  cost of arithmetic on numbers of that size and it is still polynomial"
  putStrLn "  in dig(y1), against an enumerator whose cost is 10^dig(y1)."
  putStrLn ""
  putStrLn "  WHAT IS PROVED AND WHAT IS OWED, kept apart on purpose."
  putStrLn "    proved   the enumerator's cost is exponential in the digit count of"
  putStrLn "             the answer.  That is not fitted from these rows -- it is"
  putStrLn "             what a decimal digit is.  Its cost is y1, and y1 has"
  putStrLn "             dig(y1) digits."
  putStrLn "    exhibited  the composer's turn count, per row, exact."
  putStrLn "    OWED     a proved bound on turns as a function of dig(y1).  The"
  putStrLn "             classical route is the period of the continued fraction of"
  putStrLn "             sqrt(D).  It is NOT supplied here, and no law is inferred"
  putStrLn "             from these 44 rows: a pattern over n instances is a pattern"
  putStrLn "             over n instances until something is computed downstream of"
  putStrLn "             it.  The rows are exact pairs; read them as 44 facts."
  putStrLn ""
  putStrLn "  This is why MathMachine stalled at 239 rounds with 1696 residuals and"
  putStrLn "  zero theorems while Nalanda answered D = 61 in nine turns.  It was"
  putStrLn "  never about arithmetic.  An architecture that sifts a fixed space"
  putStrLn "  cannot reach a truth whose smallest witness is larger than the space,"
  putStrLn "  and raising the bound costs exponentially.  An architecture whose"
  putStrLn "  rule COMPOSES two results into a third is not doing the same kind of"
  putStrLn "  work more efficiently -- it is doing a different kind of work."
  putStrLn ""
  putStrLn "  Brahmagupta, Brahmasphutasiddhanta 18, 628 CE."
  case selfTest of
    [] -> return ()
    _  -> exitFailure
  where
    headline r = do
      putStrLn ("  D = " ++ show (rD r) ++ ":")
      putStrLn ("      composing:   " ++ show (rTurns r) ++ " turns")
      putStrLn ("      enumerating: " ++ show (rFullCost r) ++ " tests")
      putStrLn ("                   (" ++ show (digits (rY r)) ++ " digits)")
      putStrLn ""
