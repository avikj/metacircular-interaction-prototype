# the suspension: transport along Susp<ua(not)(i)> pushes into the path
# constructor's field, definitionally; the torus: a two-dimensional path
# constructor, its corners and edges by evaluation, an eliminator on it
import Base

def Bool.not.not(b: Bool) -> {Bool.not(Bool.not(b)) == b : Bool}:
  match b:
    case True{}:
      {==}
    case False{}:
      {==}

def notEquiv() -> Equiv(&2, &2, Bool, Bool):
  Equiv.from_iso(~Bool, ~Bool, ~Bool.not, ~Bool.not, ~Bool.not.not, ~Bool.not.not)

type Susp<-A: Type> is Type:
  north{}
  south{}
  path merid{a: A}: {north{} == south{} : Susp<A>}

law susp_tr:
  {(j => coe(i => Susp<ua(&2, Bool, Bool, notEquiv())(i)>, i0, i1, merid{True{}}(j))) == merid{False{}} : {north{} == south{} : Susp<Bool>}}

def susp_tr(): {==}

type Torus is Data:
  pt{}
  path p{}: {pt{} == pt{} : Torus}
  path q{}: {pt{} == pt{} : Torus}
  path surf{}: {q{} == q{} : i => {p{}(i) == p{}(i) : Torus}}

law torus_edges:
  for -i: Interval
  {surf{}(i0) == q{} : {pt{} == pt{} : Torus}} & {surf{}(i)(i0) == p{}(i) : Torus} & {surf{}(i)(i1) == p{}(i) : Torus}

def torus_edges(i): ({==}, {==}, {==})

def toBool(t: Torus) -> Bool:
  match t:
    case pt{}:
      True{}
    case p{}:
      i => True{}
    case q{}:
      i => True{}
    case surf{}:
      i => j => True{}

def main() -> Bool:
  toBool(surf{}(i1)(i0))

#|True{}
