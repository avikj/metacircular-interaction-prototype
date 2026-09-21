# Partial elements (CCHM): Partial(phi, A) is the type of elements of A defined
# only where phi holds; its inhabitants are SYSTEMS. pout extracts the value
# where the face is true. Systems must be well-typed on their own cells, agree
# on overlaps, and COVER phi.
def one_branch(A: Set, x: A) -> Partial(i1, A):
  system([(i1, x)])
# two branches that agree where they overlap
def two_branches(A: Set, i: Interval, x: A) -> Partial(ior(i, inot(i)), A):
  system([(i, x), (inot(i), x)])
# extraction on a true face
def extract(A: Set, x: A) -> A:
  pout(system([(i1, x)]))
def extract_is_x(A: Set, x: A) -> Path(A, pout(system([(i1, x)])), x):
  <_> x
def neg(b: Bool) -> Bool:
  if b:
    False
  else:
    True
def main() -> Bool:
  pout(system([(i1, neg(True))]))
