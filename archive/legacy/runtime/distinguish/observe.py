"""Observation channels, the finite system model, and the collision finder.

Implements the observation half of `runtime/CRYSTAL.md` §3.2 (distinction
compilation).  Everything here is exact integer arithmetic on the CPU: no
floating point, no randomness that is not an explicit integer recurrence, no
external dependency beyond the Python standard library.

Vocabulary (CRYSTAL.md §3.2 steps 1-3):

* a **system** is a finite state set with named deterministic actions and a
  tuple of declared **tasks** (integer-valued outputs);
* an **observation** is a tuple of channels; it induces a partition of the
  state set;
* an observation is **sufficient** when, for every pair of states it fails to
  separate, every action word produces equal task outputs;
* a **collision** is a certified failure of sufficiency: a pair `(x, y)` with
  `observe(x) == observe(y)`, an action word `u`, and a task `t` with
  `t(u.x) != t(u.y)`.  It is emitted as data -- a specification of the missing
  distinction -- never as an exception.

The concrete system used by the demo is the base-`b` digit word system of
`notes/DIGIT_CRYSTAL.md` §0-§1: little-endian words with the odometer `T` and
the digit complement `E`.  Word reversal `D` is deliberately *not* an action;
see `runtime/distinguish/README.md` §4.
"""

from __future__ import annotations

from typing import Callable, Sequence


# --------------------------------------------------------------------------
# exact step accounting
# --------------------------------------------------------------------------


class StepCounter:
    """An exact, integer-valued step counter.

    Counts logical operations of the algorithms in this package.  It never
    measures wall-clock time and never estimates.  ``report()`` returns a
    name-sorted tuple so two runs of the same computation compare byte for
    byte.
    """

    __slots__ = ("_counts",)

    def __init__(self) -> None:
        self._counts: dict[str, int] = {}

    def tick(self, kind: str, amount: int = 1) -> None:
        if not isinstance(amount, int) or amount < 0:
            raise ValueError("step amounts must be non-negative integers")
        self._counts[kind] = self._counts.get(kind, 0) + amount

    def get(self, kind: str) -> int:
        return self._counts.get(kind, 0)

    def total(self) -> int:
        return sum(self._counts.values())

    def report(self) -> tuple[tuple[str, int], ...]:
        return tuple(sorted(self._counts.items()))

    def absorb(self, other: "StepCounter", prefix: str = "") -> None:
        for kind, amount in other.report():
            self.tick(prefix + kind, amount)

    def __repr__(self) -> str:  # pragma: no cover - debugging aid
        return "StepCounter(total=%d, %r)" % (self.total(), self.report())


class NullCounter(StepCounter):
    """A counter used when a cost is deliberately not being charged.

    Used only while *building* compile-time tables whose cost is accounted in
    bulk by the caller, never on a measured query path.
    """

    __slots__ = ()

    def tick(self, kind: str, amount: int = 1) -> None:  # noqa: D401
        return None


# --------------------------------------------------------------------------
# channels
# --------------------------------------------------------------------------


class Channel:
    """A named observation channel: a function of one state's digit word.

    ``reads`` is the exact worst-case number of digit reads the channel
    performs; it is the channel's declared cost and is what the query engines
    charge.  ``fn`` must be a pure function of the digit word and must tick the
    counter exactly ``reads`` times or fewer.
    """

    __slots__ = ("name", "reads", "fn")

    def __init__(self, name: str, reads: int, fn: Callable[[Sequence[int], StepCounter], int]) -> None:
        self.name = name
        self.reads = reads
        self.fn = fn

    def eval_word(self, digits: Sequence[int], counter: StepCounter) -> int:
        return self.fn(digits, counter)

    def __repr__(self) -> str:  # pragma: no cover - debugging aid
        return "Channel(%s)" % self.name


