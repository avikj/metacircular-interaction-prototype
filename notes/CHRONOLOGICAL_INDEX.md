> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# Chronological index of the repository

**Purpose.** A forward pass through the repository in the order things actually
happened, recording what each artifact is and what it says. No ranking, no
verdict, no analysis. Where a file states its own status, that status is quoted
rather than restated.

**Method and its limits.** First-appearance times come from
`git log --diff-filter=A` over all 5231 tracked files; the 70 files whose
addition is hidden inside a merge were dated by a per-file query. **All times
below are UTC.** This matters: the first day's commits arrive from two clocks
(`-07:00` and `+00:00`), so the raw `git log` string order is not the true
order. Converting to UTC reorders the first day substantially — see §1.

Commit totals by day (3350 commits, six days):

| day | commits | files first appearing |
|---|---:|---:|
| 2026-08-11 | 334 | 658 |
| 2026-08-12 | 901 | 1978 |
| 2026-08-13 | 368 | 461 |
| 2026-08-14 | 1453 | 1647 |
| 2026-08-15 | 232 | 334 |
| 2026-08-16 | 62 | 153 |

This file is written in a forward pass and is incomplete below the point
marked CURSOR. Everything above the cursor has been read; nothing below it has.

---

## 1. Day 1 — 2026-08-11

### 08:55Z — the repository exists

`README.md`, initial commit `5b902508`. One file.

### 09:44Z–10:45Z — the entire pair-field corpus lands in one hour

This is the single densest hour in the repository's history and it is an
import, not a derivation: a body of work that already existed arrives at once.
In UTC order:

- **09:44:57Z** `5b902508`→`50ff7c24` — `notes/REPORT.md`, `code/exp1_rigidity.py`,
  `exp1b_bigfactor.py`, `exp2_bridge.py`, `exp3_fujii.py`, `exp4_singular.py`,
  `exp5_zerofield.py`, `exp6_additive_energy.py`, `exp6b_sumspectrum.py`,
  `code/pairfield.py`, `data/exp1b_out.txt`, and
  `data/odlyzko_zeros_100k.txt` (the first 100,000 Riemann zeros, accurate to
  3·10⁻⁹). Commit subject: *"Prime pair field: adversarial assessment, four
  theorems, numerical verification."*
- **09:54:12Z** — `code/exp7_racetics.py`, `data/exp7_out.txt`,
  `data/exp7_ties.txt`, `notes/APPENDIX_D.md`. Subject: *"Add race-tie scan
  (exp7), Theorem D″ proof appendix, Parseval closure."*
- **10:04:34Z** — `notes/ADELIC.md`, `code/exp8_adelic.py`.
- **10:12:10Z** — `notes/PARITY.md`, `code/exp9_crossover_L.py`,
  `code/exp10_parity.py`.
- **10:25:44Z** — `notes/GAUGE.md`, `code/exp11_gauge.py`.
- **10:31:33Z** — `notes/BLOCKS.md`, `code/exp13_blocks.py`.
- **10:34:50Z** — `code/exp1c_bigfactor2.py`, `data/exp1c_out.txt`.
- **10:40:24Z** — `notes/CORE_KMS.md`, `code/exp12_screw.py`,
  `exp15_divisor.py`, `exp16_energy.py`, `exp19_ternary.py`,
  `exp7b_ties_extended.py`.
- **10:40:53Z** — `notes/TERNARY.md`, `data/exp7b_out.txt`.
- **10:43:56Z** — `notes/RIGIDITY_FRONTIER.md`, `code/redteam_poly.py`,
  `site/index.html`.
- **10:44:18Z** — `code/exp17_dside.py`.
- **10:45:37Z** — `notes/SCREW.md`, `code/redteam_sumspectrum.py`.

