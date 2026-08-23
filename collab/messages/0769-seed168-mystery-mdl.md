---
id: 0769-seed168-mystery-mdl
from: seed168 (Kolmogorov × someone who will not quote a description length without naming the machine)
date: 2026-08-15
kind: adjudication note — the MDL layer spanning D0018 §A and D0019 §F
subject: "The invariance theorem sorts the four MDL objects into three grades, and the sorting rule is exact: slack = (number of non-cancelling L-terms) × c(U,V), and a statement survives iff it is an unbounded family rather than a sign test or a selection. (I1) ΔMystery at fixed X SURVIVES — L(X) cancels identically, leaving L(X|𝔏)−L(X|𝔏'), two terms, uniform 2c slack, and the quantity is unbounded. (I2) Mystery(X) absolute survives ONLY as an asymptotic: 'Mystery(X)>0' and 'X is more mysterious than Y' are not machine-invariant, so §F's title word 'conserved' is indefensible while 'relocated' is fine. (I3) gain(σ)>0 is THREE terms with no cancellation used as a SIGN TEST on a single σ — under the Kolmogorov reading it is NOT WELL-DEFINED as a criterion (Prop 1); it births different signs on different machines. Well-defined only under a named concrete code, which is the textbook two-part-MDL trade-off. (I4) argmin is the weakest: a selection has no asymptotic form to retreat to, and candidates within 6c(U,V) reorder with the machine. CORRECTION TO D0019 §J6, which was right about the hazard and wrong about which argument to fix: it is differences at fixed X varying 𝔏 that cancel, NOT 'differences at fixed 𝔏' — at fixed 𝔏 varying X nothing cancels — and J6 never connected the hazard it recorded to (G) or (A). ΔMystery = −ΔCompression IS a tautology under Reading B (Compression := residual length) restricted to ΔL(X)=0, and is FALSE under Reading A (Compression := saving, where Mystery = Compression identically so the identity asserts ΔS = −ΔS). DEFECT IN THE DEFINITION, reported not rewritten: L(X)−L(X|𝔏) is the standard I(𝔏:X), which is LARGE exactly when 𝔏 explains X well — it is the mystery DISPELLED, not remaining; the sign is backwards relative to the word and relative to §F's own gloss. Substantive claim adjudicated (Thm 1): knowledge growth ⇏ mystery decrease is TRUE and splits — FAILS up to O(1) under cumulative growth (prepend the recovery program), HOLDS unboundedly under replacement. It is exactly non-monotonicity of K(·|y) under REPLACING y rather than EXTENDING it. Consequence the transmissions do not draw: D0018 §A's own ladder is a cumulative colimit, hence in the regime where mystery CANNOT grow — §F's law is true in general and inapplicable to §A's construction unless 𝔠 discards; whether 𝔠 is conservative is the missing datum. ARGMIN: existence is NOT the problem and D0018 §J7's complaint is DISCHARGED by a proof shorter than the complaint — the objective is ℕ∪{∞}-valued, so well-ordering gives an attained minimum with NO topology, NO compactness, NO cardinality bound (Thm 2). What fails is definiteness: non-unique always (length-preserving relabellings, Thm 3), no tie-breaking rule supplied, and the identity of a minimiser is not machine-invariant (Thm 4). Under a REAL-valued objective (−log prior, stochastic complexity, NML) (H1) fails and existence is genuinely open with compactness/lsc as the missing hypotheses. GAIN IS WELL-FOUNDED — a positive result: with L and 𝔔 fixed in advance, #{σ : gain(σ)>0} < 2^{L(𝔔)} by Kraft (Thm 5), and the stage-relative iterate has μ(α) = L(𝔔|𝔏_α) ∈ ℕ strictly decreasing, terminating in ≤ L(𝔔|𝔏_0) steps (Thm 6) — precisely the well-founded measure ADVANCE_CONJUNCTS_DEFINED §9 proved unavailable for Advance, and no contradiction, since gain is not a function of resolving power (which is why Theorem U does not reach it). PROP 5 VERIFIED BY READING, and STRENGTHENED: its side condition (L declared in advance, defeating post-hoc gaming) is NECESSARY AND NOT SUFFICIENT — one can declare 'L = K_U for U named later' and satisfy Prop 5 while failing invariance entirely; the second condition (L concrete and named) is independent and is supplied here. Three ways finiteness is lost, all realised in the transmissions: 𝔔 grows (§F ΔReach, §G diag — this is the mechanism by which 'new mystery may be born' is CONSISTENT with §A's minting rule, the one place the two sections lock together); L varies with α (Prop 5 verbatim); batch minting (gains are not additive, and Definition 4 of that note sums them — gap named, not filled). ρ(D𝒦) ≠ χ_α: different TYPES (scalar ratio of two increments vs modulus of an eigenvalue of a linearisation), and two undefined quantities cannot be proved equal, so D0019 §J5's identification is itself unfounded — FALSE GROUND, correct disposition; the right ground is the one J5 states two sentences later and does not connect (no domain, norm, linearisation or basepoint for 𝒦), which suffices alone. Neither quantity measured, defined, or rehabilitated. Nothing here is new mathematics: invariance (Li–Vitányi 2.1.1), I(y:x) (§2.8, Levin–Gács), Kraft (Cover–Thomas 5.2), MDL code-dependence (Rissanen 1978, Grünwald 2007), Floyd 1967. No PDF read."
predecessors:
  - collab/upstream/raw/D0019-owner-fourth-transmission-2026-08-15.md (§F, §A, triage §J5, §J6)
  - collab/upstream/raw/D0018-owner-third-transmission-2026-08-14.md (§A, triage §J5, §J7)
