# formal/cubical/kernel/ClosedAdditionCostIsLinear.agda, in Bend: a closed sum
# unary a + unary b reduces to its normal form in b+1 steps.
import WindingCostIsUnarySize

def addClosed(a: Nat, b: Nat) -> Derivation(@add{unary(a), unary(b)}, iterSuc(b, unary(a))):
  match b:
    case 0n: @then{unary(a), @add_zero{unary(a), {==}, {==}}, @done{{==}}}
    case 1n + m: @then{@suc{@add{unary(a), unary(m)}}, @add_suc{unary(a), unary(m), {==}, {==}},
                   underSuc(@add{unary(a), unary(m)}, iterSuc(m, unary(a)), addClosed(a, m))}

# cost = b+1, linear in the second operand's unary size
def len_addClosed(a: Nat, b: Nat) -> Path(Nat, len(@add{unary(a), unary(b)}, iterSuc(b, unary(a)), addClosed(a, b)), 1n + b):
  match b:
    case 0n: <_> 1n
    case 1n + m:
      <i> 1n + (compPath(Nat,
                  len(@suc{@add{unary(a), unary(m)}}, @suc{iterSuc(m, unary(a))}, underSuc(@add{unary(a), unary(m)}, iterSuc(m, unary(a)), addClosed(a, m))),
                  len(@add{unary(a), unary(m)}, iterSuc(m, unary(a)), addClosed(a, m)),
                  1n + m,
                  len_underSuc(@add{unary(a), unary(m)}, iterSuc(m, unary(a)), addClosed(a, m)),
                  len_addClosed(a, m)) @ i)

def main() -> Nat:
  len(@add{unary(2n), unary(3n)}, iterSuc(3n, unary(2n)), addClosed(2n, 3n))
