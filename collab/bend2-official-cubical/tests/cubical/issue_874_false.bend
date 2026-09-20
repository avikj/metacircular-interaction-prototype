# issue 874, the shape that matters most: a foreign definition promising
# an equation with distinct ends. An equation the checker can close by
# conversion ({0 == 0 : U32}) is honest data (the host's null is {==});
# one it cannot is a new axiom, and 0 == 1 would let J rewrite any
# P(0) into P(1) at runtime, a type confusion. Refused at the
# declaration, before any host code is consulted.
import Base

def forge_false() -> IO({0 == 1 : U32}):
  import "./issue_874.js"

def main() -> IO(Unit):
  do IO<Unit>:
    p : {0 == 1 : U32} <- forge_false()
    IO.print("unreachable")
#|Error:
#|- expected : a transportable payload (a foreign definition delivers data: words, strings, constructors of such, a handle, a kind, a host function answering data, or an equation the checker closes itself; never a path with distinct ends, a universe path or an empty type)
#|- observed : {0 == 1 : U32}
#|Location: forge_false
#| 8 |
#| 9>| def forge_false() -> IO({0 == 1 : U32}):
#|10 |   import "./issue_874.js"
#|exit 1
