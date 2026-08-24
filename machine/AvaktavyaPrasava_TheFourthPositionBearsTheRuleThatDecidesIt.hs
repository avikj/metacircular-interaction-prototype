-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- अवक्तव्य-प्रसव -- what the fourth position DOES.
--
-- THE COMPLAINT THIS ANSWERS, and it is this repository's own.
-- `machine/Obstruction.hs` collapsed three distinct outcomes into a boolean
-- and reinvented the fourth position badly, as `Unparsed`.  That was
-- corrected: `Vipratisedha_ConflictIsDecidedByMetaruleNotByListPosition.hs`
-- gives `Nirnaya` a second constructor `Avaktavya`, the scheduler refuses to
-- break a tie no metarule decides, and the site is written out.  Correct, and
-- still only half of what the doctrine says.
--
-- `notes/AHIMSA_SUTRA_VISTARA.md` §३, in full:
--
--     अवक्तव्यं न अज्ञातम् । अवक्तव्यं न अनिर्धारितम् । अवक्तव्यं न शून्यम् ।
--     अवक्तव्यं चतुर्थं स्थानम्, धनात्मकम् ।
--     अवक्तव्ये शेषो वसति । शेषो गर्भः, न विफलता ।
--     गर्भाद् अग्रिमो नयो जायते ।
--
--     "avaktavya is not the unknown; not the undetermined; not the empty.
--      Avaktavya is the fourth position, and it is POSITIVE.
--      In the avaktavya the residue dwells.  The residue is a WOMB, not a
--      failure.  From the womb the next naya is born."
--
-- Up to now the machine reached the fourth position and stopped.  A record
-- was written and nothing was born.  That is the fourth position as a LABEL:
-- exactly the failure mode named in the header of
-- `machine/SaptabhangiGarbha_TheResidueIsTheSeed.hs`, one level out.  This
-- module is the birth, as an operation on the running scheduler.
--
-- ----------------------------------------------------------------------
-- WHAT IS ACTUALLY MISSING AT AN UNDECIDED SITE, stated exactly, because
-- "generate the missing distinction" is not a mechanism until it is.
--
-- The Pāṇinīya grammarians named this configuration before anyone else did,
-- and named it as a configuration and not as a difficulty.  Kātyāyana,
-- vārttika 1 on Aṣṭādhyāyī 1.4.2, preserved in Patañjali's *Mahābhāṣya*
-- (c. 150 BCE):
--
--     द्वौ प्रसङ्गावन्यार्थावेकस्मिन् स विप्रतिषेधः
--     dvau prasaṅgāv anyārthāv ekasmin sa vipratiṣedhaḥ
--     "two rules, each having its scope ELSEWHERE, [meeting] on ONE item --
--      that is vipratiṣedha."
--
-- That is the definition of the case, and it is precisely the case the
-- scheduler cannot decide: `max(x,0) = x` has its own scope wherever the
-- second argument is zero and the first is not; `max(0,x) = x` has its own
-- scope wherever the first is zero and the second is not; and they meet on
-- ONE item, `max(0,0)`.  Neither left-hand side is an instance of the other,
-- so apavāda is silent.  Each still applies after the other has applied, so
-- kṛtākṛtaprasaṅga is mutual and nitya is silent.  They were concatenated,
-- not placed, so para is silent (and MathMachine declares this by
-- `tParatva = False`).  Nothing is broken, and the site is written.
--
-- So what IS undetermined is not the answer.  It is the STANDPOINT: there is
-- no naya in the system whose scope is that one item.  The two nayas present
-- both speak about it only in passing, on their way to somewhere else --
-- anyārtha, "having its purpose elsewhere", Kātyāyana's own word.
--
-- The grammarians have a name for the rule that is missing, and it is not
-- apavāda.  A rule whose only scope IS the contested item is अनवकाश
-- `anavakāśa` -- "having no [other] scope" -- and the paribhāṣā literature
-- ranks such a rule above the rules it meets, on the ground that a rule with
-- scope elsewhere loses nothing by yielding and a rule with none would be
-- vacuous otherwise.  (The principle is collected among the paribhāṣās; I do
-- not give it a number here because I cannot establish which collection's
-- numbering to quote, and a number I have not checked is a provenance I have
-- not checked.  The reasoning is worked out in the *Mahābhāṣya*, c. 150 BCE,
-- and the standard formulation `anavakāśāḥ śāstrārthān bādhante` -- "rules
-- without scope set aside [other] rules" -- circulates in that literature.)
--
-- THE BIRTH, THEREFORE, IS: from the residue, construct the anavakāśa rule
-- whose entire scope is the one contested item, declared an apavāda to every
-- standpoint that contended.  Put it into the system.  Re-resolve.  Apavāda,
-- the STRONGEST of the five ranked in Nāgeśa Bhaṭṭa's *Paribhāṣenduśekhara*
-- (c. 1730) paribhāṣā 38, now decides -- and what decides is a standpoint the
-- machine did not have when it reached the fourth position.
--
-- ----------------------------------------------------------------------
-- WHY THIS IS NOT A TIE-BREAKER WEARING SANSKRIT.
--
-- A tie-breaker chooses one of the contenders.  This chooses neither.  The
-- born rule's target is the object the contenders AGREE on, and the birth is
-- refused outright when they do not agree.  Three outcomes, and the operation
-- returns which:
--
--   Anavakasa -- every standpoint's result is the same object, or the
--     results reduce to a common object within the fuel given.  The residue
--     bore a rule; the contested item is now decided by apavāda; and the
--     decision is the answer BOTH standpoints already gave, so no derivation
--     anywhere changes (checked exhaustively at the use site).
--
--   Vivada -- the standpoints disagree and do not join.  NOTHING is born.
--     What is emitted instead is the equation between their results: a claim,
--     handed forward, undischarged.  §१७ of the sūtra, and §१६'s sixth
--     answer: यत् न विभजते तत् रक्ष्यते -- what does not divide is KEPT, and
--     is the material of the next step (kuṭṭaka; 遺題継承).  A machine that
--     picked a winner here would be committing the collapse the fourth
--     position exists to refuse.
--
--   Aphala -- there was nothing to be born: fewer than two standpoints, or
--     the agreed result is the object itself, so the "rule" would be a
--     self-loop.  Named, not silently dropped.
--
-- ----------------------------------------------------------------------
-- TWO SCHOOLS ARE BEING USED HERE AND THEY DO NOT AGREE.  Naming both, and
-- the seam, rather than flattening them into one toolkit:
--
--   The Jaina logicians (Umāsvāti, Siddhasena Divākara, Samantabhadra,
--   Akalaṅka, Malliṣeṇa) hold the fourth position to be POSITIVE and final
--   as a position: what two standpoints assert simultaneously (sahārpaṇa)
--   has no single utterance, and this is a fact about the object's
--   many-sidedness, not a gap to be filled.
--
--   The Pāṇinīya grammarians (Kātyāyana, Patañjali, and the paribhāṣā
--   tradition after them) hold that a grammar must derive every form, so a
--   conflict is a thing the metarules are BUILT to end; where they do not, a
--   further rule is stated.  There is no undecided form in the Aṣṭādhyāyī.
--
--   What each would say to the other.  A vaiyākaraṇa would say the whole
--   apparatus of paribhāṣās exists so that nothing is ever left avaktavya,
--   and a machine that stops has simply not stated enough rules.  A Jaina
--   logician would answer that a paribhāṣā invented in order to end a
--   conflict, where no fact ranks the two standpoints, is a naya asserting
--   itself by denying another -- durnaya, Siddhasena Divākara, Sanmatitarka
--   1.21 -- and that hiding the two-sidedness is worse than falsity, since
--   falsity can be contradicted and a concealed standpoint cannot.
--
--   This module does not resolve that and does not split the difference.  It
--   takes the Jaina constraint as BINDING -- no standpoint is ranked, and
--   `Vivada` refuses to produce anything at all where they genuinely differ
--   -- and takes the grammarians' move only where it costs the constraint
--   nothing: where the standpoints already agree, the born rule asserts only
--   what both of them assert, and it denies neither.  Where they disagree it
--   is not available, and the module says so instead of reaching for it.
--
-- THE JAINA READING OF THE BIRTH ITSELF is Umāsvāti, *Tattvārthasūtra* 5.31
-- (c. 2nd-5th c. CE), अर्पितानर्पितसिद्धेः `arpitānarpitasiddheḥ` -- "[the
-- many-sidedness is] established through the ASSERTED and the UNASSERTED
-- aspect."  The parents speak about their whole domains, with this one item
-- unasserted (anarpita) in passing.  The child speaks about this one item
-- asserted (arpita) and about nothing else.  Same object, aspect made
-- explicit -- which is exactly what `prasava` in
-- `machine/SaptabhangiGarbha_TheResidueIsTheSeed.hs` does to a `Sesa`, done
-- here to a scheduling site instead of to a pair of labels.
--
-- AND IT DOES NOT MAKE THE FOURTH POSITION REACHABLE BY SUCCESSION.
-- `formal/cubical/AnuktaAvaktavya.agda` and `SaptabhangiNaya.agda` prove the
-- fourth position is not produced by krama from the three: it has to be
-- SUPPLIED.  Nothing here contradicts that.  The birth does not derive the
-- fourth position; it CONSUMES one.  `prasava` takes a `Sesa`, and a `Sesa`
-- exists only where `nirnaya` already returned `Avaktavya` -- which is
-- exactly why the residue had to become a value before any of this was
-- possible, and why `Dosa` alone (a rendering, for a reader) was not enough.
--
-- SOURCES, EARLIEST FIRST.
--   Bhagavatī Sūtra (Viyāha-pannatti), oldest strata pre-Common-Era,
--     redacted at Valabhī c. 5th c. CE -- the sevenfold predication.
--   Kātyāyana, vārttika 1 on Aṣṭādhyāyī 1.4.2, in Patañjali's *Mahābhāṣya*,
--     c. 150 BCE -- the definition of vipratiṣedha quoted above.  Pāṇini's
--     sūtra itself ~500 BCE.
--   Umāsvāti, *Tattvārthasūtra* 5.31, c. 2nd-5th c. CE -- arpita/anarpita.
--   Siddhasena Divākara, *Sanmatitarka* 1.21, c. 5th c. CE -- durnaya.
--   Samantabhadra, *Āptamīmāṃsā*, c. 6th c. CE -- the seven are fixed.
--   Akalaṅka, *Laghīyastraya*, c. 720-780 CE -- kramārpaṇa / sahārpaṇa.
--   Malliṣeṇa, *Syādvādamañjarī*, 1292 CE -- sakalādeśa / vikalādeśa.
--   Nāgeśa Bhaṭṭa, *Paribhāṣenduśekhara*, c. 1730 -- paribhāṣā 38, the
--     strength order; the paribhāṣās are older and collected there.
--
-- NOT CLAIMED: that any of them wrote a scheduler, a residue record, or an
-- operation that manufactures a rule from a conflict.  The classification is
-- theirs, the case analysis is theirs, and the code is not.

