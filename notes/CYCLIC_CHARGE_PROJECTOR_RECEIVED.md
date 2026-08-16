# The cyclic charge projector: Factory IV's Theorem 58 is its M = 2 instance, and the conditioning is exactly 1

**Author.** cf-corner (Claude Fable 5), 2026-08-16.
**Receives** (owner upload, archived verbatim with manifests and reports):
`collab/upstream/library/raw/prime-pair-2026-08-16/` —
`PRIME_PAIR_CYCLIC_CHARGE_CRT_BOUNDARY_THEOREMS_V2`,
`PRIME_ATOM_TOMOGRAPHY_CONDITIONING_THEOREMS`,
`PRIME_MOBIUS_KLOOSTERMAN_PARAMETER_AUDIT`; and
`collab/upstream/library/raw/circulation-0002/` (EGB circulation event 0002:
interference pass, claim-graph extensions, dynamic sieve, validation).
The fourth upload was byte-identical to the already-archived V3 index
(sha256 `f8f26139…`) — idempotent re-send, no action.
**Substrate note.** Each package ships a `.py` calibration artifact. Archived
as provenance, **not run** (ban; `CLAUDE.md`). Nothing below depends on them.

---

## 0. The join, which is the reason to read this

The uploaded CRT-boundary document defines the divisor charge kernel
$a_z(d)=(z^{\Omega}*\mu)(d)=z^{\Omega(d)-\omega(d)}(z-1)^{\omega(d)}$ and
extracts its charge-one coefficient by finite Fourier inversion over $M$-th
roots of unity, $M>\Omega(d)$, $\zeta=e^{2\pi i/M}$:

$$\kappa_1(d)=\frac1M\sum_{\nu=0}^{M-1}\zeta^{-\nu}a_{\zeta^\nu}(d).\tag{0.2}$$

> **The join.** Factory IV's Theorem 58 — the parity projector
> $(1-\lambda)/2$ is exact on the Chen envelope — **is (0.2) at $M=2$.**
> Charge support $\{1,2\}$ means $\Omega<2$ fails but the *support* has two
> points, so two evaluation points suffice; with $M=2$, $\zeta=-1$, the sum
> $\tfrac12\bigl(a_{+1}-a_{-1}\bigr)$ is exactly the odd-charge projector,
> and $z^{\Omega}$ evaluated at $z=-1$ is $\lambda$. Parity is not a
> special trick available after Chen: it is the smallest instance of the
> cyclic charge-character projector, and Chen's theorem is precisely the
> analytic input that shrinks the support to where $M=2$ suffices.

This corpus already has the $M=2$ case **machine-checked**:
`formal/cubical/NaturalMachine/ChenProjector.agda` (`theorem-58`,
`projector-sound`/`projector-complete`, both directions, exit 0), and its
channel refinement `NaturalMachine/ThreeChannels.agda`
(`primitive-projector`, the $\mu^2-\pi_1$ identity of Factory IX). The
uploaded document supplies the general-$M$ statement those two are instances
of; the Agda supplies the checked base case. Neither was written knowing
about the other, which is why the agreement is worth recording.

## 1. Why the general form is quantitatively better, not just prettier

`PRIME_ATOM_TOMOGRAPHY_CONDITIONING_THEOREMS` prices three exact probe
families that all recover the same charge-one term $a_0$, under a matched
support-normalized independent absolute-error model:

| probe family | exact worst-case amplification |
|---|---|
| power moments $P_m=(z\partial_z)^mG(1)$ | $\kappa_{\mathrm{pow}}(R)=\binom{2R}{R}\sim 4^R/\sqrt{\pi R}$ (raw: $R+1$) |
| factorial moments / Taylor jet $F_m=G^{(m)}(1)$ | $\kappa_{\mathrm{fac}}(R)=2^R$ |
| **cyclic charge DFT** | $\boxed{\kappa_{\mathrm{DFT}}(R)=1}$ |

So the projector this corpus has been formalizing is the *perfectly
conditioned* one — exponentially better than either moment route — and the
document states the operator form directly:
$P\,U_h\,P\,U_k\,P=\frac1{R+1}\sum_\nu P\,U_h\,\omega^{\nu(C-1)}U_k\,P$.

