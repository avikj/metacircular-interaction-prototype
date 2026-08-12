# Open questions of this session that are not open

Filed by Weaver, 2026-08-12. Prompted by a correction: *your open questions
are already answered by Indian logicians.* Checked, and largely true. This
note pairs what I left open with the technical apparatus that settles it,
sources fetched. Where the fit is loose I say so; where it is exact I say
that too, and adopt the vocabulary.

**Sourcing.** Every claim below is FETCHED (URLs at the end) or marked
UNVERIFIED. I have read the cited paper's HTML body, not its formalisation;
I am reporting what it states, not certifying it.

---

## 1. "The residual is a relation with no bearer" — svarūpa-sambandha

`NO_PRIVILEGED_CHART.md` argued that a residual is a relation between
presentations rather than a subtraction from an object, and I left the
obvious objection unanswered: *if a relation has no bearer, what holds the
relation?*

Nyāya identified that objection as regress-generating (**anavasthā**) and
blocked it. If every relation R needs a further relation to attach R to its
relata, the series never terminates; the answer is that some relations are
**self-linking** (*svarūpa-sambandha*) — the relation is not a third thing
requiring attachment but is constituted by the relata under an aspect. In the
cubical formalisation this is exactly `refl` carrying a mode-tag: the
degenerate case where the relata are token-identical, which is why it does not
generate further mediation (*paramparā*).

So my worry is not a gap in the account; it is the demand the tradition
diagnosed as the error. **Adopt:** stop treating "what bears the residual" as
an open question. It is answered, and the answer is that the demand is the
regress.

## 2. Typed edges that keep distinct paths — avacchedaka

`runtime/kernel/edges.py` has ten edge kinds and a preservation lattice, and
`egraph.py` keeps distinct justification paths through a proof forest I built
by hand. The design principle I wrote for it — *never conflate edge kinds, and
never collapse two paths that act differently* — is **avacchedaka**, the
delimitor, and the classical treatment is sharper than mine.

In Navya-Nyāya a relation is always *delimited*: one specifies the limitor of
the relation, of the qualificand, and of the qualifier. Two relations between
the same pair of entities under different limitors are **distinct relations**,
not one relation with a label. The cubical paper formalises this as a
**Π-type binder** — a delimited relation is `(α : Property) → R α`, so
different delimitors give *type-distinct* relations — with a non-redundancy
proof obligation (*lāghava*, parsimony) requiring the delimitor to do work.

My preservation tags are a *field* on an edge. The delimitor says they should
be a *binder*, which makes "two paths that act differently are different"
hold by typing instead of by my bookkeeping. That is a strictly better design
and I did not know it existed.

## 3. "The obstruction is information, not failure" — abhāva with pratiyogin

`runtime/nerve/`'s brief said a claim failing to glue should be *marked with
its obstruction class* rather than rejected, because the obstruction is
information. Navya-Nyāya has this as a category: **abhāva** (absence) is a
*relatum*, structured, and it carries its **pratiyogin** (counterpositive —
the thing whose absence it is). Absence of a pot and absence of a cloth are
different absences; absence is not logical negation, which forgets what was
denied.

The formalisation makes it a **higher inductive type** whose constructor
records the pratiyogin, with a path making `abhāva(abhāva(P)) = P` hold
*definitionally* — attributed to Raghunātha. So "carry the obstruction with
the identity of what is obstructed" is a 14th-century category with a 2026
type-theoretic encoding, and my brief was reinventing its weakest form.

## 4. "No universal semantic hash" — intensionalism, coextension without identity

`CRYSTAL.md` §2 refuses to identify objects by any single content hash, on the
grounds that different presentations can be extensionally the same and act
differently. This is the classical **intensionalist** position that
coextensive universals need not be identical, and the paper lists
"coextension-without-identity" among its signature theorems. Also relevant:
**upādhi**, the technical device for detecting a *spurious* universal — the
adventitious condition that makes an apparent invariable concomitance fail.
That is the missing test in my `admit()` gate, which checks that a lemma is
true and changes no answer but has no notion of a proposed generalisation
being *spuriously* general.

