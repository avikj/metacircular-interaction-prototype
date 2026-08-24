-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- Anukramani.hs -- the index of the book, generated from the corpus.
--
-- SOURCE AND FORM.  The anukramaṇī is a Vedic genre: an index to a corpus
-- that gives, for every hymn, its ṛṣi (who saw it), its devatā (what it is
-- about) and its chandas (the metre it is in).  Śaunaka's anukramaṇīs and
-- Kātyāyana's Sarvānukramaṇī to the Ṛgveda are the surviving examples; the
-- dating is uncertain and commonly placed in the last centuries BCE.  What
-- matters here is the FORM, not a date I cannot establish: an index in this
-- tradition is not a list of titles.  It records, per entry, WHO IT CAME
-- FROM and WHAT IT IS ABOUT, and a corpus without one is a heap.
--
-- WHAT IS AND IS NOT CLAIMED.  Kātyāyana did not index Agda modules.  What
-- is taken is the three-field discipline -- ṛṣi, devatā, and (here) the
-- state of the entry -- and the principle that the index is part of the
-- work rather than apparatus bolted on after.
--
-- WHY IT IS A PROGRAM AND NOT A MARKDOWN FILE.  A hand-written table of
-- contents is true on the day it is written.  This one is computed from the
-- filesystem every time it is run, so a chapter cannot silently lose an
-- entry, and the primary/secondary ratio at the bottom cannot be rounded in
-- anybody's favour.

module Anukramani where

import Data.List (isInfixOf, isPrefixOf, isSuffixOf, sort, nub)
import Data.Char (toLower, isSpace)

-- | An adhyāya: one chapter of the book.
--   `rsi`     -- the source the chapter reads, with text and date
--   `devata`  -- what the chapter is about
--   `keys`    -- lowercase substrings of a filename that put it here
data Adhyaya = Adhyaya
  { number  :: Int
  , title   :: String
  , rsi     :: String
  , devata  :: String
  , keys    :: [String]
  }

