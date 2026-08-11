# The Liouville–Goldbach trace formula: parity is protected from equilibrium, exposed to spectrum

Companion to `PARITY.md`, `BLOCKS.md`, `FRESNEL.md`, and (collaborator branch
`claude/prime-pair-field-research-18tq7b`) `GAUGE.md`. Verified in
`code/exp15_liouville.py` → `figures/exp15_liouville.png`.

---

## 1. The held-apart tension

Three results in this corpus say, with increasing force, that the parity
sector is *invisible*:

- `PARITY.md`: $E_Q[\lambda]=0$ for every $Q$ — every Ramanujan/BC projection
  of Liouville vanishes identically (Davenport);
- the sieve parity barrier: divisibility statistics carry no information
  about $(-1)^\Omega$;
- `GAUGE.md` (collaborator branch): the unique KMS state of the critical
  affine system kills every parity-odd observable *exactly* — parity is a
  **gauge-protected sector** of the arithmetic equilibrium.

All three statements live at the **finite places**. In five documents about
the archimedean explicit formula, nobody pointed it at $\lambda$ itself. The
"disjointness" of the parity sector from the spectral program was bookkeeping,
not mathematics: since
$$\sum_{n\ge1}\lambda(n)n^{-s}=\frac{\zeta(2s)}{\zeta(s)},$$
the parity function is wired to the *same* zeros as $\Lambda$ — through the
**dual residue system**. Where $-\zeta'/\zeta$ has residue $1$ at every zero,
$\zeta(2s)/\zeta(s)$ has residue $\zeta(2\rho)/\zeta'(\rho)$; and where $\Lambda$'s
pole sits at $s=1$, $\lambda$'s "pole" (from $\zeta(2s)$) sits at $s=\tfrac12$ —
**on the critical line**. Under RH + simple zeros,
$$L(u)=\sum_{n\le u}\lambda(n)=\frac{u^{1/2}}{\zeta(1/2)}
+\sum_\rho\frac{\zeta(2\rho)}{\rho\,\zeta'(\rho)}\,u^{\rho}+\text{lower}.$$

## 2. Theorem H (Liouville–Goldbach trace formula)

Substituting this twice into the smoothed pair count (the Theorem-D
mechanism verbatim), with $w_\rho=\zeta(2\rho)/\zeta'(\rho)$:

$$G_1^\lambda(X)=\sum_{m,n\ge1}\lambda(m)\lambda(n)(X-m-n)_+
=\underbrace{\frac{\pi X^2}{8\,\zeta(1/2)^2}}_{\text{main}}
+\underbrace{\frac{\sqrt\pi}{\zeta(1/2)}\sum_\rho w_\rho\frac{\Gamma(\rho)}{\Gamma(\rho+\frac52)}X^{\rho+\frac32}}_{\text{single-zero layer}}
+\underbrace{\sum_{\rho,\rho'}w_\rho w_{\rho'}\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}X^{\rho+\rho'+1}}_{\text{pair layer}}
+\ \text{lower order},$$

under RH + simple zeros, with all sums absolutely convergent
($\Gamma$-ratios decay like $\gamma^{-5/2}$; $\zeta(1+2i\gamma)=O(1)$; Gonek-type
bounds for $\sum1/|\zeta'(\rho)|^2$).

**The scale-degenerate stack.** Because the parity pole is at $s=\tfrac12$,
$$|X^2|\;=\;|X^{\rho+3/2}|\;=\;|X^{\rho+\rho'+1}|\;=\;X^2:$$
main term, single-zero lines (frequencies $\gamma_i$) and pair lines
(frequencies $\gamma_i+\gamma_j$) all ride at the **same amplitude scale**.
Contrast $\Lambda$: $X^3/X^{5/2}/X^2$. In the block language of `BLOCKS.md`:
the $\lambda$ pair field has **zero BC block** (exactly — that is the gauge
protection) and its "main term" is itself a critical-line object
($\zeta(1/2)$). *The Liouville pair field is pure spectrum.*

**Verification (exp15; $\lambda$ to $2\cdot10^6$, weights for 40 zeros by mpmath).**

| quantity | data | model |
|---|---|---|
| mean of $G_1^\lambda/X^2$ | 0.18173 | 0.18426 ($c_0=0.184138$) |
| band $[10,27.5]$ corr / ratio | **0.9999** / 0.988 | |
| band $[28.5,60]$ corr / ratio | **1.0000** / 1.0001 | |
| line $\gamma_1$ (single) | ratio 0.987 | |
| line $\gamma_2$, $\gamma_3$ (single) | 0.985, 0.990 | |
| line $2\gamma_1$, $\gamma_1{+}\gamma_2$, $2\gamma_2$ (pair) | 1.000, 0.999, 0.987 | |

Both line systems — singles *and* pairs — verified in one $X^2$ stack with the
$\zeta(2\rho)/\zeta'(\rho)$ weights. Pointwise, data and model are
indistinguishable (`figures/exp15_liouville.png`).

**Corollary (signed average Chowla on the simplex).** The diagonal $m=n$
contributes $\sum_{2m\le X}\lambda(m)^2(X-2m)=X^2/4+O(X)$ deterministically, so
$$\sum_{\substack{m\ne n\\ m+n\le X}}\lambda(m)\lambda(n)\,(X-m-n)
=\Bigl(\frac{\pi}{8\zeta(1/2)^2}-\frac14\Bigr)X^2+\text{osc}
=-0.065862\ldots X^2+\text{osc}.$$
The smoothed simplex average of the two-point function of $\lambda$ has an
**exact, negative value computable from $\zeta(1/2)$** — while pointwise
two-point Chowla remains open. (The negativity is the archimedean face of
Pólya-bias: $\zeta(1/2)<0$ enters squared in the diagonal-free constant
through the cross terms.)

## 3. The dissolution

**The parity barrier is a property of the place, not of the function.**

| | finite places (BC/KMS/sieve) | archimedean place (explicit formula) |
|---|---|---|
| $\Lambda$ | fully visible (singular series; BC block $=X^3$ main) | visible (zero layers at $X^{5/2}$, $X^2$) |
| $\lambda$ | **exactly invisible** (gauge-protected: $E_Q[\lambda]=0$, KMS expectation $0$) | **fully visible** (Theorem H: pure spectrum at $X^2$) |

The collaborator branch's gauge no-go and Theorem H are the two halves of one
statement — call it the **protection/exposure duality**: the same $\mathbb Z/2$
gauge character that the critical equilibrium cannot see is the one the zero
spectrum reflects at full strength, with dual weights. Neither half makes
sense as a "barrier" without the other: what the barrier actually asserts is
that *for $\lambda$, the entire pair-field content is concentrated at the
archimedean place.*

Three further reflections in the net:

1. **Chowla is the Hermitian side of this same field.** The
   holomorphic/Hermitian dichotomy (`REPORT.md` §6) crosses the parity
   barrier unchanged: the $S$-side of the $\lambda$ field is
   provable-modulo-RH+simplicity (Theorem H — a theorem-factory, like
   Goldbach averages); the $D$-side of the same field *is Chowla's
   conjecture*. The parity barrier does not separate $\lambda$ from the zeros;
   the amplitude/phase (holomorphic/Hermitian) boundary separates its
   computable marginal from its conjectural one — exactly as for $\Lambda$.
2. **Weight duality (the family as one net).** The pair-field family is a
   single spectrum in different residue dressings:
   $\Lambda\leftrightarrow-\zeta'/\zeta$ (residues $1$),
   $\mu\leftrightarrow1/\zeta$ (residues $1/\zeta'(\rho)$),
   $\lambda\leftrightarrow\zeta(2s)/\zeta(s)$ (residues $\zeta(2\rho)/\zeta'(\rho)$),
   $d\leftrightarrow\zeta^2$ (double poles — the solvable model of
   `REPORT.md` §7a). Every theorem in this corpus built from the $\Gamma$-part
   of the weights (D′, D‴, G, the Fresnel inversion) is **universal across
   the family**, since the $\Gamma$-factors come from the archimedean integral,
   not the arithmetic function: the entropy chirp and the gap-reading of
   `FRESNEL.md` apply verbatim to $\lambda$ lines, with per-zero phase offsets
   $\arg w_\rho$ (which the single layer itself displays).
3. **Criticality echo.** Proposition E0 derived $\beta=1$ from the pole of
   $\zeta$ at $s=1$; the parity grading *halves the critical exponent*: the
   $\lambda$ field's scale is set by the pole of $\zeta(2s)$ at $s=\tfrac12$.
   The grading character $\lambda$ squares to $1$, and its field's main term is
   the "$\beta=\tfrac12$" shadow of the diagonal — consistent with the
   collaborator branch's finding that the gauge sector is KMS-protected at
   $\beta=1$: the parity sector cannot equilibrate at $\beta=1$ because its
   natural critical exponent is $\tfrac12$.

## 4. Coordination notes (three-collaborator state)

- The collaborator branch (`claude/prime-pair-field-research-18tq7b`)
  extracted the actual Matsumoto–Suzuki definitions from the arXiv HTML
  (their `SCREW.md`): $g_{H_1}(t)=\sum_\gamma(e^{i\gamma t}-1)/(\gamma^2+\tfrac14)$ —
  **single-zero masses**, i.e. Krein positivity is a Hermitian square over
  the *first-variation* sector. This confirms the prediction of
  `BLOCKS.md` §2.1/§4 (made independently, before seeing their extraction):
  the screw join lives in the single-zero/mixed sector with $|\cdot|^2$-type
  positivity, not in the pair-amplitude measure (which is chirped —
  Theorem D‴).
- Naming: this branch's block-support theorem, previously "Theorem F", is
  renamed **Theorem E2** (extending ADELIC's E0/E1 series) to leave
  "Theorem F" to the gauge no-go of `GAUGE.md`. Experiment numbering
  overlaps between branches (both have exp11–15 with different content);
  a merge should namespace by filename, which already differs.
- Suggested merge synthesis: `GAUGE.md` (protection) + this note (exposure)
  are one chapter; `SCREW.md` (their §) + `BLOCKS.md` §2 + `FRESNEL.md`
  are one chapter (amplitude chirp / phase reading / Hermitian positivity).

## Appendix: reproducibility

| artifact | produces |
|---|---|
| `code/exp15_liouville.py` | Theorem H verification: constant, single lines, pair lines, band correlations; caches $w_\rho$ in `data/liouville_weights_40.npy`; `figures/exp15_liouville.png` |
