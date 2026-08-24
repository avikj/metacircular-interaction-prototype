# Architecture

*For engineers and system builders. Every component below names its
source file; "BUILT" and "DESIGNED" are kept strictly separate. See
[RESULTS](RESULTS.md) for the theorem inventory and measured numbers.*

---

## 1. The substrate: computing univalence

The proof layer is **cubical Agda** (`formal/cubical/`, flags
`--cubical --safe`: no postulates, no holes, no unchecked escape hatch).
The load-bearing property is that **univalence computes**: `ua`'s β-rule
reduces, so `transport (ua e)` evaluates. An equivalence between two
representations is therefore not a citation — it is an executable
channel that carries any theorem or datum across, in both directions,
on the nose. This is what makes "the same mathematics in two forms" a
zero-cost, mechanically-checked operation rather than a re-implementation.

The organizing law (`punaragamana/src/Punaragamana/Carrier.agda`): for
`f : A → B`, ask which side of `f a ≡ b` is bound.

- Bind the output: the fiber is `singl (f a)` — contractible, always.
  A datum can carry its image and the witness that it *is* the image at
  zero informational cost (`A ≃ Carrier f`). This is the wire format:
  **base + carried + witness** — self-certifying data.
- Bind the input: the fiber is `fiber f b` — arbitrary, and usually the
  object of interest. Loss, memory, charge, and price are all readings
  of this fiber (`machine/AtmaJnana_….md` for the six-faces map).

Two derived disciplines, both checked:

- **Every transport owes its residual**
  (`formal/cubical/NaturalMachine/SankramanaSesa_….agda`): "lossless"
  is precisely "every residual contractible" — which is the definition
  of `isEquiv` — so a no-loss claim carries a proof obligation, and
  where standpoints disagree the loss provably cannot be summarized by
  one object (the record stays pointwise).
- **Two-valued verdicts are an error, as a theorem**
  (`formal/cubical/Saptabhangi.agda`): asserting presence and absence
  *simultaneously* is proven distinct from asserting them sequentially,
  so the honest verdict lattice has seven positions, and a boolean on
  a wire is a discarded distinction.

## 2. The autonomous loop (BUILT, running)

Driver: `machine/Sphatika_TheCrystalGrowsByItsOwnStallsAndEveryTheorem
StrengthensTheNext.hs` (Haskell, a *driver only* — it introduces no new
term type and no proof logic; it connects three pre-existing organs).

```
                     ┌────────────── SENSE ──────────────┐
                     │  Sanghatta: Knuth–Bendix critical  │
                     │  pairs of the installed rules →    │
                     │  the equations rewriting cannot    │
                     │  close = the frontier               │
                     └────────────────┬───────────────────┘
                                      ▼
   ┌──────────── PROVE ───────────────────────────────────────┐
   │  KernelContext: an ordered lemma list where each lemma    │
   │  may cite any earlier one (PCite). Shapes tried per goal: │
   │  refl → cite → structural induction (3 step forms), all   │
   │  judged concurrently, 4-wide. A landing appends to the    │
   │  crystal (machine/sphatika.crystal) and re-renders the    │
   │  whole store as one kernel-checked module                 │
   │  (formal/cubical/Sphatika.agda).                          │
   └──────┬──────────────────────────────────┬────────────────┘
          │ landing                           │ stall
          ▼                                   ▼
   ┌─ INSTALL ────────────┐   ┌─ RESIDUAL ─────────────────────┐
   │ installRules: the    │   │ Obstruction: parse the kernel's │
   │ landed equation      │   │ stall text back into terms; the │
   │ enters library.terms │   │ residual is triaged (refutation │
   │ as a rewrite rule →  │   │ by exact evaluation turns back  │
   │ next SENSE derives   │   │ false parents) and enters as    │
   │ NEW critical pairs   │   │ the next goal; the parent       │
   └──────────────────────┘   │ retries when the crystal grows  │
                              └─────────────────────────────────┘
```

Loop mechanics, each with its doctrine written at the site:

- **Single-writer lock** on the crystal; a second driver turns back.
- **Retry gate**: a refused goal is retried only when the crystal has
  grown (a conjecture is not re-asked until the machine knows something
  it did not know when it failed).
