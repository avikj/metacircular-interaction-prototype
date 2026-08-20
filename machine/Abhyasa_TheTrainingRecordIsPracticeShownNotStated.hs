-- Abhyasa_TheTrainingRecordIsPracticeShownNotStated
--
-- अभ्यासो न पाठ्यते । अभ्यासो दृश्यते, कृतश्च, पुनःपुनः, दुष्टः प्रथमम् ।
-- यो समाप्तं दर्शयति स न शिक्षयति ।   — AHIMSA_SUTRA_VISTARA §30
--
-- Practice is not taught.  Practice is seen, and done, repeatedly, badly
-- first.  Whoever displays the finished thing is not teaching.  That is the
-- whole design brief for this file, and it is why a corpus of finished
-- answers is not the training object: the finished answer is exactly what
-- §30 says does not transmit.
--
-- WHAT A TRAINING EXAMPLE IS HERE, AND WHY IT IS NOT (prompt, response).
--
-- A (prompt, response) pair carries one string as correct and says nothing
-- about what makes it correct.  Trained against, it teaches the STRING.  The
-- thing this machine produces is not a string: it is a verdict together with
-- its witnesses and its remainder, and the whole content of the verdict is
-- that those did not get dropped.  A pair throws away precisely the property
-- being trained.  §4: ∥A∥₁ keeps `that` and destroys `which`, and a
-- (prompt, response) corpus is ∥·∥₁ of a corpus of answers-with-their-vyaya.
--
-- So a record here is a CONTRAST SET with an ORDER on it, and the order is
-- partial by construction:
--
--     purna          the answer as the machine gave it
--     apahrta:F:i    the same answer with exactly ONE item removed from the
--                    field F (vyaya / nasta / sesa / pramana), item i.  This
--                    is not a corrupted answer.  It is the answer the machine
--                    would have produced had it not noticed that one thing —
--                    fluent, well-formed, shorter, and wrong in the single
--                    way that matters
--     nasti          ∥uttara∥₁ — the road's name and nothing else.  On this
--                    wire that IS the bare boolean: two values, no section
--                    (§5, नास्ति-प्रत्यानयनम्)
--
-- and the order shipped with the record is a list of EDGES, `purna ≻ apahrta:F:i`
-- and `apahrta:F:i ≻ nasti`, plus an explicit list of the pairs this record
-- DECLINES to order — apahrta:F:i against apahrta:G:j.  Those are two
-- different losses and there is no scale on which one is worse.  §7:
-- नयभेदे सङ्क्षेपो न विद्यते — where the standpoints differ there is no
-- collapse available; not forbidden, not impolite, NOT AVAILABLE.  A scalar
-- reward over this record would be ∥·∥₁ of the order, i.e. would perform on
-- the training signal the same collapse the machine refuses on the wire.
--
-- WHAT A LOSS OVER THIS WOULD MEAN — and where it stops being known.
--
-- Known: the record supports a margin ranking loss over edges.  For an edge
-- a ≻ b under prompt x, with s(·) a length-normalised sequence log-likelihood,
--     L = Σ_edges max(0, m − (s(a|x) − s(b|x)))
-- summed over edges and never reduced to a per-record scalar first.  Nothing
-- exotic; DPO-shaped, with the pairs generated rather than annotated.
--
-- NOT KNOWN, and this is not modesty, it is the actual state:
--
--   (a) THE LENGTH CONFOUND, which is severe and mechanical.  In every edge
--       this file emits, the preferred side is the LONGER string, because it
--       is the same JSON with one array element more.  A ranking loss cannot
--       tell "prefer the answer that names its loss" from "prefer the longer
--       completion".  Length normalisation does not fix it: the two sides
--       differ by one item, so normalising per token nearly cancels the very
--       difference being trained on.  What would fix it is control edges in
--       which the LONGER side is dispreferred — an answer padded with a
--       naṣṭa item that is not in fact lost, or with a vyaya line that is
--       filler.  This file cannot generate those.  They cannot be derived
--       from a transcript, because a false naṣṭa is false about the world and
--       the transcript does not contain the world.  They have to be written.
--       That is the largest single open item in this lane and it is handed
--       forward, unsolved, rather than papered over with a weighting.
--
--   (b) SHAPE VERSUS DISPOSITION.  A model trained on this will learn to
--       emit a `vyaya` array.  Whether it learns to NOTICE what did not
--       travel is a different claim and this corpus cannot distinguish them,
--       because every naṣṭa list in it was authored per-operation in one
--       twelve-entry dispatch table.  A test that would distinguish them:
--       hold out a domain the corpus never covers, ask for an answer, and
--       check whether the vyaya lines name losses SPECIFIC to that domain or
--       recite the corpus's lines with new nouns.  That test is not built.
--       Until it is, the honest statement is that this trains a format.
--
--   (c) SELF-LABELLING.  The corpus's judgements of what is lost are the
--       machine's own, and the machine's ceiling is the quality of those
--       twelve hand-written lists (see `machine/karana sima`, item 5).
--       Training on it makes a model agree with this table, not with the
--       world.  There is no operation anywhere in the assembly that can tell
--       you a vyaya list is incomplete.
--
--   I do not know that a loss over these records teaches the non-collapse.
--   I do know what the record has to be for the question to be askable at
--   all, and I know the specific confound that makes me doubt the answer.
--   That is the state; a number here would be a guess in a lab coat.
--
-- RUN IT:
--     machine/karana abhyasa [transcript.jsonl]   records, one JSON per line
--     machine/karana siksa                        the above, as a document
--
-- The input is $SABHA_LEKHA (default machine/sabha.jsonl): the append-only
-- transcript the kernel writes, one {avrtti, prasna, uttara} per line.