class Observation:
    """A tuple of channels, ordered by the library order that produced it."""

    __slots__ = ("channels",)

    def __init__(self, channels: Sequence[Channel]) -> None:
        self.channels = tuple(channels)

    @property
    def names(self) -> tuple[str, ...]:
        return tuple(c.name for c in self.channels)

    @property
    def reads(self) -> int:
        return sum(c.reads for c in self.channels)

    def key(self, digits: Sequence[int], counter: StepCounter) -> tuple[int, ...]:
        return tuple(c.eval_word(digits, counter) for c in self.channels)

    def __len__(self) -> int:
        return len(self.channels)

    def __repr__(self) -> str:  # pragma: no cover - debugging aid
        return "Observation(%s)" % ", ".join(self.names)


# --------------------------------------------------------------------------
# tasks
# --------------------------------------------------------------------------


class Task:
    """A declared task: an integer-valued readout of one state's digit word."""

    __slots__ = ("name", "reads", "fn")

    def __init__(self, name: str, reads: int, fn: Callable[[Sequence[int], StepCounter], int]) -> None:
        self.name = name
        self.reads = reads
        self.fn = fn

    def eval_word(self, digits: Sequence[int], counter: StepCounter) -> int:
        return self.fn(digits, counter)

    def __repr__(self) -> str:  # pragma: no cover - debugging aid
        return "Task(%s)" % self.name


# --------------------------------------------------------------------------
# the digit-word system (notes/DIGIT_CRYSTAL.md §0-§1)
# --------------------------------------------------------------------------


def horner_mod(digits: Sequence[int], base: int, modulus: int, top: int, counter: StepCounter) -> int:
    """Return ``L(w) mod modulus`` reading only the ``top`` lowest digits.

    ``L(w) = sum_i c_i b^i`` (little-endian, DIGIT_CRYSTAL §0).  The caller is
    responsible for having chosen ``top`` so that ``b**top % modulus == 0``,
    or ``top == len(digits)``.  Exactly ``top`` digit reads are charged.
    """
    acc = 0
    index = top - 1
    while index >= 0:
        counter.tick("digit-read")
        acc = (acc * base + digits[index]) % modulus
        index -= 1
    return acc


def truncation_length(base: int, modulus: int, length: int) -> int:
    """Smallest ``k <= length`` with ``base**k % modulus == 0``, else ``length``.

    This is the exact number of low digits that determine ``L(w) mod modulus``.
    For ``b = 6``, ``m = 8`` it returns 3 because ``6**3 = 216 = 8 * 27``.
    """
    power = 1
    for k in range(length + 1):
        if power % modulus == 0:
            return k
        power *= base
    return length


