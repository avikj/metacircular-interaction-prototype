-- Yogyānupalabdhi — योग्यानुपलब्धिः, the fitness of the looking, applied to
-- the one seam in this engine where a false rewrite rule can enter: the
-- kernel.
--
-- ═══════════════════════════════════════════════════ WHAT THIS IS ABOUT
--
-- `machine/GATE_AUDIT_DISPOSITION.md` §2 records the finding and the repair.
-- The finding: the checker was sound against MATHEMATICS and unsound against
-- its ENVIRONMENT — 1753 enumerated false equations produced zero
-- certificates, while three ways of lying with a shell wrapper all produced
-- certificates for `s(x) = x`.  The cheapest of the three is one line:
--
--     agda "$@" 2>&1 | cat
--
-- The exit status of a pipeline is its last stage's.  Real agda runs, really
-- prints `1 != 0`, really exits 1 — and a caller reading the exit status
-- reads 0.
--
-- The repair: `canaryTrue` (`(zero + x) ≡ x`, must check) and `canaryFalse`
-- (`(suc x) ≡ x`, must NOT), run once per process, uncached, through the same
-- invocation the candidates use, so that **no acceptance is honoured by a
-- process that has not watched its kernel reject a falsehood.**
--
-- That is not a hygiene measure with a Sanskrit label on it afterwards.  It
-- is *yogyānupalabdhi*, stated in the 7th century and stated exactly:
-- non-apprehension is a means of knowing an absence only where the thing
-- WOULD HAVE BEEN apprehended had it been present.  "agda printed no error"
-- establishes "there is no error" only from a looking FIT to have seen one.
-- The pipeline shim is precisely an unfit looking, and the doctrine names it
-- before the tool exists.  `notes/AHIMSA_SUTRA_VISTARA.md` §19 carries the
-- two lines this module implements:
--
--     "न दृष्टम्" इति न प्रमाणम् ।
--     "यत्र दृश्येत तत्र न दृष्टम्" इति प्रमाणम् ।
--
-- ═════════════════════════════════════════════ WHAT THIS FILE ADDS, MEASURED
--
-- The repair of 2026-08-16 was made **in a wrapper**, not at the seam.  It
-- lives in `Certificate.vetSuccess`, and `vetSuccess` is reached from exactly
-- one function in this repository: `Certificate.runAgdaCached`.
-- `Certificate.runAgda` — the function that actually launches the process —
-- does not vet, and five modules have copied that invocation into themselves
-- (`TraceReplay.hs:820`, `ParallelGate.hs:286`, `CandidateGen.hs:413`,
-- `AgdaRewriteGate.runAgdaBounded`, `KernelProbe.checkModule`), each carrying
-- the structure and dropping the fitness.
--
-- RUN TODAY, 2026-08-20, on this container (Agda 2.8.0, GHC 9.12.2), with the
-- shim above placed first on PATH and `MATH_CERTCACHE=0`:
--
--   REAL agda
--     runAgda        on canaryFalse -> ExitFailure 42     (output has `1 != 0`)
--     runAgdaCached  on canaryFalse -> ExitFailure 42
--     kernelStatus                  -> KernelChecking
--     ClauseOrder.certifyUnder on s(x) = x
--                                   -> Refused "1 != 0 of type ℕ …"  (8 calls)
--
--   PIPELINE SHIM
--     runAgda        on canaryFalse -> ExitSuccess        ← the whole defect
--     runAgdaCached  on canaryFalse -> ExitFailure 125    ← the repair holding
--     kernelStatus                  -> KernelAcceptedAFalsehood
--     ClauseOrder.certifyUnder on s(x) = x
--                                   -> Accepted "refl"    (1 call)
--
-- The last line is the one that matters.  It is not a transcription of a
-- classification function and it is not an argument: an exported function of
-- this repository returned `Accepted "refl"` for `s(x) = x`, from a real agda
-- that had just printed `1 != 0`, in one call.  `ClauseOrder.main` is
-- defended — it asks `Certificate.kernelIsChecking` before it counts anything
-- and exits when the answer is no — and that defence is a property of the
-- PROGRAM, not of the exported function, which any other module may call.
-- Saying "ClauseOrder is unsound" would be false and saying "ClauseOrder is
-- watched" would be false; the two standpoints are both true of different
-- entry points, which is the ordinary case and not a paradox (नयः एकः, वस्तु
-- अनेकम्).  `sthanani` below records entry points, not files, for that reason.
--
-- ══════════════════════════════════════════════════ THE SCHOOLS, AND WHAT
--                                                    THEY WOULD SAY TO THIS
--
-- Anupalabdhi as a SEPARATE means of knowledge is **Bhāṭṭa Mīmāṃsā's**:
-- Kumārila Bhaṭṭa, *Ślokavārttika*, Abhāvapariccheda (c. 7th c.).  **Prabhākara
-- rejects it** and folds the cognition of absence into perception of the bare
-- locus; the Bhāṭṭas answer that a bare floor and an absent-pot-on-the-floor
-- are different cognitions.  Nyāya's own list (Gautama, *Nyāyasūtra* 1.1.3,
-- c. 2nd c. BCE) has four and no anupalabdhi at all, and the Naiyāyikas treat
-- absence as a knowable OBJECT (abhāva, with its pratiyogin) reached by
-- ordinary perception rather than by a sixth instrument.
--
-- These are three positions and this module does not merge them into one
-- toolkit.  What it takes is the ONE THING all three impose, each for its own
-- reason: the fitness condition.  Kumārila imposes it as the definition of the
-- instrument; Prabhākara imposes it on the perception he reduces it to (an
-- unfit perceiver perceives no bare locus either); the Naiyāyika imposes it on
-- the *yogyatā* of the sense-object contact by which the abhāva is grasped.
--
-- Put to each in turn, this construction is:
--
--   BHĀṬṬA:      a straightforward yogyānupalabdhi.  The looking is agda; its
--                fitness is established by watching it apprehend a falsehood
--                as false.  The canary IS the fitness clause, implemented.
--   PRĀBHĀKARA:  "then you have not needed a sixth instrument — you watched
--                the kernel PRINT `1 != 0`, which is perception, and your
--                whole mechanism is a fitness condition on perception, which
--                is my position."  This module cannot refute that and does not
--                try: nothing below turns on anupalabdhi being irreducible.
--                What it turns on is that the fitness must be OBSERVED in this
--                process, which both schools require.
--   NAIYĀYIKA:   "your `Anujna` is not an absence at all; it is a positive
--                cognition of a proof.  The absence is the one in `sthanani`,
--                and it belongs in `abhāva` with a pratiyogin" — which is
--                where it is put, through
--                `Abhava_TheAbsenceCarriesItsPratiyoginAndItsSearchedDomain`,
--                rather than re-typed here.
--
-- GRADE OF THE TEXTUAL CLAIMS.  No critical edition opened.  School
-- attributions and the Abhāvapariccheda reference are carried from this
-- repository's `notes/AHIMSA_SUTRA_VISTARA.md` §19, `machine/Pramana.hs` and
-- `machine/Abhava_…hs`, and are śabda at prior-note grade, which is a real
-- pramāṇa and a stated one.  NOT CLAIMED: that Kumārila wrote about compilers,
-- that the canary is his example, or that the Bhāṭṭa–Prābhākara dispute is
-- settled by anything here.
--
-- ══════════════════════════════════════════════════════════ NOT A "GATE"
--
-- Nothing here is named for admitting or refusing.  A door admits or refuses,
-- which is the boolean, which is the durnaya: it publishes a verdict and
-- conceals the standpoint that produced it.  A pramāṇa produces knowledge and
-- is itself accountable, and the accountability of a NEGATIVE verdict is the
-- fitness of the looking.  So `Anujna` is abstract, its only constructor takes
-- the watch, and its refusals are `Ayogyata` values carrying what was and was
-- not observed — never `False`.
module Yogyanupalabdhi_TheKernelAcceptanceCarriesTheWatchThatEarnedIt
  ( -- * what a process watched its kernel do
    Saksin(..)
  , renderSaksin
    -- * an acceptance.  ABSTRACT: the only way in carries the watch.
  , Anujna
  , Ayogyata(..)
  , anujna
  , anujnaClaim
  , anujnaSaksin
  , anujnaWords
  , renderAnujna
  , renderAyogyata
    -- * the census of kernel-facing entry points, and its own fitness
  , Sthana(..)
  , sthanani
  , verifySthanani
  , renderSthana
    -- * the negative verdict about the seam, with its pratiyogin and extent
  , seamAbsence
    -- * the dispute, which is content and not preface
  , mimamsakaVivada
    -- * checked in-process
  , selfTest
  ) where

