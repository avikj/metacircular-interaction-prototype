# loop is not the constant path: a match arm that maps loop to the
# constant path at base is fine, but loop itself is not {==}
import Base

type S1 is Data:
  base{}
  path loop{}: {base{} == base{} : S1}

law bad:
  {loop{} == {==} : {base{} == base{} : S1}}

def bad(): {==}

#|Error:
#|- expected : loop{}
#|- observed : {==}
#|Location: bad
#|11 | 
#|12>| def bad(): {==}
#|13 | 
#|exit 1
