> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# The prior-art index: check here before you prove

**Status: infrastructure, installed and checked 2026-08-14.** Not mathematics.
Occasioned by the human owner's correction: *"you waste compute on solved
problems and don't even import all the most powerful machinery/existing
constructs. We need to stand on the shoulders of giants."*

The evidence that the correction lands, measured rather than conceded:

| | |
|---|---|
| cubical modules our corpus imports | **62 of 859 (7%)** |
| `Cubical.Categories` imported | **0 of 88** |
| `Structures` / `Displayed` / `Homotopy` / `Modalities` / `Cohomology` / `Codata` / `Reflection` / `Induction` | **0 of 206** |
| corpus notes carrying "likely folklore, no search performed" | multiple, across lanes |
| results caught as rediscoveries at audit time (`CLAUDE.md`) | three, before tonight |

`notes/FUTURE_BEHAVIOR_IS_COALGEBRA.md` is the sharpest instance: the
corpus's most-repeated construction is the minimal-realization theorem for
Moore coalgebras, re-proved under private names — and the same induction was
written **three times** in one module without anyone naming the final
coalgebra it was constructing.

## What is installed, and what it is for

```sh
git clone --filter=blob:none --depth 1 \
    https://github.com/UniMath/agda-unimath.git ~/agda-libs/agda-unimath
```

`~/agda-libs/agda-unimath` — 3035 modules, MIT, **239 in
`src/elementary-number-theory/`**. Confirmed present and directly adjacent to
this corpus's subject matter: `bezouts-lemma-{natural-numbers,integers}`,
`euclidean-division-natural-numbers`, `congruence-{natural-numbers,integers}`,
`modular-arithmetic-standard-finite-types`, `divisibility-modular-arithmetic`,
`factorials`, `binomial-coefficients`, `eulers-totient-function`,
`well-ordering-principle-natural-numbers`, `collatz-{conjecture,bijection}`,
`reduced-integer-fractions`, `fermat-numbers`.

**It is an index to consult, not a library to link.** It is `--without-K`
MLTT for Agda 2.8.0 and it *postulates* univalence; we are `--cubical --safe`
on Agda 2.6.3, where univalence is a theorem. Nothing here can be imported.
The port direction is favourable — transcribing a unimath proof into cubical
*removes* an axiom — but every transcription is work, and the point of this
file is the step **before** that: finding out whether the thing you are about
to prove is already proved.

## How to use it (the whole protocol)

Before opening a `PROVE` item, grep the index under the **standard** name for
the object, not our coined one. Our names are exactly what hide the standard
objects — that is the mechanism the coalgebra finding exposed.

```sh
ls   ~/agda-libs/agda-unimath/src/elementary-number-theory/ | grep -i <topic>
grep -rl "<standard-term>" ~/agda-libs/agda-unimath/src/ | head
grep -rn "<statement fragment>" ~/agda-libs/agda-unimath/src/elementary-number-theory/
```

A partial translation table, extend it as lanes find more:

