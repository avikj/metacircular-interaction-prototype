-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

-- द्वारवादः -- the disputation at the door.
--
-- नालन्दायां द्वारे वादः.  At Nalanda the gatekeeper argued with the arrival and
-- the argument was the credential; the letter of introduction was not.  This
-- file is that gate, for forms proposed by a machine that cannot be asked how
-- it got them.
--
-- WHAT THIS IS.  `Astadhyayi.hs` runs sutras: it takes `dadhi + indra` and
-- computes `dadhindra`, recording which sutra fired at which position and,
-- where two of them wanted the same position, which metarule decided.  It is
-- a producer.  This file is the other direction.  It takes a form SOMEONE
-- ELSE proposes -- a language model at inference time, which produces fluent
-- Sanskrit-shaped strings with no derivation behind them at all -- and either
-- admits it with a certificate or refuses it with a residual.
--
-- Admission is never on the form and never on fluency.  `dadhyindra` is a
-- fluent, well-formed, Sanskrit-looking string, produced by a real sutra
-- (6.1.77 iko yan aci), and it is wrong, because 6.1.101 also fires at that
-- juncture and 1.4.2 vipratisedhe param karyam gives the position to the
-- later sutra.  A fluency judge admits it.  The door refuses it and hands
-- back the pair it could not resolve.
--
--
-- PURVAPAKSA -- stated first, in the form its holder would sign, because
-- tantrayukti counts the opponent's position as a limb of one's own text and
-- because a purvapaksa the opponent would not sign is a refutation of
-- something one built oneself (Kautilya, Arthasastra; Caraka, Vimanasthana
-- 8).  The strongest case against this door, and it is not weak:
--
--   "The gate is not checking the derivation.  It is checking whether the
--   proposed string equals the string your own engine prints, and your
--   engine encodes a few dozen sutras of ~3983 -- `coverage` prints the
--   number and it is under one percent.  So the certificate certifies
--   agreement with that fragment, and the residual you hand back on a
--   refusal is, in the overwhelming majority of real cases, a report that
--   your fragment is missing a rule -- not that the proposer is wrong.  A
--   door that refuses `bhavati` because it has no dhatupatha has not
--   adjudicated anything; it has mistaken its own coverage for the grammar.
--   That is precisely durnaya: a standpoint asserting itself as the thing.
--   Worse, it is durnaya WITH A CERTIFICATE, which is harder to dislodge
--   than a bare wrong answer, because the trace makes the refusal look
--   adjudicated when it is only incomplete.  And your admissions are no
--   better founded: a form the engine happens to reproduce is admitted
--   whether or not the proposer had any derivation in mind, so the door
--   rewards a lucky string exactly as it rewards a derived one."
--
-- That is signed and it is right about the first half.  What is done about
-- it here, mechanically rather than as a promise:
--
--   1. A refusal for want of coverage and a refusal for a wrong derivation
--      are DIFFERENT CONSTRUCTORS, and the door never conflates them.
--      `Avisaya` -- "outside the domain" -- is what a refusal says when the
--      juncture contains material the encoded fragment cannot condition on.
--      It is not a verdict about Sanskrit and it says so in its own text.
--      `SesaPada` -- शेषपद, the leftover pair of terms -- the derivation reached a different form -- is a verdict,
--      and it is only ever issued when every sound in the query is in the
--      varnasamamnaya and some rule of the fragment did fire.
--
--   2. The luck objection is answered by making the CITATION part of the
--      query.  A proposer may state which sutras it claims fired.  If it
--      does, the door checks that claim against the trace and refuses on a
--      `Hetu` residual when the form is right and the derivation is wrong.
--      `devendra by 6.1.101` is refused: the form is correct, 6.1.87 ad
--      gunah is what produced it, and a proposer that cites the wrong rule
--      did not derive it.  Under that constructor the door does what the
--      purvapaksa says it cannot: it separates the answer from the reason.
--
--   3. The coverage number is printed by `Astadhyayi.coverage` and is not
--      rounded up.  The door reports it in every refusal of the `Avisaya`
--      kind, so the reader of a refusal always holds the fragment's size.
--
--
-- WHAT A RESPONSE CARRIES, and why none of it is optional.
--
-- NEVER A BARE LABEL.  `Admitted` carries the full derivation: every sutra
-- Ref that fired, the position it fired at, the item list before and after,
-- and the adjudication that let it fire.  Each step carries its own input,
-- so the certificate is checkable STEP BY STEP by a party that did not
-- produce it -- `audit` does exactly that, re-firing each named sutra on the
-- step's own recorded input from the sutra table alone, and checking that
-- the steps chain, that the first input is the query, and that the last
-- output is the admitted form.  A trace that is only a log is not a
-- certificate; the difference is whether it can be replayed against the
-- rules without trusting the producer.
--
-- WHERE TWO CONTENDED.  `Contention` records every position where more than
-- one sutra offered a rewrite, all the offers, and which metarule decided:
-- the elsewhere condition (an apavada blocks its utsarga regardless of
-- position -- a paribhasa, not a numbered sutra, and it is cited as one) or
-- 1.4.2 (the later sutra takes the position).  The two are separate NAYAS
-- here, evaluated independently, and the door records BOTH verdicts even
-- when they agree -- because "they agreed" is a fact about the grammar and
-- collapsing it to the winner destroys it.
--
-- WHERE NOTHING DECIDED.  `Remainder` is a typed position, not an error and
-- not a default.  Two grounds produce it:
--
--   VIBHASA.  8.4.56 `vavasane` -- jhaL in pause becomes caR *va*, optionally.
--   Panini wrote the option.  So `vac` in pause is `vak` AND `vag`, and a
--   machine that prints one of them has performed sanksepa on the grammar's
--   own text.  The door retains both branches, each with its own complete
--   trace, and the certificate for either branch NAMES THE OTHER -- so a
--   reader holding one certificate cannot mistake it for the whole.  This is
--   the fourth position of the saptabhangi read strictly: krama-arpana can
--   utter each in turn, saha-arpana cannot utter them together, and what
--   cannot be uttered together is avaktavyam -- which is a position, with
--   content, and not a gap.
--
--   NAYA-VIRODHA.  The two metarules disagree: the apavada verdict and the
--   1.4.2 verdict name different sutras.  Structurally this happens exactly
--   when a sutra's utsarga is LATER than it is.  The mechanism is
--   implemented and the door will fork on it.  IT DOES NOT ARISE IN THE
--   ENCODED FRAGMENT -- the one apavada relation present, 6.1.88 to 6.1.87,
--   has the exception later than the general rule, so both nayas name
--   6.1.88 and agree.  `selfTest` asserts the emptiness rather than the
--   mechanism, so that a future rule creating a genuine conflict fails the
--   test instead of being silently resolved.  This is recorded here and not
--   in a commit message because an unexercised mechanism that is not
--   labelled as unexercised is a claim nobody checked.
--
-- A REFUSAL CARRIES THE RESIDUAL.  Not "invalid".  The position at which the
-- derivation and the claim part company, and the exact pair of terms at that
-- position -- what the grammar gives, what was claimed -- together with the
-- sutras that were offered there and the ones that were beaten there.
--
--     137 = 2 * 60 + 17
--      60 = 3 * 17 +  9
--
-- The kuttaka (Aryabhata, Aryabhatiya, ganitapada 32-33, 499 CE) does not
-- discard 17.  It keeps it and recurses on it, and the vlaqi -- the column
-- of what would not divide -- is not a record of failure, it is the material
-- the answer is built out of, read back upward.  `yo sesam tyajati tasya
-- yantram na calati`.  The residual here is that column: the pair the door
-- could not resolve is exactly the pair the next rule has to be made from,
-- and a refusal that returned only `False` would have thrown away the only
-- part of the computation with anything in it.
--
--
-- SOURCES.  Panini, Astadhyayi, ~500 BCE, for every sutra cited; text and
-- numbering follow the vulgate, through `Astadhyayi.hs`, which carries its
-- own sourcing.  1.4.2 vipratisedhe param karyam for the contention rule;
-- 8.2.1 purvatrasiddham for the stratification the trace records; 8.4.56
-- vavasane for the option that makes the remainder non-empty.  The elsewhere
-- condition is a paribhasa of the tradition rather than a numbered sutra and
-- is cited that way.  Aryabhata, Aryabhatiya, 499, for the kuttaka, which is
-- the shape of the residual and not a decoration on it.  For the sevenfold
-- predication and the fourth position: Umasvati, Tattvarthasutra; Siddhasena
-- Divakara, Sanmatitarka -- Jaina, and named as Jaina, because the treatment
-- of the unutterable here is theirs and the Naiyayika treatment of absence
-- is a rival account that would not sign it.
--
-- NO FLOATING POINT, no measurement.  Every claim is a finite check in
-- `selfTest`, which returns [] or names what failed.

