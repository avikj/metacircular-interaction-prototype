> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# Exact-computation substrate

> **Retired executable surface:** Python is banned. Commands below are
> historical provenance only; do not run or repair them. Port any load-bearing
> claim to checked Agda or Lean before relying on it.

This directory is the engine layer beneath the language-based discovery loop.
It is intentionally narrower than an agent framework.

- `specs/` declares mathematical families and proof-labeled pruning rules.
- `schemas/` fixes canonical fields for problem and stage manifests.
- `validate.py` rejects any pruning constraint not backed by a theorem/audited
  lemma and validates immutable stage ledgers.

The exact wire format is JSON/JSONL with ascending integer polynomial
coefficients and rationals represented as `{ "num": "...", "den": "..." }`.
Candidate IDs should be SHA-256 of the problem-spec hash plus canonical
coefficients.  Floating values may be annotations but never load-bearing
fields.

Production and hostile-audit implementations must not import the same exact
polynomial kernel.  Shared code is convenience, not independence.

## Compiled research-state queries

`code/natural.py` is the read-only graph layer above this exact-computation
substrate. It compiles claim packets, events, sources, obligations, evidence,
dependencies, coordination messages, and journal heads without changing their
authority. Run its regressions with:

```sh
python3 code/natural.py validate
python3 -m unittest machinery.test_natural_runtime
```

Historical missing event artifacts remain visible warnings; use
`natural.py validate --strict-artifacts` when a workflow requires a completely
closed provenance set.

## Finite observer audits

`observer_channel.py` compiles the finite information lens into an exact
counterexample/reconstruction kernel.  Given JSONL rows for a finite state,
its observable value, and a target value, it decides whether the target is
constant on every observer fiber.  On failure it emits a concrete collision;
in either case it computes the exact minimum zero-error side alphabet for the
target and for full-state reconstruction.  This separates target sufficiency,
fiber ambiguity, and Shannon channel capacity instead of treating them as one
quantity.

The checker is exact only relative to the supplied finite state list.  A
separate proof obligation must establish that the list exhausts the intended
mathematical domain; no finite table certifies an infinite universal claim.

## Odd-degree tail certificates

`odd_tail_certificate.py` is the reusable arithmetic residue of the septic
and nonic closures.  For a monic odd-degree candidate with one negative root,
it checks the strict rational inequality that excludes divisibility by every
later odd-exponent prefix tail.  The input contains a nonzero prefix
resultant, rational upper bounds for the negative root and complex-pair
moduli, the prefix support, and the first tail exponent.  It also binds a
polynomial identifier, prefix identifier, the stride-two/coefficient-one tail
model, and a hash of the canonical input.  Rationals use the repository wire
format `{ "num": "...", "den": "..." }`.  The output records the exact lower
side, upper side, and signed margin.

The kernel deliberately does not bless its inputs: root topology and
enclosures, monicity/integrality, prefix identity and support, resultant
correctness, and the asserted later-tail support/coefficient bound remain
separate proof obligations.  This makes the cheap verifier reusable without
hiding the agent-derived mathematics inside configuration.

## Monomial vertex certificates

`monomial_vertex.py` compiles positive rational cap and product constraints
into a finite exact vertex problem.  In log coordinates, each disjoint
product law is a simplex of cap deficits.  Every positive-coefficient Laurent
polynomial is convex there, so its closed-domain maximum (or strict-domain
supremum) is the largest exact value on the product-of-simplices vertices.
This transfers conserved-product reasoning into a cheap traditional program:
the checker accepts signed integer exponents, rejects floats and overlapping
groups, hashes the canonical problem, and evaluates all vertices with rational
arithmetic.

The result certifies only the declared optimization problem.  Root caps,
norm equations, and the translation from polynomial coefficients to a
positive Laurent objective remain external theorem obligations.  Strict
domains are reported as suprema with attainment deliberately undecided.

### Exponent-addressed bound contracts

Analytic root bounds are often written from the leading coefficient while the
enumerators store polynomials from the constant coefficient.  A bare tuple is
therefore not an admissible pruning interface.  `bound_contract.py` stores each
bound under its actual polynomial exponent, checks a separately declared
human-facing vector and its orientation, and can emit a C++ array indexed by
exponent.  The regression includes the octic reversal that quarantined the
first exp36 certificate.  This checks indexing only; it does not prove the
analytic bounds themselves.

## CPU work units

`cpu_ledger.py` is the distribution boundary for deterministic searches. A
worker records the exact problem-spec hash, kernel hash, declared shard domain,
ordered pruning counts, candidate artifact hash, and stable candidate IDs.  A
merge succeeds only when every shard index occurs exactly once and no candidate
appears in two shards.  Mutating a spec, kernel, manifest, or candidate row is
detected by replay. Artifact paths are relative to the manifest; move a worker's
manifest and artifacts as one directory tree.

The ledger proves that every declared shard index is present exactly once and
that artifacts are intact. It does **not** prove that the index-to-domain map
actually partitions the mathematical search domain. It also does **not** prove
that the coefficient box covers every mathematical case or that a pruning
predicate is sound.  Those are separate theorem obligations in the spec.  The
production kernel and the hostile audit must still be independently encoded.

Example worker record:

```sh
python3 machinery/cpu_ledger.py record \
  --spec machinery/specs/nonic-prime-prefix.json \
  --kernel code/exp37_nonic_enumerator.cpp \
  --candidates /tmp/nonic-017.jsonl \
  --shard-index 17 --shard-count 441 \
  --domain '{"a":-10,"j":7}' \
  --stage-counts '[{"stage":"raw","count":1000},{"stage":"unit","count":3}]' \
  --command './exp37 --a -10 --j 7' \
  --output /tmp/nonic-017.manifest.json
```

Run the regressions with:

```sh
python3 machinery/test_cpu_ledger.py
python3 machinery/test_bound_contract.py
python3 machinery/test_odd_tail_certificate.py
python3 machinery/test_monomial_vertex.py
```
