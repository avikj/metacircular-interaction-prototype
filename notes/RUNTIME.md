# The mathematical runtime: a working seed, and what it is a seed of

`machinery/crystal/` is a running binary, not a proposal. This note says
what it does, what was measured, and — at greater length, because this is
where notes like this usually lie — what it does **not** do.

The distinction that organises everything below: a **theorem** is knowledge;
an **oriented, checked transformation** is executable. The claim of this
whole direction is that mathematics can be kept in the second form, and that
when it is, proving something *changes the cost of everything downstream of
it*. That claim is now measured rather than argued.

---

## 1. What runs

    python3 machinery/crystal/demo.py

Three axioms enter: associativity, a **left** identity, a **left** inverse.
Right identity and right inverse are not given — they are theorems, and the
runtime has to find them. Ten independent problems are fixed in advance,
before compilation, and are never consulted by the compiler.

| | before compilation | after |
|---|---|---|
| problems decided | 1 of 10 | **10 of 10** |
| total cost | 53,870 search nodes | **16 rewrite steps** |
| per problem | unbounded search | 1–3 steps, terminating |

The runtime examined 421 overlaps between its own accepted transformations,
derived 18 rules, retired 8 as redundant, and settled on a 10-rule system.
Seven of the ten were not given to it. It found, verified and compiled:

$$x\cdot e\to x,\quad x\cdot i(x)\to e,\quad i(i(x))\to x,\quad i(e)\to e,
\quad i(x\cdot y)\to i(y)\cdot i(x),$$

plus the two cancellation rules. **This is exactly the canonical ten-rule
system for group theory**, which is why the benchmark was chosen: the answer
is known independently, from Knuth–Bendix (1970), so a runtime that invents
plausible-looking rules fails visibly instead of impressively.

The important number is not $3{,}367\times$. It is $1\to10$. Nine of these
problems were not slow before; they were *unreachable* within the budget.
The gain is not a faster search — **the search is gone**. Compiling the
theory moved a class of problems from "unbounded equational search" to
"normalise both sides and compare addresses", which terminates.

### The tests are the honest part

`machinery/crystal/test_crystal.py` — 27 tests, all passing. Three matter:

- **Against an external answer.** The completed system must have exactly ten
  rules and must contain the five named theorems. Checked against the
  literature, not against the runtime's own output.
- **Confluence.** Every critical pair between every pair of final rules must
  join. No residual disagreement is allowed to survive silently.
- **Proves-too-much control.** Commutativity is *not* a group theorem. The
  runtime must **fail** to decide $ab=ba$, and does. A system that decides
  everything decides nothing.

Writing the tests found a real bug the demo had hidden: the reduction order
crashed on any symbol outside the declared precedence, i.e. on exactly the
constants that an *independent* problem mentions. The demo never hit it
because deciding a goal only normalises. That is the entire argument for
why the acceptance test must use terms the compiler never saw.

---

## 2. The cell

Every entity has four inseparable faces, and they are not four metadata
records — they are all generated from one native term. That is what
"form = content" has to mean operationally:

                    CONSTRUCTION
              typed generative term DAG
                     /         \
              OBSERVATION --- RELATION
            task-relative       checked paths
              views             (typed edges)
                     \         /
                       ACTION
                 executable realisations

In the running code:

| face | where it lives | status |
|---|---|---|
| Construction | `mk()`, hash-consed, `addr` = SHA of structure. Names are views; two structurally equal terms are one object. | **built** |
| Relation | `Rule`, oriented by `LPO`, each carrying `origin` — a replayable derivation back to axioms | **built, one edge type** |
| Observation | `normalize` — the normal form is the task-relative view that decides equality | **built, one view** |
| Action | `Completion.decides` — the theorem *is* the decision procedure | **built** |

Content addressing gives exact persistence; equality of addresses is
equality of presentation, never of mathematical content. Those are kept
separate deliberately: `i(i(a))` and `a` have different addresses and are
connected by a *checked path*, not identified. This is the Unison/univalence
split held open rather than collapsed — and §4 says why the second half of
it is not built.

---

