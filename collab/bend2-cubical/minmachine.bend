# The minimal Moore machine as a set-quotient, computing.
# State S, one action (unary alphabet), output Bool.  observe : S -> Bool,
# step : S -> S.  behavior x w = observe (run step x w).  NerodeCongruence:
# x ~ y iff same behavior on every word.  Meaning = S / ~ is the minimal machine.

def S() -> Set:
  Nat

def observe(x: S) -> Bool:
  match x:
    case 0n: True
    case 1n+p: False

def step(x: S) -> S:
  match x:
    case 0n: 0n
    case 1n+p: p

def run(x: S, w: Nat) -> S:
  match w:
    case 0n: x
    case 1n+k: run(step(x), k)

def behavior(x: S, w: Nat) -> Bool:
  observe(run(x, w))

# NerodeCongruence: observationally-equal states (same behavior on every word).
def Nerode(x: S, y: S) -> Set:
  all w: Nat. Path(Bool, behavior(x, w), behavior(y, w))

def Meaning() -> Set:
  Quot(S, Nerode)

# isSet of the output type, threaded as a hypothesis exactly as the corpus's
# FutureQuotient module takes (setO : isSet O).  The .bend name for it:
def isSet(A: Set) -> Set:
  all x: A. all y: A. all p: Path(A,x,y). all q: Path(A,x,y). Path(Path(A,x,y),p,q)

# quotObserve descends: observe respects ~ because the empty word is a word.
def observeResp(a: S, b: S, w: Nerode(a,b)) -> Path(Bool, observe(a), observe(b)):
  w(0n)

def quotObserve(setO: isSet(Bool), m: Meaning) -> Bool:
  qrec(m, setO, observe, observeResp)

# It computes on a point (for any set-truncation evidence):
# quotObserve setO [x] = observe x.
def quotObserve_0 (setO: isSet(Bool)) -> Path(Bool, quotObserve(setO, qcl(0n)), True):
  <_> True

def quotObserve_1 (setO: isSet(Bool)) -> Path(Bool, quotObserve(setO, qcl(1n)), False):
  <_> False

# The congruence collapses observationally-equal states in Meaning: given a
# proof they are Nerode-equal, their meanings are equal (this is eq/).
def sameMeaning(x: S, y: S, e: Nerode(x,y)) -> Path(Meaning, qcl(x), qcl(y)):
  qeq(x, y, e)

# and reduces at runtime (net): observe of the run.
def main() -> Bool:
  behavior(0n, 2n)
