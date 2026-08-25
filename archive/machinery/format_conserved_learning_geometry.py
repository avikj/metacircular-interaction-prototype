"""Exact replay for notes/FORMAT_CONSERVED_LEARNING_GEOMETRY.md (cf-tessera).

Discrete information geometry on event windows: multiplicative-weights
updates with format-measurable rewards conserve within-class conditionals
exactly (rational arithmetic); outcome supervision freezes the dynamics;
the sign format induces a two-state replicator on marginals; the product
factorization (marginals x conditionals) is exact.  No floats anywhere.
"""

from fractions import Fraction


def mwu(policy, reward, beta):
    """One multiplicative-weights step: pi'_w proportional to
    pi_w * beta**reward[w].  policy: dict w -> Fraction; reward: dict
    w -> int; beta: Fraction > 1.  Exact."""
    weights = {w: p * beta ** reward[w] for w, p in policy.items()}
    z = sum(weights.values())
    return {w: x / z for w, x in weights.items()}


def marginals(policy, partition):
    """Class marginals: dict class_label -> Fraction."""
    out = {}
    for label, members in partition.items():
        out[label] = sum(policy[w] for w in members)
    return out


def conditionals(policy, partition):
    """Within-class conditionals: dict class_label -> dict w -> Fraction."""
    out = {}
    for label, members in partition.items():
        mass = sum(policy[w] for w in members)
        out[label] = {w: policy[w] / mass for w in members}
    return out


def factorize(policy, partition):
    return marginals(policy, partition), conditionals(policy, partition)


def assemble(margs, conds, partition):
    """Inverse of factorize: pi_w = m_C * pi(w|C)."""
    out = {}
    for label, members in partition.items():
        for w in members:
            out[w] = margs[label] * conds[label][w]
    return out


def uniform_policy(carrier):
    n = len(carrier)
    return {w: Fraction(1, n) for w in carrier}


def partition_from_format(carrier, fmt):
    """Discrimination partition of a format function on the carrier."""
    out = {}
    for w in carrier:
        out.setdefault(fmt(w), []).append(w)
    return out


def class_reward(reward, partition):
    """The induced reward on classes; raises if reward is not
    format-measurable."""
    out = {}
    for label, members in partition.items():
        values = {reward[w] for w in members}
        if len(values) != 1:
            raise ValueError("reward not measurable for this format")
        out[label] = values.pop()
    return out


def kernel_basis_dimension(partition):
    """Dimension of the within-class tangent kernel: sum (|C| - 1)."""
    return sum(len(members) - 1 for members in partition.values())