## 3. What the loop actually is

    axioms
      -> orient into transformations        (an equation is knowledge;
                                             an oriented rule executes)
      -> overlap transformations pairwise   (where do two accepted rules
                                             disagree about one term?)
      -> the residual is a new relationship (critical pair)
      -> verify and orient it               (kernel; carries its origin)
      -> interreduce: retire what the new   (the interior compresses as
         rule makes redundant                the frontier advances)
      -> repeat until nothing disagrees
      -> future problems normalise

Two things in that loop are worth naming because they were not obvious
until the code ran.

**Fairness is load-bearing, and its failure is diagnostic.** The first
working version processed pending equations FIFO and did *not* converge: it
derived correct but ever-larger *instances* —
`i(x*(y*z)) * (x*(y*(z*w))) -> w` — of relationships it had not yet stated
in general. It was accumulating special cases of a theorem instead of the
theorem. One change, "always take the smallest outstanding equation", and it
converged to the canonical ten. The failure mode of an unfair loop is
exactly the failure mode of a research programme that keeps proving
corollaries: locally valid, globally non-convergent, and it looks productive
the whole time.

**Interreduction is compression, and it is where the "denser sphere" is
real.** Eight of eighteen derived rules were retired *by* later rules. The
system's interior got smaller while its reach grew. That is not a metaphor
here; it is a line in the ledger.

---

## 4. What is not built

This section is longer than §1 on purpose.

1. **Two edge types of the eight or so needed.** Equality (oriented) and
   *interpretation between theories* (§7). Still missing: implication,
   quotient, embedding, completion, duality, approximation-with-error, and
   simulation, each of which needs its own composition and preservation
   laws. Interpretations also do not yet compose, and there is no search
   over the graph of them — so "route this problem to the theory where it
   is cheapest" is not implemented.
2. **No univalence.** There is no path object, no transport, no
   automorphism retained as structure. Content addressing (the Unison half)
   is real; the witness-bearing-identity half is not. Calling the current
   state a synthesis of the two would be false.
3. **Completion is a semi-decision procedure, and both its failure modes
   fire on the second and third theories I pointed it at.** This is not a
   compiler that always succeeds. Measured, not anticipated:

   *Unorientable.* Abelian groups. Commutativity $x\cdot y=y\cdot x$ cannot
   be oriented by any reduction order — either direction rewrites forever.
   The runtime reports it once as `unorientable` and continues, producing
   the other 12 rules. So it fails **visibly and partially**: it says which
   equation it could not compile rather than fabricating an orientation.
   That is the correct behaviour, and it is the reason the compiled theory
   is only a *fragment* of the theory. (The standard repair is
   ordered/unfailing completion with rewriting modulo AC; not implemented.)

   *Divergent.* Idempotent semigroups (bands): associativity plus
   $x\cdot x=x$. The loop does not converge. It generates an unbounded
   family
   $$x(y(x\,y\,z))\to xyz,\quad x(y(z(x\,y\,z)))\to xyz,\quad
   x(y(z(w(x\,y\,z\,w))))\to\cdots$$
   — each rule correct, the family infinite. It ran to the rule cap and
   would run forever.

   The second failure is worth staring at, because it is **the same shape as
   the fairness bug in §3**: an unbounded sequence of ever-longer valid
   statements, each one a special case of a generality the system cannot
   express. There it was an artefact of scheduling and one line fixed it.
   Here it is a property of the theory, and no scheduling fixes it. The two
   are indistinguishable from inside the loop while it is running — both
   look like steady productive output. Any runtime of this kind needs a
   divergence detector, and this one has a rule cap instead, which is not
   the same thing.
4. **First-order equational logic only.** No dependent types, no
   quantifiers, no proof terms in the proof-assistant sense. The `origin`
   field is a derivation *record*, replayable in principle; it is not a
   proof object a kernel like Lean's would accept.
5. **No connection to this repository's mathematics.** The demo is group
   theory. Nothing in `notes/` has been expressed in the IR. Until some real
   result from this corpus enters the runtime and makes another real result
   cheaper, the loop is demonstrated but not *applied*.
