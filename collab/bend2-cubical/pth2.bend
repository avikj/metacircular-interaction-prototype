# genuinely nonconstant path family: endpoints move along q.
# family i := Path(Nat, q@i, q@i);  at i0: Path(a,a), at i1: Path(b,b).
# transport refl(a) along it should land in Path(b,b).
def moveRefl(a: Nat, b: Nat, q: Path(Nat, a, b)) -> Path(Nat, b, b):
  coe(lambda i. Path(Nat, q @ i, q @ i), i0, i1, <_> a)
def main() -> Nat:
  0n
