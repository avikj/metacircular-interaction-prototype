# #874: a host cannot deliver an inhabitant of an empty type either
import Base

def forge_empty() -> IO(Empty):
  import "./issue_874.js"

def main() -> IO(Unit):
  do IO<Unit>:
    e : Empty <- forge_empty()
    IO.print("unreachable")
#|Error:
#|- expected : a transportable payload (a foreign definition delivers data: words, strings, constructors of such, a handle, a kind, a host function answering data, or an equation the checker closes itself; never a path with distinct ends, a universe path or an empty type)
#|- observed : Empty
#|Location: forge_empty
#|3 |
#|4>| def forge_empty() -> IO(Empty):
#|5 |   import "./issue_874.js"
#|exit 1