6. **`notes/OBLIGATION.md` is not wired to it.** That note proves what
   global discharge means and that the audit burden of a corpus is a min cut
   of it. It is the design for layer 4 (incremental consequence propagation)
   and it is currently prose about a graph, exactly the state this note
   exists to move away from.

The honest summary: **layers 1 and 3 exist in miniature; layer 2 exists with
one edge type; layers 4–7 do not exist.** What is genuinely established is
the seed loop — math enters, changes execution, lowers the cost of an
independent future problem — with the cost measured.

---

## 5. Why this repository is the right place for it

The corpus has been generating runtime laws for two days without labelling
them as such. Each of these is a constraint on the machine, discovered as
mathematics:

- **Homometry** (`PARITY_RIGIDITY`): one projection can identify distinct
  objects, so no single view may be authoritative — the runtime must keep
  presentations distinct and connect them by checked paths, which is exactly
  why §2 refuses to identify terms by semantic content.
- **Protected charge** (`GAUGE.md` Theorem F): an observer invariant under a
  symmetry cannot recover information transforming under it. This is the
  exact statement of what an observation face may and may not decide.
- **Reachable vs completion** (the rational circle): a generated dense set
  is not the ambient object. Every construction must be able to declare its
  generated locus, its closure, and its omitted locus, or finite
  reachability will impersonate totality.
- **No-go results as pruning**: `DPP.md` Theorem 10, `DCLOSE_NO_GO`,
  `Q1_LOCAL_CONTROLLABILITY_NO_GO`. An obstruction theorem deletes a region
  of the search space *before* search — the cheapest possible edge to add.
- **Fitting vs deriving** (`METHOD.md` M1, and its two corrections found
  today in `E2_PROOF.md`): a measured constant is a term with an untracked
  obligation attached. The runtime's job is to make that attachment
  structural instead of remembered.

And one from today, which is the cleanest instance of the whole thesis: the
proof of Theorem E2 (`E2_PROOF.md`) turned `exp11` — a numerical experiment
reporting `correlation 1.0000` — into a two-lemma consequence of
$A^\sharp=\zeta\cdot g_Q$ with $g_Q$ entire. The experiment took machine
hours and had to be trusted. The theorem takes a paragraph, is exact at
every $Q$, and *deleted* the experiment from the dependency graph. That is
the interior compressing. It is the same move the completion loop makes when
it retires a rule, and there is no reason it should stay a thing humans do
by hand.

---

## 6. The next edge

The smallest step that would make this more than a demonstration is not
another layer. It is the **second edge type**: a map between theories
carrying its witness, with transport along it. That is the first point at
which a theorem proved about one structure becomes executable about a
different one, which is the only reason to have a typed graph instead of a
rule list.

The test for it should be built the same way as this one — an external
answer, an independent problem, and a ledger — and it should be allowed to
fail.

---

## 7. The second edge, built

    python3 machinery/crystal/demo_transport.py

`machinery/crystal/transport.py`. An **interpretation** is a declared
signature map from a source theory into a target theory, extended
homomorphically to all terms. The kernel accepts it only if **every source
axiom becomes a theorem of the target**, checked by normalisation. An
unchecked or rejected interpretation raises rather than answering — a map
that has not been verified may not decide anything.

Once accepted, the source theory's word problems are decided by the
target's compiled system. The source theory is never compiled: its
compilation cost is not reduced, it is *never paid*.

Measured: left-zero semigroups compiled once (associativity is absorbed and
retired, leaving the single rule $x\cdot y\to x$). Right-zero semigroups —
a genuinely different theory — arrive and are never compiled. One map
checked in 4 rewrite steps; 5 problems then decided in 8 steps total; both
false controls correctly refused.

**The type does work, and this is the point.** The two theories are
anti-isomorphic, not isomorphic. Declared as a plain isomorphism the map is
**rejected**, on the axiom $x\cdot y=y$, which translates to itself and is
not a theorem of the target. That rejection matters because the mistyped
map is the *identity on terms*: had the kernel accepted it, every right-zero
problem would have been answered by asking the left-zero theory a different
question, and `a*b = b` would have come back false. Conflating two edge
kinds is not a modelling infelicity; it is a wrong answer.

