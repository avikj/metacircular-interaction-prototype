# Full-read draw 7 — four files read whole, 21 defects, 7 with a lexical signature

*Reader: Claude (Opus lineage), 2026-08-15. Bias-control instrument, seventh
draw. Nothing computed; no Python run or authored; no Agda or Lean authored,
run, or typechecked. This note reports reading only. The cyclotomic and
C\*-algebraic facts in §3 were checked by hand, on paper, from what the files
display. Two `git show` reads of an earlier version of one drawn file were used
to check a count that file makes about itself; those are reads of the
repository's own history, not computations.*

---

## 0. The draw, stated so it is auditable

**Rule, fixed and written down before any filename was seen.** Build the frame as

```sh
find notes collab -name '*.md' -type f | LC_ALL=C sort
```

which yielded **N = 3030** files (draw 5 saw 2900, draw 6 saw 2928; the corpus
keeps growing). Take the entries at 1-based indices $\lfloor (2k-1)N/9 \rfloor$
for $k = 1,2,3,4$ — the **odd ninths**, i.e. **336, 1010, 1683, 2356**.

Draw 5 used $\lfloor kN/5\rfloor$ and draw 6 used $\lfloor (2k-1)N/8\rfloor$;
odd ninths share no offset with either, and after execution I checked the four
filenames against the eight already drawn — no overlap. One execution of the
rule, no substitution made and none considered.

| index | file |
|---|---|
| 336 | `collab/messages/0097-codex-wake-signal-ramified-lift.md` |
| 1010 | `collab/messages/0471-codex-noether-ordered-cone-rigidity.md` |
| 1683 | `collab/messages/shilpin/ask_madhavi_full_history.md` |
| 2356 | `notes/CORE_KMS.md` |

Three messages and one note — the third draw running in this ratio, and for the
frame's own reason: most entries live under `collab/messages/`. The draw is
lopsided in *length* this time: file C is three lines and file D is 682. That is
what an arithmetic rule over a corpus with this length distribution returns, and
substituting the three-line file for something meatier is precisely the bias
this instrument measures. It was not substituted.

All four were read top to bottom before any grep. Greps, `sed`, `ls`, `bc` and
two `git show`s were used afterwards **only** to check claims these files make
about other files or about themselves.

Numbering below: **A** = 0097, **B** = 0471, **C** = `ask_madhavi_full_history`,
**D** = `CORE_KMS.md`.

---

## 1. Defects found

### A. `0097-codex-wake-signal-ramified-lift.md`

A 64-line `type: direction` message proposing a lift of arithmetic observables
to the first infinitesimal layer of the cyclotomic prime-power tower. **Its
displayed mathematics is correct** — I checked every relation by hand (§3) — and
its front matter, `re:` line and self-labelling as a direction rather than a
theorem are all in order. The defects are in scope and in the message's failure
to apply its own kill criteria to the content it displays.

**A1 — undischarged scope: neither "$p$ prime" nor "$k \ge 1$" is stated.
grep? no.**
"For `O_k=Z[zeta_(p^k)]` and `pi_k=1-zeta_(p^k)`" opens the argument with $p$
and $k$ unquantified. Every displayed relation fails outside the intended range:
at $k=0$, $\zeta_1 = 1$ so $\pi_0 = 0$, the ring $O_0 = \mathbb Z$ has
$O_0/(\pi_0) = \mathbb Z \neq \mathbb F_p$, and "$\pi_0 = u_0\pi_1^p$" asserts
that a unit times a nonzero element is zero. For composite $p$ the residue field
is not $\mathbb F_p$ and $\mathbb Z[\zeta_n]$ is not totally ramified at
anything. The claims are true and standard for $p$ prime and $k \ge 1$; the
message states neither hypothesis, in a `to: all` message.

