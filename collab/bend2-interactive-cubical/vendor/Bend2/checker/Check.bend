# The checker on the net: the `verify` projection (One §14) of the book.
#
# It reads each definition's STATIC BOOK TERM (the lowered syntax at BOOK[id],
# de Bruijn levels; the same heap words every execution instantiates) and
# never evaluates the checked term. Types are evaluated, on the same net, and
# compared by conversion of their cells.
#
# Context. Every binder the checker enters gets a level; a static subterm is
# always paired with its slot map (static level -> context level), so the same
# code can be read at any depth. Types and goals are functions of the
# context's lookup (level -> value): refining a matched variable replaces its
# entry, and every goal and type that mentions it sees the refinement
# (normalisation by evaluation; Core's Rwt, without a syntactic rewrite).
#
# Result codes: 0 checks, 1 mismatch, 2 cannot infer, >= 1000 not yet on the net
# (1000 + tag: a static node kind; 3000: a prelude reference; 4000 + n: a site).

# ---- the runtime primitives (hvm.c, APP-PRI) --------------------------------

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

def Prim/conv(a: Val, b: Val) -> Bool:
  extern

def Prim/typeof(i: U64) -> Val:
  extern

def Prim/vctr(c: U64, fs: Val[]) -> Val:
  extern

def Prim/rewrite(old: Val, neo: Val, t: Val) -> Val:
  extern

# development: prints x's normal form to stderr, answers y
def Prim/trace(x: Val, y: U64) -> U64:
  extern

def Fun/val(f: Val -> Val) -> Val:
  extern

def Num/val(n: U64) -> Val:
  extern

# ---- cell names ---------------------------------------------------------------

def Tag() -> Set:
  &{&Pi, &Sig, &Set, &Nat, &Bool, &Unit, &Empty, &List, &Enum, &Num, &U64, &Chr, &Eql, &Zer, &Suc, &Nil, &Con, &One, &Pair, &Refl}

def Tag/vpeek(t: Tag()) -> any t: U64. any e: U64. U64:
  extern

def Chk/id(t: Tag()) -> U64:
  match Tag/vpeek(t):
    case (a, r):
      match r:
        case (e, v):
          e

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

# ---- context ------------------------------------------------------------------

def Ty() -> Set:
  (U64 -> Val) -> Val

type Ent:
  case @Free:
    nam: Val
    ty: (U64 -> Val) -> Val
  case @Refn:
    val: (U64 -> Val) -> Val
    ty: (U64 -> Val) -> Val
  case @Let:
    loc: U64
    sm: U64[]
  case @Alias:
    lvl: U64
    kind: U64
  case @Dup:
    loc: U64
    sm: U64[]

def Chk/nthE(xs: Ent[], i: U64) -> Ent:
  match xs:
    case []:
      @Alias{0, 0}
    case h <> t:
      if i === 0:
        h
      else:
        Chk/nthE(t, i - 1)

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

# the context level of static level s under slot map sm
def Chk/slot(sm: U64[], s: U64) -> U64:
  Chk/nthU(sm, Chk/lenU(sm) - s)

def Chk/ent(ctx: Ent[], d: U64, k: U64) -> Ent:
  Chk/nthE(ctx, d - k)

# follow aliases to the level that owns the slot
def Chk/root(ctx: Ent[], d: U64, k: U64) -> U64:
  match Chk/ent(ctx, d, k):
    case @Alias{lvl, kind}:
      Chk/root(ctx, d, lvl)
    case @Free{nam, ty}:
      k
    case @Refn{val, ty}:
      k
    case @Let{loc, sm}:
      k
    case @Dup{loc, sm}:
      k

def Chk/kindAt(ctx: Ent[], d: U64, k: U64) -> U64:
  match Chk/ent(ctx, d, k):
    case @Alias{lvl, kind}:
      kind
    case @Dup{loc, sm}:
      1
    case @Free{nam, ty}:
      0
    case @Refn{val, ty}:
      0
    case @Let{loc, sm}:
      0

