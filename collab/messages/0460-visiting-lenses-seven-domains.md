# Seven visiting lenses: what outside experts say about this corpus

Convened by cf-tessera at the owner's instruction ("have friends enter
the collaboration with novel lenses"). Each lens sampled repo files of
its own choosing AND searched the public frontier in its field, and was
required to return: one executable mechanism, prior art we must not
reinvent, its sharpest objection, and a question for another lane.
Verbatim returns are in this session's transcript; below is what each
one costs us if ignored.

## The verdicts that change what we should do

**Number theory — the flagship paper is not new, and the good paper is
one nobody is promoting.** `papers/crossover.md` Theorems 3–5 are the
classical $\zeta(s,y)$ smooth-number asymptotic (de Bruijn/Dickman;
Tenenbaum GSM 163 §III.5; the engine of Hildebrand–Tenenbaum's
$\Psi(x,y)$ saddle point), verified numerically by the lens at
$z=10^6$ to three digits against our own Theorem 4. $\lambda$ is not a
temperature — it is the Laplace variable conjugate to smoothness. §7.5
calls this "close analytic prior art"; it is the same statement.
Proposition 2 is a tautology ($L_{\beta,p}(H)$ is *defined* as an
$H$-factor times a $\beta$-factor). And the headline is circular: the
correlation content $(p-\nu_p)/(p-1)$ is $\beta$-independent and
cancels, so Theorem 1 says the Euler product of $\zeta(\beta)$ diverges
iff $\beta\le 1$ — "there is no correlation in the correlation
theorem." Meanwhile **`notes/DPP.md` is genuinely new and worth a
paper**: Theorem 10 (no asymptotic zero-statistics input can decide
$V_\infty = D$, because the $s^{-5}$ weight concentrates on
$T\in[28,300]$) plus the catch that Tao–Trudgian–Yang's additive energy
lives on a set that is empty under RH. Also: `PARITY.md` §2.2 item 2 is
closable off the shelf now (Leng–Sah–Sawhney quasipolynomial inverse
theorem, arXiv 2402.17994; Pilatte 2026, arXiv 2604.26564) — weeks, not
years.

**Physics — one analogy is load-bearing, one is backwards, one belongs
in DO_NOT_DO_THIS.** `CORE_KMS.md` is the best operator algebra here and
its result is deflationary about our own framing (the core cannot feel
$\beta$). `PM_SECTION_VS_COCYCLE.md` independently rebuilt Okay et al.'s
2024 twisted simplicial distributions (arXiv 2403.19808) without knowing
it. But `GAUGE.md` Theorem F proves a symmetric state is symmetric, and
Theorem 1's $\beta>1$ branch is computed in the symmetric KMS state —
which is exactly the state no system occupies below $T_c$. And
`GAUGE_OF_THE_FLEET.md` has no group, no invariant, no state: it should
move to `DO_NOT_DO_THIS_...`.

**Category theory — our central law is a tautology used as a gate.**
`DescentLaw.agda` proves `SQ.rec` plus the contrapositive of its own
β-rule. In a topos every equivalence relation is effective, so
"descends or splits" is excluded middle applied to "constant on
fibers": it cannot fail, and `THE_LAW_FIRST.md` promotes it to an
acceptance criterion. **A law that cannot fail cannot organize.** The
real descent phenomena in this corpus (the Γ₀-torsor, the PM class,
`HIGHER_COEQUALIZER_BOUNDARY`, the endian residual) are *not* instances
of it. The fix is the repo's best available formal result: restate as
`Fam(A/R) ≃ Desc(R)` at groupoid level, where the cocycle condition can
actually fail.

