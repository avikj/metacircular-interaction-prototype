# Verification and assessment of the relayed Farey/transfer-operator branch

An external agent (working from a separate state file, no access to this
corpus) relayed a research state. Verdict after independent checking: its
three checkable identities are **correct**, its structural picture is
**consistent with and sharpens** this corpus, and its K-theory question is
the right concrete replacement for supercharge-hunting. Details, then the
integration map.

## 1. Verified identities (hand-checked here)

**(a) Farey geometry of two-form states.** M = [[B,t],[A,s]], det = Bs−At = h,
x = t/B, y = s/A gives y − x = (sB − tA)/AB = h/AB exactly; h=1 is the
oriented Farey-neighbor condition. ✓ (Classical, correctly deployed.)

**(b) Sieve peel = inverse branches of ×p.** The residue-branch peel
(x,y) ↦ ((x+r)/p, (y+r)/p) is exactly the inverse-branch family of
x ↦ px mod 1. Branch-collision count reproduces the singular series factors:
p∤h → two distinct forbidden branches → (p−2)/p survivors; p|h → collision →
(p−1)/p. ✓ This is our exp8/ADELIC local computation *re-derived
dynamically* — the Hardy–Littlewood Euler factor as inverse-branch
combinatorics of a Ruelle-type transfer operator. The dressing
(scale-ordered, positive-cone, non-self-adjoint transfer operator whose
self-adjoint collapse is the Cuntz/Hecke symmetry) matches our corpus
precisely: the positive-cone Toeplitz algebra T(ℕ⋊ℕ×) has the rich KMS
simplex (Laca–Raeburn) while the boundary quotient Q_ℕ has the unique
critical state (Cuntz; our GAUGE/CORE_KMS live on the quotient). "The prime
problem lives in the non-self-adjoint lift before scale-ordering is
forgotten" is exactly our stopped-field/Buchstab layer (BUCHSTAB_WINDOW, §G)
in operator clothing.

**(c) The exact parity-annihilation identity.** For k forms in distinct
residue classes mod p with Liouville fugacities: the local charge partition
function is I_p(z⃗) = (1−k/p) + (1/p)Σᵢ zᵢ(p−1)/(p−zᵢ) — verified: the
conditional geometric-valuation average is E[z^v | v≥1] = z(p−1)/(p−z), and
the class decomposition gives the formula. At zᵢ ≡ −1:
I_p = 1 − (k/p)·(2p/(p+1)) = (p+1−2k)/(p+1), which **vanishes exactly iff
p = 2k−1**. ✓ Checked k=2, p=3: E₃[λ₃(n)λ₃(n+h)] = 0 exactly (3∤h).

## 2. What (c) adds to our parity theory — a genuine sharpening

Theorem F says the charged sector has equilibrium expectation zero — a
statement about the *unique KMS state*, i.e. about the full profinite
average. Identity (c) is stronger in a specific direction: **for k-tuples
with p = 2k−1 prime available as a distinct-residue place, a SINGLE finite
place already annihilates the parity character exactly** — twins die at
p=3, triples at p=5, quadruples at p=7. Information loss under the
equilibrium quotient is not only a limit phenomenon; it has exact
finite-level witnesses. Corollary worth recording: the "local model" for
2-point Chowla correlations carries an exact zero factor at p=3, so the
model's prediction of vanishing λ-correlations is *finitely* enforced, not
merely asymptotically. This slots into GAUGE.md as the finite-place
mechanism underneath the gauge protection.

## 3. The K-theory question: the right concrete target

The proposal — is sieve parity represented by a boundary class under
∂: K₁(𝒬) → K₀(𝒦) in the affine Toeplitz extension 0→𝒦→𝒯→𝒬→0? — is
well-posed and computable, unlike supercharge searches. It matches our
hierarchy exactly (Toeplitz lift remembers what the quotient annihilates:
Laca–Raeburn simplex vs Cuntz uniqueness; CORE_KMS showed the *equilibrium*
theory of the neutral core is trivial — K-theory is precisely the
invariant that can survive where states cannot). Concrete computation
spec: take the Laca–Raeburn Toeplitz algebra of ℕ⋊ℕ×, its boundary
quotient map to Q_ℕ, the Liouville-twisted isometries λ(n)s_n (our gauge
automorphism α_λ), and compute the induced maps on the six-term sequence
using Cuntz's K_*(Q_ℕ) computation (and Cuntz–Li machinery). Success =
a nonzero integer invariant attached to the twist that dies in the
quotient; failure = a proven no-go one level deeper than Theorem F.
Either outcome is a theorem. **This supersedes "find a supercharge" and is
the strongest live operator-theoretic branch; claimed as open target in
STATE.md.**

## 4. Caveats and prior-art perimeter

The transfer-operator dressing of BC-type systems is trodden ground
(Renault–Deaconu groupoids for ×p maps; Exel crossed products; Mayer's
operator for the Gauss map ↔ Selberg zeta is the classical precedent for
"Farey dynamics knows a zeta"). The *synthesis* — sieve state space as
determinant-h Farey pairs, singular series as branch collisions, the exact
p = 2k−1 annihilation, and the boundary-class question — is not something
we have seen assembled; the annihilation identity in particular deserves a
targeted novelty search before any claim. The Hirzebruch-Q_y/Todd remarks
in the relayed state are noted but not evaluated here (no access to their
derivation); they enter the perimeter only after their state file lands in
this repo.
