# Dependent graph/fibre completion.
#
# For B : A -> Set and f : (a:A) -> B(a):
#
#   A ≃ Σ a:A. Σ b:B(a). Path(B(a), f(a), b)
#
# This is the dependent analogue of FibreElement. The inner based path space is
# contractible for each a, so no dependent section needs to be excluded from
# intrinsic lossless presentation.

type DependentFibreElement(A: Set, B: A -> Set, f: all a: A. B(a)):
  case @dependentFibreCarry:
    base: A
    carried: B(base)
    witness: Path(B(base), f(base), carried)

def dependentDescend(A: Set, B: A -> Set, f: all a: A. B(a), a: A) ->
  DependentFibreElement(A,B,f):
  @dependentFibreCarry{a, f(a), <_> f(a)}

def dependentAscend(A: Set, B: A -> Set, f: all a: A. B(a),
                    c: DependentFibreElement(A,B,f)) -> A:
  match c:
    case @dependentFibreCarry{base,carried,witness}: base

def dependentAscendDescend(A: Set, B: A -> Set, f: all a: A. B(a), a: A) ->
  Path(A, dependentAscend(A,B,f,dependentDescend(A,B,f,a)), a):
  <_> a

def dependentObservedValue(A: Set, B: A -> Set, f: all a: A. B(a),
                           c: DependentFibreElement(A,B,f)) ->
  B(dependentAscend(A,B,f,c)):
  match c:
    case @dependentFibreCarry{base,carried,witness}: carried
