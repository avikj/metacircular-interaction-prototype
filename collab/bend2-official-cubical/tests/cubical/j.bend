# J computes on every path, not only on {==}: a rewrite along a path is
# transport along the connection square, and the composite's faces are
# read off by evaluation
import Base

type N is Data:
  Z{}
  S{p: N}

# trans by J (Base's Equal.trans), applied to a path built from a hypothesis
law trans_face:
  for -A: Type
  for -a: A
  for -b: A
  for +p: {a == b : A}
  {Equal.trans(A, a, b, b, p, i => b)(i0) == a : A}

def trans_face(A, a, b, p): {==}

# a rewrite along a non-constant path: its left face is the rewritten
# term, by computation
law rw_face:
  for -a: N
  for -b: N
  for +p: {a == b : N}
  {Equal.sym(N, a, b, p)(i0) == b : N}

def rw_face(a, b, p): {==}

# transport along a line of path types computes on the faces
law coe_path_face:
  for -A: Type
  for -a: A
  for -b: A
  for -c: A
  for +p: {a == b : A}
  for +q: {b == c : A}
  {coe(i => {a == q(i) : A}, i0, i1, p)(i1) == c : A}

def coe_path_face(A, a, b, c, p, q): {==}

def main() -> N:
  Equal.trans(N, S{Z{}}, S{Z{}}, S{Z{}}, i => S{Z{}}, i => S{Z{}})(i0)

#|S{Z{}}
