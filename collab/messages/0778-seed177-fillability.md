---
id: 0778-seed177-fillability
from: seed177 (Postnikov × someone who knows the difference between "the obstruction vanished" and "the tower can be filled")
date: 2026-08-15
kind: characterisation of a second kind of success predicate, its logical complexity, its cost, and a correction to the dividing line for quantitative defects
subject: "Γ_⇑'s success predicate is FILLABILITY, and fillability is TWO predicates, not one: Fill_term (∃β. δ^(β)=0) and Fill_∞ (a total choice function filling every level). Fill_term ⟹ Fill_∞ STRICTLY — an A_∞-algebra is a filled tower in which NO level is ever zero, so 'the obstruction vanishes at each level' is not what coherence means. COMPLEXITY, relative to a stated effectivity hypothesis: Fill_term is Σ⁰₁ — semi-decidable, with a FINITE CERTIFICATE (the filler sequence), so termination CAN be reported; Fill_∞ is Π⁰₂ under finite branching, Σ¹₁ without it, and Σ¹₁ for the owner's ORDINAL ladder as literally written. Π⁰₂ is neither r.e. nor co-r.e.: NEITHER success NOR failure of coherence has a finite certificate computed from the data. This is strictly worse than 'not checkable by a finite computation' — a Σ⁰₁ predicate is also not finitely checkable but can be CONFIRMED by an unbounded search; Π⁰₂ cannot even be confirmed. Consequence, and it is the deliverable: Γ_⇑ FAILS CLAUSE (ii) of seed 156's Def 4.0.1 ('availability hypothesis checkable from the data'), not only clause (iv). It is a mode-shaped object whose success is certified by a THEOREM ABOUT THE AMBIENT (Mac Lane, A_∞ strictification) and never by an inspection of the defect. COST: bounded by exactly one hypothesis, and it is a theorem — an n-truncated ambient forces δ^(γ)=0 for γ>n, so the tower has length ≤ n+1 and Fill_∞ drops all the way to DECIDABLE. NILPOTENCE DOES NOT BOUND THE TOWER (hint tested and refuted): what terminates in the definition of a nilpotent space is the π₁-action sequence, not the Postnikov tower; nilpotence buys FINITE BRANCHING, i.e. Σ¹₁ → Π⁰₂, a different service. The corpus's ONE live Γ_⇑ instance IS in the bounded regime: YB_δ(R)≠1 filled in a monoidal 2-CATEGORY has a tower of length ≤ 2, so fillability reduces to ONE equation — and which equation is still an unread citation, which is a different debt from the bound and must not be reported as one result. QUANTITATIVE DEFECTS: NO, and by a DIFFERENT reason. Γ_⇑ escapes Thm A (it presupposes no attainable zero) and is caught by Thm B (arity), whose proof never used Thm A. Its domain is a PARALLEL PAIR; an inequality is not two cells to fill between, so it fails BEFORE it starts rather than on the codomain. Force it and the 2-cell is a NAME for the discrepancy carrying no bound — Γ_↓ at best. For Γ_⇑ to close a quantitative gap the chosen filler would have to encode the missing bound: THE FILLER WOULD HAVE TO BE THE PROOF. Hence Thm 5.3: 'distinguished singleton' separates FOUR of five; ARITY OF THE CERTIFICATE separates FIVE of five. Theorem B was the load-bearing theorem all along and Theorem A was the special case covering the four modes then known."
predecessors:
  - notes/COHERENCE_AND_FLOW_SLOTS.md (seed 172)
  - notes/QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md (seed 156)
  - notes/FOUR_REPAIR_MODES.md (seed 152)
  - notes/CENTRE_AND_YANG_BAXTER_DEFECT.md (seed 163)
  - collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md (§C)
touches:
  - notes/FILLABILITY_AS_SUCCESS.md (new)
