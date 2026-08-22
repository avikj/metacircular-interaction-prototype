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
--   (a) THE LENGTH CONFOUND, which was severe and mechanical, and which is
--       now half answered — by a file that refutes the paragraph that used to
--       stand here.  What stood here said: in every edge this file emits the
--       preferred side is the LONGER string, so a ranking loss cannot tell
--       "prefer the answer that names its loss" from "prefer the longer
--       completion"; the fix is control edges where the LONGER side is
--       dispreferred, an answer padded with a naṣṭa that is not in fact lost;
--       and those "cannot be derived from a transcript, because a false naṣṭa
--       is false about the world and the transcript does not contain the
--       world.  They have to be written."
--
--       The second half of that was too strong.  A claimed loss is indeed
--       false about the world, and the transcript is indeed not the world —
--       but it does not follow that no claimed loss can be WITNESSED false,
--       and Anrta_TheClaimedLossThatIsNotLostAndTheWitnessOfItsFalsity finds
--       three registries this process actually holds:  the answer's own
--       `vahita` (a line saying X did not travel, where X is a key of the
--       very object saying it); the running dispatch table (a line naming an
--       operation or a parameter this machine does not have); and the file on
--       disk (a real sentence of the sūtra under a section number the file
--       does not contain).  Every `adhika:F:j` below is generated from one of
--       those, carries the object that defeats it, and CANNOT BE BUILT
--       WITHOUT ONE — the constructor refuses, and refuses in particular any
--       line that turns out to be true.  So the corpus now contains edges
--       with the longer string on the dispreferred side, and it reports the
--       byte difference on every edge (`dairghya`) so a consumer can see the
--       correlation rather than take this sentence's word for it.
--
--       What is NOT solved, and this is the whole of the residual: all three
--       registries are inside this process or this repository.  A model
--       trained on these learns not to contradict its own answer, its own
--       table and its own citations — a consistency property.  The general
--       case, a fluent plausible claimed loss about something outside the
--       process, still needs the world.  `machine/karana sima` items 9–12
--       carry that, together with the fabrication pools' finiteness and the
--       orderings this corpus declines to assert.
--
--       Taken together the two families pin the vyaya list from both sides:
--       `purna ≻ apahrta` says do not drop a loss that occurred, `purna ≻
--       adhika` says do not name one that did not.  Either alone is
--       satisfiable by a length policy.  Both together are not.
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
import Anrta_TheClaimedLossThatIsNotLostAndTheWitnessOfItsFalsity