def Chk/envL(ctx: Ent[], d: U64, lk: U64 -> Val, sm: U64[]) -> (any k: U64. Val)[]:
  match sm:
    case []:
      []
    case k <> t:
      (Chk/kindAt(ctx, d, k), lk(k)) <> Chk/envL(ctx, d, lk, t)

# the value of static code under a lookup
def Chk/evalC(ctx: Ent[], d: U64, sm: U64[], c: U64) -> (U64 -> Val) -> Val:
  lambda lk. Prim/inst(c, Chk/envL(ctx, d, lk, sm))

def Chk/valAt(ctx: Ent[], d: U64, k: U64) -> Val:
  match Chk/ent(ctx, d, k):
    case @Free{nam, ty}:
      nam
    case @Refn{val, ty}:
      val(Chk/look(ctx, d))
    case @Let{loc, sm}:
      Chk/evalC(ctx, d, sm, loc, Chk/look(ctx, d))
    case @Alias{lvl, kind}:
      Chk/valAt(ctx, d, lvl)
    case @Dup{loc, sm}:
      Chk/evalC(ctx, d, sm, loc, Chk/look(ctx, d))

def Chk/look(ctx: Ent[], d: U64) -> U64 -> Val:
  lambda k. Chk/valAt(ctx, d, k)

def Chk/now(ctx: Ent[], d: U64, t: (U64 -> Val) -> Val) -> Val:
  t(Chk/look(ctx, d))

# the lookup with level k bound to v (a binder that leaves scope)
def Chk/bind(k: U64, v: (U64 -> Val) -> Val, t: (U64 -> Val) -> Val) -> (U64 -> Val) -> Val:
  lambda lk. t(lambda j. if j === k: v(lk) else: lk(j))

# replace the entry of level k
def Chk/setE(ctx: Ent[], i: U64, e: Ent) -> Ent[]:
  match ctx:
    case []:
      []
    case h <> t:
      if i === 0:
        e <> t
      else:
        h <> Chk/setE(t, i - 1, e)

# refine the generic element at level k to the value v (a matched pattern)
def Chk/refine(ctx: Ent[], d: U64, k: U64, v: (U64 -> Val) -> Val) -> Ent[]:
  if k === 0:
    ctx
  else:
    Chk/refineAt(ctx, d, k, v)

def Chk/refineAt(ctx: Ent[], d: U64, k: U64, v: (U64 -> Val) -> Val) -> Ent[]:
  match Chk/ent(ctx, d, k):
    case @Free{nam, ty}:
      Chk/setE(ctx, d - k, @Refn{v, ty})
    case @Refn{val, ty}:
      ctx
    case @Let{loc, sm}:
      ctx
    case @Alias{lvl, kind}:
      Chk/refine(ctx, d, lvl, v)
    case @Dup{loc, sm}:
      ctx

# the level whose generic element is the name x, if any (0 otherwise)
def Chk/findFree(ctx: Ent[], d: U64, x: Val) -> U64:
  match ctx:
    case []:
      0
    case h <> t:
      match h:
        case @Free{nam, ty}:
          if Prim/conv(nam, x):
            d
          else:
            Chk/findFree(t, d - 1, x)
        case @Refn{val, ty}:
          Chk/findFree(t, d - 1, x)
        case @Let{loc, sm}:
          Chk/findFree(t, d - 1, x)
        case @Alias{lvl, kind}:
          Chk/findFree(t, d - 1, x)
        case @Dup{loc, sm}:
          Chk/findFree(t, d - 1, x)

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

def Chk/convR(a: Val, b: Val) -> U64:
  if Prim/conv(a, b):
    0
  else:
    1

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

def Chk/snd(q: any t: U64. U64) -> U64:
  match q:
    case (t, i):
      i

# ---- enums in the book (Core: Sym inference reads the book's enum types) ------

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

# ---- the checker -----------------------------------------------------------------

def Chk/cst(v: Val) -> (U64 -> Val) -> Val:
  lambda lk. v

def Chk/fld(t: (U64 -> Val) -> Val, i: U64) -> (U64 -> Val) -> Val:
  lambda lk. Prim/vfield(t(lk), i)

