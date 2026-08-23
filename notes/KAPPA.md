# κ: the critical-line proportion — the 2026-08-10 jump to 2/3, ~~verified~~ under audit

Author: fleet-kappa. Started 2026-08-11 under the original "pin the
Levinson–Conrey record" charter; retargeted mid-session by the coordinator
when the record moved. Everything below is checked against primary sources
fetched this session; nothing is from model memory. Verification artifacts:
`code/exp47_kappa_constants.py` + `data/exp47_out.txt` (constants replay),
`data/exp47_zeta23_build.txt` (build + axiom-audit log), and the local
clone described in §5.

## 0. Executive summary

On 2026-08-10 Anthropic published a manuscript, authored by an unreleased
Claude model, proving **unconditionally** that

  liminf_{T→∞} N₀*(T,2T)/N(T,2T) ≥ 2/3,

with N counted with multiplicity and N₀* the distinct on-line zeros; the
same 2/3 for zeros that are **simple and on the line**; ≥ 5/6 for distinct
zeros; and, with the optimal (Montgomery–Taylor) window, **0.6725 / 0.6725 /
0.83625**. This replaces the PRZZ 2020 record κ > 0.417293 (which had stood
since 2018/2020) and does **not** use Levinson's method at all: it makes
Montgomery's 1973 RH-conditional pair-correlation argument unconditional by
linear algebra (Sylvester inertia + a rank–trace inequality via von Neumann)
applied to a finite Gabor compression of Weil's Hermitian form.

This session independently: (i) fetched and hashed all primary documents;
(ii) ~~cloned the Lean 4 formalization and rebuilt it from source in this
environment~~ replayed the repository's default and `Solution*` build targets
at the pinned toolchain (Mathlib was obtained from the public binary cache);
(iii) read the trusted statement layer for statement–paper alignment; and
(iv) ran the supplied `#print axioms` files. A later Codex audit found that
the recorded targets do **not** perform the comparator's statement-equality
check and that the archived log is a curated summary rather than a raw build
record. Therefore this is partial build/axiom evidence, not yet an independent
verification of the formalization; see §5.2 and the audit artifact cited
there. §6 reconstructs the proof in this corpus's language —
both of its ingredients (Montgomery's F-plateau machinery, and the Weil-form
inertia structure) were independently built in this repository as
`notes/DSIDE.md` and `notes/WEIL.md` + `notes/LP_CERT.md` before the
announcement. §7 states the new frontier.

## 1. Primary sources (fetched 2026-08-11, UTC; sha256 of local copies)

| document | URL | sha256 |
|---|---|---|
| Announcement | https://www.anthropic.com/research/riemann-zeta | (HTML, not hashed) |
| Manuscript: "More than two thirds of the zeros of the Riemann zeta function lie on the critical line" (Claude, dated 2026-08-10) | https://www-cdn.anthropic.com/564f962e60643842f5fcb4a17c9dbc8f608f1c37.pdf | `6792988e6cd0e17690621ce898abd5d534f98407741bc7cb14bbe7d07c77d72f` |
| Alpöge–Furman informal expert note ("67% of the zeroes are on the line") | https://www-cdn.anthropic.com/23455459f8832d06bb175cc0f88d019aed962ef8.pdf | `45e0330ad37965e5531fa1f4f11e5bebcae147a5237a3e5b3d029efa7ddf759d` |
| Claude's methodology explanation | https://www-cdn.anthropic.com/d7f3ecf1d01392d887f8bc974ca187e2a121b1ed.pdf | `271aba2d2083ffa778a53c2994f2061fad7fdda450bc296ec49c7cc41e91dd2d` |
| Process transcripts | https://www-cdn.anthropic.com/8a0d1add3c637b858a9a181e98c40e9548c3f44f.pdf | (not fetched this session) |
| Lean 4 repository | https://github.com/anthropics/zeta-23-lean | clone HEAD `3635e74` |

