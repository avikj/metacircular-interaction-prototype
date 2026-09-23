# formal/cubical/kernel-flat/TheCompressionIsTheForgetfulProjection.agda, in Bend.
# eval at a fixed environment is the compression from a term to its value; its
# input-side fibre over a+b holds two provably distinct terms (the drop), while
# binding the output makes the fibre a contractible singleton (carrying is free).
import WindingCostIsUnarySize

def rho0() -> Env:
  @env{0n, 0n, 0n, 0n, 0n, 0n}

# THE COMPRESSION: a structured term to its value
def compress(t: Tm) -> Nat:
  eval(t, rho0())

def eval_unary(n: Nat) -> Path(Nat, compress(unary(n)), n):
  match n:
    case 0n: <_> 0n
    case 1n + p: <i> 1n + (eval_unary(p) @ i)

def eval_add_unary(a: Nat, b: Nat) -> Path(Nat, compress(@add{unary(a), unary(b)}), add(a, b)):
  <i> add(eval_unary(a) @ i, eval_unary(b) @ i)

# THE FIBRE of the compression over a value: the terms that reach it
def Fib(n: Nat) -> Set:
  any t: Tm. Path(Nat, compress(t), n)

def sum_in_fibre(a: Nat, b: Nat) -> Fib(add(a, b)):
  (@add{unary(a), unary(b)}, eval_add_unary(a, b))
def value_in_fibre(a: Nat, b: Nat) -> Fib(add(a, b)):
  (unary(add(a, b)), eval_unary(add(a, b)))

def isAddTag(t: Tm) -> Nat:
  match t:
    case @var{}: 0n
    case @yvar{}: 0n
    case @zvar{}: 0n
    case @uvar{}: 0n
    case @vvar{}: 0n
    case @wvar{}: 0n
    case @zero{}: 0n
    case @suc{a}: 0n
    case @add{l, r}: 1n

def tag_unary(n: Nat) -> Path(Nat, isAddTag(unary(n)), 0n):
  match n:
    case 0n: <_> 0n
    case 1n + p: <_> 0n

def fibTm(n: Nat, w: Fib(n)) -> Tm:
  fst(Tm, lambda t. Path(Nat, compress(t), n), w)

# the two are distinct terms (one is an add, the other never is)
def structured_ne_value(a: Nat, b: Nat, p: Path(Tm, fibTm(add(a, b), sum_in_fibre(a, b)), fibTm(add(a, b), value_in_fibre(a, b)))) -> Empty:
  natEncode(1n, 0n, compPath(Nat, 1n, isAddTag(unary(add(a, b))), 0n, <i> isAddTag(p @ i), tag_unary(add(a, b))))

# THE DROP, NAMED: the fibre over a+b contains two provably distinct terms
def compression_forgets_structure(a: Nat, b: Nat) -> any x: Fib(add(a, b)). any y: Fib(add(a, b)). (Path(Tm, fibTm(add(a, b), x), fibTm(add(a, b), y)) -> Empty):
  (sum_in_fibre(a, b), (value_in_fibre(a, b), lambda p. structured_ne_value(a, b, p)))

# THE CARRIED SIDE IS FREE: binding the output, the fibre is a singleton
def Carried() -> Set:
  any t: Tm. any n: Nat. Path(Nat, compress(t), n)
def carried_side_is_free() -> Equiv(Carried, Tm):
  isoToEquiv(Carried, Tm,
    lambda w. match w: case (t, s): t,
    lambda t. (t, (compress(t), <_> compress(t))),
    lambda t. <_> t,
    lambda w. match w: case (t, s): match s: case (n, p): <i> (t, (p @ i, <j> p @ iand(i, j))))

def main() -> Nat:
  compress(fibTm(add(2n, 3n), sum_in_fibre(2n, 3n)))
