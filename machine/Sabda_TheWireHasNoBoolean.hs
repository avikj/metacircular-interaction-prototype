-- Sabda_TheWireHasNoBoolean — the transport layer of the sabhā, and the
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
--      analysis nobody did.  A decimal point on this wire is refused at
--      the moment of the act, which is the repository's own stated rule
--      for what to do when prose has failed.
--
-- Nor is there `null`.  Absence is said by omitting the key, and asked
-- for by name; a key present-and-null is two facts flattened into one.
--
-- The refusals are not errors in the ordinary sense: each one returns the
-- utterance it refused AND the utterance that would have carried the same
-- intent without loss.  Refusal without a repair is itself a collapse.
--
-- NOT CLAIMED: that Gautama or Vātsyāyana wrote a wire format.  What is
-- taken from Nyāya is the position that testimony is a distinct pramāṇa
-- with its own fitness conditions, and that an utterance arriving by an
-- unaccepted route is not weak evidence but no evidence (§19 of the
-- sūtra: अप्रमाणं न सञ्चीयते — what is not a pramāṇa does not accumulate).

module Sabda_TheWireHasNoBoolean
  ( J(..)
  , render
  , parseJ
  , parseLine
  , look
  , jStr
  , jInt
  , jStrs
  , jObj
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
              cons (chr (foldl (\a d -> a * 16 + digitToInt d) 0 h)) (pstring r')
            _ -> Left "a \\u escape without four hex digits"
  _    -> Left ("unknown escape \\" ++ [c])
  where cons x = fmap (\(str, rest) -> (x : str, rest))
pstring (c:r) = fmap (\(str, rest) -> (c : str, rest)) (pstring r)

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

look :: String -> J -> Either String J
look k (JObj kvs) = case lookup k kvs of
  Just v  -> Right v
  Nothing -> Left ("no key `" ++ k ++ "` in the utterance; keys present: "
                   ++ intercalate ", " (map fst kvs))
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
