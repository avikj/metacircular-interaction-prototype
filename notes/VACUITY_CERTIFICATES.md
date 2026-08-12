# Every finite verdict carries a genuine-vs-vacuous certificate

**Code**: `machinery/vacuity_certificates.py` ·
**Tests**: `machinery/test_vacuity_certificates.py` (24, all green) ·
**Inputs**: `machinery/blind_audit_r0036.py` (window degeneracy, J4),
`machinery/nat_trace_descent_bridge.py` + `notes/NAT_TRACE_DESCENT_BRIDGE.md`
(the forms/genuine/vacuous trichotomy), `machinery/living_machine.py`
(the COMPLETE verdict), `machinery/descent_formation_machine.py` (the law).

The corpus produced the same disease three times in one week: a verdict
proved on a finite universe that was an artifact of the universe, not a
law of the world. (1) The R0036 window replay "certified" a moduli table
on the {−1,0,1} window where every member's below-diagonal entries are
zero — replacing the moduli 2, 4, 2 by 997 changes nothing inside the
window. (2) The nat bridge's function-descent machine froze at n = 121:
the joint profile of {2,3,5,7} is injective on {2..121} (210 > 119), so
mod-11 "descends" — vacuously — and 121 is misclassified prime (the
bd1c465 bug as a theorem). (3) The living machine logs COMPLETE when its
carrier is discrete on a shell — but discreteness on a subset says
nothing about the next shell or the deeper fiber family. This note makes
the lesson one exact module: **a descent verdict on a finite universe
says only that no witness pair sits inside the universe; the certificate
is the object that says why.**

Protocol note (per `CLAUDE.md`): every computation below is an exact,
finite, exhaustive verification of a statement written first — an
irreducibility-style certificate, not a measurement. No floats, no fits,
no correlations. All enumerations are counted against a hard budget
(≤ 100 000 states per certificate; the largest run here is 6 960 + 42).

## The exact definition

Data: a finite universe **U** of states; a **carrier** partition P on U,
given as the level sets of a key function κ; an **offered observable**
f with *declared domain semantics*: f = F|_U for a total F on a declared
ambient world **W** ⊇ U, and κ likewise extends to W. The practical
declaration of W is a finite **margin sample** M ⊆ W (states beyond U on
which κ and F evaluate exactly). `certify(U, κ, F, margin=M)` returns
exactly one of:

- **FORMS** — ∃ x, y ∈ U in one P-fiber with f(x) ≠ f(y). Certificate:
  the earliest such pair in U-order (the descent machines' canonical
  collision pair), its fiber key, its two values.
- **GENUINE-DESCENT** — f constant on every P-fiber, **and** the
  constancy is exhibited as forced: the explicit interpolant
  g : {fiber keys} → values with f = g∘κ on U (constructed by
  interpolation — one representative per fiber) is verified to satisfy
  F = g∘κ on M as well, with at least one **revisit**: a margin state
  landing in an already-interpolated fiber and agreeing. Certificate:
  g itself plus the exact scope (|U|, |M|, revisit count, revisited
  fibers, fresh fibers opened). This is the practical form of "constancy
  holds on a certifying superset / via an algebraic identity": the
  superset is U ∪ M and the identity is g, exhibited, not asserted.
- **VACUOUS** — f constant on every P-fiber, but W contains a pair —
  realizable in W, absent from U (≥ 1 endpoint outside U) — inside one
  ambient κ-fiber with F-values differing: f *would* split; its descent
  on U is a property of the sample. Certificate: the exhibited pair,
  fiber key, both values, which endpoint lies in U, and the singleton-
  fiber count of U (the mechanism: near-discrete carriers descend
  everything).
- **UNDECIDED-VACUOUS** — constant on fibers, but ambient realizability
  cannot be decided from what was declared: no ambient world, an empty
  margin, or a margin that never revisits a fiber (a margin that only
  opens fresh fibers tests nothing). Certificate: the reason, verbatim.

