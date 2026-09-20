# propositional truncation: a recursive path constructor over two points
# of the type itself; the recursor into a proposition; the truncation is
# a proposition by its own constructor
import Base

type Tr<-A: Type> is Type:
  in{a: A}
  path sq{x: Tr<A>, y: Tr<A>}: {x == y : Tr<A>}

law tr_prop:
  for -A: Type
  for x: Tr<A>
  for y: Tr<A>
  {x == y : Tr<A>}

def tr_prop(A, x, y): sq{x, y}

def Unit.eq(u: Unit, v: Unit) -> {u == v : Unit}:
  match u:
    case Unit{}:
      match v:
        case Unit{}:
          {==}

# the recursor into Unit, a proposition: the path arm is the target's
# propositionality between the recursive results
def toUnit(-A: Type, t: Tr<A>) -> Unit:
  match t:
    case in{a}:
      Unit{}
    case sq{x, y}:
      i => Unit.eq(toUnit(A, x), toUnit(A, y))(i)

law sq_faces:
  for -A: Type
  for x: Tr<A>
  for y: Tr<A>
  {sq{x, y}(i0) == x : Tr<A>} & {sq{x, y}(i1) == y : Tr<A>}

def sq_faces(A, x, y): ({==}, {==})

# the eliminator on an hcomp cell of the truncation composes along its
# motive with the tubes eliminated
law elim_cell:
  for -j: Interval
  {toUnit(Nat, hcomp(Tr<Nat>, in{1n}, [(j == i1) i => in{1n}])) == hcomp(Unit, Unit{}, [(j == i1) i => Unit{}]) : Unit}

def elim_cell(j): {==}

def main() -> Unit:
  toUnit(Nat, sq{in{1n}, in{2n}}(i0))

#|Unit{}
