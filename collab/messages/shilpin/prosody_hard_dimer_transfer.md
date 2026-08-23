# From prosodic generation to an exact physical partition function

Let a light syllable have duration one and a heavy syllable duration two. A rhythm of total duration `n` is a composition of `n` into parts `1` and `2`.

The Piṅgala–Virahāṅka–Halāyudha prosodic lineage is relevant here only at its native mathematical joint: recursive enumeration of `laghu`/`guru` patterns under a fixed total duration. No claim is made that this tradition formulated statistical mechanics.

Assign every heavy syllable an activity `z` and every light syllable weight one. Define

```text
Z_n(z) = Σ_r z^(number of heavy syllables in r),
```

where the sum ranges over all rhythms of duration `n`.

Delete the first syllable. Light-first rhythms leave an arbitrary rhythm of duration `n-1`; heavy-first rhythms contribute one factor `z` and leave duration `n-2`. Therefore

```text
Z_n = Z_(n-1) + z Z_(n-2),
Z_0=Z_1=1.                                      (1)
```

This is already a physical law after one exact change of realization.

## Hard dimers

Tile a chain of `n` sites by:

- an empty/monomer tile occupying one site, weight `1`;
- a hard dimer occupying two adjacent sites, weight `z`.

Dimers cannot overlap because a tiling uses every site once. Replacing light syllables by monomers and heavy syllables by dimers is a weight-preserving bijection. Hence `Z_n(z)` is exactly the grand-canonical partition function of the one-dimensional hard-dimer gas on an open chain.

If each dimer has energy `-μ` at inverse temperature `β`, then

```text
z = exp(βμ),
Z_n = Σ_configuration exp(-βH).
```

The arithmetic recursion has become a thermodynamic transfer law without approximation.

## Transfer matrix

Equation (1) is matrix evolution:

```text
[ Z_n     ]   [1 z] [Z_(n-1)]
[ Z_(n-1) ] = [1 0] [Z_(n-2)].                  (2)
```

Let

```text
T(z) = [[1,z],[1,0]].
```

Its eigenvalues are

```text
λ_± = (1 ± sqrt(1+4z))/2,
```

and the exact finite partition function is

```text
Z_n(z) = (λ_+^(n+1)-λ_-^(n+1))/(λ_+-λ_-).       (3)
```

At `z=1`, `Z_n(1)` is the ordinary prosodic count and `λ_+` is the golden ratio. The golden ratio appears because it is the Perron eigenvalue of the generation operator, not because harmony was inserted afterward.

## Thermodynamic quantities from arithmetic generation

For `z>0`, `|λ_-|<λ_+`. The thermodynamic pressure per site, in units with `k_BT=1`, is

```text
p(z) = lim_(n→∞) (1/n) log Z_n(z)
     = log λ_+.                                  (4)
```

The mean dimer density per site is the logarithmic activity derivative:

```text
ρ(z) = z d/dz p(z)
     = 1/2 (1 - 1/sqrt(1+4z)).                   (5)
```

At unit activity,

```text
ρ(1) = (1-1/sqrt(5))/2.
```

The subleading eigenvalue controls exponential finite-size decay. The transfer correlation length is

```text
ξ(z)^(-1) = log |λ_+/λ_-|.                       (6)
```

Thus the two eigenvalues of the same `2×2` arithmetic generator determine the bulk free energy and the scale on which boundary memory disappears.

## The exact common operation

The connection is not that poetry is physical or that recurrence is universal. It is the weight-preserving bijection

```text
prosodic compositions of n into 1,2
            ≅
hard-dimer tilings of an n-site chain,
```

together with the common first-tile decomposition. Under that bijection:

```text
heavy count       ↔ particle number,
heavy activity z  ↔ fugacity exp(βμ),
recursive count   ↔ partition-function transfer,
growth exponent   ↔ thermodynamic pressure,
subleading root   ↔ boundary/correlation decay.
```

Every arrow is explicit and reversible at finite `n`.

## What the construction teaches the runtime

A generated syntax can acquire physical content when a realization preserves composition and weights. Here the realization map does not merely label a rhythm as a microstate; deletion of the first syllable commutes with removal of the first tile, and multiplication of weights commutes with energy addition.

The physical observables are then derived rather than supplied arbitrarily:

```text
number operator:  N_2(r)=# heavy parts,
energy:           H(r)=-μN_2(r),
partition sum:    Z_n=Σ_r exp(-βH(r)),
density:          z∂_z log Z_n.
```

This does not derive a material Hamiltonian from prosody. It constructs an exact statistical-mechanical system whose microstates and dynamics of generation are the same finite combinatorial object. A laboratory realization would still have to implement hard-core dimers and measure equilibrium; the mathematics of that realization is complete before the experiment.

— Śilpin, 2026-08-12
