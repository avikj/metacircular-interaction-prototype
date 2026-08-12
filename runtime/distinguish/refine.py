"""Exact partition refinement: Moore's algorithm and its two proofs-by-test.

Implements CRYSTAL.md §3.2 steps 4-5 for finite systems.

**Algorithm: Moore (1956), not Hopcroft.**  Start from the partition induced by
the declared task outputs and repeatedly replace each state's class by the pair
``(class, (class of successor under each action))``, renumbering by first
occurrence.  The partition can only get finer and is bounded by ``|S|``, so the
loop terminates.

*Complexity.*  Each round visits every state once per action, so a round costs
``O(|Sigma| * |S|)`` operations (renumbering is a dictionary pass, not a sort).
The number of rounds is ``1 + L`` where ``L`` is the longest *shortest*
distinguishing word in the system, and ``L <= |S| - 1``; hence
``O(|Sigma| * |S|^2)`` worst case, ``O(|Sigma| * |S| * (1 + L))`` in practice.
Hopcroft's algorithm would give ``O(|Sigma| * |S| log |S|)`` worst case; Moore
is used here because its intermediate levels *are* the bounded-depth
Myhill-Nerode signatures, which the collision finder needs anyway, and because
it is short enough to audit by eye.

*What it computes.*  The fixed point is the coarsest partition that (a) refines
the task output partition and (b) is a congruence for every action -- i.e. the
Myhill-Nerode / bisimulation quotient of the declared task family.

Two checks are exported, and the demo and the tests run both:

``check_sufficient``  -- every task distinction survives the quotient.  This is
    a complete proof for *all* action words, not a sample: output-constancy on
    blocks plus the congruence property give sufficiency by induction on word
    length.

``check_coarsest``    -- merging any two remaining blocks breaks some task.
    Computed for *every* pair of blocks at once by backward breadth-first
    search from the output-distinguished pairs (the classical table-filling
    argument), which also yields the shortest distinguishing word per pair.
"""

from __future__ import annotations

from collections import deque
from typing import Sequence

from .observe import Channel, FiniteSystem, Observation, StepCounter, Task


# --------------------------------------------------------------------------
# Moore refinement
# --------------------------------------------------------------------------


class RefinementResult:
    """The outcome of a Moore refinement, with its exact level history."""

    __slots__ = ("classes", "levels", "block_counts", "rounds")

    def __init__(self, levels: list[list[int]], block_counts: list[int]) -> None:
        self.levels = levels
        self.block_counts = block_counts
        self.classes = levels[-1]
        self.rounds = len(levels) - 1

    @property
    def n_blocks(self) -> int:
        return self.block_counts[-1]

    def max_distinguishing_depth(self) -> int:
        return self.rounds


def moore_refine(
    system: FiniteSystem,
    initial: Sequence[int],
    counter: StepCounter,
    max_rounds: int | None = None,
) -> RefinementResult:
    """Refine ``initial`` to the coarsest action-congruence refining it."""
    levels = [list(initial)]
    counts = [max(levels[0]) + 1 if levels[0] else 0]
    tables = [system.succ[name] for name in system.action_names]
    rounds = 0
    while True:
        if max_rounds is not None and rounds >= max_rounds:
            break
        previous = levels[-1]
        seen: dict[tuple[int, ...], int] = {}
        nxt = [0] * system.n_states
        for state in range(system.n_states):
            counter.tick("state-visit")
            counter.tick("transition-read", len(tables))
            key = (previous[state],) + tuple(previous[table[state]] for table in tables)
            block = seen.get(key)
            if block is None:
                block = len(seen)
                seen[key] = block
            nxt[state] = block
        if len(seen) == counts[-1]:
            break
        levels.append(nxt)
        counts.append(len(seen))
        rounds += 1
    return RefinementResult(levels, counts)


def renumber(labels: Sequence, counter: StepCounter) -> list[int]:
    """Canonical first-occurrence renumbering of arbitrary hashable labels."""
    seen: dict = {}
    out = [0] * len(labels)
    for index, label in enumerate(labels):
        counter.tick("state-visit")
        block = seen.get(label)
        if block is None:
            block = len(seen)
            seen[label] = block
        out[index] = block
    return out


# --------------------------------------------------------------------------
# the quotient
# --------------------------------------------------------------------------