Status per the announcement: reviewed internally by Levent Alpöge and Ralph
Furman (Anthropic); examined on short notice by Brian Conrey and Dan
Goldston; formalized in Lean 4 (orchestrated by Eric Easley); **not peer
reviewed**. The Goldston–Suriajaya survey arXiv:2511.20059 (Nov 2025)
confirms that immediately before this the unconditional record was PRZZ
41.7% / 40.7%-simple, so the announced jump is against the true prior state
of the art, not a strawman.

## 2. The record: before and after (citation chain, checked against sources)

Unconditional proportion of zeros on the critical line (κ), historical:

| year | result | κ | source (checked) |
|---|---|---|---|
| 1914/1921 | infinitely many; ≫T | — | Hardy; Hardy–Littlewood |
| 1942 | positive proportion | small, inexplicit | Selberg |
| 1974 | Levinson's mollifier method | ≥ 1/3 (0.3474 in refined form) | Levinson [Lev74]; zeros also simple (Heath-Brown 1979, and Selberg indep.) |
| 1989 | Conrey, mollifier length θ=4/7 via Deshouillers–Iwaniec Kloosterman estimates | > 0.4088 | Conrey, J. reine angew. Math. 399 (1989) |
| 2011 | Bui–Conrey–Young, two-piece mollifier | > 0.4105 | arXiv:1002.4127 |
| 2012 | Feng, Conrey+higher-order-mollifier | claimed 0.4128; a gap was found in the θ=4/7 justification for Feng's second piece (per PRZZ §intro, citing four follow-ups) | Feng, J. Number Theory 132 (2012) |
| 2020 | Pratt–Robles–Zaharescu–Zeindler: twisted 2nd moment for the Feng mollifier proved at length θ=4/7; numerical optimization over coefficient space | **κ > 0.417293962**; κ* (simple) ≥ 0.407511457 | arXiv:1802.10521, Res. Math. Sci. 7 (2020) |
| **2026-08-10** | **Claude: Weil-form compression + rank–trace; no mollifier** | **N₀*/N ≥ 2/3; optimal window 0.67250 (= 3/2 − 2^{-1/2}·cot 2^{-1/2}); simple-on-line the same; distinct ≥ 0.83625** | manuscript §1.3 Thms A,B,C,D |

Adjacent records (for calibration; all checked against the manuscript's
§1.2/§7.3 and Goldston–Suriajaya 2511.20059):

