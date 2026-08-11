#!/usr/bin/env python3
"""Run the optional Wolfram discovery probe with provenance hashing.

This adapter never certifies a claim.  It packages exact request/response bytes
so a builder or breaker can attach them to a discovery packet and nominate an
independent verifier.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PROBE = ROOT / "code" / "wolfram_probe.wls"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("request", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    executable = shutil.which("wolframscript")
    if not executable:
        print("wolframscript is not installed; Wolfram integration is optional.", file=sys.stderr)
        return 3
    request = json.loads(args.request.read_text(encoding="utf-8"))
    for key in ("Expression", "Assumptions", "Operation", "StatementHash"):
        if key not in request:
            print(f"request missing {key}", file=sys.stderr)
            return 2
    args.output.mkdir(parents=True, exist_ok=True)
    result = subprocess.run(
        [executable, "-file", str(PROBE), str(args.request), str(args.output)],
        capture_output=True,
        text=True,
        timeout=int(request.get("TimeConstraintSeconds", 60)) + 30,
        check=False,
    )
    envelope = {
        "authority": "discovery-only",
        "request": str(args.request),
        "request_sha256": sha256(args.request),
        "probe_sha256": sha256(PROBE),
        "exit_code": result.returncode,
        "stdout": result.stdout,
        "stderr": result.stderr,
    }
    manifest_path = args.output / "adapter-manifest.json"
    manifest_path.write_text(json.dumps(envelope, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(manifest_path)
    return result.returncode


if __name__ == "__main__":
    raise SystemExit(main())
