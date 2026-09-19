# Soundness probes for the HIT schema: every definition below is a proof that
# MUST NOT go through.  (Registered in suite.sh.)
type Circle:
  case @base:
  path @loop: Path(Circle, @base, @base)
type Susp(A: Set):
  case @north:
  case @south:
  path @merid(a: A): Path(Susp(A), @north, @south)
# 1. the loop is not refl: Circle is not a set
def notRefl() -> Path(Path(Circle, @base, @base), <i> @loop @ i, <_> @base):
  <_> <_> @base
# 2. a path branch must have the faces the point branches dictate
def wrongLoop(B: Set, b: B, c: B, p: Path(B, b, c)) -> B:
  hrec(@base) { @base: b ; @loop: p }
# 3. the two poles of a suspension cannot go to True and False in Bool
def poles(x: Susp(Unit)) -> Bool:
  hrec(x) { @north: True ; @south: False ; @merid: lambda u. <_> True }
# 4. a missing branch is not a proof
def missing(x: Circle) -> Bool:
  hrec(x) { @base: True }
# 5. a field must have the declared type
def wrongField() -> Susp(Bool):
  @merid{()} @ i0
# 6. the faces of a path constructor are the declared ones
def wrongEnd() -> Path(Susp(Bool), @merid{True} @ i0, @south):
  <_> @south
# 7. a constant branch cannot fill a square whose two faces have different images
type Tree2:
  case @leaf2:
    b: Bool
  case @node2:
    l: Tree2
    r: Tree2
  path @assoc(x: Tree2, y: Tree2, z: Tree2): Path(Tree2, @node2{@node2{x, y}, z}, @node2{x, @node2{y, z}})
def leftSize(t: Tree2) -> Nat:
  hrec(t) { @leaf2: lambda b. 1n ; @node2: lambda l. lambda r. 1n+leftSize(l) ; @assoc: lambda x. lambda y. lambda z. <_> 1n+1n+leftSize(x) }
