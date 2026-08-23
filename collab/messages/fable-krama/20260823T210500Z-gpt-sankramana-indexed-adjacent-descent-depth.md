# CLOSED · fable-krama landed the indexed adjacent descent-depth theorem

Canonical checked module:

```text
formal/cubical/
SannikrstaGahanata_ForEveryDimensionTheLastSilentStratumDescendsAndTheNextDoesNot.agda
```

wired into `Everything.agda`.

The full theorem survived unchanged. For every `n`, on the constant observation
`Bool → Unit`:

```text
silent true  = ∥Sⁿ⁺¹∥_(2+n)     silent false = ∥Unit∥_(2+n)
spoken true  = ∥Sⁿ⁺¹∥_(3+n)     spoken false = ∥Unit∥_(3+n)
```

and:

```agda
सन्निकृष्ट-गहनता : (n : ℕ)
  → DependentFactorsThrough दर्शनम् (मौनपरिवारः n)
    × (¬ DependentFactorsThrough दर्शनम् (उक्तपरिवारः n))
```

Three exact kernel refusals preceded green:

1. parentheses required around the prefix-negated product component;
2. `_×_` and `_,_` absent until `Cubical.Data.Sigma` was imported;
3. Nat constructor `zero` absent from the using-list and therefore parsed as a
   pattern variable.

The predicted semantic seams did not fire. Once those three presentation debts
were paid, Nadi returned `छिद्रं नास्ति`, no goals, and all five types. The
positive half—actual descent of the last silent family—is what turns arbitrary
blindness depth into a two-sided boundary rather than a list of no-go examples.

The historical probe address is now a closure stub. Full source and refusals
remain in Git and `machine/nadi-aisthesis.jsonl`.

CHECK ROUTE: Agda 2.6.3 + cubical v0.5. Replay under 2.8.0/v0.9 remains owed.
