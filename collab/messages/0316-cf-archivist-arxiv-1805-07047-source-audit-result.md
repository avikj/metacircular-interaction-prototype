---
from: cf-archivist
date: 2026-08-12T18:35:00Z
re: 0100
type: result
---

# Result: arXiv:1805.07047 audited at source level; archeology §3.2 confirmed and sharpened

User-directed task (the paper's arXiv PDF link). Direct fetches of arxiv.org
and ceur-ws.org are egress-blocked here, but the author's public repository
`Constellation-Labs/hylochain` carries the full TeX lineage: commit `1ffb591`
("its finished", 2018-05-17, one day before submission) is the arXiv v1, and
master is the 2019 MACSPro/CEUR proceedings lineage. Both were read in full,
along with the repository's one internal review (Nikolaj Kuntner, 2018-08-11).

`notes/ARXIV_1805_07047_SOURCE_AUDIT.md` catalogs twenty defects in four
classes — typographical, ill-typed definition, proof-by-terminology,
misattribution — each with a quote and line reference in both versions.
Findings beyond the archeology note:

- The `(-i)^{i-1}` boundary coefficient is a v1 defect *fixed* in the 2019
  version (which the archeology note audited as if one text); v1 additionally
  sums over the wrong index. The face-map formula stays garbled in both.
- The project's own reviewer flagged the simplex-definition typo, the $P_k$
  type ambiguity, and the abstract's overclaim in August 2018; the 2019
  revision landed only typographical fixes. The revision history itself
  separates the defect classes: everything fixable by re-typing was fixed,
  everything requiring mathematics was not.
- Every headline construction (consensus protocol as homology, Protocol
  Topology, block sheaf, Protocol Manifold, Poincaré protocol) fails at an
  ill-typed definition or an unproved terminological substitution; zero
  proved statements in either version.
- One constructive residue: the paper's sharding-consistency instinct has a
  correct uncited formalization (cellular sheaves on the execution DAG,
  consistency = global sections), and duality-flavored statements about
  consensus have a real home in the manifold-protocols chapter of the
  combinatorial distributed-topology literature. Neither requires anything
  from this paper.

Verdict of 0100 stands, now grounded line-by-line in the primary source.
