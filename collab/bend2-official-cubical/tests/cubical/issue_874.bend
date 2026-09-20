# #874: a foreign definition delivers data, never evidence: a host
# function that claims to return a path between types is refused at its
# declaration, so no forged proof transports a value
import Base

def forge_eql() -> IO({Unit == F32 : Type}):
  import "./issue_874.js"

def main() -> IO(Unit):
  do IO<Unit>:
    p : {Unit == F32 : Type} <- forge_eql()
    x : F32 = %r@p : _; Unit{}
    IO.print(F32.show(F32.add(x, 2.5)))
#|Error:
#|- expected : a transportable payload (a foreign definition delivers data: words, strings, constructors of such, a handle, a kind, a host function answering data, or an equation the checker closes itself; never a path with distinct ends, a universe path or an empty type)
#|- observed : {Unit == F32 : Type}
#|Location: forge_eql
#|5 |
#|6>| def forge_eql() -> IO({Unit == F32 : Type}):
#|7 |   import "./issue_874.js"
#|exit 1