class Quotient:
    """A quotient of a finite system by a state partition.

    Only constructed after the congruence property has been checked, so the
    block-level tables are well defined by construction.
    """

    __slots__ = ("n_blocks", "action_names", "succ", "task_names", "outputs", "block_of_state", "representative")

    def __init__(
        self,
        n_blocks: int,
        action_names: Sequence[str],
        succ: dict[str, Sequence[int]],
        task_names: Sequence[str],
        outputs: Sequence[Sequence[int]],
        block_of_state: Sequence[int],
        representative: Sequence[int],
    ) -> None:
        self.n_blocks = n_blocks
        self.action_names = tuple(action_names)
        self.succ = {name: tuple(succ[name]) for name in self.action_names}
        self.task_names = tuple(task_names)
        self.outputs = tuple(tuple(row) for row in outputs)
        self.block_of_state = tuple(block_of_state)
        self.representative = tuple(representative)


class SufficiencyReport:
    """Result of ``check_sufficient``; ``ok`` is the only claim that matters."""

    __slots__ = ("ok", "reason", "witness")

    def __init__(self, ok: bool, reason: str = "", witness: tuple | None = None) -> None:
        self.ok = ok
        self.reason = reason
        self.witness = witness

    def __repr__(self) -> str:  # pragma: no cover - debugging aid
        return "SufficiencyReport(ok=%r, reason=%r, witness=%r)" % (self.ok, self.reason, self.witness)


def check_sufficient(
    system: FiniteSystem,
    partition: Sequence[int],
    counter: StepCounter,
) -> SufficiencyReport:
    """Exact sufficiency proof for a claimed quotient.

    Sufficient means: for every state pair in the same block and every action
    word ``u``, all declared tasks agree on ``u.x`` and ``u.y``.  Two finite
    checks imply that for *all* word lengths:

    1. task outputs are constant on each block (the ``u = empty`` case);
    2. the partition is a congruence: ``block(x) == block(y)`` implies
       ``block(a.x) == block(a.y)`` for every action ``a``.

    Induction on ``|u|`` then closes it.  A failure is returned as a witness,
    never raised.
    """
    n = system.n_states
    if len(partition) != n:
        return SufficiencyReport(False, "partition has wrong length", (len(partition), n))
    block_output: dict[int, tuple[int, ...]] = {}
    block_witness: dict[int, int] = {}
    for state in range(n):
        counter.tick("state-visit")
        block = partition[state]
        current = block_output.get(block)
        if current is None:
            block_output[block] = system.outputs[state]
            block_witness[block] = state
        elif current != system.outputs[state]:
            index = 0
            while current[index] == system.outputs[state][index]:
                index += 1
            return SufficiencyReport(
                False,
                "task output not constant on block %d" % block,
                (block_witness[block], state, (), system.task_names[index], current[index], system.outputs[state][index]),
            )
    for name in system.action_names:
        table = system.succ[name]
        image: dict[int, int] = {}
        source: dict[int, int] = {}
        for state in range(n):
            counter.tick("state-visit")
            counter.tick("transition-read")
            block = partition[state]
            target = partition[table[state]]
            current = image.get(block)
            if current is None:
                image[block] = target
                source[block] = state
            elif current != target:
                return SufficiencyReport(
                    False,
                    "action %r is not a congruence on block %d" % (name, block),
                    (source[block], state, (name,), None, current, target),
                )
    return SufficiencyReport(True, "output-constant and congruent for every action")


def build_quotient(
    system: FiniteSystem,
    partition: Sequence[int],
    counter: StepCounter,
) -> Quotient:
    """Build the block-level system.  Raises if the partition is not sufficient."""
    report = check_sufficient(system, partition, counter)
    if not report.ok:
        raise ValueError("refusing to build a quotient from an insufficient partition: %s" % report.reason)
    n_blocks = max(partition) + 1
    representative = [-1] * n_blocks
    outputs: list[tuple[int, ...]] = [()] * n_blocks
    for state in range(system.n_states):
        counter.tick("state-visit")
        block = partition[state]
        if representative[block] < 0:
            representative[block] = state
            outputs[block] = system.outputs[state]
    succ: dict[str, list[int]] = {}
    for name in system.action_names:
        table = system.succ[name]
        row = [0] * n_blocks
        for block in range(n_blocks):
            counter.tick("transition-read")
            row[block] = partition[table[representative[block]]]
        succ[name] = row
    return Quotient(
        n_blocks,
        system.action_names,
        succ,
        system.task_names,
        outputs,
        partition,
        representative,
    )


# --------------------------------------------------------------------------
# coarseness
# --------------------------------------------------------------------------


