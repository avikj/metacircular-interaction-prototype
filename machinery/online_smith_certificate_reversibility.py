"""Exact separation of Smith output records from discarded process memory."""

from collections import Counter

from smith_quotient_memory_no_go import witness_matrix
from smith_residual_machine import smith_reduce


def maximum_fiber_dimension(values) -> int:
    """Minimum environment dimension for a basis map with these outputs."""
    counts = Counter(values)
    return max(counts.values(), default=0)


def first_smith_transition(quotient: int):
    """Return (source, post-state, emitted row coefficient)."""
    source = witness_matrix(quotient)
    step = smith_reduce(source).steps[0]
    return source, step.state, -step.quotient


def smith_online_profile(count: int):
    if count < 0:
        raise ValueError("count must be nonnegative")
    transitions = [first_smith_transition(q) for q in range(count)]
    posts = [post for _, post, _ in transitions]
    records = [record for _, _, record in transitions]
    pairs = list(zip(posts, records))
    return {
        "source_count": count,
        "post_image_size": len(set(posts)),
        "record_image_size": len(set(records)),
        "post_environment_dimension": maximum_fiber_dimension(posts),
        "joint_environment_dimension": maximum_fiber_dimension(pairs),
        "joint_is_injective": len(set(pairs)) == count,
    }


def clean_retained_input_map(count: int) -> bool:
    """The basis map source -> (source, record) is injective."""
    outputs = []
    for q in range(count):
        source, _, record = first_smith_transition(q)
        outputs.append((source, record))
    return len(set(outputs)) == count
