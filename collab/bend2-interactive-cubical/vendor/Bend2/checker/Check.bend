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
# context: refining a matched variable replaces its entry, and every goal and
# type that mentions it sees the refinement (normalisation by evaluation).
#
# Goals, types and refinements are FIRST-ORDER expressions (G) read by one
# evaluator, never closures of the checker: a closure duplicated and applied
# in nested ways shares its dup labels between the two applications (label
# capture within one instance), while data duplicates constructor by
# constructor and every evaluation is a fresh unfolding with fresh names.
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

# ---- expressions: cells as functions of the context, as data ------------------

type G:
  case @V:
    v: Val
  case @L:
    k: U64
  case @C:
    c: U64
    sm: U64[]
  case @F:
    g: G
    i: U64
  case @A:
    f: G
    x: G
  case @K:
    t: U64
    fs: G[]
  case @Cst:
    g: G
  case @Rw:
    o: G
    n: G
    t: G
  case @S:
    k: U64
    v: G
    t: G

# ---- context ------------------------------------------------------------------

type Ent:
  case @Free:
    nam: Val
    ty: G
  case @Refn:
    val: G
    ty: G
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

# ---- the evaluator ---------------------------------------------------------------

def Chk/eval(ctx: Ent[], d: U64, ov: (any k: U64. Val)[], g: G) -> Val:
  match g:
    case @V{v}:
      v
    case @L{k}:
      Chk/lvlVal(ctx, d, ov, k)
    case @C{c, sm}:
      Prim/inst(c, Chk/envOf(ctx, d, ov, sm))
    case @F{h, i}:
      Prim/vfield(Chk/eval(ctx, d, ov, h), i)
    case @A{f, x}:
      Prim/vapp(Chk/eval(ctx, d, ov, f), Chk/eval(ctx, d, ov, x))
    case @K{t, fs}:
      Prim/vctr(t, Chk/evalList(ctx, d, ov, fs))
    case @Cst{h}:
      v = Chk/eval(ctx, d, ov, h)
      Fun/val(lambda x. v)
    case @Rw{o, n, t}:
      Prim/rewrite(Chk/eval(ctx, d, ov, o), Chk/eval(ctx, d, ov, n), Chk/eval(ctx, d, ov, t))
    case @S{k, v, t}:
      Chk/eval(ctx, d, (k, Chk/eval(ctx, d, ov, v)) <> ov, t)

def Chk/evalList(ctx: Ent[], d: U64, ov: (any k: U64. Val)[], gs: G[]) -> Val[]:
  match gs:
    case []:
      []
    case g <> rest:
      Chk/eval(ctx, d, ov, g) <> Chk/evalList(ctx, d, ov, rest)

def Chk/lvlVal(ctx: Ent[], d: U64, ov: (any k: U64. Val)[], k: U64) -> Val:
  match ov:
    case []:
      Chk/valAt(ctx, d, k)
    case p <> rest:
      match p:
        case (j, v):
          if j === k:
            v
          else:
            Chk/lvlVal(ctx, d, rest, k)

def Chk/valAt(ctx: Ent[], d: U64, k: U64) -> Val:
  match Chk/ent(ctx, d, k):
    case @Free{nam, ty}:
      nam
    case @Refn{val, ty}:
      Chk/eval(ctx, d, [], val)
    case @Let{loc, sm}:
      Prim/inst(loc, Chk/envOf(ctx, d, [], sm))
    case @Alias{lvl, kind}:
      Chk/valAt(ctx, d, lvl)
    case @Dup{loc, sm}:
      Prim/inst(loc, Chk/envOf(ctx, d, [], sm))

def Chk/envOf(ctx: Ent[], d: U64, ov: (any k: U64. Val)[], sm: U64[]) -> (any k: U64. Val)[]:
  match sm:
    case []:
      []
    case k <> t:
      (Chk/kindAt(ctx, d, k), Chk/lvlVal(ctx, d, ov, k)) <> Chk/envOf(ctx, d, ov, t)

