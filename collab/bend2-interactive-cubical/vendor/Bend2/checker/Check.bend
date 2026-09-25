# The checker on the net: the `verify` projection (One §14) of the book, by
# normalisation by evaluation on the runtime's own values.
#
# It reads each definition's STATIC BOOK TERM (the lowered syntax at BOOK[id],
# de Bruijn levels; the same heap words every execution instantiates) and
# never evaluates the checked term. Types are evaluated, on the same net.
#
# Context. Every binder the checker enters gets a level. A static subterm is
# always paired with its slot map (static level -> context level), so code can
# be read at any depth. Types and goals are FUNCTIONS OF THE CONTEXT (closures
# over a level lookup): refining a matched variable replaces its entry, and
# every type and goal that mentions it is re-applied to the new context
# (One §1 at the constructor map: the branch's goal is the motive applied to
# the pattern).
#
# Conversion is equality of normal forms (Visranti: two steps and a refl):
# both sides are read back η-long at their type (Π, Σ, Path, Unit) and
# compared by the runtime's `===`. Interval points are generators of the free
# De Morgan algebra, whose operations (the prelude) compute its normal form.
#
# Result codes: 0 checks, 1 mismatch, 2 cannot infer, >= 1000 not yet on the net
# (1000 + tag: a static node kind; 3000: a prelude reference; 4000 + n: a site).

# ---- the runtime primitives (hvm.c, APP-PRI) and prelude functions ----------

def Val() -> Set:
  extern

def Prim/fresh(u: Unit) -> Val:
  extern

def Prim/peek(c: U64) -> any t: U64. any e: U64. U64:
  extern

def Prim/inst(c: U64, env: (any k: U64. Val)[]) -> Val:
  extern

def Prim/vpeek(v: Val) -> any t: U64. any e: U64. U64:
  extern

def Prim/vfield(v: Val, i: U64) -> Val:
  extern

def Prim/vapp(f: Val, x: Val) -> Val:
  extern

def Prim/typeof(i: U64) -> Val:
  extern

def Prim/vctr(c: U64, fs: Val[]) -> Val:
  extern

# p @ i, the path with faces a, b over p, Equiv(T, A), and structural
# equality of normal forms: functions of the prelude
def Prim/pathAt(p: Val, i: Val) -> Val:
  extern

def Prim/pbndL(a: Val, b: Val, p: Val) -> Val:
  extern

def Prim/equivT(t: Val, a: Val) -> Val:
  extern

def Prim/veql(a: Val, b: Val) -> Bool:
  extern

# the head (0) or argument (1) of a neutral spine
def Prim/vdry(v: Val, i: U64) -> Val:
  extern

# development: prints x's normal form to stderr, answers y
def Prim/trace(x: Val, y: U64) -> U64:
  extern

def Fun/val(f: Val -> Val) -> Val:
  extern

def Num/val(n: U64) -> Val:
  extern

# ---- cell names ---------------------------------------------------------------

# the checker's names for the built-in cells; each id is read off a real
# cell of the one lowering (typed casts through the identity primitive), so
# a symbol never stands in for a constructor
def Set/val(t: Set) -> Val:
  extern

def Nat/val(n: Nat) -> Val:
  extern

def List/val(xs: U64[]) -> Val:
  extern

def Pair/val(p: any a: U64. U64) -> Val:
  extern

def Unit/val(u: Unit) -> Val:
  extern

def Refl/val(e: Nat{0n == 0n}) -> Val:
  extern

def Chk/cell(t: Tag()) -> Val:
  match t:
    case &Pi:
      Set/val(all x: Nat. Nat)
    case &Sig:
      Set/val(any x: Nat. Nat)
    case &Set:
      Set/val(Set)
    case &Nat:
      Set/val(Nat)
    case &Bool:
      Set/val(Bool)
    case &Unit:
      Set/val(Unit)
    case &Empty:
      Set/val(Empty)
    case &List:
      Set/val(Nat[])
    case &Num:
      Set/val(U64)
    case &U64:
      Prim/vfield(Set/val(U64), 0)
    case &Chr:
      Prim/vfield(Set/val(Char), 0)
    case &Eql:
      Set/val(Nat{0n == 0n})
    case &Zer:
      Nat/val(0n)
    case &Suc:
      Nat/val(1n)
    case &Nil:
      List/val([])
    case &Con:
      List/val([0])
    case &One:
      Unit/val(())
    case &Pair:
      Pair/val((0, 0))
    case &Refl:
      Refl/val(finally)
    case &Enum:
      Set/val(&{&a})

def Chk/id(t: Tag()) -> U64:
  Chk/vext(Chk/cell(t))

# the static node / cell head: (tag, ext, val)
def Chk/tag(c: U64) -> U64:
  match Prim/peek(c):
    case (t, r):
      t

def Chk/ext(c: U64) -> U64:
  match Prim/peek(c):
    case (t, r):
      match r:
        case (e, v):
          e

def Chk/val(c: U64) -> U64:
  match Prim/peek(c):
    case (t, r):
      match r:
        case (e, v):
          v

def Chk/vtag(x: Val) -> U64:
  match Prim/vpeek(x):
    case (t, r):
      t

def Chk/vext(x: Val) -> U64:
  match Prim/vpeek(x):
    case (t, r):
      match r:
        case (e, v):
          e

# is x the cell #tag{..}?
def Chk/is(x: Val, t: Tag()) -> Bool:
  match Prim/vpeek(x):
    case (tg, r):
      match r:
        case (e, v):
          (tg >= 13) and (tg <= 29) and (e === Chk/id(t))

def Chk/mk0(t: Tag()) -> Val:
  Prim/vctr(Chk/id(t), [])

def Chk/mk1(t: Tag(), a: Val) -> Val:
  Prim/vctr(Chk/id(t), [a])

def Chk/mk2(t: Tag(), a: Val, b: Val) -> Val:
  Prim/vctr(Chk/id(t), [a, b])

def Chk/mk3(t: Tag(), a: Val, b: Val, c: Val) -> Val:
  Prim/vctr(Chk/id(t), [a, b, c])

def Chk/u64T() -> Val:
  Chk/mk1(&Num, Chk/mk0(&U64))

# ---- the book --------------------------------------------------------------------

# the book's enum types, the prelude's reference ids and anchor cells (the
# host lists them in this order)
type Bk:
  case @Bk:
    enums: Val[]
    pre: U64[]
    cells: Val[]

def Chk/enums(b: Bk) -> Val[]:
  match b:
    case @Bk{e, p, c}:
      e

def Chk/nthV(xs: Val[], i: U64) -> Val:
  match xs:
    case []:
      Chk/mk0(&Set)
    case h <> t:
      if i === 0:
        h
      else:
        Chk/nthV(t, i - 1)

def Chk/cellv(b: Bk, i: U64) -> Val:
  match b:
    case @Bk{e, p, c}:
      Chk/nthV(c, i)

def Chk/cid(b: Bk, i: U64) -> U64:
  Chk/vext(Chk/cellv(b, i))

def Chk/isc(b: Bk, x: Val, i: U64) -> Bool:
  match Prim/vpeek(x):
    case (tg, r):
      match r:
        case (e, v):
          (tg >= 13) and (tg <= 29) and (e === Chk/cid(b, i))

# which prelude function a static reference names (18: none)
def Chk/preIdx(b: Bk, id: U64) -> U64:
  match b:
    case @Bk{e, p, c}:
      Chk/idxU(p, id, 0)

def Chk/idxU(xs: U64[], x: U64, i: U64) -> U64:
  match xs:
    case []:
      i
    case h <> t:
      if h === x:
        i
      else:
        Chk/idxU(t, x, i + 1)

def Chk/nthU(xs: U64[], i: U64) -> U64:
  match xs:
    case []:
      0
    case h <> t:
      if i === 0:
        h
      else:
        Chk/nthU(t, i - 1)

def Chk/lenU(xs: U64[]) -> U64:
  match xs:
    case []:
      0
    case h <> t:
      1 + Chk/lenU(t)

# ---- context: entries and the level lookup ------------------------------------

# A hypothesis holds its value and its type as functions of the context's
# level lookup (level -> (kind, value)); a definition level is static code.
type Ent:
  case @Hyp:
    v: (U64 -> any k: U64. Val) -> Val
    ty: (U64 -> any k: U64. Val) -> Val
  case @Def:
    c: U64
    sm: U64[]
    kind: U64
  case @Alias:
    k: U64
    kind: U64

def Chk/nthE(xs: Ent[], i: U64) -> Ent:
  match xs:
    case []:
      @Alias{0, 0}
    case h <> t:
      if i === 0:
        h
      else:
        Chk/nthE(t, i - 1)

# the context level of static level s under slot map sm
def Chk/slot(sm: U64[], s: U64) -> U64:
  Chk/nthU(sm, Chk/lenU(sm) - s)

def Chk/ent(ctx: Ent[], d: U64, k: U64) -> Ent:
  Chk/nthE(ctx, d - k)

def Chk/kindAt(ctx: Ent[], d: U64, k: U64) -> U64:
  match Chk/ent(ctx, d, k):
    case @Alias{lvl, kind}:
      kind
    case @Def{c, sm, kind}:
      kind
    case @Hyp{v, ty}:
      0

# follow aliases to the level that owns the slot
def Chk/root(ctx: Ent[], d: U64, k: U64) -> U64:
  if (k === 0) or (k > d):
    k
  else:
    Chk/rootAt(ctx, d, k)

def Chk/rootAt(ctx: Ent[], d: U64, k: U64) -> U64:
  match Chk/ent(ctx, d, k):
    case @Alias{lvl, kind}:
      Chk/root(ctx, d, lvl)
    case @Hyp{v, ty}:
      k
    case @Def{c, sm, kind}:
      k

def Chk/valAt(ctx: Ent[], d: U64, k: U64) -> Val:
  match Chk/ent(ctx, d, k):
    case @Hyp{v, ty}:
      v(Chk/look(ctx, d))
    case @Def{c, sm, kind}:
      Prim/inst(c, Chk/envOf(Chk/look(ctx, d), sm))
    case @Alias{lvl, kind}:
      Chk/valAt(ctx, d, lvl)

def Chk/look(ctx: Ent[], d: U64) -> U64 -> any k: U64. Val:
  lambda k. (Chk/kindAt(ctx, d, k), Chk/valAt(ctx, d, k))

def Chk/envOf(l: U64 -> any k: U64. Val, sm: U64[]) -> (any k: U64. Val)[]:
  match sm:
    case []:
      []
    case k <> t:
      l(k) <> Chk/envOf(l, t)

def Chk/lv(l: U64 -> any k: U64. Val, k: U64) -> Val:
  match l(k):
    case (kind, v):
      v

# a cell as a function of the context
def Chk/now(ctx: Ent[], d: U64, f: (U64 -> any k: U64. Val) -> Val) -> Val:
  f(Chk/look(ctx, d))

def Chk/cst(x: Val) -> (U64 -> any k: U64. Val) -> Val:
  lambda l. x

def Chk/lvl(k: U64) -> (U64 -> any k: U64. Val) -> Val:
  lambda l. Chk/lv(l, k)

