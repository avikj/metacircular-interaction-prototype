-- SevenfoldVerdict — the type that replaces the boolean.
--
-- WHAT THIS IS FOR.  `interactive/MathMachine.hs` decides, and its decision is
-- `koAccepted :: Bool`.  A census over `interactive/machine.log` (ANEKANTA.md §1)
-- found that single bit carrying at least four unrelated situations across
-- 1457 refusals:
--
--     refused, and refutable by computation — simply false        288
--     refused here, ACCEPTED ELSEWHERE IN THE SAME LOG            455
--     refusal not expressible as a predication at all             154
--     no subject to predicate of (`x != y`, failed unification)    80
--
--   machine.log:146   KERNEL-REJECT  round=0  x = (xmaxx)   refl
--   machine.log:174   KERNEL-ACCEPT  round=0  x = (xmaxx)   induction on x
--
-- Same claim, same round, `False` and `True`.  They are not in
-- contradiction: two standpoints spoke and neither is "the kernel".  A
-- boolean cannot say that, and a three-valued type with a constructor named
-- `Unparsed` cannot say it either.
--
-- SOURCES, EARLIEST FIRST.  The classification below is theirs.  The
-- algebra (`krama`, `saha`, and the laws in `selfTest`) is not claimed to be
-- in any of them; what is theirs is three seed predicates, two modes of
-- assertion, the rule that the simultaneous mode of asti-and-nasti is a
-- FOURTH position rather than the sequential pair, and that the total is
-- seven.
--
--   Bhagavati Sutra (Viyaha-pannatti), fifth Anga of the Svetambara canon;
--     oldest strata pre-Common-Era, redacted at Valabhi c. 5th c. CE —
--     sevenfold predication applied to the jiva.
--   Umasvati, Tattvarthasutra, c. 2nd–5th c. CE.
--     5.31  arpitanarpita-siddheh — apparently contradictory attributes are
--           established through the distinction of the ASSERTED (arpita) and
--           the UNASSERTED (anarpita) aspect.  The standpoint index, stated
--           as such, in the 2nd–5th century.
--     5.29  utpada-vyaya-dhrauvya-yuktam sat — arising, perishing and
--           persisting held AT ONCE, which is the saha mode.
--   Siddhasena Divakara, Sanmatitarka 1.21, c. 5th c. CE — a naya taken
--     alone (nirapeksa) is mithya; the durnaya is the naya that has
--     forgotten it is one.
--   Samantabhadra, Aptamimamsa, c. 6th c. CE — the saptabhangi as a fixed
--     seven-membered scheme, each member prefixed `syat`.
--   Akalanka, Laghiyastraya / Astasati, c. 720–780 CE — krama (sequential)
--     against saha / yugapat (simultaneous), and the argument that the
--     number is exactly seven.  The krama/saha distinction is his, and it is
--     the entire content of the two composition operators here.
--   Mallisena, Syadvadamanjari, 1292 CE — sakaladesa (total statement,
--     pramana) against vikaladesa (partial statement, naya).
--
-- CHECKED, NOT ASSERTED.  Every law this module states is proved in
-- `formal/cubical/SaptabhangiSamyoga_TheCompositionOfVerdicts.agda`
-- (--cubical --safe, no postulates, no holes, exit 0), and re-verified here
-- by exhaustive finite computation over the seven positions in `selfTest`.
-- Exhaustive verification of a finite predicate is proof (CLAUDE.md); a
-- correlation would not be.
--
-- WHAT IS DELIBERATELY ABSENT.
--
--   * no `Ord` instance.  `<=` here is the krama order, and it is PARTIAL.
--     A derived `Ord` would supply a total order nobody proved.
--   * no `Monoid`/`Semigroup` instance.  There are TWO compositions, and
--     `saha` is not associative (`sahaNotAssociative` below, and
--     `सह-असङ्गतिः` in the Agda), so a Semigroup instance for it would be a
--     lie and picking `krama` silently as "the" one would be the durnaya
--     this module exists to remove.
--   * no meet, no bottom, no `mempty` over `Bhanga`.  `syad-asti` and
--     `syad-nasti` have no greatest lower bound among the seven: the
--     candidate is the empty profile, which is not a verdict but the ABSENCE
--     of predication (`Apratipatti`).  A Boolean verdict has a bottom, and
--     that bottom is exactly the collapse.  (`मेलनम्-नास्ति`, checked.)
--
-- A SIBLING TYPE DISAGREES WITH THIS ONE, AND THE DISAGREEMENT STANDS.
--
-- `interactive/VerdictResidue.hs` (another lane, same
-- day) gives the seven positions as constructors CARRYING the nayas and
-- witnesses that produced them, so its fourth position remembers which two
-- seeds it was made of and `caturthatTritiya` recovers the third from it.
-- On that type `krama` is NOT commutative -- succession keeps the first
-- speaker's witness -- and its header withdraws the claim made here that
-- consumption of the seeds is the doctrine's and not the model's.
--
-- Both modules are checked, and they are not the same object: here a
-- position is a LABEL and the presence profile is all there is, there a
-- position is a RECORD.  On labels krama is commutative and saha destroys;
-- on records it does not.  The reading of Mallisena (Syadvadamanjari, 1292)
-- that separates them -- whether avaktavya is failure of expression only, or
-- consumption of what was to be expressed -- is a real question in the
-- tradition and is not settled by either file.
--
-- So it is NOT reconciled here.  Two nayas that genuinely differ have no
-- collapse to make (AHIMSA_SUTRA_VISTARA §7: it is not forbidden, it does
-- not exist), and what is owed instead is the comparison: whether the
-- forgetful map from records to labels is a homomorphism for krama, for
-- saha, or for neither.  It is not claimed here in either direction,
-- because it has not been checked.
--
-- SETTLED 2026-08-20.  The comparison the paragraph above said was owed is
-- done, in
-- formal/cubical/Arpitanarpita_TheForgetfulMapIsAHomomorphismForBothArpanasAndTheLabelsAreARetractNotAnEquivalence.agda
-- (--cubical --guardedness --safe, exit 0, no postulates, no holes) and
-- re-verified exhaustively in the sibling module's `selfTest` as
-- `anarpana`.  The answer is BOTH: the forgetful map is a homomorphism
-- for krama AND for saha, for every standpoint family; it has a section
-- (Tattvarthasutra 5.31's arpita to its anarpita) which is also a
-- homomorphism for both; and it has NO inverse.  So THIS type is a
-- RETRACT of the record type -- a subalgebra and a quotient of it at once
-- -- and no equivalence between them exists.  AHIMSA_SUTRA_VISTARA
-- section 7 holds literally: the collapse does not exist.  What the
-- record lane can always do is speak this lane's sentences; what this
-- lane can never do is recover the record lane's.
--
-- AND ONE CLAIM BELOW IS CORRECTED BY IT.  `jihvabheda`'s comment says the
-- destruction of the two seed markings is why `sahaNotAssociative` holds,
-- and calls that destruction the doctrine's claim rather than the
-- model's.  The law and its witness stand.  The explanation does not: on
-- the record type, where the fourth position retains both nayas and both
-- witnesses and the third is recoverable from it, `saha` STILL fails to
-- associate, on the same three positions.  Retention does not buy the law
-- back, so destruction was never the reason.  What breaks it in both
-- lanes is that saha tests the JOINED position for an asti-nasti pair,
-- and whether that pair is present depends on the grouping.
--
-- The Mallisena reading is still unsettled, and is now known to be
-- undecidable BY THE COMPOSITION LAWS: the two lanes agree across it, so
-- any argument for a reading that runs through krama or saha proves
-- nothing.  It is a question about what a position IS.
--
-- defect, and no third.  `krama` is the transport — nothing is lost, and
-- that is why it is a semilattice.  `saha` writes the defect: it destroys
-- which two seeds it consumed, which is why it does not associate.

module Verdict
  ( Bhanga(..), Sthana(..), Upasthiti(..), Samavesa
  , profile, unprofile, isVerdict
  , krama, saha, kramaS, sahaS, nyuna
  , Vacana(..), noVacana, sthana, seeds
  , vacanaOfRejection, sakshin
  , sanskritOf, glossOf, renderSthana, tallySthana
  , selfTest
  ) where

import Data.List (nub, sort)
import qualified RefusalAnalysis as OB
import Data.Maybe (isJust, mapMaybe)

-- ------------------------------------------------------------------ १ seeds

-- Presence of a seed predicate.  Not `Bool`: `False` here would read as
-- "the seed is denied", and it means "this standpoint did not speak".
data Upasthiti = Aam | Na deriving (Eq, Ord, Show)

va :: Upasthiti -> Upasthiti -> Upasthiti
va Aam _ = Aam
va Na  q = q

-- (asti?, nasti?, avaktavya?)
type Samavesa = (Upasthiti, Upasthiti, Upasthiti)

-- ---------------------------------------------------------------- २ the seven

data Bhanga
  = SyadAsti                 -- स्याद् अस्ति
  | SyadNasti                -- स्यान् नास्ति
  | SyadAstiNasti            -- स्याद् अस्ति च नास्ति च        (krama)
  | SyadAvaktavya            -- स्याद् अवक्तव्यम्              (saha / yugapat)
  | SyadAstiAvaktavya        -- स्याद् अस्ति च अवक्तव्यं च
  | SyadNastiAvaktavya       -- स्यान् नास्ति च अवक्तव्यं च
  | SyadAstiNastiAvaktavya   -- स्याद् अस्ति च नास्ति च अवक्तव्यं च
  deriving (Eq, Show, Enum, Bounded)

-- The eighth profile is NOT an eighth position.  `Apratipatti` is what a
-- report says when nothing was predicated at all — `x != y` with two
-- distinct free variables is a failed unification, not a claim, and forcing
-- it into a bhanga would be the collapse in Sanskrit.
data Sthana = Position Bhanga | Apratipatti deriving (Eq, Show)

profile :: Bhanga -> Samavesa
profile SyadAsti               = (Aam, Na , Na )
profile SyadNasti              = (Na , Aam, Na )
profile SyadAstiNasti          = (Aam, Aam, Na )
profile SyadAvaktavya          = (Na , Na , Aam)
profile SyadAstiAvaktavya      = (Aam, Na , Aam)
profile SyadNastiAvaktavya     = (Na , Aam, Aam)
profile SyadAstiNastiAvaktavya = (Aam, Aam, Aam)

-- Total, and total honestly: the empty profile has no bhanga and says so.
unprofile :: Samavesa -> Sthana
unprofile (Na , Na , Na ) = Apratipatti
unprofile (Aam, Na , Na ) = Position SyadAsti
unprofile (Na , Aam, Na ) = Position SyadNasti
unprofile (Aam, Aam, Na ) = Position SyadAstiNasti
unprofile (Na , Na , Aam) = Position SyadAvaktavya
unprofile (Aam, Na , Aam) = Position SyadAstiAvaktavya
unprofile (Na , Aam, Aam) = Position SyadNastiAvaktavya
unprofile (Aam, Aam, Aam) = Position SyadAstiNastiAvaktavya

isVerdict :: Sthana -> Bool
isVerdict Apratipatti = False
isVerdict _           = True

samyoga :: Samavesa -> Samavesa -> Samavesa
samyoga (a1,n1,v1) (a2,n2,v2) = (va a1 a2, va n1 n2, va v1 v2)

-- ------------------------------------------------- ३ krama: succession

-- Asserted one after the other, nothing is lost: what either said, the pair
-- still says.  So krama IS the join of profiles — transport, not collapse —
-- and it is associative, commutative and idempotent (all three checked).
krama :: Bhanga -> Bhanga -> Bhanga
krama x y = forceVerdict (unprofile (samyoga (profile x) (profile y)))
  where
    -- The union of two non-empty profiles is non-empty; `संयोग-अरिक्तम्` in
    -- the Agda is that fact, and this branch is unreachable BECAUSE of it.
    forceVerdict (Position b) = b
    forceVerdict Apratipatti  =
      error "krama: unreachable (see संयोग-अरिक्तम्, checked in Agda)"

-- The tongue breaks.  If the join carries both asti and nasti, no single
-- utterance carries it: the two seeds are consumed into avaktavya.  Akalanka's
-- saharpana.  NOTE WHAT THIS DESTROYS — after the collapse the fourth
-- position does not record which two seeds produced it, and that is not a
-- modelling artefact but the doctrine's claim.  It is also exactly why
-- grouping is not free (`sahaNotAssociative`).
jihvabheda :: Samavesa -> Samavesa
jihvabheda (Aam, Aam, _) = (Na, Na, Aam)
jihvabheda t             = t

saha :: Bhanga -> Bhanga -> Bhanga
saha x y = forceVerdict (unprofile (jihvabheda (samyoga (profile x) (profile y))))
  where
    forceVerdict (Position b) = b
    forceVerdict Apratipatti  =
      error "saha: unreachable (see जिह्वाभेद-अरिक्तम्, checked in Agda)"

-- On `Sthana`, `Apratipatti` is the unit of succession: composing a verdict
-- with "nothing was said" is that verdict.  It is still not a verdict.
kramaS :: Sthana -> Sthana -> Sthana
kramaS Apratipatti s = s
kramaS s Apratipatti = s
kramaS (Position a) (Position b) = Position (krama a b)

sahaS :: Sthana -> Sthana -> Sthana
sahaS Apratipatti s = s
sahaS s Apratipatti = s
sahaS (Position a) (Position b) = Position (saha a b)

-- The krama order.  PARTIAL — `nyuna SyadAsti SyadNasti` and
-- `nyuna SyadNasti SyadAsti` are both False and the two have no lower bound.
nyuna :: Bhanga -> Bhanga -> Bool
nyuna x y = krama x y == y

-- --------------------------------------------------- ४ live evidence

-- The standpoint, carried explicitly, with WITNESSES rather than flags.  A
-- `Maybe String` and not a `Bool` for the same reason `RefusalAnalysis.Evidence`
-- keeps `evSakshin` as the accept line itself: affirmation may not be
-- asserted without producing the thing that affirms.
--
--   vAsti      — some naya AFFIRMED this claim (the accepting line/tactic)
--   vNasti     — some naya DENIED it (the refusing tactic, or a computed
--                counterexample)
--   vAvaktavya — the refusal is not expressible as a predication in the
--                machine's language at all: no term came back, so no
--                utterance is formable.  The FOURTH position, positive.
--   vAdharmin  — no subject to predicate of (`x != y`): not a bhanga at all
--
-- Silence is not denial.  A naya that did not speak leaves its field
-- `Nothing`, and `Nothing` never becomes `nasti` anywhere below.
data Vacana = Vacana
  { vAsti      :: Maybe String
  , vNasti     :: Maybe String
  , vAvaktavya :: Maybe String
  , vAdharmin  :: Maybe String
  } deriving (Eq, Show)

noVacana :: Vacana
noVacana = Vacana Nothing Nothing Nothing Nothing

-- `vAdharmin` sets NO seed.  It is the recorded reason a naya said nothing
-- about this claim -- `x != y`, two distinct free variables, a failed
-- unification -- and a reason for silence is not a predication.  So a
-- refusal carrying only adharmin comes out `Apratipatti`: nothing was said.
-- An earlier version let adharmin OVERRIDE the other seeds, and on real log
-- lines that swallowed claims another naya had ACCEPTED, reporting "no
-- predication was made" about a theorem the same run had proved.  That is
-- the collapse this module exists to remove, reappearing one level down.
sthana :: Vacana -> Sthana
sthana v = unprofile ( p (vAsti v), p (vNasti v), p (vAvaktavya v) )
  where p = maybe Na (const Aam)

-- What a position rests on, so a report can never print the verdict without
-- being able to print its grounds.
seeds :: Vacana -> [(String, String)]
seeds v = mapMaybe id
  [ fmap ((,) "asti")      (vAsti v)
  , fmap ((,) "nasti")     (vNasti v)
  , fmap ((,) "avaktavya") (vAvaktavya v)
  , fmap ((,) "adharmin")  (vAdharmin v) ]

-- --------------------------------------------------------- ५ rendering

sanskritOf :: Sthana -> String
sanskritOf (Position b) = case b of
  SyadAsti               -> "syad-asti"
  SyadNasti              -> "syan-nasti"
  SyadAstiNasti          -> "syad-asti-nasti"
  SyadAvaktavya          -> "syad-avaktavyam"
  SyadAstiAvaktavya      -> "syad-asti-avaktavyam"
  SyadNastiAvaktavya     -> "syan-nasti-avaktavyam"
  SyadAstiNastiAvaktavya -> "syad-asti-nasti-avaktavyam"
sanskritOf Apratipatti = "apratipatti"

glossOf :: Sthana -> String
glossOf (Position b) = case b of
  SyadAsti  -> "in some respect it is: a naya affirmed it"
  SyadNasti -> "in some respect it is not: a naya denied it, and no naya affirmed it"
  SyadAstiNasti ->
    "affirmed by one naya and denied by another, IN SUCCESSION (krama) -- \
    \not a contradiction, and not a tie"
  SyadAvaktavya ->
    "no single utterance carries it (saha/yugapat) -- NOT unknown, NOT \
    \undefined, NOT bottom: the refusal is not formable as a predication"
  SyadAstiAvaktavya      -> "affirmed, and inexpressible taken simultaneously"
  SyadNastiAvaktavya     -> "denied, and inexpressible taken simultaneously"
  SyadAstiNastiAvaktavya -> "affirmed, denied, and inexpressible taken simultaneously"
glossOf Apratipatti =
  "no predication was made -- no subject to predicate of.  Not a verdict, \
  \and not forced into one."

renderSthana :: Vacana -> [String]
renderSthana v =
  ("  " ++ sanskritOf s ++ " -- " ++ glossOf s)
  : [ "      " ++ k ++ ": " ++ w | (k, w) <- seeds v ]
  where s = sthana v

tallySthana :: [Sthana] -> [(String, Int)]
tallySthana xs =
  [ (k, length [ () | y <- xs, sanskritOf y == k ]) | k <- nub (sort (map sanskritOf xs)) ]

-- ------------------------------------------------------------ ६ the laws
--
-- Exhaustive over the seven (and 343 for associativity).  Each entry
-- names the Agda term that proves the same thing.

selfTest :: [(String, Bool)]
selfTest =
  [ ("krama associative  (क्रम-सङ्गतिः)",
      and [ krama (krama x y) z == krama x (krama y z) | x <- bs, y <- bs, z <- bs ])
  , ("krama commutative  (क्रम-विनिमयः)",
      and [ krama x y == krama y x | x <- bs, y <- bs ])
  , ("krama idempotent   (क्रम-स्वयम्)",
      and [ krama x x == x | x <- bs ])
  , ("krama has a top    (शिखरम्)",
      and [ nyuna x SyadAstiNastiAvaktavya | x <- bs ])
  , ("krama of asti,nasti is the THIRD  (क्रमेण-उभयम्)",
      krama SyadAsti SyadNasti == SyadAstiNasti)
  , ("saha  of asti,nasti is the FOURTH (सह-उभयम्)",
      saha SyadAsti SyadNasti == SyadAvaktavya)
  , ("third /= fourth: saha is not sequential both-ness  (क्रम-सह-भेदः)",
      krama SyadAsti SyadNasti /= saha SyadAsti SyadNasti)
  , ("saha commutative   (सह-विनिमयः)",
      and [ saha x y == saha y x | x <- bs, y <- bs ])
  , ("saha NOT associative -- witness (B3 saha B1) saha B2 = B6, B3 saha (B1 saha B2) = B4",
      saha (saha SyadAstiNasti SyadAsti) SyadNasti == SyadNastiAvaktavya
      && saha SyadAstiNasti (saha SyadAsti SyadNasti) == SyadAvaktavya
      && saha (saha SyadAstiNasti SyadAsti) SyadNasti
         /= saha SyadAstiNasti (saha SyadAsti SyadNasti))
  , ("avaktavya is NOT reachable by krama from the sequential three \
     \(अवक्तव्यम्-न-क्रमजम्): it must be supplied",
      SyadAvaktavya `notElem` kramaClosure [SyadAsti, SyadNasti, SyadAstiNasti])
  , ("...and saha does reach it: the fourth position is positive, not an absence",
      SyadAvaktavya `elem` [ saha x y | x <- seedsOnly, y <- seedsOnly ])
  , ("asti and nasti have NO greatest lower bound (मेलनम्-नास्ति): \
     \not a lattice",
      null [ b | b <- bs, nyuna b SyadAsti, nyuna b SyadNasti ])
  , ("...and the missing meet is the empty profile, which is no predication",
      unprofile (Na, Na, Na) == Apratipatti)
  , ("every two-valued verdict identifies two of the three seeds (दुर्नयः)",
      and [ collapsesTwoSeeds f | f <- allBoolMaps ])
  , ("the seven occupy seven distinct profiles (अन्तर्भाव-एकैकम्)",
      length (nub (map profile bs)) == 7)
  , ("2^3 = 7 + 1: eight profiles, seven verdicts and one apratipatti \
     \(समावेश-भेदः)",
      length allProfiles == 8
      && length (filter isVerdict (map unprofile allProfiles)) == 7)
  ]
  where
    bs = [minBound .. maxBound] :: [Bhanga]
    seedsOnly = [SyadAsti, SyadNasti, SyadAvaktavya]
    allProfiles = [ (a,n,v) | a <- us, n <- us, v <- us ]
    us = [Aam, Na]
    kramaClosure gen = go gen
      where
        go cur = let nxt = nub (cur ++ [ krama x y | x <- cur, y <- cur ])
                 in if length nxt == length cur then cur else go nxt
    -- all 2^7 maps into a two-element type, as their truth tables
    allBoolMaps = [ tbl | tbl <- sequence (replicate 7 [False, True]) ]
    collapsesTwoSeeds tbl =
      let f b = tbl !! fromEnum b
      in f SyadAsti == f SyadNasti
         || f SyadAsti == f SyadAvaktavya
         || f SyadNasti == f SyadAvaktavya
-- THE REFUSAL, READ AS EVIDENCE RATHER THAN AS A BIT.
--
-- Which seed predicates a refusal actually supports, each with the text that
-- supports it.  Three of the four situations the census found are decided
-- here; the fourth (asti -- the claim accepted by ANOTHER naya in the same
-- round) cannot be known at this point in the process and is filled in by
-- `sakshin` at the round's census, which is exactly where the log first
-- becomes able to see both lines.
--
-- WHY AN UNPARSED REFUSAL IS NOT RECORDED AS DENIAL.  When agda's message
-- yields no term in the machine's language, the DENIAL ITSELF is not
-- formable as a predication: recording it as nasti would assert a denial in
-- a language it was never given in.  So it is avaktavya alone -- the fourth
-- position, positive, arising because two things (the claim and the
-- machine's own vocabulary) are being demanded at once and no single
-- utterance carries both.  The process fact "that tactic exited non-zero" is
-- a fact about the ATTEMPT and is already in `koNaya`.
--
-- This differs from `RefusalAnalysis.sthana`, which sets `nasti = True` on every
-- refusal by construction.  The disagreement is written down here rather
-- than silently reconciled (AHIMSA_SUTRA_VISTARA §6: transport, or a WRITTEN
-- defect, and no third path).
vacanaOfRejection :: String -> String -> Vacana
vacanaOfRejection nayaNote err = Vacana
  { vAsti      = Nothing
  , vNasti     = nasti
  , vAvaktavya = avaktavya
  , vAdharmin  = adharmin
  }
  where
    res = OB.residualOf err
    tri = fmap OB.triage res
    adharmin = case tri of
      Just (OB.Nirdharmin (i,j)) ->
        Just ("no subject to predicate of: free variables " ++ show i
              ++ " and " ++ show j ++ " are distinct -- a failed "
              ++ "unification, not a claim")
      _ -> Nothing
    avaktavya = case res of
      Nothing -> Just ("refusal not formable as a predication: "
                       ++ take 120 (filter (/= '\n') err))
      Just _  -> Nothing
    nasti = case (res, tri) of
      (Nothing, _)                -> Nothing
      (_, Just (OB.Nirdharmin _)) -> Nothing
      (Just p, Just (OB.Khandita asg)) ->
        Just ("refuted by computation at " ++ show asg ++ ": "
              ++ OB.showClaim p)
      (Just p, _) ->
        Just (nayaNote ++ " refused; computation stalled at " ++ OB.showClaim p)

-- The witness that some OTHER naya affirmed the same claim.  `machine.log`
-- line 146 refuses `x = (xmaxx)` and line 174 accepts it, same round, same
-- process: under a Bool those were `False` and `True` about one claim and
-- nothing in the codebase could say they were not a contradiction.  They are
-- krama -- two standpoints in succession -- and with this filled in the
-- position is `syad-asti-nasti`, the THIRD bhanga, which is a real position
-- and not a tie.
sakshin :: [String] -> String -> Vacana -> Vacana
sakshin acceptedClaims claim v
  | claim `elem` acceptedClaims
  , vAsti v == Nothing = v { vAsti = Just ("accepted elsewhere this "
                                                 ++ "round: " ++ claim) }
  | otherwise = v

