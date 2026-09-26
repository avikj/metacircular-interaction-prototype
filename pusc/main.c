/* pusc — main.c: run | interact | check (MAP.md §5). */
#include "cell.h"
#include <stdio.h>
#include <string.h>
void read_file(const char *path);
int check_book(const char *prefix);
static void load_next_to_exe(const char *exe, const char *name) {
  char pre[4096]; const char *slash = strrchr(exe, '/');
  snprintf(pre, sizeof pre, "%.*s%s%s", slash ? (int)(slash - exe) : 1, slash ? exe : ".", "/", name);
  read_file(pre);
}
int main(int argc, char **argv) {
  if (argc < 3) { fprintf(stderr, "usage: pusc run FILE [DEF] | pusc bend FILE | pusc check FILE\n"); return 1; }
  bool bend = !strcmp(argv[1], "bend") || !strcmp(argv[1], "check");
  load_next_to_exe(argv[0], "prelude.pusc");            /* the Kan rule rows, next to the executable */
  if (bend) load_next_to_exe(argv[0], "bend.pusc");     /* the Bend2 dialect's rows */
  read_file(argv[2]);
  load_prelude();
  if (!strcmp(argv[1], "check")) return check_book("b/") ? 1 : 0;
  const char *entry = argc > 3 ? argv[3] : (bend ? "b/main" : "main");
  int id = book_find(entry); if (id < 0) { fprintf(stderr, "pusc: no %s\n", entry); return 1; }
  Term r = run_def((uint32_t)id);
  if (bend) { collapse_print(r); fprintf(stderr, "- Itrs: %llu\n", (unsigned long long)ITRS); return 0; }
  print_term(r, 64); printf("\n");
  printf("- Itrs: %llu\n", (unsigned long long)ITRS);
  return 0;
}
