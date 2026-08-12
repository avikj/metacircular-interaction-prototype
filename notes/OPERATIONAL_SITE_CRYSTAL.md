# Operational sites and finite contextual crystals

**Status.** Exact finite mathematics and executable criteria.  The named
lenses in §1 are declared methodological simulations, not historical speech
or identity claims.  The definitions and proofs stand without them.

## 1. Room, provenance, and forecast

One execution process convened an inline constructive salon around the
question: *when do finite experiments reconstruct an object, and what exactly
is retained when they do not?*  The lenses were:

- **Grothendieck-influenced:** ask for a site, covers, descent, and density;
- **Bacon-influenced:** require operational experiments and negative controls;
- **Peirce-influenced:** distinguish abductive nomination from deductive
  reconstruction and retain falsifiers;
- **Voevodsky-influenced:** separate presentation equality, witnessed
  equivalence, and transport;
- **Rovelli-influenced:** treat an observation as relative to a named
  interaction;
- **Wolfram-influenced:** demand a finite executable rule;
- **unnamed breaker:** look for the smallest family that fails to reconstruct.

These labels record transformations of attention.  They do not attribute any
sentence here to the historical people.

### Constructive salon trace

The **Bacon-influenced lens** required every proposed cover to expose an
operation and a negative control.  This produced the separated-but-not-
effective example in §6: distinct globals can be distinguishable although
some compatible local records have no global realization.

The **Peirce-influenced lens** objected that successful reconstruction of the
chosen examples would only nominate a rule.  It asked for the exact observable
consequence of removing one probe.  The answer became the missing-singleton
witness in Theorem 4.1: \(\{\omega\}\) and \(\varnothing\) acquire a spurious
profile morphism.

The **Grothendieck-influenced lens** then strengthened point separation to
reconstruction of every arrow by a restricted nerve.  The **Voevodsky-
influenced lens** prevented us from calling equality of profiles presentation
equality before full faithfulness was proved.  The **unnamed breaker** applied
the distinction to twelve and forced the point-state versus signal-field
control in §5.  The resulting construction is Theorem 4.1 plus the executable
descent checker, not agreement among the lenses.

Registered forecast before construction: `0.55` an ordinary finite sheaf and
density theorem exactly locates reconstruction; `0.30` the contextual quotient
is useful but has no exact restricted-Yoneda relation; `0.15` the site language
adds no operational content.  The first outcome occurred, with an additional
finite density criterion in Theorem 4.1.

## 2. An operational site

An **operational site** is a finite category \(\mathcal E\) of experiments,
equipped with a declared collection of covering families

\[
\{u_i:e_i\to e\}_{i\in I}.
\]

An arrow is a refinement or re-expression of an experiment.  A presheaf
\(F:\mathcal E^{op}\to\mathbf{FinSet}\) assigns to \(e\) its possible
observation records and restricts records along refinements.

For a cover admitting the relevant pullbacks, the comparison map is

\[
F(e)\longrightarrow
\operatorname{Eq}\!\left(
\prod_iF(e_i)
\rightrightarrows
\prod_{i,j}F(e_i\times_e e_j)
\right).                                           \tag{2.1}
\]

We use three different judgments:

- **separated:** (2.1) is injective; local observations distinguish globals;
- **effective descent:** (2.1) is bijective; every compatible local family
  has a unique global amalgam;
- **reconstruction:** a named observation map on a named admissible state
  class is injective.

Surjectivity without uniqueness is not reconstruction.  Injectivity without
surjectivity separates existing states but does not make every formally
compatible local record realizable.

## 3. The finite contextual crystal

Let \(S\) be a finite set of admissible states and let
\(o_i:S\to O_i\) be experiments.  Define

\[
x\sim_{\mathcal O}y
\quad\Longleftrightarrow\quad
o_i(x)=o_i(y)\quad\text{for every }i.               \tag{3.1}
\]

The **finite contextual crystal** is

\[
\operatorname{Cry}_{\mathcal O}(S)=S/{\sim_{\mathcal O}}.
\]

It is canonically the image of the joint observation map
\(o:S\to\prod_iO_i\).  Thus its points are realizable compatible records,
and its origin fiber over a record is exactly the set of states which that
context cannot distinguish.

### Proposition 3.1 (separation is crystal triviality)

The joint observation is injective iff every origin fiber is a singleton iff
\(\operatorname{Cry}_{\mathcal O}(S)\cong S\).

**Proof.** These are three readings of equality of the fibers of \(o\). ∎

This quotient must not be confused with sheafification.  The quotient removes
state distinctions; descent constrains which local records glue.  They meet
when \(S=F(e)\) and the \(o_i\) are restriction maps of one cover: the fibers
measure failure of separatedness, while missing compatible records measure
failure of effective descent.

## 4. Restricted Yoneda density: an exact finite theorem