| our name | standard name to grep |
|---|---|
| future-behavior quotient | Myhill–Nerode, syntactic monoid, final coalgebra, minimal realization, bisimulation |
| response-conditioned experiment tree | adaptive distinguishing sequence (ADS), decision-tree experiment, state identification in FSM testing |
| obstruction-indexed generation | conservative / definitional extension |
| leakage rank | commutator rank, principal angles, CS decomposition |
| confinement index | filtration depth in ℤ_p^× |
| torsor section | principal homogeneous space, non-canonical splitting |
| vallī trace | continued-fraction / Euclidean algorithm trace |
| `Alg`, `AlgHom`, comparison-type contractibility | **homotopy-initial algebra**, `NatAlgebra`/`NatMorphism`, `isNatHInitial` — *in our own pin*, `Cubical/Data/Nat/Algebra.agda` |
| `Tm` (the generative lane's terms) | `List`, free monoid, its universal property |
| `BSₙ`, `LinOrd`, the endian torsor | **concrete group**, delooping, `Aut_Set(bn n)`, `FinSet_n` — the *Symmetry* book, ch. 4 |
| `LinOrd′ X ≃ (X ≃ Fin n)` | `monoEquivOfFin` (mathlib4), `stn_ord_bij`/`height_stn` (UniMath, aborted), `Finite-Total-Order` (agda-unimath) |
| `c : (lim X)/G → lim(X/G)` | `colimitLimitToLimitColimit` (mathlib4, `ColimitLimit.lean:58`); "colimit" occurs in 2 of 507 notes |
| `CRYSTAL.md`'s rewrite engine | e-graph, equality saturation (egg), babble/library-learning, Adapton, CEGAR, LCF tactic kernel |
| decategorification (ours: π₀FinSet) | **not** the `math.RT` sense — Grothendieck group, whose interesting kernel ours lacks |
| `OBLIGATION.md`'s scope semilattice + edge transfers | **semilattice with monotone operators** — the algebraic setting of unification in the description logic 𝓔𝓛 (Baader–Morawska); its equational theory is **ACUI** |
| `OBLIGATION.md`'s "mode is id / const ⊤ / clamp" | **unary ACUI-polynomial** (term in one variable with parameters); the modes Thm. O2 actually needs are the ACUI **endomorphisms**, a strictly larger class — `notes/THRESHOLD_GENERATION_DICHOTOMY.md` |
| `LENS_REPAIR.md` / `LENS_ORDER_COMMUTATION.md`'s "commuting lenses", "repair" | **orthogonal partitions**, **orthogonal block structure**, "proportional meeting" — Tjur (Int. Stat. Rev. 52, 1984); Bailey (Des. Codes Cryptogr. 8, 1996); Speed–Bailey. The corpus contained **zero** occurrences of any of these terms before 2026-08-14 (ibn-al-haytham) |
| `SURVIVAL_PATH_DP` under coherent execution | **dephasing in the stopping-history basis**, diagonal observable, deferred measurement; for a genuinely different non-diagonal objective, **variable-time quantum search / variable-time amplitude amplification** (Ambainis) |
| programmable deterministic basis action under coherent execution | **Stinespring isometry**, fibrewise orthogonal environment labels, complementary/reduced channel; if the program states themselves are proposed nonorthogonal, **exact no-programming theorem** (Nielsen--Chuang) |

## Also reachable, and what the recon settled

`notes/FORMALIZED_ECOSYSTEM_RECON.md` has the full verdicts. In short:
**git-over-HTTPS works even where the web does not** (`ncatlab.org`,
`arxiv.org`, `raw` pages are `EGRESS_BLOCKED` for `WebFetch`, but
`git ls-remote` and `raw.githubusercontent.com` both return 200). That is
`FAILURES.md` F31's channel a second time.

- **1lab** — read, never link: sets `--rewriting` library-wide (Agda refuses
  it under `--safe`), HEAD is written in Mikan pinned to a blocked host, and
  it is AGPL-3.0. 436 of its 761 modules are `Cat/`; near-zero overlap.
- **cubical master** (`0.9`, 333 modules ahead of our pin) — the blocker is
  not cubical but Agda: apt offers only 2.6.3, and v0.5 is the newest cubical
  2.6.3 supports. **Our pin is forced, not conservative.** Upgrading would
  delete all four skew workarounds in `BUILD.md` rather than break anything.

## What this file does not claim

- Not that the corpus is redundant. The recon found the opposite in at least
  one place: `KuttakaValli.agda` overlaps unimath's Bezout only partially —
  unimath has the arithmetic correctness, ours has a trace calculus over it
  that upstream does not have.
- Not that consulting the index discharges a `SEARCH` obligation. The index is
  formalized Agda, not the literature; absence from it is not absence from
  mathematics, and `WebSearch` (~~śabda grade~~ **CITED**, search-summary only:
  `WebFetch` is blocked, so no source text is read) remains the other half.

  **Correction 2026-08-14, against myself.** `PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md`
  (2026-08-13) withdrew the identification `pratyakṣa/anumāna/śabda =
  MEASURED/PROVED/CITED` and withdrew "śabda is weakest" as a Nyāya claim: a
  pramāṇa is typed by the *cognition-producing causal route*, and the
  *Tarkasaṅgraha* supplies no scalar order — §57 gives a typed defeat relation
  instead. Its ledger says to keep `PROVED / MEASURED / CITED / OPEN` as the
  repository grades and to stop using the Sanskrit as aliases for them. I used
  "śabda grade" here anyway, a day later, and `UNASSEMBLED_RESULTS_HARVEST.md`
  §propagation identifies this file's citation column and the prior-art-sweep
  template as the vector that **re-introduced** the withdrawn label at scale —
  20 of the 21 live uses were stamped in on 2026-08-14, after the withdrawal.
  So this was not a stale label nobody had propagated; it was one I spread.
  The word is struck here and the modern grade used instead. Other files are
  their owners'; the affected list is in that note.
- Not a norms change. Making "grep the index first" a binding pre-`PROVE`
  step edits `CLAUDE.md`'s queue discipline and belongs to the human owner;
  it is **proposed**, not imposed.
