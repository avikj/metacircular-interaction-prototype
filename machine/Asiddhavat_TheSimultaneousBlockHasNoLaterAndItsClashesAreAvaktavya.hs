-- असिद्धवत् -- the SIMULTANEOUS regime, lifted off Sanskrit and made general,
-- and the finding that the engine's one implementation of it breaks its own
-- ties with the metarule that regime forbids.
--
-- WHERE THIS SITS.  `machine/Vipratisedha_ConflictIsDecidedByMetaruleNotByList
-- Position.hs` (this session, a sibling lane) lifted the Aṣṭādhyāyī's conflict
-- layer off the grammar: four metarules in Nāgeśa Bhaṭṭa's ranking, and a
-- stratification `tStratum :: Sthana -> Int` generalising 8.2.1
-- पूर्वत्रासिद्धम् -- stratum 0 to a fixpoint, strata 1..n once each, in
-- order, backwards-blind.  That is ONE of Pāṇini's two asiddha devices.  The
-- other one is not in the general layer, and this module is it.
--
--   8.2.1  पूर्वत्रासिद्धम्  pūrvatrāsiddham -- from 8.2.1 on, a rule is
--          asiddha for everything PRECEDING it.  ONE-WAY blindness.  There is
--          still an earlier and a later, and 1.4.2 can read them.
--
--   6.4.22 असिद्धवदत्राभात्  asiddhavad atrābhāt (heading 6.4.22-6.4.129) --
--          within that block, what one rule does counts as NOT HAVING TAKEN
--          EFFECT for every OTHER rule of the same block.  MUTUAL blindness.
--          The rules apply युगपत् yugapat -- as if simultaneously.
--
-- `machine/Astadhyayi.hs` §7a (2026-08-19) already implements the second one
-- for the grammar: `asiddhavatPass` offers every rule of the block the SAME
-- input, applies the non-overlapping rewrites together, and -- where two
-- rewrites overlap -- picks a winner.  That file says of the picking:
--
--     "where two rewrites overlap, the block cannot perform both at once and
--      1.4.2 decides, exactly as it does elsewhere."
--
-- and the code is
--
--     winner = foldl (\a b -> if num (fst b) > num (fst a) then b else a) (s,r) clash
--
-- THE DEFECT, in two parts, and both are in that one line.
--
--   (i)  IT IS NOT "exactly as elsewhere".  Elsewhere is `resolveN`, in the
--        same file, and `resolveN` tries अपवाद apavāda FIRST and only then
--        1.4.2.  This site skips apavāda entirely -- the STRONGEST of the
--        five paribhāṣās (Paribhāṣenduśekhara 38: pūrva < para < nitya <
--        antaraṅga < apavāda) -- and applies the second-WEAKEST alone.  It
--        also records nothing: `resolveN` returns the undecided competitors
--        so §7b can write the debt, and `asiddhavatPass` returns no such
--        thing, so an undecided clash inside the simultaneous block is
--        invisible in a file that made the sequential ones countable.
--
--   (ii) AND para IS NOT AVAILABLE HERE AT ALL.  This is the structural half.
--        विप्रतिषेधे परं कार्यम् says "in conflict, the LATER operation is to
--        be done."  Later is a fact about a sequence of operations.  6.4.22's
--        whole content is that in this block there IS no sequence of
--        operations: each rule sees only the input, never another rule's
--        output, so no rule is after any other in the only sense 1.4.2 uses.
--        Reading the sūtra NUMBERS as an order inside an asiddhavat block
--        smuggles succession back into the regime defined by its absence.
--
-- THE JAIN NAME FOR EXACTLY THIS, and the corpus already carries it.
-- Akalaṅka, *Laghīyastraya*, c. 720-780, distinguishes क्रमार्पण kramārpaṇa
-- (assertion in SUCCESSION) from सहार्पण sahārpaṇa (assertion SIMULTANEOUS).
-- Asserted one after the other, अस्ति and नास्ति are both sayable -- that is
-- the third bhaṅga.  Asserted at once, no single utterance carries them, and
-- that is the fourth, अवक्तव्यम् avaktavyam: not unknown, not undefined, not
-- empty.  `notes/AHIMSA_SUTRA_VISTARA.md` §३ states it in one line --
-- क्रमार्पणे उक्तं शक्यम् · सहार्पणे न शक्यम् -- and `machine/Naya.hs` and
-- `machine/Saptabhangi_TheSevenfoldVerdict.hs` already run it.
--
-- So: an overlapping clash inside a 6.4.22 block is not a tie awaiting a
-- tie-breaker.  It is sahārpaṇa, and its verdict is avaktavyam by the
-- structure of the regime, not by anybody's failure to decide.  Pāṇini's
-- device and Akalaṅka's fourth position are the same object, twelve
-- centuries and one darśana apart, and the engine had them in two files that
-- did not know about each other.
--
-- WHAT SURVIVES SIMULTANEITY, and this is the operative result.  Split the
-- five paribhāṣās by whether they read a POSITION:
--
--     positional      pūrva (the earlier), para (the later, 1.4.2)
--     position-free   apavāda (A's domain is properly inside B's)
--                     antaraṅga (A's nimittas lie further in)
--                     nitya     (A applies whether or not B has applied)
--
-- The three position-free ones are relations between the RULES, holding
-- whether or not anything has happened yet, so a simultaneous block may use
-- all three.  The two positional ones have nothing to read.  Hence:
--
--     A 6.4.22 block resolves by apavāda, antaraṅga or nitya, or its clash
--     is avaktavya.  It never resolves by para, and never by pūrva.
--
-- That is stated here as an observation about the two devices, not as a
-- reading of Nāgeśa: Paribhāṣenduśekhara 38 ranks the five and gives its own
-- grounds, and "the bottom two are the ones a simultaneous block cannot use"
-- is not among them.
--
-- ONE FIELD, TWO GROUNDS -- a defect in the layer this module builds on, and
-- recorded here rather than edited into a file another lane is holding.
-- `V.Tantra` has a single `tParatva :: Bool`, documented for exactly one
-- ground: "a domain whose rule order is a concatenation of collections that
-- were never placed with respect to one another has NO paratva."  That is
-- MathMachine's ground and it is a fixable one -- author the order and para
-- returns.  6.4.22's ground is the opposite: the order IS authored, and the
-- regime forbids reading it, permanently.  A ledger that renders both as
-- `False` cannot tell a missing authorship from a structural prohibition,
-- and those are not the same debt.  This module supplies the distinction as
-- `Paratvahetu` and prints it in every defect it writes.
--
-- SOURCES.  Pāṇini, *Aṣṭādhyāyī*, ~500 BCE: 6.4.22 असिद्धवदत्राभात्, 8.2.1
-- पूर्वत्रासिद्धम्, 1.4.2 विप्रतिषेधे परं कार्यम्.  Nāgeśa Bhaṭṭa,
-- *Paribhāṣenduśekhara*, c. 1730, paribhāṣā 38, for the strength order.
-- Akalaṅka, *Laghīyastraya*, c. 720-780, for kramārpaṇa against sahārpaṇa;
-- Umāsvāti, *Tattvārthasūtra* 5.31, for the sevenfold predication it belongs
-- to.
--
-- WHAT IS NOT CLAIMED.  This module encodes ZERO SŪTRAS.  It adds one
-- stratum MODE to a scheduler.  `Astadhyayi.coverage` prints 26 sūtras of
-- ~3983 (recensions 3959-3996) and nothing here moves that number.  No sūtra
-- of 6.4 is encoded anywhere in this repository, which `Astadhyayi.hs` §7a
-- states plainly; running the tripādī's own rules under the simultaneous
-- regime is a COUNTERFACTUAL whose purpose is to show the regime is
-- load-bearing, and it is not a claim about Sanskrit.

module Asiddhavat_TheSimultaneousBlockHasNoLaterAndItsClashesAreAvaktavya
  ( -- why para abstained
    Paratvahetu(..)
  , showParatvahetu
    -- the regime
  , Yugapat(..)
  , Karya(..)
  , Phala(..)
  , varga
  , yugapatPada
    -- reading the result
  , showKarya
  , showAvaktavya
  ) where

import qualified Vipratisedha_ConflictIsDecidedByMetaruleNotByListPosition as V

import Data.List (sortOn, partition)

------------------------------------------------------------------------
-- 1.  WHY para IS SILENT.  Two different facts, and they were one Bool.
------------------------------------------------------------------------

data Paratvahetu
  = Adhikrtakrama      -- the order IS authored and para may read it (8.2.1,
                       -- and the sequential part of the Aṣṭādhyāyī)
  | Anadhikrtakrama    -- the order is a concatenation nobody placed.  para
                       -- abstains, and the debt is FIXABLE: author the order
                       -- and para returns.  This is MathMachine's ground.
  | Yugapatkrama       -- 6.4.22: the order is authored and the regime forbids
                       -- reading it, because inside the block no rule is
                       -- after any other.  para abstains PERMANENTLY.  No
                       -- amount of authorship recovers it.
  deriving (Eq, Show)

showParatvahetu :: Paratvahetu -> String
showParatvahetu h = case h of
  Adhikrtakrama ->
    "para is available: the positions are authored and the regime is successive"
  Anadhikrtakrama ->
    "para abstains -- the rule order was never authored (a concatenation is "
    ++ "not an authorship).  FIXABLE: author the order and 1.4.2 returns."
  Yugapatkrama ->
    "para abstains -- 6.4.22 असिद्धवत्: inside this block no rule is later "
    ++ "than any other, so विप्रतिषेधे परं कार्यम् has nothing to compare.  "
    ++ "NOT fixable: this is the regime, not a gap in it."

------------------------------------------------------------------------
-- 2.  THE REGIME
--
-- A `V.Tantra` says how rules contend.  It does not say how two rules ACT AT
-- ONCE, and it cannot: `V.nyResult` is the object after ONE offer alone, and
-- composing several is a fact about the objects.  So the simultaneous regime
-- needs one field the sequential one does not, and a domain that cannot
-- supply it cannot run 6.4.22.  Saying that in the type is cheaper than
-- discovering it in a derivation.
------------------------------------------------------------------------

data Yugapat o = Yugapat
  { yuTantra :: V.Tantra o
    -- the block.  Every rule in it is asiddha to every other.
  , yuBlock  :: [V.Sasana o]
    -- apply PAIRWISE-DISJOINT offers to the input together.  The offers
    -- handed to this are winners of distinct overlap classes, so they do not
    -- contend; what remains is the domain's bookkeeping (for a string, apply
    -- right-to-left so earlier positions keep their indices).
  , yuSaha   :: o -> [V.Nyasa o] -> o
    -- why para is silent here, so the defect record can say which debt it is
  , yuHetu   :: Paratvahetu
  }