def Chk/code(c: U64, sm: U64[]) -> (U64 -> any k: U64. Val) -> Val:
  lambda l. Prim/inst(c, Chk/envOf(l, sm))

def Chk/fld(f: (U64 -> any k: U64. Val) -> Val, i: U64) -> (U64 -> any k: U64. Val) -> Val:
  lambda l. Prim/vfield(f(l), i)

def Chk/ap(f: (U64 -> any k: U64. Val) -> Val, x: (U64 -> any k: U64. Val) -> Val) -> (U64 -> any k: U64. Val) -> Val:
  lambda l. Prim/vapp(f(l), x(l))

def Chk/k1(t: U64, a: (U64 -> any k: U64. Val) -> Val) -> (U64 -> any k: U64. Val) -> Val:
  lambda l. Prim/vctr(t, [a(l)])

def Chk/k2(t: U64, a: (U64 -> any k: U64. Val) -> Val, b: (U64 -> any k: U64. Val) -> Val) -> (U64 -> any k: U64. Val) -> Val:
  lambda l. Prim/vctr(t, [a(l), b(l)])

def Chk/k3(t: U64, a: (U64 -> any k: U64. Val) -> Val, b: (U64 -> any k: U64. Val) -> Val, c: (U64 -> any k: U64. Val) -> Val) -> (U64 -> any k: U64. Val) -> Val:
  lambda l. Prim/vctr(t, [a(l), b(l), c(l)])

# the constant family λ_. g
def Chk/konst(g: (U64 -> any k: U64. Val) -> Val) -> (U64 -> any k: U64. Val) -> Val:
  lambda l. Fun/val(lambda x. g(l))

def Chk/pat(p: (U64 -> any k: U64. Val) -> Val, i: (U64 -> any k: U64. Val) -> Val) -> (U64 -> any k: U64. Val) -> Val:
  lambda l. Prim/pathAt(p(l), i(l))

def Chk/eqv(t: (U64 -> any k: U64. Val) -> Val, a: (U64 -> any k: U64. Val) -> Val) -> (U64 -> any k: U64. Val) -> Val:
  lambda l. Prim/equivT(t(l), a(l))

# a cell of the context extended by a definition level k (a let, a dup of
# code), read in the outer context: k is bound to that code's value
def Chk/under(k: U64, kind: U64, c: U64, sm: U64[], t: (U64 -> any k: U64. Val) -> Val) -> (U64 -> any k: U64. Val) -> Val:
  lambda l. t(Chk/extL(l, k, (kind, Prim/inst(c, Chk/envOf(l, sm)))))

def Chk/extL(l: U64 -> any k: U64. Val, k: U64, e: any k: U64. Val) -> U64 -> any k: U64. Val:
  lambda j. if j === k: e else: l(j)

def Chk/set() -> (U64 -> any k: U64. Val) -> Val:
  Chk/cst(Chk/mk0(&Set))

# replace the entry at list index i
def Chk/setE(ctx: Ent[], i: U64, e: Ent) -> Ent[]:
  match ctx:
    case []:
      []
    case h <> t:
      if i === 0:
        e <> t
      else:
        h <> Chk/setE(t, i - 1, e)

# refine the hypothesis at level k to the value p (a matched pattern)
def Chk/refine(ctx: Ent[], d: U64, k: U64, p: (U64 -> any k: U64. Val) -> Val) -> Ent[]:
  if k === 0:
    ctx
  else:
    match Chk/ent(ctx, d, k):
      case @Hyp{v, ty}:
        Chk/setE(ctx, d - k, @Hyp{p, ty})
      case @Alias{lvl, kind}:
        Chk/refine(ctx, d, lvl, p)
      case @Def{c, sm, kind}:
        ctx

# ---- generic elements and normal forms --------------------------------------

# the generic element of type t named n: η-long (a function is a λ of
# generics, a pair of projections, a path a line with its type's faces, the
# unit its point); an interval point is a generator of the De Morgan algebra
def Chk/reflect(es: Bk, t: Val, n: Val) -> Val:
  if Chk/is(t, &Pi):
    b = Prim/vfield(t, 1)
    Fun/val(lambda x. Chk/reflect(es, Prim/vapp(b, x), Prim/vapp(n, x)))
  else:
    if Chk/is(t, &Sig):
      a = Prim/vfield(t, 0)
      b = Prim/vfield(t, 1)
      x = Chk/reflect(es, a, Prim/vfield(n, 0))
      Chk/mk2(&Pair, x, Chk/reflect(es, Prim/vapp(b, x), Prim/vfield(n, 1)))
    else:
      if Chk/is(t, &Unit):
        Chk/mk0(&One)
      else:
        if Chk/isc(es, t, 6):
          Prim/pbndL(Prim/vfield(t, 1), Prim/vfield(t, 2), n)
        else:
          if Chk/isc(es, t, 3):
            Chk/gen(es, n)
          else:
            n

# the interval generator of a name
def Chk/gen(es: Bk, n: Val) -> Val:
  Prim/vctr(Chk/cid(es, 13), [Num/val(Chk/vext(n))])

# the normal form of v at type t, η-long
def Chk/rb(es: Bk, t: Val, v: Val) -> Val:
  if Chk/is(t, &Pi):
    a = Prim/vfield(t, 0)
    b = Prim/vfield(t, 1)
    Fun/val(lambda x. Chk/rbPi(es, a, b, v, Chk/reflect(es, a, x)))
  else:
    if Chk/is(t, &Sig):
      b = Prim/vfield(t, 1)
      x = Prim/vfield(v, 0)
      Chk/mk2(&Pair, Chk/rb(es, Prim/vfield(t, 0), x), Chk/rb(es, Prim/vapp(b, x), Prim/vfield(v, 1)))
    else:
      if Chk/is(t, &Unit):
        Chk/mk0(&One)
      else:
        if Chk/is(t, &Set):
          Chk/rbT(es, v)
        else:
          if Chk/isc(es, t, 6):
            p = Prim/vfield(t, 0)
            Prim/vctr(Chk/cid(es, 2), [Fun/val(lambda i. Chk/rbAt(es, p, v, Chk/gen(es, i)))])
          else:
            if Chk/is(t, &List):
              Chk/rbList(es, Prim/vfield(t, 0), v)
            else:
              v

def Chk/rbPi(es: Bk, a: Val, b: Val, v: Val, x: Val) -> Val:
  Chk/rb(es, Prim/vapp(b, x), Prim/vapp(v, x))

def Chk/rbAt(es: Bk, p: Val, v: Val, g: Val) -> Val:
  Chk/rb(es, Prim/vapp(p, g), Prim/pathAt(v, g))

def Chk/rbList(es: Bk, a: Val, v: Val) -> Val:
  if Chk/is(v, &Con):
    Chk/mk2(&Con, Chk/rb(es, a, Prim/vfield(v, 0)), Chk/rbList(es, a, Prim/vfield(v, 1)))
  else:
    v

# the normal form of a type
def Chk/rbT(es: Bk, t: Val) -> Val:
  if Chk/is(t, &Pi) or Chk/is(t, &Sig):
    a = Prim/vfield(t, 0)
    b = Prim/vfield(t, 1)
    Prim/vctr(Chk/vext(t), [Chk/rbT(es, a), Fun/val(lambda x. Chk/rbT(es, Prim/vapp(b, Chk/reflect(es, a, x))))])
  else:
    if Chk/isc(es, t, 6):
      p = Prim/vfield(t, 0)
      Prim/vctr(Chk/cid(es, 6), [Fun/val(lambda i. Chk/rbT(es, Prim/vapp(p, Chk/gen(es, i)))), Chk/rb(es, Prim/vapp(p, Chk/cellv(es, 4)), Prim/vfield(t, 1)), Chk/rb(es, Prim/vapp(p, Chk/cellv(es, 5)), Prim/vfield(t, 2))])
    else:
      if Chk/is(t, &Eql):
        a = Prim/vfield(t, 0)
        Chk/mk3(&Eql, Chk/rbT(es, a), Chk/rb(es, a, Prim/vfield(t, 1)), Chk/rb(es, a, Prim/vfield(t, 2)))
      else:
        if Chk/is(t, &List):
          Chk/mk1(&List, Chk/rbT(es, Prim/vfield(t, 0)))
        else:
          t

# conversion: equal normal forms
def Chk/conv(es: Bk, t: Val, a: Val, b: Val) -> U64:
  if Prim/veql(Chk/rb(es, t, a), Chk/rb(es, t, b)):
    0
  else:
    1

def Chk/convT(es: Bk, a: Val, b: Val) -> U64:
  if Prim/veql(Chk/rbT(es, a), Chk/rbT(es, b)):
    0
  else:
    1

# a fresh hypothesis of type ty: its value is the generic element
def Chk/hyp(es: Bk, ty: (U64 -> any k: U64. Val) -> Val) -> Ent:
  @Hyp{Chk/genF(es, ty, Prim/fresh(())), ty}

def Chk/genF(es: Bk, ty: (U64 -> any k: U64. Val) -> Val, n: Val) -> (U64 -> any k: U64. Val) -> Val:
  lambda l. Chk/reflect(es, ty(l), n)

# the level whose value is x, if any (0 otherwise)
def Chk/findFree(es: Bk, ctx: Ent[], d: U64, x: Val) -> U64:
  Chk/findGo(ctx, d, ctx, d, x)

def Chk/findGo(cx0: Ent[], d0: U64, ctx: Ent[], d: U64, x: Val) -> U64:
  match ctx:
    case []:
      0
    case h <> t:
      match h:
        case @Hyp{v, ty}:
          if Prim/veql(Chk/valAt(cx0, d0, d), x):
            d
          else:
            Chk/findGo(cx0, d0, t, d - 1, x)
        case @Def{c, sm, kind}:
          Chk/findGo(cx0, d0, t, d - 1, x)
        case @Alias{lvl, kind}:
          Chk/findGo(cx0, d0, t, d - 1, x)

# the entry of a dup level (a DUP node's value at v): both copies read the
# same slot, an alias when the dup'd code is a variable
def Chk/dupEnt(ctx: Ent[], d: U64, sm: U64[], v: U64) -> Ent:
  k = Chk/varLvl(sm, v)
  if k === 0:
    @Def{v, sm, 1}
  else:
    @Alias{Chk/root(ctx, d, k), 1}

# the level a static variable names (0 if the code is not a variable)
def Chk/varLvl(sm: U64[], c: U64) -> U64:
  match Prim/peek(c):
    case (t, r):
      match r:
        case (e, v):
          if (t === 42) or (t === 43) or (t === 44):
            Chk/slot(sm, v)
          else:
            0

# ---- results ------------------------------------------------------------------

def Chk/then(a: U64, b: U64) -> U64:
  if a === 0:
    b
  else:
    a

# ---- static spines -------------------------------------------------------------

# the head of an application spine and its arguments (static locations)
def Chk/head(c: U64) -> U64:
  if Chk/tag(c) === 0:
    Chk/head(Chk/val(c))
  else:
    c

