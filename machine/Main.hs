-- The one process.  See Server.
--
--     sh machine/run-yantra.sh            -- the scripted session, checked
--     sh machine/run-yantra.sh --wire     -- JSON lines on stdin/stdout
module Main (main) where

import Server (yantraMain)

main :: IO ()
main = yantraMain
