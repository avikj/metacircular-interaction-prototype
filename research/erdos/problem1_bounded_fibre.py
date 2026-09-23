#!/usr/bin/env python3
"""Run a finite Erdős Problem 1 fibre through the SAT HVM presentation.

The unbounded statement is recorded verbatim in ERDOS_PROBLEMS_FULL.md.  This
file chooses N=7 and n=3 and classifies every A subset of {1,...,7} of size 3
whose subset sums are pairwise distinct.  The generated HVM net returns the
complete satisfying fibre as #SAT masks.
"""
from __future__ import annotations

import itertools
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SAT = ROOT / "sat_fibre"
OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(SAT))
from experiment import emit
N, n = 7, 3

def distinct_subset_sums(bits: tuple[int, ...]) -> bool:
    A = [i + 1 for i, bit in enumerate(bits) if bit]
    if len(A) != n:
        return False
    sums = [sum(a for a, take in zip(A, mask) if take)
            for mask in itertools.product((0, 1), repeat=n)]
    return len(sums) == len(set(sums))

def direct_cnf() -> list[list[int]]:
    """Encode the bounded proposition structurally, without truth-table search.

    At least three selected elements: every five coordinates contain a true
    bit. At most three: every four coordinates contain a false bit. For three
    selected positive integers, subset-sum injectivity is exactly the absence
    of a+b=c, so forbid each such triple directly.
    """
    clauses: list[list[int]] = []
    for five in itertools.combinations(range(1, N + 1), 5):
        clauses.append(list(five))
    for four in itertools.combinations(range(1, N + 1), 4):
        clauses.append([-i for i in four])
    for a in range(1, N + 1):
        for b in range(a + 1, N + 1):
            c = a + b
            if c <= N:
                clauses.append([-a, -b, -c])
    return clauses

def main() -> None:
    rows = list(itertools.product((0, 1), repeat=N))
    good = [bits for bits in rows if distinct_subset_sums(bits)]
    cnf = direct_cnf()
    hvm = OUT / "problem1_N7_n3_models.hvm4"
    log = OUT / "problem1_N7_n3_models.log"
    receipt = OUT / "problem1_N7_n3_fibre.json"
    hvm.write_text(emit(N, cnf, "models"), encoding="utf-8")
    hvm_bin = Path(__file__).resolve().parents[1] / "biology_exact/build/toolchain/hvm4"
    run = subprocess.run([str(hvm_bin), str(hvm), "-s", "-C"],
                         check=True, text=True, capture_output=True)
    log.write_text(run.stdout, encoding="utf-8")
    actual = sorted(int(x) for x in re.findall(r"#SAT\{(\d+)\}", run.stdout))
    expected = sorted(sum(bit << i for i, bit in enumerate(bits)) for bits in good)
    assert actual == expected, (actual, expected)
    stats = re.search(r"Itrs: (\d+).*?Heap: (\d+)", run.stdout, re.S)
    result = {
        "problem": 1,
        "bounded_instance": {"N": N, "n": n},
        "proposition": "A subset of {1,...,7} has cardinality 3 and pairwise-distinct subset sums",
        "variables": [f"x{i}" for i in range(1, N + 1)],
        "fibre_masks": actual,
        "fibre_subsets": [[i + 1 for i, bit in enumerate(bits) if bit]
                          for bits in rows if bits in good],
        "interactions": int(stats.group(1)) if stats else None,
        "heap_nodes": int(stats.group(2)) if stats else None,
        "hvm": str(hvm),
    }
    receipt.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))

if __name__ == "__main__":
    main()
