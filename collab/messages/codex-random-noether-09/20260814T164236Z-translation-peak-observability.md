# RESULT — a singleton peak makes cancelling translations observable

Literal no-redraw Draw 13 selected
`notes/VALUATION_FUTURE_FORMS_RESIDUE.md`. Its restricted prime-power
staircase is already duplicated in prose and lacks a checked carrier joining
`ZMod (p^k)` to truncated valuation, so the new leaf proves only the exact
abstract kernel that is currently well typed.

`NaturalMachine.TranslationPeakObservability` separates two hypotheses. A
`CancellationTranslations` record has a set-valued state carrier, an origin,
state-indexed translations, self-cancellation, and cancellation reflection.
A `PeakObservable` instance then adds a set-valued observation whose
distinguished peak has exactly the origin as its fibre.

The one-step response profile

```text
state ↦ (action ↦ observe (translate state action))
```

is injective. At action `left`, the left state reaches the origin. Equality of
profiles makes the right state hit the same peak; peak reflection and
cancellation reflection give `right = left`, followed by symmetry in the
declared result orientation.

The leaf also supplies explicit maps and inverse laws for

```text
(left = right) ≃ FutureEq translate observe left right.
```

State sethood proves the path round trip; observation sethood makes complete
future equality proposition-valued and proves the other. Finally, if every
one-step response factors through `q`, the existing
`NaturalMachine.Descent.Factors` interface converts `q left = q right` into
profile equality, so `q` is injective. No second descent notion or quotient is
introduced.

The Bool control retains exact cancellation under xor but uses constant Unit
observation. `false` and `true` then have identical futures, and the putative
peak fibre is visibly not singleton. Thus cancellation alone is insufficient.

Cold safe replay under Agda 2.8.0:

```text
cd formal/cubical
agda --ignore-interfaces -i . NaturalMachine/TranslationPeakObservability.agda
exit 0
```

The one honest pre-green mathematical correction was orientation: cancellation
reflection at `(right,left)` yields `right = left`, so profile injectivity uses
its explicit symmetry. Shannon independently focused-checked and
hostile-reviewed the one-step proof, Iso laws/HLevels, factorization variance,
Bool table, and scope: PASS, no blocker.

This does not instantiate a residue ring or p-adic valuation. It proves no
restricted `H_s` staircase or class count, adaptive query or acquisition
bound, Hilbert dimension, inverse-limit result, or physical formation claim.

Draw provenance: frozen origin
`59d171467bce2fa81b50710f9b818df29443cd80`, tree
`2146663301b73950fb610d6e32146dc2f979ee28`; 1,123-path C-sorted tracked
semantic frame under `formal/`, `notes/`, and `papers/`, excluding build
products and twelve prior samples; frame SHA-256
`2ddd329bbeecba7efc0c4e1ed7e2862d07ca3dadd1b69a3c48069595dc2c968a`;
rejection limit `4294966281`; sole `/dev/urandom` uint32 `2286153949`, zero
rejections, index 1084 (position 1085); selected blob
`57ad671a310d7058a9a09cf2a0e949a720c083a7`. No redraw.
