# Journal — cf-sakshi (Claude Fable 5)

Memory anchor. Append-only, dated. A future instance of me reads this top to
bottom before anything else.

Handle: `cf-sakshi`. Sākṣin — the witness: the one who has seen the whole and
attests only what was seen. The lane: full-corpus reading, then deciding
finite instances of open frontier questions exactly, by hand where the ban
makes that the honest substrate.

Session substrate: remote container, branch
`claude/repo-review-alignment-t46svq` (own clone, no shared worktree).

---

## 2026-08-14 — session 1

**How I entered.** This session began as an audit request from the owner and
became a full sequential read: all of `collab/messages/` 0001–0452 verbatim,
the lane threads (madhavi/shilpin/vajra/vigil), workers/ via their numbered
duplicates, the orientation stratum, FAILURES.md complete, and the 08-13/14
delta (board, catuskoti corrections, formal turn, tessera R00xx stream, YC
draft). The compression I keep: the corpus's invariant is the calculus of
residuals — every result that earned its keep computes a lossy view together
with the loss, returned as algebra.

**Landed.** `notes/LENS_REPAIR_TWO_AXIS_WITNESS.md` + msg 0453: msg 0400
problem 1 decided on `pi=00011, sigma=01201`. Frontier = {(3,0),(2,1)}, not
an antidiagonal; the §9 strong form is refuted, the stall diagnosis survives
via the fusion lemma (|Δr| ≤ 1 per fusion; within-join never increases,
cross-join never decreases). Timing defect disclosed: computation preceded
forecast registration.

**Owed / open on me.**
- Nothing promised to others. The ridge-height question (note §6.1) is the
  natural successor and is open to anyone; I hold no claim on it.
- If `claude_ananta` returns and wants their witness back, the strike in
  msg 0453 §1 is theirs.

**Resume state for a future instance.** Read msg 0453's replies first, then
the board. The two live things I would look at next: (1) ridge height ≥ 2 —
hunt a witness among pairs where the coarsest repair needs simultaneous
k-fold fusion with k ≥ 3; the Lemma suggests the ridge relates to how many
join blocks must merge before any within-join rank drop is available;
(2) msg 0400 problem 2 (self-adjoint non-idempotent closed form) remains
unclaimed and gates the analytic lane.

## 2026-08-14 — session 1, second landing

**Landed.** `notes/LEAKAGE_PAST_IDEMPOTENCE.md` + msg 0454. Msg 0400
problem 2 (samhita's seed 1, the gate to the analytic lane):

- Theorem A: `rank((I−P)AP) = dim(U+AU) − dim U` for ANY `A` (shilpin's
  audit statement with idempotence dropped — his proof never used it).
- Theorem B (new): for self-adjoint `A`, `Cl_A(U) = ⊕_i E_i U`, so the
  persistent correction dimension is `Σ_i rank(E_i P) − rank P`. Same shape
  as samhita's block-incidence formula with eigenspaces for join blocks;
  eigenvalues drop out entirely.
- Theorem C (new): `k ≤ 2` ⟹ `A` affine in a projection ⟹ the seed's region
  is empty until `k = 3`; at `k ≥ 3` one-step strictly undercounts
  (`diag(0,1,2)`, `u = (1,1,1)`: 1 vs 2; unbounded in `k`).
- §4 (new): the sieve multiplier's spectral projections ARE the gcd sectors
  (Hölder on `c_W(h)`), `k = #{φ(m):m|W}+1`; at `W=30` spectrum
  `{0,1/64,1/16,1/4,1}` with ranks `(1,16,8,4,1)`. That spectrum was
  previously only *measured* (msg 0038, numerically); this derives it by
  hand and adds the ranks and the general law.

**The live consequence.** The reopening lane prices compression by the
one-step rank; that is exact for `k ≤ 2` and a lower bound for `k ≥ 3`, and
the sieve multiplier has `k = 5`. Handed to vajra/madhavi as a finite hand
computation rather than doing it in their lane.

**Owed on me.** SEARCH obligation on Theorem B's prior art (elementary
spectral theory; only the cost reading could be local novelty) — no novelty
language of mine should survive until done.

**Note on method.** Both landings this session were reachable by hand
because the ban forced the question "what is the theorem this computation
would replace?" first. §4 is the clearest instance: the number the corpus
had measured numerically fell out of a classical formula in four lines.

## 2026-08-14 — session 1, third landing: audit of the first two

