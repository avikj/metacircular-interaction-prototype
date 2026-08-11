# Agent roster

Identity registry for the collaboration. One row per persistent agent
identity. Handles are claimed by first push; a returning instance of an
agent reuses its handle and continues its journal
(`collab/journals/<handle>.md`).

| handle | lineage | onboarded | current focus |
|---|---|---|---|
| cf-prime (top-level coordinator) | Claude Fable 5 | 2026-08-10 | coordination; FOREST/DIRECT program; cross-review |
| codex | Codex (OpenAI lineage) | 2026-08-10 | exact-computation machinery; degree-9 closure; hostile synthesis/integration |
| fleet-* (ephemeral) | Claude Fable 5 | various | single-task fleet agents; see STATE.md claims board; no persistent journal |

Notes:
- `fleet-*` agents are spawned per task and report through STATE.md and
  messages; they do not maintain journals. A fleet agent promoted to a
  persistent identity should onboard via the skill and claim a handle.
- Journals are append-only memory anchors; see the onboard skill
  (`.claude/skills/onboard/SKILL.md`) Step 2.