def Chk/now(ctx: Ent[], d: U64, g: G) -> Val:
  Chk/eval(ctx, d, [], g)

def Chk/set() -> G:
  @V{Chk/mk0(&Set)}

# replace the entry of level k (at list index i)
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
def Chk/refine(ctx: Ent[], d: U64, k: U64, v: G) -> Ent[]:
  if k === 0:
    ctx
  else:
    Chk/refineAt(ctx, d, k, v)

def Chk/refineAt(ctx: Ent[], d: U64, k: U64, v: G) -> Ent[]:
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

# the entry of a dup level (a DUP node's value at v): both copies read the
# same slot, an alias when the dup'd code is a variable
def Chk/dupEnt(ctx: Ent[], d: U64, sm: U64[], v: U64) -> Ent:
  k = Chk/varLvl(sm, v)
  if k === 0:
    @Dup{v, sm}
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

def Chk/infer(es: Val[], ctx: Ent[], d: U64, sm: U64[], c: U64) -> any r: U64. G:
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
        (0, @V{ty})
    else:
      if t === 46:
        Chk/inferSta(es, ctx, d, sm, e, v)
      else:
        if t === 30:
          (0, @V{Chk/u64T()})
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
def Chk/typeAt(es: Val[], ctx: Ent[], d: U64, k: U64) -> any r: U64. G:
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

def Chk/inferSta(es: Val[], ctx: Ent[], d: U64, sm: U64[], k: U64, v: U64) -> any r: U64. G:
  if k === 0:
    (Chk/check(es, ctx, d, sm, v + 1, @C{v, sm}), @C{v, sm})
  else:
    if k === 1:
      Chk/inferNext(Chk/check(es, ctx, d, sm, v, @V{Chk/mk1(&List, Chk/mk1(&Num, Chk/mk0(&Chr)))}), Chk/infer(es, ctx, d, sm, v + 1))
    else:
      (2, Chk/set())

def Chk/inferNext(r: U64, x: any r: U64. G) -> any r: U64. G:
  match x:
    case (r2, ty):
      (Chk/then(r, r2), ty)

# a dup level: both copies are the dup'd code; the type is read with the
# level bound to that code's value
def Chk/inferDup(es: Val[], ctx: Ent[], d: U64, sm: U64[], v: U64) -> any r: U64. G:
  match Chk/infer(es, Chk/dupEnt(ctx, d, sm, v) <> ctx, d + 1, (d + 1) <> sm, v + 1):
    case (r, ty):
      (r, @S{d + 1, @C{v, sm}, ty})

def Chk/inferCtr(es: Val[], ctx: Ent[], d: U64, sm: U64[], ari: U64, e: U64, v: U64) -> any r: U64. G:
  set = Chk/set()
  if (e === Chk/id(&Set)) or (e === Chk/id(&Nat)) or (e === Chk/id(&Bool)) or (e === Chk/id(&Unit)) or (e === Chk/id(&Empty)) or (e === Chk/id(&Num)) or (e === Chk/id(&Enum)):
    (0, set)
  else:
    if e === Chk/id(&List):
      (Chk/check(es, ctx, d, sm, v, set), set)
    else:
      if (e === Chk/id(&Sig)) or (e === Chk/id(&Pi)):
        r1 = Chk/check(es, ctx, d, sm, v, set)
        r2 = Chk/check(es, ctx, d, sm, v + 1, @K{Chk/id(&Pi), [@C{v, sm}, @Cst{Chk/set()}]})
        (Chk/then(r1, r2), set)
      else:
        if e === Chk/id(&Eql):
          r1 = Chk/check(es, ctx, d, sm, v, set)
          r2 = Chk/check(es, ctx, d, sm, v + 1, @C{v, sm})
          r3 = Chk/check(es, ctx, d, sm, v + 2, @C{v, sm})
          (Chk/then(r1, Chk/then(r2, r3)), set)
        else:
          if e === Chk/id(&Zer):
            (0, @V{Chk/mk0(&Nat)})
          else:
            if e === Chk/id(&Suc):
              Chk/inferSuc(Chk/infer(es, ctx, d, sm, v), ctx, d)
            else:
              if e === Chk/id(&One):
                (0, @V{Chk/mk0(&Unit)})
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