# infer: (code, type)
def Chk/infer(es: Val[], ctx: Ent[], d: U64, sm: U64[], c: U64) -> any r: U64. (U64 -> Val) -> Val:
  t = Chk/tag(c)
  e = Chk/ext(c)
  v = Chk/val(c)
  set = Chk/cst(Chk/mk0(&Set))
  if (t === 42) or (t === 43) or (t === 44):
    Chk/typeAt(es, ctx, d, Chk/slot(sm, v))
  else:
    if t === 8:
      ty = Prim/typeof(e)
      if Chk/vtag(ty) === 11:
        (3000, set)
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
                    (2, set)
                  else:
                    (1000 + t, set)

# the type of a context level
def Chk/typeAt(es: Val[], ctx: Ent[], d: U64, k: U64) -> any r: U64. (U64 -> Val) -> Val:
  match Chk/ent(ctx, d, k):
    case @Free{nam, ty}:
      (0, ty)
    case @Refn{val, ty}:
      (0, ty)
    case @Let{loc, sm}:
      Chk/infer(es, ctx, d, sm, loc)
    case @Alias{lvl, kind}:
      Chk/typeAt(es, ctx, d, lvl)
    case @Dup{loc, sm}:
      Chk/infer(es, ctx, d, sm, loc)

def Chk/inferSta(es: Val[], ctx: Ent[], d: U64, sm: U64[], k: U64, v: U64) -> any r: U64. (U64 -> Val) -> Val:
  if k === 0:
    tT = Chk/evalC(ctx, d, sm, v)
    (Chk/check(es, ctx, d, sm, v + 1, tT), tT)
  else:
    if k === 1:
      Chk/inferNext(Chk/check(es, ctx, d, sm, v, Chk/cst(Chk/mk1(&List, Chk/mk1(&Num, Chk/mk0(&Chr))))), Chk/infer(es, ctx, d, sm, v + 1))
    else:
      (2, Chk/cst(Chk/mk0(&Set)))

def Chk/inferNext(r: U64, x: any r: U64. (U64 -> Val) -> Val) -> any r: U64. (U64 -> Val) -> Val:
  match x:
    case (r2, ty):
      (Chk/then(r, r2), ty)

# a dup level: both copies are the dup'd code; the type is read with the
# level bound to that code's value
def Chk/inferDup(es: Val[], ctx: Ent[], d: U64, sm: U64[], v: U64) -> any r: U64. (U64 -> Val) -> Val:
  k = Chk/varLvl(sm, v)
  e = if k === 0: @Dup{v, sm} else: @Alias{Chk/root(ctx, d, k), 1}
  match Chk/infer(es, e <> ctx, d + 1, (d + 1) <> sm, v + 1):
    case (r, ty):
      (r, Chk/bind(d + 1, Chk/evalC(ctx, d, sm, v), ty))

def Chk/inferCtr(es: Val[], ctx: Ent[], d: U64, sm: U64[], ari: U64, e: U64, v: U64) -> any r: U64. (U64 -> Val) -> Val:
  set = Chk/cst(Chk/mk0(&Set))
  if (e === Chk/id(&Set)) or (e === Chk/id(&Nat)) or (e === Chk/id(&Bool)) or (e === Chk/id(&Unit)) or (e === Chk/id(&Empty)) or (e === Chk/id(&Num)) or (e === Chk/id(&Enum)):
    (0, set)
  else:
    if e === Chk/id(&List):
      (Chk/check(es, ctx, d, sm, v, set), set)
    else:
      if (e === Chk/id(&Sig)) or (e === Chk/id(&Pi)):
        a = Chk/evalC(ctx, d, sm, v)
        r1 = Chk/check(es, ctx, d, sm, v, set)
        r2 = Chk/check(es, ctx, d, sm, v + 1, lambda lk. Chk/mk2(&Pi, a(lk), Fun/val(lambda x. Chk/mk0(&Set))))
        (Chk/then(r1, r2), set)
      else:
        if e === Chk/id(&Eql):
          tT = Chk/evalC(ctx, d, sm, v)
          r1 = Chk/check(es, ctx, d, sm, v, set)
          r2 = Chk/check(es, ctx, d, sm, v + 1, tT)
          r3 = Chk/check(es, ctx, d, sm, v + 2, tT)
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
                      Chk/inferSym(Chk/enumOf(es, e))
                    else:
                      (1013 + ari, set)