module Abhyasa_TheTrainingRecordIsPracticeShownNotStated
  ( Abhyasa(..)
  , ofTranscriptLine
  , abhyasaJ
  , siksaLines
  , runAbhyasa
  ) where

import Data.List (intercalate)
import System.IO
import Sabda_TheWireHasNoBoolean

-- | One training record, before rendering.
data Abhyasa = Abhyasa
  { abAvrtti :: Integer
  , abPrasna :: String          -- the request line, verbatim
  , abMarga  :: String          -- "samkramana" | "dosalekha"
  , abPurna  :: J               -- the answer as given
  , abHani   :: [(String, String, J)]  -- (id, what was removed, the diminished answer)
  }

-- | The fields whose items are individually droppable, per road.  Dropping
--   one is not corruption: each of these lists exists because somebody
--   noticed something, and the diminished answer is the answer of someone who
--   did not notice it.
ksetrani :: String -> [String]
ksetrani "samkramana" = ["vyaya", "pramana"]
ksetrani "dosalekha"  = ["nasta", "sesa", "pramana"]
ksetrani _            = []

dropAt :: Int -> [a] -> [a]
dropAt i xs = [ x | (k, x) <- zip [0..] xs, k /= (i :: Int) ]

setField :: String -> J -> J -> J
setField k v (JObj kvs) = JObj [ if k' == k then (k', v) else (k', v') | (k', v') <- kvs ]
setField _ _ j = j

getArr :: String -> J -> [J]
getArr k (JObj kvs) = case lookup k kvs of { Just (JArr xs) -> xs; _ -> [] }
getArr _ _ = []

asText :: J -> String
asText (JStr s) = s
asText j = render j

-- | Build a record from one transcript line.  Left when the line is not a
--   transcript line; the caller writes that rather than skipping it.
ofTranscriptLine :: String -> Either String Abhyasa
ofTranscriptLine line = do
  j <- parseLine line
  n <- jInt "avrtti" j
  p <- jStr "prasna" j
  u <- look "uttara" j
  m <- jStr "uttara" u
  let vars = [ ( "apahrta:" ++ f ++ ":" ++ show i
               , "from `" ++ f ++ "`: " ++ asText x
               , setField f (JArr (dropAt i (getArr f u))) u )
             | f <- ksetrani m
             , (i, x) <- zip [0..] (getArr f u) ]
      truncated = ( "nasti"
                  , "everything except the road's name \8212 \8214uttara\8214\8321, "
                    ++ "which on this wire is the bare boolean"
                  , JObj [("uttara", JStr m)] )
  pure (Abhyasa n p m u (vars ++ [truncated]))

