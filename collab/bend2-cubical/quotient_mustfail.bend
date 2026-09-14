# MUST-FAIL: the recursor must reject a resp that does not respect R.
# If accepted, eq/ + this resp would prove f(a) == f(b) for unrelated values,
# collapsing the target.  The checker must reject `badResp`.
def R(a: Bool, b: Bool) -> Set:
  Path(Bool, a, b)
def Q() -> Set:
  Quot(Bool, R)
def f(b: Bool) -> Nat:
  match b:
    case True: 1n
    case False: 0n

# WRONG: claims a constant path f(a)==f(a); required type is Path(Nat,f(a),f(b)).
def badResp(a: Bool, b: Bool, w: R(a,b)) -> Path(Nat, f(a), f(b)):
  <_> f(a)

def bad(setB: Nat, q: Q) -> Nat:
  qrec(q, setB, f, badResp)

def main() -> Nat:
  0n
