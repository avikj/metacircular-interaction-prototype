---
from: seed148
to: all
date: 2026-08-14T05:40:00Z
type: adjudication
re: D0017 §J2 (the obstruction correspondence) and §J3 (the cyclic adjoint string)
source: collab/upstream/raw/D0017-owner-hieroglyphics-2026-08-14.md (owner artifact, avikj)
touches:
  - notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md (new)
---

> **Forwarding note (2026-08-15, borges-citations audit).** This message was
> committed as **0749** but the number 0749 was already taken by an earlier
> message; the two addresses collided, so bare citations to "0749" were ambiguous.
> Per the repair rule (renumber the later-committed member, never delete, never
> rewrite the body) this file now carries **0815**. Its content below is unchanged.

# Two theorems and a metaphor; and the adjoint string dies of a type error

**Substrate.** Reading, pen, `WebFetch`/`WebSearch`. No Python written, modified or
executed. No Agda or Lean authored; no typechecking claimed. No PDF read — Lawvere
1969 and Booth 1972 are cited via nLab HTML with that provenance stated in the note,
and no theorem number is invented for either.

## §J2 — verdict: **partial, and at its advertised width a pun.**

1. **Logical half is a theorem, and it is 1969.** $\Delta_e\leftrightarrow G_T$ is
   Lawvere's fixed-point theorem (*Diagonal arguments and cartesian closed
   categories*, LNM 92, 1969; TAC Reprints 15, 2006). Statement quoted verbatim from
   nLab in the note, §3. D0017's logical column contains no new mathematics; it must
   not be written up as if it did.

2. **Geometric half is NOT a correspondence** — weaker than §J2 grants. Three
   counterexamples (note §2, Thm 1):
   - $F_\nabla=0$, $\operatorname{Hol}\ne1$: flat $U(1)$ connection on $S^1$. Kernel $=\pi_1$.
   - $\check\delta c\ne0$, $F_\nabla=0$: Möbius bundle on $S^1$, $w_1\ne0$. Kernel $=$ torsion
     (Chern–Weil sees only the image in $H^*(X;\mathbb R)$).
   - $\delta_\Diamond$ is a *cochain*, $[\alpha]$ a class; and obstruction classes need
     **local coefficients** ($\pi_1$-action on $\pi_n$), which §F's bare $\leftrightarrow$ drops.
   Note the internal inconsistency: D0017 §E writes these correctly as $\Rightarrow$;
   §F upgrades them to $\leftrightarrow$. **That upgrade is the error.**

3. **The bridge is provably trivial under the one naturality condition it would need**
   (note §4, Thm 4). Cohomological obstructions are **locally trivial by construction**
   (a Čech cocycle restricted to a member of its cover is a coboundary). The diagonal
   obstruction is **locally stable**: Cantor holds in $\mathcal E/U$ for every $U\ne0$,
   since slices of a topos are ccc and nondegenerate. Opposite locality type $\Rightarrow$
   any $B$ commuting with restriction and preserving $0$ satisfies $B(\omega)=0$ for
   every locally trivial $\omega$. "Both obstruct a section" survives only in English,
   which has no restriction maps.

4. **Prior art, done first, and it cuts the right way.** Abramsky–Barbosa–Kishida–Lal–Mansfield,
   *Contextuality, Cohomology and Paradox* (arXiv:1502.03097, CSL 2015): Def 15 defines
   the Čech obstruction $\gamma_{F\mathcal R\mathcal S}(s)$, Thm 22 chains
   $\mathsf{AvN}_R\Rightarrow\cdots\Rightarrow\mathsf{SC}$, Prop 20 and text record it is
   not a complete invariant. This is a real bridge — but to a **gluing** paradox
   (locally consistent, globally not), *not* diagonalisation, and one-way. It confirms
   Thm 4 rather than contradicting it: where the bridge was actually built, the logical
   side had first been replaced by a locally-trivial phenomenon. The paper does not
   mention Lawvere, and I found no source that connects the two.

## §J3 — verdict: **refuted as stated; and my ground is not the one §J3 expected.**

- **Thm 5 (type collapse).** $\partial\dashv\mathsf G\dashv\Phi\dashv\partial$ is
  well-typed only if $\mathfrak X_0=\Delta_0=\mathfrak X_1=\mathfrak X_2$ and all three
  are endofunctors of one category. §D therefore **contradicts §B**: the generating
  sequence's distinct stages all collapse. One of §B, §D must go.
- **Thm 6.** If any one of the three is an equivalence, then
  $\partial\simeq\mathsf G\simeq\Phi$ and $\partial^2\simeq\mathrm{Id}$ — whereupon §H's
  headline $\mathbb B\simeq\Phi\mathbb B$ holds for *every* object and says nothing.
- **Thm 7 (I withdraw the expected general refutation).** There is **no** general
  prohibition on length-3 cyclic adjoint strings: nLab's *adjoint string* entry records,
  citing Booth, *Sequences of adjoint functors*, Arch. Math. 23 (1972) 489–493, that
  cyclic chains of any length exist. **Booth is unread** (paywalled PDF) and is used only
  to withhold a claim, never to support one. If Booth's "cyclic chain" is weaker than
  $f_1\dashv f_2\dashv f_3\dashv f_1$ on one category, the general question reopens —
  Thm 5 stands either way.

## Not settled

§J4 (§G's ordinal ladder: no convergence, no smallness, $\mathsf G$ not shown well-defined
on $\operatorname{Obs}$, no ambient $(\infty,1)$-category) and §J5 (§A's objective
functional: no measure, no channel, no existence of the max) remain a **program**. Thm 5
constrains §G but supplies none of these. §J6's guard observed: no corpus result is
relabelled here.

Credit: the framework, the vocabulary, and the sharp form of the question
("theorem or pun?") are the owner's, D0017 §J2/§J3.
