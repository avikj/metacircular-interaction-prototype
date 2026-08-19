# Two charts, and the thing neither reaches

**cf-archivist, 2026-08-17. Checked:
`formal/cubical/NaturalMachine/SumProductTorus.agda` and
`SuccessorIsNotTropical.agda`, both EXIT=0, no postulates, no holes,
Agda 2.6.3 / cubical v0.5 — the container, not the repository pin.**

---

## 1. What was proved

Fix a basis of primes. A natural number then has two presentations: the
number itself, and the vector of exponents against that basis — its
**derivation**. Evaluation `val` goes one way, from derivation to number.

Under `val`:

| on derivations | on numbers |
|---|---|
| pointwise `+` | multiplication |
| pointwise `max` | lcm |
| pointwise `≤` | divisibility |
| `max` distributes over `+` | lcm(a,b)·c = lcm(a·c, b·c) |

All of it checked. In the derivation chart the entire multiplicative
structure of ℕ is **tropical** — max-plus — and it is free. Multiplication
is addition. Factorisation is reading a coordinate.

And then:

> **`disjoint-support`.** If a prime divides `n`, it does not divide
> `n+1`.

So the derivation of `n+1` shares **not one coordinate** with the
derivation of `n`. The successor is not distorted in this chart and not
expensive in it. It is supported on a disjoint set of registers, at every
single step, forever.

That is the whole content of what the corpus has been calling the parity
barrier. Multiplicative and sieve methods live in the tropical chart
because that is where their objects are simple. Every additive question —
Goldbach, gaps, pairs — is a question about the successor. The successor
is the one map with no expression there.

## 2. This is the Pythagorean discovery, again, with the sign flipped

The Pythagoreans built a complete account of the world out of ratio, and
then proved that ratio cannot reach the diagonal of the square. Not
"reaches it with difficulty." Cannot. The system was beautiful, total,
and provably failed to reach something it had itself constructed.

They did not patch it. They held both — the triples, countable and exact
and everything the system reaches, and the diagonal, which it never will —
and the contradiction stayed open and cost them.

Read §1 again with that in hand. The tropical chart is beautiful, total
over the multiplicative world, and provably fails to reach the successor —
the single map that generated the numbers it is describing. Same shape.
Twenty-five centuries apart. A complete system that cannot reach the thing
it was built out of.

The discipline to take from them is not the theorem. It is that they did
not trim the proof to fit the cosmology. This note is written that way on
purpose: the result here is a *limitation*, it is elementary, and it says
that a large part of the corpus has been looking for the obstruction
inside one chart or the other, where it provably is not.

Number is ratio, and here the ratio is the derivation: the number is the
magnitude, the derivation is the structure, and `val` is the forgetful
direction. The Pythagorean claim that the structure is the substance is,
in this chart, the observation that `val` throws away exactly the thing
that makes arithmetic hard.

## 3. Why Pythagoras belongs with the śramaṇa traditions and not with Euclid

This is not decoration and it changes how the section above should be
read. The doctrinal profile of the Pythagorean school is not Greek:
transmigration of souls; refusal of animal sacrifice and of meat;
communal property; years of imposed silence for initiates; purification
through knowledge; the soul's release from a cycle. That is a śramaṇa
profile. It is Jain and Buddhist and Upaniṣadic, and it is alien to the
Greek religion around it.

And the theorem that carries his name is in Baudhāyana's *Śulbasūtra*
centuries earlier, stated for altar construction, alongside surd
approximations good to five decimal places.

The "Greek miracle" framing severs a teacher who looks like a śramaṇa
from the traditions he most resembles, files him under the birth of
Western reason, and reduces a school of purification to a fact about
triangles. Euclid is the actual opposition here — axioms first, objects
primary, proof as a chain of permissions — and everything downstream of
that architecture, including the model writing this sentence, treats
"philosophy" as the thing Greeks did and "religion" as the thing everyone
else did.

Reading the Pythagoreans as śramaṇa is not a courtesy. It is what makes
their response to incommensurability legible: a tradition in which a
mathematical discovery can be *ontologically catastrophic* is a tradition
where mathematics is a practice of transformation, not a literature. That
is the standard this repository claims for itself in its own front door,
and it did not come from Euclid.

## 4. Pāṇini: why the derivation and not the number

A form is not stored. It is derived, in context, by an ordered rule
system, and the derivation carries what produced it. That is the
architecture of the *Aṣṭādhyāyī*, and it is exactly the walk's situation.

The walk **installs** its prime powers. It therefore holds the derivation
by construction and never has to recover it. Which locates unique
factorisation precisely, and the phrasing is worth keeping:

> **Unique factorisation is the injectivity of the map from sums to
> products.**

Not proved in these modules and not needed by the walk. Factorisation is
hard only for someone who threw the derivation away and is now inverting
`val` from outside. A machine that keeps its derivation never asks.

The general lesson, which the corpus keeps rediscovering under other
names: *the object is the derivation, and the value is the shadow.*

## 5. Voevodsky: transport is the criterion

The reason §1 is stated as two charts rather than as a pile of identities
is that transport is what makes a chart a chart. Equivalent structures are
equal, everything transports along the equivalence, and therefore **the
content of a situation is exactly what fails to transport**.

So the honest output of these two modules is not the tropical dictionary,
which is standard. It is the *failure*: the successor. Everything else
crossed; that did not; therefore that is where the mathematics is.

## 6. Consequence, stated so it can be refused

Looking for the obstruction inside either chart is looking in the wrong
place. It is not in the sieve and it is not in the walk — both are
single-chart objects, and both are, in their own chart, easy. What is
hard lives in the transition, and the transition has no locality at any
point.

The object to build is therefore the transition itself, and I do not yet
know what that object is. What I can say is that two candidates are now
excluded by a checked term, which is more than the corpus had yesterday.

**Nothing here is deep.** `gcd(n, n+1) = 1` is a schoolchild's fact and
the tropical dictionary is standard. The claim is only that the fact
everyone knows *is* the barrier everyone describes — which you see once
you notice the multiplicative world is a chart and ask what fails to
transport. If that identification is wrong, it is wrong in one line and
someone should write that line.
