-- GhanaPatha_TheFramesDisagreeAndTheDisagreementIsThePosition
--
-- घनपाठः.  Syndrome checking for the derivation engine: the same form
-- derived in several independent frames, and the frames compared against
-- each other rather than against a stored answer.
--
-- THE CONSTRUCTION, and where it comes from.  The Vedic recitation schools
-- transmit a saṃhitā text not once but in permuted orders — पदपाठ (word by
-- word), क्रमपाठ (1-2, 2-3, 3-4), जटापाठ (1-2, 2-1, 1-2), घनपाठ (1-2, 2-1,
-- 1-2-3, 3-2-1, 1-2-3) — so that every word is recited many times, in
-- different neighbourhoods, and in both directions.  The vikṛti-pāṭhas are
-- described in the Prātiśākhya literature and its commentaries (Ṛgveda-
-- prātiśākhya; the Caraṇavyūha lists the eight vikṛtis); the recitation is
-- carried on human carriers with no written master copy, and the schools
-- transmitted the Ṛgveda across the interval in which its language stopped
-- being spoken and its meaning stopped being available to most reciters.
--
-- The property that does the work: a carrier who has normalised a sound has
-- to commit the SAME normalisation in every frame, and the frames put the
-- sound in different neighbourhoods and different directions, so a
-- normalisation that is conditioned on neighbourhood shows up as two
-- recitations by ONE reciter in ONE session that do not agree.  Bare
-- repetition does not have this property — a carrier repeats his own error
-- identically.  The redundancy has to be PERMUTED.  And no step of it
-- consults a master copy, because there is no master copy: the defect is
-- located by inconsistency between frames.
--
-- WHAT IS AND IS NOT CLAIMED.  No claim that the recitation schools were
-- doing what this file does, or that anything below is Pāṇinian doctrine.
-- The sūtras run here are Pāṇini's (Aṣṭādhyāyī, ~500 BCE), encoded in
-- `Astadhyayi.hs`; the frame discipline is the recitation schools'.  What is
-- claimed is one thing: the machine currently trusts a single derivation,
-- and a single derivation cannot report a defect, only a result.
--
-- THE FRAMES (each produces a reading; readings are compared, never
-- validated):
--
--   क्रम  krama       the incumbent: Astadhyayi.deriveTrace, whole form at
--                    once, phase A to a fixpoint then the tripādī in order.
--   व्युत्क्रम vyutkrama  an INDEPENDENT re-implementation of the engine in this
--                    file, run with the sūtra list REVERSED.  1.4.2
--                    vipratiṣedhe paraṃ kāryam says the conflict is decided
--                    by the sūtra's number.  If it is, list order cannot
--                    reach the output.  The incumbent's `stepA` picks
--                    `head` of the candidates at the leftmost site, which is
--                    list order; this frame is what makes that visible.
--   दक्षिणतः dakṣiṇataḥ same independent engine, canonical order, scanning for
--                    the RIGHTMOST applicable site instead of the leftmost.
--                    The saṃhitā rules of 6.1 are local to a juncture, so
--                    scan direction should not reach the output either.
--   जटा   jaṭā        accretive left to right: derive juncture 1, then feed
--                    the RESULT into juncture 2, and so on.  Compared with
--                    krama, which sees all junctures at once.
--   घन    ghana       accretive right to left: the same junctures combined
--                    in the opposite order.
--   प्रतिलोम pratiloma  the trace read BACKWARDS from the surface form: for
--                    each recorded step, re-fire the named sūtra on the
--                    recorded before-state and check it produces the
--                    recorded after-state, and that step k's after-state is
--                    step k+1's before-state.  This asks whether the trace
--                    is a WITNESS or only a log.
--   असिद्ध asiddha     the frame that already existed: `asiddhaAudit`, the
--                    rules that would have fired on the tripādī's output and
--                    were refused by 8.2.1.  Cross-checked here rather than
--                    printed: a refusal by a sūtra of section A is licensed
--                    by 8.2.1 only if some tripādī rule actually fired.  If
--                    none did, phase A did not reach its fixpoint and the
--                    refusal has no licence.
--
-- WHAT A SYNDROME IS.  Never a boolean and never a verdict.  A `Syndrome`
-- carries a POSITION (which step, which juncture, which sūtra, or the
-- surface), the two FRAMES that disagree, and the two READINGS at that
-- position.  Nobody holds a correct answer; the pair is the finding.  This
-- is the same discipline as
-- `Uttara_SamkramanaOrDosalekhaNeverABareBoolean.hs`: an unwritten defect
-- is the loss, and `True`/`False` is a defect that was not written.
--
-- CONCORDANCE IS ALSO REPORTED, and it is reported as a list of frames that
-- agreed and what they agreed on — not as `no syndromes`.  A frame set that
-- agrees vacuously (one frame, or frames that share the defect) is a weaker
-- fact than a frame set that agrees after disagreeing about the route, and
-- collapsing both to a green tick is the collapse this repository keeps
-- finding.
--
-- COMMON MODE, stated because the frames are only as independent as their
-- implementations.  `vyutkrama` and `dakṣiṇataḥ` re-implement rewrite
-- application, conflict resolution and the two phases HERE, from the
-- exported `fires`/`apavadaTo`/`num` alone, so a bug in the incumbent's
-- `applyRw`, `resolve`, `stepA` or `phaseB` is visible to them.  What they
-- share with the incumbent is the SŪTRAS themselves: `fires` is one
-- implementation of each rule, and an error inside a rule body is invisible
-- to every frame here.  That is the corruption class this construction does
-- not detect, and it is the same class the recitation schools do not detect
-- — a text corrupted before it entered the frames is transmitted perfectly.
--
-- NO FLOATING POINT, no measurement, no fitted anything.  Every claim here
-- is a finite comparison of finite derivations.