def Chk/inferSym(es: Val[]) -> any r: U64. G:
  match es:
    case []:
      (2, Chk/set())
    case e <> rest:
      (0, @V{e})

def Chk/inferSuc(x: any r: U64. G, ctx: Ent[], d: U64) -> any r: U64. G:
  match x:
    case (r, ty):
      if r === 0:
        n = Chk/now(ctx, d, ty)
        if Chk/is(n, &Nat):
          (0, @V{Chk/mk0(&Nat)})
        else:
          if Chk/is(n, &Eql) and Chk/is(Prim/vfield(n, 0), &Nat):
            (0, @K{Chk/id(&Eql), [@V{Chk/mk0(&Nat)}, @K{Chk/id(&Suc), [@F{ty, 1}]}, @K{Chk/id(&Suc), [@F{ty, 2}]}]})
          else:
            (1, ty)
      else:
        (r, ty)

def Chk/inferPair(a: any r: U64. G, b: any r: U64. G) -> any r: U64. G:
  match a:
    case (ra, ta):
      match b:
        case (rb, tb):
          (Chk/then(ra, rb), @K{Chk/id(&Sig), [ta, @Cst{tb}]})

# binary operators (Core.Check.inferOp2Type)
def Chk/inferOp(es: Val[], ctx: Ent[], d: U64, sm: U64[], op: U64, v: U64) -> any r: U64. G:
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

def Chk/opType(op: U64, a: Val, b: Val) -> any r: U64. G:
  ka = Chk/numKind(a)
  kb = Chk/numKind(b)
  bit = @V{Chk/mk0(&Bool)}
  same = (ka !== 0) and (ka === kb)
  bools = Chk/is(a, &Bool) and Chk/is(b, &Bool)
  if op <= 4:
    if same:
      (0, @V{Chk/mk1(&Num, Prim/vfield(a, 0))})
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
            (0, @V{Chk/u64T()})
          else:
            (1, bit)
      else:
        if same and (ka === Chk/id(&U64)):
          (0, @V{Chk/u64T()})
        else:
          (1, bit)

# an application spine: a λ head substitutes its argument (Core infer App-Lam);
# any other head is inferred and applied argument by argument
def Chk/inferApp(es: Val[], ctx: Ent[], d: U64, sm: U64[], h: U64, xs: U64[]) -> any r: U64. G:
  ht = Chk/tag(h)
  if ht === 2:
    match xs:
      case []:
        (2, Chk/set())
      case x <> rest:
        match rest:
          case []:
            match Chk/infer(es, @Let{x, sm} <> ctx, d + 1, (d + 1) <> sm, Chk/val(h)):
              case (r, ty):
                (r, @S{d + 1, @C{x, sm}, ty})
          case y <> more:
            (2, Chk/set())
  else:
    if (ht === 12) or (ht === 31) or (ht === 11):
      (2, Chk/set())
    else:
      match Chk/infer(es, ctx, d, sm, h):
        case (r, ty):
          if r === 0:
            Chk/inferArgs(es, ctx, d, sm, ty, xs)
          else:
            (r, ty)

def Chk/inferArgs(es: Val[], ctx: Ent[], d: U64, sm: U64[], ty: G, xs: U64[]) -> any r: U64. G:
  match xs:
    case []:
      (0, ty)
    case x <> rest:
      if Chk/is(Chk/now(ctx, d, ty), &Pi):
        r = Chk/check(es, ctx, d, sm, x, @F{ty, 0})
        if r === 0:
          Chk/inferArgs(es, ctx, d, sm, @A{@F{ty, 1}, @C{x, sm}}, rest)
        else:
          (r, ty)
      else:
        (1, ty)

