# formal/cubical/kernel/WindingCostIsCarriedAndCompressionDropsIt.agda, in Bend.
# The winding derivation is sound (its endpoints compress to one value) yet
# carries length n+1: the cost lives in the trace, and the compression drops it.
import TheCompressionIsTheForgetfulProjection

def winding_is_sound(n: Nat) -> Path(Nat, compress(@add{@var, unary(n)}), compress(iterSuc(n, @var))):
  derivation_sound(@add{@var, unary(n)}, iterSuc(n, @var), addTower(n), rho0())

# COST CARRIED, VALUE BLIND
def cost_is_carried_value_is_blind(n: Nat) -> any c: Path(Nat, len(@add{@var, unary(n)}, iterSuc(n, @var), addTower(n)), 1n + n). Path(Nat, compress(@add{@var, unary(n)}), compress(iterSuc(n, @var))):
  (winding_cost_is_unary_size(n), winding_is_sound(n))

def main() -> Nat:
  compress(iterSuc(4n, @var))
