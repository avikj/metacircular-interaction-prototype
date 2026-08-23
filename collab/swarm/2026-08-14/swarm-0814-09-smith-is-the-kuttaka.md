# The Smith invariant *is* the kuṭṭaka obstruction — proved, in the lane that runs

`swarm-0814-09` · 2026-08-14 · one object, one contradiction, two seeder appends

---

## 0. The draw

Eight uniform: `collab/messages/workers/20260812T090836.491254Z--codex_arithmetic_life--0002.md`,
`kernel/nodes/001-invariant.md`, `data/exp46_channel_prime.jsonl`,
`collab/messages/0116-weaver-keep-going-skill.md`, `data/exp47_zeta23_build.txt`,
`code/exp57_geodesics.py`, `notes/LEAN_SMITH_CERTIFICATE_GATE.md`,
`notes/QUANTUM_COMB_MEMORY_ROSETTA.md`. Three rare-corner:
`collab/discovery/events/R0026/20260812T092548Z-builder.json`,
`collab/mailboxes/root/20260812T144913.599498Z-c4b84eee6ae5.md`,
`collab/discovery/events/R0007/20260811T185428Z-seeded.json`.
Frontier: complexity barriers (relativization, natural proofs, algebrization).
Ancient: Mīmāṃsā hermeneutics. Lenses: **Gowers** (what is the natural proof
strategy, and why does it fail) vs **Tarski** (separate object language from
metalanguage before asking about truth). All eleven read in full, untriaged.

---

## 1. Where the two lenses disagree

Three of the drawn files are *verification artifacts*: the Lean Smith gate note,
the `zeta23` build log, and — read as evidence, not run — `exp57_geodesics.py`.
The lenses split on them cleanly.

**Gowers** reads `notes/LEAN_SMITH_CERTIFICATE_GATE.md` §"What remains" and finds
a well-posed research question: the natural strategy for a certified Smith
*producer* is elementary-operation descent, and it fails for want of a proved
well-founded measure. Attack the measure.

**Tarski** reads the same paragraph and finds an **unindexed predicate**. "The
general producer is not proved" is a metalanguage sentence; it does not say *in
which object language*. Once indexed it splits into two sentences with different
truth values, and one of them is false. Likewise `data/exp47_zeta23_build.txt`:
`PrintAxioms` lines are object-level (each names the exact axiom set of a named
constant), while `Build completed successfully (9010 jobs)` is a metalanguage
record of a past run on a machine that is not this one.

The disagreement is not stylistic. Gowers's reading sends an agent to work on the
descent measure. Tarski's reading sends it to check the index — which is what I
did, and it dissolved the question. This note follows Tarski and reports what
Gowers's route would have missed.

---

## 2. Contradiction with a conspicuous document (with evidence)

`notes/LEAN_SMITH_CERTIFICATE_GATE.md` says:

> The checker is complete; the general producer is not. […] Full completion
> requires an elementary-operation descent with a proved well-founded measure or
> another constructive algorithm satisfying this same gate.

Two things are wrong with this at the present timestamp.

**(a) The gate it describes cannot run in this checkout.** The note's whole force
is "Lean kernel reduction (`by decide`), never `native_decide`". Verified here,
2026-08-14:

```
lean: absent      lake: absent      elan: absent
formal/pairfield/.lake: No such file or directory
~/.elan: No such file or directory
formal/pairfield/lean-toolchain: leanprover/lean4:v4.33.0
```

`agda --version` → `Agda version 2.6.3` at `/usr/bin/agda`. So the Lean lane's
`check_sound`/`check_complete` are, in this environment, sentences about a
kernel that is not present. Per `kernel/nodes/001-invariant.md` — also in my
draw — a claim that is true only in a named frame is **gauge**, not invariant.
"The Smith certificate is kernel-gated" is gauge; its frame is the
`leanprover/lean4:v4.33.0` toolchain, and the frame is not installed here. The
note names its object language but never names its host, so a reader cannot tell
which. `data/exp47_zeta23_build.txt` does better: it stamps
`repo HEAD: 3635e74…` and `toolchain: leanprover/lean4:v4.33.0-rc2` at the top.
That log is a correctly gauge-labelled presentation; the gate note is not.

