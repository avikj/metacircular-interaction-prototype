# fibre/src/Fibre/Carrier.agda, in Bend: THE LAW. Bind the output and the fibre
# is a contractible singleton, so A ≃ Carrier f by univalence; contracting the
# second component IS the content.
import Prelude

type Carrier(A: Set, B: Set, f: A -> B):
  case @carry:
    base: A
    carried: B
    witness: Path(B, f(base), carried)

def fibre(A: Set, B: Set, f: A -> B, a: A) -> Set:
  singl(B, f(a))
def fibre_isContr(A: Set, B: Set, f: A -> B, a: A) -> isContr(fibre(A, B, f, a)):
  isContrSingl(B, f(a))

def descend(A: Set, B: Set, f: A -> B, a: A) -> Carrier(A, B, f):
  @carry{a, f(a), <_> f(a)}
def ascend(A: Set, B: Set, f: A -> B, c: Carrier(A, B, f)) -> A:
  match c: case @carry{a, b, w}: a

def ascend_descend(A: Set, B: Set, f: A -> B, a: A) -> Path(A, ascend(A, B, f, descend(A, B, f, a)), a):
  <_> a
def descend_ascend(A: Set, B: Set, f: A -> B, c: Carrier(A, B, f)) -> Path(Carrier(A, B, f), descend(A, B, f, ascend(A, B, f, c)), c):
  match c:
    case @carry{a, b, w}:
      <i> @carry{a, w @ i, <j> w @ iand(i, j)}

def CarrierEquiv(A: Set, B: Set, f: A -> B) -> Equiv(A, Carrier(A, B, f)):
  isoToEquiv(A, Carrier(A, B, f), lambda a. descend(A, B, f, a), lambda c. ascend(A, B, f, c),
             lambda c. descend_ascend(A, B, f, c), lambda a. ascend_descend(A, B, f, a))

# ...and therefore, by univalence, equal to it
def CarrierPath(A: Set, B: Set, f: A -> B) -> Path(Set, A, Carrier(A, B, f)):
  ua(A, Carrier(A, B, f), lambda a. descend(A, B, f, a), lambda c. ascend(A, B, f, c),
     lambda a. ascend_descend(A, B, f, a), lambda c. descend_ascend(A, B, f, c))

def carry_transport(A: Set, B: Set, f: A -> B, a: A) -> Carrier(A, B, f):
  coe(lambda i. CarrierPath(A, B, f) @ i, i0, i1, a)

# the β rule for ua: transport along the univalent equality IS descend
def carry_transport_descend(A: Set, B: Set, f: A -> B, a: A) -> Path(Carrier(A, B, f), carry_transport(A, B, f, a), descend(A, B, f, a)):
  <_> descend(A, B, f, a)

# an endomorphism of the base transports to the carrier; the square commutes on the nose
def phi_carrier(A: Set, B: Set, f: A -> B, phi: A -> A, c: Carrier(A, B, f)) -> Carrier(A, B, f):
  descend(A, B, f, phi(ascend(A, B, f, c)))
def phi_square(A: Set, B: Set, f: A -> B, phi: A -> A, a: A) -> Path(Carrier(A, B, f), phi_carrier(A, B, f, phi, descend(A, B, f, a)), descend(A, B, f, phi(a))):
  <_> descend(A, B, f, phi(a))
def phi_ascend(A: Set, B: Set, f: A -> B, phi: A -> A, c: Carrier(A, B, f)) -> Path(A, ascend(A, B, f, phi_carrier(A, B, f, phi, c)), phi(ascend(A, B, f, c))):
  <_> phi(ascend(A, B, f, c))

def main() -> Nat:
  ascend(Nat, Nat, lambda n. 1n + n, carry_transport(Nat, Nat, lambda n. 1n + n, 2n))
