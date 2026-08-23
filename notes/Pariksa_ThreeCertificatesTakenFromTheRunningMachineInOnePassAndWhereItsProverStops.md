# परीक्षा — three certificates taken from the running machine in one pass, and where its prover stops

**Term.** *parīkṣā*, critical examination of a thesis — standard technical
usage in the Nyāya tradition (Vātsyāyana's *Nyāyabhāṣya* on the
*Nyāyasūtra*), and already the corpus's own word for this: `saksiPariksa` in
`machine/Uttara_...hs`, `machine/check-yantra-pariksa.sh`. Nothing here is
attributed to that tradition beyond the word.

**How these were obtained.** By asking the warm machine through नाडी, in one
sitting, across three unrelated axes. Every number below is a finite
exhaustive check against the running organs, not a sample and not a
reimplementation — the organ answered, and the answer was verified against
arithmetic done outside it.

---

## 1. चक्रवाल — the intermediate norms stay under √D, and the bound is sharp

`vargaprakrti` returns not only the fundamental solution of x² − Dy² = 1 but
its **spectrum**: the norm n at every intermediate step of the cakravāla
descent. That field had never been checked against anything.

**Checked: every non-square D from 2 to 200.** For each, the maximum |n| over
all intermediate steps *after the seed*:

> **Zero violations of |n| ≤ ⌊√D⌋.** 186 values of D, every step of every
> descent.

**Prior art, stated first.** That cakravāla keeps its intermediate norms small
is classical — it is the statement that the method stays among reduced forms,
and the comparison against continued-fraction and ideal-theoretic methods is
Selenius (1975). **The bound is not this note's.** What is this note's is the
exhaustive verification of *this implementation* against it, which had not
been done, and the sharpness data below.

**The bound is attained**, i.e. max |n| = ⌊√D⌋ exactly, at

    3, 7, 13, 21, 29, 46, 53, 57, 58, 73, 76, 85, 91, 94, 97,
    111, 125, 133, 137, 157, 173, 183, 191

— 23 of the 186. So the bound is sharp and not slack. **No pattern is
claimed for that set.** An earlier guess (n²+n+1, fitting 3, 7, 13, 21) died
at 31 on the very next term, which is exactly why `CLAUDE.md` says to
generate the next term rather than to phrase the conjecture more carefully.
The set is recorded as data.

Two spot readings, for anyone who wants them: D = 61 descends through
−12, 3, −4, −5, 5, 4, −3, −1 to (1766319049, 226153980), and the only norm
exceeding √61 ≈ 7.81 is the **seed**, which the cakravāla step did not
produce. D = 991 descends through 23 norms, max 30, to a 30-digit solution.

## 2. कुट्टक — the pulveriser's Bézout output, certified

`kuttaka a b` returns the vallī (the quotient chain) and a pair (x, y) with
a·x + b·y = gcd. **84 identities checked** across small, Fibonacci-adjacent,
and large coprime inputs — including 999983 and 1000003, both prime —
recomputing a·x + b·y and gcd(a,b) independently of the organ.

> **84 checked, 0 mismatches.** Every returned pair satisfies the identity and
> every returned gcd is the true gcd.

## 3. साधन — where the prover stops, and it is a clean line

`sadhana` is the Certificate-gated prover: it proposes shapes to the kernel
and reports what the kernel accepted. Four propositions, all in its declared
fragment:

| proposition | verdict |
|---|---|
| (x + y) + z ≡ x + (y + z) | **syād-asti** — proved, 4 agda calls, step = `cong suc` |
| x + y ≡ y + x | syān-nāsti — the kernel rejected every shape tried |
| x·(y + z) ≡ x·y + x·z | syān-nāsti |
| x·y ≡ y·x | syān-nāsti |

**The line is structural, not a matter of strength.** Associativity of `+`
closes by induction whose step is a *single* `cong suc`. Commutativity of `+`
does not: it needs `+-zero` and `+-suc` proved first, and only then does the
induction close. Distributivity needs associativity and commutativity both.

> **`sadhana` decides exactly the goals whose inductive step is one
> congruence, and stops exactly where an auxiliary lemma is required.**

The failures are honest: *syān-nāsti* here means "the kernel rejected every
shape tried", a refusal carrying its reason, not an unproved claim dressed as
a falsehood.

### §3 is a rediscovery, and the prior work is sharper. Struck as a finding.

