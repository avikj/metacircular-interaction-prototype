# transport along a line of datatypes over ua, compiled: the runtime pass
# mints a structural transport for List, pushing the equivalence into
# every element, and along a function line it wraps the function
import Base

def Bool.not.not(b: Bool) -> {Bool.not(Bool.not(b)) == b : Bool}:
  match b:
    case True{}:
      {==}
    case False{}:
      {==}

def notEquiv() -> Equiv(&2, &2, Bool, Bool):
  Equiv.from_iso(~Bool, ~Bool, ~Bool.not, ~Bool.not, ~Bool.not.not, ~Bool.not.not)

def flipAll(xs: List<Bool>) -> List<Bool>:
  coe(i => List<ua(&2, Bool, Bool, notEquiv())(i)>, i0, i1, xs)

def flipFun(f: Bool -> Bool) -> Bool -> Bool:
  coe(i => ua(&2, Bool, Bool, notEquiv())(i) -> ua(&2, Bool, Bool, notEquiv())(i), i0, i1, f)

def main() -> IO(Unit):
  do IO<Unit>:
    IO.print(List.show(~&1, ~Bool, ~Bool.show, flipAll([True{}, False{}, True{}])))
    IO.print(Bool.show(flipFun(x => x)(True{})))

#|[False, True, False]
#|True
