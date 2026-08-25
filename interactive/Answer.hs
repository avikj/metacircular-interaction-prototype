-- Answer — the shape of every
-- answer this machine gives, with no third case.
--
-- THE SPECIFICATION, from notes/AHIMSA_SUTRA_VISTARA.md §6:
--
--     संक्रमणम् e = transport (ua e)     -- ua: तुल्यं तादात्म्यं भवितुम् अर्हति
--     संक्रमणे न किञ्चिन् नश्यति ।        -- in transport nothing is lost
--     अन्यो मार्गो दोषलेखः ।              -- the other road is the written defect
--     लिखितो दोषो जीवति । अलिखितो दोषो हिंसा ।
--     तृतीयो मार्गो न विद्यते ।           -- there is no third road
--
-- So `Uttara` has exactly two constructors and will not acquire a third.
-- A boolean answer is neither: it is a defect that was not written, which
-- the sūtra names hiṃsā and univalence explains — ∥A∥₁ admits no
-- retraction (§5), so the `which` a boolean drops is gone, not merely
-- unreported.
--
-- WHAT EACH CONSTRUCTOR IS OBLIGED TO CARRY, and these are enforced by
-- the smart constructors below rather than requested in prose, because
-- this repository's own finding is that a rule violated repeatedly needs
-- a mechanism that fires at the moment of the act (CLAUDE.md):
--
--   Samkramana must name the EQUIVALENCE it moved along.  transport
--   without `ua e` is not transport, it is assertion.  Voevodsky's point
--   is that the identification is a thing you hold, not a fact you cite;
--   so `tulyata` carries both sides and the witness that they agree.
--
--   Samkramana must also state its VYAYA.  §31: यत् सङ्क्रम्यते तत् किञ्चित्
--   त्यजति — what is transported gives something up; यो न वदति स न पश्यति
--   — whoever does not say it does not see it.  Structure travels; who
--   did it, for whom, and why does not.  A transport claiming zero cost
--   is downgraded, by the constructor, to a defect entry about itself.
--
--   Dosalekha must carry NAṢṬA item by item — the things that would have
--   been destroyed, named, not counted.  A count is the collapse again:
--   `3 items lost` is ∥·∥₁ of the losses.  An empty naṣṭa makes the
--   entry a defect about the report, since an unwritten defect is
--   precisely what §6 forbids.
--
--   Dosalekha carries ŚEṢA, the remainder, handed forward rather than
--   discarded.  §3: अवक्तव्ये शेषो वसति । शेषो गर्भः, न विफलता — the
--   remainder is a womb, not a failure; §17, the kuṭṭaka's rule: यत् न
--   विभजते तत् रक्ष्यते — what does not divide is kept, and it is the
--   material of the next step (Āryabhaṭa, Āryabhaṭīya, Gaṇitapāda 32–33,
--   499).  The remainder queue is the same discipline the Japanese
--   wasan tradition wrote as 遺題継承, unsolved problems posted at the
--   end of a book for the next author (Sawaguchi Kazuyuki 1670,
--   Seki Takakazu's 1674 answer).
--
-- NOT CLAIMED: that any source wrote this datatype.  What is taken is the
-- two-road structure and the obligation each road carries.

module Answer
  ( Saksin(..)
  , saksinPada
  , saksinPrakara
  , Tulyata(..)
  , tuWitness
  , tulyata
  , ganita
  , Uttara(..)
  , samkramana
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
-- DOṢA 0022, and it is the general form of six of the eight findings of
-- 2026-08-20.  `tuWitness` was one String.  `samkramana` refused a transport
-- whose witness was EMPTY and could not refuse one whose witness was FALSE,
-- because a String bears no relation to the objects named on either side
-- that any code here can examine.  Nothing in this lane had ever been
-- watched rejecting a tulyatā.  Three answers went out over one session
-- carrying witnesses that said the opposite of what had happened —
-- `no deduplication … the list you get back is the list you sent`, over a
-- list half of which had been destroyed (doṣa 0015); `stored verbatim: no
-- rewording`, over an entry that had been correctly reworded (0022); and one
-- that was never delivered at all because the encoder died mid-line (0017).
--
-- The intractable half is said rather than closed: a tulyatā between two
-- PROSE descriptions is a claim by whoever wrote the handler, and no type
-- makes it checkable.  What the type can do — and this is exactly the
-- distinction doṣa 0018 finds missing in `nasta`, two lanes and one missing
-- distinction — is stop the two from looking alike.  A witness is either
--
--   गणित  computed here, in this process, at the moment the answer was
--         built: two integers that the handler evaluated, which this module
--         COMPARES, and refuses the transport when they differ;
--
--   लिखित written by the author of the handler: a sentence, carried as a
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
  | l == r    = s ++ "  [गणित — computed in this process: " ++ show l
                  ++ " = " ++ show r ++ ", and checked here]"
  | otherwise = s ++ "  [गणित — computed in this process: " ++ show l
                  ++ " ≠ " ++ show r ++ ", AND IT DOES NOT HOLD]"

saksinPrakara :: Saksin -> String
saksinPrakara Ganita{}  = "ganita"
saksinPrakara Likhita{} = "likhita"

-- | The equivalence a transport moves along: two sides, named, and the
--   witness exhibiting that they may be identified.  `tuSaksin` is the
--   place where an exact identity goes — `1766319049² − 61·226153980² = 1`
--   — never a similarity score, never a confidence.
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
--   distinction — and every call site that keeps using it is now saying,
--   on the wire, that its witness was never checked.
tulyata :: String -> String -> String -> String -> Tulyata
tulyata n l r w = Tulyata n l r (Likhita w)

-- | A COMPUTED witness: the handler hands over the two integers it already
--   evaluated, and this module compares them.  Where a handler computes the
--   identity and then renders it into prose — which is what `kuttaka` and
--   `vargaprakrti` both did — the computation was already present and its
--   result was simply never compared to what it should be.
ganita :: String -> String -> String -> String -> Integer -> Integer -> Tulyata
ganita n l r w lhs rhs = Tulyata n l r (Ganita w lhs rhs)

-- | Two roads.  There is no third, and adding one is a change to the
--   specification, not to this file.
data Uttara
  = Samkramana
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
      , uSesa    :: [String]          -- the remainder, handed forward
      , uPramana :: [String]
      }
  deriving (Eq, Show)

uttaraKind :: Uttara -> String
uttaraKind Samkramana{} = "samkramana"
uttaraKind Dosalekha{}  = "dosalekha"

-- | Build a transport, or refuse to and say why.  The refusal is itself a
--   written defect, so this function is total in the sūtra's sense: it
--   never returns a third thing and never returns silence.
samkramana :: String -> Tulyata -> [(String, J)] -> [String] -> [String] -> Uttara
samkramana k t carried cost srcs
  -- THE ONE REFUSAL THIS FILE DID NOT HAVE.  A computed witness whose two
  -- sides differ is a transport along an equivalence that does not exist,
  -- and it takes the second road (§6) rather than going out with a false
  -- sākṣin.  Uncheckable witnesses are still uncheckable; this is the
  -- fragment where the check is available, and it was available all along.
  | Ganita w lhs rhs <- tuSaksin t, lhs /= rhs =
      raw k ("a transport was claimed for `" ++ k ++ "` along an identity "
             ++ "that does not hold: " ++ w ++ " — the two sides computed to "
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
            , "AHIMSA_SUTRA_VISTARA §31: यो न वदति स न पश्यति" ]
            [ "state what does not travel: who did it, for whom, on what occasion" ]
            srcs
  | otherwise = Samkramana k t carried cost srcs

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
              ++ "than named; a count is ∥·∥₁ of the list it replaces" ]
            rest srcs
  | otherwise = Dosalekha k hetu lost rest srcs

