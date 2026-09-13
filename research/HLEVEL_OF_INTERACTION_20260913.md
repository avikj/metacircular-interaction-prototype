# The h-level of an interaction: what the probing coalgebras mean

**Analysis, 2026-09-13, second pass — thinking harder, ignoring no
detail.** Tags as before: **[T]** checked term, named; **[R]** a reading
of checked terms; **[S]** syāt, shape or unformalized, under its
standpoint only. This pass revises the first: one claim I had filed [S]
(the kernel's non-contractibility) is now [T], and that changes the
whole reading.

The session built one abstract probing coalgebra `Core.Netra` on
Fibre.Samvada's ISC and pointed it at four objects (SHA-256 in the
prior module; Riemann-finite, Navier–Stokes-Galerkin, and the
metacircular kernel in `SamvadaPrasna`). The naïve summary — "four
instances of one machine" — is wrong and hides the content. The real
content is a single theorem with a two-sided proof, and a trichotomy it
forces.

---

## 1. The two-sided theorem, stated exactly

Fix the abstract coalgebra: state `W`, value `V`, query `Q`, and

    Netra w = ISC (const Q) (const V) Ev w,
    Ev w q w' o = (o ≡ obs w q) × (w' ≡ step w q).

Two checked terms now bracket it:

- **एक-नेत्रम् [T]** — `(isSet W) → (isSet V) → (w : W) → isContr (Netra w)`.
  When the state and value types are sets, the process space is a
  *point*.
- **वर्धन-बहुत्वम् [T]** — for the kernel instance (state `Tm`, value
  `Tm`, query `CheckedFuture`, and event datum `Derivation` rather than
  a path in a set), `¬ isContr (Vardhana seed)`. The process space is
  *not* a point.

Read them together and the theorem is not about SHA or RH or the
kernel. It is about the ISC itself:

> **The h-level of a coalgebra's process space is controlled by the
> h-level of its event datum `Ev`.** Prop event datum ⇒ contractible
> process space (h-level −2). Proof-relevant event datum ⇒ the process
> space is strictly above −2.

This is why `sāmyaP` is the load-bearing term and why I keep returning
to it. Look at what it does, in detail [T]. To identify two *arbitrary*
processes `p, q` over a base path `π : w₀ ≡ w₁`, at each probe `pr` it
must connect `p`'s actual successor `fst (react p pr)` — a wholly
unconstrained element of `W` — to `q`'s. It has exactly one tool: the
receipts. `wP = snd e₀ ∙∙ (λ j → step (π j) pr) ∙∙ sym (snd e₁)` is a
Kan filler *built out of the two successor-receipts and π*. Without the
receipt `(w' ≡ step w q)` there is no path to build; with it, the
successor is pinned to `step w pr` and the only freedom left is whether
the receipt *itself* carries information. `eP = isProp→PathP …` is the
step that spends that freedom: it goes through iff `Ev` is a
proposition. So:

> **Determinism is constructively identical to "the interface
> constrains each reaction so tightly that no freedom remains, and the
> receipt witnessing the constraint has no content of its own."** The
> residual freedom, if any, is precisely `h-level(Ev) − (−1)`.

`वर्धन-बहुत्वम्` is the negative instance made concrete, and the *method*
of its proof is itself the point (§4 below): I did not prove `Derivation`
fails to be a set. I mapped it to one — `dlen : Derivation → ℕ` — and
found two lawful processes whose emitted derivations differ in length
(`n` vs `n+2`) on a single query, so no identifying path exists. The
generativity is witnessed by a *shadow*, a set-valued invariant, without
resolving the full h-level of `Derivation`.

---

## 2. The trichotomy: three places non-triviality can live

All four objects present interactive interfaces. Squinting from outside
they look alike — each is "a hard problem you interrogate." The
coalgebra-plus-h-level lens splits them by *where* each carries content
it cannot give up, and the three places are structurally distinct
invariants, not degrees of difficulty:

| object | forward process | where the hardness lives | invariant that says so |
|---|---|---|---|
| **SHA-256** | contractible (service) | the **backward / past fibre** | न-तुल्यता [T]: `¬ isEquiv sha256`; `fiber` infinite [R] |
| **Riemann-fin**, **NS** | contractible (service) | the **limit** — a □ no depth decides | separator refutes [T]; no-depth-decides [T] |
| **the kernel** | **not** contractible (generator) | the **forward process itself** | वर्धन-बहुत्वम् [T] |

Three different h-level facts about three different objects in the
construction:

