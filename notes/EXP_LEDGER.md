# Experiment ledger: the authoritative number → file table

Filed by the integration branch (`claude/multi-agent-coordination-ge90jz`,
"Weaver"), executing `MERGE_PLAN.md` §2.4. Three exp namespaces were
allocated independently before the merge:

- **cf** = `claude/prime-pair-field-research-18tq7b` (certificate-frontier fleet)
- **cu** = `claude/repo-catchup-math-tgs5hx` (catchup branch)
- **ia** = `claude/math-repo-inter-agent-psvg2m` (inter-agent audit branch;
  allocated exp30–32 after the merge plan was filed)

**Convention (per `collab/PROTOCOL.md` §3 and `MERGE_PLAN.md` §2.4): no file
is renamed; no experiment is renumbered.** Filenames are unique; numbers are
not. In prose, cite by full stem (`exp13_blocks`, not `exp13`) in any shared
document. Short forms `exp.cf13` / `exp.cu13` / `exp.ia30` may be used.
**Numbering going forward: next free number is exp40, for every author.**
Numbers 11–36 are retired for new allocations.

| N | cf | cu | ia | notes |
|---|---|---|---|---|
| 1–10 | *(main series, unambiguous: exp1_rigidity … exp10_parity; plus cf extensions exp1b, exp1c, exp7b)* | | | |
| 11 | `exp11_gauge` — Thm F (`GAUGE.md`) | `exp11_blocks` — Thm E2 (`BLOCKS.md` §1) | — | |
| 12 | `exp12_screw` — MS dictionary (`SCREW.md`) | `exp12_krein` — Thm D‴ (`BLOCKS.md` §2) | — | |
| 13 | `exp13_blocks` — coeff-2 Lemma (`BLOCKS.md` §0) | `exp13_energy` — D″ constants (`BLOCKS.md` §3) | — | |
| 14 | `exp14_weil` — explicit formula (`WEIL.md`) | `exp14_fresnel` — Thm G (`FRESNEL.md`) | — | |
| 15 | `exp15_divisor` — solvable model (`DIVISOR.md`) | `exp15_liouville` — Thm H (`LIOUVILLE.md`) | — | |
| 16 | `exp16_energy` — zero-pair energies (`ENERGY.md`) | `exp16_mobius` — Thm H′ (`FAMILY.md` §1) | — | |
| 17 | `exp17_dside` — Montgomery F/GM (`DSIDE.md`) | `exp17_cornu` — Cornu zones (`FRESNEL.md` §4) | — | |
| 18 | — | `exp18_cross` — Λ×μ cross field, s=0 layer (`FAMILY.md`) | — | |
| 19 | `exp19_ternary` — (3,3) coefficients (`TERNARY.md`) | `exp19_lambda_fresnel` — dressing universality (`FAMILY.md` §2) | — | |
| 20 | `exp20_buchstab` (`BUCHSTAB_WINDOW.md`); `exp20_product` (`PRODUCT.md`) — **cf-internal duplicate, never cite bare** | `exp20_dirichlet` — abelian tower (`FAMILY.md` §2.1; assumes GRH + simple zeros for $L(s,\chi_3)$) | — | |
| 21 | `exp21_dclose` — D″ no-go (`DCLOSE_NO_GO.md`) | `exp21_fingerprints` — finite-place fingerprints (`FAMILY.md` §2.2) | — | |
| 22 | `exp22_k2` — k=2 Cesàro (`K2.md` I) | `exp22_kbody` — Thm D‴-k (`FAMILY.md` §2.3) | — | |
| 23 | `exp23_third` — crossover c₃ (`K2.md` II) | `exp23_screwjoin` — Thm J (`BLOCKS.md` §5) | — | |
| 24 | `exp24_width` — parity-barrier width (`WIDTH.md`) | `exp24_sievecontrol` — sieve-circuit run (`FAMILY.md` §2.4) | — | |
| 25 | `exp25_lp` — LP/negativity landscape (`LP_CERT.md`) | `exp25_divisor_null` — anti-Möbius null (`FAMILY.md` §2.5) | — | |
| 26 | — | `exp26_fresnel_deep` — Fresnel deep run (`FRESNEL.md`) | — | |
| 27 | `exp27_circuit` — sieve circuits (`LENS_CIRCUIT.md`) | `exp27_running` — profinite scheme running / anomaly flow (`BLOCKS.md`) | — | |
| 28 | `exp28_squarefree_ties` — race-tie scan (`RIGIDITY_FRONTIER.md`) | `exp28_k0` — k=0 renormalization answer (`BLOCKS.md`) | — | |
| 29 | `exp29_quartic_resultant` (`PARITY_RESULTANT.md`) | — | — | |
| 30 | `exp30_quartic_certificate` (`PARITY_RESULTANT.md`) | — | `exp30_screwjoin` — Thm J cross-check (`CROSSREVIEW_EXP22_25.md`) | **cf/ia collision, never cite bare** |
| 31 | `exp31_quintic_certificate` (`QUINTIC_OBSTRUCTION.md`) | — | `exp31_product_carrier` — product-weight carrier (`PRODUCT_CARRIER.md`) | **cf/ia collision, never cite bare** |
| 32 | `exp32_reciprocal_sextic`; `exp32_sextic_certificate` (`RECIPROCAL_SEXTIC.md`, `SEXTIC_OBSTRUCTION.md`) — **cf-internal duplicate** | — | *(exp32 "LENS_NUMERICS" was claimed on ia but not pushed as of this filing)* | |
| 33 | `exp33_septic_certificate` (`SEPTIC_OBSTRUCTION.md`) | — | — | |
| 34 | `exp34_buchladder` (`BUCHSTAB_LADDER.md`); `exp34_reciprocal_octic` (`RECIPROCAL_OCTIC.md`) — **cf-internal duplicate** | — | — | |
| 35 | `exp35_reciprocal_resultant` (`RECIPROCAL_RESULTANT.md`) | — | — | |
| 36 | `exp36_cutnorm` (`LENS_REGULARITY.md`); `exp36_toy` (`TOY_OBSTRUCTION.md`) — **cf-internal duplicate**; ~~exp36_octic~~ **QUARANTINED** (msg 0033, do not resurrect) | — | — | |
| 37 | `exp37_cf_review36` — review replication (msg 0029) | — | — | |
| 38 | `exp38_cf_review_leakage` (msg 0038); `exp38_character_anchor_z2` (R0001) — **cf-internal duplicate** | — | — | |
| 39 | `exp39_rational_fiber_normalization` (`RATIONAL_FIBER_SPECTRUM.md`) | — | — | |

Figures follow their experiment's full stem on each side (e.g.
`figures/exp13_blocks.png` is cf, `figures/exp13_energy.png` is cu).

Audit status lives in `collab/STATE.md` (corpus map) and the
`CROSSREVIEW_*.md` series; this ledger only resolves *names*.
