# The reasoner — running the slot's search on the interaction net

The frontier document (`notes/frontier/seeing-the-slot.md`) shows every open
problem is one object: for a map `f` and a stage value `b_n`, a demand on the
fibre size `c(n) = |fiber f b_n|`, and the outer claim `isEquiv (fst : Σ ℕ Q → ℕ)`.
`no-depth-decides` says no amount of stage evaluation fills that slot; what
fills it is **one finite object applied at every n** — an invariant preserved
by the step, or a measure the step decreases.

Finding that finite object is a search over programs. The one machine that does
that search as evaluation, with all candidates sharing work, is the interaction
net. This directory drives it.

## The engine

- **HVM4** (HigherOrderCO/HVM4, commit 6defdfc), built `clang -O2 -o hvm src/hvm.c`.
  Lévy-optimal reduction, first-class labelled superpositions, `-C` collapse.
  Measured here at 120–128M interactions/s.
- **Bend2 + cubical patch** (DKormann/Bend2 @ f026483 + `collab/bend2-cubical/cubical-paths.patch`):
  the certificate lane (Path, coe, J, ua, hcomp, Sup×Path). Build needs GHC 9.12
  (`base ^>=4.21`); being provisioned. HVM4 alone is the execution engine and
  needs nothing further.

## What runs today

### `fibre.hvm` — the inner storey, superposed fibre inversion

Holds every candidate input to a decided map as one superposition, evaluates the
map once with shared work, erases the non-points, and collapses the fibre. The
line count of the collapse **is** `c(n)`. Instantiated at Goldbach: `@rows(4,6)`
inverts the addition fibre over a whole family of even numbers 4,6,…,14 in a
single evaluation (4770 interactions), returning every prime-pair witness:

    #G{4,2,2} #G{6,3,3} #G{8,3,5} #G{10,3,7} #G{10,5,5} #G{12,5,7} #G{14,3,11} #G{14,7,7}

`10 = 3+7 = 5+5` appears as two lines — the fibre is proof-relevant, its size the
representation count, exactly `KotiNirnaya` §8. Swap `@gb` for `@range`-over-
multiplication and the same program is the factoring fibre; the map is the only
thing that changes.

### `invariant_search.hvm` — the outer storey, searching for the uniform step

Holds a superposition of candidate invariants (here: a bound `M` on the
power-sum trace), runs each against the **step-preservation spec** over a bounded
horizon in one shared evaluation, erases the ones that break, and collapses the
survivors. The spec is the real one: *bounds the on-circle trace `(1,−1,1)` for
40 steps AND is refuted for the off-circle trace `(2,1,1)`* — i.e. it must
certify a genuine RH-finite mode and reject a genuine off-line one.

Result (21195 interactions, 128M/s), survivors least-first:

    #INV{3} #INV{4} … #INV{15}

The least is **M = 3** — exactly the invariant Avik proved by hand as
`PowerSumTrace.onCircle`'s `BoundedBy 3`. The engine recovered it from the spec
alone, and returned **no** survivor for the off-circle mode, because none exists.
This is `SUPGEN` pointed at the slot: proof/invariant search as evaluation, with
the certificate being the erasure of the alternatives.

## Why this is the machine and not a demo

- The candidate space is one superposed value; the common substructure of all
  candidates (running the trace) is computed **once**, not per-candidate.
