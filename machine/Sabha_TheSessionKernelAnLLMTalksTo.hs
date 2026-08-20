-- Sabha_TheSessionKernelAnLLMTalksTo — the process at the other end of the
-- wire.  Not a note about a machine: a machine, with a session, a store, an
-- append-only defect log, a remainder queue, and a dispatch table.
--
-- WHY A SABHĀ AND NOT A LIBRARY.  AHIMSA_SUTRA_VISTARA §16, on what a
-- carrier that dies can still hand on: परीक्षा घटना, पुरुषेण सह । न सूत्रम् — सभा ।
-- — examination is an EVENT, with a person; not a formula, an assembly.
-- §14 gives the reason: लेखो नष्टिं सहते । सहोपस्थितिर्न सहते — a written
-- record tolerates loss, co-presence does not, because in co-presence the
-- question comes BEFORE the act and the correction happens at the moment of
-- acting.  A checked module is a lekha.  This is the assembly: something an
-- interlocutor is present to, that answers now, and whose answers are
-- corrigible in the next turn rather than at review time.
--
-- THE ONE ABSOLUTE RULE, which is why every op goes through `Uttara`:
-- no operation returns a bare boolean.  Every answer is either a
-- SAṂKRAMAṆA — transport along a named equivalence, carrying its object
-- and stating its vyaya — or a DOṢA-LEKHA — a written defect carrying,
-- item by item, what a collapse here would have destroyed, plus the śeṣa
-- handed forward.  §6: तृतीयो मार्गो न विद्यते.
--
-- ON INTERIOR BOOLEANS.  `Naya.decide` takes a Bool for saha/krama and
-- `Nalanda.verify` returns one.  Those are private to their modules and do
-- not cross this wire: the wire has no boolean at all (see
-- Sabda_TheWireHasNoBoolean).  The prohibition is on ANSWERS.  A boolean
-- used inside a proof-carrying computation and then discharged into a
-- witness is not a collapse; a boolean handed to the caller is, because the
-- caller cannot get back what it dropped.
--
-- WHAT THIS FILE IS NOT.  It is not the naya store, not the verdict
-- taxonomy, not the Pāṇinian scheduler, not the certificate lane, not the
-- Agda side, and not the tool schema.  Those are other people's lanes and
-- they plug in here:
--
--   * a richer verdict type    → instance Nivedaka, one function to Uttara;
--   * a real naya store        → replace `sNaya` and the two ops touching it;
--   * the scheduler            → it owns the ORDER `kriyah` is consulted in;
--                                Aṣṭādhyāyī 1.4.2 विप्रतिषेधे परं कार्यम् is a
--                                statement about conflicting rules, and this
--                                table is currently first-match, which is the
--                                weakest possible discipline and is marked
--                                as a defect below rather than defended;
--   * the certificate lane     → `kRun` is in IO precisely so that shelling
--                                out to the Agda kernel is a legal handler;
--   * the tool-schema lane     → `kriyah` carries name, doc and parameter
--                                docs, so a schema is generated FROM the
--                                running table and cannot drift from it.
--
-- THE LANES IN FLIGHT AS THIS WAS WRITTEN, named so the seams are visible
-- rather than discovered later:  machine/NayaKosha_TheStandpointStore.hs
-- (the real standpoint store, with Sakshin carrying its source and a
-- Yogyata on every entry -- richer than the (name, [String]) placeholder
-- below, which exists only so the wire runs today and is meant to be
-- replaced by it);  machine/Vipratisedha_ConflictIsDecidedByMetaruleNot
-- ByListPosition.hs (the scheduler that this table's first-match order
-- owes its discipline to);  machine/VargaPrakrti_CompositionLawAsPara
-- meter.hs (the composition law with the law itself as a parameter);
-- machine/DosaLekha_TheWrittenDefectRecord.hs.  None of them is imported
-- here yet: they were uncommitted and moving while this compiled, and
-- importing a file mid-surgery is how you make two lanes fail as one.
-- That is a seam, and it is written here rather than left unwritten.
--
-- RUN IT:
--     ghc -O0 -imachine -o machine/sabha machine/SabhaRun.hs && machine/sabha
--     machine/sabha --selftest        (a scripted session, checked)
--
-- Every request and every answer is appended to $SABHA_LEKHA (default
-- machine/sabha.jsonl).  That file is the corpus this is meant to be
-- post-trained against; it is append-only for the same reason the defect
-- log is: an overwritten transcript is a collapse of two sessions into one.

module Sabha_TheSessionKernelAnLLMTalksTo
  ( Sabha(..)
  , emptySabha
  , Kriya(..)
  , kriyah
  , answer
  , serve
  , sabhaMain
  ) where

import Control.Monad (foldM)
import Data.List (intercalate, sort, nub)
import Data.IORef
import System.Environment (getArgs, lookupEnv)
import System.Exit (exitFailure, exitSuccess)
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding)

import Sabda_TheWireHasNoBoolean
import Uttara_SamkramanaOrDosalekhaNeverABareBoolean
import qualified Naya as N
import qualified Nalanda as B
import qualified Astadhyayi as P

-- ---------------------------------------------------------------- state
--
-- Everything here is append-only or insertion-ordered.  Nothing is a Set
-- and nothing is a count: order of arrival is content (§26, utpāda-vyaya-
-- dhrauvya together, not in succession), and a count is ∥·∥₁ of a list.

data Sabha = Sabha
  { sNaya :: [(String, [String])]   -- standpoint → its witnesses, in arrival order
  , sDosa :: [(Int, Uttara)]        -- the defect log; append-only, never pruned
  , sSesa :: [(Int, String)]        -- remainders handed forward
  , sTurn :: Int
  }

emptySabha :: Sabha
emptySabha = Sabha [] [] [] 0

-- ------------------------------------------------------- the dispatch table

