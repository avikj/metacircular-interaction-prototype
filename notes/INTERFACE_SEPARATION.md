# W3: the interface separation is two theorems with opposite answers, and the program picked the trivial one

**Author:** TURING seat, 2026-08-14.
**Assignment:** `TARGET.md` §2 **W3** = `notes/BARRIER.md` §2's closing demand —
"a proof that no WL post-processing $\Phi$ can simulate that interface — i.e., a
separation, not just a classification."

**Status.** One machine-checked module,
`formal/cubical/NaturalMachine/InterfaceSeparation.agda` (Agda 2.6.3, cubical
v0.5, `--cubical --guardedness --safe --no-import-sorts`, **exit 0**, zero
warnings, no postulates, no holes). Everything below is proved on paper and the
load-bearing statements are also checked terms; the Agda name is given in
`typewriter` after each. No measurement, no floating point, no fitted constant,
no Python.

**Grades used:** PROVED / REFUTED / CITED / OPEN.

---

## 0. The verdict, first

> **W3 is not one question.** It is two, with opposite answers, and which one is
> being asked is fixed by a modelling choice `BARRIER.md` makes silently: *what
> is the hypothesis class the oracle is hiding an object from?*
>
> - **Promised class** (the hidden object is a completely multiplicative $\pm1$
>   function — i.e. what $\lambda$ actually is): **W3 is FALSE.** REFUTED.
>   Functional-equation access is exactly simulated by post-processing of value
>   queries, and the simulator is constructed, total, and computes. This holds
>   for the *unbudgeted* oracle: every FE instance answered at once, arbitrary
>   non-computable post-processing allowed on the other side.
> - **Unpromised class** (the hidden object is an arbitrary $\pm1$ sequence —
>   which is what `BARRIER.md`'s own phrase "treats $a$ as a black-box sequence"
>   says verbatim): **W3 is TRUE.** PROVED, at the smallest nontrivial scale, by
>   an explicitly constructed separating pair.
>
> **The content of the functional-equation interface is exactly the promise.**
> It is nonconstant on sequences and constant on multiplicative ones
> (`fe-content-is-the-promise`). So a separation theorem built on it separates
> *hypotheses*, not *channels*, and the thing it proves — that verifying
> multiplicativity requires reading the product point — is a statement in the
> Blum–Luby–Rubinfeld orbit, not a statement about entropy decrement.

And the positive theorem that survives the refutation, which is the part the
barrier program should actually keep:

> **Theorem C (the barrier extends across the interface).** Let $Q$ be a
> parity-neutral value-query set (every argument of even $\Omega$). Then every
> number derivable from $Q$ by the functional equation is again of even
> $\Omega$, so the FE-closure of $Q$ admits no separator whatsoever. **Granting
> a method the functional equation as a free rewriting rule does not enlarge the
> class of parity questions it can answer.** PROVED,
> `target-even` / `fe-closure-cannot-separate`.

Refuting the separation *strengthens* the barrier: the FE interface is inside
WL's post-processing, therefore the parity no-go that applies to WL applies
verbatim to FE-augmented WL.

---

## 1. The oracle model, stated as choices

A model chosen so the theorem is easy is worth nothing, so the choices are
listed and the attackable one is named in §6.

**(M1) The hidden object.** A number is its multiset of prime factors, so the
factorization monoid is the free commutative monoid on the primes and
multiplication is concatenation. `ParitySeparator` already fixes this
(`Number = List ℕ`, $\Omega = \mathrm{length}$), and I inherit it rather than
re-choose it.

- *Promised class* $\mathcal M = \{\pm1\}^{\mathcal P}$: a sign assignment
  $\sigma$ on the primes, evaluated multiplicatively (`Signs`, `val`).
- *Unpromised class* $\mathcal S = \{\pm1\}^{\mathbb N}$: an arbitrary sequence
  (`Seq`), no relation between arguments.

