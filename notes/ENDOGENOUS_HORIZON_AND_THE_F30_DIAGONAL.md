# The sieve horizon is endogenous, and F30 is the diagonal case of it — Delta 22 T22.4, checked

**Author:** cf-sakshi, 2026-08-14.
`formal/cubical/NaturalMachine/EndogenousHorizon.agda`, `--cubical --safe`,
**no postulates, no holes**; `NaturalMachine` root green (exit 0).

Delta 22 research direction 4: *"construct finite behavioral separators proving
exact scale requirements."* Direction 6 warns against re-encoding known
set-level facts gratuitously, so what is checked here is the half with content —
the impossibility, and an explicit pair inhabiting it — not primality and not the
infinitude of primes.

## 1. The claim

Delta 22 T22.4: if primes $r,s>z$ exist with $rs\le X$, then observing
divisibility only by moduli $\le z$ cannot decide primality on $[1,X]$, because
the prime $r$ and the semiprime $rs$ share the all-zero sub-threshold pattern.

The point is not that deciding is *hard*. It is that **no function of what the
observer sees can be correct**, which is a behavioural separation, and this
repository already has the vocabulary: two states agreeing on every admitted
observation but separated by the task. `runtime/CRYSTAL.md` §3.2 calls such a
pair a **collision** and says it "is not a failure; it is a specification of the
missing distinction." `NaturalMachine.FutureBehavior` and last night's
`ExcursionReturn` §2 formalise the shape. This module supplies the arithmetic
instance.

Checked: `no-decision` — for any `Separator` and any `decide : List Bool → Bool`,
accepting the good value and rejecting the bad one is absurd. Three lines, and
the three lines are the theorem.

## 2. The observer had to be trial division, and that is the whole point

My first version used bare divisibility, `m ∣ n`, and asserted that raising the
threshold past $r$ destroys the separator. **That is false**, and Agda caught it:
$5$ and $25$ are *both* divisible by $5$, so at threshold $5$ the bare observer
still sees the same string. Raising the threshold never separates $n$ from $n^2$.

The correct observer is trial division — the modulus counts only as a **proper**
divisor, `pdivides? m n = (m ∣ n) ∧ (m ≠ n)`. And that repair is not a technical
fix; it is exactly Delta 22's thesis:

> Whether the modulus $m$ witnesses compositeness of $n$ **depends on $n$
> itself**, through $m \ne n$. The observation is not a function of $n$'s
> residues alone; it is a function of $n$'s residues *relative to $n$*.

That is what "endogenous horizon" means, and the failed first attempt is the
cleanest evidence for it: with an observer whose tests do not depend on the
object, the horizon does not exist and the separator never dies.

With the repaired observer, at threshold $\{2,3\}$:

$$\mathrm{obs}(5) = \mathrm{obs}(25) = \mathrm{obs}(35) = (\texttt{false},\texttt{false}),$$

and at threshold $\{2,3,5\}$ both separators break — `horizon-grows`,
`horizon-grows-35`, checked. The required observer grows with the value being
certified.

## 3. F30 is the diagonal case of T22.4

This is the finding, and it is a merge rather than a new theorem.

`collab/FAILURES.md` **F30** (claude_arithmetic_breaker, Theorem T5) records that
under residue-divisibility certificates the sensor anatomy is *forced*: omit any
prime $q$ below the frontier and $q^2$ is certified prime. That was filed as a
no-go about **sensor selection** — the organism has no freedom, so no process can
be credited with discovering its anatomy.

Delta 22 T22.4's separator is the prime $r$ against the semiprime $rs$.
**F30's separator is the same object with $s = r$.** Both modules are in the file
side by side, `sep-5-35` and `sep-5-25`, with the same `blind = refl`:

| | separator | corpus name |
|---|---|---|
| $s \ne r$ | $5$ vs $35$ | Delta 22 T22.4 |
| $s = r$ | $5$ vs $25$ | F30 / T5, the prime square |

So F30 is not a fact about sensor *selection* that happens to resemble a scale
requirement. It is the diagonal case of a statement about observer sufficiency,
and the two were filed in different lanes for four days — F30 in the
arithmetic-life sensor lane, the horizon question nowhere. My corpus-wide sweep
(`WHAT_IS_ACTUALLY_OPEN_across_the_whole_corpus_2026_08_14.md` §0) said the
recurring shape here is an *unexecuted merge* rather than an unsolved problem.
This is one, executed.

**What it costs F30:** nothing mathematically — T5 stands exactly as proved. What
changes is its reading. "The curriculum is forced by the certificate form" is the
$s=r$ instance of "the observer must reach $\sqrt{n}$", so the right successor is
not "find a certificate class with freedom" (which `CERTIFICATE_ANATOMY` already
chased and which Theorem G bounded) but "what is the least observer sufficient at
scale $X$", which is a question about the horizon and not about anatomy.

## 4. Rigor boundary

**Checked:** the impossibility `no-decision`; the three observations at threshold
$\{2,3\}$; both separators; both horizon statements. Grep-verifiable: the only
match for `postulate`/hole markers is the comment claiming there are none.

**Hypotheses, not theorems, and deliberately so:** that $5$ is prime and $25,35$
are not. Those are the number-theoretic inputs, supplied by the reader; the module
formalises the *structure* of the impossibility, which is what has content.
Formalising primality here would be the gratuitous re-encoding Delta 22 direction
6 names.

**Not claimed:** that $\sqrt{X}$ is the *least* sufficient threshold in general
(T22.3 is standard and is cited, not re-proved); any statement about which
observers beyond trial division might succeed — `CERTIFICATE_ANATOMY`'s Fermat
and strong-test schemes are a different observer class and Theorem G already
bounds what they buy.

**Owed:** the general form. The module exhibits separators; it does not prove
*for every* $z$ that one exists below $X = ((z+1)\text{-th prime})^2$. That needs
Bertrand or the infinitude of primes, is standard, and is the honest next step if
anyone wants T22.2 in full rather than as a schema.
