-- Uttara_SamkramanaOrDosalekhaNeverABareBoolean — the shape of every
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

module Uttara_SamkramanaOrDosalekhaNeverABareBoolean
  ( Tulyata(..)
  , tulyata
  , Uttara(..)
  , samkramana
  , dosalekha
  , uttaraKind
  , uttaraJ
  , uttaraLines
  , Nivedaka(..)
  ) where

import Sabda_TheWireHasNoBoolean (J(..), render)

-- | The equivalence a transport moves along: two sides, named, and the
--   witness exhibiting that they may be identified.  `tuWitness` is the
--   place where an exact identity goes — `1766319049² − 61·226153980² = 1`
--   — never a similarity score, never a confidence.
data Tulyata = Tulyata
  { tuName    :: String   -- what the identification is called, in its own tradition
  , tuLeft    :: String   -- one side, as given
  , tuRight   :: String   -- the other side, as given
  , tuWitness :: String   -- the exhibited identity making them the same
  } deriving (Eq, Show)

tulyata :: String -> String -> String -> String -> Tulyata
tulyata = Tulyata

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

-- ------------------------------------------------------------ the wire

uttaraJ :: Uttara -> J
uttaraJ u@(Samkramana k t carried cost srcs) = JObj
  [ ("uttara", JStr (uttaraKind u))
  , ("kriya", JStr k)
  , ("tulyata", JObj [ ("nama", JStr (tuName t))
                     , ("vama", JStr (tuLeft t))
                     , ("daksina", JStr (tuRight t))
                     , ("saksin", JStr (tuWitness t)) ])
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
  , "    witness: " ++ tuWitness t
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
