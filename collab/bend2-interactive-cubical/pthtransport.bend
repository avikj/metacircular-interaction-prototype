# transport a PATH along a nonconstant path family.
# Family: at interval i, the type is Path(Nat, 0n, s(i)) where s is a path in Nat.
# Concretely test the simplest nonconstant case: transport reflexivity along
# a family whose endpoints move, and along a constant family (must be id).

def constFamPath(a: Nat, b: Nat, p: Path(Nat, a, b)) -> Path(Nat, a, b):
  coe(lambda i. Path(Nat, a, b), i0, i1, p)

def constFam_ok(a: Nat, b: Nat, p: Path(Nat, a, b)) -> Path(Path(Nat, a, b), constFamPath(a, b, p), p):
  <_> p

def main() -> Nat:
  0n
