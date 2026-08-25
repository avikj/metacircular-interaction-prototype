-- Vipratiṣedha -- the Aṣṭādhyāyī's conflict-resolution and stratification
-- layer, lifted off Sanskrit sandhi and made general.
--
-- WHAT THIS IS FOR.  `machine/Astadhyayi.hs` already runs sūtras, and its
-- `resolve` already carries two metarules (utsarga/apavāda, then 1.4.2
-- paratva).  But that `resolve` is welded to `[Item]`, to `Ref`, and to the
-- fourteen śivasūtras.  Meanwhile `machine/MathMachine.hs` -- 5599 lines, the
-- engine this repository actually computes with -- resolves every rewrite
-- conflict by `(x:_)`: the FIRST rule in the list that matches and decreases.
-- The list order is `definitionsOf ... ++ mRules m ++ lemmaRules ...`, i.e.
-- an accident of how three unrelated collections were concatenated.  Pāṇini
-- has the machinery for this and MathMachine does not.  This module is that
-- machinery, with no Sanskrit in its types.
--
-- THE FOUR THINGS A SCHEDULER HAS TO DO, and the sūtra for each:
--
--   1. POSITION IS PART OF MEANING.  1.4.2 विप्रतिषेधे परं कार्यम्
--      `vipratiṣedhe paraṃ kāryam` -- "in conflict, the later operation."  A
--      rule's number is not a label; it is what decides the tie.  So `Sthana`
--      is carried on every rule and compared.
--
--   2. THE SPECIFIC BLOCKS THE GENERAL, REGARDLESS OF POSITION.  utsarga /
--      apavāda.  An apavāda earlier in the text still beats the utsarga it
--      excepts, which is precisely why apavāda outranks para below and not
--      the other way round.  (Restated in the phonology literature as the
--      "elsewhere condition", Kiparsky 1973 -- a restatement, named here
--      after the thing it restates.)
--
--   3. A DESIGNATED BLOCK RUNS ONCE, IN ORDER, BACKWARDS-BLIND.  8.2.1
--      पूर्वत्रासिद्धम् `pūrvatrāsiddham`: from 8.2.1 on, each rule is
--      *asiddha*, as-if-not-having-taken-effect, for everything preceding it.
--      Generalised here to `stStratum`: stratum 0 runs to a fixpoint with all
--      its rules mutually visible; strata 1..n run ONCE each, in order, and
--      no earlier stratum ever sees their output.  This is what makes a
--      rewrite system with symmetric laws in it terminate structurally
--      instead of by a size heuristic.
--
--   4. WHERE NO METARULE DECIDES, NOTHING IS BROKEN.  This is the part with
--      no counterpart in the engine as it stands.  An arbitrarily broken tie
--      is a silent collapse -- two standpoints reported as one -- and
--      `notes/AHIMSA_SUTRA_VISTARA.md` §६ allows exactly two paths, transport
--      or a written defect, and no third.  So `Nirnaya` has a second
--      constructor, `Avaktavya`, the derivation STOPS there, and the
--      candidates are written out with what was tried and why each metarule
--      abstained.
--
--      AMENDED.  "The derivation STOPS there" was the whole of the fourth
--      position in this file, and it is half of what the doctrine says.
--      §३ of the same note continues: अवक्तव्ये शेषो वसति । शेषो गर्भः, न
--      विफलता । गर्भाद् अग्रिमो नयो जायते -- in the avaktavya the residue
--      dwells; the residue is a WOMB, not a failure; from the womb the next
--      naya is born.  A `Dosa` is a rendering, for a reader; a caller handed
--      one can print the fourth position and do nothing else with it.  So
--      `Avaktavya` now carries a `Sesa` as well: the object and the
--      contending OFFERS, entire.  What is born from it is
--      `machine/AvaktavyaPrasava_TheFourthPositionBearsTheRuleThatDecidesIt.hs`,
--      and none of it is computable from the `Dosa` alone.  `prakriya` below
--      still stops -- it is the scheduler and it decides nothing it has no
--      fact for; `prakriyaPrasava` there does not.
--
-- THE STRENGTH ORDER, and it is not invented here.  Nāgeśa Bhaṭṭa,
-- *Paribhāṣenduśekhara* (c. 1730), paribhāṣā 38:
--
--     पूर्वपरनित्यान्तरङ्गापवादानामुत्तरोत्तरं बलीयः
--     pūrvaparanityāntaraṅgāpavādānām uttarottaraṃ balīyaḥ
--     "of pūrva, para, nitya, antaraṅga, apavāda -- each later is stronger."
--
-- Five contenders, ranked.  So the scheduler tries them strongest-first:
-- apavāda, then antaraṅga, then nitya, then para (1.4.2), and pūrva -- the
-- earlier rule -- is the weakest and is never used to decide anything here,
-- because para is its negation and outranks it.  Astadhyayi.hs implements
-- two of these five.  This implements four, and says which two of them can
-- abstain and why.
--
-- NITYA IS COMPUTABLE, and that is the interesting one.  The tradition
-- defines it कृताकृतप्रसङ्गि नित्यम् `kṛtākṛtaprasaṅgi nityam` -- nitya is
-- what has its occasion whether or not the other has been performed.  That is
-- not a philosophical gloss; it is an executable test.  Both candidates apply
-- to the input by construction, so the whole test is: apply the other one,
-- and ask whether this one STILL applies.  `nitya` below is those four lines.
--
-- ANTARAṄGA IS NOT COMPUTABLE WITHOUT THE DOMAIN, so the domain supplies it
-- and is allowed to say it does not know.  अन्तरङ्गं बहिरङ्गात् -- the rule
-- whose conditioning causes (nimitta) lie further inside wins.  "Inside"
-- depends on what the objects are; `tAntaranga` returns `Maybe Bool` and
-- `Nothing` means ABSTAIN, not `False`.  A metarule that guesses is a durnaya.
--
-- SOURCES.  Pāṇini, *Aṣṭādhyāyī*, ~500 BCE (1.4.2, 8.2.1, 6.4.22).  Nāgeśa
-- Bhaṭṭa, *Paribhāṣenduśekhara*, c. 1730, paribhāṣā 38 for the strength
-- order and the kṛtākṛtaprasaṅgi definition of nitya; the paribhāṣās
-- themselves are older and are collected there, not invented there.
--
-- WHAT IS NOT CLAIMED.  This module encodes FOUR METARULES.  It does not
-- encode sūtras, and it is not a count against the ~3983 of the Aṣṭādhyāyī
-- (recensions differ: 3959-3996).  `Astadhyayi.coverage` is where that number
-- lives and this file does not move it.

