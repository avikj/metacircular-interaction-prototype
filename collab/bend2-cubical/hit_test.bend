# Propositional truncation ∥A∥ and the circle S¹ (CCHM HITs) in Bend2-cubical.
# Acceptance: every constructor types, and each recursor's computation rules
# hold definitionally (witnessed by refl).

# ---- Propositional truncation ∥A∥ ----

def MyTrunc(A: Set) -> Set:
  Trunc(A)

def tunit(A: Set, a: A) -> Trunc(A):
  tin(a)

# squash: any two elements of ∥A∥ are equal.
def tsquash_path(A: Set, x: Trunc(A), y: Trunc(A)) -> Path(Trunc(A), x, y):
  tsquash(x, y)

# recursor into a proposition P (fq : isProp P).
def trec(A: Set, P: Set, fp: A -> P, fq: all u: P. all v: P. Path(P, u, v),
         x: Trunc(A)) -> P:
  telim(x, fp, fq)

# point β-rule: telim(|a|, fp, fq) ≡ fp(a). Witnessed by refl.
def trec_beta(A: Set, P: Set, fp: A -> P, fq: all u: P. all v: P. Path(P, u, v),
              a: A) -> Path(P, telim(tin(a), fp, fq), fp(a)):
  <i> fp(a)

# ---- Circle S¹ ----

def circ_base() -> S1:
  s1base

def circ_loop() -> Path(S1, s1base, s1base):
  s1loop

# recursor into B: s1base ↦ b, s1loop ↦ l.
def crec(B: Set, b: B, l: Path(B, b, b), x: S1) -> B:
  celim(x, b, l)

# s1base β-rule: celim(s1base, b, l) ≡ b. Witnessed by refl.
def crec_base_beta(B: Set, b: B, l: Path(B, b, b))
  -> Path(B, celim(s1base, b, l), b):
  <i> b

# s1loop β-rule: celim(s1loop @ i, b, l) ≡ l @ i. Its boundary s1base↦b holds by the
# s1base β-rule.
def crec_loop_lam(B: Set, b: B, l: Path(B, b, b)) -> Path(B, b, b):
  <i> celim(s1loop @ i, b, l)

# ...and pushing the recursor through s1loop is definitionally l itself.
def crec_loop_beta(B: Set, b: B, l: Path(B, b, b))
  -> Path(Path(B, b, b), crec_loop_lam(B, b, l), l):
  <k> l

def main() -> Nat:
  0n
