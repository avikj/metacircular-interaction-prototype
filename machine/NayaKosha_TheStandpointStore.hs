-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- NayaKosha_TheStandpointStore -- नयकोश, a live store of standpoints.
--
-- WHAT THIS IS.  `machine/Naya.hs` DECIDES, on a fragment, whether a set
-- of standpoints may be collapsed into one verdict, and prints what the
-- collapse would destroy.  A decision procedure is not a memory: it takes
-- its input from a call site, answers once, and forgets.  This is the
-- memory.  Standpoints are held many at once, indexed, each with its
-- witnesses and the provenance of each witness; the store is an
-- append-only journal on disk, so it survives a session and replays
-- byte-for-byte; every insertion returns every relation the new entry has
-- to what is already held, and NOTHING IS EVER MERGED.
--
-- ────────────────────────────────────────────────────────────────────
-- THE INDEX, which is the whole question.
--
-- Two standpoints that agree in CONTENT and two that agree merely in
-- TRUTH VALUE are different cases, and a store that keys on one of them
-- has already committed the collapse it exists to prevent.  This is not
-- an opinion about tidiness; it is
-- `formal/cubical/NaturalMachine/Durnaya_CollapseIffEveryNayaAgrees.agda`,
-- which proves that a standpoint index may be dropped exactly when every
-- pair of fibres is EQUIVALENT, and exhibits `Mixed : Bool → Type` with
-- fibres `Unit` and `Bool` — both inhabited, so equal in truth value,
-- inequivalent, so not collapsible.  Truth-equality is strictly weaker
-- than content-equality and reading the first as the second is durnaya.
--
-- Doing the work turned up a THIRD level that `Naya.hs` collapses in
-- silence.  Its `content` is `sort . nub . witnesses`, a set of witness
-- LABELS; the document a label came from is nowhere in the type.  So two
-- standpoints that cite the same fact from independent sources are
-- reported by `Naya.hs` as one thing said twice.  They are not.  The
-- independence of the attestations is the content of the case, and
-- discarding it is the same act one level down.  Hence three indices,
-- each strictly refining the last:
--
--     सत्य  satya  — inhabited or not.  Coarsest.
--     अर्थ  artha  — the set of witness labels.
--     मूल   mūla   — the set of (label, source) pairs.  Finest held here.
--
-- A family may agree at satya and differ at artha (durnaya: the Unit/Bool
-- case, one verdict discards the difference).  A family may agree at
-- artha and differ at mūla (two independent attestations of one fact:
-- their CONTENT collapses, their RECORD does not, and saying so in one
-- sentence is the seventh bhaṅga).  The store reports the highest level
-- at which the family agrees, never a bare yes/no.
--
-- ────────────────────────────────────────────────────────────────────
-- THE FRAGMENT, WIDENED, AND WHERE IT COULD NOT BE.
--
-- `Naya.hs` states its fragment honestly and returns `Abhinna` outside
-- it.  Four widenings are made here, each of them a case that module
-- refused and this one decides:
--
--  1. YOGYATĀ IS NOW AN INPUT, AND ITS ABSENCE IS NOT A DENIAL.
--     `Naya.hs` computes truth as `not . null . witnesses`, so an empty
--     witness list is read as nāsti.  Its own header cites Kumārila
--     (Ślokavārttika, Abhāvapariccheda, c. 7th c.) for yogya-anupalabdhi
--     — "not seen" is not a pramāṇa, "not seen WHERE IT WOULD BE SEEN"
--     is — and then the code does the thing the citation forbids.  Here
--     each entry carries the fitness of the looking that produced its
--     witnesses.  Empty under `Yogya` is a denial.  Empty under `Ayogya`
--     is silence, and silence gets NO truth value at all, so the entry
--     is residue rather than a nāsti.  (Reading silence as denial is
--     named as the durnaya in `machine/Obstruction.hs` under THE
--     SEVENFOLD POSITIONS.  Both modules are this repository's; the bug
--     and the warning against it were live at the same time.)
--
--  2. UNFITNESS IS NOW LOCAL.  One malformed standpoint used to void the
--     whole verdict.  Here the unfit entries are listed by name as
--     residue and the fit remainder is decided, which is the difference
--     between "I cannot see" and "there was nothing to see".
--
--  3. PARTIAL AGREEMENT IS NOW REPORTED AS A PARTITION.  With three or
--     more standpoints of which some agree, `Naya.hs` returns one flat
--     `Durnaya`.  By Durnaya_CollapseIffEveryNayaAgrees, collapse of a
--     family exists iff its members agree PAIRWISE; agreement at a fixed
--     index is an equivalence relation; so the maximal collapsible
--     sub-families are exactly its classes, and the store computes them.
--     What is unavailable is the collapse of the whole, and the classes
--     say precisely how much of it is available.
--
--  4. ONE-SIDED DIFFERENCE IS NAMED.  When one standpoint's content is
--     properly contained in another's, `Naya.hs` computes the (empty)
--     loss on one side and prints nothing for it, so the reader cannot
--     tell containment from crosswise disagreement.  Here the two are
--     different renderings.
--
-- WRITTEN DEFECTS.  Each is a collapse this store performs and cannot
-- avoid.  An unwritten one would be hiṃsā; these are written, which is
-- the second of the two paths and not the third that does not exist.
--
--  D1. LABEL EQUALITY IS STRING EQUALITY.  Two witness labels naming the
--      same document in different words are held as two; one label
--      covering two documents is held as one.  Deciding otherwise is
--      deciding synonymy, which is not decidable and is exactly what
--      `formal/cubical/ApohaParyaya_…` says the two schools DISPUTE
--      rather than share.  The store therefore does not attempt it, and
--      the cost is that mūla-agreement is sufficient for identity of
--      record but not necessary.
--
--  D2. MULTIPLICITY AND ORDER ARE DISCARDED at artha and mūla (`sort .
--      nub`).  A standpoint that cites a document twice and one that
--      cites it once are content-identical here.  Kept because a
--      standpoint's content is a set in the doctrine's own usage; noted
--      because it is nonetheless a quotient, and a family that differs
--      only in multiplicity will be told it agrees.
--
--  D3. NO VERDICT WHERE CONTENT IS NOT FINITELY ENUMERABLE.  Inherited
--      unchanged from `Naya.hs`.  A standpoint given by a rule rather
--      than a list is outside this store; type equality is undecidable
--      and no amount of journal format changes that.
--
--  D4. A DENIAL HAS NO WITNESSES, so two fit denials are indexed
--      identically no matter what they deny.  The store refuses the case
--      (`decide` returns Abhinna when every fit standpoint is a denial)
--      rather than reporting the vacuous agreement as agreement.  What
--      would fix it is an index on the PROPOSITION denied, which this
--      store does not have, because it holds witnesses and a proposition
--      is not one.  Stated, not repaired.
--
--  D5. THE JOURNAL IS TOTALLY ORDERED, and the entries in it are not.
--      Reading the file back gives ids in insertion order, which is a
--      fact about who ran the machine when and about nothing else.  No
--      code here may use id order as evidence, and none does.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT COLLAPSED, stated because it is the point.
--
--   * अवक्तव्य and अभिन्न are kept apart.  Avaktavyam is the positive
--     fourth bhaṅga: the joint content is perfectly determinate and no
--     single utterance carries it (Akalaṅka, Laghīyastraya c. 720–780,
--     kramārpaṇa against sahārpaṇa).  Abhinna is the refusal of a
--     looking that was not fit to decide.  Both say "no single
--     sentence"; they say it for opposite reasons, and a type with one
--     constructor for the pair would destroy which.
--   * A duplicate insertion is STORED, with a pointer to what it
--     duplicates.  Deduplicating is the cheapest possible saṃkṣepa and
--     it is exactly what a store is normally built to do.
--
-- SOURCES.  Umāsvāti, Tattvārthasūtra (c. 2nd–5th c. CE) 5.31
-- arpitānarpitasiddheḥ — the standpoint index, stated as an index.
-- Siddhasena Divākara, Sanmatitarka (c. 5th c. CE) 1.21 — a naya taken
-- without regard to the others is the durnaya.  Samantabhadra,
-- Āptamīmāṃsā (c. 6th c. CE) — the seven members.  Akalaṅka,
-- Laghīyastraya (c. 720–780 CE) — krama against saha, and the argument
-- that the number is exactly seven.  Kumārila Bhaṭṭa, Ślokavārttika,
-- Abhāvapariccheda (c. 7th c. CE) — yogya-anupalabdhi.  NOT CLAIMED:
-- that any of them wrote a store, an index, or a decision procedure.
-- What is taken is the classification and the rule for which case is
-- which.
--
-- The `Bhanga` and `Sthana` types are NOT redefined here.  They are
-- another hand's work in `machine/Obstruction.hs` and are imported.

