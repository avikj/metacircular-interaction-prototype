# SetQuotient: representative usage (scrutinee is a typed variable).
def R(a: Bool, b: Bool) -> Set:
  Path(Bool, a, b)

def Q() -> Set:
  Quot(Bool, R)

def isSet(A: Set) -> Set:
  all x: A. all y: A. all p: Path(A,x,y). all q: Path(A,x,y). Path(Path(A,x,y), p, q)

# squash/ inhabits isSet of the quotient
def isSetQ() -> isSet(Q):
  qsquash

# point endpoints in a Path type (check-mode against the constant line)
def loopT() -> Path(Q, qcl(True), qcl(True)):
  <_> qcl(True)

# eq/ as a genuine path in the quotient
def eqPath(a: Bool, b: Bool, w: R(a,b)) -> Path(Q, qcl(a), qcl(b)):
  qeq(a,b,w)

def f(b: Bool) -> Nat:
  match b:
    case True: 1n
    case False: 0n

def resp(a: Bool, b: Bool, w: R(a,b)) -> Path(Nat, f(a), f(b)):
  <i> f(w @ i)

# recursor with a variable scrutinee (the real elimination shape)
def rec(setB: isSet(Nat), g: all b: Bool. Nat, gr: all a: Bool. all b: Bool. all w: R(a,b). Path(Nat, g(a), g(b)), q: Q) -> Nat:
  qrec(q, setB, g, gr)

def recRun(setB: Nat, g: all b: Bool. Nat, gr: all a: Bool. all b: Bool. all w: R(a,b). Path(Nat, g(a), g(b)), q: Q) -> Nat:
  qrec(q, setB, g, gr)

# qrec(qcl(True), ..) reduces to f(True) = 1n  (the point computation rule)
def recComputes() -> Path(Nat, recRun(0n, f, resp, qcl(True)), 1n):
  <_> 1n

def main() -> Nat:
  recRun(0n, f, resp, qcl(True))
