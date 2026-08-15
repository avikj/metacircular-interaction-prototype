---
id: 0765-seed164-seven-components
from: seed164 (Noether × a type theorist who asks what set a tuple lives in before asking what it means)
date: 2026-08-15
kind: proof note — one theorem with an exact converse, a component triage, a four-row finite table, and one CLASSICAL verdict against a claim the corpus already owned
subject: "D0016 §B, the seven-component defect (ledger §1.12, OPEN, nobody had looked). STRUCTURE: it is a PRODUCT of heterogeneously typed lattices — δ^sem lives in P(X), δ^proof in P(Π), δ^boundary in P(D_sep ⊔ D_id) — so 'δ=0' is meaningful but ⊖, norms and any cross-component comparison are NOT. It is not a filtration: all four vanishing patterns of (sem, prov) are realised at |X|=2, |T|=1. THEOREM 1 (new, with an iff): for a uniform component family, ⋃_k δ^{(S,π_k)} ⊆ δ^{(S,id)}, with equality for all C, ρ, σ IFF {π_k} is jointly injective; failure of joint injectivity gives a 2×1 witness by explicit construction. COROLLARY 1.2 — the finding: exhaustiveness of the seven components and the existence of hidden curvature are MUTUALLY EXCLUSIVE. If the tuple is the defect, hidden curvature is impossible; if hidden curvature occurs, the tuple is lossy. §B's π must therefore be a projection onto a PROPER sub-family. HIDDEN CURVATURE ITSELF: CLASSICAL — it is Thm 3 / E2 / E2′ of SHRINKING_TESTS_LOWER_CURVATURE.md restated, and that note names the identification itself. Translation is not a result; the converse (Thm 1) is the part that is not already owned. TRIAGE: 1 definable (sem), 3 definable-with-added-datum (proof ← Π; boundary ← declared boundary, but see the Collapse Cor. K.1; prov ← citation ledger — and YES δ^prov is PreserveProv's defect, with a declared arity mismatch: PreserveProv is binary on a STEP, δ^prov_σ is indexed by a SIMPLEX, reconciled only by the added identification chart = stage). NO REFERENT: charge, outright, and I could construct none. resource and info have no referent AND their only natural completions are functions of δ^sem — for info this is a one-line REFUTATION of independence under any full-support measure (Prop 5.7.1). VERDICT ON 'SEVEN': the number does no work. Every §B claim is binary — reported vs withheld. Two coordinates suffice for all of it; four of the seven names are placeholders."
predecessors:
  - collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md (§B; triage §J3, §J6)
  - notes/OWNER_TRANSMISSIONS_LEDGER.md (§1.12 — the OPEN item worked here; §1.1, §1.13–1.14)
touches:
  - notes/SEVEN_DEFECT_COMPONENTS.md (new)
reads:
  - notes/SHRINKING_TESTS_LOWER_CURVATURE.md (Def. 1.1–1.7, Thm 1–5, §4 Thm 3/Cor 4.2, E1/E2/E2′, §5A, §6, §7, §7A — read in full)
  - notes/CHANGING_TESTS_VERSUS_SHRINKING.md (Thm A–F, Def. 6.1, Thm E, Prop. 6.3)
  - notes/ADVANCE_CONJUNCTS_DEFINED.md (Def. 1–5, Lem. 2, Prop. 2–3, Thm K, Cor. K.1–K.3)
verdict: PARTIAL (split named) — product structure PROVED; non-implication TRUE only for proper sub-families and FALSE for exhaustive ones (Cor. 1.3); hidden curvature CLASSICAL within this corpus; independence PROVED for (sem, prov) and REFUTED for (sem, info); exhaustiveness OPEN and unsettleable as posed; "seven" carries no content
---

# Summary

**Ledger §1.12 asked for "a statement of what each component *is* as a function of
$(X,\mathcal T,e,\rho)$." §5 of the note gives it where such a function exists and names the
missing datum where it does not.** The tally: 1 / 3 / 3.

**The one theorem.** For a uniform component family $R=\{(S,\pi_k)\}$,
$$\bigcup_k\delta^{(S,\pi_k)}_\sigma\subseteq\delta^{(S,\mathrm{id})}_\sigma,$$
with equality for *every* Chu space, connection and simplex **iff** $\{\pi_k\}$ is jointly
injective. The forward inclusion is Thm 3 of the predecessor applied $k$-fold; the converse is
a two-point, one-test construction from any pair $q\ne q'$ that all $\pi_k$ identify. Both
directions are finite and elementary.

The quantifier is load-bearing and I flag it rather than let it read as an iff at a fixed Chu
space, where a non-injective family can achieve equality by accident (standing check (e) —
this is the error found in D0017 §F and I have not repeated it).

**What follows, and it is the point.** Hidden curvature is a property of the *report*, not of
the connection. $\delta^{\mathrm{sem}}=\emptyset$ with $\delta^{\mathrm{prov}}\ne\emptyset$
(row P3 of the table = seed148's E2′, credited not reclaimed) reads as hidden curvature only
because $\delta^{\mathrm{prov}}$ is withheld; report both and the join formula holds exactly.
This is *zero curvature is not truth* one level up: **zero reported curvature is not zero
curvature, and the two coincide exactly when the report is complete.**

**What I am refusing to claim.** The hidden-curvature display of §B is not new work: it is
Thm 3 with E2/E2′, and `SHRINKING_TESTS_LOWER_CURVATURE.md` §5 states the identification in
its own words. Per D0016 §J6 I record it as CLASSICAL-within-corpus rather than re-proving it
in component vocabulary. What is not already owned is the characterisation of *when* it can
occur, and that is one theorem, not a framework.

**For the owner, one request.** $\delta^{\mathrm{charge}}$ has no referent anywhere in D0016,
D0017, D0018 or the five adjudicating notes, and I could construct none that was not a
duplicate of $\delta^{\mathrm{sem}}$. It is the single blocking item for further work on §B.

**Scope.** Uniform families only; vanishing not magnitude; no common home constructed for the
seven types; the Collapse (Cor. K.1) inherited not re-proved; the ladder, $\mathfrak F$,
$\Gamma$, $\mathbb B$ and the Yang–Baxter defect untouched, as in every predecessor.

**Substrate.** No experiment, no floating-point number, no Python, no Agda or Lean authored or
typechecked, no PDF claimed as read. Theorem 1 is two inclusions and a construction; §6 is a
four-row table of coordinate comparisons, complete and checkable by reading it.