module NayaKosha_TheStandpointStore where

import Data.List (sort, nub, sortOn, intercalate, partition, groupBy, isPrefixOf)
import Data.Function (on)
import Obstruction (Bhanga(..), Sthana(..))

-- ─────────────────────────────────────────────────────────── the entry

-- | साक्षिन् — a witness: what it says, and the document it says it from.
--   The source is carried, never folded into the label (see D1).
data Sakshin = Sakshin { sakLabel :: String, sakSource :: String }
  deriving (Eq, Ord, Show)

-- | योग्यता — the fitness of the looking that produced this entry's
--   witnesses.  Kumārila's condition, as an input rather than an
--   assumption.  The String is the reason, and it is required: a fitness
--   claim with no account of the search is itself unfit.
data Yogyata = Yogya String | Ayogya String
  deriving (Eq, Ord, Show)

type EntryId = Int

-- | A held standpoint.  `entMula` is where the ENTRY came from (who
--   recorded it, when, out of what) as distinct from where its witnesses
--   came from.
data Entry = Entry
  { entId       :: EntryId
  , entName     :: String
  , entYogyata  :: Yogyata
  , entRecorder :: String
  , entWhen     :: String
  , entWitness  :: [Sakshin]
  } deriving (Eq, Show)

-- ───────────────────────────────────────────────── the three indices