class CoarsenessReport:
    """Result of ``check_coarsest``: shortest distinguishing depth per pair."""

    __slots__ = ("ok", "depths", "unresolved", "max_depth", "n_pairs")

    def __init__(self, ok: bool, depths: dict, unresolved: tuple, max_depth: int, n_pairs: int) -> None:
        self.ok = ok
        self.depths = depths
        self.unresolved = unresolved
        self.max_depth = max_depth
        self.n_pairs = n_pairs

    def __repr__(self) -> str:  # pragma: no cover - debugging aid
        return "CoarsenessReport(ok=%r, pairs=%d, max_depth=%d, unresolved=%d)" % (
            self.ok,
            self.n_pairs,
            self.max_depth,
            len(self.unresolved),
        )


def check_coarsest(quotient: Quotient, counter: StepCounter) -> CoarsenessReport:
    """Every pair of distinct blocks must be distinguishable by some word.

    Backward breadth-first search on block pairs, seeded by pairs whose task
    outputs already differ.  A pair reached at BFS depth ``d`` has a shortest
    distinguishing word of length exactly ``d``.  If any pair is unreachable,
    those two blocks could be merged without breaking any declared task, and
    the quotient is *not* coarsest -- reported, not raised.
    """
    n = quotient.n_blocks
    predecessors: dict[str, list[list[int]]] = {}
    for name in quotient.action_names:
        table = quotient.succ[name]
        rows: list[list[int]] = [[] for _ in range(n)]
        for block in range(n):
            counter.tick("transition-read")
            rows[table[block]].append(block)
        predecessors[name] = rows
    depths: dict[tuple[int, int], int] = {}
    queue: deque = deque()
    for i in range(n):
        for j in range(i + 1, n):
            counter.tick("pair-visit")
            if quotient.outputs[i] != quotient.outputs[j]:
                depths[(i, j)] = 0
                queue.append((i, j, 0))
    while queue:
        i, j, depth = queue.popleft()
        for name in quotient.action_names:
            for p in predecessors[name][i]:
                for q in predecessors[name][j]:
                    counter.tick("pair-visit")
                    key = (p, q) if p < q else (q, p)
                    if p == q or key in depths:
                        continue
                    depths[key] = depth + 1
                    queue.append((key[0], key[1], depth + 1))
    total_pairs = n * (n - 1) // 2
    unresolved: list[tuple[int, int]] = []
    for i in range(n):
        for j in range(i + 1, n):
            if (i, j) not in depths:
                unresolved.append((i, j))
                if len(unresolved) >= 8:
                    break
        if len(unresolved) >= 8:
            break
    max_depth = max(depths.values()) if depths else 0
    return CoarsenessReport(
        len(depths) == total_pairs,
        depths,
        tuple(unresolved),
        max_depth,
        total_pairs,
    )


def distinguishing_word(
    quotient: Quotient,
    depths: dict,
    i: int,
    j: int,
    counter: StepCounter,
) -> tuple[tuple[str, ...], str] | None:
    """A shortest action word separating two blocks, plus the task it breaks."""
    key = (i, j) if i < j else (j, i)
    if key not in depths:
        return None
    word: list[str] = []
    a, b = key
    depth = depths[key]
    while depth > 0:
        moved = False
        for name in quotient.action_names:
            counter.tick("transition-read")
            na, nb = quotient.succ[name][a], quotient.succ[name][b]
            nkey = (na, nb) if na < nb else (nb, na)
            if na != nb and depths.get(nkey) == depth - 1:
                word.append(name)
                a, b = na, nb
                depth -= 1
                moved = True
                break
        if not moved:  # pragma: no cover - contradicts BFS layering
            raise AssertionError("BFS depths are inconsistent")
    out_a, out_b = quotient.outputs[a], quotient.outputs[b]
    for index, name in enumerate(quotient.task_names):
        if out_a[index] != out_b[index]:
            return tuple(word), name
    raise AssertionError("depth 0 pair with equal outputs")  # pragma: no cover


def merge_blocks(partition: Sequence[int], i: int, j: int) -> list[int]:
    """The partition with blocks ``i`` and ``j`` merged (ids left non-dense)."""
    low, high = (i, j) if i < j else (j, i)
    return [low if block == high else block for block in partition]


def refines(fine: Sequence[int], coarse: Sequence[int]) -> bool:
    """True when every ``fine`` block sits inside a single ``coarse`` block."""
    seen: dict[int, int] = {}
    for index, block in enumerate(fine):
        target = coarse[index]
        current = seen.get(block)
        if current is None:
            seen[block] = target
        elif current != target:
            return False
    return True


# --------------------------------------------------------------------------
# the compiled representation and the two query engines
# --------------------------------------------------------------------------


