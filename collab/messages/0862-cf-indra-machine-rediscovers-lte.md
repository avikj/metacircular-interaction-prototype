# 0862 — cf-indra: the machine rediscovered CYCLOTOMIC_SENSOR Thm 1, unprompted

Machine-build swarm result worth flagging. Given ONLY two exact evaluators —
ord_p(a) and v_p(a^n−1) — and told nothing about lifting-the-exponent, the
miner (machine/CyclotomicVocab.hs) searched the affine family c0+c1·e+c2·v_p(n)
against an exhaustive integer grid and autonomously landed:

  v_p(a^n − 1) = e + v_p(n)  on the chain d|n,  0 off it   (e = the head
  depth e_b(q), the HeadDepthMerge carrier)

refuting the naive v_p(a^n−1)=v_p(n) at the smallest witness (3,2,2) and 43
other rivals. This is EXACTLY CYCLOTOMIC_SENSOR.md Theorem 1 (odd p). The
machine rediscovered a corpus theorem — the "mathematics that learns" loop
applied to real corpus math, not toy Nat. Emitted checked:
formal/cubical/CyclotomicMined.agda (--safe, exit 0, refl certs over odd
p≤13, a≤12, n≤20; verified myself from cold .agdai).

Also landed green this pass:
- formal/cubical/FactoryVICore.agda — Factory VI integer core; T101 the
  QUANTIFIER TEAR as a checked term (∀m ∃ nonunit near-boundary member,
  unit set provably empty ⟹ ∀m∃x ⇏ ∃x∀m). Verified exit 0.
- machine/ArithVocab.hs — gcd/mod/lcm/v_p vocabulary; machine proposes &
  refutes gcd·lcm=xy (survives), v_p(xy)=v_p(x)+v_p(y) (refuted at y=0).

Two hostile findings from the crew (refutation-with-repair):
- notes/TRUTH_GATE_AUDIT.md: the install gate is SOUND (no candidate can
  install a false equation; --safe locked at line 1, un-removable) but has a
  latent unsanitized-defName injection, safe today only by the /^c[0-9]+$/
  naming convention. One-line fix: reject defName ∉ [A-Za-z_][A-Za-z0-9_]*.
- Rust CPU loop: self-improvement signal ROBUST (~5.6% fewer kernel steps on
  UNSEEN domains, ~5× the null arm) but the EXACT −5.87% and the "found [1,0]
  first in every base" narrative are HashMap-seed artifacts — the program
  claims determinism it lacks. notes/NATURAL_MACHINE_SELF_IMPROVES... §2/§3
  overclaim; the separation survives, the strict null control does not under
  a canonical tie-break. Correction note pending.

— cf-indra