**(M2) An interface** on a hidden object of type $O$ is a map $O \to A$: the
entire transcript it produces. Not a query budget, not a protocol — the
transcript, all of it. This is deliberately the *weakest* notion of interface,
because a separation proved against it is strongest.

**(M3) Post-processing** is any function $A \to B$. No computability, no
continuity, no measurability. This is `BARRIER.md` Proposition B3's "arbitrary
— even non-computable — $\Phi$" taken literally.

**(M4) Simulation.** $I$ **simulates** $J$ iff there is $f$ with
$f \circ I = J$ pointwise (`Simulates`).

**Lemma 1 (what simulation is).** Under (M3), $I$ simulates $J$ iff the
partition of $O$ induced by $I$ refines the one induced by $J$; hence the only
way to refute simulation is to exhibit a **collision** of $I$ that $J$ splits.
PROVED in the direction used, `collision⇒no-simulation`.

*Remark on the converse.* The "iff" is classical (choose one representative per
$I$-fibre); constructively only the refutation direction is free, and every
positive claim below is discharged by **constructing** $f$, never by invoking
the converse. This is not a weakening — an explicit simulator is a stronger
result than an existence proof.

**(M5) The two interfaces.**

- **Value interface** $V_Q$ for a finite query list $Q$: $\;a \mapsto
  (a(n))_{n\in Q}$ (`obs`, `obsS`).
- **Functional-equation interface**, in the two readings the phrase carries:
  - *check*: $\;a \mapsto \bigl(a(mn)\,a(m)\,a(n)\bigr)_{(m,n)}$, the **defect**
    of the identity (`defect`). This is `BARRIER.md`'s "$a(np)=a(n)a(p)$ used as
    a constraint, not a value".
  - *rewrite*: derive $a(mn)$ from $a(m)$ and $a(n)$ — the operation that moves
    information from a scale to a dilate of that scale, which is what entropy
    decrement does and what a window $[1,X]$ cannot do, since an interval is not
    closed under multiplication. Formalised as a syntax `Deriv` of derivations
    (a query already asked, the empty product, the product of two derivations)
    with `target` naming the number derived.

Both readings are formalised and both are decided. Deciding only the *check*
reading would be cheating, and is the trap this note exists to avoid.

---

## 2. The promised model: W3 is false, twice over

### 2.1 The check reading carries zero bits

**Theorem A.** For every $\sigma$ and every $m,n$, the defect
$\mathrm{val}_\sigma(mn)\cdot\mathrm{val}_\sigma(m)\cdot\mathrm{val}_\sigma(n)
= +1$. Hence the **full** FE oracle — every instance answered simultaneously —
is simulated by the *empty* transcript. PROVED,
`fe-promised-constant` / `fe-simulated-by-nothing` / `fe-oracle-simulated-by-nothing`.

*Proof.* $\mathrm{val}_\sigma$ is a monoid homomorphism from the free
commutative monoid to $\{\pm1\}$ (`val-++`, induction on the multiset), and
$\{\pm1\}$ has exponent two. $\square$

This half is trivial and is stated because it is the half a reader of
`BARRIER.md` §2 will assume away: a constraint that always holds is not an
access.

### 2.2 The rewrite reading is post-processing — the substantive half

**Theorem B (the compiler).** For every query list $Q$ and every derivation $d$
there is an explicit post-processing $\mathrm{post}(d)$ of the value transcript
with
$$\mathrm{post}(d)\bigl(V_Q(\sigma)\bigr) \;=\; \mathrm{val}_\sigma\bigl(\mathrm{target}_Q(d)\bigr)
\qquad\text{for every }\sigma .$$
Hence the whole FE-rewriting oracle, answering every derivation at once, is a
single post-processing of $V_Q$. PROVED, `compile` / `derived-simulated` /
`derived-oracle-simulated`.

*Proof.* Structural recursion on the derivation, with `val-++` at the `mul`
node. $\square$

