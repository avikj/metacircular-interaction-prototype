# Two identities — the compact expression

**Status: compression of the corpus into one law, one theorem (proved, finite
case), one test. Written under the standing assumption that it is incomplete;
§4 states what this compression itself destroys.**

## 1. The expression

Every object in this program has two identities:

- the identity it is **generated** with — closure under its rules, from below
  (term, derivation, construction, syntax);
- the identity it is **observed** with — indistinguishability under its
  probes, from above (profile, behavior, sieve state, e-class).

All the mathematics lives in the gap between them. The gap is never noise:
it is an **action** — parity, charge, proof-path, order, provenance — and
the corpus's one law is:

> **What a projection destroys returns as an action on its fibers.
> Completion adjoins the minimal carrier on which that action lives
> natively. A completion is real only if it lowers the cost of what comes
> after — this process included.**

One instantiation per strand, one line each:

| strand | generated identity | observed identity | the gap (action) |
|---|---|---|---|
| sieve arithmetic | full factorization | sieve profile below √X | one charge bit; 2^k on k forms |
| Liouville/parity | multiplication | every quotient/averaging | sign, visible only to order |
| kernel L0–L2 | term address | e-class | proof-path homotopy class |
| Voevodsky | raw generated syntax | definitional equality | initiality of the term model |
| the network | a node's derivation | a node's compressed report | provenance; who can still interpret |
| the protocol | P₀…P₃ themselves | each protocol's outputs | the extrinsic element deleted next |

## 2. The theorem (compression relativizes; it never silently destroys)

Setting: a finite rule system `S` with term model `T = Cl_S(∅)`
(`machinery/initial_crystal.py`), initial in the category **M** of its
models: every `M ∈ M` receives a unique homomorphism `h_M : T → M`.
Let `Θ` be any congruence on `T` — in practice the **observational**
congruence: the greatest congruence contained in `ker(o)` for a probe
family `o`, computed by refinement (`NATURAL_CRYSTAL.md`).

**Theorem (relativized initiality).** `T/Θ` is initial in the full
subcategory `M_Θ ⊆ M` of models `M` with `ker(h_M) ⊇ Θ`, and receives or
sends **no** homomorphism witnessing initiality outside it: a model `M`
admits a homomorphism `T/Θ → M` iff `M ∈ M_Θ`.

*Proof.* If `ker(h_M) ⊇ Θ`, then `h_M` factors uniquely through the
quotient map `q : T → T/Θ` (first isomorphism theorem for algebras),
giving `g : T/Θ → M` with `g∘q = h_M`. Uniqueness: any `g′ : T/Θ → M`
yields `g′∘q : T → M`, which equals `h_M` by initiality of `T`; since `q`
is surjective, `g′ = g`. Conversely, if any homomorphism `g : T/Θ → M`
exists, then `g∘q = h_M` (initiality again), so
`ker(h_M) ⊇ ker(q) = Θ`, i.e. `M ∈ M_Θ`. ∎

**Reading.** Compression never destroys universality *silently*: it
**relativizes** it. Quotienting by what your observables cannot
distinguish keeps you initial — but only in the world of models that
already validate your identifications. The models excluded — `M \ M_Θ` —
are the charge, made external and exact. The sieve row of the table is
this theorem verbatim: the sieve quotient is universal for every task
blind to parity, and the parity-sensitive tasks are precisely the
excluded models; the one recovery bit is the minimal re-adjoined carrier.
The network row likewise: a node may compress iff every node that must
still interpret it validates the identification — compatibility is
`ker(h) ⊇ Θ`, checkable, not social.

## 3. The test

A proposed completion (new carrier, new edge kind, new joint object) is
accepted iff an **independent** problem thereafter costs strictly fewer
kernel steps, by exact counters, with a null control that does not move
(`runtime/CRYSTAL.md` §0). A completion that merely renames the gap is
metadata and is rejected by the counters, not by taste.

## 4. What this compression destroys (own-law audit)

This note is itself a quotient of the corpus, so it owes its fiber:

- **Analytic content.** The frontier constants (`0.6725/0.83625`), the
  Hahn/Bessel bridge, the all-height obstructions (`DCLOSE_NO_GO.md`) are
  not instances of the law; they are hard analysis the law only frames.
  Excluded models, honestly listed.
- **Higher identity.** The theorem is set-level. When identifications
  themselves must carry paths and coherences (descent, the gluing
  obstruction program of U0006), a set quotient destroys exactly the data
  of interest; the correct carrier is a higher quotient, and no current
  repo theorem forces that need (madhavi's boundary,
  `to_vajra_voevodsky_boundary.md`). Open, and marked.
- **General initiality.** `T` initial is proved here for finite Horn-style
  closure; Voevodsky's Initiality Conjecture for dependent type theory
  with binders remains the ancestor obligation, not discharged by §2.
- **Cost of the quotient itself.** §2 says nothing about whether computing
  `Θ` is cheaper than living with the gap; the counters (§3) decide that,
  per instance.

## 5. The short path this opens

The compatibility question that was the corpus's "exact next theorem"
(`VOEVODSKY_TERMINAL_PROGRAM.md` §end) is answered in the finite case by
§2 in its sharpest form: **behavioral collapse preserves the universal
interpretation property relative to exactly the models validating the
collapse — no more, no less — and the excluded models are enumerable in
the finite case.** What remains is not conceptual but constructive:
exhibit, inside the runtime, one live pair (rule system, probe family)
where `M_Θ ≠ M` and the excluded model is a task the fleet actually
runs — making the charge a measured cost, not an allegory. That is a
construction with a null control, and it closes the loop between
§1's table and §3's test.

**Landed** (`machinery/relativized_initiality.py`, 16/16 hostile tests):
exhaustively over all 602 admissible pointed unary algebras with ≤4
states, `T/Θ` receives a homomorphism iff `Θ` is validated — 390 in-class,
**212 excluded** — with parity the concrete excluded task (no map exists,
verified by enumeration), the in-class task strictly cheaper (17 < 20
counter steps, same answer), the charge completion `T/Θ × parity ≅ T`
verified by executable CRT round trip, the null control (trivial
congruence) moving no counter and excluding nothing, and two planted-false
controls caught.
