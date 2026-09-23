from pathlib import Path
import subprocess
import time
import sys

r=Path(__file__).resolve().parent
while 'SUITE COMPLETE runtime' not in (r/'runtime.log').read_text():
    time.sleep(2)
for suite,lanes in [('compiler','bend'),('checker','agda,lean,rocq,isabelle')]:
    with (r/(suite+'-remaining.log')).open('w') as log:
        rc=subprocess.run([sys.executable,str(r/'run_benchmarks.py'),suite,'--lanes',lanes],stdout=log,stderr=subprocess.STDOUT).returncode
    print(suite,'finished',rc,flush=True)
    if rc:sys.exit(rc)
print('ALL REMAINING SUITES COMPLETE',flush=True)
