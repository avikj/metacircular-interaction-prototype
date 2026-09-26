#define _GNU_SOURCE
/* pusc — cell.c: the heap, frames, and the one loop (MAP.md §§1–4, 6).
 *
 * Every rule below fires only at an active pair, only when demanded, and
 * appends its receipt.  Definitional unfolding (REF) is not counted: transport
 * is free (One §4).  Nothing is erased inside a run (§3.3).
 */
#include "cell.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

Term    *HEAP;  Loc HEAP_LEN = 1;          /* loc 0 is reserved (= "none") */
static Loc HEAP_CAP;
SNode   *CODE;  uint32_t CODE_LEN = 1;
Def     *BOOK;  uint32_t BOOK_LEN = 0;
uint64_t ITRS = 0;
uint32_t *TRACE; uint64_t TRACE_LEN = 0; static uint64_t TRACE_CAP;

/* ---- heap ------------------------------------------------------------- */
Loc alloc(uint32_t n) {
  if (!HEAP) { HEAP_CAP = 1u << 20; HEAP = calloc(HEAP_CAP, sizeof(Term)); }
  if (HEAP_LEN + n >= HEAP_CAP) {
    while (HEAP_LEN + n >= HEAP_CAP) HEAP_CAP *= 2;
    HEAP = realloc(HEAP, HEAP_CAP * sizeof(Term));
    memset(HEAP + HEAP_LEN, 0, (HEAP_CAP - HEAP_LEN) * sizeof(Term));
  }
  Loc l = HEAP_LEN; HEAP_LEN += n; return l;
}
static Term node1(unsigned t, uint32_t e, Term a)                 { Loc l = alloc(1); HEAP[l]=a; return mk(t,e,l); }
static Term node2(unsigned t, uint32_t e, Term a, Term b)         { Loc l = alloc(2); HEAP[l]=a; HEAP[l+1]=b; return mk(t,e,l); }
static Term node3(unsigned t, uint32_t e, Term a, Term b, Term c) { Loc l = alloc(3); HEAP[l]=a; HEAP[l+1]=b; HEAP[l+2]=c; return mk(t,e,l); }
static Term node4(unsigned t, uint32_t e, Term a, Term b, Term c, Term d) { Loc l = alloc(4); HEAP[l]=a; HEAP[l+1]=b; HEAP[l+2]=c; HEAP[l+3]=d; return mk(t,e,l); }

static void receipt(unsigned rule) {
  ITRS++;
  if (!TRACE) { TRACE_CAP = 1u << 16; TRACE = malloc(TRACE_CAP * sizeof(uint32_t)); }
  if (TRACE_LEN >= TRACE_CAP) { TRACE_CAP *= 2; TRACE = realloc(TRACE, TRACE_CAP * sizeof(uint32_t)); }
  TRACE[TRACE_LEN++] = rule;
}

/* ---- constructor names --------------------------------------------- */
static const char **CTORS; static uint32_t NCTORS;
uint32_t ctor_intern(const char *name, uint32_t arity) {
  (void)arity;
  static const char *builtin[] = { "", "Set","Pi","Sig","Path","Eql","Nat","Bool","Unit","Empty","List","Enum","Num","Glue","Pair","Refl" };
  for (uint32_t i = 1; i < sizeof builtin / sizeof *builtin; i++) if (!strcmp(builtin[i], name)) return i;
  for (uint32_t i = 0; i < NCTORS; i++) if (!strcmp(CTORS[i], name)) return C_USER_BASE + i;
  CTORS = realloc(CTORS, (NCTORS + 1) * sizeof *CTORS);
  CTORS[NCTORS] = strdup(name);
  return C_USER_BASE + NCTORS++;
}
const char *ctor_name(uint32_t id) {
  static const char *builtin[] = { "", "Set","Pi","Sig","Path","Eql","Nat","Bool","Unit","Empty","List","Enum","Num","Glue","Pair","Refl" };
  if (id < sizeof builtin / sizeof *builtin) return builtin[id];
  if (id - C_USER_BASE < NCTORS) return CTORS[id - C_USER_BASE];
  return "?";
}
int book_find(const char *name) {
  for (uint32_t i = 0; i < BOOK_LEN; i++) if (!strcmp(BOOK[i].name, name)) return (int)i;
  return -1;
}