# ---- checking --------------------------------------------------------------------

def Chk/check(es: Val[], ctx: Ent[], d: U64, sm: U64[], c: U64, goal: G) -> U64:
  t = Chk/tag(c)
  e = Chk/ext(c)
  v = Chk/val(c)
  if t === 2:
    if Chk/is(Chk/now(ctx, d, goal), &Pi):
      Chk/check(es, @Free{Prim/fresh(()), @F{goal, 0}} <> ctx, d + 1, (d + 1) <> sm, v, @A{@F{goal, 1}, @L{d + 1}})
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
def Chk/checkNode(es: Val[], ctx: Ent[], d: U64, sm: U64[], c: U64, t: U64, e: U64, v: U64, goal: G) -> U64:
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
          if (t === 42) or (t === 43) or (t === 44):
            Chk/checkVar(es, ctx, d, sm, c, Chk/slot(sm, v), goal)
          else:
            Chk/verify(es, ctx, d, sm, c, goal)

# a variable bound to code (a let, a dup of code) is that code: it is
# checked where it is used (Core substitutes the let)
def Chk/checkVar(es: Val[], ctx: Ent[], d: U64, sm: U64[], c: U64, k: U64, goal: G) -> U64:
  match Chk/ent(ctx, d, k):
    case @Let{loc, sm2}:
      Chk/check(es, ctx, d, sm2, loc, goal)
    case @Dup{loc, sm2}:
      Chk/check(es, ctx, d, sm2, loc, goal)
    case @Alias{lvl, kind}:
      Chk/checkVar(es, ctx, d, sm, c, lvl, goal)
    case @Free{nam, ty}:
      Chk/verify(es, ctx, d, sm, c, goal)
    case @Refn{val, ty}:
      Chk/verify(es, ctx, d, sm, c, goal)

def Chk/verify(es: Val[], ctx: Ent[], d: U64, sm: U64[], c: U64, goal: G) -> U64:
  match Chk/infer(es, ctx, d, sm, c):
    case (r, ty):
      if r === 0:
        Chk/convR(Chk/now(ctx, d, ty), Chk/now(ctx, d, goal))
      else:
        r

def Chk/checkSta(es: Val[], ctx: Ent[], d: U64, sm: U64[], k: U64, v: U64, goal: G) -> U64:
  if k === 1:
    Chk/then(Chk/check(es, ctx, d, sm, v, @V{Chk/mk1(&List, Chk/mk1(&Num, Chk/mk0(&Chr)))}), Chk/check(es, ctx, d, sm, v + 1, goal))
  else:
    if k === 0:
      Chk/then(Chk/check(es, ctx, d, sm, v + 1, @C{v, sm}), Chk/convR(Chk/now(ctx, d, @C{v, sm}), Chk/now(ctx, d, goal)))
    else:
      2

def Chk/checkCtr(es: Val[], ctx: Ent[], d: U64, sm: U64[], c: U64, ari: U64, e: U64, v: U64, goal: G) -> U64:
  g = Chk/now(ctx, d, goal)
  if (e === Chk/id(&Zer)) and Chk/is(g, &Nat):
    0
  else:
    if (e === Chk/id(&Suc)) and Chk/is(g, &Nat):
      Chk/check(es, ctx, d, sm, v, goal)
    else:
      if (e === Chk/id(&Suc)) and Chk/is(g, &Eql) and Chk/is(Prim/vfield(g, 1), &Suc) and Chk/is(Prim/vfield(g, 2), &Suc):
        Chk/check(es, ctx, d, sm, v, @K{Chk/id(&Eql), [@F{goal, 0}, @F{@F{goal, 1}, 0}, @F{@F{goal, 2}, 0}]})
      else:
        if e === Chk/id(&Nil):
          if Chk/is(g, &List):
            0
          else:
            1
        else:
          if (e === Chk/id(&Con)) and Chk/is(g, &List):
            Chk/then(Chk/check(es, ctx, d, sm, v, @F{goal, 0}), Chk/check(es, ctx, d, sm, v + 1, goal))
          else:
            if (e === Chk/id(&One)) and Chk/is(g, &Unit):
              0
            else:
              if (e === Chk/id(&Pair)) and Chk/is(g, &Sig):
                Chk/then(Chk/check(es, ctx, d, sm, v, @F{goal, 0}), Chk/check(es, ctx, d, sm, v + 1, @A{@F{goal, 1}, @C{v, sm}}))
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
def Chk/checkApp(es: Val[], ctx: Ent[], d: U64, sm: U64[], c: U64, h: U64, xs: U64[], goal: G) -> U64:
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
      # a primitive of the runtime (an extern body): its declared type is
      # its specification (Core: Pri EXTERN checks)
      if ht === 45:
        0
      else:
        Chk/verify(es, ctx, d, sm, c, goal)

