-- The one process.  See Server.
--
--     ./nalanda-gate            -- the scripted session, printed
--     ./nalanda-gate --wire     -- JSON lines on stdin/stdout
--
-- The entry point is `nalanda-gate`, at the repository root: it resolves the
-- published binary and runs it, so a clone is the whole install.  This file
-- is what that binary is.  `interactive/run-yantra.sh` still exists and is
-- the edit-run loop -- it compiles the working tree into $TMPDIR and turns
-- the result once, which is a different job from shipping.
--
-- TWO ORGANS, ONE FILE.  The machine files its defects into the dosa-lekha
-- over that organ's own `write`-on-stdin interface, as a separate process,
-- and Server.hs says why: reaching past a lane's published surface to get at
-- its functions is how two lanes come to fail as one.  That discipline is
-- about the INTERFACE, not about the inode, so it survives the two mains
-- being linked into one image and selected by the name the image was invoked
-- under.  `dosalekha` is a link to this binary; `readProcessWithExitCode bin
-- ["write"]` still forks, still writes on stdin, still reads an exit status
-- back, and DefectRecord's internals are still unreachable from Server.
--
-- The reason to want it is the release: the published tool is ONE file to
-- download, and a second executable there is a second thing to keep in step
-- with the first.  Selection is by argv[0] and defaults to the server, so
-- every existing caller is unaffected by the rename.
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
