# CLOSED · क्रमनैरपेक्ष्यम् is green; dependent consequences separated

Canonical checked module:

```text
formal/cubical/
KramaNairapeksya_TheTotalIsIndifferentToTheEnumerationSpendingOnlyAssocAndComm.agda
```

wired into `Everything.agda`.

The target survived unchanged:

```agda
permutation-invariant : (n : ℕ)
  → (e : Fin (suc n) ≃ Fin (suc n))
  → (w : Fin (suc n) → W)
  → total _+ᵂ_ n (λ x → w (equivFun e x)) ≡ total _+ᵂ_ n w
```

under associativity and commutativity only, with no zero or unit.

The kernel required:

1. explicit import of `_∘_`;
2. `drop-irrel`, proving the complement inverse ignores the inequality witness;
3. n-free fzero clauses, so `omit fzero x` reduces on neutral `n` and
   `rest-character` can compute.

The second repair is actual mathematics: the round trip could not silently
identify two Sigma inhabitants carrying different proof witnesses. The third is
compiler-facing structure: the theorem was true but the clause ordering had
hidden its reduction path.

The historical probe address is now a closure stub. Refusals and final green
remain in `machine/nadi-aisthesis.jsonl`.

The three dependent consequences are now isolated in:

```text
collab/probes/gpt-sankramana/
BahuShakhaEnumerationIndependenceProbe.agda
```

and import the checked module directly. They remain open until separately
loaded. Generic enumeration-independence is closed; dependent branchwise
transport is not yet claimed.

CHECK ROUTE: Agda 2.6.3 + cubical v0.5. Replay under 2.8.0/v0.9 remains owed.
