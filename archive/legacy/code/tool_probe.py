#!/usr/bin/env python3
"""Inventory optional mathematical engines without making them dependencies.

The discovery loop may exploit any available engine, but certificate manifests
must name the engine/version and an independent checker.  This probe emits a
stable JSON capability report suitable for attaching to a run manifest.
"""

from __future__ import annotations

import importlib.util
import json
import platform
import shutil
import subprocess
import sys


EXECUTABLES = {
    "wolframscript": ["wolframscript", "-version"],
    "WolframKernel": ["WolframKernel", "-version"],
    "lean": ["lean", "--version"],
    "lake": ["lake", "--version"],
    "sage": ["sage", "--version"],
    "gp": ["gp", "--version"],
    "Singular": ["Singular", "--version"],
    "M2": ["M2", "--version"],
    "gap": ["gap", "-h"],
    "z3": ["z3", "--version"],
    "cvc5": ["cvc5", "--version"],
    "vampire": ["vampire", "--version"],
}

PYTHON_MODULES = (
    "sympy",
    "flint",
    "cypari2",
    "z3",
    "cvc5",
    "wolframclient",
    "mpmath",
    "numpy",
    "scipy",
)


def executable_report(name: str, command: list[str]) -> dict[str, object]:
    path = shutil.which(name)
    if not path:
        return {"available": False}
    try:
        result = subprocess.run(command, capture_output=True, text=True, timeout=8, check=False)
        output = (result.stdout or result.stderr).strip().splitlines()
        version = output[0][:500] if output else "present; version command silent"
        return {"available": True, "path": path, "version": version, "exit_code": result.returncode}
    except (OSError, subprocess.TimeoutExpired) as error:
        return {"available": True, "path": path, "probe_error": str(error)}


def main() -> int:
    report = {
        "python": sys.version.splitlines()[0],
        "platform": platform.platform(),
        "executables": {name: executable_report(name, command)
                        for name, command in EXECUTABLES.items()},
        "python_modules": {name: importlib.util.find_spec(name) is not None
                           for name in PYTHON_MODULES},
    }
    print(json.dumps(report, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
