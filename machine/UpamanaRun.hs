-- Turn the key on Upamana.
--
-- `machine/Upamana.hs` is 896 lines implementing the third pramana
-- (Nyayasutra 1.1.6, prasiddha-sadharmyat sadhya-sadhanam upamanam;
-- Vatsyayana's Nyayabhasya ad loc., c. 400-450 CE, the gavaya).  Until this
-- file it was imported by nothing.  896 lines on a shelf.
--
-- Its §9 poses a question that has been open since Dignaga: upamana's own
-- §4 states similarities as TESTIMONY (someone says "the gavaya is like the
-- cow"), while §5 DERIVES them from the engine's proved theory -- which is a
-- pervasion, and having a pervasion is what makes a cognition anumana rather
-- than upamana.  Dignaga (Pramanasamuccaya, c. 480-540) held that upamana
-- reduces to anumana and is not a separate means at all; the Naiyayikas held
-- it is irreducible.  Upamana.hs §9 answers that by reporting WHAT THE
-- STATED SIMILARITIES EMIT THAT THE DERIVED ONES CANNOT.
--
-- Nobody had run it.  This file supplies the two vocabularies its report
-- needs and runs it.
--
--   pair-chart signature/semantics  from machine/PairVocab.hs, the engine's
--                                   own symbol table, unmodified
--   head-depth signature/semantics  the target of w3Similarity, built here
--                                   from machine/HeadDepthVocab.hs's
--                                   `headDepth` and `fermatBlind`
--
-- Nothing is invented for the run: the semantics below are the engine's own
-- functions, and where a symbol has no engine-side function it is absent
-- rather than stubbed, so `adjudicate` refuses instead of guessing.
import qualified Upamana as U
import qualified PairVocab as PV
import qualified HeadDepthVocab as HD

import qualified Data.Map.Strict as M
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, utf8)

-- The pair-chart side: the engine's own vocabulary, arities and semantics
-- taken straight from PairVocab with no edit.
-- The FULL pair-chart symbol table.  The first run of this file passed only
-- `PV.vocabulary` and the bhavana similarity's audit immediately said
-- "target has no symbol bcx1 of arity 4" -- correctly: bcx1/bcy live in
-- PV.bhavanaSymbols, which is where Brahmagupta's composition at D = 1 is
-- implemented.  A similarity whose target symbols are not in scope is a
-- similarity that cannot land, and the audit caught it.
pairSig :: [(String, Int)]
pairSig = PV.arities pairSyms

pairSem :: M.Map String ([Integer] -> Integer)
pairSem = PV.semantics pairSyms

pairSyms :: [PV.Sym]
pairSyms = PV.vocabulary ++ PV.pairSymbols ++ PV.bhavanaSymbols

-- The head-depth side: the target signature of w3Similarity.  `eb` is
-- HeadDepthVocab.headDepth and `fb` is its fermatBlind, read back as 0/1 so
-- that `adjudicate` can compare it against the transported comparison.
-- Nothing here is a stub: every symbol below is either an engine function or
-- ordinary arithmetic the engine already has under the same name.
hdSig :: [(String, Int)]
hdSig =
  [ ("0", 0), ("s", 1), ("+", 2), ("*", 2), ("-", 2), ("max", 2)
  , ("le", 2), ("eb", 2), ("fb", 3) ]

hdSem :: M.Map String ([Integer] -> Integer)
hdSem = M.fromList
  [ ("0",   const 0)
  , ("s",   \vs -> head vs + 1)
  , ("+",   \vs -> vs !! 0 + vs !! 1)
  , ("*",   \vs -> vs !! 0 * vs !! 1)
  , ("-",   \vs -> max 0 (vs !! 0 - vs !! 1))       -- truncated, as the engine's
  , ("max", \vs -> max (vs !! 0) (vs !! 1))
  , ("le",  \vs -> if vs !! 0 <= vs !! 1 then 1 else 0)
  , ("eb",  \vs -> let p = q (vs !! 0) in HD.headDepth p (b p (vs !! 1)))
  , ("fb",  \vs -> let p = q (vs !! 0) in
                   if HD.fermatBlind p (max 1 (vs !! 1)) (b p (vs !! 2))
                     then 1 else 0)
  ]
  where
    -- e_b(q) and blindness are defined for an odd prime q and a base b with
    -- q not dividing b.  The report evaluates over a box of small integers
    -- and cannot know which of them are legal here, so the arguments are
    -- folded onto legal values: the first odd prime at or above the value,
    -- and then the first base at or above the value that q does not divide.
    -- The second half of that was missing on the first attempt and the run
    -- hung -- `ordMod q b` with q | b never terminates.  It is guarded at its
    -- own site now as well; this fold keeps the arguments meaningful rather
    -- than merely non-fatal.
    q v = head [ p | p <- HD.oddPrimes, p >= max 3 v ]
    b p v = head [ c | c <- [max 2 v ..], c `mod` p /= 0 ]

main :: IO ()
main = do
  setLocaleEncoding utf8
  setFileSystemEncoding utf8
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8
  -- kVars and kSizeCap: the enumerated space Upamana compares itself
  -- against.  These are the engine's own round parameters.
  U.upamanaReport pairSig pairSem hdSig hdSem 3 6