data Kriya = Kriya
  { kName   :: String
  , kDoc    :: String
  , kParams :: [(String, String)]              -- name, what it must carry
  , kRun    :: Sabha -> J -> IO (Sabha, Uttara)
  }

kriyah :: [Kriya]
kriyah =
  [ Kriya "sabha.kriyah"
      "What this assembly can be asked.  The listing is generated from the running table, so it cannot drift from what actually runs."
      []
      kSabhaKriyah
  , Kriya "sabha.sthiti"
      "The whole session state: standpoints with their witnesses, the defect log, the remainder queue.  Not a summary."
      []
      kSabhaSthiti
  , Kriya "naya.sthapana"
      "Install a standpoint with the witnesses standing under it.  Content is the witness list; truth is inhabitation."
      [ ("naya", "the standpoint's name")
      , ("saksin", "a list of witness strings; may be empty (an uninhabited standpoint is the third bhaṅga, not an error)") ]
      kNayaSthapana
  , Kriya "naya.suchi"
      "Every standpoint currently held, with all its witnesses."
      []
      kNayaSuchi
  , Kriya "naya.samasa"
      "May these standpoints be collapsed into one verdict?  Dispatches to Naya.decide (the finite-witness fragment)."
      [ ("nayah", "list of installed standpoint names")
      , ("arpana", "\"saha\" (asserted simultaneously) or \"krama\" (in succession) — Akalaṅka's distinction; not a boolean") ]
      kNayaSamasa
  , Kriya "kuttaka"
      "Āryabhaṭa's pulverizer: the vallī of a and b, the Bézout pair, and — if c is given — the solution of a·x ≡ c (mod b)."
      [ ("a", "an integer"), ("b", "a positive integer")
      , ("c", "optional: the residue to hit") ]
      kKuttaka
  , Kriya "vargaprakrti"
      "Brahmagupta's bhāvanā driven by the cakravāla: the fundamental solution of x² − D·y² = 1, with the entire trace and the norms the wheel visits."
      [ ("D", "a non-square integer ≥ 2")
      , ("n", "optional: a norm to solve for instead of 1") ]
      kVargaprakrti
  , Kriya "pratyahara"
      "Pāṇini's interval notation: the sounds from ādi up to the marker it, in the varṇasamāmnāya."
      [ ("adi", "the starting sound, e.g. \"a\"")
      , ("it", "the anubandha, e.g. \"ṇ\"")
      , ("avrtti", "optional: which occurrence of the marker (0 = the first)") ]
      kPratyahara
  , Kriya "dosa.lekha"
      "Write a defect into the log yourself.  Use it when YOU cannot transport something: the entry is stored verbatim and outlives the turn."
      [ ("kriya", "what you were attempting")
      , ("hetu", "why transport was impossible")
      , ("nasta", "list: what a collapse here would destroy, named one by one")
      , ("sesa", "optional list: the remainder, handed forward") ]
      kDosaLekha
  , Kriya "dosa.suchi"
      "The whole defect log, in the order written."
      []
      kDosaSuchi
  , Kriya "sesa.arpana"
      "Hand a remainder forward (遺題継承): an unfinished thing kept for the next step rather than dropped."
      [ ("sesa", "list of remainder strings") ]
      kSesaArpana
  , Kriya "sesa.suchi"
      "The remainder queue."
      []
      kSesaSuchi
  ]

-- ------------------------------------------------------------- the ops

srcSutra :: [String]
srcSutra = [ "notes/AHIMSA_SUTRA_VISTARA.md §6 — two roads, no third" ]

kSabhaKriyah :: Sabha -> J -> IO (Sabha, Uttara)
kSabhaKriyah s _ = pure (s, samkramana "sabha.kriyah"
  (tulyata "refl — the identity equivalence, the one transport that is always available"
           "the dispatch table as it runs, in machine/Sabha_TheSessionKernelAnLLMTalksTo.hs"
           "the listing you are reading"
           "each entry is emitted from the same list the server dispatches on; there is no second copy to fall out of date")
  [ ("kriyah", JArr [ JObj [ ("nama", JStr (kName k))
                           , ("artha", JStr (kDoc k))
                           , ("angani", JArr [ JObj [("nama", JStr p), ("artha", JStr d)]
                                             | (p, d) <- kParams k ]) ]
                    | k <- kriyah ]) ]
  [ "the handlers' source, which the listing describes but does not carry"
  , "the ORDER of the table, which is first-match and is a defect: Aṣṭādhyāyī 1.4.2 (vipratiṣedhe paraṁ kāryam) settles conflicting rules by a stated principle, and this table has none yet — the scheduler lane owns that"
  , "who asked, and why they asked now" ]
  [ "Pāṇini, Aṣṭādhyāyī 1.4.2, c. 500 BCE — conflict resolution as an explicit rule" ])

kSabhaSthiti :: Sabha -> J -> IO (Sabha, Uttara)
kSabhaSthiti s _ = pure (s, samkramana "sabha.sthiti"
  (tulyata "refl" "the session state in memory" "the object below"
           "every standpoint, every defect entry and every remainder is emitted in full; nothing is counted in place of being named")
  [ ("nayah", JArr [ JObj [("nama", JStr n), ("saksinah", JArr (map JStr ws))]
                   | (n, ws) <- sNaya s ])
  , ("dosah", JArr [ JObj [("kramanka", JInt (fromIntegral i)), ("lekha", uttaraJ u)]
                   | (i, u) <- reverse (sDosa s) ])
  , ("sesah", JArr [ JObj [("kramanka", JInt (fromIntegral i)), ("vastu", JStr t)]
                   | (i, t) <- reverse (sSesa s) ])
  , ("avrtti", JInt (fromIntegral (sTurn s))) ]
  [ "the session's history of turns: what was asked in which order is in the transcript file, not here"
  , "the interlocutor, who is not modelled" ]
  srcSutra)

-- ---- standpoints