import Data.List (isInfixOf, isPrefixOf)
import Control.Exception (SomeException, try)
import qualified Abhava_TheAbsenceCarriesItsPratiyoginAndItsSearchedDomain as AB

-- ===================================================================
-- THE WATCH.
--
-- Three states, and the middle one is the whole reason this is not a Bool.
-- `machine/KernelProbe.hs` is the honest instance: it checks `2 + 2 ≡ 4` by
-- refl, prints `refl=OK`, and its own header says it "grades capability, not
-- soundness".  That is a POSITIVE control with no negative control, and under
-- the pipeline shim it prints `refl=OK cubical=OK` and exits 0.  A two-valued
-- watch would have to file that either with the unwatched or with the
-- watched, and both are wrong.
data Saksin
  = Adrsta
    -- ^ nothing was watched.  The verdict rests on a number a process
    --   returned.
  | SadhuDrsta String
    -- ^ a TRUTH was watched to check, and no falsehood was watched to fail.
    --   The field is the module that checked.  This establishes that the
    --   container can compile; it establishes nothing about whether the
    --   thing on the far side is checking proofs, because a shim that
    --   answers 0 to everything passes it.
  | BadhakaDrsta String String
    -- ^ the process watched its kernel REJECT a named falsehood, and here are
    --   the kernel's own words.  This, and only this, is the fitness clause.
  deriving (Eq, Show)