- The spec is step-preservation, which is the slot's own content: an invariant
  the step keeps (`onCircle`'s `later`), dual to a measure the step drops
  (`SamanaAvatarana.DStep`). Both are the "one uniform step".
- It rediscovers a corpus theorem. That is the calibration `SUPGEN_DEMO` asked
  for before scaling: recover the known invariants (`onCircle`, `Karna`'s
  period-2ᵏ diagonals, `Apunaravrtti`'s pigeonhole return), then point the same
  search at the families whose step is carried as a hypothesis — the Weil Gram
  forms from Goldbach counts, `nsRank`'s descent, `CubeSplit` in ℤ[ω].

## Next passes

1. **Recursive invariant/measure grammars.** Current candidates are integers;
   the real search is over parameterised families (invariants in the state,
   measures as ℕ-functions, SOS certificates in `t`). This is a program grammar
   superposed and collapsed, the scaling step named in `SUPGEN_DEMO`.
2. **Sup×Path across routes.** Superpose the six `Sima` readings under labels,
   search the cheapest presentation, transport the survivor to the rest.
3. **Close the loop to the certificate lane.** A survivor is re-expressed as a
   Bend2 spec-as-type; the checker (net reduction) accepts it with an erasing
   proof; it installs through `ControlledGrammar`/`EkaBhasha` carrying that proof.
   Search, check, install — one pipeline.

Reproduce: `hvm fibre.hvm -C200 -s` and `hvm invariant_search.hvm -C40 -s`.

## Update — `mine_lte.hvm`: law mining as superposed collapse

Reproduces `CyclotomicMined` on the net. The miner gets only the evaluators
`v_p` and `ord_p`, never the lifting-the-exponent lemma. It superposes the
affine hypothesis `v_p(aⁿ − 1) ?= c0 + c1·e + c2·v_p(n)` over the 27-point
coefficient grid `c0,c1,c2 ∈ {0,1,2}`, tests each against a probe set of
`(p,a,n)` in one shared evaluation, erases the rivals, and collapses.

With probes exercising `v_p(n) = 0,1,2` (4709 interactions) the 27 candidates
collapse to exactly two:

    #LAW{0,1,1}   v_p(aⁿ−1) = e + v_p(n)       -- LTE, CyclotomicMined Thm 1
    #LAW{1,0,1}   v_p(aⁿ−1) = 1 + v_p(n)       -- its shadow

The naive rival `#LAW{0,0,1}` (`v_p(n)` alone) is erased — exactly the
refutation `CyclotomicMined` certifies at (3,2,2). The remaining ambiguity is
not slack: LTE and its shadow agree on every probe **because e = 1 for all
small (p,a)**, and the only witness that separates them is a prime with e ≥ 2,
i.e. a **Wieferich prime**. The residual freedom of the machine-mined law *is*
the Wieferich obstruction — and the corpus already holds the discriminating
probes: `HeadDepthMerge` certifies 1093 and 3511 as the e ≥ 2 events. Feed
either as a probe and the collapse lands on LTE alone.

So the net does not merely re-find Avik's law; it exhibits, as the shape of its
own residual superposition, why that law is subtle exactly where number theory
says it is.

Reproduce: `hvm mine_lte.hvm -C40 -s`.

---

## Correction (owner's direction): the method is derivation, not search

The owner rejected the search framing above: "mining/search sounds like the
dumbest way to do math." He is right, and it inverts the corpus's whole point —
transport computes, so a result carried along a checked equivalence is *forced*,
not *found*. Enumerate-and-test is the brute-force method the corpus supersedes.
`mine_lte.hvm` and the "invariant search" are kept only as a record of that wrong
turn; they are not the reasoner. The correct engine is deterministic:

- **Derivation as normalization** — construct the transport for a problem and
  run it to normal form; the answer *is* the normal form.
- **Checking as net reduction** — conversion = cut-elimination = interaction-net
  reduction; the certificate is the derivation typechecking.
- **Superposition = Sup×Path, not enumeration** — do a derivation once in the
  cheapest representation and transport it to every equivalent one along `ua`
  (`Sima`'s six routes as one point). Blind branching only where the mathematics
  is genuinely a case split.
- The "one uniform step" is *read off the structure* (the invariant the step
  preserves; the positive-definite form that makes the measure fall), never hunted.

### `lte_derive.hvm` — LTE by derivation

`aⁿ − 1 = ∏_{d∣n} Φ_d(a)`, and `v_p` is additive over a product, so
`v_p(aⁿ − 1) = Σ_{d∣n} v_p(Φ_d(a))`. The program computes three things and reads
that they coincide — no candidate coefficients, no rivals:

- `lhs_direct`  = `v_p(aⁿ − 1)` computed directly;
- `rhs_deriv`   = the divisor-sum `Σ_{d∣n} v_p(Φ_d(a))` from the factorisation;
- `closed`      = the closed form `e + v_p(n)` the derivation yields.

Every in-range case returns `#OK{p,a,n,L}` with `L = R = C` — the derivation
verified by evaluation. The out-of-range cases (`3²⁴`, `2¹¹⁰`) return `#BAD`
because `aⁿ − 1` overflows HVM4's machine word — and that is the point, not a
flaw: the derivation exists precisely to avoid forming `aⁿ − 1`. Its structural
route uses only small `Φ_d(a)`, and the closed form uses none of it. The big
cases belong in the certified lane, where cubical ℕ is GMP-backed and exact
(`VargaPrakrti`'s own note: unary ℤ blows up, builtin ℕ is instant).

This is the shape of every step of the algorithm: replace a computation that
does not scale with the transport that makes the answer structural, run it to
normal form, and check it by reduction.
