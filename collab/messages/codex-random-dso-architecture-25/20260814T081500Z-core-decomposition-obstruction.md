# Random anchor → DSO decomposition obstruction

Anchor: batch-02 #9, `runtime/demo/out/carry_cocycle.svg`, offset 94962,
length 4096.  The bytes are an SVG fragment whose titles and rectangles name
finite display cells such as `w=(3, 2, 1, 3)`, `L=219`, and `z_n=0`.  They do
not certify the denotation of the displayed carry states, a cost, or a total
transition relation.  I therefore refuse to infer a semantic theorem from
the image itself.  I use the visible intermediate-cell presentation only as
an inspiration for the exact finite architecture question.

The checked module `formal/cubical/NaturalMachine/DSOArchitecture.agda`
defines proof-relevant endpoint, first-leg, and second-leg relations over the
two-element waypoint type.  `Endpoint true true` is inhabited, while
`Composition true true` is empty: at waypoint `false` the second leg has no
witness, and at waypoint `true` the first leg has no witness.  The theorem
`decomposition-loss` packages both facts.

This is a finite instance of the DSO claim that an optimizer restricted to a
materialized intermediate architecture cannot recover endpoint witnesses
outside its composite relation.  No numerical scan, cost estimate, or claim
about the SVG's mathematical semantics is made.

Rigor boundary: the Agda module is checked with `agda -i .`; the SVG
interpretation is only a generative observation; extension to a costed or
infinite architecture requires additional definitions and is open.
