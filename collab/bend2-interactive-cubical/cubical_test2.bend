# Layer 2: PathP, coe (transport), J with definitional refl, ua.

# transport along a line of types
def transport(P: Interval -> Set, t: P(i0)) -> P(i1):
  coe(P, i0, i1, t)

# subst: transport along a path in the base of a family
def subst(A: Set, C: A -> Set, a: A, b: A, p: Path(A, a, b), d: C(a)) -> C(b):
  coe(lambda i. C(p @ i), i0, i1, d)

# J, defined by coe along the connection square (no hcomp needed)
def J(A: Set, a: A, C: all b:A. (Path(A, a, b) -> Set), d: C(a, <_> a), b: A, p: Path(A, a, b)) -> C(b, p):
  coe(lambda i. C(p @ i, <j> p @ iand(i, j)), i0, i1, d)

# J computes on refl definitionally (regularity)
def J_refl(A: Set, a: A, C: all b:A. (Path(A, a, b) -> Set), d: C(a, <_> a)) -> Path(C(a, <_> a), J(A, a, C, d, a, <_> a), d):
  <i> d

# PathP: dependent path over a line of types
def pathp_const(A: Set, a: A) -> PathP(lambda i. A, a, a):
  <i> a

# transport along ua computes to the function
def ua_beta(A: Set, B: Set, f: A -> B, g: B -> A, gf: all x:A. Path(A, g(f(x)), x), fg: all y:B. Path(B, f(g(y)), y), x: A) -> Path(B, transport(lambda i. ua(A, B, f, g, gf, fg) @ i, x), f(x)):
  <i> f(x)

# transport backwards along ua computes to the inverse
def ua_beta_inv(A: Set, B: Set, f: A -> B, g: B -> A, gf: all x:A. Path(A, g(f(x)), x), fg: all y:B. Path(B, f(g(y)), y), y: B) -> Path(A, coe(lambda i. ua(A, B, f, g, gf, fg) @ i, i1, i0, y), g(y)):
  <i> g(y)

# transport in a Pi type (function transport)
def transport_pi(A: Set, B: Set, C: Set, p: Path(Set, A, B)) -> ((A -> C) -> (B -> C)):
  lambda h. coe(lambda i. (p @ i) -> C, i0, i1, h)

# transport in a Sigma
def transport_sig(A: Set, C: Set, D: Set, p: Path(Set, C, D), t: any x:A. C) -> any x:A. D:
  coe(lambda i. any x:A. (p @ i), i0, i1, t)

def main() -> Nat:
  0n