Let \(\Omega\) be finite and let \(\mathcal P(\Omega)\) be its powerset poset,
viewed as a category.  Choose a full subcategory \(\mathcal B\) of probes.  The
restricted Yoneda profile of \(A\subseteq\Omega\) is

\[
N_{\mathcal B}(A)(E)=\operatorname{Hom}(E,A),
\qquad E\in\mathcal B.                              \tag{4.1}
\]

Because the ambient category is a poset, (4.1) is simply the truth value of
\(E\subseteq A\).

### Theorem 4.1 (singleton density criterion)

The restricted nerve

\[
N_{\mathcal B}:\mathcal P(\Omega)
\longrightarrow [\mathcal B^{op},\mathbf{Set}]
\]

is fully faithful iff \(\mathcal B\) contains every singleton
\(\{\omega\}\), \(\omega\in\Omega\).

**Proof.** If every singleton is a probe, then

\[
A\subseteq C
\iff
\forall\omega\in\Omega,
(\{\omega\}\subseteq A\Rightarrow\{\omega\}\subseteq C).
\]

The right side is precisely the existence of the unique natural
transformation \(N_{\mathcal B}(A)\to N_{\mathcal B}(C)\), since the profiles
are subterminal presheaves.  Thus the nerve is fully faithful.

Conversely, suppose \(\{\omega\}\notin\mathcal B\).  For every probe \(E\),
the implication \(E\subseteq\{\omega\}\Rightarrow E\subseteq\varnothing\)
holds: the only possible nonempty counterexample would be the missing
singleton.  Hence there is a natural transformation
\(N_{\mathcal B}(\{\omega\})\to N_{\mathcal B}(\varnothing)\), although no
inclusion \(\{\omega\}\subseteq\varnothing\) exists.  The nerve is not full.
∎

This theorem is a finite, computable form of density.  Probe profiles recover
not only equality of objects but every inclusion exactly when the atomic
contexts are present.

### Corollary 4.2 (crystal versus density)

For any probe family \(\mathcal B\), quotienting subsets by equality of their
restricted Yoneda profiles produces the contextual crystal of the experiments
\(A\mapsto N_{\mathcal B}(A)(E)\).  The crystal equals the original powerset
category on objects and arrows exactly under Theorem 4.1's singleton
criterion.

The qualification “and arrows” matters.  A merely injective object code need
not be a dense nerve; density reconstructs compositional relations as well.

## 5. A twelve-state control

On \(S=\mathbb Z/12\mathbb Z\), the two observations

\[
o_3(x)=x\bmod3,
\qquad
o_4(x)=x\bmod4
\]

jointly separate points by the Chinese remainder theorem.  The crystal of
**point states** therefore has twelve singleton fibers.

This does not imply that the two marginal pushforwards reconstruct a general
signal \(f:S\to k\).  Those maps forget the coupling between the \(3\)- and
\(4\)-coordinates.  Thus “state reconstruction” and “field reconstruction”
must always name their admissible object class.

The executable criterion also returns `(1,2)` as the minimum separating
subfamily among parity, mod-3, and mod-4: parity is redundant once the latter
two are present.

## 6. Executable certificates

`machinery/operational_site.py` implements:

1. restricted-Yoneda profiles on finite powersets;
2. the singleton density criterion, cross-checked by exhaustive profiles;
3. contextual-crystal fibers and exact minimum separating families;
4. finite separation/effective-descent checks, including invisible pairs and
   missing matching families.

`machinery/test_operational_site.py` contains four exact controls: a missing
singleton kills density; mod-3/mod-4 separate twelve points; overlapping
binary words satisfy descent; and a deliberately restricted global state set
is separated but not effective.

## 7. Rigor boundary

**Proved here:** Proposition 3.1, Theorem 4.1, and Corollary 4.2.  The finite
checks are exact and dependency-free.

**Classical framework:** Grothendieck sites, the sheaf equalizer condition, the
Yoneda embedding, dense subcategories, and the nerve/density theorem are
standard.  No novelty is claimed for that framework.  Theorem 4.1 is its
elementary specialization to a finite powerset site and is offered as a new
repository lemma, not a literature-novel claim.

**Not claimed:** arbitrary finite experiment categories form a Grothendieck
topology; every observation quotient is a sheafification; local agreement
implies global existence; or named methodological lenses reproduce the views
of historical persons.

## 8. Room state and resumption protocol

The durable identity is this room, not an agent or persona.  A later execution
process resumes by reading §§1–8 and the exact test output, then records:

1. which lenses it invoked and what each attended to;
2. the unresolved mathematical tension it inherited;
3. any new construction, objection, or unnamed lens;
4. proof and artifact references for every assertion;
5. a new compressed room state without rewriting this historical one.

Current open tension: extend Theorem 4.1 from truth-valued powerset probes to
finite algebras and their polynomial contexts, and determine when the existing
compositional crystal is the object part of a fully faithful restricted nerve.
