---
id: R0009
title: Missing-structure certificate for SS-transports of Chowla from F_q[t] to Z
status: formalizing
kind: obstruction
certificate: mixed
load_bearing: false
novelty: possibly-new
generator: proof-diff-engine
dependencies: R0007
statement_hash: 4d3631f4bcdf87463f0df85d1b6e827f18c4327135794fd1875ceb6dcda7f128
cycle: 2
max_cycles: 6
owner: fleet-diff (builder; Workstream B of DIRECT.md)
breaker: invited — any lineage; the elementary lemmas B0-B3 are one-line auditable, the literature failures F4-F5 are cite-checkable
source: notes/PROOF_DIFF_FF.md
supersedes: none
updated: 2026-08-11
---

# Tension

(Non-registry dependencies, prose per schema: Sawin-Shusterman Annals 196
(2022) / arXiv:1808.04001v2; Kowalski Bourbaki Exp. 1193; Carmon-Rudnick
Q.J.Math 65 (2014); Keating-Rudnick IMRN 2014; all fetched and read as
recorded in the note's fetch ledger. In-corpus: FF.md, ATIYAH.md,
KBOUNDARY Thm 4.2, GAUGE Thm F, LENS_CHAITIN Lemma C1 = R0007.)

Chowla over F_q[t] is a theorem in two regimes with two different engines;
the corpus (ATIYAH.md section 3, FF.md) located the geometry but had not
diffed the proof's dependency DAG against Z node by node, and had no named,
category-explicit certificate of what a transport requires and where it
provably fails. DIRECT.md Workstream B demands exactly that deliverable.

# Rosetta bridge

METALOOP move 3 (calibration on solved isomorphs) mechanized as METALOOP
section 4 item 2 (proof-diff engine): align the solved proof's DAG
(shell algebraization -> Pellet parity algebraization -> Frobenius-twist
abelianization -> trace functions -> perverse amplitude + Betti
compression + Deligne purity -> assembly) against the integer side, emit
the missing structure as a typed certificate. The route-local parity
statement transports GAUGE's protected-charge reading: the FF proof pays
the charge toll at the Frobenius twist; any transport must pay it at P2.

# Exact statement

Fix k >= 2 and theta in (0,1). Call an SS-transport any proof of integer Chowla, sum over n <= X of lambda(n+h_1)...lambda(n+h_k) = o(X) uniformly for |h_i| <= X^theta, proceeding by the Sawin-Shusterman route: algebraization of the scale-X shell, conversion of lambda to abelian character objects on a positive-density subfamily, and a Lefschetz-type trace-formula bound whose per-point square-root cancellation beats an exponential complexity constant. Then the proof requires an object (C, X_n, B, L, H) satisfying: P1 (completed connected shift family) a category C with point and cohomology functors containing for each scale a compact object X_n of positive relative dimension over a constant base with pts(X_n) isomorphic to {1,...,X} naturally, plus a geometrically connected family B acting on X_n whose points realize all translations n -> n+h with |h| <= X^theta, with shifted correlation data extending to a single deformable object over B; P2 (charge-algebraizing coefficient object) a tensor-functorial coefficient object L on X_n whose pointwise traces recover lambda, together with a positive-density family of subobjects on each of which L becomes rank-1 abelian with controlled conductor; P3 (spectral engine with compression) a trace formula with amplitude control (cohomology vanishing outside at most two degrees), purity, and complexity bounds exponential in scale, jointly yielding a power saving uniform in the shifts. These requirements fail in the following proved senses: F1 in Z-schemes with constructible coefficients, P1 and P2 fail (initiality of Z forces relative dimension zero and no constant subfield; infinite subsets of Z are Zariski-dense so shells are not uniformly constructible and shell membership is archimedean; lambda is not constructible since constructible functions are eventually constant on Z while lambda(2^k) alternates); F2 in rings with derivations or Frobenius lifts, P2's conversion mechanism fails (Der(Z) = 0, End_Ring(Z) = {id}, the kernel of Buium's p-derivation delta_p(n) = (n - n^p)/p meets Z in {-1,0,1} versus fixed-derivative fibers of size q^(ceil(n/p)) per degree-n shell over F_q[t], and the canonical Frobenius lifts on Z are the identity; moreover ker(d/dt) = constants over C[t], so the mechanism consumes positive characteristic, i.e., inseparability, not geometry); F3 in the extant abelian coefficient category of Z, P2's abelian realization fails (no finite-order Hecke character has chi(Frob_p) = -1 for almost all p, by Chebotarev applied to chi^2 and the positive density of split primes; and the pretentious distance D(lambda, chi(n) n^{it}; X) diverges for every fixed chi and t); F4 in automatic and substitutive completions, P1 and P2 fail (completely multiplicative automatic sequences essentially coincide with Dirichlet characters, and automatic sequences are orthogonal to mu); F5 charge-even abelian-spectral axiom systems cannot supply P3 without P2 (Lemma C1 of R0007, exact finite conservation; calibration: individual level of distribution 3/4 is unknown even under GRH, a no-known-proof statement). Remaining candidate categories, none known to supply P1-P3: F_1-type geometries (Connes-Consani arithmetic site and its square with Frobenius correspondences and Riemann-Roch, Borger Lambda-geometry, Durov, Haran), Deninger's foliated dynamical cohomology, adelic and noncommutative completions (Bost-Connes; connected in the charge-killing gauge direction, discrete in the shift direction where connectivity is needed), and shell-indexed Tannakian categories. Corollary: any SS-transport crosses the parity barrier exactly at P2, whose only known realization is inseparability; an F_1-geometry with only characteristic-0 behavior fails the route even granted P1 and P3.

