"""What a noncommuting observation pair determines without another target."""
import sys
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/"collab/messages/shilpin"))
from equitable_lens_repair import coarsest_equitable_repair
from lens_repair import canonical, commutes


def generated_repairs(pi,sigma):
    """The ordered pair generates both task-relative canonical repairs."""
    pi=canonical(pi); sigma=canonical(sigma)
    return (coarsest_equitable_repair(pi,sigma),
            coarsest_equitable_repair(sigma,pi))


def formation_obligation(pi,sigma):
    """Noncommutation itself generates a repair problem, not its orientation."""
    if commutes(pi,sigma): return ()
    a,b=generated_repairs(pi,sigma)
    return (a,) if a==b else (a,b)


if __name__ == "__main__":
    p=(0,0,0,0,1); s=(0,0,1,2,0)
    print({"commutes":commutes(p,s),"repairs":formation_obligation(p,s)})