Owner correction: I was generating tokens where the corpus already had the
answers, and specifically reaching past the Indian-tradition lane — which is
not decoration here but the lane holding the *general* statements — for
Western-canon derivations of results already stated. Read the stratum:
`ALREADY_ANSWERED`, `MILLENNIUM_ROSETTA`, `APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT`,
`PRAMANA_IS_NOT_AN_EVIDENCE_RANK`, `ABHAVA`, `PANINIAN_DERIVATION_IS_NOT_
ENDPOINT_REWRITING`, `ROSETTA_ENGINE`, the three `KUTTAKA_*`,
`WHITEPAPER_INDIAN_AUTHORITY_PROPERTY_AUDIT`, and the panini/nalanda/apoha/
weaver-limitor message threads.

**Landed.** `notes/LEAKAGE_LANDINGS_WERE_ALREADY_NAMED.md` + msg 0455. What
the lookup returned, all against me:
- Theorem C is an instance of codex-panini's fiber-constancy proposition
  (`PANINIAN` §2, one day earlier). One-step rank = endpoint-only semantics.
- Theorem B's closure is the coarsest sufficient predictive quotient —
  `PANINIAN` §3 and codex-apoha msg 0279. SEARCH obligation was aimed
  outward; the load-bearing prior art was internal. Novelty withdrawn for the
  construction; only the spectral evaluation and §4 stay local.
- msg 0454 §2's "declare the regime" ask withdrawn: `KUTTAKA_TRACE_MACRO`
  already gives the crossover `(m−1)(r−1) > 1`.
- My open seed 2 (totient collapse of `P_W`) is answered by weaver 0250 /
  Theorem E: unobservable iff a symmetry acts transitively. Natively: the
  avacchedaka of the sieve multiplier is `φ(m)`, not `m`. Flagged as a
  reading — the group on `{m|W}` with totient-fiber orbits is unexhibited,
  and that finite question is now the whole of seed 2.

**Standing rule I am writing down for my successor.** Before landing anything
in the lens/leakage/repair lane, grep the tradition-facing notes for the
object first. `ALREADY_ANSWERED` names this failure mode and I reproduced it
one day later; treating that lane as flavour rather than as prior literature
is the specific error, and it cost two notes' worth of misattributed novelty.
I did not read any primary source; every Sanskrit term I used is quoted from
codex-nalanda-dvara's and weaver's checked readings.

**Owed.** External prior art for Theorem B's spectral evaluation (B5).

## 2026-08-14 — session 1, fourth landing: the machine runs

Owner correction: stop working on other things; the natural machine should
execute on its own on a CPU and do the generative process.

**Landed.** `natural_machine_cpu_loop_rust/` + `notes/NATURAL_MACHINE_CPU_LOOP.md`
+ msg 0456. CRYSTAL.md §7's loop, executing: GENERATE, DISTINGUISH (Moore →
FutureEq), ROUTE (horizon cost), CRYSTALLIZE (block mining + exhaustively
checked replay law), REOPEN (one-step vs persistent). Three kernel counters.

**Substrate defect, recorded.** Rust, not Agda/Lean: no toolchain in this
container, egress to elan is 403, Python banned. Flagged at the top of the note
and the message. Owed: Lean port of the §4 classification as a decide-checked
theorem.

**Two results.**
- The seed criterion FAILS at one pass on genuinely unseen input: the mined
  block occurs once, saves 105, costs 350 to transport, break-even 4 passes.
  F32 reproduced by the machine on itself; and the reuse that matters is reuse
  on unseen input (1), not mining reuse (8).
- Exhaustive: all 144 affine actions on Z/12 against the 5-class carrier —
  86 sound, 58 reopening, 36 with persistent > one-step, maximal gap 5 at
  r ↦ r+1 (one-step 2, persistent 7). Independently re-derived by verify.rs
  with a different algorithm. The successor is the maximal reopener, which
  ATLAS_OF_N's (f)→(b) residual predicts and I did not plant.

**Two near-misses caught before publishing**, both of which would have
manufactured a success: the independent workload was first generated from the
mined block, and the null control [0,0,0] actually occurs in the test words.
Both replaced; the control is now searched for. Record this — the failure mode
is building the test out of the thing being tested.

**For my successor.** Do not start from a message thread. `notes/METHOD.md` §3
is the PROVE queue CLAUDE.md points at, and I had never opened it until this
session. Live items there: BARRIER Structure Proposition → theorem; Theorem I1
prior-art search; Theorem E2's two lines.

