# Derivation as normalization, certified lane.
# A checked equivalence is a path (ua); transport along it RUNS — the answer is
# the normal form of the transport, correctness is the path, checked by reduction.

def neg(b: Bool) -> Bool:
  match b:
    case False: True
    case True:  False

def negneg(b: Bool) -> Path(Bool, neg(neg(b)), b):
  match b:
    case False: <_> False
    case True:  <_> True

def negPath() -> Path(Set, Bool, Bool):
  ua(Bool, Bool, neg, neg, negneg, negneg)

def flip(b: Bool) -> Bool:
  coe(lambda i. negPath() @ i, i0, i1, b)

def flip_is_neg(b: Bool) -> Path(Bool, flip(b), neg(b)):
  <i> neg(b)

def main() -> Bool:
  flip(True)
