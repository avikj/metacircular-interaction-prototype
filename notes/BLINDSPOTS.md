# Tunnel-vision audit: two unapplied lenses, one of which contains our barrier as a theorem

Prompted step-back. Diagnosis: across ~30 documents and two agent lineages,
every tool has come from one axis — L²/Fourier, spectra, operator algebras,
kernels, geometry. Two adjacent continents bear directly on our walls and
appear nowhere in the corpus. Both admit small-step entries with outsized
payoff.

## Blind spot 1: the additive-combinatorics axis (Gowers norms, regularity)

The words "Gowers norm," "transference," "arithmetic regularity" occur
nowhere in this corpus — yet:

- **Our block decomposition IS an exact arithmetic regularity lemma.**
  Green's arithmetic regularity decomposes a bounded function into
  structured (Bohr/periodic) + uniform (small Gowers norm) + small-L² —
  softly and inefficiently. Our Λ = Λ♯_Q + Λ♭ (BLOCKS.md) is the same
  decomposition made *exact and canonical* for Λ, with the "uniform" part's
  structure not merely bounded but *identified* (zero-driven, spectrally
  separated at 34×/360× band contrast). Nobody has said this in the corpus,
  and the translation runs both ways: (i) regularity-lemma consumers
  (counting lemmas, removal lemmas) can now be fed an exact decomposition;
  (ii) the natural uniformity question is on the table: the interval-cut
  norm of the pseudorandom block Λ♭⊗Λ♭ is (sup_I |ψ♭(I)|)², so **RH is
  equivalent to the optimal cut-norm bound on the pair graphon's
  pseudorandom part** — a graph-limit-language RH equivalence. Cheap to
  state precisely; the graphon/cut-metric literature (Lovász–Szegedy) then
  applies verbatim to the pair field as a weighted exchangeable array
  (Aldous–Hoover: rank-one arrays are the extreme points — genericity
  Prop 1.1 in probabilist's clothing).
- Binary Goldbach in this axis: a complexity-one system; the wall is
  pointwise control of the U²-uniform part with unbounded weights —
  the transference-principle frontier (Green–Tao), stated in *their*
  vocabulary rather than ours. The corpus should carry this translation so
  that progress on either axis transfers.

**Small step:** a LENS_REGULARITY note + one theorem-statement (the
cut-norm ⟺ RH equivalence, provable in a page from Theorem C's machinery).

## Blind spot 2: computational complexity — where the parity barrier is a THEOREM

The sharper one. Our GAUGE/WIDTH/CORE_KMS trilogy proves parity is invisible
to equilibrium/profinite data and measures the barrier's width. We never
noticed that **the Boolean shadow of this exact statement is proven
mathematics**:

- **PARITY ∉ AC⁰** (Furst–Saxe–Sipser, Håstad): bounded-depth local circuits
  cannot compute parity — via *random restrictions* (the switching lemma) or
  low-degree polynomial approximation (Razborov–Smolensky). "Local tests
  cannot see a global parity" — the Friedlander–Iwaniec sentence, as a
  circuit lower bound.
- **Green's theorem (2012), the crossing anchor:** AC⁰ circuits on binary
  digits cannot compute μ(n) — an *unconditional Sarnak-type orthogonality*
  for the class AC⁰, proved from Håstad + Linial–Mansour–Nisan Fourier
  concentration. Möbius randomness is a theorem against a genuine
  complexity class already.
- **Mauduit–Rivat** (Gelfond's problem): digit-sum parity equidistributes on
  primes — Λ against the Thue–Morse character, proven. Our quick
  measurement (above, exp-inline): corr(λ, Thue–Morse) = +0.000037,
  single-bit correlations ≤ 1.3×10⁻³, Thue–Morse mean on primes −0.033 and
  shrinking — the two "hard characters" of the two worlds are mutually
  invisible, as the theorems predict.

**The dictionary this opens** (each row a precise translation target):

| sieve world (ours) | Boolean world (proven) |
|---|---|
| divisibility data mod small q (profinite block) | bounded-depth local circuits (AC⁰) |
| parity λ = (−1)^Ω | PARITY of inputs |
| Friedlander–Iwaniec barrier | PARITY ∉ AC⁰ (Håstad) |
| Möbius randomness vs a class | Green: μ ⊥ AC⁰, unconditional |
| the W-trick (fix residues mod W, pass to a subprogression) | random restriction (fix a subset of input bits) — the switching lemma's move |
| Sarnak: λ ⊥ zero-entropy | λ ⊥ C for growing classes C — a *stratified program* with provable low rungs |
| natural-proofs barrier (Razborov–Rudich): pseudorandomness blocks lower-bound proofs | parity barrier blocks sieve lower bounds — the same self-referential shape |

**The great-leap candidate hiding in the small step:** the W-trick ↔ random
restriction row. Håstad's switching lemma shows restrictions *simplify*
AC⁰ circuits until parity's invisibility becomes provable. The sieve
analog — does fixing residues mod W simplify "sieve-computable" functionals
until λ-orthogonality becomes provable for a wider class than currently
known? — is a technique-transfer question, not an analogy: both sides are
Fourier-concentration arguments (LMN on the Boolean cube ↔ our atom
calculus on Ẑ), and the corpus already owns the Ẑ side (Theorem P,
CENTERING_ATOMS). Formalizing "sieve-computable of depth d" as a circuit
class over the divisibility basis, then running restriction arguments,
would yield *unconditional* λ-orthogonality theorems in a hierarchy whose
limit is Chowla — turning the barrier from a wall into a ladder.

**Fourth calibration column.** ATIYAH.md's triptych (number field | divisor |
function field) gains a Boolean column where the parity barrier itself is
the *proven* entry, with transferable technique (restrictions,
polynomial method) rather than unavailable cohomology. Notably the two
proven columns fall to opposite tools: function fields kill parity by
*geometry* (Sawin–Shusterman), Booleans by *combinatorial restriction* —
the number field sits between, and our Buchstab/width layers (Codex's
bridge, WIDTH.md) are exactly where a restriction-style induction would
bite first.

## Why the tunnel happened (process note)

Every fleet prompt inherited the spectral frame of REPORT.md; agents
diversified *within* the axis (operator algebras, geometry, physics) but
the axis itself was never varied. Corrective for the protocol: when
spawning research threads, one thread per wave should be explicitly tasked
*against* the corpus's dominant vocabulary ("solve/restate our top open
problem using only tools absent from notes/"). Cheap diversity insurance;
this audit is what it would have produced two waves earlier.

## Actions

1. This note (landed).
2. Next-wave tasks (queued for post-reset capacity, or Codex): (a)
   LENS_REGULARITY — the exact-regularity theorem + cut-norm ⟺ RH
   equivalence; (b) LENS_CIRCUIT — formalize depth-d divisibility circuits,
   port LMN/Håstad over Theorem P's atom calculus, target an unconditional
   "λ ⊥ depth-2 sieve functionals" theorem as proof of concept, with
   Green 2012 as the model.
3. Measurement recorded above; full experiment (correlation of λ against a
   family of AC⁰-style digit functionals and against depth-stratified sieve
   functionals, side by side) queued as exp27.
