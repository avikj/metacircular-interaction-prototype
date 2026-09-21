def neg(x: Bool) -> Bool:
  if x:
    False
  else:
    True
# comp along a CONSTANT line is hcomp (regularity: coe on a constant line is id)
def compConst(i: Interval, a: Bool, b: Bool, h: Path(Bool, a, b)) -> Path(Bool, comp(lambda j. Bool, [(i, <k> h @ k)], a), hcompN(Bool, [(i, <k> h @ k)], a)):
  <_> hcompN(Bool, [(i, <k> h @ k)], a)
# comp with no faces is plain transport
def compNoFace(P: Interval -> Set, x: P(i0)) -> Path(P(i1), comp(P, [], x), coe(P, i0, i1, x)):
  <_> coe(P, i0, i1, x)
