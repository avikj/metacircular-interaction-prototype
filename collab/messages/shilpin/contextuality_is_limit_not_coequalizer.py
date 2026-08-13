#!/usr/bin/env python3
"""Exact smallest parity-gluing obstruction and noncontextual control."""

from itertools import product


def local_sections(edge, parity):
    i, j = edge
    return tuple({i: a, j: b} for a, b in product((0, 1), repeat=2)
                 if (a ^ b) == parity)


def global_sections(parities):
    edges = ((0, 1), (1, 2), (0, 2))
    return tuple(bits for bits in product((0, 1), repeat=3)
                 if all((bits[i] ^ bits[j]) == p
                        for (i, j), p in zip(edges, parities)))


def incidence_components():
    # Six context-local variable occurrences.  Overlap arrows identify the two
    # copies of each global variable; their set coequalizer has three classes.
    occurrences = (("01", 0), ("01", 1), ("12", 1),
                   ("12", 2), ("02", 0), ("02", 2))
    return tuple(frozenset(o for o in occurrences if o[1] == variable)
                 for variable in range(3))


def main():
    edges = ((0, 1), (1, 2), (0, 2))
    contextual = (0, 0, 1)
    assert all(len(local_sections(e, p)) == 2
               for e, p in zip(edges, contextual))
    assert len(incidence_components()) == 3
    assert global_sections(contextual) == ()

    # Hostile control: changing the last parity to the forced sum restores two
    # global sections, whose restrictions are compatible local sections.
    control = (0, 0, 0)
    assert global_sections(control) == ((0, 0, 0), (1, 1, 1))

    # Minimality inside graph parity systems: every forest is satisfiable.
    # On <=2 variables every simple constraint graph is a forest; the triangle
    # is the first cycle and odd xor around it is the first obstruction.
    for parity in (0, 1):
        assert len(global_sections((parity, 0, parity))) == 2
    print("CONTEXTUAL TRIANGLE: 3 incidence classes, 0 global sections")
    print("EVEN-PARITY CONTROL: 2 global sections")
    print("ALL EXACT GLUING CHECKS PASS")


if __name__ == "__main__":
    main()