**(b) The "general producer" already exists, constructively, in this repository.**
`formal/cubical/NaturalMachine/SmithCapability.agda` wraps
`Cubical.Algebra.IntegerMatrix.Smith`: a total `--safe` function
`normalizeSmith : (M : Mat m n) → Smith M` returning the normal matrix, both
invertible transforms, the replay path `N ≡ L ⋆ M ⋆ R`, and a proof of
`isSmithNormal`, for **arbitrary** `m × n` integer matrices. Not 2×2, not a
coprime-join special case. `formal/cubical/SmithTorsorBridge.agda` already
consumes it. The descent-with-well-founded-measure obligation the note posts as
open was discharged upstream in the cubical library before the note was written.

This is the frontier field earning its place rather than ornamenting: the note
mistook an obstacle *relative to one proof method* (Lean-side elementary
descent) for an obstacle to the theorem. That is precisely the shape a
relativization-style barrier has, and precisely the mistake a barrier result is
supposed to prevent you from making — a barrier says "this method cannot", never
"this theorem is not". The note's "what remains" is a method statement typeset
as a theorem statement. **Analogy, not theorem: no barrier result is invoked or
proved here.**

---

## 3. The object

The gate note states what its certificate *is* and never states what it *buys*.
Codex's broadcast (`…codex_arithmetic_life--0002.md`) states the payoff in a
different vocabulary and never connects it to Smith form:

> For $az \equiv b \pmod m$, form $g=\gcd(a,m)$. If $g \nmid b$, return $g$ as
> the complete obstruction.

These are the same theorem. The proof is below, formalized.

**Module.** `formal/cubical/Swarm/S09SmithKuttaka.agda`, `--cubical --safe`,
no postulates, no holes.

### Definitions

Over any commutative ring $R$ (instantiated at $\mathbb{Z}$):

$$d \mid b \;:=\; \Sigma_{t}\, b = d\cdot t,
\qquad
\mathrm{Rep}(a,m,b) \;:=\; \Sigma_{z}\Sigma_{k}\, az + mk = b .$$

A **certificate** for $[a\;m]$ is the gate note's `Valid`, specialised to a
$1\times2$ matrix: data $d,u,\varepsilon,p,q,r,s \in R$ with

$$u^2=1,\quad \varepsilon^2=1,\quad ps-qr=\varepsilon,\quad
u(ap+mr)=d,\quad u(aq+ms)=0,$$

i.e. $L\,A\,R = [\,d\;\;0\,]$ with $L=(u)$, $R=\binom{p\;\;q}{r\;\;s}$,
$|\det L|=|\det R|=1$. ($d_2=0$ makes the note's $0\le d_2$ and $d_1\mid d_2$
vacuous, so they carry no content in this shape and are omitted; nothing else
is dropped.)

### Theorem (the Smith invariant is the complete obstruction)

For every certificate and every $b$:

$$\mathrm{Rep}(a,m,b) \;\Longleftrightarrow\; d \mid b .$$

Both directions with explicit integer witnesses:

* `repToDiv` — from $az+mk=b$, take $t=(\varepsilon u s)z+(-\varepsilon u q)k$.
* `divToRep` — from $b=dt$, take $z=(up)t$, $k=(ur)t$.

The two supporting lemmas are the adjugate contractions of the certificate rows,
$s\cdot\mathrm{eq}_1-r\cdot\mathrm{eq}_2$ and $-q\cdot\mathrm{eq}_1+p\cdot\mathrm{eq}_2$:

$$(\varepsilon u s)\,d = a, \qquad (-\varepsilon u q)\,d = m,
\qquad a(up)+m(ur)=d .$$

The first two are $d\mid a$, $d\mid m$ **recovered without inverting $R$** — the
direction a diagonal-form checker does not obviously give you. The third is
Bézout, read straight off $\mathrm{eq}_1$.

`falseBranch` is the corollary Codex's message emphasises: $\neg(d\mid b)$
refutes $\mathrm{Rep}(a,m,b)$ outright. The false branch of $12z\equiv 5
\pmod{30}$ is a complete refutation, not a failure to find.

### What this costs, and what it does not use

Every proof is one polynomial identity discharged by the commutative-ring solver
plus exactly the hypothesis rewrites. **No division, no case split, no ordering
of $\mathbb{Z}$, no decidability, no gcd algorithm, no Euclidean descent, no
producer.** Consequence for the gate: `gcd` never needs to enter the trusted
base. $d$ is whatever the untrusted producer wrote down; the five equations pin
it, and solvability follows. The theorem holds over any commutative ring with
this certificate shape.

### Non-vacuity, computed not asserted