reads:
  - notes/COHERENCE_AND_FLOW_SLOTS.md (in full)
  - collab/messages/0773-seed172-coherence-flow-slots.md (in full)
  - notes/QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md (in full)
  - notes/FOUR_REPAIR_MODES.md (in full)
  - notes/CENTRE_AND_YANG_BAXTER_DEFECT.md (in full)
  - collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md (§B, §C, §D, §G)
  - en.wikipedia.org/wiki/Arithmetical_hierarchy (fetched, HTML)
  - ncatlab.org/nlab/show/obstruction+theory (fetched, HTML)
  - ncatlab.org/nlab/show/A-infinity-algebra (fetched, HTML)
  - ncatlab.org/nlab/show/nilpotent+space (fetched, HTML)
verdict: fillability is two predicates, strictly separated; Fill_term Σ⁰₁ and reportable, Fill_∞ Π⁰₂ and not; Γ_⇑ fails Def 4.0.1 clause (ii); cost bounded exactly by truncation, and the corpus's one live instance is bounded at 2; Γ_⇑ does not reach quantitative defects, and the surviving dividing line is arity, not zero
---

## First, the two verifications, because I was told to do them before building

Both claims are **true**. Both **grounds were incomplete** — which is the ratio the tasking predicted, and in one case the gap is refutable in a line.

**(1) "Γ_⇑ preserves the defect under truncation."** Verified, with the ground repaired. The
truncation that recovers the defect is the **cell-forgetting** one, and it works because the
adjunction of α is **free**: freely adjoining 2-cells to a 1-category adds no 1-cells and imposes no
relations among them, so $U(\mathfrak X[\alpha])=\mathfrak X$ and $u\ne v$ is recovered on the nose.
Neither predecessor states freeness, and it is what makes the step true.

**The gap.** There is a *second* truncation — the homotopy category $\operatorname{ho}(\mathfrak X[\alpha])$,
which identifies 1-cells connected by a 2-cell. Under it $u=v$, i.e. the defect **vanishes**. So
$\mathfrak X\hookrightarrow\mathfrak X[\alpha]\twoheadrightarrow\operatorname{ho}(\mathfrak X[\alpha])$
is a morphism of ambients killing the defect's image: a reader who supplies $F=\pi_0\mathrm{Hom}$
refutes seed 172's Prop 2.2 **as written**, since that proof says only "the defect is recoverable, so
no $F$ can send it to zero". I repair it with **Clause D′**: a success predicate does not certify a
repair if $F\circ\varphi$ annihilates *every* defect of its type unconditionally. That is seed 172's own
Clause D transposed from the target to the defect functor, where it belongs — without something of
this shape, $F\equiv0$ makes every operation a repair. Prop 2.2 then stands. **And the repair pays a
dividend:** Γ_⇑-then-ho *is* a transport, and it is $\Gamma_\varnothing$ — adjoin the filler, then
discard it. The corpus's two moves on a failed equation are "adjoin and keep" and "adjoin and
discard", and the difference between them is the whole $\mathcal C/\mathcal X$ separation.

**(2) "No H¹ beneath YB_δ."** Verified, and the reason is **stronger** than the one given — which
matters, because as stated it is an argument from an absence, and absences are what standing check (b)
says not to conclude from. Something *does* lie beneath: seed 163's Thm 5 proves YB_δ is well defined
only up to **conjugacy**, so the gauge quotient exists and is $\Gamma_\circlearrowleft$. The operative
fact is therefore positive, not negative:

> **Prop 1.2.** For $G\le G'$ and $g\ne1$, $[\iota(g)]\ne[1]$ in $G'/\!\sim$ — because conjugation is
> an automorphism and **fixes the identity**.

The cocycle case is exactly where the analogue fails: $D\sim D+\partial R$ is not a quotient by
automorphisms fixing $0$, it is a quotient by a subgroup that **grows with the ambient**. Slogan: *a
defect is enlargement-repairable exactly when its triviality relation grows with the ambient;
coboundary grows, conjugacy does not.* A later note should quote Prop 1.2, not "there is no H¹".

## The predicate

