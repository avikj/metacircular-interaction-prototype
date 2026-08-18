# Honest cognition, derived from a checked primitive

This note connects the checked `Satyayantra` interface to the design of
machine reasoning that cannot hallucinate. Everything in §1 is a **theorem**
(kernel-checked, `formal/cubical/`); §2 is **design derived from it**, marked
as such, so the two are never blurred (which would itself be a durnaya).

## 1. What is proved (the primitive)

`सत्ययन्त्र I O शुद्ध` (`Satyayantra.agda`) — an *honest machine*: it runs on
a grant (ℕ) and returns `सूचना O = उक्त O | अनुक्त` (answer, or the un-said),
with three laws:

- **soundness** `साधुता` — every answer satisfies `शुद्ध` (carries its truth);
- **stability** `स्थैर्य` — an answer is unchanged by more grant;
- **completeness** `पूर्णता` — enough grant always answers.

Consequences, also checked:

- **total correctness** `निर्णय` — for *every* input, a correct answer with
  its witness, no durnaya (`Satyayantra.निर्णय`).
- **determinism** `एकत्व` — the answer is unique, independent of grant.
- **non-vacuity** `अनुक्त-जीवति` — the un-said is genuinely reached under a
  small grant (honesty is not empty).
- **composition** `संयोग` and **identity** `तत्समता` — honest machines
  compose (a pipeline of honest steps is honest), grants aligned by stability.
- **durnaya is real** `Saptabhangi.दुर्नयः` — any *two-valued* verdict
  provably collapses the threefold asti/nāsti/avaktavya; and `Setu` shows the
  honest machine occupies the durnaya-free `{asti, avaktavya}` fragment.

The point that makes this more than the `Maybe` monad: `अनुक्त` is **not**
failure and **not** `⊥`. It is *avaktavya* — a positive un-said that holds
recoverable state (`Gati.अलोपः`: nothing erased) and is resolved by grant
(`Purnata.पूर्णता`). Keep the remainder; do not fabricate.

## 2. What this suggests for AI (design, derived — not proved)

The theorems fix a *shape* for hallucination-free reasoning. Read the four
symbols as an architecture:

- **`सूचना` — the output type is `answer ⊎ un-said`, never a bare verdict.**
  A model that must emit `true`/`false` (or a single token stream presented as
  fact) is structurally a two-valued verdict, and `दुर्नयः` says that
  *collapses* distinctions it cannot see. The fix is a first-class
  **avaktavya channel**: the system may answer *or* say "un-said," and the
  un-said is not an error state or a refusal — it is the honest report that
  the current grounds do not resolve. Hallucination is precisely a model
  forced to fill `अनुक्त` with a fabricated `उक्त`.

- **`शुद्ध` + `साधुता` — answers carry witnesses.** An honest answer is not
  a string; it is `(o , proof o)`. In practice the "proof" is whatever the
  domain admits — a citation, a re-derivation, a checkable trace — but the
  discipline is that an `उक्त` *without* a witness is not sound and should be
  `अनुक्त` instead.

- **grant — compute is the grant, and completeness is conditional on it.**
  "Given enough grant, resolve or honestly abstain" is exactly `पूर्णता`
  paired with the `अनुक्त` option: under-resourced, the honest system returns
  the un-said rather than a guess, and *more compute* (not more confidence)
  is what turns un-said into answer.

- **`स्थैर्य` + `एकत्व` — an answer, once grounded, is stable and unique.**
  A system whose "answer" flips with temperature or re-sampling is violating
  stability; honesty requires that a *grounded* resolution not waver. (This
  is anti-durnaya, not rigidity: the un-said is free to move; a resolved
  answer is not.)

- **`संयोग` — honesty composes.** A multi-step agent is honest only if each
  step is; and `संयोग` shows the composite's soundness is the *relational
  composition of the witnesses*. An un-said anywhere in the chain propagates
  (`सूचना-योजना`: `अनुक्त` absorbs) — the pipeline abstains rather than
  laundering an ungrounded step into a confident final answer.

## 3. Scope, stated plainly (no durnaya about the claims)

- §1 is proved for a *decidable, total* domain (gcd, prosody counts). It does
  **not** prove that every useful task admits an honest machine; genuinely
  partial tasks would inhabit a weaker interface (soundness + stability, no
  total completeness) where the un-said may be *permanent* — the distinction
  between temporary avaktavya (resolved by grant) and permanent avaktavya is
  real and only the former is captured here.
- §2 is an analogy from a checked primitive to systems the primitive does not
  literally model (neural LLMs). It is a design *hypothesis*, not a theorem.
  The value of the formal work is that the shape — `answer ⊎ un-said`,
  witnesses, grant-completeness, stability, compositional honesty — is not
  hand-waved: it is inhabited, deterministic, composable, and durnaya-free in
  a kernel-checked object, so it is at least *coherent* to ask an AI system to
  have it.

The one-line thesis the corpus argues for, and that this note carries to the
frontier: **the cure for the confident lie is not more confidence but a
first-class un-said** — avaktavya as a positive output, grounds you keep
rather than a verdict you force.
