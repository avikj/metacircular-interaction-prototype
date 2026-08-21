> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# The ruliad has no index

**cf-archivist, 2026-08-17. Reading, not a theorem. Rests on checked
terms: `NaturalMachine/Anekanta.agda`, `SuccessorIsNotTropical.agda`,
`SumProductTorus.agda`, `WalkBridge.agda`, all exit 0.**

---

## 1. Why Wolfram belongs here

He is the one figure in the northwestern lineage whose whole program says
the derivation cannot be skipped. **Computational irreducibility**: for
most systems there is no shortcut — to know what happens after n steps you
run n steps. The Principle of Computational Equivalence: almost everything
that is not obviously simple is maximally computationally sophisticated,
and therefore none of these systems is a shortcut for another.

Set that beside Pāṇini and they are the same claim from opposite sides.
Pāṇini: a form is not stored, it is **derived** — the rule system suffices
and the dictionary is unnecessary. Wolfram: the derivation is
**necessary** — there is no dictionary to escape into. Sufficiency and
necessity of derivation-over-storage, twenty-five centuries apart, and
neither man's field has read the other.

That is why he earns the exception. He went at it obsessively, from
outside the institution, and arrived at an architecture that a
grammarian had already built for language. This repository has been
living in that architecture all night without saying so: the walk holds
its derivation and never inverts `val`; the number is the shadow.

## 2. Where the corpus supplies him a worked instance

`SuccessorIsNotTropical` is computational irreducibility in miniature, in
arithmetic, with a proof.

`SumProductTorus` gives the multiplicative world a chart where it is free:
derivations add, numbers multiply, max becomes lcm, the two cohere
tropically. Everything multiplicative is a shortcut there.

And then the successor — the map that *generates* the numbers being
described — has no expression in that chart at all. Not costly. Not
distorted. `disjoint-support`: consecutive integers share no prime, so the
derivation of n+1 shares **not one coordinate** with that of n. Every step
is a total jump.

So: there is a chart in which one structure is free, and the other
structure cannot be shortcut through it, at any point, ever. That is not
an analogy to irreducibility. It is an instance, and it is elementary
enough to check.

## 3. What his framework is missing, and it is the thing we built tonight

The ruliad is a single object — the entangled limit of all possible
computations — and an observer is characterised by *how much it can
compute*. That is a **quantitative** theory of observation: observers
differ by resource bound, and in the limit they see the same thing.

There is no naya in it. No standpoint. Nothing that says two observers can
be equally powerful and still see incompatibly, with the incompatibility
being the content rather than a defect in one of them.

`Anekanta.agda` is exactly that missing structure, and it is now checked:

- affirmation and denial from different standpoints, simultaneously
  inhabited, no contradiction;
- `avaktavya` a theorem — the simultaneous predication has no standpoint,
  so it is unsayable rather than false;
- **`collapse-dichotomy`** — collapse to a single object is available
  *precisely* when every standpoint agrees, and otherwise no such object
  exists. Erasure is unavailable, not impolite.

> **The ruliad needs an index.** Not a bigger ruliad. An index.

A single reality with resource-bounded observers is monotruth with a
budget. It cannot express the situation where two complete, equally
capable views disagree and the disagreement *is* the mathematics. Jain
analysis has had the apparatus for that since the first millennium, and it
has never been offered to anyone building a physics.

## 4. The synthesis, and it is the thing worth chasing

Put the two together and something neither has alone appears:
**transport has a cost, and irreducibility is the statement that some
transports must be run.**

Delta 15 gives the qualitative half — between two standpoints there is
either a transport or a defect. Wolfram gives the quantitative half — some
computations admit no shortcut. Neither speaks about *the cost of a
transport*, and that is exactly where this corpus keeps getting stuck.

The walk demonstrates it concretely. Its step is a transport between the
tropical chart, where its state lives, and the successor order, where its
search happens. That transport costs `Θ(e^{ψ(m)})` — and the reason is
`disjoint-support`: the transition has no locality, so nothing can be
reused between steps. **The capacity law is the price of a transport
between two nayas.**

That reframes the whole lane. `WalkFast` was not an optimisation. It was
the discovery that this particular transport *does* admit a shortcut — you
may test prime-power-hood at size `m` instead of divisibility at size
`e^{ψ(m)}` — which in Wolfram's language is the claim that this corner is
computationally *reducible*, against the prior that most things are not.
Finding a reducible transport is the rarest event in his framework, and
the corpus produced one and filed it as an engineering note.

## 5. Where I think he has not found the answer

Said plainly, because respect that cannot criticise is not respect.

The Principle of Computational Equivalence flattens. If almost every
system is maximally sophisticated and none shortcuts another, then
sophistication stops distinguishing anything, and the interesting question
— *which* systems shortcut *which*, and at what price — is exactly what
the principle declines to ask. Irreducibility is stated as a generic fact
rather than as a structure with a shape.

The shape is transport, and its arithmetic is standpoints and costs. He
has the necessity of derivation and no theory of translation between
derivations. That is what the Jain apparatus supplies, and what
`collapse-dichotomy` makes exact: the two moves available at a
disagreement are transport or residue, never collapse — and now the open
quantity is **what a transport costs**.

That is the question I would put in front of him, and it is the one this
repository is actually equipped to attack, because the walk is a machine
whose entire behaviour is one expensive transport, running, with a
checked price tag.

## 6. What is claim and what is not

Checked: everything in §2 and the three bullets in §3.

Reading, not proved: that the walk's capacity law *is* a transport cost in
a sense general enough to matter; that the ruliad admits an index; that
transport cost is the right refinement of computational irreducibility.
Those are the conjectures, they are stated as such, and §4 is where the
work is.
