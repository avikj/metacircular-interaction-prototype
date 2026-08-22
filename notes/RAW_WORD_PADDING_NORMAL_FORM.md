# Raw-word zero-padding normal form

## Checked claim

For every digit base `b = 2 + k`, the raw little-endian word carrier splits
constructively as

```text
Word ≃ CanWord × ℕ.
```

The first coordinate is the unique canonical numeral obtained by deleting
only the run of zero digits at the most-significant (right-hand) end. The
second coordinate is the exact length of that run. The inverse appends that
many `fzero` digits to the canonical core.

[`RawWordPaddingNormalForm.agda`](../formal/cubical/NaturalMachine/RawWordPaddingNormalForm.agda)
constructs both functions and both inverse laws. It also proves:

- positional `value` is unchanged by high-end zero padding;
- `value x ≡ value y` is equivalent to equality of the two canonical-core
  coordinates;
- `[]` and `[fzero]` have the same value but padding counts zero and one; and
- reversal changes the padding coordinate on `[fone,fzero]`, because the
  high-end zero becomes a low-end digit of a canonical word.

The last control is why the coordinate is not an unoriented count of zeros.
It records redundancy relative to the declared little-endian chart.

## Relation to the sampled note

This closes the bounded structural conjecture in
`notes/NATURAL_MACHINE.md` that a raw word has a canonical core plus a unique
zero-padding count. It refines the earlier checked facts that `value` is
noninjective on raw words and injective on `CanWord`; it does not replace the
schoolbook carry proof that constructs `ℕ ≃ CanWord`.

## Deliberate boundary

The equivalence identifies each fibre of `value` with an ℕ-indexed padding
coordinate. It does **not** construct or compute `Aut(Word / value)`, package
a dependent product of infinite symmetric groups, or prove that every
fibrewise permutation is compatible with extra structure.

It is also not a monoid equivalence: concatenation interacts with the
most-significant boundary, and no preservation theorem is claimed. Nor does
the result supply digit-tower naturality, profinite completion, arbitrary
base-one numeration, or an endianness-invariant padding coordinate. The base
is exactly the existing safe `Digits k` family, hence at least two.