What is in that hour, by the files' own statements: the pair field
`K(w,d)=a_{w−d}a_{w+d}` and its two marginals; the deflationary boundary
(`REPORT §1`: the field is rank-one `a⊗a` in rotated coordinates, `Z=|P|²≥0`
holds for arbitrary real sequences, and the integral isometry group of
`S²−D²` is finite); Theorem A (sum-marginal injectivity, difference-marginal
homometry kernel); Theorem C (heat-smoothed Goldbach ⟺ RH, two-line proof);
Theorem D and D′ (Goldbach data displays the sum spectrum of the zeros;
`|W|≍(γ+γ′)^{−5/2}`); Theorem D″ (variance ⟺ weighted additive energy,
conditional); Theorem F (`GAUGE`: the parity barrier as a protected gauge
sector of the unique KMS state of Cuntz's `Q_ℕ`); `CORE_KMS` closing the
neutral-core escape; the block decomposition `G₁=[♯♯]+2[♯♭]+[♭♭]`; the
ternary calibration; the divisor calibration; the screw-function join with its
own refutation already recorded; `RIGIDITY_FRONTIER` opening the factor-degree
programme. Two `redteam_*.py` files land in the same hour as the work they
audit.

### 11:02Z onward — a second lineage arrives and the factor ladder runs

`collab/messages/0002` opens *"Thanks for the welcome"* and is signed
**Codex (session 1)**. From here the day is one agent working a single
programme, in order, one degree at a time.

- **11:02:39Z** — msg `0002`, `notes/BUCHSTAB_WINDOW.md`,
  `code/exp20_buchstab.py`. Codex arrives with an independently developed
  finite-sieve line. Central correction it brings: the periodic finite-adic
  density `ν_W` has mean `e^γ ω(u)`, **not one**, on `[1,X]`. Six numbered
  results including the exact Ramanujan martingale `E(ν_Q | mod W)=ν_W` and
  the critical fourth-energy asymptotic with `I_arch=0.181474529…`. Asks to be
  attacked at two named theorems.
- **11:06:56Z** — msg `0003`, `notes/PRODUCT_WEIGHT_NO_GO.md`. Type:
  *challenge*. Takes `SCREW §4`'s product-weighted pair object and returns a
  classification theorem: universal factorization of `Γ(z)Γ(w)/Γ(z+w)·k̂(z+w)`
  forces exponential heat kernels, which are already separable. The
  Matsumoto–Suzuki weight is not of that form. Records its own scope limit
  (formal Mellin variables; does not exclude a spectrum-dependent kernel).
- **11:08:46Z** — msg `0004`, `notes/CENTERING_ATOMS.md`. Reconciles a
  relayed Web ChatGPT research state (sections I–XII) against the branch
  rather than importing it. Finds no conflicting theorem; corrects the scope
  of section XI (one-body Lebesgue centering changes transforms, never exact
  atomic coefficients).
- **11:45:14Z** — msgs `0009` and `0010`, `notes/WOLFRAM_LENS.md`. `0009`
  independently confirms the crossover second-order constant
  `κ₂ = γ₁ + γ²/2 = 0.0937731164…`, then **narrows its own statement**: the
  fixed-order summation proof does not by itself give the uniform
  `O(e^{−c√log z})` remainder; three audits recover it by truncating at
  `N ≍ √log z`. `0010` records the Wolfram pass: finite-prime sieve levels are
  exact modular automata, CRT tensors them, normalized accepted-state traces
  are the partial singular series; and two explicit no-go boundaries
  (confluence does not imply causal invariance, Piskunov; no Wolfram result
  gives computational irreducibility of the primes, Israeli–Goldenfeld).
- **12:14:00Z** — msg `0011`, `notes/CYCLOTOMIC_TRACE.md`. Relative trace
  `Tr_{ℚ(ζ_m)/ℚ(ζ_{m/p})}(ζ_m^a)` vanishes unless `p|a`; every non-squarefree
  modulus is impossible at every cutoff. Strictly strengthens a former `4|m`
  parity theorem and all machine checks through `m=1000`. Reduces the global
  conjecture to squarefree `m`.
- **12:15:28Z** — msg `0012`, `notes/SHARP_CUTOFF.md`. Riesz descent
  `A₀=(2+∂_u)A₁`; weights in `ℓ^p` exactly for `p>4/3`; absolute near-diagonal
  energy diverges at every fixed resolution with `E^abs_{≤H}(η) ≫ η(log H)⁵`.
  Consequence recorded: the Appendix-D variance route **cannot** be desmoothed
  to `k=0`.
- **12:43:37Z** — msgs `0013`, `0014`, `code/exp28_squarefree_ties.py`. The
  squarefree half closes: forced residue vector → covering congruence →
  Bertrand reduction to `m=P` or `2P` → one corollary of Hajdu–Saradha (2016)
  Thm 2.3. Result: `Φ_m | F_X ⟺ (X,m)=(3,2)` or `(11,6)`, for all `m`.
  *"Computation is no longer load-bearing."*
- **12:54:44Z** — msgs `0015`, `0016`, `notes/CUBIC_OBSTRUCTION.md`,
  `papers/prime_prefix_cyclotomic.md`. Cubic layer closed with no
  prime-distribution input. With the cyclotomic theorem: every irreducible
  factor of `F_X` for `X≥13` is non-cyclotomic of degree ≥ 4. First paper
  drafted.
- **13:25:50Z** — msgs `0017`, `0018`, `notes/PARITY_RESULTANT.md`,
  `code/exp29_quartic_resultant.py`, `exp30_quartic_certificate.py`. Quartic
  closed.
- **13:44:12Z** — msg `0019`, `notes/QUINTIC_OBSTRUCTION.md`,
  `code/exp31_quintic_certificate.py`.
- **14:01:59Z** — msg `0020`, `notes/RECIPROCAL_SEXTIC.md`,
  `code/exp32_reciprocal_sextic.py`.
- **14:19:32Z** — msg `0021`, `notes/SEXTIC_OBSTRUCTION.md`,
  `code/exp32_sextic_certificate.py`.
- **14:40:57Z** — msg `0022`, `notes/SEPTIC_OBSTRUCTION.md`,
  `code/exp33_septic_certificate.py`.
- **14:52:52Z** — msg `0023`, `notes/RECIPROCAL_OCTIC.md`,
  `code/exp34_reciprocal_octic.py`.
- **15:02:15Z** — msg `0024`, `notes/RECIPROCAL_RESULTANT.md`,
  `code/exp35_reciprocal_resultant.py`. The low-degree square factorizations
  are collapsed into one all-degree theorem: for reciprocal `g=E(x²)+xO(x²)`
  and `T=y+y⁻¹`, `Res(E,O)=E(−1)Res(A,B)²` in degree `4k` and
  `(−1)^k B(−2)Res(A,B)²` in degree `4k+2`; hence `g(i)∈{±1,±i}`. 3,000 exact
  cases checked through degree 14. *"No novelty claim pending a dedicated
  classical-literature comparison."*
- **15:16:29Z** — `notes/ASYMPTOTIC_FACTOR_RIGIDITY.md`.
- **16:22:01Z** — `notes/FF.md`.
- **16:28:52Z** — `notes/DCLOSE_NO_GO.md`.
- **17:02:39Z** — `notes/PARITY_RIGIDITY.md`.

### 17:20Z — the infrastructure arrives

`.github/workflows/epistemic.yml`, `code/discovery_loop.py`,
`code/tool_probe.py`, `code/wolfram_bridge.py`, `code/wolfram_probe.wls`,
`collab/discovery/README.md`, the first claim packet
`R0001-character-anchor-rigidity.md` and its `created` event,
`collab/discovery/manifests/README.md`,
`collab/discovery/schema/claim.schema.json`, `machinery/README.md`,
`machinery/specs/nonic-prime-prefix.json`, `machinery/validate.py`,
`notes/MATH_OS.md`, `notes/ROSETTA_ENGINE.md`,
`requirements-discovery.txt`.

Nine hours after the repository exists, the claim registry, the JSON schema,
the validator, the CI workflow, the Wolfram bridge, and two design notes named
`MATH_OS` and `ROSETTA_ENGINE` all land in one commit.

- **17:24:20Z** — `R0002-nonic-prime-prefix.md` and its `seeded` event.
- **17:29:09Z** — `formal/cubical/ProjectionChargeAudit.agda` (first Agda file
  in the repository), `notes/CUBICAL_QUOTIENT_AUDIT.md`,
  `notes/PROJECTION_LEAKAGE.md`.
- **17:30:10Z** — msg `0033-codex-projection-cubical-octic-quarantine.md`.
- **17:41:58Z** — `formal/pairfield/Pairfield/CharacterAnchor.lean` (first Lean
  file), `notes/CHARACTER_ANCHOR_RIGIDITY.md`, `code/exp38_character_anchor_z2.py`,
  and R0001's `builder` event.
- **17:42:07Z** — `machinery/cpu_ledger.py`, `machinery/test_cpu_ledger.py`,
  `notes/WOLFRAM_ADOPTION.md`.

### What the 17:20Z commit actually contains

Two of the files in that commit state the project's design, on its first day,
more precisely than anything written about it since.

**`ROSETTA_ENGINE.md`** opens by refusing the obvious reading of its own name:

> The useful denial of "unrelated" is not the claim that everything is
> isomorphic. It is the stricter claim that **absence of a map is relative to a
> chosen category of objects and observations**. When two descriptions resist
> comparison, the first mathematical question is which change of category makes
> their common structure visible.

It then gives eight moves for building a bridge between two descriptions, and
for each one the obligation you incur and the way it characteristically fails:

| move | diagram | proof obligation | characteristic failure |
|---|---|---|---|
| common lift | A ← L → B | exhibit L and both maps | lift adds unconstrained structure |
| common quotient | A → Q ← B | compute both kernels/fibers | shared shadow mistaken for equivalence |
| dualize/transform | A ↔ A^∨ | inversion or full-faithfulness | phase, boundary, or domain is lost |
| localize | A → A[S⁻¹] | universal property and torsion kernel | local equivalence hides global obstruction |
| complete | A → Â | topology and density/injectivity | formal limit invents solutions |
| deform/continue | A_t | control singularities and endpoint | generic truth fails at the critical fiber |
| take boundary | bulk → boundary class | exact sequence/trace formula | boundary term silently discarded |
| change observer | state → accessible data | sufficiency and lost charge sectors | positivity or equality survives while truth does not |

Categorification and decategorification are iterated lift and quotient;
linearization is a representation-valued lift followed by a quotient;
renormalization is scale-indexed observer change plus a fixed-point question.

Its §2 is the instruction for what to do when two claims conflict: build the
square, compute the residual, and read the residual as the result rather than
choosing a side. *"The residual is often the theorem."* With worked readings —
failure to commute suggests a cocycle or a missing boundary term; a nontrivial
kernel identifies information destroyed by an observer; agreement locally but
not globally suggests an obstruction class; equal spectra with unequal objects
suggests phase or extension data; opposite inequalities often mean an
indefinite form whose primitive subspace has the correct sign.

And the exact condition under which a transformation survives a change of
description: `T` is well-defined through a quotient `q` precisely when
`q(x)=q(y) ⟹ q(Tx)=q(Ty)`. Failure is a noncongruence witness — a
round-trip defect when the setting is linear. Branches merge *"only under a
declared exact quotient (normal form, proved equality, finite character data),
never merely because a general simplifier says the endpoints look alike."*

§3 is seven composition rules, of which the load-bearing ones are: a theorem
transports only after every hypothesis is translated and checked; a projection
composes with a cumulative preservation ledger, so lost information never
reappears without an explicit new observable; an open bridge anywhere in a path
makes the whole transported conclusion open; analogies generate packets, never
conclusions. The closing sentence names what the discipline is for:

> This is the epistemic type system missing from an unqualified "Indra's net."
> The net is generative because every object may illuminate every other; it
> remains mathematics because every strand declares what it preserves.

**`MATH_OS.md`** states the target as *"a content-addressed mathematical
operating system in which many imperfect reasoners can generate at full speed
while a small trusted kernel controls what becomes reusable truth,"* with
*"language is program state for agents"* as the central retained insight: the
objects, roles, tensions and obligations stay readable prose, and code enforces
only the irreversible transitions.

Its authority lattice fixes the maximum status any kind of output can reach on
its own:

| output | maximum autonomous status |
|---|---|
| LLM explanation, analogy, CAS simplification | seed |
| float experiment or PSLQ relation | formalizing |
| exact CAS witness independently substituted | proving |
| finite exhaustive computation without proved reduction | proving |
| proof accepted by the Lean kernel | formal-verified, **not yet semantically aligned** |
| formal proof + alignment audit + blind breaker + prior-art manifest | certified internally |
| negative literature search | searched-not-found, **never novel** |

with the design reason stated: *"generation can be nearly free because promotion
is expensive and fail-closed."* Kernel verification, agreement with the English
statement, and novelty are three separate gates.

It also carries a center-of-gravity invariant that should be read alongside
`collab/upstream/raw/U0009.txt` rather than merged with it:

> The agent layer is the research intelligence, not temporary scaffolding to be
> compiled away. Frontier models choose important questions, invent languages,
> read the literature, notice structural tension, and interpret anomalies. CPU
> kernels only amplify a mathematical reduction the agents already understood.
> … Scaling CPU without a proved reduction, or scaling agents without extracting
> reusable invariants, are dual failure modes.

U0009 asks for the opposite emphasis — *"we must transfer kernels of
intelligence down towards traditional programs"* so that CPU rather than
language models does the work. Both are in the repository. They are recorded
here as two standpoints, not reconciled.

<!-- CURSOR: forward pass has reached 2026-08-11T17:42Z, plus the two design
     notes from the 17:20Z commit. Next: collab/messages/0038 onward through the
     17:45Z-19:15Z burst, then day 2. -->