def Chk/args(c: U64, acc: U64[]) -> U64[]:
  if Chk/tag(c) === 0:
    Chk/args(Chk/val(c), (Chk/val(c) + 1) <> acc)
  else:
    acc

# a LAM's own flags: a descent binding (a frame entry, not a λ of the program)
def Chk/isLet(c: U64) -> Bool:
  (Chk/tag(c) === 2) and ((Chk/ext(c) % 4194304) >= 2097152)

# ---- enums in the book (Core: Sym inference reads the book's enum types) ------

def Chk/snd(q: any t: U64. U64) -> U64:
  match q:
    case (t, i):
      i

def Chk/enumsOf(defs: (any c: U64. any t: U64. U64)[]) -> Val[]:
  match defs:
    case []:
      []
    case p <> rest:
      match p:
        case (c, q):
          i = Chk/snd(q)
          if (Chk/tag(c) === 15) and (Chk/ext(c) === Chk/id(&Sig)) and (Chk/tag(Chk/val(c)) === 14) and (Chk/ext(Chk/val(c)) === Chk/id(&Enum)) and Chk/is(Prim/typeof(i), &Set):
            Prim/inst(Chk/val(c), []) <> Chk/enumsOf(rest)
          else:
            Chk/enumsOf(rest)

# does the symbol list #Con{#s, ..} contain the symbol id s?
def Chk/hasSym(xs: Val, s: U64) -> Bool:
  if Chk/is(xs, &Con):
    if Chk/vext(Prim/vfield(xs, 0)) === s:
      True
    else:
      Chk/hasSym(Prim/vfield(xs, 1), s)
  else:
    False

def Chk/enumOf(es: Val[], s: U64) -> Val[]:
  match es:
    case []:
      []
    case e <> rest:
      if Chk/hasSym(Prim/vfield(e, 0), s):
        [e]
      else:
        Chk/enumOf(rest, s)

# ---- inference -------------------------------------------------------------------

def Chk/infer(es: Bk, ctx: Ent[], d: U64, sm: U64[], c: U64) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  t = Chk/tag(c)
  e = Chk/ext(c)
  v = Chk/val(c)
  if (t === 42) or (t === 43) or (t === 44):
    Chk/typeAt(es, ctx, d, Chk/slot(sm, v))
  else:
    if t === 8:
      ty = Prim/typeof(e)
      if Chk/vtag(ty) === 11:
        (3000, Chk/set())
      else:
        (0, Chk/cst(ty))
    else:
      if t === 46:
        Chk/inferSta(es, ctx, d, sm, e, v)
      else:
        if t === 30:
          (0, Chk/cst(Chk/u64T()))
        else:
          if (t >= 13) and (t <= 29):
            Chk/inferCtr(es, ctx, d, sm, t - 13, e, v)
          else:
            if t === 33:
              Chk/inferOp(es, ctx, d, sm, e, v)
            else:
              if t === 0:
                Chk/inferApp(es, ctx, d, sm, Chk/head(c), Chk/args(c, []))
              else:
                if t === 6:
                  Chk/inferDup(es, ctx, d, sm, v)
                else:
                  if (t === 2) or (t === 12) or (t === 31) or (t === 11):
                    (2, Chk/set())
                  else:
                    (1000 + t, Chk/set())

# the type of a context level
def Chk/typeAt(es: Bk, ctx: Ent[], d: U64, k: U64) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  match Chk/ent(ctx, d, k):
    case @Hyp{v, ty}:
      (0, ty)
    case @Def{c, sm, kind}:
      Chk/infer(es, ctx, d, sm, c)
    case @Alias{lvl, kind}:
      Chk/typeAt(es, ctx, d, lvl)

def Chk/inferSta(es: Bk, ctx: Ent[], d: U64, sm: U64[], k: U64, v: U64) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  if k === 0:
    (Chk/check(es, ctx, d, sm, v + 1, Chk/code(v, sm)), Chk/code(v, sm))
  else:
    if k === 1:
      Chk/inferNext(Chk/check(es, ctx, d, sm, v, Chk/cst(Chk/mk1(&List, Chk/mk1(&Num, Chk/mk0(&Chr))))), Chk/infer(es, ctx, d, sm, v + 1))
    else:
      (2, Chk/set())

def Chk/inferNext(r: U64, x: any r: U64. (U64 -> any k: U64. Val) -> Val) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  match x:
    case (r2, ty):
      (Chk/then(r, r2), ty)

# a definition level entered for code at depth d + 1: the result type is
# read with that level bound to the code's value
def Chk/inferUnder(es: Bk, ctx: Ent[], d: U64, sm: U64[], en: Ent, c: U64, kind: U64, x: U64) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  match Chk/infer(es, en <> ctx, d + 1, (d + 1) <> sm, c):
    case (r, ty):
      (r, Chk/under(d + 1, kind, x, sm, ty))

def Chk/inferDup(es: Bk, ctx: Ent[], d: U64, sm: U64[], v: U64) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  Chk/inferUnder(es, ctx, d, sm, Chk/dupEnt(ctx, d, sm, v), v + 1, 1, v)

def Chk/inferCtr(es: Bk, ctx: Ent[], d: U64, sm: U64[], ari: U64, e: U64, v: U64) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  if (e === Chk/cid(es, 3)):
    (0, Chk/set())
  else:
    if (e === Chk/cid(es, 4)) or (e === Chk/cid(es, 5)):
      (0, Chk/itv(es))
    else:
      if e === Chk/cid(es, 6):
        r1 = Chk/check(es, ctx, d, sm, v, Chk/line(es))
        r2 = Chk/check(es, ctx, d, sm, v + 1, Chk/ap(Chk/code(v, sm), Chk/cst(Chk/cellv(es, 4))))
        r3 = Chk/check(es, ctx, d, sm, v + 2, Chk/ap(Chk/code(v, sm), Chk/cst(Chk/cellv(es, 5))))
        (Chk/then(r1, Chk/then(r2, r3)), Chk/set())
      else:
        if (e === Chk/cid(es, 2)) or (e === Chk/cid(es, 0)):
          (2, Chk/set())
        else:
          if e === Chk/cid(es, 1):
            Chk/inferUa(es, ctx, d, sm, v)
          else:
            Chk/inferCtr0(es, ctx, d, sm, ari, e, v)

# ua(A, B, f, g, gf, fg) : Path(Set, A, B) (Core.Check: Ua)
def Chk/inferUa(es: Bk, ctx: Ent[], d: U64, sm: U64[], v: U64) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  a = Chk/code(v, sm)
  b = Chk/code(v + 1, sm)
  f = Chk/code(v + 2, sm)
  g = Chk/code(v + 3, sm)
  r1 = Chk/checkAll(es, ctx, d, sm, [v, v + 1], Chk/set())
  r2 = Chk/check(es, ctx, d, sm, v + 2, Chk/k2(Chk/id(&Pi), a, Chk/konst(b)))
  r3 = Chk/check(es, ctx, d, sm, v + 3, Chk/k2(Chk/id(&Pi), b, Chk/konst(a)))
  r4 = Chk/checkRet(es, ctx, d, sm, v + 4, a, f, g)
  r5 = Chk/checkRet(es, ctx, d, sm, v + 5, b, g, f)
  (Chk/then(r1, Chk/then(r2, Chk/then(r3, Chk/then(r4, r5)))), Chk/k3(Chk/cid(es, 6), Chk/konst(Chk/set()), a, b))

# c : Π x:X. Path(X, w(u(x)), x), read through its binder
def Chk/checkRet(es: Bk, ctx: Ent[], d: U64, sm: U64[], c: U64, x: (U64 -> any k: U64. Val) -> Val, u: (U64 -> any k: U64. Val) -> Val, w: (U64 -> any k: U64. Val) -> Val) -> U64:
  t = Chk/tag(c)
  if t === 6:
    Chk/checkRet(es, Chk/dupEnt(ctx, d, sm, Chk/val(c)) <> ctx, d + 1, (d + 1) <> sm, Chk/val(c) + 1, x, u, w)
  else:
    if Chk/isLetApp(c):
      Chk/checkRet(es, Chk/letEnt(ctx, d, sm, Chk/val(c) + 1) <> ctx, d + 1, (d + 1) <> sm, Chk/val(Chk/val(c)), x, u, w)
    else:
      Chk/checkRet1(es, ctx, d, sm, c, t, x, u, w)

def Chk/checkRet1(es: Bk, ctx: Ent[], d: U64, sm: U64[], c: U64, t: U64, x: (U64 -> any k: U64. Val) -> Val, u: (U64 -> any k: U64. Val) -> Val, w: (U64 -> any k: U64. Val) -> Val) -> U64:
  if t === 2:
    l = d + 1
    Chk/check(es, Chk/hyp(es, x) <> ctx, l, l <> sm, Chk/val(c), Chk/k3(Chk/cid(es, 6), Chk/konst(x), Chk/ap(w, Chk/ap(u, Chk/lvl(l))), Chk/lvl(l)))
  else:
    4007

def Chk/inferCtr0(es: Bk, ctx: Ent[], d: U64, sm: U64[], ari: U64, e: U64, v: U64) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  set = Chk/set()
  if (e === Chk/id(&Set)) or (e === Chk/id(&Nat)) or (e === Chk/id(&Bool)) or (e === Chk/id(&Unit)) or (e === Chk/id(&Empty)) or (e === Chk/id(&Num)) or (e === Chk/id(&Enum)):
    (0, set)
  else:
    if e === Chk/id(&List):
      (Chk/check(es, ctx, d, sm, v, set), set)
    else:
      if (e === Chk/id(&Sig)) or (e === Chk/id(&Pi)):
        r1 = Chk/check(es, ctx, d, sm, v, set)
        r2 = Chk/check(es, ctx, d, sm, v + 1, Chk/k2(Chk/id(&Pi), Chk/code(v, sm), Chk/konst(Chk/set())))
        (Chk/then(r1, r2), set)
      else:
        if e === Chk/id(&Eql):
          r1 = Chk/check(es, ctx, d, sm, v, set)
          r2 = Chk/check(es, ctx, d, sm, v + 1, Chk/code(v, sm))
          r3 = Chk/check(es, ctx, d, sm, v + 2, Chk/code(v, sm))
          (Chk/then(r1, Chk/then(r2, r3)), set)
        else:
          if e === Chk/id(&Zer):
            (0, Chk/cst(Chk/mk0(&Nat)))
          else:
            if e === Chk/id(&Suc):
              Chk/inferSuc(Chk/infer(es, ctx, d, sm, v), ctx, d)
            else:
              if e === Chk/id(&One):
                (0, Chk/cst(Chk/mk0(&Unit)))
              else:
                if e === Chk/id(&Pair):
                  Chk/inferPair(Chk/infer(es, ctx, d, sm, v), Chk/infer(es, ctx, d, sm, v + 1))
                else:
                  if (e === Chk/id(&Nil)) or (e === Chk/id(&Con)) or (e === Chk/id(&Refl)):
                    (2, set)
                  else:
                    if ari === 0:
                      Chk/inferSym(Chk/enumOf(Chk/enums(es), e))
                    else:
                      (1013 + ari, set)