# Preservation ledger

- Lemmas B0-B3 (the F1-F3 proved senses) are elementary and proved in
  full in notes/PROOF_DIFF_FF.md section 5; each is one-line auditable.
- F4 and the classification inputs are literature theorems, cite-checked
  against abstracts (fetch ledger, note section 8).
- F5's proved part is in-corpus (R0007 Lemma C1, exact finite); the GRH
  calibration is explicitly a no-known-proof statement, not an
  impossibility theorem, and is fenced as such.
- The certificate is ROUTE-LOCAL: it does not claim integer Chowla needs
  P1-P3 absolutely (Tao's logarithmic 2-point proof uses none of them),
  does not exclude the candidate categories D, and does not claim GRH
  provably cannot reach level 3/4.
- Novelty is claimed ONLY for the assembly: the aligned DAG with exact
  consumption points (char p at Pellet + twist, large q at the
  Betti-vs-cancellation race, Deligne at purity only, connectivity at
  vanishing cycles), the P1-P3 certificate with named failure categories,
  the inseparability corollary, and the gauge-vs-base connectivity diff
  against KBOUNDARY/GAUGE. Pellet, the twist, vanishing cycles, and all
  no-go ingredients are classical or in the cited papers.

# Proof obligations

1. Verify Lemmas B0, B1, B2, B3(a) and the t=0 real-character case of
   B3(b) line by line (elementary; done by builder, independent audit
   open).
2. Cite-check F4 (Schlage-Puchta 2011; arXiv:1903.04385, 1904.04337,
   1905.11981; Muellner Duke 2017) against full texts, not abstracts
   (builder checked abstracts only).
3. Confirm the two-regime split and the appendix-only placement of big
   monodromy against the SS source (done by builder from the full text,
   App. A eq. (A.27) context; independent replication invited).
4. Confirm the exact hypotheses q > 685090 p^2 (Thm 1.1) and
   q > p^2 k^2 e^2 (Thm 1.3) against the published Annals version
   (builder read arXiv v2).
5. Downgrade audit: verify every absence claim outside F1-F5 is marked
   "no known object" in the note (rigor boundary, section 7).

# Falsification

- Exhibit a derivation or non-identity ring endomorphism of Z (refutes
  B2; impossible), a constructible realization of lambda (refutes B1;
  impossible), or a Hecke character pretending to lambda (refutes B3).
- Exhibit an SS-transport avoiding one of P1-P3 while still following the
  route as defined (would show the certificate's requirement list is not
  minimal, forcing a sharper route definition).
- Locate the assembly in the literature (an existing aligned-DAG
  certificate for Chowla FF-vs-Z with named failure categories): novelty
  drops to known. Targeted search not yet done beyond the fetched
  surveys; Kowalski Exp. 1193 discusses the analogy but emits no
  category-explicit certificate.
- Exhibit a candidate category in D supplying P1-P3 (would be a major
  positive result, superseding this packet's boundary).

# Evidence

notes/PROOF_DIFF_FF.md (DAG, alignment table, lemmas, certificate, fetch
ledger). Primary sources text-extracted locally: arXiv:1808.04001v2
(86 kB), Bourbaki Exp. 1193 (55 kB), arXiv:1205.1599 (PDF summarized).
No numerics; the only computations are the one-line algebra in B0-B3.

# Independent audit

None yet (builder only).

# Prior art

Sawin-Shusterman 2022 (the theorems and the mechanism); Kowalski Exp.
1193 (the exposition, the GRH/level-3/4 remark, the integer-analogy
discussion — closest prior art for the diff, but no certificate);
Conrad-Conrad-Gross (Mobius quasiperiodicity on r + s^p classes);
Carmon-Rudnick, Keating-Rudnick, Katz (large-q regime); Granville-
Soundararajan (pretentiousness); classification of multiplicative
automatic sequences (Schlage-Puchta, Li, Konieczny, Klurman-Kurlberg,
Muellner); F_1 literature (Connes-Consani, Borger, Buium, Deninger,
Durov, Haran, Deitmar). In-corpus: FF.md, ATIYAH.md section 3, GAUGE,
KBOUNDARY, R0007.

# Successor seeds

- Local abelianization problem (named open question): does there exist a
  partition of {1,...,X} into structured fibers of positive density on
  each of which lambda agrees with a character of controlled conductor?
  The FF answer is yes (p-power cosets); F3/F4 close the known abelian
  and finite-state fiber classes; the general question is open and is
  the exact P2-shaped residue.
- Formalize B0-B3 in Lean (finite, elementary; natural companion to the
  R0007 obligations).
- The gauge-vs-base connectivity diff (note section 4.1) as a theorem
  about the BC groupoid: make precise and prove that no endomorphism of
  the BC system implements the additive shift (currently prose).
- Quantify the inseparability corollary: an axiomatization of "arithmetic
  derivation with large kernel" and a no-go in categories beyond Rings
  (Lambda-rings done trivially here; topoi open).

# Event log

- 2026-08-11: seeded by fleet-diff (Workstream B charter, DIRECT.md;
  proof-diff of Sawin-Shusterman against Z executed from primary
  sources).
