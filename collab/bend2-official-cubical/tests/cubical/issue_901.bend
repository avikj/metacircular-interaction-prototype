# issue 901: a product over a family indexed twice (Mat(r, c) matches r
# and c in a nest) died with a memory fault on the C lane from depth 2,
# unless a second recursion over the same constructors was reachable.
# The compiler's hotness walk of a family stuck on open indices stopped
# at the outer arm of the nest, so Rows, Cols and Quad were never heated
# and a shared operand was taken raw. A stuck match is every one of its
# arms' types, nested arms included. Prints 8^2 at depth 2 on all lanes.
import Base

law Mat:
  for r: Nat
  for c: Nat
  Data

type Mat.Leaf is Data:
  MatB{x: F32}

type Mat.Rows<-p: Nat, -c: Nat> is Data:
  MatR{top: Mat(p, c), bot: Mat(p, c)}

type Mat.Cols<-r: Nat, -q: Nat> is Data:
  MatC{left: Mat(r, q), right: Mat(r, q)}

type Mat.Quad<-p: Nat, -q: Nat> is Data:
  MatQ{tl: Mat(p, q), tr: Mat(p, q), bl: Mat(p, q), br: Mat(p, q)}

def Mat(r, c):
  match r c:
    case 0n 0n:
      Mat.Leaf
    case 1n+p 0n:
      Mat.Rows<p, 0n>
    case 0n 1n+q:
      Mat.Cols<0n, q>
    case 1n+p 1n+q:
      Mat.Quad<p, q>

def Mat.full(+r: Nat, +c: Nat, +x: F32) -> Mat(r, c):
  match r c:
    case 0n 0n:
      MatB{x}
    case 1n+p 0n:
      t b = Mat.full(p, 0n, x) Mat.full(p, 0n, x)
      MatR{t, b}
    case 0n 1n+q:
      l r2 = Mat.full(0n, q, x) Mat.full(0n, q, x)
      MatC{l, r2}
    case 1n+p 1n+q:
      a b c2 d = Mat.full(p, q, x) Mat.full(p, q, x) Mat.full(p, q, x) Mat.full(p, q, x)
      MatQ{a, b, c2, d}

def Mat.add(+r: Nat, +c: Nat, m: Mat(r, c), n: Mat(r, c)) -> Mat(r, c):
  match r c:
    case 0n 0n:
      MatB{x} = m
      MatB{y} = n
      MatB{(x + y : F32)}
    case 1n+p 0n:
      MatR{mt, mb} = m
      MatR{nt, nb} = n
      x y = Mat.add(p, 0n, mt, nt) Mat.add(p, 0n, mb, nb)
      MatR{x, y}
    case 0n 1n+q:
      MatC{ml, mr} = m
      MatC{nl, nr} = n
      x y = Mat.add(0n, q, ml, nl) Mat.add(0n, q, mr, nr)
      MatC{x, y}
    case 1n+p 1n+q:
      MatQ{ma, mb, mc, md} = m
      MatQ{na, nb, nc, nd} = n
      w x y z = Mat.add(p, q, ma, na) Mat.add(p, q, mb, nb) Mat.add(p, q, mc, nc) Mat.add(p, q, md, nd)
      MatQ{w, x, y, z}

def Mat.add4(+p: Nat, +q: Nat, a0: Mat(p, q), b0: Mat(p, q), a1: Mat(p, q), b1: Mat(p, q),
             a2: Mat(p, q), b2: Mat(p, q), a3: Mat(p, q), b3: Mat(p, q)) -> Mat(1n+p, 1n+q):
  w x y z = Mat.add(p, q, a0, b0) Mat.add(p, q, a1, b1) Mat.add(p, q, a2, b2) Mat.add(p, q, a3, b3)
  MatQ{w, x, y, z}

def Mat.add2r(+p: Nat, a0: Mat(p, 0n), b0: Mat(p, 0n), a1: Mat(p, 0n), b1: Mat(p, 0n)) -> Mat(1n+p, 0n):
  x y = Mat.add(p, 0n, a0, b0) Mat.add(p, 0n, a1, b1)
  MatR{x, y}