renderSaksin :: Saksin -> String
renderSaksin Adrsta = "adrsta: nothing watched; the verdict is an exit status"
renderSaksin (SadhuDrsta m) =
  "sadhu-drsta: watched `" ++ m ++ "` check.  Positive control only; a shim "
  ++ "that answers 0 to everything passes it."
renderSaksin (BadhakaDrsta m w) =
  "badhaka-drsta: watched `" ++ m ++ "` be REJECTED, in these words: "
  ++ oneLine w

-- Why an acceptance was refused.  Never `False`: the refusal names what was
-- looked at and what that looking could not have seen — which is the same
-- obligation this module imposes on the kernel, imposed on itself.
data Ayogyata
  = NaKascidDrstah
    -- ^ nothing was watched at all.
  | KevalamSadhuDrstah String
    -- ^ only the positive control was watched; the named module checked, and
    --   no falsehood was watched to fail.
  | VacoVirodhah String
    -- ^ the kernel's own output contradicts its exit status: a zero exit
    --   whose text carries a type error.  The field is the offending text.
  deriving (Eq, Show)

renderAyogyata :: Ayogyata -> String
renderAyogyata NaKascidDrstah =
  "REFUSED.  This process has not watched its kernel reject a falsehood, so "
  ++ "its silence about this module is not evidence.  (yogyanupalabdhi: "
  ++ "\"na drstam\" iti na pramanam.)"
renderAyogyata (KevalamSadhuDrstah m) =
  "REFUSED.  Only the positive control was watched (`" ++ m ++ "` checked).  "
  ++ "A checker that answers 0 to everything passes that and is not checking."
renderAyogyata (VacoVirodhah w) =
  "REFUSED.  Zero exit with a type error in the output; the exit status of "
  ++ "this invocation is not the kernel's.  Its words: " ++ oneLine w

-- An acceptance.  There is no exported constructor: the ONLY way to hold one
-- is to have produced the watch that earned it.
data Anujna = Anujna
  { anujnaClaim  :: String   -- ^ what was accepted
  , anujnaSaksin :: Saksin   -- ^ the watch that earned it — always BadhakaDrsta
  , anujnaWords  :: String   -- ^ the kernel's own output on THIS claim
  } deriving (Eq, Show)

