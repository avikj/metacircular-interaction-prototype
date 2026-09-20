# Pushout of a span: a path constructor with a field AND parameters used in its endpoints.
type Pushout(A: Set, B: Set, C: Set, f: C -> A, g: C -> B):
  case @inl:
    a: A
  case @inr:
    b: B
  path @glue(c: C): Path(Pushout(A, B, C, f, g), @inl{f(c)}, @inr{g(c)})

def glue0(A: Set, B: Set, C: Set, f: C -> A, g: C -> B, c: C) -> Path(Pushout(A, B, C, f, g), @glue{c} @ i0, @inl{f(c)}):
  <_> @inl{f(c)}

def poRec(A: Set, B: Set, C: Set, f: C -> A, g: C -> B, D: Set, l: A -> D, r: B -> D, h: all c: C. Path(D, l(f(c)), r(g(c))), x: Pushout(A, B, C, f, g)) -> D:
  hrec(x) { @inl: l ; @inr: r ; @glue: h }

def poRec_glue(A: Set, B: Set, C: Set, f: C -> A, g: C -> B, D: Set, l: A -> D, r: B -> D, h: all c: C. Path(D, l(f(c)), r(g(c))), c: C) -> Path(Path(D, l(f(c)), r(g(c))), <i> poRec(A, B, C, f, g, D, l, r, h, (@glue{c}::Pushout(A, B, C, f, g)) @ i), h(c)):
  <_> h(c)

def main() -> Nat:
  0n

# endpoints that MENTION the parameters need them: annotate the constructor
def poRec_glue2(A: Set, B: Set, C: Set, f: C -> A, g: C -> B, D: Set, l: A -> D, r: B -> D, h: all c: C. Path(D, l(f(c)), r(g(c))), c: C) -> Path(Path(D, l(f(c)), r(g(c))), <i> poRec(A, B, C, f, g, D, l, r, h, (@glue{c}::Pushout(A, B, C, f, g)) @ i), h(c)):
  <_> h(c)