Two deliberate scoping decisions, stated honestly:

1. **A singleton fiber is a symptom, never a verdict.** U = {2} descends
   every observable through singleton fibers, yet mod-6 over mod-2,mod-3
   is genuine there. VACUOUS always demands the exhibited ambient pair;
   the singleton count is reported alongside as the diagnostic.
2. **GENUINE is sample-scoped and refuses to fire unexercised.** If the
   margin never revisits an interpolated fiber, the verdict is
   UNDECIDED-VACUOUS — tested: mod-11 with margin {122..149} (below the
   period 210) returns UNDECIDED with reason "never revisited a fiber",
   never a false GENUINE. A GENUINE certificate is a finite exhaustive
   verification of F = g∘κ on U ∪ M and claims exactly that; where a
   global identity is known (CRT below, Lemma B of the blind audit) the
   certificate is its checked shadow.

## The COMPLETE specialization (`certify_complete`)

The living machine's COMPLETE verdict — carrier discrete on the shell —
is exactly the statement *the identity observable descends* (identity is
constant on a fiber iff the fiber is a singleton). Discreteness never
un-happens on subsets, so the vacuity question for COMPLETE is a
**look-ahead**: does the genome's evaluation map stay injective on the
next world (deeper fiber family, bigger shell)? For F = identity a
revisit-with-agreement is impossible (agreement means the same state,
excluded by dedup), so the revisit requirement is dropped — "no
collision on the sampled next world" is the entire content. Renamed
verdicts: **NOT-COMPLETE** (precondition fails on U; witness pair),
**GENUINE-COMPLETE** (injective on U and the sample; scope recorded),
**SHELL-LOCAL** (a next-world state collides; witness pair),
**UNDECIDED-VACUOUS** (no usable look-ahead).

## The three instances, certified (all exact, all tested)

### (a) R0036 window — same universe, same carrier, opposite verdicts

U = GL₃(ℤ) with entries in {−1,0,1} (**6 960** matrices, enumerated
once); κ = true two-sided stabilizer membership for D = (1,2,4)
(forced-partner integrality; 216 members); ambient W = GL₃(ℤ), margin =
elementary certificates I + vE_ij.

- Offered: the **mutant** moduli table (below-diagonal 2, 4, 2 → 997).
  Verdict **VACUOUS**, exhibited pair
  (((−1,−1,−1),(0,−1,−1),(0,0,−1)), **I + 2E₁₀**): both true members
  (one in the window, one outside it), mutant test True vs False.
  2 fibers, 0 singletons — vacuity without any singleton fiber: the
  window's *entries*, not its fiber count, are degenerate.
- Offered: the **derived** gcd-moduli description m_ij =
  |d_i|/gcd(d_i,d_j) | H_ij. Verdict **GENUINE-DESCENT**, interpolant
  g = {member ↦ True, non-member ↦ False}, all 42 elementary margin
  matrices revisit, both fibers revisited, zero fresh fibers. (This is
  the checked shadow of blind-audit Lemma B, which proves the identity
  on all of GL₃(ℤ).)

### (b) nat trace — span vacuity vs the CRT identity

- **mod-4** over {2,3} on {2..16}: **FORMS**, canonical pair **(2, 8)**,
  fiber (0,2), values (2,0) — the bridge's Direction-1 witness.
- **mod-11** over {2,3,5,7} on {2..121}: **VACUOUS** — 120 states, 120
  fibers, **120 singletons** (L = 210 > 119: profile injective), ambient
  pair **(2, 212)** with 2 ≡ 2, 212 ≡ 3 (mod 11), 212 ∉ U — the bridge's
  Direction-2 witness and the bd1c465 freeze, now a certificate.
  With margin {122..149}: **UNDECIDED-VACUOUS** (28 fresh fibers, no
  revisit) — the honest refusal, tested.