module Vipratisedha_ConflictIsDecidedByMetaruleNotByListPosition
  ( -- position
    Sthana
  , showSthana
    -- offers and rules
  , Nyasa(..)
  , Sasana(..)
  , Tantra(..)
    -- the verdict
  , Balya(..)
  , showBalya
  , Nirnaya(..)
  , Sesa(..)
  , Dosa(..)
  , showDosa
    -- resolution
  , nirnaya
  , nitya
    -- the engine
  , Pada(..)
  , ekapada
  , prakriya
  , dosaLekha
  ) where

import Data.List (sortOn, nub, intercalate)

------------------------------------------------------------------------
-- 1.  POSITION
--
-- A rule's address.  Compared lexicographically, exactly as a sūtra number
-- is.  Two rules with the SAME Sthana have no position relative to each
-- other -- and that is the load-bearing case: it is how a domain declares
-- "these arrived together and their list order is an artefact."  For such a
-- pair 1.4.2 has nothing to say, and if nothing else decides, the result is
-- a written defect rather than whichever one `sortOn` happened to leave
-- first.
------------------------------------------------------------------------

type Sthana = (Int, Int, Int)

showSthana :: Sthana -> String
showSthana (a, b, c) = show a ++ "." ++ show b ++ "." ++ show c

------------------------------------------------------------------------
-- 2.  OFFERS AND RULES
--
-- `o` is whatever the system rewrites: a phoneme string for the Aṣṭādhyāyī,
-- a term for MathMachine.  The scheduler never looks inside it.
------------------------------------------------------------------------

