"""Sharp relation between context-basis size and predictive memory dimension."""

from itertools import product

from compositional_crystal import Operation, crystallize_algebra


def coordinate_crystal(alphabet_size: int, coordinate_count: int):
    if alphabet_size < 1:
        raise ValueError("alphabet_size must be positive")
    if coordinate_count < 1:
        raise ValueError("coordinate_count must be positive")
    alphabet = tuple(range(alphabet_size))
    elements = tuple(product(alphabet, repeat=coordinate_count))
    operations = []
    for index in range(1, coordinate_count):
        table = {}
        for element in elements:
            swapped = list(element)
            swapped[0], swapped[index] = swapped[index], swapped[0]
            table[(element,)] = tuple(swapped)
        operations.append(Operation(f"swap0{index}", 1, table))
    observation = {element: element[0] for element in elements}
    return crystallize_algebra(elements, operations, observation)


def response_capacity_bound(alphabet_size: int, context_count: int) -> int:
    if alphabet_size < 1 or context_count < 0:
        raise ValueError("invalid response parameters")
    return alphabet_size ** context_count


def exact_memory_dimension(crystal) -> int:
    """Exact classical / zero-error quantum predictive dimension."""
    return len(crystal.fibers)


def profile(alphabet_size: int, coordinate_count: int):
    crystal = coordinate_crystal(alphabet_size, coordinate_count)
    context_dimension = len(crystal.separating_contexts)
    memory_dimension = exact_memory_dimension(crystal)
    return {
        "context_dimension": context_dimension,
        "memory_dimension": memory_dimension,
        "capacity_bound": response_capacity_bound(alphabet_size, context_dimension),
        "fiber_count": len(crystal.fibers),
    }
