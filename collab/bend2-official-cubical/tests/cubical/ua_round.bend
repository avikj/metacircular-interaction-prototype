# the reverse univalence round trip, coherent: the equivalence read off
# ua(e) is e, for every equivalence (its function and its proof are
# template hypotheses: a theorem over every closed instance, used as often
# as the proof needs). The function agrees by computation (ua beta through
# the transported identity), the proof by isEquiv being a proposition.
import Base

def Bool.not.not(b: Bool) -> {Bool.not(Bool.not(b)) == b : Bool}:
  match b:
    case True{}:
      {==}
    case False{}:
      {==}

def notEquiv() -> Equiv(&2, &2, Bool, Bool):
  Equiv.from_iso(~Bool, ~Bool, ~Bool.not, ~Bool.not, ~Bool.not.not, ~Bool.not.not)

def Equiv.proof(a, b, -A: Kind(a), -B: Kind(b), e: Equiv(a, b, A, B)) -> isEquiv(a, b, A, B, Equiv.fun(a, b, A, B, e)):
  (f, h) = e
  h

law ua_round:
  for ~A: Data
  for ~B: Data
  for ~f: A -> B
  for ~h: isEquiv(&2, &2, A, B, f)
  {Equiv.of_path(&2, A, B, ua(&2, A, B, (f, h))) == (f, h) : Equiv(&2, &2, A, B)}

def ua_round(A, B, f, h):
  i => (f, isEquiv.prop(A, B, f, Equiv.proof(&2, &2, A, B, Equiv.of_path(&2, A, B, ua(&2, A, B, (f, h)))), h)(i))

# the forward round trip on the function, for an abstract equivalence
law ua_fun:
  for ~A: Data
  for ~B: Data
  for ~e: Equiv(&2, &2, A, B)
  for x: A
  {Equiv.fun(&2, &2, A, B, Equiv.of_path(&2, A, B, ua(&2, A, B, e)))(x) == Equiv.fun(&2, &2, A, B, e)(x) : B}

def ua_fun(A, B, e, x): {==}

def main() -> Bool:
  Equiv.fun(&2, &2, Bool, Bool, Equiv.of_path(&2, Bool, Bool, ua(&2, Bool, Bool, notEquiv())))(True{})

#|False{}