def Chk/inferSym(es: Val[]) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  match es:
    case []:
      (2, Chk/set())
    case e <> rest:
      (0, Chk/cst(e))

def Chk/inferSuc(x: any r: U64. (U64 -> any k: U64. Val) -> Val, ctx: Ent[], d: U64) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  match x:
    case (r, ty):
      if r === 0:
        n = Chk/now(ctx, d, ty)
        if Chk/is(n, &Nat):
          (0, Chk/cst(Chk/mk0(&Nat)))
        else:
          if Chk/is(n, &Eql) and Chk/is(Prim/vfield(n, 0), &Nat):
            (0, Chk/k3(Chk/id(&Eql), Chk/cst(Chk/mk0(&Nat)), Chk/k1(Chk/id(&Suc), Chk/fld(ty, 1)), Chk/k1(Chk/id(&Suc), Chk/fld(ty, 2))))
          else:
            (1, ty)
      else:
        (r, ty)

def Chk/inferPair(a: any r: U64. (U64 -> any k: U64. Val) -> Val, b: any r: U64. (U64 -> any k: U64. Val) -> Val) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  match a:
    case (ra, ta):
      match b:
        case (rb, tb):
          (Chk/then(ra, rb), Chk/k2(Chk/id(&Sig), ta, Chk/konst(tb)))

# binary operators (Core.Check.inferOp2Type)
def Chk/inferOp(es: Bk, ctx: Ent[], d: U64, sm: U64[], op: U64, v: U64) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  match Chk/infer(es, ctx, d, sm, v):
    case (ra, ta):
      match Chk/infer(es, ctx, d, sm, v + 1):
        case (rb, tb):
          if (ra !== 0) or (rb !== 0):
            (Chk/then(ra, rb), ta)
          else:
            Chk/opType(op, Chk/now(ctx, d, ta), Chk/now(ctx, d, tb))

def Chk/numKind(t: Val) -> U64:
  if Chk/is(t, &Num):
    Chk/vext(Prim/vfield(t, 0))
  else:
    0

def Chk/opType(op: U64, a: Val, b: Val) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  ka = Chk/numKind(a)
  kb = Chk/numKind(b)
  bit = Chk/cst(Chk/mk0(&Bool))
  same = (ka !== 0) and (ka === kb)
  bools = Chk/is(a, &Bool) and Chk/is(b, &Bool)
  if op <= 4:
    if same:
      (0, Chk/cst(Chk/mk1(&Num, Prim/vfield(a, 0))))
    else:
      (1, bit)
  else:
    if op >= 11:
      if same or bools:
        (0, bit)
      else:
        (1, bit)
    else:
      if op <= 7:
        if bools:
          (0, bit)
        else:
          if same and (ka !== Chk/id(&Chr)):
            (0, Chk/cst(Chk/u64T()))
          else:
            (1, bit)
      else:
        if same and (ka === Chk/id(&U64)):
          (0, Chk/cst(Chk/u64T()))
        else:
          (1, bit)

# an application spine: a λ head binds its argument (a let; Core infer
# App-Lam); a variable bound to code continues into that code (its slot map
# differs from the arguments'); any other head is inferred and applied
# argument by argument
def Chk/inferApp(es: Bk, ctx: Ent[], d: U64, sm: U64[], h: U64, xs: U64[]) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  Chk/inferAppX(es, ctx, d, h, sm, Chk/codes(xs, sm))

def Chk/inferAppX(es: Bk, ctx: Ent[], d: U64, h: U64, hsm: U64[], xs: (any c: U64. U64[])[]) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  ht = Chk/tag(h)
  if ht === 0:
    Chk/inferAppX(es, ctx, d, Chk/head(h), hsm, Chk/catX(Chk/codes(Chk/args(h, []), hsm), xs))
  else:
    if ht === 2:
      match xs:
        case []:
          (2, Chk/set())
        case x <> rest:
          match rest:
            case []:
              match x:
                case (xc, xsm):
                  match Chk/infer(es, Chk/letEnt(ctx, d, xsm, xc) <> ctx, d + 1, (d + 1) <> hsm, Chk/val(h)):
                    case (r, ty):
                      (r, Chk/under(d + 1, 0, xc, xsm, ty))
            case y <> more:
              (2, Chk/set())
    else:
      if (ht === 12) or (ht === 31) or (ht === 11):
        (2, Chk/set())
      else:
        if Chk/codeHead(ctx, d, h, hsm):
          Chk/inferCodeHead(es, ctx, d, Chk/slot(hsm, Chk/val(h)), xs)
        else:
          if (ht === 8) and (Chk/preIdx(es, Chk/ext(h)) < 18):
            Chk/inferPre(es, ctx, d, Chk/preIdx(es, Chk/ext(h)), xs)
          else:
            match Chk/infer(es, ctx, d, hsm, h):
              case (r, ty):
                if r === 0:
                  Chk/inferArgsX(es, ctx, d, ty, xs)
                else:
                  (r, ty)

def Chk/inferCodeHead(es: Bk, ctx: Ent[], d: U64, k: U64, xs: (any c: U64. U64[])[]) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  match Chk/ent(ctx, d, k):
    case @Def{c, sm2, kind}:
      Chk/inferAppX(es, ctx, d, c, sm2, xs)
    case @Alias{lvl, kind}:
      Chk/inferCodeHead(es, ctx, d, lvl, xs)
    case @Hyp{v, ty}:
      (4011, Chk/set())

# a let binding: an alias when the bound code is a variable
def Chk/letEnt(ctx: Ent[], d: U64, sm: U64[], x: U64) -> Ent:
  k = Chk/varLvl(sm, x)
  if k === 0:
    @Def{x, sm, 0}
  else:
    @Alias{Chk/root(ctx, d, k), 0}

# the prelude's cubical operations (Core.Check: INot/IAnd/IOr, PAp, Coe)
def Chk/arg(xs: U64[], i: U64) -> U64:
  Chk/nthU(xs, i)

def Chk/itv(es: Bk) -> (U64 -> any k: U64. Val) -> Val:
  Chk/cst(Chk/cellv(es, 3))

def Chk/checkAll(es: Bk, ctx: Ent[], d: U64, sm: U64[], xs: U64[], g: (U64 -> any k: U64. Val) -> Val) -> U64:
  match xs:
    case []:
      0
    case x <> rest:
      Chk/then(Chk/check(es, ctx, d, sm, x, g), Chk/checkAll(es, ctx, d, sm, rest, g))

def Chk/checkAllX(es: Bk, ctx: Ent[], d: U64, xs: (any c: U64. U64[])[], g: (U64 -> any k: U64. Val) -> Val) -> U64:
  match xs:
    case []:
      0
    case x <> rest:
      match x:
        case (xc, xsm):
          Chk/then(Chk/check(es, ctx, d, xsm, xc, g), Chk/checkAllX(es, ctx, d, rest, g))

# the type line of a path (P : Interval -> Set)
def Chk/line(es: Bk) -> (U64 -> any k: U64. Val) -> Val:
  Chk/k2(Chk/id(&Pi), Chk/itv(es), Chk/konst(Chk/set()))

def Chk/xcode(x: any c: U64. U64[]) -> (U64 -> any k: U64. Val) -> Val:
  match x:
    case (c, sm):
      Chk/code(c, sm)

def Chk/xcheck(es: Bk, ctx: Ent[], d: U64, x: any c: U64. U64[], g: (U64 -> any k: U64. Val) -> Val) -> U64:
  match x:
    case (c, sm):
      Chk/check(es, ctx, d, sm, c, g)

def Chk/nthX(xs: (any c: U64. U64[])[], i: U64) -> any c: U64. U64[]:
  match xs:
    case []:
      (0, [])
    case x <> rest:
      if i === 0:
        x
      else:
        Chk/nthX(rest, i - 1)

# the prelude operation k applied to xs; an operation given fewer arguments
# than it takes is not yet read (never garbage)
def Chk/inferPre(es: Bk, ctx: Ent[], d: U64, k: U64, xs: (any c: U64. U64[])[]) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  itv = Chk/itv(es)
  n = Chk/lenX(xs)
  if k <= 2:
    if ((k === 0) and (n === 1)) or ((k > 0) and (n === 2)):
      (Chk/checkAllX(es, ctx, d, xs, itv), itv)
    else:
      (3000, Chk/set())
  else:
    if (k === 3) and (n === 2):
      Chk/inferPAt(es, ctx, d, Chk/nthX(xs, 0), Chk/nthX(xs, 1))
    else:
      if (k === 4) and (n === 4):
        pl = Chk/nthX(xs, 0)
        r1 = Chk/xcheck(es, ctx, d, pl, Chk/line(es))
        r2 = Chk/then(Chk/xcheck(es, ctx, d, Chk/nthX(xs, 1), itv), Chk/xcheck(es, ctx, d, Chk/nthX(xs, 2), itv))
        r3 = Chk/xcheck(es, ctx, d, Chk/nthX(xs, 3), Chk/ap(Chk/xcode(pl), Chk/xcode(Chk/nthX(xs, 1))))
        (Chk/then(r1, Chk/then(r2, r3)), Chk/ap(Chk/xcode(pl), Chk/xcode(Chk/nthX(xs, 2))))
      else:
        if (k === 17) and (n === 3):
          match Chk/nthX(xs, 2):
            case (c, sm):
              Chk/infer(es, ctx, d, sm, c)
        else:
          if (k === 5) and (n === 3):
            Chk/inferHcomp(es, ctx, d, Chk/nthX(xs, 0), Chk/nthX(xs, 1), Chk/nthX(xs, 2))
          else:
            (3000, Chk/set())

# p @ r: (<i> t) @ r is t with i := r; otherwise p's type line at r
def Chk/inferPAt(es: Bk, ctx: Ent[], d: U64, px: any c: U64. U64[], rx: any c: U64. U64[]) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  match px:
    case (p, psm):
      match rx:
        case (r, rsm):
          rr = Chk/check(es, ctx, d, rsm, r, Chk/itv(es))
          if Chk/isPLmLam(es, p):
            match Chk/infer(es, Chk/letEnt(ctx, d, rsm, r) <> ctx, d + 1, (d + 1) <> psm, Chk/val(Chk/val(p))):
              case (rb, ty):
                (Chk/then(rr, rb), Chk/under(d + 1, 0, r, rsm, ty))
          else:
            match Chk/infer(es, ctx, d, psm, p):
              case (rp, ty):
                if rp !== 0:
                  (rp, ty)
                else:
                  if Chk/isc(es, Chk/now(ctx, d, ty), 6):
                    (rr, Chk/ap(Chk/fld(ty, 0), Chk/code(r, rsm)))
                  else:
                    (1, ty)

# is the code a path cell <i> t (its body a λ)?  (`and` is strict: nested)
def Chk/isPLmLam(es: Bk, p: U64) -> Bool:
  if (Chk/tag(p) === 14) and (Chk/ext(p) === Chk/cid(es, 2)):
    Chk/tag(Chk/val(p)) === 2
  else:
    False

# ---- faces --------------------------------------------------------------------

