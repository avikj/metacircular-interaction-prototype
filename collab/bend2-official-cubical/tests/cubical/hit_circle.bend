# the circle as a higher inductive type: a point and a path constructor;
# its eliminator by match, a path arm landing in the path over the motive
import Base

type S1 is Data:
  base{}
  path loop{}: {base{} == base{} : S1}

def toBool(x: S1) -> Bool:
  match x:
    case base{}:
      True{}
    case loop{}:
      i => True{}

# the faces of loop are base, and the eliminator computes on them
law loop_faces:
  {loop{}(i0) == base{} : S1} & {loop{}(i1) == base{} : S1}

def loop_faces(): ({==}, {==})

law elim_loop:
  {toBool(loop{}(i1)) == True{} : Bool}

def elim_loop(): {==}

# a loop-dependent eliminator: the loop arm must be a path over the motive
def spin(x: S1) -> S1:
  match x:
    case base{}:
      base{}
    case loop{}:
      i => loop{}(-i)

law spin_loop:
  {spin(loop{}(i0)) == base{} : S1}

def spin_loop(): {==}

# transport along the constant line of S1 is the identity on loop
law tr_loop:
  {coe(i => S1, i0, i1, loop{}(i0)) == base{} : S1}

def tr_loop(): {==}

def main() -> Bool:
  toBool(spin(loop{}(i1)))

#|True{}
