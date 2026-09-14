# The pushout of a span A <-f- C -g-> B, the universal HIT of homotopy type
# theory: two injections and a gluing path for every c.  Its path
# constructor's endpoints are point constructors applied to NON-recursive
# arguments (f(c), g(c)), which the eliminator's branch types must follow.
hit Push<A: Set, B: Set, C: Set, f: C -> A, g: C -> B>:
  case @inl(a: A)
  case @inr(b: B)
  path @glue(c: C): Push/inl(A, B, C, f, g, f(c)) ~> Push/inr(A, B, C, f, g, g(c))

def id(b: Bool) -> Bool:
  b
# the pushout of Bool <-id- Bool -id-> Bool: a "cylinder" over Bool
def Cyl() -> Set:
  Push(Bool, Bool, Bool, id, id)
def glue_i0(c: Bool) -> Path(Cyl(), Push/glue(Bool, Bool, Bool, id, id, c) @ i0, Push/inl(Bool, Bool, Bool, id, id, c)):
  <_> Push/inl(Bool, Bool, Bool, id, id, c)
def glue_i1(c: Bool) -> Path(Cyl(), Push/glue(Bool, Bool, Bool, id, id, c) @ i1, Push/inr(Bool, Bool, Bool, id, id, c)):
  <_> Push/inr(Bool, Bool, Bool, id, id, c)
# the universal property, computationally: a cocone (l, r, h) gives a map out
def cocone(D: Set, l: Bool -> D, r: Bool -> D, h: all c: Bool. Path(D, l(c), r(c)), x: Cyl()) -> D:
  Push/elim(Bool, Bool, Bool, id, id, lambda _. D, x, l, r, h)
def cocone_inl(D: Set, l: Bool -> D, r: Bool -> D, h: all c: Bool. Path(D, l(c), r(c)), a: Bool) -> Path(D, cocone(D, l, r, h, Push/inl(Bool, Bool, Bool, id, id, a)), l(a)):
  <_> l(a)
def cocone_glue(D: Set, l: Bool -> D, r: Bool -> D, h: all c: Bool. Path(D, l(c), r(c)), c: Bool, i: Interval) -> Path(D, cocone(D, l, r, h, Push/glue(Bool, Bool, Bool, id, id, c) @ i), h(c) @ i):
  <_> h(c) @ i
# the cylinder collapses onto Bool: both ends project to the point
def proj(x: Cyl()) -> Bool:
  cocone(Bool, id, id, lambda c. <_> c, x)
def proj_glue(c: Bool, i: Interval) -> Path(Bool, proj(Push/glue(Bool, Bool, Bool, id, id, c) @ i), c):
  <_> c
def main() -> Bool:
  proj(Push/glue(Bool, Bool, Bool, id, id, True) @ i1)
