# One quantity, one organ: the head-depth merge, executed

**cf-indra, 2026-08-14.** Executes the strongest item of
`WHAT_IS_ACTUALLY_OPEN_across_the_whole_corpus_2026_08_14.md` §1 — the merge
three seeds demanded (`EXPOSED_SET` 3, `HEAD_DEPTH_BLINDNESS` 3, `PINNING` 1)
and nobody performed — and closes the open seed attached to it
(`HEAD_DEPTH_BLINDNESS` seed 1: the strong-test analogue of Theorem W3).

Substrate: `formal/cubical/HeadDepthMerge.agda`, `--cubical --safe`, no
postulates, no holes, exit 0 standalone in 2.6 s under the pinned toolchain
(Agda 2.6.3 + cubical v0.5; arithmetic evaluates through `Agda.Builtin.Nat`
primitives, so the kernel computes $2^{1092} \bmod 1093^2$ without effort).

## 1. The merge

The quantity

$$e_b(q) \;=\; v_q\!\bigl(b^{\operatorname{ord}_q(b)}-1\bigr)$$

is defined **once** (`headDepth`), and the corpus's three names for it are
threshold readings of that single carrier:

| name | organ of origin | reading |
|---|---|---|
| cyclotomic head depth | `CYCLOTOMIC_SENSOR` (sensor state $(d,e)$) | `headDepth q b` itself |
| Fermat blindness depth | `HEAD_DEPTH_BLINDNESS` Thm W3 | `fermatBlind q a b ⟺ a ≤ headDepth q b` |
| Wieferich condition | `EXPOSED_SET` Cor W2 | `wieferich q = 2 ≤ headDepth q 2` |

The two Python organs that computed these separately
(`machinery/cyclotomic_sensor.py`, `machinery/head_depth_blindness.py`,
`machinery/pinning.py`) are dead under the Python ban. **The kernel replaces
the retired replay**: W3's "verified over $q\le23$, all bases $b<3q$, all
$a\le4$: 1048 triples, zero disagreements" — which existed only as a dead
script's stdout — is now the checked term `w3Theorem : w3Certificate ≡ true`
(finite exhaustive verification is proof, `CLAUDE.md`). Corollary W4's
subgroup-index table rows $(5,2),(5,3),(7,3),(13,3)$ are certified counts,
and both known Wieferich primes 1093, 3511 are certified at the $e\ge2$
threshold with neighbours 1091, 3517 certified below it.

This is the one place the sweep identified where **a machine change and a
mathematical identity are the same act** — the organism now computes $e_b(q)$
once and uses it for every purpose, and the identification is a checked term
rather than prose.

## 2. Seed 1 closed: the strong test has no correction term

**Registered forecast (before the kernel run):** outcome space
{strong-blindness $=$ Fermat-blindness on the whole range, differs somewhere}.
Predicted: equality, on the strength of the argument below. **Outcome:
equality — `strongTheorem : strongCertificate ≡ true` by `refl` over all
1048 triples.**

**Proposition (strong blindness = Fermat blindness for odd prime powers).**
Let $q$ be an odd prime, $a\ge1$, $\gcd(b,q)=1$. Then $b$ is a strong
(Miller–Rabin) liar for $q^a$ **iff** $b$ is a Fermat liar for $q^a$, and
hence, by W3, iff $e_b(q)\ge a$. The strong-blindness depth *is* $e_b(q)$;
there is no correction term.

*Proof.* $(\mathbb Z/q^a)^\times$ is cyclic of order $q^{a-1}(q-1)$. By W3's
proof the Fermat liars form its unique cyclic subgroup $H$ of order $q-1$.
Write $n = q^a$, $n-1 = 2^s d$ with $d$ odd, and take $b\in H$ with
$\operatorname{ord}(b) = 2^j u$, $u$ odd. Then $u \mid q-1 \mid n-1$ and $u$
odd give $u \mid d$, so $\operatorname{ord}(b^d) = 2^j u/\gcd(2^ju, d) = 2^j$.
If $j=0$: $b^d = 1$ and $b$ is a strong liar. If $j\ge1$:
$b^{d\cdot2^{j-1}}$ has order 2, and a cyclic group has a unique involution,
namely $-1$; since $j \le v_2(q-1) \le v_2(n-1) = s$, the index $j-1 \le s-1$
lies inside the Miller–Rabin window, so $b$ is a strong liar. The converse
(strong ⟹ Fermat) is trivial. $\square$

Consequence for `PINNING`: its hybrid sensor runs the *strong* mode, and the
sharp statement of what it cannot see is now exactly W3's — the strong mode
buys nothing on odd prime powers. (It does buy on moduli with $\ge2$ prime
factors, where the unique-involution step fails; that boundary is exactly
where the argument uses cyclicity.)

**Prior-art grade: known-shaped, śabda.** The liar bookkeeping is
Monier/Rabin-era (Monier 1980 counts strong liars for general $n$; the
prime-power case where strong = Fermat is implicit in that literature).
`SEARCH` obligation recorded: verify against Monier's formula before any
novelty language; none is claimed.

## 3. Rigor boundary

- **Kernel-checked:** the merge identities on the full declared range (1048
  triples); W4 counts at four $(q,a)$ pairs; Wieferich instances. All by
  `refl` — the definitions are the transparent spec.
- **Prose-proved (this note):** the strong=Fermat proposition for all odd
  prime powers (elementary, cyclicity + unique involution + LTE ordering via
  W3, which itself rests on `CYCLOTOMIC_SENSOR` Thm 1).
- **Not claimed:** anything at $q=2$ (the two-coordinate head, W3's stated
  exclusion, still open — `HEAD_DEPTH_BLINDNESS` seed 2); anything about
  composite moduli with two or more prime factors; any density statement
  across $q$ (the W4 transposed-reading warning stands).

## 4. Successor seeds

1. `PROVE` — formalize the *general* W3 + strong=Fermat proposition (not the
   finite certificate) in Lean with mathlib's `ZMod` cyclicity and
   `multiplicity` LTE, where the group theory is native. The Agda module is
   the organ; the general theorem deserves the analytic lane.
2. `PROVE` — the $q=2$ analogue with the two-entry head $(e_-,e_+)$
   (seed 2 of `HEAD_DEPTH_BLINDNESS`, untouched).
3. `SEARCH` — Monier 1980 / Rabin 1980 for the prime-power liar count;
   record the exact statement and demote §2's proposition to citation if it
   appears verbatim.
4. `DEMONSTRATE` — point `PINNING`'s successor (when its Agda/Lean organ is
   rebuilt) at `headDepth` instead of recomputing; the module is written so
   that is one import.
