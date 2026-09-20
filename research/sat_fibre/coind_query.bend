# THE QUERY, to the coinductive calculus.
# corpus_calculus: Point = (Set, value); Question s = (B, Src s -> B);
# run answers every question with target + refl-event + continuation.
# Here the object is a problem's reduction trace, and the question asked of it
# is a map out: its cost. The machine answers with the cost and continues.

def Point() -> Set:
  any A: Set. A
def point(A: Set, a: A) -> Point():
  (A, a)
def Src(s: Point()) -> Set:
  match s:
    case (A, a): A
def src(s: Point()) -> Src(s):
  match s:
    case (A, a): a
def Question(s: Point()) -> Set:
  any B: Set. (Src(s) -> B)
def target(s: Point(), q: Question(s)) -> Point():
  match q:
    case (B, f): (B, f(src(s)))

# --- the object: a problem, as its reduction trace ---
type Step:
  case @Fwd: w: Nat
  case @Bwd: w: Nat
type Trace:
  case @Done:
  case @Then: s: Step  rest: Trace
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n: b
    case 1n + p: 1n + add(p, b)
def cost(t: Trace) -> Nat:                    # the map asked of the object
  match t:
    case @Done{}: 0n
    case @Then{s, rest}:
      match s:
        case @Fwd{w}: add(w, cost(rest))
        case @Bwd{w}: add(w, cost(rest))
def instance() -> Trace:
  @Then{@Fwd{0n}, @Then{@Fwd{1n}, @Then{@Fwd{1n}, @Then{@Bwd{1n}, @Then{@Bwd{0n}, @Then{@Bwd{0n}, @Done}}}}}}

# THE OBJECT and THE QUESTION
def obj() -> Point():
  point(Trace, instance())
def costQuestion() -> Question(obj()):
  (Nat, cost)                                  # "what is your cost?", a map Trace -> Nat

# THE ANSWER: run the object, ask it the cost question, read the target.
def answer() -> Point():
  target(obj(), costQuestion())                # = point(Nat, cost(instance))

def main() -> Nat:
  src(answer())                                # the cost the machine answers
