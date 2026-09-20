# formal/cubical/kernel/WindingCostIsUnarySize.agda, in Bend: the winding to standpoint n costs n+1 steps.
import RewriteCertificate

def unary(n: Nat) -> Tm:
  match n:
    case 0n: @zero
    case 1n + p: @suc{unary(p)}
def iterSuc(n: Nat, t: Tm) -> Tm:
  match n:
    case 0n: t
    case 1n + p: @suc{iterSuc(p, t)}
def len(a: Tm, b: Tm, d: Derivation(a, b)) -> Nat:
  match d:
    case @done{e}: 0n
    case @then{y, s, d2}: 1n + len(y, b, d2)
def underSuc(a: Tm, b: Tm, d: Derivation(a, b)) -> Derivation(@suc{a}, @suc{b}):
  match d:
    case @done{eq}:
      match eq: case {==}: @done{{==}}
    case @then{y, s, d2}: @then{@suc{y}, @suc_step{a, y, s, {==}, {==}}, underSuc(y, b, d2)}
def len_underSuc(a: Tm, b: Tm, d: Derivation(a, b)) -> Path(Nat, len(@suc{a}, @suc{b}, underSuc(a, b, d)), len(a, b, d)):
  match d:
    case @done{eq}:
      match eq: case {==}: <_> 0n
    case @then{y, s, d2}: <i> 1n + (len_underSuc(y, b, d2) @ i)
def addTower(n: Nat) -> Derivation(@add{@var, unary(n)}, iterSuc(n, @var)):
  match n:
    case 0n: @then{@var, @add_zero{@var, {==}, {==}}, @done{{==}}}
    case 1n + m: @then{@suc{@add{@var, unary(m)}}, @add_suc{@var, unary(m), {==}, {==}}, underSuc(@add{@var, unary(m)}, iterSuc(m, @var), addTower(m))}
# cost = unary size: the winding costs exactly n+1 steps
def winding_cost_is_unary_size(n: Nat) -> Path(Nat, len(@add{@var, unary(n)}, iterSuc(n, @var), addTower(n)), 1n + n):
  match n:
    case 0n: <_> 1n
    case 1n + m:
      <i> 1n + (compPath(Nat, len(@suc{@add{@var, unary(m)}}, @suc{iterSuc(m, @var)}, underSuc(@add{@var, unary(m)}, iterSuc(m, @var), addTower(m))), len(@add{@var, unary(m)}, iterSuc(m, @var), addTower(m)), 1n + m,
                 len_underSuc(@add{@var, unary(m)}, iterSuc(m, @var), addTower(m)), winding_cost_is_unary_size(m)) @ i)
def main() -> Nat:
  len(@add{@var, unary(5n)}, iterSuc(5n, @var), addTower(5n))