**This was written before searching the corpus, which is the error
`CLAUDE.md` names.** `machine/SesaPariksa_WhichOfTheSixOutstandingDemands
InductionReaches.hs` already asks this question and answers it at higher
resolution, splitting what §3 reports as one boundary into **three**:

  (a) the emitter can already reach it and **was never asked** — `certifyWith`
      read the induction variable off the caller's note and refused after one
      `refl` module when there was none. Asking each variable in turn reaches
      three of six, including `x ≡ x + (0 · x)`, a residual the engine had
      circled for 239 rounds. That fallback is now in the shipped emitter.
  (b) the proof lives inside the fragment but the **shape menu cannot spell
      it** — a limitation of the proof term language, priced by the diff.
  (c) the statement **needs a stronger principle** — course-of-values
      induction, a generalised hypothesis, nested induction, a side condition.

`notes/SamasaBhavana_...` §9 carries the counts behind it: 119,489 true
equations produced, 3 already known, 1 reached by the identification hand, 5
out of reach of any composition law. What §3 above calls "one congruence or a
lemma" is (b) and (c) run together — the collapse `SesaPariksa`'s header
explicitly names as the thing not to do.

### The Agsy question, asked and answered the wrong way round

Agda ships **Agsy** (`Cmd_autoOne`), and नाडी does not expose it. That looked
like an oversight and a one-line fix, and a verb was written for it.

**It is not an oversight, and "discipline" is the wrong word for it too.**
The verb was written, then reverted, and the first version of this section
said the corpus FORGOES Agsy out of principle.  That is backwards.  Agsy is
bounded-depth term search over what is in scope.  What is actually installed
here is larger by orders of magnitude and by kind:

- `MathMachine` enumerates and filters — 25k terms, then 396k, to fixpoint.
- `PaksaLaksana` composes **119,489 true equations** and partitions them by
  the JOINT POSITION OF TWO REWRITERS — the machine's M and Agda's
  definitional unfolding K, read as a case tree — into four cells.  One cell,
  (M no, K yes), is **8,130 free acceptances**: certain before agda is
  called, one kernel call each, and outside the machine's present reach.
  `PaksaKrama` then ORDERS them by how much each, installed as an M-rule,
  enlarges what M can close.
- `Sanghatta` adds the second conjecture source enumeration cannot reach:
  Knuth–Bendix superposition of the installed rules on each other, every
  non-joining critical pair a theorem the rewriter needs.
- `Nalanda` turns the checked classical modules instead of shelving them.

A local term search is not a smaller version of that; it is a different and
weaker instrument.  And §2 below is not a restriction the engine accepts in
place of power — it is what keeps the 8,130 count MEANING anything.*
`machine/CERTIFICATE_REACH.md` §2 forbids exactly this move by name:

> "If the emitted module may cite `+-comm`, then the engine's celebrated line
> … is certified by the library already knowing it. The statement would be
> true and the certificate honest, but the engine's contribution collapses
> from *proof* to *discovery*, and nothing in the log would say so."

Agsy searches everything in scope, which includes
`Cubical.Data.Nat.Properties`. An agent typing `auto` at the `+-comm` hole
would be handed the library's own theorem and would report a proof. That is
the forbidden repair with the import line removed — **worse than the version
the document rules out, because there is no longer anything to see.**

So the absence is load-bearing, and the corpus's own search apparatus is the
principled alternative, already built: `Tapas_...` (proof shapes as templates,
every non-match a written refusal), `Prastara_...` (search spaces addressed by
index, never stored), `MargaRaksana_...` (the path kept, not searched again —
which is also the "cache the lemmas" idea, already done and named for the
vallī). Anyone who has the Agsy idea should read §2 first; it is stated there
better than here.

---

## Rigor boundary

- **Exhaustive, exact**: §1 over all non-square D ≤ 200; §2 over the 84 stated
  input pairs. Both verified with arithmetic computed outside the organ under
  test. These are certificates, not measurements.
- **Cited, not proved here**: the classical boundedness of cakravāla's
  intermediate norms (Selenius 1975 for the analysis of the method).
- **Data, not a claim**: the attained set in §1. No pattern is asserted, and
  the one that suggested itself was refuted by its own next term.
- **STRUCK as a finding, kept as a record**: §3.  It was written before the
  corpus was searched and it rediscovers `machine/SesaPariksa_...hs` and
  `notes/SamasaBhavana_...` §9 at lower resolution, collapsing their (b) and
  (c) into one line.  It is left standing with the correction attached rather
  than deleted, because striking a claim silently is how this repository
  loses its own history.
- **The one addition from this pass**: why Agsy is not on the नाडी wire.  The
  verb was written, then reverted, because `machine/CERTIFICATE_REACH.md` §2
  forbids the move it makes.  That reasoning had not been written down where
  someone reaching for `Cmd_autoOne` would find it, and now it is.