module GhanaPatha_TheFramesDisagreeAndTheDisagreementIsThePosition
  ( Frame(..)
  , frames
  , Position(..)
  , Anuvacana(..)
  , Syndrome(..)
  , Concord(..)
  , Patha(..)
    -- the independent engine (not the incumbent's)
  , Scan(..)
  , Order(..)
  , deriveIn
    -- the frames, individually
  , readKrama
  , readVyutkrama
  , readDaksinatah
  , readJata
  , readGhana
  , pratilomaSyndromes
  , pratilomaUnder
  , asiddhaSyndromes
    -- the whole recitation
  , patha
  , syndromes
  , showSyndrome
  , showPatha
  , selfTestGhana
  ) where

import Astadhyayi
import Data.List (sortOn, intercalate, nub)

------------------------------------------------------------------------
-- 1.  POSITION, READING, SYNDROME
--
-- A syndrome localises.  It does not judge.
------------------------------------------------------------------------

data Position
  = AtSurface                 -- the two frames end at different forms
  | AtStep Int                -- the k-th step of the derivation (0-based)
  | AtJuncture Int            -- the j-th pada boundary of the input
  | AtSutra Ref               -- a named sūtra
  | AtInput                   -- the frame could not start
  deriving (Eq, Show)

showPosition :: Position -> String
showPosition AtSurface      = "surface"
showPosition (AtStep k)     = "step " ++ show k
showPosition (AtJuncture j) = "juncture " ++ show j
showPosition (AtSutra r)    = "sūtra " ++ showRef r
showPosition AtInput        = "input"

showRef :: Ref -> String
showRef (a, b, c) = show a ++ "." ++ show b ++ "." ++ show c

data Frame = Frame
  { frName   :: String        -- the recitation school's name for the order
  , frGloss  :: String        -- what is permuted, in one line
  } deriving (Eq, Show)

frames :: [Frame]
frames =
  [ Frame "krama"      "whole form at once, sūtras in the order given"
  , Frame "vyutkrama"  "independent engine, sūtra list reversed"
  , Frame "dakṣiṇataḥ" "independent engine, rightmost site first"
  , Frame "jaṭā"       "junctures accreted left to right"
  , Frame "ghana"      "junctures accreted right to left"
  , Frame "pratiloma"  "trace replayed against the sūtras it names, chain walked back"
  , Frame "asiddha"    "rules refused on the tripādī's output (8.2.1)"
  ]

-- An anuvacana is what one frame recites: a surface form and the route it took.
data Anuvacana = Anuvacana
  { rdFrame   :: String
  , rdSurface :: String
  , rdRoute   :: [(Ref, String)]    -- sūtra fired, form after it
  } deriving (Eq, Show)

-- The finding.  Two frames, one position, two readings at it.  There is no
-- field for "which is right", because no frame here holds a master copy.
data Syndrome = Syndrome
  { syPosition :: Position
  , syFrameA   :: String
  , syFrameB   :: String
  , syReadingA :: String
  , syReadingB :: String
  , sySays     :: String            -- what the disagreement means, mechanically
  } deriving (Eq, Show)

-- Agreement, carried explicitly, with what was agreed and by whom.
data Concord = Concord
  { coFrames  :: [String]
  , coSurface :: String
  , coRoutes  :: Int                -- how many DISTINCT routes reached it
  } deriving (Eq, Show)

data Patha = Patha
  { paInput     :: String
  , paReadings  :: [Anuvacana]
  , paSyndromes :: [Syndrome]
  , paConcord   :: Concord
  } deriving (Eq, Show)

------------------------------------------------------------------------
-- 2.  AN INDEPENDENT ENGINE
--
-- Re-implemented here from `fires`, `num`, `apavadaTo` and `tripadi` alone.
-- It shares no code with `Astadhyayi.deriveTrace`; that is the point.  Two
-- reciters, one text.
------------------------------------------------------------------------

data Scan  = Vamatah | Daksinatah deriving (Eq, Show)   -- leftmost / rightmost site
data Order = Yatha   | Viparita   deriving (Eq, Show)   -- as given / reversed

-- Apply one rewrite.  Independent of the incumbent's `applyRw`, and written
-- by splitting rather than by take/drop arithmetic so that an off-by-one in
-- either is not shared.
applyOne :: [Item] -> Rewrite -> [Item]
applyOne xs r =
  let (before, rest) = splitAt (rPos r) xs
      after          = drop (rLen r) rest
  in before ++ rNew r ++ after

clash :: Rewrite -> Rewrite -> Bool
clash a b = not (rPos a + rLen a <= rPos b || rPos b + rLen b <= rPos a)

-- utsarga/apavāda, then 1.4.2.  Deterministic in the CANDIDATE SET, never in
-- the list: where several apavādas are available the later one is taken, by
-- the same metarule, so this function cannot see the order it was handed.
decide :: [Rewrite] -> (Rewrite, [Ref], String)
decide []  = error "decide: empty candidate set"
decide [r] = (r, [], "sole candidate")
decide rs =
  let apavadas = [ r | r <- rs, any (\o -> rSutra o `elem` apavadaTo (sutraOf (rSutra r))) rs ]
      later a b = if rSutra b > rSutra a then b else a
      pick xs   = foldl later (head xs) (tail xs)
      w = case apavadas of
            [] -> pick rs
            as -> pick as
      why = case apavadas of
              [] -> "1.4.2 vipratiṣedhe paraṃ kāryam: the later sūtra"
              _  -> "apavāda blocks the utsarga (elsewhere condition)"
  in (w, [ rSutra o | o <- rs, rSutra o /= rSutra w ], why)

sutraOf :: Ref -> Sutra
sutraOf r = case [ s | s <- sutras, num s == r ] of
              (s : _) -> s
              []      -> Sutra r "?" "?" Vidhi [] (const [])

-- Every rule firing in this file goes through ONE adapter, so that a change
-- to the incumbent's rule interface lands in one place rather than in five.
-- (Astadhyayi.hs is under concurrent revision as this is written: an anuvrtti
-- layer there is changing `fires` to take the sutra's READING -- what it says
-- plus what it inherits -- before its input.  When that lands, this becomes
-- `firesOn s xs = fires s (readingUnder [] s) xs` and nothing else moves.)
firesOn :: Sutra -> [Item] -> [Rewrite]
firesOn = fires

-- The two strata, computed here from `tripadi`, not imported.
straA, straB :: [Sutra]
straA = [ s | s <- sutras, not (tripadi (num s)) ]
straB = sortOn num [ s | s <- sutras, tripadi (num s) ]

-- One step of the mutually-siddha stratum, under a scan direction and a
-- presentation order of the rule list.
oneStep :: Scan -> Order -> [Item] -> Maybe (Rewrite, [Ref], String)
oneStep sc ord xs =
  let rules = case ord of { Yatha -> straA ; Viparita -> reverse straA }
      cands = concat [ firesOn s xs | s <- rules ]
  in case cands of
       [] -> Nothing
       _  ->
         let site = case sc of
                      Vamatah    -> minimum (map rPos cands)
                      Daksinatah -> maximum (map rPos cands)
             anchors = [ r | r <- cands, rPos r == site ]
             anchor  = foldl (\a b -> if rSutra b > rSutra a then b else a)
                             (head anchors) (tail anchors)
             here    = [ r | r <- cands, clash r anchor ]
         in Just (decide here)

-- The whole derivation in one frame.  Phase A to a fixpoint, then the
-- tripādī once each in numeric order (8.2.1 pūrvatrāsiddham), a rule being
-- siddha to itself and so saturating on its own output.
deriveIn :: Scan -> Order -> [Item] -> ([(Ref, String)], [Item])
deriveIn sc ord start = phaseB (phaseA (0 :: Int) start [])
  where
    phaseA k xs acc
      | k > 64 = (reverse acc, xs)
      | otherwise = case oneStep sc ord xs of
          Nothing -> (reverse acc, xs)
          Just (w, _, _) ->
            let ys = applyOne xs w
            in if ys == xs then (reverse acc, xs)
                           else phaseA (k + 1) ys ((rSutra w, render ys) : acc)

    phaseB (acc, xs0) = go straB xs0 acc
      where
        go []       xs a = (a, xs)
        go (s : ss) xs a = let (xs', steps) = sat s xs [] in go ss xs' (a ++ steps)
        sat s xs a =
          case firesOn s xs of
            []      -> (xs, reverse a)
            (r : _) ->
              let ys = applyOne xs r
              in if ys == xs || length a > 16
                   then (xs, reverse a)
                   else sat s ys ((num s, render ys) : a)

------------------------------------------------------------------------
-- 3.  THE FRAMES
------------------------------------------------------------------------

readKrama :: [Item] -> Anuvacana
readKrama xs =
  let (steps, final) = deriveTrace xs
  in Anuvacana "krama" (render final) [ (stSutra s, stAfter s) | s <- steps ]

readVyutkrama :: [Item] -> Anuvacana
readVyutkrama xs =
  let (route, final) = deriveIn Vamatah Viparita xs
  in Anuvacana "vyutkrama" (render final) route

readDaksinatah :: [Item] -> Anuvacana
readDaksinatah xs =
  let (route, final) = deriveIn Daksinatah Yatha xs
  in Anuvacana "dakṣiṇataḥ" (render final) route

-- The junctures of an input, as the pada-separated blocks between them.
blocks :: [Item] -> [[Item]]
blocks xs = case break (== Pada) xs of
  (b, [])       -> [b]
  (b, _ : rest) -> b : blocks rest

-- Accretive frames.  Two padas at a time, the partial result carried forward
-- as ITEMS and never re-tokenized from a string, so the frame tests the engine
-- and not the parser.  A single-block input still has to be DERIVED -- one
-- pada is a recitation too, and the tripadi runs on it -- which is what the
-- `one` case is; leaving it underived made the frame recite its own input back,
-- and the syndrome that produced was about this file, not about the grammar.
readJata :: [Item] -> Anuvacana
readJata xs =
  let joinL a b = snd (deriveTrace (a ++ [Pada] ++ b))
      one b     = snd (deriveTrace b)
      final = case blocks xs of
                []        -> []
                [b]       -> one b
                (b : bs)  -> foldl joinL (one b) bs
  in Anuvacana "jaṭā" (render final) []

readGhana :: [Item] -> Anuvacana
readGhana xs =
  let joinR a b = snd (deriveTrace (a ++ [Pada] ++ b))
      one b     = snd (deriveTrace b)
      final = case reverse (blocks xs) of
                []        -> []
                [b]       -> one b
                (b : bs)  -> foldl (flip joinR) (one b) bs
  in Anuvacana "ghana" (render final) []

------------------------------------------------------------------------
-- 4.  PRATILOMA — the trace read backwards, and re-fired in the item domain
--
-- A trace is a claim: "sūtra r took THIS form to THAT one".  Reading it
-- forwards cannot test the claim, because the forward reading is what
-- produced it.  Two things are asked here instead, and they are different
-- questions:
--
--   (a) CHAIN, walked from the surface backwards.  The last step must end at
--       the surface, each step must begin where its predecessor ended, and
--       the first must begin at the input.  A trace that is not a chain is a
--       log, not a derivation.
--
--   (b) RE-FIRING, in the item domain.  For each step, the sūtra it names is
--       fired again on the state the replay has reached, using this file's
--       own `applyOne` rather than the incumbent's `applyRw`, and asked
--       whether any of its rewrites reaches the recorded output.  A step
--       whose own sūtra cannot reproduce its own effect is a syndrome at
--       that step; the replay stops there, because every later step is then
--       being read off a state nobody claimed.
--
-- WHY THE ITEM DOMAIN, learned by getting it wrong first.  The first version
-- of (b) re-parsed the recorded string with `parseInput`.  `render` prints a
-- pada boundary as a space and `parseInput` splits on spaces without
-- restoring one, so `te api` came back as five phonemes with no boundary, and
-- 6.1.109 -- which conditions on `padāntāt` -- could not fire on its own
-- recorded input.  That produced four syndromes on this corpus, every one of
-- them about the round trip and none about the grammar.  Recorded here rather
-- than quietly fixed: a frame that re-encodes before comparing is testing its
-- own encoding, which is the failure mode of the whole construction, and it
-- is exactly the corruption a reciter introduces by normalising.
------------------------------------------------------------------------

-- Parameterized by a CORRUPTION of the trace, so that the self-test can
-- inject one and watch the position come back, instead of asserting that it
-- would.  `pratilomaSyndromes` is this with the identity corruption; there is
-- no second implementation of the check to drift from this one.
pratilomaSyndromes :: [Item] -> [Syndrome]
pratilomaSyndromes = pratilomaUnder id

pratilomaUnder :: ([Step] -> [Step]) -> [Item] -> [Syndrome]
pratilomaUnder corrupt xs =
  let (steps0, final) = deriveTrace xs
      steps = corrupt steps0
      n = length steps
      idx = zip [0 ..] steps
      contig =
        [ Syndrome (AtStep k) "krama" "pratiloma"
            (stAfter s) (stBefore s')
            ("step " ++ show k ++ " ends at a form step " ++ show (k + 1)
             ++ " does not begin at; the trace is not a chain")
        | ((k, s), (_, s')) <- reverse (zip idx (drop 1 idx))
        , stAfter s /= stBefore s' ]
      endpoints =
        [ Syndrome AtSurface "krama" "pratiloma" (render final) (stAfter (last steps))
            "the last step does not end at the surface form"
        | n > 0, stAfter (last steps) /= render final ]
        ++
        [ Syndrome AtInput "krama" "pratiloma" (render xs) (stBefore (head steps))
            "the first step does not begin at the input"
        | n > 0, stBefore (head steps) /= render xs ]
  in contig ++ endpoints ++ replay 0 xs steps

-- the re-firing walk.  Stops at the first step it cannot reproduce.
replay :: Int -> [Item] -> [Step] -> [Syndrome]
replay _ _ [] = []
replay k st (s : ss) =
  let rws  = firesOn (sutraOf (stSutra s)) st
      outs = nub [ (render (applyOne st r), applyOne st r) | r <- rws ]
      hit  = [ ys | (t, ys) <- outs, t == stAfter s ]
  in case hit of
       (ys : _) -> replay (k + 1) ys ss
       [] ->
         [ Syndrome (AtStep k) "krama" "pratiloma"
             (stBefore s ++ " ⇒ " ++ stAfter s)
             (render st ++ " ⇒ "
              ++ (case outs of
                    [] -> "(no rewrite of " ++ showRef (stSutra s) ++ " applies)"
                    _  -> intercalate " | " (map fst outs)))
             ("sūtra " ++ showRef (stSutra s)
              ++ " re-fired on the replayed state does not reach the recorded"
              ++ " output; the replay stops here, so any later step is unchecked") ]


------------------------------------------------------------------------
-- 5.  ASIDDHA — the existing frame, cross-checked
--
-- `asiddhaAudit` reports the rules that would fire on the tripādī's output
-- and are refused.  8.2.1 licenses the refusal of a rule that PRECEDES the
-- rule which created the context.  So a refusal by a section-A rule is
-- licensed only if some tripādī rule actually fired in this derivation.  If
-- none did, nothing made the context asiddha and phase A simply stopped
-- short of its own fixpoint — which is a different defect wearing the same
-- report, and the audit alone cannot tell them apart.
------------------------------------------------------------------------

asiddhaSyndromes :: [Item] -> [Syndrome]
asiddhaSyndromes xs =
  let (steps, _) = deriveTrace xs
      firedTripadi = [ stSutra s | s <- steps, tripadi (stSutra s) ]
      audit = asiddhaAudit xs
  in [ Syndrome (AtSutra r) "asiddha" "krama"
         (r `seq` showRef r ++ " refused: " ++ why)
         "no tripādī rule fired in this derivation"
         ("8.2.1 cannot license this refusal: nothing later than "
          ++ showRef r ++ " has taken effect, so phase A stopped short of"
          ++ " its own fixpoint")
     | (r, why) <- audit
     , not (tripadi r)
     , null firedTripadi ]

------------------------------------------------------------------------
-- 6.  COMPARING THE FRAMES
--
-- Surfaces first, then routes.  A surface disagreement says the frames
-- reached different forms; a route disagreement with equal surfaces says
-- they reached the same form by different rules, which is a weaker finding
-- and is reported as one, at the step where they first part.
------------------------------------------------------------------------

compareReadings :: Anuvacana -> Anuvacana -> [Syndrome]
compareReadings a b
  | rdSurface a /= rdSurface b =
      [ Syndrome AtSurface (rdFrame a) (rdFrame b) (rdSurface a) (rdSurface b)
          ("the two frames end at different forms; the earlier divergence is"
           ++ firstRouteSplit a b) ]
  | otherwise = case routeSplit a b of
      Nothing -> []
      Just (k, ra, rb)
        | null (rdRoute a) || null (rdRoute b) -> []
        | otherwise ->
            [ Syndrome (AtStep k) (rdFrame a) (rdFrame b) ra rb
                ("same surface, different route: the frames part at step "
                 ++ show k ++ ", so the output does not depend on this"
                 ++ " choice but the derivation does") ]

routeSplit :: Anuvacana -> Anuvacana -> Maybe (Int, String, String)
routeSplit a b = go 0 (rdRoute a) (rdRoute b)
  where
    go _ [] [] = Nothing
    go k [] ((r, f) : _) = Just (k, "(no further step)", showRef r ++ " → " ++ f)
    go k ((r, f) : _) [] = Just (k, showRef r ++ " → " ++ f, "(no further step)")
    go k ((r, f) : rs) ((r', f') : rs')
      | r == r' && f == f' = go (k + 1) rs rs'
      | otherwise = Just (k, showRef r ++ " → " ++ f, showRef r' ++ " → " ++ f')

firstRouteSplit :: Anuvacana -> Anuvacana -> String
firstRouteSplit a b = case routeSplit a b of
  Nothing -> " not visible in the recorded routes"
  Just (k, ra, rb) -> " at step " ++ show k ++ ": " ++ ra ++ " against " ++ rb

------------------------------------------------------------------------
-- 7.  THE WHOLE RECITATION
------------------------------------------------------------------------

patha :: String -> Patha
patha input =
  let xs = parseInput input
      rs = [ readKrama xs, readVyutkrama xs, readDaksinatah xs
           , readJata xs, readGhana xs ]
      k  = head rs
      pairSyn = concat [ compareReadings k r | r <- drop 1 rs ]
      syn = pairSyn ++ pratilomaSyndromes xs ++ asiddhaSyndromes xs
      agreeing = [ rdFrame r | r <- rs, rdSurface r == rdSurface k ]
      routes   = length (nub [ rdRoute r | r <- rs, not (null (rdRoute r)) ])
  in Patha input rs syn (Concord agreeing (rdSurface k) routes)

syndromes :: String -> [Syndrome]
syndromes = paSyndromes . patha

------------------------------------------------------------------------
-- 8.  REPORTING.  A position and a disagreement.  Never a boolean.
------------------------------------------------------------------------

showSyndrome :: Syndrome -> [String]
showSyndrome s =
  [ "  syndrome at " ++ showPosition (syPosition s)
  , "      " ++ pad 12 (syFrameA s) ++ "  " ++ syReadingA s
  , "      " ++ pad 12 (syFrameB s) ++ "  " ++ syReadingB s
  , "      " ++ sySays s ]
  where pad n t = t ++ replicate (max 0 (n - length t)) ' '

showPatha :: Patha -> [String]
showPatha p =
  [ "", "  " ++ paInput p ]
  ++ [ "      " ++ pad 12 (rdFrame r) ++ "  " ++ rdSurface r
       ++ (if null (rdRoute r) then ""
           else "   [" ++ intercalate " " [ showRef q | (q, _) <- rdRoute r ] ++ "]")
     | r <- paReadings p ]
  ++ (case paSyndromes p of
        [] -> [ "      concord: " ++ intercalate ", " (coFrames (paConcord p))
                ++ " all recite " ++ coSurface (paConcord p)
                ++ " (" ++ show (coRoutes (paConcord p)) ++ " distinct route"
                ++ (if coRoutes (paConcord p) == 1 then "" else "s") ++ ")" ]
        ss -> concatMap showSyndrome ss)
  where pad n t = t ++ replicate (max 0 (n - length t)) ' '

------------------------------------------------------------------------
-- 9.  SELF-TEST
--
-- The frames must be capable of disagreeing, or the construction is
-- decorative.  Checked by CORRUPTING a derivation and seeing the syndrome
-- appear at the right position — the recitation-school test, which is to
-- hand a reciter a deliberately altered pāṭha.
------------------------------------------------------------------------

selfTestGhana :: [String]
selfTestGhana = concat
  [ chk "the independent engine reaches the incumbent's surface on deva + indra"
      (rdSurface (readVyutkrama (parseInput "deva + indra")))
      (derive "deva + indra")
  , chk "blocks/1: a two-pada input has two blocks"
      (length (blocks (parseInput "deva + indra"))) 2
  , chk "blocks/2: a three-pada input has three"
      (length (blocks (parseInput "deva + indra + iva"))) 3
  , chk "a trace whose steps are contiguous produces no pratiloma syndrome"
      (map syPosition (pratilomaSyndromes (parseInput "dadhi + indra"))) []
  , chk "a corrupted step-output is caught, and at that step"
      (nub (map syPosition (pratilomaUnder (bend 0) (parseInput "tat + ca"))))
      [AtStep 0]
  , chk "a corrupted later step is caught, and at THAT step, not the first"
      (nub (map syPosition (pratilomaUnder (bend 1) (parseInput "tat + ca"))))
      [AtStep 1]
  , chk "a dropped last step is caught at the surface"
      (map syPosition (pratilomaUnder init (parseInput "tat + ca")))
      [AtSurface]
  , chk "applyOne agrees with a rewrite's own arithmetic"
      (render (applyOne (parseInput "deva + indra")
                 (Rewrite (6,1,87) 0 1 [P "x"] 0 "probe")))
      "xeva indra"
  ]
  where
    chk :: (Eq a, Show a) => String -> a -> a -> [String]
    chk nm got want
      | got == want = []
      | otherwise = [ nm ++ ": got " ++ show got ++ ", wanted " ++ show want ]

    -- normalise one step's recorded output, the way a carrier normalises a
    -- sound: the trace still reads as a derivation, and the frames part
    bend k steps = [ if i == k then s { stAfter = stAfter s ++ "a" } else s
                   | (i, s) <- zip [0 ..] steps ]

-- (the parameterized check lives at section 4; there is no second copy here.)
