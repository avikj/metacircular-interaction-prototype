# A hit with RECURSIVE POINT-CONSTRUCTOR fields: binary trees of booleans with
# a path swapping the children of every node (the free commutative magma on
# Bool).  The eliminator hands every branch an induction hypothesis per
# recursive field, and the swap branch's PathP runs between the IMAGES of
# node(l, r) and node(r, l): the node branch applied to the hypotheses.
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
  Tree/elim(lambda _. Bool, t, lambda b. b, lambda l. lambda r. lambda ihl. lambda ihr. disj(ihl, ihr), lambda l. lambda r. lambda ihl. lambda ihr. <i> disjComm(ihl, ihr) @ i)
def any_leaf(b: Bool) -> Path(Bool, anyTrue(Tree/leaf(b)), b):
  <_> b
# on a node the hypotheses ARE the recursive calls
def any_node(l: Tree, r: Tree) -> Path(Bool, anyTrue(Tree/node(l, r)), disj(anyTrue(l), anyTrue(r))):
  <_> disj(anyTrue(l), anyTrue(r))
# and on the swap path, at every interval, the branch runs on the recursive calls
def any_swap(l: Tree, r: Tree, i: Interval) -> Path(Bool, anyTrue(Tree/swap(l, r) @ i), disjComm(anyTrue(l), anyTrue(r)) @ i):
  <_> disjComm(anyTrue(l), anyTrue(r)) @ i
def swap_i0(l: Tree, r: Tree) -> Path(Tree, Tree/swap(l, r) @ i0, Tree/node(l, r)):
  <_> Tree/node(l, r)
def swap_i1(l: Tree, r: Tree) -> Path(Tree, Tree/swap(l, r) @ i1, Tree/node(r, l)):
  <_> Tree/node(r, l)
def t1() -> Tree:
  Tree/node(Tree/leaf(False), Tree/node(Tree/leaf(False), Tree/leaf(True)))
def main() -> Bool:
  anyTrue(Tree/swap(Tree/leaf(False), t1()) @ i1)