module DvaraVada_TheDoorAdmitsTheDerivationNotTheForm
  ( -- the query
    Query(..)
    -- the response
  , Response(..)
  , Certificate(..)
  , Refusal(..)
  , Fired(..)
  , Phase(..)
  , Contention(..)
  , Adjudication(..)
  , Naya(..)
  , Remainder(..)
  , RemainderGround(..)
  , Residual(..)
    -- the gate
  , dvara
  , audit
    -- the machinery, exposed so the gate is not the only way to see it
  , World(..)
  , worlds
  , adjudicate
  , vibhasa
  , nayaVirodhaCandidates
    -- reading
  , renderResponse
  , showRef
    -- honesty
  , selfTest
  ) where

import Astadhyayi hiding (selfTest, coverage)
import qualified Astadhyayi as A

import Data.List (sortOn, nub, maximumBy, isPrefixOf, (\\), intercalate)
import Data.Ord (comparing)

------------------------------------------------------------------------
-- 1.  THE QUERY.  What a proposer may put to the door.
--
-- Three doors, because the Astadhyayi has three kinds of thing to be wrong
-- about and they fail differently: a form, a class of sounds, and a case
-- ending.  A proposer states a juncture and a form; it MAY also state the
-- sutras it claims fired, and if it does, that claim is checked.  The
-- citation is optional in the type and not in the discipline: a query with
-- no citation can only ever be admitted on the form, which is the weaker
-- admission, and the certificate says which of the two it got.
------------------------------------------------------------------------

data Query
  = AskSandhi
      { qJuncture :: String     -- e.g. "dadhi + indra"; + is a pada boundary, - a morph juncture
      , qForm     :: String     -- the form proposed
      , qCitation :: [Ref]      -- the sutras the proposer claims fired; [] = no claim
      }
  | AskVarga
      { qFrom     :: String     -- the pratyahara's first sound
      , qMarker   :: String     -- its anubandha
      , qMembers  :: [String]   -- the sounds the proposer claims it denotes
      }
  | AskKaraka
      { qVacya    :: Vacya
      , qKaraka   :: Karaka
      , qVibhakti :: Vibhakti
      }
  deriving (Eq, Show)

------------------------------------------------------------------------
-- 2.  THE RESPONSE.  Never a bare label.
------------------------------------------------------------------------

data Phase
  = Siddha      -- 1.1.1 .. 8.1.x, all rules mutually visible, run to a fixpoint
  | Tripadi     -- 8.2.1 on, each rule once, in order, blind to what follows
  deriving (Eq, Show)

-- Which standpoint decided.  Two, and they are kept apart even when they
-- agree, because agreement is a fact and collapsing it destroys it.
data Naya
  = Apavada     -- the elsewhere condition: the exception blocks the general rule
  | Paratva     -- 1.4.2 vipratisedhe param karyam: the later sutra
  deriving (Eq, Show)

data Adjudication
  = Sole Ref
      -- exactly one sutra wanted this position
  | Decided Ref [Naya] [Ref] String
      -- winner, the standpoints that name it, the sutras beaten, why
  | Undecided [(Naya, Ref)] String
      -- the standpoints name different sutras; nothing decided
  | InOrder Ref
      -- tripadi: no contention is possible, 8.2.1 fixed the order
  deriving (Eq, Show)

data Fired = Fired
  { fSutra   :: Ref
  , fText    :: String
  , fPos     :: Int          -- the position in the item list where it fired
  , fLen     :: Int          -- how many items it replaced
  , fNote    :: String
  , fPhase   :: Phase
  , fAdj     :: Adjudication
  , fBeforeI :: [Item]       -- the step's own input: this is what makes it checkable
  , fAfterI  :: [Item]
  } deriving (Show)

data Contention = Contention
  { cPos     :: Int
  , cOffered :: [Ref]
  , cAdj     :: Adjudication
  } deriving (Show)

data RemainderGround
  = Vibhasa Ref String        -- the sutra states the option itself
  | NayaVirodha Ref Ref       -- apavada and 1.4.2 name different sutras
  deriving (Eq, Show)

