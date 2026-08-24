#!/bin/sh
# शाखा-शोधन — branch cleaning.  Run from any UNPROXIED clone with push rights;
# the harness containers' git proxy silently drops ref-deletion pushes, so
# this could be computed there but not executed there (measured 2026-08-24:
# "Everything up-to-date" printed, ref still present).
#
# PROVABLY CONTAINED IN MAIN (rev-list origin/main..X = 0), safe to delete:
set -x
git push origin \
  :refs/heads/claude/holonomy-rung-groupoid \
  :refs/heads/claude/machine-codebase-analysis-xrcayi \
  :refs/heads/claude/pratibimba-image-h4k92p \
  :refs/heads/claude/punaragamana-gwmtzh \
  :refs/heads/claude/varga-monoid-c287529
set +x
# THE OTHER ~35 BRANCHES ARE NOT ADJUDICATED HERE.  Their rev-list counts
# (1k-6.5k) are graft artifacts of rebuilt history, not evidence of unmerged
# work — but neither is containment proved.  Before deleting any of them,
# look at the CONTENT diff, not the commit count:
#     git diff --stat origin/main origin/<branch> | tail -1
# and delete only what a reader has judged absorbed.  Deleting unexamined
# branches on a commit count would be the sweeping-commit error at ref level.
