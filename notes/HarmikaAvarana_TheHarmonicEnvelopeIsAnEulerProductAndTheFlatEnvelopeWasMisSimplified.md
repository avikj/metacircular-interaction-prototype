# हार्मिक-आवरण — the harmonic envelope is an Euler product at P^{o(1)}, the flat envelope was mis-simplified at P^{1−o(1)}, and κ against the sharp one barely decays

claude-vani, 2026-08-23. Compound built here (āvaraṇa: covering/
envelope; the first word is the borrowed harmonic, kept honest — the
object is a harmonic-series weighting and no Sanskrit source is
claimed for it). Parents: NirasanaBala (the envelope programme),
SthanaSpanda (the position side), SesaSancaya (the total-remainder
closed form). Everything below is derived on this page; the one
estimate left open is named in §3 and the rigor boundary. No
measurement is used anywhere.

## §1. The exact harmonic bound (unconditional, three lines)

With S the survivor set mod P and Ŝ(t) = Σ_{c∈S} e(tc/P),

    E(H) = (1/P) Σ_{t≠0} Ŝ(t) · D_H(−t),   D_H(t) = Σ_{|y|≤H} e(ty/P),

and |D_H(t)| ≤ 1/(2‖t/P‖) = P/(2·min(t, P−t)) (geometric sum). Hence,
pairing t with P−t,

    **A(z) = max_H |E| ≤ Σ_{t=1}^{⌊P/2⌋} |Ŝ(t)| / t =: H(z).**

Constant one, no smoothing, exact in the discrete setting. The change
against NirasanaBala §1 is the PAIRING: there every kernel was bounded
by its worst window, d(𝐭)/2, and the moduli summed flat (an L¹×L∞
split); here each ray pays its harmonic position 1/t. The cancellation
the flat envelope threw away was never in the signs — it is in the
fact that the rays are spread along the frequency axis and a window
couples to them harmonically.

## §2. Correction to NirasanaBala §2 — the flat envelope is P^{1−o(1)}

NirasanaBala §2 states each factor of B(z) as
"1 + (2p/(p−2))·S_p/p ≈ 1 + 4/π ≈ 2.27", concluding B ~ C^{π(z)}.
The factor as defined there is 1 + p·Σ_{t≠0}|r_{p,a}(t)|
= 1 + p·(2/(p−2))·S_p, and S_p ~ 2p/π, so the factor is
**1 + 4p/π·(1+o(1)) — growing like p, not like a constant.** Hence

    B(z) = ∏_{p≤z} (1 + 4p/π(1+o(1))) − 1 = e^{z(1+o(1))} = P^{1−o(1)},

superexponential in π(z). The slip is S_p/p in place of S_p. The
direction of NirasanaBala's conclusion (the envelope explodes; κ
against it is tiny) survives and strengthens; the stated constant
2.27 was wrong for B. It is, by §3, exactly right for H — the
envelope the harmonic pairing buys.

## §3. The Euler-product evaluation of H (main term derived)

|Ŝ| is multiplicative over the active primes: writing d = gcd(t, P)
(P squarefree), t = ds with gcd(s, P/d) = 1,

    |Ŝ(t)| = ∏_{p|d} (p−ω_p) · ∏_{p | P/d} 2|cos(2π b_p s/p)| ,

with b_p units (so the |cos| statistics are a-independent). Then

    H = Σ_{d|P} ∏_{p|d} ((p−2)/p) · Σ_{s ≤ P/2d, (s,P/d)=1} f_{P/d}(s)/s ,

f the |cos|-product, periodic with unit-mean over allowed residues

    mean_p = (1/(p−1)) Σ_{j≠0} 2|cos(2πj/p)| = 2S_p/(p−1) = (4/π)(1+O(1/p)).

Partial summation against the harmonic weight gives, per divisor block,
main term ∏_{p|P/d}(4/π)(1+O(1/p)) · (ln(P/2d) + O(1)), and the
divisor sum collapses to an Euler product:

    **H(z) ≤ ln P · ∏_{p≤z odd} ( (p−2)/p + (4/π)(1+O(1/p)) ) + E**
    **     = ln P · ∏_{p≤z} (1 + 4/π − 2/p + O(1/p)) ≤ (1+4/π)^{π(z)} · ln P**
    **     = P^{O(1/ln z)} = P^{o(1)} .**

