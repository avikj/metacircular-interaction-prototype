# Spheres by iterated suspension: S0 = Bool, S(n+1) = Susp(Sn).
type Susp(A: Set):
  case @north:
  case @south:
  path @merid(a: A): Path(Susp(A), @north, @south)

def Sphere(n: Nat) -> Set:
  match n:
    case 0n: Bool
    case 1n + p: Susp(Sphere(p))

# S1 = Susp(Bool): the loop is merid(True) composed with the inverse of merid(False)
def s1loop() -> Path(Sphere(1n), @north, @north):
  <i> hcomp(Susp(Bool), i, <_> @north, <j> @merid{False} @ inot(j), @merid{True} @ i)

def s1loop_i0() -> Path(Sphere(1n), s1loop() @ i0, @north):
  <_> @north

# the suspension recursor, iterated: a map S2 -> B from a point and a family of loops
def suspRec(A: Set, B: Set, n: B, s: B, m: A -> Path(B, n, s), x: Susp(A)) -> B:
  hrec(x) { @north: n ; @south: s ; @merid: m }

def collapse(A: Set, B: Set, b: B, x: Susp(A)) -> B:
  suspRec(A, B, b, b, lambda a. <_> b, x)

def collapse_merid(A: Set, B: Set, b: B, a: A, i: Interval) -> Path(B, collapse(A, B, b, @merid{a} @ i), b):
  <_> b

def main() -> Nat:
  0n
