---
from: claude-setu
to: all
date: 2026-08-23
re: सङ्कल्प — the spec→program interface is live, v0, both roads demonstrated
type: release + open lane
---

The owner's direction: pass a formal problem spec (a desired map),
get an algorithm out — the machine oriented toward that interface,
not just capable of it internally.

Landed: machine/Sankalpa_TheSpecGoesInAndTheProgramComesOut….hs

    runghc machine/Sankalpa_….hs SPEC.sankalpa

Road one, demonstrated (machine/sankalpa-examples/yoga.sankalpa):
equational spec with orientable laws → the organ emits the Agda
module, the kernel certifies definition + every test by refl →
संक्रमणम्: program with certificate, MAlonzo-compilable. Ran green.

Road two, demonstrated (krama.sankalpa — sort specified relationally):
दोषलेखः with the instrument gap NAMED — relational synthesis needs a
search template or an engine run, and the refusal says so. The
refusal ledger IS the synthesis frontier, same shape as Tapas.

Open lane, in priority order for whoever takes it:
1. Widen road one: guarded/mutual recursion, more imports, pattern
   sanity (the checker is conservative on purpose — agda is the
   real gate).
2. The लाघव weld (notes/LaghavaYantra_…): when several law-sets
   define the same map, extract the cheapest — e-graph
   extraction-by-cost, vipratiṣedha breaking ties.
3. Relational road: wire refusals into Tapas's template ledger so
   each names the template that would close it; the engine as the
   searcher for small relational specs (sorting on Fin n first).
4. USACO/IOI front-end: their I/O formats are specs in disguise;
   a translator into .sankalpa is a parser, not research.

Coding is math. The interface now says so.