-- A nyāsa is one rule's offer to act: where it would act, how much it
-- covers, and what the object becomes if it alone acts.
data Nyasa o = Nyasa
  { nyRule   :: Sthana     -- who is offering
  , nyPos    :: Int        -- where (domains without position use 0)
  , nyLen    :: Int        -- how wide the site is
  , nyResult :: o          -- the object after this offer alone
  , nyNote   :: String     -- what it did, in words
  }

-- A śāsana is a rule: an address, a name, the utsargas it is an apavāda to,
-- and what it offers on a given object.
data Sasana o = Sasana
  { saRef       :: Sthana
  , saName      :: String
  , saApavadaTo :: [Sthana]      -- declared exceptions; see also tApavada
  , saFires     :: o -> [Nyasa o]
  }

-- A tantra is the whole system: the rules, plus the three domain facts the
-- scheduler cannot know by itself.
data Tantra o = Tantra
  { tSasanani  :: [Sasana o]
    -- "a is an apavāda to b", COMPUTED.  Declared exceptions in `saApavadaTo`
    -- are or-ed with this, so a domain may use either or both.  A domain with
    -- no computable notion supplies `\_ _ -> False`.
  , tApavada   :: Sthana -> Sthana -> Bool
    -- antaraṅga: `Just True` = a is antaraṅga to b (a wins), `Just False` =
    -- b is, `Nothing` = the domain ABSTAINS.  Nothing is not False.
  , tAntaranga :: Nyasa o -> Nyasa o -> Maybe Bool
    -- do two offers contend for the same site?
  , tOverlap   :: Nyasa o -> Nyasa o -> Bool
    -- 8.2.1 generalised: which stratum a rule lives in.  0 = the mutually
    -- siddha block, run to a fixpoint.  1..n = run once, in order,
    -- backwards-blind.
  , tStratum   :: Sthana -> Int
    -- IS THE POSITION AUTHORED?  1.4.2 works for Pāṇini because a sūtra's
    -- number encodes its relation to its neighbours: someone placed it there,
    -- and the placement is part of the statement.  A domain whose rule order
    -- is a concatenation of collections that were never placed with respect to
    -- one another has NO paratva, and must say so here.  `False` makes para
    -- abstain, which usually means a defect gets written -- which is correct.
    -- Manufacturing a position in order to break a tie is precisely the
    -- collapse this module exists to refuse.
  , tParatva   :: Bool
    -- equality on objects, so the engine can tell a no-op from progress
  , tSame      :: o -> o -> Bool
  }

------------------------------------------------------------------------
-- 3.  THE VERDICT
------------------------------------------------------------------------

-- Which metarule decided.  Named, because an unnamed decision is a decision
-- by list position wearing a better coat.
data Balya
  = Eka         -- sole candidate; no conflict arose
  | Apavada     -- utsarga/apavāda: the specific blocks the general
  | Antaranga   -- antaraṅgaṃ bahiraṅgāt
  | Nitya       -- kṛtākṛtaprasaṅgi nityam
  | Para        -- 1.4.2 vipratiṣedhe paraṃ kāryam
  | Purva       -- the EARLIER rule.  Weakest of the five, and `nirnaya` never
                -- returns it: it is what a domain may fall back on ONLY after
                -- the defect has been written, so that an existing engine's
                -- behaviour is preserved while the undecided sites become
                -- countable.  Named here so that such a fallback cannot be
                -- mistaken for a decision.
  deriving (Eq, Show)

