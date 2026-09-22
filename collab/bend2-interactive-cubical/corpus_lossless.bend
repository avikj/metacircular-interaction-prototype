# The repo's lossless presentation lemma, in Bend2's fragment.
#
# Agda (cubical):  lossless : A ≃  B (fiber f),  a  (f a , a , refl)
# This file is the Eql + Sigma (pre-cubical) version: the section-retraction
# half and the visible-projection law.  The full coherent statement — the
# equivalence itself, its ua path, and transport along it — is fibrelaw.bend.

# Presentation of A through f: an observation b, a source a, a witness f a == b.
def Pres(A: Set, B: Set, f: A -> B) -> Set:
  any b: B. any a: A. B{f(a) == b}

# encode: the codec, a ↦ (f a, a, {==})
def encode(A: Set, B: Set, f: A -> B, a: A) -> Pres(A, B, f):
  (f(a), a, {==})

# decode: drop the determined fields
def decode(A: Set, B: Set, f: A -> B, p: Pres(A, B, f)) -> A:
  match p:
    case (b, a, e):
      a

# retraction: decode(encode(a)) == a, definitionally
def lossless_retract(A: Set, B: Set, f: A -> B, a: A) -> A{decode(A, B, f, encode(A, B, f, a)) == a}:
  {==}

# the observation is the visible projection, definitionally
def obs(A: Set, B: Set, f: A -> B, p: Pres(A, B, f)) -> B:
  match p:
    case (b, a, e):
      b

# the observation is the visible projection, definitionally
def visible_projection(A: Set, B: Set, f: A -> B, a: A) -> B{obs(A, B, f, encode(A, B, f, a)) == f(a)}:
  {==}

def main() -> Nat:
  0n

# section: encode(decode(p)) == p, by eliminating the witness (J).
# In cubical Agda this is  λ i → p i , a , λ j  p (i ∧ j).
def lossless_section(A: Set, B: Set, f: A -> B, p: Pres(A, B, f)) -> Pres(A, B, f){encode(A, B, f, decode(A, B, f, p)) == p}:
  match p:
    case (b, a, e):
      rewrite e
      finally