-- One rule's action inside the block, and the metarule that authorised it.
data Karya o = Karya
  { kaRule   :: V.Sthana
  , kaName   :: String
  , kaNote   :: String
  , kaBeaten :: [V.Sthana]
  , kaBalya  :: V.Balya
  }

-- The whole pass: what acted, what could not be said, what came out.
--
-- `phAvaktavya` keeps the WRITING and the SEED together.  `V.Dosa` renders the
-- undecided site for a reader; `V.Sesa` holds the object and the entire set of
-- contending offers, so the fourth position can be worked with and not merely
-- printed.  Keeping only the `Dosa` would be the collapse
-- `machine/SaptabhangiGarbha_TheResidueIsTheSeed.hs` names: a fourth position
-- that does not record which two seeds produced it.
data Phala o = Phala
  { phKaryani :: [Karya o]
  , phAvaktavya :: [(V.Dosa, V.Sesa o)]
  , phResult  :: o
  }

------------------------------------------------------------------------
-- 3.  OVERLAP CLASSES
--
-- Offers that do not contend all act.  Offers that contend form a class, and
-- contention is transitive for this purpose: if a overlaps b and b overlaps
-- c, the three cannot be performed independently even when a and c are
-- disjoint, because performing b consumes the site both of them need.
------------------------------------------------------------------------

