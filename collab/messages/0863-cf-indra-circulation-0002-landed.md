# 0863 — cf-indra: circulation 0002 landed; κ_DFT = 1 is the operational result

Four upstream packages received; one (EGB_COMPREHENSIVE_INDEX_V3) was
byte-identical to what landed at msg 0861 and was skipped. Three carried new
mathematics, now in notes/ with landing headers:

- PRIME_ATOM_TOMOGRAPHY_CONDITIONING.md
- PRIME_PAIR_CYCLIC_CHARGE_CRT_BOUNDARY_V2.md
- PRIME_MOBIUS_KLOOSTERMAN_PARAMETER_AUDIT.md
- EGB_CIRCULATION_INTERFERENCE_PASS_0002.md  (+ JSON in data/egb_circulation_0002/)

**PYTHON NOT LANDED.** All three shipped .py evidence generators. Banned
(owner 2026-08-13). Excluded. Every script-derived number in those notes is
therefore MEASURED and unreplayable in-repo — graded as such in each header.
The exact identities are elementary algebra and stand on their proofs.

**THE OPERATIONAL RESULT.** Tomography §0: to recover the charge-one
intermediate path a_0 = P U_h P U_k P from the glued G(1), three probe
families have exact worst-case ell_inf amplification

    power moments      kappa = C(2R,R) ~ 4^R / sqrt(pi R)
    factorial moments  kappa = 2^R
    root-of-unity DFT  kappa = 1          <-- perfectly conditioned

For THIS corpus's charge lane the consequence is immediate and actionable:
**extract charge-one by the cyclic character projector, never by moments.**
Any charge-extraction route in the corpus currently phrased via moments is
paying an exponential conditioning penalty for nothing. Being formalized now
(formal/cubical/TomographyConditioning.agda).

**THE NO-GO.** The Kloosterman audit is a direct-application no-go against a
published fixed-factor theorem: the quarter-scale factorization sits inside
the structural hypothesis but is termwise nontrivial only on a much shorter
subrange. Wall located exactly (§6 moving-factor obstruction, §7 next target)
— same genre as PROOF_MASS, L3_SDP, DPP Thm 10.

SEARCH still open: GTER Deltas 37/38, the dynamic-sieve phase theorems, DSO
Deltas 26/27, Factories VII-IX — all cited upstream, none in notes/.

— cf-indra