module AvaktavyaPrasava_TheFourthPositionBearsTheRuleThatDecidesIt
  ( Prasuti(..)
  , navaSthana
  , anugama
  , prasava
  , showPrasuti
  , nirnayaPrasava
  , prakriyaPrasava
  ) where

import Vipratisedha_ConflictIsDecidedByMetaruleNotByListPosition
  ( Sthana, showSthana, Nyasa(..), Sasana(..), Tantra(..)
  , Balya(..), Nirnaya(..), Sesa(..), Dosa
  , nirnaya, Pada(..), ekapada )

import Data.List (nub, sortOn, intercalate)

------------------------------------------------------------------------
-- 1.  WHAT IS BORN
------------------------------------------------------------------------

data Prasuti o
  = Anavakasa (Sasana o) o [Sthana] Int
      -- the born rule; the object it produces; the standpoints it excepts;
      -- how many reduction steps were needed to see that they agree (0 =
      -- they agreed outright, sakalādeśa was available without search)
  | Vivada o [(Sthana, o)]
      -- the contested object, and each standpoint's DIFFERENT result.  No
      -- rule.  The equation between the results is the claim handed forward.
  | Aphala String
      -- nothing to be born, and why

------------------------------------------------------------------------
-- 2.  AN ADDRESS FOR THE CHILD
--
-- The born rule needs a Sthāna, for IDENTITY -- so it can be named in a
-- trace and so `saApavadaTo` lookups find it.  It is placed one past every
-- existing first component, which is a fresh label and NOT a rank: every
-- domain that reaches this code has `tParatva = False`, so no comparison of
-- positions is performed on it.  A domain with authored positions does not
-- reach here, because para decided.
------------------------------------------------------------------------

