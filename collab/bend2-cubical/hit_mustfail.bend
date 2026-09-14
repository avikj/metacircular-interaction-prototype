# Soundness probes for the hit schema: every definition below is a proof that
# MUST NOT go through.  (Registered in suite.sh.)
hit Circle:
  case @base
  path @loop: Circle/base ~> Circle/base
hit Susp<A: Set>:
  case @north
  case @south
  path @merid(a: A): Susp/north(A) ~> Susp/south(A)

# 1. the loop is not refl: Circle is not a set
def notRefl() -> Path(Path(Circle, Circle/base, Circle/base), <i> Circle/loop @ i, <_> Circle/base):
  <_> <_> Circle/base
# 2. a path branch must have the endpoints the point branches dictate: this
#    loop branch goes from b to c, not from b to b
def wrongLoop(B: Set, b: B, c: B, p: Path(B, b, c)) -> B:
  Circle/elim(lambda _. B, Circle/base, b, p)
# 3. the two poles of a suspension cannot be sent to True and False in Bool,
#    because the meridian would need a path True = False
def poles(x: Susp(Unit)) -> Bool:
  Susp/elim(Unit, lambda _. Bool, x, True, False, lambda u. <_> True)
# 4. a missing branch is not a proof
def missing(x: Circle) -> Bool:
  Circle/elim(lambda _. Bool, x, True)
# 5. the eliminator's result lives in P(x), not in an arbitrary type
def wrongMotive(x: Circle) -> Nat:
  Circle/elim(lambda _. Bool, x, True, <_> True)
# 6. a constructor's field must have the declared type
def wrongField() -> Susp(Bool):
  Susp/merid(Bool, ()) @ i0
# 7. the endpoints of a path constructor are the declared ones, not others
def wrongEnd() -> Path(Susp(Bool), Susp/merid(Bool, True) @ i0, Susp/south(Bool)):
  <_> Susp/south(Bool)
