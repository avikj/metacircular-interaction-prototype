"""Finite exact criterion for contracting an intervention-bearing process."""

from collections import defaultdict


def response_functions(response_table):
    rows = tuple(tuple(row) for row in response_table)
    if rows and any(len(row) != len(rows[0]) for row in rows):
        raise ValueError("response table must be rectangular")
    return rows


def erased_port_preservable(endpoint, response_table):
    rows = response_functions(response_table)
    if len(endpoint) != len(rows):
        raise ValueError("endpoint and response table must share a domain")
    value_by_endpoint = {}
    for y, row in zip(endpoint, rows):
        if row and any(value != row[0] for value in row):
            return False
        value = row[0] if row else ()
        if y in value_by_endpoint and value_by_endpoint[y] != value:
            return False
        value_by_endpoint[y] = value
    return True


def retained_port_memory_dimension(endpoint, response_table):
    rows = response_functions(response_table)
    if len(endpoint) != len(rows):
        raise ValueError("endpoint and response table must share a domain")
    functions_by_endpoint = defaultdict(set)
    for y, row in zip(endpoint, rows):
        functions_by_endpoint[y].add(row)
    return max((len(functions) for functions in functions_by_endpoint.values()), default=0)