-- Not an error and not a default.  A position, with both branches in it.
data Remainder = Remainder
  { remGround   :: RemainderGround
  , remBranches :: [(Maybe Ref, String)]   -- Nothing = the branch where the rule did not apply
  , remWhy      :: String
  } deriving (Show)

-- The kuttaka column.  What did not divide, kept, because it is the material
-- of the next step.
data Residual
  = SesaPada
      { rdPrefix  :: [String]              -- what the grammar and the claim agree on
      , rdHave    :: Maybe String          -- what the grammar has at the divergence
      , rdWant    :: Maybe String          -- what was claimed there
      , rdTailHave :: [String]             -- the rest of each, kept whole
      , rdTailWant :: [String]
      , rdOffered :: [Ref]                 -- sutras offered at that position, and beaten there
      }
  | Hetu
      { rdClaimedNotFired :: [Ref]
      , rdFiredNotClaimed :: [Ref]
      }
  | Avisaya
      { rdUnknown  :: [String]             -- sounds not in the varnasamamnaya
      , rdCoverage :: String
      }
  | VargaResidual
      { rdMissing :: [String]
      , rdExtra   :: [String]
      , rdWalk    :: [Slot]                -- the raw span, markers included
      }
  | KarakaResidual
      { rdGotCase  :: Vibhakti
      , rdWantCase :: Vibhakti
      , rdWhy     :: String
      }
  deriving (Show)

data Certificate = Certificate
  { certQuery      :: Query
  , certForm       :: String       -- the admitted form
  , certAllForms   :: [String]     -- every form the grammar allows here; more than one is not a bug
  , certTrace      :: [Fired]
  , certContention :: [Contention]
  , certRemainder  :: [Remainder]
  , certAsiddha    :: [(Ref, String)]  -- rules 8.2.1 refuses on the final form
  , certGround     :: String       -- form-only, or form-and-citation
  , certSyat       :: String       -- the respect in which this holds
  } deriving (Show)

data Refusal = Refusal
  { refQuery    :: Query
  , refTrace    :: [Fired]      -- everything that did fire before the parting
  , refReached  :: [String]     -- the form(s) the grammar reached
  , refStalledAt :: Int         -- the position at which derivation and claim part
  , refResidual :: Residual
  , refGround   :: String
  } deriving (Show)

data Response
  = Admitted Certificate
  | Refused Refusal
  deriving (Show)

------------------------------------------------------------------------
-- 3.  THE ENGINE, WITH BRANCHES.
--
-- `Astadhyayi.deriveTrace` returns ONE form.  Where Panini wrote an option
-- it takes the option, silently.  That is the truncation this file exists to
-- refuse, so the derivation here carries a set of worlds and forks where the
-- grammar forks.  The rules, the metarules and the stratification are
-- Astadhyayi's, unchanged and imported; what is new is that nothing is
-- collapsed.
------------------------------------------------------------------------

data World = World
  { wItems :: [Item]
  , wFired :: [Fired]
  , wCont  :: [Contention]
  , wRem   :: [Remainder]
  } deriving (Show)

-- Panini's own options.  `va` (optionally), `vibhasa` (alternatively),
-- `anyatarasyam` (either way) are the three words that mark one, and where
-- one is in the sutra the grammar does not decide.  Only sutras encoded in
-- Astadhyayi.hs can be listed here; the list is the sutras among those whose
-- own text carries the option.
vibhasa :: [(Ref, String)]
vibhasa =
  [ ((8,4,56), "vā -- 8.4.56 vāvasāne states the option in its own first word") ]

isVibhasa :: Ref -> Bool
isVibhasa r = r `elem` map fst vibhasa

-- EVERY call into Astadhyayi's rule table goes through this one function, and
-- it is the only line that has to change if the signature of `fires` changes
-- upstream.  A door that reached into the grammar in four places would make
-- someone else's refactor into someone else's outage.
offers :: Sutra -> [Item] -> [Rewrite]
offers s xs = fires s (readingUnder [] s) xs   -- the standard reading: no
                                            -- counterfactual cancellation of any
                                            -- heading.  `readingUnder` supplies the
                                            -- anuvrtti context a sutra does not write.

apply :: [Item] -> Rewrite -> [Item]
apply xs r = take (rPos r) xs ++ rNew r ++ drop (rPos r + rLen r) xs

-- Rules that WOULD fire on a finished form and do not.  Two reasons, and the
-- door does not merge them: 8.2.1 purvatrasiddham refuses a rule that has
-- already been passed in the tripadi (which is what makes the grammar
-- terminate: on `vak` 8.2.39 would give `vag` and 8.4.56 `vak` again,
-- forever), and a vibhasa did not apply because the grammar left it open,
-- which is not a refusal at all but the other branch of a remainder.
wouldFireOn :: [Item] -> [(Ref, String)]
wouldFireOn xs =
  [ (num s, tag (num s) ++ rNote r)
  | s <- sutras, r <- offers s xs, apply xs r /= xs ]
  where
    tag r | isVibhasa r = "the sūtra's own option, retained as a remainder and not refused: "
          | otherwise   = "8.2.1 pūrvatrāsiddham refuses it: "

sutraAt :: Ref -> Sutra
sutraAt r = head ([ s | s <- sutras, num s == r ] ++ [ missing ])
  where missing = Sutra r "?" "?" Vidhi [] (\_ _ -> [])

sectionA, sectionB :: [Sutra]
sectionA = [ s | s <- sutras, not (tripadi (num s)) ]
sectionB = sortOn num [ s | s <- sutras, tripadi (num s) ]

overlaps :: Rewrite -> Rewrite -> Bool
overlaps a b = rPos a < rPos b + rLen b && rPos b < rPos a + rLen a

