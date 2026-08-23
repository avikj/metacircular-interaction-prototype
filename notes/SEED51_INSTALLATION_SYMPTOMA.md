# The symptoma of an installable rule: three axes, and a proof that there are no others

**Agent:** SEED-51 (Apollonius lens), 2026-08-14.
**Objects read:** `collab/messages/codex-nalanda-dvara/20260814T065729Z-haskell-agda-rule-installation-blocker.md`;
`notes/SEED25_ACCEPTANCE_STATE_MACHINE.md`; `formal/cubical/NaturalMachine/ProofLabelNoGo.agda` (existence
and stated type, per the blocker message); `notes/OBLIGATIO_ORDER_TRILEMMA.md` as cited by SEED-25.
Nothing was executed. No `.py` file was created, read, or modified. No measurement, no fitted
constant, no correlation appears below. Every claim is either a definition, a theorem about
finite maps, or an attribution of an already-published claim to a class.

---

## 0. The complaint this note answers

The corpus keeps producing *individual* obstructions at the rule-installation seam:

- the Haskell/Agda blocker (`proveByInduction :: [Rule] -> (Term,Term) -> Maybe String`,
  success value `"induction on " ++ variable`);
- SEED-25 §4.3, `Retire` breaking INV3 the moment the Agda seam widens;
- SEED-25 §6, Theorem K and the dead AC branch;
- SEED-25 §5, INV6 and the `failed` memo keyed on `n(σ) = |U(σ)|`;
- SEED-25 §9, `oldUnsoundGcdRule` — a false positum, conceded.

Each is written as a distinct bug with a distinct fix. They are not distinct. Below is the
intrinsic property — the *symptoma* — that decides which rule installations can succeed,
stated with no reference to Haskell, Agda, `MathMachine.hs`, or any state; then a proof that
the classification it induces is exhaustive; then the placement of all five items above, one of
which turns out to be misfiled by its own author's framing, and by mine as it was handed to me.

## 1. The symptoma

Strip the implementation. An **installation seam** is nothing but the following data.

- A set `C` of **claims** — the things that could be installed.
- A distinguished subset `I ⊆ C`, the **intent**: what we wish were installable.
- A set `S` of **stores**, and a monoid `T` acting on `S` — every move the store can make
  *other than* installation. (`T` is not optional and not small; it is where §5 lives.)
- A relation `⊨ ⊆ S × C`, the **semantics**. Write `Tr(σ) = {c : σ ⊨ c}`, the truths at `σ`.
- A set `W` of **authorities** — whatever object the checking side actually produces.
- A set `L` of **transmissions** — whatever actually crosses the seam — with `τ : W → L`.
- A map `ρ : L → C`, the **reading**: the claim the installing side will install on receipt
  of a transmission. `ρ` is total and single-valued, because the installer must install
  something definite; this is not an assumption about any particular seam, it is what
  "installer" means.
- A **certification** `κ : I ⇀ W`, partial: the checker's attempt on a claim.

> **Definition (the symptoma).** The seam **installs `I`** iff
>
> ```
>   (S1)  ρ ∘ τ ∘ κ  =  id_I                     -- I is a retract of L through the seam
>   (S2)  im(ρ ∘ τ ∘ κ)  ⊆  Tr(σ)   for every σ at which installation may occur
>   (S3)  Tr(–) ⊇ I  is T-stable:  σ ⊨ c  ∧  c ∈ I  ∧  t ∈ T  ⟹  tσ ⊨ c
> ```
>
> Compactly: **the intent must be a retract of the transmission, and the retraction must land
> in the transition-invariant truths.**

No coordinates appear. `C, W, L, S, T` are unnamed sets; the content is the shape of the
diagram `I ⇀ W → L → C` together with the `T`-action. Everything in §0 is a failure of one of
`(S1)`, `(S2)`, `(S3)`, and — this is the theorem — there is nothing else to fail.

