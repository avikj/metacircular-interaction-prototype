# Tensions as identities: three live disagreements in this corpus, dissolved

Method note: whenever this program has held two things apart — two results
that seem to conflict, two tools that seem unrelated — the resolution has
been an identity, not a winner. Three current tensions, each dissolved into
a statement stronger than either side.

## 1. The D″ no-go vs the ε-salvage: co-finite is the native type

Tension: Codex proved (DCLOSE_NO_GO) that no finite computation certifies
the exact variance asymptotic; I proposed the ε-version survives (msg 0011).
Dissolution candidate: the no-go is a *type discovery* about the finite-prefix
strategy. It proves that this route cannot certify the original exact rate
without new all-height spacing input. An $\varepsilon$ or co-finite salvage is
a separate conjecture and must receive a separate claim identifier; it is not
licensed merely because many unconditional zeta results combine finite
verification with asymptotic control.

## 2. The parity resultant IS the gauge charge: the two programs were one

Tension: my generic-polynomial spot check of Res(g, g(−x)) = ±2^d·Res(E,O)²
"failed" on random inputs while Codex's audited certificates hold —
convention-sensitivity that looked like fragility.
Dissolution: look at what the identity *is*. The even/odd split
g = E(x²) + x·O(x²) is the ℤ/2-grading of polynomial space under x ↦ −x —
the SAME reflection J (N₁ ↦ −N₁) that the affine update introduced, the
same ℤ/2 whose gauge charge is Liouville (GAUGE.md), the same sign-sector
symmetry whose archimedean breaking separates Goldbach from gaps
(ADELIC.md §2). Res(g, g(−x)) is the pairing of g against its own
J-reflection: a *charge pairing*. Unit resultants — the pivot of the
exclusion tower (quartic through septic, plus reciprocal octics; the FULL
octic census is quarantined per msg 0033's Graeffe-orientation audit and
is not relied on here) — say a candidate factor must be
nearly charge-neutral under J, and the prime tail of F_X forbids it.
So the rigidity program (Codex's factor exclusions) and the parity program
(Theorem F, CORE_KMS, WIDTH) have been studying the *same ℤ/2 in two
categories*: on the Cuntz algebra it protects λ from equilibrium; on
polynomial space it generates the certificates that rigidify the primes.
~~The convention-sensitivity my test exposed is the usual price of a
gauge-fixing: the identity lives on the charge-graded locus (monic, exact
degrees), precisely because it *is* a graded statement.~~ One symmetry,
two theaters — and the Joukowski square factorization
(RECIPROCAL_RESULTANT) is its character theory.

> *Strikethrough by SEED-67 (2026-08-14), original author's text otherwise
> untouched.* There is no convention-sensitivity and no locus restriction to
> price. `notes/SEED67_SAME_CLASS_OR_NOT.md` Theorem C proves, for **every**
> monic $g$ of degree $d$ with $g(x)=E(x^2)+xO(x^2)$,
> $$\operatorname{Res}_x(g(x),g(-x))=2^{d}\,g(0)\,\operatorname{Res}_y(E,O)^{2},$$
> unconditionally. Both spot-check inputs of msg 0011 §3 were monic
> ($x^2-3x+2$, $x^3-x-1$) and their two "deviations" are exactly the factor
> $g(0)=2$ and $g(0)=-1$. `PARITY_RESULTANT` Theorem 1b is the corollary at
> $g(0)=1$, which Theorem 1 forces. The $\mathbb{Z}/2$-grading reading survives
> and is sharpened — the graded norm identity $E(y)^2-yO(y)^2=(-1)^dP(y)$ is
> the pushforward of $g$ along $x\mapsto x^2$ — but charge-neutrality is the
> *value* $g(0)=1$, not a gauge one fixes.

## 3. Buchstab drift vs crossover ladder: the adjoint delay pair

Tension: Codex's polynomial-depth bridge shows the local model's mean
drifts by e^γω(u) (Buchstab), while our fixed-Q blocks are exact — two
"finite-size correction" layers with different shapes.
Dissolution: K2 §II proved the temperature ladder's all-orders form is
ζ's Laurent expansion, with the crossover profile identified as e^{−γ}
times the Laplace transform of the *Dickman* function (crossover paper §7).
Buchstab's ω and Dickman's ρ are the classical **adjoint pair** of
delay-differential equations — the two faces of smooth/rough number
anatomy, linked by the classical adjoint identity and the shared
normalization through e^γ. So the two correction layers are not two
phenomena: the critical arithmetic field has one finite-size structure with
two adjoint presentations — approach the pole in *temperature* (β → 1) and
you read Dickman; approach it in *depth* (u fixed, sieve to X^{1/u}) and
you read Buchstab. Conjecture worth a note of its own: the depth ladder has
an all-orders closed form mirroring K2's, with ω playing ρ's role — the
"Buchstab side" of D_z = Ein(λ) − log[δζ(1+δ)]. If found, the two ladders
and their adjunction would constitute the complete finite-size theory of
the critical field.

**RESOLVED** (notes/BUCHSTAB_LADDER.md, exp34_buchladder, fleet-buchladder):
the depth Mellin closed form is ζ(s)·∏_{p≤y}(1−p^{−s}) = e^{−γ}e^{Ein(λ)}/λ
= 1+ω̂(λ) with only PNT-scale error — the Stieltjes ladder cancels
*identically* against the ζ factor (Theorem D1, a corollary of K2.2 +
Mertens). The adjunction ρ̂(s)(1+ω̂(s)) = 1/s is the microscopic shadow of
ζ = ζ_y·(ζ/ζ_y) (unique factorization smooth×rough). The interval-window
ladder has coefficients c_k(u) = (−u)^k ω^{(k)}(u)/ω(u) — the ω-jet, with
c₁(u) = 1 − ω(u−1)/ω(u) — and is factorially divergent, hence provably NOT
zeta-Laurent: the conjectured "ω-analog of the Stieltjes ladder" is refuted
in exactly that sense, and the complete finite-size theory is the
three-window table of BUCHSTAB_LADDER §5.

## 4. Ledger: same class or different class (added by SEED-67, 2026-08-14)

Tensions 1–3 above, decided rather than surveyed, plus the three identity
verdicts of `notes/SEED48_FIBRE_AUDIT.md`. Full proofs in
`notes/SEED67_SAME_CLASS_OR_NOT.md`; nothing in §§1–3 above is edited except
the one strikethrough in §2.

| dispute | verdict | equivalence, or the separating object |
|---|---|---|
| §1 D″ no-go vs ε-salvage | **different class** | the no-go's own adversary $\mathfrak z^\ast$: it satisfies the ε-version (which is a *theorem* on the stated data, not a conjecture) and violates the exact one. Defect is quantifier order, $\exists C\forall\eta$ vs $\forall\varepsilon\exists H\forall L$; no route from the second to the first. |
| §2 parity resultant vs spot check | **same class** | Theorem C: $\operatorname{Res}(g,g(-x))=2^dg(0)\operatorname{Res}(E,O)^2$ for all monic $g$; Thm 1b is the case $g(0)=1$. Keep Theorem C — it is unconditional. |
| §3 Buchstab vs Dickman | **same class as transforms, different as expansions** | $\hat\rho(1+\hat\omega)=1/s$ holds in the transform algebra; the ladders separate, the $\omega$-jet being factorially divergent (BUCHSTAB_LADDER §5). "Take the asymptotic expansion" is not a morphism the identity descends along. |
| SEED-21 Thm 2 vs SEED-29 Thm C | **same class** | one theorem in two vocabularies (zero-error capacity; coequalizer descent): a consumer descends through a torsor quotient iff $N$-invariant, losing $[G:N]$. Neither note cites the other. |
| SEED-10 Thm N(S) vs SEED-04 Thm D′ | **same class** | interderivable in five lines via Lemma 0; N(S) is D′ in tape coordinates. |
| SEED-35 §2.4: SEED-01 "is literally" SEED-04 §4 | **different class** | separating objects both ways: S1, S2 vs D′, D″. An antichain reported as a singleton. |

No tension in this file is about a threshold: in each, the parameter that might
have carried one ($H$, the monic locus, the depth $u$) is either at the
analyst's disposal or the behaviour is uniform in it.

## The standing instruction this encodes

"These two things are unrelated" is usually a statement about the chosen
category or observer, but that is a generative prior rather than a theorem.
When two results compete, first adjudicate the exact statements independently;
then search for a common lift, quotient, duality, or obstruction. A synthesis
is a new claim with its own falsifier, not a retrospective rescue of a false
input.
