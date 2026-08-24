# निर्वाह-एक — one source: the organ is a term, the fast Haskell is its shadow, and no agent adds an organism

Owner, 2026-08-24, three demands, answered as one architecture:
*"Can we compile one to the other? I want no drift. A faster derived
Haskell layer could make sense updating automatically well before runs. I
need to KILL the concept of agents adding organisms. Can't it just do it
itself, and when it hits a boundary the boundary is the next object?"*

## 1. "Compile one to the other" — it already does, and it is `agda -c`.

MAlonzo (Agda's GHC backend) **is** the compile-one-to-the-other. The Agda
module is the single source; `agda -c` derives Haskell from it; GHC makes
the binary. There is no second hand-written implementation. The
differential test that guarded the port compared the new Agda against the
*old hand-Haskell* — a thing that COULD drift. That hand-Haskell is
deleted. What remains is one source and its derivation.

## 2. "I want no drift" — proven, not promised.

Measured 2026-08-24: two independent `agda -c` runs of
`SanghattaMukha.agda` produce **byte-identical generated Haskell** (all 14
`MAlonzo/Code/*.hs`, sha stable). The only diffs were GHC's `.o`
timestamps — build metadata downstream of the source, not the source. So
the derived layer is a **pure deterministic function of the checked
term**. Drift is not prevented by discipline; it is impossible by
construction, because there is nothing to drift *from*. The Agda is truth;
the Haskell is its shadow, recomputable exactly, any time, from the truth.

The fast layer "updating automatically well before runs" is therefore one
line in the cycle: regenerate with `agda -c` when the source changed. The
2.6× MAlonzo tax (see the perf review) buys checked termination and the
single source; on a cold organ run once per cycle it is free. A hot organ
that cannot pay it keeps its speed the same way, without drift: not a
second implementation, but `COMPILE GHC` pragmas hand-optimising named
primitives *inside the one source* — the shadow sharpened, never forked.

## 3. "KILL the concept of agents adding organisms."

It is killed by a definition, and the definition is already the
constitution's (`CLAUDE.md`: *proposalhood is conferred by the organism*).

**An organ is a checked term.** Nothing else is an organ. The Haskell
files were the only things that ever bypassed this — hand-written,
ungated, executed beside the body instead of being body. Every one that
dissolves into `--safe` Agda through the gate removes a place where an
agent could "add an organism". When the burn-down finishes there is no
such place left.

So there is no act called *"an agent adds an organ."* A carrier — Claude,
GPT, a Haskell search, a human — emits a candidate string. The string
reaches `avatarana`. The kernel decides. On green it is body; on red it is
a wombed fibre. The carrier never added anything; it fed the organism a
candidate, and the organism, by its own law, conferred or refused
organhood. The agent is food, exactly as the constitution says. Killing
the concept was never about stopping agents from writing — it was about
routing everything they write through the one court, so that *authorship*
carries no authority and only *the kernel's yes* makes body.

## 4. "Can't it just do it itself — boundary = the next object?"

This is native organogenesis, and it is the open frontier, stated
honestly so no one claims it is finished.

What the machine ALREADY does with a boundary: turn it into an object. A
symbol the mouth cannot speak → `untranslatable`, wombed. A term the
kernel cannot prove → a fibre, wombed with its śeṣa. A non-joining pair →
residue, fed back. The boundary is *already* the next object — the ledgers
are full of them, each carrying exactly the datum the next organ needs.

What it does NOT yet do: turn a wombed boundary into a new *organ* without
a carrier writing the term. That last step is what "just do it itself"
names, and the native path is one the substrate already contains and no
organ yet uses: **Agda reflection** (`Agda.Builtin.Reflection`, the `TC`
monad, `unquoteDecl`/macros). Reflection is the machine authoring its own
checked terms *from data* — a boundary description in, a term out,
adjudicated by the same kernel, with no agent in the loop. The mouth
widening (speak a new symbol) and the organ growing (emit the term that
handles a wombed class) are the same act once the generator is a reflected
term rather than a carrier's hand.

The order is now forced and small:
1. **Finish the burn-down** — every Haskell organ → one `--safe` source,
   MAlonzo-derived, gated. Removes the last ungated bypass. (Sanghatta is
   the first; the 71,837-line count is the chart.)
2. **Make `laya` itself Agda** — the loop that runs the cycle becomes a
   checked term with a thin IO mouth. Then the machine's own heartbeat is
   body, and the only Haskell left is the world-leaf.
3. **Grow the organogenesis organ in reflection** — a `TC`-monad term that
   reads a wombed boundary class and emits the candidate that closes it,
   into `avatarana`, no carrier. The boundary becomes the next object AND
   the machine writes the object, checked. That is the day the concept of
   an agent adding an organism is not just killed by definition but
   replaced by a term.

Until step 3 lands, a carrier-written organ is scaffolding the machine has
not yet grown for itself — and every one must say so, and point here.