-- Two standpoints, evaluated separately, then compared.  Neither is allowed
-- to stand in for the other, and where they part the door does not choose.
adjudicate :: [Rewrite] -> Adjudication
adjudicate rs
  | length (nub (map rSutra rs)) <= 1 = Sole (rSutra (head rs))
  | otherwise =
      let byApavada = [ rSutra r | r <- rs
                      , any (\o -> rSutra o `elem` apavadaTo (sutraAt (rSutra r))) rs ]
          byParatva = rSutra (maximumBy (comparing rSutra) rs)
          allRefs   = nub (map rSutra rs)
      in case byApavada of
           []      -> Decided byParatva [Paratva] (allRefs \\ [byParatva])
                        "1.4.2 vipratiṣedhe paraṃ kāryam: the later sūtra takes the position"
           (a : _)
             | a == byParatva ->
                 Decided a [Apavada, Paratva] (allRefs \\ [a])
                   ("the apavāda blocks its utsarga (paribhāṣā, not a numbered sūtra), "
                    ++ "and 1.4.2 names the same sūtra -- both standpoints agree")
             | otherwise ->
                 Undecided [(Apavada, a), (Paratva, byParatva)]
                   ("the apavāda paribhāṣā names " ++ showRef a
                    ++ " and 1.4.2 names " ++ showRef byParatva
                    ++ "; nothing in the grammar orders the two metarules, "
                    ++ "so both branches are retained (avaktavyam)")

-- Where a genuine naya-virodha COULD arise in a rule table: a sutra whose
-- utsarga is later than it is.  Reported rather than assumed absent.
nayaVirodhaCandidates :: [(Ref, Ref)]
nayaVirodhaCandidates =
  [ (num s, u) | s <- sutras, u <- apavadaTo s, u > num s ]

-- one step of the mutually-siddha section
stepA :: World -> [World]
stepA w =
  case sortOn rPos (concatMap (\s -> offers s (wItems w)) sectionA) of
    []    -> []
    ofs ->
      let leftmost = minimum (map rPos ofs)
          anchor   = head [ r | r <- ofs, rPos r == leftmost ]
          here     = [ r | r <- ofs, overlaps r anchor ]
          adj      = adjudicate here
          cont     = Contention leftmost (nub (map rSutra here)) adj
          keepCont = if length (nub (map rSutra here)) > 1
                       then wCont w ++ [cont] else wCont w
          takeRef r = head [ q | q <- here, rSutra q == r ]
      in case adj of
           Sole r        -> [ advance w keepCont adj (takeRef r) ]
           Decided r _ _ _ -> [ advance w keepCont adj (takeRef r) ]
           InOrder r     -> [ advance w keepCont adj (takeRef r) ]
           Undecided brs why ->
             let ws = [ advance w keepCont adj (takeRef r) | (_, r) <- brs ]
                 rem_ = Remainder (NayaVirodha (snd (head brs)) (snd (brs !! 1)))
                          [ (Just r, render (wItems v)) | ((_, r), v) <- zip brs ws ]
                          why
             in [ v { wRem = wRem v ++ [rem_] } | v <- ws ]
  where
    advance v cont adj r =
      let ys = apply (wItems v) r
          f  = Fired (rSutra r) (text (sutraAt (rSutra r))) (rPos r) (rLen r)
                     (rNote r) Siddha adj (wItems v) ys
      in v { wItems = ys, wFired = wFired v ++ [f], wCont = cont }

phaseA :: Int -> [World] -> [World]
phaseA k ws
  | k > 64 = ws
  | otherwise =
      let next = [ (w, stepA w) | w <- ws ]
          progressed = or [ any ((/= wItems w) . wItems) vs | (w, vs) <- next ]
      in if not progressed
           then ws
           else phaseA (k + 1)
                  (take 16 (concat [ if null vs || all ((== wItems w) . wItems) vs
                                       then [w] else vs
                                   | (w, vs) <- next ]))

-- one tripadi rule against one world, saturating on its own output
saturate :: Sutra -> World -> World
saturate s = go (0 :: Int)
  where
    go n w
      | n > 16 = w
      | otherwise =
          case offers s (wItems w) of
            []      -> w
            (r : _) ->
              let ys = apply (wItems w) r
              in if ys == wItems w then w
                 else go (n + 1)
                        w { wItems = ys
                          , wFired = wFired w
                                   ++ [ Fired (num s) (text s) (rPos r) (rLen r)
                                          (rNote r) Tripadi (InOrder (num s))
                                          (wItems w) ys ] }

-- 8.2.1: each rule once, in order.  Where the sutra states an option, the
-- world forks and BOTH branches are kept, each carrying the remainder that
-- names the other.
stepB :: Sutra -> World -> [World]
stepB s w
  | isVibhasa (num s) && not (null (offers s (wItems w))) =
      let applied = saturate s w
          skipped = w
          rem_ = Remainder
                   (Vibhasa (num s) (head ([ t | (r, t) <- vibhasa, r == num s ] ++ ["vā"])))
                   [ (Just (num s), render (wItems applied))
                   , (Nothing,      render (wItems skipped)) ]
                   ("the sūtra states the option in its own text, so the grammar does "
                    ++ "not decide here; both forms stand and neither is a default")
      in [ applied { wRem = wRem applied ++ [rem_] }
         , skipped { wRem = wRem skipped ++ [rem_] } ]
  | otherwise = [ saturate s w ]

worlds :: [Item] -> [World]
worlds xs0 =
  let w0 = World xs0 [] [] []
      a  = phaseA 0 [w0]
  in take 16 (foldl (\ws s -> concatMap (stepB s) ws) a sectionB)

------------------------------------------------------------------------
-- 4.  THE CERTIFICATE IS CHECKABLE BY A PARTY THAT DID NOT PRODUCE IT.
--
-- Every step carries its own input, so `audit` never has to trust the
-- producer's ordering, its engine, or its arithmetic.  It re-fires the named
-- sutra on the step's own recorded input, from `sutras` alone, and checks
-- four things: that each step is what that sutra does at that position; that
-- the steps chain; that the first input is the query; and that the last
-- output is the admitted form.  Returns [] or names what failed.
------------------------------------------------------------------------

audit :: Certificate -> [String]
audit cert = stepChecks ++ chainCheck ++ endpointChecks
  where
    tr = certTrace cert
    stepChecks = concat
      [ if reproduces f then []
          else [ "step " ++ show i ++ " (" ++ showRef (fSutra f)
                 ++ ") is not what that sūtra does at position " ++ show (fPos f) ]
      | (i, f) <- zip [(0 :: Int) ..] tr ]
    reproduces f =
      any (\r -> rSutra r == fSutra f && rPos r == fPos f
                 && apply (fBeforeI f) r == fAfterI f)
          (offers (sutraAt (fSutra f)) (fBeforeI f))
    chainCheck = concat
      [ if fAfterI a == fBeforeI b then []
          else [ "steps " ++ show i ++ " and " ++ show (i + 1) ++ " do not chain" ]
      | (i, a, b) <- zip3 [(0 :: Int) ..] tr (drop 1 tr) ]
    endpointChecks = case certQuery cert of
      AskSandhi j _ _ ->
        let start = case tr of { [] -> Nothing; (f : _) -> Just (fBeforeI f) }
            end   = case reverse tr of { [] -> Nothing; (f : _) -> Just (fAfterI f) }
        in concat
           [ case start of
               Just s | s /= parseInput j -> ["the trace does not begin at the query"]
               _ -> []
           , case end of
               Just e | render e /= certForm cert ->
                 ["the trace does not end at the admitted form"]
               Nothing | render (parseInput j) /= certForm cert ->
                 ["empty trace, and the query is not already the admitted form"]
               _ -> []
           ]
      _ -> []

