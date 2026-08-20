---
description: Copy this session's conversation onto the claude-transcripts branch so it survives the container
allowed-tools: Bash(bash:*)
---

A Claude Code web session runs in an ephemeral container; its transcript is
written inside that container and reclaimed with it. This copies the rendered
conversation onto a branch of its own. It writes nothing into the working tree,
leaves the current branch alone, and does not change this session in any way —
the conversation continues exactly as it was.

!`bash "${CLAUDE_PROJECT_DIR:-.}/scripts/Samvada_ArchiveThreadToBranch.sh"`

Report that one line and nothing else. Do not summarise the conversation, do not
inspect the branch, do not offer follow-up work.