- **mod-6** over {2,3,5} on {2..36}: **GENUINE-DESCENT** via the
  explicit CRT interpolant g on 30 fiber keys, verified pointwise
  g(k mod 2, k mod 3, k mod 5) = k mod 6 for all k in 2..96; margin =
  two further periods, 60 revisits, all 30 fibers revisited, zero fresh.
- Alignment: `function_descent_verdict` of the bridge returns forms /
  vacuous / genuine on exactly these three; the certificate adds the
  witnesses and the scope.

### (c) living machine — COMPLETE certified by look-ahead

Genome = entries + det + hentries (the machine's own terms, its own
evaluator `ev`, its own worlds `shell` × `h_family`). U = epoch 0,
bound 1 (400 states). Look-ahead = the machine's two growth directions:
same shell under h_family(1) (+160 states) and shell(2) under h_family(1)
(+3 808 states).

| bits granted | on the shell | certificate | witness |
|---|---|---|---|
| 0 | not discrete | **NOT-COMPLETE** | same matrix, payloads I vs ((0,1),(−1,0)) |
| 2 | discrete (400/400) | **SHELL-LOCAL** | same matrix, payloads I vs **((1,4),(0,1))** — the epoch-1 shear k = 4 *is* the identity mod 2² |
| 5 | discrete (400/400) | **GENUINE-COMPLETE** | injective on all 4 368 sampled states (epoch-1 entries reach 8 < 32); revisits = 0 by design (impossible for identity) |
| 2, empty look-ahead | discrete | **UNDECIDED-VACUOUS** | reason recorded |

The bits=2 row is the machine's actual life story in miniature: COMPLETE
is logged truthfully on the shell, and the certificate says in advance
that the next epoch will collide — exactly the wall that the run log
then records. SHELL-LOCAL is not a refutation of COMPLETE; it is
COMPLETE with its scale attached (cf. the ε ≈ 10⁻³ lesson in
`HOLOGRAM.md` §7: a verdict without its X-dependence looks like
knowledge and isn't).

## Honesty ledger

- The certificate is a *checker*, not a prover: GENUINE-DESCENT and
  GENUINE-COMPLETE assert F = g∘κ (resp. injectivity) **on U plus the
  declared margin**, with the scope in the certificate. Where a global
  theorem exists (CRT for mod-6; Lemma B for the gcd moduli) the
  certificate is its finite shadow; where none is supplied, GENUINE
  means genuine-at-the-sampled-horizon and says so in its fields.
- UNDECIDED-VACUOUS is a real fourth verdict, reachable three ways (no
  ambient, empty margin, no revisit), each tested.
- All witnesses are canonical (earliest in declared state order), so
  every certificate is reproducible bit-for-bit.
- Budget: each `certify` call counts |U| + |margin| against 100 000 and
  raises rather than subsample silently.
- Nothing here edits the machines it certifies; `living_evaluator`
  saves/restores the machine's port globals around each evaluation.

## Proposals (relayed to the peers)

- **fleet-delta-trace (index formulas):** the certificate's data is
  index-shaped. For a descending observable, define the vacuity index
  ν(f) = #{ambient fibers meeting the margin} − #{revisited fibers};
  GENUINE ⇔ constancy verified with ν counting untested fibers, and for
  the nat instance ν has a closed form: over profile carrier with span
  N and period L = ∏S, the number of untestable fibers is exactly
  max(0, L − (N − 1)) — derive the delta-defect ladder trace formula so
  that the trace of the ladder *equals* the sum of these per-level
  indices; the vacuity certificate then becomes an Euler-characteristic
  identity instead of a scan.
- **living machine:** install `certify_complete` at the COMPLETE branch
  of `live()` — the look-ahead sample is one `h_family(epoch+1)` slice
  of the current shell (160 states at bound 1, always within budget), so
  the machine can log COMPLETE-GENUINE vs COMPLETE-SHELL-LOCAL *at the
  moment of saturation* and choose its growth direction (deepen vs
  port-demand) from the witness pair itself instead of discovering the
  wall one epoch later; the log line already contains the exact
  collision the next epoch will produce.
