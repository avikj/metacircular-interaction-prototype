# formal/cubical/kernel/MultiplicationUnfoldsInLinearPeels.agda, in Bend:
# mul x (unary b) unfolds into b right-nested copies of x in exactly b+1 steps.
import RewriteCertificateMul

def lenM(a: TmM, b: TmM, d: DerivationM(a, b)) -> Nat:
  match d:
    case @done_m{e}: 0n
    case @then_m{y, s, d2}: 1n + lenM(y, b, d2)

def unaryM(n: Nat) -> TmM:
  match n:
    case 0n: @zero_m
    case 1n + p: @suc_m{unaryM(p)}

# congruence lift on the left of an add, length preserved
def underAddLM(a: TmM, b: TmM, d: DerivationM(a, b), z: TmM) -> DerivationM(@add_m{a, z}, @add_m{b, z}):
  match d:
    case @done_m{eq}:
      match eq: case {==}: @done_m{{==}}
    case @then_m{y, s, d2}: @then_m{@add_m{y, z}, @add_left_m{a, y, s, z, {==}, {==}}, underAddLM(y, b, d2, z)}

def len_underAddLM(a: TmM, b: TmM, d: DerivationM(a, b), z: TmM) -> Path(Nat, lenM(@add_m{a, z}, @add_m{b, z}, underAddLM(a, b, d, z)), lenM(a, b, d)):
  match d:
    case @done_m{eq}:
      match eq: case {==}: <_> 0n
    case @then_m{y, s, d2}: <i> 1n + (len_underAddLM(y, b, d2, z) @ i)

# b right-nested copies of x
def copies(x: TmM, n: Nat) -> TmM:
  match n:
    case 0n: @zero_m
    case 1n + p: @add_m{copies(x, p), x}

# THE PEEL: mul x (unary b) unfolds to b copies of x in b+1 steps
def mulPeel(x: TmM, b: Nat) -> DerivationM(@mul_m{x, unaryM(b)}, copies(x, b)):
  match b:
    case 0n: @then_m{@zero_m, @mul_zero_m{x, {==}, {==}}, @done_m{{==}}}
    case 1n + m: @then_m{@add_m{@mul_m{x, unaryM(m)}, x}, @mul_suc_m{x, unaryM(m), {==}, {==}},
                   underAddLM(@mul_m{x, unaryM(m)}, copies(x, m), mulPeel(x, m), x)}

# cost of the multiplicative layer = number of factors (+1)
def len_mulPeel(x: TmM, b: Nat) -> Path(Nat, lenM(@mul_m{x, unaryM(b)}, copies(x, b), mulPeel(x, b)), 1n + b):
  match b:
    case 0n: <_> 1n
    case 1n + m:
      <i> 1n + (compPath(Nat,
                  lenM(@add_m{@mul_m{x, unaryM(m)}, x}, @add_m{copies(x, m), x}, underAddLM(@mul_m{x, unaryM(m)}, copies(x, m), mulPeel(x, m), x)),
                  lenM(@mul_m{x, unaryM(m)}, copies(x, m), mulPeel(x, m)),
                  1n + m,
                  len_underAddLM(@mul_m{x, unaryM(m)}, copies(x, m), mulPeel(x, m), x),
                  len_mulPeel(x, m)) @ i)

def main() -> Nat:
  lenM(@mul_m{@var_m, unaryM(3n)}, copies(@var_m, 3n), mulPeel(@var_m, 3n))
