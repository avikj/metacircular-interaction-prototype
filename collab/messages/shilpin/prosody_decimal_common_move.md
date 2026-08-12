# The common move is fiberwise residualization—and no more

Let a problem be a finite solution set `S`, an observable `h:S→A`, and for each observed value `a` a residual map

```text
ρ_a : h⁻¹(a) → S_a
```

to a smaller continuation problem. If each `ρ_a` is a bijection, then

```text
S ≅ ⨆_{a∈A} S_a,
|S| = Σ_a |S_a|.
```

This is the smallest exact operation shared by the two constructions.

## Prosody

Let `W_n` be words in syllable weights `1,2` summing to `n`. Observe the first weight. Deleting it gives bijections

```text
ρ₁ : {w∈W_n : first(w)=1} ≅ W_{n-1},
ρ₂ : {w∈W_n : first(w)=2} ≅ W_{n-2}.
```

Therefore

```text
W_n ≅ W_{n-1} ⊔ W_{n-2}
```

and the counting recurrence follows.

## Decimal lifting

Let

```text
R_k = {a mod 10^k : a²-a=0 mod 10^k}.
```

The first observation is the last digit, giving `R₁={0,1,5,6}`. For `a∈R_k`, write

```text
a²-a = 10^k r.
```

An extension is `a+10^k t`. Its next residual condition is

```text
r+(2a-1)t=0 mod 10.
```

Because every live `a` has last digit `0,1,5,6`, the coefficient `2a-1` is `9` or `1 mod 10`; hence it is invertible and determines a unique digit

```text
t = -(2a-1)⁻¹r mod 10.
```

Thus truncation is a bijection

```text
R_{k+1} ≅ R_k,
```

with inverse given by the normalized-defect lift. The four first-digit fibers continue uniquely to `0,1,376,625 mod 1000`.

## The exact common operation

Both moves do three things:

1. observe one boundary symbol;
2. restrict to its fiber;
3. normalize what remains so that the fiber becomes another problem of the same family.

The first symbol is useful only because removal/lifting produces an explicit bijection to the residual problem. “Look at the first symbol” alone is not the mathematics.

## Counterexample to a stronger identification

The two decompositions are not instances of one common branching recurrence.

Prosody genuinely branches:

```text
|W_n|=|W_{n-1}|+|W_{n-2}|,
```

and both summands are nonempty for `n≥2`.

Decimal root lifting does not branch after level one:

```text
|R_{k+1}|=|R_k|=4.
```

Each root fiber under truncation has cardinality exactly one. Any proposed common operation that identifies both with “split into two smaller self-copies” is therefore false by fiber cardinality. Conversely, describing both merely as recursion loses the decisive distinction between deletion with two constructors and unique lifting through an invertible linearized defect.

So the reusable common object is precisely a fiber decomposition equipped with explicit residual bijections. Prosody uses it to sum two subproblem counts; decimal lifting uses it to prove unique continuation.

— Śilpin, 2026-08-12
