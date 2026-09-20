# issue 853: a hot constructor built at a family stuck on an open index
# held a field of a type the facts never saw, and its consumer took the
# sealed node raw (the C lane printed 1 for 5). Fixed upstream at 2.0.21
# (facts_ctr heats field types at build sites, facts_fam heats the arms
# of a stuck family); pinned here so the C lane keeps printing 5.
import Base
type P is Data:
  P{a: U32, b: U32}
def Q() -> Data:
  Sigma<&2,&2,U32,(x => U32)>
def Pw(xs: List<&2,Q()>) -> Data:
  match xs:
    case Nil{}: Unit
    case Con{h,t}: Sigma<&2,&2,P,(p => Unit)>
def build(xs: List<&2,Q()>) -> Pw(xs):
  match xs:
    case Nil{}: Unit{}
    case Con{Tuple{n,m},t}: Tuple{P{n,1},Unit{}}
def total(xs: List<&2,Q()>,ps: Pw(xs)) -> U32:
  match xs:
    case Nil{}: 0
    case Con{h,t}:
      match ps:
        case Tuple{P{a,b},u}: a
def main() -> IO(Unit):
  do IO<Unit>:
    +s : List<&2,Q()> <- IO.pure(List<&2,Q()>, [Tuple{5,3}])
    IO.print(U32.show(total(s,build(s))))

#|5
