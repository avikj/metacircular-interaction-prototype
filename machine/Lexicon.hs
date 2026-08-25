-- Lexicon — the wire's vocabulary in two registers, Greek by default.
--
-- WHY THIS EXISTS.  Every name this server puts on the wire was Sanskrit,
-- and the Sanskrit is not decoration: the distinctions it draws are the
-- ones the mathematics actually makes, and English does not have words
-- for most of them.  English flattens.  It has one word "proof" where the
-- work needs four, one word "reason" where the work needs cause,
-- criterion, testimony and route.
--
-- Greek does not flatten, and a mathematician already reads it.  So the
-- default register is GREEK, the Sanskrit is one field away, and English
-- is used only for the gloss.  The maps below are not translations of
-- convenience; each one is a term the Greek tradition coined for exactly
-- the distinction the Sanskrit term coins, and where no such term exists
-- the entry says so rather than inventing one.
--
-- The three that carry the most weight:
--
--   avaktavya  ->  ARRHETON (ἄρρητον).  The fourth position of the
--     saptabhaṅgī: not unknown, not undefined, not false — INEXPRESSIBLE,
--     because two standpoints asserted at once form no single utterance.
--     ἄρρητον is the Pythagoreans' own word for the incommensurable: the
--     ratio that exists and cannot be said.  Same concept, two
--     civilisations, no borrowing in either direction.
--
--   doṣa-lekha ->  ELENCHOS (ἔλεγχος).  A written defect that exposes
--     what a collapse would destroy.  ἔλεγχος is the Socratic
--     cross-examination — refutation as the productive act, not the
--     failure.  And `dosa.lekha` -> `elenchos.graphe`: γραφή in Athenian
--     law is literally the WRITTEN indictment, as against the spoken one.
--
--   pramāṇa    ->  KRITERION (κριτήριον).  The means by which a thing is
--     known, and the question of which means are valid.  περὶ κριτηρίου
--     is the title of the argument Sextus spends a book on.  Nyāya spends
--     a school on it.  They are asking one question.
--
-- INDIAN ROOTS ARE NOT ERASED BY THIS.  The Sanskrit register is live —
-- send `"register":"sanskrit"` — and every answer's testimony field still
-- names the text and the date the mathematics comes from: Āryabhaṭa 499
-- for the pulverizer, Brahmagupta 628 for the composition law, Pāṇini for
-- the interval notation, Akalaṅka and Umāsvāti for the sevenfold
-- position.  The Greek is a second door onto the same room, opened
-- because more people can find it.  It is not the room.

module Lexicon
  ( Register(..)
  , registerOf
  , Entry(..)
  , entries
  , toGreek
  , toSanskrit
  , lexiconJ
  ) where

import Json (J(..))

data Register = Greek | Sanskrit deriving (Eq, Show)

-- Read the register off a request.  Absent or unrecognised -> Greek.
registerOf :: J -> Register
registerOf (JObj kvs) = case lookup "register" kvs of
  Just (JStr "sanskrit") -> Sanskrit
  Just (JStr "samskrta") -> Sanskrit
  _                      -> Greek
registerOf _ = Greek

-- sanskrit, greek (romanised), and the English gloss — the gloss is for
-- the reader, never for the wire.
data Entry = Entry
  { eSanskrit :: String
  , eGreek    :: String
  , eGloss    :: String
  } deriving (Eq, Show)

