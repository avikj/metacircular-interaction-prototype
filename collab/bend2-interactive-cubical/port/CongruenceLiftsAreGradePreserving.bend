# formal/cubical/kernel-flat/CongruenceLiftsAreGradePreserving.agda, in Bend.
# The engine under every cost lemma: a derivation lifts under any one-hole
# context (suc _, add _ z, add z _) step by step, and the lift preserves length.
import RewriteCertificate

def len(a: Tm, b: Tm, d: Derivation(a, b)) -> Nat:
  match d:
    case @done{e}: 0n
    case @then{y, s, d2}: 1n + len(y, b, d2)

def underSuc(a: Tm, b: Tm, d: Derivation(a, b)) -> Derivation(@suc{a}, @suc{b}):
  match d:
    case @done{eq}:
      match eq: case {==}: @done{{==}}
    case @then{y, s, d2}: @then{@suc{y}, @suc_step{a, y, s, {==}, {==}}, underSuc(y, b, d2)}

def underAddL(a: Tm, b: Tm, d: Derivation(a, b), z: Tm) -> Derivation(@add{a, z}, @add{b, z}):
  match d:
    case @done{eq}:
      match eq: case {==}: @done{{==}}
    case @then{y, s, d2}: @then{@add{y, z}, @add_left{a, y, s, z, {==}, {==}}, underAddL(y, b, d2, z)}

def underAddR(z: Tm, a: Tm, b: Tm, d: Derivation(a, b)) -> Derivation(@add{z, a}, @add{z, b}):
  match d:
    case @done{eq}:
      match eq: case {==}: @done{{==}}
    case @then{y, s, d2}: @then{@add{z, y}, @add_right{z, a, y, s, {==}, {==}}, underAddR(z, y, b, d2)}

def len_underSuc(a: Tm, b: Tm, d: Derivation(a, b)) -> Path(Nat, len(@suc{a}, @suc{b}, underSuc(a, b, d)), len(a, b, d)):
  match d:
    case @done{eq}:
      match eq: case {==}: <_> 0n
    case @then{y, s, d2}: <i> 1n + (len_underSuc(y, b, d2) @ i)

def len_underAddL(a: Tm, b: Tm, d: Derivation(a, b), z: Tm) -> Path(Nat, len(@add{a, z}, @add{b, z}, underAddL(a, b, d, z)), len(a, b, d)):
  match d:
    case @done{eq}:
      match eq: case {==}: <_> 0n
    case @then{y, s, d2}: <i> 1n + (len_underAddL(y, b, d2, z) @ i)

def len_underAddR(z: Tm, a: Tm, b: Tm, d: Derivation(a, b)) -> Path(Nat, len(@add{z, a}, @add{z, b}, underAddR(z, a, b, d)), len(a, b, d)):
  match d:
    case @done{eq}:
      match eq: case {==}: <_> 0n
    case @then{y, s, d2}: <i> 1n + (len_underAddR(z, y, b, d2) @ i)

def main() -> Nat:
  len(@add{@add{@var, @suc{@zero}}, @yvar}, @add{@suc{@var}, @yvar}, underAddL(@add{@var, @suc{@zero}}, @suc{@var}, accepted(), @yvar))
