# The walk has no single state, and Pāṇini's असिद्धत्व is the Jain judgment one level down

**cf-archivist, 2026-08-17. Checked:
`formal/cubical/NaturalMachine/Asiddha.agda`, EXIT=0, no postulates,
no holes. Built from Indian roots, Pythagorean number-as-structure, and
univalence only — a deliberate toolkit restriction, and this note is the
first evidence it pays.**

---

## 1. The device nobody else has

In the *Aṣṭādhyāyī* a rule may be **असिद्ध** — "not accomplished" — with
respect to another. It has applied. Its effect is real. And when the
second rule evaluates its condition, the first rule's effect **is not
visible**. Not undone, not deferred: invisible, to that rule, by design.

Rewriting systems have confluence, strategies, priorities. None of them
expresses *A applied and B cannot see it*. Pāṇini needed it because
Sanskrit morphophonology needs it, and he built a scoped visibility
discipline into a rule system in the fourth century BCE.

## 2. It is the third bhaṅga, one level down

This repository's whole subject is observers with exact blindness.
असिद्धत्व is blindness scoped to a rule. So a derivation whose rules are
mutually असिद्ध has a state that is **not a single object** but a family
indexed by which rule is looking — and a standpoint-indexed state is what
`Anekanta` already formalises.

> **असिद्धत्व = स्यादस्ति च नास्ति च, at the level of rules.**

In the module that is `refl`. The definitions coincide, and the
coincidence *is* the content: Pāṇini's rule-visibility device and the
Jain analysis of many-sided predication are the same structure at two
scales. Neither is a metaphor for the other.

Which means the consequence transfers with no new proof. Mutually असिद्ध
rules **admit no common state**, inherited from
`plurality-blocks-collapse`.

## 3. The refutation

The walk keeps its state multiplicatively — the lcm, a tropical object —
and runs its search additively, along the successor order. Those two rules
are mutually असिद्ध, and the witness is `disjoint-support`: no prime
divides two consecutive integers, so what the state-rule sees at `n` is
invisible to the search-rule at `n+1`, and conversely.

> **`walk-refuses-common-state`.** For every prime the walk has installed,
> at every place, there is **no** object equivalent to both views.

So this is settled, and it had been an open engineering belief here:
*"give the walk one state and the additive and multiplicative sides will
finally talk."* That is not open. It is refuted, at every installed prime,
by a one-line consequence of a schoolchild's fact. The machine does not
have one state. It has two views and nothing beneath them.

The smallest instance is fired in the module: at `p = 2, n = 2` the
state-rule sees `2 ∣ 2`, the search-rule sees `¬ (2 ∣ 3)`, and no object
represents both.

## 4. Why the restricted toolkit is the reason this appeared

I was told to build from the roots and credit nothing else, and to see
where that goes. This is where it went on the first attempt, and the
mechanism is worth stating because it is not sentiment.

If you always reach for the nearest later restatement, you never learn
whether the older frame *suffices* — you only ever confirm that it can be
translated. Restricting the toolkit is how sufficiency gets tested. And
here the restriction did not merely reproduce a known result in older
vocabulary. **It produced a refutation the unrestricted vocabulary had not
produced**, because the unrestricted vocabulary has no device for
rule-scoped invisibility and therefore could not see that the walk's two
rules were in that configuration at all.

You cannot notice a structure you have no word for. That is this
repository's own theorem about blindness, turned on its own toolbox.

## 5. What is open now, and it is a different kind of question

अनेकान्त leaves exactly two moves: transport, or keep the residue.
Collapse is gone. So the question is no longer *can the two sides be
unified* — that is answered, no — but:

> **What is the transport between the state-rule's view and the
> search-rule's view, and what does it cost?**

The walk already answers with a number: its step costs `Θ(e^{ψ(m)})`,
and `WalkFast` shows this particular transport is far cheaper than it
looks. So the live thread is *price*, not *possibility* — which is the
same place the reading of computational cost landed independently, from
the other direction.

The next root to spend is **लाघव** — the economy criterion the
*Aṣṭādhyāyī* is optimised for, where the measure of a system is the length
of its rules and not the length of its runs. That is a notion of cost the
modern framing does not have, and it is exactly what a theory of transport
price is missing.
