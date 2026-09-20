# #874 through polymorphism: a foreign definition polymorphic in its
# payload is fine to declare (it relays what it was given), but a call
# that instantiates the payload at a path is refused
import Base

def relay(-A: Type) -> IO(A):
  import "./issue_874.js"

def main() -> IO(Unit):
  do IO<Unit>:
    p : {Unit == F32 : Type} <- relay({Unit == F32 : Type})
    IO.print("unreachable")
#|Error:
#|- expected : a transportable payload at this foreign call (the host delivers data, never a path with distinct ends, a universe path or an empty type)
#|- observed : {Unit == F32 : Type}
#|Location: main
#|10 |   do IO<Unit>:
#|11>|     p : {Unit == F32 : Type} <- relay({Unit == F32 : Type})
#|12 |     IO.print("unreachable")
#|exit 1
