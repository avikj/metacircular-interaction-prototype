# The center-relative pair weight is the unique integral quarter of `Q`

**Status:** checked in safe Cubical Agda.  The exact terms are in
`formal/cubical/CenterRelativeWeightTransport.agda`.

## Result

The sampled `CENTER_RELATIVE_CONE` note left one precise successor seed: do
not stop at the carrier equivalence

```text
Pair ≃ CR;
```

transport a structure through it.  For the elementary pair evaluator

```text
pairWeight (p , q) = p · q,
```

the checked inverse-precomposition transport is

```text
nativeWeight y = pairWeight (Ψ y).
```

The direction matters.  An evaluator on `Pair` is contravariant in its input,
so it becomes an evaluator on `CR` by the inverse `Ψ`, not by the forward map
`Φ`.  `nativeWeight-preserves` proves

```text
nativeWeight (Φ x) = pairWeight x,
```

and `nativeWeight-unique-conserved` proves that this conservation equation
uniquely determines the transported evaluator.  Both specialize the existing
generic `NaturalMachine.EvaluatorTransport` interface; that generic transport
is prior checked infrastructure, not a new theorem here.

The new arithmetic identification is division-free.  On

```text
CR = Σ W , Σ R , isEven (W - R) = true,
qCR (W , R , _) = W² - R²,
four z = (z + z) + (z + z),
```

the module proves

```text
nativeWeight-quarter : (y : CR) → four (nativeWeight y) = qCR y.
```

This is `CenterRelative.thm16-8`, `Q(Φ(p,q)) = 4pq`, followed through the
checked round trip `Φ(Ψ y) = y`.  No integer division is introduced.  The
parity evidence is already a field of `y : CR`; it is exactly what makes `Ψ`
available.

Finally, `nativeWeight-unique-quarter` proves that any integer-valued
`f : CR → ℤ` with `four (f y) = qCR y` is equal to `nativeWeight`.  The
proof applies injectivity of integer doubling twice.  It assumes neither a
division operation nor a cancellativity/domain hypothesis on a generalized
ring.

Thus the exact local/global statement is:

> On the parity sublattice `CR`, `Q` has a unique integer-valued quarter, and
> that quarter is precisely the pair-product evaluator transported along the
> checked center-relative equivalence.

It is deliberately not a claim that `W²-R²` is divisible by four on all of
`ℤ²`.

## Novelty and prior-art boundary

- `CenterRelative.Pair≃CR`, `Ψ`, `ΦΨ`, `thm16-8`, and injectivity of
  doubling were already checked.
- `NaturalMachine.EvaluatorTransport` already proved generic contravariant
  evaluator transport, conservation, and uniqueness.
- The leaf contributes the exact adapter between those two prior results:
  the transported pair evaluator is characterized natively by the quadratic
  quarter law on `CR`.
- A search through the frozen draw tree and the then-current `origin/main`
  found no existing `nativeWeight`, `pairWeight`, or quarter-of-`Q` theorem.

The identity `(p+q)²-(q-p)²=4pq` is classical, and no novelty is claimed
for it.

## Scope fence

This is a theorem about integer pairs, their parity-compatible coordinate
lattice, and an evaluator on that carrier.  It proves no statement about
primes, positivity of the cone, pair counts, singular series, analytic pair
weights, hyperbolic coordinates, `O(1,1)`, higher arity, or physical
realization.  In particular, `pairWeight` here is the bare product `p·q`, not
an arithmetic coefficient family `a_p a_q` and not a prime-supported measure.

## Draw provenance

Draw 12 froze `origin/main` commit
`4ecfac8f689581a4ec50b2b95bb1a5059706ed40`, tree
`76135d7f8f1e606efc9c1b2ab96e59eb1c9601c0`.  The frame was the C-sorted
tracked semantic corpus under `formal/`, `notes/`, and `papers/`, restricted to
`.agda`, `.lean`, and `.md`, excluding build products and the exact eleven
earlier samples.  It contained 1,039 paths and had SHA-256
`b8818883d9d96961261872ff5173c4b8c47f8b41b71c5df72b93f2f862f04099`.

For exact unbiased indexing, the acceptance limit was `4294967289` (tail
size 7).  The sole native `/dev/urandom` uint32 was `2978517349`, accepted at
zero-based index 464 (one-based position 465), selecting
`notes/CENTER_RELATIVE_CONE.md`, blob
`46eb33a47dce4ebab68f18bfce5979bde88e1637`, 11,244 bytes.  Its provenance
commit is `caf56ab0d902357794b312d9f46251fc474ef6ef`.

## Verification

On Agda 2.8.0 with the installed Cubical library, from `formal/cubical/`:

```sh
agda --ignore-interfaces -i . CenterRelativeWeightTransport.agda
```

exits 0.  The module uses `--cubical --guardedness --safe
--no-import-sorts`, contains no postulate or hole, and writes no aggregate
import.

The cold replay caught two pre-commit defects.  First, three occurrences of
the wrong Unicode glyph `Pair≓CR` did not name the exported `Pair≃CR`.
After that correction, destructuring `Ψ y` in a `with` clause did not
definitionally refine the dependent endpoint `ΦΨ y`.  Factoring
`pair-quarter` over the entire pair removed that invalid refinement.  The
final direct and isolated cold replays exit 0 on the corrected bytes; hostile
review rechecked both repairs and the path orientation.