# (λx. b)(a1)..(an): a1 is substituted; each later argument is a generic
# element of its inferred type (Core: check f against ∀(typeof x). goal)
def Chk/checkLamApp(es: Val[], ctx: Ent[], d: U64, sm: U64[], h: U64, xs: U64[], goal: G) -> U64:
  match xs:
    case []:
      Chk/check(es, ctx, d, sm, h, goal)
    case x <> rest:
      Chk/lamArgs(es, @Let{x, sm} <> ctx, d + 1, (d + 1) <> sm, Chk/val(h), rest, sm, goal)

def Chk/lamArgs(es: Val[], ctx: Ent[], d: U64, sm: U64[], c: U64, xs: U64[], sm0: U64[], goal: G) -> U64:
  match xs:
    case []:
      Chk/check(es, ctx, d, sm, c, goal)
    case x <> rest:
      if Chk/tag(c) === 6:
        Chk/lamArgs(es, Chk/dupEnt(ctx, d, sm, Chk/val(c)) <> ctx, d + 1, (d + 1) <> sm, Chk/val(c) + 1, x <> rest, sm0, goal)
      else:
        if Chk/tag(c) === 2:
          match Chk/infer(es, ctx, d, sm0, x):
            case (r, ty):
              if r === 0:
                Chk/lamArgs(es, @Free{Prim/fresh(()), ty} <> ctx, d + 1, (d + 1) <> sm, Chk/val(c), rest, sm0, goal)
              else:
                r
        else:
          4001

# ---- matches ---------------------------------------------------------------------

def Chk/checkMatch(es: Val[], ctx: Ent[], d: U64, sm: U64[], h: U64, x: U64, env: U64[], goal: G) -> U64:
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
          Chk/arms(es, ctx, d, sm, h, xT, kr, @C{x, sm}, env, goal, [])

# refining a scrutinee that is not a variable: its occurrences in the goal
# are rewritten to the pattern (Core: Rwt x pat goal)
def Chk/refG(kr: U64, xv: G, pat: G, goal: G) -> G:
  if kr === 0:
    @Rw{xv, pat, goal}
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
def Chk/arms(es: Val[], ctx: Ent[], d: U64, sm: U64[], h: U64, xT: G, kr: U64, xv: G, env: U64[], goal: G, cov: U64[]) -> U64:
  t = Chk/tag(h)
  e = Chk/ext(h)
  v = Chk/val(h)
  xt = Chk/now(ctx, d, xT)
  if t === 12:
    Chk/then(Chk/arm(es, ctx, d, sm, v, e, xT, kr, xv, env, goal), Chk/arms(es, ctx, d, sm, v + 1, xT, kr, xv, env, goal, e <> cov))
  else:
    if t === 31:
      if Chk/is(xt, &Bool) and (e === 0):
        f = @V{Num/val(0)}
        Chk/then(Chk/armFields(es, Chk/refine(ctx, d, kr, f), d, sm, v, env, Chk/refG(kr, xv, f, goal)), Chk/arms(es, ctx, d, sm, v + 1, xT, kr, xv, env, goal, cov))
      else:
        4002
    else:
      if t === 30:
        0
      else:
        if t === 2:
          if Chk/is(xt, &Bool):
            tr = @V{Num/val(1)}
            ctx2 = @Refn{tr, @V{Chk/mk0(&Bool)}} <> ctx
            Chk/armFields(es, Chk/refine(ctx2, d + 1, kr, tr), d + 1, (d + 1) <> sm, v, env, Chk/refG(kr, xv, tr, goal))
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
                  ctx2 = @Free{Prim/fresh(()), xT} <> ctx
                  Chk/armFields(es, Chk/refine(ctx2, d + 1, kr, @L{d + 1}), d + 1, (d + 1) <> sm, v, env, Chk/refG(kr, xv, @L{d + 1}, goal))
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