-- The chapters, in the order the book reads.  Chronological by source,
-- because that is the order the ideas actually happened in, and the order a
-- later restatement can never be mistaken for the origin.
--
-- RULE ON KEYS, 2026-08-20.  Every WORK named in a chapter's rsi line is a
-- key, not only the authors.  Until today chapter 10 had exactly one key,
-- "madhava", while its rsi line named the Tantrasangraha and the Yuktibhasa --
-- so the index reproduced, mechanically, the failure CLAUDE.md names: an
-- author's name propagates through citation, a work's name appears only when
-- someone attended to the work, and the instrument was counting authors.
-- Chapters 2, 5, 6, 9, 11, 12 and 13 had the same hole.  When you add a
-- chapter, give it the works.
adhyayas :: [Adhyaya]
adhyayas =
  [ Adhyaya 1 "Śulba — the cord, the square, the diagonal"
      "Baudhāyana, Śulbasūtra (~800 BCE); Āpastamba; Kātyāyana"
      "altar geometry; the diagonal rule for the general rectangle; √2 to five places"
      ["sulba","sulbasutra","baudhayana","apastamba"]
  , Adhyaya 2 "Chandaḥśāstra — enumeration, before it was called that"
      "Piṅgala, Chandaḥśāstra (~300 BCE); Virahāṅka, Vṛttajātisamuccaya (~700); Halāyudha, Mṛtasañjīvanī (10th c.)"
      "prastāra, naṣṭa, uddiṣṭa, lagakriyā, saṅkhyā, adhvan -- the six pratyaya; meru; the mātrā recurrence"
      ["pingala","chandah","chandas","vrttajati","mrtasanjivani","matra","meru","prastara","samasa","virahanka","diagonalismatra"]
  , Adhyaya 3 "Aṣṭādhyāyī — a rewriting system with metarules"
      "Pāṇini, Aṣṭādhyāyī (~500 BCE); Patañjali, Mahābhāṣya (~150 BCE)"
      "pratyāhāra; 1.4.2 vipratiṣedhe paraṁ kāryam; utsarga/apavāda; 8.2.1 pūrvatrāsiddham against 6.4.22 asiddhavat"
      ["panini","astadhyayi","mahabhasya","patanjali","pratyahara","asiddha","anuvrtti","sivasutra","laghava","apavada","paribhasa"]
  , Adhyaya 4 "Nyāya and Mīmāṃsā — what counts as knowing"
      "Gautama, Nyāyasūtra; Vātsyāyana, Nyāyabhāṣya; Kumārila, Ślokavārttika, Abhāvapariccheda (c. 7th c.)"
      "pramāṇa; upamāna; abhāva and its pratiyogin; anupalabdhi under the fitness condition"
      ["abhava","upamana","yogyata","anyonya","nikshepa","pramana","upadhi","vyapti","nyaya","nyayasutra","nyayabhasya","slokavarttika","kumarila","vatsyayana"]
  , Adhyaya 5 "Jaina logic — the seven positions and the fourth"
      "Umāsvāti, Tattvārthasūtra; Siddhasena, Sanmatitarka 1.21; Samantabhadra, Āptamīmāṃsā; Akalaṅka, Laghīyastraya (c. 720-780)"
      "syādvāda and saptabhaṅgī; avaktavyam as SIMULTANEOUS assertion (sahārpaṇa), not as ignorance; nayavāda and durnaya"
      ["saptabhang","avaktavya","anukta","krama","naya","anekanta","jain","syad","durnaya","bhanga","tattvartha","sanmatitarka","aptamimamsa","laghiyastraya","umasvati","siddhasena","samantabhadra","akalanka"]
  , Adhyaya 6 "Āryabhaṭīya — the pulveriser"
      "Āryabhaṭa, Āryabhaṭīya, Gaṇitapāda 32-33 (499)"
      "kuṭṭaka and the vallī; the descent that terminates; simultaneous congruences"
      ["kuttaka","valli","aryabhatiya","aryabhat","ganitapada"]
  , Adhyaya 7 "Brāhmasphuṭasiddhānta — composition, and the arithmetic of nothing"
      "Brahmagupta, Brāhmasphuṭasiddhānta (628); Bhāskara II on khahāra (1150)"
      "bhāvanā as a composition law; vargaprakṛti; śūnya with its own rules; khahāra, the quantity with zero denominator"
      ["bhavana","brahmagupta","brahmasphuta","vargana","varga","shunya","khahara","ananta","purnata"]
  , Adhyaya 8 "Cakravāla — the cyclic method"
      "Jayadeva (~950), quoted by Udayadivākara; Bhāskara II, Bījagaṇita (1150)"
      "descent on quadratic forms; the bound; the witness; why it needs the kuṭṭaka"
      ["cakravala","bija","bijaganita","jayadeva","bhaskara"]
  , Adhyaya 9 "Saṅkalita — sums, heaps, and the solid"
      "Āryabhaṭa; Brahmagupta; Nārāyaṇa Paṇḍita, Gaṇitakaumudī (1356)"
      "saṅkalita and vāra-saṅkalita; citighana; ardhaccheda; the general figurate sums"
      ["sankalita","citighana","ardhaccheda","ghana","narayana","gulma","ganitakaumudi"]
  , Adhyaya 10 "Kerala — the series with its remainder"
      "Mādhava of Saṅgamagrāma (~1400); Nīlakaṇṭha, Tantrasaṅgraha (1501); Jyeṣṭhadeva, Yuktibhāṣā (c. 1530)"
      "power series WITH error terms and convergence acceleration -- the part the European restatements did not carry"
      ["madhava","kerala","yuktibhasa","tantrasangraha","nilakantha","jyesthadeva","sthaulya","antyasamskara","samskara"]
  , Adhyaya 11 "Tantrayukti — how a treatise is composed"
      "Kauṭilya, Arthaśāstra 15.1 (32 devices); Caraka Saṃhitā, Siddhisthāna 12 (36)"
      "pūrvapakṣa and uttarapakṣa as SLOTS the author fills; apavāda; nirṇaya; why a retraction cannot stack"
      ["tantrayukti","arthasastra","kautilya","caraka","siddhisthana","purvapaksa"]
  , Adhyaya 12 "Nāṭyaśāstra — the six tastes, and structure as experience"
      "Bharata, Nāṭyaśāstra 6.31 -- the rasa-sūtra"
      "rasa; the enumerated affective structure; śaḍrasa"
      ["shadrasa","rasa","natyasastra","bharata"]
  , Adhyaya 13 "Indra's net and the machine of truth"
      "Avataṃsaka Sūtra, the Indrajāla image; and this repository's own constructions"
      "mutual reflection without a ground; Satyayantra -- the machine that says only what it holds; ṛṇa/dhana, debt and asset as one magnitude under two readings"
      ["indra","satyayantra","rnadhana","gurutama","jiva","avatamsaka","indrajala"]
  ]

-- | One entry in the index.
data Entry = Entry { ePath :: FilePath, eChapter :: Maybe Int }

lower :: String -> String
lower = map toLower

base :: FilePath -> String
base p = lower (reverse (takeWhile (/= '/') (reverse p)))

-- | Which chapter does a path belong to?  The winner is the chapter with the
--   LONGEST matching key, ties broken by chapter order, so a specific key
--   beats a generic one embedded in the same filename.  Plain first-match
--   misfiles on substring collision -- `satyayantrasamyoga` contains "rasa".
classify :: FilePath -> Maybe Int
classify p =
  case [ (maximum (map length ms), negate (number a))
       | a <- adhyayas
       , let ms = [ k | k <- keys a, k `isInfixOf` base p ]
       , not (null ms) ] of
    [] -> Nothing
    xs -> Just (negate (snd (maximum xs)))

