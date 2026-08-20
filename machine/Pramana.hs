-- Pramāṇa — the means of knowing, carried as a type instead of assumed.
--
-- WHAT THIS IS FOR, AND WHY IT IS A TYPE AND NOT A COMMENT.
--
-- The engine had two organs for coming to know something and no name for
-- either.  `fingerprint` evaluates a candidate on instances and kills it if
-- two sides disagree; `kernelAcceptWith` asks Agda.  Everything downstream —
-- `mKnown`, `mRules`, `machine/library.terms` — records only THAT a claim was
-- established, never BY WHAT MEANS, and never UNDER WHAT DELIMITATION.  Two
-- consequences were measured on the committed log before this file existed:
--
--   1. machine.log:146 REJECTS `x = (xmaxx)` and machine.log:174 ACCEPTS it.
--      Same process, same round=0, twenty-eight lines apart.  Line 146 is
--      re-admission submitting under `refl`; line 174 is the round's prover
--      submitting under `induction on x, step = cong suc`.  Nothing in any
--      type distinguishes the two, so "the kernel rejected it" is a sentence
--      the codebase cannot form correctly: the kernel is at least two nayas
--      and the log is the only place either of them is named.
--
--   2. Consequently re-admission from `machine/library.terms` re-derives the
--      proof note blind.  Measured 2026-08-18 on the committed 92-line memory
--      (37 distinct) with no `machine/thoughts.math` present, so the startup
--      vocabulary is the default `max 3 …` rather than the 8 that prose file
--      happens to demand:  re-admitted=6 dropped=31.  The six survivors are
--      the refl-closable ones.  The other thirty-one were each proved, by
--      this same engine, under induction — and the file did not carry that
--      one field, so the gate was asked the wrong question and said no.
--
-- THE SIX PRAMĀṆAS, and why this is the right frame rather than a decoration.
--
-- Nyāya (Gautama, *Nyāyasūtra* 1.1.3, c. 2nd c. BCE) fixes four: pratyakṣa,
-- anumāna, upamāna, śabda.  Mīmāṃsā (Kumārila Bhaṭṭa, *Ślokavārttika*, c. 7th
-- c.; Prabhākara) adds arthāpatti and — Bhāṭṭa only — anupalabdhi, making six.
-- The dispute between the schools is exactly the dispute this engine is in:
-- whether a means of knowing REDUCES to another (Prabhākara folds
-- anupalabdhi into pratyakṣa) or is IRREDUCIBLE.  That is the design
-- question, stated as a design question, fifteen centuries early.
--
-- The engine's own answer, read off its log rather than asserted:
--
--   pratyakṣa      fingerprint evaluation on instances            HAVE
--   anumāna        kernel proof                                   HAVE, plural
--   śabda          testimony: its own kernel-checked certificates  THIS FILE
--   arthāpatti     postulate what would explain the residual      Obstruction
--   anupalabdhi    yogya-anupalabdhi: warranted non-apprehension  Certify
--   upamāna        knowledge by likeness across vocabularies      Upamana
--
-- CORRECTED 2026-08-19.  That last line read ABSENT until today, and it was
-- wrong: `machine/Upamana.hs` had implemented it — 896 lines, with
-- Nyāyasūtra 1.1.6 and Vātsyāyana's gavaya in its header, transport across
-- stated similarities, an audit, and a §9 posing Dignāga's reduction
-- question to the engine.  What was true, and worse than absence, is that
-- NOTHING IMPORTED IT.  It had never been run.  The first run
-- (`machine/UpamanaRun.hs`, today) found two defects that had been sitting
-- in it since it was written: `adjudicate` crashed on a symbol its own audit
-- had already flagged, and `spaceSize` memoised into a strict map that
-- forced itself, so it could not terminate.  Both are fixed at their sites.
--
-- The lesson is not about that file.  A shelf reports the same as an
-- absence, and this header could not tell the difference for as long as
-- nobody turned the key.
--
-- WHAT ŚABDA IS AND IS NOT HERE — the line this file will not cross.
--
-- Nyāya's condition on valid śabda is āptatva: the reliability of the
-- speaker (*Nyāyasūtra* 1.1.7, āptopadeśaḥ śabdaḥ — "śabda is the
-- instruction of a reliable speaker").  It is tempting to read that as
-- licence to install a remembered theorem on the strength of the memory.
-- THAT IS NOT DONE AND MUST NOT BE.  A memory file is editable text; if it
-- could install rules it would be an axiom store with an Indian name on it.
--
-- What the recorded certificate is testimony ABOUT is not the theorem's
-- truth but the NAYA under which anumāna succeeds — which module Agda should
-- be asked to check.  The kernel is still asked, in this process, and a
-- remembered theorem that no longer certifies is still dropped.  So the
-- invariant is untouched, and the classical structure is respected rather
-- than borrowed: śabda conveys the artha via a means, and here the means is
-- what it conveys.  A false note cannot promote a false claim; it can only
-- waste an Agda call.
--
-- NOT `module Main`.  Four files in this directory were written that way and
-- could therefore never be consumed by the seams built for them.  This one is
-- importable from the day it lands, depends on `base` alone, and carries its
-- own `selfTest`, which `MathMachine --pramana-self-test` runs in-process.
--
-- ON `Term`.  The instruction that produced this file asked for `Term` to
-- live here, because it is currently redefined in eight modules.  IT DOES NOT
-- LIVE HERE, and the reason is measured, not aesthetic: the definitions are
-- structurally identical but their `Show` instances are NOT interchangeable.
-- `MathMachine`'s renders infix over ["+","*","^","gcd","max"] with `,`
-- between non-infix arguments; `Obstruction`'s renders infix over
-- ["+","*","max","-","gcd","le"] with NO separator.  They disagree on `-` and
-- `le` (`-(x,x)` versus `(x-x)`), and `Obstruction.showClaim` compares its
-- rendering against strings MathMachine printed to the log — so a shared
-- `Term` would have to pick one rendering and would silently move either the
-- log format or the saptabhaṅgī census.  Both are load-bearing measurements.
-- Unifying them is a real and separate change with a real regression surface;
-- collapsing it into this one would be exactly the kind of unmeasured edit
-- this repository's protocol exists to stop.
--
-- What is done instead is stronger than a ninth `Term`: every type below is
-- either term-free or PARAMETRIC in the term type, so `MemoryRecord` composes
-- with all eight without adding one.
module Pramana
  ( -- the six means
    Pramana(..)
  , pramanaName
    -- the likeness an upamana moved along, and its wire round-trip
  , Sadrsya(..)
  , sadrsyaNote
  , sadrsyaOfNote
  , Source(..)
  , aptatva
    -- the standpoint, finer than Obstruction's three-way Naya
  , Naya(..)
  , nayaNote
  , nayaOfNote
  , nayaCoarse
  , nayaVariable
    -- the delimitor: under WHAT was this established
  , Avacchedaka(..)
  , noAvacchedaka
    -- the whole justification, and its wire format
  , Provenance(..)
  , noProvenance
  , Justification(..)
  , testimony
  , renderJustification
  , parseJustification
    -- the memory record: parametric in the term type, so it adds no ninth Term
  , MemoryRecord(..)
  , renderRecord
  , parseRecord
    -- checked in-process
  , selfTest
  ) where

import Data.Char (isDigit, isSpace)
import Data.List (intercalate, isPrefixOf)

-- ===================================================================
-- THE STANDPOINT.
--
-- `Obstruction.Naya` has three constructors — Rewriter, KernelRefl,
-- KernelInd — and that is the right coarseness for a saptabhaṅgī census,
-- which asks only whether SOME naya affirmed and SOME denied.  It is too
-- coarse to be a justification: `KernelInd` does not say which variable, and
-- `Certificate.inductionVariable` reads exactly that variable out of the
-- proof note in order to decide which module to emit.  A standpoint that
-- cannot reproduce the module is not a record of how the thing was known.
--
-- So this is finer, and `nayaCoarse` is the forgetful map back to
-- Obstruction's three.  The census keeps working on the coarse image; the
-- gate gets the fine one.
--
-- The distribution over the committed machine/machine.log, 1886 acceptances:
--
--     678  trace replay                      44  refl
--     490  induction on x, step = refl        6  induction on y, step = refl
--     429  induction on x, step = ih          3  induction on y, step = ih
--     262  induction on x, step = cong suc
--
-- Every one of those lines is a standpoint that no type recorded.
data Naya
  = NRefl
    -- ^ Agda's definitional equality, `refl` the whole tactic.
  | NInduction Char (Maybe String)
    -- ^ induction on the named variable; the step shape when it is known
    --   (@"ih"@, @"cong suc"@, @"refl"@, …), 'Nothing' when only the
    --   variable was recorded.
  | NTraceReplay
    -- ^ the path compiled from the engine's own rewrite trace
    --   ('TraceReplay'), which is a rewrite-by-rewrite reconstruction and not
    --   a search.  It still ends at the same Agda invocation.
  | NRewriter
    -- ^ the machine's own evaluation over 'Integer' — pratyakṣa's organ, kept
    --   here so a justification can name it without a second type.
  | NOther String
    -- ^ a note this module declines to classify.  Kept VERBATIM rather than
    --   normalised away, because the note is what the gate consumes: an
    --   unrecognised note must still round-trip to the string that produced
    --   it, or recording it would lose the only field this file exists for.
  deriving (Eq, Ord, Show)

-- The proof note this naya presents to `kernelAcceptWith`.  This is the
-- operative direction: `Certificate.certifyWith` reads the induction variable
-- out of this string, so `nayaNote` must produce something
-- `Certificate.inductionVariable` can read.  Checked in 'selfTest' against a
-- transcription of that function.
nayaNote :: Naya -> String
nayaNote NRefl                    = "refl"
nayaNote (NInduction v Nothing)   = "induction on " ++ [v]
nayaNote (NInduction v (Just st)) = "induction on " ++ [v] ++ ", step = " ++ st
nayaNote NTraceReplay             = "trace replay"
nayaNote NRewriter                = "rewriter"
nayaNote (NOther s)               = s

-- The inverse, on the strings the engine actually writes.  Anything else
-- becomes 'NOther' with the text kept, so `nayaNote . nayaOfNote == id` on
-- every string — which is the property that makes it safe to put an
-- unrecognised note into the memory file and read it back.
nayaOfNote :: String -> Naya
nayaOfNote s
  | t == "refl"                      = NRefl
  | t == "trace replay"              = NTraceReplay
  | t == "rewriter"                  = NRewriter
  | Just rest <- afterMarker t
  , (c:more) <- rest
  , c `elem` "xyzuvw" =
      case dropWhile isSpace (dropWhile (== ',') (dropWhile isSpace more)) of
        step | Just sh <- afterStep step, not (null sh) -> NInduction c (Just sh)
        _                                               -> NInduction c Nothing
  | otherwise = NOther s
  where
    t = trim s
    marker = "induction on "
    afterMarker u
      | marker `isPrefixOf` u = Just (dropWhile isSpace (drop (length marker) u))
      | otherwise             = Nothing
    afterStep u
      | "step = " `isPrefixOf` u = Just (trim (drop 7 u))
      | otherwise                = Nothing

-- The forgetful map onto `Obstruction.Naya`'s three, by name rather than by
-- import: `Obstruction` is deliberately dependency-free and this module is
-- too, so neither imports the other and the correspondence is a string.
-- (That is a weaker join than a shared type and it is written down here so
-- nobody reads it as one.)
nayaCoarse :: Naya -> String
nayaCoarse NRefl           = "KernelRefl"
nayaCoarse (NInduction _ _) = "KernelInd"
nayaCoarse NTraceReplay    = "KernelInd"
nayaCoarse NRewriter       = "Rewriter"
nayaCoarse (NOther _)      = "KernelRefl"

-- The variable this naya inducts on, if any.  Transcribed from
-- `Certificate.inductionVariable` on the note, so that a caller can check the
-- two agree without importing Certificate.
nayaVariable :: Naya -> Maybe Int
nayaVariable n = go (nayaNote n)
  where
    marker = "induction on "
    go [] = Nothing
    go u@(_:rest)
      | marker `isPrefixOf` u = nameToIndex (drop (length marker) u)
      | otherwise             = go rest
    nameToIndex u = case dropWhile isSpace u of
      (c:_) | Just i <- lookup c (zip "xyzuvw" [0 :: Int ..]) -> Just i
      ('n':ds) | (d@(_:_), _) <- span isDigit ds -> Just (read d)
      _ -> Nothing

-- ===================================================================
-- THE DELIMITOR.
--
-- Avacchedaka (अवच्छेदक) is Navya-Nyāya's answer to the question this engine
-- gets wrong every time it restarts: a cognition is never of a property
-- simpliciter, it is of a property AS DELIMITED — by a locus, by a time, by a
-- mode.  Gaṅgeśa's *Tattvacintāmaṇi* (c. 1325) is built on the machinery;
-- the terminology is refined by Raghunātha Śiromaṇi (c. 1510).
--
-- The engine's concrete instance of the point: `x = (xmaxx)` is established
-- AS DELIMITED BY a vocabulary in which `max` has defining equations.  Start
-- the machine with `startVocab = 3` and `max` is not visible, so
-- `proveByInduction` cannot reduce either side, so it reports no induction
-- variable, so the note is empty and the gate is handed `refl`.  The theorem
-- did not become false; its delimitor went away and nothing had recorded what
-- the delimitor was.  That is the whole of measurement (2) in the header.
data Avacchedaka = Avacchedaka
  { avEquality   :: String
    -- ^ which equality — @"_≡_ on ℕ"@ for everything this engine has proved.
    --   Recorded because it is the field that will be wrong first: the
    --   cubical substrate has more than one.
  , avVocabulary :: [String]
    -- ^ which symbols were visible, in precedence order.  ORDER IS THE
    --   PRECEDENCE (`MathMachine.precedence` indexes into it), so this is not
    --   a set.
  , avVars       :: Int
    -- ^ the variable horizon in force (`Knobs.kVars`, ceiling 6).
  , avSizeBound  :: Int
    -- ^ the size horizon in force (`Knobs.kSizeCap`).
  } deriving (Eq, Show)

noAvacchedaka :: Avacchedaka
noAvacchedaka = Avacchedaka "" [] 0 0

-- ===================================================================
-- THE SPEAKER.
--
-- Āptatva is a condition ON THE SPEAKER, not on the sentence, and that is
-- what makes it usable here: the machine's past self is an āpta exactly to
-- the extent that what it wrote down was kernel-checked when it wrote it.
-- A hand-edited line in `machine/library.terms` and a line the round appended
-- after `KERNEL-ACCEPT` are the same bytes; `SelfPast` is the claim that the
-- second kind is what is being read, and it is a claim the file cannot
-- verify.  Hence `aptatva`, and hence the fact that being an āpta buys the
-- speaker exactly one thing — the naya — and never installation.
data Source
  = SelfPast
      { srcRound :: Int          -- ^ the round that wrote it, -1 when unknown
      , srcNaya  :: Naya         -- ^ the naya it says established the claim
      }
  | Human String                 -- ^ a thought file, a note, a person
  | Unattributed                 -- ^ a memory line with no justification field
  deriving (Eq, Show)

-- Is this speaker an āpta?  `Unattributed` is not: a two-field legacy line
-- says nothing about how it was established, so its testimony conveys no
-- naya and the caller must fall back to re-deriving one.  `Human` is not
-- either, and deliberately: a researcher's thought file is a source of
-- QUESTIONS in this engine, never of proof notes.
--
-- Note what this predicate does NOT decide: whether to install.  Nothing in
-- this module decides that.  It decides whether there is a naya worth
-- submitting, which is a question about which Agda module to write.
aptatva :: Source -> Bool
aptatva (SelfPast _ _) = True
aptatva (Human _)      = False
aptatva Unattributed   = False

-- ===================================================================
-- SĀDṚŚYA — the likeness an upamāna moved along.
--
-- ADDED 2026-08-20 by the transport lane.  Until this commit the sixth
-- pramāṇa read
--
--     | Upamana              -- ^ knowledge by likeness across vocabularies
--
-- — a NULLARY constructor.  Every other means of knowledge in this type
-- carries what it is made of: `Anumana` carries its naya, `Sabda` carries
-- its speaker.  The one whose entire subject matter is IDENTIFICATION
-- carried nothing at all, which makes it boolean-grade: "these were
-- identified by likeness" and not one word about which likeness, stated
-- by whom, or what refused to travel.
--
-- That is the defect `notes/AHIMSA_SUTRA_VISTARA.md` §६ names.  There are
-- two roads, transport along an EXHIBITED identification and the written
-- defect; a bare `Upamana` is neither, because the identification is
-- asserted and not held.  §५ says why it cannot be repaired afterwards:
-- ∥ A ∥₁ admits no retraction, so the `which` a tag drops is destroyed
-- rather than merely unreported (checked in
-- `formal/cubical/Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis.agda`
-- and, in the transport form, in `formal/cubical/Samkramana_Transport…`).
--
-- AND THE ENGINE ALREADY HAD THE EVIDENCE.  `machine/Upamana.hs` computes
-- it in full — `Similarity` (`:277`) is a STATED morphism with a citation,
-- audited by `simFaults` before use, and `Transported` (`:396`) records
-- `trSource`, `trSim` and `trRefusals`.  All of it dies at the file
-- boundary: `renderCandidate` (`:758`) emits `"candidate\t" ++ l ++ "\t" ++ r`
-- and nothing else.  So the loss is not an absence of evidence, it is
-- evidence discarded — which is the harder case and the one worth naming.
--
-- WHAT THIS TYPE CHANGES, and it is a mechanism rather than a paragraph:
-- `Upamana` can no longer be written down without producing the likeness.
-- The compiler refuses at the moment of the act, which is the repair
-- CLAUDE.md prescribes for a rule that prose has failed to enforce.
--
-- `sadTyakta` is a LIST, never a count.  A count is the collapse again:
-- "3 slots dropped" is ∥·∥₁ of the drops.
--
-- ───────────────────────────────────────────────────────────────────
-- दोषलेखः — WHAT IS *NOT* DONE HERE, AND EXACTLY WHY.  Written down
-- because §६'s second road is to write the defect, and an unwritten one
-- is the thing it forbids.  This is a defect, not a plan.
--
-- The likeness now cannot be omitted from a `Pramana` value, and it
-- round-trips through 'sadrsyaNote' / 'sadrsyaOfNote' (checked in
-- 'selfTest').  IT STILL DOES NOT REACH THE WIRE.  The path from
-- `Upamana.hs` to the engine is `machine/thoughts.upamana.*.math`, and
-- `MathMachine.parseThoughts` reads it with
--
--     ["candidate", l, r] | Just lt <- parseTerm l, … -> …candidate…
--     _                                               -> …residual…
--
-- (MathMachine.hs:611).  The pattern is a THREE-field tab split with no
-- catch-all for a wider line, so appending a fourth field would not be
-- ignored — every upamāna candidate would fall through to
-- `thoughtResiduals` and be silently reclassified.  The trick that makes
-- `library.terms` extensible (a third field the old reader drops) does
-- NOT transfer, because that reader has the fallback and this one has an
-- exact match.  So the wire cannot be widened from this file; it takes
-- one edit to `parseThoughts` and one to `Upamana.renderCandidate`.
--
-- Why that edit is not in this commit: `machine/MathMachine.hs` and five
-- other files carried ANOTHER LANE'S UNCOMMITTED, UNSTAGED work at the
-- time of writing, and `git commit -o <path>` commits the working-tree
-- version of the path — so touching it would have swept that agent's
-- work into this commit under this commit's message.  That harm was
-- committed once already today and is recorded in
-- `collab/messages/0900-dosalekha-my-commit-swept-another-agents-staged-files.md`.
-- Refusing to repeat it is the whole reason the remainder is written here
-- instead of done.  शेषो गर्भः, न विफलता (§३): the remainder is handed
-- forward, not dropped — which is also the kuṭṭaka's rule.
-- ───────────────────────────────────────────────────────────────────
--
-- स्रोतांसि : उपमानम् as a distinct pramāṇa is Nyāya's — Gautama,
--   *Nyāyasūtra* 1.1.6 (प्रसिद्धसाधर्म्यात् साध्यसाधनम् उपमानम्, "upamāna is
--   the establishing of what is to be established from a well-known
--   likeness"), c. 2nd c. CE, with Vātsyāyana's *Nyāyabhāṣya*.  What is
--   taken from it is the insistence that the likeness be PRASIDDHA —
--   already established, and therefore nameable and citable — which is
--   exactly `sadName` and `sadCite`.  NOT CLAIMED: that Gautama wrote
--   this record, or that the Naiyāyika analysis is settled — the Jaina
--   and Bauddha schools both dispute whether upamāna is irreducible to
--   anumāna, and this type takes no side on that; it only refuses to let
--   the likeness go unstated whichever way the dispute goes.
data Sadrsya = Sadrsya
  { sadName   :: String
    -- ^ what the likeness is called, in its own tradition — `bhavana`,
    --   `pair-ring`.  The name the engine's `Similarity.simName` holds.
  , sadCite   :: String
    -- ^ who stated it, and where.  Not decoration: an upamāna whose
    --   likeness nobody stated is a resemblance the machine noticed, and
    --   Nyāya's प्रसिद्ध- is precisely the requirement that it not be.
  , sadMula   :: String
    -- ^ the source claim, as it stood BEFORE transport.  Without it the
    --   carried claim cannot be replayed, only re-asserted.
  , sadTyakta :: [String]
    -- ^ what did NOT carry, named one by one.  Empty means nothing was
    --   dropped and is a claim, not a default.
  } deriving (Eq, Ord, Show)

-- The likeness as one wire-safe string, and back.  Same discipline as
-- 'nayaNote' / 'nayaOfNote': total in both directions, round-tripping on
-- everything it produces, and 'Nothing' rather than a guess on anything
-- it does not recognise.  `|`, tab and newline are stripped because the
-- justification field is `|`-separated; `~` and `;` are the internal
-- separators and are stripped from the parts for the same reason.
sadrsyaNote :: Sadrsya -> String
sadrsyaNote s = intercalate "~"
  [ "upamana along " ++ w (sadName s)
  , "cite "  ++ w (sadCite s)
  , "mula "  ++ w (sadMula s)
  , "tyakta " ++ intercalate ";" (map w (sadTyakta s))
  ]
  where
    w = filter (\c -> c `notElem` "|~;\t\n\r")

sadrsyaOfNote :: String -> Maybe Sadrsya
sadrsyaOfNote str = case splitOn '~' str of
  [a, b, c, d]
    | Just n <- after "upamana along " a
    , Just ct <- after "cite " b
    , Just ml <- after "mula " c
    , Just tk <- after "tyakta " d
    -> Just (Sadrsya n ct ml (if null tk then [] else splitOn ';' tk))
  _ -> Nothing
  where
    after pre s | pre `isPrefixOf` s = Just (drop (length pre) s)
                | otherwise          = Nothing

-- ===================================================================
-- THE SIX.
data Pramana
  = Pratyaksa            -- ^ fingerprint evaluation on instances
  | Anumana Naya         -- ^ kernel proof, INDEXED — this is the whole point
  | Sabda Source         -- ^ testimony from an āpta
  | Arthapatti           -- ^ postulation of what would explain a residual
  | Anupalabdhi          -- ^ warranted non-apprehension (yogya-anupalabdhi)
  | Upamana Sadrsya      -- ^ knowledge by likeness across vocabularies,
                         --   CARRYING the likeness it moved along.  See
                         --   'Sadrsya' for why this is not nullary.
  deriving (Eq, Show)

pramanaName :: Pramana -> String
pramanaName Pratyaksa    = "pratyaksa"
pramanaName (Anumana _)  = "anumana"
pramanaName (Sabda _)    = "sabda"
pramanaName Arthapatti   = "arthapatti"
pramanaName Anupalabdhi  = "anupalabdhi"
pramanaName (Upamana _)  = "upamana"

data Provenance = Provenance
  { provRound     :: Int   -- ^ the round that established it; -1 unknown
  , provAgdaCalls :: Int   -- ^ processes actually launched; 0 = served cached
  } deriving (Eq, Show)

noProvenance :: Provenance
noProvenance = Provenance (-1) 0

-- Everything a later process needs in order to ask the SAME question the
-- earlier process asked, and nothing that would let it skip asking.
data Justification = Justification
  { jPramana     :: Pramana
  , jNaya        :: Naya
  , jAvacchedaka :: Avacchedaka
  , jProvenance  :: Provenance
  } deriving (Eq, Show)

-- Turn a justification recorded by a past round into the testimony a present
-- round receives.  The pramāṇa CHANGES — what was anumāna for the speaker is
-- śabda for the hearer — while the naya is carried across unchanged.  That
-- asymmetry is the classical position (a hearer who repeats an inference has
-- not performed it) and it is also the honest engineering: the present
-- process has not run that Agda call and must not claim it did.
testimony :: Justification -> Justification
testimony j = j { jPramana = Sabda (SelfPast (provRound (jProvenance j)) (jNaya j)) }

-- ===================================================================
-- THE WIRE FORMAT.
--
-- `machine/library.terms` is `lhs \t rhs \n` and ninety-two committed lines
-- are in that shape.  The justification is a THIRD TAB FIELD, so every
-- existing line still parses — to `Unattributed`, which is exactly true of
-- it — and the reader falls back to what it does today.  A format that
-- orphaned the existing memory would be a strange way to fix a memory bug.
--
-- Within the field: `key=value` pairs separated by `|`.  Values may contain
-- `=` and `,` (the note "induction on x, step = cong suc" contains both), so
-- the split is on the FIRST `=` only.  `|` and tab and newline are stripped
-- on render, since no symbol name or step label contains them.
renderJustification :: Justification -> String
renderJustification j = intercalate "|"
  [ "pramana=" ++ clean (pramanaName (jPramana j))
  , "naya="    ++ clean (nayaNote (jNaya j))
  , "eq="      ++ clean (avEquality av)
  , "vocab="   ++ clean (intercalate "." (avVocabulary av))
  , "vars="    ++ show (avVars av)
  , "size="    ++ show (avSizeBound av)
  , "round="   ++ show (provRound (jProvenance j))
  , "calls="   ++ show (provAgdaCalls j')
  ]
  where
    av = jAvacchedaka j
    j' = jProvenance j
    clean = filter (\c -> c /= '|' && c /= '\t' && c /= '\n' && c /= '\r')

-- The reader.  Every field is optional and a missing one takes its neutral
-- value: a justification is a record of what a past process happened to
-- know about itself, and a format that could fail to parse would put the
-- memory back where it started.
--
-- The pramāṇa read back is ALWAYS śabda, whatever the file says, because the
-- file is being heard and not inferred.  The recorded name is kept inside
-- `SelfPast` via the naya.  This is `testimony` enforced at the boundary
-- rather than trusted to callers.
parseJustification :: String -> Justification
parseJustification s = Justification
  { jPramana     = Sabda (SelfPast rnd naya)
  , jNaya        = naya
  , jAvacchedaka = Avacchedaka
      { avEquality   = get "eq" ""
      , avVocabulary = case get "vocab" "" of
          "" -> []
          v  -> splitOn '.' v
      , avVars      = getInt "vars" 0
      , avSizeBound = getInt "size" 0
      }
  , jProvenance  = Provenance rnd (getInt "calls" 0)
  }
  where
    fields = [ (k, drop 1 rest)
             | f <- splitOn '|' s
             , let (k, rest) = break (== '=') f
             , not (null rest) ]
    get k d = maybe d id (lookup k fields)
    getInt k d = case reads (get k (show (d :: Int))) of
      [(n, "")] -> n
      _         -> d
    rnd  = getInt "round" (-1)
    naya = nayaOfNote (get "naya" "")

-- The memory record.  PARAMETRIC in the term type: this is what lets
-- `MathMachine`, `Obstruction`, `Certify`, `TraceReplay` and `Certificate`
-- all use it against their own `Term` without a ninth one being introduced.
data MemoryRecord t = MemoryRecord
  { mrLhs  :: t
  , mrRhs  :: t
  , mrJust :: Maybe Justification
    -- ^ 'Nothing' for a legacy two-field line: no testimony, no āpta, and the
    --   caller re-derives as it did before.
  } deriving (Eq, Show)

renderRecord :: (t -> String) -> MemoryRecord t -> String
renderRecord sh (MemoryRecord l r mj) =
  sh l ++ "\t" ++ sh r ++ maybe "" (\j -> "\t" ++ renderJustification j) mj

-- Returns 'Nothing' only when the TERMS do not parse — a malformed
-- justification degrades to `Unattributed`, it does not lose the theorem.
parseRecord :: (String -> Maybe t) -> String -> Maybe (MemoryRecord t)
parseRecord rd line = case splitOn '\t' line of
  (l:r:more) -> do
    lt <- rd l
    rt <- rd r
    let mj = case filter (not . all isSpace) more of
               (j:_) -> Just (parseJustification j)
               []    -> Nothing
    pure (MemoryRecord lt rt mj)
  _ -> Nothing

splitOn :: Char -> String -> [String]
splitOn c s = case break (== c) s of
  (a, [])     -> [a]
  (a, _:rest) -> a : splitOn c rest

trim :: String -> String
trim = dropWhile isSpace . reverse . dropWhile isSpace . reverse

-- ===================================================================
-- CHECKED IN-PROCESS.  Run by `MathMachine --pramana-self-test`; a test
-- nothing runs is the defect this directory already has four instances of.
--
-- Returns the failures, so a caller can print them.  Empty is pass.
selfTest :: [String]
selfTest = concat
  [ check "naya round-trips on every note the log contains"
      (all (\n -> nayaOfNote (nayaNote (nayaOfNote n)) == nayaOfNote n) loggedNotes
       && all (\n -> nayaNote (nayaOfNote n) == n) loggedNotes)
  , check "the four log tactics classify, and not as NOther"
      (map nayaOfNote loggedNotes ==
         [ NRefl
         , NInduction 'x' (Just "refl")
         , NInduction 'x' (Just "ih")
         , NInduction 'x' (Just "cong suc")
         , NInduction 'y' (Just "refl")
         , NInduction 'y' (Just "ih")
         , NTraceReplay ])
  , check "an unrecognised note survives verbatim"
      (nayaNote (nayaOfNote weird) == weird && nayaOfNote weird == NOther weird)
  , -- THE OPERATIVE PROPERTY.  `Certificate.certifyWith` refuses the instant
    -- `inductionVariable` finds nothing in the note, so a naya whose note
    -- does not name its variable is a naya the gate cannot act on.  This is
    -- the property the whole file exists to guarantee.
    check "every inductive naya's note names its variable to inductionVariable"
      (nayaVariable (NInduction 'x' (Just "cong suc")) == Just 0
       && nayaVariable (NInduction 'y' Nothing) == Just 1
       && nayaVariable (NInduction 'w' (Just "ih")) == Just 5
       && nayaVariable NRefl == Nothing
       && nayaVariable NTraceReplay == Nothing)
  , -- THE UPAMĀNA GATE.  The sixth pramāṇa was nullary until 2026-08-20;
    -- these three checks are what a payload buys, stated as properties
    -- rather than as a comment about the type.
    check "a likeness round-trips through its note"
      (sadrsyaOfNote (sadrsyaNote sampleSadrsya) == Just sampleSadrsya)
  , check "a dropped slot survives by name, not as a count"
      (case sadrsyaOfNote (sadrsyaNote sampleSadrsya) of
         Just s  -> sadTyakta s == ["norm slot 2", "unit"]
         Nothing -> False)
  , -- Wire safety: the justification field is `|`-separated and the naya
    -- note is split on the FIRST `=`, so a likeness carrying either must
    -- not be able to corrupt the line.  Checked, because "no name contains
    -- them" is an assumption about data this module does not own.
    check "a likeness carrying wire separators cannot corrupt the field"
      (let nasty = Sadrsya "a|b" "c\td~e" "f;g" ["h|i"]
           note  = sadrsyaNote nasty
       in all (`notElem` note) "|\t\n\r"
          && sadrsyaOfNote note == Just (Sadrsya "ab" "cde" "fg" ["hi"]))
  , check "an unrecognised likeness note is refused, not guessed at"
      (sadrsyaOfNote "induction on x" == Nothing
       && sadrsyaOfNote "" == Nothing)
  , check "coarse map lands in Obstruction's three names"
      (map nayaCoarse [NRefl, NInduction 'x' Nothing, NTraceReplay, NRewriter]
         == ["KernelRefl","KernelInd","KernelInd","Rewriter"])
  , check "justification round-trips through the wire format"
      (let back = parseJustification (renderJustification sample)
       in jNaya back == jNaya sample
          && jAvacchedaka back == jAvacchedaka sample
          && jProvenance back == jProvenance sample)
  , check "reading testimony always yields sabda from a self-past apta"
      (case jPramana (parseJustification (renderJustification sample)) of
         Sabda src -> aptatva src && srcNaya src == jNaya sample
         _         -> False)
  , check "hearing is not inferring: testimony changes the pramana"
      (pramanaName (jPramana (testimony sample)) == "sabda"
       && pramanaName (jPramana sample) == "anumana"
       && jNaya (testimony sample) == jNaya sample)
  , -- BACKWARD COMPATIBILITY, checked rather than hoped: the ninety-two
    -- committed lines are two-field and must still read.
    check "a legacy two-field line parses, with no testimony"
      (parseRecord idp "x\tmax(x,x)"
         == Just (MemoryRecord "x" "max(x,x)" Nothing))
  , check "a three-field line parses and carries the naya"
      (case parseRecord idp ("x\tmax(x,x)\t" ++ renderJustification sample) of
         Just (MemoryRecord "x" "max(x,x)" (Just j)) ->
           nayaNote (jNaya j) == "induction on x, step = cong suc"
             && not (aptatva Unattributed)
         _ -> False)
  , check "a corrupt justification degrades to Unattributed, keeping the terms"
      (case parseRecord idp "x\tmax(x,x)\tnot a justification at all" of
         Just (MemoryRecord "x" "max(x,x)" (Just j)) ->
           jNaya j == NOther "" && provRound (jProvenance j) == (-1)
         _ -> False)
  , check "a line whose terms do not parse is rejected outright"
      (parseRecord (\t -> if t == "bad" then Nothing else Just t) "bad\tx"
         == (Nothing :: Maybe (MemoryRecord String)))
  , check "render escapes the separators, so a record is always one line"
      (let nasty = sample { jNaya = NOther "a|b\tc\nd" }
           r = renderJustification nasty
       in notElem '|' (drop 1 (dropWhile (/= '=') (takeWhile (/= '|') (dropTo "naya=" r))))
          && notElem '\t' r && notElem '\n' r)
  , check "aptatva admits only the machine's own kernel-checked past"
      (aptatva (SelfPast 3 NRefl)
       && not (aptatva (Human "thoughts.math"))
       && not (aptatva Unattributed))
  ]
  where
    check _   True  = [] :: [String]
    check msg False = ["pramana self-test FAILED: " ++ msg]
    idp = Just :: String -> Maybe String
    weird = "critical pair from 0 = (0*x) and x = (0+x)"
    loggedNotes =
      [ "refl"
      , "induction on x, step = refl"
      , "induction on x, step = ih"
      , "induction on x, step = cong suc"
      , "induction on y, step = refl"
      , "induction on y, step = ih"
      , "trace replay"
      ]
    -- A real one: `bhavana` is the similarity `machine/Upamana.hs` actually
    -- carries, and the citation is Brahmagupta's composition law, so the
    -- fields are exercised on the shape they will hold rather than on
    -- placeholders.  Brahmagupta, Brāhmasphuṭasiddhānta 18, bhāvanā, 628 CE.
    sampleSadrsya = Sadrsya
      { sadName   = "bhavana"
      , sadCite   = "Brahmagupta, Brahmasphutasiddhanta 18 (628 CE)"
      , sadMula   = "x*(y+z) = x*y + x*z"
      , sadTyakta = ["norm slot 2", "unit"]
      }
    sample = Justification
      { jPramana     = Anumana (NInduction 'x' (Just "cong suc"))
      , jNaya        = NInduction 'x' (Just "cong suc")
      , jAvacchedaka = Avacchedaka "_≡_ on ℕ"
                         ["0","s","+","*","max","-","gcd","le"] 3 7
      , jProvenance  = Provenance 4 1
      }
    dropTo pre s
      | pre `isPrefixOf` s = s
      | null s             = s
      | otherwise          = dropTo pre (tail s)
