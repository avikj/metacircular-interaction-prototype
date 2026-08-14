# A regular-action witness for a nonzero compression defect

**Status:** checked bounded specialization.  The leaf module is
`formal/cubical/NaturalMachine/CompressionDefectRegularWitness.agda`.

## Unbiased random provenance

This result came from the eighth no-redraw semantic-corpus encounter.  The
frozen tree was `3e5c6c23930e059fb7951ad1cf2180ab512b9ad4`; its frame was the
980 bytewise-sorted tracked `.agda`, `.lean`, and `.md` paths under `formal/`,
`notes/`, and `papers/`, excluding build paths and the seven earlier samples.
The newline-frame SHA-256 was
`50f6834755fcada6ba1e2e92bd8917d215db6a53abb705ed5aa9857137d546df`.

Indexing used exact rejection rather than biased reduction.  For `n=980`, the
acceptance limit is

```text
floor(2^32 / 980) * 980 = 4294966620,
```

leaving a rejection tail of 676 values.  The sole native-`uint32` draw was
`456342931`, so it was accepted without redraw and selected zero-based index
51 (position 52):
`formal/cubical/NaturalMachine/CompressionDefect.agda`, blob
`65e0461585e666783207abef84f1c2bea874f5e2`.

## Duplicate correction

The sampled module's header says its semigroup result is only one-way.  That
gap is already closed elsewhere:
`NaturalMachine.ExcursionReturn.semigroup→defect-zero` proves the converse.
No new semigroup/defect equivalence is claimed here.

The genuinely unfilled sentence in the sampled header is different: a
nonzero operator does not automatically supply an inhabited state witness in
an unspecified carrier.  The new result answers only the canonical regular
left action of a ring on its own carrier.

## Exact checked result

For any ring element, acting on the multiplicative unit detects nonvanishing:

```text
regular-action-detects-nonzero :
  (a : ⟨ A ⟩) → ¬ (a ≡ 0r)
  → Σ[ x ∈ ⟨ A ⟩ ] ¬ (a · x ≡ 0r).
```

The witness is `x = 1r`.  If `a · 1r ≡ 0r`, the right-unit law gives
`a ≡ 0r`, contradicting the hypothesis.  This is zero-divisor-safe: it
uses neither cancellation nor a domain/no-zero-divisor assumption.

Specializing `a` to the raw product expression exported under the name
`CompressionDefect.defect` gives:

```text
nonzero-compression-defect→regular-witness :
  (eIdem : e · e ≡ e)
  (eq1 : e + q ≡ 1r)
  (Tsemi : (t s : ℕ) → T t · T s ≡ T (t + s))
  → ¬ (CompressionDefect.defect A e q eIdem eq1 T Tsemi t s ≡ 0r)
  → Σ[ x ∈ ⟨ A ⟩ ]
      ¬ (CompressionDefect.defect A e q eIdem eq1 T Tsemi t s · x ≡ 0r).
```

The imported interface explicitly binds the projector, complement, and
semigroup laws, so the specialization supplies them.  Its displayed value is
still the raw product; after that element is selected and assumed nonzero,
the witness extraction uses only the ring unit.  The laws license its
excursion-return reading in the enclosing compression theorem.

## Scope boundary

This is the ring's left regular representation, where states are ring
elements.  It does **not** produce a witness in an arbitrary intended module
or physical state carrier.  Such a result needs an explicit action plus a
witness-producing faithfulness/nontriviality hypothesis; bare operator
nonvanishing is not enough data constructively.  Therefore the general T18.5
witness direction remains open, as do endomorphism, half-line, charge,
Buchstab, and arithmetic instances.  The theorem is an elementary ring fact,
not a novelty claim or a physical realization.

## Verification

The frozen formal tree was extracted to a fresh temporary directory and Agda
2.8.0 checked the new leaf with `--ignore-interfaces`.  It exited zero under
`--cubical --guardedness --safe --no-import-sorts`; no interface was written
into the shared repository.
