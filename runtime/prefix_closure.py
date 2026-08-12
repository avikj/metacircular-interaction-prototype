"""Exact boundary for closing a prefix under *all* certified histories.

The installed equality kernel is symmetric.  Consequently any nonempty
checked path ``a = b`` generates a distinct checked return history at ``a``
for every positive repetition count: traverse the path, traverse its reverse,
and repeat.  Thus closure under all paths landing at a prefix point is already
infinite before arithmetic constructors are considered.

This module changes the object by making that obstruction executable.  It does
not choose a quotient, a path budget, or a canonical representative: each of
those is additional policy not forced by the prefix walk.
"""

from __future__ import annotations

from typing import Iterator, Sequence, Tuple

from runtime.kernel import check as C
from runtime.execute.rewrite import reverse_path


def certified_return_paths(
    path: Sequence[C.Step], ctx: C.CheckContext
) -> Iterator[Tuple[C.Step, ...]]:
    """Enumerate infinitely many distinct checked histories at ``path``'s source.

    ``path`` must be a nonempty kernel-checked equality path.  The kth result
    has exactly ``2*k*len(path)`` top-level steps, so different results are
    distinct even when they share both endpoints.
    """
    path = tuple(path)
    if not path:
        raise ValueError("a nonempty checked path is required")
    src, dst = path[0].src, path[-1].dst
    if not C.check_path(path, src, dst, ctx):
        raise ValueError("path is not accepted by the kernel")
    loop = path + reverse_path(path)
    history: Tuple[C.Step, ...] = ()
    while True:
        history += loop
        if not C.check_path(history, src, src, ctx):
            raise AssertionError("symmetric checked path did not close")
        yield history

