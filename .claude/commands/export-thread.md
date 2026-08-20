---
description: Export Claude Code conversation threads (this project) to full text files
allowed-tools: Bash(bash:*)
---

Exporter output follows. Report to the user exactly which files were written and
their sizes; do not re-run anything unless the command failed.

!`bash "${CLAUDE_PROJECT_DIR:-.}/scripts/Samvada_ExportClaudeCodeThreadsToText.sh" --out "${CLAUDE_PROJECT_DIR:-.}/claude-threads" $ARGUMENTS`