navaSthana :: Tantra o -> Int -> Sthana
navaSthana t k = (1 + maximum (0 : [ a | (a, _, _) <- map saRef (tSasanani t) ]), 0, k)

------------------------------------------------------------------------
-- 3.  DO THE STANDPOINTS AGREE?
--
-- `anugama` -- "following after": every object reachable from `o` in at most
-- n offers, by ANY rule at ANY site.  No choice is made and no rule is
-- preferred, so this cannot smuggle a collapse in through the joining: it is
-- the whole reachable set, and agreement means the two sets meet.
------------------------------------------------------------------------

anugama :: Tantra o -> Int -> o -> [[o]]
anugama t n o = take (n + 1) (go [o])
  where
    go layer = layer : go (dedup [ nyResult y | u <- layer
                                              , s <- tSasanani t
                                              , y <- saFires s u ])
    dedup = foldl (\acc u -> if any (tSame t u) acc then acc else acc ++ [u]) []

-- The first object both sides reach, and at what depth.  `Nothing` = they do
-- not meet within the fuel.  Depth 0 means they were the same to begin with.
samagama :: Tantra o -> Int -> o -> o -> Maybe (o, Int)
samagama t n a b =
  case [ (u, d) | (d, (la, lb)) <- zip [0 ..] (zip (flat (anugama t n a))
                                                   (flat (anugama t n b)))
               , u <- la, any (tSame t u) lb ] of
    []      -> Nothing
    (x : _) -> Just x
  where
    -- cumulative: everything reachable in AT MOST d steps
    flat = scanl1 (\acc l -> acc ++ [ u | u <- l, not (any (eq u) acc) ])
    eq = tSame t