-- The unvalidated constructor, used only by the validators above so that
-- the regress stops at depth one.
raw :: String -> String -> [String] -> [String] -> [String] -> Uttara
raw = Dosalekha

-- ------------------------------------------------- the watched rejection
--
-- interactive/GATE_AUDIT_DISPOSITION.md §2 states the discipline this lane had
-- the words for and not the mechanism: *no acceptance is honoured by a
-- process that has not watched its kernel reject a falsehood.*  There, 1753
-- systematically false equations produced zero certificates while three
-- shell wrappers produced certificates for `s(x) = x` — a checker sound
-- against mathematics and unsound against its environment.  Here the failure
-- was one level cheaper: there was no falsifier at all, and `selftest` drove
-- 25 utterances checking only that the witness field was NON-EMPTY.
--
-- So the constructor above now faces a falsifier of its own, run once per
-- process, before any answer is served:
--
--   satya  — 137·(−7) + 60·16 = 1, Āryabhaṭa's own worked kuṭṭaka
--            (Āryabhaṭīya, Gaṇitapāda 32–33, 499).  MUST transport.
--   asatya — the same identity with one side moved by one.  MUST NOT.
--
-- Both go through the very `samkramana` every handler goes through.  If the
-- false one transports, this process is not checking anything and nothing it
-- says may be read as a transport; it refuses to serve rather than serve
-- answers nobody has grounds to believe.  If the true one is refused, the
-- check is over-firing and honest transports are being destroyed, which is
-- the 2026-08-15 fault in the other lane and is equally disqualifying.
--
-- Not cached, and it cannot be: it is two constructor calls.  A cached
-- canary is a canary the adversary can answer (GATE_AUDIT_DISPOSITION §2).