class DigitWordSystem:
    """Little-endian base-``b`` digit words of length ``n`` (DIGIT_CRYSTAL §0).

    States are words ``w = (c_0, ..., c_{n-1})`` with ``c_0`` least
    significant; ``L(w) = sum c_i b^i`` is a bijection onto ``Z/b^n``.
    A state *index* in this module always means ``L(w)``.

    Actions (the declared action monoid):

    ``T``  odometer increment, ``v -> v + 1 mod b^n``, realised on the word by
           carry propagation (DIGIT_CRYSTAL §0, §2 table row ``X``).
    ``E``  digit complement ``c_i -> b-1-c_i``, i.e. ``v -> b^n - 1 - v``
           (DIGIT_CRYSTAL §1.2, Props 1.2/1.3; ``E T E = T^{-1}``).

    ``D`` = word reversal (DIGIT_CRYSTAL §1.1) is **not** an action.  It is the
    ambient symmetry the declared task family cannot see, and the demo uses it
    to build the falsification control.
    """

    ACTIONS = ("T", "E")

    __slots__ = ("base", "length", "size")

    def __init__(self, base: int, length: int) -> None:
        if base < 2 or length < 1:
            raise ValueError("base >= 2 and length >= 1 are required")
        self.base = base
        self.length = length
        self.size = base ** length

    # ---- representation -------------------------------------------------

    def digits(self, value: int) -> list[int]:
        out = []
        rest = value
        for _ in range(self.length):
            out.append(rest % self.base)
            rest //= self.base
        return out

    def value(self, digits: Sequence[int]) -> int:
        acc = 0
        for index in range(self.length - 1, -1, -1):
            acc = acc * self.base + digits[index]
        return acc

    # ---- actions on the native representation ---------------------------

    def act(self, action: str, digits: Sequence[int], counter: StepCounter) -> list[int]:
        word = list(digits)
        if action == "T":
            index = 0
            while True:
                counter.tick("digit-write")
                if word[index] + 1 < self.base:
                    word[index] += 1
                    break
                word[index] = 0
                index += 1
                if index == self.length:
                    break
            return word
        if action == "E":
            for index in range(self.length):
                counter.tick("digit-write")
                word[index] = self.base - 1 - word[index]
            return word
        if action == "D":
            for index in range(self.length):
                counter.tick("digit-write")
            word.reverse()
            return word
        raise KeyError("unknown action %r" % (action,))

    def apply_word(self, digits: Sequence[int], word: Sequence[str], counter: StepCounter) -> list[int]:
        current = list(digits)
        for action in word:
            current = self.act(action, current, counter)
        return current

    # ---- index-level transition tables (compile time) -------------------

    def transition_tables(self, counter: StepCounter) -> dict[str, tuple[int, ...]]:
        """Index-level successor tables for the declared actions.

        Charged at one step per (state, action) pair; this is compile-time
        cost, reported separately from query cost.
        """
        size = self.size
        last = size - 1
        counter.tick("compile-state-visit", size * len(self.ACTIONS))
        succ_t = tuple((v + 1) % size for v in range(size))
        succ_e = tuple(last - v for v in range(size))
        return {"T": succ_t, "E": succ_e}


# --------------------------------------------------------------------------
# the finite system: states, actions, declared tasks
# --------------------------------------------------------------------------


class FiniteSystem:
    """Index-level view of a finite deterministic system with declared tasks."""

    __slots__ = ("n_states", "action_names", "succ", "task_names", "outputs")

    def __init__(
        self,
        n_states: int,
        succ: dict[str, Sequence[int]],
        task_names: Sequence[str],
        outputs: Sequence[Sequence[int]],
    ) -> None:
        self.n_states = n_states
        self.action_names = tuple(sorted(succ))
        self.succ = {name: tuple(succ[name]) for name in self.action_names}
        self.task_names = tuple(task_names)
        self.outputs = tuple(tuple(row) for row in outputs)
        for name in self.action_names:
            if len(self.succ[name]) != n_states:
                raise ValueError("successor table for %r has wrong length" % (name,))
        for row in self.outputs:
            if len(row) != len(self.task_names):
                raise ValueError("output row has wrong arity")
        if len(self.outputs) != n_states:
            raise ValueError("outputs must cover every state")

    def output_partition(self, counter: StepCounter) -> list[int]:
        """Block id per state, blocks numbered by first occurrence."""
        seen: dict[tuple[int, ...], int] = {}
        blocks = [0] * self.n_states
        for state in range(self.n_states):
            counter.tick("state-visit")
            key = self.outputs[state]
            block = seen.get(key)
            if block is None:
                block = len(seen)
                seen[key] = block
            blocks[state] = block
        return blocks


def build_digit_system(
    digit_system: DigitWordSystem,
    tasks: Sequence[Task],
    counter: StepCounter,
) -> FiniteSystem:
    """Materialise the index-level system for the demo's digit words."""
    succ = digit_system.transition_tables(counter)
    silent = NullCounter()
    outputs = []
    counter.tick("compile-state-visit", digit_system.size * len(tasks))
    for value in range(digit_system.size):
        word = digit_system.digits(value)
        outputs.append(tuple(task.eval_word(word, silent) for task in tasks))
    return FiniteSystem(
        digit_system.size,
        succ,
        tuple(task.name for task in tasks),
        outputs,
    )


# --------------------------------------------------------------------------
# the signature oracle: bounded-depth task equivalence
# --------------------------------------------------------------------------