------------------------------------------------------------------------
-- 5.  THE GATE.
------------------------------------------------------------------------

showRef :: Ref -> String
showRef (a, b, c) = show a ++ "." ++ show b ++ "." ++ show c

-- sounds in a query that the varnasamamnaya does not contain.  A juncture
-- with one of these is OUTSIDE THE DOMAIN, which is a different thing from
-- being wrong, and the door keeps them apart.
unknownSounds :: String -> [String]
unknownSounds s =
  nub [ t | w <- words s, w /= "+", w /= "-"
          , t <- tokenize w, t /= "'", phoneOf t == Nothing ]

coverageLine :: String
coverageLine = head A.coverage

dvara :: Query -> Response

------------------------------------------------------------------------
-- 5a.  the sandhi door
------------------------------------------------------------------------
dvara q@(AskSandhi juncture claim cites) =
  case unknownSounds juncture ++ unknownSounds claim of
    (u : us) ->
      Refused (Refusal q [] [] 0
        (Avisaya (nub (u : us)) coverageLine)
        ("outside the domain: the sound(s) named are not in the varṇasamāmnāya, "
         ++ "so no sūtra of the fragment can condition on them.  This is a "
         ++ "statement about the coverage of the encoded fragment and NOT a "
         ++ "verdict about Sanskrit."))
    [] ->
      let ws    = worlds (parseInput juncture)
          forms = nub (map (render . wItems) ws)
      in case [ w | w <- ws, render (wItems w) == claim ] of
           (w : _) ->
             let firedRefs = nub (map fSutra (wFired w))
                 missing   = nub cites \\ firedRefs
                 extra     = firedRefs \\ nub cites
                 cert = Certificate
                   { certQuery      = q
                   , certForm       = claim
                   , certAllForms   = forms
                   , certTrace      = wFired w
                   , certContention = wCont w
                   , certRemainder  = wRem w
                   , certAsiddha    = wouldFireOn (wItems w)
                   , certGround     = if null cites
                                        then "form only: no citation was offered, so the \
                                             \derivation is the door's and not the proposer's"
                                        else "form and citation: the sūtras claimed are \
                                             \exactly the sūtras that fired"
                   , certSyat       = syat forms claim (wRem w)
                   }
                 firstUncited =
                   length (takeWhile (\f -> fSutra f `elem` nub cites) (wFired w))
             in if null cites || (null missing && null extra)
                  then Admitted cert
                  else Refused (Refusal q (wFired w) forms firstUncited
                         (Hetu missing extra)
                         ("the form is one the grammar reaches and the derivation offered \
                          \is not the one that reaches it; admission is on the derivation.  \
                          \The position is a STEP index, not a place in the form: it is where \
                          \the trace and the citation part company."))
           [] ->
             let best = closest claim forms
                 w    = head ([ v | v <- ws, render (wItems v) == best ] ++ ws)
                 (pre, hv, wt, th, tw, i) = part best claim
             in Refused (Refusal q (wFired w) forms i
                  (SesaPada pre hv wt th tw (offeredAt w i))
                  ("the derivation reaches " ++ intercalate " / " forms
                   ++ " and the claim is " ++ claim
                   ++ "; the pair at position " ++ show i
                   ++ " is the residual, and it is what the next rule would have to be "
                   ++ "made of (kuṭṭaka: keep what does not divide)"))
  where
    closest c fs = case sortOn (negate . agree c) fs of
                     (f : _) -> f
                     []      -> ""
    agree c f = length (takeWhile id (zipWith (==) (tokenize c) (tokenize f)))
    part have want =
      let hs = tokenize have
          ws' = tokenize want
          i   = length (takeWhile id (zipWith (==) hs ws'))
      in ( take i hs
         , if i < length hs  then Just (hs !! i)  else Nothing
         , if i < length ws' then Just (ws' !! i) else Nothing
         , drop i hs, drop i ws', i )
    -- the sutras that were offered at, or beaten at, the divergence: the
    -- material a next step would be made from
    offeredAt w i =
      nub ([ r | c <- wCont w, cPos c <= i, r <- cOffered c ]
           ++ [ fSutra f | f <- wFired w, fPos f <= i ])

------------------------------------------------------------------------
-- 5b.  the pratyahara door.  The trace here is the walk itself: the raw
--      span through the varnasamamnaya, markers included, so a reader can
--      see which boundaries were crossed and not collected.
------------------------------------------------------------------------
dvara q@(AskVarga from marker claimed) =
  let truth = pratyahara from marker
      walk  = rawSpan from marker
      missing = truth \\ claimed
      extra   = claimed \\ truth
  in if null walk && null truth
       then Refused (Refusal q [] [] 0
              (Avisaya [from, marker] coverageLine)
              "outside the domain: that sound or that anubandha is not in the śivasūtras")
       else if null missing && null extra && claimed == truth
         then Admitted Certificate
                { certQuery      = q
                , certForm       = unwords truth
                , certAllForms   = [unwords truth]
                , certTrace      = []
                , certContention = []
                , certRemainder  = []
                , certAsiddha    = []
                , certGround     = "the interval was walked: " ++ show (length walk)
                                   ++ " slots, of which "
                                   ++ show (length [ () | It _ <- walk ])
                                   ++ " are anubandhas and are boundaries, never members"
                , certSyat       = "syād asti: in the respect of the śivasūtra order, "
                                   ++ "which is one order and is not the only possible one"
                }
         else Refused (Refusal q [] [unwords truth]
                (length (takeWhile id (zipWith (==) claimed truth)))
                (VargaResidual missing extra walk)
                ("the class is the interval from " ++ from ++ " to the anubandha "
                 ++ marker ++ "; the walk is the certificate"))

------------------------------------------------------------------------
-- 5c.  the karaka door.  2.3.1 anabhihite as a gate: the assignment is
--      consulted only for a karaka the verbal ending has not expressed.
------------------------------------------------------------------------
dvara q@(AskKaraka v k vb) =
  let (got, why) = vibhaktiOf v k
  in if got == vb
       then Admitted Certificate
              { certQuery      = q
              , certForm       = show got
              , certAllForms   = [show got]
              , certTrace      = []
              , certContention = []
              , certRemainder  = []
              , certAsiddha    = []
              , certGround     = why
              , certSyat       = "syād asti: under the voice " ++ show v
                                 ++ ", and the same kāraka under the other voice "
                                 ++ "takes " ++ show (fst (vibhaktiOf (other v) k))
              }
       else Refused (Refusal q [] [show got] 0
              (KarakaResidual got vb why)
              ("the kāraka is unchanged and the vibhakti is not: what decides is "
               ++ "whether the ending already expressed it (2.3.1 anabhihite)"))
  where
    other Kartari = Karmani
    other Karmani = Kartari

-- The respect in which an admission holds.  Where the grammar left the
-- question open this says so IN THE ADMISSION, so a certificate can never be
-- read as more than it is.
syat :: [String] -> String -> [Remainder] -> String
syat forms claim rems
  | length forms > 1 =
      "syād asti ca avaktavyaṃ ca: " ++ claim ++ " stands, and so does "
      ++ intercalate " / " (forms \\ [claim])
      ++ " -- the grammar states the option itself ("
      ++ intercalate "; " [ g | r <- rems, let g = groundText (remGround r) ]
      ++ "), so neither is a default and the pair cannot be uttered as one"
  | otherwise = "syād asti: the derivation is the one below, and nothing in it was defaulted"
  where
    groundText (Vibhasa r t) = showRef r ++ " " ++ t
    groundText (NayaVirodha a b) = showRef a ++ " against " ++ showRef b

------------------------------------------------------------------------
-- 6.  READING A RESPONSE.
------------------------------------------------------------------------

renderResponse :: Response -> [String]
renderResponse (Admitted c) =
  [ "ADMITTED   " ++ certForm c ]
  ++ [ "  ground:  " ++ certGround c ]
  ++ [ "  syāt:    " ++ certSyat c ]
  ++ (if length (certAllForms c) > 1
        then [ "  the grammar allows: " ++ intercalate " / " (certAllForms c) ] else [])
  ++ concatMap step (certTrace c)
  ++ concatMap contention (certContention c)
  ++ concatMap remainder (certRemainder c)
  ++ [ "  " ++ showRef r ++ " would fire on this form and does not -- " ++ why
     | (r, why) <- certAsiddha c ]
  ++ [ "  audit by a party that did not produce it: "
       ++ (case audit c of { [] -> "replays, step by step"; es -> unwords es }) ]
  where
    step f =
      [ "    " ++ showRef (fSutra f) ++ " @" ++ show (fPos f) ++ "  " ++ fText f
        ++ "   [" ++ show (fPhase f) ++ "]"
      , "        " ++ fNote f
      , "        " ++ render (fBeforeI f) ++ "  ⇒  " ++ render (fAfterI f)
      ] ++ verdict (fAdj f)
    verdict (Sole _) = []
    verdict (InOrder _) = []
    verdict (Decided _ ns beaten why) =
      [ "        decided by " ++ show ns ++ ", beating "
        ++ unwords (map showRef beaten) ++ " -- " ++ why ]
    verdict (Undecided brs why) =
      [ "        UNDECIDED " ++ show [ (n, showRef r) | (n, r) <- brs ] ++ " -- " ++ why ]
    contention c' =
      [ "  contention @" ++ show (cPos c') ++ ": "
        ++ unwords (map showRef (cOffered c')) ]
    remainder r =
      [ "  REMAINDER (" ++ show (remGround r) ++ "): "
        ++ intercalate " | " [ maybe "not applied" showRef mr ++ " -> " ++ f
                             | (mr, f) <- remBranches r ]
      , "        " ++ remWhy r ]
renderResponse (Refused r) =
  [ "REFUSED" ]
  ++ [ "  reached: " ++ intercalate " / " (refReached r) ]
  ++ [ "  stalled at position " ++ show (refStalledAt r) ]
  ++ [ "  ground:  " ++ refGround r ]
  ++ residual (refResidual r)
  where
    residual (SesaPada pre hv wt th tw off) =
      [ "  residual (kuṭṭaka): agreed on " ++ unwords pre
      , "        the pair: grammar " ++ maybe "(nothing)" id hv
                             ++ "  against claim " ++ maybe "(nothing)" id wt
      , "        tails kept whole: " ++ unwords th ++ "  /  " ++ unwords tw
      , "        sūtras in play there: " ++ unwords (map showRef off) ]
    residual (Hetu cnf fnc) =
      [ "  residual (hetu): cited and did not fire: " ++ unwords (map showRef cnf)
      , "                   fired and was not cited: " ++ unwords (map showRef fnc) ]
    residual (Avisaya u cov) =
      [ "  residual (aviṣaya): not in the varṇasamāmnāya: " ++ unwords u
      , "        " ++ cov
      , "        this is a statement about coverage, not a verdict about Sanskrit" ]
    residual (VargaResidual m e walk) =
      [ "  residual: missing " ++ unwords m ++ "; extra " ++ unwords e
      , "        the walk: " ++ unwords [ case sl of { Snd s -> s; It i -> "(" ++ i ++ ")" }
                                        | sl <- walk ] ]
    residual (KarakaResidual g w why) =
      [ "  residual: the grammar gives " ++ show g ++ ", the claim was " ++ show w
      , "        " ++ why ]

------------------------------------------------------------------------
-- 7.  SELFTEST.
--
-- Half of these are cases that MUST FAIL.  A door that only ever admits has
-- not been tested; it has been demonstrated.  Returns [] or names what
-- failed.
------------------------------------------------------------------------

selfTest :: [String]
selfTest = concat
  [ admitTests
  , fluentButWrongTests
  , wrongDerivationTests
  , outsideDomainTests
  , remainderTests
  , auditTests
  , vargaTests
  , karakaTests
  , structureTests
  ]
  where
    chk name got want
      | got == want = []
      | otherwise   = [ name ++ ": got " ++ show got ++ ", wanted " ++ show want ]

    isAdmitted (Admitted _) = True
    isAdmitted _            = False

    ask j f cs = dvara (AskSandhi j f cs)

    -- 7.1  what passes.  Each of these is the attested form and each carries
    -- a trace that replays.
    admitTests = concat
      [ chk "devendra admitted"      (isAdmitted (ask "deva + indra" "devendra" []))      True
      , chk "dadhīndra admitted"     (isAdmitted (ask "dadhi + indra" "dadhīndra" []))    True
      , chk "sūkta admitted"         (isAdmitted (ask "su + ukta" "sūkta" []))            True
      , chk "maharṣi admitted"       (isAdmitted (ask "mahā + ṛṣi" "maharṣi" []))         True
      , chk "te'pi admitted"         (isAdmitted (ask "te + api" "te'pi" []))             True
      , chk "nayana admitted"        (isAdmitted (ask "ne - ana" "nayana" []))            True
      , chk "tajjalam admitted"      (isAdmitted (ask "tat + jalam" "tajjalam" []))       True
      -- with the citation checked, not merely the form
      , chk "devendra by 6.1.87 admitted"
          (isAdmitted (ask "deva + indra" "devendra" [(6,1,87)])) True
      , chk "dadhīndra by 6.1.101 admitted"
          (isAdmitted (ask "dadhi + indra" "dadhīndra" [(6,1,101)])) True
      , chk "tajjalam by 8.2.39 + 8.4.40 admitted"
          (isAdmitted (ask "tat + jalam" "tajjalam" [(8,2,39),(8,4,40)])) True
      ]

    -- 7.2  MUST FAIL: the fluent wrong answer.  `dadhyindra` is what 6.1.77
    -- alone produces, it is well-formed Sanskrit phonology, and it is not the
    -- word.  A fluency judge admits it.
    fluentButWrongTests =
      let r1 = ask "dadhi + indra" "dadhyindra" []
          r2 = ask "te + api" "tayapi" []
          r3 = ask "deva + indra" "devaindra" []
          r4 = ask "tat + jalam" "tadjalam" []      -- the simultaneous-regime form
      in concat
         [ chk "dadhyindra REFUSED (6.1.77 alone; 1.4.2 gives it to 6.1.101)"
             (isAdmitted r1) False
         , chk "tayapi REFUSED (6.1.78 alone; 1.4.2 gives it to 6.1.109)"
             (isAdmitted r2) False
         , chk "devaindra REFUSED (no sandhi at all)"
             (isAdmitted r3) False
         , chk "tadjalam REFUSED (the asiddhavat regime's form, not the tripādī's)"
             (isAdmitted r4) False
         -- the residual is the pair, and it is the right pair
         , case r1 of
             Refused ref -> case refResidual ref of
               SesaPada pre hv wt _ _ off -> concat
                 [ chk "dadhyindra: agreed prefix" pre ["d","a","dh"]
                 , chk "dadhyindra: the pair" (hv, wt) (Just "ī", Just "y")
                 , chk "dadhyindra: 6.1.77 is named in the residual"
                     ((6,1,77) `elem` off) True
                 , chk "dadhyindra: 6.1.101 is named in the residual"
                     ((6,1,101) `elem` off) True ]
               other -> ["dadhyindra: wrong residual constructor: " ++ show other]
             _ -> ["dadhyindra was admitted"]
         , case r2 of
             Refused ref -> case refResidual ref of
               SesaPada _ hv wt _ _ _ -> chk "tayapi: the pair" (hv, wt) (Just "e", Just "a")
               other -> ["tayapi: wrong residual constructor: " ++ show other]
             _ -> ["tayapi was admitted"]
         ]

    -- 7.3  MUST FAIL: the right form with the wrong derivation.  This is the
    -- case the purvapaksa says a door of this kind cannot catch.
    wrongDerivationTests =
      let r = ask "deva + indra" "devendra" [(6,1,101)]
      in concat
         [ chk "devendra cited to 6.1.101 REFUSED (6.1.87 is what fires)"
             (isAdmitted r) False
         , case r of
             Refused ref -> case refResidual ref of
               Hetu cnf fnc -> concat
                 [ chk "hetu residual: cited and did not fire" cnf [(6,1,101)]
                 , chk "hetu residual: fired and was not cited" fnc [(6,1,87)] ]
               other -> ["wrong residual constructor: " ++ show other]
             _ -> ["it was admitted"]
         , chk "dadhīndra cited to 6.1.77 REFUSED (77 was beaten, not fired)"
             (isAdmitted (ask "dadhi + indra" "dadhīndra" [(6,1,77)])) False
         , chk "an incomplete citation is REFUSED (tajjalam needs both sūtras)"
             (isAdmitted (ask "tat + jalam" "tajjalam" [(8,4,40)])) False
         ]

    -- 7.4  MUST FAIL, AND FOR A DIFFERENT REASON.  Coverage is not a verdict.
    outsideDomainTests =
      let r = ask "deva + zeus" "devazeus" []
      in concat
         [ chk "a sound outside the varṇasamāmnāya is REFUSED" (isAdmitted r) False
         , case r of
             Refused ref -> case refResidual ref of
               Avisaya u _ -> chk "and the residual names it, as aviṣaya" u ["z"]
               other -> ["wrong residual constructor: " ++ show other]
             _ -> ["it was admitted"]
         ]

    -- 7.5  THE REMAINDER.  8.4.56 states its own option, so `vāc` in pause is
    -- two forms and the door admits either -- with the other named in the
    -- certificate.  Astadhyayi.derive prints one of them.
    remainderTests =
      let a = ask "vāc" "vāk" []
          b = ask "vāc" "vāg" []
      in concat
         [ chk "vāk admitted"  (isAdmitted a) True
         , chk "vāg admitted"  (isAdmitted b) True
         , chk "the deterministic engine returns only one of the two"
             (A.derive "vāc" `elem` ["vāk", "vāg"]) True
         , chk "the door returns both"
             (sortOn id (nub (map (render . wItems) (worlds (parseInput "vāc")))))
             ["vāg","vāk"]
         , case a of
             Admitted c -> concat
               [ chk "the vāk certificate names vāg too"
                   (sortOn id (certAllForms c)) ["vāg","vāk"]
               , chk "and carries the remainder"
                   (length (certRemainder c)) 1
               , chk "whose ground is the sūtra's own option word"
                   [ r | Remainder (Vibhasa r _) _ _ <- certRemainder c ] [(8,4,56)]
               , chk "and both branches are in it"
                   (length (concatMap remBranches (certRemainder c))) 2
               , chk "the syāt statement is the fourth position, not a preference"
                   ("syād asti ca avaktavyaṃ ca" `isPrefixOf` certSyat c) True ]
             _ -> ["vāk was refused"]
         -- the two reasons a rule can fail to fire on a finished form are not
         -- merged: 8.2.1 refusing it, and the grammar leaving it open
         , chk "on vāk, 8.2.39 is refused by 8.2.1"
             (case a of
                Admitted c -> [ r | (r, w) <- certAsiddha c
                                  , take 5 w == "8.2.1" ]
                _ -> []) [(8,2,39)]
         , chk "on vāg, 8.4.56 is the option and is NOT called a refusal"
             (case b of
                Admitted c -> [ r | (r, w) <- certAsiddha c
                                  , take 5 w /= "8.2.1" ]
                _ -> []) [(8,4,56)]
         -- a form that is NEITHER branch is still refused: the remainder is
         -- two positions, not a licence
         , chk "vāc itself REFUSED (neither branch)"
             (isAdmitted (ask "vāc" "vāc" [])) False
         , chk "where the grammar decides, there is no remainder"
             (case ask "deva + indra" "devendra" [] of
                Admitted c -> null (certRemainder c)
                _          -> False) True
         ]

    -- 7.6  THE CERTIFICATE REPLAYS.  `audit` re-fires each step from the
    -- sutra table on the step's own input; it does not consult the engine.
    auditTests = concat
      [ chk "every admitted certificate replays"
          [ (j, f, audit c)
          | (j, f) <- [ ("deva + indra", "devendra"), ("dadhi + indra", "dadhīndra")
                      , ("su + ukta", "sūkta"), ("te + api", "te'pi")
                      , ("ne - ana", "nayana"), ("tat + jalam", "tajjalam")
                      , ("vāc", "vāk"), ("vāc", "vāg"), ("rāmas", "rāmaḥ") ]
          , Admitted c <- [ask j f []]
          , not (null (audit c)) ]
          []
      -- and the audit is not vacuous: corrupt one step and it says so
      , chk "a certificate with a forged step fails the audit"
          (case ask "deva + indra" "devendra" [] of
             Admitted c ->
               let bad = c { certTrace = [ f { fSutra = (6,1,101) } | f <- certTrace c ] }
               in not (null (audit bad))
             _ -> False) True
      , chk "a certificate whose steps do not chain fails the audit"
          (case ask "tat + jalam" "tajjalam" [] of
             Admitted c ->
               let bad = c { certTrace = reverse (certTrace c) }
               in not (null (audit bad))
             _ -> False) True
      ]

    -- 7.7  the pratyahara door
    vargaTests = concat
      [ chk "iK = i u ṛ ḷ admitted"
          (isAdmitted (dvara (AskVarga "i" "k" ["i","u","ṛ","ḷ"]))) True
      , chk "iK with an extra member REFUSED"
          (isAdmitted (dvara (AskVarga "i" "k" ["i","u","ṛ","ḷ","e"]))) False
      , chk "aṆ = a i u admitted"
          (isAdmitted (dvara (AskVarga "a" "ṇ" ["a","i","u"]))) True
      , chk "a marker is never a member: aC does not contain ṅ"
          (isAdmitted (dvara (AskVarga "a" "c"
             ["a","i","u","ṛ","ḷ","e","o","ai","au","ṅ"]))) False
      , case dvara (AskVarga "i" "k" ["i","u","ṛ","ḷ","e"]) of
          Refused ref -> case refResidual ref of
            VargaResidual m e _ -> concat
              [ chk "varga residual: missing" m []
              , chk "varga residual: extra"   e ["e"] ]
            other -> ["wrong residual constructor: " ++ show other]
          _ -> ["it was admitted"]
      ]

    -- 7.8  the karaka door: 2.3.1 anabhihite
    karakaTests = concat
      [ chk "active kartṛ takes prathamā -- admitted"
          (isAdmitted (dvara (AskKaraka Kartari Kartr Prathama))) True
      , chk "active kartṛ claimed as tṛtīyā -- REFUSED"
          (isAdmitted (dvara (AskKaraka Kartari Kartr Trtiya))) False
      , chk "passive kartṛ takes tṛtīyā -- admitted"
          (isAdmitted (dvara (AskKaraka Karmani Kartr Trtiya))) True
      , chk "passive karman claimed as dvitīyā -- REFUSED"
          (isAdmitted (dvara (AskKaraka Karmani Karman Dvitiya))) False
      ]

    -- 7.9  the machinery, checked on its own terms
    structureTests = concat
      [ -- every vibhasa listed is a sutra that exists, and is in the tripadi
        -- (phase A does not fork, and this is why it is allowed not to)
        chk "every vibhāṣā names an encoded sūtra"
          [ r | (r, _) <- vibhasa, not (any ((== r) . num) sutras) ] []
      , chk "every vibhāṣā is in the tripādī"
          (all (tripadi . fst) vibhasa) True
      -- the naya-virodha branch is implemented and UNEXERCISED, and this is
      -- the assertion of that, so a future rule breaks the test
      , chk "no naya-virodha arises in the encoded fragment"
          nayaVirodhaCandidates []
      -- both nayas are recorded where they agree, rather than collapsed
      , chk "contention records both standpoints where they agree"
          (case ask "dadhi + indra" "dadhīndra" [] of
             Admitted c -> [ ns | Contention _ _ (Decided _ ns _ _) <- certContention c ]
             _          -> []) [[Paratva]]
      , chk "the contention at dadhi+indra names both sūtras"
          (case ask "dadhi + indra" "dadhīndra" [] of
             Admitted c -> sortOn id (concatMap cOffered (certContention c))
             _          -> []) [(6,1,77),(6,1,101)]
      , chk "where one rule fires there is no contention"
          (case ask "deva + indra" "devendra" [] of
             Admitted c -> null (certContention c)
             _          -> False) True
      -- the door's worlds agree with the engine wherever the engine has no
      -- option to take
      , chk "door and engine agree on every unbranched form"
          [ (j, A.derive j, fs)
          | j <- [ "deva + indra", "dadhi + indra", "mahā + indra", "su + ukta"
                 , "deva + ṛṣi", "mahā + ṛṣi", "madhu + ari", "deva + aiśvarya"
                 , "te + api", "ne - ana", "ne + ana", "rāmas", "tat + ca"
                 , "tat + jalam" ]
          , let fs = nub (map (render . wItems) (worlds (parseInput j)))
          , fs /= [A.derive j] ]
          []
      ]
