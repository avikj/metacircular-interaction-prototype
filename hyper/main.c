/* hyper — main.c: run | bend | check | interact | census.
 *
 * The machine is Fibre.CorpusInteraction (fibre/src/Fibre/CorpusInteraction.agda): a state is a typed point
 * (A, a) : Σ A. A; a question is a typed map (B, f) out of the current type; the answer is the point (B, f a);
 * the receipt is the path target s q ≡ s', refl at the canonical step; the process continues at the new point
 * (ISC, react).  `run` is the trivial-query case.  `interact` reads questions from the world, one per line.
 * Every run reports its charge (research/sat_fibre/InteractionLedger.agda: interactions and heap words), and
 * `census` reports what a question loses (Fibre.WholePartialDesa: the fibre over each visible value). */
#include "cell.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/resource.h>
void read_file(const char *path);
int read_question(const char *text);
int check_book(const char *prefix);
Term app2(Term f, Term a);
Term node2(unsigned t, uint32_t e, Term a, Term b);

/* §5: the machine that asks. The root is the typed point; each line of the world is a question q, a
   term; the point presents itself along q: root := (q a, (a, refl)). A reduction that stalls at an
   ASK cell prints the question and waits for the world's section; the continuation resumes on it. */
static char *read_line(FILE *in) {
  static char buf[1 << 16]; if (!fgets(buf, sizeof buf, in)) return 0;
  size_t n = strlen(buf); while (n && (buf[n-1] == '\n' || buf[n-1] == '\r')) buf[--n] = 0;
  return buf;
}
static Term answer_asks(Term v, bool bend) {
  for (;;) {
    v = whnf(v);
    if (tag(v) != T_ASK) return v;
    printf("? "); if (bend) print_bend(HEAP[loc(v)], 64); else print_term(HEAP[loc(v)], 64); printf("\n"); fflush(stdout);
    char *line = read_line(stdin); if (!line) { fprintf(stderr, "hyper: the world went silent at a question\n"); exit(1); }
    int q = read_question(line);
    v = app2(HEAP[loc(v)+1], mk(T_REF, 0, (uint32_t)q));
  }
}
static int interact(const char *entry, bool bend) {
  int id = book_find(entry); if (id < 0) { fprintf(stderr, "hyper: no %s\n", entry); return 1; }
  uint64_t before = ITRS;
  Term root = answer_asks(mk(T_REF, 0, (uint32_t)id), bend);
  if (bend) collapse_print(root); else { print_term(root, 64); printf("\n"); }
  printf("- Itrs: %llu\n", (unsigned long long)(ITRS - before)); fflush(stdout);
  for (char *line; (line = read_line(stdin)); ) {
    if (!*line || *line == ';') continue;
    int q = read_question(line); before = ITRS;
    Term qa = answer_asks(app2(mk(T_REF, 0, (uint32_t)q), root), bend);
    if (bend) collapse_print(qa); else { print_term(qa, 64); printf("\n"); }
    printf("- Itrs: %llu\n", (unsigned long long)(ITRS - before)); fflush(stdout);
    root = node2(T_CTR, ctr_ext(C_PAIR, 2), qa, node2(T_CTR, ctr_ext(C_PAIR, 2), root, mk(T_CTR, ctr_ext(C_REFL, 0), 1)));   /* present: (q a, (a, refl)) */
  }
  return 0;
}
/* गणना f : (b : B) → देश f b  (fibre/src/Fibre/WholePartialDesa_….agda:87–94): the census of a question, pointwise
   over the codomain.  The domain and codomain are given as superpositions of their points; the fibre शेष f b is
   the set of domain points whose value is b, and its census is नास्ति (no point), सकलादेश (one point), or
   विकलादेश (two or more distinct points, both shown). */
static int census(const char *f, const char *dom, const char *cod) {
  int fi = book_find(f), di = book_find(dom), ci = book_find(cod);
  if (fi < 0 || di < 0 || ci < 0) { fprintf(stderr, "hyper: census needs three definitions: the map, the domain, the codomain\n"); return 1; }
  static Term as[4096], bs[4096]; int na = collapse_leaves(mk(T_REF, 0, (uint32_t)di), as, 4096), nb = collapse_leaves(mk(T_REF, 0, (uint32_t)ci), bs, 4096);
  char **fa = calloc((size_t)na, sizeof *fa), **sa = calloc((size_t)na, sizeof *sa);
  for (int i = 0; i < na; i++) { sa[i] = term_string(as[i], 64); fa[i] = term_string(app2(mk(T_REF, 0, (uint32_t)fi), as[i]), 64); }
  for (int j = 0; j < nb; j++) {
    char *b = term_string(bs[j], 64); int k = 0;
    for (int i = 0; i < na; i++) if (!strcmp(fa[i], b)) k++;
    printf("%s: %s", b, k == 0 ? "नास्ति" : k == 1 ? "सकलादेश" : "विकलादेश");
    for (int i = 0; i < na; i++) if (!strcmp(fa[i], b)) printf(" %s", sa[i]);
    printf("\n");
  }
  return 0;
}
/* ---- the encounter of two peers -------------------------------------------------------------------------
   formal/cubical/kernel-flat/TheEncounterOfTwoPeersIsOneTraceAndNoScalarProjectionOfItHasASection.agda.
   A Derivation a b is a sequence of steps (RewriteCertificate: done, then-step, and `reverse` as a constructor);
   here a step is a receipt, a rule at a node, and a run of a term to its normal form is one.  A Peer is a Session
   (origin, here, trace : Derivation origin here, library).  An Encounter is two peers and an overlap they both
   reach: mine : Derivation (here A) meeting, theirs : Derivation meeting (here B).  τ = mine ⊕ theirs;
   interact E = (A′, B′, τ); gain installs theirs, mine and τ as moves; receive keeps the moves and does not move. */