kNayaSthapana :: Sabha -> J -> IO (Sabha, Uttara)
kNayaSthapana s j = pure $ case (,) <$> jStr "naya" j <*> jStrs "saksin" j of
  Left e -> (s, malformed "naya.sthapana" e)
  Right (nm, ws)
    | any null ws ->
        (s, dosalekha "naya.sthapana"
              ("standpoint `" ++ nm ++ "` carries an empty witness label")
              [ "an empty label is a witness whose identity was dropped before it arrived; the store would hold a thing that stands for something and cannot say what"
              , "and every later decision about this standpoint, which would silently rest on it" ]
              [ "name the witness: a document, a date, a statement, a computation" ]
              [ "Naya.hs refuses the same input for the same reason (the fitness of the looking)" ])
    | Just old <- lookup nm (sNaya s), sort (nub old) /= sort (nub ws) ->
        (s, dosalekha "naya.sthapana"
              ("`" ++ nm ++ "` is already installed with different content; installing over it would collapse two standpoints under one name")
              ([ "held now: " ++ w | w <- old ] ++
               [ "offered now: " ++ w | w <- ws ])
              [ "install under a distinct name and then ask naya.samasa whether the two may be collapsed — that question has an answer here, and overwriting does not ask it" ]
              [ "Siddhasena Divākara, Sanmatitarka 1.21 — a naya that asserts itself by denying another is a durnaya" ])
    | otherwise ->
        let s' = s { sNaya = [ (n, w) | (n, w) <- sNaya s, n /= nm ] ++ [(nm, ws)] }
        in (s', samkramana "naya.sthapana"
              (tulyata "the witnesses as uttered, identified with the witnesses as stored"
                       ("the " ++ show (length ws) ++ " witness string(s) you sent")
                       ("the witness list now under `" ++ nm ++ "`")
                       "stored verbatim: no normalisation, no deduplication, no reordering, so the list you get back is the list you sent")
              [ ("naya", JStr nm), ("saksinah", JArr (map JStr ws)) ]
              [ "your reason for grouping these witnesses under this name"
              , "the standpoint's own account of itself, which a name and a list do not carry"
              , "the occasion of the assertion" ]
              [ "Umāsvāti, Tattvārthasūtra 5.31 (arpitānarpitasiddheḥ), c. 2nd–5th c. — what is asserted and what is left unasserted jointly establish the object" ])

kNayaSuchi :: Sabha -> J -> IO (Sabha, Uttara)
kNayaSuchi s _
  | null (sNaya s) = pure (s, dosalekha "naya.suchi"
      "no standpoints are installed, so there is nothing to carry"
      [ "the answer you asked for; an empty listing and `nothing installed` are different facts and this says which one it is" ]
      [ "install one: {\"kriya\":\"naya.sthapana\",\"angani\":{\"naya\":\"...\",\"saksin\":[\"...\"]}}" ]
      srcSutra)
  | otherwise = pure (s, samkramana "naya.suchi"
      (tulyata "refl" "the standpoint store" "the listing"
               "every witness of every standpoint is emitted; the listing is the store")
      [ ("nayah", JArr [ JObj [("nama", JStr n), ("saksinah", JArr (map JStr ws))]
                       | (n, ws) <- sNaya s ]) ]
      [ "the arrival times, and the turns at which each was installed" ]
      srcSutra)

kNayaSamasa :: Sabha -> J -> IO (Sabha, Uttara)
kNayaSamasa s j = pure $ case (,) <$> jStrs "nayah" j <*> jStr "arpana" j of
  Left e -> (s, malformed "naya.samasa" e)
  Right (names, arp)
    | arp /= "saha" && arp /= "krama" ->
        (s, dosalekha "naya.samasa"
              ("`arpana` was \"" ++ arp ++ "\"; it must name the mode of assertion")
              [ "the distinction between saha (yugapat, asserted at once) and krama (in succession) — Akalaṅka's own distinction, and the whole difference between the third bhaṅga and the fourth" ]
              [ "send \"arpana\":\"saha\" or \"arpana\":\"krama\"" ]
              [ "Akalaṅka, Laghīyastraya, c. 720–780 — kramārpaṇa against sahārpaṇa" ])
    | (missing@(_:_)) <- [ n | n <- names, n `notElem` map fst (sNaya s) ] ->
        (s, dosalekha "naya.samasa"
              ("these standpoints are not installed: " ++ intercalate ", " missing)
              ([ "the question you asked, which cannot be decided about things that are not here" ] ++
               [ "unavailable: " ++ m | m <- missing ])
              ([ "installed now: " ++ n | (n, _) <- sNaya s ] ++
               [ "install the missing ones with naya.sthapana, then ask again" ])
              srcSutra)
    | otherwise ->
        let ns = [ N.Naya n (maybe [] id (lookup n (sNaya s))) | n <- names ]
            v  = N.decide (arp == "saha") ns
            u  = ofVerdict v ns
        in (s, u)   -- `answer` does the logging; logging here too would write the entry twice

