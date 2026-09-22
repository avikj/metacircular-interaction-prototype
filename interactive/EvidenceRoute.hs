-- प्रामाण्य — the five routes an answer arrives by, each with its witness.
--
-- Yantra imports and re-exports this module, and Aisthesis imports it
-- directly — the light dependency that lets the heartbeat (./jiva, runghc)
-- speak the same route vocabulary without interpreting the whole assembly
-- on every beat.
--
-- By what route is this answer a prama?  Nyya's question (Gautama,
-- Nyyastra 1.1.3, c. 2nd c. CE; Vtsyyana's Bhya c. 400): a means of
-- knowledge is distinguished by its CAUSAL ROUTE, not by how confident its
-- holder is.  §19 of the sūtra: प्रमाणं कारणमार्गेण भिद्यते, न विश्वासमात्रया ।
--
-- Five, and each carries its witness rather than a name alone.

module EvidenceRoute
  ( Pramanya(..)
  , pramanyaJ
  , pramanyaWitness
  ) where

import Wire (J(..))

data Pramanya
  = Pratyaksa String
    -- ^ the object is IN the answer.  Nothing is asserted about anything
    --   not shown; the reader checks by reading.
  | Nihsesa Int String
    -- ^ exhaustive over n cases, all of them run.  A finite exhaustive
    --   verification is proof, and the n is stated so that the
    --   domain of the claim is visible.
  | Ganita String
    -- ^ an exact integer identity, exhibited, computed in ℤ.  Not a
    --   measurement: there is no error term because there is no error.
  | Kernel String
    -- ^ agda typechecked an emitted module, with the two controls having
    --   been watched first (ProofGate.kernelStatus).
  | Ayogya String
    -- ^ NO route.  Legal only on a doa-lekha; Yantra's `mudra` turns a
    --   transport carrying it into a defect about itself.
  deriving (Eq, Show)

pramanyaJ :: Pramanya -> J
pramanyaJ p = case p of
  Pratyaksa w  -> JObj [("marga", JStr "pratyaksa"), ("saksin", JStr w)]
  Nihsesa n w  -> JObj [("marga", JStr "nihsesa"), ("ganana", JInt (fromIntegral n))
                       , ("saksin", JStr w)]
  Ganita w     -> JObj [("marga", JStr "ganita"), ("saksin", JStr w)]
  Kernel w     -> JObj [("marga", JStr "kernel"), ("saksin", JStr w)]
  Ayogya w     -> JObj [("marga", JStr "ayogya"), ("saksin", JStr w)]

pramanyaWitness :: Pramanya -> String
pramanyaWitness p = case p of
  Pratyaksa w -> w; Nihsesa _ w -> w; Ganita w -> w
  Kernel w -> w; Ayogya w -> w
