# Canonical consequences do not determine future execution

**Status:** safe-Agda theorem and extracted control.

`ConsequenceFiber.agda` separates a canonical output `o : O` from its
proof-relevant derivation fiber `Fiber o`.  Forgetting the fiber is a lawful
projection, but it is not a sufficient machine state when later operations may
consume derivational structure.

The executable instance deliberately makes the consequence contractible:
`LeastThree` has one constructor, and `leastThree-contractible` proves every
output equals it.  Its fiber nevertheless has two disjoint constructors:

- `replayRoute` retains the bounded minimization derivation with exact budget
  six;
- `installedRoute` retains that derivation plus a proved reusable transport
  whose result is three.

`replay≠installed` proves these are distinct fiber points.  Both machine
states have canonical output `3`, and their next transformations again return
`3`.  But the replay fiber lawfully re-executes the bounded route at cost six,
while the installed fiber invokes the retained transport at cost one.
`installed-strictly-cheaper` and `capabilities-differ` are checked.

The extracted runtime returns:

```text
same consequence, distinct fibers: outputs=3/3 next-values=3/3 costs=6/1
```

The distinction is not that one proof makes the theorem more true.  It is that
one derivation carries a reusable map absent from the other current state.
Future discovery may construct the map for the replay state too; until then,
silently quotienting both states to `3` destroys a real executable capability.

This is the precise machine reading of consequence-fiber separation:

\[
\boxed{
\text{canonical theorem value may be contractible, while its derivation fiber
controls the next lawful path and cost.}
}
\]

No claim is made that arbitrary proof terms should always remain distinct.
Only structure consumed by declared future transformations is retained.