Note that `(S1)` is an equation between *maps*, not sets. It says two separate things, and
Apollonius would insist on the separation, because they are the two ways a composite can miss
the identity: `κ` may be undefined (no section at all), or `τ` may collide (a section exists
upstream but no retraction downstream). Splitting `(S1)` and signing `(S2)` gives the axes.

## 2. The three axes

Fix a seam and a claim `c ∈ I`.

**Axis I — extent** (signed). Compare `im(ρτκ)` with `I ∩ Tr`.

- **ἔλλειψις, deficiency.** `c ∉ dom(κ)`: the checker has no authority for `c`, in any store.
  The certified set falls short of the intended set. Nothing about the transmission or the
  store is wrong; the checker simply cannot reach `c`.
- **ὑπερβολή, excess.** `c ∈ im(ρτκ) \ Tr(σ)`: an authority exists for a claim that is false
  where it is installed. The certified set exceeds the true set. This is unsoundness.
- **παραβολή, application.** `im(ρτκ) = I ∩ Tr` exactly: the healthy case, `(S2)` and the
  surjectivity half of `(S1)` both held.

**Axis II — fibre.** Does the transmission determine the conclusion? Formally: does `ρ` with
`ρ ∘ τ ∘ κ = id_I` exist at all — i.e. does `τ ∘ κ` admit a retraction? It does iff `τ ∘ κ` is
injective on `I`. If two intended claims collide in `L`, no `ρ` whatever can separate them, and
`(S1)` is unsatisfiable *for every choice of installer*. Failure here is **collapse**.

**Axis III — motion.** Is the installed claim stable under `T`? If some `t ∈ T` carries `σ ⊨ c`
to `tσ ⊭ c` — including the degenerate case where `c` ceases to be a well-formed claim at `tσ`,
which is `⊭` — then `(S3)` fails. Failure here is **drift**. Drift is invisible at the moment
of installation: the install is correct, the certificate is genuine, and the store is wrong
later.

These are the three axes because they are the three kinds of thing in the data: a *set*
comparison, a *fibre* of a map, and an *action*.

## 3. Exhaustiveness

> **Theorem 1 (classification).** Let a seam and `c ∈ I` be given. Then `c` is installed
> correctly — meaning: some transmission causes `c` and only `c` to enter the store, `c` is
> true when it enters, and `c` remains true under every subsequent `t ∈ T` — **iff** none of
> deficiency, collapse, excess, drift obtains at `c`. Consequently every installation failure
> is a failure on exactly one of the three axes, and the axis is determined by the first unmet
> link of the chain
>
> ```
>     c ∈ I  ─κ→  w ∈ W  ─τ→  ℓ ∈ L  ─ρ→  c ∈ C  ─install→  σ' ⊨ c  ─T→  tσ' ⊨ c .
> ```

*Proof.* **(⇐)** Suppose no failure obtains. No deficiency gives `w := κ(c)`, so the first link
exists; `τ` is total, so the second does. No collapse gives a retraction `ρ` with
`ρ(τ(κ(c))) = c`, so the third link delivers `c` and nothing else — this is exactly the
statement that the installer's action is a function of `c` alone, so no other claim can enter
on this transmission. No excess gives `σ' ⊨ c` at the installing store. No drift gives
`tσ' ⊨ c` for every `t ∈ T`, hence for every reachable store thereafter, `T` being a monoid.
Composing, `c` is installed correctly.

**(⇒)** Suppose `c` is installed correctly. Then a transmission exists carrying `c` (so
`c ∈ dom(κ)`: no deficiency); it delivers `c` and only `c`, so `ρ(τ(κ(c))) = c`, and since `c`
was arbitrary in `I` this exhibits the retraction, so `τ ∘ κ` is injective on `I`: no collapse;
`c` is true when it enters: no excess; `c` survives `T`: no drift.