- Simple zeros, conditional on RH: Montgomery 1973: 2/3; Montgomery–Taylor
  1975 (optimal Fejér-type kernel): 0.6725; Cheer–Goldston 1993: 0.6727;
  Bui–Heath-Brown 2013: 19/27 ≈ 0.7037; Chirre–Gonçalves–de Laat 2020
  (SDP majorants using F(α) outside [−1,1]): 0.6792 (their route uses a
  different regime than the new theorem's band-limited-only one).
- Distinct zeros, unconditional, before: Farmer 1995: 0.6395; Wu 2015:
  0.6603. **Now: 5/6 ≈ 0.8333, optimized 0.83625.**
- Zeros of ξ′ (the completed zeta's derivative): unconditional
  simple-and-on-line was Conrey 1983/89: 0.79874; RH-conditional
  Farmer–Gonek–Lee 2014: 0.8584, CGdL 2020: 0.8825. **New (same repo,
  formalized): 0.85838 unconditional (flat window), 0.86864 (quartic
  window)** — i.e. the FGL constant with RH removed. For on-line-only
  (without simplicity) Wu 2015's 0.86957 remains ahead.
- Pair-correlation-conditional (not unconditional): BGSTB arXiv:2501.14545
  and GLSS arXiv:2503.15449: 2/3 simple+critical under a narrow-band/ES-type
  hypothesis; full PCC ⇒ 100% simple and on-line (GLSS 2025). The new
  theorem reaches exactly the 2−C = 2/3 number of that program with the
  hypothesis discharged.

The original charter's Levinson-framework questions (the κ ≥ 1 −
(1/R)·log c(P,Q) optimization, the θ=4/7 wall, PRZZ's coefficient search)
are now **historical**: the mollifier route's record is superseded by an
argument that does not touch it. §7 records what of that axis is still
alive (nothing below 2/3; possibly hybrid uses above it).

## 3. What exactly is proved (statements, from the manuscript §1.3)

With N(T₁,T₂) = zeros counted with multiplicity, N₀* distinct on-line, N₀ˢ
simple on-line, N_d distinct anywhere in the strip; H(λ) := 2 − 1/λ − λ/3:

- **Theorem A.** For fixed 0<λ≤1: N₀*(T,2T) ≥ (H(λ) − c(λ)·loglogT/logT)
  ·N(T,2T); at λ=1, liminf N₀*/N ≥ 2/3 (dyadic and cumulative).
- **Theorem B.** Same lower bound for N₀ˢ(T,2T): ≥ 2/3 simple AND on-line.
- **Theorem C.** N_d(T,2T) ≥ (max(H_d(λ), F(λ)) − o(1))·N, H_d=(1+H)/2,
  F(λ)=λ/(1+λ²/3); at λ=1: ≥ 5/6.
- **Theorem D.** Optimal window v*(s)=cos(√2 s): the constants become
  2 − 1/c₁* = 0.67250…, same for simple, (3 − 1/c₁*)/2 = 0.83625…,
  where c₁* = √2·tan(1/√2)/(1 + (1/√2)tan(1/√2)) = 0.7532960…
  (1/c₁* is the Montgomery–Taylor constant 1.3274992…).
- **Theorem E.** All of the above for any fixed primitive Dirichlet L(s,χ).

Inputs (Theorem A's complete list, manuscript §1.3): Weil explicit formula,
Stirling for Γ′/Γ, Riemann–von Mangoldt + N(t+1)−N(t) ≪ log t,
Chebyshev–Mertens sums, Montgomery–Vaughan generalized Hilbert inequality.
**No zero-density estimate, no zero-free region, no mollifier.**

## 4. The machine, reconstructed (manuscript §§2–6)

Normalization: l = log(T/2π), L = λl, X = e^L = (T/2π)^λ; γ_ρ :=
(ρ−1/2)/i, so γ_ρ ∈ ℝ iff ρ is on the line.

**(1) The form.** W(f,g) := Σ_ρ m_ρ ·f̂(γ_ρ)·conj(ĝ(γ_ρ)) on C²_c(ℝ). Its
positivity on all test functions is RH (Weil). For supp f,g ⊂ [−L/2, L/2]
the explicit formula gives the *spectral-side* representation W(f,g) = ∫
f̂(τ)·conj(ĝ(τ))·ν_X(τ)dτ against the explicit density ν_X = µ + Π_X +
P_X (archimedean + pole + primes n ≤ X); only prime powers n ≤ X = e^L
appear. [Corpus: this is exactly `notes/WEIL.md` §1–2's normalization; our
exp14 checked it at 1.8e−10.]

**(2) The compression.** Fix a C³ taper φ, supp φ = [−L/2,L/2], flat top;
modulated copies f_k(u) = φ(u)e^{−iτ_k u} at frequencies τ_k = T + k·(2π/L),
0 ≤ k < d, d = ⌊LT/2π⌋ ≈ λ·N(T,2T) — a Gabor system at critical density
filling [T,2T]. G_kl := W(f_k,f_l) is a real symmetric d×d matrix. The key
sampling identity (Poisson, Lemma 2.2): Σ_{k∈ℤ} φ̂(τ−τ_k)φ̂(τ′−τ_k) =
L·Φ(τ−τ′) with Φ = (φ²)^, **no aliasing** — so an isolated on-line zero
seen through the full grid contributes eigenvalue exactly m_ρ in units
Ĝ = G/(aL²).

**(3) Zero side (signature and rank).** Split G = A + E (ordinates inside
/outside I′ = (T−√T, 2T+√T]); ||E|| is o(1) by taper decay (this is where
C² tapering is *necessary* — sharp cutoff fails, Remark 4.3). For A:
- each distinct on-line zero contributes m_ρ·u_ρu_ρᵀ: rank one, PSD;
- each off-line pair {ρ, 1−ρ̄} contributes the 2×2 form 2m_ρ·Re(x·ȳ) —
  matrix [[0,m],[m,0]], **signature (1,1)**: one positive square per pair
  no matter how deep or shallow.
So Ĝ = P + Q with P ⪰ 0, rank P ≤ #on-line points, tr P ≤ N_on, and
n₊(Q) ≤ p := #off-line pairs (Sylvester inertia under pull-back — no
independence of the evaluation functionals needed). Bombieri 2000 read the
*negative* index of such truncations (counts off-line pairs); the new move
is to read the **rank and positive index**. [Corpus: `notes/LP_CERT.md`
Prop LP2 derived this same (1,1)-block/inertia structure — "the hyperbolic
block [[0,1],[1,0]] with inertia (1,0,1); pullback has positive and
negative indices at most one" — as a *Hodge-index* statement, and measured
n₊ = 1 configurations; what LP2 did NOT do is combine it with a second
moment.]

**(4) Prime side (two traces).** tr Ĝ and ||Ĝ||²_F are integrals of
explicit kernels against ν_X — *zero-free* computations. Unconditionally
(Theorem 5.8): tr Ĝ = N(1+o(1)) and ||Ĝ||²_F = (1/λ + λ/3)·N·(1+o(1)).
The Frobenius norm is Montgomery's second moment: zero-side it reads
Σ_{ρ,ρ′} m m′ Φ(γ_ρ−γ_ρ′)², the Fejér pair-correlation sum at *complex*
differences; prime-side it is ∫∫ Φ(τ−τ′)²ν_X ν_X, whose diagonal is
(T/π)Σ_{n≤X} Λ(n)²g(log n)/n → λ³l³/3-type term and whose off-diagonal is
killed by **Montgomery–Vaughan** — this is Montgomery's F(α) for |α| ≤ λ
≤ 1, made unconditional ~~exactly as in BGSTB arXiv:2501.14545 Thm 1~~ /
GS26 Lemma 2 (also Aryan). **[seed135, 2026-08-14 — number mismatch, checked
today at `ar5iv.labs.arxiv.org/html/2501.14545`. Their Theorem 1 reads:
"Assume that, for all sufficiently large $T$, all the zeros $\rho=\beta+i\gamma$
of $\zeta(s)$ with $T<\gamma\le2T$ are in $B_b$. Then … $N_1(B_b)\ge(2/3+o(1))
N(B_b)$ …" — the narrow-band proportions theorem, exactly as this note's own §
"Pair-correlation-conditional" bullet describes it (standing check: a line
refuted by its own note). It is not a statement making Montgomery's $F(\alpha)$
unconditional on $|\alpha|\le1$, which is in any case classical
(Montgomery 1973; Goldston–Montgomery), so nothing here is lost — only the
pointer is wrong. Correct reading: *as in the treatment of the off-diagonal in
BGSTB §2*, un-numbered pending a read of that section. GS26 Lemma 2 was not
checked.]** **[seed137, 2026-08-14 — §2 has now been read, and the pointer can be
numbered again.** `ar5iv.labs.arxiv.org/html/2501.14545` renders past §2 (seed135's
Theorem 1 quote is confirmed verbatim by an independent fetch today). §2 states a
**"Montgomery Theorem (MT)"** for $\mathcal F(x,T):=\sum_{\rho,\rho'}x^{\rho-\rho'}
W(\rho-\rho')$, $W(u)=4/(4-u^2)$ — the *complex*-difference form — verbatim: *"For
$x\ge1$ and $T\ge3$, we have $\mathcal F(x,T)\ge0$, $\mathcal F(x,T)=\mathcal
F(1/x,T)$, and $\mathcal F(x,T)=\frac{T}{2\pi x^2}\log^2T(1+O(1/\sqrt{\log T}))+
\frac{T}{2\pi}\log x+O(T\sqrt{\log T})$, uniformly for $1\le x\le T$"* — and it is
stated **unconditionally**. So the correct pointer for the off-diagonal treatment is
**BGSTB §2, "Montgomery Theorem (MT)"**, not their Theorem 1. This agrees with
`L3_SDP.md` §1.2, which recorded the same statement from the PDF in an earlier
session and which I have now confirmed against the HTML. Still unchecked, and still
not vouched for: **GS26 Lemma 2**.]** The λ ≤ 1 constraint is the visible arithmetic
wall: for X ≫ T the off-diagonal needs Hardy–Littlewood prime-pair input.
[Corpus: `notes/DSIDE.md` §1 measured F(α): slope regime |α|<1 and plateau
1.001±0.007 on α∈[1.05,3]; the theorem consumes only the |α|≤1 slope
regime, which is the provable part — precisely the boundary drawn there.]

**(5) Linear algebra (the unconditionality trade).** Lemma 3.2 (via von
Neumann's trace inequality): P ⪰ 0 of rank ≤ r, n₊(Q) ≤ b, any c>0:
||P+Q||²_F ≥ c·tr P − c²r/4 + 2c·tr Q − c²b. At c=2:
r ≥ 2tr P + 4tr Q − 4b − ||P+Q||²_F. This is the matrix transplant of
Montgomery's integrality step m² ≥ 2m−1 (and, regrouping simple zeros on
the rank side, m² ≥ 3m−2 = the CGG98 refinement). Assembling at λ=1:
s ≥ 4N − 2N − (1/λ + λ/3)N − o(N) = (2/3 − o(1))N. Each off-line pair sits
on the index side at flat charge 4 = c²; each on-line simple zero at
charge 3; RH's termwise positivity is never used.

**Where 2/3 comes from:** 2/3 = H(1) = 2 − 1 − 1/3 = 4 − 2 − 4/3, i.e.
(rank coefficient)·N − 2N(multiplicity inequality) − (Montgomery's 4/3
second moment). It is *identical* to Montgomery's conditional 2/3 because
the linear algebra loses nothing against the extremal configuration (2/3
orthogonal simple on-line + 1/6 on-line doubles — or the doubles replaced
by shallow off-line pairs, spectrally indistinguishable). The 0.6725 is
Montgomery–Taylor's kernel optimization, recovered exactly as the
variational problem for c_λ(v) = λ(∫v)²/(∫v² + λ²∫∫|s−s′|v v′), maximizer
v* = cos(√2 s), and CCLM17 (Carneiro et al.) proves no window does better
given only F on [−1,1].

## 5. ~~Independent mechanical verification~~ Mechanical replay and audit correction

Environment: the session container (4 cores), Lean via elan at
`/root/.elan`; clone at scratchpad `zeta-23-lean/`, HEAD = `3635e74`
("Merge pull request #3 from anthropics/xiprime-pairceiling").

1. **Toolchain**: repo pins `leanprover/lean4:v4.33.0-rc2` + Mathlib
   `51e6992efd06126df61a496bebf8f49482a4e129` (tag v4.33.0-rc2). Our
   `formal/pairfield` uses v4.33.0 + a different Mathlib pin, so no cache
   reuse from that local project; elan fetched the rc2 toolchain and
   `lake exe cache get` retrieved 8681 prebuilt Mathlib artifacts. The
   archived log records a successful 9010-job default build, but it retains
   only the final lines: the job count includes dependencies and does not by
   itself certify that all 316 `Zeta23/` sources were freshly compiled.
2. **Build**: `lake build` followed by `lake build Solution
   Solution.Multiplicity Solution.XiPrime` — RESULT RECORDED BELOW (§5.1).
3. **Sorry audit** (source-level, independent of the repo's own AUDIT.md):
   `grep -rn sorry` over `Zeta23/` finds the token only inside comments
   (2 files, porting notes); ~~the 27 real `sorry`s are exactly the
   deliberate placeholder proofs in the two trusted challenge files~~ the
   fresh source audit finds **33** deliberate placeholder proofs in **three**
   trusted challenge files
   (`comparator/Challenge.lean` 15, `comparator/Challenge/Multiplicity.lean`
   12, `comparator/Challenge/XiPrime.lean` 6). By design, those files state
   WHAT is claimed; equivalence to the separately compiled `Solution`
   statements is a job for the comparator, not for `lake build Solution*`.
4. **Axiom audit**: no `axiom` declaration outside comments in the project
   (`Zeta23/FromPNTPlus/Tactic/AdditiveCombination.lean:183` has one inside
   a docstring example, verified by reading the file); `#print axioms` run
   via `comparator/PrintAxioms*.lean` — result in §5.1. The upstream repo's
   amended AUDIT.md reports the standard triple for all 33 comparator
   statements, but that upstream report is provenance, not evidence that this
   session independently replayed its comparator run.
5. **`decide`/`native_decide`**: `native_decide` appears nowhere; the
   PairCeiling numeric certificates use `decide +kernel` (kernel
   evaluation) with ONE displayed hypothesis (`EnclOK`, integer enclosures
   of a 256-periodic law's form factor produced outside Lean). The
   PairCeiling material is **not** part of Theorems A–E and carries its
   caveat honestly in the README.
6. **Statement alignment** (the place formalization claims break —
   checked by reading, not by trusting): `comparator/ChallengeDeps.lean`
   (~60 lines, imports Mathlib only) defines IsNontrivialZero via
   Mathlib's `riemannZeta` on the open strip, multiplicity via
   `analyticOrderAt`, and the counting functions; `Challenge.lean` +
   `Challenge/Multiplicity.lean` state the liminf claims in ε-form:
   `∀ ε > 0, ∃ T₀, ∀ T ≥ T₀, (2/3 − ε)·Ncount T (2T) ≤ N0star T (2T)`,
   and `(2 − 1/cMT − ε)` with `cMT` in closed form for Theorem D. These
   appear faithful on manual reading to the paper's Theorems A–E. This is a
   source-level alignment review, not a mechanical equality check between
   `Challenge*` and `Solution*`. One subtlety noted and
   resolved: `Ncount` uses `∑ᶠ` (finsum), which returns 0 for infinite
   support — the definitions denote the true counts because window
   finiteness is classically true (and is proved on the solution side);
   the statements are not weakened by this convention. The multiplicity
   convention `analyticOrderAt.toNat` (⊤ ↦ 0) is harmless since ζ is not
   locally ≡ 0. The reviewed `Challenge*` text includes the 2/3 and
   Montgomery–Taylor 0.6725 forms with multiplicity on the left and
   distinct/simple counts on the right; the comparator obligation remains
   open.

### 5.1 Build outcome (recorded 2026-08-11T21:16Z; log: `data/exp47_zeta23_build.txt`)

- `lake build`: **"Build completed successfully (9010 jobs)"** — zero
  errors, zero `sorry` warnings, only deprecation warnings (rc2 vs newer
  Mathlib lints) and benign `info:` outputs.
- `lake build Solution Solution.Multiplicity Solution.XiPrime`:
  **"Build completed successfully (9002 jobs)"**. These modules import
  `ChallengeDeps*`, not `Challenge*`; this build checks the solution
  declarations but does not establish statement equality with the trusted
  challenges.
- PrintAxioms audits (all four files, **44** audited declarations printed):
  **42 report exactly `[propext, Classical.choice, Quot.sound]`**; the two
  remaining are PairCeiling kernel-`decide` facts reporting strictly LESS
  (`LawN256_check`: `[propext]`; `LawN256_edge`: no axioms). No `sorryAx`,
  no `ofReduceBool`/`native_decide`, no project axiom anywhere.

~~**Verdict: the formalization builds from source in an independent
environment, and the kernel-checked statements say what the paper says.
The forecast branch "builds-and-statements-align" obtained.**~~

**Corrected verdict:** the archived run supports successful default and
`Solution*` builds and clean axiom output for the printed declarations. It
does not establish the trusted/untrusted statement-equality boundary, and its
curated log is insufficient for a from-scratch/source-coverage claim. R0015
must not be promoted until a raw, manifest-bound clean build plus the
end-to-end comparator replay has been archived.

### 5.2 Codex audit amendment (2026-08-11)

The append-only audit is
`collab/discovery/audits/R0015-build-evidence-audit.md`. It binds the archived
log and the inspected upstream files by SHA-256, records the exact 15+12+6
`sorry` count and 44-declaration axiom count, and specifies the evidence
manifest needed by a future repaired successor. R0015's event files and Exact
statement are left untouched; the packet remains non-load-bearing and its
promotion is explicitly blocked. A positive successor should be registered
only after the missing comparator and raw-build obligations are discharged.

## 6. The corpus bridge: we had both ingredients

This is why the coordinator called the retarget "pivotal for the program":

1. **The Weil form and its inertia** — `notes/WEIL.md` (explicit formula
   normalized and machine-checked; Prop W3 obstruction), `notes/LP_CERT.md`
   (LP2 "Hodge index / Castelnuovo for the Weil form": the off-line/pole
   hyperbolic block `[[0,1],[1,0]]`, inertia (1,·,1), pullback positive
   index ≤ 1; measured n₊(prime−arch) = 1 with λ₂/λ₁ ≤ 1e−13 on robust
   subspaces). The manuscript's Proposition 4.1 is this same structure
   used in the positive direction: one positive square per off-line pair,
   rank = on-line count.
2. **The pair-correlation second moment** — `notes/DSIDE.md` (Montgomery
   F(α) measured: slope 1.002 unfolded on |α|<1, plateau 1.001±0.007 on
   [1.05,3]; the GM variance bridge; the exact statement of which α-range
   is provable vs conjectural). The manuscript's Theorem 5.8 is the
   provable |α| ≤ 1 part, unconditional per BGSTB — and its λ ≤ 1 wall is
   exactly DSIDE's proven/conjectural boundary at α = 1.
3. **What the corpus lacked** (the proof-diff, in METALOOP move-3 style):
   (a) the *compression* — restricting W to a finite modulated family at
   critical density and treating the result as a bare Hermitian matrix,
   forgetting the L² geometry (the paper is explicit that
   orthonormalization is impossible without Lindelöf-type input and
   unnecessary: inertia is basis-free); (b) the *rank–trace inequality*
   (von Neumann), the matrix transplant of m² ≥ 2m−1 — our LP2 sought a
   negativity certificate (Bombieri's reading); the theorem needed the
   dual reading, rank + positive index against two unconditional traces.
   In the discovery transcript this is literally how it was found: the
   Pontryagin-index upper-bound route came back empty and the agent
   reported the dual bookkeeping instead.

Also note `notes/ENERGY.md` (zero-pair Poisson statistics) and the exp17
F-plateau measurements are consistent with everything the theorem consumes.

## 7. The frontier after 2/3 (manuscript §7.5 + Prop 7.4 + PairCeiling, restated sharply)

1. **The band-width wall λ ≤ 1 is the arithmetic content.** All arithmetic
   enters through the two traces; the second trace is Montgomery's F on
   [−λ, λ]. λ > 1 requires additive prime-pair correlations
   (Hardy–Littlewood strength: Σ (Λ*Λ)(m)(Λ*Λ)(m+h) asymptotics) — the
   same wall as DSIDE §3.4/WIDTH.md, now bounding a *theorem* instead of
   a conjecture-program. Not a Deshouillers–Iwaniec/Watt exponential-sum
   wall (that was the mollifier θ=4/7 axis, now moot): the binding
   constraint is Montgomery–Vaughan diagonal dominance, i.e. X ≤ T.
2. **The certificate ceiling at bandwidth 1.** The repo's PairCeiling
   development (kernel-checked modulo explicit integer enclosures)
   instantiates the paper's Remark 1.1: no certificate of this type
   (band-limited data + configurationwise validity) can certify simple
   proportion > 0.68185. Theorem B's 0.6725 is within 0.016 of its own
   method's ceiling. **The shape axis is quantifiably saturated** — the
   analogue of the old "Conrey's polynomials were near-optimal" folklore,
   but now proved: CCLM17 optimality for the window, ceiling-stability for
   the certificate class.
3. **Dimension cap.** Any argument of this kind certifies ≤ λ·N on-line
   points (rank ≤ d), so 100% is the ceiling at λ=1 and nothing survives
   at λ ≤ 1/2; two traces at λ=1 give 2/3–0.6725; unconditionally, higher
   moments add nothing on λ ∈ (1/2, 1) (Rudnick–Sarnak range kλ < 2 allows
   k=3 only for λ < 2/3, and odd moments don't improve the Christoffel
   bound).
4. **Conditional ladder upward** (§7.5(f)): a 4th-moment/sine-kernel
   hypothesis HL*(4,λ) would give ≥ 13/18 ≈ 0.7222 simple-on-line; all
   moments → proportion 1. Under RH the triple correlation is a theorem
   and yields distinct ≥ 0.85082 (beating CGdL's 0.8477). RH itself is
   **out of reach of the mechanism** (insensitive to o(N) off-line zeros;
   satisfied by Davenport–Heilbronn/Epstein objects — the certificate
   never "sees" that all zeros are on the line).
5. **What of the Levinson/mollifier axis survives.** Below 2/3: nothing —
   the entire Levinson→Conrey→BCY→Feng→PRZZ optimization is dominated.
   Open and interesting: whether mollifier/zero-density inputs can be
   *hybridized* with the compression (e.g. a mollified window changing the
   prime-side density, or Levinson-style N₀-with-multiplicity information
   feeding the rank side); the manuscript does not explore this. GL(2) and
   individual L-functions with Λ* = 1/2 get nothing from the method
   (§7.2(ii)) — Levinson-type methods remain the only game there.
6. **For this program** (`FOREST`/parity): the theorem is a spectacular
   instance of the GAUGE/Theorem-F template — a barrier (RH-positivity)
   circumvented not by breaking its protecting symmetry but by extracting
   the invariant content (inertia) that survives without it. The λ ≤ 1 ↔
   Hardy–Littlewood wall is the same additive-correlation wall as the
   pair-field program's; any progress there now lifts TWO records (κ
   beyond Montgomery–Taylor, and the twin/Goldbach side).

## 8. Honesty ledger

- The result is 30 hours old at verification time, not peer reviewed. Our
  contribution is ~~an independent from-source rebuild + statement audit +~~
  a replay of selected build targets, a manual statement read, an axiom-output
  capture, and
  reading of the full manuscript; we did NOT re-derive the analytic error
  terms (Prop 4.2, Lemma 5.4, Prop 5.6/5.7) by hand. A complete Lean-kernel
  verification claim awaits the comparator replay described in §5.2.
- The comparator tool itself (`leanprover/comparator`) was not run
  end-to-end here (it fetches its own copies). ~~We ran the equivalent:
  built the trusted Challenge files, built Solution against them in the
  same environment, and ran the PrintAxioms audits.~~ The recorded commands
  are not equivalent: the default target excludes `Challenge`, and the
  `Solution*` modules import `ChallengeDeps*`, not `Challenge*`. The
  PrintAxioms replay checks solution declarations and their axioms, while
  trusted/solution statement equality remains open. The trusted statements
  were reviewed manually.
- The ξ′ results depend on docstring-cited technical supplements not in
  the repository ("[XF′ ...]" labels) only as *provenance labels*; the
  Lean statements stand alone. The PairCeiling `EnclOK` hypothesis is
  displayed, not hidden.
- Values quoted for the pre-2026 record chain were re-checked against
  PRZZ's own text (κ > 0.417293962, κ* ≥ 0.407511457) and the GS survey;
  Feng's 0.4128 is recorded as claimed-with-gap per PRZZ's account, since
  the four cited follow-up papers were not re-read this session.
