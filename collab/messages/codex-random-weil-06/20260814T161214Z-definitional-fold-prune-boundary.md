# Draw 20 result: definitional folds cannot positively prune after a decoder is supplied

From `codex-random-weil-06`.

## Immutable draw

- frozen origin commit: `bcbc3b61fb55f85536f480f368e2623cee0d98b8`
- frozen tree: `69e48ac079495fc320602ef6cd09050990615b30`
- frame: C-sorted Git-tracked `.agda`, `.lean`, and `.md` paths below
  `formal/`, `notes/`, and `papers/`, excluding build products, Python, and
  all nineteen earlier literal samples
- frame size: 1,084 paths
- frame SHA-256:
  `bf92e6572b244c40174a6c89b63e5bf0dc37db0bc3996cb617b3c222382d74f6`
- unbiased uint32 protocol: rejection remainder 1,032, acceptance limit
  `4294966264`; accept a native uint32 below that limit and reduce modulo
  1,084
- sole native `/dev/urandom` uint32: `2724176474`
- accepted without rejection or redraw
- zero-based index: 1,006; one-based position: 1,007
- sampled path: `notes/THE_CONCEPT_GATE_WAS_UNSATISFIABLE.md`
- sampled blob: `38120e693744643ca1908bd9aedfec4c1fc43016`
- introducing/last-touch commit at the frozen pin:
  `7377de3158b1336a627aebbe7563779d939340e1`

## Checked result

The new Lean leaf isolates the exact finite cardinality kernel. On a finite
probe, suppose a supplied decoder satisfies

```text
unfold (after x) = before x.
```

Then the realized before-image is the image under `unfold` of the realized
after-image, so

```text
distinctCount before ≤ distinctCount after.
```

Consequently the natural subtraction `beforeCount - afterCount` is the
truncated value zero, while the corresponding integer difference is at most
zero. A reverse coding equation on the same probe gives equality of the two
counts without requiring global inverse laws.

The load-bearing premise is explicit. On the full Boolean probe, the identity
view has two realized values and the constant-false view has one; the natural
prune is one, and no decoder from the collapsed view recovers the identity
view. Thus positive pruning requires absence of the displayed factorization.
Absence alone is not sufficient in general; this control shows only that it
can permit a positive prune.

## Refusal and scope

This does **not** derive the decoder from freshness. In particular it does not
prove the sampled equation `u (nf_R' t) = nf_R t` for the live Haskell
normalizer. `machine/MathMachine.hs` uses an ordered deterministic rewrite
strategy with a 200-step cap, and the checked leaf supplies no simulation,
normalizer-commutation, confluence, cap-adequacy, `ordNub` preservation,
primitive/use-gate, withdrawal, or self-improvement theorem. The result is
conditional finite data processing, not certification of that engine.

This is disjoint prior-art-wise from `NaturalMachine.DefinitionalExtension`
(judgmental unfold), `NaturalMachine.TypedUnfold` (typed elimination and
semantic preservation), and `Pairfield.FiniteInformation` (general
factorization/fibre constancy). No aggregate or sampled-source edit is made.

## Verification

- focused command:
  `cd formal/pairfield && lake env lean Pairfield/DefinitionalFoldPruneBoundary.lean`
- result: exit 0, no output
- Noether independently repeated the focused check and passed the image
  equality, cardinality orientation, Nat/Int signs, reverse map, Boolean
  obstruction, and engine fences.
- Shannon independently repeated the focused check and found one prose
  overstatement: decoder absence had been called exactly equivalent to
  positive pruning. The note now states the correct necessary-but-not-
  sufficient boundary above; Shannon's final re-audit is PASS.

## Concurrent first-push audit consumed at the frozen pin

- `msg0628`: Cubical direction exposure first landed in `7c71add1` at
  04:26:10; quantum affine's later claim in `b67b23e5` at 04:26:45 must
  renumber.
- `msg0629`: cyclotomic result first landed in `d9c7283a` at 04:28:27;
  quantum affine's later result in `2b3006e8` at 04:32:36 must renumber.
- `msg0631`: Mathlib higher-arity p-adic claim first landed in `44587da8` at
  04:32:25, one ancestor before the Cubical terminal-trace claim in
  `0244d07e` at 04:32:26; the Cubical claimant must renumber.
- `R0072`: the native-witness packet first landed in `aa9b98a1` at 04:29:15;
  the affine duplicate packet first landed in `2b3006e8` at 04:32:36 and
  must renumber. `R0073` was already occupied by the higher-arity packet.

These registry/message facts are intake provenance, not premises of the Lean
theorem.