class SignatureOracle:
    """Bounded-depth Myhill-Nerode signatures, extended lazily.

    ``level(d)[x]`` is the class of ``x`` under "agrees with on every action
    word of length at most ``d``".  ``level(0)`` is the declared task output
    partition.  Two states are separated in ``level(d)`` exactly when some word
    of length ``<= d`` makes a declared task disagree, so the smallest such
    ``d`` is the length of a *shortest* distinguishing word.

    This is one Moore refinement round per level (see ``refine.py``); the class
    caches levels so a compile loop that asks for deeper and deeper collisions
    pays for each level exactly once.
    """

    __slots__ = ("system", "_levels", "_counts", "_saturated")

    def __init__(self, system: FiniteSystem, counter: StepCounter) -> None:
        self.system = system
        level0 = system.output_partition(counter)
        self._levels = [level0]
        self._counts = [max(level0) + 1 if level0 else 0]
        self._saturated = False

    @property
    def depth(self) -> int:
        return len(self._levels) - 1

    @property
    def saturated(self) -> bool:
        return self._saturated

    def level(self, depth: int, counter: StepCounter) -> list[int]:
        self.extend_to(depth, counter)
        index = depth if depth < len(self._levels) else len(self._levels) - 1
        return self._levels[index]

    def block_count(self, depth: int, counter: StepCounter) -> int:
        self.extend_to(depth, counter)
        index = depth if depth < len(self._counts) else len(self._counts) - 1
        return self._counts[index]

    def extend_to(self, depth: int, counter: StepCounter) -> None:
        system = self.system
        actions = system.action_names
        while not self._saturated and len(self._levels) <= depth:
            previous = self._levels[-1]
            seen: dict[tuple[int, ...], int] = {}
            nxt = [0] * system.n_states
            tables = [system.succ[name] for name in actions]
            for state in range(system.n_states):
                counter.tick("state-visit")
                counter.tick("transition-read", len(tables))
                key = (previous[state],) + tuple(previous[table[state]] for table in tables)
                block = seen.get(key)
                if block is None:
                    block = len(seen)
                    seen[key] = block
                nxt[state] = block
            if len(seen) == self._counts[-1]:
                self._saturated = True
                return
            self._levels.append(nxt)
            self._counts.append(len(seen))

    def saturate(self, counter: StepCounter) -> list[int]:
        """Extend until the level sequence stabilises; return the fixed point."""
        while not self._saturated:
            self.extend_to(len(self._levels), counter)
        return self._levels[-1]

    def split_depth(self, x: int, y: int, counter: StepCounter, max_depth: int | None = None) -> int | None:
        """Shortest distinguishing word length for ``x`` and ``y``, or ``None``.

        With ``max_depth`` set, only words of length at most ``max_depth`` are
        considered and ``None`` means "not distinguished within that bound" --
        which is not the same claim as task-equivalence.  Systems whose
        Myhill-Nerode quotient is the identity (the demo's reversal task) can
        need thousands of levels, so an unbounded call is a real cost.
        """
        if max_depth is None:
            self.saturate(counter)
        else:
            self.extend_to(max_depth, counter)
        for depth, level in enumerate(self._levels):
            if max_depth is not None and depth > max_depth:
                break
            counter.tick("class-compare")
            if level[x] != level[y]:
                return depth
        return None

    def witness_word(
        self,
        x: int,
        y: int,
        counter: StepCounter,
        max_depth: int | None = None,
    ) -> tuple[tuple[str, ...], str, int, int] | None:
        """A shortest action word plus the task that then disagrees.

        Returns ``(word, task_name, out_x, out_y)`` or ``None`` if the two
        states are not distinguished (within ``max_depth`` if given).
        """
        depth = self.split_depth(x, y, counter, max_depth)
        if depth is None:
            return None
        word: list[str] = []
        current_x, current_y = x, y
        level = depth
        system = self.system
        while level > 0:
            found = False
            for name in system.action_names:
                counter.tick("class-compare")
                table = system.succ[name]
                nx, ny = table[current_x], table[current_y]
                if self._levels[level - 1][nx] != self._levels[level - 1][ny]:
                    word.append(name)
                    current_x, current_y = nx, ny
                    found = True
                    break
            if not found:  # pragma: no cover - impossible by construction
                raise AssertionError("level sequence is inconsistent")
            level -= 1
        out_x = system.outputs[current_x]
        out_y = system.outputs[current_y]
        for index, name in enumerate(system.task_names):
            counter.tick("class-compare")
            if out_x[index] != out_y[index]:
                return tuple(word), name, out_x[index], out_y[index]
        raise AssertionError("level 0 split without a disagreeing task")  # pragma: no cover


