# inS must REJECT an element that is not definitionally u on the face.
def badTrue(A: Set, u: A, x: A) -> Sub(A, i1, u):
  inS(x)
def badSym(A: Set, p: Interval, u: A, x: A) -> Sub(A, p, u):
  inS(x)
