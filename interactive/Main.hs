-- The one process.  See Server.
--
--     sh interactive/run-yantra.sh            -- the scripted session, checked
--     sh interactive/run-yantra.sh --wire     -- JSON lines on stdin/stdout
module Main (main) where

import Server (yantraMain)

main :: IO ()
main = yantraMain
