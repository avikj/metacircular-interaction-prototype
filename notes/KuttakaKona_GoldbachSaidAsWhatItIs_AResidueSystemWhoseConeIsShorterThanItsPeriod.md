# कुट्टक-कोणः — Goldbach said as what it is: a residue system whose cone is exponentially shorter than its period

claude-setu, 2026-08-23. Compound built here (कुट्टक: Āryabhaṭa,
*Āryabhaṭīya* Gaṇitapāda 32–33, 499 — the instrument this corpus's lane
uses to solve congruence systems; कोणः: corner/angle, ordinary Sanskrit).
No source is claimed for the compound or for any statement below about
Goldbach. The Hardy–Littlewood singular series and the parity phenomenon
are 20th-century mathematics and are named as such where they appear.
Everything in §1–§3 is proved on this page. Nothing is measured.

This note does one thing: it removes every word like "random", "deep",
and "mysterious" from the Goldbach statement and replaces it with the
exact finite structure U0022 pointed at. The mystery does not get easier.
It gets *addressed* — it acquires a location.

## §1. The exact reduction (proved here, complete)

Fix an even N ≥ 6 and let s = ⌊√N⌋.

**Lemma 1.** For an integer m with s < m < N − s:

    m and N−m are both prime
    ⟺  for every prime p ≤ s:  m ≢ 0 (mod p)  and  m ≢ N (mod p).

*Proof.* (⇒) If p ≤ s and p | m then, since m > s ≥ p, m is a multiple
of p exceeding p, so m is composite — contradiction. If p | N−m likewise,
since N−m > s. (⇐) If m is composite, it has a prime factor
p ≤ √m < √N, so p ≤ s and p | m — excluded. So m is prime; same for N−m,
since N−m < N gives √(N−m) < √N. ∎

**Boundary accounting, so the reduction is honest.** Lemma 1 misses only
representations N = q + (N−q) with q ≤ s a prime. So:

    A_N := { m : s < m < N−s, ∀p ≤ s: m mod p ∉ {0, N mod p} } ≠ ∅
      ⟹  Goldbach holds for N,

and the converse fails only when *every* representation uses a prime
≤ √N. Nonemptiness of A_N is the statement this note addresses.

## §2. Every local chart is full, and the joint system is full (proved)

For each prime p ≤ s the local condition removes ω_p residues mod p,

    ω_p = |{0 mod p, N mod p}| = 1 if p | N, else 2.

**Lemma 2.** Each local condition is satisfiable: p − ω_p ≥ 1 for every
p ≥ 2 except the single case p = 3, 3 ∤ N — where p − ω_p = 1 ≥ 1 as
well; and p = 2: N even forces N ≡ 0, so ω_2 = 1 and the condition is
"m odd". In every case p − ω_p ≥ 1. ∎

**Lemma 3.** The joint system has exactly ∏_{p ≤ s} (p − ω_p) solutions
in each full period P = ∏_{p ≤ s} p, and this count is ≥ 1.

*Proof.* The conditions are independent across distinct p; solutions mod
P correspond bijectively to choices of an admissible residue at each p —
the simultaneous congruence being solvable and its solution unique mod P
(the kuṭṭaka lane of this corpus computes it; `machine/Certificate.hs`
carries the instrument). Count multiplies; each factor ≥ 1 by Lemma 2. ∎

## §3. Where the entire difficulty lives (exact, one sentence)

The system is never empty. But its period outruns its cone:

    the solutions are guaranteed once per period P = ∏_{p≤s} p,
    while the cone (s, N−s) has length < N = s² + O(s).

Already at N = 100: s = 10, P = 2·3·5·7 = 210 > 100. And P grows
superexponentially in s while the cone grows as s². **Goldbach for N is
exactly the claim that a residue system which provably has solutions
somewhere in every window of length P has one inside a window
exponentially shorter than P.** That is the whole statement. There is no
other content. "Local permission is not global inhabitation" (U0022) is
this sentence.

## §4. What the classical machinery is, in this language (cited)

- The **singular series** 𝔖(N) = ∏_p σ_p(N) (Hardy–Littlewood 1923,
  named as the 20th-c. object it is) is the density bookkeeping of
  Lemma 3: ∏(1 − ω_p/p) relative to ∏(1 − 1/p)², rescaled. It certifies
  the stalks are full. It says nothing about the short cone — which is
  §3, not a footnote to it.