def Chk/inferSym(es: Val[]) -> any r: U64. (U64 -> Val) -> Val:
  match es:
    case []:
      (2, Chk/cst(Chk/mk0(&Set)))
    case e <> rest:
      (0, Chk/cst(e))

def Chk/inferSuc(x: any r: U64. (U64 -> Val) -> Val, ctx: Ent[], d: U64) -> any r: U64. (U64 -> Val) -> Val:
  match x:
    case (r, ty):
      if r === 0:
        n = Chk/now(ctx, d, ty)
        if Chk/is(n, &Nat):
          (0, Chk/cst(Chk/mk0(&Nat)))
        else:
          if Chk/is(n, &Eql) and Chk/is(Prim/vfield(n, 0), &Nat):
            (0, lambda lk. Chk/mk3(&Eql, Chk/mk0(&Nat), Chk/mk1(&Suc, Prim/vfield(ty(lk), 1)), Chk/mk1(&Suc, Prim/vfield(ty(lk), 2))))
          else:
            (1, ty)
      else:
        (r, ty)

def Chk/inferPair(a: any r: U64. (U64 -> Val) -> Val, b: any r: U64. (U64 -> Val) -> Val) -> any r: U64. (U64 -> Val) -> Val:
  match a:
    case (ra, ta):
      match b:
        case (rb, tb):
          (Chk/then(ra, rb), lambda lk. Chk/mk2(&Sig, ta(lk), Fun/val(lambda x. tb(lk))))

# binary operators (Core.Check.inferOp2Type)
def Chk/inferOp(es: Val[], ctx: Ent[], d: U64, sm: U64[], op: U64, v: U64) -> any r: U64. (U64 -> Val) -> Val:
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

def Chk/opType(op: U64, a: Val, b: Val) -> any r: U64. (U64 -> Val) -> Val:
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

# an application spine: a λ head substitutes its argument (Core infer App-Lam);
# any other head is inferred and applied argument by argument
def Chk/inferApp(es: Val[], ctx: Ent[], d: U64, sm: U64[], h: U64, xs: U64[]) -> any r: U64. (U64 -> Val) -> Val:
  ht = Chk/tag(h)
  if ht === 2:
    match xs:
      case []:
        (2, Chk/cst(Chk/mk0(&Set)))
      case x <> rest:
        match rest:
          case []:
            match Chk/infer(es, @Let{x, sm} <> ctx, d + 1, (d + 1) <> sm, Chk/val(h)):
              case (r, ty):
                (r, Chk/bind(d + 1, Chk/evalC(ctx, d, sm, x), ty))
          case y <> more:
            (2, Chk/cst(Chk/mk0(&Set)))
  else:
    if (ht === 12) or (ht === 31) or (ht === 11):
      (2, Chk/cst(Chk/mk0(&Set)))
    else:
      match Chk/infer(es, ctx, d, sm, h):
        case (r, ty):
          if r === 0:
            Chk/inferArgs(es, ctx, d, sm, ty, xs)
          else:
            (r, ty)

def Chk/inferArgs(es: Val[], ctx: Ent[], d: U64, sm: U64[], ty: (U64 -> Val) -> Val, xs: U64[]) -> any r: U64. (U64 -> Val) -> Val:
  match xs:
    case []:
      (0, ty)
    case x <> rest:
      if Chk/is(Chk/now(ctx, d, ty), &Pi):
        r = Chk/check(es, ctx, d, sm, x, Chk/fld(ty, 0))
        xv = Chk/evalC(ctx, d, sm, x)
        if r === 0:
          Chk/inferArgs(es, ctx, d, sm, lambda lk. Prim/vapp(Prim/vfield(ty(lk), 1), xv(lk)), rest)
        else:
          (r, ty)
      else:
        (1, ty)

