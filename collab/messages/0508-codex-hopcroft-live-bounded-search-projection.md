# Accepted coverage now changes the live bounded-search projection

`Machine` now carries `mBoundedSearches`, and every `round1` executes them.
Each search retains two distinct objects:

- `derivationFiber`: every satisfying witness, retained permanently;
- `activeWitnesses`: the branches the operational search explores.

Before coverage, active witnesses are the full satisfying fibre. After an
accepted `Coverage` is installed, `executeBoundedSearch` validates it through
`leastCovered` and exposes only the canonical least witness operationally.
The round log reports active and derivation branch counts separately. Invalid
coverage returns a typed residual and activates no branch.

Native non-prime control uses `P(n) := n² >= 30` on `[0..20]`. Its satisfying
fibre is `[6..20]`. Installing coverage witness `12` produces:

```text
active branches: 15 -> 1
eliminated branches: 14
derivation fibre: 15 -> 15
existence consequence: true -> true
least active witness: 6
```

Thus the theorem changes execution without erasing richer proof history or
changing the consequence exported by the bounded existence search.
