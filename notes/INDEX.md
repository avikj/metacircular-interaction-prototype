> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# Index: the catchup branch's corpus and its interfaces (three-collaborator state)

*Merged-tree note (integration branch, 2026-08-11): this document was the
catchup branch's (`claude/repo-catchup-math-tgs5hx`) self-map, written before
the three-branch merge. It is kept as a historical map; the live corpus map is
`collab/STATE.md` and the exp-number authority is `notes/EXP_LEDGER.md`. Bare
exp numbers in this file refer to the **cu** series.*

Branch `claude/repo-catchup-math-tgs5hx`, sessions of 2026-08-11. Sibling
branch: `claude/prime-pair-field-research-18tq7b` (rigidity certificate
tower, gauge no-go, screw extraction, LENS_CIRCUIT / LENS_REGULARITY — the
latter builds directly on this branch's `BLOCKS.md`).

## Results on this branch, in dependency order

| # | result | note | code | status |
|---|---|---|---|---|
| E2 | block spectral support: BC block smooth, **mixed = single-zero layer**, [♭♭] = pair layer; closure $2\times10^{-13}$ | `BLOCKS.md` §1 | exp11 | corrects `ADELIC.md` §3 |
| D‴ | weight law, full form: $W=\sqrt{2\pi}s^{-5/2}e^{-i(sH(p)+5\pi/4)}$ — modulus knows only the sum, **phase = splitting entropy** | `BLOCKS.md` §2 | exp12 | refutes naive Krein positivity (measure maximally chirped) |
| D″ | variance = weighted additive energy, closed with explicit constants: $E(\eta)=C\eta$, $C/D=1.44$; $V/D\to0.9998$; Parseval chain closes 4 ways | `BLOCKS.md` §3, `APPENDIX_D.md` | exp13 | only the unconditional near-diagonal count (TTY $N^*$) remains |
| G | **Fresnel coupling**: $\arg c_f\supset(\gamma-\gamma')^2/2f$ — the difference spectrum lives in sum-line phases; given the line positions, gaps read off Goldbach phases to 0.1% (blind: ~10–30%, `CROSSREVIEW_WAVE2.md`) | `FRESNEL.md` | exp14 | fills the dictionary off-diagonal (Hermitian statistics stay blind) |
| — | zone problem resolved: variance zone-uniform (modulus blindness); coherence = **Cornu spirals**, fraction $\sim f^{-1/2}$ | `FRESNEL.md` §4 | exp17 | corrects this branch's own §4 conjecture |
| H | **Liouville–Goldbach trace formula**: $\lambda$-field = pure spectrum, all layers at $X^2$, weights $\zeta(2\rho)/\zeta'(\rho)$; corr 0.9999–1.0000 | `LIOUVILLE.md` | exp15 | protection/exposure duality with sibling `GAUGE.md` |
| H′ | **Möbius = the pure pair field**: no pole ⟹ pair layer only; corr 0.9999/0.9999 | `FAMILY.md` §1 | exp16 | terminal object of the family |
| — | family classification: layer count = pole count + 1; purity axis $d\to\Lambda\to\lambda\to\mu$; simplex-Chowla corollaries $-0.0659X^2$ ($\lambda$), $-0.1520X^2$ ($\mu$) | `FAMILY.md` §2 | — | |
| — | cross field $\Lambda\times\mu$: compositional layers (corr 1.0000 twice); **$s=0$ layer discovered** — data measures $\zeta(0)=-\tfrac12$; off-diag $=-\tfrac34X^2$ | `FAMILY.md` §2 | exp18 | layer algebra = all Mellin singularities, composed pairwise |
| — | Fresnel reading is dressing-universal: gaps from $\lambda$ data, self-calibrated ($w_1,w_2$ to 1%); crowding limit quantified | `FAMILY.md` §2 law 3 | exp19 | |
| — | **abelian tower**: mod-3 twisted Goldbach displays the $L(s,\chi_3)$ zero sum-spectrum (self-computed zeros); corr 0.9994, unit weights | `FAMILY.md` §2.1 | exp20 | each character reads its own jewel string |
| — | finite-place fingerprints: three visibility classes; **Galois lever** acts by $\chi(2)=-1$ on the character sector | `FAMILY.md` §2.2, `ADELIC.md` §1 | exp21 | answers ADELIC's Galois remark |
| D‴-k | **k-body ladder**: $W_k=(2\pi)^{(k-1)/2}s^{-(k+3)/2}e^{-i(sH_k+(k+3)\pi/4)}$, verified $k=2,3,4$; diffraction hierarchy; triple-layer inaccessibility quantified | `FAMILY.md` §2.3 | exp22 | closes sibling `TERNARY.md`'s open triple layer |

Plus: erratum to `REPORT.md` §8.1 (reciprocal factors *remove* swap freedom);
naming: this branch's block theorem is **E2** (ceding "Theorem F" to the
sibling's gauge no-go); exp numbering overlaps the sibling branch (both have
exp11–20, filenames differ — namespace by filename on merge).

## The through-line

One mechanism generated everything after exp13: **read the phases.** The
entropy phase law (D‴) was found by asking what the Krein test would see;
its Taylor expansion (G) filled the dictionary's off-diagonal; its Stirling
correction made gap-reading quantitative (exp14/19); its chirp made the
sum spectrum diffract (exp17); and pointing the same double-explicit-formula
at the "unrelated" parity sector produced the trace formulas H, H′, the
family classification, the $s=0$ layer, and the abelian tower. The
standing instruction of the sibling's `TENSIONS.md` — *treat "these two
things are unrelated" as a bookkeeping failure* — held every single time it
was tested.

## Open interfaces (best next joins)

1. `SCREW.md` × `BLOCKS.md` §1 — **corrected by audit
   (`CROSSREVIEW_EXP22_25.md`):** the *fluctuation* of the MS screw kernel
   lives in the mixed block (corr 1.0000, ratio 0.9992, band-passed), but
   the exact block identity and "$c_2$ from the BC block" were wrong —
   block constants are $Q$-artifacts; true $c_2=-2.2803$ (matches sibling).
   Open: a canonical smooth subtraction to upgrade the fluctuation
   identification to an exact statement.
2. `LENS_REGULARITY.md` (sibling) × exp11: their cut-norm theorems use this
   branch's measured decomposition; the $Q$-orthogonality table (exp11) is
   the numerical face of their spectral-gap propositions.
3. ~~family × `LENS_CIRCUIT`~~ **DONE (exp24 / `FAMILY.md` §2.4):** best
   sieve-circuit advantage measured for all four dressings over 11 moduli —
   $\Lambda$: $1-\varphi(L)/L$ exactly; $\Lambda\chi_3$: $0.5000$ iff $3\mid L$
   (one literal deep — literals are finer than Ramanujan probes);
   $\lambda,\mu$: noise floor everywhere — the fixed points of SIEVE_d.
4. Merge plan: `GAUGE.md` + `LIOUVILLE.md` are one chapter
   (protection/exposure); `SCREW.md` + `BLOCKS.md` §2 + `FRESNEL.md` are one
   chapter (amplitude chirp / phase reading / Hermitian positivity);
   `FAMILY.md` + their monograph's solvable-model sections are one chapter.