-- | One training record, before rendering.
data Abhyasa = Abhyasa
  { abAvrtti :: Integer
  , abPrasna :: String          -- the request line, verbatim
  , abMarga  :: String          -- "samkramana" | "dosalekha"
  , abPurna  :: J               -- the answer as given
  , abHani   :: [(String, String, J)]  -- (id, what was removed, the diminished answer)
  , abAdhika :: [(String, Anrta, J)]   -- (id, the item added and what defeats it, the enlarged answer)
  , abTyakta :: [String]               -- fabrications this record REFUSED to certify, with the reason
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

-- | Put a fabricated item into a field.  It goes LAST, not into a random
--   position, and that is a limit rather than a choice: a model could learn
--   `the last item of vyaya is the false one`.  Said here and in
--   `machine/karana sima` item 10 rather than hidden by a shuffle, because a
--   shuffle would make the corpus unreproducible to buy an appearance of
--   safety.
addLast :: J -> [J] -> [J]
addLast x xs = xs ++ [x]

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
ofTranscriptLine :: Loka -> String -> Either String Abhyasa
ofTranscriptLine loka line = do
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
      -- The control side.  Certified items only: an item whose badhaka does
      -- not fire is not shipped, and its refusal is carried in `abTyakta`
      -- rather than dropped, since a corpus builder that silently discards
      -- what it could not certify is the collapse it is built to refuse.
      certified = anrtani loka n u
      adds = [ ( "adhika:" ++ anKsetra a ++ ":" ++ show k
               , a
               , setField (anKsetra a) (JArr (addLast (JStr (anVakya a)) (getArr (anKsetra a) u))) u )
             | (k, a) <- zip [(0::Int)..] [ a | Right a <- certified ] ]
  pure (Abhyasa n p m u (vars ++ [truncated]) adds [ e | Left e <- certified ])

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
  , ("adhika", JArr [ JObj [ ("nama", JStr i)
                           , ("yojitam", JStr (anVakya an))
                           , ("ksetra", JStr (anKsetra an))
                           , ("jati", jatiOf (anrtaJ an))
                           , ("badha", JStr (anBadha an))
                           , ("rupa", r) ]
                    | (i, an, r) <- abAdhika a ])
  , ("parityakta", JArr (map JStr (abTyakta a)))
  , ("krama", JArr ([ edge "purna" i | (i, _, _) <- abHani a ] ++
                    [ edge i "nasti" | (i, _, _) <- abHani a, i /= "nasti" ] ++
                    [ edge "purna" i | (i, _, _) <- abAdhika a ]))
  , ("atulya", JArr ([ JObj [("eka", JStr i), ("dvitiya", JStr k), ("hetu", JStr sameFamily)]
                     | let ids = [ i | (i, _, _) <- abHani a, i /= "nasti" ]
                     , (n, i) <- zip [(0::Int)..] ids
                     , (m, k) <- zip [0..] ids
                     , n < m ] ++
                     [ JObj [("eka", JStr i), ("dvitiya", JStr k), ("hetu", JStr sameFamily)]
                     | let ids = [ i | (i, _, _) <- abAdhika a ]
                     , (n, i) <- zip [(0::Int)..] ids
                     , (m, k) <- zip [0..] ids
                     , n < m ] ++
                     [ JObj [("eka", JStr i), ("dvitiya", JStr k), ("hetu", JStr crossFamily)]
                     | (i, _, _) <- abHani a, i /= "nasti"
                     , (k, _, _) <- abAdhika a ] ++
                     [ JObj [("eka", JStr i), ("dvitiya", JStr "nasti"), ("hetu", JStr paddedVsTruncated)]
                     | (i, _, _) <- abAdhika a ]))
  , ("niyama", JStr ("`krama` is a list of ordered pairs, not a score: varam is preferred to hinam, and "
                     ++ "`dairghya` on each pair is len(varam) \8722 len(hinam) in bytes of rendered JSON, "
                     ++ "so the length confound is a number in the record and not a claim about it. "
                     ++ "`atulya` names the pairs this record DECLINES to order, each with its reason. "
                     ++ "Reducing this record to one number is the collapse the answer it contains was "
                     ++ "constructed to refuse."))
  , ("pramana", JArr (map JStr
      [ "notes/AHIMSA_SUTRA_VISTARA.md \167\&30 \8212 practice is shown, done, badly first; the finished thing does not teach"
      , "\167\&4 and \167\&5 \8212 \8214A\8214\8321 keeps `that` and destroys `which`, and there is no section back"
      , "\167\&7 \8212 where the standpoints differ, collapse is not forbidden but unavailable"
      , "\167\&21 \8212 the purvapaksa is a limb of one's own book: the `adhika` items are false ON PURPOSE, labelled as such, each with the object that defeats it"
      , "Umasvati, Tattvarthasutra 7.1 \8212 anrta, the second of the five; the naming, not the datatype" ]))
  ]
  where
    sameFamily = "two losses of the same kind, no scale between them \8212 \167\&7"
    crossFamily = "dropping a loss that occurred, against naming one that did not: "
                  ++ "different kinds, and asserting an order between them would be the collapse \167\&7 "
                  ++ "says is unavailable, not forbidden"
    paddedVsTruncated =
      "a padded answer against the bare road-name. \167\&5 says a truncation admits no retraction and "
      ++ "is therefore irreparable, which argues the padded answer above it; the Jaina vrata on anrta "
      ++ "is not a magnitude to be traded against another loss, which argues it is not comparable. "
      ++ "Both stand. Noted here because the direction declined is the one that would have put the "
      ++ "longer string back on the preferred side, and a reason that is convenient needs its "
      ++ "convenience stated"
    rupaOf nm
      | nm == "purna" = Just (abPurna a)
      | otherwise = case [ r | (i, _, r) <- abHani a, i == nm ] of
          (r:_) -> Just r
          [] -> case [ r | (i, _, r) <- abAdhika a, i == nm ] of
                  (r:_) -> Just r
                  [] -> Nothing
    len nm = maybe 0 (toInteger . length . render) (rupaOf nm)
    edge v h = JObj [ ("varam", JStr v), ("hinam", JStr h)
                    , ("dairghya", JInt (len v - len h)) ]
    jatiOf (JObj xs) = maybe (JStr "") id (lookup "jati" xs)
    jatiOf _ = JStr ""

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
  , "    adhika:F:j   the same answer, one item ADDED to field F: a claimed"
  , "                 loss that is not in fact lost, each carrying the object"
  , "                 that witnesses it false. Fluent, well-formed, LONGER."
  , "  and the order is shipped as edges (`krama`) with the pairs it refuses to"
  , "  order shipped alongside (`atulya`), each with its reason. The refused"
  , "  pairs now include adhika against apahrta and adhika against nasti."
  , ""
  , "WHAT A LOSS WOULD MEAN"
  , "  Over edges a > b under prompt x, with s a length-normalised sequence"
  , "  log-likelihood:   L = sum over edges of max(0, m - (s(a|x) - s(b|x)))."
  , "  Summed over edges. Never reduced to a per-record scalar first: the order"
  , "  is partial and a scalar is its truncation."
  , ""
  , "  Three kinds of edge now, not two:"
  , "    purna > apahrta:F:i   do not drop a loss that occurred  (longer preferred)"
  , "    apahrta:F:i > nasti   any named loss beats the bare road-name"
  , "    purna > adhika:F:j    do not name a loss that did not occur"
  , "                                                            (SHORTER preferred)"
  , "  Either of the first two alone is satisfiable by a length policy. The"
  , "  three together are not, and the record carries `dairghya` \8212 the byte"
  , "  difference \8212 on every edge so that is a number and not a claim."
  , ""
  , "WHAT IS NOT KNOWN"
  , "  (a) THE LENGTH CONFOUND \8212 HALF ANSWERED, AND THE HALF THAT IS NOT IS"
  , "      NAMED. What stood here said the control edges could not be derived"
  , "      from a transcript, because a false nasta is false about the WORLD"
  , "      and the transcript does not contain the world. The first clause is"
  , "      right and the inference is not: a claimed loss can be WITNESSED"
  , "      false without the world, when the object that defeats it is one"
  , "      this process holds. Three are:"
  , "        the answer's own `vahita` \8212 a line saying X did not travel,"
  , "          where X is a key of the very object saying it;"
  , "        the running dispatch table \8212 a line naming an operation or a"
  , "          parameter this machine does not have;"
  , "        the file on disk \8212 a real sentence of the sutra under a section"
  , "          number notes/AHIMSA_SUTRA_VISTARA.md does not contain."
  , "      Every `adhika` item is built from one of those, ships the object"
  , "      that defeats it in its own `badha` field, and cannot be constructed"
  , "      without one: the constructor refuses, and refuses in particular any"
  , "      fabricated line that turns out to be TRUE. The refusals are counted"
  , "      and carried in each record's `parityakta`."
  , "      THE RESIDUAL, exactly: all three registries are inside this process"
  , "      or this repository. A model trained on these learns not to"
  , "      contradict its own answer, table and citations \8212 a consistency"
  , "      property, and a real one. It does not learn not to claim a loss"
  , "      that did not occur, in general, because that needs the world. See"
  , "      `machine/karana sima` items 9 to 12."
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
  loka <- lokah
  txt <- readFile fp
  let ls = [ l | l <- lines txt, not (all (`elem` " \t\r") l) ]
  rs <- mapM (one loka) ls
  let ok = length [ () | Right _ <- rs ]
      recs = [ a | Right a <- rs ]
      hanEdges = sum [ 2 * length (abHani a) - 1 | a <- recs ]
      addEdges = sum [ length (abAdhika a) | a <- recs ]
      atulyani = sum [ let n = length (abHani a) - 1
                           m = length (abAdhika a)
                       in n * (n - 1) `div` 2 + m * (m - 1) `div` 2 + n * m + m
                     | a <- recs ]
      -- The confound, as a number over the corpus that was actually emitted.
      -- Exact, not fitted: these are the rendered byte lengths of the very
      -- strings on either side of every edge shipped.
      deltas = concat [ edgeDeltas a | a <- recs ]
      -- The confound lives in the ONE-ITEM edges: purna against an answer
      -- differing from it by exactly one array element.  The edges against
      -- `nasti` differ by the whole answer and were never the confound; they
      -- are counted separately rather than averaged in, which would hide the
      -- number that matters under a number that never moved.
      eka = [ d | (True, d) <- deltas ]
      itara = [ d | (False, d) <- deltas ]
      up = length [ () | d <- eka, d > 0 ]
      dn = length [ () | d <- eka, d < 0 ]
      eq = length [ () | d <- eka, d == 0 ]
      refused = sum [ length (abTyakta a) | a <- recs ]
  hPutStrLn stderr ("abhyasa: " ++ show (length ls) ++ " transcript line(s) from " ++ fp
                    ++ "; " ++ show ok ++ " record(s); "
                    ++ show (length ls - ok) ++ " unreadable, each written in place")
  hPutStrLn stderr ("edges emitted: " ++ show (hanEdges + addEdges)
                    ++ " (" ++ show hanEdges ++ " hani, " ++ show addEdges ++ " adhika)"
                    ++ "   incomparable pairs declared: " ++ show atulyani)
  hPutStrLn stderr ("dairghya, one-item edges (purna against an answer differing by exactly one "
                    ++ "array element \8212 the family the confound lives in): " ++ show (length eka)
                    ++ " edge(s), of which " ++ show up ++ " prefer the LONGER side, "
                    ++ show dn ++ " prefer the SHORTER, " ++ show eq ++ " equal.")
  hPutStrLn stderr ("  a ranking loss over this corpus that is really a length policy scores "
                    ++ show (max up dn) ++ "/" ++ show (length eka)
                    ++ " on that family; before the control edges existed it scored "
                    ++ show up ++ "/" ++ show up ++ ".")
  hPutStrLn stderr ("  the " ++ show (length itara) ++ " edge(s) against `nasti` differ by the "
                    ++ "whole answer, not by one item, and were never the confound; counted apart "
                    ++ "rather than averaged in.")
  hPutStrLn stderr ("anrta refused certification: " ++ show refused
                    ++ " (a fabrication whose badhaka did not fire is not shipped; "
                    ++ "the reason stands in each record's `parityakta`)")
  pure (ok, length ls - ok)
  where
    edgeDeltas a =
      let rupaOf nm | nm == "purna" = Just (abPurna a)
                    | otherwise = case [ r | (i, _, r) <- abHani a, i == nm ] of
                        (r:_) -> Just r
                        [] -> case [ r | (i, _, r) <- abAdhika a, i == nm ] of
                                (r:_) -> Just r
                                [] -> Nothing
          len nm = maybe 0 (toInteger . length . render) (rupaOf nm)
      in [ len "purna" - len i | (i, _, _) <- abHani a ]
      ++ [ len i - len "nasti" | (i, _, _) <- abHani a, i /= "nasti" ]
      ++ [ len "purna" - len i | (i, _, _) <- abAdhika a ]
    one loka l = case ofTranscriptLine loka l of
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
