# Layer 4: hcomp (definitional composition), full iso-univalence, Sup x Path.

def neg4(x: Bool) -> Bool:
  if x:
    False
  else:
    True

def neg_inv(x: Bool) -> Path(Bool, neg4(neg4(x)), x):
  if x:
    <i> True
  else:
    <i> False

# full iso-univalence: Bool = Bool by negation, with both coherences
def notPath() -> Path(Set, Bool, Bool):
  ua(Bool, Bool, lambda x. neg4(x), lambda x. neg4(x), lambda x. neg_inv(x), lambda x. neg_inv(x))

# transport along it computes: True goes to False, definitionally
def notPath_beta() -> Path(Bool, coe(lambda i. notPath() @ i, i0, i1, True), False):
  <i> False

# hcomp: definitional path composition
def pcompH(A: Set, a: A, b: A, c: A, p: Path(A, a, b), q: Path(A, b, c)) -> Path(A, a, c):
  <i> hcomp(A, i, <j> a, <j> q @ j, p @ i)

# Sup x Path: transport along a superposed line routes by label:
# the first universe transports along notPath (negation), the second is constant.
def supLine() -> Interval -> Set:
  lambda i. &0{notPath() @ i, Bool}

def sup_transport() -> Path(&0{Bool, Bool}, coe(lambda i. supLine()(i), i0, i1, &0{True, True}), &0{False, True}):
  <i> &0{False, True}

def main() -> Nat:
  0n
