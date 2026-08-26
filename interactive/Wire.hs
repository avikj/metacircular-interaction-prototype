-- Json — the transport layer of the sabhā, and the
-- first place the contract is enforced rather than described.
--
-- śabda is the fourth pramāṇa: what reaches you as an utterance from
-- another (Gautama, Nyāyasūtra 1.1.7, āptopadeśaḥ śabdaḥ; Vātsyāyana's
-- Bhāṣya, c. 400 CE).  A wire is exactly that — everything the machine
-- knows about its interlocutor arrives as an utterance and nothing else.
-- So the wire's grammar is not a neutral encoding decision.  What the
-- grammar can say is what can be said here.
--
-- TWO THINGS THIS GRAMMAR CANNOT SAY, both by construction, both checked
-- by the type having no constructor for them:
--
--   1. THERE IS NO BOOLEAN.  ∥A∥₁ has no retraction — नास्ति-प्रत्यानयनम्,
--      AHIMSA_SUTRA_VISTARA §5 — so a `true` on the wire is not a compact
--      answer, it is the terminal object of a collapse with no way back.
--      Every yes/no in this system is instead a named position carrying
--      its own reasons.  A client that sends `true` gets told what to
--      send instead; it is not silently coerced, because a silent
--      coercion is the collapse performed by the parser.
--
--   2. THERE IS NO FLOAT.  CLAUDE.md: exact/certified symbolic
--      computation is proof, a measurement stands in for an error
--      analysis nobody did.  A decimal point on this wire is turned back at
--      the moment of the act, which is the repository's own stated rule
--      for what to do when prose has failed.
--
-- WHERE THE BOOLEAN CAME FROM, which this header did not say and which
-- changes where the repair goes.  '1 above gives the CONSEQUENCE: a
-- `true` is the terminal object of a collapse with no retraction.  The
-- CAUSE is in a different library, in
-- `fiber/src/Fiber/KuttakaValli_…`:
--
--     वल्ली, the step, is a total function त्रिक् → त्रिक् written with NO
--     comparison, NO `Dec`, NO `Bool` — because पक्षः has already recorded
--     which side the remainder fell on.  The subtractive Euclidean step
--     needs a decision only for a base that has thrown that slot away.
--
-- So a decision is the PRICE OF HAVING FORGOTTEN something.  Keep the slot
-- and the branch does not exist; discard it and a boolean is manufactured
-- to stand where the slot was.  That is Āryabhaṭa.s शेषं रक्ष read as
-- engineering rather than as piety: DISCARDING A SLOT MANUFACTURES A
-- BRANCH, and the branch is what the boolean stands in for.
--
-- ~~"and it is sharper than the thermodynamic form: erasure does not
-- merely cost"~~ -- STRUCK 2026-08-23 by its author, left standing struck.
-- That sentence imports Landauer as the comparison class and NO CHECKED
-- TERM ANYWHERE SUPPORTS IT.  A statement about `Dec` in a step function
-- is about code; joules are about a physical implementation, and this
-- corpus.s implementation runs on a machine that dissipates.  The branch
-- claim needs no physics and is weakened, not helped, by borrowing some:
-- वल्ली needs no comparison because पक्षः kept the slot, which is checkable
-- and checked, and that is the whole of it.
--
-- The same overclaim was struck the same day in
-- `Yantra_TheComputerIsTheGroupoidOfProofsOfTransport…` ("nothing is
-- erased, so nothing dissipates"; "hence (Landauer) the zero-heat floor")
-- and in `PramanaSankramana` §5 ("a receipted crossing costs zero joules,
-- forever, for anyone").  Three files, one inference, no term.
--
-- OPERATIVE CONSEQUENCE, and it is why this is written here.  This wire
-- turns back a boolean and offers a repair AT THE WIRE.  That is the right
-- place to turn it back and the wrong place to fix.  A client that keeps sending
-- `true` is not the defect; the defect is the slot its producer discarded,
-- upstream, and no amount of wire grammar reaches it.  A boolean on this
-- wire is a RECEIPT of that discard.
--
-- Neither file said this.  '1 knows the collapse is irreversible and not
-- what produced it; the kuṭṭaka module knows what produces it and is not
-- about wires.  2026-08-23.
--
-- Nor is there `null`.  Absence is said by omitting the key, and asked
-- for by name; a key present-and-null is two facts flattened into one.
--
-- The turn-backs are not errors in the ordinary sense: each one returns the
-- utterance it turned back AND the utterance that would have carried the same
-- intent without loss.  A turn-back without a repair is itself a collapse.
--
-- NOT CLAIMED: that Gautama or Vātsyāyana wrote a wire format.  What is
-- taken from Nyāya is the position that testimony is a distinct pramāṇa
-- with its own fitness conditions, and that an utterance arriving by an
-- unaccepted route is not weak evidence but no evidence (§19 of the
-- sūtra: अप्रमाणं न सञ्चीयते — what is not a pramāṇa does not accumulate).

module Wire
  ( J(..)
  , render
  , parseJ
  , parseLine
  , look
  , jStr
  , jInt
  , jStrs
  , jObj
  , unwritable
  , Vacana(..)
  , vacana
  , vStr
  , vInt
  , vStrs
  , vObjAt
  , athava
  , anadhikrta
  ) where

import Data.Char (isDigit, isHexDigit, chr, digitToInt, isControl, ord)
import Data.List (intercalate)
import Numeric (showHex)

-- | The whole of what may cross the wire.  Four constructors.  Count them:
--   no boolean, no float, no null.
data J
  = JStr String
  | JInt Integer
  | JArr [J]
  | JObj [(String, J)]
  deriving (Eq, Show)

-- ------------------------------------------------------------- writing

render :: J -> String
render (JStr s) = quote s
render (JInt n) = show n
render (JArr xs) = "[" ++ intercalate "," (map render xs) ++ "]"
render (JObj kvs) =
  "{" ++ intercalate "," [ quote k ++ ":" ++ render v | (k, v) <- kvs ] ++ "}"

quote :: String -> String
quote s = '"' : concatMap esc s ++ "\""
  where
    esc '"'  = "\\\""
    esc '\\' = "\\\\"
    esc '\n' = "\\n"
    esc '\r' = "\\r"
    esc '\t' = "\\t"
    esc c
      | isControl c && ord c < 0x10000 =
          let h = showHex (ord c) ""
          in "\\u" ++ replicate (4 - length h) '0' ++ h
      | otherwise = [c]

-- ------------------------------------------------------------- reading
--
-- Left carries a sentence, not a code.  Every Left below says what
-- arrived and what to send instead; see the header.

parseLine :: String -> Either String J
parseLine s = do
  (v, rest) <- value (skip s)
  case skip rest of
    [] -> Right v
    r  -> Left ("trailing text after the utterance: " ++ show (take 40 r)
                ++ " — one utterance per line on this wire")

parseJ :: String -> Either String J
parseJ = parseLine

skip :: String -> String
skip = dropWhile (`elem` " \t\r\n")

value :: String -> Either String (J, String)
value [] = Left "the utterance was empty"
value s@(c:cs)
  | c == '"'  = do (str, r) <- pstring cs; Right (JStr str, r)
  | c == '{'  = pobject (skip cs)
  | c == '['  = parray (skip cs)
  | c == '-' || isDigit c = pnumber s
  | take 4 s == "true" || take 5 s == "false" =
      Left ("a bare boolean arrived on the wire: `"
            ++ (if take 4 s == "true" then "true" else "false")
            ++ "`.  This wire has no boolean, because a boolean is the "
            ++ "collapse with no retraction (∥A∥₁, no section: "
            ++ "AHIMSA_SUTRA_VISTARA §5).  Send the name of the position "
            ++ "instead — e.g. \"arpana\":\"saha\" or \"arpana\":\"krama\" "
            ++ "— so the answer carries which, and not only whether.")
  | take 4 s == "null" =
      Left ("`null` arrived on the wire.  Absence here is said by omitting "
            ++ "the key; a key present-and-null flattens `not given` and "
            ++ "`given as nothing` into one.  Omit it, or name the "
            ++ "absence: \"sesa\":[\"why it is not given\"].")
  | otherwise = Left ("cannot read an utterance beginning " ++ show (take 20 s))

pnumber :: String -> Either String (J, String)
pnumber s =
  let (sgn, s1) = case s of { ('-':r) -> ("-", r); _ -> ("", s) }
      (ds, r1)  = span isDigit s1
  in if null ds
       then Left ("a number was started and not written: " ++ show (take 12 s))
       else case r1 of
         (c:_) | c == '.' || c == 'e' || c == 'E' ->
           Left ("a float arrived on the wire: " ++ show (takeWhile (`notElem` ",}] ") s)
                 ++ ".  Exact arithmetic only (CLAUDE.md: a measurement "
                 ++ "stands in for an error analysis nobody did).  Send the "
                 ++ "exact object — a ratio as two integers, or the integer "
                 ++ "itself — and if the quantity is genuinely approximate, "
                 ++ "say so with the word the tradition uses: āsanna "
                 ++ "(Āryabhaṭīya 2.10, 499) states the approximation IN the "
                 ++ "verse rather than hiding it in the digits.")
         _ -> Right (JInt (read (sgn ++ ds)), r1)

pstring :: String -> Either String (String, String)
pstring [] = Left "an unterminated string reached the end of the line"
pstring ('"':r) = Right ("", r)
pstring ('\\':c:r) = case c of
  '"'  -> cons '"' (pstring r)
  '\\' -> cons '\\' (pstring r)
  '/'  -> cons '/' (pstring r)
  'n'  -> cons '\n' (pstring r)
  't'  -> cons '\t' (pstring r)
  'r'  -> cons '\r' (pstring r)
  'b'  -> cons '\b' (pstring r)
  'f'  -> cons '\f' (pstring r)
  'u'  -> case splitAt 4 r of
            (h, r') | length h == 4 && all isHexDigit h ->
              uEscape (hexVal h) r'
            _ -> Left "a \\u escape without four hex digits"
  _    -> Left ("unknown escape \\" ++ [c])
  where cons x = fmap (\(str, rest) -> (x : str, rest))
pstring (c:r) = fmap (\(str, rest) -> (c : str, rest)) (pstring r)

hexVal :: String -> Int
hexVal = foldl (\a d -> a * 16 + digitToInt d) 0

-- THE READER MUST NOT ADMIT WHAT THE WRITER CANNOT WRITE.  Doṣa 0017:
-- `\ud800` was read as `chr 0xD800`, a lone surrogate, which is a legal
-- Haskell Char and is not encodable as UTF-8.  It travelled through the
-- machine, reached `hPutStrLn`, and the encoder threw THERE — half an answer
-- already on the wire, exit 1, the transcript never created, the session's
-- written remainders destroyed unwritten.  That is neither road (§6:
-- तृतीयो मार्गो न विद्यते) and it was the default behaviour of this branch.
--
-- Surrogates exist only to encode a supplementary character as a PAIR in
-- UTF-16.  So the pair is accepted and combined — nothing is lost, that is
-- the transport — and a lone one is turned back with the repair named, which is
-- what every other answer in this file does.
uEscape :: Int -> String -> Either String (String, String)
uEscape n rest
  | n >= 0xD800 && n <= 0xDBFF =
      case rest of
        ('\\':'u':more) | (h, r') <- splitAt 4 more
                        , length h == 4, all isHexDigit h
                        , lo <- hexVal h
                        , lo >= 0xDC00 && lo <= 0xDFFF ->
          consChar (chr (0x10000 + (n - 0xD800) * 0x400 + (lo - 0xDC00))) r'
        _ -> Left (loneMsg n "high" "a low surrogate \\udc00–\\udfff")
  | n >= 0xDC00 && n <= 0xDFFF =
      Left (loneMsg n "low" "a high surrogate \\ud800–\\udbff before it")
  | otherwise = consChar (chr n) rest
  where
    consChar x r = fmap (\(str, s) -> (x : str, s)) (pstring r)
    loneMsg v which want =
      "a lone " ++ which ++ " surrogate escape arrived on the wire: \\u"
      ++ pad4hex v ++ ".  A surrogate is half of a UTF-16 pair and is not a "
      ++ "character; nothing on this wire can encode one, so accepting it "
      ++ "here would hand the writer a value it cannot write — and the "
      ++ "failure would then land mid-flush, truncating the answer instead "
      ++ "of turning back the utterance (doṣa 0017).  Send " ++ want
      ++ ", or send the character itself in UTF-8."

pad4hex :: Int -> String
pad4hex v = let h = showHex v "" in replicate (4 - length h) '0' ++ h

-- | Is this String writable at all?  A String may hold a lone surrogate that
--   arrived from somewhere other than this parser — a handler that built it,
--   a file read under a different decoder — and `render` would then produce
--   bytes the UTF-8 encoder cannot write, mid-line.  Callers that are about to put
--   a rendered answer on a wire ask this FIRST and take the second road when
--   the answer is Just.  §6, held at the boundary where it was being lost.
unwritable :: String -> Maybe Char
unwritable s = case [ c | c <- s, ord c >= 0xD800, ord c <= 0xDFFF ] of
  (c:_) -> Just c
  []    -> Nothing

parray :: String -> Either String (J, String)
parray (']':r) = Right (JArr [], r)
parray s = go s []
  where
    go t acc = do
      (v, r) <- value (skip t)
      case skip r of
        (',':r') -> go r' (v : acc)
        (']':r') -> Right (JArr (reverse (v : acc)), r')
        r'       -> Left ("expected `,` or `]` in a list, found "
                          ++ show (take 12 r'))

pobject :: String -> Either String (J, String)
pobject ('}':r) = Right (JObj [], r)
pobject s = go s []
  where
    go t acc = case skip t of
      ('"':t1) -> do
        (k, r1) <- pstring t1
        case skip r1 of
          (':':r2) -> do
            (v, r3) <- value (skip r2)
            case skip r3 of
              (',':r4) -> go r4 ((k, v) : acc)
              ('}':r4) -> Right (JObj (reverse ((k, v) : acc)), r4)
              r4       -> Left ("expected `,` or `}` in an object, found "
                                ++ show (take 12 r4))
          r2 -> Left ("expected `:` after key " ++ show k ++ ", found "
                      ++ show (take 12 r2))
      t1 -> Left ("an object key must be a string; found " ++ show (take 12 t1))

-- ------------------------------------------------------- reading fields
--
-- Every accessor returns Either String, and the Left is a sentence for the
-- caller's eyes.  None of them defaults: a default is a silent collapse of
-- `you did not say` into `you said this`.

-- `J` holds an object as an ordered association list and PRESERVES repeats,
-- deliberately: a Map would keep one binding and drop the rest, which is the
-- collapse this whole file exists to refuse.  `look` used to read that list
-- with Data.List.lookup, which returns the FIRST binding and discards the rest
-- with no error and no residue — so the parser preserved the multiplicity and
-- the accessor destroyed it, one function later, in the same lane.  Recorded
-- as doṣa 0015 in interactive/dosa.lekha, and repaired here rather than argued
-- about: `look` has the same two roads as everything else (§6), and a key
-- bound twice takes the second.
--
-- NOT deduplication.  Deduplication would decide that the two bindings are
-- the same when the wire has just said they are two, which is the collapse
-- wearing a repair's name.  Both are named in the answer and neither is
-- chosen for the caller.
look :: String -> J -> Either String J
look k (JObj kvs) = case [ v | (k', v) <- kvs, k' == k ] of
  [v] -> Right v
  []  -> Left ("no key `" ++ k ++ "` in the utterance; keys present: "
               ++ intercalate ", " (map fst kvs))
  vs  -> Left ("key `" ++ k ++ "` is bound " ++ show (length vs)
               ++ " times in one object, carrying "
               ++ intercalate " and then " (map render vs)
               ++ ".  Reading the first would destroy the rest with no residue "
               ++ "and no way back (∥A∥₁ has no section: AHIMSA_SUTRA_VISTARA "
               ++ "§5), so it is turned back rather than resolved.  Send the key "
               ++ "once; if you meant several things, send them as one list "
               ++ "under it: \"" ++ k ++ "\":[…] — a list says `these are "
               ++ "several` and a repeated key says `this is one thing` twice.")
look k _ = Left ("looked for key `" ++ k ++ "` in something that is not an object")

jStr :: String -> J -> Either String String
jStr k o = look k o >>= \v -> case v of
  JStr s -> Right s
  _      -> Left ("key `" ++ k ++ "` is not a string: " ++ render v)

jInt :: String -> J -> Either String Integer
jInt k o = look k o >>= \v -> case v of
  JInt n -> Right n
  _      -> Left ("key `" ++ k ++ "` is not an integer: " ++ render v)

jStrs :: String -> J -> Either String [String]
jStrs k o = look k o >>= \v -> case v of
  JArr xs -> mapM one xs
  _       -> Left ("key `" ++ k ++ "` is not a list: " ++ render v)
  where
    one (JStr s) = Right s
    one x        = Left ("a list under `" ++ k ++ "` holds a non-string: "
                         ++ render x)

jObj :: J -> Either String [(String, J)]
jObj (JObj kvs) = Right kvs
jObj v = Left ("expected an object, got " ++ render v)

-- ------------------------------------------------- three, where two collapse
--
-- WHY THIS SECTION EXISTS, and it is the header's own argument one layer
-- down.  The header says: *Nor is there `null`.  Absence is said by omitting
-- the key; a key present-and-null is two facts flattened into one.*  The
-- parser enforces that at the wire.  Three lines into a handler the same
-- flattening was being performed anyway, by hand, in the shape
--
--     either (const <default>) id (jInt "avrtti" j)
--
-- — because `Either String a` has two positions and the reader needs three.
-- `Left` there carries BOTH `you did not say` and `you said it and I could
-- not read it`, and `const` discards the sentence that said which.  The
-- caller who sent `avrtti:"second"` was answered about occurrence 0 and told
-- it succeeded.  That is the boolean this wire turns back, reached by another
-- road: a default is a silent coercion, and a silent coercion is the
-- collapse performed by the parser (header, on turn-backs).
--
-- So the reader's own type has three constructors, for the same reason the
-- wire has four and no boolean: what the type cannot say, this machine
-- cannot do.  A default may attach to अनुक्तम् and to nothing else.
--
-- The correct pattern was already in the kernel twice — kuṭṭaka's `c` and
-- vargaprakṛti's `n` are read with `case look k j of Left _ -> …; Right
-- (JInt n) -> …; Right other -> turned back` — and was written out longhand each
-- time, which is why the other four sites did not get it.  §35: यत् हेतुना
-- जन्यते तत् न स्थाप्यते — what a rule generates is not stored in six copies.
--
-- NOT CLAIMED of any source.  `vacana`, `ukta`, `anukta`, `durvaca` are the
-- ordinary Sanskrit words for utterance, uttered, unuttered, and ill-spoken
-- / hard-to-express (durvaca, an attested adjective).  No text is being said
-- to have specified a JSON reader.  What §3 does supply, and what is being
-- used, is the position itself: अवक्तव्यं न अज्ञातम् । अवक्तव्यं न अनिर्धारितम् ।
-- अवक्तव्यं न शून्यम् — the inexpressible is not the unknown, not the
-- undetermined, and not the empty.  Durvacam is not Anuktam.

-- | What a key on the wire is, from the reader's side.  Three, not two.
data Vacana a
  = Anuktam            -- ^ अनुक्तम् — not uttered.  The key is absent.
  | Uktam a            -- ^ उक्तम् — uttered, and readable in the shape asked for.
  | Durvacam String    -- ^ दुर्वचम् — uttered and NOT readable.  Carries the
                       --   sentence the accessor had already composed and
                       --   which `const` used to throw away.
  deriving (Eq, Show)

-- | Lift any of the `j*` accessors above into the three-way reading.  The
--   key's presence is decided by `lookup`, never by the accessor's `Left`,
--   which is exactly the confusion being removed.
vacana :: (String -> J -> Either String a) -> String -> J -> Vacana a
vacana rd k o@(JObj kvs) = case lookup k kvs of
  Nothing -> Anuktam
  Just _  -> either Durvacam Uktam (rd k o)
vacana _ k v = Durvacam ("looked for key `" ++ k ++ "` in something that is not "
                         ++ "an object: " ++ render v)

vStr :: String -> J -> Vacana String
vStr = vacana jStr

vInt :: String -> J -> Vacana Integer
vInt = vacana jInt

vStrs :: String -> J -> Vacana [String]
vStrs = vacana jStrs

-- | The key must be present AS AN OBJECT.  Used for the argument bundle,
--   where `absent` and `present and not an object` were byte-identical
--   (doṣa 0016).
vObjAt :: String -> J -> Vacana J
vObjAt = vacana (\k o -> look k o >>= \v -> case v of
                   JObj _ -> Right v
                   _      -> Left ("key `" ++ k ++ "` is not an object: " ++ render v))

-- | अथवा — "or else".  The ONLY sanctioned way to give a key a default, and
--   the whole of its discipline is in which constructor it may touch: the
--   default applies to अनुक्तम् and never to दुर्वचम्.  A `Left` out of this is
--   a sentence to be written as a doṣa-lekha, not a value to fall back from.
athava :: a -> Vacana a -> Either String a
athava d Anuktam      = Right d
athava _ (Uktam a)    = Right a
athava _ (Durvacam e) = Left e

-- | अनधिकृतम् — given the names an operation declares, the keys in an
--   argument object that nothing reads.  Each is returned WITH its own
--   reason, in the caller's own order.
--
-- THE SECOND WAY TO BE READ BY NOTHING IS NOT CHECKED HERE, and that is a
-- decision rather than an omission.  A key uttered twice is also read by
-- nothing — the reader took the first and the rest went with no trace — and
-- this function carried a branch for it.  The branch is gone because `look`,
-- above, was repaired for doṣa 0015 in this same file while this was being
-- written, and it turns back a doubled key AT THE ACCESSOR, naming both values
-- and giving the repair (send a list, which says `these are several`, rather
-- than the key twice, which says `this is one thing` twice).  A check here
-- runs first and would shadow that with a worse sentence: one lane's rule
-- displacing another lane's better one by being earlier in the pipeline,
-- which is vipratiṣedha settled by list position and is exactly what
-- Aṣṭādhyāyī 1.4.2 exists to rule out.  An undeclared doubled key still lands
-- here, by the extent branch below; a declared one reaches `look`.
--
-- THIS IS WHAT THIS WIRE SAYS INSTEAD OF `additionalProperties:false`,
-- WHICH IT CANNOT EMIT.  A schema rendered by this module cannot carry that
-- keyword: its value is literally `false` and `J` has four constructors and
-- no boolean.  The tool-schema lane says so in its own vyaya rather than
-- smuggling a fifth constructor in, and the hole it names was real — the
-- kernels read the keys they name and ignored the rest, so a misspelt param
-- was executed as an omission and reported as a success.
--
-- A FIFTH CONSTRUCTOR IS THE OBVIOUS REPAIR AND IT IS THE WRONG ONE.  It
-- buys one keyword in one emitted document at the price of this module's
-- whole claim: the moment `J` can carry `false`, every operation on this
-- machine CAN answer with a bare boolean, and the argument that stops it
-- drops from `the type has no constructor for it` — mechanical, at the
-- moment of the act — to `nobody has done it yet`.  §5: नष्टिर्विनाशः । यत्
-- नष्टं तत् अग्रे न लभ्यम् — that is not a trade.
--
-- SILENCE IS ALSO WRONG, for the reason above: the hole is real.
--
-- The third road is that the constraint was never the schema's to state.
-- `additionalProperties:false` asks the CALLER's validator to turn it back; the
-- ignoring happens in the kernel.  So it is turned back in the kernel, and what
-- comes back is strictly more than the keyword could have said: WHICH key,
-- WHY it is unread, and the operation's whole adhikāra beside it.  A
-- validator would have answered `does not match schema`.  The keyword stays
-- unsayable and stays unsaid; the hole it named is closed at the machine
-- rather than at the description of the machine — §36, यो करणं न जानाति स
-- तस्मै न रचयति: design for the carrier, and the carrier misspells keys.
--
-- WHAT IS NOT CLOSED, stated so the next reader does not infer it: the
-- callers of this guard it at the ARGUMENT object only.  The top level of a
-- request stays open — `prasna-id` rides there and is read by the transport,
-- not by any operation — so an unnamed key beside `kriya` is still ignored
-- in silence.  Closing that needs the set of keys the transport itself
-- claims, which is not written down anywhere yet.
--
-- NOT CLAIMED of Pāṇini: adhikāra is his term for a heading that governs a
-- stated extent (Aṣṭādhyāyī 1.4.1–2 and the adhikāra-sūtras throughout), and
-- what is taken is one sentence of it — the extent is stated, so a rule
-- outside it is not a weaker match, it is outside.  He did not write a
-- parameter check.
anadhikrta :: [String] -> J -> [(String, String)]
anadhikrta declared (JObj kvs) =
  [ (n, why n) | n <- nub' [ n | (n, _) <- kvs ], why n /= "" ]
  where
    count n = length [ () | (m, _) <- kvs, m == n ]
    why n
      | n `notElem` declared =
          "this operation declares no parameter of that name, so nothing reads it"
      | count n > 1 =
          "uttered " ++ show (count n) ++ " times in one object; the reader takes "
          ++ "the first and the rest are lost with no trace, so which one you meant "
          ++ "is not in the utterance"
      | otherwise = ""
    nub' [] = []
    nub' (x:xs) = x : nub' [ z | z <- xs, z /= x ]
anadhikrta _ _ = []
