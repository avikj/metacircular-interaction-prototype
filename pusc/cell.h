/* pusc — the Parallel Univalent Superposition Computer.  cell.h: the word.
 *
 * MAP.md §1.  One data structure: a heap of cells over bound dimension names.
 * A Port is one word:  tag:8 | ext:24 | loc:32.  A node is a block at loc.
 * A Name is the heap address of the frame that bound it, so two instances of
 * one definition never share a name (the label-capture finding).
 */
#ifndef PUSC_CELL_H
#define PUSC_CELL_H
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

typedef uint64_t Term;
typedef uint32_t Loc;

/* ---- tags ------------------------------------------------------------- */
enum Tag {
  /* points and maps */
  T_VAR = 1,   /* ext = de Bruijn level, loc = frame               */
  T_LAM,       /* loc → [code, frame]              closure          */
  T_APP,       /* loc → [fun, arg]                  ● fun            */
  T_REF,       /* loc = book index                  a NAME (value)   */
  T_ERA,       /* the one address of loss                             */
  /* lines: one notion of dimension */
  T_SUP,       /* loc → [name, a, b]                a 1-cell by faces */
  T_PLM,       /* loc → [code, frame]              a 1-cell by formula (binds a dim) */
  T_FCE,       /* ext = side, loc → [name, target]  the face map      */
  /* the interval */
  T_I0, T_I1,  /* no node                                              */
  T_IVAR,      /* loc = name                                           */
  T_INOT,      /* loc → [a]                                            */
  T_IAND,      /* loc → [a, b]                                         */
  T_IOR,       /* loc → [a, b]                                         */
  /* data; a type is a CTR cell with a reserved constructor id */
  T_CTR,       /* ext = ctor id (16) | arity (8), loc → fields         */
  T_NUM,       /* loc → [u64]                                          */
  T_OP2,       /* ext = op, loc → [a, b]            ● a then ● b       */
  /* Kan */
  T_TRP,       /* loc → [line, r, s, x]             ● line            */
  T_HCM,       /* ext = nfaces, loc → [type, base, phi₁,u₁,…]  ● faces */
  /* static-code eliminators instantiated on the heap */
  T_CASE,      /* loc → [scrut, code, frame]        ● scrut           */
  /* judgments and the interaction */
  T_CHK,       /* loc → [type, term]                                   */
  T_ASK,       /* loc → [q, k]                      a free port        */
  /* frames (never a value) */
  T_FRAME,     /* loc → [parent, slot]  ext = depth   one binding      */
  T_DIM,       /* loc → [parent, unused] ext = depth  a bound dimension: its loc is the NAME */
  T_RESTRICT,  /* loc → [parent, name]  ext = side    a face taken on a closure's frame */
  T_TAGS
};

static inline Term  mk(unsigned tag, uint32_t ext, Loc loc) {
  return ((Term)tag << 56) | ((Term)(ext & 0xFFFFFFu) << 32) | (Term)loc;
}
static inline unsigned tag(Term t) { return (unsigned)(t >> 56); }
static inline uint32_t ext(Term t) { return (uint32_t)((t >> 32) & 0xFFFFFFu); }
static inline Loc      loc(Term t) { return (Loc)t; }

/* ---- constructor ids (a type is a point of Set) ------------------------ */
enum Ctor {
  C_USER = 0,        /* user constructors are looked up by name, ids ≥ C_USER_BASE */
  C_SET = 1, C_PI, C_SIG, C_PATH, C_EQL, C_NAT, C_BOOL, C_UNIT, C_EMPTY, C_LIST,
  C_ENUM, C_NUMTY, C_GLU, C_PAIR, C_REFL,
  C_USER_BASE = 64
};
static inline uint32_t ctr_ext(uint32_t id, uint32_t arity) { return (id << 8) | (arity & 0xFF); }
static inline uint32_t ctr_id(Term t)    { return ext(t) >> 8; }
static inline uint32_t ctr_arity(Term t) { return ext(t) & 0xFF; }

/* ---- ops ---------------------------------------------------------------- */
enum Op { OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_MOD, OP_EQ, OP_NE, OP_LT, OP_LE, OP_GT, OP_GE,
          OP_AND, OP_OR, OP_XOR, OP_LSH, OP_RSH, OP_COUNT };

/* ---- static code (the BOOK) ------------------------------------------- */
/* Static terms live in an immutable arena; binders are de Bruijn levels.  */
enum STag {
  S_VAR = 1, S_LAM, S_APP, S_REF, S_ERA, S_SUP, S_PLM, S_DIM, S_FCE,
  S_I0, S_I1, S_IVAR, S_INOT, S_IAND, S_IOR,
  S_CTR, S_NUM, S_OP2, S_TRP, S_HCM, S_CASE, S_BRANCH, S_CHK, S_ASK, S_LET
};
typedef struct SNode {
  uint8_t  tag;
  uint32_t ext;        /* level / op / ctor ext / side / count */
  uint32_t a, b, c, d; /* child indices into the arena (0 = none) */
  uint64_t num;        /* S_NUM */
} SNode;

typedef struct Def {
  const char *name;
  uint32_t    code;    /* static index of the body */
  uint32_t    type;    /* static index of the type, 0 if none */
  uint32_t    ndims;   /* implicit dimension binders at the top */
} Def;

/* ---- the machine ----------------------------------------------------- */
typedef struct Rule { uint32_t lhs, rhs, cert; } Rule;   /* §8, install appends */

extern Term    *HEAP;   extern Loc HEAP_LEN;
extern SNode   *CODE;   extern uint32_t CODE_LEN;
extern Def     *BOOK;   extern uint32_t BOOK_LEN;
extern uint64_t ITRS;
extern uint32_t *TRACE; extern uint64_t TRACE_LEN;   /* receipts: rule ids */

enum RuleId { R_BETA = 1, R_APP_SUP, R_APP_PLM, R_FCE_ANNIHILATE, R_FCE_COMMUTE, R_FCE_PUSH,
              R_FCE_SHARE, R_CASE, R_CASE_SUP, R_OP2, R_OP2_SUP, R_ERASE, R_TRP, R_HCM, R_COUNT };

Loc  alloc(uint32_t n);
Term whnf(Term t);
Term normalize(Term t, int depth);
void print_term(Term t, int depth);
Term inst(uint32_t code, Term frame);
Term run_def(uint32_t id);
int  book_find(const char *name);
const char *ctor_name(uint32_t id);
uint32_t ctor_intern(const char *name, uint32_t arity);
#endif