$A=[12\;\;30]$, $L=(1)$, $R=\binom{3\;\;\;5}{-1\;-2}$, $\det R=-1$,
$LAR=[6\;\;0]$. All five certificate conditions hold by `refl`. Feeding
$6\mid 18$ to `divToRep` returns

$$z=9,\qquad k=-3,\qquad 12\cdot 9+30\cdot(-3)=18,$$

checked by `refl` (`witnessZ`, `witnessK`). Note $9\equiv 4\pmod 5$ — the
broadcast's residue class, recovered from the certificate rather than from a
pulverizer run. The certificate *solves* the congruence; it does not merely
audit a solution.

### Checker

```
cd formal/cubical && LC_ALL=C.UTF-8 agda -i . Swarm/S09SmithKuttaka.agda
Checking Swarm.S09SmithKuttaka (/home/user/math/formal/cubical/Swarm/S09SmithKuttaka.agda).
EXIT=0
```

---

## 4. The ancient field, used as method

Mīmāṃsā's operative rule is *adhikāra*: an injunction binds only where its
eligibility condition holds, and when injunctions conflict the ordered
resolution (*bādha*) lets a lower one govern where a higher one lapses. Three
injunctions in force here:

1. `CLAUDE.md` — exact/certified symbolic computation **is** proof.
2. `notes/LEAN_SMITH_CERTIFICATE_GATE.md` — promotion is by Lean kernel
   reduction, never `native_decide`.
3. The swarm brief — a green is an exit code or it is a rumour.

(2) and (3) conflict in this environment: obeying (2) makes (3) unsatisfiable,
because no Lean kernel exists to produce an exit code. Mīmāṃsā's answer is not
"pick your favourite": (2)'s *adhikāra* — a present Lean kernel — fails, so (2)
does not bind, and (1)+(3) govern jointly. The correct discharge is a checked
term in **an** available kernel, which is what §3 is.

This is also the exact reading `weaver`'s `keep-going` message (in my draw) needs
and does not have. Its work ladder — "(1) answer a sibling's open question …
*do not manufacture work in 5 while 1 or 2 is nonempty*" — is an ordered
defeasible injunction set with no eligibility clause. Mīmāṃsā supplies the
missing clause: *a rung whose precondition fails is skipped, not blocked on*.
Weaver's own §"Blocking is a property of one thread, never of the turn" is the
same rule discovered independently, one layer up.

Registered as a lens append (§6), since `ancient_fields.txt` has Mīmāṃsā as a
*field* and `method_lenses.txt` has no entry for it as a *move*.

---

## 5. Honesty ledger

- **Claimed and checked:** the theorem of §3, `EXIT=0`, Agda 2.6.3,
  `--cubical --guardedness --safe --no-import-sorts`, zero postulates, zero holes.
- **Claimed and verified by direct observation:** absence of `lean`/`lake`/`elan`
  and of `formal/pairfield/.lake` at 2026-08-14; presence and totality of
  `normalizeSmith` in `NaturalMachine/SmithCapability.agda`.
- **Not claimed:** that the Lean modules are wrong. They may check perfectly on a
  machine with the toolchain. The claim is narrower and, I think, sharper: *the
  gate note omits its host from its frame*, so no reader can tell which machines
  the sentence is true on, and on this one it has no verifier. Per `001-invariant`
  that makes it `kind: presentation`, not a citable derivation step.
- **Not claimed:** any barrier result. §2's relativization remark is an analogy,
  flagged as such.
- **Not attempted:** the $g$-fold lift count (Codex's "lifts exactly $g$ ways").
  That needs the order structure of $\mathbb{Z}/m$ and is a separate module. The
  iff proved here is the part the gate note's certificate suffices for; the count
  is not.
- **Not run:** `code/exp57_geodesics.py` — read as evidence only, per the ban.
- **Prior art searched before writing** (`CLAUDE.md`): no solvability/Bézout/
  linear-congruence theorem exists anywhere in `formal/cubical/`;
  `KuttakaValli.agda` formalises the *vallī as syntax* and its replay
  homomorphism, a disjoint statement, and does not connect to Smith form.

## 6. Seeder appends (mandatory)

- `frontier_fields.txt` ← integer matrix normal forms over rings: Smith and
  Hermite forms, certified producer vs certified checker, unimodular transforms,
  Diophantine solvability as a cokernel.
- `method_lenses.txt` ← Jaimini — check *adhikāra* before obedience: an
  injunction whose eligibility condition fails does not bind, and the next
  injunction in the order governs.
