-- The one process.  See Server.
--
--     sh interactive/run-machine.sh            -- the scripted session, checked
--     sh interactive/run-machine.sh --wire     -- JSON lines on stdin/stdout
module Main (main) where

import Server (machineMain)

main :: IO ()
main = machineMain