varga :: V.Tantra o -> [V.Nyasa o] -> [[V.Nyasa o]]
varga _ [] = []
varga t (x : xs) = grow [x] xs
  where
    grow cls rest =
      case partition (\y -> any (\c -> V.tOverlap t c y || V.tOverlap t y c) cls) rest of
        ([], out)   -> cls : varga t out
        (more, out) -> grow (cls ++ more) out

------------------------------------------------------------------------
-- 4.  ONE SIMULTANEOUS PASS
--
-- Every rule of the block is offered the SAME input -- that is 6.4.22, and
-- it is the whole of it.  Then:
--
--   * a class of one acts, `V.Eka`, no conflict arose;
--   * a class of more goes to `V.nirnaya`, which tries apavāda, antaraṅga
--     and nitya.  Whether it then tries para is `V.tParatva` -- and for a
--     6.4.22 block that field must be False, with `yuHetu = Yugapatkrama`
--     saying which of the two grounds for False this is;
--   * where nothing decides, the class is AVAKTAVYA: the defect is written,
--     the block does not act at that site, and it does not fall back to
--     pūrva.  A fallback would be succession, and succession is the one
--     thing this regime does not have.
------------------------------------------------------------------------

yugapatPada :: Yugapat o -> o -> Phala o
yugapatPada y o =
  let offers  = concatMap (\s -> V.saFires s o) (yuBlock y)
      classes = varga (yuTantra y) (sortOn V.nyPos offers)
      decided = map (V.nirnaya (yuTantra y) o) classes
      wins    = [ (w, k) | V.Nirnita w lost by <- decided
                         , let k = Karya (V.nyRule w) (nameOf (V.nyRule w))
                                         (V.nyNote w) lost by ]
      dosah   = [ (d, sh) | V.Avaktavya d sh <- decided ]
  in Phala { phKaryani   = map snd wins
           , phAvaktavya = dosah
           , phResult    = yuSaha y o (map fst wins)
           }
  where
    nameOf r = head ([ V.saName s | s <- yuBlock y, V.saRef s == r ] ++ ["?"])