# a face formula (a canonical interval: a join of meets of literals) as its
# cells, each a conjunction of literals (level, end); a generator that is no
# hypothesis restricts nothing
def Chk/cells(es: Bk, ctx: Ent[], d: U64, v: Val) -> (any k: U64. U64)[][]:
  if Chk/isc(es, v, 5):
    [[]]
  else:
    if Chk/isc(es, v, 4):
      []
    else:
      if Chk/isc(es, v, 12):
        Chk/cube(es, ctx, d, Prim/vfield(v, 0)) <> Chk/cells(es, ctx, d, Prim/vfield(v, 1))
      else:
        [Chk/cube(es, ctx, d, v)]

def Chk/cube(es: Bk, ctx: Ent[], d: U64, v: Val) -> (any k: U64. U64)[]:
  if Chk/isc(es, v, 11):
    Chk/catL(Chk/literal(es, ctx, d, Prim/vfield(v, 0)), Chk/cube(es, ctx, d, Prim/vfield(v, 1)))
  else:
    Chk/literal(es, ctx, d, v)

def Chk/literal(es: Bk, ctx: Ent[], d: U64, v: Val) -> (any k: U64. U64)[]:
  if Chk/isc(es, v, 10):
    k = Chk/findFree(es, ctx, d, Prim/vfield(v, 0))
    if k === 0:
      []
    else:
      [(k, 0)]
  else:
    k = Chk/findFree(es, ctx, d, v)
    if k === 0:
      []
    else:
      [(k, 1)]

def Chk/catL(xs: (any k: U64. U64)[], ys: (any k: U64. U64)[]) -> (any k: U64. U64)[]:
  match xs:
    case []:
      ys
    case x <> rest:
      x <> Chk/catL(rest, ys)

def Chk/catC(xs: (any k: U64. U64)[][], ys: (any k: U64. U64)[][]) -> (any k: U64. U64)[][]:
  match xs:
    case []:
      ys
    case x <> rest:
      x <> Chk/catC(rest, ys)

def Chk/crossOne(c: (any k: U64. U64)[], ys: (any k: U64. U64)[][]) -> (any k: U64. U64)[][]:
  match ys:
    case []:
      []
    case y <> rest:
      Chk/catL(c, y) <> Chk/crossOne(c, rest)

def Chk/cross(xs: (any k: U64. U64)[][], ys: (any k: U64. U64)[][]) -> (any k: U64. U64)[][]:
  match xs:
    case []:
      []
    case x <> rest:
      Chk/catC(Chk/crossOne(x, ys), Chk/cross(rest, ys))

# the context on a cell: each literal refines its interval variable to i0/i1
def Chk/restrict(es: Bk, ctx: Ent[], d: U64, c: (any k: U64. U64)[]) -> Ent[]:
  match c:
    case []:
      ctx
    case l <> rest:
      match l:
        case (k, e):
          Chk/restrict(es, Chk/refine(ctx, d, k, Chk/cst(Chk/cellv(es, if e === 0: 4 else: 5))), d, rest)

# does a cell give some variable both ends (an empty cell)?
def Chk/clash(c: (any k: U64. U64)[]) -> Bool:
  match c:
    case []:
      False
    case l <> rest:
      match l:
        case (k, e):
          Chk/clashWith(k, e, rest) or Chk/clash(rest)

def Chk/clashWith(k: U64, e: U64, c: (any k: U64. U64)[]) -> Bool:
  match c:
    case []:
      False
    case l <> rest:
      match l:
        case (k2, e2):
          ((k2 === k) and (e2 !== e)) or Chk/clashWith(k, e, rest)

# a static face list #Cons{#Face{p, u}, ..} | #Nil: (formula code, tube code)
def Chk/faces(es: Bk, c: U64) -> (any p: U64. U64)[]:
  if (Chk/tag(c) === 15) and (Chk/ext(c) === Chk/cid(es, 7)):
    f = Chk/val(c)
    (Chk/val(f), Chk/val(f) + 1) <> Chk/faces(es, Chk/val(c) + 1)
  else:
    []

def Chk/isFaces(es: Bk, c: U64) -> Bool:
  if (Chk/tag(c) === 15) and (Chk/ext(c) === Chk/cid(es, 7)):
    Chk/isFaces(es, Chk/val(c) + 1)
  else:
    (Chk/tag(c) === 13) and (Chk/ext(c) === Chk/id(&Nil))

# hcomp(A, faces, x) : A (Core.Check: HCm): each tube u on face p is, on
# every cell of p, a line in A starting at the base; tubes agree on every
# cell where two faces meet (the faces are read under the list's slot map)
def Chk/inferHcomp(es: Bk, ctx: Ent[], d: U64, ax: any c: U64. U64[], fx: any c: U64. U64[], xx: any c: U64. U64[]) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  match fx:
    case (fs, fsm):
      if Chk/isFaces(es, fs):
        faces = Chk/faces(es, fs)
        r1 = Chk/xcheck(es, ctx, d, ax, Chk/set())
        r2 = Chk/xcheck(es, ctx, d, xx, Chk/xcode(ax))
        r3 = Chk/tubes(es, ctx, d, fsm, ax, xx, faces)
        r4 = Chk/adjacent(es, ctx, d, fsm, ax, faces)
        (Chk/then(r1, Chk/then(r2, Chk/then(r3, r4))), Chk/xcode(ax))
      else:
        (4009, Chk/set())

def Chk/tubeGoal(es: Bk, sm: U64[], ax: any c: U64. U64[], xx: any c: U64. U64[], u: U64) -> (U64 -> any k: U64. Val) -> Val:
  Chk/k3(Chk/cid(es, 6), Chk/konst(Chk/xcode(ax)), Chk/xcode(xx), Chk/pat(Chk/code(u, sm), Chk/cst(Chk/cellv(es, 5))))

def Chk/tubes(es: Bk, ctx: Ent[], d: U64, sm: U64[], ax: any c: U64. U64[], xx: any c: U64. U64[], faces: (any p: U64. U64)[]) -> U64:
  match faces:
    case []:
      0
    case f <> rest:
      match f:
        case (p, u):
          rp = Chk/check(es, ctx, d, sm, p, Chk/itv(es))
          ru = Chk/onCells(es, ctx, d, sm, u, Chk/tubeGoal(es, sm, ax, xx, u), Chk/cells(es, ctx, d, Chk/now(ctx, d, Chk/code(p, sm))))
          Chk/then(rp, Chk/then(ru, Chk/tubes(es, ctx, d, sm, ax, xx, rest)))

def Chk/onCells(es: Bk, ctx: Ent[], d: U64, sm: U64[], u: U64, goal: (U64 -> any k: U64. Val) -> Val, cells: (any k: U64. U64)[][]) -> U64:
  match cells:
    case []:
      0
    case c <> rest:
      if Chk/clash(c):
        Chk/onCells(es, ctx, d, sm, u, goal, rest)
      else:
        Chk/then(Chk/check(es, Chk/restrict(es, ctx, d, c), d, sm, u, goal), Chk/onCells(es, ctx, d, sm, u, goal, rest))

def Chk/adjacent(es: Bk, ctx: Ent[], d: U64, sm: U64[], ax: any c: U64. U64[], faces: (any p: U64. U64)[]) -> U64:
  match faces:
    case []:
      0
    case f <> rest:
      Chk/then(Chk/adjWith(es, ctx, d, sm, ax, f, rest), Chk/adjacent(es, ctx, d, sm, ax, rest))

def Chk/adjWith(es: Bk, ctx: Ent[], d: U64, sm: U64[], ax: any c: U64. U64[], f: any p: U64. U64, rest: (any p: U64. U64)[]) -> U64:
  match rest:
    case []:
      0
    case g <> more:
      match f:
        case (p, u):
          match g:
            case (q, w):
              cells = Chk/cross(Chk/cells(es, ctx, d, Chk/now(ctx, d, Chk/code(p, sm))), Chk/cells(es, ctx, d, Chk/now(ctx, d, Chk/code(q, sm))))
              Chk/then(Chk/agree(es, ctx, d, sm, ax, u, w, cells), Chk/adjWith(es, ctx, d, sm, ax, (p, u), more))

# two tubes agree on a cell: equal lines in A
def Chk/agree(es: Bk, ctx: Ent[], d: U64, sm: U64[], ax: any c: U64. U64[], u: U64, w: U64, cells: (any k: U64. U64)[][]) -> U64:
  match cells:
    case []:
      0
    case c <> rest:
      if Chk/clash(c):
        Chk/agree(es, ctx, d, sm, ax, u, w, rest)
      else:
        c2 = Chk/restrict(es, ctx, d, c)
        av = Chk/now(c2, d, Chk/xcode(ax))
        lineT = Prim/vctr(Chk/id(&Pi), [Chk/cellv(es, 3), Fun/val(lambda i. av)])
        Chk/then(Chk/conv(es, lineT, Chk/lineOf(es, Chk/now(c2, d, Chk/code(u, sm))), Chk/lineOf(es, Chk/now(c2, d, Chk/code(w, sm)))), Chk/agree(es, ctx, d, sm, ax, u, w, rest))

# a tube as the function i -> u @ i
def Chk/lineOf(es: Bk, u: Val) -> Val:
  Fun/val(lambda i. Prim/pathAt(u, i))

def Chk/inferArgs(es: Bk, ctx: Ent[], d: U64, sm: U64[], ty: (U64 -> any k: U64. Val) -> Val, xs: U64[]) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  match xs:
    case []:
      (0, ty)
    case x <> rest:
      if Chk/is(Chk/now(ctx, d, ty), &Pi):
        r = Chk/check(es, ctx, d, sm, x, Chk/fld(ty, 0))
        if r === 0:
          Chk/inferArgs(es, ctx, d, sm, Chk/ap(Chk/fld(ty, 1), Chk/code(x, sm)), rest)
        else:
          (r, ty)
      else:
        (1, ty)

# ---- checking --------------------------------------------------------------------

