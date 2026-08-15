# 0782 — seed 181 — D0020 §J2 adjudicated: the number tower is not an instance of the four modes

> **Forwarding note (2026-08-15, borges-citations audit).** This message was
> committed as **0782** but the number 0782 was already taken by an earlier
> message; the two addresses collided, so bare citations to "0782" were ambiguous.
> Per the repair rule (renumber the later-committed member, never delete, never
> rewrite the body) this file now carries **0817**. Its content below is unchanged.

Deliverable: `notes/NUMBER_TOWER_AS_REPAIR.md`. Read in full first:
`collab/upstream/raw/D0020-owner-fifth-transmission-2026-08-15.md` (§1, §5, §8, §J),
`notes/FOUR_REPAIR_MODES.md`, `notes/EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md`,
D0016 §J6.

**§J2 invited either outcome. The answer is a third one: the theory does not classify the
tower, and is not thereby wrong — it is correctly scoped, and §J2 stepped outside the scope.**

## Verdict

Not one of the four steps $\aleph\subset\zeta\subset\vartheta\subset\varrho\subset\chi$ is an
instance of a proved repair mode. The mode-hypothesis that fails is the first: all four modes
take a 1-cocycle $D\in Z^1(\Gamma,V)$ as input, and no tower step supplies a $\Gamma$, a $V$, or
a $D$ (Thm 1). §J2's *ground* is weaker than its claim — Shapiro's lemma (`EIGHT_CLASSES` Thm 3.3)
consumes $D\in Z^1(\Gamma,V)$ and produces $\operatorname{Coind}_1^\Gamma V$; with no $\Gamma$
there is nothing to coinduce. And "coefficient enlargement" mislocates the slot: what enlarges is
the object slot $\mathcal X$, not $\mathcal R$.

Sharpest form: **$\operatorname{Gal}(\mathbb C/\mathbb R)$ is a product of the last repair, not
an input to it.** The cocycle machinery is available for descent obstructions *along* an extension
(Hilbert 90, $\operatorname{Br}(\mathbb R)=\mathbb Z/2$) and unavailable for the construction of
the extension. The tower is the second kind of thing at every step.

Second, independent failure: the mode one reads off is not a function of the defect. $\mathbb Z$,
$\mathbb Q$ and Cauchy-$\mathbb R$ are quotients ($\Gamma_\circlearrowleft$'s operation);
Dedekind-$\mathbb R$ and $\mathbb R^2$-$\mathbb C$ are not. Same defects, different mode.

## Four theorems separating the steps (all proved in the note)

1. **Steps 1 and 2 are one construction**, monoid localisation $S^{-1}M$: $(\mathbb N,+)$ with
   $S=\mathbb N$ gives $\mathbb Z$; $(\mathbb Z,\times)$ with $S=\mathbb Z^{\ne0}$ gives
   $\mathbb Q$. The tower has at most three shapes, not four.
2. **The displayed step-3 defect cannot reach $\varrho$.** Repairing "$\xi^2=2$" and iterating
   gives $\mathbb Q^{\mathrm{alg}}$, countable; $|\mathbb R|=2^{\aleph_0}$. The transmission
   displays both $\xi^2=2$ and $\varrho=\overline\vartheta$ for one step; a cardinal separates
   them. The real step-3 defect is Cauchy incompleteness — the only step using order/metric data.
3. **Rigidity: $\operatorname{Aut}(\mathbb Z)=\operatorname{Aut}(\mathbb Q)=\operatorname{Aut}(\mathbb R)=1$
   but $\operatorname{Aut}(\mathbb C/\mathbb R)=\mathbb Z/2$.** So steps 1–3 are unique up to
   *unique* isomorphism and step 4 is not: "the" imaginary unit is a choice, and the transmission's
   $\xi^2=-1\rightsquigarrow\iota\in\chi$ names $\iota$ as if determined. It is not.
4. **Step 4 is the only lossy one**: $\mathbb C$ admits no field ordering, so any assignment
   sending all four steps to one mode is wrong on `FOUR_REPAIR_MODES.md` §1.1's *destroys* column
   alone, whichever mode is chosen. Plus Artin–Schreier: the step **terminates** (no proper finite
   extension of $\mathbb C$), and it looks canonical only because $\mathbb R$ is real closed — a
   theorem about $\mathbb R$, silently imported by the "same enlargement once more" reading.

## Two things the corpus gains

- **Ostrowski upgrades the D0019 §B guard.** "$\mathbb Q$ is incomplete" has one repair per place:
  $\mathbb R,\mathbb Q_2,\mathbb Q_3,\dots$, pairwise non-isomorphic. `EIGHT_CLASSES` Thm 6.1
  proved $\operatorname{Class}$ is set-valued using $\Gamma'=1$, flagged there as degenerate. This
  is a classical theorem and an infinite family. $\mathbb R$ is what you get by *choosing the
  archimedean place*.
- **Prop 9 (schema).** Repairs of a defect form a torsor under $\operatorname{Aut}$ of the repaired
  object over the defective one; the repair is canonical iff that group is trivial; initial repairs
  are rigid. This subsumes `FOUR_REPAIR_MODES.md` Thm 3 (the $V^\Gamma$-torsor and the "chosen
  lift") as the cocycle special case. **In the tower, the chosen lift is literally the choice of
  $i$.** I state this as a parallel and refuse to call it an instance — Thm 3's torsor group is
  the invariants of a coefficient module, and there is no module here.

## Boundary statement

`FOUR_REPAIR_MODES.md` §4.3 found the scope edge from one side: quantitative defects (magnitudes,
not classes). The tower is a **second** kind outside the scope and more interesting, because it is
perfectly structural and still not cohomological: *the four modes classify obstructions inside a
fixed ambient; the tower's defects are obstructions to the ambient's existence, and their repairs
are universal constructions. The discriminating datum is a universal property, not a class.*

Queue item raised: universal-construction repairs appear to fill **none** of the six slots of
$\mathfrak U$ — they change the ambient rather than a slot of it. If right, $\mathfrak U$ needs a
seventh component or the slot theory needs a stated domain.

## Scope limits

- Nothing computed; no Python, no Agda, no Lean, nothing typechecked. Thms 1–4, 6–7, 8(c), Prop 9
  proved from definitions; Ostrowski, FTA, Artin–Schreier, Artin's construction, Hilbert 90 and
  the ZF-independence of algebraic closure quoted from standard statements, not re-read. No fetch.
- **Archive.** D0020 states its transcription is not display-complete, and §1 carries a
  `[…run…]`-style marker immediately after the tower. The four defect-arrows as transcribed may
  not be all the owner transmitted; I report the possible absence and do not conclude from it.
  Step 3 is where a fuller display would most plausibly change the reading.
- **Prompt.** The task's gloss ("naturals … complex") matches §1, but §1 additionally glosses
  $\varrho=\overline\vartheta$, which is the load-bearing discrepancy of Thm 4 and would have been
  missed had the prompt's list been taken as the scope.
- `ATLAS_OF_N.md`, `ACTION_RESIDUAL_FORMATION.md`, `QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md`,
  `SEED64_...` are second-hand through the two notes read in full; no argument depends on them.
- D0020 §J1's $\mathfrak{sl}_2$ action remains the transmission's one exactly-checkable claim and
  is untouched here.

Credit: the tower, its arrows, §J2's test-case framing and **समता प्रमाणेन, साम्येन न** are the
owner's; the four modes are the owner's (D0018 §B) as made precise in `notes/FOUR_REPAIR_MODES.md`.
