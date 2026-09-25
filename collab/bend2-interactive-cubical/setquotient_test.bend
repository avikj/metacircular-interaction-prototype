# SetQuotient HIT in Bend2-cubical (CCHM).
# Formers: Quot(A,R) type, qcl(a) point ctor, qeq(a,b,r) path ctor,
#          qrec(x, setB, fp, fe) recursor into a set (setB : isSet B).
# Acceptance: the point β-rule and the path (cong) β-rule both hold
# definitionally, witnessed by refl.

def isSet(A: Set) -> Set:
  all x: A. all y: A. all p: Path(A,x,y). all q: Path(A,x,y). Path(Path(A,x,y), p, q)

# The quotient type former.
def MyQuot(A: Set, R: A -> A -> Set) -> Set:
  Quot(A, R)

# Point constructor [ a ] : A / R.
def inj(A: Set, R: A -> A -> Set, a: A) -> Quot(A, R):
  qcl(a)

# Path constructor eq/ a b r : Path(A/R, [a], [b]).
def link(A: Set, R: A -> A -> Set, a: A, b: A, r: R(a, b)) -> Path(Quot(A, R), qcl(a), qcl(b)):
  qeq(a, b, r)

# Recursor into a set B.
def rec(A: Set, R: A -> A -> Set, B: Set, setB: isSet(B), fp: A -> B,
        fe: all a: A. all b: A. all r: R(a, b). Path(B, fp(a), fp(b)),
        x: Quot(A, R)) -> B:
  qrec(x, setB, fp, fe)

# Point β-rule: qrec([a], setB, fp, fe) ≡ fp(a). Witnessed by refl. (A quotient
# point is check-mode: it needs R, so it is stated through rec's typed argument.)
def rec_point_beta(A: Set, R: A -> A -> Set, B: Set, setB: isSet(B), fp: A -> B,
                   fe: all a: A. all b: A. all r: R(a, b). Path(B, fp(a), fp(b)),
                   a: A) -> Path(B, rec(A, R, B, setB, fp, fe, qcl(a)), fp(a)):
  <i> fp(a)

# Path (cong) β-rule: the recursor pushed through the path constructor is the
# supplied fe. Its boundary [a]↦fp(a), [b]↦fp(b) holds by the point β-rule.
def rec_path_lam(A: Set, R: A -> A -> Set, B: Set, setB: isSet(B), fp: A -> B,
                 fe: all a: A. all b: A. all r: R(a, b). Path(B, fp(a), fp(b)),
                 a: A, b: A, r: R(a, b)) -> Path(B, fp(a), fp(b)):
  <i> rec(A, R, B, setB, fp, fe, link(A, R, a, b, r) @ i)

# ...and it is definitionally equal to fe(a,b,r) itself.
def rec_path_beta(A: Set, R: A -> A -> Set, B: Set, setB: isSet(B), fp: A -> B,
                  fe: all a: A. all b: A. all r: R(a, b). Path(B, fp(a), fp(b)),
                  a: A, b: A, r: R(a, b))
  -> Path(Path(B, fp(a), fp(b)),
          rec_path_lam(A, R, B, setB, fp, fe, a, b, r),
          fe(a, b, r)):
  <k> fe(a, b, r)

def main() -> Nat:
  0n
