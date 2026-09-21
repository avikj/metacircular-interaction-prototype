# The interval is a DE MORGAN algebra: meet and join are commutative,
# associative, idempotent and absorptive, with De Morgan negation -- but NO
# complement law (i and not i is NOT i0; that is what makes paths non-trivial).
# These all hold DEFINITIONALLY, so the checker sees through reassociation.
def comm_and(A: Set, x: A, i: Interval, j: Interval) -> Path(A, hcompN(A, [(iand(i,j), <_> x)], x), hcompN(A, [(iand(j,i), <_> x)], x)):
  <_> hcompN(A, [(iand(j,i), <_> x)], x)
def comm_or(A: Set, x: A, i: Interval, j: Interval) -> Path(A, hcompN(A, [(ior(i,j), <_> x)], x), hcompN(A, [(ior(j,i), <_> x)], x)):
  <_> hcompN(A, [(ior(j,i), <_> x)], x)
def assoc_and(A: Set, x: A, i: Interval, j: Interval, k: Interval) -> Path(A, hcompN(A, [(iand(iand(i,j),k), <_> x)], x), hcompN(A, [(iand(i,iand(j,k)), <_> x)], x)):
  <_> hcompN(A, [(iand(i,iand(j,k)), <_> x)], x)
def idem_and(A: Set, x: A, i: Interval) -> Path(A, hcompN(A, [(iand(i,i), <_> x)], x), hcompN(A, [(i, <_> x)], x)):
  <_> hcompN(A, [(i, <_> x)], x)
def idem_or(A: Set, x: A, i: Interval) -> Path(A, hcompN(A, [(ior(i,i), <_> x)], x), hcompN(A, [(i, <_> x)], x)):
  <_> hcompN(A, [(i, <_> x)], x)
# absorption: i and (i or j) = i
def absorb(A: Set, x: A, i: Interval, j: Interval) -> Path(A, hcompN(A, [(iand(i,ior(i,j)), <_> x)], x), hcompN(A, [(i, <_> x)], x)):
  <_> hcompN(A, [(i, <_> x)], x)
def main() -> Nat:
  0n