entries :: [Entry]
entries =
  -- ── the two answers.  There is no third and there is no boolean. ──
  [ Entry "samkramana" "diabasis"
      "a crossing that arrives carrying what it set out with; \948\953\940\946\945\963\953\962"
  , Entry "dosalekha" "elenchos"
      "a written refutation: the defect, and what a collapse would destroy; \7956\955\949\947\967\959\962"

  -- ── the shape of every answer ──
  , Entry "uttara"   "apokrisis"    "the reply itself; \7936\960\972\954\961\953\963\953\962"
  , Entry "kriya"    "praxis"       "the operation performed; \960\961\8118\958\953\962"
  , Entry "angani"   "dedomena"     "the givens the operation was handed; Euclid's \916\949\948\959\956\941\957\945"
  , Entry "nirnaya"  "krisis"       "the judgement reached; \954\961\943\963\953\962"
  , Entry "pramanya" "kriterion"    "by what means it is known; \954\961\953\964\942\961\953\959\957"
  , Entry "marga"    "hodos"        "the road by which it was reached; \8001\948\972\962, whence \956\941\952\959\948\959\962"
  , Entry "saksin"   "martys"       "the witness standing under it; \956\940\961\964\965\962"
  , Entry "pramana"  "martyria"     "the testimony: text, author, date; \956\945\961\964\965\961\943\945"
  , Entry "tulyata"  "isotes"       "the identification the transport rides on; \7984\963\972\964\951\962"
  , Entry "vahita"   "phoroumenon"  "what was actually carried across; \966\949\961\972\956\949\957\959\957"
  , Entry "vyaya"    "apoleimma"    "what did NOT travel and was left behind; \7936\960\972\955\949\953\956\956\945"
  , Entry "nasta"    "phthora"      "what a single verdict would destroy; \966\952\959\961\940"
  , Entry "sesa"     "hypoleimma"   "the remainder, handed forward; \8017\960\972\955\949\953\956\956\945"
  , Entry "hetu"     "aitia"        "the reason transport was impossible; \945\7984\964\943\945"
  , Entry "sthana"   "thesis"       "the position occupied; \952\941\963\953\962"
  , Entry "artha"    "semainomenon" "what the position means; the Stoic \963\951\956\945\953\957\972\956\949\957\959\957"
  , Entry "prasna-id" "erotema-id"  "the caller's tag for this question; \7952\961\974\964\951\956\945"

  -- ── standpoints ──
  , Entry "naya"     "tropos"       "one standpoint, true from where it stands; Sextus's \964\961\972\960\959\962"
  , Entry "nayah"    "tropoi"       "several standpoints"
  , Entry "nama"     "onoma"        "its name; \8004\957\959\956\945"
  , Entry "vacana"   "lexis"        "what the witness says; \955\941\958\953\962"
  , Entry "mula"     "pege"         "the document it says it from; \960\951\947\942, a spring"
  , Entry "saksinah" "martyres"     "the witnesses"
  , Entry "karta"    "poietes"      "who recorded it; \960\959\953\951\964\942\962"
  , Entry "kala"     "chronos"      "when; \967\961\972\957\959\962"
  , Entry "yogyata"  "epitedeiotes" "was the looking FIT to find what it sought; \7952\960\953\964\951\948\949\953\972\964\951\962"
  , Entry "yogya"    "epitedeios"   "fit"
  , Entry "ayogya"   "anepitedeios" "unfit"
  , Entry "yogyata-hetu" "epitedeiotes-aitia" "the account of the search; a fitness claim without one is itself unfit"

  -- ── how several standpoints are put together ──
  , Entry "arpana"   "taxis"        "how they are arranged for judgement; \964\940\958\953\962"
  , Entry "saha"     "hama"         "asserted AT ONCE; \7973\956\945"
  , Entry "krama"    "ephexes"      "asserted IN SUCCESSION; \7952\966\949\958\8134\962"
  , Entry "sadhaka"  "kataphasis"   "the affirming side; \954\945\964\940\966\945\963\953\962"
  , Entry "badhaka"  "apophasis"    "the denying side; \7936\960\972\966\945\963\953\962"
  , Entry "sadhaka-saksin" "kataphasis-martys" "the affirming side's witness"
  , Entry "badhaka-saksin" "apophasis-martys"  "the denying side's witness"
  , Entry "stara"    "bathmos"      "how many generations to run out; \946\945\952\956\972\962, a step"
  , Entry "dhara"    "rhoe"         "the stream born from a residue; \8165\959\942"

  -- ── the sevenfold position ──
  , Entry "syad-asti" "pei-esti"
      "in a certain respect it IS; \960\8135 \7956\963\964\953"
  , Entry "syad-nasti" "pei-ouk-esti"
      "in a certain respect it IS NOT"
  , Entry "syad-asti-nasti" "pei-esti-ouk-esti"
      "in succession, both — and no contradiction, because the respects differ"
  , Entry "syad-avaktavyam" "pei-arrheton"
      "INEXPRESSIBLE: asserted at once, no single utterance carries it. \7940\961\961\951\964\959\957 is the Pythagoreans' word for the incommensurable"
  , Entry "syad-asti-avaktavyam" "pei-esti-arrheton"
      "is, and is inexpressible"
  , Entry "syad-nasti-avaktavyam" "pei-ouk-esti-arrheton"
      "is not, and is inexpressible"
  , Entry "syad-asti-nasti-avaktavyam" "pei-esti-ouk-esti-arrheton"
      "both in succession, and inexpressible at once"
  , Entry "apratipatti" "aporia"
      "NO predication was made: no subject to predicate of. \7936\960\959\961\943\945 — no way through"

  -- ── kinds of witness ──
  , Entry "pratyaksa" "autopsia"    "seen directly, here, in this process; \945\8016\964\959\968\943\945"
  , Entry "ganita"    "logismos"    "computed here and checked; \955\959\947\953\963\956\972\962"
  , Entry "likhita"   "gegrammenon" "written, and emitted from the thing it describes"
  , Entry "nihsesa"   "anelleipes"  "exhaustive: every case run, none left out; \7936\957\949\955\955\953\960\942\962"
  , Entry "saksi-prakara" "martys-tropos" "which kind of witness this is"
  , Entry "ganana"    "arithmos"    "how many cases; \7936\961\953\952\956\972\962"

  -- ── proof ──
  , Entry "vama"      "aristeron"   "the left-hand side; \7936\961\953\963\964\949\961\972\957"
  , Entry "daksina"   "dexion"      "the right-hand side; \948\949\958\953\972\957"
  , Entry "sadhya"    "zetoumenon"  "what is to be shown; \950\951\964\959\973\956\949\957\959\957"
  , Entry "samikarana" "exisosis"   "the equation; \7952\958\943\963\969\963\953\962"
  , Entry "akara"     "schema"      "the SHAPE that closed the proof; \963\967\8134\956\945"
  , Entry "agda-ahvana" "agda-kleseis" "how many fresh kernel calls were spent"
  , Entry "ahvanani"  "kleseis"     "how many fresh kernel calls were spent; \954\955\942\963\949\953\962"

  -- ── the operations ──
  , Entry "yantra.kriyah" "organon.praxeis"
      "what this instrument can be asked; Aristotle's \8004\961\947\945\957\959\957"
  , Entry "yantra.kosa" "organon.lexikon"
      "the wire's own dictionary, both registers, with glosses; \955\949\958\953\954\972\957"
  , Entry "yantra.sthiti" "organon.katastasis"
      "the whole session state; \954\945\964\940\963\964\945\963\953\962"
  , Entry "yantra.srutam" "organon.akousma"
      "what has been heard on this wire; \7940\954\959\965\963\956\945, the Pythagorean things-heard"
  , Entry "naya.sthapana" "tropos.thesis"
      "install a standpoint with its witnesses"
  , Entry "naya.suchi"    "tropos.katalogos"
      "every standpoint held; \954\945\964\940\955\959\947\959\962"
  , Entry "naya.samasa"   "tropos.synkrisis"
      "may these be collapsed into one verdict; \963\973\947\954\961\953\963\953\962, a bringing-together"
  , Entry "kosha.punaravrtti" "thesauros.anakyklesis"
      "journal the store and replay it; \952\951\963\945\965\961\972\962 + \7936\957\945\954\973\954\955\951\963\953\962"
  , Entry "nirnaya.saptabhangi" "krisis.heptas"
      "ask all three verdict organs and hand the three answers to the scheduler; \7953\960\964\940\962"
  , Entry "saptabhangi.samkramana" "heptas.diabasis"
      "the equivalence that DOES hold between two of the three verdict types"
  , Entry "saptabhangi.nasti" "heptas.apophasis"
      "the equivalence that does NOT hold, with the collision computed"
  , Entry "garbha.dhara" "genesis"
      "run the fourth position forward: from a residue, the stream born from it; \947\941\957\949\963\953\962"
  , Entry "sadhana" "apodeixis"
      "emit a module for an equation and give it to the kernel; Aristotle's \7936\960\972\948\949\953\958\953\962"
  , Entry "kuttaka" "anthyphairesis"
      "\256ryabha\355a's pulverizer, 499 CE. \7936\957\952\965\966\945\943\961\949\963\953\962 is Euclid's reciprocal subtraction: the same descent, named twice"
  , Entry "vargaprakrti" "kyklos"
      "Brahmagupta's composition driven by the cakrav\257la, 628/1150 CE. \954\973\954\955\959\962 is the wheel the method is named for"
  , Entry "pratyahara" "diastema"
      "P\257\7751ini's interval over the ordered sound list. \948\953\940\963\964\951\956\945 is the Greek theorists' interval in an ordered series"
  , Entry "dosa.lekha" "elenchos.graphe"
      "write a defect yourself; \947\961\945\966\942 is the WRITTEN indictment, as against the spoken"
  , Entry "dosa.suchi" "elenchos.katalogos"
      "every defect written this session, in order"
  , Entry "dosa.pramanya" "elenchos.kriterion"
      "verify the defect log's chain from inside the session"
  , Entry "sesa.arpana" "hypoleimma.paradosis"
      "hand a remainder forward; \960\945\961\940\948\959\963\953\962, a handing-on"
  , Entry "sesa.suchi" "hypoleimma.katalogos"
      "the remainder queue"
  ]