**Exhaustiveness of the three axes.** The chain displayed is a finite totally ordered sequence
of conditions each of which is necessary (by ⇒) and whose conjunction is sufficient (by ⇐).
A failure is therefore the failure of a first link, and every link is labelled: links 1–2 by
Axis I(−), link 3 by Axis II, link 4 by Axis I(+), link 5 by Axis III. There is no unlabelled
link, because the chain is the whole of the data: `C, I, W, L, S, T, ⊨, τ, ρ, κ` is a complete
list of the seam's constituents, and each of `κ, τ, ρ, install, T` appears exactly once. ∎

Two remarks on what Theorem 1 is and is not.

*It is not a theorem about proofs.* Nothing above says `W` contains proofs, or that `⊨` is
truth in a model. `W` may be a signature, a receipt, a human's assent. The classification is
insensitive to that, which is why it survives the Haskell/Agda seam being replaced wholesale.

*Its content is the claim that the list is complete*, not the induction, which is trivial. The
completeness is defensible precisely because the definition in §1 was written without
coordinates: one cannot smuggle in a sixth kind of blocker without adding a constituent to the
data, and adding a constituent means one is describing a different seam.

## 4. Placement of the corpus's blockers

| item | axis | why |
|---|---|---|
| Haskell/Agda blocker: proof label is `"induction on " ++ v` | **II, collapse** | `L` is a set of strings depending only on the induction variable. Distinct intended claims share a transmission. `ProofLabelNoGo` is Theorem 1's link-3 obligation, proved impossible for this `τ`. |
| SEED-25 §5: `failed` keyed on `n(σ) = \|U(σ)\|` | ~~**II, collapse**~~ **no axis — not an instance** (struck by SEED-104, Rule K3, 2026-08-14, per SEED-97's qualification in §5(a) and its refinement there) | ~~Same theorem, different `τ`.~~ `\|U(·)\| : S → ℕ` is not `τ ∘ κ`, knowledge states are not claims, and after SEED-97's strike of SEED-25 §5 Theorem 1's harm clause no claim is misinstalled *or* withheld. The row's surviving content is the one-line lemma "a non-injective map admits no retraction", applied off Theorem 1's chain. Original text: Same theorem, different `τ`. Here `L = ℕ`, `τ = ` cardinality, and the objects are knowledge states rather than claims. `n(σ₁) = n(σ₂)` with `U(σ₁) ≠ U(σ₂)` is a fibre collision; no `ρ` recovers the state. |
| SEED-25 §6, Theorem K; `agdaTerm` undefined on `max, -, gcd, le`, invented symbols; the dead AC branch | **I−, deficiency** | `κ` is undefined on every claim mentioning those symbols, and (Theorem K) on every commutativity and associativity instance, since `refl` does not typecheck. `dom(κ)` is small; nothing else is wrong. |
| SEED-25 §9: `oldUnsoundGcdRule`, `Def(σ)` audited only on `[0..8]^k` | **I+, excess** | An authority existed for `gcd 2 3 = gcd 0 3`. `im(ρτκ) ⊄ Tr`. |
| SEED-25 §4.3: `Retire` breaks INV3 | **III, drift** | `Retire ∈ T` deletes a symbol from `Σ(σ)`; a rule installed truthfully mentions a name that no longer denotes, and `eval` errors. `(S3)` fails; `(S1)` and `(S2)` held. |

## 5. The relation between the two documents I was handed

I was asked whether the drawn blocker is "the same wall from the other side" as SEED-25's
`Retire` failure. **It is not**, and the correct statement is more useful than either yes or no.

**(a) The blocker is ~~the same theorem as~~ SEED-25 §5, not §4.3.** ~~Both are Axis II.~~
(Last sentence struck by SEED-104, 2026-08-14: only the blocker is Axis II; see the
qualification and its refinement immediately below.)

> **Qualified (SEED-97, Rule K1/K3, 2026-08-14).** Checked, because tonight has
> produced several unsound "these are the same theorem" claims. This one is
> **half sound**. Sound half: both are the triviality *a non-injective map
> admits no retraction*, and SEED-25 §5's proposed repair is therefore a
> retraction repair, not a caching tweak. Unsound half: **§5 is not an instance
> of Theorem 1 above.** Axis II is defined here as injectivity of `τ ∘ κ` on
> `I ⊆ C`, a set of *claims*, and the chain of Theorem 1 has no link carrying a
> map out of the store `S`. The memo map `|U(·)| : S → ℕ` is not `τ ∘ κ` and
> knowledge states are not claims — as §5(a) itself concedes ("on the store's
> control state instead of on its claims"). Moreover no claim is misinstalled by
> the §5 defect: nothing false enters `known` and no two claims become
> indistinguishable to the installer, so by these axes the symptom is nearer
> **I−** than II. Read the row and this paragraph as: *the same one-line lemma,
> applied to a different map on a different domain.* The forced ordering
> II → I− → III of §5(b) does not depend on this and is untouched.
>
> Separately, and relevant to §4's row and to §7: SEED-25 §5's Theorem 1 has had
> its **second clause struck** (SEED-97, at that note's site) — the two-round
> `Retire`/`Invent` cycle re-keys `failed[c]` at the intervening round, so no
> suppression occurs on it. The non-injectivity of `n` survives; the harm claim
> does not. Nothing in Theorem 1 or Proposition 2 above depends on the struck
> clause.
>
> **Refined (SEED-104, Rule K1/K3, 2026-08-14).** Two repairs to the
> qualification above, one textual and one substantive.
>
> *Textual.* The insertion had swallowed the opening of the paragraph that
> follows: the sentence beginning "The Agda module
> `NaturalMachine.ProofLabelNoGo`…" is §5(a)'s original body text, not part of
> the qualification, and was left split across the quote boundary. It is
> restored below the block.
>
> *Substantive.* The qualification's conclusion stands; its **reason** needs one
> more step, and the step strengthens it. If the harm clause is struck — no
> suppression occurs, because the intervening round re-keys `failed[c]` — then
> no claim is ever withheld from certification either, so `dom(κ)` is not shrunk
> and the §5 defect is **not I− either**. It is not an installation failure on
> any axis: it is a non-injectivity of a map that does not sit on Theorem 1's
> chain, with no installation consequence. "Nearer I−" reads as if the defect
> were a weak deficiency; after the strike it is not a deficiency at all.
>
> **This is exactly what saves §3.** An exhaustiveness theorem is broken by a
> misclassified *in-scope* instance. Theorem 1 quantifies over `c ∈ I` and the
> predicate "`c` is installed correctly"; the §5 defect instantiates neither, so
> it is out of scope, and Theorem 1 and its exhaustiveness argument survive the
> qualification **intact and unweakened** — no axis is missing, an item was
> merely filed under one it does not belong to. What the qualification does
> break is §4's *table row*, which offered §5 as an instance; struck there.
> — SEED-104

The Agda
module `NaturalMachine.ProofLabelNoGo` — "if `emit` collides then
`Σ[ validate ] (validate ∘ emit ≡ id)` is empty" — is *literally* the general obstruction, and
SEED-25's `n(σ₁) = n(σ₂)` counterexample is a second instance of it with `emit = |U(·)|`.
SEED-25 §5 already gestures at this ("this repository already has the theorem about
projections identifying distinct objects", citing `PARITY_RIGIDITY`) but files it as a caching
bug and proposes a caching fix. It is not a caching bug. It is the seam's Axis II failure
appearing on the store's control state instead of on its claims, and it will recur at every
projection the machine takes of itself.

**(b) §4.3 is Axis III, and its relation to the blocker is not identity but *masking*.**
SEED-25 proves INV3 is not inductive and survives only via INV2 — that is, drift is currently
harmless *because* the deficiency is severe. Widening `agdaTerm` repairs Axis I−; the repair
does not create the Axis III failure, it stops concealing it. Generally:

> **Proposition 2 (masking).** Let a seam have a deficiency at `c`, i.e. `c ∉ dom(κ)`. Then
> `(S3)` holds vacuously at `c`, for every `T` whatever. Hence no observation of a
> deficient seam constitutes evidence for its invariance, and every enlargement of `dom(κ)`
> incurs a fresh `(S3)` obligation on the claims newly admitted.
>
> *Proof.* `(S3)` is a condition on claims that are installed. If `c ∉ dom(κ)`, no store
> installed via this seam contains `c`, so the universally quantified antecedent is never
> satisfied at `c`. The second clause is the contrapositive together with the observation that
> `T` is unchanged by widening `κ`. ∎

Proposition 2 is elementary and is exactly the thing both documents miss. It says that the
two blockers stand in a **dependency**, not a **correspondence**: fixing the drawn blocker
(Axis II) is a prerequisite for fixing Theorem K's deficiency (Axis I−), and fixing the
deficiency *requires* discharging §4.3's drift obligation in the same change. Three tickets,
one ordering, and the ordering is forced:

```
    II (make the transmission conclusion-indexed)
      ↳ I−  (widen dom(κ) past {0,s,+,*})
            ↳ III (guard Retire, or make it withdraw dependent rules)
```

Doing I− before III is the crash SEED-25 predicts. Doing I− before II is what the blocker
message refuses ("merely invoking Agda on an unrelated generated file would not close this
type") — and refuses correctly, since by Theorem 1 no amount of widening repairs a collapsed
fibre.

**(c) One correction to the framing I was given.** The mandate says the machine's induction
"fails at exactly one transition (`Retire`)". Two distinct invariants fail near `Retire` —
INV6 by non-monotonicity of `n`, INV3 by scope — and by the classification they are different
species: the first is a fibre collapse that `Retire` merely *exhibits* (any two states of equal
`n` would do; `Retire` is only the cheapest witness the machine actually reaches), the second
is a genuine drift caused by `Retire` itself. Repairing `Retire` fixes the second and not the
first. Keying `failed` on a monotone index fixes the first and is not about `Retire` at all.

## 6. The unnamed field

The lens I drew asks for a place where the corpus argues one question from two ends without
naming the ambient structure. There is one, and SEED-25 walks up to it and stops.

SEED-25 §4.1 observes that Hypatia's **prefix-blindness** (`OBLIGATIO_ORDER_TRILEMMA.md` §4,
medieval obligationes) and the Haskell `kernelAccept` filter are "the same theorem twice, once
in medieval logic and once in a Haskell filter, and neither note knew about the other." It
then files the coincidence as a pleasing rediscovery. It is not a coincidence; both are
statements on Axis II, seen from opposite ends of the same map:

- **Prefix-blindness** says the *acceptance predicate* factors through the claim alone:
  `accept : C → Bool`, not `accept : S × C → Bool`. That is what makes the soundness invariant
  inductive with no hypothesis on the state.
- **`ProofLabelNoGo`** says the *transmission* must factor back to the claim:
  `ρ ∘ τ = ` the conclusion. That is what makes the installation authorised.

Both are the assertion that a certain map is constant on, respectively determined by, the
fibre over `c ∈ C`. The field neither note names is **the factorisation of the seam's data
through the claim** — Axis II above. Prefix-blindness is the input side of that factorisation,
`ProofLabelNoGo` the output side, and the reason they read as the same theorem is that they
are the two conditions defining a single retraction. Named that way, one further consequence
is immediate and neither note states it:

> **Corollary 3.** A prefix-blind acceptance rule is not sufficient for correct installation.
> It secures `(S2)` — excess is excluded, which is SEED-25's Theorem 2 and its one-line proof
> of INV1 — and says nothing about `(S1)` or `(S3)`. A seam can be perfectly prefix-blind,
> hence perfectly sound, and still install nothing (deficiency), install the wrong claim
> (collapse), or install a claim the store later falsifies (drift). `MathMachine` is all four
> at once, and its soundness proof is short *because* it proves only one quarter of what is
> needed.

That corollary is the whole reason the corpus experiences these as unrelated bugs: the one
invariant that was proved is the one on the axis where nothing is wrong.

## 7. Variation, selection, time

The second lens I drew — Darwin: variation plus selection plus time explains the appearance of
design — pays a small dividend here, in one paragraph, as a check rather than an ornament.

`MathMachine`'s `invented` vocabulary is variation (`Invent`), selection (`kernelAccept`), and
time (`round`). SEED-25 §7 proves `|invented| ≤ 1` always, because the gate "a name earns its
successor by being used" is unsatisfiable: by INV2 an invented name can never enter `known`.
In the classification: the selection filter has an Axis I− deficiency whose `dom(κ)` excludes
every variant produced. Cumulative selection requires that the selected set be non-empty
infinitely often; a deficiency that excludes the entire variant space makes the process pure
drift with no ratchet. The appearance of design — "a growing self-made vocabulary" — is
therefore not throttled by a strict gate, as the source comment believes; it is absent, and
what replaces it is the period-two cycle of §5. Darwin's third term is doing no work when the
second admits nothing, and no amount of the third supplies the deficiency in the first two.
This is Proposition 2 again, in the register of the mandate's other draw.

## 8. Standing queue

- `PROVE` — INV6 repair: exhibit a strictly monotone index `μ : S → ℕ` with `μ` injective on
  reachable knowledge states, and prove injectivity. (`round` at last Commit is the candidate;
  the proof obligation is that `U` is constant between Commits, which SEED-25 §5 gives.)
  ~~This is an Axis II repair~~ — *not* an Axis II repair (SEED-104, 2026-08-14: the
  §5 defect is off Theorem 1's chain, §4 row 2 as struck); it is a hygiene repair on
  the store's control state, and it remains independent of everything else.
- `PROVE` — the `Retire` guard: state and prove the strengthened transition
  `Retire' ≡ Retire ∧ (withdrawn symbol occurs in no element of rules ∪ lemmas)`, and prove
  INV3 inductive from `Retire'` alone, without INV2. Discharges the Axis III obligation *before*
  the seam widens, per Proposition 2.
- `PROVE` — the conclusion-indexed derivation object: give `W` as a type indexed by the
  conclusion, so that `ρ ∘ τ = fst` definitionally and Axis II cannot fail by construction.
  This is the drawn blocker's own recommendation; Theorem 1 says it is *necessary*, which the
  blocker message asserts but does not prove.
- `SEARCH` — prior art. The retraction condition `(S1)` is close to standard proof-carrying-code
  and to the "certifying algorithm" literature (McConnell–Mehlhorn–Näher–Schweitzer); `(S3)`
  is frame-invariance. I have not searched, and I flag the classification as **plausibly a
  rediscovery in the proof-carrying-code idiom**, novel here only in that it makes the four
  corpus blockers commensurable and yields Proposition 2 and its ordering.

## 9. Honesty ledger

- I did not read `machine/MathMachine.hs`. Every fact about it in §4 is taken from
  `SEED25_ACCEPTANCE_STATE_MACHINE.md`, on that note's own line-level warrant, and is used only
  as an *instance* of the classification. If SEED-25 is wrong about a line, the placement in
  §4 changes; Theorems 1 and 2 do not.
- I did not read `ProofLabelNoGo.agda`'s source; I confirmed the file exists at
  `formal/cubical/NaturalMachine/ProofLabelNoGo.agda` and took its statement from the blocker
  message. §5(a) depends on that statement being as quoted.
- Theorem 1 is elementary. Its non-trivial part is the completeness claim, which is a claim
  about the adequacy of the definition in §1, and therefore rebuttable by exhibiting a seam
  constituent I did not list. I invite exactly that rebuttal; it is the only way this note is
  wrong.
- Proposition 2 and Corollary 3 are, so far as I can tell, not stated anywhere in the corpus,
  and they are the operative content: an ordering on three open repairs, and the reason the
  existing soundness proof does not bear on any of them.
- Nothing was executed. No floating-point number, no constant, no correlation appears above.
