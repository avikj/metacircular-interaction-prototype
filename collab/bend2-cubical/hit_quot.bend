# The set-quotient's GENERATOR structure declared with the schema: classes and
# a path for every related pair.  (Without a 2-dimensional constructor this is
# the quotient's 1-skeleton, which is all the recursor into a set ever uses.)
hit Q<A: Set, R: A -> A -> Set>:
  case @cl(a: A)
  path @eq(a: A, b: A, r: R(a, b)): Q/cl(A, R, a) ~> Q/cl(A, R, b)

def Always(a: Bool, b: Bool) -> Set:
  Unit
# Bool / (everything related): all classes are joined
def joined(a: Bool, b: Bool) -> Path(Q(Bool, Always), Q/cl(Bool, Always, a), Q/cl(Bool, Always, b)):
  <i> Q/eq(Bool, Always, a, b, ()) @ i
# a function respecting the relation descends to the quotient
def descend(B: Set, f: Bool -> B, resp: all a: Bool. all b: Bool. all r: Always(a, b). Path(B, f(a), f(b)), q: Q(Bool, Always)) -> B:
  Q/elim(Bool, Always, lambda _. B, q, f, resp)
def descend_cl(B: Set, f: Bool -> B, resp: all a: Bool. all b: Bool. all r: Always(a, b). Path(B, f(a), f(b)), a: Bool) -> Path(B, descend(B, f, resp, Q/cl(Bool, Always, a)), f(a)):
  <_> f(a)
def descend_eq(B: Set, f: Bool -> B, resp: all a: Bool. all b: Bool. all r: Always(a, b). Path(B, f(a), f(b)), a: Bool, b: Bool, i: Interval) -> Path(B, descend(B, f, resp, Q/eq(Bool, Always, a, b, ()) @ i), resp(a, b, ()) @ i):
  <_> resp(a, b, ()) @ i
def const(b: Bool) -> Unit:
  ()
def toUnit(q: Q(Bool, Always)) -> Unit:
  descend(Unit, const, lambda a. lambda b. lambda r. <_> (), q)
def main() -> Unit:
  toUnit(Q/eq(Bool, Always, True, False, ()) @ i1)