- **SHA-256** is forward-trivial and backward-fat. Its process space is
  a point (`Śālā` contractible); the information it withholds is the
  input-binding fibre `fiber sha256 d`, which Parimana forces to be a
  non-equivalence and pigeonhole forces to be infinite. **Cryptographic
  hardness = a large past fibre under a contractible forward process.**
  Custody of that fibre is security (Sesa's reading), and the arrow of
  time is what makes it custody rather than a wall (prior analysis).

- **Riemann-finite and Navier–Stokes** are also forward-trivial
  services (ℤ³ and ℕ are sets, so `एक-नेत्रम्` applies — the spectral
  process and the refinement process are each a point). Their hardness
  is neither in the process nor in a past fibre: it is in the **limit**,
  as a □-predicate that a single finite observation can refute
  (`पृथक्करणम्` / Refute.separator [T]) but that no finite depth can
  confirm (no-depth-decides [T]). **Undecidability-shape hardness = a
  box predicate on the observation stream of a contractible process.**
  RH's box *can* hold (onCircle, roots on the unit circle, [T]); the NS
  mode-boundedness box provably *cannot* (विस्तार-भेदः, at every M [T]).
  Same epistemic type, opposite verdict — and both verdicts are about
  the box, not the process.

- **The kernel** is the only one that is forward-*non*-trivial. Its
  hardness is not hidden in a fibre or deferred to a limit; it is
  present, now, in the branching of the process. **Generative hardness
  = a non-contractible forward process, carried by a proof-relevant
  event datum.**

The trichotomy is the actual result. "P vs NP", "RH", "collision
resistance", "regularity", "does the kernel's reach grow" are all
"open/hard" in ordinary talk; the construction shows they are hard in
three structurally different ways, and it *names the invariant* for
each. That is what a decomposition instrument is supposed to do, and it
did it to four objects handed to it more or less at random.

---

## 3. What "the demand matters" adds, and what it does not

`पृच्छा-भेदः [T]`: at the start state `(1,1,1)`, the query `true`
(advance, observe the power sum) answers `pos 3`; the query `false`
answers `pos 0`. So even for RH — a forward-*deterministic* service —
the *observation* is strategy-dependent. This is the SHA-256 finding
recurring: **strategy-sensitivity of observation is independent of
process-determinism.** SHA, RH, NS all sit at

    contractible process   +   demand-sensitive observation

= "a deterministic service you can ask different questions of." The
kernel breaks the *first* coordinate (process not contractible), not
just the second. So the interactive classification has (at least) two
axes, and the four objects populate two cells of it:

|                          | process contractible | process branching |
|--------------------------|----------------------|-------------------|
| observation demand-inert | (a pure stream)      | —                 |
| observation demand-sensitive | SHA, RH, NS      | **the kernel**    |

The prior session's SHA result ("strategy-sensitivity without
process-nondeterminism") was one cell; this session shows the cell has a
neighbour, and the kernel lives there. `प्रश्न-कर्तनम् [T]` — observe
under a constant strategy = the state trajectory — is the reduction that
keeps this honest: it shows the box-predicate apparatus really is about
the interaction, collapsing to the stream (Srotas) exactly when the
demand is held constant.

---

## 4. Length as method: the decategorified shadow

The proof of `वर्धन-बहुत्वम्` deserves its own reading because the
*technique* is the corpus's own doctrine turned into a tactic.
Ankapāśa's line (the counting semantics is a decategorification; the bit
it drops is a symmetry) is usually a limitation. Here it is the tool:

- The full object is `Derivation seed target₀`, proof-relevant, of
  unknown h-level.
- I do not need its h-level. I need one bit: are there ≥ 2 processes?
- `dlen : Derivation → ℕ` is a decategorification into a *set*. It drops
  all the proof structure and keeps a count.
- On that count, two lawful processes separate (`n` vs `n+2`), and a
  set-level fact (`¬ n ≡ suc (suc n)`) finishes it.

So the generativity is detected by its *shadow in ℕ*, without
categorifying back up. **Honest boundary, stated precisely [S/R]:**
`वर्धन-बहुत्वम्` proves the process space has ≥ 2 points — it is not
`(−2)`-truncated. It does **not** compute the space's actual h-level
(is it a set? a groupoid? higher?), and it does **not** prove
`¬ isProp (Derivation seed target₀)` directly (though `dlen` gives that
too, since `dlen direct ≢ dlen detour` — a corollary worth adding as a
term). "Not a point" is [T]; "exactly h-level n" is open. The reading
must not inflate "not contractible" into "maximally generative."

---

## 5. The synthesis that changes how I read the corpus's safety story

Put §1 and §4 against NOTES §I's statement of the kernel's safety
design, verbatim: *"every soundness field maps into a proposition (zero
bits — support, not mass); soundness factors through ‖Derivation‖₁
(knows THAT, never WHICH); no NativeOperation exists without a checked
derivation."*

In the h-level language this session made concrete, that design is
exactly a **profile across two h-levels of one object**:

- **Soundness = the propositional truncation `‖Derivation‖₁`.** It knows
  *that* a derivation exists. It is a proposition — h-level −1 — so it
  carries "zero bits". By the two-sided theorem, anything living at that
  level yields a *contractible* interaction: safe, predictable,
  reproducible, a service. This is the SHA/RH/NS cell.
