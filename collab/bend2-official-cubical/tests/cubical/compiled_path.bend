# a path in Type is runtime data: its equivalence, affine as a closure is.
# A function takes a path between types as an argument and transports
# along it; a trace (a, p) is stored and its visible value replayed from
# it; a line of lists over a template path maps the equivalence over the
# list
import Base

def Bool.not.not(b: Bool) -> {Bool.not(Bool.not(b)) == b : Bool}:
  match b:
    case True{}:
      {==}
    case False{}:
      {==}

def notEquiv() -> Equiv(&2, &2, Bool, Bool):
  Equiv.from_iso(~Bool, ~Bool, ~Bool.not, ~Bool.not, ~Bool.not.not, ~Bool.not.not)

def cast(p: {Bool == Bool : Data}, x: Bool) -> Bool:
  coe(p, i0, i1, x)

def cast.back(p: {Bool == Bool : Data}, x: Bool) -> Bool:
  coe(p, i1, i0, x)

type Trace is Type:
  tr{a: Bool, p: {Bool == Bool : Data}}

def move(p: {Bool == Bool : Data}, a: Bool) -> Trace:
  tr{a, p}

def replay(t: Trace) -> Bool:
  tr{a, p} = t
  cast(p, a)

# a line of lists over a path spends the path once per element: the path
# is a template argument, as the function of List.map is
def flipAll(~p: {Bool == Bool : Data}, xs: List<Bool>) -> List<Bool>:
  coe(i => List<p(i)>, i0, i1, xs)

def showPair(x: Bool & Bool) -> String:
  (a, b) = x
  Bool.show(a) ++ " " ++ Bool.show(b)

def main() -> IO(Unit):
  do IO<Unit>:
    IO.print(showPair((replay(move(ua(&2, Bool, Bool, notEquiv()), True{})), cast.back(ua(&2, Bool, Bool, notEquiv()), False{}))))
    IO.print(List.show(~&1, ~Bool, ~Bool.show, flipAll(~ua(&2, Bool, Bool, notEquiv()), [True{}, False{}])))
    IO.print(Bool.show(cast({==}, True{})))

#|False True
#|[False, True]
#|True