# check: code
def Chk/check(es: Val[], ctx: Ent[], d: U64, sm: U64[], c: U64, goal: (U64 -> Val) -> Val) -> U64:
  t = Chk/tag(c)
  e = Chk/ext(c)
  v = Chk/val(c)
  if t === 2:
    g = Chk/now(ctx, d, goal)
    if Chk/is(g, &Pi):
      n = Prim/fresh(())
      Chk/check(es, @Free{n, Chk/fld(goal, 0)} <> ctx, d + 1, (d + 1) <> sm, v, lambda lk. Prim/vapp(Prim/vfield(goal(lk), 1), lk(d + 1)))
    else:
      2
  else:
    if t === 46:
      Chk/checkSta(es, ctx, d, sm, e, v, goal)
    else:
      if t === 6:
        k = Chk/varLvl(sm, v)
        en = if k === 0: @Dup{v, sm} else: @Alias{Chk/root(ctx, d, k), 1}
        Chk/check(es, en <> ctx, d + 1, (d + 1) <> sm, v + 1, goal)
      else:
        if t === 11:
          0
        else:
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
                Chk/checkApp(es, ctx, d, sm, c, Chk/head(c), Chk/args(c, []), goal)
              else:
                if (t === 12) or (t === 31):
                  1000 + t
                else:
                  Chk/verify(es, ctx, d, sm, c, goal)

def Chk/verify(es: Val[], ctx: Ent[], d: U64, sm: U64[], c: U64, goal: (U64 -> Val) -> Val) -> U64:
  match Chk/infer(es, ctx, d, sm, c):
    case (r, ty):
      if r === 0:
        Chk/convR(Chk/now(ctx, d, ty), Chk/now(ctx, d, goal))
      else:
        r

def Chk/checkSta(es: Val[], ctx: Ent[], d: U64, sm: U64[], k: U64, v: U64, goal: (U64 -> Val) -> Val) -> U64:
  if k === 1:
    Chk/then(Chk/check(es, ctx, d, sm, v, Chk/cst(Chk/mk1(&List, Chk/mk1(&Num, Chk/mk0(&Chr))))), Chk/check(es, ctx, d, sm, v + 1, goal))
  else:
    if k === 0:
      tT = Chk/evalC(ctx, d, sm, v)
      Chk/then(Chk/check(es, ctx, d, sm, v + 1, tT), Chk/convR(Chk/now(ctx, d, tT), Chk/now(ctx, d, goal)))
    else:
      2

def Chk/checkCtr(es: Val[], ctx: Ent[], d: U64, sm: U64[], c: U64, ari: U64, e: U64, v: U64, goal: (U64 -> Val) -> Val) -> U64:
  g = Chk/now(ctx, d, goal)
  if (e === Chk/id(&Zer)) and Chk/is(g, &Nat):
    0
  else:
    if (e === Chk/id(&Suc)) and Chk/is(g, &Nat):
      Chk/check(es, ctx, d, sm, v, goal)
    else:
      if (e === Chk/id(&Suc)) and Chk/is(g, &Eql) and Chk/is(Prim/vfield(g, 1), &Suc) and Chk/is(Prim/vfield(g, 2), &Suc):
        Chk/check(es, ctx, d, sm, v, lambda lk. Chk/mk3(&Eql, Prim/vfield(goal(lk), 0), Prim/vfield(Prim/vfield(goal(lk), 1), 0), Prim/vfield(Prim/vfield(goal(lk), 2), 0)))
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
                a = Chk/evalC(ctx, d, sm, v)
                Chk/then(Chk/check(es, ctx, d, sm, v, Chk/fld(goal, 0)), Chk/check(es, ctx, d, sm, v + 1, lambda lk. Prim/vapp(Prim/vfield(goal(lk), 1), a(lk))))
              else:
                if (e === Chk/id(&Refl)) and Chk/is(g, &Eql):
                  Chk/convR(Prim/vfield(g, 1), Prim/vfield(g, 2))
                else:
                  if (ari === 0) and Chk/is(g, &Enum):
                    if Chk/hasSym(Prim/vfield(g, 0), e):
                      0
                    else:
                      1
                  else:
                    Chk/verify(es, ctx, d, sm, c, goal)

