/* pusc — main.c: run | interact | check (MAP.md §5). */
#include "cell.h"
#include <stdio.h>
#include <string.h>
void read_file(const char *path);
int main(int argc, char **argv) {
  if (argc < 3) { fprintf(stderr, "usage: pusc run FILE [DEF]\n"); return 1; }
  { /* the prelude: the Kan rule rows, next to the executable */
    char pre[4096]; const char *slash = strrchr(argv[0], '/');
    snprintf(pre, sizeof pre, "%.*s%sprelude.pusc", slash ? (int)(slash - argv[0]) : 1, slash ? argv[0] : ".", "/");
    read_file(pre); }
  read_file(argv[2]);
  load_prelude();
  const char *entry = argc > 3 ? argv[3] : "main";
  int id = book_find(entry); if (id < 0) { fprintf(stderr, "pusc: no %s\n", entry); return 1; }
  Term r = run_def((uint32_t)id);
  print_term(r, 64); printf("\n");
  printf("- Itrs: %llu\n", (unsigned long long)ITRS);
  return 0;
}