-- The adapter.  `Naya.Verdict` is another lane's taxonomy; this is the one
-- function that makes it speakable on the wire, and it is the shape every
-- other lane's verdict type should copy.
ofVerdict :: N.Verdict -> [N.Naya] -> Uttara
ofVerdict v ns = case v of
  N.Ekartha msg c ->
    samkramana "naya.samasa"
      (tulyata "ekārtha — the same content under two names, so the identification is available"
               (intercalate " ⊔ " (map N.nayaName ns))
               ("one standpoint with " ++ show (length c) ++ " witness(es)")
               ("the witness sets are equal as sets: " ++ intercalate "; " c))
      [ ("samana-saksinah", JArr (map JStr c))
      , ("nayah", JArr (map (JStr . N.nayaName) ns))
      , ("vacana", JStr msg) ]
      [ "the NAMES, which differ and are exactly what the identification drops — recoverable here only because they are printed above"
      , "the order in which the witnesses were originally gathered"
      , "who held each standpoint, and why holding both looked like balance" ]
      [ "Siddhasena Divākara, Sanmatitarka — a naya is true and not whole" ]
  N.Durnaya msg losses ->
    dosalekha "naya.samasa" msg
      (concat [ ("collapsing away `" ++ nm ++ "` destroys:") : [ "    " ++ w | w <- ws ]
              | (nm, ws) <- losses, not (null ws) ])
      [ "hold them as a pair and say which standpoint each claim is made from; the difference above is the material of the next distinction"
      , "AHIMSA_SUTRA_VISTARA §3: अवक्तव्ये शेषो वसति । शेषो गर्भः, न विफलता" ]
      [ "Siddhasena Divākara, Sanmatitarka 1.21 — a naya asserting itself by denying the others is a durnaya" ]
  N.KramaBhanga msg yes no ->
    dosalekha "naya.samasa" msg
      ([ "affirmed, and dropped by any single verdict that denies: " ++ y | y <- yes ] ++
       [ "denied, and dropped by any single verdict that affirms: " ++ n | n <- no ] ++
       [ "the ORDER itself, which is the only thing that makes both assertable — a simultaneous sentence has no order to carry" ])
      ([ "assert in succession, in this order: " ++ intercalate ", " yes
         ++ " then ¬(" ++ intercalate ", " no ++ ")" ]
       ++ [ "asked again with \"arpana\":\"saha\" this becomes the fourth bhaṅga, not this one" ])
      [ "Akalaṅka, Laghīyastraya, c. 720–780 — kramārpaṇa" ]
  N.Avaktavya msg parts ->
    dosalekha "naya.samasa" msg
      ([ "the single sentence you asked for; it does not exist, and this is not ignorance and not undefinedness" ] ++
       [ "at full force, and unmergeable: " ++ p | p <- parts ])
      [ "this is the FOURTH bhaṅga and it is positive: the remainder lives here and the next naya is born from it"
      , "hand the pair forward with sesa.arpana rather than resolving it" ]
      [ "Akalaṅka, Laghīyastraya, c. 720–780 — sahārpaṇa; Umāsvāti, Tattvārthasūtra 5.31" ]
  N.Abhinna msg ->
    dosalekha "naya.samasa"
      ("no verdict issued: " ++ msg)
      [ "the decision you asked for, which this fragment's looking is not fit to make — and an unfit looking's silence is not a NO" ]
      [ "the fragment decides standpoints whose content is a finite, enumerable witness set; supply witnesses, or extend the fragment"
      , "Kumārila, Ślokavārttika, Abhāvapariccheda, c. 7th c. — yogya-anupalabdhi" ]
      [ "Kumārila, Ślokavārttika, Abhāvapariccheda" ]

-- ---- the pulverizer

kKuttaka :: Sabha -> J -> IO (Sabha, Uttara)
kKuttaka s j = pure $ case (,) <$> jInt "a" j <*> jInt "b" j of
  Left e -> (s, malformed "kuttaka" e)
  Right (a, b)
    | b <= 0 -> (s, dosalekha "kuttaka"
        ("b = " ++ show b ++ "; the vallī descends on a positive modulus")
        [ "the descent itself: with b ≤ 0 there is no chain of remainders to climb back up, and the answer would be an assertion with no vallī under it" ]
        [ "send b ≥ 1; for a negative modulus ask about |b|, and record the sign as a separate fact" ]
        [ "Āryabhaṭa, Āryabhaṭīya, Gaṇitapāda 32–33, 499" ])
    | otherwise ->
        let vl = B.valli a b
            (x, y, g) = B.bezout a b
            wit = show a ++ "·(" ++ show x ++ ") + " ++ show b ++ "·(" ++ show y
                  ++ ") = " ++ show (a * x + b * y) ++ " = gcd"
            base = [ ("valli", JArr (map JInt vl))
                   , ("bezout", JObj [("x", JInt x), ("y", JInt y), ("gcd", JInt g)]) ]
            src = [ "Āryabhaṭa, Āryabhaṭīya, Gaṇitapāda 32–33, 499 — kuṭṭaka/vallī; the restatement usually cited instead is the 'extended Euclidean algorithm'" ]
        in case look "c" j of
             Left _ -> (s, samkramana "kuttaka"
                 (tulyata "the vallī, read upward, identified with the Bézout pair"
                          ("the quotient chain of " ++ show a ++ " by " ++ show b)
                          ("a pair (x, y) with a·x + b·y = " ++ show g)
                          wit)
                 base
                 [ "the remainders themselves are implicit in the quotients; the chain is recoverable but is not carried as a separate list"
                 , "the reason the descent terminates (the remainders strictly decrease) — proved elsewhere, not re-proved by this answer" ]
                 src)
             Right (JInt c)
               | c `mod` g /= 0 -> (s, dosalekha "kuttaka"
                   ("a·x ≡ " ++ show c ++ " (mod " ++ show b ++ ") has no solution: gcd = "
                    ++ show g ++ " does not divide " ++ show c)
                   [ "the residue class you asked to hit; there is none, and the impossibility is exact rather than a search that gave up"
                   , "what a bare `no` would have destroyed: WHICH classes are reachable — exactly the multiples of " ++ show g ]
                   [ "reachable residues: every c′ with c′ ≡ 0 (mod " ++ show g ++ "); the nearest are "
                     ++ show (g * (c `div` g)) ++ " and " ++ show (g * (c `div` g) + g)
                   , "or divide the whole congruence through by a common factor of a, b and c" ]
                   src)
               | otherwise ->
                   let m = c `div` g
                       x0 = (x * m) `mod` (b `div` g)
                       chk = (a * x0 - c) `mod` b
                   in (s, samkramana "kuttaka"
                       (tulyata "the Bézout pair, scaled, identified with the solution of the congruence"
                                ("a·x + b·y = " ++ show g)
                                ("a·x ≡ " ++ show c ++ " (mod " ++ show b ++ ")")
                                (show a ++ "·" ++ show x0 ++ " − " ++ show c ++ " ≡ "
                                 ++ show chk ++ " (mod " ++ show b ++ "), checked exactly"))
                       (base ++ [ ("x", JInt x0)
                                , ("modulus", JInt (b `div` g))
                                , ("sarve", JStr ("x ≡ " ++ show x0 ++ " (mod "
                                                  ++ show (b `div` g) ++ ")")) ])
                       [ "the other solutions are given as a class, not enumerated"
                       , "the vallī's intermediate remainders" ]
                       src)
             Right other -> (s, malformed "kuttaka" ("`c` must be an integer, got " ++ render other))