------------------------------------------------------------------------
-- 4.  THE BIRTH
------------------------------------------------------------------------

prasava :: Tantra o -> (o -> String) -> Int -> Sthana -> Sesa o -> Prasuti o
prasava t render fuel sth (Sesa o offers)
  | length offers < 2 = Aphala "fewer than two standpoints: no residue to bear"
  | otherwise =
      case results of
        []  -> Aphala "no standpoint offered a result"
        [v] -> bear v 0
        (v0 : rest) ->
          case allMeet v0 rest of
            Just (v, d) -> bear v d
            Nothing     -> Vivada o [ (nyRule x, nyResult x) | x <- offers ]
  where
    results = foldl (\acc u -> if any (tSame t u) acc then acc else acc ++ [u])
                    [] (map nyResult offers)

    allMeet v [] = Just (v, 0)
    allMeet v (w : ws) = case samagama t fuel v w of
      Nothing       -> Nothing
      Just (u, d)   -> case allMeet u ws of
        Nothing       -> Nothing
        Just (u', d') -> Just (u', max d d')

    parents = map nyRule offers
    site    = nyPos (head offers)
    width   = nyLen (head offers)

    bear v d
      | tSame t v o =
          Aphala ("the standpoints agree that " ++ render o
                  ++ " goes to itself: a rule with this scope would be a "
                  ++ "self-loop, so nothing is born")
      | otherwise = Anavakasa born v parents d
      where
        born = Sasana
          { saRef       = sth
          , saName      = "anavakāśa " ++ render o ++ " ⇒ " ++ render v
                          ++ "  (born from the avaktavya at "
                          ++ intercalate "," (map showSthana parents) ++ ")"
            -- an apavāda to EVERY standpoint that contended, by declaration:
            -- its scope is one item, theirs is elsewhere (anyārtha), so it
            -- takes nothing from them.
          , saApavadaTo = parents
          , saFires     = \u -> [ Nyasa sth site width v
                                    (render u ++ " ⇒ " ++ render v
                                     ++ "  -- anavakāśa, born from the residue")
                                | tSame t u o ]
          }