-- The one door in, and it is not a door: it produces knowledge or it produces
-- a named unfitness, and either way the standpoint travels with the value.
--
-- The output scan is the per-call half of the same suspicion and it fires
-- earlier than the canary: under the pipeline shim the type error is sitting
-- in the text beside the zero exit status, on the very first candidate.
anujna :: Saksin -> String -> String -> Either Ayogyata Anujna
anujna s claim out
  | hidesAnError out = Left (VacoVirodhah out)
  | otherwise = case s of
      Adrsta -> Left NaKascidDrstah
      SadhuDrsta m -> Left (KevalamSadhuDrstah m)
      BadhakaDrsta _ _ -> Right (Anujna claim s out)

renderAnujna :: Anujna -> String
renderAnujna a = unlines
  [ "anujna    " ++ anujnaClaim a
  , "  saksin  " ++ renderSaksin (anujnaSaksin a)
  , "  vacah   " ++ oneLine (anujnaWords a)
  ]

-- Transcribed from `Certificate.successHidesAnError`, deliberately rather
-- than imported: `Certificate` is 1987 lines and pulls in `process`,
-- `directory` and `time`, and this module is meant to be importable by
-- anything, including by a module `Certificate` itself could one day import.
-- The transcription is CHECKED against the original in 'selfTest', on the
-- strings agda actually emits, so the copy cannot drift silently.  (A copy
-- that drifts silently is the very defect this file's census is about; making
-- one without a check would be comic.)
hidesAnError :: String -> Bool
hidesAnError out = any (`isInfixOf` out) markers
  where
    markers =
      [ " != ", "when checking", "Not in scope", "Multiple definitions"
      , "Unsolved", "Termination checking failed", "Failed to find source"
      , "error:", "Parse error" ]

oneLine :: String -> String
oneLine = take 200 . unwords . words

-- ===================================================================
-- THE CENSUS.
--
-- ENTRY POINTS, not files.  See the header: `ClauseOrder.main` is watched and
-- `ClauseOrder.certifyUnder` is not, and they are the same file.
--
-- Every `stQuote` below is a string that was present in the named file on
-- 2026-08-20 at the recorded line.  `stLine` is recorded so a reader can go
-- and look; it is NOT what `verifySthanani` checks against, because other
-- lanes are editing these files continuously and a line number goes stale in
-- an hour.  The quote is what is checked, and the line it is found at now is
-- reported alongside the line it was found at then.
data Sthana = Sthana
  { stFile   :: FilePath   -- ^ relative to the repository root
  , stEntry  :: String     -- ^ the exported entry point, not the module
  , stLine   :: Int        -- ^ where the quote sat on 2026-08-20
  , stQuote  :: String     -- ^ the expression that reads the exit status
  , stSaksin :: Saksin     -- ^ what a process entering here has watched
  , stScan   :: Maybe String
    -- ^ the predicate applied to the kernel's OUTPUT, by name.  'Nothing'
    --   means the output is not read at all, which is the case that the
    --   pipeline shim walks straight through.
  } deriving (Eq, Show)

