#!/usr/bin/env python3
"""Verify all archived payload files against MANIFEST.json. Standard library only.
This checks integrity/availability, not mathematical truth or native formalization.
"""
from __future__ import annotations
from pathlib import Path
import hashlib,json,sys
root=Path(__file__).resolve().parents[1]
manifest_path=root/'MANIFEST.json'
if not manifest_path.is_file():
    raise SystemExit('Missing MANIFEST.json; bundle incomplete or not yet finalized.')
man=json.loads(manifest_path.read_text())
fail=[]
for e in man['files']:
    p=(root/e['path']).resolve()
    if not p.is_relative_to(root.resolve()):
        fail.append((e['path'],'unsafe relative path')); continue
    if not p.is_file():fail.append((e['path'],'missing')); continue
    data=p.read_bytes()
    if len(data)!=e['bytes']:fail.append((e['path'],'size mismatch'))
    if hashlib.sha256(data).hexdigest()!=e['sha256']:fail.append((e['path'],'SHA256 mismatch'))
if fail:
    print(json.dumps({'verified':False,'errors':fail},indent=2));sys.exit(1)
print(f"Integrity verified: {len(man['files'])} payload files, SHA-256 and sizes match.")
print('This is an archive integrity result, not an Agda/Lean/Yantra or mathematical proof verdict.')