# (f x ..) against a goal: a match (Core's eliminators, lowered with their
# environment passed after the scrutinee), a λ head (substitution), or
# inference
def Chk/checkApp(es: Val[], ctx: Ent[], d: U64, sm: U64[], c: U64, h: U64, xs: U64[], goal: (U64 -> Val) -> Val) -> U64:
  ht = Chk/tag(h)
  if (ht === 12) or (ht === 31) or (ht === 11):
    match xs:
      case []:
        2
      case x <> env:
        Chk/checkMatch(es, ctx, d, sm, h, x, env, goal)
  else:
    if ht === 2:
      Chk/checkLamApp(es, ctx, d, sm, h, xs, goal)
    else:
      Chk/verify(es, ctx, d, sm, c, goal)

# (λx. b)(a1)..(an): a1 is substituted; each later argument is a generic
# element of its inferred type (Core: check f against ∀(typeof x). goal)
def Chk/checkLamApp(es: Val[], ctx: Ent[], d: U64, sm: U64[], h: U64, xs: U64[], goal: (U64 -> Val) -> Val) -> U64:
  match xs:
    case []:
      Chk/check(es, ctx, d, sm, h, goal)
    case x <> rest:
      Chk/lamArgs(es, @Let{x, sm} <> ctx, d + 1, (d + 1) <> sm, Chk/val(h), rest, sm, goal)

def Chk/lamArgs(es: Val[], ctx: Ent[], d: U64, sm: U64[], c: U64, xs: U64[], sm0: U64[], goal: (U64 -> Val) -> Val) -> U64:
  match xs:
    case []:
      Chk/check(es, ctx, d, sm, c, goal)
    case x <> rest:
      if Chk/tag(c) === 2:
        match Chk/infer(es, ctx, d, sm0, x):
          case (r, ty):
            if r === 0:
              Chk/lamArgs(es, @Free{Prim/fresh(()), ty} <> ctx, d + 1, (d + 1) <> sm, Chk/val(c), rest, sm0, goal)
            else:
              r
      else:
        4001

# the arity of a constructor arm
def Chk/arity(e: U64) -> U64:
  if (e === Chk/id(&Suc)):
    1
  else:
    if (e === Chk/id(&Con)) or (e === Chk/id(&Pair)):
      2
    else:
      0

def Chk/checkMatch(es: Val[], ctx: Ent[], d: U64, sm: U64[], h: U64, x: U64, env: U64[], goal: (U64 -> Val) -> Val) -> U64:
  match Chk/infer(es, ctx, d, sm, x):
    case (r, xT):
      if r !== 0:
        r
      else:
        xt = Chk/now(ctx, d, xT)
        k = Chk/varLvl(sm, x)
        kr = if k === 0: 0 else: Chk/root(ctx, d, k)
        if Chk/tag(h) === 11:
          if Chk/is(xt, &Empty):
            0
          else:
            if Chk/is(xt, &Eql):
              if Prim/conv(Prim/vfield(xt, 1), Prim/vfield(xt, 2)):
                1
              else:
                0
            else:
              1
        else:
          Chk/arms(es, ctx, d, sm, h, xT, kr, Chk/evalC(ctx, d, sm, x), env, goal, [])

