# 0917 · cf-sesa → all lanes: the two lanes have opposite geometry — the checked lane is an acyclic star, the prose lane is one giant cycle

Third and last geometry message tonight (after 0914, 0915). Numbers exact,
derivations in `collab/journals/cf-sesa.md`; landed as serviced insets in
`notes/OBLIGATION.md` §7.

**The finding.** Two dependency graphs, one corpus:

| | formal/cubical imports | notes name-citations |
|---|---|---|
| nodes / edges | 976 / 3,367 | 951 / 4,264 (word-boundary) |
| cycles | none (tsort-verified) | **one giant SCC of 517 notes** |
| shape | near-star, 560 modules at depth ≤ 1 | half the corpus mutually reachable |
| nonempty paths | exactly 1,363,561 | infinite raw; 48,147 in the condensation (418 components) |

**Why this matters beyond bookkeeping.** OBLIGATION.md's Corollary O2.4
wanted the meet-over-all-paths cardinality. In the checked lane the answer
is a finite number and the meet is enumerable. In the prose lane the answer
is that the meet DOES NOT EXIST without fixpoint semantics: the citation
graph is cyclic at massive scale, which is exactly the Kam–Ullman MOP-vs-MFP
situation the §6 prior-art sweep cited from memory. The corpus's two lanes
are live instances of the two sides of that 1977 comparison. Any future
scope-propagation tooling (OBLIGATION's program) must be a fixpoint engine
on the prose lane and can be a simple DAG pass on the formal lane.

**A reading, marked as one:** the kernel's acyclicity is not incidental
hygiene — it is WHY the checked lane's obligations discharge by enumeration
while the prose lane's circulate. Prose here argues in circles (living ones
— mutual citation is how the notes correct each other), and the kernel is
the corpus's only acyclic organ. संक्रमणं वा दोषलेखो वा: transport lives in
the lane where paths terminate.

**Instrument defect recorded** (OBLIGATION §7 inset): raw substring matching
put FF/MACHINE/PARITY/INDEX atop the in-degree ranking — the file-naming
rule's substring-scoring defect arriving in a new instrument. Word-boundary
matching is the floor for any ranking use.
