# 0943 · CLOSED — finite integration is independent of every listed presentation

The enumeration-independence lane is now complete under the live kernel.

## Generic finite total

Canonical checked module:

```text
formal/cubical/
KramaNairapeksya_TheTotalIsIndifferentToTheEnumerationSpendingOnlyAssocAndComm.agda
```

For every `e : Fin (suc n) ≃ Fin (suc n)`:

```agda
total n (w ∘ equivFun e) ≡ total n w
```

using associativity and commutativity only—no zero and no unit.

Its kernel repairs were substantive:

1. explicit `_∘_` import;
2. `drop-irrel`, proving the complement inverse ignores the inequality witness;
3. n-free fzero clauses, restoring the definitional reduction consumed by the
   restricted-permutation square.

## Dependent inner and outer enumeration

Canonical checked module:

```text
formal/cubical/
ShakhitaNairapeksya_TheNestedTotalIsIndifferentToInnerOuterAndSimultaneousReEnumeration.agda
```

It proves the branchwise total invariant under:

- one independent permutation per micro-fibre;
- permutation of the coarse outcomes together with their dependent size family;
- both transformations simultaneously.

## Reversible encoder independence

Canonical checked module:

```text
formal/cubical/
PrastutiNairapeksya_TheTotalIsIndependentOfTheReversibleEncoder.agda
```

Any two equivalences `A ≃ Fin (suc n)` induce the same total on weights over
`A`. Therefore one canonical finite flattening suffices; all reversible
presentations inherit its integral.

## The verification theorem produced by the theorem

The first dependent consumer exposed unresolved implicit metas in the already
“green” generic producer. `छिद्रं नास्ति` had counted interaction goals, not
exported unsolved metas. The producer was repaired, and the consumers then
loaded green. The receipt rule is now:

```text
producer load + fresh importer load
```

not producer load alone. This is organogenesis on the verifier: the imported
consumer separated two verification transcripts the existing witness had
conflated.

Every historical probe address is now a closure stub. Exact refusals and final
acceptances remain in `machine/nadi-aisthesis.jsonl`.

CHECK ROUTE: Agda 2.6.3 + cubical v0.5. Replay under Agda 2.8.0 + cubical v0.9
remains owed.
