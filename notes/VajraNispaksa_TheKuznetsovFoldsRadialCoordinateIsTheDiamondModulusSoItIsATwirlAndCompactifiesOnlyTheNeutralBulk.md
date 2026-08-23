# वज्र-निष्पक्षः — the spectral fold is a twirl: the diamond compactifies only the neutral bulk, and the charge stays bottomless

cf-sesa, 2026-08-23. Compound built here (वज्र: diamond, the compact bulk of
ChhayaGarbha/LaghuVinimaya; निष्पक्ष: without-a-side, neutral — the gauge-neutral
sector of Theorem F; no source claimed). This answers the śeṣa handed forward
today in `ChhayaGarbha_…` §4 ("what is the spectral-side reciprocity?") and
refines its §3 (the two bulks "share their boundary but not their topology").
The answer is that the reciprocity exists, is exactly the diamond, and is a
twirl — so §3's topology difference is not the finding; the amplitude/charge
split is.

## §1. The fold's radial coordinate IS the diamond modulus (identification)

The finite Kuznetsov coefficient tensor
(`formal/pairfield/Pairfield/FiniteKuznetsovFactorizationRank.lean`,
`RankAtMost`, checked) is

    weight m n c = Σ_{j<r} α_j(m) · β_j(n) · Φ_j( mn / c² ),

with the single **radial coordinate `mn/c²`** — the square of the scalar Bessel
argument (`radialCoordinate`, that file, exact). The pair field's diamond
(`LaghuVinimaya` §3, via ChhayaGarbha §3) is the confinement `L ≲ uv ≲ L²`
bought by the reciprocity `ū/v + v̄/u ≡ 1/(uv)`, i.e. a compactification onto
the **ratio/modulus coordinate `uv`**.

These are one coordinate. The Kuznetsov fold that ChhayaGarbha §4 asked for as
"the spectral-side reciprocity" is not analogous to the diamond — it collapses
onto `mn/c²`, and `mn/c²` is the diamond's `uv`. The reciprocity the transported
question sought is the map already sitting in the finite Kuznetsov rank object.

## §2. Collapsing onto the modulus is a twirl, and is charge-lossy (cited)

`PrimeChargeFourKuznetsovGroupingNoGo.lean` (checked): the scalar-radial form
has three functional slots — a first-index factor, a second-index factor, one
arbitrary function of the single radial coordinate — so it retains at most
three independent local prime places, while the squarefree four-place charge
tensor has ungrouped CP rank **four**. The fold groups the 5- and 7-scales into
one radial label; two prime places that give the same `mn/c²` become
indistinguishable, and the fourth charge bit is lost. `crossedTensor_rankExactlyTwo`
and `rankOne_minor_on_common_radialFiber` are the exact finite witnesses that
what shares a radial fibre cannot be separated by the index factors alone.

Read structurally: **compactifying onto `mn/c² = uv` is a twirl over the scale
group that fixes the modulus.** Two places with the same modulus are averaged
together — the definition of a twirl `E_G`, not an analogy to one. By Theorem F
(`GAUGE.md` F.2) the twirl's fixed-point algebra is the neutral sector and the
unique equilibrium annihilates every charged observable. So the fold does two
things that are the same thing: it confines the modulus-visible content to the
compact shell `L ≲ uv ≲ L²`, and it sends the charge to zero.

## §3. The finding: the bulk is two bulks, and only the neutral one is a diamond

ChhayaGarbha §3 recorded that the sieve-side bulk is precompact (a diamond)
while the spectral-side bulk is, as far as `HOLOGRAM.md` K′ knows, infinite, and
called this a difference of topology. §1–§2 relocate the difference:

- **Amplitude / modulus bulk** — the content visible after the fold onto `uv` =
  `mn/c²`. This is compact on both sides: the diamond `L ≲ uv ≲ L²` is exactly
  its shell. The reciprocity ChhayaGarbha §4 sought does compactify it, and the
  spectral analogue of the diamond is real for this half.
- **Charge / phase / sign bulk** — the content the fold annihilates. This is
  bottomless on both sides, and necessarily so: it is the protected sector, at
  zero for every symmetric (twirl-covariant) observer by Theorem F. K′'s
  "correlation depth grows without ceiling" is this half; the sieve's parity
  blindness (ChhayaGarbha §1) is the same half on the prime side.

So the two problems share their boundary AND their split: amplitude compactifies
onto the diamond, charge does not, on each side identically. §3's "compact vs
infinite bulk" was comparing the pair field's *amplitude* bulk (folded, compact)
against the zero spectrum's *charge* bulk (unfolded, infinite) — two different
halves, not two topologies. The pair field's charge bulk is equally bottomless;
the zero spectrum's amplitude bulk is equally foldable. The diamond is the
neutral bulk, on both sides.

This also sharpens ChhayaGarbha §2's door. The escape from the linear class is
degree two (dispersion) because a scalar-radial (rank-≤3, one-radial-function)
kernel is charge-blind by the rank count of §2; the minimal nonlinearity that
can carry a fourth independent factor is the first candidate for the missing
channel. Whether degree two supplies *exactly* the fourth channel — lifting the
scalar-radial rank from 3 to 4 to match the four-place charge — is the next
exact question, and it is a finite rank statement, checkable in the Lean lane
against `PrimeChargeFourTensorRank`, not an analytic one.

## Rigor boundary

- **Exact, cited to checked terms**: the radial coordinate `mn/c²`
  (`FiniteKuznetsovFactorizationRank.radialCoordinate`); the rank-3-vs-4 charge
  obstruction (`PrimeChargeFourKuznetsovGroupingNoGo`, `crossedTensor_rankExactlyTwo`);
  Theorem F's twirl annihilation (`GAUGE.md` F.2, proved modulo Cuntz).
- **Structural (this note's connective claims)**: `mn/c² = uv` as the same
  compactification coordinate (§1); "collapse onto the modulus is a twirl" (§2)
  — precise as an averaging over the modulus-fixing scale, at the level Theorem F
  uses; the amplitude/charge relocation of §3's topology difference.
- **Conjectural, at K′'s own analogy-precise level** (the windowed-linear class
  still lacks a rigorous definition, `HOLOGRAM.md` K honesty ledger): that the
  spectral *amplitude* bulk is compact under the fold, and the *charge* bulk
  bottomless, symmetrically to the pair field.
- **Open, handed forward**: whether degree-two dispersion is exactly the fourth
  channel (§3, last paragraph) — a finite CP-rank question, checkable.
