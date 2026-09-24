# Grammar-independent AdiBija: the initial derivation object over an
# arbitrary Bend state type A and proof-relevant primitive motion family Step.
#
# This removes the accidental restriction of the older executable port to its
# toy arithmetic Tm grammar. It does NOT manufacture Step: for Cubical Bend the
# intrinsic motion family is supplied by the language's own typed/cubical
# transformations (paths, equivalences, reduction rules, congruences).

type Derivation(A: Set, Step: A -> A -> Set, x: A, z: A):
  case @done:
    ez: A{z == x}
  case @then:
    y: A
    step: Step(x, y)
    rest: Derivation(A, Step, y, z)

# A receiver is exactly an algebra for the free derivation object.
type Receiver(A: Set, Step: A -> A -> Set):
  case @receiver:
    Motion: A -> A -> Set
    epsilon: all t: A. Motion(t, t)
    prepend: all a: A. all b: A. all c: A.
             Step(a, b) -> Motion(b, c) -> Motion(a, c)

# The unique structural reading. This is AdiBija's fold, now independent of
# any particular object language.
def fold(A: Set, Step: A -> A -> Set,
         Motion: A -> A -> Set,
         epsilon: all t: A. Motion(t,t),
         prepend: all a: A. all b: A. all c: A.
                  Step(a,b) -> Motion(b,c) -> Motion(a,c),
         x: A, z: A, d: Derivation(A,Step,x,z)) -> Motion(x,z):
  match d:
    case @done{ez}:
      match ez:
        case {==}: epsilon(x)
    case @then{y, step, rest}:
      prepend(x, y, z, step,
              fold(A,Step,Motion,epsilon,prepend,y,z,rest))

# Cubical identity itself is a lawful primitive-motion family. This is the
# smallest language-intrinsic instance: a transformation is admitted by
# constructing its path, not by an external certificate/check.
def PathStep(A: Set, x: A, y: A) -> Set:
  Path(A,x,y)

def pathDerivation(A: Set, x: A, y: A, p: Path(A,x,y)) ->
  Derivation(A, PathStep(A), x, y):
  @then{y, p, @done{{==}}}

# Length/cost is one receiver of the same derivation.
def derivationLength(A: Set, Step: A -> A -> Set,
                     x: A, z: A, d: Derivation(A,Step,x,z)) -> Nat:
  match d:
    case @done{ez}: 0n
    case @then{y, step, rest}:
      1n + derivationLength(A,Step,y,z,rest)
