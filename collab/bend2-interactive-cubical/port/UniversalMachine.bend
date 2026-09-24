# One executable object joining the two universal constructions:
#
#   (1) initial derivation geometry (AdiBija/Vivarana), and
#   (2) forced lossless observation/residual (FibreElement/FibreCoalgebra).
#
# There is no "derive then install" protocol here. A lawful transformation is
# already a Step value; when the step is cubical identity it is literally a
# Path. Every receiver (meaning, cost, etc.) folds that same Derivation, while
# every observation re-presents the same state losslessly and continues.
import UniversalDerivation
import UniversalElucidator
import UniversalPresentation

type Machine(A: Set, a: A):
  case @machine:
    whole: FibreCoalgebra(A,a)

def machine(A: Set, a: A) -> Machine(A,a):
  @machine{presentPoint(A,a)}

# A cubical path is simultaneously executable identity and a one-edge member
# of the universal derivation geometry.
def pathMotion(A: Set, a: A, b: A, p: Path(A,a,b)) ->
  Derivation(A,PathStep(A),a,b):
  pathDerivation(A,a,b,p)

def pathLength(A: Set, a: A, b: A, p: Path(A,a,b)) -> Nat:
  derivationLengthReading(A,PathStep(A),a,b,pathMotion(A,a,b,p))

# Observation remains THE LAW: visible coordinate plus exact residual.
def observeMachine(A: Set, a: A, B: Set, f: A -> B) -> FibreElement(A,B,f):
  presentMap(A,B,f,a)

def observeMachineBeta(A: Set, a: A, B: Set, f: A -> B) ->
  Path(B, observedValue(A,B,f,observeMachine(A,a,B,f)), f(a)):
  <_> f(a)

def main() -> Nat:
  pathLength(Nat,2n,2n,<_> 2n)
