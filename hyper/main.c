/* hyper — main.c: run | bend | check | interact | census.
 *
 * The machine is Fibre.CorpusInteraction (fibre/src/Fibre/CorpusInteraction.agda): a state is a typed
 * point (A, a) : Σ A. A; a question is a typed map (B, f) out of the current type; the answer is the
 * point (B, f a); the receipt is the path target s q ≡ s', refl at the canonical step; and the process
 * continues at the new point (ISC, react).  `run` is the trivial-query case: no question, the point
 * reduced to its normal form.  `interact` reads questions from the world, one per line, each a term of
 * the kernel's text; a reduction that stalls at an ASK cell prints the question and resumes on the
 * world's answer.  The retained point is the trace (Fibre.Trace): the source, never left behind. */
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

static char *read_line(FILE *in) {
  static char buf[1 << 16]; if (!fgets(buf, sizeof buf, in)) return 0;
  size_t n = strlen(buf); while (n && (buf[n-1] == '\n' || buf[n-1] == '\r')) buf[--n] = 0;
  return buf;
}
static void show(Term v, bool bend) { if (bend) collapse_print(v); else { print_term(v, 64); printf("\n"); } fflush(stdout); }
/* an ASK cell is a question the point asks the world; the world's line is its answer */
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
/* react: the point presents itself along each question q of the world; the new state is (q a, (a, refl)) */
static int interact(const char *entry, bool bend) {
  int id = book_find(entry); if (id < 0) { fprintf(stderr, "hyper: no %s\n", entry); return 1; }
  Term point = answer_asks(mk(T_REF, 0, (uint32_t)id), bend);
  show(point, bend);
  for (char *line; (line = read_line(stdin)); ) {
    if (!*line || *line == ';') continue;
    int q = read_question(line);
    Term qa = answer_asks(app2(mk(T_REF, 0, (uint32_t)q), point), bend);
    show(qa, bend);
    point = node2(T_CTR, ctr_ext(C_PAIR, 2), qa, node2(T_CTR, ctr_ext(C_PAIR, 2), point, mk(T_CTR, ctr_ext(C_REFL, 0), 1)));
  }
  return 0;
}
/* गणना f : (b : B) → देश f b  (fibre/src/Fibre/WholePartialDesa_…agda:87–94): the census of a question, pointwise
   over the codomain.  The domain and codomain are given as superpositions of their points; the fibre शेष f b is
   the set of domain points whose value is b, and its census is नास्ति (no point), सकलादेश (one point), or
   विकलादेश (two or more distinct points, both shown).  This is what a computation costs (MAP §3). */
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
static void load_next_to_exe(const char *exe, const char *name) {
  char pre[4096]; const char *slash = strrchr(exe, '/');
  snprintf(pre, sizeof pre, "%.*s%s%s", slash ? (int)(slash - exe) : 1, slash ? exe : ".", "/", name);
  read_file(pre);
}
int main(int argc, char **argv) {
  { struct rlimit rl; if (!getrlimit(RLIMIT_STACK, &rl)) { rl.rlim_cur = rl.rlim_max == RLIM_INFINITY ? (rlim_t)4 << 30 : rl.rlim_max; setrlimit(RLIMIT_STACK, &rl); } }   /* deep terms recurse deep */
  if (argc < 3) { fprintf(stderr, "usage: hyper run FILE [DEF] | hyper bend FILE | hyper check FILE | hyper interact FILE [DEF] | hyper census FILE MAP DOM COD\n"); return 1; }
  bool bend = !strcmp(argv[1], "bend") || !strcmp(argv[1], "check");
  bool inter = !strcmp(argv[1], "interact");
  if (inter) bend = true;                                /* the dialect's rows are loaded; presentation follows the entry's namespace */
  load_next_to_exe(argv[0], "prelude.hyper");            /* the Kan rows, next to the executable */
  if (bend) load_next_to_exe(argv[0], "bend.hyper");     /* the Bend2 dialect's rows */
  read_file(argv[2]);
  load_prelude();
  if (!strcmp(argv[1], "check")) return check_book("b/") ? 1 : 0;
  if (!strcmp(argv[1], "census")) { if (argc < 6) { fprintf(stderr, "usage: hyper census FILE MAP DOM COD\n"); return 1; } return census(argv[3], argv[4], argv[5]); }
  if (inter) { const char *e = argc > 3 ? argv[3] : (book_find("b/main") >= 0 ? "b/main" : "main"); return interact(e, !strncmp(e, "b/", 2)); }
  const char *entry = argc > 3 ? argv[3] : (bend ? "b/main" : "main");
  int id = book_find(entry); if (id < 0) { fprintf(stderr, "hyper: no %s\n", entry); return 1; }
  show(run_def((uint32_t)id), bend);
  return 0;
}