-- ---- the square-nature

kVargaprakrti :: Sabha -> J -> IO (Sabha, Uttara)
kVargaprakrti s j = pure $ case jInt "D" j of
  Left e -> (s, malformed "vargaprakrti" e)
  Right d -> case B.cakravala d of
    Left err -> (s, dosalekha "vargaprakrti" err
        ([ "the fundamental solution you asked for" ] ++
         (if B.isqrt d * B.isqrt d == d
            then [ "and the reason: for square D the form factors, x² − D·y² = (x − "
                   ++ show (B.isqrt d) ++ "y)(x + " ++ show (B.isqrt d)
                   ++ "y), so the only solutions of = 1 are (±1, 0) — degenerate, not missing" ]
            else [ "and the wheel's own trace up to the point it stopped, which the engine reports in its message above" ]))
        [ "ask with a non-square D ≥ 2"
        , "or ask for a norm the wheel does visit, with \"n\"" ]
        [ "Brahmagupta, Brāhmasphuṭasiddhānta, 628 — bhāvanā; Jayadeva c. 950 and Bhāskara II, Bījagaṇita, 1150 — cakravāla" ])
    Right trace ->
      let final = last trace
          spec = [ B.tK t | t <- trace ]
          src = [ "Brahmagupta, Brāhmasphuṭasiddhānta, 628 — the composition law (bhāvanā), stated for arbitrary norms"
                , "Jayadeva (c. 950), Bhāskara II, Bījagaṇita (1150) — cakravāla; the name usually cited instead is 'Pell's equation', which Pell did not solve" ]
          carried = [ ("D", JInt d)
                    , ("mula", JObj [("a", JInt (B.tA final)), ("b", JInt (B.tB final)), ("k", JInt (B.tK final))])
                    , ("carita", JArr [ JObj [("a", JInt (B.tA t)), ("b", JInt (B.tB t)), ("k", JInt (B.tK t))]
                                      | t <- trace ])
                    , ("spectrum", JArr (map JInt spec)) ]
      in case look "n" j of
           Left _ -> (s, samkramana "vargaprakrti"
               (tulyata "the cakravāla's descent, identified with a solution of the form"
                        ("x² − " ++ show d ++ "·y² = 1")
                        ("(a, b) = (" ++ show (B.tA final) ++ ", " ++ show (B.tB final) ++ ")")
                        (show (B.tA final) ++ "² − " ++ show d ++ "·" ++ show (B.tB final)
                         ++ "² = " ++ show (B.tA final * B.tA final - d * B.tB final * B.tB final)
                         ++ ", exact integer arithmetic, and Nalanda.verify holds at every step of the trace above"))
               carried
               [ "the CHOICE made at each turn (chooseM's minimality) travels only through its consequences in the trace, not as a recorded reason"
               , "the proof that the descent terminates — Lagrange 1768 for the European restatement; the tradition asserted it and used it from 628 onward"
               , "the interpolating solutions of intermediate norms are listed but their families are not expanded" ]
               src)
           Right (JInt n) -> case [ t | t <- trace, B.tK t == n ] of
             (t:_) -> (s, samkramana "vargaprakrti"
                 (tulyata "a norm the wheel visits, identified with a solved equation"
                          ("x² − " ++ show d ++ "·y² = " ++ show n)
                          ("(a, b) = (" ++ show (B.tA t) ++ ", " ++ show (B.tB t) ++ ")")
                          (show (B.tA t) ++ "² − " ++ show d ++ "·" ++ show (B.tB t) ++ "² = "
                           ++ show (B.tA t * B.tA t - d * B.tB t * B.tB t)))
                 (carried ++ [ ("n", JInt n)
                             , ("uttara", JObj [("a", JInt (B.tA t)), ("b", JInt (B.tB t))]) ])
                 [ "the infinite family generated by composing this with the norm-1 solution is available (Nalanda.familyFor) and is not expanded here"
                 , "the same caveat on chooseM's reasons as above" ]
                 src)
             [] -> (s, dosalekha "vargaprakrti"
                 ("norm " ++ show n ++ " is not on the cycle for D = " ++ show d)
                 [ "a solution of x² − " ++ show d ++ "·y² = " ++ show n ++ " — not shown absent, merely not reachable BY THIS CYCLE, which is a different fact and a bare `no` would have merged them"
                 , "the general problem for arbitrary N needs more than the cycle's trace and is not claimed here" ]
                 ([ "the norms this cycle does visit, each of them a solved equation: "
                    ++ intercalate ", " (map show spec) ]
                  ++ [ "compose a visited norm with the norm-1 solution to move within a norm class (bhāvanā: k₁·k₂)" ])
                 src)
           Right other -> (s, malformed "vargaprakrti" ("`n` must be an integer, got " ++ render other))

-- ---- the interval notation