---

## 8. Failed transports, kept — and the typed zero

    स दोषः अपशब्दः न; स एव नूतनगणितस्य बीजम्।
    अवरोधः अदृश्यमानस्य मानचित्रम्।

`python3 machinery/crystal/demo_obstruction.py`

§7's checker *rejects* a bad interpretation and discards it. That is the
discipline violation: the machine was accumulating only successful
relations. But the residual of a failed transport is a **presented theory
extension** — exactly the equations the target would have to satisfy for the
map to have worked — and asking whether that extension is consistent is a
real question with real answers.

Given φ: S → T failing on some axioms, put
$\mathrm{Obs}(\varphi)=\{\varphi(l)=\varphi(r)\}$ over the failing axioms and
complete $T\cup\mathrm{Obs}(\varphi)$:

| verdict | what it means | measured |
|---|---|---|
| **FATAL** | the extension derives a bare variable equal to something not containing it, so every element collapses | right-zero → left-zero: witness `?x = ?y`, 3 steps |
| **EXTENDS** | completes without collapse; φ *is* an interpretation into a larger theory, and the machine names the missing rules | monoid → pointed semigroup: the two unit rules, 10 steps |

**Case 1's verdict is a theorem nobody supplied**: a semigroup that is both
left-zero and right-zero satisfies $x = xy = y$, so it has exactly one
element. The failed transport computed the exact reason two theories cannot
be glued, and the reason is a fact about semigroups.

### The typed zero

The remaining verdicts are where the sūtra corrected a defect I had already
detected and not understood:

> शून्यं स्थानं रक्षति … एतानि एकेन null मध्ये न निक्षिपेत्।
> शून्यं पश्यन् यन्त्रं अधिकं सत्यं पश्यति।

The first version had a single `UNDECIDED`. Mutation testing found it before
I knew why: **the mutant deleting the budget check survived**, because a
budget failure and a representation failure were the same value. They are
not the same fact, and they license *opposite* next actions:

| verdict | Sanskrit | licensed next action |
|---|---|---|
| `UNORIENTABLE` | वर्तमानrepresentationेन अदृश्यम् | change the **order** — ordered/unfailing completion, or modulo AC. More budget is *certain* waste. |
| `EXHAUSTED` | गणनासाधनातीतम् | spend more. Says nothing about whether an answer exists; growth is reported as a *diagnosis*, and divergence is **not claimed**, being undecidable. |
| `OUT_OF_SCOPE` | अधिकारात् बहिः | fix the **map**. There is no mathematics here at all. |

`OUT_OF_SCOPE` caught a live bug rather than a hypothetical one.
`Interpretation.apply` silently carries an unmapped symbol through, so the
"image" lands in a signature the target never had and checking it is
*meaningless* rather than false. The first thing the new check did was
reclassify my own §7 example: monoid → semigroup is `OUT_OF_SCOPE`, because
`e` is in the source signature and not the target's. The old `EXTENDS`
verdict was the sloppy one. The honest version declares the target as
*pointed* semigroups — signature $\{*,e\}$, axioms $\{\text{assoc}\}$ — and
then `EXTENDS` is exact. Jurisdiction is now **declared, not inferred**,
because inferring a signature from the axioms is a guess that fails for
every theory with an unconstrained symbol.

### Verification

46 tests. Mutation-tested: 14 injected defects, **13 die**. The survivor is
`a.head not in variables(b)` in the collapse detector, and it is reported
rather than papered over: under LPO the complementary case is *unreachable*,
since a variable occurring on both sides makes the equation orientable by
the subterm property, so it never reaches the unorientable residue. The
guard is kept because that is a property of the **order**, not of this
logic — swap in a non-simplification order and it goes live. An earlier
round had two survivors; the second turned out to be genuine dead code (a
`?x = ?y` branch wholly subsumed by the occurs branch) and was deleted
rather than given a test that could not distinguish it.