sanskritToGreek :: [(String, String)]
sanskritToGreek = [ (eSanskrit e, eGreek e) | e <- entries ]

greekToSanskrit :: [(String, String)]
greekToSanskrit = [ (eGreek e, eSanskrit e) | e <- entries ]

-- Translate a whole answer.  Keys always; string VALUES only on an exact
-- whole-string match, so prose that happens to contain a term is left
-- alone.  Under `Sanskrit` this is the identity: the internal names are
-- already Sanskrit, and there is no second copy to drift.
toGreek :: Register -> J -> J
toGreek Sanskrit j = j
toGreek Greek    j = mapJ sanskritToGreek j

-- and the inverse, for the request coming in.
toSanskrit :: Register -> J -> J
toSanskrit Sanskrit j = j
toSanskrit Greek    j = mapJ greekToSanskrit j

-- THE DICTIONARY IS EXEMPT FROM ITS OWN TRANSLATION, and this is not a
-- special case bolted on: the payload under `kosa` is the table itself,
-- whose whole content is that each row holds BOTH registers side by side.
-- Translating it collapses the two columns into one and the answer says
-- `"greek":"diabasis","sanskrit":"diabasis"` — the exact collapse this
-- machine refuses everywhere else, committed by its own dictionary.
mapJ :: [(String, String)] -> J -> J
mapJ tbl = go
  where
    tr s = maybe s id (lookup s tbl)
    go (JStr s)   = JStr (tr s)
    go (JInt n)   = JInt n
    go (JArr xs)  = JArr (map go xs)
    go (JObj kvs) = JObj [ (tr k, if k == "kosa" then v else go v) | (k, v) <- kvs ]

-- The dictionary itself, as an answer.  A caller that does not know a
-- word can ask for the table rather than guess, and the table is emitted
-- from the same list the translation runs on, so it cannot drift.
lexiconJ :: J
lexiconJ = JArr
  [ JObj [ ("greek", JStr (eGreek e))
         , ("sanskrit", JStr (eSanskrit e))
         , ("gloss", JStr (eGloss e)) ]
  | e <- entries ]

