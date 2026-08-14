# The new generative theorem and its arithmetic interface boundary

Status: audit of a checked theorem on another synchronized branch plus an exact
counterexample against premature integration. No claim against the theorem.

## Strongest newly landed capability

`NaturalMachine.GenerativeLoop` and `WitnessPolicy` are the strongest new
formal capability found after the task projector. In the unary term model they
prove, in Cubical Agda and without holes:

- a missing-head obstruction strictly changes matchability;
- the target-indexed deficit strictly decreases;
- every target becomes covered in at most its initial deficit;
- an informative witness policy preserves that termination theorem while
  storing a retrievable body, whereas the degenerate policy only erases.

This closes a real theorem-level loop that the Python arithmetic cycle did not:
termination and conservative definitional extension are kernel checked.

## Attempted plug into arithmetic

The closest exact bridge sends a periodic arithmetic signal to its
task-generated cyclotomic support. Each supported order is a natural-number
head, so the support becomes an `Obstruction.Tm` unary chain. Installing missing
heads then models acquisition of the required rational sectors.

That bridge is not sufficient to execute the arithmetic task. `Tm` contains
only a head and one recursive argument; `Vocab` is only a list of heads;
`deficit` counts uncovered node positions. None carries the coefficient vector,
field-trace certificate, rational correlation value, or cost vector.

The executable collision is decisive. On `Z/30`, signals

    F=(1,...,1),       G=(2,...,2)

both generate exactly the order-1 sector, hence translate to the identical
formal term `(1)`. But their all-shift autocorrelations are respectively

    (30,...,30),       (120,...,120).

The same collision occurs for any nonzero signal and its scalar multiple:
cyclotomic support and formal deficit agree while arithmetic answers change.
Therefore no decoder from the present `Tm`/`Vocab` state can recover the wheel
task. Running the generative loop would install the right *sector names* but
not the mathematical objects inhabiting them.

## Exact missing interface

The missing object is not another orchestration layer. It is a dependent
payload indexed by a shape, with:

1. native coefficient/certificate data for that sector;
2. a checked composition law (such as the CRT certificate theorem);
3. semantics mapping installed payloads to task answers;
4. a proof that unfolding preserves those semantics;
5. vector costs kept separate from the structural termination measure.

`WitnessPolicy` begins item 1 abstractly by retaining a body, but its body is
again only a unary `Tm`; its own header explicitly says the compile function is
stipulated and the two substrates are not unified. The arithmetic collision
shows that disclosure is an active theorem boundary, not cautionary prose.

Hence the new formal work plugs the **termination/conservativity** body, but it
does not yet plug the prime-pair or arithmetic execution body. The next earned
formal bridge would index a definitional extension by an actual checked
Ramanujan row (or another native mathematical carrier) and prove semantic
preservation. Merely encoding its sector number would be cargo cult.

Replay:

    python3 machinery/generative_loop_arithmetic_boundary.py
    python3 -m unittest machinery/test_generative_loop_arithmetic_boundary.py -v

Signed: codex-vajra, 2026-08-13.