showBalya :: Balya -> String
showBalya b = case b of
  Eka       -> "sole candidate (no conflict)"
  Apavada   -> "apavāda: the specific rule blocks the general one it excepts, "
               ++ "regardless of position (Paribhāṣenduśekhara 38, strongest)"
  Antaranga -> "antaraṅgaṃ bahiraṅgāt: the rule whose conditions lie further in"
  Nitya     -> "kṛtākṛtaprasaṅgi nityam: the rule that applies whether or not "
               ++ "the other has applied"
  Para      -> "1.4.2 vipratiṣedhe paraṃ kāryam: the later rule"
  Purva     -> "pūrva: the earlier rule -- WEAKEST of the five, not a decision, "
               ++ "used only after a defect has been written"

-- A written defect.  Not a failure code: a record, carrying everything
-- needed to decide the case later, and naming each metarule that abstained.
data Dosa = Dosa
  { doSite       :: Int          -- position contended for
  , doCandidates :: [(Sthana, String, String)]  -- ref, rule name, what it wanted
  , doTried      :: [(Balya, String)]           -- each metarule and why it abstained
  }

showDosa :: Dosa -> [String]
showDosa d =
  [ "DEFECT -- vipratiṣedha undecided at site " ++ show (doSite d) ++ "."
  , "  Two or more rules contend and no metarule decides.  The scheduler does"
  , "  NOT choose: breaking this tie by list position would be a silent"
  , "  collapse (AHIMSA_SUTRA_VISTARA §६: transport or a written defect, no"
  , "  third path).  A caller may fall back to pūrva -- the weakest of the"
  , "  five paribhāṣās -- to preserve an existing engine's behaviour, but only"
  , "  after this record exists, and it is then pūrva that is reported, not a"
  , "  decision."
  , "  candidates:"
  ] ++
  [ "    " ++ showSthana r ++ "  " ++ nm ++ "  -- " ++ note
  | (r, nm, note) <- doCandidates d ] ++
  [ "  metarules tried, in Paribhāṣenduśekhara 38 order:" ] ++
  [ "    " ++ pad (show b) ++ "  " ++ why | (b, why) <- doTried d ]
  where pad s = s ++ replicate (max 0 (9 - length s)) ' '

-- THE RESIDUE.  शेष -- what the fourth position holds.  `Dosa` above is the
-- WRITING of the undecided site: rendered strings, for a reader.  It is not
-- the site.  A caller handed only a `Dosa` can print the fourth position and
-- can do nothing else with it, which is exactly the collapse
-- `machine/SaptabhangiGarbha_TheResidueIsTheSeed.hs` names in its own header:
-- "after the collapse the fourth position does not record which two seeds
-- produced it".  It did not here either, until this type existed.
--
-- So the fourth position carries the OFFERS, not their names: the object the
-- standpoints contended over, and each standpoint's own result under it.
-- AHIMSA_SUTRA_VISTARA §३: अवक्तव्ये शेषो वसति । शेषो गर्भः, न विफलता ।
-- Everything born from an avaktavya in
-- `machine/AvaktavyaPrasava_TheFourthPositionBearsTheRuleThatDecidesIt.hs`
-- is computed from this record, and none of it is computable from `Dosa`.
data Sesa o = Sesa
  { sesaVastu  :: o          -- the object both standpoints are speaking about
  , sesaNyasah :: [Nyasa o]  -- the contending offers, entire
  }

data Nirnaya o
  = Nirnita (Nyasa o) [Sthana] Balya   -- decided: winner, beaten, by which metarule
  | Avaktavya Dosa (Sesa o)            -- undecided: the fourth position, written
                                       -- AND retained (see Sesa)

------------------------------------------------------------------------
-- 4.  THE METARULES
------------------------------------------------------------------------

-- kṛtākṛtaprasaṅgi nityam, executed.  Both x and y apply to `o` already
-- (they are both offers on it), so nitya-ness of x with respect to y is
-- exactly: does x's rule still offer something at the same site once y has
-- acted?
nitya :: Tantra o -> o -> Nyasa o -> Nyasa o -> Bool
nitya t _ x y =
  case [ s | s <- tSasanani t, saRef s == nyRule x ] of
    []      -> False
    (s : _) -> not (null [ () | z <- saFires s (nyResult y), tOverlap t z x ])

