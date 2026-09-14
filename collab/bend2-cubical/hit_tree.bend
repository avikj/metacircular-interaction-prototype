# HITs with RECURSIVE POINT-CONSTRUCTOR fields: binary trees of booleans with
# a path swapping the children of every node (the free commutative magma on
# Bool), and trees with an associativity path over NESTED constructor terms.
type Tree:
  case @leaf:
    b: Bool
  case @node:
    l: Tree
    r: Tree
  path @swap(l: Tree, r: Tree): Path(Tree, @node{l, r}, @node{r, l})

def disj(a: Bool, b: Bool) -> Bool:
  if a:
    True
  else:
    b
def disjComm(a: Bool, b: Bool) -> Path(Bool, disj(a, b), disj(b, a)):
  if a:
    if b:
      <_> True
    else:
      <_> True
  else:
    if b:
      <_> True
    else:
      <_> False
# "some leaf is True": respects the swap because disj is commutative;
# recursion is by the named definition (Agda's pattern matching)
def anyTrue(t: Tree) -> Bool:
  hrec(t) { @leaf: lambda b. b ; @node: lambda l. lambda r. disj(anyTrue(l), anyTrue(r)) ; @swap: lambda l. lambda r. <i> disjComm(anyTrue(l), anyTrue(r)) @ i }
def any_leaf(b: Bool) -> Path(Bool, anyTrue(@leaf{b}), b):
  <_> b
def any_node(l: Tree, r: Tree) -> Path(Bool, anyTrue(@node{l, r}), disj(anyTrue(l), anyTrue(r))):
  <_> disj(anyTrue(l), anyTrue(r))
def any_swap(l: Tree, r: Tree, i: Interval) -> Path(Bool, anyTrue(@swap{l, r} @ i), disjComm(anyTrue(l), anyTrue(r)) @ i):
  <_> disjComm(anyTrue(l), anyTrue(r)) @ i
def swap_i1(l: Tree, r: Tree) -> Path(Tree, @swap{l, r} @ i1, @node{r, l}):
  <_> @node{r, l}

# a face may be a nested constructor term.  The two faces of assoc have
# DIFFERENT images under a size function, add(add(x,y),z) and
# add(x,add(y,z)), so the branch must be the associativity of addition,
# proved by induction; a constant branch is correctly rejected.
type Tree2:
  case @leaf2:
    b: Bool
  case @node2:
    l: Tree2
    r: Tree2
  path @assoc(x: Tree2, y: Tree2, z: Tree2): Path(Tree2, @node2{@node2{x, y}, z}, @node2{x, @node2{y, z}})
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n: b
    case 1n+p: 1n+add(p, b)
def addAssoc(a: Nat, b: Nat, c: Nat) -> Path(Nat, add(add(a, b), c), add(a, add(b, c))):
  match a:
    case 0n: <_> add(b, c)
    case 1n+p: <i> 1n+(addAssoc(p, b, c) @ i)
def size(t: Tree2) -> Nat:
  hrec(t) { @leaf2: lambda b. 1n ; @node2: lambda l. lambda r. add(size(l), size(r)) ; @assoc: lambda x. lambda y. lambda z. <i> addAssoc(size(x), size(y), size(z)) @ i }
def size_assoc(x: Tree2, y: Tree2, z: Tree2, i: Interval) -> Path(Nat, size(@assoc{x, y, z} @ i), addAssoc(size(x), size(y), size(z)) @ i):
  <_> addAssoc(size(x), size(y), size(z)) @ i
def main() -> Nat:
  size(@assoc{@leaf2{True}, @node2{@leaf2{True}, @leaf2{False}}, @leaf2{True}} @ i1)
