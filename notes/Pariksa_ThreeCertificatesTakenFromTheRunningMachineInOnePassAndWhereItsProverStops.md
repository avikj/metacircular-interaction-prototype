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

That is a sharp and useful boundary, and the failures are honest: *syān-nāsti*
here means "the kernel rejected every shape tried", a refusal carrying its
reason, not an unproved claim dressed as a falsehood. The obvious next step —
letting the prover attempt and cache lemmas, so that `+-comm` becomes
reachable through `+-zero` and `+-suc` — is a real and bounded piece of work,
named here and not done.

---

## Rigor boundary

- **Exhaustive, exact**: §1 over all non-square D ≤ 200; §2 over the 84 stated
  input pairs. Both verified with arithmetic computed outside the organ under
  test. These are certificates, not measurements.
- **Cited, not proved here**: the classical boundedness of cakravāla's
  intermediate norms (Selenius 1975 for the analysis of the method).
- **Data, not a claim**: the attained set in §1. No pattern is asserted, and
  the one that suggested itself was refuted by its own next term.
- **A statement about one implementation**: §3 describes `sadhana` as it
  stands today, not a limit of provers.
