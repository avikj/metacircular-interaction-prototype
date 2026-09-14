# A hit with RECURSIVE POINT-CONSTRUCTOR fields: binary trees of booleans with
# a path swapping the children of every node (the free commutative magma on
# Bool).  Recursion is by a named definition; the swap branch's PathP runs
# between the eliminator's images of node(l, r) and node(r, l), which compute
# to the node branch on the recursive calls.
hit Tree:
  case @leaf(b: Bool)
  case @node(l: Tree, r: Tree)
  path @swap(l: Tree, r: Tree): Tree/node(l, r) ~> Tree/node(r, l)

def disj(a: Bool, b: Bool) -> Bool:
  match a:
    case False: b
    case True: True
def disjComm(a: Bool, b: Bool) -> Path(Bool, disj(a, b), disj(b, a)):
  match a:
    case False:
      match b:
        case False: <_> False
        case True: <_> True
    case True:
      match b:
        case False: <_> True
        case True: <_> True
# "some leaf is True": respects the swap because disj is commutative
def anyTrue(t: Tree) -> Bool:
  Tree/elim(lambda _. Bool, t, lambda b. b, lambda l. lambda r. disj(anyTrue(l), anyTrue(r)), lambda l. lambda r. <i> disjComm(anyTrue(l), anyTrue(r)) @ i)
def any_leaf(b: Bool) -> Path(Bool, anyTrue(Tree/leaf(b)), b):
  <_> b
def any_node(l: Tree, r: Tree) -> Path(Bool, anyTrue(Tree/node(l, r)), disj(anyTrue(l), anyTrue(r))):
  <_> disj(anyTrue(l), anyTrue(r))
def any_swap(l: Tree, r: Tree, i: Interval) -> Path(Bool, anyTrue(Tree/swap(l, r) @ i), disjComm(anyTrue(l), anyTrue(r)) @ i):
  <_> disjComm(anyTrue(l), anyTrue(r)) @ i
def swap_i0(l: Tree, r: Tree) -> Path(Tree, Tree/swap(l, r) @ i0, Tree/node(l, r)):
  <_> Tree/node(l, r)
def swap_i1(l: Tree, r: Tree) -> Path(Tree, Tree/swap(l, r) @ i1, Tree/node(r, l)):
  <_> Tree/node(r, l)
# a face may be ANY term of the HIT — here nested constructor terms.  The
# two faces of assoc have DIFFERENT images under a size function,
# add(add(x,y),z) and add(x,add(y,z)), so the branch must be the
# associativity of addition, proved by induction: a constant branch is
# correctly rejected (that is the checker catching a wrong test).
hit Tree2:
  case @leaf(b: Bool)
  case @node(l: Tree2, r: Tree2)
  path @assoc(x: Tree2, y: Tree2, z: Tree2): Tree2/node(Tree2/node(x, y), z) ~> Tree2/node(x, Tree2/node(y, z))
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n: b
    case 1n+p: 1n+add(p, b)
def addAssoc(a: Nat, b: Nat, c: Nat) -> Path(Nat, add(add(a, b), c), add(a, add(b, c))):
  match a:
    case 0n: <_> add(b, c)
    case 1n+p: <i> 1n+(addAssoc(p, b, c) @ i)
def size(t: Tree2) -> Nat:
  Tree2/elim(lambda _. Nat, t, lambda b. 1n, lambda l. lambda r. add(size(l), size(r)), lambda x. lambda y. lambda z. <i> addAssoc(size(x), size(y), size(z)) @ i)
def size_assoc(x: Tree2, y: Tree2, z: Tree2, i: Interval) -> Path(Nat, size(Tree2/assoc(x, y, z) @ i), addAssoc(size(x), size(y), size(z)) @ i):
  <_> addAssoc(size(x), size(y), size(z)) @ i
def t1() -> Tree:
  Tree/node(Tree/leaf(False), Tree/node(Tree/leaf(False), Tree/leaf(True)))
def main() -> Nat:
  size(Tree2/assoc(Tree2/leaf(True), Tree2/node(Tree2/leaf(True), Tree2/leaf(False)), Tree2/leaf(True)) @ i1)