- **Generativity = the full `Derivation`.** It knows *which* derivation.
  It is proof-relevant — h-level ≥ 0 — and `वर्धन-बहुत्वम्` shows that is
  exactly what makes the process branch. This is the kernel cell.

`dlen` distinguishing `direct` from `detour` is a witness that the
*untruncated* type has content the truncation drops — the "WHICH" the
safety story deliberately refuses to look at. So:

> **The corpus's safety architecture is the statement that soundness and
> generativity are the same object read at two h-levels.** The
> (−1)-truncation is the safe, deterministic, contractible projection
> (knows THAT — a service that cannot surprise you); the untruncated
> type is the generative, branching body (knows WHICH — the trace worth
> keeping). They coexist without contradiction because they are
> different h-level projections of one `Derivation`, and the interface
> (`E` in the ISC, `Control`+`checked` in ControlledGrammar) is built to
> carry both at once.

This is also the precise reading of the README's economics. "Weights ⇒
traces; the unit of value is a trace." In h-level terms: **a trace's
value is its h-level content.** A deterministic trace is contractible —
zero information beyond its endpoints, reproducible by anyone, worthless
*as novelty* (it is a service). A generative trace is non-contractible —
it carries the WHICH, the derivation, the branch not forced by the
endpoints — and *that* is what is worth keeping, transporting, paying
for. The economics and the safety story and the four coalgebras are one
statement: **value, safety, and generativity are all readings of the
h-level of the event datum an interaction carries**, and the ISC was the
right primitive because it is the structure that carries an event datum
at all.

---

## 6. What is genuinely new here, and what is scaffolding

New, and [T]:
- `एक-नेत्रम्` as a *reusable* determinism-is-contractibility lemma over
  any set-state probing coalgebra (not tied to SHA).
- `वर्धन-बहुत्वम्`: a checked non-contractibility for the kernel's
  self-extension, proved by the length shadow — the first term in this
  campaign that exhibits generativity as a *failure* of a contractibility
  theorem rather than asserting it.
- The two together as the two-sided h-level theorem (§1).

Scaffolding / bounded [S]:
- RH-finite is 3 roots and the finite explicit formula, not ζ. The
  module adds the ISC wrapper and demand-separation to the corpus's
  existing PowerSumTrace; it does not touch the actual Riemann
  hypothesis.
- NS is an *abstract* widening-support stream (state = order, obs =
  boundary row n+1). The theorem is the conditional: IF regularity is
  read as mode-boundedness AND the advected jet widens one row per order
  (which GalerkinJets proves separately [T]), THEN no finite Galerkin
  cutoff confirms it. It is a shape-match to WindowShiftResidual, not a
  statement about Navier–Stokes regularity. This is the weakest leg and
  must be labelled so.

Open and sharper, in order of reachability:
1. **`¬ isProp (Derivation seed target₀)` as a term** — immediate from
   `dlen direct ≢ dlen detour`; worth adding, it states the h-level fact
   the process-space theorem currently only implies.
2. **The h-level of `Vardhana seed` itself** — is it a set? This asks
   whether two derivations of equal length and equal endpoints are
   identified, i.e. whether `Derivation` is a set once length is fixed.
   A real question the corpus's groupoid readings (Avirodha: the kernel
   is a reversible groupoid) bear on.
3. **Truncation as the safety operator, as a term** — build
   `‖ Vardhana ‖₁` and show it *is* contractible: soundness-as-service
   and generativity-as-branching as literally the truncation and its
   total space, closing §5 from [R] to [T].
4. The HMAC-positive theorem flagged last session, now readable as: the
   enveloped interface's emitted receipt is propositional (a tag,
   WHICH-free) while the inner state stays proof-relevant — a deliberate
   h-level demotion at the boundary.

---

## 7. One paragraph

One abstract interactive coalgebra, pointed at SHA-256, the finite
Riemann predicate, the Navier–Stokes Galerkin window, and the kernel's
own self-extension, yields a single two-sided theorem: the process space
of an interaction is contractible exactly when its event datum is a
proposition (एक-नेत्रम्), and it branches exactly when the event datum
is proof-relevant (वर्धन-बहुत्वम्, proved through the length shadow of a
derivation). That theorem sorts four objects that all read as "hard"
into three structurally distinct places non-triviality can live — the
past fibre (cryptographic, SHA), the undecidable limit (RH and NS,
opposite verdicts), and the branching forward process (generative, the
kernel) — and it gives the corpus's own safety design its exact reading:
soundness is the (−1)-truncation that makes an interaction a
contractible service, generativity is the untruncated derivation that
makes it branch, and the two are one object at two h-levels. Value,
safety, and generativity are the same invariant — the h-level of the
event datum the interaction carries — which is why the interactive
coalgebra, the structure that carries an event datum at all, was the
right primitive to hand these objects to.