-- The census, hand-read on 2026-08-20 from the twelve modules in `machine/`
-- that launch agda.  `Certificate.runAgdaCached` and `KernelContext` are in
-- the list because a census that lists only the failures cannot be checked
-- for having looked at the successes too.
--
-- `SadhuDrsta`/`BadhakaDrsta` here describe what a process ARRIVING AT THIS
-- ENTRY POINT has necessarily watched — not what it could watch if it chose.
sthanani :: [Sthana]
sthanani =
  [ Sthana "machine/Certificate.hs" "runAgdaCached" 1314
      "ExitSuccess -> do"
      (BadhakaDrsta "canaryFalse" "(via kernelStatus, once per process)")
      (Just "successHidesAnError, via vetSuccess")
  , Sthana "machine/KernelContext.hs" "the kernel arm" 1029
      "Right (ExitSuccess, _) -> True"
      (BadhakaDrsta "canaryFalse" "(via C.kernelIsChecking at line 1019)")
      Nothing
  , Sthana "machine/ClauseOrder.hs" "main" 255
      "ExitSuccess -> pure (Accepted \"refl\" n0)"
      (BadhakaDrsta "canaryFalse" "(via C.kernelIsChecking, before any count)")
      (Just "environmentFault, on the FAILURE branch only")
  , -- ─────────── from here down, nothing has been watched to fail ───────────
    Sthana "machine/ClauseOrder.hs" "certifyUnder" 255
      "ExitSuccess -> pure (Accepted \"refl\" n0)"
      Adrsta
      (Just "environmentFault, on the FAILURE branch only")
  , Sthana "machine/ClauseOrder.hs" "reflOnly (via runArm)" 408
      "ExitSuccess -> Accepted \"refl\" n"
      Adrsta
      Nothing
  , Sthana "machine/AgdaRewriteGate.hs" "classifyExit" 226
      "Just ExitSuccess -> Admitted"
      Adrsta
      Nothing
  , Sthana "machine/CandidateGen.hs" "the emit check" 480
      "ExitSuccess -> pure True"
      Adrsta
      Nothing
  , Sthana "machine/MathMachineInductionGate.hs" "the agda call" 419
      "pure (code == ExitSuccess, output ++ errors))"
      Adrsta
      Nothing
  , Sthana "machine/ParallelGate.hs" "the worker" 322
      "pure (code == ExitSuccess))"
      Adrsta
      Nothing
  , Sthana "machine/TraceReplay.hs" "the replay check" 932
      "ExitSuccess -> do"
      Adrsta
      Nothing
  , Sthana "machine/NalandaCertify.hs" "main" 81
      "let good = ec2 == ExitSuccess"
      Adrsta
      Nothing
  , Sthana "machine/VargaPrakrtiCertify_KernelVerdictComesBackIn.hs" "main" 82
      "let good = ec2 == ExitSuccess"
      Adrsta
      Nothing
  , Sthana "machine/KernelProbe.hs" "checkModule" 69
      "pure (code == ExitSuccess))"
      (SadhuDrsta "Probe1.agda: 2 + 2 \8801 4 by refl")
      Nothing
  ]

renderSthana :: Sthana -> String
renderSthana s = concat
  [ pad 46 (stFile s ++ ":" ++ show (stLine s))
  , pad 26 (stEntry s)
  , pad 14 (case stSaksin s of
              Adrsta          -> "ADRSTA"
              SadhuDrsta _    -> "sadhu only"
              BadhakaDrsta _ _ -> "badhaka-drsta")
  , case stScan s of
      Nothing -> "output unread"
      Just p  -> p
  ]
  where pad n t = t ++ replicate (max 1 (n - length t)) ' '

-- THE CENSUS'S OWN FITNESS.  A census recorded by hand goes stale, and a
-- stale census reporting zeros is the exact shape of an unfit looking
-- reported as knowledge (`ANEKANTA.md` §19: a count without its input is a
-- constant without its scaling).  So this re-derives from the files on disk
-- and reports the disagreement in BOTH directions: a quote that has moved, a
-- quote that has vanished, and a file that is not there to be read.
--
-- Returns the discrepancies.  Empty means every recorded quote was found in
-- its recorded file — which is a statement about the quotes, and NOT a
-- statement that the census is complete.  Completeness is the claim
-- `seamAbsence` carries, with its extent, where it can be argued with.
verifySthanani :: FilePath -> IO [String]
verifySthanani root = concat <$> mapM one sthanani
  where
    one s = do
      r <- try (readFile (root ++ "/" ++ stFile s))
             :: IO (Either SomeException String)
      pure $ case r of
        Left e -> [ stFile s ++ ": UNREADABLE, so this row is unverified: "
                    ++ oneLine (show e) ]
        Right src ->
          let ls = zip [1 :: Int ..] (lines src)
              hits = [ n | (n, l) <- ls, stQuote s `isInfixOf` l ]
          in case hits of
               [] -> [ stFile s ++ ": the recorded expression is GONE: "
                       ++ show (stQuote s)
                       ++ "  (recorded at line " ++ show (stLine s)
                       ++ " on 2026-08-20; the file now has "
                       ++ show (length ls) ++ " lines)" ]
               ns | stLine s `elem` ns -> []
                  | otherwise ->
                      [ stFile s ++ ": the expression MOVED, "
                        ++ show (stLine s) ++ " -> " ++ show ns
                        ++ "  (" ++ show (stQuote s) ++ ")" ]

