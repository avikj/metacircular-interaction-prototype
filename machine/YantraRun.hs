-- The one process.  See Yantra_TheOrgansAreOneMachineOnOneWire.
--
--     sh machine/run-yantra.sh            -- the scripted session, checked
--     sh machine/run-yantra.sh --wire     -- JSON lines on stdin/stdout
module Main (main) where

import Yantra_TheOrgansAreOneMachineOnOneWire (yantraMain)

main :: IO ()
main = yantraMain