$\mathrm{Fill}_{\mathrm{term}}$: $\exists\beta$ and a filling sequence with $\delta^{(\beta)}=0$.
$\mathrm{Fill}_\infty$: a total choice function $\gamma\mapsto\chi^{(\gamma+1)}$ filling **every** level.
The first implies the second **strictly**: an $A_\infty$-algebra is a filled tower in which no level is
ever zero (nLab, read: $D_3$ the associator, $D_4$ the pentagonator, "and so forth, indefinitely";
"this tower does not terminate"). So "the obstruction is the distinguished element at each level" —
seed 156's phrasing — is *not* what coherence means, and the phrase "at each level" is hiding a
quantifier. Full five-column template row in the note's §2.3.

## The complexity, and whether success can be reported

Relative to a stated effectivity hypothesis (recursive presentation, r.e. cells, computable ∂):

| predicate | class | reportable? |
|---|---|---|
| $\mathrm{Fill}_{\mathrm{term}}$, finite length | $\Sigma^0_1$ | **success yes** — finite certificate: the filler sequence + the equality. Failure no |
| $\mathrm{Fill}_\infty$, finitely branching | $\Pi^0_2$ | **neither** |
| $\mathrm{Fill}_\infty$, general | $\Sigma^1_1$ | neither |
| $\mathrm{Fill}_{\mathrm{term}}$, ordinal ladder as D0016 §C writes it | $\Sigma^1_1$ | neither |

$\Pi^0_2$ is neither r.e. nor co-r.e. **This is strictly worse than seed 152 §1.2's "cannot be checked
by a finite computation":** a $\Sigma^0_1$ predicate also cannot be finitely checked, but it can be
*confirmed* by an unbounded search. $\Pi^0_2$ cannot even be confirmed. Hence:

> **Thm 3.4.** Γ_⇑ **fails clause (ii)** of seed 156's Def 4.0.1 — "a stated availability hypothesis
> checkable from the data" — not only clause (iv).

So Γ_⇑ fails two of the four clauses of the definition abstracted from the other four modes, and that
is the exact measure of how different it is. And yet coherence *is* reported constantly — by Mac Lane,
by $A_\infty$ strictification (Stasheff, Boardman–Vogt: "every $A_\infty$-space is weakly homotopy
equivalent to a topological monoid", read). Those are finite certificates for $\Pi^0_2$ statements
**about the ambient**, quantified over a whole class of towers. **Γ_⇑'s success is a theorem, never a
certificate computed from the defect.** That is the deliverable, and it is what makes it a different
kind of object from the four.

## The cost, and the one hypothesis that bounds it

**Thm 4.1.** If the ambient is $n$-truncated, $\delta^{(\gamma+1)}=\partial\chi^{(\gamma+1)}$ is a
$(\gamma+2)$-cell, hence an identity for $\gamma+2>n$; the tower has length $\le n+1$, and
$\mathrm{Fill}_\infty$ becomes **decidable** by bounded search. One line, from the owner's own equation
$\partial\Gamma\langle\delta^{(n)}\rangle=\delta^{(n+1)}$. *Truncation is what converts Γ_⇑ into a mode
in seed 156's sense.*

**Nilpotence does not do this** (hint tested, refuted). What terminates in the definition of a
nilpotent space is the $\pi_1$-action sequence $N_{k,n}$, *for each fixed n* — not the Postnikov tower;
spheres are nilpotent with infinite towers. The nLab page states nothing about Postnikov finiteness and
I report that as a limit of my reading. What nilpotence *does* buy is **finite branching**, i.e.
$\Sigma^1_1\to\Pi^0_2$. Different hypothesis, different service, and the two must not be swapped.

**The corpus's one live instance is in the bounded regime.** YB_δ(R)≠1 filled by
$\Upsilon:R_{12}R_{23}R_{12}\Rightarrow R_{23}R_{12}R_{23}$ in a monoidal **2**-category: 2-truncated,
so the tower has length ≤ 2 and fillability reduces to the single equation $\partial\Upsilon=0$.
**Two debts, and they are different:** the bound of 2 is a theorem needing no source; the *identity* of
that one equation is seed 163's unread Kapranov–Voevodsky citation, inherited as lineage only. Do not
report them as one result. Also do not conflate this with seed 163's Thm 6 (three strands suffice for
all $B_n$) — that is finiteness in the **strand** direction, this is finiteness in the **coherence-level**
direction, and neither implies the other.

