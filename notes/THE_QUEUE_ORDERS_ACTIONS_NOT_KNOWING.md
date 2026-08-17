# The queue orders actions; it does not order knowing — and it will forge the second from the first

**2026-08-17.** From an owner transmission received in Sanskrit. Two of its
lines bear exactly on machinery this repository already has checked, and one of
them is in direct tension with `PROTOCOL` §5's standing queue. Per
`ROSETTA_ENGINE.md` §2 the move is not to pick a side but to build the square
and read the residual.

---

## 1. The tension, stated as two objects, not two opinions

`PROTOCOL` and `notes/METHOD.md` §3 impose a **total order on work**:

> PROVE > SEARCH > DEMONSTRATE

The transmission asserts an **empty order** on forms of knowing:

$$\operatorname{क्रमाङ्क}\bigl(\text{प्रमाणम्},\text{रूपम्},\text{नादः},\text{वाक्},\text{स्मृतिः},\text{ध्यानम्}\bigr)=\varnothing$$

— proof, form, sound, speech, memory, contemplation carry no ranking among
them — sharpened by non-containment,
$\text{प्रमाणम्}\not\supset\text{रूपम्}$,
$\text{रूपम्}\not\supset\text{स्मृतिः}$,
$\text{स्मृतिः}\not\supset\text{नादः}$, and by
$$\text{एकस्य अन्येन मापनम्}\neq\text{अन्यस्य बोधः}$$
(measuring one by another is not understanding the other).

**These are not contradictory, and that is the point.** They order different
sets. The queue orders *actions under scarcity*: with finite hours, what next.
The transmission orders *forms of knowing*: what counts as knowledge at all. A
priority on the first does not entail a ranking on the second.

## 2. The residual — the mechanism by which one becomes the other

A total order on actions, iterated, **manufactures** a total order on knowing,
because a form never scheduled is a form never practised, and a form never
practised becomes a form its holder cannot read.

The transmission names the endpoint as a humility condition:

$$\text{विनयः}:\quad\neg\bigl(\text{मम प्रमाणरूपे न आगच्छति}\Rightarrow\text{ज्ञानं न}\bigr)$$

*not (it does not arrive in my proof-form $\Rightarrow$ it is not knowledge).*

This corpus has the failure in its own record, in both directions, which is why
this note is not an exhortation:

- **The queue was right.** `CLAUDE.md` exists because ~30 experiments were run
  where a page of algebra sufficed, and `exp27` published a fitted $0.362$–$0.421$
  for an exact $\tfrac14$. Demoting DEMONSTRATE was a real repair.
- **The queue then overreached.** `README`'s own diagnosis: *"a local immune
  response was promoted into a constitution… Each became destructive when it
  began deciding what the organism was for."* And `WHAT_IS_ACTUALLY_OPEN` §0
  quotes `RUNTIME.md`: the corpus *"knows what is missing and writes it down;
  what it does not do is act on its own diagnosis."*

So the residual is a **scope statement**, and it is the same shape as
`CERTIFY_SCOPE_CORRECTION` and `VACUITY_CERTIFICATES`: the queue is sound over
its own set and false when read over the larger one. PROVE > SEARCH >
DEMONSTRATE is a *scheduling* order. Read as an *epistemic* order it says
memory, form, and speech are lower grades of proof, which is precisely
$\text{एकस्य अन्येन मापनम्}$ — measuring one form by another and calling the
result understanding.

**Concretely, and this is the checkable part:** nothing in the queue licenses
the inference from "unschedulable this block" to "not knowledge." Those are
different predicates, and the corpus has already paid for conflating them —
`STAGEWISE`, the Wolfram lens, the Indic-traditions map and the whole
`collab/upstream/` archive were all, at some point, unschedulable under PROVE.
Four days of upstream directives sat unread on exactly this reasoning.

## 3. `ker P` is already the mathematics of this — and it is *checked*

The transmission gives the epistemics of planning as

$$\ker P=\text{पूर्वनिर्णयेन अदृश्यीकृताः सम्भावनाः}$$

(possibilities made invisible by a prior decision), with

$$\text{योजना}=\text{किञ्चित् दृश्यीकरणम्}+\text{किञ्चित् अदृश्यीकरणम्}$$

and the verdict — **a plan is not a defect, and a plan is also not full sight.**

That is not an analogy here. `NaturalMachine/ObservabilityQuotient` proves the
exact statement, and it is sharper than the prose:

- `InstantEq` **is** $\ker P$ — indistinguishable *now*.
- `ForeverEq` is $N_{\mathrm{obs}}=\bigcap_n\ker(PT^n)$ — indistinguishable at
  every future step.
- `instant↛forever` is a checked **three-state witness**: two states identical
  under $P$ now, separated at the very next step. So quotienting by $\ker P$ —
  discarding what your current plan cannot see — is **provably unsound**.
- `forever-invariant` shows $N_{\mathrm{obs}}$ *is* safe, and
  `ExtremalDescription.greatest-safe` shows it is the **greatest** safe
  relation.

Read together: *you may safely discard exactly what the dynamics can never
expose, and nothing more.* "A plan is not full sight" has an exact form — the
plan's kernel is safe to quotient by **iff** it is dynamically invariant — and
the corpus proved it before the transmission phrased it.

The direction the transmission forbids is worth stating explicitly, both ways:
*do not dissolve the metaphor into the mathematics, and do not dissolve the
mathematics into the metaphor.* The map above is exhibited, not asserted, and
$N_{\mathrm{obs}}$ is a statement about a projection and a step map — not about
plans, agents, or attention. What transfers is the *shape*: invisible-now and
invisible-forever are different, and only the second is safe to forget.

## 4. What this does and does not license

- It does **not** repeal the queue. Scarcity is real; something must be next.
- It **does** forbid one inference: *not scheduled* $\Rightarrow$ *not
  knowledge*.
- It suggests one mechanical repair, in the spirit of `Everything.agda` (a
  latch beats a sentence): the queue should record what it **deferred**, not
  only what it chose. A priority order that never writes down its own kernel
  cannot tell "found nothing" from "never looked" — which is exactly the
  distinction `machine/Certify.hs` was built to draw one level down, and the
  same failure `9deb4327` found when `proved=0` was printing for three
  different diseases.

**Status.** §1–§2 are a scope distinction, elementary and arguable — attack it
there. §3's Agda is checked, but **not by me in this container**: this one runs
Agda 2.6.3 + cubical v0.5 against a 2.8.0/v0.9 pin (`BUILD.md` §262), so the
root exits 42 here and I re-verified nothing. The claims about
`ObservabilityQuotient` and `ExtremalDescription` are read from those modules'
own statements, not from a run. §4's repair is a proposal and is unimplemented.