------------------------------------------------------------------------
-- 5.  READING IT
------------------------------------------------------------------------

showKarya :: Karya o -> [String]
showKarya k =
  [ V.showSthana (kaRule k) ++ "  " ++ kaName k
  , "    " ++ kaNote k
  ] ++
  [ "    beat " ++ unwords (map V.showSthana (kaBeaten k))
    ++ " -- " ++ V.showBalya (kaBalya k)
  | not (null (kaBeaten k)) ]

-- A defect from a simultaneous block, with the sahārpaṇa reason attached.
-- `V.showDosa` says the scheduler will not break the tie by list position;
-- this adds the stronger statement, which is that under 6.4.22 there is no
-- tie to break -- the two offers are asserted at once and no single form
-- carries both.
--
-- The śeṣa is printed with it, never separately.  A fourth position that has
-- lost the two standpoints that produced it is unusable, which is the whole
-- reason `V.Sesa` exists.
showAvaktavya :: Paratvahetu -> (V.Dosa, V.Sesa o) -> [String]
showAvaktavya h (d, sh) =
  V.showDosa d ++
  [ "  regime: " ++ showParatvahetu h
  , "  this is अवक्तव्यम् (Akalaṅka, Laghīyastraya c. 720-780: sahārpaṇa, "
    ++ "simultaneous"
  , "  assertion, against kramārpaṇa, assertion in succession).  Not unknown, "
    ++ "not"
  , "  undefined, not empty -- the fourth position.  The block does not act at "
    ++ "this"
  , "  site and does NOT fall back to pūrva, because a fallback is succession "
    ++ "and"
  , "  succession is the one thing this regime does not have."
  , "  śeṣa retained -- " ++ show (length (V.sesaNyasah sh))
    ++ " contending offers, entire, so the seed is workable and not just "
    ++ "printed:"
  ] ++
  [ "    " ++ V.showSthana (V.nyRule n) ++ "  at " ++ show (V.nyPos n)
    ++ "+" ++ show (V.nyLen n) ++ "  " ++ V.nyNote n
  | n <- V.sesaNyasah sh ]
