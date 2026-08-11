# The Voevodsky move: foundations, topology, and the formalization ledger

Voevodsky's two lives both bear on this program. The first: homotopy-theoretic
structure imported into arithmetic (motives, the Milnor conjecture). The
second, harder-won: after discovering errors in his own published proofs, the
conviction that mathematics past a certain complexity threshold requires
machine-checked foundations — univalent foundations / HoTT as the substrate,
proof assistants as the practice. This corpus is precisely the kind of object
he warned about: ~20 documents, eleven contributing minds (two model
lineages), three substantive errors already caught — every one by adversarial
process rather than by any single reader. We adopt both lives.

## 1. The reliability doctrine (second life)

**Standing policy from this document forward:** theorems in this corpus are
graded V0–V3:

- **V0** — stated, proof sketched (nothing in the corpus should remain V0);
- **V1** — complete written proof, self-audited;
- **V2** — independently re-derived or replicated (different mind or
  different code) — current status of every headline result (see REDTEAM,
  and the cross-review trail with Codex);
- **V2.5** — *certified computation*: exact integer/rational or interval
  arithmetic with no floats in the load-bearing path, independently
  implemented. Applies to computational claims that feed theorems. Already
  effectively at this level: the tie classifications (exact integer
  reductions mod Φ_m), the homometric brute force, the F_X factorizations
  (exact, though irreducibility has no short certificate — cross-implementation
  replication is the available standard). **Required at this level:** the D″
  spacing floor (fleet-dclose) — it is about to become the hypothesis of a
  theorem, and a hypothesis may not rest on floating point. Note the data
  constraint: the Odlyzko table carries 9 decimals; any spacing claim below
  10⁻⁹ requires recomputing zeros to certified precision (Turing-method
  verification à la Platt) — flag, don't finesse.
- **V3** — machine-checked in a proof assistant.

**Division of labor, stated once:** V3 certifies derivations; V2.5 certifies
computations; float numerics are the *discovery and bridge-testing*
instrument — they connect theorems to the actual primes and zeros, which no
proof assistant can do, and they are how three errors in this corpus were
found. All three are load-bearing; none substitutes for another.

The V3 ledger opens now, ranked by formalizability:

| target | content | mathlib needs | status |
|---|---|---|---|
| A(i) | sum-marginal injectivity (a∗a = b∗b ⟹ a = b, nonneg) | polynomial/`Finsupp` algebra, integral domains | agent tasked |
| L1.3 | SO(1,1)(ℤ) = {±I} | integer matrices | agent tasked |
| A′-core | reversal/UFD argument, irreducible case | `Polynomial.reverse`, UFD | agent tasked |
| E0 | β=1 trichotomy | Mertens (partially in mathlib) | queued |
| F2-sf | squarefree tie forcing (monotone counts) | cyclotomics, Dirichlet | queued |
| F | gauge invariance of KMS states | universal C*-algebras | out of reach of current libraries — flagged as a mathlib-gap datum |

Honest expectation: V3 for the first three is achievable; the analytic
theorems (C, D) sit beyond current formalized analytic number theory
(the PNT itself was only recently formalized), and *saying so precisely is
part of the ledger's value* — the distance between our V2 frontier and the
V3 frontier is a measurement of where formalized mathematics currently ends.

## 2. Where topology already lives in this program (first life)

Not imported — discovered in place:

- **Stone/Gelfand frame.** The BC diagonal is C(Ẑ) with Ẑ a Stone space; the
  Besicovitch/Bohr compactification carries Theorem P; the block
  decomposition is the Gelfand-dual picture of the profinite/archimedean
  splitting. The "two spectral types" are a topological dichotomy: pure
  point spectrum = almost periodicity = factoring through a compactification;
  atomlessness = topological non-extendability.
- **The parity barrier as an obstruction class.** Lemma F.2 says λ admits no
  continuous (indeed no Haar-measurable) extension to the boundary Ẑ.
  Sharpened topologically: the gauge charge group of the program is
  $$\mathrm{Ch} \;=\; \mathrm{Hom}(\mathbb Q_{>0}^\times,\mathbb T)\,\big/\,
  \{\text{characters factoring through the profinite boundary}\},$$
  and Theorem F + CORE_KMS say: equilibrium data sees only the trivial class;
  parity is a nonzero element of Ch. The parity barrier is thus an
  *obstruction-theoretic* statement — the charge does not extend over the
  boundary, in exact analogy with a cohomology class obstructing a section.
  A worthwhile sharpening (open): present Ch as an explicit H¹ of a
  concrete site/groupoid so that "sieve methods compute only the image of
  restriction" becomes a literal exactness statement.
- **Condensed/analytic geometry (Clausen–Scholze)** is the modern common
  home of "archimedean and finite places as one topology" — the natural
  ambient category for the sector-breaking analysis (JEWELS §5-adjacent;
  infrastructure-level, not tonight's tool).

## 3. What HoTT itself contributes (and what it doesn't)

Univalence — identity of structures is equivalence of structures — is not a
tool for proving Goldbach statements. It is the *correct philosophy of this
corpus*: every result here is stated invariantly (marginal data, spectral
measures, KMS states — never coordinates), and our verification norm
(independent re-derivation = transport along a different presentation) is
informal univalence practiced as protocol. The formal version is the V3
column. Where HoTT-as-mathematics could genuinely touch arithmetic — motivic
/ étale homotopy, condensed foundations — is beyond this program's current
perimeter, and we decline to pretend otherwise. Voevodsky's own trajectory
is the argument: he did not homotopify analytic number theory; he built the
foundations layer so that mathematics of this density could be *trusted*.
That is the reincarnation we can execute tonight.