/* ---- frames (§2) ------------------------------------------------------ */
/* A frame binds one slot; frames chain by parent; ext holds the depth.     */
/* T_DIM binds a dimension: its loc IS the name.                             */
/* T_RESTRICT records a face taken on everything the closure reads.          */
static Term frame_push(Term parent, Term slot) {
  uint32_t depth = tag(parent) ? ext(parent) + 1 : 0;
  return node2(T_FRAME, depth, parent, slot);
}
static Term dim_push(Term parent) {
  uint32_t depth = tag(parent) ? ext(parent) + 1 : 0;
  return node2(T_DIM, depth, parent, 0);
}
static Term restrict_push(Term parent, Loc name, unsigned side) {
  return node2(T_RESTRICT, side, parent, mk(T_IVAR, 0, name));
}
static uint32_t frame_depth(Term f) {
  while (tag(f) == T_RESTRICT) f = HEAP[loc(f)];
  return tag(f) ? ext(f) + 1 : 0;   /* number of bindings in scope */
}
/* Look up level `lvl`, wrapping the value in every face taken between here and it. */
static Term frame_lookup(Term f, uint32_t lvl, bool *is_dim) {
  Term faces[64]; unsigned nf = 0;
  for (;;) {
    if (!tag(f)) { fprintf(stderr, "pusc: unbound level %u\n", lvl); exit(2); }
    if (tag(f) == T_RESTRICT) { if (nf < 64) faces[nf++] = f; f = HEAP[loc(f)]; continue; }
    if (ext(f) == lvl) break;
    f = HEAP[loc(f)];
  }
  Term v;
  if (tag(f) == T_DIM) { *is_dim = true; v = mk(T_IVAR, 0, loc(f)); }
  else { *is_dim = false; v = mk(T_VAR, lvl, loc(f)); }   /* a VAR reads the slot lazily (§2: forced once, written back) */
  for (unsigned i = nf; i-- > 0;) v = node2(T_FCE, ext(faces[i]), HEAP[loc(faces[i]) + 1], v);
  return v;
}

/* ---- instantiation: static code → cells over a frame (δ, uncounted) ---- */
Term inst(uint32_t c, Term fr) {
  SNode *n = &CODE[c];
  switch (n->tag) {
    case S_VAR: { bool d; return frame_lookup(fr, n->ext, &d); }
    case S_LAM: return node2(T_LAM, 0, mk(0, 0, c), fr);
    case S_PLM: return node2(T_PLM, 0, mk(0, 0, c), fr);
    case S_DIM: return inst(n->a, dim_push(fr));
    case S_LET: { Term v = inst(n->a, fr); return inst(n->b, frame_push(fr, v)); }
    case S_APP: return node2(T_APP, 0, inst(n->a, fr), inst(n->b, fr));
    case S_REF: return mk(T_REF, 0, n->ext);
    case S_ERA: return mk(T_ERA, 0, 0);
    case S_SUP: { bool d; Term nm = frame_lookup(fr, n->ext, &d);
                  return node3(T_SUP, 0, nm, inst(n->a, fr), inst(n->b, fr)); }
    case S_FCE: { bool d; Term nm = frame_lookup(fr, n->a, &d);
                  return node2(T_FCE, n->ext, nm, inst(n->b, fr)); }
    case S_I0:  return mk(T_I0, 0, 0);
    case S_I1:  return mk(T_I1, 0, 0);
    case S_IVAR:{ bool d; return frame_lookup(fr, n->ext, &d); }
    case S_INOT: return node1(T_INOT, 0, inst(n->a, fr));
    case S_IAND: return node2(T_IAND, 0, inst(n->a, fr), inst(n->b, fr));
    case S_IOR:  return node2(T_IOR, 0, inst(n->a, fr), inst(n->b, fr));
    case S_CTR: { uint32_t ar = n->ext & 0xFF; Loc l = alloc(ar ? ar : 1);
                  uint32_t kids[4] = { n->a, n->b, n->c, n->d };
                  for (uint32_t i = 0; i < ar && i < 4; i++) HEAP[l + i] = inst(kids[i], fr);
                  if (ar > 4) { /* long constructors chain fields through S_LET-style lists: not needed yet */ }
                  return mk(T_CTR, n->ext, l); }
    case S_NUM: return node1(T_NUM, 0, (Term)n->num);
    case S_OP2: return node2(T_OP2, n->ext, inst(n->a, fr), inst(n->b, fr));
    case S_TRP: return node4(T_TRP, 0, inst(n->a, fr), inst(n->b, fr), inst(n->c, fr), inst(n->d, fr));
    case S_CASE: return node3(T_CASE, 0, inst(n->a, fr), mk(0, 0, c), fr);
    case S_CHK: return node2(T_CHK, 0, inst(n->a, fr), inst(n->b, fr));
    case S_ASK: return node2(T_ASK, 0, inst(n->a, fr), inst(n->b, fr));
    default: fprintf(stderr, "pusc: inst: bad static tag %u\n", n->tag); exit(2);
  }
}