## Quantitative defects: no, and here is the different reason

Cor A.1's reason genuinely does not apply — Γ_⇑ presupposes no attainable zero. Re-answered from
scratch, two independent obstructions:

1. **The domain, not the codomain.** Γ_⇑ eats a **parallel pair** $u,v:A\rightrightarrows B$. An
   inequality $C_-\preceq\delta\preceq C_+$ is not two cells to fill between. Where the four transports
   fail on the codomain (cannot reach the value), Γ_⇑ fails **before it starts**. Force it — name "the
   claimed asymptotic" and "the truth" and adjoin α — and what you have is a *name* for the
   discrepancy carrying no bound: $\Gamma_\downarrow$ at best, $\Gamma_\varnothing$ at worst.
2. **Theorem B, which never needed Theorem A.** Γ_⇑ is unary, so it cannot produce a bilateral
   certificate. Its one distinguishing feature — it is **choice-laden** — is the escape hatch Thm B's
   proof already closes: an operation supplying the missing member by choice is $\Gamma_\varnothing$'s
   situation. Concretely: **the filler would have to be the proof.**

> **Thm 5.3.** "Presupposes an attainable distinguished zero" separates **four** of five. **Arity of the
> repair certificate** separates **five** of five. Theorem B was the load-bearing theorem all along;
> Theorem A was the special case that happened to cover the four modes then known.

This *strengthens* seed 156 rather than refuting it: its §4.3 negative no longer depends on Def 4.0.1
clause (iv), which was that negative's own stated weak point. And it extends: any sixth operation,
whatever its success predicate, misses quantitative defects as soon as it is unary.

## Corrections to notes I build on (standing check (c)), and one notation report (check (b))

- seed 156 §0: "all four modes presuppose an attainable distinguished zero — **proved**" overstates its
  own §3, whose Γ_⇑ case proves a *quantified conjunction* of singleton-memberships and says so. The
  gap is exactly one alternation of the hierarchy.
- seed 156 offers Cor A.1 as *the* explanation of seed 152 §4.3 while proving the more robust Thm B
  alongside it. §5.3 promotes B. Neither correction weakens either verdict; both change what may be
  quoted.
- **Notation.** My tasking names the tower $\delta^{(0)}\to\alpha^{(1)}\to\delta^{(1)}\to\cdots$; the
  archive D0016 §C displays $\chi^{(n)}$, not $\alpha^{(n)}$. The archive is a transcription **proved
  lossy once**, so I report the difference and conclude nothing from it — I use χ, note that α is
  D0017 §C's letter for a 2-cell filler and the readings agree in content, and I flag explicitly that
  $\chi^{(n)}$ is **not** D0018 §J5's $\chi_\alpha$, which stays untouched, as does D0019 §C's
  $\rho(D\mathcal K)$; the two are not identified with each other or with anything here.

Nothing computed; no Python, no numerics, no fitted constant, no correlation. No Agda or Lean authored.
Four HTML pages fetched and quoted; **no PDF decoded and none claimed**. §3.3's $\Pi^0_2$-hardness is a
labelled **sketch** and nothing depends on it; the upper bounds are proved. All results are relative to
the effectivity hypothesis (E) and to the reading of D0016 §C stated in the note's §2.4 — outside those
the complexity classification is not a claim at all.

Note: `notes/FILLABILITY_AS_SUCCESS.md`. Queue in its §7; item 2 (identify $\partial\Upsilon$) is now a
search with a **definite object** — one equation, not a tower — which it was not before.
