-- runghc -imachine machine/PramanaRun.hs
-- Graded against REAL claims made in this repository, including mine.
import Pramanya
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, utf8)
import qualified Data.Map.Strict as M
import Data.List (sortOn)

claims :: [Claim]
claims =
  [ -- ── the Agda result I committed today ────────────────────────────
    Claim "apoha-isProp"
      "An exclusion is proposition-valued, on both readings of apoha."
      Pratyaksa Siddha Nothing [] Nothing
      -- Pratyaksa because the checker RAN here; the term is the object.

  , Claim "dignaga-apoha"
      "Dignaga's conceptual content is anya-apoha, exclusion-of-the-other."
      Sabda Sruta (Just (Source "Dignaga" "Pramanasamuccaya" "c. 480-540")) [] Nothing
      -- Sruta: cited, NOT consulted.  No route to the text on this container.

  , Claim "apoha-forces-deflation"
      "The Bauddha does not assume the deflation of anekanta; apoha derives it."
      Anumana Siddha Nothing ["apoha-isProp", "dignaga-apoha"] Nothing
      -- The INFERENCE is checked.  What it is an inference ABOUT is not.

  , -- ── the measurement I published in CLAUDE.md's head ──────────────
    Claim "book-is-15pct"
      "The book is 15% of this corpus: 120 in a chapter, 655 apparatus."
      Pratyaksa Siddha Nothing [] Nothing

  , Claim "book-is-15pct-means-neglect"
      "That ratio measures the book being neglected for the apparatus."
      Anumana Anumita Nothing ["book-is-15pct"] Nothing

  , -- ── the claim I made and that was FALSE ──────────────────────────
    Claim "kerala-chapter-empty"
      "Chapter 10 (Kerala) has one entry; the Madhava material is not written."
      Anupalabdhi Sruta Nothing [] Nothing
      -- cLooking = Nothing.  The index read .agda and .hs and never read
      -- notes/.  The gate below is what should have caught this before I
      -- said it out loud, and did not exist yet.

  , -- ── the Kerala mathematics, from the stream ──────────────────────
    Claim "madhava-correction-terms"
      "Madhava gives the series WITH end-corrections; that is the part the \
      \European restatement did not carry."
      Sabda Sruta (Just (Source "Jyesthadeva" "Yuktibhasa" "c. 1530")) [] Nothing
      -- The stream that found this says, in its own header: "from recall,
      -- no web."  So: Sruta.  Not Drsta.  Nobody opened the Yuktibhasa.

  , Claim "kerala-priority-row"
      "Ledger row: Gregory/Leibniz series -> Madhava (~1400), gap ~270 yrs."
      Anumana Siddha Nothing ["madhava-correction-terms"] Nothing
      -- The row is machine-checked and fires correctly.  Its CONTENT is
      -- only as good as the unconsulted source underneath it.

  , -- ── the priority ledger's own mechanism ──────────────────────────
    Claim "ledger-fires"
      "The displacing-name check fires on 16 live misattributions in this corpus."
      Pratyaksa Siddha Nothing [] Nothing

  , -- ── an absence stated WITH its looking ───────────────────────────
    Claim "no-transmission-document"
      "No document showing transfer of the Kerala series to Europe has been produced."
      Anupalabdhi Sruta Nothing []
      (Just "the secondary literature as summarised in the stream; \
            \Almeida-Joseph 2007 and C.K. Raju 2007 argue the case, \
            \mainstream holds independent rediscovery")

  , -- ── a claim resting on itself ────────────────────────────────────
    Claim "self-resting"
      "This corpus is reliable because its own audits say so."
      Anumana Siddha Nothing ["self-resting"] Nothing
  ]

main :: IO ()
main = do
  setLocaleEncoding utf8; setFileSystemEncoding utf8; hSetEncoding stdout utf8
  let e = env claims
  putStrLn "=== PRAMANA: what grade has each claim actually earned? ==="
  putStrLn "Route is TYPED and unranked (Nyayasutra 1.1.3).  Only the status of"
  putStrLn "THIS INSTANCE is ranked, and the grade is the MINIMUM over everything"
  putStrLn "the claim rests on.  No downstream rigour raises it."
  putStrLn ""
  mapM_ (\c -> mapM_ putStrLn (verdict e c) >> putStrLn "") claims
  putStrLn "=== summary ==="
  let gs = [ (cId c, grade e (cId c)) | c <- claims ]
  mapM_ (\(i, g) -> putStrLn ("  " ++ show g ++ "\t" ++ i)) (sortOn snd gs)
  putStrLn ""
  putStrLn ("  Siddha (checked here)      : " ++ show (length [()|(_,g)<-gs,g==Siddha]))
  putStrLn ("  Drsta  (source consulted)  : " ++ show (length [()|(_,g)<-gs,g==Drsta]))
  putStrLn ("  Anumita(inherited)         : " ++ show (length [()|(_,g)<-gs,g==Anumita]))
  putStrLn ("  Sruta  (cited, not read)   : " ++ show (length [()|(_,g)<-gs,g==Sruta]))
  putStrLn ("  Asiddha(nothing behind it) : " ++ show (length [()|(_,g)<-gs,g==Asiddha]))