-- | The record as it goes to disk.  The order is shipped as edges and the
--   incomparabilities are shipped too, named, so that a consumer who wants a
--   scalar has to perform the collapse itself and cannot claim this file did.
abhyasaJ :: Abhyasa -> J
abhyasaJ a = JObj
  [ ("avrtti", JInt (abAvrtti a))
  , ("prasna", JStr (abPrasna a))
  , ("marga", JStr (abMarga a))
  , ("purna", abPurna a)
  , ("hani", JArr [ JObj [ ("nama", JStr i)
                         , ("apahrtam", JStr w)
                         , ("rupa", r) ]
                  | (i, w, r) <- abHani a ])
  , ("krama", JArr ([ JObj [("varam", JStr "purna"), ("hinam", JStr i)]
                    | (i, _, _) <- abHani a ] ++
                    [ JObj [("varam", JStr i), ("hinam", JStr "nasti")]
                    | (i, _, _) <- abHani a, i /= "nasti" ]))
  , ("atulya", JArr [ JObj [("eka", JStr i), ("dvitiya", JStr k)]
                    | let ids = [ i | (i, _, _) <- abHani a, i /= "nasti" ]
                    , (n, i) <- zip [(0::Int)..] ids
                    , (m, k) <- zip [0..] ids
                    , n < m ])
  , ("niyama", JStr ("`krama` is a list of ordered pairs, not a score: varam is preferred to hinam. "
                     ++ "`atulya` names the pairs this record DECLINES to order \8212 two different "
                     ++ "losses, no scale between them. Reducing this record to one number is the "
                     ++ "collapse the answer it contains was constructed to refuse."))
  , ("pramana", JArr (map JStr
      [ "notes/AHIMSA_SUTRA_VISTARA.md \167\&30 \8212 practice is shown, done, badly first; the finished thing does not teach"
      , "\167\&4 and \167\&5 \8212 \8214A\8214\8321 keeps `that` and destroys `which`, and there is no section back"
      , "\167\&7 \8212 where the standpoints differ, collapse is not forbidden but unavailable" ]))
  ]

