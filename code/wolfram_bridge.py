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
    parser.add_argument("--trusted-code", action="store_true",
                        help="acknowledge that WL Expression/Assumptions execute arbitrary code")
    args = parser.parse_args()
    if not args.trusted_code:
        print("Refusing to execute agent-authored Wolfram Language without --trusted-code. "
              "Use an OS sandbox for autonomous requests.", file=sys.stderr)
        return 4
    executable = shutil.which("wolframscript")
    if not executable:
        print("wolframscript is not installed; Wolfram integration is optional.", file=sys.stderr)
        return 3
    request = json.loads(args.request.read_text(encoding="utf-8"))
    for key in ("Expression", "Assumptions", "Operation", "StatementHash"):
        if key not in request:
            print(f"request missing {key}", file=sys.stderr)
            return 2
    allowed_operations = {"FullSimplify", "FunctionExpand", "Reduce", "Resolve", "FindInstance"}
    if request["Operation"] not in allowed_operations:
        print("unsupported operation", file=sys.stderr)
        return 2
    if not isinstance(request["StatementHash"], str) or len(request["StatementHash"]) != 64 \
            or any(char not in "0123456789abcdef" for char in request["StatementHash"].lower()):
        print("StatementHash must be 64 hexadecimal characters", file=sys.stderr)
        return 2
    timeout = request.get("TimeConstraintSeconds", 60)
    if not isinstance(timeout, int) or not 1 <= timeout <= 300:
        print("TimeConstraintSeconds must be an integer from 1 to 300", file=sys.stderr)
        return 2
    if args.output.exists():
        print("output directory must not already exist", file=sys.stderr)
        return 2
    args.output.mkdir(parents=True)
    result = subprocess.run(
        [executable, "-file", str(PROBE), str(args.request), str(args.output)],
        capture_output=True,
        text=True,
        timeout=timeout + 30,
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
    for name in ("result.wxf", "manifest.json"):
        candidate = args.output / name
        if candidate.exists():
            envelope[name + "_sha256"] = sha256(candidate)
    manifest_path = args.output / "adapter-manifest.json"
    manifest_path.write_text(json.dumps(envelope, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(manifest_path)
    return result.returncode


if __name__ == "__main__":
    raise SystemExit(main())
