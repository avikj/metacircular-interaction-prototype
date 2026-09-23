# formal/cubical/kernel-flat/RewriteCertificateMul.agda, in Bend: the certificate
# language widened to multiplication, and the conservativity of the widening.
# Bend imports are unqualified, so the widened language carries an `M` / `_m`
# suffix where the Agda mirrors the additive names exactly; `embed` is the
# inclusion of the additive language and every additive certificate is carried
# to one of the same shape here, with the same meaning.
import RewriteCertificate

# ---- multiplication on Nat, recursing on the first argument, and its laws
def mul(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n: 0n
    case 1n + p: add(b, mul(p, b))
def plusAssoc(a: Nat, b: Nat, c: Nat) -> Path(Nat, add(a, add(b, c)), add(add(a, b), c)):
  match a:
    case 0n: <_> add(b, c)
    case 1n + p: <i> 1n + (plusAssoc(p, b, c) @ i)
def plusComm(a: Nat, b: Nat) -> Path(Nat, add(a, b), add(b, a)):
  match a:
    case 0n: sym(Nat, add(b, 0n), b, plusZero(b))
    case 1n + p: compPath(Nat, 1n + add(p, b), 1n + add(b, p), add(b, 1n + p), <i> 1n + (plusComm(p, b) @ i), sym(Nat, add(b, 1n + p), 1n + add(b, p), plusSuc(b, p)))
def mulZero(m: Nat) -> Path(Nat, mul(m, 0n), 0n):
  match m:
    case 0n: <_> 0n
    case 1n + p: mulZero(p)
def mulSuc(m: Nat, n: Nat) -> Path(Nat, mul(m, 1n + n), add(m, mul(m, n))):
  match m:
    case 0n: <_> 0n
    case 1n + p:
      <i> 1n + (compPath3(Nat, add(n, mul(p, 1n + n)), add(n, add(p, mul(p, n))), add(add(p, n), mul(p, n)), add(p, add(n, mul(p, n))),
                  <i> add(n, mulSuc(p, n) @ i),
                  compPath(Nat, add(n, add(p, mul(p, n))), add(add(n, p), mul(p, n)), add(add(p, n), mul(p, n)),
                    plusAssoc(n, p, mul(p, n)), <i> add(plusComm(n, p) @ i, mul(p, n))),
                  sym(Nat, add(p, add(n, mul(p, n))), add(add(p, n), mul(p, n)), plusAssoc(p, n, mul(p, n)))) @ i)

# ---- 1. syntax
type TmM:
  case @var_m:
  case @yvar_m:
  case @zvar_m:
  case @uvar_m:
  case @vvar_m:
  case @wvar_m:
  case @zero_m:
  case @suc_m:
    t: TmM
  case @add_m:
    l: TmM
    r: TmM
  case @mul_m:
    l: TmM
    r: TmM

type StepM(x: TmM, y: TmM):
  case @add_zero_m:
    t: TmM
    ex: TmM{x == @add_m{t, @zero_m}}
    ey: TmM{y == t}
  case @add_suc_m:
    l: TmM
    r: TmM
    ex: TmM{x == @add_m{l, @suc_m{r}}}
    ey: TmM{y == @suc_m{@add_m{l, r}}}
  case @mul_zero_m:
    t: TmM
    ex: TmM{x == @mul_m{t, @zero_m}}
    ey: TmM{y == @zero_m}
  case @mul_suc_m:
    l: TmM
    r: TmM
    ex: TmM{x == @mul_m{l, @suc_m{r}}}
    ey: TmM{y == @add_m{@mul_m{l, r}, l}}
  case @suc_step_m:
    a: TmM
    b: TmM
    s: StepM(a, b)
    ex: TmM{x == @suc_m{a}}
    ey: TmM{y == @suc_m{b}}
  case @add_left_m:
    a: TmM
    b: TmM
    s: StepM(a, b)
    z: TmM
    ex: TmM{x == @add_m{a, z}}
    ey: TmM{y == @add_m{b, z}}
  case @add_right_m:
    z: TmM
    a: TmM
    b: TmM
    s: StepM(a, b)
    ex: TmM{x == @add_m{z, a}}
    ey: TmM{y == @add_m{z, b}}
  case @mul_left_m:
    a: TmM
    b: TmM
    s: StepM(a, b)
    z: TmM
    ex: TmM{x == @mul_m{a, z}}
    ey: TmM{y == @mul_m{b, z}}
  case @mul_right_m:
    z: TmM
    a: TmM
    b: TmM
    s: StepM(a, b)
    ex: TmM{x == @mul_m{z, a}}
    ey: TmM{y == @mul_m{z, b}}
  case @reverse_m:
    s: StepM(y, x)

type DerivationM(x: TmM, z: TmM):
  case @done_m:
    e: TmM{z == x}
  case @then_m:
    y: TmM
    s: StepM(x, y)
    d: DerivationM(y, z)

def subVarM(u: TmM, t: TmM) -> TmM:
  match t:
    case @var_m{}: u
    case @yvar_m{}: @yvar_m
    case @zvar_m{}: @zvar_m
    case @uvar_m{}: @uvar_m
    case @vvar_m{}: @vvar_m
    case @wvar_m{}: @wvar_m
    case @zero_m{}: @zero_m
    case @suc_m{a}: @suc_m{subVarM(u, a)}
    case @add_m{l, r}: @add_m{subVarM(u, l), subVarM(u, r)}
    case @mul_m{l, r}: @mul_m{subVarM(u, l), subVarM(u, r)}

type HypStepM(ihL: TmM, ihR: TmM, x: TmM, y: TmM):
  case @lift_step_m:
    s: StepM(x, y)
  case @hypothesis_m:
    ex: TmM{x == ihL}
    ey: TmM{y == ihR}
  case @reverse_hypothesis_m:
    ex: TmM{x == ihR}
    ey: TmM{y == ihL}
  case @hyp_suc_m:
    a: TmM
    b: TmM
    s: HypStepM(ihL, ihR, a, b)
    ex: TmM{x == @suc_m{a}}
    ey: TmM{y == @suc_m{b}}
  case @hyp_add_left_m:
    a: TmM
    b: TmM
    s: HypStepM(ihL, ihR, a, b)
    z: TmM
    ex: TmM{x == @add_m{a, z}}
    ey: TmM{y == @add_m{b, z}}
  case @hyp_add_right_m:
    z: TmM
    a: TmM
    b: TmM
    s: HypStepM(ihL, ihR, a, b)
    ex: TmM{x == @add_m{z, a}}
    ey: TmM{y == @add_m{z, b}}
  case @hyp_mul_left_m:
    a: TmM
    b: TmM
    s: HypStepM(ihL, ihR, a, b)
    z: TmM
    ex: TmM{x == @mul_m{a, z}}
    ey: TmM{y == @mul_m{b, z}}
  case @hyp_mul_right_m:
    z: TmM
    a: TmM
    b: TmM
    s: HypStepM(ihL, ihR, a, b)
    ex: TmM{x == @mul_m{z, a}}
    ey: TmM{y == @mul_m{z, b}}

type HypDerivationM(ihL: TmM, ihR: TmM, x: TmM, z: TmM):
  case @hyp_done_m:
    e: TmM{z == x}
  case @hyp_then_m:
    y: TmM
    s: HypStepM(ihL, ihR, x, y)
    d: HypDerivationM(ihL, ihR, y, z)

type InductionCertificateM(lhs: TmM, rhs: TmM):
  case @cert_m:
    base: DerivationM(subVarM(@zero_m, lhs), subVarM(@zero_m, rhs))
    step: HypDerivationM(lhs, rhs, subVarM(@suc_m{@var_m}, lhs), subVarM(@suc_m{@var_m}, rhs))

# ---- 2. semantics (the same six-coordinate environment)
def evalM(t: TmM, r: Env) -> Nat:
  match t:
    case @var_m{}: match r: case @env{x, y, z, u, v, w}: x
    case @yvar_m{}: match r: case @env{x, y, z, u, v, w}: y
    case @zvar_m{}: match r: case @env{x, y, z, u, v, w}: z
    case @uvar_m{}: match r: case @env{x, y, z, u, v, w}: u
    case @vvar_m{}: match r: case @env{x, y, z, u, v, w}: v
    case @wvar_m{}: match r: case @env{x, y, z, u, v, w}: w
    case @zero_m{}: 0n
    case @suc_m{a}: 1n + evalM(a, r)
    case @add_m{l, rr}: add(evalM(l, r), evalM(rr, r))
    case @mul_m{l, rr}: mul(evalM(l, r), evalM(rr, r))

# ---- 3. soundness
def step_soundM(a: TmM, b: TmM, s: StepM(a, b), r: Env) -> Path(Nat, evalM(a, r), evalM(b, r)):
  match s:
    case @add_zero_m{t, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          plusZero(evalM(t, r))
    case @add_suc_m{l, rr, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          plusSuc(evalM(l, r), evalM(rr, r))
    case @mul_zero_m{t, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          mulZero(evalM(t, r))
    case @mul_suc_m{l, rr, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          compPath(Nat, mul(evalM(l, r), 1n + evalM(rr, r)), add(evalM(l, r), mul(evalM(l, r), evalM(rr, r))), add(mul(evalM(l, r), evalM(rr, r)), evalM(l, r)),
            mulSuc(evalM(l, r), evalM(rr, r)), plusComm(evalM(l, r), mul(evalM(l, r), evalM(rr, r))))
    case @suc_step_m{a2, b2, s2, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          <i> 1n + (step_soundM(a2, b2, s2, r) @ i)
    case @add_left_m{a2, b2, s2, z, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          <i> add(step_soundM(a2, b2, s2, r) @ i, evalM(z, r))
    case @add_right_m{z, a2, b2, s2, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          <i> add(evalM(z, r), step_soundM(a2, b2, s2, r) @ i)
    case @mul_left_m{a2, b2, s2, z, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          <i> mul(step_soundM(a2, b2, s2, r) @ i, evalM(z, r))
    case @mul_right_m{z, a2, b2, s2, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          <i> mul(evalM(z, r), step_soundM(a2, b2, s2, r) @ i)
    case @reverse_m{s2}:
      <i> step_soundM(b, a, s2, r) @ inot(i)

def derivation_soundM(a: TmM, b: TmM, d: DerivationM(a, b), r: Env) -> Path(Nat, evalM(a, r), evalM(b, r)):
  match d:
    case @done_m{e}:
      match e: case {==}:
        <_> evalM(a, r)
    case @then_m{y, s, d2}:
      compPath(Nat, evalM(a, r), evalM(y, r), evalM(b, r), step_soundM(a, y, s, r), derivation_soundM(y, b, d2, r))

def eval_subVarM(t: TmM, body: TmM, r: Env) -> Path(Nat, evalM(subVarM(t, body), r), evalM(body, setX(evalM(t, r), r))):
  match body:
    case @var_m{}: match r: case @env{x, y, z, u, v, w}: <_> evalM(t, @env{x, y, z, u, v, w})
    case @yvar_m{}: match r: case @env{x, y, z, u, v, w}: <_> y
    case @zvar_m{}: match r: case @env{x, y, z, u, v, w}: <_> z
    case @uvar_m{}: match r: case @env{x, y, z, u, v, w}: <_> u
    case @vvar_m{}: match r: case @env{x, y, z, u, v, w}: <_> v
    case @wvar_m{}: match r: case @env{x, y, z, u, v, w}: <_> w
    case @zero_m{}: <_> 0n
    case @suc_m{a}: <i> 1n + (eval_subVarM(t, a, r) @ i)
    case @add_m{l, rr}: <i> add(eval_subVarM(t, l, r) @ i, eval_subVarM(t, rr, r) @ i)
    case @mul_m{l, rr}: <i> mul(eval_subVarM(t, l, r) @ i, eval_subVarM(t, rr, r) @ i)

def hyp_step_soundM(ihL: TmM, ihR: TmM, a: TmM, b: TmM, s: HypStepM(ihL, ihR, a, b), r: Env, ih: Path(Nat, evalM(ihL, r), evalM(ihR, r))) -> Path(Nat, evalM(a, r), evalM(b, r)):
  match s:
    case @lift_step_m{s2}: step_soundM(a, b, s2, r)
    case @hypothesis_m{ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          ih
    case @reverse_hypothesis_m{ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          <i> ih @ inot(i)
    case @hyp_suc_m{a2, b2, s2, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          <i> 1n + (hyp_step_soundM(ihL, ihR, a2, b2, s2, r, ih) @ i)
    case @hyp_add_left_m{a2, b2, s2, z, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          <i> add(hyp_step_soundM(ihL, ihR, a2, b2, s2, r, ih) @ i, evalM(z, r))
    case @hyp_add_right_m{z, a2, b2, s2, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          <i> add(evalM(z, r), hyp_step_soundM(ihL, ihR, a2, b2, s2, r, ih) @ i)
    case @hyp_mul_left_m{a2, b2, s2, z, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          <i> mul(hyp_step_soundM(ihL, ihR, a2, b2, s2, r, ih) @ i, evalM(z, r))
    case @hyp_mul_right_m{z, a2, b2, s2, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          <i> mul(evalM(z, r), hyp_step_soundM(ihL, ihR, a2, b2, s2, r, ih) @ i)

def hyp_derivation_soundM(ihL: TmM, ihR: TmM, a: TmM, b: TmM, d: HypDerivationM(ihL, ihR, a, b), r: Env, ih: Path(Nat, evalM(ihL, r), evalM(ihR, r))) -> Path(Nat, evalM(a, r), evalM(b, r)):
  match d:
    case @hyp_done_m{e}:
      match e: case {==}:
        <_> evalM(a, r)
    case @hyp_then_m{y, s, d2}:
      compPath(Nat, evalM(a, r), evalM(y, r), evalM(b, r), hyp_step_soundM(ihL, ihR, a, y, s, r, ih), hyp_derivation_soundM(ihL, ihR, y, b, d2, r, ih))

def induction_goM(lhs: TmM, rhs: TmM, c: InductionCertificateM(lhs, rhs), k: Nat, y0: Nat, z0: Nat, u0: Nat, v0: Nat, w0: Nat) -> Path(Nat, evalM(lhs, @env{k, y0, z0, u0, v0, w0}), evalM(rhs, @env{k, y0, z0, u0, v0, w0})):
  match c:
    case @cert_m{base, step}:
      match k:
        case 0n:
          compPath(Nat, evalM(lhs, @env{0n, y0, z0, u0, v0, w0}), evalM(subVarM(@zero_m, lhs), @env{0n, y0, z0, u0, v0, w0}), evalM(rhs, @env{0n, y0, z0, u0, v0, w0}),
            sym(Nat, evalM(subVarM(@zero_m, lhs), @env{0n, y0, z0, u0, v0, w0}), evalM(lhs, @env{0n, y0, z0, u0, v0, w0}), eval_subVarM(@zero_m, lhs, @env{0n, y0, z0, u0, v0, w0})),
            compPath(Nat, evalM(subVarM(@zero_m, lhs), @env{0n, y0, z0, u0, v0, w0}), evalM(subVarM(@zero_m, rhs), @env{0n, y0, z0, u0, v0, w0}), evalM(rhs, @env{0n, y0, z0, u0, v0, w0}),
              derivation_soundM(subVarM(@zero_m, lhs), subVarM(@zero_m, rhs), base, @env{0n, y0, z0, u0, v0, w0}),
              eval_subVarM(@zero_m, rhs, @env{0n, y0, z0, u0, v0, w0})))
        case 1n + p:
          compPath(Nat, evalM(lhs, @env{1n + p, y0, z0, u0, v0, w0}), evalM(subVarM(@suc_m{@var_m}, lhs), @env{p, y0, z0, u0, v0, w0}), evalM(rhs, @env{1n + p, y0, z0, u0, v0, w0}),
            sym(Nat, evalM(subVarM(@suc_m{@var_m}, lhs), @env{p, y0, z0, u0, v0, w0}), evalM(lhs, @env{1n + p, y0, z0, u0, v0, w0}), eval_subVarM(@suc_m{@var_m}, lhs, @env{p, y0, z0, u0, v0, w0})),
            compPath(Nat, evalM(subVarM(@suc_m{@var_m}, lhs), @env{p, y0, z0, u0, v0, w0}), evalM(subVarM(@suc_m{@var_m}, rhs), @env{p, y0, z0, u0, v0, w0}), evalM(rhs, @env{1n + p, y0, z0, u0, v0, w0}),
              hyp_derivation_soundM(lhs, rhs, subVarM(@suc_m{@var_m}, lhs), subVarM(@suc_m{@var_m}, rhs), step, @env{p, y0, z0, u0, v0, w0}, induction_goM(lhs, rhs, @cert_m{base, step}, p, y0, z0, u0, v0, w0)),
              eval_subVarM(@suc_m{@var_m}, rhs, @env{p, y0, z0, u0, v0, w0})))

def induction_soundM(lhs: TmM, rhs: TmM, c: InductionCertificateM(lhs, rhs), r: Env) -> Path(Nat, evalM(lhs, r), evalM(rhs, r)):
  match r:
    case @env{x, y, z, u, v, w}: induction_goM(lhs, rhs, c, x, y, z, u, v, w)

# ---- 4. the additive certificate, re-checked in the wider language
def acceptedM() -> DerivationM(@add_m{@var_m, @suc_m{@zero_m}}, @suc_m{@var_m}):
  @then_m{@suc_m{@add_m{@var_m, @zero_m}}, @add_suc_m{@var_m, @zero_m, {==}, {==}},
    @then_m{@suc_m{@var_m}, @suc_step_m{@add_m{@var_m, @zero_m}, @var_m, @add_zero_m{@var_m, {==}, {==}}, {==}, {==}},
      @done_m{{==}}}}
def accepted_soundM(r: Env) -> Path(Nat, evalM(@add_m{@var_m, @suc_m{@zero_m}}, r), evalM(@suc_m{@var_m}, r)):
  derivation_soundM(@add_m{@var_m, @suc_m{@zero_m}}, @suc_m{@var_m}, acceptedM(), r)

# ---- 5a. a ground multiplicative computation: 1 * 1 = 1
# 1 * 1 → 1 * 0 + 1 → 0 + 1 → s (0 + 0) → s 0; the second move's redex sits in
# the LEFT argument of an add, so add_left carries it.
def one_times_one() -> DerivationM(@mul_m{@suc_m{@zero_m}, @suc_m{@zero_m}}, @suc_m{@zero_m}):
  @then_m{@add_m{@mul_m{@suc_m{@zero_m}, @zero_m}, @suc_m{@zero_m}}, @mul_suc_m{@suc_m{@zero_m}, @zero_m, {==}, {==}},
    @then_m{@add_m{@zero_m, @suc_m{@zero_m}}, @add_left_m{@mul_m{@suc_m{@zero_m}, @zero_m}, @zero_m, @mul_zero_m{@suc_m{@zero_m}, {==}, {==}}, @suc_m{@zero_m}, {==}, {==}},
      @then_m{@suc_m{@add_m{@zero_m, @zero_m}}, @add_suc_m{@zero_m, @zero_m, {==}, {==}},
        @then_m{@suc_m{@zero_m}, @suc_step_m{@add_m{@zero_m, @zero_m}, @zero_m, @add_zero_m{@zero_m, {==}, {==}}, {==}, {==}},
          @done_m{{==}}}}}}
def one_times_one_sound(r: Env) -> Path(Nat, evalM(@mul_m{@suc_m{@zero_m}, @suc_m{@zero_m}}, r), evalM(@suc_m{@zero_m}, r)):
  derivation_soundM(@mul_m{@suc_m{@zero_m}, @suc_m{@zero_m}}, @suc_m{@zero_m}, one_times_one(), r)

# ---- 5b. x * 1 = x as a full induction certificate: the successor branch is a
# six-step trace using mul_zero forwards, mul_zero and mul_suc BACKWARDS to
# refold 0 + x into x * 1, and the hypothesis under a suc.
def x_times_one() -> InductionCertificateM(@mul_m{@var_m, @suc_m{@zero_m}}, @var_m):
  @cert_m{
    @then_m{@add_m{@mul_m{@zero_m, @zero_m}, @zero_m}, @mul_suc_m{@zero_m, @zero_m, {==}, {==}},
      @then_m{@add_m{@zero_m, @zero_m}, @add_left_m{@mul_m{@zero_m, @zero_m}, @zero_m, @mul_zero_m{@zero_m, {==}, {==}}, @zero_m, {==}, {==}},
        @then_m{@zero_m, @add_zero_m{@zero_m, {==}, {==}},
          @done_m{{==}}}}},
    @hyp_then_m{@add_m{@mul_m{@suc_m{@var_m}, @zero_m}, @suc_m{@var_m}}, @lift_step_m{@mul_suc_m{@suc_m{@var_m}, @zero_m, {==}, {==}}},
      @hyp_then_m{@add_m{@zero_m, @suc_m{@var_m}}, @lift_step_m{@add_left_m{@mul_m{@suc_m{@var_m}, @zero_m}, @zero_m, @mul_zero_m{@suc_m{@var_m}, {==}, {==}}, @suc_m{@var_m}, {==}, {==}}},
        @hyp_then_m{@suc_m{@add_m{@zero_m, @var_m}}, @lift_step_m{@add_suc_m{@zero_m, @var_m, {==}, {==}}},
          @hyp_then_m{@suc_m{@add_m{@mul_m{@var_m, @zero_m}, @var_m}},
            @hyp_suc_m{@add_m{@zero_m, @var_m}, @add_m{@mul_m{@var_m, @zero_m}, @var_m},
              @lift_step_m{@reverse_m{@add_left_m{@mul_m{@var_m, @zero_m}, @zero_m, @mul_zero_m{@var_m, {==}, {==}}, @var_m, {==}, {==}}}}, {==}, {==}},
            @hyp_then_m{@suc_m{@mul_m{@var_m, @suc_m{@zero_m}}},
              @hyp_suc_m{@add_m{@mul_m{@var_m, @zero_m}, @var_m}, @mul_m{@var_m, @suc_m{@zero_m}},
                @lift_step_m{@reverse_m{@mul_suc_m{@var_m, @zero_m, {==}, {==}}}}, {==}, {==}},
              @hyp_then_m{@suc_m{@var_m},
                @hyp_suc_m{@mul_m{@var_m, @suc_m{@zero_m}}, @var_m, @hypothesis_m{{==}, {==}}, {==}, {==}},
                @hyp_done_m{{==}}}}}}}}}

# x · 1 ≡ x is a theorem OF THE MACHINE'S CALCULUS, by a checked trace
def x_times_one_sound(r: Env) -> Path(Nat, evalM(@mul_m{@var_m, @suc_m{@zero_m}}, r), evalM(@var_m, r)):
  induction_soundM(@mul_m{@var_m, @suc_m{@zero_m}}, @var_m, x_times_one(), r)

# ---- 6. conservativity, proved: the inclusion of the additive language
def embed(t: Tm) -> TmM:
  match t:
    case @var{}: @var_m
    case @yvar{}: @yvar_m
    case @zvar{}: @zvar_m
    case @uvar{}: @uvar_m
    case @vvar{}: @vvar_m
    case @wvar{}: @wvar_m
    case @zero{}: @zero_m
    case @suc{a}: @suc_m{embed(a)}
    case @add{l, r}: @add_m{embed(l), embed(r)}

# meaning is preserved: the widening adds vocabulary, not reinterpretation
def embed_eval(t: Tm, r: Env) -> Path(Nat, evalM(embed(t), r), eval(t, r)):
  match t:
    case @var{}: <_> evalM(@var_m, r)
    case @yvar{}: <_> evalM(@yvar_m, r)
    case @zvar{}: <_> evalM(@zvar_m, r)
    case @uvar{}: <_> evalM(@uvar_m, r)
    case @vvar{}: <_> evalM(@vvar_m, r)
    case @wvar{}: <_> evalM(@wvar_m, r)
    case @zero{}: <_> 0n
    case @suc{a}: <i> 1n + (embed_eval(a, r) @ i)
    case @add{l, rr}: <i> add(embed_eval(l, r) @ i, embed_eval(rr, r) @ i)

def embed_step(a: Tm, b: Tm, s: Step(a, b)) -> StepM(embed(a), embed(b)):
  match s:
    case @add_zero{t, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          @add_zero_m{embed(t), {==}, {==}}
    case @add_suc{l, r, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          @add_suc_m{embed(l), embed(r), {==}, {==}}
    case @suc_step{a2, b2, s2, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          @suc_step_m{embed(a2), embed(b2), embed_step(a2, b2, s2), {==}, {==}}
    case @add_left{a2, b2, s2, z, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          @add_left_m{embed(a2), embed(b2), embed_step(a2, b2, s2), embed(z), {==}, {==}}
    case @add_right{z, a2, b2, s2, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          @add_right_m{embed(z), embed(a2), embed(b2), embed_step(a2, b2, s2), {==}, {==}}
    case @reverse{s2}:
      @reverse_m{embed_step(b, a, s2)}

def embed_derivation(a: Tm, b: Tm, d: Derivation(a, b)) -> DerivationM(embed(a), embed(b)):
  match d:
    case @done{e}:
      match e: case {==}: @done_m{{==}}
    case @then{y, s, d2}: @then_m{embed(y), embed_step(a, y, s), embed_derivation(y, b, d2)}

def embed_hyp_step(ihL: Tm, ihR: Tm, a: Tm, b: Tm, s: HypStep(ihL, ihR, a, b)) -> HypStepM(embed(ihL), embed(ihR), embed(a), embed(b)):
  match s:
    case @lift_step{s2}: @lift_step_m{embed_step(a, b, s2)}
    case @hypothesis{ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          @hypothesis_m{{==}, {==}}
    case @reverse_hypothesis{ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          @reverse_hypothesis_m{{==}, {==}}
    case @hyp_suc{a2, b2, s2, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          @hyp_suc_m{embed(a2), embed(b2), embed_hyp_step(ihL, ihR, a2, b2, s2), {==}, {==}}
    case @hyp_add_left{a2, b2, s2, z, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          @hyp_add_left_m{embed(a2), embed(b2), embed_hyp_step(ihL, ihR, a2, b2, s2), embed(z), {==}, {==}}
    case @hyp_add_right{z, a2, b2, s2, ex, ey}:
      match ex: case {==}:
        match ey: case {==}:
          @hyp_add_right_m{embed(z), embed(a2), embed(b2), embed_hyp_step(ihL, ihR, a2, b2, s2), {==}, {==}}

def embed_hyp_derivation(ihL: Tm, ihR: Tm, a: Tm, b: Tm, d: HypDerivation(ihL, ihR, a, b)) -> HypDerivationM(embed(ihL), embed(ihR), embed(a), embed(b)):
  match d:
    case @hyp_done{e}:
      match e: case {==}: @hyp_done_m{{==}}
    case @hyp_then{y, s, d2}: @hyp_then_m{embed(y), embed_hyp_step(ihL, ihR, a, y, s), embed_hyp_derivation(ihL, ihR, y, b, d2)}

def embed_subVar(u: Tm, t: Tm) -> Path(TmM, embed(subVar(u, t)), subVarM(embed(u), embed(t))):
  match t:
    case @var{}: <_> embed(u)
    case @yvar{}: <_> @yvar_m
    case @zvar{}: <_> @zvar_m
    case @uvar{}: <_> @uvar_m
    case @vvar{}: <_> @vvar_m
    case @wvar{}: <_> @wvar_m
    case @zero{}: <_> @zero_m
    case @suc{a}: <i> @suc_m{embed_subVar(u, a) @ i}
    case @add{l, r}: <i> @add_m{embed_subVar(u, l) @ i, embed_subVar(u, r) @ i}

# THE CONSERVATIVITY STATEMENT: every additive induction certificate is one
# here, over the embedded endpoints (the two subVar squares carried by coe)
def embed_certificate(lhs: Tm, rhs: Tm, c: InductionCertificate(lhs, rhs)) -> InductionCertificateM(embed(lhs), embed(rhs)):
  match c:
    case @cert{base, step}:
      @cert_m{
        coe(lambda i. DerivationM(embed_subVar(@zero, lhs) @ i, embed_subVar(@zero, rhs) @ i), i0, i1,
            embed_derivation(subVar(@zero, lhs), subVar(@zero, rhs), base)),
        coe(lambda i. HypDerivationM(embed(lhs), embed(rhs), embed_subVar(@suc{@var}, lhs) @ i, embed_subVar(@suc{@var}, rhs) @ i), i0, i1,
            embed_hyp_derivation(lhs, rhs, subVar(@suc{@var}, lhs), subVar(@suc{@var}, rhs), step))}

# ... and it means there what it meant here
def embed_certificate_sound(lhs: Tm, rhs: Tm, c: InductionCertificate(lhs, rhs), r: Env) -> Path(Nat, eval(lhs, r), eval(rhs, r)):
  compPath3(Nat, eval(lhs, r), evalM(embed(lhs), r), evalM(embed(rhs), r), eval(rhs, r),
    sym(Nat, evalM(embed(lhs), r), eval(lhs, r), embed_eval(lhs, r)),
    induction_soundM(embed(lhs), embed(rhs), embed_certificate(lhs, rhs, c), r),
    embed_eval(rhs, r))

def main() -> Nat:
  evalM(@mul_m{@suc_m{@suc_m{@zero_m}}, @suc_m{@suc_m{@suc_m{@zero_m}}}}, @env{0n, 0n, 0n, 0n, 0n, 0n})