-- | सत्य — inhabited or not.  `Nothing` is SILENCE, not denial: no
--   witnesses and no fit looking gives no truth value.  This is widening 1.
--
--   KUMĀRILA'S CONDITION IS ON THE LOOKING, NOT ON WHAT THE LOOKING BROUGHT
--   BACK.  Until doṣa 0021 this function read `entYogyata` only in the branch
--   where the witness list was EMPTY, so the fitness guarded absence and never
--   presence: an entry declaring `Ayogya "I did not look at all; these are
--   invented"` but carrying witnesses returned `Just True` and went into `fit`
--   unremarked.  Two entries with identical witnesses, one from an exhaustive
--   search and one invented, came back Position B1Asti, MulaSama, with both
--   loss lists empty and the sentence "IDENTIFIABLE, at every index this store
--   holds" — the invented standpoint identified with the searched one at the
--   strongest level available, and the string saying it was invented appearing
--   nowhere in the answer.  The module's own widening 1 says each entry carries
--   the fitness of the looking that produced its witnesses; it carried it and
--   did not read it.
--
--   An unfit looking with witnesses is a genuine third case, and it is
--   neither a Just True nor a Just False.  It is SILENCE, for the same
--   reason the empty case is: यत्र दृश्येत तत्र न दृष्टम् — the pramāṇa is
--   the fitness of the looking, and a looking declared unfit says nothing
--   about the object whatever it came back holding.  So the entry lands in
--   `nirShesha` with its stated reason, which is machinery this module had
--   already built for the empty case and was applying to only half of it.
satya :: Entry -> Maybe Bool
satya e
  | Ayogya _ <- entYogyata e  = Nothing
  | not (null (entWitness e)) = Just True
  | otherwise                 = Just False

-- | अर्थ — the content: the set of witness labels.  (D2: a set.)
artha :: Entry -> [String]
artha = sort . nub . map sakLabel . entWitness

-- | मूल — the record: the set of (label, source) pairs.  Strictly finer
--   than artha, and the level `Naya.hs` has no name for.
mula :: Entry -> [(String, String)]
mula = sort . nub . map (\s -> (sakLabel s, sakSource s)) . entWitness

-- | The levels, ordered coarsest to finest.
data Samata = SatyaSama | ArthaSama | MulaSama
  deriving (Eq, Ord, Show)

samataName :: Samata -> String
samataName SatyaSama = "satya (truth value only)"
samataName ArthaSama = "artha (content: the same witness labels)"
samataName MulaSama  = "mula (record: the same labels FROM THE SAME SOURCES)"

-- ─────────────────────────────────────────────────────────── the store

-- | The store.  Append-only; `koshaNext` is the next id.  There is no
--   delete and no update: a correction is a new entry plus a relation.
data Kosha = Kosha { koshaEntries :: [Entry], koshaNext :: EntryId }
  deriving (Eq, Show)

empty :: Kosha
empty = Kosha [] 0

-- | सम्बन्ध — every relation a new entry bears to what is already held.
--   Returned in full at every insertion.  None of them causes a merge.
data Sambandha
  = Nutana                              -- नूतन: related to nothing held
  | Punarukta   EntryId                 -- पुनरुक्त: identical record; STORED anyway
  | Namasankara EntryId                 -- नामसङ्कर: same NAME, different content
  | Arthaikya   EntryId                 -- अर्थैक्य: different name, same content,
                                        --   DIFFERENT sources -- independent attestation
  | Satyaikya   [EntryId]               -- सत्यैक्य: same truth value, different content
  deriving (Eq, Ord, Show)