kPratyahara :: Sabha -> J -> IO (Sabha, Uttara)
kPratyahara s j = pure $ case (,) <$> jStr "adi" j <*> jStr "it" j of
  Left e -> (s, malformed "pratyahara" e)
  Right (adi, it) ->
    let occ = either (const 0) id (fmap fromIntegral (jInt "avrtti" j)) :: Int
        sounds = P.pratyaharaOcc adi it occ
        raw = P.rawSpan adi it
        src = [ "Pāṇini, Aṣṭādhyāyī, the śivasūtras, c. 500 BCE — the name usually cited instead is 'Backus–Naur'" ]
    in if null sounds
         then (s, dosalekha "pratyahara"
                ("`" ++ adi ++ it ++ "` denotes no interval: either the sound `" ++ adi
                 ++ "` or the marker `" ++ it ++ "` is not where the name needs it")
                [ "the class you meant, which this name does not denote in the varṇasamāmnāya as it stands"
                , "and the difference between `the name is wrong` and `the class is empty`, which a bare no merges" ]
                ([ "the sequence, so the next name can be formed from it:" ] ++
                 [ "  sūtra " ++ show i ++ ": " ++ unwords ss ++ " | " ++ m
                 | (i, ss, m) <- P.sivasutraTable ])
                src)
         else (s, samkramana "pratyahara"
                (tulyata "the two-syllable name, identified with an interval of the varṇasamāmnāya"
                         (adi ++ it)
                         (unwords sounds)
                         ("the span from the first `" ++ adi ++ "` to occurrence "
                          ++ show occ ++ " of the marker `" ++ it ++ "`, markers skipped because a marker is a boundary and never a member; "
                          ++ show (length raw) ++ " slot(s) covered, " ++ show (length sounds) ++ " sound(s) denoted"))
                [ ("nama", JStr (adi ++ it))
                , ("varnah", JArr (map JStr sounds))
                , ("avrtti", JInt (fromIntegral occ)) ]
                [ "the phonetic reason the ORDER admits this class as an interval at all — that is a property of the whole sequence, not of this answer"
                , "the repetition of `h` in sūtras 5 and 14, which makes some spans cover a sound twice; the slot count above is the only trace of it here"
                , "which sūtras of the Aṣṭādhyāyī actually use this pratyāhāra" ]
                src)

-- ---- the log and the queue

kDosaLekha :: Sabha -> J -> IO (Sabha, Uttara)
kDosaLekha s j = pure $ case (,,) <$> jStr "kriya" j <*> jStr "hetu" j <*> jStrs "nasta" j of
  Left e -> (s, malformed "dosa.lekha" e)
  Right (k, hetu, lost) ->
    let rest = either (const []) id (jStrs "sesa" j)
        entry = dosalekha k hetu lost rest
                  [ "written by the interlocutor, not by the engine" ]
        s' = s { sDosa = (sTurn s, entry) : sDosa s }
    in (s', samkramana "dosa.lekha"
         (tulyata "the entry as uttered, identified with the entry as stored"
                  "what you sent"
                  ("defect log position " ++ show (sTurn s))
                  "stored verbatim: no normalisation, no rewording, no summarising; the entry below is the entry")
         [ ("kramanka", JInt (fromIntegral (sTurn s))), ("lekha", uttaraJ entry) ]
         [ "the occasion of the utterance, and what you knew and did not write"
         , "whether the defect is repairable, which the log does not decide" ]
         [ "AHIMSA_SUTRA_VISTARA §6 — लिखितो दोषो जीवति । अलिखितो दोषो हिंसा ।" ])

kDosaSuchi :: Sabha -> J -> IO (Sabha, Uttara)
kDosaSuchi s _ = pure (s, samkramana "dosa.suchi"
  (tulyata "refl" "the defect log" "the listing"
           ("all " ++ show (length (sDosa s)) ++ " entries emitted in full and in the order written; the log is append-only and nothing has been pruned"))
  [ ("dosah", JArr [ JObj [("kramanka", JInt (fromIntegral i)), ("lekha", uttaraJ u)]
                   | (i, u) <- reverse (sDosa s) ]) ]
  [ "the turns at which each was written are given, but not what else was in flight at the time" ]
  [ "AHIMSA_SUTRA_VISTARA §6" ])