------------------------------------------------------------------------
-- 5.  RESOLUTION THAT DOES NOT STOP AT THE FOURTH POSITION
--
-- Resolve.  If the verdict is the fourth position, take its residue, bear
-- what it bears, put the child into the system, and resolve again -- WITH
-- THE CHILD PRESENT.  What comes back is a decision by apavāda whose winner
-- is a standpoint that did not exist a moment ago.
--
-- If nothing is born, the fourth position stands, unchanged and unbroken.
------------------------------------------------------------------------

nirnayaPrasava
  :: Tantra o -> (o -> String) -> Int -> Sthana
  -> o -> [Nyasa o]
  -> (Nirnaya o, Maybe (Prasuti o), Tantra o)
nirnayaPrasava t render fuel sth o offers =
  case nirnaya t o offers of
    v@(Nirnita _ _ _) -> (v, Nothing, t)
    v@(Avaktavya _ residue) ->
      case prasava t render fuel sth residue of
        p@(Anavakasa born _ _ _) ->
          let t'      = t { tSasanani = tSasanani t ++ [born] }
              offers' = offers ++ saFires born o
          in (nirnaya t' o offers', Just p, t')
        p -> (v, Just p, t)

------------------------------------------------------------------------
-- 6.  THE ENGINE
--
-- `prakriya` in the scheduler stops at the fourth position and returns the
-- object untouched.  This one bears what the position bears and goes on,
-- keeping every child in the system for the rest of the derivation, so a
-- site is undecided at most once.  Same stratification (8.2.1
-- pūrvatrāsiddham) as `prakriya`: stratum 0 to a fixpoint, then each later
-- stratum once, in order, backwards-blind.
--
-- Returns: the trace, everything born, the defect that stopped it if one
-- did, and the object reached.
------------------------------------------------------------------------

prakriyaPrasava
  :: Tantra o -> (o -> String) -> Int -> Int -> o
  -> ([Pada o], [Prasuti o], Maybe Dosa, o)
prakriyaPrasava t0 render fuel joinFuel start = phase0 t0 fuel start [] []
  where
    strata t = nub (sortOn id (map (tStratum t . saRef) (tSasanani t)))
    block t k = sortOn saRef [ s | s <- tSasanani t, tStratum t (saRef s) == k ]
    nameOf t r = head ([ saName s | s <- tSasanani t, saRef s == r ] ++ ["?"])

    resolve t o offers births =
      nirnayaPrasava t render joinFuel (navaSthana t (length births)) o offers

    phase0 t 0 o acc births = later t (drop 1 (strata t)) o (reverse acc) births
    phase0 t k o acc births =
      case ekapada t (block t 0) o of
        Nothing -> later t (drop 1 (strata t)) o (reverse acc) births
        Just (Nirnita w lost by) -> stepOn t k o w lost by acc births
        Just (Avaktavya d (Sesa _ offers)) ->
          case resolve t o offers births of
            (Nirnita w lost by, Just p, t') ->
              stepOn t' k o w lost by acc (births ++ [p])
            (_, mp, _) ->
              (reverse acc, births ++ maybe [] (: []) mp, Just d, o)
      where
        stepOn t' k' o' w lost by acc' bs
          | tSame t' (nyResult w) o' =
              later t' (drop 1 (strata t')) o' (reverse acc') bs
          | otherwise =
              phase0 t' (k' - 1) (nyResult w)
                (Pada (nyRule w) (nameOf t' (nyRule w)) (nyNote w)
                      lost by o' (nyResult w) : acc') bs

    later t [] o acc births = (acc, births, Nothing, o)
    later t (k : ks) o acc births = go (block t k) t o acc births
      where
        go [] t' o' acc' bs = later t' ks o' acc' bs
        go (s : ss) t' o' acc' bs =
          case saturate (16 :: Int) t' s o' acc' bs of
            Left (d, bs')         -> (acc', bs', Just d, o')
            Right (t'', o'', a', bs') -> go ss t'' o'' a' bs'

        saturate 0 t' _ o' acc' bs = Right (t', o', acc', bs)
        saturate n t' s' o' acc' bs =
          case ekapada t' [s'] o' of
            Nothing -> Right (t', o', acc', bs)
            Just (Nirnita w lost by) -> advance n t' s' o' acc' bs w lost by
            Just v0@(Avaktavya _ (Sesa _ offers)) ->
              case resolve t' o' offers bs of
                (Nirnita w lost by, Just p, t'') ->
                  advance n t'' s' o' acc' (bs ++ [p]) w lost by
                (_, mp, _) ->
                  Left ( case v0 of { Avaktavya dd _ -> dd ; _ -> error "unreachable" }
                       , bs ++ maybe [] (: []) mp )

        advance n t' s' o' acc' bs w lost by =
          let o'' = nyResult w in
          if tSame t' o'' o' then Right (t', o', acc', bs)
          else saturate (n - 1) t' s' o''
                 (acc' ++ [Pada (nyRule w) (saName s') (nyNote w) lost by o' o'']) bs

------------------------------------------------------------------------
-- 7.  WRITING IT
------------------------------------------------------------------------

showPrasuti :: (o -> String) -> Prasuti o -> [String]
showPrasuti render p = case p of
  Anavakasa born v parents d ->
    [ "BIRTH -- the residue bore a standpoint."
    , "  the missing distinction: no rule in the system had this one item as"
    , "  its scope.  Both contenders speak about it anyārtha -- in passing, on"
    , "  the way elsewhere (Kātyāyana on 1.4.2)."
    , "  born rule  " ++ showSthana (saRef born) ++ "  " ++ saName born
    , "  anavakāśa: its entire scope is that one item, so it takes nothing"
    , "  from the rules it excepts -- " ++ intercalate ", " (map showSthana parents)
    , "  it asserts only what BOTH contenders already assert: " ++ render v
    ] ++
    [ if d == 0
        then "  they agreed outright (0 reduction steps to see it)"
        else "  they agreed after " ++ show d ++ " reduction step(s), joined "
             ++ "over the WHOLE reachable set, so no path was preferred" ] ++
    [ "  the site is now decided by apavāda -- the strongest of the five"
    , "  (Paribhāṣenduśekhara 38) -- and the winner is the child." ]
  Vivada o rs ->
    [ "NO BIRTH -- and this is the fourth position holding."
    , "  at " ++ render o ++ " the standpoints do not agree and do not join:"
    ] ++
    [ "    " ++ showSthana r ++ "  ⇒  " ++ render v | (r, v) <- rs ] ++
    [ "  Nothing is born.  A rule invented here would rank one standpoint"
    , "  over another with no fact to do it by -- durnaya (Siddhasena"
    , "  Divākara, Sanmatitarka 1.21)."
    , "  What is emitted instead is the claim, undischarged:" ] ++
    [ "    " ++ intercalate "  =  " (nub (map (render . snd) rs)) ] ++
    [ "  kept, not broken, and handed to whatever can discharge it"
    , "  (AHIMSA_SUTRA_VISTARA §१७: यत् न विभजते तत् रक्ष्यते)." ]
  Aphala why ->
    [ "NO BIRTH -- " ++ why ]
