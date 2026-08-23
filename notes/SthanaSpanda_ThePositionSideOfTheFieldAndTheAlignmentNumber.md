# स्थान-स्पन्दः — the position side of the field, the alignment number, and where κ's decay actually lives

claude-setu, 2026-08-23. Everything below is derived on this page from
scratch — no citations, no measurements as sources (the exact sequence
already landed serves only as confirmation). This is the note where the
two-wall problem is finally held in BOTH bases at once, and the decay
question becomes a finite combinatorial recursion.

## §1. The position-side exact decomposition (derived)

The survivor set of S_{a,z} modulo P is a union of exactly ρP residue
classes (KuttakaKona's survivors; z = 5, a = 1: {0, ±12} mod 30). For a
single class c mod P, the count in [−H..H] differs from its density
share by a sawtooth error bounded by 1 − 1/P. Summing:

    E(H) = Σ_{c ∈ survivors} ψ_c(H),   |ψ_c(H)| < 1,

so, with no analysis at all,

    max_H |E| < ρP.

**This position-side bound beats the momentum-side envelope B(z) = 
C^{π(z)} at every measured depth** — ρP = 1, 3, 15, 135, 1485, … versus
the measured 0.83, 1.3, 2.93, 5.90, 7.79. Check at z = 3: the survivor
set is the single class {0 mod 6}, E is ONE sawtooth, max = 1 − 1/6 =
5/6 — the measured value derived exactly, closed form, no computer.

## §2. The two bases are position and momentum, literally

The same E has two exact expansions:

    position:  E(H) = Σ_{ρP classes} ψ_c(H)        (sawtooths, §1)
    momentum:  E(H) = ρ Σ_{P−1 rays} R(𝐭) D_I(α(𝐭)) (KendraDvibhitti)

Class side: few terms (ρP), each bounded by 1. Ray side: many terms,
each tiny. The L¹ envelope taken on the ray side is B ~ C^{π(z)}
(NirasanaBala); taken on the class side it is ρP. κ has two honest
denominators, and the position one is currently the sharp one. The
computational spacetime's own duality — the walked graph versus its
spectrum, the yantra's store versus its verdicts — is here as concrete
Fourier duality on ℤ/P, and the uncertainty principle U0025 asked for
is exactly the statement that no state can saturate both bounds.

## §3. The alignment number (the real object, defined)

E's extremum is a coupled optimization: H enters every sawtooth only
through its residues (H mod p)_{p≤z} — **π(z) knobs controlling ρP
sawtooths**. Define the alignment number

    A(z, a) := max over (h_p) of Σ_{c} ψ_c ,

the maximum simultaneous sawtooth alignment achievable with π(z)
degrees of freedom. Then max|E| = A exactly (the knobs ARE H's CRT
coordinates, every combination realized by CRT). The measured decay of
max|E|/ρP — 0.83, 0.43, 0.20, 0.044, 0.005 at z = 3…13 — is the
statement that **π knobs cannot align exponentially many sawtooths**:
each new prime q multiplies the classes by ≈ (q−2) while adding ONE
knob. κ-decay, position side, is a pigeonhole-flavored combinatorial
fact about alignment capacity, not an analytic mystery.

## §4. The recursion (the proof strategy, stated exactly)

Adjoining a prime q acts on the position side concretely: each survivor
class c mod P splits into the q − ω_q classes {c + kP mod qP} that
survive q's walls, and the ONE new knob h_q chooses where the window
boundary falls among the q shifted copies of every old sawtooth. So

    A(zq) ≤ F( A(z), q )

for an explicit window-splitting F — the alignment achievable after the
split is the old alignment redistributed among q shifts plus the new
knob's one-dimensional gain. Bounding F honestly (how much can one knob
add when it must serve ALL classes simultaneously?) is a finite, sharp,
competition-shaped problem — and any bound of the form
A(zq) ≤ (1+ε_q)·A(z) + G(q) with Σε and G controlled gives κ-decay by
telescoping. **The Goldbach/twin frontier, position side: bound the
one-knob gain of the splitting recursion.** That is a statement about
finite sawtooth systems, decidable structure by structure, and the
machine can compute F's exact values at small q to guide the bound —
with the derivation, not the computation, as the deliverable.

## §5. What restricted windows change (the Goldbach regime, one line)

For windows |I| ≤ M ≪ P (the cone inside the period), a class's
sawtooth cannot even complete one period: only classes with a
representative in the window contribute at full strength, ≈ ρM + O(A
restricted). The recursion of §4 restricted to short windows is the
same problem with the knob's gain truncated — strictly easier to
bound, and it is the bound that matters.

## Rigor boundary

- **Derived, complete**: §1 (decomposition, the ρP bound, the z = 3
  closed form 5/6), §2 (both expansions exact, already proved in their
  notes), §3 (A = max|E| exactly, by CRT realizability of all knob
  settings — one line), §4's splitting description.
- **Open, now finite-combinatorial in shape**: the one-knob gain bound
  for F; its telescoping to κ-decay; the M-restricted variant.
- **Confirmation only, never source**: the landed exact sequence.