/* ---- the interval (§3.4, minimal: evaluate; DNF follows) ---------------- */
static Term iwhnf(Term t) {
  switch (tag(t)) {
    case T_INOT: { Term a = iwhnf(HEAP[loc(t)]);
      if (tag(a) == T_I0) return mk(T_I1,0,0); if (tag(a) == T_I1) return mk(T_I0,0,0);
      if (tag(a) == T_INOT) return HEAP[loc(a)]; HEAP[loc(t)] = a; return t; }
    case T_IAND: { Term a = iwhnf(HEAP[loc(t)]), b = iwhnf(HEAP[loc(t)+1]);
      if (tag(a) == T_I0 || tag(b) == T_I0) return mk(T_I0,0,0);
      if (tag(a) == T_I1) return b; if (tag(b) == T_I1) return a;
      HEAP[loc(t)] = a; HEAP[loc(t)+1] = b; return t; }
    case T_IOR: { Term a = iwhnf(HEAP[loc(t)]), b = iwhnf(HEAP[loc(t)+1]);
      if (tag(a) == T_I1 || tag(b) == T_I1) return mk(T_I1,0,0);
      if (tag(a) == T_I0) return b; if (tag(b) == T_I0) return a;
      HEAP[loc(t)] = a; HEAP[loc(t)+1] = b; return t; }
    case T_FCE: case T_VAR: return whnf(t);
    default: return t;
  }
}

/* ---- the face map (§3.1) ------------------------------------------------ */
static bool is_value(Term t) {
  switch (tag(t)) {
    case T_LAM: case T_PLM: case T_SUP: case T_CTR: case T_NUM: case T_ERA: case T_REF:
    case T_I0: case T_I1: case T_IVAR: return true;
    default: return false;
  }
}
static Term fce_apply(Loc name, unsigned side, Term v);

/* push a face map into a closure: record the restriction on its frame */
static Term fce_closure(unsigned ctag, Loc name, unsigned side, Term clo) {
  Term code = HEAP[loc(clo)], fr = HEAP[loc(clo) + 1];
  return node2(ctag, 0, code, restrict_push(fr, name, side));
}
static Term fce_apply(Loc name, unsigned side, Term v) {
  v = whnf(v);
  switch (tag(v)) {
    case T_SUP: {
      Term nm = whnf(HEAP[loc(v)]);
      if (tag(nm) == T_IVAR && loc(nm) == name) { receipt(R_FCE_ANNIHILATE); return whnf(HEAP[loc(v) + 1 + side]); }
      receipt(R_FCE_COMMUTE);                       /* δᵢδⱼ = δⱼδᵢ */
      return node3(T_SUP, 0, nm, node2(T_FCE, side, mk(T_IVAR,0,name), HEAP[loc(v)+1]),
                                 node2(T_FCE, side, mk(T_IVAR,0,name), HEAP[loc(v)+2]));
    }
    case T_LAM: receipt(R_FCE_PUSH); return fce_closure(T_LAM, name, side, v);
    case T_PLM: receipt(R_FCE_PUSH); return fce_closure(T_PLM, name, side, v);
    case T_IVAR: if (loc(v) == name) { receipt(R_FCE_ANNIHILATE); return mk(side ? T_I1 : T_I0, 0, 0); }
                 receipt(R_FCE_SHARE); return v;
    case T_CTR: {
      uint32_t ar = ctr_arity(v);
      if (ar == 0) { receipt(R_FCE_SHARE); return v; }
      receipt(R_FCE_PUSH);
      Loc l = alloc(ar);
      for (uint32_t i = 0; i < ar; i++) HEAP[l+i] = node2(T_FCE, side, mk(T_IVAR,0,name), HEAP[loc(v)+i]);
      return mk(T_CTR, ext(v), l);
    }
    case T_NUM: case T_ERA: case T_REF: case T_I0: case T_I1: receipt(R_FCE_SHARE); return v;
    default: /* stuck: the face map waits */ return node2(T_FCE, side, mk(T_IVAR,0,name), v);
  }
}

