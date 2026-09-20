# The fibre law run on the compiled lanes: present is the factoring and
# retrieve after present is the identity, at f = not.
# The fibre law, lossless: A ~ (&b: B -> fiber f b) for every f, as a
# coherent equivalence (Base's Equiv.from_iso: isoToIsEquiv), then ua of
# it: transport along the lossless path IS the factoring a => (f(a), a,
# {==}), and back is the identity, by computation. Functions are template
# parameters (a closure is affine; a template is a theorem), and the
# carriers are Data (a point is reused).
import Base

# --- the fibre law: Total(f) = &b: B -> fiber(A, B, f, b), a Data type
# when A and B are (a point of it is reused by the fillers)
def Total(-A: Data, -B: Data, f: A -> B) -> Data:
  Sigma<&2, &2, B, b => Sigma<&2, &2, A, x => {f(x) == b : B}>>

def tot(~A: Data, ~B: Data, ~f: A -> B, a: A) -> Total(A, B, f):
  +a = a
  (f(a), a, {==})

def untot(~A: Data, ~B: Data, ~f: A -> B, w: Total(A, B, f)) -> A:
  (b, a, q) = w
  a

def tot_sec(~A: Data, ~B: Data, ~f: A -> B, w: Total(A, B, f)) -> {tot(~A, ~B, ~f, untot(~A, ~B, ~f, w)) == w : Total(A, B, f)}:
  (b, +a, +q) = w
  i => (q(i), a, j => q(i /\ j))

def tot_ret(~A: Data, ~B: Data, ~f: A -> B, a: A) -> {untot(~A, ~B, ~f, tot(~A, ~B, ~f, a)) == a : A}:
  {==}

def totalEquiv(~A: Data, ~B: Data, ~f: A -> B) -> Equiv(A, Total(A, B, f)):
  Equiv.from_iso(~A, ~Total(A, B, f), ~tot(~A, ~B, ~f), ~untot(~A, ~B, ~f), ~tot_sec(~A, ~B, ~f), ~tot_ret(~A, ~B, ~f))

def losslessPath(~A: Data, ~B: Data, ~f: A -> B) -> {A == Total(A, B, f) : Type}:
  ua(A, Total(A, B, f), totalEquiv(~A, ~B, ~f))

def present(~A: Data, ~B: Data, ~f: A -> B, a: A) -> Total(A, B, f):
  coe(losslessPath(~A, ~B, ~f), i0, i1, a)

def retrieve(~A: Data, ~B: Data, ~f: A -> B, w: Total(A, B, f)) -> A:
  coe(losslessPath(~A, ~B, ~f), i1, i0, w)

# transport along the fibre-law path IS the factoring (ua beta), and back
law present_is_tot:
  for ~A: Data
  for ~B: Data
  for ~f: A -> B
  for +a: A
  {present(~A, ~B, ~f, a) == tot(~A, ~B, ~f, a) : Total(A, B, f)}

def present_is_tot(A, B, f, a): {==}

# the instance f = not on Bool, run
def visible(w: Total(Bool, Bool, Bool.not)) -> Bool & Bool:
  (b, a, q) = w
  (b, a)

def presentNot(x: Bool) -> Bool & Bool:
  visible(present(~Bool, ~Bool, ~Bool.not, x))

def retrieveNot(x: Bool) -> Bool:
  retrieve(~Bool, ~Bool, ~Bool.not, present(~Bool, ~Bool, ~Bool.not, x))

def showPair(p: Bool & Bool) -> String:
  (b, a) = p
  Bool.show(b) ++ " " ++ Bool.show(a)

def main() -> IO(Unit):
  do IO<Unit>:
    IO.print(showPair(presentNot(True{})) ++ " " ++ Bool.show(retrieveNot(True{})) ++ " " ++ Bool.show(retrieveNot(False{})))

#|False True True False