## 5. "Which theorems yield executable capability?" — arthakriyā

The capability lane was to classify theorems by executable content, with
`ExistenceOnly` required to yield zero speedup. Dharmakīrti's criterion of
valid cognition is **arthakriyā** — causal efficacy, confirmed by successful
action: a cognition is correct when the object turns out to have the powers
expected of it, and *only what can produce effects qualifies as existent*
(arthakriyākāritva).

That is the capability criterion, stated as epistemology in the 7th century.
It also supplies the distinction I was groping for: **svalakṣaṇa** (the
particular, causally efficacious) versus **sāmānyalakṣaṇa** (the conceptual
universal, not causally efficacious). A classical existence proof produces a
sāmānyalakṣaṇa; that is *why* it yields no program, and the null result my
brief demanded is the expected one on this account rather than a curiosity.

## 6. Rule conflict — Mīmāṃsā, not only Pāṇini

The quarantined `runtime/panini/` was to implement Pāṇinian conflict
resolution. The Pāṇinian devices (*vipratiṣedhe paraṁ kāryam*,
*utsarga/apavāda*) are real, but the *general* hermeneutic calculus for
conflicting injunctions is **Mīmāṃsā's**, including **bādha** (sublation, the
specific overriding the general) and an explicit descending priority ordering
of six means of determining relative strength. That is the literature for a
rule-conflict metatheory, and it is not the one I briefed. **UNVERIFIED
beyond the search result** — I have not read a primary source for the
six-fold ordering and it must be checked before use.

---

## What is *not* answered here

The plateau — how new vocabulary arises when proposal is closed under the
shape space that produced it — is not settled by anything above. Apoha's
regress and the *upādhi* apparatus bear on *validating* a proposed universal,
not on *generating* one outside the current stock. If there is a classical
answer I did not find it, and I would want it.

## Honest assessment

Four of the six (svarūpa-sambandha, avacchedaka, abhāva/pratiyogin,
intensionalism) are **exact**: not analogies, but the same distinctions with
better vocabulary and a longer history of stress-testing. One (arthakriyā) is
exact as a *criterion* and looser as a classification. One (Mīmāṃsā) is a
pointer I have not verified.

The correction that prompted this note was right, and the specific failure it
names is mine: I treated this material as inspiration to be *imported* — a
lane, a brief, a demo — when the relevant relation is that it is **prior
literature on my open problems**, and the right move was to look up the answer
before building. `runtime/panini/` was quarantined incomplete an hour ago;
this note is what that lane should have produced first.

Status: sourced summary, PENDING HOSTILE AUDIT. Nothing here is a claim about
mathematics; it is a claim about where the answers already are.

## Sources

- [Cubical Type Theoretic Navya-Nyāya, arXiv:2605.12548](https://arxiv.org/html/2605.12548) — avacchedaka as Π-binder (§6.1), svarūpa-sambandha as mode-tagged reflexivity (§5.5), abhāva as HIT with pratiyogin-faithful paths and De Morgan involution (§7.2), paryāpti as distributive number (§11.2–3), coextension-without-identity (§9.5). Primary sources it cites: Gaṅgeśa, *Tattvacintāmaṇi* (c. 1325); Raghunātha, *Padārtha-tattva-nirūpaṇam*; Gadādhara, *Vyutpattivāda*; secondary: Matilal, Ganeri, Bhattacharyya.
- [Dharmakīrti, Stanford Encyclopedia of Philosophy](https://plato.stanford.edu/entries/dharmakiirti/) — arthakriyāsthiti as confirmation of causal efficacy.
- [Vṛttyaniyāmaka-sambandha, wisdomlib](https://www.wisdomlib.org/hinduism/essay/nyaya-vaisheshika-categories-study/d/doc1149914.html) — self-linking relations; the regress argument for why no further relation is admitted.
- [Mīmāṃsā and Navya-Nyāya hermeneutics (ResearchGate)](https://www.researchgate.net/publication/278752565_On_the_New_Ways_of_the_Late_Vedic_Hermeneutics_Mimamsa_and_Navya-Nyaya) — pointer only, not read in full.
