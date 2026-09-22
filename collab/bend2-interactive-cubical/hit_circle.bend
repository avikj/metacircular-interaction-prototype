# The circle as a DECLARED HIT: one point constructor, one path constructor.
type Circle:
  case @pt:
  path @lp: Path(Circle, @pt, @pt)

def base() -> Circle:
  @pt

def loop() -> Path(Circle, @pt, @pt):
  @lp

# endpoints of the path constructor are definitional
def loop0() -> Path(Circle, @lp @ i0, @pt):
  <_> @pt

# recursor into any type: base ↦ b, loop  l
def rec(B: Set, b: B, l: Path(B, b, b), x: Circle) -> B:
  hrec(x) { @pt: b ; @lp: l }

def rec_pt(B: Set, b: B, l: Path(B, b, b)) -> Path(B, rec(B, b, l, @pt), b):
  <_> b

def rec_lp(B: Set, b: B, l: Path(B, b, b)) -> Path(Path(B, b, b), <i> rec(B, b, l, @lp @ i), l):
  <_> l

# dependent eliminator with an explicit motive
def elim(P: Circle -> Set, b: P(@pt), l: PathP(lambda i. P(@lp @ i), b, b), x: Circle) -> P(x):
  helim(x, P) { @pt: b ; @lp: l }

def elim_pt(P: Circle -> Set, b: P(@pt), l: PathP(lambda i. P(@lp @ i), b, b)) -> Path(P(@pt), elim(P, b, l, @pt), b):
  <_> b

# a loop in Bool that is refl: rec sends loop to it
def flipRefl() -> Path(Bool, True, True):
  <_> True

def toBool(x: Circle) -> Bool:
  rec(Bool, True, flipRefl(), x)

def main() -> Bool:
  toBool(@lp @ i0)
