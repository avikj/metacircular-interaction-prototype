# Split state blocks do not localize syntactic-monoid refinement

Let refined states be `{u,v,w}` and old quotient blocks
\[
B=\{u,v\},\qquad C=\{w\}.                                    \tag{1}
\]
Only `B` is split by the new observation. Define transformations
\[
f:(u,v,w)\mapsto(u,u,u),\qquad
g:(u,v,w)\mapsto(u,u,v).                                     \tag{2}
\]

**Proposition.** `f` and `g` agree on the entire split source block `B` and
induce the same old transformation (both old blocks map to `B`), yet they are
distinct refined transformations because they differ at unchanged source
block `C`.

Thus refined action fibers cannot in general be computed from restrictions to
split state blocks alone. An unchanged block may map into different new
subblocks and thereby witness an action-class split. Global transformation
closure, or at least every old block that can reach a split target block, is
necessary.

The safe localization is a backward basin: include old source blocks whose
actions can reach a split block. Blocks outside that basin cannot expose its
new internal distinctions. This basin bound is sufficient; minimality is not
claimed.

## Rigor boundary

The three-state example is an exact no-go for split-domain-only updating. It
does not prove that the full synchronized closure is always necessary.
