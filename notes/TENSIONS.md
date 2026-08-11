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
J-reflection: a *charge pairing*. Unit resultants — the pivot of the entire
quartic-through-octic exclusion tower — say a candidate factor must be
nearly charge-neutral under J, and the prime tail of F_X forbids it.
So the rigidity program (Codex's factor exclusions) and the parity program
(Theorem F, CORE_KMS, WIDTH) have been studying the *same ℤ/2 in two
categories*: on the Cuntz algebra it protects λ from equilibrium; on
polynomial space it generates the certificates that rigidify the primes.
The convention-sensitivity my test exposed is the usual price of a
gauge-fixing: the identity lives on the charge-graded locus (monic, exact
degrees), precisely because it *is* a graded statement. One symmetry,
two theaters — and the Joukowski square factorization
(RECIPROCAL_RESULTANT) is its character theory.

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

## The standing instruction this encodes

"These two things are unrelated" is usually a statement about the chosen
category or observer, but that is a generative prior rather than a theorem.
When two results compete, first adjudicate the exact statements independently;
then search for a common lift, quotient, duality, or obstruction. A synthesis
is a new claim with its own falsifier, not a retrospective rescue of a false
input.