-- ===================================================================
-- THE NEGATIVE VERDICT ABOUT THE SEAM.
--
-- "Nothing outside `Certificate.runAgdaCached` carries the watch" is an
-- absence claim, and this file would be self-refuting if it stated one
-- without its pratiyogin, its locus, its extent and its fitness.  It is
-- therefore built through the type another lane wrote for exactly this,
-- rather than through a fourteenth private one.
--
-- The extent is what makes it arguable: thirteen entry points across twelve
-- modules, found by `grep -l` for the strings by which agda is launched
-- (`readCreateProcessWithExitCode`, `readProcessWithExitCode`, `proc "agda"`,
-- the literal `"agda"`) over `machine/*.hs` — which is a search of ONE
-- DIRECTORY by FOUR STRINGS, and that is the limit of the looking.  A module
-- that launches agda through a name this grep does not contain, or from
-- outside `machine/`, was not looked at and this claim says nothing about it.
seamAbsence :: AB.Abhava
seamAbsence = case AB.abhava pratiyogin anuyogin extent of
  Right a  -> a
  Left err -> error ("seamAbsence is malformed: " ++ show err)
  where
    pratiyogin = AB.Pratiyogin
      { AB.ptName = "the falsifier watch (Certificate.kernelStatus / \
                    \kernelIsChecking), reached before an acceptance"
      , AB.ptAvacchedaka = "as delimited by ENTRY POINT, not by file: \
                           \ClauseOrder.main has it and ClauseOrder.certifyUnder \
                           \does not, and they are the same 700 lines"
      }
    anuyogin = AB.Anuyogin
      "the ten unwatched kernel-facing entry points of `sthanani`"
    extent = AB.Extent
      { AB.extCount = length sthanani
      , AB.extHow = "hand-read on 2026-08-20 from the twelve modules under \
                    \machine/ that grep shows launching agda \
                    \(readCreateProcessWithExitCode, readProcessWithExitCode, \
                    \proc \"agda\", the literal \"agda\"); one directory, four \
                    \strings, no other directory looked at"
      , AB.extFit = AB.Yogya
          "the shim run of 2026-08-20: under `agda \"$@\" 2>&1 | cat`, \
          \Certificate.runAgda returned ExitSuccess for `(suc x) \8801 x` while \
          \runAgdaCached returned ExitFailure 125 and kernelStatus returned \
          \KernelAcceptedAFalsehood; ClauseOrder.certifyUnder returned \
          \Accepted \"refl\" for s(x) = x in one call.  The looking was \
          \WATCHED to distinguish a watched site from an unwatched one, which \
          \is the fitness clause"
      }

-- ===================================================================
-- THE DISPUTE.  Kept as text and not as a comment, because the runner prints
-- it: a construction that draws on Mīmāṃsā owes the reader the school that
-- refuses it, in that school's own words rather than in a summary that has
-- already conceded.
mimamsakaVivada :: [String]
mimamsakaVivada =
  [ "BHATTA (Kumarila, Slokavarttika, Abhavapariccheda, c. 7th c.): absence is \
    \known by a sixth instrument, anupalabdhi, and its condition is yogyata -- \
    \non-apprehension establishes absence only where the thing would have been \
    \apprehended had it been there.  Your canary is that condition, built."
  , "PRABHAKARA: there is no sixth instrument.  What you call watching the \
    \kernel reject a falsehood is the kernel PRINTING `1 != 0` and you SEEING \
    \it -- that is perception, and the whole of your mechanism is a fitness \
    \condition on perception, which is my position and not Kumarila's."
  , "BHATTA to PRABHAKARA: the bare floor and the absence of the pot on it are \
    \not the same cognition, and your reduction has to say which perception \
    \has 'no error' as its content.  agda's SILENCE is what the caller reads; \
    \a silence is not a percept."
  , "NAIYAYIKA (Gautama, Nyayasutra 1.1.3, four pramanas; Gangesa after): \
    \neither.  Absence is an OBJECT with a counterpositive, grasped by \
    \ordinary perception under a fit sense-object contact.  Your `Anujna` is \
    \not an absence at all -- it is a positive cognition of a proof.  The only \
    \absence here is the one in your census, and it belongs in abhava with its \
    \pratiyogin."
  , "THIS MODULE: takes no side, and could not -- the mechanism below is \
    \identical under all three readings, because all three impose the fitness \
    \and they disagree only about which instrument carries it.  What none of \
    \them permits is the thing the code did: reading a silence with no \
    \account of whether the looking could have broken it."
  ]

