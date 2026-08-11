#!/usr/bin/env python3
"""Exclude degree-nine prime-prefix factors for every real cutoff X >= 2.

This fail-closed wrapper rebuilds the complete chain in fresh temporary state:

1. exp37: proved coefficient/Graeffe box and 441-shard unit-resultant census;
2. exp41: exact Sturm/Routh, strict radius-two, and irreducibility partition;
3. exp42: exact prefix resultants and odd-degree negative-root tail bounds.

The proof is in ``notes/NONIC_OBSTRUCTION.md``.  Floating point is used only
inside display-only elapsed-time and margin fields of the component ledgers.
"""

from __future__ import annotations

if not __debug__:
    raise RuntimeError("exp44 is an exact certificate and must not run under python -O")

import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
from time import perf_counter


ROOT = Path(__file__).resolve().parents[1]
CODE = ROOT / "code"


EXPECTED_EXP37_TOTALS = {
    "endpoint": 82_823,
    "cd": 830_998_061,
    "cdf_raw": 191_960_552_091,
    "eliminated": 5_956_908_483,
    "scalar": 835_048_914,
    "graeffe": 226_514_912,
    "unit": 22_077,
}
EXPECTED_EXP37_DIGEST = "ce9a01ba00db63b6a55b03348d68d4c1e7463c2a7a021077618b83f4bca415d9"
EXPECTED_STRICT_DIGEST = "6a10b7a45616332efb7b51aee6ec51e65c7b6f412e0b2b3770f63f3264c68c2b"
EXPECTED_IRREDUCIBLE_DIGEST = "96b2c779d6b9d020216e84c7dcbba904b4d8c9eb9851e72e3922a7062bd594af"
EXPECTED_TAIL_COUNTS = {
    "13": 10,
    "17": 137,
    "19": 127,
    "23": 345,
    "29": 78,
    "31": 43,
    "37": 12,
    "41": 3,
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run_stage(command: list[str]) -> None:
    process = subprocess.run(command, text=True, capture_output=True)
    if process.returncode != 0:
        sys.stderr.write(process.stdout)
        sys.stderr.write(process.stderr)
        raise RuntimeError(f"stage failed: {' '.join(command)}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--workers", type=int, default=8)
    args = parser.parse_args()
    assert args.workers > 0
    start = perf_counter()

    with tempfile.TemporaryDirectory(prefix="exp44-nonic-certificate-") as name:
        directory = Path(name)
        checkpoints = directory / "exp37-shards"
        exp37_ledger = directory / "exp37.json"
        exp41_ledger = directory / "exp41.json"
        exp42_ledger = directory / "exp42.json"

        run_stage([
            sys.executable,
            str(CODE / "exp37_nonic_discovery.py"),
            "--all",
            "--workers", str(args.workers),
            "--checkpoint-dir", str(checkpoints),
            "--ledger-out", str(exp37_ledger),
        ])
        run_stage([
            sys.executable,
            str(CODE / "exp41_nonic_postcensus.py"),
            "--checkpoint-dir", str(checkpoints),
            "--ledger-out", str(exp41_ledger),
        ])
        run_stage([
            sys.executable,
            str(CODE / "exp42_nonic_tail_discovery.py"),
            "--postcensus-ledger", str(exp41_ledger),
            "--ledger-out", str(exp42_ledger),
        ])

        census = json.loads(exp37_ledger.read_text(encoding="utf-8"))
        postcensus = json.loads(exp41_ledger.read_text(encoding="utf-8"))
        tail = json.loads(exp42_ledger.read_text(encoding="utf-8"))

    assert census["totals"] == EXPECTED_EXP37_TOTALS
    assert census["candidate_sha256"] == EXPECTED_EXP37_DIGEST
    assert census["shard_count"] == 441
    assert postcensus["stages"]["strict_radius_two"] == {
        "count": 767,
        "sha256": EXPECTED_STRICT_DIGEST,
    }
    assert postcensus["stages"]["finite_field_irreducible"]["count"] == 754
    assert postcensus["stages"]["explicitly_reducible"]["count"] == 12
    assert postcensus["stages"]["cohn_prime_value_witness"]["count"] == 1
    assert postcensus["stages"]["irreducibility_unresolved_after_all_witnesses"]["count"] == 0
    assert tail["input_count"] == 755
    assert tail["input_sha256"] == EXPECTED_IRREDUCIBLE_DIGEST
    assert tail["selected_by_cutoff"] == EXPECTED_TAIL_COUNTS
    assert tail["selected_count"] == 755
    assert tail["resultants_checked"] == 3_556
    assert not tail["prefix_divisors"] and not tail["failures"]
    numerator, denominator = tail["minimum_margin"]
    assert numerator > 0 and denominator > 0

    sources = (
        "exp37_nonic_discovery.py",
        "exp37_nonic_enumerator.cpp",
        "exp37_nonic_bounds.hpp",
        "exp41_nonic_postcensus.py",
        "exp42_nonic_tail_discovery.py",
        "exact_polynomial.py",
    )
    provenance = {source: sha256(CODE / source) for source in sources}
    provenance["nonic-graeffe-exp37.json"] = sha256(
        ROOT / "machinery" / "specs" / "nonic-graeffe-exp37.json"
    )
    provenance["nonic-prime-prefix.json"] = sha256(
        ROOT / "machinery" / "specs" / "nonic-prime-prefix.json"
    )

    print("integrated nonic certificate: PASS")
    print(f"fresh exp37 totals: {EXPECTED_EXP37_TOTALS}")
    print("postcensus partition: 767 = 754 modular + 12 reducible + 1 Cohn")
    print(f"tail cutoff census: {EXPECTED_TAIL_COUNTS}")
    print(f"source provenance: {json.dumps(provenance, sort_keys=True)}")
    print(f"elapsed seconds display only: {perf_counter() - start:.6f}")


if __name__ == "__main__":
    main()
