# formal/cubical/kernel/ForgetfulCompressionPricesTheDrop.agda, in Bend.
# The kernel's two histories between the same endpoints have equal image under
# the semantics (Nat is a set) and provably different length (2 vs 4).
import GenerativeKernel

def len(a: Tm, b: Tm, d: Derivation(a, b)) -> Nat:
  match d:
    case @done{e}: 0n
    case @then{y, s, d2}: 1n + len(y, b, d2)

def len_direct() -> Path(Nat, len(seed(), target0(), direct_history()), 2n):
  <_> 2n
def len_detour() -> Path(Nat, len(seed(), target0(), detour_history()), 4n):
  <_> 4n

def two_ne_four(p: Path(Nat, 2n, 4n)) -> Empty:
  natEncode(0n, 2n, <i> pred(pred(p @ i)))

# the route is genuinely dropped: distinct length ...
def route_length_differs(p: Path(Nat, len(seed(), target0(), direct_history()), len(seed(), target0(), detour_history()))) -> Empty:
  two_ne_four(p)

# ... but the forgetful semantics cannot tell them apart
def meaning_agrees(r: Env) -> Path(Path(Nat, eval(seed(), r), eval(target0(), r)), derivation_sound(seed(), target0(), direct_history(), r), derivation_sound(seed(), target0(), detour_history(), r)):
  isSetNat(eval(seed(), r), eval(target0(), r), derivation_sound(seed(), target0(), direct_history(), r), derivation_sound(seed(), target0(), detour_history(), r))

# packaged: the compression collapses a distinction that is real in the calculus
def the_drop_is_real_and_priced() -> any d: (Path(Nat, len(seed(), target0(), direct_history()), len(seed(), target0(), detour_history())) -> Empty). (all r: Env. Path(Path(Nat, eval(seed(), r), eval(target0(), r)), derivation_sound(seed(), target0(), direct_history(), r), derivation_sound(seed(), target0(), detour_history(), r))):
  (lambda p. route_length_differs(p), lambda r. meaning_agrees(r))

def main() -> Nat:
  len(seed(), target0(), detour_history())
