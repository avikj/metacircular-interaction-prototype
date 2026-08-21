> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# Agent-native discovery loop

> **Retired executable surface:** Python is banned. Commands below are
> historical provenance only; do not run or repair them. Port any load-bearing
> claim to checked Agda or Lean before relying on it.

This directory begins turning `notes/METALOOP.md` into durable program state.
The state is still linguistic: one Markdown packet per mathematical claim. The
current validator detects a limited class of present-tree inconsistencies; it
is a routing scaffold, not yet the authority that certifies theorems.

## The loop

Each packet moves through

`seed -> formalizing -> proving <-> breaking -> certified`

with side exits `refuted`, `known`, `blocked`, `inconclusive`, `quarantined`,
and `superseded`.
Only `certified` will eventually mean that this repository may depend on the result.  A proof
written by its builder is still `proving` until an independent breaker records
an audit.  A numerical pattern is never promoted by repetition alone.

**Certification, refutation, and literature-certification transitions are
currently disabled in code.** They remain under the legacy audited
`notes/`/`code` process until evidence manifests, dependency invalidation,
review lineage, and immutable history are actually validated.

The generative cycle is:

1. **Tension.** Select two results, languages, or solved/open cases that appear
   incompatible or unrelated.
2. **Rosetta normalization.** Seek the smallest common lift, common quotient,
   duality, completion, localization, boundary map, or invariant.  Record what
   every map preserves and destroys.
3. **Exact statement.** Replace the suggestive relation by a proposition with
   explicit hypotheses and quantifiers.
4. **Proof and break in parallel.** The builder minimizes the argument; the
   breaker attacks definitions, edge cases, hidden regularity assumptions,
   numerical stability, and novelty.
5. **Typed certificate.** The packet declares in advance what could settle it:
   symbolic proof, exact finite computation, formal proof, asymptotic estimate,
   literature identification, counterexample, or a stated mixture.
6. **Transport.** If certified, compare its proof DAG with a solved isomorph.
   The difference becomes a new packet naming the missing structure.
7. **Dissolve and rotate.** Competing conclusions generate a common-object
   search.  Each wave includes one vocabulary deliberately absent from the
   current corpus.

Refutation does not upgrade the surrounding framework.  It terminates this
packet.  Any repaired statement is a new packet linked under `supersedes`.
This prevents self-correction from becoming self-sealing confidence.

Status transitions are intended to be append-only JSON under
`collab/discovery/events/`; today this is a git convention, not a cryptographic
or server-enforced append-only log.
Each event binds the exact-statement hash, actor role, model/context lineage,
reason, and artifacts.  Validity and novelty are orthogonal: autonomous agents
may record `searched-not-found` or `possibly-new`, never `novel`.  Every packet
has a cycle budget; exhaustion means `inconclusive`, not perpetual reframing.

## Packet contract

Packets live in `collab/discovery/claims/RNNNN-slug.md`.  Their front matter is
machine-checked by `code/discovery_loop.py`.  Required sections are part of the
state machine, not documentation decoration:

- `Tension`: the apparent conflict or separation that generated the claim;
- `Rosetta bridge`: common object and typed maps;
- `Exact statement`: no metaphysical surplus;
- `Preservation ledger`: information preserved, forgotten, or introduced;
- `Proof obligations`: lemmas and dependencies;
- `Falsification`: cheapest decisive attacks;
- `Evidence`: proof, computation, or counterexample references;
- `Independent audit`: a genuinely separate derivation or implementation;
- `Prior art`: checked sources and novelty boundary;
- `Successor seeds`: what becomes possible or what repair is worth trying;
- `Event log`: append-only status transitions.

Run:

```text
python3 code/discovery_loop.py validate
python3 code/discovery_loop.py list
python3 code/discovery_loop.py next --role breaker
python3 code/discovery_loop.py prompt R0001 --role transporter
python3 code/discovery_loop.py transition R0001 --to proving \
  --actor agent-name --role builder --lineage model-session-context \
  --reason "Exact statement and proof candidate completed" \
  --artifact notes/PROOF.md
```

The script does not prove mathematics or choose taste.  It enforces the
load-bearing distinction between an attractive sentence, a proved statement,
and a result the corpus is actually allowed to use.