saksiPariksa :: (Bool, [String])
saksiPariksa = (ok, lns)
  where
    build w lhs rhs = samkramana "saksi.pariksa"
      (ganita "the pulverizer's own worked example, as an identity"
              "137·(−7) + 60·16" "gcd(137, 60)" w lhs rhs)
      [ ("mula", JInt lhs) ] [ "the occasion of the check" ]
      [ "Āryabhaṭa, Āryabhaṭīya, Gaṇitapāda 32–33, 499 — kuṭṭaka" ]
    satya  = build "137·(−7) + 60·16 = 1" (137 * (-7) + 60 * 16) 1
    asatya = build "137·(−7) + 60·16 = 2" (137 * (-7) + 60 * 16) 2
    tOk = case satya  of { Samkramana{} -> True; Dosalekha{} -> False }
    fOk = case asatya of { Dosalekha{}  -> True; Samkramana{} -> False }
    ok = tOk && fOk
    lns =
      [ "साक्षि-परीक्षा — the witness check, watched, once in this process:"
      , "  satya   137·(−7) + 60·16 = 1  → " ++ uttaraKind satya
        ++ (if tOk then "   (transported, as it must)"
                   else "   !! REFUSED — the check is destroying true transports")
      , "  asatya  137·(−7) + 60·16 = 2  → " ++ uttaraKind asatya
        ++ (if fOk then "   (refused, as it must)"
                   else "   !! TRANSPORTED — this process is not checking anything")
      ] ++
      (if ok then
        [ "  no saṃkramaṇa from this process is honoured by a run that has not"
        , "  watched one rejected (GATE_AUDIT_DISPOSITION.md §2).  It has." ]
       else
        [ "  REFUSING TO SERVE.  An answer from a process whose own falsifier"
        , "  misbehaved is not weak evidence; it is no evidence (§19:"
        , "  अप्रमाणं न सञ्चीयते — what is not a pramāṇa does not accumulate)." ])

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
uttaraJ u@(Samkramana k t carried cost srcs) = JObj
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
                     -- what doṣa 0022 costs.  Saying which is the whole of
                     -- §31 — यो न वदति स न पश्यति.
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
  , ("sesa", JArr (map JStr rest))
  , ("pramana", JArr (map JStr srcs))
  ]

-- | The same answer for a human reading the transcript.  Not a summary:
--   every field appears, because a summary of an answer about collapse
--   would be the collapse.
uttaraLines :: Uttara -> [String]
uttaraLines (Samkramana k t carried cost srcs) =
  [ "SAṂKRAMAṆA (" ++ k ++ ") — transport; nothing lost."
  , "  along: " ++ tuName t
  , "    " ++ tuLeft t ++ "  ≃  " ++ tuRight t
  , "    witness (" ++ saksinPrakara (tuSaksin t) ++ "): " ++ tuWitness t
  , "  carried:" ] ++
  [ "    " ++ key ++ " = " ++ render v | (key, v) <- carried ] ++
  [ "  vyaya (what did not travel):" ] ++
  [ "    − " ++ c | c <- cost ] ++
  srcLines srcs
uttaraLines (Dosalekha k hetu lost rest srcs) =
  [ "DOṢA-LEKHA (" ++ k ++ ") — transport impossible; the defect is written."
  , "  hetu: " ++ hetu
  , "  naṣṭa (what a collapse here would destroy):" ] ++
  [ "    − " ++ l | l <- lost ] ++
  (if null rest then [ "  śeṣa: none handed forward." ]
                else "  śeṣa (remainder, handed to the next step):"
                     : [ "    → " ++ r | r <- rest ]) ++
  srcLines srcs

srcLines :: [String] -> [String]
srcLines [] = []
srcLines ss = "  pramāṇa:" : [ "    " ++ s | s <- ss ]

-- | The plug point for the other lanes.  A verdict type built elsewhere
--   — the saptabhaṅgī lane, the certificate lane, the scheduler — becomes
--   speakable on this wire by giving one function, and the two-road
--   discipline is then enforced on it by the smart constructors above
--   rather than by review.
class Nivedaka a where
  nivedana :: String -> a -> Uttara
