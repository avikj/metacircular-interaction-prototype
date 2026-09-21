# formal/cubical/kernel/PvsNPGapLivesInTheForgetfulProjection.agda, in Bend.
import GenerativeKernel

# §1 the carried model has no gap: the answer is projection, definitionally
def answer_is_projection_general(s: Tm, f: EnabledFuture(s)) -> Path(Tm, cfTarget(s, execute(s, f)), efTarget(s, f)):
  <_> efTarget(s, f)
def answer_is_projection() -> Path(Tm, cfTarget(seed(), execute(seed(), direct_future())), target0()):
  <_> target0()
def route_is_carried() -> Derivation(seed(), cfTarget(seed(), execute(seed(), direct_future()))):
  cfDerivation(seed(), execute(seed(), direct_future()))

# §2 the gap lives in the forgetful image
def len(a: Tm, b: Tm, d: Derivation(a, b)) -> Nat:
  match d:
    case @done{e}: 0n
    case @then{y, s, d2}: 1n + len(y, b, d2)
def len_direct() -> Path(Nat, len(seed(), target0(), direct_history()), 2n):
  <_> 2n
def len_detour() -> Path(Nat, len(seed(), target0(), detour_history()), 4n):
  <_> 4n

# the forgetful semantics is blind to the route: Nat is a set
def forgetful_is_blind_to_route(a: Tm, b: Tm, d: Derivation(a, b), e: Derivation(a, b), r: Env) -> Path(Path(Nat, eval(a, r), eval(b, r)), derivation_sound(a, b, d, r), derivation_sound(a, b, e, r)):
  isSetNat(eval(a, r), eval(b, r), derivation_sound(a, b, d, r), derivation_sound(a, b, e, r))
def forgetful_image_is_blind_to_route(r: Env) -> Path(Path(Nat, eval(seed(), r), eval(target0(), r)), derivation_sound(seed(), target0(), direct_history(), r), derivation_sound(seed(), target0(), detour_history(), r)):
  forgetful_is_blind_to_route(seed(), target0(), direct_history(), detour_history(), r)

def main() -> Nat:
  len(seed(), target0(), detour_history())