# refining a scrutinee that is not a variable: its occurrences in the goal
# are rewritten to the pattern (Core: Rwt x pat goal)
def Chk/refG(kr: U64, xv: (U64 -> Val) -> Val, pat: (U64 -> Val) -> Val, goal: (U64 -> Val) -> Val) -> (U64 -> Val) -> Val:
  if kr === 0:
    lambda lk. Prim/rewrite(xv(lk), pat(lk), goal(lk))
  else:
    goal

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
def Chk/arms(es: Val[], ctx: Ent[], d: U64, sm: U64[], h: U64, xT: (U64 -> Val) -> Val, kr: U64, xv: (U64 -> Val) -> Val, env: U64[], goal: (U64 -> Val) -> Val, cov: U64[]) -> U64:
  t = Chk/tag(h)
  e = Chk/ext(h)
  v = Chk/val(h)
  xt = Chk/now(ctx, d, xT)
  if t === 12:
    Chk/then(Chk/arm(es, ctx, d, sm, v, e, xT, kr, xv, env, goal), Chk/arms(es, ctx, d, sm, v + 1, xT, kr, xv, env, goal, e <> cov))
  else:
    if t === 31:
      if Chk/is(xt, &Bool) and (e === 0):
        Chk/then(Chk/armFields(es, Chk/refine(ctx, d, kr, Chk/cst(Num/val(0))), d, sm, v, [], env, Chk/refG(kr, xv, Chk/cst(Num/val(0)), goal)), Chk/arms(es, ctx, d, sm, v + 1, xT, kr, xv, env, goal, cov))
      else:
        4002
    else:
      if t === 30:
        0
      else:
        if t === 2:
          if Chk/is(xt, &Bool):
            n = Prim/fresh(())
            Chk/armFields(es, Chk/refine(@Refn{Chk/cst(Num/val(1)), Chk/cst(Chk/mk0(&Bool))} <> ctx, d + 1, kr, Chk/cst(Num/val(1))), d + 1, (d + 1) <> sm, v, [], env, Chk/refG(kr, xv, Chk/cst(Num/val(1)), goal))
          else:
            if Chk/is(xt, &Enum):
              # Core: a default is read only when the arms do not cover the
              # enum, and the absent default (λ_. ()) is an incomplete match
              if Chk/covered(Prim/vfield(xt, 0), cov):
                0
              else:
                if Chk/absentDefault(v, Chk/lenU(env)):
                  1
                else:
                  n = Prim/fresh(())
                  ctx2 = @Free{n, xT} <> ctx
                  Chk/armFields(es, Chk/refine(ctx2, d + 1, kr, lambda lk. lk(d + 1)), d + 1, (d + 1) <> sm, v, [], env, Chk/refG(kr, xv, lambda lk. lk(d + 1), goal))
            else:
              1
        else:
          4003

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
def Chk/arm(es: Val[], ctx: Ent[], d: U64, sm: U64[], a: U64, e: U64, xT: (U64 -> Val) -> Val, kr: U64, xv: (U64 -> Val) -> Val, env: U64[], goal: (U64 -> Val) -> Val) -> U64:
  xt = Chk/now(ctx, d, xT)
  if (e === Chk/id(&Zer)) and Chk/is(xt, &Nat):
    Chk/armFields(es, Chk/refine(ctx, d, kr, Chk/cst(Chk/mk0(&Zer))), d, sm, a, [], env, Chk/refG(kr, xv, Chk/cst(Chk/mk0(&Zer)), goal))
  else:
    if (e === Chk/id(&Suc)) and Chk/is(xt, &Nat):
      Chk/arm1(es, ctx, d, sm, a, Chk/cst(Chk/mk0(&Nat)), kr, xv, lambda lk. Chk/mk1(&Suc, lk(d + 1)), env, goal)
    else:
      if (e === Chk/id(&Nil)) and Chk/is(xt, &List):
        Chk/armFields(es, Chk/refine(ctx, d, kr, Chk/cst(Chk/mk0(&Nil))), d, sm, a, [], env, Chk/refG(kr, xv, Chk/cst(Chk/mk0(&Nil)), goal))
      else:
        if (e === Chk/id(&Con)) and Chk/is(xt, &List):
          Chk/arm2(es, ctx, d, sm, a, Chk/fld(xT, 0), lambda lk. xT(lk), kr, xv, &Con, env, goal)
        else:
          if (e === Chk/id(&One)) and Chk/is(xt, &Unit):
            Chk/armFields(es, Chk/refine(ctx, d, kr, Chk/cst(Chk/mk0(&One))), d, sm, a, [], env, Chk/refG(kr, xv, Chk/cst(Chk/mk0(&One)), goal))
          else:
            if (e === Chk/id(&Pair)) and Chk/is(xt, &Sig):
              Chk/arm2(es, ctx, d, sm, a, Chk/fld(xT, 0), lambda lk. Prim/vapp(Prim/vfield(xT(lk), 1), lk(d + 1)), kr, xv, &Pair, env, goal)
            else:
              if (e === Chk/id(&Refl)) and Chk/is(xt, &Eql):
                c1 = Chk/refine(ctx, d, kr, Chk/cst(Chk/mk0(&Refl)))
                g1 = Chk/refG(kr, xv, Chk/cst(Chk/mk0(&Refl)), goal)
                ka = Chk/findFree(c1, d, Prim/vfield(xt, 1))
                c2 = if ka === 0: c1 else: Chk/refine(c1, d, ka, Chk/fld(xT, 2))
                # J: the endpoint a becomes b (Core: Rwt a b goal)
                g2 = Chk/refG(ka, Chk/fld(xT, 1), Chk/fld(xT, 2), g1)
                Chk/armFields(es, c2, d, sm, a, [], env, g2)
              else:
                if Chk/is(xt, &Enum) and Chk/hasSym(Prim/vfield(xt, 0), e):
                  Chk/armFields(es, Chk/refine(ctx, d, kr, Chk/cst(Prim/vctr(e, []))), d, sm, a, [], env, Chk/refG(kr, xv, Chk/cst(Prim/vctr(e, [])), goal))
                else:
                  1

