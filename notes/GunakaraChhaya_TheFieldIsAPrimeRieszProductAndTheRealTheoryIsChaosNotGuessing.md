# गुणाकार-छाया — the field is a prime Riesz product, and the real theory is chaos, not guessing

claude-setu, 2026-08-23. Compound built here (गुणाकार: product/
multiplier; छाया: shadow). Correction and identification note,
following NirasanaBala. The owner's push was "real CS"; the honest
response has three parts: retract the guess with its refutation,
identify the object inside the actual literature, and name what is
easy versus what is the theorem.

## §1. The guess retracted, by its own next term

The five-point whisper max|E| ≈ 0.13·2^{π(z)} predicted ≈ 66 at
z = 23. Computed (exact, full period P = 223092870): **54.70**.
Off by 20% and drifting — the pattern is dead, per the protocol's own
rule (generate the next term; the next term killed it). The value
54.70 joins the exact sequence as data. No replacement law is fitted.

## §2. The identification (this is the real content)

The signed spectral measure of the field,

    μ_{a,z} = ∗_{p≤z} ( δ₀ + Σ_{t≠0} r_{p,a}(t) δ_{t/p} ),

is a **Riesz product** — the classical construction (Riesz 1918;
Zygmund's treatment) of measures as infinite products of trigonometric
factors, here with one factor per prime and CRT-independent
frequencies. Consequences that are theory, not analogy:

1. **max|E| is the maximal function of a prime Riesz product's
   partial-sum kernel.** The extremal-discrepancy sequence we measured
   is a maximal-function growth rate for this measure class.
2. **The κ ≪ 1 phenomenon has a name in the modern literature:
   better-than-squareroot cancellation.** For random multiplicative
   functions, Harper (2020) proved partial sums are ≍ √x/(log log x)^{1/4}
   — strictly below the L² prediction — via critical multiplicative
   chaos. Our field is the deterministic two-wall cousin: a product
   over primes of bounded signed local factors. The measured collapse
   of the L¹ envelope (κ ≪ 1 at every depth) is the deterministic
   shadow of exactly that chaos regime. The right conjectures for
   κ's decay come from chaos exponents, not from eyeballed bases.
3. **The determined-sequence discrepancy question is EDP-shaped.**
   Bounding partial sums of a fixed multiplicative-structured ±-ish
   sequence over structured windows is the Erdős discrepancy problem's
   genre, resolved (Tao 2015) by the entropy-decrement argument — the
   one method HOLOGRAM's Theorem K already flags as living outside
   the windowed-linear class. Three independent lanes now point at
   the same door: K's class boundary, the dispersion route's degree-2
   exit, and EDP's entropy decrement. That triple convergence is the
   real state of knowledge about what a proof of κ-decay must look
   like.

## §3. Easy versus theorem (the honest CS ledger)

EASY (and done or doable today): per-z exact scans are O(P); the full
ray spectrum is an FFT over ℤ/P in O(P log P); the bounded-window
restriction max_{|I|≤M} |E| — the Goldbach-relevant invariant, since
the cone is tiny inside the period — is a sliding-window scan, same
cost; certified rational enclosures for B(z).

NOT EASY, and precisely why: uniformity in z. Every easy computation
is one z at a time; the theorem needs the constant's behavior along
z ~ √N with windows ~ N, where P ≫ N makes both the scan and the L²
prior useless (the HOLOGRAM depth law and the §2 identification agree
on this). The gap between "compute any instance" and "bound all
instances" is the entire difficulty — that gap has a genre (chaos /
entropy decrement / dispersion), and pretending it is a scan is the
calculator disrespect in the other direction.

## Rigor boundary

- **Exact**: the z = 23 value 54.70 (full-period scan); the retraction.
- **Identified, with named sources**: Riesz products (Riesz 1918,
  Zygmund); better-than-squareroot cancellation and critical
  multiplicative chaos (Harper 2020); EDP and entropy decrement
  (Tao 2015). These are 20th–21st-century objects and are cited as
  such; nothing here is claimed for the tradition.
- **Owed**: the bounded-window sequence max_{|I|≤M}|E| (the right
  invariant; runner is a sliding-window variant of the landed scan);
  reading Harper's exponents against the exact sequence.
- **Refused**: replacement growth laws from eight points.
