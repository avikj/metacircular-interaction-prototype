---
id: R0023
title: Derived cyclotomic identity defects detect shared prime support but Euler-size cancels
status: formalizing
kind: synthesis
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: defect-calculus-nucleus
dependencies: none
statement_hash: 7ca96079e107088cde9b52dc90eb54f8f7d29ff8261cad0f6233ea872552598f
cycle: 2
max_cycles: 4
owner: codex
breaker: invited — independently check derived degrees, zero objects, and cyclotomic tower edge cases
source: notes/DEFECT_CALCULUS_NUCLEUS.md
supersedes: none
updated: 2026-08-12
---

# Tension

The cyclotomic modules recover each Mangoldt atom exactly, but their scalar
cardinalities do not reveal relations among atoms. Derived intersection could
detect shared finite support, yet its canonical Euler realization may erase
the result.

# Rosetta bridge

The common object is `D_m tensor^L_Z D_n`. Cyclotomic identity intersection
supplies `D_n`; a two-term free resolution supplies both ordinary tensor and
`Tor_1`; alternating torsion length supplies the naive scalar realization.

# Exact statement

For `D_n=Z[x]/(Phi_n,x-1)` and `I(m,n)=D_m tensor^L_Z D_n`: `I(m,n)=0` if
either index is not a prime power or if `m=p^a,n=q^b` with `p!=q`. If
`m=p^a,n=p^b`, then `H_0 I(m,n)=F_p=H_1 I(m,n)` and all other homology
vanishes. Consequently its alternating logarithmic cardinality is zero.
Along the tower `O_k=Z[zeta_(p^k)]`, residue transport is `id_Fp`, while the
map on conormal lines induced by `pi_k=u pi_(k+1)^p` is zero.

# Preservation ledger

- Retains the rational prime supporting each prime-power collision.
- Forgets the exponents `a,b` unless logarithmic tower grading is also kept.
- Derived tensor introduces homological degree and exposes a `Tor_1` copy.
- Alternating scalar decategorification destroys the same-prime incidence.
- The ramified tower retains norm and level structure absent from isolated
  modules.

# Proof obligations

1. Use `D_n=F_p` exactly on prime powers.
2. Tensor the standard two-term resolution of `F_p` with `F_q`.
3. Check multiplication by `p` is invertible for `p!=q` and zero for `p=q`.
4. Compute the alternating logarithmic cardinality.
5. Derive the residue and conormal maps from total cyclotomic ramification.

# Falsification

- Find a non-prime-power `n` with nonzero `D_n`.
- Exhibit homology in another degree or nonzero homology for `p!=q`.
- Show an edge case where `pi_k` does not land in `(pi_(k+1))^2`.
- Produce a canonical functorial scalar Euler realization that does not cancel;
  this would refute the stated no-go boundary, not the homology computation.

# Evidence

`notes/DEFECT_CALCULUS_NUCLEUS.md` contains complete symbolic proofs using the
two-term free resolution and cyclotomic uniformizer relation. No numerical
evidence is used.

# Independent audit

Open. The result is non-load-bearing until a separate lineage rederives the
complex and checks conventions for homological degree and norm units.

# Prior art

The tensor/Tor calculation, cyclotomic ramification, and conormal behavior are
standard. No novelty is claimed. The proposed defect-profile assembly and its
use as an engine interface are research design, not a theorem of novelty.

# Successor seeds

- Audit determinant-of-cohomology and finite torsion metrics for a canonical
  polarization that avoids arbitrary degree selection.
- Add logarithmic tower grading to retain prime-power exponents.
- Test whether norm correspondences orient the two-term incidence complex.
- Seek an archimedean completion before comparing with the Weil form.

# Event log

- 2026-08-12: registered in formalizing after exact symbolic derivation; an
  independent breaker is invited.
