-- PramanyaCorpus.hs -- grade THIS repository, file by file, by its own rule.
--
-- machine/PramanyaRun.hs grades eleven hand-written claims.  That is a
-- demonstration, not an instrument.  This reads the corpus.
--
-- WHAT IT EXTRACTS, and all of it is textual and exact:
--
--   CHECKED line       a checker ran on this file      -> Siddha
--   names an author    the header invokes a source
--   names a work       the header names the TEXT, not just the person
--   has a date         a year, BCE/CE, or (c. NNNN)
--   "search"           the source was located rather than recalled
--
-- THE DISCRIMINATION THAT MAKES IT FAIR.  A module doing pure mathematics
-- with no historical claim must not be penalised for citing no text.  So
-- the gate fires only on files that INVOKE a source:
--
--   * names an author and no work  -> UNFIT.  This is the exact asymmetry
--     .claude/hooks/source-coverage.sh checks: an author's name
--     propagates by citation and costs nothing; a work's name appears
--     only where somebody opened the book.
--   * names an author and a work but no date -> UNFIT.  A provenance
--     without a date is a provenance nobody checked.
--   * names nothing -> makes no historical claim; graded on its own
--     checking alone, and that is not a demerit.
--
-- SOURCE: Gautama, Nyayasutra 1.1.3 for the route typing; Kumarila,
-- Slokavarttika, Abhavapariccheda (c. 7th c.) for the fitness condition.
-- GRADE of those: author, work, doctrine; reached by recall and by
-- search, not by consulting an edition -- Drsta is unreachable on this
-- container (see Pramanya.hs's ceiling note).

module PramanyaCorpus where

import Pramanya
import Data.List (isInfixOf, isPrefixOf, sort, sortOn, nub)
import Data.Char (isDigit, toLower)
import qualified Data.Map.Strict as M

authors :: [String]
authors =
  [ "Āryabhaṭ", "Aryabhat", "Brahmagupta", "Bhāskara", "Bhaskara"
  , "Piṅgala", "Pingala", "Pāṇini", "Panini", "Mādhava", "Madhava"
  , "Nīlakaṇṭha", "Nilakantha", "Jyeṣṭhadeva", "Jyesthadeva"
  , "Halāyudha", "Halayudha", "Virahāṅka", "Virahanka"
  , "Baudhāyana", "Baudhayana", "Umāsvāti", "Umasvati", "Siddhasena"
  , "Akalaṅka", "Akalanka", "Samantabhadra", "Mahāvīra", "Mahavira"
  , "Śrīdhara", "Sridhara", "Nārāyaṇa", "Narayana", "Vātsyāyana"
  , "Kumārila", "Kumarila", "Gaṅgeśa", "Gangesa", "Nāgārjuna", "Nagarjuna"
  , "Jayadeva", "Kauṭilya", "Kautilya", "Caraka", "Suśruta", "Susruta"
  , "Vīrasena", "Virasena", "Patañjali", "Patanjali", "Praśastapāda"
  , "Dignāga", "Dignaga", "Dharmakīrti", "Dharmakirti", "Śāntarakṣita"
  , "Santaraksita", "Bharata", "Gautama", "Vidyānanda", "Prabhācandra"
  , "Govindasvāmi", "Mallisena", "Mallisena" ]

works :: [String]
works =
  [ "Āryabhaṭīya", "Aryabhatiya", "Brāhmasphuṭa", "Brahmasphuta"
  , "Bījagaṇita", "Bijaganita", "Līlāvatī", "Lilavati", "Siddhānta"
  , "Chandaḥśāstra", "Chandahsastra", "Mṛtasañjīvanī", "Mrtasanjivani"
  , "Vṛttajātisamuccaya", "Vrttajatisamuccaya", "Yuktibhāṣā", "Yuktibhasa"
  , "Tantrasaṅgraha", "Tantrasangraha", "Aṣṭādhyāyī", "Astadhyayi"
  , "Mahābhāṣya", "Mahabhasya", "Tattvārthasūtra", "Tattvarthasutra"
  , "Sanmatitarka", "Āptamīmāṃsā", "Aptamimamsa", "Laghīyastraya"
  , "Laghiyastraya", "Aṣṭaśatī", "Astasati", "Aṣṭasahasrī", "Astasahasri"
  , "Tattvacintāmaṇi", "Tattvacintamani", "Śulbasūtra", "Sulbasutra"
  , "Ślokavārttika", "Slokavarttika", "Nyāyasūtra", "Nyayasutra"
  , "Nyāyabhāṣya", "Nyayabhasya", "Gaṇitasārasaṅgraha", "Ganitasarasangraha"
  , "Gaṇitakaumudī", "Ganitakaumudi", "Arthaśāstra", "Arthasastra"
  , "Nāṭyaśāstra", "Natyasastra", "Pramāṇasamuccaya", "Pramanasamuccaya"
  , "Pramāṇavārttika", "Pramanavarttika", "Tattvasaṅgraha", "Tattvasangraha"
  , "Prameyakamalamārtaṇḍa", "Dhavalā", "Dhavala", "Khaṇḍakhādyaka"
  , "Bhagavatī", "Bhagavati", "Anuyogadvāra", "Sthānāṅga"
  , "Syādvādamañjarī", "Syadvadamanjari", "Padārthadharma" ]

hasAny :: [String] -> String -> Bool
hasAny ps s = any (`isInfixOf` s) ps

-- a year, a BCE/CE marker, or a (c. NNNN) form
hasDate :: String -> Bool
hasDate s = go s
  where
    go [] = False
    go xs@(c:cs)
      | isDigit c =
          let (d, r) = span isDigit xs
          in (length d >= 3 && length d <= 4) || go r
      | otherwise = go cs

-- | One file, as a claim about its own grounding.
fileClaim :: FilePath -> String -> Claim
fileClaim fp hdr
  | not namesA =
      -- no historical claim made; graded on its own checking
      Claim fp "makes no historical claim" Pratyaksa
            (if checked then Siddha else Anumita) Nothing [] Nothing
  | not namesW =
      Claim fp "invokes an author and names no work" Sabda Sruta
            (Just (Source "(author named)" via "" "")) [] Nothing
  | not dated =
      Claim fp "names a work and gives no date" Sabda Sruta
            (Just (Source "(author named)" via "(work named)" "")) [] Nothing
  | otherwise =
      Claim fp "names author, work and date" Sabda
            (if searched then Anvista else Sruta)
            (Just (Source "(author named)" via "(work named)" "(dated)")) [] Nothing
  where
    namesA   = hasAny authors hdr
    namesW   = hasAny works hdr
    dated    = hasDate hdr
    checked  = "CHECKED" `isInfixOf` hdr
    searched = "search" `isInfixOf` map toLower hdr
    via      = if searched then "search" else "recall"

data CorpusReport = CorpusReport
  { crTotal    :: Int
  , crByGrade  :: [(Status, Int)]
  , crUnfit    :: [Claim]
  , crNoSource :: Int
  }

report :: [Claim] -> CorpusReport
report cs =
  let e = env cs
      gs = [ (c, grade e (cId c)) | c <- cs ]
      byG = [ (s, length [ () | (_, g) <- gs, g == s ]) | s <- [minBound .. maxBound] ]
  in CorpusReport (length cs) byG
       [ c | c <- cs, unfit c /= Nothing ]
       (length [ () | c <- cs, cSource c == Nothing ])

renderCorpus :: String -> CorpusReport -> [String]
renderCorpus what r =
  [ "=== PRAMANYA over " ++ what ++ " ==="
  , ""
  , "  files graded                     : " ++ show (crTotal r)
  , "  making no historical claim       : " ++ show (crNoSource r)
  , "  INVOKING a source but UNFIT      : " ++ show (length (crUnfit r))
  , ""
  ] ++ [ "  " ++ show s ++ "\t" ++ show n | (s, n) <- crByGrade r, n > 0 ]
