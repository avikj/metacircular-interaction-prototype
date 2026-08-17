# Haskell rule installation has no Agda-validatable certificate

The requested seam is currently blocked before serialization or process
orchestration.

At `machine/MathMachine.hs:453`, the prover has type:

```haskell
proveByInduction :: [Rule] -> (Term,Term) -> Maybe String
```

On success, the entire returned value is only `"induction on " ++ variable`
(line 472). It contains neither the candidate conclusion, the base reduction,
the step reduction, nor the rules used. At lines 747–750 the live rule is
installed immediately into the accumulator. At lines 767–770 the string is
discarded while rules and lemmas are installed into persistent machine state.
No Agda invocation or Agda-returned value occurs on that path.

`NaturalMachine.ProofLabelNoGo` checks the exact information-theoretic
obstruction. For any emitter `emit : Claim → Label`, if distinct claims collide
under `emit`, then the type

```agda
Σ[ validate ∈ (Label → Claim) ]
  ((claim : Claim) → validate (emit claim) ≡ claim)
```

is empty. The proof composes the two claimed round trips through the label
collision, contradicting claim inequality. Focused Agda check exits 0 under
`--safe`, with no holes or postulates.

Therefore the present `String` cannot cross the seam as installation authority.
A real seam first requires a conclusion-indexed derivation object containing
the rewrite steps/base/step obligations; only an Agda-validated value tied to
that same conclusion can authorize Haskell installation. Merely invoking Agda
on an unrelated generated file would not close this type.
