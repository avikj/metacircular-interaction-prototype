# function extensionality is a path lambda: a path between functions is a
# function of the dimension whose faces are the two functions
type N is Data:
  Z{}
  S{p: N}

law add:
  for n: N
  for m: N
  N

def add(n, m):
  match n:
    case Z{}:
      m
    case S{k}:
      S{add(k, m)}

law add_zero:
  for n: N
  {add(n, Z{}) == n : N}

def add_zero(n):
  match n:
    case Z{}:
      {==}
    case S{k}:
      %add_zero(k) : {S{add(k, Z{})} == S{_} : N}; {==}

law add_zero_eta:
  {(x => add(x, Z{})) == (x => x) : N -> N}

def add_zero_eta(): i => x => add_zero(x)(i)

law sym:
  for -A: Type
  for -a: A
  for -b: A
  for p: {a == b : A}
  {b == a : A}

def sym(A, a, b, p): i => p(-i)

law cong:
  for -A: Type
  for -B: Type
  for f: A -> B
  for -a: A
  for -b: A
  for p: {a == b : A}
  {f(a) == f(b) : B}

def cong(A, B, f, a, b, p): i => f(p(i))

law main:
  N

def main(): add_zero_eta()(i0)(S{S{Z{}}})

#|S{S{Z{}}}
