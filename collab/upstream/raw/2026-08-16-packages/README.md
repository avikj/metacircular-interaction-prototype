> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# Upstream packages, 2026-08-16

Four packages delivered by the human owner into cf-tantu's session on
2026-08-16, from the external "/Math Research" corpus — the same stream the
Self-Contained Core Transmission V2 came from
(`../EGB_SELF_CONTAINED_CORE_TRANSMISSION_V2_2026-08-16.md`). Stored verbatim
in `upstream/raw` per convention. Each package's own scope and non-claim
statements govern its use; nothing here has been independently verified in
this repository.

## What is here

| directory | content |
|---|---|
| `PRIME_ATOM_TOMOGRAPHY_CONDITIONING_PACKAGE_20260816` | exact finite-volume inverse norms, a cyclic charge-character projector, and a sharpened stable-extraction frontier |
| `PRIME_PAIR_PHASE_TO_MOVING_FACTOR_CONTINUATION_PACKAGE_20260816` | cyclic charge/CRT boundary theorems v2, and a Möbius–Kloosterman parameter audit |
| `EGB_COMPREHENSIVE_INDEX_V3_PACKAGE` | the V3 second-pass corpus index, its resume/relation/inventory/reread JSON, and the V2→V3 delta |
| `EGB_CIRCULATION_EVENT_0002_PACKAGE_20260816` | circulation event 0002: interference pass, validation, dynamic-sieve and theorem-claim-graph extensions |

## THE PYTHON WAS NOT COPIED

Three `.py` files in these packages were deliberately **excluded**:

```
prime_atom_tomography_conditioning.py
prime_pair_cyclic_charge_crt_boundary_v2.py
prime_mobius_kloosterman_parameter_audit.py
```

Python is banned in this repository (human owner, 2026-08-13; `CLAUDE.md`,
`PROTOCOL.md` §5), enforced at three layers. The exclusion is recorded here
rather than left silent, because a reader comparing a package manifest
against this directory will find the checksums short and is entitled to know
why. The manifests and reports those scripts produced ARE here; what is
missing is the executable that produced them, which by this repository's own
rule was never the evidence — *"a script that prints a number is an assertion
a reader must trust; a checked term is the thing itself."*

If any of these computations is to become load-bearing here, it must be
re-derived in Agda (`formal/cubical/`) or Lean (`formal/pairfield/`), or
carried as an exact finite exhaustive verification in the Haskell engine
(`machine/`), the way `ArithVocab`'s lifting-the-exponent law and
`CyclotomicVocab`'s head-length dichotomy already are.

## Why the tomography package is the one to read first

It continues an obligation the V2 transmission left open in its own words.
V2 §5.11 gives the fugacity propagator `𝒢_{h,k}(z) = P U_h z^{C−1} U_k P`
with its three exact facets (coefficient, total gluing value, and the
derivative jet at `z=1`), then states the wall plainly: in finite volume
`O(log N)` derivatives suffice *algebraically* for exact atom recovery, and
the hard part is **asymptotic conditioning** — controlling a growing jet
strongly enough that continuation from `z=1` to the rare charge-one atom
preserves the cancellation. V2 §14.7 lists "stable growing-degree prime-atom
reconstruction, not merely finite algebraic visibility" as an open item.

This package's stated change is exactly that: *"the phrase 'stable
growing-degree reconstruction is open' is sharpened into exact,
basis-dependent worst-case error-amplification constants,"* with the
remaining obligation named as proving estimates for the actual
CRT/Kloosterman fugacity propagator at one of the resulting precision
budgets. Whether the sharpening survives contact with that propagator is not
settled by the package and is not claimed by it.

## Status in this repository

**Unverified upstream source.** No claim in these files is load-bearing here
until it is independently checked. They are recorded so the correction
chains, non-claims, and open obligations they carry are visible to every
lane, and so that a later checked result can cite the exact artifact it
descends from.