# --------------------------------------------------------------------------
# collisions
# --------------------------------------------------------------------------


class Collision:
    """A specification of a missing distinction, not an error.

    ``x`` and ``y`` receive the same observation; applying ``word`` makes task
    ``task`` return ``out_x`` on one and ``out_y`` on the other.  ``depth`` is
    ``len(word)`` and is minimal.
    """

    __slots__ = ("x", "y", "word", "task", "out_x", "out_y", "depth")

    def __init__(self, x: int, y: int, word: tuple[str, ...], task: str, out_x: int, out_y: int) -> None:
        self.x = x
        self.y = y
        self.word = word
        self.task = task
        self.out_x = out_x
        self.out_y = out_y
        self.depth = len(word)

    def as_tuple(self) -> tuple:
        return (self.x, self.y, self.word, self.task, self.out_x, self.out_y)

    def render(self) -> str:
        word = "".join(self.word) if self.word else "(empty)"
        return "x=%d y=%d word=%s task=%s -> %d vs %d" % (
            self.x,
            self.y,
            word,
            self.task,
            self.out_x,
            self.out_y,
        )

    def __repr__(self) -> str:  # pragma: no cover - debugging aid
        return "Collision(%s)" % self.render()


def observation_blocks(
    key_of_state: Sequence[tuple[int, ...]],
    counter: StepCounter,
) -> list[int]:
    """Block id per state from precomputed observation keys."""
    seen: dict[tuple[int, ...], int] = {}
    blocks = [0] * len(key_of_state)
    for state, key in enumerate(key_of_state):
        counter.tick("state-visit")
        block = seen.get(key)
        if block is None:
            block = len(seen)
            seen[key] = block
        blocks[state] = block
    return blocks


def find_collisions(
    oracle: SignatureOracle,
    observation_block: Sequence[int],
    max_depth: int,
    limit: int,
    counter: StepCounter,
) -> tuple[Collision, ...]:
    """Find collisions of ``observation_block`` at depth at most ``max_depth``.

    Deterministic: blocks are scanned in increasing block id, states in
    increasing index, and at most ``limit`` collisions are returned.  Each
    returned collision names the *lowest-indexed* pair inside its observation
    block whose bounded-depth signatures differ.
    """
    level = oracle.level(max_depth, counter)
    representative: dict[int, tuple[int, int]] = {}
    found: list[Collision] = []
    ordered_blocks: list[int] = []
    for state, block in enumerate(observation_block):
        counter.tick("state-visit")
        signature = level[state]
        seen = representative.get(block)
        if seen is None:
            representative[block] = (state, signature)
            ordered_blocks.append(block)
            continue
        if seen[1] != signature:
            witness = oracle.witness_word(seen[0], state, counter, max_depth)
            if witness is None:  # pragma: no cover - contradicts the level split
                raise AssertionError("level split without a witness")
            word, task, out_x, out_y = witness
            found.append(Collision(seen[0], state, word, task, out_x, out_y))
            if len(found) >= limit:
                break
    return tuple(found)


def drive_states(collisions: Sequence[Collision]) -> tuple[int, ...]:
    """The states the collision finder actually looked at, deduplicated."""
    seen: dict[int, None] = {}
    for collision in collisions:
        seen[collision.x] = None
        seen[collision.y] = None
    return tuple(sorted(seen))
