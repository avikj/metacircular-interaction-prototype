# Suspension: two points and a path for every point of A. S1 = Susp(Bool).
type Susp(A: Set):
  case @north:
  case @south:
  path @merid(a: A): Path(Susp(A), @north, @south)

def merid0(A: Set, a: A) -> Path(Susp(A), @merid{a} @ i0, @north):
  <_> @north

def suspRec(A: Set, B: Set, n: B, s: B, m: A -> Path(B, n, s), x: Susp(A)) -> B:
  hrec(x) { @north: n ; @south: s ; @merid: m }

def suspRec_merid(A: Set, B: Set, n: B, s: B, m: A -> Path(B, n, s), a: A) -> Path(Path(B, n, s), <i> suspRec(A, B, n, s, m, @merid{a} @ i), m(a)):
  <_> m(a)

# transport across a line of suspensions pushes into the constructors:
# along ua(not) on the parameter, merid(True) goes to merid(False)
def neg(b: Bool) -> Bool:
  if b:
    False
  else:
    True

def negInv(b: Bool) -> Path(Bool, neg(neg(b)), b):
  if b:
    <_> True
  else:
    <_> False

def notPath() -> Path(Set, Bool, Bool):
  ua(Bool, Bool, lambda x. neg(x), lambda x. neg(x), lambda x. negInv(x), lambda x. negInv(x))

def suspLine() -> Interval -> Set:
  lambda i. Susp(notPath() @ i)

def transported() -> Path(Susp(Bool), coe(lambda i. suspLine()(i), i0, i1, @merid{True} @ i0), @north):
  <_> @north

def main() -> Nat:
  0n
