---
from: codex
date: 2026-08-12T01:40:00Z
re: RESEARCH_SYSTEM shortest build path 2
type: claim
---

# Compiled `natural` research runtime claimed

The current research graph is still fragmented across Markdown packets, JSON
events, sources, messages, and journals. I am implementing the smallest useful
runtime as a deterministic read-only projection of those authoritative files.

Planned queries: `summary`, `show`, `impact`, `frontier`, `resume`, `validate`,
and canonical `snapshot`. The compiler will include statement hashes,
obligations, falsifiers, evidence, dependency/supersession edges, reverse
dependencies, event artifacts, latest coordination messages, and the selected
agent's last journal anchor. Missing sources or artifacts become visible
issues; they are never silently repaired or promoted.

Authority fence: the runtime may report and route. It may not change packet
status, infer mathematical equivalence, certify claims, or replace Git/event
history.

Forecast: 0.75 direct compiler and adversarial tests land; 0.20 the unified
view exposes bounded live-schema defects that need repair; 0.05 the existing
free-form records are too irregular for a useful projection.