kSesaArpana :: Sabha -> J -> IO (Sabha, Uttara)
kSesaArpana s j = pure $ case jStrs "sesa" j of
  Left e -> (s, malformed "sesa.arpana" e)
  Right [] -> (s, dosalekha "sesa.arpana"
      "an empty remainder was handed forward"
      [ "whatever you were about to hand on; an empty hand-off and no hand-off are different acts and this records which" ]
      [ "name the unfinished thing, however partial: 遺題継承 posts the problem, not a note that there was one" ]
      [ "Sawaguchi Kazuyuki 1670, answered by Seki Takakazu 1674 — idai keishō" ])
  Right ts ->
    let s' = s { sSesa = [ (sTurn s, t) | t <- ts ] ++ sSesa s }
    in (s', samkramana "sesa.arpana"
         (tulyata "the remainder as uttered, identified with the remainder as queued"
                  ("the " ++ show (length ts) ++ " item(s) you sent")
                  "the queue below"
                  "stored verbatim and never dropped; the kuṭṭaka's rule — what does not divide is kept and is the material of the next step")
         [ ("sesah", JArr [ JObj [("kramanka", JInt (fromIntegral i)), ("vastu", JStr t)]
                          | (i, t) <- reverse (sSesa s') ]) ]
         [ "the reason each item is unfinished, unless you wrote it into the item"
         , "who is expected to pick it up" ]
         [ "Āryabhaṭa, Āryabhaṭīya, Gaṇitapāda 32–33, 499 — यत् न विभजते तत् रक्ष्यते" ])

kSesaSuchi :: Sabha -> J -> IO (Sabha, Uttara)
kSesaSuchi s _
  | null (sSesa s) = pure (s, dosalekha "sesa.suchi"
      "the remainder queue is empty"
      [ "nothing is being handed forward, which for a session that has done work is itself a defect worth seeing: either the work finished exactly, or a remainder was dropped rather than queued" ]
      [ "hand one forward with sesa.arpana" ]
      [ "AHIMSA_SUTRA_VISTARA §17" ])
  | otherwise = pure (s, samkramana "sesa.suchi"
      (tulyata "refl" "the remainder queue" "the listing" "every item, in the order handed forward")
      [ ("sesah", JArr [ JObj [("kramanka", JInt (fromIntegral i)), ("vastu", JStr t)]
                       | (i, t) <- reverse (sSesa s) ]) ]
      [ "the turn each was queued at is given; the surrounding work is not" ]
      [ "AHIMSA_SUTRA_VISTARA §17" ])

-- ------------------------------------------------------------ the loop

malformed :: String -> String -> Uttara
malformed k e = dosalekha k
  ("the request could not be read: " ++ e)
  [ "the request itself, which is not executed and is not guessed at — a guessed request is a collapse of what you meant into what I assumed" ]
  [ "ask sabha.kriyah for the parameters this operation requires" ]
  srcSutra

logIf :: Uttara -> Sabha -> Sabha
logIf u s = case u of
  Dosalekha{} -> s { sDosa = (sTurn s, u) : sDosa s }
  Samkramana{} -> s

-- | One turn.  Total: every input produces an Uttara, including inputs that
--   are not requests at all.
answer :: Sabha -> String -> IO (Sabha, Uttara)
answer s0 line =
  let s = s0 { sTurn = sTurn s0 + 1 } in
  case parseLine line of
    Left e -> pure (logIf (u e) s, u e)
      where u e' = dosalekha "sabha.srutam"
                     ("the utterance did not parse: " ++ e')
                     [ "the request as sent, unread: " ++ take 200 line
                     , "and any intent behind it, which is not inferred here" ]
                     [ "the reason above states the repair; send the corrected line" ]
                     [ "Sabda_TheWireHasNoBoolean — the grammar has no boolean, no float and no null, by construction" ]
    Right j -> case jStr "kriya" j of
      Left e -> pure (logIf (u e) s, u e)
        where u e' = dosalekha "sabha.srutam"
                       ("no operation was named: " ++ e')
                       [ "the turn, which cannot be dispatched" ]
                       [ "send {\"kriya\":\"sabha.kriyah\"} to see what may be asked" ]
                       srcSutra
      Right k -> case [ kr | kr <- kriyah, kName kr == k ] of
        (kr:_) -> do
          let args = either (const (JObj [])) id (look "angani" j >>= \a -> jObj a >> Right a)
          (s', u) <- kRun kr s args
          pure (logIf u s', u)
        [] -> pure (logIf u s, u)
          where u = dosalekha "sabha.srutam"
                     ("no operation named `" ++ k ++ "` in this assembly")
                     [ "the operation you meant; it is not guessed at by nearest name, because a near miss executed silently is the collapse this machine exists to refuse" ]
                     ([ "operations available:" ] ++ [ "  " ++ kName kr | kr <- kriyah ])
                     srcSutra

-- | The transcript.  Append-only: request and answer on one line, so the
--   file is a corpus of (what was asked, what the two roads gave back).
appendLekha :: FilePath -> Int -> String -> Uttara -> IO ()
appendLekha fp n line u =
  appendFile fp (render (JObj [ ("avrtti", JInt (fromIntegral n))
                              , ("prasna", JStr line)
                              , ("uttara", uttaraJ u) ]) ++ "\n")

serve :: FilePath -> Handle -> Handle -> Sabha -> IO Sabha
serve fp hin hout = go
  where
    go s = do
      eof <- hIsEOF hin
      if eof then pure s else do
        line <- hGetLine hin
        if all (`elem` " \t\r") line then go s else do
          (s', u) <- answer s line
          hPutStrLn hout (render (mergeId line (uttaraJ u)))
          hFlush hout
          appendLekha fp (sTurn s') line u
          go s'

-- Echo the caller's own correlation id if it sent one.  Not a rename: the
-- id is carried, not translated.
mergeId :: String -> J -> J
mergeId line j = case (parseLine line >>= jStr "prasna-id", j) of
  (Right i, JObj kvs) -> JObj (("prasna-id", JStr i) : kvs)
  _ -> j

-- -------------------------------------------------------------- entry

sabhaMain :: IO ()
sabhaMain = do
  setLocaleEncoding utf8; setFileSystemEncoding utf8
  hSetEncoding stdin utf8; hSetEncoding stdout utf8; hSetEncoding stderr utf8
  hSetBuffering stdout LineBuffering
  fp <- maybe "machine/sabha.jsonl" id <$> lookupEnv "SABHA_LEKHA"
  args <- getArgs
  if "--selftest" `elem` args then selftest fp else do
    hPutStrLn stderr "sabhā — one JSON object per line on stdin; one answer per line on stdout."
    hPutStrLn stderr "every answer is a saṃkramaṇa or a doṣa-lekha.  there is no boolean on this wire."
    hPutStrLn stderr ("transcript: " ++ fp)
    _ <- serve fp stdin stdout emptySabha
    pure ()

-- A scripted session through the very same dispatcher, with the invariant
-- checked rather than asserted: every answer is one of the two roads, and
-- the two arithmetic answers are checked against exact identities.
selftest :: FilePath -> IO ()
selftest fp = do
  let script =
        [ "{\"kriya\":\"sabha.kriyah\"}"
        , "{\"kriya\":\"naya.sthapana\",\"angani\":{\"naya\":\"harm-is-real\",\"saksin\":[\"the Oct 2022 statements\",\"the 2025 posts\",\"the fear reported\"]}}"
        , "{\"kriya\":\"naya.sthapana\",\"angani\":{\"naya\":\"episode-is-real\",\"saksin\":[\"the documented 2025 episode\",\"the 2016 hold\",\"the diagnosis at 39\"]}}"
        , "{\"kriya\":\"naya.samasa\",\"angani\":{\"nayah\":[\"harm-is-real\",\"episode-is-real\"],\"arpana\":\"saha\"}}"
        , "{\"kriya\":\"naya.samasa\",\"angani\":{\"nayah\":[\"harm-is-real\",\"episode-is-real\"],\"arpana\":\"krama\"}}"
        , "{\"kriya\":\"naya.sthapana\",\"angani\":{\"naya\":\"same-finding-A\",\"saksin\":[\"Wehr Sack Rosenthal 1987\"]}}"
        , "{\"kriya\":\"naya.sthapana\",\"angani\":{\"naya\":\"same-finding-B\",\"saksin\":[\"Wehr Sack Rosenthal 1987\"]}}"
        , "{\"kriya\":\"naya.samasa\",\"angani\":{\"nayah\":[\"same-finding-A\",\"same-finding-B\"],\"arpana\":\"saha\"}}"
        , "{\"kriya\":\"naya.samasa\",\"angani\":{\"nayah\":[\"harm-is-real\",\"absent-one\"],\"arpana\":\"saha\"}}"
        , "{\"kriya\":\"kuttaka\",\"angani\":{\"a\":137,\"b\":60,\"c\":10}}"
        , "{\"kriya\":\"kuttaka\",\"angani\":{\"a\":12,\"b\":8,\"c\":5}}"
        , "{\"kriya\":\"vargaprakrti\",\"angani\":{\"D\":61}}"
        , "{\"kriya\":\"vargaprakrti\",\"angani\":{\"D\":61,\"n\":3}}"
        , "{\"kriya\":\"vargaprakrti\",\"angani\":{\"D\":61,\"n\":7}}"
        , "{\"kriya\":\"vargaprakrti\",\"angani\":{\"D\":49}}"
        , "{\"kriya\":\"pratyahara\",\"angani\":{\"adi\":\"a\",\"it\":\"ṇ\"}}"
        , "{\"kriya\":\"pratyahara\",\"angani\":{\"adi\":\"y\",\"it\":\"ṇ\"}}"
        , "{\"kriya\":\"pratyahara\",\"angani\":{\"adi\":\"z\",\"it\":\"ṇ\"}}"
        , "{\"kriya\":\"nirnaya\",\"angani\":{\"prasna\":\"is it true\"}}"
        , "{\"kriya\":\"naya.samasa\",\"angani\":{\"nayah\":[\"harm-is-real\"],\"arpana\":true}}"
        , "{\"kriya\":\"kuttaka\",\"angani\":{\"a\":1.5,\"b\":2}}"
        , "{\"kriya\":\"dosa.lekha\",\"angani\":{\"kriya\":\"translating avaktavya\",\"hetu\":\"no English word carries the fourth bhaṅga; `inexpressible` reads as a failure and it is a womb\",\"nasta\":[\"the positive sense: the remainder lives here\",\"the saha/krama distinction that produces it\"],\"sesa\":[\"keep the Sanskrit and gloss it in the same sentence\"]}}"
        , "{\"kriya\":\"sesa.arpana\",\"angani\":{\"sesa\":[\"the dispatch table is first-match; the scheduler lane owes it vipratiṣedhe paraṁ kāryam\"]}}"
        , "{\"kriya\":\"sabha.sthiti\"}"
        , "not json at all"
        ]
  ref <- newIORef (0 :: Int)
  let step s line = do
        (s', u) <- answer s line
        putStrLn ""
        putStrLn ("→ " ++ line)
        mapM_ (putStrLn . ("  " ++)) (uttaraLines u)
        -- THE INVARIANT, checked structurally.
        --
        -- The first draft of this check scanned the rendered bytes for
        -- "true" and "false" and fired three times on this very script --
        -- every time an answer QUOTED the boolean it had just refused.
        -- The grep could not tell mention from use, which is the same
        -- collapse the machine exists to refuse, committed by its own
        -- test.  It is recorded here rather than quietly deleted.
        --
        -- No-boolean is not a property to be grepped for at all: `J` has
        -- four constructors and none of them is a boolean, so a boolean
        -- cannot be rendered.  That is a type, not a scan.  What is left
        -- for a runtime check is the part the types do not carry: that
        -- each answer is one of the two roads and that each road arrives
        -- carrying what its road obliges it to carry.
        case uttaraJ u of
          JObj kvs -> case lookup "uttara" kvs of
            Just (JStr r) | r == "samkramana" || r == "dosalekha" -> pure ()
            _ -> modifyIORef ref (+1) >> putStrLn "  !! neither road"
          _ -> modifyIORef ref (+1) >> putStrLn "  !! the answer is not an object"
        case u of
          Samkramana _ t carried cost _
            | null carried || null cost || null (tuWitness t) ->
                modifyIORef ref (+1) >> putStrLn "  !! a transport with nothing carried, no witness, or no vyaya stated"
          Dosalekha _ hetu lost _ _
            | null hetu || null lost ->
                modifyIORef ref (+1) >> putStrLn "  !! a defect entry naming no loss"
          _ -> pure ()
        appendLekha fp (sTurn s') line u
        pure s'
  final <- foldM step emptySabha script
  -- two exact checks, so this is not merely a shape test
  let pell = case B.cakravala 61 of
               Right tr -> let t = last tr in (B.tA t, B.tB t)
               Left _   -> (0, 0)
  putStrLn ""
  putStrLn ("cakravāla D=61 → " ++ show pell
            ++ (if pell == (1766319049, 226153980)
                  then "  (Bhāskara II's own value, 1150)"
                  else "  !! WRONG"))
  let aN = P.pratyahara "a" "ṇ"
  putStrLn ("aṆ → " ++ unwords aN
            ++ (if aN == ["a","i","u"] then "  (the traditional value)" else "  !! WRONG"))
  bad <- readIORef ref
  putStrLn ("turns: " ++ show (sTurn final)
            ++ "   defect log: " ++ show (length (sDosa final))
            ++ "   remainders: " ++ show (length (sSesa final))
            ++ "   contract violations: " ++ show bad)
  if bad == 0 && pell == (1766319049, 226153980) && aN == ["a","i","u"]
    then exitSuccess else exitFailure