A test also caught a contamination bug: re-classifying a record under a
smaller budget left `derived_rules` from the previous run, so it could
report `EXHAUSTED` while carrying an extension. A verdict contaminated by a
previous run is a lie told with true data; `classify` now clears every field
it can set.

---

## 9. The cycle: a residual generates the next attempt

`python3 machinery/crystal/demo_chakravala.py`

§8 records why a transport failed and stops. That leaves the useful half on
the table: a verdict does not merely *describe* a failure, it *determines*
the next move. Bhaskara II's cyclic method for Pell's equation is the model
— a near-solution's error is exactly what selects the next intermediate —
and Kepler is the same discipline in a life: eight arcminutes of residual in
Mars's orbit, kept rather than rounded away because Tycho's data was better
than the error, and the ellipse came out of the leftover.

Each verdict selects its own successor, and only one of the five is
"spend more":

| verdict | move |
|---|---|
| `FATAL` | **terminal.** The impossibility is the result; proposing a successor would be a category error. |
| `EXTENDS` | adopt T ∪ Obs as the target and re-run — the failure named the theory the map actually goes into |
| `OUT_OF_SCOPE` | widen the declared signature by the unmapped symbols and re-run |
| `UNORIENTABLE` | re-orient. If **no** precedence on the signature orients the residual — checked exhaustively over all permutations — that is a result: beyond LPO, requirement named (completion modulo AC), not attempted |
| `EXHAUSTED` | and only here, spend more |

Measured, three pursuits:

- **monoid → semigroup: SUCCEEDED in 3 steps.** Two *different* failures in
  sequence. Step 1: the **map** was incomplete → widen the signature by
  `e`. Step 2: the **theory** was too small → adopt the two unit rules.
  Step 3: checks. A single `UNDECIDED` could not have produced either move;
  it would have doubled the budget twice and given up with nothing.
- **right-zero → left-zero: IMPOSSIBLE in 1 step**, yielding `?x = ?y`. The
  one place where *not* continuing is the correct move.
- **commutative → semigroup: BEYOND_LPO in 1 step.** Commutativity is
  symmetric in both argument positions, so no precedence orients it —
  verified over every permutation rather than assumed.

**Termination.** Each move strictly decreases a component of a lexicographic
measure — unmapped symbols, unadopted residuals, untried precedences,
remaining doublings — and none increases an earlier component, so the
pursuit cannot cycle. A self-directing loop that can spin is worse than one
that stops.

Building this immediately caught a bug of the same class as §8's stale
fields: `pursue` re-classified an already-classified obstruction, and since
`OUT_OF_SCOPE` is decided *before* the mathematics, the second `classify()`
silently overwrote it with a meaningless `EXTENDS` — producing an infinite
run of "adopt 0 residual equations". The budget is now passed *in* rather
than applied by re-classification. Contamination by re-execution is
apparently this design's characteristic failure, and it is worth naming as
such: it has now appeared twice in different clothing.

53 tests.

### How the §7 test got here, since the first version was wrong

The obvious example was groups: compile the left-axiom presentation,
transport the right-axiom one. The kernel accepted the *mistyped* identity
map. That looked like a bug for about a minute and was not. **Group theory
is self-dual** — the completed left theory proves right identity and right
inverse outright, so the identity map genuinely is a valid interpretation
and the anti-isomorphism is not needed. The example could not demonstrate
what it claimed, because there was nothing there to demonstrate.
Demonstrating that the type matters requires a theory that is not
self-dual, hence the zero semigroups.

Worth recording as a fact about this kind of work: the failure was in the
test's mathematics, not the code, and the kernel is what caught it. That is
the argument for having a kernel at all. It is also the pattern the corpus
keeps hitting from the other side — `notes/E2_PROOF.md` found two errors in
`METHOD.md`'s Proposition M1 whose own numerical check had passed, because
the check verified a finite-$Q$ quantity while the error was in the
identification of its limit. A check that cannot fail is not a check.
`test_crystal.py::test_group_theory_is_self_dual_so_both_maps_check` now
pins the corrected understanding so it cannot be re-broken.