/* ---- opening a closure (β, path application) --------------------------- */
static Term open_closure(Term clo, Term arg) {
  uint32_t code = loc(HEAP[loc(clo)]);
  Term fr = HEAP[loc(clo) + 1];
  SNode *n = &CODE[code];                 /* S_LAM / S_PLM: body is n->a */
  return inst(n->a, frame_push(fr, arg));
}

/* ---- case trees (§4): the eliminator instantiated on the heap ---------- */
static Term case_select(Term cs, Term scrut) {
  uint32_t code = loc(HEAP[loc(cs) + 1]); Term fr = HEAP[loc(cs) + 2];
  SNode *n = &CODE[code];                 /* S_CASE: a = scrut, b = first S_BRANCH */
  uint32_t br = n->b;
  while (br) {
    SNode *b = &CODE[br];                 /* S_BRANCH: ext = ctor id, a = arity, b = body, c = next */
    if (b->ext == ctr_id(scrut) || b->ext == 0xFFFFFF) {
      Term f = fr;
      uint32_t ar = b->ext == 0xFFFFFF ? 0 : ctr_arity(scrut);
      for (uint32_t i = 0; i < ar; i++) f = frame_push(f, HEAP[loc(scrut) + i]);
      return inst(b->b, f);
    }
    br = b->c;
  }
  fprintf(stderr, "pusc: no branch for %s\n", ctor_name(ctr_id(scrut))); exit(3);
}
static Term case_restrict(Term cs, Loc name, unsigned side, Term scrut) {
  Term code = HEAP[loc(cs) + 1], fr = HEAP[loc(cs) + 2];
  return node3(T_CASE, 0, scrut, code, restrict_push(fr, name, side));
}

/* ---- numbers ---------------------------------------------------------- */
static Term op2_num(unsigned op, uint64_t a, uint64_t b) {
  uint64_t r = 0;
  switch (op) {
    case OP_ADD: r = a + b; break; case OP_SUB: r = a - b; break; case OP_MUL: r = a * b; break;
    case OP_DIV: r = b ? a / b : 0; break; case OP_MOD: r = b ? a % b : 0; break;
    case OP_EQ: r = a == b; break; case OP_NE: r = a != b; break; case OP_LT: r = a < b; break;
    case OP_LE: r = a <= b; break; case OP_GT: r = a > b; break; case OP_GE: r = a >= b; break;
    case OP_AND: r = a & b; break; case OP_OR: r = a | b; break; case OP_XOR: r = a ^ b; break;
    case OP_LSH: r = a << b; break; case OP_RSH: r = a >> b; break;
  }
  return node1(T_NUM, 0, (Term)r);
}