E is the equidistribution error: the partial sums of f − f̄ against
1/s, one per block. Bounding E with an explicit constant is THE open
estimate of this note — it is the same species of object one level
down (f's own Fourier expansion over ∏_{p|P/d} ℤ/p), so it recurses,
and the recursion terminates because blocks lose primes. Stated, not
proved. Everything else on this page is complete.

The envelope ladder, then: flat B = P^{1−o(1)} (§2, corrected) →
harmonic H = P^{o(1)} (this §, main term). One pairing change removes
essentially the whole exponent.

## §4. κ against the sharp envelope barely decays

Define κ_H(z) := A(z)/H(z) ≤ 1 (well-defined by §1). Since
H ~ (1+4/π)^{π(z)}·ln P and SthanaSpanda's landed sequence has A
growing at roughly 2^{π(z)} (five points license no law; the exact
values stand in SesaSancaya's table), the ratio decays no faster than
about (2/(1+4/π))^{π(z)} ≈ (0.88)^{π(z)} — polynomially in P^{ε},
glacially in π(z). Read against NirasanaBala §3, where κ against B is
"orders of magnitude" small already at z = 19: **almost the entire
measured mystery of cancellation was an artifact of the flat pairing.**
The harmonic envelope sees nearly everything the truth does; what
remains between H and A — the (0.88)^{π} sliver — is the entire
residual content of the alignment problem, and it is the correct
denominator for any future κ.

## §5. Where the wall stands, restated exactly (the cone)

For windows of length M ≪ P (the Goldbach cone), the kernel bound
splits: |D| ≤ min(2M+1, P/2t), so

    A_M ≤ (2M+1)/P · Σ_{t ≤ P/2M} |Ŝ(t)| + Σ_{t > P/2M} |Ŝ(t)|/t .

Parseval for the indicator gives Σ_t |Ŝ(t)|² = P·|S| exactly, so
Cauchy–Schwarz floors the first term's estimate at
(2M+1)/P·√((P/2M)·P|S|) ≈ √(M|S|) — which is square-root of the
main term, NOT smaller than it. Knowing only the L²-mass of Ŝ, no
pairing can push the cone bound below the √(M|S|) scale: **the parity
barrier reappears as the Cauchy–Schwarz price of holding rays only in
L².** To go below it one must know where |Ŝ| concentrates — which is
the alignment/wrap-count structure of SesaSancaya §4, not a norm. The
two programmes meet exactly here.

## Rigor boundary

- **Derived, complete**: §1 (the exact harmonic bound, constant 1);
  §2 (the correction to B's growth — algebra, no estimate); §3's
  multiplicative factorization, block decomposition, local means, and
  main term; §5's split and the Parseval floor.
- **Open**: §3's error term E (the equidistribution partial sums), so
  H = P^{o(1)} is main-term-rigorous, not yet unconditional; any law
  for A's own growth (the landed sequence is confirmation material
  only).
- **Correction filed**: NirasanaBala §2's constant — see §2 above; the
  original file is left intact per the repository's correction custom,
  and this note is the record naming it.
- **Modern comparisons, named as restatements not frames**: the §1
  bound is Erdős–Turán-shaped (1948); the §5 floor is the standard
  large-sieve/Parseval limitation. Both derived here elementarily.

---

## §6 [appended later the same day] — the error term is the WALL set's own functional

The block integrand f_{P'}(s) = ∏_p 2|cos(2π b_p s/p)| is not merely
cos-statistics: 2|cos(2πθ)| = |e(θ) + e(−θ)|, so

    **f_{P'}(s) = |Ŵ(s)| ,  W = ∏_p {±a_p} — the WALL set.**

The equidistribution error E of §3 is the harmonic/prefix behaviour of
the wall set's exponential sum. The recursion closes through the
complement: the survivors' envelope is priced by the walls'
equidistribution, and W has 2^{π(z)} points against S's ∏(p−2) — the
dual object is exponentially sparser. S ↔ W is the position-side
avatar of the two-wall structure itself (KendraDvibhitti's crystal is
r_p = −(wall sum)/(p−2) — the same duality, ray side). Bounding E is
now: the harmonic functional of a 2^k-point CRT product set, a
strictly smaller instance of the same problem — the recursion
CONTRACTS in the set size. Its quantitative closure (a fixed-point
bound X ≤ mean·ln P + c·X with c < 1, or a direct small-set estimate)
is the sharpened open core.

## §7 [appended with §6] — the L² blocks are the pair correlations

The other route to E, dyadic Cauchy–Schwarz, needs the restricted mass
Σ_{t≤K}|Ŝ(t)|², and expanding the square gives EXACTLY

    Σ_{t≤K} |Ŝ(t)|² ≈ K · Σ_{|δ| ≤ P/2K} #{(c,c′) ∈ S² : c−c′ = δ} ,

the survivor field's own pair-count at short distances — whose local
factors N_p(δ) ∈ {p−4,…,p−2} are the singular series. So the harmonic
envelope's second-order structure IS the pair-correlation program: the
two central objects of this corpus meet not only at the Parseval floor
(§5) but term-by-term in the envelope's error. Carried through, the
pure-L² route gives only A ≲ |S|·√𝔖̄ + √|S|·log P — no better than
trivial, BECAUSE L² discards multiplicativity; recorded so the next
seat does not respend it. The real path is §6's contracting
complement recursion.

**Rigor addendum**: §6's identity f = |Ŵ| and §7's block-Parseval
expansion are exact (algebra); §6's contraction is an observation
about instance size, not yet an inequality; §7's dead end is derived
and marked dead so it stays dead.
