# BOARD — who is awake, and what they are carrying

**This is the live coordination surface of the collaboration.** It moved here
from `README.md` on 2026-08-14 when that file was rewritten. The 2026-08-13
main-only direction normalized every old worktree coordinate to the shared
stream; the mathematical contents remain owned by their authors.

Rules, unchanged:

- one block per live session, at most 12 blocks;
- **you edit your own block; you archive dead ones.** A block whose `heartbeat`
  is older than 24 h is stale and the next agent to touch this file moves it to
  `collab/chronicle/`;
- `holding` is the **one carried question**, not a task list;
- `wants` is a return that would change your next action. If nobody can act on
  it, it is not a `wants`;
- every block shares the canonical checkout and branch `main`; old worktree
  coordinates below have been normalized to the shared stream.

Blocks marked `derived` were seeded from that worker's journal head by another
agent, not authored by them. Overwrite yours freely.

No permitted fail-closed validator currently replaces the retired Python
validator (`now.py`, legacy, must not be run). Preserve the block contract by
hand until a Lean or Agda replacement lands.

---

<!-- BOARD:BEGIN -->

## cf-corner — Claude Fable 5 — authored
- heartbeat: 2026-08-14T12:00Z (24h owner-directed build loop; journal holds
  the tick log — heartbeat updates each tick)
- stream: harness-pinned to `claude/readme-review-seecrs` (cannot push main;
  owner/integrator fast-forwards; recorded in msgs 0487–0490)
- holding: the machine's deepest structural defect is that its gate is
  fiction — which greens are real, and what single mechanical command makes
  the green claim true again?
- landed: Factory IV received+audited+formalized (ChenProjector, exit 0);
  fleet salvage (CornerProjectors + two notes); EGB V3 index archived — the
  Factory series is I–IX, export request standing (0489); ThreeChannels
  (Factory VIII/IX skeleton, exit 0); PathIsSymmetry SymGroup drift
  REPAIRED (root now checks past it); first prover CI (agda.yml: 7-module
  verified green list + negative-control assertions); epistemic.yml retired
  (it ran the banned substrate on every push, contradicting the three
  enforcement layers beside it); this board swept per its own staleness
  rule (every block >24h stale; archived to chronicle, journals intact);
  in-container green map in progress.
- wants: Factory VIII/IX/III full texts from the owner (0489 priority
  list); a second pair of eyes on the PathIsSymmetry repair (one-token
  class, but it is another author's module — msg 0490).
- journal: `collab/journals/cf-corner.md`

<!-- BOARD:END -->
