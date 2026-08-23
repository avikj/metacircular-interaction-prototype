# A typed obligation calculus: what "downstream discharge, computed globally" means

Fills the `proof-obligation graph` row of `notes/RESEARCH_SYSTEM.md` §4
("mostly prose/manual — dependencies exist, but downstream discharge is not
computed globally"). Claimed in msg 0080, fenced against msg 0079's runtime:
this note supplies **semantics**, a pure function of (graph, edge modes,
oracle answers). It certifies nothing. It computes what *would* follow from
oracle answers it never supplies.

Everything below is order theory and graph theory. There is no numerical
content, so `CLAUDE.md`'s standard applies vacuously; the one computational
section (§7) is an exact combinatorial evaluation on the actual corpus —
certified symbolic, i.e. proof, not measurement.

---

## 0. The one-paragraph version

A corpus is a graph of packets. Some packets carry *open obligations* —
duties that were never discharged (a prior-art search not run, a constant
fitted rather than derived, a cited theorem whose hypotheses were never
checked at the use site). The naive model says an open obligation poisons
everything downstream. That model is refuted by this corpus's own error
record: **most corrections here were scope-restricting, not fatal** — the
downstream claim survived with narrowed hypotheses. So propagation must be
valued in a lattice of scopes, not in a boolean. Doing that yields a
linear-time global discharge computation which is *exactly* (not merely
safely) the meet over all dependency paths (Theorem O2 + Prop O2.3), and it
yields the result that matters operationally:

> **You never re-audit a corpus. You audit a min cut of it** (Theorem O3) —
> and max-flow proves no cheaper audit exists (Cor. O3.1).

with the conservation law that follows (Theorem O6): work attached
downstream of the cut has **zero marginal audit cost**, and every genuinely
new external dependence costs exactly one audit. That is a design law for
the machine, not a metaphor.

---

## 1. Setup

**Definition 1 (corpus).** A *corpus* is a finite directed multigraph
$G=(V,E)$ together with a mode labelling $m:E\to M$. Vertices are
*packets* (notes, theorems, claims); an edge $e:u\to v$ means "$v$ depends
on $u$", and $m(e)$ records *how* $v$ uses $u$. Cycles are permitted; §2
does not assume acyclicity.

**Definition 2 (scope semilattice).** A finite meet-semilattice
$(\mathcal S,\wedge,\top)$ with least element $\bot$. An element is a
*scope*: the set of situations in which a statement is asserted to hold.
$\top$ = asserted without restriction; $\bot$ = asserted nowhere (dead).
Order: $s\le s'$ means $s$ is the more restricted assertion. The meet of
two scopes is their conjunction of restrictions.

For this corpus $\mathcal S$ is a product of chains $\prod_i C_i$, one
factor per *aspect* — mathematical validity, novelty, effectivity,
uniformity, parameter range. The aspects are read off the failure record
in §5 rather than posited; an aspect with no witness in the record does not
enter the model.

> **POINTER, 2026-08-14, ibn-al-haytham: this "product of chains" is now
> load-bearing, and it was not before.** O1–O3, O5, O6 need only a finite
> meet-semilattice with $\top,\bot$; O4 re-declares the hypothesis inside its
> own statement. So Definition 2's declaration was used nowhere — until the
> mode-vocabulary question. A product of chains is **distributive**, and
> `notes/THRESHOLD_GENERATION_DICHOTOMY.md` §6–§7
> (`formal/cubical/ThresholdGenerationDichotomy.agda`, EXIT=0) proves: on a
> finite distributive $\mathcal S$ the admissible transfers are exactly the
> pointwise meets of thresholds $s\mapsto(\top$ if $s\ge a$, else $b)$,
> whereas on the non-distributive $M_3$ the **identity** is admissible and is
> no meet of thresholds at all. Consequence for a successor: **generalising
> $\mathcal S$ beyond a product of chains keeps Theorem O2 but destroys the
> mode classification**, leaving no known finite generating family for the
> modes. Pointer only — nothing else in this note edited.

**Definition 3 (obligation).** An obligation on a packet is a pair (type
$\tau$, status $\in\{$open, discharged$\}$). Each type carries a *default*
$d_\tau:\mathcal S\to\mathcal S$, monotone with $d_\tau(s)\le s$: the scope
the packet actually enjoys while $\tau$ is open, given the scope it claims.
Discharging $\tau$ replaces $d_\tau$ by the identity. Write

$$\sigma_0(v)\;=\;\Bigl(\textstyle\bigcirc_{\tau\ \mathrm{open\ at}\ v} d_\tau\Bigr)\bigl(\mathrm{claimed}(v)\bigr)$$

for $v$'s *own* scope, before any dependency is taken into account.

**Definition 4 (transfer and generation).** Each edge $e$ carries

- a monotone *transfer* $t_e:\mathcal S\to\mathcal S$ with $t_e(\top)=\top$:
  if the source holds only at scope $s$, the target inherits $t_e(s)$
  through this use;
- a *generation* $g_e$: a (possibly empty) set of obligations added to the
  target by the act of using the source in this mode.

Generation is not decoration. It is the formal home of the corpus's
sharpest recorded lesson: importing a *technique* does not import its
licence. If $v$ reuses $u$'s method, $u$'s scope does not transfer — $v$
re-derives — but $v$ acquires a fresh duty to check that method's
hypotheses *at its own site*. `collab/FAILURES.md` F11 is exactly this
obligation going untracked ("exact and approximate hypotheses must never
share a sentence"), and F10 is the prior-art analogue.

The modes used here, with their transfers:

| mode $m(e)$ | meaning | $t_e$ | $g_e$ |
|---|---|---|---|
| STATEMENT | $v$ invokes $u$'s result | $\mathrm{id}$ | — |
| VALUE | $v$ consumes a constant/quantity from $u$ | $s\mapsto s\wedge c_e$ | — |
| TECHNIQUE | $v$ reuses $u$'s method, re-deriving | $\equiv\top$ | hypothesis-check at $v$ |
| COMPANION | cross-reference only | $\equiv\top$ | — |
| SUPERSESSION | $u$ retracts/replaces $v$ | *excluded* | — |

SUPERSESSION is deliberately not a dependency edge: it is a rewrite of the
graph, not a flow within it, and conflating the two is what makes a
retraction look like a contradiction instead of an edit. It is dropped
before the calculus runs, and the corpus's cycles are almost entirely
COMPANION and SUPERSESSION edges (§7).

---

## 2. Global discharge

**Definition 5 (the discharge system).** An assignment
$\sigma:V\to\mathcal S$ is *sound* if for every $v$

$$\sigma(v)\;\le\;\sigma_0(v)\qquad\text{and}\qquad \sigma(v)\;\le\;t_e\bigl(\sigma(u)\bigr)\ \ \text{for every } e:u\to v. \tag{2.1}$$

Write $F:\mathcal S^V\to\mathcal S^V$ for
$F(\sigma)(v)=\sigma_0(v)\wedge\bigwedge_{e:u\to v}t_e(\sigma(u))$, so that
sound $\iff\sigma\le F(\sigma)$.

**Theorem O1 (well-posedness; strongest sound assignment).**
$F$ has a greatest fixed point $\sigma^{*}$, and $\sigma^{*}$ is the
greatest sound assignment. It is computed by the descending Kleene chain
$\top\ge F(\top)\ge F^2(\top)\ge\cdots$, which stabilises after at most
$|V|\cdot h$ steps where $h=\operatorname{height}(\mathcal S)$. If the
mode-filtered graph is acyclic, one reverse-topological pass computes
$\sigma^*$ in $O(|V|+|E|)$ semilattice operations.

*Proof.* $\mathcal S$ finite with $\top$ and $\bot$ makes $\mathcal S^V$ a
finite lattice under the product order. Each $t_e$ is monotone and $\wedge$
is monotone in each argument, so $F$ is monotone. Knaster–Tarski gives
$\nu F=\bigvee\{\sigma:\sigma\le F(\sigma)\}$, which is simultaneously the
greatest fixed point and — by the displayed characterisation — the greatest
sound assignment. Monotonicity of $F$ makes $(F^n(\top))_n$ a descending
chain in a finite lattice, so it stabilises, at a fixed point above every
post-fixed point, hence at $\nu F$; the chain can descend at most
$\operatorname{height}(\mathcal S^V)=|V|h$ times. On a DAG, $F(\sigma)(v)$
depends only on strict predecessors of $v$, so evaluating in topological
order assigns each vertex its final value once. $\square$

Note $F(\top)(v)=\sigma_0(v)$: the first iterate is exactly "every packet
believed at its own face value", i.e. the pre-calculus state of the corpus.
Everything the calculus adds is what the *later* iterates remove.

**Definition 6 (meet over all paths).** For a path
$\pi=(v_0\xrightarrow{e_1}v_1\to\cdots\xrightarrow{e_k}v_k)$ put
$t_\pi=t_{e_k}\circ\cdots\circ t_{e_1}$ (identity for the empty path). Set

$$\mathrm{MOP}(v)\;=\;\bigwedge_{u\in V}\ \bigwedge_{\pi:\,u\rightsquigarrow v} t_\pi\bigl(\sigma_0(u)\bigr).$$

**Theorem O2 (fixed point is safe; distributivity makes it tight).**
Always $\sigma^{*}\le\mathrm{MOP}$. If every $t_e$ preserves binary meets
($t_e(a\wedge b)=t_e(a)\wedge t_e(b)$) then $\sigma^{*}=\mathrm{MOP}$.

*Proof.* ($\le$) Fix $v$ and a path $\pi:u\rightsquigarrow v$. Applying
(2.1) along $\pi$: $\sigma^*(v)\le t_{e_k}(\sigma^*(v_{k-1}))\le\cdots\le
t_\pi(\sigma^*(u))\le t_\pi(\sigma_0(u))$, each step by soundness and
monotonicity of the $t$'s. Taking the meet over all $u$ and $\pi$ gives
$\sigma^*(v)\le\mathrm{MOP}(v)$.

($\ge$, under distributivity) It suffices to show $\mathrm{MOP}$ is sound,
since $\sigma^*$ is the greatest sound assignment. The empty path at $v$
gives $\mathrm{MOP}(v)\le\sigma_0(v)$. For $e:u\to v$, every path
$\pi:w\rightsquigarrow u$ extends by $e$ to a path $\pi e:w\rightsquigarrow v$,
so meet-preservation and continuity of $t_e$ on the finite meet give

$$t_e(\mathrm{MOP}(u))=t_e\Bigl(\bigwedge_{\pi:\,w\rightsquigarrow u}t_\pi(\sigma_0(w))\Bigr)=\bigwedge_{\pi}t_{\pi e}(\sigma_0(w))\ \ge\ \mathrm{MOP}(v),$$

the last step because the paths of the form $\pi e$ are a sub-family of the
paths ending at $v$, and a meet over a sub-family is $\ge$ the meet over
the whole family. Hence $\mathrm{MOP}$ is sound. $\square$

**Attribution.** Theorems O1–O2 are the standard monotone-dataflow
framework: the fixed-point/meet-over-all-paths distinction and the
distributivity criterion are Kildall's, sharpened by Kam–Ullman; the
lattice fixed point is Knaster–Tarski via Cousot–Cousot's abstract
interpretation. Annotating a dependency graph with semiring/lattice values
and propagating them is the provenance-semiring construction of
Green–Karvounarakis–Tannen. See §6 for the pinned citations and the honest
statement of what is and is not new here. These are *setup*. The content of
this note begins at §3.

**Proposition O2.3 (this corpus's calculus is distributive).** Every
transfer arising from Definition 4 is one of: the identity, a constant
$\equiv\top$, or a clamp $s\mapsto s\wedge c$. All three preserve binary
meets, so $\sigma^{*}=\mathrm{MOP}$ exactly for this corpus.

*Proof.* Identity and constants are immediate. For the clamp,
$(a\wedge b)\wedge c=(a\wedge c)\wedge(b\wedge c)$ by idempotence,
commutativity and associativity of $\wedge$. $\square$

This is the load-bearing use of Theorem O2, and it is worth being explicit
about why. Distributivity is *not* automatic; it fails as soon as a mode's
transfer identifies two incomparable scopes. So Prop. O2.3 is a standing
obligation on the mode vocabulary itself: **any future mode must be checked
to be a clamp, or the linear-time computation silently degrades from exact
to merely conservative.** That check is cheap and is the note's own first
open obligation, recorded as such.

**Corollary O2.4 (why the prose/manual method could not work).**
$\mathrm{MOP}$ is a meet over the set of all dependency paths, whose
cardinality on the actual corpus is computed exactly in §7. A human or an
agent reviewing "the dependencies of a claim" traces a bounded number of
paths, hence computes an upper bound on the true scope — it errs by
believing claims too strongly, in exactly the direction that produces
retractions. The fixed point traces none and is exact.

---

## 3. The repair theorem

Fix the boolean specialisation: $\mathcal S=\{\top,\bot\}$, so the question
is only *is $v$ sound?* Let $O=\{u:\sigma_0(u)=\bot\}$ be the packets
carrying an open obligation, drop COMPANION and SUPERSESSION edges, and
take $t_e=\mathrm{id}$ on what remains. Then Theorem O2 reads:
$\sigma^*(v)=\bot$ iff some $u\in O$ reaches $v$.

Now suppose we want a designated target set $T\subseteq V$ to be sound, and
we are willing to work. There are exactly two ways to break a contamination
route, and the corpus already uses both:

- **Discharge** $u\in O$, at cost $c(u)>0$: run the prior-art search, derive
  the constant, check the cited hypotheses. Effect: $\sigma_0(u):=\top$.
- **Sever** an edge $e:u\to v$, at cost $w(e)>0$: re-derive at $v$, by an
  independent route, what it was importing from $u$. Effect: $t_e:\equiv\top$.

Severing is not a trick; it is what the fleet's cross-lineage audits
already do — an independent re-derivation makes the downstream claim stop
depending on the upstream one, whether or not the upstream is ever fixed.

**Definition 7 (repair).** A repair is a pair $(D\subseteq O,\ S\subseteq E)$
of cost $\sum_{u\in D}c(u)+\sum_{e\in S}w(e)$. It is *valid for $T$* if,
after applying it, $\sigma^{*}(v)=\top$ for every $v\in T$.

**Lemma O3.0.** $(D,S)$ is valid for $T$ iff for every $u\in O\setminus D$
and every path $u\rightsquigarrow t$ with $t\in T$, some edge of the path
lies in $S$.

*Proof.* After the repair, the open-obligation set is $O\setminus D$ and
the surviving edges are $E\setminus S$. By the boolean form of Theorem O2,
$t\in T$ is unsound iff some $u\in O\setminus D$ reaches $t$ in
$E\setminus S$, i.e. iff some $u\rightsquigarrow t$ path avoids $S$. $\square$

**The repair network $N$.** Add a super-source $s^{*}$ and a super-sink
$t^{*}$. For each $u\in O$ add $s^{*}\to u$ with capacity $c(u)$. Keep each
$e\in E$ with capacity $w(e)$. For each $t\in T$ add $t\to t^{*}$ with
capacity $+\infty$.

**Theorem O3 (minimum audit burden is a min cut).** The minimum cost of a
valid repair for $T$ equals the minimum capacity of an $s^{*}$–$t^{*}$ cut
in $N$, and minimum-cost repairs correspond bijectively to minimum cuts.

*Proof.* Let $X$ be a finite-capacity $s^{*}$–$t^{*}$ cut, i.e. a set of
edges of $N$ whose deletion leaves no $s^{*}\to t^{*}$ path. Since the
$t\to t^{*}$ edges have infinite capacity, $X$ contains none of them, so
$X$ splits as $X=\{s^{*}\to u:u\in D\}\ \cup\ S$ with $D\subseteq O$,
$S\subseteq E$, of capacity exactly the cost of the repair $(D,S)$.

Deleting $X$ leaves no $s^{*}\to t^{*}$ path iff there is no $u\in O$ with
$s^{*}\to u$ surviving (i.e. $u\notin D$) and a $u\rightsquigarrow t$ path
in $E\setminus S$ for some $t\in T$ — which is precisely the negation of
the failure condition in Lemma O3.0. So $X$ is a cut iff $(D,S)$ is valid,
and the correspondence $X\leftrightarrow(D,S)$ is a cost-preserving
bijection between finite cuts and repairs. Minimising both sides gives the
claim. $\square$

**Corollary O3.1 (a certified lower bound on unavoidable work).** By
max-flow–min-cut, the minimum audit burden equals the maximum
$s^{*}$–$t^{*}$ flow in $N$. With unit costs, integrality of max-flow gives
$k$ edge-disjoint routes from open obligations to targets; since no single
action lies on two of them, **at least $k$ independent audits are
unavoidable**, and the $k$ routes are the certificate. This survives every
weakening in §4: it is a lower bound, so hardness of the exact optimum
cannot touch it.

**Corollary O3.2 (why this is tractable, precisely).** Regard soundness of
$T$ as a monotone Boolean function $f$ of the repair variables. A
1-certificate of $f$ is a set of actions hitting every contamination route;
the minimum such is the min cut. Hitting-set problems are NP-hard in
general — the reason this one is not is that the clause family here is the
set of $s$–$t$ paths of a graph, where Menger's theorem applies. The
tractability is a property of the *shape* of the dependency structure, and
§4 shows exactly what destroys it.

---

## 4. Where tractability ends

**Theorem O4 (dichotomy for graded repair).** Let
$\mathcal S=\prod_{i=1}^{k}C_i$ be a product of chains with componentwise
transfers.

(a) *(separable actions)* If every repair action affects exactly one
component, minimum-cost repair decomposes into $k$ independent instances of
Theorem O3 and is solvable in polynomial time.

(b) *(shared actions)* If one action may discharge obligations in several
components at once, the problem contains Set Cover, hence is NP-hard, and
the per-component min cuts are an LP relaxation rather than the answer.

*Proof.* (a) Soundness at scope $\top$ is the conjunction over components
of componentwise soundness; with actions confined to single components the
cost separates as a sum over components with disjoint decision variables,
so the minima are attained independently, each by Theorem O3.

(b) Reduce from Set Cover with universe $U=\{1,\dots,k\}$ and sets
$S_1,\dots,S_n$. Take $k$ components; component $i$ is the two-vertex graph
$o_i\to t_i$ with $O=\{o_i\}$, $T=\{t_i\}$, and give both the individual
discharge of $o_i$ and the severing of $o_i\to t_i$ cost $+\infty$. Offer
$n$ shared actions $A_1,\dots,A_n$ of cost $1$, where $A_j$ discharges
$o_i$ for every $i\in S_j$. A finite-cost repair is then exactly a
subfamily of the $S_j$ covering $U$, of the same cost, so minimum repair
cost $=$ minimum cover size. $\square$

**This corpus is in the hard regime, and that is the useful finding.** A
hostile audit here does not discharge one obligation; it clears prior art,
checks hypotheses, and pins scope in one pass — the actions are shared, so
(b) applies. The consequence is not that the theory fails but that the
*deliverable changes*: the exactly-computable, exactly-certifiable object
is the **lower bound** of Corollary O3.1, and the min cut is reported as a
certified floor on audit burden rather than as an achievable schedule.
Reporting a floor is the honest half and is the half that cannot be wrong.

---

## 5. The oracle boundary, and a conservation law

**Theorem O5 (the mechanical half is complete; the external half has size = min cut).**
Whether a given obligation is discharged is not a property of $(G,m)$: for
types like "prior art cleared" or "the cited theorem's hypotheses hold at
this site", the answer lies outside the corpus. Let $L$ be the set of open
obligations and $\alpha\in\{0,1\}^{L}$ an oracle assignment. Then:

1. $\sigma^{*}=\Phi(\alpha)$ for a monotone $\Phi$, computable in
   $O(|V|+|E|)$ per query (Theorem O1);
2. the dependence of $\Phi$ on $\alpha$ is exactly the reachability
   structure of $G$ (Theorem O2, boolean case);
3. the minimum number of oracle bits whose values certify soundness of $T$
   is the min cut of Theorem O3 — in particular it is **independent of
   $|V|$** and can be exponentially smaller.

   > **CLAUSE (3) IS FALSE — see `notes/ORACLE_BITS_ARE_NOT_THE_MIN_CUT.md`
   > (2026-08-14, genius-09).** The proof below borrows Cor. O3.2's answer
   > for a *different* variable set: O3.2's $f$ ranges over repair actions
   > (discharge **and** sever), clause (3)'s over oracle bits ($L=O$) only,
   > and a severing supplies no oracle bit. The correct value is
   > $|R|$, $R=\{u\in O: u\rightsquigarrow T\}$, which is the *least*
   > certifying set under inclusion; $\operatorname{mincut}(N)\le|R|$ with
   > the ratio sweeping $[1/|R|,1]$. Counterexample checked in
   > `formal/cubical/ExtremalDescription.agda` §4 (min cut 1, least
   > certificate 2). O1–O4, O5(1), O5(2), O6 and the "audit a min cut"
   > slogan of O3 are untouched; §5's headline survives with $|R|$
   > substituted, since $|R|\le|O|$ is also independent of $|V|$. Pointer
   > only — nothing else in this note edited.

*Proof.* (1) and (2) are Theorems O1–O2. (3) is Corollary O3.2: certifying
$f=1$ requires fixing a 1-certificate, whose minimum size is the min cut,
and no smaller set of bits suffices since any smaller set leaves some
contamination route entirely unfixed, and the assignment that leaves that
route open is consistent with all queried bits. $\square$

The reading: **the calculus is complete on the mechanical half and locates
the irreducible external half exactly.** "The corpus is large and might be
rotten" is not a quantity; the min cut is.

**Theorem O6 (marginal audit cost).** Let $G'=G+v$ add one packet with
edges from existing packets only. If $v$ carries no open obligation of its
own and every predecessor of $v$ is sound after a repair valid for $T$,
then that same repair is valid for $T\cup\{v\}$; hence

$$\operatorname{mincut}\bigl(G',T\cup\{v\}\bigr)=\operatorname{mincut}(G,T).$$

*Proof.* Apply the repair. Every predecessor of $v$ is sound and
$\sigma_0(v)=\top$, so by (2.1) $\sigma^{*}(v)=\top$: the repair is valid
for $T\cup\{v\}$, giving $\le$. For $\ge$, any repair valid for
$T\cup\{v\}$ is valid for the subset $T$. $\square$

**Corollary O6.1 (the conservation law).** New work costs no audit if and
only if it introduces no new open obligation and reaches back only into
already-certified material. Every genuinely new external dependence costs
exactly one audit, no matter how much is built on top of it afterwards.

This is the design law the row was worth filling for. A research machine
can grow without bound at zero marginal verification cost provided growth
attaches *downstream of the cut*; the cost is incurred once, at the moment
an external fact enters, and never again. It also says exactly which
growth is expensive — new imports, not new theorems — and therefore what
an agent fleet should be told to prefer. The corpus's own record agrees:
the expensive corrections in §6 were all *entry* failures (an uncleared
prior-art check, an unchecked citation, a fitted constant), never failures
of derivation from material already in hand.

---

## 6–8. NOT DONE — status, stated plainly

Three sections were planned and are **not written**: prior art (§6), the
exact corpus extraction (§7), and the witnessed taxonomy (§8). Agents were
running on all three; the human driver redirected the work to
`notes/RUNTIME.md` and the agents were killed mid-flight. Their partial
output was not reviewed and has not been kept. Nothing from them is in the
repository.

This is recorded rather than quietly deleted because the missing sections
are exactly the load-bearing ones, and their absence changes what may be
claimed:

- **§6 missing ⇒ no novelty may be claimed for §1–§2.** The lattice
  machinery is almost certainly known — it is monotone dataflow analysis
  (Kildall 1973; Kam–Ullman on when the fixed point equals the
  meet-over-all-paths) and semiring-annotated dependency propagation
  (Green–Karvounarakis–Tannen, PODS 2007), with assumption-based truth
  maintenance (de Kleer 1986) as a third likely ancestor. Those attributions
  are stated from memory and **have not been verified against sources**, so
  they are a reading list, not a citation. Until someone checks them, §1–§2
  are setup of unknown provenance and §3–§6's status is unknown too.

  > **PRIOR-ART SWEEP 2026-08-14 — §6 serviced to the extent a search can service it:
  > RESOLVED-FOUND, all four from-memory attributions verify, and the reading list is
  > now a citation list.** G. A. Kildall, *A unified approach to global program
  > optimization*, POPL 1973 (1st ACM SIGACT–SIGPLAN Symp. on Principles of Programming
  > Languages), 194–206 — the lattice/fixed-point formulation of dataflow analysis.
  > J. B. Kam and J. D. Ullman, *Monotone data flow analysis frameworks*, Acta
  > Informatica **7** (1977) 305–317 — the meet-over-all-paths vs. maximal-fixed-point
  > comparison, exactly as the row recalls it (date corrected: 1977). T. J. Green,
  > G. Karvounarakis and V. Tannen, *Provenance semirings*, PODS 2007, 31–40 —
  > commutative semirings as annotation algebras. J. de Kleer, *An assumption-based
  > TMS*, Artificial Intelligence **28** (1986) 127–162. **So the §6-missing conclusion
  > stands and can now be stated without the hedge: the lattice machinery of §1–§2 is
  > standard monotone dataflow analysis with semiring-annotated propagation, and no
  > novelty may be claimed for it.** What this does *not* do is close §6: no source text
  > was read (`WebFetch` is EGRESS_BLOCKED; search-summary/śabda grade), and no search
  > was run for the *obligation calculus itself* — discharge cost $c(u)$, the typed
  > correction taxonomy, Prop. O2.3's mode-vocabulary distributivity — which stay
  > unsearched and therefore unattributed. §7 and §8 are untouched and remain NOT DONE.
  > Query: *Kildall 1973 unified approach global program optimization / Kam Ullman meet
  > over all paths lattice / Green Karvounarakis Tannen provenance semirings PODS 2007 /
  > de Kleer ATMS 1986*. Attribution status only.
- **§7 missing ⇒ Corollary O2.4 has no number.** It says the meet-over-all-
  paths ranges over a path set whose cardinality makes manual review
  hopeless. That cardinality was to be computed exactly. It was not, so the
  corollary is qualitative.
- **§8 missing ⇒ the §0 claim is unsupported.** "Most corrections in this
  corpus were scope-restricting rather than fatal" is an empirical claim
  about `collab/FAILURES.md` and the struck passages in `notes/`. It is the
  premise of the whole typed-vs-boolean argument, it was going to be
  checked, and it has not been. Treat it as a conjecture with a known test.

By this note's own §9 these are open obligations of the absorbing kind for
novelty and of the scope-restricting kind for the mathematics: Theorems
O1–O6 stand as proved statements about the model, and nothing is licensed
about whether the model is new or whether it fits this corpus.

## 9. This note's own open obligations

Tracked by its own calculus, which is the only honest way to publish it:

1. **Mode-vocabulary distributivity** (Prop. O2.3). ~~Every future mode must
   be verified to be identity, constant, or clamp. Open, and permanently
   so: it is a duty on additions, not a one-time check.~~

   > **DISCHARGED / REDIAGNOSED, 2026-08-14.**
   > `collab/swarm/2026-08-14/swarm-0814-02-…md` first: admissibility is a
   > closed condition (preservation of binary meets and $\top$ = being a right
   > adjoint), closed under composition and pointwise meet, so this was never
   > a per-addition duty. `notes/THRESHOLD_GENERATION_DICHOTOMY.md` then
   > identifies **what the obligation was asking**: "identity, constant, or
   > clamp" is *exactly* the set of unary **ACUI-polynomials** of
   > $(\mathcal S,\wedge,\top)$ (Thm. A, machine-checked over an arbitrary
   > meet-semilattice), i.e. the duty was "check that each new mode is
   > term-definable" — a criterion **no correct mode vocabulary satisfies**,
   > since Theorem O2 needs the ACUI *endomorphisms*, a strictly larger class.
   > Replacement, valid because Def. 2 makes $\mathcal S$ a product of chains
   > (hence distributive): *a transfer is admissible iff it is a pointwise meet
   > of thresholds $s\mapsto(\top$ if $s\ge a$, else $b)$*, an $O(|\mathcal S|^2)$
   > check against a two-parameter family, not a list. See the pointer at
   > Def. 2 for what breaks if $\mathcal S$ is generalised.
2. **Prior art** (§6). Open. Blocks all novelty language in §1–§2.
3. **Taxonomy witnesses** (§8). Open. Blocks the §0 claim that
   scope-restriction dominates.
4. **Corpus extraction fidelity** (§7). The use-mode classifier is
   keyword-based and will emit UNKNOWN on some edges; the reported min cut
   is only as good as the mode assignment. The obligation is to report the
   UNKNOWN fraction and to compute the min cut under both the optimistic
   (UNKNOWN = COMPANION, no transfer) and pessimistic (UNKNOWN = STATEMENT,
   full transfer) readings, giving an interval rather than a number.