def Chk/check(es: Bk, ctx: Ent[], d: U64, sm: U64[], c: U64, goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  t = Chk/tag(c)
  e = Chk/ext(c)
  v = Chk/val(c)
  if t === 2:
    if Chk/is(Chk/now(ctx, d, goal), &Pi):
      l = d + 1
      Chk/check(es, Chk/hyp(es, Chk/fld(goal, 0)) <> ctx, l, l <> sm, v, Chk/ap(Chk/fld(goal, 1), Chk/lvl(l)))
    else:
      2
  else:
    if t === 46:
      Chk/checkSta(es, ctx, d, sm, e, v, goal)
    else:
      if t === 6:
        Chk/check(es, Chk/dupEnt(ctx, d, sm, v) <> ctx, d + 1, (d + 1) <> sm, v + 1, goal)
      else:
        if t === 11:
          0
        else:
          if t === 5:
            Chk/then(Chk/check(es, ctx, d, sm, v, goal), Chk/check(es, ctx, d, sm, v + 1, goal))
          else:
            Chk/checkNode(es, ctx, d, sm, c, t, e, v, goal)

# the remaining node kinds of check
def Chk/checkNode(es: Bk, ctx: Ent[], d: U64, sm: U64[], c: U64, t: U64, e: U64, v: U64, goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  if (t >= 13) and (t <= 29):
    Chk/checkCtr(es, ctx, d, sm, c, t - 13, e, v, goal)
  else:
    if t === 30:
      g = Chk/now(ctx, d, goal)
      if Chk/is(g, &Num) or (Chk/is(g, &Bool) and (v <= 1)):
        0
      else:
        Chk/verify(es, ctx, d, sm, c, goal)
    else:
      if t === 0:
        Chk/checkApp(es, ctx, d, (c, sm), Chk/head(c), sm, Chk/codes(Chk/args(c, []), sm), goal)
      else:
        if (t === 12) or (t === 31):
          1000 + t
        else:
          if (t === 42) or (t === 43) or (t === 44):
            Chk/checkVar(es, ctx, d, sm, c, Chk/slot(sm, v), goal)
          else:
            Chk/verify(es, ctx, d, sm, c, goal)

def Chk/codes(xs: U64[], sm: U64[]) -> (any c: U64. U64[])[]:
  match xs:
    case []:
      []
    case x <> rest:
      (x, sm) <> Chk/codes(rest, sm)

# a variable bound to code (a let, a dup of code) is that code: it is
# checked where it is used (Core substitutes the let)
def Chk/checkVar(es: Bk, ctx: Ent[], d: U64, sm: U64[], c: U64, k: U64, goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  match Chk/ent(ctx, d, k):
    case @Def{loc, sm2, kind}:
      Chk/check(es, ctx, d, sm2, loc, goal)
    case @Alias{lvl, kind}:
      Chk/checkVar(es, ctx, d, sm, c, lvl, goal)
    case @Hyp{hv, ty}:
      Chk/verify(es, ctx, d, sm, c, goal)

# the inferred type is the goal (conversion at Set)
def Chk/verify(es: Bk, ctx: Ent[], d: U64, sm: U64[], c: U64, goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  match Chk/infer(es, ctx, d, sm, c):
    case (r, ty):
      if r === 0:
        Chk/convT(es, Chk/now(ctx, d, ty), Chk/now(ctx, d, goal))
      else:
        r

def Chk/checkSta(es: Bk, ctx: Ent[], d: U64, sm: U64[], k: U64, v: U64, goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  if k === 1:
    Chk/then(Chk/check(es, ctx, d, sm, v, Chk/cst(Chk/mk1(&List, Chk/mk1(&Num, Chk/mk0(&Chr))))), Chk/check(es, ctx, d, sm, v + 1, goal))
  else:
    if k === 0:
      Chk/then(Chk/check(es, ctx, d, sm, v + 1, Chk/code(v, sm)), Chk/convT(es, Chk/now(ctx, d, Chk/code(v, sm)), Chk/now(ctx, d, goal)))
    else:
      2

def Chk/checkCtr(es: Bk, ctx: Ent[], d: U64, sm: U64[], c: U64, ari: U64, e: U64, v: U64, goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  g = Chk/now(ctx, d, goal)
  if (e === Chk/cid(es, 2)) and Chk/isc(es, g, 6):
    Chk/checkPLm(es, ctx, d, sm, c, v, goal)
  else:
    if (e === Chk/cid(es, 0)) and Chk/isc(es, g, 6):
      Chk/checkCompU(es, ctx, d, sm, v, goal)
    else:
      Chk/checkCtr0(es, ctx, d, sm, c, ari, e, v, goal)

# <i> t : Path(P, a, b): t : P(i) for a generic i, and its faces are a, b
def Chk/checkPLm(es: Bk, ctx: Ent[], d: U64, sm: U64[], c: U64, v: U64, goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  rb = Chk/plmBody(es, ctx, d, sm, v, goal)
  if rb < 4000:
    g = Chk/now(ctx, d, goal)
    pl = Chk/now(ctx, d, Chk/fld(Chk/code(c, sm), 0))
    p = Prim/vfield(g, 0)
    z0 = Chk/cellv(es, 4)
    z1 = Chk/cellv(es, 5)
    r0 = Chk/conv(es, Prim/vapp(p, z0), Prim/vapp(pl, z0), Prim/vfield(g, 1))
    r1 = Chk/conv(es, Prim/vapp(p, z1), Prim/vapp(pl, z1), Prim/vfield(g, 2))
    Chk/then(rb, Chk/then(r0, r1))
  else:
    rb

# the body of <i> t: t : P(i) for a generic i (through descent lets)
def Chk/plmBody(es: Bk, ctx: Ent[], d: U64, sm: U64[], v: U64, goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  if Chk/isLetApp(v):
    Chk/plmBody(es, Chk/letEnt(ctx, d, sm, Chk/val(v) + 1) <> ctx, d + 1, (d + 1) <> sm, Chk/val(Chk/val(v)), goal)
  else:
    if Chk/tag(v) === 2:
      l = d + 1
      Chk/check(es, Chk/hyp(es, Chk/itv(es)) <> ctx, l, l <> sm, Chk/val(v), Chk/ap(Chk/fld(goal, 0), Chk/lvl(l)))
    else:
      4008

# a composite of two type lines (the lowering of <i> hcomp(Set, ..)): both
# are lines of types, the first ends where the second starts, and the
# composite runs from the first's start to the second's end
def Chk/checkCompU(es: Bk, ctx: Ent[], d: U64, sm: U64[], v: U64, goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  pl = Chk/now(ctx, d, Chk/code(v, sm))
  ql = Chk/now(ctx, d, Chk/code(v + 1, sm))
  g = Chk/now(ctx, d, goal)
  e0 = Chk/cellv(es, 4)
  e1 = Chk/cellv(es, 5)
  r1 = Chk/checkAll(es, ctx, d, sm, [v, v + 1], Chk/line(es))
  r2 = Chk/convT(es, Prim/vapp(pl, e1), Prim/vapp(ql, e0))
  r3 = Chk/convT(es, Prim/vapp(pl, e0), Prim/vfield(g, 1))
  r4 = Chk/convT(es, Prim/vapp(ql, e1), Prim/vfield(g, 2))
  Chk/then(r1, Chk/then(r2, Chk/then(r3, r4)))

def Chk/checkCtr0(es: Bk, ctx: Ent[], d: U64, sm: U64[], c: U64, ari: U64, e: U64, v: U64, goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  g = Chk/now(ctx, d, goal)
  if (e === Chk/id(&Zer)) and Chk/is(g, &Nat):
    0
  else:
    if (e === Chk/id(&Suc)) and Chk/is(g, &Nat):
      Chk/check(es, ctx, d, sm, v, goal)
    else:
      if (e === Chk/id(&Suc)) and Chk/is(g, &Eql) and Chk/is(Prim/vfield(g, 1), &Suc) and Chk/is(Prim/vfield(g, 2), &Suc):
        Chk/check(es, ctx, d, sm, v, Chk/k3(Chk/id(&Eql), Chk/fld(goal, 0), Chk/fld(Chk/fld(goal, 1), 0), Chk/fld(Chk/fld(goal, 2), 0)))
      else:
        if e === Chk/id(&Nil):
          if Chk/is(g, &List):
            0
          else:
            1
        else:
          if (e === Chk/id(&Con)) and Chk/is(g, &List):
            Chk/then(Chk/check(es, ctx, d, sm, v, Chk/fld(goal, 0)), Chk/check(es, ctx, d, sm, v + 1, goal))
          else:
            if (e === Chk/id(&One)) and Chk/is(g, &Unit):
              0
            else:
              if (e === Chk/id(&Pair)) and Chk/is(g, &Sig):
                Chk/then(Chk/check(es, ctx, d, sm, v, Chk/fld(goal, 0)), Chk/check(es, ctx, d, sm, v + 1, Chk/ap(Chk/fld(goal, 1), Chk/code(v, sm))))
              else:
                if (e === Chk/id(&Refl)) and Chk/is(g, &Eql):
                  Chk/conv(es, Prim/vfield(g, 0), Prim/vfield(g, 1), Prim/vfield(g, 2))
                else:
                  if (ari === 0) and Chk/is(g, &Enum):
                    if Chk/hasSym(Prim/vfield(g, 0), e):
                      0
                    else:
                      1
                  else:
                    Chk/verify(es, ctx, d, sm, c, goal)

# (f x ..) against a goal. The head h is code under hsm; each argument is
# code with its own slot map (a head bound by a let continues into its code,
# whose slot map differs from the arguments'). A match (Core's eliminators,
# lowered with their environment passed after the scrutinee), a λ head (a
# let), a variable bound to code (continue into it), or inference.
def Chk/checkApp(es: Bk, ctx: Ent[], d: U64, whole: any c: U64. U64[], h: U64, hsm: U64[], xs: (any c: U64. U64[])[], goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  ht = Chk/tag(h)
  if ht === 0:
    Chk/checkApp(es, ctx, d, whole, Chk/head(h), hsm, Chk/catX(Chk/codes(Chk/args(h, []), hsm), xs), goal)
  else:
    if (ht === 12) or (ht === 31) or (ht === 11):
      match xs:
        case []:
          2
        case x <> env:
          Chk/checkMatch(es, ctx, d, h, hsm, x, env, goal)
    else:
      if ht === 2:
        Chk/checkLamApp(es, ctx, d, h, hsm, xs, goal)
      else:
        if Chk/codeHead(ctx, d, h, hsm):
          Chk/checkCodeHead(es, ctx, d, whole, Chk/slot(hsm, Chk/val(h)), xs, goal)
        else:
          # a primitive of the runtime (an extern body): its declared type is
          # its specification (Core: Pri EXTERN checks)
          if ht === 45:
            0
          else:
            Chk/checkAppPre(es, ctx, d, whole, h, hsm, xs, goal)

# is the head a variable bound to code?  (`and` is strict: nested)
def Chk/codeHead(ctx: Ent[], d: U64, h: U64, hsm: U64[]) -> Bool:
  if Chk/tag(h) === 42:
    Chk/isCode(ctx, d, Chk/slot(hsm, Chk/val(h)))
  else:
    False

def Chk/catX(xs: (any c: U64. U64[])[], ys: (any c: U64. U64[])[]) -> (any c: U64. U64[])[]:
  match xs:
    case []:
      ys
    case x <> rest:
      x <> Chk/catX(rest, ys)

# is the level bound to code (a let / dup of code), following aliases?
def Chk/isCode(ctx: Ent[], d: U64, k: U64) -> Bool:
  if (k === 0) or (k > d):
    False
  else:
    Chk/isCodeAt(ctx, d, k)

def Chk/isCodeAt(ctx: Ent[], d: U64, k: U64) -> Bool:
  match Chk/ent(ctx, d, k):
    case @Def{c, sm, kind}:
      True
    case @Alias{lvl, kind}:
      Chk/isCode(ctx, d, lvl)
    case @Hyp{v, ty}:
      False

def Chk/checkCodeHead(es: Bk, ctx: Ent[], d: U64, whole: any c: U64. U64[], k: U64, xs: (any c: U64. U64[])[], goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  match Chk/ent(ctx, d, k):
    case @Def{c, sm2, kind}:
      Chk/checkApp(es, ctx, d, whole, c, sm2, xs, goal)
    case @Alias{lvl, kind}:
      Chk/checkCodeHead(es, ctx, d, whole, lvl, xs, goal)
    case @Hyp{v, ty}:
      4011

# a definition's path with its faces: the body checks against the goal,
# and the faces are the goal's endpoints; any other head is inferred
def Chk/checkAppPre(es: Bk, ctx: Ent[], d: U64, whole: any c: U64. U64[], h: U64, hsm: U64[], xs: (any c: U64. U64[])[], goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  if (Chk/tag(h) === 8) and (Chk/preIdx(es, Chk/ext(h)) === 17) and Chk/oneSm(xs):
    g = Chk/now(ctx, d, goal)
    sm = Chk/xsm(xs)
    rb = Chk/check(es, ctx, d, sm, Chk/xat(xs, 2), goal)
    if Chk/isc(es, g, 6):
      p = Prim/vfield(g, 0)
      a = Chk/now(ctx, d, Chk/code(Chk/xat(xs, 0), sm))
      b = Chk/now(ctx, d, Chk/code(Chk/xat(xs, 1), sm))
      Chk/then(rb, Chk/then(Chk/conv(es, Prim/vapp(p, Chk/cellv(es, 4)), a, Prim/vfield(g, 1)), Chk/conv(es, Prim/vapp(p, Chk/cellv(es, 5)), b, Prim/vfield(g, 2))))
    else:
      rb
  else:
    match whole:
      case (c, sm):
        if Chk/sameSm(xs, sm) and Chk/sameSmH(hsm, sm):
          Chk/verify(es, ctx, d, sm, c, goal)
        else:
          Chk/verifyX(es, ctx, d, h, hsm, xs, goal)

# a spine whose head and arguments are code under different slot maps (a
# head bound by a let): the head is inferred, then applied argument by
# argument, and the result is the goal
def Chk/verifyX(es: Bk, ctx: Ent[], d: U64, h: U64, hsm: U64[], xs: (any c: U64. U64[])[], goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  match Chk/inferAppX(es, ctx, d, h, hsm, xs):
    case (r, ty):
      if r !== 0:
        r
      else:
        Chk/convT(es, Chk/now(ctx, d, ty), Chk/now(ctx, d, goal))

def Chk/inferArgsX(es: Bk, ctx: Ent[], d: U64, ty: (U64 -> any k: U64. Val) -> Val, xs: (any c: U64. U64[])[]) -> any r: U64. (U64 -> any k: U64. Val) -> Val:
  match xs:
    case []:
      (0, ty)
    case x <> rest:
      match x:
        case (xc, xsm):
          if Chk/is(Chk/now(ctx, d, ty), &Pi):
            r = Chk/check(es, ctx, d, xsm, xc, Chk/fld(ty, 0))
            if r === 0:
              Chk/inferArgsX(es, ctx, d, Chk/ap(Chk/fld(ty, 1), Chk/code(xc, xsm)), rest)
            else:
              (r, ty)
          else:
            (1, ty)

def Chk/xat(xs: (any c: U64. U64[])[], i: U64) -> U64:
  match xs:
    case []:
      0
    case x <> rest:
      if i === 0:
        match x:
          case (c, sm):
            c
      else:
        Chk/xat(rest, i - 1)

def Chk/xsm(xs: (any c: U64. U64[])[]) -> U64[]:
  match xs:
    case []:
      []
    case x <> rest:
      match x:
        case (c, sm):
          sm

def Chk/eqU(a: U64[], b: U64[]) -> Bool:
  match a:
    case []:
      match b:
        case []:
          True
        case y <> ys:
          False
    case x <> xs:
      match b:
        case []:
          False
        case y <> ys:
          (x === y) and Chk/eqU(xs, ys)

def Chk/oneSm(xs: (any c: U64. U64[])[]) -> Bool:
  Chk/sameSm(xs, Chk/xsm(xs))

def Chk/sameSm(xs: (any c: U64. U64[])[], sm: U64[]) -> Bool:
  match xs:
    case []:
      True
    case x <> rest:
      match x:
        case (c, s):
          Chk/eqU(s, sm) and Chk/sameSm(rest, sm)

def Chk/sameSmH(a: U64[], b: U64[]) -> Bool:
  Chk/eqU(a, b)

# (λx. b)(a1)..(an): a1 is bound (a let); each later argument is a generic
# element of its inferred type (Core: check f against ∀(typeof x). goal)
def Chk/checkLamApp(es: Bk, ctx: Ent[], d: U64, h: U64, hsm: U64[], xs: (any c: U64. U64[])[], goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  match xs:
    case []:
      Chk/check(es, ctx, d, hsm, h, goal)
    case x <> rest:
      match x:
        case (xc, xsm):
          Chk/lamArgs(es, Chk/letEnt(ctx, d, xsm, xc) <> ctx, d + 1, (d + 1) <> hsm, Chk/val(h), rest, goal)

def Chk/lamArgs(es: Bk, ctx: Ent[], d: U64, sm: U64[], c: U64, xs: (any c: U64. U64[])[], goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  match xs:
    case []:
      Chk/check(es, ctx, d, sm, c, goal)
    case x <> rest:
      if Chk/tag(c) === 6:
        Chk/lamArgs(es, Chk/dupEnt(ctx, d, sm, Chk/val(c)) <> ctx, d + 1, (d + 1) <> sm, Chk/val(c) + 1, x <> rest, goal)
      else:
        if Chk/tag(c) === 2:
          match x:
            case (xc, xsm):
              if Chk/isLet(c):
                Chk/lamArgs(es, Chk/letEnt(ctx, d, xsm, xc) <> ctx, d + 1, (d + 1) <> sm, Chk/val(c), rest, goal)
              else:
                match Chk/infer(es, ctx, d, xsm, xc):
                  case (r, ty):
                    if r === 0:
                      Chk/lamArgs(es, Chk/hyp(es, ty) <> ctx, d + 1, (d + 1) <> sm, Chk/val(c), rest, goal)
                    else:
                      r
        else:
          # a body that is itself an application takes the rest as arguments
          Chk/checkApp(es, ctx, d, (c, sm), c, sm, xs, goal)

# ---- with-abstraction -------------------------------------------------------------

# The goal of a match on a scrutinee that is no variable is the motive at the
# scrutinee: each arm's goal is that motive at the arm's pattern, i.e. the
# goal with the scrutinee's occurrences replaced by the pattern (Core: Rwt);
# a stuck call is re-applied, so it steps once its argument is revealed.
def Chk/rw(old: Val, neo: Val, t: Val) -> Val:
  if Prim/veql(t, old):
    neo
  else:
    Chk/rwIn(old, neo, t, Chk/vtag(t))

def Chk/rwIn(old: Val, neo: Val, t: Val, tg: U64) -> Val:
  if (tg >= 13) and (tg <= 29):
    Prim/vctr(Chk/vext(t), Chk/rwFields(old, neo, t, 0, tg - 13))
  else:
    if tg === 2:
      Fun/val(lambda x. Chk/rw(old, neo, Prim/vapp(t, x)))
    else:
      if tg === 10:
        Prim/vapp(Chk/rw(old, neo, Prim/vdry(t, 0)), Chk/rw(old, neo, Prim/vdry(t, 1)))
      else:
        t

def Chk/rwFields(old: Val, neo: Val, t: Val, i: U64, n: U64) -> Val[]:
  if i === n:
    []
  else:
    Chk/rw(old, neo, Prim/vfield(t, i)) <> Chk/rwFields(old, neo, t, i + 1, n)

def Chk/rwG(o: (U64 -> any k: U64. Val) -> Val, n: (U64 -> any k: U64. Val) -> Val, g: (U64 -> any k: U64. Val) -> Val) -> (U64 -> any k: U64. Val) -> Val:
  lambda l. Chk/rw(o(l), n(l), g(l))

# the goal of an arm: refined through the scrutinee's level when it is a
# variable (kr), through its occurrences otherwise
def Chk/refG(kr: U64, xv: (U64 -> any k: U64. Val) -> Val, p: (U64 -> any k: U64. Val) -> Val, goal: (U64 -> any k: U64. Val) -> Val) -> (U64 -> any k: U64. Val) -> Val:
  if kr === 0:
    Chk/rwG(xv, p, goal)
  else:
    goal

# ---- matches ---------------------------------------------------------------------

def Chk/checkMatch(es: Bk, ctx: Ent[], d: U64, h: U64, hsm: U64[], x: any c: U64. U64[], env: (any c: U64. U64[])[], goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  match x:
    case (xc, xsm):
      match Chk/infer(es, ctx, d, xsm, xc):
        case (r, xT):
          if r !== 0:
            r
          else:
            xt = Chk/now(ctx, d, xT)
            kr = Chk/rootOf(ctx, d, Chk/varLvl(xsm, xc))
            if Chk/tag(h) === 11:
              if Chk/is(xt, &Empty):
                0
              else:
                if Chk/is(xt, &Eql):
                  if Chk/conv(es, Prim/vfield(xt, 0), Prim/vfield(xt, 1), Prim/vfield(xt, 2)) === 0:
                    1
                  else:
                    0
                else:
                  1
            else:
              Chk/arms(es, ctx, d, hsm, h, xT, kr, Chk/code(xc, xsm), env, goal, [])

def Chk/rootOf(ctx: Ent[], d: U64, k: U64) -> U64:
  if k === 0:
    0
  else:
    Chk/root(ctx, d, k)

# does the symbol list contain only symbols in cov?
def Chk/covered(xs: Val, cov: U64[]) -> Bool:
  if Chk/is(xs, &Con):
    if Chk/elemU(Chk/vext(Prim/vfield(xs, 0)), cov):
      Chk/covered(Prim/vfield(xs, 1), cov)
    else:
      False
  else:
    True

def Chk/elemU(x: U64, xs: U64[]) -> Bool:
  match xs:
    case []:
      False
    case h <> t:
      if h === x:
        True
      else:
        Chk/elemU(x, t)

# walk the arms of a match chain (cov: the constructors seen so far)
def Chk/arms(es: Bk, ctx: Ent[], d: U64, sm: U64[], h: U64, xT: (U64 -> any k: U64. Val) -> Val, kr: U64, xv: (U64 -> any k: U64. Val) -> Val, env: (any c: U64. U64[])[], goal: (U64 -> any k: U64. Val) -> Val, cov: U64[]) -> U64:
  t = Chk/tag(h)
  e = Chk/ext(h)
  v = Chk/val(h)
  xt = Chk/now(ctx, d, xT)
  if t === 12:
    Chk/then(Chk/arm(es, ctx, d, sm, v, e, xT, kr, xv, env, goal), Chk/arms(es, ctx, d, sm, v + 1, xT, kr, xv, env, goal, e <> cov))
  else:
    if t === 31:
      if Chk/is(xt, &Bool) and (e === 0):
        f = Chk/cst(Num/val(0))
        Chk/then(Chk/armFields(es, Chk/refine(ctx, d, kr, f), d, sm, v, env, Chk/refG(kr, xv, f, goal)), Chk/arms(es, ctx, d, sm, v + 1, xT, kr, xv, env, goal, cov))
      else:
        4002
    else:
      if t === 30:
        0
      else:
        if t === 2:
          if Chk/is(xt, &Bool):
            tr = Chk/cst(Num/val(1))
            ctx2 = @Hyp{tr, Chk/cst(Chk/mk0(&Bool))} <> ctx
            Chk/armFields(es, Chk/refine(ctx2, d + 1, kr, tr), d + 1, (d + 1) <> sm, v, env, Chk/refG(kr, xv, tr, goal))
          else:
            if Chk/is(xt, &Enum):
              # Core: a default is read only when the arms do not cover the
              # enum, and the absent default (λ_. ()) is an incomplete match
              if Chk/covered(Prim/vfield(xt, 0), cov):
                0
              else:
                if Chk/absentDefault(v, Chk/lenX(env)):
                  1
                else:
                  ctx2 = Chk/hyp(es, xT) <> ctx
                  Chk/armFields(es, Chk/refine(ctx2, d + 1, kr, Chk/lvl(d + 1)), d + 1, (d + 1) <> sm, v, env, Chk/refG(kr, xv, Chk/lvl(d + 1), goal))
            else:
              1
        else:
          4003

def Chk/lenX(xs: (any c: U64. U64[])[]) -> U64:
  match xs:
    case []:
      0
    case x <> rest:
      1 + Chk/lenX(rest)

# the default arm the flattener adds when none is written: λ_. λenv.. ()
def Chk/absentDefault(c: U64, n: U64) -> Bool:
  if Chk/tag(c) === 2:
    if n === 0:
      (Chk/tag(Chk/val(c)) === 13) and (Chk/ext(Chk/val(c)) === Chk/id(&One))
    else:
      Chk/absentDefault(Chk/val(c), n - 1)
  else:
    False

# one constructor arm: its fields are generic elements of the field types,
# then the scrutinee is refined to the constructor of those fields
def Chk/arm(es: Bk, ctx: Ent[], d: U64, sm: U64[], a: U64, e: U64, xT: (U64 -> any k: U64. Val) -> Val, kr: U64, xv: (U64 -> any k: U64. Val) -> Val, env: (any c: U64. U64[])[], goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  xt = Chk/now(ctx, d, xT)
  if (e === Chk/id(&Zer)) and Chk/is(xt, &Nat):
    Chk/armFields(es, Chk/refine(ctx, d, kr, Chk/cst(Chk/mk0(&Zer))), d, sm, a, env, Chk/refG(kr, xv, Chk/cst(Chk/mk0(&Zer)), goal))
  else:
    if (e === Chk/id(&Suc)) and Chk/is(xt, &Nat):
      Chk/arm1(es, ctx, d, sm, a, Chk/cst(Chk/mk0(&Nat)), kr, xv, lambda l1. Chk/k1(Chk/id(&Suc), Chk/lvl(l1)), env, goal)
    else:
      if (e === Chk/id(&Nil)) and Chk/is(xt, &List):
        Chk/armFields(es, Chk/refine(ctx, d, kr, Chk/cst(Chk/mk0(&Nil))), d, sm, a, env, Chk/refG(kr, xv, Chk/cst(Chk/mk0(&Nil)), goal))
      else:
        if (e === Chk/id(&Con)) and Chk/is(xt, &List):
          Chk/arm2(es, ctx, d, sm, a, Chk/fld(xT, 0), lambda l1. xT, kr, xv, Chk/id(&Con), env, goal)
        else:
          if (e === Chk/id(&One)) and Chk/is(xt, &Unit):
            Chk/armFields(es, Chk/refine(ctx, d, kr, Chk/cst(Chk/mk0(&One))), d, sm, a, env, Chk/refG(kr, xv, Chk/cst(Chk/mk0(&One)), goal))
          else:
            if (e === Chk/id(&Pair)) and Chk/is(xt, &Sig):
              Chk/arm2(es, ctx, d, sm, a, Chk/fld(xT, 0), lambda l1. Chk/ap(Chk/fld(xT, 1), Chk/lvl(l1)), kr, xv, Chk/id(&Pair), env, goal)
            else:
              if (e === Chk/id(&Refl)) and Chk/is(xt, &Eql):
                Chk/armJ(es, ctx, d, sm, a, xt, kr, xv, env, goal)
              else:
                if Chk/is(xt, &Enum) and Chk/hasSym(Prim/vfield(xt, 0), e):
                  Chk/armFields(es, Chk/refine(ctx, d, kr, Chk/cst(Prim/vctr(e, []))), d, sm, a, env, Chk/refG(kr, xv, Chk/cst(Prim/vctr(e, [])), goal))
                else:
                  1

# J: the scrutinee is refl, and the endpoint a is identified with b: an
# alias of b's level when a is a variable, a's occurrences in the goal
# replaced by b otherwise (Core: Rwt a b goal)
def Chk/armJ(es: Bk, ctx: Ent[], d: U64, sm: U64[], a: U64, xt: Val, kr: U64, xv: (U64 -> any k: U64. Val) -> Val, env: (any c: U64. U64[])[], goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  refl = Chk/cst(Chk/mk0(&Refl))
  c1 = Chk/refine(ctx, d, kr, refl)
  g1 = Chk/refG(kr, xv, refl, goal)
  ka = Chk/findFree(es, c1, d, Prim/vfield(xt, 1))
  kb = Chk/findFree(es, c1, d, Prim/vfield(xt, 2))
  if ka === 0:
    Chk/armFields(es, c1, d, sm, a, env, Chk/rwG(Chk/cst(Prim/vfield(xt, 1)), Chk/cst(Prim/vfield(xt, 2)), g1))
  else:
    if ka === kb:
      Chk/armFields(es, c1, d, sm, a, env, g1)
    else:
      eb = if kb === 0: Chk/cst(Prim/vfield(xt, 2)) else: Chk/lvl(kb)
      Chk/armFields(es, Chk/refine(c1, d, ka, eb), d, sm, a, env, g1)

# an arm's leading descent binding (a frame entry around its binders)
def Chk/isLetApp(c: U64) -> Bool:
  (Chk/tag(c) === 0) and Chk/isLet(Chk/val(c))

def Chk/arm1(es: Bk, ctx: Ent[], d: U64, sm: U64[], a: U64, fT: (U64 -> any k: U64. Val) -> Val, kr: U64, xv: (U64 -> any k: U64. Val) -> Val, pat: U64 -> (U64 -> any k: U64. Val) -> Val, env: (any c: U64. U64[])[], goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  t = Chk/tag(a)
  if t === 6:
    Chk/arm1(es, Chk/dupEnt(ctx, d, sm, Chk/val(a)) <> ctx, d + 1, (d + 1) <> sm, Chk/val(a) + 1, fT, kr, xv, pat, env, goal)
  else:
    if Chk/isLetApp(a):
      Chk/arm1(es, Chk/letEnt(ctx, d, sm, Chk/val(a) + 1) <> ctx, d + 1, (d + 1) <> sm, Chk/val(Chk/val(a)), fT, kr, xv, pat, env, goal)
    else:
      if t === 2:
        ctx2 = Chk/hyp(es, fT) <> ctx
        Chk/armFields(es, Chk/refine(ctx2, d + 1, kr, pat(d + 1)), d + 1, (d + 1) <> sm, Chk/val(a), env, Chk/refG(kr, xv, pat(d + 1), goal))
      else:
        4004

# a two-field arm: the first field's level is known when the second's type
# and the pattern are built
def Chk/arm2(es: Bk, ctx: Ent[], d: U64, sm: U64[], a: U64, fT: (U64 -> any k: U64. Val) -> Val, gT: U64 -> (U64 -> any k: U64. Val) -> Val, kr: U64, xv: (U64 -> any k: U64. Val) -> Val, t: U64, env: (any c: U64. U64[])[], goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  ta = Chk/tag(a)
  if ta === 6:
    Chk/arm2(es, Chk/dupEnt(ctx, d, sm, Chk/val(a)) <> ctx, d + 1, (d + 1) <> sm, Chk/val(a) + 1, fT, gT, kr, xv, t, env, goal)
  else:
    if Chk/isLetApp(a):
      Chk/arm2(es, Chk/letEnt(ctx, d, sm, Chk/val(a) + 1) <> ctx, d + 1, (d + 1) <> sm, Chk/val(Chk/val(a)), fT, gT, kr, xv, t, env, goal)
    else:
      if ta === 2:
        l1 = d + 1
        Chk/arm1(es, Chk/hyp(es, fT) <> ctx, l1, l1 <> sm, Chk/val(a), gT(l1), kr, xv, lambda l2. Chk/k2(t, Chk/lvl(l1), Chk/lvl(l2)), env, goal)
      else:
        4005

# the environment binders of an arm alias the variables passed after the
# scrutinee; then the arm body is checked against the (refined) goal
def Chk/armFields(es: Bk, ctx: Ent[], d: U64, sm: U64[], a: U64, env: (any c: U64. U64[])[], goal: (U64 -> any k: U64. Val) -> Val) -> U64:
  match env:
    case []:
      Chk/check(es, ctx, d, sm, a, goal)
    case x <> rest:
      ta = Chk/tag(a)
      if ta === 6:
        Chk/armFields(es, Chk/dupEnt(ctx, d, sm, Chk/val(a)) <> ctx, d + 1, (d + 1) <> sm, Chk/val(a) + 1, x <> rest, goal)
      else:
        if Chk/isLetApp(a):
          Chk/armFields(es, Chk/letEnt(ctx, d, sm, Chk/val(a) + 1) <> ctx, d + 1, (d + 1) <> sm, Chk/val(Chk/val(a)), x <> rest, goal)
        else:
          if ta === 2:
            match x:
              case (xc, xsm):
                Chk/armFields(es, Chk/letEnt(ctx, d, xsm, xc) <> ctx, d + 1, (d + 1) <> sm, Chk/val(a), rest, goal)
          else:
            4006

# ---- the book -------------------------------------------------------------------

# every definition: its type's code against Set, then its code against the
# type cell (Core.CLI.checkDefinitions); (book id, result) in order
def Chk/all(defs: (any c: U64. any t: U64. U64)[], pre: U64[], cells: Val[]) -> (any i: U64. U64)[]:
  Chk/each(@Bk{Chk/enumsOf(defs), pre, cells}, defs)

def Chk/each(es: Bk, defs: (any c: U64. any t: U64. U64)[]) -> (any i: U64. U64)[]:
  match defs:
    case []:
      []
    case p <> rest:
      match p:
        case (c, q):
          match q:
            case (tc, i):
              r = Chk/then(Chk/check(es, [], 0, [], tc, Chk/set()), Chk/check(es, [], 0, [], c, Chk/cst(Prim/typeof(i))))
              (i, r) <> Chk/each(es, rest)

# (enum types last: the parser reads no `A{a == b}` signature after one)
def Tag() -> Set:
  &{&Pi, &Sig, &Set, &Nat, &Bool, &Unit, &Empty, &List, &Enum, &Num, &U64, &Chr, &Eql, &Zer, &Suc, &Nil, &Con, &One, &Pair, &Refl}
