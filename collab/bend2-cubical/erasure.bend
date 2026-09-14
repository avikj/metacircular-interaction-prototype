# Erasure = descent, decided by the substrate (not a heuristic).
# q : A -> A/R is an erasure (it forgets the distinctions R identifies).
# A computation t : A -> V may run after erasure  IFF  t factors through q,
# i.e. t descends: it never uses a distinction R destroys. The recursor's resp
# obligation IS that descent condition, so the factorization type-checks exactly
# when erasure is sound and is REJECTED exactly when it is not. No "erase if
# outputs look equal" — the substrate computes descent.

def Unit() -> Set:
  all A: Set. A -> A

# R = the TOTAL relation on Bool: everything identified. So q : Bool -> Bool/R
# collapses Bool to a single class (maximal erasure).
def R(x: Bool, y: Bool) -> Set:
  Unit
def Q() -> Set:
  Quot(Bool, R)

# --- t_good : uses no distinction R destroys (constant) -> DESCENDS ---
def tgood(x: Bool) -> Bool:
  True
def tgoodResp(x: Bool, y: Bool, w: R(x,y)) -> Path(Bool, tgood(x), tgood(y)):
  <_> True
# erasure is SOUND: t_good runs after collapsing Bool to a point. Type-checks.
def erase_good(setB: Nat, q: Q) -> Bool:
  qrec(q, setB, tgood, tgoodResp)

# --- t_bad = identity : uses exactly the distinction R destroys -> does NOT descend ---
def tbad(x: Bool) -> Bool:
  x
# to erase t_bad we would need it constant on R-classes: Path(Bool, x, y) from
# R x y. That is False (True is not False), so no descent witness exists. Any
# attempt (a fake resp) is rejected — erasure that destroys a used distinction
# is caught, not silently taken.
def tbadResp(x: Bool, y: Bool, w: R(x,y)) -> Path(Bool, tbad(x), tbad(y)):
  <_> x
def erase_bad(setB: Nat, q: Q) -> Bool:
  qrec(q, setB, tbad, tbadResp)

# Coherence sharpening (the circle-doubling case): when V is a higher type, the
# descent witness resp is a PATH, not an equation, and pointwise agreement is
# insufficient — the coherence must descend too. That is exactly why effectivity
# needed toPathP (coherent descent through the quotient's path constructor): a
# locally plausible erasure can preserve pointwise reconstruction while destroying
# the loop-level coherence a globally lawful computation uses. So the runtime rule
# is: erase through q IFF the dependent computation coherently descends through q.

def main() -> Nat:
  0n
