# Grammar-independent elucidator: a reading is a fold of the same initial
# derivation object. This is the executable Bend counterpart of AdiBija/Vivarana
# without the old toy Tm restriction.
import UniversalDerivation

# A lens is simply a receiver whose Motion is constant in the endpoints.
type Lens(A: Set, Step: A -> A -> Set, R: Set):
  case @lens:
    zero: R
    step: all a: A. all b: A. Step(a,b) -> R -> R

def read(A: Set, Step: A -> A -> Set, R: Set,
         lens: Lens(A,Step,R),
         x: A, z: A, d: Derivation(A,Step,x,z)) -> R:
  match lens:
    case @lens{zero, step}:
      match d:
        case @done{ez}: zero
        case @then{y, motion, rest}:
          step(x,y,motion,read(A,Step,R,lens,y,z,rest))

# Cost is not a second execution mechanism; it is a lens/receiver of the same
# derivation object.
def lengthLens(A: Set, Step: A -> A -> Set) -> Lens(A,Step,Nat):
  @lens{0n, lambda a. lambda b. lambda s. lambda n. 1n + n}

def derivationLengthReading(A: Set, Step: A -> A -> Set,
             x: A, z: A, d: Derivation(A,Step,x,z)) -> Nat:
  read(A,Step,Nat,lengthLens(A,Step),x,z,d)