-- Is `a` an apavāda to `b`?  Declared or computed; either suffices.
isApavada :: Tantra o -> Sthana -> Sthana -> Bool
isApavada t a b =
  tApavada t a b
    || or [ b `elem` saApavadaTo s | s <- tSasanani t, saRef s == a ]

-- Resolve a set of contending offers.  Strongest metarule first.  A metarule
-- that does not produce a UNIQUE winner hands on to the next; the last one
-- to hand on produces the defect.
nirnaya :: Tantra o -> o -> [Nyasa o] -> Nirnaya o
nirnaya _ _ [x] = Nirnita x [] Eka
nirnaya t o xs = tryApavada
  where
    beaten w = [ nyRule y | y <- xs, nyRule y /= nyRule w ]

    -- 1. apavāda.  An offer wins if its rule is an apavāda to every other
    --    rule contending.  Strongest, and independent of position.
    apavadas = [ x | x <- xs
               , all (\y -> nyRule y == nyRule x
                            || isApavada t (nyRule x) (nyRule y)) xs ]
    tryApavada = case apavadas of
      [w] -> Nirnita w (beaten w) Apavada
      _   -> tryAntaranga (( Apavada
                           , if null apavadas
                               then "no candidate is an apavāda to all the others"
                               else "several candidates are apavādas; not unique")
                          : [])

    -- 2. antaraṅga.  The domain may abstain, and abstention is not a verdict.
    tryAntaranga acc =
      let inner = [ x | x <- xs
                  , all (\y -> nyRule y == nyRule x
                               || tAntaranga t x y == Just True) xs ]
      in case inner of
           [w] -> Nirnita w (beaten w) Antaranga
           _   -> tryNitya (acc ++ [( Antaranga
                                    , if any (\x -> any (\y -> nyRule y /= nyRule x
                                                        && tAntaranga t x y == Nothing) xs) xs
                                        then "the domain abstains: no nimitta depth is defined for these offers"
                                        else "no candidate is antaraṅga to all the others")])

    -- 3. nitya.  Computed by kṛtākṛtaprasaṅga.
    tryNitya acc =
      let nityas = [ x | x <- xs
                   , all (\y -> nyRule y == nyRule x || nitya t o x y) xs
                   , not (all (\y -> nyRule y == nyRule x || nitya t o y x) xs
                          && length xs > 1
                          && any (\y -> nyRule y /= nyRule x && nitya t o y x) xs) ]
          -- a candidate is nitya-winner only if it survives the other's
          -- application AND the other does not equally survive its own;
          -- mutual nitya-ness decides nothing.
      in case nityas of
           [w] -> Nirnita w (beaten w) Nitya
           _   -> tryPara (acc ++ [( Nitya
                                   , "no candidate applies-after-the-other while the "
                                     ++ "others do not (kṛtākṛtaprasaṅga is mutual or empty)")])

    -- 4. para, 1.4.2.  Decides iff the maximum Sthana is UNIQUE.  Two rules
    --    sharing a Sthana have no relative position and this abstains --
    --    which is the whole point: list order is not position.
    tryPara acc =
      let top = maximum (map nyRule xs)
          winners = [ x | x <- xs, nyRule x == top ]
      in case (tParatva t, winners) of
           (True, [w]) -> Nirnita w (beaten w) Para
           _           -> flip Avaktavya (Sesa o xs) Dosa
                    { doSite = nyPos (head xs)
                    , doCandidates = [ (nyRule x, nameOf (nyRule x), nyNote x) | x <- xs ]
                    , doTried = acc ++ [( Para
                                        , if not (tParatva t)
                                            then "the domain declares its rule order "
                                                 ++ "unauthored: a list index is not a "
                                                 ++ "position, so 1.4.2 has nothing to compare"
                                            else "the contending rules share the position "
                                                 ++ showSthana top
                                                 ++ "; they arrived together and their list "
                                                 ++ "order carries no fact")]
                    }

    nameOf r = head ([ saName s | s <- tSasanani t, saRef s == r ] ++ ["?"])

