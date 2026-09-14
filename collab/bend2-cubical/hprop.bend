# hProp / prop-level foundations for set-quotient effectivity.
# All definitional; built on the comp/hcomp machinery.  These are the pieces
# the encode-decode proof of  [a] == [b] => R a b  is assembled from.
def isProp(A: Set) -> Set:
  all x: A. all y: A. Path(A, x, y)
def isSet(A: Set) -> Set:
  all x: A. all y: A. all p: Path(A,x,y). all q: Path(A,x,y). Path(Path(A,x,y),p,q)

# isProp A -> isSet A: fill the square with the proposition (Cubical's proof).
def isPropToIsSet(A: Set, h: isProp(A)) -> isSet(A):
  lambda a. lambda b. lambda p. lambda q. <j> <i> hcompN(A,
    [ (inot(i), <k> h(a, a) @ k)
    , (i,       <k> h(a, b) @ k)
    , (inot(j), <k> h(a, p @ i) @ k)
    , (j,       <k> h(a, q @ i) @ k)
    ], a)

# being a proposition is itself a proposition
def isPropIsProp(A: Set, f: isProp(A), g: isProp(A)) -> Path(isProp(A), f, g):
  <i> lambda x. lambda y. isPropToIsSet(A, f, x, y, f(x, y), g(x, y)) @ i

# propositional univalence: props with maps both ways are equal as types
# (gf, fg forced by isProp; ua turns the biimplication into a path of types).
def propExt(A: Set, B: Set, pA: isProp(A), pB: isProp(B), f: A -> B, g: B -> A) -> Path(Set, A, B):
  ua(A, B, f, g, lambda x. pA(g(f(x)), x), lambda y. pB(f(g(y)), y))

def hProp() -> Set:
  any A: Set. isProp(A)
def hcar(P: hProp) -> Set:
  match P:
    case (A, p): A
def hpf(P: hProp) -> isProp(hcar(P)):
  match P:
    case (A, p): p

def main() -> Nat:
  0n
