# fibre/src/Fibre/FibreElement.agda, in Bend: THE LAW. Bind the output and the fibre
# is a contractible singleton, so A â‰ FibreElement f by univalence; contracting the
# second component IS the content.
import Prelude

type FibreElement(A: Set, B: Set, f: A -> B):
  case @fibreCarry:
    base: A
    carried: B
    witness: Path(B, f(base), carried)

def fibre(A: Set, B: Set, f: A -> B, a: A) -> Set:
  singl(B, f(a))
def fibre_isContr(A: Set, B: Set, f: A -> B, a: A) -> isContr(fibre(A, B, f, a)):
  isContrSingl(B, f(a))

def descend(A: Set, B: Set, f: A -> B, a: A) -> FibreElement(A, B, f):
  @fibreCarry{a, f(a), <_> f(a)}
def ascend(A: Set, B: Set, f: A -> B, c: FibreElement(A, B, f)) -> A:
  match c: case @fibreCarry{a, b, w}: a

def ascend_descend(A: Set, B: Set, f: A -> B, a: A) -> Path(A, ascend(A, B, f, descend(A, B, f, a)), a):
  <_> a
def descend_ascend(A: Set, B: Set, f: A -> B, c: FibreElement(A, B, f)) -> Path(FibreElement(A, B, f), descend(A, B, f, ascend(A, B, f, c)), c):
  match c:
    case @fibreCarry{a, b, w}:
      <i> @fibreCarry{a, w @ i, <j> w @ iand(i, j)}

def FibreElementEquiv(A: Set, B: Set, f: A -> B) -> Equiv(A, FibreElement(A, B, f)):
  isoToEquiv(A, FibreElement(A, B, f), lambda a. descend(A, B, f, a), lambda c. ascend(A, B, f, c),
             lambda c. descend_ascend(A, B, f, c), lambda a. ascend_descend(A, B, f, a))

# ...and therefore, by univalence, equal to it
def FibreElementPath(A: Set, B: Set, f: A -> B) -> Path(Set, A, FibreElement(A, B, f)):
  ua(A, FibreElement(A, B, f), lambda a. descend(A, B, f, a), lambda c. ascend(A, B, f, c),
     lambda a. ascend_descend(A, B, f, a), lambda c. descend_ascend(A, B, f, c))

def fibreElementTransport(A: Set, B: Set, f: A -> B, a: A) -> FibreElement(A, B, f):
  coe(lambda i. FibreElementPath(A, B, f) @ i, i0, i1, a)

# the Î² rule for ua: transport along the univalent equality IS descend
def fibreElementTransportDescend(A: Set, B: Set, f: A -> B, a: A) -> Path(FibreElement(A, B, f), fibreElementTransport(A, B, f, a), descend(A, B, f, a)):
  <_> descend(A, B, f, a)

# an endomorphism of the base transports to the carrier; the square commutes on the nose
def phi_fibreElement(A: Set, B: Set, f: A -> B, phi: A -> A, c: FibreElement(A, B, f)) -> FibreElement(A, B, f):
  descend(A, B, f, phi(ascend(A, B, f, c)))
def phi_square(A: Set, B: Set, f: A -> B, phi: A -> A, a: A) -> Path(FibreElement(A, B, f), phi_fibreElement(A, B, f, phi, descend(A, B, f, a)), descend(A, B, f, phi(a))):
  <_> descend(A, B, f, phi(a))
def phi_ascend(A: Set, B: Set, f: A -> B, phi: A -> A, c: FibreElement(A, B, f)) -> Path(A, ascend(A, B, f, phi_fibreElement(A, B, f, phi, c)), phi(ascend(A, B, f, c))):
  <_> phi(ascend(A, B, f, c))

def fibreElementDemo() -> Nat:
  ascend(Nat, Nat, lambda n. 1n + n, fibreElementTransport(Nat, Nat, lambda n. 1n + n, 2n))