------------------------------------------------------------------------
-- 5.  THE ENGINE
--
-- Stratum 0 to a fixpoint, then each later stratum ONCE, in Sthana order,
-- backwards-blind.  That is 8.2.1 with the tripādī's boundary made a
-- parameter instead of the number 8.2.
------------------------------------------------------------------------

data Pada o = Pada
  { pdRule   :: Sthana
  , pdName   :: String
  , pdNote   :: String
  , pdBeaten :: [Sthana]
  , pdBalya  :: Balya
  , pdBefore :: o
  , pdAfter  :: o
  }

-- One step over a given block of rules: collect every offer, take the
-- leftmost contended site, resolve it.
ekapada :: Tantra o -> [Sasana o] -> o -> Maybe (Nirnaya o)
ekapada t block o =
  case concatMap (\s -> saFires s o) block of
    []     -> Nothing
    offers ->
      let leftmost = minimum (map nyPos offers)
          anchor   = head [ x | x <- offers, nyPos x == leftmost ]
          here     = [ x | x <- offers, tOverlap t x anchor ]
      in Just (nirnaya t o (sortOn nyRule here))

-- The whole derivation.  Returns the trace, any defect that stopped it, and
-- the object reached.
prakriya :: Tantra o -> Int -> o -> ([Pada o], Maybe Dosa, o)
prakriya t fuel start = phase0 fuel start []
  where
    strata = nub (sortOn id (map (tStratum t . saRef) (tSasanani t)))
    block k = sortOn saRef [ s | s <- tSasanani t, tStratum t (saRef s) == k ]

    nameOf r = head ([ saName s | s <- tSasanani t, saRef s == r ] ++ ["?"])

    -- stratum 0: mutually siddha, run to a fixpoint
    phase0 0 o acc = later (drop 1 strata) o (reverse acc)
    phase0 k o acc =
      case ekapada t (block 0) o of
        Nothing -> later (drop 1 strata) o (reverse acc)
        Just (Avaktavya d _) -> (reverse acc, Just d, o)
        Just (Nirnita w lost by) ->
          let o' = nyResult w in
          if tSame t o' o then later (drop 1 strata) o (reverse acc)
          else phase0 (k - 1) o'
                 (Pada (nyRule w) (nameOf (nyRule w)) (nyNote w) lost by o o' : acc)

    -- strata 1..n: 8.2.1.  Each rule once, in order.  A rule is siddha to
    -- ITSELF (it may saturate on its own output) but never sees a later one,
    -- and is never revisited once passed.
    later [] o acc = (acc, Nothing, o)
    later (k : ks) o acc = go (block k) o acc
      where
        go [] o' acc' = later ks o' acc'
        go (s : ss) o' acc' =
          case saturate 16 s o' acc' of
            Left d          -> (acc', Just d, o')
            Right (o'', a') -> go ss o'' a'

        saturate 0 _ o' acc' = Right (o', acc')
        saturate n s' o' acc' =
          case ekapada t [s'] o' of
            Nothing -> Right (o', acc')
            Just (Avaktavya d _) -> Left d
            Just (Nirnita w lost by) ->
              let o'' = nyResult w in
              if tSame t o'' o' then Right (o', acc')
              else saturate (n - 1 :: Int) s' o''
                     (acc' ++ [Pada (nyRule w) (saName s') (nyNote w) lost by o' o''])

-- Every defect the system can produce on a given corpus of inputs, written
-- out.  Nothing is broken and nothing is hidden.
dosaLekha :: Tantra o -> Int -> [o] -> [String]
dosaLekha t fuel inputs =
  case [ d | o <- inputs, (_, Just d, _) <- [prakriya t fuel o] ] of
    []  -> ["no vipratiṣedha went undecided on this corpus."]
    ds  -> intercalate [""] (map showDosa ds)