**Division is not a further objection.** In $\{\pm1\}$, recovering $a(n)$ from
$a(mn)$ and $a(m)$ *is* multiplication: $\mathrm{val}_\sigma(m\,mn) =
\mathrm{val}_\sigma(n)$ (`cancel`). So the calculus is closed under the inverse
operation without adding a constructor.

### 2.3 The reason, in one line of $\mathbb F_2$

The Agda is the checked instance of this, and this is the sentence to quote.

Write $\sigma(p) = (-1)^{x_p}$, so the object is $x\in\mathbb F_2^{\mathcal P}$,
and let $e(n)\in\mathbb F_2^{(\mathcal P)}$ be the exponent vector of $n$ mod 2.
Then

$$\mathrm{val}_\sigma(n) = (-1)^{\langle e(n),\,x\rangle}.$$

**Proposition D.** (i) A value query is exactly an $\mathbb F_2$-linear
functional on the object. (ii) $e(mn) = e(m)+e(n)$, so the multiplicative
closure of a query set does **not** enlarge the $\mathbb F_2$-span of its query
vectors. (iii) Therefore $V_Q$ and $V_{\langle Q\rangle}$ (closure under
multiplication *and* division) induce the *same partition* of $\mathcal M$, and
each simulates the other. PROVED; (ii) is one line and (iii) is Theorem B.

**Corollary E (the "window" is a red herring in the multiplicative world).** For
a completely multiplicative object no notion of window defined by an interval of
arguments is an information-theoretic invariant. The invariant is the
$\mathbb F_2$-span of $\{e(n): n\in Q\}$, and that span is already closed under
multiplication and division. In particular a value oracle reading only the
primes $p\le X$ determines $a$ on **every** $X$-smooth number, however large.

Corollary E is what actually kills W3 in the promised model. The intuition
behind W3 — "FE access escapes the window $[1,X]$, value access cannot" — is
correct about intervals and false about information, because for a multiplicative
object the interval was never the boundary.

---

## 3. The unpromised model: W3 is true, and the pair is constructed

Drop the promise and the defect becomes one honest bit.

**Theorem F.** Let $Q$ be *any* finite value-query set, of any size, none of
whose arguments has exactly two prime factors. Then **no** post-processing of
$V_Q$ — computable or not — determines the single FE bit at $(p_0,p_1)$ for two
distinct primes. PROVED, `value-cannot-simulate-fe`; instantiated at the
smallest nontrivial scale $Q=\{p_0,p_1\}$ as `smallest-separation`.

*Proof.* Construct the collision. $a_0 \equiv +1$; $a_1(n) = +1$ unless
$\Omega(n)=2$, where $a_1(n) = -1$. They agree on every argument with
$\Omega \ne 2$, hence on all of $Q$ (`unpromised-agree`); their defects at
$(p_0,p_1)$ are $+1$ and $-1$ (`defect-a₀`, `defect-a₁`); apply Lemma 1.
$\square$

This is `TARGET.md` §3's freedom cashed: the object space is free, so the
separating pair is *built*, not hunted for.

**Theorem G (the exact converse — the obstruction is support, not power).**
Three value queries, at $mn$, at $m$ and at $n$, simulate the FE query at
$(m,n)$ exactly, with the post-processing being the same product. PROVED,
`fe-simulated-when-product-queried`.

