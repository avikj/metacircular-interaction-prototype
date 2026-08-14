# RESULT: WalkStream equivalence and two independent hypothesis controls

Draw 22 selected
`formal/cubical/NaturalMachine/WalkStream.agda`.  The new safe leaf
`formal/cubical/NaturalMachine/WalkStreamHypothesisBoundary.agda` proves the
reverse of the existing `installStream` map and upgrades the two directions
to

```text
IsLCM (q ∷ S) M ≃ IsLCM (range1 q) M
```

under exactly the existing `2 ≤ q`, old-state LCM,
`LeastNonDivisor L q`, and old-address range premises.  Recursive commonness
and truncated divisibility make both universal-property proof types
propositions, so the equivalence uses proposition inverse laws rather than a
choice of divisibility witnesses.

Two independent controls prevent weakening the uniform theorem:

- `S=[]`, `L=1`, `q=0`, `M=0` satisfies every premise except `2≤q`; the
  installed list has LCM 0 while the empty frontier does not.
- `S=[3]`, `L=3`, `q=2`, `M=6` satisfies the lower bound and all other
  arithmetic premises except the old-address range; `[2,3]` has LCM 6 while
  `range1 2=[2,1]` does not.

These controls show that neither premise may simply be deleted from this
uniform theorem.  They are not an if-and-only-if classification of every
individual instance.  The accompanying note is
`notes/WALK_STREAM_HYPOTHESIS_BOUNDARY.md`.

## Verification and hostile review

- `cd formal/cubical && agda -i . NaturalMachine/WalkStreamHypothesisBoundary.agda`
  exits 0 under Agda 2.8.0.
- `cd formal/cubical && agda --ignore-interfaces -i . NaturalMachine/WalkStreamHypothesisBoundary.agda`
  exits 0 after a full dependency replay.
- Shannon independently ran the focused checker and hostile-audited the
  equivalence orientation, HLevels, reverse universal property, both control
  tuples, divisibility arithmetic, and scope: PASS, no blocker.  Shannon's
  title-level caution prompted the explicit uniform-theorem qualification
  above and in the note.

The pre-green transcript is preserved conceptually: the first draft omitted
the direct `Cubical.Data.Sum` and nullary-relation imports, so Agda first
rejected the `inl`/`inr` clauses and then `¬_`; later focused passes required
parentheses at mixed-precedence `×`/`¬` types and retaining the full supplied
LCM/LND records rather than anonymous metavariable placeholders.  These were
interface and proof-plumbing repairs only; no theorem statement changed.

## Immutable random provenance

- origin pin: `82f462103e4c86a8b45123b8a17cc2b9216f7196`
- tree: `70eb945edb67cac4faa4f5d1500c68e3cf37b116`
- frame: C-sorted tracked `formal/`, `notes/`, and `papers/` files ending in
  `.agda`, `.lean`, or `.md`, excluding build products, Python, and all 21
  earlier literal samples
- base/final counts: 1,131 / 1,110 (exact exclusion delta 21)
- frame SHA-256:
  `bf86280b433f8ea6aa3cfa720a811ae21b568630127c670970bce54a9129dd57`
- unbiased protocol: uint32 acceptance bound `4294966290` for remainder
  1,006; sole native `/dev/urandom` uint32 `665072305`, accepted without
  rejection or redraw
- index: zero-based 265, one-based 266
- selected path: `formal/cubical/NaturalMachine/WalkStream.agda`
- selected blob: `69500c274f37824943c57aaae0898abcec4e4610`
- introducing/last-touch commit:
  `41d5d0bb58150ca39bcbc78f81d9595117ebd8d3`

R0074 and messages 0640--0645 were consumed at intake.  The msg0643
first-push collision remains repository bookkeeping, not a premise here.

No LCM algorithm, iteration theorem, prime-power stream, Chebyshev function,
asymptotic, runtime/storage price, or physical capacity claim follows.  No
aggregate, sampled-source, or foreign work path was touched.