sambandhaGloss :: Sambandha -> String
sambandhaGloss Nutana = "nutana: nothing held stands in any relation to it"
sambandhaGloss (Punarukta i) =
  "punarukta: same name, same content, same sources as #" ++ show i
  ++ " -- STORED ANYWAY, because deduplicating is the cheapest samksepa"
sambandhaGloss (Namasankara i) =
  "namasankara: shares the NAME of #" ++ show i ++ " and not its content"
  ++ " -- the name is not the index and this is why"
sambandhaGloss (Arthaikya i) =
  "arthaikya: same content as #" ++ show i ++ " from DIFFERENT sources"
  ++ " -- independent attestation; collapsing the record destroys the independence"
sambandhaGloss (Satyaikya is) =
  "satyaikya: agrees in TRUTH VALUE ONLY with " ++ show (length is) ++ " held entr"
  ++ (if length is == 1 then "y (" else "ies (")
  ++ intercalate ", " (map (('#':) . show) is) ++ ")"
  ++ " -- reported as a COUNT because truth-value agreement is nearly"
  ++ " universal and therefore nearly contentless.  That is the whole"
  ++ " reason it is not the index."

-- | Insert.  Returns the id given, every relation found, and the new
--   store.  It cannot return anything else: there is no code path here
--   that drops, overwrites or unifies an entry.
insert :: Entry -> Kosha -> (EntryId, [Sambandha], Kosha)
insert e k = (i, rels, Kosha (koshaEntries k ++ [e2]) (i + 1))
  where
    i  = koshaNext k
    e2 = e { entId = i }
    rels = case concatMap rel (koshaEntries k) ++ satyaikya of
             [] -> [Nutana]
             rs -> rs
    -- Aggregated, not one per pair: see the gloss.
    satyaikya = case [ entId o | o <- koshaEntries k
                     , artha o /= artha e2, satya o == satya e2
                     , satya o /= Nothing ] of
                  [] -> []
                  is -> [Satyaikya is]
    -- Independently, not as a first-match chain.  A chain would report one
    -- relation and suppress the rest, which is the same act one level down.
    rel o = concat
      [ [ Punarukta   (entId o) | entName o == entName e2, mula  o == mula  e2 ]
      , [ Namasankara (entId o) | entName o == entName e2, artha o /= artha e2 ]
      , [ Arthaikya   (entId o) | artha o == artha e2, not (null (artha e2))
                               , mula o /= mula e2 ] ]

byId :: Kosha -> EntryId -> Maybe Entry
byId k i = case [ e | e <- koshaEntries k, entId e == i ] of
             (e:_) -> Just e
             []    -> Nothing

-- | Name lookup returns a LIST.  A store whose name lookup returns one
--   entry has decided that a name is an index, which is the collapse.
byName :: Kosha -> String -> [Entry]
byName k n = [ e | e <- koshaEntries k, entName e == n ]

-- ────────────────────────────────────────────────────────── the verdict

-- | The answer to "may these be identified?"  Not a Bool, and not a bare
--   Sthana either: the loss and the residue are part of the answer.
data Nirnaya
  = Nirnaya
      { nirSthana  :: Sthana              -- the sevenfold position (Obstruction)
      , nirSamata  :: Maybe Samata        -- highest level of agreement, if any
      , nirVarga   :: [[EntryId]]         -- maximal collapsible sub-families
      , nirNashti  :: [(String, [String])]-- per standpoint, what a collapse destroys
      , nirMulaLoss:: [(String, [String])]-- sources a content-collapse discards
      , nirShesha  :: [(String, String)]  -- residue: entries no looking was fit for
      , nirVakya   :: [String]            -- what is being said, in words
      }
  | Abhinna String                        -- no verdict; the looking was unfit
  deriving (Eq, Show)