# a field-less arm: the scrutinee refined to the pattern p
def Chk/arm0(es: Val[], ctx: Ent[], d: U64, sm: U64[], a: U64, kr: U64, xv: G, p: G, env: U64[], goal: G) -> U64:
  Chk/armFields(es, Chk/refine(ctx, d, kr, p), d, sm, a, env, Chk/refG(kr, xv, p, goal))

# one constructor arm: its fields are generic elements of the field types,
# then the scrutinee is refined to the constructor of those fields
def Chk/arm(es: Val[], ctx: Ent[], d: U64, sm: U64[], a: U64, e: U64, xT: G, kr: U64, xv: G, env: U64[], goal: G) -> U64:
  xt = Chk/now(ctx, d, xT)
  if (e === Chk/id(&Zer)) and Chk/is(xt, &Nat):
    Chk/arm0(es, ctx, d, sm, a, kr, xv, @V{Chk/mk0(&Zer)}, env, goal)
  else:
    if (e === Chk/id(&Suc)) and Chk/is(xt, &Nat):
      Chk/arm1(es, ctx, d, sm, a, @V{Chk/mk0(&Nat)}, kr, xv, lambda l1. @K{Chk/id(&Suc), [@L{l1}]}, env, goal)
    else:
      if (e === Chk/id(&Nil)) and Chk/is(xt, &List):
        Chk/arm0(es, ctx, d, sm, a, kr, xv, @V{Chk/mk0(&Nil)}, env, goal)
      else:
        if (e === Chk/id(&Con)) and Chk/is(xt, &List):
          Chk/arm2(es, ctx, d, sm, a, @F{xT, 0}, lambda l1. xT, kr, xv, Chk/id(&Con), env, goal)
        else:
          if (e === Chk/id(&One)) and Chk/is(xt, &Unit):
            Chk/arm0(es, ctx, d, sm, a, kr, xv, @V{Chk/mk0(&One)}, env, goal)
          else:
            if (e === Chk/id(&Pair)) and Chk/is(xt, &Sig):
              Chk/arm2(es, ctx, d, sm, a, @F{xT, 0}, lambda l1. @A{@F{xT, 1}, @L{l1}}, kr, xv, Chk/id(&Pair), env, goal)
            else:
              if (e === Chk/id(&Refl)) and Chk/is(xt, &Eql):
                Chk/armJ(es, ctx, d, sm, a, xt, xT, kr, xv, env, goal)
              else:
                if Chk/is(xt, &Enum) and Chk/hasSym(Prim/vfield(xt, 0), e):
                  Chk/arm0(es, ctx, d, sm, a, kr, xv, @V{Prim/vctr(e, [])}, env, goal)
                else:
                  1

