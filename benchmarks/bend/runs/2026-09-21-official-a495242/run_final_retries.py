from pathlib import Path
import subprocess
import time
import sys

r=Path(__file__).resolve().parent
while 'ALL REMAINING SUITES COMPLETE' not in (r/'finish.log').read_text():
    time.sleep(2)
steps=[('compiler-retry',['compiler','--lanes','build-only']),
       ('rocq-retry',['checker','--lanes','rocq','--only','defs_12800,generics_3200'])]
for name,args in steps:
    with (r/(name+'.log')).open('w') as log:
        rc=subprocess.run([sys.executable,str(r/'run_benchmarks.py'),*args],stdout=log,stderr=subprocess.STDOUT).returncode
    print(name,'finished',rc,flush=True)
    if rc:sys.exit(rc)
print('FINAL RETRIES COMPLETE',flush=True)
