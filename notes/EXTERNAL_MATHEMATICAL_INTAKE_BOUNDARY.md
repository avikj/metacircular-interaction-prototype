# Bounded intake boundary for external mathematics

Status: process specification. This note does not certify any theorem or
authorize an external import.

External material may inform a question, but it does not become repository
mathematics merely because it is named, downloaded, summarized, or accepted by
a proof assistant. Intake therefore has three independent coordinates:

| coordinate | recorded value | what it establishes |
|---|---|---|
| provenance | exact source bytes (or an explicit incomplete/indirect record), source identity, retrieval time, and dependency/version context | what was actually observed and where it came from |
| formal-check status | `unchecked`, `replayed`, `kernel-checked`, or `kernel-checked-with-assumptions`, naming the kernel, imports, axioms, and exact artifact | what a specified checker replayed, not that the source's interpretation is correct |
| installation authority | `quarantined`, `candidate`, `accepted`, or `revoked`, as an append-only policy event with actor and scope | whether this repository may use it as a load-bearing dependency |

These coordinates must not be collapsed into a scalar trust score. In
particular, a kernel-checked translation can remain a candidate if its source
mapping, notation, hypotheses, or dependency boundary is unsettled; a famous
source can remain quarantined if its bytes or proof are unavailable.

## Intake record

An intake record is the smallest durable unit:

1. Preserve the exact observed source in a private, content-addressed record
   when permitted. If only a search result, quotation, or user relay was
   observed, label it `indirect` or `partial`; never reconstruct missing text.
2. Record citation/provenance, retrieval date, hashes, licence/access limits,
   source version, and the precise mathematical claim being imported.
3. Record the translation boundary: definitions, universe/foundation,
   hypotheses, notation map, and every unproved external dependency.
4. Attach a replayable proof artifact or exact counterexample. A checker run
   must state its kernel/version, imports, axioms/postulates, and whether it
   checks the source statement or only a translated surrogate.
5. Keep the record quarantined until an independent audit and a scoped,
   append-only acceptance event name the files and claims allowed to depend on
   it. Revocation removes current authority without deleting historical
   provenance.

No external package, theorem database, hosted CAS output, executable, or
model-generated summary may be installed as a load-bearing dependency at
intake. It may be stored as an explicitly labelled candidate or raw source;
promotion requires the same proof/translation boundary as an in-repository
claim. Search summaries are provenance and discovery signals, never evidence
of a theorem or novelty. Numerics may falsify a candidate, but cannot promote
one.

## Fail-closed rule

Consumers must reject a record unless its referenced provenance, exact claim,
formal-check status, and current scoped authority event are all present and
compatible. Missing data means `quarantined`, not “probably valid.” A checked
term proves only the term under its declared environment; it does not prove
that the external source intended that term, that the translation preserved
the intended semantics, or that importing it is authorized.

This boundary is deliberately narrower than a general package manager. It
protects the distinction between encounter, evidence, formal proof, and
repository authority while leaving a reversible path for later integration.