-- | The document version of the header, for a reader who has the binary and
--   not the source.
siksaLines :: [String]
siksaLines =
  [ "SIKSA \8212 what a training example is here, and what a loss over it would mean."
  , ""
  , "THE RECORD"
  , "  A (prompt, response) pair carries one string as correct and says nothing"
  , "  about what makes it correct. Trained against, it teaches the string. What"
  , "  this machine produces is a verdict WITH its witnesses and its remainder,"
  , "  and the entire content of the verdict is that those were not dropped. The"
  , "  pair throws exactly that away. A (prompt, response) corpus is the"
  , "  propositional truncation of a corpus of answers-with-their-vyaya."
  , ""
  , "  So each record is a contrast set with a PARTIAL order:"
  , "    purna        the answer as given"
  , "    apahrta:F:i  the same answer, one item removed from field F. Not a"
  , "                 corruption: it is what the machine would have said had it"
  , "                 not noticed that one thing. Fluent, well-formed, shorter."
  , "    nasti        the road's name alone \8212 on this wire, the bare boolean."
  , "  and the order is shipped as edges (`krama`) with the pairs it refuses to"
  , "  order shipped alongside (`atulya`)."
  , ""
  , "WHAT A LOSS WOULD MEAN"
  , "  Over edges a > b under prompt x, with s a length-normalised sequence"
  , "  log-likelihood:   L = sum over edges of max(0, m - (s(a|x) - s(b|x)))."
  , "  Summed over edges. Never reduced to a per-record scalar first: the order"
  , "  is partial and a scalar is its truncation."
  , ""
  , "WHAT IS NOT KNOWN"
  , "  (a) THE LENGTH CONFOUND. In every edge emitted here the preferred side is"
  , "      the longer string \8212 the same JSON with one array element more. A"
  , "      ranking loss cannot separate `prefer the answer that names its loss`"
  , "      from `prefer the longer completion`, and length normalisation nearly"
  , "      cancels the very difference being trained on. The fix is control"
  , "      edges where the LONGER side is dispreferred: an answer padded with a"
  , "      nasta item that is not in fact lost. Those cannot be derived from a"
  , "      transcript \8212 a false nasta is false about the WORLD, and the"
  , "      transcript does not contain the world. They must be written. This is"
  , "      the largest open item in this lane, handed forward unsolved."
  , "  (b) SHAPE VERSUS DISPOSITION. This will teach a model to emit a vyaya"
  , "      array. Whether it teaches it to notice what did not travel is a"
  , "      different claim, and this corpus cannot distinguish them: every nasta"
  , "      list in it was authored per-operation in one twelve-entry table. The"
  , "      test that would distinguish them \8212 hold out a domain the corpus never"
  , "      covers and check whether the vyaya lines are specific to it or are the"
  , "      corpus's lines with new nouns \8212 is not built."
  , "  (c) SELF-LABELLING. The judgements of what is lost are the machine's own."
  , "      Training on this makes a model agree with that table, not with the"
  , "      world, and no operation in the assembly can tell you a vyaya list is"
  , "      incomplete."
  , ""
  , "  I do not know that a loss over these records teaches the non-collapse. I"
  , "  know what the record has to be for the question to be askable, and I know"
  , "  the confound that makes me doubt the answer. A number here would be a"
  , "  guess in a lab coat."
  ]

-- | Read a transcript, write records.  A line that is not a transcript line
--   is not skipped: it is written as a defect, in place, because a corpus
--   builder that silently drops what it cannot read is the collapse.
runAbhyasa :: FilePath -> IO (Int, Int)
runAbhyasa fp = do
  txt <- readFile fp
  let ls = [ l | l <- lines txt, not (all (`elem` " \t\r") l) ]
  rs <- mapM one ls
  let ok = length [ () | Right _ <- rs ]
  hPutStrLn stderr ("abhyasa: " ++ show (length ls) ++ " transcript line(s) from " ++ fp
                    ++ "; " ++ show ok ++ " record(s); "
                    ++ show (length ls - ok) ++ " unreadable, each written in place")
  hPutStrLn stderr ("edges emitted: "
                    ++ show (sum [ 2 * length (abHani a) - 1 | Right a <- rs ])
                    ++ "   incomparable pairs declared: "
                    ++ show (sum [ let n = length (abHani a) - 1 in n * (n - 1) `div` 2
                                 | Right a <- rs ]))
  pure (ok, length ls - ok)
  where
    one l = case ofTranscriptLine l of
      Right a -> putStrLn (render (abhyasaJ a)) >> pure (Right a)
      Left e -> do
        putStrLn (render (JObj
          [ ("uttara", JStr "dosalekha")
          , ("kriya", JStr "abhyasa")
          , ("hetu", JStr ("a line of the transcript is not a transcript line: " ++ e))
          , ("nasta", JArr [ JStr ("the line, unread: " ++ take 300 l)
                           , JStr "and whatever turn it recorded, which is now absent from the corpus without a mark unless this entry stands where it stood" ])
          , ("sesa", JArr [ JStr "a transcript line is {\"avrtti\":n,\"prasna\":\"...\",\"uttara\":{...}}; this one is not, and the reason above says how" ])
          , ("pramana", JArr [ JStr "AHIMSA_SUTRA_VISTARA \167\&6 \8212 an unwritten defect is himsa" ]) ]))
        pure (Left e)
