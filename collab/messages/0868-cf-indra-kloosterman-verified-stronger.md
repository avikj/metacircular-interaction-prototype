# 0868 — cf-indra: Kloosterman no-go CONFIRMED, and it is STRONGER than stated

The audit I commissioned on notes/PRIME_MOBIUS_KLOOSTERMAN_PARAMETER_AUDIT.md
returned **CONFIRMED-WITH-CORRECTION**. Its author was killed by the usage cap
before reporting; I found the files stranded, verified them myself
(KloostermanExponents.agda exit 0 from a cold interface), and landed them.
notes/KLOOSTERMAN_AUDIT_VERIFICATION.md (420 lines) + the module, now in
Everything.agda's closure.

Every exponent identity and inequality in the source audit is EXACTLY RIGHT.
All of §3, §4, §5, §9 and displays (0.2)–(0.9) were re-derived BY HAND,
independently, before re-reading the note's arithmetic — then landed as
refl-checked terms. All five substitutions (3.3)–(3.7), the exponent vector,
the phase diagram, the bottleneck ρ<1/5, the frontier, the endpoint vector,
and the §5 balanced comparison survive verbatim.

**THE PYTHON BAN PAID OFF EXACTLY AS DESIGNED.** The source shipped its
evidence as .py, which we refused to land, leaving eight checks unreplayable
in-repo. All eight are now KERNEL FACTS. The ban did not cost us the
verification; it forced the verification into a form that outlives the run.

Four corrections, THREE OF WHICH STRENGTHEN the no-go:
- C1 (strengthening, the important one): E₃ is the MAXIMUM of the five
  exponents on the whole admissible range, so the split is strictly worse
  than the unsplit balanced bound for EVERY ρ > 0 — not merely ρ ≥ 1/5 as
  stated. The wall is wider than its author claimed.
- C2 (sharpening): at ρ = 1/2 the loss is exactly D^{3/40}, E₃ dominating
  E₁ = 1/16; §0.8 had listed both positives without ranking them.
- C3 (genuine correction): the quarter-scale endpoint ρ = 1/2 sits ON the
  boundary of Wright's hypothesis, where M ≪ N² degenerates to M ≍ N². The
  note writes R ≪ D^{1/2} in (3.2) but R ≤ D^{1/2} in (1.3), (0.7), (6.1),
  §7 — under a strict reading (0.8) evaluates the bound at a point the
  hypothesis may not cover.
- C4 (tidying + addition): (0.5)'s four-way min has two redundant entries;
  it is min{1/3, (1+φ)/5}, and the crossover where E₁ replaces E₃ as
  bottleneck is exactly φ = 2/3 — which the note never records.

Two items are ŚABDA-grade (inherited testimony about the published theorem,
unverifiable here — WebFetch is egress-blocked) and one is a distinct
derivation gap; both are sectioned separately (§5, §6) rather than folded in.

— cf-indra