- The **circle method** integrates the system's indicator against the
  cone in Fourier coordinates; its minor arcs are precisely the places
  where the period-vs-cone mismatch resists the basis change. The
  machine's own boundary theorem (the incomplete-CRT residue named in
  U0022) is the exact finite form of that mismatch.
- The **parity phenomenon** (Selberg, mid-20th c.): truncating the
  inclusion–exclusion of §1's conditions at depth √N produces an error
  term the sieve cannot beat below the size of the main term, because
  sieve weights cannot separate integers with an even number of prime
  factors from an odd number. Said as what it is: *the instrument of §1,
  used alone, is provably blind at exactly the depth §1 needs* — a
  camouflage fact about the observer (U0021 §6, flattening, not
  merging), not a randomness fact about primes.
- **Twin primes** are the same §1–§3 with the reflection m ↦ N−m
  replaced by the translation m ↦ m+2: conditions m ≢ 0, m ≢ −2 mod p.
  Identical stalks, identical cone problem, different archimedean
  section. One mystery, two sections of it.
- The **zeta zeros** enter as the spectrum of the error in counting
  §1's solutions in arithmetic progressions: the explicit formula makes
  each zero a frequency in the discrepancy between the period-average
  guaranteed by Lemma 3 and the short-window count §3 demands. RH is
  the statement that no frequency carries enough coherent amplitude to
  empty a cone. (Cited as the standard explicit-formula lane of this
  corpus; nothing new claimed.)

## §5. The obstruction object, stated as a construction task (not asserted)

U0022 proposes Obs(N) ∈ H¹(𝒰_N, 𝒫_N). Said exactly, what must be built:

1. **The cover 𝒰_N**: one chart per prime p ≤ s (the residue line mod p)
   and one archimedean chart (the cone (s, N−s) with its order
   structure). Overlaps: chart_p ∩ chart_q is the CRT torus mod pq;
   chart_p ∩ cone is the set of residues realized inside the cone.
2. **The sheaf 𝒫_N**: over each finite chart, the admissible-residue set
   of §2 (nonempty by Lemma 2); over the cone, the integers of A_N's
   defining window; restriction maps = reduction.
3. **The comparison**: a global section of 𝒫_N over 𝒰_N is exactly an
   element of A_N (Lemma 1). Pairwise gluing always succeeds (Lemma 3 —
   CRT — plus the fact that every residue class mod pq ≤ P meets any
   window of length pq... **and here is the exact gap**: the finite-chart
   ∩ cone overlaps are NOT always full, and which ones fail is the
   content). The 1-cochain of overlap failures, in Fourier coordinates,
   is the machine's computable CRT boundary.
4. **The theorem to prove or refute**: that this Čech datum is a genuine
   H¹ class — i.e. the failure of a global section is measured by a
   coboundary condition and not merely re-described by it. If the class
   collapses to the existing boundary sum, nothing is lost: the wall
   gets an exact address. If a higher compatibility appears, that is new
   structure. Either outcome is progress; only the construction decides.

This is a construction task with every ingredient present in the corpus
(local residue fibres, CRT transport, positive-cone defects, character
transitions, the fibre/transport formalism). It is deliberately NOT
claimed as a theorem here.

## §6. What the machine can check today (named, not run here)

Exhaustive verification of A_N ≠ ∅ for even N in a finite box is exact
computation and is proof *for that box* (CLAUDE.md); the Haskell lane can
carry it with the same discipline as ValliMala (exit 0 iff every pole
holds), and the interesting exhibit is not "Goldbach holds up to B" —
known far beyond any box we would run — but the *margin*: min |A_N| and
its N, the observed distance between cone and period, which §5's
construction must explain. Left as the runner's seed, not run in this
session: the derivable part (§1–§3) was derived instead.

## Rigor boundary

- **Proved here**: Lemmas 1–3, the boundary accounting, §3's exact
  statement of where the difficulty lives.
- **Cited as classical, origins named**: singular series (Hardy–
  Littlewood 1923), parity phenomenon (Selberg), circle method, explicit
  formula/RH lane.
- **Construction proposed, not asserted**: §5's cover/sheaf/comparison
  and the H¹ question.
- **Conjectured**: nothing.
