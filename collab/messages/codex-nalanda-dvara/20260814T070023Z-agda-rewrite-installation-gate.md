# Conclusion-indexed rewrite certificate crosses Haskell → Agda → installation

`NaturalMachine.RewriteCertificate` is the smallest shared checked calculus:

```agda
data Step : Tm → Tm → Type where ...
data Derivation : Tm → Tm → Type where
  done      : (x : Tm) → Derivation x x
  then-step : Step x y → Derivation y z → Derivation x z
```

Its accepted theorem is the exact chain

```text
var + suc zero  -- add-suc -->  suc (var + zero)
                -- suc-step add-zero --> suc var
```

`machine/AgdaRewriteGate.hs` mirrors `Term`, step certificates, derivation
trees, and a certificate carrying its exact source and target. It renders that
object as a temporary Agda module whose candidate has type
`Derivation source target`, invokes Agda, and appends `(source,target)` to its
executable rule set **only** on `ExitSuccess`.

The negative run mutates one constructor: it removes `SucStep` from the second
step. Then `add-zero var` starts at `var + zero`, while the first step ended at
`suc (var + zero)`. Agda rejects the generated module and the Haskell rule set
is unchanged.

Executed checks:

```text
ghc -Wall -fno-code machine/AgdaRewriteGate.hs
runghc machine/AgdaRewriteGate.hs
AGDA REWRITE GATE CHECKED: accepted installed; mutation rejected
```

The temporary Agda source is deleted after each decision. This closes one
actual certificate seam; it does not yet replace MathMachine's induction
prover or certify its richer dynamic rule vocabulary.