def Mat.add2c(+q: Nat, a0: Mat(0n, q), b0: Mat(0n, q), a1: Mat(0n, q), b1: Mat(0n, q)) -> Mat(0n, 1n+q):
  x y = Mat.add(0n, q, a0, b0) Mat.add(0n, q, a1, b1)
  MatC{x, y}

def Mat.sum(+r: Nat, +c: Nat, m: Mat(r, c)) -> F32:
  match r c:
    case 0n 0n:
      MatB{x} = m
      x
    case 1n+p 0n:
      MatR{t, b} = m
      x y = Mat.sum(p, 0n, t) Mat.sum(p, 0n, b)
      (x + y : F32)
    case 0n 1n+q:
      MatC{l, r2} = m
      x y = Mat.sum(0n, q, l) Mat.sum(0n, q, r2)
      (x + y : F32)
    case 1n+p 1n+q:
      MatQ{a, b, c2, d} = m
      w x y z = Mat.sum(p, q, a) Mat.sum(p, q, b) Mat.sum(p, q, c2) Mat.sum(p, q, d)
      ((w + x) + (y + z) : F32)

def Mat.matmul(+r: Nat, +k: Nat, +c: Nat, +a: Mat(r, k), +b: Mat(k, c)) -> Mat(r, c):
  match r k c:
    case 0n 0n 0n:
      MatB{x} = a
      MatB{y} = b
      MatB{(x * y : F32)}
    case 1n+p 0n 0n:
      MatR{at, ab} = a
      x y = Mat.matmul(p, 0n, 0n, at, b) Mat.matmul(p, 0n, 0n, ab, b)
      MatR{x, y}
    case 0n 0n 1n+s:
      MatC{bl, br} = b
      x y = Mat.matmul(0n, 0n, s, a, bl) Mat.matmul(0n, 0n, s, a, br)
      MatC{x, y}
    case 0n 1n+q 0n:
      MatC{al, ar} = a
      MatR{bt, bb} = b
      x y = Mat.matmul(0n, q, 0n, al, bt) Mat.matmul(0n, q, 0n, ar, bb)
      Mat.add(0n, 0n, x, y)
    case 1n+p 1n+q 0n:
      MatQ{a0, a1, a2, a3} = a
      MatR{bt, bb} = b
      p0 q0 p1 q1 = Mat.matmul(p, q, 0n, a0, bt) Mat.matmul(p, q, 0n, a1, bb) Mat.matmul(p, q, 0n, a2, bt) Mat.matmul(p, q, 0n, a3, bb)
      Mat.add2r(p, p0, q0, p1, q1)
    case 0n 1n+q 1n+s:
      MatC{al, ar} = a
      MatQ{b0, b1, b2, b3} = b
      p0 q0 p1 q1 = Mat.matmul(0n, q, s, al, b0) Mat.matmul(0n, q, s, ar, b2) Mat.matmul(0n, q, s, al, b1) Mat.matmul(0n, q, s, ar, b3)
      Mat.add2c(s, p0, q0, p1, q1)
    case 1n+p 0n 1n+s:
      MatR{at, ab} = a
      MatC{bl, br} = b
      w x y z = Mat.matmul(p, 0n, s, at, bl) Mat.matmul(p, 0n, s, at, br) Mat.matmul(p, 0n, s, ab, bl) Mat.matmul(p, 0n, s, ab, br)
      MatQ{w, x, y, z}
    case 1n+p 1n+q 1n+s:
      MatQ{a0, a1, a2, a3} = a
      MatQ{b0, b1, b2, b3} = b
      p0 q0 p1 q1 p2 q2 p3 q3 = Mat.matmul(p, q, s, a0, b0) Mat.matmul(p, q, s, a1, b2) Mat.matmul(p, q, s, a0, b1) Mat.matmul(p, q, s, a1, b3) Mat.matmul(p, q, s, a2, b0) Mat.matmul(p, q, s, a3, b2) Mat.matmul(p, q, s, a2, b1) Mat.matmul(p, q, s, a3, b3)
      Mat.add4(p, s, p0, q0, p1, q1, p2, q2, p3, q3)

def run(+d: Nat) -> F32:
  Mat.sum(d, d, Mat.matmul(d, d, d, Mat.full(d, d, 1.0), Mat.full(d, d, 1.0)))

def main() -> IO(Unit):
  IO.print(F32.show(run(2n)))

#|64