touches:
  - notes/MYSTERY_AND_DESCRIPTION_LENGTH.md (new)
reads:
  - notes/ADVANCE_CONJUNCTS_DEFINED.md (§6.4 Definition 4 and Proposition 5 in full, Proposition 4, §9 — verified by reading, not summary)
verdict: "machine-invariant: ΔMystery at fixed X only (unbounded families); Mystery(X) asymptotically only; gain(σ)>0 NOT invariant under the Kolmogorov reading and meaningless as a single-sign test; argmin invariant in neither value nor identity. The argmin EXISTS and is attained (ℕ-valued objective, well-ordering — no topology) but is non-unique with no tie-breaking rule, and existence is open for real-valued objectives. gain IS well-founded under two independent side conditions (L fixed in advance AND L concrete), mint-set < 2^{L(𝔔)}. ρ(D𝒦) and χ_α are NOT the same quantity."
---

## What was asked and what was done

Adjudicate the MDL layer that spans two owner transmissions and had never been
adjudicated: fix the machine or prove nothing can be said; decide whether
$\Delta\operatorname{Mystery}=-\Delta\operatorname{Compression}$ is a tautology and if so
adjudicate the substantive claim instead; decide whether the argmin exists; test
$\operatorname{gain}(\sigma)>0$ for well-foundedness against `ADVANCE_CONJUNCTS_DEFINED`
Prop. 5; and say whether $\rho(D\mathcal K)$ and $\chi_\alpha$ are the same quantity.

The work is `notes/MYSTERY_AND_DESCRIPTION_LENGTH.md`. Its spine is one lemma — the
invariance constant is *uniform in the arguments*, so an expression in $k$ non-cancelling
$L$-terms carries slack $\le kc(U,V)$ uniformly — and the observation that this makes
survival depend on the *form of the assertion*: an unbounded family survives, a sign test
does not, a selection cannot.

Three things I did not expect going in, recorded because they cut against the mandate's
own expectations:

1. **The argmin exists.** The mandate anticipated "not known to exist, here is the missing
   hypothesis". Integrality of code length plus well-ordering of $\mathbb N$ gives an
   attained minimum with no topology at all, discharging D0018 §J7's complaint in three
   lines. The real defect is one level down — non-uniqueness with no tie-breaking rule,
   and a machine-dependent identity. Existence returns as a genuine open question only for
   real-valued MDL objectives, where (H1) fails.
2. **gain is well-founded**, and supplies for sign-minting exactly the strictly-decreasing
   map into $\mathbb N$ that `ADVANCE_CONJUNCTS_DEFINED` §9 proved unavailable for
   $\operatorname{Advance}$. No contradiction: gain is not a function of resolving power,
   which is why Theorem U does not reach it — the same reason Prop. 5 gives.
3. **Prop. 5's side condition is necessary and not sufficient.** It defeats post-hoc
   gaming; it does not defeat machine arbitrariness. Both are needed, and they are
   independent. This is a strengthening of that note's own conclusion.

The one defect I found in the owner's definition — that
$L(X)-L(X\mid\mathfrak L)$ is the mystery *dispelled*, not remaining — is reported with
the repair stated and **not applied**: the owner may take or refuse it, and every theorem
in the note holds under either convention.

Standing checks discharged in the note: (a) no hint pursued beyond scope; (b) Prop. 5 read
in full before being used; (c) D0019 §J6's summary line was found to have the fixity on the
wrong argument; (d) D0019 §J5 is a false-ground finding with a correct disposition, the
fourth such in the corpus; (e) the concluding generalisation ("an MDL formula is worth
writing down iff every unconditional $L$ in it cancels") is stated with its domain and its
expected exception class (expressions with growing logarithmic terms); (f) six scope limits
listed, including that Theorem 6 is clean under a concrete code and only an
$O(\alpha)$-slack statement under Kolmogorov complexity.

No experiment, no Python, no numerical computation, no fitted constant, no Agda or Lean
authored, no PDF read.
