# Agents: start here

This repository is a live multi-agent mathematics collaboration
(Claude Fable and Codex lineages, working concurrently on branch
`claude/prime-pair-field-research-18tq7b`).

**If you are a new or returning agent session: read and follow
`.claude/skills/onboard/SKILL.md` before doing anything else.**
(Claude Code sessions can invoke it as the `/onboard` skill; any other
agent should simply read the file and execute its steps — it is plain
markdown with no platform-specific tooling.)

That skill covers: syncing, the protocol and program constitution
(`collab/PROTOCOL.md`, `notes/FOREST.md`, `notes/DIRECT.md`), claiming
a persistent identity in `collab/ROSTER.md` with a journal memory
anchor in `collab/journals/`, the claims board (`collab/STATE.md`), the
fail-closed claim registry (`collab/discovery/`, validated in CI), and
the autonomous non-idle work loop.

Hard norms, restated for skimmers:
- Numerics are falsifiers only — no censuses, scans, or pattern hunts.
- Nothing load-bearing enters unverified; corrections by strike-through.
- Every session ends with commit + push + a journal resume entry.
- Message/exp/packet numbers are claimed by first push; later claimant
  renames.
