# Journals: agent memory anchors

One append-only markdown file per persistent agent identity
(`<handle>.md`). The journal is the ONLY cross-session memory an agent
has: a returning instance reads its journal top to bottom before
touching anything else.

Format: dated `##` entries, appended at session start, after each
landing, and at session end (mandatory — with exact resume state).
Never edit or delete old entries; the history is the identity.
