# arXiv:1805.07047 "Blockchain Cohomology" — primary-source mathematical audit

**Status: line-level audit of the author's own TeX, both versions, plus the
paper's internal review record.** Companion to
`notes/CONSTELLATION_NETWORK_TECHNICAL_ARCHEOLOGY.md` §3.2, which stated the
verdict in five bullets; this note grounds each bullet in quoted source,
extends the defect catalog, and adds the revision history. Audit date
2026-08-12. No numerics were run; every claim below is a statement about a
text, a git history, or standard mathematics.

## 1. Provenance

- Paper: *Blockchain Cohomology*, Wyatt Meldman-Floch (Constellation Labs).
  arXiv:1805.07047 (cs.DC), v1 submitted 2018-05-18. A revised version
  appeared in the MACSPro 2019 proceedings (CEUR Vol-2478, paper 2).
- Direct fetches of `arxiv.org` and `ceur-ws.org` are egress-blocked in this
  environment. The source was obtained instead from the author's public
  repository `Constellation-Labs/hylochain` (git over HTTPS was permitted),
  full history, master at `2c61bb6`.
- The repository's `README.md` states the paper "can be found
  \[in this repo as `differentiable_blockchains.pdf`\] and on
  [arXiv](https://arxiv.org/abs/1805.07047)", so the identification of this
  TeX lineage with the arXiv paper is the author's own.
- **arXiv v1 witness**: commit `1ffb591` ("its finished", author
  `buckysballs <wlmeldmanfloch@me.com>`, 2018-05-17 — one day before the
  arXiv submission), `article`-class TeX whose abstract matches the arXiv
  abstract verbatim. Line numbers "v1:n" below refer to this file.
- **Proceedings-lineage witness**: master `differentiable_blockchains.tex`,
  LLNCS class, bibliography URLs "last accessed" April–October 2019. Line
  numbers "v2:n" refer to this file. Byte-equality with the published CEUR
  PDF was not verified (CEUR blocked); the repo's committed
  `blockchain_cohomology_Wyatt-Meldman-Floch.pdf` is treated as the author's
  proceedings version.
- **Internal review record**: branch
  `developer/nikolaj.kuntner/180811-first-reading` (commit `6ed4414`,
  2018-08-11; merged 2018-09-25) contains a line-by-line reading by
  Nikolaj Kuntner with `%%n`-prefixed comments. Several of the defects below
  were flagged there, three months after v1; the 2019 revision fixed
  typographical items and none of the structural ones.

## 2. What the paper claims to do

From the v1 abstract (v1:45): define cross-chain "liquidity", sharding, and
probability spaces between blockchain protocols via algebraic topology;
implement the framework in a type system via synthetic homology; "use
recursion schemes to define kernels admitting smooth manifolds across
protocol complexes, leading to the formal definition \[of\] a Poincare
protocol." The 2019 version softens the abstract but keeps every headline
construction: Protocol Complex, Protocol Topology, block sheaf, Protocol
Manifold, typesafe Poincaré duality, Poincaré protocol.

The internal reviewer's question on the abstract (commit `6ed4414`) already
identifies the gap this audit confirms: *"To what extent do you really do
this in the paper right now?"*

## 3. Defect catalog

Four defect classes are used below:

- **(T)** typographical / garbled formula;
- **(W)** ill-formed definition — the defined object's type does not parse
  (a set used as a group, a functor used as a set-factor, a derived functor
  equated to a subspace);
- **(P)** proof-by-terminology — a theorem-shaped conclusion inferred from
  the *name* of an imported concept, with none of its hypotheses checked;
- **(M)** misattribution — a cited work credited with a statement it does
  not contain.

### 3.1 Consensus protocols (v1 §1, v2 §2)

1. **(T)** The standard simplex is defined (v1:53, unchanged v2:74) as
   $\Delta^q = \{x \in \mathbb{R} \mid \Sigma x_j = 1,\ x_j \geq \forall j\}$.
   The ambient space should be $\mathbb{R}^{q+1}$ and the inequality
   $x_j \geq 0$; the "$\geq \forall$" is not parseable. Kuntner flagged
   exactly this ("*\geq zero?*") in August 2018 and supplied a corrected
   formula in his comments; **neither version adopts it**.
2. **(W)** "Protocol Complex $S_k: P_k{\Delta^q}$ … at morphism $k$"
   (v1:51): the notation $P_k\Delta^q$ is never defined ($P_k$ acts on a
   simplex how?), and "at morphism $k$" types $k$ as both an index and a
   morphism. Kuntner: "*Does P_k map or is it a set? … is this the same P?
   Without index?*" Unfixed in both versions.
3. **(W)** The consensus protocol is defined as "the singular homology of a
   simplicial chain complex, carried by a group morphism implementing
   distributed consensus" (v1:61). The displayed object (v1:63) is a chain
   complex, not a homology; "singular" and "simplicial" are conflated here
   and again at v1:80 ("the simplicial singular homology group"). $P$ is
   used simultaneously for the admissible-configuration set (v1:59), the
   homology groups $P_k = \ker\partial_k/\mathrm{im}\,\partial_{k+1}$
   (v1:65), and "the functor carrying our consensus operator" (v1:65); the
   text acknowledges the abuse and does not repair it.
4. **(W)** The consensus operator is typed twice, incompatibly:
   $\sigma: \Delta^q \to S$ and $\sigma_k: S_{k-1}\times P_k \to S_k$
   (v1:67–70), and is called a "group morphism" although no group structure
   on $S$ (a set of configurations) is ever given. The continuity remark is
   vacuous: every map out of a discrete space is continuous.
5. **(T, load-bearing)** The boundary operator in v1 (v1:73) is
   $$\partial_k(\sigma) = \sum^{q}_{k=0} (-i)^{i-1}(\sigma \circ \delta_q^{i})$$
   — three simultaneous defects: base $(-i)$ instead of $(-1)$; the sum runs
   over $k$ (which is also the operator's subscript) while the summand's
   index is $i$; the bounds $0..q$ do not match the face maps' declared range
   $1 \le i \le q+1$ (v1:75). The 2019 version (v2:94) repairs it to
   $\sum^{q+1}_{i=1}(-1)^{i-1}(\sigma\circ\delta^i_q)$. The face-map formula
   itself stays garbled in both versions (v1:77, v2:98):
   $(x_1, \dots x_{i-1}, 0, x_i, x_{i+1}, \dots, x_{q-1}, \dots, x_q)$ has a
   duplicated tail; the correct coface inserts $0$ in slot $i$ of
   $(x_1,\dots,x_q)$. This sharpens the archeology note's first bullet: the
   $(-i)^{i-1}$ coefficient is a v1 defect, corrected in the proceedings
   version, with the surrounding index clash corrected and the face-map
   defect retained.
6. **(P)** "it is trivial to note that homology holds $\forall k$, i.e.
   $\partial_k \circ \partial_{k+1} = 0$" (v1:80–82). For the *standard*
   alternating-sum boundary on the *standard* chain groups this is a
   textbook lemma. But the paper's $\partial_k$ is "the differential of a
   distributed consensus morphism" (v1:61): no chain groups are constructed
   from configurations (free abelian groups on what generators?), no
   consensus-specific map is written down, so there is nothing to compose.
   The equation is imported by name, not derived — the archeology note's
   second bullet, confirmed at the exact line.
7. **(P)** "due to the vanishing cohomology up to $k$ … $P_k\Delta^q$ is
   k-acyclic" (v1:85; v2:105 adds the gloss "or that there is a consistently
   forward moving 'arrow of time'"). $\partial^2=0$ makes a complex, not an
   acyclic one; no vanishing was established; and acyclicity has no temporal
   content. The true neighbor in the literature is real but different:
   in the asynchronous-computability framework (Herlihy–Shavit), protocol
   complexes of wait-free immediate-snapshot protocols are provably
   $k$-connected — a hard theorem with an actual proof, not a corollary of
   $\partial^2 = 0$. The paper cites the framework and bypasses the theorem.

### 3.2 Protocol topologies / "liquidity" (v1 §2, v2 §2.1)

8. **(W)** Liquidity is "the existence of a functoral vertex map between
   singular homologies … $l: \bigcup_{k} P_{\pi} \to \bigcup_{k} P_{\pi+1}$"
   (v1:90), with "applications … left as an exercise for the reader"
   (v1:88). The union index $k$ does not occur in the summand. This is the
   archeology note's fifth bullet, verbatim in source.
9. **(T/W)** The layering map (v1:99, unchanged v2:119)
   $\Sigma_\pi: \ker\partial^\pi_k/\mathrm{im}\,\partial^\pi_{k+1} \to
   \partial^{\pi+1}_k/\mathrm{im}\,\partial^{\pi+1}_{k+1}$ is missing
   $\ker$ in the codomain, and no such map is shown to exist.
10. **(P, the central substitution)** The chain-homotopy display (v1:104–106,
    unchanged v2:125–126):
    $$\Sigma_\pi - \Sigma_{\pi+1} = \partial^{\pi}\circ l + l \circ \partial^{\pi+1}
    = \partial^\pi \circ \partial^{\pi+1} = 0$$
    The first equality is the *definition* of a chain homotopy $l$ (already
    with degree and index conventions inconsistent: the standard identity
    $f - g = \partial h + h\partial$ lives on one pair of complexes, while
    $\partial^\pi$ and $\partial^{\pi+1}$ here belong to different
    complexes). The second equality substitutes $l \mapsto \partial$ with no
    typed justification — $l: P_\pi \to P_{\pi+1}$ and $\partial$ are maps
    of different domains — and the conclusion $\Sigma_\pi = \Sigma_{\pi+1}$
    would make the layering trivial if it meant anything. This is the
    archeology note's third bullet, at its exact source line. The follow-up
    "these conditions are met by the definitions of an acyclic carrier"
    (v1:110) invokes the acyclic-carrier theorem without checking its
    hypothesis (that the carrier assigns *acyclic* subcomplexes) and draws a
    conclusion ($\pi$-acyclicity of the layered complex) that the theorem
    does not give (it gives existence of chain maps and homotopies).
11. **(M)** 2019 only (v2:132): "A type hierarchy is enough to verify a
    protocol's equivalence to a Protocol Topology due to covariance, which
    is a valid null differential as detailed by R. Grahm above." Covariance
    of a type constructor is a variance annotation; no functor from a type
    hierarchy to chain complexes is constructed under which covariance
    becomes $\partial\circ\partial = 0$; and Graham's *Synthetic Homology in
    Homotopy Type Theory* (arXiv:1706.01540) contains no statement
    connecting type-level variance to null differentials.

### 3.3 Block sheaves (v1 §3, v2 §3.1)

12. **(M, structural)** Both versions transplant the Mallios–Raptis finitary
    Čech–de Rham machinery onto "protocol topology" by substitution. v2:149
    is explicit: "By constructing the Protocol Topology within a monoidal
    category, A. Malios et al. showed that the singular cohomology of a
    Protocol Topology is equivalent to an A-module of Z+-graded discrete
    differential forms." Mallios–Raptis (Int. J. Theor. Phys. 41 (2002)
    1857–1902) prove statements about *fintoposets arising from finitary
    open covers of spacetime regions* and their Rota incidence algebras;
    they never considered protocol complexes or any distributed-computing
    object. What is genuinely available from the cited chain
    (Sorkin; Raptis–Zapatrin): a finite simplicial complex determines a T0
    poset and an incidence algebra with a graded differential structure. To
    *use* their theorems one must exhibit the protocol complex in that form
    and check the hypotheses; the paper does neither.
13. **(W)** "Blockchains are naturally equipped with a sheaf, that of the
    block" (v1:123; v2:155 says "known as a block hash"). No site, no
    presheaf, no restriction maps, no gluing axiom — nothing sheaf-shaped is
    specified. The accompanying claim that a derivation map lets us
    "'unpack' data within a block recursively" attaches a ring-theoretic
    fact ("every abelian unital ring admits a derivation map") to an object
    with no specified ring structure; and for the 2019 "block hash" reading,
    a cryptographic hash is *designed* to be non-invertible, so the gloss
    contradicts the defining property of the object named.
14. **(T)** v1:128 prints $\Omega(P) = \Omega^0 \oplus \Omega^0 \dots$
    (repeated $\Omega^0$); 2019 fixes to $\Omega^0 \oplus \Omega^1$. The
    decomposition $\Omega = A \oplus R$ itself is genuine Rota /
    Raptis–Zapatrin material — one of the few displayed formulas in the
    paper that is correct as written (in the 2019 version).
15. **(W)** v1:134 defines sheaf cohomology as
    $H_n(X,\epsilon) := R^n(\Gamma(C,\epsilon) := \dots$ — unbalanced
    parenthesis, undefined $C$, homology subscript on a cohomology group —
    and v1:136 asserts "$R^n$ is equivalent to the $i^{th}$ linear ringed
    subspace above": a right derived functor equated to a vector subspace of
    an incidence algebra. Unchanged in 2019 (v2:165–167).
16. **(P/W)** v1:145–149 (v2:175–179): the differential tetrad $\tau$ is
    claimed "equivalent to the $c^\infty$-smooth Cech-de Rham complex",
    with "$\Gamma^{P_m}_m$ … fine by construction" and "$d$ is effectively
    an exterior product". Fineness (a partition-of-unity property) is a
    proved lemma for the specific finsheaves in Mallios–Raptis, not a
    property "by construction" of anything defined here; $d$ is a
    differential, not a product; and the Mallios–Raptis smooth-limit
    statement is an inverse-limit theorem for their objects, not for
    "protocol topologies".

### 3.4 Protocol manifold (v1 §4, v2 §3.2)

17. **(W)** The complete definition (v1:157, v2:184):
    $\Gamma^\epsilon_{\Sigma} = \bigoplus_{0 \leq i \leq \pi} \Sigma_* \epsilon_i$,
    called "the protocol manifold … the ringed vector space formed by the
    direct sum over all protocol sheaves" (v2:182). A finite direct sum of
    pushforward sheaves is declared a manifold: no underlying space, no
    charts, no smooth or even topological structure is produced. Cavallo's
    thesis (cited for "the existence of a tensor product in the cohomology
    theory of homotopy types") concerns cohomology operations in synthetic
    HoTT and contains no manifold construction — the citation decorates
    rather than supports **(M)**.

### 3.5 "Typesafe Poincaré duality" (v1 §5, v2 §4)

18. **(W)** The hylomorphism and metamorphism are "defined" (v1:167, 171) as
    $\epsilon \leftarrow P \times \Sigma : \Omega^T(\epsilon, P)$ and
    $\Omega_\Gamma(P, \epsilon):\Gamma_\Sigma \times \epsilon \rightarrow P$.
    In the recursion-scheme literature a hylomorphism is
    $\mathrm{hylo}\,f\,g = \mathrm{cata}\,f \circ \mathrm{ana}\,g$ for an
    algebra $f: F b \to b$ and coalgebra $g: a \to F a$; a metamorphism
    (Gibbons) is a fold followed by an unfold. The displayed expressions are
    not of this shape and do not type: $\Sigma$, a functor, appears as a
    factor in a cartesian product.
19. **(P, headline)** v1:173–177 (v2:218–222): a "geometric cw-complex" is
    displayed with *bidirectional* differentials
    ($0 \xleftrightarrow{\partial} \dots$) — not a CW complex, and with
    arrows both ways not a chain complex either — and then: "$T$ and
    $\Gamma$ form a poincare complex, **clearly** satisfying the poincare
    duality as $\partial$ vanishes in our construction … The fundamental
    class of our corresponding space is $\Omega^{T^*}_{\Gamma^*}$ which
    carries the type signatures of our hylo and metamorphisms." Poincaré
    duality — $H_k(M) \cong H^{n-k}(M)$ for a closed oriented $n$-manifold,
    via cap product with a fundamental class — requires a manifold, an
    orientation, a dimension, and a nondegenerate pairing; none is present,
    and vanishing differentials imply nothing of the sort (with $\partial=0$
    the complex is its own homology and the duality would still demand a
    rank symmetry never established). A homology class does not "carry type
    signatures". This is the archeology note's fourth bullet at source
    level; it is the paper's culminating definition ("Poincare protocol")
    and rests entirely on this paragraph.
20. **(P)** v1 Remarks (v1:180): "the existence of cycles in a cohomological
    or homological cw-complex imples the existence of forks" — no definition
    of fork in the model, no proof; "simplectic" for *simplicial*. The
    promised future work (semiautomata admitting Poincaré protocols,
    fork-preventing monoidal state transitions) does not appear in any
    located follow-up; the 2019 version deletes these remarks rather than
    proving them.

## 4. Revision history as evidence

The git record shows the repository began (January–March 2018) as
architecture notes ("hylochain", fold/unfold diagrams, code snippets), with
the mathematical vocabulary added in the two months before the arXiv
submission ("its finished", 2018-05-17). The one documented external reading
(Kuntner, 2018-08-11) flagged, at minimum: the $\Delta^q$ definition, the
$P_k$ type ambiguity, the unexplained $P^\sigma_*(S)$ notation, and the
abstract's overclaim. Comparing v1 to the 2019 proceedings version: the
fixes that landed are typographical (boundary coefficient and summation
index, one $\Omega^0$ duplicate, added related-work section, figures,
proper bibliography); every defect of classes (W), (P), (M) above survives
into the published proceedings version unchanged. The paper's own revision
process therefore corroborates the audit's classification: the items the
author could fix by re-typing were fixed; the items requiring mathematics
were not.

## 5. What is actually true nearby

The paper's bibliography is largely real and good, and each headline term
has a legitimate neighbor — which is what makes the text superficially
plausible:

- **Protocol complexes and connectivity.** Modeling distributed executions
  as simplicial complexes and proving impossibility via connectivity is
  established (Herlihy–Shavit's asynchronous computability theorem;
  Saks–Zaharoglou; the Herlihy–Kozlov–Rajsbaum book). Notably, that
  literature contains a developed theory of **manifold protocols**
  (protocol complexes that are pseudomanifolds, supporting index-lemma
  arguments) — the mathematically correct home for any duality-flavored
  statement about consensus, uncited by the paper.
- **Finitary differential structure on posets.** Sorkin's finitary
  substitutes, Raptis–Zapatrin incidence algebras, and Mallios–Raptis
  finitary Čech–de Rham cohomology are real; they apply to fintoposets from
  finitary covers, and *could* in principle be instantiated on a finite
  protocol complex's face poset — but that instantiation is exactly the work
  the paper skips.
- **Synthetic (co)homology in HoTT.** Graham's and Cavallo's developments
  are real and machine-checked; formalizing protocol-complex homology in a
  proof assistant is a sensible project they would support. Nothing in
  either work connects type-system variance to vanishing differentials or
  produces manifolds from sheaf sums.
- **Sheaves for distributed consistency.** The idea "consistency across
  shards = agreement of local data on overlaps" does have a correct
  formalization — cellular sheaves on the execution DAG, with global
  sections as consistent global states (the Abramsky contextuality /
  Hansen–Ghrist line of work, uncited). A "block sheaf" done properly would
  live there. This is the one place where the paper's instinct points at a
  real, workable construction it does not attempt.

## 6. Verdict

Unchanged from the archeology note, now grounded line-by-line: the paper is
a research sketch importing a fertile vocabulary, with **zero proved
statements**. Every load-bearing deduction is of class (P) — a conclusion
inferred from imported terminology with hypotheses unchecked — or rests on a
class-(W) definition that does not parse. The proceedings revision fixed
only class-(T) items. Conference publication establishes provenance, not
correctness; the internal review record shows the well-formedness problems
were known to the project in August 2018.

## 7. Rigor boundary

- **Directly inspected:** `Constellation-Labs/hylochain` full git history
  (master `2c61bb6`); v1 TeX at `1ffb591`; master TeX; Kuntner's review
  commit `6ed4414`; the repo's committed PDFs (filenames and sizes only —
  no PDF text extraction tool was available in this environment).
- **Inference, high confidence:** identification of commit `1ffb591` with
  arXiv v1 (author's README link, commit date one day before submission,
  abstract matches the arXiv abstract); identification of master with the
  CEUR proceedings lineage (LLNCS class, 2019 access dates). Byte-level
  equality with either published PDF was not verified (both hosts blocked).
- **From standard mathematics (no external check needed):** the definitions
  of $\Delta^q$, singular/simplicial boundary, chain homotopy, acyclic
  carrier theorem, sheaf axioms, derived-functor sheaf cohomology, Poincaré
  duality, hylo/metamorphisms.
- **Not verified here:** the numbered internal citations to Nowak's thesis
  (Lemma 4.5, Definition 5.4, Theorem 5.1) — the thesis was not fetchable;
  the pattern of citing numbered results for load-bearing steps is noted,
  their content is not disputed.
- **Not performed:** contact with the author; check of arXiv v2+ (if any
  exists beyond v1 — the arXiv listing was not fetchable; the search snippet
  and the archeology note both refer only to v1).
