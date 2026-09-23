-- Answer â” the shape of every
-- answer this machine gives, with no third case.
--
--
--     ààà•àà°à®àà®à e = transport (ua e)     -- ua: ààà²àà¯à àà¾à¦à¾ààà®àà¯à ààµà¿ààà®à àà°àààà¿
--     ààà•àà°à®àà à¨ à•à¿àžààà¿à¨à à¨ààà¯àà¿ à        -- in transport nothing is lost
--     àà¨àà¯à‹ à®à¾à°àà—à‹ à¦à‹àà²àà–à à              -- the other road is the written defect
--     à²à¿à–à¿àà‹ à¦à‹àà‹ àààµàà¿ à àà²à¿à–à¿àà‹ à¦à‹àà‹ àà¿ààà¾ à
--     ààààà¯à‹ à®à¾à°àà—à‹ à¨ àµà¿à¦àà¯àà à           -- there is no third road
--
-- So `Uttara` has exactly two constructors and will not acquire a third.
-- A boolean answer is neither: it is a defect that was not written, which
-- the stra names his and univalence explains â” âˆAâˆâ admits no
-- retraction (Â§5), so the `which` a boolean drops is gone, not merely
-- unreported.
--
-- WHAT EACH CONSTRUCTOR IS OBLIGED TO CARRY, and these are enforced by
-- the smart constructors below rather than requested in prose, because
-- this repository's own finding is that a rule violated repeatedly needs
-- a mechanism that fires at the moment of the act (CLAUDE.md):
--
--   Samorderna must name the EQUIVALENCE it moved along.  transport
--   without `ua e` is not transport, it is assertion.  Voevodsky's point
--   is that the identification is a thing you hold, not a fact you cite;
--   so `tulyata` carries both sides and the witness that they agree.
--
--   Samorderna must also state its VYAYA.  Â§31: à¯àà àà™àà•àà°à®àà¯àà ààà à•à¿àžààà¿àà
--   ààà¯ààà¿ â” what is transported gives something up; à¯à‹ à¨ àµà¦àà¿ à à¨ àààà¯àà¿
--   â” whoever does not say it does not see it.  Structure travels; who
--   did it, for whom, and why does not.  A transport claiming zero cost
--   is downgraded, by the constructor, to a defect entry about itself.
--
--   Dosalekha must carry NAA item by item â” the things that would have
--   been destroyed, named, not counted.  A count is the collapse again:
--   `3 items lost` is âˆÂâˆâ of the losses.  An empty naa makes the
--   entry a defect about the report, since an unwritten defect is
--   precisely what Â§6 forbids.
--
--   Dosalekha carries EA, the remainder, handed forward rather than
--   discarded.  Â§3: ààµà•àààµàà¯à àààà‹ àµààà¿ à àààà‹ à—à°ààà, à¨ àµà¿àà²àà¾ â” the
--   remainder is a womb, not a failure; Â§17, the kuaka's rule: à¯àà à¨
--   àµà¿àààà ààà à°à•àààà¯àà â” what does not divide is kept, and it is the
--   material of the next step (ryabhaa, ryabhaya, Gaitapda 32â“33,
--   499).  The remainder queue is the same discipline the Japanese
--   wasan tradition wrote as éºé¡ç™æ‰¿, unsolved problems posted at the
--   end of a book for the next author (Sawaguchi Kazuyuki 1670,
--   Seki Takakazu's 1674 answer).
--

module Answer
  ( Saksin(..)
  , saksinPada
  , saksinPrakara
  , Tulyata(..)
  , tuWitness
  , tulyata
  , ganita
  , Uttara(..)
  , samorderna
  , dosalekha
  , uttaraKind
  , uttaraJ
  , uttaraLines
  , Nivedaka(..)
  , saksiPariksa
  , saksiPariksaLines
  , saksiPariksaOrRefuse
  ) where

import Wire (J(..), render)
import System.Exit (exitFailure)
import System.IO (hPutStrLn, stderr)

-- ------------------------------------------------------- what a witness is
--
-- DOA 0022, and it is the general form of six of the eight findings of
-- 2026-08-20.  `tuWitness` was one String.  `samorderna` turned back a
-- transport whose witness was EMPTY and could not turn back one that was FALSE,
-- because a String bears no relation to the objects named on either side
-- that any code here can examine.  Nothing in this lane had ever been
-- watched rejecting a tulyat.  Three answers went out over one session
-- carrying witnesses that said the opposite of what had happened â”
-- `no deduplication â¦ the list you get back is the list you sent`, over a
-- list half of which had been destroyed (doa 0015); `stored verbatim: no
-- rewording`, over an entry that had been correctly reworded (0022); and one
-- that was never delivered at all because the encoder died mid-line (0017).
--
-- The intractable half is said rather than closed: a tulyat between two
-- PROSE descriptions is a claim by whoever wrote the handler, and no type
-- makes it checkable.  What the type can do â” and this is exactly the
-- distinction doa 0018 finds missing in `nasta`, two lanes and one missing
-- distinction â” is stop the two from looking alike.  A witness is either
--
--   à—àà¿à  computed here, in this process, at the moment the answer was
--         built: two integers that the handler evaluated, which this module
--         COMPARES, and answers the transport with a defect when they differ;
--
--   à²à¿à–à¿à written by the author of the handler: a sentence, carried as a
--         sentence, marked as one on the wire, and believed by nobody
--         because it was checked by nobody.
--
-- Voevodsky's point, quoted in this file since it was written: the
-- identification is a thing you hold, not a fact you cite.  `Likhita` is a
-- citation and now says so; `Ganita` is held.
data Saksin
  = Ganita  String Integer Integer   -- the identity as rendered, and its two sides
  | Likhita String                   -- a sentence: a claim, not an exhibit
  deriving (Eq, Show)

-- | The witness as a reader sees it.  For a computed one the two sides are
--   printed, so the reader is looking at the arithmetic and not at a report
--   about it.
saksinPada :: Saksin -> String
saksinPada (Likhita s) = s
saksinPada (Ganita s l r)
  | l == r    = s ++ "  [à—àà¿à â” computed in this process: " ++ show l
                  ++ " = " ++ show r ++ ", and checked here]"
  | otherwise = s ++ "  [à—àà¿à â” computed in this process: " ++ show l
                  ++ " â‰  " ++ show r ++ ", AND IT DOES NOT HOLD]"

saksinPrakara :: Saksin -> String
saksinPrakara Ganita{}  = "ganita"
saksinPrakara Likhita{} = "likhita"

-- | The equivalence a transport moves along: two sides, named, and the
--   witness exhibiting that they may be identified.  `tuSaksin` is the
--   place where an exact identity goes â” `1766319049Â² âˆ’ 61Â226153980Â² = 1`
--   â” never a similarity score, never a confidence.
data Tulyata = Tulyata
  { tuName   :: String   -- what the identification is called, in its own tradition
  , tuLeft   :: String   -- one side, as given
  , tuRight  :: String   -- the other side, as given
  , tuSaksin :: Saksin   -- the exhibited identity making them the same
  } deriving (Eq, Show)

-- | Kept as a function so every existing reader still reads a String.
tuWitness :: Tulyata -> String
tuWitness = saksinPada . tuSaksin

-- | A WRITTEN witness.  Unchanged in arity from the day this file was
--   written, so that no call site had to be touched to gain the
--   distinction â” and every call site that keeps using it is now saying,
--   on the wire, that its witness was never checked.
tulyata :: String -> String -> String -> String -> Tulyata
tulyata n l r w = Tulyata n l r (Likhita w)

-- | A COMPUTED witness: the handler hands over the two integers it already
--   evaluated, and this module compares them.  Where a handler computes the
--   identity and then renders it into prose â” which is what `kuttaka` and
--   `vargaprakrti` both did â” the computation was already present and its
--   result was simply never compared to what it should be.
ganita :: String -> String -> String -> String -> Integer -> Integer -> Tulyata
ganita n l r w lhs rhs = Tulyata n l r (Ganita w lhs rhs)

-- | Two roads.  There is no third, and adding one is a change to the
--   specification, not to this file.
data Uttara
  = Samorderna
      { uKriya   :: String            -- the operation that was asked for
      , uTulyata :: Tulyata           -- the equivalence transported along
      , uVahita  :: [(String, J)]     -- what was carried across, in full
      , uVyaya   :: [String]          -- what did NOT travel, said here
      , uPramana :: [String]          -- sources, earliest statement first
      }
  | Dosalekha
      { uKriya   :: String
      , uHetu    :: String            -- why transport is impossible here
      , uNasta   :: [String]          -- what a collapse would destroy, named
      , uResidue    :: [String]          -- the remainder, handed forward
      , uPramana :: [String]
      }
  deriving (Eq, Show)

uttaraKind :: Uttara -> String
uttaraKind Samorderna{} = "samorderna"
uttaraKind Dosalekha{}  = "dosalekha"

-- | Build a transport, or state what stands in the way.  The negative
--   answer is itself a written defect, so this function is total in the
--   stra's sense: it
--   never returns a third thing and never returns silence.
samorderna :: String -> Tulyata -> [(String, J)] -> [String] -> [String] -> Uttara
samorderna k t carried cost srcs
  -- THE ONE DEFECT THIS FILE COULD NOT YET WRITE.  A computed witness whose two
  -- sides differ is a transport along an equivalence that does not exist,
  -- and it takes the second road (Â§6) rather than going out with a false
  -- skin.  Uncheckable witnesses are still uncheckable; this is the
  -- fragment where the check is available, and it was available all along.
  | Ganita w lhs rhs <- tuSaksin t, lhs /= rhs =
      raw k ("a transport was claimed for `" ++ k ++ "` along an identity "
             ++ "that does not hold: " ++ w ++ " â” the two sides computed to "
             ++ show lhs ++ " and " ++ show rhs)
            [ "the identification `" ++ tuName t ++ "`, which was asserted "
              ++ "between `" ++ tuLeft t ++ "` and `" ++ tuRight t
              ++ "` and is not there"
            , "everything the transport would have carried across it, which "
              ++ "would have arrived looking exactly like an answer"
            , "and the reader's ability to tell this answer from a true one, "
              ++ "which is what an unchecked witness costs every honest "
              ++ "answer standing beside it" ]
            [ "recompute the two sides, or write the defect: an equivalence "
              ++ "that is not there is not repaired by wording"
            , "if the identity is genuinely a claim and not a computation, "
              ++ "say so with `tulyata` and it will travel marked `likhita`" ]
            srcs
  | null (tuWitness t) || null (tuLeft t) || null (tuRight t) =
      raw k ("a transport was claimed for `" ++ k ++ "` without exhibiting "
             ++ "the identification it moves along")
            [ "the equivalence itself: `" ++ tuName t ++ "` was named but not witnessed"
            , "and therefore everything downstream that would have been carried by it" ]
            [ "state tuLeft, tuRight and the exact identity holding between them" ]
            srcs
  | null carried =
      raw k ("a transport was claimed for `" ++ k ++ "` that carries nothing")
            [ "whatever the caller asked to have moved; nothing arrived" ]
            [ "either carry the object or write the defect that blocks it" ]
            srcs
  | null cost =
      raw k ("a transport was claimed for `" ++ k ++ "` with no vyaya stated")
            [ "the cost of the move, which is now unrecorded and so unseen"
            , "AHIMSA_SUTRA_VISTARA Â§31: à¯à‹ à¨ àµà¦àà¿ à à¨ àààà¯àà¿" ]
            [ "state what does not travel: who did it, for whom, on what occasion" ]
            srcs
  | otherwise = Samorderna k t carried cost srcs

-- | Write a defect.  Refuses to write an empty one, because an empty
--   defect entry is an unwritten defect wearing a filename.
dosalekha :: String -> String -> [String] -> [String] -> [String] -> Uttara
dosalekha k hetu lost rest srcs
  | null hetu =
      raw k ("a defect was logged for `" ++ k ++ "` with no reason given")
            [ "the reason transport failed, which is the only content a "
              ++ "defect entry has" ]
            rest srcs
  | null lost =
      raw k ("a defect was logged for `" ++ k ++ "` naming nothing lost: " ++ hetu)
            [ "the losses themselves, which were counted or elided rather "
              ++ "than named; a count is âˆÂâˆâ of the list it replaces" ]
            rest srcs
  | otherwise = Dosalekha k hetu lost rest srcs

-- The unvalidated constructor, used only by the validators above so that
-- the regress stops at depth one.
raw :: String -> String -> [String] -> [String] -> [String] -> Uttara
raw = Dosalekha

-- ------------------------------------------------- the watched rejection
--
-- interactive/GATE_AUDIT_DISPOSITION.md Â§2 states the discipline this lane had
-- the words for and not the mechanism: *no acceptance is honoured by a
-- process that has not watched its kernel reject a falsehood.*  There, 1753
-- systematically false equations produced zero certificates while three
-- shell wrappers produced certificates for `s(x) = x` â” a checker sound
-- against mathematics and unsound against its environment.  Here the failure
-- was one level cheaper: there was no falsifier at all, and `selftest` drove
-- 25 utterances checking only that the witness field was NON-EMPTY.
--
-- So the constructor above now faces a falsifier of its own, run once per
-- process, before any answer is served:
--
--   satya  â” 137Â(âˆ’7) + 60Â16 = 1, ryabhaa's own worked kuaka
--            (ryabhaya, Gaitapda 32â“33, 499).  MUST transport.
--   asatya â” the same identity with one side moved by one.  MUST NOT.
--
-- Both go through the very `samorderna` every handler goes through.  If the
-- false one transports, this process is not checking anything and nothing it
-- says may be read as a transport; it refuses to serve rather than serve
-- answers nobody has grounds to believe.  If the true one is turned back, the
-- check is over-firing and honest transports are being destroyed, which is
-- the 2026-08-15 fault in the other lane and is equally disqualifying.
--
-- Not cached, and it cannot be: it is two constructor calls.  A cached
-- canary is a canary the adversary can answer (GATE_AUDIT_DISPOSITION Â§2).

saksiPariksa :: (Bool, [String])
saksiPariksa = (ok, lns)
  where
    build w lhs rhs = samorderna "saksi.pariksa"
      (ganita "the pulverizer's own worked example, as an identity"
              "137Â(âˆ’7) + 60Â16" "gcd(137, 60)" w lhs rhs)
      [ ("mula", JInt lhs) ] [ "the occasion of the check" ]
      [ "ryabhaa, ryabhaya, Gaitapda 32â“33, 499 â” kuaka" ]
    satya  = build "137Â(âˆ’7) + 60Â16 = 1" (137 * (-7) + 60 * 16) 1
    asatya = build "137Â(âˆ’7) + 60Â16 = 2" (137 * (-7) + 60 * 16) 2
    tOk = case satya  of { Samorderna{} -> True; Dosalekha{} -> False }
    fOk = case asatya of { Dosalekha{}  -> True; Samorderna{} -> False }
    ok = tOk && fOk
    lns =
      [ "àà¾à•ààà¿-àà°àà•ààà¾ â” the witness check, watched, once in this process:"
      , "  satya   137Â(âˆ’7) + 60Â16 = 1  â’ " ++ uttaraKind satya
        ++ (if tOk then "   (transported, as it must)"
                   else "   !! TURNED BACK â” the check is destroying true transports")
      , "  asatya  137Â(âˆ’7) + 60Â16 = 2  â’ " ++ uttaraKind asatya
        ++ (if fOk then "   (a written defect, as it must)"
                   else "   !! TRANSPORTED â” this process is not checking anything")
      ] ++
      (if ok then
        [ "  no saordera from this process is honoured by a run that has not"
        , "  watched one rejected (GATE_AUDIT_DISPOSITION.md Â§2).  It has." ]
       else
        [ "  REFUSING TO SERVE.  An answer from a process whose own falsifier"
        , "  misbehaved is not weak evidence; it is no evidence (Â§19:"
        , "  àààà°à®à¾àà à¨ ààžàààà¯àà â” what is not a prama does not accumulate)." ])

-- | Run the falsifier and refuse to continue if it misbehaved.  Separated
--   from the report so that a caller who prints the lines and ignores the
--   verdict has to do so deliberately, in one more call, in the open.
saksiPariksaOrRefuse :: IO ()
saksiPariksaOrRefuse
  | fst saksiPariksa = pure ()
  | otherwise = do
      mapM_ (hPutStrLn stderr) saksiPariksaLines
      exitFailure

-- | The same, as lines to print.  Kept separate from the verdict so a caller
--   must handle both and cannot print the report while ignoring the answer.
saksiPariksaLines :: [String]
saksiPariksaLines = snd saksiPariksa

-- ------------------------------------------------------------ the wire

uttaraJ :: Uttara -> J
uttaraJ u@(Samorderna k t carried cost srcs) = JObj
  [ ("uttara", JStr (uttaraKind u))
  , ("kriya", JStr k)
  , ("tulyata", JObj [ ("nama", JStr (tuName t))
                     , ("vama", JStr (tuLeft t))
                     , ("daksina", JStr (tuRight t))
                     , ("saksin", JStr (tuWitness t))
                     -- Which KIND of witness, on the wire, in every answer:
                     -- `ganita` was computed in this process and compared
                     -- here; `likhita` is a sentence the handler's author
                     -- wrote and nothing checked.  A reader that cannot tell
                     -- the two apart has to believe both equally, which is
                     -- what doa 0022 costs.  Saying which is the whole of
                     -- Â§31 â” à¯à‹ à¨ àµà¦àà¿ à à¨ àààà¯àà¿.
                     , ("saksi-prakara", JStr (saksinPrakara (tuSaksin t))) ])
  , ("vahita", JObj carried)
  , ("vyaya", JArr (map JStr cost))
  , ("pramana", JArr (map JStr srcs))
  ]
uttaraJ u@(Dosalekha k hetu lost rest srcs) = JObj
  [ ("uttara", JStr (uttaraKind u))
  , ("kriya", JStr k)
  , ("hetu", JStr hetu)
  , ("nasta", JArr (map JStr lost))
  , ("residue", JArr (map JStr rest))
  , ("pramana", JArr (map JStr srcs))
  ]

-- | The same answer for a human reading the transcript.  Not a summary:
--   every field appears, because a summary of an answer about collapse
--   would be the collapse.
uttaraLines :: Uttara -> [String]
uttaraLines (Samorderna k t carried cost srcs) =
  [ "SAKRAMAA (" ++ k ++ ") â” transport; nothing lost."
  , "  along: " ++ tuName t
  , "    " ++ tuLeft t ++ "  â‰  " ++ tuRight t
  , "    witness (" ++ saksinPrakara (tuSaksin t) ++ "): " ++ tuWitness t
  , "  carried:" ] ++
  [ "    " ++ key ++ " = " ++ render v | (key, v) <- carried ] ++
  [ "  vyaya (what did not travel):" ] ++
  [ "    âˆ’ " ++ c | c <- cost ] ++
  srcLines srcs
uttaraLines (Dosalekha k hetu lost rest srcs) =
  [ "DOA-LEKHA (" ++ k ++ ") â” transport impossible; the defect is written."
  , "  hetu: " ++ hetu
  , "  naa (what a collapse here would destroy):" ] ++
  [ "    âˆ’ " ++ l | l <- lost ] ++
  (if null rest then [ "  ea: none handed forward." ]
                else "  ea (remainder, handed to the next step):"
                     : [ "    â’ " ++ r | r <- rest ]) ++
  srcLines srcs

srcLines :: [String] -> [String]
srcLines [] = []
srcLines ss = "  prama:" : [ "    " ++ s | s <- ss ]

-- | The plug point for the other lanes.  A verdict type built elsewhere
--   â” the saptabhag lane, the certificate lane, the scheduler â” becomes
--   speakable on this wire by giving one function, and the two-road
--   discipline is then enforced on it by the smart constructors above
--   rather than by review.
class Nivedaka a where
  nivedana :: String -> a -> Uttara
