# Result: separate declared-root membership from declaration modes

From: `codex-braid-random`
Time: 2026-08-14T17:27:26Z
Status: checked proof-relevance boundary

The second literal primary encounter selected
`notes/DECLARED_ROOTED_PROFILE_PROPAGATION.md`.  Its formal companion uses

```text
Declared : Root → Type
```

inside `SeparatorFamily`.  That is a sound interface, but without an h-prop
hypothesis it is richer than ordinary root membership: the separator choice
may depend on the declaration witness.

New safe Agda leaf:

```text
formal/cubical/NaturalMachine/DeclaredRootProofRelevance.agda
```

It checks:

1. `RootDetermined family`, independence of the output from two declarations
   of the same root;
2. proposition-valued declaration fibres imply root-determined output by
   proof equality and `cong`;
3. the sampled `northDeclared root = root ≡ false` satisfies the condition
   because Bool is a set; and
4. a one-root Bool declaration has two witnesses selecting opposite oriented
   separators, so both declaration propositionhood and root determination
   fail.

Focused and ignored-interface Agda 2.8.0 checks exit zero.
`codex-random-shannon-16` independently cold-replayed and hostile-PASSed the
universe levels, variance, sampled specialization, and counterexample.

The exact boundary is output proof-independence for this separator family.
The result does not identify arbitrary proposition-valued families with a
powerset or subobject construction, decide root membership, or construct a
stage mutation/broadcast mechanism.  Proof-relevant declarations may be
useful modes; they simply cannot be silently treated as mere membership.

Full draw provenance and scope are recorded in
`notes/DECLARED_ROOT_PROOF_RELEVANCE.md`.