So in the unpromised model the two interfaces are **not** separated by strength.
They are separated by *which arguments they touch* — the same verdict
`ChargeCriterion` reached from the other side ("about the QUERY SET and not the
post-processing"), reached here against a different adversary. That agreement is
independent replication of a structural claim, not a coincidence, and it is the
one place my lane touches the Noether seat's `TARGET.md` §6 item 2; I do not
develop it further, it is theirs.

**Theorem F is a fact in the Blum–Luby–Rubinfeld orbit.** The FE query is
literally the BLR linearity-test triple $(x,y,x+y)$ for the homomorphism
$\{\pm1\}$-valued on the free commutative monoid, and "you must read the product
point" is the elementary content of that test's query pattern. CITED from search
metadata only (see §5); I read no full text. Claiming Theorem F as new would be
a rediscovery of exactly the kind the README's receipts list records.

---

## 4. What this does to the target, said plainly

### 4.1 The strategic claim in `TARGET.md` §3 is right for W1/W2 and wrong for W3

`TARGET.md` §3 argues that the zeta-side obstruction ("you must exhibit two
admissible configurations, and the zeros of $\zeta$ cannot be moved") does not
apply on the parity side, because $\{\pm1\}^{\mathcal P}$ is free. **That is
correct for W1 and W2 and does not transfer to W3**, and the difference is
structural, not a matter of effort:

- W1/W2 **quantify over the object**. The hypothesis class *is* the free space;
  the two objects $\sigma$ and $\sigma'$ are both legitimate arithmetic objects;
  the diagonalisation is available. Both are proved.
- W3 asks about a fixed object ($\lambda$) probed through two interfaces. To
  make that an oracle separation you must re-introduce a hypothesis class, and
  there are exactly two natural ones. At the promised endpoint the FE channel
  is null (§2). At the unpromised endpoint the class contains objects that are
  not arithmetic at all, so what you prove is a testing statement (§3).

**Neither endpoint gives the theorem W3 was assigned.** The freedom
`TARGET.md` §3 identifies is real for the observer-class separations and
illusory for the interface separation. REFUTED (the strategic claim, not the
mathematics of §4/§4b, which stands).

### 4.2 Why an oracle separation cannot be the right shape here at all

The deeper reason, and the one a successor should carry: over a **fixed**
arithmetic object there is no information-theoretic mystery. $\lambda$ is
determined by countably many bits; any oracle that reads all the primes has all
of it. The parity barrier is not a statement that a method *lacks information*
— it is a statement that a method *of a given form* cannot convert information
it already has into a conclusion. That is why the natural-proofs analogy
`BARRIER.md` draws is to **circuit classes** and not to oracles: natural proofs
restricts the form of the computation, not the access.

So the honest reading of the outcome: `BARRIER.md` §2's sentence "entropy
decrement $\notin$ WL, *by the interface it consumes*" is **true and cannot be
upgraded to an oracle theorem**. The upgrade it asks for is not available,
because in the promised model there is nothing to separate, and my Theorem B is
what makes that precise rather than a matter of taste.

### 4.3 What replaces W3

- **Keep Theorem C.** "FE-augmented WL is still parity-blind on neutral read
  sets" is a real strengthening of the barrier and is checked.
- **The remaining live question is quantitative**, i.e. `TARGET.md`'s **W4**:
  not *which channel* a method consumes but *how much* archimedean/bilinear
  input at what depth buys how much parity information. W3's failure is
  evidence for promoting W4, not against the target as a whole.
- Anyone still wanting an interface theorem must work at an **intermediate
  hypothesis class** (§6), which is open.

---

## 5. Prior art: what I searched, in what vocabulary, and what not to repeat

Searched **before** writing, per PROTOCOL §0. Corpus first
(`grep` on "oracle separation", "value quer", "functional.equation quer",
"interface separation", "Problem 1", and on the section numbers per
`TARGET.md` §5), then `WebSearch`. `WebFetch` is egress-blocked; **everything
below is graded from search metadata and I read no full text.**

- **No oracle-model or observable-class formalization of the parity barrier
  exists.** Confirmed against `TARGET.md`'s own audit and by search; Tao's 2007
  open-question post and his 2014 "A general parity problem obstruction" are the
  semi-formal statements. CITED (metadata only).
- **Blum–Luby–Rubinfeld (1993), linearity/homomorphism testing.** The FE query
  is the BLR triple; the 3-query pattern $x$, $y$, $x{+}y$ is standard, as is
  the Ben-Or–Coppersmith–Luby–Rubinfeld extension to arbitrary finite groups.
  **This is the right home for my Theorem F and a successor should cite it there
  rather than re-derive it.** CITED (metadata only).
- **Bombieri (1976), Friedlander–Iwaniec (1998)** — the parity obstruction and
  the axiom that breaks it. Already cited by `BARRIER.md`; unchanged by this
  note. CITED.
- **Not found, do not repeat:** a query-complexity treatment of learning a
  completely multiplicative function from value queries, in the vocabulary
  "completely multiplicative / GF(2) linear queries / exponent vector mod 2".
  Searched; nothing. Proposition D is elementary enough that it is very likely
  folklore in the testing literature under different words, and I flag it as
  such rather than claim it.

In the corpus: nothing duplicated. The nearest neighbours are
`NaturalMachine/FlipObservable.agda` (grammar-blindness by structural induction
over a syntax — Theorem C is the same shape, against a different grammar, and I
took the shape from there) and `NaturalMachine/ObservabilityQuotient.agda`
(observational equivalence as the safe quotient — Lemma 1 is its static case).

---

## 6. Honesty ledger, and the step to attack

**What I deliberately did NOT claim.**

- Not that entropy decrement is or is not stronger than WL *as an argument*.
  I decided the **interface** question and nothing else; the strength of Tao's
  theorem is untouched.
- Not that Theorem F is new (§5).
- Not that "even $\Omega$" is the exact neutral sector of every sieve — that
  disclaimer is `ParitySeparator`'s and it is inherited verbatim.
- Not that the module belongs to the analytic lane: nothing here bounds any
  arithmetic sum, and no statement about $\zeta$, $\lambda$'s correlations, or
  log-Chowla follows from it.
- No claim about **W4**, which is untouched and now looks like the target.

**MY LEAST-SURE STEP, stated so it can be attacked.** The dichotomy is proved at
the **two endpoints** of a lattice of hypothesis classes:
$$\mathcal M \;=\; \{\text{completely multiplicative}\}
\;\subsetneq\;\cdots\;\subsetneq\;
\mathcal S \;=\; \{\text{all }\pm1\text{ sequences}\}.$$
**The interior is open, and `BARRIER.md`'s own residue-dressing family lives in
the interior.** WL is not defined over $\mathcal S$ in practice — it is applied
to dressings $a$ that are neither arbitrary nor completely multiplicative. On
such a class the FE defect is neither constant (so §2 does not apply) nor free
(so §3's construction may leave the class), and my dichotomy decides nothing.

That is the hostile reader's move, and it is the right one: **"your two models
are the two you could decide, and the arithmetically relevant class is between
them."** I accept the criticism in advance; what I claim is that the endpoints
bracket the answer and that any interior theorem must explain why the FE defect
is *neither* an identity *nor* free on its class — which is a sharper obligation
than W3 as posed, and the next PROVE item in this lane.

Secondary attackable choice: (M2) makes an interface a total transcript with no
budget. That was chosen to make the refutation in §2 as strong as possible (an
unbudgeted FE oracle is still simulated) and the separation in §3 as strong as
possible (an unbudgeted value oracle still fails). A reader who wants a
*query-complexity* separation instead will find §3 + Theorem G already give it:
the gap is exactly $0$ vs $3$ queries, i.e. a constant, so there is no
complexity separation to be had either.

---

## 7. Pointer for the integrator

`formal/cubical/NaturalMachine/InterfaceSeparation.agda` is checked standalone
(exit 0) and imports only `ParitySeparator` and `ChargeCriterion`. It is
currently an **orphan** with respect to the root aggregate: I did not edit
`formal/cubical/NaturalMachine.agda`, which is the integrator's file. It belongs
in the root next to the two modules it extends, and per `BUILD.md` the green
claim does not cover it until it is imported there.
