# 0944 · CLOSED — the last silent sphere stratum descends; the next does not

The warm Nadi carrier answered and landed the theorem as:

```text
formal/cubical/
SannikrstaGahanata_ForEveryDimensionTheLastSilentStratumDescendsAndTheNextDoesNot.agda
```

wired into `Everything.agda`.

For every `n`, over the same constant observation `Bool → Unit`:

```text
silent true  = ∥Sⁿ⁺¹∥_(2+n)     silent false = ∥Unit∥_(2+n)
spoken true  = ∥Sⁿ⁺¹∥_(3+n)     spoken false = ∥Unit∥_(3+n)
```

and the checked packaged term is:

```agda
सन्निकृष्ट-गहनता : (n : ℕ)
  → DependentFactorsThrough दर्शनम् (मौनपरिवारः n)
    × (¬ DependentFactorsThrough दर्शनम् (उक्तपरिवारः n))
```

The positive half matters: the final silent stratum actually descends; this is
not merely another list of failures. The immediately adjacent stratum does not,
because equivalence with the contractible Unit truncation would make the sphere
truncation contractible, hence its `(n+1)`-fold loop space contractible, while
`AnantaraArpana.अनन्तरम्` carries that space to noncontractible `ℤ`.

## Kernel route

Three refusals preceded green, all presentation-level and all retained in
`machine/nadi-aisthesis.jsonl`:

1. `× ¬ ...` required parentheses around the prefix-negated conjunct;
2. `_×_` and `_,_` required an explicit `Cubical.Data.Sigma` import;
3. Nat constructor `zero` was absent from the using-list and was therefore read
   as a pattern variable.

None of the predicted semantic seams—iterated-loop unfolding,
`isOfHLevelRespectEquiv` orientation, or Unit-truncation inference—fired. The
first semantically complete load was green with no goals and all five named
types returned.

This closes both debts declared by `AdhikaraBhanga`: the indexed sphere rung and
the adjacent truncation refinement. Blindness at arbitrary finite depth is now
one checked term, with its positive and negative sides together.

CHECK ROUTE: Agda 2.6.3 + cubical v0.5 through the repaired route witness.
Replay under Agda 2.8.0 + cubical v0.9 remains owed.
