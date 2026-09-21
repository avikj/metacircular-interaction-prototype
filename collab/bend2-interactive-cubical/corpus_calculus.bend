# Translation of formal/cubical/theorems/residue/CorpusCalculus.agda
# Point = Î[ A âˆˆ Type ] A ; Question s = Î[ B âˆˆ Type ] (fst s â’ B)
# target, Event, step, twoSteps â” refl theorems check by computation.

def Point() -> Set:
  any A: Set. A

def point(A: Set, a: A) -> Point():
  (A, a)

def Src(s: Point()) -> Set:
  match s:
    case (A, a):
      A

def src(s: Point()) -> Src(s):
  match s:
    case (A, a):
      a

def Question(s: Point()) -> Set:
  any B: Set. (Src(s) -> B)

def target(s: Point(), q: Question(s)) -> Point():
  match q:
    case (B, f):
      (B, f(src(s)))

# Event s q s' = target s q â‰¡ s'   (as a Path)
def Event(s: Point(), q: Question(s), s2: Point()) -> Set:
  Path(Point(), target(s, q), s2)

# step : fst (target (point a) (B , f)) â‰¡ B with value f a  â” by refl
def step(A: Set, B: Set, a: A, f: A -> B) -> Path(Point(), target(point(A, a), (B, f)), point(B, f(a))):
  <i> target(point(A, a), (B, f))

# twoSteps : target (target (point a) (B,f)) (C,g) â‰¡ point (g (f a)) â” by refl
def twoSteps(A: Set, B: Set, C: Set, a: A, f: A -> B, g: B -> C) -> Path(Point(), target(target(point(A, a), (B, f)), (C, g)), point(C, g(f(a)))):
  <i> point(C, g(f(a)))

def main() -> Nat:
  0n