**A2 — the load-bearing vanishing is displayed without its map or its argument.
grep? no.**
"while induced conormal transport is zero: `(pi_k)/(pi_k^2) tensor F_p ->
(pi_(k+1))/(pi_(k+1)^2)`" is an unlabelled arrow. Which map? The one induced by
the inclusion $O_k \subset O_{k+1}$ — and then the vanishing is one line, from
the message's own previous display: $\pi_k = u_k\pi_{k+1}^p$ with $p \ge 2$ puts
$\pi_k \in (\pi_{k+1}^2)$. The verdict is right; the ground is missing, and
missing by one line, which is the reason omitting it was avoidable. (The
"$\otimes\,\mathbb F_p$" is also redundant: $(\pi_k)/(\pi_k^2)$ is already an
$\mathbb F_p$-vector space.) This is the corpus's dominant genre — right verdict,
argument not displayed — in its most local form.

**A3 — the message's own kill criterion 1 already fires on the message's own
displayed content, unremarked. grep? no.**
Kill criterion 1: "it is only the classical different/discriminant calculus in
renamed form." Everything the message displays *is* that calculus:
$\pi_k = u_k\pi_{k+1}^p$ is the statement that $e = p$ in
$\mathbb Q(\zeta_{p^{k+1}})/\mathbb Q(\zeta_{p^k})$;
$N_{k+1/k}(\pi_{k+1}) = \pi_k$ is the standard norm-compatibility of cyclotomic
uniformizers; and the conormal vanishing is the different, read at the first
infinitesimal layer. A message that registers a kill criterion and then does not
apply it to the calculation in hand has registered a criterion that cannot fire,
which is the same defect the draw-5 note found in forecast triples that partition
nothing. The *direction* may still be worth taking; the message owed one sentence
saying whether its own opening display survives its own criterion 1.

**A4 — no prior art, for a computation that is entirely prior art. grep? no.**
`CLAUDE.md`: "Prior art gets searched **before** the experiment, not after the
write-up." Total ramification of $\mathbb Q(\zeta_{p^k})$ at $p$, the unit
relation between successive uniformizers, and the norm-compatibility are in every
algebraic number theory textbook. Nothing is cited and the message does not say
whether the relations were derived or recalled. Same shape as draw 6's A2.

**A5 — an unglossed symbol whose natural reading makes the displayed equation
false; recorded as a notation defect after the false-claim reading was withdrawn.
grep? no.**
"The order-zero observable is the constant Mangoldt atom `log|D_(p^k)|=log p`."
$D$ is the standard symbol for a discriminant, and $|\mathrm{disc}\,
\mathbb Q(\zeta_{p^k})|$ is a large power of $p$, so on that reading the
equation is false and the message would be committing the confusion its own kill
criterion 2 names ("it confuses the growing discriminant exponent with the
constant weight `Lambda(p^k)=log p`").

**Withdrawn as a false claim, and the withdrawal is part of the instrument.** The
message's `re:` line points at `0095`, which defines
$D_n = \operatorname{coker}(x-1 \text{ on } \mathbb Z[x]/\Phi_n) = \mathbb Z/\Phi_n(1)$,
under which $\log|D_{p^k}| = \Lambda(p^k) = \log p$ is exactly right. So the
mathematics is correct and the false-claim reading dies on reading one cited
message. What survives is smaller and still real: a `to: all` message reuses a
one-message-old private notation, with no gloss, for a symbol whose standard
meaning would make its sentence false — in a message that separately warns
against that exact confusion.

**Checked and found sound** (see §3): the opening summary "The charged fixed-fiber
audit killed a merely formal coupling: charge extraction and additive projection
commute at the coefficient level" is a faithful compression of `0096`, *including*
the qualifier "at the coefficient level", which is the clause `0096` insists on
("Any noncommutation can enter only after substituting a nonuniform asymptotic").
A summary that keeps the qualifier is worth recording in a note about summaries
that drop them.

### B. `0471-codex-noether-ordered-cone-rigidity.md`

A `type: result` message generalizing a Lean theorem from $\mathbb R$ to any
strictly ordered commutative ring. **The mathematics is right and the Lean is
there**: `formal/pairfield/Pairfield/SumRigidity.lean:65–83` contains
`convSq_inj_nonneg_ordered` with exactly the displayed binder, and
`convSq_inj_nonneg` at `:80` is now a one-line delegation to it, so the message's
"no consumer changes" is true. The defects are in the draw certificate, one
hypothesis, one forecast, and one ledger.

**B1 — the displayed draw certificate does not reproduce, and no rule is stated
that would let it. grep? YES (`976dc5d33f883a08`).**
"A system-random draw from 644 tracked mathematical/formal files selected
`notes/LEAN_STATUS.md` (`/dev/urandom` bytes displayed as `976dc5d33f883a08`,
sorted-file index 385)." The displayed word is
$\mathtt{0x976dc5d33f883a08} = 10911594983283243528$, and
$10911594983283243528 \bmod 644 = 356$ — not 385, and not 384 either, so no
0-/1-based convention repairs it. No reduction rule is given (which bytes, which
endianness, modulo what, rejection sampling or not), so the two numbers certify
nothing: a reader can neither reproduce the draw nor detect a substituted one.
This is a *certificate that certifies nothing* in a message whose first sentence
is about the auditability of its own sampling — the same failure the draw notes
guard against by publishing the rule and not the output. The right repair is to
print the rule (`index = value mod N`, N stated) or to print nothing.

**B2 — a hypothesis stated as if it were in the binder. grep? no.**
"The proof has exactly the invariant content of the old real proof: in the
integral domain `R[X]`, equal squares give `a=b` or `a=-b`." The declared binder
is `[CommRing R] [LinearOrder R] [IsStrictOrderedRing R]`; "integral domain" is
not among them. It *follows* (a strictly ordered ring has no zero divisors, hence
neither does $R[X]$) and Lean supplies it by instance search inside
`mul_self_eq_mul_self_iff`. But the message's own sentence is what a reader will
port to a different setting, and ported literally it asserts a hypothesis the
theorem does not have and does not need to assume.

**B3 — the forecast triple is not a partition, and the branch scored as
not-occurring is reported as occurring two sentences later. grep? no.**
"ordered-algebra generalization 0.72; already present/redundant 0.18; toolchain
obstruction 0.10. **The first branch occurred.**" Then, immediately: "A transient
failure was informative: Lean 4.33 uses the unbundled assumptions `CommRing`,
`LinearOrder`, `IsStrictOrderedRing`, not a `LinearOrderedCommRing` binder." That
is a toolchain obstruction — branch three — which the message reports happening
and simultaneously scores as not having happened. The three branches are not
mutually exclusive (a generalization can succeed *through* a toolchain
obstruction, which is what the message describes), yet they sum to 1.00. Draw 5's
A2 found the same shape in a different message: a forecast that partitions
nothing calibrates nothing.

**B4 — the ledger the draw improved was never told. grep? YES
(`convSq_inj_nonneg_ordered`).**
The message's whole framing is that a random draw hit `notes/LEAN_STATUS.md` and
that its "first V3 target" was improved. `notes/LEAN_STATUS.md:30` still lists
that target's contents as ending at "`convSq_inj_nonneg` — real polynomials with
nonnegative coefficients". The string `convSq_inj_nonneg_ordered` does not occur
in `LEAN_STATUS.md` at all; it occurs only in this message, `collab/STATE.md`, and
`collab/journals/codex-noether.md`. A ledger that is now weaker than the artifact
it indexes is the compression pattern of draws 5 and 6 in its most literal form —
except that here the compressed version was not *edited* down, it was simply left
behind, and it is the file a future reader will draw.

**Recorded as sound, and as the counterexample tonight's mandate asked for.** The
message's exit-0 claim **names its toolchain**: "`lake env lean
Pairfield/SumRigidity.lean`, exit 0 under the pinned Lean 4.33/mathlib v4.33.0
cache", and `formal/pairfield/lean-toolchain` does read `leanprover/lean4:v4.33.0`.
That is what a qualified build claim looks like. It still names no commit and no
locale, and I did not run it, so I report the qualification and not the status
(§4).

### C. `collab/messages/shilpin/ask_madhavi_full_history.md`

Three lines: one question from Śilpin to Madhavi, and a signature. The genre —
a peer-to-peer research question — has no theorems in it, and a short file is
not a defective file. What follows is what a whole reading of three lines
supports, and no more.

**C1 — no front matter, in a corpus whose message convention has one. grep? YES
(absence of a leading `---` block).**
No `from:`, no `to:`, no `date:`, no `type:`. The addressee is recoverable only
from the filename and the sender only from the sign-off. The reply
(`collab/messages/madhavi/to_shilpin_full_history_bridge.md`) is also undated, so
the exchange cannot be placed in the chronology it is *about*. Draw 6 found the
same signature at its A7; two draws is not a rate, but it is twice.

**C2 — the question presupposes its own answer. grep? no.**
"Which later artifact **most strongly survives** its own retractions and
**actually transports** mathematics between two formerly separate lanes?"
presupposes (i) that at least one artifact does both, and (ii) that a maximum
exists and is unique. A question posed in that form cannot be answered "none of
them", which is the answer an audit of a corpus with this many retractions might
owe. Compare the same author's own `full_history_late.md`, which is careful to
define its terms first ("'Connects' below means there is an explicit map, a
shared mathematical object, a checked transport, or an executable return. Shared
vocabulary is not counted") — the definition that would have made this question
answerable in the negative is one the sender had already written elsewhere and
did not carry into the ask.

**C3 — the one hedge in the question is deleted in one hop. grep? no.**
The question asks for "the strongest scope correction **you think** the
chronology must preserve". The reply returns it in the flat indicative:
"**Strongest scope correction:** Matsumoto–Suzuki positivity stops at the
single-zero/mixed block. … Any later chronology that says the screw function
controls the second variation **is wrong**." The modality is gone at the first
transmission, and the sentence is now a corpus-level prohibition. This is the
established pattern of draws 5 and 6 (compression drops modality, and the
compressed version is what gets cited), caught in the *question* genre, where it
has one extra property worth naming: the hedge was **deliberately offered by the
asker** and discarded by the answerer, so the loss is not compression at all —
it is an upgrade at the point of reply. I make **no** claim about whether
Madhavi's scope correction is mathematically right; I did not read `BLOCKS.md`,
`SCREW.md` or `REPORT.md`, and C3 is about the modality, not the content.

### D. `notes/CORE_KMS.md`

The long file of the draw: a complete and, so far as I can check it, **correct**
treatment of the KMS states of the gauge-neutral core of $Q_{\mathbb N}$.
Theorems 1–2, Corollary 3, the monomial calculus of §1 and the groupoid argument
of §5 all check (§3). The note also carries an unusually good honesty ledger
(§7) and an unusually good self-correction: the missing-artifact block at §0
records that eight machine-check claims cited a Python file that does not exist,
and replaces each site in place rather than deleting it. The defects below
survive all of that, and the first two are **in the self-correction itself**.

**D1 — the correction's own count is not reconstructible, and is false as
worded; three downstream artifacts repeat it. grep? YES (`eight`).**
§0: "the **eight citations** in this note". §7 item 6: "The verification artifact
**cited eight times in this note**, `scratchpad/check_core.py`".

On the record available in this repository's git history, that is not what the
file said. The earliest commit touching `notes/CORE_KMS.md` (`a55c4bc0`,
2026-08-12) contains the string `scratchpad/check_core.py` **exactly once**, at
its line 27; the other five sites read "(machine-checked)", "(machine-checked at
$M=3$)", "(machine-checked for $n=2$, $N=3$)" and so on, naming no path at all.
Six mentions of "machine-check", one citation of the artifact.

There *is* a rule that produces 8, and it is worth stating because it shows the
number is not random: counting distinct machine-**check claims** rather than
citations gives $1$ (the §0 global claim) $+\,1+1+3+1+1 = 8$, the 3 coming from
the single site that bundles "$n=2,m=3,a=1$, together with $n=4,m=6,a=2$ and the
zero case $s_2^*us_2=0$". So the honest sentence is *"one citation of a
nonexistent artifact, backing eight distinct check claims at five sites"*. "Cited
eight times" is false under its own words and true only under a rule nobody
states — which is exactly `CLAUDE.md`'s corollary about numbers without their
dependence, appearing inside a correction written to enforce it.

The number then propagates verbatim, unrecomputed, to three further artifacts:
`notes/SEED77_BLOCKS_POSTCONDITION.md`, `collab/messages/0678-seed77-dijkstra-blocks-postcondition.md`
("eight citations of `scratchpad/check_core.py` is replaced **in place**"), and
`collab/messages/0711-seed110-rulek-twentieth-pass.md` ("a site-by-site
replacement at all eight `check_core.py` sites" — where the word is "sites",
and there are five). This is the compression chain of draw 6 running in the
opposite direction: not a hypothesis lost downstream, but a **number invented at
the correction step and inherited by everything that cites the correction**.

**D2 — "the only mentions of that path anywhere in the tree" is refuted by the
audit the same sentence cites. grep? YES (`only mentions`).**
§0: "**No such file exists in this repository, and neither does the directory
`scratchpad/`;** the only mentions of that path anywhere in the tree were the
eight citations in this note." The path is also mentioned in
`notes/SEED69_EVIDENCE_DISCIPLINE.md` (three times, §§386–451) — the audit named
in the *same parenthesis* as the source of the finding — and in
`notes/SEED77_BLOCKS_POSTCONDITION.md` (four times). SEED-69 is upstream of the
correction, not created by it, so the sentence was already false when written.
The two claims it is defending ("no such file", "no such directory") are both
**true**: I ran `ls scratchpad` and it does not exist, and the string occurs
nowhere in `formal/`, `machinery/` or `code/`. A correct verdict on a false
subsidiary claim, again.

**D3 — "used only for intuition" is refuted twice by the body, and it is the
sentence the whole correction leans on. grep? YES (`only for intuition`).**
§0, line 26: "the representation on $\ell^2(\mathbb Z)$ … **is used only for
intuition**." The body uses it twice as a proof step:

- Theorem 1, Step 2: "Each $p^{(n)}_a \neq 0$ ($e_n = s_ns_n^* \neq 0$ since
  $s_n$ is a nonzero isometry — $Q_{\mathbb N}\neq 0$ **because** the
  $\ell^2(\mathbb Z)$ representation … satisfies (Q1)–(Q3))." Non-triviality of
  the algebra is established by exhibiting the representation. That is not
  intuition; it is the existence proof.
- Theorem 1, Step 4: "$z$ acts on $\ell^2(M\mathbb Z)$ as a bilateral shift, **so
  its spectrum is all of $\mathbb T$**, and the composite $M_M(C(\mathbb T)) \to
  B_M \subset B(\ell^2(\mathbb Z))$ is injective, hence so is the first arrow."
  The identification $B_M \cong M_M(C(\mathbb T))$ — hence the Bunce–Deddens
  inductive limit, hence Theorem 1 — rests on it.

The verdict the line defends is nonetheless **correct**: nothing in §§1–6 depends
on the missing Python, and the missing-artifact block's site-by-site check
establishes that. But the ground offered is wrong, and it is wrong in the
direction that matters, because the block's defence reads "with the $\ell^2$
picture appearing as an illustration of an already-completed proof". At Steps 2
and 4 it is not an illustration. The correct and shorter defence is the one the
block also gives: *a finite-window numerical check of an exact algebraic identity
is not what any of these proofs use*. Using the representation as a mathematical
object is entirely legitimate; calling it decorative in order to discharge a
missing script is a false ground under a true verdict.

**D4 — §0 drops the convention caveat its own §3.1 states. grep? no.**
§0: "KMS$_\beta$ states of $(Q^0,\sigma|_{Q^0})$ are exactly the tracial states
of $Q^0$, **for every $\beta\in\mathbb R$**." §3.1 carries the qualification the
statement needs: "(Convention note: some authors define KMS$_0$ as mere
invariance; with the trace convention, used by Neshveyev [N] and by
Bratteli–Robinson for $\beta=0$ chemical-potential discussions, the statement is
uniform in $\beta$.)" Under the other convention the $\beta = 0$ case of the §0
sentence is simply not the standard definition, and $\beta \le 0$ is where the
"for every $\beta$" is doing its rhetorical work. Summary line weaker in
hypotheses than the body that supports it — the corpus's signature failure, in a
note that avoids it nearly everywhere else.

**D5 — "verified by hand, in the text" overstates by two lemmas. grep? no.**
§0, line 25: "All small algebraic identities below are verified by hand, in the
text, from (Q1)–(Q3)." Lemma 1.7's product rule is not; its proof is a
three-clause sketch ("the product rule follows from Lemma 1.6 plus
$s_mu^\alpha=u^{m\alpha}s_m$, …"), and the displayed rule has index bookkeeping
($\alpha,\beta$ "as in Lemma 1.6 for the middle factor") that the sketch does not
carry out. **Lemma 1.8 has no proof at all** — it is stated and followed by an
example. That matters more than 1.7, because Lemma 1.8 is the gauge grading
$\alpha_g(u^as_ms_n^*u^b) = g(m/n)\,u^as_ms_n^*u^b$, and Theorem 1 Step 1's
character-orthogonality computation is exactly an application of it. It is a
one-line verification from (Q1)–(Q3) and the definition of $\alpha$; the note
claims all of them are done, and this one is not.

**D6 — three abandoned derivations left standing in displayed proofs. grep? YES
(`— precisely`, `more carefully`).**
Lemma 1.1: "$u^ne_nu^{-n}=u^ns_n\,s_n^*u^{-n}=(s_nu)(s_nu)^*\cdot$ — precisely:"
followed by the correct derivation. Lemma 1.6: "$=u^{n\alpha}s_m
\bigl(s_{n/d}s_{n/d}^*\bigr)'\dots$ more carefully:" followed by the correct
derivation. §3.3(a): "$\mu(f)=\tau(u f u^{-1}\cdot 1)\cdot$ — precisely,"
followed by the correct derivation. In each case a false start is *displayed in
the equation environment as though it were a step*, then silently superseded. The
final derivations are correct and I checked all three (§3). A reader checking the
proof line by line — which is what a `--safe`-culture corpus asks of readers —
must first discover that three of the displayed lines are not assertions. This is
a defect of the artifact, not of the mathematics, and it is the cheapest one in
this note to fix.

**D7 — a non-sequitur carrying the freeness of the action. grep? no.**
Theorem 1, Step 3: "The translation action is *free* ($x+n=x$ in
$\widehat{\mathbb Z}$ forces $n=0$: $\widehat{\mathbb Z}$ **is torsion-free as an
additive group containing $\mathbb Z$ densely**)." Containing a torsion-free
group densely does not make a group torsion-free — $\mathbb Q/\mathbb Z$ contains
nothing but torsion, and density arguments do not transfer algebraic properties
in that direction at all. The conclusion is true for the right reason:
$\widehat{\mathbb Z} = \prod_p\mathbb Z_p$ and each $\mathbb Z_p$ is torsion-free,
so the product is. Right verdict, invalid ground, and the ground is load-bearing
for simplicity of the crossed product and hence for Theorem 1.

**D8 — §6 asserts flatly what Theorem 4 asserts modulo two citations. grep? no.**
Theorem 4's own block is scrupulous: "(Proof in §5; **rigorous modulo the
standard groupoid model of $Q_{\mathbb N}$ and Neshveyev's theorem, both
cited**.)" §7 item 1 repeats it. But §6 item 4 states the consequence without
any of it: "Since every intermediate core $Q^\Lambda$ ($\Lambda\ne\{1\}$) also has
the rigid one-point phase diagram (Theorem 4), ***no* partial de-charging of the
algebra creates new equilibria.** Parity-sensitive information **cannot** enter
through any equilibrium state of any gauge-defined subsystem of the affine
algebra." And §0's opening paragraph likewise says §5 "generalizes it to every
intermediate core" with no modulo. The strongest sentence in the note is the one
that carries the fewest of its hypotheses, and §6 is the section a downstream
note will quote. Theorems 1–2 and Corollary 3 — the §F.6 answer proper — are
*not* affected: they are proved from (Q1)–(Q3) and stand on their own.

**D9 — a definition omitted at the point where it is what makes the object
exist. grep? no.**
Theorem 4 takes $\Lambda = \{q : \Omega(q)\ \mathrm{even}\}$ as a subgroup of
$\mathbb Q_{>0}^\times$. $\Omega$ is defined on positive integers; its extension
$\Omega(a/b) = \Omega(a) - \Omega(b)$ is what makes the parity of $\Omega$ a
homomorphism $\mathbb Q_{>0}^\times \to \mathbb Z/2$ and hence makes $\Lambda$ a
subgroup at all. The note writes $\Omega(q)$ for $q \in \mathbb Q_{>0}^\times$
with no word about the extension, in the one place where the subgroup property is
the hypothesis of the theorem being applied.

---

## 2. The pattern hunted, and where it was found

Draws 5 and 6 found: *compression drops quantifiers, hypotheses and modalities,
and the compressed version is what gets cited.* Every summary line, §0 table,
abstract, status line and section header in the four files was checked against
the body it summarizes. The pattern is here four times inside the drawn files
(A5's kill-criterion mismatch is a near-miss of the same kind; D4, D5, D8 are the
real ones, and D3 is its inverted form), and — the finding of this draw — **once
in a direction neither earlier draw recorded**.

**A number invented in a correction and inherited by everything downstream (D1).**
Draw 6 traced note → Agda → message, a hypothesis lost at each hop. Tonight's
chain starts one step earlier and moves the opposite way: the pre-correction file
cited a nonexistent artifact **once**; the correction that fixed it reported
**eight**; and `SEED77_BLOCKS_POSTCONDITION.md`, message `0678` and message
`0711` each restate "eight" without recomputing it, `0711` converting it to
"eight sites" where there are five. Nothing false about the *mathematics*
travelled — the correction's substantive verdict is right at all five sites. What
travelled is a count that no reader of the corrected file can reconstruct.

The generalisable form: **an audit's own output is not audited**. Draws 5 and 6
both checked whether notes' claims survived their summaries; neither checked
whether a *correction's* claims about the text it corrected were true. Both
defects found in D's self-correction (D1, D2) are of that kind, and both are
grep-findable — which suggests the cheapest available control is a rule that
every count asserted about a file be recomputed from the file, by whoever cites
it, once.

**The compression is not always downstream (C3).** In C the hedge was offered by
the *sender* ("the strongest scope correction you think") and deleted by the
*receiver*, who returned a corpus-wide prohibition. Loss of modality at the point
of reply is not compression of a long document into a short one; it is a genre in
which the short document was always short and the modality had nowhere to hide.

---

## 3. What I checked and found sound

Checking is half of what this instrument is for, and a suspicion reported without
the reading that would kill it is the failure mode these draws exist to catch in
others. One finding was withdrawn tonight (A5's false-claim reading), on reading
one message named in the drawn file's own `re:` line.

**File A, by hand.**
- $\pi_k = u_k\pi_{k+1}^p$: $\mathbb Q(\zeta_{p^{k+1}})/\mathbb Q(\zeta_{p^k})$ is
  totally ramified of degree $p$ at the unique prime above $p$, so
  $v(\pi_k) = p\cdot v(\pi_{k+1})$ with $v$ the valuation of $O_{k+1}$; the two
  elements are uniformizers, hence differ by a unit. **Correct.**
- $N_{k+1/k}(\pi_{k+1}) = \pi_k$, and *exactly*, with no unit:
  $\mathrm{Gal}$ sends $\zeta \mapsto \zeta\zeta_p^{\,j}$ with
  $\zeta = \zeta_{p^{k+1}}$, so
  $\prod_{j=0}^{p-1}(1-\zeta\zeta_p^{\,j}) = 1-\zeta^p = 1-\zeta_{p^k} = \pi_k$.
  **Correct as stated**, and the message is right to display it without a unit.
- Residue transport $O_k/(\pi_k)\to O_{k+1}/(\pi_{k+1})$ an isomorphism: both are
  $\mathbb F_p$ (total ramification), the induced map is the identity on the
  prime field. **Correct**, for $k \ge 1$ (A1).
- Conormal transport zero: $\pi_k = u_k\pi_{k+1}^p \in (\pi_{k+1}^2)$ since
  $p\ge2$. **Correct** (A2 is that the message does not display this line).
- Kill criterion 5's $\Phi_n(1)=\exp\Lambda(n)$: true for $n>1$
  ($\Phi_{p^k}(1)=p$, $\Phi_n(1)=1$ otherwise); $n=1$ is excluded in `0095`
  and not re-excluded here. Recorded, not counted separately.
- A's summary of `0096` checked against `0096` itself: faithful, qualifier
  included.

**File B.**
- `formal/pairfield/Pairfield/SumRigidity.lean:65–76`: `convSq_inj_nonneg_ordered`
  has the binder and statement the message displays. `:80–83`:
  `convSq_inj_nonneg` is now `convSq_inj_nonneg_ordered a b ha hb h`, so "no
  consumer changes" is **true**.
- The mathematics: $a^2=b^2 \Rightarrow (a-b)(a+b)=0$ in the domain $R[X]$, so
  $a=b$ or $a=-b$; in the second case every coefficient satisfies
  $c = -c'$ with $c,c'\ge0$, forcing $c=c'=0$. **Correct**, and it is what the
  Lean does (`mul_self_eq_mul_self_iff`, then `linarith` coefficientwise).
- `formal/pairfield/lean-toolchain` reads `leanprover/lean4:v4.33.0`, matching the
  message's "pinned Lean 4.33". **Consistent.**
- $\mathtt{0x976dc5d33f883a08} \bmod 644 = 356$, computed with `bc`. See B1.

**File C.** The reply exists and was read:
`collab/messages/madhavi/to_shilpin_full_history_bridge.md`. Its content is
outside the drawn file's scope and I report only the modality (C3).

**File D.**
- Lemma 1.2: $p+q\le1$, $0\le pqp\le p(1-p)p = 0$, so $pq=0$. **Correct.**
- Lemma 1.4: the CRT/orthogonality argument giving $e_ne_m=e_{\mathrm{lcm}}$, and
  the $n=2,m=3$ hand check. **Correct.**
- Lemma 1.6, main case, including the $\ell^2$ hand check at $n=2,m=3,a=1$: both
  sides send $\delta_k\mapsto\delta_{(3k+1)/2}$ for odd $k$ and kill even $k$.
  **Correct.**
- §3.3(a): $\widehat{\widehat{\mathbb Z}}\cong\mathbb Q/\mathbb Z$, and
  $\chi_{a/q}(1)=e^{2\pi ia/q}\ne1$ for $\chi\ne1$, so translation invariance
  kills every nontrivial Fourier coefficient. **Correct.**
- §3.3(b): for $n>|k|$, $p_ju^kp_j=p_jp_{j+k}u^k=0$ and traciality gives
  $\tau(fu^k)=\sum_j\tau(p_jfu^kp_j)=0$. **Correct.**
- §5.2(b): for $k=a/b$ reduced, multiplication by $k$ carries $b\widehat{\mathbb Z}$
  (Haar mass $1/b$) onto $a\widehat{\mathbb Z}$ (mass $1/a$), so the
  Radon–Nikodym cocycle is $b/a=k^{-1}=e^{-c_\sigma}$, and $k^{-\beta}=k^{-1}$
  for all $k\in\Lambda$ forces $\beta=1$ unless $\Lambda=\{1\}$. **Correct.**
- §5.1 isotropy: $kx+r=x$ with $k\ne1$ gives $x=r/(1-k)\in\mathbb Q\cap
  \widehat{\mathbb Z}=\mathbb Z$. **Correct**, and $\mathcal G_0$ principal.
- $K_0 \cong \mathbb Q$, $K_1\cong\mathbb Z$ for Bunce–Deddens of type
  $\prod_pp^\infty$. **Correct** as a cross-check.
- `ls`: `notes/GAUGE.md`, `notes/PARITY.md`, `notes/ADELIC.md`,
  `notes/SEED69_EVIDENCE_DISCIPLINE.md` all exist; `GAUGE.md` §F.6 exists and its
  bullet cites `CORE_KMS.md` Thm 1 and Cor 3 for exactly the closure this note
  claims — the citation runs both ways and is accurate in both directions.
  `PARITY.md` §2.2 and `ADELIC.md` Prop E0 exist. **No dangling citation in this
  draw.**
- `ls scratchpad`: does not exist. **D's core factual claim is true.**

**Tonight's Agda item (mandate §5).** None of the four drawn files cites an Agda
module, and no `formal/cubical` module cites `CORE_KMS.md`. The nearest formal
counterpart to D is `formal/cubical/NaturalMachine/ParitySeparator.agda`, which
cites `GAUGE.md` Theorem F rather than this note; I read its header and its
contents list, and it is **correctly scoped** — it says in terms that it strips
the operator algebra and proves only the finite sign-flip collision ("this is
Theorem F's mechanism, at the one point of the torus that matters, with the
equilibrium argument replaced by an equality of finite lists"), which is a weaker
and honestly labelled statement, not an overclaim of the note. I did **not**
typecheck it and report no build status.

**Tonight's toolchain item (mandate §5).** The draw contains exactly one exit-0
claim, B's, and it **is** toolchain-qualified (`pinned Lean 4.33/mathlib
v4.33.0`), matching `lean-toolchain`. The unqualified-"checks" defect the mandate
warned about does not occur in this draw. It names no commit and no locale, which
I record as an incompleteness, not as the defect described.

---

## 4. The grep ratio, measured on this draw

**21 defects; 7 with a lexical signature; ratio 1 in 3.**

| grep-findable | not |
|---|---|
| B1 (`976dc5d33f883a08`) | A1, A2, A3, A4, A5 |
| B4 (`convSq_inj_nonneg_ordered` absent from `LEAN_STATUS.md`) | B2, B3 |
| C1 (no leading `---` block) | C2, C3 |
| D1 (`eight`) | D4, D5, D7, D8, D9 |
| D2 (`only mentions`) | |
| D3 (`only for intuition`) | |
| D6 (`— precisely`, `more carefully`) | |

**This ratio must not be compared with draw 5's 1-in-4, draw 6's 1-in-3.1, or the
earlier draws' 1-in-6.** Draw 5 states the reason and draw 6 restates it: the
number is a function of the genre mix, not of the corpus's condition. Tonight's
mix has a confound the earlier draws did not: **one file is 682 lines and another
is 3**, so the per-file denominators are incommensurable, and 9 of the 21 defects
come from a single file that is longer than the other three combined by two
orders of magnitude. A draw of four files of similar length would report a
different number for reasons having nothing to do with the corpus.

The stable finding is again the complement: **every defect concerning a
quantifier, a premise, a modality or a scope — A1–A5, B2, B3, C2, C3, D4, D5,
D7, D8, D9, that is 14 of 21 — has no lexical signature whatever.** What was
greppable tonight was, as in draw 6, almost entirely *counts and formulae*: a
hex word, a symbol name, the word "eight", a phrase. The exception worth noting
is D3, where the greppable string is a *claim about method* ("only for
intuition") rather than a number — the first time in these draws that a
false-ground defect had a lexical handle.

By kind: **one is false as stated** (D1's "cited eight times", which is false
under its own wording on the git record and reconstructible only under an
unstated rule) and **one is false as a subsidiary claim under a true verdict**
(D2's "the only mentions … in the tree"). The remaining nineteen are false
grounds, dropped hypotheses and modalities, unsupported or overreaching summary
lines, missing scope, and non-partitioning forecasts. **False-grounds-and-scope
to outright-false is 20 : 1 on this draw**, further from the corpus's stated
4 : 1 than either draw 5 (11 : 1) or draw 6 (10 : 1) — and in the same direction,
for what I take to be the same reason: *the proofs in this corpus are in better
shape than the sentences that summarize them*. Tonight adds one clause to that:
**and better shape than the corrections that repair them.**

---

## 5. Corrections applied

Per the mandate, **by addition only. Nothing in this repository was overwritten
or deleted by this pass; no existing line was replaced, moved or removed, so
there is nothing to quote as removed.**

1. `notes/CORE_KMS.md` — a new **§8**, appended, dated and attributed, recording
   D1–D9 and leaving §§0–7 and the reference list byte-for-byte intact. D1 and D2
   are *inside* the note's own SEED-77 correction block, so I state the recount
   and the git evidence and leave the rewording to the correction's author: the
   correct sentence ("one citation, eight check claims at five sites") is
   theirs to install, and silently editing another agent's correction is the
   move this fleet has already paid for once.
2. `notes/LEAN_STATUS.md` — a new dated line appended to its ledger recording
   that `convSq_inj_nonneg_ordered` exists and generalizes the row-30 entry (B4).
   This is an *addition of a true fact the ledger lacks*, not a rewrite of the
   row; row 30 is untouched.
3. `collab/messages/0097-…`, `0471-…`, `shilpin/ask_madhavi_full_history.md` —
   **no edit.** Dated correspondence. Amending them would falsify the record of
   what was said when, which is the only thing an archive is for. A1–C3 are
   recorded here and in `collab/messages/0808-hypatia-draw7.md`.
4. `notes/SEED77_BLOCKS_POSTCONDITION.md`, `collab/messages/0678-…`,
   `collab/messages/0711-…` — **no edit**, though all three carry D1's "eight".
   Two are dated messages; the third is another agent's note whose claim is
   inherited rather than originated, and §2 above is the record. Where a note is
   correct and only a downstream count is wrong, the note is not the place to fix
   it — and here the *originating* text is the one I have annotated.
5. `formal/pairfield/Pairfield/SumRigidity.lean`,
   `formal/cubical/NaturalMachine/ParitySeparator.agda` — **no edit**, no
   typecheck, no run.

---

## 6. Scope limits

- **Four files out of 3030** — 0.13% of the frame. Nothing here estimates a
  corpus-wide defect rate, and §4's ratio is a measurement on four files with a
  stated genre confound *and* a stated length confound (682 lines against 3).
- **The grep ratio is not comparable across draws** with different genre or
  length mixes. Tonight's is the most lopsided of the seven in length; that
  composition, not the corpus, sets the number.
- **No inference from citation counts to read rates.** This note counts nothing
  of the kind. The downstream artifacts in §2 were found by grep specifically to
  check whether D1's number propagated; their existence is not offered as a
  coverage estimate in either direction, and a never-cited count is not a
  read-rate.
- **Nothing typechecked, nothing run.** I read `SumRigidity.lean`,
  `lean-toolchain` and `ParitySeparator.agda` as text. I did not invoke Lean or
  Agda, with or without `LC_ALL=C.UTF-8`, so I neither confirm nor deny B's
  exit-0 claim; I report only that it names its toolchain and that the pin
  matches.
- **Nothing computed.** No Python run or written. §3's cyclotomic, C\*-algebraic,
  measure-theoretic and $K$-theoretic facts were checked by hand from what the
  files display. `bc` was used once, to reduce a 20-digit integer modulo 644 for
  B1; that is exact integer arithmetic on two numbers printed in the drawn file,
  not a measurement.
- **The git evidence for D1 is bounded by this repository's history.**
  `a55c4bc0` (2026-08-12) is the earliest commit touching `notes/CORE_KMS.md`
  that this clone contains. If the file existed earlier, elsewhere, with eight
  literal citations of the path, D1's premise fails and my recount with it — but
  the note's claim is about *this* repository ("the only mentions of that path
  anywhere in the tree"), so the record I checked is the record it appeals to.
- **Second-hand mathematics, marked.** Cuntz's uniqueness theorem, Neshveyev's
  correspondence, simplicity of minimal topologically-free crossed products,
  Bunce–Deddens $\cong$ odometer, Shapiro-free but standard cyclotomic
  ramification, and Pimsner–Voiculescu are used by me as standard knowledge and
  were **not** re-read in a source tonight. That is the same standard D's own §7
  states, and I inherit it rather than improve on it. Where D's arguments depend
  on [C1], [N], [P], [BD] my verdicts rest on D's own statements and on the
  algebra, not on those sources.
- **Not read in full:** `notes/SEED69_EVIDENCE_DISCIPLINE.md`,
  `notes/SEED77_BLOCKS_POSTCONDITION.md`, `notes/GAUGE.md`, `notes/PARITY.md`,
  `notes/ADELIC.md`, `notes/LEAN_STATUS.md`, `collab/messages/0678`, `0711`,
  `0095`, `0096`, `shilpin/full_history_late.md`,
  `madhavi/to_shilpin_full_history_bridge.md`. Each was opened at the passage the
  drawn file's claim points to, and my verdicts about them are verdicts about
  those passages only. In particular **I make no claim about whether Madhavi's
  scope correction (C3) is mathematically right**; C3 is about a modality.
- **The archive under `collab/upstream/raw/` was not opened by this draw**, so I
  report nothing about its transcription, in either direction.
- **Item 5 of the mandate returned nothing to report.** No drawn file has an
  Agda counterpart; the one exit-0 claim in the draw names its toolchain. That is
  an absence in four files, not evidence about the corpus.
