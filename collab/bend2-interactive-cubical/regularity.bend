# ua DERIVED from Glue, and transport through it computing (the Kan rule).
def isContr(A: Set) -> Set:
  any c: A. (all x: A. Path(A, c, x))
def fiber(A: Set, B: Set, f: A -> B, y: B) -> Set:
  any x: A. Path(B, f(x), y)
def isEquiv(A: Set, B: Set, f: A -> B) -> Set:
  all y: B. isContr(fiber(A, B, f, y))
def Equiv(A: Set, B: Set) -> Set:
  any f: A -> B. isEquiv(A, B, f)
def isContrSingl(A: Set, a: A) -> isContr(fiber(A, A, lambda x. x, a)):
  ( (a, <_> a)
  , lambda w.
      match w:
        case (x, p):
          <i> ( p @ inot(i) , <j> p @ ior(inot(i), j) )
  )
def idEquiv(A: Set) -> Equiv(A, A):
  ( lambda x. x , lambda y. isContrSingl(A, y) )
def fstE(A: Set, B: Set, e: Equiv(A, B)) -> (A -> B):
  match e:
    case (f, _):
      f

# ---------------------------------------------------------------------------
# WHAT THE REGULARITY TEST ACTUALLY DECIDES
#
# `whnfCoe` applies the line to a marker dimension, NORMALISES, and fires the
# identity rule when the marker is gone. That is constancy up to the checker's
# own conversion, not "the variable does not literally occur" -- each case
# below mentions the dimension in the source and still transports as the
# identity, definitionally.
# ---------------------------------------------------------------------------

# 1. literally constant
def reg_literal(A: Set, a: A) -> Path(A, coe(lambda k. A, i0, i1, a), a):
  <_> a

# 2. constant only after unfolding a definition that discards the dimension
def pick(A: Set, k: Interval) -> Set:
  A

def reg_unfold(A: Set, a: A) -> Path(A, coe(lambda k. pick(A, k), i0, i1, a), a):
  <_> a

# 3. the dimension survives inside a De Morgan meet that is NOT i0 -- in a
#    De Morgan algebra k AND NOT k is its own element -- and the line is
#    still recognised as constant
def reg_demorgan(A: Set, a: A) -> Path(A, coe(lambda k. pick(A, iand(k, inot(k))), i0, i1, a), a):
  <_> a

# 4. a composite whose two tube faces and cap all give A. `k OR NOT k` is not
#    i1, so the hcomp does not collapse by a true face; it is still constant.
def reg_hcomp(A: Set, a: A) -> Path(A, coe(lambda k. hcompN(Set, [(k, <_> A), (inot(k), <_> A)], A), i0, i1, a), a):
  <_> a

# 5. a Glue line whose faces are both the identity equivalence on A. Again the
#    cofibration is not i1, so the Glue is canonical as an open term.
def reg_glue(A: Set, a: A) -> Path(A, coe(lambda k. Glue(A, [(k, A, idEquiv(A)), (inot(k), A, idEquiv(A))]), i0, i1, a), a):
  <_> a