typedef struct { Term from, to; uint32_t n; uint32_t *rule; Loc *node; bool *rev; } Derivation;
typedef struct { Term source, target; Derivation by; } Move;               /* install d: a move from d.from to d.to, carrying d */
typedef struct { Term origin, here; Derivation trace; Move *library; int nlib; } Session;

static Derivation done(Term t) { Derivation d = { t, t, 0, 0, 0, 0 }; return d; }
static Derivation run_derivation(Term t) {                                 /* the receipts of reducing t to its normal form */
  uint64_t from = TRACE_LEN; Term v = normalize(t, 64);
  Derivation d = { t, v, (uint32_t)(TRACE_LEN - from), 0, 0, 0 };
  d.rule = malloc(d.n * sizeof *d.rule); d.node = malloc(d.n * sizeof *d.node); d.rev = calloc(d.n, sizeof *d.rev);
  for (uint32_t i = 0; i < d.n; i++) { d.rule[i] = TRACE[from + i]; d.node[i] = TRACE_NODE[from + i]; }
  return d;
}
static Derivation cat(Derivation d, Derivation e) {                         /* _⊕_ : Derivation a b → Derivation b c → Derivation a c */
  Derivation r = { d.from, e.to, d.n + e.n, 0, 0, 0 };
  r.rule = malloc(r.n * sizeof *r.rule); r.node = malloc(r.n * sizeof *r.node); r.rev = malloc(r.n * sizeof *r.rev);
  for (uint32_t i = 0; i < d.n; i++) { r.rule[i] = d.rule[i]; r.node[i] = d.node[i]; r.rev[i] = d.rev[i]; }
  for (uint32_t i = 0; i < e.n; i++) { r.rule[d.n+i] = e.rule[i]; r.node[d.n+i] = e.node[i]; r.rev[d.n+i] = e.rev[i]; }
  return r;
}
static Derivation rev(Derivation d) {                                       /* rev : Derivation a b → Derivation b a, each step reversed */
  Derivation r = { d.to, d.from, d.n, 0, 0, 0 };
  r.rule = malloc(r.n * sizeof *r.rule); r.node = malloc(r.n * sizeof *r.node); r.rev = malloc(r.n * sizeof *r.rev);
  for (uint32_t i = 0; i < d.n; i++) { r.rule[i] = d.rule[d.n-1-i]; r.node[i] = d.node[d.n-1-i]; r.rev[i] = !d.rev[d.n-1-i]; }
  return r;
}
static bool same_steps(Derivation d, Derivation e) {                        /* equality of derivations as data */
  if (d.n != e.n) return false;
  for (uint32_t i = 0; i < d.n; i++) if (d.rule[i] != e.rule[i] || d.node[i] != e.node[i] || d.rev[i] != e.rev[i]) return false;
  return true;
}
static Session begin(Term t) { Session s = { t, t, done(t), 0, 0 }; return s; }
static Session with_moves(Session s, Term here, Derivation trace, Move a, Move b, Move c) {   /* gain: three moves prepended */
  Session r = s; r.here = here; r.trace = trace; r.nlib = s.nlib + 3; r.library = malloc((size_t)r.nlib * sizeof *r.library);
  r.library[0] = a; r.library[1] = b; r.library[2] = c; for (int i = 0; i < s.nlib; i++) r.library[3+i] = s.library[i];
  return r;
}
static bool enabled(Session s, const char *t) {                             /* SomeEnabled (library s) t: a move whose source is t */
  for (int i = 0; i < s.nlib; i++) if (!strcmp(term_string(s.library[i].source, 64), t)) return true;
  return false;
}
static int meet(const char *na, const char *nb) {
  int ia = book_find(na), ib = book_find(nb); if (ia < 0 || ib < 0) { fprintf(stderr, "hyper: meet needs two definitions\n"); return 1; }
  Term ta = mk(T_REF, 0, (uint32_t)ia), tb = mk(T_REF, 0, (uint32_t)ib);
  Session A = begin(ta), B = begin(tb);
  Derivation mine = run_derivation(ta), toB = run_derivation(tb);
  char *va = term_string(mine.to, 64), *vb = term_string(toB.to, 64);
  if (strcmp(va, vb)) { printf("no meeting: %s reaches %s, %s reaches %s\n", na, va, nb, vb); return 2; }
  Derivation theirs = rev(toB);                                            /* B's stretch from the meeting: rev of its run */
  Derivation tau = cat(mine, theirs);                                      /* τ E = mine E ⊕ theirs E */
  Move m_theirs = { theirs.from, theirs.to, theirs }, m_mine = { mine.from, mine.to, mine }, m_tau = { tau.from, tau.to, tau };
  Session A2 = with_moves(A, B.here, cat(A.trace, tau), m_theirs, m_mine, m_tau);          /* A′ */
  Session B2 = with_moves(B, A.here, cat(B.trace, rev(tau)), m_theirs, m_mine, m_tau);     /* B′ */
  Derivation round = cat(tau, rev(tau));                                   /* round-trip E = τ E ⊕ rev (τ E) */
  printf("meeting: %s\n", va);
  printf("mine: %u  theirs: %u  τ: %u\n", mine.n, theirs.n, tau.n);
  printf("A′ stands at %s, B′ stands at %s%s\n", nb, na, strcmp(na, nb) ? "; the two results need not agree" : "");
  printf("origins kept: %s %s\n", A2.origin == A.origin ? "yes" : "no", B2.origin == B.origin ? "yes" : "no");
  printf("the prior trace is a prefix: %s\n", same_steps(A2.trace, cat(A.trace, tau)) ? "yes" : "no");
  printf("round trip: %u steps, from %s to %s; the meaning is refl, the object is not done\n", round.n, round.from == ta ? na : nb, round.to == ta ? na : nb);
  printf("A could act at the meeting before: %s; after: %s\n", enabled(A, va) ? "yes" : "no", enabled(A2, va) ? "yes" : "no");
  printf("the pair holds the joint route: %s %s\n", enabled(A2, term_string(ta, 64)) ? "yes" : "no", enabled(B2, term_string(ta, 64)) ? "yes" : "no");
  printf("τ: "); for (uint32_t i = 0; i < tau.n; i++) printf("%s%s%s@%u", i ? " " : "", tau.rev[i] ? "~" : "", RULE_NAME[tau.rule[i]], tau.node[i]); printf("\n");
  return 0;
}
static void load_next_to_exe(const char *exe, const char *name) {
  char pre[4096]; const char *slash = strrchr(exe, '/');
  snprintf(pre, sizeof pre, "%.*s%s%s", slash ? (int)(slash - exe) : 1, slash ? exe : ".", "/", name);
  read_file(pre);
}
int main(int argc, char **argv) {
  { struct rlimit rl; if (!getrlimit(RLIMIT_STACK, &rl)) { rl.rlim_cur = rl.rlim_max == RLIM_INFINITY ? (rlim_t)4 << 30 : rl.rlim_max; setrlimit(RLIMIT_STACK, &rl); } }   /* deep terms recurse deep */
  sched_init();
  if (argc < 3) { fprintf(stderr, "usage: hyper run FILE [DEF] | hyper bend FILE | hyper check FILE | hyper interact FILE [DEF] | hyper census FILE MAP DOM COD | hyper meet FILE A B\n"); return 1; }
  bool bend = !strcmp(argv[1], "bend") || !strcmp(argv[1], "check");
  bool inter = !strcmp(argv[1], "interact");
  if (inter) bend = true;                                /* the dialect's rows are loaded; presentation follows the entry's namespace */
  load_next_to_exe(argv[0], "prelude.hyper");            /* the Kan rule rows, next to the executable */
  if (bend) load_next_to_exe(argv[0], "bend.hyper");     /* the Bend2 dialect's rows */
  read_file(argv[2]);
  load_prelude();
  if (!strcmp(argv[1], "check")) return check_book("b/") ? 1 : 0;
  if (!strcmp(argv[1], "meet")) { if (argc < 5) { fprintf(stderr, "usage: hyper meet FILE A B\n"); return 1; } return meet(argv[3], argv[4]); }
  if (!strcmp(argv[1], "census")) { if (argc < 6) { fprintf(stderr, "usage: hyper census FILE MAP DOM COD\n"); return 1; } return census(argv[3], argv[4], argv[5]); }
  if (inter) { const char *e = argc > 3 ? argv[3] : (book_find("b/main") >= 0 ? "b/main" : "main"); return interact(e, !strncmp(e, "b/", 2)); }
  const char *entry = argc > 3 ? argv[3] : (bend ? "b/main" : "main");
  int id = book_find(entry); if (id < 0) { fprintf(stderr, "hyper: no %s\n", entry); return 1; }
  Term r = run_def((uint32_t)id);
  if (bend) { collapse_print(r); fprintf(stderr, "- Itrs: %llu\n- Words: %u\n", (unsigned long long)ITRS, (unsigned)HEAP_LEN); if (getenv("HYPER_CENSUS")) print_census(); return 0; }
  print_term(r, 64); printf("\n");
  printf("- Itrs: %llu\n- Words: %u\n", (unsigned long long)ITRS, (unsigned)HEAP_LEN);
  if (getenv("HYPER_CENSUS")) print_census();
  if (getenv("HYPER_TRACE")) { printf("- Trace: "); print_trace(0); }
  return 0;
}