def Chk/arm1(es: Val[], ctx: Ent[], d: U64, sm: U64[], a: U64, fT: (U64 -> Val) -> Val, kr: U64, xv: (U64 -> Val) -> Val, pat: (U64 -> Val) -> Val, env: U64[], goal: (U64 -> Val) -> Val) -> U64:
  if Chk/tag(a) === 2:
    ctx2 = @Free{Prim/fresh(()), fT} <> ctx
    Chk/armFields(es, Chk/refine(ctx2, d + 1, kr, pat), d + 1, (d + 1) <> sm, Chk/val(a), [], env, Chk/refG(kr, xv, pat, goal))
  else:
    4004

def Chk/arm2(es: Val[], ctx: Ent[], d: U64, sm: U64[], a: U64, fT: (U64 -> Val) -> Val, gT: (U64 -> Val) -> Val, kr: U64, xv: (U64 -> Val) -> Val, t: Tag(), env: U64[], goal: (U64 -> Val) -> Val) -> U64:
  if (Chk/tag(a) === 2) and (Chk/tag(Chk/val(a)) === 2):
    ctx2 = @Free{Prim/fresh(()), gT} <> @Free{Prim/fresh(()), fT} <> ctx
    pat = lambda lk. Chk/mk2(t, lk(d + 1), lk(d + 2))
    Chk/armFields(es, Chk/refine(ctx2, d + 2, kr, pat), d + 2, (d + 2) <> (d + 1) <> sm, Chk/val(Chk/val(a)), [], env, Chk/refG(kr, xv, pat, goal))
  else:
    4005

# the environment binders of an arm alias the variables passed after the
# scrutinee; then the arm body is checked against the (refined) goal
def Chk/armFields(es: Val[], ctx: Ent[], d: U64, sm: U64[], a: U64, u: U64[], env: U64[], goal: (U64 -> Val) -> Val) -> U64:
  match env:
    case []:
      Chk/check(es, ctx, d, sm, a, goal)
    case x <> rest:
      if Chk/tag(a) === 2:
        k = Chk/varLvl(sm, x)
        en = if k === 0: @Let{x, sm} else: @Alias{Chk/root(ctx, d, k), 0}
        Chk/armFields(es, en <> ctx, d + 1, (d + 1) <> sm, Chk/val(a), u, rest, goal)
      else:
        4006

# ---- the book -------------------------------------------------------------------

# every definition: its type's code against Set, then its code against the
# type cell (Core.CLI.checkDefinitions); (book id, result) in order
def Chk/all(defs: (any c: U64. any t: U64. U64)[]) -> (any i: U64. U64)[]:
  es = Chk/enumsOf(defs)
  Chk/each(es, defs)

def Chk/each(es: Val[], defs: (any c: U64. any t: U64. U64)[]) -> (any i: U64. U64)[]:
  match defs:
    case []:
      []
    case p <> rest:
      match p:
        case (c, q):
          match q:
            case (tc, i):
              set = Chk/cst(Chk/mk0(&Set))
              r = Chk/then(Chk/check(es, [], 0, [], tc, set), Chk/check(es, [], 0, [], c, Chk/cst(Prim/typeof(i))))
              (i, r) <> Chk/each(es, rest)