- **Termination**: pass fixpoint (a full pass landing nothing ends the
  run) + per-goal call budget + finiteness of the residual set — NOT a
  descent argument (residuals can be larger than parents; the header of
  `machine/Obstruction.hs` refutes the tempting kuṭṭaka reading).
- **Supervision**: `machine/sphatika-rounds.sh` runs
  prove→install→sense to completion-fixpoint;
  `machine/sphatika-forever.sh` loops rounds and commits/pushes the
  machine's own artifacts. No agent in the loop.

## 3. The exchange (BUILT, fired once)

`--exchange PEER-CRYSTAL` mode of the same driver: a peer's rows are
candidates whose proofs are already written. The receiver **re-judges
every row through its own kernel**, remapping citations as their
targets are adopted (peers cite only earlier rows, so one ordered pass
suffices), and receipts refusals. Demonstrated: a fresh node adopted a
200-theorem crystal with zero trust in the sender. This is the network
primitive: verification is local, so authority is unnecessary.

## 4. The runtime specification (BUILT in exile, criterion MET)

`legacy/runtime/CRYSTAL.md` + `legacy/runtime/` — the full design for a
CPU-native proof-carrying runtime, with a seed implementation whose
falsifiable criterion **passed** (see RESULTS §3). Layers:

- **L0** — content-addressed identity: address = hash of elaborated
  term + dependency addresses; names are mutable views (the Unison
  model, independently required here by univalence: names are gauge).
- **L1** — a typed edge lattice (11 kinds: Eq, Iso, Embed, Quotient,
  Implies, Approx(ε), Refine, Interp, Dual, Order⟨≤⟩, Conjecture), each
  with its own composition law and preservation guarantee. Two
  hard facts live in the table: `Iso` does not preserve `sign`
  (Galois conjugation exchanges the orderings of ℚ(√2)), and no path
  through a `Quotient` delivers parity.
- **L2** — a proof-relevant e-graph: union-find + congruence closure +
  a Nieuwenhuis–Oliveras proof forest; **multiple distinct paths
  between the same nodes are kept** (distinct automorphisms are
  content, not redundancy); directed edges never merge classes.
- **L3** — execution: accepted equalities become rewrites, isos become
  transports, with route selection over a cost *vector* (no scalar
  fitness).
- **L4** — incremental consequence propagation (exact dependency cones).
- **§3.1 crystallization** — mine repeated sub-derivations across
  different proofs, anti-unify (Plotkin/Reynolds), kernel-check the
  generalization, install one edge where k steps were.
- **§3.2 distinction compilation** — a collision (`observe(x) =
  observe(y)` but `task(x) ≠ task(y)`) is the specification of a
  missing distinction; find the minimal separating channel, prove
  sufficiency, install.

The seed is implemented in Python and therefore lives in `legacy/`
under this repository's language policy; the standing rule
(`notes/Dahana_…`) is that such components are re-landed as checked
terms whose extraction is the executable, then the original is deleted.
The specification and the measured results are current; the
implementation language is the only exiled part.

## 5. The self-modification gate (BUILT as theory, wiring owed)

`formal/cubical/NaturalMachine/Nirjara_SheddingAPrimitiveCostsLaghava.agda`:
the `Anujna` (licence) record — a transformation of an ordered
derivation is admissible iff it carries, inside itself, proofs of
meaning-preservation and cost-non-increase. Licences compose; a
conflict-resolved list of individually-licensed rules is itself
licensed; the inadmissible move *inhabits no licence* (not "fails a
check" — the record cannot exist). The cost measure is Pāṇinian:
count the rules that write a term, not the occurrences that use it —
proven stable under exactly the classical economy devices (anuvṛtti,
pratyāhāra, apavāda) and unstable for naive size. This is the type of
lawful self-modification; instantiating it on the live loop's growth
moves is designed, not yet wired.

## 6. Trust boundary, stated plainly

Trusted: the Agda kernel (and, in the exiled runtime, term encoding,
typechecking, content addressing, Eq/Iso/β checking). Everything else —
drivers, stores, indices, this documentation — can be wrong without
corrupting the kernel, and the architecture's one absolute is:
**no candidate may rewrite the kernel that judges it.**