# J: the scrutinee is refl, and the endpoint a is identified with b: an
# alias of b's level when both are variables, b's value when only a is,
# and a rewrite of the goal when a is not a variable (Core: Rwt a b goal)
def Chk/armJ(es: Val[], ctx: Ent[], d: U64, sm: U64[], a: U64, xt: Val, xT: G, kr: U64, xv: G, env: U64[], goal: G) -> U64:
  refl = @V{Chk/mk0(&Refl)}
  c1 = Chk/refine(ctx, d, kr, refl)
  g1 = Chk/refG(kr, xv, refl, goal)
  ka = Chk/findFree(c1, d, Prim/vfield(xt, 1))
  kb = Chk/findFree(c1, d, Prim/vfield(xt, 2))
  eb = if kb === 0: @Refn{@V{Prim/vfield(xt, 2)}, @V{Prim/vfield(xt, 0)}} else: @Alias{kb, 0}
  c2 = if (ka === 0) or (ka === kb): c1 else: Chk/setE(c1, d - ka, eb)
  g2 = if ka === 0: @Rw{@V{Prim/vfield(xt, 1)}, @V{Prim/vfield(xt, 2)}, g1} else: g1
  Chk/armFields(es, c2, d, sm, a, env, g2)

def Chk/arm1(es: Val[], ctx: Ent[], d: U64, sm: U64[], a: U64, fT: G, kr: U64, xv: G, pat: U64 -> G, env: U64[], goal: G) -> U64:
  t = Chk/tag(a)
  if t === 6:
    Chk/arm1(es, Chk/dupEnt(ctx, d, sm, Chk/val(a)) <> ctx, d + 1, (d + 1) <> sm, Chk/val(a) + 1, fT, kr, xv, pat, env, goal)
  else:
    if t === 2:
      ctx2 = @Free{Prim/fresh(()), fT} <> ctx
      Chk/armFields(es, Chk/refine(ctx2, d + 1, kr, pat(d + 1)), d + 1, (d + 1) <> sm, Chk/val(a), env, Chk/refG(kr, xv, pat(d + 1), goal))
    else:
      4004

# a two-field arm: the first field's level is known when the second's type
# and the pattern are built
def Chk/arm2(es: Val[], ctx: Ent[], d: U64, sm: U64[], a: U64, fT: G, gT: U64 -> G, kr: U64, xv: G, t: U64, env: U64[], goal: G) -> U64:
  ta = Chk/tag(a)
  if ta === 6:
    Chk/arm2(es, Chk/dupEnt(ctx, d, sm, Chk/val(a)) <> ctx, d + 1, (d + 1) <> sm, Chk/val(a) + 1, fT, gT, kr, xv, t, env, goal)
  else:
    if ta === 2:
      l1 = d + 1
      Chk/arm1(es, @Free{Prim/fresh(()), fT} <> ctx, l1, l1 <> sm, Chk/val(a), gT(l1), kr, xv, lambda l2. @K{t, [@L{l1}, @L{l2}]}, env, goal)
    else:
      4005

# the environment binders of an arm alias the variables passed after the
# scrutinee; then the arm body is checked against the (refined) goal
def Chk/armFields(es: Val[], ctx: Ent[], d: U64, sm: U64[], a: U64, env: U64[], goal: G) -> U64:
  match env:
    case []:
      Chk/check(es, ctx, d, sm, a, goal)
    case x <> rest:
      ta = Chk/tag(a)
      if ta === 6:
        Chk/armFields(es, Chk/dupEnt(ctx, d, sm, Chk/val(a)) <> ctx, d + 1, (d + 1) <> sm, Chk/val(a) + 1, x <> rest, goal)
      else:
        if ta === 2:
          k = Chk/varLvl(sm, x)
          en = if k === 0: @Let{x, sm} else: @Alias{Chk/root(ctx, d, k), 0}
          Chk/armFields(es, en <> ctx, d + 1, (d + 1) <> sm, Chk/val(a), rest, goal)
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
              r = Chk/then(Chk/check(es, [], 0, [], tc, Chk/set()), Chk/check(es, [], 0, [], c, @V{Prim/typeof(i)}))
              (i, r) <> Chk/each(es, rest)

# (enum types last: the parser reads no `A{a == b}` signature after one)
def Tag() -> Set:
  &{&Pi, &Sig, &Set, &Nat, &Bool, &Unit, &Empty, &List, &Enum, &Num, &U64, &Chr, &Eql, &Zer, &Suc, &Nil, &Con, &One, &Pair, &Refl}

