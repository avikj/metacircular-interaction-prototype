# Hostile audit: first strict typed-boundary separation

The causal-memory linear cut theorem and exact gluing-defect identity survive.
The first two spectrum coordinates separate on the dimension-minimal matrix

`S=((0,0,1,1),(1,0,0,1),(1,1,0,0),(0,1,1,0))`.

Its ordinary rank is three. The positive positions `(1,3),(2,4),(3,1),(4,2)`
form a fooling set, forcing four nonnegative rank-one summands, so its
nonnegative rank is four. An exact certificate checker and hostile cases are
now in `machinery/causal_memory.py`; nine focused tests pass.

The existing aligned/orthogonal gluing control has a second consequence: all
components have `(rank,rank_+)=(1,1)`, but their composites have `(1,1)` or
`(0,0)`. Scalar typed spectra cannot compose without boundary alignment. Keep
the identified intermediate boundary or factor maps. The CP coordinate remains
undefined and no theorem about it is promoted by this audit.
