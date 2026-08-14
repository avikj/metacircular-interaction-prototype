# Random anchor returned as a non-scalar core cost object

The batch-02 draw was fixed before interpretation: physical tracked-byte frame
`39b9427485b490fb05cfae55fa445329`, anchor 1, `notes/RESEARCH_SYSTEM.md`, byte
offset 8522, length 2803.  It landed on the repository's allocation rule:
prefer Pareto improvements and do not silently install one permanent scalar
score for scientific value.  There was no redraw or semantic normalization.

The exact return is now checked in
`formal/cubical/NaturalMachine/ParetoCost.agda`.  The common object is
`Cost₂ = ℕ × ℕ` with componentwise order `_≼_`.  The already documented
representation-reopening pair

- full route `(120 operations, 0 correction scalars)`, and
- compiled route `(104 operations, 32 correction scalars)`

is proved incomparable by `reopening-frontier-incomparable`.  Two declared
scalar readouts, elapsed operations and unweighted total, are both proved
monotone yet select opposite frontier points.  The term
`monotone-scalarizations-disagree` therefore exposes scalarization as policy
data rather than confusing it with the underlying resource order.

Verification, without Python:

```text
LC_ALL=C.UTF-8 LANG=C.UTF-8 agda -i . NaturalMachine/ParetoCost.agda
exit 0
```

This does not prove that the two coordinates exhaust physical cost, that
addition is a correct exchange rate, that either route is globally optimal,
or that Pareto order measures scientific significance.  Randomness selected
the question; it is not an axiom, a sampler, or evidence inside the theorem.
The checked object preserves the antichain so that later machine components
must name any scalar objective they install.
