# Truncation by hub and spoke: constructors with a FUNCTION field into the HIT.
# Trunc2(A) has every map from the circle filled by a hub, so it is a groupoid-
# truncation shape; the schema needs nothing special for a recursive function field.
type Circle:
  case @base:
  path @loop: Path(Circle, @base, @base)

type HTrunc(A: Set):
  case @tin:
    a: A
  case @hub:
    f: Circle -> HTrunc(A)
  path @spoke(f: Circle -> HTrunc(A), x: Circle): Path(HTrunc(A), @hub{f}, f(x))

def spoke_i1(A: Set, f: Circle -> HTrunc(A), x: Circle) -> Path(HTrunc(A), @spoke{f, x} @ i1, f(x)):
  <_> f(x)

# a recursor into a type B with a hub-filler: every map Circle -> B is filled
def hrecT(A: Set, B: Set, g: A -> B, fill: (Circle -> B) -> B, sp: all h: Circle -> B. all x: Circle. Path(B, fill(h), h(x)), t: HTrunc(A)) -> B:
  hrec(t) {
    @tin: g ;
    @hub: lambda f. fill(lambda c. hrecT(A, B, g, fill, sp, f(c))) ;
    @spoke: lambda f. lambda x. sp(lambda c. hrecT(A, B, g, fill, sp, f(c)), x)
  }

def hrecT_in(A: Set, B: Set, g: A -> B, fill: (Circle -> B) -> B, sp: all h: Circle -> B. all x: Circle. Path(B, fill(h), h(x)), a: A) -> Path(B, hrecT(A, B, g, fill, sp, @tin{a}), g(a)):
  <_> g(a)

def hrecT_spoke(A: Set, B: Set, g: A -> B, fill: (Circle -> B) -> B, sp: all h: Circle -> B. all x: Circle. Path(B, fill(h), h(x)), f: Circle -> HTrunc(A), x: Circle, i: Interval) -> Path(B, hrecT(A, B, g, fill, sp, @spoke{f, x} @ i), sp(lambda c. hrecT(A, B, g, fill, sp, f(c)), x) @ i):
  <_> sp(lambda c. hrecT(A, B, g, fill, sp, f(c)), x) @ i

def main() -> Nat:
  0n
