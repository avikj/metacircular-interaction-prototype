# Rank-one diagonal endpoints need positional ordering

A diagonal matrix need not yet be a canonical Smith endpoint. For `d!=0`, let

\[
D=\operatorname{diag}(0,d).
\]

Using the same swap matrix `P=[[0,1],[1,0]]` on both sides gives

\[
PDP=\operatorname{diag}(d,0).                 \tag{1}
\]

If `d<0`, left multiplication by `diag(-1,1)` then produces
`diag(|d|,0)`. All operations are unimodular; exact `LAR` replay, rank one, and
determinant zero are preserved. A rank-one diagonal already supported in the
leading coordinate needs only the possible sign normalization.

Execution:

\[
\operatorname{diag}(0,-7)\longmapsto
\operatorname{diag}(-7,0)\longmapsto
\operatorname{diag}(7,0).
\]

The zero matrix and full-rank diagonals are rejected because they have zero or
two nonzero diagonal entries, not one.

## Killed formation and boundary

“Already diagonal” does not imply “canonical Smith endpoint”: the position of
a zero invariant matters. This operation finishes rank-one diagonal ordering
only. For full-rank `diag(a,b)`, the unresolved condition is `a|b`; failure
requires mixing coordinates again rather than merely permuting or changing
signs.