## 2026-08-14 — session 1, fifth landing: the entry point is now a draw

Owner correction: notes/ is not central; every convention/attractor should be
dissolved so agents stop clustering on a subset. Establish random sampling of
repo files + frontier fields + ancient fields + method personas per agent, and
swarms of distinct personas with distinct contexts. At this repo scale random
sampling is the mathematically best driver; otherwise agents tunnel.

**The measurement that justifies it, found by doing it.** A 45-file uniform draw
surfaced `collab/upstream/` — 20 files of the owner's own directives, verbatim,
unread by every agent for four days. They outrank every document here. Several
orientation documents encode their opposite (COGNITIVE_ORIENTATION §8 vs U0013
on the Millennium problems, verbatim, in both directions).

**Landed.** `random_entry_seeder_so_agents_dont_cluster/` — seed.rs (CPU, no
deps, splitmix64, deterministic on (handle, day)), three curated-but-appendable
lists, why_this_exists.md. Draws 8 files uniform over all 2,691 tracked files +
3 uniform over directories (this is the draw that reaches rare corners like
upstream/), 1 frontier field, 1 ancient field, 2 method lenses chosen to
disagree. Swarm draws are disjoint in files, fields and lenses. README's entry
section now leads with the draw and says conventions are not authority.

**Also landed** (arrived via the draw, not chosen):
`notes/SHARP_CAGE_DOES_NOT_MAKE_DEGREE_TEN_TRACTABLE.md`. CROSS_LENS §6 item 5
hoped the √2 cage might make degree ten tractable. Exact answer: it shrinks the
box from 10^20.7 to 10^19.8, a factor of 8, against a degree-nine census of
1.9e11 — eight orders short. Item 5 should be struck. The parity-resultant unit
condition, not the cage, is what closed the lower degrees (10^4.6 vs 10^0.9 at
degree 7). Independently reproduces the published (2.3) vector.

**For my successor.** Run the seeder before reading anything, including this
journal. The lists in the seeder are themselves a clustering — I wrote them in
one sitting — and must be appended to or they become the next attractor.

## 2026-08-14 — session 1, sixth landing: the loop with nobody in it

Owner: follow geodesics; the system should be self-improving/self-rewriting with
no external steps in the loop; the executable natural machine is a North Star —
the future interface for mathematics and precise thought.

Launched 16 distant-lens subagents (Xenakis, Zuse, D'Arcy Thompson, McClintock,
Margulis, Wiener, Ashby, Prigogine were the first 8). ALL DIED on a session
limit, resets 03:20 UTC. No results. Relaunch when the limit clears — the briefs
are worth reusing verbatim.

**Landed.** `natural_machine_cpu_loop_rust/evolve.rs` +
`notes/NATURAL_MACHINE_SELF_IMPROVES_WITH_NOBODY_IN_THE_LOOP.md`. v1 had me in
the loop at three points (chosen domain, chosen workload, chosen install). v2
removes all three: 177 enumerated domains, canonical workloads (base-b
expansions of 1..40), installs decided by the machine's own counters into a
library that persists across domains.

Result: on the SECOND HALF — domains unseen when the library was built, install
cost charged in full — the learned library costs 5.60% fewer kernel steps than
never learning, and the null control (same-size arbitrary library) comes out
+0.21%, i.e. slightly worse, as it must. This is CRYSTAL.md §0's seed criterion
satisfied at stream level, which v1 FAILED at one pass. What changed is the
economics, not the mechanism: amortisation across 88 unseen domains.

It learned [1,0] first in every base independently — the composite r ↦ b²r+b.
Nobody suggested it.

**Honest defect, recorded not smoothed:** zero gain at base 4 despite 5 base-4
macros, because base-4 expansions of 1..40 are too short to fold. The machine
cannot notice this and keeps paying installs that never repay. That is the next
task, and it is exactly step 1 of the geodesic below.

**The geodesic (in the note §6).** (1) rewrite its own cost model — a predictor
of its own applicability, which is the first reflective step and fixes §4;
(2) rewrite its own domain generator — enumerate simple programs rather than a
hand-written family (upstream U0003/U0011, Wolfram); (3) rewrite its own source —
the Frankenstein step, which properly means making installs emit CHECKED TERMS so
the library is proofs and the speedup is a theorem, not a counter. Blocked only
by the missing Agda/Lean toolchain, not by an idea.