/* ---- the loop (§3): weak head, demanded interaction ---------------------- */
Term whnf(Term t) {
  for (;;) {
    switch (tag(t)) {
      case T_VAR: {                                   /* a coordinate: force once, write back */
        Loc slot = loc(t) + 1; Term v = HEAP[slot];
        if (tag(v) == T_VAR && loc(v) == loc(t)) return t;   /* a generic element: its own slot */
        v = whnf(v); HEAP[slot] = v; return v;
      }
      case T_REF: {                                   /* δ: the definition's own fresh dimensions */
        Def *d = &BOOK[loc(t)]; Term fr = 0;
        for (uint32_t i = 0; i < d->ndims; i++) fr = dim_push(fr);
        t = inst(d->code, fr); continue;
      }
      case T_APP: {
        Term f = whnf(HEAP[loc(t)]), x = HEAP[loc(t) + 1];
        switch (tag(f)) {
          case T_LAM: receipt(R_BETA); t = open_closure(f, x); continue;
          case T_PLM: receipt(R_APP_PLM); t = open_closure(f, x); continue;
          case T_SUP: {                               /* distribute; the argument face-mapped at the name */
            receipt(R_APP_SUP);
            Term nm = HEAP[loc(f)]; Loc name = loc(whnf(nm));
            Term x0 = node2(T_FCE, 0, mk(T_IVAR,0,name), x), x1 = node2(T_FCE, 1, mk(T_IVAR,0,name), x);
            return node3(T_SUP, 0, nm, node2(T_APP, 0, HEAP[loc(f)+1], x0), node2(T_APP, 0, HEAP[loc(f)+2], x1));
          }
          default: HEAP[loc(t)] = f; return t;        /* stuck spine */
        }
      }
      case T_FCE: {
        Term nm = whnf(HEAP[loc(t)]);
        if (tag(nm) != T_IVAR) { HEAP[loc(t)] = nm; return t; }
        return fce_apply(loc(nm), ext(t), HEAP[loc(t) + 1]);
      }
      case T_CASE: {
        Term s = whnf(HEAP[loc(t)]);
        switch (tag(s)) {
          case T_CTR: receipt(R_CASE); t = case_select(t, s); continue;
          case T_SUP: {                                /* a match commutes over a superposition */
            receipt(R_CASE_SUP);
            Loc name = loc(whnf(HEAP[loc(s)]));
            return node3(T_SUP, 0, HEAP[loc(s)], case_restrict(t, name, 0, HEAP[loc(s)+1]),
                                                 case_restrict(t, name, 1, HEAP[loc(s)+2]));
          }
          default: HEAP[loc(t)] = s; return t;
        }
      }
      case T_OP2: {
        Term a = whnf(HEAP[loc(t)]);
        if (tag(a) == T_SUP) { receipt(R_OP2_SUP); Loc name = loc(whnf(HEAP[loc(a)])); Term b = HEAP[loc(t)+1];
          return node3(T_SUP, 0, HEAP[loc(a)],
            node2(T_OP2, ext(t), HEAP[loc(a)+1], node2(T_FCE,0,mk(T_IVAR,0,name),b)),
            node2(T_OP2, ext(t), HEAP[loc(a)+2], node2(T_FCE,1,mk(T_IVAR,0,name),b))); }
        Term b = whnf(HEAP[loc(t) + 1]);
        if (tag(b) == T_SUP) { receipt(R_OP2_SUP); Loc name = loc(whnf(HEAP[loc(b)]));
          return node3(T_SUP, 0, HEAP[loc(b)],
            node2(T_OP2, ext(t), node2(T_FCE,0,mk(T_IVAR,0,name),a), HEAP[loc(b)+1]),
            node2(T_OP2, ext(t), node2(T_FCE,1,mk(T_IVAR,0,name),a), HEAP[loc(b)+2])); }
        if (tag(a) == T_NUM && tag(b) == T_NUM) { receipt(R_OP2); return op2_num(ext(t), HEAP[loc(a)], HEAP[loc(b)]); }
        HEAP[loc(t)] = a; HEAP[loc(t)+1] = b; return t;
      }
      case T_INOT: case T_IAND: case T_IOR: return iwhnf(t);
      case T_CHK: t = HEAP[loc(t) + 1]; continue;    /* a judgment projects to its term at run */
      case T_TRP: case T_HCM:                         /* §3.5 follows: stuck for now */
        return t;
      default: return t;
    }
  }
}