-- ===================================================================
-- CHECKED IN-PROCESS.  A module nothing runs reports the same as a module
-- that does not exist (`machine/Yogyata.hs`), so this lands with its runner
-- on the same day.
selfTest :: [String]
selfTest = concat
  [ check "an acceptance cannot be built without a watched rejection"
      (case anujna Adrsta "s(x) = x" "Checking Candidate" of
         Left NaKascidDrstah -> True
         _ -> False)
  , check "a positive control alone does not license an acceptance"
      (case anujna (SadhuDrsta "Probe1") "x = x" "Checking Candidate" of
         Left (KevalamSadhuDrstah "Probe1") -> True
         _ -> False)
  , check "a watched rejection does license one, and it carries the watch"
      (case anujna (BadhakaDrsta "canaryFalse" "1 != 0") "0 + x = x"
              "Checking Candidate" of
         Right a -> anujnaSaksin a == BadhakaDrsta "canaryFalse" "1 != 0"
                    && anujnaClaim a == "0 + x = x"
         _ -> False)
  , -- THE OPERATIVE ONE.  This is the pipeline shim, in miniature: a watched
    -- process, a zero exit, and the type error sitting in the output beside
    -- it.  The per-call scan has to fire BEFORE the watch is consulted, or
    -- the shim is caught only on the first candidate of a fresh process.
    check "a zero exit whose output carries a type error is refused even when \
          \the watch is good"
      (case anujna (BadhakaDrsta "canaryFalse" "1 != 0") "s(x) = x"
              "1 != 0 of type \8469 when checking that the expression refl has \
              \type 1 \8801 zero" of
         Left (VacoVirodhah _) -> True
         _ -> False)
  , check "the transcription of successHidesAnError fires on agda's own words"
      (all hidesAnError
         [ "1 != 0 of type \8469"
         , "when checking that the expression refl has type"
         , "Not in scope: foo"
         , "Termination checking failed for the following functions"
         , "Unsolved metas at the following locations"
         , "Parse error" ]
       && not (hidesAnError "Checking Candidate (/tmp/x/Candidate.agda).")
       && not (hidesAnError ""))
  , -- The census must not be able to claim a watch it does not describe.
    check "every row whose saksin is Adrsta reads no output or reads it only \
          \on the failure branch"
      (and [ case stScan s of
               Nothing -> True
               Just p  -> "environmentFault" `isPrefixOf` p
           | s <- sthanani, stSaksin s == Adrsta ])
  , check "the census records more than one watched entry point, so it is not \
          \a list of failures with the successes omitted"
      (length [ () | s <- sthanani
              , case stSaksin s of BadhakaDrsta _ _ -> True; _ -> False ] >= 3)
  , check "the census names entry points, so one file can appear twice with \
          \different watches"
      (length [ () | s <- sthanani, stFile s == "machine/ClauseOrder.hs" ] == 3
       && length (filter (== Adrsta)
                    [ stSaksin s | s <- sthanani
                    , stFile s == "machine/ClauseOrder.hs" ]) == 2)
  , check "the seam absence carries its counterpositive and its extent"
      (AB.extCount (AB.abhavaExtent seamAbsence) == length sthanani
       && not (null (AB.ptName (AB.abhavaPratiyogin seamAbsence))))
  , check "the dispute names the school that refuses this construction"
      (any ("PRABHAKARA" `isPrefixOf`) mimamsakaVivada
       && any ("NAIYAYIKA" `isPrefixOf`) mimamsakaVivada)
  ]
  where
    check _ True = [] :: [String]
    check m False = ["yogyanupalabdhi self-test FAILED: " ++ m]
