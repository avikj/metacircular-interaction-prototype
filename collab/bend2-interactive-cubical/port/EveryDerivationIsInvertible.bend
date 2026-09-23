# formal/cubical/kernel-flat/EveryDerivationIsInvertible.agda, in Bend: the calculus is a groupoid, reversal is grade-preserving.
import RewriteCertificate

def len(a: Tm, b: Tm, d: Derivation(a, b)) -> Nat:
  match d:
    case @done{e}: 0n
    case @then{y, s, d2}: 1n + len(y, b, d2)

def concat(a: Tm, b: Tm, c: Tm, d: Derivation(a, b), e: Derivation(b, c)) -> Derivation(a, c):
  match d:
    case @done{eq}:
      match eq: case {==}: e
    case @then{y, s, d2}: @then{y, s, concat(y, b, c, d2, e)}

def len_concat(a: Tm, b: Tm, c: Tm, d: Derivation(a, b), e: Derivation(b, c)) -> Path(Nat, len(a, c, concat(a, b, c, d, e)), add(len(a, b, d), len(b, c, e))):
  match d:
    case @done{eq}:
      match eq: case {==}: <_> len(a, c, e)
    case @then{y, s, d2}: <i> 1n + (len_concat(y, b, c, d2, e) @ i)

# the inverse derivation: every derivation runs backwards
def revD(a: Tm, b: Tm, d: Derivation(a, b)) -> Derivation(b, a):
  match d:
    case @done{eq}:
      match eq: case {==}: @done{{==}}
    case @then{y, s, d2}: concat(b, y, a, revD(y, b, d2), @then{a, @reverse{s}, @done{{==}}})

# grade-preserving: the inverse has exactly the same length
def len_revD(a: Tm, b: Tm, d: Derivation(a, b)) -> Path(Nat, len(b, a, revD(a, b, d)), len(a, b, d)):
  match d:
    case @done{eq}:
      match eq: case {==}: <_> 0n
    case @then{y, s, d2}:
      compPath(Nat, len(b, a, concat(b, y, a, revD(y, b, d2), @then{a, @reverse{s}, @done{{==}}})), add(len(b, y, revD(y, b, d2)), 1n), 1n + len(y, b, d2),
        len_concat(b, y, a, revD(y, b, d2), @then{a, @reverse{s}, @done{{==}}}),
        compPath(Nat, add(len(b, y, revD(y, b, d2)), 1n), add(len(y, b, d2), 1n), 1n + len(y, b, d2),
          <i> add(len_revD(y, b, d2) @ i, 1n),
          compPath(Nat, add(len(y, b, d2), 1n), 1n + add(len(y, b, d2), 0n), 1n + len(y, b, d2),
            plusSuc(len(y, b, d2), 0n),
            <i> 1n + (plusZero(len(y, b, d2)) @ i))))

# semantically the inverse: meaning lands in a set
def revD_sound(a: Tm, b: Tm, d: Derivation(a, b), r: Env) -> Path(Path(Nat, eval(b, r), eval(a, r)), derivation_sound(b, a, revD(a, b, d), r), <i> derivation_sound(a, b, d, r) @ inot(i)):
  isSetNat(eval(b, r), eval(a, r), derivation_sound(b, a, revD(a, b, d), r), <i> derivation_sound(a, b, d, r) @ inot(i))

def main() -> Nat:
  0n
