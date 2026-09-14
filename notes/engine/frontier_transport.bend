# Derivation as normalization, in the certified lane.
# The atom of the algorithm: a checked equivalence is a path (ua), and
# transport along it RUNS — the answer is the normal form of the transport,
# and its correctness is the path itself, checked by reduction (not searched).

def not(b: Bool) -> Bool:
  match b:
    case False: True
    case True:  False

# not is its own inverse — the two homotopies, both refl-computable
def notnot(b: Bool) -> Path(Bool, not(not(b)), b):
  match b:
    case False: <_> False
    case True:  <_> True

# the univalence path Bool = Bool carrying negation
def notPath() -> Path(Set, Bool, Bool):
  ua(Bool, Bool, not, not, notnot, notnot)

# DERIVATION AS NORMALIZATION: transport True across the negation path.
# No search; the result is forced and computes.
def flip(b: Bool) -> Bool:
  coe(lambda i. notPath() @ i, i0, i1, b)

# and the derivation is CHECKED: transport along ua computes to the function.
def flip_is_not(b: Bool) -> Path(Bool, flip(b), not(b)):
  <i> not(b)

def main() -> Bool:
  flip(True)