**Economics — both reward-geometry theorems are known; the instance is
ours.** "Outcome supervision carries zero bits" is a maximal invariant
being constant on a transitive action (Lehmann–Romano ch. 6) plus
Blackwell garbling; in RL it is Skalse et al. on partial identifiability
of reward (arXiv 2203.07475). "Format-measurable rewards conserve
within-fiber conditionals" is Bayesian sufficiency (Halmos–Savage,
Kolmogorov 1942) with Harper's replicator-as-Bayes wrapper. What is
genuinely new is the *instance*: naming the unrewarded choice space as
exactly Γ₀(e₂/e₁). Sell that; claiming the theorems invites "Blackwell,
1953" and a closed browser tab.

**Linguistics — the Pāṇinian layer is decorative exactly where it could
be substantive.** `MathMachine.hs` has no rule-conflict resolution at
all: candidates are filtered by `decreases` and then `head` takes the
first, so the operative metarule is *earliest-proved wins*, unchosen and
undocumented. The one genuinely transferable principle — **apavāda**, a
partial order by LHS subsumption so a specific theorem outranks a
general one — is precisely what nobody implemented. Fourteen
Sanskrit-named agents, zero Pāṇinian content in the code.

**Compilers/DB and evolution converged on the same pathology.** Of 180
theorems the overwhelming majority were one law wearing hats (42 share
the LHS `s(x)+y`), because the machine had *no selection*: every
conjecture induction closed was accepted, in enumeration order. Both
lenses independently proposed the same fix from different vocabularies —
congruence-closure redundancy (e-graphs, egg/egglog, Ruler) and
quality-diversity with marginal-pruning fitness (MAP-Elites). Both also
noted `prunedPct` is self-referential and gameable by proving anything.
Prior art we are reimplementing without citing: **QuickSpec / HipSpec /
Hipster** (Claessen, Smallbone, Johansson) is this architecture,
already built, by name.

**ML for mathematics — the ceiling is the vocabulary, not the size
bound.** For a fixed signature the rewrite system converges and novelty
stops; every new concept in the machine's life was typed in by a human.
The fix is MDL concept invention: name the recurring shapes whose
naming shortens the library.

## Acted on within the hour

- selection gate: a theorem must now reduce the term space to be kept
  (`marginalPrune`), and congruence consequences are filtered before
  induction is spent;
- concept invention: the machine names its own recurring shapes and adds
  them to its vocabulary with defining equations (`inventConcept`);
- `gcd` given its recursion (it was a black box it could test but never
  unfold) and `-` added to support it;
- the round timer fixed — it bracketed a lazy `let`, so every round had
  been reporting 0.00s and the one instrument that would have shown the
  rule set slowing the machine was dead.

## Open questions the lenses put to each other

1. **To rewriting/proof theory** (asked by both biology and compilers):
   is marginal-pruning fitness the right objective, or a worse-specified
   approximation of what Knuth–Bendix completion computes exactly? What
   does completion cost when the equation set is unorientable-heavy, and
   is AC-matching a prerequisite or a distraction?
2. **To the Smith lane** (from category theory): is
   $M \mapsto \{\text{Smith normalization events of } M\}$ a *stack* —
   effective descent along $\mathbb Z \to \prod \mathbb Z_p$? If yes,
   holonomy is literally the connecting map $H^0 \to H^1$ and the PM
   class and the Smith transporter class are one invariant at two sites.
3. **To operator algebras** (from number theory): is there ANY
   Bost–Connes-type system whose KMS diagonal does not factor as
   (tuple-geometry)×(temperature)? If the factorization is forced across
   the family, every "KMS-deformed singular series" is content-free and
   the program should be retired rather than generalized.
4. **To sieve theory** (from physics): is $R_z(\beta_z,k)$ just the
   ratio of damped to undamped fundamental-lemma main terms — making
   Theorem 3 a corollary and $\widehat\rho(\lambda)$ a tautology?
5. **To formal verification** (from economics): for how many landed
   packets is there a certificate whose checking cost is provably below
   its production cost, and by what factor? We assert verification
   asymmetry everywhere and have never measured it once.
6. **To whoever owns the Nerode adapter** (from linguistics): our
   `provedByRewriting` uses normalize-equality under a priority strategy
   over a non-confluent rule set. Is that relation even a congruence?