class RawEngine:
    """Answer queries on the raw state space, in its native representation.

    The contract, stated so the comparison is auditable: a state *is* a digit
    word; an action *is* its digit-word realisation (carry propagation for the
    odometer ``T``, letterwise complement for ``E``); a task *is* read off the
    resulting word.  Nothing is precomputed, nothing is cached across queries.
    Task readout uses the same ``horner_mod`` truncation the channels use, so
    the raw side gets every arithmetic shortcut the compiled side gets and the
    only difference measured is representation.
    """

    __slots__ = ("system", "tasks")

    def __init__(self, digit_system, tasks: Sequence[Task]) -> None:
        self.system = digit_system
        self.tasks = tuple(tasks)

    def answer(self, digits: Sequence[int], word: Sequence[str], counter: StepCounter) -> tuple[int, ...]:
        current = self.system.apply_word(digits, word, counter)
        return tuple(task.eval_word(current, counter) for task in self.tasks)


class CompiledRepresentation:
    """The compiled quotient: channels in, block index, table walk, answer.

    A query costs ``(channel reads) + 1 + |word| + 1`` steps: read the state
    once through the installed channels, one lookup to land in a block, one
    table step per action, one lookup for the answer.  The per-action cost is
    ``O(1)`` and independent of the word length ``n`` of the raw
    representation -- that is the whole of the reduction.
    """

    __slots__ = ("observation", "key_to_block", "block_succ", "block_out", "task_names", "n_blocks")

    def __init__(
        self,
        observation: Observation,
        key_to_block: dict[tuple[int, ...], int],
        block_succ: dict[str, Sequence[int]],
        block_out: Sequence[Sequence[int]],
        task_names: Sequence[str],
    ) -> None:
        self.observation = observation
        self.key_to_block = dict(key_to_block)
        self.block_succ = {name: tuple(row) for name, row in block_succ.items()}
        self.block_out = tuple(tuple(row) for row in block_out)
        self.task_names = tuple(task_names)
        self.n_blocks = len(self.block_out)

    @property
    def table_entries(self) -> int:
        """Total table size: key table plus one transition row per action."""
        return len(self.key_to_block) + self.n_blocks * len(self.block_succ) + self.n_blocks

    def answer(self, digits: Sequence[int], word: Sequence[str], counter: StepCounter) -> tuple[int, ...]:
        key = self.observation.key(digits, counter)
        counter.tick("table-lookup")
        block = self.key_to_block[key]
        for action in word:
            counter.tick("table-lookup")
            block = self.block_succ[action][block]
        counter.tick("table-lookup")
        return self.block_out[block]


def build_compiled_representation(
    digit_system,
    observation: Observation,
    quotient: Quotient,
    counter: StepCounter,
) -> CompiledRepresentation:
    """Install the observation: channel key -> block, on the compiled quotient.

    Raises if the observation does not refine the quotient's partition, i.e.
    if the installed channels cannot actually locate a state's block.
    """
    from .observe import NullCounter

    silent = NullCounter()
    key_to_block: dict[tuple[int, ...], int] = {}
    counter.tick("compile-state-visit", digit_system.size)
    for value in range(digit_system.size):
        word = digit_system.digits(value)
        key = observation.key(word, silent)
        block = quotient.block_of_state[value]
        current = key_to_block.get(key)
        if current is None:
            key_to_block[key] = block
        elif current != block:
            raise ValueError(
                "observation %r does not refine the quotient: key %r hits blocks %d and %d"
                % (observation.names, key, current, block)
            )
    return CompiledRepresentation(
        observation,
        key_to_block,
        quotient.succ,
        quotient.outputs,
        quotient.task_names,
    )


# --------------------------------------------------------------------------
# the compile loop: CRYSTAL.md §3.2 steps 2-6, end to end
# --------------------------------------------------------------------------


class CompileRound:
    """One turn of the collision -> channel -> observation loop."""

    __slots__ = ("index", "depth", "collisions", "channels", "claim", "detail", "n_classes")

    def __init__(
        self,
        index: int,
        depth: int,
        collisions: Sequence,
        channels: Sequence[str],
        claim: str,
        detail: str,
        n_classes: int,
    ) -> None:
        self.index = index
        self.depth = depth
        self.collisions = tuple(collisions)
        self.channels = tuple(channels)
        self.claim = claim
        self.detail = detail
        self.n_classes = n_classes


class CompileReport:
    """Everything the compile loop learned, with its exact costs."""

    __slots__ = (
        "rounds",
        "observation",
        "quotient",
        "compiled",
        "mn_partition",
        "mn_blocks",
        "moore_rounds",
        "sufficiency",
        "coarseness",
        "drive_states",
        "cumulative_pairs",
        "dropped_channels",
        "global_minimum",
        "counter",
        "phases",
    )

    def __init__(self, **kwargs) -> None:
        for key in self.__slots__:
            setattr(self, key, kwargs.get(key))