**This changes a standing corpus judgement.** The moment/tomography lane had
"stable growing-degree reconstruction is open" as prose; it is now
sharpened into exact basis-dependent constants, and the winner is the basis
the parity lane was already using. Conditioning was the missing coordinate.

## 2. The three no-gos the packages land (each worth citing, none proved here)

1. **Diagonal reduction is endpoint-sufficient but decomposition-inexact.**
   The one-variable total-charge projector recovers the *endpoint count*
   ((0.4)) but not the main/boundary split: $[u^2]\Delta_X^W(u,u;h)=
   \Delta_{0,2}+\Delta_{1,1}+\Delta_{2,0}$, so
   $\Delta_{1,1}=[u^2]\Delta(u,u)+\mathcal M_{0,2}+\mathcal M_{2,0}$ ((0.5)–(0.6)).
   The "exact curvature" of the cheap 1-D quotient is the vacuum/charge-two
   pair. *(Directly relevant to `MARGINAL_TO_JOINT_CORNER.md`: this is a
   second, independent instance of a marginal that determines a total and
   not a decomposition.)*
2. **Phase reconstruction removes interpolation instability, not
   cancellation.** $|a_{e^{i\theta}}(d)|=(2|\sin(\theta/2)|)^{\omega(d)}$ and
   Parseval give $\sum_r|\kappa_r(d)|^2=\binom{2j}{j}$, $j=\omega(d)$ ((0.7)):
   the inverse DFT is perfectly conditioned while the phase-family *energy*
   is exponentially larger than the coefficient being extracted. A perfectly
   conditioned inversion of an exponentially large family is still an
   exponentially large object — the arithmetic cancellation must come from
   elsewhere. **This is the sharpest statement in the upload**, and it is the
   quantitative form of the corpus's own standing warning that a
   representation change is not an estimate.
3. **Fixed-factor Kloosterman estimates do not reach the boundary
   termwise.** The exact quarter-scale factorization at $D\asymp X^{1/2}$
   lands *inside* the structural hypothesis of the Bettin–Chandee /
   Wright trilinear fixed-factor theorems, but is nontrivial only on a much
   shorter subrange; the untreated range is the **moving short factor**.
   Stated obligation: get cancellation from the average over the moving
   factor, or use prime/Möbius coefficient structure invisible to
   arbitrary-coefficient estimates. Citations are inherited and flagged as
   such by the source (Bettin–Chandee arXiv:1502.00769 Thm 1; Wright
   arXiv:2604.25177v2 Thm 2.1 — **UNVERIFIED here**, egress blocked).

## 3. What this repository should do with it

- `PROVE` — the general finite-support inversion at the level the Agda lane
  can hold: *charge support of size $k$ is determined by $k$ evaluations,
  and no fewer* (Vandermonde). `ChenProjector` has $k=2$; the general
  statement needs a root-of-unity or Vandermonde development that v0.5
  supports only over a commutative ring, so the honest first step is the
  ring-level statement, not the analytic one.
- `PROVE` — (0.5)–(0.6) is a finite linear identity among four counters. It
  is formalizable today in the `ThreeChannels` vocabulary
  (`count-split`-style), and it would give the corner note its second
  worked instance of marginal-vs-decomposition.
- `SEARCH` — the two Kloosterman citations, when egress exists.
- **Do not** re-derive the conditioning constants numerically. They are
  exact and derived; the ban applies (`CLAUDE.md`), and the source already
  states them as theorems with proofs.

## 4. Honesty ledger

Proved in the uploads, read and understood here: (0.1)–(0.7), the three
conditioning constants, the operator DFT form. Not verified here: the
uploads' own numerical/`.py` calibrations (not run), the two inherited
Kloosterman theorems (no egress), and every claim in the circulation-0002
JSON graph (archived, not audited — a separate pass). Contributed by this
note: the $M=2$ identification with the corpus's checked parity projector,
the conditioning reading of why that basis is right, and the queue above.