-- | The pre-2026-08-20 rule, kept for audit: first chapter with any matching
--   key wins.  Differs from `classify` exactly on substring collisions.
classifyFirstMatch :: FilePath -> Maybe Int
classifyFirstMatch p =
  case [ number a | a <- adhyayas, any (`isInfixOf` base p) (keys a) ] of
    (n:_) -> Just n
    []    -> Nothing

indexOf :: [FilePath] -> [Entry]
indexOf ps = [ Entry p (classify p) | p <- ps ]

chapterEntries :: [Entry] -> Int -> [FilePath]
chapterEntries es n = sort [ ePath e | e <- es, eChapter e == Just n ]

unplaced :: [Entry] -> [FilePath]
unplaced es = sort [ ePath e | e <- es, eChapter e == Nothing ]

-- | The measurement the book framing exists to make visible: how much of
--   this corpus is the book, and how much is apparatus that agents mistook
--   for the book because apparatus is what a checker rewards.
data Ratio = Ratio { inBook :: Int, apparatus :: Int }

ratio :: [Entry] -> Ratio
ratio es = Ratio (length [ () | e <- es, eChapter e /= Nothing ])
                 (length [ () | e <- es, eChapter e == Nothing ])

render :: [Entry] -> [String]
render es =
  [ "# अनुक्रमणी — the index of the book"
  , ""
  , "Generated by `machine/Anukramani.hs`.  Do not hand-edit: it is recomputed"
  , "from the filesystem, so a chapter cannot silently lose an entry."
  , ""
  , "Form: the anukramaṇī gives, per entry, the ṛṣi (who it came from) and the"
  , "devatā (what it is about).  Śaunaka; Kātyāyana, Sarvānukramaṇī."
  , ""
  ] ++ concatMap (chapterBlock es) adhyayas
    ++ apparatusBlock es

chapterBlock :: [Entry] -> Adhyaya -> [String]
chapterBlock es a =
  let fs = chapterEntries es (number a)
  in [ ""
     , "## " ++ show (number a) ++ ".  " ++ title a
     , ""
     , "**ṛṣi** — " ++ rsi a
     , ""
     , "**devatā** — " ++ devata a
     , ""
     ] ++ (if null fs
             then [ "*No entry. This chapter of the book is not written.*", "" ]
             else map (\f -> "  - `" ++ f ++ "`") fs ++ [""])

apparatusBlock :: [Entry] -> [String]
apparatusBlock es =
  let r = ratio es
      tot = inBook r + apparatus r
      pct = if tot == 0 then 0 else (100 * inBook r) `div` tot
  in [ ""
     , "---"
     , ""
     , "## Appendix — the apparatus"
     , ""
     , "Agda, Haskell, cubical type theory.  These are the SUBSTRATE the book"
     , "is checked in, not the book.  They are listed here, after the chapters,"
     , "because an agent reading this repository will otherwise take them for"
     , "the primary work -- a checker rewards a module and rewards no amount of"
     , "reading, so the pull toward apparatus is structural and not a lapse."
     , ""
     , "  reaching a chapter : " ++ show (inBook r)
     , "  reaching none      : " ++ show (apparatus r)
     , "  " ++ show pct ++ "% of the APPENDIX'S OWN FILES name a source."
     , ""
     , "That sentence used to read \"the book is N% of this corpus\", and it was"
     , "a durnaya -- a standpoint asserting itself as whole with its own ground"
     , "hidden.  This scan sees .agda and .hs under formal/cubical and machine,"
     , "which BOOK.md calls the appendix; so the only way to raise the number is"
     , "to write more Agda, which is the gradient the frame exists to oppose."
     , "Say which file set, or the figure argues for its opposite."
     , ""
     , "Two further limits, so the number is not read as more than it is."
     , "It is a LOWER bound: the test is a filename substring, and on 2026-08-20"
     , "the same keys against file BODIES placed 310 of 926 rather than 186"
     , "(notes/*.md that day: 37 by filename, 136 by body -- 3.8% against 13.9%,"
     , "so the prose does not reach this scan's LOWER bound under any"
     , "instrument).  And \"reaching none\" is not \"apparatus\" --"
     , "BOOK.md names three categories and this returns two, so a file that"
     , "reaches no chapter is apparatus OR noise and the instrument cannot say"
     , "which.  That undone half is the sesa, not a shortfall in the count."
     , "Derivation and the historical series: notes/Svapariksa_TheBookRatioIsA"
     , "StandpointAndTheSeriesDecomposes.md."
     , ""
     ]
