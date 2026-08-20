-- runghc -imachine machine/PramanyaRun.hs
-- Graded against REAL claims from this repository, including mine today.
import Pramanya
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, utf8)
import qualified Data.Map.Strict as M
import Data.List (sortOn)

claims :: [Claim]
claims =
  [ Claim "apoha-isProp"
      "An exclusion is proposition-valued, on both readings of apoha."
      Pratyaksa Siddha Nothing [] Nothing

  , -- RAISED Sruta -> Anvista, 2026-08-20, by running the search.
    -- It returned more than corroboration: apoha is the topic of CHAPTER 5
    -- of the Pramanasamuccayavrtti, and the standard formulation is that
    -- "cow" denotes not-a-non-cow -- so the DviApoha reading modelled in
    -- the Agda as a defensive alternative IS the standard one.
    Claim "dignaga-apoha"
      "Verbal meaning is anyapoha, exclusion-of-the-other: 'cow' denotes \
      \not-a-non-cow, not a positive universal.  Pramanasamuccaya(vrtti) ch. 5."
      Sabda Anvista
      (Just (Source "Dignaga" "search 2026-08-20; located Ole Holten Pind, Dignaga's Philosophy of Language: Pramanasamuccayavrtti on anyapoha (OeAW), plus secondary encyclopedia entries" "Pramanasamuccaya(vrtti), ch. 5" "c. 480-540"))
      [] Nothing

  , Claim "apoha-forces-deflation"
      "The Bauddha does not assume the deflation of anekanta; apoha derives it."
      Anumana Siddha Nothing ["apoha-isProp", "dignaga-apoha"] Nothing

  , Claim "book-is-15pct"
      "The book is 15% of this corpus: 120 in a chapter, 655 apparatus."
      Pratyaksa Siddha Nothing [] Nothing

  , Claim "book-is-15pct-means-neglect"
      "That ratio measures the book being neglected for the apparatus."
      Anumana Anumita Nothing ["book-is-15pct"] Nothing

  , -- The claim I made OUT LOUD and that was FALSE.  Kept in the sample
    -- permanently: the fitness gate that would have caught it did not
    -- exist when I said it.
    Claim "kerala-chapter-empty"
      "Chapter 10 (Kerala) has one entry; the Madhava material is not written."
      Anupalabdhi Sruta Nothing [] Nothing

  , -- RAISED Sruta -> Anvista.  The search named the technique:
    -- ANTYA-SAMSKARA, end-correction, and gave the figure -- pi to 11
    -- decimals from 21 terms.  The stream that first carried this says in
    -- its own header "from recall, no web", which is exactly Sruta.
    Claim "madhava-correction-terms"
      "Madhava gives the arctan/pi series WITH an end-correction, \
      \antya-samskara, accelerating a series that is otherwise useless: \
      \pi to 11 decimals (3.14159265359) from 21 terms.  That is the part \
      \the European restatement did not carry."
      Sabda Anvista
      (Just (Source "Madhava of Sangamagrama (c. 1350-1425); proofs in Jyesthadeva, Yuktibhasa, in Malayalam" "search 2026-08-20; corroborated across secondary sources, no primary text read" "Yuktibhasa" "c. 1530"))
      [] Nothing

  , Claim "kerala-priority-row"
      "Ledger row: Gregory (1671) / Leibniz (1673) series -> Madhava (~1400)."
      Anumana Siddha Nothing ["madhava-correction-terms"] Nothing

  , Claim "ledger-fires"
      "The displacing-name check fires on 16 live misattributions in this corpus."
      Pratyaksa Siddha Nothing [] Nothing

  , Claim "no-transmission-document"
      "No document showing transfer of the Kerala series to Europe has been produced."
      Anupalabdhi Anvista Nothing []
      (Just "secondary literature as summarised in the corpus stream: \
            \Almeida-Joseph 2007 and C.K. Raju 2007 argue the case; \
            \mainstream position is independent rediscovery")

  , -- The environment fact, and it is the ceiling on everything above.
    Claim "drsta-unreachable-here"
      "No primary text can be consulted on this container: gateway answers \
      \403 to CONNECT for gretil.sub.uni-goettingen.de:443."
      Pratyaksa Siddha Nothing [] Nothing

  , Claim "self-resting"
      "This corpus is reliable because its own audits say so."
      Anumana Siddha Nothing ["self-resting"] Nothing
  ]

main :: IO ()
main = do
  setLocaleEncoding utf8; setFileSystemEncoding utf8; hSetEncoding stdout utf8
  let e = env claims
  putStrLn "=== PRAMANYA: what grade has each claim actually earned? ==="
  putStrLn "paratah-pramanya: validity is conferred from outside.  Route is"
  putStrLn "TYPED and unranked (Nyayasutra 1.1.3); only the status of THIS"
  putStrLn "INSTANCE is ranked, and the grade is the MINIMUM over everything"
  putStrLn "the claim rests on.  No downstream rigour raises it."
  putStrLn ""
  putStrLn "CEILING ON THIS CONTAINER: Drsta is unreachable -- the gateway"
  putStrLn "answers 403 to CONNECT for the text archives.  A claim resting on"
  putStrLn "a text cannot exceed Anvista here, by policy, not by effort."
  putStrLn ""
  mapM_ (\c -> mapM_ putStrLn (verdict e c) >> putStrLn "") claims
  putStrLn "=== summary ==="
  let gs = [ (cId c, grade e (cId c)) | c <- claims ]
  mapM_ (\(i, g) -> putStrLn ("  " ++ show g ++ "\t" ++ i)) (sortOn snd gs)
  putStrLn ""
  mapM_ (\s -> putStrLn ("  " ++ show s ++ "\t"
                         ++ show (length [ () | (_, g) <- gs, g == s ])))
        [minBound .. maxBound :: Status]
