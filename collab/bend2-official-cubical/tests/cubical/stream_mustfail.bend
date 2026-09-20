# a self-call under the delay but eliminated there is not guarded: the
# observation would loop
import Base

type Box is Type:
  bx{f: Unit -> Nat}

def unbox(b: Box) -> Nat:
  match b:
    case bx{f}:
      f(Unit{})

def loop() -> Box:
  bx{_ => unbox(loop())}

#|Error:
#|- expected : a decreasing self-call (arguments are read left to right: each passed unchanged until one shrinks)
#|- observed : loop
#|Context:
#|- _ : Unit
#|Location: loop
#|13 | def loop() -> Box:
#|14>|   bx{_ => unbox(loop())}
#|15 | 
#|exit 1
