-- The one process.  See Server.
--
--     sh interactive/run-yantra.sh            -- the scripted session, checked
--     sh interactive/run-yantra.sh --wire     -- JSON lines on stdin/stdout
--
-- TWO ORGANS, ONE FILE.  The yantra files its defects into the doṣa-lekha
-- over that organ's own `write`-on-stdin interface, as a separate process,
-- and Server.hs says why: reaching past a lane's published surface to get at
-- its functions is how two lanes come to fail as one.  That discipline is
-- about the INTERFACE, not about the inode, so it survives the two mains
-- being linked into one image and selected by the name the image was invoked
-- under.  `dosalekha` is a link to this binary; `readProcessWithExitCode bin
-- ["write"]` still forks, still writes on stdin, still reads an exit status
-- back, and DefectRecord's internals are still unreachable from Server.
--
-- The reason to want it is bin/: the shipped tool is ONE file to copy, and a
-- second executable there is a second thing to keep in step with the first.
-- Selection is by argv[0] and defaults to the yantra, so every existing
-- caller — run-yantra.sh builds this to `$OUT/yantra` — is unaffected.
module Main (main) where

import System.Environment (getProgName)

import qualified DefectRecord (main)
import Server (yantraMain)

main :: IO ()
main = do
  self <- getProgName
  case self of
    "dosalekha" -> DefectRecord.main
    _           -> yantraMain
