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

-- Anrta_TheClaimedLossThatIsNotLostAndTheWitnessOfItsFalsity
--
-- WHAT THIS IS FOR.  Abhyasa_TheTrainingRecordIsPracticeShownNotStated ships
-- a contrast set per turn: `purna` (the answer as given), `apahrta:F:i` (the
-- same answer with exactly one item gone from vyaya/nasta/sesa/pramana), and
-- `nasti` (the road's name alone).  Every edge in it has the LONGER string on
-- the preferred side, because every edge is the same JSON with one array
-- element more.  A ranking loss over that corpus cannot separate *prefer the
-- answer that names its loss* from *prefer the longer completion*, and length
-- normalisation nearly cancels the difference being trained on.  That file
-- says so, at length, and hands the problem forward:
--
--     "What would fix it is control edges in which the LONGER side is
--      dispreferred -- an answer padded with a nasta item that is not in fact
--      lost.  This file cannot generate those.  They cannot be derived from a
--      transcript, because a false nasta is false about the world and the
--      transcript does not contain the world.  They have to be written."
--
-- THE CLAIM THAT SENTENCE MAKES IS TOO STRONG, AND THIS FILE IS THE
-- REFUTATION OF ITS OWN LANE.  It is true that a claimed loss is false about
-- the world and that the transcript is not the world.  It does not follow
-- that no claimed loss can be witnessed false, because there is a proper
-- subclass whose falsity is witnessed by objects this process can hold:
--
--   1  THE ANSWER ITSELF.  A vyaya line saying `X did not travel` where X is
--      a key of that same answer's `vahita` -- the answer is carrying the
--      thing at the moment it says it did not.  Witnessed by lookup.
--
--   2  THE RUNNING DISPATCH TABLE.  A line naming an operation or a parameter
--      this machine does not have.  Witnessed by walking `kriyah`, the same
--      list the server dispatches on, not a copy of it.
--
--   3  THE FILE ON DISK.  A citation to a section of the sutra that the file
--      does not contain -- a real quotation under a false locator, which is
--      the exact shape of a confabulated reference.  Witnessed by counting
--      the headings in notes/AHIMSA_SUTRA_VISTARA.md at run time.
--
-- So the control edges ARE derivable, for that subclass, and the subclass is
-- large enough to invert the length correlation.  What is NOT derivable is
-- the rest: a fluent, plausible claimed loss about something outside this
-- process -- `the provenance of the cakravala in Jayadeva's lost text did not
-- travel` -- whose falsity needs the world.  That remains open and is written
-- into `anrtaSimaLines` rather than papered over.  The line moved; it did not
-- disappear.
--
-- WHY WRITING FALSE LINES IS NOT A VIOLATION OF THE THING THIS MACHINE IS
-- FOR.  Every item this module builds is labelled anrta at the instant it is
-- built, carries the badhaka that defeats it, and cannot be constructed
-- without one -- the smart constructor `anrta` refuses, the way `samkramana`
-- refuses a transport with no witness.  A falsehood stated as a falsehood,
-- inside the work, with its refutation attached, is purvapaksa: the opponent
-- put at full strength in one's own book, counted among the tantrayuktis and
-- required by them (AHIMSA_SUTRA_VISTARA section 21).  An unlabelled one
-- would be anrta in the vow's sense.  These are labelled.
--
-- THE TWO SCHOOLS, NAMED, BECAUSE THEY ARE NOT ONE TOOLKIT.
--   anrta is Jaina, and it is a fault of SPEECH under a vow: Umasvati,
--   Tattvarthasutra 7.1, hims'a-ANRTA-steya-abrahma-parigraha -- abstention
--   from injury, falsehood, theft, unchastity and possession is a vrata
--   (the text is in this repository, notes/TATTVARTHASUTRA_ADHYAYA_6_TO_10.md,
--   marked [recalled] there; the definitional sutra asad-abhidhanam anrtam is
--   recalled and its NUMBER is not verified against a copy here, so it is
--   named without one -- see item 4 of anrtaSimaLines, which is this file
--   applying its own test to its own citation).
--   badhaka/badhita is Nyaya, and it is a fault of an INFERENCE: Gautama,
--   Nyayasutra, among the hetvabhasas -- a reason overridden by a stronger
--   means of knowing.  machine/Hetvabhasa_TheRefusalNamesItsDefectOrItIsNotARefusal.hs
--   already carries that vocabulary with its source.
--   Gluing a Naiyayika defeater onto a Jaina speech-fault is MY composition
--   and neither school authorises it.  A Naiyayika would say badhita is
--   predicated of a hetu in an anumana and a written line in a JSON array is
--   not one; a Jaina would say the vow is about the speaker's intention and
--   pramada, which no lookup can inspect, so `witnessed false` is not the
--   same predicate as `anrta`.  Both objections are correct.  What is
--   defended is narrower than either word: an item is emitted here only when
--   a named object in this process contradicts it, and that is what the
--   record says, in the `badha` field, in each item, one by one.
--
-- WHAT IT IS NOT.  It is not a corruption of the machine's answers -- the
-- kernel never sees these, they exist only inside training records, on the
-- DISPREFERRED side of an edge.  It is not an adversarial test of the kernel.
-- It is not a claim that anything here was said by any source.

module Anrta_TheClaimedLossThatIsNotLostAndTheWitnessOfItsFalsity
  ( Badhaka(..)
  , Anrta(..)
  , Loka(..)
  , lokah
  , anrta
  , anrtani
  , anrtaJ
  , anrtaSimaLines
  , pariksaAnrta
  ) where

import Control.Exception (try, SomeException)
import Data.List (isInfixOf, isPrefixOf, intercalate)

import Sabda_TheWireHasNoBoolean
import Sabha_TheSessionKernelAnLLMTalksTo (Kriya(..), kriyah)

-- ------------------------------------------------- what defeats a claim
--
-- Three constructors, and there is no fourth, for the same reason Uttara has
-- two: a fourth would be a claim of falsity with nothing holding it up, which
-- is the thing being refused.  Each names the OBJECT that does the defeating,
-- not a verdict about it.

data Badhaka
  = VahitaSthitam String        -- ^ the key is present in this answer's `vahita`
  | KriyaAsati String String    -- ^ (operation, parameter); parameter "" means the operation itself is absent
  | ParvanAsati FilePath Int    -- ^ the file has no such section
  deriving (Eq, Show)

-- | One deliberately false item, with the badhaka that defeats it and the
--   sentence in which the defeat was actually carried out.  `anBadha` is
--   written by `badhitam` from the objects, at the moment the item is built;
--   it is not a description of a check that happened elsewhere.
data Anrta = Anrta
  { anKsetra :: String    -- ^ the field it is inserted into: vyaya | nasta | sesa | pramana
  , anVakya  :: String    -- ^ the false line, verbatim as it would appear in the answer
  , anBadhaka :: Badhaka
  , anBadha  :: String    -- ^ how the badhaka defeats it, with the objects quoted
  } deriving (Eq, Show)

-- | The objects this process can hold and check against.  Everything outside
--   this record is the world, and the world is what makes the residual
--   underivable.
data Loka = Loka
  { lKriyah  :: [(String, [String])]   -- ^ operation -> its parameter names, WALKED from the running table
  , lParvani :: [(FilePath, Int)]      -- ^ file -> the number of sections actually in it
  } deriving (Eq, Show)

sutraPath :: FilePath
sutraPath = "notes/AHIMSA_SUTRA_VISTARA.md"

-- | Build the world-fragment.  The dispatch table is walked, never copied.
--   The sutra is counted on disk; if it is not found, `lParvani` is empty and
--   family 3 emits nothing rather than emitting an unwitnessed item.
lokah :: IO Loka
lokah = do
  found <- upto (5 :: Int) ""
  pure (Loka [ (kName k, map fst (kParams k)) | k <- kriyah ] found)
  where
    upto 0 _ = pure []
    upto n pre = do
      r <- try (readFile (pre ++ sutraPath)) :: IO (Either SomeException String)
      case r of
        Right txt | c txt > 0 -> pure [(sutraPath, c txt)]
        _ -> upto (n - 1) (pre ++ "../")
    c txt = length [ () | l <- lines txt, "## " `isPrefixOf` l ]

-- ------------------------------------------------------ the constructor
--
-- The regress stops here.  An item exists only if the badhaka fires, and the
-- badhaka fires only if the object it names is really in hand.  A line that
-- happens to be TRUE is refused, by name -- which is the check that matters,
-- since the failure mode of a fabrication generator is fabricating something
-- accurate and shipping it as the dispreferred side.

anrta :: Loka -> J -> String -> String -> Badhaka -> Either String Anrta
anrta loka u ksetra vakya b = case badhitam loka u vakya b of
  Just why -> Right (Anrta ksetra vakya b why)
  Nothing  -> Left ("refused to certify as anrta: " ++ show b
                    ++ " does not defeat the line " ++ show vakya
                    ++ " -- either the object it names is not in hand, or the "
                    ++ "line does not name it, or the line is TRUE")

-- | Does the badhaka actually defeat this line?  Two conditions, both
--   required: the object must contradict the line, and the LINE MUST NAME THE
--   OBJECT.  Without the second a witness could be about something else and
--   the item would be certified by an accident of the table.
badhitam :: Loka -> J -> String -> Badhaka -> Maybe String
badhitam loka u vakya b = case b of
  VahitaSthitam k
    | not (tick k `isInfixOf` vakya) -> Nothing
    | otherwise -> case lookup "vahita" (kvs u) of
        Just (JObj carried) -> case lookup k carried of
          Just v -> Just (tick k ++ " stands as a key of this answer's own `vahita`, "
                          ++ "carrying " ++ show (length (render v)) ++ " bytes of rendered JSON; "
                          ++ "the line says it did not travel, and it travelled")
          Nothing -> Nothing
        _ -> Nothing
  KriyaAsati op p
    | not (tick (if null p then op else p) `isInfixOf` vakya) -> Nothing
    | null p -> if op `elem` map fst (lKriyah loka) then Nothing
                else Just ("the running dispatch table has no operation " ++ tick op
                           ++ "; it has " ++ show (length (lKriyah loka)) ++ ": "
                           ++ intercalate ", " (map fst (lKriyah loka)))
    | otherwise -> case lookup op (lKriyah loka) of
        Nothing -> Nothing
        Just ps
          | p `elem` ps -> Nothing
          | otherwise -> Just ("the running dispatch table gives " ++ tick op
                               ++ " the parameters "
                               ++ (if null ps then "(none)" else intercalate ", " ps)
                               ++ "; " ++ tick p ++ " is not among them")
  ParvanAsati f n
    | not (("\167" ++ show n) `isInfixOf` vakya) -> Nothing
    | otherwise -> case lookup f (lParvani loka) of
        Nothing -> Nothing
        Just have
          | n > have || n < 1 ->
              Just (f ++ " has " ++ show have ++ " sections, counted by `## ` headings "
                    ++ "in the file as it stands on disk in this process; \167" ++ show n
                    ++ " is not one of them, and the sentence quoted under it is real "
                    ++ "-- the locator is what is false")
          | otherwise -> Nothing
  where
    tick s = "`" ++ s ++ "`"

kvs :: J -> [(String, J)]
kvs (JObj xs) = xs
kvs _ = []

-- ------------------------------------------------------- the generation
--
-- Everything below is derived from the answer, the table and the file.  The
-- POOLS are authored -- plausible-looking names that do not exist -- and that
-- authoring is the only hand-written half; the falsity of every line built
-- from them is checked, not asserted.

kalpitaAnga :: [String]
kalpitaAnga = ["krama", "avadhi", "matra", "adhikara", "mula", "phala", "vipaksa"]

kalpitaKriya :: [String]
kalpitaKriya = ["naya.bheda", "sesa.tyaga", "sabha.smrti", "dosa.samasa", "naya.badha"]

-- | Real sentences of the sutra, each from a section that exists.  Only the
--   locator attached to them by `anrtani` is false.
vacanani :: [(String, String)]
vacanani =
  [ ("\2351\2340\2381 \2358\2367\2352\2360\2367 \2344 \2357\2360\2340\2367 \2340\2340\2381 \2344 \2357\2361\2340\2367", "what does not sit in the head does not travel")
  , ("\2351\2340\2381 \2344 \2357\2367\2349\2332\2340\2375 \2340\2340\2381 \2352\2325\2381\2359\2381\2351\2340\2375", "what does not divide is kept")
  , ("\2360\2340\2381\2351\2306 \2360\2352\2354\2350\2381, \2344 \2360\2369\2327\2350\2350\2381", "the true is simple, not easy")
  , ("\2313\2346\2351\2379\2327\2379 \2354\2325\2381\2359\2339\2350\2381", "attention is the mark of the living")
  ]

pick :: Integer -> [a] -> a
pick s xs = xs !! fromInteger (s `mod` toInteger (length xs))

-- | Take the first name from a pool that the running table does NOT have, so
--   the pool can be edited without silently producing true lines.
navam :: [String] -> (String -> Bool) -> Integer -> Maybe String
navam pool exists s =
  case [ x | x <- rotate (fromInteger (s `mod` toInteger (length pool))) pool, not (exists x) ] of
    (x:_) -> Just x
    []    -> Nothing
  where rotate n xs = drop n xs ++ take n xs

-- | Every anrta item derivable from one answer, each already certified, or a
--   written reason it could not be.  `salt` is the turn number: it spreads the
--   fabricated locators and names across the corpus so a model cannot learn
--   one constant string instead of the property.
anrtani :: Loka -> Integer -> J -> [Either String Anrta]
anrtani loka salt u = case lookup "uttara" (kvs u) of
  Just (JStr "samkramana") -> vahitaOnes ++ angaOne "vyaya" ++ kriyaOne "vyaya" ++ parvanOne
  Just (JStr "dosalekha")  -> angaOne "nasta" ++ kriyaOne "sesa" ++ parvanOne
  _ -> []
  where
    op = case lookup "kriya" (kvs u) of { Just (JStr k) -> k; _ -> "" }
    mk f v b = [anrta loka u f v b]

    -- 1  the answer contradicts the line
    vahitaOnes = case lookup "vahita" (kvs u) of
      Just (JObj carried) ->
        concat [ mk "vyaya"
                   ("`" ++ k ++ "` \8212 named in this answer and not carried by it, so a "
                    ++ "reader who needs the thing itself has to go back to the source")
                   (VahitaSthitam k)
               | (k, _) <- carried ]
      _ -> []

    -- 2a  a parameter the operation does not have
    angaOne f = case navam kalpitaAnga (\p -> maybe True (p `elem`) (lookup op (lKriyah loka))) salt of
      Nothing -> []
      Just p -> mk f
        (if f == "nasta"
           then "the `" ++ p ++ "` that `" ++ op ++ "` was given, destroyed here rather than reported"
           else "`" ++ op ++ "`'s `" ++ p ++ "` parameter, which does not survive into the answer")
        (KriyaAsati op p)

    -- 2b  an operation this machine does not have
    kriyaOne f = case navam kalpitaKriya (\o -> o `elem` map fst (lKriyah loka)) (salt + 1) of
      Nothing -> []
      Just o -> mk f
        (if f == "sesa"
           then "hand this to `" ++ o ++ "`, which is where a remainder of this kind belongs"
           else "whatever `" ++ o ++ "` would have contributed here, which this road forecloses")
        (KriyaAsati o "")

    -- 3  a real sentence under a locator the file does not have
    parvanOne = case lParvani loka of
      ((f, have):_) ->
        let n = have + 1 + fromInteger (salt `mod` 40)
            (sa, en) = pick salt vacanani
        in mk "pramana" (f ++ " \167" ++ show n ++ " \8212 " ++ sa ++ " \8212 " ++ en)
                        (ParvanAsati f n)
      [] -> []

-- ---------------------------------------------------------------- the wire

anrtaJ :: Anrta -> J
anrtaJ a = JObj
  [ ("ksetra", JStr (anKsetra a))
  , ("vakya", JStr (anVakya a))
  , ("jati", JStr (jati (anBadhaka a)))
  , ("badha", JStr (anBadha a))
  ]
  where
    jati VahitaSthitam{} = "vahita-sthitam \8212 the answer itself carries what the line says did not travel"
    jati (KriyaAsati _ p)
      | null p = "kriya-asati \8212 the line names an operation the running table does not have"
      | otherwise = "anga-asati \8212 the line names a parameter the running table does not give that operation"
    jati ParvanAsati{} = "parvan-asati \8212 a real sentence of the sutra under a section number the file does not have"

-- ------------------------------------------------------- the honest negative

anrtaSimaLines :: [String]
anrtaSimaLines =
  [ ""
  , "9  THE CONTROL EDGES ARE WITNESSED FALSE ABOUT THIS PROCESS, NOT ABOUT"
  , "   THE WORLD."
  , "   `karana abhyasa` now emits edges whose DISPREFERRED side is the longer"
  , "   string: the answer plus one claimed loss that is not lost. Every such"
  , "   item carries the object that defeats it -- a key of the answer's own"
  , "   `vahita`, the running dispatch table, or the section count of"
  , "   notes/AHIMSA_SUTRA_VISTARA.md on disk. That is three registries and"
  , "   they are all INSIDE this process or this repository. A model trained"
  , "   on them learns `do not contradict your own answer, your own table and"
  , "   your own citations` -- a consistency property. It does not learn `do"
  , "   not claim a loss that did not occur`, because the general case needs"
  , "   the world and the corpus does not contain the world. The length"
  , "   confound named in `karana siksa` (a) is broken; the world-grounding is"
  , "   not achieved, and this is where the line now runs."
  , ""
  , "10 THE FABRICATION POOLS ARE AUTHORED AND SMALL."
  , "   Seven invented parameter names, five invented operation names, four"
  , "   quoted sentences. Spread across turns by the turn number, but finite"
  , "   and hand-written -- item 5's ceiling, one level over. A model could"
  , "   learn the pool rather than the property, and nothing here would"
  , "   detect it. The test that would: hold the pools out, generate a"
  , "   disjoint set, and check the ordering still holds. Not built."
  , ""
  , "11 THE ORDER BETWEEN A PADDED ANSWER AND A TRUNCATED ONE IS DECLINED,"
  , "   AND THE DECLINED DIRECTION IS THE CONVENIENT ONE."
  , "   `adhika` against `nasti`, and `adhika` against `apahrta`, are shipped"
  , "   in `atulya`, not in `krama`. Two arguments exist and neither defeats"
  , "   the other: section 5, a truncation admits no retraction and is"
  , "   therefore irreparable, so the padded answer -- which can be"
  , "   contradicted, being written -- would rank above it; against which,"
  , "   the Jaina vrata on anrta is not a magnitude to be traded against"
  , "   another loss. Section 7: where the standpoints differ the collapse is"
  , "   not forbidden, it is unavailable. Recorded here because the direction"
  , "   declined (`adhika` preferred to `nasti`) is the one that would have"
  , "   put the LONGER string back on the preferred side, so declining it is"
  , "   also convenient for the loss -- and a reason that is convenient needs"
  , "   its convenience stated or it is not a reason."
  , ""
  , "12 THE SUTRA NUMBER FOR THE DEFINITION OF anrta IS NOT VERIFIED HERE."
  , "   Tattvarthasutra 7.1 lists anrta among the five, and that sutra is in"
  , "   this repository. The definitional sutra `asad-abhidhanam anrtam` is"
  , "   recalled, its recension numbering differs, and no copy in this"
  , "   repository settles it -- so this file names the definition without a"
  , "   number. It is the same failure `parvan-asati` was built to catch,"
  , "   applied to this file's own citation, and reported rather than guessed."
  ]

-- ------------------------------------------------------------- the checks

-- | Returns (failures, checks run).  Every check is about THIS module's
--   constructor, run against the running table and a synthetic answer, so it
--   fails when the discipline fails and not when another lane moves.
pariksaAnrta :: IO (Int, Int)
pariksaAnrta = do
  loka <- lokah
  let realOp = fst (head (lKriyah loka))
      realParam = case [ (o, p) | (o, ps) <- lKriyah loka, p <- ps ] of
                    ((o, p):_) -> (o, p)
                    [] -> ("", "")
      u = JObj [ ("uttara", JStr "samkramana")
               , ("kriya", JStr realOp)
               , ("vahita", JObj [("kriyah", JArr [JStr "x"])])
               , ("vyaya", JArr [JStr "who asked, and why they asked now"]) ]
      good = [ ("a line saying a carried key did not travel is certified"
               , anrta loka u "vyaya" "`kriyah` \8212 named and not carried" (VahitaSthitam "kriyah"))
             , ("a line naming an absent operation is certified"
               , anrta loka u "vyaya" "whatever `naya.bheda` would have added" (KriyaAsati "naya.bheda" ""))
             ]
      bad = [ ("a TRUE line -- a real parameter of a real operation -- is REFUSED"
              , anrta loka u "vyaya" ("`" ++ snd realParam ++ "` did not travel")
                      (uncurry KriyaAsati realParam))
            , ("a line naming an operation that DOES exist is REFUSED"
              , anrta loka u "vyaya" ("whatever `" ++ realOp ++ "` would have added")
                      (KriyaAsati realOp ""))
            , ("a line whose witness names a key it does not mention is REFUSED"
              , anrta loka u "vyaya" "something else entirely" (VahitaSthitam "kriyah"))
            , ("a citation to a section that EXISTS is REFUSED"
              , anrta loka u "pramana" (sutraPath ++ " \167\&7 \8212 real") (ParvanAsati sutraPath 7))
            ]
      parvan = case lParvani loka of
        [] -> [("NOT RUN: the sutra was not found on disk, so family 3 emitted nothing", False)]
        ((f, have):_) ->
          [ ("a real sentence under a section the file does not have is certified"
            , either (const False) (const True)
                (anrta loka u "pramana" (f ++ " \167" ++ show (have + 3) ++ " \8212 real sentence")
                       (ParvanAsati f (have + 3)))) ]
      results = [ (n, either (const False) (const True) r) | (n, r) <- good ]
             ++ [ (n, either (const True) (const False) r) | (n, r) <- bad ]
             ++ parvan
  mapM_ (\(n, ok) -> putStrLn ((if ok then "  ok    " else "  FAIL  ") ++ n)) results
  case lParvani loka of
    ((f, have):_) -> putStrLn ("  loka: " ++ show (length (lKriyah loka))
                               ++ " operations walked from the running table; "
                               ++ f ++ " has " ++ show have ++ " sections")
    [] -> putStrLn "  loka: the sutra was NOT found; family 3 is silent, by design"
  pure (length [ () | (_, False) <- results ], length results)