-- | THE DECISION.  `saha` = the standpoints are being asserted
--   simultaneously (Akalaṅka's sahārpaṇa); False = in succession (krama).
decide :: Bool -> [Entry] -> Nirnaya
decide saha es0
  | any (any null . map sakLabel . entWitness) es0 =
      Abhinna "a standpoint carries an empty witness label: nothing to compare"
  -- D4.  Every fit standpoint here is a DENIAL, and a denial's content is
  -- empty.  Empty content is not shared content: this store indexes by
  -- witnesses, so it cannot tell a fit denial of one thing from a fit
  -- denial of another, and reporting them as agreeing would be a YES
  -- manufactured out of the absence of the very thing it indexes by.
  -- Refused, and the refusal is Abhinna, not a bhanga.
  | length fit >= 2 && all (null . artha) fit =
      Abhinna ("all " ++ show (length fit) ++ " standpoints the looking was fit \
               \for are DENIALS, and this store indexes by witnesses, which a \
               \denial has none of; two denials of different things are \
               \indistinguishable here (defect D4).  Their agreement would be \
               \vacuous and is not reported as agreement.")
  | length fit < 2 =
      Abhinna ("fewer than two standpoints the looking was fit for ("
               ++ show (length fit) ++ " of " ++ show (length es0)
               ++ "); an unfit looking's silence is not a NO"
               ++ " (Kumarila, Abhavapariccheda)")
  | otherwise = Nirnaya
      { nirSthana   = position
      , nirSamata   = lvl
      , nirVarga    = classes
      , nirNashti   = losses
      , nirMulaLoss = mulaLosses
      , nirShesha   = shesha
      , nirVakya    = vakya
      }
  where
    (unfit, fit) = partition ((== Nothing) . satya) es0
    -- Positional identity, NOT entId.  `decide` is total on any list,
    -- including one whose entries have never been inserted and so all
    -- carry id 0; comparing by entId there would silently report no loss
    -- at all, which is the one failure mode this module exists to prevent.
    ixfit = zip [(0::Int) ..] fit
    -- The residue now has two populations and they are not the same fact, so
    -- the report says which.  An entry with no witnesses and no fit looking
    -- brought nothing back.  An entry whose looking was declared UNFIT and
    -- which nevertheless came back holding witnesses brought something back
    -- and it is not read as truth -- the witnesses are held, named here in
    -- full rather than counted away, and available to whoever refits the
    -- looking.  Silently treating them as truth is doṣa 0021.
    shesha = [ (entName e, reasonOf (entYogyata e) ++ carriedNote e) | e <- unfit ]
    reasonOf (Ayogya r) = r
    reasonOf (Yogya  r) = r
    carriedNote e
      | null (entWitness e) = " -- and it came back empty"
      | otherwise =
          " -- AND IT CAME BACK HOLDING WITNESSES, which are kept and are NOT"
          ++ " read as truth, because the fitness condition is on the LOOKING"
          ++ " and not on what the looking returned (Kumarila, Slokavarttika,"
          ++ " Abhavapariccheda): "
          ++ intercalate "; " [ sakLabel w ++ " <" ++ sakSource w ++ ">"
                              | w <- entWitness e ]

    truths   = nub (map satya fit)
    mixedTruth = length truths > 1

    lvl | all ((== mula  (head fit)) . mula ) fit = Just MulaSama
        | all ((== artha (head fit)) . artha) fit = Just ArthaSama
        | not mixedTruth                          = Just SatyaSama
        | otherwise                               = Nothing

    -- widening 3: maximal collapsible sub-families are the artha-classes,
    -- because collapse exists iff every PAIR agrees and agreement at a
    -- fixed index is an equivalence relation.
    classes = map (map entId)
            . groupBy ((==) `on` artha)
            . sortOn artha $ fit

    -- what collapsing to some OTHER standpoint throws away from each
    losses = [ (nameId e, ws)
             | (j, e) <- sortOn (entName . snd) ixfit
             , let ws = [ w | w <- artha e
                            , any (\(j2, o) -> j2 /= j
                                            && w `notElem` artha o) ixfit ]
             , not (null ws) ]

    -- at artha-agreement, this is the whole of the difference
    mulaLosses
      | lvl == Just ArthaSama =
          [ (nameId e, ss)
          | (j, e) <- sortOn (entName . snd) ixfit
          , let ss = [ src | (_, src) <- mula e
                           , any (\(j2, o) -> j2 /= j
                                           && src `notElem` map snd (mula o)) ixfit ]
          , not (null ss) ]
      | otherwise = []

    -- A name is not an index, so the loss report carries the id too:
    -- two entries with one name must be distinguishable in the exhibit.
    nameId e = entName e ++ " (#" ++ show (entId e) ++ ")"

    -- widening 4: containment is not crosswise disagreement
    contained = [ (entName a, entName b)
                | (ja, a) <- ixfit, (jb, b) <- ixfit, ja /= jb
                , all (`elem` artha b) (artha a), artha a /= artha b ]

    someAgree = any ((> 1) . length) classes
    allAgree  = length classes == 1

    -- The dharma predicated: "these standpoints are identifiable as one."
    -- asti  -- some sub-family collapses.  nasti -- some pair does not.
    -- avaktavya -- a single utterance is being demanded of a family that
    -- has two answers at two indices, or of a family in saha.
    position = Position bhanga
    bhanga = case lvl of
      Just MulaSama  -> B1Asti
      Just ArthaSama -> if saha then B7AstiNastiAvaktavya else B3AstiNasti
      Just SatyaSama -> if saha
                          then (if someAgree then B7AstiNastiAvaktavya else B4Avaktavya)
                          else (if someAgree then B3AstiNasti else B2Nasti)
      Nothing        -> if saha then B4Avaktavya else B3AstiNasti

    vakya = case lvl of
      Just MulaSama ->
        [ "IDENTIFIABLE, at every index this store holds."
        , "Same labels, same sources.  Holding both said one thing twice." ]
      Just ArthaSama ->
        [ "IDENTIFIABLE AS CONTENT, NOT AS RECORD."
        , "The witness labels are the same set; the sources are not."
        , "These are independent attestations of one content.  A collapse"
        , "keeps what is said and destroys that it was said twice, from two"
        , "places -- which is the entire evidential weight of the pair."
        ] ++ (if saha
                then [ "Asserted at once (saha), one sentence is being asked to carry"
                     , "both 'one content' and 'two records'.  It cannot: seventh bhanga." ]
                else [ "In succession (krama), both are sayable, in that order:"
                     , "as content one, as record two." ])
      Just SatyaSama ->
        [ "NOT IDENTIFIABLE.  They agree in TRUTH VALUE and differ in CONTENT."
        , "This is Durnaya_CollapseIffEveryNayaAgrees exactly: collapse is"
        , "available iff every pair of fibres is equivalent, and `Mixed` with"
        , "fibres Unit and Bool is the checked witness that both-inhabited is"
        , "not enough.  Any single verdict here discards the difference below."
        ] ++ (if someAgree && not allAgree
                then [ "Not uniformly, though: the sub-families listed as varga DO"
                     , "collapse.  What does not exist is the collapse of the whole." ]
                else [])
          ++ [ "One-sided: " ++ a ++ " is contained in " ++ b
                 ++ ", so the loss is entirely on " ++ b ++ "'s side."
             | (a, b) <- contained ]
      Nothing ->
        [ "NOT IDENTIFIABLE.  Some standpoint affirms and some denies."
        ] ++ (if saha
                then [ "Asserted SIMULTANEOUSLY (saha): no single utterance carries it."
                     , "This is the FOURTH bhanga and it is positive.  The joint"
                     , "content is determinate; what fails is the single sentence."
                     , "It is NOT this store saying it cannot see -- that is Abhinna,"
                     , "a different answer, kept in a different constructor." ]
                else [ "In succession (krama) they are assertable, in that order."
                     , "Akalanka's kramarpana." ])

-- ──────────────────────────────────────────────────────────── rendering

render :: Nirnaya -> [String]
render (Abhinna msg) =
  [ "  NO VERDICT ISSUED (abhinna)."
  , "  " ++ msg
  , "  An unfit looking's silence is not a NO, and this answer is NOT the"
  , "  fourth bhanga.  Avaktavyam is positive; this is a refusal." ]
render n =
  [ "  bhanga : " ++ show (nirSthana n)
  , "  samata : " ++ maybe "none -- not even truth-equal" samataName (nirSamata n)
  ] ++ map ("  " ++) (nirVakya n)
    ++ (if length (nirVarga n) > 1 || any ((>1) . length) (nirVarga n)
          then [ "", "  maximal collapsible sub-families (varga), by content:" ]
               ++ [ "      { " ++ intercalate ", " (map (('#':) . show) c) ++ " }"
                  | c <- nirVarga n ]
          else [])
    ++ (if null (nirNashti n) then [] else
          [ "", "  WHAT A SINGLE VERDICT WOULD DESTROY:" ] ++
          concat [ [ "    from `" ++ nm ++ "`, " ++ show (length ws) ++ ":" ]
                   ++ [ "        - " ++ w | w <- ws ]
                 | (nm, ws) <- nirNashti n ])
    ++ (if null (nirMulaLoss n) then [] else
          [ "", "  WHAT A CONTENT-COLLAPSE WOULD DESTROY (the sources, not the content):" ] ++
          concat [ [ "    from `" ++ nm ++ "`, " ++ show (length ss) ++ ":" ]
                   ++ [ "        - " ++ s | s <- ss ]
                 | (nm, ss) <- nirMulaLoss n ])
    ++ (if null (nirShesha n) then [] else
          [ "", "  RESIDUE -- held, undecided, not denied:" ] ++
          [ "    `" ++ nm ++ "`: no witnesses, and the looking was not fit -- "
            ++ r | (nm, r) <- nirShesha n ])

-- ─────────────────────────────────────────────────── persistence

-- The journal is line-oriented and every field is escaped, so a witness
-- label containing a separator survives the round trip.  `replay` of
-- `journal` is the identity on the store; `prop_roundtrip` checks it.

esc :: String -> String
esc = concatMap f
  where f '\\' = "\\\\"
        f '\t' = "\\t"
        f '\n' = "\\n"
        f ';'  = "\\s"
        f '='  = "\\e"
        f c    = [c]

unesc :: String -> String
unesc [] = []
unesc ('\\':c:cs) = d c : unesc cs
  where d '\\' = '\\'; d 't' = '\t'; d 'n' = '\n'
        d 's'  = ';';  d 'e' = '=';  d x   = x
unesc (c:cs) = c : unesc cs

splitOn :: Char -> String -> [String]
splitOn c s = case break (== c) s of
  (a, [])     -> [a]
  (a, _:rest) -> a : splitOn c rest

-- | One entry, one line.  Deterministic: the same store always writes the
--   same bytes, which is what makes a transcript replayable.
lineOf :: Entry -> String
lineOf e = intercalate "\t"
  [ "NAYA"
  , show (entId e)
  , esc (entName e)
  , case entYogyata e of
      Yogya  r -> "yogya:"  ++ esc r
      Ayogya r -> "ayogya:" ++ esc r
  , esc (entRecorder e)
  , esc (entWhen e)
  , intercalate ";" [ esc (sakLabel w) ++ "=" ++ esc (sakSource w)
                    | w <- entWitness e ]
  ]

parseLine :: String -> Either String Entry
parseLine ln = case splitOn '\t' ln of
  ["NAYA", i, nm, y, rec, wh, ws] -> do
    y' <- parseYogyata y
    pure Entry { entId = read i, entName = unesc nm, entYogyata = y'
               , entRecorder = unesc rec, entWhen = unesc wh
               , entWitness = parseWits ws }
  _ -> Left ("malformed journal line: " ++ take 120 ln)
  where
    parseYogyata s
      | "yogya:"  `isPrefixOf` s = Right (Yogya  (unesc (drop 6 s)))
      | "ayogya:" `isPrefixOf` s = Right (Ayogya (unesc (drop 7 s)))
      | otherwise = Left ("unknown yogyata field: " ++ s)
    parseWits "" = []
    parseWits s  = [ case break (== '=') w of
                       (a, '=':b) -> Sakshin (unesc a) (unesc b)
                       (a, _)     -> Sakshin (unesc a) ""
                   | w <- splitOn ';' s ]

journal :: Kosha -> [String]
journal = map lineOf . koshaEntries

-- | Replay.  Journal lines that are not entries (questions, verdicts,
--   comments) are skipped, so the same file can carry the transcript.
replay :: [String] -> Either String Kosha
replay lns = do
  es <- mapM parseLine [ l | l <- lns, "NAYA\t" `isPrefixOf` l ]
  pure (Kosha es (if null es then 0 else maximum (map entId es) + 1))

-- | The round trip is the whole persistence claim, so it is checked
--   rather than asserted.  Exhaustive over the store it is given.
prop_roundtrip :: Kosha -> Bool
prop_roundtrip k = replay (journal k) == Right k

-- ─────────────────────────────────────────────────────────── self-test

-- Finite, exhaustive, and it is the reason the module may be believed.
selfTest :: [(String, Bool)]
selfTest =
  [ ("round trip through the journal, separators and all", prop_roundtrip kTricky)
  , ("truth-equal, content-distinct is NOT identifiable (Unit/Bool)",
      case decide False [eUnit, eBool] of
        Nirnaya{nirSamata = Just SatyaSama, nirSthana = Position B2Nasti} -> True
        _ -> False)
  , ("and it exhibits the loss on both sides",
      case decide False [eUnit, eBool] of
        Nirnaya{nirNashti = ls} -> length ls == 2
        _ -> False)
  , ("content-equal, source-distinct is identifiable as content only",
      case decide False [ePingala, eHalayudha] of
        Nirnaya{nirSamata = Just ArthaSama} -> True
        _ -> False)
  , ("and a content-collapse's cost is the sources, exhibited",
      case decide False [ePingala, eHalayudha] of
        Nirnaya{nirMulaLoss = ls} -> length ls == 2
        _ -> False)
  , ("asserted saha, the same pair is the seventh bhanga",
      case decide True [ePingala, eHalayudha] of
        Nirnaya{nirSthana = Position B7AstiNastiAvaktavya} -> True
        _ -> False)
  , ("identical record: collapse permitted (the machine can say YES)",
      case decide False [ePingala, ePingala{entId = 99}] of
        Nirnaya{nirSamata = Just MulaSama, nirSthana = Position B1Asti} -> True
        _ -> False)
  , ("two fit DENIALS are refused, not reported as agreeing (D4)",
      case decide False [eDenied, eDenied{entName = "something-else-entirely"}] of
        Abhinna _ -> True
        _         -> False)
  , ("empty witnesses under Yogya IS a denial",     satya eDenied  == Just False)
  , ("empty witnesses under Ayogya is SILENCE",     satya eSilent  == Nothing)
  , ("silence does not become a nasti verdict; it becomes residue",
      case decide True [ePingala, eHalayudha, eSilent] of
        Nirnaya{nirShesha = [(_, _)], nirSamata = Just ArthaSama} -> True
        _ -> False)
  , ("a fit denial and an affirmation, saha, IS the fourth bhanga",
      case decide True [ePingala, eDenied] of
        Nirnaya{nirSthana = Position B4Avaktavya} -> True
        _ -> False)
  , ("the same two in succession are the third, not the fourth",
      case decide False [ePingala, eDenied] of
        Nirnaya{nirSthana = Position B3AstiNasti} -> True
        _ -> False)
  , ("avaktavya and abhinna are different answers",
      case (decide True [ePingala, eDenied], decide True [ePingala]) of
        (Nirnaya{}, Abhinna _) -> True
        _ -> False)
  , ("partial agreement returns the classes, not one flat NO",
      case decide False [ePingala, eHalayudha, eUnit] of
        Nirnaya{nirVarga = vs} -> length vs == 2 && any ((== 2) . length) vs
        _ -> False)
  , ("insert never merges: two identical records give two entries",
      let (_,_,k1) = insert ePingala empty
          (_,r ,k2) = insert ePingala{entId = 0} k1
      in length (koshaEntries k2) == 2 && any isPunar r)
  , ("insert reports the name collision instead of overwriting",
      let (_,_,k1) = insert ePingala empty
          (_,r ,_ ) = insert ePingala{entWitness = [Sakshin "other" "src"]} k1
      in any isNama r)
  , ("byName returns every entry with that name",
      let (_,_,k1) = insert ePingala empty
          (_,_,k2) = insert ePingala{entWitness = [Sakshin "other" "src"]} k1
      in length (byName k2 (entName ePingala)) == 2)
  ]
  where
    isPunar (Punarukta _)   = True; isPunar _ = False
    isNama  (Namasankara _) = True; isNama  _ = False

-- Fixtures.  Real material, so the test is about this repository.
mk :: String -> Yogyata -> [(String, String)] -> Entry
mk n y ws = Entry 0 n y "naya-kosha selfTest" "2026-08-20"
                 [ Sakshin a b | (a, b) <- ws ]

kTricky :: Kosha
kTricky = k3
  where
    (_,_,k1) = insert (mk "tabs\tand=semis;and\\backslash" (Yogya "grep over notes/")
                          [("a\tb=c;d", "source\\with=all;the\tseparators")]) empty
    (_,_,k2) = insert eUnit k1
    (_,_,k3) = insert eBool k2

-- The checked witness from Durnaya_CollapseIffEveryNayaAgrees, as data:
-- both fibres inhabited, and inequivalent.
eUnit, eBool :: Entry
eUnit = mk "Mixed-at-true" (Yogya "the fibre is Unit; enumerated")
          [("tt", "NaturalMachine/Durnaya_CollapseIffEveryNayaAgrees.agda")]
eBool = mk "Mixed-at-false" (Yogya "the fibre is Bool; enumerated")
          [("true",  "NaturalMachine/Durnaya_CollapseIffEveryNayaAgrees.agda")
          ,("false", "NaturalMachine/Durnaya_CollapseIffEveryNayaAgrees.agda")]

-- One content, two records.  Pingala states the prastara; Halayudha's
-- Mrtasanjivani (10th c.) is the commentary through which it is read.
ePingala, eHalayudha :: Entry
ePingala = mk "prastara-from-the-sutra"
              (Yogya "the Chandahsastra's own text, chapter 8")
              [("the two-syllable-class enumeration is generated, not tabulated",
                "Pingala, Chandahsastra, c. 300 BCE")]
eHalayudha = mk "prastara-from-the-commentary"
              (Yogya "Halayudha's gloss, read independently of the sutra text")
              [("the two-syllable-class enumeration is generated, not tabulated",
                "Halayudha, Mrtasanjivani, 10th c. CE")]

eDenied, eSilent :: Entry
eDenied = mk "transmission-is-documented"
            (Yogya "searched the Jesuit Cochin correspondence for a transmitted text")
            []
eSilent = mk "transmission-is-documented"
            (Ayogya "no search of the Goa or Rome archives was made at all")
            []
