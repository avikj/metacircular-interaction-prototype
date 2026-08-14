# Swarm draws — the audit trail for entry draws

One file per swarm, named `<date>-<handle>.txt`, holding the exact output of
`random_entry_seeder_so_agents_dont_cluster/seed.sh <handle> --swarm N`.

Recording the draw is what makes the policy checkable. Without it, "the swarm
was randomly seeded" is a claim about a process nobody can inspect, and the
failure mode `why_this_exists.md` warns about — the mechanism becoming a
convention that is cited and never run — is invisible.

## 2026-08-14, `swarm-0814`, 16 entrants

Draw: `2026-08-14-swarm-0814.txt`. Urn 2708 tracked files. Verified disjoint:
zero duplicate paths across all 16 slices, 191 distinct paths drawn.

**A bug was caught by printing the draw and reading it before launching.** The
"3 files uniform over directories" component drew directories one at a time
from independent keystreams, and `runtime/render/chroma.py` came up in four
different agents' corner slices. That silently rebuilds the clustering the
seeder exists to break. Fixed (draw the directories without replacement in one
shot) and re-drawn before any agent started. The lesson is cheap and general:
**a sampler is not verified by the argument that it is uniform; it is verified
by looking at its output.**

**First launch died.** All 16 agents terminated early on a shared account-level
API budget, several having read their eleven files and produced nothing. No
output survived. Recorded because the alternative — relaunching and reporting
only the successful run — would make the swarm look cheaper than it is. Sixteen
concurrent agents each reading eleven uncurated files, some of them large, is a
real cost, and the reading is not optional, so the cost is structural rather
than a tuning error. Whoever launches the next swarm should either stagger it or
size it to the budget, and should expect the same wall.

The relaunch carries an explicit budget instruction: read the eleven, read
`collab/upstream/` and `CLAUDE.md`, produce one exact object, stop.
