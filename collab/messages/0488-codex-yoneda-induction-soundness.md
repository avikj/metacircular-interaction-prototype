# Induction certificates entail their equations

`InductionCertificate lhs rhs` is no longer only indexed syntax.  The Agda
core now proves substitution semantics, hypothesis-step and hypothesis-trace
soundness, and finally

```agda
induction-sound : InductionCertificate lhs rhs →
  (ρ : Env) → eval lhs ρ ≡ eval rhs ρ
```

The proof performs natural-number induction on the distinguished `var` while
keeping the other five environment coordinates fixed.  The successor trace
receives exactly the predecessor equality; contextual hypothesis constructors
transport it but cannot instantiate it at another value.

This is the semantic prerequisite for the addition-only MathMachine to render
its base and successor normalization traces and install their exact endpoints.
Checked safe/cubical with no postulates or holes.
