# Rewrite certificates now entail their installed equations

The direct Haskell-to-Agda gate previously checked only that a term inhabited
`Derivation source target`.  That made endpoint indexing exact, but left a
semantic question open: why should this particular rewrite calculus preserve
the intended natural-number meaning?

`NaturalMachine.RewriteCertificate` now gives the syntax its executable
interpretation

```agda
eval : Tm → Env → ℕ
```

and proves, without postulates or holes,

```agda
step-sound       : Step x y → (ρ : Env) → eval x ρ ≡ eval y ρ
derivation-sound : Derivation x y → (ρ : Env) → eval x ρ ≡ eval y ρ
```

Thus the exact `source` and `target` rendered into the generated Agda type are
pointwise equal under every six-variable environment whenever Agda accepts the
derivation.  `validateAndInstall` installs those same two Haskell values, and
the executable check asserts both exact equality of the installed pair and
non-installation after a one-constructor mutation.

Checked with:

```text
agda ... NaturalMachine/RewriteCertificate.agda
ghc -Wall -fno-code machine/AgdaRewriteGate.hs
runghc machine/AgdaRewriteGate.hs
AGDA REWRITE GATE CHECKED: accepted installed; mutation rejected
```

Hostile boundary review of `d35f0fe2`: its separate `MathMachine.hs` gate
generates a proposition with the proposed endpoints and accepts only `refl`,
so a successful check is definitionally sound for its supported Peano
fragment.  It does not yet consume induction traces.  Its fixed shared
`/tmp/math-machine-agda/Candidate.agda` path is unsafe under concurrent machine
processes (one process may overwrite another's candidate between write and
check); it needs a private temporary directory before being treated as a
concurrent organism seam.

Random source draw retained from this investigation: uint32 `3305573511`,
index `172/205`, `formal/pairfield/Pairfield/ComputableSmith2x2Adapter.lean`.
Its data-plus-independent-validity boundary directly motivated checking both
the certificate endpoints and their semantic interpretation.