/* ---- normal forms and printing ------------------------------------------ */
static Term generic(Term fr) {              /* a fresh generic element: a slot that points to itself */
  Term f = frame_push(fr, 0);
  HEAP[loc(f) + 1] = mk(T_VAR, ext(f), loc(f));
  return f;
}
Term normalize(Term t, int depth) {
  if (depth <= 0) return t;
  t = whnf(t);
  switch (tag(t)) {
    case T_CTR: for (uint32_t i = 0; i < ctr_arity(t); i++) HEAP[loc(t)+i] = normalize(HEAP[loc(t)+i], depth-1); return t;
    case T_SUP: HEAP[loc(t)+1] = normalize(HEAP[loc(t)+1], depth-1); HEAP[loc(t)+2] = normalize(HEAP[loc(t)+2], depth-1); return t;
    case T_APP: HEAP[loc(t)+1] = normalize(HEAP[loc(t)+1], depth-1); return t;
    default: return t;
  }
}
static void print_rec(Term t, int depth) {
  if (depth <= 0) { printf("…"); return; }
  t = whnf(t);
  switch (tag(t)) {
    case T_NUM: printf("%llu", (unsigned long long)HEAP[loc(t)]); break;
    case T_CTR: { uint32_t ar = ctr_arity(t); printf("#%s", ctor_name(ctr_id(t)));
      if (ar) { printf("{"); for (uint32_t i = 0; i < ar; i++) { if (i) printf(","); print_rec(HEAP[loc(t)+i], depth-1); } printf("}"); }
      else printf("{}"); break; }
    case T_SUP: { Term nm = whnf(HEAP[loc(t)]); printf("&%u{", tag(nm)==T_IVAR ? loc(nm) : 0);
      print_rec(HEAP[loc(t)+1], depth-1); printf(","); print_rec(HEAP[loc(t)+2], depth-1); printf("}"); break; }
    case T_LAM: { Term fr = HEAP[loc(t)+1]; Term g = generic(fr); uint32_t code = loc(HEAP[loc(t)]);
      printf("λx%u.", ext(g)); print_rec(inst(CODE[code].a, g), depth-1); break; }
    case T_PLM: { Term fr = HEAP[loc(t)+1]; Term g = dim_push(fr); uint32_t code = loc(HEAP[loc(t)]);
      printf("<i%u>", loc(g)); print_rec(inst(CODE[code].a, g), depth-1); break; }
    case T_VAR: printf("x%u", ext(t)); break;
    case T_IVAR: printf("i%u", loc(t)); break;
    case T_I0: printf("i0"); break; case T_I1: printf("i1"); break;
    case T_INOT: printf("~"); print_rec(HEAP[loc(t)], depth-1); break;
    case T_IAND: printf("("); print_rec(HEAP[loc(t)], depth-1); printf("∧"); print_rec(HEAP[loc(t)+1], depth-1); printf(")"); break;
    case T_IOR:  printf("("); print_rec(HEAP[loc(t)], depth-1); printf("∨"); print_rec(HEAP[loc(t)+1], depth-1); printf(")"); break;
    case T_ERA: printf("*"); break;
    case T_REF: printf("@%s", BOOK[loc(t)].name); break;
    case T_APP: printf("("); print_rec(HEAP[loc(t)], depth-1); printf(" "); print_rec(HEAP[loc(t)+1], depth-1); printf(")"); break;
    case T_FCE: printf("[i%u:=%u]", loc(whnf(HEAP[loc(t)])), ext(t)); print_rec(HEAP[loc(t)+1], depth-1); break;
    case T_CASE: printf("case("); print_rec(HEAP[loc(t)], depth-1); printf(")"); break;
    case T_OP2: printf("("); print_rec(HEAP[loc(t)], depth-1); printf(" op%u ", ext(t)); print_rec(HEAP[loc(t)+1], depth-1); printf(")"); break;
    case T_TRP: printf("trp(…)"); break;
    case T_HCM: printf("hcomp(…)"); break;
    default: printf("?%u", tag(t));
  }
}
void print_term(Term t, int depth) { print_rec(t, depth); }

Term run_def(uint32_t id) { return whnf(mk(T_REF, 0, id)); }
