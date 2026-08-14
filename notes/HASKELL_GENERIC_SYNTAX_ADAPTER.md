# The Haskell discovery syntax is the generic primitive syntax

`NaturalMachine.HaskellDiscoveryBoundary` and
`NaturalMachine.ConservativePrimitiveExtension` used two arithmetic term
languages without a typed comparison map.  The first is the deliberately
small AST accepted by the five-round Haskell-to-Agda bridge.  The second is
the repository's generic arity-indexed term language, where substitution and
evaluation under substitution are already checked.

`NaturalMachine.HaskellGenericSyntaxAdapter` supplies the missing joint.  It
does not add a new discovery rule.  It proves that the two existing
presentations are exactly equivalent for the four constructors

\[
  0,\qquad \mathsf{suc},\qquad (+),\qquad (\cdot).
\]

## 1. The common signature

The adapter declares an arity-indexed operation type

| operation | arity |
|---|---:|
| `zero-op` | 0 |
| `suc-op` | 1 |
| `add-op` | 2 |
| `mul-op` | 2 |

and instantiates the generic algebra on natural numbers.  The maps
`toGeneric` and `fromGeneric` then translate between the bespoke
`HaskellTerm` and

```text
ConservativePrimitiveExtension.Term HaskellSignature ℕ.
```

Both inverse laws are checked.  In particular,

```text
haskellTermEquiv : HaskellTerm ≃ GenericTerm
```

is an actual equivalence, not a prose identification of similar syntax.
The reverse law is proof-relevant at the arity boundary: Cubical `Fin` is a
bounded-natural subtype, so the proof uses `¬Fin0`, uniqueness of `Fin 1`, and
an explicit `Fin 2` extensionality argument through `fsplit`.

## 2. Evaluation and sound equations

The natural-number algebra has the same interpretation as the Haskell bridge
AST.  The commuting equation is

```text
evaluate-to ρ t :
  CP.evaluate HaskellNatAlgebra ρ (toGeneric t) ≡ HD.evaluate ρ t.
```

Its inverse-facing form is also checked.  Hence a universally sound Haskell
equation transports to the generic presentation, and a generic proof about
the translated equation transports back.  These are the two maps
`sound-to-generic` and `generic-to-sound`; no finite test table is involved.

## 3. Reusing generic substitution

The adapter defines Haskell substitution by translating to the generic term,
calling the already-checked generic `bind`, and translating back.  The theorem

```text
evaluate-substitute ρ t σ :
  evaluate ρ (substitute t σ)
  ≡ evaluate (λ n → evaluate ρ (σ n)) t
```

is obtained by composing the two evaluator-commutation paths with
`ConservativePrimitiveExtension.evaluate-bind`.  There is deliberately no
second structural induction proving a duplicate substitution theorem.

Consequently every universally sound discovery equation stays sound after
an arbitrary term substitution.  This is the precise proof-certificate
language extension licensed by the common syntax.  It says nothing about
whether the Haskell process actually emits or checks a substitution trace.

## 4. Hostile control

The bridge does not manufacture soundness.  At the zero environment,

```text
x-not-successor-sound : ¬ Sound (x , sucT x)
```

reduces a supposed universal equality to `0 ≡ 1` and closes with `znots`.
The generic adapter therefore preserves the semantic firewall rather than
turning every pair of terms into a certificate.

## 5. Exact scope

What is checked:

- an equivalence of the two four-constructor typed ASTs;
- evaluator commutation in both directions;
- transport of universal equation soundness;
- reuse of the generic substitution theorem; and
- one explicit unsound-equation control.

What is not checked:

- parsing or compiling `machine/MathMachine.hs`;
- execution of its search, normalization, induction, or five-round loop;
- equality of a generated temporary manifest with `expectedDiscoveries`;
- a derivation-trace format for the Haskell runtime;
- admission of subtraction, gcd, invented symbols, or arbitrary later
  discoveries; or
- correctness inferred from fingerprints or bounded testing.

The existing generated-manifest check remains the authority for the concrete
five-round output.  This adapter only identifies the reusable typed syntax
and semantic substitution law beneath that bounded bridge.

## 6. Literal encounter provenance and verification

The primary encounter froze `origin/main` at
`4805912139083012cc230c119c70e021c0ad1a9f`, tree
`66fb20e1dc648fa4ab46ab33e2808425d1a6d1d9`.  Its C-sorted frame contained
1,154 Git-tracked `.agda`, `.lean`, and `.md` paths under `formal/`, `notes/`,
and `papers/`, excluding build products.  The newline-delimited frame had
SHA-256
`e7e2513bbe69a46c95795f40f1a78f2fd230e25ad4e6693501cd597e5d782dcd`.
The sole accepted native uint32 was `1980479944`, below rejection limit
`4294966432`; it selected zero-based index 146, position 147,
`formal/cubical/NaturalMachine/HaskellDiscoveryBoundary.agda`, blob
`c84eab5da59696f55e2da678e3fcb6c683da2abc`.  There was no rejection and no
content redraw.

The first focused replays exposed missing narrow imports and, more
importantly, an invalid initial attempt to pattern-match Cubical `Fin` as an
inductive datatype.  The final proof uses its actual bounded-natural
representation through `¬Fin0` and `fsplit`.  Focused and ignored-interface
Agda 2.8.0 checks both exit zero.  An independent hostile ignored-interface
replay also exits zero and confirms the equivalence orientations, finite
coordinate extensionality, evaluator paths, substitution composition, and
scope boundary.
