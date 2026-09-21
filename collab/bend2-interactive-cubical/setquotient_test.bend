# SetQuotient HIT in Bend2-cubical (CCHM).
# Formers: Quotient(A,R) type, qin(a) point ctor, qeq(a,b,r) path ctor,
#          qelim(x, fp, fe) recursor into a set.
# Acceptance: the point β-rule and the path (cong) β-rule both hold
# definitionally, witnessed by refl.

# The quotient type former.
def MyQuot(A: Set, R: A -> A -> Set) -> Set:
  Quotient(A, R)

# Point constructor [ a ] : A / R.
def inj(A: Set, R: A -> A -> Set, a: A) -> Quotient(A, R):
  qin(a)

# Path constructor eq/ a b r : Path(A/R, [a], [b]).
def link(A: Set, R: A -> A -> Set, a: A, b: A, r: R(a, b)) -> Path(Quotient(A, R), qin(a), qin(b)):
  qeq(a, b, r)

# Recursor into a set B.
def rec(A: Set, R: A -> A -> Set, B: Set, fp: A -> B,
        fe: all a: A. all b: A. all r: R(a, b). Path(B, fp(a), fp(b)),
        x: Quotient(A, R)) -> B:
  qelim(x, fp, fe)

# Point β-rule: qelim([a], fp, fe) ≡ fp(a). Witnessed by refl.
def rec_point_beta(A: Set, R: A -> A -> Set, B: Set, fp: A -> B,
                   fe: all a: A. all b: A. all r: R(a, b). Path(B, fp(a), fp(b)),
                   a: A) -> Path(B, qelim(qin(a), fp, fe), fp(a)):
  <i> fp(a)

# Path (cong) β-rule: the recursor pushed through the path constructor is the
# supplied fe. Its boundary [a]↦fp(a), [b]↦fp(b) holds by the point β-rule.
def rec_path_lam(A: Set, R: A -> A -> Set, B: Set, fp: A -> B,
                 fe: all a: A. all b: A. all r: R(a, b). Path(B, fp(a), fp(b)),
                 a: A, b: A, r: R(a, b)) -> Path(B, fp(a), fp(b)):
  <i> qelim(qeq(a, b, r) @ i, fp, fe)

# ...and it is definitionally equal to fe(a,b,r) itself.
def rec_path_beta(A: Set, R: A -> A -> Set, B: Set, fp: A -> B,
                  fe: all a: A. all b: A. all r: R(a, b). Path(B, fp(a), fp(b)),
                  a: A, b: A, r: R(a, b))
  -> Path(Path(B, fp(a), fp(b)),
          rec_path_lam(A, R, B, fp, fe, a, b, r),
          fe(a, b, r)):
  <k> fe(a, b, r)

def main() -> Nat:
  0n