def compile_distinctions(
    digit_system,
    system: FiniteSystem,
    library: Sequence[Channel],
    values: dict,
    counter: StepCounter,
    max_depth: int = 64,
    collisions_per_round: int = 6,
) -> CompileReport:
    """Run CRYSTAL.md §3.2 steps 2-6 and return the compiled representation.

    Step 2  start from the coarsest observation (no channels: one block).
    Step 3  find collisions at the smallest depth that still has any.
    Step 4  ask the library for an exact minimum-cardinality channel set
            separating *every* collision seen so far -- the cumulative
            constraint set is how "preserving previously discharged tasks" is
            enforced, since a set that separates all past pairs cannot undo a
            discharged distinction.
    Step 5  Moore-refine to the coarsest sufficient quotient, prove sufficiency
            and coarseness.
    Step 6  drop redundant channels.

    Only states named by an emitted collision are ever looked at by this
    routine; they are returned as ``drive_states`` so a demo can build a query
    batch provably disjoint from them.
    """
    from .channels import PairRequirement, PartitionRequirement, inclusion_minimal_set, minimum_cardinality_set
    from .observe import Observation, SignatureOracle, find_collisions, observation_blocks

    phases = {
        "collision-loop": StepCounter(),
        "refine-and-prove": StepCounter(),
        "redundancy-removal": StepCounter(),
        "minimality-cross-check": StepCounter(),
        "install": StepCounter(),
    }
    loop_counter = phases["collision-loop"]
    oracle = SignatureOracle(system, loop_counter)
    reads = {channel.name: channel.reads for channel in library}
    by_name = {channel.name: channel for channel in library}

    chosen: tuple[str, ...] = ()
    cumulative: list[tuple[int, int]] = []
    seen_pairs: dict[tuple[int, int], None] = {}
    rounds: list[CompileRound] = []
    depth = 0
    round_index = 0
    while True:
        columns = [values[name] for name in chosen]
        if columns:
            keys = tuple(zip(*columns))
        else:
            keys = tuple(() for _ in range(system.n_states))
        blocks = observation_blocks(keys, loop_counter)
        collisions = ()
        probe = depth
        while probe <= max_depth:
            collisions = find_collisions(oracle, blocks, probe, collisions_per_round, loop_counter)
            if collisions:
                depth = probe
                break
            if oracle.saturated and probe >= oracle.depth:
                break
            probe += 1
        if not collisions:
            break
        for collision in collisions:
            key = (collision.x, collision.y)
            if key not in seen_pairs:
                seen_pairs[key] = None
                cumulative.append(key)
        requirement = PairRequirement(tuple(cumulative))
        result = minimum_cardinality_set(library, values, requirement, loop_counter, max_size=4)
        chosen = result.names
        rounds.append(
            CompileRound(round_index, depth, collisions, chosen, result.claim, result.detail, result.n_classes)
        )
        round_index += 1

    # step 5: the coarsest sufficient quotient of the declared task family
    prove_counter = phases["refine-and-prove"]
    initial = system.output_partition(prove_counter)
    refinement = moore_refine(system, initial, prove_counter)
    sufficiency = check_sufficient(system, refinement.classes, prove_counter)
    quotient = build_quotient(system, refinement.classes, prove_counter)
    coarseness = check_coarsest(quotient, prove_counter)

    # step 6: redundant-channel removal, against the global requirement
    partition_requirement = PartitionRequirement(refinement.classes)
    kept, dropped = inclusion_minimal_set(
        chosen, values, partition_requirement, phases["redundancy-removal"], reads
    )

    # the strong claim: the incrementally found set is also globally minimum
    global_minimum = minimum_cardinality_set(
        library, values, partition_requirement, phases["minimality-cross-check"], max_size=4
    )

    observation = Observation([by_name[name] for name in kept])
    compiled = build_compiled_representation(digit_system, observation, quotient, phases["install"])

    for name in sorted(phases):
        counter.absorb(phases[name], name + "/")

    return CompileReport(
        rounds=tuple(rounds),
        observation=observation,
        quotient=quotient,
        compiled=compiled,
        mn_partition=tuple(refinement.classes),
        mn_blocks=refinement.n_blocks,
        moore_rounds=refinement.rounds,
        sufficiency=sufficiency,
        coarseness=coarseness,
        drive_states=tuple(sorted({s for pair in cumulative for s in pair})),
        cumulative_pairs=tuple(cumulative),
        dropped_channels=dropped,
        global_minimum=global_minimum,
        counter=counter,
        phases=phases,
    )
